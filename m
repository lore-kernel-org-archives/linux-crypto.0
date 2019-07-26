Return-Path: <SRS0=5D8e=VX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62EEFC76191
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 16:03:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2585B21852
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 16:03:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ctXxeKlV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726000AbfGZQDG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Jul 2019 12:03:06 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:37382 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726890AbfGZQDF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jul 2019 12:03:05 -0400
Received: by mail-ed1-f66.google.com with SMTP id w13so53752133eds.4
        for <linux-crypto@vger.kernel.org>; Fri, 26 Jul 2019 09:03:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=lTGQBb2+w/nzz7hxvTyHPbYij5S4466C2wYt6zTmkYs=;
        b=ctXxeKlVsyc30m65OXGlTS8WVJ+egWMEc6jxMujsPTyU0Gmc8ohQdx97TRRfvU1bTL
         60XdZy4WrXGAOKb2Mo++mo5ijkzgj4WY2X6Z9fwakZhLi4yvlRkFMsom+HuaDPXQJLZ6
         nhoDgadBs0mK3QM2mYci8F02WBir75Nn6gAXZGw2JNZQY/hqjzZNGJbygqQcJc9DkL7I
         UGAHHV2UJiu3j2ZJg7yxejqHyRvEm1vq7d1addP0gz1dU1WZEYtXkZgNs0p8aB8wtzIi
         oRYDFg986kcWJqH+QfKQquLHKq7QcZKS9Ih/JrzNIdIUwi91tu02qUXzAVgkRUo0MXyy
         TEnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=lTGQBb2+w/nzz7hxvTyHPbYij5S4466C2wYt6zTmkYs=;
        b=CmuAOSkPXsXcoInoMDhTxEj/TCqYG87QuyhNE8LyQOsan8qMwJ7fsA4GXqm4JMrdrD
         moXcrQrIuZiulJXTgOiTLbMsMXZiydkLCb2uIukxCgXLodaxhFKv8OcGFBpcNAeR0+Tj
         xK/xxqxpOmHVmm61Lj2mSF6gFcsiEGJAY0CLO8/IXdbf5mCK6uakkYzXONAYKalXP1Uq
         6OiYj4MoPR4CiSTxL8zkWGt9okvsh0U07hZ1KczF21FFgh9xWkkzn5odDl/mzXeQ4col
         tR1BQro5/FcmrNVpf/8v2LUpfMDd6xecOhHvJMV3jiBUAguKdwikCwQrdDWEqt5D/AVM
         CFBQ==
X-Gm-Message-State: APjAAAUvFhep4Q2rR3H/Tn7S6keCUuS5Cn4rRIjeWSPwhXbrnrV8wgw9
        MYUrBL1wdDah/IUy4yw7iBAlctfx
X-Google-Smtp-Source: APXvYqxvVrRoSy7KkeQYfelLcuQW4rkLlzuZjMDgZ3WTx1/VmX4hh1fGaCkba2RydhfNPqWqnrzzPg==
X-Received: by 2002:a50:987a:: with SMTP id h55mr84720210edb.108.1564156982732;
        Fri, 26 Jul 2019 09:03:02 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id y9sm13780258eds.15.2019.07.26.09.03.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jul 2019 09:03:02 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH 1/2] crypto: inside-secure - Move static cipher alg & mode settings to init
Date:   Fri, 26 Jul 2019 17:00:32 +0200
Message-Id: <1564153233-29390-2-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1564153233-29390-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1564153233-29390-1-git-send-email-pvanleeuwen@verimatrix.com>
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
index 80c7e5c..45b83a3 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -916,8 +916,7 @@ static int safexcel_aead_exit_inv(struct crypto_tfm *tfm)

 static int safexcel_queue_req(struct crypto_async_request *base,
 			struct safexcel_cipher_req *sreq,
-			enum safexcel_cipher_direction dir, u32 mode,
-			enum safexcel_cipher_alg alg)
+			enum safexcel_cipher_direction dir)
 {
 	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(base->tfm);
 	struct safexcel_crypto_priv *priv = ctx->priv;
@@ -925,8 +924,6 @@ static int safexcel_queue_req(struct crypto_async_request *base,

 	sreq->needs_inv = false;
 	sreq->direction = dir;
-	ctx->alg = alg;
-	ctx->mode = mode;

 	if (ctx->base.ctxr) {
 		if (priv->flags & EIP197_TRC_CACHE && ctx->base.needs_inv) {
@@ -954,18 +951,16 @@ static int safexcel_queue_req(struct crypto_async_request *base,
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
@@ -1039,12 +1034,22 @@ static void safexcel_aead_cra_exit(struct crypto_tfm *tfm)
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
@@ -1056,33 +1061,29 @@ struct safexcel_alg_template safexcel_alg_ecb_aes = {
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
@@ -1095,27 +1096,13 @@ struct safexcel_alg_template safexcel_alg_cbc_aes = {
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
@@ -1154,12 +1141,22 @@ static int safexcel_skcipher_aesctr_setkey(struct crypto_skcipher *ctfm,
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
 		/* Add 4 to include the 4 byte nonce! */
 		.min_keysize = AES_MIN_KEY_SIZE + 4,
 		.max_keysize = AES_MAX_KEY_SIZE + 4,
@@ -1173,27 +1170,13 @@ struct safexcel_alg_template safexcel_alg_ctr_aes = {
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
@@ -1224,12 +1207,22 @@ static int safexcel_des_setkey(struct crypto_skcipher *ctfm, const u8 *key,
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
@@ -1242,33 +1235,29 @@ struct safexcel_alg_template safexcel_alg_cbc_des = {
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
@@ -1280,27 +1269,13 @@ struct safexcel_alg_template safexcel_alg_ecb_des = {
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
@@ -1324,12 +1299,22 @@ static int safexcel_des3_ede_setkey(struct crypto_skcipher *ctfm,
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
@@ -1342,33 +1327,29 @@ struct safexcel_alg_template safexcel_alg_cbc_des3_ede = {
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
@@ -1380,27 +1361,25 @@ struct safexcel_alg_template safexcel_alg_ecb_des3_ede = {
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
@@ -1416,6 +1395,7 @@ static int safexcel_aead_cra_init(struct crypto_tfm *tfm)
 	ctx->priv = tmpl->priv;

 	ctx->alg  = SAFEXCEL_AES; /* default */
+	ctx->mode = CONTEXT_CONTROL_CRYPTO_MODE_CBC; /* default */
 	ctx->aead = true;
 	ctx->base.send = safexcel_aead_send;
 	ctx->base.handle_result = safexcel_aead_handle_result;
@@ -1436,8 +1416,8 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha1_cbc_aes = {
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
@@ -1470,8 +1450,8 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha256_cbc_aes = {
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
@@ -1504,8 +1484,8 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha224_cbc_aes = {
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
@@ -1538,8 +1518,8 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha512_cbc_aes = {
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
@@ -1572,8 +1552,8 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha384_cbc_aes = {
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
@@ -1601,28 +1581,12 @@ static int safexcel_aead_sha1_des3_cra_init(struct crypto_tfm *tfm)
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
@@ -1654,8 +1618,8 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha1_ctr_aes = {
 	.type = SAFEXCEL_ALG_TYPE_AEAD,
 	.alg.aead = {
 		.setkey = safexcel_aead_setkey,
-		.encrypt = safexcel_aead_encrypt_aes,
-		.decrypt = safexcel_aead_decrypt_aes,
+		.encrypt = safexcel_aead_encrypt,
+		.decrypt = safexcel_aead_decrypt,
 		.ivsize = 8,
 		.maxauthsize = SHA1_DIGEST_SIZE,
 		.base = {
@@ -1687,8 +1651,8 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha256_ctr_aes = {
 	.type = SAFEXCEL_ALG_TYPE_AEAD,
 	.alg.aead = {
 		.setkey = safexcel_aead_setkey,
-		.encrypt = safexcel_aead_encrypt_aes,
-		.decrypt = safexcel_aead_decrypt_aes,
+		.encrypt = safexcel_aead_encrypt,
+		.decrypt = safexcel_aead_decrypt,
 		.ivsize = 8,
 		.maxauthsize = SHA256_DIGEST_SIZE,
 		.base = {
@@ -1720,8 +1684,8 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha224_ctr_aes = {
 	.type = SAFEXCEL_ALG_TYPE_AEAD,
 	.alg.aead = {
 		.setkey = safexcel_aead_setkey,
-		.encrypt = safexcel_aead_encrypt_aes,
-		.decrypt = safexcel_aead_decrypt_aes,
+		.encrypt = safexcel_aead_encrypt,
+		.decrypt = safexcel_aead_decrypt,
 		.ivsize = 8,
 		.maxauthsize = SHA224_DIGEST_SIZE,
 		.base = {
@@ -1753,8 +1717,8 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha512_ctr_aes = {
 	.type = SAFEXCEL_ALG_TYPE_AEAD,
 	.alg.aead = {
 		.setkey = safexcel_aead_setkey,
-		.encrypt = safexcel_aead_encrypt_aes,
-		.decrypt = safexcel_aead_decrypt_aes,
+		.encrypt = safexcel_aead_encrypt,
+		.decrypt = safexcel_aead_decrypt,
 		.ivsize = 8,
 		.maxauthsize = SHA512_DIGEST_SIZE,
 		.base = {
@@ -1786,8 +1750,8 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha384_ctr_aes = {
 	.type = SAFEXCEL_ALG_TYPE_AEAD,
 	.alg.aead = {
 		.setkey = safexcel_aead_setkey,
-		.encrypt = safexcel_aead_encrypt_aes,
-		.decrypt = safexcel_aead_decrypt_aes,
+		.encrypt = safexcel_aead_encrypt,
+		.decrypt = safexcel_aead_decrypt,
 		.ivsize = 8,
 		.maxauthsize = SHA384_DIGEST_SIZE,
 		.base = {
--
1.8.3.1
