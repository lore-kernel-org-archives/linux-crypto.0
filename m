From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 10/16] crypto/arm: move SHA-224/256 ASM/NEON implementation to base layer
Date: Tue,  7 Apr 2015 10:51:58 +0200
Message-ID: <1428396724-19962-11-git-send-email-ard.biesheuvel@linaro.org>
References: <1428396724-19962-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: stockhausen@collogia.de, Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	x86@kernel.org, herbert@gondor.apana.org.au,
	samitolvanen@google.com, jussi.kivilinna@iki.fi
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:34425 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112AbbDGIws (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Apr 2015 04:52:48 -0400
Received: by widjs5 with SMTP id js5so5693196wid.1
        for <linux-crypto@vger.kernel.org>; Tue, 07 Apr 2015 01:52:47 -0700 (PDT)
In-Reply-To: <1428396724-19962-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/sha256_glue.c      | 174 ++++++++-----------------------------
 arch/arm/crypto/sha256_glue.h      |  17 +---
 arch/arm/crypto/sha256_neon_glue.c | 144 +++++++++---------------------
 3 files changed, 81 insertions(+), 254 deletions(-)

diff --git a/arch/arm/crypto/sha256_glue.c b/arch/arm/crypto/sha256_glue.c
index ccef5e25bbcb..6f14a5a0a467 100644
--- a/arch/arm/crypto/sha256_glue.c
+++ b/arch/arm/crypto/sha256_glue.c
@@ -24,163 +24,56 @@
 #include <linux/types.h>
 #include <linux/string.h>
 #include <crypto/sha.h>
-#include <asm/byteorder.h>
+#include <crypto/sha256_base.h>
 #include <asm/simd.h>
 #include <asm/neon.h>
+
 #include "sha256_glue.h"
 
 asmlinkage void sha256_block_data_order(u32 *digest, const void *data,
-				      unsigned int num_blks);
-
+					unsigned int num_blks);
 
-int sha256_init(struct shash_desc *desc)
+static void sha256_arm_block_fn(int blocks, u8 const *src, u32 *state,
+				const u8 *head, void *p)
 {
-	struct sha256_state *sctx = shash_desc_ctx(desc);
-
-	sctx->state[0] = SHA256_H0;
-	sctx->state[1] = SHA256_H1;
-	sctx->state[2] = SHA256_H2;
-	sctx->state[3] = SHA256_H3;
-	sctx->state[4] = SHA256_H4;
-	sctx->state[5] = SHA256_H5;
-	sctx->state[6] = SHA256_H6;
-	sctx->state[7] = SHA256_H7;
-	sctx->count = 0;
-
-	return 0;
+	if (head)
+		sha256_block_data_order(state, head, 1);
+	if (blocks)
+		sha256_block_data_order(state, src, blocks);
 }
 
-int sha224_init(struct shash_desc *desc)
+int crypto_sha256_arm_update(struct shash_desc *desc, const u8 *data,
+			     unsigned int len)
 {
-	struct sha256_state *sctx = shash_desc_ctx(desc);
-
-	sctx->state[0] = SHA224_H0;
-	sctx->state[1] = SHA224_H1;
-	sctx->state[2] = SHA224_H2;
-	sctx->state[3] = SHA224_H3;
-	sctx->state[4] = SHA224_H4;
-	sctx->state[5] = SHA224_H5;
-	sctx->state[6] = SHA224_H6;
-	sctx->state[7] = SHA224_H7;
-	sctx->count = 0;
-
-	return 0;
+	return sha256_base_do_update(desc, data, len, sha256_arm_block_fn,
+				     NULL);
 }
+EXPORT_SYMBOL(crypto_sha256_arm_update);
 
-int __sha256_update(struct shash_desc *desc, const u8 *data, unsigned int len,
-		    unsigned int partial)
+int crypto_sha256_arm_finup(struct shash_desc *desc, const u8 *data,
+			    unsigned int len, u8 *hash)
 {
-	struct sha256_state *sctx = shash_desc_ctx(desc);
-	unsigned int done = 0;
-
-	sctx->count += len;
-
-	if (partial) {
-		done = SHA256_BLOCK_SIZE - partial;
-		memcpy(sctx->buf + partial, data, done);
-		sha256_block_data_order(sctx->state, sctx->buf, 1);
-	}
-
-	if (len - done >= SHA256_BLOCK_SIZE) {
-		const unsigned int rounds = (len - done) / SHA256_BLOCK_SIZE;
-
-		sha256_block_data_order(sctx->state, data + done, rounds);
-		done += rounds * SHA256_BLOCK_SIZE;
-	}
-
-	memcpy(sctx->buf, data + done, len - done);
-
-	return 0;
+	if (len)
+		sha256_base_do_update(desc, data, len, sha256_arm_block_fn,
+				      NULL);
+	sha256_base_do_finalize(desc, sha256_arm_block_fn, NULL);
+	return sha256_base_finish(desc, hash);
 }
+EXPORT_SYMBOL(crypto_sha256_arm_finup);
 
-int sha256_update(struct shash_desc *desc, const u8 *data, unsigned int len)
-{
-	struct sha256_state *sctx = shash_desc_ctx(desc);
-	unsigned int partial = sctx->count % SHA256_BLOCK_SIZE;
-
-	/* Handle the fast case right here */
-	if (partial + len < SHA256_BLOCK_SIZE) {
-		sctx->count += len;
-		memcpy(sctx->buf + partial, data, len);
-
-		return 0;
-	}
-
-	return __sha256_update(desc, data, len, partial);
-}
-
-/* Add padding and return the message digest. */
 static int sha256_final(struct shash_desc *desc, u8 *out)
 {
-	struct sha256_state *sctx = shash_desc_ctx(desc);
-	unsigned int i, index, padlen;
-	__be32 *dst = (__be32 *)out;
-	__be64 bits;
-	static const u8 padding[SHA256_BLOCK_SIZE] = { 0x80, };
-
-	/* save number of bits */
-	bits = cpu_to_be64(sctx->count << 3);
-
-	/* Pad out to 56 mod 64 and append length */
-	index = sctx->count % SHA256_BLOCK_SIZE;
-	padlen = (index < 56) ? (56 - index) : ((SHA256_BLOCK_SIZE+56)-index);
-
-	/* We need to fill a whole block for __sha256_update */
-	if (padlen <= 56) {
-		sctx->count += padlen;
-		memcpy(sctx->buf + index, padding, padlen);
-	} else {
-		__sha256_update(desc, padding, padlen, index);
-	}
-	__sha256_update(desc, (const u8 *)&bits, sizeof(bits), 56);
-
-	/* Store state in digest */
-	for (i = 0; i < 8; i++)
-		dst[i] = cpu_to_be32(sctx->state[i]);
-
-	/* Wipe context */
-	memset(sctx, 0, sizeof(*sctx));
-
-	return 0;
-}
-
-static int sha224_final(struct shash_desc *desc, u8 *out)
-{
-	u8 D[SHA256_DIGEST_SIZE];
-
-	sha256_final(desc, D);
-
-	memcpy(out, D, SHA224_DIGEST_SIZE);
-	memzero_explicit(D, SHA256_DIGEST_SIZE);
-
-	return 0;
-}
-
-int sha256_export(struct shash_desc *desc, void *out)
-{
-	struct sha256_state *sctx = shash_desc_ctx(desc);
-
-	memcpy(out, sctx, sizeof(*sctx));
-
-	return 0;
-}
-
-int sha256_import(struct shash_desc *desc, const void *in)
-{
-	struct sha256_state *sctx = shash_desc_ctx(desc);
-
-	memcpy(sctx, in, sizeof(*sctx));
-
-	return 0;
+	return crypto_sha256_finup(desc, NULL, 0, out);
 }
 
 static struct shash_alg algs[] = { {
 	.digestsize	=	SHA256_DIGEST_SIZE,
-	.init		=	sha256_init,
-	.update		=	sha256_update,
+	.init		=	sha256_base_init,
+	.update		=	crypto_sha256_arm_update,
 	.final		=	sha256_final,
-	.export		=	sha256_export,
-	.import		=	sha256_import,
+	.finup		=	crypto_sha256_arm_finup,
+	.export		=	sha256_base_export,
+	.import		=	sha256_base_import,
 	.descsize	=	sizeof(struct sha256_state),
 	.statesize	=	sizeof(struct sha256_state),
 	.base		=	{
@@ -193,11 +86,12 @@ static struct shash_alg algs[] = { {
 	}
 }, {
 	.digestsize	=	SHA224_DIGEST_SIZE,
-	.init		=	sha224_init,
-	.update		=	sha256_update,
-	.final		=	sha224_final,
-	.export		=	sha256_export,
-	.import		=	sha256_import,
+	.init		=	sha224_base_init,
+	.update		=	crypto_sha256_arm_update,
+	.final		=	sha256_final,
+	.finup		=	crypto_sha256_arm_finup,
+	.export		=	sha256_base_export,
+	.import		=	sha256_base_import,
 	.descsize	=	sizeof(struct sha256_state),
 	.statesize	=	sizeof(struct sha256_state),
 	.base		=	{
diff --git a/arch/arm/crypto/sha256_glue.h b/arch/arm/crypto/sha256_glue.h
index 0312f4ffe8cc..7cf0bf786ada 100644
--- a/arch/arm/crypto/sha256_glue.h
+++ b/arch/arm/crypto/sha256_glue.h
@@ -2,22 +2,13 @@
 #define _CRYPTO_SHA256_GLUE_H
 
 #include <linux/crypto.h>
-#include <crypto/sha.h>
 
 extern struct shash_alg sha256_neon_algs[2];
 
-extern int sha256_init(struct shash_desc *desc);
+int crypto_sha256_arm_update(struct shash_desc *desc, const u8 *data,
+			     unsigned int len);
 
-extern int sha224_init(struct shash_desc *desc);
-
-extern int __sha256_update(struct shash_desc *desc, const u8 *data,
-			   unsigned int len, unsigned int partial);
-
-extern int sha256_update(struct shash_desc *desc, const u8 *data,
-			 unsigned int len);
-
-extern int sha256_export(struct shash_desc *desc, void *out);
-
-extern int sha256_import(struct shash_desc *desc, const void *in);
+int crypto_sha256_arm_finup(struct shash_desc *desc, const u8 *data,
+			    unsigned int len, u8 *hash);
 
 #endif /* _CRYPTO_SHA256_GLUE_H */
diff --git a/arch/arm/crypto/sha256_neon_glue.c b/arch/arm/crypto/sha256_neon_glue.c
index c4da10090eee..90053d9dc5bd 100644
--- a/arch/arm/crypto/sha256_neon_glue.c
+++ b/arch/arm/crypto/sha256_neon_glue.c
@@ -19,129 +19,70 @@
 #include <linux/types.h>
 #include <linux/string.h>
 #include <crypto/sha.h>
+#include <crypto/sha256_base.h>
 #include <asm/byteorder.h>
 #include <asm/simd.h>
 #include <asm/neon.h>
+
 #include "sha256_glue.h"
 
 asmlinkage void sha256_block_data_order_neon(u32 *digest, const void *data,
-				      unsigned int num_blks);
-
+					     unsigned int num_blks);
 
-static int __sha256_neon_update(struct shash_desc *desc, const u8 *data,
-				unsigned int len, unsigned int partial)
+static void sha256_neon_block_fn(int blocks, u8 const *src, u32 *state,
+				 const u8 *head, void *p)
 {
-	struct sha256_state *sctx = shash_desc_ctx(desc);
-	unsigned int done = 0;
-
-	sctx->count += len;
-
-	if (partial) {
-		done = SHA256_BLOCK_SIZE - partial;
-		memcpy(sctx->buf + partial, data, done);
-		sha256_block_data_order_neon(sctx->state, sctx->buf, 1);
-	}
-
-	if (len - done >= SHA256_BLOCK_SIZE) {
-		const unsigned int rounds = (len - done) / SHA256_BLOCK_SIZE;
-
-		sha256_block_data_order_neon(sctx->state, data + done, rounds);
-		done += rounds * SHA256_BLOCK_SIZE;
-	}
-
-	memcpy(sctx->buf, data + done, len - done);
-
-	return 0;
+	if (head)
+		sha256_block_data_order_neon(state, head, 1);
+	if (blocks)
+		sha256_block_data_order_neon(state, src, blocks);
 }
 
-static int sha256_neon_update(struct shash_desc *desc, const u8 *data,
-			      unsigned int len)
+static int sha256_update(struct shash_desc *desc, const u8 *data,
+			 unsigned int len)
 {
 	struct sha256_state *sctx = shash_desc_ctx(desc);
-	unsigned int partial = sctx->count % SHA256_BLOCK_SIZE;
-	int res;
 
-	/* Handle the fast case right here */
-	if (partial + len < SHA256_BLOCK_SIZE) {
-		sctx->count += len;
-		memcpy(sctx->buf + partial, data, len);
+	if (!may_use_simd() ||
+	    (sctx->count % SHA256_BLOCK_SIZE) + len < SHA256_BLOCK_SIZE)
+		return crypto_sha256_arm_update(desc, data, len);
 
-		return 0;
-	}
+	kernel_neon_begin();
+	sha256_base_do_update(desc, data, len, sha256_neon_block_fn, NULL);
+	kernel_neon_end();
 
-	if (!may_use_simd()) {
-		res = __sha256_update(desc, data, len, partial);
-	} else {
-		kernel_neon_begin();
-		res = __sha256_neon_update(desc, data, len, partial);
-		kernel_neon_end();
-	}
-
-	return res;
+	return 0;
 }
 
-/* Add padding and return the message digest. */
-static int sha256_neon_final(struct shash_desc *desc, u8 *out)
+static int sha256_finup(struct shash_desc *desc, const u8 *data,
+			unsigned int len, u8 *out)
 {
-	struct sha256_state *sctx = shash_desc_ctx(desc);
-	unsigned int i, index, padlen;
-	__be32 *dst = (__be32 *)out;
-	__be64 bits;
-	static const u8 padding[SHA256_BLOCK_SIZE] = { 0x80, };
-
-	/* save number of bits */
-	bits = cpu_to_be64(sctx->count << 3);
-
-	/* Pad out to 56 mod 64 and append length */
-	index = sctx->count % SHA256_BLOCK_SIZE;
-	padlen = (index < 56) ? (56 - index) : ((SHA256_BLOCK_SIZE+56)-index);
-
-	if (!may_use_simd()) {
-		sha256_update(desc, padding, padlen);
-		sha256_update(desc, (const u8 *)&bits, sizeof(bits));
-	} else {
-		kernel_neon_begin();
-		/* We need to fill a whole block for __sha256_neon_update() */
-		if (padlen <= 56) {
-			sctx->count += padlen;
-			memcpy(sctx->buf + index, padding, padlen);
-		} else {
-			__sha256_neon_update(desc, padding, padlen, index);
-		}
-		__sha256_neon_update(desc, (const u8 *)&bits,
-					sizeof(bits), 56);
-		kernel_neon_end();
-	}
+	if (!may_use_simd())
+		return crypto_sha256_arm_finup(desc, data, len, out);
 
-	/* Store state in digest */
-	for (i = 0; i < 8; i++)
-		dst[i] = cpu_to_be32(sctx->state[i]);
+	kernel_neon_begin();
+	if (len)
+		sha256_base_do_update(desc, data, len, sha256_neon_block_fn,
+				      NULL);
+	sha256_base_do_finalize(desc, sha256_neon_block_fn, NULL);
+	kernel_neon_end();
 
-	/* Wipe context */
-	memzero_explicit(sctx, sizeof(*sctx));
-
-	return 0;
+	return sha256_base_finish(desc, out);
 }
 
-static int sha224_neon_final(struct shash_desc *desc, u8 *out)
+static int sha256_final(struct shash_desc *desc, u8 *out)
 {
-	u8 D[SHA256_DIGEST_SIZE];
-
-	sha256_neon_final(desc, D);
-
-	memcpy(out, D, SHA224_DIGEST_SIZE);
-	memzero_explicit(D, SHA256_DIGEST_SIZE);
-
-	return 0;
+	return sha256_finup(desc, NULL, 0, out);
 }
 
 struct shash_alg sha256_neon_algs[] = { {
 	.digestsize	=	SHA256_DIGEST_SIZE,
-	.init		=	sha256_init,
-	.update		=	sha256_neon_update,
-	.final		=	sha256_neon_final,
-	.export		=	sha256_export,
-	.import		=	sha256_import,
+	.init		=	sha256_base_init,
+	.update		=	sha256_update,
+	.final		=	sha256_final,
+	.finup		=	sha256_finup,
+	.export		=	sha256_base_export,
+	.import		=	sha256_base_import,
 	.descsize	=	sizeof(struct sha256_state),
 	.statesize	=	sizeof(struct sha256_state),
 	.base		=	{
@@ -154,11 +95,12 @@ struct shash_alg sha256_neon_algs[] = { {
 	}
 }, {
 	.digestsize	=	SHA224_DIGEST_SIZE,
-	.init		=	sha224_init,
-	.update		=	sha256_neon_update,
-	.final		=	sha224_neon_final,
-	.export		=	sha256_export,
-	.import		=	sha256_import,
+	.init		=	sha224_base_init,
+	.update		=	sha256_update,
+	.final		=	sha256_final,
+	.finup		=	sha256_finup,
+	.export		=	sha256_base_export,
+	.import		=	sha256_base_import,
 	.descsize	=	sizeof(struct sha256_state),
 	.statesize	=	sizeof(struct sha256_state),
 	.base		=	{
-- 
1.8.3.2
