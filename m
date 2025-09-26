Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C4A08834;
	Fri, 26 Sep 2025 03:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758857709; cv=none; b=lMPEVDhjOXwOI2hnyoSmOV2qOTBCxjMy39UpeNsXcU650nz2W+YPD3NP3Idby7uSJCrBYrz0djP1JN/W9/ZwoGx0apz9+Fj/AHjyRzhdGJ65LWmIwiZ/CoE5jvFnAkZALX0iEa7kWX+Z3u4bmXp3aINhSP99xsGddPpN7yBIug8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758857709; c=relaxed/simple;
	bh=+TjA12X49TPvhzpMGTehrIkb0T34P6drPBGLV7IftZY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=hABeTgq8j/6t2vDwopSiMAJqQ6snERSqHD8M+oA/zAXvTM4eZbPlqi6v747IAESDBrhPQg9fx9rhek0UrDuRyoc2SFZG2x+DjnjjPuXZxF59LBUlD78Nm7lAhzCOw1+E33N5mWiNCb3z/rmbDG7iSxp6No9Eyb+BpwHcGqx+kNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R/MTHUDn; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R/MTHUDn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758857705; x=1790393705;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=+TjA12X49TPvhzpMGTehrIkb0T34P6drPBGLV7IftZY=;
  b=R/MTHUDnc/XC1LDdl9QxHxB/GKHMCy6kwj08nPX/rYYSccH9TjS94t3v
   TopTecLjC7KP7HrGoOfZ/QwIr00N7uMSUODi8w0mqxfkLmNZzEhZRbUKC
   9qQfdPTO/tTyju4RtYYp+Ey7TkQIt2qiLrcUsqAVOr6XblXUh2QZKqa6n
   uJ8PxnHg96IQNX2/4u36JN6B79dYoNXoZovidqNaUfAM2FPZ7bcqWVlLq
   vFxJ5za6xx5EJSIGcGE/cKQqipnTSVWwsVQjMIdFW962iENRQF5GRd3ny
   iINylyHRzYf5UcZ19ZD1L81Md9h5N4LX3mgnmkoaMCuIdOxfn4GIZ1ETj
   Q==;
X-CSE-ConnectionGUID: in0qeKvRTJuOf07OXGg3gQ==
X-CSE-MsgGUID: JINznULtSaGqO4wsHmpEoQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11564"; a="63819382"
X-IronPort-AV: E=Sophos;i="6.18,294,1751266800"; 
   d="scan'208";a="63819382"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 20:35:03 -0700
X-CSE-ConnectionGUID: VwgNdcG6QAeeyBwPHDuB7A==
X-CSE-MsgGUID: 1KGfrvOgTGylu94CvqyrWg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,294,1751266800"; 
   d="scan'208";a="214636544"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa001.jf.intel.com with ESMTP; 25 Sep 2025 20:35:02 -0700
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
	sj@kernel.org,
	kasong@tencent.com,
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
Subject: [PATCH v12 00/23] zswap compression batching with optimized iaa_crypto driver
Date: Thu, 25 Sep 2025 20:34:39 -0700
Message-Id: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit


v12: zswap compression batching with optimized iaa_crypto driver

Based on Herbert's suggestions, the most significant change in v12 is, the
batching interfaces from zswap to crypto, from crypto to iaa_crypto, and
the batching implementation within iaa_crypto now use the folio directly as the
source (sg_page_iter for retrieving pages) and destination SG lists. A unit_size
has been added to struct acomp_req, with kernel users such as zswap using the
new acomp_request_set_unit_size() API to set the unit size to use while breaking
down the request's src/dst scatterlists. zswap sets the unit-size to PAGE_SIZE.

Following Andrew's suggestion, the next two paragraphs emphasize generality and
alignment with current kernel efforts.

Architectural considerations for the zswap batching framework:
==============================================================
We have designed the zswap batching framework to be
hardware-agnostic. It has no dependencies on Intel-specific features and
can be leveraged by any hardware accelerator or software-based
compressor. In other words, the framework is open and inclusive by
design.

Other ongoing work that can use batching:
=========================================
This patch-series demonstrates the performance benefits of compress
batching when used in zswap_store() of large folios. shrink_folio_list()
"reclaim batching" of any-order folios is the next major work that uses
this zswap compress batching framework: our testing of kernel_compilation
with writeback and the zswap shrinker indicates 10X fewer pages get
written back when we reclaim 32 folios as a batch, as compared to one
folio at a time: this is with deflate-iaa and with zstd. We expect to
submit a patch-series with this data and the resulting performance
improvements shortly. Reclaim batching relieves memory pressure faster
than reclaiming one folio at a time, hence alleviates the need to scan
slab memory for writeback.

Many thanks to Nhat for suggesting ideas on using batching with the
ongoing kcompressd work, as well as beneficially using decompression
batching & block IO batching to improve zswap writeback efficiency.

Experiments with kernel compilation benchmark (allmod config) that
combine zswap compress batching, reclaim batching, swapin_readahead()
decompression batching of prefetched pages, and writeback batching show
that 0 pages are written back to disk with deflate-iaa and zstd. For
comparison, the baselines for these compressors see 200K-800K pages
written to disk.

To summarize, these are future clients of the batching framework:

   - shrink_folio_list() reclaim batching of multiple folios:
       Implemented, will submit patch-series.
   - zswap writeback with decompress batching:
       Implemented, will submit patch-series.
   - zram:
       Implemented, will submit patch-series.
   - kcompressd:
       Not yet implemented.
   - file systems:
       Not yet implemented.
   - swapin_readahead() decompression batching of prefetched pages:
       Implemented, will submit patch-series.


iaa_crypto Driver Rearchitecting and Optimizations:
===================================================

The most significant highlight of v11 is a new, lightweight and highly
optimized iaa_crypto driver, resulting directly in the latency and
throughput improvements noted later in this cover letter.

 1) Better stability, more functionally versatile to support zswap and
    zram with better performance on different Intel platforms.

    a) Patches 0002, 0005 and 0010 together resolve a race condition in
       mainline v6.15, reported from internal validation, when IAA
       wqs/devices are disabled while workloads are using IAA.

    b) Patch 0002 introduces a new architecture for mapping cores to
       IAAs based on packages instead of NUMA nodes, and generalizing
       how WQs are used: as package level shared resources for all
       same-package cores (default for compress WQs), or dedicated to
       mapped cores (default for decompress WQs). Further, users are
       able to configure multiple WQs and specify how many of those are
       for compress jobs only vs. decompress jobs only. sysfs iaa_crypto
       driver parameters can be used to change the default settings for
       performance tuning.

    c) idxd descriptor allocation moved from blocking to non-blocking
       with retry limits and mitigations if limits are exceeded.

    d) Code cleanup for readability and clearer code flow.

    e) Fixes IAA re-registration errors upon disabling/enabling IAA wqs
       and devices that exists in the mainline v6.15.

    f) Rearchitecting iaa_crypto to be independent of crypto_acomp to
       enable a zram/zcomp backend_deflate_iaa.c, while fully supporting
       the crypto_acomp interfaces for zswap. A new
       include/linux/iaa_comp.h is added.

    g) New Dynamic compression mode for Granite Rapids to get better
       compression ratio by echo-ing 'deflate-iaa-dynamic' as the zswap
       compressor.

    h) New crypto_acomp API crypto_acomp_batch_size() that will return
       the driver's max batch size if the driver has registered a batch_size
       that's greater than 1; or 1 if there is no driver specific definition of
       batch_size.

       Accordingly, iaa_crypto sets the acomp_alg batch_size to its internal
       IAA_CRYPTO_MAX_BATCH_SIZE for fixed and dynamic modes.

    i) A versatile set of interfaces independent of crypto_acomp for use
       in developing a zram zcomp backend for iaa_crypto.

 2) Performance optimizations (please refer to the latency data per
    optimization in the commit logs):

    a) Distributing [de]compress jobs in round-robin manner to available
       IAAs on package.

    b) Replacing the compute-intensive iaa_wq_get()/iaa_wq_put() with a
       percpu_ref in struct iaa_wq, thereby eliminating acquiring a
       spinlock in the fast path, while using a combination of the
       iaa_crypto_enabled atomic with spinlocks in the slow path to
       ensure the compress/decompress code sees a consistent state of the
       wq tables.
       
    c) Directly call movdir64b for non-irq use cases, i.e., the most
       common usage. Avoid the overhead of irq-specific computes in
       idxd_submit_desc() to gain latency.

    d) Batching of compressions/decompressions using async submit-poll
       mechanism to derive the benefits of hardware parallelism.

    e) Batching compressors need to manage their own "requests"
       abstraction, and remove this driver-specific aspect from being
       managed by kernel users such as zswap. iaa_crypto maintains
       per-CPU "struct iaa_req **reqs" to submit multiple jobs to the
       hardware accelerator to run in parallel.

    f) Modifies the iaa_crypto batching API and their implementation to expect a
       src SG list that contains the batch's pages and a dst SG list that has
       multiple scatterlists for the batch's output buffers. 

    g) Submit the two largest data buffers first for decompression
       batching, so that the longest running jobs get a head start,
       reducing latency for the batch.


Main Changes in Zswap Compression Batching:
===========================================

 Note to zswap maintainers:
 --------------------------
 Patches 20 and 21 can be reviewed and improved/merged independently
 of this series, since they are zswap centric. These 2 patches help
 batching but the crypto_acomp_batch_size() from the iaa_crypto commits
 in this series is not a requirement, unlike patches 22-23.
 
 1) v12 preserves the pool acomp_ctx resources creation/deletion
    simplification of v11, namely, lasting from pool creation-deletion,
    persisting through CPU hot[un]plug operations. Further, zswap no
    longer needs to create multiple "struct acomp_req" in the per-CPU
    acomp_ctx. zswap only needs to manage multiple "u8 **buffers".

 2) We store the compressor's batch-size (@pool->compr_batch_size) and
    the batch-size to use during compression batching
    (@pool->store_batch_size) directly in struct zswap_pool for quick
    retrieval in the zswap_store() fast path.

 3) Optimizations to not cause regressions in software compressors with
    the introduction of the new unified zswap_compress() framework that
    implements compression batching for all compressors. These optimizations
    help recover the performance for non-batching compressors:

    a) kmem_cache_alloc_bulk(), kmem_cache_free_bulk() to allocate/free
       batch zswap_entry-s. These kmem_cache API allow allocator
       optimizations with internal locks for multiple allocations.

    b) Writes to the zswap_entry right after it is allocated without
       modifying the publishing order. This avoids different code blocks
       in zswap_store_pages() having to bring the zswap_entries to the
       cache for writing, potentially evicting other working set
       structures, impacting performance.

    c) ZSWAP_MAX_BATCH_SIZE is used as the batch-size for software
       compressors, since this gives the best performance with zstd.

    d) More likely()/unlikely() annotations to try and minimize branch
       mis-predicts.

 4) During pool creation, these key additions are allocated as part of the
    per-CPU acomp_ctx so as to recover performance with the new, generalized SG
    lists based zswap_compress() batching interface:

    a) An sg_table "acomp_ctx->sg_outputs" is allocated to contain the
       compressor's batch-size number of SG lists that will contain the
       destination buffers/lengths after batch compression.

    b) The per-CPU destination buffers are mapped to the per-CPU SG lists: this
       needs to be done only once, and optimizes performance.

    c) Only for batching compressors, extra memory is allocated in the
       acomp_req, so as to avail of struct acomp_req's "void *__ctx[]" to store
       pool->compr_batch_size number of int pointers to the
       acomp_ctx->sg_outputs-sgl's component scatterlists. This is also added
       to optimize/recover performance by avoiding traversing the sg_outputs per
       batch compress call. Without this optimization, it is difficult to
       realize the benefits of batching within large folios.

 5) Finally, zswap_compress() has been re-written to incorporate Herbert's
    suggestions to use source folios and output SG lists for batching. The new
    zswap_compress() code has been made as generic to software and batching
    compressors as possible, so that it is easy to read and maintain. The
    recent changes related to PAGE_SIZE dst buffers, zsmalloc and incompressible
    pages have been incorporated into the batched zswap_compress() as well! To
    resolve regressions with zstd, I took the liberty of not explicitly checking
    for dlen == 0 and dlen > PAGE_SIZE (as is assumed in the mainline); instead,
    expecting that a negative err value will be returned by the software
    compressor in such cases.


Compression Batching:
=====================

This patch-series introduces batch compression of pages in large folios to
improve zswap swapout latency. It preserves the existing zswap protocols
for non-batching software compressors by calling crypto_acomp sequentially
per page in the batch. Additionally, in support of hardware accelerators
that can process a batch as an integral unit, the patch-series allows
zswap to call crypto_acomp without API changes, for compressors
that intrinsically support batching. The zswap_compress() code has very minimal
special casing for software/batching compressors.

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
  
    The performance testing data with 30 usemem processes/64K folios
    shows 49% throughput gains and 25% elapsed/sys time reductions with
    deflate-iaa; and 1% sys time reduction with zstd for a small
    throughput increase. For PMD folios, a 55% throughput gain and 15%
    elapsed/sys time reduction is seen.

    Kernel compilation test with 64K folios using 32 threads and the
    zswap shrinker_enabled set to "N", demonstrates similar
    improvements: zswap_store() large folios using IAA compress batching
    improves the workload performance by 6.1% and reduces sys time by
    1% as compared to IAA sequential. For zstd, compress batching
    improves workload performance by 7.8% and reduces sys time by
    2.8% as compared to sequentially calling zswap_compress() per page
    in a folio.

    The main takeaway from usemem, a workload that is mostly compression
    dominated (very few swapins) is that the higher the number of batches,
    such as, with larger folios, the more the benefit of batching cost
    amortization, as shown by the PMD usemem data. This aligns well with the
    future direction for batching.

  The second proof point is to make sure that software algorithms such as
  zstd do not regress. The data indicates that for sequential software
  algorithms a performance gain is achieved. 
  
    With the performance optimizations implemented in patches 22-23 of v12:
    *  zstd usemem metrics with 64K folios are within range of variation
       with a slight sys time improvement. zstd usemem30 throughput with PMD
       folios increases by 1%, workload performance improves by 6% and sys time
       reduces by 8%.

    *  With kernel compilation, I used zstd without the zswap shrinker to enable
       more direct comparisons with the changes in this series. Subsequent patch
       series I expect to submit in collaboration with Nhat, will enable the
       zswap shrinker to quantify the benefits of decompression batching during
       writeback. With this series' compression batching within large folios, we
       get a 1%-2.8% reduction in sys time, a 6.1%-7.8% improvement in workload
       performance with 64K folios for deflate-iaa/zstd respectively.

    These optimizations pertain to ensuring common code paths, removing
    redundant branches/computes, selectively annotating branches with
    likely()/unlikely() compiler directives to minimize branch
    mis-prediction penalty. Additionally, using the batching code for
    non-batching compressors to sequentially compress/store batches of up
    to ZSWAP_MAX_BATCH_SIZE pages seems to help, most likely due to
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
  
  2) zswap writeback decompression batching:

     This is being co-developed with Nhat Pham, and shows promising
     results. We plan to submit an RFC shortly.

  3) Reclaim batching of hybrid folios:
  
     We can expect to see even more significant performance and throughput
     improvements if we use the parallelism offered by IAA to do reclaim
     batching of 4K/large folios (really any-order folios), and using the
     zswap_store() high throughput compression pipeline to batch-compress
     pages comprising these folios, not just batching within large
     folios. This is the reclaim batching patch 13 in v1, which we expect
     to submit in a separate patch-series. As mentioned earlier, reclaim
     batching reduces the # of writeback pages by 10X for zstd and
     deflate-iaa.

  4) swapin_readahead() decompression batching:

     We have developed a zswap load batching interface to be used
     for parallel decompression batching, using swapin_readahead().
  
  These capabilities are architected so as to be useful to zswap and
  zram. We have integrated these components with zram and expect to submit an
  RFC soon.

 
  v12 Performance Summary:
  ========================

  This is a performance testing summary of results with usemem30
  (30 usemem processes running in a cgroup limited at 150G, each trying to
   allocate 10G).

  usemem30 with 64K folios:
  =========================
  
     zswap shrinker_enabled = N.
  
     -----------------------------------------------------------------------
                     mm-unstable-9-18-2025             v12
     -----------------------------------------------------------------------
     zswap compressor          deflate-iaa     deflate-iaa   IAA Batching
                                                                 vs.
                                                             IAA Sequential
     -----------------------------------------------------------------------
     Total throughput (KB/s)     7,191,949      10,702,115        49%
     Average throughput (KB/s)     239,731         356,737        49%     
     elapsed time (sec)              93.21           69.98       -25%      
     sys time (sec)               2,190.52        1,651.51       -25%      
     -----------------------------------------------------------------------
    
     -----------------------------------------------------------------------
                     mm-unstable-9-18-2025             v12    
     -----------------------------------------------------------------------
     zswap compressor                 zstd            zstd   v12 zstd    
                                                             improvement  
     -----------------------------------------------------------------------
     Total throughput (KB/s)     6,258,312       6,269,511     0.2%
     Average throughput (KB/s)     208,610         208,983     0.2% 
     elapsed time (sec)             100.01          100.50     0.5%
     sys time (sec)               2,505.14        2,490.00      -1%         
     -----------------------------------------------------------------------


  usemem30 with 2M folios:
  ========================
  
     -----------------------------------------------------------------------
                     mm-unstable-9-18-2025             v12
     -----------------------------------------------------------------------
     zswap compressor          deflate-iaa     deflate-iaa   IAA Batching
                                                                 vs.
                                                             IAA Sequential
     -----------------------------------------------------------------------
     Total throughput (KB/s)     7,237,676      11,228,928      55%
     Average throughput (KB/s)     241,255         374,297      55% 
     elapsed time (sec)              82.26           69.30     -16%
     sys time (sec)               1,901.90        1,634.78     -14%
     -----------------------------------------------------------------------
  
     -----------------------------------------------------------------------
                     mm-unstable-9-18-2025             v12      
     -----------------------------------------------------------------------
     zswap compressor                 zstd            zstd   v12 zstd           
                                                             improvement
     -----------------------------------------------------------------------
     Total throughput (KB/s)     6,796,376       6,865,781     1.0%
     Average throughput (KB/s)     226,545         228,859     1.0% 
     elapsed time (sec)              94.07           88.80      -6%
     sys time (sec)               2,261.67        2,082.91      -8%
     -----------------------------------------------------------------------


  This is a performance testing summary of results with
  kernel_compilation test (allmod config, 32 cores, cgroup limited to 2G).

  zswap shrinker_enabled = N.
  
  kernel_compilation with 64K folios:
  ===================================

     --------------------------------------------------------------------------
               mm-unstable-9-18-2025             v12
     --------------------------------------------------------------------------
     zswap compressor    deflate-iaa     deflate-iaa    IAA Batching
                                                             vs.
                                                        IAA Sequential
     --------------------------------------------------------------------------
     real_sec                 874.74          821.59      -6.1%
     sys_sec                3,834.35        3,791.12        -1%
     --------------------------------------------------------------------------

     --------------------------------------------------------------------------
               mm-unstable-9-18-2025             v12
     --------------------------------------------------------------------------
     zswap compressor           zstd            zstd    Improvement
     --------------------------------------------------------------------------
     real_sec                 925.08          853.14      -7.8%
     sys_sec                5,318.65        5,172.23      -2.8%
     --------------------------------------------------------------------------


  kernel_compilation with PMD folios:
  ===================================

     --------------------------------------------------------------------------
               mm-unstable-9-18-2025             v12
     --------------------------------------------------------------------------
     zswap compressor    deflate-iaa     deflate-iaa    IAA Batching
                                                             vs.
                                                        IAA Sequential
     --------------------------------------------------------------------------
     real_sec                 808.10          794.85      -1.6%
     sys_sec                4,351.01        4,266.95        -2%
     --------------------------------------------------------------------------
 
 
     --------------------------------------------------------------------------
              mm-unstable-9-18-2025             v12
     --------------------------------------------------------------------------
     zswap compressor          zstd            zstd    Improvement
     --------------------------------------------------------------------------
     real_sec                848.06          845.42       -0.3%
     sys_sec               5,898.58        5,741.31       -2.7%
     --------------------------------------------------------------------------



DETAILS:
========

(A) From zswap's perspective, the most significant changes are:
===============================================================

1) A unified zswap_compress() API is added to compress multiple
   pages:

   - If the compressor has multiple acomp requests, i.e., internally
     supports batching, crypto_acomp_batch_compress() is called. If all
     pages are successfully compressed, or, if folio writeback is enabled, the
     batch is stored in zsmalloc, preserving latest mm-stable behavior.
   
   - If the compressor can only compress one page at a time, each page
     is compressed and stored sequentially.

   Many thanks to Yosry for this suggestion, because it is an essential
   component of unifying common code paths between sequential/batching
   compressions.

   Overall, the likely()/unlikely() annotations prevent regressions with
   software compressors like zstd, and generally improve non-batching
   compressors' performance with the batching code by 1% to 8%.

2) A new zswap_store_pages() is added, that stores multiple pages in a
   folio in a range of indices. This is an extension of the earlier
   zswap_store_page(), except it operates on a batch of pages.

3) zswap_store() is modified to store the folio's pages in batches
   by calling zswap_store_pages(). If the compressor supports batching,
   the folio will be compressed in batches of
   "pool->compr_batch_size". If the compressor does not support
   batching, the folio will be compressed in batches of
   ZSWAP_MAX_BATCH_SIZE pages, where each page in the batch is
   compressed sequentially. We see better performance by processing
   the folio in batches of ZSWAP_MAX_BATCH_SIZE, due to cache locality
   of working set structures such as the array of zswap_entry-s for the
   batch.

   Many thanks to Yosry and Johannes for steering towards a common
   design and code paths for sequential and batched compressions (i.e.,
   for software compressors and hardware accelerators such as IAA). As per
   Yosry's suggestion in v8, the "batch_size" is an attribute of the
   compressor/pool, and hence is stored in struct zswap_pool instead of
   in struct crypto_acomp_ctx.

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
      resources, and is shared by
      zswap_cpu_comp_prepare()/zswap_pool_create() error handling and
      zswap_pool_destroy().
   d) The zswap_pool node list instance is removed right after the node
      list add function in zswap_pool_create().
   e) We directly call mutex_[un]lock(&acomp_ctx->mutex) in
      zswap_[de]compress(). acomp_ctx_get_cpu_lock()/acomp_ctx_put_unlock()
      are deleted.

   The commit log of patch 0020 has a more detailed analysis.


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

   The commit log of patch 0002 provides more details on new iaa_crypto
   driver parameters added, along with recommended settings (defaults
   are optimal settings).

2) Compress/decompress batching are implemented using
   crypto_acomp_[de]compress() with SG lists used as the batching interface.


(C) The patch-series is organized as follows:
=============================================

 1) crypto acomp & iaa_crypto driver enablers for batching: Relevant
    patches are tagged with "crypto:" in the subject:

    Patch 1) Reorganizes the iaa_crypto driver code into logically related
             sections and avoids forward declarations, in order to facilitate
             subsequent iaa_crypto patches. This patch makes no
             functional changes.

    Patch 2) Makes an infrastructure change in the iaa_crypto driver
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
             duplication of device WQs in per-CPU wq_tables, thereby
             saving 140MiB on a 384 cores dual socket Granite Rapids server
             with 8 IAAs.

             Regardless of how the user has configured the WQs' usage,
             the next WQ to use is obtained through a direct look-up in
             per-CPU "cpu_comp_wqs" and "cpu_decomp_wqs" structures so
             as to minimize latency in the critical path driver compress
             and decompress routines.

    Patch 3) Code cleanup, consistency of function parameters.

    Patch 4) Makes a change to iaa_crypto driver's descriptor allocation,
             from blocking to non-blocking with retries/timeouts and
             mitigations in case of timeouts during compress/decompress
             ops. This prevents tasks getting blocked indefinitely, which
             was observed when testing 30 cores running workloads, with
             only 1 IAA enabled on Sapphire Rapids (out of 4). These
             timeouts are typically only encountered, and associated
             mitigations exercised, only in configurations with 1 IAA
             device shared by 30+ cores.

    Patch 5) Optimize iaa_wq refcounts using a percpu_ref instead of
             spinlocks and "int refcount".

    Patch 6) Code simplification and restructuring for understandability
             in core iaa_compress() and iaa_decompress() routines.

    Patch 7) Refactor hardware descriptor setup to their own procedures
             to reduce code clutter.

    Patch 8) Simplify and optimize (i.e. reduce computes) job submission
             for the most commonly used non-irq async mode by directly
             calling movdir64b.

    Patch 9) Deprecate exporting symbols for adding IAA compression
             modes.

    Patch 10) All dma_map_sg() calls will pass in 1 for the nents instead of
              sg_nents(), for these main reasons: performance; no existing
              iaa_crypto use cases that allow multiple SG lists to be mapped for
              dma at once; facilitates new SG lists batching interface through
              crypto.

    Patch 11) Rearchitect iaa_crypto to be agnostic of crypto_acomp for
              it be usable in both zswap and zram. crypto_acomp interfaces are
              maintained as earlier, for use in zswap.

    Patch 12) Descriptor submit and polling mechanisms, enablers for batching.

    Patch 13) Define a unit_size in struct acomp_req to enable batching, and
              provides acomp_request_set_unit_size() for use by kernel modules.

    Patch 14) Implement IAA batching of compressions and decompressions
              for deriving hardware parallelism.

    Patch 15) Enables the "async" mode, sets it as the default.

    Patch 16) Disables verify_compress by default.

    Patch 17) Decompress batching optimization: Find the two largest
              buffers in the batch and submit them first.
             
    Patch 18) Add a new Dynamic compression mode that can be used on
              Granite Rapids.

    Patch 19) Add a batch_size data member to structs acomp_alg/crypto_acomp and
              a crypto_acomp_batch_size() API that returns the compressor's
              batch-size, if it has defined one; 1 otherwise. Add the definition
              of batch_size to iaa_crypto acomp_algs.

 2) zswap modifications to enable compress batching in zswap_store()
    of large folios (including pmd-mappable folios):

    Patch 20) Simplifies the zswap_pool's per-CPU acomp_ctx resource
              management and lifetime to be from pool creation to pool
              deletion.

    Patch 21) Uses IS_ERR_OR_NULL() in zswap_cpu_comp_prepare() to check for
              valid acomp/req, thereby making it consistent with the resource
              de-allocation code.

    Patch 22) Defines a zswap-specific ZSWAP_MAX_BATCH_SIZE (currently set
              as 8U) to denote the maximum number of acomp_ctx batching
              resources to allocate, thus limiting the amount of extra
              memory used for batching. Further, the "struct
              crypto_acomp_ctx" is modified to contain multiple buffers.
              New "u8 compr_batch_size" and "u8 store_batch_size" members are
              added to "struct zswap_pool" to track the number of dst
              buffers associated with the compressor (more than 1 if
              the compressor supports batching) and the unit for storing
              large folios using compression batching respectively.

              Modifies zswap_store() to store the folio in batches of
              pool->store_batch_size by calling a new zswap_store_pages() that
              takes a range of indices in the folio to be stored.
              zswap_store_pages() pre-allocates zswap entries for the batch,
              calls zswap_compress() for each page in this range, and stores
              the entries in xarray/LRU.

    Patch 23) Introduces a new unified batching implementation of
              zswap_compress() for compressors that do and do not support
              batching. This eliminates code duplication and facilitates
              maintainability of the code with the introduction of compress
              batching. Further, there are many optimizations to this common
              code that result in workload throughput and performance
              improvements with software compressors and hardware accelerators
              such as IAA.

              zstd performance is better or on par with mm-unstable. We
              see impressive throughput/performance improvements with
              IAA and zstd batching vs. no-batching.


With v12 of this patch series, the IAA compress batching feature will be
enabled seamlessly on Intel platforms that have IAA by selecting
'deflate-iaa' as the zswap compressor, and using the iaa_crypto 'async'
sync_mode driver attribute (the default).


System setup for testing:
=========================
Testing of this patch-series was done with mm-unstable as of 9-18-2025,
commit 1f98191f08b4, without and with this patch-series. Data was
gathered on an Intel Sapphire Rapids (SPR) server, dual-socket 56 cores
per socket, 4 IAA devices per socket, each IAA has total 128 WQ entries,
503 GiB RAM and 525G SSD disk partition swap. Core frequency was fixed
at 2500MHz.

Other kernel configuration parameters:

    zswap compressor  : zstd, deflate-iaa
    zswap allocator   : zsmalloc
    vm.page-cluster   : 0

IAA "compression verification" is disabled and IAA is run in the async
mode (the defaults with this series).

I ran experiments with these workloads:

1) usemem 30 processes with zswap shrinker_enabled=N. Two sets of
   experiments, one with 64K folios, another with PMD folios.

2) Kernel compilation allmodconfig with 2G max memory, 32 threads, with
   zswap shrinker_enabled=N to test batching performance impact in
   isolation. Two sets of experiments, one with 64K folios, another with PMD
   folios.

IAA configuration is done by a CLI: script is included at the end of the
cover letter.


Performance testing (usemem30):
===============================
The vm-scalability "usemem" test was run in a cgroup whose memory.high
was fixed at 150G. There is no swap limit set for the cgroup. 30 usemem
processes were run, each allocating and writing 10G of memory, and
sleeping for 10 sec before exiting:

 usemem --init-time -w -O -b 1 -s 10 -n 30 10g
 echo 0 > /sys/module/zswap/parameters/shrinker_enabled

 IAA WQ Configuration (script is iincluded at the end of the cover
 letter):

   ./enable_iaa.sh -d 4 -q 1
   
 This enables all 4 IAAs on the socket, and configures 1 WQ per IAA
 device, each containing 128 entries. The driver distributes compress
 jobs from each core to wqX.0 of all same-package IAAs in a
 round-robin manner. Decompress jobs are send to the wqX.0 of the
 mapped IAA device.

 Since usemem has significantly more swapouts than swapins, this
 configuration is the most optimal.

 64K folios: usemem30: deflate-iaa:
 ==================================

 -------------------------------------------------------------------------------
                    mm-unstable-9-18-2025             v12
 -------------------------------------------------------------------------------
 zswap compressor             deflate-iaa     deflate-iaa    IAA Batching
                                                                 vs.
                                                             IAA Sequential
 -------------------------------------------------------------------------------
 Total throughput (KB/s)        7,191,949     10,702,115         49%
 Avg throughput (KB/s)            239,731        356,737         49%       
 elapsed time (sec)                 93.21          69.98        -25%      
 sys time (sec)                  2,190.52       1,651.51        -25%      
                                                                        
 -------------------------------------------------------------------------------
 memcg_high                     1,056,505      1,320,579                
 memcg_swap_fail                    3,966            321                
 64kB_swpout_fallback               3,965            321                
 zswpout                       61,577,440     71,448,317                
 zswpin                               488            141                
 pswpout                                0              0                
 pswpin                                 0              0                
 ZSWPOUT-64kB                   3,844,593      4,465,129                
 SWPOUT-64kB                            0              0
 pgmajfault                         2,786          2,454
 zswap_reject_compress_fail             0              0
 zswap_reject_reclaim_fail              0              0
 IAA incompressible pages               0              0
 -------------------------------------------------------------------------------


 2M folios: usemem30: deflate-iaa:
 =================================

 -------------------------------------------------------------------------------
                    mm-unstable-9-18-2025             v12
 -------------------------------------------------------------------------------
 zswap compressor             deflate-iaa     deflate-iaa     IAA Batching
                                                                  vs.
                                                              IAA Sequential
 -------------------------------------------------------------------------------
 Total throughput (KB/s)        7,237,676      11,228,928        55%
 Avg throughput (KB/s)            241,255         374,297        55%
 elapsed time (sec)                 82.26           69.30       -16%     
 sys time (sec)                  1,901.90        1,634.78       -14%     
                                                               
 -------------------------------------------------------------------------------
 memcg_high                       100,141         119,644     
 memcg_swap_fail                      356              12     
 thp_swpout_fallback                  356              12     
 zswpout                       63,470,927      71,773,688     
 zswpin                               455             169     
 pswpout                                0               0     
 pswpin                                 0               0     
 ZSWPOUT-2048kB                   123,610         140,169     
 thp_swpout                             0               0     
 pgmajfault                         2,743           2,471
 zswap_reject_compress_fail             0               0
 zswap_reject_reclaim_fail              0               0
 IAA incompressible pages               0               0
 -------------------------------------------------------------------------------


 64K folios: usemem30: zstd:
 ===========================

 -------------------------------------------------------------------------------
                    mm-unstable-9-18-2025             v12        
 -------------------------------------------------------------------------------
 zswap compressor                    zstd            zstd        v12 zstd    
                                                                 improvement  
 -------------------------------------------------------------------------------
 Total throughput (KB/s)        6,258,312       6,269,511        0.2%
 Avg throughput (KB/s)            208,610         208,983        0.2%       
 elapsed time (sec)                100.01          100.50        0.5%
 sys time (sec)                  2,505.14        2,490.00         -1%
                                                         
 -------------------------------------------------------------------------------
 memcg_high                     1,071,250       1,043,886
 memcg_swap_fail                    2,251              73
 64kB_swpout_fallback               2,251              73
 zswpout                       49,491,137      49,693,220
 zswpin                               455             179
 pswpout                                0               0
 pswpin                                 0               0
 ZSWPOUT-64kB                   3,090,904       3,105,690
 SWPOUT-64kB                            0               0
 pgmajfault                         2,780           2,456
 zswap_reject_compress_fail             0               0
 zswap_reject_reclaim_fail              0               0
 -------------------------------------------------------------------------------


 2M folios: usemem30: zstd:
 ==========================

 -------------------------------------------------------------------------------
                    mm-unstable-9-18-2025             v12      
 -------------------------------------------------------------------------------
 zswap compressor                    zstd            zstd        v12 zstd           
                                                                 improvement
 -------------------------------------------------------------------------------
 Total throughput (KB/s)        6,796,376       6,865,781        1.0%
 Avg throughput (KB/s)            226,545         228,859        1.0%    
 elapsed time (sec)                 94.07           88.80         -6%
 sys time (sec)                  2,261.67        2,082.91         -8%
                                                         
 -------------------------------------------------------------------------------
 memcg_high                        89,582          88,103
 memcg_swap_fail                       14              56
 thp_swpout_fallback                   14              56
 zswpout                       48,846,660      48,000,106
 zswpin                                58             266
 pswpout                                0               0
 pswpin                                 0               0
 ZSWPOUT-2048kB                    95,388          93,692
 thp_swpout                             0               0
 pgmajfault                         2,348           2,557
 zswap_reject_compress_fail             0               0
 zswap_reject_reclaim_fail              0               0
 -------------------------------------------------------------------------------


Performance testing (Kernel compilation, allmodconfig):
=======================================================

The experiments with kernel compilation test use 32 threads and build
the "allmodconfig" that takes ~14 minutes, and has considerable
swapout/swapin activity. The cgroup's memory.max is set to 2G. zswap
writeback is not enabled so as to isolate the performance impact of only large
folio batch compression.

 echo 0 > /sys/module/zswap/parameters/shrinker_enabled

 IAA WQ Configuration (script is at the end of the cover letter):

   ./enable_iaa.sh -d 4 -q 2
   
 This enables all 4 IAAs on the socket, and configures 2 WQs per IAA,
 each containing 64 entries. The driver sends decompresses to wqX.0 of
 the mapped IAA device, and distributes compresses to wqX.1 of all
 same-package IAAs in a round-robin manner.

 64K folios: Kernel compilation/allmodconfig: deflate-iaa:
 =========================================================

 -------------------------------------------------------------------------------
                    mm-unstable-9-18-2025             v12
 -------------------------------------------------------------------------------
 zswap compressor             deflate-iaa     deflate-iaa    IAA Batching
                                                                 vs.
                                                             IAA Sequential
 -------------------------------------------------------------------------------
 real_sec                          874.74          821.59        -6.1%
 user_sec                       15,701.49       15,718.29 
 sys_sec                         3,834.35        3,791.12          -1%
 -------------------------------------------------------------------------------
 Max_Res_Set_Size_KB            1,871,264       1,872,780 
 -------------------------------------------------------------------------------
 memcg_high                             0               0         
 memcg_swap_fail                        0               0         
 64kB_swpout_fallback                   0               0         
 zswpout                       91,614,674     103,057,250         
 zswpin                        27,028,688      30,946,488         
 pswpout                                0               0         
 pswpin                                 0               0         
 ZSWPOUT-64kB                   3,007,705       3,337,682         
 SWPOUT-64kB                            0               0 
 pgmajfault                    28,697,315      32,778,092 
 zswap_reject_compress_fail             0               0 
 zswap_reject_reclaim_fail              0               0 
 IAA incompressible pages             440             239  
 -------------------------------------------------------------------------------


 2M folios: Kernel compilation/allmodconfig: deflate-iaa:
 ========================================================

 -------------------------------------------------------------------------------
                    mm-unstable-9-18-2025             v12
 -------------------------------------------------------------------------------
 zswap compressor             deflate-iaa     deflate-iaa    IAA Batching
                                                                 vs.
                                                             IAA Sequential
 -------------------------------------------------------------------------------
 real_sec                          808.10          794.85         -1.6%
 user_sec                       15,807.59       15,794.49  
 sys_sec                         4,351.01        4,266.95           -2%
 -------------------------------------------------------------------------------
 Max_Res_Set_Size_KB            1,871,100       1,874,684  
 -------------------------------------------------------------------------------
 memcg_high                             0               0     
 memcg_swap_fail                        0               0     
 thp_swpout_fallback                    0               0     
 zswpout                      109,563,983     111,586,692          
 zswpin                        38,396,482      39,089,000     
 pswpout                                0               0     
 pswpin                                 0               0     
 ZSWPOUT-2048kB                    16,661          17,020     
 thp_swpout                             0               0     
 pgmajfault                    39,727,295      40,433,559  
 zswap_reject_compress_fail             0               0  
 zswap_reject_reclaim_fail              0               0  
 IAA incompressible pages             531             317  
 -------------------------------------------------------------------------------
         
        
With the iaa_crypto driver changes for non-blocking descriptor allocations,
no timeouts-with-mitigations were seen in compress/decompress jobs, for all
of the above experiments.


 64K folios: Kernel compilation/allmodconfig: zstd:
 ==================================================

 -------------------------------------------------------------------------------
                    mm-unstable-9-18-2025             v12
 -------------------------------------------------------------------------------
 zswap compressor                    zstd            zstd    Improvement
 -------------------------------------------------------------------------------
 real_sec                          925.08          853.14       -7.8%
 user_sec                       15,708.03       15,703.87
 sys_sec                         5,318.65        5,172.23       -2.8%
 -------------------------------------------------------------------------------
 Max_Res_Set_Size_KB            1,874,060       1,874,276
 -------------------------------------------------------------------------------
 memcg_high                             0               0        
 memcg_swap_fail                        0               0        
 64kB_swpout_fallback                   0               0        
 zswpout                       80,735,528      78,500,218        
 zswpin                        24,155,464      22,898,395        
 pswpout                                0               0        
 pswpin                                 0               0        
 ZSWPOUT-64kB                   2,580,722       2,489,796        
 SWPOUT-64kB                            0               0
 pgmajfault                    25,564,063      24,223,218
 zswap_reject_compress_fail             0               0
 zswap_reject_reclaim_fail              0               0
 -------------------------------------------------------------------------------


 2M folios: Kernel compilation/allmodconfig: zstd:
 =================================================

 -------------------------------------------------------------------------------
                    mm-unstable-9-18-2025             v12
 -------------------------------------------------------------------------------
 zswap compressor                    zstd            zstd    Improvement
 -------------------------------------------------------------------------------
 real_sec                          848.06          845.42       -0.3%
 user_sec                       15,822.19       15,826.68
 sys_sec                         5,898.58        5,741.31       -2.7%
 -------------------------------------------------------------------------------
 Max_Res_Set_Size_KB            1,872,888       1,874,684
 -------------------------------------------------------------------------------
 memcg_high                             0               0   
 memcg_swap_fail                        0               0   
 thp_swpout_fallback                    0               0   
 zswpout                       91,399,677      87,856,850        
 zswpin                        29,871,078      28,452,891   
 pswpout                                0               0   
 pswpin                                 0               0   
 ZSWPOUT-2048kB                    12,130          11,968   
 thp_swpout                             0               0   
 pgmajfault                    30,723,070      29,308,735
 zswap_reject_compress_fail             0               0
 zswap_reject_reclaim_fail              0               0
 -------------------------------------------------------------------------------


IAA configuration script "enable_iaa.sh":
=========================================

 Acknowledgements: Binuraj Ravindran and Rakib Al-Fahad.

 Usage:
 ------

   ./enable_iaa.sh -d <num_IAAs> -q <num_WQs_per_IAA>


 #---------------------------------<cut here>----------------------------------
 #!/usr/bin/env bash
 #SPDX-License-Identifier: BSD-3-Clause
 #Copyright (c) 2025, Intel Corporation
 #Description: Configure IAA devices
 
 VERIFY_COMPRESS_PATH="/sys/bus/dsa/drivers/crypto/verify_compress"
 
 iax_dev_id="0cfe"
 num_iaa=$(lspci -d:${iax_dev_id} | wc -l)
 sockets=$(lscpu | grep Socket | awk '{print $2}')
 echo "Found ${num_iaa} instances in ${sockets} sockets(s)"
 
 #  The same number of devices will be configured in each socket, if there
 #  are  more than one socket.
 #  Normalize with respect to the number of sockets.
 device_num_per_socket=$(( num_iaa/sockets ))
 num_iaa_per_socket=$(( num_iaa / sockets ))
 
 iaa_wqs=2
 verbose=0
 iaa_engines=8
 mode="dedicated"
 wq_type="kernel"
 iaa_crypto_mode="async"
 verify_compress=0
 
 
 # Function to handle errors
 handle_error() {
     echo "Error: $1"
     exit 1
 }
 
 # Process arguments
 
 while getopts "d:hm:q:vD" opt; do
   case $opt in
     d)
       device_num_per_socket=$OPTARG
       ;;
     m)
       iaa_crypto_mode=$OPTARG
       ;;
     q)
       iaa_wqs=$OPTARG
       ;;
     D)
       verbose=1
       ;;
     v)
       verify_compress=1
       ;;
     h)
       echo "Usage: $0 [-d <device_count>][-q <wq_per_device>][-v]"
       echo "       -d - number of devices"
       echo "       -q - number of WQs per device"
       echo "       -v - verbose mode"
       echo "       -h - help"
       exit
       ;;
     \?)
       echo "Invalid option: -$OPTARG" >&2
       exit
       ;;
   esac
 done
 
 LOG="configure_iaa.log"
 
 # Update wq_size based on number of wqs
 wq_size=$(( 128 / iaa_wqs ))
 
 # Take care of the enumeration, if DSA is enabled.
 dsa=`lspci | grep -c 0b25`
 # set first,step counters to correctly enumerate iax devices based on
 # whether running on guest or host with or without dsa
 first=0
 step=1
 [[ $dsa -gt 0 && -d /sys/bus/dsa/devices/dsa0 ]] && first=1 && step=2
 echo "first index: ${first}, step: ${step}"
 
 
 #
 # Switch to software compressors and disable IAAs to have a clean start
 #
 COMPRESSOR=/sys/module/zswap/parameters/compressor
 last_comp=`cat ${COMPRESSOR}`
 echo lzo > ${COMPRESSOR}
 
 echo "Disable IAA devices before configuring"
 
 for ((i = ${first}; i < ${step} * ${num_iaa}; i += ${step})); do
     for ((j = 0; j < ${iaa_wqs}; j += 1)); do
         cmd="accel-config disable-wq iax${i}/wq${i}.${j} >& /dev/null"
        [[ $verbose == 1 ]] && echo $cmd; eval $cmd
      done
     cmd="accel-config disable-device iax${i} >& /dev/null"
     [[ $verbose == 1 ]] && echo $cmd; eval $cmd
 done
 
 rmmod iaa_crypto
 modprobe iaa_crypto
 
 # apply crypto parameters
 echo $verify_compress > ${VERIFY_COMPRESS_PATH} || handle_error "did not change verify_compress"
 # Note: This is a temporary solution for during the kernel transition.
 if [ -f /sys/bus/dsa/drivers/crypto/g_comp_wqs_per_iaa ];then
     echo 1 > /sys/bus/dsa/drivers/crypto/g_comp_wqs_per_iaa || handle_error "did not set g_comp_wqs_per_iaa"
 elif [ -f /sys/bus/dsa/drivers/crypto/g_wqs_per_iaa ];then
     echo 1 > /sys/bus/dsa/drivers/crypto/g_wqs_per_iaa || handle_error "did not set g_wqs_per_iaa"
 fi
 if [ -f /sys/bus/dsa/drivers/crypto/g_consec_descs_per_gwq ];then
     echo 1 > /sys/bus/dsa/drivers/crypto/g_consec_descs_per_gwq || handle_error "did not set g_consec_descs_per_gwq"
 fi
 echo ${iaa_crypto_mode} > /sys/bus/dsa/drivers/crypto/sync_mode || handle_error "could not set sync_mode"
 
 
 
 echo "Configuring ${device_num_per_socket} device(s) out of $num_iaa_per_socket per socket"
 if [ "${device_num_per_socket}" -le "${num_iaa_per_socket}" ]; then
     echo "Configuring all devices"
     start=${first}
     end=$(( ${step} * ${device_num_per_socket} ))
 else
    echo "ERROR: Not enough devices"
    exit
 fi
 
 
 #
 # enable all iax devices and wqs
 #
 for (( socket = 0; socket < ${sockets}; socket += 1 )); do
 for ((i = ${start}; i < ${end}; i += ${step})); do
 
     echo "Configuring iaa$i on socket ${socket}"
 
     for ((j = 0; j < ${iaa_engines}; j += 1)); do
         cmd="accel-config config-engine iax${i}/engine${i}.${j} --group-id=0"
         [[ $verbose == 1 ]] && echo $cmd; eval $cmd
     done
 
     # Config  WQs
     for ((j = 0; j < ${iaa_wqs}; j += 1)); do
         # Config WQ: group 0,  priority=10, mode=shared, type = kernel name=kernel, driver_name=crypto
         cmd="accel-config config-wq iax${i}/wq${i}.${j} -g 0 -s ${wq_size} -p 10 -m ${mode} -y ${wq_type} -n iaa_crypto${i}${j} -d crypto"
         [[ $verbose == 1 ]] && echo $cmd; eval $cmd
      done
 
     # Enable Device and WQs
     cmd="accel-config enable-device iax${i}"
     [[ $verbose == 1 ]] && echo $cmd; eval $cmd
 
     for ((j = 0; j < ${iaa_wqs}; j += 1)); do
         cmd="accel-config enable-wq iax${i}/wq${i}.${j}"
         [[ $verbose == 1 ]] && echo $cmd; eval $cmd
      done
 
 done
     start=$(( start + ${step} * ${num_iaa_per_socket} ))
     end=$(( start + (${step} * ${device_num_per_socket}) ))
 done
 
 # Restore the last compressor
 echo "$last_comp" > ${COMPRESSOR}
 
 # Check if the configuration is correct
 echo "Configured IAA devices:"
 accel-config list | grep iax
 
 #---------------------------------<cut here>----------------------------------


Changes since v11:
==================
1) Rebased to mm-unstable as of 9-18-2025, commit 1f98191f08b4.
2) Incorporated Herbert's suggestions on submitting the folio as the source and 
   SG lists for the destination to create the compress batching interface from
   zswap to crypto.
3) As per Herbert's suggestion, added a new unit_size member to struct
   acomp_req, along with a acomp_request_set_unit_size() API for kernel modules
   to set the unit size to use while breaking down the request's src/dst
   scatterlists.
4) Implemented iaa_crypto batching using the new SG lists based architecture and
   crypto interfaces.
5) To make the SG lists based approach functional and performant for IAA, I have
   changed all the calls to dma_map_sg() to use nents of 1. This should not be a
   concern, since it eliminates redundant computes to scan an SG list with only
   one scatterlist for existing kernel users, i.e. zswap with the
   zswap_compress() modifications in this series. This will continue to hold
   true with the zram IAA batching support I am developing. There are no kernel
   use cases for the iaa_crypto driver that will break this assumption.
6) Addressed Herbert's comment about batch_size being a statically defined data
   member in struct acomp_alg and struct crypto_acomp.
7) Addressed Nhat's comment about VM_WARN_ON_ONCE(nr_pages >
   ZSWAP_MAX_BATCH_SIZE) in zswap_store_pages().
8) Nhat's comment about deleting struct swap_batch_decomp_data is automatically
   addressed by the SG lists based rewrite of the crypto batching interface.
9) Addressed Barry's comment about renaming pool->batch_size to
   pool->store_batch_size.
10) Incorporated Barry's suggestion to merge patches that introduce data members
    to structures and/or API and their usage.
11) Added performance data to patch 0023's commit log, as suggested by Barry.

Changes since v10:
==================
1) Rebased to mm-unstable as of 7-30-2025, commit 01da54f10fdd.
2) Added change logging in patch 0024 on there being no Intel-specific
   dependencies in the batching framework, as suggested by
   Andrew Morton. Thanks Andrew!
3) Added change logging in patch 0024 on other ongoing work that can use
   batching, as per Andrew's suggestion. Thanks Andrew!
4) Added the IAA configuration script in the cover letter, as suggested
   by Nhat Pham. Thanks Nhat!
5) As suggested by Nhat, dropped patch 0020 from v10, that moves CPU
   hotplug procedures to pool functions.
6) Gathered kernel_compilation 'allmod' config performance data with
   writeback and zswap shrinker_enabled=Y.
7) Changed the pool->batch_size for software compressors to be
   ZSWAP_MAX_BATCH_SIZE since this gives better performance with the zswap
   shrinker enabled.
8) Was unable to replicate in v11 the issue seen in v10 with higher
   memcg_swap_fail than in the baseline, with usemem30/zstd.

Changes since v9:
=================
1) Rebased to mm-unstable as of 6-24-2025, commit 23b9c0472ea3.
2) iaa_crypto rearchitecting, mainline race condition fix, performance
   optimizations, code cleanup.
3) Addressed Herbert's comments in v9 patch 10, that an array based
   crypto_acomp interface is not acceptable.
4) Optimized the implementation of the batching zswap_compress() and
   zswap_store_pages() added in v9, to recover performance when
   integrated with the changes in commit 56e5a103a721 ("zsmalloc: prefer
   the the original page's node for compressed data").

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



Kanchana P Sridhar (23):
  crypto: iaa - Reorganize the iaa_crypto driver code.
  crypto: iaa - New architecture for IAA device WQ comp/decomp usage &
    core mapping.
  crypto: iaa - Simplify, consistency of function parameters, minor
    stats bug fix.
  crypto: iaa - Descriptor allocation timeouts with mitigations.
  crypto: iaa - iaa_wq uses percpu_refs for get/put reference counting.
  crypto: iaa - Simplify the code flow in iaa_compress() and
    iaa_decompress().
  crypto: iaa - Refactor hardware descriptor setup into separate
    procedures.
  crypto: iaa - Simplified, efficient job submissions for non-irq mode.
  crypto: iaa - Deprecate exporting add/remove IAA compression modes.
  crypto: iaa - Expect a single scatterlist for a [de]compress request's
    src/dst.
  crypto: iaa - Rearchitect the iaa_crypto driver to be usable by zswap
    and zram.
  crypto: iaa - Enablers for submitting descriptors then polling for
    completion.
  crypto: acomp - Define a unit_size in struct acomp_req to enable
    batching.
  crypto: iaa - IAA Batching for parallel compressions/decompressions.
  crypto: iaa - Enable async mode and make it the default.
  crypto: iaa - Disable iaa_verify_compress by default.
  crypto: iaa - Submit the two largest source buffers first in
    decompress batching.
  crypto: iaa - Add deflate-iaa-dynamic compression mode.
  crypto: acomp - Add crypto_acomp_batch_size() to get an algorithm's
    batch-size.
  mm: zswap: Per-CPU acomp_ctx resources exist from pool creation to
    deletion.
  mm: zswap: Consistently use IS_ERR_OR_NULL() to check acomp_ctx
    resources.
  mm: zswap: zswap_store() will process a large folio in batches.
  mm: zswap: Batched zswap_compress() with compress batching of large
    folios.

 .../driver-api/crypto/iaa/iaa-crypto.rst      |  168 +-
 crypto/acompress.c                            |    1 +
 crypto/testmgr.c                              |   10 +
 crypto/testmgr.h                              |   74 +
 drivers/crypto/intel/iaa/Makefile             |    4 +-
 drivers/crypto/intel/iaa/iaa_crypto.h         |   60 +-
 .../intel/iaa/iaa_crypto_comp_dynamic.c       |   22 +
 drivers/crypto/intel/iaa/iaa_crypto_main.c    | 2936 ++++++++++++-----
 drivers/crypto/intel/iaa/iaa_crypto_stats.c   |    8 +
 drivers/crypto/intel/iaa/iaa_crypto_stats.h   |    2 +
 include/crypto/acompress.h                    |   63 +
 include/crypto/internal/acompress.h           |    3 +
 include/linux/iaa_comp.h                      |  122 +
 mm/zswap.c                                    |  766 +++--
 14 files changed, 3181 insertions(+), 1058 deletions(-)
 create mode 100644 drivers/crypto/intel/iaa/iaa_crypto_comp_dynamic.c
 create mode 100644 include/linux/iaa_comp.h

-- 
2.27.0

