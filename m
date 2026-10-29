Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793315370;
	b=i/1/gVyJK/66IbuQGFQYZExXfpFy0TJIu6+RKooa+XtzgBd6227uFRKDESe2WlzYzSTb
	 Zmcju3TliMp3EXLMR3OV1K+AOlC1qoTIY8owaw2bB/C8YorS9w0JRSkjrRJ8SDRexuFdO
	 q+TMmHgeAbEmK8ZqEeTuwX9KTXeyz4tMhtH8F5BV0D8YzDYruKUQCIbsj0DNQpn4YWDob
	 TA1ANYFjwdLhY2A2FBAe5E3l3dVfFZw+xwM4XMW/UWmOWA+fRdIaSLy0CnHZoTGuYBuML
	 3YnihBGN6TIIemtr1P7+BVcZ2DO2mIc5mfq+Ykgn1tnLAKmEehp6E7DVjEorsoOqFsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793315370;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=SxAccaK9CQKKqijAxHgkuHdJDdULygHNWNh9e96YezM=;
	b=wth2MERONoGMMVKPOcUXv15asUbdfEMnXgZcWskcAZnAIsRm5KrVhtA4ko6ojQJoN63o
	 KsYKfT7u1c8G1pZLqV+D+2qg9UpK/uBohUu88v4RlSjUWiEhnfZv5VcNeaV9IxvG9cAOM
	 g49DFcFkaYqge1UL035v9nUI/j6OHAIerqBMq2F0wjhvo9EELDcSvj+Xvno+CpCqnNDuT
	 d1lcYKiumXupd4O07/tGhjcRmSEW9AqcT8+tH5tGfdUy7/eOq5pJaS2jUI5vJ/6BE4uIs
	 uTWzMcs+UjCc6h5FISidNuJAL4cs0RXkKn14XyDVuJcEzfBKM9c7sWNEe5h014uS2Yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cd9jirO9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22193606A31C
	for <linux-crypto@vger.kernel.org>; Thu, 29 Oct 2026 23:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cd9jirO9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D77841F031E4
	for <linux-crypto@vger.kernel.org>; Thu, 29 Oct 2026 23:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793315369;
	bh=SxAccaK9CQKKqijAxHgkuHdJDdULygHNWNh9e96YezM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=cd9jirO9W/+vRVFDbjADdAp0u5N2Kmb/GKL7qLaLbHWNxWybKDCURefBIedJUWnSS
	 6/wCareaJPxjAlus2f3zM2c20cRCt++ZPhvdB1eub4OjUE17sps3XjTueKFNY6BJTd
	 2Wmjt0iPz3673rly56jk1ku90ZOCLY5peM14pb9bt9+oDmgB/Mo3IU6CiHhS+Rb1wG
	 Cus/8q3uLUxCRYz5DwNQzGsMKWPXQMkxq7K6Xlebz6PMuKumBDGsNfq4xIQHIDdizP
	 ZQoTXC7m2Hg6OoXbc8mBkHDkA7pnZPa4sCpKCab2s2irMensJU2Zxb7MreQLSAcCyk
	 z/MUB6SsJ+pqQ==
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6b45f9ec1ceso84436a12.2
        for <linux-crypto@vger.kernel.org>; Thu, 29 Oct 2026 16:09:29 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzlu5W8cv+bRYtr9dqqxzqIs+5PrQl6lnHp7dYpN+mRz3inI7SJ3Ph1ZtNWXfqk0mpySBrSyfLHc0a3p2Q=@vger.kernel.org
X-Gm-Message-State: AFq9FYJQocasPOWR75rILMtPa+W2j7fJh+TCv/g1QPnflcOrPYENGhij
	eOr7AFMBYLeL+G3P4qHZzx+mv86eAGT+aINAHHySkXnV8fSvX9h9hxgOiFoHkx/TZdkTo2xmk4B
	Tj5tzRVsaC3RbGRzSY3U5IjcMT7eJwAs=
X-Received: by 2002:a17:907:6c17:b0:c41:9228:baef with SMTP id
 a640c23a62f3a-c4ca7a54fa0mr46411166b.8.1793315368743; Thu, 29 Oct 2026
 16:09:28 -0700 (PDT)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
 <20261028030503.17923-6-kanchanapsridhar2026@gmail.com> <sashiko-outbox-188657@kernel.org>
 <CACpmpofjVP17TpyieQ2khsdRL+FMX9oCEcaNE9Hh+vBfGBO2dA@mail.gmail.com>
In-Reply-To: <CACpmpofjVP17TpyieQ2khsdRL+FMX9oCEcaNE9Hh+vBfGBO2dA@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 29 Oct 2026 16:09:16 -0700
X-Gmail-Original-Message-ID: <CAO9r8zMxUZxWjZaRx8ZK69qQBmd9EQ3OY3kv8DDVsuDky_7Axg@mail.gmail.com>
X-Gm-Features: AclHuK88KyLz-z--PbBy0WnVbdAZWcqI-BsmnnLL1fm3tmu9BUUE_ZogzqpNpS0
Message-ID: <CAO9r8zMxUZxWjZaRx8ZK69qQBmd9EQ3OY3kv8DDVsuDky_7Axg@mail.gmail.com>
Subject: Re: [PATCH v2 5/8] mm: zswap: Store the folio's node id in the zswap_entry.
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: sashiko-reviews@lists.linux.dev, hannes@cmpxchg.org, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org, 
	herbert@gondor.apana.org.au, davem@davemloft.net, 
	linux-crypto@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> > > @@ -1507,9 +1506,10 @@ static bool zswap_store_page(struct folio *fol=
io, long index,
> > >  {
> > >       swp_entry_t page_swpentry =3D folio_swap_entry(folio, index);
> > >       struct zswap_entry *entry, *old;
> > > +     int nid =3D folio_nid(folio);
> > >
> > >       /* allocate entry */
> > > -     entry =3D zswap_entry_cache_alloc(GFP_KERNEL, folio_nid(folio))=
;
> > > +     entry =3D zswap_entry_cache_alloc(GFP_KERNEL);
> > >       if (!entry) {
> > >               zswap_reject_kmemcache_fail++;
> > >               return false;
> > > @@ -1524,6 +1524,7 @@ static bool zswap_store_page(struct folio *foli=
o, long index,
> > >        * to an unrelated live pool.
> > >        */
> > >       entry->pool_idx =3D pool->idx;
> > > +     entry->nid =3D nid;
> >
> > [Severity: Medium]
> > What happens during cgroup or pool reclaim in shrink_memcg() if the swa=
pped
> > folio resides on a NUMA node without normal memory (for example, a
> > ZONE_MOVABLE-only or ZONE_HIGHMEM-only node)?
> >
> > Previously, entry_to_nid() derived the node from virt_to_page(entry), w=
hich
> > was allocated from slab with GFP_KERNEL and therefore always resided on=
 a
> > node in N_NORMAL_MEMORY.
> >
> > With entry->nid now set to folio_nid(folio) in zswap_store_page(), anon=
ymous
> > and shmem folios allocated with GFP_HIGHUSER_MOVABLE can have an entry-=
>nid
> > that is in N_MEMORY, but not in N_NORMAL_MEMORY. zswap_lru_add() insert=
s
> > those entries into zswap_list_lru for entry->nid, but shrink_memcg() on=
ly
> > walks N_NORMAL_MEMORY nodes:
> >
> > mm/zswap.c:shrink_memcg() {
> >     ...
> >         for_each_node_state(nid, N_NORMAL_MEMORY) {
> >                 unsigned long nr_to_walk =3D SWAP_CLUSTER_MAX;
> >
> >                 shrunk +=3D list_lru_walk_one(&zswap_list_lru, nid, mem=
cg,
> >                                             &shrink_memcg_cb, NULL, &nr=
_to_walk);
> >                 scanned +=3D SWAP_CLUSTER_MAX - nr_to_walk;
> >         }
> > }
> >
> > Should shrink_memcg() iterate over N_MEMORY instead of N_NORMAL_MEMORY =
so
> > that entries from movable-only or highmem-only nodes can be reclaimed b=
y
> > shrink_worker() and mem_cgroup_try_charge_zswap()?
>
> Conversely, is the previous behavior correct? The entry is created on
> a node in N_NORMAL_MEMORY, and when that node is under memory pressure
> the folio (allocated on ZONE_MOVABLE-only or ZONE_HIGHMEM-only node)
> could get written back. This doesn't resolve the memory pressure for
> the node on which the entry is allocated.

Yeah I think the previous behavior might be wrong if Sashiko is right
about the slab not being on the same node as the page.

>
> Nhat/Yosry/Johannes: Does Sashiko's suggestion for the shrink_memcg()
> modification look Ok to you?

It seems correct from a high-level but I didn't look closely.


>
> Thanks,
> Kanchana
> >
> > --
> > Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261028030503.=
17923-1-kanchanapsridhar2026@gmail.com?part=3D5
