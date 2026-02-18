MS_PER_SECOND   :: 1000;
US_PER_SECOND   :: 1000000;
NS_PER_SECOND   :: 1000000000;
NS_PER_MS       :: 1000000;
NS_PER_US       :: 1000;

SECONDS_TO_NS :: (s: u64) -> u64    #expand {return s * NS_PER_SECOND;}
NS_TO_SECONDS :: (ns: u64) -> u64   #expand {return ns / NS_PER_SECOND;}
MS_TO_NS      :: (ms: u64) -> u64   #expand {return ms * NS_PER_MS;}
NS_TO_MS      :: (ns: u64) -> u64   #expand {return ns / NS_PER_MS;}
US_TO_NS      :: (us: u64) -> u64   #expand {return us * NS_PER_US;}
NS_TO_US      :: (ns: u64) -> u64   #expand {return ns / NS_PER_US;}


Timer_ID :: u32;
Timer_Callback   :: #type (userdata: *void, timer_id: Timer_ID, interval: u32) -> u32;
NS_Timer_Callback :: #type (userdata: *void, timer_id: Timer_ID, interval: u64) -> u64;

get_ticks                 :: () -> u64                                                                 #foreign SDL3 "SDL_GetTicks";
get_ticks_ns              :: () -> u64                                                                 #foreign SDL3 "SDL_GetTicksNS";
get_performance_counter   :: () -> u64                                                                 #foreign SDL3 "SDL_GetPerformanceCounter";
get_performance_frequency :: () -> u64                                                                 #foreign SDL3 "SDL_GetPerformanceFrequency";
delay                     :: (ms: u32)                                                                 #foreign SDL3 "SDL_Delay";
delay_ns                  :: (ns: u64)                                                                 #foreign SDL3 "SDL_DelayNS";
delay_precise             :: (ns: u64)                                                                 #foreign SDL3 "SDL_DelayPrecise";

add_timer                 :: (interval: u32, callback: Timer_Callback, userdata: *void) -> Timer_ID    #foreign SDL3 "SDL_AddTimer";
add_timer_ns              :: (interval: u64, callback: NS_Timer_Callback, userdata: *void) -> Timer_ID #foreign SDL3 "SDL_AddTimerNS";
remove_timer              :: (id: Timer_ID) -> bool                                                    #foreign SDL3 "SDL_RemoveTimer";
