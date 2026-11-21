Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795234807;
	b=5hM8pIic0qWfwbKDJu8k3TN4eORYgPqES8FnQcAzkLnUHGCCjQyUl2xtyps8t2ungPXt
	 7l7LyfafaQzTIUJx16cg2mUvOZYe4o70hZXPen9bzrjy0v8+wnWYSHif9f9ctZLjJHlT+
	 uwhQ279QOSx/Vp/wa9nK0cUe7wl8rU/5UwITDGSxLD4Cc1lHO5GEqPLrENBQ11nzYT1Bx
	 PLUMWb2iG7ZRe7Z0fiys9jTDwqeTNHd5neLoiGkOp3/tVNavEOTl7fz18955UveUx4m0t
	 IuvrZVs00oz3fGZH3NdprQKnY7HqXEl+b4pYM0wEr1yO3SJMLzNe6qfHXsNihaGMPZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795234807;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=8ZqbbDSjke+XMJ3ebFLBEmOYyidYIFJAnfBofycZOb8=;
	b=mipmBeZPtfI4i4PG6Jztx17uNNr2qMmW7+hqszzVtk94G3+VBqCKFSLqkHumyV4anhaG
	 3PkazPVoiNRg6rApufk45srZBh0+Amg7ngaL8Hgx2O8czGNtD4EQG75R35aJzFtwYhGH4
	 JmN8iC9KPePLTlb+7ljeeHt6LJc04EGwmvQRUKWD4ss7vidJwsnRXFcFwQuUyotQai2KR
	 zoY85bljyjQuddrLICKMBEG6s4zsTW0gZWKonzB6qCDipLNTaLDG9KPM5eL5PcHON0c+U
	 cy/+vqgKB5ymsDYWBO7BQdmtl5hmEE0v1hMolze2bSsGGw+UkasuwvF9rvi4/UqU7SA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dHE5kvuJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16D7C606A6AC
	for <linux-crypto@vger.kernel.org>; Sat, 21 Nov 2026 04:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dHE5kvuJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 646721F000C0;
	Sat, 21 Nov 2026 04:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795234806;
	bh=8ZqbbDSjke+XMJ3ebFLBEmOYyidYIFJAnfBofycZOb8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dHE5kvuJY5/LeYveUlenuretLxiRsnhTU576aiX7Voj9dKn4BshHsU8K03gyizSM2
	 NCfy+T43GbQ/ZsGJMgG1oAB4IsBm+5VFEozoRSXZxFKqgsXpza6leHoxETCWLTeHvf
	 kZnVF5WKV8lF1APrsZYaSyvjqUBSCrOz0rW3j/3ts9hwdbJYfBbL5CQBPvPlCGRbim
	 o1BXuTsLFd1Rc7PvUad15wIUorvA1Up411QtkkQmsXl0hNmvGO7CUZXA6FJlZdrukt
	 cup+zwO67wRNB9inCdy2nRJWD893Ts97kPtMtlLr5bjGvMexeg+7z+4jociWt05NFC
	 i10YDnnNf8baw==
Message-ID: <sashiko-outbox-226638@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 8/8] mm: zswap: Batched zswap_compress() for storing
 large folios in batches.
Reply-To: sashiko-reviews@lists.linux.dev
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>, hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com, chengming.zhou@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, davem@davemloft.net, linux-crypto@vger.kernel.org
Cc: rientjes@google.com, willy@infradead.org, senozhatsky@chromium.org
In-Reply-To: <20261120041906.5785-9-kanchanapsridhar2026@gmail.com>
References: <20261120041906.5785-1-kanchanapsridhar2026@gmail.com>
 <20261120041906.5785-9-kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 21 Nov 2026 04:20:06 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [High] mm: zswap: invalid and unreset dst scatterlist lengths in
  zswap_compress()
- [High] mm: zswap: unterminated dst scatterlist slice passed in
  zswap_compress()
- [Medium] mm: zswap: unsigned sg->length check and error accounting in
  zswap_compress()
--

commit a77cc3e636d5134b6371aa977bb1025c031583c2
Author: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>

mm: zswap: Batched zswap_compress() for storing large folios in batches.

This commit replaces the per-page zswap_compress() call in
zswap_store_pages() with a batched zswap_compress() and
zswap_update_entries() that compress up to ZSWAP_MAX_BATCH_SIZE pages per
batch using a per-CPU scatterlist table mapped to destination buffers.

> diff --git a/mm/zswap.c b/mm/zswap.c
> index 5e1fb5624ffb8..56354a568bad0 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
[ ... ]
> @@ -949,6 +971,26 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, =
struct hlist_node *node)
>  		}
>  	}
> =20
> +	acomp_ctx->comp.sg_table =3D kmalloc(sizeof(*acomp_ctx->comp.sg_table),
> +					   GFP_KERNEL);
> +	if (!acomp_ctx->comp.sg_table) {
> +		ret =3D -ENOMEM;
> +		goto req_fail;
> +	}
> +
> +	if (sg_alloc_table(acomp_ctx->comp.sg_table, ZSWAP_MAX_BATCH_SIZE,
> +			   GFP_KERNEL)) {
> +		ret =3D -ENOMEM;
> +		goto req_fail;
> +	}
> +
> +	/*
> +	 * Statically map the per-CPU destination buffers to the per-CPU
> +	 * SG lists; crucial for performance.
> +	 */
> +	for_each_sg(acomp_ctx->comp.sg_table->sgl, sg, ZSWAP_MAX_BATCH_SIZE, i)
> +		sg_set_buf(sg, acomp_ctx->comp.buffers[i], PAGE_SIZE);
> +
[ ... ]
> @@ -965,88 +1007,179 @@ static int zswap_cpu_comp_prepare(unsigned int cp=
u, struct hlist_node *node)
[ ... ]
> +static bool zswap_compress(struct zswap_store_context *zc)
> +{
> +	u8 nr_batch_pages, batch_start, comp_batch_iter;
> +	struct scatterlist *sg, *dst_sg;
> +	unsigned int slen;
> +	int err;
> =20
>  	/*
> +	 * @nr_batch_pages is constrained by the per-CPU comp_ctx's compressor
> +	 * batch size and the @zc->nr_pages in this store batch. @slen indicates
> +	 * the total source length bytes for @nr_batch_pages.
>  	 */
> +	nr_batch_pages =3D min(zc->comp_ctx->compr_batch_size, zc->nr_pages);
> =20
>  	/*
> +	 * Compress the @nr_pages in @folio starting at index @folio_start
> +	 * in batches of @nr_batch_pages.
>  	 */
> +	for (batch_start =3D 0; batch_start < zc->nr_pages;
> +	     batch_start +=3D nr_batch_pages) {
> +		/*
> +		 * Clamp the last iteration's batch size if the compressor's
> +		 * batch_size does not evenly divide @zc->nr_pages.
> +		 */
> +		nr_batch_pages =3D min(nr_batch_pages, zc->nr_pages - batch_start);
> +		slen =3D nr_batch_pages * PAGE_SIZE;
> +
> +		/*
> +		 * Send @nr_batch_pages to crypto_acomp for compression:
> +		 *
> +		 * These pages are in @zc->folio's range of indices in the
> +		 * interval:
> +		 *     [@zc->folio_start + @batch_start,
> +		 *      @zc->folio_start + @batch_start + @nr_batch_pages).
> +		 *
> +		 * The source folio pages in the batch are directly submitted to
> +		 * crypto_acomp via acomp_request_set_src_folio().
> +		 */
> +		acomp_request_set_src_folio(zc->comp_ctx->areq.req, zc->folio,
> +				(zc->folio_start + batch_start) * PAGE_SIZE,
> +				slen);
> +
> +		dst_sg =3D zc->comp_ctx->sg_table->sgl + batch_start;
> +		dst_sg->length =3D slen;

[Severity: High]
Does setting only dst_sg->length =3D slen overrun acomp_ctx->comp.buffers[]
and leave dst_sg[1 .. nr_batch_pages - 1].length uninitialized when
nr_batch_pages > 1?

Each entry in acomp_ctx->comp.sg_table->sgl is mapped to a single
PAGE_SIZE buffer in acomp_ctx->comp.buffers[i], and earlier runs overwrite
each entry's sg->length with compressed lengths or negative error codes.
When a batching compressor runs with nr_batch_pages > 1, dst_sg[0].length
is set to nr_batch_pages * PAGE_SIZE (exceeding its PAGE_SIZE buffer),
while dst_sg[1 .. nr_batch_pages - 1].length are not reset to PAGE_SIZE.
If the compressor fails when zc->wb_enabled is true without updating
dst_sg[1 .. nr_batch_pages - 1].length, any entry still holding a stale
compressed length (0 < sg->length < PAGE_SIZE) from a previous call will
skip the PAGE_SIZE fallback and cause zswap_update_entries() to store
stale data from the previous folio.

Each of the nr_batch_pages scatterlist entries in dst_sg needs its length
reset to PAGE_SIZE before crypto_acomp_compress().

> +
> +		/*
> +		 * The per-CPU @zc->comp_ctx->sg_table scatterlists are statically
> +		 * mapped to the per-CPU dst @buffers at pool creation time.
> +		 * There are ZSWAP_MAX_BATCH_SIZE per-CPU SG lists and dst
> +		 * buffers allocated for all compressors.
> +		 */
> +		acomp_request_set_dst_sg(zc->comp_ctx->areq.req, dst_sg, slen);

[Severity: High]
Isn't dst_sg an unterminated scatterlist slice whenever
batch_start + nr_batch_pages < ZSWAP_MAX_BATCH_SIZE?

sg_alloc_table() only sets SG_END on sgl[ZSWAP_MAX_BATCH_SIZE - 1], so
passing dst_sg as req->dst leaves sg_nents(req->dst) equal to
ZSWAP_MAX_BATCH_SIZE - batch_start (4, 3, or 2 instead of nr_batch_pages).
In-tree hardware acomp drivers rely on sg_nents(req->dst):
iaa_comp_acompress() falls back to software deflate whenever
sg_nents(req->dst) > 1 (affecting all order-0 folios and 3 of every 4
pages in a batch), while __qat_bl_sgl_to_bufl() and
hisi_acc_sg_buf_map_to_hw_sgl() walk and DMA-map all sg_nents(req->dst)
entries up to sgl[3] using their sg->length fields, which can still hold a
negative errno such as (unsigned int)-ENOSPC (~4 GiB) left behind by a
prior failed batch.

> +
> +		err =3D crypto_wait_req(crypto_acomp_compress(zc->comp_ctx->areq.req),
> +				      &zc->comp_ctx->areq.wait);
> +
> +		/*
> +		 * If a page cannot be compressed into a size smaller than
> +		 * PAGE_SIZE, save the content as is without a compression, to
> +		 * keep the LRU order of writebacks.  If writeback is disabled,
> +		 * reject the page since it only adds metadata overhead.
> +		 * swap_writeout() will put the page back to the active LRU list
> +		 * in the case.
> +		 */
> +		if (err && !zc->wb_enabled)
> +			goto compress_error;
> +
> +		/*
> +		 * For each output SG list in @acomp_ctx->req->sg_table->sgl,
> +		 * the @sg->length should be set to either the page's compressed
> +		 * length (success), or it's negative value compression error.
> +		 */
> +		for_each_sg(dst_sg, sg, nr_batch_pages, comp_batch_iter) {
> +			if (((int)sg->length <=3D 0) || (sg->length >=3D PAGE_SIZE)) {
> +				if (!zc->wb_enabled) {
> +					if (sg->length =3D=3D PAGE_SIZE)
> +						sg->length =3D -ENOSPC;
> +					else if (WARN_ON_ONCE(!sg->length || sg->length > PAGE_SIZE))
> +						sg->length =3D -EINVAL;
> +					goto compress_error;
> +				}
> +
> +				sg->length =3D PAGE_SIZE;
> +			}
> +		}
>  	}
> =20
> +	return zswap_update_entries(zc);
> =20
> +compress_error:
> +	for_each_sg(dst_sg, sg, nr_batch_pages, comp_batch_iter) {
> +		if ((int)sg->length < 0) {
> +			if ((int)sg->length =3D=3D -ENOSPC)
> +				zswap_reject_compress_poor++;
> +			else
> +				zswap_reject_compress_fail++;
> +		}
> +	}
> =20
> +	return false;
>  }

[Severity: Medium]
Won't evaluating sg->length > PAGE_SIZE on an unsigned int trigger
WARN_ON_ONCE() whenever sg->length holds a negative error code?

Because sg->length is unsigned, a negative error code in sg->length (such
as -ENOSPC from a failed page in a batch) satisfies sg->length > PAGE_SIZE
when !zc->wb_enabled, firing a spurious WARN_ON_ONCE() and overwriting the
error code with -EINVAL so compress_error increments
zswap_reject_compress_fail instead of zswap_reject_compress_poor.
Conversely, if crypto_acomp_compress() returns an early request-level
error in err before writing negative error codes into dst_sg->length,
jumping to compress_error leaves all sg->length values positive and
returns false without incrementing either rejection counter.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120041906.5785=
-1-kanchanapsridhar2026@gmail.com?part=3D8
