Return-Path: <SRS0=VKJi=YH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91A64ECE587
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 12:39:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57D96217D9
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 12:39:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="QkSQnfrV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730845AbfJNMj1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Oct 2019 08:39:27 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45558 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730800AbfJNMj1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Oct 2019 08:39:27 -0400
Received: by mail-wr1-f68.google.com with SMTP id r5so19502827wrm.12
        for <linux-crypto@vger.kernel.org>; Mon, 14 Oct 2019 05:39:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eC2V7TUqfE9dXmDaFLqNWLvUbdgeVI2lpDkDcOcFK4o=;
        b=QkSQnfrV3qSp3kR58FqzGl6z0gDTRFQkbeKqNk2g5S8eRQuAkrrtAW6jDUNYjoLdUH
         Gd6W1ryWj/gVg3qSkJ7ccpvQxH2E81NfzXGjJoaSE12mJ+GeA82hxjJ+vMcnC6G+QdCp
         S8xrJ2rRKK0n7UMN9oy/twz/sp6BLN9oGmW0gePCYH1gXZaIw0wiuK2a80grFwe67+Ee
         x9DVRSytY7VAb5/LPNnMxFMrfrUjlyPm4uS91qr62s9lOYBHwmjaopYyTjkWmgI5BAd6
         m6MsAw+1deQO3vZ8+QKKQXA0Ad498i6xhguR4kJr54sC2FyHW7+1pTiuHXmRVcud8sAT
         oEgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eC2V7TUqfE9dXmDaFLqNWLvUbdgeVI2lpDkDcOcFK4o=;
        b=X5ldfhXRMO7ThkIewQePMkQzaXPpTd/E8moixNYyX/Vl9i/99XcvXn9725dxJrmIvs
         UbJjJR5KYO7btPg1XfLRkEh9+eEjomzkrA6wrX4YbVioHn1oACGOnhonmXIuRWh2RHMz
         sxK7dl726iSJlqUq98JTO1pXDOlOP9KE7Xn1H5S1m8e8DE4c6mcM7+qxFFwS/yUjr1hj
         dik+K7KA3N+ESmixpBy0X67vJMegbMWJeN/jz6TwnL7FRkkrdlCHTTac53CCJ8VIQl01
         s357bA3X8KKTCtdtHsdkhYcrbFElEh3lGw2iyZ/oRPh1BmaULGjDIjTic3VxyzM2HQZ9
         245w==
X-Gm-Message-State: APjAAAVeg1AVsMeyb3fyMLUCwtKBiFMtyNJ6/rYa0fY4nRmser8hPrRT
        mYFfeSPX4/IHk3a6946MHfOhahNFL1+n9t7pwlf0pw==
X-Google-Smtp-Source: APXvYqylv9LxEi0v1Xlrbkbynt92Ssl3GCIVIsIKf6Zo+1thAWurIPsDhXlZB+oe9ebYc+++m8AW28xqCxvhQ6dNYIs=
X-Received: by 2002:a5d:43c9:: with SMTP id v9mr24980785wrr.200.1571056764115;
 Mon, 14 Oct 2019 05:39:24 -0700 (PDT)
MIME-Version: 1.0
References: <20191013043918.337113-1-ebiggers@kernel.org> <20191013043918.337113-4-ebiggers@kernel.org>
In-Reply-To: <20191013043918.337113-4-ebiggers@kernel.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 14 Oct 2019 14:39:12 +0200
Message-ID: <CAKv+Gu-VQrZPS6+Eo27cpXg9LS2d9MSeBYdd81xkLmF9Lt-s0w@mail.gmail.com>
Subject: Re: [PATCH 3/4] crypto: nx - convert AES-CBC to skcipher API
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        =?UTF-8?Q?Breno_Leit=C3=A3o?= <leitao@debian.org>,
        Nayna Jain <nayna@linux.ibm.com>,
        Paulo Flabiano Smorigo <pfsmorigo@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, 13 Oct 2019 at 06:40, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> Convert the PowerPC Nest (NX) implementation of AES-CBC from the
> deprecated "blkcipher" API to the "skcipher" API.  This is needed in
> order for the blkcipher API to be removed.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
>  drivers/crypto/nx/nx-aes-cbc.c | 78 ++++++++++++++--------------------
>  drivers/crypto/nx/nx.c         | 11 ++---
>  drivers/crypto/nx/nx.h         |  4 +-
>  3 files changed, 41 insertions(+), 52 deletions(-)
>
> diff --git a/drivers/crypto/nx/nx-aes-cbc.c b/drivers/crypto/nx/nx-aes-cbc.c
> index 482a203a9260..92e921eceed7 100644
> --- a/drivers/crypto/nx/nx-aes-cbc.c
> +++ b/drivers/crypto/nx/nx-aes-cbc.c
> @@ -18,11 +18,11 @@
>  #include "nx.h"
>
>
> -static int cbc_aes_nx_set_key(struct crypto_tfm *tfm,
> -                             const u8          *in_key,
> -                             unsigned int       key_len)
> +static int cbc_aes_nx_set_key(struct crypto_skcipher *tfm,
> +                             const u8               *in_key,
> +                             unsigned int            key_len)
>  {
> -       struct nx_crypto_ctx *nx_ctx = crypto_tfm_ctx(tfm);
> +       struct nx_crypto_ctx *nx_ctx = crypto_skcipher_ctx(tfm);
>         struct nx_csbcpb *csbcpb = nx_ctx->csbcpb;
>
>         nx_ctx_init(nx_ctx, HCOP_FC_AES);
> @@ -50,13 +50,11 @@ static int cbc_aes_nx_set_key(struct crypto_tfm *tfm,
>         return 0;
>  }
>
> -static int cbc_aes_nx_crypt(struct blkcipher_desc *desc,
> -                           struct scatterlist    *dst,
> -                           struct scatterlist    *src,
> -                           unsigned int           nbytes,
> -                           int                    enc)
> +static int cbc_aes_nx_crypt(struct skcipher_request *req,
> +                           int                      enc)
>  {
> -       struct nx_crypto_ctx *nx_ctx = crypto_blkcipher_ctx(desc->tfm);
> +       struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
> +       struct nx_crypto_ctx *nx_ctx = crypto_skcipher_ctx(tfm);
>         struct nx_csbcpb *csbcpb = nx_ctx->csbcpb;
>         unsigned long irq_flags;
>         unsigned int processed = 0, to_process;
> @@ -70,9 +68,9 @@ static int cbc_aes_nx_crypt(struct blkcipher_desc *desc,
>                 NX_CPB_FDM(csbcpb) &= ~NX_FDM_ENDE_ENCRYPT;
>
>         do {
> -               to_process = nbytes - processed;
> +               to_process = req->cryptlen - processed;
>
> -               rc = nx_build_sg_lists(nx_ctx, desc->info, dst, src,
> +               rc = nx_build_sg_lists(nx_ctx, req->iv, req->dst, req->src,
>                                        &to_process, processed,
>                                        csbcpb->cpb.aes_cbc.iv);
>                 if (rc)
> @@ -84,56 +82,46 @@ static int cbc_aes_nx_crypt(struct blkcipher_desc *desc,
>                 }
>
>                 rc = nx_hcall_sync(nx_ctx, &nx_ctx->op,
> -                                  desc->flags & CRYPTO_TFM_REQ_MAY_SLEEP);
> +                                  req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP);
>                 if (rc)
>                         goto out;
>
> -               memcpy(desc->info, csbcpb->cpb.aes_cbc.cv, AES_BLOCK_SIZE);
> +               memcpy(req->iv, csbcpb->cpb.aes_cbc.cv, AES_BLOCK_SIZE);
>                 atomic_inc(&(nx_ctx->stats->aes_ops));
>                 atomic64_add(csbcpb->csb.processed_byte_count,
>                              &(nx_ctx->stats->aes_bytes));
>
>                 processed += to_process;
> -       } while (processed < nbytes);
> +       } while (processed < req->cryptlen);
>  out:
>         spin_unlock_irqrestore(&nx_ctx->lock, irq_flags);
>         return rc;
>  }
>
> -static int cbc_aes_nx_encrypt(struct blkcipher_desc *desc,
> -                             struct scatterlist    *dst,
> -                             struct scatterlist    *src,
> -                             unsigned int           nbytes)
> +static int cbc_aes_nx_encrypt(struct skcipher_request *req)
>  {
> -       return cbc_aes_nx_crypt(desc, dst, src, nbytes, 1);
> +       return cbc_aes_nx_crypt(req, 1);
>  }
>
> -static int cbc_aes_nx_decrypt(struct blkcipher_desc *desc,
> -                             struct scatterlist    *dst,
> -                             struct scatterlist    *src,
> -                             unsigned int           nbytes)
> +static int cbc_aes_nx_decrypt(struct skcipher_request *req)
>  {
> -       return cbc_aes_nx_crypt(desc, dst, src, nbytes, 0);
> +       return cbc_aes_nx_crypt(req, 0);
>  }
>
> -struct crypto_alg nx_cbc_aes_alg = {
> -       .cra_name        = "cbc(aes)",
> -       .cra_driver_name = "cbc-aes-nx",
> -       .cra_priority    = 300,
> -       .cra_flags       = CRYPTO_ALG_TYPE_BLKCIPHER,
> -       .cra_blocksize   = AES_BLOCK_SIZE,
> -       .cra_ctxsize     = sizeof(struct nx_crypto_ctx),
> -       .cra_type        = &crypto_blkcipher_type,
> -       .cra_alignmask   = 0xf,
> -       .cra_module      = THIS_MODULE,
> -       .cra_init        = nx_crypto_ctx_aes_cbc_init,
> -       .cra_exit        = nx_crypto_ctx_exit,
> -       .cra_blkcipher = {
> -               .min_keysize = AES_MIN_KEY_SIZE,
> -               .max_keysize = AES_MAX_KEY_SIZE,
> -               .ivsize      = AES_BLOCK_SIZE,
> -               .setkey      = cbc_aes_nx_set_key,
> -               .encrypt     = cbc_aes_nx_encrypt,
> -               .decrypt     = cbc_aes_nx_decrypt,
> -       }
> +struct skcipher_alg nx_cbc_aes_alg = {
> +       .base.cra_name          = "cbc(aes)",
> +       .base.cra_driver_name   = "cbc-aes-nx",
> +       .base.cra_priority      = 300,
> +       .base.cra_blocksize     = AES_BLOCK_SIZE,
> +       .base.cra_ctxsize       = sizeof(struct nx_crypto_ctx),
> +       .base.cra_alignmask     = 0xf,
> +       .base.cra_module        = THIS_MODULE,
> +       .init                   = nx_crypto_ctx_aes_cbc_init,
> +       .exit                   = nx_crypto_ctx_skcipher_exit,
> +       .min_keysize            = AES_MIN_KEY_SIZE,
> +       .max_keysize            = AES_MAX_KEY_SIZE,
> +       .ivsize                 = AES_BLOCK_SIZE,
> +       .setkey                 = cbc_aes_nx_set_key,
> +       .encrypt                = cbc_aes_nx_encrypt,
> +       .decrypt                = cbc_aes_nx_decrypt,
>  };
> diff --git a/drivers/crypto/nx/nx.c b/drivers/crypto/nx/nx.c
> index 4b97081e7486..8e5367776ca0 100644
> --- a/drivers/crypto/nx/nx.c
> +++ b/drivers/crypto/nx/nx.c
> @@ -589,7 +589,7 @@ static int nx_register_algs(void)
>         if (rc)
>                 goto out;
>
> -       rc = nx_register_alg(&nx_cbc_aes_alg, NX_FC_AES, NX_MODE_AES_CBC);
> +       rc = nx_register_skcipher(&nx_cbc_aes_alg, NX_FC_AES, NX_MODE_AES_CBC);
>         if (rc)
>                 goto out_unreg_ecb;
>
> @@ -647,7 +647,7 @@ static int nx_register_algs(void)
>  out_unreg_ctr3686:
>         nx_unregister_alg(&nx_ctr3686_aes_alg, NX_FC_AES, NX_MODE_AES_CTR);
>  out_unreg_cbc:
> -       nx_unregister_alg(&nx_cbc_aes_alg, NX_FC_AES, NX_MODE_AES_CBC);
> +       nx_unregister_skcipher(&nx_cbc_aes_alg, NX_FC_AES, NX_MODE_AES_CBC);
>  out_unreg_ecb:
>         nx_unregister_skcipher(&nx_ecb_aes_alg, NX_FC_AES, NX_MODE_AES_ECB);
>  out:
> @@ -722,9 +722,9 @@ int nx_crypto_ctx_aes_ctr_init(struct crypto_tfm *tfm)
>                                   NX_MODE_AES_CTR);
>  }
>
> -int nx_crypto_ctx_aes_cbc_init(struct crypto_tfm *tfm)
> +int nx_crypto_ctx_aes_cbc_init(struct crypto_skcipher *tfm)
>  {
> -       return nx_crypto_ctx_init(crypto_tfm_ctx(tfm), NX_FC_AES,
> +       return nx_crypto_ctx_init(crypto_skcipher_ctx(tfm), NX_FC_AES,
>                                   NX_MODE_AES_CBC);
>  }
>
> @@ -817,7 +817,8 @@ static int nx_remove(struct vio_dev *viodev)
>                                    NX_FC_AES, NX_MODE_AES_GCM);
>                 nx_unregister_alg(&nx_ctr3686_aes_alg,
>                                   NX_FC_AES, NX_MODE_AES_CTR);
> -               nx_unregister_alg(&nx_cbc_aes_alg, NX_FC_AES, NX_MODE_AES_CBC);
> +               nx_unregister_skcipher(&nx_cbc_aes_alg, NX_FC_AES,
> +                                      NX_MODE_AES_CBC);
>                 nx_unregister_skcipher(&nx_ecb_aes_alg, NX_FC_AES,
>                                        NX_MODE_AES_ECB);
>         }
> diff --git a/drivers/crypto/nx/nx.h b/drivers/crypto/nx/nx.h
> index 1a839ef21c4f..2e1a3e5e65cb 100644
> --- a/drivers/crypto/nx/nx.h
> +++ b/drivers/crypto/nx/nx.h
> @@ -146,7 +146,7 @@ int nx_crypto_ctx_aes_ccm_init(struct crypto_aead *tfm);
>  int nx_crypto_ctx_aes_gcm_init(struct crypto_aead *tfm);
>  int nx_crypto_ctx_aes_xcbc_init(struct crypto_tfm *tfm);
>  int nx_crypto_ctx_aes_ctr_init(struct crypto_tfm *tfm);
> -int nx_crypto_ctx_aes_cbc_init(struct crypto_tfm *tfm);
> +int nx_crypto_ctx_aes_cbc_init(struct crypto_skcipher *tfm);
>  int nx_crypto_ctx_aes_ecb_init(struct crypto_skcipher *tfm);
>  int nx_crypto_ctx_sha_init(struct crypto_tfm *tfm);
>  void nx_crypto_ctx_exit(struct crypto_tfm *tfm);
> @@ -176,7 +176,7 @@ void nx_debugfs_fini(struct nx_crypto_driver *);
>
>  #define NX_PAGE_NUM(x)         ((u64)(x) & 0xfffffffffffff000ULL)
>
> -extern struct crypto_alg nx_cbc_aes_alg;
> +extern struct skcipher_alg nx_cbc_aes_alg;
>  extern struct skcipher_alg nx_ecb_aes_alg;
>  extern struct aead_alg nx_gcm_aes_alg;
>  extern struct aead_alg nx_gcm4106_aes_alg;
> --
> 2.23.0
>
