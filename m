Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08D841DED5B;
	Sat, 13 Sep 2025 04:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757736019; cv=none; b=r4vmghADACsn/VdqdcVCZfjRGBwBIMo3QJHAzvhhXu7IJs5xs+eJhKEgzhEzkdtNafmeF4zBD6EwbpiRmZNaN8z8/95a9LQGX9yKg8icY8QKrU5iccBUBNBqlo+kkBPpHZnEMf4Wx3vxPSDdmUK8+ke/kbtC03za29alBIrIc4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757736019; c=relaxed/simple;
	bh=StjCYRKjxo+/uNGUMp4u2Q/MThjN6is5yTdKHAtUacc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BGfpbXKullzSs9il21pUtpxA0Nma2d36S06M+Kqw+468PeZ+evzZP3u5abqorUnXigumG8HfF6jMAJy5yjnUzNQJKkbh7wyvBsMC58GR2ja0oyPftd0ObhAOYZwiVVegAZ+DfEaPLBEXiOzQhwsHu2fZBAhTeK8FaVpg1tAJj3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=NSetxOan; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="NSetxOan"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=z83lnUz437zAhQCp3R6e8kZDrrmry8SzUSHt/UweV2w=; b=NSetxOanypfCNDYPOlDCHDZJjO
	U+DY2i8GR8nCcDZxsnahzGvKop0yR+KeNrtE/Ff7lGozeN2VW0Or7wLa7p6E9M6G+f6O0RUYeTPFe
	Zj7/ItcUpqv6p1jqDK2yD8S3ljiuTOhKWnLvpuGO8vcY6+R7MmmSePaO0uc3fy3P0xioEUnInaq6W
	r0+ySGtNlE5NB7HqeLPzFKHKnVXcvetS+UmA12+NhdIlakLZmQgXwD6NG58dak4JoQGCLhvi+/boP
	fgheH2gV+/Jif/8tRdEi+2ogfCXPiLGrXhlUEW7whPTT1W+BBqIF20l7ccVH5OBt5RmoYvZn4TlTV
	zdPNXo9w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uxHBH-0053eK-2M;
	Sat, 13 Sep 2025 12:00:05 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 13 Sep 2025 12:00:04 +0800
Date: Sat, 13 Sep 2025 12:00:04 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: meenakshi.aggarwal@nxp.com
Cc: horia.geanta@nxp.com, V.sethi@nxp.com, pankaj.gupta@nxp.com,
	gaurav.jain@nxp.com, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Meenakshi Aggarwal <nxa07556@lsv05950.swis.nl-cdc01.nxp.com>
Subject: Re: [PATCH] drivers: crypto: caam: Add CRYPTO_ALG_NO_FALLBACK
Message-ID: <aMTsRIxG44TmqOnp@gondor.apana.org.au>
References: <20250904112615.4050572-1-meenakshi.aggarwal@nxp.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250904112615.4050572-1-meenakshi.aggarwal@nxp.com>

On Thu, Sep 04, 2025 at 01:26:15PM +0200, meenakshi.aggarwal@nxp.com wrote:
> From: Meenakshi Aggarwal <nxa07556@lsv05950.swis.nl-cdc01.nxp.com>
> 
> Add CRYPTO_ALG_NO_FALLBACK cra_flag for hash algorithms.
> 
> Fixes: 4ccd065a69df ("crypto: ahash - Add support for drivers with no fallback")
> 
> Signed-off-by: Meenakshi Aggarwal <nxa07556@lsv05950.swis.nl-cdc01.nxp.com>
> ---
>  drivers/crypto/caam/caamhash.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
> index 25c02e267258..90aecefdce01 100644
> --- a/drivers/crypto/caam/caamhash.c
> +++ b/drivers/crypto/caam/caamhash.c
> @@ -1933,7 +1933,8 @@ caam_hash_alloc(struct caam_hash_template *template,
>  	alg->cra_priority = CAAM_CRA_PRIORITY;
>  	alg->cra_blocksize = template->blocksize;
>  	alg->cra_alignmask = 0;
> -	alg->cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY;
> +	alg->cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
> +			 CRYPTO_ALG_NO_FALLBACK;

All hardware drivers are meant to have fallbacks.  The only exception
would be phmac where the key is inaccessible to the software fallback.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
