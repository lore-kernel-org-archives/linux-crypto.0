From: Maninder Singh <maninder1.s@samsung.com>
Subject: [PATCH 1/1] lz4: Implement lz4 with dynamic offset length.
Date: Wed, 21 Mar 2018 10:10:42 +0530
Message-ID: <1521607242-3968-2-git-send-email-maninder1.s@samsung.com>
References: <1521607242-3968-1-git-send-email-maninder1.s@samsung.com>
        <CGME20180321044149epcas5p12cba1afa5fc0f493a47fe20c4a7394bd@epcas5p1.samsung.com>
Content-Type: text/plain; charset="utf-8"
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        pankaj.m@samsung.com, a.sahrawat@samsung.com, v.narang@samsung.com,
        Maninder Singh <maninder1.s@samsung.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net,
        minchan@kernel.org, ngupta@vflare.org,
        sergey.senozhatsky.work@gmail.com, keescook@chromium.org,
        anton@enomsg.org, ccross@android.com, tony.luck@intel.com,
        akpm@linux-foundation.org, colin.king@canonical.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1521607242-3968-1-git-send-email-maninder1.s@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

LZ4 specification defines 2 byte offset length for 64 KB data.
But in case of ZRAM we compress data per page and in most of
architecture PAGE_SIZE is 4KB. So we can decide offset length based
on actual offset value. For this we can reserve 1 bit to decide offset
length (1 byte or 2 byte). 2 byte required only if ofsset is greater than 127,
else 1 byte is enough.

With this new implementation new offset value can be at MAX 32 KB.

Thus we can save more memory for compressed data.

results checked with new implementation:-
LZO
=======
orig_data_size: 78917632
compr_data_size: 15894668
mem_used_total: 17117184

LZ4
========
orig_data_size: 78917632
compr_data_size: 16310717
mem_used_total: 17592320

LZ4_DYN
=======
orig_data_size: 78917632
compr_data_size: 15520506
mem_used_total: 16748544

Signed-off-by: Maninder Singh <maninder1.s@samsung.com>
Signed-off-by: Vaneet Narang <v.narang@samsung.com>
---
 crypto/lz4.c               |   64 ++++++++++++++++++++++++++++++++-
 drivers/block/zram/zcomp.c |    4 ++
 fs/pstore/platform.c       |    2 +-
 include/linux/lz4.h        |   15 ++++++--
 lib/decompress_unlz4.c     |    2 +-
 lib/lz4/lz4_compress.c     |   84 +++++++++++++++++++++++++++++++++++--------
 lib/lz4/lz4_decompress.c   |   56 ++++++++++++++++++++---------
 lib/lz4/lz4defs.h          |   11 ++++++
 8 files changed, 197 insertions(+), 41 deletions(-)

diff --git a/crypto/lz4.c b/crypto/lz4.c
index 2ce2660..f1a8a20 100644
--- a/crypto/lz4.c
+++ b/crypto/lz4.c
@@ -67,7 +67,20 @@ static int __lz4_compress_crypto(const u8 *src, unsigned int slen,
 				 u8 *dst, unsigned int *dlen, void *ctx)
 {
 	int out_len = LZ4_compress_default(src, dst,
-		slen, *dlen, ctx);
+		slen, *dlen, ctx, false);
+
+	if (!out_len)
+		return -EINVAL;
+
+	*dlen = out_len;
+	return 0;
+}
+
+static int __lz4_compress_crypto_dynamic(const u8 *src, unsigned int slen,
+				 u8 *dst, unsigned int *dlen, void *ctx)
+{
+	int out_len = LZ4_compress_default(src, dst,
+		slen, *dlen, ctx, true);
 
 	if (!out_len)
 		return -EINVAL;
@@ -91,10 +104,30 @@ static int lz4_compress_crypto(struct crypto_tfm *tfm, const u8 *src,
 	return __lz4_compress_crypto(src, slen, dst, dlen, ctx->lz4_comp_mem);
 }
 
+static int lz4_compress_crypto_dynamic(struct crypto_tfm *tfm, const u8 *src,
+			       unsigned int slen, u8 *dst, unsigned int *dlen)
+{
+	struct lz4_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	return __lz4_compress_crypto_dynamic(src, slen, dst, dlen, ctx->lz4_comp_mem);
+}
+
 static int __lz4_decompress_crypto(const u8 *src, unsigned int slen,
 				   u8 *dst, unsigned int *dlen, void *ctx)
 {
-	int out_len = LZ4_decompress_safe(src, dst, slen, *dlen);
+	int out_len = LZ4_decompress_safe(src, dst, slen, *dlen, false);
+
+	if (out_len < 0)
+		return -EINVAL;
+
+	*dlen = out_len;
+	return 0;
+}
+
+static int __lz4_decompress_crypto_dynamic(const u8 *src, unsigned int slen,
+				   u8 *dst, unsigned int *dlen, void *ctx)
+{
+	int out_len = LZ4_decompress_safe(src, dst, slen, *dlen, true);
 
 	if (out_len < 0)
 		return -EINVAL;
@@ -117,6 +150,13 @@ static int lz4_decompress_crypto(struct crypto_tfm *tfm, const u8 *src,
 	return __lz4_decompress_crypto(src, slen, dst, dlen, NULL);
 }
 
+static int lz4_decompress_crypto_dynamic(struct crypto_tfm *tfm, const u8 *src,
+				 unsigned int slen, u8 *dst,
+				 unsigned int *dlen)
+{
+	return __lz4_decompress_crypto_dynamic(src, slen, dst, dlen, NULL);
+}
+
 static struct crypto_alg alg_lz4 = {
 	.cra_name		= "lz4",
 	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
@@ -130,6 +170,19 @@ static int lz4_decompress_crypto(struct crypto_tfm *tfm, const u8 *src,
 	.coa_decompress		= lz4_decompress_crypto } }
 };
 
+static struct crypto_alg alg_lz4_dyn = {
+	.cra_name		= "lz4_dyn",
+	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
+	.cra_ctxsize		= sizeof(struct lz4_ctx),
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(alg_lz4_dyn.cra_list),
+	.cra_init		= lz4_init,
+	.cra_exit		= lz4_exit,
+	.cra_u			= { .compress = {
+	.coa_compress		= lz4_compress_crypto_dynamic,
+	.coa_decompress		= lz4_decompress_crypto_dynamic } }
+};
+
 static struct scomp_alg scomp = {
 	.alloc_ctx		= lz4_alloc_ctx,
 	.free_ctx		= lz4_free_ctx,
@@ -150,9 +203,16 @@ static int __init lz4_mod_init(void)
 	if (ret)
 		return ret;
 
+	ret = crypto_register_alg(&alg_lz4_dyn);
+	if (ret) {
+		crypto_unregister_alg(&alg_lz4);
+		return ret;
+	}
+
 	ret = crypto_register_scomp(&scomp);
 	if (ret) {
 		crypto_unregister_alg(&alg_lz4);
+		crypto_unregister_alg(&alg_lz4_dyn);
 		return ret;
 	}
 
diff --git a/drivers/block/zram/zcomp.c b/drivers/block/zram/zcomp.c
index 4ed0a78..5bc5aab 100644
--- a/drivers/block/zram/zcomp.c
+++ b/drivers/block/zram/zcomp.c
@@ -17,11 +17,15 @@
 #include <linux/crypto.h>
 
 #include "zcomp.h"
+#define KB	(1 << 10)
 
 static const char * const backends[] = {
 	"lzo",
 #if IS_ENABLED(CONFIG_CRYPTO_LZ4)
 	"lz4",
+#if (PAGE_SIZE < (32 * KB))
+	"lz4_dyn",
+#endif
 #endif
 #if IS_ENABLED(CONFIG_CRYPTO_LZ4HC)
 	"lz4hc",
diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index 6910321..2b03449 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -342,7 +342,7 @@ static int compress_lz4(const void *in, void *out, size_t inlen, size_t outlen)
 {
 	int ret;
 
-	ret = LZ4_compress_default(in, out, inlen, outlen, workspace);
+	ret = LZ4_compress_default(in, out, inlen, outlen, workspace, false);
 	if (!ret) {
 		pr_err("LZ4_compress_default error; compression failed!\n");
 		return -EIO;
diff --git a/include/linux/lz4.h b/include/linux/lz4.h
index 394e3d9..08bb95d 100644
--- a/include/linux/lz4.h
+++ b/include/linux/lz4.h
@@ -181,6 +181,9 @@ static inline int LZ4_compressBound(size_t isize)
  *	which must be already allocated
  * @wrkmem: address of the working memory.
  *	This requires 'workmem' of LZ4_MEM_COMPRESS.
+ * @dynoffset: 1 or 0.
+ *  1 specifies dynamic offset. (1 byte or 2 byte based on offset value),
+ *  0 specifies normal offset.  (2 bytes for each offset value).
  *
  * Compresses 'sourceSize' bytes from buffer 'source'
  * into already allocated 'dest' buffer of size 'maxOutputSize'.
@@ -195,7 +198,7 @@ static inline int LZ4_compressBound(size_t isize)
  *	(necessarily <= maxOutputSize) or 0 if compression fails
  */
 int LZ4_compress_default(const char *source, char *dest, int inputSize,
-	int maxOutputSize, void *wrkmem);
+	int maxOutputSize, void *wrkmem, bool dynOffset);
 
 /**
  * LZ4_compress_fast() - As LZ4_compress_default providing an acceleration param
@@ -207,6 +210,9 @@ int LZ4_compress_default(const char *source, char *dest, int inputSize,
  * @acceleration: acceleration factor
  * @wrkmem: address of the working memory.
  *	This requires 'workmem' of LZ4_MEM_COMPRESS.
+ * @dynoffset: 1 or 0.
+ *  1 specifies dynamic offset. (1 byte or 2 byte based on offset value),
+ *  0 specifies normal offset.  (2 bytes for each offset value).
  *
  * Same as LZ4_compress_default(), but allows to select an "acceleration"
  * factor. The larger the acceleration value, the faster the algorithm,
@@ -219,7 +225,7 @@ int LZ4_compress_default(const char *source, char *dest, int inputSize,
  *	(necessarily <= maxOutputSize) or 0 if compression fails
  */
 int LZ4_compress_fast(const char *source, char *dest, int inputSize,
-	int maxOutputSize, int acceleration, void *wrkmem);
+	int maxOutputSize, int acceleration, void *wrkmem, bool dynOffset);
 
 /**
  * LZ4_compress_destSize() - Compress as much data as possible
@@ -277,6 +283,9 @@ int LZ4_compress_destSize(const char *source, char *dest, int *sourceSizePtr,
  *	which must be already allocated
  * @compressedSize: is the precise full size of the compressed block
  * @maxDecompressedSize: is the size of 'dest' buffer
+ * @dynoffset: 1 or 0.
+ *  1 specifies dynamic offset. (1 byte or 2 byte based on offset value),
+ *  0 specifies normal offset.  (2 bytes for each offset value).
  *
  * Decompresses data fom 'source' into 'dest'.
  * If the source stream is detected malformed, the function will
@@ -290,7 +299,7 @@ int LZ4_compress_destSize(const char *source, char *dest, int *sourceSizePtr,
  *	or a negative result in case of error
  */
 int LZ4_decompress_safe(const char *source, char *dest, int compressedSize,
-	int maxDecompressedSize);
+	int maxDecompressedSize, bool dynOffset);
 
 /**
  * LZ4_decompress_safe_partial() - Decompress a block of size 'compressedSize'
diff --git a/lib/decompress_unlz4.c b/lib/decompress_unlz4.c
index 1b0baf3..8be2faa 100644
--- a/lib/decompress_unlz4.c
+++ b/lib/decompress_unlz4.c
@@ -158,7 +158,7 @@ STATIC inline int INIT unlz4(u8 *input, long in_len,
 #else
 		dest_len = uncomp_chunksize;
 
-		ret = LZ4_decompress_safe(inp, outp, chunksize, dest_len);
+		ret = LZ4_decompress_safe(inp, outp, chunksize, dest_len, false);
 		dest_len = ret;
 #endif
 		if (ret < 0) {
diff --git a/lib/lz4/lz4_compress.c b/lib/lz4/lz4_compress.c
index cc7b6d4..185c358 100644
--- a/lib/lz4/lz4_compress.c
+++ b/lib/lz4/lz4_compress.c
@@ -183,7 +183,8 @@ static FORCE_INLINE int LZ4_compress_generic(
 	const tableType_t tableType,
 	const dict_directive dict,
 	const dictIssue_directive dictIssue,
-	const U32 acceleration)
+	const U32 acceleration,
+	const Dynamic_Offset dynOffset)
 {
 	const BYTE *ip = (const BYTE *) source;
 	const BYTE *base;
@@ -199,6 +200,7 @@ static FORCE_INLINE int LZ4_compress_generic(
 
 	BYTE *op = (BYTE *) dest;
 	BYTE * const olimit = op + maxOutputSize;
+	int max_distance = dynOffset ? MAX_DISTANCE_DYN : MAX_DISTANCE;
 
 	U32 forwardH;
 	size_t refDelta = 0;
@@ -245,6 +247,7 @@ static FORCE_INLINE int LZ4_compress_generic(
 	for ( ; ; ) {
 		const BYTE *match;
 		BYTE *token;
+		int curr_offset;
 
 		/* Find a match */
 		{
@@ -285,7 +288,7 @@ static FORCE_INLINE int LZ4_compress_generic(
 					: 0)
 				|| ((tableType == byU16)
 					? 0
-					: (match + MAX_DISTANCE < ip))
+					: (match + max_distance < ip))
 				|| (LZ4_read32(match + refDelta)
 					!= LZ4_read32(ip)));
 		}
@@ -328,8 +331,26 @@ static FORCE_INLINE int LZ4_compress_generic(
 
 _next_match:
 		/* Encode Offset */
-		LZ4_writeLE16(op, (U16)(ip - match));
-		op += 2;
+		if (dynOffset) {
+			curr_offset = (U16)(ip - match);
+
+			/*
+			 * If Ofsset is greater than 127, we need 2 bytes
+			 * to store it. Otherwise 1 byte is enough.
+			 */
+			if (curr_offset > 127) {
+				curr_offset = (curr_offset << 1) | DYN_BIT;
+				LZ4_writeLE16(op, (U16)curr_offset);
+				op += 2;
+			} else {
+				curr_offset = curr_offset << 1;
+				*op = (BYTE)curr_offset;
+				op++;
+			}
+		} else {
+			LZ4_writeLE16(op, (U16)(ip - match));
+			op += 2;
+		}
 
 		/* Encode MatchLength */
 		{
@@ -480,39 +501,70 @@ static int LZ4_compress_fast_extState(
 			return LZ4_compress_generic(ctx, source,
 				dest, inputSize, 0,
 				noLimit, byU16, noDict,
-				noDictIssue, acceleration);
+				noDictIssue, acceleration, NoDynOffset);
 		else
 			return LZ4_compress_generic(ctx, source,
 				dest, inputSize, 0,
 				noLimit, tableType, noDict,
-				noDictIssue, acceleration);
+				noDictIssue, acceleration, NoDynOffset);
 	} else {
 		if (inputSize < LZ4_64Klimit)
 			return LZ4_compress_generic(ctx, source,
 				dest, inputSize,
 				maxOutputSize, limitedOutput, byU16, noDict,
-				noDictIssue, acceleration);
+				noDictIssue, acceleration, NoDynOffset);
 		else
 			return LZ4_compress_generic(ctx, source,
 				dest, inputSize,
 				maxOutputSize, limitedOutput, tableType, noDict,
-				noDictIssue, acceleration);
+				noDictIssue, acceleration, NoDynOffset);
 	}
 }
 
+static int LZ4_compress_fast_extState_dynamic(
+	void *state,
+	const char *source,
+	char *dest,
+	int inputSize,
+	int maxOutputSize,
+	int acceleration)
+{
+	LZ4_stream_t_internal *ctx = &((LZ4_stream_t *)state)->internal_donotuse;
+
+	LZ4_resetStream((LZ4_stream_t *)state);
+
+	if (acceleration < 1)
+		acceleration = LZ4_ACCELERATION_DEFAULT;
+
+	if (maxOutputSize >= LZ4_COMPRESSBOUND(inputSize))
+		return LZ4_compress_generic(ctx, source,
+			dest, inputSize, 0,
+			noLimit, byU16, noDict,
+			noDictIssue, acceleration, DynOffset);
+	else
+		return LZ4_compress_generic(ctx, source,
+			dest, inputSize,
+			maxOutputSize, limitedOutput, byU16, noDict,
+			noDictIssue, acceleration, DynOffset);
+}
+
 int LZ4_compress_fast(const char *source, char *dest, int inputSize,
-	int maxOutputSize, int acceleration, void *wrkmem)
+	int maxOutputSize, int acceleration, void *wrkmem, bool dynOffset)
 {
-	return LZ4_compress_fast_extState(wrkmem, source, dest, inputSize,
+	if (!dynOffset)
+		return LZ4_compress_fast_extState(wrkmem, source, dest, inputSize,
+			maxOutputSize, acceleration);
+
+	return LZ4_compress_fast_extState_dynamic(wrkmem, source, dest, inputSize,
 		maxOutputSize, acceleration);
 }
 EXPORT_SYMBOL(LZ4_compress_fast);
 
 int LZ4_compress_default(const char *source, char *dest, int inputSize,
-	int maxOutputSize, void *wrkmem)
+	int maxOutputSize, void *wrkmem, bool dynOffset)
 {
 	return LZ4_compress_fast(source, dest, inputSize,
-		maxOutputSize, LZ4_ACCELERATION_DEFAULT, wrkmem);
+		maxOutputSize, LZ4_ACCELERATION_DEFAULT, wrkmem, dynOffset);
 }
 EXPORT_SYMBOL(LZ4_compress_default);
 
@@ -900,12 +952,12 @@ int LZ4_compress_fast_continue(LZ4_stream_t *LZ4_stream, const char *source,
 			result = LZ4_compress_generic(
 				streamPtr, source, dest, inputSize,
 				maxOutputSize, limitedOutput, byU32,
-				withPrefix64k, dictSmall, acceleration);
+				withPrefix64k, dictSmall, acceleration, NoDynOffset);
 		} else {
 			result = LZ4_compress_generic(
 				streamPtr, source, dest, inputSize,
 				maxOutputSize, limitedOutput, byU32,
-				withPrefix64k, noDictIssue, acceleration);
+				withPrefix64k, noDictIssue, acceleration, NoDynOffset);
 		}
 		streamPtr->dictSize += (U32)inputSize;
 		streamPtr->currentOffset += (U32)inputSize;
@@ -921,12 +973,12 @@ int LZ4_compress_fast_continue(LZ4_stream_t *LZ4_stream, const char *source,
 			result = LZ4_compress_generic(
 				streamPtr, source, dest, inputSize,
 				maxOutputSize, limitedOutput, byU32,
-				usingExtDict, dictSmall, acceleration);
+				usingExtDict, dictSmall, acceleration, NoDynOffset);
 		} else {
 			result = LZ4_compress_generic(
 				streamPtr, source, dest, inputSize,
 				maxOutputSize, limitedOutput, byU32,
-				usingExtDict, noDictIssue, acceleration);
+				usingExtDict, noDictIssue, acceleration, NoDynOffset);
 		}
 		streamPtr->dictionary = (const BYTE *)source;
 		streamPtr->dictSize = (U32)inputSize;
diff --git a/lib/lz4/lz4_decompress.c b/lib/lz4/lz4_decompress.c
index 141734d..337a828 100644
--- a/lib/lz4/lz4_decompress.c
+++ b/lib/lz4/lz4_decompress.c
@@ -71,7 +71,9 @@ static FORCE_INLINE int LZ4_decompress_generic(
 	 /* only if dict == usingExtDict */
 	 const BYTE * const dictStart,
 	 /* note : = 0 if noDict */
-	 const size_t dictSize
+	 const size_t dictSize,
+	 /* offset == 1; dynamic offset */
+	 const Dynamic_Offset dynOffset
 	 )
 {
 	/* Local Variables */
@@ -141,8 +143,8 @@ static FORCE_INLINE int LZ4_decompress_generic(
 		/* copy literals */
 		cpy = op + length;
 		if (((endOnInput) && ((cpy > (partialDecoding ? oexit : oend - MFLIMIT))
-			|| (ip + length > iend - (2 + 1 + LASTLITERALS))))
-			|| ((!endOnInput) && (cpy > oend - WILDCOPYLENGTH))) {
+			|| (ip + length > iend - (2 + LASTLITERALS))))
+			|| ((!endOnInput) && (cpy > oend - WILDCOPYLENGTH - 1))) {
 			if (partialDecoding) {
 				if (cpy > oend) {
 					/*
@@ -188,13 +190,31 @@ static FORCE_INLINE int LZ4_decompress_generic(
 			break;
 		}
 
-		LZ4_wildCopy(op, ip, cpy);
+		if (dynOffset && length < 4)
+			LZ4_copy4(op, ip);
+		else
+			LZ4_wildCopy(op, ip, cpy);
+
 		ip += length;
 		op = cpy;
 
 		/* get offset */
-		offset = LZ4_readLE16(ip);
-		ip += 2;
+		if (dynOffset) {
+			/*
+			 * Check if DYN_BIT is set, means 2 Byte Offset,
+			 * else 1 Byte Offset.
+			 */
+			if (*ip & DYN_BIT) {
+				offset = LZ4_readLE16(ip) >> 1;
+				ip += 2;
+			} else {
+				offset = *ip >> 1;
+				ip += 1;
+			}
+		} else {
+			offset = LZ4_readLE16(ip);
+			ip += 2;
+		}
 		match = op - offset;
 
 		if ((checkOffset) && (unlikely(match < lowLimit))) {
@@ -335,11 +355,11 @@ static FORCE_INLINE int LZ4_decompress_generic(
 }
 
 int LZ4_decompress_safe(const char *source, char *dest,
-	int compressedSize, int maxDecompressedSize)
+	int compressedSize, int maxDecompressedSize, bool dynOffset)
 {
 	return LZ4_decompress_generic(source, dest, compressedSize,
 		maxDecompressedSize, endOnInputSize, full, 0,
-		noDict, (BYTE *)dest, NULL, 0);
+		noDict, (BYTE *)dest, NULL, 0, dynOffset);
 }
 
 int LZ4_decompress_safe_partial(const char *source, char *dest,
@@ -347,14 +367,14 @@ int LZ4_decompress_safe_partial(const char *source, char *dest,
 {
 	return LZ4_decompress_generic(source, dest, compressedSize,
 		maxDecompressedSize, endOnInputSize, partial,
-		targetOutputSize, noDict, (BYTE *)dest, NULL, 0);
+		targetOutputSize, noDict, (BYTE *)dest, NULL, 0, NoDynOffset);
 }
 
 int LZ4_decompress_fast(const char *source, char *dest, int originalSize)
 {
 	return LZ4_decompress_generic(source, dest, 0, originalSize,
 		endOnOutputSize, full, 0, withPrefix64k,
-		(BYTE *)(dest - 64 * KB), NULL, 64 * KB);
+		(BYTE *)(dest - 64 * KB), NULL, 64 * KB, NoDynOffset);
 }
 
 int LZ4_setStreamDecode(LZ4_streamDecode_t *LZ4_streamDecode,
@@ -392,7 +412,7 @@ int LZ4_decompress_safe_continue(LZ4_streamDecode_t *LZ4_streamDecode,
 			endOnInputSize, full, 0,
 			usingExtDict, lz4sd->prefixEnd - lz4sd->prefixSize,
 			lz4sd->externalDict,
-			lz4sd->extDictSize);
+			lz4sd->extDictSize, NoDynOffset);
 
 		if (result <= 0)
 			return result;
@@ -406,7 +426,7 @@ int LZ4_decompress_safe_continue(LZ4_streamDecode_t *LZ4_streamDecode,
 			compressedSize, maxOutputSize,
 			endOnInputSize, full, 0,
 			usingExtDict, (BYTE *)dest,
-			lz4sd->externalDict, lz4sd->extDictSize);
+			lz4sd->externalDict, lz4sd->extDictSize, NoDynOffset);
 		if (result <= 0)
 			return result;
 		lz4sd->prefixSize = result;
@@ -427,7 +447,7 @@ int LZ4_decompress_fast_continue(LZ4_streamDecode_t *LZ4_streamDecode,
 			endOnOutputSize, full, 0,
 			usingExtDict,
 			lz4sd->prefixEnd - lz4sd->prefixSize,
-			lz4sd->externalDict, lz4sd->extDictSize);
+			lz4sd->externalDict, lz4sd->extDictSize, NoDynOffset);
 
 		if (result <= 0)
 			return result;
@@ -440,7 +460,7 @@ int LZ4_decompress_fast_continue(LZ4_streamDecode_t *LZ4_streamDecode,
 		result = LZ4_decompress_generic(source, dest, 0, originalSize,
 			endOnOutputSize, full, 0,
 			usingExtDict, (BYTE *)dest,
-			lz4sd->externalDict, lz4sd->extDictSize);
+			lz4sd->externalDict, lz4sd->extDictSize, NoDynOffset);
 		if (result <= 0)
 			return result;
 		lz4sd->prefixSize = originalSize;
@@ -463,19 +483,19 @@ static FORCE_INLINE int LZ4_decompress_usingDict_generic(const char *source,
 	if (dictSize == 0)
 		return LZ4_decompress_generic(source, dest,
 			compressedSize, maxOutputSize, safe, full, 0,
-			noDict, (BYTE *)dest, NULL, 0);
+			noDict, (BYTE *)dest, NULL, 0, NoDynOffset);
 	if (dictStart + dictSize == dest) {
 		if (dictSize >= (int)(64 * KB - 1))
 			return LZ4_decompress_generic(source, dest,
 				compressedSize, maxOutputSize, safe, full, 0,
-				withPrefix64k, (BYTE *)dest - 64 * KB, NULL, 0);
+				withPrefix64k, (BYTE *)dest - 64 * KB, NULL, 0, NoDynOffset);
 		return LZ4_decompress_generic(source, dest, compressedSize,
 			maxOutputSize, safe, full, 0, noDict,
-			(BYTE *)dest - dictSize, NULL, 0);
+			(BYTE *)dest - dictSize, NULL, 0, NoDynOffset);
 	}
 	return LZ4_decompress_generic(source, dest, compressedSize,
 		maxOutputSize, safe, full, 0, usingExtDict,
-		(BYTE *)dest, (const BYTE *)dictStart, dictSize);
+		(BYTE *)dest, (const BYTE *)dictStart, dictSize, NoDynOffset);
 }
 
 int LZ4_decompress_safe_usingDict(const char *source, char *dest,
diff --git a/lib/lz4/lz4defs.h b/lib/lz4/lz4defs.h
index 00a0b58..9451a73 100644
--- a/lib/lz4/lz4defs.h
+++ b/lib/lz4/lz4defs.h
@@ -75,6 +75,7 @@
 #define WILDCOPYLENGTH 8
 #define LASTLITERALS 5
 #define MFLIMIT (WILDCOPYLENGTH + MINMATCH)
+#define DYN_BIT 0x1
 
 /* Increase this value ==> compression run slower on incompressible data */
 #define LZ4_SKIPTRIGGER 6
@@ -87,6 +88,7 @@
 
 #define MAXD_LOG 16
 #define MAX_DISTANCE ((1 << MAXD_LOG) - 1)
+#define MAX_DISTANCE_DYN ((1 << (MAXD_LOG - 1)) - 1)
 #define STEPSIZE sizeof(size_t)
 
 #define ML_BITS	4
@@ -147,6 +149,13 @@ static FORCE_INLINE void LZ4_copy8(void *dst, const void *src)
 #endif
 }
 
+static FORCE_INLINE void LZ4_copy4(void *dst, const void *src)
+{
+	U32 a = get_unaligned((const U32 *)src);
+
+	put_unaligned(a, (U32 *)dst);
+}
+
 /*
  * customized variant of memcpy,
  * which can overwrite up to 7 bytes beyond dstEnd
@@ -224,4 +233,6 @@ static FORCE_INLINE unsigned int LZ4_count(
 typedef enum { endOnOutputSize = 0, endOnInputSize = 1 } endCondition_directive;
 typedef enum { full = 0, partial = 1 } earlyEnd_directive;
 
+typedef enum { NoDynOffset = 0, DynOffset = 1 } Dynamic_Offset;
+
 #endif
-- 
1.7.1
