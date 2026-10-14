Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92564288D0
	for <linux-crypto@vger.kernel.org>; Wed, 14 Oct 2026 01:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791940658; cv=pass; b=GqdGRpVzlHQzTGu0xntp46UvCIM0S6AsAj7G7Fs2x2hqZ5/6azif/SPvnrG5umZRy/k4s47EpvR66JMUEt1cGryQ0qTpmir+sdf7nVTsE2DZA7PY23EWtrZ3WLmjAv0t8Nl1rX9fsrXOo8HtxDxM/YQotML/vqSNidQypWy1a3E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791940658; c=relaxed/simple;
	bh=AREZaq9AoShdZqxsl4otYZHYQiLB3tn4o/O3zRDrcOg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rIOL7oUqAou26vJ2HiOLWXzcMBQb5OAGFSD28u+OBlBSpXZHO6S9aJrEyOzrBd5SRqr/7cSeYylkMw64ADhCQDM4mvii8fm74OXPhM44GlFE82j1DJwYoUaIz6LYoRjsqGMSp/DJmw5QtsnqAoe0VUUHEed9aFPHYuTc3UH6XvA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Tjx6f6yY; arc=pass smtp.client-ip=209.85.208.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Tjx6f6yY"
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-3a9ad623098so31655691fa.1
        for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 18:17:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791940653; cv=none;
        d=google.com; s=arc-20260327;
        b=Q/rxmMWtsG/ji5hlxjafLgIgddem2+OHNPAkDJ6aRvJaWEBRVT0+//OVN94ozYJTZz
         CcL+6c03AsupocL5iC8xF1YamhMcPjL7DAvycrwCBpH6lFW+t3FG1SXB1UPwa32mHBWd
         fNRKGQmHbHbJHhbeLA+5zd90ZIoR8vA8Nzh+Q5PdkKhz7DpV7hdx+ljJ2DpYJ/pF1LLF
         kOnEUDStojmu12hWeP/FGGEwqR+50zUvhHyBU5+/HWWN61ptaJTGTV3pwr/hK7xaw/Wk
         W8oaAToqF49lRRNwgPQwdphpJsx4nBettUL84mIx2Q7lZe6tOzQF28ldReukJlGeYZJ1
         abCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wyQBM5A+sbr/bsu9Xm3Evkx/SvDUAAi47Tsf2PiRHKk=;
        fh=sXtQGTOpg+zVlodn4vMwmByCHhv2COipbPlkq4F4kyQ=;
        b=R+JjIgB3Cap3pcQ2nGa1HwOvDg8c18Z/JSuQcnR1SD8orTpve8Otf9IfedNUpHvCt9
         Jdh6bP3rfUChWNDk1aMTyjbeojKda5B0a7+3EGpFIU5MfZyKwspVvf23InXvssmQsu2U
         gLl/teMIDTFIzYb01mN1F1UdDYRYVDUvBkcYXHN38xuNff/wm+f68iyIU9FMSTn8XWvL
         F4D/cKKOV8jLQ/XMx8YBONPG9synFLsLAX9wP/hdqEZPIIMBKgzEm9mr+jJ+wwKpYD4v
         rGkd5tBWw0IPHjdwEyPpdhMMz3cXvmvNQxSEIohzgXw/wf9jiEIkAvJjgbbXOEoMrdlN
         WarA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791940653; x=1792545453; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wyQBM5A+sbr/bsu9Xm3Evkx/SvDUAAi47Tsf2PiRHKk=;
        b=Tjx6f6yYZ2XTYboFGXkBJ9cTWxnaJHUdXNNq4latGc5MaLbJ/w9DsKRmcPkLUvyreu
         su+Tur95jI8yeg2ju6X93/qL8oeyaPjTSQXxcUXDm6QQ+acr+m7IJ+ZT8TY2C6NWpwfN
         zVk+V6HoyhHZj1fxVmbmv6utR3S6E3DwiUS/hnwbsmWirz56cj9zhEExa+6K2rXl1oMb
         bglNfwbZ7h4oxFuPijKjZheV/Vp3LFUqvdhblXyc0z50bPKNzpk8sJggsg244Z/9ILQR
         tbXi75r2TSlDgYlMbLV7Aua7/fgSso1Pg9ucdxIq6kJZzv8ClPUwL50IeaHV6uwgHne7
         R3Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791940653; x=1792545453;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wyQBM5A+sbr/bsu9Xm3Evkx/SvDUAAi47Tsf2PiRHKk=;
        b=Fp1BUF8lTnjFmYDmDvIG5+m/5uQwhXjdUe/9FbKt/3azgMxhIzNk09i9HP4BVMVliX
         eXO6iIDEImbmnuTCQp3wnVccM6FO356k9uXKthaMhe9X0FycVQJ9dsXsZGPoMo//hOOW
         thThQ99JVURtAHFndvvai/JooKf/Tf80R86ywe5XtpI7k0n5dIMyxop9UQErKJdb2xdi
         ebieQK6I7fyS5dOMTAYWh/SybIdz6CsZsX5gwpOskckx6K5sYgjmfIZwkO0c8nQffqBj
         xF1jr+p4GSu/rJQzyBxfUliQjDfxdEg9XVq+XB+yeIzCpDN3bXlkv+d7k4WmNAh2+LPr
         hU9g==
X-Forwarded-Encrypted: i=1; AKwUvByyejwC/1ofjEW73WnpBNK2RheO90G4oz8X6qVLuhe2ub7qhaCMtOipZrPlH/b4VsmBoxdhfD/f+lV35qY=@vger.kernel.org
X-Gm-Message-State: AFq9FYJ/wpU8x/wT3qPaSZf64OICmVnyjEkR3ZXiuKHSri0HBlodKgLu
	llla/dhImlHWI48UspeWplpkUX57a8iH36jpaTj1wBXR3fFhsli7NeAnJETnD/CKUQO/vHBrlSf
	nYbfseJGzJFKMvQg6eyjWHvjnbYBY8J8=
X-Gm-Gg: AYBFou3Uv3hAcNDqujdOa1EW8qOg2ZRO0Np+TP9c9BmC8GJiEG7v4bF2WZW5kRFmz0J
	XECl2TInF3Mz6NnYekXjBiukH3zsETXH8UJM+30ISrI11PQXqAPIlo9qsKXt5OA3tkYx/uMSWcZ
	/MhYEOdKrBxtBoUo9puJXIGaUa8qaFAGDpAlceT5q8TOYOuEnBGa/8aZ9gWBhiVItIp7qS3/lgI
	KGqwxQppvxulKlS/Pv2dSAQ1XNRxIPSoVFWV2bMRdav6JAC2KMY5FOdcHv9YECxQUY1n1IzBKVF
	+1VK4bTDmgAa58rbczLGzUz9UedQ7/dQQf6ywxPUGnwMKs7s2E0MUoQ=
X-Received: by 2002:a05:6512:b8d:b0:5bb:7c8e:15b2 with SMTP id
 2adb3069b0e04-5bcde6c4f1cmr5490083e87.31.1791940653284; Tue, 13 Oct 2026
 18:17:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
 <20261008182814.27450-6-kanchanapsridhar2026@gmail.com> <as7JC8o2kggiq_ss@google.com>
In-Reply-To: <as7JC8o2kggiq_ss@google.com>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Tue, 13 Oct 2026 18:17:20 -0700
X-Gm-Features: AclHuK9N-1t0qH1Ne5SzX5aznAgKqSCO5xi8WT7N5o98qXn1u4mrNoAaAXjfoHU
Message-ID: <CACpmpofXMGBP70Rn7jHLwOF38GRKMUGoW3rb1Jp2SPH7ygKcfw@mail.gmail.com>
Subject: Re: [PATCH v1 5/8] mm: zswap: Store the folio's node id in the zswap_entry.
To: Yosry Ahmed <yosry@kernel.org>
Cc: hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 13, 2026 at 5:18=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> On Thu, Oct 08, 2026 at 11:28:11AM -0700, Kanchana P. Sridhar wrote:
> > When storing a folio in zswap, save the folio's node id in the zswap
> > entry instead of relying on the zswap_entry being allocated on the same
> > node. This enables optimizations such as batch allocation of zswap
> > entries for large folios using kmem_cache_alloc_bulk() that does not
> > support specifying a node id.
> >
> > The size of the zswap_entry remains unchanged as 'referenced' is lumped
> > in with the 'length' (as it doesn't need a full unsigned int anyway).
> >
> > Suggested-by: Nhat Pham <nphamcs@gmail.com>
> > Suggested-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> > Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
> > ---
> >  mm/zswap.c | 23 +++++++++++------------
> >  1 file changed, 11 insertions(+), 12 deletions(-)
> >
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index ca513a9f89e3..c2731d3acb2c 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> > @@ -194,6 +194,7 @@ static struct shrinker *zswap_shrinker;
> >   *              writeback logic. The entry is only reclaimed by the wr=
iteback
> >   *              logic if referenced is unset. See comments in the shri=
nker
> >   *              section for context.
> > + * nid - NUMA node id of the page for which this is the zswap entry.
> >   * pool_idx - id of the zswap_pool that the entry's data is in.
> >   * handle - zsmalloc allocation handle that stores the compressed page=
 data
> >   * objcg - the obj_cgroup that the compressed memory is charged to
> > @@ -201,8 +202,11 @@ static struct shrinker *zswap_shrinker;
> >   */
> >  struct zswap_entry {
> >       swp_entry_t swpentry;
> > -     unsigned int length;
> > -     bool referenced;
> > +     struct {
> > +             unsigned int length:31;
> > +             bool referenced:1;
> > +     };
> > +     int nid;
>
> This will increase the size of the struct now with pool_idx, right?

I was gathering the struct size with the struct {unsigned int
length:31; bool referenced:1} as suggested in v14, for my before/after
comparisons:

before:
struct zswap_entry {
        swp_entry_t                swpentry;             /*     0     8 */
        struct {
                unsigned int       length:31;            /*     8: 0  4 */

                /* Bitfield combined with next fields */

                bool               referenced:1;         /*    11: 7  1 */
        };                                               /*     8     4 */
        int                        nid;                  /*    12     4 */
        u8                         pool_idx;             /*    16     1 */

        /* XXX 7 bytes hole, try to pack */

        long unsigned int          handle;               /*    24     8 */
        struct obj_cgroup *        objcg;                /*    32     8 */
        struct list_head           lru;                  /*    40    16 */

        /* size: 56, cachelines: 1, members: 7 */
        /* sum members: 49, holes: 1, sum holes: 7 */
        /* last cacheline: 56 bytes */
};

after:
struct zswap_entry {
        swp_entry_t                swpentry;             /*     0     8 */
        struct {
                unsigned int       length:31;            /*     8: 0  4 */

                /* Bitfield combined with next fields */

                bool               referenced:1;         /*    11: 7  1 */
        };                                               /*     8     4 */
        int                        nid;                  /*    12     4 */
        long unsigned int          handle;               /*    16     8 */
        struct obj_cgroup *        objcg;                /*    24     8 */
        struct list_head           lru;                  /*    32    16 */
        u8                         pool_idx;             /*    48     1 */

        /* size: 56, cachelines: 1, members: 7 */
        /* padding: 7 */
        /* last cacheline: 56 bytes */
};

And decided to go with the placement in patch 7, since it also
separates out members by compress/decompress path accesses. pool_idx
is set once, and never changes. Further, moving pool_idx to the end
gets rid of holes.

>
> Before you patch on x86_64:
>
> struct zswap_entry {
>         swp_entry_t                swpentry;             /*     0     8 *=
/
>         unsigned int               length;               /*     8     4 *=
/
>         bool                       referenced;           /*    12     1 *=
/
>         u8                         pool_idx;             /*    13     1 *=
/
>
>         /* XXX 2 bytes hole, try to pack */
>
>         unsigned long              handle;               /*    16     8 *=
/
>         struct obj_cgroup *        objcg;                /*    24     8 *=
/
>         struct list_head           lru;                  /*    32    16 *=
/
>
>         /* size: 48, cachelines: 1, members: 7 */
>         /* sum members: 46, holes: 1, sum holes: 2 */
>         /* last cacheline: 48 bytes */
> };
>
> After:
>
> struct zswap_entry {
>         swp_entry_t                swpentry;             /*     0     8 *=
/
>         struct {
>                 unsigned int       length:31;            /*     8: 0  4 *=
/
>
>                 /* Bitfield combined with next fields */
>
>                 bool               referenced:1;         /*    11: 7  1 *=
/
>         };                                               /*     8     4 *=
/
>         struct {
>                 unsigned int               length:31;            /*     0=
: 0  4 */
>
>                 /* Bitfield combined with next fields */
>
>                 bool                       referenced:1;         /*     3=
: 7  1 */
>
>                 /* size: 4, cachelines: 1, members: 2 */
>                 /* last cacheline: 4 bytes */
>         };
>
>         int                        nid;                  /*    12     4 *=
/
>         u8                         pool_idx;             /*    16     1 *=
/
>
>         /* XXX 7 bytes hole, try to pack */
>
>         unsigned long              handle;               /*    24     8 *=
/
>         struct obj_cgroup *        objcg;                /*    32     8 *=
/
>         struct list_head           lru;                  /*    40    16 *=
/
>
>         /* size: 56, cachelines: 1, members: 7 */
>         /* sum members: 49, holes: 1, sum holes: 7 */
>         /* last cacheline: 56 bytes */
> };
>
> I think we want to reorder the fields. We can probably also avoid the
> bitfield if the maximum page size is 64K (is it?)

It seems on ARM64, the max page size is 64K, however on PPC, it can be
256K. So it appears we need at least 18 bits on currently supported
architectures.
If you agree with the pool_idx placement to be moved to the end as
proposed in patch 7, I can try and optimize this further, by limiting
the "unsigned int length:18", if you think this makes sense.

>
> struct zswap_entry {
>         swp_entry_t                swpentry;             /*     0     8 *=
/
>         u16                        length;               /*     8     2 *=
/
>         u8                         pool_idx;             /*    10     1 *=
/
>         bool                       referenced;           /*    11     1 *=
/
>         int                        nid;                  /*    12     4 *=
/
>         unsigned long              handle;               /*    16     8 *=
/
>         struct obj_cgroup *        objcg;                /*    24     8 *=
/
>         struct list_head           lru;                  /*    32    16 *=
/
>
>         /* size: 48, cachelines: 1, members: 8 */
>         /* last cacheline: 48 bytes */
> };
>
>
> >       u8 pool_idx;
> >       unsigned long handle;
> >       struct obj_cgroup *objcg;
> > @@ -672,14 +676,8 @@ static int zswap_enabled_param_set(const char *val=
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
> > @@ -696,19 +694,18 @@ static void zswap_lru_add(struct zswap_entry *ent=
ry)
> >       rcu_read_lock();
> >       memcg =3D obj_cgroup_memcg(entry->objcg);
> >       /* will always succeed */
> > -     list_lru_add(&zswap_list_lru, &entry->lru, nid, memcg);
> > +     list_lru_add(&zswap_list_lru, &entry->lru, entry->nid, memcg);
> >       rcu_read_unlock();
> >  }
> >
> >  static void zswap_lru_del(struct zswap_entry *entry)
> >  {
> > -     int nid =3D entry_to_nid(entry);
> >       struct mem_cgroup *memcg;
> >
> >       rcu_read_lock();
> >       memcg =3D obj_cgroup_memcg(entry->objcg);
> >       /* will always succeed */
> > -     list_lru_del(&zswap_list_lru, &entry->lru, nid, memcg);
> > +     list_lru_del(&zswap_list_lru, &entry->lru, entry->nid, memcg);
> >       rcu_read_unlock();
> >  }
> >
> > @@ -1449,9 +1446,10 @@ static bool zswap_store_page(struct folio *folio=
, long index,
> >  {
> >       swp_entry_t page_swpentry =3D folio_swap_entry(folio, index);
> >       struct zswap_entry *entry, *old;
> > +     int nid =3D folio_nid(folio);
> >
> >       /* allocate entry */
> > -     entry =3D zswap_entry_cache_alloc(GFP_KERNEL, folio_nid(folio));
> > +     entry =3D zswap_entry_cache_alloc(GFP_KERNEL, nid);
>
> We don't need to allocate the entry on the same node anymore, should we
> drop this and let the slab allocator handle it as it sees fit?

Was this a recent change? I see the folio_nid(folio) on my version of
mm-unstable as of 10-3-2026. Let me check, and yes, allowing the slab
allocated handle this is probably a good idea.

Along the same lines, I have been working on replacing zsmalloc with
direct SLAB allocations for the zswap compressed data storage and see
very promising results: memory savings and latency improvements. I
will submit an RFC shortly.

>
> >       if (!entry) {
> >               zswap_reject_kmemcache_fail++;
> >               return false;
> > @@ -1466,6 +1464,7 @@ static bool zswap_store_page(struct folio *folio,=
 long index,
> >        * to an unrelated live pool.
> >        */
> >       entry->pool_idx =3D pool->idx;
> > +     entry->nid =3D nid;
> >
> >       old =3D xa_store(swap_zswap_tree(page_swpentry),
> >                      swp_offset(page_swpentry),
> > --
> > 2.39.5
> >
