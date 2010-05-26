From: David Miller <davem@davemloft.net>
Subject: [PATCH 3/7] n2_crypto: Plumb fallback ahash requests properly.
Date: Tue, 25 May 2010 17:43:37 -0700 (PDT)
Message-ID: <20100525.174337.260086035.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37722
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758297Ab0EZAn0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 25 May 2010 20:43:26 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Do this by putting the async fallback request at the end of an n2
specific ahash request context, then properly adjusting the request
private size in our ahash ->cra_init().

We also need to put the writable state bits into the n2 request
private instead of the n2 cra_ctx.

With help from Herbert Xu.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/crypto/n2_core.c |   95 +++++++++++++++++++++++-----------------------
 1 files changed, 48 insertions(+), 47 deletions(-)

diff --git a/drivers/crypto/n2_core.c b/drivers/crypto/n2_core.c
index 5613b8a..23163fd 100644
--- a/drivers/crypto/n2_core.c
+++ b/drivers/crypto/n2_core.c
@@ -251,16 +251,10 @@ static void n2_base_ctx_init(struct n2_base_ctx *ctx)
 struct n2_hash_ctx {
 	struct n2_base_ctx		base;
 
-	struct crypto_ahash		*fallback;
+	struct crypto_ahash		*fallback_tfm;
+};
 
-	/* These next three members must match the layout created by
-	 * crypto_init_shash_ops_async.  This allows us to properly
-	 * plumb requests we can't do in hardware down to the fallback
-	 * operation, providing all of the data structures and layouts
-	 * expected by those paths.
-	 */
-	struct ahash_request		fallback_req;
-	struct shash_desc		fallback_desc;
+struct n2_hash_req_ctx {
 	union {
 		struct md5_state	md5;
 		struct sha1_state	sha1;
@@ -269,56 +263,62 @@ struct n2_hash_ctx {
 
 	unsigned char			hash_key[64];
 	unsigned char			keyed_zero_hash[32];
+
+	struct ahash_request		fallback_req;
 };
 
 static int n2_hash_async_init(struct ahash_request *req)
 {
+	struct n2_hash_req_ctx *rctx = ahash_request_ctx(req);
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	struct n2_hash_ctx *ctx = crypto_ahash_ctx(tfm);
 
-	ctx->fallback_req.base.tfm = crypto_ahash_tfm(ctx->fallback);
-	ctx->fallback_req.base.flags = req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP;
+	ahash_request_set_tfm(&rctx->fallback_req, ctx->fallback_tfm);
+	rctx->fallback_req.base.flags = req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP;
 
-	return crypto_ahash_init(&ctx->fallback_req);
+	return crypto_ahash_init(&rctx->fallback_req);
 }
 
 static int n2_hash_async_update(struct ahash_request *req)
 {
+	struct n2_hash_req_ctx *rctx = ahash_request_ctx(req);
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	struct n2_hash_ctx *ctx = crypto_ahash_ctx(tfm);
 
-	ctx->fallback_req.base.tfm = crypto_ahash_tfm(ctx->fallback);
-	ctx->fallback_req.base.flags = req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP;
-	ctx->fallback_req.nbytes = req->nbytes;
-	ctx->fallback_req.src = req->src;
+	ahash_request_set_tfm(&rctx->fallback_req, ctx->fallback_tfm);
+	rctx->fallback_req.base.flags = req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP;
+	rctx->fallback_req.nbytes = req->nbytes;
+	rctx->fallback_req.src = req->src;
 
-	return crypto_ahash_update(&ctx->fallback_req);
+	return crypto_ahash_update(&rctx->fallback_req);
 }
 
 static int n2_hash_async_final(struct ahash_request *req)
 {
+	struct n2_hash_req_ctx *rctx = ahash_request_ctx(req);
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	struct n2_hash_ctx *ctx = crypto_ahash_ctx(tfm);
 
-	ctx->fallback_req.base.tfm = crypto_ahash_tfm(ctx->fallback);
-	ctx->fallback_req.base.flags = req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP;
-	ctx->fallback_req.result = req->result;
+	ahash_request_set_tfm(&rctx->fallback_req, ctx->fallback_tfm);
+	rctx->fallback_req.base.flags = req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP;
+	rctx->fallback_req.result = req->result;
 
-	return crypto_ahash_final(&ctx->fallback_req);
+	return crypto_ahash_final(&rctx->fallback_req);
 }
 
 static int n2_hash_async_finup(struct ahash_request *req)
 {
+	struct n2_hash_req_ctx *rctx = ahash_request_ctx(req);
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	struct n2_hash_ctx *ctx = crypto_ahash_ctx(tfm);
 
-	ctx->fallback_req.base.tfm = crypto_ahash_tfm(ctx->fallback);
-	ctx->fallback_req.base.flags = req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP;
-	ctx->fallback_req.nbytes = req->nbytes;
-	ctx->fallback_req.src = req->src;
-	ctx->fallback_req.result = req->result;
+	ahash_request_set_tfm(&rctx->fallback_req, ctx->fallback_tfm);
+	rctx->fallback_req.base.flags = req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP;
+	rctx->fallback_req.nbytes = req->nbytes;
+	rctx->fallback_req.src = req->src;
+	rctx->fallback_req.result = req->result;
 
-	return crypto_ahash_finup(&ctx->fallback_req);
+	return crypto_ahash_finup(&rctx->fallback_req);
 }
 
 static int n2_hash_cra_init(struct crypto_tfm *tfm)
@@ -338,7 +338,10 @@ static int n2_hash_cra_init(struct crypto_tfm *tfm)
 		goto out;
 	}
 
-	ctx->fallback = fallback_tfm;
+	crypto_ahash_set_reqsize(ahash, (sizeof(struct n2_hash_req_ctx) +
+					 crypto_ahash_reqsize(fallback_tfm)));
+
+	ctx->fallback_tfm = fallback_tfm;
 	return 0;
 
 out:
@@ -350,7 +353,7 @@ static void n2_hash_cra_exit(struct crypto_tfm *tfm)
 	struct crypto_ahash *ahash = __crypto_ahash_cast(tfm);
 	struct n2_hash_ctx *ctx = crypto_ahash_ctx(ahash);
 
-	crypto_free_ahash(ctx->fallback);
+	crypto_free_ahash(ctx->fallback_tfm);
 }
 
 static unsigned long wait_for_tail(struct spu_queue *qp)
@@ -399,14 +402,16 @@ static int n2_hash_async_digest(struct ahash_request *req,
 	 * exceed 2^16.
 	 */
 	if (unlikely(req->nbytes > (1 << 16))) {
-		ctx->fallback_req.base.tfm = crypto_ahash_tfm(ctx->fallback);
-		ctx->fallback_req.base.flags =
+		struct n2_hash_req_ctx *rctx = ahash_request_ctx(req);
+
+		ahash_request_set_tfm(&rctx->fallback_req, ctx->fallback_tfm);
+		rctx->fallback_req.base.flags =
 			req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP;
-		ctx->fallback_req.nbytes = req->nbytes;
-		ctx->fallback_req.src = req->src;
-		ctx->fallback_req.result = req->result;
+		rctx->fallback_req.nbytes = req->nbytes;
+		rctx->fallback_req.src = req->src;
+		rctx->fallback_req.result = req->result;
 
-		return crypto_ahash_digest(&ctx->fallback_req);
+		return crypto_ahash_digest(&rctx->fallback_req);
 	}
 
 	n2_base_ctx_init(&ctx->base);
@@ -472,9 +477,8 @@ out:
 
 static int n2_md5_async_digest(struct ahash_request *req)
 {
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct n2_hash_ctx *ctx = crypto_ahash_ctx(tfm);
-	struct md5_state *m = &ctx->u.md5;
+	struct n2_hash_req_ctx *rctx = ahash_request_ctx(req);
+	struct md5_state *m = &rctx->u.md5;
 
 	if (unlikely(req->nbytes == 0)) {
 		static const char md5_zero[MD5_DIGEST_SIZE] = {
@@ -497,9 +501,8 @@ static int n2_md5_async_digest(struct ahash_request *req)
 
 static int n2_sha1_async_digest(struct ahash_request *req)
 {
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct n2_hash_ctx *ctx = crypto_ahash_ctx(tfm);
-	struct sha1_state *s = &ctx->u.sha1;
+	struct n2_hash_req_ctx *rctx = ahash_request_ctx(req);
+	struct sha1_state *s = &rctx->u.sha1;
 
 	if (unlikely(req->nbytes == 0)) {
 		static const char sha1_zero[SHA1_DIGEST_SIZE] = {
@@ -524,9 +527,8 @@ static int n2_sha1_async_digest(struct ahash_request *req)
 
 static int n2_sha256_async_digest(struct ahash_request *req)
 {
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct n2_hash_ctx *ctx = crypto_ahash_ctx(tfm);
-	struct sha256_state *s = &ctx->u.sha256;
+	struct n2_hash_req_ctx *rctx = ahash_request_ctx(req);
+	struct sha256_state *s = &rctx->u.sha256;
 
 	if (req->nbytes == 0) {
 		static const char sha256_zero[SHA256_DIGEST_SIZE] = {
@@ -555,9 +557,8 @@ static int n2_sha256_async_digest(struct ahash_request *req)
 
 static int n2_sha224_async_digest(struct ahash_request *req)
 {
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct n2_hash_ctx *ctx = crypto_ahash_ctx(tfm);
-	struct sha256_state *s = &ctx->u.sha256;
+	struct n2_hash_req_ctx *rctx = ahash_request_ctx(req);
+	struct sha256_state *s = &rctx->u.sha256;
 
 	if (req->nbytes == 0) {
 		static const char sha224_zero[SHA224_DIGEST_SIZE] = {
-- 
1.7.0.4
