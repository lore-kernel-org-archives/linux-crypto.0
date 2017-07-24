From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH resend 07/18] crypto: arm64/sha2-ce - add non-SIMD scalar fallback
Date: Mon, 24 Jul 2017 11:28:09 +0100
Message-ID: <20170724102820.16534-8-ard.biesheuvel@linaro.org>
References: <20170724102820.16534-1-ard.biesheuvel@linaro.org>
Cc: herbert@gondor.apana.org.au, dave.martin@arm.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f181.google.com ([209.85.128.181]:36452 "EHLO
        mail-wr0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751766AbdGXK2o (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Jul 2017 06:28:44 -0400
Received: by mail-wr0-f181.google.com with SMTP id y43so104224371wrd.3
        for <linux-crypto@vger.kernel.org>; Mon, 24 Jul 2017 03:28:43 -0700 (PDT)
In-Reply-To: <20170724102820.16534-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The arm64 kernel will shortly disallow nested kernel mode NEON, so
add a fallback to scalar code that can be invoked in that case.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/Kconfig        |  3 +-
 arch/arm64/crypto/sha2-ce-glue.c | 30 +++++++++++++++++---
 arch/arm64/crypto/sha256-glue.c  |  1 +
 3 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/crypto/Kconfig b/arch/arm64/crypto/Kconfig
index 5d5953545dad..8cd145f9c1ff 100644
--- a/arch/arm64/crypto/Kconfig
+++ b/arch/arm64/crypto/Kconfig
@@ -24,8 +24,9 @@ config CRYPTO_SHA1_ARM64_CE
 
 config CRYPTO_SHA2_ARM64_CE
 	tristate "SHA-224/SHA-256 digest algorithm (ARMv8 Crypto Extensions)"
-	depends on ARM64 && KERNEL_MODE_NEON
+	depends on KERNEL_MODE_NEON
 	select CRYPTO_HASH
+	select CRYPTO_SHA256_ARM64
 
 config CRYPTO_GHASH_ARM64_CE
 	tristate "GHASH (for GCM chaining mode) using ARMv8 Crypto Extensions"
diff --git a/arch/arm64/crypto/sha2-ce-glue.c b/arch/arm64/crypto/sha2-ce-glue.c
index 0ed9486f75dd..fd1ff2b13dfa 100644
--- a/arch/arm64/crypto/sha2-ce-glue.c
+++ b/arch/arm64/crypto/sha2-ce-glue.c
@@ -1,7 +1,7 @@
 /*
  * sha2-ce-glue.c - SHA-224/SHA-256 using ARMv8 Crypto Extensions
  *
- * Copyright (C) 2014 Linaro Ltd <ard.biesheuvel@linaro.org>
+ * Copyright (C) 2014 - 2017 Linaro Ltd <ard.biesheuvel@linaro.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -9,6 +9,7 @@
  */
 
 #include <asm/neon.h>
+#include <asm/simd.h>
 #include <asm/unaligned.h>
 #include <crypto/internal/hash.h>
 #include <crypto/sha.h>
@@ -34,13 +35,19 @@ const u32 sha256_ce_offsetof_count = offsetof(struct sha256_ce_state,
 const u32 sha256_ce_offsetof_finalize = offsetof(struct sha256_ce_state,
 						 finalize);
 
+asmlinkage void sha256_block_data_order(u32 *digest, u8 const *src, int blocks);
+
 static int sha256_ce_update(struct shash_desc *desc, const u8 *data,
 			    unsigned int len)
 {
 	struct sha256_ce_state *sctx = shash_desc_ctx(desc);
 
+	if (!may_use_simd())
+		return sha256_base_do_update(desc, data, len,
+				(sha256_block_fn *)sha256_block_data_order);
+
 	sctx->finalize = 0;
-	kernel_neon_begin_partial(28);
+	kernel_neon_begin();
 	sha256_base_do_update(desc, data, len,
 			      (sha256_block_fn *)sha2_ce_transform);
 	kernel_neon_end();
@@ -54,13 +61,22 @@ static int sha256_ce_finup(struct shash_desc *desc, const u8 *data,
 	struct sha256_ce_state *sctx = shash_desc_ctx(desc);
 	bool finalize = !sctx->sst.count && !(len % SHA256_BLOCK_SIZE);
 
+	if (!may_use_simd()) {
+		if (len)
+			sha256_base_do_update(desc, data, len,
+				(sha256_block_fn *)sha256_block_data_order);
+		sha256_base_do_finalize(desc,
+				(sha256_block_fn *)sha256_block_data_order);
+		return sha256_base_finish(desc, out);
+	}
+
 	/*
 	 * Allow the asm code to perform the finalization if there is no
 	 * partial data and the input is a round multiple of the block size.
 	 */
 	sctx->finalize = finalize;
 
-	kernel_neon_begin_partial(28);
+	kernel_neon_begin();
 	sha256_base_do_update(desc, data, len,
 			      (sha256_block_fn *)sha2_ce_transform);
 	if (!finalize)
@@ -74,8 +90,14 @@ static int sha256_ce_final(struct shash_desc *desc, u8 *out)
 {
 	struct sha256_ce_state *sctx = shash_desc_ctx(desc);
 
+	if (!may_use_simd()) {
+		sha256_base_do_finalize(desc,
+				(sha256_block_fn *)sha256_block_data_order);
+		return sha256_base_finish(desc, out);
+	}
+
 	sctx->finalize = 0;
-	kernel_neon_begin_partial(28);
+	kernel_neon_begin();
 	sha256_base_do_finalize(desc, (sha256_block_fn *)sha2_ce_transform);
 	kernel_neon_end();
 	return sha256_base_finish(desc, out);
diff --git a/arch/arm64/crypto/sha256-glue.c b/arch/arm64/crypto/sha256-glue.c
index a2226f841960..b064d925fe2a 100644
--- a/arch/arm64/crypto/sha256-glue.c
+++ b/arch/arm64/crypto/sha256-glue.c
@@ -29,6 +29,7 @@ MODULE_ALIAS_CRYPTO("sha256");
 
 asmlinkage void sha256_block_data_order(u32 *digest, const void *data,
 					unsigned int num_blks);
+EXPORT_SYMBOL(sha256_block_data_order);
 
 asmlinkage void sha256_block_neon(u32 *digest, const void *data,
 				  unsigned int num_blks);
-- 
2.9.3
