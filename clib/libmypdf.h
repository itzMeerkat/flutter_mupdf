int LoadDocument(const char* path);
int GetPageCount(int* page_count);
int GetPageText(int page_number, unsigned char** result, int* len);
int GetPagePixmap(int page_number, unsigned char** result, int* w, int* h, int* stride, int* channel);
void ClearMuPDF();
void hello_word(unsigned char** i);