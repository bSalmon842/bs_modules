// config
COMPILE_TIME                   :: true;
COMPILE_LIBRARY                :: true;
vulkan_bootstrap_h_location    :: "source/CVkBootstrap.h";
vulkan_bootstrap_cpp_locations :: string.[
    "source/VkBootstrap.cpp",
    "source/CVkBootstrap.cpp",
];
vulkan_bootstrap_lib_path      :: ".";
vulkan_bootstrap_lib_name      :: "VKBootstrap";
vulkan_bootstrap_lib_ident     :: "libvkbootstrap";
vulkan_include_path            :: "C:/VulkanSDK/1.3.268.0/Include";

#if COMPILE_TIME {
    #run,stallable {
        #if COMPILE_LIBRARY {
            build_cpp_dynamic_lib(vulkan_bootstrap_lib_name, ..vulkan_bootstrap_cpp_locations, debug=true, extra=.[tprint("/I%", vulkan_include_path), "/std:c++20"], library_files=.["C:/work/bs_modules/Vulkan_1_3/win/vulkan-1.lib"]);
        }
        
        set_build_options_dc(.{do_output = false});
        if !generate_bindings() {
            compiler_set_workspace_status(.FAILED);
        }
    }
} else {
    #import "System";
    
    main :: () {
        set_working_directory(path_strip_filename(get_path_of_running_executable()));
        if !generate_bindings() {
            exit(1);
        }
    }
}

OMIT_LIST :: string.[

];

generate_bindings :: () -> bool {
    output_filename: string;
    opts: Generate_Bindings_Options;
    
    {
        using opts;
        
        array_add(*libnames, vulkan_bootstrap_lib_name);
        
        #if OS == .WINDOWS {
            output_filename = "generated_windows.jai";        
        } else #if OS == .LINUX {
            output_filename = "generated+linux.jai";
        } else #if OS == .MACOS {
            // @ToDo
            assert(false);
        } else {
            assert(false);
        }
        
        if vulkan_bootstrap_lib_path then array_add(*libpaths, vulkan_bootstrap_lib_path);
        array_add(*extra_clang_arguments, "-x", "c++", "-DPLEASE_EXPORT=1",  "-DWIN32_LEAN_AND_MEAN", "-Wc++17-extensions");
        // array_add(*flatten_namespaces, "vkb");
        
        array_add(*source_files, vulkan_bootstrap_h_location);
        array_add(*system_include_paths, vulkan_include_path);
        
        generate_library_declarations = false;
        
        will_print_bindings = () {
            // Change the library name to be the same on all platforms
            // so that we don't have to generate identical bindings for every platform just because the library name is different.
            context.generator.libraries[0].name = vulkan_bootstrap_lib_ident;
        };
        footer = VK_BOOTSTRAP_FOOTER;
        
        visitor = vulkan_bootstrap_visitor;
        log_stripped_declarations = false;
        generate_compile_time_struct_checks = false;
    }
    
    return generate_bindings(opts, output_filename);
}

vulkan_bootstrap_visitor :: (decl: *Declaration, parent_decl: *Declaration) -> Declaration_Visit_Result {
    // Omit header definitions (ex: VULKAN_H_)
    // if decl.kind == .MACRO_DEFINITION && ends_with(decl.name, "_H_") {
    //     decl.decl_flags |= .OMIT_FROM_OUTPUT;
    //     return .STOP;
    // }
    
    // if !parent_decl && array_find(OMIT_LIST, decl.name) {
    //     decl.decl_flags |= .OMIT_FROM_OUTPUT;
    //     return .STOP;
    // }
    
    return .RECURSE;
}

#scope_file

#import "Basic";
#import "Compiler";
#import "Bindings_Generator";
#import "String";
#import "File";
#import "Check";
#import "Hash_Table";
#import "BuildCpp";

VK_BOOTSTRAP_FOOTER :: #run tprint(#string DONE 
#import "Vulkan";

#if OS == .WINDOWS {
    % :: #library "%";
} else #if OS == .LINUX {
    % :: #library "%";
} else {
    #assert(false);
}
DONE, 
vulkan_bootstrap_lib_ident, 
vulkan_bootstrap_lib_name,
vulkan_bootstrap_lib_ident, 
vulkan_bootstrap_lib_name,
);