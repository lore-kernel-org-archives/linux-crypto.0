From: "George Spelvin" <linux@horizon.com>
Subject: [PATCH 08/10] crypto/des_generic.c: des_dkey code shrink.
Date: Sun, 08 Feb 2009 06:54:08 -0500
Message-ID: <20090208115408.5998.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux@horizon.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from science.horizon.com ([192.35.100.1]:17686 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752742AbZBHMAu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 8 Feb 2009 07:00:50 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Some loss in speed, but a great space savings.
---
 crypto/des_generic.c |   72 +++++++++-----------------------------------------
 1 files changed, 13 insertions(+), 59 deletions(-)

diff --git a/crypto/des_generic.c b/crypto/des_generic.c
index 656039b..baf51cf 100644
--- a/crypto/des_generic.c
+++ b/crypto/des_generic.c
@@ -667,68 +667,22 @@ EXPORT_SYMBOL_GPL(des_ekey);
  *
  * No weak key checking is performed, as this is only used by triple DES
  *
+ * Since the decryption round keys are just the encryption round keys in
+ * reverse order, this just generates the encryption key and reverses it.
+ * A special-purpose function would be faster, but it would waste a lot of
+ * space.
  */
 sstatic void des_dkey(u32 pe[DES_EXPKEY_WORDS], const u8 k[DES_KEY_SIZE])
 {
-	/* K&R: long is at least 32 bits */
-	unsigned long a, b, c, d;
-	const u32 *pt = pc2;
-
-	d = pc1[ ((k[4] & 0x0e) << 4) + (k[0] & 0x1e) ];
-	c = pc1[ ((k[5] & 0x0e) << 4) + (k[1] & 0x1e) ];
-	b = pc1[ ((k[6] & 0x0e) << 4) + (k[2] & 0x1e) ];
-	a = pc1[ ((k[7] & 0x0e) << 4) + (k[3] & 0x1e) ];
-
-	pe[ 0 * 2] = PC2(pt, a, b, c, d); d = rs[d];
-	pe[ 1 * 2] = PC2(pt, d, a, b, c); c = rs[c]; b = rs[b];
-	pe[ 2 * 2] = PC2(pt, b, c, d, a); a = rs[a]; d = rs[d];
-	pe[ 3 * 2] = PC2(pt, d, a, b, c); c = rs[c]; b = rs[b];
-	pe[ 4 * 2] = PC2(pt, b, c, d, a); a = rs[a]; d = rs[d];
-	pe[ 5 * 2] = PC2(pt, d, a, b, c); c = rs[c]; b = rs[b];
-	pe[ 6 * 2] = PC2(pt, b, c, d, a); a = rs[a]; d = rs[d];
-	pe[ 7 * 2] = PC2(pt, d, a, b, c); c = rs[c];
-	pe[ 8 * 2] = PC2(pt, c, d, a, b); b = rs[b]; a = rs[a];
-	pe[ 9 * 2] = PC2(pt, a, b, c, d); d = rs[d]; c = rs[c];
-	pe[10 * 2] = PC2(pt, c, d, a, b); b = rs[b]; a = rs[a];
-	pe[11 * 2] = PC2(pt, a, b, c, d); d = rs[d]; c = rs[c];
-	pe[12 * 2] = PC2(pt, c, d, a, b); b = rs[b]; a = rs[a];
-	pe[13 * 2] = PC2(pt, a, b, c, d); d = rs[d]; c = rs[c];
-	pe[14 * 2] = PC2(pt, c, d, a, b); b = rs[b];
-	pe[15 * 2] = PC2(pt, b, c, d, a);
-
-	/* Skip to next table set */
-	pt += 512;
-
-	d = pc1[ ((k[0] & 0xe0) >> 4) + (k[4] & 0xf0) + 1 ];
-	c = pc1[ ((k[1] & 0xe0) >> 4) + (k[5] & 0xf0) + 1 ];
-	b = pc1[ ((k[2] & 0xe0) >> 4) + (k[6] & 0xf0) + 1 ];
-	a = pc1[ ((k[3] & 0xe0) >> 4) + (k[7] & 0xf0) + 1 ];
-
-	pe[ 0 * 2 + 1] = PC2(pt, a, b, c, d); d = rs[d];
-	pe[ 1 * 2 + 1] = PC2(pt, d, a, b, c); c = rs[c]; b = rs[b];
-	pe[ 2 * 2 + 1] = PC2(pt, b, c, d, a); a = rs[a]; d = rs[d];
-	pe[ 3 * 2 + 1] = PC2(pt, d, a, b, c); c = rs[c]; b = rs[b];
-	pe[ 4 * 2 + 1] = PC2(pt, b, c, d, a); a = rs[a]; d = rs[d];
-	pe[ 5 * 2 + 1] = PC2(pt, d, a, b, c); c = rs[c]; b = rs[b];
-	pe[ 6 * 2 + 1] = PC2(pt, b, c, d, a); a = rs[a]; d = rs[d];
-	pe[ 7 * 2 + 1] = PC2(pt, d, a, b, c); c = rs[c];
-	pe[ 8 * 2 + 1] = PC2(pt, c, d, a, b); b = rs[b]; a = rs[a];
-	pe[ 9 * 2 + 1] = PC2(pt, a, b, c, d); d = rs[d]; c = rs[c];
-	pe[10 * 2 + 1] = PC2(pt, c, d, a, b); b = rs[b]; a = rs[a];
-	pe[11 * 2 + 1] = PC2(pt, a, b, c, d); d = rs[d]; c = rs[c];
-	pe[12 * 2 + 1] = PC2(pt, c, d, a, b); b = rs[b]; a = rs[a];
-	pe[13 * 2 + 1] = PC2(pt, a, b, c, d); d = rs[d]; c = rs[c];
-	pe[14 * 2 + 1] = PC2(pt, c, d, a, b); b = rs[b];
-	pe[15 * 2 + 1] = PC2(pt, b, c, d, a);
+	int i;
 
-	/* Fixup: 2413 5768 -> 1357 2468 */
-	for (d = 0; d < 16; ++d) {
-		a = pe[2 * d];
-		b = pe[2 * d + 1];
-		MASKSWAP(a, b, c, 0xffff0000);
-		ROL(b, 18);
-		pe[2 * d] = a;
-		pe[2 * d + 1] = b;
+	des_ekey(pe, k)
+	/* Swap 0<->30, 1<->31, 2<->28, 3<->29, 4<->26,... 14<->16, 15<->17 */
+	for (i = 0; i < 16; i++) {
+		int j = 0x1e ^ i;
+		u32 t = pe[i];
+		pe[i] = pe[j];
+		pe[j] = t;
 	}
 }
 
-- 
1.6.0.6

