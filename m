Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2676C2DCF4C;
	Sat, 21 Mar 2026 08:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774083143; cv=none; b=QA6RpD/RecLaHsBIqqJBZ9wYHiL80Boa037PSZVCOgUE7TFxq7eAd6NDspMl3JcbNeYd2aMnCImsA0Q3oAK8JM0w2C2w2/4LdG48Mb4dpYDMZykirCsXqD0o59+Ux/o/A0Kqqdv3UWqIB5Kwnz/Z2nxhXmzzfmvvQFKn4koZYT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774083143; c=relaxed/simple;
	bh=zV3ZpNCaFx+HAgZxbrTW1cfEwJSTtIHT5TX5awG6bFY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oSP3v/oNOl4mbSJsUmCYREKG/NBBYUOv9ET/8eq/4rM0v68HBF2VRgH0N/QmtK4+BuhKePqFtlxZ/EWEaJ++i+lth0IVU9fbT8BMxQOIKOzDRO5EJA9DFAL35R6/7Y8cqh/7vNBLmhPu9xqhmqO4wPhmYvyU8Myc4nF032oI8Z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=OAxiyj3j; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="OAxiyj3j"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=wS0WrMzGhr3RYR4OPM+ppLpnyCgD9P7LcaGhCjyMees=; 
	b=OAxiyj3jP0r59U6yGGHBHijUW2OccXCA2Ra1Svn3utoe+XOpU4sOvtvVey6ChpRoFEwIFTL3eLv
	oU9gQhujGi8d0YgspStOY3ZPmsPoBaFgfi28YAgVq2NDhRMIsVat6DYssQaXNoXPAQFZtbzhz0VNw
	gP37hXCLxpTGqe6Ew0KfiR8ELmtHiZc0iibOr5Qr6i5rtcdDDKwykWP+AjwHoOUdWyDatDVphTcSs
	Nh4ePOzVQufUUbEd98zIlk1NBhYcGXRCrwgA8N3Y4YGlrOwDPKUGMb9ACv8dPGdpuKJ99JVuBb0H1
	QHwBOta5gc4GwOzuYD6nYDv9jn0NlzhbH5ng==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w3s3q-00GJFL-1z;
	Sat, 21 Mar 2026 16:51:59 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 21 Mar 2026 17:51:58 +0900
Date: Sat, 21 Mar 2026 17:51:58 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Linus Walleij <linusw@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
	stable@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] crypto: atmel-sha204a - Fix potential UAF and memory
 leak in remove path
Message-ID: <ab5cLh8Dlorf8iPa@gondor.apana.org.au>
References: <20260314193627.728469-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260314193627.728469-3-thorsten.blum@linux.dev>

On Sat, Mar 14, 2026 at 08:36:29PM +0100, Thorsten Blum wrote:
> Unregister the hwrng to prevent new ->read() calls and flush the Atmel
> I2C workqueue before teardown to prevent a potential UAF if a queued
> callback runs while the device is being removed.
> 
> Drop the early return to ensure sysfs entries are removed and
> ->hwrng.priv is freed, preventing a memory leak.
> 
> Fixes: da001fb651b0 ("crypto: atmel-i2c - add support for SHA204A random number generator")
> Cc: stable@vger.kernel.org
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
> Changes in v2:
> - Unregister hwrng to avoid new ->read() calls and then flush the queue
> - Drop the ->tfm_count check and error logging after flushing (Herbert)
> - Link to v1: https://lore.kernel.org/lkml/20260221190424.85984-2-thorsten.blum@linux.dev/
> ---
>  drivers/crypto/atmel-sha204a.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
