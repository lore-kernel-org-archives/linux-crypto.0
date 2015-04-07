From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 11/16] crypto/arm: move SHA-224/256 ARMv8 implementation to base layer
Date: Tue,  7 Apr 2015 10:51:59 +0200
Message-ID: <1428396724-19962-12-git-send-email-ard.biesheuvel@linaro.org>
References: <1428396724-19962-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: stockhausen@collogia.de, Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	x86@kernel.org, herbert@gondor.apana.org.au,
	samitolvanen@google.com, jussi.kivilinna@iki.fi
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:38839 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174AbbDGIwu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Apr 2015 04:52:50 -0400
Received: by wiun10 with SMTP id n10so9763427wiu.1
        for <linux-crypto@vger.kernel.org>; Tue, 07 Apr 2015 01:52:49 -0700 (PDT)
In-Reply-To: <1428396724-19962-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/Kconfig        |   2 +-
 arch/arm/crypto/sha2-ce-glue.c | 154 ++++++++++-------------------------------
 2 files changed, 36 insertions(+), 120 deletions(-)

diff --git a/arch/arm/crypto/Kconfig b/arch/arm/crypto/Kconfig
index 5ed98bc6f95d..a267529d9577 100644
--- a/arch/arm/crypto/Kconfig
+++ b/arch/arm/crypto/Kconfig
@@ -39,7 +39,7 @@ config CRYPTO_SHA1_ARM_CE
 config CRYPTO_SHA2_ARM_CE
 	tristate "SHA-224/256 digest algorithm (ARM v8 Crypto Extensions)"
 	depends on KERNEL_MODE_NEON
-	select CRYPTO_SHA256
+	select CRYPTO_SHA256_ARM
 	select CRYPTO_HASH
 	help
 	  SHA-256 secure hash standard (DFIPS 180-2) implemented
diff --git a/arch/arm/crypto/sha2-ce-glue.c b/arch/arm/crypto/sha2-ce-glue.c
index 0449eca3aab3..6110b937264c 100644
--- a/arch/arm/crypto/sha2-ce-glue.c
+++ b/arch/arm/crypto/sha2-ce-glue.c
@@ -10,6 +10,7 @@
 
 #include <crypto/internal/hash.h>
 #include <crypto/sha.h>
+#include <crypto/sha256_base.h>
 #include <linux/crypto.h>
 #include <linux/module.h>
 
@@ -18,145 +19,59 @@
 #include <asm/neon.h>
 #include <asm/unaligned.h>
 
+#include "sha256_glue.h"
+
 MODULE_DESCRIPTION("SHA-224/SHA-256 secure hash using ARMv8 Crypto Extensions");
 MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
 MODULE_LICENSE("GPL v2");
 
 asmlinkage void sha2_ce_transform(int blocks, u8 const *src, u32 *state,
-				  u8 *head);
+				  const u8 *head, void *p);
 
-static int sha224_init(struct shash_desc *desc)
+static int sha2_ce_update(struct shash_desc *desc, const u8 *data,
+			  unsigned int len)
 {
 	struct sha256_state *sctx = shash_desc_ctx(desc);
 
-	*sctx = (struct sha256_state){
-		.state = {
-			SHA224_H0, SHA224_H1, SHA224_H2, SHA224_H3,
-			SHA224_H4, SHA224_H5, SHA224_H6, SHA224_H7,
-		}
-	};
-	return 0;
-}
+	if (!may_use_simd() ||
+	    (sctx->count % SHA256_BLOCK_SIZE) + len < SHA256_BLOCK_SIZE)
+		return crypto_sha256_arm_update(desc, data, len);
 
-static int sha256_init(struct shash_desc *desc)
-{
-	struct sha256_state *sctx = shash_desc_ctx(desc);
+	kernel_neon_begin();
+	sha256_base_do_update(desc, data, len, sha2_ce_transform, NULL);
+	kernel_neon_end();
 
-	*sctx = (struct sha256_state){
-		.state = {
-			SHA256_H0, SHA256_H1, SHA256_H2, SHA256_H3,
-			SHA256_H4, SHA256_H5, SHA256_H6, SHA256_H7,
-		}
-	};
 	return 0;
 }
 
-static int sha2_update(struct shash_desc *desc, const u8 *data,
-		       unsigned int len)
+static int sha2_ce_finup(struct shash_desc *desc, const u8 *data,
+			 unsigned int len, u8 *out)
 {
-	struct sha256_state *sctx = shash_desc_ctx(desc);
-	unsigned int partial;
-
 	if (!may_use_simd())
-		return crypto_sha256_update(desc, data, len);
-
-	partial = sctx->count % SHA256_BLOCK_SIZE;
-	sctx->count += len;
-
-	if ((partial + len) >= SHA256_BLOCK_SIZE) {
-		int blocks;
-
-		if (partial) {
-			int p = SHA256_BLOCK_SIZE - partial;
-
-			memcpy(sctx->buf + partial, data, p);
-			data += p;
-			len -= p;
-		}
-
-		blocks = len / SHA256_BLOCK_SIZE;
-		len %= SHA256_BLOCK_SIZE;
+		return crypto_sha256_arm_finup(desc, data, len, out);
 
-		kernel_neon_begin();
-		sha2_ce_transform(blocks, data, sctx->state,
-				  partial ? sctx->buf : NULL);
-		kernel_neon_end();
-
-		data += blocks * SHA256_BLOCK_SIZE;
-		partial = 0;
-	}
+	kernel_neon_begin();
 	if (len)
-		memcpy(sctx->buf + partial, data, len);
-	return 0;
-}
-
-static void sha2_final(struct shash_desc *desc)
-{
-	static const u8 padding[SHA256_BLOCK_SIZE] = { 0x80, };
+		sha256_base_do_update(desc, data, len,
+					     sha2_ce_transform, NULL);
+	sha256_base_do_finalize(desc, sha2_ce_transform, NULL);
+	kernel_neon_end();
 
-	struct sha256_state *sctx = shash_desc_ctx(desc);
-	__be64 bits = cpu_to_be64(sctx->count << 3);
-	u32 padlen = SHA256_BLOCK_SIZE
-		     - ((sctx->count + sizeof(bits)) % SHA256_BLOCK_SIZE);
-
-	sha2_update(desc, padding, padlen);
-	sha2_update(desc, (const u8 *)&bits, sizeof(bits));
+	return sha256_base_finish(desc, out);
 }
 
-static int sha224_final(struct shash_desc *desc, u8 *out)
+static int sha2_ce_final(struct shash_desc *desc, u8 *out)
 {
-	struct sha256_state *sctx = shash_desc_ctx(desc);
-	__be32 *dst = (__be32 *)out;
-	int i;
-
-	sha2_final(desc);
-
-	for (i = 0; i < SHA224_DIGEST_SIZE / sizeof(__be32); i++)
-		put_unaligned_be32(sctx->state[i], dst++);
-
-	*sctx = (struct sha256_state){};
-	return 0;
-}
-
-static int sha256_final(struct shash_desc *desc, u8 *out)
-{
-	struct sha256_state *sctx = shash_desc_ctx(desc);
-	__be32 *dst = (__be32 *)out;
-	int i;
-
-	sha2_final(desc);
-
-	for (i = 0; i < SHA256_DIGEST_SIZE / sizeof(__be32); i++)
-		put_unaligned_be32(sctx->state[i], dst++);
-
-	*sctx = (struct sha256_state){};
-	return 0;
-}
-
-static int sha2_export(struct shash_desc *desc, void *out)
-{
-	struct sha256_state *sctx = shash_desc_ctx(desc);
-	struct sha256_state *dst = out;
-
-	*dst = *sctx;
-	return 0;
-}
-
-static int sha2_import(struct shash_desc *desc, const void *in)
-{
-	struct sha256_state *sctx = shash_desc_ctx(desc);
-	struct sha256_state const *src = in;
-
-	*sctx = *src;
-	return 0;
+	return sha2_ce_finup(desc, NULL, 0, out);
 }
 
 static struct shash_alg algs[] = { {
-	.init			= sha224_init,
-	.update			= sha2_update,
-	.final			= sha224_final,
-	.export			= sha2_export,
-	.import			= sha2_import,
+	.init			= sha224_base_init,
+	.update			= sha2_ce_update,
+	.final			= sha2_ce_final,
+	.finup			= sha2_ce_finup,
+	.export			= sha256_base_export,
+	.import			= sha256_base_import,
 	.descsize		= sizeof(struct sha256_state),
 	.digestsize		= SHA224_DIGEST_SIZE,
 	.statesize		= sizeof(struct sha256_state),
@@ -169,11 +84,12 @@ static struct shash_alg algs[] = { {
 		.cra_module		= THIS_MODULE,
 	}
 }, {
-	.init			= sha256_init,
-	.update			= sha2_update,
-	.final			= sha256_final,
-	.export			= sha2_export,
-	.import			= sha2_import,
+	.init			= sha256_base_init,
+	.update			= sha2_ce_update,
+	.final			= sha2_ce_final,
+	.finup			= sha2_ce_finup,
+	.export			= sha256_base_export,
+	.import			= sha256_base_import,
 	.descsize		= sizeof(struct sha256_state),
 	.digestsize		= SHA256_DIGEST_SIZE,
 	.statesize		= sizeof(struct sha256_state),
-- 
1.8.3.2
