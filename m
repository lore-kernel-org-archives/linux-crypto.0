Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E6A3480DE0
	for <linux-crypto@vger.kernel.org>; Thu, 15 Oct 2026 21:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792100396; cv=none; b=QEX2fq1q5hbXUbZhLq+0MhmEVvwbW15XeeyKqBRswHI2ywYfv0CjI8nDjKFC0HF6UFzfouKuarKLJfN/yr40gdwETefVd/8XtzAUXt5rr0s5FnVDXi2BxlfkjlP5dAFNpqKekawgenNLKP3hGKFS2kqQI/PMS5Lbgl+9+Y8eEqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792100396; c=relaxed/simple;
	bh=8M6afGOdxI7mwSN4JB/mHsfiwomnJtKrE7cBHmGvef8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pNL96wLXJXVi0IOclhOPjmcoeoHX7cxL1qncxHBL0b/1u8Kr4m7jv4gJBWLg/+rIzF+HrF1R3J8PqWApuHPGp+t4fsk96HY8nRJu9eNZtxKVGw8L801mzPg+kY9Nu+Grf4dlj+wQXhUhpD6eRHILvVr6dSmQhgzzlRgNDaSEr9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LRPVxAtK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LRPVxAtK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C8321F000CA
	for <linux-crypto@vger.kernel.org>; Thu, 15 Oct 2026 21:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792100395;
	bh=gJ+0YN8j089fj2ZV/djvu5s7T0hJNC6kJYYYjsa++Vw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=LRPVxAtKyePwlj7nRCOHozmKtpL5xH7vvA+BiKRv7PZEAPatwvbFpQeosgeOwR2us
	 o9Q/DRB1MWTTAPaNelD42Gmm9i9RAn6GqfrvZgUlPY5gsN7ukVqZyu9NTyPuGI19RI
	 9FBTgEfMeyiF1iIksvC5BcSQYqnsmS4PaAi7pVjuJ7HWzqQjXA5k9RvLoK0sqNGVyL
	 +f6wc01mrWwlfFJfTpkXpbcr1r+hdQoVoFFn+9feJ5ZX85Wn0JZW3r5hudck9E6nXa
	 IrWvri+NKaqq3mA+4Fb1nHUN3MHKdkrgsHXIJyW4VvXE5J/nr4d+NQRqQtEVQ7UuqG
	 gLqesWkMwcD/w==
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c2e8c710847so725831166b.0
        for <linux-crypto@vger.kernel.org>; Thu, 15 Oct 2026 14:39:55 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByiUowjvMdHEXzWHkmkfW412UCISGw5BH78LcOvVF3Nsiegr2rOy0T6fp9RKlpB+xPkQgF27HmfReogMvQ=@vger.kernel.org
X-Gm-Message-State: AFq9FYJ/J8YFPtD+LtPCplVIz3pW6k4ZT5vMV1Tbl8s+RGaMPXo5+7bx
	TRV9BhlYAvhJWshAHbg5kn5VQukYNL5IIQlIzwHysxVjWHxkMPxrSYQCebj3bVGm9C0zLljnJ8B
	hX47kBHNkwaXiiBK9NaQoXxr5CyrE77M=
X-Received: by 2002:a17:907:3f12:b0:c21:450d:cd7e with SMTP id
 a640c23a62f3a-c31a9af76e8mr2002892866b.9.1792100393987; Thu, 15 Oct 2026
 14:39:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
 <20261008182814.27450-6-kanchanapsridhar2026@gmail.com> <as7JC8o2kggiq_ss@google.com>
 <CACpmpofXMGBP70Rn7jHLwOF38GRKMUGoW3rb1Jp2SPH7ygKcfw@mail.gmail.com>
 <CAO9r8zOEcGmg8eVttu41htugnng0ahnVQbubiJfxVH+GfDe47Q@mail.gmail.com> <CACpmpodDA=oqnVa_hsJpyhGt=4zxknYF=QX9L6-sJbxsRxtM2w@mail.gmail.com>
In-Reply-To: <CACpmpodDA=oqnVa_hsJpyhGt=4zxknYF=QX9L6-sJbxsRxtM2w@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 15 Oct 2026 14:39:42 -0700
X-Gmail-Original-Message-ID: <CAO9r8zNN6F01icKUFr8q_AgJvhxGw0MkGezKbBuKzFQV0NaAdg@mail.gmail.com>
X-Gm-Features: AclHuK9_U4t1aJcro9clqrnxlUhMU2VGLAoMd7xVc_4UgYJfOHupT3dXjx731Xo
Message-ID: <CAO9r8zNN6F01icKUFr8q_AgJvhxGw0MkGezKbBuKzFQV0NaAdg@mail.gmail.com>
Subject: Re: [PATCH v1 5/8] mm: zswap: Store the folio's node id in the zswap_entry.
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org
Content-Type: text/plain; charset="UTF-8"

> > > > > @@ -1449,9 +1446,10 @@ static bool zswap_store_page(struct folio *folio, long index,
> > > > >  {
> > > > >       swp_entry_t page_swpentry = folio_swap_entry(folio, index);
> > > > >       struct zswap_entry *entry, *old;
> > > > > +     int nid = folio_nid(folio);
> > > > >
> > > > >       /* allocate entry */
> > > > > -     entry = zswap_entry_cache_alloc(GFP_KERNEL, folio_nid(folio));
> > > > > +     entry = zswap_entry_cache_alloc(GFP_KERNEL, nid);
> > > >
> > > > We don't need to allocate the entry on the same node anymore, should we
> > > > drop this and let the slab allocator handle it as it sees fit?
> > >
> > > Was this a recent change? I see the folio_nid(folio) on my version of
> > > mm-unstable as of 10-3-2026. Let me check, and yes, allowing the slab
> > > allocated handle this is probably a good idea.
> >
> > We allocate the entry on the same node to avoid having to store nid in
> > the zswap entry (see entry_to_nid()). If we store it, then there's no
> > need to allocate on the node.
>
> With patch 0006, we try to bulk allocate all entries for the batch.
> Only if this fails, we call zswap_entry_cache_alloc(gfp, nid). So
> patch 0006 addresses this already, and the nid is used on in the
> fallback case.

If we are storing the nid in the zswap entry, there is no need for
zswap_entry_cache_alloc() to use the nid anymore.

>
> >
> > >
> > > Along the same lines, I have been working on replacing zsmalloc with
> > > direct SLAB allocations for the zswap compressed data storage and see
> > > very promising results: memory savings and latency improvements. I
> > > will submit an RFC shortly.
> >
> > Keep in mind that zsmalloc is movable memory, while slab memory isn't.
> > Zsmalloc may also be less likely to make a new allocation in the store
> > path. There are other considerations beyond memory overhead and
> > latency here.
>
> I realize this means we trade off page migration for writeback for the
> pages representing zswap compressed data. This might not necessarily
> be a bad thing for 2 main reasons, the way I see it in this specific
> context:
>
> 1) Page migration would only be transferring a memory pressure problem
> elsewhere. Not sure how well this would work with memcgs or
> containers. At some point someone would need to do writeback.
> 2) I don't believe there is a zswap specific page migration flow in
> the kernel other than zsmalloc compaction. IOW, memory tiering
> components like CXL are handled directly in the reclaim path. From
> what I understand, things wouldn't break with slab memory for zswap
> compressed storage, but I could be wrong. I hope to include the
> architecture level considerations/trade-offs in the RFC.

Zsmalloc memory is currently movable, so compaction can move it around
to free contiguous blocks (e.g. for THP allocations). Slab memory is
not movable. It can be reclaimable, but writing back memory from zswap
when we are not under memory pressure is also bad.

Note that compressed memory can be very large compared to slab
allocations (or kernel allocations in general), so it can increase
unmovable (or reclaimable but not movable) memory significantly,
causing fragmentation.
