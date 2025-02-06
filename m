Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF43319B5B1
	for <linux-crypto@vger.kernel.org>; Thu,  6 Feb 2025 19:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738869049; cv=none; b=HzS7LEv8CijyfvgKdV1XTv6amO4DDT8UHs2tg7HkjRMCAhKBAdf2U9fxO0K8/uV+ix0ChfLb4dLwlJ95+OK51UT0F15R5bTQUXiZyWyS9TkR/7ZqrLuTGWRUrhlgFr96J0Xg7MTxc7yYxhrpO7JV9VFpmWA9SNUSRii12Crv+b8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738869049; c=relaxed/simple;
	bh=OcP6yFgSgwbMnPAxk6X9sF7CE2HGeITDwyHQH/HMN5E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UotIzs6Ia92f6MFjAI6hGboGiXxAkZPoFmUQtI9tfxlUJ4QFpTONSbxTeHDdYHOT5Mi8q62vrMw1iSnrinvdFam3NWAjNu7TsutnDlTzvuheN7osRkzIH2qnxU+ehE5FN+Gw4f0tHiXJLHkTzuiSUp7ewix1d8glXtzytb4ZbyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mUJyifr9; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mUJyifr9"
Date: Thu, 6 Feb 2025 19:10:33 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1738869039;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HNnqh3naAnkb0jziaoULO1jiPfvp8Y4Xgu79YXRNMZE=;
	b=mUJyifr91pvsdyORJCqUrMLdn9rnWMZw6lXLOfaMoTsHV4qUiLmBeFLXWEv5J/7navMYOs
	Taq2/r0F4PhCkKPZjOuHRja7jjAFphwuPyzf7Bmj9FfUPZ0ZrkaHfH968/M1opw/9GpdqK
	83CDmSdZ08bw5WrX5hZt1M4WSKn11Lg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org,
	nphamcs@gmail.com, chengming.zhou@linux.dev, usamaarif642@gmail.com,
	ryan.roberts@arm.com, 21cnbao@gmail.com, akpm@linux-foundation.org,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net, clabbe@baylibre.com, ardb@kernel.org,
	ebiggers@google.com, surenb@google.com, kristen.c.accardi@intel.com,
	wajdi.k.feghali@intel.com, vinodh.gopal@intel.com
Subject: Re: [PATCH v6 15/16] mm: zswap: Compress batching with Intel IAA in
 zswap_store() of large folios.
Message-ID: <Z6UJKTCkffZ93us5@google.com>
References: <20250206072102.29045-1-kanchana.p.sridhar@intel.com>
 <20250206072102.29045-16-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250206072102.29045-16-kanchana.p.sridhar@intel.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Feb 05, 2025 at 11:21:01PM -0800, Kanchana P Sridhar wrote:
> zswap_compress_folio() is modified to detect if the pool's acomp_ctx has
> more than one "nr_reqs", which will be the case if the cpu onlining code
> has allocated multiple batching resources in the acomp_ctx. If so, it means
> compress batching can be used with a batch-size of "acomp_ctx->nr_reqs".
> 
> If compress batching can be used, zswap_compress_folio() will invoke the
> newly added zswap_batch_compress() procedure to compress and store the
> folio in batches of "acomp_ctx->nr_reqs" pages.
> 
> With Intel IAA, the iaa_crypto driver will compress each batch of pages in
> parallel in hardware.
> 
> Hence, zswap_batch_compress() does the same computes for a batch, as
> zswap_compress() does for a page; and returns true if the batch was
> successfully compressed/stored, and false otherwise.
> 
> If the pool does not support compress batching, or the folio has only one
> page, zswap_compress_folio() calls zswap_compress() for each individual
> page in the folio, as before.
> 
> Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> ---
>  mm/zswap.c | 122 +++++++++++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 113 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 6563d12e907b..f1cba77eda62 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -985,10 +985,11 @@ static void acomp_ctx_put_unlock(struct crypto_acomp_ctx *acomp_ctx)
>  	mutex_unlock(&acomp_ctx->mutex);
>  }
>  
> +/* The per-cpu @acomp_ctx mutex should be locked/unlocked in the caller. */

Please use lockdep assertions rather than comments for internal locking rules.

>  static bool zswap_compress(struct page *page, struct zswap_entry *entry,
> -			   struct zswap_pool *pool)
> +			   struct zswap_pool *pool,
> +			   struct crypto_acomp_ctx *acomp_ctx)
>  {
> -	struct crypto_acomp_ctx *acomp_ctx;
>  	struct scatterlist input, output;
>  	int comp_ret = 0, alloc_ret = 0;
>  	unsigned int dlen = PAGE_SIZE;
> @@ -998,7 +999,6 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
>  	gfp_t gfp;
>  	u8 *dst;
>  
> -	acomp_ctx = acomp_ctx_get_cpu_lock(pool);
>  	dst = acomp_ctx->buffers[0];
>  	sg_init_table(&input, 1);
>  	sg_set_page(&input, page, PAGE_SIZE, 0);
> @@ -1051,7 +1051,6 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
>  	else if (alloc_ret)
>  		zswap_reject_alloc_fail++;
>  
> -	acomp_ctx_put_unlock(acomp_ctx);
>  	return comp_ret == 0 && alloc_ret == 0;
>  }
>  
> @@ -1509,20 +1508,125 @@ static void shrink_worker(struct work_struct *w)
>  * main API
>  **********************************/
>  
> +/* The per-cpu @acomp_ctx mutex should be locked/unlocked in the caller. */
> +static bool zswap_batch_compress(struct folio *folio,
> +				 long index,
> +				 unsigned int batch_size,
> +				 struct zswap_entry *entries[],
> +				 struct zswap_pool *pool,
> +				 struct crypto_acomp_ctx *acomp_ctx)
> +{
> +	int comp_errors[ZSWAP_MAX_BATCH_SIZE] = { 0 };
> +	unsigned int dlens[ZSWAP_MAX_BATCH_SIZE];
> +	struct page *pages[ZSWAP_MAX_BATCH_SIZE];
> +	unsigned int i, nr_batch_pages;
> +	bool ret = true;
> +
> +	nr_batch_pages = min((unsigned int)(folio_nr_pages(folio) - index), batch_size);
> +
> +	for (i = 0; i < nr_batch_pages; ++i) {
> +		pages[i] = folio_page(folio, index + i);
> +		dlens[i] = PAGE_SIZE;
> +	}
> +
> +	/*
> +	 * Batch compress @nr_batch_pages. If IAA is the compressor, the
> +	 * hardware will compress @nr_batch_pages in parallel.
> +	 */

Please do not specifically mention IAA in zswap.c, as batching could be
supported in the future by other compressors.

> +	ret = crypto_acomp_batch_compress(
> +		acomp_ctx->reqs,
> +		NULL,
> +		pages,
> +		acomp_ctx->buffers,
> +		dlens,
> +		comp_errors,
> +		nr_batch_pages);

Does crypto_acomp_batch_compress() not require calling
crypto_wait_req()?

> +
> +	if (ret) {
> +		/*
> +		 * All batch pages were successfully compressed.
> +		 * Store the pages in zpool.
> +		 */
> +		struct zpool *zpool = pool->zpool;
> +		gfp_t gfp = __GFP_NORETRY | __GFP_NOWARN | __GFP_KSWAPD_RECLAIM;
> +
> +		if (zpool_malloc_support_movable(zpool))
> +			gfp |= __GFP_HIGHMEM | __GFP_MOVABLE;
> +
> +		for (i = 0; i < nr_batch_pages; ++i) {
> +			unsigned long handle;
> +			char *buf;
> +			int err;
> +
> +			err = zpool_malloc(zpool, dlens[i], gfp, &handle);
> +
> +			if (err) {
> +				if (err == -ENOSPC)
> +					zswap_reject_compress_poor++;
> +				else
> +					zswap_reject_alloc_fail++;
> +
> +				ret = false;
> +				break;
> +			}
> +
> +			buf = zpool_map_handle(zpool, handle, ZPOOL_MM_WO);
> +			memcpy(buf, acomp_ctx->buffers[i], dlens[i]);
> +			zpool_unmap_handle(zpool, handle);
> +
> +			entries[i]->handle = handle;
> +			entries[i]->length = dlens[i];
> +		}
> +	} else {
> +		/* Some batch pages had compression errors. */
> +		for (i = 0; i < nr_batch_pages; ++i) {
> +			if (comp_errors[i]) {
> +				if (comp_errors[i] == -ENOSPC)
> +					zswap_reject_compress_poor++;
> +				else
> +					zswap_reject_compress_fail++;
> +			}
> +		}
> +	}

This function is awfully close to zswap_compress(). It's essentially a
vectorized version and uses crypto_acomp_batch_compress() instead of
crypto_acomp_compress().

My questions are:
- Can we use crypto_acomp_batch_compress() for the non-batched case as
  well to unify the code? Does it cause any regressions?

- If we have to use different compressions APIs, can we at least reuse
  the rest of the code? We can abstract the compression call into a
  helper that chooses the appropriate API based on the batch size. The
  rest should be the same AFAICT.

> +
> +	return ret;
> +}
> +
>  static bool zswap_compress_folio(struct folio *folio,
>  				 struct zswap_entry *entries[],
>  				 struct zswap_pool *pool)
>  {
>  	long index, nr_pages = folio_nr_pages(folio);
> +	struct crypto_acomp_ctx *acomp_ctx;
> +	unsigned int batch_size;
> +	bool ret = true;
>  
> -	for (index = 0; index < nr_pages; ++index) {
> -		struct page *page = folio_page(folio, index);
> +	acomp_ctx = acomp_ctx_get_cpu_lock(pool);
> +	batch_size = acomp_ctx->nr_reqs;
> +
> +	if ((batch_size > 1) && (nr_pages > 1)) {
> +		for (index = 0; index < nr_pages; index += batch_size) {
> +
> +			if (!zswap_batch_compress(folio, index, batch_size,
> +						  &entries[index], pool, acomp_ctx)) {
> +				ret = false;
> +				goto unlock_acomp_ctx;
> +			}
> +		}
> +	} else {
> +		for (index = 0; index < nr_pages; ++index) {
> +			struct page *page = folio_page(folio, index);
>  
> -		if (!zswap_compress(page, entries[index], pool))
> -			return false;
> +			if (!zswap_compress(page, entries[index], pool, acomp_ctx)) {
> +				ret = false;
> +				goto unlock_acomp_ctx;
> +			}
> +		}
>  	}
>  
> -	return true;
> +unlock_acomp_ctx:
> +	acomp_ctx_put_unlock(acomp_ctx);
> +	return ret;
>  }
>  
>  /*
> -- 
> 2.27.0
> 
