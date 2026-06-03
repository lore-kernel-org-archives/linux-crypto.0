Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8491F3806C5;
	Wed,  3 Jun 2026 02:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780454870; cv=none; b=kw/zOp91qLmuYftbUt2VHdHFW2KUbnJdTUStNE9HxlLNqKThjNWDbBl4jXYczDTyEi1pF3ybOS48im970+Wezgi/jw/9AscJNJg9YvRKcdgQ8KzBtFeGbMqcfFnBXeDZf80yQcKplGbcmiqL+iWgpOsBTIFQ9UKtULvhCcKaG2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780454870; c=relaxed/simple;
	bh=zLThn5ELlGVTZIgTCfgBk6HK3rThC41kW3qQNWkowfE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hb3rrnx8HvVnu3TNpz90cWYjItzsNCzdNb+fqnlr7cQGLxRPqunviACjhLvHE/iTfwV2ocTFuy/5JAYP9iG2efXDMwrLS7L9YqcZD65+SicizIEkRh5p32A/I9LOdHX4g+iwYzv7tAOe8xU1kjBcf/Bpe4tFNClb308rZmDjAes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=pLGc/652; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="pLGc/652"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=cdWzvcfGbnqyGx7staWmXlYN+VUHJippWxB+WP8/jYo=; 
	b=pLGc/652HdHsnEHoUufPC6OlrYYCt03ydV8VlaMOf6OGVi4bFXhe/UEkLHvuiYWv/BBgBsrNhb0
	p/wK475B1X0rprjBVKHx9WRfoGabh9ldhkCf7DnNZI/Rs/d5saJYKXr/+kcg32gbHslKveEuXjksY
	t1GnQ0hkeJ003UKAETsg6KGr8OhsMG3LWZOmpqwPzlM7QLRuZouVFOZiDJK5Pv2OtMR8mCesjRfKL
	0SwuoBW9HrrwFTJ0A5HAJ39QHwCcoLalXcMRS2uoOfuLjsEHPRz0XppRGcZPAvp6XArwCSx1dw2bO
	raIeEOg8WgteRc1sUnbKHO3qjKZgzcnkTShg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wUbdr-001uGs-0f;
	Wed, 03 Jun 2026 10:47:40 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 03 Jun 2026 10:47:39 +0800
Date: Wed, 3 Jun 2026 10:47:39 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Wentao Liang <vulab@iscas.ac.cn>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] crypto/algapi: fix refcount leak in crypto_register_alg()
Message-ID: <ah-Vyxfn9ZLIhNLU@gondor.apana.org.au>
References: <20260603024119.3693829-1-vulab@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260603024119.3693829-1-vulab@iscas.ac.cn>

On Wed, Jun 03, 2026 at 02:41:19AM +0000, Wentao Liang wrote:
> In crypto_register_alg(), if the algorithm registration fails after
> a successful crypto_alg_get() on the template algorithm, the acquired
> reference is never released. This can occur when the new algorithm is
> not allowed to be registered due to a constraint check failure.
> 
> Fix the leak by adding a corresponding crypto_alg_put() call in the
> error path before returning.
> 
> Cc: stable@vger.kernel.org
> Fixes: f1440a90465b ("crypto: api - Add support for duplicating algorithms before registration")
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
> ---
>  crypto/algapi.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/crypto/algapi.c b/crypto/algapi.c
> index 37de377719ae..b0e4b13131c3 100644
> --- a/crypto/algapi.c
> +++ b/crypto/algapi.c
> @@ -447,6 +447,7 @@ int crypto_register_alg(struct crypto_alg *alg)
>  
>  		p = kmemdup(p, algsize + sizeof(*alg), GFP_KERNEL);
>  		if (!p)
> +			crypto_alg_put(alg);
>  			return -ENOMEM;

Where is this reference count coming from?
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
