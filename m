Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794036310;
	b=DziZmMhSIFsdNwvkgiRUYWuwsnjs6D3qUlHoTnJs14lT952bI91z+Cnk/gRjOlklepuR
	 +XVTADTLoOAo0UMp1/hUlwTcQES8RHzuDIh7SDAUpSyWYPZFpOq2HLSVSfPEGZP45MQrX
	 GfJWAHxDX7Rsh82jxVAkwrWfbOfZLGHagRbTYBBADgDtvfF7UD6/knSCGo13BUHYESqCs
	 LJ65igZeqgPeJUIfPpACZKx1a0UtPrdyMXUsEJcytBRHgj9im32Y9yaJ4O3aXKwHtLsp4
	 Bpb1DViAlKBT53WempZtHJdjqU98mx1WaHdMd9wE66y0U+MP0PeY0WyVO31HCTWyyqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794036310;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=gCWQ9qkOFfgvFaYqP71kdGivRiPvl6C6TAal7j1jCxY=;
	b=mp+S3d8Wz6paNfWshJEMSnljRVgujl6oSgLC1ltpGRMNbknizp5pFuG9NSSU6Do18fIQ
	 cAY0r0OLsaZsvYTNlSSJVV8wf5cDxcIFwfPdgTFvneX3BUu25mE4MTLVKbQf1yqD2F8ok
	 dM4YFmrmJsCiqZgaUv2kGX1b52xOHEYj4tRnWIn7NhkZCDg1tgPmUawdNfknXPeUnP46+
	 2XVjNK1OE3QrPxfaUgd2CFdsJOGUIXbM1Vlqs0qbgIO58bC7II6ofY9vO7kIulVVqs5U6
	 o3nrKj+UqfsvNuq61kONpnFjK/N0FmW7YhotIXCdGceosX56LT3xnNU2WTvNjKoYjQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ghu6+rk9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A122606A32C
	for <linux-crypto@vger.kernel.org>; Sat,  7 Nov 2026 07:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ghu6+rk9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 154191F008A1;
	Sat,  7 Nov 2026 07:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794036309;
	bh=gCWQ9qkOFfgvFaYqP71kdGivRiPvl6C6TAal7j1jCxY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ghu6+rk9zvmZZeSobEbSSFgk+jAhNIIOk9bFNo1gTqTIp/UnTSag42Qp/zyd3ihcK
	 AZpDymTpKHuTWu/jSjwvMpptttU06vOhysWyskWYa9dka6E5XTmkuMXPmwQloA967K
	 q8WmaoWbpouBqXrfZpq0y9baC7yHASyvLCNQKtJKRF1ISKsZR9sgrZC6d9uxWJYwH0
	 2TDuq94q56wEbPwGzYaqHJj2xvzozpAiibjdNM6BKIq36n0nyxFlQ1B9R3QXCvXgzw
	 PsdC6eohfA/XkbgEDGzv2VxVLipRn1QRYWWRT+DiuSdDZsRg0houLoh5BYkMar38K0
	 9Hen3RIvxjmbw==
Message-ID: <sashiko-outbox-202713@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 7/8] mm: zswap: Refactor and optimize
 zswap_store_pages() batch operations.
Reply-To: sashiko-reviews@lists.linux.dev
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>, hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com, chengming.zhou@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, davem@davemloft.net, linux-crypto@vger.kernel.org
Cc: rientjes@google.com, willy@infradead.org, senozhatsky@chromium.org
In-Reply-To: <20261106072412.7909-8-kanchanapsridhar2026@gmail.com>
References: <20261106072412.7909-1-kanchanapsridhar2026@gmail.com>
 <20261106072412.7909-8-kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 07 Nov 2026 07:25:08 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [High] mm: zswap: missing !CONFIG_MEMCG stub for obj_cgroup_get_many()
- [Low] mm: zswap: unconditional incompressible page stat updates on
  zero delta
- [Low] mm: memcontrol: unused and duplicated obj_cgroup_charge_zswap()
--

commit 55351c710f10c5fbb79d9201d80496dc658bbc19
Author: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>

mm: zswap: Refactor and optimize zswap_store_pages() batch operations.

This commit factors zswap_store_pages() into batch helpers
zswap_init_entries() and zswap_tree_stores(), and introduces
obj_cgroup_charge_zswap_many() to charge and account zswap batches at
once.

> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index ac6c43ea8c5a6..ab280a448e8c4 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -6368,6 +6368,42 @@ void obj_cgroup_charge_zswap(struct obj_cgroup *ob=
jcg, size_t size)
>  	rcu_read_unlock();
>  }
> =20
> +/**
> + * obj_cgroup_charge_zswap_many - bulk charge compression backend memory
> + *                                from compressing a batch of pages.
> + * @objcg: the object cgroup
> + * @size: total compressed length of a batch of compressed objects
> + * @nr_pages: # of pages that were compressed to store in zswap
> + * @nr_incomp_pages: # of incompressible pages to store in zswap
> + *
> + * This forces the charge after obj_cgroup_may_zswap() allowed
> + * compression and storage in zswap for this cgroup to go ahead.
> + */
> +void obj_cgroup_charge_zswap_many(struct obj_cgroup *objcg, size_t size,
> +				  u8 nr_pages, u8 nr_incomp_pages)
> +{
> +	struct mem_cgroup *memcg;
> +
> +	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
> +		return;
> +
> +	if (obj_cgroup_is_root(objcg))
> +		return;
> +
> +	VM_WARN_ON_ONCE(!(current->flags & PF_MEMALLOC));
> +
> +	/* PF_MEMALLOC context, charging must succeed */
> +	if (obj_cgroup_charge(objcg, GFP_KERNEL, size))
> +		VM_WARN_ON_ONCE(1);
> +
> +	rcu_read_lock();
> +	memcg =3D obj_cgroup_memcg(objcg);
> +	mod_memcg_state(memcg, MEMCG_ZSWAP_B, size);
> +	mod_memcg_state(memcg, MEMCG_ZSWAPPED, nr_pages);
> +	mod_memcg_state(memcg, MEMCG_ZSWAP_INCOMP, nr_incomp_pages);
> +	rcu_read_unlock();
> +}

[Severity: Low]
Could obj_cgroup_charge_zswap() be removed now that its only caller in
mm/zswap.c has switched to obj_cgroup_charge_zswap_many(), just as
zswap_pool_get() was replaced by zswap_pool_get_many()?  Leaving
obj_cgroup_charge_zswap() in mm/memcontrol.c and include/linux/memcontrol.h
duplicates the charging logic with no remaining callers.

> diff --git a/mm/zswap.c b/mm/zswap.c
> index 8c36344000f51..5ef1ae67e67a9 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c

[ ... ]

> @@ -1711,17 +1702,86 @@ static bool zswap_store_pages(struct zswap_store_=
context *zc,
>  			zswap_lru_add(entry);
>  	}
> =20
> +	/*
> +	 * Each batch entry is successfully compressed and stored in the tree,
> +	 * and further failures will be cleaned up in zswap_store().
> +	 * Next, we do bulk accounting for the batch: grab refs to the pool and
> +	 * objcg, charge zswap memory, increment zswap_stored_pages and
> +	 * zswap_stored_incompressible_pages. The opposite actions will be
> +	 * performed by zswap_entry_free() when the entry is removed from the
> +	 * tree.
> +	 */
> +	zswap_pool_get_many(pool, zc->nr_pages);
> +	if (objcg) {
> +		obj_cgroup_get_many(objcg, zc->nr_pages);

[Severity: High]
Does calling obj_cgroup_get_many() here break the build when CONFIG_ZSWAP=
=3Dy
and CONFIG_MEMCG=3Dn?

include/linux/memcontrol.h only defines obj_cgroup_get_many() inside the
#ifdef CONFIG_MEMCG block, while the #else section only provides stubs for
obj_cgroup_get() and obj_cgroup_put().

> +		obj_cgroup_charge_zswap_many(objcg, total_batch_comp_length,
> +					     zc->nr_pages, nr_incomp);
> +	}
> +	atomic_long_add(zc->nr_pages, &zswap_stored_pages);
> +	atomic_long_add(nr_incomp, &zswap_stored_incompressible_pages);

[Severity: Low]
Should the incompressible page updates here and in
obj_cgroup_charge_zswap_many() be skipped when nr_incomp is 0?

In the common case where all pages in the batch are compressible,
atomic_long_add(0, &zswap_stored_incompressible_pages) still performs an
atomic read-modify-write on the shared global counter, and
mod_memcg_state(memcg, MEMCG_ZSWAP_INCOMP, 0) still runs get_cpu(), updates
per-CPU stats by 0, and fires trace_mod_memcg_state() with val =3D=3D 0.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106072412.7909=
-1-kanchanapsridhar2026@gmail.com?part=3D7
