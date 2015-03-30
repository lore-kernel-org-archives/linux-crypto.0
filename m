From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 08/14] crypto/arm: move SHA-1 ARMv8 implementation to base layer
Date: Mon, 30 Mar 2015 11:36:23 +0200
Message-ID: <1427708184-2353-14-git-send-email-ard.biesheuvel@linaro.org>
References: <1427708184-2353-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	samitolvanen@google.com, herbert@gondor.apana.org.au,
	jussi.kivilinna@iki.fi, stockhausen@collogia.de, x86@kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:35271 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873AbbC3JhS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 30 Mar 2015 05:37:18 -0400
Received: by wgdm6 with SMTP id m6so167072783wgd.2
        for <linux-crypto@vger.kernel.org>; Mon, 30 Mar 2015 02:37:17 -0700 (PDT)
In-Reply-To: <1427708184-2353-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/Kconfig        |   2 +-
 arch/arm/crypto/sha1-ce-glue.c | 110 +++++++++++------------------------------
 2 files changed, 31 insertions(+), 81 deletions(-)

diff --git a/arch/arm/crypto/Kconfig b/arch/arm/crypto/Kconfig
index c111d8992afb..31ad19f18af2 100644
--- a/arch/arm/crypto/Kconfig
+++ b/arch/arm/crypto/Kconfig
@@ -32,7 +32,7 @@ config CRYPTO_SHA1_ARM_CE
 	tristate "SHA1 digest algorithm (ARM v8 Crypto Extensions)"
 	depends on KERNEL_MODE_NEON
 	select CRYPTO_SHA1_ARM
-	select CRYPTO_SHA1
+	select CRYPTO_SHA1_BASE
 	select CRYPTO_HASH
 	help
 	  SHA-1 secure hash standard (FIPS 180-1/DFIPS 180-2) implemented
diff --git a/arch/arm/crypto/sha1-ce-glue.c b/arch/arm/crypto/sha1-ce-glue.c
index a9dd90df9fd7..29039d1bcdf9 100644
--- a/arch/arm/crypto/sha1-ce-glue.c
+++ b/arch/arm/crypto/sha1-ce-glue.c
@@ -13,114 +13,64 @@
 #include <linux/crypto.h>
 #include <linux/module.h>
 
-#include <asm/crypto/sha1.h>
 #include <asm/hwcap.h>
 #include <asm/neon.h>
 #include <asm/simd.h>
 #include <asm/unaligned.h>
 
+#include "sha1.h"
+
 MODULE_DESCRIPTION("SHA1 secure hash using ARMv8 Crypto Extensions");
 MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
 MODULE_LICENSE("GPL v2");
 
-asmlinkage void sha1_ce_transform(int blocks, u8 const *src, u32 *state, 
-				  u8 *head);
-
-static int sha1_init(struct shash_desc *desc)
-{
-	struct sha1_state *sctx = shash_desc_ctx(desc);
-
-	*sctx = (struct sha1_state){
-		.state = { SHA1_H0, SHA1_H1, SHA1_H2, SHA1_H3, SHA1_H4 },
-	};
-	return 0;
-}
+asmlinkage void sha1_ce_transform(int blocks, u8 const *src, u32 *state,
+				  const u8 *head, void *p);
 
-static int sha1_update(struct shash_desc *desc, const u8 *data,
-		       unsigned int len)
+static int sha1_ce_update(struct shash_desc *desc, const u8 *data,
+			  unsigned int len)
 {
 	struct sha1_state *sctx = shash_desc_ctx(desc);
-	unsigned int partial;
 
-	if (!may_use_simd())
+	if (!may_use_simd() ||
+	    (sctx->count % SHA1_BLOCK_SIZE) + len < SHA1_BLOCK_SIZE)
 		return sha1_update_arm(desc, data, len);
 
-	partial = sctx->count % SHA1_BLOCK_SIZE;
-	sctx->count += len;
+	kernel_neon_begin();
+	crypto_sha1_base_do_update(desc, data, len, sha1_ce_transform, NULL);
+	kernel_neon_end();
 
-	if ((partial + len) >= SHA1_BLOCK_SIZE) {
-		int blocks;
-
-		if (partial) {
-			int p = SHA1_BLOCK_SIZE - partial;
-
-			memcpy(sctx->buffer + partial, data, p);
-			data += p;
-			len -= p;
-		}
-
-		blocks = len / SHA1_BLOCK_SIZE;
-		len %= SHA1_BLOCK_SIZE;
-
-		kernel_neon_begin();
-		sha1_ce_transform(blocks, data, sctx->state,
-				  partial ? sctx->buffer : NULL);
-		kernel_neon_end();
-
-		data += blocks * SHA1_BLOCK_SIZE;
-		partial = 0;
-	}
-	if (len)
-		memcpy(sctx->buffer + partial, data, len);
 	return 0;
 }
 
-static int sha1_final(struct shash_desc *desc, u8 *out)
+static int sha1_ce_finup(struct shash_desc *desc, const u8 *data,
+			 unsigned int len, u8 *out)
 {
-	static const u8 padding[SHA1_BLOCK_SIZE] = { 0x80, };
-
-	struct sha1_state *sctx = shash_desc_ctx(desc);
-	__be64 bits = cpu_to_be64(sctx->count << 3);
-	__be32 *dst = (__be32 *)out;
-	int i;
-
-	u32 padlen = SHA1_BLOCK_SIZE
-		     - ((sctx->count + sizeof(bits)) % SHA1_BLOCK_SIZE);
-
-	sha1_update(desc, padding, padlen);
-	sha1_update(desc, (const u8 *)&bits, sizeof(bits));
-
-	for (i = 0; i < SHA1_DIGEST_SIZE / sizeof(__be32); i++)
-		put_unaligned_be32(sctx->state[i], dst++);
-
-	*sctx = (struct sha1_state){};
-	return 0;
-}
+	if (!may_use_simd())
+		return sha1_finup_arm(desc, data, len, out);
 
-static int sha1_export(struct shash_desc *desc, void *out)
-{
-	struct sha1_state *sctx = shash_desc_ctx(desc);
-	struct sha1_state *dst = out;
+	kernel_neon_begin();
+	if (len)
+		crypto_sha1_base_do_update(desc, data, len,
+					   sha1_ce_transform, NULL);
+	crypto_sha1_base_do_finalize(desc, sha1_ce_transform, NULL);
+	kernel_neon_end();
 
-	*dst = *sctx;
-	return 0;
+	return crypto_sha1_base_finish(desc, out);
 }
 
-static int sha1_import(struct shash_desc *desc, const void *in)
+static int sha1_ce_final(struct shash_desc *desc, u8 *out)
 {
-	struct sha1_state *sctx = shash_desc_ctx(desc);
-	struct sha1_state const *src = in;
-
-	*sctx = *src;
-	return 0;
+	return sha1_ce_finup(desc, NULL, 0l, out);
 }
 
 static struct shash_alg alg = {
-	.init			= sha1_init,
-	.update			= sha1_update,
-	.final			= sha1_final,
-	.export			= sha1_export,
-	.import			= sha1_import,
+	.init			= crypto_sha1_base_init,
+	.update			= sha1_ce_update,
+	.final			= sha1_ce_final,
+	.finup			= sha1_ce_finup,
+	.export			= crypto_sha1_base_export,
+	.import			= crypto_sha1_base_import,
 	.descsize		= sizeof(struct sha1_state),
 	.digestsize		= SHA1_DIGEST_SIZE,
 	.statesize		= sizeof(struct sha1_state),
-- 
1.8.3.2
