Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DCEB23A562;
	Sat, 14 Mar 2026 03:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773460795; cv=none; b=MnoZ55My/9zNyR8K0ZRRhpIgnUoAod63CcIYxcSaQgVdBJIxEmbzSym/lq5Rg7okbbP5DGLKQ+Quq+tYk/hJiKJcdlYtRZWjvGFMuhXIlbXRmQdJpSawcWRWgZcAyzsPpoL9IwbjYY4CezEkqfQoJibFT4+gIdLeJYFaVEHXLjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773460795; c=relaxed/simple;
	bh=LNFPZFCsJ9qnXTSR0XPC9X3Z+OPlOB7Jsfoc3tz5qi8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ESTB7bVeUjEY5IYHnmZiWLCUCsfzwfdpjx2rrRJywNbNZvQv6AQdvzpLU5kqdQUJwWJIA43qkoki463nZv75P27fipGeS4y/y1UMsfENZqNXutD73Ja1UafVBHQNH7QmdMhgzny8CJlXdfBTwwUzI+W8m8e/bNpeonGS8BqR2PU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Fcn+p5E+; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Fcn+p5E+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=FfxZ+pbix1CPfROYdCwHKZBewzv/U0sU5yp1lK36dek=; 
	b=Fcn+p5E+qXNkKeiPWI1OX7uyHLEJY8c1K1D4qPOPJUiIr6oRXQ6LH1NSm1bBFmOsMRTYsW9jvTe
	H1Q6bGKYpaXygFgc7HGSg9ZGOcW6rNCTQQVKsZLUwWtzwUONw5WfjVrpHPW/5P++Kd0WuL0Rb7nJd
	bNtml9xOb5aQMbmFh3N0PPFaDW7hLXai978bZj+vCkFmGvYw2o0ND5iUipd2zT8F2uaGviyb3LglZ
	mmw5tiuaIODaOlGfsri/qyF1B6l7XpQcAqhWeQ/e4sxbN+vwYoYC5ljdbEWGfAWZ98fVsbktppS9m
	Z2mELhWDtuw/7j4vZJ/o9Ltr2amnvZZS4BeA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w1GA1-00EKWg-1P;
	Sat, 14 Mar 2026 11:59:34 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 14 Mar 2026 12:59:33 +0900
Date: Sat, 14 Mar 2026 12:59:33 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: T Pratham <t-pratham@ti.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Manorit Chawdhry <m-chawdhry@ti.com>,
	Kamlesh Gurudasani <kamlesh@ti.com>,
	Shiva Tripathi <s-tripathi1@ti.com>,
	Kavitha Malarvizhi <k-malarvizhi@ti.com>,
	Vishal Mahaveer <vishalm@ti.com>,
	Praneeth Bajjuri <praneeth@ti.com>, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH v3 1/3] crypto: ti - Add support for SHA224/256/384/512
 in DTHEv2 driver
Message-ID: <abTdJSPtLYN0VJWm@gondor.apana.org.au>
References: <20260226131103.3560884-1-t-pratham@ti.com>
 <20260226131103.3560884-2-t-pratham@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260226131103.3560884-2-t-pratham@ti.com>

On Thu, Feb 26, 2026 at 06:41:01PM +0530, T Pratham wrote:
>
> +static int dthe_hash_export(struct ahash_request *req, void *out)
> +{
> +	struct dthe_hash_req_ctx *rctx = ahash_request_ctx(req);
> +	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
> +	struct dthe_tfm_ctx *ctx = crypto_ahash_ctx(tfm);
> +	union {
> +		u8 *u8;
> +		u64 *u64;
> +	} p = { .u8 = out };
> +
> +	memcpy(out, rctx->phash, ctx->phash_size);
> +	p.u8 += ctx->phash_size;
> +	put_unaligned(rctx->digestcnt[0], p.u64++);
> +	if (ctx->phash_size >= SHA512_DIGEST_SIZE)
> +		put_unaligned(rctx->digestcnt[1], p.u64++);
> +
> +	return 0;
> +}

The hash state must always be exported, even right after initialisation.
So you need to export the initial SHA stats if phash_available is
false.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
