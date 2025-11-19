AT_COMPILE_TIME :: true;

// We don’t ship the source with the compiler. Download a release and update this path if you want to re-compile the library.
SOURCE_PATH :: "src/lz4-1.9.4";
LIB_BASE_NAME :: "liblz4";

DECLARATIONS_TO_OMIT :: string.[
    "LZ4_FREESTANDING",
];

#if AT_COMPILE_TIME {
    #run,stallable {
        set_build_options_dc(.{do_output=false});
        root_options := get_build_options();
        args := root_options.compile_time_command_line;
        if !generate_bindings(args) {
            compiler_set_workspace_status(.FAILED);
        }
    }
} else {
    #import "System";

    main :: () {
        set_working_directory(path_strip_filename(get_path_of_running_executable()));
        args := get_command_line_arguments();
        if !generate_bindings(args) {
            exit(1);
        }
    }
}

#if OS == .WINDOWS {
    PLATFORM_NAME :: "windows";
} else #if OS == .LINUX {
    PLATFORM_NAME :: "linux";
} else #if OS == .MACOS {
    PLATFORM_NAME :: "macos";
} else #if OS == .ANDROID {
    PLATFORM_NAME :: "android";
} else {
    compiler_report(tprint("Unsupported platform: %", OS));
}

generate_bindings :: (args: [] string) -> bool {
    compile        := array_find(args, "-compile");
    compile_debug  := array_find(args, "-debug");

    if compile {
        #if OS == .MACOS {
            UNIVERSAL_DIR :: "macos/lib";
            options := get_build_options();
            success := make_directory_if_it_does_not_exist(UNIVERSAL_DIR, recursive = true);
            success &&= build_lz4_variant(debug = compile_debug, suffix = "_x64",   extra_config_args = .["-DCMAKE_OSX_ARCHITECTURES=x86_64", "-DCMAKE_OSX_DEPLOYMENT_TARGET=10.13"]);
            success &&= build_lz4_variant(debug = compile_debug, suffix = "_arm64", extra_config_args = .["-DCMAKE_OSX_ARCHITECTURES=arm64",  "-DCMAKE_OSX_DEPLOYMENT_TARGET=11.0"]);
            if success {
                // Create a universal binary out of the two arch builds:
                lib_base_x64         := tprint("macos_x64/lib/%",    LIB_BASE_NAME);
                lib_base_arm64       := tprint("macos_arm64/lib/%",  LIB_BASE_NAME);
                universal_lib_base   := tprint("%/%", UNIVERSAL_DIR, LIB_BASE_NAME);
                universal_dylib_path := tprint("%.dylib", universal_lib_base);
                run_or_exit("lipo", "-create", tprint("%.dylib", lib_base_x64), tprint("%.dylib", lib_base_arm64), "-output", universal_dylib_path);
                run_or_exit("lipo", "-create", tprint("%.a", lib_base_x64),     tprint("%.a", lib_base_arm64),     "-output", tprint("%.a", universal_lib_base));
                // Fix the dynamic library’s ID since we copied the symlinked short name variant. Otherwise the library still thinks it’s called "liblz4.<version>.dylib" and anything you link against it will look for the versioned library name.
                run_or_exit("install_name_tool", "-id", tprint("@rpath/%.dylib", LIB_BASE_NAME), universal_dylib_path);
            }
            // @Incomplete: Automatically copy "include" directory from one of the arch build install dirs to the universal dir. I’ve done that by hand for now. -rluba, 2024-04-24
        } else {
            success := build_lz4_variant(debug = compile_debug);
            #if OS == .WINDOWS {
                // We're savages and want the dll next to the lib, want the real lib instead of the dll's import library, and want the same file name across platforms. Savagery!
                success &&= file_move("windows/bin/lz4.dll",        tprint("windows/lib/%.dll", LIB_BASE_NAME));
                success &&= file_move("windows/lib/lz4_static.lib", tprint("windows/lib/%.lib", LIB_BASE_NAME));
                success &&= delete_directory("windows/bin");
                success &&= file_delete("windows/lib/lz4.lib");
            }
        }
        if !success return false;
	}

    opts: Generate_Bindings_Options;
    {
        using opts;

		#if OS == {
            case .WINDOWS; array_add(*library_search_paths, "windows");
            case .LINUX;   array_add(*library_search_paths, "linux");
            case .MACOS;   array_add(*library_search_paths, "macos");
            case .ANDROID;   array_add(*library_search_paths, "android");
            case; assert(false);
		}

        generate_library_declarations = false;
        footer = tprint(FOOTER_TEMPLATE, LIB_BASE_NAME);

		include_path                  := tprint("%/include", PLATFORM_NAME);
        array_add(*library_search_paths, tprint("%/lib",     PLATFORM_NAME));
        array_add(*libraries,            .{filename="liblz4"});
        array_add(*include_paths,        include_path);
        array_add(*source_files,
            tprint("%/lz4.h", include_path),
            tprint("%/lz4hc.h", include_path),
        );

        alias_original_enum_names           = false;
        log_stripped_declarations           = false;
        generate_compile_time_struct_checks = false;

        visitor   = lz4_visitor;
    }

    return generate_bindings(opts, "bindings.jai");
}

build_lz4_variant :: (debug: bool, extra_config_args: [] string = .[], suffix := "") -> bool {
    build_type := ifx debug then "Debug" else "Release";

	install_dir := join(PLATFORM_NAME, suffix,, temp);
    success := make_directory_if_it_does_not_exist(install_dir);
    if !success {
        log_error("Could not create directory \"%\"\n", install_dir);
		return false;
    }

	absolute_install_dir := get_absolute_path(install_dir);
	assert(absolute_install_dir != "");

    absolute_build_dir := join(absolute_install_dir, "_build");
    log("Configuring lz4... \"%\" -> \"%\"", absolute_build_dir, absolute_install_dir);
	if file_exists(absolute_build_dir) {
		success := delete_directory(absolute_build_dir);
		if !success {
			log_error("Could not delete old build directory");
			return false;
		}
	}
    success = make_directory_if_it_does_not_exist(absolute_build_dir);
    if !success {
        log_error("Could not create directory \"%\"\n", absolute_build_dir);
		return false;
    }

	absolute_lz4_path := get_absolute_path(SOURCE_PATH);
    config_command: [..] string;
    array_add(*config_command,
		"cmake",
		tprint("%/build/cmake", absolute_lz4_path),
        "-DLZ4_BUILD_CLI=OFF",
        "-DLZ4_BUILD_LEGACY_LZ4C=OFF",
        "-DBUILD_SHARED_LIBS=ON",
        "-DBUILD_STATIC_LIBS=ON",
        tprint("-DCMAKE_INSTALL_PREFIX=%", absolute_install_dir),
        tprint("-DCMAKE_PREFIX_PATH=%",    install_dir),
	);
    array_add(*config_command, ..extra_config_args);

    array_add(*config_command, tprint("-DCMAKE_BUILD_TYPE=%", build_type));
    #if OS == .WINDOWS {
        array_add(*config_command, tprint("-DCMAKE_CONFIGURATION_TYPES=%", build_type));
    }

    run_or_exit(..config_command, working_directory = absolute_build_dir);
    log("Done configuring lz4");

    log("Building lz4…");
    build_command: [..] string;
    array_add(*build_command, "cmake", "--build", absolute_build_dir, "--target", "install");
    if OS == .WINDOWS {
        array_add(*build_command, tprint("--config=%", build_type));
    }

    run_or_exit(..build_command);
	log("Done building lz4");

	return true;
}

run_or_exit :: (command: .. string, working_directory := "") -> string {
    // Enable this to see the commands being executed.
    // Might be useful if, for example, you need to compile LLVM on a platform where we don’t have a Jai compiler yet and want to do it manually.
    // log("Executing command \"%\" in directory \"%\"\n", join(..command, separator = " "), working_directory);

    result, output_string, error_string := run_command(..command, working_directory = working_directory, capture_and_return_output = true, print_captured_output = true);
    defer {
        free(error_string);
    }
    if result.exit_code != 0 {
        log_error("Could not run command \"%\" in directory \"%\". Exit code: %\nError:\n%", get_quoted_command_string(command), working_directory, result.exit_code, error_string);
        // if !LIVE_OUTPUT {
        //     log_error("Output:\n%", output_string);
        // }
        exit(1);
    }
    return output_string;
}


lz4_visitor :: (decl: *Declaration, parent_decl: *Declaration) -> Declaration_Visit_Result {
    if !parent_decl && array_find(DECLARATIONS_TO_OMIT, decl.name) {
        decl.decl_flags |= .OMIT_FROM_OUTPUT;
        return .STOP;
    }
    return .RECURSE;
}

#import "Basic";
#import "Bindings_Generator";
#import "Compiler";
#import "File";
#import "File_Utilities";
#import "String";
#import "Process";

FOOTER_TEMPLATE :: #string END

#if OS == .WINDOWS  %1 :: #library "windows/lib/%1";
#if OS == .MACOS    %1 :: #library "macos/lib/%1";
#if OS == .LINUX    %1 :: #library "linux/lib/%1";
#if OS == .ANDROID  %1 :: #library "android/lib/%1";

END


