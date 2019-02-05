Return-Path: <SRS0=AMvw=QM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26087C282CB
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Feb 2019 09:32:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E02E620844
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Feb 2019 09:32:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728655AbfBEJcG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Feb 2019 04:32:06 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:35099 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728644AbfBEJcG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Feb 2019 04:32:06 -0500
Received: by mail-ot1-f66.google.com with SMTP id 81so4650663otj.2
        for <linux-crypto@vger.kernel.org>; Tue, 05 Feb 2019 01:32:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ASusYlIwhTByQErVyyA6eenfPV4WCakCXUQJ/Eobmr4=;
        b=bNBnQs63SqqxqtuNMDTCKhH3p8bbojzfih2pMnSTwGDdntFvEY1iJZqmJmY38mT3ud
         0FvbIYUwcFKcIqGOpdxxFSGm6upOhSIKKiSHmRbTmPN2P1Gra/XjLniE0nGE016ssy2B
         rkrnZIIOJXhSqHhSHZMkLw5pLdtLFtRs3kPtRRxQTRnmdGc9BSQUlDItBPuFZgQ9RV0g
         fDXjRCsaxQ2z0v/0An80HSgp5OSV3hS1hVe6BeSJUPS/TrkD7s+vVrDIME5B7VGuvwg9
         sRPeNZ4u4ZB9iZcifSPejhYFHiIAXY0xbXaLTNU62QRQVhfEiX1bXAZ+Yexx8yqKvycm
         7X3Q==
X-Gm-Message-State: AHQUAubnQVvtZyB+zkOiUB8olBimDPe0SGnk/C3qf8BsIEKnMQcWmpEq
        RVGF7j6osbWgqafsfM70EoRcvzt0x0b6xPQEYV7wBg==
X-Google-Smtp-Source: AHgI3IbDSsENhJWKAvikK7fYg1p2Y9sKxq9dUl7sCoR2/gK082S+1B0B6Iwl31HcsbKxUfWxQyf6CVf+tvJBWJVx/Ys=
X-Received: by 2002:aca:61c3:: with SMTP id v186mr2099168oib.350.1549359124830;
 Tue, 05 Feb 2019 01:32:04 -0800 (PST)
MIME-Version: 1.0
References: <20190201075150.18644-1-ebiggers@kernel.org> <20190201075150.18644-4-ebiggers@kernel.org>
In-Reply-To: <20190201075150.18644-4-ebiggers@kernel.org>
From:   Ondrej Mosnacek <omosnace@redhat.com>
Date:   Tue, 5 Feb 2019 10:31:53 +0100
Message-ID: <CAFqZXNtbbY0KSuJEO+ciGmsWckva4HVLKQ7SDWSm2qTeh3B7mQ@mail.gmail.com>
Subject: Re: [PATCH v2 03/15] crypto: x86/aegis - fix handling chunked inputs
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
> The x86 AEGIS implementations all fail the improved AEAD tests because
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
> Fixes: 1d373d4e8e15 ("crypto: x86 - Add optimized AEGIS implementations")
> Cc: <stable@vger.kernel.org> # v4.18+
> Cc: Ondrej Mosnacek <omosnace@redhat.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>

> ---
>  arch/x86/crypto/aegis128-aesni-glue.c  | 38 ++++++++++----------------
>  arch/x86/crypto/aegis128l-aesni-glue.c | 38 ++++++++++----------------
>  arch/x86/crypto/aegis256-aesni-glue.c  | 38 ++++++++++----------------
>  3 files changed, 45 insertions(+), 69 deletions(-)
>
> diff --git a/arch/x86/crypto/aegis128-aesni-glue.c b/arch/x86/crypto/aegis128-aesni-glue.c
> index 2a356b948720e..3ea71b8718135 100644
> --- a/arch/x86/crypto/aegis128-aesni-glue.c
> +++ b/arch/x86/crypto/aegis128-aesni-glue.c
> @@ -119,31 +119,20 @@ static void crypto_aegis128_aesni_process_ad(
>  }
>
>  static void crypto_aegis128_aesni_process_crypt(
> -               struct aegis_state *state, struct aead_request *req,
> +               struct aegis_state *state, struct skcipher_walk *walk,
>                 const struct aegis_crypt_ops *ops)
>  {
> -       struct skcipher_walk walk;
> -       u8 *src, *dst;
> -       unsigned int chunksize, base;
> -
> -       ops->skcipher_walk_init(&walk, req, false);
> -
> -       while (walk.nbytes) {
> -               src = walk.src.virt.addr;
> -               dst = walk.dst.virt.addr;
> -               chunksize = walk.nbytes;
> -
> -               ops->crypt_blocks(state, chunksize, src, dst);
> -
> -               base = chunksize & ~(AEGIS128_BLOCK_SIZE - 1);
> -               src += base;
> -               dst += base;
> -               chunksize &= AEGIS128_BLOCK_SIZE - 1;
> -
> -               if (chunksize > 0)
> -                       ops->crypt_tail(state, chunksize, src, dst);
> +       while (walk->nbytes >= AEGIS128_BLOCK_SIZE) {
> +               ops->crypt_blocks(state,
> +                                 round_down(walk->nbytes, AEGIS128_BLOCK_SIZE),
> +                                 walk->src.virt.addr, walk->dst.virt.addr);
> +               skcipher_walk_done(walk, walk->nbytes % AEGIS128_BLOCK_SIZE);
> +       }
>
> -               skcipher_walk_done(&walk, 0);
> +       if (walk->nbytes) {
> +               ops->crypt_tail(state, walk->nbytes, walk->src.virt.addr,
> +                               walk->dst.virt.addr);
> +               skcipher_walk_done(walk, 0);
>         }
>  }
>
> @@ -186,13 +175,16 @@ static void crypto_aegis128_aesni_crypt(struct aead_request *req,
>  {
>         struct crypto_aead *tfm = crypto_aead_reqtfm(req);
>         struct aegis_ctx *ctx = crypto_aegis128_aesni_ctx(tfm);
> +       struct skcipher_walk walk;
>         struct aegis_state state;
>
> +       ops->skcipher_walk_init(&walk, req, true);
> +
>         kernel_fpu_begin();
>
>         crypto_aegis128_aesni_init(&state, ctx->key.bytes, req->iv);
>         crypto_aegis128_aesni_process_ad(&state, req->src, req->assoclen);
> -       crypto_aegis128_aesni_process_crypt(&state, req, ops);
> +       crypto_aegis128_aesni_process_crypt(&state, &walk, ops);
>         crypto_aegis128_aesni_final(&state, tag_xor, req->assoclen, cryptlen);
>
>         kernel_fpu_end();
> diff --git a/arch/x86/crypto/aegis128l-aesni-glue.c b/arch/x86/crypto/aegis128l-aesni-glue.c
> index dbe8bb980da15..1b1b39c66c5e2 100644
> --- a/arch/x86/crypto/aegis128l-aesni-glue.c
> +++ b/arch/x86/crypto/aegis128l-aesni-glue.c
> @@ -119,31 +119,20 @@ static void crypto_aegis128l_aesni_process_ad(
>  }
>
>  static void crypto_aegis128l_aesni_process_crypt(
> -               struct aegis_state *state, struct aead_request *req,
> +               struct aegis_state *state, struct skcipher_walk *walk,
>                 const struct aegis_crypt_ops *ops)
>  {
> -       struct skcipher_walk walk;
> -       u8 *src, *dst;
> -       unsigned int chunksize, base;
> -
> -       ops->skcipher_walk_init(&walk, req, false);
> -
> -       while (walk.nbytes) {
> -               src = walk.src.virt.addr;
> -               dst = walk.dst.virt.addr;
> -               chunksize = walk.nbytes;
> -
> -               ops->crypt_blocks(state, chunksize, src, dst);
> -
> -               base = chunksize & ~(AEGIS128L_BLOCK_SIZE - 1);
> -               src += base;
> -               dst += base;
> -               chunksize &= AEGIS128L_BLOCK_SIZE - 1;
> -
> -               if (chunksize > 0)
> -                       ops->crypt_tail(state, chunksize, src, dst);
> +       while (walk->nbytes >= AEGIS128L_BLOCK_SIZE) {
> +               ops->crypt_blocks(state, round_down(walk->nbytes,
> +                                                   AEGIS128L_BLOCK_SIZE),
> +                                 walk->src.virt.addr, walk->dst.virt.addr);
> +               skcipher_walk_done(walk, walk->nbytes % AEGIS128L_BLOCK_SIZE);
> +       }
>
> -               skcipher_walk_done(&walk, 0);
> +       if (walk->nbytes) {
> +               ops->crypt_tail(state, walk->nbytes, walk->src.virt.addr,
> +                               walk->dst.virt.addr);
> +               skcipher_walk_done(walk, 0);
>         }
>  }
>
> @@ -186,13 +175,16 @@ static void crypto_aegis128l_aesni_crypt(struct aead_request *req,
>  {
>         struct crypto_aead *tfm = crypto_aead_reqtfm(req);
>         struct aegis_ctx *ctx = crypto_aegis128l_aesni_ctx(tfm);
> +       struct skcipher_walk walk;
>         struct aegis_state state;
>
> +       ops->skcipher_walk_init(&walk, req, true);
> +
>         kernel_fpu_begin();
>
>         crypto_aegis128l_aesni_init(&state, ctx->key.bytes, req->iv);
>         crypto_aegis128l_aesni_process_ad(&state, req->src, req->assoclen);
> -       crypto_aegis128l_aesni_process_crypt(&state, req, ops);
> +       crypto_aegis128l_aesni_process_crypt(&state, &walk, ops);
>         crypto_aegis128l_aesni_final(&state, tag_xor, req->assoclen, cryptlen);
>
>         kernel_fpu_end();
> diff --git a/arch/x86/crypto/aegis256-aesni-glue.c b/arch/x86/crypto/aegis256-aesni-glue.c
> index 8bebda2de92fe..6227ca3220a05 100644
> --- a/arch/x86/crypto/aegis256-aesni-glue.c
> +++ b/arch/x86/crypto/aegis256-aesni-glue.c
> @@ -119,31 +119,20 @@ static void crypto_aegis256_aesni_process_ad(
>  }
>
>  static void crypto_aegis256_aesni_process_crypt(
> -               struct aegis_state *state, struct aead_request *req,
> +               struct aegis_state *state, struct skcipher_walk *walk,
>                 const struct aegis_crypt_ops *ops)
>  {
> -       struct skcipher_walk walk;
> -       u8 *src, *dst;
> -       unsigned int chunksize, base;
> -
> -       ops->skcipher_walk_init(&walk, req, false);
> -
> -       while (walk.nbytes) {
> -               src = walk.src.virt.addr;
> -               dst = walk.dst.virt.addr;
> -               chunksize = walk.nbytes;
> -
> -               ops->crypt_blocks(state, chunksize, src, dst);
> -
> -               base = chunksize & ~(AEGIS256_BLOCK_SIZE - 1);
> -               src += base;
> -               dst += base;
> -               chunksize &= AEGIS256_BLOCK_SIZE - 1;
> -
> -               if (chunksize > 0)
> -                       ops->crypt_tail(state, chunksize, src, dst);
> +       while (walk->nbytes >= AEGIS256_BLOCK_SIZE) {
> +               ops->crypt_blocks(state,
> +                                 round_down(walk->nbytes, AEGIS256_BLOCK_SIZE),
> +                                 walk->src.virt.addr, walk->dst.virt.addr);
> +               skcipher_walk_done(walk, walk->nbytes % AEGIS256_BLOCK_SIZE);
> +       }
>
> -               skcipher_walk_done(&walk, 0);
> +       if (walk->nbytes) {
> +               ops->crypt_tail(state, walk->nbytes, walk->src.virt.addr,
> +                               walk->dst.virt.addr);
> +               skcipher_walk_done(walk, 0);
>         }
>  }
>
> @@ -186,13 +175,16 @@ static void crypto_aegis256_aesni_crypt(struct aead_request *req,
>  {
>         struct crypto_aead *tfm = crypto_aead_reqtfm(req);
>         struct aegis_ctx *ctx = crypto_aegis256_aesni_ctx(tfm);
> +       struct skcipher_walk walk;
>         struct aegis_state state;
>
> +       ops->skcipher_walk_init(&walk, req, true);
> +
>         kernel_fpu_begin();
>
>         crypto_aegis256_aesni_init(&state, ctx->key, req->iv);
>         crypto_aegis256_aesni_process_ad(&state, req->src, req->assoclen);
> -       crypto_aegis256_aesni_process_crypt(&state, req, ops);
> +       crypto_aegis256_aesni_process_crypt(&state, &walk, ops);
>         crypto_aegis256_aesni_final(&state, tag_xor, req->assoclen, cryptlen);
>
>         kernel_fpu_end();
> --
> 2.20.1
>


-- 
Ondrej Mosnacek <omosnace at redhat dot com>
Associate Software Engineer, Security Technologies
Red Hat, Inc.
