#include <mupdf/fitz.h>
#include "libmypdf.h"

fz_document* doc;
fz_context* ctx;
fz_buffer* buf;
fz_pixmap* p;


int LoadDocument(const char* path)
{
    ctx = fz_new_context(NULL, NULL, FZ_STORE_UNLIMITED);
    if (!ctx)
    {
        fprintf(stderr, "cannot create mupdf context\n");
        return EXIT_FAILURE;
    }

    fz_try(ctx)
    {
        fz_register_document_handlers(ctx);
        doc = fz_open_document(ctx, path);
        buf = fz_new_buffer(ctx, 512);
    }
    fz_catch(ctx)
    {
        fprintf(stderr, "cannot open document: %s\n", fz_caught_message(ctx));
        return EXIT_FAILURE;
    }
    return EXIT_SUCCESS;
}

int GetPageCount(int& page_count)
{
    fz_try(ctx)
    {
        page_count = fz_count_pages(ctx, doc);
    }
    fz_catch(ctx)
    {
        fprintf(stderr, "cannot count number of pages: %s\n", fz_caught_message(ctx));
        return EXIT_FAILURE;
    }
    return EXIT_SUCCESS;
}

int GetPageText(int page_number, unsigned char* result, int& len)
{
    fz_stext_options options;
    options.flags = FZ_STEXT_PRESERVE_WHITESPACE;
    fz_stext_page* text;
    fz_output* out;

    fz_clear_buffer(ctx, buf);
    fz_try(ctx)
    {
        text = fz_new_stext_page_from_page_number(ctx, doc, page_number, &options);
        out = fz_new_output_with_buffer(ctx, buf);
        fz_print_stext_page_as_json(ctx,out,text,1);
    }
    fz_always(ctx)
    {
        fz_close_output(ctx, out);
        fz_drop_stext_page(ctx,text);
    }
    fz_catch(ctx)
    {
        fprintf(stderr, "cannot extract text from page %d. err: %s\n", page_number, fz_caught_message(ctx));
        return EXIT_FAILURE;
    }
    len = fz_buffer_storage(ctx, buf, &result);
    return EXIT_SUCCESS;
}

int GetPagePixmap(int page_number, unsigned char* result, int& size, int& channel)
{
    if(p != nullptr)
    {
        fz_drop_pixmap(ctx, p);
    }
    fz_try(ctx)
    {
        p = fz_new_pixmap_from_page_number(ctx, doc, page_number, fz_identity, fz_device_rgb(ctx), 0);
    }
    fz_catch(ctx)
    {
        fprintf(stderr, "cannot render page %d. err: %s\n", page_number, fz_caught_message(ctx));
        return EXIT_FAILURE;
    }
    result = fz_pixmap_samples(ctx, p);
    size = p->w * p->h * p->stride;
    channel = p->n;
}

void ClearMuPDF()
{
    if(doc != nullptr)
    {
        if(p != nullptr)
        {
            fz_drop_pixmap(ctx, p);
        }
        fz_drop_buffer(ctx, buf);
        fz_drop_document(ctx, doc);
        fz_drop_context(ctx);
    }
}

void hello_world(char** i)
{
    (*i) = "hi mupdf";
}