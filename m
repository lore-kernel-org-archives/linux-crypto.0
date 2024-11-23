Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7AEE20E3;
	Sat, 23 Nov 2024 07:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732345290; cv=none; b=W2uVODjF7G6T3OENqaVYpwu/UPVW6vOR0xS1HsCzrQjH4HiXEl3zsOH0sqA06pCpGs7X+lQJ8QZoTLqWGTEURQPdxGQadJJg39pefj5oiQWIHhJZdWAEjHvZHGp9UkHnCxZkDEWWD6N5QTqiTmgrh/q6iylsb1iJ+jNoLi9JQz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732345290; c=relaxed/simple;
	bh=WPwn+QO9B0crb+USoWTLBajAJxXiILJM23nJr3h6x58=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Atpwz7ueqIrwctrf8e8dcRFDrIuRhLq+DxaZKafkqsLb02lOzaH+3mHl9tIsN52Gx/gag7LbcWTimcVViRIIy2ZhcJ+ck/JB2IJpwNgR3g69EcR+j/9l55IrnPZPgBSzIAN9hxigZ0m4fv2Vs7/jGFpufBJOFI74SSRGsrohIxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VPbhLrGg; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VPbhLrGg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732345289; x=1763881289;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=WPwn+QO9B0crb+USoWTLBajAJxXiILJM23nJr3h6x58=;
  b=VPbhLrGgO1YsHdHA9pckPQSS5ZptrZq7B7m+F6ZiU25ZuvhiWW7CCO+R
   RSwXVkckCkPZ9RbMIu/sjLmFQKUUNFH7BstlQj7P8lf9cFznrnOuKvn/1
   jIFG2qPlqYO3zofNOsBDated86168VzxuwBi+AvxDJkkIm0XR4wZtc7lg
   u0H1jneOJdz8Qy9f9OIOVHZjLMRQsf3ZdzEeDcIA+x8yYd9JqQkF861KO
   g3sR4r2k7YreEQdzb1YudqxkQWFtZNPmaVei9yyF2abgty0jT9e2a28Jz
   7TF3vx1T0rH7ljMX/KyGXTi4r1gaLlRTgCdrwfhWQawWIxKx8lBwtsatM
   w==;
X-CSE-ConnectionGUID: ZwDWdPpgQyOtZQoPnMRTkw==
X-CSE-MsgGUID: HY4DPtWITKuA1O7LMeJ9ew==
X-IronPort-AV: E=McAfee;i="6700,10204,11264"; a="32435447"
X-IronPort-AV: E=Sophos;i="6.12,178,1728975600"; 
   d="scan'208";a="32435447"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2024 23:01:28 -0800
X-CSE-ConnectionGUID: aP4DvTwNRtedGzYTnPtzYg==
X-CSE-MsgGUID: LeBvrpBnSOa1+uX44ZpT9Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,178,1728975600"; 
   d="scan'208";a="91573545"
Received: from unknown (HELO JF5300-B11A338T.jf.intel.com) ([10.242.51.115])
  by orviesa008.jf.intel.com with ESMTP; 22 Nov 2024 23:01:27 -0800
From: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	hannes@cmpxchg.org,
	yosryahmed@google.com,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	usamaarif642@gmail.com,
	ryan.roberts@arm.com,
	ying.huang@intel.com,
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
Subject: [PATCH v4 00/10] zswap IAA compress batching
Date: Fri, 22 Nov 2024 23:01:17 -0800
Message-Id: <20241123070127.332773-1-kanchana.p.sridhar@intel.com>
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
zswap swapout latency, resulting in sys time reduction by 41% (usemem 30
processes) and by 24% (kernel compilation); as well as a 39% increase in
usemem30 throughput with IAA batching as compared to zstd.

The patch-series is organized as follows:

 1) crypto acomp & iaa_crypto driver enablers for batching: Relevant
    patches are tagged with "crypto:" in the subject:

    Patch 1) Adds acomp_alg/crypto_acomp batch_compress() and
             batch_decompress() interfaces, that swap modules can invoke
             using the new batching API crypto_acomp_batch_compress() and
             crypto_acomp_batch_decompress(). Additionally, crypto acomp
             provides a new acomp_has_async_batching() interface to query
             for these API before allocating batching resources for a given
             compressor in zswap/zram.
    Patch 2) New CRYPTO_ACOMP_REQ_POLL acomp_req flag to act as a gate for
             async poll mode in iaa_crypto.
    Patch 3) iaa-crypto driver implementations for async polling,
             crypto_acomp_batch_compress() and crypto_acomp_batch_decompress().
             The "iaa_acomp_fixed_deflate" algorithm registers these
             implementations for its batch_compress and batch_decompress
             interfaces respectively.
    Patch 4) Modifies the default iaa_crypto driver mode to async.
    Patch 5) Disables verify_compress by default, to facilitate users to
             run IAA easily for comparison with software compressors.
    Patch 6) Reorganizes the iaa_crypto driver code into logically related
             sections and avoids forward declarations, in order to facilitate
             Patch 7. This patch makes no functional changes.
    Patch 7) Makes a major infrastructure change in the iaa_crypto driver,
             to map IAA devices/work-queues to cores based on packages
             instead of NUMA nodes. This doesn't impact performance on
             the Sapphire Rapids system used for performance
             testing. However, this change fixes problems found on Granite
             Rapids in internal validation, where the number of NUMA nodes
             is greater than the number of packages, which was resulting in
             over-utilization of some IAA devices and non-usage of other
             IAA devices as per the current NUMA based mapping
             infrastructure. This patch also eliminates duplication of device
             wqs in per-cpu wq_tables, thereby saving 140MiB on a 384 cores
             Granite Rapids server with 8 IAAs. Submitting this change now
             so that it can go through code reviews before it can be merged.
    Patch 8) Builds upon the new infrastructure for mapping IAAs to cores
             based on packages, and enables configuring a "global_wq" per
             IAA, which can be used as a global resource for compress jobs
             for the package. If the user configures 2WQs per IAA device,
             the driver will distribute compress jobs from all cores on the
             package to the "global_wqs" of all the IAA devices on that
             package, in a round-robin manner. This can be used to improve
             compression throughput for workloads that see a lot of swapout
             activity.

 2) zswap modifications to enable compress batching in zswap_batch_store()
    of large folios (including pmd-mappable folios):

    Patch 9) Changes the "struct crypto_acomp_ctx" to contain a configurable
             number of acomp_reqs and buffers. Subsequently, the cpu
             hotplug onlining code will query acomp_has_async_batching() to
             allocate up to SWAP_CRYPTO_BATCH_SIZE (i.e. 8)
             acomp_reqs/buffers if the acomp supports batching, and 1
             acomp_req/buffer if not.
    Patch 10) zswap_batch_store() IAA compress batching implementation
              using the new crypto_acomp_batch_compress() iaa_crypto driver
              API. swap_writepage() will call zswap_batch_store() for large
              folios if zswap_can_batch().

With v4 of this patch series, the IAA compress batching feature will be
enabled seamlessly on Intel platforms that have IAA by selecting
'deflate-iaa' as the zswap compressor.
 

System setup for testing:
=========================
Testing of this patch-series was done with mm-unstable as of 11-18-2024,
commit 5a7056135bb6, without and with this patch-series.
Data was gathered on an Intel Sapphire Rapids server, dual-socket 56 cores
per socket, 4 IAA devices per socket, 503 GiB RAM and 525G SSD disk
partition swap. Core frequency was fixed at 2500MHz.

Other kernel configuration parameters:

    zswap compressor  : zstd, deflate-iaa
    zswap allocator   : zsmalloc
    vm.page-cluster   : 0, 2

IAA "compression verification" is disabled and IAA is run in the async
poll mode (the defaults with this series). 2WQs are configured per IAA
device. Compress jobs from all cores on a socket are distributed among all
4 IAA devices on the same socket.

I ran experiments with these workloads:

1) usemem 30 processes with these large folios enabled to "always":
   - 16k/32k/64k
   - 2048k

2) Kernel compilation allmodconfig with 2G max memory, 32 threads, run in
   tmpfs with these large folios enabled to "always":
   - 16k/32k/64k


Performance testing (usemem30):
===============================
The vm-scalability "usemem" test was run in a cgroup whose memory.high
was fixed at 150G. The is no swap limit set for the cgroup. 30 usemem
processes were run, each allocating and writing 10G of memory, and sleeping
for 10 sec before exiting:

usemem --init-time -w -O -s 10 -n 30 10g


 16k/32/64k folios: usemem30:
 ============================

 -------------------------------------------------------------------------------
                            mm-unstable-11-18-2024   v4 of this patch-series
 -------------------------------------------------------------------------------
 zswap compressor               zstd   deflate-iaa   deflate-iaa   IAA Batching          
 vm.page-cluster                   2             2             2    vs.     vs.
                                                                    Seq    zstd
 -------------------------------------------------------------------------------
 Total throughput (KB/s)   6,284,634     7,149,906     8,392,830    17%     39%
 Avg throughput (KB/s)       209,487       238,330       279,761    17%     39%
 elapsed time (sec)           107.64         84.38         79.88    -5%    -29%
 sys time (sec)             2,566.69      1,844.32      1,592.02   -14%    -41%
                                                                      
 -------------------------------------------------------------------------------
 memcg_high                  477,219       616,897       683,170      
 memcg_swap_fail               1,040         2,734         2,330      
 zswpout                  48,931,670    55,520,017    57,467,487      
 zswpin                          384           491           415      
 pswpout                           0             0             0      
 pswpin                            0             0             0      
 thp_swpout                        0             0             0      
 thp_swpout_fallback               0             0             0      
 16kB-swpout_fallback              0             0             0                                                
 32kB_swpout_fallback              0             0             0      
 64kB_swpout_fallback          1,040         2,734         2,330      
 pgmajfault                    3,258         3,314         3,251      
 swap_ra                          95           128           112      
 swap_ra_hit                      46            49            61      
 ZSWPOUT-16kB                      2             4             3      
 ZSWPOUT-32kB                      0             2             0      
 ZSWPOUT-64kB              3,057,203     3,467,400     3,589,487      
 SWPOUT-16kB                       0             0             0      
 SWPOUT-32kB                       0             0             0      
 SWPOUT-64kB                       0             0             0      
 -------------------------------------------------------------------------------


 2M folios: usemem30:
 ====================

 -------------------------------------------------------------------------------
                            mm-unstable-11-18-2024   v4 of this patch-series
 -------------------------------------------------------------------------------
 zswap compressor               zstd   deflate-iaa   deflate-iaa   IAA Batching          
 vm.page-cluster                   2             2             2     vs.     vs.
                                                                     Seq    zstd
 -------------------------------------------------------------------------------
 Total throughput (KB/s)   6,466,700     7,245,936     9,107,731     26%     39%     
 Avg throughput (KB/s)       215,556       241,531       303,591     26%     39%     
 elapsed time (sec)           106.80         84.44         74.37    -12%    -30%     
 sys time (sec)             2,420.88      1,753.41      1,450.21    -17%    -41%     
                                                                        
 -------------------------------------------------------------------------------
 memcg_high                   60,926        79,259        90,314        
 memcg_swap_fail                  44           139           182        
 zswpout                  48,892,828    57,701,156    59,051,023        
 zswpin                          391           419           411        
 pswpout                           0             0             0        
 pswpin                            0             0             0        
 thp_swpout                        0             0             0        
 thp_swpout_fallback              44           139           182        
 pgmajfault                    4,907        11,542        30,492        
 swap_ra                       5,070        24,613        80,933        
 swap_ra_hit                   5,024        24,555        80,856        
 ZSWPOUT-2048kB               95,442       112,515       114,996        
 SWPOUT-2048kB                     0             0             0        
 -------------------------------------------------------------------------------


Performance testing (Kernel compilation, allmodconfig):
=======================================================

The experiments with kernel compilation test, 32 threads, in tmpfs use the
"allmodconfig" that takes ~12 minutes, and has considerable swapout
activity. The cgroup's memory.max is set to 2G.


 16k/32k/64k folios: Kernel compilation/allmodconfig:
 ====================================================

 -------------------------------------------------------------------------------
                           mm-unstable-11-18-2024    v4 of this patch-series
 -------------------------------------------------------------------------------
 zswap compressor             zstd    deflate-iaa    deflate-iaa   IAA Batching          
 vm.page-cluster                 0              0              0     vs.     vs.
                                                                    Seq    zstd
 -------------------------------------------------------------------------------
 real_sec                   783.15         792.78         789.65
 user_sec                15,763.86      15,779.60      15,775.48
 sys_sec                  5,198.29       4,215.74       3,930.92    -7%    -24%
 -------------------------------------------------------------------------------
 Max_Res_Set_Size_KB     1,872,932      1,873,444      1,872,896
 -------------------------------------------------------------------------------
 memcg_high                      0              0              0
 memcg_swap_fail                 0              0              0
 zswpout                88,824,270    109,828,718    109,402,157
 zswpin                 25,371,781     32,647,096     32,174,520
 pswpout                       121            360            297
 pswpin                        122            337            288
 thp_swpout                      0              0              0
 thp_swpout_fallback             0              0              0
 16kB_swpout_fallback            0              0              0                         
 32kB_swpout_fallback            0              0              0
 64kB_swpout_fallback          924         19,203          5,206
 pgmajfault             27,124,258     35,120,147     34,545,319
 swap_ra                         0              0              0
 swap_ra_hit                 2,561          3,131          2,380
 ZSWPOUT-16kB            1,246,641      1,499,293      1,469,160
 ZSWPOUT-32kB              675,242        865,310        827,968
 ZSWPOUT-64kB            2,886,860      3,596,899      3,638,188
 SWPOUT-16kB                     0              0              0
 SWPOUT-32kB                     1              0              0
 SWPOUT-64kB                     7             19             18
 -------------------------------------------------------------------------------


Summary:
========
The performance testing data with usemem 30 processes and kernel
compilation test show 39% throughput gains and 41% sys time reduction
(usemem30) and 24% sys time reduction (kernel compilation) with
zswap_batch_store() large folios using IAA compress batching as compared to
zstd.

The iaa_crypto wq stats will show almost the same number of compress calls
for wq.1 of all IAA devices. wq.0 will handle decompress calls exclusively.
We see a latency reduction of 2.5% by distributing compress jobs among all
IAA devices on the socket (based on v1 data).

We can expect to see even more significant performance and throughput
improvements if we use the parallelism offered by IAA to do reclaim
batching of 4K/large folios (really any-order folios), and using the
zswap_batch_store() high throughput compression to batch-compress pages
comprising these folios, not just batching within large folios. This is the
reclaim batching patch 13 in v1, which will be submitted in a separate
patch-series.

Our internal validation of IAA compress/decompress batching in highly
contended Sapphire Rapids server setups with workloads running on 72 cores
for ~25 minutes under stringent memory limit constraints have shown up to
50% reduction in sys time and 3.5% reduction in workload run time as
compared to software compressors.


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



Kanchana P Sridhar (10):
  crypto: acomp - Define two new interfaces for compress/decompress
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
  mm: zswap: Compress batching with Intel IAA in zswap_batch_store() of
    large folios.

 crypto/acompress.c                         |    2 +
 drivers/crypto/intel/iaa/iaa_crypto.h      |   18 +-
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 1637 ++++++++++++++------
 include/crypto/acompress.h                 |   96 ++
 include/crypto/internal/acompress.h        |   16 +
 include/linux/zswap.h                      |   19 +
 mm/page_io.c                               |   16 +-
 mm/zswap.c                                 |  759 ++++++++-
 8 files changed, 2090 insertions(+), 473 deletions(-)


base-commit: 5a7056135bb69da2ce0a42eb8c07968c1331777b
-- 
2.27.0

