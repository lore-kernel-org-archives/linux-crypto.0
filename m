From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 3/3] sha512: use standard ror64()
Date: Sat, 14 Jan 2012 21:44:49 +0300
Message-ID: <20120114184448.GB5516@p183.telecom.by>
References: <20120112235514.GA5065@p183.telecom.by>
 <20120113070813.GA20068@gondor.apana.org.au>
 <1326450942.2272.20.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <1326451301.2272.23.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <1326452246.2272.31.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <CACVxJT9FOYdRFZJ0WRe+5ty4t4XLwgHKWaoZBWB+Zjm-yCEMEA@mail.gmail.com>
 <1326458053.3826.4.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <20120114182024.GA4207@p183.telecom.by>
 <20120114182737.GB4207@p183.telecom.by>
 <20120114184057.GA5516@p183.telecom.by>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42471 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754593Ab2ANSoy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 14 Jan 2012 13:44:54 -0500
Received: by bkuw12 with SMTP id w12so704531bku.19
        for <linux-crypto@vger.kernel.org>; Sat, 14 Jan 2012 10:44:52 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20120114184057.GA5516@p183.telecom.by>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Use standard ror64() instead of hand-written.
There is no standard ror64, so create it.

The difference is shift value being "unsigned int" instead of uint64_t
(for which there is no reason). gcc starts to emit native ROR instructions
which it doesn't do for some reason currently. This should make the code
faster.

Patch survives in-tree crypto test and ping flood with hmac(sha512) on.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 crypto/sha512_generic.c |   13 ++++---------
 include/linux/bitops.h  |   20 ++++++++++++++++++++
 2 files changed, 24 insertions(+), 9 deletions(-)

--- a/crypto/sha512_generic.c
+++ b/crypto/sha512_generic.c
@@ -31,11 +31,6 @@ static inline u64 Maj(u64 x, u64 y, u64 z)
         return (x & y) | (z & (x | y));
 }
 
-static inline u64 RORu64(u64 x, u64 y)
-{
-        return (x >> y) | (x << (64 - y));
-}
-
 static const u64 sha512_K[80] = {
         0x428a2f98d728ae22ULL, 0x7137449123ef65cdULL, 0xb5c0fbcfec4d3b2fULL,
         0xe9b5dba58189dbbcULL, 0x3956c25bf348b538ULL, 0x59f111f1b605d019ULL,
@@ -66,10 +61,10 @@ static const u64 sha512_K[80] = {
         0x5fcb6fab3ad6faecULL, 0x6c44198c4a475817ULL,
 };
 
-#define e0(x)       (RORu64(x,28) ^ RORu64(x,34) ^ RORu64(x,39))
-#define e1(x)       (RORu64(x,14) ^ RORu64(x,18) ^ RORu64(x,41))
-#define s0(x)       (RORu64(x, 1) ^ RORu64(x, 8) ^ (x >> 7))
-#define s1(x)       (RORu64(x,19) ^ RORu64(x,61) ^ (x >> 6))
+#define e0(x)       (ror64(x,28) ^ ror64(x,34) ^ ror64(x,39))
+#define e1(x)       (ror64(x,14) ^ ror64(x,18) ^ ror64(x,41))
+#define s0(x)       (ror64(x, 1) ^ ror64(x, 8) ^ (x >> 7))
+#define s1(x)       (ror64(x,19) ^ ror64(x,61) ^ (x >> 6))
 
 static inline void LOAD_OP(int I, u64 *W, const u8 *input)
 {
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -56,6 +56,26 @@ static inline unsigned long hweight_long(unsigned long w)
 }
 
 /**
+ * rol64 - rotate a 64-bit value left
+ * @word: value to rotate
+ * @shift: bits to roll
+ */
+static inline __u64 rol64(__u64 word, unsigned int shift)
+{
+	return (word << shift) | (word >> (64 - shift));
+}
+
+/**
+ * ror64 - rotate a 64-bit value right
+ * @word: value to rotate
+ * @shift: bits to roll
+ */
+static inline __u64 ror64(__u64 word, unsigned int shift)
+{
+	return (word >> shift) | (word << (64 - shift));
+}
+
+/**
  * rol32 - rotate a 32-bit value left
  * @word: value to rotate
  * @shift: bits to roll
