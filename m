Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB10C18892D;
	Thu,  6 Feb 2025 18:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738865091; cv=none; b=hwElWRkk2eZboUmyUwxXn/DLPSYN1GFYhVBZU6BnhNSexxJiAl0+Y7NgTiGaUiUlAoL4+qq0fLId81abSV4jz4nW0kwv3rCrGBHsLZJJa9idfrXypBnFxBfJylciRO1cmzHr4/DcGc1kJuWwUDJvBBbolkI5f4wH7k+LFr34LCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738865091; c=relaxed/simple;
	bh=zxU8fylGqAO4r6pXjsq8B/zgRmvN3gl5YL2E1/zO+KI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VYPicEwONKUMcZXvMDJkOoJ+mODmT6IJm6xLFC5L/fwl7V8uP76A3lpkEUeSoHQPlvTCadxwkjRL0qlMUDCzjFxsOk8vR6ShvBcXrmbIZbtQVCNN87SvnABpDCuOAt0zWdVrqH0k0wFqIb0vuzB1LUCPOLE+1oae4x1wgPwSUbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pNFpBA0t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pNFpBA0t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50309C4CEE3;
	Thu,  6 Feb 2025 18:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738865091;
	bh=zxU8fylGqAO4r6pXjsq8B/zgRmvN3gl5YL2E1/zO+KI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=pNFpBA0tEU3pGKagSmkjFHB7RBipgMZZhjKhOySTb2rHLvwJewiV4CS/xwIEux4hx
	 zcC9ribRxq074XUAYoHPhL3NGh8pgMECD05R1j40QVJNIoqXFYUXpopEhtSUNaxN0z
	 sDeInXaH4PsuN40MsWoQBTrR84bWj4BxwlqOXPZqnrGZwqRg046g0pO5Ry0l6n97tA
	 3mp4srRFG3SfA92yJSoGTqHM2z2SGE5T6TB/hDNAmUPzQfmIh0y2jKPoCPzxS+zW2g
	 9XTPaXhpBhfvZwRkWUiGvgS8acdox3Ft/VQ4gncap7y4zr/JlWL5HOSpjYWGAsJWgX
	 VbChC2xFm7TWw==
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-543e49a10f5so1358574e87.1;
        Thu, 06 Feb 2025 10:04:51 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWB/kCmxYSa/kc3lfg0gIjdELJokvysBG3KqlFJu86iBNQoksIuBZBuyRSbx5cysHtE0A9LLd3PJrWZ6CA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwINPGRsDQ6J//nnQSWKOtDYHZfCphvb0IRC8CNGJ7aMf0Wzqi0
	mItnU2dpwKqz41p9gcLolwPo7XR/2FtMuRz9vkro0Tj+yyB9TFHSgIhmOcTMCFa/UyouveRy4nB
	vhyUSK5S+eXDAsvPSumzAfEe6nVs=
X-Google-Smtp-Source: AGHT+IG+nbhBYu25APUg+C1Phge0GmKyxpFxgriETHdt8qX1kzlQEo+5Y/pTU/DnUq8/cdsnT2Gy4T57yuWlGiveHsc=
X-Received: by 2002:ac2:488e:0:b0:544:ecc:1f6d with SMTP id
 2adb3069b0e04-5440ecc1facmr889187e87.40.1738865089534; Thu, 06 Feb 2025
 10:04:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250206173857.39794-1-ebiggers@kernel.org>
In-Reply-To: <20250206173857.39794-1-ebiggers@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Thu, 6 Feb 2025 19:04:38 +0100
X-Gmail-Original-Message-ID: <CAMj1kXHAvD9DRb_Qry===C4Hg-DeT6rN0HzWLcB3dCr+eNug+w@mail.gmail.com>
X-Gm-Features: AWEUYZlNk_hTQsxlggzva9mFGO21NPsjDqE0XqanU9-c8Ku38mduYH32AtOKdgw
Message-ID: <CAMj1kXHAvD9DRb_Qry===C4Hg-DeT6rN0HzWLcB3dCr+eNug+w@mail.gmail.com>
Subject: Re: [PATCH] crypto: crct10dif - remove from crypto API
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	dm-devel@lists.linux.dev, Mikulas Patocka <mpatocka@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 6 Feb 2025 at 18:40, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> Remove the "crct10dif" shash algorithm from the crypto API.  It has no
> known user now that the lib is no longer built on top of it.  It has no
> remaining references in kernel code.  The only other potential users
> would be the usual components that allow specifying arbitrary hash
> algorithms by name, namely AF_ALG and dm-integrity.   However there are
> no indications that "crct10dif" is being used with these components.
> Debian Code Search and web searches don't find anything relevant, and
> explicitly grepping the source code of the usual suspects (cryptsetup,
> libell, iwd) finds no matches either.  "crc32" and "crc32c" are used in
> a few more places, but that doesn't seem to be the case for "crct10dif".
>
> crc_t10dif_update() is also tested by crc_kunit now, so the test
> coverage provided via the crypto self-tests is no longer needed.
>
> Also note that the "crct10dif" shash algorithm was inconsistent with the
> rest of the shash API in that it wrote the digest in CPU endianness,
> making the resulting byte array differ on little endian vs. big endian
> platforms.  This means it was effectively just built for use by the lib
> functions, and it was not actually correct to treat it as "just another
> hash function" that could be dropped in via the shash API.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>
> I'm planning to take this via the crc tree.
>
>  arch/mips/configs/decstation_64_defconfig     |   1 -
>  arch/mips/configs/decstation_defconfig        |   1 -
>  arch/mips/configs/decstation_r4k_defconfig    |   1 -
>  crypto/Kconfig                                |   9 -
>  crypto/Makefile                               |   2 -
>  crypto/crct10dif_generic.c                    | 168 ----------
>  crypto/tcrypt.c                               |   8 -
>  crypto/testmgr.c                              |   7 -
>  crypto/testmgr.h                              | 288 ------------------
>  include/linux/crc-t10dif.h                    |   3 -
>  .../testing/selftests/arm64/fp/kernel-test.c  |   1 -
>  11 files changed, 489 deletions(-)
>  delete mode 100644 crypto/crct10dif_generic.c
>

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
