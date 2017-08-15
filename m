From: Fabien Dessenne <fabien.dessenne@st.com>
Subject: [PATCH v2 1/3] crypto: engine - permit to enqueue aead_request
Date: Tue, 15 Aug 2017 09:19:42 +0200
Message-ID: <1502781584-18468-2-git-send-email-fabien.dessenne@st.com>
References: <1502781584-18468-1-git-send-email-fabien.dessenne@st.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Benjamin Gaignard <benjamin.gaignard@st.com>,
        Lionel Debieve <lionel.debieve@st.com>,
        Ludovic Barre <ludovic.barre@st.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        <linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1502781584-18468-1-git-send-email-fabien.dessenne@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The current crypto engine allows ablkcipher_request and ahash_request to
be enqueued. Extend this to aead_request.

Signed-off-by: Fabien Dessenne <fabien.dessenne@st.com>
---
 crypto/crypto_engine.c  | 101 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/crypto/engine.h |  16 ++++++++
 2 files changed, 117 insertions(+)

diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c
index 61e7c4e..3cdf051 100644
--- a/crypto/crypto_engine.c
+++ b/crypto/crypto_engine.c
@@ -15,6 +15,7 @@
 #include <linux/err.h>
 #include <linux/delay.h>
 #include <crypto/engine.h>
+#include <crypto/internal/aead.h>
 #include <crypto/internal/hash.h>
 #include <uapi/linux/sched/types.h>
 #include "internal.h"
@@ -35,6 +36,7 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 {
 	struct crypto_async_request *async_req, *backlog;
 	struct ahash_request *hreq;
+	struct aead_request *areq;
 	struct ablkcipher_request *breq;
 	unsigned long flags;
 	bool was_busy = false;
@@ -122,6 +124,22 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 			goto req_err;
 		}
 		return;
+	case CRYPTO_ALG_TYPE_AEAD:
+		areq = aead_request_cast(engine->cur_req);
+		if (engine->prepare_aead_request) {
+			ret = engine->prepare_aead_request(engine, areq);
+			if (ret) {
+				pr_err("failed to prepare request: %d\n", ret);
+				goto req_err;
+			}
+			engine->cur_req_prepared = true;
+		}
+		ret = engine->aead_one_request(engine, areq);
+		if (ret) {
+			pr_err("failed to do aead one request from queue\n");
+			goto req_err;
+		}
+		return;
 	case CRYPTO_ALG_TYPE_ABLKCIPHER:
 		breq = ablkcipher_request_cast(engine->cur_req);
 		if (engine->prepare_cipher_request) {
@@ -150,6 +168,10 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 		hreq = ahash_request_cast(engine->cur_req);
 		crypto_finalize_hash_request(engine, hreq, ret);
 		break;
+	case CRYPTO_ALG_TYPE_AEAD:
+		areq = aead_request_cast(engine->cur_req);
+		crypto_finalize_aead_request(engine, areq, ret);
+		break;
 	case CRYPTO_ALG_TYPE_ABLKCIPHER:
 		breq = ablkcipher_request_cast(engine->cur_req);
 		crypto_finalize_cipher_request(engine, breq, ret);
@@ -255,6 +277,48 @@ int crypto_transfer_hash_request_to_engine(struct crypto_engine *engine,
 EXPORT_SYMBOL_GPL(crypto_transfer_hash_request_to_engine);
 
 /**
+ * crypto_transfer_aead_request - transfer the new request into the
+ * enginequeue
+ * @engine: the hardware engine
+ * @req: the request need to be listed into the engine queue
+ */
+int crypto_transfer_aead_request(struct crypto_engine *engine,
+				 struct aead_request *req, bool need_pump)
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
+	ret = aead_enqueue_request((struct aead_queue *)&engine->queue, req);
+
+	if (!engine->busy && need_pump)
+		kthread_queue_work(engine->kworker, &engine->pump_requests);
+
+	spin_unlock_irqrestore(&engine->queue_lock, flags);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(crypto_transfer_aead_request);
+
+/**
+ * crypto_transfer_aead_request_to_engine - transfer one request to list
+ * into the engine queue
+ * @engine: the hardware engine
+ * @req: the request need to be listed into the engine queue
+ */
+int crypto_transfer_aead_request_to_engine(struct crypto_engine *engine,
+					   struct aead_request *req)
+{
+	return crypto_transfer_aead_request(engine, req, true);
+}
+EXPORT_SYMBOL_GPL(crypto_transfer_aead_request_to_engine);
+
+/**
  * crypto_finalize_cipher_request - finalize one request if the request is done
  * @engine: the hardware engine
  * @req: the request need to be finalized
@@ -329,6 +393,43 @@ void crypto_finalize_hash_request(struct crypto_engine *engine,
 EXPORT_SYMBOL_GPL(crypto_finalize_hash_request);
 
 /**
+ * crypto_finalize_aead_request - finalize one request if the request is done
+ * @engine: the hardware engine
+ * @req: the request need to be finalized
+ * @err: error number
+ */
+void crypto_finalize_aead_request(struct crypto_engine *engine,
+				  struct aead_request *req, int err)
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
+		    engine->unprepare_aead_request) {
+			ret = engine->unprepare_aead_request(engine, req);
+			if (ret)
+				pr_err("failed to unprepare request\n");
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
+EXPORT_SYMBOL_GPL(crypto_finalize_aead_request);
+
+/**
  * crypto_engine_start - start the hardware engine
  * @engine: the hardware engine need to be started
  *
diff --git a/include/crypto/engine.h b/include/crypto/engine.h
index dd04c16..9ee1722 100644
--- a/include/crypto/engine.h
+++ b/include/crypto/engine.h
@@ -16,6 +16,7 @@
 #include <linux/list.h>
 #include <linux/kernel.h>
 #include <linux/kthread.h>
+#include <crypto/aead.h>
 #include <crypto/algapi.h>
 #include <crypto/hash.h>
 
@@ -43,6 +44,9 @@
  * @prepare_hash_request: do some prepare if need before handle the current request
  * @unprepare_hash_request: undo any work done by prepare_hash_request()
  * @hash_one_request: do hash for current request
+ * @prepare_aead_request: do some prepare if need before handle the current request
+ * @unprepare_aead_request: undo any work done by prepare_aead_request()
+ * @aead_one_request: do aead for current request
  * @kworker: kthread worker struct for request pump
  * @pump_requests: work struct for scheduling work to the request pump
  * @priv_data: the engine private data
@@ -73,10 +77,16 @@ struct crypto_engine {
 				    struct ahash_request *req);
 	int (*unprepare_hash_request)(struct crypto_engine *engine,
 				      struct ahash_request *req);
+	int (*prepare_aead_request)(struct crypto_engine *engine,
+				    struct aead_request *req);
+	int (*unprepare_aead_request)(struct crypto_engine *engine,
+				      struct aead_request *req);
 	int (*cipher_one_request)(struct crypto_engine *engine,
 				  struct ablkcipher_request *req);
 	int (*hash_one_request)(struct crypto_engine *engine,
 				struct ahash_request *req);
+	int (*aead_one_request)(struct crypto_engine *engine,
+				struct aead_request *req);
 
 	struct kthread_worker           *kworker;
 	struct kthread_work             pump_requests;
@@ -94,10 +104,16 @@ int crypto_transfer_hash_request(struct crypto_engine *engine,
 				 struct ahash_request *req, bool need_pump);
 int crypto_transfer_hash_request_to_engine(struct crypto_engine *engine,
 					   struct ahash_request *req);
+int crypto_transfer_aead_request(struct crypto_engine *engine,
+				 struct aead_request *req, bool need_pump);
+int crypto_transfer_aead_request_to_engine(struct crypto_engine *engine,
+					   struct aead_request *req);
 void crypto_finalize_cipher_request(struct crypto_engine *engine,
 				    struct ablkcipher_request *req, int err);
 void crypto_finalize_hash_request(struct crypto_engine *engine,
 				  struct ahash_request *req, int err);
+void crypto_finalize_aead_request(struct crypto_engine *engine,
+				  struct aead_request *req, int err);
 int crypto_engine_start(struct crypto_engine *engine);
 int crypto_engine_stop(struct crypto_engine *engine);
 struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool rt);
-- 
2.7.4
