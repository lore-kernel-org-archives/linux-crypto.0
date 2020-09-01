Return-Path: <SRS0=65YJ=CK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35EA2C433E2
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Sep 2020 12:44:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F5BB206CD
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Sep 2020 12:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598964242;
	bh=uSDIIwJheHhnhnwA+f9yNJkacKFxUcCjbzBlAX7aTKk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=eU1TEzYzsnUAMHlzyaGAwgVVq3STcCHduyajCsElGNtzVmTouqQRTRy4IfbP7fMaX
	 oRBMbPhQeI26W+QHlc1krWdAX8qsd34vAjgsGMnWtyhFRcItTY6axx6u5nGlIwGXWg
	 /xuMUZ0mgq5lia9J4VV76mPgexIYby6R9nOTTcCQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728043AbgIAMno (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Sep 2020 08:43:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:37928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728185AbgIAMQ1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Sep 2020 08:16:27 -0400
Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7CDC20767
        for <linux-crypto@vger.kernel.org>; Tue,  1 Sep 2020 12:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598962563;
        bh=uSDIIwJheHhnhnwA+f9yNJkacKFxUcCjbzBlAX7aTKk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=t4wHK8lD6+tZqWzwB3+GhDI5gu6rnIdlpD4hnBPaeHiMYFm32kDS6WyY86ig0WfHb
         llBvF8KVO8NaVW812wF+HoPK0Ta4rL4qPmmP+fnw2LQ23LqOp7toHhl03J+DTGDFFi
         uJOQdL0iEj0PWxpqJxRdimtMTQOrVdgZlK5jIUgQ=
Received: by mail-oo1-f49.google.com with SMTP id m4so230461oos.6
        for <linux-crypto@vger.kernel.org>; Tue, 01 Sep 2020 05:16:02 -0700 (PDT)
X-Gm-Message-State: AOAM532/JYXCztwxu8Xp4a+jIT+oWSNY/CmzClF/DBcT6HeKraRKScm9
        4E7uoalbNnj+8ACIFnzyDVDWvD+9GPSs8yyEEqs=
X-Google-Smtp-Source: ABdhPJwH37ioUMGpaohNoOCSPV3Kv0qeO00bzre2QePc6z1ABla8gKzpIPXpZvdpVQnOiAhd5l+tlBO0o2RVUMK39h4=
X-Received: by 2002:a4a:4910:: with SMTP id z16mr1029424ooa.41.1598962562190;
 Tue, 01 Sep 2020 05:16:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200901062804.GA1533@gondor.apana.org.au> <CAMj1kXGDPTbhs_2FkvHROMmp+j7eON43r8muWgMGJpFQKpTjSw@mail.gmail.com>
 <20200901114542.GA2441@gondor.apana.org.au> <20200901114840.GA2519@gondor.apana.org.au>
In-Reply-To: <20200901114840.GA2519@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 1 Sep 2020 15:15:51 +0300
X-Gmail-Original-Message-ID: <CAMj1kXHn-d-Dv81cY=0r3VeZWnkFdLYuDBDP7WbQqTSvFia0+Q@mail.gmail.com>
Message-ID: <CAMj1kXHn-d-Dv81cY=0r3VeZWnkFdLYuDBDP7WbQqTSvFia0+Q@mail.gmail.com>
Subject: Re: [v2 PATCH 1/2] crypto: arm/aes-neonbs - Use generic cbc
 encryption path
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 1 Sep 2020 at 14:48, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> Since commit b56f5cbc7e08ec7d31c42fc41e5247677f20b143 ("crypto:
> arm/aes-neonbs - resolve fallback cipher at runtime") the CBC
> encryption path in aes-neonbs is now identical to that obtained
> through the cbc template.  This means that it can simply call
> the generic cbc template instead of doing its own thing.
>
> This patch removes the custom encryption path and simply invokes
> the generic cbc template.
>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

For the series,

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>

>
> diff --git a/arch/arm/crypto/aes-neonbs-glue.c b/arch/arm/crypto/aes-neonbs-glue.c
> index e6fd32919c81..b324c5500846 100644
> --- a/arch/arm/crypto/aes-neonbs-glue.c
> +++ b/arch/arm/crypto/aes-neonbs-glue.c
> @@ -8,7 +8,6 @@
>  #include <asm/neon.h>
>  #include <asm/simd.h>
>  #include <crypto/aes.h>
> -#include <crypto/cbc.h>
>  #include <crypto/ctr.h>
>  #include <crypto/internal/simd.h>
>  #include <crypto/internal/skcipher.h>
> @@ -49,7 +48,7 @@ struct aesbs_ctx {
>
>  struct aesbs_cbc_ctx {
>         struct aesbs_ctx        key;
> -       struct crypto_cipher    *enc_tfm;
> +       struct crypto_skcipher  *enc_tfm;
>  };
>
>  struct aesbs_xts_ctx {
> @@ -140,19 +139,23 @@ static int aesbs_cbc_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
>         kernel_neon_end();
>         memzero_explicit(&rk, sizeof(rk));
>
> -       return crypto_cipher_setkey(ctx->enc_tfm, in_key, key_len);
> +       return crypto_skcipher_setkey(ctx->enc_tfm, in_key, key_len);
>  }
>
> -static void cbc_encrypt_one(struct crypto_skcipher *tfm, const u8 *src, u8 *dst)
> +static int cbc_encrypt(struct skcipher_request *req)
>  {
> +       struct skcipher_request *subreq = skcipher_request_ctx(req);
> +       struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
>         struct aesbs_cbc_ctx *ctx = crypto_skcipher_ctx(tfm);
>
> -       crypto_cipher_encrypt_one(ctx->enc_tfm, dst, src);
> -}
> +       skcipher_request_set_tfm(subreq, ctx->enc_tfm);
> +       skcipher_request_set_callback(subreq,
> +                                     skcipher_request_flags(req),
> +                                     NULL, NULL);
> +       skcipher_request_set_crypt(subreq, req->src, req->dst,
> +                                  req->cryptlen, req->iv);
>
> -static int cbc_encrypt(struct skcipher_request *req)
> -{
> -       return crypto_cbc_encrypt_walk(req, cbc_encrypt_one);
> +       return crypto_skcipher_encrypt(subreq);
>  }
>
>  static int cbc_decrypt(struct skcipher_request *req)
> @@ -183,20 +186,27 @@ static int cbc_decrypt(struct skcipher_request *req)
>         return err;
>  }
>
> -static int cbc_init(struct crypto_tfm *tfm)
> +static int cbc_init(struct crypto_skcipher *tfm)
>  {
> -       struct aesbs_cbc_ctx *ctx = crypto_tfm_ctx(tfm);
> +       struct aesbs_cbc_ctx *ctx = crypto_skcipher_ctx(tfm);
> +       unsigned int reqsize;
> +
> +       ctx->enc_tfm = crypto_alloc_skcipher("cbc(aes)", 0, CRYPTO_ALG_ASYNC);
> +       if (IS_ERR(ctx->enc_tfm))
> +               return PTR_ERR(ctx->enc_tfm);
>
> -       ctx->enc_tfm = crypto_alloc_cipher("aes", 0, 0);
> +       reqsize = sizeof(struct skcipher_request);
> +       reqsize += crypto_skcipher_reqsize(ctx->enc_tfm);
> +       crypto_skcipher_set_reqsize(tfm, reqsize);
>
> -       return PTR_ERR_OR_ZERO(ctx->enc_tfm);
> +       return 0;
>  }
>
> -static void cbc_exit(struct crypto_tfm *tfm)
> +static void cbc_exit(struct crypto_skcipher *tfm)
>  {
> -       struct aesbs_cbc_ctx *ctx = crypto_tfm_ctx(tfm);
> +       struct aesbs_cbc_ctx *ctx = crypto_skcipher_ctx(tfm);
>
> -       crypto_free_cipher(ctx->enc_tfm);
> +       crypto_free_skcipher(ctx->enc_tfm);
>  }
>
>  static int aesbs_ctr_setkey_sync(struct crypto_skcipher *tfm, const u8 *in_key,
> @@ -432,8 +442,6 @@ static struct skcipher_alg aes_algs[] = { {
>         .base.cra_ctxsize       = sizeof(struct aesbs_cbc_ctx),
>         .base.cra_module        = THIS_MODULE,
>         .base.cra_flags         = CRYPTO_ALG_INTERNAL,
> -       .base.cra_init          = cbc_init,
> -       .base.cra_exit          = cbc_exit,
>
>         .min_keysize            = AES_MIN_KEY_SIZE,
>         .max_keysize            = AES_MAX_KEY_SIZE,
> @@ -442,6 +450,8 @@ static struct skcipher_alg aes_algs[] = { {
>         .setkey                 = aesbs_cbc_setkey,
>         .encrypt                = cbc_encrypt,
>         .decrypt                = cbc_decrypt,
> +       .init                   = cbc_init,
> +       .exit                   = cbc_exit,
>  }, {
>         .base.cra_name          = "__ctr(aes)",
>         .base.cra_driver_name   = "__ctr-aes-neonbs",
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
