Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 379B7184524;
	Sat, 28 Feb 2026 08:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772268996; cv=none; b=C0DbmOscIxAUBwGDZncrXDvpxQmKGK1eKUkg2yv+K60o7ICr0KvKfm9nsrX4DTt8e4E2LYilNYRHFvHYUfdUaa9XFWgUOcWQoa3jHon4Y717wnOVkxK4HexuENr/H46uh7+ackKpNyxfvdDQZE2Lrlz9XqZSVl/fx7tkXnh8jOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772268996; c=relaxed/simple;
	bh=MN35DYoY6v1CbJ5Fx0X2KmXlpgXJ3y1FDNRAmd0oVik=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U2dz3zUdNX1hWvwe7UL2jbcoFe5MmXnUu6AYKlr92obIfvrQISqblrzT8clkIRTcErzPMl+9/F1/DcQ7vtEFYi1gEDp+ErmcO3igqF3o9MdxGHk8kNdbn1zZVMxniHitw420IHi5SxbmGRKvGS4i6AaBI+K2wr4bjk5FMjzYNCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=MMLt57gt; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="MMLt57gt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=PENJ3u1oRqkCAFoEC2zMwPQ2xkR5GPODis8NlOlrmeE=; 
	b=MMLt57gt9Whtpw8hvHkKwcRH88DbW+Z823Ec6k/axa1Cmnygyi/jISh9VOQGFi07vFGD4CtTKiS
	BYtc4MVCFg7yqhZHh/GRAR8FVOamYTA/JEAk4AU5f0VJTfOV1JPvoL4sWaem1SkoomaYQRP8kdUr8
	N3OW/VjsL2NDyAiHBTWjMMAP2GSFQbc1oVLABkj0Zx+nMN49KBDHLp5htWbHDUFReaQPbmvztqhfo
	JlBlSqwZaUmnHc7rJb+m/aAjtrZv8ZOCIEWWiC5YmBA9Zr0eltxYp7ORyzxtZ+Mc5prxFncFOyhf/
	YBmQGstX6NPafS/JNygXNy5AZ9J+uuUQPfUA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vwG7e-00ADwE-2z;
	Sat, 28 Feb 2026 16:56:28 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 28 Feb 2026 17:56:26 +0900
Date: Sat, 28 Feb 2026 17:56:26 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jeff Barnes <jeffbarnes@linux.microsoft.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jeff Barnes <jeffbarnes@microsoft.com>
Subject: Re: [PATCH] crypto: aead: add service indicator flag for RFC4106
 AES-GCM
Message-ID: <aaKtujHwV0zDFWxi@gondor.apana.org.au>
References: <20260129-fips-gcm-clean-v1-v1-1-43e17dc20a1a@microsoft.com>
 <aXw9Wj19ZX6dpNHW@gondor.apana.org.au>
 <ce1d34d9-23f9-4d1e-b790-6af75d1555ed@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce1d34d9-23f9-4d1e-b790-6af75d1555ed@linux.microsoft.com>

On Tue, Feb 17, 2026 at 03:59:41PM -0500, Jeff Barnes wrote:
>
> I don't know how to accomplish that.
> 
> SP800-38D provides two frameworks for constructing a gcm IV. (https://nvlpubs.nist.gov/nistpubs/Legacy/SP/nistspecialpublication800-38d.pdf)
> 
> The first construction, described in Sec. 8.2.1, relies on deterministic
> elements to achieve the uniqueness requirement in Sec. 8; the second
> construction, described in Sec. 8.2.2, relies on a sufficiently long output
> string from an approved RBG with a sufficient security strength. My patch
> checks for an implementation of 8.2.1 via rfc4106(gcm(aes)). I don't know
> how a patch could check for 8.2.1 or 8.2.2 from an externally generated iv.
> 
> Suggestions welcome.

Rather than setting the FIPS_COMPLIANCE flag, why not simply ban the
non-compliant cases from being used in FIPS mode?

Sure that would mean banning gcm(aes) in FIPS mode, and only
allowing seqiv(gcm(aes)) but that's OK because we have the
FIPS_INTERNAL flag to deal with this by only allowing gcm(aes)
to be used to construct something like seqiv(gcm(aes)).

Of course this would need to be tested since FIPS_INTERNAL was
introduced for something else but I see no reason why it can't
be used for gcm too.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
