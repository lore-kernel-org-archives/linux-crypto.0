Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E9B44E77FF
	for <linux-crypto@vger.kernel.org>; Thu, 15 Oct 2026 21:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792099840; cv=pass; b=BTg0YI3jmOMBvIsXk0XTVq7jGhJfAKUuQfu8MuphnCLRYImamMu3aAQLzvA+KESWnoK6iVULHf1oIY3j/MPlRTDCmxcBIie0EYaloOUnHQqsRnfUBO12yRgViDw56fMhVu22j2pdSkM6oV6WxZEOnY19YBtRju8L5a4c7q8ThQs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792099840; c=relaxed/simple;
	bh=zJc1yHXSI8gYM/pd1YaPYoLdJGSzI/gziAdRlyZmKSs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Atbrv2cwb/BtNChAkJ9oBbs+YC4lLOnIYqbKzX58O5W92O1H+a+BOhIJXE6kkQpqHd9q9dGsQrQ6Htf+00hRW6g/3pKlUPLiXTiOoRaHzV7zqQIwQRuOmP/53NO/nple5RQhtx5YjVTi339+tf+NHRd9r0GKhg9grAMSpaxl/RE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cBmehTSX; arc=pass smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cBmehTSX"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5b2b92065ffso2801329e87.1
        for <linux-crypto@vger.kernel.org>; Thu, 15 Oct 2026 14:30:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792099837; cv=none;
        d=google.com; s=arc-20260327;
        b=YezrfvJtRmZe/QEQA+y38zQiYmLMS9n7LQKz/QR8z9MgST/r6wF9ONyroSqaAsXjiS
         hxGqJT4j3/DI0oxb1yEAioAtTr2U5AS8eAKpPWwK3m/miA+8uSeYjChgQmjvpb39nX/I
         8fn2SYR0uCk91FoLAwNFWneyAzK+tJvJbDhCkBfN150XSZXiv0nqz7cJwZw5oAK7cQ+2
         CBHyXfqxUbfGwu1CfklWvG2CDTwma3bDSgMrYj3StU5RETxP1y2QjFT4Yt80pLqtsZhv
         LXFSD906BD8FHyDoQL0+zfBuFMb1FbnkLnNxF5W8PrvXzR6zD6Du96qUzlCk6cvElXNC
         shpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6QOUwpYyaURolaGh43C2DQXMGVfTGXyyd22jdUdTcOM=;
        fh=IMXjPzbnxlgwRGk8pLnwoSaVhtT4IiwaaLgYUKPWarc=;
        b=HD3vJkSXn8AnmSsvYaHCI5+7vdGYhI9VYaldyiI5/VBuUlhRrDOAvWtK+NLgKjpdIh
         RYcFbZnJN1gMZwQg1lzDhB5+KwvAbdTsNxRGRJZyjY2bAcDZkRCk1gHjxXKvbY6w73IU
         85R+QL2jxkba8V1OtXxrfQsHdQWXlC/D8NJ//1mJgrmop4UzU+XWptXWe2tUJL1GtXc7
         odLaRfyoCoZHaqqp3jNCDezBIGhCCSNiiLJwtNPBiXUht1g4NbLqdncjS9pDDwX/lD4/
         DSfXqYoHTOj4b6JBpWqVECo8JdsXBA4M+Gu2X8SwPp/9OdMhECo7fwU4Wf6/3lJeSns4
         /X/Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792099837; x=1792704637; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6QOUwpYyaURolaGh43C2DQXMGVfTGXyyd22jdUdTcOM=;
        b=cBmehTSXLOd5n8yK6AlJTXRGgTPtM89TfjIdUDj0psnsGOuSkNu2yXDajVdeBuWx/w
         R3I0NK5aH2+hEw30PWNGn7sUY1eyaLYp8BMoKXwvbTWbko6kbyX623HBQ2PIxyayC4ZD
         wnrsUjKDWTCP8VZBfGIOYkydwmHqs/L4X7yJM83tpiqEo53RqhE1qe9IbM75R4OnCA9v
         fcFmyOijcEvVeAXNlti1c1fkrez+Jn6816mjqRDVDPqILnUJmg+1ABj46MO3KqkKWfoo
         ctLCDVMLssuqZQPfkUs2aLvcpK0Oiy8iDcuq5Lv4j6k1hDDZNNUkJoJPoZM0XR0a93Yu
         ahyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792099837; x=1792704637;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6QOUwpYyaURolaGh43C2DQXMGVfTGXyyd22jdUdTcOM=;
        b=aw5Yy9a4Bt11herWlelsgD3CUTk4r2NOdO+3bAGvuCAqymgKMflBCPPuTZtLIAOFif
         rUM7mmGaUsC/pSnrxiGavP6FDqQfGt7+NM7KbcJh/OFbe8FYoTjh5OF9LhjCpyR55urj
         Y79aU8GxbSasDYUR4kmO1PvhkZPTIRENglxo0BwwcJCbX+c0Ht+w76IeSqlcA3dzGTP2
         7SI61N8mSmfXuBlWC+vLDSIPGBvgaEXG5hNorNgq9VkEZ5mGG4N2ngOJcwyEotMTZAYY
         GUE4ar40xbJm5o1jR61EgdnjiKhJNNo8K4Igovf98OVYK6l7vdhIhgDLZsq15Xsjz++M
         5tew==
X-Forwarded-Encrypted: i=1; AKwUvBxW+woZTLLi/R/lx4zVxWcBFMXEZadTJ+wVIbZNNicU9+gEah/FOXAnfqgxQ+tXUp9VjNzuZqnxNiKcCCQ=@vger.kernel.org
X-Gm-Message-State: AFq9FYJhbEfN3JxOPsD0/kgE9AuOjXJYPxGqX9X/3REphXCMMn5iXpPy
	FNXx2rSzoo1vrngP8IPckWIcXf0gR675oDrhWFpmzJmZd2rjsL8hbOq/av+4E/oChVAUkfYNea1
	klX/rmu8g7r+LZJKfrxox7Gj45dpXqI0=
X-Gm-Gg: AYBFou1pVry5c4nvYYd93hHN8Q9Qb3Cr68hVxr9jf5JL51v4yWcP4is5CBAQg01y6X7
	3q/Uwd/mVnLzivdj3AkrcINJOVVLzsuPoLaDpeWDShDQz0Y05fHk9IWFIl0JIv6jP9TskHUrGdN
	SbniyQATe1yrSB76pVIzbWok3tJLq/4KyN1vmwdh363JPn1g5wFKMnViSf7GuOD/OyNjMcO0fBJ
	TXulLMMM49MaaXxJnrUySc4Erj2nZiKoz6cOyWvFMWiH/Dhhtx2iRPhZ98qsUkkzcNdLY8zd5fZ
	GvUU3SZgkXkCIDDvDja9g22OSf7A3U2oNnJkn/DNf62hFPSTo6O3usc+e9J8GCX5fNhtxtCctWT
	Q8TAonK5Unn6jFx1v46a2zht3Sqr3EKfcPgFa
X-Received: by 2002:a05:6512:1151:b0:5be:41a1:d2ae with SMTP id
 2adb3069b0e04-5be41a1d3ebmr1107279e87.15.1792099836702; Thu, 15 Oct 2026
 14:30:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
 <20261008182814.27450-6-kanchanapsridhar2026@gmail.com> <as7JC8o2kggiq_ss@google.com>
 <CACpmpofXMGBP70Rn7jHLwOF38GRKMUGoW3rb1Jp2SPH7ygKcfw@mail.gmail.com> <CAO9r8zOEcGmg8eVttu41htugnng0ahnVQbubiJfxVH+GfDe47Q@mail.gmail.com>
In-Reply-To: <CAO9r8zOEcGmg8eVttu41htugnng0ahnVQbubiJfxVH+GfDe47Q@mail.gmail.com>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Thu, 15 Oct 2026 14:30:22 -0700
X-Gm-Features: AclHuK_VkvA5Ou--PjXINBAVxrFNqnCfphylRWwthtObaGmikBDgzUqpBnjQop4
Message-ID: <CACpmpodDA=oqnVa_hsJpyhGt=4zxknYF=QX9L6-sJbxsRxtM2w@mail.gmail.com>
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

On Wed, Oct 14, 2026 at 8:17=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> On Tue, Oct 13, 2026 at 6:17=E2=80=AFPM Kanchana P. Sridhar
> <kanchanapsridhar2026@gmail.com> wrote:
> >
> > On Tue, Oct 13, 2026 at 5:18=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> =
wrote:
> > >
> > > On Thu, Oct 08, 2026 at 11:28:11AM -0700, Kanchana P. Sridhar wrote:
> > > > When storing a folio in zswap, save the folio's node id in the zswa=
p
> > > > entry instead of relying on the zswap_entry being allocated on the =
same
> > > > node. This enables optimizations such as batch allocation of zswap
> > > > entries for large folios using kmem_cache_alloc_bulk() that does no=
t
> > > > support specifying a node id.
> > > >
> > > > The size of the zswap_entry remains unchanged as 'referenced' is lu=
mped
> > > > in with the 'length' (as it doesn't need a full unsigned int anyway=
).
> > > >
> > > > Suggested-by: Nhat Pham <nphamcs@gmail.com>
> > > > Suggested-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > > > Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> > > > Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
> > > > ---
> > > >  mm/zswap.c | 23 +++++++++++------------
> > > >  1 file changed, 11 insertions(+), 12 deletions(-)
> > > >
> > > > diff --git a/mm/zswap.c b/mm/zswap.c
> > > > index ca513a9f89e3..c2731d3acb2c 100644
> > > > --- a/mm/zswap.c
> > > > +++ b/mm/zswap.c
> > > > @@ -194,6 +194,7 @@ static struct shrinker *zswap_shrinker;
> > > >   *              writeback logic. The entry is only reclaimed by th=
e writeback
> > > >   *              logic if referenced is unset. See comments in the =
shrinker
> > > >   *              section for context.
> > > > + * nid - NUMA node id of the page for which this is the zswap entr=
y.
> > > >   * pool_idx - id of the zswap_pool that the entry's data is in.
> > > >   * handle - zsmalloc allocation handle that stores the compressed =
page data
> > > >   * objcg - the obj_cgroup that the compressed memory is charged to
> > > > @@ -201,8 +202,11 @@ static struct shrinker *zswap_shrinker;
> > > >   */
> > > >  struct zswap_entry {
> > > >       swp_entry_t swpentry;
> > > > -     unsigned int length;
> > > > -     bool referenced;
> > > > +     struct {
> > > > +             unsigned int length:31;
> > > > +             bool referenced:1;
> > > > +     };
> > > > +     int nid;
> > >
> > > This will increase the size of the struct now with pool_idx, right?
> >
> > I was gathering the struct size with the struct {unsigned int
> > length:31; bool referenced:1} as suggested in v14, for my before/after
> > comparisons:
> >
> > before:
> > struct zswap_entry {
> >         swp_entry_t                swpentry;             /*     0     8=
 */
> >         struct {
> >                 unsigned int       length:31;            /*     8: 0  4=
 */
> >
> >                 /* Bitfield combined with next fields */
> >
> >                 bool               referenced:1;         /*    11: 7  1=
 */
> >         };                                               /*     8     4=
 */
> >         int                        nid;                  /*    12     4=
 */
> >         u8                         pool_idx;             /*    16     1=
 */
> >
> >         /* XXX 7 bytes hole, try to pack */
> >
> >         long unsigned int          handle;               /*    24     8=
 */
> >         struct obj_cgroup *        objcg;                /*    32     8=
 */
> >         struct list_head           lru;                  /*    40    16=
 */
> >
> >         /* size: 56, cachelines: 1, members: 7 */
> >         /* sum members: 49, holes: 1, sum holes: 7 */
> >         /* last cacheline: 56 bytes */
> > };
> >
> > after:
> > struct zswap_entry {
> >         swp_entry_t                swpentry;             /*     0     8=
 */
> >         struct {
> >                 unsigned int       length:31;            /*     8: 0  4=
 */
> >
> >                 /* Bitfield combined with next fields */
> >
> >                 bool               referenced:1;         /*    11: 7  1=
 */
> >         };                                               /*     8     4=
 */
> >         int                        nid;                  /*    12     4=
 */
> >         long unsigned int          handle;               /*    16     8=
 */
> >         struct obj_cgroup *        objcg;                /*    24     8=
 */
> >         struct list_head           lru;                  /*    32    16=
 */
> >         u8                         pool_idx;             /*    48     1=
 */
> >
> >         /* size: 56, cachelines: 1, members: 7 */
> >         /* padding: 7 */
> >         /* last cacheline: 56 bytes */
> > };
> >
> > And decided to go with the placement in patch 7, since it also
> > separates out members by compress/decompress path accesses. pool_idx
> > is set once, and never changes. Further, moving pool_idx to the end
> > gets rid of holes.
>
> Please look at the layout I pasted (quoted below). Your patch
> increases the struct size from 48 bytes to 56 bytes, undoing the
> optimization introduced by pool_idx. We need to pack length, pool_idx,
> and referenced in a single u32 to keep the size constant.

Thanks for the suggestion. I have modified the layout such that the
size remains unchanged at 48 bytes. The "u8 pool_idx" requires byte
alignment, so I moved the 1-bit "referenced" field to be before this:

#define ZSWAP_MAX_COMPR_LENGTH_SHIFT 18U
struct zswap_entry {
  swp_entry_t swpentry;
  struct {
    unsigned int length:ZSWAP_MAX_COMPR_LENGTH_SHIFT;
    bool referenced:1U;
    u8 pool_idx;
  };
  int nid;
  unsigned long handle;
  struct obj_cgroup *objcg;
  struct list_head lru;
};

struct zswap_entry {
        swp_entry_t                swpentry;             /*     0     8 */
        struct {
                unsigned int       length:18;            /*     8: 0  4 */

                /* Bitfield combined with next fields */

                bool               referenced:1;         /*    10: 2  1 */

                /* XXX 5 bits hole, try to pack */

                u8                 pool_idx;             /*    11     1 */
        };                                               /*     8     4 */
        int                        nid;                  /*    12     4 */
        long unsigned int          handle;               /*    16     8 */
        struct obj_cgroup *        objcg;                /*    24     8 */
        struct list_head           lru;                  /*    32    16 */

        /* size: 48, cachelines: 1, members: 6 */
        /* last cacheline: 48 bytes */
};

The macro is required to add a build time assertion in zswap_setup():

 BUILD_BUG_ON(ZSWAP_MAX_COMPR_LENGTH_SHIFT < PAGE_SHIFT);

>
> FWIW, moving pool_idx to the end just trades holes for padding, I am
> not sure if that's necessarily an improvement.
>
> >
> > >
> > > Before you patch on x86_64:
> > >
> > > struct zswap_entry {
> > >         swp_entry_t                swpentry;             /*     0    =
 8 */
> > >         unsigned int               length;               /*     8    =
 4 */
> > >         bool                       referenced;           /*    12    =
 1 */
> > >         u8                         pool_idx;             /*    13    =
 1 */
> > >
> > >         /* XXX 2 bytes hole, try to pack */
> > >
> > >         unsigned long              handle;               /*    16    =
 8 */
> > >         struct obj_cgroup *        objcg;                /*    24    =
 8 */
> > >         struct list_head           lru;                  /*    32    =
16 */
> > >
> > >         /* size: 48, cachelines: 1, members: 7 */
> > >         /* sum members: 46, holes: 1, sum holes: 2 */
> > >         /* last cacheline: 48 bytes */
> > > };
> > >
> > > After:
> > >
> > > struct zswap_entry {
> > >         swp_entry_t                swpentry;             /*     0    =
 8 */
> > >         struct {
> > >                 unsigned int       length:31;            /*     8: 0 =
 4 */
> > >
> > >                 /* Bitfield combined with next fields */
> > >
> > >                 bool               referenced:1;         /*    11: 7 =
 1 */
> > >         };                                               /*     8    =
 4 */
> > >         struct {
> > >                 unsigned int               length:31;            /*  =
   0: 0  4 */
> > >
> > >                 /* Bitfield combined with next fields */
> > >
> > >                 bool                       referenced:1;         /*  =
   3: 7  1 */
> > >
> > >                 /* size: 4, cachelines: 1, members: 2 */
> > >                 /* last cacheline: 4 bytes */
> > >         };
> > >
> > >         int                        nid;                  /*    12    =
 4 */
> > >         u8                         pool_idx;             /*    16    =
 1 */
> > >
> > >         /* XXX 7 bytes hole, try to pack */
> > >
> > >         unsigned long              handle;               /*    24    =
 8 */
> > >         struct obj_cgroup *        objcg;                /*    32    =
 8 */
> > >         struct list_head           lru;                  /*    40    =
16 */
> > >
> > >         /* size: 56, cachelines: 1, members: 7 */
> > >         /* sum members: 49, holes: 1, sum holes: 7 */
> > >         /* last cacheline: 56 bytes */
> > > };
> > >
> > > I think we want to reorder the fields. We can probably also avoid the
> > > bitfield if the maximum page size is 64K (is it?)
> >
> > It seems on ARM64, the max page size is 64K, however on PPC, it can be
> > 256K. So it appears we need at least 18 bits on currently supported
> > architectures.
>
> In this case unfortunately we need to stick with bitfields. We should
> probably add a build-time assertion that the width of length is enough
> to cover PAGE_SIZE.
>
> > If you agree with the pool_idx placement to be moved to the end as
> > proposed in patch 7, I can try and optimize this further, by limiting
> > the "unsigned int length:18", if you think this makes sense.
>
> I don't think we can put pool_idx to the end and keep the struct size
> constant. For length, yeah let's use the minimum number of bits needed
> and add an assertion, so that the free to use bits are obvious.

This is all taken care of in my latest version.

>
> >
> > >
> > > struct zswap_entry {
> > >         swp_entry_t                swpentry;             /*     0    =
 8 */
> > >         u16                        length;               /*     8    =
 2 */
> > >         u8                         pool_idx;             /*    10    =
 1 */
> > >         bool                       referenced;           /*    11    =
 1 */
> > >         int                        nid;                  /*    12    =
 4 */
> > >         unsigned long              handle;               /*    16    =
 8 */
> > >         struct obj_cgroup *        objcg;                /*    24    =
 8 */
> > >         struct list_head           lru;                  /*    32    =
16 */
> > >
> > >         /* size: 48, cachelines: 1, members: 8 */
> > >         /* last cacheline: 48 bytes */
> > > };
> > >
> > >
> > > >       u8 pool_idx;
> > > >       unsigned long handle;
> > > >       struct obj_cgroup *objcg;
> > > > @@ -672,14 +676,8 @@ static int zswap_enabled_param_set(const char =
*val,
> > > >  * lru functions
> > > >  **********************************/
> > > >
> > > > -static inline int entry_to_nid(struct zswap_entry *entry)
> > > > -{
> > > > -     return page_to_nid(virt_to_page(entry));
> > > > -}
> > > > -
> > > >  static void zswap_lru_add(struct zswap_entry *entry)
> > > >  {
> > > > -     int nid =3D entry_to_nid(entry);
> > > >       struct mem_cgroup *memcg;
> > > >
> > > >       /*
> > > > @@ -696,19 +694,18 @@ static void zswap_lru_add(struct zswap_entry =
*entry)
> > > >       rcu_read_lock();
> > > >       memcg =3D obj_cgroup_memcg(entry->objcg);
> > > >       /* will always succeed */
> > > > -     list_lru_add(&zswap_list_lru, &entry->lru, nid, memcg);
> > > > +     list_lru_add(&zswap_list_lru, &entry->lru, entry->nid, memcg)=
;
> > > >       rcu_read_unlock();
> > > >  }
> > > >
> > > >  static void zswap_lru_del(struct zswap_entry *entry)
> > > >  {
> > > > -     int nid =3D entry_to_nid(entry);
> > > >       struct mem_cgroup *memcg;
> > > >
> > > >       rcu_read_lock();
> > > >       memcg =3D obj_cgroup_memcg(entry->objcg);
> > > >       /* will always succeed */
> > > > -     list_lru_del(&zswap_list_lru, &entry->lru, nid, memcg);
> > > > +     list_lru_del(&zswap_list_lru, &entry->lru, entry->nid, memcg)=
;
> > > >       rcu_read_unlock();
> > > >  }
> > > >
> > > > @@ -1449,9 +1446,10 @@ static bool zswap_store_page(struct folio *f=
olio, long index,
> > > >  {
> > > >       swp_entry_t page_swpentry =3D folio_swap_entry(folio, index);
> > > >       struct zswap_entry *entry, *old;
> > > > +     int nid =3D folio_nid(folio);
> > > >
> > > >       /* allocate entry */
> > > > -     entry =3D zswap_entry_cache_alloc(GFP_KERNEL, folio_nid(folio=
));
> > > > +     entry =3D zswap_entry_cache_alloc(GFP_KERNEL, nid);
> > >
> > > We don't need to allocate the entry on the same node anymore, should =
we
> > > drop this and let the slab allocator handle it as it sees fit?
> >
> > Was this a recent change? I see the folio_nid(folio) on my version of
> > mm-unstable as of 10-3-2026. Let me check, and yes, allowing the slab
> > allocated handle this is probably a good idea.
>
> We allocate the entry on the same node to avoid having to store nid in
> the zswap entry (see entry_to_nid()). If we store it, then there's no
> need to allocate on the node.

With patch 0006, we try to bulk allocate all entries for the batch.
Only if this fails, we call zswap_entry_cache_alloc(gfp, nid). So
patch 0006 addresses this already, and the nid is used on in the
fallback case.

>
> >
> > Along the same lines, I have been working on replacing zsmalloc with
> > direct SLAB allocations for the zswap compressed data storage and see
> > very promising results: memory savings and latency improvements. I
> > will submit an RFC shortly.
>
> Keep in mind that zsmalloc is movable memory, while slab memory isn't.
> Zsmalloc may also be less likely to make a new allocation in the store
> path. There are other considerations beyond memory overhead and
> latency here.

I realize this means we trade off page migration for writeback for the
pages representing zswap compressed data. This might not necessarily
be a bad thing for 2 main reasons, the way I see it in this specific
context:

1) Page migration would only be transferring a memory pressure problem
elsewhere. Not sure how well this would work with memcgs or
containers. At some point someone would need to do writeback.
2) I don't believe there is a zswap specific page migration flow in
the kernel other than zsmalloc compaction. IOW, memory tiering
components like CXL are handled directly in the reclaim path. From
what I understand, things wouldn't break with slab memory for zswap
compressed storage, but I could be wrong. I hope to include the
architecture level considerations/trade-offs in the RFC.

>
> >
> > >
> > > >       if (!entry) {
> > > >               zswap_reject_kmemcache_fail++;
> > > >               return false;
> > > > @@ -1466,6 +1464,7 @@ static bool zswap_store_page(struct folio *fo=
lio, long index,
> > > >        * to an unrelated live pool.
> > > >        */
> > > >       entry->pool_idx =3D pool->idx;
> > > > +     entry->nid =3D nid;
> > > >
> > > >       old =3D xa_store(swap_zswap_tree(page_swpentry),
> > > >                      swp_offset(page_swpentry),
> > > > --
> > > > 2.39.5
> > > >
