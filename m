Received: from mta1.migadu.com (out-74.mta1.migadu.com [95.215.58.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CDCB25B093
	for <linux-crypto@vger.kernel.org>; Sun, 30 Aug 2026 22:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788128505; cv=none; b=YtWzHj8ZXt3D63O5PBVXAtOqVqq/x6fpO/d2dniCE2xs0InkUaRzjnwZUHz03yuKXCIO2yLpWURZ3mgujW4VZVll94cbx/sN7GS0cd9VHblJoGB44aSRZC3WH3bPU+DaHJO0+Re1kaC8JYk+XYd5wjZMasIhyt6TbGrhcD5oQSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788128505; c=relaxed/simple;
	bh=GAVGkBKgIT+5W4soILfBMtzTyj4hIYcnKlAuurk89uU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zv7iVd8BhtbH7gJXrkKvLBJ/fXWgqxM9zv5j3LVx4T1aKP12Ia5uEvHvEL7hS96rhwdLe/Vi9gyvBH7zkRg5VjN+gZ7Lv+eSGNrzgRhEpJ5XoOWCgZl3hNW1couYdiRKftklD4DOsRlw3t+icv9+IhtIuF67pMVGUHLhV/MyEdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VqZ+4DlW; arc=none smtp.client-ip=95.215.58.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VqZ+4DlW"
X-Envelope-To: linux-crypto@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=GAVGkBKgIT+5W4soILfBMtzTyj4hIYcnKlAuurk89uU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788128501; v=1; x=1788733301;
 b=VqZ+4DlWDq9weL9G6R+QDnqeN6NQ7jBOFPCunexo/cbnhLMadx+fKJkwdJXN0MkM6I3H0x3R
 Aj6xG4mZtSXetOfnluB/VI/P+xzI4em+P6iYuDi/8kto9Jdpt3iF4flYncFhRt3mwa75RjBDIIa
 UA9vfJGga/Rg7CaWkyMrz4Lo=
X-Envelope-To: linux-crypto@vger.kernel.org
Received: by mta11.migadu.com with ESMTPS id 8ed5e7393a3496c1;
	Sun, 30 Aug 2026 22:21:41 +0000
X-Mizu-Trace-ID: 8ed5e7393a3496c1
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
Subject: [PATCH v2 1/2] lib/zstd: add fallback aliases for disabled BMI2 variants
Date: Sun, 30 Aug 2026 15:20:24 -0700
Message-ID: <20260830222100.2706175-2-usama.arif@linux.dev>
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

