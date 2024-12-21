Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB4A71E9B2B;
	Sat, 21 Dec 2024 06:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734762683; cv=none; b=C4RHjVCo3zx7waKHth762GrurLG2ejbhMZw4k8A6GiL6gHmSWhVMGlNnPaeRuT+YKbBa9ODC/MHHreYDR7jsyAiUjGrXX0wh9XMhKCsYbSbANWhuewjjY+rjuh0IVFmZxsKZZA3Sf+iFoWvFnqIY1dTvYtOMoqYFBito+5JTS5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734762683; c=relaxed/simple;
	bh=3X3HR0fHEJ1lBlsH8Ictztcl9wbocoPn9D0PYw5/iGQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=oMp4bal9HfewHFEAHznsGy7SHzsx5M2L8BxO9FPvXZbj4OzErtvJP0Zfv9xqa7eZdkrgb+tdEUT4cxb4L9rNpzGYJ+Ojwd6UmzxCphTN2D7hMfNDel4sH3ZzAQX5ymTli71TEmBfjIAj3KypFVmdHW3hHITO2V/6FEqDyzcwUMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=h4MXevkN; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h4MXevkN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734762680; x=1766298680;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=3X3HR0fHEJ1lBlsH8Ictztcl9wbocoPn9D0PYw5/iGQ=;
  b=h4MXevkNwh3sJaYtPF8gQNaDux3j8kxyQsj7ly+cU9dAz8ptT9+YhbGe
   V790o3YjN4rzsqmkQQlkaqoWQyZuCOLdKEmHcgJFXoJFdYqcIYULMzsM4
   GC0fRroweMy5d42dd0ZM1V78zGX3lfp7At+j34D9XTZQ1oA91+NS2YMGO
   wGSlxMFx8siTE9RdJC8rpXfwJJERNlqynDzPEcvUTM1DRLDz2JglJurB3
   6XTimWueSuXoL8zkk7AH+5Fh1HOMXfPwcfwQ77QWU/pYOThpd90jAYhIk
   kJLXhqfdOW9Z0m7NSAzjyg4ZDj7FB07UOVgpP4OfIouQcTml5CJ7wqDQ+
   Q==;
X-CSE-ConnectionGUID: duhoE+xCS1WJKf0m2hGMhQ==
X-CSE-MsgGUID: 1knqRFCsQM6dFFX+jVC6gw==
X-IronPort-AV: E=McAfee;i="6700,10204,11292"; a="35021601"
X-IronPort-AV: E=Sophos;i="6.12,253,1728975600"; 
   d="scan'208";a="35021601"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2024 22:31:19 -0800
X-CSE-ConnectionGUID: j6bDd2x9Tou/PyB32xfmhw==
X-CSE-MsgGUID: q+tZS66dR7avdkwSuUgWsQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="99184571"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa007.jf.intel.com with ESMTP; 20 Dec 2024 22:31:20 -0800
From: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	hannes@cmpxchg.org,
	yosryahmed@google.com,
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
Subject: [PATCH v5 00/12] zswap IAA compress batching
Date: Fri, 20 Dec 2024 22:31:07 -0800
Message-Id: <20241221063119.29140-1-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit


IAA Compression Batching with acomp Request Chaining:
=====================================================

This patch-series introduces the use of the Intel Analytics Accelerator
(IAA) for parallel batch compression of pages in large folios to improve
zswap swapout latency, resulting in sys time reduction by 22% (usemem30)
and by 27% (kernel compilation); as well as a 30% increase in usemem30
throughput with IAA batching as compared to zstd.

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

 2) zswap modifications to enable compress batching in zswap_store()
    of large folios (including pmd-mappable folios):

    Patch 10) Defines a zswap-specific ZSWAP_MAX_BATCH_SIZE (currently set
              as 8U) to denote the maximum number of acomp_ctx batching
              resources. Further, the "struct crypto_acomp_ctx" is modified
              to contain a configurable number of acomp_reqs and buffers.
              The cpu hotplug onlining code will query
              acomp_has_async_batching() and if this returns "true", will
              further get the compressor defined maximum batch size, and
              will use the minimum of zswap's upper limit and the
              compressor's maximum batch size to allocate
              acomp_reqs/buffers if the acomp supports batching, and 1
              acomp_req/buffer if not.

    Patch 11) Restructures & simplifies zswap_store() to make it amenable
              for batching. Moves the loop over the folio's pages to a new
              zswap_store_folio(), which in turn allocates zswap entries
              for all folio pages upfront, before proceeding to call a
              newly added zswap_compress_folio(), which simply calls
              zswap_compress() for each folio page.

    Patch 12) Finally, this patch modifies zswap_compress_folio() to detect
              if the pool's acomp_ctx has batching resources. If so, the
              "acomp_ctx->nr_reqs" becomes the batch size to use to call
              crypto_acomp_batch_compress() for every "acomp_ctx->nr_reqs"
              pages in the large folio. The crypto API calls into the new
              iaa_crypto "iaa_comp_acompress_batch()" that does batching
              with request chaining. Upon successful compression of a
              batch, the compressed buffers are stored in zpool.

With v5 of this patch series, the IAA compress batching feature will be
enabled seamlessly on Intel platforms that have IAA by selecting
'deflate-iaa' as the zswap compressor, and using the iaa_crypto 'async'
sync_mode driver attribute.

[1]: https://lore.kernel.org/linux-crypto/677614fbdc70b31df2e26483c8d2cd1510c8af91.1730021644.git.herbert@gondor.apana.org.au/


System setup for testing:
=========================
Testing of this patch-series was done with mm-unstable as of 12-20-2024,
commit 5555a83c82d6, without and with this patch-series.
Data was gathered on an Intel Sapphire Rapids server, dual-socket 56 cores
per socket, 4 IAA devices per socket, 503 GiB RAM and 525G SSD disk
partition swap. Core frequency was fixed at 2500MHz.

Other kernel configuration parameters:

    zswap compressor  : zstd, deflate-iaa
    zswap allocator   : zsmalloc
    vm.page-cluster   : 0, 2

IAA "compression verification" is disabled and IAA is run in the async
mode (the defaults with this series). 2WQs are configured per IAA
device. Compress jobs from all cores on a socket are distributed among all
4 IAA devices on the same socket.

I ran experiments with these workloads:

1) usemem 30 processes with these large folios enabled to "always":
   - 16k/32k/64k
   - 2048k

2) Kernel compilation allmodconfig with 2G max memory, 32 threads, run in
   tmpfs with these large folios enabled to "always":
   - 16k/32k/64k


IAA compress batching performance: sync vs. async request chaining:
===================================================================
The vm-scalability "usemem" test was run in a cgroup whose memory.high
was fixed at 150G. The is no swap limit set for the cgroup. 30 usemem
processes were run, each allocating and writing 10G of memory, and sleeping
for 10 sec before exiting:

usemem --init-time -w -O -s 10 -n 30 10g

"async polling" here refers to the v4 implementation of batch compression
without request chaining, which is used as baseline to compare the request
chaining implementations in v5.

These are the latencies measured using bcc profiling with bpftrace for the
various iaa_crypto modes:

 -------------------------------------------------------------------------------
 usemem30: 16k/32k/64k Folios         crypto_acomp_batch_compress() latency
 
 iaa_crypto batching          count     mean       p50       p99
 implementation                         (ns)      (ns)      (ns)
 -------------------------------------------------------------------------------

 async polling            5,210,702    10,083     9,675   17,488
                                                                
 sync request chaining    5,396,532    33,391    32,977   39,426
                                                                
 async request chaining   5,509,777     9,959     9,611   16,590

 -------------------------------------------------------------------------------

This demonstrates that async request chaining doesn't cause IAA compress
batching performance regression wrt the v4 implementation without request
chaining.


Performance testing (usemem30):
===============================
The vm-scalability "usemem" test was run in a cgroup whose memory.high
was fixed at 150G. The is no swap limit set for the cgroup. 30 usemem
processes were run, each allocating and writing 10G of memory, and sleeping
for 10 sec before exiting:

usemem --init-time -w -O -s 10 -n 30 10g


 16k/32/64k folios: usemem30: zstd:
 ==================================

 -------------------------------------------------------------------------------
                        mm-unstable-12-20-2024   v5 of this patch-series
 -------------------------------------------------------------------------------
 zswap compressor                      zstd             zstd  
 vm.page-cluster                          2                2 
                                                             
 -------------------------------------------------------------------------------
 Total throughput (KB/s)          6,143,774        6,180,657  
 Avg throughput (KB/s)              204,792          206,021  
 elapsed time (sec)                  110.45           112.02  
 sys time (sec)                    2,628.55         2,684.53  
                                                              
 -------------------------------------------------------------------------------
 memcg_high                         469,269          481,665  
 memcg_swap_fail                      1,198              910  
 zswpout                         48,932,319       48,931,447  
 zswpin                                 384              398  
 pswpout                                  0                0  
 pswpin                                   0                0  
 thp_swpout                               0                0  
 thp_swpout_fallback                      0                0  
 16kB-swpout_fallback                     0                0                                   
 32kB_swpout_fallback                     0                0  
 64kB_swpout_fallback                 1,198              910  
 pgmajfault                           3,459            3,090  
 swap_ra                                 96              100  
 swap_ra_hit                             48               54  
 ZSWPOUT-16kB                             2                2  
 ZSWPOUT-32kB                             2                0  
 ZSWPOUT-64kB                     3,057,060        3,057,286  
 SWPOUT-16kB                              0                0  
 SWPOUT-32kB                              0                0  
 SWPOUT-64kB                              0                0  
 -------------------------------------------------------------------------------


 16k/32/64k folios: usemem30: deflate-iaa:
 =========================================

 -------------------------------------------------------------------------------
                    mm-unstable-12-20-2024     v5 of this patch-series
 -------------------------------------------------------------------------------
 zswap compressor             deflate-iaa        deflate-iaa      IAA Batching          
 vm.page-cluster                        2                  2       vs.     vs.
                                                                   Seq    zstd
 -------------------------------------------------------------------------------
 Total throughput (KB/s)        7,679,064         8,027,314         5%    30%
 Avg throughput (KB/s)            255,968           267,577         5%    30%
 elapsed time (sec)                 90.82             87.53        -4%   -22%
 sys time (sec)                  2,205.73          2,099.80        -5%   -22%
                                                                    
 -------------------------------------------------------------------------------
 memcg_high                       716,670           722,693         
 memcg_swap_fail                    1,187             1,251         
 zswpout                       64,511,695        64,510,499         
 zswpin                               483               477         
 pswpout                                0                 0         
 pswpin                                 0                 0         
 thp_swpout                             0                 0         
 thp_swpout_fallback                    0                 0         
 16kB-swpout_fallback                   0                 0                                                   
 32kB_swpout_fallback                   0                 0         
 64kB_swpout_fallback               1,187             1,251         
 pgmajfault                         3,180             3,187         
 swap_ra                              175               155         
 swap_ra_hit                          114                76         
 ZSWPOUT-16kB                           5                 3         
 ZSWPOUT-32kB                           1                 2         
 ZSWPOUT-64kB                   4,030,709         4,030,573         
 SWPOUT-16kB                            0                 0         
 SWPOUT-32kB                            0                 0         
 SWPOUT-64kB                            0                 0         
 -------------------------------------------------------------------------------


 2M folios: usemem30: zstd:
 ==========================

 -------------------------------------------------------------------------------
               mm-unstable-12-20-2024   v5 of this patch-series
 -------------------------------------------------------------------------------
 zswap compressor               zstd             zstd  
 vm.page-cluster                   2                2  
                                                        
 -------------------------------------------------------------------------------
 Total throughput (KB/s)   6,643,427        6,534,525     
 Avg throughput (KB/s)       221,447          217,817     
 elapsed time (sec)           102.92           104.44     
 sys time (sec)             2,332.67         2,415.00     
                                                     
 -------------------------------------------------------------------------------
 memcg_high                   61,999           60,770
 memcg_swap_fail                  37               47
 zswpout                  48,934,491       48,934,952
 zswpin                          386              404
 pswpout                           0                0
 pswpin                            0                0
 thp_swpout                        0                0
 thp_swpout_fallback              37               47
 pgmajfault                    5,010            4,646
 swap_ra                       5,836            4,692
 swap_ra_hit                   5,790            4,640
 ZSWPOUT-2048kB               95,529           95,520
 SWPOUT-2048kB                     0                0
 -------------------------------------------------------------------------------


 2M folios: usemem30: deflate-iaa:
 =================================

 -------------------------------------------------------------------------------
                 mm-unstable-12-20-2024        v5 of this patch-series
 -------------------------------------------------------------------------------
 zswap compressor           deflate-iaa      deflate-iaa     IAA Batching          
 vm.page-cluster                      2                2      vs.     vs.
                                                              Seq    zstd
 -------------------------------------------------------------------------------
 Total throughput (KB/s)      8,197,457        8,427,981       3%     29%
 Avg throughput (KB/s)          273,248          280,932       3%     29%
 elapsed time (sec)               86.79            83.45      -4%    -20%
 sys time (sec)                2,044.02         1,925.84      -6%    -20%
                                                                
 -------------------------------------------------------------------------------
 memcg_high                      94,008           88,809        
 memcg_swap_fail                     50               57        
 zswpout                     64,521,910       64,520,405        
 zswpin                             421              452        
 pswpout                              0                0        
 pswpin                               0                0        
 thp_swpout                           0                0        
 thp_swpout_fallback                 50               57        
 pgmajfault                       9,658            8,958        
 swap_ra                         19,633           17,341        
 swap_ra_hit                     19,579           17,278        
 ZSWPOUT-2048kB                 125,916          125,913        
 SWPOUT-2048kB                        0                0        
 -------------------------------------------------------------------------------


Performance testing (Kernel compilation, allmodconfig):
=======================================================

The experiments with kernel compilation test, 32 threads, in tmpfs use the
"allmodconfig" that takes ~12 minutes, and has considerable swapout
activity. The cgroup's memory.max is set to 2G.


 16k/32k/64k folios: Kernel compilation/allmodconfig:
 ====================================================
 w/o: mm-unstable-12-20-2024

 -------------------------------------------------------------------------------
                               w/o            v5            w/o             v5
 -------------------------------------------------------------------------------
 zswap compressor             zstd          zstd    deflate-iaa    deflate-iaa          
 vm.page-cluster                 0             0              0              0
                                                                              
 -------------------------------------------------------------------------------
 real_sec                   792.04        793.92         783.43         766.93
 user_sec                15,781.73     15,772.48      15,753.22      15,766.53
 sys_sec                  5,302.83      5,308.05       3,982.30       3,853.21
 -------------------------------------------------------------------------------
 Max_Res_Set_Size_KB     1,871,908     1,873,368      1,871,836      1,873,168
 -------------------------------------------------------------------------------
 memcg_high                      0             0              0              0
 memcg_swap_fail                 0             0              0              0
 zswpout                90,775,917    91,653,816    106,964,482    110,380,500
 zswpin                 26,099,486    26,611,908     31,598,420     32,618,221
 pswpout                        48            96            331            331
 pswpin                         48            89            320            310
 thp_swpout                      0             0              0              0
 thp_swpout_fallback             0             0              0              0
 16kB_swpout_fallback            0             0              0              0                         
 32kB_swpout_fallback            0             0              0              0
 64kB_swpout_fallback            0         2,337          7,943          5,512
 pgmajfault             27,858,798    28,438,518     33,970,455     34,999,918
 swap_ra                         0             0              0              0
 swap_ra_hit                 2,173         2,913          2,192          5,248
 ZSWPOUT-16kB            1,292,865     1,306,214      1,463,397      1,483,056
 ZSWPOUT-32kB              695,446       705,451        830,676        829,992
 ZSWPOUT-64kB            2,938,716     2,958,250      3,520,199      3,634,972
 SWPOUT-16kB                     0             0              0              0
 SWPOUT-32kB                     0             0              0              0
 SWPOUT-64kB                     3             6             20             19
 -------------------------------------------------------------------------------



Summary:
========
The performance testing data with usemem 30 processes and kernel
compilation test show 30% throughput gains and 22% sys time reduction
(usemem30) and 27% sys time reduction (kernel compilation) with
zswap_store() large folios using IAA compress batching as compared to
zstd.

The iaa_crypto wq stats will show almost the same number of compress calls
for wq.1 of all IAA devices. wq.0 will handle decompress calls exclusively.
We see a latency reduction of 2.5% by distributing compress jobs among all
IAA devices on the socket (based on v1 data).

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
50% reduction in sys time and 3.5% reduction in workload run time as
compared to software compressors.


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



Kanchana P Sridhar (12):
  crypto: acomp - Add synchronous/asynchronous acomp request chaining.
  crypto: acomp - Define new interfaces for compress/decompress
    batching.
  crypto: iaa - Add an acomp_req flag CRYPTO_ACOMP_REQ_POLL to enable
    async mode.
  crypto: iaa - Implement batch_compress(), batch_decompress() API in
    iaa_crypto.
  crypto: iaa - Make async mode the default.
  crypto: iaa - Disable iaa_verify_compress by default.
  crypto: iaa - Re-organize the iaa_crypto driver code.
  crypto: iaa - Map IAA devices/wqs to cores based on packages instead
    of NUMA.
  crypto: iaa - Distribute compress jobs from all cores to all IAAs on a
    package.
  mm: zswap: Allocate pool batching resources if the crypto_alg supports
    batching.
  mm: zswap: Restructure & simplify zswap_store() to make it amenable
    for batching.
  mm: zswap: Compress batching with Intel IAA in zswap_store() of large
    folios.

 crypto/acompress.c                         |  287 ++++
 drivers/crypto/intel/iaa/iaa_crypto.h      |   27 +-
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 1697 +++++++++++++++-----
 include/crypto/acompress.h                 |  157 ++
 include/crypto/algapi.h                    |   10 +
 include/crypto/internal/acompress.h        |   29 +
 include/linux/crypto.h                     |   31 +
 mm/zswap.c                                 |  406 +++--
 8 files changed, 2103 insertions(+), 541 deletions(-)


base-commit: 5555a83c82d66729e4abaf16ae28d6bd81f9a64a
-- 
2.27.0

