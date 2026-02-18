Pen_ID          :: u32;
Pen_Input_Flags :: u32;

Pen_Axis :: enum u32
{
    PRESSURE;
    XTILT;
    YTILT;
    DISTANCE;
    ROTATION;
    SLIDER;
    TANGENTIAL_PRESSURE;
    COUNT;
}
