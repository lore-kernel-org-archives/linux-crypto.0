From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 07/14] crypto/arm: move SHA-1 ARM asm implementation to base layer
Date: Mon, 30 Mar 2015 11:36:22 +0200
Message-ID: <1427708184-2353-13-git-send-email-ard.biesheuvel@linaro.org>
References: <1427708184-2353-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	samitolvanen@google.com, herbert@gondor.apana.org.au,
	jussi.kivilinna@iki.fi, stockhausen@collogia.de, x86@kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:37099 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880AbbC3JhR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 30 Mar 2015 05:37:17 -0400
Received: by wiaa2 with SMTP id a2so120340581wia.0
        for <linux-crypto@vger.kernel.org>; Mon, 30 Mar 2015 02:37:15 -0700 (PDT)
In-Reply-To: <1427708184-2353-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/Kconfig                  |   1 +
 arch/arm/{include/asm => }/crypto/sha1.h |   3 +
 arch/arm/crypto/sha1_glue.c              | 117 +++++++------------------------
 3 files changed, 28 insertions(+), 93 deletions(-)
 rename arch/arm/{include/asm => }/crypto/sha1.h (67%)

diff --git a/arch/arm/crypto/Kconfig b/arch/arm/crypto/Kconfig
index d63f319924d2..c111d8992afb 100644
--- a/arch/arm/crypto/Kconfig
+++ b/arch/arm/crypto/Kconfig
@@ -11,6 +11,7 @@ if ARM_CRYPTO
 config CRYPTO_SHA1_ARM
 	tristate "SHA1 digest algorithm (ARM-asm)"
 	select CRYPTO_SHA1
+	select CRYPTO_SHA1_BASE
 	select CRYPTO_HASH
 	help
 	  SHA-1 secure hash standard (FIPS 180-1/DFIPS 180-2) implemented
diff --git a/arch/arm/include/asm/crypto/sha1.h b/arch/arm/crypto/sha1.h
similarity index 67%
rename from arch/arm/include/asm/crypto/sha1.h
rename to arch/arm/crypto/sha1.h
index 75e6a417416b..ffd8bd08b1a7 100644
--- a/arch/arm/include/asm/crypto/sha1.h
+++ b/arch/arm/crypto/sha1.h
@@ -7,4 +7,7 @@
 extern int sha1_update_arm(struct shash_desc *desc, const u8 *data,
 			   unsigned int len);
 
+extern int sha1_finup_arm(struct shash_desc *desc, const u8 *data,
+			   unsigned int len, u8 *out);
+
 #endif
diff --git a/arch/arm/crypto/sha1_glue.c b/arch/arm/crypto/sha1_glue.c
index e31b0440c613..b6a78be0367f 100644
--- a/arch/arm/crypto/sha1_glue.c
+++ b/arch/arm/crypto/sha1_glue.c
@@ -23,124 +23,55 @@
 #include <linux/types.h>
 #include <crypto/sha.h>
 #include <asm/byteorder.h>
-#include <asm/crypto/sha1.h>
 
+#include "sha1.h"
 
 asmlinkage void sha1_block_data_order(u32 *digest,
 		const unsigned char *data, unsigned int rounds);
 
-
-static int sha1_init(struct shash_desc *desc)
-{
-	struct sha1_state *sctx = shash_desc_ctx(desc);
-
-	*sctx = (struct sha1_state){
-		.state = { SHA1_H0, SHA1_H1, SHA1_H2, SHA1_H3, SHA1_H4 },
-	};
-
-	return 0;
-}
-
-
-static int __sha1_update(struct sha1_state *sctx, const u8 *data,
-			 unsigned int len, unsigned int partial)
+static void sha1_arm_block_fn(int blocks, u8 const *src, u32 *state,
+			      const u8 *head, void *p)
 {
-	unsigned int done = 0;
-
-	sctx->count += len;
-
-	if (partial) {
-		done = SHA1_BLOCK_SIZE - partial;
-		memcpy(sctx->buffer + partial, data, done);
-		sha1_block_data_order(sctx->state, sctx->buffer, 1);
-	}
-
-	if (len - done >= SHA1_BLOCK_SIZE) {
-		const unsigned int rounds = (len - done) / SHA1_BLOCK_SIZE;
-		sha1_block_data_order(sctx->state, data + done, rounds);
-		done += rounds * SHA1_BLOCK_SIZE;
-	}
-
-	memcpy(sctx->buffer, data + done, len - done);
-	return 0;
+	if (head)
+		sha1_block_data_order(state, head, 1);
+	if (blocks)
+		sha1_block_data_order(state, src, blocks);
 }
 
-
 int sha1_update_arm(struct shash_desc *desc, const u8 *data,
 		    unsigned int len)
 {
-	struct sha1_state *sctx = shash_desc_ctx(desc);
-	unsigned int partial = sctx->count % SHA1_BLOCK_SIZE;
-	int res;
-
-	/* Handle the fast case right here */
-	if (partial + len < SHA1_BLOCK_SIZE) {
-		sctx->count += len;
-		memcpy(sctx->buffer + partial, data, len);
-		return 0;
-	}
-	res = __sha1_update(sctx, data, len, partial);
-	return res;
+	return crypto_sha1_base_do_update(desc, data, len, sha1_arm_block_fn,
+					  NULL);
 }
 EXPORT_SYMBOL_GPL(sha1_update_arm);
 
-
-/* Add padding and return the message digest. */
-static int sha1_final(struct shash_desc *desc, u8 *out)
+int sha1_finup_arm(struct shash_desc *desc, const u8 *data,
+		   unsigned int len, u8 *out)
 {
-	struct sha1_state *sctx = shash_desc_ctx(desc);
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
-	/* We need to fill a whole block for __sha1_update() */
-	if (padlen <= 56) {
-		sctx->count += padlen;
-		memcpy(sctx->buffer + index, padding, padlen);
-	} else {
-		__sha1_update(sctx, padding, padlen, index);
-	}
-	__sha1_update(sctx, (const u8 *)&bits, sizeof(bits), 56);
-
-	/* Store state in digest */
-	for (i = 0; i < 5; i++)
-		dst[i] = cpu_to_be32(sctx->state[i]);
-
-	/* Wipe context */
-	memset(sctx, 0, sizeof(*sctx));
-	return 0;
-}
-
+	if (len)
+		crypto_sha1_base_do_update(desc, data, len,
+					   sha1_arm_block_fn, NULL);
+	crypto_sha1_base_do_finalize(desc, sha1_arm_block_fn, NULL);
 
-static int sha1_export(struct shash_desc *desc, void *out)
-{
-	struct sha1_state *sctx = shash_desc_ctx(desc);
-	memcpy(out, sctx, sizeof(*sctx));
-	return 0;
+	return crypto_sha1_base_finish(desc, out);
 }
+EXPORT_SYMBOL_GPL(sha1_finup_arm);
 
-
-static int sha1_import(struct shash_desc *desc, const void *in)
+/* Add padding and return the message digest. */
+static int sha1_final(struct shash_desc *desc, u8 *out)
 {
-	struct sha1_state *sctx = shash_desc_ctx(desc);
-	memcpy(sctx, in, sizeof(*sctx));
-	return 0;
+	return sha1_finup_arm(desc, NULL, 0, out);
 }
 
-
 static struct shash_alg alg = {
 	.digestsize	=	SHA1_DIGEST_SIZE,
-	.init		=	sha1_init,
+	.init		=	crypto_sha1_base_init,
 	.update		=	sha1_update_arm,
 	.final		=	sha1_final,
-	.export		=	sha1_export,
-	.import		=	sha1_import,
+	.finup		=	sha1_finup_arm,
+	.export		=	crypto_sha1_base_export,
+	.import		=	crypto_sha1_base_import,
 	.descsize	=	sizeof(struct sha1_state),
 	.statesize	=	sizeof(struct sha1_state),
 	.base		=	{
-- 
1.8.3.2
