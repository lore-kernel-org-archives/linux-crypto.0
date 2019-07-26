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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0EE9C76194
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 16:03:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A88F521852
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 16:03:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qOB6Ip7Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbfGZQDG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Jul 2019 12:03:06 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:43195 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727025AbfGZQDG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jul 2019 12:03:06 -0400
Received: by mail-ed1-f65.google.com with SMTP id e3so53733208edr.10
        for <linux-crypto@vger.kernel.org>; Fri, 26 Jul 2019 09:03:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=NWF94khR4K+lzIhRbFdBUSbaFUVIY/Or7GKqM3qR0RI=;
        b=qOB6Ip7QK0RG8ebsUiUJWkuIFOLlNJBDMzE9Q/0OCjdz+QUbxojRAfBPg+jgvA7N2u
         qFua5imqNfF9xW4FQsXycgLca4DyaIPUJQ9RyuD8u3WZ9/CvLHaAnrGtiz7ZYve6Ae99
         5Y4yU0PVN2rYY/lP/9PjW76HeWqG5BOc3IJH99LqH2Nv4sYQDL80eXBS3zkKWP1fDJQu
         TDEuANcrllSHuGlSO6y7hc4prQpHdZuDdTWodIa73jGMPEJyj7YgmPTQ7AUZ6oSIQi9v
         2kbFMLUcLr3Ea67ihqZEOFbNXCNy7FRS49MbWVBUaOy6/MYm9aWvKFoE24z8ln81atOe
         xUkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=NWF94khR4K+lzIhRbFdBUSbaFUVIY/Or7GKqM3qR0RI=;
        b=qN9Yq9+0UtV2cdPoX0Fte18AGivyKt4EpMbJRckRohLmQxnXA2Vhw9yplEV7pSiZbh
         EaL8ihXdmmIMWUTaMWmwG8SrK8Bst1nXov2g0ibON+oKyLCie1X3zSB4DR92fBkbBRqm
         RgzgSzopE7RePw1R4mL7R4DBx7d44RxIyNNy18wUOGEU5AdF88fk7trMWfgCDMX0ruh9
         BgjRS0RgNLzCPzywepX+i+dMajYbFbrFhK67tt04ONTpivzR2gK2nAsopVdEkOOhVh9s
         8O2alNj7capZ1sqBorMjPXaE0JvN1/4SbtKflR/7ZxFdXv5s/126EH8tciSrbLH4Axmd
         YYCQ==
X-Gm-Message-State: APjAAAXTp8y6LIz7QNYrkHBVPUBOlF8wkaRMJgsWmJI75nCHoN54erq0
        cERcsesKePGpetYGCveZ//K/OXza
X-Google-Smtp-Source: APXvYqyEPj95qdPKw6virQ56oxa+MV4VFeZ/i8st0bQsK6VzqyErnAMKIi47oa9zdDsu+v2hc1L+nA==
X-Received: by 2002:a50:c081:: with SMTP id k1mr82636640edf.19.1564156983843;
        Fri, 26 Jul 2019 09:03:03 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id y9sm13780258eds.15.2019.07.26.09.03.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jul 2019 09:03:02 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH 2/2] crypto: inside-secure - Add support for the AES-XTS algorithm
Date:   Fri, 26 Jul 2019 17:00:33 +0200
Message-Id: <1564153233-29390-3-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1564153233-29390-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1564153233-29390-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds support for the AES-XTS skcipher algorithm.

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel.c        |   1 +
 drivers/crypto/inside-secure/safexcel.h        |   2 +
 drivers/crypto/inside-secure/safexcel_cipher.c | 102 ++++++++++++++++++++++++-
 3 files changed, 101 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index ca84119..45443bf 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -1004,6 +1004,7 @@ static int safexcel_request_ring_irq(void *pdev, int irqid,
 	&safexcel_alg_authenc_hmac_sha256_ctr_aes,
 	&safexcel_alg_authenc_hmac_sha384_ctr_aes,
 	&safexcel_alg_authenc_hmac_sha512_ctr_aes,
+	&safexcel_alg_xts_aes,
 };

 static int safexcel_register_algorithms(struct safexcel_crypto_priv *priv)
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index 6687ff9..dcc060c 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -329,6 +329,7 @@ struct safexcel_context_record {
 #define CONTEXT_CONTROL_CRYPTO_MODE_ECB		(0 << 0)
 #define CONTEXT_CONTROL_CRYPTO_MODE_CBC		(1 << 0)
 #define CONTEXT_CONTROL_CRYPTO_MODE_CTR_LOAD	(6 << 0)
+#define CONTEXT_CONTROL_CRYPTO_MODE_XTS		(7 << 0)
 #define CONTEXT_CONTROL_IV0			BIT(5)
 #define CONTEXT_CONTROL_IV1			BIT(6)
 #define CONTEXT_CONTROL_IV2			BIT(7)
@@ -744,5 +745,6 @@ int safexcel_hmac_setkey(const char *alg, const u8 *key, unsigned int keylen,
 extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha256_ctr_aes;
 extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha384_ctr_aes;
 extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha512_ctr_aes;
+extern struct safexcel_alg_template safexcel_alg_xts_aes;

 #endif
diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index 45b83a3..d65e5f7 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -39,9 +39,9 @@ struct safexcel_cipher_ctx {
 	enum safexcel_cipher_alg alg;
 	bool aead;

-	__le32 key[8];
+	__le32 key[16];
 	u32 nonce;
-	unsigned int key_len;
+	unsigned int key_len, xts;

 	/* All the below is AEAD specific */
 	u32 hash_alg;
@@ -368,7 +368,7 @@ static int safexcel_context_control(struct safexcel_cipher_ctx *ctx,
 	} else if (ctx->alg == SAFEXCEL_3DES) {
 		cdesc->control_data.control0 |= CONTEXT_CONTROL_CRYPTO_ALG_3DES;
 	} else if (ctx->alg == SAFEXCEL_AES) {
-		switch (ctx->key_len) {
+		switch (ctx->key_len >> ctx->xts) {
 		case AES_KEYSIZE_128:
 			cdesc->control_data.control0 |= CONTEXT_CONTROL_CRYPTO_ALG_AES128;
 			break;
@@ -380,7 +380,7 @@ static int safexcel_context_control(struct safexcel_cipher_ctx *ctx,
 			break;
 		default:
 			dev_err(priv->dev, "aes keysize not supported: %u\n",
-				ctx->key_len);
+				ctx->key_len >> ctx->xts);
 			return -EINVAL;
 		}
 	}
@@ -1769,3 +1769,97 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha384_ctr_aes = {
 		},
 	},
 };
+
+static int safexcel_skcipher_aesxts_setkey(struct crypto_skcipher *ctfm,
+					   const u8 *key, unsigned int len)
+{
+	struct crypto_tfm *tfm = crypto_skcipher_tfm(ctfm);
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct safexcel_crypto_priv *priv = ctx->priv;
+	struct crypto_aes_ctx aes;
+	int ret, i;
+	unsigned int keylen;
+
+	/* Only half of the key data is cipher key */
+	keylen = (len >> 1) + (len & 1);
+	ret = crypto_aes_expand_key(&aes, key, keylen);
+	if (ret) {
+		crypto_skcipher_set_flags(ctfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return ret;
+	}
+
+	if (priv->flags & EIP197_TRC_CACHE && ctx->base.ctxr_dma) {
+		for (i = 0; i < keylen / sizeof(u32); i++) {
+			if (ctx->key[i] != cpu_to_le32(aes.key_enc[i])) {
+				ctx->base.needs_inv = true;
+				break;
+			}
+		}
+	}
+
+	for (i = 0; i < keylen / sizeof(u32); i++)
+		ctx->key[i] = cpu_to_le32(aes.key_enc[i]);
+
+	/* The other half is the tweak key */
+	ret = crypto_aes_expand_key(&aes, (u8 *)(key + keylen), keylen);
+	if (ret) {
+		crypto_skcipher_set_flags(ctfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return ret;
+	}
+
+	if (priv->flags & EIP197_TRC_CACHE && ctx->base.ctxr_dma) {
+		for (i = 0; i < keylen / sizeof(u32); i++) {
+			if (ctx->key[i + keylen / sizeof(u32)] !=
+			    cpu_to_le32(aes.key_enc[i])) {
+				ctx->base.needs_inv = true;
+				break;
+			}
+		}
+	}
+
+	for (i = 0; i < keylen / sizeof(u32); i++)
+		ctx->key[i + keylen / sizeof(u32)] =
+			cpu_to_le32(aes.key_enc[i]);
+
+	ctx->key_len = keylen << 1;
+
+	memzero_explicit(&aes, sizeof(aes));
+	return 0;
+}
+
+static int safexcel_skcipher_aes_xts_cra_init(struct crypto_tfm *tfm)
+{
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	safexcel_skcipher_cra_init(tfm);
+	ctx->alg  = SAFEXCEL_AES;
+	ctx->xts  = 1;
+	ctx->mode = CONTEXT_CONTROL_CRYPTO_MODE_XTS;
+	return 0;
+}
+
+struct safexcel_alg_template safexcel_alg_xts_aes = {
+	.type = SAFEXCEL_ALG_TYPE_SKCIPHER,
+	.alg.skcipher = {
+		.setkey = safexcel_skcipher_aesxts_setkey,
+		.encrypt = safexcel_encrypt,
+		.decrypt = safexcel_decrypt,
+		/* Add 4 to include the 4 byte nonce! */
+		.min_keysize = AES_MIN_KEY_SIZE * 2,
+		.max_keysize = AES_MAX_KEY_SIZE * 2,
+		.ivsize = 16,
+		.base = {
+			.cra_name = "xts(aes)",
+			.cra_driver_name = "safexcel-xts-aes",
+			.cra_priority = 300,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_blocksize = 1,
+			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
+			.cra_alignmask = 0,
+			.cra_init = safexcel_skcipher_aes_xts_cra_init,
+			.cra_exit = safexcel_skcipher_cra_exit,
+			.cra_module = THIS_MODULE,
+		},
+	},
+};
--
1.8.3.1
