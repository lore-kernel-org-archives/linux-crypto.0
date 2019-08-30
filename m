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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 697F8C3A5A7
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Aug 2019 08:55:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3324921726
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Aug 2019 08:55:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cQxS3P+F"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbfH3IzT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 30 Aug 2019 04:55:19 -0400
Received: from mail-ed1-f41.google.com ([209.85.208.41]:40569 "EHLO
        mail-ed1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727768AbfH3IzT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Aug 2019 04:55:19 -0400
Received: by mail-ed1-f41.google.com with SMTP id v38so1282190edm.7
        for <linux-crypto@vger.kernel.org>; Fri, 30 Aug 2019 01:55:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ZMdfkZ1hJHJZstRCxguvEhXgMWvu382NgdD05nebMTc=;
        b=cQxS3P+FG+2A6hvvH0rRpIqLo9xoydUXXvGi6IiK6wp5DP3BZ0Mpzn/F96cYSw9qk5
         j3JRR28cJbMiiE1y9/4jdocl4ffw1RhnZrYwqeuPfYOvvVvtwg+s78a98Aq8b/duOtpT
         WFY1kPYFCUqE12qCcifMdbLFAgd4gg0amqsCah2jxJQwDVijAGPJmmQgJZl1hp3kDcOQ
         TyVT8vL4yh91gQdhan7gmyzz4l1jpE44kF1ovr4rLd8z1h3yN4RuSk9RXKnvNZUb57Nd
         1WfBWhRA6hx8j5aRBOCjmgD5r/T0ffdPWWWdn6W6VXvsX5aukXaZpMptSiDSxGEu/cLz
         lpIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ZMdfkZ1hJHJZstRCxguvEhXgMWvu382NgdD05nebMTc=;
        b=EHZHFvXtk2Wf/Fc7/jSKsF2PBz6esAojul1wt3MvCZhpim7sJMdwAins4+9QpM/EGC
         L/tSL7w2gjeBhxD3ycV6dw3FyawldmzFEzheR52PfHG3X7y5h97WOKfxI3Bt1aEEp2qU
         LDkXjW/ZNGjSexQ3apjrHWqCaa60YvxqyvLcemPz8SrqROUQVyLW73zU6uGS29XEHy8i
         EreuTVQ62Pm2oxdZiYSLzAbBLSrcaF2RB7pAuyBPMFV0WPBKwcFrgukzCi3XI1qwIBAg
         +8f4fTjgurs8DeUUoCroia9VRLb1eLeExFMdUdQEYjNUxChgoO87K+X82Vv99utWD+zY
         JYNA==
X-Gm-Message-State: APjAAAU5nS81h2Rnbuy5fBHkA9YG0MsVWbGwK5kiTdQQRHqIoxH9Yyko
        pHz6ieKtxj5GL5n4YNAGRoawF3nD
X-Google-Smtp-Source: APXvYqyq0JYCUcWB24XpwEDX1Pe9UlMKE0nYiKbN2ADCSjZDbvX0ZNPTTyEvqK9DyS2Ib82MFVeYaw==
X-Received: by 2002:a17:906:340e:: with SMTP id c14mr12215776ejb.170.1567155316885;
        Fri, 30 Aug 2019 01:55:16 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id l9sm335610eda.51.2019.08.30.01.55.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Aug 2019 01:55:16 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH 4/4] crypto: inside-secure - Added support for basic AES-CCM
Date:   Fri, 30 Aug 2019 09:52:33 +0200
Message-Id: <1567151553-11108-5-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1567151553-11108-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1567151553-11108-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds support for the basic AES-CCM AEAD cipher suite.

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel.c        |   4 +-
 drivers/crypto/inside-secure/safexcel.h        |  10 +-
 drivers/crypto/inside-secure/safexcel_cipher.c | 288 ++++++++++++++++++++-----
 3 files changed, 249 insertions(+), 53 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 5ad4feb..5d648ee 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -715,8 +715,7 @@ inline int safexcel_rdesc_check_errors(struct safexcel_crypto_priv *priv,
 	} else if (rdesc->result_data.error_code & BIT(9)) {
 		/* Authentication failed */
 		return -EBADMSG;
-	} else if (!rdesc->result_data.error_code)
-		return 0;
+	}
 
 	/* All other non-fatal errors */
 	return -EINVAL;
@@ -1009,6 +1008,7 @@ static int safexcel_request_ring_irq(void *pdev, int irqid,
 	&safexcel_alg_authenc_hmac_sha512_ctr_aes,
 	&safexcel_alg_xts_aes,
 	&safexcel_alg_gcm,
+	&safexcel_alg_ccm,
 };
 
 static int safexcel_register_algorithms(struct safexcel_crypto_priv *priv)
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index 0eb3445..1407804 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -19,7 +19,7 @@
 
 /* Static configuration */
 #define EIP197_DEFAULT_RING_SIZE		400
-#define EIP197_MAX_TOKENS			10
+#define EIP197_MAX_TOKENS			18
 #define EIP197_MAX_RINGS			4
 #define EIP197_FETCH_COUNT			1
 #define EIP197_MAX_BATCH_SZ			64
@@ -330,6 +330,9 @@ struct safexcel_context_record {
 #define CONTEXT_CONTROL_CRYPTO_ALG_SHA384	(0x6 << 23)
 #define CONTEXT_CONTROL_CRYPTO_ALG_SHA512	(0x5 << 23)
 #define CONTEXT_CONTROL_CRYPTO_ALG_GHASH	(0x4 << 23)
+#define CONTEXT_CONTROL_CRYPTO_ALG_XCBC128	(0x1 << 23)
+#define CONTEXT_CONTROL_CRYPTO_ALG_XCBC192	(0x2 << 23)
+#define CONTEXT_CONTROL_CRYPTO_ALG_XCBC256	(0x3 << 23)
 #define CONTEXT_CONTROL_INV_FR			(0x5 << 24)
 #define CONTEXT_CONTROL_INV_TR			(0x6 << 24)
 
@@ -350,6 +353,9 @@ struct safexcel_context_record {
 #define CONTEXT_CONTROL_CRYPTO_STORE		BIT(12)
 #define CONTEXT_CONTROL_HASH_STORE		BIT(19)
 
+#define EIP197_XCM_MODE_GCM			1
+#define EIP197_XCM_MODE_CCM			2
+
 /* The hash counter given to the engine in the context has a granularity of
  * 64 bits.
  */
@@ -464,6 +470,7 @@ static inline void eip197_noop_token(struct safexcel_token *token)
 /* Instructions */
 #define EIP197_TOKEN_INS_INSERT_HASH_DIGEST	0x1c
 #define EIP197_TOKEN_INS_ORIGIN_IV0		0x14
+#define EIP197_TOKEN_INS_ORIGIN_TOKEN		0x1b
 #define EIP197_TOKEN_INS_ORIGIN_LEN(x)		((x) << 5)
 #define EIP197_TOKEN_INS_TYPE_OUTPUT		BIT(5)
 #define EIP197_TOKEN_INS_TYPE_HASH		BIT(6)
@@ -797,5 +804,6 @@ int safexcel_hmac_setkey(const char *alg, const u8 *key, unsigned int keylen,
 extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha512_ctr_aes;
 extern struct safexcel_alg_template safexcel_alg_xts_aes;
 extern struct safexcel_alg_template safexcel_alg_gcm;
+extern struct safexcel_alg_template safexcel_alg_ccm;
 
 #endif
diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index bc4ebc7..023cabc 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -81,7 +81,7 @@ static void safexcel_cipher_token(struct safexcel_cipher_ctx *ctx, u8 *iv,
 		cdesc->control_data.token[3] = cpu_to_be32(1);
 
 		return;
-	} else if (ctx->mode == CONTEXT_CONTROL_CRYPTO_MODE_XCM) {
+	} else if (ctx->xcm == EIP197_XCM_MODE_GCM) {
 		cdesc->control_data.options |= EIP197_OPTION_4_TOKEN_IV_CMD;
 
 		/* 96 bit IV part */
@@ -90,6 +90,16 @@ static void safexcel_cipher_token(struct safexcel_cipher_ctx *ctx, u8 *iv,
 		cdesc->control_data.token[3] = cpu_to_be32(1);
 
 		return;
+	} else if (ctx->xcm == EIP197_XCM_MODE_CCM) {
+		cdesc->control_data.options |= EIP197_OPTION_4_TOKEN_IV_CMD;
+
+		/* Variable length IV part */
+		memcpy(&cdesc->control_data.token[0], iv, 15 - iv[0]);
+		/* Start variable length counter at 0 */
+		memset((u8 *)&cdesc->control_data.token[0] + 15 - iv[0],
+		       0, iv[0] + 1);
+
+		return;
 	}
 
 	if (ctx->mode != CONTEXT_CONTROL_CRYPTO_MODE_ECB) {
@@ -143,67 +153,117 @@ static void safexcel_aead_token(struct safexcel_cipher_ctx *ctx, u8 *iv,
 	if (direction == SAFEXCEL_ENCRYPT) {
 		/* align end of instruction sequence to end of token */
 		token = (struct safexcel_token *)(cdesc->control_data.token +
-			 EIP197_MAX_TOKENS - 5);
-
-		token[4].opcode = EIP197_TOKEN_OPCODE_INSERT;
-		token[4].packet_length = digestsize;
-		token[4].stat = EIP197_TOKEN_STAT_LAST_HASH |
-				EIP197_TOKEN_STAT_LAST_PACKET;
-		token[4].instructions = EIP197_TOKEN_INS_TYPE_OUTPUT |
-					EIP197_TOKEN_INS_INSERT_HASH_DIGEST;
+			 EIP197_MAX_TOKENS - 13);
+
+		token[12].opcode = EIP197_TOKEN_OPCODE_INSERT;
+		token[12].packet_length = digestsize;
+		token[12].stat = EIP197_TOKEN_STAT_LAST_HASH |
+				 EIP197_TOKEN_STAT_LAST_PACKET;
+		token[12].instructions = EIP197_TOKEN_INS_TYPE_OUTPUT |
+					 EIP197_TOKEN_INS_INSERT_HASH_DIGEST;
 	} else {
 		cryptlen -= digestsize;
 
 		/* align end of instruction sequence to end of token */
 		token = (struct safexcel_token *)(cdesc->control_data.token +
-			 EIP197_MAX_TOKENS - 6);
-
-		token[4].opcode = EIP197_TOKEN_OPCODE_RETRIEVE;
-		token[4].packet_length = digestsize;
-		token[4].stat = EIP197_TOKEN_STAT_LAST_HASH |
-				EIP197_TOKEN_STAT_LAST_PACKET;
-		token[4].instructions = EIP197_TOKEN_INS_INSERT_HASH_DIGEST;
-
-		token[5].opcode = EIP197_TOKEN_OPCODE_VERIFY;
-		token[5].packet_length = digestsize |
-					 EIP197_TOKEN_HASH_RESULT_VERIFY;
-		token[5].stat = EIP197_TOKEN_STAT_LAST_HASH |
-				EIP197_TOKEN_STAT_LAST_PACKET;
-		token[5].instructions = EIP197_TOKEN_INS_TYPE_OUTPUT;
+			 EIP197_MAX_TOKENS - 14);
+
+		token[12].opcode = EIP197_TOKEN_OPCODE_RETRIEVE;
+		token[12].packet_length = digestsize;
+		token[12].stat = EIP197_TOKEN_STAT_LAST_HASH |
+				 EIP197_TOKEN_STAT_LAST_PACKET;
+		token[12].instructions = EIP197_TOKEN_INS_INSERT_HASH_DIGEST;
+
+		token[13].opcode = EIP197_TOKEN_OPCODE_VERIFY;
+		token[13].packet_length = digestsize |
+					  EIP197_TOKEN_HASH_RESULT_VERIFY;
+		token[13].stat = EIP197_TOKEN_STAT_LAST_HASH |
+				 EIP197_TOKEN_STAT_LAST_PACKET;
+		token[13].instructions = EIP197_TOKEN_INS_TYPE_OUTPUT;
 	}
 
-	token[0].opcode = EIP197_TOKEN_OPCODE_DIRECTION;
-	token[0].packet_length = assoclen;
+	token[6].opcode = EIP197_TOKEN_OPCODE_DIRECTION;
+	token[6].packet_length = assoclen;
 
 	if (likely(cryptlen)) {
-		token[0].instructions = EIP197_TOKEN_INS_TYPE_HASH;
-
-		token[3].opcode = EIP197_TOKEN_OPCODE_DIRECTION;
-		token[3].packet_length = cryptlen;
-		token[3].stat = EIP197_TOKEN_STAT_LAST_HASH;
-		token[3].instructions = EIP197_TOKEN_INS_LAST |
-					EIP197_TOKEN_INS_TYPE_CRYPTO |
-					EIP197_TOKEN_INS_TYPE_HASH |
-					EIP197_TOKEN_INS_TYPE_OUTPUT;
-	} else {
-		token[0].stat = EIP197_TOKEN_STAT_LAST_HASH;
-		token[0].instructions = EIP197_TOKEN_INS_LAST |
+		token[6].instructions = EIP197_TOKEN_INS_TYPE_HASH;
+
+		token[10].opcode = EIP197_TOKEN_OPCODE_DIRECTION;
+		token[10].packet_length = cryptlen;
+		token[10].stat = EIP197_TOKEN_STAT_LAST_HASH;
+		token[10].instructions = EIP197_TOKEN_INS_LAST |
+					 EIP197_TOKEN_INS_TYPE_CRYPTO |
+					 EIP197_TOKEN_INS_TYPE_HASH |
+					 EIP197_TOKEN_INS_TYPE_OUTPUT;
+	} else if (ctx->xcm != EIP197_XCM_MODE_CCM) {
+		token[6].stat = EIP197_TOKEN_STAT_LAST_HASH;
+		token[6].instructions = EIP197_TOKEN_INS_LAST |
 					EIP197_TOKEN_INS_TYPE_HASH;
 	}
 
-	if (ctx->xcm) {
-		token[0].instructions = EIP197_TOKEN_INS_LAST |
+	if (!ctx->xcm)
+		return;
+
+	token[8].opcode = EIP197_TOKEN_OPCODE_INSERT_REMRES;
+	token[8].packet_length = 0;
+	token[8].instructions = AES_BLOCK_SIZE;
+
+	token[9].opcode = EIP197_TOKEN_OPCODE_INSERT;
+	token[9].packet_length = AES_BLOCK_SIZE;
+	token[9].instructions = EIP197_TOKEN_INS_TYPE_OUTPUT |
+				EIP197_TOKEN_INS_TYPE_CRYPTO;
+
+	if (ctx->xcm == EIP197_XCM_MODE_GCM) {
+		token[6].instructions = EIP197_TOKEN_INS_LAST |
 					EIP197_TOKEN_INS_TYPE_HASH;
+	} else {
+		u8 *cbcmaciv = (u8 *)&token[1];
+		u32 *aadlen = (u32 *)&token[5];
+
+		/* Construct IV block B0 for the CBC-MAC */
+		token[0].opcode = EIP197_TOKEN_OPCODE_INSERT;
+		token[0].packet_length = AES_BLOCK_SIZE +
+					 ((assoclen > 0) << 1);
+		token[0].instructions = EIP197_TOKEN_INS_ORIGIN_TOKEN |
+					EIP197_TOKEN_INS_TYPE_HASH;
+		/* Variable length IV part */
+		memcpy(cbcmaciv, iv, 15 - iv[0]);
+		/* fixup flags byte */
+		cbcmaciv[0] |= ((assoclen > 0) << 6) | ((digestsize - 2) << 2);
+		/* Clear upper bytes of variable message length to 0 */
+		memset(cbcmaciv + 15 - iv[0], 0, iv[0] - 1);
+		/* insert lower 2 bytes of message length */
+		cbcmaciv[14] = cryptlen >> 8;
+		cbcmaciv[15] = cryptlen & 255;
 
-		token[1].opcode = EIP197_TOKEN_OPCODE_INSERT_REMRES;
-		token[1].packet_length = 0;
-		token[1].stat = EIP197_TOKEN_STAT_LAST_HASH;
-		token[1].instructions = AES_BLOCK_SIZE;
+		if (assoclen) {
+			*aadlen = cpu_to_le32(cpu_to_be16(assoclen));
+			assoclen += 2;
+		}
 
-		token[2].opcode = EIP197_TOKEN_OPCODE_INSERT;
-		token[2].packet_length = AES_BLOCK_SIZE;
-		token[2].instructions = EIP197_TOKEN_INS_TYPE_OUTPUT |
-					EIP197_TOKEN_INS_TYPE_CRYPTO;
+		token[6].instructions = EIP197_TOKEN_INS_TYPE_HASH;
+
+		/* Align AAD data towards hash engine */
+		token[7].opcode = EIP197_TOKEN_OPCODE_INSERT;
+		assoclen &= 15;
+		token[7].packet_length = assoclen ? 16 - assoclen : 0;
+
+		if (likely(cryptlen)) {
+			token[7].instructions = EIP197_TOKEN_INS_TYPE_HASH;
+
+			/* Align crypto data towards hash engine */
+			token[10].stat = 0;
+
+			token[11].opcode = EIP197_TOKEN_OPCODE_INSERT;
+			cryptlen &= 15;
+			token[11].packet_length = cryptlen ? 16 - cryptlen : 0;
+			token[11].stat = EIP197_TOKEN_STAT_LAST_HASH;
+			token[11].instructions = EIP197_TOKEN_INS_TYPE_HASH;
+		} else {
+			token[7].stat = EIP197_TOKEN_STAT_LAST_HASH;
+			token[7].instructions = EIP197_TOKEN_INS_LAST |
+						EIP197_TOKEN_INS_TYPE_HASH;
+		}
 	}
 }
 
@@ -379,10 +439,15 @@ static int safexcel_context_control(struct safexcel_cipher_ctx *ctx,
 		}
 		if (sreq->direction == SAFEXCEL_ENCRYPT)
 			cdesc->control_data.control0 |=
-				CONTEXT_CONTROL_TYPE_ENCRYPT_HASH_OUT;
+				(ctx->xcm == EIP197_XCM_MODE_CCM) ?
+					CONTEXT_CONTROL_TYPE_HASH_ENCRYPT_OUT :
+					CONTEXT_CONTROL_TYPE_ENCRYPT_HASH_OUT;
+
 		else
 			cdesc->control_data.control0 |=
-				CONTEXT_CONTROL_TYPE_HASH_DECRYPT_IN;
+				(ctx->xcm == EIP197_XCM_MODE_CCM) ?
+					CONTEXT_CONTROL_TYPE_DECRYPT_HASH_IN :
+					CONTEXT_CONTROL_TYPE_HASH_DECRYPT_IN;
 	} else {
 		if (sreq->direction == SAFEXCEL_ENCRYPT)
 			cdesc->control_data.control0 =
@@ -2076,7 +2141,7 @@ static int safexcel_aead_gcm_cra_init(struct crypto_tfm *tfm)
 	safexcel_aead_cra_init(tfm);
 	ctx->hash_alg = CONTEXT_CONTROL_CRYPTO_ALG_GHASH;
 	ctx->state_sz = GHASH_BLOCK_SIZE;
-	ctx->xcm = 1; /* GCM */
+	ctx->xcm = EIP197_XCM_MODE_GCM;
 	ctx->mode = CONTEXT_CONTROL_CRYPTO_MODE_XCM; /* override default */
 
 	ctx->hkaes = crypto_alloc_cipher("aes", 0, 0);
@@ -2125,3 +2190,126 @@ struct safexcel_alg_template safexcel_alg_gcm = {
 		},
 	},
 };
+
+static int safexcel_aead_ccm_setkey(struct crypto_aead *ctfm, const u8 *key,
+				    unsigned int len)
+{
+	struct crypto_tfm *tfm = crypto_aead_tfm(ctfm);
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct safexcel_crypto_priv *priv = ctx->priv;
+	struct crypto_aes_ctx aes;
+	int ret, i;
+
+	ret = aes_expandkey(&aes, key, len);
+	if (ret) {
+		crypto_aead_set_flags(ctfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		memzero_explicit(&aes, sizeof(aes));
+		return ret;
+	}
+
+	if (priv->flags & EIP197_TRC_CACHE && ctx->base.ctxr_dma) {
+		for (i = 0; i < len / sizeof(u32); i++) {
+			if (ctx->key[i] != cpu_to_le32(aes.key_enc[i])) {
+				ctx->base.needs_inv = true;
+				break;
+			}
+		}
+	}
+
+	for (i = 0; i < len / sizeof(u32); i++) {
+		ctx->key[i] = cpu_to_le32(aes.key_enc[i]);
+		ctx->ipad[i + 2 * AES_BLOCK_SIZE / sizeof(u32)] =
+			cpu_to_be32(aes.key_enc[i]);
+	}
+
+	ctx->key_len = len;
+	ctx->state_sz = 2 * AES_BLOCK_SIZE + len;
+
+	if (len == AES_KEYSIZE_192)
+		ctx->hash_alg = CONTEXT_CONTROL_CRYPTO_ALG_XCBC192;
+	else if (len == AES_KEYSIZE_256)
+		ctx->hash_alg = CONTEXT_CONTROL_CRYPTO_ALG_XCBC256;
+	else
+		ctx->hash_alg = CONTEXT_CONTROL_CRYPTO_ALG_XCBC128;
+
+	memzero_explicit(&aes, sizeof(aes));
+	return 0;
+}
+
+static int safexcel_aead_ccm_cra_init(struct crypto_tfm *tfm)
+{
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	safexcel_aead_cra_init(tfm);
+	ctx->hash_alg = CONTEXT_CONTROL_CRYPTO_ALG_XCBC128;
+	ctx->state_sz = 3 * AES_BLOCK_SIZE;
+	ctx->xcm = EIP197_XCM_MODE_CCM;
+	ctx->mode = CONTEXT_CONTROL_CRYPTO_MODE_XCM; /* override default */
+	return 0;
+}
+
+static int safexcel_aead_ccm_setauthsize(struct crypto_aead *tfm,
+					 unsigned int authsize)
+{
+	/* Borrowed from crypto/ccm.c */
+	switch (authsize) {
+	case 4:
+	case 6:
+	case 8:
+	case 10:
+	case 12:
+	case 14:
+	case 16:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int safexcel_ccm_encrypt(struct aead_request *req)
+{
+	struct safexcel_cipher_req *creq = aead_request_ctx(req);
+
+	if (req->iv[0] < 1 || req->iv[0] > 7)
+		return -EINVAL;
+
+	return safexcel_queue_req(&req->base, creq, SAFEXCEL_ENCRYPT);
+}
+
+static int safexcel_ccm_decrypt(struct aead_request *req)
+{
+	struct safexcel_cipher_req *creq = aead_request_ctx(req);
+
+	if (req->iv[0] < 1 || req->iv[0] > 7)
+		return -EINVAL;
+
+	return safexcel_queue_req(&req->base, creq, SAFEXCEL_DECRYPT);
+}
+
+struct safexcel_alg_template safexcel_alg_ccm = {
+	.type = SAFEXCEL_ALG_TYPE_AEAD,
+	.algo_mask = SAFEXCEL_ALG_AES | SAFEXCEL_ALG_CBC_MAC_ALL,
+	.alg.aead = {
+		.setkey = safexcel_aead_ccm_setkey,
+		.setauthsize = safexcel_aead_ccm_setauthsize,
+		.encrypt = safexcel_ccm_encrypt,
+		.decrypt = safexcel_ccm_decrypt,
+		.ivsize = AES_BLOCK_SIZE,
+		.maxauthsize = AES_BLOCK_SIZE,
+		.base = {
+			.cra_name = "ccm(aes)",
+			.cra_driver_name = "safexcel-ccm-aes",
+			.cra_priority = SAFEXCEL_CRA_PRIORITY,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_blocksize = 1,
+			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
+			.cra_alignmask = 0,
+			.cra_init = safexcel_aead_ccm_cra_init,
+			.cra_exit = safexcel_aead_cra_exit,
+			.cra_module = THIS_MODULE,
+		},
+	},
+};
-- 
1.8.3.1

