Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A378340293;
	Thu, 11 Jun 2026 05:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781154489; cv=none; b=S09pQWLrelSTXYglOGMtlfJG/zt3U75J6pKl2uIX+v6yePAX1zNNMtMEPsULCrOMtD4v7Nwr37qzEjUmNURRVEdZf7kqM/YmdK5HJM6/McwctmH30peL5uqjEAynjJciY2k4wpzpVsEmBWbxAPgcC7N+FyOSchTWZaBAmmylHmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781154489; c=relaxed/simple;
	bh=QuOQzKqWtSYR32qN5nAanMbXmgiPPtV1NmvqVk3Nb68=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TSi+AHTkNxmgSvb9/JD/xFxEiU+CIH/Om/IqOEj0FEsKOHB3yvmxk3/cttzmBEsPTkgqyKHZdoBcaUv2yHla3PoJHfNcsH+30f9NM4lZAFVxAakJI7T/Z1s2V28HlbE11L58Vc01UT+o9rvlxhs9lKr87tBdBXHkqfBS069JJBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=iju0Omu+; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="iju0Omu+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=GDfClmc81kfx8tEP4oo29m8sp+Ny4s0yacmzWMf40x8=; 
	b=iju0Omu+wYeKvT+BzaaKXUgoaDf9+tb2kjnzy6ZmkrN5TifIU766lsllVR5RdfjvRunTNEMOyiK
	EQyqlog6Qr1MK2Myno6ZDcS3fmWoXkOjpaUTaKbMTjm48+UUH80Ri+KN0gShlqGN6ZtYHtsq4Lg7f
	95fSknI7BnVctegZLVSgDqcgVNoohDbLBVNReo4ZlDTYXS1bLH3A1adB3SFsF0S5t8af0odml3Ny9
	bsThv36w0eh0JYfRpPnUgTUoQYDJtZNqa0GX0uiHZ5F91O/4m75dh7i+0Qyd7YnclLAATef3j+UlU
	soA+0gX9DVkQbIwJd3/iJHdHCmRA8R15Ki4Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wXXdy-00000004TpW-1MUd;
	Thu, 11 Jun 2026 13:07:55 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 11 Jun 2026 13:07:54 +0800
Date: Thu, 11 Jun 2026 13:07:54 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Leonid Ravich <lravich@amazon.com>
Cc: Alasdair Kergon <agk@redhat.com>, Ard Biesheuvel <ardb@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Horia Geanta <horia.geanta@nxp.com>,
	Gilad Ben-Yossef <gilad@benyossef.com>,
	linux-crypto@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org
Subject: Re: [PATCH v3 1/4] crypto: skcipher - add per-tfm data_unit_size for
 batched requests
Message-ID: <aipCqiY-s1zYaB1d@gondor.apana.org.au>
References: <20260601085644.13026-1-lravich@amazon.com>
 <20260601085644.13026-2-lravich@amazon.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260601085644.13026-2-lravich@amazon.com>

On Mon, Jun 01, 2026 at 08:56:41AM +0000, Leonid Ravich wrote:
>
> diff --git a/crypto/skcipher.c b/crypto/skcipher.c
> index 2b31d1d5d268..bc37bd554aec 100644
> --- a/crypto/skcipher.c
> +++ b/crypto/skcipher.c
> @@ -432,13 +432,119 @@ int crypto_skcipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
>  }
>  EXPORT_SYMBOL_GPL(crypto_skcipher_setkey);
>  
> +int crypto_skcipher_set_data_unit_size(struct crypto_skcipher *tfm,
> +				       unsigned int data_unit_size)
> +{
> +	unsigned int blocksize;
> +
> +	if (!data_unit_size) {
> +		tfm->data_unit_size = 0;
> +		return 0;
> +	}
> +
> +	if (!crypto_skcipher_supports_multi_data_unit(tfm))
> +		return -EOPNOTSUPP;
> +
> +	blocksize = crypto_skcipher_blocksize(tfm);
> +	if (data_unit_size < blocksize || data_unit_size % blocksize)
> +		return -EINVAL;
> +
> +	tfm->data_unit_size = data_unit_size;
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(crypto_skcipher_set_data_unit_size);

The unit size should be a per-request attribute, not per tfm.

> @@ -492,6 +517,66 @@ static inline unsigned int crypto_lskcipher_chunksize(
>  	return crypto_lskcipher_alg(tfm)->co.chunksize;
>  }
>  
> +/**
> + * crypto_skcipher_supports_multi_data_unit() - test multi-data-unit support
> + * @tfm: cipher handle
> + *
> + * Return: true if the algorithm advertises that it can process multiple
> + *	   data units in a single skcipher_request.
> + */
> +static inline bool
> +crypto_skcipher_supports_multi_data_unit(struct crypto_skcipher *tfm)
> +{
> +	return crypto_skcipher_alg_common(tfm)->base.cra_flags &
> +		CRYPTO_ALG_SKCIPHER_MULTI_DATA_UNIT;
> +}

My preference is to always use multi-unit submission if the user
is capable of doing it.  The Crypto API should automatically divide
up the units if the underlying driver does not support it.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
