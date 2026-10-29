Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.41
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793314827;
	b=hCjDDu/wFDTzq/tlk1vzTyNv6UtTOnfB4qBv2AMHu9PGyv05ovsFD7XeFpOwPcNduK1Y
	 E2aKzEV5V+XzVNDR8hv2YF4NXBdhLYcoUXK5XzrfcUxWt1/Aw6K3hEEFp0KpZzxc8AMe2
	 cXN2qeQ/rypq5fCaglBRm3+uaovy5VVmNigg79oB3bf4jleGBqZSU1GlBg37q7A4aaYvc
	 N81YRiyv7esn3k+o8YMC0mG1wizzmlo3hcSATeJi2HjsrxHjEEnlX1JLvb9izogl57XH7
	 SUCbLO9/2k2OCLLuGEIvR7eHhvRNuoQaRo3ePv2gzDkCs2+SWi6AFbrn3TV7YC1Uc5g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793314827;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=OjIFR9RHuZyb+FQlUiSJHHP2buOKCHCE0JjDFtdSiWE=;
	b=X5lxVUquIZUYZbGmdhdVf/4GKMeZVlPGK9rV2GSnQo0Dn5jaarhVL3EtlKkljoT3Ewex
	 n5uFyz+LqA0jLLKmOix0i3FSI5CXoUFHvqSS7LxZLBFsGD4nuV0MoowQroJjTWoENVfUC
	 5MaGZREHLzu+cN/qINlFnFMIeyWBek44ZytSm6RT0SYOyvc+ua+nrvpe0zJ38uutQZ0/Q
	 MjcgZS+OIarkSZPWTKs6UdXMFXjHKezX3v7umQMaBeYarNNfzqsNUEsc9vD/OSIuLAo4/
	 P7CaL3wwUOBDLqHgKAsi+II2nLoJJaAr0k5Hi55Hn+KgTOghlE4zeBK5X8NvKyS3naw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XS86gjiK;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.41
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47766606A31D
	for <linux-crypto@vger.kernel.org>; Thu, 29 Oct 2026 23:00:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 47766606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XS86gjiK
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5be4c78e8caso185093e87.1
        for <linux-crypto@vger.kernel.org>; Thu, 29 Oct 2026 16:00:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793314825; cv=none;
        d=google.com; s=arc-20260327;
        b=dqcf1DKBCZIgyQCl7g8uB+v87J/ZMDsnxAKth8yT57PZSoJ7BkBYR+rx75O5IKpTnD
         vOT/MIyp1CJzAsIM2Ing/ysSzwK/KPVJ7JIVuRhw0TD7cakYeIzs8w3wDOaM95ycHJhK
         40q7o/B9u9563KlwfyV2sLNCGDhZL4g4oO3Re8DM2IrTiuxkiF9KoWr5PX3+Hf3jIfp9
         Lr0EQ54RJkPoha25HLOlWjWeSot4fCCBakl/06Qjy8C9uCVmCeXOHO48C0V25zdxJK2V
         LRIfd4v9VpHggo2C49/OG5xv1TeBkqOibQxDi1obKX0+7DFr0wEFW0hZf1NSrdAXa+Lx
         YnVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=OjIFR9RHuZyb+FQlUiSJHHP2buOKCHCE0JjDFtdSiWE=;
        fh=gJYa5hMoPJiVcTJGYigoLQt1OuGnneE2X7NOdTrClOI=;
        b=hLj4ch3ZTWRw3dKXoEfCB8R0Tp4nQ0L6Ok0qedQKSg7rGDu++Ta/WdZz4d2fODG2PI
         3879jYQ7BHhpd3HKy6U9wUILP3LKR5sc2Zkp0XHmWUO8xDxXUAmbK29r7ZqX0AUCAGeb
         yem6iZj88MJDXfe7tMGAAjY2xx2U3GJmT4qmnQEy4UF9vzPmLkakiUhvzq13y/tT+ycq
         PnpPoLuYz1tmyr6jR1+V6nq5kilCv0XLF9BVy0dAkkQcZyhws5R32trJGeEWvsQljJ3G
         ztydQFUrFiTyPMItUJSb/iFDtXwuVawQ++m1gvj1VKLbX2XZyTDKkIq+wkNm2SfDmlxU
         KXuQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793314825; x=1793919625; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OjIFR9RHuZyb+FQlUiSJHHP2buOKCHCE0JjDFtdSiWE=;
        b=XS86gjiK0egZk81cVgFgrvOGZ6KgBi3XgTyauxO3ijrkTAl3jE9ki7AQx0hiylee7E
         O4jcPO/9WCXh71jOL85BKj2xHRXL6sL/5x7kq6ifYZHbkyhgoG+0kdXZzyq0ZsDHbNhB
         AkHaNn9owgG/tV3h24nGgbTWhwbwx5stP2zFm8apCdEslZzo6wfLQBD6byiLdHCC1TSC
         q8jPuRZ1MLndiJyyvZXUvfrBK+JH68x1NmJK0f2dnrWhT1j7irrVhdn4BPBWlyf/Ywc8
         cadgBdaRREbh9+JRcAsMahrDGcW3n8gpYkS0roKNbbx0TmtQxEgquigPT2ojDSoxekSu
         ZO8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793314825; x=1793919625;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OjIFR9RHuZyb+FQlUiSJHHP2buOKCHCE0JjDFtdSiWE=;
        b=hdtj0bvuIVqKCbXhIAdDAxvnxw9vdQqN+1s/589Van1Kp3jtxjceFGMqcpdZkhP5cl
         Kk1PZTe18tlawzLQsR+epgp+I9JzjHlG7nxge53TVPPnAyJpqo5SNXDuXuOufJcrz0pR
         U6a1kP1SoNFQB1YqfF5fzBF+ve3FKvI4jZVDHxVXBzeGBqfYzKZUpBDi6PE9p4T2ivdU
         E8qP1b9FEPPXnPOK7ydgcZwsa/TJ4Uqp57JARBl5PKzxid80RJzYWU2HNqSykFFXcIqA
         wHG+QgcCt27JhU6zQ5nfE97MSbV1zQindy+Cmr9yTELgPHLoGI2RjF1/mYiFmIzPxXMH
         UwLQ==
X-Forwarded-Encrypted: i=1; AKwUvBzvVFOeF2tyEGAcw9+agJhWKIGuPi0oihOLTPz2GRG5otbknVj/WcGJgZMAzLKPoqV03rA1sljJzfkcaws=@vger.kernel.org
X-Gm-Message-State: AFq9FYKnIAtxREsawK9oGvMyYGttj1u5eAzlMPYex4BScJlnFfJCBDnm
	u7UnqID+ScPHd9ylIzIGB7DcJFyndDuDKZVzkjg5FSm+1aYohOX2SBFEkTu5Pxvcb/K5TsjcL5X
	PT7smPCJgixSlsv68+iob/U8YcU6kdRg=
X-Gm-Gg: AYBFou2qqp1ArrCJ6bVYClnNYm0IDZhjWhJcE+MXc2md5r7ruBXmTmgyE0IVMK95vsD
	4lvD7R5P9aDWAHqdXOx1a7SJVWandV/bIzU6w0AUOGlmu6iwnlr+sd+HyBDZg4BqAUf8IxGBlog
	6Ou4SXeFC70fF57K0XMkVbP9usHwuitF8dGZIb1WHikmF1W+6M0eS2JbVuQESRqqJVZJ5pS7eTr
	LDJ6IhXAEqXTe1osXnviXkx76p/OcoXH1Zvgp5w+R2LhbS6ACsd8WU6IfMJdko6Y+lpb/4a3Kzz
	YHO7Wdj4DKmS+ijzPoo2QdddDVHVhcGvpzLzDUS7PLncY693xkd1djokK9CIWWM2tzMLp1fHCXH
	jYkf/McoH86LjWC0ahf0ZFYiAMJaGUqWhmVED
X-Received: by 2002:a05:6512:32c9:b0:5bf:aad9:df71 with SMTP id
 2adb3069b0e04-5bfd95208d7mr108143e87.7.1793314825046; Thu, 29 Oct 2026
 16:00:25 -0700 (PDT)
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
In-Reply-To: <sashiko-outbox-188657@kernel.org>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Thu, 29 Oct 2026 16:00:11 -0700
X-Gm-Features: AclHuK8vPy78HoUW065_s9Da2om9WIPFjJ9GZXx-qNzNfH1rQXOgW4zxEQfJFis
Message-ID: <CACpmpofjVP17TpyieQ2khsdRL+FMX9oCEcaNE9Hh+vBfGBO2dA@mail.gmail.com>
Subject: Re: [PATCH v2 5/8] mm: zswap: Store the folio's node id in the zswap_entry.
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
> Thank you for your contribution! Sashiko AI review found 2 potential issu=
e(s) to consider:
> - [High] mm: zswap: off-by-one bitfield width for zswap_entry.length on 2=
56KB pages
> - [Medium] mm: zswap: shrink_memcg() skips non-N_NORMAL_MEMORY nodes in z=
swap_list_lru
> --
>
> commit c4aa889f59a75fcf871276fd68b4a4738afe132b
> Author: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
>
> mm: zswap: Store the folio's node id in the zswap_entry.
>
> This commit stores the folio's NUMA node ID directly in struct zswap_entr=
y
> instead of deriving it from the slab page backing the entry, and converts
> zswap_entry_cache_alloc() to use node-agnostic slab allocation. To keep t=
he
> structure size unchanged, it packs length and referenced into bitfields.
>
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index e1d57a7d95950..19b7d60bc7d2a 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> > @@ -180,6 +180,7 @@ struct zswap_pool {
> >   */
> >  #define ZSWAP_FIRST_POOL_ID 1
> >  #define ZSWAP_MAX_POOL_ID U8_MAX
> > +#define ZSWAP_MAX_COMPR_LENGTH_SHIFT 18U
> >  static DEFINE_XARRAY_FLAGS(zswap_pools, XA_FLAGS_ALLOC1 | XA_FLAGS_LOC=
K_BH);
> >  static struct zswap_pool __rcu *zswap_current_pool;
> >
> > @@ -206,15 +207,19 @@ static struct shrinker *zswap_shrinker;
> >   *              logic if referenced is unset. See comments in the shri=
nker
> >   *              section for context.
> >   * pool_idx - id of the zswap_pool that the entry's data is in.
> > + * nid - NUMA node id of the page for which this is the zswap entry.
> >   * handle - zsmalloc allocation handle that stores the compressed page=
 data
> >   * objcg - the obj_cgroup that the compressed memory is charged to
> >   * lru - handle to the pool's lru used to evict pages.
> >   */
> >  struct zswap_entry {
> >       swp_entry_t swpentry;
> > -     unsigned int length;
> > -     bool referenced;
> > -     u8 pool_idx;
> > +     struct {
> > +             unsigned int length:ZSWAP_MAX_COMPR_LENGTH_SHIFT;
> > +             bool referenced:1U;
> > +             u8 pool_idx;
> > +     };
>
> [Severity: High]
> Can entry->length overflow to 0 when storing an incompressible page on a
> kernel with 256KB pages (PAGE_SHIFT =3D=3D 18)?

Good catch. This has been addressed by setting
ZSWAP_MAX_COMPR_LENGTH_SHIFT to 19U and the build time assertion check
for BUILD_BUG_ON(ZSWAP_MAX_COMPR_LENGTH_SHIFT <=3D PAGE_SHIFT)), as per
Sashiko's suggestion.

[ .. ]

>
> > @@ -1507,9 +1506,10 @@ static bool zswap_store_page(struct folio *folio=
, long index,
> >  {
> >       swp_entry_t page_swpentry =3D folio_swap_entry(folio, index);
> >       struct zswap_entry *entry, *old;
> > +     int nid =3D folio_nid(folio);
> >
> >       /* allocate entry */
> > -     entry =3D zswap_entry_cache_alloc(GFP_KERNEL, folio_nid(folio));
> > +     entry =3D zswap_entry_cache_alloc(GFP_KERNEL);
> >       if (!entry) {
> >               zswap_reject_kmemcache_fail++;
> >               return false;
> > @@ -1524,6 +1524,7 @@ static bool zswap_store_page(struct folio *folio,=
 long index,
> >        * to an unrelated live pool.
> >        */
> >       entry->pool_idx =3D pool->idx;
> > +     entry->nid =3D nid;
>
> [Severity: Medium]
> What happens during cgroup or pool reclaim in shrink_memcg() if the swapp=
ed
> folio resides on a NUMA node without normal memory (for example, a
> ZONE_MOVABLE-only or ZONE_HIGHMEM-only node)?
>
> Previously, entry_to_nid() derived the node from virt_to_page(entry), whi=
ch
> was allocated from slab with GFP_KERNEL and therefore always resided on a
> node in N_NORMAL_MEMORY.
>
> With entry->nid now set to folio_nid(folio) in zswap_store_page(), anonym=
ous
> and shmem folios allocated with GFP_HIGHUSER_MOVABLE can have an entry->n=
id
> that is in N_MEMORY, but not in N_NORMAL_MEMORY. zswap_lru_add() inserts
> those entries into zswap_list_lru for entry->nid, but shrink_memcg() only
> walks N_NORMAL_MEMORY nodes:
>
> mm/zswap.c:shrink_memcg() {
>     ...
>         for_each_node_state(nid, N_NORMAL_MEMORY) {
>                 unsigned long nr_to_walk =3D SWAP_CLUSTER_MAX;
>
>                 shrunk +=3D list_lru_walk_one(&zswap_list_lru, nid, memcg=
,
>                                             &shrink_memcg_cb, NULL, &nr_t=
o_walk);
>                 scanned +=3D SWAP_CLUSTER_MAX - nr_to_walk;
>         }
> }
>
> Should shrink_memcg() iterate over N_MEMORY instead of N_NORMAL_MEMORY so
> that entries from movable-only or highmem-only nodes can be reclaimed by
> shrink_worker() and mem_cgroup_try_charge_zswap()?

Conversely, is the previous behavior correct? The entry is created on
a node in N_NORMAL_MEMORY, and when that node is under memory pressure
the folio (allocated on ZONE_MOVABLE-only or ZONE_HIGHMEM-only node)
could get written back. This doesn't resolve the memory pressure for
the node on which the entry is allocated.

Nhat/Yosry/Johannes: Does Sashiko's suggestion for the shrink_memcg()
modification look Ok to you?

Thanks,
Kanchana
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261028030503.17=
923-1-kanchanapsridhar2026@gmail.com?part=3D5
