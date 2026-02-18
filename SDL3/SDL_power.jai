Power_State :: enum s32
{
    ERROR :: -1;
    UNKNOWN;
    ON_BATTERY;
    NO_BATTERY;
    CHARGING;
    CHARGED;
}

get_power_info :: (seconds: *s32, percent: *s32) -> Power_State #foreign SDL3 "SDL_GetPowerInfo";
