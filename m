Return-Path: <SRS0=VKJi=YH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37209C4CECE
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 17:53:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 088722089C
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 17:53:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RSHWB5Sf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729650AbfJNRxF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Oct 2019 13:53:05 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41457 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728941AbfJNRxE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Oct 2019 13:53:04 -0400
Received: by mail-wr1-f66.google.com with SMTP id p4so4858787wrm.8
        for <linux-crypto@vger.kernel.org>; Mon, 14 Oct 2019 10:53:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zpqA0b5GNBkHRyGXS/9MbK6KgSVMH9XT5Yg8Y8UcE2E=;
        b=RSHWB5Sf9WJG2+fZoo+Cp+IsHOiImB1XOzWrkwma3/X2ux1ZjrFfIclMeKgA5yvtag
         XbHv/+AwWMblwvKlG8ALBp1/glrUxzUnls/din6V+or8QI5SPqqpW060bRjn9Xf3/KG6
         yd3VUTi9QZs0XzbfMIx2+lWiWytB4p31vN7LMQ4mwcn8GB4s5VGO1Z357+CIU5VoiC6X
         uAy5icYv8DVXGXOq31+o8+Hp9TAGoJIsxy9bwuuzdvEoD0J+20sUSraEy1CoadwUojRO
         qgoWYgcWh4cj8lC5vcnCMQbifiYrAZdssKtEkpZzCo2QkvuoHBU+8/4bk6JGTDH8Q0ve
         dh4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zpqA0b5GNBkHRyGXS/9MbK6KgSVMH9XT5Yg8Y8UcE2E=;
        b=mHnBOuII9yooQts1GIQlsxMPQ4wH1krn7VwyWF1ckF+bKCTwzPHLE80QEyXKTpZ2pq
         9TuJAfKlIrJcDMJAEh6EWEt70skjZ8UnGpB2hXwVc2c3gBuvWzAS1R7GzoygWvck0V8u
         8euluey4mrzqtjpQSVw+0orlN6YhVZZ4okBUrk/ATp7pCiH6aFqpZxDqfWSVD+ylivKB
         aPW9xlnuTyRJAh5uOdN+Sfs4PM/Dkn5NvJ40vFxS7/3XKbN4GkFAhCyURPAu4CWjBioA
         5u+DdgFTnowo0LgZtLmxo1ef7A/qZ2Yk77pRIFG1S7Y5AMcV8QZENs1Z5MOcOfschkLl
         94EQ==
X-Gm-Message-State: APjAAAWchP8X49y36ixtOmkk6/0qFSkf9RekeTEJyWmsA3J7xwsGHpjh
        nF55a2kAnp2aQecI9Ia/HjICpSniWc9oEd20moruEA==
X-Google-Smtp-Source: APXvYqxQkpXYu5NfircmOBfak8JaBK0rdp0cYqchJqVdxT3Xn/TO+VN3yY4zSjF4pSU3ceyOrS4mzx/nnBXl7+kZhPY=
X-Received: by 2002:a5d:6449:: with SMTP id d9mr28195789wrw.246.1571075582156;
 Mon, 14 Oct 2019 10:53:02 -0700 (PDT)
MIME-Version: 1.0
References: <20191012022946.185320-1-ebiggers@kernel.org> <CAKv+Gu9qS838o+jJv3My=ibvfgE=3yeVbH5SB=yraKb3S7sV6A@mail.gmail.com>
 <20191014173848.GA104009@gmail.com>
In-Reply-To: <20191014173848.GA104009@gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 14 Oct 2019 19:52:51 +0200
Message-ID: <CAKv+Gu_5f-mx9zoEvvQXsVb+r+9z-YCtOHzrQJ5f73_QYt4e8Q@mail.gmail.com>
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

On Mon, 14 Oct 2019 at 19:38, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Mon, Oct 14, 2019 at 10:45:22AM +0200, Ard Biesheuvel wrote:
> > Hi Eric,
> >
> > On Sat, 12 Oct 2019 at 04:32, Eric Biggers <ebiggers@kernel.org> wrote:
> > >
> > > From: Eric Biggers <ebiggers@google.com>
> > >
> > > Convert the glue code for the PowerPC SPE implementations of AES-ECB,
> > > AES-CBC, AES-CTR, and AES-XTS from the deprecated "blkcipher" API to the
> > > "skcipher" API.
> > >
> > > Tested with:
> > >
> > >         export ARCH=powerpc CROSS_COMPILE=powerpc-linux-gnu-
> > >         make mpc85xx_defconfig
> > >         cat >> .config << EOF
> > >         # CONFIG_MODULES is not set
> > >         # CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
> > >         CONFIG_DEBUG_KERNEL=y
> > >         CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y
> > >         CONFIG_CRYPTO_AES=y
> > >         CONFIG_CRYPTO_CBC=y
> > >         CONFIG_CRYPTO_CTR=y
> > >         CONFIG_CRYPTO_ECB=y
> > >         CONFIG_CRYPTO_XTS=y
> > >         CONFIG_CRYPTO_AES_PPC_SPE=y
> > >         EOF
> > >         make olddefconfig
> > >         make -j32
> > >         qemu-system-ppc -M mpc8544ds -cpu e500 -nographic \
> > >                 -kernel arch/powerpc/boot/zImage \
> > >                 -append cryptomgr.fuzz_iterations=1000
> > >
> > > Note that xts-ppc-spe still fails the comparison tests due to the lack
> > > of ciphertext stealing support.  This is not addressed by this patch.
> > >
> > > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > > ---
> > >  arch/powerpc/crypto/aes-spe-glue.c | 416 +++++++++++++----------------
> > >  crypto/Kconfig                     |   1 +
> > >  2 files changed, 186 insertions(+), 231 deletions(-)
> > >
> > > diff --git a/arch/powerpc/crypto/aes-spe-glue.c b/arch/powerpc/crypto/aes-spe-glue.c
> > > index 3a4ca7d32477..374e3e51e998 100644
> > > --- a/arch/powerpc/crypto/aes-spe-glue.c
> > > +++ b/arch/powerpc/crypto/aes-spe-glue.c
> > > @@ -17,6 +17,7 @@
> > >  #include <asm/byteorder.h>
> > >  #include <asm/switch_to.h>
> > >  #include <crypto/algapi.h>
> > > +#include <crypto/internal/skcipher.h>
> > >  #include <crypto/xts.h>
> > >
> > >  /*
> > > @@ -86,17 +87,13 @@ static void spe_end(void)
> > >         preempt_enable();
> > >  }
> > >
> > > -static int ppc_aes_setkey(struct crypto_tfm *tfm, const u8 *in_key,
> > > -               unsigned int key_len)
> > > +static int expand_key(struct ppc_aes_ctx *ctx,
> > > +                     const u8 *in_key, unsigned int key_len)
> > >  {
> > > -       struct ppc_aes_ctx *ctx = crypto_tfm_ctx(tfm);
> > > -
> > >         if (key_len != AES_KEYSIZE_128 &&
> > >             key_len != AES_KEYSIZE_192 &&
> > > -           key_len != AES_KEYSIZE_256) {
> > > -               tfm->crt_flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
> > > +           key_len != AES_KEYSIZE_256)
> > >                 return -EINVAL;
> > > -       }
> > >
> > >         switch (key_len) {
> > >         case AES_KEYSIZE_128:
> > > @@ -114,17 +111,40 @@ static int ppc_aes_setkey(struct crypto_tfm *tfm, const u8 *in_key,
> > >         }
> > >
> > >         ppc_generate_decrypt_key(ctx->key_dec, ctx->key_enc, key_len);
> > > +       return 0;
> > > +}
> > >
> > > +static int ppc_aes_setkey(struct crypto_tfm *tfm, const u8 *in_key,
> > > +               unsigned int key_len)
> > > +{
> > > +       struct ppc_aes_ctx *ctx = crypto_tfm_ctx(tfm);
> > > +
> > > +       if (expand_key(ctx, in_key, key_len) != 0) {
> > > +               tfm->crt_flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
> > > +               return -EINVAL;
> > > +       }
> > > +       return 0;
> > > +}
> > > +
> > > +static int ppc_aes_setkey_skcipher(struct crypto_skcipher *tfm,
> > > +                                  const u8 *in_key, unsigned int key_len)
> > > +{
> > > +       struct ppc_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
> > > +
> > > +       if (expand_key(ctx, in_key, key_len) != 0) {
> > > +               crypto_skcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
> > > +               return -EINVAL;
> > > +       }
> > >         return 0;
> > >  }
> > >
> > > -static int ppc_xts_setkey(struct crypto_tfm *tfm, const u8 *in_key,
> > > +static int ppc_xts_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
> > >                    unsigned int key_len)
> > >  {
> > > -       struct ppc_xts_ctx *ctx = crypto_tfm_ctx(tfm);
> > > +       struct ppc_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
> > >         int err;
> > >
> > > -       err = xts_check_key(tfm, in_key, key_len);
> > > +       err = xts_verify_key(tfm, in_key, key_len);
> > >         if (err)
> > >                 return err;
> > >
> > > @@ -133,7 +153,7 @@ static int ppc_xts_setkey(struct crypto_tfm *tfm, const u8 *in_key,
> > >         if (key_len != AES_KEYSIZE_128 &&
> > >             key_len != AES_KEYSIZE_192 &&
> > >             key_len != AES_KEYSIZE_256) {
> > > -               tfm->crt_flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
> > > +               crypto_skcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
> > >                 return -EINVAL;
> > >         }
> > >
> > > @@ -178,208 +198,154 @@ static void ppc_aes_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
> > >         spe_end();
> > >  }
> > >
> > > -static int ppc_ecb_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
> > > -                          struct scatterlist *src, unsigned int nbytes)
> > > +static int ppc_ecb_crypt(struct skcipher_request *req, bool enc)
> > >  {
> > > -       struct ppc_aes_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
> > > -       struct blkcipher_walk walk;
> > > -       unsigned int ubytes;
> > > +       struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
> > > +       struct ppc_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
> > > +       struct skcipher_walk walk;
> > > +       unsigned int nbytes;
> > >         int err;
> > >
> > > -       desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
> > > -       blkcipher_walk_init(&walk, dst, src, nbytes);
> > > -       err = blkcipher_walk_virt(desc, &walk);
> > > +       err = skcipher_walk_virt(&walk, req, false);
> > >
> >
> > Shouldn't atomic be set to 'true' here to retain the non-sleeping behavior?
>
> This was intentional since the non-sleeping behavior is unnecessary, as the call
> to skcipher_walk_done() is not within the spe_begin() / spe_end() section.
> I can split this into a separate patch if it would make it clearer, though.
>

No, I guess that is fine, but it deserves a mention in the commit log.
