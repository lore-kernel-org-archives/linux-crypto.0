From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: [PATCH v4 3/4] crypto: inside-secure - fix request allocations in invalidation path
Date: Mon, 11 Dec 2017 12:10:57 +0100
Message-ID: <20171211111058.8878-4-antoine.tenart@free-electrons.com>
References: <20171211111058.8878-1-antoine.tenart@free-electrons.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        thomas.petazzoni@free-electrons.com,
        gregory.clement@free-electrons.com,
        miquel.raynal@free-electrons.com, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:58922 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752415AbdLKLPE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Dec 2017 06:15:04 -0500
In-Reply-To: <20171211111058.8878-1-antoine.tenart@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch makes use of the SKCIPHER_REQUEST_ON_STACK and
AHASH_REQUEST_ON_STACK helpers to allocate enough memory to contain both
the crypto request structures and their embedded context (__ctx).

Fixes: 1b44c5a60c13 ("crypto: inside-secure - add SafeXcel EIP197 crypto engine driver")
Suggested-by: Ofer Heifetz <oferh@marvell.com>
Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 drivers/crypto/inside-secure/safexcel_cipher.c | 16 ++++++++--------
 drivers/crypto/inside-secure/safexcel_hash.c   | 14 +++++++-------
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index 9ea24868d860..fcc0a606d748 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -422,25 +422,25 @@ static int safexcel_cipher_exit_inv(struct crypto_tfm *tfm)
 {
 	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct safexcel_crypto_priv *priv = ctx->priv;
-	struct skcipher_request req;
-	struct safexcel_cipher_req *sreq = skcipher_request_ctx(&req);
+	SKCIPHER_REQUEST_ON_STACK(req, __crypto_skcipher_cast(tfm));
+	struct safexcel_cipher_req *sreq = skcipher_request_ctx(req);
 	struct safexcel_inv_result result = {};
 	int ring = ctx->base.ring;
 
-	memset(&req, 0, sizeof(struct skcipher_request));
+	memset(req, 0, sizeof(struct skcipher_request));
 
 	/* create invalidation request */
 	init_completion(&result.completion);
-	skcipher_request_set_callback(&req, CRYPTO_TFM_REQ_MAY_BACKLOG,
-					safexcel_inv_complete, &result);
+	skcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+				      safexcel_inv_complete, &result);
 
-	skcipher_request_set_tfm(&req, __crypto_skcipher_cast(tfm));
-	ctx = crypto_tfm_ctx(req.base.tfm);
+	skcipher_request_set_tfm(req, __crypto_skcipher_cast(tfm));
+	ctx = crypto_tfm_ctx(req->base.tfm);
 	ctx->base.exit_inv = true;
 	sreq->needs_inv = true;
 
 	spin_lock_bh(&priv->ring[ring].queue_lock);
-	crypto_enqueue_request(&priv->ring[ring].queue, &req.base);
+	crypto_enqueue_request(&priv->ring[ring].queue, &req->base);
 	spin_unlock_bh(&priv->ring[ring].queue_lock);
 
 	if (!priv->ring[ring].need_dequeue)
diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index 79fe149804d3..55ff8a340b11 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -450,25 +450,25 @@ static int safexcel_ahash_exit_inv(struct crypto_tfm *tfm)
 {
 	struct safexcel_ahash_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct safexcel_crypto_priv *priv = ctx->priv;
-	struct ahash_request req;
-	struct safexcel_ahash_req *rctx = ahash_request_ctx(&req);
+	AHASH_REQUEST_ON_STACK(req, __crypto_ahash_cast(tfm));
+	struct safexcel_ahash_req *rctx = ahash_request_ctx(req);
 	struct safexcel_inv_result result = {};
 	int ring = ctx->base.ring;
 
-	memset(&req, 0, sizeof(struct ahash_request));
+	memset(req, 0, sizeof(struct ahash_request));
 
 	/* create invalidation request */
 	init_completion(&result.completion);
-	ahash_request_set_callback(&req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+	ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
 				   safexcel_inv_complete, &result);
 
-	ahash_request_set_tfm(&req, __crypto_ahash_cast(tfm));
-	ctx = crypto_tfm_ctx(req.base.tfm);
+	ahash_request_set_tfm(req, __crypto_ahash_cast(tfm));
+	ctx = crypto_tfm_ctx(req->base.tfm);
 	ctx->base.exit_inv = true;
 	rctx->needs_inv = true;
 
 	spin_lock_bh(&priv->ring[ring].queue_lock);
-	crypto_enqueue_request(&priv->ring[ring].queue, &req.base);
+	crypto_enqueue_request(&priv->ring[ring].queue, &req->base);
 	spin_unlock_bh(&priv->ring[ring].queue_lock);
 
 	if (!priv->ring[ring].need_dequeue)
-- 
2.14.3
