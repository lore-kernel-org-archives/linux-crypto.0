Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.44
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793330356;
	b=0aSLFwzsV+aW03ALrG1IZHazbl3oFL/5c+BgBYFqjVeL+2erxzUJAgLkYLaCyBM/ZdWE
	 sr7KY0JZe27tYsYc5IhJ1a1HtTRw8Zs8NWTFKCbYODQubQlrzK4PnqGXodeeFLb/cFoDH
	 4+n/BxIBoEOrnpSos+g9NshGxoM7jXwrkaEh0KlFrb2Mlrwsj2H+J9C90C9c23mKr7yk+
	 7EW7fPGWY4pxOwU+YI6YyBBPPSDFxoGvpJeBzasHI6g4+cY66FcSjPJYj0slElFF7GyIH
	 OTHMH8WR6G2S2vKDDe97oIXyq7sXhF1+guloqf/JCgOmo6VpW+TjHxvNFS4PIvnaEYA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793330356;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=TvFyOlYWWcM4bfjI5ZFYq0uA7WbLDYElCyWjZqS03Gw=;
	b=AE9cX6CgbBnqkmfp2ZMM+l5Uvb0+E2V/MHzcdfOmrMiqEl+2t8PLSEyImWVTg3KkZFLj
	 KAsPGTgi7Lz0cZQOnCcR5B6r+Lx8J3YiGjblYrcRSueZqGccvRZqi9mP9L5ktfdliFua5
	 SRtXXzVCV6imjH0q/1sPx64UxgztYI8qzXPq3fnmhhr+/wg1u1KSRgBkxZH8io1MHXarC
	 Gf3S8QVtiz81IWx4xMsRuNboRkRl6kpn3k7IXe9OCyoYFUHDI7UKyzS+42Yc7NK6wuZ56
	 JNpxZrq/pw5EPF32FFUvnX2dPyVBoD+z2SzTil8W49jLIcutTrw2do8p8nnbh48Ps1Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="Zoy/exii";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.44
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8EE3606A31A
	for <linux-crypto@vger.kernel.org>; Fri, 30 Oct 2026 03:19:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D8EE3606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Zoy/exii
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5be4d648aacso234196e87.3
        for <linux-crypto@vger.kernel.org>; Thu, 29 Oct 2026 20:19:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793330354; cv=none;
        d=google.com; s=arc-20260327;
        b=DPcWKFoWvIJkxCFO8ZH2JWXlAqKcmbDTEXE9SAC63bMVv7cecalSt+DhqFTCKi+c0M
         qwxmimkBa3qzIt4uUAosmwKIkxTVzahIfaKdHtjZ0MDl8tUQzODOgBEeH+/qT37h2cOg
         q2PD4f15rS6BHDzkg985txQedDDlwbjV1+bZDXPyubBfo0K+970pS5iFSYNG5eBth+nH
         F0XzGRgmfLfN3ehw0co6by02oVQ3OLY8W8ATLLZMgqdW9KFxCY1y2hj0d+bi25GVJMPP
         7SyewOqXbThAX5yynwZ1q4ART8P0ITWTWPRfAbaFrUwrOwjhh4EMQkeN0v+UtPbS9r4g
         jlnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TvFyOlYWWcM4bfjI5ZFYq0uA7WbLDYElCyWjZqS03Gw=;
        fh=PAkMO8aezZWA0M1jxxeWYoUnph8H3J1IBTrQhPbE5Ac=;
        b=RTQNIy51HQteFRK4HGL3O4e4yFMKMGi3l6EnAk2MOywgjWZ32DzU7+4WKeDwt5dg99
         XTxhvoIWD4/weeUoHdojdu6shaGXfkrO2vb0MEO29Ko/1jqH+HIjoRqySofYqhdCpXF3
         Oc7DyosDvWXPRvcPttoO2REA8zYisiv/NhLKCeWA3Hu6lapa2pm8NkSk6nEH41dVeo3t
         tOTrSCM1mgdBOmrB35ZoQlrXs/9IjoLs3dDAbyMVGp58t/X6a5dbiNv5VXL9QBiCTjEX
         HWZt4FCGDJIR45UojdYsXR9M3bZHWyif18LdZqlXDmTRDIyXVenIlTQp3DK/MiUELeqc
         kWzw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793330354; x=1793935154; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=TvFyOlYWWcM4bfjI5ZFYq0uA7WbLDYElCyWjZqS03Gw=;
        b=Zoy/exiiDDGCwgVF02fRUk53SHESE2bX5WxQXvZr394bXZ2PZKTml6xhyq/pmA8aPK
         T5cbkhzc/xCJ7o+ycEksAvZxaTe6psTpwrEwendIsXFljVJBi1O5nYN+OTxL7TnFk8f8
         WEJIuEFHaW3mPdRzNHH6zGc3+Q7twpBYGWjnVa2avoovlB4se1slSPybUUVmSBbYlwJZ
         Ip1rOrHb92+dyxEizKs29nph7wLj3jb7sb+IpoZogWfmEeNLFHSoZWvczD2KBx++VO5w
         5pflV/hPgGE4US01xAKG42grPrFD0D0SFNXw2e1h46SAbKdlxDatYufdJw0D+oU2mKv2
         7GAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793330354; x=1793935154;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TvFyOlYWWcM4bfjI5ZFYq0uA7WbLDYElCyWjZqS03Gw=;
        b=pkYjH3aDrgYhUeqDgWMJl17EiBc71e1i0RPkby5NLeTl3ST2NuTTQO2WOtM0QMUgkH
         sHU9r8NHAtxKdKRgbyHG3WdKmcHiIWOURejE96rEyU+8VQMEXlT+Erk0Zd88B2StU60x
         v4E/B4EJ4L1clRtq4q+h70dss5uJp8pSubmm7xyfbAodVtJACNPQ9J9twuZIkxPYYrBY
         EG2aO0VNpm2c/14mVmdUvbhMmt06m0E3rkrUm4kqBWPe+9/hlDDHSKxB3T8ko1Yki1Ca
         wCPHhyAl0XGXeU6drHFWP57ItG0ZuuXP5MJgjCgt7q3/eLpPa4BK2MkoWPi3LJ3r9LG5
         0jcw==
X-Forwarded-Encrypted: i=1; AKwUvBx4KBTWwNj66Ta2Vq7dCn41XaIedfcbakCEUZYIQvrQWv8TgqlAkETWWnkaR/nWxS+a4Ssvy4DIOBpjVMc=@vger.kernel.org
X-Gm-Message-State: AFq9FYJXy1ngbiJywwS/WqCHFo+YivthtUkYmzbR6T0tLFSNPv6w5Rah
	1bLrjN4XL3dpdw9gxJq+DQDpn4MCKmybv3hoE7aB27BpiGI1UiE/Qwjys8LDVXGoAFhQfbmQz/b
	RSUaTXzf5iYT9q9IKqNH0BwQIbAqKIvM=
X-Gm-Gg: AYBFou2N0qBgTUqTcHr8bG+2wz9gbT1ZQCBVvT4On/4vclKDMmR0cpZV+R7ZzDZoMuJ
	g8sIBtna50/qnLhWjqrnWVwlVJK13beWVFTNNtH1EJ7BgXZxG8Q61BcZJ2G0q6jEV42ezWDJvgu
	93fIeTvgdh19XhDaB3f17l9Ww6fjoYn/VMotHAxaOAGszLfvQXKG5ikrR4KLOWozkvKGwUQ77nx
	fJPqPXo1P/ECV7XTYlOtUyDvcftcMWdYdXWglguZRcsNsirTL1DZQnzEeewMjZxR/tWYftdtEAD
	QZR5HJS8SgX6JmUHlWRFsvhAd2Hnh5odCQGtxHYiIjfFPVzcQQWHmIKmlfnU1QDkd4U+fcB6a94
	P0/Jjjs0ypc0qRvTfU82jdE6iTY5Wc5YUiQOr
X-Received: by 2002:ac2:4f14:0:b0:5bf:ce1f:672c with SMTP id
 2adb3069b0e04-5bfd9564e0fmr238085e87.22.1793330353814; Thu, 29 Oct 2026
 20:19:13 -0700 (PDT)
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
 <20261028030503.17923-9-kanchanapsridhar2026@gmail.com> <sashiko-outbox-188660@kernel.org>
In-Reply-To: <sashiko-outbox-188660@kernel.org>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Thu, 29 Oct 2026 20:19:00 -0700
X-Gm-Features: AclHuK84KRmP1xwOhmrGiQO4Cat7L-CCE95Y-VrA1yHRRiXcHtlToSwVQTzv2M8
Message-ID: <CACpmpoeHQ8QjFB_2UtGhib9EYToLcXx_e59t+hot+sorUvnMyQ@mail.gmail.com>
Subject: Re: [PATCH v2 8/8] mm: zswap: Refactor and optimize
 zswap_store_pages() batch operations.
To: sashiko-reviews@lists.linux.dev
Cc: hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org, 
	herbert@gondor.apana.org.au, davem@davemloft.net, 
	linux-crypto@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 28, 2026 at 8:06=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 3 potential issu=
e(s) to consider:
> - [High] mm: zswap: memcg counter corruption in zswap_account_stores()
> - [High] mm: zswap: missing zs_free() of prior sub-batches when zswap_com=
press() fails
> - [Low] mm: zswap: unused zswap_pool_get() retained with __maybe_unused
> --
>
> commit 5a1c181c752a45f404bc7cfeb7961fd6accb0903
> Author: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
>
> mm: zswap: Refactor and optimize zswap_store_pages() batch operations.
>
> This commit refactors zswap_store_pages() into smaller helper functions
> (zswap_init_entries(), zswap_tree_stores(), and zswap_account_stores()) t=
o
> process batches of pages when storing a large folio. It also batches pool=
 and
> obj_cgroup reference counting, memcg charging, and zswap_stored_pages upd=
ates
> across the batch.
>
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index 4476fb4aeb5fd..2831284cfc903 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> > @@ -504,12 +504,18 @@ static int __must_check zswap_pool_tryget(struct =
zswap_pool *pool)
> >  }
> >
> >  /* The caller must already have a reference. */
> > -static void zswap_pool_get(struct zswap_pool *pool)
> > +static void __maybe_unused zswap_pool_get(struct zswap_pool *pool)
> >  {
> >       percpu_ref_get(&pool->ref);
> >  }
>
> [Severity: Low]
> Since the only call site in zswap_store_pages() is replaced by
> zswap_pool_get_many(), zswap_pool_get() no longer has any callers in the
> file. Could zswap_pool_get() be removed outright instead of marking it
> __maybe_unused?

Sure, this makes sense.

>
> >
> > -static void zswap_pool_put(struct zswap_pool *pool)
> > +/* The caller must already have a reference. */
> > +static inline void zswap_pool_get_many(struct zswap_pool *pool, u8 nr)
> > +{
> > +     percpu_ref_get_many(&pool->ref, nr);
> > +}
>
> [ ... ]
>
> > @@ -1750,24 +1732,30 @@ static bool zswap_store_pages(struct zswap_stor=
e_context *zc,
>
> [ ... ]
>
> > +static inline void zswap_account_stores(struct zswap_store_context *zc=
,
> > +                                     struct zswap_pool *pool,
> > +                                     struct obj_cgroup *objcg)
> > +{
> > +     size_t total_batch_comp_length =3D 0;
> > +     u8 i;
> > +
> > +     for (i =3D 0; i < zc->nr_pages; ++i) {
> > +             if (unlikely(zc->entries[i]->length =3D=3D PAGE_SIZE))
> >                       atomic_long_inc(&zswap_stored_incompressible_page=
s);
> >
> > +             total_batch_comp_length +=3D zc->entries[i]->length;
> > +
> >               /*
> >                * We finish by adding the entry to the LRU while it's al=
ready
> >                * in xarray. This is safe because:
> > @@ -1778,20 +1766,78 @@ static bool zswap_store_pages(struct zswap_stor=
e_context *zc,
> >                *    The publishing order matters to prevent writeback f=
rom seeing
> >                *    an incoherent entry.
> >                */
> > -             if (likely(entry->length))
> > -                     zswap_lru_add(entry);
> > +             if (likely(zc->entries[i]->length))
> > +                     zswap_lru_add(zc->entries[i]);
> >       }
> >
> > +     /*
> > +      * The entry is successfully compressed and stored in the tree,
> > +      * and further failures will be cleaned up in zswap_store().
> > +      * For the batch, grab refs to the pool and objcg, charge zswap m=
emory,
> > +      * and increment zswap_stored_pages by @zc->nr_pages. The opposit=
e
> > +      * actions will be performed by zswap_entry_free() when the entry=
 is
> > +      * removed from the tree.
> > +      */
> > +     zswap_pool_get_many(pool, zc->nr_pages);
> > +     if (objcg) {
> > +             obj_cgroup_get_many(objcg, zc->nr_pages);
> > +             obj_cgroup_charge_zswap(objcg, total_batch_comp_length);
> > +     }
> > +     atomic_long_add(zc->nr_pages, &zswap_stored_pages);
> > +}
>
> [Severity: High]
> Does calling obj_cgroup_charge_zswap(objcg, total_batch_comp_length) once=
 per
> batch corrupt the MEMCG_ZSWAPPED and MEMCG_ZSWAP_INCOMP counters when
> zc->nr_pages > 1?
>
> Looking at obj_cgroup_charge_zswap() in mm/memcontrol.c, it assumes @size
> represents a single page:
>
> mm/memcontrol.c:obj_cgroup_charge_zswap() {
>     ...
>         rcu_read_lock();
>         memcg =3D obj_cgroup_memcg(objcg);
>         mod_memcg_state(memcg, MEMCG_ZSWAP_B, size);
>         mod_memcg_state(memcg, MEMCG_ZSWAPPED, 1);
>         if (size =3D=3D PAGE_SIZE)
>                 mod_memcg_state(memcg, MEMCG_ZSWAP_INCOMP, 1);
>         rcu_read_unlock();
> }
>
> When a batch of zc->nr_pages > 1 pages from a large folio is stored via
> zswap_store() -> zswap_store_pages() -> zswap_account_stores(),
> MEMCG_ZSWAPPED is only incremented by 1 instead of zc->nr_pages, and
> MEMCG_ZSWAP_INCOMP compares the summed total_batch_comp_length against
> PAGE_SIZE rather than counting individual incompressible pages.
>
> Later, when each entry in the batch is freed via zswap_entry_free():
>
> mm/zswap.c:zswap_entry_free() {
>     ...
>         if (entry->objcg) {
>                 obj_cgroup_uncharge_zswap(entry->objcg, entry->length);
>                 obj_cgroup_put(entry->objcg);
>         }
>     ...
> }
>
> obj_cgroup_uncharge_zswap() is called once per entry, decrementing
> MEMCG_ZSWAPPED by zc->nr_pages total and decrementing MEMCG_ZSWAP_INCOMP =
for
> each entry whose length =3D=3D PAGE_SIZE.
>
> This causes both MEMCG_ZSWAPPED and MEMCG_ZSWAP_INCOMP to be miscounted a=
nd
> underflow, which also breaks zswap_shrinker_count() where MEMCG_ZSWAPPED =
is
> used as nr_stored to scale reclaim targets.

Yes, I see this, thanks. I have added a new
obj_cgroup_charge_zswap_many() that should address this issue.

>
> > +
> > +/*
> > + * Store multiple pages in @folio, starting from the page at index @st=
art up to
> > + * the page at index @end-1.
> > + */
> > +static bool zswap_store_pages(struct zswap_store_context *zc,
> > +                           long start,
> > +                           long end,
> > +                           struct zswap_pool *pool,
> > +                           struct obj_cgroup *objcg)
> > +{
> > +     bool ret;
> > +     u8 i;
> > +
> > +     zc->nr_pages =3D end - start;
> > +     zc->folio_start =3D start;
> > +
> > +     VM_WARN_ON_ONCE(zc->nr_pages <=3D 0 || zc->nr_pages > ZSWAP_MAX_B=
ATCH_SIZE);
> > +
> > +     if (unlikely(!zswap_entries_cache_alloc_batch(zc, GFP_KERNEL)))
> > +             return false;
> > +
> > +     zswap_init_entries(zc, pool, objcg);
> > +
> > +     /*
> > +      * Locking the comp_ctx mutex once per store batch results in bet=
ter
> > +      * performance as compared to locking per compress batch.
> > +      */
> > +     zc->comp_ctx =3D &raw_cpu_ptr(pool->acomp_ctx)->comp;
> > +     mutex_lock(&zc->comp_ctx->areq.mutex);
> > +
> > +     ret =3D zswap_compress(zc);
> > +
> > +     mutex_unlock(&zc->comp_ctx->areq.mutex);
> > +
> > +     if (unlikely(!ret))
> > +             goto compress_failed;
> > +
> > +     ret =3D zswap_tree_stores(zc);
> > +
> > +     if (unlikely(!ret))
> > +             goto store_pages_failed;
> > +
> > +     zswap_account_stores(zc, pool, objcg);
> > +
> >       return true;
> >
> >  store_pages_failed:
> > -     for (i =3D store_fail_idx; i < zc->nr_pages; ++i)
> > +     for (i =3D 0; i < zc->nr_pages; ++i)
> >               zs_free(pool->zs_pool, zc->entries[i]->handle);
> >
> >  compress_failed:
> > -     zswap_entries_cache_free_batch(&zc->entries[store_fail_idx],
> > -                                    zc->nr_pages - store_fail_idx);
> > -
> > +     zswap_entries_cache_free_batch(zc->entries, zc->nr_pages);
> >       return false;
> >  }
>
> [Severity: High]
> Can jumping to compress_failed when zswap_compress() returns false leak t=
he
> zsmalloc handles allocated in earlier compression sub-batches?
>
> In zswap_compress(), pages in [0, zc->nr_pages) are compressed in sub-bat=
ches
> of zc->nr_batch_pages (which is 1 for software compressors such as ZSTD o=
r
> LZ4 when zc->nr_pages is up to ZSWAP_MAX_BATCH_SIZE):
>
> mm/zswap.c:zswap_compress() {
>         for (batch_start =3D 0; batch_start < zc->nr_pages;
>              batch_start +=3D zc->nr_batch_pages) {
>                 ...
>                 err =3D crypto_wait_req(crypto_acomp_compress(zc->comp_ct=
x->areq.req),
>                                       &zc->comp_ctx->areq.wait);
>                 if (unlikely(err && !zc->wb_enabled))
>                         goto compress_error;
>                 ...
>                 ret =3D zswap_update_entries(zc, batch_start);
>                 if (unlikely(!ret))
>                         return false;
>         }
> }
>
> Each successful call to zswap_update_entries(zc, batch_start) allocates
> zs_malloc() handles for zc->entries[batch_start .. batch_start +
> zc->nr_batch_pages - 1]. If a subsequent iteration with batch_start > 0 f=
ails
> at goto compress_error (when !zc->wb_enabled and a page is incompressible=
) or
> fails in zswap_update_entries() (which only frees handles in the current
> sub-batch starting at batch_start):
>
> mm/zswap.c:zswap_update_entries() {
>     ...
>                 if (unlikely(IS_ERR_VALUE(handle))) {
>                         ...
>                         for (i =3D 0; i < comp_batch_iter; ++i)
>                                 zs_free(zc->zs_pool, zc->entries[batch_st=
art + i]->handle);
>
>                         return false;
>                 }
>     ...
> }
>
> zswap_compress() returns false while zc->entries[0 .. batch_start - 1]->h=
andle
> still hold allocated zsmalloc objects. In zswap_store_pages(), jumping to
> compress_failed then frees zc->entries back to the slab cache without cal=
ling
> zs_free() on those handles.

Also resolved, thanks!

>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261028030503.17=
923-1-kanchanapsridhar2026@gmail.com?part=3D8
