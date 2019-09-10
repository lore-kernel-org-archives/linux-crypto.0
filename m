Return-Path: <SRS0=06DT=XF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 329A2C49ED8
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Sep 2019 15:41:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E72FE2089F
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Sep 2019 15:41:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l2BfikLh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732044AbfIJPlI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Sep 2019 11:41:08 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:33292 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731756AbfIJPlI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Sep 2019 11:41:08 -0400
Received: by mail-ed1-f65.google.com with SMTP id o9so17604839edq.0
        for <linux-crypto@vger.kernel.org>; Tue, 10 Sep 2019 08:41:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=h5rC6c3u6OXYnh0yOdqdx0BRLUGsy9ufMYehEbUK5Mw=;
        b=l2BfikLhT+PK1wLcNhGzMdcNowhJj55JeuND6Oq4fMQwSqomT2QDwJobiqDIbq9cjT
         HC19BwMEeQ1YFaoqSimpN13pG4Bv36R8no9mmhroxuHqIgTGFWp8KraZKj6jlbxJOEUq
         LjIztNFrtT6o8bwCo1EgFVwJrSKtyyO/FjZ20cNzzCDbbUPITkbMLV96hleMXpAAJkQm
         JevaYArRD4HMrhFSDBeLuychN236yuE/JXVqAugewWLS26q6fqZ3L2WAPrJZuBOu3hN1
         GvywzrsF0YFDmmWIEA0yKrm/YT4LkZdJPIPCHA6TJ+3D6f2+zk366WgnyNOZP/TYv4Kg
         RPjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=h5rC6c3u6OXYnh0yOdqdx0BRLUGsy9ufMYehEbUK5Mw=;
        b=tTS0yrF9C6T8HezeLy9uh8PnFDKeFE3ONoqIqdNUtjCsGSQhw8dS2IJiClmuR39HD2
         mc2U6O+Nz+CEWiFskaSUG+JrQlNplwHH1IPkasvuFSC8yG73pnnzihDX98Sp9/wA0Jq2
         rSULZKBkXCkOsC53scDKlBExHMM224g2FVA2PluI7k9FdlwrJLOdnMIoGz4odMdBktBi
         yqkVIWFJ+sIzdaEC8BOGxQSRwhX+SPwlpk5M6UpAwfHcMll3UlRMF8EfQ0HxPmgshfSr
         fRNoHe89D40xBHotl46A2xg1Qn6+r4KTfIhka5XbXIzTZxD54DsIOE3E3YYnzrKyaHPL
         YWZw==
X-Gm-Message-State: APjAAAXP+LNM+E1gSwvr4lhtGUmzzapmjT7gTOziXCpczm8K+GbxK9Di
        76PW8juoB9Ucwp6qU8VCfxJZw4Y9
X-Google-Smtp-Source: APXvYqytUI1nuFVh3pZvGkt7ebbHC6q7RSak4MOlc7zbs5AlE6Ou2SjuwOpAcjfK5Yhr0VXYL1iLcA==
X-Received: by 2002:a17:906:2892:: with SMTP id o18mr16491092ejd.29.1568130062716;
        Tue, 10 Sep 2019 08:41:02 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id w14sm3676014eda.69.2019.09.10.08.41.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Sep 2019 08:41:01 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH 2/2] crypto: inside-secure - Add support for the Chacha20-Poly1305 AEAD
Date:   Tue, 10 Sep 2019 16:38:13 +0200
Message-Id: <1568126293-4039-3-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568126293-4039-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1568126293-4039-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds support for the Chacha20-Poly1305 cipher suite.
It adds both the basic rfc7539(chacha20,poly1305) as well as the
rfc7539esp(chacha20,poly1305) variant for IPsec ESP acceleration.

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel.c        |   2 +
 drivers/crypto/inside-secure/safexcel.h        |   8 +
 drivers/crypto/inside-secure/safexcel_cipher.c | 276 ++++++++++++++++++++++---
 3 files changed, 262 insertions(+), 24 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index fd9c9e7..5886bcd 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -1174,6 +1174,8 @@ static int safexcel_request_ring_irq(void *pdev, int irqid,
 	&safexcel_alg_xcbcmac,
 	&safexcel_alg_cmac,
 	&safexcel_alg_chacha20,
+	&safexcel_alg_chachapoly,
+	&safexcel_alg_chachapoly_esp,
 };
 
 static int safexcel_register_algorithms(struct safexcel_crypto_priv *priv)
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index c7f1a20..282d59e 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -373,6 +373,7 @@ struct safexcel_context_record {
 #define CONTEXT_CONTROL_CRYPTO_ALG_XCBC128	(0x1 << 23)
 #define CONTEXT_CONTROL_CRYPTO_ALG_XCBC192	(0x2 << 23)
 #define CONTEXT_CONTROL_CRYPTO_ALG_XCBC256	(0x3 << 23)
+#define CONTEXT_CONTROL_CRYPTO_ALG_POLY1305	(0xf << 23)
 #define CONTEXT_CONTROL_INV_FR			(0x5 << 24)
 #define CONTEXT_CONTROL_INV_TR			(0x6 << 24)
 
@@ -385,6 +386,7 @@ struct safexcel_context_record {
 #define CONTEXT_CONTROL_CRYPTO_MODE_CTR_LOAD	(6 << 0)
 #define CONTEXT_CONTROL_CRYPTO_MODE_XTS		(7 << 0)
 #define CONTEXT_CONTROL_CRYPTO_MODE_XCM		((6 << 0) | BIT(17))
+#define CONTEXT_CONTROL_CHACHA20_MODE_CALC_OTK	(12 << 0)
 #define CONTEXT_CONTROL_IV0			BIT(5)
 #define CONTEXT_CONTROL_IV1			BIT(6)
 #define CONTEXT_CONTROL_IV2			BIT(7)
@@ -397,6 +399,10 @@ struct safexcel_context_record {
 #define EIP197_XCM_MODE_GCM			1
 #define EIP197_XCM_MODE_CCM			2
 
+#define EIP197_AEAD_TYPE_IPSEC_ESP		2
+#define EIP197_AEAD_IPSEC_IV_SIZE		8
+#define EIP197_AEAD_IPSEC_NONCE_SIZE		4
+
 /* The hash counter given to the engine in the context has a granularity of
  * 64 bits.
  */
@@ -861,5 +867,7 @@ int safexcel_hmac_setkey(const char *alg, const u8 *key, unsigned int keylen,
 extern struct safexcel_alg_template safexcel_alg_xcbcmac;
 extern struct safexcel_alg_template safexcel_alg_cmac;
 extern struct safexcel_alg_template safexcel_alg_chacha20;
+extern struct safexcel_alg_template safexcel_alg_chachapoly;
+extern struct safexcel_alg_template safexcel_alg_chachapoly_esp;
 
 #endif
diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index 44dc13a..00bf220 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -17,6 +17,7 @@
 #include <crypto/des.h>
 #include <crypto/gcm.h>
 #include <crypto/ghash.h>
+#include <crypto/poly1305.h>
 #include <crypto/sha.h>
 #include <crypto/xts.h>
 #include <crypto/skcipher.h>
@@ -43,8 +44,8 @@ struct safexcel_cipher_ctx {
 
 	u32 mode;
 	enum safexcel_cipher_alg alg;
-	bool aead;
-	int  xcm; /* 0=authenc, 1=GCM, 2 reserved for CCM */
+	char aead; /* !=0=AEAD, 2=IPSec ESP AEAD */
+	char xcm;  /* 0=authenc, 1=GCM, 2 reserved for CCM */
 
 	__le32 key[16];
 	u32 nonce;
@@ -57,6 +58,7 @@ struct safexcel_cipher_ctx {
 	u32 opad[SHA512_DIGEST_SIZE / sizeof(u32)];
 
 	struct crypto_cipher *hkaes;
+	struct crypto_aead *fback;
 };
 
 struct safexcel_cipher_req {
@@ -86,10 +88,24 @@ static void safexcel_cipher_token(struct safexcel_cipher_ctx *ctx, u8 *iv,
 	} else if (ctx->alg == SAFEXCEL_CHACHA20) {
 		cdesc->control_data.options |= EIP197_OPTION_4_TOKEN_IV_CMD;
 
-		/* 96 bit nonce part */
-		memcpy(&cdesc->control_data.token[0], &iv[4], 12);
-		/* 32 bit counter */
-		cdesc->control_data.token[3] = *(u32 *)iv;
+		if (ctx->aead == EIP197_AEAD_TYPE_IPSEC_ESP) {
+			/* 32 bit nonce part */
+			cdesc->control_data.token[0] = ctx->nonce;
+			/* 64 bit IV part */
+			memcpy(&cdesc->control_data.token[1], iv, 8);
+			/* 32 bit counter, starting at 0 */
+			cdesc->control_data.token[3] = 0;
+		} else if (ctx->aead) {
+			/* 96 bit nonce part */
+			memcpy(&cdesc->control_data.token[0], iv, 12);
+			/* 32 bit counter, starting at 0 */
+			cdesc->control_data.token[3] = 0;
+		} else {
+			/* 96 bit nonce part */
+			memcpy(&cdesc->control_data.token[0], &iv[4], 12);
+			/* 32 bit counter */
+			cdesc->control_data.token[3] = *(u32 *)iv;
+		}
 
 		return;
 	} else if (ctx->xcm == EIP197_XCM_MODE_GCM) {
@@ -193,12 +209,20 @@ static void safexcel_aead_token(struct safexcel_cipher_ctx *ctx, u8 *iv,
 		token[13].instructions = EIP197_TOKEN_INS_TYPE_OUTPUT;
 	}
 
+	if (ctx->aead == EIP197_AEAD_TYPE_IPSEC_ESP) {
+		/* For ESP mode, skip over the IV */
+		token[7].opcode = EIP197_TOKEN_OPCODE_DIRECTION;
+		token[7].packet_length = EIP197_AEAD_IPSEC_IV_SIZE;
+
+		assoclen -= EIP197_AEAD_IPSEC_IV_SIZE;
+	}
+
 	token[6].opcode = EIP197_TOKEN_OPCODE_DIRECTION;
 	token[6].packet_length = assoclen;
+	token[6].instructions = EIP197_TOKEN_INS_LAST |
+				EIP197_TOKEN_INS_TYPE_HASH;
 
-	if (likely(cryptlen)) {
-		token[6].instructions = EIP197_TOKEN_INS_TYPE_HASH;
-
+	if (likely(cryptlen || ctx->alg == SAFEXCEL_CHACHA20)) {
 		token[10].opcode = EIP197_TOKEN_OPCODE_DIRECTION;
 		token[10].packet_length = cryptlen;
 		token[10].stat = EIP197_TOKEN_STAT_LAST_HASH;
@@ -208,8 +232,6 @@ static void safexcel_aead_token(struct safexcel_cipher_ctx *ctx, u8 *iv,
 					 EIP197_TOKEN_INS_TYPE_OUTPUT;
 	} else if (ctx->xcm != EIP197_XCM_MODE_CCM) {
 		token[6].stat = EIP197_TOKEN_STAT_LAST_HASH;
-		token[6].instructions = EIP197_TOKEN_INS_LAST |
-					EIP197_TOKEN_INS_TYPE_HASH;
 	}
 
 	if (!ctx->xcm)
@@ -224,10 +246,7 @@ static void safexcel_aead_token(struct safexcel_cipher_ctx *ctx, u8 *iv,
 	token[9].instructions = EIP197_TOKEN_INS_TYPE_OUTPUT |
 				EIP197_TOKEN_INS_TYPE_CRYPTO;
 
-	if (ctx->xcm == EIP197_XCM_MODE_GCM) {
-		token[6].instructions = EIP197_TOKEN_INS_LAST |
-					EIP197_TOKEN_INS_TYPE_HASH;
-	} else {
+	if (ctx->xcm != EIP197_XCM_MODE_GCM) {
 		u8 *cbcmaciv = (u8 *)&token[1];
 		u32 *aadlen = (u32 *)&token[5];
 
@@ -392,7 +411,7 @@ static int safexcel_aead_setkey(struct crypto_aead *ctfm, const u8 *key,
 			goto badkey;
 		break;
 	default:
-		dev_err(priv->dev, "aead: unsupported hash algorithm\n");
+		dev_err(priv->dev, "aead: unsupported hash algorithmn");
 		goto badkey;
 	}
 
@@ -440,6 +459,17 @@ static int safexcel_context_control(struct safexcel_cipher_ctx *ctx,
 				CONTEXT_CONTROL_DIGEST_XCM |
 				ctx->hash_alg |
 				CONTEXT_CONTROL_SIZE(ctrl_size);
+		} else if (ctx->alg == SAFEXCEL_CHACHA20) {
+			/* Chacha20-Poly1305 */
+			cdesc->control_data.control0 =
+				CONTEXT_CONTROL_KEY_EN |
+				CONTEXT_CONTROL_CRYPTO_ALG_CHACHA20 |
+				(sreq->direction == SAFEXCEL_ENCRYPT ?
+					CONTEXT_CONTROL_TYPE_ENCRYPT_HASH_OUT :
+					CONTEXT_CONTROL_TYPE_HASH_DECRYPT_IN) |
+				ctx->hash_alg |
+				CONTEXT_CONTROL_SIZE(ctrl_size);
+			return 0;
 		} else {
 			ctrl_size += ctx->state_sz / sizeof(u32) * 2;
 			cdesc->control_data.control0 =
@@ -2328,18 +2358,12 @@ struct safexcel_alg_template safexcel_alg_ccm = {
 	},
 };
 
-static int safexcel_skcipher_chacha20_setkey(struct crypto_skcipher *ctfm,
-					     const u8 *key, unsigned int len)
+static void safexcel_chacha20_setkey(struct safexcel_cipher_ctx *ctx,
+				     const u8 *key)
 {
-	struct safexcel_cipher_ctx *ctx = crypto_skcipher_ctx(ctfm);
 	struct safexcel_crypto_priv *priv = ctx->priv;
 	int i;
 
-	if (len != CHACHA_KEY_SIZE) {
-		crypto_skcipher_set_flags(ctfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
-		return -EINVAL;
-	}
-
 	if (priv->flags & EIP197_TRC_CACHE && ctx->base.ctxr_dma) {
 		for (i = 0; i < CHACHA_KEY_SIZE / sizeof(u32); i++) {
 			if (ctx->key[i] !=
@@ -2353,6 +2377,18 @@ static int safexcel_skcipher_chacha20_setkey(struct crypto_skcipher *ctfm,
 	for (i = 0; i < CHACHA_KEY_SIZE / sizeof(u32); i++)
 		ctx->key[i] = get_unaligned_le32(key + i * sizeof(u32));
 	ctx->key_len = CHACHA_KEY_SIZE;
+}
+
+static int safexcel_skcipher_chacha20_setkey(struct crypto_skcipher *ctfm,
+					     const u8 *key, unsigned int len)
+{
+	struct safexcel_cipher_ctx *ctx = crypto_skcipher_ctx(ctfm);
+
+	if (len != CHACHA_KEY_SIZE) {
+		crypto_skcipher_set_flags(ctfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	}
+	safexcel_chacha20_setkey(ctx, key);
 
 	return 0;
 }
@@ -2392,3 +2428,195 @@ struct safexcel_alg_template safexcel_alg_chacha20 = {
 		},
 	},
 };
+
+static int safexcel_aead_chachapoly_setkey(struct crypto_aead *ctfm,
+				    const u8 *key, unsigned int len)
+{
+	struct safexcel_cipher_ctx *ctx = crypto_aead_ctx(ctfm);
+
+	if (ctx->aead  == EIP197_AEAD_TYPE_IPSEC_ESP &&
+	    len > EIP197_AEAD_IPSEC_NONCE_SIZE) {
+		/* ESP variant has nonce appended to key */
+		len -= EIP197_AEAD_IPSEC_NONCE_SIZE;
+		ctx->nonce = *(u32 *)(key + len);
+	}
+	if (len != CHACHA_KEY_SIZE) {
+		crypto_aead_set_flags(ctfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	}
+	safexcel_chacha20_setkey(ctx, key);
+
+	return 0;
+}
+
+static int safexcel_aead_chachapoly_setauthsize(struct crypto_aead *tfm,
+					 unsigned int authsize)
+{
+	if (authsize != POLY1305_DIGEST_SIZE)
+		return -EINVAL;
+	return 0;
+}
+
+static int safexcel_aead_chachapoly_crypt(struct aead_request *req,
+					  enum safexcel_cipher_direction dir)
+{
+	struct safexcel_cipher_req *creq = aead_request_ctx(req);
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct crypto_tfm *tfm = crypto_aead_tfm(aead);
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct aead_request *subreq = aead_request_ctx(req);
+	u32 key[CHACHA_KEY_SIZE / sizeof(u32) + 1];
+	int i, ret = 0;
+
+	/*
+	 * Instead of wasting time detecting umpteen silly corner cases,
+	 * just dump all "small" requests to the fallback implementation.
+	 * HW would not be faster on such small requests anyway.
+	 */
+	if (likely(req->assoclen > EIP197_AEAD_IPSEC_IV_SIZE &&
+		   req->cryptlen >= POLY1305_DIGEST_SIZE)) {
+		return safexcel_queue_req(&req->base, creq, dir);
+	}
+
+	/* HW cannot do full (AAD+payload) zero length, use fallback */
+	for (i = 0; i < CHACHA_KEY_SIZE / sizeof(u32); i++)
+		key[i] = cpu_to_le32(ctx->key[i]);
+	if (ctx->aead == EIP197_AEAD_TYPE_IPSEC_ESP) {
+		/* ESP variant has nonce appended to the key */
+		key[CHACHA_KEY_SIZE / sizeof(u32)] = ctx->nonce;
+		ret = crypto_aead_setkey(ctx->fback, (u8 *)key,
+					 CHACHA_KEY_SIZE +
+					 EIP197_AEAD_IPSEC_NONCE_SIZE);
+	} else {
+		ret = crypto_aead_setkey(ctx->fback, (u8 *)key,
+					 CHACHA_KEY_SIZE);
+	}
+	if (ret) {
+		crypto_aead_clear_flags(aead, CRYPTO_TFM_REQ_MASK);
+		crypto_aead_set_flags(aead, crypto_aead_get_flags(ctx->fback) &
+					    CRYPTO_TFM_REQ_MASK);
+		return ret;
+	}
+
+	aead_request_set_tfm(subreq, ctx->fback);
+	aead_request_set_callback(subreq, req->base.flags, req->base.complete,
+				  req->base.data);
+	aead_request_set_crypt(subreq, req->src, req->dst, req->cryptlen,
+			       req->iv);
+	aead_request_set_ad(subreq, req->assoclen);
+
+	return (dir ==  SAFEXCEL_ENCRYPT) ?
+		crypto_aead_encrypt(subreq) :
+		crypto_aead_decrypt(subreq);
+}
+
+static int safexcel_aead_chachapoly_encrypt(struct aead_request *req)
+{
+	return safexcel_aead_chachapoly_crypt(req, SAFEXCEL_ENCRYPT);
+}
+
+static int safexcel_aead_chachapoly_decrypt(struct aead_request *req)
+{
+	return safexcel_aead_chachapoly_crypt(req, SAFEXCEL_DECRYPT);
+}
+
+static int safexcel_aead_chachapoly_cra_init(struct crypto_tfm *tfm)
+{
+	struct crypto_aead *aead = __crypto_aead_cast(tfm);
+	struct aead_alg *alg = crypto_aead_alg(aead);
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	safexcel_aead_cra_init(tfm);
+	ctx->alg  = SAFEXCEL_CHACHA20;
+	ctx->mode = CONTEXT_CONTROL_CHACHA20_MODE_256_32 |
+		    CONTEXT_CONTROL_CHACHA20_MODE_CALC_OTK;
+	ctx->hash_alg = CONTEXT_CONTROL_CRYPTO_ALG_POLY1305;
+	ctx->state_sz = 0; /* Precomputed by HW */
+
+	/* Allocate fallback implementation */
+	ctx->fback = crypto_alloc_aead(alg->base.cra_name, 0,
+				       CRYPTO_ALG_ASYNC |
+				       CRYPTO_ALG_NEED_FALLBACK);
+	if (IS_ERR(ctx->fback))
+		return PTR_ERR(ctx->fback);
+
+	crypto_aead_set_reqsize(aead, max(sizeof(struct safexcel_cipher_req),
+					  sizeof(struct aead_request) +
+					  crypto_aead_reqsize(ctx->fback)));
+
+	return 0;
+}
+
+static void safexcel_aead_chachapoly_cra_exit(struct crypto_tfm *tfm)
+{
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	crypto_free_aead(ctx->fback);
+	safexcel_aead_cra_exit(tfm);
+}
+
+struct safexcel_alg_template safexcel_alg_chachapoly = {
+	.type = SAFEXCEL_ALG_TYPE_AEAD,
+	.algo_mask = SAFEXCEL_ALG_CHACHA20 | SAFEXCEL_ALG_POLY1305,
+	.alg.aead = {
+		.setkey = safexcel_aead_chachapoly_setkey,
+		.setauthsize = safexcel_aead_chachapoly_setauthsize,
+		.encrypt = safexcel_aead_chachapoly_encrypt,
+		.decrypt = safexcel_aead_chachapoly_decrypt,
+		.ivsize = CHACHAPOLY_IV_SIZE,
+		.maxauthsize = POLY1305_DIGEST_SIZE,
+		.base = {
+			.cra_name = "rfc7539(chacha20,poly1305)",
+			.cra_driver_name = "safexcel-chacha20-poly1305",
+			/* +1 to put it above HW chacha + SW poly */
+			.cra_priority = SAFEXCEL_CRA_PRIORITY + 1,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY |
+				     CRYPTO_ALG_NEED_FALLBACK,
+			.cra_blocksize = 1,
+			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
+			.cra_alignmask = 0,
+			.cra_init = safexcel_aead_chachapoly_cra_init,
+			.cra_exit = safexcel_aead_chachapoly_cra_exit,
+			.cra_module = THIS_MODULE,
+		},
+	},
+};
+
+static int safexcel_aead_chachapolyesp_cra_init(struct crypto_tfm *tfm)
+{
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+	int ret;
+
+	ret = safexcel_aead_chachapoly_cra_init(tfm);
+	ctx->aead  = EIP197_AEAD_TYPE_IPSEC_ESP;
+	return ret;
+}
+
+struct safexcel_alg_template safexcel_alg_chachapoly_esp = {
+	.type = SAFEXCEL_ALG_TYPE_AEAD,
+	.algo_mask = SAFEXCEL_ALG_CHACHA20 | SAFEXCEL_ALG_POLY1305,
+	.alg.aead = {
+		.setkey = safexcel_aead_chachapoly_setkey,
+		.setauthsize = safexcel_aead_chachapoly_setauthsize,
+		.encrypt = safexcel_aead_chachapoly_encrypt,
+		.decrypt = safexcel_aead_chachapoly_decrypt,
+		.ivsize = CHACHAPOLY_IV_SIZE - EIP197_AEAD_IPSEC_NONCE_SIZE,
+		.maxauthsize = POLY1305_DIGEST_SIZE,
+		.base = {
+			.cra_name = "rfc7539esp(chacha20,poly1305)",
+			.cra_driver_name = "safexcel-chacha20-poly1305-esp",
+			/* +1 to put it above HW chacha + SW poly */
+			.cra_priority = SAFEXCEL_CRA_PRIORITY + 1,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY |
+				     CRYPTO_ALG_NEED_FALLBACK,
+			.cra_blocksize = 1,
+			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
+			.cra_alignmask = 0,
+			.cra_init = safexcel_aead_chachapolyesp_cra_init,
+			.cra_exit = safexcel_aead_chachapoly_cra_exit,
+			.cra_module = THIS_MODULE,
+		},
+	},
+};
-- 
1.8.3.1

