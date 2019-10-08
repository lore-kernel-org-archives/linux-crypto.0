Return-Path: <SRS0=AFir=YB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0342C4360C
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Oct 2019 11:37:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69D8420673
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Oct 2019 11:37:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XtoNKprI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730618AbfJHLhA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 8 Oct 2019 07:37:00 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37523 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730561AbfJHLhA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 8 Oct 2019 07:37:00 -0400
Received: by mail-wr1-f67.google.com with SMTP id p14so18060478wro.4
        for <linux-crypto@vger.kernel.org>; Tue, 08 Oct 2019 04:36:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=USPgXhsJ5/qd/fTdRAnjSJ/p0FepKhUYaM+9o3VonSM=;
        b=XtoNKprIfefX/QXPuKcp3SW62O9ICkKvBzU/5sBfgxj3xFO/pd/4ry88dWCQIHJ6QG
         pl1K7QYkuT3/rd4FJyi45+S1noFPyMcGgaWc3+5aD62BKbnMBEO1gIeCbs1dMNtZkGQ/
         VjOC1hs5VrkT5JuCSURxMUWX+FP8u6IgQ5TEOTaoUOW7UjTnSW6e/+i6j1IKGFgdp0ck
         IcKwuAn8Uxki+E2elp1mL4pn979rHCcFhhDkNHYAlDlSfscXrTtgHip9Th6On+9yn2d2
         NU+dsw7qTEtsaAhsMUgkzpAAhScCZjY7XF2UCwOUxqRYwWtbFO2xZzumj0s6OXAJqitt
         659w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=USPgXhsJ5/qd/fTdRAnjSJ/p0FepKhUYaM+9o3VonSM=;
        b=Sv97GaMBw63GigJ0GnSmldQY/TNXXyggiEbT6hR/0kQbjwh8YufI4034m0GBEkGa2I
         0y5GWPCQTiExV9g1xJpj5LFWFlyL3d5bF9jHalP3l4bcOwWvUcUcxoGmERLtVjfBG64N
         Guz4Ij8CaAiwAGq1fnmN3V05Y4U2k/Vsl6P5VZoPIcbB3xvn4Ua+GTmfJkRL8P1G3bLB
         RZwD9skcQ7ybp7BZvk3A/p7heLLKxvTEsb6EobNhyPn5b+LU89i5ZtoWID9TRh/rT0CF
         RLDr19yndgUelCgrn5rhmqzC66im+Y9l9UacPCyGxVCEXr8hUiGd41y41+TW9wS+Foeo
         iqag==
X-Gm-Message-State: APjAAAVOELZgJVHff4v7hBHTd1VdgxRttTH4mbL57xK2MX7xMYkKNmXD
        eCK0dmUvSXwFDv3ftqJsBK36/5iA2KUcWuzhbmBmaMw3J8Q=
X-Google-Smtp-Source: APXvYqzXIYVk/vwsA37Yy+kHV7fmb0TpWU3J5pX5ZHa6B/ph6sgktpjIqT1ltFOwCUMk1r4gXOFzRugDByPyx8jPLHY=
X-Received: by 2002:a5d:61c8:: with SMTP id q8mr20362397wrv.325.1570534618232;
 Tue, 08 Oct 2019 04:36:58 -0700 (PDT)
MIME-Version: 1.0
References: <20191005091110.12556-1-ard.biesheuvel@linaro.org> <20191005122226.23552-1-florian@bezdeka.de>
In-Reply-To: <20191005122226.23552-1-florian@bezdeka.de>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Tue, 8 Oct 2019 13:36:47 +0200
Message-ID: <CAKv+Gu8n0p7fab4Uosv09tDGvfmNbQY+2Sw=QrLB1=aJJmwCJg@mail.gmail.com>
Subject: Re: [PATCH v2] crypto: geode-aes - switch to skcipher for cbc(aes) fallback
To:     Florian Bezdeka <florian@bezdeka.de>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, 5 Oct 2019 at 14:22, Florian Bezdeka <florian@bezdeka.de> wrote:
>
> Commit 79c65d179a40e145 ("crypto: cbc - Convert to skcipher") updated
> the generic CBC template wrapper from a blkcipher to a skcipher algo,
> to get away from the deprecated blkcipher interface. However, as a side
> effect, drivers that instantiate CBC transforms using the blkcipher as
> a fallback no longer work, since skciphers can wrap blkciphers but not
> the other way around. This broke the geode-aes driver.
>
> So let's fix it by moving to the sync skcipher interface when allocating
> the fallback. At the same time, align with the generic API for ECB and
> CBC by rejecting inputs that are not a multiple of the AES block size.
>
> Fixes: 79c65d179a40e145 ("crypto: cbc - Convert to skcipher")
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Signed-off-by: Florian Bezdeka <florian@bezdeka.de>
> ---
>
> Ard, I just followed your instructions and created this patch
> for usage on an 4.19 kernel. The patch was successfully tested
> on two different Geode systems.
>
> Can you please review again and forward to the stable tree if the patch
> looks OK?
>

The patch looks fine to me, but we cannot send it to -stable before
the mainline version is merged.

>  drivers/crypto/geode-aes.c | 57 +++++++++++++++++++++++---------------
>  drivers/crypto/geode-aes.h |  2 +-
>  2 files changed, 35 insertions(+), 24 deletions(-)
>
> diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
> index eb2a0a73cbed..cc33354d13c1 100644
> --- a/drivers/crypto/geode-aes.c
> +++ b/drivers/crypto/geode-aes.c
> @@ -14,6 +14,7 @@
>  #include <linux/spinlock.h>
>  #include <crypto/algapi.h>
>  #include <crypto/aes.h>
> +#include <crypto/skcipher.h>
>
>  #include <linux/io.h>
>  #include <linux/delay.h>
> @@ -170,13 +171,15 @@ static int geode_setkey_blk(struct crypto_tfm *tfm, const u8 *key,
>         /*
>          * The requested key size is not supported by HW, do a fallback
>          */
> -       op->fallback.blk->base.crt_flags &= ~CRYPTO_TFM_REQ_MASK;
> -       op->fallback.blk->base.crt_flags |= (tfm->crt_flags & CRYPTO_TFM_REQ_MASK);
> +       crypto_skcipher_clear_flags(op->fallback.blk, CRYPTO_TFM_REQ_MASK);
> +       crypto_skcipher_set_flags(op->fallback.blk,
> +                                 tfm->crt_flags & CRYPTO_TFM_REQ_MASK);
>
> -       ret = crypto_blkcipher_setkey(op->fallback.blk, key, len);
> +       ret = crypto_skcipher_setkey(op->fallback.blk, key, len);
>         if (ret) {
>                 tfm->crt_flags &= ~CRYPTO_TFM_RES_MASK;
> -               tfm->crt_flags |= (op->fallback.blk->base.crt_flags & CRYPTO_TFM_RES_MASK);
> +               tfm->crt_flags |= crypto_skcipher_get_flags(op->fallback.blk) &
> +                                 CRYPTO_TFM_RES_MASK;
>         }
>         return ret;
>  }
> @@ -185,33 +188,28 @@ static int fallback_blk_dec(struct blkcipher_desc *desc,
>                 struct scatterlist *dst, struct scatterlist *src,
>                 unsigned int nbytes)
>  {
> -       unsigned int ret;
> -       struct crypto_blkcipher *tfm;
>         struct geode_aes_op *op = crypto_blkcipher_ctx(desc->tfm);
> +       SKCIPHER_REQUEST_ON_STACK(req, op->fallback.blk);
>
> -       tfm = desc->tfm;
> -       desc->tfm = op->fallback.blk;
> -
> -       ret = crypto_blkcipher_decrypt_iv(desc, dst, src, nbytes);
> +       skcipher_request_set_tfm(req, op->fallback.blk);
> +       skcipher_request_set_callback(req, 0, NULL, NULL);
> +       skcipher_request_set_crypt(req, src, dst, nbytes, desc->info);
>
> -       desc->tfm = tfm;
> -       return ret;
> +       return crypto_skcipher_decrypt(req);
>  }
> +
>  static int fallback_blk_enc(struct blkcipher_desc *desc,
>                 struct scatterlist *dst, struct scatterlist *src,
>                 unsigned int nbytes)
>  {
> -       unsigned int ret;
> -       struct crypto_blkcipher *tfm;
>         struct geode_aes_op *op = crypto_blkcipher_ctx(desc->tfm);
> +       SKCIPHER_REQUEST_ON_STACK(req, op->fallback.blk);
>
> -       tfm = desc->tfm;
> -       desc->tfm = op->fallback.blk;
> -
> -       ret = crypto_blkcipher_encrypt_iv(desc, dst, src, nbytes);
> +       skcipher_request_set_tfm(req, op->fallback.blk);
> +       skcipher_request_set_callback(req, 0, NULL, NULL);
> +       skcipher_request_set_crypt(req, src, dst, nbytes, desc->info);
>
> -       desc->tfm = tfm;
> -       return ret;
> +       return crypto_skcipher_encrypt(req);
>  }
>
>  static void
> @@ -311,6 +309,9 @@ geode_cbc_decrypt(struct blkcipher_desc *desc,
>         struct blkcipher_walk walk;
>         int err, ret;
>
> +       if (nbytes % AES_BLOCK_SIZE)
> +               return -EINVAL;
> +
>         if (unlikely(op->keylen != AES_KEYSIZE_128))
>                 return fallback_blk_dec(desc, dst, src, nbytes);
>
> @@ -343,6 +344,9 @@ geode_cbc_encrypt(struct blkcipher_desc *desc,
>         struct blkcipher_walk walk;
>         int err, ret;
>
> +       if (nbytes % AES_BLOCK_SIZE)
> +               return -EINVAL;
> +
>         if (unlikely(op->keylen != AES_KEYSIZE_128))
>                 return fallback_blk_enc(desc, dst, src, nbytes);
>
> @@ -370,8 +374,9 @@ static int fallback_init_blk(struct crypto_tfm *tfm)
>         const char *name = crypto_tfm_alg_name(tfm);
>         struct geode_aes_op *op = crypto_tfm_ctx(tfm);
>
> -       op->fallback.blk = crypto_alloc_blkcipher(name, 0,
> -                       CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK);
> +       op->fallback.blk = crypto_alloc_skcipher(name, 0,
> +                                                CRYPTO_ALG_ASYNC |
> +                                                CRYPTO_ALG_NEED_FALLBACK);
>
>         if (IS_ERR(op->fallback.blk)) {
>                 printk(KERN_ERR "Error allocating fallback algo %s\n", name);
> @@ -385,7 +390,7 @@ static void fallback_exit_blk(struct crypto_tfm *tfm)
>  {
>         struct geode_aes_op *op = crypto_tfm_ctx(tfm);
>
> -       crypto_free_blkcipher(op->fallback.blk);
> +       crypto_free_skcipher(op->fallback.blk);
>         op->fallback.blk = NULL;
>  }
>
> @@ -424,6 +429,9 @@ geode_ecb_decrypt(struct blkcipher_desc *desc,
>         struct blkcipher_walk walk;
>         int err, ret;
>
> +       if (nbytes % AES_BLOCK_SIZE)
> +               return -EINVAL;
> +
>         if (unlikely(op->keylen != AES_KEYSIZE_128))
>                 return fallback_blk_dec(desc, dst, src, nbytes);
>
> @@ -454,6 +462,9 @@ geode_ecb_encrypt(struct blkcipher_desc *desc,
>         struct blkcipher_walk walk;
>         int err, ret;
>
> +       if (nbytes % AES_BLOCK_SIZE)
> +               return -EINVAL;
> +
>         if (unlikely(op->keylen != AES_KEYSIZE_128))
>                 return fallback_blk_enc(desc, dst, src, nbytes);
>
> diff --git a/drivers/crypto/geode-aes.h b/drivers/crypto/geode-aes.h
> index f442ca972e3c..c5763a041bb8 100644
> --- a/drivers/crypto/geode-aes.h
> +++ b/drivers/crypto/geode-aes.h
> @@ -64,7 +64,7 @@ struct geode_aes_op {
>         u8 *iv;
>
>         union {
> -               struct crypto_blkcipher *blk;
> +               struct crypto_skcipher *blk;
>                 struct crypto_cipher *cip;
>         } fallback;
>         u32 keylen;
> --
> 2.21.0
>
