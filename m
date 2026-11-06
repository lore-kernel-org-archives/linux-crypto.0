Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793949860;
	b=dMDYszieqHmMXnkXxG5iWE3a1zHV9hECyh+sCPTfXDuyWJ6JOYLVGJWoKedqmWvLuUJK
	 dZPTs56VGQ91796mSwMVoPg3L3hHRXz8YAkjXnqaoqKwZQQgPpzenaZsFcQIqCdI/B4Kc
	 EPR8wyPCceUyxMdckZCt58tsQXH9HuMi4Km9/kWXrvqiXozfD4Iu3RcihhKjs/5NCSNOS
	 4UwLamZXjL0VseddGyG/mFh46a8wm7o+GZS0OQZrq+ohowPysVQmWdrG3c+hCg8Q5HBLc
	 BXs4ubQsalIvosyYkq7vbB+EcuIupowy0Ki7CG90KN0DSaQZrb1x6kcN1A0xemODo2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793949860;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=2o9B9YhK3smzCObX+gQHTUgf7FfettUJfDQIQUIuKAI=;
	b=KJp2uaBLZekjyGk2Yjm2+rp2y/yjti8kMpLtYMEA0KD1Xk3MBPJNiIkqti78eJMz1nNl
	 2zgq9Iyn6t8EEvycNbREg1OMjWQs4odu+YP4jv7O66FaviqHJD8W0mQ2BNWJj2PD2iHLA
	 JnN1HLOStxB9RcoAKAsQBZ+k1MU2lwD9BmF9gkb2oyvKgJxuTfju5zPbfuBNBF/7cY1py
	 5202nm+9JOlqT6/8PUpuYgAQnhHECU636laQeF/3zwsWVzfJBNxLzEOvBg9BIMggJI96w
	 sQnbD0g3kcQcNdHfqSaYxPNoDqlR2GXVU0yTkfRDPDnCttfPrxwPm67P1b9SmwHNrWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WXztraq+;
	arc=none smtp.remote-ip=74.125.82.51
Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E0EA606A328
	for <linux-crypto@vger.kernel.org>; Fri,  6 Nov 2026 07:24:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4E0EA606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WXztraq+
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-1931ff67a29so1219528c88.1
        for <linux-crypto@vger.kernel.org>; Thu, 05 Nov 2026 23:24:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793949858; x=1794554658; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=2o9B9YhK3smzCObX+gQHTUgf7FfettUJfDQIQUIuKAI=;
        b=WXztraq+XnZPMlh2bB/V7L8i2s3moysoEQbEucldlkjFSB8dQSgBow5w/u0I86r/1A
         AtEePNIhDBFp7NLMCbmVLfOp4+cKTUEFR5Vc0dSGSHmtViAwaUUX3KhwwpUBzsTPWor6
         iBsB+c43xuBXqZ/rbkR2BnqlahqTyY6Pp4k20Oo200HAamTxpp0c6WIwUBT0A8eTjHDb
         wWt3J3rzKRGUPhz0IljJcnU3//20UsEXjkiZbo1xiDNNEPTKlCcpTV8jsDpwDc0a+e4i
         w72x4i7lbF5HIrBD8HznDCmotSRoiVlKESs5qqGYkJaWqe0XO40OGDE05leVu9bhhg1U
         h9sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793949858; x=1794554658;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2o9B9YhK3smzCObX+gQHTUgf7FfettUJfDQIQUIuKAI=;
        b=zoQESf1cQ5betNaQvVnXA4nHU55k5ipfnnj0hnyCGyWt17WVTWukgIJCqJ17Zoz1Wi
         3imLF8agWrdkexAoO2LrgDcmos557xTsUvS5rkIL0TX97lvI6zxzPfahzxZZ7r15yRZn
         blcbhTGVpVTNnqHHtk/j1mBmea5ggnWAiducaWDZxzbS6HgNEqh5HnVbZOQssW+hII8/
         NCQflu+SZlLK3IWiA8oEwiLv7lq/sc/eNCLVAsBE5t/O3RArk/rzD3J9RMumOgDFtsbj
         XHyfmbVJo4waAqr55CWQi/pnb+PqP4Eac+PSCFtg1WirLWUUtzQ3V/qfFXHP0t/uhLtS
         MjlQ==
X-Forwarded-Encrypted: i=1; AKwUvBxSo10rzKXNpFmVBZ8b/RBdESSpwH/CbyyhDB0xvQ+lsYgrhuRzLxF+WFBQ2K7nMtMvcZG+mG5BD7Ngzpw=@vger.kernel.org
X-Gm-Message-State: APuU4Z+VraRbAr9VOwWcOClr5QHqs76uYcnJ47BICT0exIG9Dzn6pKvg
	ABWtgV+gf3etniz914FEyV77mznsFMJ1ZE7KIwe/3Nbuy8tO7qnRFv6K
X-Gm-Gg: AYBFou2KXbCp1xkFurdr4qEpFJABTuicAx6ONeJ8T6l/W36sEFBJdck+EYcVGnZwhoG
	2rSZV3iFBQh1v4HTEof+9sxpm9MEdRlHg3q8aA5XuOrOOQhmhkl/Q/mcyaRbOT9yal+bLbsTGmV
	5b94oQRnzZ/gL2ec+UGNHcFb/m8eG6YHU4IuZydmb78lrg2U1L2R7mu33JHKeKTtxgjMjiPuCUZ
	1XuKca172LXXRkqCbOTmC4bVUfT9ttaGIX6OLh42sHHEs/+H4yZI3yk1dcO4Q4BpGLNrAJwNeJC
	T00WCKPmvRwGL+Xr4QuawvgdGhidpH1fa8nBbHeuWBR5nS2nEfeoII+daaIrGc0uDUXTCLiAPuZ
	jfQL5L94CaOsAWg4jsVy7/M2ULiQLBMX2tRsfYOcCZF11+2/Qr2bkdQ+zaNELTk9Us0tOqMbzJ3
	6FsxNv1hS2g1SvLO0WtcEPSqw9CmpMJlJJiHC34mej5ORwTV4FkJaRhP7EvkvMZ03y+d05Cg6nm
	jh7qfafCUBOOIhIFQRdrWZ19SRXk0242YtAGjWuhfi9Z5tCVOcFAnfTAMXVWRYjDEi4aNgTgvEw
	GkGEYjpeJJT1ZEqT5E48Ryq+kI/NnYbo30ag4kGQGVbvqM8G4Y+nfZXc48R4t88=
X-Received: by 2002:a05:701b:465e:b0:1b2:4e2e:d95a with SMTP id a92af1059eb24-1b25d2892b4mr1893983c88.2.1793949857890;
        Thu, 05 Nov 2026 23:24:17 -0800 (PST)
Received: from penguin.lxd ([12.187.136.98])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b25e4840f3sm6262220c88.5.2026.11.05.23.24.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 23:24:17 -0800 (PST)
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
Subject: [PATCH v3 0/8] Batched zswap_store() framework with compression batching.
Date: Thu,  5 Nov 2026 23:24:04 -0800
Message-Id: <20261106072412.7909-1-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v3: Batched zswap_store() framework with compression batching
=============================================================

This series is a spin-off of "v14: zswap compression batching with optimized
iaa_crypto driver" [1], and focuses on the generic crypto_acomp and zswap
compression batching enablers. Resuming work on this series following a gap
since v14 (January 2026). Please note that my email address and affiliation have
changed from kanchana.p.sridhar@intel.com to kanchanapsridhar2026@gmail.com. I
have retained the original Intel sign-offs on prior patches for historical
attribution while signing off v3 of this series with my current address.

The main focus of v3 was to incorporate Sashiko's code review comments and
gather results by disabling memory.high overage-driven stalls, based on Yosry's
comment in [3]. The rest of the validation methodology remains the same: 
2 usemem processes, PMD THP enabled in an experiment with 56% over-commit.

To summarize the main contribution of this patch series: Batching is introduced
in zswap_store() of large folios: we carve out a large folio into batches of
ZSWAP_MAX_BATCH_SIZE (4 pages) for software compressors, and store each
batch. Moving the fundamental operations that need to be happen to store a page
to now work at the granularity of a batch offers opportunities to optimize them
from these perspectives:

1) Utilize existing kernel API that minimize obtaining locks for bulk
   operations, e.g. kmem_cache_alloc_bulk()/kmem_cache_free_bulk().

2) We keep the working set for each of the core store functionalities
   (alloc/initialize zswap entries, compress pages, store pages in zsmalloc,
   pool/objcg reference increments, objcg charging) to be focused on a
   batch, thereby minimizing cache evictions and benefiting from cache
   locality.

3) Along the lines of (1), the main zswap_compress() batching routine obtains
   the comp_ctx mutex lock once per batch, and releases it after it has
   processed all pages in that batch.

4) Any zswap store functionality that works on a batch can potentially be
   optimized via bulk-processing/parallelized as a next step, to further improve
   performance.

Performance data: usemem with 56% over-commit:
==============================================
Validation was done with mm-unstable as of 10-25-2026 (Baseline) and with this
patch series. To minimize variation in the data and to help drive useful
conclusions, I made these changes to my performance measurement methodology:

1) Reduced the number of usemem processes to 2. Each process tries to allocate
   2400M, in a 3G cgroup memory.high budget, effectively accomplishing a 56.25%
   over-commit.

2) Modified memcontrol.c/calculate_high_delay() to always return 0 to mirror the
   "hack" noted by Yosry in [3] to minimize variation due to process throttling
   when memory.high is breached.

3) Enabled PMD THP, which forces zswap_store()/zswap_compress() latency to be in
   the critical path, and also generates sufficient samples for reliable
   bpftrace measurements.

4) v3 does not report usemem throughput metrics, instead focuses solely on bpftrace
   p50/p95/p99 latencies of zswap_store() and zswap_compress() to validate the
   benefit of store batching and compress batching respectively.

5) I used lhist() instead of hist() in bpftrace to gather latencies at a finer
   level of granularity and accuracy.

Testing was done on a Chromebook with a QEMU "vng" VM running in Crostini.
    
Chromebook Diagnostics reports:
  Intel(R) Core(TM) Ultra 5 115U (10 CPUs, 4.200GHz)
  RAM: 16GB

vng setup:
         Memory: 7G
           Swap: 3G
    Pinned CPUs: 2 (E-Cores: 2,3)

zswap compressor:
  ZSTD

mTHP enabled:
  2048kB (PMD THP)

I used the help of an LLM to write the bpftrace data post-processing scripts
that generate latency percentiles.

vm-scalability/usemem setup:

  cgroup memory.high: 3G
  2 usemem processes, each allocates 2400M anonymous memory, reads the
  Silesia dataset [2] from a pre-fork-allocated buffer into the 2400M,
  writes to each unsigned long in the 2400M, sleeps for 10 sec, then
  frees the memory and exits.

    usemem -w --read-silesia -O -b 1 -s 10 -n 2 2400M

 usemem metrics are reported from a single run after starting the QEMU VM.
 Further, I have tabulated the bpftrace p50/p95/p99 latencies with these labels:

 "zswap_store_higher_order_folio":
    zswap_store() of PMD folios.

 "zswap_store_order0_folio":
    zswap_store() of order-0 folios.

 "zswap_batch_compress_per_page":
    zswap_compress() per-page latency of store batches generated from PMD
    folios.

 "zswap_single_compress_per_page":
    zswap_compress() per-page latency of order-0 folios.

 =============================================================================
   usemem PMD THP BPFTRACE
 =============================================================================
           Baseline           zswap           zswap          Change    Change
        mm-unstable           store        compress            with      with
         10-25-2026        batching        batching        compress  compress
                        (patch 6-7)       (patch 8)        batching  batching
                                                               (ns)       %
 =============================================================================
  zswap_store_order0_folio (ns):
 =============================================================================
  p50        39,631          37,538          37,765          -1,866    -4.71% 
  p95        53,088          49,690          49,349          -3,739    -7.04% 
  p99        65,065          63,529          57,404          -7,661   -11.77%
 =============================================================================
  zswap_store_higher_order_folio (ns):
 =============================================================================
  p50    21,460,366      21,201,411      20,383,233      -1,077,133    -5.02%
  p95    25,975,341      27,558,253      25,045,350        -929,991    -3.58%
  p99    29,538,493      61,926,648      27,184,835      -2,353,658    -7.97%
 =============================================================================
  zswap_single_compress_per_page (ns):
 =============================================================================
  p50        37,545          39,320          37,218            -327    -0.87%
  p95        51,549          66,503          51,481             -68    -0.13%
  p99        89,866         134,854          87,091          -2,775    -3.09%
 =============================================================================
  zswap_batch_compress_per_page (ns):            
 =============================================================================
  p50                                        40,493           2,948     7.85%
  p95                                        56,944           5,395    10.47%
  p99                                        76,242         -13,624   -15.16%
 =============================================================================

 ==========================================================================
  vmstat summary:
 ==========================================================================
  usemem                          Baseline           zswap           zswap
  PMD THP                      mm-unstable           store        compress
                                10-25-2026        batching        batching
                                               (patch 6-7)       (patch 8)
 ==========================================================================
  zswpin                           989,367       1,050,081         949,046       
  zswpout                        1,567,607       1,634,772       1,533,088       
  2048kB-alloc                       2,500           2,504           2,500   
  2048kB-zswpout                     1,557           1,552           1,539   
  2048kB-swpout-fallback               793             834             743     
  2048kB-swpout                          0               0               0
  pswpin                                 0               0               0
  pswpout                                0               0               0
  zswpwb                                 0               0               0
 ==========================================================================

 ==========================================================================
  zswap stats after workload finishes:
 ==========================================================================
  usemem                          Baseline           zswap           zswap
  PMD THP                      mm-unstable           store        compress
                                10-25-2026        batching        batching
                                               (patch 6-7)       (patch 8)
 ==========================================================================
  pool_limit_hit                         0               0               0
  written_back_pages                     0               0               0
  reject_alloc_fail                      0               0               0
  reject_kmemcache_fail                  0               0               0
  reject_reclaim_fail                    0               0               0
  reject_compress_fail                   0               0               0
  reject_compress_poor                   0               0               0
  decompress_fail                        0               0               0
  stored_incompressible_pages            0               0               0
  stored_pages                           0               0               0
  pool_total_size                        0               0               0
 ==========================================================================


Conclusions based on the data:
==============================

 The batching of zswap_store() phases, and compress batching optimizations
 benefit zswap_store() and zswap_compress_per_page() median and tail latencies
 for PMD folios and base 4K folios. The benefits are attributable to the store
 batching framework added in patches 6-7, that is fully utilized to improve
 zswap_compress() latency by giving it a batch of pages to be compressed. As the
 bpftrace data shows, patches 6-7 alone are not sufficient for the gains. Batch
 compression added in patch 8 benefits latency significantly, for these reasons:

  1) Per-CPU sg_table with ZSWAP_MAX_BATCH_SIZE scatterlists that are statically
     mapped to compression dst buffers for that CPU, thereby minimizing local SG
     lists initialization, and using compact new crypto_acomp API introduced in
     patches 1-4 that set up an acomp_req's src/dst to be SG lists.

  2) Patch 6 allocates ZSWAP_MAX_BATCH_SIZE destination buffers in the per-CPU
     acomp_ctx, for an added memory overhead of ~12 KB per-CPU. The trade-off pays
     off in significant latency improvements which can potentially be used to
     drive higher memory over-commit.

  3) A one-shot zswap_update_entries() does all the zsmalloc handle allocation
     and copying for the batch. The key concept driving efficiency is that the
     working set is kept focused on batch-centric data pertaining to a handful
     of operations on the batch, to minimize cache evictions and benefit from
     cache locality.

  4) By making zswap_compress() more efficient, we are able to lock the comp
     mutex per batch of ZSWAP_MAX_BATCH_SIZE (4) pages instead of per-page.
     
 The exceptions are p50/p95 batch compress latencies (normalized per-page), even
 though the p99 batch compress latency improves significantly, by 15% over
 mm-unstable. Batch compress latency can be optimized further in subsequent
 patches. The batching framework established in this series allows us to make
 locking and bulk-processing improvements in each stage of zswap_store(). One of
 the ideas that shown very promising results is to replace zsmalloc with SLUB
 compressed caches and will be submitted separately. This is expected to resolve
 the p50 batch compress latency issue since it will be directly optimizing
 zswap_update_entries(), where compressed buffers can be binned based on size
 and bulk allocated from SLUB.
 
 The speedup with zswap store batching of large folios has a propelling effect
 on other parts of mm, especially, by enabling large folios to be swapped out
 without splitting, as the data shows. This enables other mm components that are
 optimized for large folios, such as munmap(), folio refcounts/mapcounts
 updates, PTE invalidation upon freeing memory, zswap_invalidate(); which
 benefit from xarray offsets/range continuity. As a result, subsequent large
 folio swapouts are more likely to find contiguous swap slots, there are fewer
 large folio splits during reclaim and the cycle continues. As the data
 demonstrates, this directly contributes to more memory over-commit
 opportunity.

[1]: https://patchwork.kernel.org/project/linux-mm/cover/20260125033537.334628-1-kanchana.p.sridhar@intel.com/
[2]: https://wanos.co/assets/silesia.tar
[3]: https://lore.kernel.org/all/auOZBtRqQGzFcbAT@google.com/


Changes since v2:
=================

Resolved v2 code review issues highlighted by Sashiko. Baseline mm-unstable as
of 10-25-2026, commit a2abad0d7f45.

1) Patch 3:
  - Re-wrote the fast path conditional to be !acomp_is_async(tfm) instead of
    !acomp_req_on_stack(req).
  - Moved the state-flag changes from acomp_save_req() back to
    acomp_virt_to_sg().

2) Patch 4:
  - Replaced the ambiguous use of "cra_flags & CRYPTO_ALG_TYPE_ACOMPRESS" with
    directly checkinf for "cra_type == &crypto_acomp_type" to detect an
    acomp_alg.

3) Patch 5:
  - Fixed the off-by-one bitfield width by modifying
    ZSWAP_MAX_COMPR_LENGTH_SHIFT to 19U and the build time assertion check for
    BUILD_BUG_ON(ZSWAP_MAX_COMPR_LENGTH_SHIFT <= PAGE_SHIFT)).

4) Patch 6:
  - Moved the "u8 compr_batch_size" to struct zswap_comp_ctx, which is
    per-CPU to address the "unsynchronized write to pool->compr_batch_size on
    CPU hotplug" issue Sashiko highlighted.

5) Patch 7:
  - The special casing for comp_ret=0 with dlen == PAGE_SIZE (among other
    end-cases) when writeback is disabled, is replicated in the batched
    version of zswap_compress() as well.

6) Patch 8:
  - Added obj_cgroup_charge_zswap_many() to correctly account for MEMCG_ZSWAP*
    counters with bulk-charging total compressed bytes to zswap.
  - Resolved zsmalloc() handles leak issue in case of compress batch failures
    in zswap_update_entries().
  - Deleted zswap_pool_get().


Changes since v1:
=================
1) Rebased to mm-unstable as of 10-25-2026, commit a2abad0d7f45.

2) Addressed Herbert's comments on checking for the req->unit_size being equal
   to the req->slen to identify singleton acomp_reqs and to quickly
   short-circuit with setting the dst SG list length instead of going through
   the request chaining flow. Further, the most common code path is the very
   first check, with the short-circuit, in crypto_acomp_compress().
   
3) Addressed Yosry's comments wrt:
   - struct zswap_entry "length" field build-time assertion to have sufficient
     bit-fields for the architecture's PAGE_SIZE.
   - Use kmem_cache_alloc() instead of kmem_cache_alloc_node() in
     zswap_entry_cache_alloc().

4) Established a reliable and accurate performance validation methodology, based
   on Yosry's comments.

5) Refactored the sub-components of zswap_store_pages() where each routine
   processes a batch. The new zswap_account_stores() gets refs, updates
   statistics and charges cgroup for the batch, rather than for a page at a
   time. zswap_store_pages() is more readable and maintainable. This batching
   framework can be immediately useful for implementing more ideas such as SLUB
   bulk allocation of compressed data, reclaiming a batch of folios from
   shrink_folio_list(), etc.


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
  mm: zswap: Refactor and optimize zswap_store_pages() batch operations.
  mm: zswap: Batched zswap_compress() for storing large folios in
    batches.

 crypto/acompress.c                  |  48 +-
 include/crypto/acompress.h          |  66 ++-
 include/crypto/algapi.h             |   5 +
 include/crypto/internal/acompress.h |  10 +-
 include/linux/crypto.h              |   5 +-
 include/linux/memcontrol.h          |   7 +
 mm/memcontrol.c                     |  36 ++
 mm/zswap.c                          | 671 +++++++++++++++++++++-------
 8 files changed, 673 insertions(+), 175 deletions(-)

-- 
2.39.5

