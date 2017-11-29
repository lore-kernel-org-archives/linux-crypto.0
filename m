From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH RFC 1/4] crypto: engine - Permit to enqueue all async requests
Date: Wed, 29 Nov 2017 09:41:18 +0100
Message-ID: <20171129084121.9385-2-clabbe.montjoie@gmail.com>
References: <20171129084121.9385-1-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: virtualization@lists.linux-foundation.org,
 Corentin Labbe <clabbe.montjoie@gmail.com>, linux-crypto@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
To: herbert@gondor.apana.org.au, alexandre.torgue@st.com,
 arei.gonglei@huawei.com, davem@davemloft.net, jasowang@redhat.com,
 mcoquelin.stm32@gmail.com, mst@redhat.com, fabien.dessenne@st.com
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20171129084121.9385-1-clabbe.montjoie@gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

The crypto engine could actually only enqueue hash and ablkcipher request.
This patch permit it to enqueue any type of crypto_async_request.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 crypto/crypto_engine.c  | 188 +++++++++++-------------------------------------
 include/crypto/engine.h |  46 +++++-------
 2 files changed, 60 insertions(+), 174 deletions(-)

diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c
index 61e7c4e02fd2..f7c4c4c1f41b 100644
--- a/crypto/crypto_engine.c
+++ b/crypto/crypto_engine.c
@@ -34,11 +34,10 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 				 bool in_kthread)
 {
 	struct crypto_async_request *async_req, *backlog;
-	struct ahash_request *hreq;
-	struct ablkcipher_request *breq;
 	unsigned long flags;
 	bool was_busy = false;
-	int ret, rtype;
+	int ret;
+	struct crypto_engine_reqctx *enginectx;
 
 	spin_lock_irqsave(&engine->queue_lock, flags);
 
@@ -94,7 +93,6 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 
 	spin_unlock_irqrestore(&engine->queue_lock, flags);
 
-	rtype = crypto_tfm_alg_type(engine->cur_req->tfm);
 	/* Until here we get the request need to be encrypted successfully */
 	if (!was_busy && engine->prepare_crypt_hardware) {
 		ret = engine->prepare_crypt_hardware(engine);
@@ -104,57 +102,31 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 		}
 	}
 
-	switch (rtype) {
-	case CRYPTO_ALG_TYPE_AHASH:
-		hreq = ahash_request_cast(engine->cur_req);
-		if (engine->prepare_hash_request) {
-			ret = engine->prepare_hash_request(engine, hreq);
-			if (ret) {
-				dev_err(engine->dev, "failed to prepare request: %d\n",
-					ret);
-				goto req_err;
-			}
-			engine->cur_req_prepared = true;
-		}
-		ret = engine->hash_one_request(engine, hreq);
-		if (ret) {
-			dev_err(engine->dev, "failed to hash one request from queue\n");
-			goto req_err;
-		}
-		return;
-	case CRYPTO_ALG_TYPE_ABLKCIPHER:
-		breq = ablkcipher_request_cast(engine->cur_req);
-		if (engine->prepare_cipher_request) {
-			ret = engine->prepare_cipher_request(engine, breq);
-			if (ret) {
-				dev_err(engine->dev, "failed to prepare request: %d\n",
-					ret);
-				goto req_err;
-			}
-			engine->cur_req_prepared = true;
-		}
-		ret = engine->cipher_one_request(engine, breq);
+	enginectx = crypto_tfm_ctx(async_req->tfm);
+
+	if (enginectx->op.prepare_request) {
+		ret = enginectx->op.prepare_request(engine, async_req);
 		if (ret) {
-			dev_err(engine->dev, "failed to cipher one request from queue\n");
+			dev_err(engine->dev, "failed to prepare request: %d\n",
+				ret);
 			goto req_err;
 		}
-		return;
-	default:
-		dev_err(engine->dev, "failed to prepare request of unknown type\n");
-		return;
+		engine->cur_req_prepared = true;
+	}
+	if (!enginectx->op.do_one_request) {
+		dev_err(engine->dev, "failed to do request\n");
+		ret = -EINVAL;
+		goto req_err;
+	}
+	ret = enginectx->op.do_one_request(engine, async_req);
+	if (ret) {
+		dev_err(engine->dev, "failed to hash one request from queue\n");
+		goto req_err;
 	}
+	return;
 
 req_err:
-	switch (rtype) {
-	case CRYPTO_ALG_TYPE_AHASH:
-		hreq = ahash_request_cast(engine->cur_req);
-		crypto_finalize_hash_request(engine, hreq, ret);
-		break;
-	case CRYPTO_ALG_TYPE_ABLKCIPHER:
-		breq = ablkcipher_request_cast(engine->cur_req);
-		crypto_finalize_cipher_request(engine, breq, ret);
-		break;
-	}
+	crypto_finalize_request(engine, async_req, ret);
 	return;
 
 out:
@@ -170,59 +142,16 @@ static void crypto_pump_work(struct kthread_work *work)
 }
 
 /**
- * crypto_transfer_cipher_request - transfer the new request into the
- * enginequeue
+ * crypto_transfer_request - transfer the new request into the engine queue
  * @engine: the hardware engine
  * @req: the request need to be listed into the engine queue
  */
-int crypto_transfer_cipher_request(struct crypto_engine *engine,
-				   struct ablkcipher_request *req,
-				   bool need_pump)
+int crypto_transfer_request(struct crypto_engine *engine,
+			    struct crypto_async_request *req, bool need_pump)
 {
 	unsigned long flags;
 	int ret;
 
-	spin_lock_irqsave(&engine->queue_lock, flags);
-
-	if (!engine->running) {
-		spin_unlock_irqrestore(&engine->queue_lock, flags);
-		return -ESHUTDOWN;
-	}
-
-	ret = ablkcipher_enqueue_request(&engine->queue, req);
-
-	if (!engine->busy && need_pump)
-		kthread_queue_work(engine->kworker, &engine->pump_requests);
-
-	spin_unlock_irqrestore(&engine->queue_lock, flags);
-	return ret;
-}
-EXPORT_SYMBOL_GPL(crypto_transfer_cipher_request);
-
-/**
- * crypto_transfer_cipher_request_to_engine - transfer one request to list
- * into the engine queue
- * @engine: the hardware engine
- * @req: the request need to be listed into the engine queue
- */
-int crypto_transfer_cipher_request_to_engine(struct crypto_engine *engine,
-					     struct ablkcipher_request *req)
-{
-	return crypto_transfer_cipher_request(engine, req, true);
-}
-EXPORT_SYMBOL_GPL(crypto_transfer_cipher_request_to_engine);
-
-/**
- * crypto_transfer_hash_request - transfer the new request into the
- * enginequeue
- * @engine: the hardware engine
- * @req: the request need to be listed into the engine queue
- */
-int crypto_transfer_hash_request(struct crypto_engine *engine,
-				 struct ahash_request *req, bool need_pump)
-{
-	unsigned long flags;
-	int ret;
 
 	spin_lock_irqsave(&engine->queue_lock, flags);
 
@@ -231,7 +160,7 @@ int crypto_transfer_hash_request(struct crypto_engine *engine,
 		return -ESHUTDOWN;
 	}
 
-	ret = ahash_enqueue_request(&engine->queue, req);
+	ret = crypto_enqueue_request(&engine->queue, req);
 
 	if (!engine->busy && need_pump)
 		kthread_queue_work(engine->kworker, &engine->pump_requests);
@@ -239,80 +168,45 @@ int crypto_transfer_hash_request(struct crypto_engine *engine,
 	spin_unlock_irqrestore(&engine->queue_lock, flags);
 	return ret;
 }
-EXPORT_SYMBOL_GPL(crypto_transfer_hash_request);
+EXPORT_SYMBOL_GPL(crypto_transfer_request);
 
 /**
- * crypto_transfer_hash_request_to_engine - transfer one request to list
+ * crypto_transfer_request_to_engine - transfer one request to list
  * into the engine queue
  * @engine: the hardware engine
  * @req: the request need to be listed into the engine queue
  */
-int crypto_transfer_hash_request_to_engine(struct crypto_engine *engine,
-					   struct ahash_request *req)
-{
-	return crypto_transfer_hash_request(engine, req, true);
-}
-EXPORT_SYMBOL_GPL(crypto_transfer_hash_request_to_engine);
-
-/**
- * crypto_finalize_cipher_request - finalize one request if the request is done
- * @engine: the hardware engine
- * @req: the request need to be finalized
- * @err: error number
- */
-void crypto_finalize_cipher_request(struct crypto_engine *engine,
-				    struct ablkcipher_request *req, int err)
+int crypto_transfer_request_to_engine(struct crypto_engine *engine,
+				      struct crypto_async_request *req)
 {
-	unsigned long flags;
-	bool finalize_cur_req = false;
-	int ret;
-
-	spin_lock_irqsave(&engine->queue_lock, flags);
-	if (engine->cur_req == &req->base)
-		finalize_cur_req = true;
-	spin_unlock_irqrestore(&engine->queue_lock, flags);
-
-	if (finalize_cur_req) {
-		if (engine->cur_req_prepared &&
-		    engine->unprepare_cipher_request) {
-			ret = engine->unprepare_cipher_request(engine, req);
-			if (ret)
-				dev_err(engine->dev, "failed to unprepare request\n");
-		}
-		spin_lock_irqsave(&engine->queue_lock, flags);
-		engine->cur_req = NULL;
-		engine->cur_req_prepared = false;
-		spin_unlock_irqrestore(&engine->queue_lock, flags);
-	}
-
-	req->base.complete(&req->base, err);
-
-	kthread_queue_work(engine->kworker, &engine->pump_requests);
+	return crypto_transfer_request(engine, req, true);
 }
-EXPORT_SYMBOL_GPL(crypto_finalize_cipher_request);
+EXPORT_SYMBOL_GPL(crypto_transfer_request_to_engine);
 
 /**
- * crypto_finalize_hash_request - finalize one request if the request is done
+ * crypto_finalize_request - finalize one request if the request is done
  * @engine: the hardware engine
  * @req: the request need to be finalized
  * @err: error number
  */
-void crypto_finalize_hash_request(struct crypto_engine *engine,
-				  struct ahash_request *req, int err)
+void crypto_finalize_request(struct crypto_engine *engine,
+			     struct crypto_async_request *req, int err)
 {
 	unsigned long flags;
 	bool finalize_cur_req = false;
 	int ret;
+	struct crypto_engine_reqctx *enginectx;
 
 	spin_lock_irqsave(&engine->queue_lock, flags);
-	if (engine->cur_req == &req->base)
+	if (engine->cur_req == req)
 		finalize_cur_req = true;
 	spin_unlock_irqrestore(&engine->queue_lock, flags);
 
 	if (finalize_cur_req) {
+		enginectx = crypto_tfm_ctx(req->tfm);
 		if (engine->cur_req_prepared &&
-		    engine->unprepare_hash_request) {
-			ret = engine->unprepare_hash_request(engine, req);
+		    enginectx->op.unprepare_request) {
+			ret = enginectx->op.unprepare_request(engine, req);
 			if (ret)
 				dev_err(engine->dev, "failed to unprepare request\n");
 		}
@@ -322,11 +216,11 @@ void crypto_finalize_hash_request(struct crypto_engine *engine,
 		spin_unlock_irqrestore(&engine->queue_lock, flags);
 	}
 
-	req->base.complete(&req->base, err);
+	req->complete(req, err);
 
 	kthread_queue_work(engine->kworker, &engine->pump_requests);
 }
-EXPORT_SYMBOL_GPL(crypto_finalize_hash_request);
+EXPORT_SYMBOL_GPL(crypto_finalize_request);
 
 /**
  * crypto_engine_start - start the hardware engine
diff --git a/include/crypto/engine.h b/include/crypto/engine.h
index dd04c1699b51..2e45db45849b 100644
--- a/include/crypto/engine.h
+++ b/include/crypto/engine.h
@@ -17,7 +17,6 @@
 #include <linux/kernel.h>
 #include <linux/kthread.h>
 #include <crypto/algapi.h>
-#include <crypto/hash.h>
 
 #define ENGINE_NAME_LEN	30
 /*
@@ -65,19 +64,6 @@ struct crypto_engine {
 	int (*prepare_crypt_hardware)(struct crypto_engine *engine);
 	int (*unprepare_crypt_hardware)(struct crypto_engine *engine);
 
-	int (*prepare_cipher_request)(struct crypto_engine *engine,
-				      struct ablkcipher_request *req);
-	int (*unprepare_cipher_request)(struct crypto_engine *engine,
-					struct ablkcipher_request *req);
-	int (*prepare_hash_request)(struct crypto_engine *engine,
-				    struct ahash_request *req);
-	int (*unprepare_hash_request)(struct crypto_engine *engine,
-				      struct ahash_request *req);
-	int (*cipher_one_request)(struct crypto_engine *engine,
-				  struct ablkcipher_request *req);
-	int (*hash_one_request)(struct crypto_engine *engine,
-				struct ahash_request *req);
-
 	struct kthread_worker           *kworker;
 	struct kthread_work             pump_requests;
 
@@ -85,19 +71,25 @@ struct crypto_engine {
 	struct crypto_async_request	*cur_req;
 };
 
-int crypto_transfer_cipher_request(struct crypto_engine *engine,
-				   struct ablkcipher_request *req,
-				   bool need_pump);
-int crypto_transfer_cipher_request_to_engine(struct crypto_engine *engine,
-					     struct ablkcipher_request *req);
-int crypto_transfer_hash_request(struct crypto_engine *engine,
-				 struct ahash_request *req, bool need_pump);
-int crypto_transfer_hash_request_to_engine(struct crypto_engine *engine,
-					   struct ahash_request *req);
-void crypto_finalize_cipher_request(struct crypto_engine *engine,
-				    struct ablkcipher_request *req, int err);
-void crypto_finalize_hash_request(struct crypto_engine *engine,
-				  struct ahash_request *req, int err);
+struct crypto_engine_op {
+	int (*prepare_request)(struct crypto_engine *engine,
+			       struct crypto_async_request *areq);
+	int (*unprepare_request)(struct crypto_engine *engine,
+				 struct crypto_async_request *areq);
+	int (*do_one_request)(struct crypto_engine *engine,
+			      struct crypto_async_request *areq);
+};
+
+struct crypto_engine_reqctx {
+	struct crypto_engine_op op;
+};
+
+int crypto_transfer_request(struct crypto_engine *engine,
+			    struct crypto_async_request *req, bool need_pump);
+int crypto_transfer_request_to_engine(struct crypto_engine *engine,
+				      struct crypto_async_request *req);
+void crypto_finalize_request(struct crypto_engine *engine,
+			     struct crypto_async_request *req, int err);
 int crypto_engine_start(struct crypto_engine *engine);
 int crypto_engine_stop(struct crypto_engine *engine);
 struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool rt);
-- 
2.13.6
