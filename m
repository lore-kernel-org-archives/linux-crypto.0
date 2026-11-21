Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795234806;
	b=dSLYlGisNK/vHGRb7qPtGgkTzRb7DKNeOKe0UE49AanXPcnZdTE2xbiOykyooa+Br8KU
	 H+XgYYNEzlk0xxACGLxbdMUM3I/Y5zxAYJPJRpIvqpttDfrxvyWajGaQir16oiBeNOpWP
	 z80foiMP4BAcmzfrcGFBQiwOMRg9VT53WKnFG+xj+wmcIIga6BxJgPdEdyE1S6M2EAfgk
	 +9Op8P8NMGRcU+QnuAM2IBewi5QiEXmeRt/nTT4YGzj3H7S8UgcX/2i1eJT5AqueeH7DO
	 x+caEBdneOfyFc6bhZjMfMMUIYrc+x5ziXuPRYawpS7YO3pmYSFGlGu888HFJNiUMPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795234806;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=m3vBbC7lB+1mVcxJ5atawTX+EVeRE8qP3n/h7VzprXo=;
	b=yF1BdMlK9w4+rq72L01fQj8gbDjNQ9WSLSS7ZgSiuFBCBXlf2f6tiR/K05PCZ4+kCQgu
	 3npce77uytYJQP5P46H3TY5LOwzqpQQ+owV1YmId84hwFEOEyEIXOrFoXGzjehUpXvMGR
	 ge+0mRlcaMjDF3AXEqKvD6tWliqI25nVAJzNRa65p0oD0iuIPmjd79F8ds2f3WBMuZLF1
	 bbSXCjJ7KlHddtGgEZkKNhVn4NmuurUX10sWxz4TIpdhlJecArupPfr2TuUwnGBm0S4Ln
	 y7ILnWcH9nZoq8DXECWTIQ6p91H9Sb1V4okXmbTkO18G4ZqutR5Jmm/rdeBr97JOyLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B6h7mEeR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA16606A69D
	for <linux-crypto@vger.kernel.org>; Sat, 21 Nov 2026 04:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B6h7mEeR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E7211F000C0;
	Sat, 21 Nov 2026 04:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795234805;
	bh=m3vBbC7lB+1mVcxJ5atawTX+EVeRE8qP3n/h7VzprXo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=B6h7mEeR1Mv3qoAzE4yw+PE46Iq0LrN+52Lm/HS9ht0fe5qlh80JanfLMQfrtaZOE
	 DIm84eFrBlVtY+vuIVc7D4BEFKEg06Zwpr7Fc2S2sf1J6oJPSC322ukSfOhFGUGlYA
	 tfiHrFYJjpwDT7OQXQ3m8H5mt2mXcjwU3oN/XSVvXS2xeZxITKU7HD+pJSNBi5YJXB
	 OVLiSdC4KaLxhs5Dl0z08RqkZPF86gcKwnkVErNnpSSxHpBMWCMBH7zP9MvFIw4E1A
	 xyRaZCsPFGjRzBAd6GYanovcFiCjKDxbmbPSF8Orj8k1WFzuRuNtiTg6TRydV0Lpay
	 EWaw//njTwELg==
Message-ID: <sashiko-outbox-226635@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 5/8] mm: zswap: Store the folio's node id in the
 zswap_entry.
Reply-To: sashiko-reviews@lists.linux.dev
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>, hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com, chengming.zhou@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, davem@davemloft.net, linux-crypto@vger.kernel.org
Cc: rientjes@google.com, willy@infradead.org, senozhatsky@chromium.org
In-Reply-To: <20261120041906.5785-6-kanchanapsridhar2026@gmail.com>
References: <20261120041906.5785-1-kanchanapsridhar2026@gmail.com>
 <20261120041906.5785-6-kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 21 Nov 2026 04:20:05 +0000
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
- [Medium] mm: zswap: shrink_memcg() skips non-N_NORMAL_MEMORY nodes in
  zswap_list_lru
--

commit e4e47a21782dc39867fe81289fb7e9ed7f2692b4
Author: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>

mm: zswap: Store the folio's node id in the zswap_entry.

This commit stores the folio's NUMA node ID in struct zswap_entry and uses
it when adding and removing entries on zswap_list_lru, instead of deriving
the node ID from the slab page backing the zswap_entry.

> diff --git a/mm/zswap.c b/mm/zswap.c
> index 9a323862bd59d..78d9694f75b5e 100644
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
> @@ -1537,9 +1536,10 @@ static bool zswap_store_page(struct folio *folio, =
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
> @@ -1554,6 +1554,7 @@ static bool zswap_store_page(struct folio *folio, l=
ong index,
>  	 * to an unrelated live pool.
>  	 */
>  	entry->pool_idx =3D pool->idx;
> +	entry->nid =3D nid;

[Severity: Medium]
Can shrink_memcg() miss zswap_list_lru entries when a folio resides on a
node outside N_NORMAL_MEMORY, such as a ZONE_MOVABLE-only CXL or
hotplugged memory node?

Previously, entry_to_nid() took the node ID from the GFP_KERNEL slab page
backing struct zswap_entry, which was always in N_NORMAL_MEMORY.  Now
entry->nid is folio_nid(folio), which for GFP_HIGHUSER_MOVABLE folios can
be any node in N_MEMORY, while shrink_memcg() only walks
N_NORMAL_MEMORY:

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

Entries stored from non-N_NORMAL_MEMORY nodes will never be scanned or
written back by synchronous cgroup limit reclaim or shrink_worker().
Should shrink_memcg() iterate over N_MEMORY instead?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120041906.5785=
-1-kanchanapsridhar2026@gmail.com?part=3D5
