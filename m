Return-Path: <SRS0=VSoq=W2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCBB0C3A5A7
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Aug 2019 08:43:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98771238C5
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Aug 2019 08:43:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qQKKMmtu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727562AbfH3Inv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 30 Aug 2019 04:43:51 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:39677 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728249AbfH3Inn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Aug 2019 04:43:43 -0400
Received: by mail-ed1-f68.google.com with SMTP id u6so1247407edq.6
        for <linux-crypto@vger.kernel.org>; Fri, 30 Aug 2019 01:43:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=xnabEG+6PqI9eSXmaPTSowveDHp4sRQ+Nh6n/D4wGVs=;
        b=qQKKMmtuSjrEEYA5aHXyRLDgk4Z/k7QGkXv/2GSCmM6xGQ+2joEubnfiLQTRWHQZgQ
         2JIRA8I5/iwKDz2R5TjZA1cXGEf6isDdCX5o70QvKhsg/cP2S9VxU3ElrHamUNotjZNA
         RvUa4jxrHTUkhzApUzrJw6WFzMEBMRGMb+3zeEdRo4jOL4Ho2TpBi5/cUqo64oVKtvwl
         B6BBzLLldiQ9fMPSoXotrCHRPl/d77WkTrM8YRe0sLZWkExI1oq8JlXFDcfVXXLf6ImX
         PJZ1B9Lkxf5+E5r3vBIbUmWj4L+ReKWcDu840gg5DS0Gosbv4eccNOoHtO1pmtbfO5lx
         33pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=xnabEG+6PqI9eSXmaPTSowveDHp4sRQ+Nh6n/D4wGVs=;
        b=sCoPndYJ0mRubCUqBynPGAmZdGocDWOLHgRQc1k90DQb3NUmPGcSGcObJZc4QmqAIq
         e3G80N33pcPOGzdnNefRQVeEeDL8kWHolOFEc+edxa0p4y/+LVXBgEYo5Gvy7v9JxFZH
         0Iox53CbR9eSMhO4CJBu0E3YO1PQd+okgX1F5cME6/gyJPGX1GmFAshIkeQMJkTBsOZk
         a7Bq4Zx2BlR46vGfTWpa9c22LM8sbxwl6R8YsJsxPMGNk58Kr0wuBmGrJ6LyjyH1K//V
         wcTrY66MeWINBAN41KjxMLSmt/GOWxNIupbTPRVM+XX2RIAry5alLAETjHerMBH41SOa
         Swsg==
X-Gm-Message-State: APjAAAVWSL9RGVqupE6ME3rEmwc1si1Xj+0GtS+QF06DEXQQJbbIVImV
        EOamfREczh6E0xZR8QP3hAP/MYj1
X-Google-Smtp-Source: APXvYqxv4keumwXfOXYgnjKeeGC8Hbm3hkazr7DKv3+QhJJlXlhdzeeiZjrjnQvjcQtfx1xr1Bva7w==
X-Received: by 2002:a50:e718:: with SMTP id a24mr14596623edn.260.1567154621088;
        Fri, 30 Aug 2019 01:43:41 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id x11sm705823eju.26.2019.08.30.01.43.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Aug 2019 01:43:40 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH 2/3] crypto: inside-secure - Add support for the AES-XTS algorithm
Date:   Fri, 30 Aug 2019 09:40:53 +0200
Message-Id: <1567150854-10589-3-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1567150854-10589-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1567150854-10589-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds support for the AES-XTS skcipher algorithm.

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel.c        |   1 +
 drivers/crypto/inside-secure/safexcel.h        |   2 +
 drivers/crypto/inside-secure/safexcel_cipher.c | 124 ++++++++++++++++++++++++-
 3 files changed, 123 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index e12a2a3..9941861 100644
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
index 33e5f66..0a30a7b 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -334,6 +334,7 @@ struct safexcel_context_record {
 #define CONTEXT_CONTROL_CRYPTO_MODE_ECB		(0 << 0)
 #define CONTEXT_CONTROL_CRYPTO_MODE_CBC		(1 << 0)
 #define CONTEXT_CONTROL_CRYPTO_MODE_CTR_LOAD	(6 << 0)
+#define CONTEXT_CONTROL_CRYPTO_MODE_XTS		(7 << 0)
 #define CONTEXT_CONTROL_IV0			BIT(5)
 #define CONTEXT_CONTROL_IV1			BIT(6)
 #define CONTEXT_CONTROL_IV2			BIT(7)
@@ -750,5 +751,6 @@ int safexcel_hmac_setkey(const char *alg, const u8 *key, unsigned int keylen,
 extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha256_ctr_aes;
 extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha384_ctr_aes;
 extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha512_ctr_aes;
+extern struct safexcel_alg_template safexcel_alg_xts_aes;
 
 #endif
diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index 8987d35..5ab0ee0 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -15,6 +15,7 @@
 #include <crypto/ctr.h>
 #include <crypto/des.h>
 #include <crypto/sha.h>
+#include <crypto/xts.h>
 #include <crypto/skcipher.h>
 #include <crypto/internal/aead.h>
 #include <crypto/internal/skcipher.h>
@@ -40,9 +41,9 @@ struct safexcel_cipher_ctx {
 	enum safexcel_cipher_alg alg;
 	bool aead;
 
-	__le32 key[8];
+	__le32 key[16];
 	u32 nonce;
-	unsigned int key_len;
+	unsigned int key_len, xts;
 
 	/* All the below is AEAD specific */
 	u32 hash_alg;
@@ -357,7 +358,7 @@ static int safexcel_context_control(struct safexcel_cipher_ctx *ctx,
 	} else if (ctx->alg == SAFEXCEL_3DES) {
 		cdesc->control_data.control0 |= CONTEXT_CONTROL_CRYPTO_ALG_3DES;
 	} else if (ctx->alg == SAFEXCEL_AES) {
-		switch (ctx->key_len) {
+		switch (ctx->key_len >> ctx->xts) {
 		case AES_KEYSIZE_128:
 			cdesc->control_data.control0 |= CONTEXT_CONTROL_CRYPTO_ALG_AES128;
 			break;
@@ -369,7 +370,7 @@ static int safexcel_context_control(struct safexcel_cipher_ctx *ctx,
 			break;
 		default:
 			dev_err(priv->dev, "aes keysize not supported: %u\n",
-				ctx->key_len);
+				ctx->key_len >> ctx->xts);
 			return -EINVAL;
 		}
 	}
@@ -1757,3 +1758,118 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha384_ctr_aes = {
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
+	/* Check for illegal XTS keys */
+	ret = xts_verify_key(ctfm, key, len);
+	if (ret)
+		return ret;
+
+	/* Only half of the key data is cipher key */
+	keylen = (len >> 1);
+	ret = aes_expandkey(&aes, key, keylen);
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
+	ret = aes_expandkey(&aes, (u8 *)(key + keylen), keylen);
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
+static int safexcel_encrypt_xts(struct skcipher_request *req)
+{
+	if (req->cryptlen < XTS_BLOCK_SIZE)
+		return -EINVAL;
+	return safexcel_queue_req(&req->base, skcipher_request_ctx(req),
+				  SAFEXCEL_ENCRYPT);
+}
+
+static int safexcel_decrypt_xts(struct skcipher_request *req)
+{
+	if (req->cryptlen < XTS_BLOCK_SIZE)
+		return -EINVAL;
+	return safexcel_queue_req(&req->base, skcipher_request_ctx(req),
+				  SAFEXCEL_DECRYPT);
+}
+
+struct safexcel_alg_template safexcel_alg_xts_aes = {
+	.type = SAFEXCEL_ALG_TYPE_SKCIPHER,
+	.alg.skcipher = {
+		.setkey = safexcel_skcipher_aesxts_setkey,
+		.encrypt = safexcel_encrypt_xts,
+		.decrypt = safexcel_decrypt_xts,
+		/* XTS actually uses 2 AES keys glued together */
+		.min_keysize = AES_MIN_KEY_SIZE * 2,
+		.max_keysize = AES_MAX_KEY_SIZE * 2,
+		.ivsize = XTS_BLOCK_SIZE,
+		.base = {
+			.cra_name = "xts(aes)",
+			.cra_driver_name = "safexcel-xts-aes",
+			.cra_priority = 300,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_blocksize = XTS_BLOCK_SIZE,
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

