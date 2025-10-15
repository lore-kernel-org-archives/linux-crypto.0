Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 476741B532F
	for <linux-crypto@vger.kernel.org>; Wed, 15 Oct 2025 17:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760547878; cv=none; b=R4LcCsyy0vlVHghlI8r7GoyFjKNEUBdGbgD+KQ/oAabxOyAoZlX4aohg3ouldVTKNUGeL6oYiRKEJ1NtMGaWWyMs9VEe6xJOIvsDY3ymahBiO25XyAVEwb9RkzIhfCkJqQcst2JUjh0Mr2jod+nUvqvOXig1Yxobiu+USjtqV/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760547878; c=relaxed/simple;
	bh=B4hiJkRKURYPLNvRlZWTUuJqTzHJNZiobRsJddeEDjg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=juqor8Jes4Y66a2A89zrmq/wfpBUTD2nMdDnJ3LP3eDYy0KlUrVl8PuzKDCDW5ytyJE4dMUE7GIKLHMWrKTdsVMsj9ZRDdG5ptZwnQd53e4cucdDMvQ7hizg7BEQf+09gvWd0YKM7o2jALgiuzNl2/tk7bplhMvs68Gd0lL6Ksg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MVzgbHZ5; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MVzgbHZ5"
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-9032edd72c1so753232139f.3
        for <linux-crypto@vger.kernel.org>; Wed, 15 Oct 2025 10:04:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760547875; x=1761152675; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0PsUZ3DTLz/FEbE6bE6qcXBs0nMzCEfwi8X1s4NPS5U=;
        b=MVzgbHZ5zyjnu/yxO37IwuOGapCqyohLn7ZQI/t0S5E/I5YIxCAX7LMbiEh4rFIOzR
         es9clLi91kAoQa7cQiheYYu7TM1B27gujrt4BIat4yoLqDslc6MyN8f0mVudt3s9PgiD
         qCfwP7xGnrfyqn2aZ/QBxhlnV+pBMdBqL89LGF60BFhl0UnycLnbuxVns3KdxT3c5oLS
         1H6pMKRuzBacH3kAsdAqiOIMgLcwbxe8g5okCH+3HKk7Old9ujL1sHmKp/RjyZEOq4yV
         BMI3AkbCBYB0bQ98scFHIzwmmkq3l49E8LtdgWF8kVetNumMpCIGwLZs8WE9YpmIegdJ
         yPIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760547875; x=1761152675;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0PsUZ3DTLz/FEbE6bE6qcXBs0nMzCEfwi8X1s4NPS5U=;
        b=dT60Db7Huq1/Iv81hmX4m/lUBBjQy5yNobC5Z6fell2rSUGocTW/0DinoKP3/aMA/M
         3tQ8xKg5q3QZ4o/YHDRb5DLHXdfAMMMuJ6rF4QKNmDKAPQIzwmxut41IOVb6w7oPeDtK
         uKjPEtJ8kgKslLKehXwJPH7zmB9lSnFCxl+61CQr2lRxQFciHvlL2gTpg153LzUrCGzt
         nXGWohovlqq/Vyt+OrWYdnX+XF3mDtt02u1DdGF8AFq/LCiQeufGPusJ1ehSBIGZ0XOe
         qwvpjENf+FUFJcomRUeMcHc3QANkf91CpyZMB40gSE8GkPS+ExrrPMM0Q/zjWPoKTPal
         An/g==
X-Forwarded-Encrypted: i=1; AJvYcCXSnjnp5BMIVsQL2pueL48AZWucMUjZweIi/sN5BnF9mqhAxDcAT2qzdMRNdpqXBfqOZ1Vnx8Zkviok3+I=@vger.kernel.org
X-Gm-Message-State: AOJu0YwBakrRzD/mRGT6SgwSpweqA0lDytwgJA/H8nh4t4fyt8q5IDa1
	ljGTC2gjWLMdA4IwVDRhnE2Zl3reuog2/T6FaYtPHK/tC97HLNdo7Mlx1YlqqCn0G99Iv4uEiQF
	CU6ejRpdih9l/m60qECw90CqBYRoxyzA=
X-Gm-Gg: ASbGncvIg15azsNaQX7YAtR8fOwKiR2BbFMoc+8Gb7A6Gk8O0lapp4E4Zg+R/PQx6Ae
	JmuRnwVetOERHHMSbiOqu5ychbbMlsamRzr59sd2lcLcPfLBfNqXzTAxEkl3tgV5TzXna+2x0DW
	nHDLQ053MAzRS+RhalAygKAKPHAbEbQX+ZDOlOA6RPdF9TJ7Pqeb5FBVHPckfAurUaU4C8MKi/f
	hV0onIo/pP63U4jJrCvxIDF0vgD0WfO5jkBkO+IKkZG
X-Google-Smtp-Source: AGHT+IGrcvHIVQYOlqUaFYBFUyNOXU4ruQhVF9+HEzslzVdiNACSpnhen54dqXbCCN8AswusBpC2oObBqP/2j6eL3zU=
X-Received: by 2002:a05:6602:3c7:b0:93e:3805:4683 with SMTP id
 ca18e2360f4ac-93e38054c07mr1683662739f.1.1760547874846; Wed, 15 Oct 2025
 10:04:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
 <20250926033502.7486-23-kanchana.p.sridhar@intel.com> <2qvfjavbepw3sq2pvvcez6jsc3bxkxej27674l4ztfdza7jqaq@xi6qndkj5xhh>
 <PH7PR11MB81216AEDFD10B5BDCBCE1F19C9E6A@PH7PR11MB8121.namprd11.prod.outlook.com>
 <xnwqi5jnawvxdciqapfhhkneynsdr3dx36hmqe7jn4shm3uc3y@iyi5qqfubqey>
 <CAKEwX=NyUR6UE0PhXCaHOdta4=gVvRj7QgZtpPaLADpfXYyvZw@mail.gmail.com> <PH7PR11MB812102541D5106A6D0E21E28C9E8A@PH7PR11MB8121.namprd11.prod.outlook.com>
In-Reply-To: <PH7PR11MB812102541D5106A6D0E21E28C9E8A@PH7PR11MB8121.namprd11.prod.outlook.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 15 Oct 2025 10:04:24 -0700
X-Gm-Features: AS18NWCmhQjk7Q5ZDuFDuVGKSrttUEbTEhYpzHsGMWN3hs2nvrL8NcFRr0CqthU
Message-ID: <CAKEwX=NkaaCkoyULr4J+5-F+L5bRhM0F8JsV2DS0Mk=xYhncRw@mail.gmail.com>
Subject: Re: [PATCH v12 22/23] mm: zswap: zswap_store() will process a large
 folio in batches.
To: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>, "chengming.zhou@linux.dev" <chengming.zhou@linux.dev>, 
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>, 
	"21cnbao@gmail.com" <21cnbao@gmail.com>, 
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"senozhatsky@chromium.org" <senozhatsky@chromium.org>, "sj@kernel.org" <sj@kernel.org>, 
	"kasong@tencent.com" <kasong@tencent.com>, 
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, 
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>, "davem@davemloft.net" <davem@davemloft.net>, 
	"clabbe@baylibre.com" <clabbe@baylibre.com>, "ardb@kernel.org" <ardb@kernel.org>, 
	"ebiggers@google.com" <ebiggers@google.com>, "surenb@google.com" <surenb@google.com>, 
	"Accardi, Kristen C" <kristen.c.accardi@intel.com>, "Gomes, Vinicius" <vinicius.gomes@intel.com>, 
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh" <vinodh.gopal@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 14, 2025 at 8:42=E2=80=AFPM Sridhar, Kanchana P
<kanchana.p.sridhar@intel.com> wrote:
>
>
> > -----Original Message-----
> > From: Nhat Pham <nphamcs@gmail.com>
> > Sent: Tuesday, October 14, 2025 9:35 AM
> > To: Yosry Ahmed <yosry.ahmed@linux.dev>
> > Cc: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>; linux-
> > kernel@vger.kernel.org; linux-mm@kvack.org; hannes@cmpxchg.org;
> > chengming.zhou@linux.dev; usamaarif642@gmail.com;
> > ryan.roberts@arm.com; 21cnbao@gmail.com;
> > ying.huang@linux.alibaba.com; akpm@linux-foundation.org;
> > senozhatsky@chromium.org; sj@kernel.org; kasong@tencent.com; linux-
> > crypto@vger.kernel.org; herbert@gondor.apana.org.au;
> > davem@davemloft.net; clabbe@baylibre.com; ardb@kernel.org;
> > ebiggers@google.com; surenb@google.com; Accardi, Kristen C
> > <kristen.c.accardi@intel.com>; Gomes, Vinicius <vinicius.gomes@intel.co=
m>;
> > Feghali, Wajdi K <wajdi.k.feghali@intel.com>; Gopal, Vinodh
> > <vinodh.gopal@intel.com>
> > Subject: Re: [PATCH v12 22/23] mm: zswap: zswap_store() will process a
> > large folio in batches.
> >
> > On Tue, Oct 14, 2025 at 8:29=E2=80=AFAM Yosry Ahmed <yosry.ahmed@linux.=
dev>
> > wrote:
> > >
> > > [..]
> > > > > > @@ -158,6 +161,8 @@ struct zswap_pool {
> > > > > >   struct work_struct release_work;
> > > > > >   struct hlist_node node;
> > > > > >   char tfm_name[CRYPTO_MAX_ALG_NAME];
> > > > > > + u8 compr_batch_size;
> > > > > > + u8 store_batch_size;
> > > > >
> > > > > I don't think we need to store store_batch_size, seems trivial to
> > > > > calculate at store time (perhaps in a helper).
> > > > >
> > > > > Taking a step back, is there any benefit to limiting store_batch_=
size to
> > > > > compr_batch_size? Is there a disadvantage to using
> > > > > ZSWAP_MAX_BATCH_SIZE
> > > > > even if it's higher than the HW compression batch size?
> > > >
> > > > Thanks Yosry, for the code review comments. I had a discussion with
> > > > Barry earlier on these very same topics as follow up to his review
> > comments
> > > > for v11, starting with [1]. Can you please go through the rationale=
 for
> > > > these design choices, and let me know if you have any questions:
> > > >
> > > > [1]: https://patchwork.kernel.org/comment/26530319/
> > >
> > > I am surprised that calculating the value in zswap_store() causes a
> > > regression, but I am fine with keeping the precalculation in this cas=
e.
> > >
> > > I think there's a bigger problem here tho, more below.
> > >
> > > > > > + */
> > > > > > +static __always_inline int zswap_entries_cache_alloc_batch(voi=
d
> > > > > **entries,
> > > > > > +                                                    unsigned i=
nt
> > > > > nr_entries,
> > > > > > +                                                    gfp_t gfp)
> > > > > > +{
> > > > > > + return kmem_cache_alloc_bulk(zswap_entry_cache, gfp, nr_entri=
es,
> > > > > entries);
> > > > >
> > > > > We currently use kmem_cache_alloc_node() in
> > zswap_entry_cache_alloc() to
> > > > > allocate the entry on the same node as the compressed page. We us=
e
> > > > > entry_to_nid() to get the node for LRU operations.
> > > > >
> > > > > This breaks that assumption.
> > > >
> > > > You bring up a good point. I was looking at the code in slub.c and =
my
> > > > understanding thus far is that both, bulk allocations and
> > kmem_cache_alloc_node()
> > > > allocations are made from a per-CPU "cpu_slab" that is allocated by=
 SLUB.
> > > >
> > > > IIUC, the concern you are raising is in the mainline, the entry is =
allocated
> > on
> > > > the same node as the compressed page, and gets added to the LRU lis=
t of
> > that
> > > > node. IOW, the node to which the compressed page belongs is the one=
 to
> > whose
> > > > LRU the entry will be added.
> > > >
> > > > With this patch, with kmem_cache_alloc_bulk(), the entry will be cr=
eated
> > on
> > > > the per-CPU slab of the CPU on which zswap_store() is called and wi=
ll be
> > > > added to the LRU of that per-CPU slab's NUMA node. Hence, the end
> > result
> > > > could potentially be that the zswap_entry for a page could potentia=
lly be
> > > > on a different NUMA node/memcg than the page's NUMA node.
> >
> > I think only the NUMA node is the problem, not the memcg.
> >
> > > >
> > > > This is my thinking as to how this will impact the zswap shrinker:
> > > >
> > > > 1) memcg shrinker: if the memcg the entry ends up in is on the
> > zswap_list_lru,
> > > >     the entry will be written back.
> > > > 2) Global shrinker: will cycle through all memcg's that have pages =
in the
> > > >     zswap_list_lru, and the entry will be written back.
> > > >
> > > > Based on this, it is not clear to me if there is a problem, and wou=
ld like to
> > > > request you, Nhat and others to provide insights as well.
> > > >
> > > > Interestingly, most of the code in slub.c has unlikely(!node_match(=
slab,
> > node)).
> > > > Does this imply some higher level mm slab allocation requirements?
> > > >
> > > > I am Ok with just calling zswap_entry_cache_alloc() for "nr_pages" =
if we
> > > > think this would be more correct.
> > >
> > > I saw your other response as well, but I think one thing is not clear
> > > here. The zswap entry will get written back "eventually", sure, but
> > > that's not the problem.
> > >
> > > If the zswap entry is on the wrong node lru, two things happen:
> > > (a) When the "right" node is under memory pressure, we cannot free th=
is
> > >     entry by writing it back since it's not available in the lru.
> > > (b) When the "wrong" node is under memory pressure, it will potential=
ly
> > >     writeback entries from other nodes AND report them as being freed
> > >     from this node.
> > >
> > > Both (a) and (b) cause less effective reclaim from the zswap shrinker=
.
> > > Additionally (b) causes the shrinker to report the wrong amount of fr=
eed
> > > memory from the node. While this may not be significant today, it's v=
ery
> > > possible that more heuristics start relying on this number in the
> > > future.
> > >
> > > I don't believe we should put zswap entries on the wrong LRU, but I w=
ill
> > > defer to Nhat for the final verdict if he has a different opinion.
> >
> > Oh shoot. Yeah I missed that part.
> >
> > In the past, we sort of did not care - zswap was very poorly designed
> > for NUMA architecture in general, and most of our test setups have
> > been single-node, so these kinds of discrepancies did not show up in
> > performance numbers.
> >
> > But we are getting more multi-node systems:
> >
> > 1. Bigger hosts (memory-wise) tend to also have more than one nodes.
> > It scales better that way (especially because a lot of structures and
> > locks protecting them are node-partitioned).
> >
> > 2. We have also seen different memory media that are often expressed
> > to the kernel as nodes: CXL, GPU memory, etc.
> >
> > This will necessitate tightening memory placement. We recently had to
> > fix one such issue:
> >
> > https://github.com/torvalds/linux/commit/56e5a103a721d0ef139bba7ff3d3a
> > da6c8217d5b
> >
> > So I'm a bit nervous about this change, which will make us use the wron=
g
> > LRU...
> >
> > Some work around:
> >
> > 1. Can we squeeze an extra int field anywhere in struct zswap_entry?
> >
> > 2. Can we pump nid all the way to zswap_lru_add()?
> >
> > This is still not 100% ideal - the metadata (struct zswap_entry) will
> > still be allocated on the wrong node. But at least the data are
> > properly managed, i.e on the right LRU.
>
> Thanks, Nhat and Yosry for the discussion. Thank you Nhat, for the
> zsmalloc change log reference and for the work arounds!
>
> Following your suggestion in (2), can we pass in the folio's nid from
> zswap_store_pages() to zswap_lru_add(), as follows:
>
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 263bc6d7f5c6..44665deece80 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -694,9 +694,9 @@ static inline int entry_to_nid(struct zswap_entry *en=
try)
>         return page_to_nid(virt_to_page(entry));
>  }
>
> -static void zswap_lru_add(struct list_lru *list_lru, struct zswap_entry =
*entry)
> +static void zswap_lru_add(struct list_lru *list_lru, struct zswap_entry =
*entry,
> +                         int nid)
>  {
> -       int nid =3D entry_to_nid(entry);
>         struct mem_cgroup *memcg;
>
>         /*
> @@ -1758,7 +1758,7 @@ static bool zswap_store_pages(struct folio *folio,
>                  *    an incoherent entry.
>                  */
>                 if (likely(entry->length))
> -                       zswap_lru_add(&zswap_list_lru, entry);
> +                       zswap_lru_add(&zswap_list_lru, entry, nid);
>         }
>
>         return true;
> --
>
> I believe this will add the entry to the LRU node of the folio being
> compressed. If so, we may be able to avoid adding an int field to
> struct zswap_entry?

Hmm that might not work for zswap_lru_del() :(

zswap_entry_free() might be called in context where we do not have
access to the node information (zswap_load()) for e.g.

Another alternative: can we instead determine the node from the
compressed object's storage? i.e store zswap_entry in the LRU
corresponding to the node that holds the compressed data?

You'll probably need the new zsmalloc API to get the node information.
And can zsmalloc migrate a backing page to a different node? This
seems complicated...

Taking a step back though, do we have to use the bulk allocation API
here? Calling the single-allocation version 512 times for a PMD-sized
page is no worse than the status quo, correct? We can leave this part
unoptimized for now - in the future, if the use case justifies it, we
can talk to slab allocator maintainers and ask for guidance on a
lock-optimized cross-node bulk allocation API.
