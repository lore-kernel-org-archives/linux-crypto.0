Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.172
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795202669;
	b=5AoypAFdmt1y9gsnGp5vaDdbzMMMqu9MJJFZcNW84ZC0FKpRjec0re0jCcYkS4Wdd2+C
	 UksyQ+orw+w72qx5Qr6rivgts5lLAh4YTz0prpmRZyXIVZkiwyyhPzh1ZBaSaFsOpq974
	 Fu2mXxCTQJAt+RbmPhBouBNx0mU9xZR6MlpakOw8Vy8ASODs1lKr7U9ONA51PcgzQ4VPZ
	 BPqHKsSvXaPZsP0Idrcc/jcAlmeN4xP5KAQaJj5M+meisQEp9FWfSfW6Kf+JGXcYOHBzi
	 IRZO9dE6HYXEztzj2IKjdIbOub3kE/par8Y+xYjBVquxlbfJN4cQvtMoc6IXStrvVMg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795202669;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=hR7xJF+eh3lU/QGj+8ASNxswZFRyXVh6Oom4tDMt+sM=;
	b=qBCOpKm1OGGDMjvz3YChVeafrQhEPUoMmjaAFmiMk9O7AgTyD1khTDOmYzVQApHL7VlB
	 Q7jFfbchV8IG+fAgJqFw3E2sZxs17rOHD+//uD+J3jU+knIxxqez2XLl8Atsm0PDy+noj
	 cOFPUGIoUUktlCPxAbFPaHMv6MZD648dZ5QaoqCedfdgegQoCVbSSS0udYkAMGhOV5YlZ
	 4OCXRnBuAOsQeMxyVHmFwRSo+CWt7dtJMvBz/RANV8tHIfQD6J1KB2XFhAYMcqgdvIkYW
	 7FRTncpHUcs08Z/Q1D/I0oRL59SX28on+weC9GbvzrAz+zfFqrX4WD52uov8h0cyKIw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="0e2eQ/OA";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.172
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2627606A32C
	for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 19:24:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A2627606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0e2eQ/OA
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-3adff684a52so10661271fa.1
        for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 11:24:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795202667; cv=none;
        d=google.com; s=arc-20260327;
        b=O112TO9pFkGE57iaOUe7bJWXpelDzovDP2YTfjCtFhY6XJdhM3NIjvg9mXsbC63XKi
         LaUWnXh6rcE0DO7dvmksSn++lUCXXYQFmfnZg/jm1mqxhMYUFnPHSa3m68o8F9+QWwV/
         O+t1h0K0Bv6kffjm59YGnuqk06qsaBLt1SXEHAtCiZeuRW+h90iMAMv91NerJkezyb+B
         CsG8n4T6wrpYlJte0q+NAmGcXs9ZD0u+ENUsyWITcBGPBxH7Y4F0wnX0BxZRlJmmDwZ6
         Zox1jpH562XcTo/BRUwePLOdbkHXCcDFS/FR3RQo8A1xJp3bRZEYr7RFpV6ZNGFu5XIL
         YfQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hR7xJF+eh3lU/QGj+8ASNxswZFRyXVh6Oom4tDMt+sM=;
        fh=K7TN4dndbTf+ZSVi+BoeYo3xyflLVrbkn+p+IHnGIm4=;
        b=IDEl9nSfOznCqkJ6kCTajCiyGLZZqgXybT7SusgtPQgGgx+jg8GFMvIKpK6Asno4fv
         YMGon5ioi0MSA67wome/fWx2FFJmgB63luW3e8Pzat6LQsZC9upXQqxmLeI6AjA6tWKu
         2a4etzZ9WckLZSQIRunfvh+w4J1FLqtfrQNn36OvLeZa1uvpzJjxDIIdFEbDSTe5terF
         UxdFjF5LQ8E0rVjf6PFMJWu229juUl/uA0a8B6+1limBYyrGhosC/zHttUNGDPFt26vf
         XFEeRbMfk+ssKhSDl0C7CnUc9SRtxRxZzvKZ15xVr8oiC392nQjO4znIyaPHB5w0UsIs
         Yzew==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795202667; x=1795807467; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hR7xJF+eh3lU/QGj+8ASNxswZFRyXVh6Oom4tDMt+sM=;
        b=0e2eQ/OAyG2xrBA/EdA6cx1TxgiHSqQd+dhT49r/RJQP128VGV16TTTP+t3VtKt0dT
         Cjgt+PftXKgY8p2zwDt/NfPUMdAGjDD7PkF7hlZlY867guERcI13NjUKneg2UWnG3446
         nNigWKtr/4ZTSITHiLlWY8OcvS9bOR2u/qaI5+xBxDK5TqjYD06VpBKkpqSI3cKdnFth
         pvEtwViH9Z65IKs7smSl2pMIW73eFRry+Ks9Wzt2r285bQF/WHLKrq699B2G9ulBYkK3
         5WIuEHy4/fvqe676Q4hgCXVKMS1dy93WV1cpyDxHt8XyID4lH978xgQGRfGSvmFdBPgR
         663A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795202667; x=1795807467;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hR7xJF+eh3lU/QGj+8ASNxswZFRyXVh6Oom4tDMt+sM=;
        b=hwtU9foaFK3bycuVsLq2ghSAfJ4SbyE6avNu3I+vaqa7QCBCkQ5JYNFfSRF6CzVV1s
         lmTATYJ37oh2IlrpECreS1Nj6Kn7f27mLXonF7w81g4E1hzkngxgLIxaR5WhCdo8iGpc
         VCwZMHOvWKo+1V/kesCjn7iiLYr0TUDDoM6SSNoSMo0A8MipSahUlWQNaPHHNSDsFrXI
         IusNprufi6IjIPWhtz5pgSiSAPNrE6m5ZSIyQHaA+TLV9QwmtyyRRTDi3bjVLv8IHEZi
         D5p0H0RAce/CfynqShPQpszZdjK98JfSAC393Nay1esxoKwqvzTyWECsKq8ql97FwF03
         sRxQ==
X-Forwarded-Encrypted: i=1; AL+hErE96LCGxRhthlITNfHZ0tgpDK7ZWLv4VjM8gJU/Tz7IsQlOh3Ok6K1eH3cwkD9oV3wlCZD8uP/icFfpCmk=@vger.kernel.org
X-Gm-Message-State: APuU4Z9jEDgzPah5QmkAQYkqDi+UGcVSDur4TyUqS5tDFMNMU5goSTju
	A6lXeG9cu7EwNt/z+1TDmpVMDGV0LeBWr2CJSbuuWL4Ymzs9o6sKzpQamOIcXqi4iX3W+xSB5eF
	Zhnq6yLZLOoyltlMD0IPtCpzte8XY+6Q=
X-Gm-Gg: AZFdTZeHiSJaJSqt5+/xIfokZQnHGuTLnhJYXIvjCBkk5qRq+ohDptffUt02i0ku9vc
	7mBFjaZzxIDkE3OcBJVnGCYTcbgNraKmtcke5cOmVpNmw5MmC+t8mPTyZhBJ4GbIMX1pdR/ccOQ
	HZwEUsnM9scz6Qyhv6Mc6OdzvbN5zaB9kpLw8fQiTcKe+c2UWSOuD2aQzD8tUN+O0FrU0+R/uRu
	D483BMPDHtS+j8EhGMshfBCXkXN/eAAq8vqIH3qM5gB4T2aKsr1tiXVS84R3m1/mlE7jTUuFQJT
	GKGcyT6sFNc+OCSBW06FiRV/E48skh74DSNtdieiaKzs1fk9JzyRITlLvjviDE1dEE/obmP9Krc
	vWvyNixCRGLs/kWIMexUt+46vwByOkTccVpvyrW+V6i8uin+0wIE6ttAxt0E=
X-Received: by 2002:a05:651c:991:b0:3aa:f4c5:8920 with SMTP id
 38308e7fff4ca-3ae7fb0b5efmr9311671fa.12.1795202666436; Fri, 20 Nov 2026
 11:24:26 -0800 (PST)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261106072412.7909-1-kanchanapsridhar2026@gmail.com>
 <20261106072412.7909-8-kanchanapsridhar2026@gmail.com> <sashiko-outbox-202713@kernel.org>
In-Reply-To: <sashiko-outbox-202713@kernel.org>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Fri, 20 Nov 2026 11:24:12 -0800
X-Gm-Features: Aa3M54oUl6qJ5hZlCYYhmiDiQH5xqNAdQbMYZMdPI76DbB-hbPU55wGtY4uRrEQ
Message-ID: <CACpmpoe44wzBDMdLX=Ryau8uuDYrfNRbGmAvuWF6p6rPc6_zbw@mail.gmail.com>
Subject: Re: [PATCH v3 7/8] mm: zswap: Refactor and optimize
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

On Fri, Nov 6, 2026 at 11:25=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 3 potential
> issues to consider:
> - [High] mm: zswap: missing !CONFIG_MEMCG stub for obj_cgroup_get_many()
> - [Low] mm: zswap: unconditional incompressible page stat updates on
>   zero delta
> - [Low] mm: memcontrol: unused and duplicated obj_cgroup_charge_zswap()
> --
>
> commit 55351c710f10c5fbb79d9201d80496dc658bbc19
> Author: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
>
> mm: zswap: Refactor and optimize zswap_store_pages() batch operations.
>
> This commit factors zswap_store_pages() into batch helpers
> zswap_init_entries() and zswap_tree_stores(), and introduces
> obj_cgroup_charge_zswap_many() to charge and account zswap batches at
> once.
>
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index ac6c43ea8c5a6..ab280a448e8c4 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -6368,6 +6368,42 @@ void obj_cgroup_charge_zswap(struct obj_cgroup *=
objcg, size_t size)
> >       rcu_read_unlock();
> >  }
> >
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
> > +                               u8 nr_pages, u8 nr_incomp_pages)
> > +{
> > +     struct mem_cgroup *memcg;
> > +
> > +     if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
> > +             return;
> > +
> > +     if (obj_cgroup_is_root(objcg))
> > +             return;
> > +
> > +     VM_WARN_ON_ONCE(!(current->flags & PF_MEMALLOC));
> > +
> > +     /* PF_MEMALLOC context, charging must succeed */
> > +     if (obj_cgroup_charge(objcg, GFP_KERNEL, size))
> > +             VM_WARN_ON_ONCE(1);
> > +
> > +     rcu_read_lock();
> > +     memcg =3D obj_cgroup_memcg(objcg);
> > +     mod_memcg_state(memcg, MEMCG_ZSWAP_B, size);
> > +     mod_memcg_state(memcg, MEMCG_ZSWAPPED, nr_pages);
> > +     mod_memcg_state(memcg, MEMCG_ZSWAP_INCOMP, nr_incomp_pages);
> > +     rcu_read_unlock();
> > +}
>
> [Severity: Low]
> Could obj_cgroup_charge_zswap() be removed now that its only caller in
> mm/zswap.c has switched to obj_cgroup_charge_zswap_many(), just as
> zswap_pool_get() was replaced by zswap_pool_get_many()?  Leaving
> obj_cgroup_charge_zswap() in mm/memcontrol.c and include/linux/memcontrol=
.h
> duplicates the charging logic with no remaining callers.

Thanks Sashiko for the code review. I have modified
obj_cgroup_charge_zswap() to call obj_cgroup_charge_zswap_many() to
avoid the charging code duplication.

>
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index 8c36344000f51..5ef1ae67e67a9 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
>
> [ ... ]
>
> > @@ -1711,17 +1702,86 @@ static bool zswap_store_pages(struct zswap_stor=
e_context *zc,
> >                       zswap_lru_add(entry);
> >       }
> >
> > +     /*
> > +      * Each batch entry is successfully compressed and stored in the =
tree,
> > +      * and further failures will be cleaned up in zswap_store().
> > +      * Next, we do bulk accounting for the batch: grab refs to the po=
ol and
> > +      * objcg, charge zswap memory, increment zswap_stored_pages and
> > +      * zswap_stored_incompressible_pages. The opposite actions will b=
e
> > +      * performed by zswap_entry_free() when the entry is removed from=
 the
> > +      * tree.
> > +      */
> > +     zswap_pool_get_many(pool, zc->nr_pages);
> > +     if (objcg) {
> > +             obj_cgroup_get_many(objcg, zc->nr_pages);
>
> [Severity: High]
> Does calling obj_cgroup_get_many() here break the build when CONFIG_ZSWAP=
=3Dy
> and CONFIG_MEMCG=3Dn?
>
> include/linux/memcontrol.h only defines obj_cgroup_get_many() inside the
> #ifdef CONFIG_MEMCG block, while the #else section only provides stubs fo=
r
> obj_cgroup_get() and obj_cgroup_put().

Added a stub for obj_cgroup_get_many() in the #else section.

>
> > +             obj_cgroup_charge_zswap_many(objcg, total_batch_comp_leng=
th,
> > +                                          zc->nr_pages, nr_incomp);
> > +     }
> > +     atomic_long_add(zc->nr_pages, &zswap_stored_pages);
> > +     atomic_long_add(nr_incomp, &zswap_stored_incompressible_pages);
>
> [Severity: Low]
> Should the incompressible page updates here and in
> obj_cgroup_charge_zswap_many() be skipped when nr_incomp is 0?
>
> In the common case where all pages in the batch are compressible,
> atomic_long_add(0, &zswap_stored_incompressible_pages) still performs an
> atomic read-modify-write on the shared global counter, and
> mod_memcg_state(memcg, MEMCG_ZSWAP_INCOMP, 0) still runs get_cpu(), updat=
es
> per-CPU stats by 0, and fires trace_mod_memcg_state() with val =3D=3D 0.
>

Good point. I have modified this such that if nr_incomp is 0, we skip
the incompressible page updates.


> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106072412.79=
09-1-kanchanapsridhar2026@gmail.com?part=3D7
