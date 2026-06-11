Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD55C279DCA;
	Thu, 11 Jun 2026 05:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781154292; cv=none; b=FHOJyicHDYV0V9rLESuBBqEosS9GTgNqd2/4vZdNy8b5FCpvud2ghRWcWigRQbiPWrRZEVmo1tZlGUc8ySCqFebPhk0POQ8EWd8QYFCSxPqspCPnhZCx523AbJ1Voay7n1F8dtkP2WoOTcodmroKzceJLXagOEUlFQUIIhHrqKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781154292; c=relaxed/simple;
	bh=gOCQVqhDJTyuRiUzL/+8C/j6YzhUC1w22ot05J1Cr/c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mx1G4CudzYF7CSnUjTCpzjtqUwJsEeWjiX5Hpd/X6A81moUL0VYw3lHTjf3RLU1z3g0EFuqMTpBjptbtWN9W6IdXQlpRJT0lFlekQT66SYfjMtE/Hw69NFBWpIJMJWbylyb6hzNUdo7VWn1DUALzu+vJLeK4mlS6NQlKBeG2oc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=sa8XVQfH; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="sa8XVQfH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=/YvzqMDI3nbkwkA5pMGiIeRglsYXX8ywE2cZbFG4rU8=; 
	b=sa8XVQfHBThT8cDuG7BuRp8CBEjfeawbl2vlG6XfTIhjdaLqCbpsxSgga0OoaYU/NmYdlUE37UN
	ZfyzjhDsZKU72uF1PVTcpwtosklGYJCIfbU0bPebY0zGJuwJfMv8aTY8jjFK2UsXUHHc2mFDMUKkY
	E/3+22hcH+xyITALfnDVZtW4WVttpN1qXmhx/1HfGrzvaNqwEG3pKZxGPm2hgU3g/jvf4anx2wHwL
	eHHm8gzuK/LZfno2wCOhIdM03kt5jmdyZVLoqygPrUUpHBf7ZeZhoeyecK2W4PNMWEQHyFyUcgFCy
	og7b1lRiU8A4dZLRVnY2jPRF4XTlqX2N3VuQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wXXaj-00000004Tmd-2lb3;
	Thu, 11 Jun 2026 13:04:34 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 11 Jun 2026 13:04:33 +0800
Date: Thu, 11 Jun 2026 13:04:33 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Nicolas Royer <nicolas@eukrea.com>,
	Eric =?iso-8859-1?Q?B=E9nard?= <eric@eukrea.com>,
	stable@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: atmel-tdes - use scatterlist length before DMA
 mapping
Message-ID: <aipB4S29ID_dQeLg@gondor.apana.org.au>
References: <20260531204115.689052-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260531204115.689052-3-thorsten.blum@linux.dev>

On Sun, May 31, 2026 at 10:41:17PM +0200, Thorsten Blum wrote:
> Using sg_dma_len() is only valid after mapping the scatterlist with
> dma_map_sg(). However, atmel_tdes_crypt_start() uses it before mapping
> to compare input/output lengths and to compute the transfer count.
> 
> Use the original scatterlist lengths before DMA mapping to avoid reading
> stale or uninitialized DMA lengths when CONFIG_NEED_SG_DMA_LENGTH=y.
> 
> Fixes: 13802005d8f2 ("crypto: atmel - add Atmel DES/TDES driver")
> Fixes: 1f858040c2f7 ("crypto: atmel-tdes - add support for latest release of the IP (0x700)")
> Cc: stable@vger.kernel.org
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/atmel-tdes.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
> index 643e507f9c02..0d62b24e9fc7 100644
> --- a/drivers/crypto/atmel-tdes.c
> +++ b/drivers/crypto/atmel-tdes.c
> @@ -463,14 +463,14 @@ static int atmel_tdes_crypt_start(struct atmel_tdes_dev *dd)
>  			IS_ALIGNED(dd->out_sg->length, dd->ctx->block_size);
>  		fast = in && out;
>  
> -		if (sg_dma_len(dd->in_sg) != sg_dma_len(dd->out_sg))
> +		if (dd->in_sg->length != dd->out_sg->length)
>  			fast = 0;
>  	}
>  
>  
>  	if (fast)  {
> -		count = min_t(size_t, dd->total, sg_dma_len(dd->in_sg));
> -		count = min_t(size_t, count, sg_dma_len(dd->out_sg));
> +		count = min_t(size_t, dd->total, dd->in_sg->length);
> +		count = min_t(size_t, count, dd->out_sg->length);

If fast == 1, then dd->in_sg->length must be equal to dd->out_sg->length,
so the second line is redundant.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
