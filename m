Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1723B406261
	for <linux-crypto@vger.kernel.org>; Thu, 15 Oct 2026 23:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792107649; cv=pass; b=SEcaHCgVgp18MHWERE2GpOOEeyX0f6/NaRde7FvicawzymUK5WNJXg0+oQbuyTZu7bcOrtjqdhkdWS4MKRRf55p87spqCu+iXTxWoBMC/UT/ivWaVDC3692oMN0rZey4hZjdEI0qPF50/cwHbRU3ZCZoaTh3Rip9mGpQPt78UJ8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792107649; c=relaxed/simple;
	bh=gU6spUyBJo8/NyQju/fbWu3JCOe2HGiOjWXuw6Ws2zs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pFf/YPo4UkLDVzkvoIHnUSDOBp8z4kDqzwoxkmcVuIOCNDzPDGo1Q7EjwV3IxEoEoTAJ+vVG3eLLB6q3GIE1zTWDTvEbvuKhQv5qol9coI64wSlIABMxknhs/LEhAv80FxgDkHLlWs+gSr4DhLSf07AbU+6C+BNZ2at2kU2as+8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MRi88Jc0; arc=pass smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MRi88Jc0"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5be4b61fd3dso62704e87.3
        for <linux-crypto@vger.kernel.org>; Thu, 15 Oct 2026 16:40:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792107646; cv=none;
        d=google.com; s=arc-20260327;
        b=BEfAwlSmGC2FbGTvZVqGc1nvYKoOI2ukmqjYJe6GvfFfgjcLuxH1Ref7/eplbYQhRn
         Huw6rtdoOp08I7SRy1r+mhmGdcFWIHTQkkJ9RH4ORIuIr/iMm0DkaL6H+NGzBHKyVwt+
         JcAwG5ixPfxckuXmMNPLf8PmEJLeZ3HlcSJ/Zp8xftWLvvuTsYJJrQ+tSuTne2AcUPmN
         hhuLk2n2tnLAa3jlog0JuU9aa9Asn20uad7cxf/gRlWYJVkpuXLlVEOtudRhoRnLsNL8
         jfptZhbxqsCRZ45Ha89m9gBcbhMYkxZkW2DOGjRVqiOp5CypQGLy3cUQaH6pOiXiY1Zp
         G4Kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ICP/xr5+1YMQinRVIx0qLLDaZPBqnXiqmFQQcLFIEgw=;
        fh=JYZDCbcdBh8h0IjhoD1KkWIY+MbR9tNuDzmXz/ysD0E=;
        b=VNk3DanwvaCldCstC+9/cf/HuCqFgblgSfqmp5QODQbkGBiBfiAjYn/Qr6uLbU4Qip
         ocU1OcKN7pdynaN5kaVbyn439+6G0XQ4lhnQ/2Rg1IHm8mMH54HjJVJWSG+8JQmdBCxU
         lVfaFEV0odedOxINjSkUf2msVvP4d0Vr3W5OClptZkZXR2nkdmriiMcE4dH5/wYDAEjO
         ng/CJxFOZ2/pecwtbDvNPd8NbN13hgEyqmyzJyODLmadszP3jEO2HPvFZ4IIQsQVmVS4
         9eFUzR8Qe8N8V3ZdujUH+nJUkluaox131TXTU3CJwvke4QXnwhwK9aAoHN5UjX9Js/3n
         7pHQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792107646; x=1792712446; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ICP/xr5+1YMQinRVIx0qLLDaZPBqnXiqmFQQcLFIEgw=;
        b=MRi88Jc05KabRN3WzOo64HQFtouX6U9tbXmaHgA1YDHmHdIIbxG0dcqitRAWhhIBQi
         7uk8syL/aS0yxrsgcpbmGbmUjyDsira1/q4Rluw83Ruo2T/AnnrJ1NlX2AoPqAth+5sW
         OGfaL9Hx+5UppvOgMdtqMGN3Jm6Ux+zePCN5qJSXBOOrKa39EmHFFA6MgdnMAJoEjOE/
         prqOBOKpca96mcLs9dmE2kI6CesQ9A5J4XL3dG3On9OFf41q6PSFOfW6EwQFr6lY4d9U
         8EeBAahKQygaW5v6o8ATnFmryrLvR5VuoVRqZVB7Qy4hELCJ7ELFhfa5FgYxo/70vS08
         xQQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792107646; x=1792712446;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ICP/xr5+1YMQinRVIx0qLLDaZPBqnXiqmFQQcLFIEgw=;
        b=UjZ+ROnjzJAtb/RNNlkZCjGy6mRNNhzbuh9DP1IwQ1DQpiRMrCMnV5zlDCOUjGLxA7
         2JtQQoAqrZIt2nCH7Fri9I8G+ojFEbC7ZgM/nTX48+uwKSu+zylGa7NmxAW5ZXh8MzAZ
         WmjDoZQdv/CS2eWdKxQNorO3aZJVqtnAA2pqF+uHMWqBTljrj2PrFptxk7dLmvOfzkw9
         ZEiVg1u+6+AIIu3sdmjo2xB8/aN9GfZap0sB8W+h2U3slLocRiHriQwmu+CyVqyL5uCw
         lWFnVSSX1meFevr9SGnupZ9ox58hfBvuvgqUCBjwKKjEzt+fby7R3uMNwIjgZAQLIcA7
         7Y4A==
X-Forwarded-Encrypted: i=1; AKwUvBxn+HdXNVKBAUWWL659A2r37EkaxdWwEckbz/3eMQELZLtMZhu84VPBNN5csY2xV1FulqAs5yTzr38bmYY=@vger.kernel.org
X-Gm-Message-State: AFq9FYKJtuM1N8kY0ijutMb5Dz9v7CHyqxlWWQE9suXwKuKdFGojt7Ka
	Futhr0eOF4nSQvxxS4FBYNNkJdWCJ0dfBlZTtLsiQDyumkor2h8cwv1kenaowNJ7km+hve7V4Yn
	eOEikL741cQ95I8tgtY6+Hmav9Ht3TK4=
X-Gm-Gg: AYBFou2nDZmtBzkAwcvHz2e9e6ZmpcrlIIkYSN+Qu0NUJsObwJn0iF/6XjZ5L6TcUQ5
	A5U7zHqzfAIQ9QGRd5geI1Ic0rPakwn5of1TJS7FXtn9L2m+1pvIgAYMjbVdhHuYD29LrEk8KoQ
	GZPkkkGH+uoKRrn1ZFGgaX3zMKXesYxfhCLVm0wLrEayZlWjNBw025ra8SyELH8/CPsbwvUmVCq
	2u2pCPUBl7QLb3IWLdIX/QT32SdU9+kP+xFvI9dEUUZMg87pzz4n5P4laPF42KGayJ0ck28/l2f
	o1y7N3lyh1ujO3G42zSwgFRI/bbBnyIc38CYSCtgwzN/FlDzTbVXUu0G
X-Received: by 2002:a05:6512:682:b0:5ba:3c60:b875 with SMTP id
 2adb3069b0e04-5bcde5aab53mr7165266e87.43.1792107645951; Thu, 15 Oct 2026
 16:40:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
 <as-jZopKRfuYAiTE@google.com> <CACpmpoeS_cvXRWJXqiYZV9oykk=91efv8KtZgK2Pi-QwHnQH3A@mail.gmail.com>
 <CAO9r8zN5n=9v4K+OtEEODg=e0kcFW99PreUcZm09q9CUMQc+ew@mail.gmail.com>
 <CACpmpofdoeVbbw7izCDeJ7eS+XpWj+3sp3teKEQWywyRB75jYQ@mail.gmail.com> <CAO9r8zMaaUsBaS0TJumochRKt2ShV7nRaLnYPWv3=S-wUFgitw@mail.gmail.com>
In-Reply-To: <CAO9r8zMaaUsBaS0TJumochRKt2ShV7nRaLnYPWv3=S-wUFgitw@mail.gmail.com>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Thu, 15 Oct 2026 16:40:33 -0700
X-Gm-Features: AclHuK-o0YoycUuTLR9c0WACqcfx9D0UCCwaTlp6tqXVGsdos9IwJufLaP7OH9Q
Message-ID: <CACpmpoecz4tjr-qvFRy22CGuF+4NBWbE7HVjdTGFqQOheK3CLg@mail.gmail.com>
Subject: Re: [PATCH v1 0/8] Batched zswap_store() with compression batching
To: Yosry Ahmed <yosry@kernel.org>
Cc: hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 15, 2026 at 3:59=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> On Thu, Oct 15, 2026 at 3:51=E2=80=AFPM Kanchana P. Sridhar
> <kanchanapsridhar2026@gmail.com> wrote:
> >
> > On Thu, Oct 15, 2026 at 3:04=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> =
wrote:
> > >
> > > On Thu, Oct 15, 2026 at 3:00=E2=80=AFPM Kanchana P. Sridhar
> > > <kanchanapsridhar2026@gmail.com> wrote:
> > > >
> > > > On Wed, Oct 14, 2026 at 8:45=E2=80=AFAM Yosry Ahmed <yosry@kernel.o=
rg> wrote:
> > > > >
> > > > > On Thu, Oct 08, 2026 at 11:28:06AM -0700, Kanchana P. Sridhar wro=
te:
> > > > > > v1: Batched zswap_store() with compression batching
> > > > > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> > > > > >
> > > > > > This series is a spin-off of "v14: zswap compression batching w=
ith optimized
> > > > > > iaa_crypto driver" [1], and focuses on the generic crypto_acomp=
 and zswap
> > > > > > compression batching enablers. Resuming work on this series fol=
lowing a gap
> > > > > > since v14 (January 2026). Please note that my email address and=
 affiliation have
> > > > > > changed from kanchana.p.sridhar@intel.com to kanchanapsridhar20=
26@gmail.com. I
> > > > > > have retained the original Intel sign-offs on prior patches for=
 historical
> > > > > > attribution while signing off v1 of this series with my current=
 address.
> > > > > >
> > > > > > To summarize the main contribution of this patch series: Batchi=
ng is introduced
> > > > > > in zswap_store() of large folios: we carve out a large folio in=
to batches of
> > > > > > ZSWAP_MAX_BATCH_SIZE (8 pages) for software compressors, and st=
ore each
> > > > > > batch. Moving the fundamental operations that need to be happen=
 to store a page
> > > > > > to now work at the granularity of a batch offers opportunities =
to optimize them
> > > > > > from these perspectives:
> > > > > >
> > > > > > 1) Utilize existing kernel API that minimize obtaining locks fo=
r bulk
> > > > > >    operations, e.g. kmem_cache_alloc_bulk()/kmem_cache_free_bul=
k().
> > > > > >
> > > > > > 2) We keep the working set for each of the core store functiona=
lities (alloc
> > > > > >    entries, compress pages, store pages in zsmalloc) to be focu=
sed on a
> > > > > >    batch, thereby minimizing cache evictions and benefiting fro=
m cache
> > > > > >    locality.
> > > > > >
> > > > > > 3) Along the lines of (1), the main zswap_compress() batching r=
outine obtains
> > > > > >    the acomp_ctx mutex lock once per batch, and releases it aft=
er it has
> > > > > >    processed all pages in that batch.
> > > > > >
> > > > > > 4) Any zswap store functionality that works on a batch can pote=
ntially be
> > > > > >    parallelized as a next step, to further improve performance.
> > > > > >
> > > > > > Performance data: usemem with 60% over-commit:
> > > > > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > > >
> > > > > How much of the performance benefits come from patch 6 vs patch 8=
?
> > > >
> > > > This is how the performance changes: Average throughput is averaged
> > > > from 10 iterations of usemem.
> > > >
> > > > patch 6: 19,119 KB/s
> > > > patch 8: 17,593 KB/s
> > > >
> > > > So the acomp_do_req_chain() path that ZSTD goes through with patch =
8
> > > > causes a regression, even though it provides a generic batching
> > > > framework in acomp.
> > > >
> > > > I was able to retrieve performance with the following change in aco=
mpress.c:
> > >
> > > Why add it to begin with in this case?
> >
> > Patch 3 ("crypto: acomp - Add trivial segmentation wrapper.") was
> > co-developed with Herbert. The request chaining for non-segmentation
> > algorithms was as in Herbert's original implementation. Since this
> > causes a regression, I would like to get Herbert's Ok on replacing the
> > request chaining in this part of crypto_acomp_compress().
>
> I mean, why add patch 8 if it doesn't improve performance? Seems like
> even with your diff, we only recover performance, but we don't improve
> it after patch 6?

Patch 8 does improve performance over patch 6 (19,578 KB/s vs. 19,119
KB/s) by 2.4%. Besides, patch 8 provides a compress batching framework
in zswap, which is the purpose of this patch series. zswap is the
first user of the crypto_acomp compress batching API provided earlier
in this series, which I think, is a great starting point for us to
evolve this further, as mentioned in the cover letter.

Thanks,
Kanchana
