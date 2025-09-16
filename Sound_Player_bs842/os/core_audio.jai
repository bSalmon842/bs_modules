
#scope_file

#import "macos";

log_error :: (err: OSStatus) -> bool {
    if err == noErr then return false;

    log_error("%", err);
    return true;
}

render_proc :: (inRefCon: *void, ioActionFlags: *AudioUnitRenderActionFlags, inTimeStamp: *AudioTimeStamp, inBusNumber: u32, inNumberFrames: u32, ioData: *AudioBufferList) -> OSStatus #c_call {
    push_context {
        lock(*ring_buffer.mutex);
        defer unlock(*ring_buffer.mutex);

        read_cursor  := ring_buffer.read_cursor;
        write_cursor := ring_buffer.write_cursor;


        if is_empty(ring_buffer) return noErr;

        in_num_bytes := (cast(s32)inNumberFrames) * BYTES_PER_FRAME;

        bytes_to_write := min(in_num_bytes, cast(s32) available_bytes(ring_buffer));

        r0, r1 := get_readable_regions(ring_buffer, bytes_to_write);

        data := cast(*u8)ioData.mBuffers.data[0].mData;
        memcpy(data, r0.data, r0.count);
        memcpy(data + r0.count, r1.data, r1.count);

        ring_buffer.read_cursor += r0.count + r1.count;
        ring_buffer.read_cursor = ring_buffer.read_cursor % ring_buffer.data.count;
        return noErr;
    }
}

BYTES_PER_FRAME :: 4;

Ring_Buffer :: struct {
    mutex: Mutex;
    data: string;
    write_cursor: s64;
    read_cursor: s64;
}

available_bytes :: (using rb: Ring_Buffer) -> s64 {
    if write_cursor >= read_cursor {
        return (read_cursor + (data.count - write_cursor)) - 2;
    } else {
        return (read_cursor - write_cursor) - 2;
    }
}

used_bytes :: (using rb: Ring_Buffer) -> s64 {
    return (data.count - 2) - available_bytes(rb);
}

is_full :: (using rb: Ring_Buffer) -> bool {
    return available_bytes(rb) <= 0;
}

is_empty :: (using rb: Ring_Buffer) -> bool {
    return available_bytes(rb) == (data.count - 2);
}

create_ring_buffer :: (size_in_bytes: s32) -> Ring_Buffer {
    buf: Ring_Buffer;
    init(*buf.mutex);
    buf.data.count = size_in_bytes;
    buf.data.data = alloc(size_in_bytes);
    memset(buf.data.data, 0, buf.data.count);
    return buf;
}

get_writable_regions :: (using rb: Ring_Buffer, requested_num_bytes: s64) -> region0: string, region1: string {
    r0, r1: string;
    bytes_to_get := min(requested_num_bytes, available_bytes(rb));

    if write_cursor >= read_cursor {
        r0.data = data.data + write_cursor;
        r0.count = min(data.count - write_cursor, bytes_to_get);

        r1.data = data.data;
        r1.count = bytes_to_get - r0.count;
    } else {
        r0.data = data.data + write_cursor;
        r0.count = bytes_to_get;
    }

    return r0, r1;
}

get_readable_regions :: (using rb: Ring_Buffer, requested_num_bytes: s64) -> region0: string, region1: string {
    r0: string;
    r1: string;

    bytes_to_get := min(requested_num_bytes, used_bytes(rb));

    if read_cursor > write_cursor {
        r0.data = data.data + read_cursor;
        r0.count = min(data.count - read_cursor, bytes_to_get);

        r1.data = data.data;
        r1.count = bytes_to_get - r0.count;
    } else {
        r0.data = data.data + read_cursor;
        r0.count = bytes_to_get;
    }

    return r0, r1;
}

advance_write_cursor_bytes :: (using rb: *Ring_Buffer, num_bytes: s64) {
    assert(num_bytes <= available_bytes(<<rb));

    if write_cursor >= read_cursor {
        write_cursor = (write_cursor + num_bytes) % data.count;
    } else {
        write_cursor += num_bytes;
    }
}

#scope_export

OUTPUT_SAMPLING_RATE :: 44100;
FILL_BUFFER_SIZE_IN_SAMPLES  :: 24000;  // @Cleanup: When we can do constexpr math, this should be: OUTPUT_SAMPLING_RATE / 2 or something like that.

backend_init :: (config: Sound_Player_Config) -> Backend_Properties {
    // TODO: maybe check kAudioUnitProperty_SupportedNumChannels ?
    max_channels: u32 = 2;

    // @Cutnpaste from the ALSA stuff
    if max_channels == 8 { // 7.1 wide, note surround71 devices may have only 6 channels
        array_add(*channel_names, "Front Left");
        array_add(*channel_names, "Front Right");
        array_add(*channel_names, "Center");
        array_add(*channel_names, "Subwoofer");
        array_add(*channel_names, "Rear Left");
        array_add(*channel_names, "Rear Right");
        array_add(*channel_names, "Extend Left");
        array_add(*channel_names, "Extend Right");
    } else if max_channels == 6 {
        array_add(*channel_names, "Front Left");
        array_add(*channel_names, "Front Right");
        array_add(*channel_names, "Center");
        array_add(*channel_names, "Subwoofer");
        array_add(*channel_names, "Rear Left");
        array_add(*channel_names, "Rear Right");
    } else {
        array_add(*channel_names, "Left");
        array_add(*channel_names, "Right");
    }

    num_channels = cast(s32) max_channels;

    outputcd: AudioComponentDescription;
    outputcd.componentType = kAudioUnitType_Output;
    outputcd.componentSubType = kAudioUnitSubType_DefaultOutput;
    outputcd.componentManufacturer = kAudioUnitManufacturer_Apple;

    comp := AudioComponentFindNext(null, *outputcd);
    if comp == null {
        log_error("Could not find match for output AudioUnit.\n");
        return .{};
    }

    status := AudioComponentInstanceNew(comp, *output_unit);
    if log_error(status) then return .{};

    input: AURenderCallbackStruct;
    input.inputProc = render_proc;
    status = AudioUnitSetProperty(output_unit, kAudioUnitProperty_SetRenderCallback, kAudioUnitScope_Input, 0, *input, size_of(type_of(input)));
    if log_error(status) then return .{};

    bd: AudioStreamBasicDescription;
    bd.mSampleRate = OUTPUT_SAMPLING_RATE;
    bd.mFormatID = kAudioFormatLinearPCM;
    bd.mFormatFlags = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
    bd.mBytesPerPacket = 4;
    bd.mFramesPerPacket = 1;
    bd.mBytesPerFrame = BYTES_PER_FRAME;
    bd.mChannelsPerFrame = xx num_channels;
    bd.mBitsPerChannel = 16;

    status = AudioUnitSetProperty(output_unit, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Input, 0, *bd, size_of(type_of(bd)));
    if log_error(status) then return .{};

    status = AudioUnitInitialize(output_unit);
    if log_error(status) then return .{};

    ring_buffer = create_ring_buffer(cast(s32) (FILL_BUFFER_SIZE_IN_SAMPLES * num_channels * size_of(s16)));

    result: Backend_Properties;
    result.num_channels  = num_channels;
    result.channel_names = channel_names;
    result.output_sampling_rate = OUTPUT_SAMPLING_RATE;
    result.initted       = true;

    return result;
}

backend_shutdown :: () {
    AudioOutputUnitStop(output_unit);
    AudioUnitUninitialize(output_unit);
    AudioComponentInstanceDispose(output_unit);
}

backend_needs_async_update_from_main_thread :: () -> bool {
    return true;
}

backend_play :: () {
    status := AudioOutputUnitStart(output_unit);
    // if status == noErr then playing = true;
}

get_bytes_between :: (front: $T, rear: T, buffer_len: T) -> T {
    if front >= rear return front - rear;
    return (buffer_len - rear) + front;
}

backend_count_buffered_bytes :: () -> (currently_buffered: s64, minimum_prebuffered_bytes: s64) {
    write_cursor := ring_buffer.write_cursor;
    read_cursor := ring_buffer.read_cursor;

    if is_full(ring_buffer) then return 0, 0;

    minimum_prebuffered_bytes := 1024*8; // arbitrarily chosen

    return used_bytes(ring_buffer), minimum_prebuffered_bytes;
}

backend_lock_fill_regions :: (bytes_to_lock: s64) -> Fill_Region_Result, bool {
    result: Fill_Region_Result;
    lock(*ring_buffer.mutex);

    result.buffer0, result.buffer1 = get_writable_regions(ring_buffer, bytes_to_lock);

    // print("%, %\n", result, bytes_to_lock);

    return result, true;
}

backend_release_fill_regions :: (result: Fill_Region_Result) {
    s0 := result.buffer0;
    s1 := result.buffer1;

    advance_write_cursor_bytes(*ring_buffer, s0.count + s1.count);

    my_write_cursor := ring_buffer.write_cursor;
    assert(my_write_cursor >= 0);
    assert(my_write_cursor < ring_buffer.data.count);
    assert((my_write_cursor % 4) == 0);
    // print("<<< Fill regions release\n");


    unlock(*ring_buffer.mutex);
}

backend_get_devices :: () -> [] Output_Device {
    return .[];  // @Incomplete
}

#scope_file

// Core Audio

AudioFormatID :: u32;
AudioFilePropertyID :: u32;
AudioFileTypeID :: u32;

AudioStreamBasicDescription :: struct {
    mSampleRate: float64;
    mFormatID: AudioFormatID;
    mFormatFlags: AudioFormatFlags;
    mBytesPerPacket: u32;
    mFramesPerPacket: u32;
    mBytesPerFrame: u32;
    mChannelsPerFrame: u32;
    mBitsPerChannel: u32;
    mReserved: u32;
}

using AudioFormatFlags :: enum u32 {
    kAudioFormatFlagIsFloat                     :: (1 << 0);
    kAudioFormatFlagIsBigEndian                 :: (1 << 1);
    kAudioFormatFlagIsSignedInteger             :: (1 << 2);
    kAudioFormatFlagIsPacked                    :: (1 << 3);
    kAudioFormatFlagIsAlignedHigh               :: (1 << 4);
    kAudioFormatFlagIsNonInterleaved            :: (1 << 5);
    kAudioFormatFlagIsNonMixable                :: (1 << 6);
    kAudioFormatFlagsAreAllClear                :: 0x80000000;

    kLinearPCMFormatFlagIsFloat                 :: kAudioFormatFlagIsFloat;
    kLinearPCMFormatFlagIsBigEndian             :: kAudioFormatFlagIsBigEndian;
    kLinearPCMFormatFlagIsSignedInteger         :: kAudioFormatFlagIsSignedInteger;
    kLinearPCMFormatFlagIsPacked                :: kAudioFormatFlagIsPacked;
    kLinearPCMFormatFlagIsAlignedHigh           :: kAudioFormatFlagIsAlignedHigh;
    kLinearPCMFormatFlagIsNonInterleaved        :: kAudioFormatFlagIsNonInterleaved;
    kLinearPCMFormatFlagIsNonMixable            :: kAudioFormatFlagIsNonMixable;
    kLinearPCMFormatFlagsSampleFractionShift    :: 7;
    kLinearPCMFormatFlagsSampleFractionMask     :: (0x3F << kLinearPCMFormatFlagsSampleFractionShift);
    kLinearPCMFormatFlagsAreAllClear            :: kAudioFormatFlagsAreAllClear;

    kAppleLosslessFormatFlag_16BitSourceData    :: 1;
    kAppleLosslessFormatFlag_20BitSourceData    :: 2;
    kAppleLosslessFormatFlag_24BitSourceData    :: 3;
    kAppleLosslessFormatFlag_32BitSourceData    :: 4;
}

kAudioFormatLinearPCM               :AudioFormatID: #run store_in_integer("lpcm");
kAudioFormatAC3                     :AudioFormatID: #run store_in_integer("ac-3");
kAudioFormat60958AC3                :AudioFormatID: #run store_in_integer("cac3");
kAudioFormatAppleIMA4               :AudioFormatID: #run store_in_integer("ima4");
kAudioFormatMPEG4AAC                :AudioFormatID: #run store_in_integer("aac ");
kAudioFormatMPEG4CELP               :AudioFormatID: #run store_in_integer("celp");
kAudioFormatMPEG4HVXC               :AudioFormatID: #run store_in_integer("hvxc");
kAudioFormatMPEG4TwinVQ             :AudioFormatID: #run store_in_integer("twvq");
kAudioFormatMACE3                   :AudioFormatID: #run store_in_integer("MAC3");
kAudioFormatMACE6                   :AudioFormatID: #run store_in_integer("MAC6");
kAudioFormatULaw                    :AudioFormatID: #run store_in_integer("ulaw");
kAudioFormatALaw                    :AudioFormatID: #run store_in_integer("alaw");
kAudioFormatQDesign                 :AudioFormatID: #run store_in_integer("QDMC");
kAudioFormatQDesign2                :AudioFormatID: #run store_in_integer("QDM2");
kAudioFormatQUALCOMM                :AudioFormatID: #run store_in_integer("Qclp");
kAudioFormatMPEGLayer1              :AudioFormatID: #run store_in_integer(".mp1");
kAudioFormatMPEGLayer2              :AudioFormatID: #run store_in_integer(".mp2");
kAudioFormatMPEGLayer3              :AudioFormatID: #run store_in_integer(".mp3");
kAudioFormatTimeCode                :AudioFormatID: #run store_in_integer("time");
kAudioFormatMIDIStream              :AudioFormatID: #run store_in_integer("midi");
kAudioFormatParameterValueStream    :AudioFormatID: #run store_in_integer("apvs");
kAudioFormatAppleLossless           :AudioFormatID: #run store_in_integer("alac");
kAudioFormatMPEG4AAC_HE             :AudioFormatID: #run store_in_integer("aach");
kAudioFormatMPEG4AAC_LD             :AudioFormatID: #run store_in_integer("aacl");
kAudioFormatMPEG4AAC_ELD            :AudioFormatID: #run store_in_integer("aace");
kAudioFormatMPEG4AAC_ELD_SBR        :AudioFormatID: #run store_in_integer("aacf");
kAudioFormatMPEG4AAC_ELD_V2         :AudioFormatID: #run store_in_integer("aacg");
kAudioFormatMPEG4AAC_HE_V2          :AudioFormatID: #run store_in_integer("aacp");
kAudioFormatMPEG4AAC_Spatial        :AudioFormatID: #run store_in_integer("aacs");
kAudioFormatAMR                     :AudioFormatID: #run store_in_integer("samr");
kAudioFormatAMR_WB                  :AudioFormatID: #run store_in_integer("sawb");
kAudioFormatAudible                 :AudioFormatID: #run store_in_integer("AUDB");
kAudioFormatiLBC                    :AudioFormatID: #run store_in_integer("ilbc");
kAudioFormatDVIIntelIMA             :AudioFormatID: 0x6D730011;
kAudioFormatMicrosoftGSM            :AudioFormatID: 0x6D730031;
kAudioFormatAES3                    :AudioFormatID: #run store_in_integer("aes3");
kAudioFormatEnhancedAC3             :AudioFormatID: #run store_in_integer("ec-3");
kAudioFormatFLAC                    :AudioFormatID: #run store_in_integer("flac");
kAudioFormatOpus                    :AudioFormatID: #run store_in_integer("opus");

OpaqueAudioFileID :: struct {}

AudioFileID :: *OpaqueAudioFileID;

using AudioFilePermissions :: enum s8 {
    kAudioFileReadPermission      :: 0x01;
    kAudioFileWritePermission     :: 0x02;
    kAudioFileReadWritePermission :: 0x03;
}

AudioFileGetPropertyInfo :: (inAudioFile: AudioFileID, inPropertyID: AudioFilePropertyID, outDataSize: *u32, isWritable: *u32) -> OSStatus #foreign CoreAudio;
AudioFileGetProperty :: (inAudioFile: AudioFileID, inPropertyID: AudioFilePropertyID, ioDataSize: *u32, outPropertyData: *void) -> OSStatus #foreign CoreAudio;

// AudioToolbox

AUNode :: s32;

OpaqueAUGraph :: struct {}
AUGraph:: *OpaqueAUGraph;

using AudioBytePacketTranslationFlags :: enum_flags u32 {
    kBytePacketTranslationFlag_IsEstimate :: 1;
}

AudioFramePacketTranslation :: struct {
    mFrame: s64;
    mPacket: s64;
    mFrameOffsetInPacket: u32;
}

AudioBytePacketTranslation :: struct {
    mByte: s64;
    mPacket: s64;
    mByteOffsetInPacket: u32;
    mFlags: AudioBytePacketTranslationFlags;
}

AudioFilePacketTableInfo :: struct {
    mNumberValidFrames: s64;
    mPrimingFrames: s32;
    mRemainderFrames: s32;
}

/*
kAFInfoDictionary_Album                         :: "album";
kAFInfoDictionary_ApproximateDurationInSeconds  :: "approximate duration in seconds";
kAFInfoDictionary_Artist                        :: "artist";
kAFInfoDictionary_ChannelLayout                 :: "channel layout";
kAFInfoDictionary_Comments                      :: "comments";
kAFInfoDictionary_Composer                      :: "composer";
kAFInfoDictionary_Copyright                     :: "copyright";
kAFInfoDictionary_EncodingApplication           :: "encoding application";
kAFInfoDictionary_Genre                         :: "genre";
kAFInfoDictionary_ISRC                          :: "ISRC";
kAFInfoDictionary_KeySignature                  :: "key signature";
kAFInfoDictionary_Lyricist                      :: "lyricist";
kAFInfoDictionary_NominalBitRate                :: "nominal bit rate";
kAFInfoDictionary_RecordedDate                  :: "recorded date";
kAFInfoDictionary_SourceBitDepth                :: "source bit depth";
kAFInfoDictionary_SourceEncoder                 :: "source encoder";
kAFInfoDictionary_SubTitle                      :: "subtitle";
kAFInfoDictionary_Tempo                         :: "tempo";
kAFInfoDictionary_TimeSignature                 :: "time signature";
kAFInfoDictionary_Title                         :: "title";
kAFInfoDictionary_TrackNumber                   :: "track number";
kAFInfoDictionary_Year                          :: "year";

kAudioFilePropertyFileFormat            :AudioFilePropertyID: #run store_in_integer("ffmt");
kAudioFilePropertyDataFormat            :AudioFilePropertyID: #run store_in_integer("dfmt");
kAudioFilePropertyIsOptimized           :AudioFilePropertyID: #run store_in_integer("optm");
kAudioFilePropertyMagicCookieData       :AudioFilePropertyID: #run store_in_integer("mgic");
kAudioFilePropertyAudioDataByteCount    :AudioFilePropertyID: #run store_in_integer("bcnt");
kAudioFilePropertyAudioDataPacketCount  :AudioFilePropertyID: #run store_in_integer("pcnt");
kAudioFilePropertyMaximumPacketSize     :AudioFilePropertyID: #run store_in_integer("psze");
kAudioFilePropertyDataOffset            :AudioFilePropertyID: #run store_in_integer("doff");
kAudioFilePropertyChannelLayout         :AudioFilePropertyID: #run store_in_integer("cmap");
kAudioFilePropertyDeferSizeUpdates      :AudioFilePropertyID: #run store_in_integer("dszu");
kAudioFilePropertyDataFormatName        :AudioFilePropertyID: #run store_in_integer("fnme");
kAudioFilePropertyMarkerList            :AudioFilePropertyID: #run store_in_integer("mkls");
kAudioFilePropertyRegionList            :AudioFilePropertyID: #run store_in_integer("rgls");
kAudioFilePropertyPacketToFrame         :AudioFilePropertyID: #run store_in_integer("pkfr");
kAudioFilePropertyFrameToPacket         :AudioFilePropertyID: #run store_in_integer("frpk");
kAudioFilePropertyPacketToByte          :AudioFilePropertyID: #run store_in_integer("pkby");
kAudioFilePropertyByteToPacket          :AudioFilePropertyID: #run store_in_integer("bypk");
kAudioFilePropertyChunkIDs              :AudioFilePropertyID: #run store_in_integer("chid");
kAudioFilePropertyInfoDictionary        :AudioFilePropertyID: #run store_in_integer("info");
kAudioFilePropertyPacketTableInfo       :AudioFilePropertyID: #run store_in_integer("pnfo");
kAudioFilePropertyFormatList            :AudioFilePropertyID: #run store_in_integer("flst");
kAudioFilePropertyPacketSizeUpperBound  :AudioFilePropertyID: #run store_in_integer("pkub");
kAudioFilePropertyReserveDuration       :AudioFilePropertyID: #run store_in_integer("rsrv");
kAudioFilePropertyEstimatedDuration     :AudioFilePropertyID: #run store_in_integer("edur");
kAudioFilePropertyBitRate               :AudioFilePropertyID: #run store_in_integer("brat");
kAudioFilePropertyID3Tag                :AudioFilePropertyID: #run store_in_integer("id3t");
kAudioFilePropertySourceBitDepth        :AudioFilePropertyID: #run store_in_integer("sbtd");
kAudioFilePropertyAlbumArtwork          :AudioFilePropertyID: #run store_in_integer("aart");
kAudioFilePropertyAudioTrackCount       :AudioFilePropertyID: #run store_in_integer("atct");
kAudioFilePropertyUseAudioTrack         :AudioFilePropertyID: #run store_in_integer("uatk");

kAudioFileGlobalInfo_ReadableTypes                          :AudioFilePropertyID: #run store_in_integer("afrf");
kAudioFileGlobalInfo_WritableTypes                          :AudioFilePropertyID: #run store_in_integer("afwf");
kAudioFileGlobalInfo_FileTypeName                           :AudioFilePropertyID: #run store_in_integer("ftnm");
kAudioFileGlobalInfo_AvailableStreamDescriptionsForFormat   :AudioFilePropertyID: #run store_in_integer("sdid");
kAudioFileGlobalInfo_AvailableFormatIDs                     :AudioFilePropertyID: #run store_in_integer("fmid");

kAudioFileGlobalInfo_AllExtensions                          :AudioFilePropertyID: #run store_in_integer("alxt");
kAudioFileGlobalInfo_AllHFSTypeCodes                        :AudioFilePropertyID: #run store_in_integer("ahfs");
kAudioFileGlobalInfo_AllUTIs                                :AudioFilePropertyID: #run store_in_integer("auti");
kAudioFileGlobalInfo_AllMIMETypes                           :AudioFilePropertyID: #run store_in_integer("amim");

kAudioFileGlobalInfo_ExtensionsForType                      :AudioFilePropertyID: #run store_in_integer("fext");
kAudioFileGlobalInfo_HFSTypeCodesForType                    :AudioFilePropertyID: #run store_in_integer("fhfs");
kAudioFileGlobalInfo_UTIsForType                            :AudioFilePropertyID: #run store_in_integer("futi");
kAudioFileGlobalInfo_MIMETypesForType                       :AudioFilePropertyID: #run store_in_integer("fmim");

kAudioFileGlobalInfo_TypesForMIMEType                       :AudioFilePropertyID: #run store_in_integer("tmim");
kAudioFileGlobalInfo_TypesForUTI                            :AudioFilePropertyID: #run store_in_integer("tuti");
kAudioFileGlobalInfo_TypesForHFSTypeCode                    :AudioFilePropertyID: #run store_in_integer("thfs");
kAudioFileGlobalInfo_TypesForExtension                      :AudioFilePropertyID: #run store_in_integer("text");
*/

// pack(4) ?
AudioComponentDescription :: struct {
    componentType: OSType;
    componentSubType: OSType;
    componentManufacturer: OSType;
    componentFlags: u32;
    componentFlagsMask: u32;
}

OpaqueAudioComponent :: struct {}
AudioComponent :: *OpaqueAudioComponent;

ComponentInstanceRecord :: struct {}
AudioComponentInstance :: *ComponentInstanceRecord;
AudioUnit :: AudioComponentInstance;

kAudioUnitType_Output                   :: #run store_in_integer("auou");
// kAudioUnitType_MusicDevice              :: #run store_in_integer("aumu");
// kAudioUnitType_MusicEffect              :: #run store_in_integer("aumf");
// kAudioUnitType_FormatConverter          :: #run store_in_integer("aufc");
// kAudioUnitType_Effect                   :: #run store_in_integer("aufx");
// kAudioUnitType_Mixer                    :: #run store_in_integer("aumx");
// kAudioUnitType_Panner                   :: #run store_in_integer("aupn");
// kAudioUnitType_Generator                :: #run store_in_integer("augn");
// kAudioUnitType_OfflineEffect            :: #run store_in_integer("auol");
// kAudioUnitType_MIDIProcessor            :: #run store_in_integer("aumi");

// AU_SUPPORT_INTERAPP_AUDIO :: false; // looks like this is an iOS thing
// #if AU_SUPPORT_INTERAPP_AUDIO {
//     kAudioUnitType_RemoteEffect         :: #run store_in_integer("aurx");
//     kAudioUnitType_RemoteGenerator      :: #run store_in_integer("aurg");
//     kAudioUnitType_RemoteInstrument     :: #run store_in_integer("auri");
//     kAudioUnitType_RemoteMusicEffect    :: #run store_in_integer("aurm");
// }


kAudioUnitManufacturer_Apple            :: #run store_in_integer("appl");

// kAudioUnitSubType_GenericOutput         :: #run store_in_integer("genr");
// kAudioUnitSubType_VoiceProcessingIO     :: #run store_in_integer("vpio");

// kAudioUnitSubType_HALOutput             :: #run store_in_integer("ahal");
kAudioUnitSubType_DefaultOutput         :: #run store_in_integer("def ");
// kAudioUnitSubType_SystemOutput          :: #run store_in_integer("sys ");

// kAudioUnitSubType_DLSSynth              :: #run store_in_integer("dls ");
// kAudioUnitSubType_Sampler               :: #run store_in_integer("samp");
// kAudioUnitSubType_MIDISynth             :: #run store_in_integer("msyn");

// kAudioUnitSubType_AUConverter           :: #run store_in_integer("conv");
// kAudioUnitSubType_Varispeed             :: #run store_in_integer("vari");
// kAudioUnitSubType_DeferredRenderer      :: #run store_in_integer("defr");
// kAudioUnitSubType_Splitter              :: #run store_in_integer("splt");
// kAudioUnitSubType_MultiSplitter         :: #run store_in_integer("mspl");
// kAudioUnitSubType_Merger                :: #run store_in_integer("merg");
// kAudioUnitSubType_NewTimePitch          :: #run store_in_integer("nutp");
// kAudioUnitSubType_AUiPodTimeOther       :: #run store_in_integer("ipto");
// kAudioUnitSubType_RoundTripAAC          :: #run store_in_integer("raac");

// kAudioUnitSubType_PeakLimiter           :: #run store_in_integer("lmtr");
// kAudioUnitSubType_DynamicsProcessor     :: #run store_in_integer("dcmp");
// kAudioUnitSubType_LowPassFilter         :: #run store_in_integer("lpas");
// kAudioUnitSubType_HighPassFilter        :: #run store_in_integer("hpas");
// kAudioUnitSubType_BandPassFilter        :: #run store_in_integer("bpas");
// kAudioUnitSubType_HighShelfFilter       :: #run store_in_integer("hshf");
// kAudioUnitSubType_LowShelfFilter        :: #run store_in_integer("lshf");
// kAudioUnitSubType_ParametricEQ          :: #run store_in_integer("pmeq");
// kAudioUnitSubType_Distortion            :: #run store_in_integer("dist");
// kAudioUnitSubType_Delay                 :: #run store_in_integer("dely");
// kAudioUnitSubType_SampleDelay           :: #run store_in_integer("sdly");
// kAudioUnitSubType_NBandEQ               :: #run store_in_integer("nbeq");

// kAudioUnitSubType_GraphicEQ             :: #run store_in_integer("greq");
// kAudioUnitSubType_MultiBandCompressor   :: #run store_in_integer("mcmp");
// kAudioUnitSubType_MatrixReverb          :: #run store_in_integer("mrev");
// kAudioUnitSubType_Pitch                 :: #run store_in_integer("tmpt");
// kAudioUnitSubType_AUFilter              :: #run store_in_integer("filt");
// kAudioUnitSubType_NetSend               :: #run store_in_integer("nsnd");
// kAudioUnitSubType_RogerBeep             :: #run store_in_integer("rogr");

AudioFileOpenURL :: (inFileRef: CFURLRef, inPermissions: AudioFilePermissions, inFileTypeHint: AudioFileTypeID, outAudioFile: *AudioFileID) -> OSStatus #foreign AudioToolbox;
AudioFileClose :: (inAudioFile: AudioFileID) -> OSStatus #foreign AudioToolbox;

using SMPTETimeType :: enum u32 {
    kSMPTETimeType24        :: 0;
    kSMPTETimeType25        :: 1;
    kSMPTETimeType30Drop    :: 2;
    kSMPTETimeType30        :: 3;
    kSMPTETimeType2997      :: 4;
    kSMPTETimeType2997Drop  :: 5;
    kSMPTETimeType60        :: 6;
    kSMPTETimeType5994      :: 7;
    kSMPTETimeType60Drop    :: 8;
    kSMPTETimeType5994Drop  :: 9;
    kSMPTETimeType50        :: 10;
    kSMPTETimeType2398      :: 11;
}

using SMPTETimeFlags :: enum u32 {
    kSMPTETimeUnknown   :: 0;
    kSMPTETimeValid     :: (1 << 0);
    kSMPTETimeRunning   :: (1 << 1);
}

SMPTETime :: struct {
    mSubframes: s16;
    mSubframeDivisor: s16;
    mCounter: u32;
    mType: SMPTETimeType;
    mFlags: SMPTETimeFlags;
    mHours: s16;
    mMinutes: s16;
    mSeconds: s16;
    mFrames: s16;
}

using AudioTimeStampFlags :: enum_flags u32 {
    kAudioTimeStampNothingValid         :: 0;
    kAudioTimeStampSampleTimeValid      :: (1 << 0);
    kAudioTimeStampHostTimeValid        :: (1 << 1);
    kAudioTimeStampRateScalarValid      :: (1 << 2);
    kAudioTimeStampWordClockTimeValid   :: (1 << 3);
    kAudioTimeStampSMPTETimeValid       :: (1 << 4);
    kAudioTimeStampSampleHostTimeValid  :: (kAudioTimeStampSampleTimeValid | kAudioTimeStampHostTimeValid);
}

using AudioUnitRenderActionFlags :: enum_flags u32 {
    kAudioUnitRenderAction_PreRender            :: (1 << 2);
    kAudioUnitRenderAction_PostRender           :: (1 << 3);
    kAudioUnitRenderAction_OutputIsSilence      :: (1 << 4);
    kAudioOfflineUnitRenderAction_Preflight     :: (1 << 5);
    kAudioOfflineUnitRenderAction_Render        :: (1 << 6);
    kAudioOfflineUnitRenderAction_Complete      :: (1 << 7);
    kAudioUnitRenderAction_PostRenderError      :: (1 << 8);
    kAudioUnitRenderAction_DoNotCheckRenderArgs :: (1 << 9);
}

AudioTimeStamp :: struct {
    mSampleTime: float64;
    mHostTime: u64;
    mRateScalar: float64;
    mWordClockTime: u64;
    mSMPTETime: SMPTETime;
    mFlags: AudioTimeStampFlags;
    mReserved: u32;
};

AURenderCallback :: #type (inRefCon: *void, ioActionFlags: *AudioUnitRenderActionFlags, inTimeStamp: *AudioTimeStamp, inBusNumber: u32, inNumberFrames: u32, ioData: *AudioBufferList) -> OSStatus #c_call;

AURenderCallbackStruct :: struct {
    inputProc: AURenderCallback;
    inputProcRefCon: *void;
}

AudioBuffer :: struct {
    mNumberChannels: u32;
    mDataByteSize: u32;
    mData: *void;
}

AudioBufferList :: struct {
    mNumberBuffers: u32;
    mBuffers: [1] AudioBuffer;
}

using AudioUnitPropertyID :: enum u32 {
    kAudioUnitProperty_ClassInfo                    :: 0;
    kAudioUnitProperty_MakeConnection               :: 1;
    kAudioUnitProperty_SampleRate                   :: 2;
    kAudioUnitProperty_ParameterList                :: 3;
    kAudioUnitProperty_ParameterInfo                :: 4;
    kAudioUnitProperty_CPULoad                      :: 6;
    kAudioUnitProperty_StreamFormat                 :: 8;
    kAudioUnitProperty_ElementCount                 :: 11;
    kAudioUnitProperty_Latency                      :: 12;
    kAudioUnitProperty_SupportedNumChannels         :: 13;
    kAudioUnitProperty_MaximumFramesPerSlice        :: 14;
    kAudioUnitProperty_ParameterValueStrings        :: 16;
    kAudioUnitProperty_AudioChannelLayout           :: 19;
    kAudioUnitProperty_TailTime                     :: 20;
    kAudioUnitProperty_BypassEffect                 :: 21;
    kAudioUnitProperty_LastRenderError              :: 22;
    kAudioUnitProperty_SetRenderCallback            :: 23;
    kAudioUnitProperty_FactoryPresets               :: 24;
    kAudioUnitProperty_RenderQuality                :: 26;
    kAudioUnitProperty_HostCallbacks                :: 27;
    kAudioUnitProperty_InPlaceProcessing            :: 29;
    kAudioUnitProperty_ElementName                  :: 30;
    kAudioUnitProperty_SupportedChannelLayoutTags   :: 32;
    kAudioUnitProperty_PresentPreset                :: 36;
    kAudioUnitProperty_DependentParameters          :: 45;
    kAudioUnitProperty_InputSamplesInOutput         :: 49;
    kAudioUnitProperty_ShouldAllocateBuffer         :: 51;
    kAudioUnitProperty_FrequencyResponse            :: 52;
    kAudioUnitProperty_ParameterHistoryInfo         :: 53;
    kAudioUnitProperty_NickName                     :: 54;
    kAudioUnitProperty_OfflineRender                :: 37;
    kAudioUnitProperty_ParameterIDName              :: 34;
    kAudioUnitProperty_ParameterStringFromValue     :: 33;
    kAudioUnitProperty_ParameterClumpName           :: 35;
    kAudioUnitProperty_ParameterValueFromString     :: 38;
    kAudioUnitProperty_ContextName                  :: 25;
    kAudioUnitProperty_PresentationLatency          :: 40;
    kAudioUnitProperty_ClassInfoFromDocument        :: 50;
    kAudioUnitProperty_RequestViewController        :: 56;
    kAudioUnitProperty_ParametersForOverview        :: 57;
    kAudioUnitProperty_SupportsMPE                  :: 58;

    kAudioUnitProperty_FastDispatch                 :: 5;
    kAudioUnitProperty_SetExternalBuffer            :: 15;
    kAudioUnitProperty_GetUIComponentList           :: 18;
    kAudioUnitProperty_CocoaUI                      :: 31;
    kAudioUnitProperty_IconLocation                 :: 39;
    kAudioUnitProperty_AUHostIdentifier             :: 46;

    kAudioUnitProperty_MIDIOutputCallbackInfo       :: 47;
    kAudioUnitProperty_MIDIOutputCallback           :: 48;
}

using AudioUnitScope :: enum u32 {
    kAudioUnitScope_Global      :: 0;
    kAudioUnitScope_Input       :: 1;
    kAudioUnitScope_Output      :: 2;
    kAudioUnitScope_Group       :: 3;
    kAudioUnitScope_Part        :: 4;
    kAudioUnitScope_Note        :: 5;
    kAudioUnitScope_Layer       :: 6;
    kAudioUnitScope_LayerItem   :: 7;
}


AudioUnitElement :: u32;

AudioOutputUnitStop :: (ci: AudioUnit) -> OSStatus #foreign AudioToolbox;
AudioOutputUnitStart :: (ci: AudioUnit) -> OSStatus #foreign AudioToolbox;
AudioUnitUninitialize :: (inUnit: AudioUnit) -> OSStatus #foreign AudioToolbox;
AudioUnitInitialize :: (inUnit: AudioUnit) -> OSStatus #foreign AudioToolbox;
AudioUnitSetProperty :: (inUnit: AudioUnit, inID: AudioUnitPropertyID, inScope: AudioUnitScope, inElement: AudioUnitElement, inData: *void, inDataSize: u32) -> OSStatus #foreign AudioToolbox;
AudioComponentInstanceDispose :: (inInstance: AudioComponentInstance) -> OSStatus #foreign AudioToolbox;
AudioComponentInstanceNew :: (inComponent: AudioComponent, outInstance: *AudioComponentInstance) -> OSStatus #foreign AudioToolbox;
AudioComponentFindNext :: (inComponent: AudioComponent, inDesc: *AudioComponentDescription) -> AudioComponent #foreign AudioToolbox;

// NOTE: AUGraph stuff is deprecated now in favor of AVAudioEngine.
// However, AVAudioEngine is only available since Yosemite (10.10).
AUGraphStart :: (inGraph: AUGraph) -> OSStatus #foreign AudioToolbox #deprecated;
NewAUGraph  :: (outGraph: *AUGraph) -> OSStatus #foreign AudioToolbox #deprecated;
AUGraphAddNode :: (inGraph: AUGraph, inDescription: *AudioComponentDescription, outNode: *AUNode) -> OSStatus #foreign AudioToolbox #deprecated;
AUGraphNodeInfo :: (inGraph: AUGraph, inNode: AUNode, outDescription: *AudioComponentDescription, outAudioUnit: *AudioUnit) -> OSStatus #foreign AudioToolbox #deprecated;
AUGraphOpen :: (inGraph: AUGraph) -> OSStatus #foreign AudioToolbox #deprecated;
AUGraphConnectNodeInput ::(inGraph: AUGraph, inSourceNode: AUNode, inSourceOutputNumber: u32, inDestNode: AUNode, inDestInputNumber: u32) -> OSStatus #foreign AudioToolbox #deprecated;
AUGraphInitialize :: (inGraph: AUGraph) -> OSStatus #foreign AudioToolbox #deprecated;

AudioToolbox :: #library,system "AudioToolbox";
CoreAudio :: #library,system "CoreAudio";
_AudioUnit :: #library,system "AudioUnit";


#scope_file;

output_unit: AudioUnit;

ring_buffer: Ring_Buffer;

minimum_prebuffered_bytes: s64;

num_channels: s32;
channel_names: [..] string;
