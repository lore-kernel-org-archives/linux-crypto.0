Return-Path: <SRS0=VKJi=YH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26F4EC4CECE
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 08:45:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB05E20854
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 08:45:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="vXOcZ0qo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730459AbfJNIpj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Oct 2019 04:45:39 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36616 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730439AbfJNIpj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Oct 2019 04:45:39 -0400
Received: by mail-wm1-f65.google.com with SMTP id m18so15861440wmc.1
        for <linux-crypto@vger.kernel.org>; Mon, 14 Oct 2019 01:45:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uVYIqHFk6pqF0L8IAIiW8QpGIEfD0iwMEBW0v2wR2Ew=;
        b=vXOcZ0qo3ubBJOq7IPO+xvVDcbViQA6XUpngkOW8vQOYZfczEkuPappqtHsb08cCa4
         dRmJSnnycuU9YwmAZgIak4ORQEQoSyuies90wtrxxdd+cddpyNWB610ra6bE76XPEQay
         pRs+cbC9MaYkxYMMLFBlW/DDnJc8yUQT9JDWXwNM7kyzJ5g+WkpIjcveURcNEEn1noO+
         /j0BUrgQ3QrE+Nop392H/IKslZwalOx7txNzNNK2zi95HGaMyOHuYCXe9+Swi14dTxCI
         3InmmB86X2SQSrQj67+hx7sE3NuLwHT6FxEtD+qmyi1Mi9Mp7NlGGBu+EflS8OQFbX7r
         FRFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uVYIqHFk6pqF0L8IAIiW8QpGIEfD0iwMEBW0v2wR2Ew=;
        b=Q9ppMTumX44ySIl5IbjsGu5yjewiOTrUQiAAZUY+2OCkS7vc4ZIi3O/kzIFLrmrpbP
         tpKa11O2sFgg2vbZLmua2RL59seVUV8FXTXc4HBLzggcKO9AfHh7zO7vlimQ2aTGSl23
         dMIsa3TCsvYbVtFejpdadNp1JlNYBCM3yeMBUlhv43GRJqob5uJJKBtV2qT3pip82MFl
         p3eBm8JxBXIrGmiHqnELVdELByicrmiPpU9IXfpFXZIrq/hxM/veZLjTSkn6+yWYDm5R
         l65RiwAAIDO+l1FFuHaeu44v0VICepVxYRcw3AfSmSLsayNajPJo7xNRBKJTX+g4/ofN
         0SjA==
X-Gm-Message-State: APjAAAUjmHBmUY5fBSPqcs+Meggr+9b1t6KF0ChmlcU44qQLlRf//jPs
        xBfrkE1eFVeB8b9rtY/4KJTzMOdojvrFRBlWvpVveLmJ2Fo=
X-Google-Smtp-Source: APXvYqwvrJq4D607owEPorcXHJPbN6+7URSul11bC+gNcL+Blvw8iFik8pIlleahykc6cE+9cDM84Y/0NVodL7A6dnY=
X-Received: by 2002:a1c:a651:: with SMTP id p78mr14247375wme.53.1571042733703;
 Mon, 14 Oct 2019 01:45:33 -0700 (PDT)
MIME-Version: 1.0
References: <20191012022946.185320-1-ebiggers@kernel.org>
In-Reply-To: <20191012022946.185320-1-ebiggers@kernel.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 14 Oct 2019 10:45:22 +0200
Message-ID: <CAKv+Gu9qS838o+jJv3My=ibvfgE=3yeVbH5SB=yraKb3S7sV6A@mail.gmail.com>
Subject: Re: [PATCH] crypto: powerpc - convert SPE AES algorithms to skcipher API
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Markus Stockhausen <stockhausen@collogia.de>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Eric,

On Sat, 12 Oct 2019 at 04:32, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> Convert the glue code for the PowerPC SPE implementations of AES-ECB,
> AES-CBC, AES-CTR, and AES-XTS from the deprecated "blkcipher" API to the
> "skcipher" API.
>
> Tested with:
>
>         export ARCH=powerpc CROSS_COMPILE=powerpc-linux-gnu-
>         make mpc85xx_defconfig
>         cat >> .config << EOF
>         # CONFIG_MODULES is not set
>         # CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
>         CONFIG_DEBUG_KERNEL=y
>         CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y
>         CONFIG_CRYPTO_AES=y
>         CONFIG_CRYPTO_CBC=y
>         CONFIG_CRYPTO_CTR=y
>         CONFIG_CRYPTO_ECB=y
>         CONFIG_CRYPTO_XTS=y
>         CONFIG_CRYPTO_AES_PPC_SPE=y
>         EOF
>         make olddefconfig
>         make -j32
>         qemu-system-ppc -M mpc8544ds -cpu e500 -nographic \
>                 -kernel arch/powerpc/boot/zImage \
>                 -append cryptomgr.fuzz_iterations=1000
>
> Note that xts-ppc-spe still fails the comparison tests due to the lack
> of ciphertext stealing support.  This is not addressed by this patch.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  arch/powerpc/crypto/aes-spe-glue.c | 416 +++++++++++++----------------
>  crypto/Kconfig                     |   1 +
>  2 files changed, 186 insertions(+), 231 deletions(-)
>
> diff --git a/arch/powerpc/crypto/aes-spe-glue.c b/arch/powerpc/crypto/aes-spe-glue.c
> index 3a4ca7d32477..374e3e51e998 100644
> --- a/arch/powerpc/crypto/aes-spe-glue.c
> +++ b/arch/powerpc/crypto/aes-spe-glue.c
> @@ -17,6 +17,7 @@
>  #include <asm/byteorder.h>
>  #include <asm/switch_to.h>
>  #include <crypto/algapi.h>
> +#include <crypto/internal/skcipher.h>
>  #include <crypto/xts.h>
>
>  /*
> @@ -86,17 +87,13 @@ static void spe_end(void)
>         preempt_enable();
>  }
>
> -static int ppc_aes_setkey(struct crypto_tfm *tfm, const u8 *in_key,
> -               unsigned int key_len)
> +static int expand_key(struct ppc_aes_ctx *ctx,
> +                     const u8 *in_key, unsigned int key_len)
>  {
> -       struct ppc_aes_ctx *ctx = crypto_tfm_ctx(tfm);
> -
>         if (key_len != AES_KEYSIZE_128 &&
>             key_len != AES_KEYSIZE_192 &&
> -           key_len != AES_KEYSIZE_256) {
> -               tfm->crt_flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
> +           key_len != AES_KEYSIZE_256)
>                 return -EINVAL;
> -       }
>
>         switch (key_len) {
>         case AES_KEYSIZE_128:
> @@ -114,17 +111,40 @@ static int ppc_aes_setkey(struct crypto_tfm *tfm, const u8 *in_key,
>         }
>
>         ppc_generate_decrypt_key(ctx->key_dec, ctx->key_enc, key_len);
> +       return 0;
> +}
>
> +static int ppc_aes_setkey(struct crypto_tfm *tfm, const u8 *in_key,
> +               unsigned int key_len)
> +{
> +       struct ppc_aes_ctx *ctx = crypto_tfm_ctx(tfm);
> +
> +       if (expand_key(ctx, in_key, key_len) != 0) {
> +               tfm->crt_flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
> +               return -EINVAL;
> +       }
> +       return 0;
> +}
> +
> +static int ppc_aes_setkey_skcipher(struct crypto_skcipher *tfm,
> +                                  const u8 *in_key, unsigned int key_len)
> +{
> +       struct ppc_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
> +
> +       if (expand_key(ctx, in_key, key_len) != 0) {
> +               crypto_skcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
> +               return -EINVAL;
> +       }
>         return 0;
>  }
>
> -static int ppc_xts_setkey(struct crypto_tfm *tfm, const u8 *in_key,
> +static int ppc_xts_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
>                    unsigned int key_len)
>  {
> -       struct ppc_xts_ctx *ctx = crypto_tfm_ctx(tfm);
> +       struct ppc_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
>         int err;
>
> -       err = xts_check_key(tfm, in_key, key_len);
> +       err = xts_verify_key(tfm, in_key, key_len);
>         if (err)
>                 return err;
>
> @@ -133,7 +153,7 @@ static int ppc_xts_setkey(struct crypto_tfm *tfm, const u8 *in_key,
>         if (key_len != AES_KEYSIZE_128 &&
>             key_len != AES_KEYSIZE_192 &&
>             key_len != AES_KEYSIZE_256) {
> -               tfm->crt_flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
> +               crypto_skcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
>                 return -EINVAL;
>         }
>
> @@ -178,208 +198,154 @@ static void ppc_aes_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
>         spe_end();
>  }
>
> -static int ppc_ecb_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
> -                          struct scatterlist *src, unsigned int nbytes)
> +static int ppc_ecb_crypt(struct skcipher_request *req, bool enc)
>  {
> -       struct ppc_aes_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
> -       struct blkcipher_walk walk;
> -       unsigned int ubytes;
> +       struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
> +       struct ppc_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
> +       struct skcipher_walk walk;
> +       unsigned int nbytes;
>         int err;
>
> -       desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
> -       blkcipher_walk_init(&walk, dst, src, nbytes);
> -       err = blkcipher_walk_virt(desc, &walk);
> +       err = skcipher_walk_virt(&walk, req, false);
>

Shouldn't atomic be set to 'true' here to retain the non-sleeping behavior?

> -       while ((nbytes = walk.nbytes)) {
> -               ubytes = nbytes > MAX_BYTES ?
> -                        nbytes - MAX_BYTES : nbytes & (AES_BLOCK_SIZE - 1);
> -               nbytes -= ubytes;
> +       while ((nbytes = walk.nbytes) != 0) {
> +               nbytes = min_t(unsigned int, nbytes, MAX_BYTES);
> +               nbytes = round_down(nbytes, AES_BLOCK_SIZE);
>
>                 spe_begin();
> -               ppc_encrypt_ecb(walk.dst.virt.addr, walk.src.virt.addr,
> -                               ctx->key_enc, ctx->rounds, nbytes);
> +               if (enc)
> +                       ppc_encrypt_ecb(walk.dst.virt.addr, walk.src.virt.addr,
> +                                       ctx->key_enc, ctx->rounds, nbytes);
> +               else
> +                       ppc_decrypt_ecb(walk.dst.virt.addr, walk.src.virt.addr,
> +                                       ctx->key_dec, ctx->rounds, nbytes);
>                 spe_end();
>
> -               err = blkcipher_walk_done(desc, &walk, ubytes);
> +               err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
>         }
>
>         return err;
>  }
>
> -static int ppc_ecb_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
> -                          struct scatterlist *src, unsigned int nbytes)
> +static int ppc_ecb_encrypt(struct skcipher_request *req)
>  {
> -       struct ppc_aes_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
> -       struct blkcipher_walk walk;
> -       unsigned int ubytes;
> -       int err;
> -
> -       desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
> -       blkcipher_walk_init(&walk, dst, src, nbytes);
> -       err = blkcipher_walk_virt(desc, &walk);
> -
> -       while ((nbytes = walk.nbytes)) {
> -               ubytes = nbytes > MAX_BYTES ?
> -                        nbytes - MAX_BYTES : nbytes & (AES_BLOCK_SIZE - 1);
> -               nbytes -= ubytes;
> -
> -               spe_begin();
> -               ppc_decrypt_ecb(walk.dst.virt.addr, walk.src.virt.addr,
> -                               ctx->key_dec, ctx->rounds, nbytes);
> -               spe_end();
> -
> -               err = blkcipher_walk_done(desc, &walk, ubytes);
> -       }
> +       return ppc_ecb_crypt(req, true);
> +}
>
> -       return err;
> +static int ppc_ecb_decrypt(struct skcipher_request *req)
> +{
> +       return ppc_ecb_crypt(req, false);
>  }
>
> -static int ppc_cbc_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
> -                          struct scatterlist *src, unsigned int nbytes)
> +static int ppc_cbc_crypt(struct skcipher_request *req, bool enc)
>  {
> -       struct ppc_aes_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
> -       struct blkcipher_walk walk;
> -       unsigned int ubytes;
> +       struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
> +       struct ppc_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
> +       struct skcipher_walk walk;
> +       unsigned int nbytes;
>         int err;
>
> -       desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
> -       blkcipher_walk_init(&walk, dst, src, nbytes);
> -       err = blkcipher_walk_virt(desc, &walk);
> +       err = skcipher_walk_virt(&walk, req, false);
>

Same here (and below)

> -       while ((nbytes = walk.nbytes)) {
> -               ubytes = nbytes > MAX_BYTES ?
> -                        nbytes - MAX_BYTES : nbytes & (AES_BLOCK_SIZE - 1);
> -               nbytes -= ubytes;
> +       while ((nbytes = walk.nbytes) != 0) {
> +               nbytes = min_t(unsigned int, nbytes, MAX_BYTES);
> +               nbytes = round_down(nbytes, AES_BLOCK_SIZE);
>
>                 spe_begin();
> -               ppc_encrypt_cbc(walk.dst.virt.addr, walk.src.virt.addr,
> -                               ctx->key_enc, ctx->rounds, nbytes, walk.iv);
> +               if (enc)
> +                       ppc_encrypt_cbc(walk.dst.virt.addr, walk.src.virt.addr,
> +                                       ctx->key_enc, ctx->rounds, nbytes,
> +                                       walk.iv);
> +               else
> +                       ppc_decrypt_cbc(walk.dst.virt.addr, walk.src.virt.addr,
> +                                       ctx->key_dec, ctx->rounds, nbytes,
> +                                       walk.iv);
>                 spe_end();
>
> -               err = blkcipher_walk_done(desc, &walk, ubytes);
> +               err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
>         }
>
>         return err;
>  }
>
> -static int ppc_cbc_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
> -                          struct scatterlist *src, unsigned int nbytes)
> +static int ppc_cbc_encrypt(struct skcipher_request *req)
>  {
> -       struct ppc_aes_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
> -       struct blkcipher_walk walk;
> -       unsigned int ubytes;
> -       int err;
> -
> -       desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
> -       blkcipher_walk_init(&walk, dst, src, nbytes);
> -       err = blkcipher_walk_virt(desc, &walk);
> -
> -       while ((nbytes = walk.nbytes)) {
> -               ubytes = nbytes > MAX_BYTES ?
> -                        nbytes - MAX_BYTES : nbytes & (AES_BLOCK_SIZE - 1);
> -               nbytes -= ubytes;
> -
> -               spe_begin();
> -               ppc_decrypt_cbc(walk.dst.virt.addr, walk.src.virt.addr,
> -                               ctx->key_dec, ctx->rounds, nbytes, walk.iv);
> -               spe_end();
> -
> -               err = blkcipher_walk_done(desc, &walk, ubytes);
> -       }
> +       return ppc_cbc_crypt(req, true);
> +}
>
> -       return err;
> +static int ppc_cbc_decrypt(struct skcipher_request *req)
> +{
> +       return ppc_cbc_crypt(req, false);
>  }
>
> -static int ppc_ctr_crypt(struct blkcipher_desc *desc, struct scatterlist *dst,
> -                        struct scatterlist *src, unsigned int nbytes)
> +static int ppc_ctr_crypt(struct skcipher_request *req)
>  {
> -       struct ppc_aes_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
> -       struct blkcipher_walk walk;
> -       unsigned int pbytes, ubytes;
> +       struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
> +       struct ppc_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
> +       struct skcipher_walk walk;
> +       unsigned int nbytes;
>         int err;
>
> -       desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
> -       blkcipher_walk_init(&walk, dst, src, nbytes);
> -       err = blkcipher_walk_virt_block(desc, &walk, AES_BLOCK_SIZE);
> +       err = skcipher_walk_virt(&walk, req, false);
>
> -       while ((pbytes = walk.nbytes)) {
> -               pbytes = pbytes > MAX_BYTES ? MAX_BYTES : pbytes;
> -               pbytes = pbytes == nbytes ?
> -                        nbytes : pbytes & ~(AES_BLOCK_SIZE - 1);
> -               ubytes = walk.nbytes - pbytes;
> +       while ((nbytes = walk.nbytes) != 0) {
> +               nbytes = min_t(unsigned int, nbytes, MAX_BYTES);
> +               if (nbytes < walk.total)
> +                       nbytes = round_down(nbytes, AES_BLOCK_SIZE);
>
>                 spe_begin();
>                 ppc_crypt_ctr(walk.dst.virt.addr, walk.src.virt.addr,
> -                             ctx->key_enc, ctx->rounds, pbytes , walk.iv);
> +                             ctx->key_enc, ctx->rounds, nbytes, walk.iv);
>                 spe_end();
>
> -               nbytes -= pbytes;
> -               err = blkcipher_walk_done(desc, &walk, ubytes);
> +               err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
>         }
>
>         return err;
>  }
>
> -static int ppc_xts_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
> -                          struct scatterlist *src, unsigned int nbytes)
> +static int ppc_xts_crypt(struct skcipher_request *req, bool enc)
>  {
> -       struct ppc_xts_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
> -       struct blkcipher_walk walk;
> -       unsigned int ubytes;
> +       struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
> +       struct ppc_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
> +       struct skcipher_walk walk;
> +       unsigned int nbytes;
>         int err;
>         u32 *twk;
>
> -       desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
> -       blkcipher_walk_init(&walk, dst, src, nbytes);
> -       err = blkcipher_walk_virt(desc, &walk);
> +       err = skcipher_walk_virt(&walk, req, false);
>         twk = ctx->key_twk;
>
> -       while ((nbytes = walk.nbytes)) {
> -               ubytes = nbytes > MAX_BYTES ?
> -                        nbytes - MAX_BYTES : nbytes & (AES_BLOCK_SIZE - 1);
> -               nbytes -= ubytes;
> +       while ((nbytes = walk.nbytes) != 0) {
> +               nbytes = min_t(unsigned int, nbytes, MAX_BYTES);
> +               nbytes = round_down(nbytes, AES_BLOCK_SIZE);
>
>                 spe_begin();
> -               ppc_encrypt_xts(walk.dst.virt.addr, walk.src.virt.addr,
> -                               ctx->key_enc, ctx->rounds, nbytes, walk.iv, twk);
> +               if (enc)
> +                       ppc_encrypt_xts(walk.dst.virt.addr, walk.src.virt.addr,
> +                                       ctx->key_enc, ctx->rounds, nbytes,
> +                                       walk.iv, twk);
> +               else
> +                       ppc_decrypt_xts(walk.dst.virt.addr, walk.src.virt.addr,
> +                                       ctx->key_dec, ctx->rounds, nbytes,
> +                                       walk.iv, twk);
>                 spe_end();
>
>                 twk = NULL;
> -               err = blkcipher_walk_done(desc, &walk, ubytes);
> +               err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
>         }
>
>         return err;
>  }
>
> -static int ppc_xts_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
> -                          struct scatterlist *src, unsigned int nbytes)
> +static int ppc_xts_encrypt(struct skcipher_request *req)
>  {
> -       struct ppc_xts_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
> -       struct blkcipher_walk walk;
> -       unsigned int ubytes;
> -       int err;
> -       u32 *twk;
> -
> -       desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
> -       blkcipher_walk_init(&walk, dst, src, nbytes);
> -       err = blkcipher_walk_virt(desc, &walk);
> -       twk = ctx->key_twk;
> -
> -       while ((nbytes = walk.nbytes)) {
> -               ubytes = nbytes > MAX_BYTES ?
> -                        nbytes - MAX_BYTES : nbytes & (AES_BLOCK_SIZE - 1);
> -               nbytes -= ubytes;
> -
> -               spe_begin();
> -               ppc_decrypt_xts(walk.dst.virt.addr, walk.src.virt.addr,
> -                               ctx->key_dec, ctx->rounds, nbytes, walk.iv, twk);
> -               spe_end();
> -
> -               twk = NULL;
> -               err = blkcipher_walk_done(desc, &walk, ubytes);
> -       }
> +       return ppc_xts_crypt(req, true);
> +}
>
> -       return err;
> +static int ppc_xts_decrypt(struct skcipher_request *req)
> +{
> +       return ppc_xts_crypt(req, false);
>  }
>
>  /*
> @@ -388,9 +354,9 @@ static int ppc_xts_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
>   * This improves IPsec thoughput by another few percent. Additionally we assume
>   * that AES context is always aligned to at least 8 bytes because it is created
>   * with kmalloc() in the crypto infrastructure
> - *
>   */
> -static struct crypto_alg aes_algs[] = { {
> +
> +static struct crypto_alg aes_cipher_alg = {
>         .cra_name               =       "aes",
>         .cra_driver_name        =       "aes-ppc-spe",
>         .cra_priority           =       300,
> @@ -408,96 +374,84 @@ static struct crypto_alg aes_algs[] = { {
>                         .cia_decrypt            =       ppc_aes_decrypt
>                 }
>         }
> -}, {
> -       .cra_name               =       "ecb(aes)",
> -       .cra_driver_name        =       "ecb-ppc-spe",
> -       .cra_priority           =       300,
> -       .cra_flags              =       CRYPTO_ALG_TYPE_BLKCIPHER,
> -       .cra_blocksize          =       AES_BLOCK_SIZE,
> -       .cra_ctxsize            =       sizeof(struct ppc_aes_ctx),
> -       .cra_alignmask          =       0,
> -       .cra_type               =       &crypto_blkcipher_type,
> -       .cra_module             =       THIS_MODULE,
> -       .cra_u = {
> -               .blkcipher = {
> -                       .min_keysize            =       AES_MIN_KEY_SIZE,
> -                       .max_keysize            =       AES_MAX_KEY_SIZE,
> -                       .ivsize                 =       AES_BLOCK_SIZE,
> -                       .setkey                 =       ppc_aes_setkey,
> -                       .encrypt                =       ppc_ecb_encrypt,
> -                       .decrypt                =       ppc_ecb_decrypt,
> -               }
> -       }
> -}, {
> -       .cra_name               =       "cbc(aes)",
> -       .cra_driver_name        =       "cbc-ppc-spe",
> -       .cra_priority           =       300,
> -       .cra_flags              =       CRYPTO_ALG_TYPE_BLKCIPHER,
> -       .cra_blocksize          =       AES_BLOCK_SIZE,
> -       .cra_ctxsize            =       sizeof(struct ppc_aes_ctx),
> -       .cra_alignmask          =       0,
> -       .cra_type               =       &crypto_blkcipher_type,
> -       .cra_module             =       THIS_MODULE,
> -       .cra_u = {
> -               .blkcipher = {
> -                       .min_keysize            =       AES_MIN_KEY_SIZE,
> -                       .max_keysize            =       AES_MAX_KEY_SIZE,
> -                       .ivsize                 =       AES_BLOCK_SIZE,
> -                       .setkey                 =       ppc_aes_setkey,
> -                       .encrypt                =       ppc_cbc_encrypt,
> -                       .decrypt                =       ppc_cbc_decrypt,
> -               }
> -       }
> -}, {
> -       .cra_name               =       "ctr(aes)",
> -       .cra_driver_name        =       "ctr-ppc-spe",
> -       .cra_priority           =       300,
> -       .cra_flags              =       CRYPTO_ALG_TYPE_BLKCIPHER,
> -       .cra_blocksize          =       1,
> -       .cra_ctxsize            =       sizeof(struct ppc_aes_ctx),
> -       .cra_alignmask          =       0,
> -       .cra_type               =       &crypto_blkcipher_type,
> -       .cra_module             =       THIS_MODULE,
> -       .cra_u = {
> -               .blkcipher = {
> -                       .min_keysize            =       AES_MIN_KEY_SIZE,
> -                       .max_keysize            =       AES_MAX_KEY_SIZE,
> -                       .ivsize                 =       AES_BLOCK_SIZE,
> -                       .setkey                 =       ppc_aes_setkey,
> -                       .encrypt                =       ppc_ctr_crypt,
> -                       .decrypt                =       ppc_ctr_crypt,
> -               }
> -       }
> -}, {
> -       .cra_name               =       "xts(aes)",
> -       .cra_driver_name        =       "xts-ppc-spe",
> -       .cra_priority           =       300,
> -       .cra_flags              =       CRYPTO_ALG_TYPE_BLKCIPHER,
> -       .cra_blocksize          =       AES_BLOCK_SIZE,
> -       .cra_ctxsize            =       sizeof(struct ppc_xts_ctx),
> -       .cra_alignmask          =       0,
> -       .cra_type               =       &crypto_blkcipher_type,
> -       .cra_module             =       THIS_MODULE,
> -       .cra_u = {
> -               .blkcipher = {
> -                       .min_keysize            =       AES_MIN_KEY_SIZE * 2,
> -                       .max_keysize            =       AES_MAX_KEY_SIZE * 2,
> -                       .ivsize                 =       AES_BLOCK_SIZE,
> -                       .setkey                 =       ppc_xts_setkey,
> -                       .encrypt                =       ppc_xts_encrypt,
> -                       .decrypt                =       ppc_xts_decrypt,
> -               }
> +};
> +
> +static struct skcipher_alg aes_skcipher_algs[] = {
> +       {
> +               .base.cra_name          =       "ecb(aes)",
> +               .base.cra_driver_name   =       "ecb-ppc-spe",
> +               .base.cra_priority      =       300,
> +               .base.cra_blocksize     =       AES_BLOCK_SIZE,
> +               .base.cra_ctxsize       =       sizeof(struct ppc_aes_ctx),
> +               .base.cra_module        =       THIS_MODULE,
> +               .min_keysize            =       AES_MIN_KEY_SIZE,
> +               .max_keysize            =       AES_MAX_KEY_SIZE,
> +               .setkey                 =       ppc_aes_setkey_skcipher,
> +               .encrypt                =       ppc_ecb_encrypt,
> +               .decrypt                =       ppc_ecb_decrypt,
> +       }, {
> +               .base.cra_name          =       "cbc(aes)",
> +               .base.cra_driver_name   =       "cbc-ppc-spe",
> +               .base.cra_priority      =       300,
> +               .base.cra_blocksize     =       AES_BLOCK_SIZE,
> +               .base.cra_ctxsize       =       sizeof(struct ppc_aes_ctx),
> +               .base.cra_module        =       THIS_MODULE,
> +               .min_keysize            =       AES_MIN_KEY_SIZE,
> +               .max_keysize            =       AES_MAX_KEY_SIZE,
> +               .ivsize                 =       AES_BLOCK_SIZE,
> +               .setkey                 =       ppc_aes_setkey_skcipher,
> +               .encrypt                =       ppc_cbc_encrypt,
> +               .decrypt                =       ppc_cbc_decrypt,
> +       }, {
> +               .base.cra_name          =       "ctr(aes)",
> +               .base.cra_driver_name   =       "ctr-ppc-spe",
> +               .base.cra_priority      =       300,
> +               .base.cra_blocksize     =       1,
> +               .base.cra_ctxsize       =       sizeof(struct ppc_aes_ctx),
> +               .base.cra_module        =       THIS_MODULE,
> +               .min_keysize            =       AES_MIN_KEY_SIZE,
> +               .max_keysize            =       AES_MAX_KEY_SIZE,
> +               .ivsize                 =       AES_BLOCK_SIZE,
> +               .setkey                 =       ppc_aes_setkey_skcipher,
> +               .encrypt                =       ppc_ctr_crypt,
> +               .decrypt                =       ppc_ctr_crypt,
> +               .chunksize              =       AES_BLOCK_SIZE,
> +       }, {
> +               .base.cra_name          =       "xts(aes)",
> +               .base.cra_driver_name   =       "xts-ppc-spe",
> +               .base.cra_priority      =       300,
> +               .base.cra_blocksize     =       AES_BLOCK_SIZE,
> +               .base.cra_ctxsize       =       sizeof(struct ppc_xts_ctx),
> +               .base.cra_module        =       THIS_MODULE,
> +               .min_keysize            =       AES_MIN_KEY_SIZE * 2,
> +               .max_keysize            =       AES_MAX_KEY_SIZE * 2,
> +               .ivsize                 =       AES_BLOCK_SIZE,
> +               .setkey                 =       ppc_xts_setkey,
> +               .encrypt                =       ppc_xts_encrypt,
> +               .decrypt                =       ppc_xts_decrypt,
>         }
> -} };
> +};
>
>  static int __init ppc_aes_mod_init(void)
>  {
> -       return crypto_register_algs(aes_algs, ARRAY_SIZE(aes_algs));
> +       int err;
> +
> +       err = crypto_register_alg(&aes_cipher_alg);
> +       if (err)
> +               return err;
> +
> +       err = crypto_register_skciphers(aes_skcipher_algs,
> +                                       ARRAY_SIZE(aes_skcipher_algs));
> +       if (err)
> +               crypto_unregister_alg(&aes_cipher_alg);
> +       return err;
>  }
>
>  static void __exit ppc_aes_mod_fini(void)
>  {
> -       crypto_unregister_algs(aes_algs, ARRAY_SIZE(aes_algs));
> +       crypto_unregister_alg(&aes_cipher_alg);
> +       crypto_unregister_skciphers(aes_skcipher_algs,
> +                                   ARRAY_SIZE(aes_skcipher_algs));
>  }
>
>  module_init(ppc_aes_mod_init);
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index 29472fb795f3..03699657fb5d 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -1126,6 +1126,7 @@ config CRYPTO_AES_SPARC64
>  config CRYPTO_AES_PPC_SPE
>         tristate "AES cipher algorithms (PPC SPE)"
>         depends on PPC && SPE
> +       select CRYPTO_BLKCIPHER
>         help
>           AES cipher algorithms (FIPS-197). Additionally the acceleration
>           for popular block cipher modes ECB, CBC, CTR and XTS is supported.
> --
> 2.23.0
>
