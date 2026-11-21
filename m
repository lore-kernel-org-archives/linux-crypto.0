Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.50
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795223846;
	b=olgc2zDf1wV9qRLct6KZdSknT6JMRV3b34xmpihCmkazv5FJP0ODthtjI+X6cUh7eXoe
	 XJ7w+6RrJvoCVigC9AalCVYdsdsEKyNiHz2BFonqO0blFNcIYqZoGVmMiK6+cj4BAtfQH
	 ZIqkg3a5RCebH841AVuGzhh1sWDNHPeplvLTkeETzAEFTuiXaZgoHRRs0gHuCc7ca/YVz
	 LU5oPmr+3iPia8XFspHxuT2trBEr+juncmms8/KCouDcJOzk7X2Uc0l20MFztR93zalEx
	 C5LxSa8FY81NZf4i03Hc5HmihtTaSbkWi3+oKwftFII5LUyDrDY4P8jgBnzHh8HLrNQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795223846;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=mGnZnNMNCIiU9GWu4BB4l5Z8uGC7kV9EeATLQ3n2YC0=;
	b=Crrgsdjlta8EZWpINpx2YvwM7EUiR4rkTo/dzMcj6zWQqyU0X3tUrMrMNl01G9WrSReq
	 u+EIse6E8KPl+pvgGlASHCZyYhNAWjp7h6lPbGT+3fAmL7JY8icGSaUcmdnxMrz7fXtGo
	 VGoF9V0EcXXD07SlqkE1SJGxTk3UUTDmcCR2bMVBUouxJE8Z8sgYa9dQj4rbq2+U+YjKy
	 z3WgtnJMVK08pHIXnIWp6K0+tCjmraYDQ+aqsi6Yj8CDvQAW1GFPwjEdMR1NoPlVEaoSx
	 FXGAiAnwPBjb7Nl3BFFpOL1wC63YrVWxjk543RjmatAeS3kfV8ddLqZRxjO9ibtz5kw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=fZoZY0aF;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.50
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCA91606A687
	for <linux-crypto@vger.kernel.org>; Sat, 21 Nov 2026 01:17:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CCA91606A687
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=fZoZY0aF
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5c1593fd141so1219496e87.0
        for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 17:17:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795223843; cv=none;
        d=google.com; s=arc-20260327;
        b=YywHo6EY9c10pd6mq638LIIdVSYeT+V/q0Jno6bqz455MAyknHpKfWrvxBAf+3cYH9
         +loer+qmzrW5mG2L3j/6lKgxYEDuTfT3gwkADEnfRAbPw/JiGS7D28MT3FbPZGvuDUjX
         bUrdcrCuup89U6ZIt7Ai37wR87W+XZZpYzjLvkwAis6RV6qRnwLVMsk8Lli6HEtMmZTH
         lZkXR8pAdswAlWYc3FgENONfwmvIgoQum/EY9y0jQKZeCF2kyCjoCs/krBZcgb9Pj5UH
         Nelri3R4rnOHyFLzM7PZyxqd3FPgNo4Qrs+V/0PgCppgLDxuC2/Xv238fz4edc4YS8QU
         Nr8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mGnZnNMNCIiU9GWu4BB4l5Z8uGC7kV9EeATLQ3n2YC0=;
        fh=FLCF6QfnxdiFWPyaqZZ1Wr6iAsZg6M1GveRV+i87CYU=;
        b=az2FASuCGPGUE9zOoFYKEyb/RIZCpBK+6UyaHldJNNQ8bs0Z3DzJeXmUwfWkdcmsa9
         rF7xGPun0XnKZTKOGpFXYrDEAI/Cb4CZicVZgR365mNcS02lUbmJlkOi3VgfV17lbloo
         mv8wOa9SYkohaUVvldL5AJedCXQMQMIcuzwCY8P4lp2Z8pe3vNcqLFEjLFzB3WspwXM5
         vT7iCtWGFAWkb7rrL7T6JuYj+Mv+VCvDiblFYJPR2lwjUjcupChc5Htfc9cvU7dwmBzr
         UoSsk9VZj+iy4AN1pUYsId6i+sX/4cpoE3prk+9IvPCQOkS3TUViHJlrnurVUFXCzP+X
         ZUFA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795223843; x=1795828643; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mGnZnNMNCIiU9GWu4BB4l5Z8uGC7kV9EeATLQ3n2YC0=;
        b=fZoZY0aF8FpmsxDkSBq6b3EJXwiSOkkha0hOvrqqAXYFNDBvaBYyzp9kb4lUcaVV+o
         bflX/tw83cVQCSo6rlcchoOE+s0Js0wTHr1JKH6KPS9dXE0eEgJqVTSzpqEIbIxbzYho
         uPdCl+YTCHPruqkDO/AaHqZuNalDwReW57OiELZrgWXac+QF3NLITyjWGhbKEShR6l9c
         xRZzn1k1pTIp94AqUghJfOPvI6Y9ZCNadbYhcgUTPO6Y0tiBa/XsIprlOV81ibp64QKe
         V8LvzXwqbBWnxEky3xlBMelmtoTeM6KftNhbotEmrywM5mH69V+/NON8LS94LtVUaZoJ
         OoVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795223843; x=1795828643;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mGnZnNMNCIiU9GWu4BB4l5Z8uGC7kV9EeATLQ3n2YC0=;
        b=Lzsz7VvMq4CBtAN+TlcnyYWXSf1YCFnAPvPrzpi4LL+Q1Xmt7hXQ1TlUFBSouVMhyR
         A2j1I/XiaQ6GcyXcfPESxYPTiEuO59ISeX5sTqTqtVtAr8vyq8qqnEkS6aK0OyEtW7Mf
         C5/gpDUjScCveca88QoXl2dRI69cFInPVRt/KrywUUUXjagsHYekUor3jcZmROHJQFB+
         ui2KbA8F2lL8AFWYtrDObjZCZd+fCxls/V3n6DsGkm7kQ5LE8tdJ4kT4Y2koTbCTc+R8
         /89r3MtP+ch3tSB5WgK6Sb9Pxn599Fz1xm3DvmKnf+tdsJh7hH70gpdbNW7yggnPkwbo
         YhMw==
X-Forwarded-Encrypted: i=1; AL+hErHBbluO2pWRG9OyECFgwco3KbQskOwY3HN2NtT8+iNMY+fOyhBe7jNBfL6eq01ssHrXYSqRo5W7teKZEnk=@vger.kernel.org
X-Gm-Message-State: APuU4Z/AcUq4bNGm954UVBhPedo0bTM/F9SoioR5408dbmq/gwG3hUoc
	u0prcegYzxtbxa6jhGMZAeDJ9i7QXMlezRHIltFjnxt2HLM1ZR0jNTsVlntXSaA2t2YDfcn9s/t
	YnP5/0odGm99pmTXCLtHRzlecbfVmAvY=
X-Gm-Gg: AZFdTZdZBzw67/wDBxsr93T+MErY3oqAH7jrRVwQi4lFry1AdZKlYF64Ja5Kibs9i6k
	XhLZgsV3dZDtjODWSJXctDfCtvISjzY5EAbw2efZziUYgeRsB05b507p6AkM24dk5p/REA5MZ6r
	Goa6AvSTX7IRTNNQMMCTB3MvycLamU2kIBAbIUutDEvuMLr2YGrcC5KtkiLygkcoHWSfhxdBvmr
	r51uA53foa6pfmY6AUPSMvzQFpNLtfiEJkPqVQC7cEDmUozuQt8ErhtvNcSKQsBHRa/6Li38Cw9
	uOnP2cDCwDOX5zZAzL6gNr/kiOPSpKLZL4FxXQMS4SWyMRs0gM0X6wP12hMLdh18bOc82FT7+Zp
	K3LmkpaJ1/flW8JSK4Qf82GDHvHE2Y5blJr3d
X-Received: by 2002:a05:6512:6c5:b0:5b8:f8f9:e080 with SMTP id
 2adb3069b0e04-5c1bc81a0f2mr1379733e87.26.1795223842532; Fri, 20 Nov 2026
 17:17:22 -0800 (PST)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261120041906.5785-1-kanchanapsridhar2026@gmail.com>
 <20261120041906.5785-9-kanchanapsridhar2026@gmail.com> <CAKEwX=NtUEd7+Q2rW79LtObnjHT5uNFAUKfkRJJN1Wppe4Yc6g@mail.gmail.com>
In-Reply-To: <CAKEwX=NtUEd7+Q2rW79LtObnjHT5uNFAUKfkRJJN1Wppe4Yc6g@mail.gmail.com>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Fri, 20 Nov 2026 17:17:10 -0800
X-Gm-Features: Aa3M54qTioA-uvYuqL3pwqS8hRRk8H_IfZ4BDPWiMg2Jv1Vi1ZkTfN49GVC8gps
Message-ID: <CACpmpoe1SHgWQJaef-Je6x26FKYFAyV5xNs=krbWJQAYbG4rzA@mail.gmail.com>
Subject: Re: [PATCH v4 8/8] mm: zswap: Batched zswap_compress() for storing
 large folios in batches.
To: Nhat Pham <nphamcs@gmail.com>
Cc: hannes@cmpxchg.org, yosry@kernel.org, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 20, 2026 at 3:55=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> On Thu, Nov 19, 2026 at 8:19=E2=80=AFPM Kanchana P. Sridhar
> <kanchanapsridhar2026@gmail.com> wrote:
> >
> > A new batching implementation of zswap_compress() is provided for
> > compressors that do and do not support batching. This eliminates code
> > duplication and facilitates code maintainability with the introduction
> > of compress batching.
> >
> > The vectorized implementation of calling the earlier zswap_compress()
> > sequentially, one page at a time in zswap_store_pages(), is replaced
> > with this new version of zswap_compress() that accepts multiple pages t=
o
> > compress as a batch.
> >
> > When the crypto_acomp is used to set up the per-CPU acomp_ctx
> > during CPU onlining, the compressor's batch_size is obtained by calling=
:
> >
> >   crypto_acomp_batch_size(acomp_ctx->acomp)
> >
> > This is bounded by ZSWAP_MAX_BATCH_SIZE to limit the memory
> > overhead and to reflect the store batch constraint of max # of pages in
> > a batch. The clamped batch_size is stored in the per-CPU
> > acomp_ctx->comp.compr_batch_size.
> >
> > As noted in previous commits in this series, ZSWAP_MAX_BATCH_SIZE
> > per-CPU compression buffers are available for sequential and batching
> > compression algorithms.
> >
> > Regardless of compression batching, we always process large folios in
> > batches of ZSWAP_MAX_BATCH_SIZE.
> >
> > If the compressor does not support batching, each page in the batch is
> > compressed sequentially. For batching compressors, up to
> > acomp_ctx->comp.compr_batch_size pages in the batch are compressed per
> > call to crypto_acomp_compress(). The first phase of zswap_compress()
> > thus only calls crypto_acomp_compress() until all pages in the batch
> > have been compressed. When this finishes, the compressed buffers and
> > compressed lengths for the batch are available in the
> > acomp_ctx->comp.sg_table->sgl scatterlists.
> >
> > A new zswap_update_entries() then iterates through the (up to)
> > ZSWAP_MAX_BATCH_SIZE SG lists in acomp_ctx->comp.sg_table->sgl,
> > allocates zsmalloc memory and copies all compressed buffers to
> > the compressed pool. All existing functionality on zswap
> > writeback_enabled (or not) fallbacks under various error conditions
> > denoted by the crypto_acomp_compress() return value [and with this
> > commit, also stored in the individual acomp_ctx->comp.sg_table->sgl
> > sg->lengths in the crypto_acomp_compress() fast path], is essentially
> > preserved.
> >
> > A significant zswap architectural change is that the batched
> > zswap_compress() incorporates Herbert's suggestion for SG lists to
> > represent the batch's inputs/outputs to interface with the crypto API
> > [1].
> >
> > The introduction of zswap_update_entries() presents an opportunity to
> > optimize the task of storing a batch of compressed buffers. Subsequent
> > patch series will be submitted to optimize this phase by replacing
> > zsmalloc with the SLUB allocator to improve zswap_store()/zswap_load()
> > latencies.
> >
> > The batching framework introduced in this series improves zswap_store()
> > latency by a lot.
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
> >      - CoV (Variance): Coefficient of variation (relative standard
> >        deviation) measures spread relative to the mean rather than
> >        statistical variance.
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
> >
> > Detailed usemem30 benchmarking data:
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> >  1) 2048kB mTHP:
> >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> >  ------------------------------------------------------------------
> >  2048kB mTHP usemem30 benchmark suite: 10 runs (Limit: 150G).
> >  ------------------------------------------------------------------
> >                Baseline mm-unstable   v4 zswap compress batching
> >                               (sec)        (sec)
> >  ------------------------------------------------------------------
> >  [Run 1/10]  Sys Time:    1581.414s    1356.252s
> >  [Run 2/10]  Sys Time:    1642.874s    1478.929s
> >  [Run 3/10]  Sys Time:    1594.458s    1411.252s
> >  [Run 4/10]  Sys Time:    1580.988s    1380.959s
> >  [Run 5/10]  Sys Time:    1579.654s    1380.609s
> >  [Run 6/10]  Sys Time:    1627.765s    1345.582s
> >  [Run 7/10]  Sys Time:    1593.872s    1334.485s
> >  [Run 8/10]  Sys Time:    1623.189s    1405.471s
> >  [Run 9/10]  Sys Time:    1661.954s    1433.365s
> >  [Run 10/10] Sys Time:    1602.098s    1329.813s
> >  ------------------------------------------------------------------
> >
> >  ------------------------------------------------------------------
> >  METRIC: System CPU Time (Sys Time) : 2048kB mTHP
> >  ------------------------------------------------------------------
> >                Baseline mm-unstable   v4 zswap compress batching
> >                               (sec)            (sec)
> >  ------------------------------------------------------------------
> >  Total Samples    :              10               10
> >  Mean Value       :        1,608.83         1,385.67
> >  Std Deviation    :           28.67            47.47
> >  CoV (Variance)   :           1.78%            3.43%
> >  ------------------------------------------------------------------
> >  METRIC: Per-Process Throughput : 2048kB mTHP
> >  ------------------------------------------------------------------
> >                Baseline mm-unstable   v4 zswap compress batching
> >                              (KB/s)           (KB/s)
> >  ------------------------------------------------------------------
> >  Total Samples    :             300              300
> >  Mean Value       :         292,261          303,508
> >  Std Deviation    :          12,946           20,806
> >  CoV (Variance)   :           4.42%            6.86%
> >  ------------------------------------------------------------------
> >
> >  2) 1024kB mTHP:
> >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> >  ------------------------------------------------------------------
> >  1024kB mTHP usemem30 benchmark suite: 10 runs (Limit: 150G).
> >  ------------------------------------------------------------------
> >                Baseline mm-unstable   v4 zswap compress batching
> >                               (sec)        (sec)
> >  ------------------------------------------------------------------
> >  [Run 1/10]  Sys Time:    1567.639s    1594.696s
> >  [Run 2/10]  Sys Time:    1537.577s    1456.113s
> >  [Run 3/10]  Sys Time:    1538.562s    1521.887s
> >  [Run 4/10]  Sys Time:    1626.176s    1531.962s
> >  [Run 5/10]  Sys Time:    1593.955s    1528.733s
> >  [Run 6/10]  Sys Time:    1643.519s    1558.482s
> >  [Run 7/10]  Sys Time:    1510.613s    1480.177s
> >  [Run 8/10]  Sys Time:    1632.018s    1584.093s
> >  [Run 9/10]  Sys Time:    1569.424s    1528.915s
> >  [Run 10/10] Sys Time:    1552.747s    1570.451s
> >  ------------------------------------------------------------------
> >
> >  ------------------------------------------------------------------
> >  METRIC: System CPU Time (Sys Time) : 1024kB mTHP
> >  ------------------------------------------------------------------
> >                Baseline mm-unstable   v4 zswap compress batching
> >                               (sec)            (sec)
> >  ------------------------------------------------------------------
> >  Total Samples    :             10                10
> >  Mean Value       :       1,577.22          1,535.55
> >  Std Deviation    :          45.13             43.79
> >  CoV (Variance)   :          2.86%             2.85%
> >  ------------------------------------------------------------------
> >  METRIC: Per-Process Throughput : 1024kB mTHP
> >  ------------------------------------------------------------------
> >                Baseline mm-unstable   v4 zswap compress batching
> >                              (KB/s)           (KB/s)
> >  ------------------------------------------------------------------
> >  Total Samples    :            300               300
> >  Mean Value       :        289,904           291,114
> >  Std Deviation    :         15,385            14,553
> >  CoV (Variance)   :          5.31%             5.00%
> >  ------------------------------------------------------------------
> >
> >  3) 64kB mTHP:
> >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> >  ------------------------------------------------------------------
> >  64kB mTHP usemem30 benchmark suite: 10 runs (Limit: 150G).
> >  ------------------------------------------------------------------
> >                Baseline mm-unstable   v4 zswap compress batching
> >                               (sec)        (sec)
> >  ------------------------------------------------------------------
> >  [Run 1/10]  Sys Time:    1914.525s    1878.483s
> >  [Run 2/10]  Sys Time:    1869.412s    1863.177s
> >  [Run 3/10]  Sys Time:    1944.049s    1863.502s
> >  [Run 4/10]  Sys Time:    1942.757s    1900.144s
> >  [Run 5/10]  Sys Time:    1866.505s    1887.285s
> >  [Run 6/10]  Sys Time:    1877.716s    1861.668s
> >  [Run 7/10]  Sys Time:    1861.741s    1868.788s
> >  [Run 8/10]  Sys Time:    1904.735s    1816.372s
> >  [Run 9/10]  Sys Time:    1891.074s    1850.435s
> >  [Run 10/10] Sys Time:    1893.366s    1849.747s
> >  ------------------------------------------------------------------
> >
> >  ------------------------------------------------------------------
> >  METRIC: System CPU Time (Sys Time) : 64kB mTHP
> >  ------------------------------------------------------------------
> >                Baseline mm-unstable   v4 zswap compress batching
> >                               (sec)            (sec)
> >  ------------------------------------------------------------------
> >  Total Samples    :              10               10
> >  Mean Value       :        1,896.59         1,863.96
> >  Std Deviation    :           29.86            22.96
> >  CoV (Variance)   :           1.57%            1.23%
> >  ------------------------------------------------------------------
> >  METRIC: Per-Process Throughput : 64kB mTHP
> >  ------------------------------------------------------------------
> >                Baseline mm-unstable   v4 zswap compress batching
> >                              (KB/s)           (KB/s)
> >  ------------------------------------------------------------------
> >  Total Samples    :            300               300
> >  Mean Value       :        239,114           242,254
> >  Std Deviation    :          9,090             6,419
> >  CoV (Variance)   :          3.80%             2.65%
> >  ------------------------------------------------------------------
>
> The numbers look nice, but what's the zswap setup here? What's the
> compressor? And how much of the win comes from this patch v.s the last
> patch?
>
> This patch series, and this patch in particular, seem like a lot of
> complexity. I'd like to understand better the win before adding all
> this complexity to the codebase.

Hi Nhat,

ZSTD is the zswap compressor. My apologies for forgetting to mention
this in the performance testing section.

All reclaim and zswap parameters are the defaults in the kernel build
(I also configure ZSTD as my default zswap compressor when I build the
kernel):

vm.swappiness =3D 60
/sys/module/zswap/parameters/max_pool_percent: 20
/sys/module/zswap/parameters/shrinker_enabled: N

/sys/kernel/mm/transparent_hugepage/hugepages-2048kB/enabled: [always]
inherit madvise never
/sys/kernel/mm/transparent_hugepage/enabled: [always] madvise never
/sys/kernel/mm/transparent_hugepage/defrag: always defer defer+madvise
[madvise] never

I just shared my analysis based on bpftrace data in response to your
cover letter comments, to try and explain the wins with zswap store
batching alone (patches 6-7) and then with zswap compress batching
(patch 8). Please do let me know if you have follow-up
questions/comments.

I will also gather and post usemem30 numbers before/after patch 8.

Thanks,
Kanchana
