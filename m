Return-Path: <SRS0=xGgh=RN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E6B6C10F03
	for <linux-crypto@archiver.kernel.org>; Sun, 10 Mar 2019 19:02:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E7EA02087F
	for <linux-crypto@archiver.kernel.org>; Sun, 10 Mar 2019 19:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552244532;
	bh=x2Ut1VxkzysMpzLR+FKTn27n15GKadI6R6zxso/Zxr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=bSgBennT80jn4yxe+AKtJCj9UVN3BtRzy+jtuf3CVb59jTjpXKBZIezHTBWyctkIg
	 I4pefnLSN2YkERWBJuOX0urNQtPdKtMAXe9r9yZstpbTSqbtryy8WxGlltShv2JIBe
	 Ic7hx0U2PcqgQDuThGDMVOY/WE/xT68Ybl9Xl1eo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726732AbfCJTCL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 10 Mar 2019 15:02:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:36936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726682AbfCJTCK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 10 Mar 2019 15:02:10 -0400
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F070220850;
        Sun, 10 Mar 2019 19:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552244530;
        bh=x2Ut1VxkzysMpzLR+FKTn27n15GKadI6R6zxso/Zxr0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zgrn/EzH9G8HHH1Rf+IadLWFdYYI5AbZ9vZNU8Su3K55It20U+4Y8kebyN3HHMfd8
         T9xQzWuyEgAvPxeT1pMfeKje/m6YIMKouuDSwWRZziXx4XkvhHUqU4y/L5lqbmuOHp
         oN6+LhOJeo39lWsDHPeIn7t34IfLU/KnOBMd1s0g=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Ondrej Mosnacek <omosnace@redhat.com>
Subject: [PATCH 3/9] crypto: x86/aesni - convert to use AEAD SIMD helpers
Date:   Sun, 10 Mar 2019 12:00:52 -0700
Message-Id: <20190310190058.4912-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190310190058.4912-1-ebiggers@kernel.org>
References: <20190310190058.4912-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Convert the AES-NI implementations of "gcm(aes)" and "rfc4106(gcm(aes))"
to use the AEAD SIMD helpers, rather than hand-rolling the same
functionality.  This simplifies the code and also fixes the bug where
the user-provided aead_request is modified.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/aesni-intel_glue.c | 161 +++--------------------------
 1 file changed, 15 insertions(+), 146 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 451918cc5f73..1466d59384ac 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -25,7 +25,6 @@
 #include <linux/err.h>
 #include <crypto/algapi.h>
 #include <crypto/aes.h>
-#include <crypto/cryptd.h>
 #include <crypto/ctr.h>
 #include <crypto/b128ops.h>
 #include <crypto/gcm.h>
@@ -643,29 +642,6 @@ static int xts_decrypt(struct skcipher_request *req)
 				   aes_ctx(ctx->raw_crypt_ctx));
 }
 
-static int rfc4106_init(struct crypto_aead *aead)
-{
-	struct cryptd_aead *cryptd_tfm;
-	struct cryptd_aead **ctx = crypto_aead_ctx(aead);
-
-	cryptd_tfm = cryptd_alloc_aead("__driver-gcm-aes-aesni",
-				       CRYPTO_ALG_INTERNAL,
-				       CRYPTO_ALG_INTERNAL);
-	if (IS_ERR(cryptd_tfm))
-		return PTR_ERR(cryptd_tfm);
-
-	*ctx = cryptd_tfm;
-	crypto_aead_set_reqsize(aead, crypto_aead_reqsize(&cryptd_tfm->base));
-	return 0;
-}
-
-static void rfc4106_exit(struct crypto_aead *aead)
-{
-	struct cryptd_aead **ctx = crypto_aead_ctx(aead);
-
-	cryptd_free_aead(*ctx);
-}
-
 static int
 rfc4106_set_hash_subkey(u8 *hash_subkey, const u8 *key, unsigned int key_len)
 {
@@ -710,15 +686,8 @@ static int common_rfc4106_set_key(struct crypto_aead *aead, const u8 *key,
 	       rfc4106_set_hash_subkey(ctx->hash_subkey, key, key_len);
 }
 
-static int gcmaes_wrapper_set_key(struct crypto_aead *parent, const u8 *key,
-				  unsigned int key_len)
-{
-	struct cryptd_aead **ctx = crypto_aead_ctx(parent);
-	struct cryptd_aead *cryptd_tfm = *ctx;
-
-	return crypto_aead_setkey(&cryptd_tfm->base, key, key_len);
-}
-
+/* This is the Integrity Check Value (aka the authentication tag) length and can
+ * be 8, 12 or 16 bytes long. */
 static int common_rfc4106_set_authsize(struct crypto_aead *aead,
 				       unsigned int authsize)
 {
@@ -734,17 +703,6 @@ static int common_rfc4106_set_authsize(struct crypto_aead *aead,
 	return 0;
 }
 
-/* This is the Integrity Check Value (aka the authentication tag length and can
- * be 8, 12 or 16 bytes long. */
-static int gcmaes_wrapper_set_authsize(struct crypto_aead *parent,
-				       unsigned int authsize)
-{
-	struct cryptd_aead **ctx = crypto_aead_ctx(parent);
-	struct cryptd_aead *cryptd_tfm = *ctx;
-
-	return crypto_aead_setauthsize(&cryptd_tfm->base, authsize);
-}
-
 static int generic_gcmaes_set_authsize(struct crypto_aead *tfm,
 				       unsigned int authsize)
 {
@@ -964,38 +922,6 @@ static int helper_rfc4106_decrypt(struct aead_request *req)
 	return gcmaes_decrypt(req, req->assoclen - 8, ctx->hash_subkey, iv,
 			      aes_ctx);
 }
-
-static int gcmaes_wrapper_encrypt(struct aead_request *req)
-{
-	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	struct cryptd_aead **ctx = crypto_aead_ctx(tfm);
-	struct cryptd_aead *cryptd_tfm = *ctx;
-
-	tfm = &cryptd_tfm->base;
-	if (irq_fpu_usable() && (!in_atomic() ||
-				 !cryptd_aead_queued(cryptd_tfm)))
-		tfm = cryptd_aead_child(cryptd_tfm);
-
-	aead_request_set_tfm(req, tfm);
-
-	return crypto_aead_encrypt(req);
-}
-
-static int gcmaes_wrapper_decrypt(struct aead_request *req)
-{
-	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	struct cryptd_aead **ctx = crypto_aead_ctx(tfm);
-	struct cryptd_aead *cryptd_tfm = *ctx;
-
-	tfm = &cryptd_tfm->base;
-	if (irq_fpu_usable() && (!in_atomic() ||
-				 !cryptd_aead_queued(cryptd_tfm)))
-		tfm = cryptd_aead_child(cryptd_tfm);
-
-	aead_request_set_tfm(req, tfm);
-
-	return crypto_aead_decrypt(req);
-}
 #endif
 
 static struct crypto_alg aesni_algs[] = { {
@@ -1148,31 +1074,7 @@ static int generic_gcmaes_decrypt(struct aead_request *req)
 			      aes_ctx);
 }
 
-static int generic_gcmaes_init(struct crypto_aead *aead)
-{
-	struct cryptd_aead *cryptd_tfm;
-	struct cryptd_aead **ctx = crypto_aead_ctx(aead);
-
-	cryptd_tfm = cryptd_alloc_aead("__driver-generic-gcm-aes-aesni",
-				       CRYPTO_ALG_INTERNAL,
-				       CRYPTO_ALG_INTERNAL);
-	if (IS_ERR(cryptd_tfm))
-		return PTR_ERR(cryptd_tfm);
-
-	*ctx = cryptd_tfm;
-	crypto_aead_set_reqsize(aead, crypto_aead_reqsize(&cryptd_tfm->base));
-
-	return 0;
-}
-
-static void generic_gcmaes_exit(struct crypto_aead *aead)
-{
-	struct cryptd_aead **ctx = crypto_aead_ctx(aead);
-
-	cryptd_free_aead(*ctx);
-}
-
-static struct aead_alg aesni_aead_algs[] = { {
+static struct aead_alg aesni_aeads[] = { {
 	.setkey			= common_rfc4106_set_key,
 	.setauthsize		= common_rfc4106_set_authsize,
 	.encrypt		= helper_rfc4106_encrypt,
@@ -1180,32 +1082,15 @@ static struct aead_alg aesni_aead_algs[] = { {
 	.ivsize			= GCM_RFC4106_IV_SIZE,
 	.maxauthsize		= 16,
 	.base = {
-		.cra_name		= "__gcm-aes-aesni",
-		.cra_driver_name	= "__driver-gcm-aes-aesni",
+		.cra_name		= "__rfc4106(gcm(aes))",
+		.cra_driver_name	= "__rfc4106-gcm-aesni",
+		.cra_priority		= 400,
 		.cra_flags		= CRYPTO_ALG_INTERNAL,
 		.cra_blocksize		= 1,
 		.cra_ctxsize		= sizeof(struct aesni_rfc4106_gcm_ctx),
 		.cra_alignmask		= AESNI_ALIGN - 1,
 		.cra_module		= THIS_MODULE,
 	},
-}, {
-	.init			= rfc4106_init,
-	.exit			= rfc4106_exit,
-	.setkey			= gcmaes_wrapper_set_key,
-	.setauthsize		= gcmaes_wrapper_set_authsize,
-	.encrypt		= gcmaes_wrapper_encrypt,
-	.decrypt		= gcmaes_wrapper_decrypt,
-	.ivsize			= GCM_RFC4106_IV_SIZE,
-	.maxauthsize		= 16,
-	.base = {
-		.cra_name		= "rfc4106(gcm(aes))",
-		.cra_driver_name	= "rfc4106-gcm-aesni",
-		.cra_priority		= 400,
-		.cra_flags		= CRYPTO_ALG_ASYNC,
-		.cra_blocksize		= 1,
-		.cra_ctxsize		= sizeof(struct cryptd_aead *),
-		.cra_module		= THIS_MODULE,
-	},
 }, {
 	.setkey			= generic_gcmaes_set_key,
 	.setauthsize		= generic_gcmaes_set_authsize,
@@ -1214,38 +1099,21 @@ static struct aead_alg aesni_aead_algs[] = { {
 	.ivsize			= GCM_AES_IV_SIZE,
 	.maxauthsize		= 16,
 	.base = {
-		.cra_name		= "__generic-gcm-aes-aesni",
-		.cra_driver_name	= "__driver-generic-gcm-aes-aesni",
-		.cra_priority		= 0,
+		.cra_name		= "__gcm(aes)",
+		.cra_driver_name	= "__generic-gcm-aesni",
+		.cra_priority		= 400,
 		.cra_flags		= CRYPTO_ALG_INTERNAL,
 		.cra_blocksize		= 1,
 		.cra_ctxsize		= sizeof(struct generic_gcmaes_ctx),
 		.cra_alignmask		= AESNI_ALIGN - 1,
 		.cra_module		= THIS_MODULE,
 	},
-}, {
-	.init			= generic_gcmaes_init,
-	.exit			= generic_gcmaes_exit,
-	.setkey			= gcmaes_wrapper_set_key,
-	.setauthsize		= gcmaes_wrapper_set_authsize,
-	.encrypt		= gcmaes_wrapper_encrypt,
-	.decrypt		= gcmaes_wrapper_decrypt,
-	.ivsize			= GCM_AES_IV_SIZE,
-	.maxauthsize		= 16,
-	.base = {
-		.cra_name		= "gcm(aes)",
-		.cra_driver_name	= "generic-gcm-aesni",
-		.cra_priority		= 400,
-		.cra_flags		= CRYPTO_ALG_ASYNC,
-		.cra_blocksize		= 1,
-		.cra_ctxsize		= sizeof(struct cryptd_aead *),
-		.cra_module		= THIS_MODULE,
-	},
 } };
 #else
-static struct aead_alg aesni_aead_algs[0];
+static struct aead_alg aesni_aeads[0];
 #endif
 
+static struct simd_aead_alg *aesni_simd_aeads[ARRAY_SIZE(aesni_aeads)];
 
 static const struct x86_cpu_id aesni_cpu_id[] = {
 	X86_FEATURE_MATCH(X86_FEATURE_AES),
@@ -1296,8 +1164,8 @@ static int __init aesni_init(void)
 	if (err)
 		goto unregister_algs;
 
-	err = crypto_register_aeads(aesni_aead_algs,
-				    ARRAY_SIZE(aesni_aead_algs));
+	err = simd_register_aeads_compat(aesni_aeads, ARRAY_SIZE(aesni_aeads),
+					 aesni_simd_aeads);
 	if (err)
 		goto unregister_skciphers;
 
@@ -1313,7 +1181,8 @@ static int __init aesni_init(void)
 
 static void __exit aesni_exit(void)
 {
-	crypto_unregister_aeads(aesni_aead_algs, ARRAY_SIZE(aesni_aead_algs));
+	simd_unregister_aeads(aesni_aeads, ARRAY_SIZE(aesni_aeads),
+			      aesni_simd_aeads);
 	simd_unregister_skciphers(aesni_skciphers, ARRAY_SIZE(aesni_skciphers),
 				  aesni_simd_skciphers);
 	crypto_unregister_algs(aesni_algs, ARRAY_SIZE(aesni_algs));
-- 
2.21.0

