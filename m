Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 271DC49A3BA;
	Fri, 25 Sep 2026 11:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790336107; cv=none; b=GuHy5KJAv3BSZ4dcp8ry1nEZ/X2AfN5bxS5dkF4bDUD0dhvMrPw03JkDd3vyHLgv9eH26rl1OV/8iAy/i0XlLAV0W3ZWSF/pE/pnKuNdCH5qR7m+lWMzWcDzqmRYdL2KRHB5ltQZIUftz+H9DZL44//7KGPzSKReY1QHdpP2RyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790336107; c=relaxed/simple;
	bh=CmtuIIY75aqcZAL/2G5cDR/9c++xNNY/4+DQvxyLuqk=;
	h=From:Date:Subject:MIME-Version:Message-Id:In-Reply-To:To:Cc:
	 Content-Type:References; b=NxrfND8mWdldPcNKq1ov+JpzHGMfeVhATZlD7DKiIrvlTeS/YxMrjdCCCAf5uv9OfBWJp7qeQFTdns0V5LtlMX+jFdY608oLSxoXdz8DxaMhNJpG+Enmtx7tiS5E1fs7mZ9mySU6Kic4zrB0/8vs0gKalT/rrkFdZbEuD3a0Et0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=dY9ASbmx; arc=none smtp.client-ip=210.118.77.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="dY9ASbmx"
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20260925113501euoutp02020fc21faf4fcccda6896643341e79e7~YjTLT-B771002710027euoutp02b;
	Fri, 25 Sep 2026 11:35:01 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20260925113501euoutp02020fc21faf4fcccda6896643341e79e7~YjTLT-B771002710027euoutp02b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1790336101;
	bh=MxbTukhxpbdLC+r2CZ8U+YSSKU6Ab7sJ+Z9oB6w3ujY=;
	h=From:Date:Subject:In-Reply-To:To:Cc:References:From;
	b=dY9ASbmxloG54MO+E4YPIX/tn4HxlNAIFbSUhuh1d5gMlTfwp08d/zplLarNM/aYB
	 uQvAtAPSD9eC24zUBaQAVA4GAVJX/0Fg+GvLsdp07e1t1Y/Rqe0MsNV0egIuRPXizT
	 U4SNQ3LEFtOio7coUoKv4qWk+Ps3+chhRIIJvbLk=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20260925113500eucas1p1b8c2b9936e936f393b295efb2ac61c51~YjTKlbytd2258322583eucas1p11;
	Fri, 25 Sep 2026 11:35:00 +0000 (GMT)
Received: from AMDC4942.eu.corp.samsungelectronics.net (unknown
	[106.210.136.40]) by eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260925113458eusmtip2181e56181e46480a72d5d7b265f721f8~YjTIfNuv62934029340eusmtip2c;
	Fri, 25 Sep 2026 11:34:58 +0000 (GMT)
From: Michal Wilczynski <m.wilczynski@samsung.com>
Date: Fri, 25 Sep 2026 13:27:35 +0200
Subject: [PATCH RFC 5/9] lib/lz4: switch the compressor to the vendored
 sources
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-Id: <20260925-lz4-vendor-upstream-v1-5-1c7ffbe21c4b@samsung.com>
In-Reply-To: <20260925-lz4-vendor-upstream-v1-0-1c7ffbe21c4b@samsung.com>
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
	<chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>,  Herbert Xu
	<herbert@gondor.apana.org.au>,  Phillip Lougher <phillip@squashfs.org.uk>,
	Sungguk <sungguk.na@samsung.com>,  Jaehoon Chung <jh80.chung@samsung.com>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, linux-erofs@lists.ozlabs.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-crypto@vger.kernel.org
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=36377;
	i=m.wilczynski@samsung.com; h=from:subject:message-id;
	bh=CmtuIIY75aqcZAL/2G5cDR/9c++xNNY/4+DQvxyLuqk=;
	b=owEBbQGS/pANAwAKASw99I2nQptuAcsmYgBqtlxUOMX5Gey48NdcmjeDO62D5voe6OLWyiXct
	g6W1fgI6SyJATMEAAEKAB0WIQR2xBTdTO5XfoUTSOYsPfSNp0KbbgUCarZcVAAKCRAsPfSNp0Kb
	bii1B/9C+k95aYN223Aa6hUpRdwKMcj5+S/jpv0+JiqSVDQk0OoY601ZzM9NEWMV/xId4+Gxtqf
	tTElLtumvlyZA9LERaDl/EfEBhjZibrUrbmBagn946vgfqSmb3hmATkLONj1H9BIc/r1IQJOKJu
	2xeBQMqwNCEKO95Wj/4WAk3VUClxDFsqJylPd2nd/kzsvajnhanNXhp5v3jXZR3wwUujMP5/7ZH
	XhZozbFcEicREfKRNVlpNIepjY5z5v6ciCeLc5Jh/MQkIB239C43w+nen1+yEnqnFcztnTpqiur
	NepgsPoaa7VeNX88YL248uaILqZHKUhCRZkboAf83II0sIxi
X-Developer-Key: i=m.wilczynski@samsung.com; a=openpgp;
	fpr=76C414DD4CEE577E851348E62C3DF48DA7429B6E
X-CMS-MailID: 20260925113500eucas1p1b8c2b9936e936f393b295efb2ac61c51
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260925113500eucas1p1b8c2b9936e936f393b295efb2ac61c51
X-EPHeader: CA
X-CMS-RootMailID: 20260925113500eucas1p1b8c2b9936e936f393b295efb2ac61c51
References: <20260925-lz4-vendor-upstream-v1-0-1c7ffbe21c4b@samsung.com>
	<CGME20260925113500eucas1p1b8c2b9936e936f393b295efb2ac61c51@eucas1p1.samsung.com>

Replace the forked compressor with thin entry points over the vendored
lz4.c.

LZ4_compress_default(), LZ4_compress_fast() and LZ4_compress_destSize()
keep the trailing wrkmem argument and forward to upstream's *_extState()
entry points. The rest are plain forwarders.

Compressed output is not quite bit-for-bit identical: it differs on a
small fraction of inputs by a byte or two, with no measurable change in
ratio. Both implementations decode each other's output, so nothing
already on disk changes meaning.

<linux/lz4.h> spelled out LZ4_stream_t's layout for the fork's benefit:
lz4defs.h included the public header and the fork read internal_donotuse
back out. The vendored compressor brings upstream's own definition, so
make the public type incomplete, repeating upstream's forward
declaration. Both headers then name the same type, which
lib/decompress_unlz4.c needs since it ends up including both.

LZ4_MEMORY_USAGE, LZ4_HASHLOG, LZ4_HASHTABLESIZE, LZ4_HASH_SIZE_U32,
LZ4_STREAMSIZE_U64 and LZ4_STREAMSIZE only existed to lay that structure
out, and go with it. LZ4_MEM_COMPRESS keeps its value, 16416, as a
plain number.

Callers now allocate LZ4_MEM_COMPRESS bytes instead of
sizeof(LZ4_stream_t). Every caller but zram already did; zram is
adjusted here.

Signed-off-by: Michal Wilczynski <m.wilczynski@samsung.com>
---
 drivers/block/zram/backend_lz4.c |   6 +-
 include/linux/lz4.h              |  47 +-
 lib/lz4/Makefile                 |  11 +-
 lib/lz4/lz4_compress.c           | 941 ++-------------------------------------
 4 files changed, 68 insertions(+), 937 deletions(-)

diff --git a/drivers/block/zram/backend_lz4.c b/drivers/block/zram/backend_lz4.c
index 1e4ad31d39a63f45b3bddd3d8a467d8d7d095beb..50265e3ce256490994cb6dae32a45da376e408e0 100644
--- a/drivers/block/zram/backend_lz4.c
+++ b/drivers/block/zram/backend_lz4.c
@@ -42,7 +42,7 @@ static int lz4_setup_params(struct zcomp_params *params)
 	if (!params->dict || !params->dict_sz)
 		return 0;
 
-	dict_stream = kzalloc_obj(*dict_stream);
+	dict_stream = kzalloc(LZ4_MEM_COMPRESS, GFP_KERNEL);
 	if (!dict_stream)
 		return -ENOMEM;
 
@@ -88,7 +88,7 @@ static int lz4_create(struct zcomp_params *params, struct zcomp_ctx *ctx)
 		if (!zctx->dstrm)
 			goto error;
 
-		zctx->cstrm = kzalloc_obj(*zctx->cstrm);
+		zctx->cstrm = kzalloc(LZ4_MEM_COMPRESS, GFP_KERNEL);
 		if (!zctx->cstrm)
 			goto error;
 	}
@@ -112,7 +112,7 @@ static int lz4_compress(struct zcomp_params *params, struct zcomp_ctx *ctx,
 					zctx->mem);
 	} else {
 		/* Cstrm needs to be reset */
-		memcpy(zctx->cstrm, params->drv_data, sizeof(*zctx->cstrm));
+		memcpy(zctx->cstrm, params->drv_data, LZ4_MEM_COMPRESS);
 		ret = LZ4_compress_fast_continue(zctx->cstrm, req->src,
 						 req->dst, req->src_len,
 						 req->dst_len, params->level);
diff --git a/include/linux/lz4.h b/include/linux/lz4.h
index ad6042a718b5428792b795db7a8d4ad44c24a985..e96353a67d617a4d734cecaf3764814df692428b 100644
--- a/include/linux/lz4.h
+++ b/include/linux/lz4.h
@@ -47,16 +47,6 @@
 /*-************************************************************************
  *	CONSTANTS
  **************************************************************************/
-/*
- * LZ4_MEMORY_USAGE :
- * Memory usage formula : N->2^N Bytes
- * (examples : 10 -> 1KB; 12 -> 4KB ; 16 -> 64KB; 20 -> 1MB; etc.)
- * Increasing memory usage improves compression ratio
- * Reduced memory usage can improve speed, due to cache effect
- * Default value is 14, for 16KB, which nicely fits into Intel x86 L1 cache
- */
-#define LZ4_MEMORY_USAGE 14
-
 #define LZ4_MAX_INPUT_SIZE	0x7E000000 /* 2 113 929 216 bytes */
 #define LZ4_COMPRESSBOUND(isize)	(\
 	(unsigned int)(isize) > (unsigned int)LZ4_MAX_INPUT_SIZE \
@@ -64,9 +54,6 @@
 	: (isize) + ((isize)/255) + 16)
 
 #define LZ4_ACCELERATION_DEFAULT 1
-#define LZ4_HASHLOG	 (LZ4_MEMORY_USAGE-2)
-#define LZ4_HASHTABLESIZE (1 << LZ4_MEMORY_USAGE)
-#define LZ4_HASH_SIZE_U32 (1 << LZ4_HASHLOG)
 
 #define LZ4HC_MIN_CLEVEL			3
 #define LZ4HC_DEFAULT_CLEVEL			9
@@ -82,9 +69,6 @@
 /*-************************************************************************
  *	STREAMING CONSTANTS AND STRUCTURES
  **************************************************************************/
-#define LZ4_STREAMSIZE_U64 ((1 << (LZ4_MEMORY_USAGE - 3)) + 4)
-#define LZ4_STREAMSIZE	(LZ4_STREAMSIZE_U64 * sizeof(unsigned long long))
-
 #define LZ4_STREAMHCSIZE        262192
 #define LZ4_STREAMHCSIZE_SIZET (262192 / sizeof(size_t))
 
@@ -93,20 +77,10 @@
 	sizeof(unsigned long long))
 
 /*
- * LZ4_stream_t - information structure to track an LZ4 stream.
+ * LZ4_stream_t - an LZ4 stream.  Incomplete: lib/lz4 owns the layout.
+ * Allocate LZ4_MEM_COMPRESS bytes and cast, do not sizeof().
  */
-typedef struct {
-	uint32_t hashTable[LZ4_HASH_SIZE_U32];
-	uint32_t currentOffset;
-	uint32_t initCheck;
-	const uint8_t *dictionary;
-	uint8_t *bufferStart;
-	uint32_t dictSize;
-} LZ4_stream_t_internal;
-typedef union {
-	unsigned long long table[LZ4_STREAMSIZE_U64];
-	LZ4_stream_t_internal internal_donotuse;
-} LZ4_stream_t;
+typedef union LZ4_stream_u LZ4_stream_t;
 
 /*
  * LZ4_streamHC_t - information structure to track an LZ4HC stream.
@@ -153,7 +127,12 @@ typedef union {
 /*-************************************************************************
  *	SIZE OF STATE
  **************************************************************************/
-#define LZ4_MEM_COMPRESS	LZ4_STREAMSIZE
+/*
+ * Working memory for the compressors.  It must be aligned to at least 8
+ * bytes; anything from kmalloc() or vmalloc() already is.  A misaligned
+ * buffer is rejected, and the stateless entry points cannot report that.
+ */
+#define LZ4_MEM_COMPRESS	16416
 #define LZ4HC_MEM_COMPRESS	LZ4_STREAMHCSIZE
 
 /*-************************************************************************
@@ -180,7 +159,7 @@ static inline int LZ4_compressBound(size_t isize)
  * @maxOutputSize: full or partial size of buffer 'dest'
  *	which must be already allocated
  * @wrkmem: address of the working memory.
- *	This requires 'workmem' of LZ4_MEM_COMPRESS.
+ *	This requires 'workmem' of LZ4_MEM_COMPRESS, aligned to 8 bytes.
  *
  * Compresses 'sourceSize' bytes from buffer 'source'
  * into already allocated 'dest' buffer of size 'maxOutputSize'.
@@ -206,7 +185,7 @@ int LZ4_compress_default(const char *source, char *dest, int inputSize,
  *	which must be already allocated
  * @acceleration: acceleration factor
  * @wrkmem: address of the working memory.
- *	This requires 'workmem' of LZ4_MEM_COMPRESS.
+ *	This requires 'workmem' of LZ4_MEM_COMPRESS, aligned to 8 bytes.
  *
  * Same as LZ4_compress_default(), but allows to select an "acceleration"
  * factor. The larger the acceleration value, the faster the algorithm,
@@ -230,7 +209,7 @@ int LZ4_compress_fast(const char *source, char *dest, int inputSize,
  *	from 'source' to fill 'dest'. New value is necessarily <= old value.
  * @targetDestSize: Size of buffer 'dest' which must be already allocated
  * @wrkmem: address of the working memory.
- *	This requires 'workmem' of LZ4_MEM_COMPRESS.
+ *	This requires 'workmem' of LZ4_MEM_COMPRESS, aligned to 8 bytes.
  *
  * Reverse the logic, by compressing as much data as possible
  * from 'source' buffer into already allocated buffer 'dest'
@@ -335,7 +314,7 @@ int LZ4_decompress_safe_partial(const char *source, char *dest,
  *	value between 1 and LZ4HC_MAX_CLEVEL will work.
  *	Values >LZ4HC_MAX_CLEVEL behave the same as 16.
  * @wrkmem: address of the working memory.
- *	This requires 'wrkmem' of size LZ4HC_MEM_COMPRESS.
+ *	This requires 'wrkmem' of size LZ4HC_MEM_COMPRESS, aligned to 8 bytes.
  *
  * Compress data from 'src' into 'dst', using the more powerful
  * but slower "HC" algorithm. Compression is guaranteed to succeed if
diff --git a/lib/lz4/Makefile b/lib/lz4/Makefile
index 5b42242afaa20deb165d8a2f0b1c0c842dfcdc39..e9d83cff4ea4efe1097f54caba72e268cecb04af 100644
--- a/lib/lz4/Makefile
+++ b/lib/lz4/Makefile
@@ -1,6 +1,11 @@
 # SPDX-License-Identifier: GPL-2.0-only
 ccflags-y += -O3
 
-obj-$(CONFIG_LZ4_COMPRESS) += lz4_compress.o
-obj-$(CONFIG_LZ4HC_COMPRESS) += lz4hc_compress.o
-obj-$(CONFIG_LZ4_DECOMPRESS) += lz4_decompress.o
+# upstream/ holds verbatim copies of the upstream LZ4 sources; do not edit
+# them.  The three entry point files include them.  freestanding/ supplies
+# the ISO C headers upstream includes that -nostdinc does not provide.
+ccflags-y += -I $(src)/freestanding
+
+obj-$(CONFIG_LZ4_COMPRESS)	+= lz4_compress.o
+obj-$(CONFIG_LZ4HC_COMPRESS)	+= lz4hc_compress.o
+obj-$(CONFIG_LZ4_DECOMPRESS)	+= lz4_decompress.o
diff --git a/lib/lz4/lz4_compress.c b/lib/lz4/lz4_compress.c
index 2a397bb2c661d9c2e4a7a67d5f50f06bfd42f1f2..19b877fc96d1dde6fd5ff832f79beca42d5b783b 100644
--- a/lib/lz4/lz4_compress.c
+++ b/lib/lz4/lz4_compress.c
@@ -1,937 +1,84 @@
+// SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
 /*
- * LZ4 - Fast LZ compression algorithm
  * Copyright (C) 2011 - 2016, Yann Collet.
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
+ * Copyright (C) 2016, Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
+ * Copyright (c) 2026 Samsung Electronics Co., Ltd.
+ * Author: Michal Wilczynski <m.wilczynski@samsung.com>
  *
- *	Changed for kernel usage by:
- *	Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
- */
-
-/*-************************************
- *	Dependencies
- **************************************/
-#include "lz4defs.h"
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/unaligned.h>
-
-static const int LZ4_minLength = (MFLIMIT + 1);
-static const int LZ4_64Klimit = ((64 * KB) + (MFLIMIT - 1));
-
-/*-******************************
- *	Compression functions
- ********************************/
-static FORCE_INLINE U32 LZ4_hash4(
-	U32 sequence,
-	tableType_t const tableType)
-{
-	if (tableType == byU16)
-		return ((sequence * 2654435761U)
-			>> ((MINMATCH * 8) - (LZ4_HASHLOG + 1)));
-	else
-		return ((sequence * 2654435761U)
-			>> ((MINMATCH * 8) - LZ4_HASHLOG));
-}
-
-static FORCE_INLINE U32 LZ4_hash5(
-	U64 sequence,
-	tableType_t const tableType)
-{
-	const U32 hashLog = (tableType == byU16)
-		? LZ4_HASHLOG + 1
-		: LZ4_HASHLOG;
-
-#if LZ4_LITTLE_ENDIAN
-	static const U64 prime5bytes = 889523592379ULL;
-
-	return (U32)(((sequence << 24) * prime5bytes) >> (64 - hashLog));
-#else
-	static const U64 prime8bytes = 11400714785074694791ULL;
-
-	return (U32)(((sequence >> 24) * prime8bytes) >> (64 - hashLog));
-#endif
-}
-
-static FORCE_INLINE U32 LZ4_hashPosition(
-	const void *p,
-	tableType_t const tableType)
-{
-#if LZ4_ARCH64
-	if (tableType == byU32)
-		return LZ4_hash5(LZ4_read_ARCH(p), tableType);
-#endif
-
-	return LZ4_hash4(LZ4_read32(p), tableType);
-}
-
-static void LZ4_putPositionOnHash(
-	const BYTE *p,
-	U32 h,
-	void *tableBase,
-	tableType_t const tableType,
-	const BYTE *srcBase)
-{
-	switch (tableType) {
-	case byPtr:
-	{
-		const BYTE **hashTable = (const BYTE **)tableBase;
-
-		hashTable[h] = p;
-		return;
-	}
-	case byU32:
-	{
-		U32 *hashTable = (U32 *) tableBase;
-
-		hashTable[h] = (U32)(p - srcBase);
-		return;
-	}
-	case byU16:
-	{
-		U16 *hashTable = (U16 *) tableBase;
-
-		hashTable[h] = (U16)(p - srcBase);
-		return;
-	}
-	}
-}
-
-static FORCE_INLINE void LZ4_putPosition(
-	const BYTE *p,
-	void *tableBase,
-	tableType_t tableType,
-	const BYTE *srcBase)
-{
-	U32 const h = LZ4_hashPosition(p, tableType);
-
-	LZ4_putPositionOnHash(p, h, tableBase, tableType, srcBase);
-}
-
-static const BYTE *LZ4_getPositionOnHash(
-	U32 h,
-	void *tableBase,
-	tableType_t tableType,
-	const BYTE *srcBase)
-{
-	if (tableType == byPtr) {
-		const BYTE **hashTable = (const BYTE **) tableBase;
-
-		return hashTable[h];
-	}
-
-	if (tableType == byU32) {
-		const U32 * const hashTable = (U32 *) tableBase;
-
-		return hashTable[h] + srcBase;
-	}
-
-	{
-		/* default, to ensure a return */
-		const U16 * const hashTable = (U16 *) tableBase;
-
-		return hashTable[h] + srcBase;
-	}
-}
-
-static FORCE_INLINE const BYTE *LZ4_getPosition(
-	const BYTE *p,
-	void *tableBase,
-	tableType_t tableType,
-	const BYTE *srcBase)
-{
-	U32 const h = LZ4_hashPosition(p, tableType);
-
-	return LZ4_getPositionOnHash(h, tableBase, tableType, srcBase);
-}
-
-
-/*
- * LZ4_compress_generic() :
- * inlined, to ensure branches are decided at compilation time
+ * LZ4 compressor -- kernel entry points
+ *
+ * The compressor is upstream's, in the verbatim lz4.c included below.  The
+ * kernel has no heap at these call sites, so LZ4_compress_default(),
+ * LZ4_compress_fast() and LZ4_compress_destSize() take a trailing wrkmem
+ * argument and forward to upstream's *_extState() entry points.
  */
-static FORCE_INLINE int LZ4_compress_generic(
-	LZ4_stream_t_internal * const dictPtr,
-	const char * const source,
-	char * const dest,
-	const int inputSize,
-	const int maxOutputSize,
-	const limitedOutput_directive outputLimited,
-	const tableType_t tableType,
-	const dict_directive dict,
-	const dictIssue_directive dictIssue,
-	const U32 acceleration)
-{
-	const BYTE *ip = (const BYTE *) source;
-	const BYTE *base;
-	const BYTE *lowLimit;
-	const BYTE * const lowRefLimit = ip - dictPtr->dictSize;
-	const BYTE * const dictionary = dictPtr->dictionary;
-	const BYTE * const dictEnd = dictionary + dictPtr->dictSize;
-	const size_t dictDelta = dictEnd - (const BYTE *)source;
-	const BYTE *anchor = (const BYTE *) source;
-	const BYTE * const iend = ip + inputSize;
-	const BYTE * const mflimit = iend - MFLIMIT;
-	const BYTE * const matchlimit = iend - LASTLITERALS;
-
-	BYTE *op = (BYTE *) dest;
-	BYTE * const olimit = op + maxOutputSize;
-
-	U32 forwardH;
-	size_t refDelta = 0;
-
-	/* Init conditions */
-	if ((U32)inputSize > (U32)LZ4_MAX_INPUT_SIZE) {
-		/* Unsupported inputSize, too large (or negative) */
-		return 0;
-	}
-
-	switch (dict) {
-	case noDict:
-	default:
-		base = (const BYTE *)source;
-		lowLimit = (const BYTE *)source;
-		break;
-	case withPrefix64k:
-		base = (const BYTE *)source - dictPtr->currentOffset;
-		lowLimit = (const BYTE *)source - dictPtr->dictSize;
-		break;
-	case usingExtDict:
-		base = (const BYTE *)source - dictPtr->currentOffset;
-		lowLimit = (const BYTE *)source;
-		break;
-	}
-
-	if ((tableType == byU16)
-		&& (inputSize >= LZ4_64Klimit)) {
-		/* Size too large (not within 64K limit) */
-		return 0;
-	}
-
-	if (inputSize < LZ4_minLength) {
-		/* Input too small, no compression (all literals) */
-		goto _last_literals;
-	}
-
-	/* First Byte */
-	LZ4_putPosition(ip, dictPtr->hashTable, tableType, base);
-	ip++;
-	forwardH = LZ4_hashPosition(ip, tableType);
-
-	/* Main Loop */
-	for ( ; ; ) {
-		const BYTE *match;
-		BYTE *token;
-
-		/* Find a match */
-		{
-			const BYTE *forwardIp = ip;
-			unsigned int step = 1;
-			unsigned int searchMatchNb = acceleration << LZ4_SKIPTRIGGER;
-
-			do {
-				U32 const h = forwardH;
-
-				ip = forwardIp;
-				forwardIp += step;
-				step = (searchMatchNb++ >> LZ4_SKIPTRIGGER);
-
-				if (unlikely(forwardIp > mflimit))
-					goto _last_literals;
-
-				match = LZ4_getPositionOnHash(h,
-					dictPtr->hashTable,
-					tableType, base);
-
-				if (dict == usingExtDict) {
-					if (match < (const BYTE *)source) {
-						refDelta = dictDelta;
-						lowLimit = dictionary;
-					} else {
-						refDelta = 0;
-						lowLimit = (const BYTE *)source;
-				}	 }
-
-				forwardH = LZ4_hashPosition(forwardIp,
-					tableType);
-
-				LZ4_putPositionOnHash(ip, h, dictPtr->hashTable,
-					tableType, base);
-			} while (((dictIssue == dictSmall)
-					? (match < lowRefLimit)
-					: 0)
-				|| ((tableType == byU16)
-					? 0
-					: (match + MAX_DISTANCE < ip))
-				|| (LZ4_read32(match + refDelta)
-					!= LZ4_read32(ip)));
-		}
-
-		/* Catch up */
-		while (((ip > anchor) & (match + refDelta > lowLimit))
-				&& (unlikely(ip[-1] == match[refDelta - 1]))) {
-			ip--;
-			match--;
-		}
-
-		/* Encode Literals */
-		{
-			unsigned const int litLength = (unsigned int)(ip - anchor);
-
-			token = op++;
-
-			if ((outputLimited) &&
-				/* Check output buffer overflow */
-				(unlikely(op + litLength +
-					(2 + 1 + LASTLITERALS) +
-					(litLength / 255) > olimit)))
-				return 0;
-
-			if (litLength >= RUN_MASK) {
-				int len = (int)litLength - RUN_MASK;
-
-				*token = (RUN_MASK << ML_BITS);
-
-				for (; len >= 255; len -= 255)
-					*op++ = 255;
-				*op++ = (BYTE)len;
-			} else
-				*token = (BYTE)(litLength << ML_BITS);
-
-			/* Copy Literals */
-			LZ4_wildCopy(op, anchor, op + litLength);
-			op += litLength;
-		}
-
-_next_match:
-		/* Encode Offset */
-		LZ4_writeLE16(op, (U16)(ip - match));
-		op += 2;
-
-		/* Encode MatchLength */
-		{
-			unsigned int matchCode;
-
-			if ((dict == usingExtDict)
-				&& (lowLimit == dictionary)) {
-				const BYTE *limit;
-
-				match += refDelta;
-				limit = ip + (dictEnd - match);
-
-				if (limit > matchlimit)
-					limit = matchlimit;
-
-				matchCode = LZ4_count(ip + MINMATCH,
-					match + MINMATCH, limit);
-
-				ip += MINMATCH + matchCode;
-
-				if (ip == limit) {
-					unsigned const int more = LZ4_count(ip,
-						(const BYTE *)source,
-						matchlimit);
-
-					matchCode += more;
-					ip += more;
-				}
-			} else {
-				matchCode = LZ4_count(ip + MINMATCH,
-					match + MINMATCH, matchlimit);
-				ip += MINMATCH + matchCode;
-			}
-
-			if (outputLimited &&
-				/* Check output buffer overflow */
-				(unlikely(op +
-					(1 + LASTLITERALS) +
-					(matchCode >> 8) > olimit)))
-				return 0;
-
-			if (matchCode >= ML_MASK) {
-				*token += ML_MASK;
-				matchCode -= ML_MASK;
-				LZ4_write32(op, 0xFFFFFFFF);
-
-				while (matchCode >= 4 * 255) {
-					op += 4;
-					LZ4_write32(op, 0xFFFFFFFF);
-					matchCode -= 4 * 255;
-				}
-
-				op += matchCode / 255;
-				*op++ = (BYTE)(matchCode % 255);
-			} else
-				*token += (BYTE)(matchCode);
-		}
 
-		anchor = ip;
+#include "lz4_deps.h"
+#include "upstream/lz4.c"
 
-		/* Test end of chunk */
-		if (ip > mflimit)
-			break;
+/* Upstream's short names for these clash with <linux/minmax.h>. */
+#undef MIN
+#undef MAX
+#undef KB
+#undef MB
+#undef GB
 
-		/* Fill table */
-		LZ4_putPosition(ip - 2, dictPtr->hashTable, tableType, base);
-
-		/* Test next position */
-		match = LZ4_getPosition(ip, dictPtr->hashTable,
-			tableType, base);
-
-		if (dict == usingExtDict) {
-			if (match < (const BYTE *)source) {
-				refDelta = dictDelta;
-				lowLimit = dictionary;
-			} else {
-				refDelta = 0;
-				lowLimit = (const BYTE *)source;
-			}
-		}
-
-		LZ4_putPosition(ip, dictPtr->hashTable, tableType, base);
-
-		if (((dictIssue == dictSmall) ? (match >= lowRefLimit) : 1)
-			&& (match + MAX_DISTANCE >= ip)
-			&& (LZ4_read32(match + refDelta) == LZ4_read32(ip))) {
-			token = op++;
-			*token = 0;
-			goto _next_match;
-		}
-
-		/* Prepare next loop */
-		forwardH = LZ4_hashPosition(++ip, tableType);
-	}
-
-_last_literals:
-	/* Encode Last Literals */
-	{
-		size_t const lastRun = (size_t)(iend - anchor);
-
-		if ((outputLimited) &&
-			/* Check output buffer overflow */
-			((op - (BYTE *)dest) + lastRun + 1 +
-			((lastRun + 255 - RUN_MASK) / 255) > (U32)maxOutputSize))
-			return 0;
-
-		if (lastRun >= RUN_MASK) {
-			size_t accumulator = lastRun - RUN_MASK;
-			*op++ = RUN_MASK << ML_BITS;
-			for (; accumulator >= 255; accumulator -= 255)
-				*op++ = 255;
-			*op++ = (BYTE) accumulator;
-		} else {
-			*op++ = (BYTE)(lastRun << ML_BITS);
-		}
-
-		LZ4_memcpy(op, anchor, lastRun);
-
-		op += lastRun;
-	}
-
-	/* End */
-	return (int) (((char *)op) - dest);
-}
-
-static int LZ4_compress_fast_extState(
-	void *state,
-	const char *source,
-	char *dest,
-	int inputSize,
-	int maxOutputSize,
-	int acceleration)
-{
-	LZ4_stream_t_internal *ctx = &((LZ4_stream_t *)state)->internal_donotuse;
-#if LZ4_ARCH64
-	const tableType_t tableType = byU32;
-#else
-	const tableType_t tableType = byPtr;
-#endif
-
-	LZ4_resetStream((LZ4_stream_t *)state);
-
-	if (acceleration < 1)
-		acceleration = LZ4_ACCELERATION_DEFAULT;
+#include "lz4_kernel_api.h"
+#include <linux/export.h>
+#include <linux/module.h>
 
-	if (maxOutputSize >= LZ4_COMPRESSBOUND(inputSize)) {
-		if (inputSize < LZ4_64Klimit)
-			return LZ4_compress_generic(ctx, source,
-				dest, inputSize, 0,
-				noLimit, byU16, noDict,
-				noDictIssue, acceleration);
-		else
-			return LZ4_compress_generic(ctx, source,
-				dest, inputSize, 0,
-				noLimit, tableType, noDict,
-				noDictIssue, acceleration);
-	} else {
-		if (inputSize < LZ4_64Klimit)
-			return LZ4_compress_generic(ctx, source,
-				dest, inputSize,
-				maxOutputSize, limitedOutput, byU16, noDict,
-				noDictIssue, acceleration);
-		else
-			return LZ4_compress_generic(ctx, source,
-				dest, inputSize,
-				maxOutputSize, limitedOutput, tableType, noDict,
-				noDictIssue, acceleration);
-	}
-}
+/* Catch any divergence from upstream's layout at build time. */
+static_assert(sizeof(LZ4_stream_t) == LZ4_STREAM_MINSIZE);
+static_assert(LZ4_STREAM_MINSIZE == 16416); /* LZ4_MEM_COMPRESS */
 
 int LZ4_compress_fast(const char *source, char *dest, int inputSize,
-	int maxOutputSize, int acceleration, void *wrkmem)
+		      int maxOutputSize, int acceleration, void *wrkmem)
 {
 	return LZ4_compress_fast_extState(wrkmem, source, dest, inputSize,
-		maxOutputSize, acceleration);
+					  maxOutputSize, acceleration);
 }
 EXPORT_SYMBOL(LZ4_compress_fast);
 
 int LZ4_compress_default(const char *source, char *dest, int inputSize,
-	int maxOutputSize, void *wrkmem)
+			 int maxOutputSize, void *wrkmem)
 {
-	return LZ4_compress_fast(source, dest, inputSize,
-		maxOutputSize, LZ4_ACCELERATION_DEFAULT, wrkmem);
+	return LZ4_compress_fast(source, dest, inputSize, maxOutputSize,
+				 LZ4_ACCELERATION_DEFAULT, wrkmem);
 }
 EXPORT_SYMBOL(LZ4_compress_default);
 
-/*-******************************
- *	*_destSize() variant
- ********************************/
-static int LZ4_compress_destSize_generic(
-	LZ4_stream_t_internal * const ctx,
-	const char * const src,
-	char * const dst,
-	int * const srcSizePtr,
-	const int targetDstSize,
-	const tableType_t tableType)
+int LZ4_compress_destSize(const char *source, char *dest, int *sourceSizePtr,
+			  int targetDestSize, void *wrkmem)
 {
-	const BYTE *ip = (const BYTE *) src;
-	const BYTE *base = (const BYTE *) src;
-	const BYTE *lowLimit = (const BYTE *) src;
-	const BYTE *anchor = ip;
-	const BYTE * const iend = ip + *srcSizePtr;
-	const BYTE * const mflimit = iend - MFLIMIT;
-	const BYTE * const matchlimit = iend - LASTLITERALS;
-
-	BYTE *op = (BYTE *) dst;
-	BYTE * const oend = op + targetDstSize;
-	BYTE * const oMaxLit = op + targetDstSize - 2 /* offset */
-		- 8 /* because 8 + MINMATCH == MFLIMIT */ - 1 /* token */;
-	BYTE * const oMaxMatch = op + targetDstSize
-		- (LASTLITERALS + 1 /* token */);
-	BYTE * const oMaxSeq = oMaxLit - 1 /* token */;
-
-	U32 forwardH;
-
-	/* Init conditions */
-	/* Impossible to store anything */
-	if (targetDstSize < 1)
-		return 0;
-	/* Unsupported input size, too large (or negative) */
-	if ((U32)*srcSizePtr > (U32)LZ4_MAX_INPUT_SIZE)
-		return 0;
-	/* Size too large (not within 64K limit) */
-	if ((tableType == byU16) && (*srcSizePtr >= LZ4_64Klimit))
-		return 0;
-	/* Input too small, no compression (all literals) */
-	if (*srcSizePtr < LZ4_minLength)
-		goto _last_literals;
-
-	/* First Byte */
-	*srcSizePtr = 0;
-	LZ4_putPosition(ip, ctx->hashTable, tableType, base);
-	ip++; forwardH = LZ4_hashPosition(ip, tableType);
-
-	/* Main Loop */
-	for ( ; ; ) {
-		const BYTE *match;
-		BYTE *token;
-
-		/* Find a match */
-		{
-			const BYTE *forwardIp = ip;
-			unsigned int step = 1;
-			unsigned int searchMatchNb = 1 << LZ4_SKIPTRIGGER;
-
-			do {
-				U32 h = forwardH;
-
-				ip = forwardIp;
-				forwardIp += step;
-				step = (searchMatchNb++ >> LZ4_SKIPTRIGGER);
-
-				if (unlikely(forwardIp > mflimit))
-					goto _last_literals;
-
-				match = LZ4_getPositionOnHash(h, ctx->hashTable,
-					tableType, base);
-				forwardH = LZ4_hashPosition(forwardIp,
-					tableType);
-				LZ4_putPositionOnHash(ip, h,
-					ctx->hashTable, tableType,
-					base);
-
-			} while (((tableType == byU16)
-				? 0
-				: (match + MAX_DISTANCE < ip))
-				|| (LZ4_read32(match) != LZ4_read32(ip)));
-		}
-
-		/* Catch up */
-		while ((ip > anchor)
-			&& (match > lowLimit)
-			&& (unlikely(ip[-1] == match[-1]))) {
-			ip--;
-			match--;
-		}
-
-		/* Encode Literal length */
-		{
-			unsigned int litLength = (unsigned int)(ip - anchor);
-
-			token = op++;
-			if (op + ((litLength + 240) / 255)
-				+ litLength > oMaxLit) {
-				/* Not enough space for a last match */
-				op--;
-				goto _last_literals;
-			}
-			if (litLength >= RUN_MASK) {
-				unsigned int len = litLength - RUN_MASK;
-				*token = (RUN_MASK<<ML_BITS);
-				for (; len >= 255; len -= 255)
-					*op++ = 255;
-				*op++ = (BYTE)len;
-			} else
-				*token = (BYTE)(litLength << ML_BITS);
-
-			/* Copy Literals */
-			LZ4_wildCopy(op, anchor, op + litLength);
-			op += litLength;
-		}
-
-_next_match:
-		/* Encode Offset */
-		LZ4_writeLE16(op, (U16)(ip - match)); op += 2;
-
-		/* Encode MatchLength */
-		{
-			size_t matchLength = LZ4_count(ip + MINMATCH,
-			match + MINMATCH, matchlimit);
-
-			if (op + ((matchLength + 240)/255) > oMaxMatch) {
-				/* Match description too long : reduce it */
-				matchLength = (15 - 1) + (oMaxMatch - op) * 255;
-			}
-			ip += MINMATCH + matchLength;
-
-			if (matchLength >= ML_MASK) {
-				*token += ML_MASK;
-				matchLength -= ML_MASK;
-				while (matchLength >= 255) {
-					matchLength -= 255;
-					*op++ = 255;
-				}
-				*op++ = (BYTE)matchLength;
-			} else
-				*token += (BYTE)(matchLength);
-		}
-
-		anchor = ip;
-
-		/* Test end of block */
-		if (ip > mflimit)
-			break;
-		if (op > oMaxSeq)
-			break;
-
-		/* Fill table */
-		LZ4_putPosition(ip - 2, ctx->hashTable, tableType, base);
-
-		/* Test next position */
-		match = LZ4_getPosition(ip, ctx->hashTable, tableType, base);
-		LZ4_putPosition(ip, ctx->hashTable, tableType, base);
-
-		if ((match + MAX_DISTANCE >= ip)
-			&& (LZ4_read32(match) == LZ4_read32(ip))) {
-			token = op++; *token = 0;
-			goto _next_match;
-		}
-
-		/* Prepare next loop */
-		forwardH = LZ4_hashPosition(++ip, tableType);
-	}
-
-_last_literals:
-	/* Encode Last Literals */
-	{
-		size_t lastRunSize = (size_t)(iend - anchor);
-
-		if (op + 1 /* token */
-			+ ((lastRunSize + 240) / 255) /* litLength */
-			+ lastRunSize /* literals */ > oend) {
-			/* adapt lastRunSize to fill 'dst' */
-			lastRunSize	= (oend - op) - 1;
-			lastRunSize -= (lastRunSize + 240) / 255;
-		}
-		ip = anchor + lastRunSize;
-
-		if (lastRunSize >= RUN_MASK) {
-			size_t accumulator = lastRunSize - RUN_MASK;
-
-			*op++ = RUN_MASK << ML_BITS;
-			for (; accumulator >= 255; accumulator -= 255)
-				*op++ = 255;
-			*op++ = (BYTE) accumulator;
-		} else {
-			*op++ = (BYTE)(lastRunSize<<ML_BITS);
-		}
-		LZ4_memcpy(op, anchor, lastRunSize);
-		op += lastRunSize;
-	}
-
-	/* End */
-	*srcSizePtr = (int) (((const char *)ip) - src);
-	return (int) (((char *)op) - dst);
-}
-
-static int LZ4_compress_destSize_extState(
-	LZ4_stream_t *state,
-	const char *src,
-	char *dst,
-	int *srcSizePtr,
-	int targetDstSize)
-{
-#if LZ4_ARCH64
-	const tableType_t tableType = byU32;
-#else
-	const tableType_t tableType = byPtr;
-#endif
-
-	LZ4_resetStream(state);
-
-	if (targetDstSize >= LZ4_COMPRESSBOUND(*srcSizePtr)) {
-		/* compression success is guaranteed */
-		return LZ4_compress_fast_extState(
-			state, src, dst, *srcSizePtr,
-			targetDstSize, 1);
-	} else {
-		if (*srcSizePtr < LZ4_64Klimit)
-			return LZ4_compress_destSize_generic(
-				&state->internal_donotuse,
-				src, dst, srcSizePtr,
-				targetDstSize, byU16);
-		else
-			return LZ4_compress_destSize_generic(
-				&state->internal_donotuse,
-				src, dst, srcSizePtr,
-				targetDstSize, tableType);
-	}
-}
-
-
-int LZ4_compress_destSize(
-	const char *src,
-	char *dst,
-	int *srcSizePtr,
-	int targetDstSize,
-	void *wrkmem)
-{
-	return LZ4_compress_destSize_extState(wrkmem, src, dst, srcSizePtr,
-		targetDstSize);
+	return LZ4_compress_destSize_extState(wrkmem, source, dest,
+					      sourceSizePtr, targetDestSize,
+					      LZ4_ACCELERATION_DEFAULT);
 }
 EXPORT_SYMBOL(LZ4_compress_destSize);
 
-/*-******************************
- *	Streaming functions
- ********************************/
 void LZ4_resetStream(LZ4_stream_t *LZ4_stream)
 {
-	memset(LZ4_stream, 0, sizeof(LZ4_stream_t));
+	__lz4_resetStream(LZ4_stream);
 }
 
-int LZ4_loadDict(LZ4_stream_t *LZ4_dict,
-	const char *dictionary, int dictSize)
+int LZ4_loadDict(LZ4_stream_t *streamPtr, const char *dictionary, int dictSize)
 {
-	LZ4_stream_t_internal *dict = &LZ4_dict->internal_donotuse;
-	const BYTE *p = (const BYTE *)dictionary;
-	const BYTE * const dictEnd = p + dictSize;
-	const BYTE *base;
-
-	if ((dict->initCheck)
-		|| (dict->currentOffset > 1 * GB)) {
-		/* Uninitialized structure, or reuse overflow */
-		LZ4_resetStream(LZ4_dict);
-	}
-
-	if (dictSize < (int)HASH_UNIT) {
-		dict->dictionary = NULL;
-		dict->dictSize = 0;
-		return 0;
-	}
-
-	if ((dictEnd - p) > 64 * KB)
-		p = dictEnd - 64 * KB;
-	dict->currentOffset += 64 * KB;
-	base = p - dict->currentOffset;
-	dict->dictionary = p;
-	dict->dictSize = (U32)(dictEnd - p);
-	dict->currentOffset += dict->dictSize;
-
-	while (p <= dictEnd - HASH_UNIT) {
-		LZ4_putPosition(p, dict->hashTable, byU32, base);
-		p += 3;
-	}
-
-	return dict->dictSize;
+	return __lz4_loadDict(streamPtr, dictionary, dictSize);
 }
 EXPORT_SYMBOL(LZ4_loadDict);
 
-static void LZ4_renormDictT(LZ4_stream_t_internal *LZ4_dict,
-	const BYTE *src)
-{
-	if ((LZ4_dict->currentOffset > 0x80000000) ||
-		((uptrval)LZ4_dict->currentOffset > (uptrval)src)) {
-		/* address space overflow */
-		/* rescale hash table */
-		U32 const delta = LZ4_dict->currentOffset - 64 * KB;
-		const BYTE *dictEnd = LZ4_dict->dictionary + LZ4_dict->dictSize;
-		int i;
-
-		for (i = 0; i < LZ4_HASH_SIZE_U32; i++) {
-			if (LZ4_dict->hashTable[i] < delta)
-				LZ4_dict->hashTable[i] = 0;
-			else
-				LZ4_dict->hashTable[i] -= delta;
-		}
-		LZ4_dict->currentOffset = 64 * KB;
-		if (LZ4_dict->dictSize > 64 * KB)
-			LZ4_dict->dictSize = 64 * KB;
-		LZ4_dict->dictionary = dictEnd - LZ4_dict->dictSize;
-	}
-}
-
-int LZ4_saveDict(LZ4_stream_t *LZ4_dict, char *safeBuffer, int dictSize)
+int LZ4_saveDict(LZ4_stream_t *streamPtr, char *safeBuffer, int dictSize)
 {
-	LZ4_stream_t_internal * const dict = &LZ4_dict->internal_donotuse;
-	const BYTE * const previousDictEnd = dict->dictionary + dict->dictSize;
-
-	if ((U32)dictSize > 64 * KB) {
-		/* useless to define a dictionary > 64 * KB */
-		dictSize = 64 * KB;
-	}
-	if ((U32)dictSize > dict->dictSize)
-		dictSize = dict->dictSize;
-
-	memmove(safeBuffer, previousDictEnd - dictSize, dictSize);
-
-	dict->dictionary = (const BYTE *)safeBuffer;
-	dict->dictSize = (U32)dictSize;
-
-	return dictSize;
+	return __lz4_saveDict(streamPtr, safeBuffer, dictSize);
 }
 EXPORT_SYMBOL(LZ4_saveDict);
 
-int LZ4_compress_fast_continue(LZ4_stream_t *LZ4_stream, const char *source,
-	char *dest, int inputSize, int maxOutputSize, int acceleration)
+int LZ4_compress_fast_continue(LZ4_stream_t *streamPtr, const char *src,
+			       char *dst, int srcSize, int maxDstSize,
+			       int acceleration)
 {
-	LZ4_stream_t_internal *streamPtr = &LZ4_stream->internal_donotuse;
-	const BYTE * const dictEnd = streamPtr->dictionary
-		+ streamPtr->dictSize;
-
-	const BYTE *smallest = (const BYTE *) source;
-
-	if (streamPtr->initCheck) {
-		/* Uninitialized structure detected */
-		return 0;
-	}
-
-	if ((streamPtr->dictSize > 0) && (smallest > dictEnd))
-		smallest = dictEnd;
-
-	LZ4_renormDictT(streamPtr, smallest);
-
-	if (acceleration < 1)
-		acceleration = LZ4_ACCELERATION_DEFAULT;
-
-	/* Check overlapping input/dictionary space */
-	{
-		const BYTE *sourceEnd = (const BYTE *) source + inputSize;
-
-		if ((sourceEnd > streamPtr->dictionary)
-			&& (sourceEnd < dictEnd)) {
-			streamPtr->dictSize = (U32)(dictEnd - sourceEnd);
-			if (streamPtr->dictSize > 64 * KB)
-				streamPtr->dictSize = 64 * KB;
-			if (streamPtr->dictSize < 4)
-				streamPtr->dictSize = 0;
-			streamPtr->dictionary = dictEnd - streamPtr->dictSize;
-		}
-	}
-
-	/* prefix mode : source data follows dictionary */
-	if (dictEnd == (const BYTE *)source) {
-		int result;
-
-		if ((streamPtr->dictSize < 64 * KB) &&
-			(streamPtr->dictSize < streamPtr->currentOffset)) {
-			result = LZ4_compress_generic(
-				streamPtr, source, dest, inputSize,
-				maxOutputSize, limitedOutput, byU32,
-				withPrefix64k, dictSmall, acceleration);
-		} else {
-			result = LZ4_compress_generic(
-				streamPtr, source, dest, inputSize,
-				maxOutputSize, limitedOutput, byU32,
-				withPrefix64k, noDictIssue, acceleration);
-		}
-		streamPtr->dictSize += (U32)inputSize;
-		streamPtr->currentOffset += (U32)inputSize;
-		return result;
-	}
-
-	/* external dictionary mode */
-	{
-		int result;
-
-		if ((streamPtr->dictSize < 64 * KB) &&
-			(streamPtr->dictSize < streamPtr->currentOffset)) {
-			result = LZ4_compress_generic(
-				streamPtr, source, dest, inputSize,
-				maxOutputSize, limitedOutput, byU32,
-				usingExtDict, dictSmall, acceleration);
-		} else {
-			result = LZ4_compress_generic(
-				streamPtr, source, dest, inputSize,
-				maxOutputSize, limitedOutput, byU32,
-				usingExtDict, noDictIssue, acceleration);
-		}
-		streamPtr->dictionary = (const BYTE *)source;
-		streamPtr->dictSize = (U32)inputSize;
-		streamPtr->currentOffset += (U32)inputSize;
-		return result;
-	}
+	return __lz4_compress_fast_continue(streamPtr, src, dst, srcSize,
+					    maxDstSize, acceleration);
 }
 EXPORT_SYMBOL(LZ4_compress_fast_continue);
 

-- 
2.34.1

