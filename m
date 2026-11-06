Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=210.118.77.12
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793976194;
	b=cvPvpT/ghraYBD5mjWn6skbMsnQ6Ou2csP/Q7hU3bFs2+2o/JJ9pV1Rh12CPd7bECIyh
	 ZFYrW0CeHmnCj0IYWmzi7BFNOabkJw9b/wdzgHNg+yQTtTsx2MO2qnogl0b6HDdcuC4yx
	 7jVRCwsl69aLgJ6wmPvJkmOJlgprGRyNfETNAlsYo7wFFfQRMFGP92UjID+W/Uc3trrpg
	 rGA+MZiMz5OzgmilUFtSO9aPSFxpJmWDPoMOMyDkn8PB3z6i26lh2amSvVi/2M2iX/rls
	 BuYqc2QllwiGNT+7Au6uAZE6b7RNTUckwLUNrC6XqgFSYFYNsl/QBt0WbqEpICgzftA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793976194;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 From:Date:Subject:MIME-Version:Content-Transfer-Encoding:Message-Id:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-CMS-MailID:X-Msg-Generator:Content-Type:X-RootMTR:X-EPHeader:
	 X-CMS-RootMailID:References;
	bh=BLfypDtaSVRGzMJ77DsQ7btrvvHihrtVX+aya00Qn8s=;
	b=ta9km6TlEZ7v1wTO9isddReS5YbHUcy0v3pAa25B67PECaT14EbTREMaDB03alNHROU/
	 /c4v3JTkYWE6FIuDEZgSWt3aSKBUn4LZkeAQ2rlecXKKbJ6ocVXY9XfSOK+7BtGDIfx8E
	 jujtT+j8HM6UMG9FGJJRm2rlYgINxquGIVU5J0yaPEOweFIAsqzuQBwnmpilNr42E0ObH
	 fCbWkPv9Y/87y0V+63L1jOM5EZqc7BZSWC6h1BrZy5Gp/ItQ0q8cI/YYpAekTVa02YCfL
	 UAj/14B8rToQbcUJmDU6EyXF/JNzWBS0zOjJ3Gq/zhswhi9SgL6nCeSQwtwsP54plkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=ugcwSvPE;
	arc=none smtp.remote-ip=210.118.77.12
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8286C606EE88;
	Fri,  6 Nov 2026 14:43:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8286C606EE88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=ugcwSvPE
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20261106144311euoutp02544cd478100227f599095d2db2e3b3c8~le9dMTMVn1135511355euoutp02K;
	Fri,  6 Nov 2026 14:43:11 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20261106144311euoutp02544cd478100227f599095d2db2e3b3c8~le9dMTMVn1135511355euoutp02K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1793976191;
	bh=BLfypDtaSVRGzMJ77DsQ7btrvvHihrtVX+aya00Qn8s=;
	h=From:Date:Subject:In-Reply-To:To:Cc:References:From;
	b=ugcwSvPEdWT5/Brk4KFmEOAYgPz7y/IkYyg+/serI9GclW5yanfMDvAb2LOLFDU5A
	 x8MRZeGbNw3+YTLj2EvJe4+6rWY/mqy7jBRceC4QSa9RatslYOq8O0dTgimTxDCvb5
	 TO0DpSqyWcW6dfvmkc7ryPCwLH8Z3UnImW5VDrt8=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20261106144310eucas1p1d60fe5c2e0170c49f38a3142bb1d8f94~le9cc505-2112221122eucas1p1J;
	Fri,  6 Nov 2026 14:43:10 +0000 (GMT)
Received: from AMDC4942.eu.corp.samsungelectronics.net (unknown
	[106.210.136.40]) by eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261106144308eusmtip1669b2a8cbde9723c315030165868f1df~le9a5TDI-0119201192eusmtip1h;
	Fri,  6 Nov 2026 14:43:08 +0000 (GMT)
From: Michal Wilczynski <m.wilczynski@samsung.com>
Date: Fri, 06 Nov 2026 15:42:53 +0100
Subject: [PATCH v2 13/15] lib/lz4: switch the decompressor to the vendored
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
Message-Id: <20261106-lz4-vendor-upstream-v2-13-ee04c3f0d7dc@samsung.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=39471;
	i=m.wilczynski@samsung.com; h=from:subject:message-id;
	bh=TGQWEmv+4W2DWgSKZyL59RxY1LCF0Fk5uIqV/HThnII=;
	b=owGbwMvMwCGWumv6zndzRCIZT6slMWS9fZ6qbKO4X8L4ZZLvQrUelusHF6sXih9LePb0YEqCx
	L8betePd5SyMIhxMMiKKbKc3RhtJPmP4Wn58ce/YOawMoEMYeDiFICJfHZn+O8XnLp7tfW/9/Jl
	JV8TmNarvnzPO/fp8x3CTk8lBDXTCmYwMvysDTz4SDxq8oRMN7Fv35v9fzCtEMyeGyZqU5a64Ef
	aA24A
X-Developer-Key: i=m.wilczynski@samsung.com; a=openpgp;
	fpr=CDB15B3219FE00E577C7E3FA65BA97B9EE9C1459
X-CMS-MailID: 20261106144310eucas1p1d60fe5c2e0170c49f38a3142bb1d8f94
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20261106144310eucas1p1d60fe5c2e0170c49f38a3142bb1d8f94
X-EPHeader: CA
X-CMS-RootMailID: 20261106144310eucas1p1d60fe5c2e0170c49f38a3142bb1d8f94
References: <20261106-lz4-vendor-upstream-v2-0-ee04c3f0d7dc@samsung.com>
	<CGME20261106144310eucas1p1d60fe5c2e0170c49f38a3142bb1d8f94@eucas1p1.samsung.com>

Replace the forked decompressor with thin entry points over the vendored
lz4.c; the API is signature-compatible, so every export is a plain
forwarder. lz4defs.h has no users left and goes.

lib/decompress_unlz4.c includes this file before boot, together with
<linux/lz4.h>, so LZ4_streamDecode_t becomes incomplete as upstream
declares it, and LZ4_MEM_DECOMPRESS (32) replaces the
LZ4_STREAMDECODESIZE macros. LZ4_COMPRESSBOUND is defined by both
headers and gets a guard; the LZ4_compressBound() wrapper goes, as
lib/decompress_unlz4.c now uses the macro.

LZ4_decompress_safe_partial() on a truncated block can now return the
bytes decoded so far rather than an error, depending on where the cut
falls; the kernel-doc says so.

This retires six local patches:

commit 8cb5d7482810 ("lib/lz4: make arrays static const, reduces object code size")
  upstream 75fb878a9019 ("decompress_generic: Add fastpath for small offsets"), v1.9.0
commit b1a3e75e466d ("lz4: fix kernel decompression speed")
  upstream fe2a1b3707d5 ("Call LZ4_memcpy() instead of memcpy()"), v1.9.3
commit 89b158635ad7 ("lib/lz4: explicitly support in-place decompression")
  upstream 33cb8518ac38 ("decompress: changed final memcpy() into memmove()"), v1.9.2
commit 7fde9d6e839d ("lz4_decompress: declare LZ4_decompress_safe_withPrefix64k static")
  LZ4LIB_VISIBILITY in lz4_deps.h, which makes every upstream entry point static
commit eafc0a02391b ("lz4: fix LZ4_decompress_safe_partial read out of bound")
  upstream c5d6f8a8be39 ("fix #783"), v1.9.3
commit 2d8867f3e083 ("lib: make LZ4_decompress_safe_forceExtDict() static")
  the static forward declaration in lz4_deps.h

Signed-off-by: Michal Wilczynski <m.wilczynski@samsung.com>
---
 drivers/block/zram/backend_lz4.c   |   2 +-
 drivers/block/zram/backend_lz4hc.c |   2 +-
 include/linux/lz4.h                |  60 ++--
 lib/decompress_unlz4.c             |   4 +-
 lib/lz4/lz4_decompress.c           | 640 +++----------------------------------
 lib/lz4/lz4defs.h                  | 247 --------------
 6 files changed, 71 insertions(+), 884 deletions(-)

diff --git a/drivers/block/zram/backend_lz4.c b/drivers/block/zram/backend_lz4.c
index 50265e3ce256490994cb6dae32a45da376e408e0..b9b8a5f678c155442fa3fd2c1984e45182e6fc38 100644
--- a/drivers/block/zram/backend_lz4.c
+++ b/drivers/block/zram/backend_lz4.c
@@ -84,7 +84,7 @@ static int lz4_create(struct zcomp_params *params, struct zcomp_ctx *ctx)
 		if (!zctx->mem)
 			goto error;
 	} else {
-		zctx->dstrm = kzalloc_obj(*zctx->dstrm);
+		zctx->dstrm = kzalloc(LZ4_MEM_DECOMPRESS, GFP_KERNEL);
 		if (!zctx->dstrm)
 			goto error;
 
diff --git a/drivers/block/zram/backend_lz4hc.c b/drivers/block/zram/backend_lz4hc.c
index e7ee3740219852f079d1e0866da6b213a3f3a583..1e09c93016264259c149e2913b2819571b56fab6 100644
--- a/drivers/block/zram/backend_lz4hc.c
+++ b/drivers/block/zram/backend_lz4hc.c
@@ -65,7 +65,7 @@ static int lz4hc_create(struct zcomp_params *params, struct zcomp_ctx *ctx)
 		if (!zctx->mem)
 			goto error;
 	} else {
-		zctx->dstrm = kzalloc_obj(*zctx->dstrm);
+		zctx->dstrm = kzalloc(LZ4_MEM_DECOMPRESS, GFP_KERNEL);
 		if (!zctx->dstrm)
 			goto error;
 
diff --git a/include/linux/lz4.h b/include/linux/lz4.h
index e809149747c3dc97d129e42e0ce4385b5a219930..fd9d7a162e04655a9d19639515466a6ba8e1e892 100644
--- a/include/linux/lz4.h
+++ b/include/linux/lz4.h
@@ -48,10 +48,16 @@
  *	CONSTANTS
  **************************************************************************/
 #define LZ4_MAX_INPUT_SIZE	0x7E000000 /* 2 113 929 216 bytes */
+
+/* Upstream's lz4.h defines the same macro, and lib/lz4's entry points and
+ * the pre-boot lib/decompress_unlz4.c see both headers.
+ */
+#ifndef LZ4_COMPRESSBOUND
 #define LZ4_COMPRESSBOUND(isize)	(\
 	(unsigned int)(isize) > (unsigned int)LZ4_MAX_INPUT_SIZE \
 	? 0 \
 	: (isize) + ((isize)/255) + 16)
+#endif
 
 #define LZ4_ACCELERATION_DEFAULT 1
 
@@ -67,12 +73,8 @@
 #define LZ4HC_CLAMP_CLEVEL			10
 
 /*-************************************************************************
- *	STREAMING CONSTANTS AND STRUCTURES
+ *	STREAMING STRUCTURES
  **************************************************************************/
-#define LZ4_STREAMDECODESIZE_U64	4
-#define LZ4_STREAMDECODESIZE		 (LZ4_STREAMDECODESIZE_U64 * \
-	sizeof(unsigned long long))
-
 /*
  * LZ4_stream_t - an LZ4 stream.  Incomplete: lib/lz4 owns the layout.
  * Allocate LZ4_MEM_COMPRESS bytes and cast, do not sizeof().
@@ -86,21 +88,11 @@ typedef union LZ4_stream_u LZ4_stream_t;
 typedef union LZ4_streamHC_u LZ4_streamHC_t;
 
 /*
- * LZ4_streamDecode_t - information structure to track an
- *	LZ4 stream during decompression.
- *
- * init this structure using LZ4_setStreamDecode (or memset()) before first use
+ * LZ4_streamDecode_t - an LZ4 stream during decompression.  Incomplete:
+ * lib/lz4 owns the layout.  Allocate LZ4_MEM_DECOMPRESS bytes and cast, do
+ * not sizeof().  Init with LZ4_setStreamDecode() (or zero it) before use.
  */
-typedef struct {
-	const uint8_t *externalDict;
-	size_t extDictSize;
-	const uint8_t *prefixEnd;
-	size_t prefixSize;
-} LZ4_streamDecode_t_internal;
-typedef union {
-	unsigned long long table[LZ4_STREAMDECODESIZE_U64];
-	LZ4_streamDecode_t_internal internal_donotuse;
-} LZ4_streamDecode_t;
+typedef union LZ4_streamDecode_u LZ4_streamDecode_t;
 
 /*-************************************************************************
  *	SIZE OF STATE
@@ -112,23 +104,12 @@ typedef union {
  */
 #define LZ4_MEM_COMPRESS	16416
 #define LZ4HC_MEM_COMPRESS	262200
+#define LZ4_MEM_DECOMPRESS	32
 
 /*-************************************************************************
  *	Compression Functions
  **************************************************************************/
 
-/**
- * LZ4_compressBound() - Max. output size in worst case szenarios
- * @isize: Size of the input data
- *
- * Return: Max. size LZ4 may output in a "worst case" szenario
- * (data not compressible)
- */
-static inline int LZ4_compressBound(size_t isize)
-{
-	return LZ4_COMPRESSBOUND(isize);
-}
-
 /**
  * LZ4_compress_default() - Compress data from source to dest
  * @source: source address of the original data
@@ -142,7 +123,7 @@ static inline int LZ4_compressBound(size_t isize)
  * Compresses 'sourceSize' bytes from buffer 'source'
  * into already allocated 'dest' buffer of size 'maxOutputSize'.
  * Compression is guaranteed to succeed if
- * 'maxOutputSize' >= LZ4_compressBound(inputSize).
+ * 'maxOutputSize' >= LZ4_COMPRESSBOUND(inputSize).
  * It also runs faster, so it's a recommended setting.
  * If the function cannot compress 'source' into a more limited 'dest' budget,
  * compression stops *immediately*, and the function result is zero.
@@ -234,7 +215,7 @@ int LZ4_decompress_safe(const char *source, char *dest, int compressedSize,
  * @source: source address of the compressed data
  * @dest: output buffer address of the decompressed data which must be
  *	already allocated
- * @compressedSize: is the precise full size of the compressed block.
+ * @compressedSize: size of the compressed data at 'source'
  * @targetOutputSize: the decompression operation will try
  *	to stop as soon as 'targetOutputSize' has been reached
  * @maxDecompressedSize: is the size of destination buffer
@@ -249,8 +230,11 @@ int LZ4_decompress_safe(const char *source, char *dest, int compressedSize,
  * It is therefore protected against malicious data packets.
  *
  * Return: the number of bytes decoded in the destination buffer
- *	(necessarily <= maxDecompressedSize)
- *	or a negative result in case of error
+ *	(necessarily <= targetOutputSize and maxDecompressedSize)
+ *	or a negative result in case of error.  For a block cut short the
+ *	result is either the bytes decoded so far, below targetOutputSize,
+ *	or an error, depending on where the cut falls; check it against the
+ *	size you expect.
  *
  */
 int LZ4_decompress_safe_partial(const char *source, char *dest,
@@ -275,7 +259,7 @@ int LZ4_decompress_safe_partial(const char *source, char *dest,
  *
  * Compress data from 'src' into 'dst', using the more powerful
  * but slower "HC" algorithm. Compression is guaranteed to succeed if
- * `dstCapacity >= LZ4_compressBound(srcSize)
+ * `dstCapacity >= LZ4_COMPRESSBOUND(srcSize)
  *
  * Return : the number of bytes written into 'dst' or 0 if compression fails.
  */
@@ -339,7 +323,7 @@ int	LZ4_loadDictHC(LZ4_streamHC_t *streamHCPtr, const char *dictionary,
  * (including initial dictionary when present) must remain accessible
  * and unmodified during compression.
  * 'dst' buffer should be sized to handle worst case scenarios, using
- *  LZ4_compressBound(), to ensure operation success.
+ *  LZ4_COMPRESSBOUND(), to ensure operation success.
  *  If, for any reason, previous data blocks can't be preserved unmodified
  *  in memory during next compression block,
  *  you must save it to a safer memory space, using LZ4_saveDictHC().
@@ -435,7 +419,7 @@ int LZ4_saveDict(LZ4_stream_t *streamPtr, char *safeBuffer, int dictSize);
  * as dictionary to improve compression ratio.
  * Important : Previous data blocks are assumed to still
  * be present and unmodified !
- * If maxDstSize >= LZ4_compressBound(srcSize),
+ * If maxDstSize >= LZ4_COMPRESSBOUND(srcSize),
  * compression is guaranteed to succeed, and runs faster.
  *
  * Return: Number of bytes written into buffer 'dst'  or 0 if compression fails
diff --git a/lib/decompress_unlz4.c b/lib/decompress_unlz4.c
index dc20c22e087900e21da49f9fcb267e6b511e1072..87eea1fbdea063e241dd98f994d7fee078b7a910 100644
--- a/lib/decompress_unlz4.c
+++ b/lib/decompress_unlz4.c
@@ -69,7 +69,7 @@ STATIC inline int INIT unlz4(u8 *input, long in_len,
 		error("NULL input pointer and missing fill function");
 		goto exit_1;
 	} else {
-		inp = large_malloc(LZ4_compressBound(uncomp_chunksize));
+		inp = large_malloc(LZ4_COMPRESSBOUND(uncomp_chunksize));
 		if (!inp) {
 			error("Could not allocate input buffer");
 			goto exit_1;
@@ -140,7 +140,7 @@ STATIC inline int INIT unlz4(u8 *input, long in_len,
 			inp += 4;
 			size -= 4;
 		} else {
-			if (chunksize > LZ4_compressBound(uncomp_chunksize)) {
+			if (chunksize > LZ4_COMPRESSBOUND(uncomp_chunksize)) {
 				error("chunk length is longer than allocated");
 				goto exit_2;
 			}
diff --git a/lib/lz4/lz4_decompress.c b/lib/lz4/lz4_decompress.c
index f89b0e547f2156990c16770f69f89e0d8b46156d..60b57862a2e387aa89fa26f6f8e2b5485b5d9995 100644
--- a/lib/lz4/lz4_decompress.c
+++ b/lib/lz4/lz4_decompress.c
@@ -1,626 +1,76 @@
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
+ * LZ4 decompressor -- kernel entry points
+ *
+ * The decompressor is upstream's, in the verbatim lz4.c included below.  The
+ * API is signature-compatible, so every export is a plain forwarder.  This
+ * file is also included by lib/decompress_unlz4.c for the pre-boot
+ * decompressor, which defines STATIC.
  */
 
-/*-************************************
- *	Dependencies
- **************************************/
-#include "lz4defs.h"
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/unaligned.h>
+#include "lz4_deps.h"
+#include "upstream/lz4.c"
 
-/*-*****************************
- *	Decompression functions
- *******************************/
+/* Upstream's short helper macros; MIN and MAX clash with <linux/minmax.h>. */
+#undef MIN
+#undef MAX
+#undef KB
+#undef MB
+#undef GB
 
-#define DEBUGLOG(l, ...) {}	/* disabled */
+#include "lz4_kernel_api.h"
 
-#ifndef assert
-#define assert(condition) ((void)0)
+#ifndef STATIC
+#include <linux/export.h>
+#include <linux/module.h>
 #endif
 
-/*
- * LZ4_decompress_generic() :
- * This generic decompression function covers all use cases.
- * It shall be instantiated several times, using different sets of directives.
- * Note that it is important for performance that this function really get inlined,
- * in order to remove useless branches during compilation optimization.
- */
-static FORCE_INLINE int LZ4_decompress_generic(
-	 const char * const src,
-	 char * const dst,
-	 int srcSize,
-		/*
-		 * If endOnInput == endOnInputSize,
-		 * this value is `dstCapacity`
-		 */
-	 int outputSize,
-	 /* endOnOutputSize, endOnInputSize */
-	 endCondition_directive endOnInput,
-	 /* full, partial */
-	 earlyEnd_directive partialDecoding,
-	 /* noDict, withPrefix64k, usingExtDict */
-	 dict_directive dict,
-	 /* always <= dst, == dst when no prefix */
-	 const BYTE * const lowPrefix,
-	 /* only if dict == usingExtDict */
-	 const BYTE * const dictStart,
-	 /* note : = 0 if noDict */
-	 const size_t dictSize
-	 )
-{
-	const BYTE *ip = (const BYTE *) src;
-	const BYTE * const iend = ip + srcSize;
-
-	BYTE *op = (BYTE *) dst;
-	BYTE * const oend = op + outputSize;
-	BYTE *cpy;
-
-	const BYTE * const dictEnd = (const BYTE *)dictStart + dictSize;
-	static const unsigned int inc32table[8] = {0, 1, 2, 1, 0, 4, 4, 4};
-	static const int dec64table[8] = {0, 0, 0, -1, -4, 1, 2, 3};
-
-	const int safeDecode = (endOnInput == endOnInputSize);
-	const int checkOffset = ((safeDecode) && (dictSize < (int)(64 * KB)));
-
-	/* Set up the "end" pointers for the shortcut. */
-	const BYTE *const shortiend = iend -
-		(endOnInput ? 14 : 8) /*maxLL*/ - 2 /*offset*/;
-	const BYTE *const shortoend = oend -
-		(endOnInput ? 14 : 8) /*maxLL*/ - 18 /*maxML*/;
-
-	DEBUGLOG(5, "%s (srcSize:%i, dstSize:%i)", __func__,
-		 srcSize, outputSize);
-
-	/* Special cases */
-	assert(lowPrefix <= op);
-	assert(src != NULL);
-
-	/* Empty output buffer */
-	if ((endOnInput) && (unlikely(outputSize == 0)))
-		return ((srcSize == 1) && (*ip == 0)) ? 0 : -1;
-
-	if ((!endOnInput) && (unlikely(outputSize == 0)))
-		return (*ip == 0 ? 1 : -1);
-
-	if ((endOnInput) && unlikely(srcSize == 0))
-		return -1;
-
-	/* Main Loop : decode sequences */
-	while (1) {
-		size_t length;
-		const BYTE *match;
-		size_t offset;
-
-		/* get literal length */
-		unsigned int const token = *ip++;
-		length = token>>ML_BITS;
-
-		/* ip < iend before the increment */
-		assert(!endOnInput || ip <= iend);
-
-		/*
-		 * A two-stage shortcut for the most common case:
-		 * 1) If the literal length is 0..14, and there is enough
-		 * space, enter the shortcut and copy 16 bytes on behalf
-		 * of the literals (in the fast mode, only 8 bytes can be
-		 * safely copied this way).
-		 * 2) Further if the match length is 4..18, copy 18 bytes
-		 * in a similar manner; but we ensure that there's enough
-		 * space in the output for those 18 bytes earlier, upon
-		 * entering the shortcut (in other words, there is a
-		 * combined check for both stages).
-		 *
-		 * The & in the likely() below is intentionally not && so that
-		 * some compilers can produce better parallelized runtime code
-		 */
-		if ((endOnInput ? length != RUN_MASK : length <= 8)
-		   /*
-		    * strictly "less than" on input, to re-enter
-		    * the loop with at least one byte
-		    */
-		   && likely((endOnInput ? ip < shortiend : 1) &
-			     (op <= shortoend))) {
-			/* Copy the literals */
-			LZ4_memcpy(op, ip, endOnInput ? 16 : 8);
-			op += length; ip += length;
-
-			/*
-			 * The second stage:
-			 * prepare for match copying, decode full info.
-			 * If it doesn't work out, the info won't be wasted.
-			 */
-			length = token & ML_MASK; /* match length */
-			offset = LZ4_readLE16(ip);
-			ip += 2;
-			match = op - offset;
-			assert(match <= op); /* check overflow */
-
-			/* Do not deal with overlapping matches. */
-			if ((length != ML_MASK) &&
-			    (offset >= 8) &&
-			    (dict == withPrefix64k || match >= lowPrefix)) {
-				/* Copy the match. */
-				LZ4_memcpy(op + 0, match + 0, 8);
-				LZ4_memcpy(op + 8, match + 8, 8);
-				LZ4_memcpy(op + 16, match + 16, 2);
-				op += length + MINMATCH;
-				/* Both stages worked, load the next token. */
-				continue;
-			}
-
-			/*
-			 * The second stage didn't work out, but the info
-			 * is ready. Propel it right to the point of match
-			 * copying.
-			 */
-			goto _copy_match;
-		}
-
-		/* decode literal length */
-		if (length == RUN_MASK) {
-			unsigned int s;
-
-			if (unlikely(endOnInput ? ip >= iend - RUN_MASK : 0)) {
-				/* overflow detection */
-				goto _output_error;
-			}
-			do {
-				s = *ip++;
-				length += s;
-			} while (likely(endOnInput
-				? ip < iend - RUN_MASK
-				: 1) & (s == 255));
-
-			if ((safeDecode)
-			    && unlikely((uptrval)(op) +
-					length < (uptrval)(op))) {
-				/* overflow detection */
-				goto _output_error;
-			}
-			if ((safeDecode)
-			    && unlikely((uptrval)(ip) +
-					length < (uptrval)(ip))) {
-				/* overflow detection */
-				goto _output_error;
-			}
-		}
-
-		/* copy literals */
-		cpy = op + length;
-		LZ4_STATIC_ASSERT(MFLIMIT >= WILDCOPYLENGTH);
-
-		if (((endOnInput) && ((cpy > oend - MFLIMIT)
-			|| (ip + length > iend - (2 + 1 + LASTLITERALS))))
-			|| ((!endOnInput) && (cpy > oend - WILDCOPYLENGTH))) {
-			if (partialDecoding) {
-				if (cpy > oend) {
-					/*
-					 * Partial decoding :
-					 * stop in the middle of literal segment
-					 */
-					cpy = oend;
-					length = oend - op;
-				}
-				if ((endOnInput)
-					&& (ip + length > iend)) {
-					/*
-					 * Error :
-					 * read attempt beyond
-					 * end of input buffer
-					 */
-					goto _output_error;
-				}
-			} else {
-				if ((!endOnInput)
-					&& (cpy != oend)) {
-					/*
-					 * Error :
-					 * block decoding must
-					 * stop exactly there
-					 */
-					goto _output_error;
-				}
-				if ((endOnInput)
-					&& ((ip + length != iend)
-					|| (cpy > oend))) {
-					/*
-					 * Error :
-					 * input must be consumed
-					 */
-					goto _output_error;
-				}
-			}
-
-			/*
-			 * supports overlapping memory regions; only matters
-			 * for in-place decompression scenarios
-			 */
-			LZ4_memmove(op, ip, length);
-			ip += length;
-			op += length;
-
-			/* Necessarily EOF when !partialDecoding.
-			 * When partialDecoding, it is EOF if we've either
-			 * filled the output buffer or
-			 * can't proceed with reading an offset for following match.
-			 */
-			if (!partialDecoding || (cpy == oend) || (ip >= (iend - 2)))
-				break;
-		} else {
-			/* may overwrite up to WILDCOPYLENGTH beyond cpy */
-			LZ4_wildCopy(op, ip, cpy);
-			ip += length;
-			op = cpy;
-		}
-
-		/* get offset */
-		offset = LZ4_readLE16(ip);
-		ip += 2;
-		match = op - offset;
-
-		/* get matchlength */
-		length = token & ML_MASK;
-
-_copy_match:
-		if ((checkOffset) && (unlikely(match + dictSize < lowPrefix))) {
-			/* Error : offset outside buffers */
-			goto _output_error;
-		}
-
-		/* costs ~1%; silence an msan warning when offset == 0 */
-		/*
-		 * note : when partialDecoding, there is no guarantee that
-		 * at least 4 bytes remain available in output buffer
-		 */
-		if (!partialDecoding) {
-			assert(oend > op);
-			assert(oend - op >= 4);
-
-			LZ4_write32(op, (U32)offset);
-		}
-
-		if (length == ML_MASK) {
-			unsigned int s;
-
-			do {
-				s = *ip++;
-
-				if ((endOnInput) && (ip > iend - LASTLITERALS))
-					goto _output_error;
-
-				length += s;
-			} while (s == 255);
+static_assert(sizeof(LZ4_streamDecode_t) == LZ4_STREAMDECODE_MINSIZE);
+static_assert(LZ4_STREAMDECODE_MINSIZE == 32); /* LZ4_MEM_DECOMPRESS */
 
-			if ((safeDecode)
-				&& unlikely(
-					(uptrval)(op) + length < (uptrval)op)) {
-				/* overflow detection */
-				goto _output_error;
-			}
-		}
-
-		length += MINMATCH;
-
-		/* match starting within external dictionary */
-		if ((dict == usingExtDict) && (match < lowPrefix)) {
-			if (unlikely(op + length > oend - LASTLITERALS)) {
-				/* doesn't respect parsing restriction */
-				if (!partialDecoding)
-					goto _output_error;
-				length = min(length, (size_t)(oend - op));
-			}
-
-			if (length <= (size_t)(lowPrefix - match)) {
-				/*
-				 * match fits entirely within external
-				 * dictionary : just copy
-				 */
-				memmove(op, dictEnd - (lowPrefix - match),
-					length);
-				op += length;
-			} else {
-				/*
-				 * match stretches into both external
-				 * dictionary and current block
-				 */
-				size_t const copySize = (size_t)(lowPrefix - match);
-				size_t const restSize = length - copySize;
-
-				LZ4_memcpy(op, dictEnd - copySize, copySize);
-				op += copySize;
-				if (restSize > (size_t)(op - lowPrefix)) {
-					/* overlap copy */
-					BYTE * const endOfMatch = op + restSize;
-					const BYTE *copyFrom = lowPrefix;
-
-					while (op < endOfMatch)
-						*op++ = *copyFrom++;
-				} else {
-					LZ4_memcpy(op, lowPrefix, restSize);
-					op += restSize;
-				}
-			}
-			continue;
-		}
-
-		/* copy match within block */
-		cpy = op + length;
-
-		/*
-		 * partialDecoding :
-		 * may not respect endBlock parsing restrictions
-		 */
-		assert(op <= oend);
-		if (partialDecoding &&
-		    (cpy > oend - MATCH_SAFEGUARD_DISTANCE)) {
-			size_t const mlen = min(length, (size_t)(oend - op));
-			const BYTE * const matchEnd = match + mlen;
-			BYTE * const copyEnd = op + mlen;
-
-			if (matchEnd > op) {
-				/* overlap copy */
-				while (op < copyEnd)
-					*op++ = *match++;
-			} else {
-				LZ4_memcpy(op, match, mlen);
-			}
-			op = copyEnd;
-			if (op == oend)
-				break;
-			continue;
-		}
-
-		if (unlikely(offset < 8)) {
-			op[0] = match[0];
-			op[1] = match[1];
-			op[2] = match[2];
-			op[3] = match[3];
-			match += inc32table[offset];
-			LZ4_memcpy(op + 4, match, 4);
-			match -= dec64table[offset];
-		} else {
-			LZ4_copy8(op, match);
-			match += 8;
-		}
-
-		op += 8;
-
-		if (unlikely(cpy > oend - MATCH_SAFEGUARD_DISTANCE)) {
-			BYTE * const oCopyLimit = oend - (WILDCOPYLENGTH - 1);
-
-			if (cpy > oend - LASTLITERALS) {
-				/*
-				 * Error : last LASTLITERALS bytes
-				 * must be literals (uncompressed)
-				 */
-				goto _output_error;
-			}
-
-			if (op < oCopyLimit) {
-				LZ4_wildCopy(op, match, oCopyLimit);
-				match += oCopyLimit - op;
-				op = oCopyLimit;
-			}
-			while (op < cpy)
-				*op++ = *match++;
-		} else {
-			LZ4_copy8(op, match);
-			if (length > 16)
-				LZ4_wildCopy(op + 8, match + 8, cpy);
-		}
-		op = cpy; /* wildcopy correction */
-	}
-
-	/* end of decoding */
-	if (endOnInput) {
-		/* Nb of output bytes decoded */
-		return (int) (((char *)op) - dst);
-	} else {
-		/* Nb of input bytes read */
-		return (int) (((const char *)ip) - src);
-	}
-
-	/* Overflow error detected */
-_output_error:
-	return (int) (-(((const char *)ip) - src)) - 1;
-}
-
-int LZ4_decompress_safe(const char *source, char *dest,
-	int compressedSize, int maxDecompressedSize)
-{
-	return LZ4_decompress_generic(source, dest,
-				      compressedSize, maxDecompressedSize,
-				      endOnInputSize, decode_full_block,
-				      noDict, (BYTE *)dest, NULL, 0);
-}
-
-int LZ4_decompress_safe_partial(const char *src, char *dst,
-	int compressedSize, int targetOutputSize, int dstCapacity)
-{
-	dstCapacity = min(targetOutputSize, dstCapacity);
-	return LZ4_decompress_generic(src, dst, compressedSize, dstCapacity,
-				      endOnInputSize, partial_decode,
-				      noDict, (BYTE *)dst, NULL, 0);
-}
-
-/* ===== Instantiate a few more decoding cases, used more than once. ===== */
-
-static int LZ4_decompress_safe_withPrefix64k(const char *source, char *dest,
-				      int compressedSize, int maxOutputSize)
+int LZ4_decompress_safe(const char *source, char *dest, int compressedSize,
+			int maxDecompressedSize)
 {
-	return LZ4_decompress_generic(source, dest,
-				      compressedSize, maxOutputSize,
-				      endOnInputSize, decode_full_block,
-				      withPrefix64k,
-				      (BYTE *)dest - 64 * KB, NULL, 0);
+	return __lz4_decompress_safe(source, dest, compressedSize,
+				     maxDecompressedSize);
 }
 
-static int LZ4_decompress_safe_withSmallPrefix(const char *source, char *dest,
-					       int compressedSize,
-					       int maxOutputSize,
-					       size_t prefixSize)
+int LZ4_decompress_safe_partial(const char *source, char *dest,
+				int compressedSize, int targetOutputSize,
+				int maxDecompressedSize)
 {
-	return LZ4_decompress_generic(source, dest,
-				      compressedSize, maxOutputSize,
-				      endOnInputSize, decode_full_block,
-				      noDict,
-				      (BYTE *)dest - prefixSize, NULL, 0);
+	return __lz4_decompress_safe_partial(source, dest, compressedSize,
+					     targetOutputSize,
+					     maxDecompressedSize);
 }
 
-static int LZ4_decompress_safe_forceExtDict(const char *source, char *dest,
-					    int compressedSize, int maxOutputSize,
-					    const void *dictStart, size_t dictSize)
-{
-	return LZ4_decompress_generic(source, dest,
-				      compressedSize, maxOutputSize,
-				      endOnInputSize, decode_full_block,
-				      usingExtDict, (BYTE *)dest,
-				      (const BYTE *)dictStart, dictSize);
-}
-
-/*
- * The "double dictionary" mode, for use with e.g. ring buffers: the first part
- * of the dictionary is passed as prefix, and the second via dictStart + dictSize.
- * These routines are used only once, in LZ4_decompress_*_continue().
- */
-static FORCE_INLINE
-int LZ4_decompress_safe_doubleDict(const char *source, char *dest,
-				   int compressedSize, int maxOutputSize,
-				   size_t prefixSize,
-				   const void *dictStart, size_t dictSize)
-{
-	return LZ4_decompress_generic(source, dest,
-				      compressedSize, maxOutputSize,
-				      endOnInputSize, decode_full_block,
-				      usingExtDict, (BYTE *)dest - prefixSize,
-				      (const BYTE *)dictStart, dictSize);
-}
-
-/* ===== streaming decompression functions ===== */
-
 int LZ4_setStreamDecode(LZ4_streamDecode_t *LZ4_streamDecode,
-	const char *dictionary, int dictSize)
+			const char *dictionary, int dictSize)
 {
-	LZ4_streamDecode_t_internal *lz4sd =
-		&LZ4_streamDecode->internal_donotuse;
-
-	lz4sd->prefixSize = (size_t) dictSize;
-	lz4sd->prefixEnd = (const BYTE *) dictionary + dictSize;
-	lz4sd->externalDict = NULL;
-	lz4sd->extDictSize	= 0;
-	return 1;
+	return __lz4_setStreamDecode(LZ4_streamDecode, dictionary, dictSize);
 }
 
-/*
- * *_continue() :
- * These decoding functions allow decompression of multiple blocks
- * in "streaming" mode.
- * Previously decoded blocks must still be available at the memory
- * position where they were decoded.
- * If it's not possible, save the relevant part of
- * decoded data into a safe buffer,
- * and indicate where it stands using LZ4_setStreamDecode()
- */
 int LZ4_decompress_safe_continue(LZ4_streamDecode_t *LZ4_streamDecode,
-	const char *source, char *dest, int compressedSize, int maxOutputSize)
+				 const char *source, char *dest,
+				 int compressedSize, int maxDecompressedSize)
 {
-	LZ4_streamDecode_t_internal *lz4sd =
-		&LZ4_streamDecode->internal_donotuse;
-	int result;
-
-	if (lz4sd->prefixSize == 0) {
-		/* The first call, no dictionary yet. */
-		assert(lz4sd->extDictSize == 0);
-		result = LZ4_decompress_safe(source, dest,
-			compressedSize, maxOutputSize);
-		if (result <= 0)
-			return result;
-		lz4sd->prefixSize = result;
-		lz4sd->prefixEnd = (BYTE *)dest + result;
-	} else if (lz4sd->prefixEnd == (BYTE *)dest) {
-		/* They're rolling the current segment. */
-		if (lz4sd->prefixSize >= 64 * KB - 1)
-			result = LZ4_decompress_safe_withPrefix64k(source, dest,
-				compressedSize, maxOutputSize);
-		else if (lz4sd->extDictSize == 0)
-			result = LZ4_decompress_safe_withSmallPrefix(source,
-				dest, compressedSize, maxOutputSize,
-				lz4sd->prefixSize);
-		else
-			result = LZ4_decompress_safe_doubleDict(source, dest,
-				compressedSize, maxOutputSize,
-				lz4sd->prefixSize,
-				lz4sd->externalDict, lz4sd->extDictSize);
-		if (result <= 0)
-			return result;
-		lz4sd->prefixSize += result;
-		lz4sd->prefixEnd  += result;
-	} else {
-		/*
-		 * The buffer wraps around, or they're
-		 * switching to another buffer.
-		 */
-		lz4sd->extDictSize = lz4sd->prefixSize;
-		lz4sd->externalDict = lz4sd->prefixEnd - lz4sd->extDictSize;
-		result = LZ4_decompress_safe_forceExtDict(source, dest,
-			compressedSize, maxOutputSize,
-			lz4sd->externalDict, lz4sd->extDictSize);
-		if (result <= 0)
-			return result;
-		lz4sd->prefixSize = result;
-		lz4sd->prefixEnd  = (BYTE *)dest + result;
-	}
-
-	return result;
+	return __lz4_decompress_safe_continue(LZ4_streamDecode, source, dest,
+					      compressedSize,
+					      maxDecompressedSize);
 }
 
 int LZ4_decompress_safe_usingDict(const char *source, char *dest,
-				  int compressedSize, int maxOutputSize,
+				  int compressedSize, int maxDecompressedSize,
 				  const char *dictStart, int dictSize)
 {
-	if (dictSize == 0)
-		return LZ4_decompress_safe(source, dest,
-					   compressedSize, maxOutputSize);
-	if (dictStart+dictSize == dest) {
-		if (dictSize >= 64 * KB - 1)
-			return LZ4_decompress_safe_withPrefix64k(source, dest,
-				compressedSize, maxOutputSize);
-		return LZ4_decompress_safe_withSmallPrefix(source, dest,
-			compressedSize, maxOutputSize, dictSize);
-	}
-	return LZ4_decompress_safe_forceExtDict(source, dest,
-		compressedSize, maxOutputSize, dictStart, dictSize);
+	return __lz4_decompress_safe_usingDict(source, dest, compressedSize,
+					       maxDecompressedSize, dictStart,
+					       dictSize);
 }
 
 #ifndef STATIC
diff --git a/lib/lz4/lz4defs.h b/lib/lz4/lz4defs.h
deleted file mode 100644
index 17277ec16919f3a554afc7d91ad515c493d745ca..0000000000000000000000000000000000000000
--- a/lib/lz4/lz4defs.h
+++ /dev/null
@@ -1,247 +0,0 @@
-#ifndef __LZ4DEFS_H__
-#define __LZ4DEFS_H__
-
-/*
- * lz4defs.h -- common and architecture specific defines for the kernel usage
-
- * LZ4 - Fast LZ compression algorithm
- * Copyright (C) 2011-2016, Yann Collet.
- * BSD 2-Clause License (http://www.opensource.org/licenses/bsd-license.php)
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
- *
- *	Changed for kernel usage by:
- *	Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
- */
-
-#include <linux/unaligned.h>
-
-#include <linux/bitops.h>
-#include <linux/string.h>	 /* memset, memcpy */
-#include <linux/lz4.h>
-
-#define FORCE_INLINE __always_inline
-
-/*-************************************
- *	Basic Types
- **************************************/
-#include <linux/types.h>
-
-typedef	uint8_t BYTE;
-typedef uint16_t U16;
-typedef uint32_t U32;
-typedef	int32_t S32;
-typedef uint64_t U64;
-typedef uintptr_t uptrval;
-
-/*-************************************
- *	Architecture specifics
- **************************************/
-#if defined(CONFIG_64BIT)
-#define LZ4_ARCH64 1
-#else
-#define LZ4_ARCH64 0
-#endif
-
-#if defined(__LITTLE_ENDIAN)
-#define LZ4_LITTLE_ENDIAN 1
-#else
-#define LZ4_LITTLE_ENDIAN 0
-#endif
-
-/*-************************************
- *	Constants
- **************************************/
-#define MINMATCH 4
-
-#define WILDCOPYLENGTH 8
-#define LASTLITERALS 5
-#define MFLIMIT (WILDCOPYLENGTH + MINMATCH)
-/*
- * ensure it's possible to write 2 x wildcopyLength
- * without overflowing output buffer
- */
-#define MATCH_SAFEGUARD_DISTANCE  ((2 * WILDCOPYLENGTH) - MINMATCH)
-
-/* Increase this value ==> compression run slower on incompressible data */
-#define LZ4_SKIPTRIGGER 6
-
-#define HASH_UNIT sizeof(size_t)
-
-#define KB (1 << 10)
-#define MB (1 << 20)
-#define GB (1U << 30)
-
-#define MAX_DISTANCE LZ4_DISTANCE_MAX
-#define STEPSIZE sizeof(size_t)
-
-#define ML_BITS	4
-#define ML_MASK	((1U << ML_BITS) - 1)
-#define RUN_BITS (8 - ML_BITS)
-#define RUN_MASK ((1U << RUN_BITS) - 1)
-
-/*-************************************
- *	Reading and writing into memory
- **************************************/
-static FORCE_INLINE U16 LZ4_read16(const void *ptr)
-{
-	return get_unaligned((const U16 *)ptr);
-}
-
-static FORCE_INLINE U32 LZ4_read32(const void *ptr)
-{
-	return get_unaligned((const U32 *)ptr);
-}
-
-static FORCE_INLINE size_t LZ4_read_ARCH(const void *ptr)
-{
-	return get_unaligned((const size_t *)ptr);
-}
-
-static FORCE_INLINE void LZ4_write16(void *memPtr, U16 value)
-{
-	put_unaligned(value, (U16 *)memPtr);
-}
-
-static FORCE_INLINE void LZ4_write32(void *memPtr, U32 value)
-{
-	put_unaligned(value, (U32 *)memPtr);
-}
-
-static FORCE_INLINE U16 LZ4_readLE16(const void *memPtr)
-{
-	return get_unaligned_le16(memPtr);
-}
-
-static FORCE_INLINE void LZ4_writeLE16(void *memPtr, U16 value)
-{
-	return put_unaligned_le16(value, memPtr);
-}
-
-/*
- * LZ4 relies on memcpy with a constant size being inlined. In freestanding
- * environments, the compiler can't assume the implementation of memcpy() is
- * standard compliant, so apply its specialized memcpy() inlining logic. When
- * possible, use __builtin_memcpy() to tell the compiler to analyze memcpy()
- * as-if it were standard compliant, so it can inline it in freestanding
- * environments. This is needed when decompressing the Linux Kernel, for example.
- */
-#define LZ4_memcpy(dst, src, size) __builtin_memcpy(dst, src, size)
-#define LZ4_memmove(dst, src, size) __builtin_memmove(dst, src, size)
-
-static FORCE_INLINE void LZ4_copy8(void *dst, const void *src)
-{
-#if LZ4_ARCH64
-	U64 a = get_unaligned((const U64 *)src);
-
-	put_unaligned(a, (U64 *)dst);
-#else
-	U32 a = get_unaligned((const U32 *)src);
-	U32 b = get_unaligned((const U32 *)src + 1);
-
-	put_unaligned(a, (U32 *)dst);
-	put_unaligned(b, (U32 *)dst + 1);
-#endif
-}
-
-/*
- * customized variant of memcpy,
- * which can overwrite up to 7 bytes beyond dstEnd
- */
-static FORCE_INLINE void LZ4_wildCopy(void *dstPtr,
-	const void *srcPtr, void *dstEnd)
-{
-	BYTE *d = (BYTE *)dstPtr;
-	const BYTE *s = (const BYTE *)srcPtr;
-	BYTE *const e = (BYTE *)dstEnd;
-
-	do {
-		LZ4_copy8(d, s);
-		d += 8;
-		s += 8;
-	} while (d < e);
-}
-
-static FORCE_INLINE unsigned int LZ4_NbCommonBytes(register size_t val)
-{
-#if LZ4_LITTLE_ENDIAN
-	return __ffs(val) >> 3;
-#else
-	return (BITS_PER_LONG - 1 - __fls(val)) >> 3;
-#endif
-}
-
-static FORCE_INLINE unsigned int LZ4_count(
-	const BYTE *pIn,
-	const BYTE *pMatch,
-	const BYTE *pInLimit)
-{
-	const BYTE *const pStart = pIn;
-
-	while (likely(pIn < pInLimit - (STEPSIZE - 1))) {
-		size_t const diff = LZ4_read_ARCH(pMatch) ^ LZ4_read_ARCH(pIn);
-
-		if (!diff) {
-			pIn += STEPSIZE;
-			pMatch += STEPSIZE;
-			continue;
-		}
-
-		pIn += LZ4_NbCommonBytes(diff);
-
-		return (unsigned int)(pIn - pStart);
-	}
-
-#if LZ4_ARCH64
-	if ((pIn < (pInLimit - 3))
-		&& (LZ4_read32(pMatch) == LZ4_read32(pIn))) {
-		pIn += 4;
-		pMatch += 4;
-	}
-#endif
-
-	if ((pIn < (pInLimit - 1))
-		&& (LZ4_read16(pMatch) == LZ4_read16(pIn))) {
-		pIn += 2;
-		pMatch += 2;
-	}
-
-	if ((pIn < pInLimit) && (*pMatch == *pIn))
-		pIn++;
-
-	return (unsigned int)(pIn - pStart);
-}
-
-typedef enum { noLimit = 0, limitedOutput = 1 } limitedOutput_directive;
-typedef enum { byPtr, byU32, byU16 } tableType_t;
-
-typedef enum { noDict = 0, withPrefix64k, usingExtDict } dict_directive;
-typedef enum { noDictIssue = 0, dictSmall } dictIssue_directive;
-
-typedef enum { endOnOutputSize = 0, endOnInputSize = 1 } endCondition_directive;
-typedef enum { decode_full_block = 0, partial_decode = 1 } earlyEnd_directive;
-
-#define LZ4_STATIC_ASSERT(c)	BUILD_BUG_ON(!(c))
-
-#endif

-- 
2.34.1

