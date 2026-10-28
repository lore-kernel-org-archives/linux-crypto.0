Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793156712;
	b=ogrwvW+RrSctTI1AnMxvCJyy/aKVA4WfAlnX8jrmXtp7R+oxndcjtLypdN4A+nM5IZYN
	 +O1TEAmIJDKJvZzk8auMERas8khLPrrlY5n+a3dD41t64gO/UsKbWN09JJk9a0/H8UJWP
	 cNVCYyCb3aP05v66fDGCmN49CHhCsQ6lZTG+F6y9dl9yFhbihTCHFiZa3IkdMOa8+qol2
	 kbEC8vsCMMShBJmvan9CMsHIdQhPKGIfE7HVA3wNHnY5tytQ670ygLPxJf3Q3VW/Dm/sI
	 bhK+lMKgVDPgZDrw8L0544KgU27dyEdraHn6q0zb1WHRZyyBHy6eccQKm0ZeGW3uBbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793156712;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=pBUxUaSh5knHQq0/77HgNSwW96o+3LO65RsiQyZl3LE=;
	b=v2B7pOKSj51afM7EXnxq7w4alSEGdnNdLI3sCLOEKN8KDDctSF45sy4YjKfSPzUXIyI+
	 WyZpPJqY8x0FhnVnI3vWN1PSlqIT7enIxsR9duZuOHzFVT34mAgjxQNBXdHS8N9uMcyQe
	 HWU3c/cNDDUZ5ZjZSuxlWFJRxB/p7fm/GbcRAccAfU/svjgrutDRxhoaEV8Ui6Lr493J1
	 FTa7kFSnJuvcH5c1qCJ8dv5tMHHWhCcXOwdCaJP7Tk6QF5YLAM3h64XYHDD1d44GJwJVG
	 pGGW6/arO1rbE8ytgFPBCE7Hn42NqgWnPLgZ296wXAg/9YoWW+FbznpHYgAoTYMNMHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="op/96jZE";
	arc=none smtp.remote-ip=74.125.82.43
Received: from mail-dl1-f43.google.com (mail-dl1-f43.google.com [74.125.82.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2AB1606A320
	for <linux-crypto@vger.kernel.org>; Wed, 28 Oct 2026 03:05:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F2AB1606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=op/96jZE
Received: by mail-dl1-f43.google.com with SMTP id a92af1059eb24-15ea896ddc8so724397c88.0
        for <linux-crypto@vger.kernel.org>; Tue, 27 Oct 2026 20:05:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793156711; x=1793761511; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=pBUxUaSh5knHQq0/77HgNSwW96o+3LO65RsiQyZl3LE=;
        b=op/96jZEg41+dCno16E7d2xVR2aWpw4cHtqZd8FGoJCAL6LP7XwzTpZWwZDpOvIMQG
         WT5xvXvUAtJvR/5xgNqlOsHQaeugGHKV/jVjErY6hDKuhTk7Yy/Mvo4eBX23kVRDACmj
         RPc2ktDWk7p7hunz6WQj3l8/xLaEKJXmNduRJqDhTXp5EBLJ5+7Vk8sy2B1JplDh/D0J
         M6eN1jmsl/2mo+yU8JIX7tu149nP/dSlIKRs5eYIhxlxrn60YDGnZ0ks/h2BA328/OPQ
         zDrDknBc5ULo/cKir2XThlxZFRgPwkyF9E8ITAkz4gdFg6K7ChV1HnfQXI/LdH0EMwPp
         itxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793156711; x=1793761511;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pBUxUaSh5knHQq0/77HgNSwW96o+3LO65RsiQyZl3LE=;
        b=0Eao7O/ZmEtqtDujfffRZLo5csEkYCtkq0sc1BtPoP9ob6VOFn0qOebvEl9WGTtbHK
         YzlIXvjJq6ElRII4AS23KTkb728thk33H057fL9xxNopt2XNhBDc0OVrYHGZD11Nrr4a
         l7qPEO4aUaW8P9tf1NCNuaCxc1myB3CuHyYfdmREO0ofDIkYD8A8pu/znuheHdFPopVk
         HzVS/beJG+CTmKzpBUDh+XEVHdzxoVB0//XV3NtAMMMyouQI3BX5YBkLMjVQJiKNfENx
         qy48Jer+taApL5LCnwnNyxU8SG4c7VURtgC1OSxCcGadsdh4HPdOeSXgTjEagZ1+tMtd
         PWRw==
X-Forwarded-Encrypted: i=1; AKwUvBziwW7PcG5jHo1D5eOFUMmd/7VGsONXX/EVRRj24T00UUk7SUEOUIv48PcZcZmvg/21WaM0mL/3e8TJLkI=@vger.kernel.org
X-Gm-Message-State: AFq9FYJJzT8xAmrWofgo1y0u/jLFvHI74IFTn8y/cWbEqRPh61IVFc9T
	2hLgkETIezHP+kCOR6ir7+6ppc8XhPl3ko/KLlG/d5QJwxi8Vgtd84T0
X-Gm-Gg: AYBFou2BkLZbXoksSKsnEnDEaH7biEjzNQPIMMekg5Zg0GUSe7+D3vWd3dxsua1HGXl
	kDsAZXdRIyqsTeSDo9Z20P57RNecUDUn6YtOlPVOQyS7IeT2CFEb7IfF7/jgrxVYhkBWhtIRLx/
	0kEFSxvLXH8sjc5eiKhljWd86pY0q9+N9yXIJFyR00emWrbg91xz1g2lFWgxcv8EyE9zO+9YSH5
	Lmk2dOJIxHFmHuWZRcR75rhKmuNTRCiEUSxplg3YUdUAvzYrcVlMgzAbrSX8PqWjMTpI3PHp3QM
	s1E/g/bufJezF7SQ0dg+Lf9J+lETpDwUKB7Zqg7hCNvudTUmlCIo+x14wlTHV2DMum0ab+W8GVb
	ztBRPtD8Ld2pHsYm+bdimQ3ZSP8gGHRCq5i+xabJvrXWNzGADPCekbgK9KoPewBDygVgR6sKXBB
	CYOYAWj9Clhb20I+KbrRkqBDlgFLvCiT5+JulD6r1uN5aLWTQ3dy5mwX5zZ6Uz1dYTu8ygKfspi
	wOVBZytyhRiagLXiOfqgDr6TmaHK0nj1m80SYnbxfR8qfkcKH7PkbptcgLsEe/8777lUqNiCeRR
	eK3YKn1u2HHn2cFvvxPLt51VeKHLZnU7PpeyU2wfkw==
X-Received: by 2002:a05:7022:b0c8:b0:195:9228:50a0 with SMTP id a92af1059eb24-1a6d0b62961mr1266643c88.42.1793156710801;
        Tue, 27 Oct 2026 20:05:10 -0700 (PDT)
Received: from penguin.lxd ([12.187.136.98])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1a75a37093esm1150734c88.3.2026.10.27.20.05.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 20:05:10 -0700 (PDT)
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
Subject: [PATCH v2 0/8] Batched zswap_store() framework with compression batching
Date: Tue, 27 Oct 2026 20:04:55 -0700
Message-Id: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
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


v2: Batched zswap_store() framework with compression batching
=============================================================

This series is a spin-off of "v14: zswap compression batching with optimized
iaa_crypto driver" [1], and focuses on the generic crypto_acomp and zswap
compression batching enablers. Resuming work on this series following a gap
since v14 (January 2026). Please note that my email address and affiliation have
changed from kanchana.p.sridhar@intel.com to kanchanapsridhar2026@gmail.com. I
have retained the original Intel sign-offs on prior patches for historical
attribution while signing off v2 of this series with my current address.

The main focus of v2 was to establish a reliable and accurate performance
measurement methodology, that addressed the problems with variation in v1. This
is accomplished and used to validate v2, by reducing usemem to 2 processes and
enabling PMD THP. As the data shows, we get exactly the same "2048kB-zswpout"
counts in the baseline and with this series.

To summarize the main contribution of this patch series: Batching is introduced
in zswap_store() of large folios: we carve out a large folio into batches of
ZSWAP_MAX_BATCH_SIZE (8 pages) for software compressors, and store each
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
patch series. To minimize variation in the data, I made these changes to my
performance measurement methodology:

1) Reduced the number of usemem processes to 2. Each process tried to allocate
   2400M, in a 3G cgroup memory.high budget, effectively accomplishing a 56.25%
   over-commit.

2) Increased the runtime of the workload to ~9 minutes by enabling PMD THP,
   i.e., 2048kB mTHP folios.

3) The use of PMD THP forces zswap_store()/zswap_compress() latency to be in the
   critical path, and thus enables very reliable measurements with bpftrace.

4) I used lhist() instead of hist() in bpftrace to gather latencies at a finer
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

 "zswap_store_higher_order":
    zswap_store() of PMD folios.

 "zswap_store_order_0":
    zswap_store() of order-0 folios.

 "zswap_batch_compress_per_page":
    zswap_compress() per-page latency of store batches generated from PMD
    folios.

 "zswap_single_compress_per_page":
    zswap_compress() per-page latency of order-0 folios.

 
 ----------------------------------------------------------------------------
 usemem                       Baseline      zswap        zswap   Change with
 PMD THP                   mm-unstable      store     compress      compress
                            10-25-2026   batching     batching      batching
                                        (patch 6)    (patch 8)          %
 ----------------------------------------------------------------------------
 usemem process 1                6,353      7,240        7,428
  Throughput (KB/s)

 usemem process 2                6,352      7,236        7,422   
  Throughput (KB/s)

 Average Throughput (KB/s)       6,353      7,238        7,425        17%
 ----------------------------------------------------------------------------
 usemem process 1              484,580    308,903      257,230
  Time to free memory (usecs)

 usemem process 2              518,928    438,585      446,958 
  Time to free memory (usecs)

 Average Time to               501,754    373,744      352,094       -30%
  Free Memory (usecs)
 -------------------------------------------------------------------------------

 -------------------------------------------------------------------------------
 usemem                          Baseline        zswap        zswap       Change
 PMD THP                      mm-unstable        store     compress         with
 BPFTRACE                      10-25-2026     batching     batching     compress
                                             (patch 6)    (patch 8)     batching
                                                                            (ns)
 -------------------------------------------------------------------------------
 zswap_batch_compress_per_page (ns):            
                         p50                                 40,086        1,569
                         p95                                 54,689      -64,505
                         p99                                 83,248      -88,488
 -------------------------------------------------------------------------------
 zswap_single_compress_per_page (ns):
                         p50       38,517       38,352       36,650       -1,867
                         p95      119,194      121,174      133,678       14,484
                         p99      171,736      158,601      169,010       -2,726
 -------------------------------------------------------------------------------
 zswap_store_higher_order (ns):
                         p50   21,012,222   21,322,885   20,176,667     -835,556
                         p95   25,643,500   26,204,375   24,485,000   -1,158,500
                         p99   28,567,400   38,577,750   26,158,000   -2,409,400
 -------------------------------------------------------------------------------
 zswap_store_order_0 (ns):
                         p50       37,601       36,994       37,568          -33
                         p95      123,731      137,034      128,366        4,635
                         p99      159,965      169,282      175,618       15,653
 -------------------------------------------------------------------------------
 vmstat summary:
 -------------------------------------------------------------------------------
 zswpin                         1,104,226      993,412    1,091,146       
 zswpout                        1,688,181    1,582,664    1,669,671       
 2048kB-alloc                       2,500        2,505        2,500   
 2048kB-zswpout                     1,535        1,535        1,535   
 2048kB-swpout-fallback               927          929          875     
 -------------------------------------------------------------------------------

 Detailed vmstat & zswap stats after workload finishes:
 ======================================================

 ------------------------------------------------------
 usemem                          Baseline        zswap
 PMD THP                      mm-unstable     compress
                               10-25-2026     batching
                                             (patch 8)
                                                      
 ------------------------------------------------------
 vmstat:
 ------------------------------------------------------
 pswpin                               0              0
 pswpout                              0              0
 thp_swpout                           0              0
 thp_swpout_fallback                927            875
 swpin_zero                           0              0
 swpout_zero                          0              0
 zswpin                       1,104,226      1,091,146
 zswpout                      1,688,181      1,669,671
 zswpwb                               0              0
 nrswpin                              0              0
 nrswpout                             0              0
 pgmajfault                     173,554        173,774
 nr_free_pages                1,753,879      1,755,195
 nr_free_pages_blocks         1,651,712      1,667,072
 2048kB-alloc                     2,500          2,500
 2048kB-zswpout                   1,535          1,535
 2048kB-swpout                        0              0
 2048kB-swpout-fallback             927            875
 2048kB-swpin                         0              0
 memory.current                 352,256        499,712
 memory.swap.current                  0              0
 ------------------------------------------------------
 zswap stats:                                         
 ------------------------------------------------------
 pool_limit_hit                       0              0
 written_back_pages                   0              0
 reject_alloc_fail                    0              0
 reject_kmemcache_fail                0              0
 reject_reclaim_fail                  0              0
 reject_compress_fail                 0              0
 reject_compress_poor                 0              0
 decompress_fail                      0              0
 stored_incompressible_pages          0              0
 stored_pages                         0              0
 pool_total_size                      0              0
 ------------------------------------------------------

Conclusions based on the data:
==============================

 zswap compress batching improves on both, zswap_store() latency and
 zswap_compress() latency wrt the baseline, pretty consistently; except for p50
 batch compress latency which can be optimized further in subsequent
 patches. The batching framework established in this series allows us to make
 locking and bulk-processing improvements in each stage of zswap_store(). One of
 the ideas that has been showing very promising results is to replace zsmalloc
 with SLUB compressed caches and will be submitted separately. This is expected
 to resolve the p50 batch compress latency issue since it will be directly
 optimizing zswap_update_entries().
 
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
  mm: zswap: Batched zswap_compress() for storing large folios in
    batches.
  mm: zswap: Refactor and optimize zswap_store_pages() batch operations.

 crypto/acompress.c                  |  53 ++-
 include/crypto/acompress.h          |  64 ++-
 include/crypto/algapi.h             |   5 +
 include/crypto/internal/acompress.h |  10 +-
 include/linux/crypto.h              |   5 +-
 mm/zswap.c                          | 635 ++++++++++++++++++++--------
 6 files changed, 592 insertions(+), 180 deletions(-)

-- 
2.39.5

