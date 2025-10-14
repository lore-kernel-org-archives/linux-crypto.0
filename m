Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B035B302168
	for <linux-crypto@vger.kernel.org>; Tue, 14 Oct 2025 16:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760459739; cv=none; b=KSa4T6a1tgChFIMdjCVkDzWfAQePuuWymeN+lTNv64dAsaR255u7gFeGq55sOk24ZAVgV4ZQjlopZVxXkVOQgaSQmOxcqwKYsdZ8dfnTugV670F/pfV/HEbW7ti6zQ+eQMQQs8Kj6m6+5mXJw3Hwc5VTKI4TnCEr7PsjMsqZuKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760459739; c=relaxed/simple;
	bh=aGDyEB9OenZmGSfU3L3yBFv+YHrHlX+ks8wUDepWGFw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HkZthVwca+D3nSUXCIL2IJoRefqugwElOOQQHulw7i/F68HM7/FSjtRXuvAaebJbPvfVHBFCpw8zUjUsu884nKqAJ2aPuoz6EWxb2/yZpVZCkrwJx4ApJVMUUMoLGnpJp+oxLcISPqwML3FgW3iV0sHMmvT5/zAg/pEUPAjldjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I0Cw/1V4; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I0Cw/1V4"
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-93bccd4901aso548259639f.2
        for <linux-crypto@vger.kernel.org>; Tue, 14 Oct 2025 09:35:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760459736; x=1761064536; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SqHQ2+KOI4dAk9Brl0lRqwVQjYCUh7n+OdRtoeAkV54=;
        b=I0Cw/1V42TaypHXEL7frnFu5+q1wcn8krlVA8NjL89CYOVMnXt89mSRpfR5MjsjpH9
         0haIFJ4A2prs18kiiY2Wlh+wJlbJPKEmkLF60SPpUf+QpdkN1Td90N8da53yx1BKZwGZ
         WpyWWqsKjIxel4r/8f7jvNrzl9gBWK/LKIVzDd81Z2PhG01Z8Usc91B/8JV9gTllg1fm
         J72J/OXV64ZbHcu3UpmHMBcQGQ0VWqHr+pjkiqKkcivMXdGK++fzyoyFNxjentScTU5H
         PoFJq5EAChxvrZZpPRgxYjuMEbRbuF4W8/mwvA9d44AjGyS/aU/xOuAbREAEjemm23GT
         bqAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760459736; x=1761064536;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SqHQ2+KOI4dAk9Brl0lRqwVQjYCUh7n+OdRtoeAkV54=;
        b=Wync6cwzgc4o1dsNFDCzq+XVCxBkrdwRO3+qBbege0w3rb3VC+JYIVmvcqo26TyQ0r
         zRWLqusfMibCszwUS0WRyN8k6++yE9weXx2wQClc2BFoYaDJ7y13bOgphHPZOKzMVOsM
         +ECjSeUEOgVo1spN32VqL2jQdUlb8M1GHOiL7A4OV1vOJfbyqOo5eZk53PR1vV6m0XlP
         bz6Ir7gAKc/DQzi3WtDLR5MOEapwSJbR4451+oUhpWCtXzUo/EkdQbxeSCw9met8CJN2
         nhA9sPUt6DdSZSE2tW4DqvL0YP0TcQNw48H7LuLb0y9ytIWi5LhK6Ji/KTZ7J4v9YlPS
         YEVQ==
X-Forwarded-Encrypted: i=1; AJvYcCWQhEHM4PGCeHduxgd9xN8nBZP07BvlIgCEe/puUfexYW3G+3fkhGOdEHzHZJ/IbOrUkA5EHIa/2vljI8U=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+hb5FdTKhGAUBjQiT7JQqM/FFLmI7lbDeAKAZbkRlYRoyJBab
	+24kkQNUuVNq14cVRWUPOYov9e4cQJASNmnqSocdkTWQOlxxu1nJcS8DOZpywbmxp3yIqoJKlQS
	KbdioZaNILP4oSydNzFeeAgQC8GuObYo=
X-Gm-Gg: ASbGncvmhcgZXT5TMMPtQKLx43RUfVKgjEh8Pmr6tpq/fvbVi0uAh2+6CCEMT/eySnS
	KqbO7tNN6IsC+o6pjQGzoQVcAKEcqZAl61TvObAO0VwDMHjhYCC++mTp+WdjzPtZ0ezj34fTpZv
	V+TJinrWjqNnwqmyKa8nm6AGhojxMZ3i0R2hQncW/87RnCMH0olsm+vjbdn4RCgqtG7qn06agjg
	8SIJ1vIthAfm0Jsci8cz4/RPy+u5lNQxg==
X-Google-Smtp-Source: AGHT+IEY7VUqCP/6pip0ttgbhxoRwcKJdJpXX3VVQ6uYBVkoIbhkGTsm9CuxqvphgnjFjnFOmjFQm0hmuzbL2sERn1M=
X-Received: by 2002:a05:6e02:1fca:b0:425:8d9b:c430 with SMTP id
 e9e14a558f8ab-42f873559d4mr317681995ab.6.1760459735457; Tue, 14 Oct 2025
 09:35:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
 <20250926033502.7486-23-kanchana.p.sridhar@intel.com> <2qvfjavbepw3sq2pvvcez6jsc3bxkxej27674l4ztfdza7jqaq@xi6qndkj5xhh>
 <PH7PR11MB81216AEDFD10B5BDCBCE1F19C9E6A@PH7PR11MB8121.namprd11.prod.outlook.com>
 <xnwqi5jnawvxdciqapfhhkneynsdr3dx36hmqe7jn4shm3uc3y@iyi5qqfubqey>
In-Reply-To: <xnwqi5jnawvxdciqapfhhkneynsdr3dx36hmqe7jn4shm3uc3y@iyi5qqfubqey>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 14 Oct 2025 09:35:24 -0700
X-Gm-Features: AS18NWB_RzfEOc-RbJZxwtIdj_8PcOzqcUoQW3euFgLMr1EXBSVQoQ46xhPlML4
Message-ID: <CAKEwX=NyUR6UE0PhXCaHOdta4=gVvRj7QgZtpPaLADpfXYyvZw@mail.gmail.com>
Subject: Re: [PATCH v12 22/23] mm: zswap: zswap_store() will process a large
 folio in batches.
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>, "chengming.zhou@linux.dev" <chengming.zhou@linux.dev>, 
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>, 
	"21cnbao@gmail.com" <21cnbao@gmail.com>, 
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"senozhatsky@chromium.org" <senozhatsky@chromium.org>, "sj@kernel.org" <sj@kernel.org>, 
	"kasong@tencent.com" <kasong@tencent.com>, 
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, 
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>, "davem@davemloft.net" <davem@davemloft.net>, 
	"clabbe@baylibre.com" <clabbe@baylibre.com>, "ardb@kernel.org" <ardb@kernel.org>, 
	"ebiggers@google.com" <ebiggers@google.com>, "surenb@google.com" <surenb@google.com>, 
	"Accardi, Kristen C" <kristen.c.accardi@intel.com>, "Gomes, Vinicius" <vinicius.gomes@intel.com>, 
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh" <vinodh.gopal@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 14, 2025 at 8:29=E2=80=AFAM Yosry Ahmed <yosry.ahmed@linux.dev>=
 wrote:
>
> [..]
> > > > @@ -158,6 +161,8 @@ struct zswap_pool {
> > > >   struct work_struct release_work;
> > > >   struct hlist_node node;
> > > >   char tfm_name[CRYPTO_MAX_ALG_NAME];
> > > > + u8 compr_batch_size;
> > > > + u8 store_batch_size;
> > >
> > > I don't think we need to store store_batch_size, seems trivial to
> > > calculate at store time (perhaps in a helper).
> > >
> > > Taking a step back, is there any benefit to limiting store_batch_size=
 to
> > > compr_batch_size? Is there a disadvantage to using
> > > ZSWAP_MAX_BATCH_SIZE
> > > even if it's higher than the HW compression batch size?
> >
> > Thanks Yosry, for the code review comments. I had a discussion with
> > Barry earlier on these very same topics as follow up to his review comm=
ents
> > for v11, starting with [1]. Can you please go through the rationale for
> > these design choices, and let me know if you have any questions:
> >
> > [1]: https://patchwork.kernel.org/comment/26530319/
>
> I am surprised that calculating the value in zswap_store() causes a
> regression, but I am fine with keeping the precalculation in this case.
>
> I think there's a bigger problem here tho, more below.
>
> > > > + */
> > > > +static __always_inline int zswap_entries_cache_alloc_batch(void
> > > **entries,
> > > > +                                                    unsigned int
> > > nr_entries,
> > > > +                                                    gfp_t gfp)
> > > > +{
> > > > + return kmem_cache_alloc_bulk(zswap_entry_cache, gfp, nr_entries,
> > > entries);
> > >
> > > We currently use kmem_cache_alloc_node() in zswap_entry_cache_alloc()=
 to
> > > allocate the entry on the same node as the compressed page. We use
> > > entry_to_nid() to get the node for LRU operations.
> > >
> > > This breaks that assumption.
> >
> > You bring up a good point. I was looking at the code in slub.c and my
> > understanding thus far is that both, bulk allocations and kmem_cache_al=
loc_node()
> > allocations are made from a per-CPU "cpu_slab" that is allocated by SLU=
B.
> >
> > IIUC, the concern you are raising is in the mainline, the entry is allo=
cated on
> > the same node as the compressed page, and gets added to the LRU list of=
 that
> > node. IOW, the node to which the compressed page belongs is the one to =
whose
> > LRU the entry will be added.
> >
> > With this patch, with kmem_cache_alloc_bulk(), the entry will be create=
d on
> > the per-CPU slab of the CPU on which zswap_store() is called and will b=
e
> > added to the LRU of that per-CPU slab's NUMA node. Hence, the end resul=
t
> > could potentially be that the zswap_entry for a page could potentially =
be
> > on a different NUMA node/memcg than the page's NUMA node.

I think only the NUMA node is the problem, not the memcg.

> >
> > This is my thinking as to how this will impact the zswap shrinker:
> >
> > 1) memcg shrinker: if the memcg the entry ends up in is on the zswap_li=
st_lru,
> >     the entry will be written back.
> > 2) Global shrinker: will cycle through all memcg's that have pages in t=
he
> >     zswap_list_lru, and the entry will be written back.
> >
> > Based on this, it is not clear to me if there is a problem, and would l=
ike to
> > request you, Nhat and others to provide insights as well.
> >
> > Interestingly, most of the code in slub.c has unlikely(!node_match(slab=
, node)).
> > Does this imply some higher level mm slab allocation requirements?
> >
> > I am Ok with just calling zswap_entry_cache_alloc() for "nr_pages" if w=
e
> > think this would be more correct.
>
> I saw your other response as well, but I think one thing is not clear
> here. The zswap entry will get written back "eventually", sure, but
> that's not the problem.
>
> If the zswap entry is on the wrong node lru, two things happen:
> (a) When the "right" node is under memory pressure, we cannot free this
>     entry by writing it back since it's not available in the lru.
> (b) When the "wrong" node is under memory pressure, it will potentially
>     writeback entries from other nodes AND report them as being freed
>     from this node.
>
> Both (a) and (b) cause less effective reclaim from the zswap shrinker.
> Additionally (b) causes the shrinker to report the wrong amount of freed
> memory from the node. While this may not be significant today, it's very
> possible that more heuristics start relying on this number in the
> future.
>
> I don't believe we should put zswap entries on the wrong LRU, but I will
> defer to Nhat for the final verdict if he has a different opinion.

Oh shoot. Yeah I missed that part.

In the past, we sort of did not care - zswap was very poorly designed
for NUMA architecture in general, and most of our test setups have
been single-node, so these kinds of discrepancies did not show up in
performance numbers.

But we are getting more multi-node systems:

1. Bigger hosts (memory-wise) tend to also have more than one nodes.
It scales better that way (especially because a lot of structures and
locks protecting them are node-partitioned).

2. We have also seen different memory media that are often expressed
to the kernel as nodes: CXL, GPU memory, etc.

This will necessitate tightening memory placement. We recently had to
fix one such issue:

https://github.com/torvalds/linux/commit/56e5a103a721d0ef139bba7ff3d3ada6c8=
217d5b

So I'm a bit nervous about this change, which will make us use the wrong LR=
U...

Some work around:

1. Can we squeeze an extra int field anywhere in struct zswap_entry?

2. Can we pump nid all the way to zswap_lru_add()?

This is still not 100% ideal - the metadata (struct zswap_entry) will
still be allocated on the wrong node. But at least the data are
properly managed, i.e on the right LRU.

>
> > >
> > > Does it actually matter if we do the initializations here vs. right
> > > before inserting to the LRU (current behavior)?
> >
> > Yes, it impacts batching performance with software quite a bit.
>
> Taking a step back, based on discussions in this thread and others, it
> seems like the performance of zswap_store() is very sensitive to minor
> changes like this one, calculating the store size, etc.
>
> I don't recall this being the case before this patch series. It seems
> like an artifact of batching affecting performance negatively and
> a collection of micro-optimizations and "correct" placement of code/data
> to fix it. This seems to be very fragile.

I agree. This seems troubling.

What's the variance of your benchmark results, Kanchana? I have found
that kernel build tests can have quite a bit of variance, but is it as
big as the performance difference of these minor changes (i.e, can it
explain the "regression")?

>
> It is very possible that an incoming change will move the
> initializations or make other changes to the code, that will seemingly
> cause regressions when they really shouldn't.
>
> Additionally, what may seem optimal on the CPU you are testing on maybe
> be suboptimal for other CPUs. I think the big problem here is not where
> to initialize the entry or whether to precompute the store batch size,
> it's why the code has become extremely sensitive to these changes when
> it shouldn't be. zswap_store() is not a fast path by any means, and
> people will not expect such changes to cause meaningful regressions.

Agree. These micro-optimizations seem very fragile.

>
> >
> > >
> > > > + for (i =3D 0; i < nr_pages; ++i) {
> > > > +         entries[i]->handle =3D (unsigned long)ERR_PTR(-EINVAL);
> > > > +         entries[i]->pool =3D pool;
> > > > +         entries[i]->swpentry =3D page_swap_entry(folio_page(folio=
,
> > > start + i));
> > > > +         entries[i]->objcg =3D objcg;
> > > > +         entries[i]->referenced =3D true;
> > > > +         INIT_LIST_HEAD(&entries[i]->lru);
> > > > + }
> > > >
> > > > - old =3D xa_store(swap_zswap_tree(page_swpentry),
> > > > -                swp_offset(page_swpentry),
> > > > -                entry, GFP_KERNEL);
> > > > - if (xa_is_err(old)) {
> > > > -         int err =3D xa_err(old);
> > > > + for (i =3D 0; i < nr_pages; ++i) {
> > > > +         struct page *page =3D folio_page(folio, start + i);
> > > >
> > > > -         WARN_ONCE(err !=3D -ENOMEM, "unexpected xarray error:
> > > %d\n", err);
> > > > -         zswap_reject_alloc_fail++;
> > > > -         goto store_failed;
> > > > +         if (!zswap_compress(page, entries[i], pool, folio_wb))
> > > > +                 goto store_pages_failed;
> > > >   }
> > > >
> > > > - /*
> > > > -  * We may have had an existing entry that became stale when
> > > > -  * the folio was redirtied and now the new version is being
> > > > -  * swapped out. Get rid of the old.
> > > > -  */
> > > > - if (old)
> > > > -         zswap_entry_free(old);
> > > > + for (i =3D 0; i < nr_pages; ++i) {
> > > > +         struct zswap_entry *old, *entry =3D entries[i];
> > > >
> > > > - /*
> > > > -  * The entry is successfully compressed and stored in the tree, t=
here is
> > > > -  * no further possibility of failure. Grab refs to the pool and o=
bjcg,
> > > > -  * charge zswap memory, and increment zswap_stored_pages.
> > > > -  * The opposite actions will be performed by zswap_entry_free()
> > > > -  * when the entry is removed from the tree.
> > > > -  */
> > > > - zswap_pool_get(pool);
> > > > - if (objcg) {
> > > > -         obj_cgroup_get(objcg);
> > > > -         obj_cgroup_charge_zswap(objcg, entry->length);
> > > > - }
> > > > - atomic_long_inc(&zswap_stored_pages);
> > > > - if (entry->length =3D=3D PAGE_SIZE)
> > > > -         atomic_long_inc(&zswap_stored_incompressible_pages);
> > > > +         old =3D xa_store(swap_zswap_tree(entry->swpentry),
> > > > +                        swp_offset(entry->swpentry),
> > > > +                        entry, GFP_KERNEL);
> > > > +         if (unlikely(xa_is_err(old))) {
> > > > +                 int err =3D xa_err(old);
> > > >
> > > > - /*
> > > > -  * We finish initializing the entry while it's already in xarray.
> > > > -  * This is safe because:
> > > > -  *
> > > > -  * 1. Concurrent stores and invalidations are excluded by folio l=
ock.
> > > > -  *
> > > > -  * 2. Writeback is excluded by the entry not being on the LRU yet=
.
> > > > -  *    The publishing order matters to prevent writeback from seei=
ng
> > > > -  *    an incoherent entry.
> > > > -  */
> > > > - entry->pool =3D pool;
> > > > - entry->swpentry =3D page_swpentry;
> > > > - entry->objcg =3D objcg;
> > > > - entry->referenced =3D true;
> > > > - if (entry->length) {
> > > > -         INIT_LIST_HEAD(&entry->lru);
> > > > -         zswap_lru_add(&zswap_list_lru, entry);
> > > > +                 WARN_ONCE(err !=3D -ENOMEM, "unexpected xarray
> > > error: %d\n", err);
> > > > +                 zswap_reject_alloc_fail++;
> > > > +                 /*
> > > > +                  * Entries up to this point have been stored in t=
he
> > > > +                  * xarray. zswap_store() will erase them from the
> > > xarray
> > > > +                  * and call zswap_entry_free(). Local cleanup in
> > > > +                  * 'store_pages_failed' only needs to happen for
> > > > +                  * entries from [@i to @nr_pages).
> > > > +                  */
> > > > +                 store_fail_idx =3D i;
> > > > +                 goto store_pages_failed;
> > > > +         }
> > > > +
> > > > +         /*
> > > > +          * We may have had an existing entry that became stale wh=
en
> > > > +          * the folio was redirtied and now the new version is bei=
ng
> > > > +          * swapped out. Get rid of the old.
> > > > +          */
> > > > +         if (unlikely(old))
> > > > +                 zswap_entry_free(old);
> > > > +
> > > > +         /*
> > > > +          * The entry is successfully compressed and stored in the=
 tree,
> > > there is
> > > > +          * no further possibility of failure. Grab refs to the po=
ol and
> > > objcg,
> > > > +          * charge zswap memory, and increment
> > > zswap_stored_pages.
> > > > +          * The opposite actions will be performed by
> > > zswap_entry_free()
> > > > +          * when the entry is removed from the tree.
> > > > +          */
> > >
> > > But there *is* further possibility of failure if a subsequent entry
> > > xa_store() fails, right?
> >
> > This comment is referring to this specific entry.
>
> I think it's currently misleading in its current form. Perhaps:
>
> The entry is successfully compressed and stored in the tree, and further
> failures will be cleaned up in zswap_store().
>
> >
> > >
> > > Seems like if xa_store() fails we do not cleanup previously charged
> > > objects, pool references, zswap_stored_pages, etc. Instead of rolling
> > > all this back on failure, can we do all the xarray stores first and o=
nly
> > > do the rest when we're at a point where no failure can happen? Would
> > > that cause a performance regression?
> >
> > It would make the code more complicated and thus cause a performance
> > regression. I have tried to balance code simplicity (which impacts perf=
ormance)
> > with correctness here. The "store_failed_idx" ensures that all partial =
work done
> > in zswap_store_pages() for this batch, is cleaned up.
> >
> > The rest is handled in zswap_store() when it sees an error returned by
> > zswap_store_pages().
>
> Right, I missed the part about zswap_store() handling this, the comment
> above confused me.
