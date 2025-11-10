Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5267F2236EB
	for <linux-crypto@vger.kernel.org>; Mon, 10 Nov 2025 15:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762788113; cv=none; b=WRLHUBiYcJn54HsLxmdUB5a7UJ1aJo2eZR7ak7mo/0Hdu8HHb5QasA1K+EknQWNxTZlcL7XTzGwfXPdlPRVEb6ok6poNA/yGGDWTzNoOhKb32X8QdYfWNbwv1rs/d//+cz+YF2tfq+13uJ6jY0vq0gfr28HZ/pS8d5Vtlmy3rng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762788113; c=relaxed/simple;
	bh=JCUtzRvmbkdCmVZ4fqZm8IrCTYBd3uWoIG0IglRdUsY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ttAw1YP5K7fNFR0C9oJvf7iIzAQzag8VCDTwo+8F0vOz8eUm/N48fFq45fFQzvpoEkCtByLDMQEAs754e0R69Ixi13xO7v6ni/AE7EQ5flTqMYUFsg0llXeOb71MFJ0/PLJGtpJhCh5GYnsA3r87rrUzWzoU65UxiICr2RuRtYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uauCMFz6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uauCMFz6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2456C2BC9E
	for <linux-crypto@vger.kernel.org>; Mon, 10 Nov 2025 15:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762788112;
	bh=JCUtzRvmbkdCmVZ4fqZm8IrCTYBd3uWoIG0IglRdUsY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=uauCMFz6HGK3ax2RmhVM9h/Lbdgdl875vLiOiE69hahfy88eNCL9x0Dj/Hk+c7Xzf
	 y/9MqkS2XHfQCL8PfrVVajeydTyoSa981F9operMLeKaxdADS8zoTs7owZ/Qd070M0
	 Xq5UOO7cPgieqH6Bh0gQI30qLNgx8aDzUYiMY0ZostdzOhFavVdR2ml0LefbQtfthr
	 8LiAoRLnJ7Y6X39SzeZgzMwK9PBTM7Zlm8FPMcY8FSfGYLC2K2AM8/AjCUD1r1LBlK
	 yVsi/+hx6XLKrnqRV1Hpk24FVEXZBGaU+LiqXE2CzM+2yLQFBXORqdFq2QFHdJ6DiI
	 hy295t9chD66A==
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5943b7bdc37so2929680e87.1
        for <linux-crypto@vger.kernel.org>; Mon, 10 Nov 2025 07:21:52 -0800 (PST)
X-Gm-Message-State: AOJu0Yz529LBdp6cLUDevy9ts6pG750XHdWK6eH2U4hnwWCxkLSCEwum
	AywRB9ADaq/GPGTcIFt7iBDxsyHovBLdvfHxFwOCrdCK3UbFXvexh4x6m20robIPhl+7Sh23JKA
	muoWgxTrReM901R3AAfeH7ewcKuTnCbg=
X-Google-Smtp-Source: AGHT+IGA90qxUCgKbawTrvLQnKXihsfBR+wfYBPMapG2e93eFykZVqcR0ieSigBnjpQApyyYsedHo78n7CIpHnxQ0aw=
X-Received: by 2002:a05:6512:61b1:b0:579:bb21:a47b with SMTP id
 2adb3069b0e04-5945ef3a2f4mr2137577e87.28.1762788111220; Mon, 10 Nov 2025
 07:21:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251109234726.638437-1-ebiggers@kernel.org> <20251109234726.638437-3-ebiggers@kernel.org>
In-Reply-To: <20251109234726.638437-3-ebiggers@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Mon, 10 Nov 2025 16:21:39 +0100
X-Gmail-Original-Message-ID: <CAMj1kXE1mhu7u5RwhCBA_RUGV6JSDV-GQPpq+thE-0-oVxrmfw@mail.gmail.com>
X-Gm-Features: AWmQ_bniVZjRCPURX1xgSvugOeF2j7sagTMJnLfQBS0PgZ_MmRwapD4fdhXdrv8
Message-ID: <CAMj1kXE1mhu7u5RwhCBA_RUGV6JSDV-GQPpq+thE-0-oVxrmfw@mail.gmail.com>
Subject: Re: [PATCH 2/9] lib/crypto: polyval: Add POLYVAL library
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	"Jason A . Donenfeld" <Jason@zx2c4.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	linux-arm-kernel@lists.infradead.org, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi,

On Mon, 10 Nov 2025 at 00:49, Eric Biggers <ebiggers@kernel.org> wrote:
>
> Add support for POLYVAL to lib/crypto/.
>
> This will replace the polyval crypto_shash algorithm and its use in the
> hctr2 template, simplifying the code and reducing overhead.
>
> Specifically, this commit introduces the POLYVAL library API and a
> generic implementation of it.  Later commits will migrate the existing
> architecture-optimized implementations of POLYVAL into lib/crypto/ and
> add a KUnit test suite.
>
> I've also rewritten the generic implementation completely, using a more
> modern approach instead of the traditional table-based approach.  It's
> now constant-time, requires no precomputation or dynamic memory
> allocations, decreases the per-key memory usage from 4096 bytes to 16
> bytes, and is faster than the old polyval-generic even on bulk data
> reusing the same key (at least on x86_64, where I measured 15% faster).
> We should do this for GHASH too, but for now just do it for POLYVAL.
>

Very nice.

GHASH might suffer on 32-bit, I suppose, but taking this approach at
least on 64-bit also for GHASH would be a huge improvement.

I had a stab at replacing the int128 arithmetic with
__builtin_bitreverse64(), but it seems to make little difference (and
GCC does not support it [yet]). I've tried both arm64 and x86, and the
perf delta (using your kunit benchmark) is negligible in either case.
(FYI)



> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  include/crypto/polyval.h | 171 +++++++++++++++++++++-
>  lib/crypto/Kconfig       |  10 ++
>  lib/crypto/Makefile      |   8 +
>  lib/crypto/polyval.c     | 307 +++++++++++++++++++++++++++++++++++++++
>  4 files changed, 493 insertions(+), 3 deletions(-)
>  create mode 100644 lib/crypto/polyval.c
>

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Tested-by: Ard Biesheuvel <ardb@kernel.org>
