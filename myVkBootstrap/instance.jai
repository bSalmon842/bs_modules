/*
Module: BS842 Vk Bootstrap
File: instance.jai
Author: Brock Salmon
Created: 14DEC2024
Last Edit: 14DEC2024
*/

InstanceError :: enum {
    Success;
    Vulkan_Unavailable;
    Vulkan_Version_Unavailable;
    Vulkan_Version_1_1_Unavailable;
    Vulkan_Version_1_2_Unavailable;
    Failed_Create_Instance;
    Failed_Create_Debug_Messenger;
    Requested_Layers_Not_Present;
    Requested_Extensions_Not_Present;
    Windowing_Extensions_Not_Present;
}

Instance :: struct {
    instance              : VkInstance               = VK_NULL_HANDLE;
    debugMessenger        : VkDebugUtilsMessengerEXT = VK_NULL_HANDLE;
    allocationCallbacks   : *VkAllocationCallbacks   = VK_NULL_HANDLE;

    headless              : bool = false;
    properties2EXTEnabled : bool = false;
    instanceVersion       : u32  = VK_API_VERSION_1_0;
    apiVersion            : u32  = VK_API_VERSION_1_0;
};

InstanceBuilder :: struct {
    // VkApplicationInfo
    appName                : string = "";
    engineName             : string = "";
    appVersion             : u32 = 0;
    engineVersion          : u32 = 0;
    minimumInstanceVersion : u32 = 0;
    requiredAPIVersion     : u32 = VK_API_VERSION_1_0;
    desiredAPIVersion      : u32 = VK_API_VERSION_1_0;

    // VkInstanceCreateInfo
    layers        : [..] string;
    extensions    : [..] string;
    flags         : VkInstanceCreateFlags = 0;

    // debug callback - use the default so it is not nullptr
    debugCallback        : PFN_vkDebugUtilsMessengerCallbackEXT = default_debug_callback;
    debugMessageSeverity : VkDebugUtilsMessageSeverityFlagsEXT = .WARNING_BIT_EXT |
                                                                 .ERROR_BIT_EXT;
    debugMessageType     : VkDebugUtilsMessageTypeFlagsEXT = .GENERAL_BIT_EXT |
                                                             .VALIDATION_BIT_EXT |
                                                             .PERFORMANCE_BIT_EXT;
    debugUserDataPointer : *void = null;

    // validation features
    disabledValidationChecks   : [..] VkValidationCheckEXT;
    enabledValidationFeatures  : [..] VkValidationFeatureEnableEXT;
    disabledValidationFeatures : [..] VkValidationFeatureDisableEXT;

    // Custom allocator
    allocationCallbacks : *VkAllocationCallbacks = VK_NULL_HANDLE;

    requestValidationLayers : bool = false;
    enableValidationLayers  : bool = false;
    useDebugMessenger       : bool = false;
    headlessContext         : bool = false;
}

set_app_name                     :: (using builder : *InstanceBuilder, name : string)                                  { appName                 = name; }
set_engine_name                  :: (using builder : *InstanceBuilder, name : string)                                  { engineName              = name; }
set_app_version                  :: (using builder : *InstanceBuilder, version : u32)                                  { appVersion              = version; }
set_app_version                  :: (using builder : *InstanceBuilder, major : u32, minor : u32, patch : u32)          { appVersion              = VK_MAKE_VERSION(major, minor, patch); }
set_engine_version               :: (using builder : *InstanceBuilder, version : u32)                                  { engineVersion           = version; }
set_engine_version               :: (using builder : *InstanceBuilder, major : u32, minor : u32, patch : u32)          { engineVersion           = VK_MAKE_VERSION(major, minor, patch); }
require_api_version              :: (using builder : *InstanceBuilder, version : u32)                                  { requiredAPIVersion      = version; }
require_api_version              :: (using builder : *InstanceBuilder, major : u32, minor : u32, patch : u32)          { requiredAPIVersion      = VK_MAKE_VERSION(major, minor, patch); }
set_minimum_instance_version     :: (using builder : *InstanceBuilder, version : u32)                                  { minimumInstanceVersion  = version; }
set_minimum_instance_version     :: (using builder : *InstanceBuilder, major : u32, minor : u32, patch : u32)          { minimumInstanceVersion  = VK_MAKE_VERSION(major, minor, patch); }
desire_api_version               :: (using builder : *InstanceBuilder, version : u32)                                  { desiredAPIVersion       = version; }
desire_api_version               :: (using builder : *InstanceBuilder, major : u32, minor : u32, patch : u32)          { desiredAPIVersion       = VK_MAKE_VERSION(major, minor, patch); }
enable_layer                     :: (using builder : *InstanceBuilder, name : string)                                  { array_add(*layers,     name); }
enable_extension                 :: (using builder : *InstanceBuilder, name : string)                                  { array_add(*extensions, name); }
enable_validation_layers         :: (using builder : *InstanceBuilder, enable := true)                                 { enableValidationLayers  = enable; }
request_validation_layers        :: (using builder : *InstanceBuilder, enable := true)                                 { requestValidationLayers = enable; }
set_debug_callback_user_data_ptr :: (using builder : *InstanceBuilder, data : *void)                                   { debugUserDataPointer = data; }
set_headless                     :: (using builder : *InstanceBuilder, headless := true)                               { headlessContext = headless; }
set_debug_messenger_severity     :: (using builder : *InstanceBuilder, severity : VkDebugUtilsMessageSeverityFlagsEXT) { debugMessageSeverity = severity; }
add_debug_messenger_severity     :: (using builder : *InstanceBuilder, severity : VkDebugUtilsMessageSeverityFlagsEXT) { debugMessageSeverity |= severity; }
set_debug_messenger_type         :: (using builder : *InstanceBuilder, type : VkDebugUtilsMessageTypeFlagsEXT)         { debugMessageType = type; }
add_debug_messenger_type         :: (using builder : *InstanceBuilder, type : VkDebugUtilsMessageTypeFlagsEXT)         { debugMessageType |= type; }
disable_validation_check         :: (using builder : *InstanceBuilder, check : VkValidationCheckEXT)                   { array_add(*disabledValidationChecks, check); }
enable_validation_feature        :: (using builder : *InstanceBuilder, feature : VkValidationFeatureEnableEXT)         { array_add(*enabledValidationFeatures, feature); }
disable_validation_feature       :: (using builder : *InstanceBuilder, feature : VkValidationFeatureDisableEXT)        { array_add(*disabledValidationFeatures, feature); }
set_allocation_callbacks         :: (using builder : *InstanceBuilder, callbacks : *VkAllocationCallbacks)             { allocationCallbacks = callbacks; }

use_default_debug_messenger  :: (using builder : *InstanceBuilder) {
    useDebugMessenger = true;
    debugCallback = default_debug_callback;
}

set_debug_callback :: (using builder : *InstanceBuilder, callback : PFN_vkDebugUtilsMessengerCallbackEXT) {
    useDebugMessenger = true;
    debugCallback = callback;
}


build :: (builder : *InstanceBuilder) -> *Instance, InstanceError {
    instance := New(Instance);
    
    systemInfo := make_system_info();
    
    // Verify version and get application info
    instanceVersion := VK_API_VERSION_1_0;
    if builder.minimumInstanceVersion > VK_API_VERSION_1_0 || builder.requiredAPIVersion > VK_API_VERSION_1_0 || builder.desiredAPIVersion > VK_API_VERSION_1_0 {
        result := vkEnumerateInstanceVersion(*instanceVersion);
        if result != .SUCCESS && builder.requiredAPIVersion > 0 {
            return instance, .Vulkan_Version_Unavailable;
        }
        
        if instanceVersion < builder.minimumInstanceVersion || (builder.minimumInstanceVersion == 0 && instanceVersion < builder.requiredAPIVersion) {
            if VK_VERSION_MINOR(builder.requiredAPIVersion) == 2 {
                return instance, .Vulkan_Version_1_2_Unavailable;
            } else if VK_VERSION_MINOR(builder.requiredAPIVersion) == 1 {
                return instance, .Vulkan_Version_1_1_Unavailable;
            } else {
                return instance, .Vulkan_Version_Unavailable;
            }
        }
    }
    
    apiVersion : u32 = ifx instanceVersion < VK_API_VERSION_1_1 then instanceVersion else builder.requiredAPIVersion;
    if builder.desiredAPIVersion > VK_API_VERSION_1_0 && instanceVersion >= builder.desiredAPIVersion {
        instanceVersion = builder.desiredAPIVersion;
        apiVersion = builder.desiredAPIVersion;
    }
    
    appName := to_c_string(builder.appName);
    engineName := to_c_string(builder.engineName);
    defer free(appName);
    defer free(engineName);
    
    vkAppInfo := VkApplicationInfo.{ .APPLICATION_INFO, null, appName, builder.appVersion, engineName, builder.engineVersion, apiVersion };
    
    // Extensions
    extensions : [..] *u8;
    defer cleanup_cstr_array(extensions);
    for builder.extensions {
        array_add(*extensions, to_c_string(it));
    }
    
    if builder.debugCallback && builder.useDebugMessenger && systemInfo.debugUtilsAvailable {
        array_add_if_unique(*extensions, to_c_string(VK_EXT_DEBUG_UTILS_EXTENSION_NAME));
    }
    
    properties2EXTEnabled : bool = apiVersion < VK_API_VERSION_1_1 && is_extension_available(systemInfo, VK_KHR_GET_PHYSICAL_DEVICE_PROPERTIES_2_EXTENSION_NAME);
    if properties2EXTEnabled {
        array_add_if_unique(*extensions, to_c_string(VK_KHR_GET_PHYSICAL_DEVICE_PROPERTIES_2_EXTENSION_NAME));
    }
    
    portabilityEnumerationSupport := is_extension_available(systemInfo, VK_KHR_PORTABILITY_ENUMERATION_EXTENSION_NAME);
    if portabilityEnumerationSupport {
        array_add_if_unique(*extensions, to_c_string(VK_KHR_PORTABILITY_ENUMERATION_EXTENSION_NAME));
    }
    
    if !builder.headlessContext {
        check_add_window_ext :: (name : string) -> bool #expand {
            if !is_extension_available(`systemInfo, name) then return false;
            array_add(*`extensions, to_c_string(name));
            return true;
        }
        
        khrSurfaceAdded := check_add_window_ext(VK_KHR_SURFACE_EXTENSION_NAME);
        
        #if OS == .WINDOWS {
            addedWindowExts := check_add_window_ext(VK_KHR_WIN32_SURFACE_EXTENSION_NAME);
        } else if OS == .LINUX {
            // TODO
        } else if OS == .MACOS {
            // TODO
        } else if OS == .ANDROID {
            // TODO
        }
        if !khrSurfaceAdded || !addedWindowExts then return instance, .Windowing_Extensions_Not_Present;
    }
    
    if !are_extensions_available(systemInfo, extensions) {
        return instance, .Requested_Extensions_Not_Present;
    }
    
    // Layers
    layers : [..] *u8;
    defer cleanup_cstr_array(layers);
    for builder.layers {
        array_add(*layers, to_c_string(it));
    }
    
    if builder.enableValidationLayers || (builder.requestValidationLayers && systemInfo.validationLayersAvailable) {
        array_add_if_unique(*layers, to_c_string(VALIDATION_LAYER_NAME));
    }
    
    if !are_layers_available(systemInfo, layers) {
        return instance, .Requested_Layers_Not_Present;
    }
    
    // Validation Chain setup
    pNextChain : [..] *VkBaseOutStructure;
    
    messengerCreateInfo : VkDebugUtilsMessengerCreateInfoEXT;
    if builder.useDebugMessenger {
        messengerCreateInfo.messageSeverity = builder.debugMessageSeverity;
        messengerCreateInfo.messageType     = builder.debugMessageType;
        messengerCreateInfo.pfnUserCallback = builder.debugCallback;
        messengerCreateInfo.pUserData       = builder.debugUserDataPointer;
        array_add(*pNextChain, cast(*VkBaseOutStructure) *messengerCreateInfo);
    }
    
    features : VkValidationFeaturesEXT;
    if builder.enabledValidationFeatures.count || builder.disabledValidationFeatures {
        features.enabledValidationFeatureCount  = xx builder.enabledValidationFeatures.count;
        features.pEnabledValidationFeatures     = builder.enabledValidationFeatures.data;
        features.disabledValidationFeatureCount = xx builder.disabledValidationFeatures.count;
        features.pDisabledValidationFeatures    = builder.disabledValidationFeatures.data;
        array_add(*pNextChain, cast(*VkBaseOutStructure) *features);
    }
    
    checks : VkValidationFlagsEXT;
    if builder.disabledValidationChecks.count {
        checks.disabledValidationCheckCount = xx builder.disabledValidationChecks.count;
        checks.pDisabledValidationChecks = builder.disabledValidationChecks.data;
        array_add(*pNextChain, cast(*VkBaseOutStructure) *checks);
    }
    
    instanceCreateInfo := VkInstanceCreateInfo.{
        .INSTANCE_CREATE_INFO, null,
        builder.flags, *vkAppInfo,
        xx layers.count, layers.data,
        xx extensions.count, extensions.data        
    };
    setup_pNext_chain(*instanceCreateInfo, *pNextChain);
    for pNextChain {
        assert(it.sType != .APPLICATION_INFO);
    }
    if portabilityEnumerationSupport then instanceCreateInfo.flags |= .ENUMERATE_PORTABILITY_BIT_KHR;
    
    if vkCreateInstance(*instanceCreateInfo, builder.allocationCallbacks, *instance.instance) != .SUCCESS {
        return instance, .Failed_Create_Instance;
    }
    
    if builder.useDebugMessenger {
        messengerCreate := VkDebugUtilsMessengerCreateInfoEXT.{
            .DEBUG_UTILS_MESSENGER_CREATE_INFO_EXT, null, 0,
            builder.debugMessageSeverity, builder.debugMessageType, builder.debugCallback, builder.debugUserDataPointer
         };
        
        vkCreateDebugUtilsMessengerEXT : PFN_vkCreateDebugUtilsMessengerEXT = xx vkGetInstanceProcAddr(instance.instance, "vkCreateDebugUtilsMessengerEXT");
        
        if vkCreateDebugUtilsMessengerEXT {
            if vkCreateDebugUtilsMessengerEXT(instance.instance, *messengerCreateInfo, builder.allocationCallbacks, *instance.debugMessenger) != .SUCCESS {
                return instance, .Failed_Create_Debug_Messenger;
            }
        }
    }
    
    instance.headless = builder.headlessContext;
    instance.properties2EXTEnabled = properties2EXTEnabled;
    instance.allocationCallbacks = builder.allocationCallbacks;
    instance.instanceVersion = instanceVersion;
    instance.apiVersion = apiVersion;
    
    return instance, .Success;
}
