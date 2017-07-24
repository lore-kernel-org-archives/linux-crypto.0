From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH resend 06/18] crypto: arm64/sha1-ce - add non-SIMD generic fallback
Date: Mon, 24 Jul 2017 11:28:08 +0100
Message-ID: <20170724102820.16534-7-ard.biesheuvel@linaro.org>
References: <20170724102820.16534-1-ard.biesheuvel@linaro.org>
Cc: herbert@gondor.apana.org.au, dave.martin@arm.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f172.google.com ([209.85.128.172]:36960 "EHLO
        mail-wr0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751559AbdGXK2m (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Jul 2017 06:28:42 -0400
Received: by mail-wr0-f172.google.com with SMTP id 33so47734538wrz.4
        for <linux-crypto@vger.kernel.org>; Mon, 24 Jul 2017 03:28:41 -0700 (PDT)
In-Reply-To: <20170724102820.16534-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The arm64 kernel will shortly disallow nested kernel mode NEON, so
add a fallback to scalar C code that can be invoked in that case.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/Kconfig        |  3 ++-
 arch/arm64/crypto/sha1-ce-glue.c | 18 ++++++++++++++----
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/crypto/Kconfig b/arch/arm64/crypto/Kconfig
index 7d75a363e317..5d5953545dad 100644
--- a/arch/arm64/crypto/Kconfig
+++ b/arch/arm64/crypto/Kconfig
@@ -18,8 +18,9 @@ config CRYPTO_SHA512_ARM64
 
 config CRYPTO_SHA1_ARM64_CE
 	tristate "SHA-1 digest algorithm (ARMv8 Crypto Extensions)"
-	depends on ARM64 && KERNEL_MODE_NEON
+	depends on KERNEL_MODE_NEON
 	select CRYPTO_HASH
+	select CRYPTO_SHA1
 
 config CRYPTO_SHA2_ARM64_CE
 	tristate "SHA-224/SHA-256 digest algorithm (ARMv8 Crypto Extensions)"
diff --git a/arch/arm64/crypto/sha1-ce-glue.c b/arch/arm64/crypto/sha1-ce-glue.c
index ea319c055f5d..efbeb3e0dcfb 100644
--- a/arch/arm64/crypto/sha1-ce-glue.c
+++ b/arch/arm64/crypto/sha1-ce-glue.c
@@ -1,7 +1,7 @@
 /*
  * sha1-ce-glue.c - SHA-1 secure hash using ARMv8 Crypto Extensions
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
@@ -37,8 +38,11 @@ static int sha1_ce_update(struct shash_desc *desc, const u8 *data,
 {
 	struct sha1_ce_state *sctx = shash_desc_ctx(desc);
 
+	if (!may_use_simd())
+		return crypto_sha1_update(desc, data, len);
+
 	sctx->finalize = 0;
-	kernel_neon_begin_partial(16);
+	kernel_neon_begin();
 	sha1_base_do_update(desc, data, len,
 			    (sha1_block_fn *)sha1_ce_transform);
 	kernel_neon_end();
@@ -52,13 +56,16 @@ static int sha1_ce_finup(struct shash_desc *desc, const u8 *data,
 	struct sha1_ce_state *sctx = shash_desc_ctx(desc);
 	bool finalize = !sctx->sst.count && !(len % SHA1_BLOCK_SIZE);
 
+	if (!may_use_simd())
+		return crypto_sha1_finup(desc, data, len, out);
+
 	/*
 	 * Allow the asm code to perform the finalization if there is no
 	 * partial data and the input is a round multiple of the block size.
 	 */
 	sctx->finalize = finalize;
 
-	kernel_neon_begin_partial(16);
+	kernel_neon_begin();
 	sha1_base_do_update(desc, data, len,
 			    (sha1_block_fn *)sha1_ce_transform);
 	if (!finalize)
@@ -71,8 +78,11 @@ static int sha1_ce_final(struct shash_desc *desc, u8 *out)
 {
 	struct sha1_ce_state *sctx = shash_desc_ctx(desc);
 
+	if (!may_use_simd())
+		return crypto_sha1_finup(desc, NULL, 0, out);
+
 	sctx->finalize = 0;
-	kernel_neon_begin_partial(16);
+	kernel_neon_begin();
 	sha1_base_do_finalize(desc, (sha1_block_fn *)sha1_ce_transform);
 	kernel_neon_end();
 	return sha1_base_finish(desc, out);
-- 
2.9.3
