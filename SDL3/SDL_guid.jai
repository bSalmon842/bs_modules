GUID :: struct
{
    data: [16] u8;
}

guid_to_string :: (guid: GUID, psz_guid: *u8, cb_guid: s32) #foreign SDL3 "SDL_GUIDToString";
string_to_guid :: (pch_guid: *u8) -> GUID                   #foreign SDL3 "SDL_StringToGUID";
