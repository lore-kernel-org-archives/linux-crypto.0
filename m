Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FB632111
	for <linux-crypto@vger.kernel.org>; Wed,  5 Mar 2025 03:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741146341; cv=none; b=hxpBhFgKPTvDOL6k9t3FoiEAhjid51XiRDK3doksiFmO94roIrHLA4fqa6Zo0hFESGVAoS3ZuiRxQltUUDMy9/8eIgZSHJ2+roM+gyryrJQ1FZWKyQKzL+5Hurcdl4uwRsPphbxTgVj2r+NQVPi8Idm5t5zImB9vbqjD+3Krjhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741146341; c=relaxed/simple;
	bh=Rf46o17AZVCbynKh8/lXJGw/SEfPC2qsuAgiGx5xhY8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nzt5roJwUHv6CtARc5TIfXHm/+hNlj7ugf7Rgf/xUcDs+QZIey5mP/wMojxoo/FQDNaDdPF+xDPrHqZbxbPtxutnOxEg4R8wJhDdjRbzoCQ6ErMVshWtv4LUCh27dcGafYh7qbWRKQcQ6z9urj/Wz678bp8085wLxN0JvoabKVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=tTaNxniR; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="tTaNxniR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=jRSbvlablJfGLKAJj0k0iPLsuWCK+JRDmY8QFewWCUA=; b=tTaNxniRAnlpMgLXP4J2bBIfqU
	baEuu26kxCSFrqpecZLx6JUubBDhxG8B7fZa4IvRXMuD1WZw3z5DGRAAPkOZXPV/VWJEzFSnxuagq
	LcyKSfHTKCQlIPi38ZM+B66jTAmjHZUVNvKx5tDmPQTaHIxDYIJvd/aNjEe+V7XzA0SME3c5v4Vib
	NxQKvRmVraUraOkS2F5EiEFMjDvvwo9Db2bfX+0gBC7PoMFTICc5BpX8nEB3D163k4JkaODv1xmpN
	hYUgqQmoKXmSBqDH4S1NMQg4sMmgyWZlJljXsgk7eZ+gEIa2lqeyj6ZV8rXNOFl2wBZHmWu2YGsEL
	DyWW9XdA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tpfhH-003rk4-1O;
	Wed, 05 Mar 2025 11:45:28 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 05 Mar 2025 11:45:27 +0800
Date: Wed, 5 Mar 2025 11:45:27 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 7/7] mm: zswap: Use acomp virtual address interface
Message-ID: <Z8fI1zdqBNGmqW2d@gondor.apana.org.au>
References: <Z8GH7VssQGR1ujHV@gondor.apana.org.au>
 <Z8Hcur3T82_FiONj@google.com>
 <Z8KrAk9Y52RDox2U@gondor.apana.org.au>
 <Z8KxVC1RBeh8DTKI@gondor.apana.org.au>
 <Z8YOVyGugHwAsvmO@google.com>
 <Z8ZzqOw9veZ2HGkk@gondor.apana.org.au>
 <Z8aByQ5kJZf47wzW@google.com>
 <Z8aZPcgzuaNR6N8L@gondor.apana.org.au>
 <dawjvaf3nbfd6hnaclhcih6sfjzeuusu6kwhklv3bpptwwjzsd@t4ln7cwu74lh>
 <Z8dm9HF9tm0sDfpt@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8dm9HF9tm0sDfpt@google.com>

On Tue, Mar 04, 2025 at 08:47:48PM +0000, Yosry Ahmed wrote:
>
> Yeah I have the same feeling that the handling is all over the place.
> Also, we don't want to introduce new map APIs, so anything we do for
> zswap should ideally work for zram.

I will be getting to zram next.  AFAIK all that's missing from
acomp is parameter support.  Once that is added we can convert
zram over to acomp and get rid of zcomp altogether.

> IIUC, what Herbert is suggesting is that we rework all of this to use SG
> lists to reduce copies, but I am not sure which copies can go away? We
> have one copy in the compression path that probably cannot go away.
> After the zsmalloc changes (and ignoring highmem), we have one copy in
> the decompression path for when objects span two pages. I think this
> will still happen with SG lists, except internally in the crypto API.

It's the decompression copy when the object spans two pages that
will disappear.  Because I have added SG support to LZO:

commit a81b9ed5287424aa7d6c191fca7019820fc1d130
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Sun Mar 2 13:56:22 2025 +0800

    crypto: lib/lzo - Add decompression scatterlist support
    
    Add lzo1x_decompress_safe_sg which handles a scatterlist as its
    input.  This is useful as pages often compress into large objects
    that straddle page boundaries so it takes extra effort to linearise
    them in the face of memory fragmentation.
    
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/include/linux/lzo.h b/include/linux/lzo.h
index 4d30e3624acd..f3686ec4aa84 100644
--- a/include/linux/lzo.h
+++ b/include/linux/lzo.h
@@ -1,6 +1,11 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #ifndef __LZO_H__
 #define __LZO_H__
+
+#include <linux/types.h>
+
+struct scatterlist;
+
 /*
  *  LZO Public Kernel Interface
  *  A mini subset of the LZO real-time data compression library
@@ -40,6 +45,10 @@ int lzorle1x_1_compress_safe(const unsigned char *src, size_t src_len,
 int lzo1x_decompress_safe(const unsigned char *src, size_t src_len,
 			  unsigned char *dst, size_t *dst_len);
 
+/* decompression with source SG list */
+int lzo1x_decompress_safe_sg(struct scatterlist *src, size_t src_len,
+			     unsigned char *dst, size_t *dst_len);
+
 /*
  * Return values (< 0 = Error)
  */
diff --git a/lib/lzo/Makefile b/lib/lzo/Makefile
index fc7b2b7ef4b2..276a7246af72 100644
--- a/lib/lzo/Makefile
+++ b/lib/lzo/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 lzo_compress-objs := lzo1x_compress.o lzo1x_compress_safe.o
-lzo_decompress-objs := lzo1x_decompress_safe.o
+lzo_decompress-objs := lzo1x_decompress_safe.o lzo1x_decompress_safe_sg.o
 
 obj-$(CONFIG_LZO_COMPRESS) += lzo_compress.o
 obj-$(CONFIG_LZO_DECOMPRESS) += lzo_decompress.o
diff --git a/lib/lzo/lzo1x_decompress_safe.c b/lib/lzo/lzo1x_decompress_safe.c
index c94f4928e188..e1da9725e33b 100644
--- a/lib/lzo/lzo1x_decompress_safe.c
+++ b/lib/lzo/lzo1x_decompress_safe.c
@@ -12,17 +12,26 @@
  *  Richard Purdie <rpurdie@openedhand.com>
  */
 
-#ifndef STATIC
+#include <linux/lzo.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
-#endif
-#include <linux/unaligned.h>
-#include <linux/lzo.h>
+#include <linux/scatterlist.h>
 #include "lzodefs.h"
 
-#define HAVE_IP(x)      ((size_t)(ip_end - ip) >= (size_t)(x))
-#define HAVE_OP(x)      ((size_t)(op_end - op) >= (size_t)(x))
+#undef INPUT_IS_LINEAR
+#ifndef HAVE_IP
+#define IP_LEFT()	(in + in_len - ip)
+#define HAVE_IP(x)      ((size_t)(in + in_len - ip) >= (size_t)(x))
 #define NEED_IP(x)      if (!HAVE_IP(x)) goto input_overrun
+#define GET_IP()	ip = in
+#define CHECK_IP()	NEED_IP(1)
+#define PUT_IP()	do {} while (0)
+#define INPUT		const unsigned char *in
+#define LZO_SG(name)	name
+#define INPUT_IS_LINEAR	1
+#endif
+
+#define HAVE_OP(x)      ((size_t)(op_end - op) >= (size_t)(x))
 #define NEED_OP(x)      if (!HAVE_OP(x)) goto output_overrun
 #define TEST_LB(m_pos)  if ((m_pos) < out) goto lookbehind_overrun
 
@@ -36,34 +45,34 @@
  */
 #define MAX_255_COUNT      ((((size_t)~0) / 255) - 2)
 
-int lzo1x_decompress_safe(const unsigned char *in, size_t in_len,
-			  unsigned char *out, size_t *out_len)
+int LZO_SG(lzo1x_decompress_safe)(INPUT, size_t in_len,
+				  unsigned char *out, size_t *out_len)
 {
+	struct sg_mapping_iter miter __maybe_unused;
 	unsigned char *op;
 	const unsigned char *ip;
 	size_t t, next;
 	size_t state = 0;
 	const unsigned char *m_pos;
-	const unsigned char * const ip_end = in + in_len;
 	unsigned char * const op_end = out + *out_len;
-
 	unsigned char bitstream_version;
+	int err;
 
 	op = out;
-	ip = in;
-
-	if (unlikely(in_len < 3))
-		goto input_overrun;
+	GET_IP();
 
 	if (likely(in_len >= 5) && likely(*ip == 17)) {
-		bitstream_version = ip[1];
-		ip += 2;
+		ip++;
+		CHECK_IP();
+		bitstream_version = *ip++;
+		CHECK_IP();
 	} else {
 		bitstream_version = 0;
 	}
 
 	if (*ip > 17) {
 		t = *ip++ - 17;
+		CHECK_IP();
 		if (t < 4) {
 			next = t;
 			goto match_next;
@@ -73,22 +82,23 @@ int lzo1x_decompress_safe(const unsigned char *in, size_t in_len,
 
 	for (;;) {
 		t = *ip++;
+		CHECK_IP();
 		if (t < 16) {
 			if (likely(state == 0)) {
 				if (unlikely(t == 0)) {
-					size_t offset;
-					const unsigned char *ip_last = ip;
+					size_t offset = 0;
 
 					while (unlikely(*ip == 0)) {
 						ip++;
-						NEED_IP(1);
+						CHECK_IP();
+						offset++;
 					}
-					offset = ip - ip_last;
 					if (unlikely(offset > MAX_255_COUNT))
 						return LZO_E_ERROR;
 
 					offset = (offset << 8) - offset;
 					t += offset + 15 + *ip++;
+					CHECK_IP();
 				}
 				t += 3;
 copy_literal_run:
@@ -110,9 +120,9 @@ int lzo1x_decompress_safe(const unsigned char *in, size_t in_len,
 #endif
 				{
 					NEED_OP(t);
-					NEED_IP(t + 3);
 					do {
 						*op++ = *ip++;
+						CHECK_IP();
 					} while (--t > 0);
 				}
 				state = 4;
@@ -122,6 +132,7 @@ int lzo1x_decompress_safe(const unsigned char *in, size_t in_len,
 				m_pos = op - 1;
 				m_pos -= t >> 2;
 				m_pos -= *ip++ << 2;
+				CHECK_IP();
 				TEST_LB(m_pos);
 				NEED_OP(2);
 				op[0] = m_pos[0];
@@ -133,6 +144,7 @@ int lzo1x_decompress_safe(const unsigned char *in, size_t in_len,
 				m_pos = op - (1 + M2_MAX_OFFSET);
 				m_pos -= t >> 2;
 				m_pos -= *ip++ << 2;
+				CHECK_IP();
 				t = 3;
 			}
 		} else if (t >= 64) {
@@ -140,45 +152,48 @@ int lzo1x_decompress_safe(const unsigned char *in, size_t in_len,
 			m_pos = op - 1;
 			m_pos -= (t >> 2) & 7;
 			m_pos -= *ip++ << 3;
+			CHECK_IP();
 			t = (t >> 5) - 1 + (3 - 1);
 		} else if (t >= 32) {
 			t = (t & 31) + (3 - 1);
 			if (unlikely(t == 2)) {
-				size_t offset;
-				const unsigned char *ip_last = ip;
+				size_t offset = 0;
 
 				while (unlikely(*ip == 0)) {
 					ip++;
-					NEED_IP(1);
+					CHECK_IP();
+					offset++;
 				}
-				offset = ip - ip_last;
 				if (unlikely(offset > MAX_255_COUNT))
 					return LZO_E_ERROR;
 
 				offset = (offset << 8) - offset;
 				t += offset + 31 + *ip++;
-				NEED_IP(2);
+				CHECK_IP();
 			}
 			m_pos = op - 1;
-			next = get_unaligned_le16(ip);
-			ip += 2;
+			next = *ip++;
+			CHECK_IP();
+			next += *ip++ << 8;
+			CHECK_IP();
 			m_pos -= next >> 2;
 			next &= 3;
 		} else {
-			NEED_IP(2);
-			next = get_unaligned_le16(ip);
+			next = *ip++;
+			CHECK_IP();
+			next += *ip++ << 8;
 			if (((next & 0xfffc) == 0xfffc) &&
 			    ((t & 0xf8) == 0x18) &&
 			    likely(bitstream_version)) {
-				NEED_IP(3);
 				t &= 7;
-				t |= ip[2] << 3;
+				CHECK_IP();
+				t |= *ip++ << 3;
+				CHECK_IP();
 				t += MIN_ZERO_RUN_LENGTH;
 				NEED_OP(t);
 				memset(op, 0, t);
 				op += t;
 				next &= 3;
-				ip += 3;
 				goto match_next;
 			} else {
 				m_pos = op;
@@ -186,26 +201,43 @@ int lzo1x_decompress_safe(const unsigned char *in, size_t in_len,
 				t = (t & 7) + (3 - 1);
 				if (unlikely(t == 2)) {
 					size_t offset;
-					const unsigned char *ip_last = ip;
+					size_t tip;
 
-					while (unlikely(*ip == 0)) {
-						ip++;
-						NEED_IP(1);
+					CHECK_IP();
+					if (!next) {
+						offset = 2;
+						while (unlikely(*ip == 0)) {
+							ip++;
+							CHECK_IP();
+							offset++;
+						}
+
+						tip = *ip++;
+						CHECK_IP();
+						next = *ip++;
+						CHECK_IP();
+					} else if (!(next & 0xff)) {
+						offset = 1;
+						tip = next >> 8;
+						next = *ip++;
+						CHECK_IP();
+					} else {
+						offset = 0;
+						tip = next & 0xff;
+						next >>= 8;
 					}
-					offset = ip - ip_last;
 					if (unlikely(offset > MAX_255_COUNT))
 						return LZO_E_ERROR;
 
 					offset = (offset << 8) - offset;
-					t += offset + 7 + *ip++;
-					NEED_IP(2);
-					next = get_unaligned_le16(ip);
+					t += offset + 7 + tip;
+					next += *ip++ << 8;
 				}
-				ip += 2;
 				m_pos -= next >> 2;
 				next &= 3;
 				if (m_pos == op)
 					goto eof_found;
+				CHECK_IP();
 				m_pos -= 0x4000;
 			}
 		}
@@ -260,36 +292,42 @@ int lzo1x_decompress_safe(const unsigned char *in, size_t in_len,
 		} else
 #endif
 		{
-			NEED_IP(t + 3);
 			NEED_OP(t);
 			while (t > 0) {
 				*op++ = *ip++;
+				CHECK_IP();
 				t--;
 			}
 		}
 	}
 
 eof_found:
-	*out_len = op - out;
-	return (t != 3       ? LZO_E_ERROR :
-		ip == ip_end ? LZO_E_OK :
-		ip <  ip_end ? LZO_E_INPUT_NOT_CONSUMED : LZO_E_INPUT_OVERRUN);
+	err = t != 3		? LZO_E_ERROR :
+	      !IP_LEFT()	? LZO_E_OK :
+	      IP_LEFT() > 0	? LZO_E_INPUT_NOT_CONSUMED :
+				  LZO_E_INPUT_OVERRUN;
+	goto out;
 
 input_overrun:
-	*out_len = op - out;
-	return LZO_E_INPUT_OVERRUN;
+	err = LZO_E_INPUT_OVERRUN;
+	goto out;
 
 output_overrun:
-	*out_len = op - out;
-	return LZO_E_OUTPUT_OVERRUN;
+	err = LZO_E_OUTPUT_OVERRUN;
+	goto out;
 
 lookbehind_overrun:
-	*out_len = op - out;
-	return LZO_E_LOOKBEHIND_OVERRUN;
-}
-#ifndef STATIC
-EXPORT_SYMBOL_GPL(lzo1x_decompress_safe);
+	err = LZO_E_LOOKBEHIND_OVERRUN;
+	goto out;
 
+out:
+	PUT_IP();
+	*out_len = op - out;
+	return err;
+}
+EXPORT_SYMBOL_GPL(LZO_SG(lzo1x_decompress_safe));
+
+#ifdef INPUT_IS_LINEAR
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("LZO1X Decompressor");
 
diff --git a/lib/lzo/lzo1x_decompress_safe_sg.c b/lib/lzo/lzo1x_decompress_safe_sg.c
new file mode 100644
index 000000000000..7312ac1b9412
--- /dev/null
+++ b/lib/lzo/lzo1x_decompress_safe_sg.c
@@ -0,0 +1,48 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ *  LZO1X Decompressor from LZO
+ *
+ *  Copyright (C) 1996-2012 Markus F.X.J. Oberhumer <markus@oberhumer.com>
+ *
+ *  The full LZO package can be found at:
+ *  http://www.oberhumer.com/opensource/lzo/
+ *
+ *  Changed for Linux kernel use by:
+ *  Nitin Gupta <nitingupta910@gmail.com>
+ *  Richard Purdie <rpurdie@openedhand.com>
+ */
+
+#include <linux/scatterlist.h>
+#include <linux/types.h>
+
+#define IP_LEFT()	((u8 *)miter.addr + miter.length - ip)
+#define HAVE_IP(x)	((size_t)((u8 *)miter.addr + miter.length - ip) >= (size_t)(x))
+#define GET_IP()	do { \
+				sg_miter_start(&miter, sg, sg_nents(sg), SG_MITER_ATOMIC); \
+				if (!lzo_sg_miter_next(&miter)) \
+					goto input_overrun; \
+				ip = miter.addr; \
+			} while (0)
+#define PUT_IP()	sg_miter_stop(&miter)
+#define CHECK_IP()	do { \
+				if (!HAVE_IP(1)) { \
+					if (!lzo_sg_miter_next(&miter)) \
+						goto input_overrun; \
+					ip = miter.addr; \
+				} \
+			} while (0)
+
+#define INPUT		struct scatterlist *sg
+#define LZO_SG(name)	name##_sg
+
+static bool lzo_sg_miter_next(struct sg_mapping_iter *miter)
+{
+	do {
+		if (!sg_miter_next(miter))
+			return false;
+	} while (!miter->length);
+
+	return true;
+}
+
+#include "lzo1x_decompress_safe.c"
diff --git a/lib/lzo/lzodefs.h b/lib/lzo/lzodefs.h
index b60851fcf6ce..5d5a029983e6 100644
--- a/lib/lzo/lzodefs.h
+++ b/lib/lzo/lzodefs.h
@@ -12,6 +12,7 @@
  *  Richard Purdie <rpurdie@openedhand.com>
  */
 
+#include <linux/unaligned.h>
 
 /* Version
  * 0: original lzo version

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
