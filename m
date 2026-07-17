Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC2A7318ECD;
	Fri, 17 Jul 2026 08:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784276142; cv=none; b=d0pZWRqP/CpRkhhekB6KBZgwBfNYWf/1pYgabLiyp/1EjTKGUV/ujDY5Nv0rAIXbcwUM43LCtvBji2RnoYQBJMxOg8mR7hN1y0s3jvu9VXtIizwAK6GyQiVOW35v67U4uPLNWFWNQWwdEunlLnraPjNgUySocC022BW8VuxsP1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784276142; c=relaxed/simple;
	bh=B0gH4HnzVvRKdmJreLVlh3Ip7Hxpknw3HEABjYqPRzA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nfzHWthNfzFNPDcH85SuK88XXAsmbsRatmdkNmn54jXfqswaTlTPsjnV2UtONagrN4p3bsc8tIVzCua0JpUP3C6GhMbMYgvfsveirX+iz9m3RKUvzrIybKExqE5ueJMPFW22tlsq4lBHxDReNpm/yEpzucwiQlYoFYKKFHNe8mQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=SSfj455B; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="SSfj455B"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=h802mIkXadPL8h5kJf2NzfoZ7DRWSCCV9EHtJsZgnII=; 
	b=SSfj455B+j3RDqYl1JB0EnsLF0YfW9+5flLDp7oIr/iZ7mYJMykG47h3U2EpVCGo04fzH9snVTy
	myQrbHNGhg6s4TYKq0n/hew8cvlDti6hVvRqAzVzqXfrfmcKkyD9MvKJwnkmXs1OOoQkO2xdH+eVx
	P0Jj/utSfbfNp/VLWS333M4rGhcVcWnJiyjqHG1Be5g83njcoofjg9sZwsfvh4HDDVzO5Z9WHxKC5
	Ldg4+cO+W9/LnqynJZRliTYFog9zLXAqYbAxcCzcZAEqEr8F1r8zSJZp4BjoJGW1rTv7MRm4YSgT8
	7vZpJBaH8j1SZ0OHcn6ykKluOzVaDU9/Njpw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wkdjG-0000000EO8E-3qHx;
	Fri, 17 Jul 2026 16:15:31 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 17 Jul 2026 18:15:30 +1000
Date: Fri, 17 Jul 2026 18:15:30 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Tudor Ambarus <tudor.ambarus@linaro.org>, stable@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: atmel-ecc - avoid stale fallback key after
 set_secret failure
Message-ID: <alnkovFqUjXzGmxy@gondor.apana.org.au>
References: <20260708204246.618591-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260708204246.618591-3-thorsten.blum@linux.dev>

On Wed, Jul 08, 2026 at 10:42:48PM +0200, Thorsten Blum wrote:
> Clear ->do_fallback before decoding a new ECDH secret and enable it only
> after the software fallback accepts a caller-provided private key. This
> avoids using a stale fallback key should crypto_kpp_set_secret() fail.
> 
> Fixes: 11105693fa05 ("crypto: atmel-ecc - introduce Microchip / Atmel ECC driver")
> Cc: stable@vger.kernel.org
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/atmel-ecc.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
