Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.169
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795225011;
	b=vWvGx5kt73iW1KTtWtBelypQwiAGxGD5Ce1v0XojP3J5G4KGa9yp4nsjo8N6ZJOajeGi
	 zSUPCqPY4K1RJqDXQj0rHuPU7IMuZ1oIvR7MsD6yeOi4EC8b1RWr5txWka1W2AGmzVd+T
	 O1TnQdCiNqykXW7W0tGgGMYvj1l+FmiaKrPCTQ+ntIgwINsFm32WN5qpUjdro+XJIZSfF
	 bBccgGZaMfJZadF3r/ClcA5ZdM3bd016sWWBy4siZf7j+8Pcjc482od6YZC9YQhzdX9gD
	 ic5UNQGgS0XI0OoAFkP+2Tbwv85zT6R9ovyNuMeQl36979cJuesVa1fpxmVxE16RJGQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795225011;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=K0GTi1D3/sOSvq62k+dOmi8FEYi6pvAy49neuOOswQM=;
	b=ZKzhvupoqYy8kN9sM5j9eLcdPi4eVQt+cNBUUPXkR4RcSHWljJdpK5kMz3dkReKvstU0
	 jRpS79nmMMJOYGVgFHhTNwOk0WQIVC0DdvKxYlo71vwmexRllbrZOCoySLwzDuqIVm0c9
	 5teb42ivHOx+5Y/na8qSlcKyQVl/lUl9vN2uU+UynzEmOPx/EN8nhb5Q/65SZ0079bP6m
	 kaBafS8ghThiAvJLqb9kHgy5I+PRKqqA9xjWc+7dfZ0BTMdYm4ROPdDXCW8NDzUbt42Du
	 g3AL8iI9/g8R4WEUQraboapLsym4mpLilXJWUh/+fDkKpjGvkncgSPlJAdIlEvz4sTA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VVemKX6y;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.169
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F7D606A68A
	for <linux-crypto@vger.kernel.org>; Sat, 21 Nov 2026 01:36:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A0F7D606A68A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VVemKX6y
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-3acd523a802so13719511fa.2
        for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 17:36:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795225000; cv=none;
        d=google.com; s=arc-20260327;
        b=HTTZDVuAGbdS2ly9nRdnQu1Dn8mfw5ZAwlnI65Mg9ikuu+sup6vbw7WapDiTSbADNp
         T5U/MIt+aBW1rSX7O7TFvqTFme2Ss6fOQ4K3hVYKw6yRK2Y8NNeQqgfn3f2EFuOWb/Uy
         f3OBa+dHX9jgkANxTLYXO5rwEm8dvO7BcOKMGoHTru2wr2djrw0BwM8RKp3QXlcTcJKL
         4ZpfwAzVoEW+JiX/AuXMBJZc5vJP/idRV5ekFJBaeENGj/XFuy8QUIhaOztJnafjokVd
         UyiFVgTe15YTBVRmsrGi26XOC92vmKMUwshlMMNoONfjTL4XkEzlRT3TOk6WTQO5tNAw
         Hj3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=K0GTi1D3/sOSvq62k+dOmi8FEYi6pvAy49neuOOswQM=;
        fh=YuaZH/Y5RpkqdOx1dLnN/55BY3xlMjKKj+O4bLvaHHY=;
        b=X8/VvnGENEQJcMHc3uoyNgQpnYRBMDTm23gWkI45WsdTeLCd2hjbMrmpq3NBzQC44X
         3fuhBaPLgQdn8A57YYihCHnPnK6ZRq9ZcB5ZO2V4Q2WJWAU3C1L283TrdtI8vUv0cmol
         phcB1TgdDpmyJ3odRU1imxTAYLdoiMh63RrCI9bhKyXceYMtrgIkOd1B+KLZavouhWVp
         GXXUYKrkg/8jbXrX81ppDRkNQ+TjatMHe0MRrI4SytctKm6Xc1rWb03Mo8AXTUnxV1yw
         YhrIsNWcmHIPzP2+tFXPUg/o0JT7QLFtiu8mpUD9UXk4j7OUm9x8HML70oGHZUXK6pVs
         b8MA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795225000; x=1795829800; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=K0GTi1D3/sOSvq62k+dOmi8FEYi6pvAy49neuOOswQM=;
        b=VVemKX6ycG5CMVtsLzV59geYQP6Z1zz79C8wnoFccXjxxnx53SV0T69Cgeu1kEOGLv
         DdRvfzX9N0lPSJlDaXmuzhJTJ61a1gvgDymyCvtcYCX65bhNtgatYoYdJySycFPjET89
         YFYU+TET2TK5v8h5I0nFaeF6nqayuKd+Urw1f8K14AgZTSuwfDGYybnANqurraAkQfeT
         ObFc1SQ3IzWq199O5/k2VedGEQpZ1TAbTcT0Jcdo32lA1jrVHksg7fWN34mzjMlm/j0F
         3wCgxibALa+I4YlwdqONat5mbBVc/XGmuNZEJnVY9PBdRhjo5AJ076MlsWKLQ1tE7Ods
         SkrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795225000; x=1795829800;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=K0GTi1D3/sOSvq62k+dOmi8FEYi6pvAy49neuOOswQM=;
        b=SZwlsXg2lLX+NaSuPt42j3zsePCagMQyWXch+aL7y3CUmNnGprXNjue7ATbzm2dHZc
         bqzs4eM/PDzKoO4Uhoevurv7rxVC6KOqvlsrSN35qb02141sZQXTGfhTECeRWCZpT6QX
         GDDIKZZVCDWKoQ1IcmGcW+3WczcTkPnkBsbxCRvOvCYZdDBTe99JUmOZ05PG4UueguAv
         q2uqwwQ12aXxnVtFCzfU2lkNdNAruSD1Bg0fxXVgjpSisE60OdVCHYb+0jZXGprpWIzl
         /5eknBwRvT9f7qkKHKF1k3uxvDy2NzxicTp5ivrUFAq3p7m5e04Aafg8aeDJGcrINhn1
         7J9w==
X-Forwarded-Encrypted: i=1; AL+hErHemMgtC3SmxphOfyXuwkcV5dxEr7egByzA9HsNTbSapPaolouoQIaxJldcOC7VABaKHArPUptJ+RW/6r4=@vger.kernel.org
X-Gm-Message-State: APuU4Z/LNkAgSgGtfVSsF4BvH5Fits7u08jD6djf7OYn2FuTtZ/ycvvI
	E3vq+yNb4DMzqlrdiCort5UEvb8GXc+VrlkEwZ3Ppm/y4jiLmLtXFUh01C1RliMbeB9UA8Oj1Jw
	cc4zqUtogwR3cmVfRXIX4/3YUoXU0I44=
X-Gm-Gg: AZFdTZfERD0lNu6t2QB0W80cJrnPxsghUArqUkbSimdt3jElGD1QMTMTa4AgZfrMlDq
	X4j9u3Vp1LIYA928LxLLzzGMhNqoJ4no1978ZyB+FRPRj6S961vGMKTA2trryOlGO62FVDsIojz
	IdrkeT1I3ZpIbSfTPa4ItiW4KwQ8TdZriiAuW/ViLbNZUCc+Z0H07oGDFI7blkgvkihD1FdgNBR
	sjEKIQ0MdgmmWwFy7hIk0fxONKKsSgqb0kyLDb7Lk9O221kYKCCGnkQt/OPoTVMNaIo5MDv4Rj5
	TBNvoNOEyZ8/ma/EJPwDGQWHlJiC7RqD9lj0a+r+t8ZSVh8TyRmnL8ByPiADl6Q3grZ7/W/FZXX
	aiVoSFNeJPFnf9LmvebCeXkRHjEkq6fO0QUFG
X-Received: by 2002:a2e:bd06:0:b0:3ac:7ad6:2003 with SMTP id
 38308e7fff4ca-3ae7f9b1020mr13168511fa.6.1795224999709; Fri, 20 Nov 2026
 17:36:39 -0800 (PST)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261120041906.5785-1-kanchanapsridhar2026@gmail.com>
 <20261120041906.5785-8-kanchanapsridhar2026@gmail.com> <CAKEwX=PuyT7WhrA3nEQQTyw1H_5D_ZxEcSZYQSF0MyUTii36MQ@mail.gmail.com>
In-Reply-To: <CAKEwX=PuyT7WhrA3nEQQTyw1H_5D_ZxEcSZYQSF0MyUTii36MQ@mail.gmail.com>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Fri, 20 Nov 2026 17:36:27 -0800
X-Gm-Features: Aa3M54oYJbz1gF7DnN1eSJnxvBH5vcc-wU5reSCTlWZdMlRlH4dttzatd7d_HsQ
Message-ID: <CACpmpoeerjFsaZ7ap9wJCFDGHdtepbGxeSkh4QFo2VkMKKUEAw@mail.gmail.com>
Subject: Re: [PATCH v4 7/8] mm: zswap: Refactor and optimize
 zswap_store_pages() batch operations.
To: Nhat Pham <nphamcs@gmail.com>
Cc: hannes@cmpxchg.org, yosry@kernel.org, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 20, 2026 at 3:46=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> On Thu, Nov 19, 2026 at 8:19=E2=80=AFPM Kanchana P. Sridhar
> <kanchanapsridhar2026@gmail.com> wrote:
> >
> > Subsequent patch series will be submitted, that implement ideas buildin=
g
> > upon this batching framework:
> >
> >  1) Replacing zsmalloc with SLUB allocator, comprising of kmem_caches
> >     for a finite # of compressed size bins. This enables bulk allocatio=
n
> >     of compressed buffers in a batch that belong to the same size
> >     bin. It gets rid of significant zsmalloc latency overhead (locks,
> >     compressed data spanning zspages, etc.), without compromising memor=
y
> >     efficiency.
>
> I don't think this will be a good idea, because it will make
> compressed memory unmovable.

Yes, SLUB comes with the constraint of the compressed memory being
unmovable. However, I want to better understand the trade off between
compressed memory migration vs. potentially representing it as SLUB
unmovable memory that needs to be written back. I was hoping to
include a discussion of my understanding of the pros-and-cons when I
submit this RFC, to get your thoughts.

>
> >
> >  2) vmscan reclaim batching of hybrid any-order folios, that will submi=
t
> >     a batch of folios to zswap_store()'s batching framework to optimize
> >     storing of batches of pages from different folios, in addition to
> >     within large folios.
>
> This one might be more complicated than its worth, but I'm not sure.

This does benefit latency a lot! But, one step at a time :)

>
> >
> > Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
>
> Code mostly LGTM.

Thanks for reviewing and providing valuable comments.

>
> > ---
> >  include/linux/memcontrol.h |  12 +++
> >  mm/memcontrol.c            |  23 ++++-
> >  mm/zswap.c                 | 181 +++++++++++++++++++++++++------------
> >  3 files changed, 153 insertions(+), 63 deletions(-)
> >
> > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > index 980358bc6f49..93f060818c14 100644
> > --- a/include/linux/memcontrol.h
> > +++ b/include/linux/memcontrol.h
> > @@ -1244,6 +1244,11 @@ struct mem_cgroup *mem_cgroup_from_css(struct cg=
roup_subsys_state *css)
> >         return NULL;
> >  }
> >
> > +static inline void obj_cgroup_get_many(struct obj_cgroup *objcg,
> > +                                      unsigned long nr)
> > +{
> > +}
> > +
> >  static inline void obj_cgroup_get(struct obj_cgroup *objcg)
> >  {
> >  }
> > @@ -1921,6 +1926,8 @@ static inline void mem_cgroup_calculate_protectio=
n_path(struct mem_cgroup *root,
> >  #if defined(CONFIG_MEMCG) && defined(CONFIG_ZSWAP)
> >  bool obj_cgroup_may_zswap(struct obj_cgroup *objcg);
> >  void obj_cgroup_charge_zswap(struct obj_cgroup *objcg, size_t size);
> > +void obj_cgroup_charge_zswap_many(struct obj_cgroup *objcg, size_t siz=
e,
> > +                                 u8 nr_pages, u8 nr_incomp_pages);
> >  void obj_cgroup_uncharge_zswap(struct obj_cgroup *objcg, size_t size);
> >  bool mem_cgroup_zswap_writeback_enabled(const struct mem_cgroup *memcg=
);
> >  #else
> > @@ -1932,6 +1939,11 @@ static inline void obj_cgroup_charge_zswap(struc=
t obj_cgroup *objcg,
> >                                            size_t size)
> >  {
> >  }
>
> Why do we still need obj_cgroup_charge_zswap() at all?

Ok, I will delete it in next rev.

>
> > +static inline void obj_cgroup_charge_zswap_many(struct obj_cgroup *obj=
cg,
> > +                                               size_t size, u8 nr_page=
s,
> > +                                               u8 nr_incomp_pages)
> > +{
> > +}
> >  static inline void obj_cgroup_uncharge_zswap(struct obj_cgroup *objcg,
> >                                              size_t size)
> >  {
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 091401cecf39..2236f5ba6304 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -6345,6 +6345,23 @@ bool obj_cgroup_may_zswap(struct obj_cgroup *obj=
cg)
> >   * compression and storage in zswap for this cgroup to go ahead.
> >   */
> >  void obj_cgroup_charge_zswap(struct obj_cgroup *objcg, size_t size)
> > +{
> > +       obj_cgroup_charge_zswap_many(objcg, size, 1, (u8)(size =3D=3D P=
AGE_SIZE));
> > +}
> > +
> > +/**
> > + * obj_cgroup_charge_zswap_many - bulk charge compression backend memo=
ry
> > + *                                from compressing a batch of pages.
> > + * @objcg: the object cgroup
> > + * @size: total compressed length of a batch of compressed objects
> > + * @nr_pages: # of pages that were compressed to store in zswap
> > + * @nr_incomp_pages: # of incompressible pages to store in zswap
> > + *
> > + * This forces the charge after obj_cgroup_may_zswap() allowed
> > + * compression and storage in zswap for this cgroup to go ahead.
> > + */
> > +void obj_cgroup_charge_zswap_many(struct obj_cgroup *objcg, size_t siz=
e,
> > +                                 u8 nr_pages, u8 nr_incomp_pages)
> >  {
> >         struct mem_cgroup *memcg;
> >
> > @@ -6363,9 +6380,9 @@ void obj_cgroup_charge_zswap(struct obj_cgroup *o=
bjcg, size_t size)
> >         rcu_read_lock();
> >         memcg =3D obj_cgroup_memcg(objcg);
> >         mod_memcg_state(memcg, MEMCG_ZSWAP_B, size);
> > -       mod_memcg_state(memcg, MEMCG_ZSWAPPED, 1);
> > -       if (size =3D=3D PAGE_SIZE)
> > -               mod_memcg_state(memcg, MEMCG_ZSWAP_INCOMP, 1);
> > +       mod_memcg_state(memcg, MEMCG_ZSWAPPED, nr_pages);
> > +       if (nr_incomp_pages)
> > +               mod_memcg_state(memcg, MEMCG_ZSWAP_INCOMP, nr_incomp_pa=
ges);
> >         rcu_read_unlock();
> >  }
> >
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index df59ab0c1029..5e1fb5624ffb 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> > @@ -491,12 +491,12 @@ static int __must_check zswap_pool_tryget(struct =
zswap_pool *pool)
> >  }
> >
> >  /* The caller must already have a reference. */
> > -static void zswap_pool_get(struct zswap_pool *pool)
> > +static inline void zswap_pool_get_many(struct zswap_pool *pool, u8 nr)
> >  {
> > -       percpu_ref_get(&pool->ref);
> > +       percpu_ref_get_many(&pool->ref, nr);
> >  }
> >
> > -static void zswap_pool_put(struct zswap_pool *pool)
> > +static inline void zswap_pool_put(struct zswap_pool *pool)
> >  {
> >         percpu_ref_put(&pool->ref);
> >  }
> > @@ -1603,55 +1603,60 @@ static void shrink_worker(struct work_struct *w=
)
> >  * main API
> >  **********************************/
> >
> > +/* Functions called by zswap_store(), that operate on batches of pages=
. */
> > +
> >  /*
> > - * Store multiple pages in @zc->folio, starting from the page at index=
 @start up
> > - * to the page at index @end-1.
> > + * zswap_init_entries() co-locates most of the zswap entry fields' set=
up under
> > + * the assumption that all phases of store processing will succeed. An=
 important
> > + * marker to simplify catch-all cleanup in zswap_store_pages() is done=
 by
> > + * initializing each entry's @handle to ERR_PTR(-EINVAL).
> >   */
> > -static bool zswap_store_pages(struct zswap_store_context *zc,
> > -                             long start,
> > -                             long end,
> > -                             struct zswap_pool *pool,
> > -                             struct obj_cgroup *objcg)
> > +static inline void zswap_init_entries(struct zswap_store_context *zc,
> > +                                     struct zswap_pool *pool,
> > +                                     struct obj_cgroup *objcg)
> >  {
> > -       u8 i, store_fail_idx =3D 0;
> > -       bool ret;
> > -
> > -       zc->nr_pages =3D end - start;
> > -       zc->folio_start =3D start;
> > -
> > -       VM_WARN_ON_ONCE(zc->nr_pages <=3D 0 || zc->nr_pages > ZSWAP_MAX=
_BATCH_SIZE);
> > -
> > -       ret =3D zswap_entries_cache_alloc_batch(zc, GFP_KERNEL);
> > -       if (unlikely(!ret))
> > -               return false;
> > +       struct zswap_entry *entry;
> > +       u8 i;
> >
> >         /*
> >          * We co-locate entry initialization as much as possible here t=
o
> >          * minimize potential cache misses.
> >          */
> >         for (i =3D 0; i < zc->nr_pages; ++i) {
> > +               entry =3D zc->entries[i];
> >                 /*
> > -                * Set pool_idx before the xa_store() below publishes t=
he entry, or a
> > -                * concurrent reader could resolve a stale pool_idx lef=
t by slab reuse
> > -                * to an unrelated live pool.
> > +                * Set pool_idx before the xa_store() in zswap_tree_sto=
res()
> > +                * publishes the entry, or a concurrent reader could re=
solve a
> > +                * stale pool_idx left by slab reuse to an unrelated li=
ve pool.
> >                  */
> > -               zc->entries[i]->pool_idx =3D pool->idx;
> > -               zc->entries[i]->swpentry =3D folio_swap_entry(zc->folio=
,
> > +               entry->pool_idx =3D pool->idx;
> > +               entry->swpentry =3D folio_swap_entry(zc->folio,
> >                                                         zc->folio_start=
 + i);
> > -               zc->entries[i]->objcg =3D objcg;
> > -               zc->entries[i]->referenced =3D true;
> > -               zc->entries[i]->nid =3D zc->nid;
> > -               INIT_LIST_HEAD(&zc->entries[i]->lru);
> > +               entry->objcg =3D objcg;
> > +               entry->referenced =3D true;
> > +               entry->nid =3D zc->nid;
> > +               INIT_LIST_HEAD(&entry->lru);
> >         }
> > +}
> >
> > -       for (i =3D 0; i < zc->nr_pages; ++i) {
> > -               if (!zswap_compress(zc->folio, zc->folio_start + i,
> > -                                   zc->entries[i], pool, zc->wb_enable=
d))
> > -                       goto store_pages_failed;
> > -       }
> > +/*
> > + * zswap_tree_stores() stores the batch entries in xarray and adds the=
m to the
> > + * zswap LRU list. If an error occurs during xa_store(), localized sta=
te
> > + * unwinding is done to erase prior batch entries from the xarray and =
delete
> > + * them from the zswap LRU list. Remaining batch cleanup occurs in
> > + * zswap_store_pages(). As batch entries are processed, we maintain ag=
gregate
> > + * statistics to do the accounting in one bulk operation.
> > + */
> > +static bool zswap_tree_stores(struct zswap_store_context *zc,
> > +                             struct zswap_pool *pool,
> > +                             struct obj_cgroup *objcg)
> > +{
> > +       u8 i, store_fail_idx =3D 0, nr_incomp =3D 0;
> > +       size_t total_batch_comp_length =3D 0;
> > +       struct zswap_entry *old, *entry;
> >
> >         for (i =3D 0; i < zc->nr_pages; ++i) {
> > -               struct zswap_entry *old, *entry =3D zc->entries[i];
> > +               entry =3D zc->entries[i];
> >
> >                 old =3D xa_store(swap_zswap_tree(entry->swpentry),
> >                                swp_offset(entry->swpentry),
> > @@ -1663,13 +1668,11 @@ static bool zswap_store_pages(struct zswap_stor=
e_context *zc,
> >                         zswap_reject_alloc_fail++;
> >                         /*
> >                          * Entries up to this point have been stored in=
 the
> > -                        * xarray. zswap_store() will erase them from t=
he xarray
> > -                        * and call zswap_entry_free(). Local cleanup i=
n
> > -                        * 'store_pages_failed' only needs to happen fo=
r
> > -                        * entries from [@i to @nr_pages).
> > +                        * xarray. Local cleanup in 'tree_store_failed'=
 needs to
> > +                        * erase entries up until now.
> >                          */
> >                         store_fail_idx =3D i;
> > -                       goto store_pages_failed;
> > +                       goto tree_store_failed;
> >                 }
> >
> >                 /*
> > @@ -1680,22 +1683,10 @@ static bool zswap_store_pages(struct zswap_stor=
e_context *zc,
> >                 if (unlikely(old))
> >                         zswap_entry_free(old);
> >
> > -               /*
> > -                * The entry is successfully compressed and stored in t=
he tree,
> > -                * and further failures will be cleaned up in zswap_sto=
re().
> > -                * Grab refs to the pool and objcg, charge zswap memory=
, and
> > -                * increment zswap_stored_pages. The opposite actions w=
ill be
> > -                * performed by zswap_entry_free() when the entry is re=
moved
> > -                * from the tree.
> > -                */
> > -               zswap_pool_get(pool);
> > -               if (objcg) {
> > -                       obj_cgroup_get(objcg);
> > -                       obj_cgroup_charge_zswap(objcg, entry->length);
> > -               }
> > -               atomic_long_inc(&zswap_stored_pages);
> > +               total_batch_comp_length +=3D entry->length;
> > +
> >                 if (unlikely(entry->length =3D=3D PAGE_SIZE))
> > -                       atomic_long_inc(&zswap_stored_incompressible_pa=
ges);
> > +                       ++nr_incomp;
> >
> >                 /*
> >                  * We finish by adding the entry to the LRU while it's =
already
> > @@ -1711,17 +1702,87 @@ static bool zswap_store_pages(struct zswap_stor=
e_context *zc,
> >                         zswap_lru_add(entry);
> >         }
> >
> > +       /*
> > +        * Each batch entry is successfully compressed and stored in th=
e tree,
> > +        * and further failures will be cleaned up in zswap_store().
> > +        * Next, we do bulk accounting for the batch: grab refs to the =
pool and
> > +        * objcg, charge zswap memory, increment zswap_stored_pages and
> > +        * zswap_stored_incompressible_pages. The opposite actions will=
 be
> > +        * performed by zswap_entry_free() when the entry is removed fr=
om the
> > +        * tree.
> > +        */
> > +       zswap_pool_get_many(pool, zc->nr_pages);
> > +       if (objcg) {
> > +               obj_cgroup_get_many(objcg, zc->nr_pages);
> > +               obj_cgroup_charge_zswap_many(objcg, total_batch_comp_le=
ngth,
> > +                                            zc->nr_pages, nr_incomp);
> > +       }
> > +       atomic_long_add(zc->nr_pages, &zswap_stored_pages);
> > +       if (unlikely(nr_incomp))
> > +               atomic_long_add(nr_incomp, &zswap_stored_incompressible=
_pages);
> > +
> > +       return true;
> > +
>
> Can you add a comment that we only clean up the current batch here,
> and the clean up of other batches in the folio are deferred to
> zswap_store() (or whereever up the stack it is handled?).

Sure, will do.

>
> > +tree_store_failed:
> > +       for (i =3D 0; i < store_fail_idx; ++i) {
> > +               xa_erase(swap_zswap_tree(zc->entries[i]->swpentry),
> > +                        swp_offset(zc->entries[i]->swpentry));
>
> xas API?

Sure, I need to spend time on it, thinking best if it is a subsequent patch=
.

>
> > +               zswap_lru_del(zc->entries[i]);
> > +       }
> > +
> > +       return false;
> > +}
> > +
> > +/*
