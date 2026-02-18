Init_Flags   :: enum_flags u32
{
    JPG  :: 0x00000001;
    PNG  :: 0x00000002;
    TIF  :: 0x00000004;
    WEBP :: 0x00000008;
    JXL  :: 0x00000010;
    AVIF :: 0x00000020;
}

Animation :: struct
{
    w, h:   s32;
    count:  s32;
    frames: **Surface;
    delays: *s32;
}

version                       :: () -> s32                                                                     #foreign SDL3_image "IMG_Version";
init                          :: (flags: Init_Flags) -> Init_Flags                                             #foreign SDL3_image "IMG_Init";
quit                          :: ()                                                                            #foreign SDL3_image "IMG_Quit";
load_typed_io                 :: (src: *IO_Stream, close_io: bool, type: *u8) -> *Surface                      #foreign SDL3_image "IMG_LoadTyped_IO";
load                          :: (file: *u8) -> *Surface                                                       #foreign SDL3_image "IMG_Load";
load_io                       :: (src: *IO_Stream, close_io: bool) -> *Surface                                 #foreign SDL3_image "IMG_Load_IO";
load_texture                  :: (renderer: *Renderer, file: *u8) -> *Texture                                  #foreign SDL3_image "IMG_LoadTexture";
load_texture_io               :: (renderer: *Renderer, src: *IO_Stream, close_io: bool) -> *Texture            #foreign SDL3_image "IMG_LoadTexture_IO";
load_texture_typed_io         :: (renderer: *Renderer, src: *IO_Stream, close_io: bool, type: *u8) -> *Texture #foreign SDL3_image "IMG_LoadTextureTyped_IO";
is_avif                       :: (src: *IO_Stream) -> bool                                                     #foreign SDL3_image "IMG_isAVIF";
is_ico                        :: (src: *IO_Stream) -> bool                                                     #foreign SDL3_image "IMG_isICO";
is_cur                        :: (src: *IO_Stream) -> bool                                                     #foreign SDL3_image "IMG_isCUR";
is_bmp                        :: (src: *IO_Stream) -> bool                                                     #foreign SDL3_image "IMG_isBMP";
is_gif                        :: (src: *IO_Stream) -> bool                                                     #foreign SDL3_image "IMG_isGIF";
is_jpg                        :: (src: *IO_Stream) -> bool                                                     #foreign SDL3_image "IMG_isJPG";
is_jxl                        :: (src: *IO_Stream) -> bool                                                     #foreign SDL3_image "IMG_isJXL";
is_lbm                        :: (src: *IO_Stream) -> bool                                                     #foreign SDL3_image "IMG_isLBM";
is_pcx                        :: (src: *IO_Stream) -> bool                                                     #foreign SDL3_image "IMG_isPCX";
is_png                        :: (src: *IO_Stream) -> bool                                                     #foreign SDL3_image "IMG_isPNG";
is_pnm                        :: (src: *IO_Stream) -> bool                                                     #foreign SDL3_image "IMG_isPNM";
is_svg                        :: (src: *IO_Stream) -> bool                                                     #foreign SDL3_image "IMG_isSVG";
is_qoi                        :: (src: *IO_Stream) -> bool                                                     #foreign SDL3_image "IMG_isQOI";
is_tif                        :: (src: *IO_Stream) -> bool                                                     #foreign SDL3_image "IMG_isTIF";
is_xcf                        :: (src: *IO_Stream) -> bool                                                     #foreign SDL3_image "IMG_isXCF";
is_xpm                        :: (src: *IO_Stream) -> bool                                                     #foreign SDL3_image "IMG_isXPM";
is_xv                         :: (src: *IO_Stream) -> bool                                                     #foreign SDL3_image "IMG_isXV";
is_webp                       :: (src: *IO_Stream) -> bool                                                     #foreign SDL3_image "IMG_isWEBP";
load_avif_io                  :: (src: *IO_Stream) -> *Surface                                                 #foreign SDL3_image "IMG_LoadAVIF_IO";
load_ico_io                   :: (src: *IO_Stream) -> *Surface                                                 #foreign SDL3_image "IMG_LoadICO_IO";
load_cur_io                   :: (src: *IO_Stream) -> *Surface                                                 #foreign SDL3_image "IMG_LoadCUR_IO";
load_bmp_io                   :: (src: *IO_Stream) -> *Surface                                                 #foreign SDL3_image "IMG_LoadBMP_IO";
load_gif_io                   :: (src: *IO_Stream) -> *Surface                                                 #foreign SDL3_image "IMG_LoadGIF_IO";
load_jpg_io                   :: (src: *IO_Stream) -> *Surface                                                 #foreign SDL3_image "IMG_LoadJPG_IO";
load_jxl_io                   :: (src: *IO_Stream) -> *Surface                                                 #foreign SDL3_image "IMG_LoadJXL_IO";
load_lbm_io                   :: (src: *IO_Stream) -> *Surface                                                 #foreign SDL3_image "IMG_LoadLBM_IO";
load_pcx_io                   :: (src: *IO_Stream) -> *Surface                                                 #foreign SDL3_image "IMG_LoadPCX_IO";
load_png_io                   :: (src: *IO_Stream) -> *Surface                                                 #foreign SDL3_image "IMG_LoadPNG_IO";
load_pnm_io                   :: (src: *IO_Stream) -> *Surface                                                 #foreign SDL3_image "IMG_LoadPNM_IO";
load_svg_io                   :: (src: *IO_Stream) -> *Surface                                                 #foreign SDL3_image "IMG_LoadSVG_IO";
load_qoi_io                   :: (src: *IO_Stream) -> *Surface                                                 #foreign SDL3_image "IMG_LoadQOI_IO";
load_tga_io                   :: (src: *IO_Stream) -> *Surface                                                 #foreign SDL3_image "IMG_LoadTGA_IO";
load_tif_io                   :: (src: *IO_Stream) -> *Surface                                                 #foreign SDL3_image "IMG_LoadTIF_IO";
load_xcf_io                   :: (src: *IO_Stream) -> *Surface                                                 #foreign SDL3_image "IMG_LoadXCF_IO";
load_xpm_io                   :: (src: *IO_Stream) -> *Surface                                                 #foreign SDL3_image "IMG_LoadXPM_IO";
load_xv_io                    :: (src: *IO_Stream) -> *Surface                                                 #foreign SDL3_image "IMG_LoadXV_IO";
load_webp_io                  :: (src: *IO_Stream) -> *Surface                                                 #foreign SDL3_image "IMG_LoadWEBP_IO";
load_sized_svg_io             :: (src: *IO_Stream, width: s32, height: s32) -> *Surface                        #foreign SDL3_image "IMG_LoadSizedSVG_IO";
read_xpm_from_array           :: (xpm: **u8) -> *Surface                                                       #foreign SDL3_image "IMG_ReadXPMFromArray";
read_xpm_from_array_to_rgb888 :: (xpm: **u8) -> *Surface                                                       #foreign SDL3_image "IMG_ReadXPMFromArrayToRGB888";
save_avif                     :: (surface: *Surface, file: *u8, quality: s32) -> bool                          #foreign SDL3_image "IMG_SaveAVIF";
save_avif_io                  :: (surface: *Surface, dst: *IO_Stream, close_io: s32, quality: s32) -> bool     #foreign SDL3_image "IMG_SaveAVIF_IO";
save_png                      :: (surface: *Surface, file: *u8) -> bool                                        #foreign SDL3_image "IMG_SavePNG";
save_png_io                   :: (surface: *Surface, dst: *IO_Stream, close_io: s32) -> bool                   #foreign SDL3_image "IMG_SavePNG_IO";
save_jpg                      :: (surface: *Surface, file: *u8, quality: s32) -> bool                          #foreign SDL3_image "IMG_SaveJPG";
save_jpg_io                   :: (surface: *Surface, dst: *IO_Stream, close_io: s32, quality: s32) -> bool     #foreign SDL3_image "IMG_SaveJPG_IO";
load_animation                :: (file: *u8) -> *Animation                                                     #foreign SDL3_image "IMG_LoadAnimation";
load_animation_io             :: (src: *IO_Stream, close_io: bool) -> *Animation                               #foreign SDL3_image "IMG_LoadAnimation_IO";
load_animation_typed_io       :: (src: *IO_Stream, close_io: bool, type: *u8) -> *Animation                    #foreign SDL3_image "IMG_LoadAnimationTyped_IO";
free_animation                :: (anim: *Animation)                                                            #foreign SDL3_image "IMG_FreeAnimation";
load_gif_animation_io         :: (src: *IO_Stream) -> *Animation                                               #foreign SDL3_image "IMG_LoadGIFAnimation_IO";
load_webp_animation_io        :: (src: *IO_Stream) -> *Animation                                               #foreign SDL3_image "IMG_LoadWEBPAnimation_IO";

#scope_module;
#import "SDL3";
