From: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [QUESTION] blkcipher_walk_phys and memory
Date: Tue, 20 Oct 2009 21:03:15 +0200
Message-ID: <20091020190315.GA5159@Chamillionaire.breakpoint.cc>
References: <aa09d86e0910200728g43adb80mb73fc3a694e0453c@mail.gmail.com>
Reply-To: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: ?????? ??????? <ierton@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:39296 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751072AbZJTTDM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 20 Oct 2009 15:03:12 -0400
Content-Disposition: inline
In-Reply-To: <aa09d86e0910200728g43adb80mb73fc3a694e0453c@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* ?????? ??????? | 2009-10-20 18:28:34 [+0400]:

>Dear all, I have a couple of questions about crypto internals, please
>help me to understand some concepts. My drivers implements
>CRYPTO_ALG_TYPE_BLKCIPHER algorithm and has to perform encryption via
>DMA transfers.
In the end you might prefer to use CRYPTO_ALG_TYPE_ABLKCIPHER. The
difference is that you could enqueue multiple transfers on the HW and
receive an interrupt once it is done.

>I decided to use blkcipher_walk_phys() and blkcipher_walk_done()
>functions. These functions take scatterlist and return one or more
>struct page's and offsets. Then i pass those to dma_map_page() which
>returns  dma_addr_t  to send to my device's DMA engine.
>Everything seems to work (on ARM) but i have several questions:
>
>1. Is it generally correct to do this? (see *_encrypt() handler below)
See comment below

>2. Article at http://linux-mm.org/DeviceDriverMmap
>says "You may be tempted to call virt_to_page(addr) to get a struct
>page pointer for a kmalloced address, but this is a violation of the
>abstraction: kmalloc does not return pages, it returns another type of
>memory object."
>And blkcipher_walk_init() internally calls virt_to_page() on a pointer
It does not:
|static inline void blkcipher_walk_init(struct blkcipher_walk *walk,
|                                       struct scatterlist *dst,
|                                       struct scatterlist *src,
|                                       unsigned int nbytes)
|{                       
|        walk->in.sg = src;      
|        walk->out.sg = dst;
|        walk->total = nbytes;
|}      

>allocated from unknown location (for example, in tcrypt.c there is
>statically allocated buffer, but it is just one case of many). Is it
>correct and how to think about it?
virt_to_page() is safe as long as you don't have HIGHMEM support or you
receive memory from vmalloc(). The blkcipher uses scatterwalk_map() for
src/dst which in turn ends up in kmap() what ensures that virt_to_page()
works on that page. In case it was a HIGHMEM page, it will be copied
into kernel address range and on unmap it will be copied back. And here
is some overhead: your HW should be able to access the HIGHMEM page
directly.

>static int mcrypto_3des_ecb_encrypt(struct blkcipher_desc *desc,
>    struct scatterlist *dst, struct scatterlist *src, unsigned int nbytes)
>{
>    struct mcrypto_device *device = &g_mcrypto_device;
>    struct mcrypto_3des_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
>    struct blkcipher_walk walk;
>    int err;
>
>    blkcipher_walk_init(&walk, dst, src, nbytes);
>    err = blkcipher_walk_phys(desc, &walk);
>    ctx->mode = mcrypto_encrypt;
>
>    while((nbytes = walk.nbytes)) {
>        dma_addr_t src_dma, dst_dma;
>        size_t size = nbytes - (nbytes % DES3_EDE_MIN_BLOCK_SIZE);
>
>        src_dma = dma_map_page(device->dev, walk.src.phys.page,
>            walk.src.phys.offset, size, DMA_TO_DEVICE);
>        dst_dma = dma_map_page(device->dev, walk.dst.phys.page,
>            walk.dst.phys.offset, size, DMA_FROM_DEVICE);

It might happen that walk.src.phys.page == walk.dst.phys.page. In that
case you should use DMA_BIDIRECTIONAL

>
>        /* Performs actual DMA transfers and waits for completion */
>        mcrypto_3des_dmacrypt(device, ctx, src_dma, dst_dma, size);
>
>        dma_unmap_page(device->dev, dst_dma, size, DMA_FROM_DEVICE);
>        dma_unmap_page(device->dev, src_dma, size, DMA_TO_DEVICE);
>
>        err = blkcipher_walk_done(desc, &walk, nbytes-size);
>    }
>    return err;
>}

Sebastian
