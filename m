From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/5] crypto: cryptd - Add helpers to check whether a tfm is queued
Date: Tue, 21 Jun 2016 16:55:13 +0800
Message-ID: <E1bFHSj-0005Uu-Dl@gondolin.me.apana.org.au>
References: <20160621085321.GA21044@gondor.apana.org.au>
To: Raj Ammanur <rammanur@arista.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:42099 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbcFUIzW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 21 Jun 2016 04:55:22 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds helpers to check whether a given tfm is currently
queued.  This is meant to be used by ablk_helper and similar
entities to ensure that no reordering is introduced because of
requests queued in cryptd with respect to requests being processed
in softirq context.

The per-cpu queue length limit is also increased to 1000 in line
with network limits.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/cryptd.c         |  132 +++++++++++++++++++++++++++++++++++++++++-------
 include/crypto/cryptd.h |    5 +
 2 files changed, 118 insertions(+), 19 deletions(-)

diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index 7921251..cf8037a 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -22,6 +22,7 @@
 #include <crypto/internal/aead.h>
 #include <crypto/cryptd.h>
 #include <crypto/crypto_wq.h>
+#include <linux/atomic.h>
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -31,7 +32,7 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 
-#define CRYPTD_MAX_CPU_QLEN 100
+#define CRYPTD_MAX_CPU_QLEN 1000
 
 struct cryptd_cpu_queue {
 	struct crypto_queue queue;
@@ -58,6 +59,7 @@ struct aead_instance_ctx {
 };
 
 struct cryptd_blkcipher_ctx {
+	atomic_t refcnt;
 	struct crypto_blkcipher *child;
 };
 
@@ -66,6 +68,7 @@ struct cryptd_blkcipher_request_ctx {
 };
 
 struct cryptd_hash_ctx {
+	atomic_t refcnt;
 	struct crypto_shash *child;
 };
 
@@ -75,6 +78,7 @@ struct cryptd_hash_request_ctx {
 };
 
 struct cryptd_aead_ctx {
+	atomic_t refcnt;
 	struct crypto_aead *child;
 };
 
@@ -118,11 +122,29 @@ static int cryptd_enqueue_request(struct cryptd_queue *queue,
 {
 	int cpu, err;
 	struct cryptd_cpu_queue *cpu_queue;
+	struct crypto_tfm *tfm;
+	atomic_t *refcnt;
+	bool may_backlog;
 
 	cpu = get_cpu();
 	cpu_queue = this_cpu_ptr(queue->cpu_queue);
 	err = crypto_enqueue_request(&cpu_queue->queue, request);
+
+	refcnt = crypto_tfm_ctx(request->tfm);
+	may_backlog = request->flags & CRYPTO_TFM_REQ_MAY_BACKLOG;
+
+	if (err == -EBUSY && !may_backlog)
+		goto out_put_cpu;
+
 	queue_work_on(cpu, kcrypto_wq, &cpu_queue->work);
+
+	if (!atomic_read(refcnt))
+		goto out_put_cpu;
+
+	tfm = request->tfm;
+	atomic_inc(refcnt);
+
+out_put_cpu:
 	put_cpu();
 
 	return err;
@@ -206,7 +228,10 @@ static void cryptd_blkcipher_crypt(struct ablkcipher_request *req,
 						unsigned int len))
 {
 	struct cryptd_blkcipher_request_ctx *rctx;
+	struct cryptd_blkcipher_ctx *ctx;
+	struct crypto_ablkcipher *tfm;
 	struct blkcipher_desc desc;
+	int refcnt;
 
 	rctx = ablkcipher_request_ctx(req);
 
@@ -222,9 +247,16 @@ static void cryptd_blkcipher_crypt(struct ablkcipher_request *req,
 	req->base.complete = rctx->complete;
 
 out:
+	tfm = crypto_ablkcipher_reqtfm(req);
+	ctx = crypto_ablkcipher_ctx(tfm);
+	refcnt = atomic_read(&ctx->refcnt);
+
 	local_bh_disable();
 	rctx->complete(&req->base, err);
 	local_bh_enable();
+
+	if (err != -EINPROGRESS && refcnt && atomic_dec_and_test(&ctx->refcnt))
+		crypto_free_ablkcipher(tfm);
 }
 
 static void cryptd_blkcipher_encrypt(struct crypto_async_request *req, int err)
@@ -456,6 +488,21 @@ static int cryptd_hash_enqueue(struct ahash_request *req,
 	return cryptd_enqueue_request(queue, &req->base);
 }
 
+static void cryptd_hash_complete(struct ahash_request *req, int err)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct cryptd_hash_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct cryptd_hash_request_ctx *rctx = ahash_request_ctx(req);
+	int refcnt = atomic_read(&ctx->refcnt);
+
+	local_bh_disable();
+	rctx->complete(&req->base, err);
+	local_bh_enable();
+
+	if (err != -EINPROGRESS && refcnt && atomic_dec_and_test(&ctx->refcnt))
+		crypto_free_ahash(tfm);
+}
+
 static void cryptd_hash_init(struct crypto_async_request *req_async, int err)
 {
 	struct cryptd_hash_ctx *ctx = crypto_tfm_ctx(req_async->tfm);
@@ -475,9 +522,7 @@ static void cryptd_hash_init(struct crypto_async_request *req_async, int err)
 	req->base.complete = rctx->complete;
 
 out:
-	local_bh_disable();
-	rctx->complete(&req->base, err);
-	local_bh_enable();
+	cryptd_hash_complete(req, err);
 }
 
 static int cryptd_hash_init_enqueue(struct ahash_request *req)
@@ -500,9 +545,7 @@ static void cryptd_hash_update(struct crypto_async_request *req_async, int err)
 	req->base.complete = rctx->complete;
 
 out:
-	local_bh_disable();
-	rctx->complete(&req->base, err);
-	local_bh_enable();
+	cryptd_hash_complete(req, err);
 }
 
 static int cryptd_hash_update_enqueue(struct ahash_request *req)
@@ -523,9 +566,7 @@ static void cryptd_hash_final(struct crypto_async_request *req_async, int err)
 	req->base.complete = rctx->complete;
 
 out:
-	local_bh_disable();
-	rctx->complete(&req->base, err);
-	local_bh_enable();
+	cryptd_hash_complete(req, err);
 }
 
 static int cryptd_hash_final_enqueue(struct ahash_request *req)
@@ -546,9 +587,7 @@ static void cryptd_hash_finup(struct crypto_async_request *req_async, int err)
 	req->base.complete = rctx->complete;
 
 out:
-	local_bh_disable();
-	rctx->complete(&req->base, err);
-	local_bh_enable();
+	cryptd_hash_complete(req, err);
 }
 
 static int cryptd_hash_finup_enqueue(struct ahash_request *req)
@@ -575,9 +614,7 @@ static void cryptd_hash_digest(struct crypto_async_request *req_async, int err)
 	req->base.complete = rctx->complete;
 
 out:
-	local_bh_disable();
-	rctx->complete(&req->base, err);
-	local_bh_enable();
+	cryptd_hash_complete(req, err);
 }
 
 static int cryptd_hash_digest_enqueue(struct ahash_request *req)
@@ -688,7 +725,10 @@ static void cryptd_aead_crypt(struct aead_request *req,
 			int (*crypt)(struct aead_request *req))
 {
 	struct cryptd_aead_request_ctx *rctx;
+	struct cryptd_aead_ctx *ctx;
 	crypto_completion_t compl;
+	struct crypto_aead *tfm;
+	int refcnt;
 
 	rctx = aead_request_ctx(req);
 	compl = rctx->complete;
@@ -697,10 +737,18 @@ static void cryptd_aead_crypt(struct aead_request *req,
 		goto out;
 	aead_request_set_tfm(req, child);
 	err = crypt( req );
+
 out:
+	tfm = crypto_aead_reqtfm(req);
+	ctx = crypto_aead_ctx(tfm);
+	refcnt = atomic_read(&ctx->refcnt);
+
 	local_bh_disable();
 	compl(&req->base, err);
 	local_bh_enable();
+
+	if (err != -EINPROGRESS && refcnt && atomic_dec_and_test(&ctx->refcnt))
+		crypto_free_aead(tfm);
 }
 
 static void cryptd_aead_encrypt(struct crypto_async_request *areq, int err)
@@ -883,6 +931,7 @@ struct cryptd_ablkcipher *cryptd_alloc_ablkcipher(const char *alg_name,
 						  u32 type, u32 mask)
 {
 	char cryptd_alg_name[CRYPTO_MAX_ALG_NAME];
+	struct cryptd_blkcipher_ctx *ctx;
 	struct crypto_tfm *tfm;
 
 	if (snprintf(cryptd_alg_name, CRYPTO_MAX_ALG_NAME,
@@ -899,6 +948,9 @@ struct cryptd_ablkcipher *cryptd_alloc_ablkcipher(const char *alg_name,
 		return ERR_PTR(-EINVAL);
 	}
 
+	ctx = crypto_tfm_ctx(tfm);
+	atomic_set(&ctx->refcnt, 1);
+
 	return __cryptd_ablkcipher_cast(__crypto_ablkcipher_cast(tfm));
 }
 EXPORT_SYMBOL_GPL(cryptd_alloc_ablkcipher);
@@ -910,9 +962,20 @@ struct crypto_blkcipher *cryptd_ablkcipher_child(struct cryptd_ablkcipher *tfm)
 }
 EXPORT_SYMBOL_GPL(cryptd_ablkcipher_child);
 
+bool cryptd_ablkcipher_queued(struct cryptd_ablkcipher *tfm)
+{
+	struct cryptd_blkcipher_ctx *ctx = crypto_ablkcipher_ctx(&tfm->base);
+
+	return atomic_read(&ctx->refcnt) - 1;
+}
+EXPORT_SYMBOL_GPL(cryptd_ablkcipher_queued);
+
 void cryptd_free_ablkcipher(struct cryptd_ablkcipher *tfm)
 {
-	crypto_free_ablkcipher(&tfm->base);
+	struct cryptd_blkcipher_ctx *ctx = crypto_ablkcipher_ctx(&tfm->base);
+
+	if (atomic_dec_and_test(&ctx->refcnt))
+		crypto_free_ablkcipher(&tfm->base);
 }
 EXPORT_SYMBOL_GPL(cryptd_free_ablkcipher);
 
@@ -920,6 +983,7 @@ struct cryptd_ahash *cryptd_alloc_ahash(const char *alg_name,
 					u32 type, u32 mask)
 {
 	char cryptd_alg_name[CRYPTO_MAX_ALG_NAME];
+	struct cryptd_hash_ctx *ctx;
 	struct crypto_ahash *tfm;
 
 	if (snprintf(cryptd_alg_name, CRYPTO_MAX_ALG_NAME,
@@ -933,6 +997,9 @@ struct cryptd_ahash *cryptd_alloc_ahash(const char *alg_name,
 		return ERR_PTR(-EINVAL);
 	}
 
+	ctx = crypto_ahash_ctx(tfm);
+	atomic_set(&ctx->refcnt, 1);
+
 	return __cryptd_ahash_cast(tfm);
 }
 EXPORT_SYMBOL_GPL(cryptd_alloc_ahash);
@@ -952,9 +1019,20 @@ struct shash_desc *cryptd_shash_desc(struct ahash_request *req)
 }
 EXPORT_SYMBOL_GPL(cryptd_shash_desc);
 
+bool cryptd_ahash_queued(struct cryptd_ahash *tfm)
+{
+	struct cryptd_hash_ctx *ctx = crypto_ahash_ctx(&tfm->base);
+
+	return atomic_read(&ctx->refcnt) - 1;
+}
+EXPORT_SYMBOL_GPL(cryptd_ahash_queued);
+
 void cryptd_free_ahash(struct cryptd_ahash *tfm)
 {
-	crypto_free_ahash(&tfm->base);
+	struct cryptd_hash_ctx *ctx = crypto_ahash_ctx(&tfm->base);
+
+	if (atomic_dec_and_test(&ctx->refcnt))
+		crypto_free_ahash(&tfm->base);
 }
 EXPORT_SYMBOL_GPL(cryptd_free_ahash);
 
@@ -962,6 +1040,7 @@ struct cryptd_aead *cryptd_alloc_aead(const char *alg_name,
 						  u32 type, u32 mask)
 {
 	char cryptd_alg_name[CRYPTO_MAX_ALG_NAME];
+	struct cryptd_aead_ctx *ctx;
 	struct crypto_aead *tfm;
 
 	if (snprintf(cryptd_alg_name, CRYPTO_MAX_ALG_NAME,
@@ -974,6 +1053,10 @@ struct cryptd_aead *cryptd_alloc_aead(const char *alg_name,
 		crypto_free_aead(tfm);
 		return ERR_PTR(-EINVAL);
 	}
+
+	ctx = crypto_aead_ctx(tfm);
+	atomic_set(&ctx->refcnt, 1);
+
 	return __cryptd_aead_cast(tfm);
 }
 EXPORT_SYMBOL_GPL(cryptd_alloc_aead);
@@ -986,9 +1069,20 @@ struct crypto_aead *cryptd_aead_child(struct cryptd_aead *tfm)
 }
 EXPORT_SYMBOL_GPL(cryptd_aead_child);
 
+bool cryptd_aead_queued(struct cryptd_aead *tfm)
+{
+	struct cryptd_aead_ctx *ctx = crypto_aead_ctx(&tfm->base);
+
+	return atomic_read(&ctx->refcnt) - 1;
+}
+EXPORT_SYMBOL_GPL(cryptd_aead_queued);
+
 void cryptd_free_aead(struct cryptd_aead *tfm)
 {
-	crypto_free_aead(&tfm->base);
+	struct cryptd_aead_ctx *ctx = crypto_aead_ctx(&tfm->base);
+
+	if (atomic_dec_and_test(&ctx->refcnt))
+		crypto_free_aead(&tfm->base);
 }
 EXPORT_SYMBOL_GPL(cryptd_free_aead);
 
diff --git a/include/crypto/cryptd.h b/include/crypto/cryptd.h
index 1547f54..bc792d5 100644
--- a/include/crypto/cryptd.h
+++ b/include/crypto/cryptd.h
@@ -31,6 +31,7 @@ static inline struct cryptd_ablkcipher *__cryptd_ablkcipher_cast(
 struct cryptd_ablkcipher *cryptd_alloc_ablkcipher(const char *alg_name,
 						  u32 type, u32 mask);
 struct crypto_blkcipher *cryptd_ablkcipher_child(struct cryptd_ablkcipher *tfm);
+bool cryptd_ablkcipher_queued(struct cryptd_ablkcipher *tfm);
 void cryptd_free_ablkcipher(struct cryptd_ablkcipher *tfm);
 
 struct cryptd_ahash {
@@ -48,6 +49,8 @@ struct cryptd_ahash *cryptd_alloc_ahash(const char *alg_name,
 					u32 type, u32 mask);
 struct crypto_shash *cryptd_ahash_child(struct cryptd_ahash *tfm);
 struct shash_desc *cryptd_shash_desc(struct ahash_request *req);
+/* Must be called without moving CPUs. */
+bool cryptd_ahash_queued(struct cryptd_ahash *tfm);
 void cryptd_free_ahash(struct cryptd_ahash *tfm);
 
 struct cryptd_aead {
@@ -64,6 +67,8 @@ struct cryptd_aead *cryptd_alloc_aead(const char *alg_name,
 					  u32 type, u32 mask);
 
 struct crypto_aead *cryptd_aead_child(struct cryptd_aead *tfm);
+/* Must be called without moving CPUs. */
+bool cryptd_aead_queued(struct cryptd_aead *tfm);
 
 void cryptd_free_aead(struct cryptd_aead *tfm);
 
