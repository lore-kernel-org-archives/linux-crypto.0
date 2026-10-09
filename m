Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 082A4341057
	for <linux-crypto@vger.kernel.org>; Fri,  9 Oct 2026 17:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791566740; cv=none; b=mg57/sJYPArRG/UpByAbhdwb22D6tTWeYKm+zkNDDoOSOh9sXCTQCiF7sweUL9j37ukOk6kBLTvQTf26C2Evo0e2OLVMab2dNmquaQQ3/L6jx5MrOc6UBy9ZysVSBjPOIW//k6lv7Y6MuZBFSolXrSBE95lKx1Ud7QtDNyLjoFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791566740; c=relaxed/simple;
	bh=8nMUAx3GZ9lfi1HkeQyHd7vI8XFCJwJR2mLSUodP8sk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N6J4Sq6ALpVLccCEnWjnSWukwTzony+94YqjaKUA5YG93INq46miLKoxomDLCLgArao1hMitYyj5/L1Q5nBCkD5vjr0p+3lTQMkbESAQ4GaLovNlqFLsX0t4hic0B8W4k+I9CajrglXaKM37JaYwHRkqd+CGUTKUtMEOiN0anew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=heladDnc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="heladDnc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 643341F000FF;
	Fri,  9 Oct 2026 17:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791566738;
	bh=qvI9tDv2VrX3PC6OABPcy9GmQItWOuVjtiop8uMTxkI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=heladDnchcAwRKKZ1qYtfePX4wk5hID8xBy1iFdA27yyQ2C55ddTGNt3ulBh9HlGs
	 V8zWbV/AQP4mgRQluZsDzTibUHmH1zFXrxmu6ZqHLxRuspImRIy9xfEXCZ4UnXnvZe
	 4gQPhjDWx0+c6E1Vf03NobWU3ULh7ic7ckDhiuk2rXztgz2w72XSoLMNYQ/UBDMOGx
	 JZnTaKgLHzalTjCzc+7fJXO5Jj4MBG06T0/N46F0l6HhdK9RfsTfkeS3Ax7wojsxh+
	 biFztogUMDeR5VycplX2rFJwQ3Til8P/pDzZZzLHDf7jn8qXMklzJfYFUmYOuE/zeB
	 JIZ3A5768t2FQ==
Date: Fri, 9 Oct 2026 19:25:34 +0200
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 0/2] lib/crypto: arm64: Fix Poly1305 NEON resume carry
 loss
Message-ID: <20261009172534.GB73965@quark>
References: <20261009125354.315476-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261009125354.315476-1-ebiggers@kernel.org>

On Fri, Oct 09, 2026 at 02:53:52PM +0200, Eric Biggers wrote:
> This series fixes a lost carry bit in the arm64 Poly1305 implementation,
> then adds a regression test for it.
> 
> Compared to v2 sent by Jérémy Jean, I cleaned up the verbose
> LLM-generated text in the commit message of the fix commit, and I
> replaced the LLM-generated minimal test case with a more comprehensive
> one similar to the existing test cases in the file.
> 
> Note: the second commit has references to the commit ID of the first,
> which I'll fix up when applying.
> 
> Eric Biggers (1):
>   lib/crypto: tests: Add Poly1305 split-update carry regression test
> 
> Jérémy Jean (1):
>   lib/crypto: arm64: Fix lost Poly1305 carry when resuming NEON state
> 
>  lib/crypto/arm64/poly1305-armv8.pl |  2 +-
>  lib/crypto/tests/poly1305_kunit.c  | 97 +++++++++++++++++++++++++++---
>  2 files changed, 89 insertions(+), 10 deletions(-)
> 
> 
> base-commit: 572af6872e520c7102e58362ef7cd7c2ed4342be

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-fixes

- Eric
