#include "mupdf_wrapper.h"
#include <mupdf/fitz.h>

struct MuPdfInst {
    fz_document* doc;
    fz_context* ctx;
    fz_buffer* buf;
    fz_pixmap* p;
    float scale = 1;
};

MuPdfInst* newMuPdfInst()
{
    return new MuPdfInst{};
}

void setScale(MuPdfInst* inst, float t_scale)
{
    inst->scale = t_scale;
}

int loadDocument(MuPdfInst* inst, const char* path)
{
    inst->ctx = fz_new_context(NULL, NULL, FZ_STORE_UNLIMITED);
    if (!inst->ctx)
    {
        fprintf(stderr, "cannot create mupdf context\n");
        return EXIT_FAILURE;
    }

    fz_try(inst->ctx)
    {
        fz_register_document_handlers(inst->ctx);
        inst->doc = fz_open_document(inst->ctx, path);
        inst->buf = fz_new_buffer(inst->ctx, 512);
    }
    fz_catch(inst->ctx)
    {
        fprintf(stderr, "cannot open document: %s\n", fz_caught_message(inst->ctx));
        return EXIT_FAILURE;
    }
    return EXIT_SUCCESS;
}

int getPageCount(MuPdfInst* inst, int* page_count)
{
    fz_try(inst->ctx)
    {
        *page_count = fz_count_pages(inst->ctx, inst->doc);
    }
    fz_catch(inst->ctx)
    {
        fprintf(stderr, "cannot count number of pages: %s\n", fz_caught_message(inst->ctx));
        return EXIT_FAILURE;
    }
    return EXIT_SUCCESS;
}

int getPageText(MuPdfInst* inst, int page_number, unsigned char** result, int* len)
{
    fz_stext_options options;
    options.flags = FZ_STEXT_PRESERVE_WHITESPACE;
    fz_stext_page* text;
    fz_output* out;

    fz_clear_buffer(inst->ctx, inst->buf);
    fz_try(inst->ctx)
    {
        text = fz_new_stext_page_from_page_number(inst->ctx, inst->doc, page_number, &options);
        out = fz_new_output_with_buffer(inst->ctx, inst->buf);
        fz_print_stext_page_as_json(inst->ctx, out, text, inst->scale);
    }
    fz_always(inst->ctx)
    {
        fz_close_output(inst->ctx, out);
        fz_drop_stext_page(inst->ctx, text);
    }
    fz_catch(inst->ctx)
    {
        fprintf(stderr, "cannot extract text from page %d. err: %s\n", page_number, fz_caught_message(inst->ctx));
        return EXIT_FAILURE;
    }
    *len = fz_buffer_storage(inst->ctx, inst->buf, result);
    return EXIT_SUCCESS;
}

int getPagePixmap(MuPdfInst* inst, int page_number, unsigned char** result, int* w, int* h, int* channel)
{
    if(inst->p != nullptr)
    {
        fz_drop_pixmap(inst->ctx, inst->p);
    }
    fz_try(inst->ctx)
    {
        inst->p = fz_new_pixmap_from_page_number(inst->ctx, inst->doc, page_number, fz_scale(inst->scale, inst->scale), fz_device_rgb(inst->ctx), 0);
    }
    fz_catch(inst->ctx)
    {
        fprintf(stderr, "cannot render page %d. err: %s\n", page_number, fz_caught_message(inst->ctx));
        return EXIT_FAILURE;
    }
    *result = fz_pixmap_samples(inst->ctx, inst->p);
    *w = inst->p->w;
    *h = inst->p->h;
    *channel = inst->p->n;
    return EXIT_SUCCESS;
}

void clearMuPDF(MuPdfInst* inst)
{
    if(inst->doc != nullptr)
    {
        if(inst->p != nullptr)
        {
            fz_drop_pixmap(inst->ctx, inst->p);
        }
        fz_drop_buffer(inst->ctx, inst->buf);
        fz_drop_document(inst->ctx, inst->doc);
        fz_drop_context(inst->ctx);
    }
    delete inst;
}
