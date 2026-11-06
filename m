Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793949872;
	b=M3+ITMa3rZN6yKFXqVqkeI00ysXSMMsmn7nsKB2zS5XICpqnpv1Med3vRhhaxgrUCAW3
	 v+IlZlLcjtbAi92zNjqcfGHowVQJwkelNOWu+faqdCxVo4NUSLgQb85/KyP51mZ+YtkMd
	 pph3ndm7kAimfFL9glkOdq8qDRXUStvmmq0hbI3i+61eaRImzK8R5taaNU8Fz+YQIsWfp
	 +tlxbktrtK2O2cn3L89Go/0qXWX5VHiBPFMkZUx72Nt4SlR6JmiUds+iqNfcSb870Wcrn
	 d1TmEJ1c3QVE/l6VRoELtXnoOD28Kl7rAPwOo1gXFA+NlRiqrhK3gwJ9hqC+D5LymOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793949872;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lLdNpW8D54h7yCGugPfl7AZTWeU3/4/Dieqc+clNNCc=;
	b=xxCTRRcCSm4jJcN2pKLZJUc84qJOsOXx3c/Z8WQaZuZZO0YV9A73ekcKgfz6XK3UM4sM
	 0cwX+R+Yidzt1PSRYasVLgIR4OgVmEHWUAx/pnrcaWKEErUEuZPoYUbq++va1knyZ8lqP
	 8muMTGkXMcbECcZhvLuOedNfPYDrZxKoSR1bnxdzTInzclS8axWuP3SYTi4HhHlQbUlA1
	 /3HasWNKR4zO8sVH+4UwQpSC3aMbBHHcOMu8AM6Q4xQvlDZahylcMtkOc2Tq7SZkhSmHp
	 ZXKzO42p0ricTlMovyQtFH5DCyX622YRc8ey5HkJ3LpQIi6UPOw3w89BxPHM4ShL2HA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Y1WI+Vlj;
	arc=none smtp.remote-ip=74.125.82.173
Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E6EB606D83F
	for <linux-crypto@vger.kernel.org>; Fri,  6 Nov 2026 07:24:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9E6EB606D83F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Y1WI+Vlj
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-36fb88ea38cso355743eec.1
        for <linux-crypto@vger.kernel.org>; Thu, 05 Nov 2026 23:24:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793949871; x=1794554671; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lLdNpW8D54h7yCGugPfl7AZTWeU3/4/Dieqc+clNNCc=;
        b=Y1WI+VljsJsxOnVZgtRcfI7CF6sOcc5eqltuqYXiCJYTjuzBlZKDQizFO+wBFJoWR/
         z4XQbr3r47RRb6A3CZqzrP2whNURRvWZSq6TFFr9rrEB2EI3jZIthZjHwUnBAleGDbJ8
         MLUn+ydNAqQbLP3ZBtQBFNCEhnt9m2QaU7Q1HEw/GDWf8usILgsPXB+1K8d2TIZNdduh
         Kxc0awi99f1noh5eELCZ9InV0Ay0wGQc0zdw+JcX0NcVB1Q15wmvtfVrT24iOVOiFPNe
         nC8Rs7FX3EqM2oPZ3V59tkFqS61jk+wYAs8LF2Py2JhsQv7CL7W9RfZcYX0VlnKk4xjx
         oZEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793949871; x=1794554671;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lLdNpW8D54h7yCGugPfl7AZTWeU3/4/Dieqc+clNNCc=;
        b=GZ2ndFQ7PQRQ4zgMZwySpAXi2x7fASjsWmyQyR62AXqZx++pG5WBYeN8iC3qsudMnh
         RX8HRh7y6JprcjXN4WHcT4t5y909Vr6c9LHOQAFqvAGUgYil0as5WD/+c9DS9/fTxgy/
         md48n151fkxJjNETP+IauNc4ujUqwvphui/frJmLSNZVmh+wbVOIcbEwMAUKd6cRhnu4
         o80zJRZdHG/i6bSuisRKbv0LtqE9pT3AIHFA21YBlZ/WzZz81Pf52D0EDsdHfmgQjRPX
         PDHsyiIQQ7eI34iObrChPrXXgS1fOAbMtm+XkgRhF44q+qZP9kUHh/hT9rXG9MzO2VH6
         Xf4g==
X-Forwarded-Encrypted: i=1; AKwUvBw4dz3djvFsyLrrl2CHWiJMlN366RxmZDNhMLKhJW91xlxHqJhTwcqVbbr4+cCZZpsVqPH7hyhdb5WG118=@vger.kernel.org
X-Gm-Message-State: APuU4Z80sP9qfHRATNLAYycXIBYaFFGurVGYlwwwcbH2bm5U6aP6blth
	aRRARmbY/iYvXYZWvN9HTUiUgsaCiMjVmZod0l4jEwdOIhdRlcD33OO0
X-Gm-Gg: AYBFou1lGcqeYenDZKoV6M4ezp2skdQrRi1/Ekac9zwlrvLgr0zLiOSdaNmsnudQuIE
	RCnNn2TFr5USV5S4Uyz3qHmyba7aXZOrnM3hm/iN92QXBime7gdcIv8vYBHmlvvD0X0k5qJzjnw
	LtzCSjBbFnTJmaB4gDgKMGPjkbO5pigsIN6MCqIoOHKM+MQkicKXPMqIAS/pOr8yHZyObWwPbGL
	SpweiU7s/aZrhr2omo4xEU8FU5MVohhhI6tnG1rilC4Gs0Ij6INF86raJz2Iy5C7Oft90Uey/0N
	GcnJS/CUiX5r7rZy/clJUAcdrpyecBSgPSaUzuQSqUHx+Ic0GA0nwPCCiZiA9dMTx8Uz/racq+B
	zE3Jh6e0eA+d5RoEAK2Ot6guNaET45rZs5NP/tpWSE3eFr74cbssbZNQu+cMcAR2xoX9T7dRyuX
	UXmR6BzLeVB8Q6g3qzUtrYfApTeIeFlL+BwYRYHb6MVE0V5nZzhu5tSDSZc2+EN6oPuvLtXGRsv
	MYRUgy4ixXDiHvQ19jsQ9SBWxpU/1VpKuNsgP9nNR64Ch/pfmL/b31NLrDa0xnv8aSFts8nxlSl
	+d1bnkbhaMY7jUm9h2l4snDRraBuvp7CewDWSRYk6w==
X-Received: by 2002:a05:7022:2209:b0:17a:a3d4:8b17 with SMTP id a92af1059eb24-1b25d300d07mr2462504c88.12.1793949870306;
        Thu, 05 Nov 2026 23:24:30 -0800 (PST)
Received: from penguin.lxd ([12.187.136.98])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b25e4840f3sm6262220c88.5.2026.11.05.23.24.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 23:24:29 -0800 (PST)
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
Subject: [PATCH v3 8/8] mm: zswap: Batched zswap_compress() for storing large folios in batches.
Date: Thu,  5 Nov 2026 23:24:12 -0800
Message-Id: <20261106072412.7909-9-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261106072412.7909-1-kanchanapsridhar2026@gmail.com>
References: <20261106072412.7909-1-kanchanapsridhar2026@gmail.com>
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

A new batching implementation of zswap_compress() is provided for
compressors that do and do not support batching. This eliminates code
duplication and facilitates code maintainability with the introduction
of compress batching.

The vectorized implementation of calling the earlier zswap_compress()
sequentially, one page at a time in zswap_store_pages(), is replaced
with this new version of zswap_compress() that accepts multiple pages to
compress as a batch.

When the crypto_acomp is used to set up the per-CPU acomp_ctx
during CPU onlining, the compressor's batch_size is obtained by calling:

  crypto_acomp_batch_size(acomp_ctx->acomp)

This is bounded by ZSWAP_MAX_BATCH_SIZE to limit the memory
overhead and to reflect the store batch constraint of max # of pages in
a batch. The clamped batch_size is stored in the per-CPU
acomp_ctx->comp.compr_batch_size.

As noted in previous commits in this series, ZSWAP_MAX_BATCH_SIZE
per-CPU compression buffers are available for sequential and batching
compression algorithms.

Regardless of compression batching, we always process large folios in
batches of ZSWAP_MAX_BATCH_SIZE.

If the compressor does not support batching, each page in the batch is
compressed sequentially. For batching compressors, up to
acomp_ctx->comp.compr_batch_size pages in the batch are compressed per
call to crypto_acomp_compress(). The first phase of zswap_compress()
thus only calls crypto_acomp_compress() until all pages in the batch
have been compressed. When this finishes, the compressed buffers and
compressed lengths for the batch are available in the
acomp_ctx->comp.sg_table->sgl scatterlists.

A new zswap_update_entries() then iterates through the (up to)
ZSWAP_MAX_BATCH_SIZE SG lists in acomp_ctx->comp.sg_table->sgl,
allocates zsmalloc memory handles and copies all compressed buffers to
the compressed pool. All existing functionality on zswap
writeback_enabled (or not) fallbacks under various error conditions
denoted by the crypto_acomp_compress() return value, and with this
commit, in the individual acomp_ctx->comp.sg_table->sgl "sg->length"s
set in the crypto_acomp_compress() fast path, is essentially preserved.

The most significant change is that the batched zswap_compress()
incorporates Herbert's suggestion for SG lists to represent the batch's
inputs/outputs to interface with the crypto API [1].

The introduction of zswap_update_entries() presents an opportunity to
optimize the task of storing a batch of compressed buffers. Subsequent
patch series will be submitted to optimize this phase by replacing
zsmalloc with the SLUB allocator to improve zswap_store()/zswap_load()
latencies.

The batching framework introduced in this series improves zswap_store()
latency by a lot.

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

Architectural considerations for the zswap batching framework:
==============================================================
The zswap batching framework is designed to be hardware-agnostic.
It can be leveraged by any hardware accelerator or software-based
compressor.

Potential future clients of the batching framework:
===================================================
This patch-series demonstrates the performance benefits of compression
batching when used in zswap_store() of large folios. Compression
batching can be used for other use cases such as batching compression in
zram, batch compression of different folios during reclaim, kcompressd,
file systems, etc. Decompression batching can be used to improve
efficiency of zswap writeback (Thanks Nhat for this idea), batching
decompressions in zram, etc.

[1]: https://lore.kernel.org/all/aJ7Fk6RpNc815Ivd@gondor.apana.org.au/T/#m99aea2ce3d284e6c5a3253061d97b08c4752a798
[2]: https://wanos.co/assets/silesia.tar

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
---
 mm/zswap.c | 293 +++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 217 insertions(+), 76 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index c2d17ccb53a1..d6746e1d7eec 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -148,9 +148,14 @@ struct zswap_acomp_req {
 
 /*
  * The compression mutex also protects the output buffer(s).
+ *
+ * @compr_batch_size: The max batch size of the compression algorithm,
+ *                    bounded by ZSWAP_MAX_BATCH_SIZE.
  */
 struct zswap_comp_ctx {
 	struct zswap_acomp_req areq;
+	u8 compr_batch_size;
+	struct sg_table *sg_table;
 	u8 **buffers;
 };
 
@@ -234,9 +239,13 @@ struct zswap_entry {
 struct zswap_store_context {
 	struct folio *folio;
 	long folio_start;
+	unsigned int slen;
+	u8 nr_batch_pages;
 	bool wb_enabled;
 	int nid;
 	u8 nr_pages;
+	struct zs_pool *zs_pool;
+	struct zswap_comp_ctx *comp_ctx;
 	struct zswap_entry *entries[ZSWAP_MAX_BATCH_SIZE];
 };
 
@@ -324,6 +333,13 @@ static void acomp_ctx_free(struct crypto_acomp_ctx *acomp_ctx)
 		kfree(acomp_ctx->comp.buffers);
 	}
 	acomp_ctx->comp.buffers = NULL;
+	acomp_ctx->comp.compr_batch_size = 0;
+
+	if (acomp_ctx->comp.sg_table) {
+		sg_free_table(acomp_ctx->comp.sg_table);
+		kfree(acomp_ctx->comp.sg_table);
+	}
+	acomp_ctx->comp.sg_table = NULL;
 }
 
 static struct zswap_pool *zswap_pool_create(char *compressor)
@@ -897,6 +913,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
 	struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
 	int nid = cpu_to_node(cpu);
+	struct scatterlist *sg;
 	int ret = -ENOMEM;
 	u8 i;
 
@@ -921,6 +938,13 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 		goto fail;
 	}
 
+	/*
+	 * Constrain the crypto algorithm's batch size by ZSWAP_MAX_BATCH_SIZE,
+	 * store this in the per-CPU zswap_comp_ctx's @compr_batch_size.
+	 */
+	acomp_ctx->comp.compr_batch_size = min(ZSWAP_MAX_BATCH_SIZE,
+					       crypto_acomp_batch_size(acomp_ctx->acomp));
+
 	ret = zswap_acomp_req_init(&acomp_ctx->comp.areq, acomp_ctx->acomp);
 	if (ret)
 		goto req_fail;
@@ -943,6 +967,26 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 		}
 	}
 
+	acomp_ctx->comp.sg_table = kmalloc(sizeof(*acomp_ctx->comp.sg_table),
+					   GFP_KERNEL);
+	if (!acomp_ctx->comp.sg_table) {
+		ret = -ENOMEM;
+		goto req_fail;
+	}
+
+	if (sg_alloc_table(acomp_ctx->comp.sg_table, ZSWAP_MAX_BATCH_SIZE,
+			   GFP_KERNEL)) {
+		ret = -ENOMEM;
+		goto req_fail;
+	}
+
+	/*
+	 * Statically map the per-CPU destination buffers to the per-CPU
+	 * SG lists; crucial for performance.
+	 */
+	for_each_sg(acomp_ctx->comp.sg_table->sgl, sg, ZSWAP_MAX_BATCH_SIZE, i)
+		sg_set_buf(sg, acomp_ctx->comp.buffers[i], PAGE_SIZE);
+
 	/* Skip the per-CPU request when decompression can use the stack. */
 	if (acomp_is_async(acomp_ctx->acomp)) {
 		ret = zswap_acomp_req_init(&acomp_ctx->decomp, acomp_ctx->acomp);
@@ -959,92 +1003,180 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 	return ret;
 }
 
-static bool zswap_compress(struct folio *folio, long index,
-			   struct zswap_entry *entry, struct zswap_pool *pool,
-			   bool wb_enabled)
+/*
+ * zswap_update_entries() is called only when all pages in a store batch have
+ * been successfully compressed (subsumes the writeback_enabled fallback in case
+ * of compress errors). The only error that can occur in this phase is zs_malloc
+ * allocation failure, upon which an error status is returned to
+ * zswap_store_pages().
+ */
+static inline bool zswap_update_entries(struct zswap_store_context *zc)
 {
-	struct zswap_comp_ctx *comp_ctx;
-	struct scatterlist input, output;
-	int comp_ret = 0, alloc_ret = 0;
-	unsigned int dlen = PAGE_SIZE;
+	gfp_t gfp = GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM | __GFP_MOVABLE;
+	struct zswap_entry *entry;
+	struct scatterlist *sg;
 	unsigned long handle;
-	gfp_t gfp;
-	u8 *dst;
-	bool mapped = false;
+	unsigned int dlen;
+	u8 batch_iter;
+	u8 *buf;
+
+	/*
+	 * For each output SG list in @acomp_ctx->req->sg_table->sgl,
+	 * the @sg->length should be set to either the page's compressed
+	 * length (success), or it's negative value compression error.
+	 */
+	for_each_sg(zc->comp_ctx->sg_table->sgl, sg, zc->nr_pages, batch_iter) {
+		entry = zc->entries[batch_iter];
+		dlen = sg->length;
+
+		prefetchw(entry);
 
-	comp_ctx = &raw_cpu_ptr(pool->acomp_ctx)->comp;
-	mutex_lock(&comp_ctx->areq.mutex);
+		handle = zs_malloc(zc->zs_pool, dlen, gfp, zc->nid);
 
-	dst = comp_ctx->buffers[0];
-	sg_init_table(&input, 1);
-	sg_set_folio(&input, folio, PAGE_SIZE, index * PAGE_SIZE);
+		if (unlikely(IS_ERR_VALUE(handle))) {
+			if (PTR_ERR((void *)handle) == -ENOSPC)
+				zswap_reject_compress_poor++;
+			else
+				zswap_reject_alloc_fail++;
+
+			return false;
+		}
 
-	sg_init_one(&output, dst, PAGE_SIZE);
-	acomp_request_set_params(comp_ctx->areq.req, &input, &output,
-				 PAGE_SIZE, dlen);
+		entry->length = dlen;
+		entry->handle = handle;
+
+		if (unlikely(dlen == PAGE_SIZE)) {
+			buf = kmap_local_folio(zc->folio,
+					(zc->folio_start + batch_iter) * PAGE_SIZE);
+			zs_obj_write(zc->zs_pool, handle, buf, dlen);
+			kunmap_local(buf);
+		} else {
+			buf = zc->comp_ctx->buffers[batch_iter];
+			zs_obj_write(zc->zs_pool, handle, buf, dlen);
+		}
+	}
+
+	return true;
+}
+
+/*
+ * zswap_compress() batching implementation for sequential and batching
+ * compressors.
+ *
+ * Description:
+ * ============
+ * Compress multiple @zc->nr_pages in @zc->folio starting from the
+ * @zc->folio_start index in batches of @zc->nr_batch_pages; the latter
+ * representing the lesser of the @zc->nr_pages to be batch compressed and the
+ * compressor's batch size.
+ *
+ * @zc->nr_pages can be in (1, ZSWAP_MAX_BATCH_SIZE] even if the compressor does
+ * not support batching.
+ *
+ * If @nr_batch_pages is 1, each page is compressed sequentially.
+ *
+ * If @nr_batch_pages is > 1, the compressor may use batching to optimize
+ * compression.
+ *
+ * In all cases, the store processing that needs to happen post-compression
+ * occurs in batches of @zc->nr_pages. Error handling is minimal, mostly to
+ * update zswap statistics, with catch-all cleanup for the batch occuring in the
+ * @store_pages_failed label in zswap_store_pages().
+ */
+static bool zswap_compress(struct zswap_store_context *zc)
+{
+	u8 batch_start, comp_batch_iter;
+	struct scatterlist *sg, *dst_sg;
+	int err;
 
 	/*
-	 * it maybe looks a little bit silly that we send an asynchronous request,
-	 * then wait for its completion synchronously. This makes the process look
-	 * synchronous in fact.
-	 * Theoretically, acomp supports users send multiple acomp requests in one
-	 * acomp instance, then get those requests done simultaneously. but in this
-	 * case, zswap actually does store and load page by page, there is no
-	 * existing method to send the second page before the first page is done
-	 * in one thread doing zswap.
-	 * but in different threads running on different cpu, we have different
-	 * acomp instance, and compression and decompression use separate
-	 * requests, so multiple threads can do (de)compression in parallel.
+	 * @nr_batch_pages is constrained by the per-CPU comp_ctx's compressor
+	 * batch size and the @zc->nr_pages in this store batch. @slen indicates
+	 * the total source length bytes for @nr_batch_pages.
 	 */
-	comp_ret = crypto_wait_req(crypto_acomp_compress(comp_ctx->areq.req),
-				   &comp_ctx->areq.wait);
-	dlen = comp_ctx->areq.req->dlen;
-	if (!comp_ret) {
-		if (dlen == PAGE_SIZE)
-			comp_ret = -ENOSPC;
-		else if (WARN_ON_ONCE(!dlen || dlen > PAGE_SIZE))
-			comp_ret = -EINVAL;
-	}
+	zc->nr_batch_pages = min(zc->comp_ctx->compr_batch_size, zc->nr_pages);
+	zc->slen = zc->nr_batch_pages * PAGE_SIZE;
 
 	/*
-	 * If a page cannot be compressed into a size smaller than PAGE_SIZE,
-	 * save the content as is without a compression, to keep the LRU order
-	 * of writebacks.  If writeback is disabled, reject the page since it
-	 * only adds metadata overhead.  swap_writeout() will put the page back
-	 * to the active LRU list in the case.
+	 * Compress the @nr_pages in @folio starting at index @folio_start
+	 * in batches of @nr_batch_pages.
 	 */
-	if (comp_ret) {
-		if (!wb_enabled)
-			goto unlock;
-		comp_ret = 0;
-		dlen = PAGE_SIZE;
-		dst = kmap_local_folio(folio, index * PAGE_SIZE);
-		mapped = true;
-	}
+	for (batch_start = 0; batch_start < zc->nr_pages;
+	     batch_start += zc->nr_batch_pages) {
+		/*
+		 * Send @nr_batch_pages to crypto_acomp for compression:
+		 *
+		 * These pages are in @folio's range of indices in the interval
+		 *     [@folio_start + @batch_start,
+		 *      @folio_start + @batch_start + @nr_batch_pages).
+		 *
+		 * The source folio pages in the batch are directly submitted to
+		 * crypto_acomp via acomp_request_set_src_folio().
+		 */
+		acomp_request_set_src_folio(zc->comp_ctx->areq.req, zc->folio,
+				(zc->folio_start + batch_start) * PAGE_SIZE,
+				zc->slen);
+
+		dst_sg = zc->comp_ctx->sg_table->sgl + batch_start;
+		dst_sg->length = zc->slen;
+
+		/*
+		 * The per-CPU @zc->comp_ctx->sg_table scatterlists are statically
+		 * mapped to the per-CPU dst @buffers at pool creation time.
+		 * There are ZSWAP_MAX_BATCH_SIZE per-CPU SG lists and dst
+		 * buffers allocated for all compressors.
+		 */
+		acomp_request_set_dst_sg(zc->comp_ctx->areq.req,
+					 dst_sg, zc->slen);
+
+		err = crypto_wait_req(crypto_acomp_compress(zc->comp_ctx->areq.req),
+				      &zc->comp_ctx->areq.wait);
+
+		/*
+		 * If a page cannot be compressed into a size smaller than
+		 * PAGE_SIZE, save the content as is without a compression, to
+		 * keep the LRU order of writebacks.  If writeback is disabled,
+		 * reject the page since it only adds metadata overhead.
+		 * swap_writeout() will put the page back to the active LRU list
+		 * in the case.
+		 */
+		if (err && !zc->wb_enabled)
+			goto compress_error;
 
-	gfp = GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM | __GFP_MOVABLE;
-	handle = zs_malloc(pool->zs_pool, dlen, gfp, folio_nid(folio));
-	if (IS_ERR_VALUE(handle)) {
-		alloc_ret = PTR_ERR((void *)handle);
-		goto unlock;
+		/*
+		 * For each output SG list in @acomp_ctx->req->sg_table->sgl,
+		 * the @sg->length should be set to either the page's compressed
+		 * length (success), or it's negative value compression error.
+		 */
+		for_each_sg(dst_sg, sg, zc->nr_batch_pages, comp_batch_iter) {
+
+			if (sg->length <= 0 || sg->length >= PAGE_SIZE) {
+				if (!zc->wb_enabled) {
+					if (sg->length == PAGE_SIZE)
+						sg->length = -ENOSPC;
+					else if (WARN_ON_ONCE(!sg->length || sg->length > PAGE_SIZE))
+						sg->length = -EINVAL;
+					goto compress_error;
+				}
+
+				sg->length = PAGE_SIZE;
+			}
+		}
 	}
 
-	zs_obj_write(pool->zs_pool, handle, dst, dlen);
-	entry->handle = handle;
-	entry->length = dlen;
+	return zswap_update_entries(zc);
 
-unlock:
-	if (mapped)
-		kunmap_local(dst);
-	if (comp_ret == -ENOSPC || alloc_ret == -ENOSPC)
-		zswap_reject_compress_poor++;
-	else if (comp_ret)
-		zswap_reject_compress_fail++;
-	else if (alloc_ret)
-		zswap_reject_alloc_fail++;
-
-	mutex_unlock(&comp_ctx->areq.mutex);
-	return comp_ret == 0 && alloc_ret == 0;
+compress_error:
+	for_each_sg(dst_sg, sg, zc->nr_batch_pages, comp_batch_iter) {
+		if ((int)sg->length < 0) {
+			if ((int)sg->length == -ENOSPC)
+				zswap_reject_compress_poor++;
+			else
+				zswap_reject_compress_fail++;
+		}
+	}
+
+	return false;
 }
 
 static bool __zswap_decompress(struct zswap_entry *entry,
@@ -1730,11 +1862,19 @@ static bool zswap_store_pages(struct zswap_store_context *zc,
 
 	zswap_init_entries(zc, pool, objcg);
 
-	for (i = 0; i < zc->nr_pages; ++i) {
-		if (!zswap_compress(zc->folio, zc->folio_start + i,
-				    zc->entries[i], pool, zc->wb_enabled))
-			goto store_pages_failed;
-	}
+	/*
+	 * Locking the comp_ctx mutex once per store batch results in better
+	 * performance as compared to locking per compress batch.
+	 */
+	zc->comp_ctx = &raw_cpu_ptr(pool->acomp_ctx)->comp;
+	mutex_lock(&zc->comp_ctx->areq.mutex);
+
+	ret = zswap_compress(zc);
+
+	mutex_unlock(&zc->comp_ctx->areq.mutex);
+
+	if (unlikely(!ret))
+		goto store_pages_failed;
 
 	ret = zswap_tree_stores(zc, pool, objcg);
 
@@ -1800,6 +1940,7 @@ bool zswap_store(struct folio *folio)
 		mem_cgroup_put(memcg);
 	}
 
+	zc.zs_pool = pool->zs_pool;
 	rcu_read_lock();
 	zc.wb_enabled = mem_cgroup_zswap_writeback_enabled(folio_memcg(folio));
 	rcu_read_unlock();
-- 
2.39.5

