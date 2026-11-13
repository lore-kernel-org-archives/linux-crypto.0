Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794575140;
	b=hTvXaC3NxYWrYvbUKaI/BwTs7nW0g380E409fu9hMDXffiuyXasxODBsWXpdH6dRySsT
	 T5ei28Xu4DlyfpXzOcQjpU6DyCpzaZZRYqLCLqXppkl2acWTU/iK0F3jtXNLqZS3Q/dzf
	 MpNKeGv93dY/dc299O18W7xFIwp03ep0cNC/2+a2ILW5N5oOotQrCqeGgzG7mSv04fT6A
	 HeTJK664ACqomrbPH5vVk3vXsCqE0DIKXKSG/XAKlYgjfBF8jCefdKv8SqoF89xFynMXw
	 dse8gWrS40BuHOmeZqgbDjiIpBLwI8RlUWrUe+k1O/JTITBH2v5vZ+wS0PzeEIytCuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794575140;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=vh961DwpV3McQVq2cHVZyQCwfc4WZpsU3Q5sG3+OJbA=;
	b=GciZG+HMohms+MeN2HEcPkiFI5zqGpNmdhSaHwCJ89UaENm0sx425ghFXfNAi8De4Hem
	 STER+Qhz7Txcnqq2Tp2Cd1yhn+Mn7VqAwqFu42z+/3LF+7PAMnoRCMnCa9n9PdX/nElIn
	 zXU2/I7HOM00MAmy4cOHa7/iRTLxa3hw4W/52z4GdvmGZNLb1AOCcJqROLWqDMs273yjF
	 qLM0neh9QB3dwZ7g1JS3Sq9VVmw6djXF41183LVfKAo/SeoKb2psIYG8T2p2FYNluPZbr
	 m1oLI7/c3A0rFlimSaTScAXNMeU0m59VyUAW2PkvijRpLU3/AjqRoVDOzmU+9caiszg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=fjghFF3G;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D30F606A881;
	Fri, 13 Nov 2026 13:05:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5D30F606A881
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=fjghFF3G
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=vh961DwpV3McQVq2cHVZyQCwfc4WZpsU3Q5sG3+OJbA=; 
	b=fjghFF3GE6rgbymzbzpt0oW6UJqsuloQEEyj7SLu/EvSbKfoXuOL3TzTzmsZGVIP/XAKLK4oXSD
	xDfzEDUbW/dLeoDXoVqCl8/NhrCXSruDrZ5IRuZIboEmcnivcrV6PRTbLJaSN4Nt6puBVrRodeQJQ
	PTOrFmSSn/Oqu0A0wYbPtdvL00n8ej7hFTU0BaOnpTSn+oNaipAVh/YTq3j7IsCuw3xTegHiB3vjI
	oEA8MuEheBfIAJTR9B4Jt0mA47ohgwTtPmSgrc5RcoZcvisIF1MCCn1kgUrtSS/pCusJYUEnY6lba
	2gqEpf7y2EhKc7V/13nCdtw7g1as3WH7tY4w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xRqyG-0000000EfHD-3F0p;
	Fri, 13 Nov 2026 21:05:37 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 13 Nov 2026 21:05:36 +0800
Date: Fri, 13 Nov 2026 21:05:36 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Wentao Liang <vulab@iscas.ac.cn>
Cc: ayush.sawal@chelsio.com, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] crypto: chcr - Free fallback transforms when device
 assignment fails
Message-ID: <avcLIImowe7Pw1so@gondor.apana.org.au>
References: <20261103063850.1033008-1-vulab@iscas.ac.cn>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261103063850.1033008-1-vulab@iscas.ac.cn>

On Tue, Nov 03, 2026 at 06:38:50AM +0000, Wentao Liang wrote:
> The skcipher, RFC3686 and AEAD initialization callbacks allocate their
> fallback transforms before calling chcr_device_init(). If no active
> device can be assigned, chcr_device_init() returns -ENXIO and the
> fallback is leaked. The crypto core does not invoke the algorithm's
> exit callback after its initialization callback fails.
> 
> Free the fallback transform before returning the device assignment
> error in each of these initialization callbacks.
> 
> Fixes: b8fd1f4170e7 ("crypto: chcr - Add ctr mode and process large sg entries for cipher")
> Fixes: 0e93708dabc0 ("crypto: chcr - Add fallback for AEAD algos")
> Cc: stable@vger.kernel.org
> Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
> ---
>  drivers/crypto/chelsio/chcr_algo.c | 21 ++++++++++++++++++---
>  1 file changed, 18 insertions(+), 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
