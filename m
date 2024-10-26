Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5148F178CDE
	for <linux-crypto@vger.kernel.org>; Sat, 26 Oct 2024 06:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729925909; cv=none; b=Ets0fYKml+8kmvZWSJXkqGZQpkhcm0YG+W12ZbqJIRtIhI3izXZExBe4bLt4RQkyP+BvBSXN6clgXAErdYd1J3KeKQjOquAFjYDZ8WVZXVPmXjm5m5LczmuaSVHOyVgodHCI2Ud/XWLPJ+67SzFiFY5FY3gp18K8oJYvbHdRPik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729925909; c=relaxed/simple;
	bh=ZFJTDs17hHMkTzgVQFFLllOMFj/Z7mHijlQ8AZoqYF0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fqVAs1QZ4xh4CGnfl65BoU6RaganTBfluHERJP91tiP5smch0crhX5N7zFzTJfSEcr4+vR/fyXRlTHFkIVGVEhUwiS6S0pUDKxuPpskygYbCMSJNdnJtjKRrRDX++c2IyrjhlvCJK/dTyRi2LykYtPqHslnGzhFXN8cChxM1f0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=qhEoMUhn; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="qhEoMUhn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Z7JjEp9xPVy5pWT5kTyjYn4GZovUE6D3j8pqL4//+Co=; b=qhEoMUhnVSNvrqHjR6FqCJJyGf
	7YLn6RZS3Pc9lw8viTpTzGoQpystTjZyK6Sf75qU9yIjos0iHyIO8Q6U1yOFD0E0YIe/84O1PTMLE
	mxUH5MM64ILDSREy0LCpYXmZ6tmmnUnKI7bxKP4scw4+rBkWOAT2uQtGiyw3bmtvFoOYZKXtFMS6I
	Gpom9zdLKnC5Bp/c1ew6JUGqU4Wk0EkBPpCPtFxGDTKv0m6tiXVMpvRkJfSAPY8nu1cAy2DtrWAXA
	Sew3RgdAtjStJp3+CKQAXktTyYdl66xm9NkRjrXokxLCMaN03DiWYX5N8Op9K18xJpd9Q+/xnF3QQ
	sl5eJsWw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1t4akh-00CFyj-1k;
	Sat, 26 Oct 2024 14:58:24 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 26 Oct 2024 14:58:23 +0800
Date: Sat, 26 Oct 2024 14:58:23 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-crypto@vger.kernel.org, ebiggers@kernel.org,
	Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v2 0/2] crypto: Enable fuzz testing for arch code
Message-ID: <ZxyTD0Pvy3xDG7xz@gondor.apana.org.au>
References: <20241016185722.400643-4-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241016185722.400643-4-ardb+git@google.com>

On Wed, Oct 16, 2024 at 08:57:23PM +0200, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> Follow-up to [0].
> 
> crc32-generic and crc32c-generic are built around the architecture
> library code for CRC-32, and the lack of distinct drivers for this arch
> code means they are lacking test coverage.
> 
> Fix this by exposing the arch library code as a separate driver (with a
> higher priority) if it is different from the generic C code. Update the
> crc32-generic drivers to always use the generic C code.
> 
> Changes since [0]:
> - make generic drivers truly generic, and expose the arch code as a
>   separate driver
> 
> [0] https://lore.kernel.org/all/20241015141514.3000757-4-ardb+git@google.com/T/#u
> 
> Ard Biesheuvel (2):
>   crypto/crc32: Provide crc32-arch driver for accelerated library code
>   crypto/crc32c: Provide crc32c-arch driver for accelerated library code
> 
>  crypto/Makefile         |  2 +
>  crypto/crc32_generic.c  | 94 +++++++++++++++-----
>  crypto/crc32c_generic.c | 94 +++++++++++++++-----
>  lib/crc32.c             |  4 +
>  4 files changed, 148 insertions(+), 46 deletions(-)
> 
> -- 
> 2.47.0.rc1.288.g06298d1525-goog

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
