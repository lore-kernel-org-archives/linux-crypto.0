Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE38E1FF1B4;
	Thu,  6 Feb 2025 07:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738826469; cv=none; b=NyMRX5Q7btkq55Kc6uPbMY+vv/Eig7cIbnNEoDsSqu3EfVtFoHTPX9fTlSzAkEtr17+msK/MDdf0apLx/2XQFoCrBLxtJzSba6d743w9coZEFviXQM8k/kC9mDpjT6m5z/y4F0gVaC3Utu1z9F/CmW4sjCahpAtrkQc+lQX0FLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738826469; c=relaxed/simple;
	bh=84dbuA5ZeoWlBeaM0rI/RZHiZWWHT3sLg/FAVVpwgdY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=PpjIjjmiguV1a0pED5oQYT43IPW0M4CgnXtOiiZeR+2MgkVJQUPWDwH9e6IqStJja2E8exj1RwmFvt0GlVQCXb5zsp47sjNnMuU3WuTJRExMc39sBlU9+qAPe8MUEQKEz1KPSZMLfydm9A8e0GSFUbFpxXdwFaJ3sJLz9o5L+yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mch5WHdE; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mch5WHdE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1738826467; x=1770362467;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=84dbuA5ZeoWlBeaM0rI/RZHiZWWHT3sLg/FAVVpwgdY=;
  b=mch5WHdEdKPSy6cBkNO/OZJy3vcrc0Fg/M20t7QbmSxQYr6sOTCdM3sG
   6xrJV/G//zWdZCAzNmOtYctq9YsMQTCbUB+IE+PR4FMSsBi0TlRb9tXr2
   DBwx9gXeZEaGjCf56RDonNf03FkEGS0/wWNziwWwEZW0TuXP0Bn5zOs21
   yefjVut9oT/6GFESZWJDOiLDA8+5Y7MVHl24yNKMxb2fFN5X9lPm0I5HX
   zmeF7A/uBe3x8HiGSSAMkUARIF4hI4ayrH/8qBKFN20BnD/gQz4JIt5m6
   oO4cQxPP2k0Tp2qqlV18YrrchalcNHYfZy8VZpd5EbIiw0MuER8+A/D7t
   g==;
X-CSE-ConnectionGUID: O9FGWRpFQR6b4OXx13TEpw==
X-CSE-MsgGUID: kybj4M5sR8m7fDzlHimopQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11336"; a="56962578"
X-IronPort-AV: E=Sophos;i="6.13,263,1732608000"; 
   d="scan'208";a="56962578"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2025 23:21:03 -0800
X-CSE-ConnectionGUID: LeJTioXSQoO9W5QzhAR/+A==
X-CSE-MsgGUID: RAPwBuLjTPmmcINPz2v1SA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="112022589"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa008.jf.intel.com with ESMTP; 05 Feb 2025 23:21:03 -0800
From: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	hannes@cmpxchg.org,
	yosry.ahmed@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	usamaarif642@gmail.com,
	ryan.roberts@arm.com,
	21cnbao@gmail.com,
	akpm@linux-foundation.org,
	linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	clabbe@baylibre.com,
	ardb@kernel.org,
	ebiggers@google.com,
	surenb@google.com,
	kristen.c.accardi@intel.com
Cc: wajdi.k.feghali@intel.com,
	vinodh.gopal@intel.com,
	kanchana.p.sridhar@intel.com
Subject: [PATCH v6 00/16] zswap IAA compress batching
Date: Wed,  5 Feb 2025 23:20:46 -0800
Message-Id: <20250206072102.29045-1-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

IAA Compression Batching:
=========================

This patch-series introduces the use of the Intel Analytics Accelerator
(IAA) for parallel batch compression of pages in large folios to improve
zswap swapout latency.

Improvements seen with IAA compress batching vs. IAA sequential:

 usemem30 with 64K folios:
 -------------------------
  59.1% higher throughput
  30.3% lower elapsed time
  36.2% lower sys time 

 usemem30 with 2M folios:
 ------------------------
  60.2% higher throughput
  26.7% lower elapsed time
  30.5% lower sys time 

There is no performance impact to zstd with v6.

The major focus for v6 was to fix the performance regressions observed in
v5, highlighted by Yosry (Thanks Yosry):

 1) zstd performance regression.
 2) IAA batching vs. IAA non-batching regression.

The patch-series is organized as follows:

 1) crypto acomp & iaa_crypto driver enablers for batching: Relevant
    patches are tagged with "crypto:" in the subject:

    Patch 1) Adds new acomp request chaining framework and interface based
             on Herbert Xu's ahash reference implementation in "[PATCH 2/6]
             crypto: hash - Add request chaining API" [1]. acomp algorithms
             can use request chaining through these interfaces:

             Setup the request chain:
               acomp_reqchain_init()
               acomp_request_chain()

             Process the request chain:
               acomp_do_req_chain(): synchronously (sequentially)
               acomp_do_async_req_chain(): asynchronously using submit/poll
                                           ops (in parallel)

    Patch 2) Adds acomp_alg/crypto_acomp interfaces for batch_compress(),
             batch_decompress() and get_batch_size(), that swap modules can
             invoke using the new batching API crypto_acomp_batch_compress(),
             crypto_acomp_batch_decompress() and crypto_acomp_batch_size().
             Additionally, crypto acomp provides a new
             acomp_has_async_batching() interface to query for these API
             before allocating batching resources for a given compressor in
             zswap/zram.

    Patch 3) New CRYPTO_ACOMP_REQ_POLL acomp_req flag to act as a gate for
             async poll mode in iaa_crypto.

    Patch 4) iaa-crypto driver implementations for sync/async
             crypto_acomp_batch_compress() and
             crypto_acomp_batch_decompress() developed using request
             chaining. If the iaa_crypto driver is set up for 'async'
             sync_mode, these batching implementations deploy the
             asynchronous request chaining implementation. 'async' is the
             recommended mode for realizing the benefits of IAA parallelism.
             If iaa_crypto is set up for 'sync' sync_mode, the synchronous
             version of the request chaining API is used.
             
             The "iaa_acomp_fixed_deflate" algorithm registers these
             implementations for its "batch_compress" and "batch_decompress"
             interfaces respectively and opts in with CRYPTO_ALG_REQ_CHAIN.
             Further, iaa_crypto provides an implementation for the
             "get_batch_size" interface: this returns the
             IAA_CRYPTO_MAX_BATCH_SIZE constant that iaa_crypto defines
             currently as 8U for IAA compression algorithms (iaa_crypto can
             change this if needed as we optimize our batching algorithm).

    Patch 5) Modifies the default iaa_crypto driver mode to async, now that
             iaa_crypto provides a truly async mode that gives
             significantly better latency than sync mode for the batching
             use case.

    Patch 6) Disables verify_compress by default, to facilitate users to
             run IAA easily for comparison with software compressors.

    Patch 7) Reorganizes the iaa_crypto driver code into logically related
             sections and avoids forward declarations, in order to facilitate
             Patch 8. This patch makes no functional changes.

    Patch 8) Makes a major infrastructure change in the iaa_crypto driver,
             to map IAA devices/work-queues to cores based on packages
             instead of NUMA nodes. This doesn't impact performance on
             the Sapphire Rapids system used for performance
             testing. However, this change fixes functional problems we
             found on Granite Rapids in internal validation, where the
             number of NUMA nodes is greater than the number of packages,
             which was resulting in over-utilization of some IAA devices
             and non-usage of other IAA devices as per the current NUMA
             based mapping infrastructure.
             This patch also eliminates duplication of device wqs in
             per-cpu wq_tables, thereby saving 140MiB on a 384 cores
             Granite Rapids server with 8 IAAs. Submitting this change now
             so that it can go through code reviews before it can be merged.

    Patch 9) Builds upon the new infrastructure for mapping IAAs to cores
             based on packages, and enables configuring a "global_wq" per
             IAA, which can be used as a global resource for compress jobs
             for the package. If the user configures 2WQs per IAA device,
             the driver will distribute compress jobs from all cores on the
             package to the "global_wqs" of all the IAA devices on that
             package, in a round-robin manner. This can be used to improve
             compression throughput for workloads that see a lot of swapout
             activity.

   Patch 10) Makes an important change to iaa_crypto driver's descriptor
             allocation, from blocking to non-blocking with
             retries/timeouts and mitigations in case of timeouts during
             compress/decompress ops. This prevents tasks getting blocked
             indefinitely, which was observed when testing 30 cores running
             workloads, with only 1 IAA enabled on Sapphire Rapids (out of
             4). These timeouts are typically only encountered, and
             associated mitigations exercised, only in configurations with
             1 IAA device shared by 30+ cores.

   Patch 11) Fixes a bug with the "deflate_generic_tfm" global being
             accessed without locks in the software decomp fallback code.

 2) zswap modifications to enable compress batching in zswap_store()
    of large folios (including pmd-mappable folios):

   Patch 12) Defines a zswap-specific ZSWAP_MAX_BATCH_SIZE (currently set
             as 8U) to denote the maximum number of acomp_ctx batching
             resources. Further, the "struct crypto_acomp_ctx" is modified
             to contain a configurable number of acomp_reqs and buffers.
             The cpu hotplug onlining code will allocate up to
             ZSWAP_MAX_BATCH_SIZE requests/buffers in the per-cpu
             acomp_ctx, thereby limiting the memory usage in zswap, and
             ensuring that non-batching compressors incur no memory penalty.

   Patch 13) Restructures & simplifies zswap_store() to make it amenable
             for batching. Moves the loop over the folio's pages to a new
             zswap_store_folio(), which in turn allocates zswap entries
             for all folio pages upfront, then calls zswap_compress() for
             each folio page.

   Patch 14) Introduces zswap_compress_folio() to compress all pages in a
             folio. 

   Patch 15) We modify zswap_compress_folio() to detect if the compressor
             supports batching. If so, the "acomp_ctx->nr_reqs" becomes the
             batch size with which we call crypto_acomp_batch_compress() to
             compress multiple folio pages in parallel in IAA. Upon
             successful compression of a batch, the compressed buffers are
             stored in zpool.

             For compressors that don't support batching,
             zswap_compress_folio() will call zswap_compress() for each
             page in the folio.

             However, although we observe significantly better IAA batching
             performance/throughput, there was also a significant
             performance regression observed with zstd/2M folios. This is
             fixed in patch 16.

             Based on the discussions in [2], patch 15 invokes
             crypto_acomp_batch_compress() with "NULL" for the @wait
             parameter. This causes iaa_crypto's iaa_comp_acompress_batch()
             to use asynchronous polling instead of async request chaining
             for now, until there is better clarity on request
             chaining. Further, testing with micro-benchmarks indicated a
             slight increase in latency with request chaining:

             crypto_acomp_batch_compress()  p05 (ns)   p50 (ns)  p99 (ns)
             -------------------------------------------------------------
             async polling                   5,279      5,589     8,875
             async request chaining          5,316      5,662     8,923
             -------------------------------------------------------------

   Patch 16) The zstd 2M regression is fixed. We now see no regressions
             with zstd, and impressive throughput/performance improvements
             with IAA batching vs. no-batching.


With v6 of this patch series, the IAA compress batching feature will be
enabled seamlessly on Intel platforms that have IAA by selecting
'deflate-iaa' as the zswap compressor, and using the iaa_crypto 'async'
sync_mode driver attribute.

[1]: https://lore.kernel.org/linux-crypto/677614fbdc70b31df2e26483c8d2cd1510c8af91.1730021644.git.herbert@gondor.apana.org.au/
[2]: https://patchwork.kernel.org/project/linux-mm/patch/20241221063119.29140-3-kanchana.p.sridhar@intel.com/


System setup for testing:
=========================
Testing of this patch-series was done with mm-unstable as of 2-1-2025,
commit 7de6fd8ab650, without and with this patch-series.
Data was gathered on an Intel Sapphire Rapids (SPR) server, dual-socket
56 cores per socket, 4 IAA devices per socket, 503 GiB RAM and 525G SSD
disk partition swap. Core frequency was fixed at 2500MHz.

Other kernel configuration parameters:

    zswap compressor  : zstd, deflate-iaa
    zswap allocator   : zsmalloc
    vm.page-cluster   : 0

IAA "compression verification" is disabled and IAA is run in the async
mode (the defaults with this series).

I ran experiments with these workloads:

1) usemem 30 processes with these large folios enabled to "always":
   - 64k
   - 2048k

2) Kernel compilation allmodconfig with 2G max memory, 32 threads, run in
   tmpfs with these large folios enabled to "always":
   - 64k

usemem30 and kernel compilation used different IAA WQs configurations:

  usemem30 IAA WQ configuration:
  ------------------------------
  1 WQ with 128 entries per device. Compress/decompress jobs are sent to
  the same WQ and IAA that is mapped to the cores. There is very less
  swapin activity in this workload, and allocating 2WQs (one for decomps,
  one for comps, each 64 entries) degrades compress batching latency. This
  IAA WQ configuration explains the insignificant performance gains seen
  with IAA batching in v5, and once again delivers the expected performance
  improvements with batching.

  Kernel compilation IAA WQ configuration:
  ----------------------------------------
  2WQs, with 64 entries each, are configured per IAA device. Compress jobs
  from all cores on a socket are distributed among all 4 IAA devices on the
  same socket.


Performance testing (usemem30):
===============================
The vm-scalability "usemem" test was run in a cgroup whose memory.high
was fixed at 150G. The is no swap limit set for the cgroup. 30 usemem
processes were run, each allocating and writing 10G of memory, and sleeping
for 10 sec before exiting:

usemem --init-time -w -O -b 1 -s 10 -n 30 10g

One important difference in v6's experiments is that the 30 usemem
processes are pinned to 30 consecutive cores on socket 0, which makes use
of the IAA devices only on socket 0.


 64K folios: usemem30: deflate-iaa:
 ==================================

 -------------------------------------------------------------------------------
                 mm-unstable-2-1-2025            v6             v6
 -------------------------------------------------------------------------------
 zswap compressor         deflate-iaa   deflate-iaa    deflate-iaa  IAA Batching
                                                                        vs.
                                                                      Sequential
 -------------------------------------------------------------------------------
 Total throughput (KB/s)    6,039,595     9,679,965      9,537,327       59.1%      
 Avg throughput (KB/s)        201,319       322,665        317,910                  
 elapsed time (sec)            100.74         69.05          71.43      -30.3%      
 sys time (sec)              2,446.53      1,526.71       1,596.23      -36.2%      
                                                                                    
 -------------------------------------------------------------------------------
 memcg_high                   909,501       961,527        964,010                  
 memcg_swap_fail                1,580           733          2,393                  
 zswpout                   58,342,295    61,542,432     61,715,737                  
 zswpin                           425            80            442                  
 pswpout                            0             0              0                  
 pswpin                             0             0              0                  
 thp_swpout                         0             0              0                  
 thp_swpout_fallback                0             0              0                  
 64kB_swpout_fallback           1,580           733          2,393                  
 pgmajfault                     3,311         2,860          3,220                  
 anon_fault_alloc_64kB      4,924,571     4,924,545      4,924,104                 
 ZSWPOUT-64kB               3,644,769     3,845,652      3,854,791 
 SWPOUT-64kB                        0             0              0 
 -------------------------------------------------------------------------------


 2M folios: usemem30: deflate-iaa:
 =================================


 -------------------------------------------------------------------------------
                 mm-unstable-2-1-2025             v6             v6
 -------------------------------------------------------------------------------
 zswap compressor         deflate-iaa    deflate-iaa    deflate-iaa IAA Batching
                                                                        vs.
                                                                     Sequential
 -------------------------------------------------------------------------------
 Total throughput (KB/s)     6,334,585     10,068,264    10,230,633      60.2%     
 Avg throughput (KB/s)         211,152        335,608       341,021                
 elapsed time (sec)              87.68          65.74         62.86     -26.7%     
 sys time (sec)               2,031.84       1,454.93      1,370.87     -30.5%     
                                                                                   
 -------------------------------------------------------------------------------
 memcg_high                    115,322        121,226       120,093                
 memcg_swap_fail                   568            350           301                
 zswpout                   559,323,303     62,474,427    61,907,590                
 zswpin                            518            463            14                
 pswpout                             0              0             0                
 pswpin                              0              0             0                
 thp_swpout                          0              0             0                
 thp_swpout_fallback               568            350           301                
 pgmajfault                      3,298          3,247         2,826                
 anon_fault_alloc_2048kB       153,734        153,734       153,737               
 ZSWPOUT-2048kB                115,321        121,672       120,614           
 SWPOUT-2048kB                       0              0             0           
 -------------------------------------------------------------------------------


 64K folios: usemem30: zstd:
 ===========================

 -------------------------------------------------------------------------------
                mm-unstable-2-1-2025            v6            v6           v6
                                          Patch 15      Patch 16     Patch 16
                                            (regr)       (fixed)      (fixed)
 -------------------------------------------------------------------------------
 zswap compressor               zstd          zstd          zstd         zstd
 -------------------------------------------------------------------------------
 Total throughput (KB/s)   6,929,741     6,975,265     7,003,546    6,953,025
 Avg throughput (KB/s)       230,991       232,508       233,451      231,767
 elapsed time (sec)            88.59         87.32         87.45        88.57
 sys time (sec)             2,188.83      2,136.52      2,133.41     2,178.23

 -------------------------------------------------------------------------------
 memcg_high                  764,423       764,174       764,420      764,476
 memcg_swap_fail               1,236            15         1,234           16
 zswpout                  48,928,758    48,908,998    48,928,536   48,928,551
 zswpin                          421            68           396          100
 pswpout                           0             0             0            0
 pswpin                            0             0             0            0
 thp_swpout                        0             0             0            0
 thp_swpout_fallback               0             0             0            0
 64kB_swpout_fallback          1,236            15         1,234           16
 pgmajfault                    3,196         2,875         3,570        3,284
 anon_fault_alloc_64kB     4,924,288     4,924,406     4,924,161    4,924,064
 ZSWPOUT-64kB              3,056,753     3,056,772     3,056,745    3,057,979
 SWPOUT-64kB                       0             0             0            0
 -------------------------------------------------------------------------------


 2M folios: usemem30: zstd:
 ==========================

 -------------------------------------------------------------------------------
                mm-unstable-2-1-2025            v6            v6           v6
                                          Patch 15      Patch 16     Patch 16
                                            (regr)       (fixed)      (fixed)
 -------------------------------------------------------------------------------
 zswap compressor               zstd          zstd          zstd         zstd
 -------------------------------------------------------------------------------
 Total throughput (KB/s)   7,712,462     7,235,682     7,716,994    7,745,378
 Avg throughput (KB/s)       257,082       241,189       257,233      258,179
 elapsed time (sec)            84.94         89.54         86.96        85.82
 sys time (sec)             2,008.19      2,141.90      2,059.80     2,039.96
                                                                             
 -------------------------------------------------------------------------------
 memcg_high                   93,036        94,792        93,137       93,100
 memcg_swap_fail                 143           169            32           11
 zswpout                  48,062,240    48,929,604    48,113,722   48,073,739
 zswpin                          439           438            71            9
 pswpout                           0             0             0            0
 pswpin                            0             0             0            0
 thp_swpout                        0             0             0            0
 thp_swpout_fallback             143           169            32           11
 pgmajfault                    3,246         3,645         3,248        2,775
 anon_fault_alloc_2048kB     153,739       153,738       153,740      153,733
 ZSWPOUT-2048kB               93,726        95,398        93,940       93,883
 SWPOUT-2048kB                     0             0             0            0
 -------------------------------------------------------------------------------

 zstd 2M regression fix details:
 -------------------------------
 Patch 16 essentially adapts the batching implementation of
 zswap_store_folio() to be sequential, i.e., for the behavior to be the
 same as the earlier zswap_store_page() iteration over the folio's
 pages. It attempts to preserve common code paths.

 I wasn't able to quantify why the Patch 15 implementation caused
 the zstd regression with the usual profiling methods such as
 tracepoints/bpftrace. My best hypothesis as to why Patch 16 resolves the
 regression, is that it has to do with a combination of branch mispredicts
 and the working set in the zswap_store_folio() code blocks having to load
 and iterate over 512 pages in the 3 loops. I gathered perf event counts
 that seem to back up this hypothesis:


 -------------------------------------------------------------------------------
 usemem30, zstd,              v6 Patch 15          v6 Patch 16        Change in
 2M Folios,            zstd 2M regression           Fixes zstd       PMU events
 perf stats                                      2M regression         with fix
 -------------------------------------------------------------------------------
 branch-misses              1,571,192,128        1,545,342,571       -25,849,557
 L1-dcache-stores       1,211,615,528,323    1,190,695,049,961   -20,920,478,362
 L1-dcache-loads        3,357,273,843,074    3,307,817,975,881   -49,455,867,193
 LLC-store-misses           3,357,428,475        3,340,252,023       -17,176,452
 branch-load-misses         1,567,824,197        1,546,321,034       -21,503,163
 branch-loads           1,463,632,526,371    1,449,551,102,173   -14,081,424,198
 mem-stores             1,211,399,592,024    1,191,473,855,029   -19,925,736,995
 dTLB-loads             3,367,449,558,533    3,308,475,712,698   -58,973,845,835
 LLC-loads                  1,867,235,354        1,773,790,017       -93,445,337
 node-load-misses               4,057,323            3,959,741           -97,582
 major-faults                         241                    0              -241
 L1-dcache-load-misses     22,339,515,994       24,381,783,235     2,042,267,241
 L1-icache-load-misses     21,182,690,283       26,504,876,405     5,322,186,122
 LLC-load-misses              224,000,082          258,495,328        34,495,246
 node-loads                   221,425,627          256,372,686        34,947,059
 mem-loads                              0                    0                 0
 dTLB-load-misses               4,886,686            8,672,079         3,785,393
 iTLB-load-misses               1,548,637            4,268,093         2,719,456
 cache-misses              10,831,533,095       10,834,598,425         3,065,330
 minor-faults                     155,246              155,707               461 
 -------------------------------------------------------------------------------



 4K folios: usemem30: Regression testing:
 ========================================

 -------------------------------------------------------------------------------
                        mm-unstable             v6   mm-unstable           v6
 -------------------------------------------------------------------------------
 zswap compressor       deflate-iaa    deflate-iaa          zstd         zstd   
 -------------------------------------------------------------------------------
 Total throughput (KB/s)  5,155,471      6,031,332     6,453,431    6,566,026
 Avg throughput (KB/s)      171,849        201,044       215,114      218,867
 elapsed time (sec)          108.35          92.61         95.50        88.99
 sys time (sec)            2,400.32       2,212.06      2,417.16     2,207.35
                                                                                
 -------------------------------------------------------------------------------
 memcg_high                 670,635      1,007,763       764,456      764,470
 memcg_swap_fail                  0              0             0            0
 zswpout                 62,098,929     64,507,508    48,928,772   48,928,690
 zswpin                         425             77           457          461
 pswpout                          0              0             0            0
 pswpin                           0              0             0            0
 thp_swpout                       0              0             0            0
 thp_swpout_fallback              0              0             0            0
 pgmajfault                   3,271          2,864         3,240        3,242
 -------------------------------------------------------------------------------


Performance testing (Kernel compilation, allmodconfig):
=======================================================

The experiments with kernel compilation test, 32 threads, in tmpfs use the
"allmodconfig" that takes ~12 minutes, and has considerable swapout/swapin
activity. The cgroup's memory.max is set to 2G.


 64K folios: Kernel compilation/allmodconfig:
 ============================================

 -------------------------------------------------------------------------------
                     mm-unstable               v6   mm-unstable            v6
 -------------------------------------------------------------------------------
 zswap compressor    deflate-iaa      deflate-iaa          zstd          zstd   
 -------------------------------------------------------------------------------
 real_sec                 767.36           743.90        776.08        769.43
 user_sec              15,773.57        15,773.34     15,780.93     15,736.49
 sys_sec                4,209.63         4,013.51      5,392.85      5,046.05
 -------------------------------------------------------------------------------
 Max_Res_Set_Size_KB   1,874,680        1,873,776     1,874,244     1,873,456
 -------------------------------------------------------------------------------
 memcg_high                    0                0             0             0
 memcg_swap_fail               0                0             0             0
 zswpout             109,623,799      110,737,958    89,488,777    81,553,126
 zswpin               33,303,441       33,295,883    26,753,716    23,266,542
 pswpout                     315              151            99           116
 pswpin                       80               54            64            32
 thp_swpout                    0                0             0             0
 thp_swpout_fallback           0                0             0             0
 64kB_swpout_fallback          0              348             0             0
 pgmajfault           35,606,216       35,462,017    28,488,538    24,703,903
 ZSWPOUT-64kB          3,551,578        3,596,675     2,814,435     2,603,649
 SWPOUT-64kB                  19                5             5             7
 -------------------------------------------------------------------------------


With the iaa_crypto driver changes for non-blocking descriptor allocations
no timeouts-with-mitigations were seen in compress/decompress jobs, for all
of the above experiments.


Summary:
========
The performance testing data with usemem 30 processes and kernel
compilation test show 60% throughput gains and 36% sys time reduction
(usemem30) and 5% sys time reduction (kernel compilation) with
zswap_store() large folios using IAA compress batching as compared to
IAA sequential. There is no performance regression for zstd.

We can expect to see even more significant performance and throughput
improvements if we use the parallelism offered by IAA to do reclaim
batching of 4K/large folios (really any-order folios), and using the
zswap_store() high throughput compression to batch-compress pages
comprising these folios, not just batching within large folios. This is the
reclaim batching patch 13 in v1, which will be submitted in a separate
patch-series.

Our internal validation of IAA compress/decompress batching in highly
contended Sapphire Rapids server setups with workloads running on 72 cores
for ~25 minutes under stringent memory limit constraints have shown up to
50% reduction in sys time and 21.3% more memory savings with IAA, as
compared to zstd, for same performance. IAA batching demonstrates more than
2X the memory savings obtained by zstd for same performance.


Changes since v5:
=================
1) Rebased to mm-unstable as of 2-1-2025, commit 7de6fd8ab650.

Several improvements, regression fixes and bug fixes, based on Yosry's
v5 comments (Thanks Yosry!):

2) Fix for zstd performance regression in v5.
3) Performance debug and fix for marginal improvements with IAA batching
   vs. sequential.
4) Performance testing data compares IAA with and without batching, instead
   of IAA batching against zstd.
5) Commit logs/zswap comments not mentioning crypto_acomp implementation
   details.
6) Delete the pr_info_once() when batching resources are allocated in
   zswap_cpu_comp_prepare().
7) Use kcalloc_node() for the multiple acomp_ctx buffers/reqs in
   zswap_cpu_comp_prepare().
8) Simplify and consolidate error handling cleanup code in
   zswap_cpu_comp_prepare().
9) Introduce zswap_compress_folio() in a separate patch.
10) Bug fix in zswap_store_folio() when xa_store() failure can cause all
    compressed objects and entries to be freed, and UAF when zswap_store()
    tries to free the entries that were already added to the xarray prior
    to the failure.
11) Deleting compressed_bytes/bytes. zswap_store_folio() also comprehends
    the recent fixes in commit bf5eaaaf7941 ("mm/zswap: fix inconsistency
    when zswap_store_page() fails") by Hyeonggon Yoo.

iaa_crypto improvements/fixes/changes:

12) Enables asynchronous mode and makes it the default. With commit
    4ebd9a5ca478 ("crypto: iaa - Fix IAA disabling that occurs when
    sync_mode is set to 'async'"), async mode was previously just sync. We
    now have true async support.
13) Change idxd descriptor allocations from blocking to non-blocking with
    timeouts, and mitigations for compress/decompress ops that fail to
    obtain a descriptor. This is a fix for tasks blocked errors seen in
    configurations where 30+ cores are running workloads under high memory
    pressure, and sending comps/decomps to 1 IAA device.
14) Fixes a bug with unprotected access of "deflate_generic_tfm" in
    deflate_generic_decompress(), which can cause data corruption and
    zswap_decompress() kernel crash.
15) zswap uses crypto_acomp_batch_compress() with async polling instead of
    request chaining for slightly better latency. However, the request
    chaining framework itself is unchanged, preserved from v5.


Changes since v4:
=================
1) Rebased to mm-unstable as of 12-20-2024, commit 5555a83c82d6.
2) Added acomp request chaining, as suggested by Herbert. Thanks Herbert!
3) Implemented IAA compress batching using request chaining.
4) zswap_store() batching simplifications suggested by Chengming, Yosry and
   Nhat, thanks to all!
   - New zswap_compress_folio() that is called by zswap_store().
   - Move the loop over folio's pages out of zswap_store() and into a
     zswap_store_folio() that stores all pages.
   - Allocate all zswap entries for the folio upfront.
   - Added zswap_batch_compress().
   - Branch to call zswap_compress() or zswap_batch_compress() inside
     zswap_compress_folio().
   - All iterations over pages kept in same function level.
   - No helpers other than the newly added zswap_store_folio() and
     zswap_compress_folio().


Changes since v3:
=================
1) Rebased to mm-unstable as of 11-18-2024, commit 5a7056135bb6.
2) Major re-write of iaa_crypto driver's mapping of IAA devices to cores,
   based on packages instead of NUMA nodes.
3) Added acomp_has_async_batching() API to crypto acomp, that allows
   zswap/zram to query if a crypto_acomp has registered batch_compress and
   batch_decompress interfaces.
4) Clear the poll bits on the acomp_reqs passed to
   iaa_comp_a[de]compress_batch() so that a module like zswap can be
   confident about the acomp_reqs[0] not having the poll bit set before
   calling the fully synchronous API crypto_acomp_[de]compress().
   Herbert, I would appreciate it if you can review changes 2-4; in patches
   1-8 in v4. I did not want to introduce too many iaa_crypto changes in
   v4, given that patch 7 is already making a major change. I plan to work
   on incorporating the request chaining using the ahash interface in v5
   (I need to understand the basic crypto ahash better). Thanks Herbert!
5) Incorporated Johannes' suggestion to not have a sysctl to enable
   compress batching.
6) Incorporated Yosry's suggestion to allocate batching resources in the
   cpu hotplug onlining code, since there is no longer a sysctl to control
   batching. Thanks Yosry!
7) Incorporated Johannes' suggestions related to making the overall
   sequence of events between zswap_store() and zswap_batch_store() similar
   as much as possible for readability and control flow, better naming of
   procedures, avoiding forward declarations, not inlining error path
   procedures, deleting zswap internal details from zswap.h, etc. Thanks
   Johannes, really appreciate the direction!
   I have tried to explain the minimal future-proofing in terms of the
   zswap_batch_store() signature and the definition of "struct
   zswap_batch_store_sub_batch" in the comments for this struct. I hope the
   new code explains the control flow a bit better.


Changes since v2:
=================
1) Rebased to mm-unstable as of 11-5-2024, commit 7994b7ea6ac8.
2) Fixed an issue in zswap_create_acomp_ctx() with checking for NULL
   returned by kmalloc_node() for acomp_ctx->buffers and for
   acomp_ctx->reqs.
3) Fixed a bug in zswap_pool_can_batch() for returning true if
   pool->can_batch_comp is found to be equal to BATCH_COMP_ENABLED, and if
   the per-cpu acomp_batch_ctx tests true for batching resources having
   been allocated on this cpu. Also, changed from per_cpu_ptr() to
   raw_cpu_ptr().
4) Incorporated the zswap_store_propagate_errors() compilation warning fix
   suggested by Dan Carpenter. Thanks Dan!
5) Replaced the references to SWAP_CRYPTO_SUB_BATCH_SIZE in comments in
   zswap.h, with SWAP_CRYPTO_BATCH_SIZE.

Changes since v1:
=================
1) Rebased to mm-unstable as of 11-1-2024, commit 5c4cf96cd702.
2) Incorporated Herbert's suggestions to use an acomp_req flag to indicate
   async/poll mode, and to encapsulate the polling functionality in the
   iaa_crypto driver. Thanks Herbert!
3) Incorporated Herbert's and Yosry's suggestions to implement the batching
   API in iaa_crypto and to make its use seamless from zswap's
   perspective. Thanks Herbert and Yosry!
4) Incorporated Yosry's suggestion to make it more convenient for the user
   to enable compress batching, while minimizing the memory footprint
   cost. Thanks Yosry!
5) Incorporated Yosry's suggestion to de-couple the shrink_folio_list()
   reclaim batching patch from this series, since it requires a broader
   discussion.


I would greatly appreciate code review comments for the iaa_crypto driver
and mm patches included in this series!

Thanks,
Kanchana



Kanchana P Sridhar (16):
  crypto: acomp - Add synchronous/asynchronous acomp request chaining.
  crypto: acomp - Define new interfaces for compress/decompress
    batching.
  crypto: iaa - Add an acomp_req flag CRYPTO_ACOMP_REQ_POLL to enable
    async mode.
  crypto: iaa - Implement batch_compress(), batch_decompress() API in
    iaa_crypto.
  crypto: iaa - Enable async mode and make it the default.
  crypto: iaa - Disable iaa_verify_compress by default.
  crypto: iaa - Re-organize the iaa_crypto driver code.
  crypto: iaa - Map IAA devices/wqs to cores based on packages instead
    of NUMA.
  crypto: iaa - Distribute compress jobs from all cores to all IAAs on a
    package.
  crypto: iaa - Descriptor allocation timeouts with mitigations in
    iaa_crypto.
  crypto: iaa - Fix for "deflate_generic_tfm" global being accessed
    without locks.
  mm: zswap: Allocate pool batching resources if the compressor supports
    batching.
  mm: zswap: Restructure & simplify zswap_store() to make it amenable
    for batching.
  mm: zswap: Introduce zswap_compress_folio() to compress all pages in a
    folio.
  mm: zswap: Compress batching with Intel IAA in zswap_store() of large
    folios.
  mm: zswap: Fix for zstd performance regression with 2M folios.

 .../driver-api/crypto/iaa/iaa-crypto.rst      |   11 +-
 crypto/acompress.c                            |  287 +++
 drivers/crypto/intel/iaa/iaa_crypto.h         |   30 +-
 drivers/crypto/intel/iaa/iaa_crypto_main.c    | 1724 ++++++++++++-----
 include/crypto/acompress.h                    |  157 ++
 include/crypto/algapi.h                       |   10 +
 include/crypto/internal/acompress.h           |   29 +
 include/linux/crypto.h                        |   31 +
 mm/zswap.c                                    |  449 ++++-
 9 files changed, 2170 insertions(+), 558 deletions(-)


base-commit: 7de6fd8ab65003f050aa58e705592745717ed318
-- 
2.27.0

