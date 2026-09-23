Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29CEE424646;
	Wed, 23 Sep 2026 08:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790153428; cv=none; b=K5X59yynuhVx6NeegB4JeKv/HUNt0FNyXx7+czPERSTRt6i3V7D+y+XgkAZImBDXFR8WzWgzSEbBMUgnpEkIcekKd86w+SGWNzEVqZKLHPUr2PK0FOJfxXQiEqILR8uLDRdWxOg0+Rq8CMbEPdUJl2Q6PlEICkRq25WaklIJQCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790153428; c=relaxed/simple;
	bh=qFbsRoJ0Pdm5dsYHk3/8plwt1PvCIphYjvbws+w1l4A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oQtUNTSN21RJGTM/52bS0hoqNxp364iVKv46ixA4tGg1E0nrz6o65TwDoTb5PTRQBVjFDicNBkJNs9jzY4j9Lvf0W7NCQFPexsv/JvA8Q3eRU8MMvsoaj9jfgqjtG5AzBsAWXIOo03ip/zxQf+IfULcstOplTzBxo0MDqDGq1Jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=B8xjEb5Z; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="B8xjEb5Z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=hO932NQ06DTc2e0n4ctH4CB2tn4URweJkiaBxz0DG9o=; 
	b=B8xjEb5ZxqFwFYLXqG4WKKhTMbn37PNPBxx2xdzCjcbxD86UZxAYzUMsSwk5g9M+yh6rWeg7Q3i
	nvGnIK1ekypQ0/tMzhF7LN9z+unR/ApeVQJULI02OGk3ERGMx+jDHby4J4KIDKwQFPVT+iJhLRRSH
	Ww2rlMz+cJpF6fZsEYHQDMoW3x1OwIzRXHJfv11V6gBVXTc5UswDAVOWN63CWSA9Dy+bbHXXuAa1Q
	elJTdsehOd1fHEC2VO/sPXwgGdSE8bmWTEqP/miZ8n/UmyF5Gh3hKwCf+h64+N0PkKM1IwbmM4TeX
	ljVH//TwjpjszVPq+exHYAzaS78Q+P+9hU7Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x9Ig9-0000000GyDF-3T4x;
	Wed, 23 Sep 2026 16:50:14 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 23 Sep 2026 18:50:13 +1000
Date: Wed, 23 Sep 2026 18:50:13 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <blum@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: atmel-tdes - consolidate transfer setup
Message-ID: <arOSxQ05VZzmP0qx@gondor.apana.org.au>
References: <20260916171659.129009-3-blum@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260916171659.129009-3-blum@kernel.org>

On Wed, Sep 16, 2026 at 07:17:01PM +0200, Thorsten Blum wrote:
> atmel_tdes_crypt_pdc() and atmel_tdes_crypt_dma() store the transfer
> length in dd->dma_size and synchronize the bounce buffers before a slow
> transfer.
> 
> Move the shared code to atmel_tdes_crypt_start() and use dd->dma_size in
> atmel_tdes_crypt_pdc() and atmel_tdes_crypt_dma() instead of passing the
> length separately.
> 
> Signed-off-by: Thorsten Blum <blum@kernel.org>
> ---
>  drivers/crypto/atmel-tdes.c | 40 ++++++++++++-------------------------
>  1 file changed, 13 insertions(+), 27 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
