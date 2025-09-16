music: Sound_Data;
click: Sound_Data;

started_music := false;

main :: () {
    base_path := path_strip_filename(get_path_of_running_executable());

    music = load_audio_file(tprint("%/lux_aeterna.ogg", base_path));
    if !music.loaded  exit(1); // Hard-exit for now.

    click = load_audio_file(tprint("%/click.wav", base_path));
    if !click.loaded  exit(1); // Hard-exit for now.

    devices := get_devices();
    print("devices: %\n", devices);

    success := sound_player_init(.{});
    assert(success);

    start_music();

    start_time := current_time_monotonic();
    last_sound_time := start_time;
    while true {
        now := current_time_monotonic();
        if to_milliseconds(now - last_sound_time) > 2000 {
            last_sound_time = now;
            stream := stage_sound(*click, .GENERAL_SFX, true);
            start_playing(stream);
        }
        if !started_music && to_milliseconds(now - start_time) > 5000 {
            start_music();
        }

        Sound.update();
    }

    sound_player_shutdown();
}

start_music :: () {
    stream := make_stream(*music, .MUSIC);
    set_repeating(stream, true);
    stream.play_cursor += 30 * cast(float)(stream.sound_data.sampling_rate) * stream.current_rate;
    start_playing(stream);
    started_music = true;
}

stage_sound :: (data: *Sound_Data, category := Sound_Category.GENERAL_SFX, perturb := true) -> *Sound_Stream {
    stream := make_stream(data, category);

    if perturb {
        stream.user_volume_scale = random_get_within_range(0.5, 1.4);
        stream.rate_scale        = random_get_within_range(0.7, 1.22);
    }

    return stream;
}

using Sound :: #import "Sound_Player"(VERBOSE = false);
#import "Basic";
#import "Input";
#import "Random";
#import "String";
#import "System";

