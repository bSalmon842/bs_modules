GPU_Device            :: void;
GPU_Buffer            :: void;
GPU_Transfer_Buffer   :: void;
GPU_Texture           :: void;
GPU_Sampler           :: void;
GPU_Shader            :: void;
GPU_Compute_Pipeline  :: void;
GPU_Graphics_Pipeline :: void;
GPU_Command_Buffer    :: void;
GPU_Render_Pass       :: void;
GPU_Compute_Pass      :: void;
GPU_Copy_Pass         :: void;
GPU_Fence             :: void;

GPU_Primitive_Type :: enum u32
{
    TRIANGLELIST;
    TRIANGLESTRIP;
    LINELIST;
    LINESTRIP;
    POINTLIST;
}

GPU_Load_Op :: enum u32
{
    LOAD;
    CLEAR;
    DONT_CARE;
}

GPU_Store_Op :: enum u32
{
    STORE;
    DONT_CARE;
    RESOLVE;
    RESOLVE_AND_STORE;
}

GPU_Index_Element_Size :: enum u32
{
    SIZE_16BIT;
    SIZE_32BIT;
}

GPU_Texture_Format :: enum u32
{
    INVALID;
    A8_UNORM;
    R8_UNORM;
    R8G8_UNORM;
    R8G8B8A8_UNORM;
    R16_UNORM;
    R16G16_UNORM;
    R16G16B16A16_UNORM;
    R10G10B10A2_UNORM;
    B5G6R5_UNORM;
    B5G5R5A1_UNORM;
    B4G4R4A4_UNORM;
    B8G8R8A8_UNORM;
    BC1_RGBA_UNORM;
    BC2_RGBA_UNORM;
    BC3_RGBA_UNORM;
    BC4_R_UNORM;
    BC5_RG_UNORM;
    BC7_RGBA_UNORM;
    BC6H_RGB_FLOAT;
    BC6H_RGB_UFLOAT;
    R8_SNORM;
    R8G8_SNORM;
    R8G8B8A8_SNORM;
    R16_SNORM;
    R16G16_SNORM;
    R16G16B16A16_SNORM;
    R16_FLOAT;
    R16G16_FLOAT;
    R16G16B16A16_FLOAT;
    R32_FLOAT;
    R32G32_FLOAT;
    R32G32B32A32_FLOAT;
    R11G11B10_UFLOAT;
    R8_UINT;
    R8G8_UINT;
    R8G8B8A8_UINT;
    R16_UINT;
    R16G16_UINT;
    R16G16B16A16_UINT;
    R32_UINT;
    R32G32_UINT;
    R32G32B32A32_UINT;
    R8_INT;
    R8G8_INT;
    R8G8B8A8_INT;
    R16_INT;
    R16G16_INT;
    R16G16B16A16_INT;
    R32_INT;
    R32G32_INT;
    R32G32B32A32_INT;
    R8G8B8A8_UNORM_SRGB;
    B8G8R8A8_UNORM_SRGB;
    BC1_RGBA_UNORM_SRGB;
    BC2_RGBA_UNORM_SRGB;
    BC3_RGBA_UNORM_SRGB;
    BC7_RGBA_UNORM_SRGB;
    D16_UNORM;
    D24_UNORM;
    D32_FLOAT;
    D24_UNORM_S8_UINT;
    D32_FLOAT_S8_UINT;
    ASTC_4x4_UNORM;
    ASTC_5x4_UNORM;
    ASTC_5x5_UNORM;
    ASTC_6x5_UNORM;
    ASTC_6x6_UNORM;
    ASTC_8x5_UNORM;
    ASTC_8x6_UNORM;
    ASTC_8x8_UNORM;
    ASTC_10x5_UNORM;
    ASTC_10x6_UNORM;
    ASTC_10x8_UNORM;
    ASTC_10x10_UNORM;
    ASTC_12x10_UNORM;
    ASTC_12x12_UNORM;
    ASTC_4x4_UNORM_SRGB;
    ASTC_5x4_UNORM_SRGB;
    ASTC_5x5_UNORM_SRGB;
    ASTC_6x5_UNORM_SRGB;
    ASTC_6x6_UNORM_SRGB;
    ASTC_8x5_UNORM_SRGB;
    ASTC_8x6_UNORM_SRGB;
    ASTC_8x8_UNORM_SRGB;
    ASTC_10x5_UNORM_SRGB;
    ASTC_10x6_UNORM_SRGB;
    ASTC_10x8_UNORM_SRGB;
    ASTC_10x10_UNORM_SRGB;
    ASTC_12x10_UNORM_SRGB;
    ASTC_12x12_UNORM_SRGB;
    ASTC_4x4_FLOAT;
    ASTC_5x4_FLOAT;
    ASTC_5x5_FLOAT;
    ASTC_6x5_FLOAT;
    ASTC_6x6_FLOAT;
    ASTC_8x5_FLOAT;
    ASTC_8x6_FLOAT;
    ASTC_8x8_FLOAT;
    ASTC_10x5_FLOAT;
    ASTC_10x6_FLOAT;
    ASTC_10x8_FLOAT;
    ASTC_10x10_FLOAT;
    ASTC_12x10_FLOAT;
    ASTC_12x12_FLOAT;
}

GPU_Texture_Usage_Flags :: enum_flags u32
{
    SAMPLER                                 :: (1 << 0);
    COLOR_TARGET                            :: (1 << 1);
    DEPTH_STENCIL_TARGET                    :: (1 << 2);
    GRAPHICS_STORAGE_READ                   :: (1 << 3);
    COMPUTE_STORAGE_READ                    :: (1 << 4);
    COMPUTE_STORAGE_WRITE                   :: (1 << 5);
    COMPUTE_STORAGE_SIMULTANEOUS_READ_WRITE :: (1 << 6);
}

GPU_Texture_Type :: enum u32
{
    TYPE_2D;
    TYPE_2D_ARRAY;
    TYPE_3D;
    TYPE_CUBE;
    TYPE_CUBE_ARRAY;
}

GPU_Sample_Count :: enum u32
{
    ONE;
    TWO;
    FOUR;
    EIGHT;
}

GPU_Cube_Map_Face :: enum u32
{
    POSITIVEX;
    NEGATIVEX;
    POSITIVEY;
    NEGATIVEY;
    POSITIVEZ;
    NEGATIVEZ;
}

GPU_Buffer_Usage_Flags :: enum_flags u32
{
    VERTEX                                  :: (1 << 0);
    INDEX                                   :: (1 << 1);
    INDIRECT                                :: (1 << 2);
    GRAPHICS_STORAGE_READ                   :: (1 << 3);
    COMPUTE_STORAGE_READ                    :: (1 << 4);
    COMPUTE_STORAGE_WRITE                   :: (1 << 5);
}

GPU_Transfer_Buffer_Usage :: enum u32
{
    UPLOAD;
    DOWNLOAD;
}

GPU_Shader_Stage :: enum u32
{
    VERTEX;
    FRAGMENT;
}

GPU_Shader_Format :: enum_flags u32
{
    INVALID                                :: 0;
    PRIVATE                                :: (1 << 0);
    SPIRV                                  :: (1 << 1);
    DXBC                                   :: (1 << 2);
    DXIL                                   :: (1 << 3);
    MSL                                    :: (1 << 4);
    METALLIB                               :: (1 << 5);
}

GPU_Vertex_Element_Format :: enum u32
{
    INVALID;
    INT;
    INT2;
    INT3;
    INT4;
    UINT;
    UINT2;
    UINT3;
    UINT4;
    FLOAT;
    FLOAT2;
    FLOAT3;
    FLOAT4;
    BYTE2;
    BYTE4;
    UBYTE2;
    UBYTE4;
    BYTE2_NORM;
    BYTE4_NORM;
    UBYTE2_NORM;
    UBYTE4_NORM;
    SHORT2;
    SHORT4;
    USHORT2;
    USHORT4;
    SHORT2_NORM;
    SHORT4_NORM;
    USHORT2_NORM;
    USHORT4_NORM;
    HALF2;
    HALF4;
}

GPU_Vertex_Input_Rate :: enum u32
{
    VERTEX;
    INSTANCE;
}

GPU_Fill_Mode :: enum u32
{
    FILL;
    LINE;
}

GPU_Cull_Mode :: enum u32
{
    NONE;
    FRONT;
    BACK;
}

GPU_Front_Face :: enum u32
{
    COUNTER_CLOCKWISE;
    CLOCKWISE;
}

GPU_Compare_Op :: enum u32
{
    INVALID;
    NEVER;
    LESS;
    EQUAL;
    LESS_OR_EQUAL;
    GREATER;
    NOT_EQUAL;
    GREATER_OR_EQUAL;
    ALWAYS;
}

GPU_Stencil_Op :: enum u32
{
    INVALID;
    KEEP;
    ZERO;
    REPLACE;
    INCREMENT_AND_CLAMP;
    DECREMENT_AND_CLAMP;
    INVERT;
    INCREMENT_AND_WRAP;
    DECREMENT_AND_WRAP;
}

GPU_Blend_Op :: enum u32
{
    INVALID;
    ADD;
    SUBTRACT;
    REVERSE_SUBTRACT;
    MIN;
    MAX;
}

GPU_Blend_Factor :: enum u32
{
    INVALID;
    ZERO;
    ONE;
    SRC_COLOR;
    ONE_MINUS_SRC_COLOR;
    DST_COLOR;
    ONE_MINUS_DST_COLOR;
    SRC_ALPHA;
    ONE_MINUS_SRC_ALPHA;
    DST_ALPHA;
    ONE_MINUS_DST_ALPHA;
    CONSTANT_COLOR;
    ONE_MINUS_CONSTANT_COLOR;
    SRC_ALPHA_SATURATE;
}

GPU_Color_Component_Flags :: enum_flags u8
{
    R :: (1 << 0);
    G :: (1 << 1);
    B :: (1 << 2);
    A :: (1 << 3);
}

GPU_Filter :: enum u32
{
    NEAREST;
    LINEAR;
}

GPU_Sampler_Mipmap_Mode :: enum u32
{
    NEAREST;
    LINEAR;
}

GPU_Sampler_Address_Mode :: enum u32
{
    REPEAT;
    MIRRORED_REPEAT;
    CLAMP_TO_EDGE;
}

GPU_Present_Mode :: enum u32
{
    VSYNC;
    IMMEDIATE;
    MAILBOX;
}

GPU_Swapchain_Composition :: enum u32
{
    SDR;
    SDR_LINEAR;
    HDR_EXTENDED_LINEAR;
    HDR10_ST2048;
}

GPU_Viewport :: struct
{
    x:         float32;
    y:         float32;
    w:         float32;
    h:         float32;
    min_depth: float32;
    max_depth: float32;
}

GPU_Texture_Transfer_Info :: struct
{
    transfer_buffer: *GPU_Transfer_Buffer;
    offset:          u32;
    pixels_per_row:  u32;
    rows_per_layer:  u32;
}

GPU_Transfer_Buffer_Location :: struct
{
    transfer_buffer: *GPU_Transfer_Buffer;
    offset:          u32;
}

GPU_Texture_Location :: struct
{
    texture:   *GPU_Texture;
    mip_level: u32;
    layer:     u32;
    x:         u32;
    y:         u32;
    z:         u32;
}

GPU_Texture_Region :: struct
{
    texture:   *GPU_Texture;
    mip_level: u32;
    layer:     u32;
    x:         u32;
    y:         u32;
    z:         u32;
    w:         u32;
    h:         u32;
    d:         u32;
}

GPU_Blit_Region :: struct
{
    texture:              *GPU_Texture;
    mip_level:            u32;
    layer_or_depth_plane: u32;
    x:                    u32;
    y:                    u32;
    w:                    u32;
    h:                    u32;
}

GPU_Buffer_Location :: struct
{
    buffer: *GPU_Buffer;
    offset: u32;
}

GPU_Buffer_Region :: struct
{
    buffer: *GPU_Buffer;
    offset: u32;
    size:   u32;
}

GPU_Indirect_Draw_Command :: struct
{
    num_vertices:   u32;
    num_instances:  u32;
    first_vertex:   u32;
    first_instance: u32;
}

GPU_Indexed_Indirect_Draw_Command :: struct
{
    num_indices:    u32;
    num_instances:  u32;
    first_index:    u32;
    vertex_offset:  s32;
    first_instance: u32;
}

GPU_Indirect_Dispatch_Command :: struct
{
    groupcount_x: u32;
    groupcount_y: u32;
    groupcount_z: u32;
}

GPU_Sampler_Create_Info :: struct
{
    min_filter:        GPU_Filter;
    mag_filter:        GPU_Filter;
    mipmap_mode:       GPU_Sampler_Mipmap_Mode;
    address_mode_u:    GPU_Sampler_Address_Mode;
    address_mode_v:    GPU_Sampler_Address_Mode;
    address_mode_w:    GPU_Sampler_Address_Mode;
    mip_lod_bias:      float32;
    max_anisotropy:    float32;
    compare_op:        GPU_Compare_Op;
    min_lod:           float32;
    max_lod:           float32;
    enable_anisotropy: bool;
    enable_compare:    bool;
    padding1:          u8;
    padding2:          u8;

    props:             Properties_ID;
}

GPU_Vertex_Buffer_Description :: struct
{
    slot:               u32;
    pitch:              u32;
    input_rate:         GPU_Vertex_Input_Rate;
    instance_step_rate: u32;
}

GPU_Vertex_Attribute :: struct
{
    location:    u32;
    buffer_slot: u32;
    format:      GPU_Vertex_Element_Format;
    offset:      u32;
}

GPU_Vertex_Input_State :: struct
{
    vertex_buffer_descriptions: *GPU_Vertex_Buffer_Description;
    num_vertex_buffers:         u32;
    vertex_attributes:          *GPU_Vertex_Attribute;
    num_vertex_attributes:      u32;
}

GPU_Stencil_Op_State :: struct
{
    fail_op:       GPU_Stencil_Op;
    pass_op:       GPU_Stencil_Op;
    depth_fail_op: GPU_Stencil_Op;
    compare_op:    GPU_Compare_Op;
}

GPU_Color_Target_Blend_State :: struct
{
    src_color_blendfactor:   GPU_Blend_Factor;
    dst_color_blendfactor:   GPU_Blend_Factor;
    color_blend_op:          GPU_Blend_Op;
    src_alpha_blendfactor:   GPU_Blend_Factor;
    dst_alpha_blendfactor:   GPU_Blend_Factor;
    alpha_blend_op:          GPU_Blend_Op;
    color_write_mask:        GPU_Color_Component_Flags;
    enable_blend:            bool;
    enable_color_write_mask: bool;
    padding1:                u8;
    padding2:                u8;
}

GPU_Shader_Create_Info :: struct
{
    code_size:            u64;
    code:                 *u8;
    entry_point:          *u8;
    format:               GPU_Shader_Format;
    stage:                GPU_Shader_Stage;
    num_samplers:         u32;
    num_storage_textures: u32;
    num_storage_buffers:  u32;
    num_uniform_buffers:  u32;

    props:                Properties_ID;
}

GPU_Texture_Create_Info :: struct
{
    type:                 GPU_Texture_Type;
    format:               GPU_Texture_Format;
    usage:                GPU_Texture_Usage_Flags;
    width:                u32;
    height:               u32;
    layer_count_or_depth: u32;
    num_levels:           u32;
    sample_count:         GPU_Sample_Count;

    props:                Properties_ID;
}

GPU_Buffer_Create_Info :: struct
{
    usage: GPU_Buffer_Usage_Flags;
    size:  u32;

    props: Properties_ID;
}

GPU_Transfer_Buffer_Create_Info :: struct
{
    usage: GPU_Transfer_Buffer_Usage;
    size:  u32;

    props: Properties_ID;
}

GPU_Rasterizer_State :: struct
{
    fill_mode:                  GPU_Fill_Mode;
    cull_mode:                  GPU_Cull_Mode;
    front_face:                 GPU_Front_Face;
    depth_bias_constant_factor: float32;
    depth_bias_clamp:           float32;
    depth_bias_slope_factor:    float32;
    enable_depth_bias:          bool;
    enable_depth_clip:          bool;
    padding1:                   u8;
    padding2:                   u8;
}

GPU_Multisample_State :: struct
{
    sample_count: GPU_Sample_Count;
    sample_mask:  u32;
    enable_mask:  bool;
    padding1:     u8;
    padding2:     u8;
    padding3:     u8;
}

GPU_Depth_Stencil_State :: struct
{
    compare_op:          GPU_Compare_Op;
    back_stencil_state:  GPU_Stencil_Op_State;
    front_stencil_state: GPU_Stencil_Op_State;
    compare_mask:        u8;
    write_mask:          u8;
    enable_depth_test:   bool;
    enable_depth_write:  bool;
    enable_stencil_test: bool;
    padding1:            u8;
    padding2:            u8;
    padding3:            u8;
}

GPU_Color_Target_Description :: struct
{
    format:      GPU_Texture_Format;
    blend_state: GPU_Color_Target_Blend_State;
}

GPU_Graphics_Pipeline_Target_Info :: struct
{
    color_target_descriptions: *GPU_Color_Target_Description;
    num_color_targets:         u32;
    depth_stencil_format:      GPU_Texture_Format;
    has_depth_stencil_target:  bool;
    padding1:                  u8;
    padding2:                  u8;
    padding3:                  u8;
}

GPU_Graphics_Pipeline_Create_Info :: struct
{
    vertex_shader:       *GPU_Shader;
    fragment_shader:     *GPU_Shader;
    vertex_input_state:  GPU_Vertex_Input_State;
    primitive_type:      GPU_Primitive_Type;
    rasterizer_state:    GPU_Rasterizer_State;
    multisample_state:   GPU_Multisample_State;
    depth_stencil_state: GPU_Depth_Stencil_State;
    target_info:         GPU_Graphics_Pipeline_Target_Info;

    props:               Properties_ID;
}

GPU_Compute_Pipeline_Create_Info :: struct
{
    code_size:                      u64;
    code:                           *u8;
    entry_point:                    *u8;
    format:                         GPU_Shader_Format;
    num_samplers:                   u32;
    num_readonly_storage_textures:  u32;
    num_readonly_storage_buffers:   u32;
    num_readwrite_storage_textures: u32;
    num_readwrite_storage_buffers:  u32;
    num_uniform_buffers:            u32;
    threadcount_x:                  u32;
    threadcount_y:                  u32;
    threadcount_z:                  u32;

    props:                          Properties_ID;
}

GPU_Color_Target_Info :: struct
{
    texture:                 *GPU_Texture;
    mip_level:               u32;
    layer_or_depth_plane:    u32;
    clear_color:             F_Color;
    load_op:                 GPU_Load_Op;
    store_op:                GPU_Store_Op;
    resolve_texture:         *GPU_Texture;
    resolve_mip_level:       u32;
    resolve_layer:           u32;
    cycle:                   bool;
    cycle_resolve_texture:   bool;
    padding1:                u8;
    padding2:                u8;
}

GPU_Depth_Stencil_Target_Info :: struct
{
    texture:                *GPU_Texture;
    clear_depth:            float32;
    load_op:                GPU_Load_Op;
    store_op:               GPU_Store_Op;
    stencil_load_op:        GPU_Load_Op;
    stencil_store_op:       GPU_Store_Op;
    cycle:                  bool;
    clear_stencil:          u8;
    padding1:               u8;
    padding2:               u8;
}

GPU_Blit_Info :: struct
{
    source:           GPU_Blit_Region;
    destination:      GPU_Blit_Region;
    load_op:          GPU_Load_Op;
    clear_color:      F_Color;
    flip_mode:        Flip_Mode;
    filter:           GPU_Filter;
    cycle:            bool;
    padding1:         u8;
    padding2:         u8;
    padding3:         u8;
}

GPU_Buffer_Binding :: struct
{
    buffer:  *GPU_Buffer;
    offset:  u32;
}

GPU_Texture_Sampler_Binding :: struct
{
    texture: *GPU_Texture;
    sampler: *GPU_Sampler;
}

GPU_Storage_Buffer_Read_Write_Binding :: struct
{
    buffer:   *GPU_Buffer;
    cycle:    bool;
    padding1: u8;
    padding2: u8;
    padding3: u8;
}

GPU_Storage_Texture_Read_Write_Binding :: struct
{
    texture:   *GPU_Texture;
    mip_level: u32;
    layer:     u32;
    cycle:     bool;
    padding1:  u8;
    padding2:  u8;
    padding3:  u8;
}


gpu_supports_shader_formats                 :: (format_flags: GPU_Shader_Format, name: *u8) -> bool                                                                                                                                     #foreign SDL3 "SDL_GPUSupportsShaderFormats";
gpu_supports_properties                     :: (props: Properties_ID) -> bool                                                                                                                                                           #foreign SDL3 "SDL_GPUSupportsProperties";
create_gpu_device                           :: (format_flags: GPU_Shader_Format, debug_mode: bool, name: *u8) -> *GPU_Device                                                                                                            #foreign SDL3 "SDL_CreateGPUDevice";
create_gpu_device_with_properties           :: (props: Properties_ID) -> *GPU_Device                                                                                                                                                    #foreign SDL3 "SDL_CreateGPUDeviceWithProperties";
destroy_gpu_device                          :: (device: *GPU_Device)                                                                                                                                                                    #foreign SDL3 "SDL_DestroyGPUDevice";
get_num_gpu_drivers                         :: () -> s32                                                                                                                                                                                #foreign SDL3 "SDL_GetNumGPUDrivers";
get_gpu_driver                              :: (index: s32) -> *u8                                                                                                                                                                      #foreign SDL3 "SDL_GetGPUDriver";
get_gpu_device_driver                       :: (device: *GPU_Device) -> *u8                                                                                                                                                             #foreign SDL3 "SDL_GetGPUDeviceDriver";
get_gpu_shader_formats                      :: (device: *GPU_Device) -> GPU_Shader_Format                                                                                                                                               #foreign SDL3 "SDL_GetGPUShaderFormats";
create_gpu_compute_pipeline                 :: (device: *GPU_Device, create_info: *GPU_Compute_Pipeline_Create_Info) -> *GPU_Compute_Pipeline                                                                                           #foreign SDL3 "SDL_CreateGPUComputePipeline";
create_gpu_graphics_pipeline                :: (device: *GPU_Device, create_info: *GPU_Graphics_Pipeline_Create_Info) -> *GPU_Graphics_Pipeline                                                                                         #foreign SDL3 "SDL_CreateGPUGraphicsPipeline";
create_gpu_sampler                          :: (device: *GPU_Device, create_info: *GPU_Sampler_Create_Info) -> *GPU_Sampler                                                                                                             #foreign SDL3 "SDL_CreateGPUSampler";
create_gpu_shader                           :: (device: *GPU_Device, create_info: *GPU_Shader_Create_Info) -> *GPU_Shader                                                                                                               #foreign SDL3 "SDL_CreateGPUShader";
create_gpu_texture                          :: (device: *GPU_Device, create_info: *GPU_Texture_Create_Info) -> *GPU_Texture                                                                                                             #foreign SDL3 "SDL_CreateGPUTexture";
create_gpu_buffer                           :: (device: *GPU_Device, create_info: *GPU_Buffer_Create_Info) -> *GPU_Buffer                                                                                                               #foreign SDL3 "SDL_CreateGPUBuffer";
create_gpu_transfer_buffer                  :: (device: *GPU_Device, create_info: *GPU_Transfer_Buffer_Create_Info) -> *GPU_Transfer_Buffer                                                                                             #foreign SDL3 "SDL_CreateGPUTransferBuffer";
set_gpu_buffer_name                         :: (device: *GPU_Device, buffer: *GPU_Buffer, text: *u8)                                                                                                                                    #foreign SDL3 "SDL_SetGPUBufferName";
set_gpu_texture_name                        :: (device: *GPU_Device, texture: *GPU_Texture, text: *u8)                                                                                                                                  #foreign SDL3 "SDL_SetGPUTextureName";
insert_gpu_debug_label                      :: (command_buffer: *GPU_Command_Buffer, text: *u8)                                                                                                                                         #foreign SDL3 "SDL_InsertGPUDebugLabel";
push_gpu_debug_group                        :: (command_buffer: *GPU_Command_Buffer, name: *u8)                                                                                                                                         #foreign SDL3 "SDL_PushGPUDebugGroup";
pop_gpu_debug_group                         :: (command_buffer: *GPU_Command_Buffer)                                                                                                                                                    #foreign SDL3 "SDL_PopGPUDebugGroup";
release_gpu_texture                         :: (device: *GPU_Device, texture: *GPU_Texture)                                                                                                                                             #foreign SDL3 "SDL_ReleaseGPUTexture";
release_gpu_sampler                         :: (device: *GPU_Device, sampler: *GPU_Sampler)                                                                                                                                             #foreign SDL3 "SDL_ReleaseGPUSampler";
release_gpu_buffer                          :: (device: *GPU_Device, buffer: *GPU_Buffer)                                                                                                                                               #foreign SDL3 "SDL_ReleaseGPUBuffer";
release_gpu_transfer_buffer                 :: (device: *GPU_Device, transfer_buffer: *GPU_Transfer_Buffer)                                                                                                                             #foreign SDL3 "SDL_ReleaseGPUTransferBuffer";
release_gpu_compute_pipeline                :: (device: *GPU_Device, compute_pipeline: *GPU_Compute_Pipeline)                                                                                                                           #foreign SDL3 "SDL_ReleaseGPUComputePipeline";
release_gpu_shader                          :: (device: *GPU_Device, shader: *GPU_Shader)                                                                                                                                               #foreign SDL3 "SDL_ReleaseGPUShader";
release_gpu_graphics_pipeline               :: (device: *GPU_Device, graphics_pipeline: *GPU_Graphics_Pipeline)                                                                                                                         #foreign SDL3 "SDL_ReleaseGPUGraphicsPipeline";
acquire_gpu_command_buffer                  :: (device: *GPU_Device) -> *GPU_Command_Buffer                                                                                                                                             #foreign SDL3 "SDL_AcquireGPUCommandBuffer";
push_gpu_vertex_uniform_data                :: (command_buffer: *GPU_Command_Buffer, slot_index: u32, data: *void, length: u32)                                                                                                         #foreign SDL3 "SDL_PushGPUVertexUniformData";
push_gpu_fragment_uniform_data              :: (command_buffer: *GPU_Command_Buffer, slot_index: u32, data: *void, length: u32)                                                                                                         #foreign SDL3 "SDL_PushGPUFragmentUniformData";
push_gpu_compute_uniform_data               :: (command_buffer: *GPU_Command_Buffer, slot_index: u32, data: *void, length: u32)                                                                                                         #foreign SDL3 "SDL_PushGPUComputeUniformData";
begin_gpu_render_pass                       :: (command_buffer: *GPU_Command_Buffer, color_target_infos: *GPU_Color_Target_Info, num_color_targets: u32, depth_stencil_target_info: *GPU_Depth_Stencil_Target_Info) -> *GPU_Render_Pass #foreign SDL3 "SDL_BeginGPURenderPass";
bind_gpu_graphics_pipeline                  :: (render_pass: *GPU_Render_Pass, graphics_pipeline: *GPU_Graphics_Pipeline)                                                                                                               #foreign SDL3 "SDL_BindGPUGraphicsPipeline";
set_gpu_viewport                            :: (render_pass: *GPU_Render_Pass, viewport: *GPU_Viewport)                                                                                                                                 #foreign SDL3 "SDL_SetGPUViewport";
set_gpu_scissor                             :: (render_pass: *GPU_Render_Pass, scissor: *Rect)                                                                                                                                          #foreign SDL3 "SDL_SetGPUScissor";
set_gpu_blend_constants                     :: (render_pass: *GPU_Render_Pass, blend_constants: F_Color)                                                                                                                                 #foreign SDL3 "SDL_SetGPUBlendConstants";
set_gpu_stencil_reference                   :: (render_pass: *GPU_Render_Pass, reference: u8)                                                                                                                                           #foreign SDL3 "SDL_SetGPUStencilReference";
bind_gpu_vertex_buffers                     :: (render_pass: *GPU_Render_Pass, first_slot: u32, bindings: *GPU_Buffer_Binding, num_bindings: u32)                                                                                       #foreign SDL3 "SDL_BindGPUVertexBuffers";
bind_gpu_index_buffer                       :: (render_pass: *GPU_Render_Pass, binding: *GPU_Buffer_Binding, index_element_size: GPU_Index_Element_Size)                                                                                #foreign SDL3 "SDL_BindGPUIndexBuffer";
bind_gpu_vertex_samplers                    :: (render_pass: *GPU_Render_Pass, first_slot: u32, texture_sampler_bindings: *GPU_Texture_Sampler_Binding, num_bindings: u32)                                                              #foreign SDL3 "SDL_BindGPUVertexSamplers";
bind_gpu_vertex_storage_textures            :: (render_pass: *GPU_Render_Pass, first_slot: u32, storage_textures: **GPU_Texture, num_bindings: u32)                                                                                     #foreign SDL3 "SDL_BindGPUVertexStorageTextures";
bind_gpu_vertex_storage_buffers             :: (render_pass: *GPU_Render_Pass, first_slot: u32, storage_buffers: **GPU_Buffer, num_bindings: u32)                                                                                       #foreign SDL3 "SDL_BindGPUVertexStorageBuffers";
bind_gpu_fragment_samplers                  :: (render_pass: *GPU_Render_Pass, first_slot: u32, texture_sampler_bindings: *GPU_Texture_Sampler_Binding, num_bindings: u32)                                                              #foreign SDL3 "SDL_BindGPUFragmentSamplers";
bind_gpu_fragment_storage_textures          :: (render_pass: *GPU_Render_Pass, first_slot: u32, storage_textures: **GPU_Texture, num_bindings: u32)                                                                                     #foreign SDL3 "SDL_BindGPUFragmentStorageTextures";
bind_gpu_fragment_storage_buffers           :: (render_pass: *GPU_Render_Pass, first_slot: u32, storage_buffers: **GPU_Buffer, num_bindings: u32)                                                                                       #foreign SDL3 "SDL_BindGPUFragmentStorageBuffers";
draw_gpu_indexed_primitives                 :: (render_pass: *GPU_Render_Pass, num_indices: u32, num_instances: u32, first_index: u32, vertex_offset: s32, first_instance: u32)                                                         #foreign SDL3 "SDL_DrawGPUIndexedPrimitives";
draw_gpu_primitives                         :: (render_pass: *GPU_Render_Pass, num_vertices: u32, num_instances: u32, first_vertex: u32, first_instance: u32)                                                                           #foreign SDL3 "SDL_DrawGPUPrimitives";
draw_gpu_primitives_indirect                :: (render_pass: *GPU_Render_Pass, buffer: *GPU_Buffer, offset: u32, draw_count: u32)                                                                                                       #foreign SDL3 "SDL_DrawGPUPrimitivesIndirect";
draw_gpu_indexed_primitives_indirect        :: (render_pass: *GPU_Render_Pass, buffer: *GPU_Buffer, offset: u32, draw_count: u32)                                                                                                       #foreign SDL3 "SDL_DrawGPUIndexedPrimitivesIndirect";
end_gpu_render_pass                         :: (render_pass: *GPU_Render_Pass)                                                                                                                                                          #foreign SDL3 "SDL_EndGPURenderPass";
bind_gpu_compute_pipeline                   :: (compute_pass: *GPU_Compute_Pass, compute_pipeline: *GPU_Compute_Pipeline)                                                                                                               #foreign SDL3 "SDL_BindGPUComputePipeline";
bind_gpu_compute_samplers                   :: (compute_pass: *GPU_Compute_Pass, first_slot: u32, texture_sampler_bindings: *GPU_Texture_Sampler_Binding, num_bindings: u32)                                                            #foreign SDL3 "SDL_BindGPUComputeSamplers";
bind_gpu_compute_storage_textures           :: (compute_pass: *GPU_Compute_Pass, first_slot: u32, storage_textures: **GPU_Texture, num_bindings: u32)                                                                                   #foreign SDL3 "SDL_BindGPUComputeStorageTextures";
bind_gpu_compute_storage_buffers            :: (compute_pass: *GPU_Compute_Pass, first_slot: u32, storage_buffers: **GPU_Buffer, num_bindings: u32)                                                                                     #foreign SDL3 "SDL_BindGPUComputeStorageBuffers";
dispatch_gpu_compute                        :: (compute_pass: *GPU_Compute_Pass, groupcount_x: u32, groupcount_y: u32, groupcount_z: u32)                                                                                               #foreign SDL3 "SDL_DispatchGPUCompute";
dispatch_gpu_compute_indirect               :: (compute_pass: *GPU_Compute_Pass, buffer: *GPU_Buffer, offset: u32)                                                                                                                      #foreign SDL3 "SDL_DispatchGPUComputeIndirect";
end_gpu_compute_pass                        :: (compute_pass: *GPU_Compute_Pass)                                                                                                                                                        #foreign SDL3 "SDL_EndGPUComputePass";
map_gpu_transfer_buffer                     :: (device: *GPU_Device, transfer_buffer: *GPU_Transfer_Buffer, cycle: bool) -> *void                                                                                                       #foreign SDL3 "SDL_MapGPUTransferBuffer";
unmap_gpu_transfer_buffer                   :: (device: *GPU_Device, transfer_buffer: *GPU_Transfer_Buffer)                                                                                                                             #foreign SDL3 "SDL_UnmapGPUTransferBuffer";
begin_gpu_copy_pass                         :: (command_buffer: *GPU_Command_Buffer) -> *GPU_Copy_Pass                                                                                                                                  #foreign SDL3 "SDL_BeginGPUCopyPass";
upload_to_gpu_texture                       :: (copy_pass: *GPU_Copy_Pass, source: *GPU_Texture_Transfer_Info, destination: *GPU_Texture_Region, cycle: bool)                                                                           #foreign SDL3 "SDL_UploadToGPUTexture";
upload_to_gpu_buffer                        :: (copy_pass: *GPU_Copy_Pass, source: *GPU_Transfer_Buffer_Location, destination: *GPU_Buffer_Region, cycle: bool)                                                                         #foreign SDL3 "SDL_UploadToGPUBuffer";
copy_gpu_texture_to_texture                 :: (copy_pass: *GPU_Copy_Pass, source: *GPU_Texture_Location, destination: *GPU_Texture_Location, w: u32, h: u32, d: u32, cycle: bool)                                                      #foreign SDL3 "SDL_CopyGPUTextureToTexture";
copy_gpu_buffer_to_buffer                   :: (copy_pass: *GPU_Copy_Pass, source: *GPU_Buffer_Location, destination: *GPU_Buffer_Location, size: u32, cycle: bool)                                                                     #foreign SDL3 "SDL_CopyGPUBufferToBuffer";
download_from_gpu_texture                   :: (copy_pass: *GPU_Copy_Pass, source: *GPU_Texture_Region, destination: *GPU_Texture_Transfer_Info)                                                                                        #foreign SDL3 "SDL_DownloadFromGPUTexture";
download_from_gpu_buffer                    :: (copy_pass: *GPU_Copy_Pass, source: *GPU_Buffer_Region, destination: *GPU_Transfer_Buffer_Location)                                                                                      #foreign SDL3 "SDL_DownloadFromGPUBuffer";
end_gpu_copy_pass                           :: (copy_pass: *GPU_Copy_Pass)                                                                                                                                                              #foreign SDL3 "SDL_EndGPUCopyPass";
generate_mipmaps_for_gpu_texture            :: (command_buffer: *GPU_Command_Buffer, texture: *GPU_Texture)                                                                                                                             #foreign SDL3 "SDL_GenerateMipmapsForGPUTexture";
blit_gpu_texture                            :: (command_buffer: *GPU_Command_Buffer, info: *GPU_Blit_Info)                                                                                                                              #foreign SDL3 "SDL_BlitGPUTexture";
window_supports_gpu_swapchain_composition   :: (device: *GPU_Device, window: *Window, swapchain_composition: GPU_Swapchain_Composition) -> bool                                                                                         #foreign SDL3 "SDL_WindowSupportsGPUSwapchainComposition";
window_supports_gpu_present_mode            :: (device: *GPU_Device, window: *Window, present_mode: GPU_Present_Mode) -> bool                                                                                                           #foreign SDL3 "SDL_WindowSupportsGPUPresentMode";
claim_window_for_gpu_device                 :: (device: *GPU_Device, window: *Window) -> bool                                                                                                                                           #foreign SDL3 "SDL_ClaimWindowForGPUDevice";
release_window_from_gpu_device              :: (device: *GPU_Device, window: *Window)                                                                                                                                                   #foreign SDL3 "SDL_ReleaseWindowFromGPUDevice";
set_gpu_swapchain_parameters                :: (device: *GPU_Device, window: *Window, swapchain_composition: GPU_Swapchain_Composition, present_mode: GPU_Present_Mode) -> bool                                                         #foreign SDL3 "SDL_SetGPUSwapchainParameters";
get_gpu_swapchain_texture_format            :: (device: *GPU_Device, window: *Window) -> GPU_Texture_Format                                                                                                                             #foreign SDL3 "SDL_GetGPUSwapchainTextureFormat";
acquire_gpu_swapchain_texture               :: (command_buffer: *GPU_Command_Buffer, window: *Window, swapchain_texture: **GPU_Texture, swapchain_texture_width: *u32, swapchain_texture_height: *u32) -> bool                          #foreign SDL3 "SDL_AcquireGPUSwapchainTexture";
submit_gpu_command_buffer                   :: (command_buffer: *GPU_Command_Buffer) -> bool                                                                                                                                            #foreign SDL3 "SDL_SubmitGPUCommandBuffer";
submit_gpu_command_buffer_and_acquire_fence :: (command_buffer: *GPU_Command_Buffer) -> *GPU_Fence                                                                                                                                      #foreign SDL3 "SDL_SubmitGPUCommandBufferAndAcquireFence";
cancel_gpu_command_buffer                   :: (command_buffer: *GPU_Command_Buffer) -> bool                                                                                                                                            #foreign SDL3 "SDL_CancelGPUCommandBuffer";
wait_for_gpu_idle                           :: (device: *GPU_Device) -> bool                                                                                                                                                            #foreign SDL3 "SDL_WaitForGPUIdle";
wait_for_gpu_fences                         :: (device: *GPU_Device, wait_all: bool, fences: **GPU_Fence, num_fences: u32) -> bool                                                                                                      #foreign SDL3 "SDL_WaitForGPUFences";
query_gpu_fence                             :: (device: *GPU_Device, fence: *GPU_Fence) -> bool                                                                                                                                         #foreign SDL3 "SDL_QueryGPUFence";
release_gpu_fence                           :: (device: *GPU_Device, fence: *GPU_Fence)                                                                                                                                                 #foreign SDL3 "SDL_ReleaseGPUFence";
gpu_texture_format_texel_block_size         :: (format: GPU_Texture_Format) -> u32                                                                                                                                                      #foreign SDL3 "SDL_GPUTextureFormatTexelBlockSize";
gpu_texture_supports_format                 :: (device: *GPU_Device, format: GPU_Texture_Format, type: GPU_Texture_Type, usage: GPU_Texture_Usage_Flags) -> bool                                                                        #foreign SDL3 "SDL_GPUTextureSupportsFormat";
gpu_texture_supports_sample_count           :: (device: *GPU_Device, format: GPU_Texture_Format, sample_count: GPU_Sample_Count) -> bool                                                                                                #foreign SDL3 "SDL_GPUTextureSupportsSampleCount";
calculate_gpu_texture_format_size           :: (format: GPU_Texture_Format, width: u32, depth: u32, depth_of_layer_count: u32) -> u32                                                                                                   #foreign SDL3 "SDL_CalculateGPUTextureFormatSize";

begin_gpu_compute_pass           :: (command_buffer: *GPU_Command_Buffer, storage_texture_bindings: *GPU_Storage_Texture_Read_Write_Binding, num_storage_texture_bindings: u32, storage_buffer_bindings: *GPU_Storage_Buffer_Read_Write_Binding, num_storage_buffer_bindings: u32) -> *GPU_Compute_Pass #foreign SDL3 "SDL_BeginGPUComputePass";



PROP_GPU_DEVICE_CREATE_DEBUGMODE_BOOLEAN          :: "SDL.gpu.device.create.debugmode";
PROP_GPU_DEVICE_CREATE_PREFERLOWPOWER_BOOLEAN     :: "SDL.gpu.device.create.preferlowpower";
PROP_GPU_DEVICE_CREATE_NAME_STRING                :: "SDL.gpu.device.create.name";
PROP_GPU_DEVICE_CREATE_SHADERS_PRIVATE_BOOLEAN    :: "SDL.gpu.device.create.shaders.private";
PROP_GPU_DEVICE_CREATE_SHADERS_SPIRV_BOOLEAN      :: "SDL.gpu.device.create.shaders.spirv";
PROP_GPU_DEVICE_CREATE_SHADERS_DXBC_BOOLEAN       :: "SDL.gpu.device.create.shaders.dxbc";
PROP_GPU_DEVICE_CREATE_SHADERS_DXIL_BOOLEAN       :: "SDL.gpu.device.create.shaders.dxil";
PROP_GPU_DEVICE_CREATE_SHADERS_MSL_BOOLEAN        :: "SDL.gpu.device.create.shaders.msl";
PROP_GPU_DEVICE_CREATE_SHADERS_METALLIB_BOOLEAN   :: "SDL.gpu.device.create.shaders.metallib";
PROP_GPU_DEVICE_CREATE_D3D12_SEMANTIC_NAME_STRING :: "SDL.gpu.device.create.d3d12.semantic";

PROP_GPU_CREATETEXTURE_D3D12_CLEAR_R_FLOAT       :: "SDL.gpu.createtexture.d3d12.clear.r";
PROP_GPU_CREATETEXTURE_D3D12_CLEAR_G_FLOAT       :: "SDL.gpu.createtexture.d3d12.clear.g";
PROP_GPU_CREATETEXTURE_D3D12_CLEAR_B_FLOAT       :: "SDL.gpu.createtexture.d3d12.clear.b";
PROP_GPU_CREATETEXTURE_D3D12_CLEAR_A_FLOAT       :: "SDL.gpu.createtexture.d3d12.clear.a";
PROP_GPU_CREATETEXTURE_D3D12_CLEAR_DEPTH_FLOAT   :: "SDL.gpu.createtexture.d3d12.clear.depth";
PROP_GPU_CREATETEXTURE_D3D12_CLEAR_STENCIL_UINT8 :: "SDL.gpu.createtexture.d3d12.clear.stencil";
