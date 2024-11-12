Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4569F4120B;
	Tue, 12 Nov 2024 01:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731375542; cv=none; b=geu6PefhnFetk+W2epH3MeuVOQGHChSy8RVyhrGNaS0E5ifnd+sXABBXVkRqf+ONZGSZWcaNsnjJhIq7EVztkn5t2mQwKN5HvbXwypg+GCJQz2mcdGtx8N2txQ87cXxZdogN31dJw/Z4ZBU9RTdAwpQXS7DbYuyQi4Kophoym4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731375542; c=relaxed/simple;
	bh=TYtfUvaSBmkYGaI9Yoe8GUpbtl258yIwCWQxq8POOEY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pstg1CP4c3FUrEMltaLtJCsKAftwwlyEDj4gzJ2XxYlycBR6hVEXwkojIt9Ki1cz7Rc1LgsanR1hcYRrdvcO+0lyI17Y7ztXTyGJbg7Zv9r9fu5u67jYvqqPuQ1AE6Jiyf2wY7XJgiHtcs+Gj4+4d6vE4W82FM4H0jkdTrfXqNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=nAyBWCfG; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="nAyBWCfG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=xZvY1bGI4bkBHnt6hz1JpA0tdaQ4DTO3a1dlQoAhuLQ=; b=nAyBWCfGK4o/UFiDVGqjCpAMVa
	TxsGRMre/FN28maacCkzJ0eoPO6F8nvyISLEGEXrSbs6DX1ecTIdJRycF39hOzkcdcTxv24sGzWL0
	+leufeCWv8fylh+OD2HfxXc0AcvEOPWQo+xAj5Vw5gBaPc6NT0pwVFAuBfhd0f36PTJZNaHtnHmkY
	oGhm1mj/4scsrV7y3tOClwexlcOizwJCFIQOJFTAsj+QOeboW2YEfpFiQjQHIqD7znpxWY0ktzl/1
	vindlzHv7wlm79affmtbH3dJT+0FS3kRo8ZrA0cPIerXAbPLlZlSjxLC3VbFuKfWgt/vJ4hgSbjVA
	yK0zALGA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tAfro-00G7o2-1J;
	Tue, 12 Nov 2024 09:38:53 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 12 Nov 2024 09:38:52 +0800
Date: Tue, 12 Nov 2024 09:38:52 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: dengler@linux.ibm.com, davem@davemloft.net, hca@linux.ibm.com,
	linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v3 3/3] s390/crypto: New s390 specific shash phmac
Message-ID: <ZzKxrKpSFCdz8LPp@gondor.apana.org.au>
References: <20241107145521.424769-1-freude@linux.ibm.com>
 <20241107145521.424769-4-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241107145521.424769-4-freude@linux.ibm.com>

On Thu, Nov 07, 2024 at 03:55:21PM +0100, Harald Freudenberger wrote:
>
> +static int s390_phmac_sha2_init(struct shash_desc *desc)
> +{
> +	struct s390_phmac_ctx *tfm_ctx = crypto_shash_ctx(desc->tfm);
> +	struct s390_kmac_sha2_ctx *ctx = shash_desc_ctx(desc);
> +	unsigned int bs = crypto_shash_blocksize(desc->tfm);
> +	int rc;
> +
> +	rc = phmac_convert_key(desc->tfm);
> +	if (rc)
> +		goto out;
> +
> +	spin_lock_bh(&tfm_ctx->pk_lock);
> +	memcpy(ctx->param + SHA2_KEY_OFFSET(bs),
> +	       tfm_ctx->pk.protkey, tfm_ctx->pk.len);
> +	spin_unlock_bh(&tfm_ctx->pk_lock);

This appers to be completely broken.  Each tfm can be used by
an unlimited number of descriptors in parallel.  So you cannot
modify the tfm context.  I see that you have taken spinlocks
around it, but it is still broken:

CPU1			CPU2
lock(tfm)
tfm->pk = pk1
unlock(tfm)
			lock(tfm)
			tfm->pk = pk2
			unlock(tfm)
lock(tfm)
copy tfm->pk to desc
	pk2 is copied
unlock(tfm)

Now this could all be harmless because pk1 and pk2 may be guaranteed
to be the same, but if that's the case why go through all this in
the first place? You could've just done it in setkey.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
