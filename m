Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D65E1481CD;
	Fri, 17 Oct 2025 01:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760663400; cv=none; b=qW8IXe+70eo2T+AHZVOy5+gP/hMRxZKMtIajRMNDnFkQFH3DlPMHZA3sbNIa5p3mze/O3/hoeUm+rpLe6sljl6Zc520hLKShzThGAaDpqPugyTPcQ64abmjIFkc12kPZgYOXEysLP3TlslOYm8j5N71/a1NspAatDkYoJQwBC2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760663400; c=relaxed/simple;
	bh=3RwEMkNUz2AMELL+VYqJw1cfeQerHXMYHnGgBZXThw8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G0kOBEwD56M7ny/6eybkAuOR4e3vtmRwikOvWGVGOTBV0L+DMcFL+VOkqvWhvUNuMa5/n/0we1+xp3Mx86o+5RczV/tJpvewUWcgplkNRe/VBD9BWyIWGTYhi58rbF1OvOV6tFo3qQeUiyCZfBi++Cc8VN5mrISaJASkoeqwOL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=qbcQPSRg; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="qbcQPSRg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=dg9UrmyeMX3l+vmZbebYqb6LMNHNQPPuGCglxcVhywk=; 
	b=qbcQPSRginp3zT2ooRQz3ELG230xVO5RMIK+33anIhQR+2nchY8murdgvYBLZ0V633tXYE2i1m3
	samNW1mzPP3Ti+htL4q1rZ/VmrY43UFU7womf5MhHRJ/JaaW7V0ZrNd58SJW34CRg0EyHLdq40Vnm
	TyhpFsHOAmpbgdSlRC9azpuUzh0msbI8egLKuQxVj7kuPlEhbIPUK2W6w5Im6/4ExkXb1DzV+uquX
	QjdbnVDbGWbcN0oXNuq4JZR9DU/HeT3MQigmcijBQ1NxjqKM+5WQNdOkm49AM2SfU2Yr41e9uIZ0P
	9UAOgF6YIc4DKNefHbYdTcFD1N10kUg/ckcA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1v9YyR-00DI4R-1l;
	Fri, 17 Oct 2025 09:09:40 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 17 Oct 2025 09:09:39 +0800
Date: Fri, 17 Oct 2025 09:09:39 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org,
	yosry.ahmed@linux.dev, nphamcs@gmail.com, chengming.zhou@linux.dev,
	usamaarif642@gmail.com, ryan.roberts@arm.com, 21cnbao@gmail.com,
	ying.huang@linux.alibaba.com, akpm@linux-foundation.org,
	senozhatsky@chromium.org, sj@kernel.org, kasong@tencent.com,
	linux-crypto@vger.kernel.org, davem@davemloft.net,
	clabbe@baylibre.com, ardb@kernel.org, ebiggers@google.com,
	surenb@google.com, kristen.c.accardi@intel.com,
	vinicius.gomes@intel.com, wajdi.k.feghali@intel.com,
	vinodh.gopal@intel.com
Subject: Re: [PATCH v12 14/23] crypto: iaa - IAA Batching for parallel
 compressions/decompressions.
Message-ID: <aPGXUxRZeYLO_CUo@gondor.apana.org.au>
References: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
 <20250926033502.7486-15-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250926033502.7486-15-kanchana.p.sridhar@intel.com>

On Thu, Sep 25, 2025 at 08:34:53PM -0700, Kanchana P Sridhar wrote:
>
> +__always_inline int iaa_comp_compress_batch(
> +	enum iaa_mode mode,
> +	struct iaa_req *parent_req,
> +	unsigned int unit_size)
> +{
> +	return iaa_comp_acompress_batch(iaa_ctx[mode], parent_req, unit_size);
> +}
> +EXPORT_SYMBOL_GPL(iaa_comp_compress_batch);
> +
> +__always_inline int iaa_comp_decompress_batch(
> +	enum iaa_mode mode,
> +	struct iaa_req *parent_req,
> +	unsigned int unit_size)
> +{
> +	return iaa_comp_adecompress_batch(iaa_ctx[mode], parent_req, unit_size);
> +}
> +EXPORT_SYMBOL_GPL(iaa_comp_decompress_batch);

What are these for?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
