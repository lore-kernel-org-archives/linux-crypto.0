Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20349447805
	for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 21:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792187317; cv=none; b=MRm/rK9k+462MPdo0BUCpP1wYSylt9wlWYaA1+RlkhoNdLk5PV17z5mGtQd2uFbMg+OmBxenUR11V48nKYudMeDbrblthRvjJYAK9W00jRUb037E517gGMQpyTVIvNU+QfR3OnH0/ATkqCFWqYJfm/yRC408ge54PKDEb8pLOmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792187317; c=relaxed/simple;
	bh=KI0lbA3taZSp/xfnZz8dan8dBH4/HQNH0lOer+P480U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=heSGD7wurTG8Cji1mL4lGXPs39OVdh4ytnHT8w50HOSFXAjY1DmQkaNiT37da96ZFld7dNbyf1b/7SY3l4Vpj5crh/DSosdrXMBSj1YMSqSrRxQaxyXteFnGmGL1LDCqQM+lPYl6gFD9q9E7rtJMq2krKHYuyntLQT7fwBlBK7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LVuTTWsY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LVuTTWsY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99D4C1F000CA
	for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 21:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792187314;
	bh=ylh7TTsoBZmvoxuSRMyoR3bwQNz2SMz21EvQ30zmx9A=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=LVuTTWsYz6W76Thi1YXgOVaDYQM2FTrz/ArcFuNiQTA0ZvQEDAJNpG0BBWxa86LeD
	 LIkLjWb6G/CpviF/y/xZdhoRDWIe8lbPQaINDtJPy4VdxpGO4ZByUAhR2gLK5ipTjF
	 W74FyAZQ4sgzUkyu+2tVhebb/4ymzRPh7ywDEoGCDUMx8qfD6yDQSCVaZt3QEwviMI
	 FBVocAahARGfvkTUOOPujFfCGQ1mP03pJacvOiNL1CJEuqQn+86kY2jbKCdaf2NQAj
	 7knsfLzMWukW4TNSwbuD797GMNG7AcfsAWWbie4s5qP2LEToK9Xk2/nmJ9CJmxWNbe
	 9LvY+aEbOOIHA==
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c3ee49054ecso44604466b.3
        for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 14:48:34 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxthDn2Tqe4CYKqYC4EdghQhzfttChqtve2JWohtFP/aMuTDyD11Cq7GtPhAIyQBTZCCsZB007h8943n6g=@vger.kernel.org
X-Gm-Message-State: AFq9FYIkLZaSBRwCwKBZRMVz1keIiOHi7agX7e0JHHXu1q9Y1xZ1Q0/h
	9U4zC7qyHmgavjT8xcbgM5JRNZELeZq5drk/WhU7YKxxEmvA5W3qBpHA9TPne4iI8L0VD9V/fFP
	K8n9K0e2T2sBoEgcbyMj7rQqLoLJDyQE=
X-Received: by 2002:a17:907:868a:b0:c40:aa04:18d0 with SMTP id
 a640c23a62f3a-c419da41336mr78750666b.17.1792187313507; Fri, 16 Oct 2026
 14:48:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
 <CAO9r8zOHtaeo5jhHkHB8Vtb9+KZXO+DH74v+7Y84W0v=tatRqg@mail.gmail.com> <CACpmpofN-JfCgJtW9D0wNu0_pL1pRWGfNphUQnE9Bse-P5tHpQ@mail.gmail.com>
In-Reply-To: <CACpmpofN-JfCgJtW9D0wNu0_pL1pRWGfNphUQnE9Bse-P5tHpQ@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 16 Oct 2026 14:48:21 -0700
X-Gmail-Original-Message-ID: <CAO9r8zO+0h3LLuaFGi6RF02sBYrG71Zf9qMei73UPvRi2onGxg@mail.gmail.com>
X-Gm-Features: AclHuK_zAfaGRUrzaXzEs4qzNQZy6mar-GxIugKXPKJjvgPfBJdYRUyLH6KYsfc
Message-ID: <CAO9r8zO+0h3LLuaFGi6RF02sBYrG71Zf9qMei73UPvRi2onGxg@mail.gmail.com>
Subject: Re: [PATCH v1 0/8] Batched zswap_store() with compression batching
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 16, 2026 at 12:05=E2=80=AFPM Kanchana P. Sridhar
<kanchanapsridhar2026@gmail.com> wrote:
>
> On Fri, Oct 16, 2026 at 9:14=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wr=
ote:
> >
> > On Thu, Oct 8, 2026 at 11:28=E2=80=AFAM Kanchana P. Sridhar
> > <kanchanapsridhar2026@gmail.com> wrote:
> > >
> > > v1: Batched zswap_store() with compression batching
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
> > >
> > > This series is a spin-off of "v14: zswap compression batching with op=
timized
> > > iaa_crypto driver" [1], and focuses on the generic crypto_acomp and z=
swap
> > > compression batching enablers. Resuming work on this series following=
 a gap
> > > since v14 (January 2026). Please note that my email address and affil=
iation have
> > > changed from kanchana.p.sridhar@intel.com to kanchanapsridhar2026@gma=
il.com. I
> > > have retained the original Intel sign-offs on prior patches for histo=
rical
> > > attribution while signing off v1 of this series with my current addre=
ss.
> > >
> > > To summarize the main contribution of this patch series: Batching is =
introduced
> > > in zswap_store() of large folios: we carve out a large folio into bat=
ches of
> > > ZSWAP_MAX_BATCH_SIZE (8 pages) for software compressors, and store ea=
ch
> > > batch. Moving the fundamental operations that need to be happen to st=
ore a page
> > > to now work at the granularity of a batch offers opportunities to opt=
imize them
> > > from these perspectives:
> > >
> > > 1) Utilize existing kernel API that minimize obtaining locks for bulk
> > >    operations, e.g. kmem_cache_alloc_bulk()/kmem_cache_free_bulk().
> > >
> > > 2) We keep the working set for each of the core store functionalities=
 (alloc
> > >    entries, compress pages, store pages in zsmalloc) to be focused on=
 a
> > >    batch, thereby minimizing cache evictions and benefiting from cach=
e
> > >    locality.
> > >
> > > 3) Along the lines of (1), the main zswap_compress() batching routine=
 obtains
> > >    the acomp_ctx mutex lock once per batch, and releases it after it =
has
> > >    processed all pages in that batch.
> > >
> > > 4) Any zswap store functionality that works on a batch can potentiall=
y be
> > >    parallelized as a next step, to further improve performance.
> > >
> > > Performance data: usemem with 60% over-commit:
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > Validation was done with mm-unstable as of 10-3-2026 (Baseline) and w=
ith this
> > > patch series.
> > >
> > > Testing was done on a Chromebook with a QEMU "vng" VM running in Cros=
tini.
> > >
> > > Chromebook Diagnostics reports:
> > >   Intel(R) Core(TM) Ultra 5 115U (10 CPUs, 4.200GHz)
> > >   RAM: 16GB
> > >
> > > vng setup:
> > >          Memory: 7G
> > >            Swap: 3G
> > >     Pinned CPUs: 4 (E-Cores: 4,5,6,7)
> > >
> > > zswap compressor:
> > >   ZSTD
> > >
> > > mTHP enabled:
> > >   64kB
> > >
> > > vm-scalability/usemem setup:
> > >
> > >   cgroup memory.high: 3G
> > >   4 usemem processes, each allocates 1200M anonymous memory, reads th=
e
> > >   Silesia dataset [2] from a pre-fork-allocated buffer into the 1200M=
,
> > >   writes to each unsigned long in the 1200M, sleeps for 10 sec, then
> > >   frees the memory and exits.
> > >
> > >     usemem --read-silesia -w -O -b 1 -s 10 -n 4 1200M
> >
> > What is --read-silesia? Is this a local change you made to usemem?
>
> Yes, this is a local change I made because I wanted to get compressed
> lengths besides 565, which is the only compressed length of data
> swapped out from the original usemem.
>
> To replicate my setup:

Thanks for sharing the details. I am having trouble reproducing the
results, mainly because the standard deviation seems to be too high to
make conclusions. What is the standard deviation in your runs?

Also, I tried measuring the latency of zswap_store() itself through
bpftrace, and it doesn't seem to change much throughout the series.
