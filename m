Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D163A2576;
	Fri, 22 May 2026 12:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779453313; cv=none; b=kZ1YGjn3WBFZt/O1uErjYcg+3rWJ8z49smuYTCyuWyi3y1fVsk4Ja3wJiD6kolFTZzXl32gQOJCaFcDWyY7FDQkexSyGxjo+EBSvKrHUbrYwWCwCQGl7L3u8RanfjkjA1bO9c7UCzeRZSYH6US0w4tk8XQ6QXgUeP9JO3vRGDh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779453313; c=relaxed/simple;
	bh=9hO+8Rz3Sn8lKcNpYElBUknWB5z2e4DBXSn9+v5UIhM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X64mqr0W91l4e1uoTXXhPaYy5cHfMrJoRQV0AZTflDd6IOqv58AjySMarD1m03WRjSXMN7UM0c+GmEo0qJrysFFow+MTZ24qi79uJ1mfzXo4BhI5fF8FF2eFmGakzP93TeCXS9UUVdZlvZ82yMpqokG+CxR5x+nYdick3Oi/RQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=o2FhxGqz; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="o2FhxGqz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=logEAC/y6L8OMdAdQxzGzvXVtC+AZZLeeQZx7UaemU0=; 
	b=o2FhxGqzI7ZpPAcZevMwy7MeFY2tXAs4aF4OwdQXTc7oH824ip9P1JMid0mdIRnGni7Mk7O6v7Y
	ng8Qo/pQS9QRy00lInKho97NCd0tk8nwWxaaIFXvf/Jmv4UKUCZGlZSP84Y4jU/dEZWj8dDcltNbL
	xKoTG0Yeyc1/URKNcym0qLhmVpKLzcOuOsycsl+yi+xWK2cmmuEmoJWRRMgw8dczRSdWYzUQthPZ8
	9u8wTOZnIjJUYEfdfJvZmid6H8GIlLp12ox6M5PzQX2EirDab/RDI98nV0Q2euZrLyVF4S6rTIkXj
	CPPR/XwOc+nmMBnR5po6Zqzg4WC0BXxReHBA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wQP5e-00GSTG-09;
	Fri, 22 May 2026 20:34:59 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 22 May 2026 20:34:58 +0800
Date: Fri, 22 May 2026 20:34:58 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: atmel-sha - use memcpy_and_pad to simplify
 hmac_setup
Message-ID: <ahBNcrfyKD5mwQ0Q@gondor.apana.org.au>
References: <20260516234211.1131137-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260516234211.1131137-2-thorsten.blum@linux.dev>

On Sun, May 17, 2026 at 01:42:12AM +0200, Thorsten Blum wrote:
> Use memcpy_and_pad() instead of memcpy() followed by memset() to
> simplify atmel_sha_hmac_setup().
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/atmel-sha.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
