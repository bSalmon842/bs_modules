AUDIO_MASK_BITSIZE       :: (0xFF);
AUDIO_MASK_FLOAT         :: (1<<8);
AUDIO_MASK_BIG_ENDIAN    :: (1<<12);
AUDIO_MASK_SIGNED        :: (1<<15);

DEFINE_AUDIO_FORMAT :: (signed: u16, big_endian: u16, flt: u16, size: u16) -> u16
{
    return (signed << 15) | (big_endian << 12) | (flt << 8) | (size & AUDIO_MASK_BITSIZE);
}

Audio_Format :: enum u32
{
    UNKNOWN   :: 0x0000;
    U8        :: 0x0008;
    S8        :: 0x8008;
    S16LE     :: 0x8010;
    S16BE     :: 0x9010;
    S32LE     :: 0x8020;
    S32BE     :: 0x9020;
    F32LE     :: 0x8120;
    F32BE     :: 0x9120;

    // #if BYTEORDER == LIL_ENDIAN
    S16:: 0x8010;
    S32:: 0x8020;
    F32:: 0x8120;

    // #if BYTEORDER != LIL_ENDIAN
    // AUDIO_S16 :: 0x9010;
    // AUDIO_S32 :: 0x9020;
    // AUDIO_F32 :: 0x9120;
}

AUDIO_BITSIZE        :: (x: u32) -> u32  #expand {return (x & AUDIO_MASK_BITSIZE);}
AUDIO_BYTESIZE       :: (x: u32) -> u32  #expand {return AUDIO_BITSIZE(x) / 8;}
AUDIO_ISFLOAT        :: (x: u32) -> bool #expand {return xx (x & AUDIO_MASK_FLOAT);}
AUDIO_ISBIGENDIAN    :: (x: u32) -> bool #expand {return xx (x & AUDIO_MASK_BIG_ENDIAN);}
AUDIO_ISLITTLEENDIAN :: (x: u32) -> bool #expand {return !AUDIO_ISBIGENDIAN(x);}
AUDIO_ISSIGNED       :: (x: u32) -> bool #expand {return xx (x & AUDIO_MASK_SIGNED);}
AUDIO_ISINT          :: (x: u32) -> bool #expand {return !AUDIO_ISFLOAT(x);}
AUDIO_ISUNSIGNED     :: (x: u32) -> bool #expand {return !AUDIO_ISSIGNED(x);}
AUDIO_FRAMESIZE      :: (x: Audio_Spec) -> u32 #expand {return AUDIO_BYTESIZE(xx x.format * x.channels);}


Audio_Device_ID :: enum_flags u32
{
    PLAYBACK  :: 0xFFFFFFFF;
    RECORDING :: 0xFFFFFFFE;
}

Audio_Spec :: struct
{
    format:   Audio_Format;
    channels: u32;
    freq:     s32;
}

Audio_Stream :: void;

Audio_Stream_Callback :: #type (userdata: *void, stream: *Audio_Stream, additional_amount: s32, total_amount: s32);
Audio_Postmix_Callback :: #type (userdata: *void, spec: Audio_Spec, buffer: *float32, buflen: s32);

get_num_audio_drivers               :: () -> s32                                                                                                          #foreign SDL3 "SDL_GetNumAudioDrivers";
get_audio_driver                    :: (index: s32) -> *u8                                                                                                #foreign SDL3 "SDL_GetAudioDriver";
get_current_audio_driver            :: () -> *u8                                                                                                          #foreign SDL3 "SDL_GetCurrentAudioDriver";
get_audio_playback_devices          :: (count: *s32) -> *Audio_Device_ID                                                                                  #foreign SDL3 "SDL_GetAudioPlaybackDevices";
get_audio_recording_devices         :: (count: *s32) -> *Audio_Device_ID                                                                                  #foreign SDL3 "SDL_GetAudioRecordingDevices";
get_audio_device_name               :: (dev_id: Audio_Device_ID) -> *u8                                                                                   #foreign SDL3 "SDL_GetAudioDeviceName";
get_audio_device_format             :: (dev_id: Audio_Device_ID, spec: *Audio_Spec, sample_frames: *s32) -> bool                                          #foreign SDL3 "SDL_GetAudioDeviceFormat";
get_audio_device_channel_map        :: (dev_id: Audio_Device_ID, count: *s32) -> *s32                                                                     #foreign SDL3 "SDL_GetAudioDeviceChannelMap";
open_audio_device                   :: (dev_id: Audio_Device_ID, spec: *Audio_Spec) -> Audio_Device_ID                                                    #foreign SDL3 "SDL_OpenAudioDevice";
pause_audio_device                  :: (dev_id: Audio_Device_ID) -> bool                                                                                  #foreign SDL3 "SDL_PauseAudioDevice";
resume_audio_device                 :: (dev_id: Audio_Device_ID) -> bool                                                                                  #foreign SDL3 "SDL_ResumeAudioDevice";
audio_device_paused                 :: (dev_id: Audio_Device_ID) -> bool                                                                                  #foreign SDL3 "SDL_AudioDevicePaused";
get_audio_device_gain               :: (dev_id: Audio_Device_ID) -> float32                                                                               #foreign SDL3 "SDL_GetAudioDeviceGain";
set_audio_device_gain               :: (dev_id: Audio_Device_ID, gain: float32) -> bool                                                                   #foreign SDL3 "SDL_SetAudioDeviceGain";
close_audio_device                  :: (dev_id: Audio_Device_ID)                                                                                          #foreign SDL3 "SDL_CloseAudioDevice";
bind_audio_streams                  :: (dev_id: Audio_Device_ID, streams: **Audio_Stream, num_streams: s32) -> bool                                       #foreign SDL3 "SDL_BindAudioStreams";
bind_audio_stream                   :: (dev_id: Audio_Device_ID, stream: *Audio_Stream) -> bool                                                           #foreign SDL3 "SDL_BindAudioStream";
unbind_audio_streams                :: (streams: **Audio_Stream, num_streams: s32)                                                                        #foreign SDL3 "SDL_UnbindAudioStreams";
unbind_audio_stream                 :: (stream: *Audio_Stream)                                                                                            #foreign SDL3 "SDL_UnbindAudioStream";
get_audio_stream_device             :: (stream: *Audio_Stream) -> Audio_Device_ID                                                                         #foreign SDL3 "SDL_GetAudioStreamDevice";
create_audio_stream                 :: (src_spec: *Audio_Spec, dst_spec: *Audio_Spec) -> *Audio_Stream                                                    #foreign SDL3 "SDL_CreateAudioStream";
get_audio_stream_properties         :: (stream: *Audio_Stream) -> Properties_ID                                                                           #foreign SDL3 "SDL_GetAudioStreamProperties";
get_audio_stream_format             :: (stream: *Audio_Stream, src_spec: *Audio_Spec, dst_spec: *Audio_Spec) -> bool                                      #foreign SDL3 "SDL_GetAudioStreamFormat";
set_audio_stream_format             :: (stream: *Audio_Stream, src_spec: *Audio_Spec, dst_spec: *Audio_Spec) -> bool                                      #foreign SDL3 "SDL_SetAudioStreamFormat";
get_audio_stream_frequency_ratio    :: (stream: *Audio_Stream) -> float32                                                                                 #foreign SDL3 "SDL_GetAudioStreamFrequencyRatio";
set_audio_stream_frequency_ratio    :: (stream: *Audio_Stream, ratio: float32) -> bool                                                                    #foreign SDL3 "SDL_SetAudioStreamFrequencyRatio";
get_audio_stream_gain               :: (stream: *Audio_Stream) -> float32                                                                                 #foreign SDL3 "SDL_GetAudioStreamGain";
set_audio_stream_gain               :: (stream: *Audio_Stream, gain: float32) -> bool                                                                     #foreign SDL3 "SDL_SetAudioStreamGain";
get_audio_stream_input_channel_map  :: (stream: *Audio_Stream, count: *s32) -> *s32                                                                       #foreign SDL3 "SDL_GetAudioStreamInputChannelMap";
get_audio_stream_output_channel_map :: (stream: *Audio_Stream, count: *s32) -> *s32                                                                       #foreign SDL3 "SDL_GetAudioStreamOutputChannelMap";
set_audio_stream_input_channel_map  :: (stream: *Audio_Stream, chmap: *s32, count: s32) -> bool                                                           #foreign SDL3 "SDL_SetAudioStreamInputChannelMap";
set_audio_stream_output_channel_map :: (stream: *Audio_Stream, chmap: *s32, count: s32) -> bool                                                           #foreign SDL3 "SDL_SetAudioStreamOutputChannelMap";
put_audio_stream_data               :: (stream: *Audio_Stream, buf: *void, len: s32) -> bool                                                              #foreign SDL3 "SDL_PutAudioStreamData";
get_audio_stream_data               :: (stream: *Audio_Stream, buf: *void, len: s32) -> s32                                                               #foreign SDL3 "SDL_GetAudioStreamData";
get_audio_stream_available          :: (stream: *Audio_Stream) -> s32                                                                                     #foreign SDL3 "SDL_GetAudioStreamAvailable";
get_audio_stream_queued             :: (stream: *Audio_Stream) -> s32                                                                                     #foreign SDL3 "SDL_GetAudioStreamQueued";
flush_audio_stream                  :: (stream: *Audio_Stream) -> bool                                                                                    #foreign SDL3 "SDL_FlushAudioStream";
clear_audio_stream                  :: (stream: *Audio_Stream) -> bool                                                                                    #foreign SDL3 "SDL_ClearAudioStream";
pause_audio_stream_device           :: (stream: *Audio_Stream) -> bool                                                                                    #foreign SDL3 "SDL_PauseAudioStreamDevice";
resume_audio_stream_device          :: (stream: *Audio_Stream) -> bool                                                                                    #foreign SDL3 "SDL_ResumeAudioStreamDevice";
lock_audio_stream                   :: (stream: *Audio_Stream) -> bool                                                                                    #foreign SDL3 "SDL_LockAudioStream";
unlock_audio_stream                 :: (stream: *Audio_Stream) -> bool                                                                                    #foreign SDL3 "SDL_UnlockAudioStream";
set_audio_stream_get_callback       :: (stream: *Audio_Stream, callback: Audio_Stream_Callback, userdata: *void) -> bool                                  #foreign SDL3 "SDL_SetAudioStreamGetCallback";
set_audio_stream_put_callback       :: (stream: *Audio_Stream, callback: Audio_Stream_Callback, userdata: *void) -> bool                                  #foreign SDL3 "SDL_SetAudioStreamPutCallback";
destroy_audio_stream                :: (stream: *Audio_Stream)                                                                                            #foreign SDL3 "SDL_DestroyAudioStream";
open_audio_device_stream            :: (dev_id: Audio_Device_ID, spec: *Audio_Spec, callback: Audio_Stream_Callback, userdata: *void) -> *Audio_Stream    #foreign SDL3 "SDL_OpenAudioDeviceStream";
set_audio_postmix_callback          :: (dev_id: Audio_Device_ID, callback: Audio_Postmix_Callback, userdata: *void) -> bool                               #foreign SDL3 "SDL_SetAudioPostmixCallback";
load_wav_io                         :: (src: *IO_Stream, close_io: bool, spec: *Audio_Spec, audio_buf: **u8, audio_len: *u32) -> bool                     #foreign SDL3 "SDL_LoadWAV_IO";
load_wav                            :: (path: *u8, spec: *Audio_Spec, audio_buf: **u8, audio_len: *u32) -> bool                                           #foreign SDL3 "SDL_LoadWAV";
mix_audio                           :: (dst: *u8, src: *u8, format: Audio_Format, len: u32, volume: float32) -> bool                                      #foreign SDL3 "SDL_MixAudio";
convert_audio_samples               :: (src_spec: *Audio_Spec, src_data: *u8, src_len: s32, dst_spec: *Audio_Spec, dst_data: **u8, dst_len: *s32) -> bool #foreign SDL3 "SDL_ConvertAudioSamples";
get_audio_format_name               :: (format: Audio_Format) -> *u8                                                                                      #foreign SDL3 "SDL_GetAudioFormatName";
get_silence_value_for_format        :: (format: Audio_Format) -> s32                                                                                      #foreign SDL3 "SDL_GetSilenceValueForFormat";
