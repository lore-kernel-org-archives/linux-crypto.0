Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793243167;
	b=3LgxDql4Ub0BQSM2Qwzub95x+shakoplpQKIlKaSln9ID/xspZlYz0xYLQX/TaBxcx9P
	 9crva32tljDMVtGuXUaRJrvRDdP6l96USTZVknvp2CVI57JbFV6vCM0GlEQtXzPLHlise
	 oZ+nZEwDBILIWiVZNGruNgWCW3940PQeGCuI9Ac2tuoZtkUuN1uksLCIkZ/PRffL1+R72
	 HJQvLK11mVZDybOXuQ4R0V3I0a67Ut8w4S1wcXlG0LEMWf0ISR9LbbyGmioteDlOeRoC1
	 XA4bznM1cFMdnYfeByKBxGgrY/jjPPar/78ixtPsl4EWiVyKPz5hHgquRmPEOXmPMSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793243167;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=RSzM2KzvS9xfH8+rHRrBVo8Vj5bEU/hq1pSIjCpjaUE=;
	b=1JSLAAGB6mIw+fXXkPo6JRn1Z5uFKmUqZmy/lJ69HL/i8DDULLyVqq90+LekdrTB7bWf
	 rZLRk6tkXKhfBAbtt1gNodJN0NCRtIhU4m7gf3m2Y7ms/snuYviOjU5NnnTkLJImcSHOx
	 DN3eYSekl6npk3zaJNcn5YNbxMYconrcBi8kBPcGug63rpboD4t0gnRWIiCUp8v3zrgYA
	 XH/5iXQmv0f/tSDt1PySx9C4WFFY9dB1OdHjjXAl9/bGc2AYhkAx5oSLxkHwhr3bq6xl4
	 SiTqdmHRfixJyu85kc5WtMYo3cVHNzM45NhkJcD9VJyYBzt0ut3ozC+kojrQQM86+Sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NGMuIG1Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9409C606A31C
	for <linux-crypto@vger.kernel.org>; Thu, 29 Oct 2026 03:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NGMuIG1Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 929CD1F01829;
	Thu, 29 Oct 2026 03:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793243166;
	bh=RSzM2KzvS9xfH8+rHRrBVo8Vj5bEU/hq1pSIjCpjaUE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NGMuIG1YQqbnAYVTu9KYZKF/BvXyfuaoTCKjJPapGEKC7I00xA1GosnZg1G7Pq0Sn
	 IGngTX7W8Tx7vVe9AI4TRuJ0ighPFsOkp3jgN7GsRJDHf+sakeb+PT/4FcZx6noFY1
	 Ezpz2TTWyc2J5egtkpGQptw3emLNYL0+1WkJSGvcdq98Ld4RLjADbmFxq3OsRcXerP
	 RyrmnQs+EU5TGHRVdSwVDWb83ETxfpjFbs0KKiLfJssfmAHwsK/3HOIkoPaZL8EdKl
	 ecJ9CaZ0QL+lbWaKO7Rb+4UxKKz9cfNLMBnz9uYlfjEaZZ5TTxBZJe5p7YnoVOD5C7
	 c1RTLf1bzZp7A==
Message-ID: <sashiko-outbox-188659@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 7/8] mm: zswap: Batched zswap_compress() for storing
 large folios in batches.
Reply-To: sashiko-reviews@lists.linux.dev
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>, hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com, chengming.zhou@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, davem@davemloft.net, linux-crypto@vger.kernel.org
Cc: rientjes@google.com, willy@infradead.org, senozhatsky@chromium.org
In-Reply-To: <20261028030503.17923-8-kanchanapsridhar2026@gmail.com>
References: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
 <20261028030503.17923-8-kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 29 Oct 2026 03:06:05 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 6 potential issue(=
s) to consider:
- [Critical] mm: zswap: unclamped nr_batch_pages in zswap_compress() causes=
 OOB and crash
- [High] mm: zswap: zsmalloc handle leak on partial batch failure in zswap_=
compress()
- [High] mm: zswap: invalid and unreset dst scatterlist lengths in zswap_co=
mpress()
- [High] mm: zswap: zswap_cpu_comp_prepare() returns 0 on buffer or sg_tabl=
e alloc fail
- [High] mm: zswap: zswap_compress() reads -EINPROGRESS sg->length for asyn=
c acomp
- [Medium] mm: zswap: zswap_compress() stores PAGE_SIZE outputs when writeb=
ack disabled
--

commit 61c906de6e16dcc53db7f835142f9c05558dca5f
Author: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>

mm: zswap: Batched zswap_compress() for storing large folios in batches.

This commit introduces a batched zswap_compress() implementation using
per-CPU scatterlists and refactors zsmalloc allocation into
zswap_update_entries().

> diff --git a/mm/zswap.c b/mm/zswap.c
> index c8890e8a9b836..4476fb4aeb5fd 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c

[ ... ]

> @@ -944,6 +956,21 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, =
struct hlist_node *node)
>  			goto req_fail;
>  	}
> =20
> +	acomp_ctx->comp.sg_table =3D kmalloc(sizeof(*acomp_ctx->comp.sg_table),=
 GFP_KERNEL);
> +	if (!acomp_ctx->comp.sg_table)
> +		goto req_fail;
> +
> +	if (sg_alloc_table(acomp_ctx->comp.sg_table, pool->compr_batch_size,
> +			   GFP_KERNEL))
> +		goto req_fail;
> +
> +	/*
> +	 * Statically map the per-CPU destination buffers to the per-CPU
> +	 * SG lists; crucial for performance.
> +	 */
> +	for_each_sg(acomp_ctx->comp.sg_table->sgl, sg, pool->compr_batch_size, =
i)
> +		sg_set_buf(sg, acomp_ctx->comp.buffers[i], PAGE_SIZE);
> +
>  	/* Skip the per-CPU request when decompression can use the stack. */
>  	if (acomp_is_async(acomp_ctx->acomp)) {
>  		ret =3D zswap_acomp_req_init(&acomp_ctx->decomp, acomp_ctx->acomp);
> @@ -960,92 +987,161 @@ static int zswap_cpu_comp_prepare(unsigned int cpu=
, struct hlist_node *node)
>  	return ret;
>  }

[Severity: High]
Does zswap_cpu_comp_prepare() return 0 on failure if allocating
acomp_ctx->comp.buffers, acomp_ctx->comp.sg_table, or sg_alloc_table()
fails?

Earlier in zswap_cpu_comp_prepare(), ret is overwritten by
zswap_acomp_req_init():

	ret =3D zswap_acomp_req_init(&acomp_ctx->comp.areq, acomp_ctx->acomp);
	if (ret)
		goto req_fail;

When that call succeeds, ret is 0. If any of the subsequent allocations
for buffers or sg_table fail and jump to req_fail, acomp_ctx_free() tears
down and zeroes acomp_ctx, and zswap_cpu_comp_prepare() returns ret (0) to
the CPU hotplug core, leading to a NULL pointer dereference when zswap
later uses the per-CPU context.

> -static bool zswap_compress(struct folio *folio, long index,
> -			   struct zswap_entry *entry, struct zswap_pool *pool,
> -			   bool wb_enabled)
> +static bool zswap_update_entries(struct zswap_store_context *zc,
> +				 u8 batch_start)
>  {
> -	struct zswap_comp_ctx *comp_ctx;
> -	struct scatterlist input, output;
> -	int comp_ret =3D 0, alloc_ret =3D 0;
> -	unsigned int dlen =3D PAGE_SIZE;
> +	gfp_t gfp =3D GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM | __GFP_MOVABL=
E;
> +	u8 i, batch_iter, comp_batch_iter;
>  	unsigned long handle;
> -	gfp_t gfp;
> +	unsigned int dlen;
>  	u8 *dst;
> -	bool mapped =3D false;
> -
> -	comp_ctx =3D &raw_cpu_ptr(pool->acomp_ctx)->comp;
> -	mutex_lock(&comp_ctx->areq.mutex);
> -
> -	dst =3D comp_ctx->buffers[0];
> -	sg_init_table(&input, 1);
> -	sg_set_folio(&input, folio, PAGE_SIZE, index * PAGE_SIZE);
> -
> -	sg_init_one(&output, dst, PAGE_SIZE);
> -	acomp_request_set_params(comp_ctx->areq.req, &input, &output,
> -				 PAGE_SIZE, dlen);
> =20
>  	/*
> -	 * it maybe looks a little bit silly that we send an asynchronous reque=
st,
> -	 * then wait for its completion synchronously. This makes the process l=
ook
> -	 * synchronous in fact.
> -	 * Theoretically, acomp supports users send multiple acomp requests in =
one
> -	 * acomp instance, then get those requests done simultaneously. but in =
this
> -	 * case, zswap actually does store and load page by page, there is no
> -	 * existing method to send the second page before the first page is done
> -	 * in one thread doing zswap.
> -	 * but in different threads running on different cpu, we have different
> -	 * acomp instance, and compression and decompression use separate
> -	 * requests, so multiple threads can do (de)compression in parallel.
> +	 * For each output SG list in @acomp_ctx->req->sg_table->sgl,
> +	 * the @sg->length should be set to either the page's compressed
> +	 * length (success), or it's negative value compression error.
>  	 */
> -	comp_ret =3D crypto_wait_req(crypto_acomp_compress(comp_ctx->areq.req),
> -				   &comp_ctx->areq.wait);
> -	dlen =3D comp_ctx->areq.req->dlen;
> -	if (!comp_ret) {
> -		if (dlen =3D=3D PAGE_SIZE)
> -			comp_ret =3D -ENOSPC;
> -		else if (WARN_ON_ONCE(!dlen || dlen > PAGE_SIZE))
> -			comp_ret =3D -EINVAL;
> +	for (comp_batch_iter =3D 0; comp_batch_iter < zc->nr_batch_pages;
> +	     ++comp_batch_iter) {
> +		batch_iter =3D batch_start + comp_batch_iter;
> +		dlen =3D zc->entries[batch_iter]->length;
> +		handle =3D zs_malloc(zc->zs_pool, dlen, gfp, zc->nid);
> +
> +		if (unlikely(IS_ERR_VALUE(handle))) {
> +			if (PTR_ERR((void *)handle) =3D=3D -ENOSPC)
> +				zswap_reject_compress_poor++;
> +			else
> +				zswap_reject_alloc_fail++;
> +
> +			for (i =3D 0; i < comp_batch_iter; ++i)
> +				zs_free(zc->zs_pool, zc->entries[batch_start + i]->handle);
> +
> +			return false;
> +		}
> +
> +		zc->entries[batch_iter]->handle =3D handle;
> +
> +		if (likely(dlen < PAGE_SIZE)) {
> +			dst =3D zc->comp_ctx->buffers[comp_batch_iter];
> +			zs_obj_write(zc->zs_pool, handle, dst, dlen);
> +		} else {
> +			dst =3D kmap_local_folio(zc->folio,
> +					(zc->folio_start + batch_iter) * PAGE_SIZE);
> +			zs_obj_write(zc->zs_pool, handle, dst, dlen);
> +			kunmap_local(dst);
> +		}
>  	}
> =20
> +	return true;
> +}
> +
> +/*
> + * zswap_compress() batching implementation for sequential and batching
> + * compressors.
> + *
> + * Description:
> + * =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> + * Compress multiple @nr_pages in @folio starting from the @folio_start =
index
> + * in batches of @nr_batch_pages; the latter representing the lesser of =
the
> + * @nr_pages to be batch compressed and the compressor's batch size.
> + *
> + * @nr_pages can be in (1, ZSWAP_MAX_BATCH_SIZE] even if the compressor =
does not
> + * support batching.
> + *
> + * If @nr_batch_pages is 1, each page is processed sequentially.
> + *
> + * If @nr_batch_pages is > 1, the compressor may use batching to optimize
> + * compression.
> + */
> +static bool zswap_compress(struct zswap_store_context *zc)
> +{
> +	u8 batch_start, comp_batch_iter, batch_iter;
> +	struct scatterlist *sg;
> +	bool ret;
> +	int err;
> +
>  	/*
> -	 * If a page cannot be compressed into a size smaller than PAGE_SIZE,
> -	 * save the content as is without a compression, to keep the LRU order
> -	 * of writebacks.  If writeback is disabled, reject the page since it
> -	 * only adds metadata overhead.  swap_writeout() will put the page back
> -	 * to the active LRU list in the case.
> +	 * Compress the @nr_pages in @folio starting at index @folio_start
> +	 * in batches of @nr_batch_pages.
>  	 */
> -	if (comp_ret) {
> -		if (!wb_enabled)
> -			goto unlock;
> -		comp_ret =3D 0;
> -		dlen =3D PAGE_SIZE;
> -		dst =3D kmap_local_folio(folio, index * PAGE_SIZE);
> -		mapped =3D true;
> -	}
> +	for (batch_start =3D 0; batch_start < zc->nr_pages;
> +	     batch_start +=3D zc->nr_batch_pages) {
> +		/*
> +		 * Send @nr_batch_pages to crypto_acomp for compression:
> +		 *
> +		 * These pages are in @folio's range of indices in the interval
> +		 *     [@folio_start + @batch_start,
> +		 *      @folio_start + @batch_start + @nr_batch_pages).
> +		 *
> +		 * @slen indicates the total source length bytes for
> +		 * @nr_batch_pages.
> +		 *
> +		 * The source folio pages in the batch are directly submitted to
> +		 * crypto_acomp via acomp_request_set_src_folio().
> +		 *
> +		 * The pool's compressor batch size is at least @nr_batch_pages,
> +		 * hence the acomp_ctx has at least @nr_batch_pages dst @buffers.
> +		 */
> +		acomp_request_set_src_folio(zc->comp_ctx->areq.req, zc->folio,
> +				(zc->folio_start + batch_start) * PAGE_SIZE,
> +				zc->slen);
> +
> +		zc->comp_ctx->sg_table->sgl->length =3D zc->slen;
> +
> +		/*
> +		 * The per-CPU @zc->comp_ctx->sg_table scatterlists are statically
> +		 * mapped to the per-CPU dst @buffers at pool creation time.
> +		 */
> +		acomp_request_set_dst_sg(zc->comp_ctx->areq.req,
> +					 zc->comp_ctx->sg_table->sgl, zc->slen);

[Severity: High]
How are the destination scatterlist entry lengths in
zc->comp_ctx->sg_table->sgl maintained across batches when
zc->nr_batch_pages > 1?

In zswap_cpu_comp_prepare(), each acomp_ctx->comp.buffers[i] is allocated
with size PAGE_SIZE and mapped to sgl[i] via sg_set_buf(..., PAGE_SIZE).

Here in zswap_compress(), setting zc->comp_ctx->sg_table->sgl->length =3D
zc->slen sets sgl[0].length to zc->nr_batch_pages * PAGE_SIZE, which
exceeds the single PAGE_SIZE allocation backing buffers[0] when
zc->nr_batch_pages > 1.

At the same time, sgl[1 .. zc->nr_batch_pages - 1].length are never reset
to PAGE_SIZE before calling crypto_acomp_compress(). After the first batch
completes (or after a batch fails and jumps to compress_error), those SG
entries retain their previous compressed lengths or negative error codes on
subsequent requests.

> +
> +		err =3D crypto_wait_req(crypto_acomp_compress(zc->comp_ctx->areq.req),
> +				      &zc->comp_ctx->areq.wait);
> =20
> -	gfp =3D GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM | __GFP_MOVABLE;
> -	handle =3D zs_malloc(pool->zs_pool, dlen, gfp, folio_nid(folio));
> -	if (IS_ERR_VALUE(handle)) {
> -		alloc_ret =3D PTR_ERR((void *)handle);
> -		goto unlock;
> +		/*
> +		 * If a page cannot be compressed into a size smaller than
> +		 * PAGE_SIZE, save the content as is without a compression, to
> +		 * keep the LRU order of writebacks.  If writeback is disabled,
> +		 * reject the page since it only adds metadata overhead.
> +		 * swap_writeout() will put the page back to the active LRU list
> +		 * in the case.
> +		 *
> +		 * It is assumed that any compressor that sets the output length
> +		 * to 0 or a value >=3D PAGE_SIZE will also return a negative
> +		 * error status in @err; i.e, will not return a successful
> +		 * compression status in @err in this case.
> +		 */
> +		if (unlikely(err && !zc->wb_enabled))
> +			goto compress_error;
> +
> +		for_each_sg(zc->comp_ctx->sg_table->sgl, sg,
> +			    zc->nr_batch_pages, comp_batch_iter) {
> +			batch_iter =3D batch_start + comp_batch_iter;
> +			if (unlikely(sg->length <=3D 0 || sg->length >=3D PAGE_SIZE))
> +				sg->length =3D PAGE_SIZE;
> +
> +			zc->entries[batch_iter]->length =3D sg->length;
> +		}

[Severity: High]
What happens in zswap_compress() when using an asynchronous non-segmented
acomp driver?

In crypto/acompress.c:crypto_acomp_compress(), when req->unit_size =3D=3D
req->slen and !crypto_acomp_req_seg(tfm), the fast path runs:

	if (likely((req->unit_size =3D=3D req->slen) && acomp_request_issg(req) &&
		    !crypto_acomp_req_seg(tfm) && !acomp_req_on_stack(req))) {
		int err =3D tfm->compress(req);

		req->dst->length =3D unlikely(err) ? err : req->dlen;
		return err;
	}

When tfm->compress(req) is asynchronous and returns -EINPROGRESS or -EBUSY,
req->dst->length (sg->length) is set to -EINPROGRESS before
crypto_wait_req() waits for completion, and nothing updates sg->length to
req->dlen when the request finishes.

Wouldn't zswap_compress() then see sg->length =3D=3D (unsigned int)-EINPROG=
RESS
after crypto_wait_req() returns 0, clamp sg->length to PAGE_SIZE, and store
every page uncompressed instead of using req->dlen?

[Severity: Medium]
Also, is the assumption that compressors never return 0 when the output
length is PAGE_SIZE true for software compressors?

Software compressors such as lz4 and zstd return 0 with dlen =3D=3D PAGE_SI=
ZE
when a page compresses to exactly PAGE_SIZE bytes. Previously,
zswap_compress() checked:

	if (!comp_ret) {
		if (dlen =3D=3D PAGE_SIZE)
			comp_ret =3D -ENOSPC;
		else if (WARN_ON_ONCE(!dlen || dlen > PAGE_SIZE))
			comp_ret =3D -EINVAL;
	}

Without that check, when err =3D=3D 0 and sg->length =3D=3D PAGE_SIZE with
!zc->wb_enabled, won't zswap_compress() and zswap_update_entries() allocate
a PAGE_SIZE object in zsmalloc and store the uncompressed page even though
writeback is disabled?

> +
> +		ret =3D zswap_update_entries(zc, batch_start);
> +		if (unlikely(!ret))
> +			return false;
>  	}

[ ... ]

> @@ -1681,11 +1785,10 @@ static bool zswap_store_pages(struct zswap_store_=
context *zc,
>  	return true;
> =20
>  store_pages_failed:
> -	for (i =3D store_fail_idx; i < zc->nr_pages; ++i) {
> -		if (!IS_ERR_VALUE(zc->entries[i]->handle))
> -			zs_free(pool->zs_pool, zc->entries[i]->handle);
> -	}
> +	for (i =3D store_fail_idx; i < zc->nr_pages; ++i)
> +		zs_free(pool->zs_pool, zc->entries[i]->handle);
> =20
> +compress_failed:
>  	zswap_entries_cache_free_batch(&zc->entries[store_fail_idx],
>  				       zc->nr_pages - store_fail_idx);
> =20

[Severity: High]
Does this leak zsmalloc handles in zc->entries[0 .. batch_start - 1] when a
later sub-batch (batch_start > 0) fails in zswap_compress()?

For example, with a non-batching compressor (zc->nr_batch_pages =3D=3D 1) a=
nd a
large folio (zc->nr_pages =3D=3D 8), zswap_compress() iterates batch_start =
from
0 to zc->nr_pages - 1, calling zswap_update_entries(zc, batch_start) on
each iteration.

If sub-batch 0 succeeds (allocating zc->entries[0]->handle via zs_malloc())
and a later sub-batch at batch_start > 0 fails either in
crypto_acomp_compress() (with !zc->wb_enabled) or in zs_malloc() inside
zswap_update_entries(), zswap_update_entries() only frees handles in the
current sub-batch [batch_start, batch_start + comp_batch_iter):

	for (i =3D 0; i < comp_batch_iter; ++i)
		zs_free(zc->zs_pool, zc->entries[batch_start + i]->handle);

zswap_store_pages() then jumps to compress_failed, which skips the
zs_free() loop at store_pages_failed and frees zc->entries[], leaking all
zsmalloc handles allocated in [0, batch_start).

> @@ -1757,6 +1860,10 @@ bool zswap_store(struct folio *folio)
>  	store_batch_size =3D (pool->compr_batch_size > 1) ?
>  			    pool->compr_batch_size : ZSWAP_MAX_BATCH_SIZE;
> =20
> +	zc.nr_batch_pages =3D pool->compr_batch_size;
> +	zc.slen =3D zc.nr_batch_pages * PAGE_SIZE;
> +	zc.zs_pool =3D pool->zs_pool;
> +
>  	for (start =3D 0; start < nr_pages; start +=3D store_batch_size) {
>  		end =3D min(start + store_batch_size, nr_pages);
> =20

[Severity: Critical]
What happens in zswap_store() -> zswap_store_pages() -> zswap_compress()
when pool->compr_batch_size > 1 and the folio (or trailing batch end -
start) has fewer pages than pool->compr_batch_size, such as an order-0
folio where nr_pages =3D=3D 1?

In zswap_store(), zc.nr_batch_pages is set to pool->compr_batch_size and
zc.slen is set to zc.nr_batch_pages * PAGE_SIZE, while zswap_store_pages()
sets zc->nr_pages =3D end - start and only allocates zc->nr_pages entries in
zc->entries[0 .. zc->nr_pages - 1].

Because zc->nr_batch_pages and zc->slen are never clamped to zc->nr_pages,
when zc->nr_pages < zc->nr_batch_pages:

1. acomp_request_set_src_folio() in zswap_compress() maps zc->slen bytes,
   reading past the end of zc->folio.

2. Both the for_each_sg() loop in zswap_compress() and the loop in
   zswap_update_entries() iterate comp_batch_iter up to zc->nr_batch_pages,
   dereferencing zc->entries[batch_iter] for batch_iter >=3D zc->nr_pages. =
On
   the first batch, zc->entries[zc->nr_pages] is NULL (causing a NULL
   pointer dereference); on a trailing partial batch after a full batch, it
   contains stale zswap_entry pointers from the previous batch (corrupting
   live entries and leaking the newly allocated zsmalloc handles).

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261028030503.1792=
3-1-kanchanapsridhar2026@gmail.com?part=3D7
