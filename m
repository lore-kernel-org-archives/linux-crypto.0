Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.171
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795296152;
	b=WtEcNtWBAx5TgugsjS0m9dht4y86il34Jv5FG8jNFNy7OkwzE17x337GjyYXgjSAPh21
	 slTyL0rOhMOIWo8q+SMh5NaNfuu7IQ2MfDUhRL40pD6gxlc/ZNXjhSog/+j9fVJH5mdRo
	 egsBO71J1VNprcgK6sCJCqckb+2snqYeZ79gW9VNdwWp0JEKHDBfM/+JxMn0Y0JxMecI6
	 pFMV+Haas0YJJGXD15lJ94NLpPpTQQ6QtZNVd8gk9zBO7+mM7lufYHgucmgm5m2Vw7Mtg
	 wiRw9cDQ6kW1HX/ZJKAkk9wOduNfdqRjqBb9tyrMBvN2IGSsZhbSpsEY5PCLrpcUgOA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795296152;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=rGcrw4mT7NdiqFu7SkETRkItggb0uYK1nbamCet3nRg=;
	b=WygmiejyfQgh778UEd7Wcbz7QcJE7vvuJAi+H/x8nW672pMD3oRTVKtXsc00WzNTneWd
	 isNvmwNFoj8pMIM1/5EWzHX9mNDcw5GhPzyC6k3T50fDiSqfCssDs4SdYrpY1y33ZBSUc
	 q/B8RZ1IejucUn0Gwn/WLXDa4DMTHB+mx3OrPiMOTw3D/Wbujwj2Sgm3evYsp1TOqf/+N
	 m5hryeBJZVeNviXHNORM5OIpbcFe0rKY7x2ePvoFiTtSTT1wK9kUZzsT6CUtKEUbawbKe
	 4qxvNXAaOcWTTCrgKy/y07gsTtyoeeL9tB8sqdl5xJB/ydEHm9BhVujWI1BRbyeG02w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=g20LdADQ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.171
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C6F8606A32C
	for <linux-crypto@vger.kernel.org>; Sat, 21 Nov 2026 21:22:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1C6F8606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=g20LdADQ
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-3ae0d0b9db2so18897891fa.1
        for <linux-crypto@vger.kernel.org>; Sat, 21 Nov 2026 13:22:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795296150; cv=none;
        d=google.com; s=arc-20260327;
        b=VJHDhtOI+zSyNciG9Cj17WhPRttxXvA+pUOCJLoglIiDqUedGFsv6gBFqbhZCtR1yf
         3LaIeRRJ3/PAburX6TKwVxHLSeGwuGkWpqZB/uZssWhx8P2D/p/q8gx3if94QpCy/GEa
         /PB5aXiIqs0yC2nULCAXfOgOkk2Wke/Brm0Pj5FPKPntK9oJP5iEf/w7Ts8V5ig5Aqtx
         zapEOjq3HU5NjmSVy8DiAGGTBAiTUD+7MRiKNfXNweWzeNP4BYTLM91WWo4veDCzeKMe
         pGB5RSci9YMKzcWLUfV6jFN/rUHJdg7sDsxy1lJhmqG8EivPue7gbbc6VP/enHYT8pFb
         umcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rGcrw4mT7NdiqFu7SkETRkItggb0uYK1nbamCet3nRg=;
        fh=6vcXTgJDKs5jPr54Eg32GZFw3ILYou5t1GyAvwbCx5Q=;
        b=XcWUfkctg4wmVnSc28FDGgWZcSwdBt5mKh2An18UiArGmPKNtI5AGYbWQnDZTrt8vJ
         I6hzXH201uPGCSLTWR+fpYIAjqZLjard1URzjyOTOiEqBR5hHmcACxnXyUlX+HsdpmSp
         hn0sqE9wcFrb3dwg4ANd857D4UmPdU7b6dqB1jhd1/a1IkmeCuDqtdxoaCIQptwbQ8Ob
         8rQ32pyraTzgp818jPDWBRBAQA+co2odzIpFvhV8/cwPDOufg1gvhtJynb917xxtxN++
         aw3YU+Hw3hgzTffc7Z34xkfLfyZ8swRDRf/5otBtSmFRYPfxYyPrMUW68qwta++QsGHZ
         xtOw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795296150; x=1795900950; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rGcrw4mT7NdiqFu7SkETRkItggb0uYK1nbamCet3nRg=;
        b=g20LdADQAo4dkhKG7EcROCfHoiNAF6OzdDCUrl+kqp2ypTtBkI7pMcBQg2vDWhqJOp
         RWcf3WushPfzucyxKdsLQLYITEdwFjXr+MjiyAQC9LqAZBNnQVoZwDi68hLDrf/34ikd
         ALuw1UjZAoIiCa034TxHoSqkdUNZkrr8Br2QdTNaWW0RHHPR7u2M01rFmxwVWHmk3U4u
         dUp+K/eQ52WLwjDU+yT8yu11vkU12hXdu3L7zJa9HMyxwwUrOwK1UUOD0KtCuhaQcFrz
         qez8HLAV7LwYtP3CQWKYzmjglCto1iof7jPA4G9QGHC4N8t2/4tIMPMrJjHehmtPJBNv
         OZBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795296150; x=1795900950;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rGcrw4mT7NdiqFu7SkETRkItggb0uYK1nbamCet3nRg=;
        b=ibfxJyxWtscD5gsYRm5fMwqtlju5fYCWjHP/kcxRtP7cJeWQdZBzSOnR1EdKNuodnx
         whMsX0d66LlbXtF7fVMopHFlh5DwJiQJVE3HAHnc8YQ0IFnSeDbrHIg2pNTZL8qn99NJ
         MF55GuN9vz6UU6uXpo2evO0YJ/o4W3lcBT1HqxV69YHKQZGn3hLf4rfleg1sXuQo2eYN
         sCkupLKv4lNAyeYwj13cQcsjeMgOCFJKvp/U6CSZ0Mg4ys60j1wkhb8QWnMyTyjog+mL
         m6KvWkv1RfLQB2RAa7giQgBdkHt2+AZIUCsvo03IwCJQSPa4k/X4awBvV2cfvfRzIApg
         blwQ==
X-Forwarded-Encrypted: i=1; AL+hErGs1+qWb03aRjttV8VP8aF79cfB1783nI4sGv8L5JpIEKopIQR/JGCYVImUhUBPyHNVB/AZqG+3vcvoLQE=@vger.kernel.org
X-Gm-Message-State: APuU4Z8uIBB2hoVJEgxHtb5Ca4WX9nRTRmvIIJLzLlDgOF+Uuu2uZzb4
	LrNj5QOvPOsjRjXe0RID9sVJSn/2i1YD2t9EDicjsqr5Sm155GS6TwWMRdNKqV6O42g5aTdDPYv
	P3Dlr3auHsIdc7yyKQ9CoD90cpXtKw98=
X-Gm-Gg: AZFdTZfiSBs0jH8nF+YF3AmeOT0iXCk3zmDsYdTLgkIK5HQboGWci7HPzFPGPZIsRxm
	wbuE6jTiY8/Ouvq4PwCtbDh/SFDQduEMx1YE0M0lo6ub7xjZJ0S2UcEcdno8EiIa4eBAZxH/5Fs
	Kkh2gqVI58XemsVJ14jiaTnYbisGbg7GvQvxDrjjJgZcWiyr7ch2G+XzdqH0fQC4iX5cqCzDmoW
	Wk2qtuvBQsuKpMN/5KjPNiDQvymP72zju4af67grgy/vsCh6VEiO9N0/ME2VaDUSKTlUT4tyvJ+
	dzfmLv8X6Is4jdLUJRtDQfzw0kyWfGNyLC6Y+Ew3u2KtcJMM7wQ3M0UHU+nt7VX+GOeDrdw6hj8
	K8z25xxmt5P/InH8ntqvbKevlbHANstLpR1K4
X-Received: by 2002:a2e:b8c9:0:b0:3ab:344e:373c with SMTP id
 38308e7fff4ca-3ae7f9d5f36mr20017261fa.5.1795296150106; Sat, 21 Nov 2026
 13:22:30 -0800 (PST)
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
 <20261120041906.5785-6-kanchanapsridhar2026@gmail.com> <sashiko-outbox-226635@kernel.org>
In-Reply-To: <sashiko-outbox-226635@kernel.org>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Sat, 21 Nov 2026 13:22:17 -0800
X-Gm-Features: Aa3M54osTYEDX87du_Iyy9mI8Cvq-0UULn2mX3Kv6V_zPCZindyaWLd_Ecpy6sI
Message-ID: <CACpmpodVacE6-7=sOh7-odaDytspcH=+9u-B0-zkO6c8W0JiwQ@mail.gmail.com>
Subject: Re: [PATCH v4 5/8] mm: zswap: Store the folio's node id in the zswap_entry.
To: sashiko-reviews@lists.linux.dev
Cc: hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org, 
	herbert@gondor.apana.org.au, davem@davemloft.net, 
	linux-crypto@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 20, 2026 at 8:20=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Medium] mm: zswap: shrink_memcg() skips non-N_NORMAL_MEMORY nodes in
>   zswap_list_lru
> --
>
> commit e4e47a21782dc39867fe81289fb7e9ed7f2692b4
> Author: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
>
> mm: zswap: Store the folio's node id in the zswap_entry.
>
> This commit stores the folio's NUMA node ID in struct zswap_entry and use=
s
> it when adding and removing entries on zswap_list_lru, instead of derivin=
g
> the node ID from the slab page backing the zswap_entry.
>
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index 9a323862bd59d..78d9694f75b5e 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> [ ... ]
> > @@ -680,14 +685,8 @@ static int zswap_enabled_param_set(const char *val=
,
> >  * lru functions
> >  **********************************/
> >
> > -static inline int entry_to_nid(struct zswap_entry *entry)
> > -{
> > -     return page_to_nid(virt_to_page(entry));
> > -}
> > -
> >  static void zswap_lru_add(struct zswap_entry *entry)
> >  {
> > -     int nid =3D entry_to_nid(entry);
> >       struct mem_cgroup *memcg;
> >
> >       /*
> > @@ -704,19 +703,18 @@ static void zswap_lru_add(struct zswap_entry *ent=
ry)
> >       rcu_read_lock();
> >       memcg =3D obj_cgroup_memcg(entry->objcg);
> >       /* will always succeed */
> > -     list_lru_add(&zswap_list_lru, &entry->lru, nid, memcg);
> > +     list_lru_add(&zswap_list_lru, &entry->lru, entry->nid, memcg);
> >       rcu_read_unlock();
> >  }
> [ ... ]
> > @@ -1537,9 +1536,10 @@ static bool zswap_store_page(struct folio *folio=
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
> > @@ -1554,6 +1554,7 @@ static bool zswap_store_page(struct folio *folio,=
 long index,
> >        * to an unrelated live pool.
> >        */
> >       entry->pool_idx =3D pool->idx;
> > +     entry->nid =3D nid;
>
> [Severity: Medium]
> Can shrink_memcg() miss zswap_list_lru entries when a folio resides on a
> node outside N_NORMAL_MEMORY, such as a ZONE_MOVABLE-only CXL or
> hotplugged memory node?
>
> Previously, entry_to_nid() took the node ID from the GFP_KERNEL slab page
> backing struct zswap_entry, which was always in N_NORMAL_MEMORY.  Now
> entry->nid is folio_nid(folio), which for GFP_HIGHUSER_MOVABLE folios can
> be any node in N_MEMORY, while shrink_memcg() only walks
> N_NORMAL_MEMORY:
>
> mm/zswap.c:shrink_memcg() {
>         ...
>         for_each_node_state(nid, N_NORMAL_MEMORY) {
>                 unsigned long nr_to_walk =3D SWAP_CLUSTER_MAX;
>
>                 shrunk +=3D list_lru_walk_one(&zswap_list_lru, nid, memcg=
,
>                                             &shrink_memcg_cb, &ctl, &nr_t=
o_walk);
>                 scanned +=3D SWAP_CLUSTER_MAX - nr_to_walk;
>         }
>         ...
> }
>
> Entries stored from non-N_NORMAL_MEMORY nodes will never be scanned or
> written back by synchronous cgroup limit reclaim or shrink_worker().
> Should shrink_memcg() iterate over N_MEMORY instead?

v2 5/8 response to Sashiko's comment:

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
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120041906.57=
85-1-kanchanapsridhar2026@gmail.com?part=3D5
