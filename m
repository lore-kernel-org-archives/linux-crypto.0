Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B8BAA50
	for <linux-crypto@vger.kernel.org>; Tue,  7 Jan 2025 01:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736212657; cv=none; b=dwx1y4EZd0XPI7y6yokZzD8qogZe21rPNpeCMf2IcZOWBGj0KtBanedd0ljwDKB0eVmGRHiYda78+yaqeH9smBVq+NY2ER4O+f+E3Y0M0jpyLk96lLNgdNT195V7eg1KTzwiJ6+ag2FahP+m1Lx9/jl6C9eNwyltrNItxVdYhEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736212657; c=relaxed/simple;
	bh=RqjZxeFQ1h4bh/P/wyaMc0I7frTMt0g/jote2kM0Arw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WAcSGbKe5sbNlfUcZ8RYRDmHIUUnfEdBfc6qLTrLt+WyrX9jWvfnFX9DZK1EMwWrG/bOLc1VAwxQYnrudDA+bvSuUNo2KcctXOwiFT6Ae/yoQiF6+z7UZUEuwSO4399vKa2M2JyMnYe9k2XPrZk7mPSZqqsEsQzy/DKqsiZUkUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lr5/7JNh; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lr5/7JNh"
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-7b6e4d38185so1205213185a.0
        for <linux-crypto@vger.kernel.org>; Mon, 06 Jan 2025 17:17:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736212653; x=1736817453; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8e+RtCGudvSKljC3J4TMkvI9D8wepFwqkWCe1hsZ2Qk=;
        b=lr5/7JNhaaZ76/w4GRprQsjFoZjRhOdW0U7hrUVuf+mqRvHZBHt7G3FCxXMFSkmIhr
         i3nLz2imk3FTMe59TIbud1hzQPPhl0poSfcD8hVAx+yTug3zxV8n/9cC+t0ld9vQutpZ
         4Z6DkYaG/bTKVHRWgVx9oQqrIuOIAOTWYrPOLF/A6q9qiDQLU8ZwYLEykYx1wFsfZyEF
         Ywpk2DA0JWaD4MQsMqxDZ0zkqxjmR4tplu353GodLnDKw9nHwUpht7cc5EV7nN5aiu8b
         AOqtHAod6WrRputwO3+au/4w+HBHE5xYiPsg1WXsW/pVwCTo+L2CVg6h4/6Fp78+HvOU
         8DaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736212653; x=1736817453;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8e+RtCGudvSKljC3J4TMkvI9D8wepFwqkWCe1hsZ2Qk=;
        b=JPtoJh2s0rFETZzmuQn0nRSw9oMTf+AjTT3kgKqobP1cvRUCajDU4K7cmXrezMnKFZ
         gXLN8HuifvMJ45+C52O9LOvHvD2VO5MikyiwvnYqt5I8Fofwj7lvPjyfU0/4in+LNWiD
         MND5X0S0lewJYxeKaCD8WVOh7G731jeCohPGqaBAQW9G+6L3iVraho8HbahtaivW1t7n
         YEkMyKrlLuWR2Nr/8ITLlPb2US0jWEcZf9GYdpR8x9SaURufP+fxuh+i62LLRW/gVlNB
         OTBcOZJKjNYGSI5OT6/bdPy4P72wkiCoZe1FTAxfUP3YmRGl0LXWEwaw4RN0Y0zin0TI
         zMBw==
X-Forwarded-Encrypted: i=1; AJvYcCVM2cJCcMsvcnGTGGyiaP6DfA8fOmQF8dl7PQJ3zQv8o/BbGH/k1/XXIr/Tv0NYV4Dwd1AXtolDT5D21Tw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyWGgo+1bC2JiuezY/HND282BTs8iDN4iZhbH+IiIvzogrwR923
	2dmPZvZLyEw1wsDVOlsik/qmGir8m+uqHhvbGaoJ1WDyiM7CKGZx76OTjvvlSqYLbODnzlBsLTX
	ett5h3JfRCFeuLjrCE6pfk9cWdxZUkDTAfd21
X-Gm-Gg: ASbGncv28V8gJO1MmltNVZ6iGovYZ2gKGPSW/z2OEcPT3l+WCzvei9Pn9J3JUp/HlB0
	LPv1iK9yQKAWihKMqSuv+EMwZdI3JhJqsqEk=
X-Google-Smtp-Source: AGHT+IFEwBEDT7tBkECwtnZEMAHyH9n4yChnvqe+bwfQTa7pEUr7djsQ3CSQUKvo5IY+wbx7KjXrc7isNgAoHg5OSfQ=
X-Received: by 2002:a05:6214:262c:b0:6cb:d4e6:2507 with SMTP id
 6a1803df08f44-6dd2335706fmr950815736d6.22.1736212653189; Mon, 06 Jan 2025
 17:17:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241221063119.29140-1-kanchana.p.sridhar@intel.com> <20241221063119.29140-12-kanchana.p.sridhar@intel.com>
In-Reply-To: <20241221063119.29140-12-kanchana.p.sridhar@intel.com>
From: Yosry Ahmed <yosryahmed@google.com>
Date: Mon, 6 Jan 2025 17:16:56 -0800
X-Gm-Features: AbW1kvamYUatLjiZ5OPcQdyR7T0WzjBviKiXRpM86mf9wmkQgM_poT1gAzmWmbI
Message-ID: <CAJD7tkYFcxtvD7GEQa3mDzKWURfseVsLvFh6m5yN36B8hefctg@mail.gmail.com>
Subject: Re: [PATCH v5 11/12] mm: zswap: Restructure & simplify zswap_store()
 to make it amenable for batching.
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, usamaarif642@gmail.com, 
	ryan.roberts@arm.com, 21cnbao@gmail.com, akpm@linux-foundation.org, 
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, clabbe@baylibre.com, ardb@kernel.org, 
	ebiggers@google.com, surenb@google.com, kristen.c.accardi@intel.com, 
	wajdi.k.feghali@intel.com, vinodh.gopal@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 20, 2024 at 10:31=E2=80=AFPM Kanchana P Sridhar
<kanchana.p.sridhar@intel.com> wrote:
>
> This patch introduces zswap_store_folio() that implements all the compute=
s
> done earlier in zswap_store_page() for a single-page, for all the pages i=
n
> a folio. This allows us to move the loop over the folio's pages from
> zswap_store() to zswap_store_folio().
>
> A distinct zswap_compress_folio() is also added, that simply calls
> zswap_compress() for each page in the folio it is called with.

The git diff looks funky, it may make things clearer to introduce
zswap_compress_folio() in a separate patch.

>
> zswap_store_folio() starts by allocating all zswap entries required to
> store the folio. Next, it calls zswap_compress_folio() and finally, adds
> the entries to the xarray and LRU.
>
> The error handling and cleanup required for all failure scenarios that ca=
n
> occur while storing a folio in zswap is now consolidated to a
> "store_folio_failed" label in zswap_store_folio().
>
> These changes facilitate developing support for compress batching in
> zswap_store_folio().
>
> Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> ---
>  mm/zswap.c | 183 +++++++++++++++++++++++++++++++++--------------------
>  1 file changed, 116 insertions(+), 67 deletions(-)
>
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 99cd78891fd0..1be0f1807bfc 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -1467,77 +1467,129 @@ static void shrink_worker(struct work_struct *w)
>  * main API
>  **********************************/
>
> -static ssize_t zswap_store_page(struct page *page,
> -                               struct obj_cgroup *objcg,
> -                               struct zswap_pool *pool)
> +static bool zswap_compress_folio(struct folio *folio,
> +                                struct zswap_entry *entries[],
> +                                struct zswap_pool *pool)
>  {
> -       swp_entry_t page_swpentry =3D page_swap_entry(page);
> -       struct zswap_entry *entry, *old;
> +       long index, nr_pages =3D folio_nr_pages(folio);
>
> -       /* allocate entry */
> -       entry =3D zswap_entry_cache_alloc(GFP_KERNEL, page_to_nid(page));
> -       if (!entry) {
> -               zswap_reject_kmemcache_fail++;
> -               return -EINVAL;
> +       for (index =3D 0; index < nr_pages; ++index) {
> +               struct page *page =3D folio_page(folio, index);
> +
> +               if (!zswap_compress(page, entries[index], pool))
> +                       return false;
>         }
>
> -       if (!zswap_compress(page, entry, pool))
> -               goto compress_failed;
> +       return true;
> +}
>
> -       old =3D xa_store(swap_zswap_tree(page_swpentry),
> -                      swp_offset(page_swpentry),
> -                      entry, GFP_KERNEL);
> -       if (xa_is_err(old)) {
> -               int err =3D xa_err(old);
> +/*
> + * Store all pages in a folio.
> + *
> + * The error handling from all failure points is consolidated to the
> + * "store_folio_failed" label, based on the initialization of the zswap =
entries'
> + * handles to ERR_PTR(-EINVAL) at allocation time, and the fact that the
> + * entry's handle is subsequently modified only upon a successful zpool_=
malloc()
> + * after the page is compressed.
> + */
> +static ssize_t zswap_store_folio(struct folio *folio,
> +                                struct obj_cgroup *objcg,
> +                                struct zswap_pool *pool)
> +{
> +       long index, nr_pages =3D folio_nr_pages(folio);
> +       struct zswap_entry **entries =3D NULL;
> +       int node_id =3D folio_nid(folio);
> +       size_t compressed_bytes =3D 0;
>
> -               WARN_ONCE(err !=3D -ENOMEM, "unexpected xarray error: %d\=
n", err);
> -               zswap_reject_alloc_fail++;
> -               goto store_failed;
> +       entries =3D kmalloc(nr_pages * sizeof(*entries), GFP_KERNEL);

We can probably use kcalloc() here.

> +       if (!entries)
> +               return -ENOMEM;
> +
> +       /* allocate entries */

This comment can be dropped.

> +       for (index =3D 0; index < nr_pages; ++index) {
> +               entries[index] =3D zswap_entry_cache_alloc(GFP_KERNEL, no=
de_id);
> +
> +               if (!entries[index]) {
> +                       zswap_reject_kmemcache_fail++;
> +                       nr_pages =3D index;
> +                       goto store_folio_failed;
> +               }
> +
> +               entries[index]->handle =3D (unsigned long)ERR_PTR(-EINVAL=
);
>         }
>
> -       /*
> -        * We may have had an existing entry that became stale when
> -        * the folio was redirtied and now the new version is being
> -        * swapped out. Get rid of the old.
> -        */
> -       if (old)
> -               zswap_entry_free(old);
> +       if (!zswap_compress_folio(folio, entries, pool))
> +               goto store_folio_failed;
>
> -       /*
> -        * The entry is successfully compressed and stored in the tree, t=
here is
> -        * no further possibility of failure. Grab refs to the pool and o=
bjcg.
> -        * These refs will be dropped by zswap_entry_free() when the entr=
y is
> -        * removed from the tree.
> -        */
> -       zswap_pool_get(pool);
> -       if (objcg)
> -               obj_cgroup_get(objcg);
> +       for (index =3D 0; index < nr_pages; ++index) {
> +               swp_entry_t page_swpentry =3D page_swap_entry(folio_page(=
folio, index));
> +               struct zswap_entry *old, *entry =3D entries[index];
> +
> +               old =3D xa_store(swap_zswap_tree(page_swpentry),
> +                              swp_offset(page_swpentry),
> +                              entry, GFP_KERNEL);
> +               if (xa_is_err(old)) {
> +                       int err =3D xa_err(old);
> +
> +                       WARN_ONCE(err !=3D -ENOMEM, "unexpected xarray er=
ror: %d\n", err);
> +                       zswap_reject_alloc_fail++;
> +                       goto store_folio_failed;
> +               }
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
> +               /*
> +                * We may have had an existing entry that became stale wh=
en
> +                * the folio was redirtied and now the new version is bei=
ng
> +                * swapped out. Get rid of the old.
> +                */
> +               if (old)
> +                       zswap_entry_free(old);
> +
> +               /*
> +                * The entry is successfully compressed and stored in the=
 tree, there is
> +                * no further possibility of failure. Grab refs to the po=
ol and objcg.
> +                * These refs will be dropped by zswap_entry_free() when =
the entry is
> +                * removed from the tree.
> +                */
> +               zswap_pool_get(pool);
> +               if (objcg)
> +                       obj_cgroup_get(objcg);
> +
> +               /*
> +                * We finish initializing the entry while it's already in=
 xarray.
> +                * This is safe because:
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
> +               entry->pool =3D pool;
> +               entry->swpentry =3D page_swpentry;
> +               entry->objcg =3D objcg;
> +               entry->referenced =3D true;
> +               if (entry->length) {
> +                       INIT_LIST_HEAD(&entry->lru);
> +                       zswap_lru_add(&zswap_list_lru, entry);
> +               }
> +
> +               compressed_bytes +=3D entry->length;
>         }
>
> -       return entry->length;
> +       kfree(entries);
> +
> +       return compressed_bytes;
> +
> +store_folio_failed:
> +       for (index =3D 0; index < nr_pages; ++index) {
> +               if (!IS_ERR_VALUE(entries[index]->handle))
> +                       zpool_free(pool->zpool, entries[index]->handle);
> +
> +               zswap_entry_cache_free(entries[index]);
> +       }

If there is a failure in xa_store() halfway through the entries, this
loop will free all the compressed objects and entries. But, some of
the entries are already in the xarray, and zswap_store() will try to
free them again. This seems like a bug, or did I miss something here?

> +
> +       kfree(entries);
>
> -store_failed:
> -       zpool_free(pool->zpool, entry->handle);
> -compress_failed:
> -       zswap_entry_cache_free(entry);
>         return -EINVAL;
>  }
>
> @@ -1549,8 +1601,8 @@ bool zswap_store(struct folio *folio)
>         struct mem_cgroup *memcg =3D NULL;
>         struct zswap_pool *pool;
>         size_t compressed_bytes =3D 0;
> +       ssize_t bytes;
>         bool ret =3D false;
> -       long index;
>
>         VM_WARN_ON_ONCE(!folio_test_locked(folio));
>         VM_WARN_ON_ONCE(!folio_test_swapcache(folio));
> @@ -1584,15 +1636,11 @@ bool zswap_store(struct folio *folio)
>                 mem_cgroup_put(memcg);
>         }
>
> -       for (index =3D 0; index < nr_pages; ++index) {
> -               struct page *page =3D folio_page(folio, index);
> -               ssize_t bytes;
> +       bytes =3D zswap_store_folio(folio, objcg, pool);
> +       if (bytes < 0)
> +               goto put_pool;
>
> -               bytes =3D zswap_store_page(page, objcg, pool);
> -               if (bytes < 0)
> -                       goto put_pool;
> -               compressed_bytes +=3D bytes;
> -       }
> +       compressed_bytes =3D bytes;

What's the point of having both compressed_bytes and bytes now?

>
>         if (objcg) {
>                 obj_cgroup_charge_zswap(objcg, compressed_bytes);
> @@ -1622,6 +1670,7 @@ bool zswap_store(struct folio *folio)
>                 pgoff_t offset =3D swp_offset(swp);
>                 struct zswap_entry *entry;
>                 struct xarray *tree;
> +               long index;
>
>                 for (index =3D 0; index < nr_pages; ++index) {
>                         tree =3D swap_zswap_tree(swp_entry(type, offset +=
 index));
> --
> 2.27.0
>
