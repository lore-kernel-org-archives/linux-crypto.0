From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 09/16] crypto/arm: move SHA-1 ARMv8 implementation to base layer
Date: Tue,  7 Apr 2015 10:51:57 +0200
Message-ID: <1428396724-19962-10-git-send-email-ard.biesheuvel@linaro.org>
References: <1428396724-19962-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: stockhausen@collogia.de, Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	x86@kernel.org, herbert@gondor.apana.org.au,
	samitolvanen@google.com, jussi.kivilinna@iki.fi
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:36194 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963AbbDGIwq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Apr 2015 04:52:46 -0400
Received: by wizk4 with SMTP id k4so8930947wiz.1
        for <linux-crypto@vger.kernel.org>; Tue, 07 Apr 2015 01:52:44 -0700 (PDT)
In-Reply-To: <1428396724-19962-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/Kconfig        |   1 -
 arch/arm/crypto/sha1-ce-glue.c | 108 +++++++++++------------------------------
 2 files changed, 28 insertions(+), 81 deletions(-)

diff --git a/arch/arm/crypto/Kconfig b/arch/arm/crypto/Kconfig
index 458729d2ce22..5ed98bc6f95d 100644
--- a/arch/arm/crypto/Kconfig
+++ b/arch/arm/crypto/Kconfig
@@ -31,7 +31,6 @@ config CRYPTO_SHA1_ARM_CE
 	tristate "SHA1 digest algorithm (ARM v8 Crypto Extensions)"
 	depends on KERNEL_MODE_NEON
 	select CRYPTO_SHA1_ARM
-	select CRYPTO_SHA1
 	select CRYPTO_HASH
 	help
 	  SHA-1 secure hash standard (FIPS 180-1/DFIPS 180-2) implemented
diff --git a/arch/arm/crypto/sha1-ce-glue.c b/arch/arm/crypto/sha1-ce-glue.c
index e93b24c1af1f..9d0e86e5647b 100644
--- a/arch/arm/crypto/sha1-ce-glue.c
+++ b/arch/arm/crypto/sha1-ce-glue.c
@@ -10,13 +10,13 @@
 
 #include <crypto/internal/hash.h>
 #include <crypto/sha.h>
+#include <crypto/sha1_base.h>
 #include <linux/crypto.h>
 #include <linux/module.h>
 
 #include <asm/hwcap.h>
 #include <asm/neon.h>
 #include <asm/simd.h>
-#include <asm/unaligned.h>
 
 #include "sha1.h"
 
@@ -24,104 +24,52 @@ MODULE_DESCRIPTION("SHA1 secure hash using ARMv8 Crypto Extensions");
 MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
 MODULE_LICENSE("GPL v2");
 
-asmlinkage void sha1_ce_transform(int blocks, u8 const *src, u32 *state, 
-				  u8 *head);
+asmlinkage void sha1_ce_transform(int blocks, u8 const *src, u32 *state,
+				  const u8 *head, void *p);
 
-static int sha1_init(struct shash_desc *desc)
+static int sha1_ce_update(struct shash_desc *desc, const u8 *data,
+			  unsigned int len)
 {
 	struct sha1_state *sctx = shash_desc_ctx(desc);
 
-	*sctx = (struct sha1_state){
-		.state = { SHA1_H0, SHA1_H1, SHA1_H2, SHA1_H3, SHA1_H4 },
-	};
-	return 0;
-}
-
-static int sha1_update(struct shash_desc *desc, const u8 *data,
-		       unsigned int len)
-{
-	struct sha1_state *sctx = shash_desc_ctx(desc);
-	unsigned int partial;
-
-	if (!may_use_simd())
+	if (!may_use_simd() ||
+	    (sctx->count % SHA1_BLOCK_SIZE) + len < SHA1_BLOCK_SIZE)
 		return sha1_update_arm(desc, data, len);
 
-	partial = sctx->count % SHA1_BLOCK_SIZE;
-	sctx->count += len;
-
-	if ((partial + len) >= SHA1_BLOCK_SIZE) {
-		int blocks;
+	kernel_neon_begin();
+	sha1_base_do_update(desc, data, len, sha1_ce_transform, NULL);
+	kernel_neon_end();
 
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
+		sha1_base_do_update(desc, data, len, sha1_ce_transform, NULL);
+	sha1_base_do_finalize(desc, sha1_ce_transform, NULL);
+	kernel_neon_end();
 
-	*dst = *sctx;
-	return 0;
+	return sha1_base_finish(desc, out);
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
+	.init			= sha1_base_init,
+	.update			= sha1_ce_update,
+	.final			= sha1_ce_final,
+	.finup			= sha1_ce_finup,
+	.export			= sha1_base_export,
+	.import			= sha1_base_import,
 	.descsize		= sizeof(struct sha1_state),
 	.digestsize		= SHA1_DIGEST_SIZE,
 	.statesize		= sizeof(struct sha1_state),
-- 
1.8.3.2
