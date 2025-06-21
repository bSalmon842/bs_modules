#run,stallable {
    set_build_options_dc(.{do_output=false});
    if !generate_all_bindings() {
        compiler_set_workspace_status(.FAILED);
    }
}

generate_all_bindings :: () -> bool {
    available_flag_bits = .{};

    output_filename: string = ---;

    os := OS;
    options := get_build_options();
    if array_find(options.compile_time_command_line, "android") then os = .ANDROID;
    
    opts: Generate_Bindings_Options;
    {
	opts.os = os;
        using opts;

        if os == .WINDOWS {
            output_filename = "ktx_windows.jai";
            array_add(*libpaths, "windows");
            array_add(*libnames, "ktx");
            strip_flags = 0;
	    
	    array_add(*source_files, "include/ktx.h");
            array_add(*system_include_paths, "./include");
        } else if os == .LINUX {
            output_filename = "ktx_linux.jai";
            array_add(*libpaths, "linux");
            array_add(*libnames, "ktx");
            strip_flags = .INLINED_FUNCTIONS;
	} else if os == .ANDROID {
	    array_add(*libpaths, "android");
            array_add(*libnames, "libktx");
	    output_filename = "ktx_android.jai";
            strip_flags = .INLINED_FUNCTIONS;
	    
	    opts.cpu = .ARM64;

	    array_add(*source_files, "include_android/ktx.h");
            array_add(*system_include_paths, "./include_android");

	    make_directory_if_it_does_not_exist("android");
            ndk := get_ndk_paths();
            target_triple := get_android_target_triple(cpu);
	    array_add(*system_include_paths, tprint("%/usr/include", ndk.sysroot));
	    array_add(*system_include_paths, tprint("%/usr/include/%", ndk.sysroot, target_triple));
        } else {
            assert(false, "OS is not supported.");
        }
	
	array_add(*system_include_paths, ..get_default_system_include_paths());
        array_add(*system_include_paths, ".");

        array_add(*extra_clang_arguments, "-x", "c", "-DWIN32_LEAN_AND_MEAN");

        visitor = libktx_visitor;
    }

    return generate_bindings(opts, output_filename);
}

available_flag_bits: Table(string, *Enum);

OMIT_LIST :: string.[
    "KTX_ETC1S_DEFAULT_COMPRESSION_LEVEL", // This is marked as extern, so this is omitted and re-defined in modules.jai.
];

libktx_visitor :: (decl: *Declaration, parent_decl: *Declaration) -> Declaration_Visit_Result {
    // Omit our OMIT_LIST
    if !parent_decl && array_find(OMIT_LIST, decl.name) {
        //print("OMIT_LIST: %\n", decl.name);
        decl.decl_flags |= .OMIT_FROM_OUTPUT;
        return .STOP;
    }

    if decl.kind == .ENUM {
        en := cast(*Enum)decl;
        if contains(decl.name, "flag_bits_e") || contains(decl.name, "FlagBits") {
            en.flags |= .IS_ENUM_FLAGS;
            en.flags |= .VALUES_IN_HEX;

            // Flags must be ktx_uint32_t == u32
            en.type = context.generator.type_def_u32;

            table_add(*available_flag_bits, decl.name, en);
        }
    }

    if decl.kind == .TYPEDEF && decl.type.type_of_typedef &&  decl.type.type_of_typedef.name == "ktx_uint32_t" {
        print("%, %\n", decl.name, decl.type.type_of_typedef.name);
        flags_name := replace(decl.name, "flags", "flag_bits_e");
        enum_decl, found := table_find(*available_flag_bits, flags_name);

        if !found {
            // Because of course there's an inconsistent naming scheme...
            flags_name := replace(decl.name, "Flags", "FlagBits");
            enum_decl, found = table_find(*available_flag_bits, flags_name);
        }

        if found {
            type := New(CType);
            type.type_of_enum = enum_decl;
            type.size = enum_decl.type.size;
            decl.type = type;
        }
    }

    return .RECURSE;
}

#import "Basic";
#import "Bindings_Generator";
#import "Compiler";
#import "File";
#import "Hash_Table";
#import "String";

#import "BuildCpp";
#import "Toolchains/Android";
