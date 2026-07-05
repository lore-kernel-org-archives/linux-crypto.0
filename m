Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DCCA364EA4;
	Sun,  5 Jul 2026 08:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783240145; cv=none; b=NrLKxL2qcv9G0MFOCNcICU5oNT8J+r7GFCTqNHU69ptc5Y3uHaRapfVKysXofIv66pYwwk/OAc9EQTRof4lOjGypCNpsUrvHwwikEFgwjy1KVC5HzpmrqdW0eANeya0B8DkmJ1YTXHW38ZJnjh8SNX+DyOJjUefNBmcDbhq94k8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783240145; c=relaxed/simple;
	bh=XriLQPx9jJwy388XOpkJtVlwjiplGlTEB33S1FoV+VE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fRzp0QRhwKxn+5hxhIEJFUvaJTGh07YFs/vMFH5d6Mgz2wPins5I4mUT5vAFgYzmyd/8CqeROq87OO52tr+cJGZpa0L/D5zdGtEhDP/jeGkUcNpUAVrKAfcIrmnM+UNorf1O291ifWyWDPGS8X2F2n9J1x+Zi0FfvN+iWujliUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=aC3S1SPF; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="aC3S1SPF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=a26LDP23I0jAoaKTwCFAOnHcyE8CbjAuBb0B0Ovkal8=; 
	b=aC3S1SPFzzKDTfa/zPCawY64qY7G05Vgi64Zsz1BgZy8dpTThAH0oWSztCRFqm/dW2GNDea08PT
	DvYTyNyMH/uxsr6pcLV44JyUfDTEfxXgdrOmOI9xtApnj7xtrlCbMyFIP2N7ZIOsfKmw7e0orK1Xl
	V9RYLGlRXRTa+qQBq3z00zeX6+F7poQxEFoyzB04XUoe/j8r8Xq3pfnL0Mlx8GaiVXVhQXwyCnJnr
	RnlO4iwEJUgK84jhUDs/QNJdEjtTsTZMv9ifl32Sh/aXam1c5XbN2EQLu5lcbSwZUEWoxRn59lCmo
	YwcoTwgtlLlJwuLgVC3VQau4CKBlfX5XVHFw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wgIDe-0000000AkwR-3oy5;
	Sun, 05 Jul 2026 16:28:55 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 05 Jul 2026 16:28:54 +0800
Date: Sun, 5 Jul 2026 16:28:54 +0800
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
Subject: Re: [PATCH v2] crypto: atmel-tdes - use scatterlist length before
 DMA mapping
Message-ID: <akoVxtnZkHP-Le_0@gondor.apana.org.au>
References: <20260611103633.458381-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260611103633.458381-3-thorsten.blum@linux.dev>

On Thu, Jun 11, 2026 at 12:36:35PM +0200, Thorsten Blum wrote:
> Using sg_dma_len() is only valid after mapping the scatterlist with
> dma_map_sg(). However, atmel_tdes_crypt_start() uses it before mapping
> to compare input/output lengths and to compute the transfer count.
> 
> Use the original scatterlist lengths before DMA mapping to avoid reading
> stale or uninitialized DMA lengths when CONFIG_NEED_SG_DMA_LENGTH=y.
> 
> Drop the output scatterlist length in the fast path since it is equal to
> ->in_sg->length and does not change the transfer count.
> 
> Fixes: 13802005d8f2 ("crypto: atmel - add Atmel DES/TDES driver")
> Fixes: 1f858040c2f7 ("crypto: atmel-tdes - add support for latest release of the IP (0x700)")
> Cc: stable@vger.kernel.org
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
> Changes in v2:
> - Drop ->out_sg->length in the fast path (Herbert)
> - v1: https://lore.kernel.org/lkml/20260531204115.689052-3-thorsten.blum@linux.dev/
> ---
>  drivers/crypto/atmel-tdes.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
