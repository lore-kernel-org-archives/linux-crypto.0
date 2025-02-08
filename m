Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2B9F28F3;
	Sat,  8 Feb 2025 09:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739007741; cv=none; b=CijsOhBQbKn4kvPxKQ1mp6dxZjK7y4QvO5zoOMh5tJ7PxRJ7ZaLFqUS2dmD7uJ6i7JRq1z6GL3XY3HtFIRQUnOKlyCK2dlbr2mtIIoJIfsFn98hXdMbKkDqDKGglyb0IsaqQIl8flDWKuFgsHwjfx2O2fbvozKbubQU2WRKFy7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739007741; c=relaxed/simple;
	bh=kvvOJEs0fAuMdo5rH9JgzKyiguL9Ah4wBUAARm5QJ7s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gA+nHkRAxWCh7MVSRy0mp9FFxkiRQXpmt0x++QeqTvihu9Gs5jWo8zBKnkIhlDbJ5pD+mCsRpVmsZ2/tYOucwtN6aKB0WoneAnzDY7tl/Qs/9bEVr7y5ygDMIVuEj2tVaRWgu9+E2HK6wDKPYTRlfjCaM53x7D0RnF26U1xLsb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T8VTFG8q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T8VTFG8q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ADA4C4CED6;
	Sat,  8 Feb 2025 09:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739007741;
	bh=kvvOJEs0fAuMdo5rH9JgzKyiguL9Ah4wBUAARm5QJ7s=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=T8VTFG8qv+m74aZbYRCVfqIlxGZcEMTxj2nHgFaTWccexW/fZaC9vuuOFt7yVrZu3
	 zs8BcuWxf5QSKXPl2apdQ40dL5CeI9XEjED9xcxQfYlxZcyy48jaKycptuY3aLifn4
	 UoJZW+RLxDhVMC/tp5j6kgmWavvqEHhirS9Gcb3FoY55m6+kl8zXoDO7oeLXQzsP8V
	 Lnmm+OUOrQp24EUKEyfC4LxOuYML7R9Aaxf9Y+jgTn8TXpEnD1uDMlksUpKnvoblcf
	 yCr+PRKFuM4fyLYn/ZnLjQrzm99mlCz2YQboy96ANihTI5xiLrXO+gpkG1DPckJ/t0
	 TS/El0lNd53NA==
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-545074b88aaso27980e87.3;
        Sat, 08 Feb 2025 01:42:21 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWpAwYqUDK+Af3AkVApYQ1IEOCxLeUpavFM7C4y0GDt548XJJ9Mto926F7kh30IZ7zW+xDsbDHBybcIdk0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwtWUuhpMiNYs65xoy9MVr5aozX84v9MlSsOZtSBMXTMeuoHwJD
	trtgfQC7ty0c5zBuaJGJmmncW0rcot6C/f5Rm0A+RGuD5X8LxnqnR94pBjtReQYLTrBHXjHWUOh
	jApv3ZeGC7lpr0qBK19nVTfzlwP4=
X-Google-Smtp-Source: AGHT+IE3j+vFLb2ryC9RbuvT+iDlBRHEHpBMclWEXrCnFiSCac2rv2CBCOD3/cCbFSTcrlCtYhQvHDIkXkpyaNQTCWY=
X-Received: by 2002:a05:6512:6c5:b0:540:1d0a:57fa with SMTP id
 2adb3069b0e04-54414a9cea6mr1977037e87.13.1739007739640; Sat, 08 Feb 2025
 01:42:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250208024911.14936-1-ebiggers@kernel.org> <20250208024911.14936-2-ebiggers@kernel.org>
In-Reply-To: <20250208024911.14936-2-ebiggers@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Sat, 8 Feb 2025 10:42:08 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGJ9AMj88mprWkfiYk=qBtAmVG9wjz0Kh__38WoBDeXfA@mail.gmail.com>
X-Gm-Features: AWEUYZnhgI8oAsRQ2d1Kpy7qib9AES9dhR2Cd8dhRzfkZrbPo2FdRG2_0GkILuI
Message-ID: <CAMj1kXGJ9AMj88mprWkfiYk=qBtAmVG9wjz0Kh__38WoBDeXfA@mail.gmail.com>
Subject: Re: [PATCH v2 1/6] mips/crc32: remove unused enums
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	Nathan Chancellor <nathan@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Sat, 8 Feb 2025 at 03:49, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> Remove enum crc_op_size and enum crc_type, since they are never actually
> used.  Tokens with the names of the enum values do appear in the file,
> but they are only used for token concatenation with the preprocessor.
>
> This prevents a conflict with the addition of crc32c() to linux/crc32.h.
>
> Reported-by: Nathan Chancellor <nathan@kernel.org>
> Closes: https://lore.kernel.org/r/20250207224233.GA1261167@ax162
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  arch/mips/lib/crc32-mips.c | 9 ---------
>  1 file changed, 9 deletions(-)
>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> diff --git a/arch/mips/lib/crc32-mips.c b/arch/mips/lib/crc32-mips.c
> index 083e5d693a169..100ac586aadb2 100644
> --- a/arch/mips/lib/crc32-mips.c
> +++ b/arch/mips/lib/crc32-mips.c
> @@ -14,19 +14,10 @@
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <asm/mipsregs.h>
>  #include <linux/unaligned.h>
>
> -enum crc_op_size {
> -       b, h, w, d,
> -};
> -
> -enum crc_type {
> -       crc32,
> -       crc32c,
> -};
> -
>  #ifndef TOOLCHAIN_SUPPORTS_CRC
>  #define _ASM_SET_CRC(OP, SZ, TYPE)                                       \
>  _ASM_MACRO_3R(OP, rt, rs, rt2,                                           \
>         ".ifnc  \\rt, \\rt2\n\t"                                          \
>         ".error \"invalid operands \\\"" #OP " \\rt,\\rs,\\rt2\\\"\"\n\t" \
> --
> 2.48.1
>
