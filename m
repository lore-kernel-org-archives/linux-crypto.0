Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA36B28A703
	for <linux-crypto@vger.kernel.org>; Tue, 10 Jun 2025 09:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749548580; cv=none; b=UYup7L4iBWlDDeX9adFaJANwB+BJOGY711nJ8BNPpL45+JdzgTpR+/59m5KOfiXkIPECURbZAe9iC+Mv7s0aSmVinn9TxPKHbJ57Yt9gvRzD8I6Gw19oIs+0nRC1Kr4NH0VMOXsD4GbWzAcfifEuekpsKCpEKczFd16ahFnvYTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749548580; c=relaxed/simple;
	bh=fzmo2aRYWdxEbzfDTHzVg4vQOgBDHmhwkQgMU5JBwvc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RgUSdpzC5H2KafocLXdQcnWhHLMmcOKgANQ934xjdAQIdzOQEyQYI2QBjebea7QmM5ruvL5sL7DgkW1X4tN0eCYKDxsub/3i2dLTElRhcxrf770D0W5Vdkuz/WKmdWbfyGV/4Uqs+UgCJtuJ6s70CnWKfVG2VVXIRFELU/RgKiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MdoGrN/l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MdoGrN/l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7765DC4CEF5
	for <linux-crypto@vger.kernel.org>; Tue, 10 Jun 2025 09:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749548580;
	bh=fzmo2aRYWdxEbzfDTHzVg4vQOgBDHmhwkQgMU5JBwvc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=MdoGrN/ljx1EVSXQdpSoXwORJfsaIubdlqtrT2t6IYKz/6bmoFXNdsbU9AGJiZJOw
	 t0QPQzTeJ3BZ/6jDtt4ByUfvsLm/R5ABJE7slMJGdOI2z4ZATJooy2cB9tgPFmfVsg
	 w2kiuAZJ/bvQq+Jp6tCb/xuXSRM3rUpKvT8H8GLLIAlkjcT4XdWyv62VvTpZs9J5rg
	 fW1tykH/nE+5ItVo0ZcrjWRwOibBylNA5yPQcGaHZsBlLREWNo/MfbQnZBLh4Mtvgb
	 HCw9TMcmd0KPQ4HcZ9Ha+f7bArgTWHI8Tl5o0fKEPEpxGlGVasp31zC4b4tD93+DXH
	 koXgEFaUy+rUg==
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-54998f865b8so4928524e87.3
        for <linux-crypto@vger.kernel.org>; Tue, 10 Jun 2025 02:43:00 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWcM4hpvb30UGkI+TIeGU6Qz1592BQjZDkHasDvpL/ZefHJ6X7v+jviCBRpccJek0DblgTiMaYFvQb+r2g=@vger.kernel.org
X-Gm-Message-State: AOJu0YzcwW12VXsGt+y/ZVOgbM2hBym8S6JV2BuBJv6FWcJc8GNAp7UQ
	i+CMUVnB44wJFF5r2kGtBGwsO6Fu2rfVe6rM5FvFZPft6tY0rQZ2FiNpUir4UWUKNqnPePWPJn0
	tJtUKCaWoOmDSStB25AbKzgnCZO0Gbvo=
X-Google-Smtp-Source: AGHT+IE4nSa2bN4TzrktkXCRfEv1np+VUrkGQV9lEdeLrzrSEiaejfA3SM6i9AyO2/WtBhsU+gxaR7qTX0JhonighTg=
X-Received: by 2002:a05:6512:110d:b0:553:2bb2:7890 with SMTP id
 2adb3069b0e04-55394776841mr436094e87.25.1749548578816; Tue, 10 Jun 2025
 02:42:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250609-curve25519-hacl64-disable-kasan-clang-v1-1-08ea0ac5ccff@kernel.org>
In-Reply-To: <20250609-curve25519-hacl64-disable-kasan-clang-v1-1-08ea0ac5ccff@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Tue, 10 Jun 2025 11:42:47 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFFb2EbQnOdKuw2xMPG1Y2WXJt4XigC7Wzqh1Sv0PGodA@mail.gmail.com>
X-Gm-Features: AX0GCFu0n6arctlqt-pm09a_qRtTHEWwn8b0pKXXaifIkWO-61Tq9-c1nzXSmMI
Message-ID: <CAMj1kXFFb2EbQnOdKuw2xMPG1Y2WXJt4XigC7Wzqh1Sv0PGodA@mail.gmail.com>
Subject: Re: [PATCH] crypto: lib/curve25519-hacl64 - Disable KASAN with
 clang-17 and older
To: Nathan Chancellor <nathan@kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, linux-crypto@vger.kernel.org, 
	llvm@lists.linux.dev, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Tue, 10 Jun 2025 at 00:45, Nathan Chancellor <nathan@kernel.org> wrote:
>
> After commit 6f110a5e4f99 ("Disable SLUB_TINY for build testing"), which
> causes CONFIG_KASAN to be enabled in allmodconfig again, arm64
> allmodconfig builds with clang-17 and older show an instance of
> -Wframe-larger-than (which breaks the build with CONFIG_WERROR=y):
>
>   lib/crypto/curve25519-hacl64.c:757:6: error: stack frame size (2336) exceeds limit (2048) in 'curve25519_generic' [-Werror,-Wframe-larger-than]
>     757 | void curve25519_generic(u8 mypublic[CURVE25519_KEY_SIZE],
>         |      ^
>
> When KASAN is disabled, the stack usage is roughly quartered:
>
>   lib/crypto/curve25519-hacl64.c:757:6: error: stack frame size (608) exceeds limit (128) in 'curve25519_generic' [-Werror,-Wframe-larger-than]
>     757 | void curve25519_generic(u8 mypublic[CURVE25519_KEY_SIZE],
>         |      ^
>
> Using '-Rpass-analysis=stack-frame-layout' shows the following variables
> and many, many 8-byte spills when KASAN is enabled:
>
>   Offset: [SP-144], Type: Variable, Align: 8, Size: 40
>   Offset: [SP-464], Type: Variable, Align: 8, Size: 320
>   Offset: [SP-784], Type: Variable, Align: 8, Size: 320
>   Offset: [SP-864], Type: Variable, Align: 32, Size: 80
>   Offset: [SP-896], Type: Variable, Align: 32, Size: 32
>   Offset: [SP-1016], Type: Variable, Align: 8, Size: 120
>
> When KASAN is disabled, there are still spills but not at many and the
> variables list is smaller:
>
>   Offset: [SP-192], Type: Variable, Align: 32, Size: 80
>   Offset: [SP-224], Type: Variable, Align: 32, Size: 32
>   Offset: [SP-344], Type: Variable, Align: 8, Size: 120
>
> Disable KASAN for this file when using clang-17 or older to avoid
> blowing out the stack, clearing up the warning.
>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> ---
>  lib/crypto/Makefile | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
> index 3e79283b617d..18664127ecd6 100644
> --- a/lib/crypto/Makefile
> +++ b/lib/crypto/Makefile
> @@ -35,6 +35,10 @@ obj-$(CONFIG_CRYPTO_LIB_CURVE25519_GENERIC)  += libcurve25519-generic.o
>  libcurve25519-generic-y                                := curve25519-fiat32.o
>  libcurve25519-generic-$(CONFIG_ARCH_SUPPORTS_INT128)   := curve25519-hacl64.o
>  libcurve25519-generic-y                                += curve25519-generic.o
> +# clang versions prior to 18 may blow out the stack with KASAN
> +ifeq ($(call clang-min-version, 180000),)
> +KASAN_SANITIZE_curve25519-hacl64.o := n
> +endif
>
>  obj-$(CONFIG_CRYPTO_LIB_CURVE25519)            += libcurve25519.o
>  libcurve25519-y                                        += curve25519.o
>
> ---
> base-commit: 19272b37aa4f83ca52bdf9c16d5d81bdd1354494
> change-id: 20250609-curve25519-hacl64-disable-kasan-clang-faf6e97315e4
>
> Best regards,
> --
> Nathan Chancellor <nathan@kernel.org>
>
