Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E88B928FC;
	Sat,  7 Mar 2026 05:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772861407; cv=none; b=nwtgHfkWUdi3v0/JrfSQ05mHIaxutxP/mVUCIQxYzWq75/AmeqGnlJ0iadI1SCEU2+enJ5a1ENMw4zCm7Lv7OeC0tHPxviSmLI93z+w3AWkTEtcD/ryta/Jeif8g+BcQ9knuTPkDt5iLWjW3jVS+wfspRZKicYLazE3joyjIfcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772861407; c=relaxed/simple;
	bh=SBJiMkhFr5XkTjUrlirXUZKG+Bk1W5NOePiRXerC/aQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mxzkz9dlGYMcHMpWd3MGPaoB0YNjjLniyknlFC3Lt/t94RNoNxPXSe1UNN1EijTUcstIG2Zer1DLuMEpXADgE3IMXUT2nf1Cek++kNC9JfWAsDyXEOENjOpLKCYe92Pn0FlupYyAXh5a769mBxYpJXzhCAw9uN9xuGDlXYxDLm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=g2ii4N9K; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="g2ii4N9K"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=ik57wtQI0JITE+23AU51z6Ud9QY793AQ76FK53fxLlY=; 
	b=g2ii4N9KFQAhOKSt/sUsywDAz71AUsZxiXkA06nm5n8i8nsEyP25Lb2QjR7V8xCfzFZTopv4W38
	wK528Th6g6MTxXp+4p624HWzekl+mu94/I77vi0IfA43zpceHTcGPoZ7jTiMJfmkMXdru0dHQAQsp
	KgmIVChHXq3KECSh3rWRWnonWNmUmi1rhvhBqOB/+Ds8n/7dpF9U/7HGs81fMoEqr03vg23c3pE+F
	4w0ngcIevFtu7eraRQ2ibiaYlPJ1HXyflhDGTwtKQ5gVJZ87/39DIvvcoj2gVnARIIKWZeXwCuYvF
	23x4RV88EGx3oxtQhhKmnmW4KG3Hjyn1tO7w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vykEU-00CJY2-19;
	Sat, 07 Mar 2026 13:29:47 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 07 Mar 2026 14:29:46 +0900
Date: Sat, 7 Mar 2026 14:29:46 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: atmel-i2c - Replace hard-coded bus clock rate
 with constant
Message-ID: <aau3yuTMe67fgQvG@gondor.apana.org.au>
References: <20260223165737.342015-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260223165737.342015-1-thorsten.blum@linux.dev>

On Mon, Feb 23, 2026 at 05:57:37PM +0100, Thorsten Blum wrote:
> Replace 1000000L with I2C_MAX_FAST_MODE_PLUS_FREQ.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/atmel-i2c.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
