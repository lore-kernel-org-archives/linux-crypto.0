Return-Path: <SRS0=Ue/q=WF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB872C433FF
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 17:20:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 763D42085B
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 17:20:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MSqnG/0z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407549AbfHIRUU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Aug 2019 13:20:20 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38366 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407548AbfHIRUT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Aug 2019 13:20:19 -0400
Received: by mail-wr1-f68.google.com with SMTP id g17so98921347wrr.5
        for <linux-crypto@vger.kernel.org>; Fri, 09 Aug 2019 10:20:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XcBqfxqF4uZ8aGdcjdb4fUSrpyKrObZVNY/bzXq9uE4=;
        b=MSqnG/0zF7NGGLuPabMSeyiegyZeRZuir+zlMWuK2lL9pHQ5EJ2LovANGVIWKByC+q
         RD56M4a0TonAHHoilFGvvistNBKV/uUcDZwBsGl72esOHrEsv9M4AHyCWki+HPcbYdNC
         aMQd7mg7Fz9jCNH3SllzfCfPk5K1uSDQKHS8xhHaQ7G+GDfxRfhxkd+JkvfNN4JHsg8A
         GbMtnU5vbJjaPqtFg0+2eHnXNxY1uTI2ZU6sFy8FFyEs2+7hHtL8DELUUxMCw1vaeXjW
         6WpMVO5DeAoBGwBh8LqTRC/O3IKEuTuB0ueK5U7wiVhMwlbnQB6mwJNZGYVK6mZSbqh7
         X0Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XcBqfxqF4uZ8aGdcjdb4fUSrpyKrObZVNY/bzXq9uE4=;
        b=BzrqzWbP7iL7jxvhAEwpOSPlgdAqNfoKIHuJsSEbvaa557CNeWFzXFTF/+AM2KJ8Tq
         udIuJvkP2/6jmyNQr8D2kIXEQrxHQ3jn7RCDCRaW/z9eCmmar1klk9Yx9X8KuIKRXoFM
         JqbO2fmg1LbO04hELReyyl0fzxJqz4nUW6x947Hp+b7Md0GHwWxEotUN+IMT5/RMxjgF
         ie/UHvHD/jBGkwdbpNFsSqUu+YCz9BRTNE8Q7NO6l46KCPwr0/PYPszwU4ZPRcDlPxbN
         zKt2MfmUAwNme7VkRezb0+kr4N/mhixnuBbABFpdXY75qKbZsTX5xMzxIfZFDEyyFQDz
         y8hQ==
X-Gm-Message-State: APjAAAX3Ag5zfatBMkwyehlSjEKZwM3xrZ/b+z1Ner9M+5r2B+tft9hk
        muKfcSgZ8jdSJnp5UbM46k5M/OBo20Yl5kNqFy5I8Q==
X-Google-Smtp-Source: APXvYqxcW6/EFV2Igjw+LO2QWAFXJOZtf05wqlGpdE+85Emn6l77JMz4IyEskQWV7eOOGkaruo9O8odY8XPM9nBKCrE=
X-Received: by 2002:a5d:6b07:: with SMTP id v7mr14534858wrw.169.1565371216341;
 Fri, 09 Aug 2019 10:20:16 -0700 (PDT)
MIME-Version: 1.0
References: <20190802151510.17074-1-ard.biesheuvel@linaro.org>
 <20190802151510.17074-4-ard.biesheuvel@linaro.org> <CAKwvOdmUcp-ZY2rNrCZ10_GPyVureKip8XKCfA13mPDW=9pgXQ@mail.gmail.com>
In-Reply-To: <CAKwvOdmUcp-ZY2rNrCZ10_GPyVureKip8XKCfA13mPDW=9pgXQ@mail.gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 9 Aug 2019 20:20:05 +0300
Message-ID: <CAKv+Gu-=cKtmZODozOKrH9cGKL_AehrJ_KBY7=EX=17KFVxNpQ@mail.gmail.com>
Subject: Re: [PATCH RFC 3/3] crypto: arm64/aegis128 - implement plain NEON version
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>, Tri Vo <trong@google.com>,
        Petr Hosek <phosek@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 9 Aug 2019 at 01:31, Nick Desaulniers <ndesaulniers@google.com> wrote:
>
> On Fri, Aug 2, 2019 at 8:15 AM Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> >
> > Provide a version of the core AES transform to the aegis128 SIMD
> > code that does not rely on the special AES instructions, but uses
> > plain NEON instructions instead. This allows the SIMD version of
> > the aegis128 driver to be used on arm64 systems that do not
> > implement those instructions (which are not mandatory in the
> > architecture), such as the Raspberry Pi 3.
> >
> > Cc: Nick Desaulniers <ndesaulniers@google.com>
>
> Thanks for the heads up, thoughts below:
>
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > ---
> >  crypto/Makefile              |  5 ++
> >  crypto/aegis128-neon-inner.c | 53 ++++++++++++++++++++
> >  crypto/aegis128-neon.c       | 16 +++++-
> >  3 files changed, 73 insertions(+), 1 deletion(-)
> >
> > diff --git a/crypto/Makefile b/crypto/Makefile
> > index 99a9fa9087d1..c3760c7616ac 100644
> > --- a/crypto/Makefile
> > +++ b/crypto/Makefile
> > @@ -99,6 +99,11 @@ aegis128-$(CONFIG_CRYPTO_AEGIS128_SIMD) += aegis128-neon.o aegis128-neon-inner.o
> >  endif
> >  ifeq ($(ARCH),arm64)
> >  CFLAGS_aegis128-neon-inner.o += -ffreestanding -mcpu=generic+crypto
> > +CFLAGS_aegis128-neon-inner.o += -ffixed-q14 -ffixed-q15
> > +CFLAGS_aegis128-neon-inner.o += -ffixed-q16 -ffixed-q17 -ffixed-q18 -ffixed-q19
> > +CFLAGS_aegis128-neon-inner.o += -ffixed-q20 -ffixed-q21 -ffixed-q22 -ffixed-q23
> > +CFLAGS_aegis128-neon-inner.o += -ffixed-q24 -ffixed-q25 -ffixed-q26 -ffixed-q27
> > +CFLAGS_aegis128-neon-inner.o += -ffixed-q28 -ffixed-q29 -ffixed-q30 -ffixed-q31
>
> So Tri implemented support for -ffixed-x*, but Clang currently lacks
> support for -ffixed-q*.  Petr recently made this slightly more
> generic:
> https://reviews.llvm.org/D56305
> but Clang still doesn't allow specifying any register number + width
> for each supported arch.  The arm64 support for x registers was
> manually added.
>
> I'm guessing that for arm64 that if:
> * w* is 32b registers
> * x* is 64b registers
> then:
> * q* is 128b NEON registers?
>
> I'm curious as to why we need to reserve these registers when calling
> functions in this TU?  I assume this has to do with the calling
> convention for uint8x16_t?  Can you point me to documentation about
> that (that way I can reference in any patch to Clang/LLVM)?
>

This is to allow the AES sbox to remain loaded in registers.
Otherwise, the compiler will reload all 256 bytes into 16 NEON
registers for every AES block processed, which is suboptimal.

> >  CFLAGS_REMOVE_aegis128-neon-inner.o += -mgeneral-regs-only
> >  aegis128-$(CONFIG_CRYPTO_AEGIS128_SIMD) += aegis128-neon.o aegis128-neon-inner.o
> >  endif
> > diff --git a/crypto/aegis128-neon-inner.c b/crypto/aegis128-neon-inner.c
> > index 6aca2f425b6d..7aa4cef3c2de 100644
> > --- a/crypto/aegis128-neon-inner.c
> > +++ b/crypto/aegis128-neon-inner.c
> > @@ -17,6 +17,8 @@
> >
> >  #include <stddef.h>
> >
> > +extern int aegis128_have_aes_insn;
> > +
> >  void *memcpy(void *dest, const void *src, size_t n);
> >  void *memset(void *s, int c, size_t n);
> >
> > @@ -49,6 +51,32 @@ uint8x16_t aegis_aes_round(uint8x16_t w)
> >  {
> >         uint8x16_t z = {};
> >
> > +#ifdef CONFIG_ARM64
> > +       if (!__builtin_expect(aegis128_have_aes_insn, 1)) {
>
> Can we use a likely/unlikely here?  It always takes me a minute to decode these.
>

I am avoiding ordinary kernel headers in this TU, so not really.

> > +               uint8x16_t v;
> > +
> > +               // shift rows
> > +               asm("tbl %0.16b, {%0.16b}, v14.16b" : "+w"(w));
> > +
> > +               // sub bytes
> > +               asm("tbl %0.16b, {v16.16b-v19.16b}, %1.16b" : "=w"(v) : "w"(w));
> > +               w -= 0x40;
> > +               asm("tbx %0.16b, {v20.16b-v23.16b}, %1.16b" : "+w"(v) : "w"(w));
> > +               w -= 0x40;
> > +               asm("tbx %0.16b, {v24.16b-v27.16b}, %1.16b" : "+w"(v) : "w"(w));
> > +               w -= 0x40;
> > +               asm("tbx %0.16b, {v28.16b-v31.16b}, %1.16b" : "+w"(v) : "w"(w));
> > +
> > +               // mix columns
> > +               w = (v << 1) ^ (uint8x16_t)(((int8x16_t)v >> 7) & 0x1b);
>
> What does it mean to right shift a int8x16_t?  Is that elementwise
> right shift or do the bits shift from one element to another?
>

Element wise. This applies to all uint8x16_t arithmetic, which is kind
of the point.

> > +               w ^= (uint8x16_t)vrev32q_u16((uint16x8_t)v);
> > +               asm("tbl %0.16b, {%1.16b}, v15.16b" : "=w"(v) : "w"(v ^ w));
> > +               w ^= v;
> > +
> > +               return w;
> > +       }
> > +#endif
> > +
> >         /*
> >          * We use inline asm here instead of the vaeseq_u8/vaesmcq_u8 intrinsics
> >          * to force the compiler to issue the aese/aesmc instructions in pairs.
> > @@ -149,3 +177,28 @@ void crypto_aegis128_decrypt_chunk_neon(void *state, void *dst, const void *src,
> >
> >         aegis128_save_state_neon(st, state);
> >  }
> > +
> > +#ifdef CONFIG_ARM64
> > +void crypto_aegis128_init_neon(void)
> > +{
> > +       u64 tmp;
> > +
> > +       asm volatile(
> > +           "adrp               %0, crypto_aes_sbox             \n\t"
> > +           "add                %0, %0, :lo12:crypto_aes_sbox   \n\t"
> > +           "mov                v14.16b, %1.16b                 \n\t"
> > +           "mov                v15.16b, %2.16b                 \n\t"
> > +           "ld1                {v16.16b-v19.16b}, [%0], #64    \n\t"
> > +           "ld1                {v20.16b-v23.16b}, [%0], #64    \n\t"
> > +           "ld1                {v24.16b-v27.16b}, [%0], #64    \n\t"
> > +           "ld1                {v28.16b-v31.16b}, [%0]         \n\t"
> > +           : "=&r"(tmp)
> > +           : "w"((uint8x16_t){ // shift rows permutation vector
> > +                       0x0, 0x5, 0xa, 0xf, 0x4, 0x9, 0xe, 0x3,
> > +                       0x8, 0xd, 0x2, 0x7, 0xc, 0x1, 0x6, 0xb, }),
> > +             "w"((uint8x16_t){ // ror32 permutation vector
> > +                       0x1, 0x2, 0x3, 0x0, 0x5, 0x6, 0x7, 0x4,
> > +                       0x9, 0xa, 0xb, 0x8, 0xd, 0xe, 0xf, 0xc, })
> > +       );
> > +}
> > +#endif
> > diff --git a/crypto/aegis128-neon.c b/crypto/aegis128-neon.c
> > index c1c0a1686f67..72f9d48e4963 100644
> > --- a/crypto/aegis128-neon.c
> > +++ b/crypto/aegis128-neon.c
> > @@ -14,14 +14,24 @@ void crypto_aegis128_encrypt_chunk_neon(void *state, void *dst, const void *src,
> >  void crypto_aegis128_decrypt_chunk_neon(void *state, void *dst, const void *src,
> >                                         unsigned int size);
> >
> > +void crypto_aegis128_init_neon(void);
> > +
> > +int aegis128_have_aes_insn __ro_after_init;
> > +
> >  bool crypto_aegis128_have_simd(void)
> >  {
> > -       return cpu_have_feature(cpu_feature(AES));
> > +       if (cpu_have_feature(cpu_feature(AES))) {
> > +               aegis128_have_aes_insn = 1;
> > +               return true;
>
> This could just fall through right? (if you removed the return
> statement, I assume IS_ENABLED doesn't have runtime overhead but is
> just a preprocessor check?)
>

No. This code can be built for 32-bit ARM as well, in which case we
can only use the AES instructions.

> > +       }
> > +       return IS_ENABLED(CONFIG_ARM64);
> >  }
> >
> >  void crypto_aegis128_update_simd(union aegis_block *state, const void *msg)
> >  {
> >         kernel_neon_begin();
> > +       if (IS_ENABLED(CONFIG_ARM64) && !aegis128_have_aes_insn)
> > +               crypto_aegis128_init_neon();
> >         crypto_aegis128_update_neon(state, msg);
> >         kernel_neon_end();
> >  }
> > @@ -30,6 +40,8 @@ void crypto_aegis128_encrypt_chunk_simd(union aegis_block *state, u8 *dst,
> >                                         const u8 *src, unsigned int size)
> >  {
> >         kernel_neon_begin();
> > +       if (IS_ENABLED(CONFIG_ARM64) && !aegis128_have_aes_insn)
> > +               crypto_aegis128_init_neon();
> >         crypto_aegis128_encrypt_chunk_neon(state, dst, src, size);
> >         kernel_neon_end();
> >  }
> > @@ -38,6 +50,8 @@ void crypto_aegis128_decrypt_chunk_simd(union aegis_block *state, u8 *dst,
> >                                         const u8 *src, unsigned int size)
> >  {
> >         kernel_neon_begin();
> > +       if (IS_ENABLED(CONFIG_ARM64) && !aegis128_have_aes_insn)
> > +               crypto_aegis128_init_neon();
> >         crypto_aegis128_decrypt_chunk_neon(state, dst, src, size);
> >         kernel_neon_end();
> >  }
> > --
> > 2.17.1
> >
>
>
> --
> Thanks,
> ~Nick Desaulniers
