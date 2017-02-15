From: Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
Subject: [PATCH v8 5/5] lib/lz4: Remove back-compat wrappers
Date: Wed, 15 Feb 2017 19:16:38 +0100
Message-ID: <1487182598-15351-6-git-send-email-4sschmid@informatik.uni-hamburg.de>
References: <1482259992-16680-1-git-send-email-4sschmid@informatik.uni-hamburg.de>
 <1487182598-15351-1-git-send-email-4sschmid@informatik.uni-hamburg.de>
Cc: bongkyu.kim@lge.com, rsalvaterra@gmail.com,
        sergey.senozhatsky@gmail.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        anton@enomsg.org, ccross@android.com, keescook@chromium.org,
        tony.luck@intel.com,
        Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
To: akpm@linux-foundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1487182598-15351-1-git-send-email-4sschmid@informatik.uni-hamburg.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Remove the functions introduced as wrappers for providing backwards
compatibility to the prior LZ4 version.  They're not needed anymore since
there's no callers left.

Signed-off-by: Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
---
 include/linux/lz4.h      | 69 ------------------------------------------------
 lib/lz4/lz4_compress.c   | 22 ---------------
 lib/lz4/lz4_decompress.c | 42 -----------------------------
 lib/lz4/lz4hc_compress.c | 23 ----------------
 4 files changed, 156 deletions(-)

diff --git a/include/linux/lz4.h b/include/linux/lz4.h
index 1b0f8ca..394e3d9 100644
--- a/include/linux/lz4.h
+++ b/include/linux/lz4.h
@@ -173,18 +173,6 @@ static inline int LZ4_compressBound(size_t isize)
 }
 
 /**
- * lz4_compressbound() - For backwards compatibility; see LZ4_compressBound
- * @isize: Size of the input data
- *
- * Return: Max. size LZ4 may output in a "worst case" szenario
- *	(data not compressible)
- */
-static inline int lz4_compressbound(size_t isize)
-{
-	return LZ4_COMPRESSBOUND(isize);
-}
-
-/**
  * LZ4_compress_default() - Compress data from source to dest
  * @source: source address of the original data
  * @dest: output buffer address of the compressed data
@@ -257,20 +245,6 @@ int LZ4_compress_fast(const char *source, char *dest, int inputSize,
 int LZ4_compress_destSize(const char *source, char *dest, int *sourceSizePtr,
 	int targetDestSize, void *wrkmem);
 
-/*
- * lz4_compress() - For backward compatibility, see LZ4_compress_default
- * @src: source address of the original data
- * @src_len: size of the original data
- * @dst: output buffer address of the compressed data. This requires 'dst'
- *	of size LZ4_COMPRESSBOUND
- * @dst_len: is the output size, which is returned after compress done
- * @workmem: address of the working memory.
- *
- * Return: Success if return 0, Error if return < 0
- */
-int lz4_compress(const unsigned char *src, size_t src_len, unsigned char *dst,
-	size_t *dst_len, void *wrkmem);
-
 /*-************************************************************************
  *	Decompression Functions
  **************************************************************************/
@@ -346,34 +320,6 @@ int LZ4_decompress_safe(const char *source, char *dest, int compressedSize,
 int LZ4_decompress_safe_partial(const char *source, char *dest,
 	int compressedSize, int targetOutputSize, int maxDecompressedSize);
 
-/*
- * lz4_decompress_unknownoutputsize() - For backwards compatibility,
- *	see LZ4_decompress_safe
- * @src: source address of the compressed data
- * @src_len: is the input size, therefore the compressed size
- * @dest: output buffer address of the decompressed data
- *	which must be already allocated
- * @dest_len: is the max size of the destination buffer, which is
- *	returned with actual size of decompressed data after decompress done
- *
- * Return: Success if return 0, Error if return (< 0)
- */
-int lz4_decompress_unknownoutputsize(const unsigned char *src, size_t src_len,
-	unsigned char *dest, size_t *dest_len);
-
-/**
- * lz4_decompress() - For backwards cocmpatibility, see LZ4_decompress_fast
- * @src: source address of the compressed data
- * @src_len: is the input size, which is returned after decompress done
- * @dest: output buffer address of the decompressed data,
- *	which must be already allocated
- * @actual_dest_len: is the size of uncompressed data, supposing it's known
- *
- * Return: Success if return 0, Error if return (< 0)
- */
-int lz4_decompress(const unsigned char *src, size_t *src_len,
-	unsigned char *dest, size_t actual_dest_len);
-
 /*-************************************************************************
  *	LZ4 HC Compression
  **************************************************************************/
@@ -401,21 +347,6 @@ int LZ4_compress_HC(const char *src, char *dst, int srcSize, int dstCapacity,
 	int compressionLevel, void *wrkmem);
 
 /**
- * lz4hc_compress() - For backwards compatibility, see LZ4_compress_HC
- * @src: source address of the original data
- * @src_len: size of the original data
- * @dst: output buffer address of the compressed data. This requires 'dst'
- *	of size LZ4_COMPRESSBOUND.
- * @dst_len: is the output size, which is returned after compress done
- * @wrkmem: address of the working memory.
- *	This requires 'workmem' of size LZ4HC_MEM_COMPRESS.
- *
- * Return	: Success if return 0, Error if return (< 0)
- */
-int lz4hc_compress(const unsigned char *src, size_t src_len, unsigned char *dst,
-	size_t *dst_len, void *wrkmem);
-
-/**
  * LZ4_resetStreamHC() - Init an allocated 'LZ4_streamHC_t' structure
  * @streamHCPtr: pointer to the 'LZ4_streamHC_t' structure
  * @compressionLevel: Recommended values are between 4 and 9, although any
diff --git a/lib/lz4/lz4_compress.c b/lib/lz4/lz4_compress.c
index 53f313f..cc7b6d4 100644
--- a/lib/lz4/lz4_compress.c
+++ b/lib/lz4/lz4_compress.c
@@ -936,27 +936,5 @@ int LZ4_compress_fast_continue(LZ4_stream_t *LZ4_stream, const char *source,
 }
 EXPORT_SYMBOL(LZ4_compress_fast_continue);
 
-/*-******************************
- *	For backwards compatibility
- ********************************/
-int lz4_compress(const unsigned char *src, size_t src_len, unsigned char *dst,
-	size_t *dst_len, void *wrkmem) {
-	*dst_len = LZ4_compress_default(src, dst, src_len,
-		*dst_len, wrkmem);
-
-	/*
-	 * Prior lz4_compress will return -1 in case of error
-	 * and 0 on success
-	 * while new LZ4_compress_fast/default
-	 * returns 0 in case of error
-	 * and the output length on success
-	 */
-	if (!*dst_len)
-		return -1;
-	else
-		return 0;
-}
-EXPORT_SYMBOL(lz4_compress);
-
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_DESCRIPTION("LZ4 compressor");
diff --git a/lib/lz4/lz4_decompress.c b/lib/lz4/lz4_decompress.c
index b5e00a1..bd35743 100644
--- a/lib/lz4/lz4_decompress.c
+++ b/lib/lz4/lz4_decompress.c
@@ -493,46 +493,6 @@ int LZ4_decompress_fast_usingDict(const char *source, char *dest,
 		originalSize, 0, dictStart, dictSize);
 }
 
-/*-******************************
- *	For backwards compatibility
- ********************************/
-int lz4_decompress_unknownoutputsize(const unsigned char *src,
-	size_t src_len, unsigned char *dest, size_t *dest_len) {
-	*dest_len = LZ4_decompress_safe(src, dest,
-		src_len, *dest_len);
-
-	/*
-	 * Prior lz4_decompress_unknownoutputsize will return
-	 * 0 for success and a negative result for error
-	 * new LZ4_decompress_safe returns
-	 * - the length of data read on success
-	 * - and also a negative result on error
-	 * meaning when result > 0, we just return 0 here
-	 */
-	if (src_len > 0)
-		return 0;
-	else
-		return -1;
-}
-
-int lz4_decompress(const unsigned char *src, size_t *src_len,
-	unsigned char *dest, size_t actual_dest_len) {
-	*src_len = LZ4_decompress_fast(src, dest, actual_dest_len);
-
-	/*
-	 * Prior lz4_decompress will return
-	 * 0 for success and a negative result for error
-	 * new LZ4_decompress_fast returns
-	 * - the length of data read on success
-	 * - and also a negative result on error
-	 * meaning when result > 0, we just return 0 here
-	 */
-	if (*src_len > 0)
-		return 0;
-	else
-		return -1;
-}
-
 #ifndef STATIC
 EXPORT_SYMBOL(LZ4_decompress_safe);
 EXPORT_SYMBOL(LZ4_decompress_safe_partial);
@@ -542,8 +502,6 @@ EXPORT_SYMBOL(LZ4_decompress_safe_continue);
 EXPORT_SYMBOL(LZ4_decompress_fast_continue);
 EXPORT_SYMBOL(LZ4_decompress_safe_usingDict);
 EXPORT_SYMBOL(LZ4_decompress_fast_usingDict);
-EXPORT_SYMBOL(lz4_decompress_unknownoutputsize);
-EXPORT_SYMBOL(lz4_decompress);
 
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_DESCRIPTION("LZ4 decompressor");
diff --git a/lib/lz4/lz4hc_compress.c b/lib/lz4/lz4hc_compress.c
index e1fbf15..176f03b 100644
--- a/lib/lz4/lz4hc_compress.c
+++ b/lib/lz4/lz4hc_compress.c
@@ -765,28 +765,5 @@ int LZ4_saveDictHC(
 }
 EXPORT_SYMBOL(LZ4_saveDictHC);
 
-/*-******************************
- *	For backwards compatibility
- ********************************/
-int lz4hc_compress(const unsigned char *src, size_t src_len,
-	unsigned char *dst, size_t *dst_len, void *wrkmem)
-{
-	*dst_len = LZ4_compress_HC(src, dst, src_len,
-		*dst_len, LZ4HC_DEFAULT_CLEVEL, wrkmem);
-
-	/*
-	 * Prior lz4hc_compress will return -1 in case of error
-	 * and 0 on success
-	 * while new LZ4_compress_HC
-	 * returns 0 in case of error
-	 * and the output length on success
-	 */
-	if (!*dst_len)
-		return -1;
-	else
-		return 0;
-}
-EXPORT_SYMBOL(lz4hc_compress);
-
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_DESCRIPTION("LZ4 HC compressor");
-- 
2.1.4
