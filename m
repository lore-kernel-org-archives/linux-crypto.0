Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFCE12D7386;
	Sun,  5 Jul 2026 05:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783229542; cv=none; b=HZNsAWEB7b21zwjZ76S6n+rmlYlBRqGPLUuPfEGqnDyECWclRHKjoli7JdVjD8vrBv5n695jGrgCr3ey4wZhWCDigIl7rLw4j8KJBUa4RYnPDGcuM9K0q6tWcc0YKQv/O3wQbkwprTkC0QIzKP/lGbb69Yjz4+pfLsrNiCFC9Sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783229542; c=relaxed/simple;
	bh=+FtwOO2tAhuUZyfmQpemSi0iiRwGELL2fUvyxWJgcP0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cdO700vo8foPq1PKGPpEhJdpBBSxhPpz9xlNXI+Xgur3OsAzDKu6h1aGc+kA+ldM1YP++KLnBenkh5b8hOCjlahL/oWIljo6fSQEmc5gdSgSxqPnZFcjhi/c4nXoBsUwbhU72SYJAZqZbOyFhvXYzhp+NVUCrGRsG44I/Jj7XM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=X+WJuUyW; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="X+WJuUyW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=Q/K+U8RtoxLD4AghOpbVPDReXNYLDr3EnrdkatDMFKI=; 
	b=X+WJuUyWUjHYzWpqdqapexUVrgyBQZT1Pc5O+SOae4rK/M+b/qEX0B2uV0ZT+jxEO5Z4bu+kOjB
	n8w7tNN5YNn1KemIoF5C8t7mQ77lxuUsKJ/0wc6TzawVTKuFsNf2HHoQyh4W8ZYeRM5jOND6boBr0
	EbtzDSgWkgEYyxC37aQh2qyimIdfIQlPqyEpag6AerPj4UoOsEeFzbs7MvPkmkiCk52CWfDtjVtiO
	FsvCNLTt2bB4mvRDaxVyBsaPOBnO5290J7Y1CKIF9FoL4GEBVg6VRltkYXbCz+dpJvIMe5wVTw/uX
	QDPiSMg34S9wNBK2LoaXW3xA+LTFEqFpXNMg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wgFSP-0000000Aje9-1lDo;
	Sun, 05 Jul 2026 13:31:58 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 05 Jul 2026 13:31:57 +0800
Date: Sun, 5 Jul 2026 13:31:57 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Olivia Mackall <olivia@selenic.com>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwrng: atmel - drop __maybe_unused from atmel_trng_pm_ops
Message-ID: <aknsTUIswYXFKBm1@gondor.apana.org.au>
References: <20260606131755.10132-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260606131755.10132-2-thorsten.blum@linux.dev>

On Sat, Jun 06, 2026 at 03:17:54PM +0200, Thorsten Blum wrote:
> Since atmel_trng_driver keeps atmel_trng_pm_ops referenced and pm_ptr()
> uses IS_ENABLED(), which allows the compiler to optimize away unused
> variables, drop the redundant __maybe_unused annotation.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/char/hw_random/atmel-rng.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
