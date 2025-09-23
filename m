Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF978320CA4;
	Tue, 23 Sep 2025 09:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758621471; cv=none; b=g8WwMD3T3y0GZZ3d4a70Gtchp/Hqksc7CTLFrIUYT4mz446cq0jj21nduSmcm1pqOd+Rv/IEVTvAdmFRGarrDR76EcDJcEuNYBT75CZ78Q5llpXOxg2zdfRUrxo0pWTKCYru5kXmPD3nb+d5lPeh4NL+f/yCuYtt/6Z09VFbI14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758621471; c=relaxed/simple;
	bh=zPfKwdSR9oddwO9eHQJWJzuNQMmJ/mcIvCmXT6qq4Jo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bk44b5cCJQbnfcKBLrd3Q30P+Cx4ABGx5aKh5i4JcUfgK6uCpdD5DW3VF4aZdXICQP/gPvLXLBQqQdy35DfP9bMN2UQ46f5lGgC+dxmRt2zXWsb7f2u0eH+eDnYtLeWnVz8o+1e/eBZTIA9Cn9IbdNBItdNlO7OjRGCs00XryhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=c6MGZdNM; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="c6MGZdNM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:MIME-Version:References:Message-ID:Subject:Cc:To:
	From:Date:cc:to:subject:message-id:date:from:reply-to;
	bh=3ogVVRy+gjYuWJTEKyXU9wHZ16J+s+nW7RolmVRVlEg=; b=c6MGZdNMuuglNGPv2YGzuDT2p1
	92oDMzfePYwJb7yqHuiwsmC0tcggR8xWbli0EXOH4gocPAbajRzD0g+MeicFa+OQGyn446UHQHUmL
	ic5h53vqNS0YePGX49A0E09Q8h/IQD68WD1DYlyeAUlJ73U7aLS4VKOQmTn06DAmvHJRCApzJETx7
	Msxx+rrdpl+eiab2vrnYO3NZ8EqDj8OPRe8FVikco5hyAO2Wma98OWyQ8RLzxb+tkkUthPDRtiqQ9
	Cut/+6DXeDm7KOODKwW12MqjLm3wKKmIpB/JQbCSwJGIz97G6Fkl6WoahMptTgQZXz4JjvA4xJ8XW
	VFYyshVQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1v0zmB-007e9Z-01;
	Tue, 23 Sep 2025 17:57:36 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 23 Sep 2025 17:57:35 +0800
Date: Tue, 23 Sep 2025 17:57:35 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Shivani Agarwal <shivani.agarwal@broadcom.com>
Cc: davem@davemloft.net, smueller@chronox.de, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
	ajay.kaher@broadcom.com, alexey.makhalov@broadcom.com,
	tapas.kundu@broadcom.com, vamsi-krishna.brahmajosyula@broadcom.com,
	srinidhi.rao@broadcom.com, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: zero initialize memory allocated via sock_kmalloc
Message-ID: <aNJvD53QPva4Z7yo@gondor.apana.org.au>
References: <20250923074515.295899-1-shivani.agarwal@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250923074515.295899-1-shivani.agarwal@broadcom.com>

On Tue, Sep 23, 2025 at 12:45:15AM -0700, Shivani Agarwal wrote:
>
> diff --git a/crypto/af_alg.c b/crypto/af_alg.c
> index ca6fdcc6c54a..6c271e55f44d 100644
> --- a/crypto/af_alg.c
> +++ b/crypto/af_alg.c
> @@ -1212,15 +1212,14 @@ struct af_alg_async_req *af_alg_alloc_areq(struct sock *sk,
>  	if (unlikely(!areq))
>  		return ERR_PTR(-ENOMEM);
>  
> +	memset(areq, 0, areqlen);
> +
>  	ctx->inflight = true;
>  
>  	areq->areqlen = areqlen;
>  	areq->sk = sk;
>  	areq->first_rsgl.sgl.sgt.sgl = areq->first_rsgl.sgl.sgl;
> -	areq->last_rsgl = NULL;
>  	INIT_LIST_HEAD(&areq->rsgl_list);
> -	areq->tsgl = NULL;
> -	areq->tsgl_entries = 0;
>  
>  	return areq;
>  }
> diff --git a/crypto/algif_hash.c b/crypto/algif_hash.c
> index e3f1a4852737..4d3dfc60a16a 100644
> --- a/crypto/algif_hash.c
> +++ b/crypto/algif_hash.c
> @@ -416,9 +416,8 @@ static int hash_accept_parent_nokey(void *private, struct sock *sk)
>  	if (!ctx)
>  		return -ENOMEM;
>  
> -	ctx->result = NULL;
> +	memset(ctx, 0, len);
>  	ctx->len = len;
> -	ctx->more = false;
>  	crypto_init_wait(&ctx->wait);
>  
>  	ask->private = ctx;
> diff --git a/crypto/algif_rng.c b/crypto/algif_rng.c
> index 10c41adac3b1..1a86e40c8372 100644
> --- a/crypto/algif_rng.c
> +++ b/crypto/algif_rng.c
> @@ -248,9 +248,8 @@ static int rng_accept_parent(void *private, struct sock *sk)
>  	if (!ctx)
>  		return -ENOMEM;
>  
> +	memset(ctx, 0, len);
>  	ctx->len = len;
> -	ctx->addtl = NULL;
> -	ctx->addtl_len = 0;
>  
>  	/*
>  	 * No seeding done at that point -- if multiple accepts are

These changes look good.

> diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
> index 125d395c5e00..f4ce5473324f 100644
> --- a/crypto/algif_skcipher.c
> +++ b/crypto/algif_skcipher.c
> @@ -70,6 +70,7 @@ static int algif_skcipher_export(struct sock *sk, struct skcipher_request *req)
>  	if (!ctx->state)
>  		return -ENOMEM;
>  
> +	memset(ctx->state, 0, statesize);
>  	err = crypto_skcipher_export(req, ctx->state);
>  	if (err) {
>  		sock_kzfree_s(sk, ctx->state, statesize);

But this one should be dropped.  The ctx->state will immediately
be overwritten by crypto_skcipher_export.  Even if it fails, the
memory is immediately freed so no harm is done.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
