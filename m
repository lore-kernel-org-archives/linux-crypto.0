From: Baolin Wang <baolin.wang@linaro.org>
Subject: [PATCH v2 3/4] crypto: Introduce the bulk mode for crypto engine framework
Date: Tue, 15 Mar 2016 15:48:01 +0800
Message-ID: <69544da46451eaa41e07ee67c02af4d81ddffe3c.1458023699.git.baolin.wang@linaro.org>
References: <cover.1458023695.git.baolin.wang@linaro.org>
Cc: akpm@linux-foundation.org, david.s.gordon@intel.com,
	thomas.lendacky@amd.com, robert.jarzmik@free.fr,
	yamada.masahiro@socionext.com, smueller@chronox.de,
	tadeusz.struk@intel.com, standby24x7@gmail.com, shli@kernel.org,
	broonie@kernel.org, linus.walleij@linaro.org, arnd@arndb.de,
	baolin.wang@linaro.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-raid@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net, agk@redhat.com,
	snitzer@redhat.com, axboe@fb.com, dm-devel@redhat.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1458023695.git.baolin.wang@linaro.org>
In-Reply-To: <cover.1458023695.git.baolin.wang@linaro.org>
References: <cover.1458023695.git.baolin.wang@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Now some cipher hardware engines prefer to handle bulk block by merging
requests to increase the block size and thus increase the hardware engine
processing speed.

This patch introduces request bulk mode to help the crypto hardware drivers
improve in efficiency, and chooses the suitable mode (SECTOR_MODE) for
initializing omap aes engine.

Signed-off-by: Baolin Wang <baolin.wang@linaro.org>
---
 crypto/Kconfig            |    1 +
 crypto/crypto_engine.c    |  122 +++++++++++++++++++++++++++++++++++++++++++--
 drivers/crypto/omap-aes.c |    2 +-
 include/crypto/algapi.h   |   23 ++++++++-
 4 files changed, 143 insertions(+), 5 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index c844227..6a2f9a6 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -229,6 +229,7 @@ config CRYPTO_GLUE_HELPER_X86
 
 config CRYPTO_ENGINE
 	tristate
+	select CRYPTO_ABLK_HELPER
 
 comment "Authenticated Encryption with Associated Data"
 
diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c
index a55c82d..0de5829 100644
--- a/crypto/crypto_engine.c
+++ b/crypto/crypto_engine.c
@@ -14,6 +14,7 @@
 
 #include <linux/err.h>
 #include <linux/delay.h>
+#include <crypto/ablk_helper.h>
 #include "internal.h"
 
 #define CRYPTO_ENGINE_MAX_QLEN 10
@@ -84,6 +85,17 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 
 	req = ablkcipher_request_cast(async_req);
 
+	/*
+	 * If the engine supports the bulk mode and the request is allocated the
+	 * sg table to expand scatterlists entries, then it need to point the
+	 * scatterlists from the sg table.
+	 */
+	if (engine->mode == SECTOR_BULK_MODE && req->sgt_src.orig_nents &&
+	    req->sgt_dst.orig_nents) {
+		req->src = req->sgt_src.sgl;
+		req->dst = req->sgt_dst.sgl;
+	}
+
 	engine->cur_req = req;
 	if (backlog)
 		backlog->complete(backlog, -EINPROGRESS);
@@ -137,9 +149,46 @@ static void crypto_pump_work(struct kthread_work *work)
 }
 
 /**
+ * crypto_merge_request_to_engine - try to merge one request into previous one
+ * @engine: the hardware engine
+ * @req: the request need to be merged
+ *
+ * If the crypto engine supports bulk mode, then try to merge the new request
+ * into the listed one from engine queue to handle them together.
+ *
+ * Return 0 on success and others are failed.
+ */
+static bool crypto_merge_request_to_engine(struct crypto_engine *engine,
+					   struct ablkcipher_request *req)
+{
+	/*
+	 * The request is allocated from memory pool in dm-crypt, here need to
+	 * do initialization for sg table in case some random values.
+	 */
+	req->sgt_src.orig_nents = 0;
+	req->sgt_dst.orig_nents = 0;
+
+	/*
+	 * If the hardware engine can not support the bulk mode encryption,
+	 * just return 1 means merging failed.
+	 */
+	if (engine->mode != SECTOR_BULK_MODE)
+		return 1;
+
+	return ablk_try_merge(&engine->queue, req);
+}
+
+/**
  * crypto_transfer_request - transfer the new request into the engine queue
  * @engine: the hardware engine
  * @req: the request need to be listed into the engine queue
+ *
+ * Firstly it will check if the new request can be merged into previous one
+ * if their secotr numbers are continuous, if not should list it into engine
+ * queue.
+ *
+ * If the new request can be merged into the previous request, then just
+ * finalize the new request.
  */
 int crypto_transfer_request(struct crypto_engine *engine,
 			    struct ablkcipher_request *req, bool need_pump)
@@ -154,6 +203,26 @@ int crypto_transfer_request(struct crypto_engine *engine,
 		return -ESHUTDOWN;
 	}
 
+	/*
+	 * Here need to check if the request can be merged into previous
+	 * request. If the hardware engine can support encryption with
+	 * bulk block, we can merge the new request into previous request
+	 * if their secotr numbers are continuous, which can be handled
+	 * together by engine to improve the encryption efficiency.
+	 * Return -EINPROGRESS means it has been merged into previous request,
+	 * so just end up this request.
+	 */
+	ret = crypto_merge_request_to_engine(engine, req);
+	if (!ret) {
+		spin_unlock_irqrestore(&engine->queue_lock, flags);
+		crypto_finalize_request(engine, req, 0);
+		return -EINPROGRESS;
+	}
+
+	/*
+	 * If the request can not be merged into previous request, then list it
+	 * into the queue of engine, and will be handled by kthread worker.
+	 */
 	ret = ablkcipher_enqueue_request(&engine->queue, req);
 
 	if (!engine->busy && need_pump)
@@ -178,7 +247,8 @@ int crypto_transfer_request_to_engine(struct crypto_engine *engine,
 EXPORT_SYMBOL_GPL(crypto_transfer_request_to_engine);
 
 /**
- * crypto_finalize_request - finalize one request if the request is done
+ * crypto_finalize_request - finalize one request if the request is done or
+ * merged into previous request
  * @engine: the hardware engine
  * @req: the request need to be finalized
  * @err: error number
@@ -208,9 +278,18 @@ void crypto_finalize_request(struct crypto_engine *engine,
 		spin_unlock_irqrestore(&engine->queue_lock, flags);
 	}
 
+	sg_free_table(&req->sgt_src);
+	sg_free_table(&req->sgt_dst);
 	req->base.complete(&req->base, err);
 
-	queue_kthread_work(&engine->kworker, &engine->pump_requests);
+	/*
+	 * If the request is finalized by merging into the previous request from
+	 * the engine queue, then it is no need to queue the kthread work.
+	 * Cause now maybe there are other requests need to be merged into the
+	 * listed request from one block, just wait for merging action.
+	 */
+	if (finalize_cur_req)
+		queue_kthread_work(&engine->kworker, &engine->pump_requests);
 }
 EXPORT_SYMBOL_GPL(crypto_finalize_request);
 
@@ -279,15 +358,45 @@ int crypto_engine_stop(struct crypto_engine *engine)
 EXPORT_SYMBOL_GPL(crypto_engine_stop);
 
 /**
+ * crypto_engine_change_mode - Change the mode for hardware engine
+ * @engine: the hardware engine
+ * @mode: engine mode to be set
+ *
+ * This function can change the hardware engine mode when the engine is running.
+ * Return 0 on success, else on fail.
+ */
+int crypto_engine_change_mode(struct crypto_engine *engine,
+			      enum engine_mode mode)
+{
+	unsigned long flags;
+	int ret;
+
+	ret = crypto_engine_stop(engine);
+	if (ret) {
+		pr_warn("could not change engine mode now\n");
+		return ret;
+	}
+
+	spin_lock_irqsave(&engine->queue_lock, flags);
+	engine->mode = mode;
+	spin_unlock_irqrestore(&engine->queue_lock, flags);
+
+	return crypto_engine_start(engine);
+}
+EXPORT_SYMBOL_GPL(crypto_engine_change_mode);
+
+/**
  * crypto_engine_alloc_init - allocate crypto hardware engine structure and
  * initialize it.
  * @dev: the device attached with one hardware engine
+ * @mode: crypto engine mode
  * @rt: whether this queue is set to run as a realtime task
  *
  * This must be called from context that can sleep.
  * Return: the crypto engine structure on success, else NULL.
  */
-struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool rt)
+struct crypto_engine *crypto_engine_alloc_init(struct device *dev,
+					       enum engine_mode mode, bool rt)
 {
 	struct sched_param param = { .sched_priority = MAX_RT_PRIO - 1 };
 	struct crypto_engine *engine;
@@ -299,6 +408,13 @@ struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool rt)
 	if (!engine)
 		return NULL;
 
+	/*
+	 * If the hardware engine can handle the IV by itself, that means it
+	 * just need one initial IV for multiple requests from one block. So
+	 * we can merge requests from one block into one request to handle,
+	 * which can improve the hardware engine efficiency.
+	 */
+	engine->mode = mode;
 	engine->rt = rt;
 	engine->running = false;
 	engine->busy = false;
diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index d420ec7..946f11f 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -1230,7 +1230,7 @@ static int omap_aes_probe(struct platform_device *pdev)
 	}
 
 	/* Initialize crypto engine */
-	dd->engine = crypto_engine_alloc_init(dev, 1);
+	dd->engine = crypto_engine_alloc_init(dev, SECTOR_MODE, 1);
 	if (!dd->engine)
 		goto err_algs;
 
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index b09d43f..69fb43e 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -130,6 +130,22 @@ struct ablkcipher_walk {
 };
 
 #define ENGINE_NAME_LEN	30
+
+/*
+ * enum engine_mode - crypto engine mode
+ * @SECTOR_MODE: should do encryption/decryption one request by one (one
+ * request length is one sector size), and it will not coalesce requests.
+ * @SECTOR_BULK_MODE: it can coalesce the contiguous requests (one request
+ * length is one sector size) together to be one bulk request, which can be
+ * handled by crypto engine at one time.
+ * @MAX_MODE: engine mode numbers
+ */
+enum engine_mode {
+	SECTOR_MODE,
+	SECTOR_BULK_MODE,
+	MAX_MODE,
+};
+
 /*
  * struct crypto_engine - crypto hardware engine
  * @name: the engine name
@@ -140,6 +156,7 @@ struct ablkcipher_walk {
  * @list: link with the global crypto engine list
  * @queue_lock: spinlock to syncronise access to request queue
  * @queue: the crypto queue of the engine
+ * @mode: crypto engine mode
  * @rt: whether this queue is set to run as a realtime task
  * @prepare_crypt_hardware: a request will soon arrive from the queue
  * so the subsystem requests the driver to prepare the hardware
@@ -167,6 +184,7 @@ struct crypto_engine {
 	spinlock_t		queue_lock;
 	struct crypto_queue	queue;
 
+	enum engine_mode	mode;
 	bool			rt;
 
 	int (*prepare_crypt_hardware)(struct crypto_engine *engine);
@@ -195,7 +213,10 @@ void crypto_finalize_request(struct crypto_engine *engine,
 			     struct ablkcipher_request *req, int err);
 int crypto_engine_start(struct crypto_engine *engine);
 int crypto_engine_stop(struct crypto_engine *engine);
-struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool rt);
+int crypto_engine_change_mode(struct crypto_engine *engine,
+			      enum engine_mode mode);
+struct crypto_engine *crypto_engine_alloc_init(struct device *dev,
+					       enum engine_mode mode, bool rt);
 int crypto_engine_exit(struct crypto_engine *engine);
 
 extern const struct crypto_type crypto_ablkcipher_type;
-- 
1.7.9.5
