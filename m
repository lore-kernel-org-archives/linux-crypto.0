Return-Path: <SRS0=kkEj=VC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97B2FC4649A
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jul 2019 07:53:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B237218BC
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jul 2019 07:53:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ADK8UOiZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725894AbfGEHxM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 5 Jul 2019 03:53:12 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:34017 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727654AbfGEHxM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Jul 2019 03:53:12 -0400
Received: by mail-ed1-f68.google.com with SMTP id s49so7447936edb.1
        for <linux-crypto@vger.kernel.org>; Fri, 05 Jul 2019 00:53:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=yb0+YrhVhIqNqblwYmQ7EReShWk4/O5bzgnhpMk0T1I=;
        b=ADK8UOiZISbwOwolsqJZNqnvVeJLuLvuXejdOh6k3IGKDQw5zmvlszqzIlN9TlQquq
         1S/AcuHaia2eVVSCoN49nlnag84m2uKlPIwcyM15trEcI4Xp84KU2rJrFrk8089V4qLt
         oXy2LzgPWOzLBRSZ3R2LndDYsrlWEqTK+dxvJxedcyYVRdXB4t9tgf9M4So+d7+Il4tX
         vzfIUI+29FMVF8wCSsBI0TSQnBFsDQtS4CzWzFAS/BxJg+NSn2YQclP1wTjauTLf82ZI
         CXXt9l6vzeVYsD3Q3SsXwWy52gyxd9LnRAEGkWWcRommICUIUcCkaQrqVCyRF3jE4M2V
         k93A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=yb0+YrhVhIqNqblwYmQ7EReShWk4/O5bzgnhpMk0T1I=;
        b=HBxsAfUl845etmlUgpmEMcNdCwe8WFkRxp09glTeEaBsr3xmDt7ayoQzVwErUyVPeG
         o1EW7UN9qC4hCEnsQjPGGBek90PqQdzTEk66TQ194qxdGGwEAReAIqo/2Ncf9a38OO3G
         XWbqagjA/kHNrBTXI4Uzt7C4eNVouICbCZxCrGpAY08LNv2bNILUEv6AfPfjFnkgLZnm
         3KO367Ig9n5PMrco1koVYdl3ZYPHPcVSuD6lXpr6VTYy7URXeiAGSmOGyieYIv2I7+KR
         dmKAi5dsL26wBwSzIDVkkOGwN4dpRkS9GyVi/thNFhY4CuqS7UbmP0ulcsWECih8GWeK
         U5gg==
X-Gm-Message-State: APjAAAVOUE9aHNHI9hWCLKA1935tFvnRnyAgfLyJcOC0/vQZMdzHWjUZ
        IoegNqdSESvuTzqnS6TUx1j58Z3O
X-Google-Smtp-Source: APXvYqzeYxxXHYEIo/pcKSWBekSZD9vDGQX17RLNqlzJ8t+B6cU3OhJuG6ZGCBM2XpH8HV+qRPbJiQ==
X-Received: by 2002:a17:906:1f43:: with SMTP id d3mr2090680ejk.169.1562313189103;
        Fri, 05 Jul 2019 00:53:09 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id z2sm1551438ejp.73.2019.07.05.00.53.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jul 2019 00:53:08 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH 2/3] crypto: inside-secure - added support for rfc3686(ctr(aes))
Date:   Fri,  5 Jul 2019 08:49:23 +0200
Message-Id: <1562309364-942-3-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1562309364-942-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1562309364-942-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel.c        |  15 +--
 drivers/crypto/inside-secure/safexcel.h        |  32 +----
 drivers/crypto/inside-secure/safexcel_cipher.c | 155 +++++++++++++++++++++----
 3 files changed, 138 insertions(+), 64 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index c3bb177..26f086b 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -506,17 +506,9 @@ static int safexcel_hw_init(struct safexcel_crypto_priv *priv)
 		      EIP197_PE_EIP96_TOKEN_CTRL_POST_REUSE_CTX;
 		writel(val, EIP197_PE(priv) + EIP197_PE_EIP96_TOKEN_CTRL(pe));
 
-		/* H/W capabilities selection */
-		val = EIP197_FUNCTION_RSVD;
-		val |= EIP197_PROTOCOL_ENCRYPT_ONLY | EIP197_PROTOCOL_HASH_ONLY;
-		val |= EIP197_PROTOCOL_ENCRYPT_HASH | EIP197_PROTOCOL_HASH_DECRYPT;
-		val |= EIP197_ALG_DES_ECB | EIP197_ALG_DES_CBC;
-		val |= EIP197_ALG_3DES_ECB | EIP197_ALG_3DES_CBC;
-		val |= EIP197_ALG_AES_ECB | EIP197_ALG_AES_CBC;
-		val |= EIP197_ALG_MD5 | EIP197_ALG_HMAC_MD5;
-		val |= EIP197_ALG_SHA1 | EIP197_ALG_HMAC_SHA1;
-		val |= EIP197_ALG_SHA2 | EIP197_ALG_HMAC_SHA2;
-		writel(val, EIP197_PE(priv) + EIP197_PE_EIP96_FUNCTION_EN(pe));
+		/* H/W capabilities selection: just enable everything */
+		writel(EIP197_FUNCTION_ALL,
+		       EIP197_PE(priv) + EIP197_PE_EIP96_FUNCTION_EN(pe));
 	}
 
 	/* Command Descriptor Rings prepare */
@@ -987,6 +979,7 @@ static int safexcel_request_ring_irq(void *pdev, int irqid,
 	&safexcel_alg_cbc_des3_ede,
 	&safexcel_alg_ecb_aes,
 	&safexcel_alg_cbc_aes,
+	&safexcel_alg_ctr_aes,
 	&safexcel_alg_md5,
 	&safexcel_alg_sha1,
 	&safexcel_alg_sha224,
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index 765f481..af71120 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -279,35 +279,7 @@
 #define EIP197_PE_EIP96_TOKEN_CTRL_POST_REUSE_CTX	BIT(20)
 
 /* EIP197_PE_EIP96_FUNCTION_EN */
-#define EIP197_FUNCTION_RSVD			(BIT(6) | BIT(15) | BIT(20) | BIT(23))
-#define EIP197_PROTOCOL_HASH_ONLY		BIT(0)
-#define EIP197_PROTOCOL_ENCRYPT_ONLY		BIT(1)
-#define EIP197_PROTOCOL_HASH_ENCRYPT		BIT(2)
-#define EIP197_PROTOCOL_HASH_DECRYPT		BIT(3)
-#define EIP197_PROTOCOL_ENCRYPT_HASH		BIT(4)
-#define EIP197_PROTOCOL_DECRYPT_HASH		BIT(5)
-#define EIP197_ALG_ARC4				BIT(7)
-#define EIP197_ALG_AES_ECB			BIT(8)
-#define EIP197_ALG_AES_CBC			BIT(9)
-#define EIP197_ALG_AES_CTR_ICM			BIT(10)
-#define EIP197_ALG_AES_OFB			BIT(11)
-#define EIP197_ALG_AES_CFB			BIT(12)
-#define EIP197_ALG_DES_ECB			BIT(13)
-#define EIP197_ALG_DES_CBC			BIT(14)
-#define EIP197_ALG_DES_OFB			BIT(16)
-#define EIP197_ALG_DES_CFB			BIT(17)
-#define EIP197_ALG_3DES_ECB			BIT(18)
-#define EIP197_ALG_3DES_CBC			BIT(19)
-#define EIP197_ALG_3DES_OFB			BIT(21)
-#define EIP197_ALG_3DES_CFB			BIT(22)
-#define EIP197_ALG_MD5				BIT(24)
-#define EIP197_ALG_HMAC_MD5			BIT(25)
-#define EIP197_ALG_SHA1				BIT(26)
-#define EIP197_ALG_HMAC_SHA1			BIT(27)
-#define EIP197_ALG_SHA2				BIT(28)
-#define EIP197_ALG_HMAC_SHA2			BIT(29)
-#define EIP197_ALG_AES_XCBC_MAC			BIT(30)
-#define EIP197_ALG_GCM_HASH			BIT(31)
+#define EIP197_FUNCTION_ALL			0xffffffff
 
 /* EIP197_PE_EIP96_CONTEXT_CTRL */
 #define EIP197_CONTEXT_SIZE(n)			(n)
@@ -356,6 +328,7 @@ struct safexcel_context_record {
 /* control1 */
 #define CONTEXT_CONTROL_CRYPTO_MODE_ECB		(0 << 0)
 #define CONTEXT_CONTROL_CRYPTO_MODE_CBC		(1 << 0)
+#define CONTEXT_CONTROL_CRYPTO_MODE_CTR_LOAD	(6 << 0)
 #define CONTEXT_CONTROL_IV0			BIT(5)
 #define CONTEXT_CONTROL_IV1			BIT(6)
 #define CONTEXT_CONTROL_IV2			BIT(7)
@@ -748,6 +721,7 @@ int safexcel_hmac_setkey(const char *alg, const u8 *key, unsigned int keylen,
 extern struct safexcel_alg_template safexcel_alg_cbc_des3_ede;
 extern struct safexcel_alg_template safexcel_alg_ecb_aes;
 extern struct safexcel_alg_template safexcel_alg_cbc_aes;
+extern struct safexcel_alg_template safexcel_alg_ctr_aes;
 extern struct safexcel_alg_template safexcel_alg_md5;
 extern struct safexcel_alg_template safexcel_alg_sha1;
 extern struct safexcel_alg_template safexcel_alg_sha224;
diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index 5eed890..91945b1 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -40,6 +40,7 @@ struct safexcel_cipher_ctx {
 	bool aead;
 
 	__le32 key[8];
+	u32 nonce;
 	unsigned int key_len;
 
 	/* All the below is AEAD specific */
@@ -62,9 +63,9 @@ static void safexcel_skcipher_token(struct safexcel_cipher_ctx *ctx, u8 *iv,
 				    u32 length)
 {
 	struct safexcel_token *token;
-	u32 offset = 0, block_sz = 0;
+	u32 block_sz = 0;
 
-	if (ctx->mode == CONTEXT_CONTROL_CRYPTO_MODE_CBC) {
+	if (ctx->mode != CONTEXT_CONTROL_CRYPTO_MODE_ECB) {
 		switch (ctx->alg) {
 		case SAFEXCEL_DES:
 			block_sz = DES_BLOCK_SIZE;
@@ -80,11 +81,20 @@ static void safexcel_skcipher_token(struct safexcel_cipher_ctx *ctx, u8 *iv,
 			break;
 		}
 
-		offset = block_sz / sizeof(u32);
-		memcpy(cdesc->control_data.token, iv, block_sz);
+		if (ctx->mode == CONTEXT_CONTROL_CRYPTO_MODE_CTR_LOAD) {
+			/* 32 bit nonce */
+			cdesc->control_data.token[0] = ctx->nonce;
+			/* 64 bit IV part */
+			memcpy(&cdesc->control_data.token[1], iv, 8);
+			/* 32 bit counter, start at 1 (big endian!) */
+			cdesc->control_data.token[3] = cpu_to_be32(1);
+		} else {
+			memcpy(cdesc->control_data.token, iv, block_sz);
+		}
 	}
 
-	token = (struct safexcel_token *)(cdesc->control_data.token + offset);
+	/* skip over worst case IV of 4 dwords, no need to be exact */
+	token = (struct safexcel_token *)(cdesc->control_data.token + 4);
 
 	token[0].opcode = EIP197_TOKEN_OPCODE_DIRECTION;
 	token[0].packet_length = length;
@@ -101,33 +111,35 @@ static void safexcel_aead_token(struct safexcel_cipher_ctx *ctx, u8 *iv,
 				u32 cryptlen, u32 assoclen, u32 digestsize)
 {
 	struct safexcel_token *token;
-	unsigned offset = 0;
+	u32 block_sz = 0;
 
-	if (ctx->mode == CONTEXT_CONTROL_CRYPTO_MODE_CBC) {
-		offset = AES_BLOCK_SIZE / sizeof(u32);
-		memcpy(cdesc->control_data.token, iv, AES_BLOCK_SIZE);
+	if (ctx->mode != CONTEXT_CONTROL_CRYPTO_MODE_ECB) {
+		switch (ctx->alg) {
+		case SAFEXCEL_DES:
+			block_sz = DES_BLOCK_SIZE;
+			cdesc->control_data.options |= EIP197_OPTION_2_TOKEN_IV_CMD;
+			break;
+		case SAFEXCEL_3DES:
+			block_sz = DES3_EDE_BLOCK_SIZE;
+			cdesc->control_data.options |= EIP197_OPTION_2_TOKEN_IV_CMD;
+			break;
+		case SAFEXCEL_AES:
+			block_sz = AES_BLOCK_SIZE;
+			cdesc->control_data.options |= EIP197_OPTION_4_TOKEN_IV_CMD;
+			break;
+		}
 
-		cdesc->control_data.options |= EIP197_OPTION_4_TOKEN_IV_CMD;
+		memcpy(cdesc->control_data.token, iv, block_sz);
 	}
 
-	token = (struct safexcel_token *)(cdesc->control_data.token + offset);
-
 	if (direction == SAFEXCEL_DECRYPT)
 		cryptlen -= digestsize;
 
-	token[0].opcode = EIP197_TOKEN_OPCODE_DIRECTION;
-	token[0].packet_length = assoclen;
-	token[0].instructions = EIP197_TOKEN_INS_TYPE_HASH;
-
-	token[1].opcode = EIP197_TOKEN_OPCODE_DIRECTION;
-	token[1].packet_length = cryptlen;
-	token[1].stat = EIP197_TOKEN_STAT_LAST_HASH;
-	token[1].instructions = EIP197_TOKEN_INS_LAST |
-				EIP197_TOKEN_INS_TYPE_CRYPTO |
-				EIP197_TOKEN_INS_TYPE_HASH |
-				EIP197_TOKEN_INS_TYPE_OUTPUT;
-
 	if (direction == SAFEXCEL_ENCRYPT) {
+		/* align end of instruction sequence to end of token */
+		token = (struct safexcel_token *)(cdesc->control_data.token +
+			 EIP197_MAX_TOKENS - 3);
+
 		token[2].opcode = EIP197_TOKEN_OPCODE_INSERT;
 		token[2].packet_length = digestsize;
 		token[2].stat = EIP197_TOKEN_STAT_LAST_HASH |
@@ -135,6 +147,10 @@ static void safexcel_aead_token(struct safexcel_cipher_ctx *ctx, u8 *iv,
 		token[2].instructions = EIP197_TOKEN_INS_TYPE_OUTPUT |
 					EIP197_TOKEN_INS_INSERT_HASH_DIGEST;
 	} else {
+		/* align end of instruction sequence to end of token */
+		token = (struct safexcel_token *)(cdesc->control_data.token +
+			 EIP197_MAX_TOKENS - 4);
+
 		token[2].opcode = EIP197_TOKEN_OPCODE_RETRIEVE;
 		token[2].packet_length = digestsize;
 		token[2].stat = EIP197_TOKEN_STAT_LAST_HASH |
@@ -148,6 +164,19 @@ static void safexcel_aead_token(struct safexcel_cipher_ctx *ctx, u8 *iv,
 				EIP197_TOKEN_STAT_LAST_PACKET;
 		token[3].instructions = EIP197_TOKEN_INS_TYPE_OUTPUT;
 	}
+
+	token[0].opcode = EIP197_TOKEN_OPCODE_DIRECTION;
+	token[0].packet_length = assoclen;
+	token[0].instructions = EIP197_TOKEN_INS_TYPE_HASH;
+
+	token[1].opcode = EIP197_TOKEN_OPCODE_DIRECTION;
+	token[1].packet_length = cryptlen;
+	token[1].stat = EIP197_TOKEN_STAT_LAST_HASH;
+	token[1].instructions = EIP197_TOKEN_INS_LAST |
+				EIP197_TOKEN_INS_TYPE_CRYPTO |
+				EIP197_TOKEN_INS_TYPE_HASH |
+				EIP197_TOKEN_INS_TYPE_OUTPUT;
+
 }
 
 static int safexcel_skcipher_aes_setkey(struct crypto_skcipher *ctfm,
@@ -1044,6 +1073,84 @@ struct safexcel_alg_template safexcel_alg_cbc_aes = {
 	},
 };
 
+static int safexcel_ctr_aes_encrypt(struct skcipher_request *req)
+{
+	return safexcel_queue_req(&req->base, skcipher_request_ctx(req),
+			SAFEXCEL_ENCRYPT, CONTEXT_CONTROL_CRYPTO_MODE_CTR_LOAD,
+			SAFEXCEL_AES);
+}
+
+static int safexcel_ctr_aes_decrypt(struct skcipher_request *req)
+{
+	return safexcel_queue_req(&req->base, skcipher_request_ctx(req),
+			SAFEXCEL_DECRYPT, CONTEXT_CONTROL_CRYPTO_MODE_CTR_LOAD,
+			SAFEXCEL_AES);
+}
+
+static int safexcel_skcipher_aesctr_setkey(struct crypto_skcipher *ctfm,
+					   const u8 *key, unsigned int len)
+{
+	struct crypto_tfm *tfm = crypto_skcipher_tfm(ctfm);
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct safexcel_crypto_priv *priv = ctx->priv;
+	struct crypto_aes_ctx aes;
+	int ret, i;
+	unsigned int keylen;
+
+	/* last 4 bytes of key are the nonce! */
+	ctx->nonce = *(u32 *)(key + len - 4);
+	/* exclude the nonce here */
+	keylen = len - 4;
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
+	ctx->key_len = keylen;
+
+	memzero_explicit(&aes, sizeof(aes));
+	return 0;
+}
+
+struct safexcel_alg_template safexcel_alg_ctr_aes = {
+	.type = SAFEXCEL_ALG_TYPE_SKCIPHER,
+	.alg.skcipher = {
+		.setkey = safexcel_skcipher_aesctr_setkey,
+		.encrypt = safexcel_ctr_aes_encrypt,
+		.decrypt = safexcel_ctr_aes_decrypt,
+		/* Add 4 to include the 4 byte nonce! */
+		.min_keysize = AES_MIN_KEY_SIZE + 4,
+		.max_keysize = AES_MAX_KEY_SIZE + 4,
+		.ivsize = 8,
+		.base = {
+			.cra_name = "rfc3686(ctr(aes))",
+			.cra_driver_name = "safexcel-ctr-aes",
+			.cra_priority = 300,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_blocksize = 1,
+			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
+			.cra_alignmask = 0,
+			.cra_init = safexcel_skcipher_cra_init,
+			.cra_exit = safexcel_skcipher_cra_exit,
+			.cra_module = THIS_MODULE,
+		},
+	},
+};
+
 static int safexcel_cbc_des_encrypt(struct skcipher_request *req)
 {
 	return safexcel_queue_req(&req->base, skcipher_request_ctx(req),
-- 
1.8.3.1

