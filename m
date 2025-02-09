Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D671BD9CE;
	Sun,  9 Feb 2025 11:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739101971; cv=none; b=HQGXOCUdQCSDl0KBKBjeuqk5Pm1Pb5ZnT4ckjQeXJOUgrYBo86u7+fkttWeo7AiAKZEPzTs55AGSXMmpvddtUmYpJErG5t6J5sQLWcCYx8CVEzx9vwRe9duOhHeFLX3gY0y/tqeGSa3/OuEKAAjBmQKMoNddXKgw+jp25Hq+aZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739101971; c=relaxed/simple;
	bh=PhDbKNXuTiUKPAVw6tHZWO5JOsIIkmKxc+7r3DftrjA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KjcbCqniyO8c1cVuNsFwrCPt/xvOKGBkNTDvVbJ2o0xUfhzC6Lh/yd0j1yZmXx74wYTbAQlqAKG/zIBW73IY+51U1Tj3znw1IL1gszYrCAq1y7Xcw/L8Tr+D1nJiTmffCh4BQySXa2PMgncTx8TZ3OHw1wAlPBmab5c8HMV9cAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rhEskkbt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rhEskkbt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2F62C4CEDD;
	Sun,  9 Feb 2025 11:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739101970;
	bh=PhDbKNXuTiUKPAVw6tHZWO5JOsIIkmKxc+7r3DftrjA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=rhEskkbtZrAlSE/k6prcUyV4pQpG/rO+F7UMqt8pdHxQyHhJTj/B63V4TdtDxSBeD
	 jVqhBNQrd5mGn1rva6Beaci/kMQ/k5W7hngMwLVt22yEfkvOc3ZmVQ7I94k0dbxjI0
	 57U+ReZO6iFhbVDVwfI3+NO+mGo5Vs657DWuZuLxKo9+KoPGmzxilcMCQmMhyXnVju
	 jpos/hC5XfHZCsMtiofe8Q28M/6kuaUz50DsbSqBJClSNaZ/IJ6y/1uS4oXMs5UhHh
	 fsvj8PIWGa+tqwR0bmipLKgn493ezch3tv3kIvZemlF5t0/aTY99TRloXJuLhO0rDY
	 5w4XQNQUexqBw==
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5450622b325so893471e87.1;
        Sun, 09 Feb 2025 03:52:50 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUyBsIfsTb/GgLimOyCJXfnXfvnh4T1Pg18oth5I3iDDmHgPO/qBrI++2jKfLWK7MMdox6nrDsK0IlB6gw=@vger.kernel.org
X-Gm-Message-State: AOJu0YywDb3OZ1sineXGuPZ0doQdwYH4BkaSUfcMrH/4UU9v56mQ5RsU
	SDF4s0rQkmj7RN/4yOlU24EiCIAPg4iQRWHkYvUa4aazu2woGVeirLIioJEKIZTUMf2zJYFjsmp
	bgazdAXnanozd/0p3jv9eD3OlSPQ=
X-Google-Smtp-Source: AGHT+IFMz/1AaymgWDvJG5mFSjJfibgeJWLHfZLKMkdEQ4nfnhAycUE8XD2JF5ovK61CCIr9uboKjrDPsfJb5269FIw=
X-Received: by 2002:a05:6512:3fc:b0:542:98bb:5674 with SMTP id
 2adb3069b0e04-54414ae0732mr2587641e87.33.1739101969127; Sun, 09 Feb 2025
 03:52:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250208175647.12333-1-ebiggers@kernel.org>
In-Reply-To: <20250208175647.12333-1-ebiggers@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Sun, 9 Feb 2025 12:52:38 +0100
X-Gmail-Original-Message-ID: <CAMj1kXFt9d2vmNOaYk9+3CpEv9ZfTPTrDGgTKYOe-RCRgg7UFA@mail.gmail.com>
X-Gm-Features: AWEUYZnebgQyXs_mccyGE8n-LAEqlU7sljhb1y7T8aDJbHuCulO7Hsw4P7U92Vs
Message-ID: <CAMj1kXFt9d2vmNOaYk9+3CpEv9ZfTPTrDGgTKYOe-RCRgg7UFA@mail.gmail.com>
Subject: Re: [PATCH] lib/crc-t10dif: remove crc_t10dif_is_optimized()
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	Zhihang Shao <zhihang.shao.iscas@gmail.com>
Content-Type: text/plain; charset="UTF-8"

On Sat, 8 Feb 2025 at 18:57, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> With the "crct10dif" algorithm having been removed from the crypto API,
> crc_t10dif_is_optimized() is no longer used.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>
> This applies to
> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=crc-next
>
>  arch/arm/lib/crc-t10dif-glue.c     | 6 ------
>  arch/arm64/lib/crc-t10dif-glue.c   | 6 ------
>  arch/powerpc/lib/crc-t10dif-glue.c | 6 ------
>  arch/x86/lib/crc-t10dif-glue.c     | 6 ------
>  include/linux/crc-t10dif.h         | 9 ---------
>  5 files changed, 33 deletions(-)
>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> diff --git a/arch/arm/lib/crc-t10dif-glue.c b/arch/arm/lib/crc-t10dif-glue.c
> index d24dee62670e..f3584ba70e57 100644
> --- a/arch/arm/lib/crc-t10dif-glue.c
> +++ b/arch/arm/lib/crc-t10dif-glue.c
> @@ -67,14 +67,8 @@ arch_initcall(crc_t10dif_arm_init);
>  static void __exit crc_t10dif_arm_exit(void)
>  {
>  }
>  module_exit(crc_t10dif_arm_exit);
>
> -bool crc_t10dif_is_optimized(void)
> -{
> -       return static_key_enabled(&have_neon);
> -}
> -EXPORT_SYMBOL(crc_t10dif_is_optimized);
> -
>  MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
>  MODULE_DESCRIPTION("Accelerated CRC-T10DIF using ARM NEON and Crypto Extensions");
>  MODULE_LICENSE("GPL v2");
> diff --git a/arch/arm64/lib/crc-t10dif-glue.c b/arch/arm64/lib/crc-t10dif-glue.c
> index dab7e3796232..a007d0c5f3fe 100644
> --- a/arch/arm64/lib/crc-t10dif-glue.c
> +++ b/arch/arm64/lib/crc-t10dif-glue.c
> @@ -68,14 +68,8 @@ arch_initcall(crc_t10dif_arm64_init);
>  static void __exit crc_t10dif_arm64_exit(void)
>  {
>  }
>  module_exit(crc_t10dif_arm64_exit);
>
> -bool crc_t10dif_is_optimized(void)
> -{
> -       return static_key_enabled(&have_asimd);
> -}
> -EXPORT_SYMBOL(crc_t10dif_is_optimized);
> -
>  MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
>  MODULE_DESCRIPTION("CRC-T10DIF using arm64 NEON and Crypto Extensions");
>  MODULE_LICENSE("GPL v2");
> diff --git a/arch/powerpc/lib/crc-t10dif-glue.c b/arch/powerpc/lib/crc-t10dif-glue.c
> index 730850dbc51d..f411b0120cc5 100644
> --- a/arch/powerpc/lib/crc-t10dif-glue.c
> +++ b/arch/powerpc/lib/crc-t10dif-glue.c
> @@ -76,14 +76,8 @@ arch_initcall(crc_t10dif_powerpc_init);
>  static void __exit crc_t10dif_powerpc_exit(void)
>  {
>  }
>  module_exit(crc_t10dif_powerpc_exit);
>
> -bool crc_t10dif_is_optimized(void)
> -{
> -       return static_key_enabled(&have_vec_crypto);
> -}
> -EXPORT_SYMBOL(crc_t10dif_is_optimized);
> -
>  MODULE_AUTHOR("Daniel Axtens <dja@axtens.net>");
>  MODULE_DESCRIPTION("CRCT10DIF using vector polynomial multiply-sum instructions");
>  MODULE_LICENSE("GPL");
> diff --git a/arch/x86/lib/crc-t10dif-glue.c b/arch/x86/lib/crc-t10dif-glue.c
> index 13f07ddc9122..7734bdbc2e39 100644
> --- a/arch/x86/lib/crc-t10dif-glue.c
> +++ b/arch/x86/lib/crc-t10dif-glue.c
> @@ -39,13 +39,7 @@ arch_initcall(crc_t10dif_x86_init);
>  static void __exit crc_t10dif_x86_exit(void)
>  {
>  }
>  module_exit(crc_t10dif_x86_exit);
>
> -bool crc_t10dif_is_optimized(void)
> -{
> -       return static_key_enabled(&have_pclmulqdq);
> -}
> -EXPORT_SYMBOL(crc_t10dif_is_optimized);
> -
>  MODULE_DESCRIPTION("CRC-T10DIF using PCLMULQDQ instructions");
>  MODULE_LICENSE("GPL");
> diff --git a/include/linux/crc-t10dif.h b/include/linux/crc-t10dif.h
> index d0706544fc11..a559fdff3f7e 100644
> --- a/include/linux/crc-t10dif.h
> +++ b/include/linux/crc-t10dif.h
> @@ -17,15 +17,6 @@ static inline u16 crc_t10dif_update(u16 crc, const u8 *p, size_t len)
>  static inline u16 crc_t10dif(const u8 *p, size_t len)
>  {
>         return crc_t10dif_update(0, p, len);
>  }
>
> -#if IS_ENABLED(CONFIG_CRC_T10DIF_ARCH)
> -bool crc_t10dif_is_optimized(void);
> -#else
> -static inline bool crc_t10dif_is_optimized(void)
> -{
> -       return false;
> -}
> -#endif
> -
>  #endif
>
> base-commit: 3dceb9c4f1202d2c374976936ef803bf4b076fa7
> --
> 2.48.1
>
