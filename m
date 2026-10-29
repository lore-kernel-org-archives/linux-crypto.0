Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793243163;
	b=k/A6VnvDaC05U3iq3X7FiyWy/YopJvyEjkEWZaFe9j4Wq7nJp8i/Itctwxd7VnHdQn91
	 agTJ/4MJzLUiZHqin2tkyMZO64ve/rLW4QrjIwx5lFNUK5OapEU9WpucCwjobcOpvgVd8
	 E7BIb8IVp8LrfeIWG4AYfMh+bVzYlKfXxstAwntSU+vUrgO1kJy9zCvgnol2+H+7BGXW1
	 AwOniZ+k6eVbvFCO3vduMqMDiUkZujLojuOQuGNIEkN4G85aldjby/blGAIFRbcsc16W7
	 CiFGKiqoGBRsygt7McteQAnfxRBUZr7mgtiWX+AhvhcuDKkvuRkhgOI7fsbqwLlOFgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793243163;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=4b2oq+C40ech5OdXcId7EI0kRc6xwtJPfUMQW1KODYw=;
	b=rdsriUaAH/hROR6egWneHXed+CK/5+QGD7A035IGOkiblfj1JBEc2zyTYAnI1aUTDL4N
	 U6hgVOyUq45k4SVmZ81+NfKPFC6hpqI9HdeXDUlDHfEz3fqHIeh8WIFWiD3XYQuPedSTQ
	 zPgAKC7WuPaUDRnMLEPd380/Qy/zfSbGhBSLcvqQ7xjP7vrrELizDWBsqkunPKm6t2tfq
	 Pr5YsDDjyQmLTHmmNc/skGf7aGerRz6vAx5iTTPYbIJmpo9BDJh9tCJiVyadrNC+T6hk8
	 4fQqAXqDyC83uAZ0i66NnJwNDG7cYzscco+EhI84N/h9JR3iObScNsl344BFCFIrcjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hPl7XYHJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 756D6606A31A
	for <linux-crypto@vger.kernel.org>; Thu, 29 Oct 2026 03:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hPl7XYHJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 855271F01825;
	Thu, 29 Oct 2026 03:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793243163;
	bh=4b2oq+C40ech5OdXcId7EI0kRc6xwtJPfUMQW1KODYw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hPl7XYHJpJn7ap/pINv2UtZVTwWe/12yxeaSjN8U6hwdQuzfn4bGO5V7v7FNim7nW
	 MCN+EL08pG3FrIr+yayVaOCXyx5l2U4DQXwriPGGrJUteNkYmFOypYDPMmFHJ6OD2F
	 8UvIeAT+A07FcSfs1d00NI9odg/vVQHJl8rCrk2TUOyLAWgKcnd/0IoI8ONDlgF127
	 JdEfdRUcD4YgDL3jw1hpX5ukxf8mSCTovc7AvHUlU6HjoSkoi8ntxz0gs64Nii96vw
	 ds7zsErrHV6RWs6q/YTKDXMFWki/VvtSbAGjPyl1SYf9HMoNlPgiCcluXGWNJTvO0C
	 yL0Bqqql3mlMw==
Message-ID: <sashiko-outbox-188657@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 5/8] mm: zswap: Store the folio's node id in the
 zswap_entry.
Reply-To: sashiko-reviews@lists.linux.dev
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>, hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com, chengming.zhou@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, davem@davemloft.net, linux-crypto@vger.kernel.org
Cc: rientjes@google.com, willy@infradead.org, senozhatsky@chromium.org
In-Reply-To: <20261028030503.17923-6-kanchanapsridhar2026@gmail.com>
References: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
 <20261028030503.17923-6-kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 29 Oct 2026 03:06:02 +0000
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
- [High] mm: zswap: off-by-one bitfield width for zswap_entry.length on 256=
KB pages
- [Medium] mm: zswap: shrink_memcg() skips non-N_NORMAL_MEMORY nodes in zsw=
ap_list_lru
--

commit c4aa889f59a75fcf871276fd68b4a4738afe132b
Author: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>

mm: zswap: Store the folio's node id in the zswap_entry.

This commit stores the folio's NUMA node ID directly in struct zswap_entry
instead of deriving it from the slab page backing the entry, and converts
zswap_entry_cache_alloc() to use node-agnostic slab allocation. To keep the
structure size unchanged, it packs length and referenced into bitfields.

> diff --git a/mm/zswap.c b/mm/zswap.c
> index e1d57a7d95950..19b7d60bc7d2a 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -180,6 +180,7 @@ struct zswap_pool {
>   */
>  #define ZSWAP_FIRST_POOL_ID 1
>  #define ZSWAP_MAX_POOL_ID U8_MAX
> +#define ZSWAP_MAX_COMPR_LENGTH_SHIFT 18U
>  static DEFINE_XARRAY_FLAGS(zswap_pools, XA_FLAGS_ALLOC1 | XA_FLAGS_LOCK_=
BH);
>  static struct zswap_pool __rcu *zswap_current_pool;
> =20
> @@ -206,15 +207,19 @@ static struct shrinker *zswap_shrinker;
>   *              logic if referenced is unset. See comments in the shrink=
er
>   *              section for context.
>   * pool_idx - id of the zswap_pool that the entry's data is in.
> + * nid - NUMA node id of the page for which this is the zswap entry.
>   * handle - zsmalloc allocation handle that stores the compressed page d=
ata
>   * objcg - the obj_cgroup that the compressed memory is charged to
>   * lru - handle to the pool's lru used to evict pages.
>   */
>  struct zswap_entry {
>  	swp_entry_t swpentry;
> -	unsigned int length;
> -	bool referenced;
> -	u8 pool_idx;
> +	struct {
> +		unsigned int length:ZSWAP_MAX_COMPR_LENGTH_SHIFT;
> +		bool referenced:1U;
> +		u8 pool_idx;
> +	};

[Severity: High]
Can entry->length overflow to 0 when storing an incompressible page on a
kernel with 256KB pages (PAGE_SHIFT =3D=3D 18)?

With ZSWAP_MAX_COMPR_LENGTH_SHIFT defined as 18U, the 18-bit unsigned
bitfield can only hold values up to (1U << 18) - 1, whereas PAGE_SIZE is
(1UL << 18) when PAGE_SHIFT =3D=3D 18.

When an incompressible page is stored with writeback enabled in
zswap_store_page() -> zswap_compress():

mm/zswap.c:zswap_compress() {
    ...
	if (comp_ret) {
		...
		comp_ret =3D 0;
		dlen =3D PAGE_SIZE;
		dst =3D kmap_local_folio(folio, index * PAGE_SIZE);
		mapped =3D true;
	}
	...
	entry->handle =3D handle;
	entry->length =3D dlen;
}

Assigning PAGE_SIZE to entry->length wraps the 18-bit bitfield to 0. In
zswap_store_page(), entry->length =3D=3D 0 then skips initializing entry->l=
ru and
adding it to the LRU:

mm/zswap.c:zswap_store_page() {
    ...
	if (entry->length =3D=3D PAGE_SIZE)
		atomic_long_inc(&zswap_stored_incompressible_pages);
	...
	if (entry->length) {
		INIT_LIST_HEAD(&entry->lru);
		zswap_lru_add(entry);
	}
}

Later, zswap_entry_free() unconditionally calls zswap_lru_del(entry) on the
uninitialized entry->lru list head, and __zswap_decompress() fails on swapin
because entry->length =3D=3D PAGE_SIZE is false.

Should ZSWAP_MAX_COMPR_LENGTH_SHIFT be at least 19U (and the check in
zswap_setup() be BUILD_BUG_ON(ZSWAP_MAX_COMPR_LENGTH_SHIFT <=3D PAGE_SHIFT)=
) so
that entry->length can represent PAGE_SIZE?

[ ... ]

> @@ -1507,9 +1506,10 @@ static bool zswap_store_page(struct folio *folio, =
long index,
>  {
>  	swp_entry_t page_swpentry =3D folio_swap_entry(folio, index);
>  	struct zswap_entry *entry, *old;
> +	int nid =3D folio_nid(folio);
> =20
>  	/* allocate entry */
> -	entry =3D zswap_entry_cache_alloc(GFP_KERNEL, folio_nid(folio));
> +	entry =3D zswap_entry_cache_alloc(GFP_KERNEL);
>  	if (!entry) {
>  		zswap_reject_kmemcache_fail++;
>  		return false;
> @@ -1524,6 +1524,7 @@ static bool zswap_store_page(struct folio *folio, l=
ong index,
>  	 * to an unrelated live pool.
>  	 */
>  	entry->pool_idx =3D pool->idx;
> +	entry->nid =3D nid;

[Severity: Medium]
What happens during cgroup or pool reclaim in shrink_memcg() if the swapped
folio resides on a NUMA node without normal memory (for example, a
ZONE_MOVABLE-only or ZONE_HIGHMEM-only node)?

Previously, entry_to_nid() derived the node from virt_to_page(entry), which
was allocated from slab with GFP_KERNEL and therefore always resided on a
node in N_NORMAL_MEMORY.

With entry->nid now set to folio_nid(folio) in zswap_store_page(), anonymous
and shmem folios allocated with GFP_HIGHUSER_MOVABLE can have an entry->nid
that is in N_MEMORY, but not in N_NORMAL_MEMORY. zswap_lru_add() inserts
those entries into zswap_list_lru for entry->nid, but shrink_memcg() only
walks N_NORMAL_MEMORY nodes:

mm/zswap.c:shrink_memcg() {
    ...
	for_each_node_state(nid, N_NORMAL_MEMORY) {
		unsigned long nr_to_walk =3D SWAP_CLUSTER_MAX;

		shrunk +=3D list_lru_walk_one(&zswap_list_lru, nid, memcg,
					    &shrink_memcg_cb, NULL, &nr_to_walk);
		scanned +=3D SWAP_CLUSTER_MAX - nr_to_walk;
	}
}

Should shrink_memcg() iterate over N_MEMORY instead of N_NORMAL_MEMORY so
that entries from movable-only or highmem-only nodes can be reclaimed by
shrink_worker() and mem_cgroup_try_charge_zswap()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261028030503.1792=
3-1-kanchanapsridhar2026@gmail.com?part=3D5
