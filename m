From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH v3 1/1] crypto: engine: permit to enqueue ashash_request
Date: Thu,  2 Jun 2016 15:13:32 +0200
Message-ID: <1464873212-15426-2-git-send-email-clabbe.montjoie@gmail.com>
References: <1464873212-15426-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	LABBE Corentin <clabbe.montjoie@gmail.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net,
	baolin.wang@linaro.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1464873212-15426-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The current crypto engine allow only ablkcipher_request to be enqueued.
Thus denying any use of it for hardware that also handle hash algo.

This patch convert all ablkcipher_request references to the
more general crypto_async_request.

Since the crypto engine is now generalist, this patch rename
crypto_one_request to do_one_request.

Since omap-aes/omap-des are the only users, this patch also convert them to
the new cryptoengine API.

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 crypto/crypto_engine.c    | 19 ++++++++-----------
 drivers/crypto/omap-aes.c | 18 +++++++++++++-----
 drivers/crypto/omap-des.c | 18 +++++++++++++-----
 include/crypto/algapi.h   | 18 +++++++++---------
 4 files changed, 43 insertions(+), 30 deletions(-)

diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c
index a55c82d..e9b31f4 100644
--- a/crypto/crypto_engine.c
+++ b/crypto/crypto_engine.c
@@ -19,7 +19,7 @@
 #define CRYPTO_ENGINE_MAX_QLEN 10
 
 void crypto_finalize_request(struct crypto_engine *engine,
-			     struct ablkcipher_request *req, int err);
+			     struct crypto_async_request *req, int err);
 
 /**
  * crypto_pump_requests - dequeue one request from engine queue to process
@@ -34,7 +34,6 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 				 bool in_kthread)
 {
 	struct crypto_async_request *async_req, *backlog;
-	struct ablkcipher_request *req;
 	unsigned long flags;
 	bool was_busy = false;
 	int ret;
@@ -82,9 +81,7 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 	if (!async_req)
 		goto out;
 
-	req = ablkcipher_request_cast(async_req);
-
-	engine->cur_req = req;
+	engine->cur_req = async_req;
 	if (backlog)
 		backlog->complete(backlog, -EINPROGRESS);
 
@@ -113,7 +110,7 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 		engine->cur_req_prepared = true;
 	}
 
-	ret = engine->crypt_one_request(engine, engine->cur_req);
+	ret = engine->do_one_request(engine, engine->cur_req);
 	if (ret) {
 		pr_err("failed to crypt one request from queue\n");
 		goto req_err;
@@ -142,7 +139,7 @@ static void crypto_pump_work(struct kthread_work *work)
  * @req: the request need to be listed into the engine queue
  */
 int crypto_transfer_request(struct crypto_engine *engine,
-			    struct ablkcipher_request *req, bool need_pump)
+			    struct crypto_async_request *req, bool need_pump)
 {
 	unsigned long flags;
 	int ret;
@@ -154,7 +151,7 @@ int crypto_transfer_request(struct crypto_engine *engine,
 		return -ESHUTDOWN;
 	}
 
-	ret = ablkcipher_enqueue_request(&engine->queue, req);
+	ret = crypto_enqueue_request(&engine->queue, req);
 
 	if (!engine->busy && need_pump)
 		queue_kthread_work(&engine->kworker, &engine->pump_requests);
@@ -171,7 +168,7 @@ EXPORT_SYMBOL_GPL(crypto_transfer_request);
  * @req: the request need to be listed into the engine queue
  */
 int crypto_transfer_request_to_engine(struct crypto_engine *engine,
-				      struct ablkcipher_request *req)
+				      struct crypto_async_request *req)
 {
 	return crypto_transfer_request(engine, req, true);
 }
@@ -184,7 +181,7 @@ EXPORT_SYMBOL_GPL(crypto_transfer_request_to_engine);
  * @err: error number
  */
 void crypto_finalize_request(struct crypto_engine *engine,
-			     struct ablkcipher_request *req, int err)
+			     struct crypto_async_request *req, int err)
 {
 	unsigned long flags;
 	bool finalize_cur_req = false;
@@ -208,7 +205,7 @@ void crypto_finalize_request(struct crypto_engine *engine,
 		spin_unlock_irqrestore(&engine->queue_lock, flags);
 	}
 
-	req->base.complete(&req->base, err);
+	req->complete(req, err);
 
 	queue_kthread_work(&engine->kworker, &engine->pump_requests);
 }
diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index ce174d3..a8234fc 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -519,7 +519,7 @@ static void omap_aes_finish_req(struct omap_aes_dev *dd, int err)
 
 	pr_debug("err: %d\n", err);
 
-	crypto_finalize_request(dd->engine, req, err);
+	crypto_finalize_request(dd->engine, &req->base, err);
 }
 
 static int omap_aes_crypt_dma_stop(struct omap_aes_dev *dd)
@@ -592,14 +592,15 @@ static int omap_aes_handle_queue(struct omap_aes_dev *dd,
 				 struct ablkcipher_request *req)
 {
 	if (req)
-		return crypto_transfer_request_to_engine(dd->engine, req);
+		return crypto_transfer_request_to_engine(dd->engine, &req->base);
 
 	return 0;
 }
 
 static int omap_aes_prepare_req(struct crypto_engine *engine,
-				struct ablkcipher_request *req)
+				struct crypto_async_request *areq)
 {
+	struct ablkcipher_request *req = ablkcipher_request_cast(areq);
 	struct omap_aes_ctx *ctx = crypto_ablkcipher_ctx(
 			crypto_ablkcipher_reqtfm(req));
 	struct omap_aes_dev *dd = omap_aes_find_dev(ctx);
@@ -609,6 +610,9 @@ static int omap_aes_prepare_req(struct crypto_engine *engine,
 	if (!dd)
 		return -ENODEV;
 
+	if (crypto_tfm_alg_type(areq->tfm) != CRYPTO_ALG_TYPE_ABLKCIPHER)
+		return -EINVAL;
+
 	/* assign new request to device */
 	dd->req = req;
 	dd->total = req->nbytes;
@@ -642,8 +646,9 @@ static int omap_aes_prepare_req(struct crypto_engine *engine,
 }
 
 static int omap_aes_crypt_req(struct crypto_engine *engine,
-			      struct ablkcipher_request *req)
+			      struct crypto_async_request *areq)
 {
+	struct ablkcipher_request *req = ablkcipher_request_cast(areq);
 	struct omap_aes_ctx *ctx = crypto_ablkcipher_ctx(
 			crypto_ablkcipher_reqtfm(req));
 	struct omap_aes_dev *dd = omap_aes_find_dev(ctx);
@@ -651,6 +656,9 @@ static int omap_aes_crypt_req(struct crypto_engine *engine,
 	if (!dd)
 		return -ENODEV;
 
+	if (crypto_tfm_alg_type(areq->tfm) != CRYPTO_ALG_TYPE_ABLKCIPHER)
+		return -EINVAL;
+
 	return omap_aes_crypt_dma_start(dd);
 }
 
@@ -1205,7 +1213,7 @@ static int omap_aes_probe(struct platform_device *pdev)
 		goto err_algs;
 
 	dd->engine->prepare_request = omap_aes_prepare_req;
-	dd->engine->crypt_one_request = omap_aes_crypt_req;
+	dd->engine->do_one_request = omap_aes_crypt_req;
 	err = crypto_engine_start(dd->engine);
 	if (err)
 		goto err_engine;
diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
index 3eedb03..a8026f7 100644
--- a/drivers/crypto/omap-des.c
+++ b/drivers/crypto/omap-des.c
@@ -506,7 +506,7 @@ static void omap_des_finish_req(struct omap_des_dev *dd, int err)
 	pr_debug("err: %d\n", err);
 
 	pm_runtime_put(dd->dev);
-	crypto_finalize_request(dd->engine, req, err);
+	crypto_finalize_request(dd->engine, &req->base, err);
 }
 
 static int omap_des_crypt_dma_stop(struct omap_des_dev *dd)
@@ -572,14 +572,15 @@ static int omap_des_handle_queue(struct omap_des_dev *dd,
 				 struct ablkcipher_request *req)
 {
 	if (req)
-		return crypto_transfer_request_to_engine(dd->engine, req);
+		return crypto_transfer_request_to_engine(dd->engine, &req->base);
 
 	return 0;
 }
 
 static int omap_des_prepare_req(struct crypto_engine *engine,
-				struct ablkcipher_request *req)
+				struct crypto_async_request *areq)
 {
+	struct ablkcipher_request *req = ablkcipher_request_cast(areq);
 	struct omap_des_ctx *ctx = crypto_ablkcipher_ctx(
 			crypto_ablkcipher_reqtfm(req));
 	struct omap_des_dev *dd = omap_des_find_dev(ctx);
@@ -588,6 +589,9 @@ static int omap_des_prepare_req(struct crypto_engine *engine,
 	if (!dd)
 		return -ENODEV;
 
+	if (crypto_tfm_alg_type(areq->tfm) != CRYPTO_ALG_TYPE_ABLKCIPHER)
+		return -EINVAL;
+
 	/* assign new request to device */
 	dd->req = req;
 	dd->total = req->nbytes;
@@ -620,8 +624,9 @@ static int omap_des_prepare_req(struct crypto_engine *engine,
 }
 
 static int omap_des_crypt_req(struct crypto_engine *engine,
-			      struct ablkcipher_request *req)
+			      struct crypto_async_request *areq)
 {
+	struct ablkcipher_request *req = ablkcipher_request_cast(areq);
 	struct omap_des_ctx *ctx = crypto_ablkcipher_ctx(
 			crypto_ablkcipher_reqtfm(req));
 	struct omap_des_dev *dd = omap_des_find_dev(ctx);
@@ -629,6 +634,9 @@ static int omap_des_crypt_req(struct crypto_engine *engine,
 	if (!dd)
 		return -ENODEV;
 
+	if (crypto_tfm_alg_type(areq->tfm) != CRYPTO_ALG_TYPE_ABLKCIPHER)
+		return -EINVAL;
+
 	return omap_des_crypt_dma_start(dd);
 }
 
@@ -1093,7 +1101,7 @@ static int omap_des_probe(struct platform_device *pdev)
 		goto err_algs;
 
 	dd->engine->prepare_request = omap_des_prepare_req;
-	dd->engine->crypt_one_request = omap_des_crypt_req;
+	dd->engine->do_one_request = omap_des_crypt_req;
 	err = crypto_engine_start(dd->engine);
 	if (err)
 		goto err_engine;
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index eeafd21..c8de827 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -149,7 +149,7 @@ struct ablkcipher_walk {
  * hardware by issuing this call
  * @prepare_request: do some prepare if need before handle the current request
  * @unprepare_request: undo any work done by prepare_message()
- * @crypt_one_request: do encryption for current request
+ * @do_one_request: do encryption for current request
  * @kworker: thread struct for request pump
  * @kworker_task: pointer to task for request pump kworker thread
  * @pump_requests: work struct for scheduling work to the request pump
@@ -173,26 +173,26 @@ struct crypto_engine {
 	int (*unprepare_crypt_hardware)(struct crypto_engine *engine);
 
 	int (*prepare_request)(struct crypto_engine *engine,
-			       struct ablkcipher_request *req);
+			       struct crypto_async_request *req);
 	int (*unprepare_request)(struct crypto_engine *engine,
-				 struct ablkcipher_request *req);
-	int (*crypt_one_request)(struct crypto_engine *engine,
-				 struct ablkcipher_request *req);
+				 struct crypto_async_request *req);
+	int (*do_one_request)(struct crypto_engine *engine,
+			      struct crypto_async_request *req);
 
 	struct kthread_worker           kworker;
 	struct task_struct              *kworker_task;
 	struct kthread_work             pump_requests;
 
 	void				*priv_data;
-	struct ablkcipher_request	*cur_req;
+	struct crypto_async_request	*cur_req;
 };
 
 int crypto_transfer_request(struct crypto_engine *engine,
-			    struct ablkcipher_request *req, bool need_pump);
+			    struct crypto_async_request *req, bool need_pump);
 int crypto_transfer_request_to_engine(struct crypto_engine *engine,
-				      struct ablkcipher_request *req);
+				      struct crypto_async_request *req);
 void crypto_finalize_request(struct crypto_engine *engine,
-			     struct ablkcipher_request *req, int err);
+			     struct crypto_async_request *req, int err);
 int crypto_engine_start(struct crypto_engine *engine);
 int crypto_engine_stop(struct crypto_engine *engine);
 struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool rt);
-- 
2.7.3
