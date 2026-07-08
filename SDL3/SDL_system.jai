FormFactor :: enum {
    UNKNOWN;
    DESKTOP;
    LAPTOP;
    PHONE;
    TABLET;
    CONSOLE;
    HANDHELD;
    WATCH;
    TV;
    HEADSET;
    CAR;
}

get_android_internal_storage_path :: () -> *u8   #foreign SDL3 "SDL_GetAndroidInternalStoragePath";
get_android_cache_path            :: () -> *u8   #foreign SDL3 "SDL_GetAndroidCachePath";
get_android_activity              :: () -> *void #foreign SDL3 "SDL_GetAndroidActivity";
get_android_jni_env               :: () -> *void #foreign SDL3 "SDL_GetAndroidJNIEnv";
get_android_sdk_version           :: () -> s32   #foreign SDL3 "SDL_GetAndroidSDKVersion";

