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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2044C49ED7
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 21:07:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6DF1D206BB
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 21:07:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P0n4cXQ9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387422AbfIMVHk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Sep 2019 17:07:40 -0400
Received: from mail-ed1-f48.google.com ([209.85.208.48]:44924 "EHLO
        mail-ed1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731020AbfIMVHk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Sep 2019 17:07:40 -0400
Received: by mail-ed1-f48.google.com with SMTP id p2so26963574edx.11
        for <linux-crypto@vger.kernel.org>; Fri, 13 Sep 2019 14:07:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4Glt5kdL/EFgnUcnVFFdrLZHQjKcEHayaQwmuT4AbDw=;
        b=P0n4cXQ924VnTUHpv3fDkZ0zRG2ad1LhL+g1PhYpvk8+Y0U/4QVS/k6nglzLVR09S6
         dmrVuzklZDtL+72qvx7kdeeHGxae/MwzKpjLgHmWsMpt/NFme03kdhK7V3GKK+zHBxLt
         51Y7GXHcHV08cZj0hz9brxAlD3QbeTFR/PUGP/B6c+7cXEqRwEAqyKjPrVtkPdQCYswk
         v+P/1PHiQedv51oIlIaariYFZdfebulB2Eq07aK1Jhjo0Ajv7MaUIm5xL3UrrdSNqO1w
         yi3s9tYyFp/iHGt3O9ssGsmZPX0wor1iUQ8aE2UoN3NwaIVuW6nOVULAc5KDan6Pte02
         YGEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=4Glt5kdL/EFgnUcnVFFdrLZHQjKcEHayaQwmuT4AbDw=;
        b=DEk6UeZOUF2RqDcyqQL8lhVJFbbGKhUqRAj6gJIOcONGGIdYbq6tOxEnuEEGUMHxyj
         d8SUzuoYRUn9fXdPpD4K0x4wNDSd6d5IT4gMOhO8oU1qYC6QAVwTjqyA1j+2NVULLzjo
         cH3pxRivem7v3XK2LroJY+Wh5hFNARwui8UPgtBIPoKqZVUrBfWlTg71orqfZK5Qg9NG
         Aew1QBOM3wXDml7R2oRyU7twytccC5PXQ36V9RUCQD/kVAjqfn06EeV+zXM2G4+L2GNo
         EQBpT6VfB4dRS6Rd5YYHfWFm8cYl2Qh1ZfhME/W7DuF/RlUd/zB0BBC9PEKiJY37imLh
         soXQ==
X-Gm-Message-State: APjAAAXNvOtdTZqszw+jgzEvRam9VmxrPY4bXcdTZQxnV2PvTGMk+NMN
        sprs82/uJWdrgLm1u6w1FHDqcQCO
X-Google-Smtp-Source: APXvYqyPrfQK4SaX/jrrA7ys0cL+ppBWqroTCqUVZRw629xZzEhOUg/23kd7Bp4akmFus5zclbBtOw==
X-Received: by 2002:a05:6402:1485:: with SMTP id e5mr50339395edv.191.1568408857623;
        Fri, 13 Sep 2019 14:07:37 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id e44sm1411296ede.34.2019.09.13.14.07.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Sep 2019 14:07:37 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCHv2 3/3] crypto: inside-secure - Added support for authenc HMAC-SHA2/DES-CBC
Date:   Fri, 13 Sep 2019 22:04:46 +0200
Message-Id: <1568405086-7898-4-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568405086-7898-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1568405086-7898-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds support for the authenc(hmac(sha224),cbc(des)),
authenc(hmac(sha256),cbc(des)), authenc(hmac(sha384),cbc(des))
and authenc(hmac(sha512),cbc(des)) aead's

changes since v1:
- nothing

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel.c        |   4 +
 drivers/crypto/inside-secure/safexcel.h        |   4 +
 drivers/crypto/inside-secure/safexcel_cipher.c | 136 +++++++++++++++++++++++++
 3 files changed, 144 insertions(+)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 36523dd..094b581 100644
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
index b1703e3..9522594 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -906,5 +906,9 @@ int safexcel_hmac_setkey(const char *alg, const u8 *key, unsigned int keylen,
 extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha224_cbc_des3_ede;
 extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha512_cbc_des3_ede;
 extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha384_cbc_des3_ede;
+extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha256_cbc_des;
+extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha224_cbc_des;
+extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha512_cbc_des;
+extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha384_cbc_des;
 
 #endif
diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index a80e4f2..9768db3 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -2016,6 +2016,142 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha1_cbc_des = {
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

