From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4/8] [CRYPTO] ablkcipher: Remove queue pointer from common alg object
Date: Thu, 30 Aug 2007 16:41:24 +0800
Message-ID: <E1IQfae-0004BV-00@gondolin.me.apana.org.au>
References: <20070830083900.GA15936@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Thomas Graf <tgraf@suug.ch>,
	Herbgert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1410 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756318AbXH3Il1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 Aug 2007 04:41:27 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

[CRYPTO] ablkcipher: Remove queue pointer from common alg object

Since not everyone needs a queue pointer and those who need it can
always get it from the context anyway the queue pointer in the
common alg object is redundant.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/ablkcipher.c     |    4 ----
 crypto/cryptd.c         |    7 +++----
 include/crypto/algapi.h |   14 +++++++-------
 include/linux/crypto.h  |    3 ---
 4 files changed, 10 insertions(+), 18 deletions(-)

diff --git a/crypto/ablkcipher.c b/crypto/ablkcipher.c
index 47438b6..2731acb 100644
--- a/crypto/ablkcipher.c
+++ b/crypto/ablkcipher.c
@@ -94,10 +94,6 @@ static void crypto_ablkcipher_show(struct seq_file *m, struct crypto_alg *alg)
 	seq_printf(m, "min keysize  : %u\n", ablkcipher->min_keysize);
 	seq_printf(m, "max keysize  : %u\n", ablkcipher->max_keysize);
 	seq_printf(m, "ivsize       : %u\n", ablkcipher->ivsize);
-	if (ablkcipher->queue) {
-		seq_printf(m, "qlen         : %u\n", ablkcipher->queue->qlen);
-		seq_printf(m, "max qlen     : %u\n", ablkcipher->queue->max_qlen);
-	}
 }
 
 const struct crypto_type crypto_ablkcipher_type = {
diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index ac6dce2..8bf2da8 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -131,7 +131,7 @@ static int cryptd_blkcipher_enqueue(struct ablkcipher_request *req,
 	req->base.complete = complete;
 
 	spin_lock_bh(&state->lock);
-	err = ablkcipher_enqueue_request(crypto_ablkcipher_alg(tfm), req);
+	err = ablkcipher_enqueue_request(&state->queue, req);
 	spin_unlock_bh(&state->lock);
 
 	wake_up_process(state->task);
@@ -173,7 +173,8 @@ static void cryptd_blkcipher_exit_tfm(struct crypto_tfm *tfm)
 	int active;
 
 	mutex_lock(&state->mutex);
-	active = ablkcipher_tfm_in_queue(__crypto_ablkcipher_cast(tfm));
+	active = ablkcipher_tfm_in_queue(&state->queue,
+					 __crypto_ablkcipher_cast(tfm));
 	mutex_unlock(&state->mutex);
 
 	BUG_ON(active);
@@ -251,8 +252,6 @@ static struct crypto_instance *cryptd_alloc_blkcipher(
 	inst->alg.cra_ablkcipher.encrypt = cryptd_blkcipher_encrypt_enqueue;
 	inst->alg.cra_ablkcipher.decrypt = cryptd_blkcipher_decrypt_enqueue;
 
-	inst->alg.cra_ablkcipher.queue = &state->queue;
-
 out_put_alg:
 	crypto_mod_put(alg);
 	return inst;
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 290bce0..cd721a7 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -234,16 +234,16 @@ static inline struct crypto_async_request *crypto_get_backlog(
 	       container_of(queue->backlog, struct crypto_async_request, list);
 }
 
-static inline int ablkcipher_enqueue_request(struct ablkcipher_alg *alg,
+static inline int ablkcipher_enqueue_request(struct crypto_queue *queue,
 					     struct ablkcipher_request *request)
 {
-	return crypto_enqueue_request(alg->queue, &request->base);
+	return crypto_enqueue_request(queue, &request->base);
 }
 
 static inline struct ablkcipher_request *ablkcipher_dequeue_request(
-	struct ablkcipher_alg *alg)
+	struct crypto_queue *queue)
 {
-	return ablkcipher_request_cast(crypto_dequeue_request(alg->queue));
+	return ablkcipher_request_cast(crypto_dequeue_request(queue));
 }
 
 static inline void *ablkcipher_request_ctx(struct ablkcipher_request *req)
@@ -251,10 +251,10 @@ static inline void *ablkcipher_request_ctx(struct ablkcipher_request *req)
 	return req->__ctx;
 }
 
-static inline int ablkcipher_tfm_in_queue(struct crypto_ablkcipher *tfm)
+static inline int ablkcipher_tfm_in_queue(struct crypto_queue *queue,
+					  struct crypto_ablkcipher *tfm)
 {
-	return crypto_tfm_in_queue(crypto_ablkcipher_alg(tfm)->queue,
-				   crypto_ablkcipher_tfm(tfm));
+	return crypto_tfm_in_queue(queue, crypto_ablkcipher_tfm(tfm));
 }
 
 #endif	/* _CRYPTO_ALGAPI_H */
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index da09b4a..b1c7f41 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -95,7 +95,6 @@ struct crypto_async_request;
 struct crypto_aead;
 struct crypto_blkcipher;
 struct crypto_hash;
-struct crypto_queue;
 struct crypto_tfm;
 struct crypto_type;
 
@@ -178,8 +177,6 @@ struct ablkcipher_alg {
 	int (*encrypt)(struct ablkcipher_request *req);
 	int (*decrypt)(struct ablkcipher_request *req);
 
-	struct crypto_queue *queue;
-
 	unsigned int min_keysize;
 	unsigned int max_keysize;
 	unsigned int ivsize;
