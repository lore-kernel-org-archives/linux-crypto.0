From: Baolin Wang <baolin.wang@linaro.org>
Subject: [PATCH 2/3] crypto: Introduce the block request crypto engine framework
Date: Tue, 26 Jan 2016 20:25:39 +0800
Message-ID: <b536ab5bf45382d77d7fa0409fb6de2df807959f.1453810717.git.baolin.wang@linaro.org>
References: <cover.1453810716.git.baolin.wang@linaro.org>
Cc: broonie@kernel.org, linus.walleij@linaro.org, arnd@arndb.de,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	baolin.wang@linaro.org
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1453810716.git.baolin.wang@linaro.org>
In-Reply-To: <cover.1453810716.git.baolin.wang@linaro.org>
References: <cover.1453810716.git.baolin.wang@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Now block cipher engines need to implement and maintain their own queue/thread
for processing requests, moreover currently helpers provided for only the queue
itself (in crypto_enqueue_request() and crypto_dequeue_request()) but they
don't help with the mechanics of driving the hardware (things like running the
request immediately, DMA map it or providing a thread to process the queue in)
even though a lot of that code really shouldn't vary that much from device to
device.

Thus this patch provides a mechanism for pushing requests to the hardware
as it becomes free that drivers could use. And this framework is patterned
on the SPI code and has worked out well there.
(https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/
 drivers/spi/spi.c?id=ffbbdd21329f3e15eeca6df2d4bc11c04d9d91c0)

Signed-off-by: Baolin Wang <baolin.wang@linaro.org>
---
 crypto/Kconfig          |    3 +
 crypto/Makefile         |    1 +
 crypto/crypto_engine.c  |  355 +++++++++++++++++++++++++++++++++++++++++++++++
 include/crypto/algapi.h |   70 ++++++++++
 4 files changed, 429 insertions(+)
 create mode 100644 crypto/crypto_engine.c

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 7240821..90df301 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -227,6 +227,9 @@ config CRYPTO_GLUE_HELPER_X86
 	depends on X86
 	select CRYPTO_ALGAPI
 
+config CRYPTO_ENGINE
+	tristate
+
 comment "Authenticated Encryption with Associated Data"
 
 config CRYPTO_CCM
diff --git a/crypto/Makefile b/crypto/Makefile
index f7aba92..5490d21 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -7,6 +7,7 @@ crypto-y := api.o cipher.o compress.o memneq.o
 
 obj-$(CONFIG_CRYPTO_WORKQUEUE) += crypto_wq.o
 
+obj-$(CONFIG_CRYPTO_ENGINE) += crypto_engine.o
 obj-$(CONFIG_CRYPTO_FIPS) += fips.o
 
 crypto_algapi-$(CONFIG_PROC_FS) += proc.o
diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c
new file mode 100644
index 0000000..a55c82d
--- /dev/null
+++ b/crypto/crypto_engine.c
@@ -0,0 +1,355 @@
+/*
+ * Handle async block request by crypto hardware engine.
+ *
+ * Copyright (C) 2016 Linaro, Inc.
+ *
+ * Author: Baolin Wang <baolin.wang@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ *
+ */
+
+#include <linux/err.h>
+#include <linux/delay.h>
+#include "internal.h"
+
+#define CRYPTO_ENGINE_MAX_QLEN 10
+
+void crypto_finalize_request(struct crypto_engine *engine,
+			     struct ablkcipher_request *req, int err);
+
+/**
+ * crypto_pump_requests - dequeue one request from engine queue to process
+ * @engine: the hardware engine
+ * @in_kthread: true if we are in the context of the request pump thread
+ *
+ * This function checks if there is any request in the engine queue that
+ * needs processing and if so call out to the driver to initialize hardware
+ * and handle each request.
+ */
+static void crypto_pump_requests(struct crypto_engine *engine,
+				 bool in_kthread)
+{
+	struct crypto_async_request *async_req, *backlog;
+	struct ablkcipher_request *req;
+	unsigned long flags;
+	bool was_busy = false;
+	int ret;
+
+	spin_lock_irqsave(&engine->queue_lock, flags);
+
+	/* Make sure we are not already running a request */
+	if (engine->cur_req)
+		goto out;
+
+	/* If another context is idling then defer */
+	if (engine->idling) {
+		queue_kthread_work(&engine->kworker, &engine->pump_requests);
+		goto out;
+	}
+
+	/* Check if the engine queue is idle */
+	if (!crypto_queue_len(&engine->queue) || !engine->running) {
+		if (!engine->busy)
+			goto out;
+
+		/* Only do teardown in the thread */
+		if (!in_kthread) {
+			queue_kthread_work(&engine->kworker,
+					   &engine->pump_requests);
+			goto out;
+		}
+
+		engine->busy = false;
+		engine->idling = true;
+		spin_unlock_irqrestore(&engine->queue_lock, flags);
+
+		if (engine->unprepare_crypt_hardware &&
+		    engine->unprepare_crypt_hardware(engine))
+			pr_err("failed to unprepare crypt hardware\n");
+
+		spin_lock_irqsave(&engine->queue_lock, flags);
+		engine->idling = false;
+		goto out;
+	}
+
+	/* Get the fist request from the engine queue to handle */
+	backlog = crypto_get_backlog(&engine->queue);
+	async_req = crypto_dequeue_request(&engine->queue);
+	if (!async_req)
+		goto out;
+
+	req = ablkcipher_request_cast(async_req);
+
+	engine->cur_req = req;
+	if (backlog)
+		backlog->complete(backlog, -EINPROGRESS);
+
+	if (engine->busy)
+		was_busy = true;
+	else
+		engine->busy = true;
+
+	spin_unlock_irqrestore(&engine->queue_lock, flags);
+
+	/* Until here we get the request need to be encrypted successfully */
+	if (!was_busy && engine->prepare_crypt_hardware) {
+		ret = engine->prepare_crypt_hardware(engine);
+		if (ret) {
+			pr_err("failed to prepare crypt hardware\n");
+			goto req_err;
+		}
+	}
+
+	if (engine->prepare_request) {
+		ret = engine->prepare_request(engine, engine->cur_req);
+		if (ret) {
+			pr_err("failed to prepare request: %d\n", ret);
+			goto req_err;
+		}
+		engine->cur_req_prepared = true;
+	}
+
+	ret = engine->crypt_one_request(engine, engine->cur_req);
+	if (ret) {
+		pr_err("failed to crypt one request from queue\n");
+		goto req_err;
+	}
+	return;
+
+req_err:
+	crypto_finalize_request(engine, engine->cur_req, ret);
+	return;
+
+out:
+	spin_unlock_irqrestore(&engine->queue_lock, flags);
+}
+
+static void crypto_pump_work(struct kthread_work *work)
+{
+	struct crypto_engine *engine =
+		container_of(work, struct crypto_engine, pump_requests);
+
+	crypto_pump_requests(engine, true);
+}
+
+/**
+ * crypto_transfer_request - transfer the new request into the engine queue
+ * @engine: the hardware engine
+ * @req: the request need to be listed into the engine queue
+ */
+int crypto_transfer_request(struct crypto_engine *engine,
+			    struct ablkcipher_request *req, bool need_pump)
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
+	ret = ablkcipher_enqueue_request(&engine->queue, req);
+
+	if (!engine->busy && need_pump)
+		queue_kthread_work(&engine->kworker, &engine->pump_requests);
+
+	spin_unlock_irqrestore(&engine->queue_lock, flags);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(crypto_transfer_request);
+
+/**
+ * crypto_transfer_request_to_engine - transfer one request to list into the
+ * engine queue
+ * @engine: the hardware engine
+ * @req: the request need to be listed into the engine queue
+ */
+int crypto_transfer_request_to_engine(struct crypto_engine *engine,
+				      struct ablkcipher_request *req)
+{
+	return crypto_transfer_request(engine, req, true);
+}
+EXPORT_SYMBOL_GPL(crypto_transfer_request_to_engine);
+
+/**
+ * crypto_finalize_request - finalize one request if the request is done
+ * @engine: the hardware engine
+ * @req: the request need to be finalized
+ * @err: error number
+ */
+void crypto_finalize_request(struct crypto_engine *engine,
+			     struct ablkcipher_request *req, int err)
+{
+	unsigned long flags;
+	bool finalize_cur_req = false;
+	int ret;
+
+	spin_lock_irqsave(&engine->queue_lock, flags);
+	if (engine->cur_req == req)
+		finalize_cur_req = true;
+	spin_unlock_irqrestore(&engine->queue_lock, flags);
+
+	if (finalize_cur_req) {
+		if (engine->cur_req_prepared && engine->unprepare_request) {
+			ret = engine->unprepare_request(engine, req);
+			if (ret)
+				pr_err("failed to unprepare request\n");
+		}
+
+		spin_lock_irqsave(&engine->queue_lock, flags);
+		engine->cur_req = NULL;
+		engine->cur_req_prepared = false;
+		spin_unlock_irqrestore(&engine->queue_lock, flags);
+	}
+
+	req->base.complete(&req->base, err);
+
+	queue_kthread_work(&engine->kworker, &engine->pump_requests);
+}
+EXPORT_SYMBOL_GPL(crypto_finalize_request);
+
+/**
+ * crypto_engine_start - start the hardware engine
+ * @engine: the hardware engine need to be started
+ *
+ * Return 0 on success, else on fail.
+ */
+int crypto_engine_start(struct crypto_engine *engine)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&engine->queue_lock, flags);
+
+	if (engine->running || engine->busy) {
+		spin_unlock_irqrestore(&engine->queue_lock, flags);
+		return -EBUSY;
+	}
+
+	engine->running = true;
+	spin_unlock_irqrestore(&engine->queue_lock, flags);
+
+	queue_kthread_work(&engine->kworker, &engine->pump_requests);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(crypto_engine_start);
+
+/**
+ * crypto_engine_stop - stop the hardware engine
+ * @engine: the hardware engine need to be stopped
+ *
+ * Return 0 on success, else on fail.
+ */
+int crypto_engine_stop(struct crypto_engine *engine)
+{
+	unsigned long flags;
+	unsigned limit = 500;
+	int ret = 0;
+
+	spin_lock_irqsave(&engine->queue_lock, flags);
+
+	/*
+	 * If the engine queue is not empty or the engine is on busy state,
+	 * we need to wait for a while to pump the requests of engine queue.
+	 */
+	while ((crypto_queue_len(&engine->queue) || engine->busy) && limit--) {
+		spin_unlock_irqrestore(&engine->queue_lock, flags);
+		msleep(20);
+		spin_lock_irqsave(&engine->queue_lock, flags);
+	}
+
+	if (crypto_queue_len(&engine->queue) || engine->busy)
+		ret = -EBUSY;
+	else
+		engine->running = false;
+
+	spin_unlock_irqrestore(&engine->queue_lock, flags);
+
+	if (ret)
+		pr_warn("could not stop engine\n");
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(crypto_engine_stop);
+
+/**
+ * crypto_engine_alloc_init - allocate crypto hardware engine structure and
+ * initialize it.
+ * @dev: the device attached with one hardware engine
+ * @rt: whether this queue is set to run as a realtime task
+ *
+ * This must be called from context that can sleep.
+ * Return: the crypto engine structure on success, else NULL.
+ */
+struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool rt)
+{
+	struct sched_param param = { .sched_priority = MAX_RT_PRIO - 1 };
+	struct crypto_engine *engine;
+
+	if (!dev)
+		return NULL;
+
+	engine = devm_kzalloc(dev, sizeof(*engine), GFP_KERNEL);
+	if (!engine)
+		return NULL;
+
+	engine->rt = rt;
+	engine->running = false;
+	engine->busy = false;
+	engine->idling = false;
+	engine->cur_req_prepared = false;
+	engine->priv_data = dev;
+	snprintf(engine->name, sizeof(engine->name),
+		 "%s-engine", dev_name(dev));
+
+	crypto_init_queue(&engine->queue, CRYPTO_ENGINE_MAX_QLEN);
+	spin_lock_init(&engine->queue_lock);
+
+	init_kthread_worker(&engine->kworker);
+	engine->kworker_task = kthread_run(kthread_worker_fn,
+					   &engine->kworker, "%s",
+					   engine->name);
+	if (IS_ERR(engine->kworker_task)) {
+		dev_err(dev, "failed to create crypto request pump task\n");
+		return NULL;
+	}
+	init_kthread_work(&engine->pump_requests, crypto_pump_work);
+
+	if (engine->rt) {
+		dev_info(dev, "will run requests pump with realtime priority\n");
+		sched_setscheduler(engine->kworker_task, SCHED_FIFO, &param);
+	}
+
+	return engine;
+}
+EXPORT_SYMBOL_GPL(crypto_engine_alloc_init);
+
+/**
+ * crypto_engine_exit - free the resources of hardware engine when exit
+ * @engine: the hardware engine need to be freed
+ *
+ * Return 0 for success.
+ */
+int crypto_engine_exit(struct crypto_engine *engine)
+{
+	int ret;
+
+	ret = crypto_engine_stop(engine);
+	if (ret)
+		return ret;
+
+	flush_kthread_worker(&engine->kworker);
+	kthread_stop(engine->kworker_task);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(crypto_engine_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Crypto hardware engine framework");
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 4f861c4..b09d43f 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -15,6 +15,7 @@
 #include <linux/crypto.h>
 #include <linux/list.h>
 #include <linux/kernel.h>
+#include <linux/kthread.h>
 #include <linux/skbuff.h>
 
 struct crypto_aead;
@@ -128,6 +129,75 @@ struct ablkcipher_walk {
 	unsigned int		blocksize;
 };
 
+#define ENGINE_NAME_LEN	30
+/*
+ * struct crypto_engine - crypto hardware engine
+ * @name: the engine name
+ * @idling: the engine is entering idle state
+ * @busy: request pump is busy
+ * @running: the engine is on working
+ * @cur_req_prepared: current request is prepared
+ * @list: link with the global crypto engine list
+ * @queue_lock: spinlock to syncronise access to request queue
+ * @queue: the crypto queue of the engine
+ * @rt: whether this queue is set to run as a realtime task
+ * @prepare_crypt_hardware: a request will soon arrive from the queue
+ * so the subsystem requests the driver to prepare the hardware
+ * by issuing this call
+ * @unprepare_crypt_hardware: there are currently no more requests on the
+ * queue so the subsystem notifies the driver that it may relax the
+ * hardware by issuing this call
+ * @prepare_request: do some prepare if need before handle the current request
+ * @unprepare_request: undo any work done by prepare_message()
+ * @crypt_one_request: do encryption for current request
+ * @kworker: thread struct for request pump
+ * @kworker_task: pointer to task for request pump kworker thread
+ * @pump_requests: work struct for scheduling work to the request pump
+ * @priv_data: the engine private data
+ * @cur_req: the current request which is on processing
+ */
+struct crypto_engine {
+	char			name[ENGINE_NAME_LEN];
+	bool			idling;
+	bool			busy;
+	bool			running;
+	bool			cur_req_prepared;
+
+	struct list_head	list;
+	spinlock_t		queue_lock;
+	struct crypto_queue	queue;
+
+	bool			rt;
+
+	int (*prepare_crypt_hardware)(struct crypto_engine *engine);
+	int (*unprepare_crypt_hardware)(struct crypto_engine *engine);
+
+	int (*prepare_request)(struct crypto_engine *engine,
+			       struct ablkcipher_request *req);
+	int (*unprepare_request)(struct crypto_engine *engine,
+				 struct ablkcipher_request *req);
+	int (*crypt_one_request)(struct crypto_engine *engine,
+				 struct ablkcipher_request *req);
+
+	struct kthread_worker           kworker;
+	struct task_struct              *kworker_task;
+	struct kthread_work             pump_requests;
+
+	void				*priv_data;
+	struct ablkcipher_request	*cur_req;
+};
+
+int crypto_transfer_request(struct crypto_engine *engine,
+			    struct ablkcipher_request *req, bool need_pump);
+int crypto_transfer_request_to_engine(struct crypto_engine *engine,
+				      struct ablkcipher_request *req);
+void crypto_finalize_request(struct crypto_engine *engine,
+			     struct ablkcipher_request *req, int err);
+int crypto_engine_start(struct crypto_engine *engine);
+int crypto_engine_stop(struct crypto_engine *engine);
+struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool rt);
+int crypto_engine_exit(struct crypto_engine *engine);
+
 extern const struct crypto_type crypto_ablkcipher_type;
 extern const struct crypto_type crypto_blkcipher_type;
 
-- 
1.7.9.5
