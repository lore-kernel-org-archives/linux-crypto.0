Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C45AE3D5244
	for <linux-crypto@vger.kernel.org>; Sat, 17 Oct 2026 03:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792209226; cv=pass; b=sAzpZWesL0v08iVdwWvc9EiEYceykPERwsbBGpP4VMEgATVkoztdMdOsE7uBuxG00oldH8CjViKJryB6nGEozygreOFvS3neQ941ukHRiwNuZPkT0fLS5M1dGTWazRUvK1OYIyFqTXQucvBT8+o4jvMBSc7nthS17D2X5dKKWjs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792209226; c=relaxed/simple;
	bh=H0kJa2+j+UqUqwrq/WWDGpia51mM82qVdeIzkYkhygg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=i7tuOAB8iUt7Crz5oKLq4xYO6mbKFor8HEJXp/0F4Bdg+0OfdBM+7YbGJGLcmSY+bDUS5vpz5XlbV3gGqoq+6z/uaWXB8O2+uY98s92zti93ETUvfSck6+w7YnQAOz/sWKC0yTRG/6lszVj14h94sC61AdrY6004eo+Qwk1r1ng=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=muV6RQUy; arc=pass smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="muV6RQUy"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5be3cff0f6cso368238e87.0
        for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 20:53:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792209219; cv=none;
        d=google.com; s=arc-20260327;
        b=pDMvbty4tt/XtUMQpi2fv8NQ5KvQza6MBQU+Ix/ZBCn/3bEFUFXaBxINMoL06WSNro
         SxdYPLpSv/ifdVr72hmMBIgKOz+5Ben6ymJfe6uQZqZK1K5pZcKNePiWLIw7aTPLWK8z
         dgZYXlbYCFwVetniNAof6Pox7CwTlnPxT35bCBH7446o04OFqCKvMpTTbk+s/o4kpHzp
         w/JCWjEd+jTCt6z+2bvOU8zSCkGSxkMkhK0btpG37eVLW9sl6rG9/piaYhtWxHaQ6d23
         fJvrZQ1VdsTTZm/cppiEoFbs9OYCjMc0TW6El1AW4RyF2gL12+XPvR+64cNGdQMF0+mv
         ya8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=c0xww6zOl66Izqr/6HsQKYJXypZK9pMb27w+but6MD0=;
        fh=LrBrvMTK+ZPBW4U4JuXvi1+q3hDoF+9TzXQS7VzaZiY=;
        b=OfRcc51A0CT/bWwXNzCoJJCarGswtUIMymtOlwl1iTlHnGh+7gpEtwSCeCApmMNvmP
         Q2/HY48Bo1erEzO+VD4HUCbjMxMkU0LzeGD72kBwm/tZ3HixMrNY5aYDC7f2Zy9X9+Kz
         XHSUfNyytrvYRAl6w5e5s2JlRdjXL7g6XXsWPUGznn+uXzDw1eUUMUdsR9Y5Mt0YJGQ1
         p61TwYFeZbtWef8XIZq9wLXguMcR1OknaaPufKDNFuiA8ExaB+e5Ok3/mtlqrbiOZXLc
         b0uYb4cRlxl/pD6ZY+kucbpS0VpCl3lPq5LZ5P1RcjhLPyYLBIIbsVVBoUvyZLEnmGt6
         y0VA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792209219; x=1792814019; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=c0xww6zOl66Izqr/6HsQKYJXypZK9pMb27w+but6MD0=;
        b=muV6RQUyhdCST2VnHWDjaQD/tPf3fzHfiYTBPR1cUphdKFcNwtpDMVf8GWTqXYMyzY
         NQ1tSidNJWNSgrum53BRkvI8tbiH8s0s4WxFvJOsfDuBqt673OBeQGAF3GoW1yRRP49h
         hQchXkBy7kSXxD84gDZOunvEZjTDzH5r5Ibv/x/85kVs1U69HrP3+6e2wGDzsz5JAHCd
         ncAFxHzBDJ+bKwt4Sjz+0Zzkme2f0d6voFHDhRXMp3Tw13NuMQ/TihleRt5pzh1SOL+2
         LFwJzG2OeaJRLxKqxUf73lu5kuW0U5m8NIQ/4VFxl0g2y5PjuEi5nCuNCEhuzBzcw5Qw
         uDXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792209219; x=1792814019;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=c0xww6zOl66Izqr/6HsQKYJXypZK9pMb27w+but6MD0=;
        b=aI0tLmmRkewpxrnKp7H/JqQHbMBDtLHNx9DkopAoRm/KbFqWz1Q6sdxOhUYIxQ4MZh
         aZw3D4Kh3C6EYoUfX4u0MNNBvgEFBdIJmkr9sIxGqQQohNXLMOsNCchZQAIATmjdWZab
         3DDEGUmATJ1KYyPv2ITccpaOqpojeFTgM5JBKb8nZwxwKNZwh1RCsCCVMLG4naDpaq35
         FYB5XcvYteBut5VbrVkEDfTago8mCRYX9Y0sT4JovKMhl7mW2SnRThbjCcc+kCdo4ZYj
         P36uY15C4y+LWGcldddBabTlxI/48Jo5LCZaeGmpejr+t19KORZjVp1nednjZXdE4sZl
         dv1A==
X-Forwarded-Encrypted: i=1; AKwUvBy5BqpkFigr+fo3ZtrVbIkTuVxOafqs7eH6vnbX92hbv3tx5Q8049lwWOZpQw/ur6i8r3esttiCy8acj5E=@vger.kernel.org
X-Gm-Message-State: AFq9FYKc9KBAIuZ2Wzokk0i8Y8DT595yBU9SbBKqf3rYf4f1kZSaQxO4
	3JofrDnsbMGS94EsFI2igOP8kjCSBoccnWb5L+OnCEyqXPJ/L6lJdSDYPq+pL+eCByV8EHah9Og
	VVc4oMGWYRBKlFNSM/3pL9fDLknCbEWc=
X-Gm-Gg: AYBFou0Nr/R1ZgZvmlrCnK2Bcrj1NMR8OnYZrJFmDeeieXrV6TO4Rivw1L8qbMZYVlP
	S7Ey3+2RW2zbuPxxBinoUPXDiWHEBE1MZeNK3DkoP+DlGmn8Es/+YAAqXG2iH4iKZnUQZdgl3tY
	dlAnGHuxfagAZ9ydZJgi7fNfnqcI90xfFG1XMNwT5wRw8edvLWMg8HFAa2m8r1ohXchWtrP59e4
	UljXWK7vo2y238L2I69h0TtMhT1NaeUm0aDaVhQIrOLQ8nMIRSi91FRtK9u8z2LqxD/xc5A4C2L
	PERu9mA7TkQY82obhkf9SzJpzk8UK/0htnuE90Mk2A2ad8dgRAKlcoY=
X-Received: by 2002:a05:6512:3993:b0:5be:5220:3db2 with SMTP id
 2adb3069b0e04-5be52203f96mr217853e87.26.1792209219390; Fri, 16 Oct 2026
 20:53:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
 <CAO9r8zOHtaeo5jhHkHB8Vtb9+KZXO+DH74v+7Y84W0v=tatRqg@mail.gmail.com>
 <CACpmpofN-JfCgJtW9D0wNu0_pL1pRWGfNphUQnE9Bse-P5tHpQ@mail.gmail.com> <CAO9r8zO+0h3LLuaFGi6RF02sBYrG71Zf9qMei73UPvRi2onGxg@mail.gmail.com>
In-Reply-To: <CAO9r8zO+0h3LLuaFGi6RF02sBYrG71Zf9qMei73UPvRi2onGxg@mail.gmail.com>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Fri, 16 Oct 2026 20:53:26 -0700
X-Gm-Features: AclHuK9PwGYFMZLK4QolgvssL7tX2S8kM-FVLNspgBd1JKDsPP-LcKfChdsn8JU
Message-ID: <CACpmpoe+krnso-b1h_g_Q=HzV5x8xpu=Ke9==+4PfWF0ZcAUgQ@mail.gmail.com>
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

On Fri, Oct 16, 2026 at 2:48=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> On Fri, Oct 16, 2026 at 12:05=E2=80=AFPM Kanchana P. Sridhar
> <kanchanapsridhar2026@gmail.com> wrote:
> >
> > On Fri, Oct 16, 2026 at 9:14=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> =
wrote:
> > >
> > > On Thu, Oct 8, 2026 at 11:28=E2=80=AFAM Kanchana P. Sridhar
> > > <kanchanapsridhar2026@gmail.com> wrote:
> > > >
> > > > v1: Batched zswap_store() with compression batching
> > > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
> > > >
> > > > This series is a spin-off of "v14: zswap compression batching with =
optimized
> > > > iaa_crypto driver" [1], and focuses on the generic crypto_acomp and=
 zswap
> > > > compression batching enablers. Resuming work on this series followi=
ng a gap
> > > > since v14 (January 2026). Please note that my email address and aff=
iliation have
> > > > changed from kanchana.p.sridhar@intel.com to kanchanapsridhar2026@g=
mail.com. I
> > > > have retained the original Intel sign-offs on prior patches for his=
torical
> > > > attribution while signing off v1 of this series with my current add=
ress.
> > > >
> > > > To summarize the main contribution of this patch series: Batching i=
s introduced
> > > > in zswap_store() of large folios: we carve out a large folio into b=
atches of
> > > > ZSWAP_MAX_BATCH_SIZE (8 pages) for software compressors, and store =
each
> > > > batch. Moving the fundamental operations that need to be happen to =
store a page
> > > > to now work at the granularity of a batch offers opportunities to o=
ptimize them
> > > > from these perspectives:
> > > >
> > > > 1) Utilize existing kernel API that minimize obtaining locks for bu=
lk
> > > >    operations, e.g. kmem_cache_alloc_bulk()/kmem_cache_free_bulk().
> > > >
> > > > 2) We keep the working set for each of the core store functionaliti=
es (alloc
> > > >    entries, compress pages, store pages in zsmalloc) to be focused =
on a
> > > >    batch, thereby minimizing cache evictions and benefiting from ca=
che
> > > >    locality.
> > > >
> > > > 3) Along the lines of (1), the main zswap_compress() batching routi=
ne obtains
> > > >    the acomp_ctx mutex lock once per batch, and releases it after i=
t has
> > > >    processed all pages in that batch.
> > > >
> > > > 4) Any zswap store functionality that works on a batch can potentia=
lly be
> > > >    parallelized as a next step, to further improve performance.
> > > >
> > > > Performance data: usemem with 60% over-commit:
> > > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > > Validation was done with mm-unstable as of 10-3-2026 (Baseline) and=
 with this
> > > > patch series.
> > > >
> > > > Testing was done on a Chromebook with a QEMU "vng" VM running in Cr=
ostini.
> > > >
> > > > Chromebook Diagnostics reports:
> > > >   Intel(R) Core(TM) Ultra 5 115U (10 CPUs, 4.200GHz)
> > > >   RAM: 16GB
> > > >
> > > > vng setup:
> > > >          Memory: 7G
> > > >            Swap: 3G
> > > >     Pinned CPUs: 4 (E-Cores: 4,5,6,7)
> > > >
> > > > zswap compressor:
> > > >   ZSTD
> > > >
> > > > mTHP enabled:
> > > >   64kB
> > > >
> > > > vm-scalability/usemem setup:
> > > >
> > > >   cgroup memory.high: 3G
> > > >   4 usemem processes, each allocates 1200M anonymous memory, reads =
the
> > > >   Silesia dataset [2] from a pre-fork-allocated buffer into the 120=
0M,
> > > >   writes to each unsigned long in the 1200M, sleeps for 10 sec, the=
n
> > > >   frees the memory and exits.
> > > >
> > > >     usemem --read-silesia -w -O -b 1 -s 10 -n 4 1200M
> > >
> > > What is --read-silesia? Is this a local change you made to usemem?
> >
> > Yes, this is a local change I made because I wanted to get compressed
> > lengths besides 565, which is the only compressed length of data
> > swapped out from the original usemem.
> >
> > To replicate my setup:
>
> Thanks for sharing the details. I am having trouble reproducing the
> results, mainly because the standard deviation seems to be too high to
> make conclusions. What is the standard deviation in your runs?

Sure thing! Let me know if it would be useful to upstream the
--read-silesia option to the vm-scalability tree.

Yes, standard deviation is considerable, which is why I run usemem
consecutively for 10 iterations and report the mean Average
throughput. I could also report the median going forward if that
helps. The cover letter vmstats are after 10 iterations. The last set
of data I reported in this thread after applying patch 8 [batched
version of zswap_compress()], had a mean of 20,946 KB/s, standard
deviation of 5,391 KB/s and median of 22,477 KB/s. For reference, the
stddev for the baseline mm-unstable was 5,397 KB/s.

I have found this methodology to be reliable in drawing conclusions
because as zswap_store() performance improves, the outliers are fewer
and the data is more clustered near the mean.

>
> Also, I tried measuring the latency of zswap_store() itself through
> bpftrace, and it doesn't seem to change much throughout the series.

I ran bpftrace today to gather zswap_compress() latency per-page,
before and after patch 8. It shows a clear performance improvement
with compress batching for the reasons mentioned before:

Sequential_zswap_compress  nr_samples     p25     p50      p75
p95       p99
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
zswap_compress_ns_per_page  1,722,489  43,947  57,791   88,489
130,165   323,961

Batched_zswap_compress     nr_samples     p25     p50      p75
p95       p99
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
zswap_compress_ns_per_page    339,088  42,081  52,633   63,185
118,461   191,710
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
 Latency saving (ns)                   -1,866  -5,159  -25,305
-11,704  -132,251
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D

Hope this helps. Thanks!
