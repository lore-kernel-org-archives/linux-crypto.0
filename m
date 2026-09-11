Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C2DD2F7EE4;
	Fri, 11 Sep 2026 05:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789104635; cv=none; b=E1S2TlM20ewpubWvHuWiTOdktwoSJNZQVChiXzQ40MG1598gFwOpm/N48KXACJPYP1eH8bbda4o3G3WK7k+ynlFJvhGadruTDtjB5SUdlEMHrjzzdDUSn8Mi6K5yIT3yH4aQJmDh+s3l0MKVGGqegdGIaLY+2xi8lB7GINcHogE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789104635; c=relaxed/simple;
	bh=GsGvfKxthiVNiuG1NADvZGbB3p76Gla8qJMlP7MKaDI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BxxCfAeZNaM0/GjnUvbuUPdm8ciwRaVNlOUCZ1uFgAaLmebAwvb6fd0JfHo9VspzzPF0eqDZfX/FPiwPd1Ii2S8Fwn17HqiUDFtFc+jFLmUezRzqKxj4VKwgHT4vdYmi6+WDuUwmklwTcY8G1BGHmzuo10ehWGPMOWSxZrFKIjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=cbYbsAR6; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="cbYbsAR6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=/Qc9W48ajHUaDYex3wbtF0VK8EtF1Jd5f/13/VkTqAA=; 
	b=cbYbsAR6kv84UBtTq+RC8A1nKGRqQXr3bttPltSs11P3qyepcWm96t2DY9GvFryQF8kFlNHWC41
	1eefaUrHh02APbnfPehyEsbvdgJdu32nu8k2XedKJS8wszjTjmXaJ6Whep6wQ+aeZbrxmHa55Sy88
	wQ/4zu7JtEKJjbwLFZonjlRy+C+bYUZo4wlOJ1+FQm1lAwprnn8Ry7cYL7oyiB+22aEikanTWyKY0
	qlo48b9+yKvOACcafN6iNV2scykk0czzMyk9mCHO6N70to+xzyGzFLWWlVksISrhkD65jk7Bmrfw/
	ByGYDCfsoytOzXHhw1ON3l5haFFN1gKXxUaw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x4tqA-0000000CuAl-0cKb;
	Fri, 11 Sep 2026 13:30:23 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Sep 2026 15:30:22 +1000
Date: Fri, 11 Sep 2026 15:30:22 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Pramod Gurav <pramod.gurav@smartplayin.com>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: atmel-tdes - zero-initialize device state
Message-ID: <aqOR7pH5LB5b0Rjn@gondor.apana.org.au>
References: <20260829035821.67220-1-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260829035821.67220-1-kmehltretter@gmail.com>

On Sat, Aug 29, 2026 at 05:58:21AM +0200, Karl Mehltretter wrote:
> Commit c659d07f11a3 ("crypto: atmel-tdes - Switch to managed version of
> kzalloc") accidentally replaced kzalloc() with devm_kmalloc(), so the
> device state is no longer zeroed.
> 
> atmel_tdes_hw_init() tests dd->flags during probe: a stale TDES_FLAGS_INIT
> skips the hardware reset, and a stale TDES_FLAGS_BUSY makes
> atmel_tdes_handle_queue() treat the engine as permanently busy, leaving
> every request queued and never dispatched.
> 
> Seen on a SAM9X75 Curiosity: the first TDES request after boot never
> completes and the TDES interrupt count stays at zero, while the AES and
> SHA engines on the same SoC work normally.
> 
> Switch to devm_kzalloc(), matching the Atmel AES and SHA drivers.
> 
> Fixes: c659d07f11a3 ("crypto: atmel-tdes - Switch to managed version of kzalloc")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
> ---
>  drivers/crypto/atmel-tdes.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
