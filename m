Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DDAD1C84B8;
	Sat,  6 Sep 2025 21:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757195082; cv=none; b=iHM+2tFhz/KDntuVyTCfdntV4fJN3syRI/PIzPtBrsp5bLuWt5VB5q0z0O9PL1tzkfjLVVdIr4/JrZ2rJAC5lK1P1olunEwN726dMUg8Aeoh0t4lxaUPq+o3X7dxL+wsh+WQgXxAT446BNTOtNbuv/n3eUvpKSoaUNlQz7Q3Vpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757195082; c=relaxed/simple;
	bh=gwfh68oMkRTSH1R3N9Af4GojEV1OW8M+fSIxaenodpY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KAToHgMvFWG4Ha+c5utc9+9whVhF3yNhKZvXvCTfUGLUAmIRI/mnh42rnUoZGU3kIDFgUxSrzfxy6xnhUbEI7cfcEygNXJg1TTcqQfSZgU5X5R+jmq0YBNWH5zlrd5oe0ftpVnnW2yKVCeKhhv8qQV6a6grnmCxz9XKrR8h+rOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MDvStL0M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MDvStL0M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B986C4CEE7;
	Sat,  6 Sep 2025 21:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757195081;
	bh=gwfh68oMkRTSH1R3N9Af4GojEV1OW8M+fSIxaenodpY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MDvStL0MkcXoDiDngrcrLj3boAtY+1gBPvlYqJQ0Rn9NlZEIQs3ZZTSv6KOH8n/rU
	 PXYZd8KRklvq9m8m0v6RphoTy9CxCw4aBz1WAhnqzOvIIGiklHNxOqESf+AfuXvUQA
	 Rye3yextOdB7pwDioAIyTNWZoP8sIbJL2EY1G4Uzy6ayiopkGIm8typPw+k3aCCs2a
	 tyDNhKhPoZK3yoc8/fRg/usd8PtEPVCoMzocdBB4EL8PQroxJigerVE5QRwvNDW4rN
	 sqT57q5JDP0/ycdkeZb6ArspBA/lJJlDsiiMVEMkbFmwCJRH/Hgw52ApU3yI6jNLET
	 oAFi1XpStfsDg==
Date: Sat, 6 Sep 2025 14:44:39 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 00/12] ChaCha and BLAKE2s cleanups
Message-ID: <20250906214439.GA47837@quark>
References: <20250827151131.27733-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827151131.27733-1-ebiggers@kernel.org>

On Wed, Aug 27, 2025 at 08:11:19AM -0700, Eric Biggers wrote:
> This series is targeting libcrypto-next.  It can also be retrieved from:
> 
>     git fetch https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git chacha-blake2s-v1
> 
> This series consolidates how the ChaCha and BLAKE2s code is organized.
> This is essentially the same change that I made to the other algorithms,
> so this should be fairly boring by now.
> 
> These algorithms were the last two users of
> lib/crypto/$(SRCARCH)/{Makefile,Kconfig}.  So this series removes all
> those files, finishing the transition to the centralized build process
> (at least for the algorithms supported by lib/crypto/ so far).
> 
> This series also makes the arch-optimized BLAKE2s code start being
> enabled by default, again following the pattern of the other algorithms.
> 
> Finally, it adds a KUnit test suite for BLAKE2s and deletes the older
> blake2s-selftest.
> 
> Eric Biggers (12):
>   arm: configs: Remove obsolete assignments to CRYPTO_CHACHA20_NEON
>   crypto: chacha - register only "-lib" drivers
>   lib/crypto: chacha: Remove unused function chacha_is_arch_optimized()
>   lib/crypto: chacha: Rename chacha.c to chacha-block-generic.c
>   lib/crypto: chacha: Rename libchacha.c to chacha.c
>   lib/crypto: chacha: Consolidate into single module
>   lib/crypto: x86/blake2s: Reduce size of BLAKE2S_SIGMA2
>   lib/crypto: blake2s: Remove obsolete self-test
>   lib/crypto: blake2s: Always enable arch-optimized BLAKE2s code
>   lib/crypto: blake2s: Move generic code into blake2s.c
>   lib/crypto: blake2s: Consolidate into single C translation unit
>   lib/crypto: tests: Add KUnit tests for BLAKE2s

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
