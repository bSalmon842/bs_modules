//
// This file was auto-generated using the following command:
//
// jai generate_bindings.jai
//


InstanceError :: enum s32 {
    NONE                             :: 0;
    VULKAN_UNAVAILABLE               :: 1;
    VULKAN_VERSION_UNAVAILABLE       :: 2;
    VULKAN_VERSION_1_1_UNAVAILABLE   :: 3;
    VULKAN_VERSION_1_2_UNAVAILABLE   :: 4;
    FAILED_CREATE_INSTANCE           :: 5;
    FAILED_CREATE_DEBUG_MESSENGER    :: 6;
    REQUESTED_LAYERS_NOT_PRESENT     :: 7;
    REQUESTED_EXTENSIONS_NOT_PRESENT :: 8;
    WINDOWING_EXTENSIONS_NOT_PRESENT :: 9;
}

PhysicalDeviceError :: enum s32 {
    NONE                              :: 0;
    NO_SURFACE_PROVIDED               :: 1;
    FAILED_ENUMERATE_PHYSICAL_DEVICES :: 2;
    NO_PHYSICAL_DEVICES_FOUND         :: 3;
    NO_SUITABLE_DEVICE                :: 4;
}

QueueError :: enum s32 {
    NONE                       :: 0;
    PRESENT_UNAVAILABLE        :: 1;
    GRAPHICS_UNAVAILABLE       :: 2;
    COMPUTE_UNAVAILABLE        :: 3;
    TRANSFER_UNAVAILABLE       :: 4;
    QUEUE_INDEX_OUT_OF_RANGE   :: 5;
    INVALID_QUEUE_FAMILY_INDEX :: 6;
}

DeviceError :: enum s32 {
    NONE                                                                                 :: 0;
    FAILED_CREATE_DEVICE                                                                 :: 1;
    VKPHYSICALDEVICEFEATURES2_IN_PNEXT_CHAIN_WHILE_USING_ADD_REQUIRED_EXTENSION_FEATURES :: 2;
}

SwapchainError :: enum s32 {
    NONE                                 :: 0;
    SURFACE_HANDLE_NOT_PROVIDED          :: 1;
    FAILED_QUERY_SURFACE_SUPPORT_DETAILS :: 2;
    FAILED_CREATE_SWAPCHAIN              :: 3;
    FAILED_GET_SWAPCHAIN_IMAGES          :: 4;
    FAILED_CREATE_SWAPCHAIN_IMAGE_VIEWS  :: 5;
    REQUIRED_MIN_IMAGE_COUNT_TOO_LOW     :: 6;
    REQUIRED_USAGE_NOT_SUPPORTED         :: 7;
}

SystemInfo_T :: struct {}
SystemInfo :: *SystemInfo_T;

// SystemInfoFunctions
    get_system_info :: (result: *SystemInfo) -> InstanceError #foreign libvkbootstrap "?get_system_info@VkbSystemInfoFunctions@@YA?AW4VkbInstanceError@@PEAPEAUVkbSystemInfo_T@@@Z";
    get_system_info :: (fp_vkGetInstanceProcAddr: PFN_vkGetInstanceProcAddr, result: *SystemInfo) -> InstanceError #foreign libvkbootstrap "?get_system_info@VkbSystemInfoFunctions@@YA?AW4VkbInstanceError@@P6AP6AXXZPEAUVkInstance_T@@PEBD@ZPEAPEAUVkbSystemInfo_T@@@Z";

    delete_system_info :: (system_info: *SystemInfo) -> void #foreign libvkbootstrap "?delete_system_info@VkbSystemInfoFunctions@@YAXPEAPEAUVkbSystemInfo_T@@@Z";

    is_layer_available :: (system_info: SystemInfo, layer_name: *u8) -> bool #foreign libvkbootstrap "?is_layer_available@VkbSystemInfoFunctions@@YA_NPEAUVkbSystemInfo_T@@PEBD@Z";
    is_extension_available :: (system_info: SystemInfo, extension_name: *u8) -> bool #foreign libvkbootstrap "?is_extension_available@VkbSystemInfoFunctions@@YA_NPEAUVkbSystemInfo_T@@PEBD@Z";

    // This will return a slice or array view.
    get_available_layers :: (system_info: SystemInfo, data: **VkLayerProperties, length: *u64) -> void #foreign libvkbootstrap "?get_available_layers@VkbSystemInfoFunctions@@YAXPEAUVkbSystemInfo_T@@PEAPEAUVkLayerProperties@@PEA_K@Z";
    get_available_layers :: inline (system_info: SystemInfo) -> []VkLayerProperties #no_context {
        result: []VkLayerProperties = ---;
        length: u64 = ---;
        get_available_layers(system_info, *result.data, *length);
        result.count = xx length;
        return result;
    }

    // This will return a slice or array view.
    get_available_extensions :: (system_info: SystemInfo, data: **VkExtensionProperties, length: *u64) -> void #foreign libvkbootstrap "?get_available_extensions@VkbSystemInfoFunctions@@YAXPEAUVkbSystemInfo_T@@PEAPEAUVkExtensionProperties@@PEA_K@Z";
    get_available_extensions :: inline (system_info: SystemInfo) -> []VkExtensionProperties #no_context {
        result: []VkExtensionProperties = ---;
        length: u64 = ---;
        get_available_extensions(system_info, *result.data, *length);
        result.count = xx length;
        return result; 
    }

    is_validation_layers_available :: (system_info: SystemInfo) -> bool #foreign libvkbootstrap "?is_validation_layers_available@VkbSystemInfoFunctions@@YA_NPEAUVkbSystemInfo_T@@@Z";
    is_debug_utils_available :: (system_info: SystemInfo) -> bool #foreign libvkbootstrap "?is_debug_utils_available@VkbSystemInfoFunctions@@YA_NPEAUVkbSystemInfo_T@@@Z";

Instance_T :: struct {}
Instance :: *Instance_T;

// InstanceFunctions
    get_vk_instance :: (instance: Instance) -> VkInstance #foreign libvkbootstrap "?get_vk_instance@VkbInstanceFunctions@@YAPEAUVkInstance_T@@PEAUVkbInstance_T@@@Z";
    get_debug_messenger :: (instance: Instance) -> VkDebugUtilsMessengerEXT #foreign libvkbootstrap "?get_debug_messenger@VkbInstanceFunctions@@YAPEAUVkDebugUtilsMessengerEXT_T@@PEAUVkbInstance_T@@@Z";
    get_allocation_callbacks :: (instance: Instance) -> *VkAllocationCallbacks #foreign libvkbootstrap "?get_allocation_callbacks@VkbInstanceFunctions@@YAPEAUVkAllocationCallbacks@@PEAUVkbInstance_T@@@Z";

    destroy_instance :: (instance: *Instance) -> void #foreign libvkbootstrap "?destroy_instance@VkbInstanceFunctions@@YAXPEAPEAUVkbInstance_T@@@Z";

InstanceBuilder_T :: struct {}
InstanceBuilder :: *InstanceBuilder_T;

// InstanceBuilderFunctions
    make_instance_builder :: () -> InstanceBuilder #foreign libvkbootstrap "?make_instance_builder@VkbInstanceBuilderFunctions@@YAPEAUVkbInstanceBuilder_T@@XZ";
    make_instance_builder :: (fp_vkGetInstanceProcAddr: PFN_vkGetInstanceProcAddr) -> InstanceBuilder #foreign libvkbootstrap "?make_instance_builder@VkbInstanceBuilderFunctions@@YAPEAUVkbInstanceBuilder_T@@P6AP6AXXZPEAUVkInstance_T@@PEBD@Z@Z";
    delete_instance_builder :: (builder: *InstanceBuilder) -> void #foreign libvkbootstrap "?delete_instance_builder@VkbInstanceBuilderFunctions@@YAXPEAPEAUVkbInstanceBuilder_T@@@Z";

    // Create a VkInstance. Return a VkbInstanceError if it failed.
    build :: (builder: InstanceBuilder, result: *Instance) -> InstanceError #foreign libvkbootstrap "?build@VkbInstanceBuilderFunctions@@YA?AW4VkbInstanceError@@PEAUVkbInstanceBuilder_T@@PEAPEAUVkbInstance_T@@@Z";
    build :: inline (builder: InstanceBuilder) -> Instance, InstanceError #no_context {
        result: Instance = ---;
        error := build(builder, *result);
        return result, error;
    }

    // Sets the name of the application. Defaults to "" if none is provided.
    set_app_name :: (builder: InstanceBuilder, app_name: *u8) -> void #foreign libvkbootstrap "?set_app_name@VkbInstanceBuilderFunctions@@YAXPEAUVkbInstanceBuilder_T@@PEBD@Z";

    // Sets the name of the engine. Defaults to "" if none is provided.
    set_engine_name :: (builder: InstanceBuilder, engine_name: *u8) -> void #foreign libvkbootstrap "?set_engine_name@VkbInstanceBuilderFunctions@@YAXPEAUVkbInstanceBuilder_T@@PEBD@Z";

    // Sets the version of the application.
    // Should be constructed with VK_MAKE_VERSION or VK_MAKE_API_VERSION.
    set_app_version :: (builder: InstanceBuilder, app_version: u32) -> void #foreign libvkbootstrap "?set_app_version@VkbInstanceBuilderFunctions@@YAXPEAUVkbInstanceBuilder_T@@I@Z";

    // Sets the (major, minor, patch) version of the application.
    set_app_version :: (builder: InstanceBuilder, major: u32, minor: u32, patch: u32 = 0) -> void #foreign libvkbootstrap "?set_app_version@VkbInstanceBuilderFunctions@@YAXPEAUVkbInstanceBuilder_T@@III@Z";

    // Sets the version of the engine.
    // Should be constructed with VK_MAKE_VERSION or VK_MAKE_API_VERSION.
    set_engine_version :: (builder: InstanceBuilder, engine_version: u32) -> void #foreign libvkbootstrap "?set_engine_version@VkbInstanceBuilderFunctions@@YAXPEAUVkbInstanceBuilder_T@@I@Z";

    // Sets the (major, minor, patch) version of the engine.
    set_engine_version :: (builder: InstanceBuilder, major: u32, minor: u32, patch: u32 = 0) -> void #foreign libvkbootstrap "?set_engine_version@VkbInstanceBuilderFunctions@@YAXPEAUVkbInstanceBuilder_T@@III@Z";

    // Require a vulkan API version. Will fail to create if this version isn't available.
    // Should be constructed with VK_MAKE_VERSION or VK_MAKE_API_VERSION.
    require_api_version :: (builder: InstanceBuilder, required_api_version: u32) -> void #foreign libvkbootstrap "?require_api_version@VkbInstanceBuilderFunctions@@YAXPEAUVkbInstanceBuilder_T@@I@Z";

    // Require a vulkan API version. Will fail to create if this version isn't available.
    require_api_version :: (builder: InstanceBuilder, major: u32, minor: u32, patch: u32 = 0) -> void #foreign libvkbootstrap "?require_api_version@VkbInstanceBuilderFunctions@@YAXPEAUVkbInstanceBuilder_T@@III@Z";

    // Overrides required API version for instance creation. Will fail to create if this version isn't available.
    // Should be constructed with VK_MAKE_VERSION or VK_MAKE_API_VERSION.
    set_minimum_instance_version :: (builder: InstanceBuilder, minimum_instance_version: u32) -> void #foreign libvkbootstrap "?set_minimum_instance_version@VkbInstanceBuilderFunctions@@YAXPEAUVkbInstanceBuilder_T@@I@Z";

    // Overrides required API version for instance creation. Will fail to create if this version isn't available.
    set_minimum_instance_version :: (builder: InstanceBuilder, major: u32, minor: u32, patch: u32 = 0) -> void #foreign libvkbootstrap "?set_minimum_instance_version@VkbInstanceBuilderFunctions@@YAXPEAUVkbInstanceBuilder_T@@III@Z";

    // Adds a layer to be enabled. Will fail to create an instance if the layer isn't available.
    enable_layer :: (builder: InstanceBuilder, layer_name: *u8) -> void #foreign libvkbootstrap "?enable_layer@VkbInstanceBuilderFunctions@@YAXPEAUVkbInstanceBuilder_T@@PEBD@Z";

    // Adds an extension to be enabled. Will fail to create an instance if the extension isn't available.
    enable_extension :: (builder: InstanceBuilder, extension_name: *u8) -> void #foreign libvkbootstrap "?enable_extension@VkbInstanceBuilderFunctions@@YAXPEAUVkbInstanceBuilder_T@@PEBD@Z";

    enable_extensions :: (builder: InstanceBuilder, extensions_data: **u8, array_length: u64) -> void #foreign libvkbootstrap "?enable_extensions@VkbInstanceBuilderFunctions@@YAXPEAUVkbInstanceBuilder_T@@PEAPEBD_K@Z";
    enable_extensions :: (builder: InstanceBuilder, count: u64, extensions: **u8) -> void #foreign libvkbootstrap "?enable_extensions@VkbInstanceBuilderFunctions@@YAXPEAUVkbInstanceBuilder_T@@_KPEAPEBD@Z";

    // Headless Mode does not load the required extensions for presentation. Defaults to true.
    set_headless :: (builder: InstanceBuilder, headless := true) -> void #foreign libvkbootstrap "?set_headless@VkbInstanceBuilderFunctions@@YAXPEAUVkbInstanceBuilder_T@@_N@Z";

    // Enables the validation layers. Will fail to create an instance if the validation layers aren't available.
    enable_validation_layers :: (builder: InstanceBuilder, require_validation := true) -> void #foreign libvkbootstrap "?enable_validation_layers@VkbInstanceBuilderFunctions@@YAXPEAUVkbInstanceBuilder_T@@_N@Z";

    // Checks if the validation layers are available and loads them if they are.
    request_validation_layers :: (builder: InstanceBuilder, enable_validation := true) -> void #foreign libvkbootstrap "?request_validation_layers@VkbInstanceBuilderFunctions@@YAXPEAUVkbInstanceBuilder_T@@_N@Z";

    // Use a default debug callback that prints to standard out.
    use_default_debug_messenger :: (builder: InstanceBuilder) -> void #foreign libvkbootstrap "?use_default_debug_messenger@VkbInstanceBuilderFunctions@@YAXPEAUVkbInstanceBuilder_T@@@Z";

    // Provide a user defined debug callback.
    set_debug_callback :: (builder: InstanceBuilder, callback: PFN_vkDebugUtilsMessengerCallbackEXT) -> void #foreign libvkbootstrap "?set_debug_callback@VkbInstanceBuilderFunctions@@YAXPEAUVkbInstanceBuilder_T@@P6AIW4VkDebugUtilsMessageSeverityFlagBitsEXT@@IPEBUVkDebugUtilsMessengerCallbackDataEXT@@PEAX@Z@Z";

    // Sets the void* to use in the debug messenger - only useful with a custom callback
    set_debug_callback_user_data_pointer :: (builder: InstanceBuilder, user_data_pointer: *void) -> void #foreign libvkbootstrap "?set_debug_callback_user_data_pointer@VkbInstanceBuilderFunctions@@YAXPEAUVkbInstanceBuilder_T@@PEAX@Z";

    // Set what message severity is needed to trigger the callback.
    set_debug_messenger_severity :: (builder: InstanceBuilder, severity: VkDebugUtilsMessageSeverityFlagsEXT) -> void #foreign libvkbootstrap "?set_debug_messenger_severity@VkbInstanceBuilderFunctions@@YAXPEAUVkbInstanceBuilder_T@@I@Z";

    // Add a message severity to the list that triggers the callback.
    add_debug_messenger_severity :: (builder: InstanceBuilder, severity: VkDebugUtilsMessageSeverityFlagsEXT) -> void #foreign libvkbootstrap "?add_debug_messenger_severity@VkbInstanceBuilderFunctions@@YAXPEAUVkbInstanceBuilder_T@@I@Z";

    // Set what message type triggers the callback.
    set_debug_messenger_type :: (builder: InstanceBuilder, type: VkDebugUtilsMessageTypeFlagsEXT) -> void #foreign libvkbootstrap "?set_debug_messenger_type@VkbInstanceBuilderFunctions@@YAXPEAUVkbInstanceBuilder_T@@I@Z";

    // Add a message type to the list of that triggers the callback.
    add_debug_messenger_type :: (builder: InstanceBuilder, type: VkDebugUtilsMessageTypeFlagsEXT) -> void #foreign libvkbootstrap "?add_debug_messenger_type@VkbInstanceBuilderFunctions@@YAXPEAUVkbInstanceBuilder_T@@I@Z";

    // Disable some validation checks.
    // Checks: All, and Shaders
    add_validation_disable :: (builder: InstanceBuilder, check: VkValidationCheckEXT) -> void #foreign libvkbootstrap "?add_validation_disable@VkbInstanceBuilderFunctions@@YAXPEAUVkbInstanceBuilder_T@@W4VkValidationCheckEXT@@@Z";

    // Enables optional parts of the validation layers.
    // Parts: best practices, gpu assisted, and gpu assisted reserve binding slot.
    add_validation_feature_enable :: (builder: InstanceBuilder, enable: VkValidationFeatureEnableEXT) -> void #foreign libvkbootstrap "?add_validation_feature_enable@VkbInstanceBuilderFunctions@@YAXPEAUVkbInstanceBuilder_T@@W4VkValidationFeatureEnableEXT@@@Z";

    // Disables sections of the validation layers.
    // Options: All, shaders, thread safety, api parameters, object lifetimes, core checks, and unique handles.
    add_validation_feature_disable :: (builder: InstanceBuilder, disable: VkValidationFeatureDisableEXT) -> void #foreign libvkbootstrap "?add_validation_feature_disable@VkbInstanceBuilderFunctions@@YAXPEAUVkbInstanceBuilder_T@@W4VkValidationFeatureDisableEXT@@@Z";

    // Provide custom allocation callbacks.
    set_allocation_callbacks :: (builder: InstanceBuilder, callbacks: *VkAllocationCallbacks) -> void #foreign libvkbootstrap "?set_allocation_callbacks@VkbInstanceBuilderFunctions@@YAXPEAUVkbInstanceBuilder_T@@PEAUVkAllocationCallbacks@@@Z";

PhysicalDevice_T :: struct {}
PhysicalDevice :: *PhysicalDevice_T;

// PhysicalDeviceFunctions
    get_name :: (pdevice: PhysicalDevice, data: **u8, length: *u64) -> void #foreign libvkbootstrap "?get_name@VkbPhysicalDeviceFunctions@@YAXPEAUVkbPhysicalDevice_T@@PEAPEBDPEA_K@Z";
    get_name :: inline (pdevice: PhysicalDevice) -> string #no_context {
        result: string = ---;
        length: u64 = ---;
        get_name(pdevice, *result.data, *length);
        result.count = xx length;
        return result;
    }
        
    get_vk_physical_device :: (pdevice: PhysicalDevice) -> VkPhysicalDevice #foreign libvkbootstrap "?get_vk_physical_device@VkbPhysicalDeviceFunctions@@YAPEAUVkPhysicalDevice_T@@PEAUVkbPhysicalDevice_T@@@Z";

    get_vk_device_features :: (pdevice: PhysicalDevice) -> VkPhysicalDeviceFeatures #foreign libvkbootstrap "?get_vk_device_features@VkbPhysicalDeviceFunctions@@YA?AUVkPhysicalDeviceFeatures@@PEAUVkbPhysicalDevice_T@@@Z";
    get_vk_device_properties :: (pdevice: PhysicalDevice) -> VkPhysicalDeviceProperties #foreign libvkbootstrap "?get_vk_device_properties@VkbPhysicalDeviceFunctions@@YA?AUVkPhysicalDeviceProperties@@PEAUVkbPhysicalDevice_T@@@Z";
    get_vk_device_memory_properties :: (pdevice: PhysicalDevice) -> VkPhysicalDeviceMemoryProperties #foreign libvkbootstrap "?get_vk_device_memory_properties@VkbPhysicalDeviceFunctions@@YA?AUVkPhysicalDeviceMemoryProperties@@PEAUVkbPhysicalDevice_T@@@Z";

    // Has a queue family that supports compute operations but not graphics nor transfer.
    has_dedicated_compute_queue :: (pdevice: PhysicalDevice) -> bool #foreign libvkbootstrap "?has_dedicated_compute_queue@VkbPhysicalDeviceFunctions@@YA_NPEAUVkbPhysicalDevice_T@@@Z";

    // Has a queue family that supports transfer operations but not graphics nor compute.
    has_dedicated_transfer_queue :: (pdevice: PhysicalDevice) -> bool #foreign libvkbootstrap "?has_dedicated_transfer_queue@VkbPhysicalDeviceFunctions@@YA_NPEAUVkbPhysicalDevice_T@@@Z";

    // Has a queue family that supports transfer operations but not graphics.
    has_separate_compute_queue :: (pdevice: PhysicalDevice) -> bool #foreign libvkbootstrap "?has_separate_compute_queue@VkbPhysicalDeviceFunctions@@YA_NPEAUVkbPhysicalDevice_T@@@Z";

    // Has a queue family that supports transfer operations but not graphics.
    has_separate_transfer_queue :: (pdevice: PhysicalDevice) -> bool #foreign libvkbootstrap "?has_separate_transfer_queue@VkbPhysicalDeviceFunctions@@YA_NPEAUVkbPhysicalDevice_T@@@Z";

    // Advanced: Get the VkQueueFamilyProperties of the device if special queue setup is needed
    get_queue_families :: (pdevice: PhysicalDevice, data: **VkQueueFamilyProperties, length: *u64) -> void #foreign libvkbootstrap "?get_queue_families@VkbPhysicalDeviceFunctions@@YAXPEAUVkbPhysicalDevice_T@@PEAPEAUVkQueueFamilyProperties@@PEA_K@Z";
    get_queue_families :: inline (pdevice: PhysicalDevice) -> []VkQueueFamilyProperties #no_context {
        result: []VkQueueFamilyProperties = ---;
        length: u64 = ---;
        get_queue_families(pdevice, *result.data, *length);
        result.count = xx length;
        return result;
    }

    // Query the list of extensions which should be enabled
    // Note: string_lengths and array_data allocates with malloc(), this leaves the caller
    // responsible to free the memory.
    get_extensions :: (pdevice: PhysicalDevice, array_data: ***u8, array_length: *u64, string_lengths: **u64) -> void #foreign libvkbootstrap "?get_extensions@VkbPhysicalDeviceFunctions@@YAXPEAUVkbPhysicalDevice_T@@PEAPEAPEBDPEA_KPEAPEA_K@Z";
    
    // The only thing needing to be deleted is the slice. The
    // strings are fine on their own.
    get_extensions :: inline (pdevice: PhysicalDevice) -> []string {
        array_data: **u8 = ---;
        array_length: u64 = ---;
        string_lengths: *u64 = ---;
        
        get_extensions(pdevice, *array_data, *array_length, *string_lengths);
        defer _vkb_impl_c_free(array_data);
        defer _vkb_impl_c_free(string_lengths);
        
        result := NewArray(xx array_length, string);
        
        for i : 0..array_length-1 {
            str := *result[i];
            str.data = array_data[i];
            str.count = xx string_lengths[i];      
        }
        
        return result;
    }

    // Query the list of extensions which the physical device supports
    // Note: string_lengths and array_data allocates with malloc(), this leaves the caller
    // responsible to free the memory.
    get_available_extensions :: (pdevice: PhysicalDevice, array_data: ***u8, array_length: *u64, string_lengths: **u64) -> void #foreign libvkbootstrap "?get_available_extensions@VkbPhysicalDeviceFunctions@@YAXPEAUVkbPhysicalDevice_T@@PEAPEAPEBDPEA_KPEAPEA_K@Z";
    get_available_extensions :: inline (pdevice: PhysicalDevice) -> []string {
        array_data: **u8 = ---;
        array_length: u64 = ---;
        string_lengths: *u64 = ---;
        
        get_available_extensions(pdevice, *array_data, *array_length, *string_lengths);
        defer _vkb_impl_c_free(array_data);
        defer _vkb_impl_c_free(string_lengths);
        
        result := NewArray(xx array_length, string);
        
        for i : 0..array_length-1 {
            str := *result[i];
            str.data = array_data[i];
            str.count = xx string_lengths[i];      
        }
        
        return result;
    }

    // Returns true if an extension should be enabled on the device
    is_extension_present :: (pdevice: PhysicalDevice, extension: *u8) -> bool #foreign libvkbootstrap "?is_extension_present@VkbPhysicalDeviceFunctions@@YA_NPEAUVkbPhysicalDevice_T@@PEBD@Z";

    // If the given extension is present, make the extension be enabled on the device.
    // Returns true the extension is present.
    enable_extension_if_present :: (pdevice: PhysicalDevice, extension: *u8) -> bool #foreign libvkbootstrap "?enable_extension_if_present@VkbPhysicalDeviceFunctions@@YA_NPEAUVkbPhysicalDevice_T@@PEBD@Z";

PreferredDeviceType :: enum s32 {
    OTHER       :: 0;
    INTEGRATED  :: 1;
    DISCRETE    :: 2;
    VIRTUAL_GPU :: 3;
    CPU         :: 4;
}

DeviceSelectionMode :: enum s32 {
    PARTIALLY_AND_FULLY_SUITABLE :: 0;

    ONLY_FULLY_SUITABLE          :: 1;
}

PhysicalDeviceSelector_T :: struct {}
PhysicalDeviceSelector :: *PhysicalDeviceSelector_T;

// PhysicalDeviceSelectorFunctions
    make_physical_device_selector :: (instance: Instance) -> PhysicalDeviceSelector #foreign libvkbootstrap "?make_physical_device_selector@VkbPhysicalDeviceSelectorFunctions@@YAPEAUVkbPhysicalDeviceSelector_T@@PEAUVkbInstance_T@@@Z";
    make_physical_device_selector :: (instance: Instance, surface: VkSurfaceKHR) -> PhysicalDeviceSelector #foreign libvkbootstrap "?make_physical_device_selector@VkbPhysicalDeviceSelectorFunctions@@YAPEAUVkbPhysicalDeviceSelector_T@@PEAUVkbInstance_T@@PEAUVkSurfaceKHR_T@@@Z";
    delete_physical_device_selector :: (selector: *PhysicalDeviceSelector) -> void #foreign libvkbootstrap "?delete_physical_device_selector@VkbPhysicalDeviceSelectorFunctions@@YAXPEAPEAUVkbPhysicalDeviceSelector_T@@@Z";

    // Return the first device which is suitable
    // use the `selection` parameter to configure if partially
    select :: (selector: PhysicalDeviceSelector, result: *PhysicalDevice, selection: DeviceSelectionMode = .PARTIALLY_AND_FULLY_SUITABLE) -> PhysicalDeviceError #foreign libvkbootstrap "?select@VkbPhysicalDeviceSelectorFunctions@@YA?AW4VkbPhysicalDeviceError@@PEAUVkbPhysicalDeviceSelector_T@@PEAPEAUVkbPhysicalDevice_T@@W4VkbDeviceSelectionMode@@@Z";
    select :: inline (selector: PhysicalDeviceSelector, selection: DeviceSelectionMode = .PARTIALLY_AND_FULLY_SUITABLE) -> PhysicalDevice, PhysicalDeviceError #no_context {
        result: PhysicalDevice = ---;
        error := select(selector, *result, selection);
        return result, error;
    }
    
    // Return all devices which are considered suitable - intended for applications which want to let the user pick the physical device
    select_devices :: (selector: PhysicalDeviceSelector, results: **PhysicalDevice, length: *u64, selection: DeviceSelectionMode = .PARTIALLY_AND_FULLY_SUITABLE) -> PhysicalDeviceError #foreign libvkbootstrap "?select_devices@VkbPhysicalDeviceSelectorFunctions@@YA?AW4VkbPhysicalDeviceError@@PEAUVkbPhysicalDeviceSelector_T@@PEAPEAPEAUVkbPhysicalDevice_T@@PEA_KW4VkbDeviceSelectionMode@@@Z";

    // Note: Will need to delete the slice as well as all the individual physical devices 
    select_devices :: inline (selector: PhysicalDeviceSelector, selection: DeviceSelectionMode = .PARTIALLY_AND_FULLY_SUITABLE) -> []PhysicalDevice, PhysicalDeviceError {
        physical_device_results: *PhysicalDevice = ---;
        length: u64 = ---;
        error := select_devices(selector, *physical_device_results, *length, selection);
        defer _vkb_impl_c_free(physical_device_results);
        
        result := NewArray(xx length, PhysicalDevice);
        
        memcpy(result.data, physical_device_results, size_of(PhysicalDevice) * xx length);
        
        return result, error;
    }

    // Return the names of all devices which are considered suitable - intended for applications which want to let the user pick the physical device
    // Note: string_lengths and array_data allocates with malloc(), this leaves the caller
    // responsible to free the memory.
    select_device_names :: (selector: PhysicalDeviceSelector, array_data: ***u8, array_length: *u64, string_lengths: **u64, selection: DeviceSelectionMode = .PARTIALLY_AND_FULLY_SUITABLE) -> PhysicalDeviceError #foreign libvkbootstrap "?select_device_names@VkbPhysicalDeviceSelectorFunctions@@YA?AW4VkbPhysicalDeviceError@@PEAUVkbPhysicalDeviceSelector_T@@PEAPEAPEBDPEA_KPEAPEA_KW4VkbDeviceSelectionMode@@@Z";
    
    // Note: Will have to free the slice.
    select_device_names :: inline (selector: PhysicalDeviceSelector, selection: DeviceSelectionMode = .PARTIALLY_AND_FULLY_SUITABLE) -> []string, PhysicalDeviceError {
        array_data: **u8 = ---;
        array_length: u64 = ---;
        string_lengths: *u64 = ---;
        
        error := select_device_names(selector, *array_data, *array_length, *string_lengths, selection);
        defer _vkb_impl_c_free(array_data);
        defer _vkb_impl_c_free(string_lengths);
        
        result := NewArray(xx array_length, string);
        
        for i : 0..array_length-1 {
            str := *result[i];
            str.data = array_data[i];
            str.count = xx string_lengths[i];      
        }
        
        return result, error;
    }
    
    // Set the surface in which the physical device should render to.
    // Be sure to set it if swapchain functionality is to be used.
    set_surface :: (selector: PhysicalDeviceSelector, surface: VkSurfaceKHR) -> void #foreign libvkbootstrap "?set_surface@VkbPhysicalDeviceSelectorFunctions@@YAXPEAUVkbPhysicalDeviceSelector_T@@PEAUVkSurfaceKHR_T@@@Z";

    // Set the name of the device to select.
    set_name :: (selector: PhysicalDeviceSelector, name: *u8, name_char_length: u64) -> void #foreign libvkbootstrap "?set_name@VkbPhysicalDeviceSelectorFunctions@@YAXPEAUVkbPhysicalDeviceSelector_T@@PEBD_K@Z";
    set_name :: inline (selector: PhysicalDeviceSelector, name: string) #no_context {
        set_name(selector, name.data, xx name.count);
    }

    // Set the desired physical device type to select. Defaults to PreferredDeviceType::DISCRETE.
    prefer_gpu_device_type :: (selector: PhysicalDeviceSelector, type: PreferredDeviceType = .DISCRETE) -> void #foreign libvkbootstrap "?prefer_gpu_device_type@VkbPhysicalDeviceSelectorFunctions@@YAXPEAUVkbPhysicalDeviceSelector_T@@W4VkbPreferredDeviceType@@@Z";

    // Allow selection of a gpu device type that isn't the preferred physical device type. Defaults to true.
    allow_any_gpu_device_type :: (selector: PhysicalDeviceSelector, allow_any_type := true) -> void #foreign libvkbootstrap "?allow_any_gpu_device_type@VkbPhysicalDeviceSelectorFunctions@@YAXPEAUVkbPhysicalDeviceSelector_T@@_N@Z";

    // Require that a physical device supports presentation. Defaults to true.
    require_present :: (selector: PhysicalDeviceSelector, require := true) -> void #foreign libvkbootstrap "?require_present@VkbPhysicalDeviceSelectorFunctions@@YAXPEAUVkbPhysicalDeviceSelector_T@@_N@Z";

    // Require a queue family that supports compute operations but not graphics nor transfer.
    require_dedicated_compute_queue :: (selector: PhysicalDeviceSelector) -> void #foreign libvkbootstrap "?require_dedicated_compute_queue@VkbPhysicalDeviceSelectorFunctions@@YAXPEAUVkbPhysicalDeviceSelector_T@@@Z";

    // Require a queue family that supports transfer operations but not graphics nor compute.
    require_dedicated_transfer_queue :: (selector: PhysicalDeviceSelector) -> void #foreign libvkbootstrap "?require_dedicated_transfer_queue@VkbPhysicalDeviceSelectorFunctions@@YAXPEAUVkbPhysicalDeviceSelector_T@@@Z";

    // Require a queue family that supports compute operations but not graphics.
    require_separate_compute_queue :: (selector: PhysicalDeviceSelector) -> void #foreign libvkbootstrap "?require_separate_compute_queue@VkbPhysicalDeviceSelectorFunctions@@YAXPEAUVkbPhysicalDeviceSelector_T@@@Z";

    // Require a queue family that supports transfer operations but not graphics.
    require_separate_transfer_queue :: (selector: PhysicalDeviceSelector) -> void #foreign libvkbootstrap "?require_separate_transfer_queue@VkbPhysicalDeviceSelectorFunctions@@YAXPEAUVkbPhysicalDeviceSelector_T@@@Z";

    // Require a memory heap from VK_MEMORY_PROPERTY_DEVICE_LOCAL_BIT with `size` memory available.
    required_device_memory_size :: (selector: PhysicalDeviceSelector, size: VkDeviceSize) -> void #foreign libvkbootstrap "?required_device_memory_size@VkbPhysicalDeviceSelectorFunctions@@YAXPEAUVkbPhysicalDeviceSelector_T@@_K@Z";

    // Require a physical device which supports a specific extension.
    add_required_extension :: (selector: PhysicalDeviceSelector, extension: *u8) -> void #foreign libvkbootstrap "?add_required_extension@VkbPhysicalDeviceSelectorFunctions@@YAXPEAUVkbPhysicalDeviceSelector_T@@PEBD@Z";

    // Require a physical device which supports a set of extensions.
    add_required_extensions :: (selector: PhysicalDeviceSelector, extensions: **u8, length: u64) -> void #foreign libvkbootstrap "?add_required_extensions@VkbPhysicalDeviceSelectorFunctions@@YAXPEAUVkbPhysicalDeviceSelector_T@@PEAPEBD_K@Z";

    // Require a physical device that supports a (major, minor) version of vulkan.
    set_minimum_version :: (selector: PhysicalDeviceSelector, major: u32, minor: u32) -> void #foreign libvkbootstrap "?set_minimum_version@VkbPhysicalDeviceSelectorFunctions@@YAXPEAUVkbPhysicalDeviceSelector_T@@II@Z";

    // By default PhysicalDeviceSelector enables the portability subset if available
    // This function disables that behavior
    disable_portability_subset :: (selector: PhysicalDeviceSelector) -> void #foreign libvkbootstrap "?disable_portability_subset@VkbPhysicalDeviceSelectorFunctions@@YAXPEAUVkbPhysicalDeviceSelector_T@@@Z";

    // Require a physical device which supports a specific set of general/extension features.
    // If this function is used, the user should not put their own VkPhysicalDeviceFeatures2 in
    // the pNext chain of VkDeviceCreateInfo.
    //
    // Original function:
    //     template <typename T> PhysicalDeviceSelector& add_required_extension_features(T const& features) {
    //         criteria.extended_features_chain.push_back(features);
    //         return *this;
    //     }
    add_required_extension_features :: (selector: PhysicalDevice, data: *void, size: u64) -> void #foreign libvkbootstrap "?add_required_extension_features@VkbPhysicalDeviceSelectorFunctions@@YAXPEAUVkbPhysicalDevice_T@@PEAX_K@Z";
    add_required_extension_features :: (selector: PhysicalDevice, features: *$T) #no_context {
        add_required_extension_features(selector, features, xx size_of(T));
    }

    // Require a physical device which supports the features in VkPhysicalDeviceFeatures.
    set_required_features :: (selector: PhysicalDeviceSelector, features: *VkPhysicalDeviceFeatures) -> void #foreign libvkbootstrap "?set_required_features@VkbPhysicalDeviceSelectorFunctions@@YAXPEAUVkbPhysicalDeviceSelector_T@@AEBUVkPhysicalDeviceFeatures@@@Z";
    set_required_features :: (selector: PhysicalDeviceSelector, features: VkPhysicalDeviceFeatures) #no_context {
        set_required_features(selector, *features);
    }

    // Require a physical device which supports the features in VkPhysicalDeviceVulkan11Features.
    // Must have vulkan version 1.2 - This is due to the VkPhysicalDeviceVulkan11Features struct being added in 1.2, not 1.1
    set_required_features_11 :: (selector: PhysicalDeviceSelector, features_11: VkPhysicalDeviceVulkan11Features) -> void #foreign libvkbootstrap "?set_required_features_11@VkbPhysicalDeviceSelectorFunctions@@YAXPEAUVkbPhysicalDeviceSelector_T@@UVkPhysicalDeviceVulkan11Features@@@Z";

    // Require a physical device which supports the features in VkPhysicalDeviceVulkan12Features.
    // Must have vulkan version 1.2
    set_required_features_12 :: (selector: PhysicalDeviceSelector, features_12: VkPhysicalDeviceVulkan12Features) -> void #foreign libvkbootstrap "?set_required_features_12@VkbPhysicalDeviceSelectorFunctions@@YAXPEAUVkbPhysicalDeviceSelector_T@@UVkPhysicalDeviceVulkan12Features@@@Z";

    // Require a physical device which supports the features in VkPhysicalDeviceVulkan13Features.
    // Must have vulkan version 1.3
    set_required_features_13 :: (selector: PhysicalDeviceSelector, features_13: VkPhysicalDeviceVulkan13Features) -> void #foreign libvkbootstrap "?set_required_features_13@VkbPhysicalDeviceSelectorFunctions@@YAXPEAUVkbPhysicalDeviceSelector_T@@UVkPhysicalDeviceVulkan13Features@@@Z";

    // Used when surface creation happens after physical device selection.
    // Warning: This disables checking if the physical device supports a given surface.
    defer_surface_initialization :: (selector: PhysicalDeviceSelector) -> void #foreign libvkbootstrap "?defer_surface_initialization@VkbPhysicalDeviceSelectorFunctions@@YAXPEAUVkbPhysicalDeviceSelector_T@@@Z";

    // Ignore all criteria and choose the first physical device that is available.
    // Only use when: The first gpu in the list may be set by global user preferences and an application may wish to respect it.
    select_first_device_unconditionally :: (selector: PhysicalDeviceSelector, unconditionally := true) -> void #foreign libvkbootstrap "?select_first_device_unconditionally@VkbPhysicalDeviceSelectorFunctions@@YAXPEAUVkbPhysicalDeviceSelector_T@@_N@Z";

QueueType :: enum s32 {
    PRESENT  :: 0;
    GRAPHICS :: 1;
    COMPUTE  :: 2;
    TRANSFER :: 3;
}

Device_T :: struct {}
Device :: *Device_T;

// DeviceFunctions
    get_vk_device :: (device: Device) -> VkDevice #foreign libvkbootstrap "?get_vk_device@VkbDeviceFunctions@@YAPEAUVkDevice_T@@PEAUVkbDevice_T@@@Z";
    get_queue_families :: (device: Device, queue_families: **VkQueueFamilyProperties, length: *u64) -> void #foreign libvkbootstrap "?get_queue_families@VkbDeviceFunctions@@YAXPEAUVkbDevice_T@@PEAPEAUVkQueueFamilyProperties@@PEA_K@Z";
    
    // Note: Do not deallocate.
    get_queue_families :: inline (device: Device) -> []VkQueueFamilyProperties #no_context {
        result: []VkQueueFamilyProperties = ---;
        length: u64 = ---;
        get_queue_families(device, *result.data, *length);
        result.count = xx length;
        return result;
    }
    
    get_allocation_callbacks :: (device: Device) -> *VkAllocationCallbacks #foreign libvkbootstrap "?get_allocation_callbacks@VkbDeviceFunctions@@YAPEAUVkAllocationCallbacks@@PEAUVkbDevice_T@@@Z";

    destroy_device :: (device: *Device) -> void #foreign libvkbootstrap "?destroy_device@VkbDeviceFunctions@@YAXPEAPEAUVkbDevice_T@@@Z";

    get_queue_index :: (device: Device, type: QueueType, result: *u32) -> QueueError #foreign libvkbootstrap "?get_queue_index@VkbDeviceFunctions@@YA?AW4VkbQueueError@@PEAUVkbDevice_T@@W4VkbQueueType@@PEAI@Z";
    get_queue_index :: inline (device: Device, type: QueueType) -> u32, QueueError #no_context {
        result: u32 = ---;
        error := get_queue_index(device, type, *result);
        return result, error;
    }

    // Only a compute or transfer queue type is valid. All other queue types do not support a 'dedicated' queue index
    get_dedicated_queue_index :: (device: Device, type: QueueType, result: *u32) -> QueueError #foreign libvkbootstrap "?get_dedicated_queue_index@VkbDeviceFunctions@@YA?AW4VkbQueueError@@PEAUVkbDevice_T@@W4VkbQueueType@@PEAI@Z";
    get_dedicated_queue_index :: inline (device: Device, type: QueueType) -> u32, QueueError #no_context {
        result: u32 = ---;
        error := get_dedicated_queue_index(device, type, *result);
        return result, error;
    }

    get_queue :: (device: Device, type: QueueType, result: *VkQueue) -> QueueError #foreign libvkbootstrap "?get_queue@VkbDeviceFunctions@@YA?AW4VkbQueueError@@PEAUVkbDevice_T@@W4VkbQueueType@@PEAPEAUVkQueue_T@@@Z";
    get_queue :: inline (device: Device, type: QueueType) -> VkQueue, QueueError #no_context {
        result: VkQueue = ---;
        error := get_queue(device, type, *result);
        return result, error;
    }

    // Only a compute or transfer queue type is valid. All other queue types do not support a 'dedicated' queue
    get_dedicated_queue :: (device: Device, type: QueueType, result: *VkQueue) -> QueueError #foreign libvkbootstrap "?get_dedicated_queue@VkbDeviceFunctions@@YA?AW4VkbQueueError@@PEAUVkbDevice_T@@W4VkbQueueType@@PEAPEAUVkQueue_T@@@Z";
    get_dedicated_queue :: inline (device: Device, type: QueueType) -> VkQueue, QueueError #no_context {
        result: VkQueue = ---;
        error := get_dedicated_queue(device, type, *result);
        return result, error;
    }

DeviceBuilder_T :: struct {}
DeviceBuilder :: *DeviceBuilder_T;

// DeviceBuilderFunctions
    make_device_builder :: (physical_device: PhysicalDevice) -> DeviceBuilder #foreign libvkbootstrap "?make_device_builder@VkbDeviceBuilderFunctions@@YAPEAUVkbDeviceBuilder_T@@PEAUVkbPhysicalDevice_T@@@Z";
    delete_device_builder :: (builder: *DeviceBuilder) -> void #foreign libvkbootstrap "?delete_device_builder@VkbDeviceBuilderFunctions@@YAXPEAPEAUVkbDeviceBuilder_T@@@Z";

    build :: (builder: DeviceBuilder, result: *Device) -> DeviceError #foreign libvkbootstrap "?build@VkbDeviceBuilderFunctions@@YA?AW4VkbDeviceError@@PEAUVkbDeviceBuilder_T@@PEAPEAUVkbDevice_T@@@Z";
    build :: inline (builder: DeviceBuilder) -> Device, DeviceError #no_context {
        result: Device = ---;
        error := build(builder, *result);
        return result, error;
    }

    add_pNext :: (builder: DeviceBuilder, structure: *VkBaseOutStructure) -> void #foreign libvkbootstrap "?add_pNext@VkbDeviceBuilderFunctions@@YAXPEAUVkbDeviceBuilder_T@@PEAUVkBaseOutStructure@@@Z";

    set_allocation_callbacks :: (builder: DeviceBuilder, callbacks: *VkAllocationCallbacks) -> void #foreign libvkbootstrap "?set_allocation_callbacks@VkbDeviceBuilderFunctions@@YAXPEAUVkbDeviceBuilder_T@@PEAUVkAllocationCallbacks@@@Z";

Swapchain_T :: struct {}
Swapchain :: *Swapchain_T;

// VkbSwapchainFunctions
    get_image_count :: (swapchain: Swapchain) -> u32 #foreign libvkbootstrap "?get_image_count@VkbSwapchainFunctions@@YAIPEAUVkbSwapchain_T@@@Z";
    get_image_format :: (swapchain: Swapchain) -> VkFormat #foreign libvkbootstrap "?get_image_format@VkbSwapchainFunctions@@YA?AW4VkFormat@@PEAUVkbSwapchain_T@@@Z";
    get_color_space :: (swapchain: Swapchain) -> VkColorSpaceKHR #foreign libvkbootstrap "?get_color_space@VkbSwapchainFunctions@@YA?AW4VkColorSpaceKHR@@PEAUVkbSwapchain_T@@@Z";
    get_extent :: (swapchain: Swapchain) -> VkExtent2D #foreign libvkbootstrap "?get_extent@VkbSwapchainFunctions@@YA?AUVkExtent2D@@PEAUVkbSwapchain_T@@@Z";
    get_image_usage_flags :: (swapchain: Swapchain) -> VkImageUsageFlags #foreign libvkbootstrap "?get_image_usage_flags@VkbSwapchainFunctions@@YAIPEAUVkbSwapchain_T@@@Z";
    get_present_mode :: (swapchain: Swapchain) -> VkPresentModeKHR #foreign libvkbootstrap "?get_present_mode@VkbSwapchainFunctions@@YA?AW4VkPresentModeKHR@@PEAUVkbSwapchain_T@@@Z";
    get_allocation_callbacks :: (swapchain: Swapchain) -> *VkAllocationCallbacks #foreign libvkbootstrap "?get_allocation_callbacks@VkbSwapchainFunctions@@YAPEAUVkAllocationCallbacks@@PEAUVkbSwapchain_T@@@Z";

    destroy_swapchain :: (swapchain: *Swapchain) -> void #foreign libvkbootstrap "?destroy_swapchain@VkbSwapchainFunctions@@YAXPEAPEAUVkbSwapchain_T@@@Z";

    // Returns a vector of VkImage handles to the swapchain.
    //
    // Alllocates memory that needs to be freed with "destroy_images"
    get_images :: (swapchain: Swapchain, data: **VkImage, length: *u64) -> SwapchainError #foreign libvkbootstrap "?get_images@VkbSwapchainFunctions@@YA?AW4VkbSwapchainError@@PEAUVkbSwapchain_T@@PEAPEAPEAUVkImage_T@@PEA_K@Z";
    
    get_images :: inline (swapchain: Swapchain) -> []VkImage, SwapchainError #no_context {
        result: []VkImage = ---;
        length: u64 = ---;
        error := get_images(swapchain, *result.data, *length);
        result.count = xx length;
        return result, error;
    }
    
    destroy_images :: (data: *VkImage) -> void #foreign libvkbootstrap "?destroy_images@VkbSwapchainFunctions@@YAXPEAPEAUVkImage_T@@@Z";
    destroy_images :: inline (data: []VkImage) #no_context {
        destroy_images(data.data);
    }

    // Returns a vector of VkImageView's to the VkImage's of the swapchain.
    // VkImageViews must be destroyed.  The pNext chain must be a nullptr or a valid
    // structure.
    //
    // Compared to the original function, this will allocate memory for the data variable,
    // This means that the user won't have to worry about the lifetime of the data as it's
    // not bound to a vector. All that'll need to be done in the end is calling the destroy
    // method.
    get_image_views :: (swapchain: Swapchain, data: **VkImageView, length: *u64) -> SwapchainError #foreign libvkbootstrap "?get_image_views@VkbSwapchainFunctions@@YA?AW4VkbSwapchainError@@PEAUVkbSwapchain_T@@PEAPEAPEAUVkImageView_T@@PEA_K@Z";
    get_image_views :: inline (swapchain: Swapchain) -> []VkImageView, SwapchainError #no_context {
        result, error := get_image_views(swapchain, null);
        return result, error;
    }
    
    get_image_views :: (swapchain: Swapchain, pNext: *void, data: **VkImageView, length: *u64) -> SwapchainError #foreign libvkbootstrap "?get_image_views@VkbSwapchainFunctions@@YA?AW4VkbSwapchainError@@PEAUVkbSwapchain_T@@PEBXPEAPEAPEAUVkImageView_T@@PEA_K@Z";
    get_image_views :: inline (swapchain: Swapchain, pNext: *void) -> []VkImageView, SwapchainError #no_context {
        result: []VkImageView = ---;
        length: u64 = ---;
        error := get_image_views(swapchain, pNext, *result.data, *length);
        result.count = xx length;
        return result, error;
    }
    
    destroy_image_views :: (swapchain: Swapchain, data: *VkImageView, length: u64) -> void #foreign libvkbootstrap "?destroy_image_views@VkbSwapchainFunctions@@YAXPEAUVkbSwapchain_T@@PEAPEAUVkImageView_T@@_K@Z";
    destroy_image_views :: inline (swapchain: Swapchain, image_views: []VkImageView) #no_context {
        destroy_image_views(swapchain, image_views.data, xx image_views.count);
    }

SwapchainBuilder_T :: struct {}
SwapchainBuilder :: *SwapchainBuilder_T;

// VkbSwapchainBuilderFunctions
    make_swapchain_builder :: (device: Device) -> SwapchainBuilder #foreign libvkbootstrap "?make_swapchain_builder@VkbSwapchainBuilderFunctions@@YAPEAUVkbSwapchainBuilder_T@@PEAUVkbDevice_T@@@Z";
    make_swapchain_builder :: (device: Device, surface: VkSurfaceKHR) -> SwapchainBuilder #foreign libvkbootstrap "?make_swapchain_builder@VkbSwapchainBuilderFunctions@@YAPEAUVkbSwapchainBuilder_T@@PEAUVkbDevice_T@@PEAUVkSurfaceKHR_T@@@Z";
    delete_swapchain_builder :: (builder: *SwapchainBuilder) -> void #foreign libvkbootstrap "?delete_swapchain_builder@VkbSwapchainBuilderFunctions@@YAXPEAPEAUVkbSwapchainBuilder_T@@@Z";

    build :: (builder: SwapchainBuilder, result: *Swapchain) -> SwapchainError #foreign libvkbootstrap "?build@VkbSwapchainBuilderFunctions@@YA?AW4VkbSwapchainError@@PEAUVkbSwapchainBuilder_T@@PEAPEAUVkbSwapchain_T@@@Z";
    build :: inline (builder: SwapchainBuilder) -> Swapchain, SwapchainError #no_context {
        result: VkbSwapchain = ---;
        error := build(builder, *result);
        return result, error;
    }

    // Set the oldSwapchain member of VkSwapchainCreateInfoKHR.
    // For use in rebuilding a swapchain.
    set_old_swapchain :: (builder: SwapchainBuilder, old_swapchain: VkSwapchainKHR) -> void #foreign libvkbootstrap "?set_old_swapchain@VkbSwapchainBuilderFunctions@@YAXPEAUVkbSwapchainBuilder_T@@PEAUVkSwapchainKHR_T@@@Z";
    set_old_swapchain :: (builder: SwapchainBuilder, old_swapchain: Swapchain) -> void #foreign libvkbootstrap "?set_old_swapchain@VkbSwapchainBuilderFunctions@@YAXPEAUVkbSwapchainBuilder_T@@PEAUVkbSwapchain_T@@@Z";

    // Desired size of the swapchain. By default, the swapchain will use the size
    // of the window being drawn to.
    set_desired_extent :: (builder: SwapchainBuilder, width: u32, height: u32) -> void #foreign libvkbootstrap "?set_desired_extent@VkbSwapchainBuilderFunctions@@YAXPEAUVkbSwapchainBuilder_T@@II@Z";

    // When determining the surface format, make this the first to be used if supported.
    set_desired_format :: (builder: SwapchainBuilder, format: VkSurfaceFormatKHR) -> void #foreign libvkbootstrap "?set_desired_format@VkbSwapchainBuilderFunctions@@YAXPEAUVkbSwapchainBuilder_T@@UVkSurfaceFormatKHR@@@Z";

    // Add this swapchain format to the end of the list of formats selected from.
    add_fallback_format :: (builder: SwapchainBuilder, format: VkSurfaceFormatKHR) -> void #foreign libvkbootstrap "?add_fallback_format@VkbSwapchainBuilderFunctions@@YAXPEAUVkbSwapchainBuilder_T@@UVkSurfaceFormatKHR@@@Z";

    // Use the default swapchain formats. This is done if no formats are provided.
    // Default surface format is {VK_FORMAT_B8G8R8A8_SRGB, VK_COLOR_SPACE_SRGB_NONLINEAR_KHR}
    use_default_format_selection :: (builder: SwapchainBuilder) -> void #foreign libvkbootstrap "?use_default_format_selection@VkbSwapchainBuilderFunctions@@YAXPEAUVkbSwapchainBuilder_T@@@Z";

    // When determining the present mode, make this the first to be used if supported.
    set_desired_present_mode :: (builder: SwapchainBuilder, present_mode: VkPresentModeKHR) -> void #foreign libvkbootstrap "?set_desired_present_mode@VkbSwapchainBuilderFunctions@@YAXPEAUVkbSwapchainBuilder_T@@W4VkPresentModeKHR@@@Z";

    // Add this present mode to the end of the list of present modes selected from.
    add_fallback_present_mode :: (builder: SwapchainBuilder, present_mode: VkPresentModeKHR) -> void #foreign libvkbootstrap "?add_fallback_present_mode@VkbSwapchainBuilderFunctions@@YAXPEAUVkbSwapchainBuilder_T@@W4VkPresentModeKHR@@@Z";

    // Use the default presentation mode. This is done if no present modes are provided.
    // Default present modes: VK_PRESENT_MODE_MAILBOX_KHR with fallback VK_PRESENT_MODE_FIFO_KHR
    use_default_present_mode_selection :: (builder: SwapchainBuilder) -> void #foreign libvkbootstrap "?use_default_present_mode_selection@VkbSwapchainBuilderFunctions@@YAXPEAUVkbSwapchainBuilder_T@@@Z";

    // Set the bitmask of the image usage for acquired swapchain images.
    // If the surface capabilities cannot allow it, building the swapchain will result in the `SwapchainError::required_usage_not_supported` error.
    set_image_usage_flags :: (builder: SwapchainBuilder, usage_flags: VkImageUsageFlags) -> void #foreign libvkbootstrap "?set_image_usage_flags@VkbSwapchainBuilderFunctions@@YAXPEAUVkbSwapchainBuilder_T@@I@Z";

    // Add a image usage to the bitmask for acquired swapchain images.
    add_image_usage_flags :: (builder: SwapchainBuilder, usage_flags: VkImageUsageFlags) -> void #foreign libvkbootstrap "?add_image_usage_flags@VkbSwapchainBuilderFunctions@@YAXPEAUVkbSwapchainBuilder_T@@I@Z";

    // Use the default image usage bitmask values. This is the default if no image usages
    // are provided. The default is VK_IMAGE_USAGE_COLOR_ATTACHMENT_BIT
    use_default_image_usage_flags :: (builder: SwapchainBuilder) -> void #foreign libvkbootstrap "?use_default_image_usage_flags@VkbSwapchainBuilderFunctions@@YAXPEAUVkbSwapchainBuilder_T@@@Z";

    // Set the number of views in for multiview/stereo surface
    set_image_array_layer_count :: (builder: SwapchainBuilder, array_layer_count: u32) -> void #foreign libvkbootstrap "?set_image_array_layer_count@VkbSwapchainBuilderFunctions@@YAXPEAUVkbSwapchainBuilder_T@@I@Z";

    // Convenient named constants for passing to set_desired_min_image_count().
    // Note that it is not an `enum class`, so its constants can be passed as an integer value without casting
    // In other words, these might as well be `static const int`, but they benefit from being grouped together this way.
    BufferMode :: enum s32 {
        SINGLE_BUFFERING :: 1;
        DOUBLE_BUFFERING :: 2;
        TRIPLE_BUFFERING :: 3;
    }

    // Sets the desired minimum image count for the swapchain.
    // Note that the presentation engine is always free to create more images than requested.
    // You may pass one of the values specified in the BufferMode enum, or any integer value.
    // For instance, if you pass DOUBLE_BUFFERING, the presentation engine is allowed to give you a double buffering setup, triple buffering, or more. This is up to the drivers.
    set_desired_min_image_count :: (builder: SwapchainBuilder, min_image_count: u32) -> void #foreign libvkbootstrap "?set_desired_min_image_count@VkbSwapchainBuilderFunctions@@YAXPEAUVkbSwapchainBuilder_T@@I@Z";

    // Sets a required minimum image count for the swapchain.
    // If the surface capabilities cannot allow it, building the swapchain will result in the `SwapchainError::required_min_image_count_too_low` error.
    // Otherwise, the same observations from set_desired_min_image_count() apply.
    // A value of 0 is specially interpreted as meaning "no requirement", and is the behavior by default.
    set_required_min_image_count :: (builder: SwapchainBuilder, required_min_image_count: u32) -> void #foreign libvkbootstrap "?set_required_min_image_count@VkbSwapchainBuilderFunctions@@YAXPEAUVkbSwapchainBuilder_T@@I@Z";

    // Set whether the Vulkan implementation is allowed to discard rendering operations that
    // affect regions of the surface that are not visible. Default is true.
    // Note: Applications should use the default of true if they do not expect to read back the content
    // of presentable images before presenting them or after reacquiring them, and if their fragment
    // shaders do not have any side effects that require them to run for all pixels in the presentable image.
    set_clipped :: (builder: SwapchainBuilder, clipped := true) -> void #foreign libvkbootstrap "?set_clipped@VkbSwapchainBuilderFunctions@@YAXPEAUVkbSwapchainBuilder_T@@_N@Z";

    // Set the VkSwapchainCreateFlagBitsKHR.
    set_create_flags :: (builder: SwapchainBuilder, create_flags: VkSwapchainCreateFlagBitsKHR) -> void #foreign libvkbootstrap "?set_create_flags@VkbSwapchainBuilderFunctions@@YAXPEAUVkbSwapchainBuilder_T@@W4VkSwapchainCreateFlagBitsKHR@@@Z";

    // Set the transform to be applied, like a 90 degree rotation. Default is no transform.
    set_pre_transform_flags :: (builder: SwapchainBuilder, pre_transform_flags: VkSurfaceTransformFlagBitsKHR) -> void #foreign libvkbootstrap "?set_pre_transform_flags@VkbSwapchainBuilderFunctions@@YAXPEAUVkbSwapchainBuilder_T@@W4VkSurfaceTransformFlagBitsKHR@@@Z";

    // Set the alpha channel to be used with other windows in on the system. Default is VK_COMPOSITE_ALPHA_OPAQUE_BIT_KHR.
    set_composite_alpha_flags :: (builder: SwapchainBuilder, composite_alpha_flags: VkCompositeAlphaFlagBitsKHR) -> void #foreign libvkbootstrap "?set_composite_alpha_flags@VkbSwapchainBuilderFunctions@@YAXPEAUVkbSwapchainBuilder_T@@W4VkCompositeAlphaFlagBitsKHR@@@Z";

    // Add a structure to the pNext chain of VkSwapchainCreateInfoKHR.
    // The structure must be valid when SwapchainBuilder::build() is called.
    //
    // Original Code:
    //     template <typename T> SwapchainBuilder& add_pNext(T* structure) {
    //         info.pNext_chain.push_back(reinterpret_cast<VkBaseOutStructure*>(structure));
    //         return *this;
    //     }
    add_pNext :: (builder: SwapchainBuilder, structure: *VkBaseOutStructure) -> void #foreign libvkbootstrap "?add_pNext@VkbSwapchainBuilderFunctions@@YAXPEAUVkbSwapchainBuilder_T@@PEAUVkBaseOutStructure@@@Z";

    // Provide custom allocation callbacks.
    set_allocation_callbacks :: (builder: SwapchainBuilder, callbacks: *VkAllocationCallbacks) -> void #foreign libvkbootstrap "?set_allocation_callbacks@VkbSwapchainBuilderFunctions@@YAXPEAUVkbSwapchainBuilder_T@@PEAUVkAllocationCallbacks@@@Z";

// A quick little c wrapper to help remove any allocated memory.
_vkb_impl_c_free :: (data: *void) -> void #foreign libvkbootstrap "?_vkb_impl_c_free@@YAXPEAX@Z";

#scope_file

#import "Vulkan_1_3";
#import "Basic";

#if OS == .WINDOWS {
    libvkbootstrap :: #library "VKBootstrap";
} else #if OS == .LINUX {
    libvkbootstrap :: #library "VKBootstrap";
} else {
    #assert(false);
}
