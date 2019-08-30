Return-Path: <SRS0=VSoq=W2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0244AC3A5A4
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Aug 2019 08:43:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B720C238CF
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Aug 2019 08:43:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tIAOuHUB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727747AbfH3Inn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 30 Aug 2019 04:43:43 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:35778 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726943AbfH3Inm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Aug 2019 04:43:42 -0400
Received: by mail-ed1-f68.google.com with SMTP id t50so7156088edd.2
        for <linux-crypto@vger.kernel.org>; Fri, 30 Aug 2019 01:43:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=n7No1j+dI2r7GYVs3AdWgNebf2YxKNFFsgt8OV0BbTY=;
        b=tIAOuHUBG8EQiEQ4hIXe6eN3KtUSUyqWq2zj8PsFIE0PSgTMnQEQ4VC+KKYnaNGliB
         oc7ecw85yoZq2i2Em19bCOkxbar9JlocPtHkiNQiNhSm+Xh/bu3RAl9zJWzYwmSMjEZe
         0SLbDUsTTn4lv6NZjG/oFQMfgp9Gb5Ee189+bat58mdoQvlGz7nXKZguR75F26Cc+OtJ
         lNA5oZSXEBPQoc6J0Dl/fKFDaYWDE+XYv5fo6LWN9VksWusJsKaIpbZuv8fgVbb4bEsd
         1/FVDe/aIruheqPvqxShRsQo/EgYhJ9xBKOnCZk9UE0jDuZgH2obDuKZ93EpVb+BTdEc
         tqMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=n7No1j+dI2r7GYVs3AdWgNebf2YxKNFFsgt8OV0BbTY=;
        b=Bw6ZEpE6RVfNZ/a/CsZn5lm1+76ctIo+P/iYE4iT5CziO8Sk/YYg/5xifTksEz8kOT
         Rmq4v64LrFU4UgvT5OlLce+c6LP2OSHiS+kySQiR/O+Bz/jUvxCkTImITw3OAa5nx6sE
         4fU1Y/QZUNWWB8tiXfly7FEL8rcjm6p2yIouXmmMNMPD0yZIBgraeL5y8xIcvm18cr3H
         hrGABun/b4x+/WxfN/nvOa+WcZuKN668nk8dAhBbeiJwBaFaezB1yEjO2R4KptGALNLN
         2Gku49nMDHSlZ4V66fmiGxHg5ZcO6XZ9dBTkCFnjIGP1g4K+RjohJ0qPcFwvmEHaZ2Rz
         s50w==
X-Gm-Message-State: APjAAAUvPVctosTIyONQFqMzWM7ujQSiXZi3VQZeZWXvZoVbGhWZ31ed
        akfEF8YZBHt9Roh0S5IA8ylp32pY
X-Google-Smtp-Source: APXvYqyd2iG4eY3atSb/1KYzkU1FpVUgpbcYmNQD9JXAgARHC1NCjRCqiANR4Z+2HIQ/Ohn9j8cADg==
X-Received: by 2002:a17:906:9713:: with SMTP id k19mr6934432ejx.122.1567154620484;
        Fri, 30 Aug 2019 01:43:40 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id x11sm705823eju.26.2019.08.30.01.43.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Aug 2019 01:43:39 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH 1/3] crypto: inside-secure - Move static cipher alg & mode settings to init
Date:   Fri, 30 Aug 2019 09:40:52 +0200
Message-Id: <1567150854-10589-2-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1567150854-10589-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1567150854-10589-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

ctx->alg and ctx->mode were set from safexcel_send_req through the
various safexcel_encrypt and _decrypt routines, but this makes little
sense as these are static per ciphersuite. So moved to _init instead,
in preparation of adding more ciphersuites.

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel_cipher.c | 258 +++++++++++--------------
 1 file changed, 111 insertions(+), 147 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index c78c6de..8987d35 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -909,8 +909,7 @@ static int safexcel_aead_exit_inv(struct crypto_tfm *tfm)
 
 static int safexcel_queue_req(struct crypto_async_request *base,
 			struct safexcel_cipher_req *sreq,
-			enum safexcel_cipher_direction dir, u32 mode,
-			enum safexcel_cipher_alg alg)
+			enum safexcel_cipher_direction dir)
 {
 	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(base->tfm);
 	struct safexcel_crypto_priv *priv = ctx->priv;
@@ -918,8 +917,6 @@ static int safexcel_queue_req(struct crypto_async_request *base,
 
 	sreq->needs_inv = false;
 	sreq->direction = dir;
-	ctx->alg = alg;
-	ctx->mode = mode;
 
 	if (ctx->base.ctxr) {
 		if (priv->flags & EIP197_TRC_CACHE && ctx->base.needs_inv) {
@@ -947,18 +944,16 @@ static int safexcel_queue_req(struct crypto_async_request *base,
 	return ret;
 }
 
-static int safexcel_ecb_aes_encrypt(struct skcipher_request *req)
+static int safexcel_encrypt(struct skcipher_request *req)
 {
 	return safexcel_queue_req(&req->base, skcipher_request_ctx(req),
-			SAFEXCEL_ENCRYPT, CONTEXT_CONTROL_CRYPTO_MODE_ECB,
-			SAFEXCEL_AES);
+			SAFEXCEL_ENCRYPT);
 }
 
-static int safexcel_ecb_aes_decrypt(struct skcipher_request *req)
+static int safexcel_decrypt(struct skcipher_request *req)
 {
 	return safexcel_queue_req(&req->base, skcipher_request_ctx(req),
-			SAFEXCEL_DECRYPT, CONTEXT_CONTROL_CRYPTO_MODE_ECB,
-			SAFEXCEL_AES);
+			SAFEXCEL_DECRYPT);
 }
 
 static int safexcel_skcipher_cra_init(struct crypto_tfm *tfm)
@@ -1032,12 +1027,22 @@ static void safexcel_aead_cra_exit(struct crypto_tfm *tfm)
 	}
 }
 
+static int safexcel_skcipher_aes_ecb_cra_init(struct crypto_tfm *tfm)
+{
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	safexcel_skcipher_cra_init(tfm);
+	ctx->alg  = SAFEXCEL_AES;
+	ctx->mode = CONTEXT_CONTROL_CRYPTO_MODE_ECB;
+	return 0;
+}
+
 struct safexcel_alg_template safexcel_alg_ecb_aes = {
 	.type = SAFEXCEL_ALG_TYPE_SKCIPHER,
 	.alg.skcipher = {
 		.setkey = safexcel_skcipher_aes_setkey,
-		.encrypt = safexcel_ecb_aes_encrypt,
-		.decrypt = safexcel_ecb_aes_decrypt,
+		.encrypt = safexcel_encrypt,
+		.decrypt = safexcel_decrypt,
 		.min_keysize = AES_MIN_KEY_SIZE,
 		.max_keysize = AES_MAX_KEY_SIZE,
 		.base = {
@@ -1049,33 +1054,29 @@ struct safexcel_alg_template safexcel_alg_ecb_aes = {
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
 			.cra_alignmask = 0,
-			.cra_init = safexcel_skcipher_cra_init,
+			.cra_init = safexcel_skcipher_aes_ecb_cra_init,
 			.cra_exit = safexcel_skcipher_cra_exit,
 			.cra_module = THIS_MODULE,
 		},
 	},
 };
 
-static int safexcel_cbc_aes_encrypt(struct skcipher_request *req)
+static int safexcel_skcipher_aes_cbc_cra_init(struct crypto_tfm *tfm)
 {
-	return safexcel_queue_req(&req->base, skcipher_request_ctx(req),
-			SAFEXCEL_ENCRYPT, CONTEXT_CONTROL_CRYPTO_MODE_CBC,
-			SAFEXCEL_AES);
-}
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
 
-static int safexcel_cbc_aes_decrypt(struct skcipher_request *req)
-{
-	return safexcel_queue_req(&req->base, skcipher_request_ctx(req),
-			SAFEXCEL_DECRYPT, CONTEXT_CONTROL_CRYPTO_MODE_CBC,
-			SAFEXCEL_AES);
+	safexcel_skcipher_cra_init(tfm);
+	ctx->alg  = SAFEXCEL_AES;
+	ctx->mode = CONTEXT_CONTROL_CRYPTO_MODE_CBC;
+	return 0;
 }
 
 struct safexcel_alg_template safexcel_alg_cbc_aes = {
 	.type = SAFEXCEL_ALG_TYPE_SKCIPHER,
 	.alg.skcipher = {
 		.setkey = safexcel_skcipher_aes_setkey,
-		.encrypt = safexcel_cbc_aes_encrypt,
-		.decrypt = safexcel_cbc_aes_decrypt,
+		.encrypt = safexcel_encrypt,
+		.decrypt = safexcel_decrypt,
 		.min_keysize = AES_MIN_KEY_SIZE,
 		.max_keysize = AES_MAX_KEY_SIZE,
 		.ivsize = AES_BLOCK_SIZE,
@@ -1088,27 +1089,13 @@ struct safexcel_alg_template safexcel_alg_cbc_aes = {
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
 			.cra_alignmask = 0,
-			.cra_init = safexcel_skcipher_cra_init,
+			.cra_init = safexcel_skcipher_aes_cbc_cra_init,
 			.cra_exit = safexcel_skcipher_cra_exit,
 			.cra_module = THIS_MODULE,
 		},
 	},
 };
 
-static int safexcel_ctr_aes_encrypt(struct skcipher_request *req)
-{
-	return safexcel_queue_req(&req->base, skcipher_request_ctx(req),
-			SAFEXCEL_ENCRYPT, CONTEXT_CONTROL_CRYPTO_MODE_CTR_LOAD,
-			SAFEXCEL_AES);
-}
-
-static int safexcel_ctr_aes_decrypt(struct skcipher_request *req)
-{
-	return safexcel_queue_req(&req->base, skcipher_request_ctx(req),
-			SAFEXCEL_DECRYPT, CONTEXT_CONTROL_CRYPTO_MODE_CTR_LOAD,
-			SAFEXCEL_AES);
-}
-
 static int safexcel_skcipher_aesctr_setkey(struct crypto_skcipher *ctfm,
 					   const u8 *key, unsigned int len)
 {
@@ -1147,12 +1134,22 @@ static int safexcel_skcipher_aesctr_setkey(struct crypto_skcipher *ctfm,
 	return 0;
 }
 
+static int safexcel_skcipher_aes_ctr_cra_init(struct crypto_tfm *tfm)
+{
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	safexcel_skcipher_cra_init(tfm);
+	ctx->alg  = SAFEXCEL_AES;
+	ctx->mode = CONTEXT_CONTROL_CRYPTO_MODE_CTR_LOAD;
+	return 0;
+}
+
 struct safexcel_alg_template safexcel_alg_ctr_aes = {
 	.type = SAFEXCEL_ALG_TYPE_SKCIPHER,
 	.alg.skcipher = {
 		.setkey = safexcel_skcipher_aesctr_setkey,
-		.encrypt = safexcel_ctr_aes_encrypt,
-		.decrypt = safexcel_ctr_aes_decrypt,
+		.encrypt = safexcel_encrypt,
+		.decrypt = safexcel_decrypt,
 		/* Add nonce size */
 		.min_keysize = AES_MIN_KEY_SIZE + CTR_RFC3686_NONCE_SIZE,
 		.max_keysize = AES_MAX_KEY_SIZE + CTR_RFC3686_NONCE_SIZE,
@@ -1166,27 +1163,13 @@ struct safexcel_alg_template safexcel_alg_ctr_aes = {
 			.cra_blocksize = 1,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
 			.cra_alignmask = 0,
-			.cra_init = safexcel_skcipher_cra_init,
+			.cra_init = safexcel_skcipher_aes_ctr_cra_init,
 			.cra_exit = safexcel_skcipher_cra_exit,
 			.cra_module = THIS_MODULE,
 		},
 	},
 };
 
-static int safexcel_cbc_des_encrypt(struct skcipher_request *req)
-{
-	return safexcel_queue_req(&req->base, skcipher_request_ctx(req),
-			SAFEXCEL_ENCRYPT, CONTEXT_CONTROL_CRYPTO_MODE_CBC,
-			SAFEXCEL_DES);
-}
-
-static int safexcel_cbc_des_decrypt(struct skcipher_request *req)
-{
-	return safexcel_queue_req(&req->base, skcipher_request_ctx(req),
-			SAFEXCEL_DECRYPT, CONTEXT_CONTROL_CRYPTO_MODE_CBC,
-			SAFEXCEL_DES);
-}
-
 static int safexcel_des_setkey(struct crypto_skcipher *ctfm, const u8 *key,
 			       unsigned int len)
 {
@@ -1212,12 +1195,22 @@ static int safexcel_des_setkey(struct crypto_skcipher *ctfm, const u8 *key,
 	return 0;
 }
 
+static int safexcel_skcipher_des_cbc_cra_init(struct crypto_tfm *tfm)
+{
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	safexcel_skcipher_cra_init(tfm);
+	ctx->alg  = SAFEXCEL_DES;
+	ctx->mode = CONTEXT_CONTROL_CRYPTO_MODE_CBC;
+	return 0;
+}
+
 struct safexcel_alg_template safexcel_alg_cbc_des = {
 	.type = SAFEXCEL_ALG_TYPE_SKCIPHER,
 	.alg.skcipher = {
 		.setkey = safexcel_des_setkey,
-		.encrypt = safexcel_cbc_des_encrypt,
-		.decrypt = safexcel_cbc_des_decrypt,
+		.encrypt = safexcel_encrypt,
+		.decrypt = safexcel_decrypt,
 		.min_keysize = DES_KEY_SIZE,
 		.max_keysize = DES_KEY_SIZE,
 		.ivsize = DES_BLOCK_SIZE,
@@ -1230,33 +1223,29 @@ struct safexcel_alg_template safexcel_alg_cbc_des = {
 			.cra_blocksize = DES_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
 			.cra_alignmask = 0,
-			.cra_init = safexcel_skcipher_cra_init,
+			.cra_init = safexcel_skcipher_des_cbc_cra_init,
 			.cra_exit = safexcel_skcipher_cra_exit,
 			.cra_module = THIS_MODULE,
 		},
 	},
 };
 
-static int safexcel_ecb_des_encrypt(struct skcipher_request *req)
+static int safexcel_skcipher_des_ecb_cra_init(struct crypto_tfm *tfm)
 {
-	return safexcel_queue_req(&req->base, skcipher_request_ctx(req),
-			SAFEXCEL_ENCRYPT, CONTEXT_CONTROL_CRYPTO_MODE_ECB,
-			SAFEXCEL_DES);
-}
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
 
-static int safexcel_ecb_des_decrypt(struct skcipher_request *req)
-{
-	return safexcel_queue_req(&req->base, skcipher_request_ctx(req),
-			SAFEXCEL_DECRYPT, CONTEXT_CONTROL_CRYPTO_MODE_ECB,
-			SAFEXCEL_DES);
+	safexcel_skcipher_cra_init(tfm);
+	ctx->alg  = SAFEXCEL_DES;
+	ctx->mode = CONTEXT_CONTROL_CRYPTO_MODE_ECB;
+	return 0;
 }
 
 struct safexcel_alg_template safexcel_alg_ecb_des = {
 	.type = SAFEXCEL_ALG_TYPE_SKCIPHER,
 	.alg.skcipher = {
 		.setkey = safexcel_des_setkey,
-		.encrypt = safexcel_ecb_des_encrypt,
-		.decrypt = safexcel_ecb_des_decrypt,
+		.encrypt = safexcel_encrypt,
+		.decrypt = safexcel_decrypt,
 		.min_keysize = DES_KEY_SIZE,
 		.max_keysize = DES_KEY_SIZE,
 		.base = {
@@ -1268,27 +1257,13 @@ struct safexcel_alg_template safexcel_alg_ecb_des = {
 			.cra_blocksize = DES_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
 			.cra_alignmask = 0,
-			.cra_init = safexcel_skcipher_cra_init,
+			.cra_init = safexcel_skcipher_des_ecb_cra_init,
 			.cra_exit = safexcel_skcipher_cra_exit,
 			.cra_module = THIS_MODULE,
 		},
 	},
 };
 
-static int safexcel_cbc_des3_ede_encrypt(struct skcipher_request *req)
-{
-	return safexcel_queue_req(&req->base, skcipher_request_ctx(req),
-			SAFEXCEL_ENCRYPT, CONTEXT_CONTROL_CRYPTO_MODE_CBC,
-			SAFEXCEL_3DES);
-}
-
-static int safexcel_cbc_des3_ede_decrypt(struct skcipher_request *req)
-{
-	return safexcel_queue_req(&req->base, skcipher_request_ctx(req),
-			SAFEXCEL_DECRYPT, CONTEXT_CONTROL_CRYPTO_MODE_CBC,
-			SAFEXCEL_3DES);
-}
-
 static int safexcel_des3_ede_setkey(struct crypto_skcipher *ctfm,
 				   const u8 *key, unsigned int len)
 {
@@ -1312,12 +1287,22 @@ static int safexcel_des3_ede_setkey(struct crypto_skcipher *ctfm,
 	return 0;
 }
 
+static int safexcel_skcipher_des3_cbc_cra_init(struct crypto_tfm *tfm)
+{
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	safexcel_skcipher_cra_init(tfm);
+	ctx->alg  = SAFEXCEL_3DES;
+	ctx->mode = CONTEXT_CONTROL_CRYPTO_MODE_CBC;
+	return 0;
+}
+
 struct safexcel_alg_template safexcel_alg_cbc_des3_ede = {
 	.type = SAFEXCEL_ALG_TYPE_SKCIPHER,
 	.alg.skcipher = {
 		.setkey = safexcel_des3_ede_setkey,
-		.encrypt = safexcel_cbc_des3_ede_encrypt,
-		.decrypt = safexcel_cbc_des3_ede_decrypt,
+		.encrypt = safexcel_encrypt,
+		.decrypt = safexcel_decrypt,
 		.min_keysize = DES3_EDE_KEY_SIZE,
 		.max_keysize = DES3_EDE_KEY_SIZE,
 		.ivsize = DES3_EDE_BLOCK_SIZE,
@@ -1330,33 +1315,29 @@ struct safexcel_alg_template safexcel_alg_cbc_des3_ede = {
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
 			.cra_alignmask = 0,
-			.cra_init = safexcel_skcipher_cra_init,
+			.cra_init = safexcel_skcipher_des3_cbc_cra_init,
 			.cra_exit = safexcel_skcipher_cra_exit,
 			.cra_module = THIS_MODULE,
 		},
 	},
 };
 
-static int safexcel_ecb_des3_ede_encrypt(struct skcipher_request *req)
+static int safexcel_skcipher_des3_ecb_cra_init(struct crypto_tfm *tfm)
 {
-	return safexcel_queue_req(&req->base, skcipher_request_ctx(req),
-			SAFEXCEL_ENCRYPT, CONTEXT_CONTROL_CRYPTO_MODE_ECB,
-			SAFEXCEL_3DES);
-}
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
 
-static int safexcel_ecb_des3_ede_decrypt(struct skcipher_request *req)
-{
-	return safexcel_queue_req(&req->base, skcipher_request_ctx(req),
-			SAFEXCEL_DECRYPT, CONTEXT_CONTROL_CRYPTO_MODE_ECB,
-			SAFEXCEL_3DES);
+	safexcel_skcipher_cra_init(tfm);
+	ctx->alg  = SAFEXCEL_3DES;
+	ctx->mode = CONTEXT_CONTROL_CRYPTO_MODE_ECB;
+	return 0;
 }
 
 struct safexcel_alg_template safexcel_alg_ecb_des3_ede = {
 	.type = SAFEXCEL_ALG_TYPE_SKCIPHER,
 	.alg.skcipher = {
 		.setkey = safexcel_des3_ede_setkey,
-		.encrypt = safexcel_ecb_des3_ede_encrypt,
-		.decrypt = safexcel_ecb_des3_ede_decrypt,
+		.encrypt = safexcel_encrypt,
+		.decrypt = safexcel_decrypt,
 		.min_keysize = DES3_EDE_KEY_SIZE,
 		.max_keysize = DES3_EDE_KEY_SIZE,
 		.base = {
@@ -1368,27 +1349,25 @@ struct safexcel_alg_template safexcel_alg_ecb_des3_ede = {
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
 			.cra_alignmask = 0,
-			.cra_init = safexcel_skcipher_cra_init,
+			.cra_init = safexcel_skcipher_des3_ecb_cra_init,
 			.cra_exit = safexcel_skcipher_cra_exit,
 			.cra_module = THIS_MODULE,
 		},
 	},
 };
 
-static int safexcel_aead_encrypt_aes(struct aead_request *req)
+static int safexcel_aead_encrypt(struct aead_request *req)
 {
 	struct safexcel_cipher_req *creq = aead_request_ctx(req);
 
-	return safexcel_queue_req(&req->base, creq, SAFEXCEL_ENCRYPT,
-			CONTEXT_CONTROL_CRYPTO_MODE_CBC, SAFEXCEL_AES);
+	return safexcel_queue_req(&req->base, creq, SAFEXCEL_ENCRYPT);
 }
 
-static int safexcel_aead_decrypt_aes(struct aead_request *req)
+static int safexcel_aead_decrypt(struct aead_request *req)
 {
 	struct safexcel_cipher_req *creq = aead_request_ctx(req);
 
-	return safexcel_queue_req(&req->base, creq, SAFEXCEL_DECRYPT,
-			CONTEXT_CONTROL_CRYPTO_MODE_CBC, SAFEXCEL_AES);
+	return safexcel_queue_req(&req->base, creq, SAFEXCEL_DECRYPT);
 }
 
 static int safexcel_aead_cra_init(struct crypto_tfm *tfm)
@@ -1404,6 +1383,7 @@ static int safexcel_aead_cra_init(struct crypto_tfm *tfm)
 	ctx->priv = tmpl->priv;
 
 	ctx->alg  = SAFEXCEL_AES; /* default */
+	ctx->mode = CONTEXT_CONTROL_CRYPTO_MODE_CBC; /* default */
 	ctx->aead = true;
 	ctx->base.send = safexcel_aead_send;
 	ctx->base.handle_result = safexcel_aead_handle_result;
@@ -1424,8 +1404,8 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha1_cbc_aes = {
 	.type = SAFEXCEL_ALG_TYPE_AEAD,
 	.alg.aead = {
 		.setkey = safexcel_aead_setkey,
-		.encrypt = safexcel_aead_encrypt_aes,
-		.decrypt = safexcel_aead_decrypt_aes,
+		.encrypt = safexcel_aead_encrypt,
+		.decrypt = safexcel_aead_decrypt,
 		.ivsize = AES_BLOCK_SIZE,
 		.maxauthsize = SHA1_DIGEST_SIZE,
 		.base = {
@@ -1458,8 +1438,8 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha256_cbc_aes = {
 	.type = SAFEXCEL_ALG_TYPE_AEAD,
 	.alg.aead = {
 		.setkey = safexcel_aead_setkey,
-		.encrypt = safexcel_aead_encrypt_aes,
-		.decrypt = safexcel_aead_decrypt_aes,
+		.encrypt = safexcel_aead_encrypt,
+		.decrypt = safexcel_aead_decrypt,
 		.ivsize = AES_BLOCK_SIZE,
 		.maxauthsize = SHA256_DIGEST_SIZE,
 		.base = {
@@ -1492,8 +1472,8 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha224_cbc_aes = {
 	.type = SAFEXCEL_ALG_TYPE_AEAD,
 	.alg.aead = {
 		.setkey = safexcel_aead_setkey,
-		.encrypt = safexcel_aead_encrypt_aes,
-		.decrypt = safexcel_aead_decrypt_aes,
+		.encrypt = safexcel_aead_encrypt,
+		.decrypt = safexcel_aead_decrypt,
 		.ivsize = AES_BLOCK_SIZE,
 		.maxauthsize = SHA224_DIGEST_SIZE,
 		.base = {
@@ -1526,8 +1506,8 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha512_cbc_aes = {
 	.type = SAFEXCEL_ALG_TYPE_AEAD,
 	.alg.aead = {
 		.setkey = safexcel_aead_setkey,
-		.encrypt = safexcel_aead_encrypt_aes,
-		.decrypt = safexcel_aead_decrypt_aes,
+		.encrypt = safexcel_aead_encrypt,
+		.decrypt = safexcel_aead_decrypt,
 		.ivsize = AES_BLOCK_SIZE,
 		.maxauthsize = SHA512_DIGEST_SIZE,
 		.base = {
@@ -1560,8 +1540,8 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha384_cbc_aes = {
 	.type = SAFEXCEL_ALG_TYPE_AEAD,
 	.alg.aead = {
 		.setkey = safexcel_aead_setkey,
-		.encrypt = safexcel_aead_encrypt_aes,
-		.decrypt = safexcel_aead_decrypt_aes,
+		.encrypt = safexcel_aead_encrypt,
+		.decrypt = safexcel_aead_decrypt,
 		.ivsize = AES_BLOCK_SIZE,
 		.maxauthsize = SHA384_DIGEST_SIZE,
 		.base = {
@@ -1589,28 +1569,12 @@ static int safexcel_aead_sha1_des3_cra_init(struct crypto_tfm *tfm)
 	return 0;
 }
 
-static int safexcel_aead_encrypt_3des(struct aead_request *req)
-{
-	struct safexcel_cipher_req *creq = aead_request_ctx(req);
-
-	return safexcel_queue_req(&req->base, creq, SAFEXCEL_ENCRYPT,
-			CONTEXT_CONTROL_CRYPTO_MODE_CBC, SAFEXCEL_3DES);
-}
-
-static int safexcel_aead_decrypt_3des(struct aead_request *req)
-{
-	struct safexcel_cipher_req *creq = aead_request_ctx(req);
-
-	return safexcel_queue_req(&req->base, creq, SAFEXCEL_DECRYPT,
-			CONTEXT_CONTROL_CRYPTO_MODE_CBC, SAFEXCEL_3DES);
-}
-
 struct safexcel_alg_template safexcel_alg_authenc_hmac_sha1_cbc_des3_ede = {
 	.type = SAFEXCEL_ALG_TYPE_AEAD,
 	.alg.aead = {
 		.setkey = safexcel_aead_setkey,
-		.encrypt = safexcel_aead_encrypt_3des,
-		.decrypt = safexcel_aead_decrypt_3des,
+		.encrypt = safexcel_aead_encrypt,
+		.decrypt = safexcel_aead_decrypt,
 		.ivsize = DES3_EDE_BLOCK_SIZE,
 		.maxauthsize = SHA1_DIGEST_SIZE,
 		.base = {
@@ -1642,8 +1606,8 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha1_ctr_aes = {
 	.type = SAFEXCEL_ALG_TYPE_AEAD,
 	.alg.aead = {
 		.setkey = safexcel_aead_setkey,
-		.encrypt = safexcel_aead_encrypt_aes,
-		.decrypt = safexcel_aead_decrypt_aes,
+		.encrypt = safexcel_aead_encrypt,
+		.decrypt = safexcel_aead_decrypt,
 		.ivsize = CTR_RFC3686_IV_SIZE,
 		.maxauthsize = SHA1_DIGEST_SIZE,
 		.base = {
@@ -1675,8 +1639,8 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha256_ctr_aes = {
 	.type = SAFEXCEL_ALG_TYPE_AEAD,
 	.alg.aead = {
 		.setkey = safexcel_aead_setkey,
-		.encrypt = safexcel_aead_encrypt_aes,
-		.decrypt = safexcel_aead_decrypt_aes,
+		.encrypt = safexcel_aead_encrypt,
+		.decrypt = safexcel_aead_decrypt,
 		.ivsize = CTR_RFC3686_IV_SIZE,
 		.maxauthsize = SHA256_DIGEST_SIZE,
 		.base = {
@@ -1708,8 +1672,8 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha224_ctr_aes = {
 	.type = SAFEXCEL_ALG_TYPE_AEAD,
 	.alg.aead = {
 		.setkey = safexcel_aead_setkey,
-		.encrypt = safexcel_aead_encrypt_aes,
-		.decrypt = safexcel_aead_decrypt_aes,
+		.encrypt = safexcel_aead_encrypt,
+		.decrypt = safexcel_aead_decrypt,
 		.ivsize = CTR_RFC3686_IV_SIZE,
 		.maxauthsize = SHA224_DIGEST_SIZE,
 		.base = {
@@ -1741,8 +1705,8 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha512_ctr_aes = {
 	.type = SAFEXCEL_ALG_TYPE_AEAD,
 	.alg.aead = {
 		.setkey = safexcel_aead_setkey,
-		.encrypt = safexcel_aead_encrypt_aes,
-		.decrypt = safexcel_aead_decrypt_aes,
+		.encrypt = safexcel_aead_encrypt,
+		.decrypt = safexcel_aead_decrypt,
 		.ivsize = CTR_RFC3686_IV_SIZE,
 		.maxauthsize = SHA512_DIGEST_SIZE,
 		.base = {
@@ -1774,8 +1738,8 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha384_ctr_aes = {
 	.type = SAFEXCEL_ALG_TYPE_AEAD,
 	.alg.aead = {
 		.setkey = safexcel_aead_setkey,
-		.encrypt = safexcel_aead_encrypt_aes,
-		.decrypt = safexcel_aead_decrypt_aes,
+		.encrypt = safexcel_aead_encrypt,
+		.decrypt = safexcel_aead_decrypt,
 		.ivsize = CTR_RFC3686_IV_SIZE,
 		.maxauthsize = SHA384_DIGEST_SIZE,
 		.base = {
-- 
1.8.3.1

