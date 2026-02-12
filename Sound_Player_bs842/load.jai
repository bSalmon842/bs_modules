//
// If optional == true, we don't log an error when the file fails to load.
//
load_audio_file :: (filename: string, optional := false) -> Sound_Data {
    #import "File";

    #if OS == .ANDROID {
        Android_File :: #import "Android/File";
        assert(context.android_app != null && context.android_app.activity != null);
        file_data, success := Android_File.read_entire_file(context.android_app.activity.assetManager, filename);
    } else {
        file_data, success := read_entire_file(filename);
    }
    
    if !success {
        if !optional {
            log_error("load_audio_file was unable to read the file: %\n", filename);
        }

        return .{};
    }

    return load_audio_data(filename, file_data);
}

load_audio_data :: (name_for_error_reporting: string, data: string) -> Sound_Data {
    #import "Wav_File";

    result: Sound_Data;

    name := name_for_error_reporting;

    if data.count < 12 {
        log_error("Unable to parse '%' as wav or ogg.\n", name);
        return .{};
    }

    magic0 := get_magic4(data, 0);
    if magic0 == 0x46464952 {
        result.name = copy_string(name);
        result.buffer = data;

        format, samples, success2, extra := get_wav_header(result.buffer);
        if !success2 {
            log_error("Unable to parse '%' as wav.\n", name);
            return result;
        }

        if format.wFormatTag == WAVE_FORMAT_PCM {
            result.type                     = .LINEAR_SAMPLE_ARRAY;
            result.nchannels                = cast(u16) format.nChannels;
            result.nsamples_times_nchannels = samples.count/BYTES_PER_SAMPLE;

            // For now, we only do 16-bit wav files, for code simplicity.
            // It would not be too hard to expand this support, but we should
            // decide whether it's worth the tradeoff.
            if format.wBitsPerSample != BYTES_PER_SAMPLE * 8 {
                log_error("Sound_Player currently doesn't support .wav with % bits per sample (currently, the only supported size is 16 bits).", format.wBitsPerSample);
                return result;
            }
        } else if format.wFormatTag == WAVE_FORMAT_DVI_ADPCM {
            result.type             = .ADPCM_COMPRESSED;
            result.wSamplesPerBlock = extra.wSamplesPerBlock;
            result.nBlockAlign      = format.nBlockAlign;

            result.nchannels = cast(u16) format.nChannels;
            // The value in the FACT chunk is number of samples by time.
            result.nsamples_times_nchannels = extra.wSamplesAccordingToFactChunk * result.nchannels;
        } else {
            log_error("Sound_Player currently doesn't support WAV format %.", format.wFormatTag);
            return result;
        }

        result.samples       = cast(*s16) samples.data;
        result.sampling_rate = cast(u32) format.nSamplesPerSec;

        result.loaded = true;
    } else if magic0 == 0x5367674f {
        result.name   = copy_string(name);
        result.buffer = data;
        result.type   = .OGG_COMPRESSED;

        result.loaded = true;
    } else {
        // Unsupported format.
        log_error("Unknown or unsupported format in %\n", name);
    }

    return result;
}

get_magic4 :: (data: string, base: s64) -> u32 {
    u0 := cast(u32) data[base + 0];
    u1 := cast(u32) data[base + 1];
    u2 := cast(u32) data[base + 2];
    u3 := cast(u32) data[base + 3];

    u := (u3 << 24) | (u2 << 16) | (u1 << 8) | u0;

    return u;
}

// BS842 Specific Functions
pack_sound_data :: (data : *Sound_Data) -> string {
    builder : String_Builder;
    init_string_builder(*builder);

    append_field :: (field : *$T) #expand {
	append(*`builder, cast(*u8) field, size_of(T));
    }

    append_array :: (arr : [] $T) #expand {
	append_field(*arr.count);
	if arr.count > 0 {
	    append(*`builder, cast(*u8) arr.data, size_of(T) * arr.count);
	}
    }

    append_string :: (str : *string) #expand {
	append_field(*str.count);
	if str.count > 0 {
	    append(*`builder, str.data, str.count);
	}
    }
    
    append_string(*data.name);
    append_string(*data.full_path);
    append_field(*data.loaded);
    append_field(*data.skip_load);
    
    append_field(*data.type);
    
    append_field(*data.nsamples_times_nchannels);
    
    append_field(*data.nchannels);
    append_field(*data.sampling_rate);
    
    append_string(*data.buffer);
    // NOTE: The 'samples' field is just a pointer into buffer.data, so we just save the offset from the data pointer
    sampleOffset := cast(s64) (cast(*u8) data.samples - data.buffer.data);
    append_field(*sampleOffset);

    append_field(*data.volume_scale);
    append_field(*data.silence_before_repeat);

    append_string(*data.filename_to_stream_from);
    append_array(data.source_directions);

    append_field(*data.nBlockAlign);
    append_field(*data.wSamplesPerBlock);
    
    return builder_to_string(*builder);
}

unpack_sound_data :: (raw : string) -> Sound_Data {
    // NOTE: The get functions also advance the data ptr, so we can just pass the rawData variable without needing to manually advance
    
    rawData := raw;
    data : Sound_Data;
    
    get_value :: (data : *string, $T : Type) -> T {
	value := (cast(*T) data.data).*;
	advance(data, size_of(T));
	return value;
    }
    
    get_string :: (data : *string) -> string {
	strLen := (cast(*s64) data.data).*;
	advance(data, size_of(s64));
	
	strValue := alloc_string(strLen);
	memcpy(strValue.data, data.data, strLen);
	advance(data, strLen);
	
	return strValue;
    }
    
    data.name = get_string(*rawData);
    data.full_path = get_string(*rawData);
    data.loaded = get_value(*rawData, type_of(data.loaded));
    data.skip_load = get_value(*rawData, type_of(data.skip_load));
    
    data.type = get_value(*rawData, type_of(data.type));
    
    data.nsamples_times_nchannels = get_value(*rawData, type_of(data.nsamples_times_nchannels));
    
    data.nchannels = get_value(*rawData, type_of(data.nchannels));
    data.sampling_rate = get_value(*rawData, type_of(data.sampling_rate));

    data.buffer = get_string(*rawData);
    sampleOffset := get_value(*rawData, s64);
    data.samples = cast(*s16) (cast(*u8) data.buffer.data + sampleOffset);

    data.volume_scale = get_value(*rawData, type_of(data.volume_scale));
    data.silence_before_repeat = get_value(*rawData, type_of(data.silence_before_repeat));

    data.filename_to_stream_from = get_string(*rawData);

    advance(*rawData, size_of(type_of(data.source_directions.count)));
    for * data.source_directions {
	it.* = (cast(*Source_Direction) rawData.data).*;
	advance(*rawData, size_of(Source_Direction));
    }

    data.nBlockAlign = get_value(*rawData, type_of(data.nBlockAlign));
    data.wSamplesPerBlock = get_value(*rawData, type_of(data.wSamplesPerBlock));
    
    return data;
}

