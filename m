Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=210.118.77.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793976174;
	b=mjVl2+2GDzHuiQTzv7Bc6mGhSjdl5m0QsiBI6Mh/yNoOt97ylRb53MDYwYj3QgoFv60c
	 eqbmY9YzD5+mg2aCLi2ol8+m54SL4RDhYT7jZHWjIsD0RvWHt7mcRQ1Cg+C8T7X4uW60+
	 8vhp69ACWdzio+Zbvk/TfqfSAAEJ3CVc+srm6/fQ9tuPliF7VxYoy4+/MVvqrJYVlsW0S
	 OQvig7if3KFIfxs4GInZXoPFEmLP5uDV9ADP7xNmvrehHc6nXlpa1AV1QKQqw6PHvAqgX
	 ddRICqxvfHPYvDgM/1CbPGrWD15bW9z0Lh+fLzGkQvjOoojQ1p9ZO1DDgWMlJXiW2EQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793976174;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 From:Date:Subject:MIME-Version:Content-Transfer-Encoding:Message-Id:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-CMS-MailID:X-Msg-Generator:Content-Type:X-RootMTR:X-EPHeader:
	 X-CMS-RootMailID:References;
	bh=78E49OBy2vOoRp7AN/TR4ZTGCJZbMDDSfbiqD0uAN1c=;
	b=uZcqDCSa0+UfHLJVzcQTjVLWBy2lnj9Ti5XYy9sH8k4UtHPhyuk98QfHDnWRICinmN7/
	 IXmHnsbWyrcQJwR+DMd6cg/I7jiCDbOC41SV7Pe2rHK5Ph7nIoVLuY8N34tVQkSJ/3hJ9
	 TDYuZwaNbBZSzByoRG09dIgTMjtJ5hDBf4iB5Z+7ombpZ7GihuAH0uWuDY5JuJuHiKYpD
	 rOJBgRHQEYEV+I5Y3ZguFyDHp1IkVrIAtrih2uM3CJmy8OWc6ahkXk1g5Uf+dRvk85Q5t
	 NfFSnrF+ArFQ2OMFjvKrGDeKfz+tpcZI6JUPXNYGcP0HNNdUqyviCUkFUpY+jOuKzNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=M8gZZwbj;
	arc=none smtp.remote-ip=210.118.77.11
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC03F606A339;
	Fri,  6 Nov 2026 14:42:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EC03F606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=M8gZZwbj
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20261106144251euoutp0124c3e0e8100b38fae754f436843806e8~le9Kc-C1K2317823178euoutp01Q;
	Fri,  6 Nov 2026 14:42:51 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20261106144251euoutp0124c3e0e8100b38fae754f436843806e8~le9Kc-C1K2317823178euoutp01Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1793976171;
	bh=78E49OBy2vOoRp7AN/TR4ZTGCJZbMDDSfbiqD0uAN1c=;
	h=From:Date:Subject:In-Reply-To:To:Cc:References:From;
	b=M8gZZwbjD4LgP+xP0uC24mjXC9kKwoMA/TiWFSHNOnP9zE5gyBdPfBpVXF2Y7o78u
	 JwPYDfW9yoAJKd7B7pt0Y/A1+ivUHknlVBTlWJNJjwfsurupjK6UuIo8GeqoOQqQpZ
	 n79l67FhNKVWWq212/kD400VVKiW+DDI1gdDo6Ms=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20261106144250eucas1p23dbd9566bcf265bb48728cedff315031~le9KDaSv51206712067eucas1p2W;
	Fri,  6 Nov 2026 14:42:50 +0000 (GMT)
Received: from AMDC4942.eu.corp.samsungelectronics.net (unknown
	[106.210.136.40]) by eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261106144249eusmtip1c345bf2ed8b7c6eeaaffcd2c9e7cf626~le9IhzIcG0491904919eusmtip1d;
	Fri,  6 Nov 2026 14:42:48 +0000 (GMT)
From: Michal Wilczynski <m.wilczynski@samsung.com>
Date: Fri, 06 Nov 2026 15:42:42 +0100
Subject: [PATCH v2 02/15] lib/lz4: remove LZ4_decompress_fast() and its
 variants
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
Message-Id: <20261106-lz4-vendor-upstream-v2-2-ee04c3f0d7dc@samsung.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=10729;
	i=m.wilczynski@samsung.com; h=from:subject:message-id;
	bh=BKqLz3nPV4nIxU4/LOt8w19Fm/2lu9lum9paP/eOwAI=;
	b=owGbwMvMwCGWumv6zndzRCIZT6slMWS9fZ4iuFzskPBCtZnBN9LdLrLOYeBuFBe5Emr92Uuqm
	vX4hhXfO0pZGMQ4GGTFFFnObow2kvzH8LT8+ONfMHNYmUCGMHBxCsBELq5lZOh8PJFvteO7+ZP4
	xLVXTOmTahE0fHPxvebD+b9n3nRgsuFh+KeVqniopO3Uo1z3c6cOdG9pusOht23+pv3LtkrvWjF
	VqpIRAA==
X-Developer-Key: i=m.wilczynski@samsung.com; a=openpgp;
	fpr=CDB15B3219FE00E577C7E3FA65BA97B9EE9C1459
X-CMS-MailID: 20261106144250eucas1p23dbd9566bcf265bb48728cedff315031
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20261106144250eucas1p23dbd9566bcf265bb48728cedff315031
X-EPHeader: CA
X-CMS-RootMailID: 20261106144250eucas1p23dbd9566bcf265bb48728cedff315031
References: <20261106-lz4-vendor-upstream-v2-0-ee04c3f0d7dc@samsung.com>
	<CGME20261106144250eucas1p23dbd9566bcf265bb48728cedff315031@eucas1p2.samsung.com>

LZ4_decompress_fast(), LZ4_decompress_fast_continue() and
LZ4_decompress_fast_usingDict() have no users left. Upstream has
deprecated all three since v1.9: they take only the decompressed size,
so a corrupt or malicious stream has nothing to stop the decoder from
reading past the end of its input.

Remove them, their exports and their declarations in <linux/lz4.h>,
along with the two helpers only they used. Doing it before lib/lz4 moves
to upstream LZ4 keeps them out of the glue that move adds.

Signed-off-by: Michal Wilczynski <m.wilczynski@samsung.com>
---
 include/linux/lz4.h      | 81 ----------------------------------------------
 lib/lz4/lz4_decompress.c | 84 ------------------------------------------------
 2 files changed, 165 deletions(-)

diff --git a/include/linux/lz4.h b/include/linux/lz4.h
index ad6042a718b5428792b795db7a8d4ad44c24a985..0df69e2b1ad523c291e3a96ab5595df9239f7252 100644
--- a/include/linux/lz4.h
+++ b/include/linux/lz4.h
@@ -249,27 +249,6 @@ int LZ4_compress_destSize(const char *source, char *dest, int *sourceSizePtr,
  *	Decompression Functions
  **************************************************************************/
 
-/**
- * LZ4_decompress_fast() - Decompresses data from 'source' into 'dest'
- * @source: source address of the compressed data
- * @dest: output buffer address of the uncompressed data
- *	which must be already allocated with 'originalSize' bytes
- * @originalSize: is the original and therefore uncompressed size
- *
- * Decompresses data from 'source' into 'dest'.
- * This function fully respect memory boundaries for properly formed
- * compressed data.
- * It is a bit faster than LZ4_decompress_safe().
- * However, it does not provide any protection against intentionally
- * modified data stream (malicious input).
- * Use this function in trusted environment only
- * (data to decode comes from a trusted source).
- *
- * Return: number of bytes read from the source buffer
- *	or a negative result if decompression fails.
- */
-int LZ4_decompress_fast(const char *source, char *dest, int originalSize);
-
 /**
  * LZ4_decompress_safe() - Decompression protected against buffer overflow
  * @source: source address of the compressed data
@@ -561,44 +540,6 @@ int LZ4_decompress_safe_continue(LZ4_streamDecode_t *LZ4_streamDecode,
 	const char *source, char *dest, int compressedSize,
 	int maxDecompressedSize);
 
-/**
- * LZ4_decompress_fast_continue() - Decompress blocks in streaming mode
- * @LZ4_streamDecode: the 'LZ4_streamDecode_t' structure
- * @source: source address of the compressed data
- * @dest: output buffer address of the uncompressed data
- *	which must be already allocated with 'originalSize' bytes
- * @originalSize: is the original and therefore uncompressed size
- *
- * This decoding function allows decompression of multiple blocks
- * in "streaming" mode.
- * Previously decoded blocks *must* remain available at the memory position
- * where they were decoded (up to 64 KB)
- * In the case of a ring buffers, decoding buffer must be either :
- *    - Exactly same size as encoding buffer, with same update rule
- *      (block boundaries at same positions) In which case,
- *      the decoding & encoding ring buffer can have any size,
- *      including very small ones ( < 64 KB).
- *    - Larger than encoding buffer, by a minimum of maxBlockSize more bytes.
- *      maxBlockSize is implementation dependent.
- *      It's the maximum size you intend to compress into a single block.
- *      In which case, encoding and decoding buffers do not need
- *      to be synchronized, and encoding ring buffer can have any size,
- *      including small ones ( < 64 KB).
- *    - _At least_ 64 KB + 8 bytes + maxBlockSize.
- *      In which case, encoding and decoding buffers do not need to be
- *      synchronized, and encoding ring buffer can have any size,
- *      including larger than decoding buffer. W
- * Whenever these conditions are not possible, save the last 64KB of decoded
- * data into a safe buffer, and indicate where it is saved
- * using LZ4_setStreamDecode()
- *
- * Return: number of bytes decompressed into destination buffer
- *	(necessarily <= maxDecompressedSize)
- *	or a negative result in case of error
- */
-int LZ4_decompress_fast_continue(LZ4_streamDecode_t *LZ4_streamDecode,
-	const char *source, char *dest, int originalSize);
-
 /**
  * LZ4_decompress_safe_usingDict() - Same as LZ4_setStreamDecode()
  *	followed by LZ4_decompress_safe_continue()
@@ -623,28 +564,6 @@ int LZ4_decompress_safe_usingDict(const char *source, char *dest,
 	int compressedSize, int maxDecompressedSize, const char *dictStart,
 	int dictSize);
 
-/**
- * LZ4_decompress_fast_usingDict() - Same as LZ4_setStreamDecode()
- *	followed by LZ4_decompress_fast_continue()
- * @source: source address of the compressed data
- * @dest: output buffer address of the uncompressed data
- *	which must be already allocated with 'originalSize' bytes
- * @originalSize: is the original and therefore uncompressed size
- * @dictStart: pointer to the start of the dictionary in memory
- * @dictSize: size of dictionary
- *
- * This decoding function works the same as
- * a combination of LZ4_setStreamDecode() followed by
- * LZ4_decompress_fast_continue()
- * It is stand-alone, and doesn't need an LZ4_streamDecode_t structure.
- *
- * Return: number of bytes decompressed into destination buffer
- *	(necessarily <= maxDecompressedSize)
- *	or a negative result in case of error
- */
-int LZ4_decompress_fast_usingDict(const char *source, char *dest,
-	int originalSize, const char *dictStart, int dictSize);
-
 #define LZ4_DECOMPRESS_INPLACE_MARGIN(compressedSize)          (((compressedSize) >> 8) + 32)
 
 #ifndef LZ4_DISTANCE_MAX	/* history window size; can be user-defined at compile time */
diff --git a/lib/lz4/lz4_decompress.c b/lib/lz4/lz4_decompress.c
index 3a2cd9acada4a09ef70a344090d48167c46088a1..f89b0e547f2156990c16770f69f89e0d8b46156d 100644
--- a/lib/lz4/lz4_decompress.c
+++ b/lib/lz4/lz4_decompress.c
@@ -474,14 +474,6 @@ int LZ4_decompress_safe_partial(const char *src, char *dst,
 				      noDict, (BYTE *)dst, NULL, 0);
 }
 
-int LZ4_decompress_fast(const char *source, char *dest, int originalSize)
-{
-	return LZ4_decompress_generic(source, dest, 0, originalSize,
-				      endOnOutputSize, decode_full_block,
-				      withPrefix64k,
-				      (BYTE *)dest - 64 * KB, NULL, 0);
-}
-
 /* ===== Instantiate a few more decoding cases, used more than once. ===== */
 
 static int LZ4_decompress_safe_withPrefix64k(const char *source, char *dest,
@@ -517,17 +509,6 @@ static int LZ4_decompress_safe_forceExtDict(const char *source, char *dest,
 				      (const BYTE *)dictStart, dictSize);
 }
 
-static int LZ4_decompress_fast_extDict(const char *source, char *dest,
-				       int originalSize,
-				       const void *dictStart, size_t dictSize)
-{
-	return LZ4_decompress_generic(source, dest,
-				      0, originalSize,
-				      endOnOutputSize, decode_full_block,
-				      usingExtDict, (BYTE *)dest,
-				      (const BYTE *)dictStart, dictSize);
-}
-
 /*
  * The "double dictionary" mode, for use with e.g. ring buffers: the first part
  * of the dictionary is passed as prefix, and the second via dictStart + dictSize.
@@ -546,18 +527,6 @@ int LZ4_decompress_safe_doubleDict(const char *source, char *dest,
 				      (const BYTE *)dictStart, dictSize);
 }
 
-static FORCE_INLINE
-int LZ4_decompress_fast_doubleDict(const char *source, char *dest,
-				   int originalSize, size_t prefixSize,
-				   const void *dictStart, size_t dictSize)
-{
-	return LZ4_decompress_generic(source, dest,
-				      0, originalSize,
-				      endOnOutputSize, decode_full_block,
-				      usingExtDict, (BYTE *)dest - prefixSize,
-				      (const BYTE *)dictStart, dictSize);
-}
-
 /* ===== streaming decompression functions ===== */
 
 int LZ4_setStreamDecode(LZ4_streamDecode_t *LZ4_streamDecode,
@@ -636,45 +605,6 @@ int LZ4_decompress_safe_continue(LZ4_streamDecode_t *LZ4_streamDecode,
 	return result;
 }
 
-int LZ4_decompress_fast_continue(LZ4_streamDecode_t *LZ4_streamDecode,
-	const char *source, char *dest, int originalSize)
-{
-	LZ4_streamDecode_t_internal *lz4sd = &LZ4_streamDecode->internal_donotuse;
-	int result;
-
-	if (lz4sd->prefixSize == 0) {
-		assert(lz4sd->extDictSize == 0);
-		result = LZ4_decompress_fast(source, dest, originalSize);
-		if (result <= 0)
-			return result;
-		lz4sd->prefixSize = originalSize;
-		lz4sd->prefixEnd = (BYTE *)dest + originalSize;
-	} else if (lz4sd->prefixEnd == (BYTE *)dest) {
-		if (lz4sd->prefixSize >= 64 * KB - 1 ||
-		    lz4sd->extDictSize == 0)
-			result = LZ4_decompress_fast(source, dest,
-						     originalSize);
-		else
-			result = LZ4_decompress_fast_doubleDict(source, dest,
-				originalSize, lz4sd->prefixSize,
-				lz4sd->externalDict, lz4sd->extDictSize);
-		if (result <= 0)
-			return result;
-		lz4sd->prefixSize += originalSize;
-		lz4sd->prefixEnd  += originalSize;
-	} else {
-		lz4sd->extDictSize = lz4sd->prefixSize;
-		lz4sd->externalDict = lz4sd->prefixEnd - lz4sd->extDictSize;
-		result = LZ4_decompress_fast_extDict(source, dest,
-			originalSize, lz4sd->externalDict, lz4sd->extDictSize);
-		if (result <= 0)
-			return result;
-		lz4sd->prefixSize = originalSize;
-		lz4sd->prefixEnd = (BYTE *)dest + originalSize;
-	}
-	return result;
-}
-
 int LZ4_decompress_safe_usingDict(const char *source, char *dest,
 				  int compressedSize, int maxOutputSize,
 				  const char *dictStart, int dictSize)
@@ -693,26 +623,12 @@ int LZ4_decompress_safe_usingDict(const char *source, char *dest,
 		compressedSize, maxOutputSize, dictStart, dictSize);
 }
 
-int LZ4_decompress_fast_usingDict(const char *source, char *dest,
-				  int originalSize,
-				  const char *dictStart, int dictSize)
-{
-	if (dictSize == 0 || dictStart + dictSize == dest)
-		return LZ4_decompress_fast(source, dest, originalSize);
-
-	return LZ4_decompress_fast_extDict(source, dest, originalSize,
-		dictStart, dictSize);
-}
-
 #ifndef STATIC
 EXPORT_SYMBOL(LZ4_decompress_safe);
 EXPORT_SYMBOL(LZ4_decompress_safe_partial);
-EXPORT_SYMBOL(LZ4_decompress_fast);
 EXPORT_SYMBOL(LZ4_setStreamDecode);
 EXPORT_SYMBOL(LZ4_decompress_safe_continue);
-EXPORT_SYMBOL(LZ4_decompress_fast_continue);
 EXPORT_SYMBOL(LZ4_decompress_safe_usingDict);
-EXPORT_SYMBOL(LZ4_decompress_fast_usingDict);
 
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_DESCRIPTION("LZ4 decompressor");

-- 
2.34.1

