// These are paths for the Vulkan headers and libraries used by the Vulkan module distributed with the compiler.
// This is useful for generating bindings for libraries that depend on Vulkan.

Vulkan_Paths :: struct {
    include: string;

    import_library: string;
    shared_library: string;
}

VULKAN_PATHS :: #run,stallable -> Vulkan_Paths {

    #if OS == .WINDOWS {
        import_library := tprint("C:/work/bs_modules/Vulkan_1_3/win/vulkan-1.lib");
        shared_library := tprint("C:/work/bs_modules/Vulkan_1_3/win/vulkan-1.dll");
        return .{include = "C:/work/bs_modules/Vulkan_1_3/source", import_library = import_library, shared_library = shared_library};
    } else {
        return .{}; //.{include = vulkan_source_path};
    }
};

#import "Basic";
#import "Compiler";
#import "File_Utilities";
#import "System";
