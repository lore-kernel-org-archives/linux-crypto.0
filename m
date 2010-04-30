From: Lee Nipper <lee.nipper@gmail.com>
Subject: Re: [PATCH 3/3] crypto: talitos - add hash algorithms
Date: Fri, 30 Apr 2010 07:17:48 -0500
Message-ID: <4BDACA6C.3020700@gmail.com>
References: <4bd82b34.0e0bca0a.475e.ffffa572@mx.google.com> <20100429220751.224037c0.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:32834 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933565Ab0D3R7F (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 30 Apr 2010 13:59:05 -0400
Received: by gwj19 with SMTP id 19so219471gwj.19
        for <linux-crypto@vger.kernel.org>; Fri, 30 Apr 2010 10:59:02 -0700 (PDT)
In-Reply-To: <20100429220751.224037c0.kim.phillips@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Kim Phillips wrote:
 > On Wed, 28 Apr 2010 05:33:56 -0700
 > <lee.nipper@gmail.com> wrote:
 >
 >> Add the following alorithms to talitos:
 >>     md5,
 >>     sha1,
 >>     sha256,
 >>     sha384,
 >>     sha512.
 >> These are all type ahash.
 >
 > sha224 is left as an exercise for the reader, I see ;)

Well, here's the story.
The errata 'SEC5' says sha224 is broken on 8349E Rev 1.1;
I considered adding it, but saw the errata and thought "naaah".
Figured it wasn't that commonly used anyway.

 >
 >> It has been tested successfully on MPC8349E.
 >
 > curious, is that an 8349E/sec2.1 or 8349EA/sec2.4?
 >

8349E silicon Rev 1.1 => sec2.1.

 >> It needs a load on a board with SEC 3.x (hint hint).
 >
 > loaded on an fsl,sec3.0 (8572) - all selftests passed.
 >

Thank you.

 >> +const struct talitos_ptr zero_entry = {
 >
 >   CHECK   drivers/crypto/talitos.c
 > drivers/crypto/talitos.c:71:26: warning: symbol 'zero_entry' was not 
declared. Should it be static?
 >

oops, will certainly make it static.

 >> -    edesc->dma_link_tbl = dma_map_single(dev, &edesc->link_tbl[0],
 >> +    if (dma_len)
 >> +        edesc->dma_link_tbl = dma_map_single(dev, &edesc->link_tbl[0],
 >>                           edesc->dma_len, DMA_BIDIRECTIONAL);
 >
 > broken indentation.

ok.

 >
 >> +    /* HMAC key */
 >> +    if (ctx->keylen)
 >> +        map_single_talitos_ptr(dev, &desc->ptr[2], ctx->keylen,
 >> +                       (char *)&ctx->key, 0, DMA_TO_DEVICE);
 >> +    else {
 >> +        desc->ptr[2] = zero_entry;
 >> +    }
 >
 > unnecessary braces.
 >

ok.

 >> +    if (!req_ctx->last && (index + nbytes) < blocksize) {
 >> +        /* Buffer the partial block */
 >> +        sg_copy_to_buffer(areq->src,
 >> +                  sg_count(areq->src, nbytes, &chained),
 >> +                  req_ctx->buf + index, nbytes);
 >> +    } else {
 >> +        if (index) {
 >> +            /* partial block from previous update; chain it in. */
 >> +            sg_init_table(req_ctx->bufsl, (nbytes) ? 2 : 1);
 >> +            sg_set_buf(req_ctx->bufsl, req_ctx->buf, index);
 >> +            if (nbytes)
 >> +                scatterwalk_sg_chain(req_ctx->bufsl, 2,
 >> +                             areq->src);
 >> +            req_ctx->psrc = req_ctx->bufsl;
 >> +        } else {
 >> +            req_ctx->psrc = areq->src;
 >> +        }
 >> +        nbytes_to_hash =  index + nbytes;
 >> +        if (!req_ctx->last) {
 >> +            to_hash_later = (nbytes_to_hash & (blocksize - 1));
 >> +            if (to_hash_later) {
 >> +                int nents;
 >> +                /* Must copy to_hash_later bytes from the end
 >> +                 * to bufnext (a partial block) for later.
 >> +                 */
 >> +                nents = sg_count(areq->src, nbytes, &chained);
 >> +                sg_copy_end_to_buffer(areq->src, nents,
 >> +                              req_ctx->bufnext,
 >> +                              to_hash_later,
 >> +                              nbytes - to_hash_later);
 >> +
 >> +                /* Adjust count for what will be hashed now */
 >> +                nbytes_to_hash -= to_hash_later;
 >> +            }
 >> +            req_ctx->to_hash_later = to_hash_later;
 >> +        }
 >> +
 >> +        /* allocate extended descriptor */
 >> +        edesc = ahash_edesc_alloc(areq, nbytes_to_hash);
 >> +        if (IS_ERR(edesc))
 >> +            return PTR_ERR(edesc);
 >> +
 >> +        edesc->desc.hdr = ctx->desc_hdr_template;
 >> +
 >> +        /* On last one, request SEC to pad; otherwise continue */
 >> +        if (req_ctx->last)
 >> +            edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_PAD;
 >> +        else
 >> +            edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_CONT;
 >> +
 >> +        /* On first one, request SEC to INIT hash. */
 >> +        if (req_ctx->first)
 >> +            edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_INIT;
 >> +
 >
 >> +        /* When the tfm context has a keylen, it's an HMAC. */
 >> +        if (ctx->keylen) {
 >> +            /* All but middle descriptors request HMAC. */
 >> +            if (req_ctx->first || req_ctx->last)
 >> +                edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_HMAC;
 >> +        }
 >
 > if (ctx->keylen && (req_ctx->first || req_ctx->last))
 >     hdr |= ...
 >

ok.

 >> +
 >> +        return common_nonsnoop_hash(edesc, areq, nbytes_to_hash,
 >> +                        ahash_done);
 >> +    }
 >> +    return 0;
 >
 > instead of
 > if (cond) {
 >     do a;
 > } else {
 >     do b;
 >     return x;
 > }
 > return 0;
 >
 > can we do:
 >
 > if (cond) {
 >     do a;
 >     return 0;
 > }
 > do b;
 > return x;
 >

ah, one less indent level for most of it.
good, will do.

 >> -    struct talitos_crypto_alg *talitos_alg;
 >> +    struct talitos_crypto_alg *talitos_alg =
 >> +                    crypto_alg_to_talitos_crypto_alg(alg);
 >>      struct talitos_ctx *ctx = crypto_tfm_ctx(tfm);
 >>
 >> -    talitos_alg =  container_of(alg, struct talitos_crypto_alg,
 >> -                    algt.alg.crypto);
 >> -
 >
 > this undoes what "[PATCH 2/3] crypto: talitos - second prepare step for
 > adding ahash algorithms" did better IMO.
 >

will simplify assignments, more like [PATCH 2/3].

 > Thanks!
 >

You are welcome.
And thank you for the speedy review.

[PATCHv2 3/3] is forthcoming.

Lee

