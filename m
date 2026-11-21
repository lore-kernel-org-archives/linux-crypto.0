Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.48
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795223101;
	b=BBwz3C2g6YdbWNhBlRfWgJKMkqDwx2FdAOZeW05Ud7XmKk5gDhIJfUtXUbOyILdztyj9
	 gAhQfBGtELM16n7+wTY9O1WngWqupCEItFTgWJNeH7xlZT+qVk14+tHuOD2QXh1cl6SJJ
	 8m4Xh9ecUhQiRvO15KeeQUJQcMG7rnilfCJlPX/XiJ/UgHlxXRBqF+ueJNcl6K+R613QO
	 ltSJ74Gqbz+1ANOjDLMMu6y6puYuIHFPHn3bHDUd8xrI5SYWkLmKpQq3bC9bUWY3Yg24+
	 41V9DGtIdA02bptqvNo/NMb8tx9n1Kaq1vdkYOVRJzHvvT4JxStnmJNht2ukGBelMnw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795223101;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=Eh52j9Q/RVKuR5bJt/KT+uWkjFJZmV3tU4pEpDhX5T0=;
	b=bnH0vxCnjT7facSiwQ4JxdGG8mCJL18MyKl6P9MJzaXFLrFOPdzzprOf/SJePilF4Cv7
	 hsL1dfFBO+je0XOdliQpAWgTcoBmCwF5TA3ei3xdXjo5LEWsQUXXBSNmVk0Mv1TdqB5R9
	 xKDCFjKee0YtiXNu4g0pQtZVottvVAzkG6PdCsm6dUCtmwF0c7iCTWJFiWx9ak7QLoTDK
	 IF1voL3+VWQ0MZ6EKaEfA6JqHzXo06nc9/oAnpiF2jewV6246/0M6nINOeVQxkSdoLPxq
	 u52tryXr0ONsz3kVOqqpaWjeTtBIxm4JXnqVx6SeIjkZTU0xhCF0j/uJQK50VGZEy9w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=nX1qGARo;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.48
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D84BE606A6A8
	for <linux-crypto@vger.kernel.org>; Sat, 21 Nov 2026 01:04:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D84BE606A6A8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=nX1qGARo
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5c26207ee6eso42329e87.0
        for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 17:04:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795223098; cv=none;
        d=google.com; s=arc-20260327;
        b=hvFEgXfdLB6GNFaJsIJdQyj925ywtPtJ5x1w09lVJSDnD7zZFsXd2G0Nm/ikCInsLz
         HFVVGVjFqHsPLeWkKvJldkID7PEve0RVT2NKdVi8VLpSeBRC9NLhLfxNs9jP8B1HlMmE
         Cu3lcQq0Qmz3VKgQ9wAzCzxDrWzAsOPUN0ySxFiYJvN5wDxxEL+95ZF4jvLh2jy/c+mb
         6HNDYU2dH5kNr1lgN80b6Q1J1FTRP6a1nRMge5NGiTxJFNi/vlhkMhqA4LGE68xJ3Y/0
         geXTp+W3K8uOrR/6vGGSVma0rD01nT2fC8q43v+geDJNMZ1k5LJXxn7huBtO8lfzbf0Z
         k5IQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Eh52j9Q/RVKuR5bJt/KT+uWkjFJZmV3tU4pEpDhX5T0=;
        fh=tZnWDMHYrmLiXgUPHKmpR4XewwCHeDrNi9wel/uRRx0=;
        b=l8hINCD6VBmJLcB9/nYUfsUaLeOyd7IZS61h22G70bmzqvGE+FsXYrzN9XgVPaO+FF
         Oj4424EEzG/5lGd1fgclu3hp/MtYHs+dvEVMd9Vf6hk3erWLRZvHvwYjmbNiC22rv4DF
         GGNQKSSFH63uBcAZmmbo6Fxcmkq6v5oBLvIl9nA69OmqdkHeRvtDyXGbxNgyC4tzhDCR
         urPbziGxDbuQcCyEzG/xaV0diWPlHfzFI6Ty2TTUM0ct2dv4F1+c7pX+LZqZTSAOpVRz
         1RcpNunOyOgTKe1FLlKU9+0q8rYGGW0lFXr+tQTg7fswckK2z1AywyCE0UTLMjKD8v+/
         MW5w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795223098; x=1795827898; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Eh52j9Q/RVKuR5bJt/KT+uWkjFJZmV3tU4pEpDhX5T0=;
        b=nX1qGARoljNW46hXPmrobIA/NLCUH2wH8NmxO2d7rF6qndwcPmRjfaSoUT1Fkthj3F
         SgWIIWi+iEMvCPUPVU2rfmt87/VF6UKP2pN/j7GxAqUfv2ccx2RJwhdMeYpYTGnDQ3VD
         Diz5a/tqcM4sNqnVXDHZ8vJE/PByScT2ShSpLHqLfNRaxWTzS8bSU////2mNIiQyBfEw
         a6NKwNLFtiUFlKXbsZoX6De1TPqpeP3mZKZTyaw5vg2s5mwssMbijvU2+2Zhw8Wg7cBm
         IIN+yIVhs/ZebeHUv/sFu1eXbrbNVSp6spos0e72iqfq+lq+OJjyFsWDFSDrLNineTi0
         5WxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795223098; x=1795827898;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Eh52j9Q/RVKuR5bJt/KT+uWkjFJZmV3tU4pEpDhX5T0=;
        b=IcL3tlxae5cG8NOK9wApKCqQj2QgGoLnseJCbdx2OeBTB9Z3euYE3Fan4aB4aMHjQu
         y3HbewLvARyBRMLUbHWFhChNKm5BZ4h30iYdWbMi1TYqIxV1yFjBXizLRP4gGmj++2ue
         W6xM0lXNAgjKjkFdDddv53fhezsC3fcdwytFVavWE6Of3UY6v3o4GHIeUw+ud/yOvYKv
         z2j9fHGik6+q6PdGQekKk4TawqZTx0R6BXdFkFlUi3EReOXMV0rH0m1M3aQGDAXKvjlF
         alt+4yjX3n8cFLwiiEpR/f5eRZY9PH43+/OSaMGfXk2rbFGJ9M2J+OcwCXuZ0Y8Iq2CA
         +7vQ==
X-Forwarded-Encrypted: i=1; AL+hErEE7IyaVXcXwyuKGuSAzSZGXi/4UA9r65jUGb1CGacIVMjINpwdWnbNMN7lj263v6XeGPryymeB9SLtV+o=@vger.kernel.org
X-Gm-Message-State: APuU4Z84etJQakpq1t2GCxusNnKLfS9nO0BVDu1DQyOGGbPOEuzX1rvy
	/Sg5lJuK95vA26o45upZWrmANmZtvg7bmyFVwSlzmxbQ4d3STL5MfS+8XRDgGqNqXKq6NuSWuiS
	l12uIVMbV0dxQY63exa2BC1VmMe+2VpU=
X-Gm-Gg: AZFdTZcONYHXqGb0cZMsKzzjey+/BNHPyjAC52epYL0hEDgiIk6C/dfB0sEy99eukLI
	jAX/1EGCPaKX6PYfqwD4idy2mWWRdW0mhWD33S1E4qHRKFqku3enSCApXwMHdIL/9MzmkS2ERCs
	93bojZDFQ+1Zifa4n6LPw1WjljjwuJ+w/zuiQ3alFhvf42Mis6DUh9ntl34MGMYENWDLb5kEHGH
	iTl6IPTMiB8PU6YPXzAWcndMHYoVVLfDoyIDD+tq0msn1kVKk6dR3Qtrpda3Jg2du76J2BPXB+T
	veEOjUf66HHrg3O12pxC7b2cyae5LSTIoUxutlPbGAH1zSLT8++k8R8NlHPi1czp6QdCGKVAQuU
	zMK82p4yhsGyIV7+Pv6tb75+JnAmbgUNBF487
X-Received: by 2002:a05:6512:3d24:b0:5c1:4c4b:6b68 with SMTP id
 2adb3069b0e04-5c1bc802f62mr1541232e87.31.1795223097637; Fri, 20 Nov 2026
 17:04:57 -0800 (PST)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261120041906.5785-1-kanchanapsridhar2026@gmail.com> <CAKEwX=MLrDn55wmVKKba5=PcU+qFpkEbMmN2SjGTfTBiFKX8cw@mail.gmail.com>
In-Reply-To: <CAKEwX=MLrDn55wmVKKba5=PcU+qFpkEbMmN2SjGTfTBiFKX8cw@mail.gmail.com>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Fri, 20 Nov 2026 17:04:45 -0800
X-Gm-Features: Aa3M54qT3ZtjD22EaLRJUtBbQryoUqmzjt-YjHsfdzKJaoAYzbDgBoEjNV0-lBI
Message-ID: <CACpmpod+crauW5g5fiU-2qg-GTg6roSi6j10Wg4cPR3qnni-PQ@mail.gmail.com>
Subject: Re: [PATCH v4 0/8] Batched zswap_store() framework with compression batching
To: Nhat Pham <nphamcs@gmail.com>
Cc: hannes@cmpxchg.org, yosry@kernel.org, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 20, 2026 at 3:16=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> On Thu, Nov 19, 2026 at 8:19=E2=80=AFPM Kanchana P. Sridhar
> <kanchanapsridhar2026@gmail.com> wrote:
> >
> >
> > v4: Batched zswap_store() framework with compression batching
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > This series is a spin-off of "v14: zswap compression batching with opti=
mized
> > iaa_crypto driver" [1], and focuses on the generic crypto_acomp and zsw=
ap
> > compression batching enablers. Resuming work on this series following a=
 gap
> > since v14 (January 2026). Please note that my email address and affilia=
tion have
> > changed from kanchana.p.sridhar@intel.com to kanchanapsridhar2026@gmail=
.com. I
> > have retained the original Intel sign-offs on prior patches for histori=
cal
> > attribution while signing off v4 of this series with my current address=
.
> >
> > The main focus of v4 was to establish a performance measurement methodo=
logy to
> > quantify the benefits to high level metrics by using zswap compression
> > batching. This was done using an Intel Sapphire Rapids bare-metal insta=
nce with
> > 48 physical cores and by running "usemem30", i.e., 30 concurrent usemem
> > processes, each of which allocates 10G, in a 150G memory.high contraine=
d cgroup,
> > for 10 iterations. The environment was set up to minimize performance j=
itter so
> > we can understand the system-level/workload-level advantages of zswap
> > compression batching when running workloads at scale.
> >
> > To summarize the main contribution of this patch series: Batching is in=
troduced
> > in zswap_store() of large folios: we carve out a large folio into batch=
es of
> > ZSWAP_MAX_BATCH_SIZE (4 pages) for software compressors, and store each
> > batch. Moving the fundamental operations that need to be happen to stor=
e a page
> > to now work at the granularity of a batch offers opportunities to optim=
ize them
> > from these perspectives:
> >
> > 1) Utilize existing kernel API that minimize obtaining locks for bulk
> >    operations, e.g. kmem_cache_alloc_bulk()/kmem_cache_free_bulk().
> >
> > 2) We keep the working set for each of the core store functionalities
> >    (alloc/initialize zswap entries, compress pages, store pages in zsma=
lloc,
> >    pool/objcg reference increments, objcg charging) to be focused on a
> >    batch, thereby minimizing cache evictions and benefiting from cache
> >    locality.
> >
> > 3) Along the lines of (1), the main zswap_compress() batching routine o=
btains
> >    the comp_ctx mutex lock once per batch, and releases it after it has
> >    processed all pages in that batch.
> >
> > 4) Any zswap store functionality that works on a batch can potentially =
be
> >    optimized via bulk-processing/parallelized as a next step, to furthe=
r improve
> >    performance.
> >
> > Performance testing: usemem30 with 100% over-commit:
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> > Validation was done with mm-unstable as of 11-17-2026 (Baseline: commit
> > 866f761fd414) and with this patch series.
> >
> > v4 was validated on an Intel Xeon Sapphire Rapids bare-metal instance w=
ith
> > 48 cores.
> >
> >  Bare-metal instance specs:
> >  --------------------------
> >  - 48 physical cores
> >  - 190G RAM
> >  - 200G SWAP disk partition
> >
> >  Workload: 30 concurrent usemem processes, each allocates 10G:
> >  -------------------------------------------------------------
> >  The vm-scalability "usemem" test (unmodified version) was run in a
> >  cgroup with memory.high fixed at 150G. There is no swap limit set for =
the
> >  cgroup.
> >
> >  To quantify the performance benefit of zswap compress batching at scal=
e,
> >  30 usemem processes were run ("usemem30"), each allocating and writing=
 10G of
> >  memory, and sleeping for 10 sec before exiting.
> >
> >   usemem -w -O -b 5 -s 10 -n 30 10g
> >   echo 0 > /sys/module/zswap/parameters/shrinker_enabled
> >
> >  Performance validation methodology:
> >  -----------------------------------
> >  These settings were used to minimize variation:
> >
> >  - All cores were fixed to run at 2.4GHz with "performance" scaling gov=
ernor.
> >  - Turbo boost was disabled.
> >  - CPU power-saving C-states restricted with:
> >
> >      GRUB_CMDLINE_LINUX_DEFAULT=3D"intel_idle.max_cstate=3D1 processor.=
max_cstate=3D1"
> >
> >  The usemem30 experiments were run with the baseline mm-unstable as of
> >  11-17-2026 (commit 866f761fd414) and with this patch-series.
> >
> >  After booting into each kernel:
> >
> >   1) Constrain the cgroup's memory.high to 150G.
> >
> >   2) Run 2 warm-up iterations of usemem30. Don't use this data for benc=
hmarking
> >      since sys time typically skews higher for initial runs.
> >
> >   3) Next, run 10 benchmarking iterations of usemem30:
> >      - Log these high-level metrics: Sys time and individual usemem thr=
oughput.
> >
> >   4) Sys time and Throughput metrics were gathered for three mTHP setti=
ngs:
> >
> >      - 2048kB
> >      - 1024kB
> >      - 64kB
> >
> >   5) Benchmark summary data includes Sys time and Throughput components=
 from the
> >      10 iterations of usemem30:
> >
> >      - Total Samples
> >      - Mean Value
> >      - Std Deviation
> >      - CoV (Variance): Coefficient of variation (relative standard devi=
ation)
> >        measures spread relative to the mean rather than statistical var=
iance.
> >
> >  An LLM was used to help generate the benchmarking and data processing =
scripts.
> >
> > usemem30 Benchmarking Summary:
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
> >
> >  ---------------------------------------------------
> >     Improvement with v4 zswap compress batching
> >  ---------------------------------------------------
> >   mTHP enabled:       2048kB     1024kB       64kB
> >  ---------------------------------------------------
> >       Sys time:      -13.87%     -2.64%     -1.72%
> >     Throughput:       +3.85%     +0.42%     +1.31%
> >  ---------------------------------------------------
>
> Have you tried perf-ing the store path to see what was the overhead
> source (before and after this optimization)? I'm curious.
>
> Mostly LGTM - still taking a look...

Thanks Nhat, for reviewing the code and providing valuable feedback!
Thanks also for your time.

Forgot to mention: ZSTD is the zswap compressor used. I will also
reply to your comment in the other email, along with more setup
details.
All zswap parameters (max pool percent, shrinker) are defaults.

I did analyze the performance of the store path using bpftrace to
understand what was the overhead source before and after this
optimization. My experiments used PMD folios to maximize the zswap
store/compress batching samples so the traces are helpful in
understanding how the optimizations are eliminating overhead.
Although, this was done with v3 and my earlier, memory constrained
QEMU setup running on Chromebook/Crostini.

These are the bpftrace p50/p95/p99 latencies. The labels mean:

 "zswap_store_higher_order_folio":
    zswap_store() of PMD folios.

 "zswap_store_order0_folio":
    zswap_store() of order-0 folios.

 "zswap_batch_compress_per_page":
    zswap_compress() per-page latency of store batches generated from PMD
    folios.

 "zswap_single_compress_per_page":
    zswap_compress() per-page latency of order-0 folios.

 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
   usemem PMD THP BPFTRACE
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
           Baseline           zswap           zswap          Change    Chan=
ge
        mm-unstable           store        compress            with      wi=
th
         10-25-2026        batching        batching        compress  compre=
ss
                        (patch 6-7)       (patch 8)        batching  batchi=
ng
                                                               (ns)       %
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
  zswap_store_order0_folio (ns):
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
  p50        39,631          37,538          37,765          -1,866    -4.7=
1%
  p95        53,088          49,690          49,349          -3,739    -7.0=
4%
  p99        65,065          63,529          57,404          -7,661   -11.7=
7%
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
  zswap_store_higher_order_folio (ns):
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
  p50    21,460,366      21,201,411      20,383,233      -1,077,133    -5.0=
2%
  p95    25,975,341      27,558,253      25,045,350        -929,991    -3.5=
8%
  p99    29,538,493      61,926,648      27,184,835      -2,353,658    -7.9=
7%
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
  zswap_single_compress_per_page (ns):
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
  p50        37,545          39,320          37,218            -327    -0.8=
7%
  p95        51,549          66,503          51,481             -68    -0.1=
3%
  p99        89,866         134,854          87,091          -2,775    -3.0=
9%
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
  zswap_batch_compress_per_page (ns):
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
  p50                                        40,493           2,948     7.8=
5%
  p95                                        56,944           5,395    10.4=
7%
  p99                                        76,242         -13,624   -15.1=
6%
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D

Analysis:
=3D=3D=3D=3D=3D=3D=3D=3D=3D

 The batching of zswap_store() phases, and compress batching
optimizations benefit zswap_store() and zswap_compress_per_page()
median and tail latencies
 for PMD folios and base 4K folios. The benefits are attributable
firstly to the store batching framework added in patches 6-7, that is
fully utilized to improve
 zswap_compress() latency by giving it a batch of pages to be compressed.

Gains seen from store batching alone (patches 6-7) are due to:

1) Bulk allocating the zswap entries for the batch,
2) Minimizing computes by getting the wb_enabled once per PMD folio,
rather than per-page,
3) Fewer function calls: zswap_store_pages() called once every 4
pages, rather than per-page.

Furthermore, the batch compression added in patch 8 improves latency
significantly, even more than that obtained by store batching alone,
for these reasons:

The overall approach for making the zswap_store() code more efficient, has =
been:

a) Minimize computes, especially conditionals. For e.g. crypto API
that set things up for a batch, rather than for a page.
b) The working set is kept focused on batch-centric data pertaining to
a handful of operations on the batch, to minimize cache evictions and
benefit from cache locality.
c) Each block of compute in zswap_compress() is doing checks/state
changes for a batch, which I believe simplifies the architecture and
allows us to build further optimizations.

Specifically:

1) Per-CPU sg_table with ZSWAP_MAX_BATCH_SIZE scatterlists that are
statically mapped to compression dst buffers for that CPU, thereby
minimizing local SG lists initialization, and using compact new
crypto_acomp API introduced in patches 1-4 that set up an acomp_req's
src/dst to be SG lists.

2) Patch 6 allocates ZSWAP_MAX_BATCH_SIZE destination buffers in the
per-CPU acomp_ctx, for an added memory overhead of ~12 KB per-CPU.
However, it allows us to not have to immediately call zs_store() with
the compressed buffer, but instead continue to compress the next page.
I haven't quantified this with perf event counters, but my guess is
this minimizes cache evictions because we are focused on running a
focused set of computes on a specific data set.

3) A one-shot zswap_update_entries() does all the zsmalloc handle
allocation and copying for the batch.

4) Bulk accounting for the batch instead of per-page.

5) Single point error-handling in zswap_store_pages() to avoid
conditionals, so as to not wash away batching gains.

6) By making zswap_compress() more efficient, we are able to lock the
comp mutex per batch of ZSWAP_MAX_BATCH_SIZE (4) pages instead of
per-page.

7) Optimize most-likely-to-succeed fast paths, move conditionals and
error processing to less-likely code (which is also consolidated to a
single error handling label).

8) Don't proceed to next stage of batch processing until this stage is
successful for its specific functionality scope. This minimizes
computes by avoiding if-then-else checks per-page.

The bpftraces highlight exceptions in p50/p95 batch compress latencies
(normalized per-page), even though the p99 batch compress latency
improves by 15% over mm-unstable. Batch compress latency can be
optimized further in subsequent patches. The batching framework
established in this series allows us to make locking and
bulk-processing improvements in each stage of zswap_store().

Please feel free to share any additional insights you may have as you
review the code!

Thanks,
Kanchana
