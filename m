Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4988E1DF72C;
	Fri, 29 May 2026 06:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780035127; cv=none; b=kJSbTy51IsxTjPzofK150JnaVmKmK/Ccwz6GvOZ2rz0T1Bwm2WKc8HXJIqiGKwPMwTsnlbnzxCERUbmtcm81SDoC4Nx1DNwaaRbrwSHOVWLqGv8HwXD7e7cWlWTQSjeerzIHf4r3e6zYE+rmRVhrszSVaJIAw6ThAJabmBLJzMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780035127; c=relaxed/simple;
	bh=5cq51ZvUmXttPL64hpXmKVU7eFwJlq9i7rnAZ58QdbQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G3QAu0gN3A1B+8t292FgdEZ4t3JiqkjuIvP1hwrUWerMbOS9/gxF+IKpVImPAbPUo1T2hnXfVYC8nRwInrQmvRO/OGPXUcYPC5Tl0oJaVG5RgTfpY/Lcq4YXiW6cSs84ioTQAzDTNSODqv5W3mmv7wlpuGMm70UQR37klyxHjHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=cC0+4cRY; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="cC0+4cRY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=PoVKhzzmIrNFG1UZP8NlLw5m4P+ZkY+UrKc384/A01c=; 
	b=cC0+4cRYSBdg1Ia1D5a53vjxX/DCxbbNTWHu/uwdEPa+CZQB0l0vfFG8wgnJt6TaP5wdklXnfDM
	3/uJPvxERoWwaueKdVheUVyCYWGJ7GqaswEGFr9Kdw47hCd8GaXRYeXHsOiYnA+OSV8ozV5FAM0TN
	BYHTf9Le4XBPqEuJ9E/hu5oe+84evLWwkrncIxq+lc5J7ws7BLfb0b4Zr0CHwcdWppcj8XVo6y3Wt
	vhe5jJ0V5xPGZfITJB7W9KmzdAU2/NQuZ1UUFfcpf8x/7TBcW5QgZPLdQJyyWz79qeGXx7vKyfOYA
	O3fz/b1wY1ponZNHylgVvI4zbAGEpj/xpPKg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wSqRf-000dL1-1P;
	Fri, 29 May 2026 14:11:48 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 29 May 2026 14:11:47 +0800
Date: Fri, 29 May 2026 14:11:47 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Tianchu Chen <tianchu.chen@linux.dev>
Cc: clabbe.montjoie@gmail.com, davem@davemloft.net, wens@kernel.org,
	jernej.skrabec@gmail.com, samuel@sholland.org,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-sunxi@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: sun4i-ss: restrict PRNG seed length to prevent
 heap overflow
Message-ID: <ahkuI-Z2w0sea_ba@gondor.apana.org.au>
References: <af749a8447bd7f0e9dd26ca6c87e9c6afecb09d9@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af749a8447bd7f0e9dd26ca6c87e9c6afecb09d9@linux.dev>

On Thu, May 28, 2026 at 02:53:17PM +0000, Tianchu Chen wrote:
>
> diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-prng.c b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-prng.c
> index 491fcb7b8..010fa891c 100644
> --- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-prng.c
> +++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-prng.c
> @@ -8,6 +8,8 @@ int sun4i_ss_prng_seed(struct crypto_rng *tfm, const u8 *seed,
>  	struct rng_alg *alg = crypto_rng_alg(tfm);
>  
>  	algt = container_of(alg, struct sun4i_ss_alg_template, alg.rng);
> +	if (slen > sizeof(algt->ss->seed))
> +		return -EINVAL;

This should simply ignore the extra data instead of failing.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
