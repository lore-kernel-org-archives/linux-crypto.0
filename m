Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A61718A6DE;
	Wed,  5 Feb 2025 15:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738769725; cv=none; b=NCDyKLyUAWPjcOs6FrM9nmfFYFVSYV1vSt3tYJgKD+ycszT2kcd0EbxxwrYk77NfdztfXAiN2GLBD3ziSOzQzi5PxtlnkZI3OUuPK/SLhKsDYQTJUmgzrXD144eig4R0GOzFDgaXtMCErPNDzchzzBshuWOWS6+7ONkVPMNVgA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738769725; c=relaxed/simple;
	bh=7PDY9/nZTwZkVKVNvnHXJBYHOe0wl9KKqpVeJAlSVeY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tm2OLvETEgLYVVu801y0BPiCrURIfzTI4EQHCU+6PrmjJwAfXf/BbHHnZhuAw8rzGStvDBTwd7B7/aKiFHqt/SzaKATQUnJTp+UMl/bMukHMWt5wAIHpFiIdO4Sv5S642wAuljE4vStHYUKG9KpYmqFyyrVH5svkio8m9TUI6c4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D/79cUJf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D/79cUJf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0543CC4CED1;
	Wed,  5 Feb 2025 15:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738769725;
	bh=7PDY9/nZTwZkVKVNvnHXJBYHOe0wl9KKqpVeJAlSVeY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=D/79cUJflGtFUuBZw3e1qCuXhnmjovbhL0p8lJt1VU1DK6rXd9WQLqT6FqfEU/vbW
	 guDSexmckjZ65vb21C0WSJVfda/ILp7rQF8SVNYdNLyB+0LciR9Ga82ecstc38nVRm
	 NRUs0L2SBAyyiSdV8F/zGqyBAHlE/y2zzEun3lxCKMbvaGds9OQazMMjgo4XZhrz5J
	 UuiNByYEUcwNZwC0yEUaLpMlBmvfBohYQPjb6zsm1wEg4gMDQyNQZGs1Kq9cQBtVGS
	 lTf7woqchEe8PwTVOecBHMiJtD45ooul/lWTsYoTJrsxsR22ie7lGDn7jIzzt2DkhG
	 8njUpVex4X0xQ==
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-30036310158so51660991fa.0;
        Wed, 05 Feb 2025 07:35:24 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVQyk2UomCkeDHznliys1252WjPlEIHYwh85ruUA29pn1ac54xy6B2eGLSFWHb8ahpE5t7xEgaKYZSQTD0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyFX4Q+M5auja4birdcoCHIStjysq+Y8WJDGqf89Gk+0S3vJqET
	xgnvM94it9QWuC+xbv/Ae4/jdCY19VDdBB3R2cLSjZB4NNccBONqLANo6xVtiapsWY0ehs2gEr7
	BsfGSjoBpb6UuuieJ6+mByFZOMP0=
X-Google-Smtp-Source: AGHT+IERKatGcObx3raYjUdcgv/yxblmehs5Ib+3XRthA6BcAC4y0C/1fX9J8yDuz/jZC55zrLmW2oCnCghQOlyBWUU=
X-Received: by 2002:a2e:bc21:0:b0:302:4132:499 with SMTP id
 38308e7fff4ca-307cf38cd74mr15117051fa.25.1738769723337; Wed, 05 Feb 2025
 07:35:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250205005403.136082-1-ebiggers@kernel.org>
In-Reply-To: <20250205005403.136082-1-ebiggers@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Wed, 5 Feb 2025 16:35:12 +0100
X-Gmail-Original-Message-ID: <CAMj1kXF+z4YGkGL7OC=3mq7bH-NQqubOkkus-ohVmdC-z4cq8w@mail.gmail.com>
X-Gm-Features: AWEUYZnjdv9mpmG8EcEnTkQ-3d-aBgguCVnpdbJiahp5sFHVU0X19eiEmiiDIXY
Message-ID: <CAMj1kXF+z4YGkGL7OC=3mq7bH-NQqubOkkus-ohVmdC-z4cq8w@mail.gmail.com>
Subject: Re: [PATCH 0/5] A few more CRC32 library cleanups
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 5 Feb 2025 at 01:55, Eric Biggers <ebiggers@kernel.org> wrote:
>
> This series makes the CRC32 library functions have consistent
> prototypes, and it makes the Castagnoli CRC32 be consistently called
> simply crc32c instead of a mix of crc32c, crc32c_le, and __crc32c_le.
>
> Eric Biggers (5):
>   lib/crc32: use void pointer for data
>   lib/crc32: don't bother with pure and const function attributes
>   lib/crc32: standardize on crc32c() name for Castagnoli CRC32
>   lib/crc32: rename __crc32c_le_combine() to crc32c_combine()
>   lib/crc32: remove "_le" from crc32c base and arch functions
>
>  arch/arm/lib/crc32-glue.c                     | 12 ++---
>  arch/arm64/lib/crc32-glue.c                   | 10 ++--
>  arch/loongarch/lib/crc32-loongarch.c          |  6 +--
>  arch/mips/lib/crc32-mips.c                    |  6 +--
>  arch/powerpc/lib/crc32-glue.c                 | 10 ++--
>  arch/riscv/lib/crc32-riscv.c                  | 17 +++---
>  arch/s390/lib/crc32-glue.c                    |  2 +-
>  arch/sparc/lib/crc32_glue.c                   | 10 ++--
>  arch/x86/lib/crc32-glue.c                     |  6 +--
>  crypto/crc32c_generic.c                       |  8 +--
>  drivers/crypto/stm32/stm32-crc32.c            |  2 +-
>  drivers/infiniband/sw/siw/siw.h               |  4 +-
>  drivers/md/raid5-cache.c                      | 31 ++++++-----
>  drivers/md/raid5-ppl.c                        | 16 +++---
>  .../net/ethernet/broadcom/bnx2x/bnx2x_sp.c    |  2 +-
>  drivers/thunderbolt/ctl.c                     |  2 +-
>  drivers/thunderbolt/eeprom.c                  |  2 +-
>  include/linux/crc32.h                         | 53 +++++++++----------
>  include/linux/crc32c.h                        |  8 ---
>  include/net/sctp/checksum.h                   |  7 +--
>  lib/crc32.c                                   | 21 ++++----
>  lib/crc_kunit.c                               |  2 +-
>  sound/soc/codecs/aw88395/aw88395_device.c     |  2 +-
>  23 files changed, 111 insertions(+), 128 deletions(-)
>

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
