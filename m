From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4/6] crypto: sha512_generic - Use 64-bit counters
Date: Wed, 22 Jul 2009 14:40:07 +0800
Message-ID: <E1MTVUl-0007k0-LL@gondolin.me.apana.org.au>
References: <20090722063844.GA28998@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:51384 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753257AbZGVGkI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jul 2009 02:40:08 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1MTVUl-0005yv-VO
	for <linux-crypto@vger.kernel.org>; Wed, 22 Jul 2009 16:40:08 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: sha512_generic - Use 64-bit counters

This patch replaces the 32-bit counters in sha512_generic with
64-bit counters.  It also switches the bit count to the simpler
byte count.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/sha512_generic.c |   28 +++++++++++-----------------
 include/crypto/sha.h    |    6 +++---
 2 files changed, 14 insertions(+), 20 deletions(-)

diff --git a/crypto/sha512_generic.c b/crypto/sha512_generic.c
index 4fe95eb..9ed9f60 100644
--- a/crypto/sha512_generic.c
+++ b/crypto/sha512_generic.c
@@ -144,7 +144,7 @@ sha512_init(struct shash_desc *desc)
 	sctx->state[5] = SHA512_H5;
 	sctx->state[6] = SHA512_H6;
 	sctx->state[7] = SHA512_H7;
-	sctx->count[0] = sctx->count[1] = sctx->count[2] = sctx->count[3] = 0;
+	sctx->count[0] = sctx->count[1] = 0;
 
 	return 0;
 }
@@ -161,7 +161,7 @@ sha384_init(struct shash_desc *desc)
 	sctx->state[5] = SHA384_H5;
 	sctx->state[6] = SHA384_H6;
 	sctx->state[7] = SHA384_H7;
-        sctx->count[0] = sctx->count[1] = sctx->count[2] = sctx->count[3] = 0;
+	sctx->count[0] = sctx->count[1] = 0;
 
 	return 0;
 }
@@ -174,15 +174,11 @@ sha512_update(struct shash_desc *desc, const u8 *data, unsigned int len)
 	unsigned int i, index, part_len;
 
 	/* Compute number of bytes mod 128 */
-	index = (unsigned int)((sctx->count[0] >> 3) & 0x7F);
-
-	/* Update number of bits */
-	if ((sctx->count[0] += (len << 3)) < (len << 3)) {
-		if ((sctx->count[1] += 1) < 1)
-			if ((sctx->count[2] += 1) < 1)
-				sctx->count[3]++;
-		sctx->count[1] += (len >> 29);
-	}
+	index = sctx->count[0] & 0x7f;
+
+	/* Update number of bytes */
+	if (!(sctx->count[0] += len))
+		sctx->count[1]++;
 
         part_len = 128 - index;
 
@@ -211,18 +207,16 @@ sha512_final(struct shash_desc *desc, u8 *hash)
 	struct sha512_state *sctx = shash_desc_ctx(desc);
         static u8 padding[128] = { 0x80, };
 	__be64 *dst = (__be64 *)hash;
-	__be32 bits[4];
+	__be64 bits[2];
 	unsigned int index, pad_len;
 	int i;
 
 	/* Save number of bits */
-	bits[3] = cpu_to_be32(sctx->count[0]);
-	bits[2] = cpu_to_be32(sctx->count[1]);
-	bits[1] = cpu_to_be32(sctx->count[2]);
-	bits[0] = cpu_to_be32(sctx->count[3]);
+	bits[1] = cpu_to_be64(sctx->count[0] << 3);
+	bits[0] = cpu_to_be64(sctx->count[1] << 3 | sctx->count[0] >> 61);
 
 	/* Pad out to 112 mod 128. */
-	index = (sctx->count[0] >> 3) & 0x7f;
+	index = sctx->count[0] & 0x7f;
 	pad_len = (index < 112) ? (112 - index) : ((128+112) - index);
 	sha512_update(desc, padding, pad_len);
 
diff --git a/include/crypto/sha.h b/include/crypto/sha.h
index 45b25cc..069e85b 100644
--- a/include/crypto/sha.h
+++ b/include/crypto/sha.h
@@ -77,9 +77,9 @@ struct sha256_state {
 };
 
 struct sha512_state {
-	u64 state[8];
-	u32 count[4];
-	u8 buf[128];
+	u64 count[2];
+	u64 state[SHA512_DIGEST_SIZE / 8];
+	u8 buf[SHA512_BLOCK_SIZE];
 };
 
 #endif
