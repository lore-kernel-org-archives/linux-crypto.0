Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6787614F70;
	Mon, 21 Jul 2025 03:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753068727; cv=none; b=A0aUzq4Cv3UJ1Fj5kepES4Uvdvi7pwV/lCvJ3NQ5e0R3VLeTs5dQS26xE51XYUl7QbtnziOBoDaKdwakSKUY9CdiEnrio0m1WkyMFpjApuZJe4cRVHmRhUhVCdlkuwcIYGqT3tPVWwJGclfTimfzGgeaZqGuaX1908hQrw8Yi4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753068727; c=relaxed/simple;
	bh=5vGNU3/VpvbOaw9Es6KWgWMC2qfsaJtRyTifOvfm/G0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Rah440pMN5P2MAftc3jQlWv20aikDJrol35pUCVu4ps+aXylgfmWCf3CfUN24jN+ot9ivdTVg25LofslJuu/rUdHqV5bNz62Dzrzux4lD5Viz/thrAVgW+uFoPdFzk8pYZ54WS1Mq0hM/7TE1CnbABdIZlhhJXpLDN1pfaWMVHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L7CFg5tI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L7CFg5tI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9B5CC4CEF7;
	Mon, 21 Jul 2025 03:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753068725;
	bh=5vGNU3/VpvbOaw9Es6KWgWMC2qfsaJtRyTifOvfm/G0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=L7CFg5tIKouQ5MZ7XvPuD9A5DhP1TDS/o22rImL596mOzORI6rsrpw/hMLnZktogH
	 bmS6olMgLAuJup6pFHb6SFkBlcOjn4NErjQN7YFFl6s45bUvjXt1R2NKdygMlNYuS1
	 EhIIFPVjR5UeiMd2lMPb0tJ4xbBCVwP4z93IzL8qH8oRZgCvxn9RgF43FrFJQ/OCg0
	 6SsL/X3z7r4Q1stmdX/m26AO98JjsTgcRfeicZSPBItG4OC06NtdQIuEDyfeldBgO1
	 hS/o87uHIupGMRMg4r4Ag8cO+HfRucByCJolNl1S8L4PW2q/Ta5XbP2+cDozWYGgJk
	 IYU8e4Ch0MX2Q==
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-54b10594812so3749061e87.1;
        Sun, 20 Jul 2025 20:32:05 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWYDlVev0Nvit/LUsVKH2H63QnD4LildGNRPXA2ee9tlaj01Jas3GHDeGJhikbqBb8ny4WMfV7eBb6eD+4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwSx+IW357z8O+JJmP9OHX1xdhnK8+lM7GWRjbRqY2BHirDnNRK
	0ipp+OXmvlvIKmP4zNbJNLl2mpatcJW250IT2fxqnkFZhV0RJtepxgYizNIC/NTAcaYt+6qGCEd
	+3RumZgGEyJ5/49TPIH1QUPfmS5XRQJM=
X-Google-Smtp-Source: AGHT+IE4SN0JuNh3roM0ETQFLsVy/x2AhxAGEyYBRRpy0Dw80fhA3MNnUViddOKGY2zlXrfAeWMcNUbQETOHytAj6HA=
X-Received: by 2002:a05:6512:110a:b0:550:e3de:63bc with SMTP id
 2adb3069b0e04-55a23f1c0e6mr4537830e87.25.1753068724220; Sun, 20 Jul 2025
 20:32:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250718220706.475240-1-ebiggers@kernel.org>
In-Reply-To: <20250718220706.475240-1-ebiggers@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Mon, 21 Jul 2025 13:31:47 +1000
X-Gmail-Original-Message-ID: <CAMj1kXG8rEGH9suNf+s26174-SDrVWaV3RcuY53ysiBbrJtKUQ@mail.gmail.com>
X-Gm-Features: Ac12FXx9Y8-gcXuH-ruBlTGuUo6bmhA8vXdtqeYbUG7cHBHU_pt46u8LrNVoH2k
Message-ID: <CAMj1kXG8rEGH9suNf+s26174-SDrVWaV3RcuY53ysiBbrJtKUQ@mail.gmail.com>
Subject: Re: [PATCH] lib/crypto: arm64/sha512-ce: Drop compatibility macros
 for older binutils
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, "Jason A . Donenfeld" <Jason@zx2c4.com>
Content-Type: text/plain; charset="UTF-8"

On Sat, 19 Jul 2025 at 08:07, Eric Biggers <ebiggers@kernel.org> wrote:
>
> Now that the oldest supported binutils version is 2.30, the macros that
> emit the SHA-512 instructions as '.inst' words are no longer needed.  So
> drop them.  No change in the generated machine code.
>
> Changed from the original patch by Ard Biesheuvel:
> (https://lore.kernel.org/r/20250515142702.2592942-2-ardb+git@google.com):
>  - Reduced scope to just SHA-512
>  - Added comment that explains why "sha3" is used instead of "sha2"
>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

Nit below

> ---
>
> This patch is targeting libcrypto-next
>
>  lib/crypto/arm64/sha512-ce-core.S | 27 +++++++--------------------
>  1 file changed, 7 insertions(+), 20 deletions(-)
>
> diff --git a/lib/crypto/arm64/sha512-ce-core.S b/lib/crypto/arm64/sha512-ce-core.S
> index 7d870a435ea38..eaa485244af52 100644
> --- a/lib/crypto/arm64/sha512-ce-core.S
> +++ b/lib/crypto/arm64/sha512-ce-core.S
> @@ -10,30 +10,17 @@
>   */
>
>  #include <linux/linkage.h>
>  #include <asm/assembler.h>
>
> -       .irp            b,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19
> -       .set            .Lq\b, \b
> -       .set            .Lv\b\().2d, \b
> -       .endr
> -
> -       .macro          sha512h, rd, rn, rm
> -       .inst           0xce608000 | .L\rd | (.L\rn << 5) | (.L\rm << 16)
> -       .endm
> -
> -       .macro          sha512h2, rd, rn, rm
> -       .inst           0xce608400 | .L\rd | (.L\rn << 5) | (.L\rm << 16)
> -       .endm
> -
> -       .macro          sha512su0, rd, rn
> -       .inst           0xcec08000 | .L\rd | (.L\rn << 5)
> -       .endm
> -
> -       .macro          sha512su1, rd, rn, rm
> -       .inst           0xce608800 | .L\rd | (.L\rn << 5) | (.L\rm << 16)
> -       .endm
> +       /*
> +        * While SHA-512 is part of the SHA-2 family of algorithms, the
> +        * corresponding arm64 instructions are actually part of the "sha3" CPU
> +        * feature.  (Except in binutils 2.30 through 2.42, which used "sha2".

Nit: the ARM ARM describes these features as FEAT_SHA256, FEAT_SHA512
and FEAT_SHA3, and the latter two happen to have appeared in the same
architecture revision. So this is likely just the GCC/binutils devs
getting confused, and assuming a) that SHA-3 implies SHA-2 (which is
silly if you know the difference) and b) SHA512 has anything to do
with SHA-3.


> +        * But "sha3" implies "sha2", so "sha3" still works in those versions.)
> +        */
> +       .arch           armv8-a+sha3
>
>         /*
>          * The SHA-512 round constants
>          */
>         .section        ".rodata", "a"
>
> base-commit: 66be847cc4c2e82fb50190b52b05b3bb0ef57999
> --
> 2.50.1
>
