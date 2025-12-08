Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70D4E2C08B1
	for <linux-crypto@vger.kernel.org>; Mon,  8 Dec 2025 23:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765235410; cv=none; b=JYTlA/r7MBfnoT+lUStDXDnBlpXQpydLw0Uhu9p48VZKB99/cLRk3ZdyRCWMDX85ajc5t8QkotAcGb1hJ3keM3sDFz7JTaB+RN2nN+ZYFam2vQ6EeuNbjgBjFUPXSIaNqjrWLmH143l8kXADs/X7vKcQAmyOoWgxEPrJzFwG6kQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765235410; c=relaxed/simple;
	bh=w1a+5KzSjw1JCflihGEgubmpJqJeJd1VSzBNJ/LyIFE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E5AwDuO8nkVazYVOQTWM5ZSdl/l6ejRtJOJCVLf8H9Iqcn3hBDJW5qawtnDHKYzbyP6vXTy600uyzujeKooC+ijrYpx0HP1Zn+PEQkfBNGE3c2OYZbHISLNzWxIo1D4TKFNwR3IxLsn4fXFNKp0NIW73vjqMlBNGBCh4dCAr+Y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KLR4QbVx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KLR4QbVx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF601C4CEF1;
	Mon,  8 Dec 2025 23:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765235410;
	bh=w1a+5KzSjw1JCflihGEgubmpJqJeJd1VSzBNJ/LyIFE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KLR4QbVx1HQbVv8xmgrgmsD99F3hTiO9tDCrPIUlT4TzJEzDAuZOWKZgoJaiqbVdh
	 9MWFLWgXSBDLoKTN9FPl+Ka2eXN7p+UsD2z73NCmBvM7f8ZZmA3B6vWI08o2NHXypA
	 IAv3hBfZuRwncdiBDcKad0D0L0bFr5RLzXWXPQ6Rs357u6aoYBv8C7hFOhxadKPFpN
	 RGR84diyXShakvbWtzVmimC/NbMB9v90nahUdRmTaDWw13sXCzGhJwXpeKASfKmV8n
	 JEDKL21eW+rl5mkRTyHERcP8yCO+emzBtYYM/PU3s0Pl607iHdqWS2VcIS5ZPu3xZZ
	 ct3pqSbytZeXQ==
Date: Mon, 8 Dec 2025 15:10:08 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-crypto@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/2] crypto/arm64: Reduce stack bloat from scoped ksimd
Message-ID: <20251208231008.GC1853@quark>
References: <20251203163803.157541-4-ardb@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251203163803.157541-4-ardb@kernel.org>

On Wed, Dec 03, 2025 at 05:38:04PM +0100, Ard Biesheuvel wrote:
> Arnd reports that the new scoped ksimd changes result in excessive stack
> bloat in the XTS routines in some cases. Fix this for AES-XTS and
> SM4-XTS.
> 
> Note that the offending patches went in via the libcrypto tree, so these
> changes should either go via the same route, or wait for -rc1
> 
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Eric Biggers <ebiggers@kernel.org>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> 
> Ard Biesheuvel (2):
>   crypto/arm64: aes/xts - Using single ksimd scope to reduce stack bloat
>   crypto/arm64: sm4/xts: Merge ksimd scopes to reduce stack bloat
> 
>  arch/arm64/crypto/aes-glue.c        | 75 ++++++++++----------
>  arch/arm64/crypto/aes-neonbs-glue.c | 44 ++++++------
>  arch/arm64/crypto/sm4-ce-glue.c     | 42 ++++++-----
>  3 files changed, 77 insertions(+), 84 deletions(-)

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-fixes

- Eric
