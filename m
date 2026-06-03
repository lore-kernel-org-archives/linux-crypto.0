Received: from mx01.omp.ru (mx01.omp.ru [90.154.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E830840759D
	for <linux-crypto@vger.kernel.org>; Wed,  3 Jun 2026 09:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.154.21.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780480665; cv=none; b=m8FSd4e0E8LY8VROyY0YTryVrZTiOTp6zLiJv2Xt3qDP2WnnV72PLcLW8Vg8dsjzoyJ5/w19atF2eiVbq4hGgxoYaLHRWTvGjMdcNSJqAjMw+oowCuC7gzHcFdijCuZuXHq0DVBUPhNpsolUbnobrMkCealueVAQ+3odOUjI0DU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780480665; c=relaxed/simple;
	bh=xIIBW/e5Uw+kqVuYYTR9ZJKD9rzp/togBuR4h0ltqj0=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=iiAlCzq7ss6DoNTkaeXiIbkJAgnHU4sczMnkp/iMc+CWUpO/DZOSBTRydp1tcJcZ8eKvuYliQKMe8fUGaFc/dhIDshl+GxbQaoTW24KbUhjYBbID/kKFB/ogNFGVNS1m7tGH9PKYo39vUhzAyGMeKaL9HqUKy32KsVAIEpubRuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=omp.ru; spf=pass smtp.mailfrom=omp.ru; arc=none smtp.client-ip=90.154.21.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=omp.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=omp.ru
Received: from vpn2.omp.ru (31.133.126.217) by msexch01.omp.ru (10.188.4.12)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1258.12; Wed, 3 Jun
 2026 12:42:19 +0300
From: Viktoriya Danchenko <v.danchenko@omp.ru>
To: <lvc-project@linuxtesting.org>, "David S. Miller" <davem@davemloft.net>,
	David Sterba <dsterba@suse.com>, Herbert Xu <herbert@gondor.apana.org.au>,
	<linux-crypto@vger.kernel.org>
Subject: [PATCH 5.10] crypto: lzo - Fix compression buffer overrun
Date: Wed, 3 Jun 2026 12:42:07 +0300
Message-ID: <20260603094207.50626-1-v.danchenko@omp.ru>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: msexch01.omp.ru (10.188.4.12) To msexch01.omp.ru
 (10.188.4.12)
X-KSE-ServerInfo: msexch01.omp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 6.1.1, Database issued on: 06/03/2026 09:34:08
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 19
X-KSE-AntiSpam-Info: Lua profiles 203621 [Jun 03 2026]
X-KSE-AntiSpam-Info: Version: 6.1.1.22
X-KSE-AntiSpam-Info: Envelope from: v.danchenko@omp.ru
X-KSE-AntiSpam-Info: LuaCore: 107 0.3.107
 575e75fe8e3b9d45c142d144823c5de38605099e
X-KSE-AntiSpam-Info: {rep_avail}
X-KSE-AntiSpam-Info: {date_rfc_vio_soft_silent}
X-KSE-AntiSpam-Info: {Tracking_uf_ne_domains}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: {SMTP from is not routable}
X-KSE-AntiSpam-Info: {Found in DNSBL: 31.133.126.217 in (user)
 dbl.spamhaus.org}
X-KSE-AntiSpam-Info:
	d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;www.oberhumer.com:7.1.1;vpn2.omp.ru:7.1.1;127.0.0.199:7.1.2;omp.ru:7.1.1
X-KSE-AntiSpam-Info: {Tracking_ip_hunter}
X-KSE-AntiSpam-Info: FromAlignment: s
X-KSE-AntiSpam-Info: ApMailHostAddress: 31.133.126.217
X-KSE-AntiSpam-Info: {DNS response errors}
X-KSE-AntiSpam-Info: Rate: 19
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dmarc=temperror header.from=omp.ru;spf=temperror
 smtp.mailfrom=omp.ru;dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 06/03/2026 09:36:00
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 6/3/2026 5:40:00 AM
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit cc47f07234f72cbd8e2c973cdbf2a6730660a463 ]

Unlike the decompression code, the compression code in LZO never
checked for output overruns.  It instead assumes that the caller
always provides enough buffer space, disregarding the buffer length
provided by the caller.

Add a safe compression interface that checks for the end of buffer
before each write.  Use the safe interface in crypto/lzo.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Roman Smirnov <r.smirnov@omp.ru>
Fixes: 64c70b1cf43d ("Add LZO1X algorithm to the kernel")
Signed-off-by: Viktoriya Danchenko <v.danchenko@omp.ru>
---
Backport fix for CVE-2025-38068
---
 crypto/lzo-rle.c              |   2 +-
 crypto/lzo.c                  |   2 +-
 include/linux/lzo.h           |   8 +++
 lib/lzo/Makefile              |   2 +-
 lib/lzo/lzo1x_compress.c      | 101 +++++++++++++++++++++++++---------
 lib/lzo/lzo1x_compress_safe.c |  18 ++++++
 6 files changed, 105 insertions(+), 28 deletions(-)
 create mode 100644 lib/lzo/lzo1x_compress_safe.c

diff --git a/crypto/lzo-rle.c b/crypto/lzo-rle.c
index 0631d975bfac..0abc2d87f042 100644
--- a/crypto/lzo-rle.c
+++ b/crypto/lzo-rle.c
@@ -55,7 +55,7 @@ static int __lzorle_compress(const u8 *src, unsigned int slen,
 	size_t tmp_len = *dlen; /* size_t(ulong) <-> uint on 64 bit */
 	int err;
 
-	err = lzorle1x_1_compress(src, slen, dst, &tmp_len, ctx);
+	err = lzorle1x_1_compress_safe(src, slen, dst, &tmp_len, ctx);
 
 	if (err != LZO_E_OK)
 		return -EINVAL;
diff --git a/crypto/lzo.c b/crypto/lzo.c
index ebda132dd22b..8338851c7406 100644
--- a/crypto/lzo.c
+++ b/crypto/lzo.c
@@ -55,7 +55,7 @@ static int __lzo_compress(const u8 *src, unsigned int slen,
 	size_t tmp_len = *dlen; /* size_t(ulong) <-> uint on 64 bit */
 	int err;
 
-	err = lzo1x_1_compress(src, slen, dst, &tmp_len, ctx);
+	err = lzo1x_1_compress_safe(src, slen, dst, &tmp_len, ctx);
 
 	if (err != LZO_E_OK)
 		return -EINVAL;
diff --git a/include/linux/lzo.h b/include/linux/lzo.h
index e95c7d1092b2..4d30e3624acd 100644
--- a/include/linux/lzo.h
+++ b/include/linux/lzo.h
@@ -24,10 +24,18 @@
 int lzo1x_1_compress(const unsigned char *src, size_t src_len,
 		     unsigned char *dst, size_t *dst_len, void *wrkmem);
 
+/* Same as above but does not write more than dst_len to dst. */
+int lzo1x_1_compress_safe(const unsigned char *src, size_t src_len,
+			  unsigned char *dst, size_t *dst_len, void *wrkmem);
+
 /* This requires 'wrkmem' of size LZO1X_1_MEM_COMPRESS */
 int lzorle1x_1_compress(const unsigned char *src, size_t src_len,
 		     unsigned char *dst, size_t *dst_len, void *wrkmem);
 
+/* Same as above but does not write more than dst_len to dst. */
+int lzorle1x_1_compress_safe(const unsigned char *src, size_t src_len,
+			     unsigned char *dst, size_t *dst_len, void *wrkmem);
+
 /* safe decompression with overrun testing */
 int lzo1x_decompress_safe(const unsigned char *src, size_t src_len,
 			  unsigned char *dst, size_t *dst_len);
diff --git a/lib/lzo/Makefile b/lib/lzo/Makefile
index 2f58fafbbddd..fc7b2b7ef4b2 100644
--- a/lib/lzo/Makefile
+++ b/lib/lzo/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0-only
-lzo_compress-objs := lzo1x_compress.o
+lzo_compress-objs := lzo1x_compress.o lzo1x_compress_safe.o
 lzo_decompress-objs := lzo1x_decompress_safe.o
 
 obj-$(CONFIG_LZO_COMPRESS) += lzo_compress.o
diff --git a/lib/lzo/lzo1x_compress.c b/lib/lzo/lzo1x_compress.c
index 8ad5ba2b86e2..941d7337f273 100644
--- a/lib/lzo/lzo1x_compress.c
+++ b/lib/lzo/lzo1x_compress.c
@@ -18,11 +18,22 @@
 #include <linux/lzo.h>
 #include "lzodefs.h"
 
-static noinline size_t
-lzo1x_1_do_compress(const unsigned char *in, size_t in_len,
-		    unsigned char *out, size_t *out_len,
-		    size_t ti, void *wrkmem, signed char *state_offset,
-		    const unsigned char bitstream_version)
+#undef LZO_UNSAFE
+
+#ifndef LZO_SAFE
+#define LZO_UNSAFE 1
+#define LZO_SAFE(name) name
+#define HAVE_OP(x) 1
+#endif
+
+#define NEED_OP(x) if (!HAVE_OP(x)) goto output_overrun
+
+static noinline int
+LZO_SAFE(lzo1x_1_do_compress)(const unsigned char *in, size_t in_len,
+			      unsigned char **out, unsigned char *op_end,
+			      size_t *tp, void *wrkmem,
+			      signed char *state_offset,
+			      const unsigned char bitstream_version)
 {
 	const unsigned char *ip;
 	unsigned char *op;
@@ -30,8 +41,9 @@ lzo1x_1_do_compress(const unsigned char *in, size_t in_len,
 	const unsigned char * const ip_end = in + in_len - 20;
 	const unsigned char *ii;
 	lzo_dict_t * const dict = (lzo_dict_t *) wrkmem;
+	size_t ti = *tp;
 
-	op = out;
+	op = *out;
 	ip = in;
 	ii = ip;
 	ip += ti < 4 ? 4 - ti : 0;
@@ -118,25 +130,32 @@ lzo1x_1_do_compress(const unsigned char *in, size_t in_len,
 		if (t != 0) {
 			if (t <= 3) {
 				op[*state_offset] |= t;
+				NEED_OP(4);
 				COPY4(op, ii);
 				op += t;
 			} else if (t <= 16) {
+				NEED_OP(17);
 				*op++ = (t - 3);
 				COPY8(op, ii);
 				COPY8(op + 8, ii + 8);
 				op += t;
 			} else {
 				if (t <= 18) {
+					NEED_OP(1);
 					*op++ = (t - 3);
 				} else {
 					size_t tt = t - 18;
+					NEED_OP(1);
 					*op++ = 0;
 					while (unlikely(tt > 255)) {
 						tt -= 255;
+						NEED_OP(1);
 						*op++ = 0;
 					}
+					NEED_OP(1);
 					*op++ = tt;
 				}
+				NEED_OP(t);
 				do {
 					COPY8(op, ii);
 					COPY8(op + 8, ii + 8);
@@ -153,6 +172,7 @@ lzo1x_1_do_compress(const unsigned char *in, size_t in_len,
 		if (unlikely(run_length)) {
 			ip += run_length;
 			run_length -= MIN_ZERO_RUN_LENGTH;
+			NEED_OP(4);
 			put_unaligned_le32((run_length << 21) | 0xfffc18
 					   | (run_length & 0x7), op);
 			op += 4;
@@ -245,10 +265,12 @@ lzo1x_1_do_compress(const unsigned char *in, size_t in_len,
 		ip += m_len;
 		if (m_len <= M2_MAX_LEN && m_off <= M2_MAX_OFFSET) {
 			m_off -= 1;
+			NEED_OP(2);
 			*op++ = (((m_len - 1) << 5) | ((m_off & 7) << 2));
 			*op++ = (m_off >> 3);
 		} else if (m_off <= M3_MAX_OFFSET) {
 			m_off -= 1;
+			NEED_OP(1);
 			if (m_len <= M3_MAX_LEN)
 				*op++ = (M3_MARKER | (m_len - 2));
 			else {
@@ -256,14 +278,18 @@ lzo1x_1_do_compress(const unsigned char *in, size_t in_len,
 				*op++ = M3_MARKER | 0;
 				while (unlikely(m_len > 255)) {
 					m_len -= 255;
+					NEED_OP(1);
 					*op++ = 0;
 				}
+				NEED_OP(1);
 				*op++ = (m_len);
 			}
+			NEED_OP(2);
 			*op++ = (m_off << 2);
 			*op++ = (m_off >> 6);
 		} else {
 			m_off -= 0x4000;
+			NEED_OP(1);
 			if (m_len <= M4_MAX_LEN)
 				*op++ = (M4_MARKER | ((m_off >> 11) & 8)
 						| (m_len - 2));
@@ -284,11 +310,14 @@ lzo1x_1_do_compress(const unsigned char *in, size_t in_len,
 				m_len -= M4_MAX_LEN;
 				*op++ = (M4_MARKER | ((m_off >> 11) & 8));
 				while (unlikely(m_len > 255)) {
+					NEED_OP(1);
 					m_len -= 255;
 					*op++ = 0;
 				}
+				NEED_OP(1);
 				*op++ = (m_len);
 			}
+			NEED_OP(2);
 			*op++ = (m_off << 2);
 			*op++ = (m_off >> 6);
 		}
@@ -297,14 +326,20 @@ lzo1x_1_do_compress(const unsigned char *in, size_t in_len,
 		ii = ip;
 		goto next;
 	}
-	*out_len = op - out;
-	return in_end - (ii - ti);
+	*out = op;
+	*tp = in_end - (ii - ti);
+	return LZO_E_OK;
+
+output_overrun:
+	return LZO_E_OUTPUT_OVERRUN;
 }
 
-int lzogeneric1x_1_compress(const unsigned char *in, size_t in_len,
-		     unsigned char *out, size_t *out_len,
-		     void *wrkmem, const unsigned char bitstream_version)
+static int LZO_SAFE(lzogeneric1x_1_compress)(
+	const unsigned char *in, size_t in_len,
+	unsigned char *out, size_t *out_len,
+	void *wrkmem, const unsigned char bitstream_version)
 {
+	unsigned char * const op_end = out + *out_len;
 	const unsigned char *ip = in;
 	unsigned char *op = out;
 	unsigned char *data_start;
@@ -312,6 +347,7 @@ int lzogeneric1x_1_compress(const unsigned char *in, size_t in_len,
 	size_t t = 0;
 	signed char state_offset = -2;
 	unsigned int m4_max_offset;
+	int err;
 
 	// LZO v0 will never write 17 as first byte (except for zero-length
 	// input), so this is used to version the bitstream
@@ -332,10 +368,12 @@ int lzogeneric1x_1_compress(const unsigned char *in, size_t in_len,
 			break;
 		BUILD_BUG_ON(D_SIZE * sizeof(lzo_dict_t) > LZO1X_1_MEM_COMPRESS);
 		memset(wrkmem, 0, D_SIZE * sizeof(lzo_dict_t));
-		t = lzo1x_1_do_compress(ip, ll, op, out_len, t, wrkmem,
-					&state_offset, bitstream_version);
+		err = LZO_SAFE(lzo1x_1_do_compress)(
+			ip, ll, &op, op_end, &t, wrkmem,
+			&state_offset, bitstream_version);
+		if (err != LZO_E_OK)
+			return err;
 		ip += ll;
-		op += *out_len;
 		l  -= ll;
 	}
 	t += l;
@@ -344,20 +382,26 @@ int lzogeneric1x_1_compress(const unsigned char *in, size_t in_len,
 		const unsigned char *ii = in + in_len - t;
 
 		if (op == data_start && t <= 238) {
+			NEED_OP(1);
 			*op++ = (17 + t);
 		} else if (t <= 3) {
 			op[state_offset] |= t;
 		} else if (t <= 18) {
+			NEED_OP(1);
 			*op++ = (t - 3);
 		} else {
 			size_t tt = t - 18;
+			NEED_OP(1);
 			*op++ = 0;
 			while (tt > 255) {
 				tt -= 255;
+				NEED_OP(1);
 				*op++ = 0;
 			}
+			NEED_OP(1);
 			*op++ = tt;
 		}
+		NEED_OP(t);
 		if (t >= 16) do {
 			COPY8(op, ii);
 			COPY8(op + 8, ii + 8);
@@ -370,31 +414,38 @@ int lzogeneric1x_1_compress(const unsigned char *in, size_t in_len,
 		} while (--t > 0);
 	}
 
+	NEED_OP(3);
 	*op++ = M4_MARKER | 1;
 	*op++ = 0;
 	*op++ = 0;
 
 	*out_len = op - out;
 	return LZO_E_OK;
+
+output_overrun:
+	return LZO_E_OUTPUT_OVERRUN;
 }
 
-int lzo1x_1_compress(const unsigned char *in, size_t in_len,
-		     unsigned char *out, size_t *out_len,
-		     void *wrkmem)
+int LZO_SAFE(lzo1x_1_compress)(const unsigned char *in, size_t in_len,
+			       unsigned char *out, size_t *out_len,
+			       void *wrkmem)
 {
-	return lzogeneric1x_1_compress(in, in_len, out, out_len, wrkmem, 0);
+	return LZO_SAFE(lzogeneric1x_1_compress)(
+		in, in_len, out, out_len, wrkmem, 0);
 }
 
-int lzorle1x_1_compress(const unsigned char *in, size_t in_len,
-		     unsigned char *out, size_t *out_len,
-		     void *wrkmem)
+int LZO_SAFE(lzorle1x_1_compress)(const unsigned char *in, size_t in_len,
+				  unsigned char *out, size_t *out_len,
+				  void *wrkmem)
 {
-	return lzogeneric1x_1_compress(in, in_len, out, out_len,
-				       wrkmem, LZO_VERSION);
+	return LZO_SAFE(lzogeneric1x_1_compress)(
+		in, in_len, out, out_len, wrkmem, LZO_VERSION);
 }
 
-EXPORT_SYMBOL_GPL(lzo1x_1_compress);
-EXPORT_SYMBOL_GPL(lzorle1x_1_compress);
+EXPORT_SYMBOL_GPL(LZO_SAFE(lzo1x_1_compress));
+EXPORT_SYMBOL_GPL(LZO_SAFE(lzorle1x_1_compress));
 
+#ifndef LZO_UNSAFE
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("LZO1X-1 Compressor");
+#endif
diff --git a/lib/lzo/lzo1x_compress_safe.c b/lib/lzo/lzo1x_compress_safe.c
new file mode 100644
index 000000000000..371c9f849492
--- /dev/null
+++ b/lib/lzo/lzo1x_compress_safe.c
@@ -0,0 +1,18 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ *  LZO1X Compressor from LZO
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
+#define LZO_SAFE(name) name##_safe
+#define HAVE_OP(x) ((size_t)(op_end - op) >= (size_t)(x))
+
+#include "lzo1x_compress.c"
-- 
2.43.0

