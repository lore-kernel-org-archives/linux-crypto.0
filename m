Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793301144;
	b=K9nm1qRZncO79738sNMuUAmh4bDsNsEdMyRhkVA6d/WJguZBbF4M+51oxWGCfIfx2FcX
	 lxAsYRzLITucY9oAYOgVRDge4OIQ8fmJvLD8eB89oxoA6+71k9lJzjAnk1B2LQ3j4ATU5
	 +hQltvFJ1JYsX1FQXDS8shTT90mFs5OM11KMLtV+5e/xHlR4oaC2LsXuZ5iH0fMznwboY
	 gjWTcc4NHFQaTzqaXiiZHn4l3kQ9M4HwYDhd51i8S/SBkxKzZB/+YGioIjnqVAPw80lo7
	 fLqJJIYRWpRtqK54hPqWOiYZrp3/m4j8ceJbxUbAQSJxN50VfUnpZfKvgCHqD0COeEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793301144;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=SnGkcBSoxO1qg6e+mIm2ZjnwnYuiHewsm9s9apLqRbE=;
	b=GiDATsceK5XI9MVed85gQcgA6xBZ0Ed9Vy8SGu4H0np3NoY78rVXPAEjTgoD96KWunvo
	 tsCsMFwBDVJedjdtk9T00pg7VwVx8NuBk/r84jjZmKxdo3/zfhEKPpO7Yetp1vHFwWqoH
	 MC6fHnbf4QbD11IAP2dMvIUXGljys9i80t+7Ki0iIbW2KQMD21kQdiUo/vCJ+2G+eOdiD
	 yC2bEJjsllnDXqI83l7zosa9kLBr+Sc7bSeTQ6Ojyn9kDFGQ3GXfEn7Dh9lNQmzlbNmSH
	 ww6cIEPxOJ791TxHbTpF8ZCGT4x8xEa+EsE+/P1LgCh4oyGJ4vyPyu0v0GkDP+2dkuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Rb3CYL53;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E673A606A31D;
	Thu, 29 Oct 2026 19:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Rb3CYL53
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDEFE1F01816;
	Thu, 29 Oct 2026 19:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793301143;
	bh=SnGkcBSoxO1qg6e+mIm2ZjnwnYuiHewsm9s9apLqRbE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Rb3CYL53RIcciYxSZiawLVDUdyakhf2hNs1VYKt0wlOXoHDN/B4rIwelSImNphBob
	 7A3ue5eWxrlxNEVWF/dVqlFZh5xIN2dIpM9m+ZKFk0AV5Ts2Y4rre6jTYMr1aXn8Bp
	 qRi66ltRFii7c8p0ry/J4045S+ndNFOF790670QA9tivmgcUEf601tGUqKgDvQxSke
	 iKlFGaW3vt1NE4TMe6YzSsC/OWt3kBlnAFazGbwB7gWruDhQiZc6Wk4Cdm/bR4/YXo
	 JTKhs/274CRnWfrbD706jxcYiuN/BHVR0py0Ku9L1p+WDfkUtqZtO9AR7QnOiZ6da9
	 yk6odrBEbNVvA==
Date: Thu, 29 Oct 2026 19:12:21 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	rientjes@google.com, willy@infradead.org, senozhatsky@chromium.org
Subject: Re: [PATCH v2 0/8] Batched zswap_store() framework with compression
 batching
Message-ID: <auOZBtRqQGzFcbAT@google.com>
References: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>

On Tue, Oct 27, 2026 at 08:04:55PM -0700, Kanchana P. Sridhar wrote:
> 
> v2: Batched zswap_store() framework with compression batching
> =============================================================
> 
> This series is a spin-off of "v14: zswap compression batching with optimized
> iaa_crypto driver" [1], and focuses on the generic crypto_acomp and zswap
> compression batching enablers. Resuming work on this series following a gap
> since v14 (January 2026). Please note that my email address and affiliation have
> changed from kanchana.p.sridhar@intel.com to kanchanapsridhar2026@gmail.com. I
> have retained the original Intel sign-offs on prior patches for historical
> attribution while signing off v2 of this series with my current address.
> 
> The main focus of v2 was to establish a reliable and accurate performance
> measurement methodology, that addressed the problems with variation in v1. This
> is accomplished and used to validate v2, by reducing usemem to 2 processes and
> enabling PMD THP. As the data shows, we get exactly the same "2048kB-zswpout"
> counts in the baseline and with this series.
> 
> To summarize the main contribution of this patch series: Batching is introduced
> in zswap_store() of large folios: we carve out a large folio into batches of
> ZSWAP_MAX_BATCH_SIZE (8 pages) for software compressors, and store each
> batch. Moving the fundamental operations that need to be happen to store a page
> to now work at the granularity of a batch offers opportunities to optimize them
> from these perspectives:
> 
> 1) Utilize existing kernel API that minimize obtaining locks for bulk
>    operations, e.g. kmem_cache_alloc_bulk()/kmem_cache_free_bulk().
> 
> 2) We keep the working set for each of the core store functionalities
>    (alloc/initialize zswap entries, compress pages, store pages in zsmalloc,
>    pool/objcg reference increments, objcg charging) to be focused on a
>    batch, thereby minimizing cache evictions and benefiting from cache
>    locality.
> 
> 3) Along the lines of (1), the main zswap_compress() batching routine obtains
>    the comp_ctx mutex lock once per batch, and releases it after it has
>    processed all pages in that batch.
> 
> 4) Any zswap store functionality that works on a batch can potentially be
>    optimized via bulk-processing/parallelized as a next step, to further improve
>    performance.
> 
> Performance data: usemem with 56% over-commit:
> ==============================================
> Validation was done with mm-unstable as of 10-25-2026 (Baseline) and with this
> patch series. To minimize variation in the data, I made these changes to my
> performance measurement methodology:
> 
> 1) Reduced the number of usemem processes to 2. Each process tried to allocate
>    2400M, in a 3G cgroup memory.high budget, effectively accomplishing a 56.25%
>    over-commit.
> 
> 2) Increased the runtime of the workload to ~9 minutes by enabling PMD THP,
>    i.e., 2048kB mTHP folios.
> 
> 3) The use of PMD THP forces zswap_store()/zswap_compress() latency to be in the
>    critical path, and thus enables very reliable measurements with bpftrace.
> 
> 4) I used lhist() instead of hist() in bpftrace to gather latencies at a finer
>    level of granularity and accuracy.
> 
> Testing was done on a Chromebook with a QEMU "vng" VM running in Crostini.
>     
> Chromebook Diagnostics reports:
>   Intel(R) Core(TM) Ultra 5 115U (10 CPUs, 4.200GHz)
>   RAM: 16GB
> 
> vng setup:
>          Memory: 7G
>            Swap: 3G
>     Pinned CPUs: 2 (E-Cores: 2,3)
> 
> zswap compressor:
>   ZSTD
> 
> mTHP enabled:
>   2048kB (PMD THP)
> 
> I used the help of an LLM to write the bpftrace data post-processing scripts
> that generate latency percentiles.
> 
> vm-scalability/usemem setup:
> 
>   cgroup memory.high: 3G
>   2 usemem processes, each allocates 2400M anonymous memory, reads the
>   Silesia dataset [2] from a pre-fork-allocated buffer into the 2400M,
>   writes to each unsigned long in the 2400M, sleeps for 10 sec, then
>   frees the memory and exits.
> 
>     usemem -w --read-silesia -O -b 1 -s 10 -n 2 2400M
> 
>  usemem metrics are reported from a single run after starting the QEMU VM.
>  Further, I have tabulated the bpftrace p50/p95/p99 latencies with these labels:
> 
>  "zswap_store_higher_order":
>     zswap_store() of PMD folios.
> 
>  "zswap_store_order_0":
>     zswap_store() of order-0 folios.
> 
>  "zswap_batch_compress_per_page":
>     zswap_compress() per-page latency of store batches generated from PMD
>     folios.
> 
>  "zswap_single_compress_per_page":
>     zswap_compress() per-page latency of order-0 folios.
> 
>  
>  ----------------------------------------------------------------------------
>  usemem                       Baseline      zswap        zswap   Change with
>  PMD THP                   mm-unstable      store     compress      compress
>                             10-25-2026   batching     batching      batching
>                                         (patch 6)    (patch 8)          %
>  ----------------------------------------------------------------------------
>  usemem process 1                6,353      7,240        7,428
>   Throughput (KB/s)
> 
>  usemem process 2                6,352      7,236        7,422   
>   Throughput (KB/s)
> 
>  Average Throughput (KB/s)       6,353      7,238        7,425        17%
>  ----------------------------------------------------------------------------
>  usemem process 1              484,580    308,903      257,230
>   Time to free memory (usecs)
> 
>  usemem process 2              518,928    438,585      446,958 
>   Time to free memory (usecs)
> 
>  Average Time to               501,754    373,744      352,094       -30%
>   Free Memory (usecs)
>  -------------------------------------------------------------------------------
> 
>  -------------------------------------------------------------------------------
>  usemem                          Baseline        zswap        zswap       Change
>  PMD THP                      mm-unstable        store     compress         with
>  BPFTRACE                      10-25-2026     batching     batching     compress
>                                              (patch 6)    (patch 8)     batching
>                                                                             (ns)
>  -------------------------------------------------------------------------------
>  zswap_batch_compress_per_page (ns):            
>                          p50                                 40,086        1,569
>                          p95                                 54,689      -64,505
>                          p99                                 83,248      -88,488
>  -------------------------------------------------------------------------------
>  zswap_single_compress_per_page (ns):
>                          p50       38,517       38,352       36,650       -1,867
>                          p95      119,194      121,174      133,678       14,484
>                          p99      171,736      158,601      169,010       -2,726
>  -------------------------------------------------------------------------------
>  zswap_store_higher_order (ns):
>                          p50   21,012,222   21,322,885   20,176,667     -835,556
>                          p95   25,643,500   26,204,375   24,485,000   -1,158,500
>                          p99   28,567,400   38,577,750   26,158,000   -2,409,400
>  -------------------------------------------------------------------------------
>  zswap_store_order_0 (ns):
>                          p50       37,601       36,994       37,568          -33
>                          p95      123,731      137,034      128,366        4,635
>                          p99      159,965      169,282      175,618       15,653
>  -------------------------------------------------------------------------------
>  vmstat summary:
>  -------------------------------------------------------------------------------
>  zswpin                         1,104,226      993,412    1,091,146       
>  zswpout                        1,688,181    1,582,664    1,669,671       
>  2048kB-alloc                       2,500        2,505        2,500   
>  2048kB-zswpout                     1,535        1,535        1,535   
>  2048kB-swpout-fallback               927          929          875     
>  -------------------------------------------------------------------------------
> 
>  Detailed vmstat & zswap stats after workload finishes:
>  ======================================================
> 
>  ------------------------------------------------------
>  usemem                          Baseline        zswap
>  PMD THP                      mm-unstable     compress
>                                10-25-2026     batching
>                                              (patch 8)
>                                                       
>  ------------------------------------------------------
>  vmstat:
>  ------------------------------------------------------
>  pswpin                               0              0
>  pswpout                              0              0
>  thp_swpout                           0              0
>  thp_swpout_fallback                927            875
>  swpin_zero                           0              0
>  swpout_zero                          0              0
>  zswpin                       1,104,226      1,091,146
>  zswpout                      1,688,181      1,669,671
>  zswpwb                               0              0
>  nrswpin                              0              0
>  nrswpout                             0              0
>  pgmajfault                     173,554        173,774
>  nr_free_pages                1,753,879      1,755,195
>  nr_free_pages_blocks         1,651,712      1,667,072
>  2048kB-alloc                     2,500          2,500
>  2048kB-zswpout                   1,535          1,535
>  2048kB-swpout                        0              0
>  2048kB-swpout-fallback             927            875
>  2048kB-swpin                         0              0
>  memory.current                 352,256        499,712
>  memory.swap.current                  0              0
>  ------------------------------------------------------
>  zswap stats:                                         
>  ------------------------------------------------------
>  pool_limit_hit                       0              0
>  written_back_pages                   0              0
>  reject_alloc_fail                    0              0
>  reject_kmemcache_fail                0              0
>  reject_reclaim_fail                  0              0
>  reject_compress_fail                 0              0
>  reject_compress_poor                 0              0
>  decompress_fail                      0              0
>  stored_incompressible_pages          0              0
>  stored_pages                         0              0
>  pool_total_size                      0              0
>  ------------------------------------------------------

As mentioned in the previous version, I cannot reproduce these results,
mainly because the noise is too high. Digging a bit deeper, it's because
the throttling from memory.high varies. Hacking in a change to make
calculate_high_delay() always return 0 (no memory.high stalls) paints a
clearer picture about throughput improvements from the series up to
patch 6 and patch 8. With that, I see 1-2% improvement in throughput
with patch 6, and almost no improvement with patch 8 on top. Similarly,
for zswap store latency for high-order folios, I see a slight (~1-2%)
improvement with patch 6, but almost none with patch 8 on top.

In order to make meaningful progress, can you send patches 5-6
separately? I assume that 1-4 are prep for 7-8, so 5-6 are standalone. I
also think patch 6 will be simplified if we drop the prep work for
patches 7-8?

Also, PTAL at Sashiko reviews before respinning.
