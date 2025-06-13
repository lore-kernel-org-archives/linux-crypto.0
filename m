Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0CDD279DA0
	for <linux-crypto@vger.kernel.org>; Fri, 13 Jun 2025 09:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749805450; cv=none; b=PMOV22Jyp6U1MoUimA1o1LYnwz2VQvqVA/U8kH1L/AiH0jifu6rJ+89Dwc6YrtAnhCG7ElvP4fPm7tAaURR/R4zKPx7x9QuYRWtMRS63BwnDqmTchqhU8gKt3Znw6d/JrUyMaGMsvErIO4g/eCn11ixCkuqFOCIQSR/9gIyzH7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749805450; c=relaxed/simple;
	bh=cCiMj3s8GeTAhomYpdtHgmpClWLvEj+jbXlfD2E+o1A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s31xQ+Uw9wbBnBNSQODeAYo3eq0ThoxJIP5ZigqkHPc+hmIJ/cdkQzUv/hN1g2N9fbiYVJ9Qal7c0IYeSwzKeXtauTgEERHELHEHhjkhYXLR2pt7o7RzpYsdsKwo3ebDfVBHkqQFIUjxR6R6wfmJOPNq/++Z+FXVPxW+fNZj0Eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=hVkQONxI; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="hVkQONxI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=BfMROpeMtfb28TEWbbkXwBnNayvCZs/x+IEC4JE5abw=; b=hVkQONxI6ZoclQqFFRmAc6D2ot
	WjdQfskqVpUYFkWzUdSkcjWK4sm1soYk+k9ztQLZWV3H2apeiaMc+8EffkdK1650btLzHHZS6EBzb
	OWS3IDkmuCVVYdIgce8gfxVEs8nN0yFW26CwuCYwC/ogbnrPQkONgwGZkqNDjkTP2vVYMDKij6ovA
	2ZGXrfzemTEFYwxb86Krvgph9mVWTNDTteJGYe+LgAyCxshKFF3oDMa9FtrECIOevWIE8S6Smn53y
	VpAWCFqnlxk1VETExNNsMIrtJDCVIoKKo9h9CclKkpgw2N6wEQ97X/hCFO2fTyrSrRSre+57cpUZ5
	iw82TR8Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uQ0KQ-00CsMO-2C;
	Fri, 13 Jun 2025 17:04:03 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 13 Jun 2025 17:04:02 +0800
Date: Fri, 13 Jun 2025 17:04:02 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com, dsterba@suse.com,
	terrelln@fb.com, clabbe.montjoie@gmail.com
Subject: Re: [PATCH v6] crypto: zstd - convert to acomp
Message-ID: <aEvpgrEiitqZPFkB@gondor.apana.org.au>
References: <20250604042538.876415-1-suman.kumar.chakraborty@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250604042538.876415-1-suman.kumar.chakraborty@intel.com>

On Wed, Jun 04, 2025 at 05:25:38AM +0100, Suman Kumar Chakraborty wrote:
>
> +	u8 wksp[0] __attribute__((aligned(8)));

Please use __aligned.

> -static int __zstd_compress(const u8 *src, unsigned int slen,
> -			   u8 *dst, unsigned int *dlen, void *ctx)
> +static int zstd_compress_one(struct acomp_req *req, struct zstd_ctx *ctx, unsigned int *dlen)
>  {
> -	size_t out_len;
> -	struct zstd_ctx *zctx = ctx;
> -	const zstd_parameters params = zstd_params();
> +	unsigned int out_len;
>  
> -	out_len = zstd_compress_cctx(zctx->cctx, dst, *dlen, src, slen, &params);
> +	ctx->cctx = zstd_init_cctx(ctx->wksp, ctx->wksp_size);
> +	if (!ctx->cctx)
> +		return -EINVAL;
> +
> +	out_len = zstd_compress_cctx(ctx->cctx, sg_virt(req->dst),
> +				     req->dlen, sg_virt(req->src),
> +				     req->slen, &ctx->params);

Even if the SG is linear, it may not have been mapped so you
can't just do sg_virt.  Just use the mapped address from the
walk object.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
