Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793243165;
	b=FFTEnaaOHt+rJg/Y5R6F5CyMzkmxKcE3cv4qsU19unGc0kWsZ9GZ2CrpYAWEX6IeLCbm
	 mwCBu0xxwC8RgzchkpgsH9V74flLaIoaeeYtk6csvHqpQWb27nXm6TgfuTboPBbszZCyV
	 iI3YHMRafaE2cXMzfwnAmlYCJOCK7SsTCZs9qs3ADW46/MoRVblIQinnxhl5jb8dmb+Ax
	 w1AzIVZwOXB+tC/CXhiVcfpSiPDk0prAx36CHO0f0fPQsWyUo7se2J90eByQgDp3kZ7LH
	 N2m63//f80guV1IvDKMmVcid1zI7OP53VO0EfjOptCC8z8OqrNl3gTpWhcfIb/72wiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793243165;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=DsQzxyMenJds2tGUJsHplWFmap7Qi4tvdnzR8ntWQ/U=;
	b=Ep9vVTsAAJmUkl1mL5bIm0v3NKiOeE7JRkY4OV7zRHdvmXk8ftvoILYeIv0yajWbGyZF
	 NQz/5ReTrAMqR3rHP0Rq7X4xlzNMqbzNvBJdFGRpxPLBNHul8/N10MpGGvKSmNN0ZbCkd
	 nNUdTGfL0LpUIBoIW7KyF8jPBj83ykfuGZtvF5M1a9Ao/MgmP7SW77S00NXfatIkZgcPb
	 fHzj8TlL24KyR1o92LM7ZsJq4c1NZ5O7hBV9c2ru8WOr6qU+LWCZW1XGbaPhRm0r9oODf
	 2nsM02RfPmBao1e1iyvtXK1Q6+Yos71I3jNrIPE+KrehFPe6GEdjEx6voVwfrBcZHCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kn0KKHTG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0D1606A31C
	for <linux-crypto@vger.kernel.org>; Thu, 29 Oct 2026 03:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kn0KKHTG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A63E11F01828;
	Thu, 29 Oct 2026 03:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793243164;
	bh=DsQzxyMenJds2tGUJsHplWFmap7Qi4tvdnzR8ntWQ/U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kn0KKHTGAOzoTr530I4hGNyjDPLzk4IVpEbDXSW/90FmsEQyv5jVO7hh+K20Ldksc
	 7vLshdi2lOXs7rsnMjwKQCqhLdlsQU6f5Z1mUVVNLHQAFo+q/rv2S+pzycIB4YbfFx
	 3xTWifBCalaxWGn6ydsIGRw3J0isGYzcxIxrYOS+dux+eYHKBQkuRDjVYUGi2aAzyg
	 CH1GKuEVlgTTOljNMI5JcRwkDAnUyK+4gS1NsRJybvmHXsVXseBPStqZ+bbnQEwSxN
	 bYl6VLIDUb0kNZBmaEu3W5sXp0pcnH07YfqNlcrIEDHsvDfHZzZPGjHLqoYL6WfPlJ
	 3XyKqXdBcc9GQ==
Message-ID: <sashiko-outbox-188658@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 6/8] mm: zswap: Store large folios in batches.
Reply-To: sashiko-reviews@lists.linux.dev
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>, hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com, chengming.zhou@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, davem@davemloft.net, linux-crypto@vger.kernel.org
Cc: rientjes@google.com, willy@infradead.org, senozhatsky@chromium.org
In-Reply-To: <20261028030503.17923-7-kanchanapsridhar2026@gmail.com>
References: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
 <20261028030503.17923-7-kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 29 Oct 2026 03:06:03 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] mm: zswap: fix error return on buffer alloc failure in zswap_cpu_c=
omp_prepare()
- [Medium] mm: zswap: unsynchronized write to pool->compr_batch_size on CPU=
 hotplug
--

commit 13a7e2ffeb93e24e6a8f400496ff51f01ce0c408
Author: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>

mm: zswap: Store large folios in batches.

This commit introduces batching when storing large folios in zswap, allocat=
ing
multiple per-CPU compression destination buffers when supported by the
compressor and batch-allocating zswap entries from the slab cache. It also
caches the memcg writeback setting and folio NUMA node ID in a store context
and reorganizes struct zswap_pool for cacheline locality.

> diff --git a/mm/zswap.c b/mm/zswap.c
> index 19b7d60bc7d2a..c8890e8a9b836 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c

[ ... ]

> @@ -866,10 +922,28 @@ static int zswap_cpu_comp_prepare(unsigned int cpu,=
 struct hlist_node *node)
>  		goto fail;
>  	}
> =20
> +	/*
> +	 * Allocate up to ZSWAP_MAX_BATCH_SIZE dst buffers if the
> +	 * compressor supports batching.
> +	 */
> +	pool->compr_batch_size =3D min(ZSWAP_MAX_BATCH_SIZE,
> +				     crypto_acomp_batch_size(acomp_ctx->acomp));

[Severity: Medium]
Can updating pool->compr_batch_size inside the per-CPU hotplug callback race
with concurrent readers or cause a buffer count mismatch across CPUs?

In zswap_pool_create(), cpuhp_state_add_instance() runs zswap_cpu_comp_prep=
are()
only on currently online CPUs. If an offline CPU is brought online later wh=
ile
the pool is active, zswap_cpu_comp_prepare() writes to pool->compr_batch_si=
ze
without synchronization while zswap_store() concurrently reads it:

    store_batch_size =3D (pool->compr_batch_size > 1) ?
                        pool->compr_batch_size : ZSWAP_MAX_BATCH_SIZE;

Additionally, because each CPU independently calls crypto_alloc_acomp_node()
when brought online, if a higher-priority acomp implementation for
pool->tfm_name with a different batch_size is registered before a CPU comes
online, pool->compr_batch_size will be overwritten with the new value. When
zswap_pool_destroy() later frees each CPU's buffers using the single
pool->compr_batch_size:

    for_each_possible_cpu(cpu)
        acomp_ctx_free(per_cpu_ptr(pool->acomp_ctx, cpu),
                       pool->compr_batch_size);

acomp_ctx_free() would iterate past the end of acomp_ctx->comp.buffers (or
leak buffers) for CPUs that were initialized with the earlier batch size.

> +
>  	ret =3D zswap_acomp_req_init(&acomp_ctx->comp.areq, acomp_ctx->acomp);
>  	if (ret)
>  		goto req_fail;
> =20
> +	acomp_ctx->comp.buffers =3D kcalloc_node(pool->compr_batch_size, sizeof=
(u8 *),
> +					       GFP_KERNEL, nid);
> +	if (!acomp_ctx->comp.buffers)
> +		goto req_fail;
> +
> +	for (i =3D 0; i < pool->compr_batch_size; ++i) {
> +		acomp_ctx->comp.buffers[i] =3D kmalloc_node(PAGE_SIZE, GFP_KERNEL, nid=
);
> +		if (!acomp_ctx->comp.buffers[i])
> +			goto req_fail;
> +	}
> +
>  	/* Skip the per-CPU request when decompression can use the stack. */
>  	if (acomp_is_async(acomp_ctx->acomp)) {
>  		ret =3D zswap_acomp_req_init(&acomp_ctx->decomp, acomp_ctx->acomp);
> @@ -882,12 +956,13 @@ static int zswap_cpu_comp_prepare(unsigned int cpu,=
 struct hlist_node *node)
>  req_fail:
>  	pr_err("could not alloc crypto acomp_request %s\n", pool->tfm_name);
>  fail:
> -	acomp_ctx_free(acomp_ctx);
> +	acomp_ctx_free(acomp_ctx, pool->compr_batch_size);
>  	return ret;
>  }

[Severity: High]
Does zswap_cpu_comp_prepare() return 0 (success) if kcalloc_node() or
kmalloc_node() fails when allocating acomp_ctx->comp.buffers?

Earlier in zswap_cpu_comp_prepare(), ret is initialized to -ENOMEM, but then
zswap_acomp_req_init() is called:

    ret =3D zswap_acomp_req_init(&acomp_ctx->comp.areq, acomp_ctx->acomp);
    if (ret)
        goto req_fail;

When zswap_acomp_req_init() succeeds, ret is 0. If the subsequent
kcalloc_node() for acomp_ctx->comp.buffers or kmalloc_node() for
acomp_ctx->comp.buffers[i] fails and jumps to req_fail, ret is still 0.

At req_fail, acomp_ctx_free() frees the acomp state and sets
acomp_ctx->comp.buffers, acomp_ctx->comp.areq.req, and acomp_ctx->acomp to
NULL, and zswap_cpu_comp_prepare() returns 0 to the CPU hotplug core.
Subsequent calls to zswap_compress() on that CPU will then dereference NULL=
 at
dst =3D comp_ctx->buffers[0].

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261028030503.1792=
3-1-kanchanapsridhar2026@gmail.com?part=3D6
