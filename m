Return-Path: <SRS0=PDVT=3I=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63343C33CB1
	for <linux-crypto@archiver.kernel.org>; Sun, 19 Jan 2020 13:51:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B2EF206D7
	for <linux-crypto@archiver.kernel.org>; Sun, 19 Jan 2020 13:51:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="f/ze/z/0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbgASNvk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 19 Jan 2020 08:51:40 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45079 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726860AbgASNvk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 19 Jan 2020 08:51:40 -0500
Received: by mail-wr1-f66.google.com with SMTP id j42so26813259wrj.12
        for <linux-crypto@vger.kernel.org>; Sun, 19 Jan 2020 05:51:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0d7O0sKEgelwqD2tS5pgqyPTlbBN7nszAYfcpFYXNA8=;
        b=f/ze/z/0ddqWoCLLxuiQDM50mBYNEGt/RHTrFyKalvzHNIEX5wB2n7s1ui44Rk3Mqp
         BRLKBhzMr1QuhtKvMjUf7nvQokrcVnEl5UjoX8lC7g0pudHnfhduIQegAsUidUQtXfM8
         Q84XB++o9nk7z9+hnsEoD1Ir5pSffqCocN6YxQfHvGROOQn/WavIaMyL1Ig12myx5QIR
         Zq0RjUCfDZvN3L/bhPVIqAP4ahRtcHz0WpAgKXmXHt8S4RjbILiDia9Jc50eb1G3apVK
         sZ2KrQTQS0tfgqLpWWH1tdkh3hSxmeBv00rrBOc23GNfhG3GstplfLE1q/ZptJfrDxDs
         Mggw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0d7O0sKEgelwqD2tS5pgqyPTlbBN7nszAYfcpFYXNA8=;
        b=DMrDW6DywLSuXcMZAAtm7l24UR18LXAPqk8fPzMxpBUykOFViTf8fhXq1Le9oUMMr4
         Z+v6JL7CWpGjVsSmbz/hlpI6jZUhUIuvmOBxgjM7wGT1xPS99dSO96JLm+LscYZzAVYv
         MA9Od1UsnXRkqF41QFeNRDvpGCN5VokfXyztYKD/n9S5R1Ad8/CvlxozfViL6KOJ24se
         dPfsxyaWVgEwLR9rk2kbeoRXTHQz4BFZIfagoZWMZd8gBSp+XlcdrOc0f8WLivj90OUL
         G+3j/yslS3HlLI3mltk9YWOE+yrpYDdubPuercKBwaB8ZphX56ooLy5YdwvFwDhSUr77
         npCA==
X-Gm-Message-State: APjAAAWW/SrK6+rAXR/YBbGlwbY4tvxTB0FbGTmD1ymjP2PsvKm21+hk
        /FgKf1ILG+/igyVBN6XZN29k3mW2BjUmQiqRzT+xYU+taYc=
X-Google-Smtp-Source: APXvYqxU+++HxL3SlBhHdBoLzzGevH8a3BDPBvrMP9WJ3jnFmCM337zrxAiERzdf1QiKhVFGf5sgSQ5kXIl+vSutnbg=
X-Received: by 2002:a5d:4d0e:: with SMTP id z14mr13715190wrt.208.1579441896981;
 Sun, 19 Jan 2020 05:51:36 -0800 (PST)
MIME-Version: 1.0
References: <20191005091110.12556-1-ard.biesheuvel@linaro.org>
 <20191005122226.23552-1-florian@bezdeka.de> <CAKv+Gu8n0p7fab4Uosv09tDGvfmNbQY+2Sw=QrLB1=aJJmwCJg@mail.gmail.com>
 <8b9ced63-00b3-b2af-d554-1f049276b0a6@bezdeka.de>
In-Reply-To: <8b9ced63-00b3-b2af-d554-1f049276b0a6@bezdeka.de>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Sun, 19 Jan 2020 14:51:26 +0100
Message-ID: <CAKv+Gu9TsaWpgT+SAS9x4bmgbeRZNeP+sKbVRTEcnfdJuisfCA@mail.gmail.com>
Subject: Re: [PATCH v2] crypto: geode-aes - switch to skcipher for cbc(aes) fallback
To:     Florian Bezdeka <florian@bezdeka.de>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, 19 Jan 2020 at 11:02, Florian Bezdeka <florian@bezdeka.de> wrote:
>
> Hi Ard,
>
> Greg picked the non-backported version of the v2 patch and merged it into the
> 4.9, 4.14 and 4.19 stable trees. The commit of the stable-queue repository [1]
> is [2].
>
> Some days later he noticed that the non-backported version is not working as
> expected (failing the build) and he removed the patch from all affected stable
> trees again. The commit id is [3].
>
> What are the right steps to get the backported version of this patch to the
> stable-queue and afterwards to the stable trees?
>

Just send a working version of the patch to stable@vger.kernel.org,
and explain what needed to be changed to make it build correctly.
Look at stable-kernel-rules in the kernel Documentation/ directory for
instructions



> [1] git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
> [2] ab6793e0731db6b937c47faf2ad95c5d9ef9ff86
> [3] 23e4ec1db5b3ba3fb5cb60aac0b9b84e244e0a10
>
> Am 08.10.19 um 13:36 schrieb Ard Biesheuvel:
> > On Sat, 5 Oct 2019 at 14:22, Florian Bezdeka <florian@bezdeka.de> wrote:
> >>
> >> Commit 79c65d179a40e145 ("crypto: cbc - Convert to skcipher") updated
> >> the generic CBC template wrapper from a blkcipher to a skcipher algo,
> >> to get away from the deprecated blkcipher interface. However, as a side
> >> effect, drivers that instantiate CBC transforms using the blkcipher as
> >> a fallback no longer work, since skciphers can wrap blkciphers but not
> >> the other way around. This broke the geode-aes driver.
> >>
> >> So let's fix it by moving to the sync skcipher interface when allocating
> >> the fallback. At the same time, align with the generic API for ECB and
> >> CBC by rejecting inputs that are not a multiple of the AES block size.
> >>
> >> Fixes: 79c65d179a40e145 ("crypto: cbc - Convert to skcipher")
> >> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> >> Signed-off-by: Florian Bezdeka <florian@bezdeka.de>
> >> ---
> >>
> >> Ard, I just followed your instructions and created this patch
> >> for usage on an 4.19 kernel. The patch was successfully tested
> >> on two different Geode systems.
> >>
> >> Can you please review again and forward to the stable tree if the patch
> >> looks OK?
> >>
> >
> > The patch looks fine to me, but we cannot send it to -stable before
> > the mainline version is merged.
> >
> >>  drivers/crypto/geode-aes.c | 57 +++++++++++++++++++++++---------------
> >>  drivers/crypto/geode-aes.h |  2 +-
> >>  2 files changed, 35 insertions(+), 24 deletions(-)
> >>
> >> diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
> >> index eb2a0a73cbed..cc33354d13c1 100644
> >> --- a/drivers/crypto/geode-aes.c
> >> +++ b/drivers/crypto/geode-aes.c
> >> @@ -14,6 +14,7 @@
> >>  #include <linux/spinlock.h>
> >>  #include <crypto/algapi.h>
> >>  #include <crypto/aes.h>
> >> +#include <crypto/skcipher.h>
> >>
> >>  #include <linux/io.h>
> >>  #include <linux/delay.h>
> >> @@ -170,13 +171,15 @@ static int geode_setkey_blk(struct crypto_tfm *tfm, const u8 *key,
> >>         /*
> >>          * The requested key size is not supported by HW, do a fallback
> >>          */
> >> -       op->fallback.blk->base.crt_flags &= ~CRYPTO_TFM_REQ_MASK;
> >> -       op->fallback.blk->base.crt_flags |= (tfm->crt_flags & CRYPTO_TFM_REQ_MASK);
> >> +       crypto_skcipher_clear_flags(op->fallback.blk, CRYPTO_TFM_REQ_MASK);
> >> +       crypto_skcipher_set_flags(op->fallback.blk,
> >> +                                 tfm->crt_flags & CRYPTO_TFM_REQ_MASK);
> >>
> >> -       ret = crypto_blkcipher_setkey(op->fallback.blk, key, len);
> >> +       ret = crypto_skcipher_setkey(op->fallback.blk, key, len);
> >>         if (ret) {
> >>                 tfm->crt_flags &= ~CRYPTO_TFM_RES_MASK;
> >> -               tfm->crt_flags |= (op->fallback.blk->base.crt_flags & CRYPTO_TFM_RES_MASK);
> >> +               tfm->crt_flags |= crypto_skcipher_get_flags(op->fallback.blk) &
> >> +                                 CRYPTO_TFM_RES_MASK;
> >>         }
> >>         return ret;
> >>  }
> >> @@ -185,33 +188,28 @@ static int fallback_blk_dec(struct blkcipher_desc *desc,
> >>                 struct scatterlist *dst, struct scatterlist *src,
> >>                 unsigned int nbytes)
> >>  {
> >> -       unsigned int ret;
> >> -       struct crypto_blkcipher *tfm;
> >>         struct geode_aes_op *op = crypto_blkcipher_ctx(desc->tfm);
> >> +       SKCIPHER_REQUEST_ON_STACK(req, op->fallback.blk);
> >>
> >> -       tfm = desc->tfm;
> >> -       desc->tfm = op->fallback.blk;
> >> -
> >> -       ret = crypto_blkcipher_decrypt_iv(desc, dst, src, nbytes);
> >> +       skcipher_request_set_tfm(req, op->fallback.blk);
> >> +       skcipher_request_set_callback(req, 0, NULL, NULL);
> >> +       skcipher_request_set_crypt(req, src, dst, nbytes, desc->info);
> >>
> >> -       desc->tfm = tfm;
> >> -       return ret;
> >> +       return crypto_skcipher_decrypt(req);
> >>  }
> >> +
> >>  static int fallback_blk_enc(struct blkcipher_desc *desc,
> >>                 struct scatterlist *dst, struct scatterlist *src,
> >>                 unsigned int nbytes)
> >>  {
> >> -       unsigned int ret;
> >> -       struct crypto_blkcipher *tfm;
> >>         struct geode_aes_op *op = crypto_blkcipher_ctx(desc->tfm);
> >> +       SKCIPHER_REQUEST_ON_STACK(req, op->fallback.blk);
> >>
> >> -       tfm = desc->tfm;
> >> -       desc->tfm = op->fallback.blk;
> >> -
> >> -       ret = crypto_blkcipher_encrypt_iv(desc, dst, src, nbytes);
> >> +       skcipher_request_set_tfm(req, op->fallback.blk);
> >> +       skcipher_request_set_callback(req, 0, NULL, NULL);
> >> +       skcipher_request_set_crypt(req, src, dst, nbytes, desc->info);
> >>
> >> -       desc->tfm = tfm;
> >> -       return ret;
> >> +       return crypto_skcipher_encrypt(req);
> >>  }
> >>
> >>  static void
> >> @@ -311,6 +309,9 @@ geode_cbc_decrypt(struct blkcipher_desc *desc,
> >>         struct blkcipher_walk walk;
> >>         int err, ret;
> >>
> >> +       if (nbytes % AES_BLOCK_SIZE)
> >> +               return -EINVAL;
> >> +
> >>         if (unlikely(op->keylen != AES_KEYSIZE_128))
> >>                 return fallback_blk_dec(desc, dst, src, nbytes);
> >>
> >> @@ -343,6 +344,9 @@ geode_cbc_encrypt(struct blkcipher_desc *desc,
> >>         struct blkcipher_walk walk;
> >>         int err, ret;
> >>
> >> +       if (nbytes % AES_BLOCK_SIZE)
> >> +               return -EINVAL;
> >> +
> >>         if (unlikely(op->keylen != AES_KEYSIZE_128))
> >>                 return fallback_blk_enc(desc, dst, src, nbytes);
> >>
> >> @@ -370,8 +374,9 @@ static int fallback_init_blk(struct crypto_tfm *tfm)
> >>         const char *name = crypto_tfm_alg_name(tfm);
> >>         struct geode_aes_op *op = crypto_tfm_ctx(tfm);
> >>
> >> -       op->fallback.blk = crypto_alloc_blkcipher(name, 0,
> >> -                       CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK);
> >> +       op->fallback.blk = crypto_alloc_skcipher(name, 0,
> >> +                                                CRYPTO_ALG_ASYNC |
> >> +                                                CRYPTO_ALG_NEED_FALLBACK);
> >>
> >>         if (IS_ERR(op->fallback.blk)) {
> >>                 printk(KERN_ERR "Error allocating fallback algo %s\n", name);
> >> @@ -385,7 +390,7 @@ static void fallback_exit_blk(struct crypto_tfm *tfm)
> >>  {
> >>         struct geode_aes_op *op = crypto_tfm_ctx(tfm);
> >>
> >> -       crypto_free_blkcipher(op->fallback.blk);
> >> +       crypto_free_skcipher(op->fallback.blk);
> >>         op->fallback.blk = NULL;
> >>  }
> >>
> >> @@ -424,6 +429,9 @@ geode_ecb_decrypt(struct blkcipher_desc *desc,
> >>         struct blkcipher_walk walk;
> >>         int err, ret;
> >>
> >> +       if (nbytes % AES_BLOCK_SIZE)
> >> +               return -EINVAL;
> >> +
> >>         if (unlikely(op->keylen != AES_KEYSIZE_128))
> >>                 return fallback_blk_dec(desc, dst, src, nbytes);
> >>
> >> @@ -454,6 +462,9 @@ geode_ecb_encrypt(struct blkcipher_desc *desc,
> >>         struct blkcipher_walk walk;
> >>         int err, ret;
> >>
> >> +       if (nbytes % AES_BLOCK_SIZE)
> >> +               return -EINVAL;
> >> +
> >>         if (unlikely(op->keylen != AES_KEYSIZE_128))
> >>                 return fallback_blk_enc(desc, dst, src, nbytes);
> >>
> >> diff --git a/drivers/crypto/geode-aes.h b/drivers/crypto/geode-aes.h
> >> index f442ca972e3c..c5763a041bb8 100644
> >> --- a/drivers/crypto/geode-aes.h
> >> +++ b/drivers/crypto/geode-aes.h
> >> @@ -64,7 +64,7 @@ struct geode_aes_op {
> >>         u8 *iv;
> >>
> >>         union {
> >> -               struct crypto_blkcipher *blk;
> >> +               struct crypto_skcipher *blk;
> >>                 struct crypto_cipher *cip;
> >>         } fallback;
> >>         u32 keylen;
> >> --
> >> 2.21.0
> >>
