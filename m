From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 08/16] crypto/arm: move SHA-1 NEON implementation to base layer
Date: Tue,  7 Apr 2015 10:51:56 +0200
Message-ID: <1428396724-19962-9-git-send-email-ard.biesheuvel@linaro.org>
References: <1428396724-19962-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: stockhausen@collogia.de, Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	x86@kernel.org, herbert@gondor.apana.org.au,
	samitolvanen@google.com, jussi.kivilinna@iki.fi
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:35592 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963AbbDGIwn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Apr 2015 04:52:43 -0400
Received: by widdi4 with SMTP id di4so8941553wid.0
        for <linux-crypto@vger.kernel.org>; Tue, 07 Apr 2015 01:52:42 -0700 (PDT)
In-Reply-To: <1428396724-19962-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/sha1_neon_glue.c | 137 +++++++++------------------------------
 1 file changed, 30 insertions(+), 107 deletions(-)

diff --git a/arch/arm/crypto/sha1_neon_glue.c b/arch/arm/crypto/sha1_neon_glue.c
index 5d9a1b4aac73..4280f657fb9d 100644
--- a/arch/arm/crypto/sha1_neon_glue.c
+++ b/arch/arm/crypto/sha1_neon_glue.c
@@ -25,7 +25,7 @@
 #include <linux/cryptohash.h>
 #include <linux/types.h>
 #include <crypto/sha.h>
-#include <asm/byteorder.h>
+#include <crypto/sha1_base.h>
 #include <asm/neon.h>
 #include <asm/simd.h>
 
@@ -34,136 +34,59 @@
 asmlinkage void sha1_transform_neon(void *state_h, const char *data,
 				    unsigned int rounds);
 
-
-static int sha1_neon_init(struct shash_desc *desc)
+static void sha1_neon_block_fn(int blocks, u8 const *src, u32 *state,
+			      const u8 *head, void *p)
 {
-	struct sha1_state *sctx = shash_desc_ctx(desc);
-
-	*sctx = (struct sha1_state){
-		.state = { SHA1_H0, SHA1_H1, SHA1_H2, SHA1_H3, SHA1_H4 },
-	};
-
-	return 0;
-}
-
-static int __sha1_neon_update(struct shash_desc *desc, const u8 *data,
-			       unsigned int len, unsigned int partial)
-{
-	struct sha1_state *sctx = shash_desc_ctx(desc);
-	unsigned int done = 0;
-
-	sctx->count += len;
-
-	if (partial) {
-		done = SHA1_BLOCK_SIZE - partial;
-		memcpy(sctx->buffer + partial, data, done);
-		sha1_transform_neon(sctx->state, sctx->buffer, 1);
-	}
-
-	if (len - done >= SHA1_BLOCK_SIZE) {
-		const unsigned int rounds = (len - done) / SHA1_BLOCK_SIZE;
-
-		sha1_transform_neon(sctx->state, data + done, rounds);
-		done += rounds * SHA1_BLOCK_SIZE;
-	}
-
-	memcpy(sctx->buffer, data + done, len - done);
-
-	return 0;
+	if (head)
+		sha1_transform_neon(state, head, 1);
+	if (blocks)
+		sha1_transform_neon(state, src, blocks);
 }
 
 static int sha1_neon_update(struct shash_desc *desc, const u8 *data,
-			     unsigned int len)
-{
-	struct sha1_state *sctx = shash_desc_ctx(desc);
-	unsigned int partial = sctx->count % SHA1_BLOCK_SIZE;
-	int res;
-
-	/* Handle the fast case right here */
-	if (partial + len < SHA1_BLOCK_SIZE) {
-		sctx->count += len;
-		memcpy(sctx->buffer + partial, data, len);
-
-		return 0;
-	}
-
-	if (!may_use_simd()) {
-		res = sha1_update_arm(desc, data, len);
-	} else {
-		kernel_neon_begin();
-		res = __sha1_neon_update(desc, data, len, partial);
-		kernel_neon_end();
-	}
-
-	return res;
-}
-
-
-/* Add padding and return the message digest. */
-static int sha1_neon_final(struct shash_desc *desc, u8 *out)
+			  unsigned int len)
 {
 	struct sha1_state *sctx = shash_desc_ctx(desc);
-	unsigned int i, index, padlen;
-	__be32 *dst = (__be32 *)out;
-	__be64 bits;
-	static const u8 padding[SHA1_BLOCK_SIZE] = { 0x80, };
-
-	bits = cpu_to_be64(sctx->count << 3);
-
-	/* Pad out to 56 mod 64 and append length */
-	index = sctx->count % SHA1_BLOCK_SIZE;
-	padlen = (index < 56) ? (56 - index) : ((SHA1_BLOCK_SIZE+56) - index);
-	if (!may_use_simd()) {
-		sha1_update_arm(desc, padding, padlen);
-		sha1_update_arm(desc, (const u8 *)&bits, sizeof(bits));
-	} else {
-		kernel_neon_begin();
-		/* We need to fill a whole block for __sha1_neon_update() */
-		if (padlen <= 56) {
-			sctx->count += padlen;
-			memcpy(sctx->buffer + index, padding, padlen);
-		} else {
-			__sha1_neon_update(desc, padding, padlen, index);
-		}
-		__sha1_neon_update(desc, (const u8 *)&bits, sizeof(bits), 56);
-		kernel_neon_end();
-	}
 
-	/* Store state in digest */
-	for (i = 0; i < 5; i++)
-		dst[i] = cpu_to_be32(sctx->state[i]);
+	if (!may_use_simd() ||
+	    (sctx->count % SHA1_BLOCK_SIZE) + len < SHA1_BLOCK_SIZE)
+		return sha1_update_arm(desc, data, len);
 
-	/* Wipe context */
-	memset(sctx, 0, sizeof(*sctx));
+	kernel_neon_begin();
+	sha1_base_do_update(desc, data, len, sha1_neon_block_fn, NULL);
+	kernel_neon_end();
 
 	return 0;
 }
 
-static int sha1_neon_export(struct shash_desc *desc, void *out)
+static int sha1_neon_finup(struct shash_desc *desc, const u8 *data,
+			   unsigned int len, u8 *out)
 {
-	struct sha1_state *sctx = shash_desc_ctx(desc);
+	if (!may_use_simd())
+		return sha1_finup_arm(desc, data, len, out);
 
-	memcpy(out, sctx, sizeof(*sctx));
+	kernel_neon_begin();
+	if (len)
+		sha1_base_do_update(desc, data, len, sha1_neon_block_fn, NULL);
+	sha1_base_do_finalize(desc, sha1_neon_block_fn, NULL);
+	kernel_neon_end();
 
-	return 0;
+	return sha1_base_finish(desc, out);
 }
 
-static int sha1_neon_import(struct shash_desc *desc, const void *in)
+static int sha1_neon_final(struct shash_desc *desc, u8 *out)
 {
-	struct sha1_state *sctx = shash_desc_ctx(desc);
-
-	memcpy(sctx, in, sizeof(*sctx));
-
-	return 0;
+	return sha1_neon_finup(desc, NULL, 0, out);
 }
 
 static struct shash_alg alg = {
 	.digestsize	=	SHA1_DIGEST_SIZE,
-	.init		=	sha1_neon_init,
+	.init		=	sha1_base_init,
 	.update		=	sha1_neon_update,
 	.final		=	sha1_neon_final,
-	.export		=	sha1_neon_export,
-	.import		=	sha1_neon_import,
+	.finup		=	sha1_neon_finup,
+	.export		=	sha1_base_export,
+	.import		=	sha1_base_import,
 	.descsize	=	sizeof(struct sha1_state),
 	.statesize	=	sizeof(struct sha1_state),
 	.base		=	{
-- 
1.8.3.2
