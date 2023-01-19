Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0779DC38142
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Jan 2023 10:38:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbjASKiD (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Jan 2023 05:38:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230221AbjASKhl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Jan 2023 05:37:41 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 475976F33A
        for <linux-crypto@vger.kernel.org>; Thu, 19 Jan 2023 02:37:01 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pISHy-001iZe-N1; Thu, 19 Jan 2023 18:36:59 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 19 Jan 2023 18:36:58 +0800
Date:   Thu, 19 Jan 2023 18:36:58 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Raveendra Padasalagi <raveendra.padasalagi@broadcom.com>
Subject: [PATCH] crypto: bcm - Use subrequest for fallback
Message-ID: <Y8kdSg6xF0IUM+dV@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Instead of doing saving and restoring on the AEAD request object
for fallback processing, use a subrequest instead.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/bcm/cipher.c b/drivers/crypto/bcm/cipher.c
index c8c799428fe0..f8e035039aeb 100644
--- a/drivers/crypto/bcm/cipher.c
+++ b/drivers/crypto/bcm/cipher.c
@@ -2570,66 +2570,29 @@ static int aead_need_fallback(struct aead_request *req)
 		return payload_len > ctx->max_payload;
 }
 
-static void aead_complete(struct crypto_async_request *areq, int err)
-{
-	struct aead_request *req =
-	    container_of(areq, struct aead_request, base);
-	struct iproc_reqctx_s *rctx = aead_request_ctx(req);
-	struct crypto_aead *aead = crypto_aead_reqtfm(req);
-
-	flow_log("%s() err:%d\n", __func__, err);
-
-	areq->tfm = crypto_aead_tfm(aead);
-
-	areq->complete = rctx->old_complete;
-	areq->data = rctx->old_data;
-
-	areq->complete(areq, err);
-}
-
 static int aead_do_fallback(struct aead_request *req, bool is_encrypt)
 {
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	struct crypto_tfm *tfm = crypto_aead_tfm(aead);
 	struct iproc_reqctx_s *rctx = aead_request_ctx(req);
 	struct iproc_ctx_s *ctx = crypto_tfm_ctx(tfm);
-	int err;
-	u32 req_flags;
+	struct aead_request *subreq;
 
 	flow_log("%s() enc:%u\n", __func__, is_encrypt);
 
-	if (ctx->fallback_cipher) {
-		/* Store the cipher tfm and then use the fallback tfm */
-		rctx->old_tfm = tfm;
-		aead_request_set_tfm(req, ctx->fallback_cipher);
-		/*
-		 * Save the callback and chain ourselves in, so we can restore
-		 * the tfm
-		 */
-		rctx->old_complete = req->base.complete;
-		rctx->old_data = req->base.data;
-		req_flags = aead_request_flags(req);
-		aead_request_set_callback(req, req_flags, aead_complete, req);
-		err = is_encrypt ? crypto_aead_encrypt(req) :
-		    crypto_aead_decrypt(req);
-
-		if (err == 0) {
-			/*
-			 * fallback was synchronous (did not return
-			 * -EINPROGRESS). So restore request state here.
-			 */
-			aead_request_set_callback(req, req_flags,
-						  rctx->old_complete, req);
-			req->base.data = rctx->old_data;
-			aead_request_set_tfm(req, aead);
-			flow_log("%s() fallback completed successfully\n\n",
-				 __func__);
-		}
-	} else {
-		err = -EINVAL;
-	}
+	if (!ctx->fallback_cipher)
+		return -EINVAL;
 
-	return err;
+	subreq = &rctx->req;
+	aead_request_set_tfm(subreq, ctx->fallback_cipher);
+	aead_request_set_callback(subreq, aead_request_flags(req),
+				  req->base.complete, req->base.data);
+	aead_request_set_crypt(subreq, req->src, req->dst, req->cryptlen,
+			       req->iv);
+	aead_request_set_ad(subreq, req->assoclen);
+
+	return is_encrypt ? crypto_aead_encrypt(req) :
+			    crypto_aead_decrypt(req);
 }
 
 static int aead_enqueue(struct aead_request *req, bool is_encrypt)
@@ -4243,6 +4206,7 @@ static int ahash_cra_init(struct crypto_tfm *tfm)
 
 static int aead_cra_init(struct crypto_aead *aead)
 {
+	unsigned int reqsize = sizeof(struct iproc_reqctx_s);
 	struct crypto_tfm *tfm = crypto_aead_tfm(aead);
 	struct iproc_ctx_s *ctx = crypto_tfm_ctx(tfm);
 	struct crypto_alg *alg = tfm->__crt_alg;
@@ -4254,7 +4218,6 @@ static int aead_cra_init(struct crypto_aead *aead)
 
 	flow_log("%s()\n", __func__);
 
-	crypto_aead_set_reqsize(aead, sizeof(struct iproc_reqctx_s));
 	ctx->is_esp = false;
 	ctx->salt_len = 0;
 	ctx->salt_offset = 0;
@@ -4263,22 +4226,29 @@ static int aead_cra_init(struct crypto_aead *aead)
 	get_random_bytes(ctx->iv, MAX_IV_SIZE);
 	flow_dump("  iv: ", ctx->iv, MAX_IV_SIZE);
 
-	if (!err) {
-		if (alg->cra_flags & CRYPTO_ALG_NEED_FALLBACK) {
-			flow_log("%s() creating fallback cipher\n", __func__);
-
-			ctx->fallback_cipher =
-			    crypto_alloc_aead(alg->cra_name, 0,
-					      CRYPTO_ALG_ASYNC |
-					      CRYPTO_ALG_NEED_FALLBACK);
-			if (IS_ERR(ctx->fallback_cipher)) {
-				pr_err("%s() Error: failed to allocate fallback for %s\n",
-				       __func__, alg->cra_name);
-				return PTR_ERR(ctx->fallback_cipher);
-			}
-		}
+	if (err)
+		goto out;
+
+	if (!(alg->cra_flags & CRYPTO_ALG_NEED_FALLBACK))
+		goto reqsize;
+
+	flow_log("%s() creating fallback cipher\n", __func__);
+
+	ctx->fallback_cipher = crypto_alloc_aead(alg->cra_name, 0,
+						 CRYPTO_ALG_ASYNC |
+						 CRYPTO_ALG_NEED_FALLBACK);
+	if (IS_ERR(ctx->fallback_cipher)) {
+		pr_err("%s() Error: failed to allocate fallback for %s\n",
+		       __func__, alg->cra_name);
+		return PTR_ERR(ctx->fallback_cipher);
 	}
 
+	reqsize += crypto_aead_reqsize(ctx->fallback_cipher);
+
+reqsize:
+	crypto_aead_set_reqsize(aead, reqsize);
+
+out:
 	return err;
 }
 
diff --git a/drivers/crypto/bcm/cipher.h b/drivers/crypto/bcm/cipher.h
index d6d87332140a..e36881c983cf 100644
--- a/drivers/crypto/bcm/cipher.h
+++ b/drivers/crypto/bcm/cipher.h
@@ -339,15 +339,12 @@ struct iproc_reqctx_s {
 	/* hmac context */
 	bool is_sw_hmac;
 
-	/* aead context */
-	struct crypto_tfm *old_tfm;
-	crypto_completion_t old_complete;
-	void *old_data;
-
 	gfp_t gfp;
 
 	/* Buffers used to build SPU request and response messages */
 	struct spu_msg_buf msg_buf;
+
+	struct aead_request req;
 };
 
 /*
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
