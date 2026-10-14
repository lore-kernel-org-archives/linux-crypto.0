Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0200D54528F
	for <linux-crypto@vger.kernel.org>; Wed, 14 Oct 2026 15:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791991059; cv=none; b=pIsLEFY1R9v5P6mr3P8r1awR6WE3weDr/i6Bh6b0M/Vdi3BWos0d6+DsRjgSqk7f7weA+JrbKMmr80b96HPrj+l4puZdBZ7PfsMmCRAY/IHcsoI/Z6/3dvhSXR4fZXb2cUqvlpoAn4ws+6xWtWdRHIfI7hyMT4qDcVkORMMMmEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791991059; c=relaxed/simple;
	bh=vNerpuuZLI7loM8/rKJpG2hQ/ndg9Py+tx+BsMldyWA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YvW3Ub3YMORF5562tGGGIWymulp+JWXDmklMQP/iMN/f2/iCVI4JzhXAU/XKM/Hlv9YpQjmth6JiU0UYn20zeSLOkgbGYYRNrihLWXUloqMiNrjPIZMbGLGsGSmT6msr7CYamQnYIpUgXBozSniWaMU1jZZMXgooAGTa1QDb/l4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VqCGFG0F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VqCGFG0F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 741661F000C5
	for <linux-crypto@vger.kernel.org>; Wed, 14 Oct 2026 15:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791991057;
	bh=TGg9zLBzBGi2zH1vsZ4XSrJ5/M5hqhcjBRGfXtJNFlo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=VqCGFG0FjtcUuILwpPuGdgHtuCcBWADJQSszoq4KNyqk+L4Liax3tsJJQFJZYSKRJ
	 D6qyT4hX2CUbDHcf2zbFpS+nDHPAIgBxFZectfIWi+E6FSl8w6VI7ARC3HUAJ+N+XU
	 309UyiyWVkx5scKU8zQiT8PXJYzEhQXRdhNgt5pM2PuEpj270Affsx1oD5Os6RD7Lg
	 32Qa1w1Ol53KMIvzB7Dq5VURnvmuLRVxl0e9ssf9pGcLKOPWT2Diqeh9dZZr2f/mov
	 qKVPxYOkGtwsAiRIv5cUG76DEfeO8ciB47l62LJy3sJtvwWBBq3ezv4JMiD9rFJDrL
	 cvoM0S2rLWalw==
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c315729ad50so700827966b.0
        for <linux-crypto@vger.kernel.org>; Wed, 14 Oct 2026 08:17:37 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzVNcQczPJh4IBvoGIbaHO7qxYRi0OhkBxyD2t3Z+e/L9VKpHeTf3ztYO5JtzpPMPI5/iUrvJGvZJRIN54=@vger.kernel.org
X-Gm-Message-State: AFq9FYI3VXPCtpkzNGrB0xX3BoIipB23Raj5jZqvSFRq258crkqDPYIS
	PkInPaXwqgmOZTLv1EiazltOQtGltRpQTCOiTKkLWYAhWH57FmuoHLP85ZR9kS2IA3MmFjOkq1v
	aGjy4yLQJGZdXTR6KAch0bj2ZzaCCvJQ=
X-Received: by 2002:a17:907:1997:b0:c2d:c98f:4824 with SMTP id
 a640c23a62f3a-c31aa057064mr1511236766b.30.1791991056352; Wed, 14 Oct 2026
 08:17:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
 <20261008182814.27450-6-kanchanapsridhar2026@gmail.com> <as7JC8o2kggiq_ss@google.com>
 <CACpmpofXMGBP70Rn7jHLwOF38GRKMUGoW3rb1Jp2SPH7ygKcfw@mail.gmail.com>
In-Reply-To: <CACpmpofXMGBP70Rn7jHLwOF38GRKMUGoW3rb1Jp2SPH7ygKcfw@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Wed, 14 Oct 2026 08:17:24 -0700
X-Gmail-Original-Message-ID: <CAO9r8zOEcGmg8eVttu41htugnng0ahnVQbubiJfxVH+GfDe47Q@mail.gmail.com>
X-Gm-Features: AclHuK-ehxXi7A0e1gRS8w_1Qe3FwN4I9eAdtlth0BvoDqVKzvl-jH6zB_7Y6xQ
Message-ID: <CAO9r8zOEcGmg8eVttu41htugnng0ahnVQbubiJfxVH+GfDe47Q@mail.gmail.com>
Subject: Re: [PATCH v1 5/8] mm: zswap: Store the folio's node id in the zswap_entry.
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 13, 2026 at 6:17=E2=80=AFPM Kanchana P. Sridhar
<kanchanapsridhar2026@gmail.com> wrote:
>
> On Tue, Oct 13, 2026 at 5:18=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wr=
ote:
> >
> > On Thu, Oct 08, 2026 at 11:28:11AM -0700, Kanchana P. Sridhar wrote:
> > > When storing a folio in zswap, save the folio's node id in the zswap
> > > entry instead of relying on the zswap_entry being allocated on the sa=
me
> > > node. This enables optimizations such as batch allocation of zswap
> > > entries for large folios using kmem_cache_alloc_bulk() that does not
> > > support specifying a node id.
> > >
> > > The size of the zswap_entry remains unchanged as 'referenced' is lump=
ed
> > > in with the 'length' (as it doesn't need a full unsigned int anyway).
> > >
> > > Suggested-by: Nhat Pham <nphamcs@gmail.com>
> > > Suggested-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > > Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> > > Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
> > > ---
> > >  mm/zswap.c | 23 +++++++++++------------
> > >  1 file changed, 11 insertions(+), 12 deletions(-)
> > >
> > > diff --git a/mm/zswap.c b/mm/zswap.c
> > > index ca513a9f89e3..c2731d3acb2c 100644
> > > --- a/mm/zswap.c
> > > +++ b/mm/zswap.c
> > > @@ -194,6 +194,7 @@ static struct shrinker *zswap_shrinker;
> > >   *              writeback logic. The entry is only reclaimed by the =
writeback
> > >   *              logic if referenced is unset. See comments in the sh=
rinker
> > >   *              section for context.
> > > + * nid - NUMA node id of the page for which this is the zswap entry.
> > >   * pool_idx - id of the zswap_pool that the entry's data is in.
> > >   * handle - zsmalloc allocation handle that stores the compressed pa=
ge data
> > >   * objcg - the obj_cgroup that the compressed memory is charged to
> > > @@ -201,8 +202,11 @@ static struct shrinker *zswap_shrinker;
> > >   */
> > >  struct zswap_entry {
> > >       swp_entry_t swpentry;
> > > -     unsigned int length;
> > > -     bool referenced;
> > > +     struct {
> > > +             unsigned int length:31;
> > > +             bool referenced:1;
> > > +     };
> > > +     int nid;
> >
> > This will increase the size of the struct now with pool_idx, right?
>
> I was gathering the struct size with the struct {unsigned int
> length:31; bool referenced:1} as suggested in v14, for my before/after
> comparisons:
>
> before:
> struct zswap_entry {
>         swp_entry_t                swpentry;             /*     0     8 *=
/
>         struct {
>                 unsigned int       length:31;            /*     8: 0  4 *=
/
>
>                 /* Bitfield combined with next fields */
>
>                 bool               referenced:1;         /*    11: 7  1 *=
/
>         };                                               /*     8     4 *=
/
>         int                        nid;                  /*    12     4 *=
/
>         u8                         pool_idx;             /*    16     1 *=
/
>
>         /* XXX 7 bytes hole, try to pack */
>
>         long unsigned int          handle;               /*    24     8 *=
/
>         struct obj_cgroup *        objcg;                /*    32     8 *=
/
>         struct list_head           lru;                  /*    40    16 *=
/
>
>         /* size: 56, cachelines: 1, members: 7 */
>         /* sum members: 49, holes: 1, sum holes: 7 */
>         /* last cacheline: 56 bytes */
> };
>
> after:
> struct zswap_entry {
>         swp_entry_t                swpentry;             /*     0     8 *=
/
>         struct {
>                 unsigned int       length:31;            /*     8: 0  4 *=
/
>
>                 /* Bitfield combined with next fields */
>
>                 bool               referenced:1;         /*    11: 7  1 *=
/
>         };                                               /*     8     4 *=
/
>         int                        nid;                  /*    12     4 *=
/
>         long unsigned int          handle;               /*    16     8 *=
/
>         struct obj_cgroup *        objcg;                /*    24     8 *=
/
>         struct list_head           lru;                  /*    32    16 *=
/
>         u8                         pool_idx;             /*    48     1 *=
/
>
>         /* size: 56, cachelines: 1, members: 7 */
>         /* padding: 7 */
>         /* last cacheline: 56 bytes */
> };
>
> And decided to go with the placement in patch 7, since it also
> separates out members by compress/decompress path accesses. pool_idx
> is set once, and never changes. Further, moving pool_idx to the end
> gets rid of holes.

Please look at the layout I pasted (quoted below). Your patch
increases the struct size from 48 bytes to 56 bytes, undoing the
optimization introduced by pool_idx. We need to pack length, pool_idx,
and referenced in a single u32 to keep the size constant.

FWIW, moving pool_idx to the end just trades holes for padding, I am
not sure if that's necessarily an improvement.

>
> >
> > Before you patch on x86_64:
> >
> > struct zswap_entry {
> >         swp_entry_t                swpentry;             /*     0     8=
 */
> >         unsigned int               length;               /*     8     4=
 */
> >         bool                       referenced;           /*    12     1=
 */
> >         u8                         pool_idx;             /*    13     1=
 */
> >
> >         /* XXX 2 bytes hole, try to pack */
> >
> >         unsigned long              handle;               /*    16     8=
 */
> >         struct obj_cgroup *        objcg;                /*    24     8=
 */
> >         struct list_head           lru;                  /*    32    16=
 */
> >
> >         /* size: 48, cachelines: 1, members: 7 */
> >         /* sum members: 46, holes: 1, sum holes: 2 */
> >         /* last cacheline: 48 bytes */
> > };
> >
> > After:
> >
> > struct zswap_entry {
> >         swp_entry_t                swpentry;             /*     0     8=
 */
> >         struct {
> >                 unsigned int       length:31;            /*     8: 0  4=
 */
> >
> >                 /* Bitfield combined with next fields */
> >
> >                 bool               referenced:1;         /*    11: 7  1=
 */
> >         };                                               /*     8     4=
 */
> >         struct {
> >                 unsigned int               length:31;            /*    =
 0: 0  4 */
> >
> >                 /* Bitfield combined with next fields */
> >
> >                 bool                       referenced:1;         /*    =
 3: 7  1 */
> >
> >                 /* size: 4, cachelines: 1, members: 2 */
> >                 /* last cacheline: 4 bytes */
> >         };
> >
> >         int                        nid;                  /*    12     4=
 */
> >         u8                         pool_idx;             /*    16     1=
 */
> >
> >         /* XXX 7 bytes hole, try to pack */
> >
> >         unsigned long              handle;               /*    24     8=
 */
> >         struct obj_cgroup *        objcg;                /*    32     8=
 */
> >         struct list_head           lru;                  /*    40    16=
 */
> >
> >         /* size: 56, cachelines: 1, members: 7 */
> >         /* sum members: 49, holes: 1, sum holes: 7 */
> >         /* last cacheline: 56 bytes */
> > };
> >
> > I think we want to reorder the fields. We can probably also avoid the
> > bitfield if the maximum page size is 64K (is it?)
>
> It seems on ARM64, the max page size is 64K, however on PPC, it can be
> 256K. So it appears we need at least 18 bits on currently supported
> architectures.

In this case unfortunately we need to stick with bitfields. We should
probably add a build-time assertion that the width of length is enough
to cover PAGE_SIZE.

> If you agree with the pool_idx placement to be moved to the end as
> proposed in patch 7, I can try and optimize this further, by limiting
> the "unsigned int length:18", if you think this makes sense.

I don't think we can put pool_idx to the end and keep the struct size
constant. For length, yeah let's use the minimum number of bits needed
and add an assertion, so that the free to use bits are obvious.

>
> >
> > struct zswap_entry {
> >         swp_entry_t                swpentry;             /*     0     8=
 */
> >         u16                        length;               /*     8     2=
 */
> >         u8                         pool_idx;             /*    10     1=
 */
> >         bool                       referenced;           /*    11     1=
 */
> >         int                        nid;                  /*    12     4=
 */
> >         unsigned long              handle;               /*    16     8=
 */
> >         struct obj_cgroup *        objcg;                /*    24     8=
 */
> >         struct list_head           lru;                  /*    32    16=
 */
> >
> >         /* size: 48, cachelines: 1, members: 8 */
> >         /* last cacheline: 48 bytes */
> > };
> >
> >
> > >       u8 pool_idx;
> > >       unsigned long handle;
> > >       struct obj_cgroup *objcg;
> > > @@ -672,14 +676,8 @@ static int zswap_enabled_param_set(const char *v=
al,
> > >  * lru functions
> > >  **********************************/
> > >
> > > -static inline int entry_to_nid(struct zswap_entry *entry)
> > > -{
> > > -     return page_to_nid(virt_to_page(entry));
> > > -}
> > > -
> > >  static void zswap_lru_add(struct zswap_entry *entry)
> > >  {
> > > -     int nid =3D entry_to_nid(entry);
> > >       struct mem_cgroup *memcg;
> > >
> > >       /*
> > > @@ -696,19 +694,18 @@ static void zswap_lru_add(struct zswap_entry *e=
ntry)
> > >       rcu_read_lock();
> > >       memcg =3D obj_cgroup_memcg(entry->objcg);
> > >       /* will always succeed */
> > > -     list_lru_add(&zswap_list_lru, &entry->lru, nid, memcg);
> > > +     list_lru_add(&zswap_list_lru, &entry->lru, entry->nid, memcg);
> > >       rcu_read_unlock();
> > >  }
> > >
> > >  static void zswap_lru_del(struct zswap_entry *entry)
> > >  {
> > > -     int nid =3D entry_to_nid(entry);
> > >       struct mem_cgroup *memcg;
> > >
> > >       rcu_read_lock();
> > >       memcg =3D obj_cgroup_memcg(entry->objcg);
> > >       /* will always succeed */
> > > -     list_lru_del(&zswap_list_lru, &entry->lru, nid, memcg);
> > > +     list_lru_del(&zswap_list_lru, &entry->lru, entry->nid, memcg);
> > >       rcu_read_unlock();
> > >  }
> > >
> > > @@ -1449,9 +1446,10 @@ static bool zswap_store_page(struct folio *fol=
io, long index,
> > >  {
> > >       swp_entry_t page_swpentry =3D folio_swap_entry(folio, index);
> > >       struct zswap_entry *entry, *old;
> > > +     int nid =3D folio_nid(folio);
> > >
> > >       /* allocate entry */
> > > -     entry =3D zswap_entry_cache_alloc(GFP_KERNEL, folio_nid(folio))=
;
> > > +     entry =3D zswap_entry_cache_alloc(GFP_KERNEL, nid);
> >
> > We don't need to allocate the entry on the same node anymore, should we
> > drop this and let the slab allocator handle it as it sees fit?
>
> Was this a recent change? I see the folio_nid(folio) on my version of
> mm-unstable as of 10-3-2026. Let me check, and yes, allowing the slab
> allocated handle this is probably a good idea.

We allocate the entry on the same node to avoid having to store nid in
the zswap entry (see entry_to_nid()). If we store it, then there's no
need to allocate on the node.

>
> Along the same lines, I have been working on replacing zsmalloc with
> direct SLAB allocations for the zswap compressed data storage and see
> very promising results: memory savings and latency improvements. I
> will submit an RFC shortly.

Keep in mind that zsmalloc is movable memory, while slab memory isn't.
Zsmalloc may also be less likely to make a new allocation in the store
path. There are other considerations beyond memory overhead and
latency here.

>
> >
> > >       if (!entry) {
> > >               zswap_reject_kmemcache_fail++;
> > >               return false;
> > > @@ -1466,6 +1464,7 @@ static bool zswap_store_page(struct folio *foli=
o, long index,
> > >        * to an unrelated live pool.
> > >        */
> > >       entry->pool_idx =3D pool->idx;
> > > +     entry->nid =3D nid;
> > >
> > >       old =3D xa_store(swap_zswap_tree(page_swpentry),
> > >                      swp_offset(page_swpentry),
> > > --
> > > 2.39.5
> > >
