Return-Path: <SRS0=vORM=XI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07CC3C4CEC5
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 15:06:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C9ECA20830
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 15:06:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DedgKSAm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390886AbfIMPGT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Sep 2019 11:06:19 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:34921 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390884AbfIMPGT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Sep 2019 11:06:19 -0400
Received: by mail-ed1-f65.google.com with SMTP id f24so9727357edv.2
        for <linux-crypto@vger.kernel.org>; Fri, 13 Sep 2019 08:06:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=cVUwAljGiZksQubTUeS6DFZTcWZ4ZZEez2CiuBcwBaA=;
        b=DedgKSAmI0J55klWRpgwLMsFgjwrj208u3VzRw2HNnYgmSVYc1lxVRJJ/q32wdXxem
         DXc0y87G4SsoAIptsjpqZ1PAJaiTt/biheyTN1S6RWXXy64b07rc3o8wr/2ofWNlGhfO
         rswkBA70cZ6j6KwQE7FNH/jR2VMaGWMVUmu2Ua9w9fnwJ60X/4/DzWbWJKU3lzVfRb+t
         +EueD22OZvo/mC4LYh8Aoz7mJ1aYPwGH+z6mGYgbfga3P0plsndO7L+EfrTx9OVwoaj8
         OEFu7g/LiH3GvksFhFL3pwLSIg7OIa/WzDVBTPE0F+q+7HPPt+qzuT5XTM4lvc8O4uRI
         xxTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=cVUwAljGiZksQubTUeS6DFZTcWZ4ZZEez2CiuBcwBaA=;
        b=JRSt3jhBtW8+6EgR47YXuns6C9/ac9fb6IJ76iBg4Ki0FpcnGUibSueGmpQu6xme+P
         zsJIfCrc9I1kI3eylEU7yWq+WkUmqhW+13YsKDuTYtSCOllNlg9Otx1tqffODjWb5ZrO
         QcMyHHbTp8ELOjCnzrsFoTX5yxorSotYl2V6TG78/rCrGfG+EddkIT9FiaDjS3VnZbFw
         b9f08pSptvVtwnDJGTpBXK3necp9TxTu/Sbg5SQ8RfM/SfT3z53YMXmtfGyOxgFCvOzn
         sMLydEdGHQv0+J+YTdk7wtrTu3PqtTefFRuuB96S7l6XSKC21fqTCtsv394Bkin1BwfH
         F8sA==
X-Gm-Message-State: APjAAAXvT9DNzQzq8377wYlgRr/jkm4licZRaLYuZiFhoYyogffmC3Mq
        V7RBwYBbUqpyWBphfMzHacf7QCjP
X-Google-Smtp-Source: APXvYqx/jcErt35LWBZA7VT6OKVgfUVnBmAudmtLoktmvfX6DJY+vtlChm/N6eQgtkWXct3TOGUk9A==
X-Received: by 2002:a17:906:9716:: with SMTP id k22mr39811130ejx.284.1568387176293;
        Fri, 13 Sep 2019 08:06:16 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id ly10sm3206654ejb.59.2019.09.13.08.06.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Sep 2019 08:06:15 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH 3/3] crypto: inside-secure - Added support for authenc HMAC-SHA2/DES-CBC
Date:   Fri, 13 Sep 2019 16:03:26 +0200
Message-Id: <1568383406-8009-4-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568383406-8009-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1568383406-8009-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds support for the authenc(hmac(sha224),cbc(des)),
authenc(hmac(sha256),cbc(des)), authenc(hmac(sha384),cbc(des))
and authenc(hmac(sha512),cbc(des)) aead's

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel.c        |   4 +
 drivers/crypto/inside-secure/safexcel.h        |   4 +
 drivers/crypto/inside-secure/safexcel_cipher.c | 136 +++++++++++++++++++++++++
 3 files changed, 144 insertions(+)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 4222ffa..1e05b5f 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -1200,6 +1200,10 @@ static int safexcel_request_ring_irq(void *pdev, int irqid,
 	&safexcel_alg_authenc_hmac_sha224_cbc_des3_ede,
 	&safexcel_alg_authenc_hmac_sha512_cbc_des3_ede,
 	&safexcel_alg_authenc_hmac_sha384_cbc_des3_ede,
+	&safexcel_alg_authenc_hmac_sha256_cbc_des,
+	&safexcel_alg_authenc_hmac_sha224_cbc_des,
+	&safexcel_alg_authenc_hmac_sha512_cbc_des,
+	&safexcel_alg_authenc_hmac_sha384_cbc_des,
 };
 
 static int safexcel_register_algorithms(struct safexcel_crypto_priv *priv)
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index fd6798f..fc16d5a 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -900,5 +900,9 @@ int safexcel_hmac_setkey(const char *alg, const u8 *key, unsigned int keylen,
 extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha224_cbc_des3_ede;
 extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha512_cbc_des3_ede;
 extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha384_cbc_des3_ede;
+extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha256_cbc_des;
+extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha224_cbc_des;
+extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha512_cbc_des;
+extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha384_cbc_des;
 
 #endif
diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index 0d26bea..71233ff 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -2035,6 +2035,142 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha1_cbc_des = {
 	},
 };
 
+static int safexcel_aead_sha256_des_cra_init(struct crypto_tfm *tfm)
+{
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	safexcel_aead_sha256_cra_init(tfm);
+	ctx->alg = SAFEXCEL_DES; /* override default */
+	return 0;
+}
+
+struct safexcel_alg_template safexcel_alg_authenc_hmac_sha256_cbc_des = {
+	.type = SAFEXCEL_ALG_TYPE_AEAD,
+	.algo_mask = SAFEXCEL_ALG_DES | SAFEXCEL_ALG_SHA2_256,
+	.alg.aead = {
+		.setkey = safexcel_aead_setkey,
+		.encrypt = safexcel_aead_encrypt,
+		.decrypt = safexcel_aead_decrypt,
+		.ivsize = DES_BLOCK_SIZE,
+		.maxauthsize = SHA256_DIGEST_SIZE,
+		.base = {
+			.cra_name = "authenc(hmac(sha256),cbc(des))",
+			.cra_driver_name = "safexcel-authenc-hmac-sha256-cbc-des",
+			.cra_priority = SAFEXCEL_CRA_PRIORITY,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_blocksize = DES_BLOCK_SIZE,
+			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
+			.cra_alignmask = 0,
+			.cra_init = safexcel_aead_sha256_des_cra_init,
+			.cra_exit = safexcel_aead_cra_exit,
+			.cra_module = THIS_MODULE,
+		},
+	},
+};
+
+static int safexcel_aead_sha224_des_cra_init(struct crypto_tfm *tfm)
+{
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	safexcel_aead_sha224_cra_init(tfm);
+	ctx->alg = SAFEXCEL_DES; /* override default */
+	return 0;
+}
+
+struct safexcel_alg_template safexcel_alg_authenc_hmac_sha224_cbc_des = {
+	.type = SAFEXCEL_ALG_TYPE_AEAD,
+	.algo_mask = SAFEXCEL_ALG_DES | SAFEXCEL_ALG_SHA2_256,
+	.alg.aead = {
+		.setkey = safexcel_aead_setkey,
+		.encrypt = safexcel_aead_encrypt,
+		.decrypt = safexcel_aead_decrypt,
+		.ivsize = DES_BLOCK_SIZE,
+		.maxauthsize = SHA224_DIGEST_SIZE,
+		.base = {
+			.cra_name = "authenc(hmac(sha224),cbc(des))",
+			.cra_driver_name = "safexcel-authenc-hmac-sha224-cbc-des",
+			.cra_priority = SAFEXCEL_CRA_PRIORITY,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_blocksize = DES_BLOCK_SIZE,
+			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
+			.cra_alignmask = 0,
+			.cra_init = safexcel_aead_sha224_des_cra_init,
+			.cra_exit = safexcel_aead_cra_exit,
+			.cra_module = THIS_MODULE,
+		},
+	},
+};
+
+static int safexcel_aead_sha512_des_cra_init(struct crypto_tfm *tfm)
+{
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	safexcel_aead_sha512_cra_init(tfm);
+	ctx->alg = SAFEXCEL_DES; /* override default */
+	return 0;
+}
+
+struct safexcel_alg_template safexcel_alg_authenc_hmac_sha512_cbc_des = {
+	.type = SAFEXCEL_ALG_TYPE_AEAD,
+	.algo_mask = SAFEXCEL_ALG_DES | SAFEXCEL_ALG_SHA2_512,
+	.alg.aead = {
+		.setkey = safexcel_aead_setkey,
+		.encrypt = safexcel_aead_encrypt,
+		.decrypt = safexcel_aead_decrypt,
+		.ivsize = DES_BLOCK_SIZE,
+		.maxauthsize = SHA512_DIGEST_SIZE,
+		.base = {
+			.cra_name = "authenc(hmac(sha512),cbc(des))",
+			.cra_driver_name = "safexcel-authenc-hmac-sha512-cbc-des",
+			.cra_priority = SAFEXCEL_CRA_PRIORITY,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_blocksize = DES_BLOCK_SIZE,
+			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
+			.cra_alignmask = 0,
+			.cra_init = safexcel_aead_sha512_des_cra_init,
+			.cra_exit = safexcel_aead_cra_exit,
+			.cra_module = THIS_MODULE,
+		},
+	},
+};
+
+static int safexcel_aead_sha384_des_cra_init(struct crypto_tfm *tfm)
+{
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	safexcel_aead_sha384_cra_init(tfm);
+	ctx->alg = SAFEXCEL_DES; /* override default */
+	return 0;
+}
+
+struct safexcel_alg_template safexcel_alg_authenc_hmac_sha384_cbc_des = {
+	.type = SAFEXCEL_ALG_TYPE_AEAD,
+	.algo_mask = SAFEXCEL_ALG_DES | SAFEXCEL_ALG_SHA2_512,
+	.alg.aead = {
+		.setkey = safexcel_aead_setkey,
+		.encrypt = safexcel_aead_encrypt,
+		.decrypt = safexcel_aead_decrypt,
+		.ivsize = DES_BLOCK_SIZE,
+		.maxauthsize = SHA384_DIGEST_SIZE,
+		.base = {
+			.cra_name = "authenc(hmac(sha384),cbc(des))",
+			.cra_driver_name = "safexcel-authenc-hmac-sha384-cbc-des",
+			.cra_priority = SAFEXCEL_CRA_PRIORITY,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_blocksize = DES_BLOCK_SIZE,
+			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
+			.cra_alignmask = 0,
+			.cra_init = safexcel_aead_sha384_des_cra_init,
+			.cra_exit = safexcel_aead_cra_exit,
+			.cra_module = THIS_MODULE,
+		},
+	},
+};
+
 static int safexcel_aead_sha1_ctr_cra_init(struct crypto_tfm *tfm)
 {
 	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
-- 
1.8.3.1

