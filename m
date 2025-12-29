Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A7731A8F84
	for <linux-crypto@vger.kernel.org>; Mon, 29 Dec 2025 00:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766969498; cv=none; b=fOeVMDGhykGUNvkfEnd+2G0VoyppUs3epeXvH03JbQI9b3sZN8SpmUs+biY6dTTKM6cQjN2kyaJouCRHLjgK1BQoJO/aRenzXb/COOMNZYWyVmsLfEdy624meNRRjN5uDHupM3PYnWeMkUeSPqa04pR3HY5t0pQsXItKnAk1QFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766969498; c=relaxed/simple;
	bh=taaluATutcNrELB61lIcorYtLAfGntpQ2UsKqfOgpQ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D3UETVocS/Kk74Nd1r70hi5TTQ9OQQ4pn1BWDHHZLjtn7jZXRgBn2uT25P6awaKzlwdOKx4qT6tuw1LItn578wdDOlXk8tE39HUS3yQh0wxxDKkHUr98a9itG6aDiwFnxwEj3YY0LZGO+Zvs2YykMmkFlM06j06Rh25vvPy9KGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=WV1u4K8f; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="WV1u4K8f"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=20XY5DbQ7wDO0BZizRlWD1naiLGDp7vX9D4+DGUmpQ8=; 
	b=WV1u4K8fne7fEQV8qDA0nleYDU+h9q0eNVzdVV7YcIpsMW3nc31w2fSn1PTUczDXU0eaj37ZX3F
	X3nBnyaRbDDyb4Ha9+/z5JqfdKhFOIHtyI7XbiS/dX6iujOsw7WoWcG/t6xHXVrL+S/4NbWMCe6Nx
	Rdnsk4CzNbgZdTk082+CmRcx3yfeQYVEsW9gqpT5c6tLAToPHGDt6dt7G63rzMAR+V5RWLW0nGzCu
	tqtWBJSK/hxlrPzCWUDa9GvMYIF6R6+AsudL78BNV8mYYtq642WDn2Wd2shu61757oTUWFZSTm1il
	kKsdjIGTZqGfmetHyNxDxdaeUblEbgAEiRWg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1va1Tq-00D0GL-1S;
	Mon, 29 Dec 2025 08:51:27 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 29 Dec 2025 08:51:26 +0800
Date: Mon, 29 Dec 2025 08:51:26 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Sergey Shtylyov <s.shtylyov@omp.ru>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 0/3] Several simplifications in the DRBG driver
Message-ID: <aVHQjt-m0BMNa1yv@gondor.apana.org.au>
References: <20251217202148.22887-1-s.shtylyov@omp.ru>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251217202148.22887-1-s.shtylyov@omp.ru>

On Wed, Dec 17, 2025 at 11:21:42PM +0300, Sergey Shtylyov wrote:
> First Simplify drbg_fips_continuous_test(), then drbg_get_random_bytes(),
> and then its callers...
> 
> The patches below were made against the master branch of Herbert Xu's
> cryptodev-2.6.git repo.
> 
> Sergey Shtylyov (3):
>   crypto: drbg - kill useless variable in drbg_fips_continuous_test()
>   crypto: drbg - make drbg_fips_continuous_test() return bool
>   crypto: drbg - make drbg_get_random_bytes() return *void*
> 
>  crypto/drbg.c | 49 +++++++++++++++++--------------------------------
>  1 file changed, 17 insertions(+), 32 deletions(-)
> 
> -- 
> 2.52.0

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
