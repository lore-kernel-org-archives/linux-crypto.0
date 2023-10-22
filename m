Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F13D7C00A8F
	for <linux-crypto@archiver.kernel.org>; Sun, 22 Oct 2023 08:18:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231611AbjJVIS6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 22 Oct 2023 04:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231356AbjJVISt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 22 Oct 2023 04:18:49 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C5A693
        for <linux-crypto@vger.kernel.org>; Sun, 22 Oct 2023 01:18:47 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE60AC433CB
        for <linux-crypto@vger.kernel.org>; Sun, 22 Oct 2023 08:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697962726;
        bh=o1ecA8M9LopLjtfKIXqmw72nJfQRspU8YS31eZy7Elg=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=aOvCasG01WZc7tw/m8wDVs+zroQJln7q5z2DgCGb+Vy9kdTBmY9n4W3QSEzvTMH3g
         qymKZNOBzyWOJGPMHnKuvPTgE16+PAjhOpb0Czv/rBOEA0Pjw5gg3Xo5QYTgmTQJb0
         qjCxtpk5OEHOj4ncH/Ccr299vLcK35c8C7si+fVHqgdH8/axRXoaaYZaZA+OlKaHm4
         LJz7KC85Ihrt3ya4JW4KaO2Tci7xJ1R8sY/k2k97HBxNiV0gmqnknYwMd3K5ATGn0l
         BZmY9al6540kolMiqfzVp/vAfOE5BE45XyRjmXtDu8oOK7a1EQBxdQRr+QKaQ88WVF
         9Fk0XU5PNStwg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 15/30] crypto: authenc - stop using alignmask of ahash
Date:   Sun, 22 Oct 2023 01:10:45 -0700
Message-ID: <20231022081100.123613-16-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231022081100.123613-1-ebiggers@kernel.org>
References: <20231022081100.123613-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Now that the alignmask for ahash and shash algorithms is always 0,
simplify the code in authenc accordingly.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/authenc.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/crypto/authenc.c b/crypto/authenc.c
index fa896ab143bdf..3aaf3ab4e360f 100644
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -134,23 +134,20 @@ static int crypto_authenc_genicv(struct aead_request *req, unsigned int flags)
 	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
 	struct aead_instance *inst = aead_alg_instance(authenc);
 	struct crypto_authenc_ctx *ctx = crypto_aead_ctx(authenc);
 	struct authenc_instance_ctx *ictx = aead_instance_ctx(inst);
 	struct crypto_ahash *auth = ctx->auth;
 	struct authenc_request_ctx *areq_ctx = aead_request_ctx(req);
 	struct ahash_request *ahreq = (void *)(areq_ctx->tail + ictx->reqoff);
 	u8 *hash = areq_ctx->tail;
 	int err;
 
-	hash = (u8 *)ALIGN((unsigned long)hash + crypto_ahash_alignmask(auth),
-			   crypto_ahash_alignmask(auth) + 1);
-
 	ahash_request_set_tfm(ahreq, auth);
 	ahash_request_set_crypt(ahreq, req->dst, hash,
 				req->assoclen + req->cryptlen);
 	ahash_request_set_callback(ahreq, flags,
 				   authenc_geniv_ahash_done, req);
 
 	err = crypto_ahash_digest(ahreq);
 	if (err)
 		return err;
 
@@ -279,23 +276,20 @@ static int crypto_authenc_decrypt(struct aead_request *req)
 	unsigned int authsize = crypto_aead_authsize(authenc);
 	struct aead_instance *inst = aead_alg_instance(authenc);
 	struct crypto_authenc_ctx *ctx = crypto_aead_ctx(authenc);
 	struct authenc_instance_ctx *ictx = aead_instance_ctx(inst);
 	struct crypto_ahash *auth = ctx->auth;
 	struct authenc_request_ctx *areq_ctx = aead_request_ctx(req);
 	struct ahash_request *ahreq = (void *)(areq_ctx->tail + ictx->reqoff);
 	u8 *hash = areq_ctx->tail;
 	int err;
 
-	hash = (u8 *)ALIGN((unsigned long)hash + crypto_ahash_alignmask(auth),
-			   crypto_ahash_alignmask(auth) + 1);
-
 	ahash_request_set_tfm(ahreq, auth);
 	ahash_request_set_crypt(ahreq, req->src, hash,
 				req->assoclen + req->cryptlen - authsize);
 	ahash_request_set_callback(ahreq, aead_request_flags(req),
 				   authenc_verify_ahash_done, req);
 
 	err = crypto_ahash_digest(ahreq);
 	if (err)
 		return err;
 
@@ -393,40 +387,38 @@ static int crypto_authenc_create(struct crypto_template *tmpl,
 		goto err_free_inst;
 	auth = crypto_spawn_ahash_alg(&ctx->auth);
 	auth_base = &auth->base;
 
 	err = crypto_grab_skcipher(&ctx->enc, aead_crypto_instance(inst),
 				   crypto_attr_alg_name(tb[2]), 0, mask);
 	if (err)
 		goto err_free_inst;
 	enc = crypto_spawn_skcipher_alg_common(&ctx->enc);
 
-	ctx->reqoff = ALIGN(2 * auth->digestsize + auth_base->cra_alignmask,
-			    auth_base->cra_alignmask + 1);
+	ctx->reqoff = 2 * auth->digestsize;
 
 	err = -ENAMETOOLONG;
 	if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME,
 		     "authenc(%s,%s)", auth_base->cra_name,
 		     enc->base.cra_name) >=
 	    CRYPTO_MAX_ALG_NAME)
 		goto err_free_inst;
 
 	if (snprintf(inst->alg.base.cra_driver_name, CRYPTO_MAX_ALG_NAME,
 		     "authenc(%s,%s)", auth_base->cra_driver_name,
 		     enc->base.cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
 		goto err_free_inst;
 
 	inst->alg.base.cra_priority = enc->base.cra_priority * 10 +
 				      auth_base->cra_priority;
 	inst->alg.base.cra_blocksize = enc->base.cra_blocksize;
-	inst->alg.base.cra_alignmask = auth_base->cra_alignmask |
-				       enc->base.cra_alignmask;
+	inst->alg.base.cra_alignmask = enc->base.cra_alignmask;
 	inst->alg.base.cra_ctxsize = sizeof(struct crypto_authenc_ctx);
 
 	inst->alg.ivsize = enc->ivsize;
 	inst->alg.chunksize = enc->chunksize;
 	inst->alg.maxauthsize = auth->digestsize;
 
 	inst->alg.init = crypto_authenc_init_tfm;
 	inst->alg.exit = crypto_authenc_exit_tfm;
 
 	inst->alg.setkey = crypto_authenc_setkey;
-- 
2.42.0

