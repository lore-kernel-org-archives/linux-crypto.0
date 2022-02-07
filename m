Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 908F5C41535
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Feb 2022 10:16:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231335AbiBGKPD (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Feb 2022 05:15:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352273AbiBGKAT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Feb 2022 05:00:19 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38B8BC043188
        for <linux-crypto@vger.kernel.org>; Mon,  7 Feb 2022 02:00:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 78A3FCE0F47
        for <linux-crypto@vger.kernel.org>; Mon,  7 Feb 2022 10:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93582C340F2
        for <linux-crypto@vger.kernel.org>; Mon,  7 Feb 2022 10:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644228014;
        bh=pegKrCZ3UDYg+8BOpgybNYVaCQCx/7+j3tuQHRy8lCA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=XtGpYpAmMKuYIT36/RS4sZoAerlB34wu3PrSWQDg7jJwAngt5jFMeqHczyyRwGYtA
         /09jFMTpKTj5Cq/RBinuiezQWXmzYI53XTzxHjB5Ab9UTc003WzC1H/YusEyfVh9Ol
         XZ8Gh9RuhkpaoKQPKQCByt6qM3xEj9e8MwLLsCjfJ5k1GYumqZR1buNs6OlGk7AaRD
         z4lF/EgEczheRpbo9I8fZ4ilXG0RWDKbLG11JDUsn04eqsmNBJWYb5mW67EPAw0HdH
         UiAYYylcCw0zMFQ0/DJo2VT35LYD7MotqChsfUGdpeADuokoQY+dMT1fVgUcPSUp8W
         IE1sQo3XVyz/Q==
Received: by mail-wr1-f48.google.com with SMTP id s18so23679319wrv.7
        for <linux-crypto@vger.kernel.org>; Mon, 07 Feb 2022 02:00:14 -0800 (PST)
X-Gm-Message-State: AOAM5306ZJXfg+Yv4V6f9zin08UewAwXVAdFgwkeysrpzZzXcI0XuQZD
        2V/mBPASHEYKgg+/4LGcGLoPc2Pl5jrMnwftjeU=
X-Google-Smtp-Source: ABdhPJyNnePZ+wN+vuD4vPPeEJfVCVf8SmWBT1dMC2+BDwYhPSRevWmQ1N+UWUsF5eAYAQ36ZPPGduzAn7eaz+Vab6s=
X-Received: by 2002:a05:6000:15ca:: with SMTP id y10mr9411057wry.417.1644228012917;
 Mon, 07 Feb 2022 02:00:12 -0800 (PST)
MIME-Version: 1.0
References: <20220125014422.80552-1-nhuck@google.com> <20220125014422.80552-6-nhuck@google.com>
 <CAMj1kXFW1fBXtELj+gpQ0mqVA=+vce7LCMRtxW+uT5AzyYTmwA@mail.gmail.com>
In-Reply-To: <CAMj1kXFW1fBXtELj+gpQ0mqVA=+vce7LCMRtxW+uT5AzyYTmwA@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 7 Feb 2022 11:00:01 +0100
X-Gmail-Original-Message-ID: <CAMj1kXFVEhNnqeMzqWwrGJ5ktkGW-32PQnknHRWZokgDNq48ZA@mail.gmail.com>
Message-ID: <CAMj1kXFVEhNnqeMzqWwrGJ5ktkGW-32PQnknHRWZokgDNq48ZA@mail.gmail.com>
Subject: Re: [RFC PATCH 5/7] crypto: arm64/aes-xctr: Add accelerated
 implementation of XCTR
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Paul Crowley <paulcrowley@google.com>,
        Eric Biggers <ebiggers@google.com>,
        Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 28 Jan 2022 at 15:10, Ard Biesheuvel <ardb@kernel.org> wrote:
>
> On Tue, 25 Jan 2022 at 02:47, Nathan Huckleberry <nhuck@google.com> wrote:
> >
> > Add hardware accelerated version of XCTR for ARM64 CPUs with ARMv8
> > Crypto Extension support.  This XCTR implementation is based on the CTR
> > implementation in aes-modes.S.
> >
> > More information on XCTR can be found in
> > the HCTR2 paper: Length-preserving encryption with HCTR2:
> > https://eprint.iacr.org/2021/1441.pdf
> >
> > Signed-off-by: Nathan Huckleberry <nhuck@google.com>
> > ---
> >  arch/arm64/crypto/Kconfig     |   4 +-
> >  arch/arm64/crypto/aes-glue.c  |  70 ++++++++++++++++++-
> >  arch/arm64/crypto/aes-modes.S | 128 ++++++++++++++++++++++++++++++++++
> >  3 files changed, 198 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/arm64/crypto/Kconfig b/arch/arm64/crypto/Kconfig
> > index addfa413650b..cab469e279ec 100644
> > --- a/arch/arm64/crypto/Kconfig
> > +++ b/arch/arm64/crypto/Kconfig
> > @@ -84,13 +84,13 @@ config CRYPTO_AES_ARM64_CE_CCM
> >         select CRYPTO_LIB_AES
> >
> >  config CRYPTO_AES_ARM64_CE_BLK
> > -       tristate "AES in ECB/CBC/CTR/XTS modes using ARMv8 Crypto Extensions"
> > +       tristate "AES in ECB/CBC/CTR/XTS/XCTR modes using ARMv8 Crypto Extensions"
> >         depends on KERNEL_MODE_NEON
> >         select CRYPTO_SKCIPHER
> >         select CRYPTO_AES_ARM64_CE
> >
> >  config CRYPTO_AES_ARM64_NEON_BLK
> > -       tristate "AES in ECB/CBC/CTR/XTS modes using NEON instructions"
> > +       tristate "AES in ECB/CBC/CTR/XTS/XCTR modes using NEON instructions"
> >         depends on KERNEL_MODE_NEON
> >         select CRYPTO_SKCIPHER
> >         select CRYPTO_LIB_AES
> > diff --git a/arch/arm64/crypto/aes-glue.c b/arch/arm64/crypto/aes-glue.c
> > index 30b7cc6a7079..377f8d8369fb 100644
> > --- a/arch/arm64/crypto/aes-glue.c
> > +++ b/arch/arm64/crypto/aes-glue.c
> > @@ -35,10 +35,11 @@
> >  #define aes_essiv_cbc_encrypt  ce_aes_essiv_cbc_encrypt
> >  #define aes_essiv_cbc_decrypt  ce_aes_essiv_cbc_decrypt
> >  #define aes_ctr_encrypt                ce_aes_ctr_encrypt
> > +#define aes_xctr_encrypt       ce_aes_xctr_encrypt
> >  #define aes_xts_encrypt                ce_aes_xts_encrypt
> >  #define aes_xts_decrypt                ce_aes_xts_decrypt
> >  #define aes_mac_update         ce_aes_mac_update
> > -MODULE_DESCRIPTION("AES-ECB/CBC/CTR/XTS using ARMv8 Crypto Extensions");
> > +MODULE_DESCRIPTION("AES-ECB/CBC/CTR/XTS/XCTR using ARMv8 Crypto Extensions");
> >  #else
> >  #define MODE                   "neon"
> >  #define PRIO                   200
> > @@ -52,16 +53,18 @@ MODULE_DESCRIPTION("AES-ECB/CBC/CTR/XTS using ARMv8 Crypto Extensions");
> >  #define aes_essiv_cbc_encrypt  neon_aes_essiv_cbc_encrypt
> >  #define aes_essiv_cbc_decrypt  neon_aes_essiv_cbc_decrypt
> >  #define aes_ctr_encrypt                neon_aes_ctr_encrypt
> > +#define aes_xctr_encrypt       neon_aes_xctr_encrypt
> >  #define aes_xts_encrypt                neon_aes_xts_encrypt
> >  #define aes_xts_decrypt                neon_aes_xts_decrypt
> >  #define aes_mac_update         neon_aes_mac_update
> > -MODULE_DESCRIPTION("AES-ECB/CBC/CTR/XTS using ARMv8 NEON");
> > +MODULE_DESCRIPTION("AES-ECB/CBC/CTR/XTS/XCTR using ARMv8 NEON");
> >  #endif
> >  #if defined(USE_V8_CRYPTO_EXTENSIONS) || !IS_ENABLED(CONFIG_CRYPTO_AES_ARM64_BS)
> >  MODULE_ALIAS_CRYPTO("ecb(aes)");
> >  MODULE_ALIAS_CRYPTO("cbc(aes)");
> >  MODULE_ALIAS_CRYPTO("ctr(aes)");
> >  MODULE_ALIAS_CRYPTO("xts(aes)");
> > +MODULE_ALIAS_CRYPTO("xctr(aes)");
> >  #endif
> >  MODULE_ALIAS_CRYPTO("cts(cbc(aes))");
> >  MODULE_ALIAS_CRYPTO("essiv(cbc(aes),sha256)");
> > @@ -91,6 +94,10 @@ asmlinkage void aes_cbc_cts_decrypt(u8 out[], u8 const in[], u32 const rk[],
> >  asmlinkage void aes_ctr_encrypt(u8 out[], u8 const in[], u32 const rk[],
> >                                 int rounds, int bytes, u8 ctr[], u8 finalbuf[]);
> >
> > +asmlinkage void aes_xctr_encrypt(u8 out[], u8 const in[], u32 const rk[],
> > +                                int rounds, int bytes, u8 ctr[], u8 finalbuf[],
> > +                                int byte_ctr);
> > +
> >  asmlinkage void aes_xts_encrypt(u8 out[], u8 const in[], u32 const rk1[],
> >                                 int rounds, int bytes, u32 const rk2[], u8 iv[],
> >                                 int first);
> > @@ -444,6 +451,49 @@ static int __maybe_unused essiv_cbc_decrypt(struct skcipher_request *req)
> >         return err ?: cbc_decrypt_walk(req, &walk);
> >  }
> >
> > +static int __maybe_unused xctr_encrypt(struct skcipher_request *req)
> > +{
> > +       struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
> > +       struct crypto_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
> > +       int err, rounds = 6 + ctx->key_length / 4;
> > +       struct skcipher_walk walk;
> > +       unsigned int byte_ctr = 0;
> > +
> > +       err = skcipher_walk_virt(&walk, req, false);
> > +
> > +       while (walk.nbytes > 0) {
> > +               const u8 *src = walk.src.virt.addr;
> > +               unsigned int nbytes = walk.nbytes;
> > +               u8 *dst = walk.dst.virt.addr;
> > +               u8 buf[AES_BLOCK_SIZE];
> > +               unsigned int tail;
> > +
> > +               if (unlikely(nbytes < AES_BLOCK_SIZE))
> > +                       src = memcpy(buf, src, nbytes);
> > +               else if (nbytes < walk.total)
> > +                       nbytes &= ~(AES_BLOCK_SIZE - 1);
> > +
> > +               kernel_neon_begin();
> > +               aes_xctr_encrypt(dst, src, ctx->key_enc, rounds, nbytes,
> > +                                                walk.iv, buf, byte_ctr);
> > +               kernel_neon_end();
> > +
> > +               tail = nbytes % (STRIDE * AES_BLOCK_SIZE);
> > +               if (tail > 0 && tail < AES_BLOCK_SIZE)
> > +                       /*
> > +                        * The final partial block could not be returned using
> > +                        * an overlapping store, so it was passed via buf[]
> > +                        * instead.
> > +                        */
> > +                       memcpy(dst + nbytes - tail, buf, tail);
>
> I have a patch [0] that elides this memcpy() for the CTR routine if
> the input is more than a block. It's independent of this one, of
> course, but for symmetry, it would make sense to do the same.
>
> [0] https://lore.kernel.org/r/20220127095211.3481959-1-ardb@kernel.org
>

This is now in Herbert's tree. If it helps, my fixup for this patch is here:
https://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git/log/?h=hctr2
