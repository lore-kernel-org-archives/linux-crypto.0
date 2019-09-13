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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98CA2C4CEC5
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 21:07:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66C8220830
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 21:07:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cg24KZew"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731154AbfIMVHk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Sep 2019 17:07:40 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:44698 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731110AbfIMVHj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Sep 2019 17:07:39 -0400
Received: by mail-ed1-f67.google.com with SMTP id p2so26963537edx.11
        for <linux-crypto@vger.kernel.org>; Fri, 13 Sep 2019 14:07:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=xx/hvQA7i9CvwqMbYOnLL/zTNy8rgTX2wzCAHVUWtu4=;
        b=cg24KZewgafbNasNmlVVsg1dvy0RkrOmXmxEPlMZe8EMLQpbYUDc9S9sQz5ZK7ravf
         WNONB113bo03709dqv9UoM//9gXvYaKd7pEUtPQtubWRTFRGbXJVxhI1E1ECqZEaNX1W
         OV9bDZEo1xUvQUl9Av/50IB9WKvqM4h1h/6QM0EdM9TEvpyWXMuGlcGpfzPZuf9k2iYL
         d3FuKpZn9Jr2r5FibgatQetyvajAF55ncbHtmq5gTTPK/dT5mLNaz/vSzVSMxk2DykDn
         hQLsoDMElJ1KFbbIYb6AeSUoONwV0v947MYorm8OzeBnOxZh+VG0LCUTmrdwNAvRUEAW
         eZMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=xx/hvQA7i9CvwqMbYOnLL/zTNy8rgTX2wzCAHVUWtu4=;
        b=Qsj5xmX5QWUrmqNjXVs3rA3fFZ+6K7A+BCbJrCVFD8wGbiNvhLCwQbvg08awp/24Zw
         +omCD+eB50pmuzi12Y4vAw1zUz6kAhH/eJxTDaVWOCRbp44rNlIjyYga2L7Mjc5B6/MW
         LaXluy0L+kUSJ2b2Ovtthh7GsNad6qPXZXIpGcpkRlC9/oDBgvYQtGrBgIYxeysUyVXT
         er9U3DvG4KX+pZeiR4jNO/93DHTMup6lxhYapKvRBBvq1byI6iQWIf2QKH92SvMEz/AM
         weIcILMerErFY4rU8HA8Tp2QSMyVN6UJ1+Z1j35+wS1SbCbocZI/v97P0c8Axo9OghY+
         YVuA==
X-Gm-Message-State: APjAAAWXjofSPpBJcjkmIVIKIVbm9JFnRQY6eVPMeiylLFOrE1UgXWd0
        K527CrDKyLAIfwVoTO1mSJGREJxm
X-Google-Smtp-Source: APXvYqw9bA4uw4qR3MDvrzV0XV/3ltYRnfYaN0hr56HagmliU6SZTyhUt29fnj32gXKWM+t9TkQ4ug==
X-Received: by 2002:a17:906:2f92:: with SMTP id w18mr23045269eji.33.1568408856851;
        Fri, 13 Sep 2019 14:07:36 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id e44sm1411296ede.34.2019.09.13.14.07.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Sep 2019 14:07:36 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH 2/3] crypto: inside-secure - Added support for authenc HMAC-SHA2/3DES-CBC
Date:   Fri, 13 Sep 2019 22:04:45 +0200
Message-Id: <1568405086-7898-3-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568405086-7898-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1568405086-7898-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds support for the authenc(hmac(sha224),cbc(des3_ede)),
authenc(hmac(sha256),cbc(des3_ede)), authenc(hmac(sha384),cbc(des3_ede))
and authenc(hmac(sha512),cbc(des3_ede)) aead's

changes since v1:
- nothing

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel.c        |   4 +
 drivers/crypto/inside-secure/safexcel.h        |   4 +
 drivers/crypto/inside-secure/safexcel_cipher.c | 136 +++++++++++++++++++++++++
 3 files changed, 144 insertions(+)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 462dbf6..36523dd 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -1196,6 +1196,10 @@ static int safexcel_request_ring_irq(void *pdev, int irqid,
 	&safexcel_alg_hmac_sha3_384,
 	&safexcel_alg_hmac_sha3_512,
 	&safexcel_alg_authenc_hmac_sha1_cbc_des,
+	&safexcel_alg_authenc_hmac_sha256_cbc_des3_ede,
+	&safexcel_alg_authenc_hmac_sha224_cbc_des3_ede,
+	&safexcel_alg_authenc_hmac_sha512_cbc_des3_ede,
+	&safexcel_alg_authenc_hmac_sha384_cbc_des3_ede,
 };
 
 static int safexcel_register_algorithms(struct safexcel_crypto_priv *priv)
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index fe00b87..b1703e3 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -902,5 +902,9 @@ int safexcel_hmac_setkey(const char *alg, const u8 *key, unsigned int keylen,
 extern struct safexcel_alg_template safexcel_alg_hmac_sha3_384;
 extern struct safexcel_alg_template safexcel_alg_hmac_sha3_512;
 extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha1_cbc_des;
+extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha256_cbc_des3_ede;
+extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha224_cbc_des3_ede;
+extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha512_cbc_des3_ede;
+extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha384_cbc_des3_ede;
 
 #endif
diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index 91cab26..a80e4f2 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -1846,6 +1846,142 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha1_cbc_des3_ede = {
 	},
 };
 
+static int safexcel_aead_sha256_des3_cra_init(struct crypto_tfm *tfm)
+{
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	safexcel_aead_sha256_cra_init(tfm);
+	ctx->alg = SAFEXCEL_3DES; /* override default */
+	return 0;
+}
+
+struct safexcel_alg_template safexcel_alg_authenc_hmac_sha256_cbc_des3_ede = {
+	.type = SAFEXCEL_ALG_TYPE_AEAD,
+	.algo_mask = SAFEXCEL_ALG_DES | SAFEXCEL_ALG_SHA2_256,
+	.alg.aead = {
+		.setkey = safexcel_aead_setkey,
+		.encrypt = safexcel_aead_encrypt,
+		.decrypt = safexcel_aead_decrypt,
+		.ivsize = DES3_EDE_BLOCK_SIZE,
+		.maxauthsize = SHA256_DIGEST_SIZE,
+		.base = {
+			.cra_name = "authenc(hmac(sha256),cbc(des3_ede))",
+			.cra_driver_name = "safexcel-authenc-hmac-sha256-cbc-des3_ede",
+			.cra_priority = SAFEXCEL_CRA_PRIORITY,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
+			.cra_alignmask = 0,
+			.cra_init = safexcel_aead_sha256_des3_cra_init,
+			.cra_exit = safexcel_aead_cra_exit,
+			.cra_module = THIS_MODULE,
+		},
+	},
+};
+
+static int safexcel_aead_sha224_des3_cra_init(struct crypto_tfm *tfm)
+{
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	safexcel_aead_sha224_cra_init(tfm);
+	ctx->alg = SAFEXCEL_3DES; /* override default */
+	return 0;
+}
+
+struct safexcel_alg_template safexcel_alg_authenc_hmac_sha224_cbc_des3_ede = {
+	.type = SAFEXCEL_ALG_TYPE_AEAD,
+	.algo_mask = SAFEXCEL_ALG_DES | SAFEXCEL_ALG_SHA2_256,
+	.alg.aead = {
+		.setkey = safexcel_aead_setkey,
+		.encrypt = safexcel_aead_encrypt,
+		.decrypt = safexcel_aead_decrypt,
+		.ivsize = DES3_EDE_BLOCK_SIZE,
+		.maxauthsize = SHA224_DIGEST_SIZE,
+		.base = {
+			.cra_name = "authenc(hmac(sha224),cbc(des3_ede))",
+			.cra_driver_name = "safexcel-authenc-hmac-sha224-cbc-des3_ede",
+			.cra_priority = SAFEXCEL_CRA_PRIORITY,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
+			.cra_alignmask = 0,
+			.cra_init = safexcel_aead_sha224_des3_cra_init,
+			.cra_exit = safexcel_aead_cra_exit,
+			.cra_module = THIS_MODULE,
+		},
+	},
+};
+
+static int safexcel_aead_sha512_des3_cra_init(struct crypto_tfm *tfm)
+{
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	safexcel_aead_sha512_cra_init(tfm);
+	ctx->alg = SAFEXCEL_3DES; /* override default */
+	return 0;
+}
+
+struct safexcel_alg_template safexcel_alg_authenc_hmac_sha512_cbc_des3_ede = {
+	.type = SAFEXCEL_ALG_TYPE_AEAD,
+	.algo_mask = SAFEXCEL_ALG_DES | SAFEXCEL_ALG_SHA2_512,
+	.alg.aead = {
+		.setkey = safexcel_aead_setkey,
+		.encrypt = safexcel_aead_encrypt,
+		.decrypt = safexcel_aead_decrypt,
+		.ivsize = DES3_EDE_BLOCK_SIZE,
+		.maxauthsize = SHA512_DIGEST_SIZE,
+		.base = {
+			.cra_name = "authenc(hmac(sha512),cbc(des3_ede))",
+			.cra_driver_name = "safexcel-authenc-hmac-sha512-cbc-des3_ede",
+			.cra_priority = SAFEXCEL_CRA_PRIORITY,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
+			.cra_alignmask = 0,
+			.cra_init = safexcel_aead_sha512_des3_cra_init,
+			.cra_exit = safexcel_aead_cra_exit,
+			.cra_module = THIS_MODULE,
+		},
+	},
+};
+
+static int safexcel_aead_sha384_des3_cra_init(struct crypto_tfm *tfm)
+{
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	safexcel_aead_sha384_cra_init(tfm);
+	ctx->alg = SAFEXCEL_3DES; /* override default */
+	return 0;
+}
+
+struct safexcel_alg_template safexcel_alg_authenc_hmac_sha384_cbc_des3_ede = {
+	.type = SAFEXCEL_ALG_TYPE_AEAD,
+	.algo_mask = SAFEXCEL_ALG_DES | SAFEXCEL_ALG_SHA2_512,
+	.alg.aead = {
+		.setkey = safexcel_aead_setkey,
+		.encrypt = safexcel_aead_encrypt,
+		.decrypt = safexcel_aead_decrypt,
+		.ivsize = DES3_EDE_BLOCK_SIZE,
+		.maxauthsize = SHA384_DIGEST_SIZE,
+		.base = {
+			.cra_name = "authenc(hmac(sha384),cbc(des3_ede))",
+			.cra_driver_name = "safexcel-authenc-hmac-sha384-cbc-des3_ede",
+			.cra_priority = SAFEXCEL_CRA_PRIORITY,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
+			.cra_alignmask = 0,
+			.cra_init = safexcel_aead_sha384_des3_cra_init,
+			.cra_exit = safexcel_aead_cra_exit,
+			.cra_module = THIS_MODULE,
+		},
+	},
+};
+
 static int safexcel_aead_sha1_des_cra_init(struct crypto_tfm *tfm)
 {
 	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
-- 
1.8.3.1

