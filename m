Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CB5CC433E6
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Feb 2021 18:29:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D0F864F21
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Feb 2021 18:29:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233502AbhBYS3n (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Feb 2021 13:29:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232394AbhBYS3B (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Feb 2021 13:29:01 -0500
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53173C06121D
        for <linux-crypto@vger.kernel.org>; Thu, 25 Feb 2021 10:27:24 -0800 (PST)
Received: by mail-qv1-xf34.google.com with SMTP id 2so3270172qvd.0
        for <linux-crypto@vger.kernel.org>; Thu, 25 Feb 2021 10:27:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=K8qzTDRvDqE8beEmzlw5Ro8ITdxfmMURdYMnM5S+IyE=;
        b=h+Q1XSl04Nzrd+2U2F0w6/LaJqEAvLRf+WZmIxdkjyk1DLN1dygniaGYvNl0sVQ0FM
         AOj99fJI8uTPVhfy38PSj6uBbnmvPnsOYC0aMhet8dDzhUADC4fV3H+bvfazVieOFafw
         dgAb8WwcbiWPMhzTAFyKeAkRbvHe/Z+evdApivRPuCqsPP3leyM879JxXJmV117UD0xW
         //VUqP1GG1uGO8MR3jInaDy+tA40KBfWDxZ267/vtWQzkfglFXrBuu+pppvrErIDjO74
         fhnb+Myys7oELCLBvJ0bh/aF3mdsyE7C4QnKdq11TWwFEtwhcNf8S/nFG1OlDaF4NenE
         GG7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=K8qzTDRvDqE8beEmzlw5Ro8ITdxfmMURdYMnM5S+IyE=;
        b=jeGmqskhdtPQ5KaXAPqdBc2z/vlArmR+2UVd9JK5B/agk55HNy31Y3ZF3fsAqUztZL
         uZon6ymxA/Tb7H54SK+QBHaHUBwO9JcoEhkhksajQKnrGKPDRkIuRo/kFsEM7Q6+B+KP
         ljyI/0G0S8b1Ba5MXIwBmglh9awubTRBeWx46sXWsDs1KondJ+jje+A1rvsnSfTiid3a
         iwZzOKaOLncLOdCe3iV60HhAAG2uyvT0zPTQZ5o/7kll8NTagITvzgprOHFnbEaPudRD
         x5zEYJoyCvyonXzxerN9OXqjLsCv/QjII8ZojolJb3pBuv1D77Fls5AhfGIsQxtoBGKl
         o+BQ==
X-Gm-Message-State: AOAM530W57iYIXqRgbc+5KF2inSNEQmWPuqXcf7jTAJysDieI1loLdIy
        oZX1hIkO+/IijIvavhkMtY67jA==
X-Google-Smtp-Source: ABdhPJxAfE2GJd/EajpQ676kFpKi8geeoB+J3n/FsuReVJ4Ig9YwxjEG7KFNFP/MaWQXfKDWCkdjSQ==
X-Received: by 2002:a0c:eac9:: with SMTP id y9mr2955448qvp.58.1614277643557;
        Thu, 25 Feb 2021 10:27:23 -0800 (PST)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id l65sm4519678qkf.113.2021.02.25.10.27.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 10:27:23 -0800 (PST)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        bjorn.andersson@linaro.org
Cc:     ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] crypto: qce: aead: Schedule fallback algorithm
Date:   Thu, 25 Feb 2021 13:27:16 -0500
Message-Id: <20210225182716.1402449-8-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210225182716.1402449-1-thara.gopinath@linaro.org>
References: <20210225182716.1402449-1-thara.gopinath@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Qualcomm crypto engine does not handle the following scenarios and
will issue an abort. In such cases, pass on the transformation to
a fallback algorithm.

- DES3 algorithms with all three keys same.
- AES192 algorithms.
- 0 length messages.

Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
---
 drivers/crypto/qce/aead.c | 58 ++++++++++++++++++++++++++++++++-------
 drivers/crypto/qce/aead.h |  3 ++
 2 files changed, 51 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/qce/aead.c b/drivers/crypto/qce/aead.c
index b594c4bb2640..4c2d024e5296 100644
--- a/drivers/crypto/qce/aead.c
+++ b/drivers/crypto/qce/aead.c
@@ -492,7 +492,20 @@ static int qce_aead_crypt(struct aead_request *req, int encrypt)
 	/* CE does not handle 0 length messages */
 	if (!rctx->cryptlen) {
 		if (!(IS_CCM(rctx->flags) && IS_DECRYPT(rctx->flags)))
-			return -EINVAL;
+			ctx->need_fallback = true;
+	}
+
+	/* If fallback is needed, schedule and exit */
+	if (ctx->need_fallback) {
+		aead_request_set_tfm(&rctx->fallback_req, ctx->fallback);
+		aead_request_set_callback(&rctx->fallback_req, req->base.flags,
+					  req->base.complete, req->base.data);
+		aead_request_set_crypt(&rctx->fallback_req, req->src,
+				       req->dst, req->cryptlen, req->iv);
+		aead_request_set_ad(&rctx->fallback_req, req->assoclen);
+
+		return encrypt ? crypto_aead_encrypt(&rctx->fallback_req) :
+				 crypto_aead_decrypt(&rctx->fallback_req);
 	}
 
 	/*
@@ -533,7 +546,7 @@ static int qce_aead_ccm_setkey(struct crypto_aead *tfm, const u8 *key,
 		memcpy(ctx->ccm4309_salt, key + keylen, QCE_CCM4309_SALT_SIZE);
 	}
 
-	if (keylen != AES_KEYSIZE_128 && keylen != AES_KEYSIZE_256)
+	if (keylen != AES_KEYSIZE_128 && keylen != AES_KEYSIZE_256 && keylen != AES_KEYSIZE_192)
 		return -EINVAL;
 
 	ctx->enc_keylen = keylen;
@@ -542,7 +555,12 @@ static int qce_aead_ccm_setkey(struct crypto_aead *tfm, const u8 *key,
 	memcpy(ctx->enc_key, key, keylen);
 	memcpy(ctx->auth_key, key, keylen);
 
-	return 0;
+	if (keylen == AES_KEYSIZE_192)
+		ctx->need_fallback = true;
+
+	return IS_CCM_RFC4309(flags) ?
+		crypto_aead_setkey(ctx->fallback, key, keylen + QCE_CCM4309_SALT_SIZE) :
+		crypto_aead_setkey(ctx->fallback, key, keylen);
 }
 
 static int qce_aead_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
@@ -573,20 +591,21 @@ static int qce_aead_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int
 		 * The crypto engine does not support any two keys
 		 * being the same for triple des algorithms. The
 		 * verify_skcipher_des3_key does not check for all the
-		 * below conditions. Return -EINVAL in case any two keys
-		 * are the same. Revisit to see if a fallback cipher
-		 * is needed to handle this condition.
+		 * below conditions. Schedule fallback in this case.
 		 */
 		memcpy(_key, authenc_keys.enckey, DES3_EDE_KEY_SIZE);
 		if (!((_key[0] ^ _key[2]) | (_key[1] ^ _key[3])) ||
 		    !((_key[2] ^ _key[4]) | (_key[3] ^ _key[5])) ||
 		    !((_key[0] ^ _key[4]) | (_key[1] ^ _key[5])))
-			return -EINVAL;
+			ctx->need_fallback = true;
 	} else if (IS_AES(flags)) {
 		/* No random key sizes */
 		if (authenc_keys.enckeylen != AES_KEYSIZE_128 &&
+		    authenc_keys.enckeylen != AES_KEYSIZE_192 &&
 		    authenc_keys.enckeylen != AES_KEYSIZE_256)
 			return -EINVAL;
+		if (authenc_keys.enckeylen == AES_KEYSIZE_192)
+			ctx->need_fallback = true;
 	}
 
 	ctx->enc_keylen = authenc_keys.enckeylen;
@@ -597,7 +616,7 @@ static int qce_aead_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int
 	memset(ctx->auth_key, 0, sizeof(ctx->auth_key));
 	memcpy(ctx->auth_key, authenc_keys.authkey, authenc_keys.authkeylen);
 
-	return 0;
+	return crypto_aead_setkey(ctx->fallback, key, keylen);
 }
 
 static int qce_aead_setauthsize(struct crypto_aead *tfm, unsigned int authsize)
@@ -612,15 +631,32 @@ static int qce_aead_setauthsize(struct crypto_aead *tfm, unsigned int authsize)
 			return -EINVAL;
 	}
 	ctx->authsize = authsize;
-	return 0;
+
+	return crypto_aead_setauthsize(ctx->fallback, authsize);
 }
 
 static int qce_aead_init(struct crypto_aead *tfm)
 {
+	struct qce_aead_ctx *ctx = crypto_aead_ctx(tfm);
+
+	ctx->need_fallback = false;
+	ctx->fallback = crypto_alloc_aead(crypto_tfm_alg_name(&tfm->base),
+					  0, CRYPTO_ALG_NEED_FALLBACK);
+
+	if (IS_ERR(ctx->fallback))
+		return PTR_ERR(ctx->fallback);
+
 	crypto_aead_set_reqsize(tfm, sizeof(struct qce_aead_reqctx));
 	return 0;
 }
 
+static void qce_aead_exit(struct crypto_aead *tfm)
+{
+	struct qce_aead_ctx *ctx = crypto_aead_ctx(tfm);
+
+	crypto_free_aead(ctx->fallback);
+}
+
 struct qce_aead_def {
 	unsigned long flags;
 	const char *name;
@@ -718,11 +754,13 @@ static int qce_aead_register_one(const struct qce_aead_def *def, struct qce_devi
 	alg->encrypt			= qce_aead_encrypt;
 	alg->decrypt			= qce_aead_decrypt;
 	alg->init			= qce_aead_init;
+	alg->exit			= qce_aead_exit;
 
 	alg->base.cra_priority		= 300;
 	alg->base.cra_flags		= CRYPTO_ALG_ASYNC |
 					  CRYPTO_ALG_ALLOCATES_MEMORY |
-					  CRYPTO_ALG_KERN_DRIVER_ONLY;
+					  CRYPTO_ALG_KERN_DRIVER_ONLY |
+					  CRYPTO_ALG_NEED_FALLBACK;
 	alg->base.cra_ctxsize		= sizeof(struct qce_aead_ctx);
 	alg->base.cra_alignmask		= 0;
 	alg->base.cra_module		= THIS_MODULE;
diff --git a/drivers/crypto/qce/aead.h b/drivers/crypto/qce/aead.h
index 3d1f2039930b..efb8477cc088 100644
--- a/drivers/crypto/qce/aead.h
+++ b/drivers/crypto/qce/aead.h
@@ -19,6 +19,8 @@ struct qce_aead_ctx {
 	unsigned int enc_keylen;
 	unsigned int auth_keylen;
 	unsigned int authsize;
+	bool need_fallback;
+	struct crypto_aead *fallback;
 };
 
 struct qce_aead_reqctx {
@@ -39,6 +41,7 @@ struct qce_aead_reqctx {
 	u8 ccm_nonce[QCE_MAX_NONCE];
 	u8 ccmresult_buf[QCE_BAM_BURST_SIZE];
 	u8 ccm_rfc4309_iv[QCE_MAX_IV_SIZE];
+	struct aead_request fallback_req;
 };
 
 static inline struct qce_alg_template *to_aead_tmpl(struct crypto_aead *tfm)
-- 
2.25.1

