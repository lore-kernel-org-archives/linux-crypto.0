Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6729CC636CD
	for <linux-crypto@archiver.kernel.org>; Tue, 31 Jan 2023 05:44:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbjAaFoL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 31 Jan 2023 00:44:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbjAaFoK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 31 Jan 2023 00:44:10 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 922FA2BF28
        for <linux-crypto@vger.kernel.org>; Mon, 30 Jan 2023 21:44:08 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pMjR7-005ten-L4; Tue, 31 Jan 2023 13:44:06 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 31 Jan 2023 13:44:05 +0800
Date:   Tue, 31 Jan 2023 13:44:05 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Antoine Tenart <atenart@kernel.org>
Subject: [v2 PATCH] crypto: safexcel - Use crypto_wait_req
Message-ID: <Y9iqpXQhKNIxOCuu@gondor.apana.org.au>
References: <Y8+dwWHIz2058E43@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8+dwWHIz2058E43@gondor.apana.org.au>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

v2 adds a missing conversion for hmac.

---8<---
This patch replaces the custom crypto completion function with
crypto_req_done.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index ae6110376e21..baff0123f919 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -970,17 +970,6 @@ void safexcel_complete(struct safexcel_crypto_priv *priv, int ring)
 	} while (!cdesc->last_seg);
 }
 
-void safexcel_inv_complete(struct crypto_async_request *req, int error)
-{
-	struct safexcel_inv_result *result = req->data;
-
-	if (error == -EINPROGRESS)
-		return;
-
-	result->error = error;
-	complete(&result->completion);
-}
-
 int safexcel_invalidate_cache(struct crypto_async_request *async,
 			      struct safexcel_crypto_priv *priv,
 			      dma_addr_t ctxr_dma, int ring)
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index 6c2fc662f64f..47ef6c7cd02c 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -884,11 +884,6 @@ struct safexcel_alg_template {
 	} alg;
 };
 
-struct safexcel_inv_result {
-	struct completion completion;
-	int error;
-};
-
 void safexcel_dequeue(struct safexcel_crypto_priv *priv, int ring);
 int safexcel_rdesc_check_errors(struct safexcel_crypto_priv *priv,
 				void *rdp);
@@ -927,7 +922,6 @@ void safexcel_rdr_req_set(struct safexcel_crypto_priv *priv,
 			  struct crypto_async_request *req);
 inline struct crypto_async_request *
 safexcel_rdr_req_get(struct safexcel_crypto_priv *priv, int ring);
-void safexcel_inv_complete(struct crypto_async_request *req, int error);
 int safexcel_hmac_setkey(struct safexcel_context *base, const u8 *key,
 			 unsigned int keylen, const char *alg,
 			 unsigned int state_sz);
diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index 32a37e3850c5..272c28b5a088 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -1091,13 +1091,12 @@ static int safexcel_aead_send(struct crypto_async_request *async, int ring,
 static int safexcel_cipher_exit_inv(struct crypto_tfm *tfm,
 				    struct crypto_async_request *base,
 				    struct safexcel_cipher_req *sreq,
-				    struct safexcel_inv_result *result)
+				    struct crypto_wait *result)
 {
 	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct safexcel_crypto_priv *priv = ctx->base.priv;
 	int ring = ctx->base.ring;
-
-	init_completion(&result->completion);
+	int err;
 
 	ctx = crypto_tfm_ctx(base->tfm);
 	ctx->base.exit_inv = true;
@@ -1110,13 +1109,13 @@ static int safexcel_cipher_exit_inv(struct crypto_tfm *tfm,
 	queue_work(priv->ring[ring].workqueue,
 		   &priv->ring[ring].work_data.work);
 
-	wait_for_completion(&result->completion);
+	err = crypto_wait_req(-EINPROGRESS, result);
 
-	if (result->error) {
+	if (err) {
 		dev_warn(priv->dev,
 			"cipher: sync: invalidate: completion error %d\n",
-			 result->error);
-		return result->error;
+			 err);
+		return err;
 	}
 
 	return 0;
@@ -1126,12 +1125,12 @@ static int safexcel_skcipher_exit_inv(struct crypto_tfm *tfm)
 {
 	EIP197_REQUEST_ON_STACK(req, skcipher, EIP197_SKCIPHER_REQ_SIZE);
 	struct safexcel_cipher_req *sreq = skcipher_request_ctx(req);
-	struct safexcel_inv_result result = {};
+	DECLARE_CRYPTO_WAIT(result);
 
 	memset(req, 0, sizeof(struct skcipher_request));
 
 	skcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
-				      safexcel_inv_complete, &result);
+				      crypto_req_done, &result);
 	skcipher_request_set_tfm(req, __crypto_skcipher_cast(tfm));
 
 	return safexcel_cipher_exit_inv(tfm, &req->base, sreq, &result);
@@ -1141,12 +1140,12 @@ static int safexcel_aead_exit_inv(struct crypto_tfm *tfm)
 {
 	EIP197_REQUEST_ON_STACK(req, aead, EIP197_AEAD_REQ_SIZE);
 	struct safexcel_cipher_req *sreq = aead_request_ctx(req);
-	struct safexcel_inv_result result = {};
+	DECLARE_CRYPTO_WAIT(result);
 
 	memset(req, 0, sizeof(struct aead_request));
 
 	aead_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
-				  safexcel_inv_complete, &result);
+				  crypto_req_done, &result);
 	aead_request_set_tfm(req, __crypto_aead_cast(tfm));
 
 	return safexcel_cipher_exit_inv(tfm, &req->base, sreq, &result);
diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index ca46328472d4..e17577b785c3 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -625,15 +625,16 @@ static int safexcel_ahash_exit_inv(struct crypto_tfm *tfm)
 	struct safexcel_crypto_priv *priv = ctx->base.priv;
 	EIP197_REQUEST_ON_STACK(req, ahash, EIP197_AHASH_REQ_SIZE);
 	struct safexcel_ahash_req *rctx = ahash_request_ctx_dma(req);
-	struct safexcel_inv_result result = {};
+	DECLARE_CRYPTO_WAIT(result);
 	int ring = ctx->base.ring;
+	int err;
 
 	memset(req, 0, EIP197_AHASH_REQ_SIZE);
 
 	/* create invalidation request */
 	init_completion(&result.completion);
 	ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
-				   safexcel_inv_complete, &result);
+				   crypto_req_done, &result);
 
 	ahash_request_set_tfm(req, __crypto_ahash_cast(tfm));
 	ctx = crypto_tfm_ctx(req->base.tfm);
@@ -647,12 +648,11 @@ static int safexcel_ahash_exit_inv(struct crypto_tfm *tfm)
 	queue_work(priv->ring[ring].workqueue,
 		   &priv->ring[ring].work_data.work);
 
-	wait_for_completion(&result.completion);
+	err = crypto_wait_req(-EINPROGRESS, &result);
 
-	if (result.error) {
-		dev_warn(priv->dev, "hash: completion error (%d)\n",
-			 result.error);
-		return result.error;
+	if (err) {
+		dev_warn(priv->dev, "hash: completion error (%d)\n", err);
+		return err;
 	}
 
 	return 0;
@@ -1042,27 +1042,11 @@ static int safexcel_hmac_sha1_digest(struct ahash_request *areq)
 	return safexcel_ahash_finup(areq);
 }
 
-struct safexcel_ahash_result {
-	struct completion completion;
-	int error;
-};
-
-static void safexcel_ahash_complete(struct crypto_async_request *req, int error)
-{
-	struct safexcel_ahash_result *result = req->data;
-
-	if (error == -EINPROGRESS)
-		return;
-
-	result->error = error;
-	complete(&result->completion);
-}
-
 static int safexcel_hmac_init_pad(struct ahash_request *areq,
 				  unsigned int blocksize, const u8 *key,
 				  unsigned int keylen, u8 *ipad, u8 *opad)
 {
-	struct safexcel_ahash_result result;
+	DECLARE_CRYPTO_WAIT(result);
 	struct scatterlist sg;
 	int ret, i;
 	u8 *keydup;
@@ -1075,16 +1059,12 @@ static int safexcel_hmac_init_pad(struct ahash_request *areq,
 			return -ENOMEM;
 
 		ahash_request_set_callback(areq, CRYPTO_TFM_REQ_MAY_BACKLOG,
-					   safexcel_ahash_complete, &result);
+					   crypto_req_done, &result);
 		sg_init_one(&sg, keydup, keylen);
 		ahash_request_set_crypt(areq, &sg, ipad, keylen);
-		init_completion(&result.completion);
 
 		ret = crypto_ahash_digest(areq);
-		if (ret == -EINPROGRESS || ret == -EBUSY) {
-			wait_for_completion_interruptible(&result.completion);
-			ret = result.error;
-		}
+		ret = crypto_wait_req(ret, &result);
 
 		/* Avoid leaking */
 		kfree_sensitive(keydup);
@@ -1109,16 +1089,15 @@ static int safexcel_hmac_init_pad(struct ahash_request *areq,
 static int safexcel_hmac_init_iv(struct ahash_request *areq,
 				 unsigned int blocksize, u8 *pad, void *state)
 {
-	struct safexcel_ahash_result result;
 	struct safexcel_ahash_req *req;
+	DECLARE_CRYPTO_WAIT(result);
 	struct scatterlist sg;
 	int ret;
 
 	ahash_request_set_callback(areq, CRYPTO_TFM_REQ_MAY_BACKLOG,
-				   safexcel_ahash_complete, &result);
+				   crypto_req_done, &result);
 	sg_init_one(&sg, pad, blocksize);
 	ahash_request_set_crypt(areq, &sg, pad, blocksize);
-	init_completion(&result.completion);
 
 	ret = crypto_ahash_init(areq);
 	if (ret)
@@ -1129,14 +1108,9 @@ static int safexcel_hmac_init_iv(struct ahash_request *areq,
 	req->last_req = true;
 
 	ret = crypto_ahash_update(areq);
-	if (ret && ret != -EINPROGRESS && ret != -EBUSY)
-		return ret;
-
-	wait_for_completion_interruptible(&result.completion);
-	if (result.error)
-		return result.error;
+	ret = crypto_wait_req(ret, &result);
 
-	return crypto_ahash_export(areq, state);
+	return ret ?: crypto_ahash_export(areq, state);
 }
 
 static int __safexcel_hmac_setkey(const char *alg, const u8 *key,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
