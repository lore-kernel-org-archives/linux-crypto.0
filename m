Return-Path: <SRS0=anrJ=M4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D0D1C5ACC6
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Oct 2018 22:37:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E65A82148D
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Oct 2018 22:37:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="BcwS90TZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E65A82148D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbeJQGaG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 17 Oct 2018 02:30:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:41562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726955AbeJQGaG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Oct 2018 02:30:06 -0400
Received: from gmail.com (unknown [104.132.51.88])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 251CB21471;
        Tue, 16 Oct 2018 22:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1539729453;
        bh=nRCue6l8mMnF5OtXEA5ekqYzJeWpMzHcRgZo6eC3ae0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BcwS90TZ3SgvQeNUetNYxk9eCsww0FD2rvmiwPtKCU4gdsfIzQOJ45ZTLGWwY4EiX
         im28ESQkBT2fzOtAWJJutkAu0F03ivIHoca0BqQhTS8zN9lcpQe+Lgvar0XeOnXcCw
         ZN/L3IAuvQfUVjc6UEuE6GXelBoG4bm6/RI0rfoY=
Date:   Tue, 16 Oct 2018 15:37:31 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Paul Crowley <paulcrowley@google.com>
Subject: Re: [PATCH] crypto: aes_ti - disable interrupts while accessing sbox
Message-ID: <20181016223730.GA26061@gmail.com>
References: <20181004040711.29021-1-ebiggers@kernel.org>
 <CAKv+Gu9XzQPGo7OBMd5h+KA9tLQEfUVK9D5kNMdfGk3pe=VH+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9XzQPGo7OBMd5h+KA9tLQEfUVK9D5kNMdfGk3pe=VH+Q@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181016223731.faZ_yYNN3smMo2lMeQ3FGf931FxHOGD3VMr7U5aTLa8@z>

Hi Ard,

On Thu, Oct 04, 2018 at 08:55:14AM +0200, Ard Biesheuvel wrote:
> Hi Eric,
> 
> On 4 October 2018 at 06:07, Eric Biggers <ebiggers@kernel.org> wrote:
> > From: Eric Biggers <ebiggers@google.com>
> >
> > The generic constant-time AES implementation is supposed to preload the
> > AES S-box into the CPU's L1 data cache.  But, an interrupt handler can
> > run on the CPU and muck with the cache.  Worse, on preemptible kernels
> > the process can even be preempted and moved to a different CPU.  So the
> > implementation may actually still be vulnerable to cache-timing attacks.
> >
> > Make it more robust by disabling interrupts while the sbox is used.
> >
> > In some quick tests on x86 and ARM, this doesn't affect performance
> > significantly.  Responsiveness is also a concern, but interrupts are
> > only disabled for a single AES block which even on ARM Cortex-A7 is
> > "only" ~1500 cycles to encrypt or ~2600 cycles to decrypt.
> >
> 
> I share your concern, but that is quite a big hammer.
> 
> Also, does it really take ~100 cycles per byte? That is terrible :-)
> 
> Given that the full lookup table is only 1024 bytes (or 1024+256 bytes
> for decryption), I wonder if something like the below would be a
> better option for A7 (apologies for the mangled whitespace)
> 
> diff --git a/arch/arm/crypto/aes-cipher-core.S
> b/arch/arm/crypto/aes-cipher-core.S
> index 184d6c2d15d5..83e893f7e581 100644
> --- a/arch/arm/crypto/aes-cipher-core.S
> +++ b/arch/arm/crypto/aes-cipher-core.S
> @@ -139,6 +139,13 @@
> 
>   __adrl ttab, \ttab
> 
> + .irpc r, 01234567
> + ldr r8, [ttab, #(32 * \r)]
> + ldr r9, [ttab, #(32 * \r) + 256]
> + ldr r10, [ttab, #(32 * \r) + 512]
> + ldr r11, [ttab, #(32 * \r) + 768]
> + .endr
> +
>   tst rounds, #2
>   bne 1f
> 
> @@ -180,6 +187,12 @@ ENDPROC(__aes_arm_encrypt)
> 
>   .align 5
>  ENTRY(__aes_arm_decrypt)
> + __adrl ttab, __aes_arm_inverse_sbox
> +
> + .irpc r, 01234567
> + ldr r8, [ttab, #(32 * \r)]
> + .endr
> +
>   do_crypt iround, crypto_it_tab, __aes_arm_inverse_sbox, 0
>  ENDPROC(__aes_arm_decrypt)
> 
> diff --git a/arch/arm/crypto/aes-cipher-glue.c
> b/arch/arm/crypto/aes-cipher-glue.c
> index c222f6e072ad..630e1a436f1d 100644
> --- a/arch/arm/crypto/aes-cipher-glue.c
> +++ b/arch/arm/crypto/aes-cipher-glue.c
> @@ -23,16 +23,22 @@ static void aes_encrypt(struct crypto_tfm *tfm, u8
> *out, const u8 *in)
>  {
>   struct crypto_aes_ctx *ctx = crypto_tfm_ctx(tfm);
>   int rounds = 6 + ctx->key_length / 4;
> + unsigned long flags;
> 
> + local_irq_save(flags);
>   __aes_arm_encrypt(ctx->key_enc, rounds, in, out);
> + local_irq_restore(flags);
>  }
> 
>  static void aes_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
>  {
>   struct crypto_aes_ctx *ctx = crypto_tfm_ctx(tfm);
>   int rounds = 6 + ctx->key_length / 4;
> + unsigned long flags;
> 
> + local_irq_save(flags);
>   __aes_arm_decrypt(ctx->key_dec, rounds, in, out);
> + local_irq_restore(flags);
>  }
> 
>  static struct crypto_alg aes_alg = {
> diff --git a/crypto/aes_generic.c b/crypto/aes_generic.c
> index ca554d57d01e..82fa860c9cb9 100644
> --- a/crypto/aes_generic.c
> +++ b/crypto/aes_generic.c
> @@ -63,7 +63,7 @@ static inline u8 byte(const u32 x, const unsigned n)
> 
>  static const u32 rco_tab[10] = { 1, 2, 4, 8, 16, 32, 64, 128, 27, 54 };
> 
> -__visible const u32 crypto_ft_tab[4][256] = {
> +__visible const u32 crypto_ft_tab[4][256] __cacheline_aligned = {
>   {
>   0xa56363c6, 0x847c7cf8, 0x997777ee, 0x8d7b7bf6,
>   0x0df2f2ff, 0xbd6b6bd6, 0xb16f6fde, 0x54c5c591,
> @@ -327,7 +327,7 @@ __visible const u32 crypto_ft_tab[4][256] = {
>   }
>  };
> 
> -__visible const u32 crypto_fl_tab[4][256] = {
> +__visible const u32 crypto_fl_tab[4][256] __cacheline_aligned = {
>   {
>   0x00000063, 0x0000007c, 0x00000077, 0x0000007b,
>   0x000000f2, 0x0000006b, 0x0000006f, 0x000000c5,
> @@ -591,7 +591,7 @@ __visible const u32 crypto_fl_tab[4][256] = {
>   }
>  };
> 
> -__visible const u32 crypto_it_tab[4][256] = {
> +__visible const u32 crypto_it_tab[4][256] __cacheline_aligned = {
>   {
>   0x50a7f451, 0x5365417e, 0xc3a4171a, 0x965e273a,
>   0xcb6bab3b, 0xf1459d1f, 0xab58faac, 0x9303e34b,
> @@ -855,7 +855,7 @@ __visible const u32 crypto_it_tab[4][256] = {
>   }
>  };
> 
> -__visible const u32 crypto_il_tab[4][256] = {
> +__visible const u32 crypto_il_tab[4][256] __cacheline_aligned = {
>   {
>   0x00000052, 0x00000009, 0x0000006a, 0x000000d5,
>   0x00000030, 0x00000036, 0x000000a5, 0x00000038,
> 

Thanks for the suggestion -- this turns out to work pretty well.  At least in a
microbenchmark, loading the larger table only slows it down by around 5%, so
it's still around 2-3 times faster than aes_ti.c on ARM Cortex-A7.  It also
noticeably improves Adiantum performance (Adiantum-XChaCha12-AES):

                             Before (cpb)    After (cpb)
Adiantum (enc), size=4096:   10.91           10.58
Adiantum (dec), size=4096:   11.04           10.62
Adiantum (enc), size=512:    18.07           15.57
Adiantum (dec), size=512:    19.10           15.83

(Those numbers are from our userspace benchmark suite:
 https://github.com/google/adiantum/benchmark/.
 The kernel implementation tends to be slightly slower, for various reasons.)

So I think we should just make the ARM scalar AES unconditionally
"constant-time".  I'll send a fixed-up version of your patch.

But I think my original patch to disable IRQs in aes_ti.c is still desired as
well, since that implementation is meant to be constant-time too.

- Eric
