Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B780481DD;
	Thu, 14 Aug 2025 21:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755205519; cv=none; b=rx14Znk0HWwK/vV41NlLsKsMagM0EO6isLHh0R9KDRMAENbTgkyyi5JjNnESullvX9FsGfk50FZ1g4+hAq4zOnDGQLBO2f72pw253M1vh9nSJyY5QYpMw7XfosyRi/NkvieAVYnEBFGBZ7+GELqWqoQJmt6srni3+7QvbI39w84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755205519; c=relaxed/simple;
	bh=Frky4N//ppJVk/g5TYCN8AE1vQuheM2iekSiyykvSFM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TWWlAowsndCpfqwC+HApKEKZPTaHm9HkWaaxziHjjrMRP1IPAX8WXng5I0cJPc3zh9/6jr96IZjUkIb3nTRlXhtjZd/ecz07LJA7wm8FireLomp1T0bsNMaj5qW19un7NlOp1uN4GqiKBEd5yWpMtBOjN/JjtwkKG5DfaqITCWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=anyEPeK4; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="anyEPeK4"
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-3e575ff1b5eso5786885ab.3;
        Thu, 14 Aug 2025 14:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755205516; x=1755810316; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j9GEbGYpAl9ZYb7PgL+hmgK6T8IXI+LOILb57JZov84=;
        b=anyEPeK47T61N/GJwwhNUaomFlnoK/6nsp/QS1xjTJM6+hBYvmnaJmPT5E1yaVJ2No
         AwQMu9cJQGC1/E2c51uq/ADEBD+HTHkcjhsrL8gP80PE5rvclpkfaiZ/mnFBSrmATaQ1
         JeQnPql+f9U5eVeFqyh1xqmwIBPdjlHWYKWWGYRpP7X/6XZSkjjF+8kCLSYS/fjVDOZL
         jdwclY3mUqMymm3HGpwvOz2zrUm5eh+wC6VDVc0Q1+GDbsxR+S9ev/LLNeywJpdLkgoA
         4VcUbAmZF8kVgCR+T5zGFEOb+IQx8zcmjzdFkLWbFBuhxZr8b4jsvwKJxjGn81gm8kR2
         bgmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755205516; x=1755810316;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j9GEbGYpAl9ZYb7PgL+hmgK6T8IXI+LOILb57JZov84=;
        b=DdNhuq+4ajL0Z1yOEld+4WFo89RWxL7T64At3buAF6G+1DTHhl3s5BHF4wx3g7wZmK
         eaz/6tBKzn7w5t+T+bQct3b2VcAaFdYgRIa/ufjv3dVRWuJnDKY2CrXWsYVy+S/5SMIk
         PPQIxoh8QxKi/xvLbDYK+W1gxSZW74g4i6fvSvKe4sNxqt5SjpTBazZB94xt9ZuaET7c
         rJqyp5YmX34wrVzbuEVChi1k+0rAntS93g2PVYjZ2q42jI7k95ZPAIliNRAjm1SX6bJU
         Lg3WTGS0BIFjPSqRD4ZW3MBasjadiCutVtvzjY2Xc5J3kj7rcaZ1Ky+tmJRbCeeMxOCq
         0J2w==
X-Forwarded-Encrypted: i=1; AJvYcCX+tjYJ4ZAnd2k39o3eeTtQAXV4SpvDZKcM2AvhUt6EJm26SiAE4hJRSTe6tSeOwsqKCTi8MTihYZAOT08=@vger.kernel.org
X-Gm-Message-State: AOJu0YzIpRpc+DjWDk4usxL6zaqh9KI1PZhK7Ny/LoziPYp01NrxUzqG
	rUo1yI/ZcuB96BUVx+mQXURpuRIWJ2lZlsoJkbRw5UhO8pXaDWAOoTKNVqXliTPFGuSL7vulUiV
	BIi8dNzZytNKJXkaWQ7kmpRBwZ5eXfOQ=
X-Gm-Gg: ASbGncumV20ZIOZ4aUBwQCTSDFB0zWohvepIprKk7j5jlYcHF5i8I5QPL9i75/juK92
	g3adnNDlv2fQlbx8iIzxwzOzmLnV6rUlvZgqKn3UuYa0bW9IjjEWb7HrLlAZBo0gGmh4dFdYkte
	un+EiUpM0M8lzlPmF5cUioJeV/xsEcV7s5Qx/mNB3iV30WxSoOKY2BPDVoqU5Ve+8KmqoXvst23
	7iX50TCjjxN3Fa9TcO6AIU=
X-Google-Smtp-Source: AGHT+IFN9IX+OqiygWLS3bv9GReWZDPmxX4NpFt7R3ZINH4TwSo73r+HWi6y6UDi5Dxjkcl2a03+xnNp7B50B61iNks=
X-Received: by 2002:a05:6e02:1fc9:b0:3e5:4da2:93ad with SMTP id
 e9e14a558f8ab-3e5709144c7mr78477845ab.11.1755205516094; Thu, 14 Aug 2025
 14:05:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com> <20250801043642.8103-24-kanchana.p.sridhar@intel.com>
In-Reply-To: <20250801043642.8103-24-kanchana.p.sridhar@intel.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 14 Aug 2025 14:05:04 -0700
X-Gm-Features: Ac12FXxuV7Q0wou7hYqoXwQNo-696enIvb_DC6WEALqgMV_gXOt0FjNzFvS26IM
Message-ID: <CAKEwX=Ov2X-0EnmWDCf=mahnR57si_QUuXF7F=Eb5P2cKYZEvg@mail.gmail.com>
Subject: Re: [PATCH v11 23/24] mm: zswap: zswap_store() will process a large
 folio in batches.
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org, 
	yosry.ahmed@linux.dev, chengming.zhou@linux.dev, usamaarif642@gmail.com, 
	ryan.roberts@arm.com, 21cnbao@gmail.com, ying.huang@linux.alibaba.com, 
	akpm@linux-foundation.org, senozhatsky@chromium.org, 
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, clabbe@baylibre.com, ardb@kernel.org, 
	ebiggers@google.com, surenb@google.com, kristen.c.accardi@intel.com, 
	vinicius.gomes@intel.com, wajdi.k.feghali@intel.com, vinodh.gopal@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 31, 2025 at 9:36=E2=80=AFPM Kanchana P Sridhar
<kanchana.p.sridhar@intel.com> wrote:
>
> This patch modifies zswap_store() to store a batch of pages in large
> folios at a time, instead of storing one page at a time. It does this by
> calling a new procedure zswap_store_pages() with a range of
> "pool->batch_size" indices in the folio.
>
> zswap_store_pages() implements all the computes done earlier in
> zswap_store_page() for a single-page, for multiple pages in a folio,
> namely the "batch":
>
> 1) It starts by allocating all zswap entries required to store the
>    batch. New procedures, zswap_entries_cache_alloc_batch() and
>    zswap_entries_cache_free_batch() call kmem_cache_[free]alloc_bulk()
>    to optimize the performance of this step.
>
> 2) Next, the entries fields are written, computes that need to be happen
>    anyway, without modifying the zswap xarray/LRU publishing order. This
>    improves latency by avoiding having the bring the entries into the
>    cache for writing in different code blocks within this procedure.
>
> 3) Next, it calls zswap_compress() to sequentially compress each page in
>    the batch.
>
> 4) Finally, it adds the batch's zswap entries to the xarray and LRU,
>    charges zswap memory and increments zswap stats.
>
> 5) The error handling and cleanup required for all failure scenarios
>    that can occur while storing a batch in zswap are consolidated to a
>    single "store_pages_failed" label in zswap_store_pages(). Here again,
>    we optimize performance by calling kmem_cache_free_bulk().
>
> Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> ---
>  mm/zswap.c | 218 ++++++++++++++++++++++++++++++++++++-----------------
>  1 file changed, 149 insertions(+), 69 deletions(-)
>
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 63a997b999537..8ca69c3f30df2 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -879,6 +879,24 @@ static void zswap_entry_cache_free(struct zswap_entr=
y *entry)
>         kmem_cache_free(zswap_entry_cache, entry);
>  }
>
> +/*
> + * Returns 0 if kmem_cache_alloc_bulk() failed and a positive number oth=
erwise.
> + * The code for __kmem_cache_alloc_bulk() indicates that this positive n=
umber
> + * will be the @size requested, i.e., @nr_entries.
> + */
> +static __always_inline int zswap_entries_cache_alloc_batch(void **entrie=
s,
> +                                                          unsigned int n=
r_entries,
> +                                                          gfp_t gfp)
> +{
> +       return kmem_cache_alloc_bulk(zswap_entry_cache, gfp, nr_entries, =
entries);
> +}
> +
> +static __always_inline void zswap_entries_cache_free_batch(void **entrie=
s,
> +                                                          unsigned int n=
r_entries)
> +{
> +       kmem_cache_free_bulk(zswap_entry_cache, nr_entries, entries);
> +}
> +
>  /*
>   * Carries out the common pattern of freeing and entry's zpool allocatio=
n,
>   * freeing the entry itself, and decrementing the number of stored pages=
.
> @@ -1512,93 +1530,154 @@ static void shrink_worker(struct work_struct *w)
>  * main API
>  **********************************/
>
> -static bool zswap_store_page(struct page *page,
> -                            struct obj_cgroup *objcg,
> -                            struct zswap_pool *pool)
> +/*
> + * Store multiple pages in @folio, starting from the page at index @star=
t up to
> + * the page at index @end-1.
> + */
> +static bool zswap_store_pages(struct folio *folio,
> +                             long start,
> +                             long end,
> +                             struct obj_cgroup *objcg,
> +                             struct zswap_pool *pool,
> +                             int node_id)
>  {
> -       swp_entry_t page_swpentry =3D page_swap_entry(page);
> -       struct zswap_entry *entry, *old;
> -
> -       /* allocate entry */
> -       entry =3D zswap_entry_cache_alloc(GFP_KERNEL, page_to_nid(page));
> -       if (!entry) {
> -               zswap_reject_kmemcache_fail++;
> -               return false;
> +       struct zswap_entry *entries[ZSWAP_MAX_BATCH_SIZE];
> +       u8 i, store_fail_idx =3D 0, nr_pages =3D end - start;
> +
> +       if (unlikely(!zswap_entries_cache_alloc_batch((void **)&entries[0=
],
> +                                                     nr_pages, GFP_KERNE=
L))) {
> +               for (i =3D 0; i < nr_pages; ++i) {
> +                       entries[i] =3D zswap_entry_cache_alloc(GFP_KERNEL=
, node_id);
> +
> +                       if (unlikely(!entries[i])) {
> +                               zswap_reject_kmemcache_fail++;
> +                               /*
> +                                * While handling this error, we only nee=
d to
> +                                * call zswap_entries_cache_free_batch() =
for
> +                                * entries[0 .. i-1].
> +                                */
> +                               nr_pages =3D i;
> +                               goto store_pages_failed;
> +                       }
> +               }
>         }
>
> -       if (!zswap_compress(page, entry, pool))
> -               goto compress_failed;
> +       /*
> +        * Three sets of initializations are done to minimize bringing
> +        * @entries into the cache for writing at different parts of this
> +        * procedure, since doing so regresses performance:
> +        *
> +        * 1) Do all the writes to each entry in one code block. These
> +        *    writes need to be done anyway upon success which is more li=
kely
> +        *    than not.
> +        *
> +        * 2) Initialize the handle to an error value. This facilitates
> +        *    having a consolidated failure handling
> +        *    'goto store_pages_failed' that can inspect the value of the
> +        *    handle to determine whether zpool memory needs to be
> +        *    de-allocated.
> +        *
> +        * 3) The page_swap_entry() is obtained once and stored in the en=
try.
> +        *    Subsequent store in xarray gets the entry->swpentry instead=
 of
> +        *    calling page_swap_entry(), minimizing computes.
> +        */
> +       for (i =3D 0; i < nr_pages; ++i) {
> +               entries[i]->handle =3D (unsigned long)ERR_PTR(-EINVAL);
> +               entries[i]->pool =3D pool;
> +               entries[i]->swpentry =3D page_swap_entry(folio_page(folio=
, start + i));
> +               entries[i]->objcg =3D objcg;
> +               entries[i]->referenced =3D true;
> +               INIT_LIST_HEAD(&entries[i]->lru);
> +       }
>
> -       old =3D xa_store(swap_zswap_tree(page_swpentry),
> -                      swp_offset(page_swpentry),
> -                      entry, GFP_KERNEL);
> -       if (xa_is_err(old)) {
> -               int err =3D xa_err(old);
> +       for (i =3D 0; i < nr_pages; ++i) {
> +               struct page *page =3D folio_page(folio, start + i);
>
> -               WARN_ONCE(err !=3D -ENOMEM, "unexpected xarray error: %d\=
n", err);
> -               zswap_reject_alloc_fail++;
> -               goto store_failed;
> +               if (!zswap_compress(page, entries[i], pool))
> +                       goto store_pages_failed;
>         }
>
> -       /*
> -        * We may have had an existing entry that became stale when
> -        * the folio was redirtied and now the new version is being
> -        * swapped out. Get rid of the old.
> -        */
> -       if (old)
> -               zswap_entry_free(old);
> +       for (i =3D 0; i < nr_pages; ++i) {
> +               struct zswap_entry *old, *entry =3D entries[i];
>
> -       /*
> -        * The entry is successfully compressed and stored in the tree, t=
here is
> -        * no further possibility of failure. Grab refs to the pool and o=
bjcg,
> -        * charge zswap memory, and increment zswap_stored_pages.
> -        * The opposite actions will be performed by zswap_entry_free()
> -        * when the entry is removed from the tree.
> -        */
> -       zswap_pool_get(pool);
> -       if (objcg) {
> -               obj_cgroup_get(objcg);
> -               obj_cgroup_charge_zswap(objcg, entry->length);
> -       }
> -       atomic_long_inc(&zswap_stored_pages);
> +               old =3D xa_store(swap_zswap_tree(entry->swpentry),
> +                              swp_offset(entry->swpentry),
> +                              entry, GFP_KERNEL);
> +               if (unlikely(xa_is_err(old))) {
> +                       int err =3D xa_err(old);
>
> -       /*
> -        * We finish initializing the entry while it's already in xarray.
> -        * This is safe because:
> -        *
> -        * 1. Concurrent stores and invalidations are excluded by folio l=
ock.
> -        *
> -        * 2. Writeback is excluded by the entry not being on the LRU yet=
.
> -        *    The publishing order matters to prevent writeback from seei=
ng
> -        *    an incoherent entry.
> -        */
> -       entry->pool =3D pool;
> -       entry->swpentry =3D page_swpentry;
> -       entry->objcg =3D objcg;
> -       entry->referenced =3D true;
> -       if (entry->length) {
> -               INIT_LIST_HEAD(&entry->lru);
> -               zswap_lru_add(&zswap_list_lru, entry);
> +                       WARN_ONCE(err !=3D -ENOMEM, "unexpected xarray er=
ror: %d\n", err);
> +                       zswap_reject_alloc_fail++;
> +                       /*
> +                        * Entries up to this point have been stored in t=
he
> +                        * xarray. zswap_store() will erase them from the=
 xarray
> +                        * and call zswap_entry_free(). Local cleanup in
> +                        * 'store_pages_failed' only needs to happen for
> +                        * entries from [@i to @nr_pages).
> +                        */
> +                       store_fail_idx =3D i;
> +                       goto store_pages_failed;
> +               }
> +
> +               /*
> +                * We may have had an existing entry that became stale wh=
en
> +                * the folio was redirtied and now the new version is bei=
ng
> +                * swapped out. Get rid of the old.
> +                */
> +               if (unlikely(old))
> +                       zswap_entry_free(old);
> +
> +               /*
> +                * The entry is successfully compressed and stored in the=
 tree, there is
> +                * no further possibility of failure. Grab refs to the po=
ol and objcg,
> +                * charge zswap memory, and increment zswap_stored_pages.
> +                * The opposite actions will be performed by zswap_entry_=
free()
> +                * when the entry is removed from the tree.
> +                */
> +               zswap_pool_get(pool);
> +               if (objcg) {
> +                       obj_cgroup_get(objcg);
> +                       obj_cgroup_charge_zswap(objcg, entry->length);
> +               }
> +               atomic_long_inc(&zswap_stored_pages);
> +
> +               /*
> +                * We finish by adding the entry to the LRU while it's al=
ready
> +                * in xarray. This is safe because:
> +                *
> +                * 1. Concurrent stores and invalidations are excluded by=
 folio lock.
> +                *
> +                * 2. Writeback is excluded by the entry not being on the=
 LRU yet.
> +                *    The publishing order matters to prevent writeback f=
rom seeing
> +                *    an incoherent entry.
> +                */
> +               if (likely(entry->length))
> +                       zswap_lru_add(&zswap_list_lru, entry);
>         }
>
>         return true;
>
> -store_failed:
> -       zpool_free(pool->zpool, entry->handle);
> -compress_failed:
> -       zswap_entry_cache_free(entry);
> +store_pages_failed:
> +       for (i =3D store_fail_idx; i < nr_pages; ++i) {
> +               if (!IS_ERR_VALUE(entries[i]->handle))
> +                       zpool_free(pool->zpool, entries[i]->handle);
> +       }
> +       zswap_entries_cache_free_batch((void **)&entries[store_fail_idx],
> +                                      nr_pages - store_fail_idx);
> +
>         return false;
>  }
>
>  bool zswap_store(struct folio *folio)
>  {
>         long nr_pages =3D folio_nr_pages(folio);
> +       int node_id =3D folio_nid(folio);
>         swp_entry_t swp =3D folio->swap;
>         struct obj_cgroup *objcg =3D NULL;
>         struct mem_cgroup *memcg =3D NULL;
>         struct zswap_pool *pool;
>         bool ret =3D false;
> -       long index;
> +       long start, end;
>
>         VM_WARN_ON_ONCE(!folio_test_locked(folio));
>         VM_WARN_ON_ONCE(!folio_test_swapcache(folio));
> @@ -1632,10 +1711,11 @@ bool zswap_store(struct folio *folio)
>                 mem_cgroup_put(memcg);
>         }
>
> -       for (index =3D 0; index < nr_pages; ++index) {
> -               struct page *page =3D folio_page(folio, index);
> +       /* Store the folio in batches of @pool->batch_size pages. */
> +       for (start =3D 0; start < nr_pages; start +=3D pool->batch_size) =
{
> +               end =3D min(start + pool->batch_size, nr_pages);
>
> -               if (!zswap_store_page(page, objcg, pool))
> +               if (!zswap_store_pages(folio, start, end, objcg, pool, no=
de_id))
>                         goto put_pool;
>         }
>
> @@ -1665,9 +1745,9 @@ bool zswap_store(struct folio *folio)
>                 struct zswap_entry *entry;
>                 struct xarray *tree;
>
> -               for (index =3D 0; index < nr_pages; ++index) {
> -                       tree =3D swap_zswap_tree(swp_entry(type, offset +=
 index));
> -                       entry =3D xa_erase(tree, offset + index);
> +               for (start =3D 0; start < nr_pages; ++start) {
> +                       tree =3D swap_zswap_tree(swp_entry(type, offset +=
 start));
> +                       entry =3D xa_erase(tree, offset + start);
>                         if (entry)
>                                 zswap_entry_free(entry);
>                 }
> --
> 2.27.0
>

This patch LGTM for the most part. Lemme test the series again (I
tested an old version of this patch series), and I will give my Ack.
