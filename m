Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FEE5C388F7
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Nov 2020 19:05:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 268C620797
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Nov 2020 19:05:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="AhIwZsal"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731281AbgKJTFA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Nov 2020 14:05:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:51200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731187AbgKJTFA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Nov 2020 14:05:00 -0500
Received: from e123331-lin.nice.arm.com (lfbn-nic-1-188-42.w2-15.abo.wanadoo.fr [2.15.37.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E14D02076E;
        Tue, 10 Nov 2020 19:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605035099;
        bh=uMlXX6dEGvjboEdSLJCaee28jrk5uTh2PV9QmdrnoPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AhIwZsalO+SdeWzz5OC0Fep9bk2tisPQWmF2wm4aymmF8A+CadDkjeYFlU6uGatoK
         lCx+UwnHXsgQpXT1oGsJDd+JxGbQ2odH9iRi7JZURcCoYzRJj8520F1Qg54bqhhOe2
         TiyXNO5JlV9D7h+tl5SqCbA+RUT2Y7ib1tqV2dbA=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>,
        Ondrej Mosnacek <omosnacek@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 4/4] crypto: aegis128 - expose SIMD code path as separate driver
Date:   Tue, 10 Nov 2020 20:04:44 +0100
Message-Id: <20201110190444.10634-5-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201110190444.10634-1-ardb@kernel.org>
References: <20201110190444.10634-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Wiring the SIMD code into the generic driver has the unfortunate side
effect that the tcrypt testing code cannot distinguish them, and will
therefore not use the latter to fuzz test the former, as it does for
other algorithms.

So let's refactor the code a bit so we can register two implementations:
aegis128-generic and aegis128-simd.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 crypto/aegis128-core.c | 176 +++++++++++++-------
 1 file changed, 119 insertions(+), 57 deletions(-)

diff --git a/crypto/aegis128-core.c b/crypto/aegis128-core.c
index 859c7b905618..19f38e8c1627 100644
--- a/crypto/aegis128-core.c
+++ b/crypto/aegis128-core.c
@@ -396,7 +396,7 @@ static int crypto_aegis128_setauthsize(struct crypto_aead *tfm,
 	return 0;
 }
 
-static int crypto_aegis128_encrypt(struct aead_request *req)
+static int crypto_aegis128_encrypt_generic(struct aead_request *req)
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	union aegis_block tag = {};
@@ -407,27 +407,18 @@ static int crypto_aegis128_encrypt(struct aead_request *req)
 	struct aegis_state state;
 
 	skcipher_walk_aead_encrypt(&walk, req, false);
-	if (aegis128_do_simd()) {
-		crypto_aegis128_init_simd(&state, &ctx->key, req->iv);
-		crypto_aegis128_process_ad(&state, req->src, req->assoclen);
-		crypto_aegis128_process_crypt(&state, &walk,
-					      crypto_aegis128_encrypt_chunk_simd);
-		crypto_aegis128_final_simd(&state, &tag, req->assoclen,
-					   cryptlen, 0);
-	} else {
-		crypto_aegis128_init(&state, &ctx->key, req->iv);
-		crypto_aegis128_process_ad(&state, req->src, req->assoclen);
-		crypto_aegis128_process_crypt(&state, &walk,
-					      crypto_aegis128_encrypt_chunk);
-		crypto_aegis128_final(&state, &tag, req->assoclen, cryptlen);
-	}
+	crypto_aegis128_init(&state, &ctx->key, req->iv);
+	crypto_aegis128_process_ad(&state, req->src, req->assoclen);
+	crypto_aegis128_process_crypt(&state, &walk,
+				      crypto_aegis128_encrypt_chunk);
+	crypto_aegis128_final(&state, &tag, req->assoclen, cryptlen);
 
 	scatterwalk_map_and_copy(tag.bytes, req->dst, req->assoclen + cryptlen,
 				 authsize, 1);
 	return 0;
 }
 
-static int crypto_aegis128_decrypt(struct aead_request *req)
+static int crypto_aegis128_decrypt_generic(struct aead_request *req)
 {
 	static const u8 zeros[AEGIS128_MAX_AUTH_SIZE] = {};
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
@@ -442,27 +433,11 @@ static int crypto_aegis128_decrypt(struct aead_request *req)
 				 authsize, 0);
 
 	skcipher_walk_aead_decrypt(&walk, req, false);
-	if (aegis128_do_simd()) {
-		crypto_aegis128_init_simd(&state, &ctx->key, req->iv);
-		crypto_aegis128_process_ad(&state, req->src, req->assoclen);
-		crypto_aegis128_process_crypt(&state, &walk,
-					      crypto_aegis128_decrypt_chunk_simd);
-		if (unlikely(crypto_aegis128_final_simd(&state, &tag,
-							req->assoclen,
-							cryptlen, authsize))) {
-			skcipher_walk_aead_decrypt(&walk, req, false);
-			crypto_aegis128_process_crypt(NULL, &walk,
-						      crypto_aegis128_wipe_chunk);
-			return -EBADMSG;
-		}
-		return 0;
-	} else {
-		crypto_aegis128_init(&state, &ctx->key, req->iv);
-		crypto_aegis128_process_ad(&state, req->src, req->assoclen);
-		crypto_aegis128_process_crypt(&state, &walk,
-					      crypto_aegis128_decrypt_chunk);
-		crypto_aegis128_final(&state, &tag, req->assoclen, cryptlen);
-	}
+	crypto_aegis128_init(&state, &ctx->key, req->iv);
+	crypto_aegis128_process_ad(&state, req->src, req->assoclen);
+	crypto_aegis128_process_crypt(&state, &walk,
+				      crypto_aegis128_decrypt_chunk);
+	crypto_aegis128_final(&state, &tag, req->assoclen, cryptlen);
 
 	if (unlikely(crypto_memneq(tag.bytes, zeros, authsize))) {
 		/*
@@ -482,42 +457,128 @@ static int crypto_aegis128_decrypt(struct aead_request *req)
 	return 0;
 }
 
-static struct aead_alg crypto_aegis128_alg = {
-	.setkey = crypto_aegis128_setkey,
-	.setauthsize = crypto_aegis128_setauthsize,
-	.encrypt = crypto_aegis128_encrypt,
-	.decrypt = crypto_aegis128_decrypt,
+static int crypto_aegis128_encrypt_simd(struct aead_request *req)
+{
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	union aegis_block tag = {};
+	unsigned int authsize = crypto_aead_authsize(tfm);
+	struct aegis_ctx *ctx = crypto_aead_ctx(tfm);
+	unsigned int cryptlen = req->cryptlen;
+	struct skcipher_walk walk;
+	struct aegis_state state;
 
-	.ivsize = AEGIS128_NONCE_SIZE,
-	.maxauthsize = AEGIS128_MAX_AUTH_SIZE,
-	.chunksize = AEGIS_BLOCK_SIZE,
+	if (!aegis128_do_simd())
+		return crypto_aegis128_encrypt_generic(req);
 
-	.base = {
-		.cra_blocksize = 1,
-		.cra_ctxsize = sizeof(struct aegis_ctx),
-		.cra_alignmask = 0,
+	skcipher_walk_aead_encrypt(&walk, req, false);
+	crypto_aegis128_init_simd(&state, &ctx->key, req->iv);
+	crypto_aegis128_process_ad(&state, req->src, req->assoclen);
+	crypto_aegis128_process_crypt(&state, &walk,
+				      crypto_aegis128_encrypt_chunk_simd);
+	crypto_aegis128_final_simd(&state, &tag, req->assoclen, cryptlen, 0);
 
-		.cra_priority = 100,
+	scatterwalk_map_and_copy(tag.bytes, req->dst, req->assoclen + cryptlen,
+				 authsize, 1);
+	return 0;
+}
 
-		.cra_name = "aegis128",
-		.cra_driver_name = "aegis128-generic",
+static int crypto_aegis128_decrypt_simd(struct aead_request *req)
+{
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	union aegis_block tag;
+	unsigned int authsize = crypto_aead_authsize(tfm);
+	unsigned int cryptlen = req->cryptlen - authsize;
+	struct aegis_ctx *ctx = crypto_aead_ctx(tfm);
+	struct skcipher_walk walk;
+	struct aegis_state state;
+
+	if (!aegis128_do_simd())
+		return crypto_aegis128_decrypt_generic(req);
+
+	scatterwalk_map_and_copy(tag.bytes, req->src, req->assoclen + cryptlen,
+				 authsize, 0);
+
+	skcipher_walk_aead_decrypt(&walk, req, false);
+	crypto_aegis128_init_simd(&state, &ctx->key, req->iv);
+	crypto_aegis128_process_ad(&state, req->src, req->assoclen);
+	crypto_aegis128_process_crypt(&state, &walk,
+				      crypto_aegis128_decrypt_chunk_simd);
 
-		.cra_module = THIS_MODULE,
+	if (unlikely(crypto_aegis128_final_simd(&state, &tag, req->assoclen,
+						cryptlen, authsize))) {
+		skcipher_walk_aead_decrypt(&walk, req, false);
+		crypto_aegis128_process_crypt(NULL, &walk,
+					      crypto_aegis128_wipe_chunk);
+		return -EBADMSG;
 	}
+	return 0;
+}
+
+static struct aead_alg crypto_aegis128_alg_generic = {
+	.setkey			= crypto_aegis128_setkey,
+	.setauthsize		= crypto_aegis128_setauthsize,
+	.encrypt		= crypto_aegis128_encrypt_generic,
+	.decrypt		= crypto_aegis128_decrypt_generic,
+
+	.ivsize			= AEGIS128_NONCE_SIZE,
+	.maxauthsize		= AEGIS128_MAX_AUTH_SIZE,
+	.chunksize		= AEGIS_BLOCK_SIZE,
+
+	.base.cra_blocksize	= 1,
+	.base.cra_ctxsize	= sizeof(struct aegis_ctx),
+	.base.cra_alignmask	= 0,
+	.base.cra_priority	= 100,
+	.base.cra_name		= "aegis128",
+	.base.cra_driver_name	= "aegis128-generic",
+};
+
+static struct aead_alg crypto_aegis128_alg_simd = {
+	.base.cra_module	= THIS_MODULE,
+	.setkey			= crypto_aegis128_setkey,
+	.setauthsize		= crypto_aegis128_setauthsize,
+	.encrypt		= crypto_aegis128_encrypt_simd,
+	.decrypt		= crypto_aegis128_decrypt_simd,
+
+	.ivsize			= AEGIS128_NONCE_SIZE,
+	.maxauthsize		= AEGIS128_MAX_AUTH_SIZE,
+	.chunksize		= AEGIS_BLOCK_SIZE,
+
+	.base.cra_blocksize	= 1,
+	.base.cra_ctxsize	= sizeof(struct aegis_ctx),
+	.base.cra_alignmask	= 0,
+	.base.cra_priority	= 200,
+	.base.cra_name		= "aegis128",
+	.base.cra_driver_name	= "aegis128-simd",
+	.base.cra_module	= THIS_MODULE,
 };
 
 static int __init crypto_aegis128_module_init(void)
 {
+	int ret;
+
+	ret = crypto_register_aead(&crypto_aegis128_alg_generic);
+	if (ret)
+		return ret;
+
 	if (IS_ENABLED(CONFIG_CRYPTO_AEGIS128_SIMD) &&
-	    crypto_aegis128_have_simd())
+	    crypto_aegis128_have_simd()) {
+		ret = crypto_register_aead(&crypto_aegis128_alg_simd);
+		if (ret) {
+			crypto_unregister_aead(&crypto_aegis128_alg_generic);
+			return ret;
+		}
 		static_branch_enable(&have_simd);
-
-	return crypto_register_aead(&crypto_aegis128_alg);
+	}
+	return 0;
 }
 
 static void __exit crypto_aegis128_module_exit(void)
 {
-	crypto_unregister_aead(&crypto_aegis128_alg);
+	if (IS_ENABLED(CONFIG_CRYPTO_AEGIS128_SIMD) &&
+	    crypto_aegis128_have_simd())
+		crypto_unregister_aead(&crypto_aegis128_alg_simd);
+
+	crypto_unregister_aead(&crypto_aegis128_alg_generic);
 }
 
 subsys_initcall(crypto_aegis128_module_init);
@@ -528,3 +589,4 @@ MODULE_AUTHOR("Ondrej Mosnacek <omosnacek@gmail.com>");
 MODULE_DESCRIPTION("AEGIS-128 AEAD algorithm");
 MODULE_ALIAS_CRYPTO("aegis128");
 MODULE_ALIAS_CRYPTO("aegis128-generic");
+MODULE_ALIAS_CRYPTO("aegis128-simd");
-- 
2.17.1

