From: "George Spelvin" <linux@horizon.com>
Subject: [PATCH 01/10] crypto/des_generic: Factor out MASKSWAP()
Date: Sun, 08 Feb 2009 06:51:04 -0500
Message-ID: <20090208115104.4483.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux@horizon.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from science.horizon.com ([192.35.100.1]:12041 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752506AbZBHL5p (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 8 Feb 2009 06:57:45 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This greatly shrinks the IP() and FP() macros.
---
 crypto/des_generic.c |  103 +++++++++++++++-----------------------------------
 1 files changed, 31 insertions(+), 72 deletions(-)

diff --git a/crypto/des_generic.c b/crypto/des_generic.c
index 5bd3ee3..afde5b4 100644
--- a/crypto/des_generic.c
+++ b/crypto/des_generic.c
@@ -22,9 +22,6 @@
 
 #include <crypto/des.h>
 
-#define ROL(x, r) ((x) = rol32((x), (r)))
-#define ROR(x, r) ((x) = ror32((x), (r)))
-
 struct des_ctx {
 	u32 expkey[DES_EXPKEY_WORDS];
 };
@@ -521,70 +518,38 @@ static const u32 S8[64] = {
 
 /* Encryption components: IP, FP, and round function */
 
-#define IP(L, R, T)		\
-	ROL(R, 4);		\
-	T  = L;			\
-	L ^= R;			\
-	L &= 0xf0f0f0f0;	\
-	R ^= L;			\
-	L ^= T;			\
-	ROL(R, 12);		\
-	T  = L;			\
-	L ^= R;			\
-	L &= 0xffff0000;	\
-	R ^= L;			\
-	L ^= T;			\
-	ROR(R, 14);		\
-	T  = L;			\
-	L ^= R;			\
-	L &= 0xcccccccc;	\
-	R ^= L;			\
-	L ^= T;			\
-	ROL(R, 6);		\
-	T  = L;			\
-	L ^= R;			\
-	L &= 0xff00ff00;	\
-	R ^= L;			\
-	L ^= T;			\
-	ROR(R, 7);		\
-	T  = L;			\
-	L ^= R;			\
-	L &= 0xaaaaaaaa;	\
-	R ^= L;			\
+#define ROL(x, r) ((x) = rol32((x), (r)))
+#define ROR(x, r) ((x) = ror32((x), (r)))
+/* Swap the bits set in "mask" between L and R */
+#define MASKSWAP(L, R, T, mask)	\
+	T = (L ^ R) & (mask);	\
 	L ^= T;			\
+	R ^= T;			\
+
+#define IP(L, R, T)			\
+	ROL(R, 4);			\
+	MASKSWAP(L, R, T, 0xf0f0f0f0);  \
+	ROL(R, 12);			\
+	MASKSWAP(L, R, T, 0xffff0000);  \
+	ROR(R, 14);			\
+	MASKSWAP(L, R, T, 0xcccccccc);  \
+	ROL(R, 6);			\
+	MASKSWAP(L, R, T, 0xff00ff00);  \
+	ROR(R, 7);			\
+	MASKSWAP(L, R, T, 0xaaaaaaaa);  \
 	ROL(L, 1);
 
-#define FP(L, R, T)		\
-	ROR(L, 1);		\
-	T  = L;			\
-	L ^= R;			\
-	L &= 0xaaaaaaaa;	\
-	R ^= L;			\
-	L ^= T;			\
-	ROL(R, 7);		\
-	T  = L;			\
-	L ^= R;			\
-	L &= 0xff00ff00;	\
-	R ^= L;			\
-	L ^= T;			\
-	ROR(R, 6);		\
-	T  = L;			\
-	L ^= R;			\
-	L &= 0xcccccccc;	\
-	R ^= L;			\
-	L ^= T;			\
-	ROL(R, 14);		\
-	T  = L;			\
-	L ^= R;			\
-	L &= 0xffff0000;	\
-	R ^= L;			\
-	L ^= T;			\
-	ROR(R, 12);		\
-	T  = L;			\
-	L ^= R;			\
-	L &= 0xf0f0f0f0;	\
-	R ^= L;			\
-	L ^= T;			\
+#define FP(L, R, T)			\
+	ROR(L, 1);			\
+	MASKSWAP(L, R, T, 0xaaaaaaaa);  \
+	ROL(R, 7);			\
+	MASKSWAP(L, R, T, 0xff00ff00);  \
+	ROR(R, 6);			\
+	MASKSWAP(L, R, T, 0xcccccccc);  \
+	ROL(R, 14);			\
+	MASKSWAP(L, R, T, 0xffff0000);  \
+	ROR(R, 12);			\
+	MASKSWAP(L, R, T, 0xf0f0f0f0);  \
 	ROR(R, 4);
 
 #define ROUND(L, R, A, B, K, d)					\
@@ -691,10 +656,7 @@ unsigned long des_ekey(u32 *pe, const u8 *k)
 	for (d = 0; d < 16; ++d) {
 		a = pe[2 * d];
 		b = pe[2 * d + 1];
-		c = a ^ b;
-		c &= 0xffff0000;
-		a ^= c;
-		b ^= c;
+		MASKSWAP(a, b, c, 0xffff0000);
 		ROL(b, 18);
 		pe[2 * d] = a;
 		pe[2 * d + 1] = b;
@@ -768,10 +730,7 @@ static void dkey(u32 *pe, const u8 *k)
 	for (d = 0; d < 16; ++d) {
 		a = pe[2 * d];
 		b = pe[2 * d + 1];
-		c = a ^ b;
-		c &= 0xffff0000;
-		a ^= c;
-		b ^= c;
+		MASKSWAP(a, b, c, 0xffff0000);
 		ROL(b, 18);
 		pe[2 * d] = a;
 		pe[2 * d + 1] = b;
-- 
1.6.0.6

