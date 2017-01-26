From: Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
Subject: [PATCH v5 5/5] lib/lz4: Remove back-compat wrappers
Date: Thu, 26 Jan 2017 08:57:35 +0100
Message-ID: <1485417455-31726-6-git-send-email-4sschmid@informatik.uni-hamburg.de>
References: <1482259992-16680-1-git-send-email-4sschmid@informatik.uni-hamburg.de>
 <1485417455-31726-1-git-send-email-4sschmid@informatik.uni-hamburg.de>
Cc: bongkyu.kim@lge.com, rsalvaterra@gmail.com,
        sergey.senozhatsky@gmail.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        anton@enomsg.org, ccross@android.com, keescook@chromium.org,
        tony.luck@intel.com,
        Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
To: akpm@linux-foundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1485417455-31726-1-git-send-email-4sschmid@informatik.uni-hamburg.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch removes the functions introduced as wrappers for providing
backwards compatibility to the prior LZ4 version.
They're not needed anymore since there's no callers left.

Signed-off-by: Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
---
 include/linux/lz4.h      | 73 ------------------------------------------------
 lib/lz4/lz4_compress.c   | 22 ---------------
 lib/lz4/lz4_decompress.c | 42 ----------------------------
 lib/lz4/lz4hc_compress.c | 23 ---------------
 4 files changed, 160 deletions(-)

diff --git a/include/linux/lz4.h b/include/linux/lz4.h
index 2072255..5958f7d 100644
--- a/include/linux/lz4.h
+++ b/include/linux/lz4.h
@@ -173,14 +173,6 @@ static inline int LZ4_compressBound(size_t isize)
 }
 
 /*
- * For backward compatibility
- */
-static inline int lz4_compressbound(size_t isize)
-{
-	return LZ4_COMPRESSBOUND(isize);
-}
-
-/*
  * LZ4_compress_default()
  *	Compresses 'sourceSize' bytes from buffer 'source'
  *	into already allocated 'dest' buffer of size 'maxOutputSize'.
@@ -249,23 +241,6 @@ int LZ4_compress_fast(const char *source, char *dest, int inputSize,
 int LZ4_compress_destSize(const char *source, char *dest, int *sourceSizePtr,
 	int targetDestSize, void *wrkmem);
 
-/*
- * lz4_compress()
- *	src    : source address of the original data
- *	src_len: size of the original data
- *	dst    : output buffer address of the compressed data
- *           This requires 'dst' of size LZ4_COMPRESSBOUND.
- *	dst_len: is the output size, which is returned after compress done
- *	workmem: address of the working memory.
- *           This requires 'workmem' of size LZ4_MEM_COMPRESS.
- *	return	: Success if return 0
- *            Error if return (< 0)
- *	note :	Destination buffer and workmem must be already allocated with
- *		the defined size.
- */
-int lz4_compress(const unsigned char *src, size_t src_len, unsigned char *dst,
-	size_t *dst_len, void *wrkmem);
-
 /*-************************************************************************
  *	Decompression Functions
  **************************************************************************/
@@ -340,37 +315,6 @@ int LZ4_decompress_safe(const char *source, char *dest, int compressedSize,
 int LZ4_decompress_safe_partial(const char *source, char *dest,
 	int compressedSize, int targetOutputSize, int maxDecompressedSize);
 
-
-/*
- * lz4_decompress_unknownoutputsize() :
- *	src     : source address of the compressed data
- *	src_len : is the input size, therefore the compressed size
- *	dest    : output buffer address of the decompressed data
- *	dest_len: is the max size of the destination buffer, which is
- *            returned with actual size of decompressed data after
- *            decompress done
- * return: Success if return 0
- *         Error if return (< 0)
- * note:   Destination buffer must be already allocated.
- */
-int lz4_decompress_unknownoutputsize(const unsigned char *src, size_t src_len,
-	unsigned char *dest, size_t *dest_len);
-
-/*
- * lz4_decompress() :
- *	src            : source address of the compressed data
- *	src_len        : is the input size,
- *                   which is returned after decompress done
- *	dest           : output buffer address of the decompressed data
- *	actual_dest_len: is the size of uncompressed data, supposing it's known
- *	return: Success if return 0
- *          Error if return (< 0)
- *	note  : Destination buffer must be already allocated.
- *          slightly faster than lz4_decompress_unknownoutputsize()
- */
-int lz4_decompress(const unsigned char *src, size_t *src_len,
-	unsigned char *dest, size_t actual_dest_len);
-
 /*-************************************************************************
  *	LZ4 HC Compression
  **************************************************************************/
@@ -399,23 +343,6 @@ int LZ4_compress_HC(const char *src, char *dst, int srcSize, int dstCapacity,
 	int compressionLevel, void *wrkmem);
 
 /*
- * lz4hc_compress()
- *	src    : source address of the original data
- *	src_len: size of the original data
- *	dst    : output buffer address of the compressed data
- *           This requires 'dst' of size LZ4_COMPRESSBOUND.
- *	dst_len: is the output size, which is returned after compress done
- *	workmem: address of the working memory.
- *           This requires 'workmem' of size LZ4HC_MEM_COMPRESS.
- * return	: Success if return 0
- *          Error if return (< 0)
- * note   : Destination buffer and workmem must be already allocated with
- *          the defined size.
- */
-int lz4hc_compress(const unsigned char *src, size_t src_len, unsigned char *dst,
-	size_t *dst_len, void *wrkmem);
-
-/*
  *	These functions compress data in successive blocks of any size,
  *	using previous blocks as dictionary. One key assumption is that previous
  *	blocks (up to 64 KB) remain read-accessible while
diff --git a/lib/lz4/lz4_compress.c b/lib/lz4/lz4_compress.c
index e595896..b625226 100644
--- a/lib/lz4/lz4_compress.c
+++ b/lib/lz4/lz4_compress.c
@@ -872,27 +872,5 @@ int LZ4_compress_fast_continue(LZ4_stream_t *LZ4_stream, const char *source,
 }
 EXPORT_SYMBOL(LZ4_compress_fast_continue);
 
-/*-******************************
- *	For backwards compatibility
- ********************************/
-int lz4_compress(const unsigned char *src, size_t src_len, unsigned char *dst,
-	size_t *dst_len, void *wrkmem) {
-	*dst_len = LZ4_compress_default(src, dst, (int)src_len,
-		(int)((size_t)dst_len), wrkmem);
-
-	/*
-	 * Prior lz4_compress will return -1 in case of error
-	 * and 0 on success
-	 * while new LZ4_compress_fast/default
-	 * returns 0 in case of error
-	 * and the output length on success
-	 */
-	if (!dst_len)
-		return -1;
-	else
-		return 0;
-}
-EXPORT_SYMBOL(lz4_compress);
-
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_DESCRIPTION("LZ4 compressor");
diff --git a/lib/lz4/lz4_decompress.c b/lib/lz4/lz4_decompress.c
index ca71375..053d09d 100644
--- a/lib/lz4/lz4_decompress.c
+++ b/lib/lz4/lz4_decompress.c
@@ -483,47 +483,5 @@ int LZ4_decompress_fast_usingDict(const char *source, char *dest,
 }
 EXPORT_SYMBOL(LZ4_decompress_fast_usingDict);
 
-/*-******************************
- *	For backwards compatibility
- ********************************/
-int lz4_decompress_unknownoutputsize(const unsigned char *src,
-	size_t src_len, unsigned char *dest, size_t *dest_len) {
-	 *dest_len = LZ4_decompress_safe(src, dest,
-		 (int)src_len, (int)((size_t)dest_len));
-
-		/*
-		 * Prior lz4_decompress_unknownoutputsize will return
-		 * 0 for success and a negative result for error
-		 * new LZ4_decompress_safe returns
-		 * - the length of data read on success
-		 * - and also a negative result on error
-		 * meaning when result > 0, we just return 0 here
-		 */
-		if (src_len > 0) {
-			return 0;
-		} else
-			return -1;
-}
-EXPORT_SYMBOL(lz4_decompress_unknownoutputsize);
-
-int lz4_decompress(const unsigned char *src, size_t *src_len,
-	unsigned char *dest, size_t actual_dest_len) {
-	*src_len = LZ4_decompress_fast(src, dest, (int)actual_dest_len);
-
-	/*
-	 * Prior lz4_decompress will return
-	 * 0 for success and a negative result for error
-	 * new LZ4_decompress_fast returns
-	 * - the length of data read on success
-	 * - and also a negative result on error
-	 * meaning when result > 0, we just return 0 here
-	 */
-	if ((int)((size_t)src_len) > 0)
-		return 0;
-	else
-		return -1;
-}
-EXPORT_SYMBOL(lz4_decompress);
-
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_DESCRIPTION("LZ4 decompressor");
diff --git a/lib/lz4/lz4hc_compress.c b/lib/lz4/lz4hc_compress.c
index 880c778..a29dad0 100644
--- a/lib/lz4/lz4hc_compress.c
+++ b/lib/lz4/lz4hc_compress.c
@@ -603,29 +603,6 @@ int LZ4_compress_HC(const char *src, char *dst, int srcSize,
 }
 EXPORT_SYMBOL(LZ4_compress_HC);
 
-/*-******************************
- *	For backwards compatibility
- ********************************/
-int lz4hc_compress(const unsigned char *src, size_t src_len,
-	unsigned char *dst, size_t *dst_len, void *wrkmem)
-{
-	*dst_len = LZ4_compress_HC(src, dst, (int)src_len,
-		(int)((size_t)dst_len), LZ4HC_DEFAULT_CLEVEL, wrkmem);
-
-	/*
-	 * Prior lz4hc_compress will return -1 in case of error
-	 * and 0 on success
-	 * while new LZ4_compress_HC
-	 * returns 0 in case of error
-	 * and the output length on success
-	 */
-	if (!dst_len)
-		return -1;
-	else
-		return 0;
-}
-EXPORT_SYMBOL(lz4hc_compress);
-
 /**************************************
  *	Streaming Functions
  **************************************/
-- 
2.1.4
