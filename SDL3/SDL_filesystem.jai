EnumerationResult :: enum {
    CONTINUE;
    SUCCESS;
    FAILURE;
}

EnumerateDirectoryCallback :: #type (userData : *void, dirName : *u8, fName : *u8) -> EnumerationResult #c_call;

enumerate_directory :: (path : *u8, callback : EnumerateDirectoryCallback, userData : *void) -> bool #foreign SDL3 "SDL_EnumerateDirectory";

get_base_path :: () -> *u8 #foreign SDL3 "SDL_GetBasePath";

PathType :: enum {
    NONE;
    FILE;
    DIRECTORY;
    OTHER;
}

PathInfo :: struct {
    type : PathType;
    size : u64;
    createTime : s64;
    modifyTime : s64;
    accessTime : s64;
}

get_path_info :: (path : *u8, info : *PathInfo) -> bool #foreign SDL3 "SDL_GetPathInfo";
