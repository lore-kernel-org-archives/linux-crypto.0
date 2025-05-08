Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92E5A22256E;
	Thu,  8 May 2025 19:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746733300; cv=none; b=CoSp+2nFlcoTU6lvF6CUCGdbT1BaVd3bnP/KmFLn2gdvGIvOZtY24t+qQN47OdwJ9HkrfzHgU/kE4j5itEW5LHJ3zV0+fmB1Mkj8fXHDVrH7o/2JXYJmUsMLPkUGyNP8AmP1WBEaCNhq77kAC+7jBViisN0xhPBnUlE7tusJ4/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746733300; c=relaxed/simple;
	bh=MsKqRYuGryph1BrZpATMZy12aKXnlZw6nI4mxSnY7yo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=tO2NxLhAxiOHw9macd2BXpCOK9LhGihb6NeTrq4bjxumNmpZxyZ26BWf0//mz37MOvUOYbQZ4gKFtiONl7Nqms6j61ha+5PDP8ToB/sdVUwJz4p0VQXZFYoA5Mq3tvg3i90563aukeIQfQYrkTukgIHNthVJyv24PBwZnl940LU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Bo6S2dXo; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Bo6S2dXo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746733297; x=1778269297;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=MsKqRYuGryph1BrZpATMZy12aKXnlZw6nI4mxSnY7yo=;
  b=Bo6S2dXoIOlWiwllF5gkeJapuJjITugeFMUttG3Rnu7p8FK4HnKGd+dK
   0RYuVPvim1SpbM/D62ve+wEd5Il11PL2D+WlUc4u4ELt2XDtrn6eEPjFj
   ZO3vM60ssiUwRXP3M6sInfL61xR3H48My+Mjy3OH5NXYdyYBcADL0PmCP
   F1BE18FZzkn9X/XYsMFNpWr9GhgkwARcwKzUMgJO63m48Bw3BRxvXWoKr
   HdoGUXUO+glzdBQmMuzqG9WSrcvlPPPBonOXjB0uNHp9f3yFIcX6o1xaN
   dVlwk2Y1gr3MtP6WMkkEvqDCPl99RCVvF74dyLHobG4zBx/FXOKdNbz4R
   Q==;
X-CSE-ConnectionGUID: ciOtMoSNRBiXJTzgEO9+gQ==
X-CSE-MsgGUID: zu5AZwSFTXyucYx5ShKn3Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="48454543"
X-IronPort-AV: E=Sophos;i="6.15,273,1739865600"; 
   d="scan'208";a="48454543"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 12:41:35 -0700
X-CSE-ConnectionGUID: cDfFBQjoTyuH++/FS3cSxg==
X-CSE-MsgGUID: vBIIl7sJQdWNavn+lOS2lQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,273,1739865600"; 
   d="scan'208";a="136880801"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by fmviesa010.fm.intel.com with ESMTP; 08 May 2025 12:41:34 -0700
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
	senozhatsky@chromium.org,
	linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	clabbe@baylibre.com,
	ardb@kernel.org,
	ebiggers@google.com,
	surenb@google.com,
	kristen.c.accardi@intel.com,
	vinicius.gomes@intel.com
Cc: wajdi.k.feghali@intel.com,
	vinodh.gopal@intel.com,
	kanchana.p.sridhar@intel.com
Subject: [RESEND PATCH v9 00/19] zswap compression batching
Date: Thu,  8 May 2025 12:41:15 -0700
Message-Id: <20250508194134.28392-1-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit


Compression Batching:
=====================

This patch-series introduces batch compression of pages in large folios to
improve zswap swapout latency. It preserves the existing zswap protocols
for non-batching software compressors by calling crypto_acomp sequentially
per page in the batch. Additionally, in support of hardware accelerators
that can process a batch as an integral unit, the patch-series creates
generic batching interfaces in crypto_acomp, and calls the
crypto_acomp_batch_compress() interface in zswap_compress() for compressors
that intrinsically support batching.

The patch series provides a proof point by using the Intel Analytics
Accelerator (IAA) for implementing the compress/decompress batching API
using hardware parallelism in the iaa_crypto driver and another proof point
with a sequential software compressor, zstd.

SUMMARY:
========

  The first proof point is to test with IAA using a sequential call (fully
  synchronous, compress one page at a time) vs. a batching call (fully
  asynchronous, submit a batch to IAA for parallel compression, then poll for
  completion statuses).
  
    The performance testing data with usemem 30 processes and kernel
    compilation test using 32 threads, show 67%-77% throughput gains and
    28%-32% sys time reduction (usemem30) and 2-3% sys time reduction
    (kernel compilation) with zswap_store() large folios using IAA compress
    batching as compared to IAA sequential.

  The second proof point is to make sure that software algorithms such as
  zstd do not regress. The data indicates that for sequential software
  algorithms a performance gain is achieved. 
  
    With the performance optimizations implemented in patches 18 and 19 of
    v9, zstd usemem30 throughput increases by 1%, along with a 6%-8% sys time
    reduction. With kernel compilation using zstd, we get a 0.4%-3.2%
    reduction in sys time. These optimizations pertain to common code
    paths, removing redundant branches/computes, using prefetchw() of the
    zswap entry before it is written, and selectively annotating branches
    with likely()/unlikely() compiler directives to minimize branch
    mis-prediction penalty. Additionally, using the batching code for
    non-batching compressors to sequentially compress/store batches of up
    to ZSWAP_MAX_BATCH_SIZE (8) pages seems to help, most likely due to
    cache locality of working set structures such as the array of
    zswap_entry-s for the batch.
  
    Our internal validation of zstd with the batching interface vs. IAA with
    the batching interface on Emerald Rapids has shown that IAA
    compress/decompress batching gives 21.3% more memory savings as compared
    to zstd, for 5% performance loss as compared to the baseline without any
    memory pressure. IAA batching demonstrates more than 2X the memory
    savings obtained by zstd at this 95% performance KPI.
    The compression ratio with IAA is 2.23, and with zstd 2.96. Even with
    this compression ratio deficit for IAA, batching is extremely
    beneficial. As we improve the compression ratio of the IAA accelerator,
    we expect to see even better memory savings with IAA as compared to
    software compressors.
    

  Batching Roadmap:
  =================

  1) Compression batching within large folios (this series).
  
  2) Reclaim batching of hybrid folios:
  
     We can expect to see even more significant performance and throughput
     improvements if we use the parallelism offered by IAA to do reclaim
     batching of 4K/large folios (really any-order folios), and using the
     zswap_store() high throughput compression pipeline to batch-compress
     pages comprising these folios, not just batching within large
     folios. This is the reclaim batching patch 13 in v1, which we expect
     to submit in a separate patch-series.
  
  3) Decompression batching:

     We have developed a zswap load batching interface for IAA to be used
     for parallel decompression batching, using swapin_readahead().
  
  These capabilities are architected so as to be useful to zswap and
  zram. We are actively working on integrating these components with zram.
  
  v9 Performance Summary:
  =======================

  This is a performance testing summary of results with usemem30
  (30 usemem processes running in a cgroup limited at 150G, each trying to
  allocate 10G).
  
  usemem30 with 64K folios:
  =========================
  
     -----------------------------------------------------------------------
                    mm-unstable-4-21-2025              v9
     -----------------------------------------------------------------------
     zswap compressor         deflate-iaa     deflate-iaa    IAA Batching
                                                                 vs.
                                                             IAA Sequential
     -----------------------------------------------------------------------
     Total throughput (KB/s)    6,091,607      10,174,344         67%
     Avg throughput (KB/s)        203,053         339,144                    
     elapsed time (sec)            100.46           69.70        -31%      
     sys time (sec)              2,416.97        1,648.37        -32%
     -----------------------------------------------------------------------
    
     -----------------------------------------------------------------------
                    mm-unstable-4-21-2025              v9    
     -----------------------------------------------------------------------
     zswap compressor                zstd            zstd    v9 zstd    
                                                             improvement  
     -----------------------------------------------------------------------
     Total throughput (KB/s)    6,574,380       6,632,230          1%
     Avg throughput (KB/s)        219,146         221,074
     elapsed time (sec)             96.58           90.60         -6%
     sys time (sec)              2,416.52        2,224.78         -8%          
     -----------------------------------------------------------------------
    
  usemem30 with 2M folios:
  ========================
  
     ----------------------------------------------------------------------
                     mm-unstable-4-21-2025             v9
     ----------------------------------------------------------------------
     zswap compressor          deflate-iaa    deflate-iaa    IAA Batching
                                                                 vs.
                                                             IAA Sequential
     ----------------------------------------------------------------------
     Total throughput (KB/s)     6,371,048     11,282,935         77%     
     Avg throughput (KB/s)         212,368        376,097              
     elapsed time (sec)              87.15          63.04        -28%     
     sys time (sec)               2,011.56       1,450.45        -28%     
     ----------------------------------------------------------------------
  
     ----------------------------------------------------------------------
                     mm-unstable-4-21-2025             v9      
     ----------------------------------------------------------------------
     zswap compressor                 zstd           zstd    v9 zstd           
                                                             improvement
     ----------------------------------------------------------------------
     Total throughput (KB/s)     7,320,278      7,428,055          1%         
     Avg throughput (KB/s)         244,009        247,601            
     elapsed time (sec)              83.30          81.60         -2%         
     sys time (sec)               1,970.89       1,857.70         -6%         
     ----------------------------------------------------------------------



DETAILS:
========

(A) From zswap's perspective, the most significant changes are:
===============================================================

1) A unified zswap_compress() API is added to compress multiple
   pages:

   - If the compressor has multiple acomp requests, i.e., internally
     supports batching, crypto_acomp_batch_compress() is called. If all
     pages are successfully compressed, the batch is stored in zpool.
   
   - If the compressor can only compress one page at a time, each page
     is compressed and stored sequentially.

   Many thanks to Yosry for this suggestion, because it is an essential
   component of unifying common code paths between sequential/batching
   compressions.

   prefetchw() is used in zswap_compress() to minimize cache-miss
   latency by moving the zswap entry to the cache before it is written
   to; reducing sys time by ~1.5% for zstd (non-batching software
   compression). In other words, this optimization helps both batching and
   software compressors.

   Overall, the prefetchw() and likely()/unlikely() annotations prevent
   regressions with software compressors like zstd, and generally improve
   non-batching compressors' performance with the batching code by ~8%.

2) A new zswap_store_pages() is added, that stores multiple pages in a
   folio in a range of indices. This is an extension of the earlier
   zswap_store_page(), except it operates on a batch of pages.

3) zswap_store() is modified to store the folio's pages in batches
   by calling zswap_store_pages(). If the compressor supports batching,
   i.e., has multiple acomp requests, the folio will be compressed in
   batches of "pool->nr_reqs". If the compressor has only one acomp
   request, the folio will be compressed in batches of
   ZSWAP_MAX_BATCH_SIZE pages, where each page in the batch is
   compressed sequentially. We see better performance by processing
   the folio in batches of ZSWAP_MAX_BATCH_SIZE, due to cache locality
   of working set structures such as the array of zswap_entry-s for the
   batch.

   Many thanks to Yosry and Johannes for steering towards a common
   design and code paths for sequential and batched compressions (i.e.,
   for software compressors and hardware accelerators such as IAA). As per
   Yosry's suggestion in v8, the nr_reqs is an attribute of the
   compressor/pool, and hence is stored in struct zswap_pool instead of in
   struct crypto_acomp_ctx.

4) Simplifications to the acomp_ctx resources allocation/deletion
   vis-a-vis CPU hot[un]plug. This further improves upon v8 of this
   patch-series based on the discussion with Yosry, and formalizes the
   lifetime of these resources from pool creation to pool
   deletion. zswap does not register a CPU hotplug teardown
   callback. The acomp_ctx resources will persist through CPU
   online/offline transitions. The main changes made to avoid UAF/race
   conditions, and correctly handle process migration, are:

   a) No acomp_ctx mutex locking in zswap_cpu_comp_prepare().
   b) No CPU hotplug teardown callback, no acomp_ctx resources deleted.
   c) New acomp_ctx_dealloc() procedure that cleans up the acomp_ctx
      resources, and is shared by zswap_cpu_comp_prepare() error
      handling and zswap_pool_destroy().
   d) The zswap_pool node list instance is removed right after the node
      list add function in zswap_pool_create().
   e) We directly call mutex_[un]lock(&acomp_ctx->mutex) in
      zswap_[de]compress(). acomp_ctx_get_cpu_lock()/acomp_ctx_put_unlock()
      are deleted.

   The commit log of patch 0015 has a more detailed analysis.


(B) Main changes in crypto_acomp and iaa_crypto:
================================================

1) A new architecture is introduced for IAA device WQs' usage as:
   - compress only
   - decompress only
   - generic, i.e., both compress/decompress.

   Further, IAA devices/wqs are assigned to cores based on packages
   instead of NUMA nodes.

   The WQ rebalancing algorithm that is invoked as WQs are
   discovered/deleted has been made very general and flexible so that
   the user can control exactly how IAA WQs are used. In addition to the
   user being able to specify a WQ type as comp/decomp/generic, the user
   can also configure if WQs need to be shared among all same-package
   cores, or, whether the cores should be divided up amongst the
   available IAA devices.

   If distribute_[de]comps is enabled, from a given core's perspective,
   the iaa_crypto driver will distribute comp/decomp jobs among all
   devices' WQs in round-robin manner. This improves batching latency
   and can improve compression/decompression throughput for workloads
   that see a lot of swap activity.

   The commit log of patch 0006 provides more details on new iaa_crypto
   driver parameters added, along with recommended settings.

2) Compress/decompress batching are implemented using
   crypto_acomp_batch_[de]compress(), along the lines of v6 since
   request chaining is no longer the recommended approach.


(C) The patch-series is organized as follows:
=============================================

 1) crypto acomp & iaa_crypto driver enablers for batching: Relevant
    patches are tagged with "crypto:" in the subject:

    Patches 1-4) Backport some of the crypto patches that revert request
                 chaining that are in the cryptodev-2.6 git tree and are
                 yet to be included in mm-unstable. I have also
                 backported the fix to the scomp off-by-one bug. Further, the
                 non-request-chaining implementations of
                 crypto_acomp_[de]compress() are reinstated. Without
                 patches 1/2/3, the crypto/testmgr issues errors that
                 prevent deflate-iaa from being used as zswap's
                 compressor. Once mm-unstable is updated with the
                 request chaining reverts, patches 1/3/4 can be deleted
                 from this patch-series.

    Patch 5) Reorganizes the iaa_crypto driver code into logically related
             sections and avoids forward declarations, in order to facilitate
             subsequent iaa_crypto patches. This patch makes no
             functional changes.

    Patch 6) Makes an infrastructure change in the iaa_crypto driver
             to map IAA devices/work-queues to cores based on packages
             instead of NUMA nodes. This doesn't impact performance on
             the Sapphire Rapids system used for performance
             testing. However, this change fixes functional problems we
             found on Granite Rapids during internal validation, where the
             number of NUMA nodes is greater than the number of packages,
             which was resulting in over-utilization of some IAA devices
             and non-usage of other IAA devices as per the current NUMA
             based mapping infrastructure.

             This patch also develops a new architecture that
             generalizes how IAA device WQs are used. It enables
             designating IAA device WQs as either compress-only or
             decompress-only or generic. Once IAA device WQ types are
             thus defined, it also allows the configuration of whether
             device WQs will be shared by all cores on the package, or
             used only by "mapped cores" obtained by a simple allocation
             of available IAAs to cores on the package.

             As a result of the overhaul of wq_table definition,
             allocation and rebalancing, this patch eliminates
             duplication of device WQs in per-cpu wq_tables, thereby
             saving 140MiB on a 384 cores dual socket Granite Rapids server
             with 8 IAAs.

             Regardless of how the user has configured the WQs' usage,
             the next WQ to use is obtained through a direct look-up in
             per-cpu "cpu_comp_wqs" and "cpu_decomp_wqs" structures so
             as to minimize latency in the critical path driver compress
             and decompress routines.

    Patch 7) Defines a "void *data" in struct acomp_req, in response to
             Herbert's comments in v8 about avoiding use of
             req->base.data. iaa_crypto requires the req->data to
             store the idxd_desc allocated in the core
             iaa_[de]compress() functions, for later retreival in the
             iaa_comp_poll() function to check for the descriptor's
             completion status. This async submit-poll is essential for
             batching.

    Patch 8) Makes a change to iaa_crypto driver's descriptor allocation,
             from blocking to non-blocking with retries/timeouts and
             mitigations in case of timeouts during compress/decompress
             ops. This prevents tasks getting blocked indefinitely, which
             was observed when testing 30 cores running workloads, with
             only 1 IAA enabled on Sapphire Rapids (out of 4). These
             timeouts are typically only encountered, and associated
             mitigations exercised, only in configurations with 1 IAA
             device shared by 30+ cores.

    Patch 9) New CRYPTO_ACOMP_REQ_POLL acomp_req flag to act as a gate for
             async poll mode in iaa_crypto.

   Patch 10) Adds acomp_alg/crypto_acomp interfaces for get_batch_size(),
             batch_compress() and batch_decompress() along with the
             corresponding crypto_acomp_batch_size(),
             crypto_acomp_batch_compress() and
             crypto_acomp_batch_decompress() API for use in zswap.

   Patch 11) iaa-crypto driver implementations for the newly added batching
             interfaces. iaa_crypto implements the crypto_acomp
             get_batch_size() interface that returns an iaa_driver specific
             constant, IAA_CRYPTO_MAX_BATCH_SIZE (set to 8U currently).

             This patch also provides the iaa_crypto driver implementations
             for the batch_compress() and batch_decompress() crypto_acomp
             interfaces.

   Patch 12) Modifies the default iaa_crypto driver mode to async, now that
             iaa_crypto provides a truly async mode that gives
             significantly better latency than sync mode for the batching
             use case.

   Patch 13) Disables verify_compress by default, to facilitate users to
             run IAA easily for comparison with software compressors.


 2) zswap modifications to enable compress batching in zswap_store()
    of large folios (including pmd-mappable folios):

   Patch 14) Moves the zswap CPU hotplug procedures under "pool functions",
             because they are invoked upon pool creation/deletion.

   Patch 15) Simplifies the zswap_pool's per-CPU acomp_ctx resource
             management and lifetime to be from pool creation to pool
             deletion.

   Patch 16) Uses IS_ERR_OR_NULL() in zswap_cpu_comp_prepare() to check for
             valid acomp/req, thereby making it consistent with the resource
             de-allocation code.

   Patch 17) Defines a zswap-specific ZSWAP_MAX_BATCH_SIZE (currently set
             as 8U) to denote the maximum number of acomp_ctx batching
             resources to allocate, thus limiting the amount of extra
             memory used for batching. Further, the "struct
             crypto_acomp_ctx" is modified to contain multiple acomp_reqs
             and buffers. A new "u8 nr_reqs" member is added to "struct
             zswap_pool" to track the number of requests/buffers associated
             with the compressor.

   Patch 18) Modifies zswap_store() to store the folio in batches of
             pool->nr_reqs by calling a new zswap_store_pages() that takes
             a range of indices in the folio to be stored.
             zswap_store_pages() pre-allocates zswap entries for the batch,
             calls zswap_compress() for each page in this range, and stores
             the entries in xarray/LRU.

   Patch 19) Introduces a new unified implementation of zswap_compress()
             for compressors that do and do not support batching. This
             eliminates code duplication and facilitates maintainability of
             the code with the introduction of compress batching. Further,
             there are many optimizations to this common code that result
             in workload throughput and performance improvements with
             software compressors and hardware accelerators such as IAA.

             zstd performance is better or on par with mm-unstable. We
             see impressive throughput/performance improvements with IAA
             batching vs. no-batching.


With v9 of this patch series, the IAA compress batching feature will be
enabled seamlessly on Intel platforms that have IAA by selecting
'deflate-iaa' as the zswap compressor, and using the iaa_crypto 'async'
sync_mode driver attribute (the default).


System setup for testing:
=========================
Testing of this patch-series was done with mm-unstable as of 4-21-2025,
commit 2c01d9f3c611, without and with this patch-series. Data was
gathered on an Intel Sapphire Rapids (SPR) server, dual-socket 56 cores
per socket, 4 IAA devices per socket, 503 GiB RAM and 525G SSD disk
partition swap. Core frequency was fixed at 2500MHz.

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

   IAA WQ Configuration:

   Since usemem sees practically no swapin activity, we set up 1 WQ per
   IAA device, so that all 128 entries are available for compress
   jobs. All IAA's WQs are available to all package cores to send
   compress/decompress jobs in a round-robin manner.

     4 IAA devices
     1 WQ per device
     echo 0 > /sys/bus/dsa/drivers/crypto/g_comp_wqs_per_iaa
     echo 1 > /sys/bus/dsa/drivers/crypto/distribute_comps
     echo 1 > /sys/bus/dsa/drivers/crypto/distribute_decomps

2) Kernel compilation allmodconfig with 2G max memory, 32 threads, with
   these large folios enabled to "always":
   - 64k

   IAA WQ Configuration:

   Since kernel compilation sees considerable swapin activity, we set up
   2 WQs per IAA device, each containing 64 entries. The driver sends
   decompresses to wqX.0 and compresses to wqX.1. All IAAs' wqX.0 are
   available to all package cores to send decompress jobs in a
   round-robin manner. Likewise, all IAAs' wqX.1 are available to all
   package cores to send decompress jobs in a round-robin manner. 

     4 IAA devices
     2 WQs per device
     echo 1 > /sys/bus/dsa/drivers/crypto/g_comp_wqs_per_iaa
     echo 1 > /sys/bus/dsa/drivers/crypto/distribute_comps
     echo 1 > /sys/bus/dsa/drivers/crypto/distribute_decomps


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
                 mm-unstable-4-21-2025             v9
 -------------------------------------------------------------------------------
 zswap compressor         deflate-iaa     deflate-iaa    IAA Batching
                                                             vs.
                                                         IAA Sequential
 -------------------------------------------------------------------------------
 Total throughput (KB/s)    6,091,607      10,174,344         67%
 Avg throughput (KB/s)        203,053         339,144                    
 elapsed time (sec)            100.46           69.70        -31%      
 sys time (sec)              2,416.97        1,648.37        -32%      
                                                                         
 -------------------------------------------------------------------------------
 memcg_high                 1,262,996       1,403,680                    
 memcg_swap_fail                2,712           2,105                    
 zswpout                   58,146,954      64,508,450                    
 zswpin                            91             256                    
 pswpout                            0               0                    
 pswpin                             0               0                    
 thp_swpout                         0               0                    
 thp_swpout_fallback                0               0                    
 64kB_swpout_fallback           2,712           2,105                    
 pgmajfault                     2,858           3,032                    
 ZSWPOUT-64kB               3,631,559       4,029,802   
 SWPOUT-64kB                        0               0   
 -------------------------------------------------------------------------------


 2M folios: usemem30: deflate-iaa:
 =================================

 -------------------------------------------------------------------------------
                 mm-unstable-4-21-2025              v9
 -------------------------------------------------------------------------------
 zswap compressor          deflate-iaa     deflate-iaa     IAA Batching
                                                               vs.
                                                           IAA Sequential
 -------------------------------------------------------------------------------
 Total throughput (KB/s)     6,371,048      11,282,935       77%     
 Avg throughput (KB/s)         212,368         376,097              
 elapsed time (sec)              87.15           63.04      -28%     
 sys time (sec)               2,011.56        1,450.45      -28%     
                                                                    
 -------------------------------------------------------------------------------
 memcg_high                    116,156         125,138             
 memcg_swap_fail                   348             248             
 zswpout                    59,815,486      64,509,928             
 zswpin                            442             422             
 pswpout                             0               0             
 pswpin                              0               0             
 thp_swpout                          0               0             
 thp_swpout_fallback               348             248             
 pgmajfault                      3,575           3,272             
 ZSWPOUT-2048kB                116,480         125,759        
 SWPOUT-2048kB                       0               0        
 -------------------------------------------------------------------------------


 64K folios: usemem30: zstd:
 ===========================

 -------------------------------------------------------------------------------
               mm-unstable-4-21-2025            v9       
 -------------------------------------------------------------------------------
 zswap compressor               zstd          zstd       v9 zstd    
                                                         improvement  
 -------------------------------------------------------------------------------
 Total throughput (KB/s)   6,574,380     6,632,230        1%
 Avg throughput (KB/s)       219,146       221,074
 elapsed time (sec)            96.58         90.60       -6%
 sys time (sec)             2,416.52      2,224.78       -8%          
                                                  
 -------------------------------------------------------------------------------
 memcg_high                1,117,577     1,110,504
 memcg_swap_fail                  65         2,217
 zswpout                  48,771,672    48,806,988
 zswpin                          137           429
 pswpout                           0             0
 pswpin                            0             0
 thp_swpout                        0             0
 thp_swpout_fallback               0             0
 64kB_swpout_fallback             65         2,217
 pgmajfault                    3,286         3,224
 ZSWPOUT-64kB              3,048,122     3,048,198
 SWPOUT-64kB                       0             0
 -------------------------------------------------------------------------------


 2M folios: usemem30: zstd:
 ==========================

 -------------------------------------------------------------------------------
               mm-unstable-4-21-2025            v9      
 -------------------------------------------------------------------------------
 zswap compressor               zstd          zstd      v9 zstd           
                                                        improvement
 -------------------------------------------------------------------------------
 Total throughput (KB/s)   7,320,278     7,428,055       1%         
 Avg throughput (KB/s)       244,009       247,601                 
 elapsed time (sec)            83.30         81.60      -2%         
 sys time (sec)             1,970.89      1,857.70      -6%         
                                                   
 -------------------------------------------------------------------------------
 memcg_high                   92,970        92,708 
 memcg_swap_fail                  59           172 
 zswpout                  48,043,615    47,896,223
 zswpin                           77           416 
 pswpout                           0             0 
 pswpin                            0             0 
 thp_swpout                        0             0 
 thp_swpout_fallback              59           172 
 pgmajfault                    2,815         3,170 
 ZSWPOUT-2048kB               93,776        93,381 
 SWPOUT-2048kB                     0             0 
 -------------------------------------------------------------------------------



Performance testing (Kernel compilation, allmodconfig):
=======================================================

The experiments with kernel compilation test use 32 threads and build
the "allmodconfig" that takes ~14 minutes, and has considerable
swapout/swapin activity. The cgroup's memory.max is set to 2G.


 64K folios: Kernel compilation/allmodconfig:
 ============================================

 -------------------------------------------------------------------------------
                       mm-unstable               v9    mm-unstable            v9
 -------------------------------------------------------------------------------
 zswap compressor      deflate-iaa      deflate-iaa           zstd          zstd   
 -------------------------------------------------------------------------------
 real_sec                   835.31           837.75         858.73        852.22
 user_sec                15,649.58        15,660.48      15,682.66     15,649.91
 sys_sec                  3,705.03         3,642.59       4,858.46      4,703.58
 -------------------------------------------------------------------------------
 Max_Res_Set_Size_KB     1,874,524        1,872,200      1,871,248     1,870,972
 -------------------------------------------------------------------------------
 memcg_high                      0                0              0             0
 memcg_swap_fail                 0                0              0             0
 zswpout                89,767,776       91,376,740     76,444,847    73,771,346
 zswpin                 26,362,204       27,700,717     22,138,662    21,287,433
 pswpout                       360              574             52           154
 pswpin                        275              551             19            63
 thp_swpout                      0                0              0             0
 thp_swpout_fallback             0                0              0             0
 64kB_swpout_fallback            0            1,523              0             0
 pgmajfault             27,938,009       29,559,339     23,339,818    22,458,108
 ZSWPOUT-64kB            2,958,806        2,992,126      2,444,259     2,382,986
 SWPOUT-64kB                    21               30              3             8
 -------------------------------------------------------------------------------


 2M folios: Kernel compilation/allmodconfig:
 ===========================================

 -------------------------------------------------------------------------------
                       mm-unstable               v9    mm-unstable            v9
 -------------------------------------------------------------------------------
 zswap compressor      deflate-iaa      deflate-iaa           zstd          zstd   
 -------------------------------------------------------------------------------
 real_sec                   790.66           789.01         818.46        819.08
 user_sec                15,757.60        15,759.57      15,785.34     15,777.70
 sys_sec                  4,307.92         4,184.09       5,602.95      5,582.45
 -------------------------------------------------------------------------------
 Max_Res_Set_Size_KB     1,871,100        1,872,892      1,872,892     1,872,888
 -------------------------------------------------------------------------------
 memcg_high                      0                0              0             0
 memcg_swap_fail                 0                0              0             0
 zswpout               107,349,845      101,481,140     90,083,661    90,818,923
 zswpin                 37,486,883       35,081,184     29,823,462    29,597,292
 pswpout                     3,664            1,191          1,066         1,617
 pswpin                      1,594              138             37         1,594
 thp_swpout                      7                2              2             3
 thp_swpout_fallback         9,434            8,100          6,354         5,809
 pgmajfault             38,781,821       36,235,171     30,677,937    30,442,685
 ZSWPOUT-2048kB              8,810            7,772          7,857         8,515
 -------------------------------------------------------------------------------


With the iaa_crypto driver changes for non-blocking descriptor allocations,
no timeouts-with-mitigations were seen in compress/decompress jobs, for all
of the above experiments.



Changes since v8:
=================
1) Rebased to mm-unstable as of 4-21-2025, commit 2c01d9f3c611.
2) Backported commits for reverting request chaining, since these are
   in cryptodev-2.6 but not yet in mm-unstable: without these backports,
   deflate-iaa is non-functional in mm-unstable:
   commit 64929fe8c0a4 ("crypto: acomp - Remove request chaining")
   commit 5976fe19e240 ("Revert "crypto: testmgr - Add multibuffer acomp
                         testing"")
   Backported this hotfix as well:
   commit 002ba346e3d7 ("crypto: scomp - Fix off-by-one bug when
   calculating last page").
3) crypto_acomp_[de]compress() restored to non-request chained
   implementations since request chaining has been removed from acomp in
   commit 64929fe8c0a4 ("crypto: acomp - Remove request chaining").
4) New IAA WQ architecture to denote WQ type and whether or not a WQ
   should be shared among all package cores, or only to the "mapped"
   ones from an even cores-to-IAA distribution scheme.
5) Compress/decompress batching are implemented in iaa_crypto using new
   crypto_acomp_batch_compress()/crypto_acomp_batch_decompress() API.
6) Defines a "void *data" in struct acomp_req, based on Herbert advising
   against using req->base.data in the driver. This is needed for async
   submit-poll to work.
7) In zswap.c, moved the CPU hotplug callbacks to reside in "pool
   functions", per Yosry's suggestion to move procedures in a distinct
   patch before refactoring patches.
8) A new "u8 nr_reqs" member is added to "struct zswap_pool" to track
   the number of requests/buffers associated with the per-cpu acomp_ctx,
   as per Yosry's suggestion.
9) Simplifications to the acomp_ctx resources allocation, deletion,
   locking, and for these to exist from pool creation to pool deletion,
   based on v8 code review discussions with Yosry.
10) Use IS_ERR_OR_NULL() consistently in zswap_cpu_comp_prepare() and
    acomp_ctx_dealloc(), as per Yosry's v8 comment.
11) zswap_store_folio() is deleted, and instead, the loop over
    zswap_store_pages() is moved inline in zswap_store(), per Yosry's
    suggestion.
12) Better structure in zswap_compress(), unified procedure that
    compresses/stores a batch of pages for both, non-batching and
    batching compressors. Renamed from zswap_batch_compress() to
    zswap_compress(): Thanks Yosry for these suggestions.


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



Kanchana P Sridhar (19):
  crypto: acomp - Remove request chaining
  crypto: acomp - Reinstate non-chained crypto_acomp_[de]compress().
  Revert "crypto: testmgr - Add multibuffer acomp testing"
  crypto: scomp - Fix off-by-one bug when calculating last page
  crypto: iaa - Re-organize the iaa_crypto driver code.
  crypto: iaa - New architecture for IAA device WQ comp/decomp usage &
    core mapping.
  crypto: iaa - Define and use req->data instead of req->base.data.
  crypto: iaa - Descriptor allocation timeouts with mitigations in
    iaa_crypto.
  crypto: iaa - CRYPTO_ACOMP_REQ_POLL acomp_req flag for sequential vs.
    parallel.
  crypto: acomp - New interfaces to facilitate batching support in acomp
    & drivers.
  crypto: iaa - Implement crypto_acomp batching interfaces for Intel
    IAA.
  crypto: iaa - Enable async mode and make it the default.
  crypto: iaa - Disable iaa_verify_compress by default.
  mm: zswap: Move the CPU hotplug procedures under "pool functions".
  mm: zswap: Per-CPU acomp_ctx resources exist from pool creation to
    deletion.
  mm: zswap: Consistently use IS_ERR_OR_NULL() to check acomp_ctx
    resources.
  mm: zswap: Allocate pool batching resources if the compressor supports
    batching.
  mm: zswap: zswap_store() will process a folio in batches.
  mm: zswap: Batched zswap_compress() with compress batching of large
    folios.

 .../driver-api/crypto/iaa/iaa-crypto.rst      |  145 +-
 crypto/acompress.c                            |  112 +-
 crypto/scompress.c                            |   28 +-
 crypto/testmgr.c                              |  147 +-
 drivers/crypto/intel/iaa/iaa_crypto.h         |   30 +-
 drivers/crypto/intel/iaa/iaa_crypto_main.c    | 1934 ++++++++++++-----
 include/crypto/acompress.h                    |  129 +-
 include/crypto/internal/acompress.h           |   25 +-
 mm/zswap.c                                    |  684 +++---
 9 files changed, 2199 insertions(+), 1035 deletions(-)


base-commit: 2c01d9f3c61101355afde90dc5c0b39d9a772ef3
-- 
2.27.0

