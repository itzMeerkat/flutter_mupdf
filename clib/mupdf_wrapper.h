typedef struct MuPdfInst MuPdfInst;

MuPdfInst* newMuPdfInst();
int loadDocument(MuPdfInst* inst, const char* path);
int getPageCount(MuPdfInst* inst, int* page_count);
int getPageText(MuPdfInst* inst, int page_number, unsigned char** result, int* len);
int getPagePixmap(MuPdfInst* inst, int page_number, unsigned char** result, int* w, int* h, int* channel);
void clearMuPDF(MuPdfInst* inst);
