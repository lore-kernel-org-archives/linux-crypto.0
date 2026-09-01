Received: from mta0.migadu.com (out-19.mta0.migadu.com [91.218.175.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CAAD476CEA
	for <linux-crypto@vger.kernel.org>; Tue,  1 Sep 2026 11:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788260939; cv=none; b=L3W+egOeVJMia56RsCmZgbZvcC4fL2Z/4O5MuikbCxyJPYqXedp/4iZwqauaQBy4t1SOKlA63/Vtshf7geOgGEMrApahdE3sTTcYyhX/7ZskbFHre66zweRveb36SCg8qUMswZnIDdnuzgLVsw93Fsm6BGo0BijUsOjOpZILXG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788260939; c=relaxed/simple;
	bh=GAVGkBKgIT+5W4soILfBMtzTyj4hIYcnKlAuurk89uU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k/3bYTMn9cW00zxTpNEKDbcxdZMESRtME0c2Av4cAzGp3u7UgQEm1Nuwoe5npxhJY4htFktgEwhVp4OkfGrvX8vxKa6TZPzG+FiHfwsaOF8la5PkKzocFR1cN7MLSDq+NzuqQ06I/G2UDxuf9L0diq7QUk53xoCApiBU+tbJrJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uH+CfPFu; arc=none smtp.client-ip=91.218.175.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uH+CfPFu"
X-Envelope-To: linux-crypto@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=GAVGkBKgIT+5W4soILfBMtzTyj4hIYcnKlAuurk89uU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788260935; v=1; x=1788865735;
 b=uH+CfPFuIlYnmVhGAaZzjHNoVo0jbUKwM6nNrGFaZtoFmsfaMeiDYcI5n20wtmGx3hdFR9iX
 WO8il3/eBL7hnc8fmGIXrryUbG0uw0OyRN3y6qkvCq0NowJ0hrEIe06saT9uXuwkG86hvKm/lnB
 6o4oVxYK/W25RvbijZcsTCaY=
X-Envelope-To: linux-crypto@vger.kernel.org
Received: by mta12.migadu.com with ESMTPS id 5472b1e3b94e1808;
	Tue, 01 Sep 2026 11:08:55 +0000
X-Mizu-Trace-ID: 5472b1e3b94e1808
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
Subject: [PATCH v3 1/2] lib/zstd: add fallback aliases for disabled BMI2 variants
Date: Tue,  1 Sep 2026 04:07:56 -0700
Message-ID: <20260901110850.1805747-2-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260901110850.1805747-1-usama.arif@linux.dev>
References: <20260901110850.1805747-1-usama.arif@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When dynamic BMI2 dispatch is disabled, the BMI2-specific functions are
not compiled and each selector is conditionally compiled to avoid naming
them.

The selector-level preprocessor guards will be replaced with a predicate
that becomes constant false when dynamic BMI2 dispatch is disabled.
Although the compiler eliminates an `if (0)` branch, it must still parse
and resolve the BMI2 function referenced by it.

Add aliases from the unavailable BMI2 function names to their default
implementations. These aliases make the names valid without emitting
BMI2-specific code. The selectors remain unchanged in this patch, so the
aliases are not used yet and there is no code-generation change.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 lib/zstd/common/entropy_common.c            |  4 ++++
 lib/zstd/common/fse_decompress.c            |  2 ++
 lib/zstd/compress/zstd_compress_sequences.c |  4 ++++
 lib/zstd/decompress/huf_decompress.c        |  4 ++++
 lib/zstd/decompress/zstd_decompress_block.c | 12 ++++++++++++
 5 files changed, 26 insertions(+)

diff --git a/lib/zstd/common/entropy_common.c b/lib/zstd/common/entropy_common.c
index 6cdd82233fb59..15a7c14ae8040 100644
--- a/lib/zstd/common/entropy_common.c
+++ b/lib/zstd/common/entropy_common.c
@@ -202,6 +202,8 @@ BMI2_TARGET_ATTRIBUTE static size_t FSE_readNCount_body_bmi2(
 {
     return FSE_readNCount_body(normalizedCounter, maxSVPtr, tableLogPtr, headerBuffer, hbSize);
 }
+#else
+#define FSE_readNCount_body_bmi2 FSE_readNCount_body_default
 #endif
 
 size_t FSE_readNCount_bmi2(
@@ -323,6 +325,8 @@ static BMI2_TARGET_ATTRIBUTE size_t HUF_readStats_body_bmi2(BYTE* huffWeight, si
 {
     return HUF_readStats_body(huffWeight, hwSize, rankStats, nbSymbolsPtr, tableLogPtr, src, srcSize, workSpace, wkspSize, 1);
 }
+#else
+#define HUF_readStats_body_bmi2 HUF_readStats_body_default
 #endif
 
 size_t HUF_readStats_wksp(BYTE* huffWeight, size_t hwSize, U32* rankStats,
diff --git a/lib/zstd/common/fse_decompress.c b/lib/zstd/common/fse_decompress.c
index 15081d8dc607c..8d9c43b928833 100644
--- a/lib/zstd/common/fse_decompress.c
+++ b/lib/zstd/common/fse_decompress.c
@@ -300,6 +300,8 @@ BMI2_TARGET_ATTRIBUTE static size_t FSE_decompress_wksp_body_bmi2(void* dst, siz
 {
     return FSE_decompress_wksp_body(dst, dstCapacity, cSrc, cSrcSize, maxLog, workSpace, wkspSize, 1);
 }
+#else
+#define FSE_decompress_wksp_body_bmi2 FSE_decompress_wksp_body_default
 #endif
 
 size_t FSE_decompress_wksp_bmi2(void* dst, size_t dstCapacity, const void* cSrc, size_t cSrcSize, unsigned maxLog, void* workSpace, size_t wkspSize, int bmi2)
diff --git a/lib/zstd/compress/zstd_compress_sequences.c b/lib/zstd/compress/zstd_compress_sequences.c
index 256980c9d85ad..64abcdf2c5714 100644
--- a/lib/zstd/compress/zstd_compress_sequences.c
+++ b/lib/zstd/compress/zstd_compress_sequences.c
@@ -415,6 +415,10 @@ ZSTD_encodeSequences_bmi2(
                                     sequences, nbSeq, longOffsets);
 }
 
+#else
+
+#define ZSTD_encodeSequences_bmi2 ZSTD_encodeSequences_default
+
 #endif
 
 size_t ZSTD_encodeSequences(
diff --git a/lib/zstd/decompress/huf_decompress.c b/lib/zstd/decompress/huf_decompress.c
index ac8b87f48f847..5663ae524cd83 100644
--- a/lib/zstd/decompress/huf_decompress.c
+++ b/lib/zstd/decompress/huf_decompress.c
@@ -700,6 +700,8 @@ size_t HUF_decompress4X1_usingDTable_internal_bmi2(void* dst, size_t dstSize, vo
                     size_t cSrcSize, HUF_DTable const* DTable) {
     return HUF_decompress4X1_usingDTable_internal_body(dst, dstSize, cSrc, cSrcSize, DTable);
 }
+#else
+#define HUF_decompress4X1_usingDTable_internal_bmi2 HUF_decompress4X1_usingDTable_internal_default
 #endif
 
 static
@@ -1503,6 +1505,8 @@ size_t HUF_decompress4X2_usingDTable_internal_bmi2(void* dst, size_t dstSize, vo
                     size_t cSrcSize, HUF_DTable const* DTable) {
     return HUF_decompress4X2_usingDTable_internal_body(dst, dstSize, cSrc, cSrcSize, DTable);
 }
+#else
+#define HUF_decompress4X2_usingDTable_internal_bmi2 HUF_decompress4X2_usingDTable_internal_default
 #endif
 
 static
diff --git a/lib/zstd/decompress/zstd_decompress_block.c b/lib/zstd/decompress/zstd_decompress_block.c
index 710eb0ffd5a37..9c4215e435014 100644
--- a/lib/zstd/decompress/zstd_decompress_block.c
+++ b/lib/zstd/decompress/zstd_decompress_block.c
@@ -622,6 +622,8 @@ BMI2_TARGET_ATTRIBUTE static void ZSTD_buildFSETable_body_bmi2(ZSTD_seqSymbol* d
     ZSTD_buildFSETable_body(dt, normalizedCounter, maxSymbolValue,
             baseValue, nbAdditionalBits, tableLog, wksp, wkspSize);
 }
+#else
+#define ZSTD_buildFSETable_body_bmi2 ZSTD_buildFSETable_body_default
 #endif
 
 void ZSTD_buildFSETable(ZSTD_seqSymbol* dt,
@@ -1934,6 +1936,16 @@ ZSTD_decompressSequencesLong_bmi2(ZSTD_DCtx* dctx,
 }
 #endif /* ZSTD_FORCE_DECOMPRESS_SEQUENCES_SHORT */
 
+#else
+
+#ifndef ZSTD_FORCE_DECOMPRESS_SEQUENCES_LONG
+#define ZSTD_decompressSequences_bmi2 ZSTD_decompressSequences_default
+#define ZSTD_decompressSequencesSplitLitBuffer_bmi2 ZSTD_decompressSequencesSplitLitBuffer_default
+#endif
+#ifndef ZSTD_FORCE_DECOMPRESS_SEQUENCES_SHORT
+#define ZSTD_decompressSequencesLong_bmi2 ZSTD_decompressSequencesLong_default
+#endif
+
 #endif /* DYNAMIC_BMI2 */
 
 #ifndef ZSTD_FORCE_DECOMPRESS_SEQUENCES_LONG
-- 
2.53.0-Meta

