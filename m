Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC88A3DD512;
	Fri, 17 Jul 2026 08:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784276060; cv=none; b=lNIlLWrL7nFxmf4CoqTD1oChuUNE2J4fMskbLbOq6znTS7ZXA2k/qi62gCcWdh3Y/MwitvCtehYgOsaeGgnlrUKiT7kvNHOR7URXY4Ig3cg/6YTwCLquP92YJ8qh8ilpvZL8Zskg0iKWFb05XL07prH1ILOXcg7jrqf0uc0GFYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784276060; c=relaxed/simple;
	bh=XfKEYe6AXFXgI8WM6RjJBad24csPJO5z5UH5OxNFr8U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p/qTAnWTwmKBJxQTXwv3xFxOpZDN2jXC+tzQxoGgCXUoJcQYK9780gubw8VFblIyFdR/UEWxQa+BEgJAhLm8aMv605qOQ+fkzHyEymgI/IgQ4vk1H4BI4uJzLoqm/TiQ1l+pDrwUNdDQXubl1FpZQQnZ0Uk/z+TOKcJyONAVdAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Jo5JwX5t; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Jo5JwX5t"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=9z91ILlxQtYqvnBQwnktbnN3/Hw+eSYMXdhvRXnuXjA=; 
	b=Jo5JwX5ttm1a0aFE3FRT6/R0B+5PjG/lrzmg6hihJWuEVMo7fGAGK15Gf65LKg+C+4Eh/LtS655
	tIfI7qhJztpt/2bRt2Qc7hTLYbsmVIFWNP3ufhsU5QDN8gF6XVBx2hg8+l3l8PDtkcFmTtd+0Xu44
	MCHNAgwZSuwnRMOqEG5UjPkLAiMfEhw1aka87gXmuMRpc3WLqNte4qjIq6CVFrStBMy0FtdDU5KMl
	p4kT0BMN7XI4NVBx/APLqsiqa5vGet6QryBPjj1S6i3ftuWcq8j2MkFoABzYj8MeeKVtRd37F7BUK
	wgo1n0qMeD1IhybUCHvelRVwcwrFKF/f9FeQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wkdhq-0000000EO72-1uu9;
	Fri, 17 Jul 2026 16:14:03 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 17 Jul 2026 18:14:02 +1000
Date: Fri, 17 Jul 2026 18:14:02 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] crypto: atmel-tdes - simplify fast path in
 crypt_start
Message-ID: <alnkSoU0swZzyh-i@gondor.apana.org.au>
References: <20260706150404.382209-5-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260706150404.382209-5-thorsten.blum@linux.dev>

On Mon, Jul 06, 2026 at 05:04:05PM +0200, Thorsten Blum wrote:
> Fold all fast path conditions into a single boolean expression and drop
> any redundant checks.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/atmel-tdes.c | 24 +++++++++---------------
>  1 file changed, 9 insertions(+), 15 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
