Return-Path: <SRS0=Hj06=BI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05897C433DF
	for <linux-crypto@archiver.kernel.org>; Wed, 29 Jul 2020 06:17:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CEB0E206D4
	for <linux-crypto@archiver.kernel.org>; Wed, 29 Jul 2020 06:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596003429;
	bh=/2UEGJwg9UFsDp7OaBcyL68RhUM9sPSlDWTt3LQzIHQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=ycW4/z4eZwVVA+mH+U6SrsqiDvTuQ4RvPE0EbGLjRgCTi1ps2Z87wTx9+ih7/dc2Q
	 2qW8takHm+WZXKg517i1cxFOXXeaa0ZMaQODIqFbMO3AZOgtxKcZ7K4MPDJ9nI94xZ
	 VxTW55Zj2HsN9bC3A8vmghAOhjbS+GPwKpTgWbfg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbgG2GRI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 29 Jul 2020 02:17:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:36030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726286AbgG2GRI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 29 Jul 2020 02:17:08 -0400
Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A261206D4
        for <linux-crypto@vger.kernel.org>; Wed, 29 Jul 2020 06:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596003427;
        bh=/2UEGJwg9UFsDp7OaBcyL68RhUM9sPSlDWTt3LQzIHQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=0NWbxkVXJgYg2e6gUTi0dOCdDLRleIAgUmQhTIU5mo/8bBZW0V15nU1CZA+NBBQLK
         kmObIzTiUuVFdX+R4c7gnsuM45iZSrBTvCdxAXL78hcLWyEDo/x9R4gmqFPkaZ7vjV
         hrLXwhHJEbicOVlngeAWOUth7nLcKLlBxhJpgB6g=
Received: by mail-oi1-f180.google.com with SMTP id k6so19792552oij.11
        for <linux-crypto@vger.kernel.org>; Tue, 28 Jul 2020 23:17:07 -0700 (PDT)
X-Gm-Message-State: AOAM5313QEwly7UYzvHEX+s+iQWInk6KTQCJ8mmrttswfibDujMqUBuj
        Bas+5vC2/ExxgzzIPgESCegptHcVoYKcd9ZFOHY=
X-Google-Smtp-Source: ABdhPJzSfMagmeJ74zC12wremv5R+gBYsCKqaJRHfVzlAvrVWcsxQp5V5/s0aH6DiIRFpGOOSAhjWkiVFKFBDBzLGtQ=
X-Received: by 2002:aca:5594:: with SMTP id j142mr6443791oib.33.1596003426802;
 Tue, 28 Jul 2020 23:17:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200728071746.GA22352@gondor.apana.org.au> <E1k0JtB-0006Np-A3@fornost.hmeau.com>
In-Reply-To: <E1k0JtB-0006Np-A3@fornost.hmeau.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 29 Jul 2020 09:16:55 +0300
X-Gmail-Original-Message-ID: <CAMj1kXFj9-+LCbrLT3VSY_nq3MsyRigFhBEkf9BCosH-UJ+YsQ@mail.gmail.com>
Message-ID: <CAMj1kXFj9-+LCbrLT3VSY_nq3MsyRigFhBEkf9BCosH-UJ+YsQ@mail.gmail.com>
Subject: Re: [v3 PATCH 12/31] crypto: arm64/chacha - Add support for chaining
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Stephan Mueller <smueller@chronox.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 28 Jul 2020 at 10:19, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> As it stands chacha cannot do chaining.  That is, it has to handle
> each request as a whole.  This patch adds support for chaining when
> the CRYPTO_TFM_REQ_MORE flag is set.
>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Only state[12] needs to be preserved, since it contains the block
counter. Everything else in the state can be derived from the IV.

So by doing the init unconditionally, and overriding state[12] to the
captured value (if it exists), we can get rid of the redundant copy of
state, which also avoids inconsistencies if IV and state are out of
sync.

> ---
>
>  arch/arm64/crypto/chacha-neon-glue.c |   43 ++++++++++++++++++++++-------------
>  1 file changed, 28 insertions(+), 15 deletions(-)
>
> diff --git a/arch/arm64/crypto/chacha-neon-glue.c b/arch/arm64/crypto/chacha-neon-glue.c
> index af2bbca38e70f..d82c574ddcc00 100644
> --- a/arch/arm64/crypto/chacha-neon-glue.c
> +++ b/arch/arm64/crypto/chacha-neon-glue.c
> @@ -19,10 +19,8 @@
>   * (at your option) any later version.
>   */
>
> -#include <crypto/algapi.h>
>  #include <crypto/internal/chacha.h>
>  #include <crypto/internal/simd.h>
> -#include <crypto/internal/skcipher.h>
>  #include <linux/jump_label.h>
>  #include <linux/kernel.h>
>  #include <linux/module.h>
> @@ -101,16 +99,16 @@ void chacha_crypt_arch(u32 *state, u8 *dst, const u8 *src, unsigned int bytes,
>  }
>  EXPORT_SYMBOL(chacha_crypt_arch);
>
> -static int chacha_neon_stream_xor(struct skcipher_request *req,
> -                                 const struct chacha_ctx *ctx, const u8 *iv)
> +static int chacha_neon_stream_xor(struct skcipher_request *req, int nrounds)
>  {
> +       struct chacha_reqctx *rctx = skcipher_request_ctx(req);
>         struct skcipher_walk walk;
> -       u32 state[16];
> +       u32 *state = rctx->state;
>         int err;
>
> -       err = skcipher_walk_virt(&walk, req, false);
> +       rctx->init = req->base.flags & CRYPTO_TFM_REQ_MORE;
>
> -       chacha_init_generic(state, ctx->key, iv);
> +       err = skcipher_walk_virt(&walk, req, false);
>
>         while (walk.nbytes > 0) {
>                 unsigned int nbytes = walk.nbytes;
> @@ -122,11 +120,11 @@ static int chacha_neon_stream_xor(struct skcipher_request *req,
>                     !crypto_simd_usable()) {
>                         chacha_crypt_generic(state, walk.dst.virt.addr,
>                                              walk.src.virt.addr, nbytes,
> -                                            ctx->nrounds);
> +                                            nrounds);
>                 } else {
>                         kernel_neon_begin();
>                         chacha_doneon(state, walk.dst.virt.addr,
> -                                     walk.src.virt.addr, nbytes, ctx->nrounds);
> +                                     walk.src.virt.addr, nbytes, nrounds);
>                         kernel_neon_end();
>                 }
>                 err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
> @@ -138,26 +136,38 @@ static int chacha_neon_stream_xor(struct skcipher_request *req,
>  static int chacha_neon(struct skcipher_request *req)
>  {
>         struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
> +       struct chacha_reqctx *rctx = skcipher_request_ctx(req);
>         struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
>
> -       return chacha_neon_stream_xor(req, ctx, req->iv);
> +       if (!rctx->init)
> +               chacha_init_generic(rctx->state, ctx->key, req->iv);
> +
> +       return chacha_neon_stream_xor(req, ctx->nrounds);
>  }
>
>  static int xchacha_neon(struct skcipher_request *req)
>  {
>         struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
> +       struct chacha_reqctx *rctx = skcipher_request_ctx(req);
>         struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
> -       struct chacha_ctx subctx;
> -       u32 state[16];
> +       int nrounds = ctx->nrounds;
> +       u32 *state = rctx->state;
>         u8 real_iv[16];
> +       u32 key[8];
> +
> +       if (rctx->init)
> +               goto skip_init;
>
>         chacha_init_generic(state, ctx->key, req->iv);
> -       hchacha_block_arch(state, subctx.key, ctx->nrounds);
> -       subctx.nrounds = ctx->nrounds;
> +       hchacha_block_arch(state, key, nrounds);
>
>         memcpy(&real_iv[0], req->iv + 24, 8);
>         memcpy(&real_iv[8], req->iv + 16, 8);
> -       return chacha_neon_stream_xor(req, &subctx, real_iv);
> +
> +       chacha_init_generic(state, key, real_iv);
> +
> +skip_init:
> +       return chacha_neon_stream_xor(req, nrounds);
>  }
>
>  static struct skcipher_alg algs[] = {
> @@ -174,6 +184,7 @@ static struct skcipher_alg algs[] = {
>                 .ivsize                 = CHACHA_IV_SIZE,
>                 .chunksize              = CHACHA_BLOCK_SIZE,
>                 .walksize               = 5 * CHACHA_BLOCK_SIZE,
> +               .reqsize                = sizeof(struct chacha_reqctx),
>                 .setkey                 = chacha20_setkey,
>                 .encrypt                = chacha_neon,
>                 .decrypt                = chacha_neon,
> @@ -190,6 +201,7 @@ static struct skcipher_alg algs[] = {
>                 .ivsize                 = XCHACHA_IV_SIZE,
>                 .chunksize              = CHACHA_BLOCK_SIZE,
>                 .walksize               = 5 * CHACHA_BLOCK_SIZE,
> +               .reqsize                = sizeof(struct chacha_reqctx),
>                 .setkey                 = chacha20_setkey,
>                 .encrypt                = xchacha_neon,
>                 .decrypt                = xchacha_neon,
> @@ -206,6 +218,7 @@ static struct skcipher_alg algs[] = {
>                 .ivsize                 = XCHACHA_IV_SIZE,
>                 .chunksize              = CHACHA_BLOCK_SIZE,
>                 .walksize               = 5 * CHACHA_BLOCK_SIZE,
> +               .reqsize                = sizeof(struct chacha_reqctx),
>                 .setkey                 = chacha12_setkey,
>                 .encrypt                = xchacha_neon,
>                 .decrypt                = xchacha_neon,
