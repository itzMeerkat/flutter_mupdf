#include<iostream>
#include <fstream>
#include "mupdf_wrapper.h"
// #include <mupdf/fitz.h>
#include <string>
using namespace std;

void savePPM(unsigned char* data,int w, int h,int c, string path)
{
    ofstream out(path);
    out<<"P3"<<endl;
    out<<w<<" "<<h<<endl<<"255"<<endl;
    // printf("P3\n");
	// printf("%d %d\n", pix->w, pix->h);
	// printf("255\n");
	for (int y = 0; y < h; ++y)
	{
		unsigned char *p = &data[y * c * w];
		for (int x = 0; x < w; ++x)
		{
			if (x > 0)
				out<<"  ";
            char b[12];
			sprintf(b, "%3d %3d %3d", p[0], p[1], p[2]);
            out<<b;
			p += c;
		}
		// printf("\n");
        out<<endl;
	}
    out.close();
}

int main()
{
    MuPdfInst* inst = newMuPdfInst();
    // inst->scale = 2;
    loadDocument(inst, "../mxnet-learningsys.pdf");
    int a;
    getPageCount(inst, &a);
    cout<<"page cnt "<<a<<endl;
    unsigned char* res;
    int len;
    int w,h,c;
    getPagePixmap(inst, 1, &res, &w,&h,&c);
    len = w*h*c;
    savePPM(res, w,h,c, "./1.ppm");
    clearMuPDF(inst);
}