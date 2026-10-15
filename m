Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E721C288C96
	for <linux-crypto@vger.kernel.org>; Thu, 15 Oct 2026 22:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792104520; cv=none; b=AmiKzRkdEU9zbsVDK2bQI3/R2NHHeFLktZrvP7R7ylQfVYOVCrg7rlz+J9c0bTVcAX/Lfh1JhHrc9e87bKtARn7fDbwipp5lqBQwOdDKHfkez8wxpxLHtcFmDNANzSdrkSpe4BFAjrWfXMDU0ZtM3L2XhIWZ52w2za1b6WDU9PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792104520; c=relaxed/simple;
	bh=mBvROpDAXljWOCYCxPFxmbqoGhdj5l7GlAWCJboV/2Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iBxZjTxCeZ0FBMx2MDs88GoH/wJJlOsX6BopzNIx+QkInsz/cjgiGnTGjEraBBmTGmIc5s+Hc9VLwv+5BDR4ruETLVEKdf+Ilj4eTBQsJdzA4M8J5pKH9bVW88ZIsi0htBsz4X4bn+2C5sQvYjhuHXlcaNqIpKRKBGSKj3mI51w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hmMI300v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hmMI300v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96E571F000C4
	for <linux-crypto@vger.kernel.org>; Thu, 15 Oct 2026 22:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792104518;
	bh=1V9CLpu10O1jPLEvgLakWRwageDrCx/acxcQ42UB1iQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=hmMI300v0CSWEEGulFbyPPwZQ5gUAMCZF+mqGOjdl+L62Lj1t74wfSuept1fVqG0v
	 1b36Z0gw9b7VNlztUiioksU7+cIrBfMNSCj19qyZ5Vst+0lF3bvXxfrwr9e55vfJTJ
	 pXMXrNWhGxi8LPrXCAZwsFSd5XdH562s5kQnW7IBxpUr2FYNaCdLGZzlado+qmhrr5
	 Jwkklb6re1flkLKKBPUTX20GkDHzHzOwBVe+ZLk31K0RB5nCJigrhzqGTlP0xDOIUz
	 iGWJrsiKSjBqOCNL3F4GLGT7GCY8S9AoT+FsdzLgw4QrkQR/qDoYuOBGfir4oixOHf
	 eahrf2/taNYWg==
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-93a40a9a01aso63725685a.0
        for <linux-crypto@vger.kernel.org>; Thu, 15 Oct 2026 15:48:38 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzMipYJEj+LLnoWYJpUbxLtBaiH+9vd5dnWoG0ZqFETV8qGnHW2vh1bZzZK/PzsWwl2qJ9a+9eudu3w/hg=@vger.kernel.org
X-Gm-Message-State: AFq9FYKGlx/MZeEtbfB1Y6h4HjP4I1hI8em4IqCb0ZABsstkszSFARyZ
	zJ7h5duF7UtfMpxRduukmwfnQ69LjxbBFCIJbiGzkNNBZ7vqcb8+wTVBpjEf3d/z5tqoXSNQzE4
	R13p1eefZM7mKPe6sWAoZqDZwQ7TyvOM=
X-Received: by 2002:a05:620a:1707:b0:93e:5508:24f8 with SMTP id
 af79cd13be357-93f17f65725mr271332285a.32.1792104518007; Thu, 15 Oct 2026
 15:48:38 -0700 (PDT)
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
 <CACpmpodDA=oqnVa_hsJpyhGt=4zxknYF=QX9L6-sJbxsRxtM2w@mail.gmail.com>
 <CAO9r8zNN6F01icKUFr8q_AgJvhxGw0MkGezKbBuKzFQV0NaAdg@mail.gmail.com> <CACpmpocCJWkA+zvZ9ivNCt8xSZWfViKQ2ZeYN+f1EmdVTewzRQ@mail.gmail.com>
In-Reply-To: <CACpmpocCJWkA+zvZ9ivNCt8xSZWfViKQ2ZeYN+f1EmdVTewzRQ@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 15 Oct 2026 15:48:25 -0700
X-Gmail-Original-Message-ID: <CAO9r8zOtedHfJ5A7JiXJYtWO-MjoGfE9PLPyyrQoHrr-R3FivA@mail.gmail.com>
X-Gm-Features: AclHuK-xrj8xMXtzgLT0L3fOnR7Oshgch5485U5XCqQHI3AqfSa_Wb3B6E8EGrI
Message-ID: <CAO9r8zOtedHfJ5A7JiXJYtWO-MjoGfE9PLPyyrQoHrr-R3FivA@mail.gmail.com>
Subject: Re: [PATCH v1 5/8] mm: zswap: Store the folio's node id in the zswap_entry.
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 15, 2026 at 3:45=E2=80=AFPM Kanchana P. Sridhar
<kanchanapsridhar2026@gmail.com> wrote:
>
> On Thu, Oct 15, 2026 at 2:39=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wr=
ote:
> >
> > > > > > > @@ -1449,9 +1446,10 @@ static bool zswap_store_page(struct fo=
lio *folio, long index,
> > > > > > >  {
> > > > > > >       swp_entry_t page_swpentry =3D folio_swap_entry(folio, i=
ndex);
> > > > > > >       struct zswap_entry *entry, *old;
> > > > > > > +     int nid =3D folio_nid(folio);
> > > > > > >
> > > > > > >       /* allocate entry */
> > > > > > > -     entry =3D zswap_entry_cache_alloc(GFP_KERNEL, folio_nid=
(folio));
> > > > > > > +     entry =3D zswap_entry_cache_alloc(GFP_KERNEL, nid);
> > > > > >
> > > > > > We don't need to allocate the entry on the same node anymore, s=
hould we
> > > > > > drop this and let the slab allocator handle it as it sees fit?
> > > > >
> > > > > Was this a recent change? I see the folio_nid(folio) on my versio=
n of
> > > > > mm-unstable as of 10-3-2026. Let me check, and yes, allowing the =
slab
> > > > > allocated handle this is probably a good idea.
> > > >
> > > > We allocate the entry on the same node to avoid having to store nid=
 in
> > > > the zswap entry (see entry_to_nid()). If we store it, then there's =
no
> > > > need to allocate on the node.
> > >
> > > With patch 0006, we try to bulk allocate all entries for the batch.
> > > Only if this fails, we call zswap_entry_cache_alloc(gfp, nid). So
> > > patch 0006 addresses this already, and the nid is used on in the
> > > fallback case.
> >
> > If we are storing the nid in the zswap entry, there is no need for
> > zswap_entry_cache_alloc() to use the nid anymore.
>
> As of now, zswap_entry_cache_alloc() uses the nid for
> kmem_cache_alloc_node(). Is the suggestion to change this to be
> kmem_cache_alloc()?

Yes. I don't think we need to use kmem_cache_alloc_node() if we store
nid in zswap_entry.

>
> >
> > >
> > > >
> > > > >
> > > > > Along the same lines, I have been working on replacing zsmalloc w=
ith
> > > > > direct SLAB allocations for the zswap compressed data storage and=
 see
> > > > > very promising results: memory savings and latency improvements. =
I
> > > > > will submit an RFC shortly.
> > > >
> > > > Keep in mind that zsmalloc is movable memory, while slab memory isn=
't.
> > > > Zsmalloc may also be less likely to make a new allocation in the st=
ore
> > > > path. There are other considerations beyond memory overhead and
> > > > latency here.
> > >
> > > I realize this means we trade off page migration for writeback for th=
e
> > > pages representing zswap compressed data. This might not necessarily
> > > be a bad thing for 2 main reasons, the way I see it in this specific
> > > context:
> > >
> > > 1) Page migration would only be transferring a memory pressure proble=
m
> > > elsewhere. Not sure how well this would work with memcgs or
> > > containers. At some point someone would need to do writeback.
> > > 2) I don't believe there is a zswap specific page migration flow in
> > > the kernel other than zsmalloc compaction. IOW, memory tiering
> > > components like CXL are handled directly in the reclaim path. From
> > > what I understand, things wouldn't break with slab memory for zswap
> > > compressed storage, but I could be wrong. I hope to include the
> > > architecture level considerations/trade-offs in the RFC.
> >
> > Zsmalloc memory is currently movable, so compaction can move it around
> > to free contiguous blocks (e.g. for THP allocations). Slab memory is
> > not movable. It can be reclaimable, but writing back memory from zswap
> > when we are not under memory pressure is also bad.
>
> All good points, thanks. I agree, writing back memory from zswap when
> not under memory pressure is bad, however I have not seen any
> writebacks in my experiments with usemem at 60% over-commit and with
> 64kB mTHP.

We can discuss further when you make your posting :)

>
> I am running these experiments in a memory constrained environment:
>
> QEMU VM: 7G RAM
> Swap: 3G
> cgroup memory.high: 3G
> 4 usemem processes want to allocate 1200M each. To make the experiment
> even more stringent and representative of actual compression datasets,
> each usemem process reads the Silesia dataset from a
> pre-fork-allocated buffer into the 1200M. This causes realistic
> compression payloads in usemem.
>
> >
> > Note that compressed memory can be very large compared to slab
> > allocations (or kernel allocations in general), so it can increase
> > unmovable (or reclaimable but not movable) memory significantly,
> > causing fragmentation.
>
> It took me a while to experiment with compressed size bins, until I
> settled on a compromise between memory wasted per slab and zswap
> latency in finding the correct size bin to minimize fragmentation. I
> have been gathering extensive SLUB stats which indicate:
>
> 1) Even under peak zswap compressed quota ("pool") utilization across
> 10 consecutive iterations, SLUB comes out ahead in less overall memory
> overhead.
>
> 2) At steady state (when 10 iterations of the workload are done), most
> of the slabs have been returned to the Buddy allocator, except for 3M
> worth of slab setup per compressed size bin (0 objects in use): this
> is as compared to 32K of zsmalloc slub metadata that remains at steady
> state.
>
> I learned some really interesting things from these experiments, which
> pose questions about the memory penalty due to latency that zsmalloc
> adds to zswap compress/decompress paths vs. "internal fragmentation".
> I expect to quantify this with data from my experimental setup.
