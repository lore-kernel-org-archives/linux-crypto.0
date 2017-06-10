From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 12/12] crypto: arm64/aes-bs - implement non-SIMD fallback for AES-CTR
Date: Sat, 10 Jun 2017 16:22:58 +0000
Message-ID: <1497111778-4210-13-git-send-email-ard.biesheuvel@linaro.org>
References: <1497111778-4210-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
        will.deacon@arm.com, dave.martin@arm.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f172.google.com ([209.85.128.172]:34181 "EHLO
        mail-wr0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752205AbdFJQXg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 10 Jun 2017 12:23:36 -0400
Received: by mail-wr0-f172.google.com with SMTP id g76so58544284wrd.1
        for <linux-crypto@vger.kernel.org>; Sat, 10 Jun 2017 09:23:35 -0700 (PDT)
In-Reply-To: <1497111778-4210-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Of the various chaining modes implemented by the bit sliced AES driver,
only CTR is exposed as a synchronous cipher, and requires a fallback in
order to remain usable once we update the kernel mode NEON handling logic
to disallow nested use. So wire up the existing CTR fallback C code.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/aes-neonbs-glue.c | 48 ++++++++++++++++++--
 1 file changed, 43 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/crypto/aes-neonbs-glue.c b/arch/arm64/crypto/aes-neonbs-glue.c
index db2501d93550..5fe442c26ff1 100644
--- a/arch/arm64/crypto/aes-neonbs-glue.c
+++ b/arch/arm64/crypto/aes-neonbs-glue.c
@@ -1,7 +1,7 @@
 /*
  * Bit sliced AES using NEON instructions
  *
- * Copyright (C) 2016 Linaro Ltd <ard.biesheuvel@linaro.org>
+ * Copyright (C) 2016 - 2017 Linaro Ltd <ard.biesheuvel@linaro.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -9,12 +9,15 @@
  */
 
 #include <asm/neon.h>
+#include <asm/simd.h>
 #include <crypto/aes.h>
 #include <crypto/internal/simd.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/xts.h>
 #include <linux/module.h>
 
+#include "aes-ctr-fallback.h"
+
 MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
 MODULE_LICENSE("GPL v2");
 
@@ -58,6 +61,11 @@ struct aesbs_cbc_ctx {
 	u32			enc[AES_MAX_KEYLENGTH_U32];
 };
 
+struct aesbs_ctr_ctx {
+	struct aesbs_ctx	key;		/* must be first member */
+	struct crypto_aes_ctx	fallback;
+};
+
 struct aesbs_xts_ctx {
 	struct aesbs_ctx	key;
 	u32			twkey[AES_MAX_KEYLENGTH_U32];
@@ -196,6 +204,25 @@ static int cbc_decrypt(struct skcipher_request *req)
 	return err;
 }
 
+static int aesbs_ctr_setkey_sync(struct crypto_skcipher *tfm, const u8 *in_key,
+				 unsigned int key_len)
+{
+	struct aesbs_ctr_ctx *ctx = crypto_skcipher_ctx(tfm);
+	int err;
+
+	err = crypto_aes_expand_key(&ctx->fallback, in_key, key_len);
+	if (err)
+		return err;
+
+	ctx->key.rounds = 6 + key_len / 4;
+
+	kernel_neon_begin();
+	aesbs_convert_key(ctx->key.rk, ctx->fallback.key_enc, ctx->key.rounds);
+	kernel_neon_end();
+
+	return 0;
+}
+
 static int ctr_encrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
@@ -260,6 +287,17 @@ static int aesbs_xts_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
 	return aesbs_setkey(tfm, in_key, key_len);
 }
 
+static int ctr_encrypt_sync(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct aesbs_ctr_ctx *ctx = crypto_skcipher_ctx(tfm);
+
+	if (!may_use_simd())
+		return aes_ctr_encrypt_fallback(&ctx->fallback, req);
+
+	return ctr_encrypt(req);
+}
+
 static int __xts_crypt(struct skcipher_request *req,
 		       void (*fn)(u8 out[], u8 const in[], u8 const rk[],
 				  int rounds, int blocks, u8 iv[]))
@@ -356,7 +394,7 @@ static struct skcipher_alg aes_algs[] = { {
 	.base.cra_driver_name	= "ctr-aes-neonbs",
 	.base.cra_priority	= 250 - 1,
 	.base.cra_blocksize	= 1,
-	.base.cra_ctxsize	= sizeof(struct aesbs_ctx),
+	.base.cra_ctxsize	= sizeof(struct aesbs_ctr_ctx),
 	.base.cra_module	= THIS_MODULE,
 
 	.min_keysize		= AES_MIN_KEY_SIZE,
@@ -364,9 +402,9 @@ static struct skcipher_alg aes_algs[] = { {
 	.chunksize		= AES_BLOCK_SIZE,
 	.walksize		= 8 * AES_BLOCK_SIZE,
 	.ivsize			= AES_BLOCK_SIZE,
-	.setkey			= aesbs_setkey,
-	.encrypt		= ctr_encrypt,
-	.decrypt		= ctr_encrypt,
+	.setkey			= aesbs_ctr_setkey_sync,
+	.encrypt		= ctr_encrypt_sync,
+	.decrypt		= ctr_encrypt_sync,
 }, {
 	.base.cra_name		= "__xts(aes)",
 	.base.cra_driver_name	= "__xts-aes-neonbs",
-- 
2.7.4
