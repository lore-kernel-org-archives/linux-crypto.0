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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A3CBC46499
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jul 2019 07:53:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29F4520843
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jul 2019 07:53:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dLWHiX+H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbfGEHxM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 5 Jul 2019 03:53:12 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:44697 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725894AbfGEHxM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Jul 2019 03:53:12 -0400
Received: by mail-ed1-f67.google.com with SMTP id k8so7390225edr.11
        for <linux-crypto@vger.kernel.org>; Fri, 05 Jul 2019 00:53:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=dAIrQUNXz4sThzPed45ui7vlPENL1s9+05aSnqLSyls=;
        b=dLWHiX+HTU2Fk5pLT3I/8kJuR6Fe5KzSUx10rQYCD9AzR0nvN1Hy/CD1+z8FcWlP1e
         hPmXs1ch+pec5iCLyWGpXm+lsVuK4VXEGESvW8S7qYIu1ExzvbTHgxUBIjaCV5yqNvZs
         eB2SZDruHbwT2RpyRW1oPa7HrtU2m7ld0j5JKR7ZJAqPz9ee2EUcbE0h37J6uuJ+19oS
         1jJbFC5wHfHjnu94re7h0a3uBS33AWlKZvJ4Y0fNrwyXMU4836lmfs1n4tbrripLAemP
         Ips88UO+0nx+TVgoqinMrnjrl9tTpPbJbp2Rc+QreHGRUlyfiLSNlirLrT4VIY86j3SZ
         XvZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=dAIrQUNXz4sThzPed45ui7vlPENL1s9+05aSnqLSyls=;
        b=DAxmFRaUpYgazECwbG6KHSiI3iVKR3YgvMksBKrqaktVEA8CY1hYY/79tQw+jpptY7
         DQJeFTH0DJw8UVX0clGZYaeF1qDh4xVKwuhndh7YWQaxZTrGOGlT/bvHT4umNgs6YLQ0
         +RVXgHBXhk/TwmJ2NTJ+6yojJqIKBirS5mZRMNBdAasBtridhT2xxb5mZMaPf9j9hUvD
         Yw4+OeRQ15SkwFtbMFvUDkGOaO7FtyfRruD143uf4QUFqSFoplsRPsKWw2yXfYb67Y+t
         TqeVxTUUWiafTGvko9Sufk4gnU6J76Y41kmwuaazAR14K1YKEYGtfNa5w4bLLW1bB+90
         4TdQ==
X-Gm-Message-State: APjAAAVyJb1+fPWdjAPMLgCjyxwhLhKP8Shjp9vHm+uqCJ83Tu4NPN4D
        ljk1qlPXM7sLrOo7eclJzC6K2vFo
X-Google-Smtp-Source: APXvYqwaF1hk6NCgvQqaGfTFXcfVu9MvT3A64EUAV+/SuI22hy837As26cZYY1p6QPqTiVH1DJC+rQ==
X-Received: by 2002:a50:a56d:: with SMTP id z42mr2933564edb.241.1562313189632;
        Fri, 05 Jul 2019 00:53:09 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id z2sm1551438ejp.73.2019.07.05.00.53.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jul 2019 00:53:09 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH 3/3] crypto: inside-secure - add support for authenc(hmac(sha*),rfc3686(ctr(aes))) suites
Date:   Fri,  5 Jul 2019 08:49:24 +0200
Message-Id: <1562309364-942-4-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1562309364-942-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1562309364-942-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds support for the following AEAD ciphersuites:
- authenc(hmac(sha1),rfc3686(ctr(aes)))
- authenc(hmac(sha224),rfc3686(ctr(aes)))
- authenc(hmac(sha256),rfc3686(ctr(aes)))
- authenc(hmac(sha384),rfc3686(ctr(aes)))
- authenc(hmac(sha512),rfc3686(ctr(aes)))

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel.c        |  14 +-
 drivers/crypto/inside-secure/safexcel.h        |   5 +
 drivers/crypto/inside-secure/safexcel_cipher.c | 276 +++++++++++++++++++++----
 3 files changed, 250 insertions(+), 45 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 26f086b..ca84119 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -697,17 +697,18 @@ inline int safexcel_rdesc_check_errors(struct safexcel_crypto_priv *priv,
 	if (rdesc->buffer_overflow)
 		dev_err(priv->dev, "Buffer overflow detected");
 
-	if (rdesc->result_data.error_code & 0x4067) {
-		/* Fatal error (bits 0,1,2,5,6 & 14) */
+	if (rdesc->result_data.error_code & 0x4066) {
+		/* Fatal error (bits 1,2,5,6 & 14) */
 		dev_err(priv->dev,
 			"result descriptor error (%x)",
 			rdesc->result_data.error_code);
 		return -EIO;
 	} else if (rdesc->result_data.error_code &
-		   (BIT(7) | BIT(4) | BIT(3))) {
+		   (BIT(7) | BIT(4) | BIT(3) | BIT(0))) {
 		/*
 		 * Give priority over authentication fails:
-		 * Blocksize & overflow errors, something wrong with the input!
+		 * Blocksize, length & overflow errors,
+		 * something wrong with the input!
 		 */
 		return -EINVAL;
 	} else if (rdesc->result_data.error_code & BIT(9)) {
@@ -998,6 +999,11 @@ static int safexcel_request_ring_irq(void *pdev, int irqid,
 	&safexcel_alg_authenc_hmac_sha384_cbc_aes,
 	&safexcel_alg_authenc_hmac_sha512_cbc_aes,
 	&safexcel_alg_authenc_hmac_sha1_cbc_des3_ede,
+	&safexcel_alg_authenc_hmac_sha1_ctr_aes,
+	&safexcel_alg_authenc_hmac_sha224_ctr_aes,
+	&safexcel_alg_authenc_hmac_sha256_ctr_aes,
+	&safexcel_alg_authenc_hmac_sha384_ctr_aes,
+	&safexcel_alg_authenc_hmac_sha512_ctr_aes,
 };
 
 static int safexcel_register_algorithms(struct safexcel_crypto_priv *priv)
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index af71120..36657c3 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -740,5 +740,10 @@ int safexcel_hmac_setkey(const char *alg, const u8 *key, unsigned int keylen,
 extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha384_cbc_aes;
 extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha512_cbc_aes;
 extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha1_cbc_des3_ede;
+extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha1_ctr_aes;
+extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha224_ctr_aes;
+extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha256_ctr_aes;
+extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha384_ctr_aes;
+extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha512_ctr_aes;
 
 #endif
diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index 91945b1..1783483 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -58,11 +58,9 @@ struct safexcel_cipher_req {
 	int  nr_src, nr_dst;
 };
 
-static void safexcel_skcipher_token(struct safexcel_cipher_ctx *ctx, u8 *iv,
-				    struct safexcel_command_desc *cdesc,
-				    u32 length)
+static void safexcel_cipher_token(struct safexcel_cipher_ctx *ctx, u8 *iv,
+				  struct safexcel_command_desc *cdesc)
 {
-	struct safexcel_token *token;
 	u32 block_sz = 0;
 
 	if (ctx->mode != CONTEXT_CONTROL_CRYPTO_MODE_ECB) {
@@ -92,6 +90,15 @@ static void safexcel_skcipher_token(struct safexcel_cipher_ctx *ctx, u8 *iv,
 			memcpy(cdesc->control_data.token, iv, block_sz);
 		}
 	}
+}
+
+static void safexcel_skcipher_token(struct safexcel_cipher_ctx *ctx, u8 *iv,
+				    struct safexcel_command_desc *cdesc,
+				    u32 length)
+{
+	struct safexcel_token *token;
+
+	safexcel_cipher_token(ctx, iv, cdesc);
 
 	/* skip over worst case IV of 4 dwords, no need to be exact */
 	token = (struct safexcel_token *)(cdesc->control_data.token + 4);
@@ -111,26 +118,8 @@ static void safexcel_aead_token(struct safexcel_cipher_ctx *ctx, u8 *iv,
 				u32 cryptlen, u32 assoclen, u32 digestsize)
 {
 	struct safexcel_token *token;
-	u32 block_sz = 0;
 
-	if (ctx->mode != CONTEXT_CONTROL_CRYPTO_MODE_ECB) {
-		switch (ctx->alg) {
-		case SAFEXCEL_DES:
-			block_sz = DES_BLOCK_SIZE;
-			cdesc->control_data.options |= EIP197_OPTION_2_TOKEN_IV_CMD;
-			break;
-		case SAFEXCEL_3DES:
-			block_sz = DES3_EDE_BLOCK_SIZE;
-			cdesc->control_data.options |= EIP197_OPTION_2_TOKEN_IV_CMD;
-			break;
-		case SAFEXCEL_AES:
-			block_sz = AES_BLOCK_SIZE;
-			cdesc->control_data.options |= EIP197_OPTION_4_TOKEN_IV_CMD;
-			break;
-		}
-
-		memcpy(cdesc->control_data.token, iv, block_sz);
-	}
+	safexcel_cipher_token(ctx, iv, cdesc);
 
 	if (direction == SAFEXCEL_DECRYPT)
 		cryptlen -= digestsize;
@@ -165,18 +154,27 @@ static void safexcel_aead_token(struct safexcel_cipher_ctx *ctx, u8 *iv,
 		token[3].instructions = EIP197_TOKEN_INS_TYPE_OUTPUT;
 	}
 
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
+	if (unlikely(!cryptlen)) {
+		token[1].opcode = EIP197_TOKEN_OPCODE_DIRECTION;
+		token[1].packet_length = assoclen;
+		token[1].stat = EIP197_TOKEN_STAT_LAST_HASH;
+		token[1].instructions = EIP197_TOKEN_INS_LAST |
+					EIP197_TOKEN_INS_TYPE_HASH;
+	} else {
+		if (likely(assoclen)) {
+			token[0].opcode = EIP197_TOKEN_OPCODE_DIRECTION;
+			token[0].packet_length = assoclen;
+			token[0].instructions = EIP197_TOKEN_INS_TYPE_HASH;
+		}
 
+		token[1].opcode = EIP197_TOKEN_OPCODE_DIRECTION;
+		token[1].packet_length = cryptlen;
+		token[1].stat = EIP197_TOKEN_STAT_LAST_HASH;
+		token[1].instructions = EIP197_TOKEN_INS_LAST |
+					EIP197_TOKEN_INS_TYPE_CRYPTO |
+					EIP197_TOKEN_INS_TYPE_HASH |
+					EIP197_TOKEN_INS_TYPE_OUTPUT;
+	}
 }
 
 static int safexcel_skcipher_aes_setkey(struct crypto_skcipher *ctfm,
@@ -220,23 +218,43 @@ static int safexcel_aead_setkey(struct crypto_aead *ctfm, const u8 *key,
 	struct safexcel_ahash_export_state istate, ostate;
 	struct safexcel_crypto_priv *priv = ctx->priv;
 	struct crypto_authenc_keys keys;
+	struct crypto_aes_ctx aes;
 	u32 flags;
-	int err;
+	int err = -EINVAL;
 
 	if (crypto_authenc_extractkeys(&keys, key, len) != 0)
 		goto badkey;
 
-	if (keys.enckeylen > sizeof(ctx->key))
-		goto badkey;
+	if (ctx->mode == CONTEXT_CONTROL_CRYPTO_MODE_CTR_LOAD) {
+		/* 20 is minimum AES key: 16 bytes + 4 bytes nonce */
+		if (keys.enckeylen < 20)
+			goto badkey;
+		/* last 4 bytes of key are the nonce! */
+		ctx->nonce = *(u32 *)(keys.enckey + keys.enckeylen - 4);
+		/* exclude the nonce here */
+		keys.enckeylen -= 4;
+	}
 
 	/* Encryption key */
-	if (ctx->alg == SAFEXCEL_3DES) {
+	switch (ctx->alg) {
+	case SAFEXCEL_3DES:
+		if (keys.enckeylen != 24)
+			goto badkey;
 		flags = crypto_aead_get_flags(ctfm);
 		err = __des3_verify_key(&flags, keys.enckey);
 		crypto_aead_set_flags(ctfm, flags);
 
 		if (unlikely(err))
-			return err;
+			goto badkey_expflags;
+		break;
+	case SAFEXCEL_AES:
+		err = crypto_aes_expand_key(&aes, keys.enckey, keys.enckeylen);
+		if (unlikely(err))
+			goto badkey;
+		break;
+	default:
+		dev_err(priv->dev, "aead: unsupported cipher algorithm\n");
+		goto badkey;
 	}
 
 	if (priv->flags & EIP197_TRC_CACHE && ctx->base.ctxr_dma &&
@@ -295,8 +313,9 @@ static int safexcel_aead_setkey(struct crypto_aead *ctfm, const u8 *key,
 
 badkey:
 	crypto_aead_set_flags(ctfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+badkey_expflags:
 	memzero_explicit(&keys, sizeof(keys));
-	return -EINVAL;
+	return err;
 }
 
 static int safexcel_context_control(struct safexcel_cipher_ctx *ctx,
@@ -1386,6 +1405,7 @@ static int safexcel_aead_cra_init(struct crypto_tfm *tfm)
 
 	ctx->priv = tmpl->priv;
 
+	ctx->alg  = SAFEXCEL_AES; /* default */
 	ctx->aead = true;
 	ctx->base.send = safexcel_aead_send;
 	ctx->base.handle_result = safexcel_aead_handle_result;
@@ -1562,6 +1582,15 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha384_cbc_aes = {
 	},
 };
 
+static int safexcel_aead_sha1_des3_cra_init(struct crypto_tfm *tfm)
+{
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	safexcel_aead_sha1_cra_init(tfm);
+	ctx->alg = SAFEXCEL_3DES; /* override default */
+	return 0;
+}
+
 static int safexcel_aead_encrypt_3des(struct aead_request *req)
 {
 	struct safexcel_cipher_req *creq = aead_request_ctx(req);
@@ -1595,7 +1624,172 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha1_cbc_des3_ede = {
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
 			.cra_alignmask = 0,
-			.cra_init = safexcel_aead_sha1_cra_init,
+			.cra_init = safexcel_aead_sha1_des3_cra_init,
+			.cra_exit = safexcel_aead_cra_exit,
+			.cra_module = THIS_MODULE,
+		},
+	},
+};
+
+static int safexcel_aead_sha1_ctr_cra_init(struct crypto_tfm *tfm)
+{
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	safexcel_aead_sha1_cra_init(tfm);
+	ctx->mode = CONTEXT_CONTROL_CRYPTO_MODE_CTR_LOAD; /* override default */
+	return 0;
+}
+
+struct safexcel_alg_template safexcel_alg_authenc_hmac_sha1_ctr_aes = {
+	.type = SAFEXCEL_ALG_TYPE_AEAD,
+	.alg.aead = {
+		.setkey = safexcel_aead_setkey,
+		.encrypt = safexcel_aead_encrypt_aes,
+		.decrypt = safexcel_aead_decrypt_aes,
+		.ivsize = 8,
+		.maxauthsize = SHA1_DIGEST_SIZE,
+		.base = {
+			.cra_name = "authenc(hmac(sha1),rfc3686(ctr(aes)))",
+			.cra_driver_name = "safexcel-authenc-hmac-sha1-ctr-aes",
+			.cra_priority = 300,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_blocksize = 1,
+			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
+			.cra_alignmask = 0,
+			.cra_init = safexcel_aead_sha1_ctr_cra_init,
+			.cra_exit = safexcel_aead_cra_exit,
+			.cra_module = THIS_MODULE,
+		},
+	},
+};
+
+static int safexcel_aead_sha256_ctr_cra_init(struct crypto_tfm *tfm)
+{
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	safexcel_aead_sha256_cra_init(tfm);
+	ctx->mode = CONTEXT_CONTROL_CRYPTO_MODE_CTR_LOAD; /* override default */
+	return 0;
+}
+
+struct safexcel_alg_template safexcel_alg_authenc_hmac_sha256_ctr_aes = {
+	.type = SAFEXCEL_ALG_TYPE_AEAD,
+	.alg.aead = {
+		.setkey = safexcel_aead_setkey,
+		.encrypt = safexcel_aead_encrypt_aes,
+		.decrypt = safexcel_aead_decrypt_aes,
+		.ivsize = 8,
+		.maxauthsize = SHA256_DIGEST_SIZE,
+		.base = {
+			.cra_name = "authenc(hmac(sha256),rfc3686(ctr(aes)))",
+			.cra_driver_name = "safexcel-authenc-hmac-sha256-ctr-aes",
+			.cra_priority = 300,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_blocksize = 1,
+			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
+			.cra_alignmask = 0,
+			.cra_init = safexcel_aead_sha256_ctr_cra_init,
+			.cra_exit = safexcel_aead_cra_exit,
+			.cra_module = THIS_MODULE,
+		},
+	},
+};
+
+static int safexcel_aead_sha224_ctr_cra_init(struct crypto_tfm *tfm)
+{
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	safexcel_aead_sha224_cra_init(tfm);
+	ctx->mode = CONTEXT_CONTROL_CRYPTO_MODE_CTR_LOAD; /* override default */
+	return 0;
+}
+
+struct safexcel_alg_template safexcel_alg_authenc_hmac_sha224_ctr_aes = {
+	.type = SAFEXCEL_ALG_TYPE_AEAD,
+	.alg.aead = {
+		.setkey = safexcel_aead_setkey,
+		.encrypt = safexcel_aead_encrypt_aes,
+		.decrypt = safexcel_aead_decrypt_aes,
+		.ivsize = 8,
+		.maxauthsize = SHA224_DIGEST_SIZE,
+		.base = {
+			.cra_name = "authenc(hmac(sha224),rfc3686(ctr(aes)))",
+			.cra_driver_name = "safexcel-authenc-hmac-sha224-ctr-aes",
+			.cra_priority = 300,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_blocksize = 1,
+			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
+			.cra_alignmask = 0,
+			.cra_init = safexcel_aead_sha224_ctr_cra_init,
+			.cra_exit = safexcel_aead_cra_exit,
+			.cra_module = THIS_MODULE,
+		},
+	},
+};
+
+static int safexcel_aead_sha512_ctr_cra_init(struct crypto_tfm *tfm)
+{
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	safexcel_aead_sha512_cra_init(tfm);
+	ctx->mode = CONTEXT_CONTROL_CRYPTO_MODE_CTR_LOAD; /* override default */
+	return 0;
+}
+
+struct safexcel_alg_template safexcel_alg_authenc_hmac_sha512_ctr_aes = {
+	.type = SAFEXCEL_ALG_TYPE_AEAD,
+	.alg.aead = {
+		.setkey = safexcel_aead_setkey,
+		.encrypt = safexcel_aead_encrypt_aes,
+		.decrypt = safexcel_aead_decrypt_aes,
+		.ivsize = 8,
+		.maxauthsize = SHA512_DIGEST_SIZE,
+		.base = {
+			.cra_name = "authenc(hmac(sha512),rfc3686(ctr(aes)))",
+			.cra_driver_name = "safexcel-authenc-hmac-sha512-ctr-aes",
+			.cra_priority = 300,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_blocksize = 1,
+			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
+			.cra_alignmask = 0,
+			.cra_init = safexcel_aead_sha512_ctr_cra_init,
+			.cra_exit = safexcel_aead_cra_exit,
+			.cra_module = THIS_MODULE,
+		},
+	},
+};
+
+static int safexcel_aead_sha384_ctr_cra_init(struct crypto_tfm *tfm)
+{
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	safexcel_aead_sha384_cra_init(tfm);
+	ctx->mode = CONTEXT_CONTROL_CRYPTO_MODE_CTR_LOAD; /* override default */
+	return 0;
+}
+
+struct safexcel_alg_template safexcel_alg_authenc_hmac_sha384_ctr_aes = {
+	.type = SAFEXCEL_ALG_TYPE_AEAD,
+	.alg.aead = {
+		.setkey = safexcel_aead_setkey,
+		.encrypt = safexcel_aead_encrypt_aes,
+		.decrypt = safexcel_aead_decrypt_aes,
+		.ivsize = 8,
+		.maxauthsize = SHA384_DIGEST_SIZE,
+		.base = {
+			.cra_name = "authenc(hmac(sha384),rfc3686(ctr(aes)))",
+			.cra_driver_name = "safexcel-authenc-hmac-sha384-ctr-aes",
+			.cra_priority = 300,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_blocksize = 1,
+			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
+			.cra_alignmask = 0,
+			.cra_init = safexcel_aead_sha384_ctr_cra_init,
 			.cra_exit = safexcel_aead_cra_exit,
 			.cra_module = THIS_MODULE,
 		},
-- 
1.8.3.1

