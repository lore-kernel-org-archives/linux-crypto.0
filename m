Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B0A3158545
	for <linux-crypto@vger.kernel.org>; Mon, 17 Feb 2025 19:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739819771; cv=none; b=H2KeUQ8F6a2PsGGLbT/U68ea3M3H5VV9NMx3p32WCQxkNohoA5b+/mIS7iVTRsSDiwFXgmRGTUsikzNS9WG7pE5qaT6TJL9wTKCahFJr+u/MX8G0P3STO7Vrg3TKruXmo6N9qMMx2bRN8rgqv1syOBqgmy2cG5ryXGeMVGXxYl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739819771; c=relaxed/simple;
	bh=YMrIg03vTZaBozCF6QmM+k4ts7OTzl8Js925lRhTRGY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RQITnCjTqqjMk/FkK1WH0w25je0NKUulENkPuqdNT1m66XivnrqM/nK5xtRFpYWBe0ncdd1IXD3dEccQqqfu8J5p05b9Enowpw6gW+FYf4IUsRRg02LoG9EadJTELcUniAkWa/H7kM1t9z8TZDImaXYwbT4BxNB7ST4VUnQXa5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XT1rAbQr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XT1rAbQr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6D8FC4CEE4
	for <linux-crypto@vger.kernel.org>; Mon, 17 Feb 2025 19:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739819769;
	bh=YMrIg03vTZaBozCF6QmM+k4ts7OTzl8Js925lRhTRGY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=XT1rAbQrGXWLrdFYjik0Bkivb878tMyDhoy3HnnFs2zm7HlgQuKSadNgBF51xqSEL
	 SqUGdZgsy+ecqov65LBNgMtb1HQLya/8adrB78BHPG9dFdBRUDuTAeSRE1i00SOr6x
	 JvrLKaHn3EN+ThiYMvuA0mI0z20/W0jDeUIfZI1SqMk+D9ble38w4xl1X2z/RvMUjt
	 cRzBSEKL050mtM4kEU/2idCjsYOu3KjdnDV7Zqz7yls0UoOQkxsFBynlUmcTjKwOgv
	 GQqhs3xRcCCDewqXz2fdJxAb+RaSzQWAQbObrRoU/Dxs/5BQ5gDW9woQzRfPgPBGhe
	 r7QWscsNzTIPg==
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-30a28bf1baaso14182891fa.3
        for <linux-crypto@vger.kernel.org>; Mon, 17 Feb 2025 11:16:09 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVo4uuit6GYPn4iW/P7ffTw2Oi0bFGGbZV3YSB99dGmpf5w8/IcIW/Jh/r4DeE2kwy4mvBuDDSQ0FOfrN0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxJdoqTa0ChO7MchFdFjjJJpTtPYRuU3f6naQLK8Ae+mX5ECHVf
	yTNop6kqEy6M52A6kpuJr54RPMWozSaSmciHXOtQCHoMyrQsMN1QrCrmjufXv6TtTaRbYwV6YN7
	s8A/+5VO7K4JIwr95QBSEbzv/2rw=
X-Google-Smtp-Source: AGHT+IF5rjM3ghDEcQTCbgD0eoEylBfGDad6FTggQuY+aOwRBZqMxQ8Er91FzAnZNRyENYQFXCRdWPP/J9Rwt5I8vPI=
X-Received: by 2002:a2e:9212:0:b0:307:dc28:750b with SMTP id
 38308e7fff4ca-30927a4a411mr29851411fa.13.1739819768323; Mon, 17 Feb 2025
 11:16:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250217185105.26751-1-ebiggers@kernel.org>
In-Reply-To: <20250217185105.26751-1-ebiggers@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Mon, 17 Feb 2025 20:15:56 +0100
X-Gmail-Original-Message-ID: <CAMj1kXFNdpvz+fDJJP92wxw8FUQHhS6OZ0GrTSUWZe86+SsjDw@mail.gmail.com>
X-Gm-Features: AWEUYZnHCsUAMhv_Uei4UbhBY-3uia85RqGAGnczVoSggFv05LiAZ7h6Q6Crz5M
Message-ID: <CAMj1kXFNdpvz+fDJJP92wxw8FUQHhS6OZ0GrTSUWZe86+SsjDw@mail.gmail.com>
Subject: Re: [PATCH] Revert "fsverity: relax build time dependency on CRYPTO_SHA256"
To: Eric Biggers <ebiggers@kernel.org>
Cc: fsverity@lists.linux.dev, linux-crypto@vger.kernel.org, 
	Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"

On Mon, 17 Feb 2025 at 19:51, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> This reverts commit e3a606f2c544b231f6079c8c5fea451e772e1139 because it
> allows people to create broken configurations that enable FS_VERITY but
> not SHA-256 support.
>
> The commit did allow people to disable the generic SHA-256
> implementation when it's not needed.  But that at best allowed saving a
> bit of code.  In the real world people are unlikely to intentionally and
> correctly make such a tweak anyway, as they tend to just be confused by
> what all the different crypto kconfig options mean.
>
> Of course we really need the crypto API to enable the correct
> implementations automatically, but that's for a later fix.
>
> Cc: Ard Biesheuvel <ardb@kernel.org>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  fs/verity/Kconfig | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> diff --git a/fs/verity/Kconfig b/fs/verity/Kconfig
> index e1036e5353521..40569d3527a71 100644
> --- a/fs/verity/Kconfig
> +++ b/fs/verity/Kconfig
> @@ -2,17 +2,13 @@
>
>  config FS_VERITY
>         bool "FS Verity (read-only file-based authenticity protection)"
>         select CRYPTO
>         select CRYPTO_HASH_INFO
> -       # SHA-256 is implied as it's intended to be the default hash algorithm.
> +       # SHA-256 is selected as it's intended to be the default hash algorithm.
>         # To avoid bloat, other wanted algorithms must be selected explicitly.
> -       # Note that CRYPTO_SHA256 denotes the generic C implementation, but
> -       # some architectures provided optimized implementations of the same
> -       # algorithm that may be used instead. In this case, CRYPTO_SHA256 may
> -       # be omitted even if SHA-256 is being used.
> -       imply CRYPTO_SHA256
> +       select CRYPTO_SHA256
>         help
>           This option enables fs-verity.  fs-verity is the dm-verity
>           mechanism implemented at the file level.  On supported
>           filesystems (currently ext4, f2fs, and btrfs), userspace can
>           use an ioctl to enable verity for a file, which causes the
>
> base-commit: 0ad2507d5d93f39619fc42372c347d6006b64319
> --
> 2.48.1
>
