From: "George Spelvin" <linux@horizon.com>
Subject: [PATCH 04/10] crypto/des_generic: Simplify pc1-using code.
Date: Sun, 08 Feb 2009 06:52:25 -0500
Message-ID: <20090208115225.4984.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux@horizon.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from science.horizon.com ([192.35.100.1]:17652 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752646AbZBHL7H (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 8 Feb 2009 06:59:07 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

I think a modern compiler can do without the step-by-step
instructions and schedule it pretty well by itself.
---
 crypto/des_generic.c |   32 ++++++++++++++++----------------
 1 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/crypto/des_generic.c b/crypto/des_generic.c
index 6434a39..24d7f93 100644
--- a/crypto/des_generic.c
+++ b/crypto/des_generic.c
@@ -594,10 +594,10 @@ unsigned long des_ekey(u32 *pe, const u8 *k)
 	unsigned long a, b, c, d, w;
 	const u32 *pt = pc2;
 
-	d = k[4]; d &= 0x0e; d <<= 4; d |= k[0] & 0x1e; d = pc1[d];
-	c = k[5]; c &= 0x0e; c <<= 4; c |= k[1] & 0x1e; c = pc1[c];
-	b = k[6]; b &= 0x0e; b <<= 4; b |= k[2] & 0x1e; b = pc1[b];
-	a = k[7]; a &= 0x0e; a <<= 4; a |= k[3] & 0x1e; a = pc1[a];
+	d = pc1[ ((k[4] & 0x0e) << 4) + (k[0] & 0x1e) ];
+	c = pc1[ ((k[5] & 0x0e) << 4) + (k[1] & 0x1e) ];
+	b = pc1[ ((k[6] & 0x0e) << 4) + (k[2] & 0x1e) ];
+	a = pc1[ ((k[7] & 0x0e) << 4) + (k[3] & 0x1e) ];
 
 	pe[15 * 2 + 0] = PC2(pt, a, b, c, d); d = rs[d];
 	pe[14 * 2 + 0] = PC2(pt, d, a, b, c); c = rs[c]; b = rs[b];
@@ -622,10 +622,10 @@ unsigned long des_ekey(u32 *pe, const u8 *k)
 	/* Skip to next table set */
 	pt += 512;
 
-	d = k[0]; d &= 0xe0; d >>= 4; d |= k[4] & 0xf0; d = pc1[d + 1];
-	c = k[1]; c &= 0xe0; c >>= 4; c |= k[5] & 0xf0; c = pc1[c + 1];
-	b = k[2]; b &= 0xe0; b >>= 4; b |= k[6] & 0xf0; b = pc1[b + 1];
-	a = k[3]; a &= 0xe0; a >>= 4; a |= k[7] & 0xf0; a = pc1[a + 1];
+	d = pc1[ ((k[0] & 0xe0) >> 4) + (k[4] & 0xf0) + 1 ];
+	c = pc1[ ((k[1] & 0xe0) >> 4) + (k[5] & 0xf0) + 1 ];
+	b = pc1[ ((k[2] & 0xe0) >> 4) + (k[6] & 0xf0) + 1 ];
+	a = pc1[ ((k[3] & 0xe0) >> 4) + (k[7] & 0xf0) + 1 ];
 
 	/* Check if second half is weak */
 	w |= (a ^ c) | (b ^ d) | (rs[a] ^ c) | (b ^ rs[d]);
@@ -674,10 +674,10 @@ static void dkey(u32 *pe, const u8 *k)
 	unsigned long a, b, c, d;
 	const u32 *pt = pc2;
 
-	d = k[4]; d &= 0x0e; d <<= 4; d |= k[0] & 0x1e; d = pc1[d];
-	c = k[5]; c &= 0x0e; c <<= 4; c |= k[1] & 0x1e; c = pc1[c];
-	b = k[6]; b &= 0x0e; b <<= 4; b |= k[2] & 0x1e; b = pc1[b];
-	a = k[7]; a &= 0x0e; a <<= 4; a |= k[3] & 0x1e; a = pc1[a];
+	d = pc1[ ((k[4] & 0x0e) << 4) + (k[0] & 0x1e) ];
+	c = pc1[ ((k[5] & 0x0e) << 4) + (k[1] & 0x1e) ];
+	b = pc1[ ((k[6] & 0x0e) << 4) + (k[2] & 0x1e) ];
+	a = pc1[ ((k[7] & 0x0e) << 4) + (k[3] & 0x1e) ];
 
 	pe[ 0 * 2] = PC2(pt, a, b, c, d); d = rs[d];
 	pe[ 1 * 2] = PC2(pt, d, a, b, c); c = rs[c]; b = rs[b];
@@ -699,10 +699,10 @@ static void dkey(u32 *pe, const u8 *k)
 	/* Skip to next table set */
 	pt += 512;
 
-	d = k[0]; d &= 0xe0; d >>= 4; d |= k[4] & 0xf0; d = pc1[d + 1];
-	c = k[1]; c &= 0xe0; c >>= 4; c |= k[5] & 0xf0; c = pc1[c + 1];
-	b = k[2]; b &= 0xe0; b >>= 4; b |= k[6] & 0xf0; b = pc1[b + 1];
-	a = k[3]; a &= 0xe0; a >>= 4; a |= k[7] & 0xf0; a = pc1[a + 1];
+	d = pc1[ ((k[0] & 0xe0) >> 4) + (k[4] & 0xf0) + 1 ];
+	c = pc1[ ((k[1] & 0xe0) >> 4) + (k[5] & 0xf0) + 1 ];
+	b = pc1[ ((k[2] & 0xe0) >> 4) + (k[6] & 0xf0) + 1 ];
+	a = pc1[ ((k[3] & 0xe0) >> 4) + (k[7] & 0xf0) + 1 ];
 
 	pe[ 0 * 2 + 1] = PC2(pt, a, b, c, d); d = rs[d];
 	pe[ 1 * 2 + 1] = PC2(pt, d, a, b, c); c = rs[c]; b = rs[b];
-- 
1.6.0.6

