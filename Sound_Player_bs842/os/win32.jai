#scope_module

#import "Windows";
#import "Wav_File";

/*

Here are the ugly macros from C for when we want them:

DECLARE_INTERFACE_(IDirectSound, IUnknown)
{
    // IUnknown methods
    STDMETHOD(QueryInterface)       (THIS_ __in REFIID, __deref_out LPVOID*) PURE;
    STDMETHOD_(ULONG,AddRef)        (THIS) PURE;
    STDMETHOD_(ULONG,Release)       (THIS) PURE;

    // IDirectSound methods
    STDMETHOD(CreateSoundBuffer)    (THIS_ __in LPCDSBUFFERDESC pcDSBufferDesc, __deref_out LPDIRECTSOUNDBUFFER *ppDSBuffer, __null LPUNKNOWN pUnkOuter) PURE;
    STDMETHOD(GetCaps)              (THIS_ __out LPDSCAPS pDSCaps) PURE;
    STDMETHOD(DuplicateSoundBuffer) (THIS_ __in LPDIRECTSOUNDBUFFER pDSBufferOriginal, __deref_out LPDIRECTSOUNDBUFFER *ppDSBufferDuplicate) PURE;
    STDMETHOD(SetCooperativeLevel)  (THIS_ HWND hwnd, DWORD dwLevel) PURE;
    STDMETHOD(Compact)              (THIS) PURE;
    STDMETHOD(GetSpeakerConfig)     (THIS_ __out LPDWORD pdwSpeakerConfig) PURE;
    STDMETHOD(SetSpeakerConfig)     (THIS_ DWORD dwSpeakerConfig) PURE;
    STDMETHOD(Initialize)           (THIS_ __in_opt LPCGUID pcGuidDevice) PURE;
};


DECLARE_INTERFACE_(IDirectSoundBuffer8, IDirectSoundBuffer)
{
    // IUnknown methods
    STDMETHOD(QueryInterface)       (THIS_ _In_ REFIID, _Outptr_ LPVOID*) PURE;
    STDMETHOD_(ULONG,AddRef)        (THIS) PURE;
    STDMETHOD_(ULONG,Release)       (THIS) PURE;

    // IDirectSoundBuffer methods
    STDMETHOD(GetCaps)              (THIS_ _Out_ LPDSBCAPS pDSBufferCaps) PURE;
    STDMETHOD(GetCurrentPosition)   (THIS_ _Out_opt_ LPDWORD pdwCurrentPlayCursor, _Out_opt_ LPDWORD pdwCurrentWriteCursor) PURE;
    STDMETHOD(GetFormat)            (THIS_ _Out_writes_bytes_opt_(dwSizeAllocated) LPWAVEFORMATEX pwfxFormat, DWORD dwSizeAllocated, _Out_opt_ LPDWORD pdwSizeWritten) PURE;
    STDMETHOD(GetVolume)            (THIS_ _Out_ LPLONG plVolume) PURE;
    STDMETHOD(GetPan)               (THIS_ _Out_ LPLONG plPan) PURE;
    STDMETHOD(GetFrequency)         (THIS_ _Out_ LPDWORD pdwFrequency) PURE;
    STDMETHOD(GetStatus)            (THIS_ _Out_ LPDWORD pdwStatus) PURE;
    STDMETHOD(Initialize)           (THIS_ _In_ LPDIRECTSOUND pDirectSound, _In_ LPCDSBUFFERDESC pcDSBufferDesc) PURE;
    STDMETHOD(Lock)                 (THIS_ DWORD dwOffset, DWORD dwBytes,
                                           _Outptr_result_bytebuffer_(*pdwAudioBytes1) LPVOID *ppvAudioPtr1, _Out_ LPDWORD pdwAudioBytes1,
                                           _Outptr_opt_result_bytebuffer_(*pdwAudioBytes2) LPVOID *ppvAudioPtr2, _Out_opt_ LPDWORD pdwAudioBytes2, DWORD dwFlags) PURE;
    STDMETHOD(Play)                 (THIS_ DWORD dwReserved1, DWORD dwPriority, DWORD dwFlags) PURE;
    STDMETHOD(SetCurrentPosition)   (THIS_ DWORD dwNewPosition) PURE;
    STDMETHOD(SetFormat)            (THIS_ _In_ LPCWAVEFORMATEX pcfxFormat) PURE;
    STDMETHOD(SetVolume)            (THIS_ LONG lVolume) PURE;
    STDMETHOD(SetPan)               (THIS_ LONG lPan) PURE;
    STDMETHOD(SetFrequency)         (THIS_ DWORD dwFrequency) PURE;
    STDMETHOD(Stop)                 (THIS) PURE;
    STDMETHOD(Unlock)               (THIS_ _In_reads_bytes_(dwAudioBytes1) LPVOID pvAudioPtr1, DWORD dwAudioBytes1,
                                           _In_reads_bytes_opt_(dwAudioBytes2) LPVOID pvAudioPtr2, DWORD dwAudioBytes2) PURE;
    STDMETHOD(Restore)              (THIS) PURE;

    // IDirectSoundBuffer8 methods
    STDMETHOD(SetFX)                (THIS_ DWORD dwEffectsCount, _In_reads_opt_(dwEffectsCount) LPDSEFFECTDESC pDSFXDesc, _Out_writes_opt_(dwEffectsCount) LPDWORD pdwResultCodes) PURE;
    STDMETHOD(AcquireResources)     (THIS_ DWORD dwFlags, DWORD dwEffectsCount, _Out_writes_(dwEffectsCount) LPDWORD pdwResultCodes) PURE;
    STDMETHOD(GetObjectInPath)      (THIS_ _In_ REFGUID rguidObject, DWORD dwIndex, _In_ REFGUID rguidInterface, _Outptr_ LPVOID *ppObject) PURE;
};

*/

#scope_export

OUTPUT_SAMPLING_RATE :: 44100;

PRIMARY_BUFFER_SIZE_IN_BYTES :: 0;
FILL_BUFFER_SIZE_IN_SAMPLES  :: 24000;  // @Cleanup: When we can do constexpr math, this should be: OUTPUT_SAMPLING_RATE / 2 or something like that.

DS_OK :: 0;

DSBPLAY_LOOPING      :: 0x01;

DSBSTATUS_PLAYING           :: 0x001;
DSBSTATUS_BUFFERLOST        :: 0x002;
DSBSTATUS_LOOPING           :: 0x004;
DSBSTATUS_LOCHARDWARE       :: 0x008;
DSBSTATUS_LOCSOFTWARE       :: 0x010;
DSBSTATUS_TERMINATED        :: 0x020;

//
// DirectSound Stuff:
//

WAVE_FORMAT_EXTENSIBLE         :: 0xFFFE;


// @Incomplete:: Eventually we can uncomment this, but
// right now the #run directive return value handling does not
// handle big return values and GUID is big! Because the return value
// is put back into the AST, we would need an AST Literal for
// a binary blob, I think. Weird and I don't want to do it yet.
// -jblow, 19 September 2015
//
// KSDATAFORMAT_SUBTYPE_PCM :: #run string_to_guid("00000001-0000-0010-8000-00aa00389b71");

init_KSDATAFORMAT_SUBTYPE_PCM :: (dest: *GUID) { <<dest = string_to_guid("00000001-0000-0010-8000-00aa00389b71"); }


SPEAKER_FRONT_LEFT             :: 0x1;
SPEAKER_FRONT_RIGHT            :: 0x2;
SPEAKER_FRONT_CENTER           :: 0x4;
SPEAKER_LOW_FREQUENCY          :: 0x8;
SPEAKER_BACK_LEFT              :: 0x10;
SPEAKER_BACK_RIGHT             :: 0x20;
SPEAKER_FRONT_LEFT_OF_CENTER   :: 0x40;
SPEAKER_FRONT_RIGHT_OF_CENTER  :: 0x80;
SPEAKER_BACK_CENTER            :: 0x100;
SPEAKER_SIDE_LEFT              :: 0x200;
SPEAKER_SIDE_RIGHT             :: 0x400;
SPEAKER_TOP_CENTER             :: 0x800;
SPEAKER_TOP_FRONT_LEFT         :: 0x1000;
SPEAKER_TOP_FRONT_CENTER       :: 0x2000;
SPEAKER_TOP_FRONT_RIGHT        :: 0x4000;
SPEAKER_TOP_BACK_LEFT          :: 0x8000;
SPEAKER_TOP_BACK_CENTER        :: 0x10000;
SPEAKER_TOP_BACK_RIGHT         :: 0x20000;


KSAUDIO_SPEAKER_MONO           :: SPEAKER_FRONT_CENTER;
KSAUDIO_SPEAKER_STEREO         :: SPEAKER_FRONT_LEFT | SPEAKER_FRONT_RIGHT;
KSAUDIO_SPEAKER_QUAD           :: SPEAKER_FRONT_LEFT | SPEAKER_FRONT_RIGHT |
                                  SPEAKER_BACK_LEFT  | SPEAKER_BACK_RIGHT;
KSAUDIO_SPEAKER_SURROUND       :: SPEAKER_FRONT_LEFT | SPEAKER_FRONT_RIGHT |
                                  SPEAKER_FRONT_CENTER | SPEAKER_BACK_CENTER;
KSAUDIO_SPEAKER_5POINT1        :: SPEAKER_FRONT_LEFT | SPEAKER_FRONT_RIGHT |
                                  SPEAKER_FRONT_CENTER | SPEAKER_LOW_FREQUENCY |
                                  SPEAKER_BACK_LEFT  | SPEAKER_BACK_RIGHT;
KSAUDIO_SPEAKER_7POINT1        :: SPEAKER_FRONT_LEFT | SPEAKER_FRONT_RIGHT |
                                  SPEAKER_FRONT_CENTER | SPEAKER_LOW_FREQUENCY |
                                  SPEAKER_BACK_LEFT | SPEAKER_BACK_RIGHT |
                                  SPEAKER_FRONT_LEFT_OF_CENTER | SPEAKER_FRONT_RIGHT_OF_CENTER;
KSAUDIO_SPEAKER_5POINT1_SURROUND :: SPEAKER_FRONT_LEFT | SPEAKER_FRONT_RIGHT |
                                    SPEAKER_FRONT_CENTER | SPEAKER_LOW_FREQUENCY |
                                    SPEAKER_SIDE_LEFT  | SPEAKER_SIDE_RIGHT;
KSAUDIO_SPEAKER_7POINT1_SURROUND :: SPEAKER_FRONT_LEFT | SPEAKER_FRONT_RIGHT |
                                    SPEAKER_FRONT_CENTER | SPEAKER_LOW_FREQUENCY |
                                    SPEAKER_BACK_LEFT | SPEAKER_BACK_RIGHT |
                                    SPEAKER_SIDE_LEFT | SPEAKER_SIDE_RIGHT;

// The following are obsolete 5.1 and 7.1 settings (they lack side speakers).  Note this means
// that the default 5.1 and 7.1 settings (KSAUDIO_SPEAKER_5POINT1 and KSAUDIO_SPEAKER_7POINT1 are
// similarly obsolete but are unchanged for compatibility reasons).
//KSAUDIO_SPEAKER_5POINT1_BACK :: KSAUDIO_SPEAKER_5POINT1;
//KSAUDIO_SPEAKER_7POINT1_WIDE :: KSAUDIO_SPEAKER_7POINT1;


DSSPEAKER :: enum {
    HEADPHONE        :: 1;
    MONO             :: 2;
    QUAD             :: 3;
    STEREO           :: 4;
    SURROUND         :: 5;
    _5POINT1          :: 6;
    _5POINT1_BACK     :: _5POINT1;
    _5POINT1_SURROUND :: 9;
    _7POINT1          :: 7;
    _7POINT1_SURROUND :: 8;
    _7POINT1_WIDE     :: _7POINT1;
}

DSBCAPS_PRIMARYBUFFER      :: 0x1;
DSBCAPS_CTRLVOLUME         :: 0x80;
DSBCAPS_GLOBALFOCUS        :: 0x08000;
DSBCAPS_GETCURRENTPOSITION2:: 0x10000;

DSBUFFERCAPS :: struct {
}

IDirectSound8 :: struct {
    using vtable: *IDirectSound8Vtable;
}

IDirectSoundBuffer8 :: struct {
    using vtable: *IDirectSoundBuffer8Vtable;
}

IDirectSoundBuffer8Vtable :: struct {
    using base: IUnknown_VTable;

    GetCaps: (buffer: *IDirectSoundBuffer8, caps: *DSBUFFERCAPS) #c_call;
    GetCurrentPosition: (buffer: *IDirectSoundBuffer8, pdwCurrentPlayCursor: *s32, pdwCurrentWriteCursor: *s32) -> s32 #c_call;
    GetFormat: *void;
    GetVolume: *void;
    GetPan: *void;
    GetFrequency: *void;
    GetStatus:     (buffer: *IDirectSoundBuffer8, pdwStatus: *s32) -> s32 #c_call;
    Initialize:   *void;
    Lock: (buffer: *IDirectSoundBuffer8, dwOffset: s32, dwBytes: s32, pvAudioPtr1: **void, dwAudioBytes1: *s32, pvAudioPtr2: **void, dwAudioBytes2: *s32, dwFlags: s32) -> s32 #c_call;
    Play: (buffer: *IDirectSoundBuffer8, dwReserved1: s32, dwPriority: s32, dwFlags: s32) -> s32 #c_call;
    SetCurrentPosition: *void;
    SetFormat:  (buffer: *IDirectSoundBuffer8, format: *Waveformatex) -> s32 #c_call;
    SetVolume:    *void;
    SetPan:       *void;
    SetFrequency: *void;
    Stop: (buffer: *IDirectSoundBuffer8) -> s32 #c_call;
    Unlock: (buffer: *IDirectSoundBuffer8, pvAudioPtr1: *void, dwAudioBytes1: s32, pvAudioPtr2: *void, dwAudioBytes2: s32) -> s32 #c_call;

    Restore: (buffer: *IDirectSoundBuffer8) -> s32 #c_call;

    // IDirectSoundBuffer8 methods
    SetFX: *void;
    AcquireResources: *void;
    GetObjectInPath: *void;
}

IDirectSound8Vtable :: struct {
    using base: IUnknown_VTable;

    // IDirectSound methods
    CreateSoundBuffer: (dsound: *IDirectSound8, desc: *DSBUFFERDESC, buffer: **IDirectSoundBuffer8, outer: **void = null) -> s32 #c_call;

    GetCaps: *void;
    DuplicateSoundBuffer: *void;
    SetCooperativeLevel: (dsound: *IDirectSound8, hwnd: HWND, level: s32) -> s32 #c_call;
    Compact: *void;
    GetSpeakerConfig: (dsound: *IDirectSound8, config: *s32) -> s32 #c_call;
    SetSpeakerConfig: *void;
    Initialize: *void;
}

WAVEFORMATEXTENSIBLE :: struct {
    Format: Waveformatex;
    wValidBitsPerSample: s16;
    dwChannelMask: s32;
    SubFormat: GUID;
}

DSBUFFERDESC :: struct {
    dwSize        : s32;
    dwFlags       : s32;
    dwBufferBytes : s32;
    dwReserved    : s32;
    lpwfxFormat   : *Waveformatex;

    guid3DAlgorithm: GUID;
}


init_wave_format :: (using w: *Waveformatex, nchannels: s16) {
    wFormatTag      = WAVE_FORMAT_PCM;
    nChannels       = nchannels;
    nSamplesPerSec  = OUTPUT_SAMPLING_RATE;
    wBitsPerSample  = 16;
    nBlockAlign     = (wBitsPerSample / 8) * nChannels;
    nAvgBytesPerSec = nSamplesPerSec * nBlockAlign;
}

CONFIG :: (speaker_config: s32) -> DSSPEAKER {
    return cast(DSSPEAKER) (speaker_config & 0xff);
}

GEOMETRY :: (speaker_config: s32) -> u8 {
    return cast(u8) ((speaker_config >> 16) & 0xff);
}

backend_init :: (config: Sound_Player_Config) -> Backend_Properties {
    DirectSoundCreate8 :: (device: *void, ppds8: **IDirectSound8, outer: *void) -> s32 #foreign dsound_lib;

    hr := DirectSoundCreate8(ifx config.output_device then *config.output_device.guid else null, *dsound, null);
    if !SUCCEEDED(hr) {
        log_error("DSCreate8 Failed!\n");
        return .{};
    }

    // Try find the window our process actually owns, if not then fallback to what the DSound docs suggest. This avoids
    // setting the incorrect window if you alt tab after window creation, before sound player init.
    hwnd := find_my_window();
    if !hwnd {
        hwnd = ifx GetForegroundWindow() else GetDesktopWindow();
    }

    DSSCL_NORMAL        :: 0x1;
    DSSCL_PRIORITY      :: 0x2;
    // DSSCL_EXCLUSIVE     :: 0x3;   Deprecated and useless.
    // DSSCL_WRITEPRIMARY  :: 0x4;   Deprecated and useless.

    hr = dsound.SetCooperativeLevel(dsound, hwnd, DSSCL_PRIORITY);

    if !SUCCEEDED(hr) log_error("SetCooperativeLevel Failed! HWND %.\n", hwnd);
    if !SUCCEEDED(hr) return .{};

    speaker_config: s32;
    hr = dsound.GetSpeakerConfig(dsound, *speaker_config);

    if SUCCEEDED(hr) {
        config := cast(DSSPEAKER) CONFIG(speaker_config);
        geometry := GEOMETRY(speaker_config);

        log("dsound reports speaker config %, geometry %\n", config, geometry);
        if (config == ._5POINT1_BACK) || (config == ._5POINT1_SURROUND) {
            array_add(*channel_names, "Front Left");
            array_add(*channel_names, "Front Right");
            array_add(*channel_names, "Center");
            array_add(*channel_names, "Subwoofer");
            array_add(*channel_names, "Rear Left");
            array_add(*channel_names, "Rear Right");
        } else if (config == ._7POINT1_WIDE) || (config == ._7POINT1_SURROUND) {
            array_add(*channel_names, "Front Left");
            array_add(*channel_names, "Front Right");
            array_add(*channel_names, "Center");
            array_add(*channel_names, "Subwoofer");
            array_add(*channel_names, "Rear Left");
            array_add(*channel_names, "Rear Right");
            array_add(*channel_names, "Extend Left");
            array_add(*channel_names, "Extend Right");
        } else {
            array_add(*channel_names, "Left");
            array_add(*channel_names, "Right");
        }
    } else {
        array_add(*channel_names, "Left?");
        array_add(*channel_names, "Right?");
    }

    num_channels = cast(s32) channel_names.count;


    //
    // Get the primary buffer
    //
    dsbd: DSBUFFERDESC;
    dsbd.dwSize        = size_of(DSBUFFERDESC);
    dsbd.dwFlags       = DSBCAPS_PRIMARYBUFFER;
    dsbd.dwBufferBytes = PRIMARY_BUFFER_SIZE_IN_BYTES;

    hr = dsound.CreateSoundBuffer(dsound, *dsbd, *primary_buffer, null);
    if FAILED(hr) return .{};

    channel_mask: s64;
    if num_channels == 2 {
        channel_mask = KSAUDIO_SPEAKER_STEREO;
    } else {
        channel_mask = KSAUDIO_SPEAKER_5POINT1_SURROUND;
    }

    KSDATAFORMAT_SUBTYPE_PCM : GUID;
    init_KSDATAFORMAT_SUBTYPE_PCM(*KSDATAFORMAT_SUBTYPE_PCM);

    wfx: WAVEFORMATEXTENSIBLE;
    init_wave_format(*wfx.Format, cast(s16) num_channels);
    wfx.Format.wFormatTag = WAVE_FORMAT_EXTENSIBLE;
    wfx.Format.wBitsPerSample = 16;
    wfx.Format.nSamplesPerSec = OUTPUT_SAMPLING_RATE;
    wfx.Format.cbSize = 22;
    wfx.wValidBitsPerSample = 16;
    wfx.dwChannelMask = cast(s32) channel_mask;
    wfx.SubFormat = KSDATAFORMAT_SUBTYPE_PCM;

    hr = primary_buffer.SetFormat(primary_buffer, *wfx.Format);
    if !SUCCEEDED(hr) print("SetFormat! wfx.Format is: %\n", wfx.Format);
    if FAILED(hr) return .{};


/*
    wfx2: WAVEFORMATEXTENSIBLE;
    wfx2.Format.wFormatTag = WAVE_FORMAT_EXTENSIBLE;
    wfx2.Format.cbSize = 22;

    needed: s32 = 0;
    hr = primary_buffer.GetFormat(primary_buffer, null, 0, *needed);
    result_bytes := alloc(needed, __temporary_allocator);
    hr = primary_buffer->GetFormat((LPWAVEFORMATEX)result_bytes, needed, NULL);
    assert(SUCCEEDED(hr));

    //
    // @Incomplete: What if our result format has a different number of channels from what we wanted?
    //
*/

    fill_bytes := FILL_BUFFER_SIZE_IN_SAMPLES * num_channels;

    //
    // Create the fill buffer.
    //
    fill_desc: DSBUFFERDESC;
    fill_desc.dwSize        = size_of(DSBUFFERDESC);

    fill_desc.dwFlags       = DSBCAPS_CTRLVOLUME | DSBCAPS_GETCURRENTPOSITION2;
    if config.audible_when_window_is_not_in_focus  fill_desc.dwFlags |= DSBCAPS_GLOBALFOCUS;

    fill_desc.dwBufferBytes = cast(s32) fill_bytes;
    fill_desc.lpwfxFormat   = *wfx.Format;

    hr = dsound.vtable.CreateSoundBuffer(dsound, *fill_desc, *fill_buffer, null);

    if !SUCCEEDED(hr) log_error("CreateSoundBuffer failed!\n");
    if FAILED(hr) return .{};


    fill_buffer_size_in_bytes = cast(s32) fill_bytes;  // @Robustness: Check the actual length of the buffer, not what we asked it to be.

    result: Backend_Properties;
    result.num_channels  = num_channels;
    result.channel_names = channel_names;
    result.initted       = true;
    result.output_sampling_rate = OUTPUT_SAMPLING_RATE;

    return result;
}

backend_play :: () {
    if !fill_buffer return; // No audio driver!

    hr := fill_buffer.Play(fill_buffer, 0, 0, DSBPLAY_LOOPING);
    // print("play hr %\n", hr);

    // assert(SUCCEEDED(hr));
    if SUCCEEDED(hr) playing = true;
}

backend_lock_fill_regions :: (bytes_to_lock: s64) -> Fill_Region_Result, bool {
	if !fill_buffer return .{}, false;  // No driver, no regions!

    pointer1, pointer2: *void;
    bytes1, bytes2: s32;

    hr := fill_buffer.Lock(fill_buffer, cast(s32) my_write_cursor, cast(s32) bytes_to_lock,
                           *pointer1, *bytes1, *pointer2, *bytes2,
                           0);
    // print("lock %, %, %\n", fill_buffer, my_write_cursor, bytes_to_lock);

    if !SUCCEEDED(hr) return .{}, false;

    result: Fill_Region_Result;
    result.buffer0 = .{bytes1, pointer1};
    result.buffer1 = .{bytes2, pointer2};

    return result, true;
}

backend_release_fill_regions :: (result: Fill_Region_Result) {
    if !fill_buffer return;  // No driver!

    s0 := result.buffer0;
    s1 := result.buffer1;

    fill_buffer.Unlock(fill_buffer, s0.data, cast(s32) s0.count, s1.data, cast(s32) s1.count);

    my_write_cursor += s0.count + s1.count;

    if my_write_cursor >= fill_buffer_size_in_bytes  my_write_cursor -= fill_buffer_size_in_bytes;

    assert(my_write_cursor >= 0);
    assert(my_write_cursor < fill_buffer_size_in_bytes);
    assert((my_write_cursor % 4) == 0);
    // print("<<< Fill regions release\n");
}


backend_shutdown :: () {
    if fill_buffer {
        fill_buffer.Stop(fill_buffer);
    }

    safe_release_and_reset(*primary_buffer);
    safe_release_and_reset(*fill_buffer);
    safe_release_and_reset(*dsound);
}

/*
restore_buffers :: () -> bool {
    restore_buffer :: (buffer: *IDirectSoundBuffer8) -> bool {
        dwStatus: s32;
        hr := buffer.GetStatus(buffer, *dwStatus);
        if FAILED(hr) return false;

        if !(dwStatus & DSBSTATUS_BUFFERLOST) return true;

        hr = buffer.Restore(buffer);
        if FAILED(hr) return false;

        return true;
    }

    success1 := restore_buffer(primary_buffer);
    success2 := restore_buffer(fill_buffer);

    return success1 && success2;
}
*/

get_bytes_between :: (front: $T, rear: T, buffer_len: T) -> T {
    if front >= rear return front - rear;
    return (buffer_len - rear) + front;
}

backend_count_buffered_bytes :: () -> (currently_buffered: s64, minimum_prebuffered: s64) {
	if !fill_buffer return 0, 0;

    d_play_cursor: s32;
    d_annoying_write_cursor: s32;

    hr := fill_buffer.GetCurrentPosition(fill_buffer, *d_play_cursor, *d_annoying_write_cursor);
    if !SUCCEEDED(hr) return 0, 0;

    between := get_bytes_between(my_write_cursor, d_play_cursor, fill_buffer_size_in_bytes);
    necessary_prebuffered := get_bytes_between(d_annoying_write_cursor, d_play_cursor, fill_buffer_size_in_bytes);

    return between, necessary_prebuffered;
}

backend_needs_async_update_from_main_thread :: () -> bool {
    return true;
}


Enumeration_Callback_Data :: struct {
    outer_context: #Context;
    devices: [..] Output_Device;
}

backend_get_devices :: () -> [] Output_Device {
    DirectSoundEnumerateA :: (callback: (*GUID, *u8, *u8, *void) #c_call, lpContext: *void) -> HRESULT #foreign dsound_lib;
    callback_data: Enumeration_Callback_Data;
    callback_data.outer_context = context;

    hr := DirectSoundEnumerateA(enumeration_proc, *callback_data);

    enumerated_output_devices = callback_data.devices;
    return enumerated_output_devices;
}

#scope_file

enumeration_proc :: (guid: *GUID, Desc: *u8, DrvName: *u8, pContext: *void) #c_call {
    cdata := cast(*Enumeration_Callback_Data) pContext;

    push_context,defer_pop cdata.outer_context;

    devices := *cdata.devices;
    device := array_add(devices);
    device.name = copy_string(to_string(Desc));
    device.device_index = devices.count-1;
    device.guid = ifx guid then guid.* else .{};

    hints: [..] string;
    if DrvName {
        hint := copy_string(to_string(DrvName));
        array_add(*hints, hint);

        device.hints = hints;
    }
}

// A pretty ridiculous way to find our processes window, windows doesn't appear to offer a better way than this?
// Will return null when no window is found.
// @Incomplete: Doesn't handle multi window programs, or programs using esoteric windows stuff.
// This will probably go away when we stop using DirectSound. (??)
find_my_window :: () -> HWND {
    user32 :: #library,system "user32";
    EnumWindowsProc :: #type (hwnd: HWND, lParam: LPARAM) -> BOOL #c_call;
    EnumWindows     :: (lpEnumFunc: EnumWindowsProc, lParam: LPARAM) -> BOOL #foreign user32;
    GetWindowThreadProcessId :: (hWnd: HWND, lpdwProcessId: *u32) -> u32 #foreign user32;
    IsWindowVisible :: (hwnd: HWND) -> BOOL #foreign user32;

    User_Data :: struct {
        ctx: *#Context;
        current_process_id: u32;
        window_handle: HWND;
    }

    proc :: (hwnd: HWND, lParam: LPARAM) -> BOOL #c_call {
        using data := cast(*User_Data, lParam);

        push_context ctx.* {
            pid: u32;
            tid := GetWindowThreadProcessId(hwnd, *pid);
            assert(tid != 0);

            if pid != current_process_id  return .TRUE;
            if !IsWindowVisible(hwnd)     return .TRUE; // Ignore weird invisible windows, eg graphics drivers appear to create these?

            window_handle = hwnd;
            return .FALSE;
        }
    }

    using data: User_Data;
    ctx = *context;
    current_process_id = GetCurrentProcessId();
    EnumWindows(proc, xx *data);

    return window_handle;
}

dsound_lib :: #library,system "dsound";

playing: bool;

fill_buffer_size_in_bytes: s32;
minimum_prebuffered_bytes: s64;

num_channels:  s32;  // Currently will only be 2, 6, or 8.
channel_names: [..] string;

my_write_cursor: s64;

dsound:         *IDirectSound8;
primary_buffer: *IDirectSoundBuffer8;
fill_buffer:    *IDirectSoundBuffer8;

enumerated_output_devices: [..] Output_Device;
