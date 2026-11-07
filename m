Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794036309;
	b=u9RF9DDFix/9Fp622CwOootv5dgolCE52G2GfAZCmrTzLOQ8AI+GOG2D+RH8ZSko/Qib
	 3BdBPWT7CWbIFF3VMdPm9TB1fCiLMTFCPy9S7zwZUHqD6UGs56SVrvWBY5iTPGq0eitwR
	 L2bPjkwTc+zmt+yh8fdqz2ujNpeTCntRFFGjSryqjZODF5M2xDaPAqEmCTrekj1HxvJbI
	 d7iJIClCkRVQx/7tTZumggwZcCwnahT++aU6EH90nc2Qj8m/iMVSBDMCIkrgsPFJ51H8O
	 7AZWVbF4AkEiKlxfyHVuikAR4RBmS0Kqc2BV6VxSeDs54lNUDq3YNt2sQ8NFiT36+Lw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794036309;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=4uPbxxqopJMnZ7ErMwn2urmrgG+FVEzHE8ZgEba/UMo=;
	b=3xVUSUPDqj0g0gkx3sPcqOw55GrnjCaOKjKrPjCK0wu+IzyBuKPwQRBG4ulN4stvYhry
	 LQx2vMoAo/ne+DUgCjqD4DvJNY5c+q+ra+EFINhgln257efaA2kLfcCrTV7RzAA+qWy3B
	 jKKEn9xUklygBZQZTqN2M55gRvVNVLiSyBGPhfqejePcUmCcYxJsl5iJe04/xvKEj+qSY
	 hcg1LNKTuOjbFuh5UCmrOoHE4ll6vDLRb8VtrUtPtp1SKmm2P8/EJWooeAiaOrNcsCwZk
	 HugZm+BrASqxORCAeOEXyF35Y3mIHoj4VXQukaJ/cmjcvQeAJwo6DafoH4y1C9mCyPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fGWSR5Wr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00B2B606A32C
	for <linux-crypto@vger.kernel.org>; Sat,  7 Nov 2026 07:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fGWSR5Wr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D6921F0089F;
	Sat,  7 Nov 2026 07:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794036308;
	bh=4uPbxxqopJMnZ7ErMwn2urmrgG+FVEzHE8ZgEba/UMo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fGWSR5WrTTNeAhup2qqC/jsN9AWbf3vIClbIxqBpcJZ8WheZynSa+RnAX8g3fzRxS
	 /kYZy7BQMhq5gyGVOXBjZSCRaGNG+6qmkXaySZhUxBYO6xjB8kuCSsHoPx6BWRmZfY
	 d2Ij8C985C5YwV/Mle23/SFWqR4+HSGI/7t5t92NXWaEvxIS8SeNEvWX87Ui+gCQ8H
	 8HiQDbiz8x/fkZiXVqeJbdut61xdVdZis1eUz4nAf+4ciBGgfdsNhm7uLoLYbcDX7A
	 dA9v4RRGqXc+1z0JDYtRCEUjPeudzFN30DM4PdhTISckZStCq4WGJpLYf/xmHQEYxb
	 MqcmxokqaOahQ==
Message-ID: <sashiko-outbox-202711@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 5/8] mm: zswap: Store the folio's node id in the
 zswap_entry.
Reply-To: sashiko-reviews@lists.linux.dev
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>, hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com, chengming.zhou@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, davem@davemloft.net, linux-crypto@vger.kernel.org
Cc: rientjes@google.com, willy@infradead.org, senozhatsky@chromium.org
In-Reply-To: <20261106072412.7909-6-kanchanapsridhar2026@gmail.com>
References: <20261106072412.7909-1-kanchanapsridhar2026@gmail.com>
 <20261106072412.7909-6-kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 07 Nov 2026 07:25:07 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] mm: zswap: shrink_memcg() skips entries on nodes outside
  N_NORMAL_MEMORY
--

commit f6e1c6117279d2be409376eb57c05492fc654dea
Author: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>

mm: zswap: Store the folio's node id in the zswap_entry.

This commit stores the swapped-out folio's NUMA node ID in struct
zswap_entry for list_lru tracking and switches zswap_entry slab allocations
to be node-agnostic.

> diff --git a/mm/zswap.c b/mm/zswap.c
> index 78cf3d16b97b0..95997172db6f6 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
[ ... ]
> @@ -680,14 +685,8 @@ static int zswap_enabled_param_set(const char *val,
>  * lru functions
>  **********************************/
> =20
> -static inline int entry_to_nid(struct zswap_entry *entry)
> -{
> -	return page_to_nid(virt_to_page(entry));
> -}
> -
>  static void zswap_lru_add(struct zswap_entry *entry)
>  {
> -	int nid =3D entry_to_nid(entry);
>  	struct mem_cgroup *memcg;
> =20
>  	/*
> @@ -704,19 +703,18 @@ static void zswap_lru_add(struct zswap_entry *entry)
>  	rcu_read_lock();
>  	memcg =3D obj_cgroup_memcg(entry->objcg);
>  	/* will always succeed */
> -	list_lru_add(&zswap_list_lru, &entry->lru, nid, memcg);
> +	list_lru_add(&zswap_list_lru, &entry->lru, entry->nid, memcg);
>  	rcu_read_unlock();
>  }
[ ... ]
> @@ -1539,9 +1538,10 @@ static bool zswap_store_page(struct folio *folio, =
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
> @@ -1556,6 +1556,7 @@ static bool zswap_store_page(struct folio *folio, l=
ong index,
>  	 * to an unrelated live pool.
>  	 */
>  	entry->pool_idx =3D pool->idx;
> +	entry->nid =3D nid;

[Severity: Medium]
Can shrink_memcg() miss zswap_list_lru entries when a folio comes from a
node outside N_NORMAL_MEMORY?

Previously, entry_to_nid() derived the list_lru node ID from the GFP_KERNEL
slab page backing struct zswap_entry, which was guaranteed to be on a node
in N_NORMAL_MEMORY.  Now entry->nid is set to folio_nid(folio), and movable
swap-backed folios can reside on ZONE_MOVABLE-only or ZONE_HIGHMEM-only
nodes that are in N_MEMORY but not in N_NORMAL_MEMORY.  Because
shrink_memcg() only walks N_NORMAL_MEMORY nodes:

mm/zswap.c:shrink_memcg() {
    ...
	for_each_node_state(nid, N_NORMAL_MEMORY) {
		unsigned long nr_to_walk =3D SWAP_CLUSTER_MAX;

		shrunk +=3D list_lru_walk_one(&zswap_list_lru, nid, memcg,
					    &shrink_memcg_cb, &ctl, &nr_to_walk);
		scanned +=3D SWAP_CLUSTER_MAX - nr_to_walk;
	}
    ...
}

entries added under entry->nid for nodes outside N_NORMAL_MEMORY are
skipped by both per-cgroup and global pool limit reclaim, leaving them
unreclaimable by shrink_memcg() and causing premature zswap_store()
rejections once limits are reached.  Should shrink_memcg() iterate over
N_MEMORY instead?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106072412.7909=
-1-kanchanapsridhar2026@gmail.com?part=3D5
