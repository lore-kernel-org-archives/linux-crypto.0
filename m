Return-Path: <SRS0=aQ9n=XM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66068C4CECD
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Sep 2019 11:10:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A2BD214AF
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Sep 2019 11:10:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X5qH06wL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbfIQLKy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Sep 2019 07:10:54 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:37638 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbfIQLKy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Sep 2019 07:10:54 -0400
Received: by mail-ed1-f65.google.com with SMTP id r4so2943790edy.4
        for <linux-crypto@vger.kernel.org>; Tue, 17 Sep 2019 04:10:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3pV72v+HekKUSoOyILO4L2qwgl1bruaqxWxUTO5sFRM=;
        b=X5qH06wLjUF+XBmy0job3gNMX4bv+FNRQHAaPka2U3XAramDwgXedTNz2XgI9hOTP+
         PXmFWrkkstj3iY+bItf+Yw+hXy/wf8yuumbnRTlVTSlJNXoo2WP2WglaKg16dWukUv36
         Qn9/pIhOH4Z7bs/KefyreAkO6yiuuYEH0XgiWpgTC0Y5OOf2ENVmG6lcjlqtVU5phrUy
         6TAiz+q/SnakRTWWdcMevTNBzQsfYBhrmfP0igIE2ei993dVkqPm6tv57LJ2lQhywBeX
         MlD6zMeFsu8yLsptG0WjnlS0rTVj77FB+2dqGOY3KoxMJGQvPyeONdL6ibYpGBRqqWou
         fN+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3pV72v+HekKUSoOyILO4L2qwgl1bruaqxWxUTO5sFRM=;
        b=ZjhJv8j3uuVeVgWEwiTmE83MzAA1wLGWSAagAhYwNB1onfzbv6lGIZ3K2zItjimES+
         bZ1m6alHh5e2fe0VJTZVIotCi6Ebf50or3OcotzR1/2CRNkNYpeiX0PNXnR9fP1cGtm1
         t5ac0DCVm6T5L41/YyuxHlUQV9zCIACe40MrOSz98mN6bh123CNkQr90SlmHnKh1Rsbz
         0v2NzipAjLT/u8tuRm2RLqrJyxVBlQav+CSioPo0nLK6Ez3twfNz+e58JG8NhToOC/a8
         yRYTJ9X0mjffg328/LuK1gi3/lAgACCB3Gd+hMRwjspeDxSwPLh6HmNUyvDKysQDoV8V
         5KoA==
X-Gm-Message-State: APjAAAVyZ5WBhvtaMavDjxA7OHp1ildCwdRJYYoHCieAtAOGn3XRrJa6
        +RbNX1catIxgPazXZtwMd3M9i0aM
X-Google-Smtp-Source: APXvYqx4YlLvLkT/9CQgBSRrMgBxJi5ByKdQB8wsw9dg3GtvU2vcCBR205nFROM9f6Wqm052oeQMkw==
X-Received: by 2002:a50:baa5:: with SMTP id x34mr4154109ede.148.1568718651758;
        Tue, 17 Sep 2019 04:10:51 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id a50sm376204eda.25.2019.09.17.04.10.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Sep 2019 04:10:51 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH 1/3] crypto: inside-secure - Added support for the rfc4106(gcm(aes)) AEAD
Date:   Tue, 17 Sep 2019 12:07:59 +0200
Message-Id: <1568714881-30426-2-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568714881-30426-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1568714881-30426-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds support for rfc4106(gcm(aes)) for use with IPsec ESP

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel.c        |   1 +
 drivers/crypto/inside-secure/safexcel.h        |   1 +
 drivers/crypto/inside-secure/safexcel_cipher.c | 112 ++++++++++++++++++++-----
 3 files changed, 91 insertions(+), 23 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 094b581..1914124 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -1204,6 +1204,7 @@ static int safexcel_request_ring_irq(void *pdev, int irqid,
 	&safexcel_alg_authenc_hmac_sha224_cbc_des,
 	&safexcel_alg_authenc_hmac_sha512_cbc_des,
 	&safexcel_alg_authenc_hmac_sha384_cbc_des,
+	&safexcel_alg_rfc4106_gcm,
 };
 
 static int safexcel_register_algorithms(struct safexcel_crypto_priv *priv)
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index 9522594..6c91d49 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -910,5 +910,6 @@ int safexcel_hmac_setkey(const char *alg, const u8 *key, unsigned int keylen,
 extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha224_cbc_des;
 extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha512_cbc_des;
 extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha384_cbc_des;
+extern struct safexcel_alg_template safexcel_alg_rfc4106_gcm;
 
 #endif
diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index 9768db3..d0334b2 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -77,47 +77,47 @@ static void safexcel_cipher_token(struct safexcel_cipher_ctx *ctx, u8 *iv,
 {
 	u32 block_sz = 0;
 
-	if (ctx->mode == CONTEXT_CONTROL_CRYPTO_MODE_CTR_LOAD) {
+	if (ctx->mode == CONTEXT_CONTROL_CRYPTO_MODE_CTR_LOAD ||
+	    ctx->aead == EIP197_AEAD_TYPE_IPSEC_ESP) {
 		cdesc->control_data.options |= EIP197_OPTION_4_TOKEN_IV_CMD;
 
 		/* 32 bit nonce */
 		cdesc->control_data.token[0] = ctx->nonce;
 		/* 64 bit IV part */
 		memcpy(&cdesc->control_data.token[1], iv, 8);
-		/* 32 bit counter, start at 1 (big endian!) */
-		cdesc->control_data.token[3] = cpu_to_be32(1);
+
+		if (ctx->alg == SAFEXCEL_CHACHA20) {
+			/* 32 bit counter, starting at 0 */
+			cdesc->control_data.token[3] = 0;
+		} else {
+			/* 32 bit counter, start at 1 (big endian!) */
+			cdesc->control_data.token[3] = cpu_to_be32(1);
+		}
 
 		return;
-	} else if (ctx->alg == SAFEXCEL_CHACHA20) {
+	} else if (ctx->xcm == EIP197_XCM_MODE_GCM ||
+		   (ctx->aead && ctx->alg == SAFEXCEL_CHACHA20)) {
 		cdesc->control_data.options |= EIP197_OPTION_4_TOKEN_IV_CMD;
 
-		if (ctx->aead == EIP197_AEAD_TYPE_IPSEC_ESP) {
-			/* 32 bit nonce part */
-			cdesc->control_data.token[0] = ctx->nonce;
-			/* 64 bit IV part */
-			memcpy(&cdesc->control_data.token[1], iv, 8);
-			/* 32 bit counter, starting at 0 */
-			cdesc->control_data.token[3] = 0;
-		} else if (ctx->aead) {
-			/* 96 bit nonce part */
-			memcpy(&cdesc->control_data.token[0], iv, 12);
+		/* 96 bit IV part */
+		memcpy(&cdesc->control_data.token[0], iv, 12);
+
+		if (ctx->alg == SAFEXCEL_CHACHA20) {
 			/* 32 bit counter, starting at 0 */
 			cdesc->control_data.token[3] = 0;
 		} else {
-			/* 96 bit nonce part */
-			memcpy(&cdesc->control_data.token[0], &iv[4], 12);
-			/* 32 bit counter */
-			cdesc->control_data.token[3] = *(u32 *)iv;
+			/* 32 bit counter, start at 1 (big endian!) */
+			cdesc->control_data.token[3] = cpu_to_be32(1);
 		}
 
 		return;
-	} else if (ctx->xcm == EIP197_XCM_MODE_GCM) {
+	} else if (ctx->alg == SAFEXCEL_CHACHA20) {
 		cdesc->control_data.options |= EIP197_OPTION_4_TOKEN_IV_CMD;
 
-		/* 96 bit IV part */
-		memcpy(&cdesc->control_data.token[0], iv, 12);
-		/* 32 bit counter, start at 1 (big endian!) */
-		cdesc->control_data.token[3] = cpu_to_be32(1);
+		/* 96 bit nonce part */
+		memcpy(&cdesc->control_data.token[0], &iv[4], 12);
+		/* 32 bit counter */
+		cdesc->control_data.token[3] = *(u32 *)iv;
 
 		return;
 	} else if (ctx->xcm == EIP197_XCM_MODE_CCM) {
@@ -3428,3 +3428,69 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sm3_ctr_sm4 = {
 		},
 	},
 };
+
+static int safexcel_rfc4106_gcm_setkey(struct crypto_aead *ctfm, const u8 *key,
+				       unsigned int len)
+{
+	struct crypto_tfm *tfm = crypto_aead_tfm(ctfm);
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	/* last 4 bytes of key are the nonce! */
+	ctx->nonce = *(u32 *)(key + len - CTR_RFC3686_NONCE_SIZE);
+
+	len -= CTR_RFC3686_NONCE_SIZE;
+	return safexcel_aead_gcm_setkey(ctfm, key, len);
+}
+
+static int safexcel_rfc4106_gcm_setauthsize(struct crypto_aead *tfm,
+					    unsigned int authsize)
+{
+	return crypto_rfc4106_check_authsize(authsize);
+}
+
+static int safexcel_rfc4106_encrypt(struct aead_request *req)
+{
+	return crypto_ipsec_check_assoclen(req->assoclen) ?:
+	       safexcel_aead_encrypt(req);
+}
+
+static int safexcel_rfc4106_decrypt(struct aead_request *req)
+{
+	return crypto_ipsec_check_assoclen(req->assoclen) ?:
+	       safexcel_aead_decrypt(req);
+}
+
+static int safexcel_rfc4106_gcm_cra_init(struct crypto_tfm *tfm)
+{
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+	int ret;
+
+	ret = safexcel_aead_gcm_cra_init(tfm);
+	ctx->aead  = EIP197_AEAD_TYPE_IPSEC_ESP;
+	return ret;
+}
+
+struct safexcel_alg_template safexcel_alg_rfc4106_gcm = {
+	.type = SAFEXCEL_ALG_TYPE_AEAD,
+	.algo_mask = SAFEXCEL_ALG_AES | SAFEXCEL_ALG_GHASH,
+	.alg.aead = {
+		.setkey = safexcel_rfc4106_gcm_setkey,
+		.setauthsize = safexcel_rfc4106_gcm_setauthsize,
+		.encrypt = safexcel_rfc4106_encrypt,
+		.decrypt = safexcel_rfc4106_decrypt,
+		.ivsize = GCM_RFC4106_IV_SIZE,
+		.maxauthsize = GHASH_DIGEST_SIZE,
+		.base = {
+			.cra_name = "rfc4106(gcm(aes))",
+			.cra_driver_name = "safexcel-rfc4106-gcm-aes",
+			.cra_priority = SAFEXCEL_CRA_PRIORITY,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_blocksize = 1,
+			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
+			.cra_alignmask = 0,
+			.cra_init = safexcel_rfc4106_gcm_cra_init,
+			.cra_exit = safexcel_aead_gcm_cra_exit,
+		},
+	},
+};
-- 
1.8.3.1

