From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 10/12] crypto: arm64/aes-blk - add a non-SIMD fallback for synchronous CTR
Date: Sat, 10 Jun 2017 16:22:56 +0000
Message-ID: <1497111778-4210-11-git-send-email-ard.biesheuvel@linaro.org>
References: <1497111778-4210-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
        will.deacon@arm.com, dave.martin@arm.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f182.google.com ([209.85.128.182]:34150 "EHLO
        mail-wr0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752203AbdFJQXa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 10 Jun 2017 12:23:30 -0400
Received: by mail-wr0-f182.google.com with SMTP id g76so58543110wrd.1
        for <linux-crypto@vger.kernel.org>; Sat, 10 Jun 2017 09:23:29 -0700 (PDT)
In-Reply-To: <1497111778-4210-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

To accommodate systems that may disallow use of the NEON in kernel mode
in some circumstances, introduce a C fallback for synchronous AES in CTR
mode, and use it if may_use_simd() returns false.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/Kconfig            |  7 ++-
 arch/arm64/crypto/aes-ctr-fallback.h | 55 ++++++++++++++++++++
 arch/arm64/crypto/aes-glue.c         | 17 +++++-
 3 files changed, 75 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/crypto/Kconfig b/arch/arm64/crypto/Kconfig
index c3b74db72cc8..6bd1921d8ca2 100644
--- a/arch/arm64/crypto/Kconfig
+++ b/arch/arm64/crypto/Kconfig
@@ -64,17 +64,20 @@ config CRYPTO_AES_ARM64_CE_CCM
 
 config CRYPTO_AES_ARM64_CE_BLK
 	tristate "AES in ECB/CBC/CTR/XTS modes using ARMv8 Crypto Extensions"
-	depends on ARM64 && KERNEL_MODE_NEON
+	depends on KERNEL_MODE_NEON
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_AES_ARM64_CE
+	select CRYPTO_AES
 	select CRYPTO_SIMD
+	select CRYPTO_AES_ARM64
 
 config CRYPTO_AES_ARM64_NEON_BLK
 	tristate "AES in ECB/CBC/CTR/XTS modes using NEON instructions"
-	depends on ARM64 && KERNEL_MODE_NEON
+	depends on KERNEL_MODE_NEON
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_AES
 	select CRYPTO_SIMD
+	select CRYPTO_AES_ARM64
 
 config CRYPTO_CHACHA20_NEON
 	tristate "NEON accelerated ChaCha20 symmetric cipher"
diff --git a/arch/arm64/crypto/aes-ctr-fallback.h b/arch/arm64/crypto/aes-ctr-fallback.h
new file mode 100644
index 000000000000..4a6bfac6ecb5
--- /dev/null
+++ b/arch/arm64/crypto/aes-ctr-fallback.h
@@ -0,0 +1,55 @@
+/*
+ * Fallback for sync aes(ctr) in contexts where kernel mode NEON
+ * is not allowed
+ *
+ * Copyright (C) 2017 Linaro Ltd <ard.biesheuvel@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <crypto/aes.h>
+#include <crypto/internal/skcipher.h>
+
+asmlinkage void __aes_arm64_encrypt(u32 *rk, u8 *out, const u8 *in, int rounds);
+
+static inline int aes_ctr_encrypt_fallback(struct crypto_aes_ctx *ctx,
+					   struct skcipher_request *req)
+{
+	struct skcipher_walk walk;
+	u8 buf[AES_BLOCK_SIZE];
+	int err;
+
+	err = skcipher_walk_virt(&walk, req, true);
+
+	while (walk.nbytes > 0) {
+		u8 *dst = walk.dst.virt.addr;
+		u8 *src = walk.src.virt.addr;
+		int nbytes = walk.nbytes;
+		int tail = 0;
+
+		if (nbytes < walk.total) {
+			nbytes = round_down(nbytes, AES_BLOCK_SIZE);
+			tail = walk.nbytes % AES_BLOCK_SIZE;
+		}
+
+		do {
+			int bsize = min(nbytes, AES_BLOCK_SIZE);
+
+			__aes_arm64_encrypt(ctx->key_enc, buf, walk.iv,
+					    ctx->key_length / 4 + 6);
+			if (dst != src)
+				memcpy(dst, src, bsize);
+			crypto_xor(dst, buf, bsize);
+			crypto_inc(walk.iv, AES_BLOCK_SIZE);
+
+			dst += AES_BLOCK_SIZE;
+			src += AES_BLOCK_SIZE;
+			nbytes -= AES_BLOCK_SIZE;
+		} while (nbytes > 0);
+
+		err = skcipher_walk_done(&walk, tail);
+	}
+	return err;
+}
diff --git a/arch/arm64/crypto/aes-glue.c b/arch/arm64/crypto/aes-glue.c
index bcf596b0197e..6806ad7d8dd4 100644
--- a/arch/arm64/crypto/aes-glue.c
+++ b/arch/arm64/crypto/aes-glue.c
@@ -10,6 +10,7 @@
 
 #include <asm/neon.h>
 #include <asm/hwcap.h>
+#include <asm/simd.h>
 #include <crypto/aes.h>
 #include <crypto/internal/hash.h>
 #include <crypto/internal/simd.h>
@@ -19,6 +20,7 @@
 #include <crypto/xts.h>
 
 #include "aes-ce-setkey.h"
+#include "aes-ctr-fallback.h"
 
 #ifdef USE_V8_CRYPTO_EXTENSIONS
 #define MODE			"ce"
@@ -251,6 +253,17 @@ static int ctr_encrypt(struct skcipher_request *req)
 	return err;
 }
 
+static int ctr_encrypt_sync(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct crypto_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
+
+	if (!may_use_simd())
+		return aes_ctr_encrypt_fallback(ctx, req);
+
+	return ctr_encrypt(req);
+}
+
 static int xts_encrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
@@ -357,8 +370,8 @@ static struct skcipher_alg aes_algs[] = { {
 	.ivsize		= AES_BLOCK_SIZE,
 	.chunksize	= AES_BLOCK_SIZE,
 	.setkey		= skcipher_aes_setkey,
-	.encrypt	= ctr_encrypt,
-	.decrypt	= ctr_encrypt,
+	.encrypt	= ctr_encrypt_sync,
+	.decrypt	= ctr_encrypt_sync,
 }, {
 	.base = {
 		.cra_name		= "__xts(aes)",
-- 
2.7.4
