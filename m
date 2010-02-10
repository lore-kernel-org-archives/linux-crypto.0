From: Richard Hartmann <richih.mailinglist@gmail.com>
Subject: [PATCH 1/1] CRYPTO: Fix checkpatch errors & warnings in cast6.c
Date: Wed, 10 Feb 2010 02:29:53 +0100
Message-ID: <1265765394-24647-1-git-send-email-richih.mailinglist@gmail.com>
Cc: Richard Hartmann <richih.mailinglist@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34045 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755122Ab0BJBa3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Feb 2010 20:30:29 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Richard Hartmann <richih.mailinglist@gmail.com>
---
 crypto/cast6.c |  122 ++++++++++++++++++++++++++++---------------------------
 1 files changed, 62 insertions(+), 60 deletions(-)

diff --git a/crypto/cast6.c b/crypto/cast6.c
index 007d02b..e0c15a6 100644
--- a/crypto/cast6.c
+++ b/crypto/cast6.c
@@ -11,7 +11,7 @@
  * under the terms of GNU General Public License as published by the Free
  * Software Foundation; either version 2 of the License, or (at your option)
  * any later version.
- * 
+ *
  * You should have received a copy of the GNU General Public License
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA
@@ -35,12 +35,12 @@ struct cast6_ctx {
 	u8 Kr[12][4];
 };
 
-#define F1(D,r,m)  (  (I = ((m) + (D))), (I=rol32(I,(r))),   \
-    (((s1[I >> 24] ^ s2[(I>>16)&0xff]) - s3[(I>>8)&0xff]) + s4[I&0xff]) )
-#define F2(D,r,m)  (  (I = ((m) ^ (D))), (I=rol32(I,(r))),   \
-    (((s1[I >> 24] - s2[(I>>16)&0xff]) + s3[(I>>8)&0xff]) ^ s4[I&0xff]) )
-#define F3(D,r,m)  (  (I = ((m) - (D))), (I=rol32(I,(r))),   \
-    (((s1[I >> 24] + s2[(I>>16)&0xff]) ^ s3[(I>>8)&0xff]) - s4[I&0xff]) )
+#define F1(D, r, m)  ((I = ((m) + (D))), (I = rol32(I, (r))),   \
+    (((s1[I >> 24] ^ s2[(I>>16)&0xff]) - s3[(I>>8)&0xff]) + s4[I&0xff]))
+#define F2(D, r, m)  ((I = ((m) ^ (D))), (I = rol32(I, (r))),   \
+    (((s1[I >> 24] - s2[(I>>16)&0xff]) + s3[(I>>8)&0xff]) ^ s4[I&0xff]))
+#define F3(D, r, m)  ((I = ((m) - (D))), (I = rol32(I, (r))),   \
+    (((s1[I >> 24] + s2[(I>>16)&0xff]) ^ s3[(I>>8)&0xff]) - s4[I&0xff]))
 
 static const u32 s1[256] = {
 	0x30fb40d4, 0x9fa0ff0b, 0x6beccd2f, 0x3f258c7a, 0x1e213f2f,
@@ -312,7 +312,7 @@ static const u32 s4[256] = {
 
 static const u32 Tm[24][8] = {
 	{ 0x5a827999, 0xc95c653a, 0x383650db, 0xa7103c7c, 0x15ea281d,
-		0x84c413be, 0xf39dff5f, 0x6277eb00 } , 
+		0x84c413be, 0xf39dff5f, 0x6277eb00 } ,
 	{ 0xd151d6a1, 0x402bc242, 0xaf05ade3, 0x1ddf9984, 0x8cb98525,
 		0xfb9370c6, 0x6a6d5c67, 0xd9474808 } ,
 	{ 0x482133a9, 0xb6fb1f4a, 0x25d50aeb, 0x94aef68c, 0x0388e22d,
@@ -369,7 +369,8 @@ static const u8 Tr[4][8] = {
 };
 
 /* forward octave */
-static void W(u32 *key, unsigned int i) {
+static void W(u32 *key, unsigned int i)
+{
 	u32 I;
 	key[6] ^= F1(key[7], Tr[i % 4][0], Tm[i][0]);
 	key[5] ^= F2(key[6], Tr[i % 4][1], Tm[i][1]);
@@ -377,7 +378,7 @@ static void W(u32 *key, unsigned int i) {
 	key[3] ^= F1(key[4], Tr[i % 4][3], Tm[i][3]);
 	key[2] ^= F2(key[3], Tr[i % 4][4], Tm[i][4]);
 	key[1] ^= F3(key[2], Tr[i % 4][5], Tm[i][5]);
-	key[0] ^= F1(key[1], Tr[i % 4][6], Tm[i][6]);	
+	key[0] ^= F1(key[1], Tr[i % 4][6], Tm[i][6]);
 	key[7] ^= F2(key[0], Tr[i % 4][7], Tm[i][7]);
 }
 
@@ -393,11 +394,11 @@ static int cast6_setkey(struct crypto_tfm *tfm, const u8 *in_key,
 	if (key_len % 4 != 0) {
 		*flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
 		return -EINVAL;
-	}	
+	}
+
+	memset(p_key, 0, 32);
+	memcpy(p_key, in_key, key_len);
 
-	memset (p_key, 0, 32);
-	memcpy (p_key, in_key, key_len);
-	
 	key[0] = be32_to_cpu(p_key[0]);		/* A */
 	key[1] = be32_to_cpu(p_key[1]);		/* B */
 	key[2] = be32_to_cpu(p_key[2]);		/* C */
@@ -406,18 +407,16 @@ static int cast6_setkey(struct crypto_tfm *tfm, const u8 *in_key,
 	key[5] = be32_to_cpu(p_key[5]);		/* F */
 	key[6] = be32_to_cpu(p_key[6]);		/* G */
 	key[7] = be32_to_cpu(p_key[7]);		/* H */
-	
-
 
 	for (i = 0; i < 12; i++) {
-		W (key, 2 * i);
-		W (key, 2 * i + 1);
-		
+		W(key, 2 * i);
+		W(key, 2 * i + 1);
+
 		c->Kr[i][0] = key[0] & 0x1f;
 		c->Kr[i][1] = key[2] & 0x1f;
 		c->Kr[i][2] = key[4] & 0x1f;
 		c->Kr[i][3] = key[6] & 0x1f;
-		
+
 		c->Km[i][0] = key[7];
 		c->Km[i][1] = key[5];
 		c->Km[i][2] = key[3];
@@ -428,21 +427,23 @@ static int cast6_setkey(struct crypto_tfm *tfm, const u8 *in_key,
 }
 
 /*forward quad round*/
-static void Q (u32 * block, u8 * Kr, u32 * Km) {
+static void Q(u32 *block, u8 *Kr, u32 *Km)
+{
 	u32 I;
 	block[2] ^= F1(block[3], Kr[0], Km[0]);
 	block[1] ^= F2(block[2], Kr[1], Km[1]);
 	block[0] ^= F3(block[1], Kr[2], Km[2]);
-	block[3] ^= F1(block[0], Kr[3], Km[3]);		
+	block[3] ^= F1(block[0], Kr[3], Km[3]);
 }
 
 /*reverse quad round*/
-static void QBAR (u32 * block, u8 * Kr, u32 * Km) {
+static void QBAR(u32 *block, u8 *Kr, u32 *Km)
+{
 	u32 I;
-        block[3] ^= F1(block[0], Kr[3], Km[3]);
-        block[0] ^= F3(block[1], Kr[2], Km[2]);
-        block[1] ^= F2(block[2], Kr[1], Km[1]);
-        block[2] ^= F1(block[3], Kr[0], Km[0]);
+	block[3] ^= F1(block[0], Kr[3], Km[3]);
+	block[0] ^= F3(block[1], Kr[2], Km[2]);
+	block[1] ^= F2(block[2], Kr[1], Km[1]);
+	block[2] ^= F1(block[3], Kr[0], Km[0]);
 }
 
 static void cast6_encrypt(struct crypto_tfm *tfm, u8 *outbuf, const u8 *inbuf)
@@ -451,64 +452,65 @@ static void cast6_encrypt(struct crypto_tfm *tfm, u8 *outbuf, const u8 *inbuf)
 	const __be32 *src = (const __be32 *)inbuf;
 	__be32 *dst = (__be32 *)outbuf;
 	u32 block[4];
-	u32 * Km; 
-	u8 * Kr;
+	u32 *Km;
+	u8 *Kr;
 
 	block[0] = be32_to_cpu(src[0]);
 	block[1] = be32_to_cpu(src[1]);
 	block[2] = be32_to_cpu(src[2]);
 	block[3] = be32_to_cpu(src[3]);
 
-	Km = c->Km[0]; Kr = c->Kr[0]; Q (block, Kr, Km);
-	Km = c->Km[1]; Kr = c->Kr[1]; Q (block, Kr, Km);
-	Km = c->Km[2]; Kr = c->Kr[2]; Q (block, Kr, Km);
-	Km = c->Km[3]; Kr = c->Kr[3]; Q (block, Kr, Km);
-	Km = c->Km[4]; Kr = c->Kr[4]; Q (block, Kr, Km);
-	Km = c->Km[5]; Kr = c->Kr[5]; Q (block, Kr, Km);
-	Km = c->Km[6]; Kr = c->Kr[6]; QBAR (block, Kr, Km);
-	Km = c->Km[7]; Kr = c->Kr[7]; QBAR (block, Kr, Km);
-	Km = c->Km[8]; Kr = c->Kr[8]; QBAR (block, Kr, Km);
-	Km = c->Km[9]; Kr = c->Kr[9]; QBAR (block, Kr, Km);
-	Km = c->Km[10]; Kr = c->Kr[10]; QBAR (block, Kr, Km);
-	Km = c->Km[11]; Kr = c->Kr[11]; QBAR (block, Kr, Km);
+	Km = c->Km[0]; Kr = c->Kr[0]; Q(block, Kr, Km);
+	Km = c->Km[1]; Kr = c->Kr[1]; Q(block, Kr, Km);
+	Km = c->Km[2]; Kr = c->Kr[2]; Q(block, Kr, Km);
+	Km = c->Km[3]; Kr = c->Kr[3]; Q(block, Kr, Km);
+	Km = c->Km[4]; Kr = c->Kr[4]; Q(block, Kr, Km);
+	Km = c->Km[5]; Kr = c->Kr[5]; Q(block, Kr, Km);
+	Km = c->Km[6]; Kr = c->Kr[6]; QBAR(block, Kr, Km);
+	Km = c->Km[7]; Kr = c->Kr[7]; QBAR(block, Kr, Km);
+	Km = c->Km[8]; Kr = c->Kr[8]; QBAR(block, Kr, Km);
+	Km = c->Km[9]; Kr = c->Kr[9]; QBAR(block, Kr, Km);
+	Km = c->Km[10]; Kr = c->Kr[10]; QBAR(block, Kr, Km);
+	Km = c->Km[11]; Kr = c->Kr[11]; QBAR(block, Kr, Km);
 
 	dst[0] = cpu_to_be32(block[0]);
 	dst[1] = cpu_to_be32(block[1]);
 	dst[2] = cpu_to_be32(block[2]);
 	dst[3] = cpu_to_be32(block[3]);
-}	
+}
 
-static void cast6_decrypt(struct crypto_tfm *tfm, u8 *outbuf, const u8 *inbuf) {
-	struct cast6_ctx * c = crypto_tfm_ctx(tfm);
+static void cast6_decrypt(struct crypto_tfm *tfm, u8 *outbuf, const u8 *inbuf)
+{
+	struct cast6_ctx *c = crypto_tfm_ctx(tfm);
 	const __be32 *src = (const __be32 *)inbuf;
 	__be32 *dst = (__be32 *)outbuf;
 	u32 block[4];
-	u32 * Km; 
-	u8 * Kr;
+	u32 *Km;
+	u8 *Kr;
 
 	block[0] = be32_to_cpu(src[0]);
 	block[1] = be32_to_cpu(src[1]);
 	block[2] = be32_to_cpu(src[2]);
 	block[3] = be32_to_cpu(src[3]);
 
-	Km = c->Km[11]; Kr = c->Kr[11]; Q (block, Kr, Km);
-	Km = c->Km[10]; Kr = c->Kr[10]; Q (block, Kr, Km);
-	Km = c->Km[9]; Kr = c->Kr[9]; Q (block, Kr, Km);
-	Km = c->Km[8]; Kr = c->Kr[8]; Q (block, Kr, Km);
-	Km = c->Km[7]; Kr = c->Kr[7]; Q (block, Kr, Km);
-	Km = c->Km[6]; Kr = c->Kr[6]; Q (block, Kr, Km);
-	Km = c->Km[5]; Kr = c->Kr[5]; QBAR (block, Kr, Km);
-	Km = c->Km[4]; Kr = c->Kr[4]; QBAR (block, Kr, Km);
-	Km = c->Km[3]; Kr = c->Kr[3]; QBAR (block, Kr, Km);
-	Km = c->Km[2]; Kr = c->Kr[2]; QBAR (block, Kr, Km);
-	Km = c->Km[1]; Kr = c->Kr[1]; QBAR (block, Kr, Km);
-	Km = c->Km[0]; Kr = c->Kr[0]; QBAR (block, Kr, Km);
-	
+	Km = c->Km[11]; Kr = c->Kr[11]; Q(block, Kr, Km);
+	Km = c->Km[10]; Kr = c->Kr[10]; Q(block, Kr, Km);
+	Km = c->Km[9]; Kr = c->Kr[9]; Q(block, Kr, Km);
+	Km = c->Km[8]; Kr = c->Kr[8]; Q(block, Kr, Km);
+	Km = c->Km[7]; Kr = c->Kr[7]; Q(block, Kr, Km);
+	Km = c->Km[6]; Kr = c->Kr[6]; Q(block, Kr, Km);
+	Km = c->Km[5]; Kr = c->Kr[5]; QBAR(block, Kr, Km);
+	Km = c->Km[4]; Kr = c->Kr[4]; QBAR(block, Kr, Km);
+	Km = c->Km[3]; Kr = c->Kr[3]; QBAR(block, Kr, Km);
+	Km = c->Km[2]; Kr = c->Kr[2]; QBAR(block, Kr, Km);
+	Km = c->Km[1]; Kr = c->Kr[1]; QBAR(block, Kr, Km);
+	Km = c->Km[0]; Kr = c->Kr[0]; QBAR(block, Kr, Km);
+
 	dst[0] = cpu_to_be32(block[0]);
 	dst[1] = cpu_to_be32(block[1]);
 	dst[2] = cpu_to_be32(block[2]);
 	dst[3] = cpu_to_be32(block[3]);
-}	
+}
 
 static struct crypto_alg alg = {
 	.cra_name = "cast6",
-- 
1.6.6.1

