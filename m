Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63003B192
	for <linux-crypto@vger.kernel.org>; Tue, 13 Aug 2024 08:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723536746; cv=none; b=Bx2+U4plLQyo96zSztaEIJYfWqAIsWs4U2nWsoKKsYufEU2V4UkHAovV9SNoGrdL5dhjEqW/iwHoVvocpqCSCbFVZ95yMaku2ixc1yUdZBCROW/Zgny6Ff25AqjZ6iov6UDfwATTqlL+X/elWmQ6W0o4pEsI68MnfbsNC9vlggY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723536746; c=relaxed/simple;
	bh=wba/CeR2mJ6am9vgmaghUpPeqoiHwg5jfmRDoygAiPo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fzzi3Az1QWrm9TnBhujpT8/b2U4kukyvBjsSmKRDIOy1jEcv55tNVi560jUE4bswo+ukzL1isAutjxWt2S1ONYOjYaJfhrVNxdCuELHretjJJBJmfmY4OPTKg6m6RU7lX4XgHNjmMbPVARuWydOUR17Ylj7X/G7cia1C7NW23y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sdmVB-004Hg7-2e;
	Tue, 13 Aug 2024 16:12:19 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 13 Aug 2024 16:12:18 +0800
Date: Tue, 13 Aug 2024 16:12:18 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: linux-crypto@vger.kernel.org, Holger Dengler <dengler@linux.ibm.com>
Subject: Re: RFC: s390/crypto: Add hardware acceleration for HMAC modes
Message-ID: <ZrsVYl3NYdRbUMNm@gondor.apana.org.au>
References: <20240807160629.2486-1-dengler@linux.ibm.com>
 <20240807160629.2486-3-dengler@linux.ibm.com>
 <8511b5079e158b79232f7be9d03fbba5@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8511b5079e158b79232f7be9d03fbba5@linux.ibm.com>

On Tue, Aug 13, 2024 at 09:37:24AM +0200, Harald Freudenberger wrote:
>
> +static int hash(const u8 *in, unsigned int inlen,
> +		u8 *digest, unsigned int digestsize)
> +{
> +	struct crypto_shash *htfm;
> +	const char *alg_name;
> +	int ret;
> +
> +	switch (digestsize) {
> +	case SHA224_DIGEST_SIZE:
> +		alg_name = "sha224";
> +		break;
> +	case SHA256_DIGEST_SIZE:
> +		alg_name = "sha256";
> +		break;
> +	case SHA384_DIGEST_SIZE:
> +		alg_name = "sha384";
> +		break;
> +	case SHA512_DIGEST_SIZE:
> +		alg_name = "sha512";
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	htfm = crypto_alloc_shash(alg_name, 0, CRYPTO_ALG_NEED_FALLBACK);
> +	if (IS_ERR(htfm))
> +		return PTR_ERR(htfm);
> +
> +	ret = crypto_shash_tfm_digest(htfm, in, inlen, digest);
> +	if (ret)
> +		pr_err("shash digest error: %d\n", ret);
> +
> +	crypto_free_shash(htfm);
> +	return ret;
> +}

The setkey function can be called in softirq context.  Therefore
calling crypto_alloc_* from it is not allowed.  You could either
move the allocation to init_tfm and carry it throughout the life
of the tfm, or perhaps you could call the s390 underlying sha hash
function directly?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
