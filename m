From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 09/12] crypto: arm64/aes-ce-ccm: add non-SIMD generic fallback
Date: Sat, 10 Jun 2017 16:22:55 +0000
Message-ID: <1497111778-4210-10-git-send-email-ard.biesheuvel@linaro.org>
References: <1497111778-4210-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
        will.deacon@arm.com, dave.martin@arm.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f177.google.com ([209.85.128.177]:36076 "EHLO
        mail-wr0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752199AbdFJQX1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 10 Jun 2017 12:23:27 -0400
Received: by mail-wr0-f177.google.com with SMTP id v111so58818147wrc.3
        for <linux-crypto@vger.kernel.org>; Sat, 10 Jun 2017 09:23:26 -0700 (PDT)
In-Reply-To: <1497111778-4210-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The arm64 kernel will shortly disallow nested kernel mode NEON.

So honour this in the ARMv8 Crypto Extensions implementation of CCM-AES,
and fall back to a dynamically instantiated ccm(aes) implementation if
necessary (which will in all likelihood be produced by the generic CCM,
CTR and AES drivers). Due to the fact that this may break the boottime
algo tests, this driver can now only be built as a module.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/Kconfig           |   3 +-
 arch/arm64/crypto/aes-ce-ccm-glue.c | 152 +++++++++++++++-----
 2 files changed, 116 insertions(+), 39 deletions(-)

diff --git a/arch/arm64/crypto/Kconfig b/arch/arm64/crypto/Kconfig
index 772801f263d9..c3b74db72cc8 100644
--- a/arch/arm64/crypto/Kconfig
+++ b/arch/arm64/crypto/Kconfig
@@ -56,10 +56,11 @@ config CRYPTO_AES_ARM64_CE
 
 config CRYPTO_AES_ARM64_CE_CCM
 	tristate "AES in CCM mode using ARMv8 Crypto Extensions"
-	depends on ARM64 && KERNEL_MODE_NEON
+	depends on KERNEL_MODE_NEON && m
 	select CRYPTO_ALGAPI
 	select CRYPTO_AES_ARM64_CE
 	select CRYPTO_AEAD
+	select CRYPTO_CCM
 
 config CRYPTO_AES_ARM64_CE_BLK
 	tristate "AES in ECB/CBC/CTR/XTS modes using ARMv8 Crypto Extensions"
diff --git a/arch/arm64/crypto/aes-ce-ccm-glue.c b/arch/arm64/crypto/aes-ce-ccm-glue.c
index 6a7dbc7c83a6..c5ae50141988 100644
--- a/arch/arm64/crypto/aes-ce-ccm-glue.c
+++ b/arch/arm64/crypto/aes-ce-ccm-glue.c
@@ -1,7 +1,7 @@
 /*
  * aes-ccm-glue.c - AES-CCM transform for ARMv8 with Crypto Extensions
  *
- * Copyright (C) 2013 - 2014 Linaro Ltd <ard.biesheuvel@linaro.org>
+ * Copyright (C) 2013 - 2017 Linaro Ltd <ard.biesheuvel@linaro.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -9,6 +9,7 @@
  */
 
 #include <asm/neon.h>
+#include <asm/simd.h>
 #include <asm/unaligned.h>
 #include <crypto/aes.h>
 #include <crypto/scatterwalk.h>
@@ -18,6 +19,11 @@
 
 #include "aes-ce-setkey.h"
 
+struct crypto_aes_ccm_ctx {
+	struct crypto_aes_ctx	key;
+	struct crypto_aead	*fallback;
+};
+
 static int num_rounds(struct crypto_aes_ctx *ctx)
 {
 	/*
@@ -47,22 +53,33 @@ asmlinkage void ce_aes_ccm_final(u8 mac[], u8 const ctr[], u32 const rk[],
 static int ccm_setkey(struct crypto_aead *tfm, const u8 *in_key,
 		      unsigned int key_len)
 {
-	struct crypto_aes_ctx *ctx = crypto_aead_ctx(tfm);
+	struct crypto_aes_ccm_ctx *ctx = crypto_aead_ctx(tfm);
 	int ret;
 
-	ret = ce_aes_expandkey(ctx, in_key, key_len);
-	if (!ret)
-		return 0;
+	ret = ce_aes_expandkey(&ctx->key, in_key, key_len);
+	if (ret) {
+		tfm->base.crt_flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
+		return ret;
+	}
+
+	ret = crypto_aead_setkey(ctx->fallback, in_key, key_len);
+	if (ret) {
+		if (ctx->fallback->base.crt_flags & CRYPTO_TFM_RES_BAD_KEY_LEN)
+			tfm->base.crt_flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
+		return ret;
+	}
 
-	tfm->base.crt_flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
-	return -EINVAL;
+	return 0;
 }
 
 static int ccm_setauthsize(struct crypto_aead *tfm, unsigned int authsize)
 {
+	struct crypto_aes_ccm_ctx *ctx = crypto_aead_ctx(tfm);
+
 	if ((authsize & 1) || authsize < 4)
 		return -EINVAL;
-	return 0;
+
+	return crypto_aead_setauthsize(ctx->fallback, authsize);
 }
 
 static int ccm_init_mac(struct aead_request *req, u8 maciv[], u32 msglen)
@@ -106,7 +123,7 @@ static int ccm_init_mac(struct aead_request *req, u8 maciv[], u32 msglen)
 static void ccm_calculate_auth_mac(struct aead_request *req, u8 mac[])
 {
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
-	struct crypto_aes_ctx *ctx = crypto_aead_ctx(aead);
+	struct crypto_aes_ccm_ctx *ctx = crypto_aead_ctx(aead);
 	struct __packed { __be16 l; __be32 h; u16 len; } ltag;
 	struct scatter_walk walk;
 	u32 len = req->assoclen;
@@ -122,8 +139,8 @@ static void ccm_calculate_auth_mac(struct aead_request *req, u8 mac[])
 		ltag.len = 6;
 	}
 
-	ce_aes_ccm_auth_data(mac, (u8 *)&ltag, ltag.len, &macp, ctx->key_enc,
-			     num_rounds(ctx));
+	ce_aes_ccm_auth_data(mac, (u8 *)&ltag, ltag.len, &macp,
+			     ctx->key.key_enc, num_rounds(&ctx->key));
 	scatterwalk_start(&walk, req->src);
 
 	do {
@@ -135,8 +152,8 @@ static void ccm_calculate_auth_mac(struct aead_request *req, u8 mac[])
 			n = scatterwalk_clamp(&walk, len);
 		}
 		p = scatterwalk_map(&walk);
-		ce_aes_ccm_auth_data(mac, p, n, &macp, ctx->key_enc,
-				     num_rounds(ctx));
+		ce_aes_ccm_auth_data(mac, p, n, &macp, ctx->key.key_enc,
+				     num_rounds(&ctx->key));
 		len -= n;
 
 		scatterwalk_unmap(p);
@@ -148,18 +165,34 @@ static void ccm_calculate_auth_mac(struct aead_request *req, u8 mac[])
 static int ccm_encrypt(struct aead_request *req)
 {
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
-	struct crypto_aes_ctx *ctx = crypto_aead_ctx(aead);
+	struct crypto_aes_ccm_ctx *ctx = crypto_aead_ctx(aead);
 	struct skcipher_walk walk;
 	u8 __aligned(8) mac[AES_BLOCK_SIZE];
 	u8 buf[AES_BLOCK_SIZE];
 	u32 len = req->cryptlen;
 	int err;
 
+	if (!may_use_simd()) {
+		struct aead_request *fallback_req;
+
+		fallback_req = aead_request_alloc(ctx->fallback, GFP_ATOMIC);
+		if (!fallback_req)
+			return -ENOMEM;
+
+		aead_request_set_ad(fallback_req, req->assoclen);
+		aead_request_set_crypt(fallback_req, req->src, req->dst,
+				       req->cryptlen, req->iv);
+
+		err = crypto_aead_encrypt(fallback_req);
+		aead_request_free(fallback_req);
+		return err;
+	}
+
 	err = ccm_init_mac(req, mac, len);
 	if (err)
 		return err;
 
-	kernel_neon_begin_partial(6);
+	kernel_neon_begin();
 
 	if (req->assoclen)
 		ccm_calculate_auth_mac(req, mac);
@@ -176,13 +209,14 @@ static int ccm_encrypt(struct aead_request *req)
 			tail = 0;
 
 		ce_aes_ccm_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
-				   walk.nbytes - tail, ctx->key_enc,
-				   num_rounds(ctx), mac, walk.iv);
+				   walk.nbytes - tail, ctx->key.key_enc,
+				   num_rounds(&ctx->key), mac, walk.iv);
 
 		err = skcipher_walk_done(&walk, tail);
 	}
 	if (!err)
-		ce_aes_ccm_final(mac, buf, ctx->key_enc, num_rounds(ctx));
+		ce_aes_ccm_final(mac, buf, ctx->key.key_enc,
+				 num_rounds(&ctx->key));
 
 	kernel_neon_end();
 
@@ -199,7 +233,7 @@ static int ccm_encrypt(struct aead_request *req)
 static int ccm_decrypt(struct aead_request *req)
 {
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
-	struct crypto_aes_ctx *ctx = crypto_aead_ctx(aead);
+	struct crypto_aes_ccm_ctx *ctx = crypto_aead_ctx(aead);
 	unsigned int authsize = crypto_aead_authsize(aead);
 	struct skcipher_walk walk;
 	u8 __aligned(8) mac[AES_BLOCK_SIZE];
@@ -207,11 +241,27 @@ static int ccm_decrypt(struct aead_request *req)
 	u32 len = req->cryptlen - authsize;
 	int err;
 
+	if (!may_use_simd()) {
+		struct aead_request *fallback_req;
+
+		fallback_req = aead_request_alloc(ctx->fallback, GFP_ATOMIC);
+		if (!fallback_req)
+			return -ENOMEM;
+
+		aead_request_set_ad(fallback_req, req->assoclen);
+		aead_request_set_crypt(fallback_req, req->src, req->dst,
+				       req->cryptlen, req->iv);
+
+		err = crypto_aead_decrypt(fallback_req);
+		aead_request_free(fallback_req);
+		return err;
+	}
+
 	err = ccm_init_mac(req, mac, len);
 	if (err)
 		return err;
 
-	kernel_neon_begin_partial(6);
+	kernel_neon_begin();
 
 	if (req->assoclen)
 		ccm_calculate_auth_mac(req, mac);
@@ -228,13 +278,14 @@ static int ccm_decrypt(struct aead_request *req)
 			tail = 0;
 
 		ce_aes_ccm_decrypt(walk.dst.virt.addr, walk.src.virt.addr,
-				   walk.nbytes - tail, ctx->key_enc,
-				   num_rounds(ctx), mac, walk.iv);
+				   walk.nbytes - tail, ctx->key.key_enc,
+				   num_rounds(&ctx->key), mac, walk.iv);
 
 		err = skcipher_walk_done(&walk, tail);
 	}
 	if (!err)
-		ce_aes_ccm_final(mac, buf, ctx->key_enc, num_rounds(ctx));
+		ce_aes_ccm_final(mac, buf, ctx->key.key_enc,
+				 num_rounds(&ctx->key));
 
 	kernel_neon_end();
 
@@ -251,28 +302,53 @@ static int ccm_decrypt(struct aead_request *req)
 	return 0;
 }
 
+static int ccm_init(struct crypto_aead *aead)
+{
+	struct crypto_aes_ccm_ctx *ctx = crypto_aead_ctx(aead);
+	struct crypto_aead *tfm;
+
+	tfm = crypto_alloc_aead("ccm(aes)", 0,
+				CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK);
+
+	if (IS_ERR(tfm))
+		return PTR_ERR(tfm);
+
+	ctx->fallback = tfm;
+	return 0;
+}
+
+static void ccm_exit(struct crypto_aead *aead)
+{
+	struct crypto_aes_ccm_ctx *ctx = crypto_aead_ctx(aead);
+
+	crypto_free_aead(ctx->fallback);
+}
+
 static struct aead_alg ccm_aes_alg = {
-	.base = {
-		.cra_name		= "ccm(aes)",
-		.cra_driver_name	= "ccm-aes-ce",
-		.cra_priority		= 300,
-		.cra_blocksize		= 1,
-		.cra_ctxsize		= sizeof(struct crypto_aes_ctx),
-		.cra_module		= THIS_MODULE,
-	},
-	.ivsize		= AES_BLOCK_SIZE,
-	.chunksize	= AES_BLOCK_SIZE,
-	.maxauthsize	= AES_BLOCK_SIZE,
-	.setkey		= ccm_setkey,
-	.setauthsize	= ccm_setauthsize,
-	.encrypt	= ccm_encrypt,
-	.decrypt	= ccm_decrypt,
+	.base.cra_name		= "ccm(aes)",
+	.base.cra_driver_name	= "ccm-aes-ce",
+	.base.cra_priority	= 300,
+	.base.cra_blocksize	= 1,
+	.base.cra_ctxsize	= sizeof(struct crypto_aes_ccm_ctx),
+	.base.cra_module	= THIS_MODULE,
+	.base.cra_flags		= CRYPTO_ALG_NEED_FALLBACK,
+
+	.ivsize			= AES_BLOCK_SIZE,
+	.chunksize		= AES_BLOCK_SIZE,
+	.maxauthsize		= AES_BLOCK_SIZE,
+	.setkey			= ccm_setkey,
+	.setauthsize		= ccm_setauthsize,
+	.encrypt		= ccm_encrypt,
+	.decrypt		= ccm_decrypt,
+	.init			= ccm_init,
+	.exit			= ccm_exit,
 };
 
 static int __init aes_mod_init(void)
 {
 	if (!(elf_hwcap & HWCAP_AES))
 		return -ENODEV;
+
 	return crypto_register_aead(&ccm_aes_alg);
 }
 
-- 
2.7.4
