Return-Path: <SRS0=O5Fb=WI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5DBBC31E40
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Aug 2019 16:50:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F3962067D
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Aug 2019 16:50:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uP1pBnlO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbfHLQuq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Aug 2019 12:50:46 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:46788 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726457AbfHLQuq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Aug 2019 12:50:46 -0400
Received: by mail-pg1-f194.google.com with SMTP id w3so12570118pgt.13
        for <linux-crypto@vger.kernel.org>; Mon, 12 Aug 2019 09:50:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xe7OSj81AXIrorJHhVBGqzs+HPz7z04FS6hjJtBqRCg=;
        b=uP1pBnlOEaRqBIWz8ekRLc0wPPCgefgXri8+Pc7rUF3FzPLtIz5TodqDV7SwvWbKl7
         NAvFEkjjow46NhQOAmfJWdI55b7xCficA0IzCqCMn0oWvmSITSYHmvXQH76hUCAG+lSz
         Dr9orHACdjlzYVt4AKj+0oY2yfgn3f/53XzfFla3Mrg+MCakUJ9UNuEnsN7US+3WBRB7
         eX4twMGV9GPjWx9Fsjj9QWCnV1PKC22GApS8g5Tzzl2uGvHDkWiFwNtmBxz49Iny1vyS
         QoJWOX06e8O3kK6TU5oGhcVdJL+dSR7mO+oKv7gaLu7+1J8+KrBdWi/YemzyEwQmaQf1
         GBgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xe7OSj81AXIrorJHhVBGqzs+HPz7z04FS6hjJtBqRCg=;
        b=AbXFFt/ET/iRYE5rn6ljTyH4pnVJlMa/1giHFYJE8m5o4lcxQULw5TRz0IuaWWvanO
         Axa2v+b/XJW0OMb2LCORzjiJMImj1WXyEQn+GHg67phLg0bq3Wqge8GY0hOItU7mZ74Z
         KoWqCtaCGbxXfGsXzRWLCiqF2voWemP3klx4496weBlE0V9bhYWEBVrTm6MmAkXYOD+L
         tF6ycKBiaIf18o8/KMd5wBd9zpd1ngJOs1jNscaThb/j4SQykC5FdxZKuER+s4BMbIqs
         ZY6hLJvf0hyI0fhc++ie6orD32lf5K45QSSR8/IkArfc7tIkoWztZbVa52go7mImeq+g
         UQPw==
X-Gm-Message-State: APjAAAV36W5jAgO8kUz69hylkc+LKTJ4oIzeezKPju1tupqynOMaNlWx
        vPxfqsuFN2Lh6rHIIDwKT5fejQU+QgP4SvnJpRa8Rw==
X-Google-Smtp-Source: APXvYqxqS3mMHYUVwV9vRAYRHXBmKqCuhEnrUbTVkC3Jd3tvCvTUkwt7oIw+Xp2FHLjLZFoYXtfk17vImC5ig4Tx0Hs=
X-Received: by 2002:a17:90a:c20f:: with SMTP id e15mr158655pjt.123.1565628644998;
 Mon, 12 Aug 2019 09:50:44 -0700 (PDT)
MIME-Version: 1.0
References: <20190811225912.19412-1-ard.biesheuvel@linaro.org> <20190811225912.19412-4-ard.biesheuvel@linaro.org>
In-Reply-To: <20190811225912.19412-4-ard.biesheuvel@linaro.org>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 12 Aug 2019 09:50:33 -0700
Message-ID: <CAKwvOd=uxi8qmQEjOudvSUVW6vc42b-SmoV91DeWfBkp3kOJcQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] crypto: arm64/aegis128 - implement plain NEON version
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Aug 11, 2019 at 3:59 PM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
>
> Provide a version of the core AES transform to the aegis128 SIMD
> code that does not rely on the special AES instructions, but uses
> plain NEON instructions instead. This allows the SIMD version of
> the aegis128 driver to be used on arm64 systems that do not
> implement those instructions (which are not mandatory in the
> architecture), such as the Raspberry Pi 3.
>
> Since GCC makes a mess of this when using the tbl/tbx intrinsics
> to perform the sbox substitution, preload the Sbox into v16..v31
> in this case and use inline asm to emit the tbl/tbx instructions.
> Clang does not support this approach, nor does it require it, since
> it does a much better job at code generation, so there we use the
> intrinsics as usual.

Oh, great job getting it working with Clang, too. I appreciate that.
Certainly getting SIMD working exactly how you want across compilers
can be tricky.

>
> Cc: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  crypto/Makefile              |  9 ++-
>  crypto/aegis128-neon-inner.c | 65 ++++++++++++++++++++
>  crypto/aegis128-neon.c       |  8 ++-
>  3 files changed, 80 insertions(+), 2 deletions(-)
>
> diff --git a/crypto/Makefile b/crypto/Makefile
> index 99a9fa9087d1..0d2cdd523fd9 100644
> --- a/crypto/Makefile
> +++ b/crypto/Makefile
> @@ -98,7 +98,14 @@ CFLAGS_aegis128-neon-inner.o += -mfpu=crypto-neon-fp-armv8
>  aegis128-$(CONFIG_CRYPTO_AEGIS128_SIMD) += aegis128-neon.o aegis128-neon-inner.o
>  endif
>  ifeq ($(ARCH),arm64)
> -CFLAGS_aegis128-neon-inner.o += -ffreestanding -mcpu=generic+crypto
> +aegis128-cflags-y := -ffreestanding -mcpu=generic+crypto
> +aegis128-cflags-$(CONFIG_CC_IS_GCC) += -ffixed-q16 -ffixed-q17 -ffixed-q18 \
> +                                      -ffixed-q19 -ffixed-q20 -ffixed-q21 \
> +                                      -ffixed-q22 -ffixed-q23 -ffixed-q24 \
> +                                      -ffixed-q25 -ffixed-q26 -ffixed-q27 \
> +                                      -ffixed-q28 -ffixed-q29 -ffixed-q30 \
> +                                      -ffixed-q31

I've filed https://bugs.llvm.org/show_bug.cgi?id=42974 for a feature
request for this in Clang.

> +CFLAGS_aegis128-neon-inner.o += $(aegis128-cflags-y)
>  CFLAGS_REMOVE_aegis128-neon-inner.o += -mgeneral-regs-only
>  aegis128-$(CONFIG_CRYPTO_AEGIS128_SIMD) += aegis128-neon.o aegis128-neon-inner.o
>  endif
> diff --git a/crypto/aegis128-neon-inner.c b/crypto/aegis128-neon-inner.c
> index 3d8043c4832b..ed55568afd1b 100644
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
> @@ -24,6 +26,8 @@ struct aegis128_state {
>         uint8x16_t v[5];
>  };
>
> +extern const uint8x16x4_t crypto_aes_sbox[];

extern const uint8x16x4_t *crypto_aes_sbox;

> +
>  static struct aegis128_state aegis128_load_state_neon(const void *state)
>  {
>         return (struct aegis128_state){ {
> @@ -49,6 +53,46 @@ uint8x16_t aegis_aes_round(uint8x16_t w)
>  {
>         uint8x16_t z = {};
>
> +#ifdef CONFIG_ARM64
> +       if (!__builtin_expect(aegis128_have_aes_insn, 1)) {
> +               static const uint8x16_t shift_rows = {
> +                       0x0, 0x5, 0xa, 0xf, 0x4, 0x9, 0xe, 0x3,
> +                       0x8, 0xd, 0x2, 0x7, 0xc, 0x1, 0x6, 0xb,
> +               };
> +               static const uint8x16_t ror32by8 = {
> +                       0x1, 0x2, 0x3, 0x0, 0x5, 0x6, 0x7, 0x4,
> +                       0x9, 0xa, 0xb, 0x8, 0xd, 0xe, 0xf, 0xc,
> +               };
> +               uint8x16_t v;
> +
> +               // shift rows
> +               w = vqtbl1q_u8(w, shift_rows);
> +
> +               // sub bytes
> +               if (!IS_ENABLED(CONFIG_CC_IS_GCC)) {
> +                       v = vqtbl4q_u8(crypto_aes_sbox[0], w);
> +                       v = vqtbx4q_u8(v, crypto_aes_sbox[1], w - 0x40);
> +                       v = vqtbx4q_u8(v, crypto_aes_sbox[2], w - 0x80);
> +                       v = vqtbx4q_u8(v, crypto_aes_sbox[3], w - 0xc0);
> +               } else {
> +                       asm("tbl %0.16b, {v16.16b-v19.16b}, %1.16b" : "=w"(v) : "w"(w));
> +                       w -= 0x40;
> +                       asm("tbx %0.16b, {v20.16b-v23.16b}, %1.16b" : "+w"(v) : "w"(w));
> +                       w -= 0x40;
> +                       asm("tbx %0.16b, {v24.16b-v27.16b}, %1.16b" : "+w"(v) : "w"(w));
> +                       w -= 0x40;
> +                       asm("tbx %0.16b, {v28.16b-v31.16b}, %1.16b" : "+w"(v) : "w"(w));
> +               }

I find negation in a if condition that also has an else to be a code
smell.  Consider replacing:

if !foo:
  bar()
else:
  baz()

with:

if foo:
  baz()
else:
  bar()

(CONFIG_CC_IS_CLANG may be helpful here, too).

With those 2 recommendations:
Acked-by: Nick Desaulniers <ndesaulniers@google.com>
in regards to compiling w/ Clang.  Someone else should review the
implementation of this crypto routine.

> +
> +               // mix columns
> +               w = (v << 1) ^ (uint8x16_t)(((int8x16_t)v >> 7) & 0x1b);
> +               w ^= (uint8x16_t)vrev32q_u16((uint16x8_t)v);
> +               w ^= vqtbl1q_u8(v ^ w, ror32by8);
> +
> +               return w;
> +       }
> +#endif
> +
>         /*
>          * We use inline asm here instead of the vaeseq_u8/vaesmcq_u8 intrinsics
>          * to force the compiler to issue the aese/aesmc instructions in pairs.
> @@ -73,10 +117,27 @@ struct aegis128_state aegis128_update_neon(struct aegis128_state st,
>         return st;
>  }
>
> +static inline __attribute__((always_inline))
> +void preload_sbox(void)
> +{
> +       if (!IS_ENABLED(CONFIG_ARM64) ||
> +           !IS_ENABLED(CONFIG_CC_IS_GCC) ||
> +           __builtin_expect(aegis128_have_aes_insn, 1))
> +               return;
> +
> +       asm("ld1        {v16.16b-v19.16b}, [%0], #64    \n\t"
> +           "ld1        {v20.16b-v23.16b}, [%0], #64    \n\t"
> +           "ld1        {v24.16b-v27.16b}, [%0], #64    \n\t"
> +           "ld1        {v28.16b-v31.16b}, [%0]         \n\t"
> +           :: "r"(crypto_aes_sbox));
> +}
> +
>  void crypto_aegis128_update_neon(void *state, const void *msg)
>  {
>         struct aegis128_state st = aegis128_load_state_neon(state);
>
> +       preload_sbox();
> +
>         st = aegis128_update_neon(st, vld1q_u8(msg));
>
>         aegis128_save_state_neon(st, state);
> @@ -88,6 +149,8 @@ void crypto_aegis128_encrypt_chunk_neon(void *state, void *dst, const void *src,
>         struct aegis128_state st = aegis128_load_state_neon(state);
>         uint8x16_t msg;
>
> +       preload_sbox();
> +
>         while (size >= AEGIS_BLOCK_SIZE) {
>                 uint8x16_t s = st.v[1] ^ (st.v[2] & st.v[3]) ^ st.v[4];
>
> @@ -120,6 +183,8 @@ void crypto_aegis128_decrypt_chunk_neon(void *state, void *dst, const void *src,
>         struct aegis128_state st = aegis128_load_state_neon(state);
>         uint8x16_t msg;
>
> +       preload_sbox();
> +
>         while (size >= AEGIS_BLOCK_SIZE) {
>                 msg = vld1q_u8(src) ^ st.v[1] ^ (st.v[2] & st.v[3]) ^ st.v[4];
>                 st = aegis128_update_neon(st, msg);
> diff --git a/crypto/aegis128-neon.c b/crypto/aegis128-neon.c
> index c1c0a1686f67..751f9c195aa4 100644
> --- a/crypto/aegis128-neon.c
> +++ b/crypto/aegis128-neon.c
> @@ -14,9 +14,15 @@ void crypto_aegis128_encrypt_chunk_neon(void *state, void *dst, const void *src,
>  void crypto_aegis128_decrypt_chunk_neon(void *state, void *dst, const void *src,
>                                         unsigned int size);
>
> +int aegis128_have_aes_insn __ro_after_init;
> +
>  bool crypto_aegis128_have_simd(void)
>  {
> -       return cpu_have_feature(cpu_feature(AES));
> +       if (cpu_have_feature(cpu_feature(AES))) {
> +               aegis128_have_aes_insn = 1;

If aegis128_have_aes_insn is __ro_after_init, is
crypto_aegis128_have_simd() called exclusively from .init sectioned
code?

> +               return true;
> +       }
> +       return IS_ENABLED(CONFIG_ARM64);
>  }
>
>  void crypto_aegis128_update_simd(union aegis_block *state, const void *msg)
> --
> 2.17.1
>


-- 
Thanks,
~Nick Desaulniers
