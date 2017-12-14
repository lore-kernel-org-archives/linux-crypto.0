From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: [PATCH 09/17] crypto: inside-secure - move request dequeueing into a workqueue
Date: Thu, 14 Dec 2017 15:26:51 +0100
Message-ID: <20171214142659.16987-10-antoine.tenart@free-electrons.com>
References: <20171214142659.16987-1-antoine.tenart@free-electrons.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        thomas.petazzoni@free-electrons.com,
        gregory.clement@free-electrons.com,
        miquel.raynal@free-electrons.com, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:36777 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753154AbdLNOaG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Dec 2017 09:30:06 -0500
In-Reply-To: <20171214142659.16987-1-antoine.tenart@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch moves the request dequeueing into a workqueue to improve the
coalescing of interrupts when sending requests to the engine; as the
engine is capable of having one single interrupt for n requests sent.
Using a workqueue allows to send more request at once.

Suggested-by: Ofer Heifetz <oferh@marvell.com>
Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 drivers/crypto/inside-secure/safexcel.c        | 29 ++++++++++++++------------
 drivers/crypto/inside-secure/safexcel.h        |  2 +-
 drivers/crypto/inside-secure/safexcel_cipher.c | 12 +++++------
 drivers/crypto/inside-secure/safexcel_hash.c   | 12 +++++------
 4 files changed, 29 insertions(+), 26 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index f250c3c1ab0f..f422af3eed2f 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -429,8 +429,6 @@ void safexcel_dequeue(struct safexcel_crypto_priv *priv, int ring)
 	struct safexcel_request *request;
 	int ret, nreq = 0, cdesc = 0, rdesc = 0, commands, results;
 
-	priv->ring[ring].need_dequeue = false;
-
 	do {
 		spin_lock_bh(&priv->ring[ring].queue_lock);
 		backlog = crypto_get_backlog(&priv->ring[ring].queue);
@@ -445,8 +443,6 @@ void safexcel_dequeue(struct safexcel_crypto_priv *priv, int ring)
 			spin_lock_bh(&priv->ring[ring].queue_lock);
 			crypto_enqueue_request(&priv->ring[ring].queue, req);
 			spin_unlock_bh(&priv->ring[ring].queue_lock);
-
-			priv->ring[ring].need_dequeue = true;
 			goto finalize;
 		}
 
@@ -455,7 +451,6 @@ void safexcel_dequeue(struct safexcel_crypto_priv *priv, int ring)
 		if (ret) {
 			kfree(request);
 			req->complete(req, ret);
-			priv->ring[ring].need_dequeue = true;
 			goto finalize;
 		}
 
@@ -471,9 +466,7 @@ void safexcel_dequeue(struct safexcel_crypto_priv *priv, int ring)
 	} while (nreq++ < EIP197_MAX_BATCH_SZ);
 
 finalize:
-	if (nreq == EIP197_MAX_BATCH_SZ)
-		priv->ring[ring].need_dequeue = true;
-	else if (!nreq)
+	if (!nreq)
 		return;
 
 	spin_lock_bh(&priv->ring[ring].lock);
@@ -628,13 +621,18 @@ static inline void safexcel_handle_result_descriptor(struct safexcel_crypto_priv
 static void safexcel_handle_result_work(struct work_struct *work)
 {
 	struct safexcel_work_data *data =
-			container_of(work, struct safexcel_work_data, work);
+			container_of(work, struct safexcel_work_data, result_work);
 	struct safexcel_crypto_priv *priv = data->priv;
 
 	safexcel_handle_result_descriptor(priv, data->ring);
+}
+
+static void safexcel_dequeue_work(struct work_struct *work)
+{
+	struct safexcel_work_data *data =
+			container_of(work, struct safexcel_work_data, work);
 
-	if (priv->ring[data->ring].need_dequeue)
-		safexcel_dequeue(data->priv, data->ring);
+	safexcel_dequeue(data->priv, data->ring);
 }
 
 struct safexcel_ring_irq_data {
@@ -665,7 +663,10 @@ static irqreturn_t safexcel_irq_ring(int irq, void *data)
 			 */
 			dev_err(priv->dev, "RDR: fatal error.");
 		} else if (likely(stat & EIP197_xDR_THRESH)) {
-			queue_work(priv->ring[ring].workqueue, &priv->ring[ring].work_data.work);
+			queue_work(priv->ring[ring].workqueue,
+				   &priv->ring[ring].work_data.result_work);
+			queue_work(priv->ring[ring].workqueue,
+				   &priv->ring[ring].work_data.work);
 		}
 
 		/* ACK the interrupts */
@@ -846,7 +847,9 @@ static int safexcel_probe(struct platform_device *pdev)
 
 		priv->ring[i].work_data.priv = priv;
 		priv->ring[i].work_data.ring = i;
-		INIT_WORK(&priv->ring[i].work_data.work, safexcel_handle_result_work);
+		INIT_WORK(&priv->ring[i].work_data.result_work,
+			  safexcel_handle_result_work);
+		INIT_WORK(&priv->ring[i].work_data.work, safexcel_dequeue_work);
 
 		snprintf(wq_name, 9, "wq_ring%d", i);
 		priv->ring[i].workqueue = create_singlethread_workqueue(wq_name);
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index d12c2b479a5e..8e9c65183439 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -459,6 +459,7 @@ struct safexcel_config {
 
 struct safexcel_work_data {
 	struct work_struct work;
+	struct work_struct result_work;
 	struct safexcel_crypto_priv *priv;
 	int ring;
 };
@@ -489,7 +490,6 @@ struct safexcel_crypto_priv {
 		/* queue */
 		struct crypto_queue queue;
 		spinlock_t queue_lock;
-		bool need_dequeue;
 	} ring[EIP197_MAX_RINGS];
 };
 
diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index fe1d588d6a25..0e5cc230e49a 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -358,8 +358,8 @@ static int safexcel_handle_inv_result(struct safexcel_crypto_priv *priv,
 	if (enq_ret != -EINPROGRESS)
 		*ret = enq_ret;
 
-	if (!priv->ring[ring].need_dequeue)
-		safexcel_dequeue(priv, ring);
+	queue_work(priv->ring[ring].workqueue,
+		   &priv->ring[ring].work_data.work);
 
 	*should_complete = false;
 
@@ -448,8 +448,8 @@ static int safexcel_cipher_exit_inv(struct crypto_tfm *tfm)
 	crypto_enqueue_request(&priv->ring[ring].queue, &req->base);
 	spin_unlock_bh(&priv->ring[ring].queue_lock);
 
-	if (!priv->ring[ring].need_dequeue)
-		safexcel_dequeue(priv, ring);
+	queue_work(priv->ring[ring].workqueue,
+		   &priv->ring[ring].work_data.work);
 
 	wait_for_completion_interruptible(&result.completion);
 
@@ -495,8 +495,8 @@ static int safexcel_aes(struct skcipher_request *req,
 	ret = crypto_enqueue_request(&priv->ring[ring].queue, &req->base);
 	spin_unlock_bh(&priv->ring[ring].queue_lock);
 
-	if (!priv->ring[ring].need_dequeue)
-		safexcel_dequeue(priv, ring);
+	queue_work(priv->ring[ring].workqueue,
+		   &priv->ring[ring].work_data.work);
 
 	return ret;
 }
diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index d233f4a09712..2fb5bc6b6268 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -381,8 +381,8 @@ static int safexcel_handle_inv_result(struct safexcel_crypto_priv *priv,
 	if (enq_ret != -EINPROGRESS)
 		*ret = enq_ret;
 
-	if (!priv->ring[ring].need_dequeue)
-		safexcel_dequeue(priv, ring);
+	queue_work(priv->ring[ring].workqueue,
+		   &priv->ring[ring].work_data.work);
 
 	*should_complete = false;
 
@@ -470,8 +470,8 @@ static int safexcel_ahash_exit_inv(struct crypto_tfm *tfm)
 	crypto_enqueue_request(&priv->ring[ring].queue, &req->base);
 	spin_unlock_bh(&priv->ring[ring].queue_lock);
 
-	if (!priv->ring[ring].need_dequeue)
-		safexcel_dequeue(priv, ring);
+	queue_work(priv->ring[ring].workqueue,
+		   &priv->ring[ring].work_data.work);
 
 	wait_for_completion_interruptible(&result.completion);
 
@@ -556,8 +556,8 @@ static int safexcel_ahash_enqueue(struct ahash_request *areq)
 	ret = crypto_enqueue_request(&priv->ring[ring].queue, &areq->base);
 	spin_unlock_bh(&priv->ring[ring].queue_lock);
 
-	if (!priv->ring[ring].need_dequeue)
-		safexcel_dequeue(priv, ring);
+	queue_work(priv->ring[ring].workqueue,
+		   &priv->ring[ring].work_data.work);
 
 	return ret;
 }
-- 
2.14.3
