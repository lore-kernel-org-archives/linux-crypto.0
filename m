Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F0951C4A3D;
	Fri, 28 Feb 2025 10:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740736828; cv=none; b=JaHy3if+4lctE4a1u+kPaqQtS3ykaXUgZW1X+AVqZGxux7sxdMPtrKc0edrB3HspabXkxJxv28tccK8a4z2UDvcrNhE9LMwBjyqifMxrMirkVxjGbcZcGptXqIwT8qpSs5NR5sWERCW1i5U+ttbLaGlhFG1wNZFstOPLuO2Pd9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740736828; c=relaxed/simple;
	bh=wnL3/GEbkOjaIqLUyvC6m21CR6e5xna3inhd7d7WuRQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=FISbpVZfx6Bay+wyMPH/grN75+tX9N4FvIEoQdj33PcRswGzK4pegbMfY3pmDlGGvMFK7DKoOpEYqgT/11I4cFkf5qx0HgjbrFvXhccIXhrpoqbhkozQpHD3758pYl/CWO6vpbwMmgFmEJ2wUjIqKvamr0D/OS4dtSqdo7bi5+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bZBE7A5Q; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bZBE7A5Q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740736826; x=1772272826;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=wnL3/GEbkOjaIqLUyvC6m21CR6e5xna3inhd7d7WuRQ=;
  b=bZBE7A5QTRhfkhatjRzDgEyZLaSQlaGR/32F1luAm5ma5BPcgIxYdh4u
   3RkJmwLrbsiSJpWbA3w5zYWzxNiijqfZlU9cu2O8sOLdTTZIqF5Wbk1jg
   eMWxi2O1fMtknPqQp4XkXnYzQK5YgGkD5qnp1cqY+vvWqY+z4yBklNaq9
   apmnbtAxL65CqseLjigiTnLpqWdyHk06UdQtRS5KFHj9xI2tP++j9j9Vh
   dDNaXAF9Gq8fOsKtKKja3+T5ElN9VUDEuo19guEh1/6ITHARkGtxawzb6
   fylaemeqMjaMfEIFTCVSlDfDQYgjOpqeV2YfLVHMbzuvCQlfwllAi2gMI
   A==;
X-CSE-ConnectionGUID: XkUyFPV/QDeYPFV8zbh2lQ==
X-CSE-MsgGUID: v8zzWHe6S8eta23YCykxUQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11358"; a="40902549"
X-IronPort-AV: E=Sophos;i="6.13,322,1732608000"; 
   d="scan'208";a="40902549"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2025 02:00:25 -0800
X-CSE-ConnectionGUID: 8xXoEtFuQIa/5RDezMW42Q==
X-CSE-MsgGUID: uFNPoafiTKaWKNJX/LKIAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,322,1732608000"; 
   d="scan'208";a="117325684"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa006.jf.intel.com with ESMTP; 28 Feb 2025 02:00:25 -0800
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
Subject: [PATCH v7 00/15] zswap IAA compress batching
Date: Fri, 28 Feb 2025 02:00:09 -0800
Message-Id: <20250228100024.332528-1-kanchana.p.sridhar@intel.com>
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

From zswap's perspective, the notable changes are:

1) New zswap_batch_compress() API that constructs a chain of requests
   corresponding to multiple pages in a folio that need to be compressed as
   a batch. It proceeds to call crypto_acomp_compress() with the head
   request in the chain. Thus, the calls to crypto in
   zswap_batch_compress() and zswap_compress() are exactly the same.

   crypto_wait_req(crypto_acomp_compress(acomp_ctx->reqs[0]), &acomp_ctx->wait);

2) A "unified" zswap_store_folio() that compresses a folio in batches or
   one page at a time; by calling zswap_batch_compress() or
   zswap_compress(), respectively.
3) A simplification of the acomp_ctx resources allocation/deletion
   vis-a-vis CPU hot[un]plug. v7 of this patch-series proposes that these
   resources are not destroyed during CPU offlining, rather have a lifespan
   that tracks the zswap_pool's: from pool creation to pool deletion. This
   is in response to Yosry's comments in v6 with regards to exploring mutex
   locking options in zswap_cpu_comp_prepare().

Improvements seen with v7's IAA compress batching with request chaining
vs. IAA sequential:

usemem30 with 64K folios:
  61% higher throughput
  32% lower elapsed time
  37% lower sys time 

usemem30 with 2M folios:
  73% higher throughput
  27% lower elapsed time
  27% lower sys time 


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
             zswap_store_folio(), which in turn allocates zswap entries
             for all folio pages upfront, then calls zswap_compress() for
             each folio page.

   Patch 15) Introduces zswap_batch_compress(). We modify
             zswap_store_folio() to detect if the compressor supports
             batching. If so, the "acomp_ctx->nr_reqs" becomes the batch
             size and the folio is compressed in batches with
             zswap_batch_compress(). With IAA, up to 8 pages will be
             compressed in parallel in hardware.

             For non-batching compressors, or if the folio has only one
             page, zswap_compress() is invoked per page in the folio.

             The conditional "if (batching) {..} else {..}" in
             zswap_store_folio() inlines the code that calls
             zswap_batch_compress() by iterating over the folio pages in
             batch_size chunks. Moving this into a separate procedure adds
             latency to IAA batching of 2M folios.

             zstd performance is on par with mm-unstable. We see impressive
             throughput/performance improvements with IAA batching
             vs. no-batching.


With v7 of this patch series, the IAA compress batching feature will be
enabled seamlessly on Intel platforms that have IAA by selecting
'deflate-iaa' as the zswap compressor, and using the iaa_crypto 'async'
sync_mode driver attribute.

[1]: https://lore.kernel.org/linux-crypto/677614fbdc70b31df2e26483c8d2cd1510c8af91.1730021644.git.herbert@gondor.apana.org.au/
[2]: https://patchwork.kernel.org/project/linux-mm/patch/20241221063119.29140-3-kanchana.p.sridhar@intel.com/


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
                 mm-unstable-2-27-2025             v7
 -------------------------------------------------------------------------------
 zswap compressor         deflate-iaa     deflate-iaa    IAA Batching
                                                             vs.
                                                           Sequential
 -------------------------------------------------------------------------------
 Total throughput (KB/s)    6,025,001       9,674,460         61%      
 Avg throughput (KB/s)        200,833         322,482                    
 elapsed time (sec)            100.25           68.35        -32%      
 sys time (sec)              2,414.12        1,517.49        -37%      
                                                                         
 -------------------------------------------------------------------------------
 memcg_high                   909,501         964,110                    
 memcg_swap_fail                1,580           2,398                    
 zswpout                   58,342,295      61,715,859                    
 zswpin                           425             415                    
 pswpout                            0               0                    
 pswpin                             0               0                    
 thp_swpout                         0               0                    
 thp_swpout_fallback                0               0                    
 64kB_swpout_fallback           1,580           2,398                    
 pgmajfault                     3,311           3,190                    
 anon_fault_alloc_64kB      4,924,571       4,923,764                   
 ZSWPOUT-64kB               3,644,769       3,854,809   
 SWPOUT-64kB                        0               0   
 -------------------------------------------------------------------------------


 2M folios: usemem30: deflate-iaa:
 =================================


 -------------------------------------------------------------------------------
                 mm-unstable-2-27-2025              v7
 -------------------------------------------------------------------------------
 zswap compressor          deflate-iaa     deflate-iaa     IAA Batching
                                                               vs.
                                                            Sequential
 -------------------------------------------------------------------------------
 Total throughput (KB/s)     6,374,303      11,094,182         73%     
 Avg throughput (KB/s)         212,476         369,806                
 elapsed time (sec)              87.04           63.44        -27%     
 sys time (sec)               2,012.30        1,458.23        -27%     
                                                                      
 -------------------------------------------------------------------------------
 memcg_high                    115,322         125,099                
 memcg_swap_fail                   568               5                
 zswpout                   559,323,303      64,510,976                
 zswpin                            518               0                
 pswpout                             0               0                
 pswpin                              0               0                
 thp_swpout                          0               0                
 thp_swpout_fallback               568               5                
 pgmajfault                      3,298           2,755                
 anon_fault_alloc_2048kB       153,734         153,737               
 ZSWPOUT-2048kB                115,321         125,993           
 SWPOUT-2048kB                       0               0           
 -------------------------------------------------------------------------------


 64K folios: usemem30: zstd:
 ===========================

 -------------------------------------------------------------------------------
                mm-unstable-2-27-2025           v7

 -------------------------------------------------------------------------------
 zswap compressor               zstd          zstd
 -------------------------------------------------------------------------------
 Total throughput (KB/s)   6,920,374     6,939,253
 Avg throughput (KB/s)       230,679       231,308
 elapsed time (sec)            94.62         88.64
 sys time (sec)             2,387.50      2,197.54
                                                  
 -------------------------------------------------------------------------------
 memcg_high                  764,423       764,477
 memcg_swap_fail               1,236             9
 zswpout                  48,928,758    48,928,583
 zswpin                          421            69
 pswpout                           0             0
 pswpin                            0             0
 thp_swpout                        0             0
 thp_swpout_fallback               0             0
 64kB_swpout_fallback          1,236             9
 pgmajfault                    3,196         2,857
 anon_fault_alloc_64kB     4,924,288     4,924,102
 ZSWPOUT-64kB              3,056,753     3,057,986
 SWPOUT-64kB                       0             0
 -------------------------------------------------------------------------------


 2M folios: usemem30: zstd:
 ==========================

 -------------------------------------------------------------------------------
                mm-unstable-2-27-2025           v7
 -------------------------------------------------------------------------------
 zswap compressor               zstd          zstd
 -------------------------------------------------------------------------------
 Total throughput (KB/s)   7,655,965     7,808,124
 Avg throughput (KB/s)       255,198       260,270
 elapsed time (sec)            86.52         79.94
 sys time (sec)             2,030.63      1,862.74
                                                  
 -------------------------------------------------------------------------------
 memcg_high                   93,036        93,008
 memcg_swap_fail                 143           165
 zswpout                  48,062,240    48,064,321
 zswpin                          439           428
 pswpout                           0             0
 pswpin                            0             0
 thp_swpout                        0             0
 thp_swpout_fallback             143           165
 pgmajfault                    3,246         3,254
 anon_fault_alloc_2048kB     153,739       153,737
 ZSWPOUT-2048kB               93,726        93,712
 SWPOUT-2048kB                     0             0
 -------------------------------------------------------------------------------



Performance testing (Kernel compilation, allmodconfig):
=======================================================

The experiments with kernel compilation test, 32 threads, in tmpfs use the
"allmodconfig" that takes ~12 minutes, and has considerable swapout/swapin
activity. The cgroup's memory.max is set to 2G.


 64K folios: Kernel compilation/allmodconfig:
 ============================================

 -------------------------------------------------------------------------------
                     mm-unstable               v7   mm-unstable            v7
 -------------------------------------------------------------------------------
 zswap compressor    deflate-iaa      deflate-iaa          zstd          zstd   
 -------------------------------------------------------------------------------
 real_sec                 775.83           765.90        769.39        772.63 
 user_sec              15,659.10        15,659.14     15,666.28     15,665.98 
 sys_sec                4,209.69         4,040.44      5,277.86      5,358.61 
 -------------------------------------------------------------------------------
 Max_Res_Set_Size_KB   1,871,116        1,874,128     1,873,200     1,873,488 
 -------------------------------------------------------------------------------
 memcg_high                    0                0             0             0 
 memcg_swap_fail               0                0             0             0 
 zswpout             107,305,181      106,985,511    86,621,912    89,355,274 
 zswpin               32,418,991       32,184,517    25,337,514    26,522,042 
 pswpout                     272               80            94            16 
 pswpin                      274               69            54            16 
 thp_swpout                    0                0             0             0 
 thp_swpout_fallback           0                0             0             0 
 64kB_swpout_fallback        494                0             0             0 
 pgmajfault           34,577,545       34,333,290    26,892,991    28,132,682 
 ZSWPOUT-64kB          3,498,796        3,460,751     2,737,544     2,823,211 
 SWPOUT-64kB                  17                4             4             1 
 -------------------------------------------------------------------------------


With the iaa_crypto driver changes for non-blocking descriptor allocations,
no timeouts-with-mitigations were seen in compress/decompress jobs, for all
of the above experiments.


Summary:
========
The performance testing data with usemem 30 processes and kernel
compilation test show 61%-73% throughput gains and 27%-37% sys time
reduction (usemem30) and 4% sys time reduction (kernel compilation) with
zswap_store() large folios using IAA compress batching as compared to
IAA sequential. There is no performance regression for zstd/usemem30 and a
slight 1.5% sys time zstd regression with kernel compilation allmod
config.

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




Kanchana P Sridhar (15):
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
  mm: zswap: Restructure & simplify zswap_store() to make it amenable
    for batching.
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
 mm/zswap.c                                    |  655 +++++--
 9 files changed, 2028 insertions(+), 651 deletions(-)


base-commit: d58172d128acbafa2295aa17cc96e28260da9a86
-- 
2.27.0

