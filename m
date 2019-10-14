Return-Path: <SRS0=VKJi=YH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BD28C4CECE
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 17:38:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4EDD320873
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 17:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1571074733;
	bh=GAM90uSuUNkPZmpvu9jBQoRyA94D633aRlssOYHFAEs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=tggMhO8yeHLD9yr2uD6ny/LJdO0q95WYUyqoEhM/gerL7HeHolOM6BEnvwPf1Upg0
	 J2aWJilmK1mp0T47zrW9ZGgYOmkB2V7SNvTEfEtyEOQpKXGgP09FBqkoTiI5TIwCxV
	 rrtCpZw9tQr1YbYIQKAbJzfjU/6xR27yCsaay/RU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730580AbfJNRiw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Oct 2019 13:38:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:53988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730527AbfJNRiw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Oct 2019 13:38:52 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B539920854;
        Mon, 14 Oct 2019 17:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571074731;
        bh=GAM90uSuUNkPZmpvu9jBQoRyA94D633aRlssOYHFAEs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Fhd03Jk0JoIYhSM+UsAgCoOtFR5SSFz8UsS1ViKzByYy16NOR96olCm3GvaE7FIvj
         sH8gQw1+W5gQ3H/sKHBhiXThbPhaM56kG2JifgxdHv3RO0+VL5p6x5257syxiiM8lc
         fKg7XvNI24BWYGWd9gSuLUKLGOReVLfZNwk8p3s0=
Date:   Mon, 14 Oct 2019 10:38:49 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Markus Stockhausen <stockhausen@collogia.de>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH] crypto: powerpc - convert SPE AES algorithms to skcipher
 API
Message-ID: <20191014173848.GA104009@gmail.com>
Mail-Followup-To: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Markus Stockhausen <stockhausen@collogia.de>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
References: <20191012022946.185320-1-ebiggers@kernel.org>
 <CAKv+Gu9qS838o+jJv3My=ibvfgE=3yeVbH5SB=yraKb3S7sV6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9qS838o+jJv3My=ibvfgE=3yeVbH5SB=yraKb3S7sV6A@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Oct 14, 2019 at 10:45:22AM +0200, Ard Biesheuvel wrote:
> Hi Eric,
> 
> On Sat, 12 Oct 2019 at 04:32, Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > From: Eric Biggers <ebiggers@google.com>
> >
> > Convert the glue code for the PowerPC SPE implementations of AES-ECB,
> > AES-CBC, AES-CTR, and AES-XTS from the deprecated "blkcipher" API to the
> > "skcipher" API.
> >
> > Tested with:
> >
> >         export ARCH=powerpc CROSS_COMPILE=powerpc-linux-gnu-
> >         make mpc85xx_defconfig
> >         cat >> .config << EOF
> >         # CONFIG_MODULES is not set
> >         # CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
> >         CONFIG_DEBUG_KERNEL=y
> >         CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y
> >         CONFIG_CRYPTO_AES=y
> >         CONFIG_CRYPTO_CBC=y
> >         CONFIG_CRYPTO_CTR=y
> >         CONFIG_CRYPTO_ECB=y
> >         CONFIG_CRYPTO_XTS=y
> >         CONFIG_CRYPTO_AES_PPC_SPE=y
> >         EOF
> >         make olddefconfig
> >         make -j32
> >         qemu-system-ppc -M mpc8544ds -cpu e500 -nographic \
> >                 -kernel arch/powerpc/boot/zImage \
> >                 -append cryptomgr.fuzz_iterations=1000
> >
> > Note that xts-ppc-spe still fails the comparison tests due to the lack
> > of ciphertext stealing support.  This is not addressed by this patch.
> >
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > ---
> >  arch/powerpc/crypto/aes-spe-glue.c | 416 +++++++++++++----------------
> >  crypto/Kconfig                     |   1 +
> >  2 files changed, 186 insertions(+), 231 deletions(-)
> >
> > diff --git a/arch/powerpc/crypto/aes-spe-glue.c b/arch/powerpc/crypto/aes-spe-glue.c
> > index 3a4ca7d32477..374e3e51e998 100644
> > --- a/arch/powerpc/crypto/aes-spe-glue.c
> > +++ b/arch/powerpc/crypto/aes-spe-glue.c
> > @@ -17,6 +17,7 @@
> >  #include <asm/byteorder.h>
> >  #include <asm/switch_to.h>
> >  #include <crypto/algapi.h>
> > +#include <crypto/internal/skcipher.h>
> >  #include <crypto/xts.h>
> >
> >  /*
> > @@ -86,17 +87,13 @@ static void spe_end(void)
> >         preempt_enable();
> >  }
> >
> > -static int ppc_aes_setkey(struct crypto_tfm *tfm, const u8 *in_key,
> > -               unsigned int key_len)
> > +static int expand_key(struct ppc_aes_ctx *ctx,
> > +                     const u8 *in_key, unsigned int key_len)
> >  {
> > -       struct ppc_aes_ctx *ctx = crypto_tfm_ctx(tfm);
> > -
> >         if (key_len != AES_KEYSIZE_128 &&
> >             key_len != AES_KEYSIZE_192 &&
> > -           key_len != AES_KEYSIZE_256) {
> > -               tfm->crt_flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
> > +           key_len != AES_KEYSIZE_256)
> >                 return -EINVAL;
> > -       }
> >
> >         switch (key_len) {
> >         case AES_KEYSIZE_128:
> > @@ -114,17 +111,40 @@ static int ppc_aes_setkey(struct crypto_tfm *tfm, const u8 *in_key,
> >         }
> >
> >         ppc_generate_decrypt_key(ctx->key_dec, ctx->key_enc, key_len);
> > +       return 0;
> > +}
> >
> > +static int ppc_aes_setkey(struct crypto_tfm *tfm, const u8 *in_key,
> > +               unsigned int key_len)
> > +{
> > +       struct ppc_aes_ctx *ctx = crypto_tfm_ctx(tfm);
> > +
> > +       if (expand_key(ctx, in_key, key_len) != 0) {
> > +               tfm->crt_flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
> > +               return -EINVAL;
> > +       }
> > +       return 0;
> > +}
> > +
> > +static int ppc_aes_setkey_skcipher(struct crypto_skcipher *tfm,
> > +                                  const u8 *in_key, unsigned int key_len)
> > +{
> > +       struct ppc_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
> > +
> > +       if (expand_key(ctx, in_key, key_len) != 0) {
> > +               crypto_skcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
> > +               return -EINVAL;
> > +       }
> >         return 0;
> >  }
> >
> > -static int ppc_xts_setkey(struct crypto_tfm *tfm, const u8 *in_key,
> > +static int ppc_xts_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
> >                    unsigned int key_len)
> >  {
> > -       struct ppc_xts_ctx *ctx = crypto_tfm_ctx(tfm);
> > +       struct ppc_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
> >         int err;
> >
> > -       err = xts_check_key(tfm, in_key, key_len);
> > +       err = xts_verify_key(tfm, in_key, key_len);
> >         if (err)
> >                 return err;
> >
> > @@ -133,7 +153,7 @@ static int ppc_xts_setkey(struct crypto_tfm *tfm, const u8 *in_key,
> >         if (key_len != AES_KEYSIZE_128 &&
> >             key_len != AES_KEYSIZE_192 &&
> >             key_len != AES_KEYSIZE_256) {
> > -               tfm->crt_flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
> > +               crypto_skcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
> >                 return -EINVAL;
> >         }
> >
> > @@ -178,208 +198,154 @@ static void ppc_aes_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
> >         spe_end();
> >  }
> >
> > -static int ppc_ecb_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
> > -                          struct scatterlist *src, unsigned int nbytes)
> > +static int ppc_ecb_crypt(struct skcipher_request *req, bool enc)
> >  {
> > -       struct ppc_aes_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
> > -       struct blkcipher_walk walk;
> > -       unsigned int ubytes;
> > +       struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
> > +       struct ppc_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
> > +       struct skcipher_walk walk;
> > +       unsigned int nbytes;
> >         int err;
> >
> > -       desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
> > -       blkcipher_walk_init(&walk, dst, src, nbytes);
> > -       err = blkcipher_walk_virt(desc, &walk);
> > +       err = skcipher_walk_virt(&walk, req, false);
> >
> 
> Shouldn't atomic be set to 'true' here to retain the non-sleeping behavior?

This was intentional since the non-sleeping behavior is unnecessary, as the call
to skcipher_walk_done() is not within the spe_begin() / spe_end() section.
I can split this into a separate patch if it would make it clearer, though.

> 
> > -       while ((nbytes = walk.nbytes)) {
> > -               ubytes = nbytes > MAX_BYTES ?
> > -                        nbytes - MAX_BYTES : nbytes & (AES_BLOCK_SIZE - 1);
> > -               nbytes -= ubytes;
> > +       while ((nbytes = walk.nbytes) != 0) {
> > +               nbytes = min_t(unsigned int, nbytes, MAX_BYTES);
> > +               nbytes = round_down(nbytes, AES_BLOCK_SIZE);
> >
> >                 spe_begin();
> > -               ppc_encrypt_ecb(walk.dst.virt.addr, walk.src.virt.addr,
> > -                               ctx->key_enc, ctx->rounds, nbytes);
> > +               if (enc)
> > +                       ppc_encrypt_ecb(walk.dst.virt.addr, walk.src.virt.addr,
> > +                                       ctx->key_enc, ctx->rounds, nbytes);
> > +               else
> > +                       ppc_decrypt_ecb(walk.dst.virt.addr, walk.src.virt.addr,
> > +                                       ctx->key_dec, ctx->rounds, nbytes);
> >                 spe_end();
> >
> > -               err = blkcipher_walk_done(desc, &walk, ubytes);
> > +               err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
> >         }
> >
> >         return err;
> >  }

