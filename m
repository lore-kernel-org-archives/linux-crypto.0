Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47154C433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Nov 2021 15:47:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378232AbhKZPvH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Nov 2021 10:51:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232773AbhKZPtG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Nov 2021 10:49:06 -0500
X-Greylist: delayed 386 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 26 Nov 2021 07:41:37 PST
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A691C0613A5;
        Fri, 26 Nov 2021 07:41:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7FFE9B82815;
        Fri, 26 Nov 2021 15:35:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AB04C53FAD;
        Fri, 26 Nov 2021 15:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637940908;
        bh=7sGaivk9SIBD3rEdzn/r1iB88vdis4bTEwAuVWFRCvE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=uUWlqUFGnhlJn1s++MwNx1a7X5w9RGrQ4m6hkpAuyyqNQp6k6vBA9XSdN6v3SpLkQ
         KFOsQh6Qawe95gc1FRT/Ki46HivGgBrLiJZDjgSf0koIj7FqrEZgHsePAptmeXKj9V
         BHip6rWp1DJC9+3yvsp7Xygs/aQgqX/pHvZSFV5yhfAhxhY6KMrcLsFu3gbvyynC1o
         cYv7s+VOwZ1ntxvsVKSLKPCOeXqUbYX4who9W6davgumiUGNjFxTz1H2Dh3LACysZx
         45syM3eGVPcmNkzamWmF2XrIE8o8ui0TRv5DACUUi09mppkHxeuVXlAXXobGCtOtWB
         Hsgu4p20ietPQ==
Received: by mail-oi1-f171.google.com with SMTP id bk14so19505840oib.7;
        Fri, 26 Nov 2021 07:35:08 -0800 (PST)
X-Gm-Message-State: AOAM530vBrcJKKzaDTB8PIxj9HN8N9DLjR3hBa12mw3ClWmcwnAww9dO
        BGa5XlpirSrTdvv36GeT/dOvjKSNa9QpGjq7wQM=
X-Google-Smtp-Source: ABdhPJxNG3xC9NI07rXwe6DyWfvVUgUCBphev89HAiaPLfYDO1heU9rqkPr/jzYT6Bo3WlKzjuk0GnXApSegmgt4JjQ=
X-Received: by 2002:aca:ad95:: with SMTP id w143mr23154242oie.47.1637940907278;
 Fri, 26 Nov 2021 07:35:07 -0800 (PST)
MIME-Version: 1.0
References: <20211126143329.2689618-1-arnd@kernel.org>
In-Reply-To: <20211126143329.2689618-1-arnd@kernel.org>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 26 Nov 2021 16:34:56 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGBVfvpD4n6LT1Y=61apibu1Nir0z53k=uguZ9-0vDiWw@mail.gmail.com>
Message-ID: <CAMj1kXGBVfvpD4n6LT1Y=61apibu1Nir0z53k=uguZ9-0vDiWw@mail.gmail.com>
Subject: Re: [PATCH] crypto: siphash - use _unaligned version by default
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 26 Nov 2021 at 16:02, Arnd Bergmann <arnd@kernel.org> wrote:
>
> From: Arnd Bergmann <arnd@arndb.de>
>
> On ARM v6 and later, we define CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
> because the ordinary load/store instructions (ldr, ldrh, ldrb) can
> tolerate any misalignment of the memory address. However, load/store
> double and load/store multiple instructions (ldrd, ldm) may still only
> be used on memory addresses that are 32-bit aligned, and so we have to
> use the CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS macro with care, or we
> may end up with a severe performance hit due to alignment traps that
> require fixups by the kernel. Testing shows that this currently happens
> with clang-13 but not gcc-11. In theory, any compiler version can
> produce this bug or other problems, as we are dealing with undefined
> behavior in C99 even on architectures that support this in hardware,
> see also https://gcc.gnu.org/bugzilla/show_bug.cgi?id=100363.
>
> Fortunately, the get_unaligned() accessors do the right thing: when
> building for ARMv6 or later, the compiler will emit unaligned accesses
> using the ordinary load/store instructions (but avoid the ones that
> require 32-bit alignment). When building for older ARM, those accessors
> will emit the appropriate sequence of ldrb/mov/orr instructions. And on
> architectures that can truly tolerate any kind of misalignment, the
> get_unaligned() accessors resolve to the leXX_to_cpup accessors that
> operate on aligned addresses.
>
> Since the compiler will in fact emit ldrd or ldm instructions when
> building this code for ARM v6 or later, the solution is to use the
> unaligned accessors unconditionally on architectures where this is
> known to be fast. The _aligned version of the hash function is
> however still needed to get the best performance on architectures
> that cannot do any unaligned access in hardware.
>
> This new version avoids the undefined behavior and should produce
> the fastest hash on all architectures we support.
>
> Link: https://lore.kernel.org/linux-arm-kernel/20181008211554.5355-4-ard.biesheuvel@linaro.org/
> Reported-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Fixes: 2c956a60778c ("siphash: add cryptographically secure PRF")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> ---
>  include/linux/siphash.h | 14 ++++----------
>  lib/siphash.c           | 12 ++++++------
>  2 files changed, 10 insertions(+), 16 deletions(-)
>
> diff --git a/include/linux/siphash.h b/include/linux/siphash.h
> index bf21591a9e5e..0cda61855d90 100644
> --- a/include/linux/siphash.h
> +++ b/include/linux/siphash.h
> @@ -27,9 +27,7 @@ static inline bool siphash_key_is_zero(const siphash_key_t *key)
>  }
>
>  u64 __siphash_aligned(const void *data, size_t len, const siphash_key_t *key);
> -#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
>  u64 __siphash_unaligned(const void *data, size_t len, const siphash_key_t *key);
> -#endif
>
>  u64 siphash_1u64(const u64 a, const siphash_key_t *key);
>  u64 siphash_2u64(const u64 a, const u64 b, const siphash_key_t *key);
> @@ -82,10 +80,9 @@ static inline u64 ___siphash_aligned(const __le64 *data, size_t len,
>  static inline u64 siphash(const void *data, size_t len,
>                           const siphash_key_t *key)
>  {
> -#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
> -       if (!IS_ALIGNED((unsigned long)data, SIPHASH_ALIGNMENT))
> +       if (IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) ||
> +           !IS_ALIGNED((unsigned long)data, SIPHASH_ALIGNMENT))
>                 return __siphash_unaligned(data, len, key);
> -#endif
>         return ___siphash_aligned(data, len, key);
>  }
>
> @@ -96,10 +93,8 @@ typedef struct {
>
>  u32 __hsiphash_aligned(const void *data, size_t len,
>                        const hsiphash_key_t *key);
> -#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
>  u32 __hsiphash_unaligned(const void *data, size_t len,
>                          const hsiphash_key_t *key);
> -#endif
>
>  u32 hsiphash_1u32(const u32 a, const hsiphash_key_t *key);
>  u32 hsiphash_2u32(const u32 a, const u32 b, const hsiphash_key_t *key);
> @@ -135,10 +130,9 @@ static inline u32 ___hsiphash_aligned(const __le32 *data, size_t len,
>  static inline u32 hsiphash(const void *data, size_t len,
>                            const hsiphash_key_t *key)
>  {
> -#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
> -       if (!IS_ALIGNED((unsigned long)data, HSIPHASH_ALIGNMENT))
> +       if (IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) ||
> +           !IS_ALIGNED((unsigned long)data, HSIPHASH_ALIGNMENT))
>                 return __hsiphash_unaligned(data, len, key);
> -#endif
>         return ___hsiphash_aligned(data, len, key);
>  }
>
> diff --git a/lib/siphash.c b/lib/siphash.c
> index a90112ee72a1..72b9068ab57b 100644
> --- a/lib/siphash.c
> +++ b/lib/siphash.c
> @@ -49,6 +49,7 @@
>         SIPROUND; \
>         return (v0 ^ v1) ^ (v2 ^ v3);
>
> +#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
>  u64 __siphash_aligned(const void *data, size_t len, const siphash_key_t *key)
>  {
>         const u8 *end = data + len - (len % sizeof(u64));
> @@ -80,8 +81,8 @@ u64 __siphash_aligned(const void *data, size_t len, const siphash_key_t *key)
>         POSTAMBLE
>  }
>  EXPORT_SYMBOL(__siphash_aligned);
> +#endif
>
> -#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
>  u64 __siphash_unaligned(const void *data, size_t len, const siphash_key_t *key)
>  {
>         const u8 *end = data + len - (len % sizeof(u64));
> @@ -113,7 +114,6 @@ u64 __siphash_unaligned(const void *data, size_t len, const siphash_key_t *key)
>         POSTAMBLE
>  }
>  EXPORT_SYMBOL(__siphash_unaligned);
> -#endif
>
>  /**
>   * siphash_1u64 - compute 64-bit siphash PRF value of a u64
> @@ -250,6 +250,7 @@ EXPORT_SYMBOL(siphash_3u32);
>         HSIPROUND; \
>         return (v0 ^ v1) ^ (v2 ^ v3);
>
> +#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
>  u32 __hsiphash_aligned(const void *data, size_t len, const hsiphash_key_t *key)
>  {
>         const u8 *end = data + len - (len % sizeof(u64));
> @@ -280,8 +281,8 @@ u32 __hsiphash_aligned(const void *data, size_t len, const hsiphash_key_t *key)
>         HPOSTAMBLE
>  }
>  EXPORT_SYMBOL(__hsiphash_aligned);
> +#endif
>
> -#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
>  u32 __hsiphash_unaligned(const void *data, size_t len,
>                          const hsiphash_key_t *key)
>  {
> @@ -313,7 +314,6 @@ u32 __hsiphash_unaligned(const void *data, size_t len,
>         HPOSTAMBLE
>  }
>  EXPORT_SYMBOL(__hsiphash_unaligned);
> -#endif
>
>  /**
>   * hsiphash_1u32 - compute 64-bit hsiphash PRF value of a u32
> @@ -418,6 +418,7 @@ EXPORT_SYMBOL(hsiphash_4u32);
>         HSIPROUND; \
>         return v1 ^ v3;
>
> +#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
>  u32 __hsiphash_aligned(const void *data, size_t len, const hsiphash_key_t *key)
>  {
>         const u8 *end = data + len - (len % sizeof(u32));
> @@ -438,8 +439,8 @@ u32 __hsiphash_aligned(const void *data, size_t len, const hsiphash_key_t *key)
>         HPOSTAMBLE
>  }
>  EXPORT_SYMBOL(__hsiphash_aligned);
> +#endif
>
> -#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
>  u32 __hsiphash_unaligned(const void *data, size_t len,
>                          const hsiphash_key_t *key)
>  {
> @@ -461,7 +462,6 @@ u32 __hsiphash_unaligned(const void *data, size_t len,
>         HPOSTAMBLE
>  }
>  EXPORT_SYMBOL(__hsiphash_unaligned);
> -#endif
>
>  /**
>   * hsiphash_1u32 - compute 32-bit hsiphash PRF value of a u32
> --
> 2.29.2
>
