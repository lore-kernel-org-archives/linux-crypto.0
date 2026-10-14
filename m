Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3DEB23D7E3;
	Wed, 14 Oct 2026 00:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791937098; cv=none; b=arbnkgAKGgFojZm8YnjV2yeDwoQ9ugeXAyUSAqlJygTGRrUJgTKhkYN5BDC+CsYORosINZ0FQznczFBu/+bc2oZAlfzGj+Fu9BlZnYdxryFNpJ52KUWsgV5EYqM7ofmVOr1Og1/jpc45vAxPu+hkTTK3z0HFf0uincwXf4QmvxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791937098; c=relaxed/simple;
	bh=URA8KTAZUQmltFnz8XVV//LKAnb1vcTnY0iYNs2+cDM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kDVGlnQslwrXQeuwS6tGzR5244j3EPjjyhZovyAT9eu4U0BrY0Pd/PyD9YkBKnisNz1JBjOKbeJBYS4/yX7SbAc0NTZFUxPgNZTqazsCngviMa9rjCTX/+YCp3RTl27jXmU1lNo+xogk42i756eg8n268vk68DbxSF5hBRbwRL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hzn17pG9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hzn17pG9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C578F1F000FF;
	Wed, 14 Oct 2026 00:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791937095;
	bh=6ojGJwDPTVvH1mNyQFRD6ZgJPJ+C3Xv6E6vMi/T8h+E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hzn17pG99bpu4AnLp0GZuqYv84aeXmdu4EX/E6PlW4tSL5nn0xPhvQDvylCA8J4uJ
	 HbbsWrjqdsqr+5dUmhTwGFQS3JYlfN73D/LFNtot6qcrLEm6LPWCW10jnGuow8zifc
	 9RyfYHDVGFy+nXcM/0BGc+00HvdJnXD85ukvRN9qe5PCHldwZ/SwfZgQsVrDYuRLw4
	 XI91kO7ay9LNFSMbz2EBR+tGXBLbTyQS7QJtF3/E0EiEg1gYfXe9Nij9xqHqlw8yXc
	 wTI1Rre0YJdOPZ1g0a8kjdVzSL6xkVCi5EVgekdy5FMoYjeb3OUTRwk/jmjGIBzG0i
	 J94sV8320RL7A==
Date: Wed, 14 Oct 2026 00:18:13 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	rientjes@google.com, willy@infradead.org, senozhatsky@chromium.org
Subject: Re: [PATCH v1 5/8] mm: zswap: Store the folio's node id in the
 zswap_entry.
Message-ID: <as7JC8o2kggiq_ss@google.com>
References: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
 <20261008182814.27450-6-kanchanapsridhar2026@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261008182814.27450-6-kanchanapsridhar2026@gmail.com>

On Thu, Oct 08, 2026 at 11:28:11AM -0700, Kanchana P. Sridhar wrote:
> When storing a folio in zswap, save the folio's node id in the zswap
> entry instead of relying on the zswap_entry being allocated on the same
> node. This enables optimizations such as batch allocation of zswap
> entries for large folios using kmem_cache_alloc_bulk() that does not
> support specifying a node id.
> 
> The size of the zswap_entry remains unchanged as 'referenced' is lumped
> in with the 'length' (as it doesn't need a full unsigned int anyway).
> 
> Suggested-by: Nhat Pham <nphamcs@gmail.com>
> Suggested-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
> ---
>  mm/zswap.c | 23 +++++++++++------------
>  1 file changed, 11 insertions(+), 12 deletions(-)
> 
> diff --git a/mm/zswap.c b/mm/zswap.c
> index ca513a9f89e3..c2731d3acb2c 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -194,6 +194,7 @@ static struct shrinker *zswap_shrinker;
>   *              writeback logic. The entry is only reclaimed by the writeback
>   *              logic if referenced is unset. See comments in the shrinker
>   *              section for context.
> + * nid - NUMA node id of the page for which this is the zswap entry.
>   * pool_idx - id of the zswap_pool that the entry's data is in.
>   * handle - zsmalloc allocation handle that stores the compressed page data
>   * objcg - the obj_cgroup that the compressed memory is charged to
> @@ -201,8 +202,11 @@ static struct shrinker *zswap_shrinker;
>   */
>  struct zswap_entry {
>  	swp_entry_t swpentry;
> -	unsigned int length;
> -	bool referenced;
> +	struct {
> +		unsigned int length:31;
> +		bool referenced:1;
> +	};
> +	int nid;

This will increase the size of the struct now with pool_idx, right?

Before you patch on x86_64:

struct zswap_entry {
	swp_entry_t                swpentry;             /*     0     8 */
	unsigned int               length;               /*     8     4 */
	bool                       referenced;           /*    12     1 */
	u8                         pool_idx;             /*    13     1 */

	/* XXX 2 bytes hole, try to pack */

	unsigned long              handle;               /*    16     8 */
	struct obj_cgroup *        objcg;                /*    24     8 */
	struct list_head           lru;                  /*    32    16 */

	/* size: 48, cachelines: 1, members: 7 */
	/* sum members: 46, holes: 1, sum holes: 2 */
	/* last cacheline: 48 bytes */
};

After:

struct zswap_entry {
	swp_entry_t                swpentry;             /*     0     8 */
	struct {
		unsigned int       length:31;            /*     8: 0  4 */

		/* Bitfield combined with next fields */

		bool               referenced:1;         /*    11: 7  1 */
	};                                               /*     8     4 */
	struct {
		unsigned int               length:31;            /*     0: 0  4 */

		/* Bitfield combined with next fields */

		bool                       referenced:1;         /*     3: 7  1 */

		/* size: 4, cachelines: 1, members: 2 */
		/* last cacheline: 4 bytes */
	};

	int                        nid;                  /*    12     4 */
	u8                         pool_idx;             /*    16     1 */

	/* XXX 7 bytes hole, try to pack */

	unsigned long              handle;               /*    24     8 */
	struct obj_cgroup *        objcg;                /*    32     8 */
	struct list_head           lru;                  /*    40    16 */

	/* size: 56, cachelines: 1, members: 7 */
	/* sum members: 49, holes: 1, sum holes: 7 */
	/* last cacheline: 56 bytes */
};

I think we want to reorder the fields. We can probably also avoid the
bitfield if the maximum page size is 64K (is it?)

struct zswap_entry {
	swp_entry_t                swpentry;             /*     0     8 */
	u16                        length;               /*     8     2 */
	u8                         pool_idx;             /*    10     1 */
	bool                       referenced;           /*    11     1 */
	int                        nid;                  /*    12     4 */
	unsigned long              handle;               /*    16     8 */
	struct obj_cgroup *        objcg;                /*    24     8 */
	struct list_head           lru;                  /*    32    16 */

	/* size: 48, cachelines: 1, members: 8 */
	/* last cacheline: 48 bytes */
};


>  	u8 pool_idx;
>  	unsigned long handle;
>  	struct obj_cgroup *objcg;
> @@ -672,14 +676,8 @@ static int zswap_enabled_param_set(const char *val,
>  * lru functions
>  **********************************/
>  
> -static inline int entry_to_nid(struct zswap_entry *entry)
> -{
> -	return page_to_nid(virt_to_page(entry));
> -}
> -
>  static void zswap_lru_add(struct zswap_entry *entry)
>  {
> -	int nid = entry_to_nid(entry);
>  	struct mem_cgroup *memcg;
>  
>  	/*
> @@ -696,19 +694,18 @@ static void zswap_lru_add(struct zswap_entry *entry)
>  	rcu_read_lock();
>  	memcg = obj_cgroup_memcg(entry->objcg);
>  	/* will always succeed */
> -	list_lru_add(&zswap_list_lru, &entry->lru, nid, memcg);
> +	list_lru_add(&zswap_list_lru, &entry->lru, entry->nid, memcg);
>  	rcu_read_unlock();
>  }
>  
>  static void zswap_lru_del(struct zswap_entry *entry)
>  {
> -	int nid = entry_to_nid(entry);
>  	struct mem_cgroup *memcg;
>  
>  	rcu_read_lock();
>  	memcg = obj_cgroup_memcg(entry->objcg);
>  	/* will always succeed */
> -	list_lru_del(&zswap_list_lru, &entry->lru, nid, memcg);
> +	list_lru_del(&zswap_list_lru, &entry->lru, entry->nid, memcg);
>  	rcu_read_unlock();
>  }
>  
> @@ -1449,9 +1446,10 @@ static bool zswap_store_page(struct folio *folio, long index,
>  {
>  	swp_entry_t page_swpentry = folio_swap_entry(folio, index);
>  	struct zswap_entry *entry, *old;
> +	int nid = folio_nid(folio);
>  
>  	/* allocate entry */
> -	entry = zswap_entry_cache_alloc(GFP_KERNEL, folio_nid(folio));
> +	entry = zswap_entry_cache_alloc(GFP_KERNEL, nid);

We don't need to allocate the entry on the same node anymore, should we
drop this and let the slab allocator handle it as it sees fit?

>  	if (!entry) {
>  		zswap_reject_kmemcache_fail++;
>  		return false;
> @@ -1466,6 +1464,7 @@ static bool zswap_store_page(struct folio *folio, long index,
>  	 * to an unrelated live pool.
>  	 */
>  	entry->pool_idx = pool->idx;
> +	entry->nid = nid;
>  
>  	old = xa_store(swap_zswap_tree(page_swpentry),
>  		       swp_offset(page_swpentry),
> -- 
> 2.39.5
> 
