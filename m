Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE01D431A44;
	Fri, 18 Sep 2026 09:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789725402; cv=none; b=PK1igbD7aFMZcMoectJVSf8hTJj06zOx+oGYF8GO9da30xH1LWcPzJrgSUiNkYJc/cbcMs8cL6MJSWer+1246SGYWGVJYIY5vAqd8dfsPdW/HD3w/jE9rVwSoH8BrEpOB6xJK0SR8JEFHHJkH4TqBdTIdkac5S3Dt+h8hR7X8Yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789725402; c=relaxed/simple;
	bh=YmlNl+zvXvZksJMG4+954NZlIhBvgXlGjH+FoBIR6Zs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=li1QaGk3pStHvnGo299gckTczh2T9vkHzyl7C2+yOB+ST3NUnQnDTRF2mnswL69t7RyDSXGzJJlslYL/+6g7Tr+oZSVxZ1ygMxCqXLP5mIQFCFtLxsBfsSq9tQuMriydI9UZyXO5qelpiQEjwiegnM3enc5orw5S36rOdCYWyCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=TgPYYqio; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="TgPYYqio"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=8fZvlcu1P62EpkpFn/DN7tWPJ+MfVsNicXb7/rCtLBs=; 
	b=TgPYYqiokGmptU5MwgVm4wPhOn+PD34jYzH27/oEIG4WzqqHxWRDJL2FQRRYJgfJ+j/xmvKuq2H
	D/N0Pky1Kv6BfrV/zShQlRigDLaJOegmnrfo0Sp5aEYLCxXi5WqU9gJr7JlHcJi5p03I/+ugq82Qx
	ECU9z/YAcTmK8FdSrpD5tH8AY9rGILIxKE+EeZ2jGRklUkJJyxg7aa0wJYj9/JD6FuhWBFqfPuHBp
	8CFKmoPB+KblZD2JT1F0uTtqov+5oPhpxr9CF1Gdf08EfzP7FB8eiBhp6C0g4qYq1UIiwrJOExqZ3
	8v/A/isIeNHAQ7HpcXW0ltv6XhJdRnayY97g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x7VKd-0000000FM3f-3C9G;
	Fri, 18 Sep 2026 17:56:36 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Sep 2026 19:56:35 +1000
Date: Fri, 18 Sep 2026 19:56:35 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Guangshuo Li <lgs201920130244@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, Tero Kristo <t-kristo@ti.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] crypto: omap-sham: fix crypto engine cleanup
Message-ID: <aq0K0x22WHS5bc9I@gondor.apana.org.au>
References: <20260912144608.994510-1-lgs201920130244@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260912144608.994510-1-lgs201920130244@gmail.com>

On Sat, Sep 12, 2026 at 10:46:08PM +0800, Guangshuo Li wrote:
> omap_sham_probe() allocates and starts a crypto engine, but the remove
> path does not call the matching crypto_engine_exit(). The probe failure
> path already performs this cleanup.
> 
> crypto_engine_alloc_init() creates a kthread worker for processing
> requests. Without crypto_engine_exit() during driver removal, the
> worker is left running after the device is removed.
> 
> Call crypto_engine_exit() after unregistering the algorithms and before
> tearing down the remaining request handling resources. This stops the
> engine and destroys its worker.
> 
> This issue was found by manual code inspection.
> 
> Fixes: 133c3d434d91 ("crypto: omap-sham - convert to use crypto engine")
> Cc: stable@vger.kernel.org
> Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
> ---
>  drivers/crypto/omap-sham.c | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
