Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5754C39794B
	for <linux-crypto@vger.kernel.org>; Thu, 15 Oct 2026 22:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792104322; cv=pass; b=AoV8QQlfTYjoy6qskTgiqU2SwHBQMRFWgvgMCxERIwl10hSG1cce89mMb+L2apSn0OpLgWy73h3LdJ0TyGF4UPdZO5eao+sVSzGqKrEH4Mj6vMeIEgX821+HM+dF8bOOJh/t+HxtanrIcOePbx0ZyE1w+BI4OpYRnF2ZHVVu9TY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792104322; c=relaxed/simple;
	bh=pde/atokYGlXVQMXPE555qjnd8HsZsyowtY+/7fM9dI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pdAB5ORbFdTEICO8nVmNXEQsl79VPbZBBY9VQSBQ+Clwa9DQeVYzrn/4NqhmjDBokiz0WepP7G1/qfzBP4r4M8plXmTwV5uBmtTGEZD18RpWE57j9wABs2vVMLGFJ8sdyAa1SD3WPWFYgRVY7Cnb/cnOrE7X+LsGIG5ID2nPbWA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Xc93N2Pa; arc=pass smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xc93N2Pa"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5ba3adf78f5so1832165e87.3
        for <linux-crypto@vger.kernel.org>; Thu, 15 Oct 2026 15:45:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792104319; cv=none;
        d=google.com; s=arc-20260327;
        b=E6QeigoOWqL8rTl/rCI1WA0qMIjxsCxZDA16hiAUdOtKQ5wQiOJwPYROJMwky0ECSI
         FYXxQvxsethQxVfFvFdwtCVB/H8DXsnLY1mSd+aRLEC1MLBSnAPGrF/nxg3Mag4M0OTM
         a6iagS9z0fKbbRZeupW4ZoWzkbemkiHiAyUkvWEf08M6p67fd02TaEFxDEzi8/uLH3h5
         6ivbVsIaslqemf7XFbhzLjY34oHutveg130GOINXxj0X2WdC86AU0u5SZ+SKTVpMe16d
         xoCxaAr9x0DMK4PK8sG6TjBkZvp8fFoxGdoJbF1+V3AdUz0esR18SO90bTpG8THtGgq/
         i1dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cDTDKMrdQwRgjoWMeyrkyF6DIGr4iKPuJqKn3z4+wB8=;
        fh=k3l52tU73lSTDvVV/9F0xl9pbi/3qLn9FMcnflHv6tk=;
        b=UPzwNxCSyyVEcNnVtDbidGYG9yV6iBy/vHuNm8V+CbcZCvuLSEkABIU3A13VYlxjC1
         ZubKPRSSD4TlTeqcXBY0FAAvyO7sdBGgUvAIjo7bcvIzc8bNVM6jWXAlehA6rDl3muqk
         aGZZ3pv9U9aRfcbmx0kKpysEgmAGKHg0Ne1ZCjkdZR8SIuNR+q6hoK0ytXt1DMzfSKYW
         xvDRS3mQQUdCtHxaC9sLCSpqsa+76FH6wq2IxiDnvpkUdGnKvE1Gsq62tSSx6Q5mjcnJ
         gqPmj8Z2JiSLZnmfthGijBRxHRuPjdrFuvOznLkz+iuaa5+wInbAM2VRrbVshzBZZMJc
         Miug==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792104319; x=1792709119; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cDTDKMrdQwRgjoWMeyrkyF6DIGr4iKPuJqKn3z4+wB8=;
        b=Xc93N2Paw2r4qyCyhqXFb+KKF8+qI3hlJiOc/ZByj4jMu1HK5sBmNO0AlVSSSqqGlS
         k70ZRbVF6E+0MIsYqkQIaG5zj83j35rm1Dtxs4EAcPFanrijdgaN47i+U1wraVr6pElf
         LlNt9y53wGugS4sSUCG/7GLRCSDmSX2flQrA6wfQdFRvuNklbBASCuCHCr3YCCmXiXP7
         vXc/XT7TX9XbokyCUiYoh5psQ8udGnaTaMiMI+NGprSgxCiK+5agL5E6GcDU14g2nqkI
         QQA9rh0+YpKlXTE8ZhDWVrHXODet4L5v0J/NR4/TcHWzsegsZSNLzaz2wq4w5E7cru8n
         +INQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792104319; x=1792709119;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cDTDKMrdQwRgjoWMeyrkyF6DIGr4iKPuJqKn3z4+wB8=;
        b=MhzUQXXa8zcLB4HOUEDKW6hkqIv4MUiBgShzC561PV5KwbCeQgj7rGX6mE0ZzgL3/Q
         WBWEIxkxqZ8jXR/OjK3aiCVZ7dFRDLXUOAX1Kn+KAKATvJjdHqRvZMbZXDNbGan8uf5S
         M4Afkmc5tWPTMZDzAbe8nGHOXeIk3q3zDd49fw+JjmoxIHKOp0TLUL0AGAatvJ3VKuVR
         KeITHbyQdmiJ6zSXrVdF7UCJZlhHwbJzRp1EGgcyEaidjdFzv3dxwaM+D5vmtxFlgTLz
         j8trzJEfRxpld4vzEqPkJ1Gix3JNfuqbWk2/mGDcqVJY61kcqJ+cn/Q5ToMnZnwzT3PA
         czaQ==
X-Forwarded-Encrypted: i=1; AKwUvBwbnaDOn9PZCZ1DLg1YbGNisBS4P+TInykKgm4cpV2rKQui4c0fbCAqERIzb5QnG6wP9YdDDIsf3Mi48zg=@vger.kernel.org
X-Gm-Message-State: AFq9FYKWp34rc48sz19pYl0Yz3MWEHTLbrxxQrAe9zP+vocGQ3OYr04X
	VeWKHyhm8jlUpKfPW1skOQMVVHOZCMvpiYfr6xa+bDW4YSRHsx/RcnzB0cp10sJWdKgUdDMUXXK
	ak2aOCT20vSqHD5xRu6FO0GqR0FWMUDs=
X-Gm-Gg: AYBFou2YxieAN5WrUmN5zncvcGJeiC1o0JzSojDO5dkRjlwbQ69vwoOPgMD76QrvlzX
	OdOyHaMUeeWdys/Crq9ZeVkU7TDcWk+W0Ze/A9qCRChmkVg7wkZET/pbQNtvqGUvdNkKvoJwd0/
	M8ryUz7hjBmnRWXIyLVwfS3Pw9t9ehUVwbcnU9HifUz/YGDkppifjoD/w9hJRoX5PEeBTDe4xK3
	ROni5czkO0LstCIAcrC/FDOUq016fjbP9nyyTiSZSOBKBnZH7XtzPPOnNsjz6zT67VzvIs1iY+B
	uVseFI0vP6Ni9rJe5N7DO6+LGEVNjLBurOxG/oiOGE2JrjiOwjb3GlA=
X-Received: by 2002:a05:6512:3f24:b0:5b8:f533:d439 with SMTP id
 2adb3069b0e04-5bcde8c1acdmr7282009e87.38.1792104319215; Thu, 15 Oct 2026
 15:45:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
 <20261008182814.27450-6-kanchanapsridhar2026@gmail.com> <as7JC8o2kggiq_ss@google.com>
 <CACpmpofXMGBP70Rn7jHLwOF38GRKMUGoW3rb1Jp2SPH7ygKcfw@mail.gmail.com>
 <CAO9r8zOEcGmg8eVttu41htugnng0ahnVQbubiJfxVH+GfDe47Q@mail.gmail.com>
 <CACpmpodDA=oqnVa_hsJpyhGt=4zxknYF=QX9L6-sJbxsRxtM2w@mail.gmail.com> <CAO9r8zNN6F01icKUFr8q_AgJvhxGw0MkGezKbBuKzFQV0NaAdg@mail.gmail.com>
In-Reply-To: <CAO9r8zNN6F01icKUFr8q_AgJvhxGw0MkGezKbBuKzFQV0NaAdg@mail.gmail.com>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Thu, 15 Oct 2026 15:45:06 -0700
X-Gm-Features: AclHuK8NXYRqg5T9PQ2fZ89a7chOTLHtC37Sjh9lMWynljXBN8yHgyQfD3XnlOE
Message-ID: <CACpmpocCJWkA+zvZ9ivNCt8xSZWfViKQ2ZeYN+f1EmdVTewzRQ@mail.gmail.com>
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

On Thu, Oct 15, 2026 at 2:39=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> > > > > > @@ -1449,9 +1446,10 @@ static bool zswap_store_page(struct foli=
o *folio, long index,
> > > > > >  {
> > > > > >       swp_entry_t page_swpentry =3D folio_swap_entry(folio, ind=
ex);
> > > > > >       struct zswap_entry *entry, *old;
> > > > > > +     int nid =3D folio_nid(folio);
> > > > > >
> > > > > >       /* allocate entry */
> > > > > > -     entry =3D zswap_entry_cache_alloc(GFP_KERNEL, folio_nid(f=
olio));
> > > > > > +     entry =3D zswap_entry_cache_alloc(GFP_KERNEL, nid);
> > > > >
> > > > > We don't need to allocate the entry on the same node anymore, sho=
uld we
> > > > > drop this and let the slab allocator handle it as it sees fit?
> > > >
> > > > Was this a recent change? I see the folio_nid(folio) on my version =
of
> > > > mm-unstable as of 10-3-2026. Let me check, and yes, allowing the sl=
ab
> > > > allocated handle this is probably a good idea.
> > >
> > > We allocate the entry on the same node to avoid having to store nid i=
n
> > > the zswap entry (see entry_to_nid()). If we store it, then there's no
> > > need to allocate on the node.
> >
> > With patch 0006, we try to bulk allocate all entries for the batch.
> > Only if this fails, we call zswap_entry_cache_alloc(gfp, nid). So
> > patch 0006 addresses this already, and the nid is used on in the
> > fallback case.
>
> If we are storing the nid in the zswap entry, there is no need for
> zswap_entry_cache_alloc() to use the nid anymore.

As of now, zswap_entry_cache_alloc() uses the nid for
kmem_cache_alloc_node(). Is the suggestion to change this to be
kmem_cache_alloc()?

>
> >
> > >
> > > >
> > > > Along the same lines, I have been working on replacing zsmalloc wit=
h
> > > > direct SLAB allocations for the zswap compressed data storage and s=
ee
> > > > very promising results: memory savings and latency improvements. I
> > > > will submit an RFC shortly.
> > >
> > > Keep in mind that zsmalloc is movable memory, while slab memory isn't=
.
> > > Zsmalloc may also be less likely to make a new allocation in the stor=
e
> > > path. There are other considerations beyond memory overhead and
> > > latency here.
> >
> > I realize this means we trade off page migration for writeback for the
> > pages representing zswap compressed data. This might not necessarily
> > be a bad thing for 2 main reasons, the way I see it in this specific
> > context:
> >
> > 1) Page migration would only be transferring a memory pressure problem
> > elsewhere. Not sure how well this would work with memcgs or
> > containers. At some point someone would need to do writeback.
> > 2) I don't believe there is a zswap specific page migration flow in
> > the kernel other than zsmalloc compaction. IOW, memory tiering
> > components like CXL are handled directly in the reclaim path. From
> > what I understand, things wouldn't break with slab memory for zswap
> > compressed storage, but I could be wrong. I hope to include the
> > architecture level considerations/trade-offs in the RFC.
>
> Zsmalloc memory is currently movable, so compaction can move it around
> to free contiguous blocks (e.g. for THP allocations). Slab memory is
> not movable. It can be reclaimable, but writing back memory from zswap
> when we are not under memory pressure is also bad.

All good points, thanks. I agree, writing back memory from zswap when
not under memory pressure is bad, however I have not seen any
writebacks in my experiments with usemem at 60% over-commit and with
64kB mTHP.

I am running these experiments in a memory constrained environment:

QEMU VM: 7G RAM
Swap: 3G
cgroup memory.high: 3G
4 usemem processes want to allocate 1200M each. To make the experiment
even more stringent and representative of actual compression datasets,
each usemem process reads the Silesia dataset from a
pre-fork-allocated buffer into the 1200M. This causes realistic
compression payloads in usemem.

>
> Note that compressed memory can be very large compared to slab
> allocations (or kernel allocations in general), so it can increase
> unmovable (or reclaimable but not movable) memory significantly,
> causing fragmentation.

It took me a while to experiment with compressed size bins, until I
settled on a compromise between memory wasted per slab and zswap
latency in finding the correct size bin to minimize fragmentation. I
have been gathering extensive SLUB stats which indicate:

1) Even under peak zswap compressed quota ("pool") utilization across
10 consecutive iterations, SLUB comes out ahead in less overall memory
overhead.

2) At steady state (when 10 iterations of the workload are done), most
of the slabs have been returned to the Buddy allocator, except for 3M
worth of slab setup per compressed size bin (0 objects in use): this
is as compared to 32K of zsmalloc slub metadata that remains at steady
state.

I learned some really interesting things from these experiments, which
pose questions about the memory penalty due to latency that zsmalloc
adds to zswap compress/decompress paths vs. "internal fragmentation".
I expect to quantify this with data from my experimental setup.
