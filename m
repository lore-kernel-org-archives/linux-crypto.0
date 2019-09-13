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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6F61C4CEC8
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 19:47:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5775320830
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 19:47:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OhWTx4BS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387739AbfIMTrm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Sep 2019 15:47:42 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:41444 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388030AbfIMTrl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Sep 2019 15:47:41 -0400
Received: by mail-ed1-f65.google.com with SMTP id z9so28007029edq.8
        for <linux-crypto@vger.kernel.org>; Fri, 13 Sep 2019 12:47:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=xY74n20zdaQtxdZzW5WKGRjb1iqdoPqxmin5F/SNkS0=;
        b=OhWTx4BSxsJuhsZIN3sM++kOZjsif+sOBJmQj7y6K9LrlBgatvDbgFntxtToa7smzp
         M3W7EXjJQv5AC7vEEv/tioUiliiMH8sODIZ8E4yKZK04RnXeGRfFtlRkOQ8F1Nn13cTA
         FnuW83q9Smh5kcvR/jyOQ8fjckP/FXf35/iVWF8HJe3wfpO6KPysTiUy5FhqQ/5RSeUW
         HKVhtCPzG+qsXlRvoCj2sDqTB3gbe7PS2C82HhC3otjLS0+4DmveZlCurOiiV02inb7H
         vYLSkkRPQ9/dk2QM1QlZwvW1HVqVX27IAYs+nDyktKMd9hLx2nQAU8pH/6slrkgcSps9
         maWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=xY74n20zdaQtxdZzW5WKGRjb1iqdoPqxmin5F/SNkS0=;
        b=Ay+T5O8z7KN4EyXtik1f04dR8/cg3LVdL/F8GOyorexLMRfW5Bc19RNlTfdAerCVTG
         Jf+qUyJVZY56qXbNHb4NByrPA8RbNYIhquoKib6siQyhC5MI9WKoFa7nS9M5czIRaZcR
         pwP3b1mFRghY8yoVluMsi+t1f7lYGpy4wwFJGRYvfXKo53tH9gDmd6DRfBYZBjeQufp2
         6v/X4LI0Q6JnJ/ewGYx0XgjIEMQ9z7AfRdDh12AYYMGSNXQ51/tc7EGTKFuJHRLnfDi0
         DkznIzQdNBKVEi7py+kWw9a+vZnq0JmH84jMMytLIyDZONJUCrnii7e+onJ0VUA+AfF+
         UZOA==
X-Gm-Message-State: APjAAAUFv75Ef/ZikchfouLycmD04CAT8llrnj7Wc+OWb9p6/9iKFUwa
        Eqkz3qWSoeynCLUMkoH85Vu7/Ib7
X-Google-Smtp-Source: APXvYqyrJYBbBebez3Ov8SRiQ/hNqzc/6hNJNHfIMzRevz3E9OAMdg17mibmgo5xlZtOIoQ00xxYKA==
X-Received: by 2002:aa7:d755:: with SMTP id a21mr49014785eds.18.1568404059200;
        Fri, 13 Sep 2019 12:47:39 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id c32sm5299412eda.97.2019.09.13.12.47.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Sep 2019 12:47:38 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH] crypto: inside-secure - Add SM4 based authenc AEAD ciphersuites
Date:   Fri, 13 Sep 2019 20:44:50 +0200
Message-Id: <1568400290-5208-1-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds support for the authenc(hmac(sha1),cbc(sm4)),
authenc(hmac(sm3),cbc(sm4)), authenc(hmac(sha1),rfc3686(ctr(sm4))),
and authenc(hmac(sm3),rfc3686(ctr(sm4))) aead ciphersuites.
These are necessary to support IPsec according to the Chinese standard
GM/T 022-1014 - IPsec VPN specification.

Note that there are no testvectors present in testmgr for these
ciphersuites. However, considering all building blocks have already been
verified elsewhere, it is fair to assume the generic implementation to be
correct-by-construction.
The hardware implementation has been fuzzed against this generic
implementation by means of a locally modified testmgr. The intention is
to upstream these testmgr changes but this is pending other testmgr changes
being made by Eric Biggers.

The patch has been tested with the eip197c_iewxkbc configuration on the
Xilinx VCU118 development board, using the abovementioned modified testmgr

This patch applies on top of "Add support for SM4 ciphers" and needs to
be applied before "Add (HMAC) SHA3 support".

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel.c        |   4 +
 drivers/crypto/inside-secure/safexcel.h        |   4 +
 drivers/crypto/inside-secure/safexcel_cipher.c | 280 +++++++++++++++++++++++--
 3 files changed, 274 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 3c140d8..8f7fdd0 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -1183,6 +1183,10 @@ static int safexcel_request_ring_irq(void *pdev, int irqid,
 	&safexcel_alg_ofb_sm4,
 	&safexcel_alg_cfb_sm4,
 	&safexcel_alg_ctr_sm4,
+	&safexcel_alg_authenc_hmac_sha1_cbc_sm4,
+	&safexcel_alg_authenc_hmac_sm3_cbc_sm4,
+	&safexcel_alg_authenc_hmac_sha1_ctr_sm4,
+	&safexcel_alg_authenc_hmac_sm3_ctr_sm4,
 };
 
 static int safexcel_register_algorithms(struct safexcel_crypto_priv *priv)
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index 62965fb..1d75044 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -884,5 +884,9 @@ int safexcel_hmac_setkey(const char *alg, const u8 *key, unsigned int keylen,
 extern struct safexcel_alg_template safexcel_alg_ofb_sm4;
 extern struct safexcel_alg_template safexcel_alg_cfb_sm4;
 extern struct safexcel_alg_template safexcel_alg_ctr_sm4;
+extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha1_cbc_sm4;
+extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sm3_cbc_sm4;
+extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha1_ctr_sm4;
+extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sm3_ctr_sm4;
 
 #endif
diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index a00f84b..616c214 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -19,6 +19,7 @@
 #include <crypto/ghash.h>
 #include <crypto/poly1305.h>
 #include <crypto/sha.h>
+#include <crypto/sm3.h>
 #include <crypto/sm4.h>
 #include <crypto/xts.h>
 #include <crypto/skcipher.h>
@@ -349,19 +350,18 @@ static int safexcel_aead_setkey(struct crypto_aead *ctfm, const u8 *key,
 	struct crypto_aes_ctx aes;
 	int err = -EINVAL;
 
-	if (crypto_authenc_extractkeys(&keys, key, len) != 0)
+	if (unlikely(crypto_authenc_extractkeys(&keys, key, len)))
 		goto badkey;
 
 	if (ctx->mode == CONTEXT_CONTROL_CRYPTO_MODE_CTR_LOAD) {
-		/* Minimum keysize is minimum AES key size + nonce size */
-		if (keys.enckeylen < (AES_MIN_KEY_SIZE +
-				      CTR_RFC3686_NONCE_SIZE))
+		/* Must have at least space for the nonce here */
+		if (unlikely(keys.enckeylen < CTR_RFC3686_NONCE_SIZE))
 			goto badkey;
 		/* last 4 bytes of key are the nonce! */
 		ctx->nonce = *(u32 *)(keys.enckey + keys.enckeylen -
 				      CTR_RFC3686_NONCE_SIZE);
 		/* exclude the nonce here */
-		keys.enckeylen -= CONTEXT_CONTROL_CRYPTO_MODE_CTR_LOAD;
+		keys.enckeylen -= CTR_RFC3686_NONCE_SIZE;
 	}
 
 	/* Encryption key */
@@ -376,6 +376,10 @@ static int safexcel_aead_setkey(struct crypto_aead *ctfm, const u8 *key,
 		if (unlikely(err))
 			goto badkey;
 		break;
+	case SAFEXCEL_SM4:
+		if (unlikely(keys.enckeylen != SM4_KEY_SIZE))
+			goto badkey;
+		break;
 	default:
 		dev_err(priv->dev, "aead: unsupported cipher algorithm\n");
 		goto badkey;
@@ -412,6 +416,11 @@ static int safexcel_aead_setkey(struct crypto_aead *ctfm, const u8 *key,
 					 keys.authkeylen, &istate, &ostate))
 			goto badkey;
 		break;
+	case CONTEXT_CONTROL_CRYPTO_ALG_SM3:
+		if (safexcel_hmac_setkey("safexcel-sm3", keys.authkey,
+					 keys.authkeylen, &istate, &ostate))
+			goto badkey;
+		break;
 	default:
 		dev_err(priv->dev, "aead: unsupported hash algorithmn");
 		goto badkey;
@@ -2521,18 +2530,13 @@ static int safexcel_aead_chachapoly_decrypt(struct aead_request *req)
 	return safexcel_aead_chachapoly_crypt(req, SAFEXCEL_DECRYPT);
 }
 
-static int safexcel_aead_chachapoly_cra_init(struct crypto_tfm *tfm)
+static int safexcel_aead_fallback_cra_init(struct crypto_tfm *tfm)
 {
 	struct crypto_aead *aead = __crypto_aead_cast(tfm);
 	struct aead_alg *alg = crypto_aead_alg(aead);
 	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
 
 	safexcel_aead_cra_init(tfm);
-	ctx->alg  = SAFEXCEL_CHACHA20;
-	ctx->mode = CONTEXT_CONTROL_CHACHA20_MODE_256_32 |
-		    CONTEXT_CONTROL_CHACHA20_MODE_CALC_OTK;
-	ctx->hash_alg = CONTEXT_CONTROL_CRYPTO_ALG_POLY1305;
-	ctx->state_sz = 0; /* Precomputed by HW */
 
 	/* Allocate fallback implementation */
 	ctx->fback = crypto_alloc_aead(alg->base.cra_name, 0,
@@ -2548,7 +2552,20 @@ static int safexcel_aead_chachapoly_cra_init(struct crypto_tfm *tfm)
 	return 0;
 }
 
-static void safexcel_aead_chachapoly_cra_exit(struct crypto_tfm *tfm)
+static int safexcel_aead_chachapoly_cra_init(struct crypto_tfm *tfm)
+{
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	safexcel_aead_fallback_cra_init(tfm);
+	ctx->alg  = SAFEXCEL_CHACHA20;
+	ctx->mode = CONTEXT_CONTROL_CHACHA20_MODE_256_32 |
+		    CONTEXT_CONTROL_CHACHA20_MODE_CALC_OTK;
+	ctx->hash_alg = CONTEXT_CONTROL_CRYPTO_ALG_POLY1305;
+	ctx->state_sz = 0; /* Precomputed by HW */
+	return 0;
+}
+
+static void safexcel_aead_fallback_cra_exit(struct crypto_tfm *tfm)
 {
 	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
 
@@ -2578,7 +2595,7 @@ struct safexcel_alg_template safexcel_alg_chachapoly = {
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
 			.cra_alignmask = 0,
 			.cra_init = safexcel_aead_chachapoly_cra_init,
-			.cra_exit = safexcel_aead_chachapoly_cra_exit,
+			.cra_exit = safexcel_aead_fallback_cra_exit,
 			.cra_module = THIS_MODULE,
 		},
 	},
@@ -2616,7 +2633,7 @@ struct safexcel_alg_template safexcel_alg_chachapoly_esp = {
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
 			.cra_alignmask = 0,
 			.cra_init = safexcel_aead_chachapolyesp_cra_init,
-			.cra_exit = safexcel_aead_chachapoly_cra_exit,
+			.cra_exit = safexcel_aead_fallback_cra_exit,
 			.cra_module = THIS_MODULE,
 		},
 	},
@@ -2865,3 +2882,238 @@ struct safexcel_alg_template safexcel_alg_ctr_sm4 = {
 		},
 	},
 };
+
+static int safexcel_aead_sm4_blk_encrypt(struct aead_request *req)
+{
+	/* Workaround for HW bug: EIP96 4.3 does not report blocksize error */
+	if (req->cryptlen & (SM4_BLOCK_SIZE - 1))
+		return -EINVAL;
+
+	return safexcel_queue_req(&req->base, aead_request_ctx(req),
+				  SAFEXCEL_ENCRYPT);
+}
+
+static int safexcel_aead_sm4_blk_decrypt(struct aead_request *req)
+{
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+
+	/* Workaround for HW bug: EIP96 4.3 does not report blocksize error */
+	if ((req->cryptlen - crypto_aead_authsize(tfm)) & (SM4_BLOCK_SIZE - 1))
+		return -EINVAL;
+
+	return safexcel_queue_req(&req->base, aead_request_ctx(req),
+				  SAFEXCEL_DECRYPT);
+}
+
+static int safexcel_aead_sm4cbc_sha1_cra_init(struct crypto_tfm *tfm)
+{
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	safexcel_aead_cra_init(tfm);
+	ctx->alg = SAFEXCEL_SM4;
+	ctx->hash_alg = CONTEXT_CONTROL_CRYPTO_ALG_SHA1;
+	ctx->state_sz = SHA1_DIGEST_SIZE;
+	return 0;
+}
+
+struct safexcel_alg_template safexcel_alg_authenc_hmac_sha1_cbc_sm4 = {
+	.type = SAFEXCEL_ALG_TYPE_AEAD,
+	.algo_mask = SAFEXCEL_ALG_SM4 | SAFEXCEL_ALG_SHA1,
+	.alg.aead = {
+		.setkey = safexcel_aead_setkey,
+		.encrypt = safexcel_aead_sm4_blk_encrypt,
+		.decrypt = safexcel_aead_sm4_blk_decrypt,
+		.ivsize = SM4_BLOCK_SIZE,
+		.maxauthsize = SHA1_DIGEST_SIZE,
+		.base = {
+			.cra_name = "authenc(hmac(sha1),cbc(sm4))",
+			.cra_driver_name = "safexcel-authenc-hmac-sha1-cbc-sm4",
+			.cra_priority = SAFEXCEL_CRA_PRIORITY,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_blocksize = SM4_BLOCK_SIZE,
+			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
+			.cra_alignmask = 0,
+			.cra_init = safexcel_aead_sm4cbc_sha1_cra_init,
+			.cra_exit = safexcel_aead_cra_exit,
+			.cra_module = THIS_MODULE,
+		},
+	},
+};
+
+static int safexcel_aead_fallback_setkey(struct crypto_aead *ctfm,
+					 const u8 *key, unsigned int len)
+{
+	struct crypto_tfm *tfm = crypto_aead_tfm(ctfm);
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	/* Keep fallback cipher synchronized */
+	return crypto_aead_setkey(ctx->fback, (u8 *)key, len) ?:
+	       safexcel_aead_setkey(ctfm, key, len);
+}
+
+static int safexcel_aead_fallback_setauthsize(struct crypto_aead *ctfm,
+					      unsigned int authsize)
+{
+	struct crypto_tfm *tfm = crypto_aead_tfm(ctfm);
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	/* Keep fallback cipher synchronized */
+	return crypto_aead_setauthsize(ctx->fback, authsize);
+}
+
+static int safexcel_aead_fallback_crypt(struct aead_request *req,
+					enum safexcel_cipher_direction dir)
+{
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct crypto_tfm *tfm = crypto_aead_tfm(aead);
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct aead_request *subreq = aead_request_ctx(req);
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
+static int safexcel_aead_sm4cbc_sm3_encrypt(struct aead_request *req)
+{
+	struct safexcel_cipher_req *creq = aead_request_ctx(req);
+
+	/* Workaround for HW bug: EIP96 4.3 does not report blocksize error */
+	if (req->cryptlen & (SM4_BLOCK_SIZE - 1))
+		return -EINVAL;
+	else if (req->cryptlen || req->assoclen) /* If input length > 0 only */
+		return safexcel_queue_req(&req->base, creq, SAFEXCEL_ENCRYPT);
+
+	/* HW cannot do full (AAD+payload) zero length, use fallback */
+	return safexcel_aead_fallback_crypt(req, SAFEXCEL_ENCRYPT);
+}
+
+static int safexcel_aead_sm4cbc_sm3_decrypt(struct aead_request *req)
+{
+	struct safexcel_cipher_req *creq = aead_request_ctx(req);
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+
+	/* Workaround for HW bug: EIP96 4.3 does not report blocksize error */
+	if ((req->cryptlen - crypto_aead_authsize(tfm)) & (SM4_BLOCK_SIZE - 1))
+		return -EINVAL;
+	else if (req->cryptlen > crypto_aead_authsize(tfm) || req->assoclen)
+		/* If input length > 0 only */
+		return safexcel_queue_req(&req->base, creq, SAFEXCEL_DECRYPT);
+
+	/* HW cannot do full (AAD+payload) zero length, use fallback */
+	return safexcel_aead_fallback_crypt(req, SAFEXCEL_DECRYPT);
+}
+
+static int safexcel_aead_sm4cbc_sm3_cra_init(struct crypto_tfm *tfm)
+{
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	safexcel_aead_fallback_cra_init(tfm);
+	ctx->alg = SAFEXCEL_SM4;
+	ctx->hash_alg = CONTEXT_CONTROL_CRYPTO_ALG_SM3;
+	ctx->state_sz = SM3_DIGEST_SIZE;
+	return 0;
+}
+
+struct safexcel_alg_template safexcel_alg_authenc_hmac_sm3_cbc_sm4 = {
+	.type = SAFEXCEL_ALG_TYPE_AEAD,
+	.algo_mask = SAFEXCEL_ALG_SM4 | SAFEXCEL_ALG_SM3,
+	.alg.aead = {
+		.setkey = safexcel_aead_fallback_setkey,
+		.setauthsize = safexcel_aead_fallback_setauthsize,
+		.encrypt = safexcel_aead_sm4cbc_sm3_encrypt,
+		.decrypt = safexcel_aead_sm4cbc_sm3_decrypt,
+		.ivsize = SM4_BLOCK_SIZE,
+		.maxauthsize = SM3_DIGEST_SIZE,
+		.base = {
+			.cra_name = "authenc(hmac(sm3),cbc(sm4))",
+			.cra_driver_name = "safexcel-authenc-hmac-sm3-cbc-sm4",
+			.cra_priority = SAFEXCEL_CRA_PRIORITY,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY |
+				     CRYPTO_ALG_NEED_FALLBACK,
+			.cra_blocksize = SM4_BLOCK_SIZE,
+			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
+			.cra_alignmask = 0,
+			.cra_init = safexcel_aead_sm4cbc_sm3_cra_init,
+			.cra_exit = safexcel_aead_fallback_cra_exit,
+			.cra_module = THIS_MODULE,
+		},
+	},
+};
+
+static int safexcel_aead_sm4ctr_sha1_cra_init(struct crypto_tfm *tfm)
+{
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	safexcel_aead_sm4cbc_sha1_cra_init(tfm);
+	ctx->mode = CONTEXT_CONTROL_CRYPTO_MODE_CTR_LOAD;
+	return 0;
+}
+
+struct safexcel_alg_template safexcel_alg_authenc_hmac_sha1_ctr_sm4 = {
+	.type = SAFEXCEL_ALG_TYPE_AEAD,
+	.algo_mask = SAFEXCEL_ALG_SM4 | SAFEXCEL_ALG_SHA1,
+	.alg.aead = {
+		.setkey = safexcel_aead_setkey,
+		.encrypt = safexcel_aead_encrypt,
+		.decrypt = safexcel_aead_decrypt,
+		.ivsize = CTR_RFC3686_IV_SIZE,
+		.maxauthsize = SHA1_DIGEST_SIZE,
+		.base = {
+			.cra_name = "authenc(hmac(sha1),rfc3686(ctr(sm4)))",
+			.cra_driver_name = "safexcel-authenc-hmac-sha1-ctr-sm4",
+			.cra_priority = SAFEXCEL_CRA_PRIORITY,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_blocksize = 1,
+			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
+			.cra_alignmask = 0,
+			.cra_init = safexcel_aead_sm4ctr_sha1_cra_init,
+			.cra_exit = safexcel_aead_cra_exit,
+			.cra_module = THIS_MODULE,
+		},
+	},
+};
+
+static int safexcel_aead_sm4ctr_sm3_cra_init(struct crypto_tfm *tfm)
+{
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	safexcel_aead_sm4cbc_sm3_cra_init(tfm);
+	ctx->mode = CONTEXT_CONTROL_CRYPTO_MODE_CTR_LOAD;
+	return 0;
+}
+
+struct safexcel_alg_template safexcel_alg_authenc_hmac_sm3_ctr_sm4 = {
+	.type = SAFEXCEL_ALG_TYPE_AEAD,
+	.algo_mask = SAFEXCEL_ALG_SM4 | SAFEXCEL_ALG_SM3,
+	.alg.aead = {
+		.setkey = safexcel_aead_setkey,
+		.encrypt = safexcel_aead_encrypt,
+		.decrypt = safexcel_aead_decrypt,
+		.ivsize = CTR_RFC3686_IV_SIZE,
+		.maxauthsize = SM3_DIGEST_SIZE,
+		.base = {
+			.cra_name = "authenc(hmac(sm3),rfc3686(ctr(sm4)))",
+			.cra_driver_name = "safexcel-authenc-hmac-sm3-ctr-sm4",
+			.cra_priority = SAFEXCEL_CRA_PRIORITY,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_blocksize = 1,
+			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
+			.cra_alignmask = 0,
+			.cra_init = safexcel_aead_sm4ctr_sm3_cra_init,
+			.cra_exit = safexcel_aead_cra_exit,
+			.cra_module = THIS_MODULE,
+		},
+	},
+};
-- 
1.8.3.1

