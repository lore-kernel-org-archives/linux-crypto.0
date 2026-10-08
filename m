Received: from mail-dy1-f169.google.com (mail-dy1-f169.google.com [74.125.82.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16C6F4F4D0D
	for <linux-crypto@vger.kernel.org>; Thu,  8 Oct 2026 18:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791484121; cv=none; b=XeueExjtvj2Yu19GXHoZK/1H0GTM2/fe89izFrVOUWeaoie/BMTJHmcvAF/UGzqWv7NuPMvPA2lGQZ6SGVrD5Ntx5p0UgeUsLxBulou9bMaA3QU3cTSlkvcSaF7yNVLrZwFzNNkRQven5pbHxDEBgf6BulMq6yjIojrwefo5Sec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791484121; c=relaxed/simple;
	bh=axTEGPkJt6GBU0xuEPSXBP/7YGmL9myBsEY9c5Au5wk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=FcAiZGyn1pxfUA30OWWrHFCvIBmnE4GzotUNE8OtQ7jfaf0s+l88wpPRL8e0Agjeahmn1FdxAIde4e41bp6x4lBIv/a6zQyuXHJAMelxtCXL/7saVgVKtqd9o8Ge1Xjl94SjcALdYB3GOLeqejfMo09FibQyVEN9d7cfijhTR0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XQcR7gB6; arc=none smtp.client-ip=74.125.82.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XQcR7gB6"
Received: by mail-dy1-f169.google.com with SMTP id 5a478bee46e88-3515f9a5d25so1031383eec.0
        for <linux-crypto@vger.kernel.org>; Thu, 08 Oct 2026 11:28:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791484109; x=1792088909; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=xZEd1koy5JUNRs9RrhkiE6ort9fMSMjj77pbdlRj/T0=;
        b=XQcR7gB6Zex1mz2GoAkC6C4G/rEnXm+LDbuHI8rd+U6Pkv3n/K/SOTSaNINk8ikHAx
         LC6p6WzIMsEQtGCIUNghzyW0q7XTTy0s05/RSbYYfUjVIWCP3iCmuLCLyrWd+pii75jX
         +he+B8RDYRYXb24LguRe7rlsT5N2elN/qIrLb3BdF0mXY7vxCnidQIIAbOg3/ltKRwwm
         1NFUtVpnffnbS0Fu0n/SdzFES/aUsIoZAVH4bdIY+sUKUtQalj8sw6r5XOpK5edSaaPe
         DPJv088NlmO1Wd1VAyDPWbssYDEzWs55+lhf9RMuV0jHq1NymdVzMxwS5OXbRlOV6CXh
         zKiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791484109; x=1792088909;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xZEd1koy5JUNRs9RrhkiE6ort9fMSMjj77pbdlRj/T0=;
        b=jyCaqfGrnqCyF5xBBlBe8hPA8a6oETAAjSE4DL142HzCml5760VMERnSxHRdSlHQEA
         q2BfzVplr3/FxhYw3h3L6WXD07qhNZ3Hchyyc+TvoMzM2uImcQqZdJ/Olu2i+3vt1QZb
         JE1T+8n9nKK2vHq/P6z6+WGRHLojQLDga7T++E5X2E/hbChO9vcszXyYktDtlTiu2fEz
         aXSUfOWGj2Mm6SiSd/Xey/n/PygzK6WOL6Rga2e77qOjqZIj7hLz8JAgWS0EBBsfYxmQ
         pyE6s00pNpK2/bvWdZB6h2nezUawNt7vvJUZo1WXLlmvRdMCIcivR3dpQRjc2Pme6Wq8
         6SDA==
X-Forwarded-Encrypted: i=1; AKwUvBwLalutxOUXXq3xpkIUca1s4uEts8gJGj0OUnGODvE4/cjH3MaudoZNzp/lW7TxzmlOl9SFkNYTdhsbKZI=@vger.kernel.org
X-Gm-Message-State: AFuF++mAYR37tRs+i5HgCk8jA2cGQee3c9tM3/0HG7Sa8KTR7ayDb9cw
	GTs5RZr55Bcgx0NQ+oQXdJZ5N201ywDhaCXDAKpt/VEuDSxaHjNfXtyjA/Tsxg==
X-Gm-Gg: AYBFou0I9mqPmWp18degwUWPK8wJGll333S0YcSGPrbDrodMl3Y0zQZgQ6gQ+MG+/O0
	aRwU7lVGMD2CEN7NuPhu1TQL772nWvyNLzFfIkozbW0BVJLUcVq3ykONe3Bwp5NH1udbNGRVNkz
	lifEHbnwbzn2LeHqliW8NDyhla8oBXbzfPj4GSbFmpYU2EbzuLx6KJNaI2ql6GNzp1oTOfTUpTi
	YV2MxY76EFPhKsVc4CGZCEZxWd1zyjd8mIEK344Z0P/LyjN+2Gg0f6zzHzpi4qrsbL0U6ZPnX3T
	YZAYP5fVMHzvaq72Mtx8NJqyqJScT47t9LVFxN2ezz4kpIGf43uOionuJQaTXroVJHOLOjx70bz
	T/S8nAtEosk54QWhCga8CzQHF20FvU1gMxARZQreAhHWEBXBhbit9C6zjhtPiNqX0bE6olHwlKg
	OC4TIIuxKjMs4qBqcQtG+eHGi7YRsS5n+QF5VBBywzXyuYJXIElnB11wZWvrmzBsTFoRaXx8hWI
	ri1Qg2KGI4=
X-Received: by 2002:a05:701b:4519:20b0:151:2068:e81f with SMTP id a92af1059eb24-162076c832amr7195694c88.27.1791484109046;
        Thu, 08 Oct 2026 11:28:29 -0700 (PDT)
Received: from penguin.lxd ([12.187.136.98])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-169a2d2db98sm57236c88.10.2026.10.08.11.28.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 11:28:28 -0700 (PDT)
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
To: hannes@cmpxchg.org,
	yosry@kernel.org,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	kanchanapsridhar2026@gmail.com,
	linux-kernel@vger.kernel.org
Cc: rientjes@google.com,
	willy@infradead.org,
	senozhatsky@chromium.org
Subject: [PATCH v1 0/8] Batched zswap_store() with compression batching
Date: Thu,  8 Oct 2026 11:28:06 -0700
Message-Id: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v1: Batched zswap_store() with compression batching
===================================================

This series is a spin-off of "v14: zswap compression batching with optimized
iaa_crypto driver" [1], and focuses on the generic crypto_acomp and zswap
compression batching enablers. Resuming work on this series following a gap
since v14 (January 2026). Please note that my email address and affiliation have
changed from kanchana.p.sridhar@intel.com to kanchanapsridhar2026@gmail.com. I
have retained the original Intel sign-offs on prior patches for historical
attribution while signing off v1 of this series with my current address.

To summarize the main contribution of this patch series: Batching is introduced
in zswap_store() of large folios: we carve out a large folio into batches of
ZSWAP_MAX_BATCH_SIZE (8 pages) for software compressors, and store each
batch. Moving the fundamental operations that need to be happen to store a page
to now work at the granularity of a batch offers opportunities to optimize them
from these perspectives:

1) Utilize existing kernel API that minimize obtaining locks for bulk
   operations, e.g. kmem_cache_alloc_bulk()/kmem_cache_free_bulk().

2) We keep the working set for each of the core store functionalities (alloc
   entries, compress pages, store pages in zsmalloc) to be focused on a
   batch, thereby minimizing cache evictions and benefiting from cache
   locality.

3) Along the lines of (1), the main zswap_compress() batching routine obtains
   the acomp_ctx mutex lock once per batch, and releases it after it has
   processed all pages in that batch.

4) Any zswap store functionality that works on a batch can potentially be
   parallelized as a next step, to further improve performance.

Performance data: usemem with 60% over-commit:
==============================================
Validation was done with mm-unstable as of 10-3-2026 (Baseline) and with this
patch series.

Testing was done on a Chromebook with a QEMU "vng" VM running in Crostini.
    
Chromebook Diagnostics reports:
  Intel(R) Core(TM) Ultra 5 115U (10 CPUs, 4.200GHz)
  RAM: 16GB

vng setup:
         Memory: 7G
           Swap: 3G
    Pinned CPUs: 4 (E-Cores: 4,5,6,7)

zswap compressor:
  ZSTD

mTHP enabled:
  64kB

vm-scalability/usemem setup:

  cgroup memory.high: 3G
  4 usemem processes, each allocates 1200M anonymous memory, reads the
  Silesia dataset [2] from a pre-fork-allocated buffer into the 1200M,
  writes to each unsigned long in the 1200M, sleeps for 10 sec, then
  frees the memory and exits.

    usemem --read-silesia -w -O -b 1 -s 10 -n 4 1200M

 usemem metrics averaged across 10 iterations*:
 ================================================
 
 --------------------------------------------------------------------------
                                          Baseline       Patch     Change
                                       mm-unstable      series       with
                                         10-3-2026          v1         v1  
 --------------------------------------------------------------------------
 Average Throughput (KB/s)                  11,794      17,810    +51.00%
 Total Throughput (KB/s)                    47,179      71,242    +51.00%
 Average Time to Free Memory (usecs)       490,973     294,920    -39.93%
 Total Time to Free Memory (usecs)       1,963,892   1,179,682    -39.93%
 --------------------------------------------------------------------------
 * vmstats are as reported at the end of the 10th iteration:

 64kB-alloc                                834,567     828,199     -0.76%
 64kB-zswpout                              700,138     743,697      6.22%
 64kB-swpout-fallback                       35,342      17,978    -49.13%
 64kB-swpout                                     0           0           
 --------------------------------------------------------------------------

 The speedup with zswap store batching of large folios has a propelling effect
 on other parts of mm, especially, by enabling large folios to be swapped out
 without splitting, as the data shows. This enables other mm components that are
 optimized for large folios, such as munmap(), folio refcounts/mapcounts
 updates, PTE invalidation upon freeing memory, zswap_invalidate(); which
 benefit from xarray offsets/range continuity. As a result, subsequent large
 folio swapouts are more likely to find contiguous swap slots, there are fewer
 large folio splits during reclaim, more mTHP zswpouts and the cycle
 continues. As the data demonstrates, this directly contributes to more memory
 over-commit opportunity.

Detailed usemem metrics/cgroup memory utilization/vmstats:
==========================================================

 A) MAX zswap pool_total_size vmstats:
 =====================================
 This is a snapshot at the 10th iteration's peak zswap pool usage:

 --------------------------------------------------------------------------
                                    Baseline             Patch     Change
                                 mm-unstable            series       with
                                   10-3-2026                v1         v1  
 --------------------------------------------------------------------------
 pswpin                                    0                 0
 pswpout                                   0                 0
 thp_swpout                                0                 0
 thp_swpout_fallback                       0                 0
 swpin_zero                              594               548
 swpout_zero                           1,062               864
 zswpin                           10,603,882        11,070,673
 zswpout                          16,594,356        16,509,201     -0.51%
 zswpwb                                    0                 0           
 nrswpin                                   0                 0           
 nrswpout                                  0                 0           
 pgmajfault                        1,460,360         1,470,092      0.67%
 nr_free_pages                       897,249           908,935      1.30%
 nr_free_pages_blocks                892,928           903,680      1.20%
 64kB-alloc                          831,788           825,556     -0.75%
 64kB-zswpout                        690,961           735,863      6.50%
 64kB-swpout                               0                 0           
 64kB-swpout-fallback                 32,982            16,545    -49.84%
 64kB-swpin                                0                 0           
 zswap_pool_total_size         1,420,120,064     1,377,210,368     -3.02%
 memory.current                3,390,189,568     3,299,569,664     -2.67%
 memory.swap.current           3,221,221,376     3,221,221,376
 --------------------------------------------------------------------------

  B) STEADY STATE vmstats after usemem finishes:
  ==============================================
  This is a snapshot after the 10th iteration finishes:

 --------------------------------------------------------------------------
                                    Baseline             Patch     Change
                                 mm-unstable            series       with
                                   10-3-2026                v1         v1  
 --------------------------------------------------------------------------
 pswpin                                    0                 0 
 pswpout                                   0                 0
 thp_swpout                                0                 0
 thp_swpout_fallback                       0                 0
 swpin_zero                              594               548
 swpout_zero                           1,062               949
 zswpin                           11,526,695        11,963,729
 zswpout                          17,293,120        17,219,911     -0.42%
 zswpwb                                    0                 0           
 nrswpin                                   0                 0           
 nrswpout                                  0                 0           
 pgmajfault                        1,591,298         1,596,095      0.30%
 nr_free_pages                     1,752,789         1,753,264      0.03%
 nr_free_pages_blocks              1,258,496         1,240,064     -1.46%
 64kB-alloc                          834,567           828,199     -0.76%
 64kB-zswpout                        700,138           743,697      6.22%
 64kB-swpout                               0                 0           
 64kB-swpout-fallback                 35,342            17,978    -49.13%
 64kB-swpin                                0                 0           
 zswap_pool_total_size                     0                 0           
 memory.current                      757,760           802,816      5.95%
 memory.swap.current                       0                 0
 --------------------------------------------------------------------------
 zswap debugfs counters:                                      
                                                              
  pool_limit_hit                           0                 0
  written_back_pages                       0                 0
  reject_alloc_fail                        0                 0
  reject_kmemcache_fail                    0                 0
  reject_reclaim_fail                      0                 0
  reject_compress_fail                     0                 0
  reject_compress_poor                     0                 0
  decompress_fail                          0                 0
  stored_incompressible_pages              0                 0
  stored_pages                             0                 0
 --------------------------------------------------------------------------


[1]: https://patchwork.kernel.org/project/linux-mm/cover/20260125033537.334628-1-kanchana.p.sridhar@intel.com/
[2]: https://wanos.co/assets/silesia.tar


Changes since [1]:
==================
1) Better cacheline placement of struct zswap_pool and struct zswap_entry
   members for temporal memory access efficiency in zswap store/load hot paths,
   while minimizing holes.

2) Refactored the core compression batching functionality to a separate
   __zswap_compress() function, which is called by zswap_compress(), as per
   Nhat's and Yosry's comments. Hopefully this helps explain the outer "store
   batching" zswap_compress() vis-a-vis the inner "compress batching"
   __zswap_compress() distinction.

3) The acomp_ctx is locked once and is passed to the routine that compresses a
   batch, per the algorithm's batch-size. Similarly, the folio's node id and
   writeback_enabled status are computed once and passed to the routines that
   implement the different store functionalities, to save latency by avoid
   localized recomputes of information that doesn't change.

4) Moved the folio node id being stored in zswap_entry to a separate patch, per
   Yosry's comment.

5) Addressed the kunmap_local() issue flagged by Jixin He in the
   IS_ERR_VALUE(handle) error path
   (https://patchwork.kernel.org/comment/27095925) - thanks!

6) Moved comments inline, per Yosry's suggestions.

Thanks,
Kanchana


Kanchana P. Sridhar (8):
  crypto: acomp - Define a unit_size in struct acomp_req to enable
    batching. mm: zswap: Set the unit size for zswap to PAGE_SIZE.
  crypto: acomp - Add bit to indicate segmentation support.
  crypto: acomp - Add trivial segmentation wrapper.
  crypto: acomp - Add API to get a compression algorithm's batch-size.
  mm: zswap: Store the folio's node id in the zswap_entry.
  mm: zswap: Store large folios in batches.
  mm: zswap: Optimally place members of struct zswap_pool, struct
    zswap_entry.
  mm: zswap: Batched zswap_compress() for storing large folios in
    batches.

 crypto/acompress.c                  |  47 ++-
 include/crypto/acompress.h          |  62 +++
 include/crypto/algapi.h             |   5 +
 include/crypto/internal/acompress.h |   8 +
 include/linux/crypto.h              |   3 +
 mm/zswap.c                          | 571 ++++++++++++++++++++--------
 6 files changed, 528 insertions(+), 168 deletions(-)

-- 
2.39.5

