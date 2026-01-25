Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CCEC61668;
	Sun, 25 Jan 2026 03:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769312145; cv=none; b=WXeY7yAy4KG7Z/YjkuDf+63gHe1ejG0PSIxOpnjjm0OodfhSgXLwUiP9ZUWoV0CmhJSTB5xoTAi8WPgOORiFlhF72xM2pHD+B/WMV83pmx31zKK90602qMqOk6EqFuYHzJrJyLTyWoipO/yuahoa0hS1Ym1PrVolTQ7pY5VW1rA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769312145; c=relaxed/simple;
	bh=76PNQjqWh9SOqLmJjwSvMXueL9ulYMtQCIRRFbN6mkY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=WnU2um1niDcaEmH35sKEU5sILF/zmM0hUKLKqFaePTmpg1okv06mImRHJ+dKfCrfaO7CT8KVfjC1upRo7OFyXlFk/A55sIPWwIlJe83B/u4N8t4RgziEIMjVFRATXVLEta4IRObbftCc1GZumRJ58npCr3eZO8wHcjJzdLwxxOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RGQhIu3n; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RGQhIu3n"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769312141; x=1800848141;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=76PNQjqWh9SOqLmJjwSvMXueL9ulYMtQCIRRFbN6mkY=;
  b=RGQhIu3n32cWKXoqwTsuMHkHzEfmjUP8HHHdgSP/N7OkkIR1Dknu52DV
   vqA/gxdzR8PTgbv8+ZmQ3dA1RHbJ9Dp93NEqW7LIP4n+ClMe28CgqNETb
   lPS+uGXQWuPlzae3thXfcnjt87OZEIpHbCHIJ37phFqbrOxRYjwsPX0aV
   i2kso3oVDFw4KSBHalB8lACn6mFY3zT8oGhozkxEihp1O70MYK2FFKiJW
   69tE0YXIrFxNK6znpVsqgHDcKAu04uIZQ2s5LpbL6KB+XJWOnLnjpY60/
   wiFin7iiK9ARPfCHl2qxm2lDG0ijj9dAo5vSNQTv9zoWvxbGrY9E5jTXs
   A==;
X-CSE-ConnectionGUID: PJzAeQpqTiWFKYADoBt8vA==
X-CSE-MsgGUID: 7WC8stwBReioG0Yjqjfu2w==
X-IronPort-AV: E=McAfee;i="6800,10657,11681"; a="81887286"
X-IronPort-AV: E=Sophos;i="6.21,252,1763452800"; 
   d="scan'208";a="81887286"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2026 19:35:39 -0800
X-CSE-ConnectionGUID: Gl6N10I8RECbnUlRbQ7S7Q==
X-CSE-MsgGUID: fPTAdXUPRsq2ZnYX4pxWSg==
X-ExtLoop1: 1
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2026 19:35:38 -0800
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
	vinicius.gomes@intel.com,
	giovanni.cabiddu@intel.com
Cc: wajdi.k.feghali@intel.com,
	kanchana.p.sridhar@intel.com
Subject: [PATCH v14 00/26] zswap compression batching with optimized iaa_crypto driver
Date: Sat, 24 Jan 2026 19:35:11 -0800
Message-Id: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v14: zswap compression batching with optimized iaa_crypto driver
================================================================

This updated patch-series further generalizes the batching
implementation of zswap_compress() for non-batching and batching
compressors. It uses the segmentation support for compression added by
Herbert in [1] that provides a wrapper for existing algorithms so that
they can accept a single segment while returning the compressed length
or error through the dst SG list length, thereby unifying the
crypto_acomp calling convention for zswap whether or not the underlying
algorithm supports segmentation.

We aim to extend the performance gains demonstrated by zswap compression
batching to other swap components by introducing similar batching
mechanisms.

[1]: https://patchwork.kernel.org/project/linux-crypto/cover/cover.1766709379.git.herbert@gondor.apana.org.au/

The patch-series makes sure the bulk allocation of zswap entries
preserves the current behavior of addition of an entry to the LRU list
for the nid of the page.

Based on Herbert's suggestions, the batching interfaces from zswap to crypto,
from crypto to iaa_crypto, and the batching implementation within iaa_crypto now
use the folio directly as the source (sg_page_iter for retrieving pages), and
destination SG lists. A unit_size has been added to struct acomp_req, with
kernel users such as zswap using the new acomp_request_set_unit_size() API to
set the unit size to use while breaking down the request's src/dst
scatterlists. zswap sets the unit-size to PAGE_SIZE.

Following Andrew's suggestion, the next two paragraphs emphasize generality                                                               
and alignment with current kernel efforts.                                                                                                

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

Experiments with kernel compilation benchmark (allmodconfig) that
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

The most significant highlight of v14 is a new, lightweight and highly
optimized iaa_crypto driver, resulting directly in the latency and
throughput improvements noted later in this cover letter.

 1) Better stability, more functionally versatile to support zswap
    with better performance on different Intel platforms.

    a) Patches 0003, 0006 and 0012 together resolve a race condition in
       mainline v6.15, reported from internal validation, when IAA
       wqs/devices are disabled while workloads are using IAA.

    b) Patch 0003 introduces a new architecture for mapping cores to
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

    f) Addition of a layer that encapsulates iaa_crypto's core functionality to
       rely only on idxd, dma and scatterlists to provide clean interfaces to
       crypto_acomp.

    g) New Dynamic compression mode for Granite Rapids to get better
       compression ratio by echo-ing 'deflate-iaa-dynamic' as the zswap
       compressor.

    h) New crypto_acomp API crypto_acomp_batch_size() that will return
       the driver's max batch size if the driver has registered a batch_size
       that's greater than 1; or 1 if there is no driver specific definition of
       batch_size.

       Accordingly, iaa_crypto sets the acomp_alg batch_size to its internal
       IAA_CRYPTO_MAX_BATCH_SIZE for fixed and dynamic modes.

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

 3)  crypto_acomp API compatibility and extensibility:

     a) crypto_acomp_compress() integrates with the segmentation API
        support added in [1]. Please refer to function header
        documentation in crypto/acompress.c and
        acomp_request_set_unit_size() in include/crypto/acompress.h.

     b) iaa_crypto acomp_algs support segmentation.

     c) iaa_crypto driver compress batching implementation adherence to
        acomp: the sub-requests are submitted for parallel compression
        in the IAA hardware accelerator and the function immediately
        returns.

     d) Algorithms that support batching must provide a
        batch_completed() API. When the algorithm's batching
        implementation has finished processing all sub-requests, it
        notifies a wait_queue using the batch_completed() API.

     e) crypto_acomp_compress() changes:

        - For non-segmentation algorithms, the trivial segmentation
          wrapper created by Herbert in [1] is called through
          acomp_do_req_chain().

        - For segmentation algorithms, if the caller has submitted a
          batch, i.e., the acomp_req's source length is greater than the
          unit_size, compression batching is invoked by calling
          acomp_do_req_batch_parallel() that implements (c) and (d).

     f) Compress/decompress batching are implemented using SG lists as
        the batching interface.


Main Changes in Zswap Compression Batching:
===========================================

 Note to zswap maintainers:
 --------------------------
 Patches 23 and 24 can be reviewed and merged independently of this
 series, since they are zswap centric. These 2 patches help
 batching but the crypto_acomp_batch_size() from the iaa_crypto commits
 in this series is not a requirement, unlike patches 25-26.
 
 1) v14 preserves the pool acomp_ctx resources creation/deletion
    simplification of v11, namely, lasting from pool creation-deletion,
    persisting through CPU hot[un]plug operations. Further, zswap no
    longer needs to create multiple "struct acomp_req" in the per-CPU
    acomp_ctx. zswap only needs to manage multiple "u8 **buffers".

 2) We store the compressor's batch-size (@pool->compr_batch_size) directly in
    struct zswap_pool for quick retrieval in the zswap_store() fast path.

 3) Optimizations to not cause regressions in software compressors with
    the introduction of the new unified zswap_compress() framework that
    implements compression batching for all compressors. These optimizations
    help recover the performance for non-batching compressors:

    a) kmem_cache_alloc_bulk(), kmem_cache_free_bulk() to allocate/free
       batch zswap_entry-s. These kmem_cache API allow allocator
       optimizations with internal locks for multiple allocations.

    b) The page's nid is stored in a new nid field added to zswap_entry, so the
       zswap_lru_add()/zswap_lru_del() will add/delete the entry from the LRU
       list of the page's nid. This preserves the current behavior wrt the
       shrinker.

    c) Writes to the zswap_entry right after it is allocated without
       modifying the publishing order. This avoids different code blocks
       in zswap_store_pages() having to bring the zswap_entries to the
       cache for writing, potentially evicting other working set
       structures, impacting performance.

    d) ZSWAP_MAX_BATCH_SIZE is used as the batch-size for software
       compressors, since this gives the best performance with zstd.

    e) Minimize branches in zswap_compress().

 4) During pool creation, these key additions are allocated as part of the
    per-CPU acomp_ctx so as to recover performance with the new, generalized SG
    lists based zswap_compress() batching interface:

    a) An sg_table "acomp_ctx->sg_outputs" is allocated to contain the
       compressor's batch-size number of SG lists that will contain the
       destination buffers/lengths after batch compression.

    b) The per-CPU destination buffers are mapped to the per-CPU SG lists: this
       needs to be done only once, and optimizes performance.

 5) A unified zswap_compress() API is added to compress multiple pages. Thanks
    to Nhat, Yosry and Johannes for their helpful suggestions to accomplish
    this.

 6) Finally, zswap_compress() has been re-written to incorporate Herbert's
    suggestions to use source folios and output SG lists for batching. The new
    zswap_compress() code has been made as generic to software and batching
    compressors as possible, so that it is easy to read and maintain. The
    recent changes related to PAGE_SIZE dst buffers, zsmalloc and incompressible
    pages have been incorporated into the batched zswap_compress() as well. To
    resolve regressions with zstd, I took the liberty of not explicitly checking
    for dlen == 0 and dlen > PAGE_SIZE (as in the mainline); instead,
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
    shows 62% throughput gains and 28% elapsed/sys time reductions with
    deflate-iaa; and 5% sys time reduction with zstd for a small
    throughput increase. For PMD folios, a 67% throughput gain and 23%
    elapsed/sys time reduction is seen.

    Kernel compilation test with 64K folios using 32 threads and the
    zswap shrinker_enabled set to "N", demonstrates similar
    improvements: zswap_store() large folios using IAA compress batching
    improves the workload performance by 3.5% and reduces sys time by
    6% as compared to IAA sequential. For zstd, compress batching
    improves workload performance by 3.4% and reduces sys time by
    1.8% as compared to sequentially calling zswap_compress() per page
    in a folio.

    The main takeaway from usemem, a workload that is mostly compression
    dominated (very few swapins) is that the higher the number of batches,
    such as with larger folios, the more the benefit of batching cost
    amortization, as shown by the PMD usemem data. This aligns well with the
    future direction for batching.

  The second proof point is to make sure that software algorithms such as
  zstd do not regress. The data indicates that for sequential software
  algorithms a performance gain is achieved. 
  
    With the performance optimizations implemented in patches 21-22 of v14:
    
    *  zstd usemem metrics with 64K folios are within range of variation
       with a slight sys time improvement. zstd usemem30 workload performance
       with PMD folios improves by 6% and sys time reduces by 8%, for comparable
       throughput as the baseline.

    *  With kernel compilation, I used zstd without the zswap shrinker to enable
       more direct comparisons with the changes in this series. Subsequent patch
       series I expect to submit in collaboration with Nhat, will enable the
       zswap shrinker to quantify the benefits of decompression batching during
       writeback. With this series' compression batching within large folios, we
       get a 6%-1.8% reduction in sys time, a 3.5%-3.4% improvement in workload
       performance with 64K folios for deflate-iaa/zstd respectively.

    These optimizations pertain to ensuring common code paths and removing
    redundant branches/computes. Additionally, using the batching code for
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

 
  v14 Performance Summary:
  ========================

  Note to maintainers:
  --------------------
  1) mm-unstable as of 1/23/2026 commit a11ff1482517 is used as the
     baseline. For performance validation, I observed
     kernel_compilation "allmodconfig" build errors with mm-unstable
     commit a11ff1482517. Hence I have used "defconfig" data averaged
     across 10 runs for baselines and v14.

  2) With the latest mm-unstable, when I added the __zswap_compress() as
     suggested in [2], I saw a 3% regression in kernel_compilation system
     time with zstd for PMD folios, wrt the baseline. Hence, I had to
     forgo adding this helper function and keep all code contained to
     zswap_compress(). I hope this is Ok. This wasn't an issue with
     mm-unstable as of 12/15/2025. My guess is that recent mm/swap
     performance improvements available in mm-unstable cause the latency
     overhead of an extra function call impact performance with PMD
     folios.

     [2]: https://patchwork.kernel.org/comment/26693144/

  This is a summary of performance testing on an Intel Sapphire Rapids
  server with two workloads:
    
    1) 30 usemem processes run in a 150 GB memory limited cgroup, each
       allocates 10G, i.e, effectively running at 50% memory pressure.

    2) kernel_compilation "defconfig", 32 threads, cgroup memory limit set
       to 1.7 GiB (50% memory pressure, since baseline memory usage is
       3.4 GiB): data averaged across 10 runs.
    
    To keep comparisons simple, all testing was done without the
    zswap shrinker.
 
 =========================================================================
  IAA                 mm-unstable-1-23-2026             v14
 =========================================================================
    zswap compressor            deflate-iaa     deflate-iaa   IAA Batching
                                                                  vs.
                                                            IAA Sequential
 =========================================================================
 usemem30, 64K folios:       
                              
    Total throughput (KB/s)       6,226,967      10,551,714       69%
    Average throughput (KB/s)       207,565         351,723       69%     
    elapsed time (sec)                99.19           67.45      -32%      
    sys time (sec)                 2,356.19        1,580.47      -33%
                               
 usemem30, PMD folios:         
                               
    Total throughput (KB/s)       6,347,201      11,315,500       78%
    Average throughput (KB/s)       211,573         377,183       78%     
    elapsed time (sec)                88.14           63.37      -28%      
    sys time (sec)                 2,025.53        1,455.23      -28%
                               
 kernel_compilation, 64K folios:
                               
    elapsed time (sec)               100.10           98.74     -1.4%
    sys time (sec)                   308.72          301.23       -2%
                               
 kernel_compilation, PMD folios:
                               
    elapsed time (sec)                95.29           93.44     -1.9%
    sys time (sec)                   346.21          344.48     -0.5%
 =========================================================================


 =========================================================================
  ZSTD                mm-unstable-1-23-2026             v14
 =========================================================================
    zswap compressor                   zstd            zstd     v14 ZSTD      
                                                             Improvement
 =========================================================================
 usemem30, 64K folios:          
                               
    Total throughput (KB/s)       6,032,326       6,047,448      0.3%
    Average throughput (KB/s)       201,077         201,581      0.3%
    elapsed time (sec)                97.52           95.33     -2.2%
    sys time (sec)                 2,415.40        2,328.38       -4%
                                                                      
 usemem30, PMD folios:                                               
                                                                      
    Total throughput (KB/s)       6,570,404       6,623,962      0.8%
    Average throughput (KB/s)       219,013         220,798      0.8%
    elapsed time (sec)                89.17           88.25       -1%
    sys time (sec)                 2,126.69        2,043.08       -4%
                                                                     
 kernel_compilation, 64K folios:                                     
                                                                     
    elapsed time (sec)               100.89           99.98     -0.9%
    sys time (sec)                   417.49          414.62     -0.7%
                                                                     
 kernel_compilation, PMD folios:                                     
                                                                     
    elapsed time (sec)                98.26           97.38     -0.9%
    sys time (sec)                   487.14          473.16     -2.9%
 =========================================================================


The patch-series is organized as follows:
=========================================

 1) crypto acomp & iaa_crypto driver enablers for batching: Relevant
    patches are tagged with "crypto:" in the subject:

    Patch 1) Reorganizes the iaa_crypto driver code into logically related
             sections and avoids forward declarations, in order to facilitate
             subsequent iaa_crypto patches. This patch makes no
             functional changes.

    Patch 2) Imports Thorsten Blum's commit bce4678f0235 ("crypto: iaa -
             Replace sprintf with sysfs_emit in sysfs show functions")
             from cryptodev-2.6. 

    Patch 3) Makes an infrastructure change in the iaa_crypto driver
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

    Patch 4) Code cleanup, consistency of function parameters.

    Patch 5) Makes a change to iaa_crypto driver's descriptor allocation,
             from blocking to non-blocking with retries/timeouts and
             mitigations in case of timeouts during compress/decompress
             ops. This prevents tasks getting blocked indefinitely, which
             was observed when testing 30 cores running workloads, with
             only 1 IAA enabled on Sapphire Rapids (out of 4). These
             timeouts are typically only encountered, and associated
             mitigations exercised, only in configurations with 1 IAA
             device shared by 30+ cores.

    Patch 6) Optimize iaa_wq refcounts using a percpu_ref instead of
             spinlocks and "int refcount".

    Patch 7) Code simplification and restructuring for understandability
             in core iaa_compress() and iaa_decompress() routines.

    Patch 8) Refactor hardware descriptor setup to their own procedures
             to reduce code clutter.

    Patch 9) Simplify and optimize job submission for the most commonly used
             non-irq async mode by directly calling movdir64b.

    Patch 10) Deprecate exporting symbols for adding IAA compression
              modes.

    Patch 11) All dma_map_sg() calls will pass in 1 for the nents instead of
              sg_nents(), for these main reasons: performance; no existing
              iaa_crypto use cases that allow multiple SG lists to be mapped for
              dma at once; facilitates new SG lists batching interface through
              crypto.

    Patch 12) Move iaa_crypto core functionality to a layer that relies only on
              the idxd driver, dma, and scatterlists. Implement clean interfaces
              to crypto_acomp.

    Patch 13) Define a unit_size in struct acomp_req to enable batching, and
              provides acomp_request_set_unit_size() for use by kernel
              modules. zswap_cpu_comp_prepare() calls this API to set the
              unit_size for zswap as PAGE_SIZE.

    Patch 14) Imports Herbert's segmentation patch "crypto: acomp - Add
              bit to indicate segmentation support" [3].

              [3]: https://patchwork.kernel.org/project/linux-crypto/patch/0533ee1ec37d82fd22a74921cf6a1f3dc9d022b0.1766709379.git.herbert@gondor.apana.org.au/

    Patch 15) Imports and modifies Herbert's segmentation API patch
              "crypto: acomp - Add trivial segmentation wrapper" [4].

              [4]: https://patchwork.kernel.org/project/linux-crypto/patch/9aab007e003c291a549a0b1794854d5d83f9da27.1766709379.git.herbert@gondor.apana.org.au/

    Patch 16) Develops IAA batching of compressions and decompressions
              for deriving hardware parallelism. iaa_crypto supports
              segmentation.

    Patch 17) Decompress batching optimization: Find the two largest
              buffers in the batch and submit them first.

    Patch 18) iaa_crypto driver batching integration with
              crypto_comp. Adds "batch_completed()" API to "struct
              crypto_acomp" and "struct acomp_alg". Introduces
              acomp_do_req_batch_parallel() in acompress.c for
              segmentation algorithms to invoke when they receive a src
              SG list with source length greater than the req->unit_size.
             
    Patch 19) Enables the "async" mode, sets it as the default.

    Patch 20) Disables verify_compress by default.

    Patch 21) Add a new Dynamic compression mode that can be used on
              Granite Rapids.

    Patch 22) Add a batch_size data member to struct acomp_alg and
              a crypto_acomp_batch_size() API that returns the compressor's
              batch-size, if it has defined one; 1 otherwise.

 2) zswap modifications to enable compress batching in zswap_store()
    of large folios (including pmd-mappable folios):

    Patch 23) Simplifies the zswap_pool's per-CPU acomp_ctx resource
              management and lifetime to be from pool creation to pool
              deletion.

    Patch 24) Uses IS_ERR_OR_NULL() in zswap_cpu_comp_prepare() to check for
              valid acomp/req, thereby making it consistent with the resource
              de-allocation code.

    Patch 25) Defines a zswap-specific ZSWAP_MAX_BATCH_SIZE (currently set
              as 8U) to denote the maximum number of acomp_ctx batching
              resources to allocate, thus limiting the amount of extra
              memory used for batching. Further, the "struct
              crypto_acomp_ctx" is modified to contain multiple buffers.
              New "u8 compr_batch_size" member is added to "struct zswap_pool"
              to track the number of dst buffers associated with the compressor
              (more than 1 if the compressor supports batching).

              Modifies zswap_store() to store the folio in batches of
              pool->compr_batch_size (batching compressors) or
              ZSWAP_MAX_BATCH_SIZE (sequential compressors) by calling a new
              zswap_store_pages() that takes a range of indices in the folio to
              be stored.
              
              zswap_store_pages() bulk-allocates zswap entries for the batch,
              calls zswap_compress() for each page in this range, and stores
              the entries in xarray/LRU.

    Patch 26) Introduces a new unified batching implementation of
              zswap_compress() for compressors that do and do not support
              batching/segmentation. The crypto_acomp_compress() calling
              convention is exactly the same for compressors that do and
              do not support batching. This eliminates code duplication
              and facilitates code maintainability with the introduction
              of compress batching. Further, there are many
              optimizations to this common code that result in workload
              throughput and performance improvements with software
              compressors and hardware accelerators such as IAA.

              zstd performance is better or on par with mm-unstable. We
              see impressive throughput/performance improvements with
              IAA and workload performance/sys time improvement with zstd
              batching vs. no-batching.


With v14 of this patch series, the IAA compress batching feature will be
enabled seamlessly on Intel platforms that have IAA by selecting
'deflate-iaa' as the zswap compressor, and using the iaa_crypto 'async'
sync_mode driver attribute (the default).


System setup for testing:
=========================
Testing of this patch-series was done with mm-unstable as of 1-23-2026,
commit a11ff1482517, without and with this patch-series. Data was
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

2) Kernel compilation defconfig with 32 threads, zswap
   shrinker_enabled=N to test batching performance impact in
   isolation. Two sets of experiments, one with 64K folios, another with
   PMD folios. Data averaged across 10 runs.

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

 IAA WQ Configuration (script is included at the end of the cover
 letter):

   ./enable_iaa.sh -d 4 -q 1
   
 This enables all 4 IAAs on the socket, and configures 1 WQ per IAA
 device, each containing 128 entries. The driver distributes compress
 jobs from each core to wqX.0 of all same-package IAAs in a
 round-robin manner. Decompress jobs are send to the wqX.0 of the
 mapped IAA device. Since usemem has significantly more swapouts than
 swapins, this configuration is the most optimal.

 64K folios: usemem30: deflate-iaa:
 ==================================

 -------------------------------------------------------------------------------
                    mm-unstable-1-23-2026             v14
 -------------------------------------------------------------------------------
 zswap compressor             deflate-iaa     deflate-iaa    IAA Batching
                                                                 vs.
                                                             IAA Sequential
 -------------------------------------------------------------------------------
 Total throughput (KB/s)        6,226,967      10,551,714         69%
 Avg throughput (KB/s)            207,565         351,723         69%       
 elapsed time (sec)                 99.19           67.45        -32%      
 sys time (sec)                  2,356.19        1,580.47        -33%      
                                                                         
 -------------------------------------------------------------------------------
 memcg_high                     1,263,686       1,403,665                
 memcg_swap_fail                      932             961                
 64kB_swpout_fallback                 932             961                
 zswpout                       58,166,164      64,508,421                
 zswpin                                 0             405                
 pswpout                                0               0                
 pswpin                                 0               0                
 ZSWPOUT-64kB                   3,634,454       4,030,737                
 SWPOUT-64kB                            0               0
 pgmajfault                         2,261           2,683
 zswap_reject_compress_fail             0               0
 zswap_reject_reclaim_fail              0               0
 IAA incompressible pages               0               0
 -------------------------------------------------------------------------------


 2M folios: usemem30: deflate-iaa:
 =================================

 -------------------------------------------------------------------------------
                    mm-unstable-1-23-2026             v14
 -------------------------------------------------------------------------------
 zswap compressor             deflate-iaa     deflate-iaa     IAA Batching
                                                                  vs.
                                                              IAA Sequential
 -------------------------------------------------------------------------------
 Total throughput (KB/s)        6,347,201      11,315,500        78%
 Avg throughput (KB/s)            211,573         377,183        78%
 elapsed time (sec)                 88.14           63.37       -28%     
 sys time (sec)                  2,025.53        1,455.23       -28%     
                                                               
 -------------------------------------------------------------------------------
 memcg_high                       115,271         125,194     
 memcg_swap_fail                       16               3     
 thp_swpout_fallback                   16               3     
 zswpout                       59,394,133      64,512,000     
 zswpin                                67               0     
 pswpout                                0               0     
 pswpin                                 0               0     
 ZSWPOUT-2048kB                   115,988         125,997     
 thp_swpout                             0               0     
 pgmajfault                         2,359           2,275
 zswap_reject_compress_fail             0               0
 zswap_reject_reclaim_fail              0               0
 IAA incompressible pages               0               0
 -------------------------------------------------------------------------------


 64K folios: usemem30: zstd:
 ===========================

 -------------------------------------------------------------------------------
                    mm-unstable-1-23-2026             v14        
 -------------------------------------------------------------------------------
 zswap compressor                    zstd            zstd        v14 zstd    
                                                                 improvement  
 -------------------------------------------------------------------------------
 Total throughput (KB/s)        6,032,326       6,047,448         0.3%
 Avg throughput (KB/s)            201,077         201,581         0.3%       
 elapsed time (sec)                 97.52           95.33        -2.2%
 sys time (sec)                  2,415.40        2,328.38          -4%
                                                          
 -------------------------------------------------------------------------------
 memcg_high                     1,121,501       1,116,449 
 memcg_swap_fail                      335             410 
 64kB_swpout_fallback                 335             410 
 zswpout                       48,700,469      48,793,036
 zswpin                               141              56 
 pswpout                                0               0 
 pswpin                                 0               0 
 ZSWPOUT-64kB                   3,043,404       3,049,144 
 SWPOUT-64kB                            0               0 
 pgmajfault                         2,392           2,310 
 zswap_reject_compress_fail             0               0 
 zswap_reject_reclaim_fail              0               0 
 -------------------------------------------------------------------------------
      

 2M folios: usemem30: zstd:
 ==========================

 -------------------------------------------------------------------------------
                    mm-unstable-1-23-2026             v14      
 -------------------------------------------------------------------------------
 zswap compressor                    zstd            zstd        v14 zstd           
                                                                 improvement
 -------------------------------------------------------------------------------
 Total throughput (KB/s)        6,570,404       6,623,962         0.8%
 Avg throughput (KB/s)            219,013         220,798         0.8%    
 elapsed time (sec)                 89.17           88.25          -1%
 sys time (sec)                  2,126.69        2,043.08          -4%
                                                          
 -------------------------------------------------------------------------------
 memcg_high                        93,215          93,156 
 memcg_swap_fail                       32              39 
 thp_swpout_fallback                   32              39 
 zswpout                       48,112,938      48,060,675
 zswpin                               463             419 
 pswpout                                0               0 
 pswpin                                 0               0 
 ZSWPOUT-2048kB                    93,936          93,827 
 thp_swpout                             0               0 
 pgmajfault                         2,727           2,674 
 zswap_reject_compress_fail             0               0 
 zswap_reject_reclaim_fail              0               0 
 -------------------------------------------------------------------------------


Performance testing (Kernel compilation, defconfig, 10 runs average):
=====================================================================
The experiments with Kernel compilation defconfig use 32 threads, with
1.7Gi max cgroup memory (needs 3.4Gi i.e. 50% memory pressure). Two sets
of experiments, one with 64K folios, another with PMD folios. Data
averaged across 10 runs.

zswap writeback is not enabled so as to isolate the performance impact
of only large folio batch compression.

 echo 0 > /sys/module/zswap/parameters/shrinker_enabled

 IAA WQ Configuration (script is at the end of the cover letter):

   ./enable_iaa.sh -d 4 -q 2
   
 This enables all 4 IAAs on the socket, and configures 2 WQs per IAA,
 each containing 64 entries. The driver sends decompresses to wqX.0 of
 the mapped IAA device, and distributes compresses to wqX.1 of all
 same-package IAAs in a round-robin manner.

 64K folios: Kernel compilation/defconfig: deflate-iaa:
 =========================================================

 -------------------------------------------------------------------------------
                    mm-unstable-1-23-2026             v14
 -------------------------------------------------------------------------------
 zswap compressor             deflate-iaa     deflate-iaa    IAA Batching
                                                                 vs.
                                                             IAA Sequential
 -------------------------------------------------------------------------------
 real_sec                          100.10           98.74     -1.4%
 sys_sec                           308.72          301.23       -2%
                                                         
 -------------------------------------------------------------------------------
 memcg_high                             0               0      
 memcg_swap_fail                        0               0      
 64kB_swpout_fallback                   0               0      
 zswpout                        7,580,873       8,030,514      
 zswpin                         2,317,545       2,470,347      
 pswpout                                0               0      
 pswpin                                 0               0      
 ZSWPOUT-64kB                     269,427         286,160      
 SWPOUT-64kB                            0               0
 pgmajfault                     2,492,272       2,654,161
 zswap_reject_compress_fail             0               0
 zswap_reject_reclaim_fail              0               0
 IAA incompressible pages               0               0
 -------------------------------------------------------------------------------


 2M folios: Kernel compilation/defconfig: deflate-iaa:
 ========================================================

 -------------------------------------------------------------------------------
                    mm-unstable-1-23-2026             v14
 -------------------------------------------------------------------------------
 zswap compressor             deflate-iaa     deflate-iaa    IAA Batching
                                                                 vs.
                                                             IAA Sequential
 -------------------------------------------------------------------------------
 real_sec                           95.29           93.44     -1.9%
 sys_sec                           346.21          344.48     -0.5%
                                                         
 -------------------------------------------------------------------------------
 memcg_high                             0               0 
 memcg_swap_fail                        0               0 
 thp_swpout_fallback                    0               0 
 zswpout                        8,738,290       8,892,478      
 zswpin                         3,206,380       3,231,212 
 pswpout                                0               0 
 pswpin                                 0               0 
 ZSWPOUT-2048kB                     1,336           1,380 
 thp_swpout                             0               0 
 pgmajfault                     3,358,877       3,381,416
 zswap_reject_compress_fail             0               0
 zswap_reject_reclaim_fail              0               0
 IAA incompressible pages               0               0
 -------------------------------------------------------------------------------


With the iaa_crypto driver changes for non-blocking descriptor allocations,
no timeouts-with-mitigations were seen in compress/decompress jobs, for all
of the above experiments.


 64K folios: Kernel compilation/defconfig: zstd:
 ==================================================

 -------------------------------------------------------------------------------
                    mm-unstable-1-23-2026             v14
 -------------------------------------------------------------------------------
 zswap compressor                    zstd            zstd    Improvement
 -------------------------------------------------------------------------------
 real_sec                          100.89           99.98      -0.9%
 sys_sec                           417.49          414.62      -0.7%
                                                         
 -------------------------------------------------------------------------------
 memcg_high                             0               0       
 memcg_swap_fail                        0               0       
 64kB_swpout_fallback                   0               0       
 zswpout                        6,428,238       6,477,772       
 zswpin                         1,934,598       1,954,038       
 pswpout                                0               0       
 pswpin                                 0               0       
 ZSWPOUT-64kB                     227,046         228,313       
 SWPOUT-64kB                            0               0
 pgmajfault                     2,077,102       2,101,203
 zswap_reject_compress_fail             0               0
 zswap_reject_reclaim_fail              0               0
 -------------------------------------------------------------------------------


 2M folios: Kernel compilation/defconfig: zstd:
 =================================================

 -------------------------------------------------------------------------------
                    mm-unstable-1-23-2026             v14
 -------------------------------------------------------------------------------
 zswap compressor                    zstd            zstd    Improvement
 -------------------------------------------------------------------------------
 real_sec                           98.26           97.38     -0.9%
 sys_sec                           487.14          473.16     -2.9%
                                                         
 -------------------------------------------------------------------------------
 memcg_high                             0               0 
 memcg_swap_fail                        0               0 
 thp_swpout_fallback                    0               0 
 zswpout                        7,663,145       7,458,519      
 zswpin                         2,731,725       2,639,001 
 pswpout                                0               0 
 pswpin                                 0               0 
 ZSWPOUT-2048kB                     1,119           1,056 
 thp_swpout                             0               0 
 pgmajfault                     2,848,343       2,754,105
 zswap_reject_compress_fail             0               0
 zswap_reject_reclaim_fail              0               0
 -------------------------------------------------------------------------------



Changes since v13:
==================
1)  Rebased to mm-unstable as of 1-23-2026, commit a11ff1482517.
2)  iaa_crypto batching follows crypto_acomp "submit then return
    immediately" API requirements, per Herbert. After all sub-requests
    have completed, a tfm->batch_completed() API is notified.
3)  iaa_crypto acomp_algs provide segmentation support by setting the
    crypto_alg flag bit.
4)  Integrated iaa_crypto with Herbert's segmentation API, and made
    modifications for non-batching and batching compressors for
    functionality and to not regress performance.
5)  Added documentation for acomp_request_set_unit_size(), per
    Giovanni. Added documentation for crypto_acomp_compress() clarifying
    unit_size and segmentation support.
6)  zswap_entry bits to use macro defined constants, per Nhat.
7)  Unified code in zswap_compress() for software and batching
    compressors, per Yosry.
8)  Concise documentation of design in function headers, and code
    comments in line, concise commit logs, per Yosry.

Changes since v12:
==================
1)  Rebased to mm-unstable as of 10-24-2025, commit 813c0fa931ce.
2)  Added "int nid" to zswap_entry to store the page's nid, to preserve zswap
    LRU list/shrinker behavior with bulk allocation, as suggested by Nhat and
    Yosry. No change in memory footprint of struct zswap_entry.
3)  Added a WARN_ON() if kmem_cache_alloc_bulk() returns 0 or a number that's
    different than nr_entries, as suggested by Yosry.
4)  Confirmed that kmem_cache_bulk_free() works for both bulk and non-bulk
    allocated entries, to follow-up on Yosry's comment.
5)  Moved the call to cpuhp_state_remove_instance() to zswap_pool_destroy(), as
    suggested by Yosry.
6)  Variable names changed to "nid" and "wb_enabled", per Yosry's suggestion.
7)  Concise comments in zswap.c, and summarized commit logs, as suggested by
    Yosry.
8)  Minimized branches in zswap_compress().
9)  Deleted allocating extra memory in acomp_req->__ctx[] to statically store
    addresses to SG lists' lengths, as suggested by Herbert.
10) Deleted the iaa_comp API and export symbols, as suggested by Herbert.
11) Deleted @batch_size in struct crypto_acomp. Instead, the value is returned
    from struct acomp_alg directly, as suggested by Herbert.
12) Addressed checkpatch.pl warnings and coding style suggestions in the
    iaa_crypto patches, provided by Vinicius Gomes in internal code
    reviews. Thanks Vinicius!


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


I would greatly appreciate code review comments for the iaa_crypto driver
and mm patches included in this series!

Thanks,
Kanchana





Kanchana P Sridhar (26):
  crypto: iaa - Reorganize the iaa_crypto driver code.
  crypto: iaa - Replace sprintf with sysfs_emit in sysfs show functions
  crypto: iaa - New architecture for IAA device WQ [de]comp usage & core
    mapping.
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
  crypto: iaa - Rearchitect iaa_crypto to have clean interfaces with
    crypto_acomp.
  crypto: acomp - Define a unit_size in struct acomp_req to enable
    batching.
  crypto: acomp - Add bit to indicate segmentation support
  crypto: acomp - Add trivial segmentation wrapper
  crypto: iaa - IAA Batching for parallel compressions/decompressions.
  crypto: iaa - Submit the two largest source buffers first in batch
    decompress.
  crypto: acomp, iaa - crypto_acomp integration of IAA Batching.
  crypto: iaa - Enable async mode and make it the default.
  crypto: iaa - Disable iaa_verify_compress by default.
  crypto: iaa - Add deflate-iaa-dynamic compression mode.
  crypto: acomp - Add crypto_acomp_batch_size() to get an algorithm's
    batch-size.
  mm: zswap: Tie per-CPU acomp_ctx lifetime to the pool.
  mm: zswap: Consistently use IS_ERR_OR_NULL() to check acomp_ctx
    resources.
  mm: zswap: Store large folios in batches.
  mm: zswap: Batched zswap_compress() for compress batching of large
    folios.

 .../driver-api/crypto/iaa/iaa-crypto.rst      |  168 +-
 crypto/acompress.c                            |  110 +-
 crypto/testmgr.c                              |   10 +
 crypto/testmgr.h                              |   74 +
 drivers/crypto/intel/iaa/Makefile             |    4 +-
 drivers/crypto/intel/iaa/iaa_crypto.h         |   95 +-
 .../intel/iaa/iaa_crypto_comp_dynamic.c       |   22 +
 drivers/crypto/intel/iaa/iaa_crypto_main.c    | 2926 ++++++++++++-----
 drivers/crypto/intel/iaa/iaa_crypto_stats.c   |    8 +
 drivers/crypto/intel/iaa/iaa_crypto_stats.h   |    2 +
 include/crypto/acompress.h                    |   68 +
 include/crypto/algapi.h                       |    5 +
 include/crypto/internal/acompress.h           |   15 +
 include/linux/crypto.h                        |    3 +
 mm/zswap.c                                    |  724 ++--
 15 files changed, 3144 insertions(+), 1090 deletions(-)
 create mode 100644 drivers/crypto/intel/iaa/iaa_crypto_comp_dynamic.c

-- 
2.27.0

