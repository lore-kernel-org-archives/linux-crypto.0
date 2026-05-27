Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D7D039C63D
	for <linux-crypto@vger.kernel.org>; Wed, 27 May 2026 17:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779903196; cv=none; b=QPtGNuTVeDBX3gU9bvgcV+ucU/AIVqZA3e0uCO8zEkJ4gq6kdzKkLs+mfnNMGAX6eZU148dwva4HHjTryhoqWNXNt+8sFjkJb0d35vSkcqFR4fLTvoupvX5Sgdm8nDl1KutgKCJigy3ADIcLUH3LbmFLg9FttPeUqWZL1Mmw1IQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779903196; c=relaxed/simple;
	bh=FxFhadcSC6cjPReQAORcacd1A09nh8WHMoTrbMH405w=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=g8F+Ud9gzagsBIL5J46oaDSj1L+GNBlXASwW/X8lG9gqFbRWxfuCmK3+Tsggdv3e/KUoGFYyROKmUj11+Rv0yciIcLSeNjPPC5d3q7TeUDkJ1EbKezwXRVe3m1hakUFboT1nbXa9OGpgGlOJnY9XRJaJIcq67n5lo6u0M43ROgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RjlKGDpY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RjlKGDpY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779903194;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9frPwY1OQPr9fMKeynViORyeJ9Wy9bgDD7DDIXjto1U=;
	b=RjlKGDpYDye2oOKh9lZflsTbn/sUnAWE4IoIFSdSRhRhV9Cm+3gAq7Z//0LCpxbxksYj/k
	N0ONuq3IaAtsbhBjhFklyd7cWbABf5UAOSmsUJkkGfyZqgjKnmBpZecAtctp77sTccwI8v
	tqcHVXv4VZCpCyMtMQ3y9lDwvT7xkI0=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-369-sUi0JFExMxWotYbohv7wWA-1; Wed,
 27 May 2026 13:33:11 -0400
X-MC-Unique: sUi0JFExMxWotYbohv7wWA-1
X-Mimecast-MFC-AGG-ID: sUi0JFExMxWotYbohv7wWA_1779903189
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2A9E119560AA;
	Wed, 27 May 2026 17:33:08 +0000 (UTC)
Received: from [10.44.32.28] (unknown [10.44.32.28])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DA79F1800465;
	Wed, 27 May 2026 17:33:03 +0000 (UTC)
Date: Wed, 27 May 2026 19:32:56 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Leonid Ravich <lravich@amazon.com>
cc: Herbert Xu <herbert@gondor.apana.org.au>, 
    "David S . Miller" <davem@davemloft.net>, 
    Mike Snitzer <snitzer@kernel.org>, Alasdair Kergon <agk@redhat.com>, 
    Ard Biesheuvel <ardb@kernel.org>, Eric Biggers <ebiggers@kernel.org>, 
    Jens Axboe <axboe@kernel.dk>, Horia Geanta <horia.geanta@nxp.com>, 
    Gilad Ben-Yossef <gilad@benyossef.com>, linux-crypto@vger.kernel.org, 
    dm-devel@lists.linux.dev, linux-block@vger.kernel.org
Subject: Re: [PATCH v2 4/4] dm crypt: batch all sectors of a bio per crypto
 request
In-Reply-To: <20260527065021.19525-5-lravich@amazon.com>
Message-ID: <d288173f-86fe-adda-99e7-6b5e975660f7@redhat.com>
References: <20260527065021.19525-1-lravich@amazon.com> <20260527065021.19525-5-lravich@amazon.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Hi

On Wed, 27 May 2026, Leonid Ravich wrote:

> +/*
> + * Multi-data-unit variant of crypt_convert_block_skcipher.  Submits all
> + * remaining sectors of the current bio in one skcipher request whose
> + * data_unit_size is cc->sector_size.  The cipher walks the IV between
> + * data units (see crypto_skcipher_set_data_unit_size()).
> + *
> + * Returns the same set of values as crypt_convert_block_skcipher:
> + *   0 on synchronous success (full chunk processed),
> + *   -EINPROGRESS / -EBUSY on asynchronous dispatch,
> + *   -EAGAIN if the per-bio scatterlist allocation cannot be made.  The
> + *           caller MUST disable multi-data-unit batching for the rest
> + *           of this bio and re-enter the per-sector path, which uses
> + *           only mempool reserves and is therefore safe even on the
> + *           swap-out-to-dm-crypt path under total memory exhaustion.
> + *   negative errno otherwise.
> + *
> + * On success the bio iterators have been advanced by the chunk size.
> + *
> + * Walks the bio with __bio_for_each_bvec so that multi-page folios
> + * produce one scatterlist entry rather than N (one per PAGE_SIZE).
> + */
> +static int crypt_convert_block_skcipher_multi(struct crypt_config *cc,
> +					      struct convert_context *ctx,
> +					      struct skcipher_request *req,
> +					      unsigned int *out_processed)
> +{
> +	const unsigned int sector_size = cc->sector_size;
> +	const gfp_t gfp = GFP_NOIO | __GFP_NORETRY | __GFP_NOWARN;
> +	unsigned int total_in = ctx->iter_in.bi_size;
> +	unsigned int total_out = ctx->iter_out.bi_size;
> +	unsigned int total = min(total_in, total_out);
> +	unsigned int n_sectors;
> +	unsigned int n_sg_in = 0, n_sg_out = 0;
> +	struct dm_crypt_request *dmreq = dmreq_of_req(cc, req);
> +	struct scatterlist *sg_in = NULL, *sg_out = NULL;
> +	struct bvec_iter iter_in, iter_out;
> +	struct bio_vec bv;
> +	u8 *iv, *org_iv;
> +	int r;
> +
> +	if (unlikely(total < sector_size))
> +		return -EIO;
> +	n_sectors = total / sector_size;
> +	total = n_sectors * sector_size;

Division is slow. There should be this:
	n_sectors = total >> cc->sector_shift;


> +     if (unlikely(total < sector_size))
> +             return -EIO;

The condition total < sector_size is true if total is small but it goes 
through if total is bigger but unaligned. I think that it should be:

	if (unlikely(total & (sector_size - 1)))
		return -EIO;

(then, we can drop the line "total = n_sectors * sector_size")

ctx->iter_in.bi_size is supposed to be the same as ctx->iter_out.bi_size, 
so do we really need total = min(total_in, total_out)? Should it instead 
warn if they differ? (where the warning would indicate a bug in the code)

Mikulas

