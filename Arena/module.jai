/*
Module: BS842 Arena
File: module.jai
Author: Brock Salmon
Created: 11FEB2024
Last Edit: 01MAR2024
*/

#module_parameters(IS_DEV := false);

KILOBYTES :: (size : u64) -> u64 #must #expand { return size * 1024; }
MEGABYTES :: (size : u64) -> u64 #must #expand { return KILOBYTES(size) * 1024; }
GIGABYTES :: (size : u64) -> u64 #must #expand { return MEGABYTES(size) * 1024; }

Memory_Arena :: struct {
    mem : *u8;
    size : u64;
    used : u64;
}

alloc_arena :: (size : u64, logCallLoc := #caller_location) -> *Memory_Arena #must {
    arena := New(Memory_Arena);
    arena.mem = mmap_os(size);
    arena.size = size;
    arena.used = 0;
    
    return arena;
}

free_arena :: (arena : *Memory_Arena, logCallLoc := #caller_location) {
    unmap_os(arena.mem, arena.size);
    free(arena);
}

push_array :: (arena : *Memory_Arena, $T : Type, count : u64, zero := true) -> [] T #expand {
    result : [] T;
    result.data = push_size(arena, size_of(T) * count, zero);
    result.count = count;
    return result;
}

push_struct :: (arena : *Memory_Arena, $T : Type, zero := true) -> *T #expand {
    return cast(*T) push_size(arena, size_of(T), zero);
}

push_size :: (arena : *Memory_Arena, size : u64, zero := true) -> *u8 #expand {
    assert((arena.used + size) <= arena.size);
    result : *u8 = arena.mem + arena.used;
    arena.used += size;
    ifx zero then memset(result, 0, cast(s64) size);
    return result;
}

#scope_module

// Taken from Default_Allocator
#if OS == .WINDOWS {
    VirtualAlloc :: (lpAddress: *void, dwSize: u64, flAllocationType: u32, flProtect: u32) -> *void #foreign kernel32;
    VirtualFree :: (lpAddress: *void, dwSize: u64, dwFreeType: u32) -> s32 #foreign kernel32;
    
    mmap_os :: (size: u64) -> *void {
        // Ok to MEM_COMMIT - according to MSDN, "actual physical pages are not allocated unless/until the virtual addresses are actually accessed"
        MEM_COMMIT ::  0x00001000;
        MEM_RESERVE :: 0x00002000;
        PAGE_READWRITE :: 0x04;
        ptr := VirtualAlloc(null, xx size, MEM_RESERVE | MEM_COMMIT, PAGE_READWRITE);
        if !ptr {
            assert(ptr != null, "Failed to map virtual memory block");
            return null;
        }
        return ptr;
    }
    
    unmap_os :: (address: *void, release: u64) {
        MEM_RELEASE ::  0x00008000;
        if !VirtualFree(address, 0, MEM_RELEASE) {
            assert(false, "Failed to unmap virtual memory block");
        }
    }
} else #if OS == .LINUX || OS == .MACOS || OS == .ANDROID {
    mmap_os :: (size: u64) -> *void {
        PROT_READ  :: 0x01;
        PROT_WRITE :: 0x02;
        prot : s32 : PROT_READ | PROT_WRITE;

        MAP_PRIVATE ::   0x0002;
        #if OS == .MACOS {
            MAP_ANONYMOUS :: 0x1000;
        } else {
            MAP_ANONYMOUS :: 0x0020;
        }

        flags : s32 : MAP_PRIVATE | MAP_ANONYMOUS;

        #if OS == .MACOS {
            VM_MAKE_TAG :: (val: s32) -> s32 { return val << 24; }
            fd := cast(s32) VM_MAKE_TAG(240);
            ptr, error := mmap(null, xx size, prot, flags, fd, 0);
        } else {
            ptr, error := mmap(null, xx size, prot, flags, -1, 0);
        }

        MAP_FAILED :: cast(*void) -1;
        ENOMEM :: 12;
        if ptr == MAP_FAILED || !ptr {
            if error != ENOMEM
                assert((ptr != MAP_FAILED) && ptr, "Failed to map virtual memory block");
            return null;
        }
        return ptr;
    }
    
    unmap_os :: (address: *void, release: s64) {
        if release {
            if munmap(address, xx release)
                assert(false, "Failed to unmap virtual memory block");
        }
    }
    
    munmap :: (addr: *void, len: s64) -> s32 {
        result : s32 = ---;
        #if OS == .MACOS {
            SYS_MUNMAP :: SYSCALL_BASE + 73;
        } else {
            SYS_MUNMAP :: 11;
        }
        #asm SYSCALL_SYSRET {
            mov.q rcx: gpr === c,  0;
            mov.q r11: gpr === 11, 0;
            mov.q rax: gpr === a,  SYS_MUNMAP;
            mov.q rdi: gpr === di, addr;
            mov.q rsi: gpr === si, len;
            syscall rcx, r11, rax, rdi, rsi;
            mov.d result, rax;
        }
        return result;
    }
    
    mmap :: (addr: *void, len: s64, prot: s32, flags: s32, fildes: s32, offset: s64) -> *void, error: s64 {
        result : s64 = ---;
        #if OS == .MACOS {
            SYS_MMAP :: SYSCALL_BASE + 197;
        } else {
            SYS_MMAP :: 9;
        }

        #asm SYSCALL_SYSRET {
            mov.q rcx: gpr === c,  0;
            mov.q r11: gpr === 11, 0;
            mov.q rax: gpr === a,  SYS_MMAP;
            mov.q rdi: gpr === di, addr;
            mov.q rsi: gpr === si, len;
            mov.d rdx: gpr === d,  prot;
            mov.d r10: gpr === 10, flags;
            mov.q r9:  gpr === 9,  offset;
            mov.d r8:  gpr === 8,  fildes;
            syscall rcx, r11, rax, rdi, rsi, rdx, r10, r9, r8;
            mov.q result, rax;
        }
        if -4096 < result && result < 0
            return null, -result;
        else
            return cast(*void)result, 0;
    }
}

#import "Basic";