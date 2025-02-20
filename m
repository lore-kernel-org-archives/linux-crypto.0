Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 348D92641C3;
	Thu, 20 Feb 2025 23:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740094136; cv=none; b=ZCsDNKf3jGf6ft1po5aj3eCvAi0FLxVBhj6DJvA8QoLSBOZN/Nu/FREUUr1JaRHrNGg08RVVKIAcTqyn11nxvNkrJRe7pIZRXZ6RRJ++RD/sf+m0n2pwIO0OrE6r3xnsatez7jFhAH6u8d6DagOgyOvMpq1TvOcf+bkmAGwRUE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740094136; c=relaxed/simple;
	bh=qsZieKwzHxab8YO/Yz6ndIukc27UE3PZsrR3sqbXunY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Me782pDd0bOFWOieo5ETmH3agjWacePfXe+KP8jFbld2vfT75xMq7AQ9IMXpwdawslPWmILemeNPmqIISaqKHjtxKrqk8VbCtd1YfDAocNH8UPbSqpSMLQju3d9ZEtnk7q7BtjoKzbL+ceenOKZHcWSvIFqEtcHbl/E7B4DuCmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hB81PmVz; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hB81PmVz"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-7c0bb7328fbso158605885a.2;
        Thu, 20 Feb 2025 15:28:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740094133; x=1740698933; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A7nsjQsOdLCanrHBE5ga+GmcstPuckFgM2UOaW0NXKA=;
        b=hB81PmVz5U2VhSjxEhjeUDS3DDgT5SwNtHUtq3T4HbpozrZHKktHwSvMkoGlELhbi4
         c4JRRHTmSrCs4/6btdnsUkHJJZwzmMCHUal1mdacM9hh3SPFRWvqwW23Xu/V8X+f6/WE
         Y8hVCndQku/Tj3SufHfe6Bf310WiiqKunmnOtcURmrHMX35XgNsjxw/p0k65qV8f1ezJ
         gQG4be0lkfonRV/IbkQDIRxpc7X49RLQ20PyjIgXW6Glhsx0opm8LVYc6LCvYhO1H30Y
         4pYlVqjrh4XNZG6VJVl6Mh159bER/O6J9/WePga/Zqgodsa+DOOsT17Zz4poHWjW/YXQ
         K++g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740094133; x=1740698933;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A7nsjQsOdLCanrHBE5ga+GmcstPuckFgM2UOaW0NXKA=;
        b=nzhaK7VYNO8MI2Z+61yAkAhlwbw59uz+CY+5601zB8uEx8eowliw4uEmkqioH7M66e
         rgg26TdXHolhmO8G0QiP6TTbIV782gJre1ieNNw3zGAsapfLp87zPAw5gjHdfJyNHrpy
         Vl7AhE1KXWPWMldKdC4ukHa2orzjgtdELJ2BqyOX/IP0/tI7/MEMCFqJ92MW2Yzxqnol
         uHO5noGyxZoU8bJlj/mFMYtK0ICDNWs9ioj+g6V2CG72Ind1YB2kGm2ukUX/B4OSJisy
         ZuiA+wrNv7LgPRAetiFUpeKFa/pm9JsckTXlFm+A/EIrlrlbhqX2bcuXAe9Ty4pdWs46
         BCng==
X-Forwarded-Encrypted: i=1; AJvYcCWB4T3pfLbM52PWj79y4L0p78fwWJmz0J7vdxN1+YMTI/79RAIwP6PH8DRzoupRHIyqahbwpJN9LN5w2Sw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy18gJLGqx1lxDf8MUzJSCzyvzJefgVc94sL0jeUsw8NyOPBMpE
	XI/5LKMj7gzL4JRz8Ug6FO+gF3Fn556h0WxDAhRqKi4ekeGV/GyrKLbzNGbu0PT+okAYIPFP8+M
	yTp62emzz39LnIfd6deTuOXzTGnk=
X-Gm-Gg: ASbGncuz9bk5SXVYeQwrreAutUVMT0yeYwyiV3EaWKsn//GVYrby7pjyhgQ/lykaL+J
	o2V9qpyMkQ8O7Qfnn7FVOOGGtVLu8mUqQdpVNbw/vf3zdO2CWhV3BzCp+znRWL+VJaOb3MNpLUN
	Ota/0ikugkrAWXK0Afj0E5GN09uRf3
X-Google-Smtp-Source: AGHT+IEHXJcop8/Ak9HvfAznsV/aGJqQT005imbN1kpgP+gHn3wVTRj3bOocUNK7cMYkjPmFBvJMUnOB8fvHq11vZMk=
X-Received: by 2002:a05:620a:46a3:b0:7c0:b185:a951 with SMTP id
 af79cd13be357-7c0ceee9997mr213049485a.5.1740094132794; Thu, 20 Feb 2025
 15:28:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250206072102.29045-1-kanchana.p.sridhar@intel.com> <20250206072102.29045-17-kanchana.p.sridhar@intel.com>
In-Reply-To: <20250206072102.29045-17-kanchana.p.sridhar@intel.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 20 Feb 2025 15:28:42 -0800
X-Gm-Features: AWEUYZmqO_8pyUpV8OmZZT3mNE43hjKnnoLJe7KFKexIC-rIf29_dV6rwBTILuw
Message-ID: <CAKEwX=PD8LNvacFP_JF=KO7R3mfjzTp+HyoEhGe06FQCOT0PaA@mail.gmail.com>
Subject: Re: [PATCH v6 16/16] mm: zswap: Fix for zstd performance regression
 with 2M folios.
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org, 
	yosry.ahmed@linux.dev, chengming.zhou@linux.dev, usamaarif642@gmail.com, 
	ryan.roberts@arm.com, 21cnbao@gmail.com, akpm@linux-foundation.org, 
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, clabbe@baylibre.com, ardb@kernel.org, 
	ebiggers@google.com, surenb@google.com, kristen.c.accardi@intel.com, 
	wajdi.k.feghali@intel.com, vinodh.gopal@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 5, 2025 at 11:21=E2=80=AFPM Kanchana P Sridhar
<kanchana.p.sridhar@intel.com> wrote:
>
> With the previous patch that enables support for batch compressions in
> zswap_compress_folio(), a 6.2% throughput regression was seen with zstd a=
nd
> 2M folios, using vm-scalability/usemem.
>
> For compressors that don't support batching, this was root-caused to the
> following zswap_store_folio() structure:
>
>  Batched stores:
>  ---------------
>  - Allocate all entries,
>  - Compress all entries,
>  - Store all entries in xarray/LRU.

Can you clarify why the above structure leads to performance regression?

>
> Hence, the above structure is maintained only for batched stores, and the
> following structure is implemented for sequential stores of large folio p=
ages,
> that fixes the zstd regression, while preserving common code paths for ba=
tched
> and sequential stores of a folio:
>
>  Sequential stores:
>  ------------------
>  For each page in folio:
>   - allocate an entry,
>   - compress the page,
>   - store the entry in xarray/LRU.
>
> This is submitted as a separate patch only for code review purposes. I wi=
ll
> squash this with the previous commit in subsequent versions of this
> patch-series.
>
> Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> ---
>  mm/zswap.c | 193 ++++++++++++++++++++++++++++++-----------------------
>  1 file changed, 111 insertions(+), 82 deletions(-)
>
> diff --git a/mm/zswap.c b/mm/zswap.c
> index f1cba77eda62..7bfc720a6201 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -1592,40 +1592,32 @@ static bool zswap_batch_compress(struct folio *fo=
lio,
>         return ret;
>  }
>
> -static bool zswap_compress_folio(struct folio *folio,
> -                                struct zswap_entry *entries[],
> -                                struct zswap_pool *pool)
> +static __always_inline bool zswap_compress_folio(struct folio *folio,
> +                                                struct zswap_entry *entr=
ies[],
> +                                                long from_index,
> +                                                struct zswap_pool *pool,
> +                                                unsigned int batch_size,
> +                                                struct crypto_acomp_ctx =
*acomp_ctx)
>  {
> -       long index, nr_pages =3D folio_nr_pages(folio);
> -       struct crypto_acomp_ctx *acomp_ctx;
> -       unsigned int batch_size;
> +       long index =3D from_index, nr_pages =3D folio_nr_pages(folio);
>         bool ret =3D true;
>
> -       acomp_ctx =3D acomp_ctx_get_cpu_lock(pool);
> -       batch_size =3D acomp_ctx->nr_reqs;
> -
>         if ((batch_size > 1) && (nr_pages > 1)) {
> -               for (index =3D 0; index < nr_pages; index +=3D batch_size=
) {
> +               for (; index < nr_pages; index +=3D batch_size) {
>
>                         if (!zswap_batch_compress(folio, index, batch_siz=
e,
>                                                   &entries[index], pool, =
acomp_ctx)) {
>                                 ret =3D false;
> -                               goto unlock_acomp_ctx;
> +                               break;
>                         }
>                 }
>         } else {
> -               for (index =3D 0; index < nr_pages; ++index) {
> -                       struct page *page =3D folio_page(folio, index);
> +               struct page *page =3D folio_page(folio, index);
>
> -                       if (!zswap_compress(page, entries[index], pool, a=
comp_ctx)) {
> -                               ret =3D false;
> -                               goto unlock_acomp_ctx;
> -                       }
> -               }
> +               if (!zswap_compress(page, entries[index], pool, acomp_ctx=
))
> +                       ret =3D false;
>         }
>
> -unlock_acomp_ctx:
> -       acomp_ctx_put_unlock(acomp_ctx);
>         return ret;
>  }
>
> @@ -1637,92 +1629,128 @@ static bool zswap_compress_folio(struct folio *f=
olio,
>   * handles to ERR_PTR(-EINVAL) at allocation time, and the fact that the
>   * entry's handle is subsequently modified only upon a successful zpool_=
malloc()
>   * after the page is compressed.
> + *
> + * For compressors that don't support batching, the following structure
> + * showed a performance regression with zstd/2M folios:
> + *
> + * Batched stores:
> + * ---------------
> + *  - Allocate all entries,
> + *  - Compress all entries,
> + *  - Store all entries in xarray/LRU.
> + *
> + * Hence, the above structure is maintained only for batched stores, and=
 the
> + * following structure is implemented for sequential stores of large fol=
io pages,
> + * that fixes the regression, while preserving common code paths for bat=
ched
> + * and sequential stores of a folio:
> + *
> + * Sequential stores:
> + * ------------------
> + * For each page in folio:
> + *  - allocate an entry,
> + *  - compress the page,
> + *  - store the entry in xarray/LRU.
>   */
>  static bool zswap_store_folio(struct folio *folio,
>                                struct obj_cgroup *objcg,
>                                struct zswap_pool *pool)
>  {
> -       long index, from_index =3D 0, nr_pages =3D folio_nr_pages(folio);
> +       long index =3D 0, from_index =3D 0, nr_pages, nr_folio_pages =3D =
folio_nr_pages(folio);
>         struct zswap_entry **entries =3D NULL;
> +       struct crypto_acomp_ctx *acomp_ctx;
>         int node_id =3D folio_nid(folio);
> +       unsigned int batch_size;
>
> -       entries =3D kmalloc(nr_pages * sizeof(*entries), GFP_KERNEL);
> +       entries =3D kmalloc(nr_folio_pages * sizeof(*entries), GFP_KERNEL=
);
>         if (!entries)
>                 return false;
>
> -       for (index =3D 0; index < nr_pages; ++index) {
> -               entries[index] =3D zswap_entry_cache_alloc(GFP_KERNEL, no=
de_id);
> +       acomp_ctx =3D acomp_ctx_get_cpu_lock(pool);
> +       batch_size =3D acomp_ctx->nr_reqs;
>
> -               if (!entries[index]) {
> -                       zswap_reject_kmemcache_fail++;
> -                       nr_pages =3D index;
> -                       goto store_folio_failed;
> +       nr_pages =3D (batch_size > 1) ? nr_folio_pages : 1;
> +
> +       while (1) {
> +               for (index =3D from_index; index < nr_pages; ++index) {
> +                       entries[index] =3D zswap_entry_cache_alloc(GFP_KE=
RNEL, node_id);
> +
> +                       if (!entries[index]) {
> +                               zswap_reject_kmemcache_fail++;
> +                               nr_pages =3D index;
> +                               goto store_folio_failed;
> +                       }
> +
> +                       entries[index]->handle =3D (unsigned long)ERR_PTR=
(-EINVAL);
>                 }
>
> -               entries[index]->handle =3D (unsigned long)ERR_PTR(-EINVAL=
);
> -       }
> +               if (!zswap_compress_folio(folio, entries, from_index, poo=
l, batch_size, acomp_ctx))
> +                       goto store_folio_failed;
>
> -       if (!zswap_compress_folio(folio, entries, pool))
> -               goto store_folio_failed;
> +               for (index =3D from_index; index < nr_pages; ++index) {
> +                       swp_entry_t page_swpentry =3D page_swap_entry(fol=
io_page(folio, index));
> +                       struct zswap_entry *old, *entry =3D entries[index=
];
>
> -       for (index =3D 0; index < nr_pages; ++index) {
> -               swp_entry_t page_swpentry =3D page_swap_entry(folio_page(=
folio, index));
> -               struct zswap_entry *old, *entry =3D entries[index];
> +                       old =3D xa_store(swap_zswap_tree(page_swpentry),
> +                               swp_offset(page_swpentry),
> +                               entry, GFP_KERNEL);
> +                       if (xa_is_err(old)) {
> +                               int err =3D xa_err(old);
>
> -               old =3D xa_store(swap_zswap_tree(page_swpentry),
> -                              swp_offset(page_swpentry),
> -                              entry, GFP_KERNEL);
> -               if (xa_is_err(old)) {
> -                       int err =3D xa_err(old);
> +                               WARN_ONCE(err !=3D -ENOMEM, "unexpected x=
array error: %d\n", err);
> +                               zswap_reject_alloc_fail++;
> +                               from_index =3D index;
> +                               goto store_folio_failed;
> +                       }
>
> -                       WARN_ONCE(err !=3D -ENOMEM, "unexpected xarray er=
ror: %d\n", err);
> -                       zswap_reject_alloc_fail++;
> -                       from_index =3D index;
> -                       goto store_folio_failed;
> -               }
> +                       /*
> +                        * We may have had an existing entry that became =
stale when
> +                        * the folio was redirtied and now the new versio=
n is being
> +                        * swapped out. Get rid of the old.
> +                        */
> +                       if (old)
> +                               zswap_entry_free(old);
>
> -               /*
> -                * We may have had an existing entry that became stale wh=
en
> -                * the folio was redirtied and now the new version is bei=
ng
> -                * swapped out. Get rid of the old.
> -                */
> -               if (old)
> -                       zswap_entry_free(old);
> +                       /*
> +                        * The entry is successfully compressed and store=
d in the tree, there is
> +                        * no further possibility of failure. Grab refs t=
o the pool and objcg,
> +                        * charge zswap memory, and increment zswap_store=
d_pages.
> +                        * The opposite actions will be performed by zswa=
p_entry_free()
> +                        * when the entry is removed from the tree.
> +                        */
> +                       zswap_pool_get(pool);
> +                       if (objcg) {
> +                               obj_cgroup_get(objcg);
> +                               obj_cgroup_charge_zswap(objcg, entry->len=
gth);
> +                       }
> +                       atomic_long_inc(&zswap_stored_pages);
>
> -               /*
> -                * The entry is successfully compressed and stored in the=
 tree, there is
> -                * no further possibility of failure. Grab refs to the po=
ol and objcg,
> -                * charge zswap memory, and increment zswap_stored_pages.
> -                * The opposite actions will be performed by zswap_entry_=
free()
> -                * when the entry is removed from the tree.
> -                */
> -               zswap_pool_get(pool);
> -               if (objcg) {
> -                       obj_cgroup_get(objcg);
> -                       obj_cgroup_charge_zswap(objcg, entry->length);
> +                       /*
> +                        * We finish initializing the entry while it's al=
ready in xarray.
> +                        * This is safe because:
> +                        *
> +                        * 1. Concurrent stores and invalidations are exc=
luded by folio lock.
> +                        *
> +                        * 2. Writeback is excluded by the entry not bein=
g on the LRU yet.
> +                        *    The publishing order matters to prevent wri=
teback from seeing
> +                        *    an incoherent entry.
> +                        */
> +                       entry->pool =3D pool;
> +                       entry->swpentry =3D page_swpentry;
> +                       entry->objcg =3D objcg;
> +                       entry->referenced =3D true;
> +                       if (entry->length) {
> +                               INIT_LIST_HEAD(&entry->lru);
> +                               zswap_lru_add(&zswap_list_lru, entry);
> +                       }
>                 }
> -               atomic_long_inc(&zswap_stored_pages);
>
> -               /*
> -                * We finish initializing the entry while it's already in=
 xarray.
> -                * This is safe because:
> -                *
> -                * 1. Concurrent stores and invalidations are excluded by=
 folio lock.
> -                *
> -                * 2. Writeback is excluded by the entry not being on the=
 LRU yet.
> -                *    The publishing order matters to prevent writeback f=
rom seeing
> -                *    an incoherent entry.
> -                */
> -               entry->pool =3D pool;
> -               entry->swpentry =3D page_swpentry;
> -               entry->objcg =3D objcg;
> -               entry->referenced =3D true;
> -               if (entry->length) {
> -                       INIT_LIST_HEAD(&entry->lru);
> -                       zswap_lru_add(&zswap_list_lru, entry);
> -               }
> +               from_index =3D nr_pages++;
> +
> +               if (nr_pages > nr_folio_pages)
> +                       break;
>         }
>
> +       acomp_ctx_put_unlock(acomp_ctx);
>         kfree(entries);
>         return true;
>
> @@ -1734,6 +1762,7 @@ static bool zswap_store_folio(struct folio *folio,
>                 zswap_entry_cache_free(entries[index]);
>         }
>
> +       acomp_ctx_put_unlock(acomp_ctx);
>         kfree(entries);
>         return false;
>  }
> --
> 2.27.0
>
