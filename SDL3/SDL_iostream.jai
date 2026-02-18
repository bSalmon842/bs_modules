IO_Stream :: void;

load_file :: (file: *u8, data_size: *u64) -> *void #foreign SDL3 "SDL_LoadFile";
