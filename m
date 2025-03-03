Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A5C18FC6B;
	Mon,  3 Mar 2025 08:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740991651; cv=none; b=AoI1vfg1LnA2tyS/ydCxp2NES8LH8zo4TcNAUQ0eO5rXE/BJ8/4yIhfdsB8caayYpFRhfToJNLxhPZave50LBZ9ryIJMGij+s7MgmEE1PkhUXhGqwKCUu/MldvANATidYGoCWi1iLSncEejhtb0jtGAWe2JFW9osfmf87dOiXrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740991651; c=relaxed/simple;
	bh=Cy0Wn8n5jdJKV9aWxdo8hIiOZC0k2yqHJoT1pN81McQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=qWe3chkVasjDbCOcg4802Ev2/gvI2AnKeLA5DGA7hcEzkkInsP6yqkvHAtRgrE4ZxrWiFO8e1xi4AKScfsy4CRFdk5LACoG7wPE9ITxeCm7thgOQtClXusMYC2vgf6UIYBn/7A141XPVOKdtrA2X14KaqbJ6iDM09yo1R9nzeqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Tl/0cEeU; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Tl/0cEeU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740991648; x=1772527648;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Cy0Wn8n5jdJKV9aWxdo8hIiOZC0k2yqHJoT1pN81McQ=;
  b=Tl/0cEeUzhE9kXipDRc6XN9RaUrmQ8OppbK0q8nKWt3+BmJkpG9f42Zo
   5WMc/EntXh9RiGvwZlaFN3aoUULq3Qb+4TUPDDSEe0wPw9gnXfAU7gj4I
   Lg3P4FC6UIqRCLrM67eAtYH19AGHgrYAOYmAB3WD7YXA/IdlqNX1hGzj5
   SrKI+QwRajG4WwTzQpP/z/Ri/TMXqRqlypZXAPFh2It5EVoajNdenZapX
   wcLwfxWvHr1NUYMsOumvJ2DpgbV/wjiCCrZkL0z0O1YJlGOwjl0qJAANH
   713ajcASVD7a583a6w7xVLkqsj6nXJEzVGLLlu6Hrp0Ke4T0MPUx9SsIF
   g==;
X-CSE-ConnectionGUID: uqdJcgl6Sz+FVZN0OnerXg==
X-CSE-MsgGUID: VZcWdGEBTg+9efYGLfX7gQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11361"; a="42111840"
X-IronPort-AV: E=Sophos;i="6.13,329,1732608000"; 
   d="scan'208";a="42111840"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2025 00:47:25 -0800
X-CSE-ConnectionGUID: gTLAifLVTkCl7Cjx8PGL5A==
X-CSE-MsgGUID: /ncNCLBUQRCpumWl4sImuA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,329,1732608000"; 
   d="scan'208";a="118426754"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by fmviesa010.fm.intel.com with ESMTP; 03 Mar 2025 00:47:24 -0800
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
	ying.huang@linux.alibaba.com,
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
Subject: [PATCH v8 00/14] zswap IAA compress batching
Date: Mon,  3 Mar 2025 00:47:10 -0800
Message-Id: <20250303084724.6490-1-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

IAA Compression Batching with crypto_acomp Request Chaining:
============================================================

This patch-series introduces the use of the Intel Analytics Accelerator
(IAA) for parallel batch compression of pages in large folios to improve
zswap swapout latency. It does this by first creating a generic batching
framework in crypto_acomp using request chaining, followed by invoking
request chaining API to compress/decompress a batch in the iaa_crypto
driver.

From zswap's perspective, the most significant changes are:

1) A unified zswap_batch_compress() API is added to compress multiple
   pages. If the compressor has multiple acomp requests, i.e., internally
   supports batching, a request chain is created and crypto_acomp_compress()
   is called with the head request in the chain. In the iaa_crypto driver,
   the request chain is batch compressed in parallel.
   
   If the compressor can only compress one page at a time, each page is
   compressed sequentially.

   In both cases, the calls to crypto are exactly the same:

   crypto_wait_req(crypto_acomp_compress(acomp_ctx->reqs[0]), &acomp_ctx->wait);

   Many thanks to Yosry for this suggestion, because it is an essential
   component of unifying common code paths between sequential/batching
   compressions.

2) zswap_compress() has been deleted, since we call zswap_batch_compress()
   in all cases.

3) A new zswap_store_pages() is added, that stores multiple pages in a
   folio in a range of indices. This is an extension of the earlier
   zswap_store_page(), except it operates on a batch of pages.

4) A new zswap_store_folio() is added, that stores all pages in a folio by
   calling zswap_store_pages(). If the compressor supports batching,
   i.e., has multiple acomp requests, the folio will be compressed in
   batches of "acomp_ctx->nr_reqs" using request chaining. If the
   compressor has only one acomp request, the folio will be compressed
   in batches of ZSWAP_MAX_BATCH_SIZE pages, where each page in the batch
   is compressed sequentially.

5) A simplification of the acomp_ctx resources allocation/deletion
   vis-a-vis CPU hot[un]plug. v8 of this patch-series proposes that these
   resources are not destroyed during CPU offlining, rather have a lifespan
   that tracks the zswap_pool's: from pool creation to pool deletion. This
   is in response to Yosry's comments in v6 with regards to exploring mutex
   locking options in zswap_cpu_comp_prepare().

Improvements seen with v8's IAA compress batching with request chaining
vs. IAA sequential:

usemem30 with 64K folios:
  70% higher throughput
  32% lower elapsed time
  32% lower sys time 

usemem30 with 2M folios:
  68% higher throughput
  24% lower elapsed time
  24% lower sys time 

Kernel compilation allmod config with 64K folios:
  8.4% lower sys time

There are no regressions seen with zstd with either usemem30 or kernel
compilation allmod config.

In v8, there are only very minor changes wrt v7 for patches 1 through 13.
The only major change is in patch 14.

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

             Query if a request has a chain of requests that need to be
             processed with it, as a batch:

             acomp_is_reqchain()

    Patch 2) Adds acomp_alg/crypto_acomp interfaces for get_batch_size(),
             that swap modules can invoke using the new
             crypto_acomp_batch_size() API, to get the maximum batch size
             supported by a compressor before allocating batching
             resources.

    Patch 3) New CRYPTO_ACOMP_REQ_POLL acomp_req flag to act as a gate for
             async poll mode in iaa_crypto.

    Patch 4) iaa-crypto driver implementations for async and sync compress
             and decompress batching using request chaining. The driver's
             compress() and decompress() interface implementations will
             query acomp_is_reqchain() to do batched vs. sequential
             compression/decompression. If the iaa_crypto driver is set up
             for 'async' sync_mode, these batching implementations deploy
             the asynchronous request chaining framework provided via
             acomp_do_async_req_chain() in patch 1. 'async' is the
             recommended mode for realizing the benefits of IAA
             parallelism. If iaa_crypto is set up for 'sync' sync_mode, the
             synchronous version of the request chaining API is used, i.e.,
             acomp_do_req_chain() - this will process the chain in series.
             
             The "iaa_acomp_fixed_deflate" algorithm opts in to request
             chaining with CRYPTO_ALG_REQ_CHAIN, and registers the
             get_batch_size() interface, which returns the
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

   Patch 12) Simplifies acomp_ctx resources to have a lifespan from pool
             creation to pool deletion, persisting through CPU hot[un]plugs
             after initial allocation.

   Patch 13) Defines a zswap-specific ZSWAP_MAX_BATCH_SIZE (currently set
             as 8U) to denote the maximum number of acomp_ctx batching
             resources. Further, the "struct crypto_acomp_ctx" is modified
             to contain a configurable number of acomp_reqs and buffers.
             The cpu hotplug onlining code will allocate up to
             ZSWAP_MAX_BATCH_SIZE requests/buffers in the per-cpu
             acomp_ctx, thereby limiting the memory usage in zswap, and
             ensuring that non-batching compressors incur no memory penalty
             except for minimal overhead.

   Patch 14) Restructures & simplifies zswap_store() to make it amenable
             for batching. Moves the loop over the folio's pages to a new
             zswap_store_folio(), which in turn calls a new
             zswap_store_pages() with a range of indices in the folio to be
             stored. zswap_store_pages() calls the new
             zswap_batch_compress() to use compression batching with
             request chaining to compress multiple pages in one shot (in
             parallel in IAA), or to sequentially compress each page in the
             batch.

             zstd performance is on par with mm-unstable. We see impressive
             throughput/performance improvements with IAA batching
             vs. no-batching.


With v8 of this patch series, the IAA compress batching feature will be
enabled seamlessly on Intel platforms that have IAA by selecting
'deflate-iaa' as the zswap compressor, and using the iaa_crypto 'async'
sync_mode driver attribute.

[1]: https://lore.kernel.org/linux-crypto/677614fbdc70b31df2e26483c8d2cd1510c8af91.1730021644.git.herbert@gondor.apana.org.au/


System setup for testing:
=========================
Testing of this patch-series was done with mm-unstable as of 2-27-2025,
commit d58172d128ac, without and with this patch-series.
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


Performance testing (usemem30):
===============================
The vm-scalability "usemem" test was run in a cgroup whose memory.high
was fixed at 150G. The is no swap limit set for the cgroup. 30 usemem
processes were run, each allocating and writing 10G of memory, and sleeping
for 10 sec before exiting:

usemem --init-time -w -O -b 1 -s 10 -n 30 10g


 64K folios: usemem30: deflate-iaa:
 ==================================

 -------------------------------------------------------------------------------
                 mm-unstable-2-27-2025             v8
 -------------------------------------------------------------------------------
 zswap compressor         deflate-iaa     deflate-iaa    IAA Batching
                                                             vs.
                                                           Sequential
 -------------------------------------------------------------------------------
 Total throughput (KB/s)    6,025,001      10,220,686         70%      
 Avg throughput (KB/s)        200,833         340,689                    
 elapsed time (sec)            100.25           68.48        -32%      
 sys time (sec)              2,414.12        1,630.42        -32%      
                                                                         
 -------------------------------------------------------------------------------
 memcg_high                   912,474       1,007,870                    
 memcg_swap_fail                    0               0                    
 zswpout                   58,338,296      64,507,786                    
 zswpin                            65              69                    
 pswpout                            0               0                    
 pswpin                             0               0                    
 thp_swpout                         0               0                    
 thp_swpout_fallback                0               0                    
 64kB_swpout_fallback             941             125                    
 pgmajfault                     2,867           2,943                    
 anon_fault_alloc_64kB      4,924,286       4,923,648                   
 ZSWPOUT-64kB               3,645,190       4,031,585   
 SWPOUT-64kB                        0               0   
 -------------------------------------------------------------------------------


 2M folios: usemem30: deflate-iaa:
 =================================


 -------------------------------------------------------------------------------
                 mm-unstable-2-27-2025              v8
 -------------------------------------------------------------------------------
 zswap compressor          deflate-iaa     deflate-iaa     IAA Batching
                                                               vs.
                                                            Sequential
 -------------------------------------------------------------------------------
 Total throughput (KB/s)     6,374,303      10,720,261        68%     
 Avg throughput (KB/s)         212,476         357,342               
 elapsed time (sec)              87.04           65.80       -24%     
 sys time (sec)               2,012.30        1,522.93       -24%     
                                                                     
 -------------------------------------------------------------------------------
 memcg_high                   115,418          125,177              
 memcg_swap_fail                    0                0              
 zswpout                   59,471,372       64,509,017              
 zswpin                            10              441              
 pswpout                            0                0              
 pswpin                             0                0              
 thp_swpout                         0                0              
 thp_swpout_fallback               24              222              
 pgmajfault                     2,784            3,226              
 anon_fault_alloc_2048kB      153,737          153,733             
 ZSWPOUT-2048kB               116,131          125,781         
 SWPOUT-2048kB                      0                0         
 -------------------------------------------------------------------------------


 64K folios: usemem30: zstd:
 ===========================

 -------------------------------------------------------------------------------
                mm-unstable-2-27-2025           v8             v8
                                                               
 -------------------------------------------------------------------------------
 zswap compressor               zstd          zstd           zstd
 -------------------------------------------------------------------------------
 Total throughput (KB/s)   6,920,374     6,935,013      6,924,096
 Avg throughput (KB/s)       230,679       231,167        230,803
 elapsed time (sec)            94.62         88.77          89.79
 sys time (sec)             2,387.50      2,213.12       2,250.91
                                                                 
 -------------------------------------------------------------------------------
 memcg_high                  764,199       763,887        764,378
 memcg_swap_fail                   0             0              0
 zswpout                  48,917,234    48,897,180     48,928,700
 zswpin                          426           422            430
 pswpout                           0             0              0
 pswpin                            0             0              0
 thp_swpout                        0             0              0
 thp_swpout_fallback               0             0              0
 64kB_swpout_fallback          2,190         2,178          2,231
 pgmajfault                    3,231         3,210          3,206
 anon_fault_alloc_64kB     4,924,864     4,924,556      4,924,192
 ZSWPOUT-64kB              3,055,153     3,053,916      3,055,843
 SWPOUT-64kB                       0             0              0
 -------------------------------------------------------------------------------


 2M folios: usemem30: zstd:
 ==========================

 -------------------------------------------------------------------------------
                mm-unstable-2-27-2025           v8
 -------------------------------------------------------------------------------
 zswap compressor               zstd          zstd
 -------------------------------------------------------------------------------
 Total throughput (KB/s)   7,655,965     7,685,827
 Avg throughput (KB/s)       255,198       256,194
 elapsed time (sec)            86.52         81.10
 sys time (sec)             2,030.63      1,886.54
                                                  
 -------------------------------------------------------------------------------
 memcg_high                   93,106        93,054
 memcg_swap_fail                   0             0
 zswpout                  48,091,648    48,054,576
 zswpin                            0           398
 pswpout                           0             0
 pswpin                            0             0
 thp_swpout                        0             0
 thp_swpout_fallback               8           203
 pgmajfault                    2,794         3,242
 anon_fault_alloc_2048kB     153,736       153,742
 ZSWPOUT-2048kB               93,921        93,678
 SWPOUT-2048kB                     0             0
 -------------------------------------------------------------------------------



Performance testing (Kernel compilation, allmodconfig):
=======================================================

The experiments with kernel compilation test, 32 threads, in tmpfs use the
"allmodconfig" that takes ~12 minutes, and has considerable swapout/swapin
activity. The cgroup's memory.max is set to 2G.


 64K folios: Kernel compilation/allmodconfig:
 ============================================

 --------------------------------------------------------------------------------
                     mm-unstable               v8     mm-unstable              v8
 --------------------------------------------------------------------------------
 zswap compressor    deflate-iaa      deflate-iaa            zstd            zstd   
 --------------------------------------------------------------------------------
 real_sec                 775.83           742.52          769.39          762.85 
 user_sec              15,659.10        15,644.82       15,666.28       15,636.25 
 sys_sec                4,209.69         3,856.43        5,277.86        5,242.89 
 --------------------------------------------------------------------------------
 Max_Res_Set_Size_KB   1,871,116        1,873,212       1,873,200       1,871,732 
 --------------------------------------------------------------------------------
 memcg_high                    0                0               0               0 
 memcg_swap_fail               0                0               0               0 
 zswpout             107,305,181      101,061,420      86,621,912      87,004,261 
 zswpin               32,418,991       29,825,342      25,337,514      25,530,348 
 pswpout                     272              597              94              86 
 pswpin                      274              519              54              84 
 thp_swpout                    0                0               0               0 
 thp_swpout_fallback           0                0               0               0 
 64kB_swpout_fallback        494                0               0               0 
 pgmajfault           34,577,545       31,830,251      26,892,991      27,111,920 
 ZSWPOUT-64kB          3,498,796        3,276,189       2,737,544       2,766,736 
 SWPOUT-64kB                  17               36               4               5 
 --------------------------------------------------------------------------------


With the iaa_crypto driver changes for non-blocking descriptor allocations,
no timeouts-with-mitigations were seen in compress/decompress jobs, for all
of the above experiments.


Summary:
========
The performance testing data with usemem 30 processes and kernel
compilation test show 68%-70% throughput gains and 24%-32% sys time
reduction (usemem30) and 8.4% sys time reduction (kernel compilation) with
zswap_store() large folios using IAA compress batching as compared to
IAA sequential. There is no performance regression for zstd/usemem30
and zstd/kernel compilation allmod config, and even a 7.3% sys time
reduction for zstd/usemem, most likely due to the performance optimizations
implemented in zswap_batch_compress() in patch 14 of v8, such as
likely/unlikely compiler directives to minimize branch mis-predicts, and
the use of prefetchw of the zswap entry before it is written.

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


Changes since v7:
=================
1) Rebased to mm-unstable as of 3-3-2025, commit 5f089a9aa987.
2) Changed the acomp_ctx->nr_reqs to be u8 since ZSWAP_MAX_BATCH_SIZE is
   defined as 8U, for saving memory in this per-cpu structure.
3) Fixed a typo in code comments in acomp_ctx_get_cpu_lock():
   acomp_ctx->initialized to acomp_ctx->__online.
4) Incorporated suggestions from Yosry, Chengming, Nhat and Johannes,
   thanks to all!
   a) zswap_batch_compress() replaces zswap_compress(). Thanks Yosry
      for this suggestion!
   b) Process the folio in sub-batches of ZSWAP_MAX_BATCH_SIZE, regardless
      of whether or not the compressor supports batching. This gets rid of
      the kmalloc(entries), and allows us to allocate an array of
      ZSWAP_MAX_BATCH_SIZE entries on the stack. This is implemented in
      zswap_store_pages().
   c) Use of a common structure and code paths for compressing a folio in
      batches, either as a request chain (in parallel in IAA hardware) or
      sequentially. No code duplication since zswap_compress() has been
      replaced with zswap_batch_compress(), simplifying maintainability.
5) A key difference between compressors that support batching and
   those that do not, is that for the latter, the acomp_ctx mutex is
   locked/unlocked per ZSWAP_MAX_BATCH_SIZE batch, so that decompressions
   to handle page-faults can make progress. This fixes the zstd kernel
   compilation regression seen in v7. For compressors that support
   batching, for e.g. IAA, the mutex is locked/released once for storing
   the folio.
6) Used likely/unlikely compiler directives and prefetchw to restore
   performance with the common code paths.

Changes since v6:
=================
1) Rebased to mm-unstable as of 2-27-2025, commit d58172d128ac.

2) Deleted crypto_acomp_batch_compress() and
   crypto_acomp_batch_decompress() interfaces, as per Herbert's
   suggestion. Batching is instead enabled by chaining the requests. For
   non-batching compressors, there is no request chaining involved. Both,
   batching and non-batching compressions are accomplished by zswap by
   calling:

   crypto_wait_req(crypto_acomp_compress(acomp_ctx->reqs[0]), &acomp_ctx->wait);

3) iaa_crypto implementation of batch compressions/decompressions using
   request chaining, as per Herbert's suggestions.
4) Simplification of the acomp_ctx resource allocation/deletion with
   respect to CPU hot[un]plug, to address Yosry's suggestions to explore the
   mutex options in zswap_cpu_comp_prepare(). Yosry, please let me know if
   the per-cpu memory cost of this proposed change is acceptable (IAA:
   64.8KB, Software compressors: 8.2KB). On the positive side, I believe
   restarting reclaim on a CPU after it has been through an offline-online
   transition, will be much faster by not deleting the acomp_ctx resources
   when the CPU gets offlined.
5) Use of lockdep assertions rather than comments for internal locking
   rules, as per Yosry's suggestion.
6) No specific references to IAA in zswap.c, as suggested by Yosry.
7) Explored various solutions other than the v6 zswap_store_folio()
   implementation, to fix the zstd regression seen in v5, to attempt to
   unify common code paths, and to allocate smaller arrays for the zswap
   entries on the stack. All these options were found to cause usemem30
   latency regression with zstd. The v6 version of zswap_store_folio() is
   the only implementation that does not cause zstd regression, confirmed
   by 10 consecutive runs, each giving quite consistent latency
   numbers. Hence, the v6 implementation is carried forward to v7, with
   changes for branching for batching vs. sequential compression API
   calls.


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




Kanchana P Sridhar (14):
  crypto: acomp - Add synchronous/asynchronous acomp request chaining.
  crypto: acomp - New interfaces to facilitate batching support in acomp
    & drivers.
  crypto: iaa - Add an acomp_req flag CRYPTO_ACOMP_REQ_POLL to enable
    async mode.
  crypto: iaa - Implement batch compression/decompression with request
    chaining.
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
  mm: zswap: Simplify acomp_ctx resource allocation/deletion and mutex
    lock usage.
  mm: zswap: Allocate pool batching resources if the compressor supports
    batching.
  mm: zswap: Compress batching with request chaining in zswap_store() of
    large folios.

 .../driver-api/crypto/iaa/iaa-crypto.rst      |   11 +-
 crypto/acompress.c                            |  285 +++
 drivers/crypto/intel/iaa/iaa_crypto.h         |   30 +-
 drivers/crypto/intel/iaa/iaa_crypto_main.c    | 1556 ++++++++++++-----
 include/crypto/acompress.h                    |   79 +
 include/crypto/algapi.h                       |   10 +
 include/crypto/internal/acompress.h           |   14 +
 include/linux/crypto.h                        |   39 +
 mm/zswap.c                                    |  722 +++++---
 9 files changed, 2043 insertions(+), 703 deletions(-)


base-commit: 5f089a9aa987ccf72df0c6955e168e865f280603
-- 
2.27.0

