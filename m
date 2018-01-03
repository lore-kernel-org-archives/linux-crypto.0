From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH 2/6] crypto: engine - Permit to enqueue all async requests
Date: Wed,  3 Jan 2018 21:11:05 +0100
Message-ID: <20180103201109.16077-3-clabbe.montjoie@gmail.com>
References: <20180103201109.16077-1-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	fabien.dessenne@st.com, virtualization@lists.linux-foundation.org,
	Corentin Labbe <clabbe.montjoie@gmail.com>, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
To: alexandre.torgue@st.com, arei.gonglei@huawei.com, corbet@lwn.net,
	davem@davemloft.net, herbert@gondor.apana.org.au, jasowang@redhat.com,
	mcoquelin.stm32@gmail.com, mst@redhat.com
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20180103201109.16077-1-clabbe.montjoie@gmail.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
List-Id: linux-crypto.vger.kernel.org

The crypto engine could actually only enqueue hash and ablkcipher request.
This patch permit it to enqueue any type of crypto_async_request.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 crypto/crypto_engine.c  | 230 ++++++++++++++++++++++++------------------------
 include/crypto/engine.h |  59 +++++++------
 2 files changed, 148 insertions(+), 141 deletions(-)

diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c
index 61e7c4e02fd2..036270b61648 100644
--- a/crypto/crypto_engine.c
+++ b/crypto/crypto_engine.c
@@ -15,7 +15,6 @@
 #include <linux/err.h>
 #include <linux/delay.h>
 #include <crypto/engine.h>
-#include <crypto/internal/hash.h>
 #include <uapi/linux/sched/types.h>
 #include "internal.h"
 
@@ -34,11 +33,10 @@ static void crypto_pump_requests(struct crypto_engine *engine,
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
 
@@ -94,7 +92,6 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 
 	spin_unlock_irqrestore(&engine->queue_lock, flags);
 
-	rtype = crypto_tfm_alg_type(engine->cur_req->tfm);
 	/* Until here we get the request need to be encrypted successfully */
 	if (!was_busy && engine->prepare_crypt_hardware) {
 		ret = engine->prepare_crypt_hardware(engine);
@@ -104,57 +101,31 @@ static void crypto_pump_requests(struct crypto_engine *engine,
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
+		dev_err(engine->dev, "Failed to do one request from queue: %d\n", ret);
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
@@ -170,13 +141,12 @@ static void crypto_pump_work(struct kthread_work *work)
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
+static int crypto_transfer_request(struct crypto_engine *engine,
+				   struct crypto_async_request *req,
 				   bool need_pump)
 {
 	unsigned long flags;
@@ -189,7 +159,7 @@ int crypto_transfer_cipher_request(struct crypto_engine *engine,
 		return -ESHUTDOWN;
 	}
 
-	ret = ablkcipher_enqueue_request(&engine->queue, req);
+	ret = crypto_enqueue_request(&engine->queue, req);
 
 	if (!engine->busy && need_pump)
 		kthread_queue_work(engine->kworker, &engine->pump_requests);
@@ -197,85 +167,97 @@ int crypto_transfer_cipher_request(struct crypto_engine *engine,
 	spin_unlock_irqrestore(&engine->queue_lock, flags);
 	return ret;
 }
-EXPORT_SYMBOL_GPL(crypto_transfer_cipher_request);
+EXPORT_SYMBOL_GPL(crypto_transfer_request);
 
 /**
- * crypto_transfer_cipher_request_to_engine - transfer one request to list
+ * crypto_transfer_request_to_engine - transfer one request to list
  * into the engine queue
  * @engine: the hardware engine
  * @req: the request need to be listed into the engine queue
  */
+static int crypto_transfer_request_to_engine(struct crypto_engine *engine,
+					     struct crypto_async_request *req)
+{
+	return crypto_transfer_request(engine, req, true);
+}
+
+/**
+ * crypto_transfer_cipher_request_to_engine - transfer one ablkcipher_request
+ * to list into the engine queue
+ * @engine: the hardware engine
+ * @req: the request need to be listed into the engine queue
+ * TODO: Remove this function when skcipher conversion is finished
+ */
 int crypto_transfer_cipher_request_to_engine(struct crypto_engine *engine,
 					     struct ablkcipher_request *req)
 {
-	return crypto_transfer_cipher_request(engine, req, true);
+	return crypto_transfer_request_to_engine(engine, &req->base);
 }
 EXPORT_SYMBOL_GPL(crypto_transfer_cipher_request_to_engine);
 
 /**
- * crypto_transfer_hash_request - transfer the new request into the
- * enginequeue
+ * crypto_transfer_skcipher_request_to_engine - transfer one skcipher_request
+ * to list into the engine queue
  * @engine: the hardware engine
  * @req: the request need to be listed into the engine queue
  */
-int crypto_transfer_hash_request(struct crypto_engine *engine,
-				 struct ahash_request *req, bool need_pump)
+int crypto_transfer_skcipher_request_to_engine(struct crypto_engine *engine,
+					       struct skcipher_request *req)
 {
-	unsigned long flags;
-	int ret;
-
-	spin_lock_irqsave(&engine->queue_lock, flags);
-
-	if (!engine->running) {
-		spin_unlock_irqrestore(&engine->queue_lock, flags);
-		return -ESHUTDOWN;
-	}
-
-	ret = ahash_enqueue_request(&engine->queue, req);
-
-	if (!engine->busy && need_pump)
-		kthread_queue_work(engine->kworker, &engine->pump_requests);
+	return crypto_transfer_request_to_engine(engine, &req->base);
+}
+EXPORT_SYMBOL_GPL(crypto_transfer_skcipher_request_to_engine);
 
-	spin_unlock_irqrestore(&engine->queue_lock, flags);
-	return ret;
+/**
+ * crypto_transfer_akcipher_request_to_engine - transfer one akcipher_request
+ * to list into the engine queue
+ * @engine: the hardware engine
+ * @req: the request need to be listed into the engine queue
+ */
+int crypto_transfer_akcipher_request_to_engine(struct crypto_engine *engine,
+					       struct akcipher_request *req)
+{
+	return crypto_transfer_request_to_engine(engine, &req->base);
 }
-EXPORT_SYMBOL_GPL(crypto_transfer_hash_request);
+EXPORT_SYMBOL_GPL(crypto_transfer_akcipher_request_to_engine);
 
 /**
- * crypto_transfer_hash_request_to_engine - transfer one request to list
- * into the engine queue
+ * crypto_transfer_hash_request_to_engine - transfer one ahash_request
+ * to list into the engine queue
  * @engine: the hardware engine
  * @req: the request need to be listed into the engine queue
  */
 int crypto_transfer_hash_request_to_engine(struct crypto_engine *engine,
 					   struct ahash_request *req)
 {
-	return crypto_transfer_hash_request(engine, req, true);
+	return crypto_transfer_request_to_engine(engine, &req->base);
 }
 EXPORT_SYMBOL_GPL(crypto_transfer_hash_request_to_engine);
 
 /**
- * crypto_finalize_cipher_request - finalize one request if the request is done
+ * crypto_finalize_request - finalize one request if the request is done
  * @engine: the hardware engine
  * @req: the request need to be finalized
  * @err: error number
  */
-void crypto_finalize_cipher_request(struct crypto_engine *engine,
-				    struct ablkcipher_request *req, int err)
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
-		    engine->unprepare_cipher_request) {
-			ret = engine->unprepare_cipher_request(engine, req);
+		    enginectx->op.unprepare_request) {
+			ret = enginectx->op.unprepare_request(engine, req);
 			if (ret)
 				dev_err(engine->dev, "failed to unprepare request\n");
 		}
@@ -285,46 +267,64 @@ void crypto_finalize_cipher_request(struct crypto_engine *engine,
 		spin_unlock_irqrestore(&engine->queue_lock, flags);
 	}
 
-	req->base.complete(&req->base, err);
+	req->complete(req, err);
 
 	kthread_queue_work(engine->kworker, &engine->pump_requests);
 }
-EXPORT_SYMBOL_GPL(crypto_finalize_cipher_request);
 
 /**
- * crypto_finalize_hash_request - finalize one request if the request is done
+ * crypto_finalize_cipher_request - finalize one ablkcipher_request if
+ * the request is done
  * @engine: the hardware engine
  * @req: the request need to be finalized
  * @err: error number
  */
-void crypto_finalize_hash_request(struct crypto_engine *engine,
-				  struct ahash_request *req, int err)
+void crypto_finalize_cipher_request(struct crypto_engine *engine,
+				    struct ablkcipher_request *req, int err)
 {
-	unsigned long flags;
-	bool finalize_cur_req = false;
-	int ret;
-
-	spin_lock_irqsave(&engine->queue_lock, flags);
-	if (engine->cur_req == &req->base)
-		finalize_cur_req = true;
-	spin_unlock_irqrestore(&engine->queue_lock, flags);
+	return crypto_finalize_request(engine, &req->base, err);
+}
+EXPORT_SYMBOL_GPL(crypto_finalize_cipher_request);
 
-	if (finalize_cur_req) {
-		if (engine->cur_req_prepared &&
-		    engine->unprepare_hash_request) {
-			ret = engine->unprepare_hash_request(engine, req);
-			if (ret)
-				dev_err(engine->dev, "failed to unprepare request\n");
-		}
-		spin_lock_irqsave(&engine->queue_lock, flags);
-		engine->cur_req = NULL;
-		engine->cur_req_prepared = false;
-		spin_unlock_irqrestore(&engine->queue_lock, flags);
-	}
+/**
+ * crypto_finalize_skcipher_request - finalize one skcipher_request if
+ * the request is done
+ * @engine: the hardware engine
+ * @req: the request need to be finalized
+ * @err: error number
+ */
+void crypto_finalize_skcipher_request(struct crypto_engine *engine,
+				      struct skcipher_request *req, int err)
+{
+	return crypto_finalize_request(engine, &req->base, err);
+}
+EXPORT_SYMBOL_GPL(crypto_finalize_skcipher_request);
 
-	req->base.complete(&req->base, err);
+/**
+ * crypto_finalize_akcipher_request - finalize one akcipher_request if
+ * the request is done
+ * @engine: the hardware engine
+ * @req: the request need to be finalized
+ * @err: error number
+ */
+void crypto_finalize_akcipher_request(struct crypto_engine *engine,
+				      struct akcipher_request *req, int err)
+{
+	return crypto_finalize_request(engine, &req->base, err);
+}
+EXPORT_SYMBOL_GPL(crypto_finalize_akcipher_request);
 
-	kthread_queue_work(engine->kworker, &engine->pump_requests);
+/**
+ * crypto_finalize_hash_request - finalize one ahash_request if
+ * the request is done
+ * @engine: the hardware engine
+ * @req: the request need to be finalized
+ * @err: error number
+ */
+void crypto_finalize_hash_request(struct crypto_engine *engine,
+				  struct ahash_request *req, int err)
+{
+	return crypto_finalize_request(engine, &req->base, err);
 }
 EXPORT_SYMBOL_GPL(crypto_finalize_hash_request);
 
diff --git a/include/crypto/engine.h b/include/crypto/engine.h
index dd04c1699b51..1ea7cbe92eaf 100644
--- a/include/crypto/engine.h
+++ b/include/crypto/engine.h
@@ -17,7 +17,9 @@
 #include <linux/kernel.h>
 #include <linux/kthread.h>
 #include <crypto/algapi.h>
+#include <crypto/akcipher.h>
 #include <crypto/hash.h>
+#include <crypto/skcipher.h>
 
 #define ENGINE_NAME_LEN	30
 /*
@@ -37,12 +39,6 @@
  * @unprepare_crypt_hardware: there are currently no more requests on the
  * queue so the subsystem notifies the driver that it may relax the
  * hardware by issuing this call
- * @prepare_cipher_request: do some prepare if need before handle the current request
- * @unprepare_cipher_request: undo any work done by prepare_cipher_request()
- * @cipher_one_request: do encryption for current request
- * @prepare_hash_request: do some prepare if need before handle the current request
- * @unprepare_hash_request: undo any work done by prepare_hash_request()
- * @hash_one_request: do hash for current request
  * @kworker: kthread worker struct for request pump
  * @pump_requests: work struct for scheduling work to the request pump
  * @priv_data: the engine private data
@@ -65,19 +61,6 @@ struct crypto_engine {
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
 
@@ -85,19 +68,43 @@ struct crypto_engine {
 	struct crypto_async_request	*cur_req;
 };
 
-int crypto_transfer_cipher_request(struct crypto_engine *engine,
-				   struct ablkcipher_request *req,
-				   bool need_pump);
+/*
+ * struct crypto_engine_op - crypto hardware engine operations
+ * @prepare__request: do some prepare if need before handle the current request
+ * @unprepare_request: undo any work done by prepare_request()
+ * @do_one_request: do encryption for current request
+ */
+struct crypto_engine_op {
+	int (*prepare_request)(struct crypto_engine *engine,
+			       void *areq);
+	int (*unprepare_request)(struct crypto_engine *engine,
+				 void *areq);
+	int (*do_one_request)(struct crypto_engine *engine,
+			      void *areq);
+};
+
+struct crypto_engine_reqctx {
+	struct crypto_engine_op op;
+};
+
+int crypto_transfer_akcipher_request_to_engine(struct crypto_engine *engine,
+					       struct akcipher_request *req);
 int crypto_transfer_cipher_request_to_engine(struct crypto_engine *engine,
-					     struct ablkcipher_request *req);
-int crypto_transfer_hash_request(struct crypto_engine *engine,
-				 struct ahash_request *req, bool need_pump);
+				      struct ablkcipher_request *req);
 int crypto_transfer_hash_request_to_engine(struct crypto_engine *engine,
-					   struct ahash_request *req);
+					       struct ahash_request *req);
+int crypto_transfer_skcipher_request_to_engine(struct crypto_engine *engine,
+					       struct skcipher_request *req);
+void crypto_finalize_request(struct crypto_engine *engine,
+			     struct crypto_async_request *req, int err);
+void crypto_finalize_akcipher_request(struct crypto_engine *engine,
+				      struct akcipher_request *req, int err);
 void crypto_finalize_cipher_request(struct crypto_engine *engine,
 				    struct ablkcipher_request *req, int err);
 void crypto_finalize_hash_request(struct crypto_engine *engine,
 				  struct ahash_request *req, int err);
+void crypto_finalize_skcipher_request(struct crypto_engine *engine,
+				      struct skcipher_request *req, int err);
 int crypto_engine_start(struct crypto_engine *engine);
 int crypto_engine_stop(struct crypto_engine *engine);
 struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool rt);
-- 
2.13.6
