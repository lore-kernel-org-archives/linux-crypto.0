Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7801812B94
	for <linux-crypto@vger.kernel.org>; Thu, 15 Oct 2026 22:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792105154; cv=none; b=GIR5a6CjXti+bgx78pA/kWgiOoZXVBI89C2vLEnHcLLRBhAim15AIc4qPkKNqQQMR0NS4HuejgawG8wYn5OCQjjDAislLf6r7CHd/oRbuGL7i9iUOkCR086tQ3440MvSFheETSYtWZIQdl1LzklWKfnkEiqD9mFMremWV31BpGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792105154; c=relaxed/simple;
	bh=hZzozqCT/nsxUF0iE8dTuCK3A2ncDBpA6GCk9vC81UA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=l9kXC2TVQtvghEouxXUkO9dVFZ05RUWLcclVM02F3tQIWrcPTXzibSsWozVCxM1CPNfDvIGuR3DrCmK9YmYy9dqOvihOor34uwbFx9UriceBDEOESNkAWcBIqWp9QwBRKODK5jlEQw4petcuHdm4lRpZO5FebAvfd3Pi8f/nk0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XZEP2WBf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XZEP2WBf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 466711F000C8
	for <linux-crypto@vger.kernel.org>; Thu, 15 Oct 2026 22:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792105153;
	bh=vnQrwyzLoVynTCLEtuWk+TScXXTmTjeMSsfmQV0kEjE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=XZEP2WBfROoz/n/DQyrwTl60Bxqkw8stXfth5gXqEeC4dP/IiSB1l6fZaqdB5/9bn
	 F1J31UvRoUjffzlKp8FmKCVZogCI2A1t9dQM1Ilh8oSYUqrIh8dbK67PVp6NdeqrMH
	 IowuIbK0VmtR+Sj6UK59PLnnmUUfTDtm+0MdFvHHjbANcGKF2hUWK/Ke9tmSGGWkC0
	 hv8zKP2bSHHR/S6rsRZM4v6FLXu8xrlA9UQ7Q6IpRP3v+HJHp+BPU/EwKwj8F+wKrh
	 5VxXQp3KjUwOM77gCWwppm/ccGZKYCpj0cSadmqmJa1JDiqhA1+uFr3DXm9ciw7KrH
	 ZrFFJmHD4a4CA==
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c3fd91337baso135042166b.3
        for <linux-crypto@vger.kernel.org>; Thu, 15 Oct 2026 15:59:13 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBy4NNcFCZ+BXG4v5wZyO4D9LJqIukIGiyy6u32wRaw9Ln/ZAzOk7XP0KMTLw9Z5h5ugXGLndUkuYFVlnF8=@vger.kernel.org
X-Gm-Message-State: AFq9FYJk9fFhT/0/kRdQf+Ub1pOXHJ4EK6ScRWW7c36YT7xfXgJgn5Ie
	87He53nTCFSWwwwa31d9A5ttwmbKytDXsqB/hJHyv+qzod0r0Qr3IPab6rKbvJh5lHomMogc1ng
	EJY2PSUpaKBCrdzlTkOfFMP8IQifoXck=
X-Received: by 2002:a17:907:d08c:b0:c3f:c856:fb7a with SMTP id
 a640c23a62f3a-c3fc856fda9mr209686866b.3.1792105152116; Thu, 15 Oct 2026
 15:59:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
 <as-jZopKRfuYAiTE@google.com> <CACpmpoeS_cvXRWJXqiYZV9oykk=91efv8KtZgK2Pi-QwHnQH3A@mail.gmail.com>
 <CAO9r8zN5n=9v4K+OtEEODg=e0kcFW99PreUcZm09q9CUMQc+ew@mail.gmail.com> <CACpmpofdoeVbbw7izCDeJ7eS+XpWj+3sp3teKEQWywyRB75jYQ@mail.gmail.com>
In-Reply-To: <CACpmpofdoeVbbw7izCDeJ7eS+XpWj+3sp3teKEQWywyRB75jYQ@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 15 Oct 2026 15:59:00 -0700
X-Gmail-Original-Message-ID: <CAO9r8zMaaUsBaS0TJumochRKt2ShV7nRaLnYPWv3=S-wUFgitw@mail.gmail.com>
X-Gm-Features: AclHuK8OVaqtU74IUTXePWDKqT9l38kwuNNsIo2XNA9CQvEhaVmXaKfetDsN0wo
Message-ID: <CAO9r8zMaaUsBaS0TJumochRKt2ShV7nRaLnYPWv3=S-wUFgitw@mail.gmail.com>
Subject: Re: [PATCH v1 0/8] Batched zswap_store() with compression batching
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 15, 2026 at 3:51=E2=80=AFPM Kanchana P. Sridhar
<kanchanapsridhar2026@gmail.com> wrote:
>
> On Thu, Oct 15, 2026 at 3:04=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wr=
ote:
> >
> > On Thu, Oct 15, 2026 at 3:00=E2=80=AFPM Kanchana P. Sridhar
> > <kanchanapsridhar2026@gmail.com> wrote:
> > >
> > > On Wed, Oct 14, 2026 at 8:45=E2=80=AFAM Yosry Ahmed <yosry@kernel.org=
> wrote:
> > > >
> > > > On Thu, Oct 08, 2026 at 11:28:06AM -0700, Kanchana P. Sridhar wrote=
:
> > > > > v1: Batched zswap_store() with compression batching
> > > > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> > > > >
> > > > > This series is a spin-off of "v14: zswap compression batching wit=
h optimized
> > > > > iaa_crypto driver" [1], and focuses on the generic crypto_acomp a=
nd zswap
> > > > > compression batching enablers. Resuming work on this series follo=
wing a gap
> > > > > since v14 (January 2026). Please note that my email address and a=
ffiliation have
> > > > > changed from kanchana.p.sridhar@intel.com to kanchanapsridhar2026=
@gmail.com. I
> > > > > have retained the original Intel sign-offs on prior patches for h=
istorical
> > > > > attribution while signing off v1 of this series with my current a=
ddress.
> > > > >
> > > > > To summarize the main contribution of this patch series: Batching=
 is introduced
> > > > > in zswap_store() of large folios: we carve out a large folio into=
 batches of
> > > > > ZSWAP_MAX_BATCH_SIZE (8 pages) for software compressors, and stor=
e each
> > > > > batch. Moving the fundamental operations that need to be happen t=
o store a page
> > > > > to now work at the granularity of a batch offers opportunities to=
 optimize them
> > > > > from these perspectives:
> > > > >
> > > > > 1) Utilize existing kernel API that minimize obtaining locks for =
bulk
> > > > >    operations, e.g. kmem_cache_alloc_bulk()/kmem_cache_free_bulk(=
).
> > > > >
> > > > > 2) We keep the working set for each of the core store functionali=
ties (alloc
> > > > >    entries, compress pages, store pages in zsmalloc) to be focuse=
d on a
> > > > >    batch, thereby minimizing cache evictions and benefiting from =
cache
> > > > >    locality.
> > > > >
> > > > > 3) Along the lines of (1), the main zswap_compress() batching rou=
tine obtains
> > > > >    the acomp_ctx mutex lock once per batch, and releases it after=
 it has
> > > > >    processed all pages in that batch.
> > > > >
> > > > > 4) Any zswap store functionality that works on a batch can potent=
ially be
> > > > >    parallelized as a next step, to further improve performance.
> > > > >
> > > > > Performance data: usemem with 60% over-commit:
> > > > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > >
> > > > How much of the performance benefits come from patch 6 vs patch 8?
> > >
> > > This is how the performance changes: Average throughput is averaged
> > > from 10 iterations of usemem.
> > >
> > > patch 6: 19,119 KB/s
> > > patch 8: 17,593 KB/s
> > >
> > > So the acomp_do_req_chain() path that ZSTD goes through with patch 8
> > > causes a regression, even though it provides a generic batching
> > > framework in acomp.
> > >
> > > I was able to retrieve performance with the following change in acomp=
ress.c:
> >
> > Why add it to begin with in this case?
>
> Patch 3 ("crypto: acomp - Add trivial segmentation wrapper.") was
> co-developed with Herbert. The request chaining for non-segmentation
> algorithms was as in Herbert's original implementation. Since this
> causes a regression, I would like to get Herbert's Ok on replacing the
> request chaining in this part of crypto_acomp_compress().

I mean, why add patch 8 if it doesn't improve performance? Seems like
even with your diff, we only recover performance, but we don't improve
it after patch 6?
