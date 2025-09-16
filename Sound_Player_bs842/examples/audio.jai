music: Sound_Data;
click: Sound_Data;

main :: () {
    base_path := path_strip_filename(get_path_of_running_executable());
    hwnd := create_window(800, 600, "Audio!");

    music = load_audio_file(tprint("%/lux_aeterna.ogg", base_path));
    if !music.loaded  exit(1); // Hard-exit for now.

    click = load_audio_file(tprint("%/click.wav", base_path));
    if !click.loaded  exit(1); // Hard-exit for now.

    devices := get_devices();
    print("devices: %\n", devices);

    success := sound_player_init(.{});
    assert(success);

    stream := make_stream(*music, .MUSIC);
    set_repeating(stream, true);
    start_playing(stream);

    while true {
        update_window_events();

        quit := false;
        for events_this_frame {
            if it.type == .QUIT quit = true;

            if it.key_pressed && it.key_code == .MOUSE_BUTTON_LEFT {
                stream := stage_sound(*click, .GENERAL_SFX, true);
                start_playing(stream);
            }
        }

        if quit then break;

        Sound.update();
    }

    sound_player_shutdown();
}

stage_sound :: (data: *Sound_Data, category := Sound_Category.GENERAL_SFX, perturb := true) -> *Sound_Stream {
    stream := make_stream(data, category);

    if perturb {
        stream.user_volume_scale = random_get_within_range(0.5, 1.4);
        stream.rate_scale        = random_get_within_range(0.7, 1.22);
    }

    return stream;
}

using Sound :: #import "Sound_Player";
#import "Basic";
#import "Input";
#import "Random";
#import "String";
#import "System";
#import "Window_Creation";

