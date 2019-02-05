Return-Path: <SRS0=AMvw=QM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5666BC282CB
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Feb 2019 09:32:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2244B20844
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Feb 2019 09:32:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728691AbfBEJc1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Feb 2019 04:32:27 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:33535 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbfBEJc1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Feb 2019 04:32:27 -0500
Received: by mail-ot1-f65.google.com with SMTP id i20so4669666otl.0
        for <linux-crypto@vger.kernel.org>; Tue, 05 Feb 2019 01:32:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UonCy7RiIgbC7FIyHHDT3g8u5CLcpWV7rcF/tkRV5bY=;
        b=NvQzgHnJPODpbjfHn0XJrrZxSFv8jgxWLXEMxlgJobPSHkAcOcHKrY0ydWdE7xjnY/
         CSHgxpo2B/UoJUdKyLlUGht3cLtBYs1C7CryFTWtgmBGRDIUQ/1unr6SzOHTOLIjPIC7
         iSv1kCaYPvJ2dxLW+GWkglcNPHuGb4G9ObPnbGpXeLf6iEwlVCTDs3JuAEE1/S9WXAte
         G6O7GIS7sxrPQddJSuOvYSivpp3M0/FFpfbqbKv+jz0b/ebOJZBbJlvU0bNqCAkD/ZFD
         pCI/CIYvHIdhquygRxefZCIBrSZNysEq0GsL628OzpSPNDluZTB3HSFJzXd+PpI5eFW/
         FuQA==
X-Gm-Message-State: AHQUAuYPZYc0irw1sIrIgZ3zxyqe8y5VU/jkNmWhSgJjMZybOkMpnBc2
        FkajxFPDHCvc2oLdbt2FGgsfoNBPfHAUWqyPwXs1mQ==
X-Google-Smtp-Source: AHgI3IbCCO5SrFfVaRXbFOXNy5UgR2JFy6jn8eytk58dV2kfJq42tJFXYlJIExQFCCMsY733Xaexb/TVwnlD6p76OGs=
X-Received: by 2002:a9d:27e3:: with SMTP id c90mr2025113otb.21.1549359146727;
 Tue, 05 Feb 2019 01:32:26 -0800 (PST)
MIME-Version: 1.0
References: <20190201075150.18644-1-ebiggers@kernel.org> <20190201075150.18644-5-ebiggers@kernel.org>
In-Reply-To: <20190201075150.18644-5-ebiggers@kernel.org>
From:   Ondrej Mosnacek <omosnace@redhat.com>
Date:   Tue, 5 Feb 2019 10:32:15 +0100
Message-ID: <CAFqZXNuB1SyhpNoy_hgeAnWioaCiAbzM7j2paEVo6x+pXtUp6g@mail.gmail.com>
Subject: Re: [PATCH v2 04/15] crypto: x86/morus - fix handling chunked inputs
 and MAY_SLEEP
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Feb 1, 2019 at 8:52 AM Eric Biggers <ebiggers@kernel.org> wrote:
> From: Eric Biggers <ebiggers@google.com>
>
> The x86 MORUS implementations all fail the improved AEAD tests because
> they produce the wrong result with some data layouts.  The issue is that
> they assume that if the skcipher_walk API gives 'nbytes' not aligned to
> the walksize (a.k.a. walk.stride), then it is the end of the data.  In
> fact, this can happen before the end.
>
> Also, when the CRYPTO_TFM_REQ_MAY_SLEEP flag is given, they can
> incorrectly sleep in the skcipher_walk_*() functions while preemption
> has been disabled by kernel_fpu_begin().
>
> Fix these bugs.
>
> Fixes: 56e8e57fc3a7 ("crypto: morus - Add common SIMD glue code for MORUS")
> Cc: <stable@vger.kernel.org> # v4.18+
> Cc: Ondrej Mosnacek <omosnace@redhat.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>

> ---
>  arch/x86/crypto/morus1280_glue.c | 40 +++++++++++++-------------------
>  arch/x86/crypto/morus640_glue.c  | 39 ++++++++++++-------------------
>  2 files changed, 31 insertions(+), 48 deletions(-)
>
> diff --git a/arch/x86/crypto/morus1280_glue.c b/arch/x86/crypto/morus1280_glue.c
> index 0dccdda1eb3a1..7e600f8bcdad8 100644
> --- a/arch/x86/crypto/morus1280_glue.c
> +++ b/arch/x86/crypto/morus1280_glue.c
> @@ -85,31 +85,20 @@ static void crypto_morus1280_glue_process_ad(
>
>  static void crypto_morus1280_glue_process_crypt(struct morus1280_state *state,
>                                                 struct morus1280_ops ops,
> -                                               struct aead_request *req)
> +                                               struct skcipher_walk *walk)
>  {
> -       struct skcipher_walk walk;
> -       u8 *cursor_src, *cursor_dst;
> -       unsigned int chunksize, base;
> -
> -       ops.skcipher_walk_init(&walk, req, false);
> -
> -       while (walk.nbytes) {
> -               cursor_src = walk.src.virt.addr;
> -               cursor_dst = walk.dst.virt.addr;
> -               chunksize = walk.nbytes;
> -
> -               ops.crypt_blocks(state, cursor_src, cursor_dst, chunksize);
> -
> -               base = chunksize & ~(MORUS1280_BLOCK_SIZE - 1);
> -               cursor_src += base;
> -               cursor_dst += base;
> -               chunksize &= MORUS1280_BLOCK_SIZE - 1;
> -
> -               if (chunksize > 0)
> -                       ops.crypt_tail(state, cursor_src, cursor_dst,
> -                                      chunksize);
> +       while (walk->nbytes >= MORUS1280_BLOCK_SIZE) {
> +               ops.crypt_blocks(state, walk->src.virt.addr,
> +                                walk->dst.virt.addr,
> +                                round_down(walk->nbytes,
> +                                           MORUS1280_BLOCK_SIZE));
> +               skcipher_walk_done(walk, walk->nbytes % MORUS1280_BLOCK_SIZE);
> +       }
>
> -               skcipher_walk_done(&walk, 0);
> +       if (walk->nbytes) {
> +               ops.crypt_tail(state, walk->src.virt.addr, walk->dst.virt.addr,
> +                              walk->nbytes);
> +               skcipher_walk_done(walk, 0);
>         }
>  }
>
> @@ -147,12 +136,15 @@ static void crypto_morus1280_glue_crypt(struct aead_request *req,
>         struct crypto_aead *tfm = crypto_aead_reqtfm(req);
>         struct morus1280_ctx *ctx = crypto_aead_ctx(tfm);
>         struct morus1280_state state;
> +       struct skcipher_walk walk;
> +
> +       ops.skcipher_walk_init(&walk, req, true);
>
>         kernel_fpu_begin();
>
>         ctx->ops->init(&state, &ctx->key, req->iv);
>         crypto_morus1280_glue_process_ad(&state, ctx->ops, req->src, req->assoclen);
> -       crypto_morus1280_glue_process_crypt(&state, ops, req);
> +       crypto_morus1280_glue_process_crypt(&state, ops, &walk);
>         ctx->ops->final(&state, tag_xor, req->assoclen, cryptlen);
>
>         kernel_fpu_end();
> diff --git a/arch/x86/crypto/morus640_glue.c b/arch/x86/crypto/morus640_glue.c
> index 7b58fe4d9bd1a..cb3a817320160 100644
> --- a/arch/x86/crypto/morus640_glue.c
> +++ b/arch/x86/crypto/morus640_glue.c
> @@ -85,31 +85,19 @@ static void crypto_morus640_glue_process_ad(
>
>  static void crypto_morus640_glue_process_crypt(struct morus640_state *state,
>                                                struct morus640_ops ops,
> -                                              struct aead_request *req)
> +                                              struct skcipher_walk *walk)
>  {
> -       struct skcipher_walk walk;
> -       u8 *cursor_src, *cursor_dst;
> -       unsigned int chunksize, base;
> -
> -       ops.skcipher_walk_init(&walk, req, false);
> -
> -       while (walk.nbytes) {
> -               cursor_src = walk.src.virt.addr;
> -               cursor_dst = walk.dst.virt.addr;
> -               chunksize = walk.nbytes;
> -
> -               ops.crypt_blocks(state, cursor_src, cursor_dst, chunksize);
> -
> -               base = chunksize & ~(MORUS640_BLOCK_SIZE - 1);
> -               cursor_src += base;
> -               cursor_dst += base;
> -               chunksize &= MORUS640_BLOCK_SIZE - 1;
> -
> -               if (chunksize > 0)
> -                       ops.crypt_tail(state, cursor_src, cursor_dst,
> -                                      chunksize);
> +       while (walk->nbytes >= MORUS640_BLOCK_SIZE) {
> +               ops.crypt_blocks(state, walk->src.virt.addr,
> +                                walk->dst.virt.addr,
> +                                round_down(walk->nbytes, MORUS640_BLOCK_SIZE));
> +               skcipher_walk_done(walk, walk->nbytes % MORUS640_BLOCK_SIZE);
> +       }
>
> -               skcipher_walk_done(&walk, 0);
> +       if (walk->nbytes) {
> +               ops.crypt_tail(state, walk->src.virt.addr, walk->dst.virt.addr,
> +                              walk->nbytes);
> +               skcipher_walk_done(walk, 0);
>         }
>  }
>
> @@ -143,12 +131,15 @@ static void crypto_morus640_glue_crypt(struct aead_request *req,
>         struct crypto_aead *tfm = crypto_aead_reqtfm(req);
>         struct morus640_ctx *ctx = crypto_aead_ctx(tfm);
>         struct morus640_state state;
> +       struct skcipher_walk walk;
> +
> +       ops.skcipher_walk_init(&walk, req, true);
>
>         kernel_fpu_begin();
>
>         ctx->ops->init(&state, &ctx->key, req->iv);
>         crypto_morus640_glue_process_ad(&state, ctx->ops, req->src, req->assoclen);
> -       crypto_morus640_glue_process_crypt(&state, ops, req);
> +       crypto_morus640_glue_process_crypt(&state, ops, &walk);
>         ctx->ops->final(&state, tag_xor, req->assoclen, cryptlen);
>
>         kernel_fpu_end();
> --
> 2.20.1
>


-- 
Ondrej Mosnacek <omosnace at redhat dot com>
Associate Software Engineer, Security Technologies
Red Hat, Inc.
