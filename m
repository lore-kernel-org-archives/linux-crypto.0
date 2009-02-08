From: "George Spelvin" <linux@horizon.com>
Subject: [PATCH 03/10] crypto/des_generic: Make PC2()'s use of pt[]
 explicit
Date: Sun, 08 Feb 2009 06:51:52 -0500
Message-ID: <20090208115152.4740.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux@horizon.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from science.horizon.com ([192.35.100.1]:17656 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752657AbZBHL7O (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 8 Feb 2009 06:59:14 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

It was using the array name implicitly, or to be precise, macros it was
calling were using it implicitly.  Changed so it's explicit.
(And the sub-macros were inlined as unnecessary.)
---
 crypto/des_generic.c |  135 ++++++++++++++++++++++++--------------------------
 1 files changed, 65 insertions(+), 70 deletions(-)

diff --git a/crypto/des_generic.c b/crypto/des_generic.c
index 1b74adf..6434a39 100644
--- a/crypto/des_generic.c
+++ b/crypto/des_generic.c
@@ -574,12 +574,7 @@ static const u32 S8[64] = {
  * or D_i in bits 7-1 (bit 0 being the least significant).
  */
 
-#define T1(x) pt[2 * (x) + 0]
-#define T2(x) pt[2 * (x) + 1]
-#define T3(x) pt[2 * (x) + 2]
-#define T4(x) pt[2 * (x) + 3]
-
-#define PC2(a, b, c, d) (T4(d) | T3(c) | T2(b) | T1(a))
+#define PC2(p, a, b, c, d) (p[2*(a)+0] | p[2*(b)+1] | p[2*(c)+2] | p[2*(d)+3])
 
 /*
  * Encryption key expansion
@@ -604,22 +599,22 @@ unsigned long des_ekey(u32 *pe, const u8 *k)
 	b = k[6]; b &= 0x0e; b <<= 4; b |= k[2] & 0x1e; b = pc1[b];
 	a = k[7]; a &= 0x0e; a <<= 4; a |= k[3] & 0x1e; a = pc1[a];
 
-	pe[15 * 2 + 0] = PC2(a, b, c, d); d = rs[d];
-	pe[14 * 2 + 0] = PC2(d, a, b, c); c = rs[c]; b = rs[b];
-	pe[13 * 2 + 0] = PC2(b, c, d, a); a = rs[a]; d = rs[d];
-	pe[12 * 2 + 0] = PC2(d, a, b, c); c = rs[c]; b = rs[b];
-	pe[11 * 2 + 0] = PC2(b, c, d, a); a = rs[a]; d = rs[d];
-	pe[10 * 2 + 0] = PC2(d, a, b, c); c = rs[c]; b = rs[b];
-	pe[ 9 * 2 + 0] = PC2(b, c, d, a); a = rs[a]; d = rs[d];
-	pe[ 8 * 2 + 0] = PC2(d, a, b, c); c = rs[c];
-	pe[ 7 * 2 + 0] = PC2(c, d, a, b); b = rs[b]; a = rs[a];
-	pe[ 6 * 2 + 0] = PC2(a, b, c, d); d = rs[d]; c = rs[c];
-	pe[ 5 * 2 + 0] = PC2(c, d, a, b); b = rs[b]; a = rs[a];
-	pe[ 4 * 2 + 0] = PC2(a, b, c, d); d = rs[d]; c = rs[c];
-	pe[ 3 * 2 + 0] = PC2(c, d, a, b); b = rs[b]; a = rs[a];
-	pe[ 2 * 2 + 0] = PC2(a, b, c, d); d = rs[d]; c = rs[c];
-	pe[ 1 * 2 + 0] = PC2(c, d, a, b); b = rs[b];
-	pe[ 0 * 2 + 0] = PC2(b, c, d, a);
+	pe[15 * 2 + 0] = PC2(pt, a, b, c, d); d = rs[d];
+	pe[14 * 2 + 0] = PC2(pt, d, a, b, c); c = rs[c]; b = rs[b];
+	pe[13 * 2 + 0] = PC2(pt, b, c, d, a); a = rs[a]; d = rs[d];
+	pe[12 * 2 + 0] = PC2(pt, d, a, b, c); c = rs[c]; b = rs[b];
+	pe[11 * 2 + 0] = PC2(pt, b, c, d, a); a = rs[a]; d = rs[d];
+	pe[10 * 2 + 0] = PC2(pt, d, a, b, c); c = rs[c]; b = rs[b];
+	pe[ 9 * 2 + 0] = PC2(pt, b, c, d, a); a = rs[a]; d = rs[d];
+	pe[ 8 * 2 + 0] = PC2(pt, d, a, b, c); c = rs[c];
+	pe[ 7 * 2 + 0] = PC2(pt, c, d, a, b); b = rs[b]; a = rs[a];
+	pe[ 6 * 2 + 0] = PC2(pt, a, b, c, d); d = rs[d]; c = rs[c];
+	pe[ 5 * 2 + 0] = PC2(pt, c, d, a, b); b = rs[b]; a = rs[a];
+	pe[ 4 * 2 + 0] = PC2(pt, a, b, c, d); d = rs[d]; c = rs[c];
+	pe[ 3 * 2 + 0] = PC2(pt, c, d, a, b); b = rs[b]; a = rs[a];
+	pe[ 2 * 2 + 0] = PC2(pt, a, b, c, d); d = rs[d]; c = rs[c];
+	pe[ 1 * 2 + 0] = PC2(pt, c, d, a, b); b = rs[b];
+	pe[ 0 * 2 + 0] = PC2(pt, b, c, d, a);
 
 	/* Check if first half is weak */
 	w  = (a ^ c) | (b ^ d) | (rs[a] ^ c) | (b ^ rs[d]);
@@ -635,22 +630,22 @@ unsigned long des_ekey(u32 *pe, const u8 *k)
 	/* Check if second half is weak */
 	w |= (a ^ c) | (b ^ d) | (rs[a] ^ c) | (b ^ rs[d]);
 
-	pe[15 * 2 + 1] = PC2(a, b, c, d); d = rs[d];
-	pe[14 * 2 + 1] = PC2(d, a, b, c); c = rs[c]; b = rs[b];
-	pe[13 * 2 + 1] = PC2(b, c, d, a); a = rs[a]; d = rs[d];
-	pe[12 * 2 + 1] = PC2(d, a, b, c); c = rs[c]; b = rs[b];
-	pe[11 * 2 + 1] = PC2(b, c, d, a); a = rs[a]; d = rs[d];
-	pe[10 * 2 + 1] = PC2(d, a, b, c); c = rs[c]; b = rs[b];
-	pe[ 9 * 2 + 1] = PC2(b, c, d, a); a = rs[a]; d = rs[d];
-	pe[ 8 * 2 + 1] = PC2(d, a, b, c); c = rs[c];
-	pe[ 7 * 2 + 1] = PC2(c, d, a, b); b = rs[b]; a = rs[a];
-	pe[ 6 * 2 + 1] = PC2(a, b, c, d); d = rs[d]; c = rs[c];
-	pe[ 5 * 2 + 1] = PC2(c, d, a, b); b = rs[b]; a = rs[a];
-	pe[ 4 * 2 + 1] = PC2(a, b, c, d); d = rs[d]; c = rs[c];
-	pe[ 3 * 2 + 1] = PC2(c, d, a, b); b = rs[b]; a = rs[a];
-	pe[ 2 * 2 + 1] = PC2(a, b, c, d); d = rs[d]; c = rs[c];
-	pe[ 1 * 2 + 1] = PC2(c, d, a, b); b = rs[b];
-	pe[ 0 * 2 + 1] = PC2(b, c, d, a);
+	pe[15 * 2 + 1] = PC2(pt, a, b, c, d); d = rs[d];
+	pe[14 * 2 + 1] = PC2(pt, d, a, b, c); c = rs[c]; b = rs[b];
+	pe[13 * 2 + 1] = PC2(pt, b, c, d, a); a = rs[a]; d = rs[d];
+	pe[12 * 2 + 1] = PC2(pt, d, a, b, c); c = rs[c]; b = rs[b];
+	pe[11 * 2 + 1] = PC2(pt, b, c, d, a); a = rs[a]; d = rs[d];
+	pe[10 * 2 + 1] = PC2(pt, d, a, b, c); c = rs[c]; b = rs[b];
+	pe[ 9 * 2 + 1] = PC2(pt, b, c, d, a); a = rs[a]; d = rs[d];
+	pe[ 8 * 2 + 1] = PC2(pt, d, a, b, c); c = rs[c];
+	pe[ 7 * 2 + 1] = PC2(pt, c, d, a, b); b = rs[b]; a = rs[a];
+	pe[ 6 * 2 + 1] = PC2(pt, a, b, c, d); d = rs[d]; c = rs[c];
+	pe[ 5 * 2 + 1] = PC2(pt, c, d, a, b); b = rs[b]; a = rs[a];
+	pe[ 4 * 2 + 1] = PC2(pt, a, b, c, d); d = rs[d]; c = rs[c];
+	pe[ 3 * 2 + 1] = PC2(pt, c, d, a, b); b = rs[b]; a = rs[a];
+	pe[ 2 * 2 + 1] = PC2(pt, a, b, c, d); d = rs[d]; c = rs[c];
+	pe[ 1 * 2 + 1] = PC2(pt, c, d, a, b); b = rs[b];
+	pe[ 0 * 2 + 1] = PC2(pt, b, c, d, a);
 
 	/* Fixup: 2413 5768 -> 1357 2468 */
 	for (d = 0; d < 16; ++d) {
@@ -684,22 +679,22 @@ static void dkey(u32 *pe, const u8 *k)
 	b = k[6]; b &= 0x0e; b <<= 4; b |= k[2] & 0x1e; b = pc1[b];
 	a = k[7]; a &= 0x0e; a <<= 4; a |= k[3] & 0x1e; a = pc1[a];
 
-	pe[ 0 * 2] = PC2(a, b, c, d); d = rs[d];
-	pe[ 1 * 2] = PC2(d, a, b, c); c = rs[c]; b = rs[b];
-	pe[ 2 * 2] = PC2(b, c, d, a); a = rs[a]; d = rs[d];
-	pe[ 3 * 2] = PC2(d, a, b, c); c = rs[c]; b = rs[b];
-	pe[ 4 * 2] = PC2(b, c, d, a); a = rs[a]; d = rs[d];
-	pe[ 5 * 2] = PC2(d, a, b, c); c = rs[c]; b = rs[b];
-	pe[ 6 * 2] = PC2(b, c, d, a); a = rs[a]; d = rs[d];
-	pe[ 7 * 2] = PC2(d, a, b, c); c = rs[c];
-	pe[ 8 * 2] = PC2(c, d, a, b); b = rs[b]; a = rs[a];
-	pe[ 9 * 2] = PC2(a, b, c, d); d = rs[d]; c = rs[c];
-	pe[10 * 2] = PC2(c, d, a, b); b = rs[b]; a = rs[a];
-	pe[11 * 2] = PC2(a, b, c, d); d = rs[d]; c = rs[c];
-	pe[12 * 2] = PC2(c, d, a, b); b = rs[b]; a = rs[a];
-	pe[13 * 2] = PC2(a, b, c, d); d = rs[d]; c = rs[c];
-	pe[14 * 2] = PC2(c, d, a, b); b = rs[b];
-	pe[15 * 2] = PC2(b, c, d, a);
+	pe[ 0 * 2] = PC2(pt, a, b, c, d); d = rs[d];
+	pe[ 1 * 2] = PC2(pt, d, a, b, c); c = rs[c]; b = rs[b];
+	pe[ 2 * 2] = PC2(pt, b, c, d, a); a = rs[a]; d = rs[d];
+	pe[ 3 * 2] = PC2(pt, d, a, b, c); c = rs[c]; b = rs[b];
+	pe[ 4 * 2] = PC2(pt, b, c, d, a); a = rs[a]; d = rs[d];
+	pe[ 5 * 2] = PC2(pt, d, a, b, c); c = rs[c]; b = rs[b];
+	pe[ 6 * 2] = PC2(pt, b, c, d, a); a = rs[a]; d = rs[d];
+	pe[ 7 * 2] = PC2(pt, d, a, b, c); c = rs[c];
+	pe[ 8 * 2] = PC2(pt, c, d, a, b); b = rs[b]; a = rs[a];
+	pe[ 9 * 2] = PC2(pt, a, b, c, d); d = rs[d]; c = rs[c];
+	pe[10 * 2] = PC2(pt, c, d, a, b); b = rs[b]; a = rs[a];
+	pe[11 * 2] = PC2(pt, a, b, c, d); d = rs[d]; c = rs[c];
+	pe[12 * 2] = PC2(pt, c, d, a, b); b = rs[b]; a = rs[a];
+	pe[13 * 2] = PC2(pt, a, b, c, d); d = rs[d]; c = rs[c];
+	pe[14 * 2] = PC2(pt, c, d, a, b); b = rs[b];
+	pe[15 * 2] = PC2(pt, b, c, d, a);
 
 	/* Skip to next table set */
 	pt += 512;
@@ -709,22 +704,22 @@ static void dkey(u32 *pe, const u8 *k)
 	b = k[2]; b &= 0xe0; b >>= 4; b |= k[6] & 0xf0; b = pc1[b + 1];
 	a = k[3]; a &= 0xe0; a >>= 4; a |= k[7] & 0xf0; a = pc1[a + 1];
 
-	pe[ 0 * 2 + 1] = PC2(a, b, c, d); d = rs[d];
-	pe[ 1 * 2 + 1] = PC2(d, a, b, c); c = rs[c]; b = rs[b];
-	pe[ 2 * 2 + 1] = PC2(b, c, d, a); a = rs[a]; d = rs[d];
-	pe[ 3 * 2 + 1] = PC2(d, a, b, c); c = rs[c]; b = rs[b];
-	pe[ 4 * 2 + 1] = PC2(b, c, d, a); a = rs[a]; d = rs[d];
-	pe[ 5 * 2 + 1] = PC2(d, a, b, c); c = rs[c]; b = rs[b];
-	pe[ 6 * 2 + 1] = PC2(b, c, d, a); a = rs[a]; d = rs[d];
-	pe[ 7 * 2 + 1] = PC2(d, a, b, c); c = rs[c];
-	pe[ 8 * 2 + 1] = PC2(c, d, a, b); b = rs[b]; a = rs[a];
-	pe[ 9 * 2 + 1] = PC2(a, b, c, d); d = rs[d]; c = rs[c];
-	pe[10 * 2 + 1] = PC2(c, d, a, b); b = rs[b]; a = rs[a];
-	pe[11 * 2 + 1] = PC2(a, b, c, d); d = rs[d]; c = rs[c];
-	pe[12 * 2 + 1] = PC2(c, d, a, b); b = rs[b]; a = rs[a];
-	pe[13 * 2 + 1] = PC2(a, b, c, d); d = rs[d]; c = rs[c];
-	pe[14 * 2 + 1] = PC2(c, d, a, b); b = rs[b];
-	pe[15 * 2 + 1] = PC2(b, c, d, a);
+	pe[ 0 * 2 + 1] = PC2(pt, a, b, c, d); d = rs[d];
+	pe[ 1 * 2 + 1] = PC2(pt, d, a, b, c); c = rs[c]; b = rs[b];
+	pe[ 2 * 2 + 1] = PC2(pt, b, c, d, a); a = rs[a]; d = rs[d];
+	pe[ 3 * 2 + 1] = PC2(pt, d, a, b, c); c = rs[c]; b = rs[b];
+	pe[ 4 * 2 + 1] = PC2(pt, b, c, d, a); a = rs[a]; d = rs[d];
+	pe[ 5 * 2 + 1] = PC2(pt, d, a, b, c); c = rs[c]; b = rs[b];
+	pe[ 6 * 2 + 1] = PC2(pt, b, c, d, a); a = rs[a]; d = rs[d];
+	pe[ 7 * 2 + 1] = PC2(pt, d, a, b, c); c = rs[c];
+	pe[ 8 * 2 + 1] = PC2(pt, c, d, a, b); b = rs[b]; a = rs[a];
+	pe[ 9 * 2 + 1] = PC2(pt, a, b, c, d); d = rs[d]; c = rs[c];
+	pe[10 * 2 + 1] = PC2(pt, c, d, a, b); b = rs[b]; a = rs[a];
+	pe[11 * 2 + 1] = PC2(pt, a, b, c, d); d = rs[d]; c = rs[c];
+	pe[12 * 2 + 1] = PC2(pt, c, d, a, b); b = rs[b]; a = rs[a];
+	pe[13 * 2 + 1] = PC2(pt, a, b, c, d); d = rs[d]; c = rs[c];
+	pe[14 * 2 + 1] = PC2(pt, c, d, a, b); b = rs[b];
+	pe[15 * 2 + 1] = PC2(pt, b, c, d, a);
 
 	/* Fixup: 2413 5768 -> 1357 2468 */
 	for (d = 0; d < 16; ++d) {
-- 
1.6.0.6

