Return-Path: <SRS0=FyHQ=TQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B132C04AAF
	for <linux-crypto@archiver.kernel.org>; Thu, 16 May 2019 15:56:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 097F020815
	for <linux-crypto@archiver.kernel.org>; Thu, 16 May 2019 15:56:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ExDa/iFL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbfEPP4u (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 May 2019 11:56:50 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:39493 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726314AbfEPP4u (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 May 2019 11:56:50 -0400
Received: by mail-io1-f66.google.com with SMTP id m7so2995459ioa.6
        for <linux-crypto@vger.kernel.org>; Thu, 16 May 2019 08:56:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FYaKPlO96uZTQi618/iwgzsbGXwkeXmM9oGuFHBHd2k=;
        b=ExDa/iFLZrFChicqshxw+f92N+zb05wP6fRKaLegDaRMO9skb2l2hFbpdjTGzJhv1R
         lqgW9MXqTmMI71BRcpOo9+E0/CUdM1yrziK6e3lh1ckx44zk90suojqtWrzN/+vFnNzH
         m9S9JoComMQzcl6JC4gnpCDBUI5xgsi/UdsQRpe8UB8e+eEsdpj73lkwl9AclqWTbZJb
         hgp2H+J/g+K7cFx3dhZhvxrjzw70fdKpGOcD4vNNUAfuvu9MDXUyRXaom2sF6KscwqWt
         NyLMWFgl2z3bJ3pmtsUuLE/DyK7ZIgd13buJf81SOY2G+yFZBFK00YanOHXyxC5JJmv5
         xn3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FYaKPlO96uZTQi618/iwgzsbGXwkeXmM9oGuFHBHd2k=;
        b=Y70O0y184rXpdBdgpq8GPze9xDSD/7sjRj4jYfqZV3bv6e3TdEbhImhq8adJx9bXVx
         6y8m17+4DHA0afwJhG4thaaRN0lnbCiccH1kgXcV8FC+rEmcKgq2lcf2MndS+nFwkBCN
         Ksc05njFb0l6Gpvpfkrwt3zB4v4Syydh9/gsWE1PzOcJ+xoeeCpsloPthcQC5C0qsHOq
         nHr4h3p1P+wlNGvfrPVW6h/omHXkqd0rSaNCe1xb3z1nwAOPP2/miNkHY3ra0Bck0Vba
         qIoQ5bIofs+eDXQ73iDeXJV+i1VUui6tIjScMdfNmwqRKfFX0z8Eoxet5UA/O6Eyla4P
         e5TQ==
X-Gm-Message-State: APjAAAXnbnKsGvDiFANFF2pAQ42Cw+bCws9Lqt1wYHlBKZGkW8Psuu1i
        klJcC52CSDvBM+vyKR6gM2ob7qtB7YD11doqSCRORQ==
X-Google-Smtp-Source: APXvYqzgovPqpKle9HVyyP/AipW4P9e4B6xyQEPMGf+mF9Py0TGlYHc6IsC3kpaU1tm8WV4MHsW3nJ+lqL10btNERBo=
X-Received: by 2002:a5d:93da:: with SMTP id j26mr28021286ioo.170.1558022209453;
 Thu, 16 May 2019 08:56:49 -0700 (PDT)
MIME-Version: 1.0
References: <20190516154002.26246-1-dja@axtens.net>
In-Reply-To: <20190516154002.26246-1-dja@axtens.net>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 16 May 2019 17:56:37 +0200
Message-ID: <CAKv+Gu_eCZMGCKiFSeGvT7-AV-c+vVhH51ZDqHk=bgzYW3B2jw@mail.gmail.com>
Subject: Re: [PATCH] crypto: vmx - ghash: do nosimd fallback manually
To:     Daniel Axtens <dja@axtens.net>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Eric Biggers <ebiggers@kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        marcelo.cerri@canonical.com, Stephan Mueller <smueller@chronox.de>,
        leo.barbosa@canonical.com,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Nayna Jain <nayna@linux.ibm.com>, pfsmorigo@gmail.com,
        leitao@debian.org, gcwilson@linux.ibm.com, omosnacek@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 16 May 2019 at 17:40, Daniel Axtens <dja@axtens.net> wrote:
>
> VMX ghash was using a fallback that did not support interleaving simd
> and nosimd operations, leading to failures in the extended test suite.
>
> If I understood correctly, Eric's suggestion was to use the same
> data format that the generic code uses, allowing us to call into it
> with the same contexts. I wasn't able to get that to work - I think
> there's a very different key structure and data layout being used.
>

The SIMD ghash code uses a 'reflected' version of the key, to work
around bit and byte order peculiarities in the way GHASH uses
GF(2^128). So storing a fallback version of the key (as you are doing
here) is the only feasible approach. (This is described in the Intel
whitepaper that all these implementations [in both OpenSSL and Linux]
are based on [0])

Eric'c suggestion was about sharing the desc not the ctx, since the
desc is what records the ghash state, and so you cannot use two
different ones at the same time without running into inconsistencies
(which is what the bug report was about)

In summary, I think your approach is the only feasible one.

[0] http://software.intel.com/en-us/articles/carry-less-multiplication-and-its-usage-for-computing-the-gcm-mode/

> So instead steal the arm64 approach and perform the fallback
> operations directly if required.
>
> Reported-by: Eric Biggers <ebiggers@google.com>
> Signed-off-by: Daniel Axtens <dja@axtens.net>

Provided that it passes Eric's extended test suite,

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

>
> ---
>
> Tested on BE and LE in qemu-tcg, so more testing would be lovely.
> ---
>  drivers/crypto/vmx/ghash.c | 211 +++++++++++++++----------------------
>  1 file changed, 86 insertions(+), 125 deletions(-)
>
> diff --git a/drivers/crypto/vmx/ghash.c b/drivers/crypto/vmx/ghash.c
> index b5a6883bb09e..14807ac2e3b9 100644
> --- a/drivers/crypto/vmx/ghash.c
> +++ b/drivers/crypto/vmx/ghash.c
> @@ -1,22 +1,14 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /**
>   * GHASH routines supporting VMX instructions on the Power 8
>   *
> - * Copyright (C) 2015 International Business Machines Inc.
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; version 2 only.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software
> - * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + * Copyright (C) 2015, 2019 International Business Machines Inc.
>   *
>   * Author: Marcelo Henrique Cerri <mhcerri@br.ibm.com>
> + *
> + * Extended by Daniel Axtens <dja@axtens.net> to replace the fallback
> + * mechanism. The new approach is based on arm64 code, which is:
> + *   Copyright (C) 2014 - 2018 Linaro Ltd. <ard.biesheuvel@linaro.org>
>   */
>
>  #include <linux/types.h>
> @@ -38,70 +30,25 @@ void gcm_ghash_p8(u64 Xi[2], const u128 htable[16],
>                   const u8 *in, size_t len);
>
>  struct p8_ghash_ctx {
> +       /* key used by vector asm */
>         u128 htable[16];
> -       struct crypto_shash *fallback;
> +       /* key used by software fallback */
> +       be128 key;
>  };
>
>  struct p8_ghash_desc_ctx {
>         u64 shash[2];
>         u8 buffer[GHASH_DIGEST_SIZE];
>         int bytes;
> -       struct shash_desc fallback_desc;
>  };
>
> -static int p8_ghash_init_tfm(struct crypto_tfm *tfm)
> -{
> -       const char *alg = "ghash-generic";
> -       struct crypto_shash *fallback;
> -       struct crypto_shash *shash_tfm = __crypto_shash_cast(tfm);
> -       struct p8_ghash_ctx *ctx = crypto_tfm_ctx(tfm);
> -
> -       fallback = crypto_alloc_shash(alg, 0, CRYPTO_ALG_NEED_FALLBACK);
> -       if (IS_ERR(fallback)) {
> -               printk(KERN_ERR
> -                      "Failed to allocate transformation for '%s': %ld\n",
> -                      alg, PTR_ERR(fallback));
> -               return PTR_ERR(fallback);
> -       }
> -
> -       crypto_shash_set_flags(fallback,
> -                              crypto_shash_get_flags((struct crypto_shash
> -                                                      *) tfm));
> -
> -       /* Check if the descsize defined in the algorithm is still enough. */
> -       if (shash_tfm->descsize < sizeof(struct p8_ghash_desc_ctx)
> -           + crypto_shash_descsize(fallback)) {
> -               printk(KERN_ERR
> -                      "Desc size of the fallback implementation (%s) does not match the expected value: %lu vs %u\n",
> -                      alg,
> -                      shash_tfm->descsize - sizeof(struct p8_ghash_desc_ctx),
> -                      crypto_shash_descsize(fallback));
> -               return -EINVAL;
> -       }
> -       ctx->fallback = fallback;
> -
> -       return 0;
> -}
> -
> -static void p8_ghash_exit_tfm(struct crypto_tfm *tfm)
> -{
> -       struct p8_ghash_ctx *ctx = crypto_tfm_ctx(tfm);
> -
> -       if (ctx->fallback) {
> -               crypto_free_shash(ctx->fallback);
> -               ctx->fallback = NULL;
> -       }
> -}
> -
>  static int p8_ghash_init(struct shash_desc *desc)
>  {
> -       struct p8_ghash_ctx *ctx = crypto_tfm_ctx(crypto_shash_tfm(desc->tfm));
>         struct p8_ghash_desc_ctx *dctx = shash_desc_ctx(desc);
>
>         dctx->bytes = 0;
>         memset(dctx->shash, 0, GHASH_DIGEST_SIZE);
> -       dctx->fallback_desc.tfm = ctx->fallback;
> -       return crypto_shash_init(&dctx->fallback_desc);
> +       return 0;
>  }
>
>  static int p8_ghash_setkey(struct crypto_shash *tfm, const u8 *key,
> @@ -119,7 +66,51 @@ static int p8_ghash_setkey(struct crypto_shash *tfm, const u8 *key,
>         disable_kernel_vsx();
>         pagefault_enable();
>         preempt_enable();
> -       return crypto_shash_setkey(ctx->fallback, key, keylen);
> +
> +       memcpy(&ctx->key, key, GHASH_BLOCK_SIZE);
> +
> +       return 0;
> +}
> +
> +static inline void __ghash_block(struct p8_ghash_ctx *ctx,
> +                                struct p8_ghash_desc_ctx *dctx)
> +{
> +       if (crypto_simd_usable()) {
> +               preempt_disable();
> +               pagefault_disable();
> +               enable_kernel_vsx();
> +               gcm_ghash_p8(dctx->shash, ctx->htable,
> +                               dctx->buffer, GHASH_DIGEST_SIZE);
> +               disable_kernel_vsx();
> +               pagefault_enable();
> +               preempt_enable();
> +       } else {
> +               crypto_xor((u8 *)dctx->shash, dctx->buffer, GHASH_BLOCK_SIZE);
> +               gf128mul_lle((be128 *)dctx->shash, &ctx->key);
> +       }
> +}
> +
> +static inline void __ghash_blocks(struct p8_ghash_ctx *ctx,
> +                                 struct p8_ghash_desc_ctx *dctx,
> +                                 const u8 *src, unsigned int srclen)
> +{
> +       if (crypto_simd_usable()) {
> +               preempt_disable();
> +               pagefault_disable();
> +               enable_kernel_vsx();
> +               gcm_ghash_p8(dctx->shash, ctx->htable,
> +                               src, srclen);
> +               disable_kernel_vsx();
> +               pagefault_enable();
> +               preempt_enable();
> +       } else {
> +               while (srclen >= GHASH_BLOCK_SIZE) {
> +                       crypto_xor((u8 *)dctx->shash, src, GHASH_BLOCK_SIZE);
> +                       gf128mul_lle((be128 *)dctx->shash, &ctx->key);
> +                       srclen -= GHASH_BLOCK_SIZE;
> +                       src += GHASH_BLOCK_SIZE;
> +               }
> +       }
>  }
>
>  static int p8_ghash_update(struct shash_desc *desc,
> @@ -129,49 +120,33 @@ static int p8_ghash_update(struct shash_desc *desc,
>         struct p8_ghash_ctx *ctx = crypto_tfm_ctx(crypto_shash_tfm(desc->tfm));
>         struct p8_ghash_desc_ctx *dctx = shash_desc_ctx(desc);
>
> -       if (!crypto_simd_usable()) {
> -               return crypto_shash_update(&dctx->fallback_desc, src,
> -                                          srclen);
> -       } else {
> -               if (dctx->bytes) {
> -                       if (dctx->bytes + srclen < GHASH_DIGEST_SIZE) {
> -                               memcpy(dctx->buffer + dctx->bytes, src,
> -                                      srclen);
> -                               dctx->bytes += srclen;
> -                               return 0;
> -                       }
> +       if (dctx->bytes) {
> +               if (dctx->bytes + srclen < GHASH_DIGEST_SIZE) {
>                         memcpy(dctx->buffer + dctx->bytes, src,
> -                              GHASH_DIGEST_SIZE - dctx->bytes);
> -                       preempt_disable();
> -                       pagefault_disable();
> -                       enable_kernel_vsx();
> -                       gcm_ghash_p8(dctx->shash, ctx->htable,
> -                                    dctx->buffer, GHASH_DIGEST_SIZE);
> -                       disable_kernel_vsx();
> -                       pagefault_enable();
> -                       preempt_enable();
> -                       src += GHASH_DIGEST_SIZE - dctx->bytes;
> -                       srclen -= GHASH_DIGEST_SIZE - dctx->bytes;
> -                       dctx->bytes = 0;
> -               }
> -               len = srclen & ~(GHASH_DIGEST_SIZE - 1);
> -               if (len) {
> -                       preempt_disable();
> -                       pagefault_disable();
> -                       enable_kernel_vsx();
> -                       gcm_ghash_p8(dctx->shash, ctx->htable, src, len);
> -                       disable_kernel_vsx();
> -                       pagefault_enable();
> -                       preempt_enable();
> -                       src += len;
> -                       srclen -= len;
> -               }
> -               if (srclen) {
> -                       memcpy(dctx->buffer, src, srclen);
> -                       dctx->bytes = srclen;
> +                               srclen);
> +                       dctx->bytes += srclen;
> +                       return 0;
>                 }
> -               return 0;
> +               memcpy(dctx->buffer + dctx->bytes, src,
> +                       GHASH_DIGEST_SIZE - dctx->bytes);
> +
> +               __ghash_block(ctx, dctx);
> +
> +               src += GHASH_DIGEST_SIZE - dctx->bytes;
> +               srclen -= GHASH_DIGEST_SIZE - dctx->bytes;
> +               dctx->bytes = 0;
> +       }
> +       len = srclen & ~(GHASH_DIGEST_SIZE - 1);
> +       if (len) {
> +               __ghash_blocks(ctx, dctx, src, len);
> +               src += len;
> +               srclen -= len;
>         }
> +       if (srclen) {
> +               memcpy(dctx->buffer, src, srclen);
> +               dctx->bytes = srclen;
> +       }
> +       return 0;
>  }
>
>  static int p8_ghash_final(struct shash_desc *desc, u8 *out)
> @@ -180,25 +155,14 @@ static int p8_ghash_final(struct shash_desc *desc, u8 *out)
>         struct p8_ghash_ctx *ctx = crypto_tfm_ctx(crypto_shash_tfm(desc->tfm));
>         struct p8_ghash_desc_ctx *dctx = shash_desc_ctx(desc);
>
> -       if (!crypto_simd_usable()) {
> -               return crypto_shash_final(&dctx->fallback_desc, out);
> -       } else {
> -               if (dctx->bytes) {
> -                       for (i = dctx->bytes; i < GHASH_DIGEST_SIZE; i++)
> -                               dctx->buffer[i] = 0;
> -                       preempt_disable();
> -                       pagefault_disable();
> -                       enable_kernel_vsx();
> -                       gcm_ghash_p8(dctx->shash, ctx->htable,
> -                                    dctx->buffer, GHASH_DIGEST_SIZE);
> -                       disable_kernel_vsx();
> -                       pagefault_enable();
> -                       preempt_enable();
> -                       dctx->bytes = 0;
> -               }
> -               memcpy(out, dctx->shash, GHASH_DIGEST_SIZE);
> -               return 0;
> +       if (dctx->bytes) {
> +               for (i = dctx->bytes; i < GHASH_DIGEST_SIZE; i++)
> +                       dctx->buffer[i] = 0;
> +               __ghash_block(ctx, dctx);
> +               dctx->bytes = 0;
>         }
> +       memcpy(out, dctx->shash, GHASH_DIGEST_SIZE);
> +       return 0;
>  }
>
>  struct shash_alg p8_ghash_alg = {
> @@ -213,11 +177,8 @@ struct shash_alg p8_ghash_alg = {
>                  .cra_name = "ghash",
>                  .cra_driver_name = "p8_ghash",
>                  .cra_priority = 1000,
> -                .cra_flags = CRYPTO_ALG_NEED_FALLBACK,
>                  .cra_blocksize = GHASH_BLOCK_SIZE,
>                  .cra_ctxsize = sizeof(struct p8_ghash_ctx),
>                  .cra_module = THIS_MODULE,
> -                .cra_init = p8_ghash_init_tfm,
> -                .cra_exit = p8_ghash_exit_tfm,
>         },
>  };
> --
> 2.19.1
>
