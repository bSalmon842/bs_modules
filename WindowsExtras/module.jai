/*
Module: BS842 Windows Extras
File: module.jai
Author: Brock Salmon
Created: 01JUL2025
*/

// TODO: Add wide versions of functions/structs

CCHDEVICENAME : u32 : 32;
CCHFORMNAME   : u32 : 32;

PROCESS_MEMORY_COUNTERS :: struct {
    cb                         : u32;
    PageFaultCount             : u32;
    PeakWorkingSetSize         : u64;
    WorkingSetSize             : u64;
    QuotaPeakPagedPoolUsage    : u64;
    QuotaPagedPoolUsage        : u64;
    QuotaPeakNonPagedPoolUsage : u64;
    QuotaNonPagedPoolUsage     : u64;
    PagefileUsage              : u64;
    PeakPagefileUsage          : u64;
}

MONITORINFOEXA :: struct {
    using info : MONITORINFO;
    szDevice : [CCHDEVICENAME] u8;
}

DEVMODEA :: struct {
    dmDeviceName    : [CCHDEVICENAME] u8;
    dmSpecVersion   : u16;
    dmDriverVersion : u16;
    dmSize          : u16;
    dmDriverExtra   : u16;
    dmFields        : u32;

    union {
	using DUMMYSTRUCTNAME : struct {
	    dmOrientation   : s16;
	    dmPaperSize     : s16;
	    dmPaperLength   : s16;
	    dmPaperWidth    : s16;
	    dmScale         : s16;
	    dmCopies        : s16;
	    dmDefaultSource : s16;
	    dmPrintQuality  : s16;
	}
	
	dnPosition : POINT;
	
	using DUMMYSTRUCTNAME2 : struct {
	    dmPosition : POINT;
	    dmDisplayOrientation : DWORD;
	    dmDisplayFixedOutput : DWORD;
	}
    }

    dmColor       : s16;
    dmDuplex      : s16;
    dmYResolution : s16;
    dmTTOption    : s16;
    dmCollate     : s16;
    dmFormName    : [CCHFORMNAME] u8;
    dmLogPixels   : u16;
    dmBitsPerPel  : u32;
    dmPelsWidth   : u32;
    dmPelsHeight  : u32;

    union {
	dmDisplayFlags : u32;
	dmNup          : u32;
    }

    dmDisplayFrequency : u32;
    dmICMMethod        : u32;
    dmICMIntent        : u32;
    dmMediaType        : u32;
    dmDitherType       : u32;
    dmReserved1        : u32;
    dmReserved2        : u32;
    dmPanningWidth     : u32;
    dmPanningHeight    : u32;
}

ENUM_CURRENT_SETTINGS : u32 : cast,no_check(u32) -1;
ENUM_REGISTRY_SETTINGS : u32 : cast,no_check(u32) -2;

EnumDisplaySettingsA :: (lpszDeviceName : LPCSTR, iModeNum : u32, lpDevMode : *DEVMODEA) -> BOOL #foreign user32;
GetCurrentProcess :: () -> HANDLE #foreign kernel32;
GetMonitorInfoA :: (hMonitor : HMONITOR, lpmi : *MONITORINFOEXA) -> BOOL #foreign user32;
GetProcessMemoryInfo :: (Process : HANDLE, ppsmemCounters : *PROCESS_MEMORY_COUNTERS, cb : u32) -> BOOL #foreign psapi;

#scope_module
#import "Windows";

kernel32 :: #system_library "kernel32";
psapi    :: #system_library "psapi";
user32   :: #system_library "user32";

