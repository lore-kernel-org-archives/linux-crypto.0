Received: from mta0.migadu.com (out-166.mta0.migadu.com [91.218.175.166])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB0F3317162
	for <linux-crypto@vger.kernel.org>; Sun, 30 Aug 2026 22:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.166
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788128509; cv=none; b=bToKbqowN+bqCgR/k6Hc0n1tb0yUN9M1oak2aaiR+Vqx4FvCtsyWCWgy3t462CuPZSyHzn9nmdK40En2N+29Y9ffzP1x8Nea3EBefMAxYvKoetSmpCipW2RV9m5II4D1jUCAECh2vyTGEdDyfecr8yijBgCxgTUMK3QTpr+6urY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788128509; c=relaxed/simple;
	bh=BUMbGG4un7jzerExUrw+Cb+Uz5WFVGt28w9IxAUZsp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M06g1Pq2KDMN3cWqSqFfmu8ddnuuk3I9N/hPk957vg7XUnIX0B3VLGvlLQesyvhWmH/g+AgdD9ogFgKPn1gDyVlqNBbJ3JDl4PWHpL2+ZtTbq0DDdZFkMMEJCSeE3Q9jPmnoHqFoL74kyEoJUYWHGe6TTEr+hfpB2CZzasJCjak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Rhyhc6hQ; arc=none smtp.client-ip=91.218.175.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Rhyhc6hQ"
X-Envelope-To: linux-crypto@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=BUMbGG4un7jzerExUrw+Cb+Uz5WFVGt28w9IxAUZsp4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788128504; v=1; x=1788733304;
 b=Rhyhc6hQmQN/UTtqiv0VbzVa3ZMXYVi1kVt0dRivIpJJ7It+oN+fnjTijPYDL5zoAx3WHoTf
 RVwYC7P3A61UC7/AqAE2XIiKop8cktW8dDohL7E3NamiUXDNXI+oTHJJvSnz+H1r6mS02dd3ymY
 m6h9/Or6mZOGQ9E4Vm8VWfsc=
X-Envelope-To: linux-crypto@vger.kernel.org
Received: by mta11.migadu.com with ESMTPS id c25f43043f93d7ba;
	Sun, 30 Aug 2026 22:21:44 +0000
X-Mizu-Trace-ID: c25f43043f93d7ba
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: dsterba@suse.com,
	linux-kernel@vger.kernel.org,
	terrelln@fb.com,
	terrelln@meta.com,
	linux-crypto@vger.kernel.org,
	yosry@kernel.org,
	ebiggers@kernel.org,
	torvalds@linux-foundation.org
Cc: hannes@cmpxchg.org,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	shakeel.butt@linux.dev,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v2 2/2] zstd: use cpu_feature_enabled() for in-kernel BMI2 dispatch
Date: Sun, 30 Aug 2026 15:20:25 -0700
Message-ID: <20260830222100.2706175-3-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260830222100.2706175-1-usama.arif@linux.dev>
References: <20260830222100.2706175-1-usama.arif@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Zstd's dynamic BMI2 implementation probes CPUID when a compression or
decompression context is initialized, stores the result in the context,
and tests that value at every dispatch site. In normal kernel builds this
bypasses the x86 feature policy and uses ordinary runtime branches instead
of allowing x86 alternatives to resolve the feature check at boot.

Add ZSTD_USE_BMI2() and use it at every runtime BMI2/default selector. For
normal x86 kernel objects, the predicate expands directly to
cpu_feature_enabled(X86_FEATURE_BMI2). When dynamic BMI2 dispatch is not
available it is false; other builds retain the caller-provided flag. Keep
the existing HUF conditional layout because DYNAMIC_BMI2 also controls
whether target-attributed variants are emitted.

Keep the BMI2 members in the context structures so their layouts do not
change. Skip Zstd's private CPUID probes in normal x86 kernel objects and
make the context accessors return zero there; the selectors ignore that
value and consult the x86 feature policy directly. The x86 preboot
decompressor is built outside lib/zstd/Makefile, so it retains the existing
CPUID-backed dispatch.

A 4 KiB zstd-generic crypto_acomp benchmark in a one-vCPU KVM guest gave
these median results:

                        Before      After     Change
  Compression      16,634 ns/op  13,394 ns/op  -19.5%
  Decompression     3,480 ns/op     963 ns/op  -72.3%

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 lib/zstd/Makefile                             |  1 +
 lib/zstd/common/compiler.h                    |  8 ++++++++
 lib/zstd/common/entropy_common.c              | 12 +++++------
 lib/zstd/common/fse_decompress.c              |  7 ++++---
 lib/zstd/compress/huf_compress.c              |  7 ++++++-
 lib/zstd/compress/zstd_compress.c             | 12 +++++++----
 lib/zstd/compress/zstd_compress_internal.h    |  9 +++++++++
 lib/zstd/compress/zstd_compress_sequences.c   |  8 +++++---
 lib/zstd/compress/zstd_compress_superblock.c  |  2 +-
 lib/zstd/decompress/huf_decompress.c          | 19 +++++++++---------
 lib/zstd/decompress/zstd_decompress.c         |  4 ++++
 lib/zstd/decompress/zstd_decompress_block.c   | 20 ++++++++-----------
 .../decompress/zstd_decompress_internal.h     |  2 +-
 13 files changed, 71 insertions(+), 40 deletions(-)

diff --git a/lib/zstd/Makefile b/lib/zstd/Makefile
index be218b5e0ed59..4da67e1f7c247 100644
--- a/lib/zstd/Makefile
+++ b/lib/zstd/Makefile
@@ -11,6 +11,7 @@
 obj-$(CONFIG_ZSTD_COMPRESS) += zstd_compress.o
 obj-$(CONFIG_ZSTD_DECOMPRESS) += zstd_decompress.o
 obj-$(CONFIG_ZSTD_COMMON) += zstd_common.o
+ccflags-$(CONFIG_X86) += -DZSTD_USE_KERNEL_CPU_FEATURES
 
 zstd_compress-y := \
 		zstd_compress_module.o \
diff --git a/lib/zstd/common/compiler.h b/lib/zstd/common/compiler.h
index dc9bd15e174e9..e14102557ded3 100644
--- a/lib/zstd/common/compiler.h
+++ b/lib/zstd/common/compiler.h
@@ -96,6 +96,14 @@
  */
 #define BMI2_TARGET_ATTRIBUTE TARGET_ATTRIBUTE("lzcnt,bmi,bmi2")
 
+#if !DYNAMIC_BMI2
+#  define ZSTD_USE_BMI2(bmi2) 0
+#elif defined(ZSTD_USE_KERNEL_CPU_FEATURES)
+#  define ZSTD_USE_BMI2(bmi2) cpu_feature_enabled(X86_FEATURE_BMI2)
+#else
+#  define ZSTD_USE_BMI2(bmi2) (bmi2)
+#endif
+
 /* prefetch
  * can be disabled, by declaring NO_PREFETCH build macro */
 #if ( (__GNUC__ >= 4) || ( (__GNUC__ == 3) && (__GNUC_MINOR__ >= 1) ) )
diff --git a/lib/zstd/common/entropy_common.c b/lib/zstd/common/entropy_common.c
index 15a7c14ae8040..9cdbe0d3a2b2f 100644
--- a/lib/zstd/common/entropy_common.c
+++ b/lib/zstd/common/entropy_common.c
@@ -13,6 +13,10 @@
  * You may select, at your option, one of the above-listed licenses.
 ****************************************************************** */
 
+#if defined(ZSTD_USE_KERNEL_CPU_FEATURES)
+#include <asm/cpufeature.h>
+#endif
+
 /* *************************************
 *  Dependencies
 ***************************************/
@@ -210,11 +214,9 @@ size_t FSE_readNCount_bmi2(
         short* normalizedCounter, unsigned* maxSVPtr, unsigned* tableLogPtr,
         const void* headerBuffer, size_t hbSize, int bmi2)
 {
-#if DYNAMIC_BMI2
-    if (bmi2) {
+    if (ZSTD_USE_BMI2(bmi2)) {
         return FSE_readNCount_body_bmi2(normalizedCounter, maxSVPtr, tableLogPtr, headerBuffer, hbSize);
     }
-#endif
     (void)bmi2;
     return FSE_readNCount_body_default(normalizedCounter, maxSVPtr, tableLogPtr, headerBuffer, hbSize);
 }
@@ -335,11 +337,9 @@ size_t HUF_readStats_wksp(BYTE* huffWeight, size_t hwSize, U32* rankStats,
                      void* workSpace, size_t wkspSize,
                      int flags)
 {
-#if DYNAMIC_BMI2
-    if (flags & HUF_flags_bmi2) {
+    if (ZSTD_USE_BMI2(flags & HUF_flags_bmi2)) {
         return HUF_readStats_body_bmi2(huffWeight, hwSize, rankStats, nbSymbolsPtr, tableLogPtr, src, srcSize, workSpace, wkspSize);
     }
-#endif
     (void)flags;
     return HUF_readStats_body_default(huffWeight, hwSize, rankStats, nbSymbolsPtr, tableLogPtr, src, srcSize, workSpace, wkspSize);
 }
diff --git a/lib/zstd/common/fse_decompress.c b/lib/zstd/common/fse_decompress.c
index 8d9c43b928833..763c11d0541f5 100644
--- a/lib/zstd/common/fse_decompress.c
+++ b/lib/zstd/common/fse_decompress.c
@@ -13,6 +13,9 @@
  * You may select, at your option, one of the above-listed licenses.
 ****************************************************************** */
 
+#if defined(ZSTD_USE_KERNEL_CPU_FEATURES)
+#include <asm/cpufeature.h>
+#endif
 
 /* **************************************************************
 *  Includes
@@ -306,11 +309,9 @@ BMI2_TARGET_ATTRIBUTE static size_t FSE_decompress_wksp_body_bmi2(void* dst, siz
 
 size_t FSE_decompress_wksp_bmi2(void* dst, size_t dstCapacity, const void* cSrc, size_t cSrcSize, unsigned maxLog, void* workSpace, size_t wkspSize, int bmi2)
 {
-#if DYNAMIC_BMI2
-    if (bmi2) {
+    if (ZSTD_USE_BMI2(bmi2)) {
         return FSE_decompress_wksp_body_bmi2(dst, dstCapacity, cSrc, cSrcSize, maxLog, workSpace, wkspSize);
     }
-#endif
     (void)bmi2;
     return FSE_decompress_wksp_body_default(dst, dstCapacity, cSrc, cSrcSize, maxLog, workSpace, wkspSize);
 }
diff --git a/lib/zstd/compress/huf_compress.c b/lib/zstd/compress/huf_compress.c
index 0b229f5d2ae22..5d8c90f9263c2 100644
--- a/lib/zstd/compress/huf_compress.c
+++ b/lib/zstd/compress/huf_compress.c
@@ -13,6 +13,10 @@
  * You may select, at your option, one of the above-listed licenses.
 ****************************************************************** */
 
+#if defined(ZSTD_USE_KERNEL_CPU_FEATURES)
+#include <asm/cpufeature.h>
+#endif
+
 /* **************************************************************
 *  Compiler specifics
 ****************************************************************/
@@ -1138,9 +1142,10 @@ HUF_compress1X_usingCTable_internal(void* dst, size_t dstSize,
                               const void* src, size_t srcSize,
                               const HUF_CElt* CTable, const int flags)
 {
-    if (flags & HUF_flags_bmi2) {
+    if (ZSTD_USE_BMI2(flags & HUF_flags_bmi2)) {
         return HUF_compress1X_usingCTable_internal_bmi2(dst, dstSize, src, srcSize, CTable);
     }
+    (void)flags;
     return HUF_compress1X_usingCTable_internal_default(dst, dstSize, src, srcSize, CTable);
 }
 
diff --git a/lib/zstd/compress/zstd_compress.c b/lib/zstd/compress/zstd_compress.c
index c41a747413e01..8295ce44b1d7a 100644
--- a/lib/zstd/compress/zstd_compress.c
+++ b/lib/zstd/compress/zstd_compress.c
@@ -102,7 +102,9 @@ static void ZSTD_initCCtx(ZSTD_CCtx* cctx, ZSTD_customMem memManager)
     assert(cctx != NULL);
     ZSTD_memset(cctx, 0, sizeof(*cctx));
     cctx->customMem = memManager;
+#if !defined(ZSTD_USE_KERNEL_CPU_FEATURES)
     cctx->bmi2 = ZSTD_cpuSupportsBmi2();
+#endif
     {   size_t const err = ZSTD_CCtx_reset(cctx, ZSTD_reset_parameters);
         assert(!ZSTD_isError(err));
         (void)err;
@@ -142,7 +144,9 @@ ZSTD_CCtx* ZSTD_initStaticCCtx(void* workspace, size_t workspaceSize)
     cctx->blockState.nextCBlock = (ZSTD_compressedBlockState_t*)ZSTD_cwksp_reserve_object(&cctx->workspace, sizeof(ZSTD_compressedBlockState_t));
     cctx->tmpWorkspace = ZSTD_cwksp_reserve_object(&cctx->workspace, TMP_WORKSPACE_SIZE);
     cctx->tmpWkspSize = TMP_WORKSPACE_SIZE;
+#if !defined(ZSTD_USE_KERNEL_CPU_FEATURES)
     cctx->bmi2 = ZSTD_cpuid_bmi2(ZSTD_cpuid());
+#endif
     return cctx;
 }
 
@@ -4042,7 +4046,7 @@ ZSTD_compressSeqStore_singleBlock(ZSTD_CCtx* zc,
                 op + ZSTD_blockHeaderSize, dstCapacity - ZSTD_blockHeaderSize,
                 srcSize,
                 zc->tmpWorkspace, zc->tmpWkspSize /* statically allocated in resetCCtx */,
-                zc->bmi2);
+                ZSTD_CCtx_get_bmi2(zc));
     FORWARD_IF_ERROR(cSeqsSize, "ZSTD_entropyCompressSeqStore failed!");
 
     if (!zc->isFirstBlock &&
@@ -4332,7 +4336,7 @@ ZSTD_compressBlock_internal(ZSTD_CCtx* zc,
             dst, dstCapacity,
             srcSize,
             zc->tmpWorkspace, zc->tmpWkspSize /* statically allocated in resetCCtx */,
-            zc->bmi2);
+            ZSTD_CCtx_get_bmi2(zc));
 
     if (frame &&
         /* We don't want to emit our first block as a RLE even if it qualifies because
@@ -6796,7 +6800,7 @@ ZSTD_compressSequences_internal(ZSTD_CCtx* cctx,
                                 op + ZSTD_blockHeaderSize /* Leave space for block header */, dstCapacity - ZSTD_blockHeaderSize,
                                 blockSize,
                                 cctx->tmpWorkspace, cctx->tmpWkspSize /* statically allocated in resetCCtx */,
-                                cctx->bmi2);
+                                ZSTD_CCtx_get_bmi2(cctx));
         FORWARD_IF_ERROR(compressedSeqsSize, "Compressing sequences of block failed");
         DEBUGLOG(5, "Compressed sequences size: %zu", compressedSeqsSize);
 
@@ -7321,7 +7325,7 @@ ZSTD_compressSequencesAndLiterals_internal(ZSTD_CCtx* cctx,
                                 &cctx->blockState.prevCBlock->entropy, &cctx->blockState.nextCBlock->entropy,
                                 &cctx->appliedParams,
                                 cctx->tmpWorkspace, cctx->tmpWkspSize /* statically allocated in resetCCtx */,
-                                cctx->bmi2);
+                                ZSTD_CCtx_get_bmi2(cctx));
         FORWARD_IF_ERROR(compressedSeqsSize, "Compressing sequences of block failed");
         /* note: the spec forbids for any compressed block to be larger than maximum block size */
         if (compressedSeqsSize > cctx->blockSizeMax) compressedSeqsSize = 0;
diff --git a/lib/zstd/compress/zstd_compress_internal.h b/lib/zstd/compress/zstd_compress_internal.h
index b109783858763..0b8ec69c081ef 100644
--- a/lib/zstd/compress/zstd_compress_internal.h
+++ b/lib/zstd/compress/zstd_compress_internal.h
@@ -537,6 +537,15 @@ struct ZSTD_CCtx_s {
     size_t extSeqBufCapacity;
 };
 
+MEM_STATIC int ZSTD_CCtx_get_bmi2(const struct ZSTD_CCtx_s *cctx) {
+#if !defined(ZSTD_USE_KERNEL_CPU_FEATURES)
+    return cctx->bmi2;
+#else
+    (void)cctx;
+    return 0;
+#endif
+}
+
 typedef enum { ZSTD_dtlm_fast, ZSTD_dtlm_full } ZSTD_dictTableLoadMethod_e;
 typedef enum { ZSTD_tfp_forCCtx, ZSTD_tfp_forCDict } ZSTD_tableFillPurpose_e;
 
diff --git a/lib/zstd/compress/zstd_compress_sequences.c b/lib/zstd/compress/zstd_compress_sequences.c
index 64abcdf2c5714..450219bbe28bc 100644
--- a/lib/zstd/compress/zstd_compress_sequences.c
+++ b/lib/zstd/compress/zstd_compress_sequences.c
@@ -9,6 +9,10 @@
  * You may select, at your option, one of the above-listed licenses.
  */
 
+#if defined(ZSTD_USE_KERNEL_CPU_FEATURES)
+#include <asm/cpufeature.h>
+#endif
+
  /*-*************************************
  *  Dependencies
  ***************************************/
@@ -429,15 +433,13 @@ size_t ZSTD_encodeSequences(
             SeqDef const* sequences, size_t nbSeq, int longOffsets, int bmi2)
 {
     DEBUGLOG(5, "ZSTD_encodeSequences: dstCapacity = %u", (unsigned)dstCapacity);
-#if DYNAMIC_BMI2
-    if (bmi2) {
+    if (ZSTD_USE_BMI2(bmi2)) {
         return ZSTD_encodeSequences_bmi2(dst, dstCapacity,
                                          CTable_MatchLength, mlCodeTable,
                                          CTable_OffsetBits, ofCodeTable,
                                          CTable_LitLength, llCodeTable,
                                          sequences, nbSeq, longOffsets);
     }
-#endif
     (void)bmi2;
     return ZSTD_encodeSequences_default(dst, dstCapacity,
                                         CTable_MatchLength, mlCodeTable,
diff --git a/lib/zstd/compress/zstd_compress_superblock.c b/lib/zstd/compress/zstd_compress_superblock.c
index dc12d64e935c4..fada5979c3b84 100644
--- a/lib/zstd/compress/zstd_compress_superblock.c
+++ b/lib/zstd/compress/zstd_compress_superblock.c
@@ -684,6 +684,6 @@ size_t ZSTD_compressSuperBlock(ZSTD_CCtx* zc,
             &zc->appliedParams,
             dst, dstCapacity,
             src, srcSize,
-            zc->bmi2, lastBlock,
+            ZSTD_CCtx_get_bmi2(zc), lastBlock,
             zc->tmpWorkspace, zc->tmpWkspSize /* statically allocated in resetCCtx */);
 }
diff --git a/lib/zstd/decompress/huf_decompress.c b/lib/zstd/decompress/huf_decompress.c
index 5663ae524cd83..c4fc0a8c7a46f 100644
--- a/lib/zstd/decompress/huf_decompress.c
+++ b/lib/zstd/decompress/huf_decompress.c
@@ -13,6 +13,10 @@
  * You may select, at your option, one of the above-listed licenses.
 ****************************************************************** */
 
+#if defined(ZSTD_USE_KERNEL_CPU_FEATURES)
+#include <asm/cpufeature.h>
+#endif
+
 /* **************************************************************
 *  Dependencies
 ****************************************************************/
@@ -113,9 +117,10 @@ typedef size_t (*HUF_DecompressUsingDTableFn)(void *dst, size_t dstSize,
     static size_t fn(void* dst, size_t dstSize, void const* cSrc,           \
                      size_t cSrcSize, HUF_DTable const* DTable, int flags)  \
     {                                                                       \
-        if (flags & HUF_flags_bmi2) {                                       \
+        if (ZSTD_USE_BMI2(flags & HUF_flags_bmi2)) {                        \
             return fn##_bmi2(dst, dstSize, cSrc, cSrcSize, DTable);         \
         }                                                                   \
+        (void)flags;                                                        \
         return fn##_default(dst, dstSize, cSrc, cSrcSize, DTable);          \
     }
 
@@ -899,18 +904,16 @@ static size_t HUF_decompress4X1_usingDTable_internal(void* dst, size_t dstSize,
     HUF_DecompressUsingDTableFn fallbackFn = HUF_decompress4X1_usingDTable_internal_default;
     HUF_DecompressFastLoopFn loopFn = HUF_decompress4X1_usingDTable_internal_fast_c_loop;
 
-#if DYNAMIC_BMI2
-    if (flags & HUF_flags_bmi2) {
+    if (ZSTD_USE_BMI2(flags & HUF_flags_bmi2)) {
         fallbackFn = HUF_decompress4X1_usingDTable_internal_bmi2;
 # if ZSTD_ENABLE_ASM_X86_64_BMI2
         if (!(flags & HUF_flags_disableAsm)) {
             loopFn = HUF_decompress4X1_usingDTable_internal_fast_asm_loop;
         }
 # endif
-    } else {
+    } else if (DYNAMIC_BMI2) {
         return fallbackFn(dst, dstSize, cSrc, cSrcSize, DTable);
     }
-#endif
 
 #if ZSTD_ENABLE_ASM_X86_64_BMI2 && defined(__BMI2__)
     if (!(flags & HUF_flags_disableAsm)) {
@@ -1723,18 +1726,16 @@ static size_t HUF_decompress4X2_usingDTable_internal(void* dst, size_t dstSize,
     HUF_DecompressUsingDTableFn fallbackFn = HUF_decompress4X2_usingDTable_internal_default;
     HUF_DecompressFastLoopFn loopFn = HUF_decompress4X2_usingDTable_internal_fast_c_loop;
 
-#if DYNAMIC_BMI2
-    if (flags & HUF_flags_bmi2) {
+    if (ZSTD_USE_BMI2(flags & HUF_flags_bmi2)) {
         fallbackFn = HUF_decompress4X2_usingDTable_internal_bmi2;
 # if ZSTD_ENABLE_ASM_X86_64_BMI2
         if (!(flags & HUF_flags_disableAsm)) {
             loopFn = HUF_decompress4X2_usingDTable_internal_fast_asm_loop;
         }
 # endif
-    } else {
+    } else if (DYNAMIC_BMI2) {
         return fallbackFn(dst, dstSize, cSrc, cSrcSize, DTable);
     }
-#endif
 
 #if ZSTD_ENABLE_ASM_X86_64_BMI2 && defined(__BMI2__)
     if (!(flags & HUF_flags_disableAsm)) {
diff --git a/lib/zstd/decompress/zstd_decompress.c b/lib/zstd/decompress/zstd_decompress.c
index bb009554e3a61..107b4e42e4ee8 100644
--- a/lib/zstd/decompress/zstd_decompress.c
+++ b/lib/zstd/decompress/zstd_decompress.c
@@ -260,7 +260,11 @@ static void ZSTD_initDCtx_internal(ZSTD_DCtx* dctx)
     dctx->oversizedDuration = 0;
     dctx->isFrameDecompression = 1;
 #if DYNAMIC_BMI2
+# if defined(ZSTD_USE_KERNEL_CPU_FEATURES)
+    dctx->bmi2 = 0;
+# else
     dctx->bmi2 = ZSTD_cpuSupportsBmi2();
+# endif
 #endif
     dctx->ddictSet = NULL;
     ZSTD_DCtx_resetParameters(dctx);
diff --git a/lib/zstd/decompress/zstd_decompress_block.c b/lib/zstd/decompress/zstd_decompress_block.c
index 9c4215e435014..424de08fce82e 100644
--- a/lib/zstd/decompress/zstd_decompress_block.c
+++ b/lib/zstd/decompress/zstd_decompress_block.c
@@ -12,6 +12,10 @@
 /* zstd_decompress_block :
  * this module takes care of decompressing _compressed_ block */
 
+#if defined(ZSTD_USE_KERNEL_CPU_FEATURES)
+#include <asm/cpufeature.h>
+#endif
+
 /*-*******************************************************
 *  Dependencies
 *********************************************************/
@@ -631,13 +635,11 @@ void ZSTD_buildFSETable(ZSTD_seqSymbol* dt,
             const U32* baseValue, const U8* nbAdditionalBits,
             unsigned tableLog, void* wksp, size_t wkspSize, int bmi2)
 {
-#if DYNAMIC_BMI2
-    if (bmi2) {
+    if (ZSTD_USE_BMI2(bmi2)) {
         ZSTD_buildFSETable_body_bmi2(dt, normalizedCounter, maxSymbolValue,
                 baseValue, nbAdditionalBits, tableLog, wksp, wkspSize);
         return;
     }
-#endif
     (void)bmi2;
     ZSTD_buildFSETable_body_default(dt, normalizedCounter, maxSymbolValue,
             baseValue, nbAdditionalBits, tableLog, wksp, wkspSize);
@@ -1955,11 +1957,9 @@ ZSTD_decompressSequences(ZSTD_DCtx* dctx, void* dst, size_t maxDstSize,
                    const ZSTD_longOffset_e isLongOffset)
 {
     DEBUGLOG(5, "ZSTD_decompressSequences");
-#if DYNAMIC_BMI2
-    if (ZSTD_DCtx_get_bmi2(dctx)) {
+    if (ZSTD_USE_BMI2(ZSTD_DCtx_get_bmi2(dctx))) {
         return ZSTD_decompressSequences_bmi2(dctx, dst, maxDstSize, seqStart, seqSize, nbSeq, isLongOffset);
     }
-#endif
     return ZSTD_decompressSequences_default(dctx, dst, maxDstSize, seqStart, seqSize, nbSeq, isLongOffset);
 }
 static size_t
@@ -1968,11 +1968,9 @@ ZSTD_decompressSequencesSplitLitBuffer(ZSTD_DCtx* dctx, void* dst, size_t maxDst
                                  const ZSTD_longOffset_e isLongOffset)
 {
     DEBUGLOG(5, "ZSTD_decompressSequencesSplitLitBuffer");
-#if DYNAMIC_BMI2
-    if (ZSTD_DCtx_get_bmi2(dctx)) {
+    if (ZSTD_USE_BMI2(ZSTD_DCtx_get_bmi2(dctx))) {
         return ZSTD_decompressSequencesSplitLitBuffer_bmi2(dctx, dst, maxDstSize, seqStart, seqSize, nbSeq, isLongOffset);
     }
-#endif
     return ZSTD_decompressSequencesSplitLitBuffer_default(dctx, dst, maxDstSize, seqStart, seqSize, nbSeq, isLongOffset);
 }
 #endif /* ZSTD_FORCE_DECOMPRESS_SEQUENCES_LONG */
@@ -1991,11 +1989,9 @@ ZSTD_decompressSequencesLong(ZSTD_DCtx* dctx,
                              const ZSTD_longOffset_e isLongOffset)
 {
     DEBUGLOG(5, "ZSTD_decompressSequencesLong");
-#if DYNAMIC_BMI2
-    if (ZSTD_DCtx_get_bmi2(dctx)) {
+    if (ZSTD_USE_BMI2(ZSTD_DCtx_get_bmi2(dctx))) {
         return ZSTD_decompressSequencesLong_bmi2(dctx, dst, maxDstSize, seqStart, seqSize, nbSeq, isLongOffset);
     }
-#endif
   return ZSTD_decompressSequencesLong_default(dctx, dst, maxDstSize, seqStart, seqSize, nbSeq, isLongOffset);
 }
 #endif /* ZSTD_FORCE_DECOMPRESS_SEQUENCES_SHORT */
diff --git a/lib/zstd/decompress/zstd_decompress_internal.h b/lib/zstd/decompress/zstd_decompress_internal.h
index 2a225d1811c4f..401f2b526bbce 100644
--- a/lib/zstd/decompress/zstd_decompress_internal.h
+++ b/lib/zstd/decompress/zstd_decompress_internal.h
@@ -204,7 +204,7 @@ struct ZSTD_DCtx_s
 };  /* typedef'd to ZSTD_DCtx within "zstd.h" */
 
 MEM_STATIC int ZSTD_DCtx_get_bmi2(const struct ZSTD_DCtx_s *dctx) {
-#if DYNAMIC_BMI2
+#if DYNAMIC_BMI2 && !defined(ZSTD_USE_KERNEL_CPU_FEATURES)
     return dctx->bmi2;
 #else
     (void)dctx;
-- 
2.53.0-Meta

