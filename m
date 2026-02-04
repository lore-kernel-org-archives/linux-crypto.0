Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEF221D63F0
	for <linux-crypto@vger.kernel.org>; Wed,  4 Feb 2026 16:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770224265; cv=none; b=np3kh900dz57FHSFsP8ylr6w9ozltradmj/Z4h0O9z1SyjhStyfJoLtR6AEuDkgAVKmroX3zn5p7kM5FV1FLTjQT0ycQw0THpMiuiV9iJruhLACDVXVsh8kyYmhC4pdNk9vBhDJrd/aK1bJMJPaijUQcASgNF3JpcHkovBxmFHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770224265; c=relaxed/simple;
	bh=G1IkjFMxJESmPPI9gAE0P6f0Lb1MvhzaPyzsBavYPeQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mA7isPfaa8KsTWQo3ZMXgWfNXRCCsA5GdP3q4jTPBkzb7PheElqdiCXuVtBGJkSA9ZbmR0/vHLy5e4qDfdR1sOmEQP2sbRCNuqbZ5Y7l0dtTz1PjMPxs4IdAV32/yHf8+dMcSgoVYiyin4ym5AstrTHmSXsaPEv4TMs9HOQ8rzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=h0vWfW4E; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="h0vWfW4E"
Date: Wed, 4 Feb 2026 16:57:35 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770224262;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cx+x6G+SfQWLjevinHfo/G9XD5zagVRglZJCduB24h8=;
	b=h0vWfW4E1lCJpCcaT7+TLnrrJxd0qrbWxFlfwlBvpvHuC0PvV97F7eI5SYSYS+WlFih5wu
	MdxGindgUXR/s3R7Hrlk2S8X0VTjJQlkn6AmwVpANAMnK2Dhk8W+BloE0+B2pDuN9HSScs
	W/71qHmeKl4T8LquUSyGDwnvqLu/RhQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, usamaarif642@gmail.com, 
	ryan.roberts@arm.com, 21cnbao@gmail.com, ying.huang@linux.alibaba.com, 
	akpm@linux-foundation.org, senozhatsky@chromium.org, sj@kernel.org, kasong@tencent.com, 
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au, davem@davemloft.net, 
	clabbe@baylibre.com, ardb@kernel.org, ebiggers@google.com, surenb@google.com, 
	kristen.c.accardi@intel.com, vinicius.gomes@intel.com, giovanni.cabiddu@intel.com, 
	wajdi.k.feghali@intel.com
Subject: Re: [PATCH v14 25/26] mm: zswap: Store large folios in batches.
Message-ID: <7g4udorizeimntvz3lfjpl6ftaivrynjzowbb7wvnnelzyqmzg@5gbxsfvumpxi>
References: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
 <20260125033537.334628-26-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260125033537.334628-26-kanchana.p.sridhar@intel.com>
X-Migadu-Flow: FLOW_OUT

On Sat, Jan 24, 2026 at 07:35:36PM -0800, Kanchana P Sridhar wrote:
> Support batching when storing large folios in zswap. If the underlying
> compressor supports batching (e.g. hardware parallel compression),
> allocate multiple compression buffers, otherwise allocate one. The
> number of buffers is bounded by a new constant, ZSWAP_MAX_BATCH_SIZE, to
> limit the memory overhead. For existing software compressors, the only
> extra overhead is the extra 'buffers' pointer, so 8 bytes per-CPU on
> x86_64.
> 
> Only the first buffer is currently used, but subsequent changes will use
> the remaining buffers for hardware compression batching.
> 
> Regardless of compression batching, always process large folios in
> batches. For hardware compressors, the batch size is the compressor
> batch size, otherwise ZSWAP_MAX_BATCH_SIZE is used.
> 
> zswap_store_page() is replaced with zswap_store_pages(), which processes
> a batch of pages and allows for batching optimizations. For now, only
> optimize allocating entries by using batch allocations from the slab
> cache.
> 
> Since batch allocations do not support specifying a node id, store the
> node id in the zswap entry instead of relying on the zswap_entry being
> allocated on the same node. The size of the zswap_entry remains
> unchanged as 'referenced' is lumped in with the 'length' (as it doesn't
> need a full unsigned int anyway).
> 
> Avoid repeatedly calling mem_cgroup_zswap_writeback_enabled() for every
> page and only call it once for the folio, since the entire folio is
> charged to a single memcg.
> 
> Suggested-by: Nhat Pham <nphamcs@gmail.com>
> Suggested-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>

Generally LGTM with a few comments below, I suspect you'll need to
update this patch anyway due to conflicts.

> ---
>  mm/zswap.c | 351 +++++++++++++++++++++++++++++++++++++----------------
>  1 file changed, 248 insertions(+), 103 deletions(-)
> 
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 0d56390342b7..6a22add63220 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -82,6 +82,11 @@ static bool zswap_pool_reached_full;
>  
>  #define ZSWAP_PARAM_UNSET ""
>  
> +/* Limit the batch size to limit per-CPU memory usage for dst buffers. */
> +#define ZSWAP_MAX_BATCH_SIZE 8U
> +#define ZSWAP_ENTRY_SPARE_4BYTES 32U
> +#define ZSWAP_ENTRY_REF_BIT 1U
> +
>  static int zswap_setup(void);
>  
>  /* Enable/disable zswap */
> @@ -139,7 +144,7 @@ struct crypto_acomp_ctx {
>  	struct crypto_acomp *acomp;
>  	struct acomp_req *req;
>  	struct crypto_wait wait;
> -	u8 *buffer;
> +	u8 **buffers;
>  	struct mutex mutex;
>  };
>  
> @@ -148,6 +153,9 @@ struct crypto_acomp_ctx {
>   * The only case where lru_lock is not acquired while holding tree.lock is
>   * when a zswap_entry is taken off the lru for writeback, in that case it
>   * needs to be verified that it's still valid in the tree.
> + *
> + * @compr_batch_size: The max batch size of the compression algorithm,
> + *                    bounded by ZSWAP_MAX_BATCH_SIZE.
>   */
>  struct zswap_pool {
>  	struct zs_pool *zs_pool;
> @@ -157,6 +165,7 @@ struct zswap_pool {
>  	struct work_struct release_work;
>  	struct hlist_node node;
>  	char tfm_name[CRYPTO_MAX_ALG_NAME];
> +	u8 compr_batch_size;
>  };
>  
>  /* Global LRU lists shared by all zswap pools. */
> @@ -181,6 +190,7 @@ static struct shrinker *zswap_shrinker;
>   *              writeback logic. The entry is only reclaimed by the writeback
>   *              logic if referenced is unset. See comments in the shrinker
>   *              section for context.
> + * nid - NUMA node id of the page for which this is the zswap entry.
>   * pool - the zswap_pool the entry's data is in
>   * handle - zsmalloc allocation handle that stores the compressed page data
>   * objcg - the obj_cgroup that the compressed memory is charged to
> @@ -188,8 +198,11 @@ static struct shrinker *zswap_shrinker;
>   */
>  struct zswap_entry {
>  	swp_entry_t swpentry;
> -	unsigned int length;
> -	bool referenced;
> +	struct {
> +		unsigned int length:(ZSWAP_ENTRY_SPARE_4BYTES - ZSWAP_ENTRY_REF_BIT);
> +		bool referenced:ZSWAP_ENTRY_REF_BIT;
> +	};

As Nhat mentioned, please avoid the macros here. Also, if there's a new
version (which I suspect there will be due to conflicts), please move
adding the nid to the entry (instead of allocating it on the correct
node) to a separate patch.

> +	int nid;
>  	struct zswap_pool *pool;
>  	unsigned long handle;
>  	struct obj_cgroup *objcg;
> @@ -241,8 +254,10 @@ static inline struct xarray *swap_zswap_tree(swp_entry_t swp)
>  **********************************/
>  static void __zswap_pool_empty(struct percpu_ref *ref);
>  
> -static void acomp_ctx_dealloc(struct crypto_acomp_ctx *acomp_ctx)
> +static void acomp_ctx_dealloc(struct crypto_acomp_ctx *acomp_ctx, u8 nr_buffers)
>  {
> +	u8 i;
> +
>  	if (IS_ERR_OR_NULL(acomp_ctx))
>  		return;
>  
> @@ -252,7 +267,11 @@ static void acomp_ctx_dealloc(struct crypto_acomp_ctx *acomp_ctx)
>  	if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
>  		crypto_free_acomp(acomp_ctx->acomp);
>  
> -	kfree(acomp_ctx->buffer);
> +	if (acomp_ctx->buffers) {
> +		for (i = 0; i < nr_buffers; ++i)
> +			kfree(acomp_ctx->buffers[i]);
> +		kfree(acomp_ctx->buffers);
> +	}
>  }
>  
>  static struct zswap_pool *zswap_pool_create(char *compressor)
> @@ -264,6 +283,7 @@ static struct zswap_pool *zswap_pool_create(char *compressor)
>  	if (!zswap_has_pool && !strcmp(compressor, ZSWAP_PARAM_UNSET))
>  		return NULL;
>  
> +	/* Many things rely on the zero-initialization. */
>  	pool = kzalloc(sizeof(*pool), GFP_KERNEL);
>  	if (!pool)
>  		return NULL;
> @@ -316,7 +336,9 @@ static struct zswap_pool *zswap_pool_create(char *compressor)
>  
>  cpuhp_add_fail:
>  	for_each_possible_cpu(cpu)
> -		acomp_ctx_dealloc(per_cpu_ptr(pool->acomp_ctx, cpu));
> +		acomp_ctx_dealloc(per_cpu_ptr(pool->acomp_ctx, cpu),
> +				  pool->compr_batch_size);
> +
>  error:
>  	if (pool->acomp_ctx)
>  		free_percpu(pool->acomp_ctx);
> @@ -354,7 +376,8 @@ static void zswap_pool_destroy(struct zswap_pool *pool)
>  	cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE, &pool->node);
>  
>  	for_each_possible_cpu(cpu)
> -		acomp_ctx_dealloc(per_cpu_ptr(pool->acomp_ctx, cpu));
> +		acomp_ctx_dealloc(per_cpu_ptr(pool->acomp_ctx, cpu),
> +				  pool->compr_batch_size);
>  
>  	free_percpu(pool->acomp_ctx);
>  
> @@ -645,14 +668,8 @@ static inline struct mem_cgroup *mem_cgroup_from_entry(struct zswap_entry *entry
>  }
>  #endif
>  
> -static inline int entry_to_nid(struct zswap_entry *entry)
> -{
> -	return page_to_nid(virt_to_page(entry));
> -}
> -
>  static void zswap_lru_add(struct list_lru *list_lru, struct zswap_entry *entry)
>  {
> -	int nid = entry_to_nid(entry);
>  	struct mem_cgroup *memcg;
>  
>  	/*
> @@ -669,19 +686,18 @@ static void zswap_lru_add(struct list_lru *list_lru, struct zswap_entry *entry)
>  	rcu_read_lock();
>  	memcg = mem_cgroup_from_entry(entry);
>  	/* will always succeed */
> -	list_lru_add(list_lru, &entry->lru, nid, memcg);
> +	list_lru_add(list_lru, &entry->lru, entry->nid, memcg);
>  	rcu_read_unlock();
>  }
>  
>  static void zswap_lru_del(struct list_lru *list_lru, struct zswap_entry *entry)
>  {
> -	int nid = entry_to_nid(entry);
>  	struct mem_cgroup *memcg;
>  
>  	rcu_read_lock();
>  	memcg = mem_cgroup_from_entry(entry);
>  	/* will always succeed */
> -	list_lru_del(list_lru, &entry->lru, nid, memcg);
> +	list_lru_del(list_lru, &entry->lru, entry->nid, memcg);
>  	rcu_read_unlock();
>  }
>  
> @@ -741,6 +757,56 @@ static void zswap_entry_cache_free(struct zswap_entry *entry)
>  	kmem_cache_free(zswap_entry_cache, entry);
>  }
>  
> +static __always_inline void zswap_entries_cache_free_batch(
> +	struct zswap_entry **entries,
> +	u8 nr_entries)
> +{
> +	/*
> +	 * It is okay to use this to free entries allocated separately
> +	 * by zswap_entry_cache_alloc().
> +	 */
> +	kmem_cache_free_bulk(zswap_entry_cache, nr_entries, (void **)entries);
> +}
> +
> +static __always_inline bool zswap_entries_cache_alloc_batch(
> +	struct zswap_entry **entries,
> +	u8 nr_entries,
> +	gfp_t gfp,
> +	int nid)
> +{
> +	int nr_alloc = kmem_cache_alloc_bulk(zswap_entry_cache, gfp,
> +					     nr_entries, (void **)entries);
> +
> +	/*
> +	 * kmem_cache_alloc_bulk() should return @nr_entries on success
> +	 * and 0 on failure.
> +	 */
> +	if (likely(nr_alloc == nr_entries))
> +		return true;
> +
> +	if (WARN_ON_ONCE(unlikely(nr_alloc && (nr_alloc != nr_entries)))) {

We don't need to check 'nr_alloc != nr_entries' here, as we just checked
the opposite of it and returned above.

> +		zswap_reject_kmemcache_fail++;

I don't think we want to increment the counter if batch allocation
fails, only if the fallback fails below. Not a big deal as this should
never happen though.

> +		zswap_entries_cache_free_batch(entries, nr_alloc);
> +		nr_alloc = 0;
> +	}
> +
> +	if (unlikely(!nr_alloc)) {

We don't need to check this here as well, nr_alloc should always be 0,
right? If anything, it's *very* likely() :)

> +		unsigned int i;
> +
> +		for (i = 0; i < nr_entries; ++i) {
> +			entries[i] = zswap_entry_cache_alloc(GFP_KERNEL, nid);
> +
> +			if (unlikely(!entries[i])) {
> +				zswap_reject_kmemcache_fail++;
> +				zswap_entries_cache_free_batch(entries, i);
> +				return false;
> +			}
> +		}
> +	}
> +
> +	return true;
> +}
> +
>  /*
>   * Carries out the common pattern of freeing an entry's zsmalloc allocation,
>   * freeing the entry itself, and decrementing the number of stored pages.
> @@ -767,7 +833,9 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
>  {
>  	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
>  	struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
> +	int nid = cpu_to_node(cpu);
>  	int ret = -ENOMEM;
> +	u8 i;
>  
>  	/*
>  	 * To handle cases where the CPU goes through online-offline-online
> @@ -778,11 +846,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
>  		return 0;
>  	}
>  
> -	acomp_ctx->buffer = kmalloc_node(PAGE_SIZE, GFP_KERNEL, cpu_to_node(cpu));
> -	if (!acomp_ctx->buffer)
> -		return ret;
> -
> -	acomp_ctx->acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(cpu));
> +	acomp_ctx->acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, nid);
>  	if (IS_ERR_OR_NULL(acomp_ctx->acomp)) {
>  		pr_err("could not alloc crypto acomp %s : %ld\n",
>  				pool->tfm_name, PTR_ERR(acomp_ctx->acomp));
> @@ -790,20 +854,39 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
>  		goto fail;
>  	}
>  
> +	/*
> +	 * Allocate up to ZSWAP_MAX_BATCH_SIZE dst buffers if the
> +	 * compressor supports batching.
> +	 */
> +	pool->compr_batch_size = min(ZSWAP_MAX_BATCH_SIZE,
> +				     crypto_acomp_batch_size(acomp_ctx->acomp));
> +
>  	acomp_ctx->req = acomp_request_alloc(acomp_ctx->acomp);
> +
>  	if (IS_ERR_OR_NULL(acomp_ctx->req)) {
>  		pr_err("could not alloc crypto acomp_request %s\n",
>  		       pool->tfm_name);
>  		goto fail;
>  	}
>  
> -	crypto_init_wait(&acomp_ctx->wait);
> +	acomp_ctx->buffers = kcalloc_node(pool->compr_batch_size, sizeof(u8 *),
> +					  GFP_KERNEL, nid);
> +	if (!acomp_ctx->buffers)
> +		goto fail;
> +
> +	for (i = 0; i < pool->compr_batch_size; ++i) {
> +		acomp_ctx->buffers[i] = kmalloc_node(PAGE_SIZE, GFP_KERNEL, nid);
> +		if (!acomp_ctx->buffers[i])
> +			goto fail;
> +	}
>  
>  	/*
>  	 * if the backend of acomp is async zip, crypto_req_done() will wakeup
>  	 * crypto_wait_req(); if the backend of acomp is scomp, the callback
>  	 * won't be called, crypto_wait_req() will return without blocking.
>  	 */
> +	crypto_init_wait(&acomp_ctx->wait);
> +
>  	acomp_request_set_callback(acomp_ctx->req, CRYPTO_TFM_REQ_MAY_BACKLOG,
>  				   crypto_req_done, &acomp_ctx->wait);
>  
> @@ -813,12 +896,12 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
>  	return 0;
>  
>  fail:
> -	acomp_ctx_dealloc(acomp_ctx);
> +	acomp_ctx_dealloc(acomp_ctx, pool->compr_batch_size);
>  	return ret;
>  }
>  
>  static bool zswap_compress(struct page *page, struct zswap_entry *entry,
> -			   struct zswap_pool *pool)
> +			   struct zswap_pool *pool, bool wb_enabled)
>  {
>  	struct crypto_acomp_ctx *acomp_ctx;
>  	struct scatterlist input, output;
> @@ -832,7 +915,7 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
>  	acomp_ctx = raw_cpu_ptr(pool->acomp_ctx);
>  	mutex_lock(&acomp_ctx->mutex);
>  
> -	dst = acomp_ctx->buffer;
> +	dst = acomp_ctx->buffers[0];
>  	sg_init_table(&input, 1);
>  	sg_set_page(&input, page, PAGE_SIZE, 0);
>  
> @@ -862,8 +945,7 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
>  	 * to the active LRU list in the case.
>  	 */
>  	if (comp_ret || !dlen || dlen >= PAGE_SIZE) {
> -		if (!mem_cgroup_zswap_writeback_enabled(
> -					folio_memcg(page_folio(page)))) {
> +		if (!wb_enabled) {
>  			comp_ret = comp_ret ? comp_ret : -EINVAL;
>  			goto unlock;
>  		}
> @@ -909,7 +991,7 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
>  	acomp_ctx = raw_cpu_ptr(pool->acomp_ctx);
>  	mutex_lock(&acomp_ctx->mutex);
>  	obj = zs_obj_read_begin(pool->zs_pool, entry->handle, entry->length,
> -				acomp_ctx->buffer);
> +				acomp_ctx->buffers[0]);
>  
>  	/* zswap entries of length PAGE_SIZE are not compressed. */
>  	if (entry->length == PAGE_SIZE) {
> @@ -919,15 +1001,15 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
>  
>  	/*
>  	 * zs_obj_read_begin() might return a kmap address of highmem when
> -	 * acomp_ctx->buffer is not used.  However, sg_init_one() does not
> -	 * handle highmem addresses, so copy the object to acomp_ctx->buffer.
> +	 * acomp_ctx->buffers[0] is not used.  However, sg_init_one() does not
> +	 * handle highmem addresses, so copy the object to acomp_ctx->buffers[0].
>  	 */
>  	if (virt_addr_valid(obj)) {
>  		src = obj;
>  	} else {
> -		WARN_ON_ONCE(obj == acomp_ctx->buffer);
> -		memcpy(acomp_ctx->buffer, obj, entry->length);
> -		src = acomp_ctx->buffer;
> +		WARN_ON_ONCE(obj == acomp_ctx->buffers[0]);
> +		memcpy(acomp_ctx->buffers[0], obj, entry->length);
> +		src = acomp_ctx->buffers[0];
>  	}

This code no longer exists (the conflict I referred to earlier).

>  	sg_init_one(&input, src, entry->length);
> @@ -1381,95 +1463,136 @@ static void shrink_worker(struct work_struct *w)
>  * main API
>  **********************************/
>  
> -static bool zswap_store_page(struct page *page,
> -			     struct obj_cgroup *objcg,
> -			     struct zswap_pool *pool)
> +/*
> + * Store multiple pages in @folio, starting from the page at index @start up to
> + * the page at index @end-1.
> + */
> +static bool zswap_store_pages(struct folio *folio,
> +			      long start,
> +			      long end,
> +			      struct zswap_pool *pool,
> +			      struct crypto_acomp_ctx *acomp_ctx,

I don't see where acomp_ctx is used here?

> +			      int nid,
> +			      bool wb_enabled,
> +			      struct obj_cgroup *objcg)
>  {
> -	swp_entry_t page_swpentry = page_swap_entry(page);
> -	struct zswap_entry *entry, *old;
> +	struct zswap_entry *entries[ZSWAP_MAX_BATCH_SIZE];
> +	u8 i, store_fail_idx = 0, nr_pages = end - start;
>  
> -	/* allocate entry */
> -	entry = zswap_entry_cache_alloc(GFP_KERNEL, page_to_nid(page));
> -	if (!entry) {
> -		zswap_reject_kmemcache_fail++;
> +	VM_WARN_ON_ONCE(nr_pages > ZSWAP_MAX_BATCH_SIZE);
> +
> +	if (unlikely(!zswap_entries_cache_alloc_batch(entries, nr_pages,
> +						      GFP_KERNEL, nid)))
>  		return false;
> -	}
>  
> -	if (!zswap_compress(page, entry, pool))
> -		goto compress_failed;
> +	/*
> +	 * We co-locate entry initialization as much as possible here to
> +	 * minimize potential cache misses.
> +	 */
> +	for (i = 0; i < nr_pages; ++i) {
> +		entries[i]->handle = (unsigned long)ERR_PTR(-EINVAL);
> +		entries[i]->pool = pool;
> +		entries[i]->swpentry = page_swap_entry(folio_page(folio, start + i));
> +		entries[i]->objcg = objcg;
> +		entries[i]->referenced = true;
> +		entries[i]->nid = nid;
> +		INIT_LIST_HEAD(&entries[i]->lru);
> +	}
>  
> -	old = xa_store(swap_zswap_tree(page_swpentry),
> -		       swp_offset(page_swpentry),
> -		       entry, GFP_KERNEL);
> -	if (xa_is_err(old)) {
> -		int err = xa_err(old);
> +	for (i = 0; i < nr_pages; ++i) {
> +		struct page *page = folio_page(folio, start + i);
>  
> -		WARN_ONCE(err != -ENOMEM, "unexpected xarray error: %d\n", err);
> -		zswap_reject_alloc_fail++;
> -		goto store_failed;
> +		if (!zswap_compress(page, entries[i], pool, wb_enabled))
> +			goto store_pages_failed;
>  	}
>  
> -	/*
> -	 * We may have had an existing entry that became stale when
> -	 * the folio was redirtied and now the new version is being
> -	 * swapped out. Get rid of the old.
> -	 */
> -	if (old)
> -		zswap_entry_free(old);
> +	for (i = 0; i < nr_pages; ++i) {
> +		struct zswap_entry *old, *entry = entries[i];
>  
> -	/*
> -	 * The entry is successfully compressed and stored in the tree, there is
> -	 * no further possibility of failure. Grab refs to the pool and objcg,
> -	 * charge zswap memory, and increment zswap_stored_pages.
> -	 * The opposite actions will be performed by zswap_entry_free()
> -	 * when the entry is removed from the tree.
> -	 */
> -	zswap_pool_get(pool);
> -	if (objcg) {
> -		obj_cgroup_get(objcg);
> -		obj_cgroup_charge_zswap(objcg, entry->length);
> -	}
> -	atomic_long_inc(&zswap_stored_pages);
> -	if (entry->length == PAGE_SIZE)
> -		atomic_long_inc(&zswap_stored_incompressible_pages);
> +		old = xa_store(swap_zswap_tree(entry->swpentry),
> +			       swp_offset(entry->swpentry),
> +			       entry, GFP_KERNEL);
> +		if (unlikely(xa_is_err(old))) {
> +			int err = xa_err(old);
>  
> -	/*
> -	 * We finish initializing the entry while it's already in xarray.
> -	 * This is safe because:
> -	 *
> -	 * 1. Concurrent stores and invalidations are excluded by folio lock.
> -	 *
> -	 * 2. Writeback is excluded by the entry not being on the LRU yet.
> -	 *    The publishing order matters to prevent writeback from seeing
> -	 *    an incoherent entry.
> -	 */
> -	entry->pool = pool;
> -	entry->swpentry = page_swpentry;
> -	entry->objcg = objcg;
> -	entry->referenced = true;
> -	if (entry->length) {
> -		INIT_LIST_HEAD(&entry->lru);
> -		zswap_lru_add(&zswap_list_lru, entry);
> +			WARN_ONCE(err != -ENOMEM, "unexpected xarray error: %d\n", err);
> +			zswap_reject_alloc_fail++;
> +			/*
> +			 * Entries up to this point have been stored in the
> +			 * xarray. zswap_store() will erase them from the xarray
> +			 * and call zswap_entry_free(). Local cleanup in
> +			 * 'store_pages_failed' only needs to happen for
> +			 * entries from [@i to @nr_pages).
> +			 */
> +			store_fail_idx = i;
> +			goto store_pages_failed;
> +		}
> +
> +		/*
> +		 * We may have had an existing entry that became stale when
> +		 * the folio was redirtied and now the new version is being
> +		 * swapped out. Get rid of the old.
> +		 */
> +		if (unlikely(old))
> +			zswap_entry_free(old);
> +
> +		/*
> +		 * The entry is successfully compressed and stored in the tree,
> +		 * and further failures will be cleaned up in zswap_store().
> +		 * Grab refs to the pool and objcg, charge zswap memory, and
> +		 * increment zswap_stored_pages. The opposite actions will be
> +		 * performed by zswap_entry_free() when the entry is removed
> +		 * from the tree.
> +		 */
> +		zswap_pool_get(pool);
> +		if (objcg) {
> +			obj_cgroup_get(objcg);
> +			obj_cgroup_charge_zswap(objcg, entry->length);
> +		}
> +		atomic_long_inc(&zswap_stored_pages);
> +		if (entry->length == PAGE_SIZE)
> +			atomic_long_inc(&zswap_stored_incompressible_pages);
> +
> +		/*
> +		 * We finish by adding the entry to the LRU while it's already
> +		 * in xarray. This is safe because:
> +		 *
> +		 * 1. Concurrent stores and invalidations are excluded by folio lock.
> +		 *
> +		 * 2. Writeback is excluded by the entry not being on the LRU yet.
> +		 *    The publishing order matters to prevent writeback from seeing
> +		 *    an incoherent entry.
> +		 */
> +		if (likely(entry->length))
> +			zswap_lru_add(&zswap_list_lru, entry);
>  	}
>  
>  	return true;
>  
> -store_failed:
> -	zs_free(pool->zs_pool, entry->handle);
> -compress_failed:
> -	zswap_entry_cache_free(entry);
> +store_pages_failed:
> +	for (i = store_fail_idx; i < nr_pages; ++i) {
> +		if (!IS_ERR_VALUE(entries[i]->handle))
> +			zs_free(pool->zs_pool, entries[i]->handle);
> +	}
> +	zswap_entries_cache_free_batch(&entries[store_fail_idx],
> +				       nr_pages - store_fail_idx);
> +
>  	return false;
>  }
>  
>  bool zswap_store(struct folio *folio)
>  {
> +	bool wb_enabled = mem_cgroup_zswap_writeback_enabled(folio_memcg(folio));
>  	long nr_pages = folio_nr_pages(folio);
> +	struct crypto_acomp_ctx *acomp_ctx;
>  	swp_entry_t swp = folio->swap;
>  	struct obj_cgroup *objcg = NULL;
>  	struct mem_cgroup *memcg = NULL;
> +	int nid = folio_nid(folio);
>  	struct zswap_pool *pool;
> +	u8 store_batch_size;
>  	bool ret = false;
> -	long index;
> +	long start, end;
>  
>  	VM_WARN_ON_ONCE(!folio_test_locked(folio));
>  	VM_WARN_ON_ONCE(!folio_test_swapcache(folio));
> @@ -1503,10 +1626,32 @@ bool zswap_store(struct folio *folio)
>  		mem_cgroup_put(memcg);
>  	}
>  
> -	for (index = 0; index < nr_pages; ++index) {
> -		struct page *page = folio_page(folio, index);
> +	/*
> +	 * For batching compressors, store the folio in batches of the
> +	 * compressor's batch_size.
> +	 *
> +	 * For non-batching compressors, store the folio in batches
> +	 * of ZSWAP_MAX_BATCH_SIZE, where each page in the batch is
> +	 * compressed sequentially. This gives better performance than
> +	 * invoking zswap_store_pages() per-page, due to cache locality
> +	 * of working set structures.
> +	 */
> +	store_batch_size = (pool->compr_batch_size > 1) ?
> +			    pool->compr_batch_size : ZSWAP_MAX_BATCH_SIZE;
> +
> +	acomp_ctx = raw_cpu_ptr(pool->acomp_ctx);
>  
> -		if (!zswap_store_page(page, objcg, pool))
> +	for (start = 0; start < nr_pages; start += store_batch_size) {
> +		end = min(start + store_batch_size, nr_pages);
> +
> +		if (unlikely(!zswap_store_pages(folio,
> +						start,
> +						end,
> +						pool,
> +						acomp_ctx,
> +						nid,

I think acomp_ctx is not used in zswap_store_pages(). If it is, we don't
need to pass it from here. Same for nid, no need to pass it from here.

We should be able to shrink the arg list and make this more concise. I
would drop unlikely() if it doesn't result in a meaningful improvement.
Otherwise you can also make this line a bit shorter if you keep
unlikely():

	ret = zswap_store_pages(..);
	if (unlikely(!ret))
		goto put_pool;

> +						wb_enabled,
> +						objcg)))
>  			goto put_pool;
>  	}
>  
> @@ -1536,9 +1681,9 @@ bool zswap_store(struct folio *folio)
>  		struct zswap_entry *entry;
>  		struct xarray *tree;
>  
> -		for (index = 0; index < nr_pages; ++index) {
> -			tree = swap_zswap_tree(swp_entry(type, offset + index));
> -			entry = xa_erase(tree, offset + index);
> +		for (start = 0; start < nr_pages; ++start) {
> +			tree = swap_zswap_tree(swp_entry(type, offset + start));
> +			entry = xa_erase(tree, offset + start);
>  			if (entry)
>  				zswap_entry_free(entry);
>  		}
> -- 
> 2.27.0
> 
