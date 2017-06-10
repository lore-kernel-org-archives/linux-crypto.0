From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 06/12] crypto: arm64/sha2-ce - add non-SIMD scalar fallback
Date: Sat, 10 Jun 2017 16:22:52 +0000
Message-ID: <1497111778-4210-7-git-send-email-ard.biesheuvel@linaro.org>
References: <1497111778-4210-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
        will.deacon@arm.com, dave.martin@arm.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f176.google.com ([209.85.128.176]:34845 "EHLO
        mail-wr0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752144AbdFJQXT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 10 Jun 2017 12:23:19 -0400
Received: by mail-wr0-f176.google.com with SMTP id q97so58890844wrb.2
        for <linux-crypto@vger.kernel.org>; Sat, 10 Jun 2017 09:23:19 -0700 (PDT)
In-Reply-To: <1497111778-4210-1-git-send-email-ard.biesheuvel@linaro.org>
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
index 7cd587564a41..eb71543568b6 100644
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
@@ -32,13 +33,19 @@ struct sha256_ce_state {
 asmlinkage void sha2_ce_transform(struct sha256_ce_state *sst, u8 const *src,
 				  int blocks);
 
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
@@ -57,13 +64,22 @@ static int sha256_ce_finup(struct shash_desc *desc, const u8 *data,
 	ASM_EXPORT(sha256_ce_offsetof_finalize,
 		   offsetof(struct sha256_ce_state, finalize));
 
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
@@ -77,8 +93,14 @@ static int sha256_ce_final(struct shash_desc *desc, u8 *out)
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
2.7.4
