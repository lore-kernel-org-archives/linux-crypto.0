Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A246369D67;
	Sun,  5 Jul 2026 08:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783240235; cv=none; b=RgefY4y4Q6iqTjjWQBXcA/Uzage/A40mQ9B7L7qgRpUyUGZl/ryq9XErcpRfFWAD7vSqE/9LQuaxE2NrsyQ6YgM792Dvwmx2sI6W1sAqOLjNGeKKziJeIEQT8Atkdc8pDB1S5U+Ib6KIoCNSOiZJz4PyWtIm071aX1uCU5C2C/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783240235; c=relaxed/simple;
	bh=T5VMi9AtI423nze0MHwUpvqJg3rDe2kcWX2Z9/7gHTY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uq/ImfAJPl0GAXgEipTjavfWH1fdZnHFPqNHOd0e9SPli19GGOcYlM9QcrbJzVRLI2GtqHeMXkJr5qPg4QULhjJMt4GkXDmnP39mv8Rbyck8D6adlBofUwBWflB+f8b4r5MASHgqM0w9+Jgye3YkSgdLgnXuDBROlR4lPxvkf8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=aKGFPoFW; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="aKGFPoFW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=ncYdBTDKwnyVdvlOqydNM/W0W9BJ6MKobd1nuSlkn1U=; 
	b=aKGFPoFWCA0370pN0vS51SOgTImWfEyUY/bk4kuDMWlbEMjxpn9eC715rfipK2b6RF75obz8EN6
	aDxHa9KosC5+Ee0EByTVqHpQWt0P5YXYNkwxD6mmaQlGXaN1Kif3t9IQjzrBlj6KwtLZ1TeXfMy0s
	kYSeGi6izxkAV9m3W5Ikn8GtIG3sD4hemTo0RpfEklqgYh8B1LNs7t0Ry/RpdPUzGw+6O5r6V0QLl
	QI9IVWhFmN4ZmKPM1YnJxJBrqBD9MK36CgJgacDMNPILHDBC/YzC1BG4pq1gatnwGwSFR9nZQHNlc
	HtLzk43m6HGFaS+fDV3IWrRUgZE5RbitrlJg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wgIF6-0000000Akxs-2I9Q;
	Sun, 05 Jul 2026 16:30:25 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 05 Jul 2026 16:30:24 +0800
Date: Sun, 5 Jul 2026 16:30:24 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Lothar Rubusch <l.rubusch@gmail.com>
Cc: thorsten.blum@linux.dev, davem@davemloft.net,
	nicolas.ferre@microchip.com, alexandre.belloni@bootlin.com,
	claudiu.beznea@tuxon.dev, ardb@kernel.org, krzk+dt@kernel.org,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/1] crypto: atmel-sha204a - fix heap info leak on I2C
 transfer failure
Message-ID: <akoWIPq1p0YUIdyF@gondor.apana.org.au>
References: <20260613202037.47744-1-l.rubusch@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260613202037.47744-1-l.rubusch@gmail.com>

On Sat, Jun 13, 2026 at 08:20:37PM +0000, Lothar Rubusch wrote:
> The nonblocking RNG path allocates a work_data structure to track the
> state of an in-flight asynchronous I2C request. This pointer is stored
> in rng->priv and later consumed by the read path once the transaction
> completes.
> 
> If the underlying I2C transfer fails, the completion callback is invoked
> with a non-zero status. In this case, the allocated work_data is not
> usable for producing RNG output and must not remain associated with the
> hwrng state.
> 
> Previously, the failure path only logged a warning but left the pointer
> state uncleared, which can result in subsequent read attempts observing
> stale state and interpreting it as valid completion data.
> 
> Fix this by freeing the pending work_data. The I2C transaction reports
> an error. This ensures that failed requests do not leave residual state
> behind that could be interpreted as valid RNG data on later reads.
> Clearing rng->priv is done at the subsequent call to nonblocking read.
> 
> Fixes: da001fb651b0 ("crypto: atmel-i2c - add support for SHA204A random number generator")
> Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
> Assisted-by: Gemini:1.5 Pro [google]
> Reviewed-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
> v2 -> v3:
> - remove existing error-path cleanup behavior [`rng->priv = 0;`],
>   update commit msg
> - rebased
> 
> v1 -> v2:
> - reword commit message for clarity and precision
> - keep existing error-path cleanup behavior unchanged, update commit msg
> 
>  drivers/crypto/atmel-sha204a.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
