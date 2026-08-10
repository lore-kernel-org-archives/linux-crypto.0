Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 138E33A4F5B;
	Mon, 10 Aug 2026 08:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786350409; cv=none; b=idsMFa4QeNLZzpaB3J45/VPNsdQNHOWlXMCXz3RM9ne2P16aw+dPgSbqtoLqJNO64mF//bsXF71BgnuJE9ER6zhT+KF/hDvJvAibuam5frSIWEtbin4+KoHJ9XczVIdJ/M9wJ4p3lvKb6/4AQvuKwCwBSB5lvbQ6hIQQ7XtNbCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786350409; c=relaxed/simple;
	bh=AIoEiaTk+mNU2cDCLHsvjVOaaUpe0+qoNqa0sV/PC4U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=an4Xd3rmkjZuZWOogwPLRHiDAaqmfIAtjmlwN3eg+sidMzH+Oxa2xeYl8NLRKWkoNTAqlFejEDAyMo84RwX7CROKp4Tzlo2vKPjAGDI7mtioWiDzg2l0lbCeOS0gy85M8XQY0GNd7DEpB+U0yAyoDYUquQVtCiVc5s7ytgXF0xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=oETLbnAg; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="oETLbnAg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=EeN+7i9ajU/dD3F9RAbJ9KjLrqh56SYkoriI9RmjyKI=; 
	b=oETLbnAgnYh3EPViBTtOILmJyEWQp1041O32dJa3vVcnQZYIbAnrzaXoSrIzJLJ8Rjiv+pWf45v
	eKyk5VhtTfBmc1a+GqJbdpXoU1xHjpltU/lQ34k3EaJwpLvL+G95kLc6QJm4GTkHTYcYmVhQU4w6d
	QQBg23gFMNDpgKpec5m1fhegEnEv4nS2N+c9JABKZ4n08wdbK21bmK0grOBbZRr+st8UeyZMeo/Bl
	Jne7S7dU8mIWVpOaP3hbTifYGGxAafhfWyL8SLqYjzEafH4nGGoLWXaWHVeKHHH8fYYRkJV2JjsP0
	jbImRQviU3drMqnAE9l3l02TJkcc5MMy8zVw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wtLL5-00000003WeA-0r11;
	Mon, 10 Aug 2026 16:26:32 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 10 Aug 2026 18:26:31 +1000
Date: Mon, 10 Aug 2026 18:26:31 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] crypto: atmel-ecc - simplify control flow in
 atmel_ecdh_set_secret
Message-ID: <anmLN8KKX7rVCwp2@gondor.apana.org.au>
References: <20260728205825.471233-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728205825.471233-3-thorsten.blum@linux.dev>

On Tue, Jul 28, 2026 at 10:58:26PM +0200, Thorsten Blum wrote:
> Free the public key directly on I2C transaction failure and remove the
> free_public_key label to simplify the code.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/atmel-ecc.c | 11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
