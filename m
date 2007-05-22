From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: [CRYPTO] [1/1] skeleton for async crypto drivers
Date: Tue, 22 May 2007 17:16:57 +0200
Message-ID: <20070522151657.GA32493@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:32886 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934595AbXEVPRC (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 22 May 2007 11:17:02 -0400
Received: id: bigeasy by Chamillionaire.breakpoint.cc with local
	(easymta 1.00 BETA 1)
	id 1HqW6b-0000Iv-7t
	for linux-crypto@vger.kernel.org; Tue, 22 May 2007 17:16:57 +0200
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This skeleton should be a good start for everyone who is still looking for
the documentation :)
The code is based mainly on Herbert's crypto/cryptd.c. The obvious
difference is, that it does not wrap around the complete argument.
As mentioned in the code, process_requests_thread() could be optimized to
call blkcipher_crypt() directly with the parameter (and remove the
function pointer).

Sebastian
Index: linux/crypto/async_drv_skeleton.c
===================================================================
--- /dev/null
+++ linux/crypto/async_drv_skeleton.c
@@ -0,0 +1,402 @@
+/*
+ * Template for async crypto HW
+ *
+ * Code is based mainly on the crypto/cryptd.c code
+ */
+
+#include <crypto/algapi.h>
+#include <linux/module.h>
+#include <linux/crypto.h>
+#include <linux/mutex.h>
+#include <linux/err.h>
+#include <linux/list.h>
+#include <asm/byteorder.h>
+#include <asm/system.h>
+#include <linux/delay.h>
+#include <linux/spinlock.h>
+#include <linux/kthread.h>
+
+
+#define CRYPTO_MAX_QLEN 101
+
+/* not to use the HW twice at the same time */
+struct hw_work_ctx {
+	struct hw_context *hw_ctx;
+	struct mutex mutex;
+};
+
+static struct hw_work_ctx work_ctx;
+
+struct algo_ctx_t {
+	char key[42];
+	int keylen;
+};
+
+#define ALGO_MIN_KEY_SIZE	16
+#define ALGO_MAX_KEY_SIZE	32
+#define ALGO_BLOCKSIZE		16
+
+/* hardware functions */
+#define HW_DECRYPT_ECB 0xbeef
+#define HW_ENCRYPT_ECB 0xbabe
+
+static int hw_set_key(struct hw_context *hw_ctx, const char *inkey, int keylen,
+		char *outkey)
+{
+	return 1;
+}
+
+static int hw_crypt_process(int operation_type, const char *key, const char *inbuf,
+		char *outbuf, unsigned long size)
+{
+	return 2;
+}
+static void *get_hw_ctx(void)
+{
+	return NULL;
+}
+
+static void free_hw_ctx(struct hw_context *hw_ctx)
+{
+	return;
+}
+
+/* algo -> HW */
+static int _algo_set_key(struct algo_ctx_t *ctx, const u8 *in_key,
+		       unsigned int key_len)
+{
+	int ret;
+
+	switch (key_len) {
+	case 16:
+	case 24:
+	case 32:
+		break;
+
+	default:
+		 return -EINVAL;
+	}
+
+	mutex_lock(&work_ctx.mutex);
+
+	ctx->keylen = key_len / 4;
+	ret = hw_set_key(work_ctx.hw_ctx, in_key, key_len, ctx->key);
+	if (ret < 0) {
+		printk("%s() failed\n", __FUNCTION__);
+	}
+
+	mutex_unlock(&work_ctx.mutex);
+	return ret < 0 ? ret : 0;
+}
+
+/*
+ * this is from s390's AES
+ */
+static int mode_algo_crypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		struct scatterlist *src, unsigned int nbytes, int op_type)
+{
+	struct algo_ctx_t *algo_ctx = crypto_blkcipher_ctx(desc->tfm);
+	struct blkcipher_walk walk;
+	u8 *out, *in;
+	int ret;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	ret = blkcipher_walk_virt(desc, &walk);
+
+	while ((nbytes = walk.nbytes)) {
+		/* only use complete blocks */
+		unsigned int n = nbytes & ~(15);
+
+		out = walk.dst.virt.addr;
+		in = walk.src.virt.addr;
+
+		printk("%s(): processing data from %p to %p (%d bytes)\n", __FUNCTION__,
+				in, out, n);
+
+		mutex_lock(&work_ctx.mutex);
+
+		ret = hw_crypt_process(op_type, algo_ctx->key, in, out, n);
+		mutex_unlock(&work_ctx.mutex);
+
+		if (ret < 0) {
+			printk("hw_crypt error: %d\n", ret);
+		}
+
+		nbytes &= 15;
+		ret = blkcipher_walk_done(desc, &walk, nbytes);
+	}
+	return ret;
+}
+
+/* per ablk cipher data */
+struct async_algo_state {
+	spinlock_t queue_spinlock;
+	struct mutex queue_mutex;
+	struct crypto_queue requests_queue;
+	struct task_struct *requests_thread;
+};
+
+/* per request struct */
+struct async_d_request {
+	crypto_completion_t crypto_complete;
+};
+
+static struct async_algo_state algo_state;
+
+/* set key is NOT async */
+static int algo_set_key_async(struct crypto_ablkcipher *parent,
+		const u8 *key, unsigned int keylen)
+{
+	struct algo_ctx_t *ctx = crypto_ablkcipher_ctx(parent);
+
+	return _algo_set_key(ctx, key, keylen);
+}
+
+static void blkcipher_crypt(struct ablkcipher_request *req,
+		struct algo_ctx_t *ctx,
+		int err,
+		int op_type)
+{
+	struct blkcipher_desc desc;
+
+	printk("%s()\n", __FUNCTION__);
+	if (unlikely(err == -EINPROGRESS)) {
+		printk("err = -EINPROGRESS in %s\n", __FUNCTION__);
+		req->base.complete(&req->base, err);
+		return;
+	}
+
+	/*
+	 * desc is required by crypto's scatter code.
+	 * info is the IV.
+	 */
+	desc.tfm = crypto_blkcipher_cast(req->base.tfm);
+	desc.info = req->info;
+	desc.flags = CRYPTO_TFM_REQ_MAY_SLEEP;
+
+	err = mode_algo_crypt(&desc, req->dst, req->src, req->nbytes, op_type);
+
+	local_bh_disable();
+	/*
+	 * call the crypto user and inform him about his request
+	 */
+	req->base.complete(&req->base, err);
+	local_bh_enable();
+}
+
+/*
+ * the next two are called from the working thread
+ * ([a_d_ctx|a_d_backreq]->crypto_complete). This could be optimized by calling
+ * blkcipher_crypt() directly with the special parameter
+ */
+static void algo_request_encrypt (struct crypto_async_request *req, int err)
+{
+	struct algo_ctx_t *ctx = crypto_tfm_ctx(req->tfm);
+
+	blkcipher_crypt(ablkcipher_request_cast(req), ctx, err,	HW_ENCRYPT_ECB);
+}
+
+static void algo_request_decrypt (struct crypto_async_request *req, int err)
+{
+	struct algo_ctx_t *ctx = crypto_tfm_ctx(req->tfm);
+
+	blkcipher_crypt(ablkcipher_request_cast(req), ctx, err, HW_DECRYPT_ECB);
+}
+
+/*
+ * queue one request and wakeup work thread
+ */
+static int enqueue_request(struct ablkcipher_request *req,
+		crypto_completion_t complete)
+{
+	struct async_d_request *asy_d_ctx = ablkcipher_request_ctx(req);
+	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(req);
+	int ret;
+
+	asy_d_ctx->crypto_complete = complete;
+
+	spin_lock_bh(&algo_state.queue_spinlock);
+	ret = ablkcipher_enqueue_request(crypto_ablkcipher_alg(tfm), req);
+	spin_unlock_bh(&algo_state.queue_spinlock);
+
+	wake_up_process(algo_state.requests_thread);
+	return ret;
+}
+
+/*
+ * called from crypto user. We queue the crypto function + request.
+ * Crypto request is stored in our per request struct.
+ */
+static int algo_encrypt_ecb_async(struct ablkcipher_request *req)
+{
+
+	return enqueue_request(req, algo_request_encrypt);
+}
+
+static int algo_decrypt_ecb_async(struct ablkcipher_request *req)
+{
+
+	return enqueue_request(req, algo_request_decrypt);
+}
+
+static int async_d_init(struct crypto_tfm *tfm)
+{
+	/* important to save request specific data */
+	printk("currently in %s()\n", __FUNCTION__);
+	tfm->crt_ablkcipher.reqsize = sizeof(struct async_d_request);
+	return 0;
+}
+
+static void async_d_exit(struct crypto_tfm *tfm)
+{
+	printk("currently in %s()\n", __FUNCTION__);
+}
+
+static void async_d_destory(struct crypto_alg *alg)
+{
+	printk("currently in %s()\n", __FUNCTION__);
+}
+
+static struct crypto_alg algo_ecb_alg_async = {
+	.cra_name		= "ecb(algo)",
+	.cra_driver_name	= "ecb-algohw-async",
+	.cra_priority		= 123,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		= ALGO_BLOCKSIZE,
+	.cra_alignmask		= 15,
+	.cra_ctxsize		= sizeof(struct algo_ctx_t),
+	.cra_type		= &crypto_ablkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(algo_ecb_alg_async.cra_list),
+	.cra_init		= async_d_init,
+	.cra_exit		= async_d_exit,
+	.cra_destroy		= async_d_destory,
+	.cra_u	= {
+		.ablkcipher = {
+			.min_keysize	= ALGO_MIN_KEY_SIZE,
+			.max_keysize	= ALGO_MAX_KEY_SIZE,
+			.ivsize		= 0,
+			.setkey		= algo_set_key_async,
+			.encrypt	= algo_encrypt_ecb_async,
+			.decrypt	= algo_decrypt_ecb_async,
+			.queue		= &algo_state.requests_queue,
+		}
+	}
+};
+
+static int process_requests_thread(void *data) {
+
+	struct async_algo_state *state = data;
+	int stop;
+	struct crypto_async_request *req, *backlog;
+	struct ablkcipher_request *ablk_req;
+	struct async_d_request *a_d_ctx, *a_d_backreq;
+
+	printk("thread active\n");
+	do {
+		printk("%s(): Starting request\n", __FUNCTION__);
+		mutex_lock(&state->queue_mutex);
+		__set_current_state(TASK_INTERRUPTIBLE);
+
+		spin_lock_bh(&state->queue_spinlock);
+		backlog = crypto_get_backlog(&state->requests_queue);
+		req = crypto_dequeue_request(&state->requests_queue);
+		spin_unlock_bh(&state->queue_spinlock);
+
+		printk("backlog: %p, req: %p\n", backlog, req);
+
+		stop = kthread_should_stop();
+
+		if (stop || req) {
+
+			__set_current_state(TASK_RUNNING);
+			if (req) {
+				if (backlog) {
+					ablk_req = ablkcipher_request_cast(backlog);
+					a_d_backreq = ablkcipher_request_ctx(ablk_req);
+					a_d_backreq->crypto_complete(backlog, -EINPROGRESS);
+				}
+
+				ablk_req = ablkcipher_request_cast(req);
+				a_d_ctx = ablkcipher_request_ctx(ablk_req);
+				a_d_ctx->crypto_complete(req, 0);
+			}
+		}
+
+		mutex_unlock(&state->queue_mutex);
+		schedule();
+
+	} while(!stop);
+
+	return 0;
+}
+
+static int async_api_init(void) {
+	int ret;
+
+	crypto_init_queue(&algo_state.requests_queue, CRYPTO_MAX_QLEN);
+	mutex_init(&algo_state.queue_mutex);
+	spin_lock_init(&algo_state.queue_spinlock);
+
+	algo_state.requests_thread = kthread_create(process_requests_thread, &algo_state, "cryptoHW");
+	if (IS_ERR(algo_state.requests_thread)) {
+		printk("kthread_create() failed: %ld\n", PTR_ERR(algo_state.requests_thread));
+		return PTR_ERR(algo_state.requests_thread);
+	}
+
+	ret = crypto_register_alg(&algo_ecb_alg_async);
+	if (ret) {
+		printk("crypto_register_alg() failed: %d\n", ret);
+		kthread_stop(algo_state.requests_thread);
+		return ret;
+	}
+
+	return 0;
+}
+static int async_api_fini(void) {
+
+	/*
+	 * thread should not be busy anymore, nor should receive any
+	 * further requests
+	 */
+	BUG_ON(algo_state.requests_queue.qlen);
+	crypto_unregister_alg(&algo_ecb_alg_async);
+	kthread_stop(algo_state.requests_thread);
+	return 0;
+}
+
+static int __init algo_init(void)
+{
+	unsigned int ret;
+
+	work_ctx.hw_ctx = get_hw_ctx();
+
+	if (IS_ERR(work_ctx.hw_ctx)) {
+		ret = PTR_ERR(work_ctx.hw_ctx);
+		printk("Can't get HW: %d\n", ret);
+		return ret;
+	}
+	mutex_init(&work_ctx.mutex);
+
+	ret = async_api_init();
+	if (ret) {
+		printk("async_api_init() failed\n");
+		goto out_ctx;
+	}
+	return 0;
+out_ctx:
+	free_hw_ctx(work_ctx.hw_ctx);
+	return ret;
+}
+
+static void __exit algo_fini(void)
+{
+	async_api_fini();
+	free_hw_ctx(work_ctx.hw_ctx);
+}
+
+module_init(algo_init);
+module_exit(algo_fini);
+
+MODULE_DESCRIPTION("Skeleton for ASYNC crypto driver");
+MODULE_LICENSE("GPL");
