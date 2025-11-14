Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 782AB30B50C;
	Fri, 14 Nov 2025 09:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763114396; cv=none; b=POYj6zv3mZA6DNzp/n0pxlQMXFJ1PCah4w89szZRtvcLyHQ7U0HasjQ+XkZIKBgv0C+YvVTBc2dRog03efkPD5kSlXqk8S/+vfXK+6lMeBLi+dwPvb0Opj+UTOS+1caiaweq12dlAKVmKs+JcJ0dLr/otUJbLKmgP+cd9h5jsx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763114396; c=relaxed/simple;
	bh=h/YX3dJDvTfjdK/QBeR1KF7ld5D/KoATDZ+ba3OtIJE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EySZo/C0kpIucjz2xyGMVkp7ynOF7xrZDRw3uCkn+YKF7/itlzrFN/CLs8rCfp3uOa/5f5KN7m3xuNfpLPzLI/QgNv6wvnI05NZR7ZvoCKaLv+eid/XZ4dDsgNwJHPBHV9+SN8lFnnZJTfU3tHyiOeRDfr02ZEy2Jwka4rnsGAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=LqnKDYHJ; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="LqnKDYHJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=A2r/Q/+wRJ2BFr/BHn0s3SothtWMfgvNhJUxmswYYkc=; 
	b=LqnKDYHJ2hV1IWITk+XlcWoHcu2Bw8J4lGqIWsyd9e2uwsdNVw9Yn38Wt/o2M7PcyulnvfUhU39
	4KxuZBwog498fmSq/U2tuU0k1n2FhhPvnzMSrrDQr7Jml0Grp5VoP6FxpqtpZGKQDMdd2Yt0AjfTr
	b8ud4vzpnGbgPkdCX7WvJR+hGGpKIU55v5G3xX2WxkSZlqnkmFRg3XEKLH6yztg4cjQUjeCWaTktt
	LFaXDmsiA1XVetPG1Y0YvcILkSqEt/RLoe1cNVyvZpfYpmgW9p5gKglPeIz6HhQnaFov/u9bkhRB5
	EKf+ZLk6JT1ynYj6u61PoNfgwjO2ZHji95Eg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vJqaS-002y5g-25;
	Fri, 14 Nov 2025 17:59:25 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 14 Nov 2025 17:59:24 +0800
Date: Fri, 14 Nov 2025 17:59:24 +0800
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
Subject: Re: [PATCH v13 13/22] crypto: iaa - IAA Batching for parallel
 compressions/decompressions.
Message-ID: <aRb9fGDUhgRASTmM@gondor.apana.org.au>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
 <20251104091235.8793-14-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251104091235.8793-14-kanchana.p.sridhar@intel.com>

On Tue, Nov 04, 2025 at 01:12:26AM -0800, Kanchana P Sridhar wrote:
>
> +/**
> + * This API provides IAA compress batching functionality for use by swap
> + * modules.
> + *
> + * @ctx:  compression ctx for the requested IAA mode (fixed/dynamic).
> + * @parent_req: The "parent" iaa_req that contains SG lists for the batch's
> + *              inputs and outputs.
> + * @unit_size: The unit size to apply to @parent_req->slen to get the number of
> + *             scatterlists it contains.
> + *
> + * The caller should check the individual sg->lengths in the @parent_req for
> + * errors, including incompressible page errors.
> + *
> + * Returns 0 if all compress requests in the batch complete successfully,
> + * -EINVAL otherwise.
> + */
> +static int iaa_comp_acompress_batch(
> +	struct iaa_compression_ctx *ctx,
> +	struct iaa_req *parent_req,
> +	unsigned int unit_size)
> +{
> +	struct iaa_batch_ctx *cpu_ctx = raw_cpu_ptr(iaa_batch_ctx);
> +	int nr_reqs = parent_req->slen / unit_size;
> +	int errors[IAA_CRYPTO_MAX_BATCH_SIZE];
> +	int *dlens[IAA_CRYPTO_MAX_BATCH_SIZE];
> +	bool compressions_done = false;
> +	struct sg_page_iter sgiter;
> +	struct scatterlist *sg;
> +	struct iaa_req **reqs;
> +	int i, err = 0;
> +
> +	mutex_lock(&cpu_ctx->mutex);
> +
> +	reqs = cpu_ctx->reqs;
> +
> +	__sg_page_iter_start(&sgiter, parent_req->src, nr_reqs,
> +			     parent_req->src->offset/unit_size);
> +
> +	for (i = 0; i < nr_reqs; ++i, ++sgiter.sg_pgoffset) {
> +		sg_set_page(reqs[i]->src, sg_page_iter_page(&sgiter), PAGE_SIZE, 0);
> +		reqs[i]->slen = PAGE_SIZE;
> +	}
> +
> +	for_each_sg(parent_req->dst, sg, nr_reqs, i) {
> +		sg->length = PAGE_SIZE;
> +		dlens[i] = &sg->length;
> +		reqs[i]->dst = sg;
> +		reqs[i]->dlen = PAGE_SIZE;
> +	}
> +
> +	iaa_set_req_poll(reqs, nr_reqs, true);
> +
> +	/*
> +	 * Prepare and submit the batch of iaa_reqs to IAA. IAA will process
> +	 * these compress jobs in parallel.
> +	 */
> +	for (i = 0; i < nr_reqs; ++i) {
> +		errors[i] = iaa_comp_acompress(ctx, reqs[i]);
> +
> +		if (likely(errors[i] == -EINPROGRESS)) {
> +			errors[i] = -EAGAIN;
> +		} else if (unlikely(errors[i])) {
> +			*dlens[i] = errors[i];
> +			err = -EINVAL;
> +		} else {
> +			*dlens[i] = reqs[i]->dlen;
> +		}
> +	}
> +
> +	/*
> +	 * Asynchronously poll for and process IAA compress job completions.
> +	 */
> +	while (!compressions_done) {
> +		compressions_done = true;
> +
> +		for (i = 0; i < nr_reqs; ++i) {
> +			/*
> +			 * Skip, if the compression has already completed
> +			 * successfully or with an error.
> +			 */
> +			if (errors[i] != -EAGAIN)
> +				continue;
> +
> +			errors[i] = iaa_comp_poll(ctx, reqs[i]);
> +
> +			if (errors[i]) {
> +				if (likely(errors[i] == -EAGAIN)) {
> +					compressions_done = false;
> +				} else {
> +					*dlens[i] = errors[i];
> +					err = -EINVAL;
> +				}
> +			} else {
> +				*dlens[i] = reqs[i]->dlen;
> +			}
> +		}
> +	}

Why is this polling necessary?

The crypto_acomp interface is async, even if the only user that
you're proposing is synchronous.

IOW the driver shouldn't care about synchronous polling at all.
Just invoke the callback once all the sub-requests are complete
and the wait call in zswap will take care of the rest.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
