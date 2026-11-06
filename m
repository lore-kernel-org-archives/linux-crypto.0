Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=210.118.77.12
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793976190;
	b=mpNnMiQ0RkntKFpQpW+c3TdXGz7Z96JoseBaP1psZtFBUbnfPxReZg8vby4l1GOnaDTk
	 HbkeYuJqu8eUzq1/jySLMMDQqzSLBoevJYF9j8QqiOzFQ2pkVqi/ahj063Eko+PamEXK/
	 VrS3X/WI+e2CS+Eestr1ZzRSagdEhVnOKWbGRX4w6bn0PN9+BkTCAhyZo9KbV2Hstj3Zd
	 VhGLr2qZCCM5+nif687vj6eevkH7pj0CN7iP3/i/BAznxCEZVOnj/NX/aLl48zBJdaNiH
	 EASOVUztmZSrRpl0JK4HQE2ozSjAccucUpee0Su5Q9EfOkU3ABKY9Z5JNpx43UVOiRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793976190;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 From:Date:Subject:MIME-Version:Content-Transfer-Encoding:Message-Id:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-CMS-MailID:X-Msg-Generator:Content-Type:X-RootMTR:X-EPHeader:
	 X-CMS-RootMailID:References;
	bh=QeSRaIjQMGZBJ04rDlv5Fqgr86zkPN+SLNqAVa0ep6g=;
	b=MQ9j6WEfrqrBkNneEqQy6mTmqai727mPsjnaCI9EOuSeqj1YUKWiIQraW5sflF0tgwcp
	 ejBk/wZ2bLeGihLTgS0YqxYXJQhoc9OdlLOQfTu3HNwza/hFlWsTHMBGQ/NamWb0N6FPT
	 c7+GkU5/mJNw3Btoh8xIE9H1sDRTd2FpFTBxGz3yfeqtgZW83PLSeDVB0DOwERkaZwskC
	 syUhPNzK7/5mg8C0iXBVHlPsz0a/K+5BAB82o6adeaW0/8uKiXzJ848uQCgMSG6SJWBGp
	 UqNW2Cz3yTO+Bx6BfhBJIgXlMNQuRrJAzuuEnksRoqwJtVjBxVgZ5pzu013lrGqh+zA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=f79xIhj+;
	arc=none smtp.remote-ip=210.118.77.12
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65E706082BE7;
	Fri,  6 Nov 2026 14:43:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 65E706082BE7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=f79xIhj+
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20261106144307euoutp027ab7b14192172bc0dfee4c3d5de435bb~le9Z2GgYt1214112141euoutp028;
	Fri,  6 Nov 2026 14:43:07 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20261106144307euoutp027ab7b14192172bc0dfee4c3d5de435bb~le9Z2GgYt1214112141euoutp028
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1793976187;
	bh=QeSRaIjQMGZBJ04rDlv5Fqgr86zkPN+SLNqAVa0ep6g=;
	h=From:Date:Subject:In-Reply-To:To:Cc:References:From;
	b=f79xIhj+LkrbKn1pgOBkzjQOo989IRftmtI4AU/mGPeOz9vsTAO9yWsO3MEGgd3H6
	 zx0D8L3p5QD2ITeZ7zNltPF2xCImua0DbJ2g+2nIijo1MB3q16D2gLUWFyUcCx5j7S
	 ud3kFm7EMWFmuKq/6LOEWjOJftHKvzagb6+3K7ss=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20261106144306eucas1p17d110f5e01991516acd49252f81845b2~le9ZQLTn00320803208eucas1p1t;
	Fri,  6 Nov 2026 14:43:06 +0000 (GMT)
Received: from AMDC4942.eu.corp.samsungelectronics.net (unknown
	[106.210.136.40]) by eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261106144305eusmtip1ba0052de3e7e6b816f6959848f78e0b1~le9Xpfnrf0163701637eusmtip1M;
	Fri,  6 Nov 2026 14:43:05 +0000 (GMT)
From: Michal Wilczynski <m.wilczynski@samsung.com>
Date: Fri, 06 Nov 2026 15:42:51 +0100
Subject: [PATCH v2 11/15] lib/lz4: switch the HC compressor to the vendored
 sources
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-Id: <20261106-lz4-vendor-upstream-v2-11-ee04c3f0d7dc@samsung.com>
In-Reply-To: <20261106-lz4-vendor-upstream-v2-0-ee04c3f0d7dc@samsung.com>
To: Michal Wilczynski <m.wilczynski@samsung.com>,  Nathan Chancellor
	<nathan@kernel.org>,  Nick Desaulniers <ndesaulniers@google.com>,  Bill
	Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>,  Russell
	King <linux@armlinux.org.uk>,  Thomas Bogendoerfer
	<tsbogend@alpha.franken.de>,  "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>,  Helge Deller <deller@gmx.de>,
	Heiko Carstens <hca@linux.ibm.com>,  Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>,  Christian Borntraeger
	<borntraeger@linux.ibm.com>,  Sven Schnelle <svens@linux.ibm.com>, Thomas
	Gleixner <tglx@kernel.org>,  Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>,  Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Minchan Kim <minchan@kernel.org>,  Sergey
	Senozhatsky <senozhatsky@chromium.org>, Jens Axboe <axboe@kernel.dk>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org, 
	linux-parisc@vger.kernel.org, linux-s390@vger.kernel.org, 
	linux-block@vger.kernel.org, Yann Collet <yann.collet.73@gmail.com>,  Nick
	Terrell <terrelln@meta.com>, Gao Xiang <xiang@kernel.org>,  Chao Yu
	<chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>,  Eric Biggers
	<ebiggers@kernel.org>,  Herbert Xu <herbert@gondor.apana.org.au>,  David
	Laight <david.laight.linux@gmail.com>,  Sungguk <sungguk.na@samsung.com>,
	Jaehoon Chung <jh80.chung@samsung.com>,  Marek Szyprowski
	<m.szyprowski@samsung.com>, linux-erofs@lists.ozlabs.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-crypto@vger.kernel.org
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=31941;
	i=m.wilczynski@samsung.com; h=from:subject:message-id;
	bh=NZfK+YWfAH4HDbRQpekc+YNtk3ygws9Y5TIPqdC9u4E=;
	b=owGbwMvMwCGWumv6zndzRCIZT6slMWS9fZ564f4aS/2pIkx6l2ax/JQ5XLT6lZZNnMDKt0Lqx
	wRL12ou7ihlYRDjYJAVU2Q5uzHaSPIfw9Py449/wcxhZQIZwsDFKQAT0Z/P8Ff+wZc9oW0GaXkn
	pglOX/6qW/fidvmoDdevdPxbcXHra5ZUhr+yE4O3cdje47rfdk1+tvqWX/nL+Db+3b+z3/ytjuR
	16WoGAA==
X-Developer-Key: i=m.wilczynski@samsung.com; a=openpgp;
	fpr=CDB15B3219FE00E577C7E3FA65BA97B9EE9C1459
X-CMS-MailID: 20261106144306eucas1p17d110f5e01991516acd49252f81845b2
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20261106144306eucas1p17d110f5e01991516acd49252f81845b2
X-EPHeader: CA
X-CMS-RootMailID: 20261106144306eucas1p17d110f5e01991516acd49252f81845b2
References: <20261106-lz4-vendor-upstream-v2-0-ee04c3f0d7dc@samsung.com>
	<CGME20261106144306eucas1p17d110f5e01991516acd49252f81845b2@eucas1p1.samsung.com>

Replace the forked LZ4HC with thin entry points over the vendored
lz4hc.c.

Upstream routes levels 10 and up to its optimal parser, whose ~64K
workspace the kernel cannot provide. Clamp those levels to 9 rather than
reject them, so existing f2fs and zram settings keep working, and add
LZ4HC_CLAMP_CLEVEL to <linux/lz4.h>. Document the clamp in f2fs.rst.

Levels 1 and 2 now use upstream's lz4mid: on kernel source they are
50-84% faster for 4-9% larger output. Levels 3 to 9 compress the same,
but at 4K are up to 15% slower on poorly compressible data, including at
level 9, zram's lz4hc default.

LZ4_compress_HC() and LZ4_resetStreamHC() check the state's alignment
like the compressor's entry points.

LZ4_streamHC_t becomes incomplete and the macros that laid out the forked
structure go. LZ4HC_MEM_COMPRESS grows from 262192 to upstream's 262200,
static_asserted against LZ4_STREAMHC_MINSIZE. lz4hc.c pulls in lz4.c's
decoder tables, unused here when the fast decode loop is off, so silence
-Wunused-const-variable for this object.

This retires commit b08918fb3f27 ("lz4: do not export static symbol"):
the glue exports only the five LZ4HC entry points.

Signed-off-by: Michal Wilczynski <m.wilczynski@samsung.com>
---
 Documentation/filesystems/f2fs.rst |   2 +
 drivers/block/zram/backend_lz4hc.c |   2 +-
 include/linux/lz4.h                |  54 +--
 lib/lz4/Makefile                   |   4 +
 lib/lz4/lz4hc_compress.c           | 792 ++++---------------------------------
 5 files changed, 91 insertions(+), 763 deletions(-)

diff --git a/Documentation/filesystems/f2fs.rst b/Documentation/filesystems/f2fs.rst
index 771216f45207a797356d5d2a10328b74d1ab302a..4a2d4545c2752cbcea4939839ba3d2457bf92299 100644
--- a/Documentation/filesystems/f2fs.rst
+++ b/Documentation/filesystems/f2fs.rst
@@ -318,6 +318,8 @@ compress_algorithm=%s:%d Control compress algorithm and its compress level, now,
 				 zstd           1 - 22
 				 =========      ===========
 
+			 lz4 levels above 9 compress as level 9.
+
 compress_log_size=%u	 Support configuring compress cluster size. The size will
 			 be 4KB * (1 << %u). The default and minimum sizes are 16KB.
 compress_extension=%s	 Support adding specified extension, so that f2fs can enable
diff --git a/drivers/block/zram/backend_lz4hc.c b/drivers/block/zram/backend_lz4hc.c
index 06286c805cf7c56bd760f460cc854dc4014f293b..e7ee3740219852f079d1e0866da6b213a3f3a583 100644
--- a/drivers/block/zram/backend_lz4hc.c
+++ b/drivers/block/zram/backend_lz4hc.c
@@ -69,7 +69,7 @@ static int lz4hc_create(struct zcomp_params *params, struct zcomp_ctx *ctx)
 		if (!zctx->dstrm)
 			goto error;
 
-		zctx->cstrm = kzalloc_obj(*zctx->cstrm);
+		zctx->cstrm = kzalloc(LZ4HC_MEM_COMPRESS, GFP_KERNEL);
 		if (!zctx->cstrm)
 			goto error;
 		LZ4_resetStreamHC(zctx->cstrm, params->level);
diff --git a/include/linux/lz4.h b/include/linux/lz4.h
index 031a410b8e3878e9a24cc49af36cfcbba399d991..05060b9790be4621ddbe744172fa0ae37f6191f4 100644
--- a/include/linux/lz4.h
+++ b/include/linux/lz4.h
@@ -59,19 +59,16 @@
 #define LZ4HC_DEFAULT_CLEVEL			9
 #define LZ4HC_MAX_CLEVEL			16
 
-#define LZ4HC_DICTIONARY_LOGSIZE 16
-#define LZ4HC_MAXD (1<<LZ4HC_DICTIONARY_LOGSIZE)
-#define LZ4HC_MAXD_MASK (LZ4HC_MAXD - 1)
-#define LZ4HC_HASH_LOG (LZ4HC_DICTIONARY_LOGSIZE - 1)
-#define LZ4HC_HASHTABLESIZE (1 << LZ4HC_HASH_LOG)
-#define LZ4HC_HASH_MASK (LZ4HC_HASHTABLESIZE - 1)
+/* Levels from here up select the optimal parser, which needs a ~64K
+ * workspace lib/lz4 cannot give it, so lib/lz4 compresses them as
+ * LZ4HC_CLAMP_CLEVEL - 1.  f2fs and zram still accept levels up to
+ * LZ4HC_MAX_CLEVEL.
+ */
+#define LZ4HC_CLAMP_CLEVEL			10
 
 /*-************************************************************************
  *	STREAMING CONSTANTS AND STRUCTURES
  **************************************************************************/
-#define LZ4_STREAMHCSIZE        262192
-#define LZ4_STREAMHCSIZE_SIZET (262192 / sizeof(size_t))
-
 #define LZ4_STREAMDECODESIZE_U64	4
 #define LZ4_STREAMDECODESIZE		 (LZ4_STREAMDECODESIZE_U64 * \
 	sizeof(unsigned long long))
@@ -83,29 +80,10 @@
 typedef union LZ4_stream_u LZ4_stream_t;
 
 /*
- * LZ4_streamHC_t - information structure to track an LZ4HC stream.
+ * LZ4_streamHC_t - an LZ4HC stream.  Incomplete: lib/lz4 owns the layout.
+ * Allocate LZ4HC_MEM_COMPRESS bytes and cast, do not sizeof().
  */
-typedef struct {
-	unsigned int	 hashTable[LZ4HC_HASHTABLESIZE];
-	unsigned short	 chainTable[LZ4HC_MAXD];
-	/* next block to continue on current prefix */
-	const unsigned char *end;
-	/* All index relative to this position */
-	const unsigned char *base;
-	/* alternate base for extDict */
-	const unsigned char *dictBase;
-	/* below that point, need extDict */
-	unsigned int	 dictLimit;
-	/* below that point, no more dict */
-	unsigned int	 lowLimit;
-	/* index from which to continue dict update */
-	unsigned int	 nextToUpdate;
-	unsigned int	 compressionLevel;
-} LZ4HC_CCtx_internal;
-typedef union {
-	size_t table[LZ4_STREAMHCSIZE_SIZET];
-	LZ4HC_CCtx_internal internal_donotuse;
-} LZ4_streamHC_t;
+typedef union LZ4_streamHC_u LZ4_streamHC_t;
 
 /*
  * LZ4_streamDecode_t - information structure to track an
@@ -133,7 +111,7 @@ typedef union {
  * points warn about a misaligned buffer and fail the call.
  */
 #define LZ4_MEM_COMPRESS	16416
-#define LZ4HC_MEM_COMPRESS	LZ4_STREAMHCSIZE
+#define LZ4HC_MEM_COMPRESS	262200
 
 /*-************************************************************************
  *	Compression Functions
@@ -289,9 +267,9 @@ int LZ4_decompress_safe_partial(const char *source, char *dest,
  * @srcSize: size of the input data. Max supported value is LZ4_MAX_INPUT_SIZE
  * @dstCapacity: full or partial size of buffer 'dst',
  *	which must be already allocated
- * @compressionLevel: Recommended values are between 4 and 9, although any
- *	value between 1 and LZ4HC_MAX_CLEVEL will work.
- *	Values >LZ4HC_MAX_CLEVEL behave the same as 16.
+ * @compressionLevel: Recommended values are between 4 and 9.  Levels of
+ *	LZ4HC_CLAMP_CLEVEL and above are clamped to LZ4HC_CLAMP_CLEVEL - 1;
+ *	see that macro.
  * @wrkmem: address of the working memory.
  *	This requires 'wrkmem' of size LZ4HC_MEM_COMPRESS, aligned to 8 bytes.
  *
@@ -307,9 +285,9 @@ int LZ4_compress_HC(const char *src, char *dst, int srcSize, int dstCapacity,
 /**
  * LZ4_resetStreamHC() - Init an allocated 'LZ4_streamHC_t' structure
  * @streamHCPtr: pointer to the 'LZ4_streamHC_t' structure
- * @compressionLevel: Recommended values are between 4 and 9, although any
- *	value between 1 and LZ4HC_MAX_CLEVEL will work.
- *	Values >LZ4HC_MAX_CLEVEL behave the same as 16.
+ * @compressionLevel: Recommended values are between 4 and 9.  Levels of
+ *	LZ4HC_CLAMP_CLEVEL and above are clamped to LZ4HC_CLAMP_CLEVEL - 1;
+ *	see that macro.
  *
  * An LZ4_streamHC_t structure can be allocated once
  * and re-used multiple times.
diff --git a/lib/lz4/Makefile b/lib/lz4/Makefile
index 8b4eb07694e67dd99ec7cc85212fb68138d3981e..5cbbe10beedce1199dee68992d542a1e52f89f8e 100644
--- a/lib/lz4/Makefile
+++ b/lib/lz4/Makefile
@@ -10,3 +10,7 @@ ccflags-y += -I $(src)/freestanding
 obj-$(CONFIG_LZ4_COMPRESS)	+= lz4_compress.o
 obj-$(CONFIG_LZ4HC_COMPRESS)	+= lz4hc_compress.o
 obj-$(CONFIG_LZ4_DECOMPRESS)	+= lz4_decompress.o
+
+# lz4hc.c pulls in lz4.c's common definitions, which include two decoder
+# tables nothing here uses when LZ4_FAST_DEC_LOOP is off.
+CFLAGS_lz4hc_compress.o += $(call cc-disable-warning, unused-const-variable)
diff --git a/lib/lz4/lz4hc_compress.c b/lib/lz4/lz4hc_compress.c
index 91936dc3d14bca31752a361693380aad8eb3b98a..4d56d45028110805628be766b2758a8dffd56f0c 100644
--- a/lib/lz4/lz4hc_compress.c
+++ b/lib/lz4/lz4hc_compress.c
@@ -1,766 +1,110 @@
+// SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
 /*
- * LZ4 HC - High Compression Mode of LZ4
- * Copyright (C) 2011-2015, Yann Collet.
+ * Copyright (C) 2011 - 2016, Yann Collet.
+ * Copyright (C) 2016, Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
+ * Copyright (c) 2026 Samsung Electronics Co., Ltd.
+ * Author: Michal Wilczynski <m.wilczynski@samsung.com>
  *
- * BSD 2 - Clause License (http://www.opensource.org/licenses/bsd - license.php)
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions are
- * met:
- *	* Redistributions of source code must retain the above copyright
- *	  notice, this list of conditions and the following disclaimer.
- *	* Redistributions in binary form must reproduce the above
- * copyright notice, this list of conditions and the following disclaimer
- * in the documentation and/or other materials provided with the
- * distribution.
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
- * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
- * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
- * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
- * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
- * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
- * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
- * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
- * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
- * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- * You can contact the author at :
- *	- LZ4 homepage : http://www.lz4.org
- *	- LZ4 source repository : https://github.com/lz4/lz4
+ * LZ4 HC compressor -- kernel entry points
  *
- *	Changed for kernel usage by:
- *	Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
+ * The compressor is upstream's, in the verbatim lz4hc.c included below.
+ * LZ4_compress_HC() takes the kernel's trailing wrkmem argument and forwards
+ * to LZ4_compress_HC_extStateHC(); the level-taking entry points clamp the
+ * level below LZ4HC_CLEVEL_OPT_MIN (see lz4hc_clamp_level()).
  */
 
-/*-************************************
- *	Dependencies
- **************************************/
-#include "lz4defs.h"
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/string.h> /* memset */
-
-/* *************************************
- *	Local Constants and types
- ***************************************/
-
-#define OPTIMAL_ML (int)((ML_MASK - 1) + MINMATCH)
-
-#define HASH_FUNCTION(i)	(((i) * 2654435761U) \
-	>> ((MINMATCH*8) - LZ4HC_HASH_LOG))
-#define DELTANEXTU16(p)	chainTable[(U16)(p)] /* faster */
-
-static U32 LZ4HC_hashPtr(const void *ptr)
-{
-	return HASH_FUNCTION(LZ4_read32(ptr));
-}
+#include "lz4_deps.h"
 
-/**************************************
- *	HC Compression
- **************************************/
-static void LZ4HC_init(LZ4HC_CCtx_internal *hc4, const BYTE *start)
-{
-	memset((void *)hc4->hashTable, 0, sizeof(hc4->hashTable));
-	memset(hc4->chainTable, 0xFF, sizeof(hc4->chainTable));
-	hc4->nextToUpdate = 64 * KB;
-	hc4->base = start - 64 * KB;
-	hc4->end = start;
-	hc4->dictBase = start - 64 * KB;
-	hc4->dictLimit = 64 * KB;
-	hc4->lowLimit = 64 * KB;
-}
-
-/* Update chains up to ip (excluded) */
-static FORCE_INLINE void LZ4HC_Insert(LZ4HC_CCtx_internal *hc4,
-	const BYTE *ip)
+/* lz4hc.c includes lz4.c with LZ4_COMMONDEFS_ONLY, which stops short of
+ * LZ4_compressBound().  Supply it for lz4hc.c's internal use.
+ */
+static int LZ4_compressBound(int isize)
 {
-	U16 * const chainTable = hc4->chainTable;
-	U32 * const hashTable	= hc4->hashTable;
-	const BYTE * const base = hc4->base;
-	U32 const target = (U32)(ip - base);
-	U32 idx = hc4->nextToUpdate;
-
-	while (idx < target) {
-		U32 const h = LZ4HC_hashPtr(base + idx);
-		size_t delta = idx - hashTable[h];
-
-		if (delta > MAX_DISTANCE)
-			delta = MAX_DISTANCE;
-
-		DELTANEXTU16(idx) = (U16)delta;
-
-		hashTable[h] = idx;
-		idx++;
-	}
-
-	hc4->nextToUpdate = target;
+	return LZ4_COMPRESSBOUND(isize);
 }
 
-static FORCE_INLINE int LZ4HC_InsertAndFindBestMatch(
-	LZ4HC_CCtx_internal *hc4, /* Index table will be updated */
-	const BYTE *ip,
-	const BYTE * const iLimit,
-	const BYTE **matchpos,
-	const int maxNbAttempts)
-{
-	U16 * const chainTable = hc4->chainTable;
-	U32 * const HashTable = hc4->hashTable;
-	const BYTE * const base = hc4->base;
-	const BYTE * const dictBase = hc4->dictBase;
-	const U32 dictLimit = hc4->dictLimit;
-	const U32 lowLimit = (hc4->lowLimit + 64 * KB > (U32)(ip - base))
-		? hc4->lowLimit
-		: (U32)(ip - base) - (64 * KB - 1);
-	U32 matchIndex;
-	int nbAttempts = maxNbAttempts;
-	size_t ml = 0;
-
-	/* HC4 match finder */
-	LZ4HC_Insert(hc4, ip);
-	matchIndex = HashTable[LZ4HC_hashPtr(ip)];
-
-	while ((matchIndex >= lowLimit)
-		&& (nbAttempts)) {
-		nbAttempts--;
-		if (matchIndex >= dictLimit) {
-			const BYTE * const match = base + matchIndex;
-
-			if (*(match + ml) == *(ip + ml)
-				&& (LZ4_read32(match) == LZ4_read32(ip))) {
-				size_t const mlt = LZ4_count(ip + MINMATCH,
-					match + MINMATCH, iLimit) + MINMATCH;
-
-				if (mlt > ml) {
-					ml = mlt;
-					*matchpos = match;
-				}
-			}
-		} else {
-			const BYTE * const match = dictBase + matchIndex;
+#include "upstream/lz4hc.c"
 
-			if (LZ4_read32(match) == LZ4_read32(ip)) {
-				size_t mlt;
-				const BYTE *vLimit = ip
-					+ (dictLimit - matchIndex);
+/* Upstream's short helper macros; MIN and MAX clash with <linux/minmax.h>. */
+#undef MIN
+#undef MAX
+#undef KB
+#undef MB
+#undef GB
 
-				if (vLimit > iLimit)
-					vLimit = iLimit;
-				mlt = LZ4_count(ip + MINMATCH,
-					match + MINMATCH, vLimit) + MINMATCH;
-				if ((ip + mlt == vLimit)
-					&& (vLimit < iLimit))
-					mlt += LZ4_count(ip + mlt,
-						base + dictLimit,
-						iLimit);
-				if (mlt > ml) {
-					/* virtual matchpos */
-					ml = mlt;
-					*matchpos = base + matchIndex;
-				}
-			}
-		}
-		matchIndex -= DELTANEXTU16(matchIndex);
-	}
+#include "lz4_kernel_api.h"
+#include <linux/bug.h>
+#include <linux/export.h>
+#include <linux/module.h>
 
-	return (int)ml;
-}
+/* Catch any divergence from upstream's layout at build time. */
+static_assert(sizeof(LZ4_streamHC_t) == LZ4_STREAMHC_MINSIZE);
+static_assert(LZ4_STREAMHC_MINSIZE == 262200); /* LZ4HC_MEM_COMPRESS */
 
-static FORCE_INLINE int LZ4HC_InsertAndGetWiderMatch(
-	LZ4HC_CCtx_internal *hc4,
-	const BYTE * const ip,
-	const BYTE * const iLowLimit,
-	const BYTE * const iHighLimit,
-	int longest,
-	const BYTE **matchpos,
-	const BYTE **startpos,
-	const int maxNbAttempts)
+/* Levels >= LZ4HC_CLEVEL_OPT_MIN (10) reach the optimal parser, which needs
+ * a ~64K opt[]: too big for a kernel stack, and in the heap mode lz4_deps.h
+ * selects its allocation always fails, and so would the call.  Clamp them
+ * to 9 rather than reject them, so existing f2fs and zram settings keep
+ * working.  Levels 3..9 keep their meaning; 1 and 2 are upstream's lz4mid,
+ * faster and weaker than the shallow hash chain the fork used for them.
+ */
+static int lz4hc_clamp_level(int compressionLevel)
 {
-	U16 * const chainTable = hc4->chainTable;
-	U32 * const HashTable = hc4->hashTable;
-	const BYTE * const base = hc4->base;
-	const U32 dictLimit = hc4->dictLimit;
-	const BYTE * const lowPrefixPtr = base + dictLimit;
-	const U32 lowLimit = (hc4->lowLimit + 64 * KB > (U32)(ip - base))
-		? hc4->lowLimit
-		: (U32)(ip - base) - (64 * KB - 1);
-	const BYTE * const dictBase = hc4->dictBase;
-	U32 matchIndex;
-	int nbAttempts = maxNbAttempts;
-	int delta = (int)(ip - iLowLimit);
-
-	/* First Match */
-	LZ4HC_Insert(hc4, ip);
-	matchIndex = HashTable[LZ4HC_hashPtr(ip)];
-
-	while ((matchIndex >= lowLimit)
-		&& (nbAttempts)) {
-		nbAttempts--;
-		if (matchIndex >= dictLimit) {
-			const BYTE *matchPtr = base + matchIndex;
-
-			if (*(iLowLimit + longest)
-				== *(matchPtr - delta + longest)) {
-				if (LZ4_read32(matchPtr) == LZ4_read32(ip)) {
-					int mlt = MINMATCH + LZ4_count(
-						ip + MINMATCH,
-						matchPtr + MINMATCH,
-						iHighLimit);
-					int back = 0;
-
-					while ((ip + back > iLowLimit)
-						&& (matchPtr + back > lowPrefixPtr)
-						&& (ip[back - 1] == matchPtr[back - 1]))
-						back--;
+	if (compressionLevel >= LZ4HC_CLEVEL_OPT_MIN)
+		return LZ4HC_CLEVEL_OPT_MIN - 1;
 
-					mlt -= back;
-
-					if (mlt > longest) {
-						longest = (int)mlt;
-						*matchpos = matchPtr + back;
-						*startpos = ip + back;
-					}
-				}
-			}
-		} else {
-			const BYTE * const matchPtr = dictBase + matchIndex;
-
-			if (LZ4_read32(matchPtr) == LZ4_read32(ip)) {
-				size_t mlt;
-				int back = 0;
-				const BYTE *vLimit = ip + (dictLimit - matchIndex);
-
-				if (vLimit > iHighLimit)
-					vLimit = iHighLimit;
-
-				mlt = LZ4_count(ip + MINMATCH,
-					matchPtr + MINMATCH, vLimit) + MINMATCH;
-
-				if ((ip + mlt == vLimit) && (vLimit < iHighLimit))
-					mlt += LZ4_count(ip + mlt, base + dictLimit,
-						iHighLimit);
-				while ((ip + back > iLowLimit)
-					&& (matchIndex + back > lowLimit)
-					&& (ip[back - 1] == matchPtr[back - 1]))
-					back--;
-
-				mlt -= back;
-
-				if ((int)mlt > longest) {
-					longest = (int)mlt;
-					*matchpos = base + matchIndex + back;
-					*startpos = ip + back;
-				}
-			}
-		}
-
-		matchIndex -= DELTANEXTU16(matchIndex);
-	}
-
-	return longest;
+	return compressionLevel;
 }
 
-static FORCE_INLINE int LZ4HC_encodeSequence(
-	const BYTE **ip,
-	BYTE **op,
-	const BYTE **anchor,
-	int matchLength,
-	const BYTE * const match,
-	limitedOutput_directive limitedOutputBuffer,
-	BYTE *oend)
+/* LZ4_initStreamHC() returns NULL for a misaligned state.
+ * LZ4_compress_HC_extStateHC() then fails quietly, and LZ4_resetStreamHC()
+ * ignores it and leaves the state uninitialised.  Warn, and skip the reset.
+ */
+static bool lz4hc_state_misaligned(const void *state)
 {
-	int length;
-	BYTE *token;
-
-	/* Encode Literal length */
-	length = (int)(*ip - *anchor);
-	token = (*op)++;
-
-	if ((limitedOutputBuffer)
-		&& ((*op + (length>>8)
-			+ length + (2 + 1 + LASTLITERALS)) > oend)) {
-		/* Check output limit */
-		return 1;
-	}
-	if (length >= (int)RUN_MASK) {
-		int len;
-
-		*token = (RUN_MASK<<ML_BITS);
-		len = length - RUN_MASK;
-		for (; len > 254 ; len -= 255)
-			*(*op)++ = 255;
-		*(*op)++ = (BYTE)len;
-	} else
-		*token = (BYTE)(length<<ML_BITS);
-
-	/* Copy Literals */
-	LZ4_wildCopy(*op, *anchor, (*op) + length);
-	*op += length;
-
-	/* Encode Offset */
-	LZ4_writeLE16(*op, (U16)(*ip - match));
-	*op += 2;
-
-	/* Encode MatchLength */
-	length = (int)(matchLength - MINMATCH);
-
-	if ((limitedOutputBuffer)
-		&& (*op + (length>>8)
-			+ (1 + LASTLITERALS) > oend)) {
-		/* Check output limit */
-		return 1;
-	}
-
-	if (length >= (int)ML_MASK) {
-		*token += ML_MASK;
-		length -= ML_MASK;
-
-		for (; length > 509 ; length -= 510) {
-			*(*op)++ = 255;
-			*(*op)++ = 255;
-		}
-
-		if (length > 254) {
-			length -= 255;
-			*(*op)++ = 255;
-		}
-
-		*(*op)++ = (BYTE)length;
-	} else
-		*token += (BYTE)(length);
-
-	/* Prepare next loop */
-	*ip += matchLength;
-	*anchor = *ip;
-
-	return 0;
+	return WARN_ON_ONCE(!LZ4_isAligned(state, LZ4_streamHC_t_alignment()));
 }
 
-static int LZ4HC_compress_generic(
-	LZ4HC_CCtx_internal *const ctx,
-	const char * const source,
-	char * const dest,
-	int const inputSize,
-	int const maxOutputSize,
-	int compressionLevel,
-	limitedOutput_directive limit
-	)
+int LZ4_compress_HC(const char *src, char *dst, int srcSize, int dstCapacity,
+		    int compressionLevel, void *wrkmem)
 {
-	const BYTE *ip = (const BYTE *) source;
-	const BYTE *anchor = ip;
-	const BYTE * const iend = ip + inputSize;
-	const BYTE * const mflimit = iend - MFLIMIT;
-	const BYTE * const matchlimit = (iend - LASTLITERALS);
-
-	BYTE *op = (BYTE *) dest;
-	BYTE * const oend = op + maxOutputSize;
-
-	unsigned int maxNbAttempts;
-	int ml, ml2, ml3, ml0;
-	const BYTE *ref = NULL;
-	const BYTE *start2 = NULL;
-	const BYTE *ref2 = NULL;
-	const BYTE *start3 = NULL;
-	const BYTE *ref3 = NULL;
-	const BYTE *start0;
-	const BYTE *ref0;
-
-	/* init */
-	if (compressionLevel > LZ4HC_MAX_CLEVEL)
-		compressionLevel = LZ4HC_MAX_CLEVEL;
-	if (compressionLevel < 1)
-		compressionLevel = LZ4HC_DEFAULT_CLEVEL;
-	maxNbAttempts = 1 << (compressionLevel - 1);
-	ctx->end += inputSize;
-
-	ip++;
-
-	/* Main Loop */
-	while (ip < mflimit) {
-		ml = LZ4HC_InsertAndFindBestMatch(ctx, ip,
-			matchlimit, (&ref), maxNbAttempts);
-		if (!ml) {
-			ip++;
-			continue;
-		}
-
-		/* saved, in case we would skip too much */
-		start0 = ip;
-		ref0 = ref;
-		ml0 = ml;
-
-_Search2:
-		if (ip + ml < mflimit)
-			ml2 = LZ4HC_InsertAndGetWiderMatch(ctx,
-				ip + ml - 2, ip + 0,
-				matchlimit, ml, &ref2,
-				&start2, maxNbAttempts);
-		else
-			ml2 = ml;
-
-		if (ml2 == ml) {
-			/* No better match */
-			if (LZ4HC_encodeSequence(&ip, &op,
-				&anchor, ml, ref, limit, oend))
-				return 0;
-			continue;
-		}
-
-		if (start0 < ip) {
-			if (start2 < ip + ml0) {
-				/* empirical */
-				ip = start0;
-				ref = ref0;
-				ml = ml0;
-			}
-		}
-
-		/* Here, start0 == ip */
-		if ((start2 - ip) < 3) {
-			/* First Match too small : removed */
-			ml = ml2;
-			ip = start2;
-			ref = ref2;
-			goto _Search2;
-		}
-
-_Search3:
-		/*
-		* Currently we have :
-		* ml2 > ml1, and
-		* ip1 + 3 <= ip2 (usually < ip1 + ml1)
-		*/
-		if ((start2 - ip) < OPTIMAL_ML) {
-			int correction;
-			int new_ml = ml;
-
-			if (new_ml > OPTIMAL_ML)
-				new_ml = OPTIMAL_ML;
-			if (ip + new_ml > start2 + ml2 - MINMATCH)
-				new_ml = (int)(start2 - ip) + ml2 - MINMATCH;
-
-			correction = new_ml - (int)(start2 - ip);
-
-			if (correction > 0) {
-				start2 += correction;
-				ref2 += correction;
-				ml2 -= correction;
-			}
-		}
-		/*
-		 * Now, we have start2 = ip + new_ml,
-		 * with new_ml = min(ml, OPTIMAL_ML = 18)
-		 */
-
-		if (start2 + ml2 < mflimit)
-			ml3 = LZ4HC_InsertAndGetWiderMatch(ctx,
-				start2 + ml2 - 3, start2,
-				matchlimit, ml2, &ref3, &start3,
-				maxNbAttempts);
-		else
-			ml3 = ml2;
-
-		if (ml3 == ml2) {
-			/* No better match : 2 sequences to encode */
-			/* ip & ref are known; Now for ml */
-			if (start2 < ip + ml)
-				ml = (int)(start2 - ip);
-			/* Now, encode 2 sequences */
-			if (LZ4HC_encodeSequence(&ip, &op, &anchor,
-				ml, ref, limit, oend))
-				return 0;
-			ip = start2;
-			if (LZ4HC_encodeSequence(&ip, &op, &anchor,
-				ml2, ref2, limit, oend))
-				return 0;
-			continue;
-		}
-
-		if (start3 < ip + ml + 3) {
-			/* Not enough space for match 2 : remove it */
-			if (start3 >= (ip + ml)) {
-				/* can write Seq1 immediately
-				 * ==> Seq2 is removed,
-				 * so Seq3 becomes Seq1
-				 */
-				if (start2 < ip + ml) {
-					int correction = (int)(ip + ml - start2);
-
-					start2 += correction;
-					ref2 += correction;
-					ml2 -= correction;
-					if (ml2 < MINMATCH) {
-						start2 = start3;
-						ref2 = ref3;
-						ml2 = ml3;
-					}
-				}
-
-				if (LZ4HC_encodeSequence(&ip, &op, &anchor,
-					ml, ref, limit, oend))
-					return 0;
-				ip = start3;
-				ref = ref3;
-				ml = ml3;
-
-				start0 = start2;
-				ref0 = ref2;
-				ml0 = ml2;
-				goto _Search2;
-			}
-
-			start2 = start3;
-			ref2 = ref3;
-			ml2 = ml3;
-			goto _Search3;
-		}
-
-		/*
-		* OK, now we have 3 ascending matches;
-		* let's write at least the first one
-		* ip & ref are known; Now for ml
-		*/
-		if (start2 < ip + ml) {
-			if ((start2 - ip) < (int)ML_MASK) {
-				int correction;
-
-				if (ml > OPTIMAL_ML)
-					ml = OPTIMAL_ML;
-				if (ip + ml > start2 + ml2 - MINMATCH)
-					ml = (int)(start2 - ip) + ml2 - MINMATCH;
-				correction = ml - (int)(start2 - ip);
-				if (correction > 0) {
-					start2 += correction;
-					ref2 += correction;
-					ml2 -= correction;
-				}
-			} else
-				ml = (int)(start2 - ip);
-		}
-		if (LZ4HC_encodeSequence(&ip, &op, &anchor, ml,
-			ref, limit, oend))
-			return 0;
-
-		ip = start2;
-		ref = ref2;
-		ml = ml2;
-
-		start2 = start3;
-		ref2 = ref3;
-		ml2 = ml3;
-
-		goto _Search3;
-	}
-
-	/* Encode Last Literals */
-	{
-		int lastRun = (int)(iend - anchor);
-
-		if ((limit)
-			&& (((char *)op - dest) + lastRun + 1
-				+ ((lastRun + 255 - RUN_MASK)/255)
-					> (U32)maxOutputSize)) {
-			/* Check output limit */
-			return 0;
-		}
-		if (lastRun >= (int)RUN_MASK) {
-			*op++ = (RUN_MASK<<ML_BITS);
-			lastRun -= RUN_MASK;
-			for (; lastRun > 254 ; lastRun -= 255)
-				*op++ = 255;
-			*op++ = (BYTE) lastRun;
-		} else
-			*op++ = (BYTE)(lastRun<<ML_BITS);
-		LZ4_memcpy(op, anchor, iend - anchor);
-		op += iend - anchor;
-	}
-
-	/* End */
-	return (int) (((char *)op) - dest);
-}
-
-static int LZ4_compress_HC_extStateHC(
-	void *state,
-	const char *src,
-	char *dst,
-	int srcSize,
-	int maxDstSize,
-	int compressionLevel)
-{
-	LZ4HC_CCtx_internal *ctx = &((LZ4_streamHC_t *)state)->internal_donotuse;
-
-	if (((size_t)(state)&(sizeof(void *) - 1)) != 0) {
-		/* Error : state is not aligned
-		 * for pointers (32 or 64 bits)
-		 */
+	if (lz4hc_state_misaligned(wrkmem))
 		return 0;
-	}
 
-	LZ4HC_init(ctx, (const BYTE *)src);
-
-	if (maxDstSize < LZ4_compressBound(srcSize))
-		return LZ4HC_compress_generic(ctx, src, dst,
-			srcSize, maxDstSize, compressionLevel, limitedOutput);
-	else
-		return LZ4HC_compress_generic(ctx, src, dst,
-			srcSize, maxDstSize, compressionLevel, noLimit);
-}
-
-int LZ4_compress_HC(const char *src, char *dst, int srcSize,
-	int maxDstSize, int compressionLevel, void *wrkmem)
-{
-	return LZ4_compress_HC_extStateHC(wrkmem, src, dst,
-		srcSize, maxDstSize, compressionLevel);
+	return LZ4_compress_HC_extStateHC(wrkmem, src, dst, srcSize,
+					  dstCapacity,
+					  lz4hc_clamp_level(compressionLevel));
 }
 EXPORT_SYMBOL(LZ4_compress_HC);
 
-/**************************************
- *	Streaming Functions
- **************************************/
-void LZ4_resetStreamHC(LZ4_streamHC_t *LZ4_streamHCPtr, int compressionLevel)
+void LZ4_resetStreamHC(LZ4_streamHC_t *streamHCPtr, int compressionLevel)
 {
-	LZ4_streamHCPtr->internal_donotuse.base = NULL;
-	LZ4_streamHCPtr->internal_donotuse.compressionLevel = (unsigned int)compressionLevel;
+	if (lz4hc_state_misaligned(streamHCPtr))
+		return;
+
+	__lz4_resetStreamHC(streamHCPtr, lz4hc_clamp_level(compressionLevel));
 }
 EXPORT_SYMBOL(LZ4_resetStreamHC);
 
-int LZ4_loadDictHC(LZ4_streamHC_t *LZ4_streamHCPtr,
-	const char *dictionary,
-	int dictSize)
+int LZ4_loadDictHC(LZ4_streamHC_t *streamHCPtr, const char *dictionary,
+		   int dictSize)
 {
-	LZ4HC_CCtx_internal *ctxPtr = &LZ4_streamHCPtr->internal_donotuse;
-
-	if (dictSize > 64 * KB) {
-		dictionary += dictSize - 64 * KB;
-		dictSize = 64 * KB;
-	}
-	LZ4HC_init(ctxPtr, (const BYTE *)dictionary);
-	if (dictSize >= 4)
-		LZ4HC_Insert(ctxPtr, (const BYTE *)dictionary + (dictSize - 3));
-	ctxPtr->end = (const BYTE *)dictionary + dictSize;
-	return dictSize;
+	return __lz4_loadDictHC(streamHCPtr, dictionary, dictSize);
 }
 EXPORT_SYMBOL(LZ4_loadDictHC);
 
-/* compression */
-
-static void LZ4HC_setExternalDict(
-	LZ4HC_CCtx_internal *ctxPtr,
-	const BYTE *newBlock)
+int LZ4_compress_HC_continue(LZ4_streamHC_t *streamHCPtr, const char *src,
+			     char *dst, int srcSize, int maxDstSize)
 {
-	if (ctxPtr->end >= ctxPtr->base + 4) {
-		/* Referencing remaining dictionary content */
-		LZ4HC_Insert(ctxPtr, ctxPtr->end - 3);
-	}
-
-	/*
-	 * Only one memory segment for extDict,
-	 * so any previous extDict is lost at this stage
-	 */
-	ctxPtr->lowLimit	= ctxPtr->dictLimit;
-	ctxPtr->dictLimit = (U32)(ctxPtr->end - ctxPtr->base);
-	ctxPtr->dictBase	= ctxPtr->base;
-	ctxPtr->base = newBlock - ctxPtr->dictLimit;
-	ctxPtr->end	= newBlock;
-	/* match referencing will resume from there */
-	ctxPtr->nextToUpdate = ctxPtr->dictLimit;
-}
-
-static int LZ4_compressHC_continue_generic(
-	LZ4_streamHC_t *LZ4_streamHCPtr,
-	const char *source,
-	char *dest,
-	int inputSize,
-	int maxOutputSize,
-	limitedOutput_directive limit)
-{
-	LZ4HC_CCtx_internal *ctxPtr = &LZ4_streamHCPtr->internal_donotuse;
-
-	/* auto - init if forgotten */
-	if (ctxPtr->base == NULL)
-		LZ4HC_init(ctxPtr, (const BYTE *) source);
-
-	/* Check overflow */
-	if ((size_t)(ctxPtr->end - ctxPtr->base) > 2 * GB) {
-		size_t dictSize = (size_t)(ctxPtr->end - ctxPtr->base)
-			- ctxPtr->dictLimit;
-		if (dictSize > 64 * KB)
-			dictSize = 64 * KB;
-		LZ4_loadDictHC(LZ4_streamHCPtr,
-			(const char *)(ctxPtr->end) - dictSize, (int)dictSize);
-	}
-
-	/* Check if blocks follow each other */
-	if ((const BYTE *)source != ctxPtr->end)
-		LZ4HC_setExternalDict(ctxPtr, (const BYTE *)source);
-
-	/* Check overlapping input/dictionary space */
-	{
-		const BYTE *sourceEnd = (const BYTE *) source + inputSize;
-		const BYTE * const dictBegin = ctxPtr->dictBase + ctxPtr->lowLimit;
-		const BYTE * const dictEnd = ctxPtr->dictBase + ctxPtr->dictLimit;
-
-		if ((sourceEnd > dictBegin)
-			&& ((const BYTE *)source < dictEnd)) {
-			if (sourceEnd > dictEnd)
-				sourceEnd = dictEnd;
-			ctxPtr->lowLimit = (U32)(sourceEnd - ctxPtr->dictBase);
-
-			if (ctxPtr->dictLimit - ctxPtr->lowLimit < 4)
-				ctxPtr->lowLimit = ctxPtr->dictLimit;
-		}
-	}
-
-	return LZ4HC_compress_generic(ctxPtr, source, dest,
-		inputSize, maxOutputSize, ctxPtr->compressionLevel, limit);
-}
-
-int LZ4_compress_HC_continue(
-	LZ4_streamHC_t *LZ4_streamHCPtr,
-	const char *source,
-	char *dest,
-	int inputSize,
-	int maxOutputSize)
-{
-	if (maxOutputSize < LZ4_compressBound(inputSize))
-		return LZ4_compressHC_continue_generic(LZ4_streamHCPtr,
-			source, dest, inputSize, maxOutputSize, limitedOutput);
-	else
-		return LZ4_compressHC_continue_generic(LZ4_streamHCPtr,
-			source, dest, inputSize, maxOutputSize, noLimit);
+	return __lz4_compress_HC_continue(streamHCPtr, src, dst, srcSize,
+					  maxDstSize);
 }
 EXPORT_SYMBOL(LZ4_compress_HC_continue);
 
-/* dictionary saving */
-
-int LZ4_saveDictHC(
-	LZ4_streamHC_t *LZ4_streamHCPtr,
-	char *safeBuffer,
-	int dictSize)
+int LZ4_saveDictHC(LZ4_streamHC_t *streamHCPtr, char *safeBuffer,
+		   int maxDictSize)
 {
-	LZ4HC_CCtx_internal *const streamPtr = &LZ4_streamHCPtr->internal_donotuse;
-	int const prefixSize = (int)(streamPtr->end
-		- (streamPtr->base + streamPtr->dictLimit));
-
-	if (dictSize > 64 * KB)
-		dictSize = 64 * KB;
-	if (dictSize < 4)
-		dictSize = 0;
-	if (dictSize > prefixSize)
-		dictSize = prefixSize;
-
-	memmove(safeBuffer, streamPtr->end - dictSize, dictSize);
-
-	{
-		U32 const endIndex = (U32)(streamPtr->end - streamPtr->base);
-
-		streamPtr->end = (const BYTE *)safeBuffer + dictSize;
-		streamPtr->base = streamPtr->end - endIndex;
-		streamPtr->dictLimit = endIndex - dictSize;
-		streamPtr->lowLimit = endIndex - dictSize;
-
-		if (streamPtr->nextToUpdate < streamPtr->dictLimit)
-			streamPtr->nextToUpdate = streamPtr->dictLimit;
-	}
-	return dictSize;
+	return __lz4_saveDictHC(streamHCPtr, safeBuffer, maxDictSize);
 }
 EXPORT_SYMBOL(LZ4_saveDictHC);
 

-- 
2.34.1

