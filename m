Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D3223403E4;
	Thu, 11 Jun 2026 05:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781156955; cv=none; b=RStmm/yD+7rLLtnA7xgW4QeGFcLaAntE01/m3Pp0kP1Bhl9wmyE6EsLZo1ciPFe4A6scp5j8gubTbKkH1apxXk4ldFlrxdb3KMVQHi4cO0A+VSt1iuHrxjI6+gm8w4OCCIz9rO0Vy9ZLHCnY5mwLtJxlm+2K7SHB0H4HXqa+nCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781156955; c=relaxed/simple;
	bh=Cyg0gfS1CyZiOB3kXWPlXzrhcDAHMxUjdMxiF7hGPPI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IYkqToASGiUY7tgmqVGuZchVyRGXaoKLTmufx7VBME3LBQfhcO4SwOJ7ApbGDpit26GAtzTJjqXdLLFbQfordpyoH2be/y7uYaEKmgCNdLTEBgDWrd9w1mZ3BiSYQtekJiB+MFjW9mLpYvYFwiNi0eaYO98EUiQht0ZRf0xXdIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=p5hKQjjA; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="p5hKQjjA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=SmEPSkt8E7zGFX+Ycvi6FJfzrUqOPKPfjFIb6OeM/pw=; 
	b=p5hKQjjAGfj0YdQ5mDrrhu/R/DCB+ki5ng+3e2s2eEG8tQP33b36XxRcSkiHPfknoy7FcoFEjsm
	cASMPCcYKA/Vx0Miyv+P31MCn7Diymkah4Xid1veDdHQi8BnPDydlJhxfwB46YWarW5DQOWfFNkJz
	ixSg3YMR4Wv7ndVvNX81hayjf1uTqq6YWsP1kTuuQCPDhvDcFxNYBk07wCvouaBZ9xawaV9LCmLT2
	c9EPPXx5XbIkUoWIpoIUiDb5IbKJr5MsIyblYIfsF2UFJQ3RGrT4ZFnmKnBrjH1nseEYrx1uFDJkg
	cVE1+dweS+CS1IhbWxTUBSbt2rZYT7kOI0BQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wXYHr-00000004UYn-3J6E;
	Thu, 11 Jun 2026 13:49:08 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 11 Jun 2026 13:49:07 +0800
Date: Thu, 11 Jun 2026 13:49:07 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, robh@kernel.org, conor+dt@kernel.org,
	Ruud.Derwig@synopsys.com, rbannerm@synopsys.com,
	manjunath.hadli@vayavyalabs.com, adityak@vayavyalabs.com,
	navami.telsang@vayavyalabs.com, bhoomikak@vayavyalabs.com
Subject: Re: [PATCH v13 2/4] crypto: spacc - Add SPAcc ahash support
Message-ID: <aipMU4eFuNDsXDvt@gondor.apana.org.au>
References: <20260604165210.1141842-1-pavitrakumarm@vayavyalabs.com>
 <20260604165210.1141842-3-pavitrakumarm@vayavyalabs.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260604165210.1141842-3-pavitrakumarm@vayavyalabs.com>

On Thu, Jun 04, 2026 at 10:22:08PM +0530, Pavitrakumar Managutte wrote:
>
> +static int spacc_hash_do_one_request(struct crypto_engine *engine, void *areq)
> +{
> +	struct ahash_request *req = ahash_request_cast(areq);
> +	struct crypto_ahash *reqtfm = crypto_ahash_reqtfm(req);
> +	struct spacc_crypto_ctx *tctx = crypto_ahash_ctx(reqtfm);
> +	struct spacc_crypto_reqctx *ctx = ahash_request_ctx(req);
> +	struct spacc_priv *priv = dev_get_drvdata(tctx->dev);
> +	const struct spacc_alg *salg = spacc_tfm_ahash(&reqtfm->base);
> +	int rc = 0;
> +
> +	ctx->single_shot = 1;
> +	ctx->total_nents = sg_nents(req->src);
> +
> +	tctx->tmp_sgl = kmalloc_array(2, sizeof(*tctx->tmp_sgl), GFP_KERNEL);
> +
> +	if (!tctx->tmp_sgl)
> +		goto fallback;
> +
> +	sg_init_table(tctx->tmp_sgl, 2);
> +	tctx->tmp_sgl[0].length = 0;
> +
> +	if (tctx->handle < 0 || !tctx->ctx_valid) {
> +		priv = dev_get_drvdata(salg->dev);
> +		tctx->dev = get_device(salg->dev);
> +
> +		rc = spacc_is_mode_keysize_supported(&priv->spacc,
> +				salg->mode->id, tctx->keylen, 1);

This check could've been done before going through the crypto
engine.  If we're just going to use the fallback, there is no
point going all the way through the engine just to drop out right
at the end.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
