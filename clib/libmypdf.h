int LoadDocument(const char* path);
int GetPageCount(int& page_count);
int GetPageText(int page_number, unsigned char* result, int& len);
int GetPagePixmap(int page_number, unsigned char* result, int& size, int& channel);
void ClearMuPDF();
void hello_word(char** i);