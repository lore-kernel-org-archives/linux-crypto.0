Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 045864AA59E;
	Fri, 18 Sep 2026 08:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789720814; cv=none; b=hHepHZvBEX3RmLeUtonbzT3j68+31Z/sE0WzH4+jKLeLPicU0PllOxtEo3QLuDXB8uwCunZyPdV4KmWPKitqxlMBojCa0z6Jycn6xfJgDSqBrcYYGUAp8nIZZaFgp3O35ovdjn7mWmb4m4KeM0bQbSYcKznBsXJUAxS5/wHWvFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789720814; c=relaxed/simple;
	bh=K7V7Ma7lDcEZagFO0P4l8ZEMMVYhIi7YJJM+W80MAcE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cTukQ9bIjqYFeozIfAnzr/K9e//vgA0Pa9E04Exb2jXoGU/iEQDWrWi90n0Ljr71DlX9Vtser5OXQl5p5B/3k9anuPhq9V4z6sSoeeUlW9JxpHKjXlUqkgav0suHQI3DYgoe35AWBG21O2xzBCwydXVtEsMu2HecI3NTWsjwvIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=cCDMUHNR; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="cCDMUHNR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=pG44NYBS23dsJiBqAYC6vGPYrAyk0gnsW/77hlhZNnU=; 
	b=cCDMUHNRzAGYZ624JK5Dt8ogbNxEHbQUaRyqwPK8m1fFKAh4VUYh/ie0/SWK7WViketGpgqQT4z
	5VEIjJEkvXA4Gy2akoEGed/ncEDTlIpqD7twG6ofLtdmPt4TqKHCZIpf3RAYdeJ8p3HutThB7GJGW
	YagWv8y/aAcpJ8b1EwBusDoCCMK7gdDroVlvAb7LGeBNWoi/lbrQQtEfF7Quh3EH8t0gDvrlJdxAU
	ByvTFOlpkUv44MIgeKqiEUMjGK9z7mNkipdvsPxubEVxtrnrkd32XJ0fu42A0GleK65gYqYZZTYAp
	smR+BP+wnm5pbipubJhnB1QlB4vIzuTwkuEA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x7U8b-0000000FKOE-1ogZ;
	Fri, 18 Sep 2026 16:40:06 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Sep 2026 18:40:05 +1000
Date: Fri, 18 Sep 2026 18:40:05 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, robh@kernel.org, krzk@kernel.org,
	conor+dt@kernel.org, ruud.derwig@gf.com, rbannerm@synopsys.com,
	manjunath.hadli@vayavyalabs.com, adityak@vayavyalabs.com,
	navami.telsang@vayavyalabs.com, bhoomikak@vayavyalabs.com,
	nazim.khan@vayavyalabs.com
Subject: Re: [PATCH v25 2/4] crypto: spacc - Add SPAcc ahash support
Message-ID: <aqz45SDR8judkwk5@gondor.apana.org.au>
References: <20260907155916.999153-1-pavitrakumarm@vayavyalabs.com>
 <20260907155916.999153-3-pavitrakumarm@vayavyalabs.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907155916.999153-3-pavitrakumarm@vayavyalabs.com>

On Mon, Sep 07, 2026 at 09:29:14PM +0530, Pavitrakumar Managutte wrote:
>
> +static int spacc_hash_init(struct ahash_request *req)
> +{
> +	int rc;
> +	struct crypto_ahash *tfm        = crypto_ahash_reqtfm(req);
> +	struct spacc_crypto_ctx *tctx   = crypto_ahash_ctx(tfm);
> +	struct spacc_crypto_reqctx *ctx = ahash_request_ctx(req);
> +
> +	memset(ctx->state_buffer, 0, sizeof(ctx->state_buffer));
> +
> +	if (tctx->shash_fb) {
> +		SHASH_DESC_ON_STACK(desc, tctx->shash_fb);
> +
> +		desc->tfm = tctx->shash_fb;
> +		rc = crypto_shash_init(desc);
> +		if (!rc)
> +			rc = crypto_shash_export(desc, ctx->state_buffer);
> +		shash_desc_zero(desc);
> +	} else {
> +		HASH_FBREQ_ON_STACK(fbreq, req);
> +
> +		rc = crypto_ahash_init(fbreq);
> +		if (!rc)
> +			rc = crypto_ahash_export(fbreq, ctx->state_buffer);
> +		HASH_REQUEST_ZERO(fbreq);
> +	}

Why do we need two fallback paths? It would appear that you can
just use the else clause in all cases.

> +static const struct ahash_engine_alg spacc_hash_template = {
> +	.base = {
> +		.init     = spacc_hash_init,
> +		.update   = spacc_hash_update,
> +		.final    = spacc_hash_final,
> +		.finup    = spacc_hash_finup,
> +		.digest   = spacc_hash_digest,
> +		.setkey   = spacc_hash_setkey,
> +		.export   = spacc_hash_export,
> +		.import   = spacc_hash_import,
> +		.init_tfm = spacc_hash_init_tfm,
> +		.exit_tfm = spacc_hash_exit_tfm,
> +
> +		.halg.base = {
> +			.cra_priority	= 300,
> +			.cra_module	= THIS_MODULE,
> +			.cra_ctxsize	= sizeof(struct spacc_crypto_ctx),
> +			.cra_reqsize	= sizeof(struct spacc_crypto_reqctx),
> +			.cra_destroy	= spacc_hash_alg_destroy,
> +			.cra_flags	= CRYPTO_ALG_TYPE_AHASH    |
> +					  CRYPTO_ALG_ASYNC

Please use BLOCK_ONLY for all new drivers.  See aspeed for an
example on how it works.

> +	/*
> +	 * CMAC/XCBC-AES have a dedicated shash fallback (allocated in
> +	 * init_tfm).  They must not advertise CRYPTO_ALG_OPTIONAL_KEY or
> +	 * the crypto API may try to use the generic ahash fallback for them,
> +	 * which would recurse back into this driver.
> +	 */

How can it recurse back into the driver? The fallback allocated
by the API is always synchronous so unless your driver is sync
(which it is not) it cannot recurse.

> +		salg->alg.hash.base.halg.base.cra_flags =
> +			CRYPTO_ALG_TYPE_AHASH | CRYPTO_ALG_ASYNC |
> +			CRYPTO_ALG_NEED_FALLBACK;

There is no need to set NEED_FALLBACK as the API now allocates
fallbacks for all async drivers.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
