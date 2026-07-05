Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C07280035;
	Sun,  5 Jul 2026 08:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783240677; cv=none; b=ZSiSjhU6+A79eRx4qxUdGs0mLQm2hlZSJ+ej8JeM93SGvHKZhEa1YkTHqyZOlBWnVI4PUj4Uid6LmfmrrDFVOrSci6wx1y2fTWR6dNc+U0zsYvO4p1G+TptdP1G3kHPZvw4QUpgX9sLSSwA+x2WdUrWO3BnrBjh6QQLCEBT8X9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783240677; c=relaxed/simple;
	bh=wgwP3H3qz/nuE04obGIGsfkJJfWThh/Ml9MDo46Gkis=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pfRKsUd3r7YbdLYWOCs3NHYaPohRWnsx0nGyMjAzjhX8nTS3J21881Y1hbArus1QbJgsaprNx0oUxawNzZIIJgJOsf1xIjPe7zPBzq/5Ci0mqQz3tMDBXv8+FiUcXMZGeoIQsVZZ50qajgQUqzsv09xRwavg+P5siaX5XubqzPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=P5tpVYVL; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="P5tpVYVL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=G3JkHKn7CYnIQUIHAEnygms5epVvFw1YEAPwLWruV2k=; 
	b=P5tpVYVL7QJAYSVvr12KGJdoAQCrQaDLcXkP7hPBi1Jm+R8YbaYXcyMXjrtwQUDwdWoLz/JcFtC
	Js8XsE/rbKykCddxK6jqX1jpcZ22BJaKnGsdMe1xV9uiUokY6m5u78XpewEnlpEYcxbbVcMX3hU3J
	5BR4UdkyC/PIEg3KGd6a8FFPCoz0+J5mQtcvUjWew4vZIt9RIv+uDUXTGwpEFhfiHpJRF+OHyEhaF
	JyKpGON3/BTK96db4RZ96lDPQk8i8kTqtGjPmTPD8t2E2duAYJvkAmYDAVoSFRbWPOulTK3qo1qhT
	6dFE4i0DASPGm8J4Xe6soqcMtecdBm5ziC5g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wgIMD-0000000Al4S-41ay;
	Sun, 05 Jul 2026 16:37:47 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 05 Jul 2026 16:37:45 +0800
Date: Sun, 5 Jul 2026 16:37:45 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>, Frank Li <Frank.Li@nxp.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>, Marek Vasut <marex@denx.de>,
	stable@vger.kernel.org, linux-crypto@vger.kernel.org,
	imx@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: mxs-dcp - fix source scatterlist length access
Message-ID: <akoX2XUWuBezygdK@gondor.apana.org.au>
References: <20260621192615.277957-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260621192615.277957-2-thorsten.blum@linux.dev>

On Sun, Jun 21, 2026 at 09:26:16PM +0200, Thorsten Blum wrote:
> mxs_dcp_aes_block_crypt() uses sg_dma_len() without mapping the source
> scatterlist with dma_map_sg() first. Therefore, sg_dma_len() is invalid
> and could return zero or a stale DMA length, causing encryption and
> decryption to process the wrong number of bytes when
> CONFIG_NEED_SG_DMA_LENGTH=y.
> 
> Use the original scatterlist length instead.
> 
> Fixes: 15b59e7c3733 ("crypto: mxs - Add Freescale MXS DCP driver")
> Cc: stable@vger.kernel.org
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/mxs-dcp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
