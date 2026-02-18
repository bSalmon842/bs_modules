ALPHA_OPAQUE            :: 255;
ALPHA_OPAQUE_FLOAT      :: 1.0;
ALPHA_TRANSPARENT       :: 0;
ALPHA_TRANSPARENT_FLOAT :: 0.0;

Pixel_Type :: enum u32
{
    UNKNOWN;
    INDEX1;
    INDEX4;
    INDEX8;
    PACKED8;
    PACKED16;
    PACKED32;
    ARRAYU8;
    ARRAYU16;
    ARRAYU32;
    ARRAYF16;
    ARRAYF32;
    INDEX2;
}

Bitmap_Order :: enum u32
{
    ORDER_NONE;
    ORDER_4321;
    ORDER_1234;
}

Packed_Order :: enum u32
{
    NONE;
    XRGB;
    RGBX;
    ARGB;
    RGBA;
    XBGR;
    BGRX;
    ABGR;
    BGRA;
}

Array_Order :: enum u32
{
    NONE;
    RGB;
    RGBA;
    ARGB;
    BGR;
    BGRA;
    ABGR;
}

Packed_Layout :: enum u32
{
    LAYOUT_NONE;
    LAYOUT_332;
    LAYOUT_4444;
    LAYOUT_1555;
    LAYOUT_5551;
    LAYOUT_565;
    LAYOUT_8888;
    LAYOUT_2101010;
    LAYOUT_1010102;
}

DEFINE_PIXELFOURCC     :: (a: u8, b: u8, c: u8, d: u8) -> u32 #expand {return FOURCC(a, b, c, d);}
DEFINE_PIXELFORMAT     :: (type: u32, order: u32, layout: u32, bits: u32, bytes: u32) -> u32 #expand
{
    return ((1 << 28) | (type << 24) | (order << 20) | (layout << 16) | (bits << 8) | (bytes << 0));
}

PIXELFLAG              :: (x: u32) -> u32       #expand {return ((x >> 28) & 0x0F);}
PIXELTYPE              :: (x: u32) -> u32       #expand {return ((x >> 24) & 0x0F);}
PIXELORDER             :: (x: u32) -> u32       #expand {return ((x >> 20) & 0x0F);}
PIXELLAYOUT            :: (x: u32) -> u32       #expand {return ((x >> 16) & 0x0F);}

BITSPERPIXEL           :: (x: u32) -> u32       #expand {return ifx ISPIXELFORMAT_FOURCC(x) then 0 else ((x >> 8) & 0x0F);}
BYTESPERPIXEL          :: (x: u32) -> u32       #expand
{
    return ifx ISPIXELFORMAT_FOURCC(x) then (ifx ((x == xx Pixel_Format.YUY2) || (x == xx Pixel_Format.UYVY) || (x == xx Pixel_Format.YVYU) || (x == xx Pixel_Format.P010)) then 2 else 1) else ((x >> 0) & 0xFF);
}

ISPIXELFORMAT_INDEXED :: (format: u32) -> bool #expand {return !ISPIXELFORMAT_FOURCC(format) &&
                                                       (PIXELTYPE(format) == Pixel_Type.INDEX1) ||
                                                       (PIXELTYPE(format) == Pixel_Type.INDEX2) ||
                                                       (PIXELTYPE(format) == Pixel_Type.INDEX4) ||
                                                       (PIXELTYPE(format) == Pixel_Type.INDEX8);}

ISPIXELFORMAT_PACKED  :: (format: u32) -> bool #expand {return !ISPIXELFORMAT_FOURCC(format) &&
                                                       (PIXELTYPE(format) == Pixel_Type.PACKED8)  ||
                                                       (PIXELTYPE(format) == Pixel_Type.PACKED16) ||
                                                       (PIXELTYPE(format) == Pixel_Type.PACKED32);}

ISPIXELFORMAT_ARRAY   :: (format: u32) -> bool #expand {return !ISPIXELFORMAT_FOURCC(format) &&
                                                       (PIXELTYPE(format) == Pixel_Type.ARRAYU8)  ||
                                                       (PIXELTYPE(format) == Pixel_Type.ARRAYU16) ||
                                                       (PIXELTYPE(format) == Pixel_Type.ARRAYU32) ||
                                                       (PIXELTYPE(format) == Pixel_Type.ARRAYF16) ||
                                                       (PIXELTYPE(format) == Pixel_Type.ARRAYF32);}

ISPIXELFORMAT_ALPHA   :: (format: u32) -> bool #expand {return !ISPIXELFORMAT_FOURCC(format) &&
                                                       (PIXELTYPE(format) == Pixel_Type.ARGB) ||
                                                       (PIXELTYPE(format) == Pixel_Type.RGBA) ||
                                                       (PIXELTYPE(format) == Pixel_Type.ABGR) ||
                                                       (PIXELTYPE(format) == Pixel_Type.BGRA);}

ISPIXELFORMAT_10BIT   :: (format: u32) -> bool #expand {return !ISPIXELFORMAT_FOURCC(format) &&
                                                       (PIXELTYPE(format) == Pixel_Type.PACKED32) &&
                                                       (PIXELLAYOUT(format) == Packed_Layout.LAYOUT_2101010);}

ISPIXELFORMAT_FLOAT   :: (format: u32) -> bool #expand {return !ISPIXELFORMAT_FOURCC(format) &&
                                                       (PIXELTYPE(format) == Pixel_Type.ARRAYF16) ||
                                                       (PIXELTYPE(format) == Pixel_Type.ARRAYF32);}

ISPIXELFORMAT_FOURCC  :: (format: u32) -> bool #expand {return format && PIXELFLAG(format) != 1;}


Pixel_Format :: enum u32
{
    UNKNOWN       :: 0;
    INDEX1LSB     :: 0x11100100;
    INDEX1MSB     :: 0x11200100;
    INDEX2LSB     :: 0x1c100200;
    INDEX2MSB     :: 0x1c200200;
    INDEX4LSB     :: 0x12100400;
    INDEX4MSB     :: 0x12200400;
    INDEX8        :: 0x13000801;
    RGB332        :: 0x14110801;
    XRGB4444      :: 0x15120c02;
    XBGR4444      :: 0x15520c02;
    XRGB1555      :: 0x15130f02;
    XBGR1555      :: 0x15530f02;
    ARGB4444      :: 0x15321002;
    RGBA4444      :: 0x15421002;
    ABGR4444      :: 0x15721002;
    BGRA4444      :: 0x15821002;
    ARGB1555      :: 0x15331002;
    RGBA5551      :: 0x15441002;
    ABGR1555      :: 0x15731002;
    BGRA5551      :: 0x15841002;
    RGB565        :: 0x15151002;
    BGR565        :: 0x15551002;
    RGB24         :: 0x17101803;
    BGR24         :: 0x17401803;
    XRGB8888      :: 0x16161804;
    RGBX8888      :: 0x16261804;
    XBGR8888      :: 0x16561804;
    BGRX8888      :: 0x16661804;
    ARGB8888      :: 0x16362004;
    RGBA8888      :: 0x16462004;
    ABGR8888      :: 0x16762004;
    BGRA8888      :: 0x16862004;
    XRGB2101010   :: 0x16172004;
    XBGR2101010   :: 0x16572004;
    ARGB2101010   :: 0x16372004;
    ABGR2101010   :: 0x16772004;
    RGB48         :: 0x18103006;
    BGR48         :: 0x18403006;
    RGBA64        :: 0x18204008;
    ARGB64        :: 0x18304008;
    BGRA64        :: 0x18504008;
    ABGR64        :: 0x18604008;
    RGB48_FLOAT   :: 0x1a103006;
    BGR48_FLOAT   :: 0x1a403006;
    RGBA64_FLOAT  :: 0x1a204008;
    ARGB64_FLOAT  :: 0x1a304008;
    BGRA64_FLOAT  :: 0x1a504008;
    ABGR64_FLOAT  :: 0x1a604008;
    RGB96_FLOAT   :: 0x1b10600c;
    BGR96_FLOAT   :: 0x1b40600c;
    RGBA128_FLOAT :: 0x1b208010;
    ARGB128_FLOAT :: 0x1b308010;
    BGRA128_FLOAT :: 0x1b508010;
    ABGR128_FLOAT :: 0x1b608010;
    YV12          :: 0x32315659;
    IYUV          :: 0x56555949;
    YUY2          :: 0x32595559;
    UYVY          :: 0x59565955;
    YVYU          :: 0x55595659;
    NV12          :: 0x3231564e;
    NV21          :: 0x3132564e;
    P010          :: 0x30313050;
    EXTERNAL_OES  :: 0x2053454f;

// #if BYTEORDER == BIG_ENDIAN
// {
//     RGBA32 :: RGBA8888;
//     ARGB32 :: ARGB8888;
//     BGRA32 :: BGRA8888;
//     ABGR32 :: ABGR8888;
//     RGBX32 :: RGBX8888;
//     XRGB32 :: XRGB8888;
//     BGRX32 :: BGRX8888;
//     XBGR32 :: XBGR8888;
// }

// #if BYTEORDER != BIG_ENDIAN
// {
    RGBA32        :: 0x16762004;
    ARGB32        :: 0x16862004;
    BGRA32        :: 0x16362004;
    ABGR32        :: 0x16462004;
    RGBX32        :: 0x16561804;
    XRGB32        :: 0x16661804;
    BGRX32        :: 0x16161804;
    XBGR32        :: 0x16261804;
// }
}

Color_Type :: enum u32
{
    UNKNOWN :: 0;
    RGB     :: 1;
    YCBCR   :: 2;
}

Color_Range :: enum u32
{
    UNKNOWN :: 0;
    LIMITED :: 1;
    FULL    :: 2;
}

Color_Primaries :: enum u32
{
    UNKNOWN      :: 0;
    BT709        :: 1;
    UNSPECIFIED  :: 2;
    BT470M       :: 4;
    BT470BG      :: 5;
    BT601        :: 6;
    SMPTE240     :: 7;
    GENERIC_FILM :: 8;
    BT2020       :: 9;
    XYZ          :: 10;
    SMPTE431     :: 11;
    SMPTE432     :: 12;
    EBU3213      :: 22;
    CUSTOM       :: 31;
}

Transfer_Characteristics :: enum u32
{
    UNKNOWN       :: 0;
    BT709         :: 1;
    UNSPECIFIED   :: 2;
    GAMMA22       :: 4;
    GAMMA28       :: 5;
    BT601         :: 6;
    SMPTE240      :: 7;
    LINEAR        :: 8;
    LOG100        :: 9;
    LOG100_SQRT10 :: 10;
    IEC61966      :: 11;
    BT1361        :: 12;
    SRGB          :: 13;
    BT2020_10BIT  :: 14;
    BT2020_12BIT  :: 15;
    PQ            :: 16;
    SMPTE428      :: 17;
    HLG           :: 18;
    CUSTOM        :: 31;
}

Matrix_Coefficients :: enum u32
{
    IDENTITY           :: 0;
    BT709              :: 1;
    UNSPECIFIED        :: 2;
    FCC                :: 4;
    BT470BG            :: 5;
    BT601              :: 6;
    SMPTE240           :: 7;
    YCGCO              :: 8;
    BT2020_NCL         :: 9;
    BT2020_CL          :: 10;
    SMPTE2085          :: 11;
    CHROMA_DERIVED_NCL :: 12;
    CHROMA_DERIVED_CL  :: 13;
    ICTCP              :: 14;
    CUSTOM             :: 31;
}

Chroma_Location :: enum u32
{
    SDL_CHROMA_LOCATION_NONE    :: 0;
    SDL_CHROMA_LOCATION_LEFT    :: 1;
    SDL_CHROMA_LOCATION_CENTER  :: 2;
    SDL_CHROMA_LOCATION_TOPLEFT :: 3;
}

DEFINE_COLORSPACE :: (type: u32, range: u32, primaries: u32, transfer: u32, matrix: u32, chroma: u32) -> u32 #expand
{
    return (type << 28) | (range << 24) | (chroma << 20) | (primaries << 10) | (transfer << 5) | (matrix << 0);
}

COLORSPACETYPE      :: (x: u32) -> Color_Type               #expand {return xx ((x >> 28) & 0x0F);}
COLORSPACERANGE     :: (x: u32) -> Color_Range              #expand {return xx ((x >> 24) & 0x0F);}
COLORSPACECHROMA    :: (x: u32) -> Chroma_Location          #expand {return xx ((x >> 20) & 0x0F);}
COLORSPACEPRIMARIES :: (x: u32) -> Color_Primaries          #expand {return xx ((x >> 10) & 0x1F);}
COLORSPACETRANSFER  :: (x: u32) -> Transfer_Characteristics #expand {return xx ((x >>  5) & 0x1F);}
COLORSPACEMATRIX    :: (x: u32) -> Matrix_Coefficients      #expand {return xx (x & 0x1F);}

ISCOLORSPACE_MATRIX_BT601      :: (x: u32) -> bool #expand {return (COLORSPACEMATRIX(x) == Matrix_Coefficients.BT601) || (COLORSPACEMATRIX(x) == Matrix_Coefficients.BT470BG);}
ISCOLORSPACE_MATRIX_BT709      :: (x: u32) -> bool #expand {return COLORSPACEMATRIX(x) == Matrix_Coefficients.BT709;}
ISCOLORSPACE_MATRIX_BT2020_NCL :: (x: u32) -> bool #expand {return COLORSPACEMATRIX(x) == Matrix_Coefficients.BT2020_NCL;}
ISCOLORSPACE_LIMITED_RANGE     :: (x: u32) -> bool #expand {return COLORSPACEMATRIX(x) != Color_Range.FULL;}
ISCOLORSPACE_FULL_RANGE        :: (x: u32) -> bool #expand {return COLORSPACEMATRIX(x) == Color_Range.FULL;}


Colorspace :: enum u32
{
    UNKNOWN        :: 0;
    SRGB           :: 0x120005a0;
    SRGB_LINEAR    :: 0x12000500;
    HDR10          :: 0x12002600;
    JPEG           :: 0x220004c6;
    BT601_LIMITED  :: 0x211018c6;
    BT601_FULL     :: 0x221018c6;
    BT709_LIMITED  :: 0x21100421;
    BT709_FULL     :: 0x22100421;
    BT2020_LIMITED :: 0x21102609;
    BT2020_FULL    :: 0x22102609;
    RGB_DEFAULT    :: SRGB;
    YUV_DEFAULT    :: JPEG;
}

Color :: struct
{
    r, g, b, a: u8;
}

F_Color :: struct
{
    r, g, b, a: float32;
}

Palette :: struct
{
    ncolors:  s32;
    colors:   Color;
    version:  u32;
    refcount: s32;
}

Pixel_Format_Details :: struct
{
    format:          Pixel_Format;
    bits_per_pixel:  u8;
    bytes_per_pixel: u8;
    padding:         [2] u8;
    Rmask:           u32;
    Gmask:           u32;
    Bmask:           u32;
    Amask:           u32;
    Rbits:           u8;
    Gbits:           u8;
    Bbits:           u8;
    Abits:           u8;
    Rshift:          u8;
    Gshift:          u8;
    Bshift:          u8;
    Ashift:          u8;
}

get_pixel_format_name      :: (format: Pixel_Format) -> *u8                                                                     #foreign SDL3 "SDL_GetPixelFormatName";
get_masks_for_pixel_format :: (format: Pixel_Format, bpp: *s32, r_mask: *u32, g_mask: *u32, b_mask: *u32, a_mask: *u32) -> bool #foreign SDL3 "SDL_GetMasksForPixelFormat";
get_pixel_format_for_masks :: (bpp: s32, r_mask: u32, g_mask: u32, b_mask: u32, a_mask: u32) -> Pixel_Format                    #foreign SDL3 "SDL_GetPixelFormatForMasks";
get_pixel_format_details   :: (format: Pixel_Format) -> *Pixel_Format_Details                                                   #foreign SDL3 "SDL_GetPixelFormatDetails";
create_palette             :: (n_colors: s32) -> *Palette                                                                       #foreign SDL3 "SDL_CreatePalette";
set_palette_colors         :: (palette: *Palette, colors: *Color, first_color: s32, n_colors: s32) -> bool                      #foreign SDL3 "SDL_SetPaletteColors";
destroy_palette            :: (palette: *Palette)                                                                               #foreign SDL3 "SDL_DestroyPalette";
map_rgb                    :: (format: *Pixel_Format_Details, palette: *Palette, r: u8, g: u8, b: u8) -> u32                    #foreign SDL3 "SDL_MapRGB";
map_rgba                   :: (format: *Pixel_Format_Details, palette: *Palette, r: u8, g: u8, b: u8, a: u8) -> u32             #foreign SDL3 "SDL_MapRGBA";
get_rgb                    :: (pixel: u32, format: *Pixel_Format_Details, palette: *Palette, r: *u8, g: *u8, b: *u8)            #foreign SDL3 "SDL_GetRGB";
get_rgba                   :: (pixel: u32, format: *Pixel_Format_Details, palette: *Palette, r: *u8, g: *u8, b: *u8, a: *u8)    #foreign SDL3 "SDL_GetRGBA";
