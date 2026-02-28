Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF2CE1F4C8E;
	Sat, 28 Feb 2026 08:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772268522; cv=none; b=n7nr31jtJb4D4tq2DnuXIlNhpnzrS0AgKfxF0qGy+jbH9lmonlFcK7JVCCCxi7TJRop0EKJkdyxBsV7kjMovzcKJgokNxotlMBx9xMClrdiypQS9m9er5wBhMw8gMuVJ6Fi4mmpTtlNJ5YTEThxT7wNMbugCVxlDfOjelMgz1To=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772268522; c=relaxed/simple;
	bh=uLBXSQfefxGgVhjCufyOG9IQFCxNulwOI4RxtLXflFA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U1Ak6WKydUE4uKHWX6PEVOqJxWKcUWEN2R3biRBcPApuPc83nYiDjXo/3YsqE+GdZtTL0tr75B6/1qbcW774N4T5Uq+TowTgxhFPUeMF132VJDqHGAuYMzRZa381Jx7lVtFhepTmaJUO7qMIZE+sjmaHN7VHv9gd6evTlN1BuTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=i27Fe8ID; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="i27Fe8ID"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=tsXOzrHHZ0tUT/4bwgWhtkJZOaxenpihvowg1HuQPg4=; 
	b=i27Fe8IDV/Zy0Tvn6brDAjzU7vGppITK+vxsmf4+E2xBrKpkzAmyhXlpCuv+LwyAISi6uan16Vx
	dDpcryPOfoE5of3FSDOKYxuntvK/zWcc7ZneYTE8DgE3xcCf0mwEEK5rauobjg8Ej6N2pUHf3H4zn
	q9y9VHdCjrX5MB/6DOa4dsNf1NF8oMrP7tg09X32FWpDWkdFwyEFdfxdpY36TogG0E01cBmIJsan0
	Vrw/bhNC67A4nc8rJWrE0nsrnvuTjI9UZ+hnn8M9/ixqBQEWDZKChG3X+6uNCHMtfZgMmwFHieNzH
	zmW6soVvMpRYC1SQZFIfiluH5iE78lT0tJVA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vwFzo-00ADsA-24;
	Sat, 28 Feb 2026 16:48:21 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 28 Feb 2026 17:48:20 +0900
Date: Sat, 28 Feb 2026 17:48:20 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Lothar Rubusch <l.rubusch@gmail.com>, stable@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: atmel-sha204a - Fix error codes in OTP reads
Message-ID: <aaKr1E1mPOgxo0JL@gondor.apana.org.au>
References: <20260215205152.518472-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260215205152.518472-3-thorsten.blum@linux.dev>

On Sun, Feb 15, 2026 at 09:51:53PM +0100, Thorsten Blum wrote:
> Return -EINVAL from atmel_i2c_init_read_otp_cmd() on invalid addresses
> instead of -1. Since the OTP zone is accessed in 4-byte blocks, valid
> addresses range from 0 to OTP_ZONE_SIZE / 4 - 1. Fix the bounds check
> accordingly.
> 
> In atmel_sha204a_otp_read(), propagate the actual error code from
> atmel_i2c_init_read_otp_cmd() instead of -1. Also, return -EIO instead
> of -EINVAL when the device is not ready.
> 
> Cc: stable@vger.kernel.org
> Fixes: e05ce444e9e5 ("crypto: atmel-sha204a - add reading from otp zone")
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
> Compile-tested only.
> ---
>  drivers/crypto/atmel-i2c.c     | 4 ++--
>  drivers/crypto/atmel-sha204a.c | 7 ++++---
>  2 files changed, 6 insertions(+), 5 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
