Return-Path: <SRS0=wYoS=XZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D85B2C32792
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Sep 2019 21:07:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8BAF5205C9
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Sep 2019 21:07:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="rGWkWn2O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730178AbfI3VHZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 30 Sep 2019 17:07:25 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38870 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730145AbfI3VHZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Sep 2019 17:07:25 -0400
Received: by mail-wm1-f67.google.com with SMTP id 3so919189wmi.3
        for <linux-crypto@vger.kernel.org>; Mon, 30 Sep 2019 14:07:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=F1dlrd4F5ORPyEdCSa26LpJQUh8jHjxDzQoiSPUQeMc=;
        b=rGWkWn2Or7Fh+P3NUo2KX3yziLJHrtUlZ4npEQOkXhI9NcxaA+pgR39DUEe4MDscqb
         2M8n4b02UypNea/k/ZYd35Lt8IBebxxonuKsPf+Dy+d8Ub8CQicBFjkmLhfyQOTpiXJL
         iHPKKfWGxjUhIiRXNlIOkIKKenTbJu1yxtaN+xsw81koqflE3jaAJ0+LZt6x6faqdpyp
         TG2kPSWxAL9j4jCg23JDfY3/gcSF2j3jVlZFjT3hYE0ZnH+jqBdbHre5OygQwl3Y0D+q
         JHrKgKy61I8XEUZH5ZKmiB78ox+NblGAO4W275pE+vg9JGLZTSTGsPtoC3c4wToBc13p
         2A5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=F1dlrd4F5ORPyEdCSa26LpJQUh8jHjxDzQoiSPUQeMc=;
        b=tMxiwgnl9msj4FLEqwkL3/MYDujrXb3m2OzuQXxefczAuWKZd5+uYXqZefhHR/Anl4
         pjQWjMafX4GuQ3XFe7DYZnfbCg7/bOM9i2dlBBq37OyG9Wun4vKTHqnkEOBFcTVpxdTm
         7JH2EkM6m27emMEy/JxZCOW4w8uVjETNOyKv3Dqwl+0lBDMQYD3Y5IKGwqpvemiEdZn8
         OGsvB7jOjFyNllNupomIQ39QwTgfTkSpUKZZ170G2Fhdl4Gcn71/UrudVy8+DnMp0RNN
         Q+3gHdzsQbvyYt+w01MgZt3QRQOJIrEK2hg9q13nS4dBYBggdBl0QNmb+cNxzSZb8qrv
         Wy+g==
X-Gm-Message-State: APjAAAXko7vyQo6wPiJn1dNjjdhA75qSdivMjsu3NqtEczjbFu1nm409
        /+M6ED0MoO/R/L33o4BO/Te0dVUf/nHoKfhlbwkZfKEEkIyHhA==
X-Google-Smtp-Source: APXvYqxUTU0KrRQ3SKr9IUXKAfqS1/XySFfbIMwLlUKgPBoCQ6Y8oRtqEbZ3oRCmyby749UWXKSL1hkySbouWLDh4Qg=
X-Received: by 2002:a7b:c451:: with SMTP id l17mr353621wmi.61.1569867600304;
 Mon, 30 Sep 2019 11:20:00 -0700 (PDT)
MIME-Version: 1.0
References: <20190821143253.30209-1-ard.biesheuvel@linaro.org>
 <20190821143253.30209-16-ard.biesheuvel@linaro.org> <20190930163241.GA14355@roeck-us.net>
In-Reply-To: <20190930163241.GA14355@roeck-us.net>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 30 Sep 2019 20:19:47 +0200
Message-ID: <CAKv+Gu_KccJPm6x6bc8fYAiUTDuV-u6X3iqifOSVihFnDYtdrg@mail.gmail.com>
Subject: Re: [PATCH 15/17] crypto: arm/aes-ce - implement ciphertext stealing
 for CBC
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 30 Sep 2019 at 18:32, Guenter Roeck <linux@roeck-us.net> wrote:
>
> On Wed, Aug 21, 2019 at 05:32:51PM +0300, Ard Biesheuvel wrote:
> > Instead of relying on the CTS template to wrap the accelerated CBC
> > skcipher, implement the ciphertext stealing part directly.
> >
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>
> For arm:allmodconfig built with gcc 9.2.0, this patch results in
>
> arch/arm/crypto/aes-ce-core.S: Assembler messages:
> arch/arm/crypto/aes-ce-core.S:299: Error: selected processor does not support `movw ip,:lower16:.Lcts_permute_table' in ARM mode
> arch/arm/crypto/aes-ce-core.S:300: Error: selected processor does not support `movt ip,:upper16:.Lcts_permute_table' in ARM mode
> arch/arm/crypto/aes-ce-core.S:337: Error: selected processor does not support `movw ip,:lower16:.Lcts_permute_table' in ARM mode
> arch/arm/crypto/aes-ce-core.S:338: Error: selected processor does not support `movt ip,:upper16:.Lcts_permute_table' in ARM mode
> arch/arm/crypto/aes-ce-core.S:552: Error: selected processor does not support `movw ip,:lower16:.Lcts_permute_table' in ARM mode
> arch/arm/crypto/aes-ce-core.S:553: Error: selected processor does not support `movt ip,:upper16:.Lcts_permute_table' in ARM mode
> arch/arm/crypto/aes-ce-core.S:638: Error: selected processor does not support `movw ip,:lower16:.Lcts_permute_table' in ARM mode
> arch/arm/crypto/aes-ce-core.S:639: Error: selected processor does not support `movt ip,:upper16:.Lcts_permute_table' in ARM mode
>
> Any idea how to avoid that ?
>

Yes, this should fix it:

https://lore.kernel.org/linux-crypto/20190917085001.792-1-ard.biesheuvel@arm.com/




> > ---
> >  arch/arm/crypto/aes-ce-core.S |  85 +++++++++
> >  arch/arm/crypto/aes-ce-glue.c | 188 ++++++++++++++++++--
> >  2 files changed, 256 insertions(+), 17 deletions(-)
> >
> > diff --git a/arch/arm/crypto/aes-ce-core.S b/arch/arm/crypto/aes-ce-core.S
> > index 763e51604ab6..b978cdf133af 100644
> > --- a/arch/arm/crypto/aes-ce-core.S
> > +++ b/arch/arm/crypto/aes-ce-core.S
> > @@ -284,6 +284,91 @@ ENTRY(ce_aes_cbc_decrypt)
> >       pop             {r4-r6, pc}
> >  ENDPROC(ce_aes_cbc_decrypt)
> >
> > +
> > +     /*
> > +      * ce_aes_cbc_cts_encrypt(u8 out[], u8 const in[], u32 const rk[],
> > +      *                        int rounds, int bytes, u8 const iv[])
> > +      * ce_aes_cbc_cts_decrypt(u8 out[], u8 const in[], u32 const rk[],
> > +      *                        int rounds, int bytes, u8 const iv[])
> > +      */
> > +
> > +ENTRY(ce_aes_cbc_cts_encrypt)
> > +     push            {r4-r6, lr}
> > +     ldrd            r4, r5, [sp, #16]
> > +
> > +     movw            ip, :lower16:.Lcts_permute_table
> > +     movt            ip, :upper16:.Lcts_permute_table
> > +     sub             r4, r4, #16
> > +     add             lr, ip, #32
> > +     add             ip, ip, r4
> > +     sub             lr, lr, r4
> > +     vld1.8          {q5}, [ip]
> > +     vld1.8          {q6}, [lr]
> > +
> > +     add             ip, r1, r4
> > +     vld1.8          {q0}, [r1]                      @ overlapping loads
> > +     vld1.8          {q3}, [ip]
> > +
> > +     vld1.8          {q1}, [r5]                      @ get iv
> > +     prepare_key     r2, r3
> > +
> > +     veor            q0, q0, q1                      @ xor with iv
> > +     bl              aes_encrypt
> > +
> > +     vtbl.8          d4, {d0-d1}, d10
> > +     vtbl.8          d5, {d0-d1}, d11
> > +     vtbl.8          d2, {d6-d7}, d12
> > +     vtbl.8          d3, {d6-d7}, d13
> > +
> > +     veor            q0, q0, q1
> > +     bl              aes_encrypt
> > +
> > +     add             r4, r0, r4
> > +     vst1.8          {q2}, [r4]                      @ overlapping stores
> > +     vst1.8          {q0}, [r0]
> > +
> > +     pop             {r4-r6, pc}
> > +ENDPROC(ce_aes_cbc_cts_encrypt)
> > +
> > +ENTRY(ce_aes_cbc_cts_decrypt)
> > +     push            {r4-r6, lr}
> > +     ldrd            r4, r5, [sp, #16]
> > +
> > +     movw            ip, :lower16:.Lcts_permute_table
> > +     movt            ip, :upper16:.Lcts_permute_table
> > +     sub             r4, r4, #16
> > +     add             lr, ip, #32
> > +     add             ip, ip, r4
> > +     sub             lr, lr, r4
> > +     vld1.8          {q5}, [ip]
> > +     vld1.8          {q6}, [lr]
> > +
> > +     add             ip, r1, r4
> > +     vld1.8          {q0}, [r1]                      @ overlapping loads
> > +     vld1.8          {q1}, [ip]
> > +
> > +     vld1.8          {q3}, [r5]                      @ get iv
> > +     prepare_key     r2, r3
> > +
> > +     bl              aes_decrypt
> > +
> > +     vtbl.8          d4, {d0-d1}, d10
> > +     vtbl.8          d5, {d0-d1}, d11
> > +     vtbx.8          d0, {d2-d3}, d12
> > +     vtbx.8          d1, {d2-d3}, d13
> > +
> > +     veor            q1, q1, q2
> > +     bl              aes_decrypt
> > +     veor            q0, q0, q3                      @ xor with iv
> > +
> > +     add             r4, r0, r4
> > +     vst1.8          {q1}, [r4]                      @ overlapping stores
> > +     vst1.8          {q0}, [r0]
> > +
> > +     pop             {r4-r6, pc}
> > +ENDPROC(ce_aes_cbc_cts_decrypt)
> > +
> > +
> >       /*
> >        * aes_ctr_encrypt(u8 out[], u8 const in[], u32 const rk[], int rounds,
> >        *                 int blocks, u8 ctr[])
> > diff --git a/arch/arm/crypto/aes-ce-glue.c b/arch/arm/crypto/aes-ce-glue.c
> > index c215792a2494..cdb1a07e7ad0 100644
> > --- a/arch/arm/crypto/aes-ce-glue.c
> > +++ b/arch/arm/crypto/aes-ce-glue.c
> > @@ -35,6 +35,10 @@ asmlinkage void ce_aes_cbc_encrypt(u8 out[], u8 const in[], u32 const rk[],
> >                                  int rounds, int blocks, u8 iv[]);
> >  asmlinkage void ce_aes_cbc_decrypt(u8 out[], u8 const in[], u32 const rk[],
> >                                  int rounds, int blocks, u8 iv[]);
> > +asmlinkage void ce_aes_cbc_cts_encrypt(u8 out[], u8 const in[], u32 const rk[],
> > +                                int rounds, int bytes, u8 const iv[]);
> > +asmlinkage void ce_aes_cbc_cts_decrypt(u8 out[], u8 const in[], u32 const rk[],
> > +                                int rounds, int bytes, u8 const iv[]);
> >
> >  asmlinkage void ce_aes_ctr_encrypt(u8 out[], u8 const in[], u32 const rk[],
> >                                  int rounds, int blocks, u8 ctr[]);
> > @@ -210,48 +214,182 @@ static int ecb_decrypt(struct skcipher_request *req)
> >       return err;
> >  }
> >
> > -static int cbc_encrypt(struct skcipher_request *req)
> > +static int cbc_encrypt_walk(struct skcipher_request *req,
> > +                         struct skcipher_walk *walk)
> >  {
> >       struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
> >       struct crypto_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
> > -     struct skcipher_walk walk;
> >       unsigned int blocks;
> > -     int err;
> > +     int err = 0;
> >
> > -     err = skcipher_walk_virt(&walk, req, false);
> > -
> > -     while ((blocks = (walk.nbytes / AES_BLOCK_SIZE))) {
> > +     while ((blocks = (walk->nbytes / AES_BLOCK_SIZE))) {
> >               kernel_neon_begin();
> > -             ce_aes_cbc_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
> > +             ce_aes_cbc_encrypt(walk->dst.virt.addr, walk->src.virt.addr,
> >                                  ctx->key_enc, num_rounds(ctx), blocks,
> > -                                walk.iv);
> > +                                walk->iv);
> >               kernel_neon_end();
> > -             err = skcipher_walk_done(&walk, walk.nbytes % AES_BLOCK_SIZE);
> > +             err = skcipher_walk_done(walk, walk->nbytes % AES_BLOCK_SIZE);
> >       }
> >       return err;
> >  }
> >
> > -static int cbc_decrypt(struct skcipher_request *req)
> > +static int cbc_encrypt(struct skcipher_request *req)
> >  {
> > -     struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
> > -     struct crypto_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
> >       struct skcipher_walk walk;
> > -     unsigned int blocks;
> >       int err;
> >
> >       err = skcipher_walk_virt(&walk, req, false);
> > +     if (err)
> > +             return err;
> > +     return cbc_encrypt_walk(req, &walk);
> > +}
> >
> > -     while ((blocks = (walk.nbytes / AES_BLOCK_SIZE))) {
> > +static int cbc_decrypt_walk(struct skcipher_request *req,
> > +                         struct skcipher_walk *walk)
> > +{
> > +     struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
> > +     struct crypto_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
> > +     unsigned int blocks;
> > +     int err = 0;
> > +
> > +     while ((blocks = (walk->nbytes / AES_BLOCK_SIZE))) {
> >               kernel_neon_begin();
> > -             ce_aes_cbc_decrypt(walk.dst.virt.addr, walk.src.virt.addr,
> > +             ce_aes_cbc_decrypt(walk->dst.virt.addr, walk->src.virt.addr,
> >                                  ctx->key_dec, num_rounds(ctx), blocks,
> > -                                walk.iv);
> > +                                walk->iv);
> >               kernel_neon_end();
> > -             err = skcipher_walk_done(&walk, walk.nbytes % AES_BLOCK_SIZE);
> > +             err = skcipher_walk_done(walk, walk->nbytes % AES_BLOCK_SIZE);
> >       }
> >       return err;
> >  }
> >
> > +static int cbc_decrypt(struct skcipher_request *req)
> > +{
> > +     struct skcipher_walk walk;
> > +     int err;
> > +
> > +     err = skcipher_walk_virt(&walk, req, false);
> > +     if (err)
> > +             return err;
> > +     return cbc_decrypt_walk(req, &walk);
> > +}
> > +
> > +static int cts_cbc_encrypt(struct skcipher_request *req)
> > +{
> > +     struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
> > +     struct crypto_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
> > +     int cbc_blocks = DIV_ROUND_UP(req->cryptlen, AES_BLOCK_SIZE) - 2;
> > +     struct scatterlist *src = req->src, *dst = req->dst;
> > +     struct scatterlist sg_src[2], sg_dst[2];
> > +     struct skcipher_request subreq;
> > +     struct skcipher_walk walk;
> > +     int err;
> > +
> > +     skcipher_request_set_tfm(&subreq, tfm);
> > +     skcipher_request_set_callback(&subreq, skcipher_request_flags(req),
> > +                                   NULL, NULL);
> > +
> > +     if (req->cryptlen <= AES_BLOCK_SIZE) {
> > +             if (req->cryptlen < AES_BLOCK_SIZE)
> > +                     return -EINVAL;
> > +             cbc_blocks = 1;
> > +     }
> > +
> > +     if (cbc_blocks > 0) {
> > +             skcipher_request_set_crypt(&subreq, req->src, req->dst,
> > +                                        cbc_blocks * AES_BLOCK_SIZE,
> > +                                        req->iv);
> > +
> > +             err = skcipher_walk_virt(&walk, &subreq, false) ?:
> > +                   cbc_encrypt_walk(&subreq, &walk);
> > +             if (err)
> > +                     return err;
> > +
> > +             if (req->cryptlen == AES_BLOCK_SIZE)
> > +                     return 0;
> > +
> > +             dst = src = scatterwalk_ffwd(sg_src, req->src, subreq.cryptlen);
> > +             if (req->dst != req->src)
> > +                     dst = scatterwalk_ffwd(sg_dst, req->dst,
> > +                                            subreq.cryptlen);
> > +     }
> > +
> > +     /* handle ciphertext stealing */
> > +     skcipher_request_set_crypt(&subreq, src, dst,
> > +                                req->cryptlen - cbc_blocks * AES_BLOCK_SIZE,
> > +                                req->iv);
> > +
> > +     err = skcipher_walk_virt(&walk, &subreq, false);
> > +     if (err)
> > +             return err;
> > +
> > +     kernel_neon_begin();
> > +     ce_aes_cbc_cts_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
> > +                            ctx->key_enc, num_rounds(ctx), walk.nbytes,
> > +                            walk.iv);
> > +     kernel_neon_end();
> > +
> > +     return skcipher_walk_done(&walk, 0);
> > +}
> > +
> > +static int cts_cbc_decrypt(struct skcipher_request *req)
> > +{
> > +     struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
> > +     struct crypto_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
> > +     int cbc_blocks = DIV_ROUND_UP(req->cryptlen, AES_BLOCK_SIZE) - 2;
> > +     struct scatterlist *src = req->src, *dst = req->dst;
> > +     struct scatterlist sg_src[2], sg_dst[2];
> > +     struct skcipher_request subreq;
> > +     struct skcipher_walk walk;
> > +     int err;
> > +
> > +     skcipher_request_set_tfm(&subreq, tfm);
> > +     skcipher_request_set_callback(&subreq, skcipher_request_flags(req),
> > +                                   NULL, NULL);
> > +
> > +     if (req->cryptlen <= AES_BLOCK_SIZE) {
> > +             if (req->cryptlen < AES_BLOCK_SIZE)
> > +                     return -EINVAL;
> > +             cbc_blocks = 1;
> > +     }
> > +
> > +     if (cbc_blocks > 0) {
> > +             skcipher_request_set_crypt(&subreq, req->src, req->dst,
> > +                                        cbc_blocks * AES_BLOCK_SIZE,
> > +                                        req->iv);
> > +
> > +             err = skcipher_walk_virt(&walk, &subreq, false) ?:
> > +                   cbc_decrypt_walk(&subreq, &walk);
> > +             if (err)
> > +                     return err;
> > +
> > +             if (req->cryptlen == AES_BLOCK_SIZE)
> > +                     return 0;
> > +
> > +             dst = src = scatterwalk_ffwd(sg_src, req->src, subreq.cryptlen);
> > +             if (req->dst != req->src)
> > +                     dst = scatterwalk_ffwd(sg_dst, req->dst,
> > +                                            subreq.cryptlen);
> > +     }
> > +
> > +     /* handle ciphertext stealing */
> > +     skcipher_request_set_crypt(&subreq, src, dst,
> > +                                req->cryptlen - cbc_blocks * AES_BLOCK_SIZE,
> > +                                req->iv);
> > +
> > +     err = skcipher_walk_virt(&walk, &subreq, false);
> > +     if (err)
> > +             return err;
> > +
> > +     kernel_neon_begin();
> > +     ce_aes_cbc_cts_decrypt(walk.dst.virt.addr, walk.src.virt.addr,
> > +                            ctx->key_dec, num_rounds(ctx), walk.nbytes,
> > +                            walk.iv);
> > +     kernel_neon_end();
> > +
> > +     return skcipher_walk_done(&walk, 0);
> > +}
> > +
> >  static int ctr_encrypt(struct skcipher_request *req)
> >  {
> >       struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
> > @@ -486,6 +624,22 @@ static struct skcipher_alg aes_algs[] = { {
> >       .setkey                 = ce_aes_setkey,
> >       .encrypt                = cbc_encrypt,
> >       .decrypt                = cbc_decrypt,
> > +}, {
> > +     .base.cra_name          = "__cts(cbc(aes))",
> > +     .base.cra_driver_name   = "__cts-cbc-aes-ce",
> > +     .base.cra_priority      = 300,
> > +     .base.cra_flags         = CRYPTO_ALG_INTERNAL,
> > +     .base.cra_blocksize     = AES_BLOCK_SIZE,
> > +     .base.cra_ctxsize       = sizeof(struct crypto_aes_ctx),
> > +     .base.cra_module        = THIS_MODULE,
> > +
> > +     .min_keysize            = AES_MIN_KEY_SIZE,
> > +     .max_keysize            = AES_MAX_KEY_SIZE,
> > +     .ivsize                 = AES_BLOCK_SIZE,
> > +     .walksize               = 2 * AES_BLOCK_SIZE,
> > +     .setkey                 = ce_aes_setkey,
> > +     .encrypt                = cts_cbc_encrypt,
> > +     .decrypt                = cts_cbc_decrypt,
> >  }, {
> >       .base.cra_name          = "__ctr(aes)",
> >       .base.cra_driver_name   = "__ctr-aes-ce",
