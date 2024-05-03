Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02E5B1E528
	for <linux-crypto@vger.kernel.org>; Fri,  3 May 2024 10:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714732171; cv=none; b=KJt+tyxFFmpYBYeF4srbwXr22hvgKkApgh/o85HUlyFeJDkiUr2LHKasleq3PNKAWtTp+TZfmnZNh7Tu9FBZkjg97cOkc29f7O3JCwBQRN+BndblcBJ7KUnPPhivszow/BqyvZm22vb81J1XPsp519QCY74a0tPXhiVW/TWjkHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714732171; c=relaxed/simple;
	bh=TmKpUMRI6Ree+2eyrjNyYBH3PWjitawXiYjqO2R3vx4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CUXn+Sqfnx40pXZ4XwcgbvpeaSZ5pb9g/iwziI2PxirvpZcDdPkn2PZwPtNZaibiYlh5FuJRg4krbmYJGffWXDLRnjTOVUJKOOAqg3+MZ8zfX+hl6U6qMIDaRmhZsyHWEZ97VNqWC+8xL1D3oqvl9jT0VwefMlufL2uB1/eDIYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1s2qAH-009v6Y-1x;
	Fri, 03 May 2024 18:29:18 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 03 May 2024 18:29:17 +0800
Date: Fri, 3 May 2024 18:29:17 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Cc: linux-crypto@vger.kernel.org, Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com, bhoomikak@vayavyalabs.com
Subject: Re: [PATCH v3 3/7] Add SPAcc ahash support
Message-ID: <ZjS8fQE5No1rDygF@gondor.apana.org.au>
References: <20240426042544.3545690-1-pavitrakumarm@vayavyalabs.com>
 <20240426042544.3545690-4-pavitrakumarm@vayavyalabs.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240426042544.3545690-4-pavitrakumarm@vayavyalabs.com>

On Fri, Apr 26, 2024 at 09:55:40AM +0530, Pavitrakumar M wrote:
.
> +static int spacc_hash_export(struct ahash_request *req, void *out)
> +{
> +	const struct spacc_crypto_reqctx *ctx = ahash_request_ctx(req);
> +
> +	memcpy(out, ctx, sizeof(*ctx));
> +
> +	return 0;
> +}

Did you test this with CRYPTO_MANAGER_EXTRA_TESTS enabled?

When a hash exports its state, it's meant to write out the actual
partial hash state, not a bunch of kernel pointers.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
