From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4/35] crypto: sha256_generic - Use 64-bit counter like sha1
Date: Wed, 15 Jul 2009 15:15:56 +0800
Message-ID: <E1MQyia-0004yD-Od@gondolin.me.apana.org.au>
References: <20090715071424.GA19023@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:53612 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752547AbZGOHP6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jul 2009 03:15:58 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1MQyib-0004o9-1a
	for <linux-crypto@vger.kernel.org>; Wed, 15 Jul 2009 17:15:57 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: sha256_generic - Use 64-bit counter like sha1

This patch replaces the two 32-bit counter code in sha256_generic
with the simpler 64-bit counter code from sha1.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/sha256_generic.c |   65 ++++++++++++++++++++++--------------------------
 1 file changed, 30 insertions(+), 35 deletions(-)

diff --git a/crypto/sha256_generic.c b/crypto/sha256_generic.c
index 6349d83..e58c71b 100644
--- a/crypto/sha256_generic.c
+++ b/crypto/sha256_generic.c
@@ -26,7 +26,7 @@
 #include <asm/byteorder.h>
 
 struct sha256_ctx {
-	u32 count[2];
+	u64 count;
 	u32 state[8];
 	u8 buf[128];
 };
@@ -231,8 +231,7 @@ static int sha224_init(struct shash_desc *desc)
 	sctx->state[5] = SHA224_H5;
 	sctx->state[6] = SHA224_H6;
 	sctx->state[7] = SHA224_H7;
-	sctx->count[0] = 0;
-	sctx->count[1] = 0;
+	sctx->count = 0;
 
 	return 0;
 }
@@ -248,7 +247,7 @@ static int sha256_init(struct shash_desc *desc)
 	sctx->state[5] = SHA256_H5;
 	sctx->state[6] = SHA256_H6;
 	sctx->state[7] = SHA256_H7;
-	sctx->count[0] = sctx->count[1] = 0;
+	sctx->count = 0;
 
 	return 0;
 }
@@ -257,33 +256,30 @@ static int sha256_update(struct shash_desc *desc, const u8 *data,
 			  unsigned int len)
 {
 	struct sha256_ctx *sctx = shash_desc_ctx(desc);
-	unsigned int i, index, part_len;
-
-	/* Compute number of bytes mod 128 */
-	index = (unsigned int)((sctx->count[0] >> 3) & 0x3f);
-
-	/* Update number of bits */
-	if ((sctx->count[0] += (len << 3)) < (len << 3)) {
-		sctx->count[1]++;
-		sctx->count[1] += (len >> 29);
+	unsigned int partial, done;
+	const u8 *src;
+
+	partial = sctx->count & 0x3f;
+	sctx->count += len;
+	done = 0;
+	src = data;
+
+	if ((partial + len) > 63) {
+		if (partial) {
+			done = -partial;
+			memcpy(sctx->buf + partial, data, done + 64);
+			src = sctx->buf;
+		}
+
+		do {
+			sha256_transform(sctx->state, src);
+			done += 64;
+			src = data + done;
+		} while (done + 63 < len);
+
+		partial = 0;
 	}
-
-	part_len = 64 - index;
-
-	/* Transform as many times as possible. */
-	if (len >= part_len) {
-		memcpy(&sctx->buf[index], data, part_len);
-		sha256_transform(sctx->state, sctx->buf);
-
-		for (i = part_len; i + 63 < len; i += 64)
-			sha256_transform(sctx->state, &data[i]);
-		index = 0;
-	} else {
-		i = 0;
-	}
-
-	/* Buffer remaining input */
-	memcpy(&sctx->buf[index], &data[i], len-i);
+	memcpy(sctx->buf + partial, src, len - done);
 
 	return 0;
 }
@@ -292,22 +288,21 @@ static int sha256_final(struct shash_desc *desc, u8 *out)
 {
 	struct sha256_ctx *sctx = shash_desc_ctx(desc);
 	__be32 *dst = (__be32 *)out;
-	__be32 bits[2];
+	__be64 bits;
 	unsigned int index, pad_len;
 	int i;
 	static const u8 padding[64] = { 0x80, };
 
 	/* Save number of bits */
-	bits[1] = cpu_to_be32(sctx->count[0]);
-	bits[0] = cpu_to_be32(sctx->count[1]);
+	bits = cpu_to_be64(sctx->count << 3);
 
 	/* Pad out to 56 mod 64. */
-	index = (sctx->count[0] >> 3) & 0x3f;
+	index = sctx->count & 0x3f;
 	pad_len = (index < 56) ? (56 - index) : ((64+56) - index);
 	sha256_update(desc, padding, pad_len);
 
 	/* Append length (before padding) */
-	sha256_update(desc, (const u8 *)bits, sizeof(bits));
+	sha256_update(desc, (const u8 *)&bits, sizeof(bits));
 
 	/* Store state in digest */
 	for (i = 0; i < 8; i++)
