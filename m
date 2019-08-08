Return-Path: <SRS0=IdBJ=WE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 903D8C0650F
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Aug 2019 22:31:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D275216C8
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Aug 2019 22:31:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uCjhPwBH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404609AbfHHWbQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 8 Aug 2019 18:31:16 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:41183 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbfHHWbQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 8 Aug 2019 18:31:16 -0400
Received: by mail-pf1-f196.google.com with SMTP id m30so44903446pff.8
        for <linux-crypto@vger.kernel.org>; Thu, 08 Aug 2019 15:31:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gct7jHxnJiag3zfAZQNLD7NXNJZgBOVfWKykKzLCdk4=;
        b=uCjhPwBHdacmE+FqZFUGsXuP3wXrgZHv1Xbd1eFZC04tAAY6tpwGaFf61OMtlbm3XT
         FvYCyNwSsUedl/L8SqjZabD6qBHJ4CC+64gUj1JiAZyW1KU0ozOfC7tBPYbK0E1tMWj5
         t1jOtdETAD35SjqQ4NHFTWI6NY7njqJK2M79CLTd7zLeHtr2sn4WO8yytPQW7Ro2ynky
         2vsS2HbCU5NhUl62nk/NXH5miOuHJBcgi+EIXUZncwN0T8UHfIYEeos1hlA+zV9ihznJ
         m1KNkxclXIoLFy/lIsVZShdyDl1r56ztAhcruZ7deUai4+B0kPtGolSK+QOMPrRZyXe/
         j+fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gct7jHxnJiag3zfAZQNLD7NXNJZgBOVfWKykKzLCdk4=;
        b=dj+bwbcsBtcAcIrrUNQKiIwMR1NBcQy6e8jXFiJXbxtr2EmVTBbqYyiuOeEizuEoqp
         X3og2G0zPe+tb8uqCzuhi5KeaFOqcBjM1mbb3sDtZun/8CXgnYuO7zM9dmzlQw2NyPsS
         PhGUqyVn0l9I3jAPlBqpE5bz2KM4MRQosNji7P8UR0HxjPGf+hg0K/Rs0UWBIOmeceQI
         dq3bOzBJyU+yvLDTly23Y5o3BerCQopAG5n77KdOhx7+i9SRHqr5kCfDpZZWvrdeAAoe
         +INiArnW2q4dqSd2zH+r17WoUWPtF7H4amfXyqwFwtr72j3lmyS7nMduAZTGfXm1SNiK
         qP+A==
X-Gm-Message-State: APjAAAWou58hjerg7W9Ni3jyq4T735INbI93cvkuWyr1H3pMAnpm6ARD
        KdiDOwS+xaniXVJKJksfXXoMBKTu0/Jq2gLNd/eVRA==
X-Google-Smtp-Source: APXvYqzG/fRlnYE+M/qhg7Ng4MMneHn6U31l2kiglfm0zmKN/yX7DAnSwkSEN+pFVatZowIj1+UMwBRx6RiU/REJU/w=
X-Received: by 2002:a17:90a:ac11:: with SMTP id o17mr6344745pjq.134.1565303474374;
 Thu, 08 Aug 2019 15:31:14 -0700 (PDT)
MIME-Version: 1.0
References: <20190802151510.17074-1-ard.biesheuvel@linaro.org> <20190802151510.17074-4-ard.biesheuvel@linaro.org>
In-Reply-To: <20190802151510.17074-4-ard.biesheuvel@linaro.org>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Thu, 8 Aug 2019 15:31:02 -0700
Message-ID: <CAKwvOdmUcp-ZY2rNrCZ10_GPyVureKip8XKCfA13mPDW=9pgXQ@mail.gmail.com>
Subject: Re: [PATCH RFC 3/3] crypto: arm64/aegis128 - implement plain NEON version
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>, Tri Vo <trong@google.com>,
        Petr Hosek <phosek@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Aug 2, 2019 at 8:15 AM Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
> Provide a version of the core AES transform to the aegis128 SIMD
> code that does not rely on the special AES instructions, but uses
> plain NEON instructions instead. This allows the SIMD version of
> the aegis128 driver to be used on arm64 systems that do not
> implement those instructions (which are not mandatory in the
> architecture), such as the Raspberry Pi 3.
>
> Cc: Nick Desaulniers <ndesaulniers@google.com>

Thanks for the heads up, thoughts below:

> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  crypto/Makefile              |  5 ++
>  crypto/aegis128-neon-inner.c | 53 ++++++++++++++++++++
>  crypto/aegis128-neon.c       | 16 +++++-
>  3 files changed, 73 insertions(+), 1 deletion(-)
>
> diff --git a/crypto/Makefile b/crypto/Makefile
> index 99a9fa9087d1..c3760c7616ac 100644
> --- a/crypto/Makefile
> +++ b/crypto/Makefile
> @@ -99,6 +99,11 @@ aegis128-$(CONFIG_CRYPTO_AEGIS128_SIMD) += aegis128-neon.o aegis128-neon-inner.o
>  endif
>  ifeq ($(ARCH),arm64)
>  CFLAGS_aegis128-neon-inner.o += -ffreestanding -mcpu=generic+crypto
> +CFLAGS_aegis128-neon-inner.o += -ffixed-q14 -ffixed-q15
> +CFLAGS_aegis128-neon-inner.o += -ffixed-q16 -ffixed-q17 -ffixed-q18 -ffixed-q19
> +CFLAGS_aegis128-neon-inner.o += -ffixed-q20 -ffixed-q21 -ffixed-q22 -ffixed-q23
> +CFLAGS_aegis128-neon-inner.o += -ffixed-q24 -ffixed-q25 -ffixed-q26 -ffixed-q27
> +CFLAGS_aegis128-neon-inner.o += -ffixed-q28 -ffixed-q29 -ffixed-q30 -ffixed-q31

So Tri implemented support for -ffixed-x*, but Clang currently lacks
support for -ffixed-q*.  Petr recently made this slightly more
generic:
https://reviews.llvm.org/D56305
but Clang still doesn't allow specifying any register number + width
for each supported arch.  The arm64 support for x registers was
manually added.

I'm guessing that for arm64 that if:
* w* is 32b registers
* x* is 64b registers
then:
* q* is 128b NEON registers?

I'm curious as to why we need to reserve these registers when calling
functions in this TU?  I assume this has to do with the calling
convention for uint8x16_t?  Can you point me to documentation about
that (that way I can reference in any patch to Clang/LLVM)?

>  CFLAGS_REMOVE_aegis128-neon-inner.o += -mgeneral-regs-only
>  aegis128-$(CONFIG_CRYPTO_AEGIS128_SIMD) += aegis128-neon.o aegis128-neon-inner.o
>  endif
> diff --git a/crypto/aegis128-neon-inner.c b/crypto/aegis128-neon-inner.c
> index 6aca2f425b6d..7aa4cef3c2de 100644
> --- a/crypto/aegis128-neon-inner.c
> +++ b/crypto/aegis128-neon-inner.c
> @@ -17,6 +17,8 @@
>
>  #include <stddef.h>
>
> +extern int aegis128_have_aes_insn;
> +
>  void *memcpy(void *dest, const void *src, size_t n);
>  void *memset(void *s, int c, size_t n);
>
> @@ -49,6 +51,32 @@ uint8x16_t aegis_aes_round(uint8x16_t w)
>  {
>         uint8x16_t z = {};
>
> +#ifdef CONFIG_ARM64
> +       if (!__builtin_expect(aegis128_have_aes_insn, 1)) {

Can we use a likely/unlikely here?  It always takes me a minute to decode these.

> +               uint8x16_t v;
> +
> +               // shift rows
> +               asm("tbl %0.16b, {%0.16b}, v14.16b" : "+w"(w));
> +
> +               // sub bytes
> +               asm("tbl %0.16b, {v16.16b-v19.16b}, %1.16b" : "=w"(v) : "w"(w));
> +               w -= 0x40;
> +               asm("tbx %0.16b, {v20.16b-v23.16b}, %1.16b" : "+w"(v) : "w"(w));
> +               w -= 0x40;
> +               asm("tbx %0.16b, {v24.16b-v27.16b}, %1.16b" : "+w"(v) : "w"(w));
> +               w -= 0x40;
> +               asm("tbx %0.16b, {v28.16b-v31.16b}, %1.16b" : "+w"(v) : "w"(w));
> +
> +               // mix columns
> +               w = (v << 1) ^ (uint8x16_t)(((int8x16_t)v >> 7) & 0x1b);

What does it mean to right shift a int8x16_t?  Is that elementwise
right shift or do the bits shift from one element to another?

> +               w ^= (uint8x16_t)vrev32q_u16((uint16x8_t)v);
> +               asm("tbl %0.16b, {%1.16b}, v15.16b" : "=w"(v) : "w"(v ^ w));
> +               w ^= v;
> +
> +               return w;
> +       }
> +#endif
> +
>         /*
>          * We use inline asm here instead of the vaeseq_u8/vaesmcq_u8 intrinsics
>          * to force the compiler to issue the aese/aesmc instructions in pairs.
> @@ -149,3 +177,28 @@ void crypto_aegis128_decrypt_chunk_neon(void *state, void *dst, const void *src,
>
>         aegis128_save_state_neon(st, state);
>  }
> +
> +#ifdef CONFIG_ARM64
> +void crypto_aegis128_init_neon(void)
> +{
> +       u64 tmp;
> +
> +       asm volatile(
> +           "adrp               %0, crypto_aes_sbox             \n\t"
> +           "add                %0, %0, :lo12:crypto_aes_sbox   \n\t"
> +           "mov                v14.16b, %1.16b                 \n\t"
> +           "mov                v15.16b, %2.16b                 \n\t"
> +           "ld1                {v16.16b-v19.16b}, [%0], #64    \n\t"
> +           "ld1                {v20.16b-v23.16b}, [%0], #64    \n\t"
> +           "ld1                {v24.16b-v27.16b}, [%0], #64    \n\t"
> +           "ld1                {v28.16b-v31.16b}, [%0]         \n\t"
> +           : "=&r"(tmp)
> +           : "w"((uint8x16_t){ // shift rows permutation vector
> +                       0x0, 0x5, 0xa, 0xf, 0x4, 0x9, 0xe, 0x3,
> +                       0x8, 0xd, 0x2, 0x7, 0xc, 0x1, 0x6, 0xb, }),
> +             "w"((uint8x16_t){ // ror32 permutation vector
> +                       0x1, 0x2, 0x3, 0x0, 0x5, 0x6, 0x7, 0x4,
> +                       0x9, 0xa, 0xb, 0x8, 0xd, 0xe, 0xf, 0xc, })
> +       );
> +}
> +#endif
> diff --git a/crypto/aegis128-neon.c b/crypto/aegis128-neon.c
> index c1c0a1686f67..72f9d48e4963 100644
> --- a/crypto/aegis128-neon.c
> +++ b/crypto/aegis128-neon.c
> @@ -14,14 +14,24 @@ void crypto_aegis128_encrypt_chunk_neon(void *state, void *dst, const void *src,
>  void crypto_aegis128_decrypt_chunk_neon(void *state, void *dst, const void *src,
>                                         unsigned int size);
>
> +void crypto_aegis128_init_neon(void);
> +
> +int aegis128_have_aes_insn __ro_after_init;
> +
>  bool crypto_aegis128_have_simd(void)
>  {
> -       return cpu_have_feature(cpu_feature(AES));
> +       if (cpu_have_feature(cpu_feature(AES))) {
> +               aegis128_have_aes_insn = 1;
> +               return true;

This could just fall through right? (if you removed the return
statement, I assume IS_ENABLED doesn't have runtime overhead but is
just a preprocessor check?)

> +       }
> +       return IS_ENABLED(CONFIG_ARM64);
>  }
>
>  void crypto_aegis128_update_simd(union aegis_block *state, const void *msg)
>  {
>         kernel_neon_begin();
> +       if (IS_ENABLED(CONFIG_ARM64) && !aegis128_have_aes_insn)
> +               crypto_aegis128_init_neon();
>         crypto_aegis128_update_neon(state, msg);
>         kernel_neon_end();
>  }
> @@ -30,6 +40,8 @@ void crypto_aegis128_encrypt_chunk_simd(union aegis_block *state, u8 *dst,
>                                         const u8 *src, unsigned int size)
>  {
>         kernel_neon_begin();
> +       if (IS_ENABLED(CONFIG_ARM64) && !aegis128_have_aes_insn)
> +               crypto_aegis128_init_neon();
>         crypto_aegis128_encrypt_chunk_neon(state, dst, src, size);
>         kernel_neon_end();
>  }
> @@ -38,6 +50,8 @@ void crypto_aegis128_decrypt_chunk_simd(union aegis_block *state, u8 *dst,
>                                         const u8 *src, unsigned int size)
>  {
>         kernel_neon_begin();
> +       if (IS_ENABLED(CONFIG_ARM64) && !aegis128_have_aes_insn)
> +               crypto_aegis128_init_neon();
>         crypto_aegis128_decrypt_chunk_neon(state, dst, src, size);
>         kernel_neon_end();
>  }
> --
> 2.17.1
>


-- 
Thanks,
~Nick Desaulniers
