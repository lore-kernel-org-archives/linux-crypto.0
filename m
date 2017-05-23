From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH 2/2] crypto: engine - Permit to enqueue skcipher request
Date: Tue, 23 May 2017 14:09:03 +0200
Message-ID: <20170523120903.31637-2-clabbe.montjoie@gmail.com>
References: <20170523120903.31637-1-clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe.montjoie@gmail.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170523120903.31637-1-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The crypto engine could actually only enqueue hash and ablkcipher request.
This patch permit it to enqueue skcipher requets by adding all necessary
functions.
The only problem is that ablkcipher and skcipher id are the same, so
only one cipher type is usable on the same crypto engine.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 crypto/crypto_engine.c  | 136 ++++++++++++++++++++++++++++++++++++++++++++----
 include/crypto/engine.h |  14 +++++
 2 files changed, 139 insertions(+), 11 deletions(-)

diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c
index 61e7c4e02fd2..9f690e04006a 100644
--- a/crypto/crypto_engine.c
+++ b/crypto/crypto_engine.c
@@ -36,6 +36,7 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 	struct crypto_async_request *async_req, *backlog;
 	struct ahash_request *hreq;
 	struct ablkcipher_request *breq;
+	struct skcipher_request *skreq;
 	unsigned long flags;
 	bool was_busy = false;
 	int ret, rtype;
@@ -123,17 +124,34 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 		}
 		return;
 	case CRYPTO_ALG_TYPE_ABLKCIPHER:
-		breq = ablkcipher_request_cast(engine->cur_req);
-		if (engine->prepare_cipher_request) {
-			ret = engine->prepare_cipher_request(engine, breq);
-			if (ret) {
-				dev_err(engine->dev, "failed to prepare request: %d\n",
-					ret);
-				goto req_err;
+	/* since CRYPTO_ALG_TYPE_ABLKCIPHER == CRYPTO_ALG_TYPE_SKCIPHER
+	 * differenciate both with the presence of cipher_one_request
+	 */
+		if (engine->cipher_one_request) {
+			breq = ablkcipher_request_cast(engine->cur_req);
+			if (engine->prepare_cipher_request) {
+				ret = engine->prepare_cipher_request(engine, breq);
+				if (ret) {
+					dev_err(engine->dev, "failed to prepare request: %d\n",
+						ret);
+					goto req_err;
+				}
+				engine->cur_req_prepared = true;
 			}
-			engine->cur_req_prepared = true;
+			ret = engine->cipher_one_request(engine, breq);
+		} else {
+			skreq = skcipher_request_cast(engine->cur_req);
+			if (engine->prepare_skcipher_request) {
+				ret = engine->prepare_skcipher_request(engine, skreq);
+				if (ret) {
+					dev_err(engine->dev, "failed to prepare request: %d\n",
+						ret);
+					goto req_err;
+				}
+				engine->cur_req_prepared = true;
+		}
+		ret = engine->skcipher_one_request(engine, skreq);
 		}
-		ret = engine->cipher_one_request(engine, breq);
 		if (ret) {
 			dev_err(engine->dev, "failed to cipher one request from queue\n");
 			goto req_err;
@@ -151,8 +169,13 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 		crypto_finalize_hash_request(engine, hreq, ret);
 		break;
 	case CRYPTO_ALG_TYPE_ABLKCIPHER:
-		breq = ablkcipher_request_cast(engine->cur_req);
-		crypto_finalize_cipher_request(engine, breq, ret);
+		if (engine->cipher_one_request) {
+			breq = ablkcipher_request_cast(engine->cur_req);
+			crypto_finalize_cipher_request(engine, breq, ret);
+		} else {
+			skreq = skcipher_request_cast(engine->cur_req);
+			crypto_finalize_skcipher_request(engine, skreq, ret);
+		}
 		break;
 	}
 	return;
@@ -213,6 +236,49 @@ int crypto_transfer_cipher_request_to_engine(struct crypto_engine *engine,
 EXPORT_SYMBOL_GPL(crypto_transfer_cipher_request_to_engine);
 
 /**
+ * crypto_transfer_skcipher_request - transfer the new request into the
+ * enginequeue
+ * @engine: the hardware engine
+ * @req: the request need to be listed into the engine queue
+ */
+int crypto_transfer_skcipher_request(struct crypto_engine *engine,
+				     struct skcipher_request *req,
+				     bool need_pump)
+{
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&engine->queue_lock, flags);
+
+	if (!engine->running) {
+		spin_unlock_irqrestore(&engine->queue_lock, flags);
+		return -ESHUTDOWN;
+	}
+
+	ret = crypto_enqueue_request(&engine->queue, &req->base);
+
+	if (!engine->busy && need_pump)
+		kthread_queue_work(engine->kworker, &engine->pump_requests);
+
+	spin_unlock_irqrestore(&engine->queue_lock, flags);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(crypto_transfer_skcipher_request);
+
+/**
+ * crypto_transfer_skcipher_request_to_engine - transfer one request to list
+ * into the engine queue
+ * @engine: the hardware engine
+ * @req: the request need to be listed into the engine queue
+ */
+int crypto_transfer_skcipher_request_to_engine(struct crypto_engine *engine,
+					       struct skcipher_request *req)
+{
+	return crypto_transfer_skcipher_request(engine, req, true);
+}
+EXPORT_SYMBOL_GPL(crypto_transfer_skcipher_request_to_engine);
+
+/**
  * crypto_transfer_hash_request - transfer the new request into the
  * enginequeue
  * @engine: the hardware engine
@@ -292,6 +358,43 @@ void crypto_finalize_cipher_request(struct crypto_engine *engine,
 EXPORT_SYMBOL_GPL(crypto_finalize_cipher_request);
 
 /**
+ * crypto_finalize_skcipher_request - finalize one request if the request is done
+ * @engine: the hardware engine
+ * @req: the request need to be finalized
+ * @err: error number
+ */
+void crypto_finalize_skcipher_request(struct crypto_engine *engine,
+				      struct skcipher_request *req, int err)
+{
+	unsigned long flags;
+	bool finalize_cur_req = false;
+	int ret;
+
+	spin_lock_irqsave(&engine->queue_lock, flags);
+	if (engine->cur_req == &req->base)
+		finalize_cur_req = true;
+	spin_unlock_irqrestore(&engine->queue_lock, flags);
+
+	if (finalize_cur_req) {
+		if (engine->cur_req_prepared &&
+		    engine->unprepare_skcipher_request) {
+			ret = engine->unprepare_skcipher_request(engine, req);
+			if (ret)
+				dev_err(engine->dev, "failed to unprepare request\n");
+		}
+		spin_lock_irqsave(&engine->queue_lock, flags);
+		engine->cur_req = NULL;
+		engine->cur_req_prepared = false;
+		spin_unlock_irqrestore(&engine->queue_lock, flags);
+	}
+
+	req->base.complete(&req->base, err);
+
+	kthread_queue_work(engine->kworker, &engine->pump_requests);
+}
+EXPORT_SYMBOL_GPL(crypto_finalize_skcipher_request);
+
+/**
  * crypto_finalize_hash_request - finalize one request if the request is done
  * @engine: the hardware engine
  * @req: the request need to be finalized
@@ -345,6 +448,17 @@ int crypto_engine_start(struct crypto_engine *engine)
 		return -EBUSY;
 	}
 
+	if (!engine->skcipher_one_request && !engine->cipher_one_request &&
+	    !engine->hash_one_request) {
+		dev_err(engine->dev, "need at least one request type\n");
+		return -EINVAL;
+	}
+
+	if (engine->skcipher_one_request && engine->cipher_one_request) {
+		dev_err(engine->dev, "Cannot use both skcipher and ablkcipher\n");
+		return -EINVAL;
+	}
+
 	engine->running = true;
 	spin_unlock_irqrestore(&engine->queue_lock, flags);
 
diff --git a/include/crypto/engine.h b/include/crypto/engine.h
index 9e968a1033d0..a83139311e59 100644
--- a/include/crypto/engine.h
+++ b/include/crypto/engine.h
@@ -18,6 +18,7 @@
 #include <linux/kthread.h>
 #include <crypto/algapi.h>
 #include <crypto/hash.h>
+#include <crypto/skcipher.h>
 
 #define ENGINE_NAME_LEN	30
 /*
@@ -69,12 +70,18 @@ struct crypto_engine {
 				      struct ablkcipher_request *req);
 	int (*unprepare_cipher_request)(struct crypto_engine *engine,
 					struct ablkcipher_request *req);
+	int (*prepare_skcipher_request)(struct crypto_engine *engine,
+					struct skcipher_request *req);
+	int (*unprepare_skcipher_request)(struct crypto_engine *engine,
+					  struct skcipher_request *req);
 	int (*prepare_hash_request)(struct crypto_engine *engine,
 				    struct ahash_request *req);
 	int (*unprepare_hash_request)(struct crypto_engine *engine,
 				      struct ahash_request *req);
 	int (*cipher_one_request)(struct crypto_engine *engine,
 				  struct ablkcipher_request *req);
+	int (*skcipher_one_request)(struct crypto_engine *engine,
+				    struct skcipher_request *req);
 	int (*hash_one_request)(struct crypto_engine *engine,
 				struct ahash_request *req);
 
@@ -90,12 +97,19 @@ int crypto_transfer_cipher_request(struct crypto_engine *engine,
 				   bool need_pump);
 int crypto_transfer_cipher_request_to_engine(struct crypto_engine *engine,
 					     struct ablkcipher_request *req);
+int crypto_transfer_skcipher_request(struct crypto_engine *engine,
+				     struct skcipher_request *req,
+				     bool need_pump);
+int crypto_transfer_skcipher_request_to_engine(struct crypto_engine *engine,
+					       struct skcipher_request *req);
 int crypto_transfer_hash_request(struct crypto_engine *engine,
 				 struct ahash_request *req, bool need_pump);
 int crypto_transfer_hash_request_to_engine(struct crypto_engine *engine,
 					   struct ahash_request *req);
 void crypto_finalize_cipher_request(struct crypto_engine *engine,
 				    struct ablkcipher_request *req, int err);
+void crypto_finalize_skcipher_request(struct crypto_engine *engine,
+				      struct skcipher_request *req, int err);
 void crypto_finalize_hash_request(struct crypto_engine *engine,
 				  struct ahash_request *req, int err);
 int crypto_engine_start(struct crypto_engine *engine);
-- 
2.13.0
