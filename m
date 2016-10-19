From: Petr Mladek <pmladek@suse.com>
Subject: [PATCH] crypto: engine - Handle the kthread worker using the new API
Date: Wed, 19 Oct 2016 13:54:30 +0200
Message-ID: <1476878070-12024-1-git-send-email-pmladek@suse.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Use the new API to create and destroy the crypto engine kthread
worker. The API hides some implementation details.

In particular, kthread_create_worker() allocates and initializes
struct kthread_worker. It runs the kthread the right way
and stores task_struct into the worker structure.

kthread_destroy_worker() flushes all pending works, stops
the kthread and frees the structure.

This patch does not change the existing behavior except for
dynamically allocating struct kthread_worker and storing
only the pointer of this structure.

It is compile tested only because I did not find an easy
way how to run the code. Well, it should be pretty safe
given the nature of the change.

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 crypto/crypto_engine.c  | 26 +++++++++++---------------
 include/crypto/engine.h |  6 ++----
 2 files changed, 13 insertions(+), 19 deletions(-)

diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c
index 6989ba0046df..f1bf3418d968 100644
--- a/crypto/crypto_engine.c
+++ b/crypto/crypto_engine.c
@@ -47,7 +47,7 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 
 	/* If another context is idling then defer */
 	if (engine->idling) {
-		kthread_queue_work(&engine->kworker, &engine->pump_requests);
+		kthread_queue_work(engine->kworker, &engine->pump_requests);
 		goto out;
 	}
 
@@ -58,7 +58,7 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 
 		/* Only do teardown in the thread */
 		if (!in_kthread) {
-			kthread_queue_work(&engine->kworker,
+			kthread_queue_work(engine->kworker,
 					   &engine->pump_requests);
 			goto out;
 		}
@@ -189,7 +189,7 @@ int crypto_transfer_cipher_request(struct crypto_engine *engine,
 	ret = ablkcipher_enqueue_request(&engine->queue, req);
 
 	if (!engine->busy && need_pump)
-		kthread_queue_work(&engine->kworker, &engine->pump_requests);
+		kthread_queue_work(engine->kworker, &engine->pump_requests);
 
 	spin_unlock_irqrestore(&engine->queue_lock, flags);
 	return ret;
@@ -231,7 +231,7 @@ int crypto_transfer_hash_request(struct crypto_engine *engine,
 	ret = ahash_enqueue_request(&engine->queue, req);
 
 	if (!engine->busy && need_pump)
-		kthread_queue_work(&engine->kworker, &engine->pump_requests);
+		kthread_queue_work(engine->kworker, &engine->pump_requests);
 
 	spin_unlock_irqrestore(&engine->queue_lock, flags);
 	return ret;
@@ -284,7 +284,7 @@ void crypto_finalize_cipher_request(struct crypto_engine *engine,
 
 	req->base.complete(&req->base, err);
 
-	kthread_queue_work(&engine->kworker, &engine->pump_requests);
+	kthread_queue_work(engine->kworker, &engine->pump_requests);
 }
 EXPORT_SYMBOL_GPL(crypto_finalize_cipher_request);
 
@@ -321,7 +321,7 @@ void crypto_finalize_hash_request(struct crypto_engine *engine,
 
 	req->base.complete(&req->base, err);
 
-	kthread_queue_work(&engine->kworker, &engine->pump_requests);
+	kthread_queue_work(engine->kworker, &engine->pump_requests);
 }
 EXPORT_SYMBOL_GPL(crypto_finalize_hash_request);
 
@@ -345,7 +345,7 @@ int crypto_engine_start(struct crypto_engine *engine)
 	engine->running = true;
 	spin_unlock_irqrestore(&engine->queue_lock, flags);
 
-	kthread_queue_work(&engine->kworker, &engine->pump_requests);
+	kthread_queue_work(engine->kworker, &engine->pump_requests);
 
 	return 0;
 }
@@ -422,11 +422,8 @@ struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool rt)
 	crypto_init_queue(&engine->queue, CRYPTO_ENGINE_MAX_QLEN);
 	spin_lock_init(&engine->queue_lock);
 
-	kthread_init_worker(&engine->kworker);
-	engine->kworker_task = kthread_run(kthread_worker_fn,
-					   &engine->kworker, "%s",
-					   engine->name);
-	if (IS_ERR(engine->kworker_task)) {
+	engine->kworker = kthread_create_worker(0, "%s", engine->name);
+	if (IS_ERR(engine->kworker)) {
 		dev_err(dev, "failed to create crypto request pump task\n");
 		return NULL;
 	}
@@ -434,7 +431,7 @@ struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool rt)
 
 	if (engine->rt) {
 		dev_info(dev, "will run requests pump with realtime priority\n");
-		sched_setscheduler(engine->kworker_task, SCHED_FIFO, &param);
+		sched_setscheduler(engine->kworker->task, SCHED_FIFO, &param);
 	}
 
 	return engine;
@@ -455,8 +452,7 @@ int crypto_engine_exit(struct crypto_engine *engine)
 	if (ret)
 		return ret;
 
-	kthread_flush_worker(&engine->kworker);
-	kthread_stop(engine->kworker_task);
+	kthread_destroy_worker(engine->kworker);
 
 	return 0;
 }
diff --git a/include/crypto/engine.h b/include/crypto/engine.h
index 04eb5c77addd..1bf600fc99f7 100644
--- a/include/crypto/engine.h
+++ b/include/crypto/engine.h
@@ -43,8 +43,7 @@
  * @prepare_hash_request: do some prepare if need before handle the current request
  * @unprepare_hash_request: undo any work done by prepare_hash_request()
  * @hash_one_request: do hash for current request
- * @kworker: thread struct for request pump
- * @kworker_task: pointer to task for request pump kworker thread
+ * @kworker: kthread worker struct for request pump
  * @pump_requests: work struct for scheduling work to the request pump
  * @priv_data: the engine private data
  * @cur_req: the current request which is on processing
@@ -78,8 +77,7 @@ struct crypto_engine {
 	int (*hash_one_request)(struct crypto_engine *engine,
 				struct ahash_request *req);
 
-	struct kthread_worker           kworker;
-	struct task_struct              *kworker_task;
+	struct kthread_worker           *kworker;
 	struct kthread_work             pump_requests;
 
 	void				*priv_data;
-- 
1.8.5.6
