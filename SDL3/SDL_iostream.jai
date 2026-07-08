IO_Status :: enum {
    READY;
    ERROR;
    EOF;
    NOT_READY;
    READONLY;
    WRITEONLY;
}

IO_Whence :: enum {
    SET;
    CUR;
    END;
}

IO_Stream :: void;

io_from_file :: (file : *u8, mode : *u8) -> *IO_Stream                      #foreign SDL3 "SDL_IOFromFile";
close_io     :: (ctx : *IO_Stream) -> bool                                  #foreign SDL3 "SDL_CloseIO";
get_io_size  :: (ctx : *IO_Stream) -> s64                                   #foreign SDL3 "SDL_GetIOSize";
seek_io      :: (ctx : *IO_Stream, offset : s64, whence : IO_Whence) -> s64 #foreign SDL3 "SDL_SeekIO";
read_io      :: (ctx : *IO_Stream, ptr : *void, size : u32) -> u32          #foreign SDL3 "SDL_ReadIO";
write_io     :: (ctx : *IO_Stream, ptr : *void, size : u32) -> u32          #foreign SDL3 "SDL_WriteIO";
load_file    :: (file: *u8, data_size: *u64) -> *void                       #foreign SDL3 "SDL_LoadFile";
