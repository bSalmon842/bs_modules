// AAudio backend for use with Android NDK.
//
// Docs: https://developer.android.com/ndk/guides/audio/aaudio/aaudio
// Api reference: https://developer.android.com/ndk/reference/group/audio
//
//
// @Incomplete
// The Thread module, which Sound_Player uses for it's async stuff, isn't fully supported on arm yet, so update_from_a_thread
// should be false for now (it can be true on X64, but no guarentee it will work well).
// Although... AAudio recommends you use the data callback to write to device for the best performance. So it might be
// possible to have the audio "threaded" just by using that? Not totally clear to me how that is supposed to be used.
//

#scope_module

GUID :: *void;

OUTPUT_SAMPLING_RATE :: 44100;
FILL_BUFFER_SIZE_IN_FRAMES :: OUTPUT_SAMPLING_RATE / 2;

STREAM_FORMAT :: AAUDIO_FORMAT.PCM_I16;

backend_init :: (config: Sound_Player_Config) -> (Backend_Properties) {
    log("[aaudio] init called. update_from_a_thread == %.", config.update_from_a_thread);
    do_async = config.update_from_a_thread;

    builder: *AAudioStreamBuilder;
    result := AAudio_createStreamBuilder(*builder);
    assert(result == .OK);
    defer {
        // Can keep the builder around to make more streams, but that seems unlikely?
        result = AAudioStreamBuilder_delete(builder);
        assert(result == .OK);
    }

    AAudioStreamBuilder_setErrorCallback(builder, (stream: *AAudioStream, user_data: *void, error: AAUDIO) #c_call {
        outer_context := cast(*#Context) user_data;
        push_context outer_context.* {
            log_error("[aaudio] ErrorCallback received error %. It wasn't handled!", error);
        }
    }, *context);


    // Configure and create stream

    requested_device_id := cast(s32) AAUDIO_UNSPECIFIED;
    AAudioStreamBuilder_setDeviceId(builder, requested_device_id);

    // @Cleanup Sample rate, format and capactiy can actually be left up to android to pick suitable values for the device
    // in use. Is there a benefit to doing that?
    assert(STREAM_FORMAT == .PCM_I16, "Only % is currently supported for aaudio.", AAUDIO_FORMAT.PCM_I16);
    assert(BYTES_PER_SAMPLE == 2, "Stream format % should be 2 bytes per sample!", STREAM_FORMAT);

    AAudioStreamBuilder_setSampleRate(builder, OUTPUT_SAMPLING_RATE);
    AAudioStreamBuilder_setFormat(builder, STREAM_FORMAT);

    buffer_capacity_in_frames = cast(s32) FILL_BUFFER_SIZE_IN_FRAMES;
    AAudioStreamBuilder_setBufferCapacityInFrames(builder, buffer_capacity_in_frames);

    AAudioStreamBuilder_setPerformanceMode(builder, .LOW_LATENCY);

    result = AAudioStreamBuilder_openStream(builder, *stream);
    assert(result == .OK);


    // Verify stream configuration

    device_id := AAudioStream_getDeviceId(stream);
    log("[aaudio] Stream started on device with id %", device_id);
    if requested_device_id && requested_device_id != device_id {
        log("[aaudio] Device id % doesn't match the requested device id of %", device_id, requested_device_id, flags = .WARNING);
    }

    sample_rate     := AAudioStream_getSampleRate(stream);
    buffer_capactiy := AAudioStream_getBufferCapacityInFrames(stream);
    log("sample_rate == %, capacity == %", sample_rate, buffer_capactiy);

    channel_count := AAudioStream_getChannelCount(stream);
    channel_mask  := AAudioStream_getChannelMask(stream);
    log("[aaudio] Stream channel count == %, mask == %", channel_count, channel_mask);

    num_channels = channel_count;
    // NOTE(Charles): Speaker configuration can be configured with get/setChannelMask. The below has been tested doing this
    // but as all my devices only actually  have stereo output, whether it's working beyond that I don't know! Sound_Player
    // doesn't actually use the channel_names atm anyway, so we are now at least on par with win32 backend.
    // Also, the AAudio bindings we have for AAUDIO_CHANNEL aren't the best. Refer to AAudio.h for full details.
    if channel_mask == {
        case .STEREO;
            assert(num_channels == 2);
            array_add(*channel_names, "Left");
            array_add(*channel_names, "Right");

        case ._5POINT1; #through;
        case ._5POINT1_SIDE;
            assert(num_channels == 6);
            array_add(*channel_names, "Front Left");
            array_add(*channel_names, "Front Right");
            array_add(*channel_names, "Center");
            array_add(*channel_names, "Subwoofer");
            array_add(*channel_names, "Rear Left");
            array_add(*channel_names, "Rear Right");

        case ._7POINT1;
            assert(num_channels == 8);
            array_add(*channel_names, "Front Left");
            array_add(*channel_names, "Front Right");
            array_add(*channel_names, "Center");
            array_add(*channel_names, "Subwoofer");
            array_add(*channel_names, "Rear Left");
            array_add(*channel_names, "Rear Right");
            array_add(*channel_names, "Extend Left");
            array_add(*channel_names, "Extend Right");

        case;
        log("[aaudio] Unhandled channel mask % with % channels. channel_names array has been left empty", channel_mask, channel_count, flags = .WARNING);
    }

    // @Cleanup Configuration of buffer sizes, frames_per_burst etc, is all very arbitrary atm. Better job required!

    // format, rate and channels wont change. Sharing mode or buffer capacity might.
    buffer_capacity_to_check := AAudioStream_getBufferCapacityInFrames(stream);
    assert(buffer_capacity_in_frames == buffer_capacity_to_check, "We chose % frames for buffer capacity, but it is actually % frames", buffer_capacity_in_frames, buffer_capacity_to_check);
    log("[aaudio] buffer_capacity_in_frames == %", buffer_capacity_in_frames);

    // See AAudioStream_setBufferSizeInFrames
    buffer_size_in_frames = AAudioStream_getBufferSizeInFrames(stream);
    log("[aaudio] buffer_size_in_frames == %", buffer_size_in_frames);

    // I am using this in an equivalent way to period_size is used in alsa. This probably isn't really correct
    // but it shuold work. Eg this burst size is related to the size of the buffer, not related to the hardware.
    frames_per_burst = AAudioStream_getFramesPerBurst(stream);
    log("[aaudio] frames_per_burst == %", frames_per_burst);

    // NOTE(Charles): If you register a data call back (and keep all other config the same) frames per burst returns
    // 882 so that was my baseline. There is obvious latency if we don't override the frames_per_burst down to 882 but going
    // lower doesn't appear to decrease latency. (If this was decreased, a larger SAMPLE_BUFFER_NUM_BURSTS would be required
    // so that we have enough samples).
    frames_per_burst = 882;
    log("[aaudio] overrding frames_per_burst == %", frames_per_burst);

    SAMPLE_BUFFER_NUM_BURSTS :: 10;
    sample_buffer_num_frames = cast(s64) frames_per_burst * SAMPLE_BUFFER_NUM_BURSTS;
    sample_buffer.count = sample_buffer_num_frames * num_channels * BYTES_PER_SAMPLE;
    sample_buffer.data  = alloc(sample_buffer.count);

    properties: Backend_Properties;
    properties.num_channels  = num_channels;
    properties.channel_names = channel_names;
    properties.output_sampling_rate = OUTPUT_SAMPLING_RATE;
    properties.initted       = true;

    return properties;
}

backend_play :: () {
    log("[aaudio] play called!");
    // requestStart puts the stream into the Starting state. At some point later the stream will be put into the
    // Started state. There are no call backs, or any functions to check the current state but you can use
    // waitForStateChange like below. This blocks however so maybe isn't good. I'm doing it for now to be sure.
    // Probalby it's totally unecessary.
    result := AAudioStream_requestStart(stream);
    assert(result == .OK);

    next_state := AAUDIO_STREAM_STATE.UNINITIALIZED;
    timeout_nanoseconds := S64_MAX;
    result = AAudioStream_waitForStateChange(stream, .STARTING, *next_state, timeout_nanoseconds);
    if result != .OK {
        log_aaudio_error(result, "AAudioStream_waitForStateChange");
        log_error("[aaudio] we will just go ahead assuming the stream will get started...");
    } else {
        assert(next_state == .STARTED);
        log("[aaudio] output stream started!");
    }
}

// The other backends always return true here. This means they are updating audio both from the audio thread and from the main
// thread every time Sound.update() is called. That doesn't seem right to me? If we are already updating from audio thread why do we
// write from main thread as well?
// Either way, here we only update from main thread if we aren't async updating.
backend_needs_async_update_from_main_thread :: () -> bool {
    return !do_async;
}

// Use getFramesRead and getFramesWritten to correctly return the buffered bytes. This now works, but still
// it is probably worth switching to using the data call back in a similar way that core_audio does!
backend_count_buffered_bytes :: () -> (currently_buffered: s64, minimum_prebuffered_bytes: s64) {
    state := AAudioStream_getState(stream);
    if state != .STARTED {
        log("[aaudio] count_buffered_bytes: we were called before the stream is in STARTED state, it is % instead.\n AAudio has some specifics about writing to it's buffer before the stream is started so for now we are just not doing that!", state, flags=.WARNING);
        return 0, 0;
    }

    frames_read    := AAudioStream_getFramesRead(stream);
    frames_written := AAudioStream_getFramesWritten(stream);
    frames_buffered := frames_written - frames_read;
    // log_error("frames read / written == % / % | Buffered: %", frames_read, frames_written, frames_buffered);

    if frames_read == 0 {
        // @Hack Something about the stream configuration is messed up currently. When our stream first starts, AAudio
        // won't start reading from our buffer until it gets nearly full. So, without this, we do the first write,
        // Sound_Player stops requesting anymore data as we have enough buffered, but Aaudio isn't reading the data and
        // we are stuck. Just returning 0 here forces Sound_Player to keep requesting data which fills up the AAudio buffer
        // and gets it started. Once started, it works well enough. Uncomment the above log_error to see this.
        log("[aaudio] count_buffered_bytes: frames_read is still zero, just returning 0 bytes buffered to kick start us!", flags=.WARNING);
        return 0, 0;
    }

    buffered_bytes  := frames_buffered * num_channels * BYTES_PER_SAMPLE;
    minimum_prebuffered_bytes := cast(s64) frames_per_burst * num_channels * BYTES_PER_SAMPLE;

    return buffered_bytes, minimum_prebuffered_bytes;
}

backend_lock_fill_regions :: (bytes_to_lock: s64) -> (Fill_Region_Result, bool) {
    result: Fill_Region_Result;

    state := AAudioStream_getState(stream);
    if state != .STARTED {
        log_error("[aaudio] get_fill_regions has been called before the stream is in STARTED state, it is % instead.\n AAudio has some specifics about writing to it's buffer before the stream is started so for now we are just not doing that!", state);
        return result, false;
    }

    assert(bytes_to_lock <= sample_buffer.count, "[aaudio] get_fill_regions wants asked to lock % bytes, but sample buffer count is %", bytes_to_lock, sample_buffer.count);
    result.buffer0.count = bytes_to_lock;
    result.buffer0.data  = sample_buffer.data;

    return result, true;
}

backend_release_fill_regions :: (result: Fill_Region_Result) {
    state := AAudioStream_getState(stream);
    if state != .STARTED {
        log_error("[aaudio] release_fill_regions has been called before the stream is in STARTED state, it is % instead.\n AAudio has some specifics about writing to it's buffer before the stream is started so for now we are just not doing that!", state);
        return;
    }
    s0 := result.buffer0;

    if !s0.data return;

    data := s0.data;
    bytes_to_write  := s0.count;
    total_frames_to_write := bytes_to_write / (num_channels * BYTES_PER_SAMPLE);

    total_frames_written := 0;

    // Setting a large timeout like this ensures we write everything we are supposed to, but means you can easily
    // cause large hitches here depending on other settings.
    // @TODO It would be better to set small (or zero?) timeout, if we fail to write all frames loop until we do and
    // warn that we are writing too much data / tune how much we write done. The start of something like this is in the
    // else branch.
    USE_TIMEOUT_WHEN_WRITING :: true;
    #if USE_TIMEOUT_WHEN_WRITING {
        TIMEOUT_NANOSECONDS :: 1_000_000;

        frames_written := AAudioStream_write(stream, data, xx total_frames_to_write, TIMEOUT_NANOSECONDS);
        if frames_written < 0  log_aaudio_error(xx frames_written, "AAudioStream_write", true);
        total_frames_written = frames_written;
    } else {
        while true {
            bytes_written := total_frames_written * num_channels * BYTES_PER_SAMPLE;
            d := data + bytes_written;
            frames_to_write := total_frames_to_write - total_frames_written;
            frames_written := AAudioStream_write(stream, d, xx frames_to_write, 0);
            if frames_written < 0 log_aaudio_error(xx frames_written, "AAudioStream_write", true);
            assert(frames_written >= 0);

            log_error("[aaudio]     % frames written!", frames_written);
            total_frames_written += frames_written;
            if total_frames_written == total_frames_to_write break;
        }
    }

    assert(total_frames_written == total_frames_to_write, "AAudioStream_write expected to write % frames, but instead we wrote % frames", total_frames_to_write, total_frames_written);
}

backend_shutdown :: () {
    // I don't think there is any reason to stop the stream before closing it?
    // result := AAudioStream_requestStop(stream);

    result := AAudioStream_close(stream);
    assert(result == .OK);
    free(sample_buffer);
}

// Use the JNI to query for available devices. The device ids returned here can be used in AAudioStreamBuilder_setDeviceId.
backend_get_devices :: () -> [] Output_Device {
    #import "Android/Jni";

    assert(context.android_app != null && context.android_app.activity != null);
    app := context.android_app;

    output_devices: [..] Output_Device;

    // Get the JNIEnv associated with the thread we are being called on, creating one if necessary.
    env: *JNIEnv;
    vm := app.activity.vm;
    vm.*.AttachCurrentThread(vm, *env, null);

    // NOTE(Charles): The NDK does not provide a way to query for devices, so we have to use the JNI to run java code.
    // Atm I am doing everything here in native code, which means we don't have to mess around incorporating java code
    // into the build process. However, it also means we have quite a lot of code, that doesn't do very much.
    // This can be alleviated by making some appropriate helper functions, but also, depending on what kind of JNI stuff
    // ends up being useful, it might make sense to take the hit and define some custom java functions that we can use.
    // Eg, the rough equivalent java code to do the following is:
    //  public void listAudioDevices(Context context) {
    //      AudioManager audioManager = (AudioManager) context.getSystemService(Context.AUDIO_SERVICE);
    //        if (audioManager != null) {
    //            AudioDeviceInfo[] devices = audioManager.getDevices(AudioManager.GET_DEVICES_ALL);
    //            for (AudioDeviceInfo device : devices) {
    //                // Process each device here, eg:
    //                System.out.println("Device: " + device.getProductName());
    //            }
    //        } else {
    //            // Handle the case where audioManager is null
    //            System.out.println("AudioManager not available");
    //        }
    //    }

    // @TODO: Cache the various classes and methods on first call, and only actually do the getDevices call on subsequent
    // calls. (Note that JNI_OnLoad could be used to do such caching once on startup if desired).

    Context_ := env.*.FindClass(env, "android/content/Context");
    if !Context_ {
        log_error("Failed to FindClass the context. Returning no devices");
        return output_devices;
    }

    getSystemService := env.*.GetMethodID(env, Context_, "getSystemService", "(Ljava/lang/String;)Ljava/lang/Object;");
    assert(getSystemService != null);

    AUDIO_SERVICE_id := env.*.GetStaticFieldID(env, Context_, "AUDIO_SERVICE", "Ljava/lang/String;");
    assert(AUDIO_SERVICE_id != null);

    AUDIO_SERVICE := env.*.GetStaticObjectField(env, Context_, AUDIO_SERVICE_id);
    assert(AUDIO_SERVICE != null);

    audio_manager := env.*.CallObjectMethod(env, app.activity.clazz, getSystemService, AUDIO_SERVICE);
    assert(audio_manager != null);

    AudioManager := env.*.FindClass(env, "android/media/AudioManager");
    assert(AudioManager != null);

    getDevices := env.*.GetMethodID(env, AudioManager, "getDevices", "(I)[Landroid/media/AudioDeviceInfo;");
    assert(getDevices != null);

    devices := cast(jobjectArray) env.*.CallObjectMethod(env, audio_manager, getDevices, Get_Devices_Flags.OUTPUTS);
    assert(devices != null);

    num_devices := env.*.GetArrayLength(env, devices);

    for 0..num_devices-1 {
        output_device := array_add(*output_devices);

        device_info := env.*.GetObjectArrayElement(env, devices, xx it);
        assert(device_info != null);

        AudioDeviceInfo := env.*.GetObjectClass(env, device_info);
        assert(AudioDeviceInfo != null);

        // device_index is easy
        getId := env.*.GetMethodID(env, AudioDeviceInfo, "getId", "()I");
        output_device.device_index = env.*.CallIntMethod(env, device_info, getId);

        // For the name, the best thing I can see to do is concatenate product_name <type>
        getType := env.*.GetMethodID(env, AudioDeviceInfo, "getType", "()I");
        device_type := cast(AudioDeviceInfo_Type) env.*.CallIntMethod(env, device_info, getType);

        // NOTE(Charles): The device types I have encountered so far:
        //   BUILTIN_SPEAKER  - The default. Uses both the "ear piece" speaker as well as the speaker on the bottom.
        //   BUILTIN_EARPIECE - Just uses the "ear piece" speaker.
        //   TELEPHONY        - Fails to open stream
        //   BUILTIN_SPEAKER_SAFE - Just uses the speaker at the bottom
        // Maybe all that we should return from here is the BUILTIN_SPEAKER for the device, and any external devices?

        getProductName := env.*.GetMethodID(env, AudioDeviceInfo, "getProductName", "()Ljava/lang/CharSequence;");
        product_name_char_sequence := env.*.CallObjectMethod(env, device_info, getProductName);
        CharSequence := env.*.GetObjectClass(env, product_name_char_sequence);
        toString := env.*.GetMethodID(env, CharSequence, "toString", "()Ljava/lang/String;");
        product_name_jstring := env.*.CallObjectMethod(env, product_name_char_sequence, toString);
        product_name_c_string := env.*.GetStringUTFChars(env, product_name_jstring, null);
        defer env.*.ReleaseStringUTFChars(env, product_name_jstring, product_name_c_string);
        product_name := to_string(product_name_c_string);

        output_device.name = sprint("% %", product_name, device_type);

        #if false {
            getAddress := env.*.GetMethodID(env, AudioDeviceInfo, "getAddress", "()Ljava/lang/String;");
            address_jstring := env.*.CallObjectMethod(env, device_info, getAddress);
            address_c_string := env.*.GetStringUTFChars(env, address_jstring, null);
            defer env.*.ReleaseStringUTFChars(env, product_name_jstring, address_c_string);
            address := to_string(address_c_string);
        }

        // What is this supposed to be? On win32 it is something related to the driver name.
        // output_device.hints = ?
    }

    return output_devices;
}


#scope_file;

// From AudioManager.java
Get_Devices_Flags :: enum s32 {
    NONE    :: 0;
    INPUTS  :: 1;
    OUTPUTS :: 2;
    ALL     :: 3;
};

// From AudioDeviceInfo.java
AudioDeviceInfo_Type :: enum s32 {
    UNKNOWN              :: 0;
    BUILTIN_EARPIECE     :: 1;
    BUILTIN_SPEAKER      :: 2;
    WIRED_HEADSET        :: 3;
    WIRED_HEADPHONES     :: 4;
    LINE_ANALOG          :: 5;
    LINE_DIGITAL         :: 6;
    BLUETOOTH_SCO        :: 7;
    BLUETOOTH_A2DP       :: 8;
    HDMI                 :: 9;
    HDMI_ARC             :: 10;
    USB_DEVICE           :: 11;
    USB_ACCESSORY        :: 12;
    DOCK                 :: 13;
    FM                   :: 14;
    BUILTIN_MIC          :: 15;
    FM_TUNER             :: 16;
    TV_TUNER             :: 17;
    TELEPHONY            :: 18;
    AUX_LINE             :: 19;
    IP                   :: 20;
    BUS                  :: 21;
    USB_HEADSET          :: 22;
    HEARING_AID          :: 23;
    BUILTIN_SPEAKER_SAFE :: 24;
    REMOTE_SUBMIX        :: 25;
    BLE_HEADSET          :: 26;
    BLE_SPEAKER          :: 27;
    ECHO_REFERENCE       :: 28;
    HDMI_EARC            :: 29;
}

log_aaudio_error :: (error_code: AAUDIO, proc_name: string, fatal:=false) #expand {
    c_string := AAudio_convertResultToText(error_code);
    s := tprint("[aaudio] % failed: % (%)", proc_name, to_string(c_string), error_code);
    if fatal  assert(false, s);
    else  log_error(s);
}

do_async := false;

num_channels: s32;
channel_names: [..] string;

// I've copied how alsa is implemented where this is jsut a scratch area the mixer writes to that we then
// write out to the device.
sample_buffer: string;
sample_buffer_num_frames: s64;

// AAudio specific stuff below.

// In frames
buffer_size_in_frames: s32;
buffer_capacity_in_frames: s32;
stream: *AAudioStream;
frames_per_burst: s32;

#import "Android/AAudio";
