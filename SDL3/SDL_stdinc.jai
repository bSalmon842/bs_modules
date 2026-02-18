FLT_EPSILON :: 1.1920928e-07;
PI_D : float64 : 3.141592653589793238462643383279502884;
PI_F : float32 : 3.1415927;

Function_Pointer :: #type ();

strstr      :: (haystack: *u8, needle: *u8) -> *u8 #foreign SDL3 "SDL_strstr";

free        :: (mem: *void)                        #foreign SDL3 "SDL_free";

fabsf       :: (x: float32) -> float32             #foreign SDL3 "SDL_fabsf";

sin         :: (x: float64) -> float64             #foreign SDL3 "SDL_sin";
sinf        :: (x: float32) -> float32             #foreign SDL3 "SDL_sinf";
cos         :: (x: float64) -> float64             #foreign SDL3 "SDL_cos";
cosf        :: (x: float32) -> float32             #foreign SDL3 "SDL_cosf";

srand       :: (seed: u64)                         #foreign SDL3 "SDL_srand";
rand        :: (n: s32) -> s32                     #foreign SDL3 "SDL_rand";
randf       :: () -> float32                       #foreign SDL3 "SDL_randf";
rand_bits   :: () -> u32                           #foreign SDL3 "SDL_rand_bits";
rand_r      :: (state: *u64, n: s32) -> s32        #foreign SDL3 "SDL_rand_r";
randf_r     :: (state: *u64) -> float32            #foreign SDL3 "SDL_randf_r";
rand_bits_r :: (state: *u64) -> u32                #foreign SDL3 "SDL_rand_bits_r";

FOURCC :: (a: u8, b: u8, c: u8, d: u8) -> u32 #expand
{
    return ((cast(u32) a) << 0) | ((cast(u32) b) << 8) | ((cast(u32) c) << 16) | ((cast(u32) d) << 24);
}
