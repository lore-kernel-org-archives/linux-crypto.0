From: =?KOI8-R?B?88XSx8XKIO3J0s/Oz9c=?= <ierton@gmail.com>
Subject: [QUESTION] blkcipher_walk_phys and memory
Date: Tue, 20 Oct 2009 18:28:34 +0400
Message-ID: <aa09d86e0910200728g43adb80mb73fc3a694e0453c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:51592 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599AbZJTO2a (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 20 Oct 2009 10:28:30 -0400
Received: by fxm18 with SMTP id 18so6487486fxm.37
        for <linux-crypto@vger.kernel.org>; Tue, 20 Oct 2009 07:28:34 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Dear all, I have a couple of questions about crypto internals, please
help me to understand some concepts. My drivers implements
CRYPTO_ALG_TYPE_BLKCIPHER algorithm and has to perform encryption via
DMA transfers.
I decided to use blkcipher_walk_phys() and blkcipher_walk_done()
functions. These functions take scatterlist and return one or more
struct page's and offsets. Then i pass those to dma_map_page() which
returns  dma_addr_t  to send to my device's DMA engine.
Everything seems to work (on ARM) but i have several questions:

1. Is it generally correct to do this? (see *_encrypt() handler below)
2. Article at http://linux-mm.org/DeviceDriverMmap
says "You may be tempted to call virt_to_page(addr) to get a struct
page pointer for a kmalloced address, but this is a violation of the
abstraction: kmalloc does not return pages, it returns another type of
memory object."
And blkcipher_walk_init() internally calls virt_to_page() on a pointer
allocated from unknown location (for example, in tcrypt.c there is
statically allocated buffer, but it is just one case of many). Is it
correct and how to think about it?


static int mcrypto_3des_ecb_encrypt(struct blkcipher_desc *desc,
    struct scatterlist *dst, struct scatterlist *src, unsigned int nbytes)
{
    struct mcrypto_device *device = &g_mcrypto_device;
    struct mcrypto_3des_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
    struct blkcipher_walk walk;
    int err;

    blkcipher_walk_init(&walk, dst, src, nbytes);
    err = blkcipher_walk_phys(desc, &walk);
    ctx->mode = mcrypto_encrypt;

    while((nbytes = walk.nbytes)) {
        dma_addr_t src_dma, dst_dma;
        size_t size = nbytes - (nbytes % DES3_EDE_MIN_BLOCK_SIZE);

        src_dma = dma_map_page(device->dev, walk.src.phys.page,
            walk.src.phys.offset, size, DMA_TO_DEVICE);
        dst_dma = dma_map_page(device->dev, walk.dst.phys.page,
            walk.dst.phys.offset, size, DMA_FROM_DEVICE);

        /* Performs actual DMA transfers and waits for completion */
        mcrypto_3des_dmacrypt(device, ctx, src_dma, dst_dma, size);

        dma_unmap_page(device->dev, dst_dma, size, DMA_FROM_DEVICE);
        dma_unmap_page(device->dev, src_dma, size, DMA_TO_DEVICE);

        err = blkcipher_walk_done(desc, &walk, nbytes-size);
    }
    return err;
}


-- 
Thanks,
Sergey
