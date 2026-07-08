DialogFileFilter :: struct {
    name    : *u8;
    pattern : *u8;
}

DialogFileCallback :: #type (userData : *void, fileList : *u8, filter : s32);

FileDialogType :: enum {
    OPENFILE;
    SAVEFILE;
    OPENFOLDER;
}

