Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C0804414;
	Sun, 23 Feb 2025 06:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740293739; cv=none; b=Bzvvqo3HM+rfVQayJtBI+PlvPm8+ckzEYKtMo0OPrUVxyQhENmsFcDnP0M56g6gvcgzvh+K8ZoY/0DHKQGmQSEo4aneQQD7MlCq6Ty/1CUA0+4uIEDrSzfTQy7VJ2+qsVMpcXWyIj9/SCZd/RfzJshBcjgMxl99XaJdEu3akERI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740293739; c=relaxed/simple;
	bh=QmOR/YrUzzwsYy7T54Gep40GJD5nY3nQaIVBiQTDYps=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=jBdcAkegM1u2k3jY2QJFf5uiUWNyGvEMUinF+5L7LFlL0E51uYIW6HEAKBF+Qe+2RANYhOszvJALh4ZuaKgL4Mn3JbLtZbHF4/f5XKRccvEOFNd3tP9c2efdQpzENXHvtnh3Lq7Jiv+dLpqPKWj6nfHjg9lcXSACW8HwcnvEA+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=JxEDmKei; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="JxEDmKei"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Content-Type:MIME-Version:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=TrabOqtRhfI4L6MXAwrxdsN96HvSybcOUIqp0rTlZoc=; b=JxEDmKeiwKhrw9Z+o5YxLxPgBR
	HoAWaqs0VwTbUwWImyM85VEknbl3XBCiRR+CuNJC3et+XS4tr+jnqXLqK3yuAKrxLGqGckJdxuDfw
	4IRxi8oaKf4lJlevnGmYIZfG8cn2dwTOWyaYWrNaRiTpcsY8MmQkfKvya6UjwAB6uQKfXo92f/goA
	sLaTQNN+AdfMQ+PyA8rVzBdTFF2tJZIztCcnQcU8XMga3T13zHS5Q0TEBLhCWkGazq6oR/IT3qESg
	t4HYM/FrZ2RWok66dvs2Vc+2n9iEaLKHn6YCf6GHE2tW1t1oY4qumB6/VDa7uQti4PaKmSw2vlTtF
	iL2+dx+w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tm5tc-000ycI-0E;
	Sun, 23 Feb 2025 14:55:25 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 23 Feb 2025 14:55:24 +0800
Date: Sun, 23 Feb 2025 14:55:24 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Nitin Gupta <nitingupta910@gmail.com>,
	Richard Purdie <rpurdie@openedhand.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	"Markus F.X.J. Oberhumer" <markus@oberhumer.com>,
	Dave Rodgman <dave.rodgman@arm.com>
Subject: [PATCH] lib/lzo: Avoid output overruns when compressing
Message-ID: <Z7rGXJSX57gEfXPw@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The compression code in LZO never checked for output overruns.
Fix this by checking for end of buffer before each write.

Fixes: 64c70b1cf43d ("Add LZO1X algorithm to the kernel")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/lib/lzo/lzo1x_compress.c b/lib/lzo/lzo1x_compress.c
index 47d6d43ea957..5d2f2f851694 100644
--- a/lib/lzo/lzo1x_compress.c
+++ b/lib/lzo/lzo1x_compress.c
@@ -18,10 +18,10 @@
 #include <linux/lzo.h>
 #include "lzodefs.h"
 
-static noinline size_t
+static noinline int
 lzo1x_1_do_compress(const unsigned char *in, size_t in_len,
-		    unsigned char *out, size_t *out_len,
-		    size_t ti, void *wrkmem, signed char *state_offset,
+		    unsigned char **out, unsigned char *op_end,
+		    size_t *tp, void *wrkmem, signed char *state_offset,
 		    const unsigned char bitstream_version)
 {
 	const unsigned char *ip;
@@ -30,8 +30,9 @@ lzo1x_1_do_compress(const unsigned char *in, size_t in_len,
 	const unsigned char * const ip_end = in + in_len - 20;
 	const unsigned char *ii;
 	lzo_dict_t * const dict = (lzo_dict_t *) wrkmem;
+	size_t ti = *tp;
 
-	op = out;
+	op = *out;
 	ip = in;
 	ii = ip;
 	ip += ti < 4 ? 4 - ti : 0;
@@ -116,25 +117,41 @@ lzo1x_1_do_compress(const unsigned char *in, size_t in_len,
 		if (t != 0) {
 			if (t <= 3) {
 				op[*state_offset] |= t;
+				if (!HAVE_OP(4))
+					return LZO_E_OUTPUT_OVERRUN;
 				COPY4(op, ii);
 				op += t;
 			} else if (t <= 16) {
+				if (!HAVE_OP(1))
+					return LZO_E_OUTPUT_OVERRUN;
 				*op++ = (t - 3);
+				if (!HAVE_OP(16))
+					return LZO_E_OUTPUT_OVERRUN;
 				COPY8(op, ii);
 				COPY8(op + 8, ii + 8);
 				op += t;
 			} else {
 				if (t <= 18) {
+					if (!HAVE_OP(1))
+						return LZO_E_OUTPUT_OVERRUN;
 					*op++ = (t - 3);
 				} else {
 					size_t tt = t - 18;
+					if (!HAVE_OP(1))
+						return LZO_E_OUTPUT_OVERRUN;
 					*op++ = 0;
 					while (unlikely(tt > 255)) {
 						tt -= 255;
+						if (!HAVE_OP(1))
+							return LZO_E_OUTPUT_OVERRUN;
 						*op++ = 0;
 					}
+					if (!HAVE_OP(1))
+						return LZO_E_OUTPUT_OVERRUN;
 					*op++ = tt;
 				}
+				if (!HAVE_OP(t))
+					return LZO_E_OUTPUT_OVERRUN;
 				do {
 					COPY8(op, ii);
 					COPY8(op + 8, ii + 8);
@@ -151,6 +168,8 @@ lzo1x_1_do_compress(const unsigned char *in, size_t in_len,
 		if (unlikely(run_length)) {
 			ip += run_length;
 			run_length -= MIN_ZERO_RUN_LENGTH;
+			if (!HAVE_OP(4))
+				return LZO_E_OUTPUT_OVERRUN;
 			put_unaligned_le32((run_length << 21) | 0xfffc18
 					   | (run_length & 0x7), op);
 			op += 4;
@@ -243,10 +262,14 @@ lzo1x_1_do_compress(const unsigned char *in, size_t in_len,
 		ip += m_len;
 		if (m_len <= M2_MAX_LEN && m_off <= M2_MAX_OFFSET) {
 			m_off -= 1;
+			if (!HAVE_OP(2))
+				return LZO_E_OUTPUT_OVERRUN;
 			*op++ = (((m_len - 1) << 5) | ((m_off & 7) << 2));
 			*op++ = (m_off >> 3);
 		} else if (m_off <= M3_MAX_OFFSET) {
 			m_off -= 1;
+			if (!HAVE_OP(1))
+				return LZO_E_OUTPUT_OVERRUN;
 			if (m_len <= M3_MAX_LEN)
 				*op++ = (M3_MARKER | (m_len - 2));
 			else {
@@ -254,14 +277,22 @@ lzo1x_1_do_compress(const unsigned char *in, size_t in_len,
 				*op++ = M3_MARKER | 0;
 				while (unlikely(m_len > 255)) {
 					m_len -= 255;
+					if (!HAVE_OP(1))
+						return LZO_E_OUTPUT_OVERRUN;
 					*op++ = 0;
 				}
+				if (!HAVE_OP(1))
+					return LZO_E_OUTPUT_OVERRUN;
 				*op++ = (m_len);
 			}
+			if (!HAVE_OP(2))
+				return LZO_E_OUTPUT_OVERRUN;
 			*op++ = (m_off << 2);
 			*op++ = (m_off >> 6);
 		} else {
 			m_off -= 0x4000;
+			if (!HAVE_OP(1))
+				return LZO_E_OUTPUT_OVERRUN;
 			if (m_len <= M4_MAX_LEN)
 				*op++ = (M4_MARKER | ((m_off >> 11) & 8)
 						| (m_len - 2));
@@ -282,11 +313,17 @@ lzo1x_1_do_compress(const unsigned char *in, size_t in_len,
 				m_len -= M4_MAX_LEN;
 				*op++ = (M4_MARKER | ((m_off >> 11) & 8));
 				while (unlikely(m_len > 255)) {
+					if (!HAVE_OP(1))
+						return LZO_E_OUTPUT_OVERRUN;
 					m_len -= 255;
 					*op++ = 0;
 				}
+				if (!HAVE_OP(1))
+					return LZO_E_OUTPUT_OVERRUN;
 				*op++ = (m_len);
 			}
+			if (!HAVE_OP(2))
+				return LZO_E_OUTPUT_OVERRUN;
 			*op++ = (m_off << 2);
 			*op++ = (m_off >> 6);
 		}
@@ -295,14 +332,16 @@ lzo1x_1_do_compress(const unsigned char *in, size_t in_len,
 		ii = ip;
 		goto next;
 	}
-	*out_len = op - out;
-	return in_end - (ii - ti);
+	*out = op;
+	*tp = in_end - (ii - ti);
+	return LZO_E_OK;
 }
 
 static int lzogeneric1x_1_compress(const unsigned char *in, size_t in_len,
 		     unsigned char *out, size_t *out_len,
 		     void *wrkmem, const unsigned char bitstream_version)
 {
+	unsigned char * const op_end = out + *out_len;
 	const unsigned char *ip = in;
 	unsigned char *op = out;
 	unsigned char *data_start;
@@ -326,14 +365,17 @@ static int lzogeneric1x_1_compress(const unsigned char *in, size_t in_len,
 	while (l > 20) {
 		size_t ll = min_t(size_t, l, m4_max_offset + 1);
 		uintptr_t ll_end = (uintptr_t) ip + ll;
+		int err;
+
 		if ((ll_end + ((t + ll) >> 5)) <= ll_end)
 			break;
 		BUILD_BUG_ON(D_SIZE * sizeof(lzo_dict_t) > LZO1X_1_MEM_COMPRESS);
 		memset(wrkmem, 0, D_SIZE * sizeof(lzo_dict_t));
-		t = lzo1x_1_do_compress(ip, ll, op, out_len, t, wrkmem,
-					&state_offset, bitstream_version);
+		err = lzo1x_1_do_compress(ip, ll, &op, op_end, &t, wrkmem,
+					  &state_offset, bitstream_version);
+		if (err != LZO_E_OK)
+			return err;
 		ip += ll;
-		op += *out_len;
 		l  -= ll;
 	}
 	t += l;
@@ -342,20 +384,32 @@ static int lzogeneric1x_1_compress(const unsigned char *in, size_t in_len,
 		const unsigned char *ii = in + in_len - t;
 
 		if (op == data_start && t <= 238) {
+			if (!HAVE_OP(1))
+				return LZO_E_OUTPUT_OVERRUN;
 			*op++ = (17 + t);
 		} else if (t <= 3) {
 			op[state_offset] |= t;
 		} else if (t <= 18) {
+			if (!HAVE_OP(1))
+				return LZO_E_OUTPUT_OVERRUN;
 			*op++ = (t - 3);
 		} else {
 			size_t tt = t - 18;
+			if (!HAVE_OP(1))
+				return LZO_E_OUTPUT_OVERRUN;
 			*op++ = 0;
 			while (tt > 255) {
 				tt -= 255;
+				if (!HAVE_OP(1))
+					return LZO_E_OUTPUT_OVERRUN;
 				*op++ = 0;
 			}
+			if (!HAVE_OP(1))
+				return LZO_E_OUTPUT_OVERRUN;
 			*op++ = tt;
 		}
+		if (!HAVE_OP(t))
+			return LZO_E_OUTPUT_OVERRUN;
 		if (t >= 16) do {
 			COPY8(op, ii);
 			COPY8(op + 8, ii + 8);
@@ -368,6 +422,8 @@ static int lzogeneric1x_1_compress(const unsigned char *in, size_t in_len,
 		} while (--t > 0);
 	}
 
+	if (!HAVE_OP(3))
+		return LZO_E_OUTPUT_OVERRUN;
 	*op++ = M4_MARKER | 1;
 	*op++ = 0;
 	*op++ = 0;
diff --git a/lib/lzo/lzo1x_decompress_safe.c b/lib/lzo/lzo1x_decompress_safe.c
index c94f4928e188..4d5a1b58a4a0 100644
--- a/lib/lzo/lzo1x_decompress_safe.c
+++ b/lib/lzo/lzo1x_decompress_safe.c
@@ -21,7 +21,6 @@
 #include "lzodefs.h"
 
 #define HAVE_IP(x)      ((size_t)(ip_end - ip) >= (size_t)(x))
-#define HAVE_OP(x)      ((size_t)(op_end - op) >= (size_t)(x))
 #define NEED_IP(x)      if (!HAVE_IP(x)) goto input_overrun
 #define NEED_OP(x)      if (!HAVE_OP(x)) goto output_overrun
 #define TEST_LB(m_pos)  if ((m_pos) < out) goto lookbehind_overrun
diff --git a/lib/lzo/lzodefs.h b/lib/lzo/lzodefs.h
index b60851fcf6ce..8b1a46993acf 100644
--- a/lib/lzo/lzodefs.h
+++ b/lib/lzo/lzodefs.h
@@ -19,6 +19,7 @@
  */
 #define LZO_VERSION 1
 
+#define HAVE_OP(x)      ((size_t)(op_end - op) >= (size_t)(x))
 #define COPY4(dst, src)	\
 		put_unaligned(get_unaligned((const u32 *)(src)), (u32 *)(dst))
 #if defined(CONFIG_X86_64) || defined(CONFIG_ARM64)
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
