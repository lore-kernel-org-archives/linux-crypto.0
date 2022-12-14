Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17487C001B2
	for <linux-crypto@archiver.kernel.org>; Wed, 14 Dec 2022 17:20:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237767AbiLNRUS (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 14 Dec 2022 12:20:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237749AbiLNRUN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 14 Dec 2022 12:20:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 119C155A0
        for <linux-crypto@vger.kernel.org>; Wed, 14 Dec 2022 09:20:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6549FB819B3
        for <linux-crypto@vger.kernel.org>; Wed, 14 Dec 2022 17:20:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F608C433D2;
        Wed, 14 Dec 2022 17:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671038408;
        bh=sZ0XjL/6Xk+nz47vWtbmP2FyMRxMfVUBigI2jEThmYs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M4d7E3pCg8lmfxJ46Q0/n5fV97+5z3Iu2ukpoPXrsTQOGtc7tZh5xgV5g3+jlgDRW
         S0r1vKNq+ZRzEyjKEuSERTD/i0xr3NnrgKZu//KrAjrRZk47uzQjPn9SfaEIfsdh6H
         kEkOynn1nvPrztzh9UB3N5ZmqJYoHoeMnncOB/XG7BOszcruVCrfnbrJgskMZAy7Wn
         rWsC+LwdnRObHdlq7XQe9PfwCCNvy2bTHJTdpz+Dg5Up8HM4ytH59v732e3eTuN3DI
         Qy5ppO8Ur4Zi1/CCICbsFj31sIoRSybrGMS1Hp6/p/C7UAPHYVrjz+X6WMcDLLvsAS
         uytBIDgHxJz8A==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH v2 2/4] crypto: arm64/gcm - add RFC4106 support
Date:   Wed, 14 Dec 2022 18:19:55 +0100
Message-Id: <20221214171957.2833419-3-ardb@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221214171957.2833419-1-ardb@kernel.org>
References: <20221214171957.2833419-1-ardb@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=8474; i=ardb@kernel.org; h=from:subject; bh=sZ0XjL/6Xk+nz47vWtbmP2FyMRxMfVUBigI2jEThmYs=; b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBjmgW5g5RJzglBiwcCeaA81ZvSkG4oRXUkGfi/cr3r 2bNxZjqJAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCY5oFuQAKCRDDTyI5ktmPJBEeC/ wObffgwpWoLC8cHaxmtWXJZ7S6igC+5tVMsA+RE/ggxb3k396Q5DeQsX+qciDHExfoB2+SLLWsIctl o4DEpxWZvg85DTHWPCRA3ZBXvj639La8WiJJcqjo/okAZO8UN1H1dg3J7z2sa9r2VMMDNm9IcXrOFo bnxco+3akkk4QvbBhCL0LEspu71Le7IAjnnskdbal+Zh5WvPQJE7YD6W/ojb/I7vJm0CCsjJ9/vKTx QNe8M66Bgjo9l72nAry107ABbw/cWyoAbKd5AeC0AIB+doVqJYJ39bLPGsLlMXmYhtVz1yCkMi2cpQ GKvDrTRFdYSlo0WmYCGciU3P5AsE3012UqclaBuzqtKIFK8MZOKWPn+8w53Ekm9WkIaDOEr1iN9W7S 9+/XQafJR5UjhDTFSTVNhtOEp10gIBVB8VisGrgcUSwo6rv4PXNurf5hxjh8wuNMblQzum2HQNVXL1 yslWtGhz0a8JtBaTsGrdwso2HIVf2Z/6e8pXPdIq7/uBM=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add support for RFC4106 ESP encapsulation to the accelerated GCM
implementation. This results in a ~10% speedup for IPsec frames of
typical size (~1420 bytes) on Cortex-A53.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/ghash-ce-glue.c | 145 +++++++++++++++-----
 1 file changed, 107 insertions(+), 38 deletions(-)

diff --git a/arch/arm64/crypto/ghash-ce-glue.c b/arch/arm64/crypto/ghash-ce-glue.c
index 15794fe21a0b2eca..4b45fad493b16239 100644
--- a/arch/arm64/crypto/ghash-ce-glue.c
+++ b/arch/arm64/crypto/ghash-ce-glue.c
@@ -9,6 +9,7 @@
 #include <asm/simd.h>
 #include <asm/unaligned.h>
 #include <crypto/aes.h>
+#include <crypto/gcm.h>
 #include <crypto/algapi.h>
 #include <crypto/b128ops.h>
 #include <crypto/gf128mul.h>
@@ -28,7 +29,8 @@ MODULE_ALIAS_CRYPTO("ghash");
 
 #define GHASH_BLOCK_SIZE	16
 #define GHASH_DIGEST_SIZE	16
-#define GCM_IV_SIZE		12
+
+#define RFC4106_NONCE_SIZE	4
 
 struct ghash_key {
 	be128			k;
@@ -43,6 +45,7 @@ struct ghash_desc_ctx {
 
 struct gcm_aes_ctx {
 	struct crypto_aes_ctx	aes_key;
+	u8			nonce[RFC4106_NONCE_SIZE];
 	struct ghash_key	ghash_key;
 };
 
@@ -226,8 +229,8 @@ static int num_rounds(struct crypto_aes_ctx *ctx)
 	return 6 + ctx->key_length / 4;
 }
 
-static int gcm_setkey(struct crypto_aead *tfm, const u8 *inkey,
-		      unsigned int keylen)
+static int gcm_aes_setkey(struct crypto_aead *tfm, const u8 *inkey,
+			  unsigned int keylen)
 {
 	struct gcm_aes_ctx *ctx = crypto_aead_ctx(tfm);
 	u8 key[GHASH_BLOCK_SIZE];
@@ -258,17 +261,9 @@ static int gcm_setkey(struct crypto_aead *tfm, const u8 *inkey,
 	return 0;
 }
 
-static int gcm_setauthsize(struct crypto_aead *tfm, unsigned int authsize)
+static int gcm_aes_setauthsize(struct crypto_aead *tfm, unsigned int authsize)
 {
-	switch (authsize) {
-	case 4:
-	case 8:
-	case 12 ... 16:
-		break;
-	default:
-		return -EINVAL;
-	}
-	return 0;
+	return crypto_gcm_check_authsize(authsize);
 }
 
 static void gcm_update_mac(u64 dg[], const u8 *src, int count, u8 buf[],
@@ -302,13 +297,12 @@ static void gcm_update_mac(u64 dg[], const u8 *src, int count, u8 buf[],
 	}
 }
 
-static void gcm_calculate_auth_mac(struct aead_request *req, u64 dg[])
+static void gcm_calculate_auth_mac(struct aead_request *req, u64 dg[], u32 len)
 {
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	struct gcm_aes_ctx *ctx = crypto_aead_ctx(aead);
 	u8 buf[GHASH_BLOCK_SIZE];
 	struct scatter_walk walk;
-	u32 len = req->assoclen;
 	int buf_count = 0;
 
 	scatterwalk_start(&walk, req->src);
@@ -338,27 +332,25 @@ static void gcm_calculate_auth_mac(struct aead_request *req, u64 dg[])
 	}
 }
 
-static int gcm_encrypt(struct aead_request *req)
+static int gcm_encrypt(struct aead_request *req, char *iv, int assoclen)
 {
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	struct gcm_aes_ctx *ctx = crypto_aead_ctx(aead);
 	int nrounds = num_rounds(&ctx->aes_key);
 	struct skcipher_walk walk;
 	u8 buf[AES_BLOCK_SIZE];
-	u8 iv[AES_BLOCK_SIZE];
 	u64 dg[2] = {};
 	be128 lengths;
 	u8 *tag;
 	int err;
 
-	lengths.a = cpu_to_be64(req->assoclen * 8);
+	lengths.a = cpu_to_be64(assoclen * 8);
 	lengths.b = cpu_to_be64(req->cryptlen * 8);
 
-	if (req->assoclen)
-		gcm_calculate_auth_mac(req, dg);
+	if (assoclen)
+		gcm_calculate_auth_mac(req, dg, assoclen);
 
-	memcpy(iv, req->iv, GCM_IV_SIZE);
-	put_unaligned_be32(2, iv + GCM_IV_SIZE);
+	put_unaligned_be32(2, iv + GCM_AES_IV_SIZE);
 
 	err = skcipher_walk_aead_encrypt(&walk, req, false);
 
@@ -403,7 +395,7 @@ static int gcm_encrypt(struct aead_request *req)
 	return 0;
 }
 
-static int gcm_decrypt(struct aead_request *req)
+static int gcm_decrypt(struct aead_request *req, char *iv, int assoclen)
 {
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	struct gcm_aes_ctx *ctx = crypto_aead_ctx(aead);
@@ -412,21 +404,19 @@ static int gcm_decrypt(struct aead_request *req)
 	struct skcipher_walk walk;
 	u8 otag[AES_BLOCK_SIZE];
 	u8 buf[AES_BLOCK_SIZE];
-	u8 iv[AES_BLOCK_SIZE];
 	u64 dg[2] = {};
 	be128 lengths;
 	u8 *tag;
 	int ret;
 	int err;
 
-	lengths.a = cpu_to_be64(req->assoclen * 8);
+	lengths.a = cpu_to_be64(assoclen * 8);
 	lengths.b = cpu_to_be64((req->cryptlen - authsize) * 8);
 
-	if (req->assoclen)
-		gcm_calculate_auth_mac(req, dg);
+	if (assoclen)
+		gcm_calculate_auth_mac(req, dg, assoclen);
 
-	memcpy(iv, req->iv, GCM_IV_SIZE);
-	put_unaligned_be32(2, iv + GCM_IV_SIZE);
+	put_unaligned_be32(2, iv + GCM_AES_IV_SIZE);
 
 	scatterwalk_map_and_copy(otag, req->src,
 				 req->assoclen + req->cryptlen - authsize,
@@ -471,14 +461,76 @@ static int gcm_decrypt(struct aead_request *req)
 	return ret ? -EBADMSG : 0;
 }
 
-static struct aead_alg gcm_aes_alg = {
-	.ivsize			= GCM_IV_SIZE,
+static int gcm_aes_encrypt(struct aead_request *req)
+{
+	u8 iv[AES_BLOCK_SIZE];
+
+	memcpy(iv, req->iv, GCM_AES_IV_SIZE);
+	return gcm_encrypt(req, iv, req->assoclen);
+}
+
+static int gcm_aes_decrypt(struct aead_request *req)
+{
+	u8 iv[AES_BLOCK_SIZE];
+
+	memcpy(iv, req->iv, GCM_AES_IV_SIZE);
+	return gcm_decrypt(req, iv, req->assoclen);
+}
+
+static int rfc4106_setkey(struct crypto_aead *tfm, const u8 *inkey,
+			  unsigned int keylen)
+{
+	struct gcm_aes_ctx *ctx = crypto_aead_ctx(tfm);
+	int err;
+
+	keylen -= RFC4106_NONCE_SIZE;
+	err = gcm_aes_setkey(tfm, inkey, keylen);
+	if (err)
+		return err;
+
+	memcpy(ctx->nonce, inkey + keylen, RFC4106_NONCE_SIZE);
+	return 0;
+}
+
+static int rfc4106_setauthsize(struct crypto_aead *tfm, unsigned int authsize)
+{
+	return crypto_rfc4106_check_authsize(authsize);
+}
+
+static int rfc4106_encrypt(struct aead_request *req)
+{
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct gcm_aes_ctx *ctx = crypto_aead_ctx(aead);
+	u8 iv[AES_BLOCK_SIZE];
+
+	memcpy(iv, ctx->nonce, RFC4106_NONCE_SIZE);
+	memcpy(iv + RFC4106_NONCE_SIZE, req->iv, GCM_RFC4106_IV_SIZE);
+
+	return crypto_ipsec_check_assoclen(req->assoclen) ?:
+	       gcm_encrypt(req, iv, req->assoclen - GCM_RFC4106_IV_SIZE);
+}
+
+static int rfc4106_decrypt(struct aead_request *req)
+{
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct gcm_aes_ctx *ctx = crypto_aead_ctx(aead);
+	u8 iv[AES_BLOCK_SIZE];
+
+	memcpy(iv, ctx->nonce, RFC4106_NONCE_SIZE);
+	memcpy(iv + RFC4106_NONCE_SIZE, req->iv, GCM_RFC4106_IV_SIZE);
+
+	return crypto_ipsec_check_assoclen(req->assoclen) ?:
+	       gcm_decrypt(req, iv, req->assoclen - GCM_RFC4106_IV_SIZE);
+}
+
+static struct aead_alg gcm_aes_algs[] = {{
+	.ivsize			= GCM_AES_IV_SIZE,
 	.chunksize		= AES_BLOCK_SIZE,
 	.maxauthsize		= AES_BLOCK_SIZE,
-	.setkey			= gcm_setkey,
-	.setauthsize		= gcm_setauthsize,
-	.encrypt		= gcm_encrypt,
-	.decrypt		= gcm_decrypt,
+	.setkey			= gcm_aes_setkey,
+	.setauthsize		= gcm_aes_setauthsize,
+	.encrypt		= gcm_aes_encrypt,
+	.decrypt		= gcm_aes_decrypt,
 
 	.base.cra_name		= "gcm(aes)",
 	.base.cra_driver_name	= "gcm-aes-ce",
@@ -487,7 +539,23 @@ static struct aead_alg gcm_aes_alg = {
 	.base.cra_ctxsize	= sizeof(struct gcm_aes_ctx) +
 				  4 * sizeof(u64[2]),
 	.base.cra_module	= THIS_MODULE,
-};
+}, {
+	.ivsize			= GCM_RFC4106_IV_SIZE,
+	.chunksize		= AES_BLOCK_SIZE,
+	.maxauthsize		= AES_BLOCK_SIZE,
+	.setkey			= rfc4106_setkey,
+	.setauthsize		= rfc4106_setauthsize,
+	.encrypt		= rfc4106_encrypt,
+	.decrypt		= rfc4106_decrypt,
+
+	.base.cra_name		= "rfc4106(gcm(aes))",
+	.base.cra_driver_name	= "rfc4106-gcm-aes-ce",
+	.base.cra_priority	= 300,
+	.base.cra_blocksize	= 1,
+	.base.cra_ctxsize	= sizeof(struct gcm_aes_ctx) +
+				  4 * sizeof(u64[2]),
+	.base.cra_module	= THIS_MODULE,
+}};
 
 static int __init ghash_ce_mod_init(void)
 {
@@ -495,7 +563,8 @@ static int __init ghash_ce_mod_init(void)
 		return -ENODEV;
 
 	if (cpu_have_named_feature(PMULL))
-		return crypto_register_aead(&gcm_aes_alg);
+		return crypto_register_aeads(gcm_aes_algs,
+					     ARRAY_SIZE(gcm_aes_algs));
 
 	return crypto_register_shash(&ghash_alg);
 }
@@ -503,7 +572,7 @@ static int __init ghash_ce_mod_init(void)
 static void __exit ghash_ce_mod_exit(void)
 {
 	if (cpu_have_named_feature(PMULL))
-		crypto_unregister_aead(&gcm_aes_alg);
+		crypto_unregister_aeads(gcm_aes_algs, ARRAY_SIZE(gcm_aes_algs));
 	else
 		crypto_unregister_shash(&ghash_alg);
 }
-- 
2.35.1

