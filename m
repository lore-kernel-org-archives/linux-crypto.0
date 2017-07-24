From: zain wang <wzz@rock-chips.com>
Subject: [RESEND PATCH 2/2] crypto: rockchip - return the err code when unable dequeue the crypto request
Date: Mon, 24 Jul 2017 09:23:14 +0800
Message-ID: <1500859394-1799-3-git-send-email-wzz@rock-chips.com>
References: <1500859394-1799-1-git-send-email-wzz@rock-chips.com>
Cc: jekarlson@gmail.com, shawn.lin@rock-chips.com,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        zain wang <wzz@rock-chips.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Heiko Stuebner <heiko@sntech.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from regular1.263xmail.com ([211.150.99.133]:60431 "EHLO
        regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752218AbdGXBXb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 23 Jul 2017 21:23:31 -0400
In-Reply-To: <1500859394-1799-1-git-send-email-wzz@rock-chips.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Sometime we would unable to dequeue the crypto request, in this case,
we should finish crypto and return the err code.

Signed-off-by: zain wang <wzz@rock-chips.com>
---
 drivers/crypto/rockchip/rk3288_crypto.c            | 19 -------------------
 drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c | 15 +++++++++++++++
 drivers/crypto/rockchip/rk3288_crypto_ahash.c      | 14 ++++++++++++++
 3 files changed, 29 insertions(+), 19 deletions(-)

diff --git a/drivers/crypto/rockchip/rk3288_crypto.c b/drivers/crypto/rockchip/rk3288_crypto.c
index c2b1dd7..57c3783 100644
--- a/drivers/crypto/rockchip/rk3288_crypto.c
+++ b/drivers/crypto/rockchip/rk3288_crypto.c
@@ -187,27 +187,8 @@ static irqreturn_t rk_crypto_irq_handle(int irq, void *dev_id)
 static void rk_crypto_queue_task_cb(unsigned long data)
 {
 	struct rk_crypto_info *dev = (struct rk_crypto_info *)data;
-	struct crypto_async_request *async_req, *backlog;
-	unsigned long flags;
 	int err = 0;
 
-	spin_lock_irqsave(&dev->lock, flags);
-	backlog   = crypto_get_backlog(&dev->queue);
-	async_req = crypto_dequeue_request(&dev->queue);
-	spin_unlock_irqrestore(&dev->lock, flags);
-	if (!async_req) {
-		dev_err(dev->dev, "async_req is NULL !!\n");
-		return;
-	}
-	if (backlog) {
-		backlog->complete(backlog, -EINPROGRESS);
-		backlog = NULL;
-	}
-
-	if (crypto_tfm_alg_type(async_req->tfm) == CRYPTO_ALG_TYPE_ABLKCIPHER)
-		dev->ablk_req = ablkcipher_request_cast(async_req);
-	else
-		dev->ahash_req = ahash_request_cast(async_req);
 	dev->err = 0;
 	err = dev->start(dev);
 	if (err)
diff --git a/drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c b/drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c
index 8787e44..dbe78de 100644
--- a/drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c
+++ b/drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c
@@ -25,6 +25,7 @@ static int rk_handle_req(struct rk_crypto_info *dev,
 			 struct ablkcipher_request *req)
 {
 	unsigned long flags;
+	struct crypto_async_request *async_req, *backlog;
 	int err;
 
 	if (!IS_ALIGNED(req->nbytes, dev->align_size))
@@ -41,7 +42,21 @@ static int rk_handle_req(struct rk_crypto_info *dev,
 
 	spin_lock_irqsave(&dev->lock, flags);
 	err = ablkcipher_enqueue_request(&dev->queue, req);
+	backlog   = crypto_get_backlog(&dev->queue);
+	async_req = crypto_dequeue_request(&dev->queue);
 	spin_unlock_irqrestore(&dev->lock, flags);
+
+	if (!async_req) {
+		dev_err(dev->dev, "async_req is NULL !!\n");
+		return err;
+	}
+	if (backlog) {
+		backlog->complete(backlog, -EINPROGRESS);
+		backlog = NULL;
+	}
+
+	dev->ablk_req = ablkcipher_request_cast(async_req);
+
 	tasklet_schedule(&dev->queue_task);
 	return err;
 }
diff --git a/drivers/crypto/rockchip/rk3288_crypto_ahash.c b/drivers/crypto/rockchip/rk3288_crypto_ahash.c
index 9b55585..ebc46e0 100644
--- a/drivers/crypto/rockchip/rk3288_crypto_ahash.c
+++ b/drivers/crypto/rockchip/rk3288_crypto_ahash.c
@@ -166,6 +166,7 @@ static int rk_ahash_digest(struct ahash_request *req)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	struct rk_ahash_ctx *tctx = crypto_tfm_ctx(req->base.tfm);
+	struct crypto_async_request *async_req, *backlog;
 	struct rk_crypto_info *dev = NULL;
 	unsigned long flags;
 	int ret;
@@ -202,8 +203,21 @@ static int rk_ahash_digest(struct ahash_request *req)
 
 	spin_lock_irqsave(&dev->lock, flags);
 	ret = crypto_enqueue_request(&dev->queue, &req->base);
+	backlog   = crypto_get_backlog(&dev->queue);
+	async_req = crypto_dequeue_request(&dev->queue);
 	spin_unlock_irqrestore(&dev->lock, flags);
 
+	if (!async_req) {
+		dev_err(dev->dev, "async_req is NULL !!\n");
+		return ret;
+	}
+	if (backlog) {
+		backlog->complete(backlog, -EINPROGRESS);
+		backlog = NULL;
+	}
+
+	dev->ahash_req = ahash_request_cast(async_req);
+
 	tasklet_schedule(&dev->queue_task);
 
 	/*
-- 
1.9.1
