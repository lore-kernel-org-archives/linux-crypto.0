Return-Path: <SRS0=tkOt=CC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A3E4C433E1
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Aug 2020 09:47:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05874206BE
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Aug 2020 09:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598262472;
	bh=GMH2z5R3BgTYglX+yTCjfHMGApHlUMGoW4CHzjNj3aw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=ZSPOD6vBqVKWLWTUistwvCHRPtcBU8URnfhEKDhhfpcCmF4qyt0VTubzbome7WW1c
	 9r5Yr8QwpFKbSb+4HLVsJch+//Z8xZTzndFwX5LYcGeJTCu8agGY/ucb9e4l5VeI/5
	 DmUY9L23kMEbZLS4uzC1KTYHAdlJ7sLVR/rHHNwQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728752AbgHXJru (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Aug 2020 05:47:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:38738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729002AbgHXJrq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Aug 2020 05:47:46 -0400
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3FC8206BE
        for <linux-crypto@vger.kernel.org>; Mon, 24 Aug 2020 09:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598262465;
        bh=GMH2z5R3BgTYglX+yTCjfHMGApHlUMGoW4CHzjNj3aw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=rnlHRPYMTafKaJtoFOLG70x9bll+dIABaQk/XM+u4DY5jLy7kY56eG4YeXEwl1I1R
         nxbuTqvf2QGzun0xwEe3Yl2yka5s70utI7koEXe42wlCj81rhXklFitDX/W9OkgLFa
         sXqPS+6yGWw1Rj98QKDIThZztXm0BB12G4a2fgKQ=
Received: by mail-ot1-f51.google.com with SMTP id k2so195846ots.4
        for <linux-crypto@vger.kernel.org>; Mon, 24 Aug 2020 02:47:44 -0700 (PDT)
X-Gm-Message-State: AOAM530fbrEESJGapy1p0w1Z06AsAjAUePiRS5XHnDSP2chympHMEm4m
        BH6dhaWyFubKx4sL/vZ+erapiYnNIFOXx2vFvvk=
X-Google-Smtp-Source: ABdhPJyfA9np+7UP/aGuEm+2qrfelQrJnyZ0bd5oT1FHUYXd7s+O+cF2RsQSHPAb5JxqyVU6wltQzk6lW4nK+HPScGQ=
X-Received: by 2002:a9d:6251:: with SMTP id i17mr2861464otk.90.1598262463904;
 Mon, 24 Aug 2020 02:47:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200818082410.GA24497@gondor.apana.org.au> <E1k7ww8-0000fp-U0@fornost.hmeau.com>
In-Reply-To: <E1k7ww8-0000fp-U0@fornost.hmeau.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 24 Aug 2020 11:47:30 +0200
X-Gmail-Original-Message-ID: <CAMj1kXH6FTYDvzpwmga5K_2SRDBCyfPOmJJd3JN2vUjZLzTL7w@mail.gmail.com>
Message-ID: <CAMj1kXH6FTYDvzpwmga5K_2SRDBCyfPOmJJd3JN2vUjZLzTL7w@mail.gmail.com>
Subject: Re: [PATCH 6/6] crypto: cmac - Use cbc skcipher instead of raw cipher
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Ben Greear <greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 18 Aug 2020 at 10:25, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> Many architectures provide an accelerated implementation of cbc(aes)
> skcipher that is far superior to using the standard cbc template
> over an accelerated aes cipher.  As cmac uses the raw cipher, it
> was not able to benefit from the accelerated cbc(aes) skcpipher.
>
> This patch changes cmac to use an underlying cbc skcipher.  In order
> to do so safely, cmac has been split into an ahash version as well
> as an shash version.  If the underlying cbc(aes) skcipher is async,
> then only the ahash version would provide the full acceleration.
>
> Here are the numbers on x86:
>
> 1. Old cmac:
> testing speed of async cmac(aes) (cmac(aes-aesni))
> tcrypt: test  0 (   16 byte blocks,   16 bytes per update,   1 updates):    753 cycles/operation,   47 cycles/byte
> tcrypt: test  1 (   64 byte blocks,   16 bytes per update,   4 updates):   2305 cycles/operation,   36 cycles/byte
> tcrypt: test  2 (   64 byte blocks,   64 bytes per update,   1 updates):   1398 cycles/operation,   21 cycles/byte
> tcrypt: test  3 (  256 byte blocks,   16 bytes per update,  16 updates):  10996 cycles/operation,   42 cycles/byte
> tcrypt: test  4 (  256 byte blocks,   64 bytes per update,   4 updates):   4808 cycles/operation,   18 cycles/byte
> tcrypt: test  5 (  256 byte blocks,  256 bytes per update,   1 updates):   3819 cycles/operation,   14 cycles/byte
> tcrypt: test  6 ( 1024 byte blocks,   16 bytes per update,  64 updates):  30528 cycles/operation,   29 cycles/byte
> tcrypt: test  7 ( 1024 byte blocks,  256 bytes per update,   4 updates):  14471 cycles/operation,   14 cycles/byte
> tcrypt: test  8 ( 1024 byte blocks, 1024 bytes per update,   1 updates):  13469 cycles/operation,   13 cycles/byte
> tcrypt: test  9 ( 2048 byte blocks,   16 bytes per update, 128 updates):  62646 cycles/operation,   30 cycles/byte
> tcrypt: test 10 ( 2048 byte blocks,  256 bytes per update,   8 updates):  28492 cycles/operation,   13 cycles/byte
> tcrypt: test 11 ( 2048 byte blocks, 1024 bytes per update,   2 updates):  25935 cycles/operation,   12 cycles/byte
> tcrypt: test 12 ( 2048 byte blocks, 2048 bytes per update,   1 updates):  25545 cycles/operation,   12 cycles/byte
> tcrypt: test 13 ( 4096 byte blocks,   16 bytes per update, 256 updates): 126308 cycles/operation,   30 cycles/byte
> tcrypt: test 14 ( 4096 byte blocks,  256 bytes per update,  16 updates):  56565 cycles/operation,   13 cycles/byte
> tcrypt: test 15 ( 4096 byte blocks, 1024 bytes per update,   4 updates):  64675 cycles/operation,   15 cycles/byte
> tcrypt: test 16 ( 4096 byte blocks, 4096 bytes per update,   1 updates):  59264 cycles/operation,   14 cycles/byte
> tcrypt: test 17 ( 8192 byte blocks,   16 bytes per update, 512 updates): 244882 cycles/operation,   29 cycles/byte
> tcrypt: test 18 ( 8192 byte blocks,  256 bytes per update,  32 updates): 117842 cycles/operation,   14 cycles/byte
> tcrypt: test 19 ( 8192 byte blocks, 1024 bytes per update,   8 updates): 106637 cycles/operation,   13 cycles/byte
> tcrypt: test 20 ( 8192 byte blocks, 4096 bytes per update,   2 updates): 103895 cycles/operation,   12 cycles/byte
> tcrypt: test 21 ( 8192 byte blocks, 8192 bytes per update,   1 updates): 103742 cycles/operation,   12 cycles/byte
>
> 2. New shash cmac:
> testing speed of async cmac(cbc(aes-aesni)) (cmac(cbc(aes-aesni)))
> tcrypt: test  0 (   16 byte blocks,   16 bytes per update,   1 updates):    959 cycles/operation,   59 cycles/byte
> tcrypt: test  1 (   64 byte blocks,   16 bytes per update,   4 updates):   2375 cycles/operation,   37 cycles/byte
> tcrypt: test  2 (   64 byte blocks,   64 bytes per update,   1 updates):   3528 cycles/operation,   55 cycles/byte
> tcrypt: test  3 (  256 byte blocks,   16 bytes per update,  16 updates):   6904 cycles/operation,   26 cycles/byte
> tcrypt: test  4 (  256 byte blocks,   64 bytes per update,   4 updates):   8130 cycles/operation,   31 cycles/byte
> tcrypt: test  5 (  256 byte blocks,  256 bytes per update,   1 updates):   8873 cycles/operation,   34 cycles/byte
> tcrypt: test  6 ( 1024 byte blocks,   16 bytes per update,  64 updates):  25937 cycles/operation,   25 cycles/byte
> tcrypt: test  7 ( 1024 byte blocks,  256 bytes per update,   4 updates):  16445 cycles/operation,   16 cycles/byte
> tcrypt: test  8 ( 1024 byte blocks, 1024 bytes per update,   1 updates):  19753 cycles/operation,   19 cycles/byte
> tcrypt: test  9 ( 2048 byte blocks,   16 bytes per update, 128 updates):  52589 cycles/operation,   25 cycles/byte
> tcrypt: test 10 ( 2048 byte blocks,  256 bytes per update,   8 updates):  40020 cycles/operation,   19 cycles/byte
> tcrypt: test 11 ( 2048 byte blocks, 1024 bytes per update,   2 updates):  40315 cycles/operation,   19 cycles/byte
> tcrypt: test 12 ( 2048 byte blocks, 2048 bytes per update,   1 updates):  31988 cycles/operation,   15 cycles/byte
> tcrypt: test 13 ( 4096 byte blocks,   16 bytes per update, 256 updates): 123648 cycles/operation,   30 cycles/byte
> tcrypt: test 14 ( 4096 byte blocks,  256 bytes per update,  16 updates):  65420 cycles/operation,   15 cycles/byte
> tcrypt: test 15 ( 4096 byte blocks, 1024 bytes per update,   4 updates):  65512 cycles/operation,   15 cycles/byte
> tcrypt: test 16 ( 4096 byte blocks, 4096 bytes per update,   1 updates):  62763 cycles/operation,   15 cycles/byte
> tcrypt: test 17 ( 8192 byte blocks,   16 bytes per update, 512 updates): 242429 cycles/operation,   29 cycles/byte
> tcrypt: test 18 ( 8192 byte blocks,  256 bytes per update,  32 updates): 126182 cycles/operation,   15 cycles/byte
> tcrypt: test 19 ( 8192 byte blocks, 1024 bytes per update,   8 updates): 130364 cycles/operation,   15 cycles/byte
> tcrypt: test 20 ( 8192 byte blocks, 4096 bytes per update,   2 updates): 121450 cycles/operation,   14 cycles/byte
> tcrypt: test 21 ( 8192 byte blocks, 8192 bytes per update,   1 updates): 124334 cycles/operation,   15 cycles/byte
>
> 3. New ahash cmac:
> testing speed of async cmac(aes) (cmac(cbc-aes-aesni))
> tcrypt: test  0 (   16 byte blocks,   16 bytes per update,   1 updates):   1026 cycles/operation,   64 cycles/byte
> tcrypt: test  1 (   64 byte blocks,   16 bytes per update,   4 updates):   2080 cycles/operation,   32 cycles/byte
> tcrypt: test  2 (   64 byte blocks,   64 bytes per update,   1 updates):   1250 cycles/operation,   19 cycles/byte
> tcrypt: test  3 (  256 byte blocks,   16 bytes per update,  16 updates):   5348 cycles/operation,   20 cycles/byte
> tcrypt: test  4 (  256 byte blocks,   64 bytes per update,   4 updates):   2998 cycles/operation,   11 cycles/byte
> tcrypt: test  5 (  256 byte blocks,  256 bytes per update,   1 updates):   2233 cycles/operation,    8 cycles/byte
> tcrypt: test  6 ( 1024 byte blocks,   16 bytes per update,  64 updates):  18879 cycles/operation,   18 cycles/byte
> tcrypt: test  7 ( 1024 byte blocks,  256 bytes per update,   4 updates):   7964 cycles/operation,    7 cycles/byte
> tcrypt: test  8 ( 1024 byte blocks, 1024 bytes per update,   1 updates):   6826 cycles/operation,    6 cycles/byte
> tcrypt: test  9 ( 2048 byte blocks,   16 bytes per update, 128 updates):  51125 cycles/operation,   24 cycles/byte
> tcrypt: test 10 ( 2048 byte blocks,  256 bytes per update,   8 updates):  14921 cycles/operation,    7 cycles/byte
> tcrypt: test 11 ( 2048 byte blocks, 1024 bytes per update,   2 updates):  13174 cycles/operation,    6 cycles/byte
> tcrypt: test 12 ( 2048 byte blocks, 2048 bytes per update,   1 updates):  11911 cycles/operation,    5 cycles/byte
> tcrypt: test 13 ( 4096 byte blocks,   16 bytes per update, 256 updates):  74883 cycles/operation,   18 cycles/byte
> tcrypt: test 14 ( 4096 byte blocks,  256 bytes per update,  16 updates):  34169 cycles/operation,    8 cycles/byte
> tcrypt: test 15 ( 4096 byte blocks, 1024 bytes per update,   4 updates):  24703 cycles/operation,    6 cycles/byte
> tcrypt: test 16 ( 4096 byte blocks, 4096 bytes per update,   1 updates):  22081 cycles/operation,    5 cycles/byte
> tcrypt: test 17 ( 8192 byte blocks,   16 bytes per update, 512 updates): 157086 cycles/operation,   19 cycles/byte
> tcrypt: test 18 ( 8192 byte blocks,  256 bytes per update,  32 updates):  56920 cycles/operation,    6 cycles/byte
> tcrypt: test 19 ( 8192 byte blocks, 1024 bytes per update,   8 updates):  50063 cycles/operation,    6 cycles/byte
> tcrypt: test 20 ( 8192 byte blocks, 4096 bytes per update,   2 updates):  43677 cycles/operation,    5 cycles/byte
> tcrypt: test 21 ( 8192 byte blocks, 8192 bytes per update,   1 updates):  42464 cycles/operation,    5 cycles/byte
>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>


OK, so you are using a page size buffer for every request in flight,
and using that as a scratch buffer for the destination of the cbc()
transform?

I am not a fan of this approach, tbh. High latency/high bandwidth
users will cause lots of GFP_ATOMIC allocations, and synchronous CPU
implementations will cause lots of writes polluting the D-cache for no
good reason. Non-cache coherent accelerators will cause unnecessary
traffic on the memory bus in addition to the undesirable D-cache
behavior.

What we could do instead is having a certain flag/behavior in skcipher
where writes are omitted entirely, and cbcmac/cmac could opt into
that. But imho, the best way to improve this is to have a new AES-NI
asm helper (which I already implemented in my v2) that wraps the
AES-NI primitives in the right way to implement cbcmac.



>
>  crypto/cmac.c |  864 ++++++++++++++++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 745 insertions(+), 119 deletions(-)
>
> diff --git a/crypto/cmac.c b/crypto/cmac.c
> index df36be1efb817..78cbc16818b66 100644
> --- a/crypto/cmac.c
> +++ b/crypto/cmac.c
> @@ -12,9 +12,13 @@
>   */
>
>  #include <crypto/internal/hash.h>
> +#include <crypto/internal/skcipher.h>
> +#include <crypto/scatterwalk.h>
>  #include <linux/err.h>
>  #include <linux/kernel.h>
>  #include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/string.h>
>
>  /*
>   * +------------------------
> @@ -26,8 +30,13 @@
>   * +------------------------
>   */
>  struct cmac_tfm_ctx {
> -       struct crypto_cipher *child;
> -       u8 ctx[];
> +       struct crypto_sync_skcipher *child;
> +       __be64 consts[];
> +};
> +
> +struct cmac_atfm_ctx {
> +       struct crypto_skcipher *child;
> +       __be64 consts[];
>  };
>
>  /*
> @@ -36,9 +45,9 @@ struct cmac_tfm_ctx {
>   * +------------------------
>   * | cmac_desc_ctx
>   * +------------------------
> - * | odds (block size)
> + * | prev (block size, alignmask aligned)
>   * +------------------------
> - * | prev (block size)
> + * | odds (alignmask aligned)
>   * +------------------------
>   */
>  struct cmac_desc_ctx {
> @@ -46,25 +55,93 @@ struct cmac_desc_ctx {
>         u8 ctx[];
>  };
>
> -static int crypto_cmac_digest_setkey(struct crypto_shash *parent,
> -                                    const u8 *inkey, unsigned int keylen)
> +/*
> + * +------------------------
> + * | <ahash request>
> + * +------------------------
> + * | cmac_req_ctx
> + * +------------------------
> + * | skcipher_request_ctx
> + * +------------------------
> + * | prev (block size, alignmask aligned)
> + * +------------------------
> + * | odds (alignmask aligned)
> + * +------------------------
> + */
> +struct cmac_req_ctx {
> +       struct page *page;
> +       struct scatterlist src[2];
> +       bool more;
> +       bool final;
> +       struct scatterlist dst[3];
> +       unsigned int len;
> +       struct skcipher_request req;
> +};
> +
> +struct cmac_inst_ctx {
> +       struct crypto_sync_skcipher_spawn spawn;
> +       char name[CRYPTO_MAX_ALG_NAME];
> +};
> +
> +struct cmac_ainst_ctx {
> +       struct crypto_skcipher_spawn spawn;
> +       char name[CRYPTO_MAX_ALG_NAME];
> +};
> +
> +static inline void *cmac_ctx_consts(struct crypto_shash *parent)
>  {
>         unsigned long alignmask = crypto_shash_alignmask(parent);
>         struct cmac_tfm_ctx *ctx = crypto_shash_ctx(parent);
> -       unsigned int bs = crypto_shash_blocksize(parent);
> -       __be64 *consts = PTR_ALIGN((void *)ctx->ctx,
> -                                  (alignmask | (__alignof__(__be64) - 1)) + 1);
> -       u64 _const[2];
> -       int i, err = 0;
> -       u8 msb_mask, gfmask;
>
> -       err = crypto_cipher_setkey(ctx->child, inkey, keylen);
> -       if (err)
> -               return err;
> +       alignmask |= __alignof__(__be64) - 1;
> +
> +       return PTR_ALIGN(&ctx->consts[0], alignmask + 1);
> +}
> +
> +static inline void *cmac_async_consts(struct crypto_ahash *parent)
> +{
> +       unsigned long alignmask = crypto_ahash_alignmask(parent);
> +       struct cmac_atfm_ctx *ctx = crypto_ahash_ctx(parent);
> +
> +       alignmask |= __alignof__(__be64) - 1;
> +
> +       return PTR_ALIGN(&ctx->consts[0], alignmask + 1);
> +}
> +
> +static inline unsigned int cmac_ctx_size(unsigned int base,
> +                                        unsigned int alignmask,
> +                                        unsigned int bs)
> +{
> +       const unsigned int minalign = crypto_tfm_ctx_alignment();
> +
> +       return ALIGN(base, minalign) +
> +              ((alignmask | (__alignof__(__be64) - 1)) & ~(minalign - 1)) +
> +              bs * 2;
> +}
> +
> +static int cmac_compute_consts(__be64 *consts, unsigned int bs, u32 flags,
> +                              struct skcipher_request *req)
> +{
> +       u64 _const[2] __attribute__((aligned(16)));
> +       DECLARE_CRYPTO_WAIT(wait);
> +       struct scatterlist sg;
> +       u8 msb_mask, gfmask;
> +       int i, err;
>
>         /* encrypt the zero block */
> +       memset(_const, 0, bs);
>         memset(consts, 0, bs);
> -       crypto_cipher_encrypt_one(ctx->child, (u8 *)consts, (u8 *)consts);
> +       sg_init_one(&sg, consts, bs);
> +
> +       flags &= CRYPTO_TFM_REQ_MAY_SLEEP;
> +       flags |= CRYPTO_TFM_REQ_MAY_BACKLOG;
> +
> +       skcipher_request_set_callback(req, flags, crypto_req_done, &wait);
> +       skcipher_request_set_crypt(req, &sg, &sg, bs, _const);
> +
> +       err = crypto_skcipher_encrypt(req);
> +       if (err)
> +               return err;
>
>         switch (bs) {
>         case 16:
> @@ -101,129 +178,245 @@ static int crypto_cmac_digest_setkey(struct crypto_shash *parent,
>         return 0;
>  }
>
> -static int crypto_cmac_digest_init(struct shash_desc *pdesc)
> +static int crypto_cmac_digest_setkey(struct crypto_shash *parent,
> +                                    const u8 *inkey, unsigned int keylen)
>  {
> -       unsigned long alignmask = crypto_shash_alignmask(pdesc->tfm);
> -       struct cmac_desc_ctx *ctx = shash_desc_ctx(pdesc);
> -       int bs = crypto_shash_blocksize(pdesc->tfm);
> -       u8 *prev = PTR_ALIGN((void *)ctx->ctx, alignmask + 1) + bs;
> +       struct cmac_tfm_ctx *ctx = crypto_shash_ctx(parent);
> +       unsigned int bs = crypto_shash_blocksize(parent);
> +       struct crypto_sync_skcipher *child = ctx->child;
> +       SYNC_SKCIPHER_REQUEST_ON_STACK(req, child);
> +       __be64 *consts = cmac_ctx_consts(parent);
> +       u32 flags;
> +       int err;
>
> -       ctx->len = 0;
> -       memset(prev, 0, bs);
> +       crypto_sync_skcipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
> +       flags = crypto_shash_get_flags(parent) & CRYPTO_TFM_REQ_MASK;
> +       crypto_sync_skcipher_set_flags(child, flags);
> +
> +       err = crypto_sync_skcipher_setkey(child, inkey, keylen);
> +       if (err)
> +               return err;
> +
> +       skcipher_request_set_sync_tfm(req, child);
> +
> +       return cmac_compute_consts(consts, bs, flags, req);
> +}
>
> +static int crypto_cmac_digest_init(struct shash_desc *pdesc)
> +{
> +       memset(shash_desc_ctx(pdesc), 0, HASH_MAX_DESCSIZE);
>         return 0;
>  }
>
> -static int crypto_cmac_digest_update(struct shash_desc *pdesc, const u8 *p,
> -                                    unsigned int len)
> +static unsigned int fill_final_block(char *odds, unsigned int len,
> +                                    unsigned int bs)
> +{
> +       u8 *p = odds + len;
> +       unsigned int rlen;
> +
> +       *p = 0x80;
> +       p++;
> +
> +       rlen = -(len + 1) & (bs - 1);
> +       memset(p, 0, rlen);
> +
> +       return len + rlen + 1;
> +}
> +
> +static int crypto_cmac_digest_finup(struct shash_desc *pdesc, const u8 *p,
> +                                   unsigned int len, u8 *out)
>  {
>         struct crypto_shash *parent = pdesc->tfm;
>         unsigned long alignmask = crypto_shash_alignmask(parent);
>         struct cmac_tfm_ctx *tctx = crypto_shash_ctx(parent);
>         struct cmac_desc_ctx *ctx = shash_desc_ctx(pdesc);
> -       struct crypto_cipher *tfm = tctx->child;
> +       u8 *prev = PTR_ALIGN(&ctx->ctx[0], alignmask + 1);
> +       struct crypto_sync_skcipher *tfm = tctx->child;
> +       SYNC_SKCIPHER_REQUEST_ON_STACK(req, tfm);
>         int bs = crypto_shash_blocksize(parent);
> -       u8 *odds = PTR_ALIGN((void *)ctx->ctx, alignmask + 1);
> -       u8 *prev = odds + bs;
> +       u8 *consts = cmac_ctx_consts(parent);
> +       unsigned int clen = ctx->len;
> +       bool empty = !(clen + len);
> +       struct scatterlist sg;
> +       u8 *odds = prev + bs;
> +       unsigned int cs, ds;
> +       void *page = NULL;
> +       u8 *buf;
> +       int err;
>
> -       /* checking the data can fill the block */
> -       if ((ctx->len + len) <= bs) {
> -               memcpy(odds + ctx->len, p, len);
> +       odds = PTR_ALIGN(odds, alignmask + 1);
> +       cs = HASH_MAX_DESCSIZE - (odds - (u8 *)pdesc);
> +       cs &= ~(bs - 1);
> +       BUILD_BUG_ON(4 + 60 + 16 + 48 + 16 > HASH_MAX_DESCSIZE);
> +
> +       /* checking the data can fill the blocks */
> +       if ((clen + len) <= cs && !out) {
> +               memcpy(odds + clen, p, len);
>                 ctx->len += len;
>                 return 0;
>         }
>
> -       /* filling odds with new data and encrypting it */
> -       memcpy(odds + ctx->len, p, bs - ctx->len);
> -       len -= bs - ctx->len;
> -       p += bs - ctx->len;
> -
> -       crypto_xor(prev, odds, bs);
> -       crypto_cipher_encrypt_one(tfm, prev, prev);
> -
>         /* clearing the length */
>         ctx->len = 0;
>
> -       /* encrypting the rest of data */
> -       while (len > bs) {
> -               crypto_xor(prev, p, bs);
> -               crypto_cipher_encrypt_one(tfm, prev, prev);
> -               p += bs;
> -               len -= bs;
> -       }
> +       buf = odds;
> +       ds = cs;
>
> -       /* keeping the surplus of blocksize */
> -       if (len) {
> -               memcpy(odds, p, len);
> -               ctx->len = len;
> +       if (clen + len > cs * 2 &&
> +           ((page = (void *)__get_free_page(GFP_ATOMIC)))) {
> +               buf = page;
> +               ds = PAGE_SIZE;
> +               memcpy(buf, odds, clen);
>         }
>
> -       return 0;
> -}
> +       sg_init_one(&sg, buf, ds);
>
> -static int crypto_cmac_digest_final(struct shash_desc *pdesc, u8 *out)
> -{
> -       struct crypto_shash *parent = pdesc->tfm;
> -       unsigned long alignmask = crypto_shash_alignmask(parent);
> -       struct cmac_tfm_ctx *tctx = crypto_shash_ctx(parent);
> -       struct cmac_desc_ctx *ctx = shash_desc_ctx(pdesc);
> -       struct crypto_cipher *tfm = tctx->child;
> -       int bs = crypto_shash_blocksize(parent);
> -       u8 *consts = PTR_ALIGN((void *)tctx->ctx,
> -                              (alignmask | (__alignof__(__be64) - 1)) + 1);
> -       u8 *odds = PTR_ALIGN((void *)ctx->ctx, alignmask + 1);
> -       u8 *prev = odds + bs;
> -       unsigned int offset = 0;
> +       /* encrypting the rest of data */
> +       do {
> +               unsigned int es = ds - clen;
> +               bool final = false;
> +
> +               if (len <= es) {
> +                       if (out) {
> +                               ds = len + clen;
> +                               es = len;
> +
> +                               if (ds & (bs - 1) || empty) {
> +                                       ds = fill_final_block(buf, ds, bs);
> +                                       consts += bs;
> +                               }
> +
> +                               final = true;
> +                       } else {
> +                               /* Leave at least one byte for final. */
> +                               ds = (len + clen - 1) & ~(bs - 1);
> +                               es = ds - clen;
> +                       }
> +               }
>
> -       if (ctx->len != bs) {
> -               unsigned int rlen;
> -               u8 *p = odds + ctx->len;
> +               memcpy(buf + clen, p, es);
>
> -               *p = 0x80;
> -               p++;
> +               if (final)
> +                       crypto_xor(buf + ds - bs, consts, bs);
>
> -               rlen = bs - ctx->len - 1;
> -               if (rlen)
> -                       memset(p, 0, rlen);
> +               clen = 0;
> +               empty = false;
>
> -               offset += bs;
> -       }
> +               skcipher_request_set_sync_tfm(req, tfm);
> +               skcipher_request_set_callback(req, 0, NULL, NULL);
> +               skcipher_request_set_crypt(req, &sg, &sg, ds, prev);
> +
> +               err = crypto_skcipher_encrypt(req);
> +               if (err)
> +                       return err;
> +
> +               p += es;
> +               len -= es;
> +       } while (len > (out ? 0 : cs));
> +
> +       if (page)
> +               free_page((unsigned long)page);
>
> -       crypto_xor(prev, odds, bs);
> -       crypto_xor(prev, consts + offset, bs);
> +       /* keeping the surplus */
> +       memcpy(odds, p, len);
> +       ctx->len = len;
>
> -       crypto_cipher_encrypt_one(tfm, out, prev);
> +       if (out)
> +               memcpy(out, prev, bs);
>
>         return 0;
>  }
>
> -static int cmac_init_tfm(struct crypto_tfm *tfm)
> +static int crypto_cmac_digest_update(struct shash_desc *pdesc, const u8 *p,
> +                                    unsigned int len)
> +{
> +       return crypto_cmac_digest_finup(pdesc, p, len, NULL);
> +}
> +
> +static int crypto_cmac_digest_final(struct shash_desc *pdesc, u8 *out)
> +{
> +       return crypto_cmac_digest_finup(pdesc, NULL, 0, out);
> +}
> +
> +static int cmac_init_tfm(struct crypto_shash *tfm)
>  {
> -       struct crypto_cipher *cipher;
> -       struct crypto_instance *inst = (void *)tfm->__crt_alg;
> -       struct crypto_cipher_spawn *spawn = crypto_instance_ctx(inst);
> -       struct cmac_tfm_ctx *ctx = crypto_tfm_ctx(tfm);
> +       struct shash_instance *inst = shash_alg_instance(tfm);
> +       struct cmac_tfm_ctx *ctx = crypto_shash_ctx(tfm);
> +       struct crypto_sync_skcipher_spawn *spawn;
> +       struct crypto_sync_skcipher *cipher;
> +       struct cmac_inst_ctx *ictx;
>
> -       cipher = crypto_spawn_cipher(spawn);
> +       ictx = shash_instance_ctx(inst);
> +       spawn = &ictx->spawn;
> +
> +       cipher = crypto_spawn_sync_skcipher(spawn);
>         if (IS_ERR(cipher))
>                 return PTR_ERR(cipher);
>
>         ctx->child = cipher;
>
>         return 0;
> -};
> +}
>
> -static void cmac_exit_tfm(struct crypto_tfm *tfm)
> +static void cmac_exit_tfm(struct crypto_shash *tfm)
>  {
> -       struct cmac_tfm_ctx *ctx = crypto_tfm_ctx(tfm);
> -       crypto_free_cipher(ctx->child);
> +       struct cmac_tfm_ctx *ctx = crypto_shash_ctx(tfm);
> +       crypto_free_sync_skcipher(ctx->child);
>  }
>
> -static int cmac_create(struct crypto_template *tmpl, struct rtattr **tb)
> +static int cmac_set_cbc(char *name, const char *cipher_name)
> +{
> +       if (snprintf(name, CRYPTO_MAX_ALG_NAME, "cbc(%s)", cipher_name) >=
> +           CRYPTO_MAX_ALG_NAME)
> +               return -ENAMETOOLONG;
> +
> +       return 0;
> +}
> +
> +static int cmac_check_blocksize(struct skcipher_alg *alg)
> +{
> +       switch (alg->base.cra_blocksize) {
> +       case 16:
> +       case 8:
> +               return 0;
> +       }
> +
> +       return -EINVAL;
> +}
> +
> +static int cmac_set_name(char *cra_name, char *name, const char *cipher_name)
> +{
> +       unsigned len;
> +
> +       /* Alas we screwed up the naming so we have to mangle the
> +        * cipher name.
> +        */
> +       if (strncmp(cipher_name, "cbc(", 4))
> +               return -EINVAL;
> +
> +       len = strlcpy(name, cipher_name + 4, CRYPTO_MAX_ALG_NAME);
> +       if (len < 2 || len >= CRYPTO_MAX_ALG_NAME)
> +               return -EINVAL;
> +
> +       if (name[len - 1] != ')')
> +               return -EINVAL;
> +
> +       name[len - 1] = 0;
> +
> +       if (snprintf(cra_name, CRYPTO_MAX_ALG_NAME, "cmac(%s)", name) >=
> +           CRYPTO_MAX_ALG_NAME)
> +               return -ENAMETOOLONG;
> +
> +       return 0;
> +}
> +
> +static int cmac_create_sync(struct crypto_template *tmpl, struct rtattr **tb)
>  {
> +       struct crypto_sync_skcipher_spawn *spawn;
>         struct shash_instance *inst;
> -       struct crypto_cipher_spawn *spawn;
> -       struct crypto_alg *alg;
> +       struct cmac_inst_ctx *ctx;
> +       struct skcipher_alg *alg;
> +       const char *cipher_name;
>         unsigned long alignmask;
>         u32 mask;
>         int err;
> @@ -232,53 +425,60 @@ static int cmac_create(struct crypto_template *tmpl, struct rtattr **tb)
>         if (err)
>                 return err;
>
> +       cipher_name = crypto_attr_alg_name(tb[1]);
> +       if (IS_ERR(cipher_name))
> +               return PTR_ERR(cipher_name);
> +
>         inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
>         if (!inst)
>                 return -ENOMEM;
> -       spawn = shash_instance_ctx(inst);
>
> -       err = crypto_grab_cipher(spawn, shash_crypto_instance(inst),
> -                                crypto_attr_alg_name(tb[1]), 0, mask);
> +       ctx = shash_instance_ctx(inst);
> +       spawn = &ctx->spawn;
> +
> +       err = crypto_grab_sync_skcipher(spawn, shash_crypto_instance(inst),
> +                                       cipher_name, 0, mask);
> +       if (err == -ENOENT)
> +               err = cmac_set_cbc(ctx->name, cipher_name) ?:
> +                     crypto_grab_sync_skcipher(spawn,
> +                                               shash_crypto_instance(inst),
> +                                               ctx->name, 0, mask);
>         if (err)
>                 goto err_free_inst;
> -       alg = crypto_spawn_cipher_alg(spawn);
>
> -       switch (alg->cra_blocksize) {
> -       case 16:
> -       case 8:
> -               break;
> -       default:
> -               err = -EINVAL;
> -               goto err_free_inst;
> -       }
> +       alg = crypto_sync_spawn_skcipher_alg(spawn);
>
> -       err = crypto_inst_setname(shash_crypto_instance(inst), tmpl->name, alg);
> +       err = cmac_check_blocksize(alg) ?:
> +             crypto_inst_setname(shash_crypto_instance(inst), "cmac",
> +                                 &alg->base) ?:
> +             cmac_set_name(inst->alg.base.cra_name, ctx->name,
> +                           alg->base.cra_name);
>         if (err)
>                 goto err_free_inst;
>
> -       alignmask = alg->cra_alignmask;
> +       err = -EINVAL;
> +       alignmask = alg->base.cra_alignmask;
> +       if (alignmask > alg->base.cra_blocksize)
> +               goto err_free_inst;
> +
>         inst->alg.base.cra_alignmask = alignmask;
> -       inst->alg.base.cra_priority = alg->cra_priority;
> -       inst->alg.base.cra_blocksize = alg->cra_blocksize;
> +       inst->alg.base.cra_priority = alg->base.cra_priority;
> +       inst->alg.base.cra_blocksize = alg->base.cra_blocksize;
>
> -       inst->alg.digestsize = alg->cra_blocksize;
> -       inst->alg.descsize =
> -               ALIGN(sizeof(struct cmac_desc_ctx), crypto_tfm_ctx_alignment())
> -               + (alignmask & ~(crypto_tfm_ctx_alignment() - 1))
> -               + alg->cra_blocksize * 2;
> +       inst->alg.digestsize = alg->base.cra_blocksize;
> +       inst->alg.descsize = HASH_MAX_DESCSIZE;
>
> -       inst->alg.base.cra_ctxsize =
> -               ALIGN(sizeof(struct cmac_tfm_ctx), crypto_tfm_ctx_alignment())
> -               + ((alignmask | (__alignof__(__be64) - 1)) &
> -                  ~(crypto_tfm_ctx_alignment() - 1))
> -               + alg->cra_blocksize * 2;
> +       inst->alg.base.cra_ctxsize = cmac_ctx_size(sizeof(struct cmac_tfm_ctx),
> +                                                  alignmask,
> +                                                  alg->base.cra_blocksize);
>
> -       inst->alg.base.cra_init = cmac_init_tfm;
> -       inst->alg.base.cra_exit = cmac_exit_tfm;
> +       inst->alg.init_tfm = cmac_init_tfm;
> +       inst->alg.exit_tfm = cmac_exit_tfm;
>
>         inst->alg.init = crypto_cmac_digest_init;
>         inst->alg.update = crypto_cmac_digest_update;
>         inst->alg.final = crypto_cmac_digest_final;
> +       inst->alg.finup = crypto_cmac_digest_finup;
>         inst->alg.setkey = crypto_cmac_digest_setkey;
>
>         inst->free = shash_free_singlespawn_instance;
> @@ -291,6 +491,432 @@ static int cmac_create(struct crypto_template *tmpl, struct rtattr **tb)
>         return err;
>  }
>
> +static int crypto_cmac_ahash_setkey(struct crypto_ahash *parent,
> +                                   const u8 *inkey, unsigned int keylen)
> +{
> +       struct cmac_atfm_ctx *ctx = crypto_ahash_ctx(parent);
> +       unsigned int bs = crypto_ahash_blocksize(parent);
> +       struct crypto_skcipher *child = ctx->child;
> +       __be64 *consts = cmac_async_consts(parent);
> +       struct skcipher_request *req;
> +       u32 flags;
> +       int err;
> +
> +       crypto_skcipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
> +       flags = crypto_ahash_get_flags(parent) & CRYPTO_TFM_REQ_MASK;
> +       crypto_skcipher_set_flags(child, flags);
> +
> +       err = crypto_skcipher_setkey(child, inkey, keylen);
> +       if (err)
> +               return err;
> +
> +       flags &= CRYPTO_TFM_REQ_MAY_SLEEP;
> +       req = skcipher_request_alloc(child, flags ? GFP_KERNEL : GFP_ATOMIC);
> +       if (!req)
> +               return -ENOMEM;
> +
> +       err = cmac_compute_consts(consts, bs, flags, req);
> +       skcipher_request_free(req);
> +       return err;
> +}
> +
> +static int crypto_cmac_ahash_init(struct ahash_request *req)
> +{
> +       struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
> +
> +       memset(ahash_request_ctx(req), 0, crypto_ahash_reqsize(tfm));
> +       return 0;
> +}
> +
> +static int cmac_ahash_final(struct ahash_request *req, u32 flags)
> +{
> +       struct crypto_ahash *parent = crypto_ahash_reqtfm(req);
> +       struct cmac_atfm_ctx *tctx = crypto_ahash_ctx(parent);
> +       struct cmac_req_ctx *ctx = ahash_request_ctx(req);
> +       unsigned int len = ctx->final ? 0 : req->nbytes;
> +       struct crypto_skcipher *tfm = tctx->child;
> +       struct skcipher_request *creq = &ctx->req;
> +       u8 *out = ctx->more ? NULL : req->result;
> +       int bs = crypto_ahash_blocksize(parent);
> +       u8 *consts = cmac_async_consts(parent);
> +       unsigned int done = creq->cryptlen;
> +       unsigned int clen = ctx->len;
> +       unsigned long alignmask;
> +       unsigned int ds;
> +       int err = 0;
> +       u8 *prev;
> +       u8 *odds;
> +
> +       if (ctx->page) {
> +               free_page((unsigned long)ctx->page);
> +               ctx->page = NULL;
> +       }
> +
> +       alignmask = crypto_ahash_alignmask(parent);
> +
> +       prev = skcipher_request_ctx(creq);
> +       prev += crypto_skcipher_reqsize(tfm);
> +       prev = PTR_ALIGN(prev, alignmask + 1);
> +
> +       odds = PTR_ALIGN(prev + bs, alignmask + 1);
> +
> +       ds = clen + len - done;
> +
> +       if (done >= clen) {
> +               done -= clen;
> +               len -= done;
> +               clen = 0;
> +       } else {
> +               odds += done;
> +               clen -= done;
> +               done = 0;
> +       }
> +
> +       if (len)
> +               scatterwalk_map_and_copy(odds + clen, req->src, done, len, 0);
> +
> +       if (!out)
> +               goto done;
> +
> +       if (ds & (bs - 1) || !ds) {
> +               ds = fill_final_block(odds, ds, bs);
> +               consts += bs;
> +       }
> +
> +       memcpy(out, prev, bs);
> +       crypto_xor(odds + ds - bs, consts, bs);
> +       sg_init_one(ctx->src, odds, ds);
> +
> +       skcipher_request_set_tfm(creq, tfm);
> +       skcipher_request_set_callback(creq, flags, req->base.complete,
> +                                     req->base.data);
> +       skcipher_request_set_crypt(creq, ctx->src, ctx->src, ds, out);
> +
> +       err = crypto_skcipher_encrypt(creq);
> +       ds = 0;
> +
> +done:
> +       ctx->len = ds;
> +       return err;
> +}
> +
> +static void cmac_encrypt_done(struct crypto_async_request *areq, int err)
> +{
> +       struct ahash_request *req = areq->data;
> +       u32 flags;
> +
> +       if (err)
> +               goto out;
> +
> +       flags = req->base.flags & ~CRYPTO_TFM_REQ_MAY_SLEEP;
> +       err = cmac_ahash_final(req, flags);
> +
> +out:
> +       ahash_request_complete(req, err);
> +}
> +
> +static int cmac_ahash_finup(struct ahash_request *req)
> +{
> +       struct crypto_ahash *parent = crypto_ahash_reqtfm(req);
> +       struct cmac_atfm_ctx *tctx = crypto_ahash_ctx(parent);
> +       struct cmac_req_ctx *ctx = ahash_request_ctx(req);
> +       unsigned int len = ctx->final ? 0 : req->nbytes;
> +       struct crypto_skcipher *tfm = tctx->child;
> +       struct skcipher_request *creq = &ctx->req;
> +       int bs = crypto_ahash_blocksize(parent);
> +       struct scatterlist *src = req->src;
> +       struct scatterlist *dst = ctx->dst;
> +       unsigned int clen = ctx->len;
> +       u32 flags = req->base.flags;
> +       unsigned long alignmask;
> +       unsigned int cs, ds, es;
> +       u8 *prev;
> +       u8 *odds;
> +       int err;
> +
> +       flags &= CRYPTO_TFM_REQ_MAY_SLEEP | CRYPTO_TFM_REQ_MAY_BACKLOG;
> +       alignmask = crypto_ahash_alignmask(parent);
> +
> +       prev = skcipher_request_ctx(creq);
> +       prev += crypto_skcipher_reqsize(tfm);
> +       prev = PTR_ALIGN(prev, alignmask + 1);
> +
> +       odds = PTR_ALIGN(prev + bs, alignmask + 1);
> +
> +       cs = crypto_ahash_reqsize(parent) - (odds - (u8 *)ctx);
> +       cs &= ~(bs - 1);
> +       if (cs > PAGE_SIZE)
> +               cs = PAGE_SIZE;
> +
> +       ds = clen + len;
> +       es = HASH_MAX_STATESIZE - 4 - bs;
> +
> +       creq->cryptlen = 0;
> +
> +       /* checking the data can fill the blocks */
> +       if (ds <= es)
> +               return cmac_ahash_final(req, flags);
> +
> +       /* Leave at least one byte for final. */
> +       if (!ds || !(ds = (ds - 1) & ~(bs - 1)))
> +               return cmac_ahash_final(req, flags);
> +
> +       if (clen) {
> +               sg_chain(ctx->src, 2, src);
> +               src = ctx->src;
> +               sg_set_buf(src, odds, clen);
> +       }
> +
> +       sg_set_buf(dst, odds, cs);
> +       sg_chain(dst, 2, dst);
> +
> +       if (ds > cs && cs < PAGE_SIZE &&
> +           ((ctx->page = (void *)__get_free_page(GFP_ATOMIC))))
> +               sg_set_buf(dst, ctx->page, PAGE_SIZE);
> +
> +       skcipher_request_set_tfm(creq, tfm);
> +       skcipher_request_set_callback(creq, flags, cmac_encrypt_done, req);
> +       skcipher_request_set_crypt(creq, src, dst, ds, prev);
> +
> +       err = crypto_skcipher_encrypt(creq);
> +       if (err == -EINPROGRESS || err == -EBUSY)
> +               return err;
> +
> +       return cmac_ahash_final(req, flags);
> +}
> +
> +static int crypto_cmac_ahash_update(struct ahash_request *req)
> +{
> +       struct cmac_req_ctx *ctx = ahash_request_ctx(req);
> +
> +       ctx->more = true;
> +       return cmac_ahash_finup(req);
> +}
> +
> +static int crypto_cmac_ahash_finup(struct ahash_request *req)
> +{
> +       struct cmac_req_ctx *ctx = ahash_request_ctx(req);
> +
> +       ctx->more = false;
> +       return cmac_ahash_finup(req);
> +}
> +
> +static int crypto_cmac_ahash_final(struct ahash_request *req)
> +{
> +       struct cmac_req_ctx *ctx = ahash_request_ctx(req);
> +
> +       ctx->more = false;
> +       ctx->final = true;
> +       return cmac_ahash_finup(req);
> +}
> +
> +static int crypto_cmac_ahash_digest(struct ahash_request *req)
> +{
> +       return crypto_cmac_ahash_init(req) ?: cmac_ahash_finup(req);
> +}
> +
> +static int crypto_cmac_ahash_export(struct ahash_request *req, void *out)
> +{
> +       struct crypto_ahash *parent = crypto_ahash_reqtfm(req);
> +       struct cmac_atfm_ctx *tctx = crypto_ahash_ctx(parent);
> +       struct cmac_req_ctx *ctx = ahash_request_ctx(req);
> +       unsigned int bs = crypto_ahash_blocksize(parent);
> +       struct crypto_skcipher *tfm = tctx->child;
> +       struct skcipher_request *creq = &ctx->req;
> +       unsigned long alignmask;
> +       u8 *p = out;
> +       u8 *prev;
> +       u8 *odds;
> +
> +       alignmask = crypto_ahash_alignmask(parent);
> +
> +       prev = skcipher_request_ctx(creq);
> +       prev += crypto_skcipher_reqsize(tfm);
> +       prev = PTR_ALIGN(prev, alignmask + 1);
> +
> +       odds = PTR_ALIGN(prev + bs, alignmask + 1);
> +
> +       *(u32 *)p = ctx->len;
> +
> +       p += 4;
> +       memcpy(p, prev, bs);
> +
> +       p += bs;
> +       memcpy(p, odds, ctx->len);
> +
> +       return 0;
> +}
> +
> +static int crypto_cmac_ahash_import(struct ahash_request *req, const void *in)
> +{
> +       struct crypto_ahash *parent = crypto_ahash_reqtfm(req);
> +       struct cmac_atfm_ctx *tctx = crypto_ahash_ctx(parent);
> +       struct cmac_req_ctx *ctx = ahash_request_ctx(req);
> +       unsigned int bs = crypto_ahash_blocksize(parent);
> +       struct crypto_skcipher *tfm = tctx->child;
> +       struct skcipher_request *creq = &ctx->req;
> +       unsigned long alignmask;
> +       const u8 *p = in;
> +       u8 *prev;
> +       u8 *odds;
> +       int err;
> +
> +       err = crypto_cmac_ahash_init(req);
> +       if (err)
> +               return err;
> +
> +       alignmask = crypto_ahash_alignmask(parent);
> +
> +       prev = skcipher_request_ctx(creq);
> +       prev += crypto_skcipher_reqsize(tfm);
> +       prev = PTR_ALIGN(prev, alignmask + 1);
> +
> +       odds = PTR_ALIGN(prev + bs, alignmask + 1);
> +
> +       ctx->len = *(const u32 *)p;
> +       if (ctx->len > HASH_MAX_STATESIZE - 4 - bs)
> +               return -EINVAL;
> +
> +       p += 4;
> +       memcpy(prev, p, bs);
> +
> +       p += bs;
> +       memcpy(odds, p, ctx->len);
> +
> +       return 0;
> +}
> +
> +static int cmac_init_ahash(struct crypto_ahash *tfm)
> +{
> +       struct ahash_instance *inst = ahash_alg_instance(tfm);
> +       unsigned long alignmask = crypto_ahash_alignmask(tfm);
> +       struct cmac_atfm_ctx *ctx = crypto_ahash_ctx(tfm);
> +       unsigned int bs = crypto_ahash_blocksize(tfm);
> +       struct crypto_skcipher_spawn *spawn;
> +       struct crypto_skcipher *cipher;
> +       struct cmac_ainst_ctx *ictx;
> +       unsigned int reqsize;
> +       unsigned int head;
> +
> +       ictx = ahash_instance_ctx(inst);
> +       spawn = &ictx->spawn;
> +
> +       cipher = crypto_spawn_skcipher(spawn);
> +       if (IS_ERR(cipher))
> +               return PTR_ERR(cipher);
> +
> +       ctx->child = cipher;
> +
> +       reqsize = sizeof(struct cmac_req_ctx);
> +       reqsize += ALIGN(crypto_skcipher_reqsize(cipher), CRYPTO_MINALIGN);
> +       if (alignmask > CRYPTO_MINALIGN)
> +               reqsize += alignmask + 1 - CRYPTO_MINALIGN;
> +       reqsize += ALIGN(bs, alignmask + 1);
> +       reqsize += HASH_MAX_STATESIZE;
> +
> +       head = sizeof(struct ahash_request);
> +       reqsize = roundup_pow_of_two(reqsize + head) - head;
> +
> +       crypto_ahash_set_reqsize(tfm, reqsize);
> +
> +       return 0;
> +}
> +
> +static void cmac_exit_ahash(struct crypto_ahash *tfm)
> +{
> +       struct cmac_atfm_ctx *ctx = crypto_ahash_ctx(tfm);
> +       crypto_free_skcipher(ctx->child);
> +}
> +
> +static int cmac_create(struct crypto_template *tmpl, struct rtattr **tb)
> +{
> +
> +       struct crypto_skcipher_spawn *spawn;
> +       struct crypto_attr_type *algt;
> +       struct cmac_ainst_ctx *ctx;
> +       struct ahash_instance *inst;
> +       struct skcipher_alg *alg;
> +       const char *cipher_name;
> +       unsigned int alignmask;
> +       u32 mask;
> +       int err;
> +
> +       algt = crypto_get_attr_type(tb);
> +       if (IS_ERR(algt))
> +               return PTR_ERR(algt);
> +
> +       if ((algt->type ^ (CRYPTO_ALG_TYPE_AHASH | CRYPTO_ALG_ASYNC)) &
> +           algt->mask)
> +               return cmac_create_sync(tmpl, tb);
> +
> +       mask = crypto_algt_inherited_mask(algt);
> +
> +       cipher_name = crypto_attr_alg_name(tb[1]);
> +       if (IS_ERR(cipher_name))
> +               return PTR_ERR(cipher_name);
> +
> +       inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
> +       if (!inst)
> +               return -ENOMEM;
> +
> +       ctx = ahash_instance_ctx(inst);
> +       spawn = &ctx->spawn;
> +
> +       err = crypto_grab_skcipher(spawn, ahash_crypto_instance(inst),
> +                                  cipher_name, 0, mask);
> +       if (err == -ENOENT)
> +               err = cmac_set_cbc(ctx->name, cipher_name) ?:
> +                     crypto_grab_skcipher(spawn, ahash_crypto_instance(inst),
> +                                          ctx->name, 0, mask);
> +       if (err)
> +               goto err_free_inst;
> +
> +       alg = crypto_spawn_skcipher_alg(spawn);
> +
> +       err = cmac_check_blocksize(alg) ?:
> +             crypto_inst_setname(ahash_crypto_instance(inst), "cmac",
> +                                 &alg->base) ?:
> +             cmac_set_name(inst->alg.halg.base.cra_name, ctx->name,
> +                           alg->base.cra_name);
> +       if (err)
> +               goto err_free_inst;
> +
> +       err = -EINVAL;
> +
> +       alignmask = alg->base.cra_alignmask;
> +       inst->alg.halg.base.cra_alignmask = alignmask;
> +       inst->alg.halg.base.cra_priority = alg->base.cra_priority;
> +       inst->alg.halg.base.cra_blocksize = alg->base.cra_blocksize;
> +
> +       inst->alg.halg.digestsize = alg->base.cra_blocksize;
> +       inst->alg.halg.statesize = HASH_MAX_STATESIZE;
> +
> +       inst->alg.halg.base.cra_ctxsize =
> +               cmac_ctx_size(sizeof(struct cmac_atfm_ctx), alignmask,
> +                             alg->base.cra_blocksize);
> +
> +       inst->alg.init_tfm = cmac_init_ahash;
> +       inst->alg.exit_tfm = cmac_exit_ahash;
> +
> +       inst->alg.init = crypto_cmac_ahash_init;
> +       inst->alg.update = crypto_cmac_ahash_update;
> +       inst->alg.final = crypto_cmac_ahash_final;
> +       inst->alg.finup = crypto_cmac_ahash_finup;
> +       inst->alg.digest = crypto_cmac_ahash_digest;
> +       inst->alg.export = crypto_cmac_ahash_export;
> +       inst->alg.import = crypto_cmac_ahash_import;
> +       inst->alg.setkey = crypto_cmac_ahash_setkey;
> +
> +       inst->free = ahash_free_singlespawn_instance;
> +
> +       err = ahash_register_instance(tmpl, inst);
> +       if (err) {
> +err_free_inst:
> +               ahash_free_singlespawn_instance(inst);
> +       }
> +       return err;
> +}
> +
>  static struct crypto_template crypto_cmac_tmpl = {
>         .name = "cmac",
>         .create = cmac_create,
