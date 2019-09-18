Return-Path: <SRS0=f1VZ=XN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2357DC4CEC9
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Sep 2019 22:28:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA2AF21925
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Sep 2019 22:28:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ux3ztCPL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729512AbfIRW2y (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 18 Sep 2019 18:28:54 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:36198 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729033AbfIRW2y (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 18 Sep 2019 18:28:54 -0400
Received: by mail-ed1-f66.google.com with SMTP id h2so1402033edn.3
        for <linux-crypto@vger.kernel.org>; Wed, 18 Sep 2019 15:28:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=BoQbqNBKzxos1/+0RX5B4eSM4FgGWV5sOrXcQAYPS08=;
        b=ux3ztCPLDbLcHjcxwLya1qmrb0cTpMAOeTckm3Fz4gZUk9I50Ex8HOjpyQG3/aDTHi
         EEVCrS6a8Ye6np7hp9+WB1DICTRdqwcjxNsjKKTYLIjygb6K4/ViGMnkmNSAHJpZjo5F
         EaVGTo0hFxeD1MMrtb5wITEx8TNQpCXkJuCbhQKe6jlSrug7JZsvt5MkQnOgdKMfeYRJ
         a932+bzQMjxJHIniRBF9ysGN63U/jN6FvRBqK5+CdsoHg6yMAUJQETyc8CVpahPRvwHp
         /wToUrT/sY2dMKICCrqY/AT3pjBAGvd8GY30ikXNAHGx1iZlLNW+DUf6oLn7wH2iVwY5
         U0+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=BoQbqNBKzxos1/+0RX5B4eSM4FgGWV5sOrXcQAYPS08=;
        b=e+hPU/sHbgwVLH0I8qNYo+sWN1GV8411tLoBKLTsVCBL6CIDkcFkMsUVFjWJHrwEdq
         azGMHUqCnZw5tim14oeGyT69J/n0SPNEsAdROpWv0hfwS6WGLK7oBOBJav2rffQwtid5
         3BNXhsp24/g9GG/KtLPQup1cKV/4QAi56jnsmu8DBwx+KdKnd6lCBumdXjL78mhHCN+b
         zKZGgqfv4bj5WAmWLVqZ6SHteYGotIKKSyW/1lHrHNQq1nbZPpxxMeEWVncYabeLaG8G
         vKag51R6gpLsGZbWeJ1+qzAsE4vZvRuKG1WJXxE7f+aq36zVQn4WrcNANSdXFncXjXlw
         9KWw==
X-Gm-Message-State: APjAAAU52WBfdvlCMPxSfa1qos4km2TVYZ/eJ3nUa5Gv2gfhTotAXtCp
        LSgjS4jBhBIDXhATi4sbRMPIRD1R
X-Google-Smtp-Source: APXvYqxj3YE4QDtXcYzSWlce0uiEgbxLwD9vB2F9NRUIcK8iezmeDzhG4zNBwK9sbZDQTAaSp5BFlw==
X-Received: by 2002:a05:6402:2054:: with SMTP id bc20mr13372277edb.55.1568845731480;
        Wed, 18 Sep 2019 15:28:51 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id a3sm811951eje.90.2019.09.18.15.28.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Sep 2019 15:28:50 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCHv4 2/3] crypto: inside-secure - Add support for the Chacha20-Poly1305 AEAD
Date:   Wed, 18 Sep 2019 23:25:57 +0200
Message-Id: <1568841958-14622-3-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568841958-14622-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1568841958-14622-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds support for the Chacha20-Poly1305 cipher suite.
It adds both the basic rfc7539(chacha20,poly1305) as well as the
rfc7539esp(chacha20,poly1305) variant for IPsec ESP acceleration.

changes since v1:
- rebased on top of DES library changes done on cryptodev/master
- fixed crypto/Kconfig so that generic fallback is compiled as well

changes since v2:
- nothing

changes since v3:
- Fixed a problem where the tcrypt performance test would run fully on the
  fallback cipher instead of the HW due to using an AAD length of 8 for
  rfc7539esp. While this is not actually legal ESP (which includes SPI and
  sequence number in the AAD as well), it is both inconvenient and not
  necessary to run these vectors on the fallback cipher.
- Due to above, also realised that for plain (non-ESP) rfc7539, you
  probably want to be able to run vectors with less than 8 bytes of AAD
  on the HW, and this is actually possible as long as cryptlen is large
  enough, so made that possible as well.

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel.c        |   2 +
 drivers/crypto/inside-secure/safexcel.h        |   8 +
 drivers/crypto/inside-secure/safexcel_cipher.c | 277 ++++++++++++++++++++++---
 3 files changed, 263 insertions(+), 24 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index f958c92..b81f0bc 100644
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
index 15d98a9..f1e6cae 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -17,6 +17,7 @@
 #include <crypto/internal/des.h>
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
@@ -195,12 +211,20 @@ static void safexcel_aead_token(struct safexcel_cipher_ctx *ctx, u8 *iv,
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
@@ -210,8 +234,6 @@ static void safexcel_aead_token(struct safexcel_cipher_ctx *ctx, u8 *iv,
 					 EIP197_TOKEN_INS_TYPE_OUTPUT;
 	} else if (ctx->xcm != EIP197_XCM_MODE_CCM) {
 		token[6].stat = EIP197_TOKEN_STAT_LAST_HASH;
-		token[6].instructions = EIP197_TOKEN_INS_LAST |
-					EIP197_TOKEN_INS_TYPE_HASH;
 	}

 	if (!ctx->xcm)
@@ -226,10 +248,7 @@ static void safexcel_aead_token(struct safexcel_cipher_ctx *ctx, u8 *iv,
 	token[9].instructions = EIP197_TOKEN_INS_TYPE_OUTPUT |
 				EIP197_TOKEN_INS_TYPE_CRYPTO;

-	if (ctx->xcm == EIP197_XCM_MODE_GCM) {
-		token[6].instructions = EIP197_TOKEN_INS_LAST |
-					EIP197_TOKEN_INS_TYPE_HASH;
-	} else {
+	if (ctx->xcm != EIP197_XCM_MODE_GCM) {
 		u8 *cbcmaciv = (u8 *)&token[1];
 		u32 *aadlen = (u32 *)&token[5];

@@ -388,7 +407,7 @@ static int safexcel_aead_setkey(struct crypto_aead *ctfm, const u8 *key,
 			goto badkey;
 		break;
 	default:
-		dev_err(priv->dev, "aead: unsupported hash algorithm\n");
+		dev_err(priv->dev, "aead: unsupported hash algorithmn");
 		goto badkey;
 	}

@@ -436,6 +455,17 @@ static int safexcel_context_control(struct safexcel_cipher_ctx *ctx,
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
@@ -2320,18 +2350,12 @@ struct safexcel_alg_template safexcel_alg_ccm = {
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
@@ -2345,6 +2369,18 @@ static int safexcel_skcipher_chacha20_setkey(struct crypto_skcipher *ctfm,
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
@@ -2384,3 +2420,196 @@ struct safexcel_alg_template safexcel_alg_chacha20 = {
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
+	if (likely((ctx->aead != EIP197_AEAD_TYPE_IPSEC_ESP ||
+		    req->assoclen >= EIP197_AEAD_IPSEC_IV_SIZE) &&
+		   req->cryptlen > POLY1305_DIGEST_SIZE)) {
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
