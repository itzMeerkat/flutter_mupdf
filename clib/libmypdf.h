typedef struct MuPdfInst MuPdfInst;

MuPdfInst* NewMuPdfInst();
int LoadDocument(MuPdfInst* inst, const char* path);
int GetPageCount(MuPdfInst* inst, int* page_count);
int GetPageText(MuPdfInst* inst, int page_number, unsigned char** result, int* len);
int GetPagePixmap(MuPdfInst* inst, int page_number, unsigned char** result, int* w, int* h, int* channel);
void ClearMuPDF(MuPdfInst* inst);