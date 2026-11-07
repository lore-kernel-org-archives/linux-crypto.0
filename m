Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794036312;
	b=ccaMre6Wp3RumgKFb6Ts2qyFKxulgIzyHY0RjsZeT9omHPPrzqVbo3IKMByOGsWq3cXI
	 Jf7F850Qn3cdmh0Yuv8FyB344OE96mlQO8trOt8K6PO6N+nMH7NellW1T0rp3+ziKnZ4s
	 vijNc20fuAWM4NPhtKBJML893EUkzVEjyENzAylftBb73KgU7ijpibp9moguhmFt+0o3A
	 4Qbl3DPD8iXrOH0dQ8ZsVUw9Qoy2klbof6pwpTCv4o8iaB/OKuKA815VX41JkoJzvGz4X
	 czE5Sk7q8ChQFhQVs6S0XWYaboRDTbfjGoD0Xbrh8WGIzrT6nZOk0G54q1P21sth3XQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794036312;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Q/BnVNvWJBWN8gIYT+KV/HWUVqg2WBwCQRGFUzyrbeE=;
	b=gNbwz7cfL++a65B6j7/PtiFt6cv6eCarWqWmK3vAP1O8uJeNlRT94D4Fi3YrbuVuHKAc
	 uQJWKjA3TNaYBRVvC/7rh62nD1B/n0nN7NcYf06AUM7UA2K9YCM8X8hSVKkKiDmO3916D
	 xrs/DBk9LJ98ITvp/BaR9LXW69CSChYyXFiBjBK2c6lx/FDdyRRaDs59NLMsE3IJ4/E4a
	 SkTB6dCUqzgGJXZ29G9c/S3o4b/Fm9VmOEjQezTb8TlINXfqjYp5VZr6hix38mol16t7T
	 Nu65DTx4lfTk9If5ACX183AGerpLWrCaIzZM/qZA/e3oiYdekpyKR2FWtbHfylxgmMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jmvCllkf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35F80606A32F
	for <linux-crypto@vger.kernel.org>; Sat,  7 Nov 2026 07:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jmvCllkf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 266BB1F0089F;
	Sat,  7 Nov 2026 07:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794036312;
	bh=Q/BnVNvWJBWN8gIYT+KV/HWUVqg2WBwCQRGFUzyrbeE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jmvCllkfdsrF2NhWVBiWXaxoCk12Mfad/LDdzOWbzSYahK1g4CONW6WJzTO+fPnvg
	 Q4zPLbpII9E8Mn6IPnkrVgbHgeDBksLsi3HGoNJ5Qiu3RTckVC39LyIuZVbPMIv1DR
	 VFVBYgItdtP48DkfYFhl9TZ4RYWZq0PjQJ+ITFM9cNRVc4AtPtrhqkV6Vh97DJBO7d
	 6XMLYyaMNf0OU4eLgfOnZq1nn1Ip0hzieNf3MzDUoDOfzKrs0eQ2iw+/V7vpVCSBzc
	 uj7tthUR44Jk1LLCQ/dtYz4aAGdfvn+EBRm59/S9DsHp9yGIcb5LMxDe8ph5BT9wt9
	 7koHoQeoIVWuw==
Message-ID: <sashiko-outbox-202714@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 8/8] mm: zswap: Batched zswap_compress() for storing
 large folios in batches.
Reply-To: sashiko-reviews@lists.linux.dev
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>, hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com, chengming.zhou@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, davem@davemloft.net, linux-crypto@vger.kernel.org
Cc: rientjes@google.com, willy@infradead.org, senozhatsky@chromium.org
In-Reply-To: <20261106072412.7909-9-kanchanapsridhar2026@gmail.com>
References: <20261106072412.7909-1-kanchanapsridhar2026@gmail.com>
 <20261106072412.7909-9-kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 07 Nov 2026 07:25:09 +0000
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
- [High] mm: zswap: corrupted and unterminated dst scatterlist in
  zswap_compress()
- [Medium] mm: zswap: unclamped nr_batch_pages on remainder batch in
  zswap_compress()
- [Medium] mm: zswap: unsigned sg->length check mishandles negative
  errors in zswap_compress()
--

commit 212f5740068394b4c82b7b1e5452b1ac6625322f
Author: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>

mm: zswap: Batched zswap_compress() for storing large folios in batches.

This commit replaces per-page zswap_compress() calls with a batched
implementation that compresses up to ZSWAP_MAX_BATCH_SIZE pages using a
per-CPU scatterlist table and updates the batch entries in
zswap_update_entries().

> diff --git a/mm/zswap.c b/mm/zswap.c
> index 5ef1ae67e67a9..45fd8dfaf916d 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c

[ ... ]

> @@ -898,6 +914,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, s=
truct hlist_node *node)

[ ... ]

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

[ ... ]

> +static bool zswap_compress(struct zswap_store_context *zc)
> +{
> +	u8 batch_start, comp_batch_iter;
> +	struct scatterlist *sg, *dst_sg;
> +	int err;
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
> +	 * @nr_batch_pages is constrained by the per-CPU comp_ctx's compressor
> +	 * batch size and the @zc->nr_pages in this store batch. @slen indicates
> +	 * the total source length bytes for @nr_batch_pages.
>  	 */
> +	zc->nr_batch_pages =3D min(zc->comp_ctx->compr_batch_size, zc->nr_pages=
);
> +	zc->slen =3D zc->nr_batch_pages * PAGE_SIZE;
> =20
>  	/*
> +	 * Compress the @nr_pages in @folio starting at index @folio_start
> +	 * in batches of @nr_batch_pages.
>  	 */
> +	for (batch_start =3D 0; batch_start < zc->nr_pages;
> +	     batch_start +=3D zc->nr_batch_pages) {

[Severity: Medium]
Can zc->nr_batch_pages exceed the remaining pages in the store batch on the
final loop iteration?

zc->nr_batch_pages and zc->slen are computed once before the loop instead
of being clamped to zc->nr_pages - batch_start on each iteration.  If a
compressor has a compr_batch_size that does not evenly divide zc->nr_pages
(for example, compr_batch_size =3D=3D 3 with zc->nr_pages =3D=3D 4), the fi=
nal
iteration reads past the end of the folio batch and walks past the SG_END
terminator of zc->comp_ctx->sg_table->sgl in for_each_sg(), causing a NULL
pointer dereference when sg_next() returns NULL.

> +		/*
> +		 * Send @nr_batch_pages to crypto_acomp for compression:
> +		 *
> +		 * These pages are in @folio's range of indices in the interval
> +		 *     [@folio_start + @batch_start,
> +		 *      @folio_start + @batch_start + @nr_batch_pages).
> +		 *
> +		 * The source folio pages in the batch are directly submitted to
> +		 * crypto_acomp via acomp_request_set_src_folio().
> +		 */
> +		acomp_request_set_src_folio(zc->comp_ctx->areq.req, zc->folio,
> +				(zc->folio_start + batch_start) * PAGE_SIZE,
> +				zc->slen);
> +
> +		dst_sg =3D zc->comp_ctx->sg_table->sgl + batch_start;
> +		dst_sg->length =3D zc->slen;
> +
> +		/*
> +		 * The per-CPU @zc->comp_ctx->sg_table scatterlists are statically
> +		 * mapped to the per-CPU dst @buffers at pool creation time.
> +		 * There are ZSWAP_MAX_BATCH_SIZE per-CPU SG lists and dst
> +		 * buffers allocated for all compressors.
> +		 */
> +		acomp_request_set_dst_sg(zc->comp_ctx->areq.req,
> +					 dst_sg, zc->slen);

[Severity: High]
Does setting dst_sg->length =3D zc->slen corrupt the per-CPU scatterlist ta=
ble
in zc->comp_ctx->sg_table?

In zswap_cpu_comp_prepare(), each entry in sg_table->sgl is mapped to a
separate PAGE_SIZE buffer and only sgl[ZSWAP_MAX_BATCH_SIZE - 1] has SG_END
set.  During compression, each entry's sg->length is overwritten with the
compressed size or a negative error code.

When zc->nr_batch_pages > 1, setting dst_sg->length =3D zc->slen tells the
compressor that dst_sg[0]'s single PAGE_SIZE buffer is nr_batch_pages *
PAGE_SIZE bytes long, while dst_sg[1 .. nr_batch_pages - 1].length are never
reset to PAGE_SIZE and retain stale lengths or negative error codes from the
previous batch.  If crypto_acomp_compress() fails while zc->wb_enabled is
true without updating every entry's sg->length, any entry still holding a
stale length in (0, PAGE_SIZE) bypasses the sg->length >=3D PAGE_SIZE check
and causes zswap_update_entries() to store stale data from the previous
folio.

In addition, because SG_END is only set on sgl[3], passing dst_sg =3D sgl +
batch_start leaves 4 - batch_start entries linked in req->dst.  Hardware
acomp drivers that check sg_nents(req->dst) or DMA-map every entry in the
scatterlist walk past the current batch into trailing entries whose
sg->length may still hold PAGE_SIZE or (unsigned int)-ENOSPC (0xffffffe4)
from an earlier failed compression.

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
> =20
> +		/*
> +		 * For each output SG list in @acomp_ctx->req->sg_table->sgl,
> +		 * the @sg->length should be set to either the page's compressed
> +		 * length (success), or it's negative value compression error.
> +		 */
> +		for_each_sg(dst_sg, sg, zc->nr_batch_pages, comp_batch_iter) {
> +
> +			if (sg->length <=3D 0 || sg->length >=3D PAGE_SIZE) {
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
> +	for_each_sg(dst_sg, sg, zc->nr_batch_pages, comp_batch_iter) {
> +		if ((int)sg->length < 0) {
> +			if ((int)sg->length =3D=3D -ENOSPC)
> +				zswap_reject_compress_poor++;
> +			else
> +				zswap_reject_compress_fail++;
> +		}
> +	}
> +
> +	return false;
>  }

[Severity: Medium]
Does checking sg->length without casting to int mishandle negative
compression error codes when !zc->wb_enabled?

scatterlist.length is an unsigned int, so a negative error code stored in
sg->length (such as -ENOSPC) is never <=3D 0 and instead triggers
WARN_ON_ONCE(!sg->length || sg->length > PAGE_SIZE) and overwrites
sg->length with -EINVAL before compress_error: checks for -ENOSPC.
Conversely, if crypto_acomp_compress() returns an error before setting
negative values in sg->length, jumping directly to compress_error: finds no
entries with (int)sg->length < 0 and increments neither rejection counter.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106072412.7909=
-1-kanchanapsridhar2026@gmail.com?part=3D8
