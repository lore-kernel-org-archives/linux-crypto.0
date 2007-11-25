From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 5/11] [CRYPTO] chainiv: Add chain IV generator
Date: Sun, 25 Nov 2007 20:31:41 +0800
Message-ID: <20071125123141.GA12170@gondor.apana.org.au>
References: <20071122084758.GA7536@gondor.apana.org.au> <E1Iv7jn-00020S-00@gondolin.me.apana.org.au> <20071122111711.GC2444@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1254 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751851AbXKYMbs (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 25 Nov 2007 07:31:48 -0500
Content-Disposition: inline
In-Reply-To: <20071122111711.GC2444@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Nov 22, 2007 at 02:17:11PM +0300, Evgeniy Polyakov wrote:
> 
> Are you sure that crypto operation has to be limited to be performed
> with turned off bottom halves? I believe this is a huge limitation for
> those ablkcipher devices which are not async actually...

OK, one night I suddenly had this idea that we can postpone the
uncommon collision case to process context.  Here's the patch.

So as long as we're doing things one-by-one nothing changes.

However, once we see contention we move the work into a work
queue.  This should be better compared to what we do now which
is to have the contending CPU spin waiting for the other CPU to
finish its crypto operation.

We only move back once things quiten down.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
diff --git a/crypto/chainiv.c b/crypto/chainiv.c
index 25aa244..d2882b5 100644
--- a/crypto/chainiv.c
+++ b/crypto/chainiv.c
@@ -20,45 +20,107 @@
 #include <linux/random.h>
 #include <linux/spinlock.h>
 #include <linux/string.h>
+#include <linux/workqueue.h>
+
+enum {
+	CHAINIV_STATE_INUSE = 0,
+};
 
 struct chainiv_ctx {
 	struct crypto_ablkcipher *cipher;
+	unsigned long state;
+
 	spinlock_t lock;
+	struct crypto_queue queue;
+
+	struct work_struct postponed;
+	int err;
+
 	char iv[];
 };
 
-static int chainiv_givcrypt(struct ablkcipher_request *req)
+static int chainiv_schedule_work(struct chainiv_ctx *ctx)
+{
+	int queued;
+
+	if (!ctx->queue.qlen) {
+		smp_mb__before_clear_bit();
+		clear_bit(CHAINIV_STATE_INUSE, &ctx->state);
+
+		if (!ctx->queue.qlen ||
+		    test_and_set_bit(CHAINIV_STATE_INUSE, &ctx->state))
+			goto out;
+	}
+
+	queued = schedule_work(&ctx->postponed);
+	BUG_ON(!queued);
+
+out:
+	return ctx->err;
+}
+
+static int chainiv_postpone_request(struct ablkcipher_request *req)
+{
+	struct crypto_ablkcipher *geniv = crypto_ablkcipher_reqtfm(req);
+	struct chainiv_ctx *ctx = crypto_ablkcipher_ctx(geniv);
+	int err;
+
+	spin_lock_bh(&ctx->lock);
+	err = ablkcipher_enqueue_request(&ctx->queue, req);
+	spin_unlock_bh(&ctx->lock);
+
+	if (test_and_set_bit(CHAINIV_STATE_INUSE, &ctx->state))
+		return err;
+
+	ctx->err = err;
+	return chainiv_schedule_work(ctx);
+}
+
+static int chainiv_givcrypt_tail(struct ablkcipher_request *req)
 {
 	struct crypto_ablkcipher *geniv = crypto_ablkcipher_reqtfm(req);
 	struct chainiv_ctx *ctx = crypto_ablkcipher_ctx(geniv);
 	struct ablkcipher_request *subreq = ablkcipher_request_ctx(req);
 	unsigned int ivsize;
-	int err;
 
 	ablkcipher_request_set_tfm(subreq, ctx->cipher);
-	ablkcipher_request_set_callback(subreq, req->base.flags &
-						~CRYPTO_TFM_REQ_MAY_SLEEP,
+	ablkcipher_request_set_callback(subreq, req->base.flags,
 					req->base.complete, req->base.data);
 	ablkcipher_request_set_crypt(subreq, req->src, req->dst, req->nbytes,
 				     req->info);
 
-	spin_lock_bh(&ctx->lock);
-
 	ivsize = crypto_ablkcipher_ivsize(geniv);
 
 	memcpy(req->giv, ctx->iv, ivsize);
 	memcpy(req->info, ctx->iv, ivsize);
 
-	err = crypto_ablkcipher_encrypt(subreq);
-	if (err)
-		goto unlock;
+	ctx->err = crypto_ablkcipher_encrypt(subreq);
+	if (ctx->err)
+		goto out;
 
 	memcpy(ctx->iv, req->info, ivsize);
 
-unlock:
-	spin_unlock_bh(&ctx->lock);
+out:
+	return chainiv_schedule_work(ctx);
+}
 
-	return err;
+static int chainiv_givcrypt(struct ablkcipher_request *req)
+{
+	struct crypto_ablkcipher *geniv = crypto_ablkcipher_reqtfm(req);
+	struct chainiv_ctx *ctx = crypto_ablkcipher_ctx(geniv);
+
+	if (test_and_set_bit(CHAINIV_STATE_INUSE, &ctx->state))
+		goto postpone;
+
+	if (ctx->queue.qlen) {
+		clear_bit(CHAINIV_STATE_INUSE, &ctx->state);
+		goto postpone;
+	}
+
+	return chainiv_givcrypt_tail(req);
+
+postpone:
+	return chainiv_postpone_request(req);
 }
 
 static int chainiv_givcrypt_first(struct ablkcipher_request *req)
@@ -67,19 +129,43 @@ static int chainiv_givcrypt_first(struct ablkcipher_request *req)
 	struct chainiv_ctx *ctx = crypto_ablkcipher_ctx(geniv);
 	struct crypto_ablkcipher *cipher = ctx->cipher;
 
-	spin_lock_bh(&ctx->lock);
+	if (test_and_set_bit(CHAINIV_STATE_INUSE, &ctx->state))
+		goto out;
+
 	if (crypto_ablkcipher_crt(cipher)->givcrypt != chainiv_givcrypt_first)
 		goto unlock;
 
 	crypto_ablkcipher_crt(cipher)->givcrypt = chainiv_givcrypt;
 	get_random_bytes(ctx->iv, crypto_ablkcipher_ivsize(geniv));
 
+	return chainiv_givcrypt_tail(req);
+
 unlock:
-	spin_unlock_bh(&ctx->lock);
+	clear_bit(CHAINIV_STATE_INUSE, &ctx->state);
 
+out:
 	return chainiv_givcrypt(req);
 }
 
+static void chainiv_do_postponed(struct work_struct *work)
+{
+	struct chainiv_ctx *ctx = container_of(work, struct chainiv_ctx,
+					       postponed);
+	struct ablkcipher_request *req;
+
+	/* Only handle one request to avoid hogging keventd. */
+	spin_lock_bh(&ctx->lock);
+	req = ablkcipher_dequeue_request(&ctx->queue);
+	spin_unlock_bh(&ctx->lock);
+
+	if (!req) {
+		chainiv_schedule_work(ctx);
+		return;
+	}
+
+	chainiv_givcrypt_tail(req);
+}
+
 static int chainiv_init(struct crypto_tfm *tfm)
 {
 	struct crypto_instance *inst = (void *)tfm->__crt_alg;
@@ -94,6 +180,9 @@ static int chainiv_init(struct crypto_tfm *tfm)
 	ctx->cipher = cipher;
 	spin_lock_init(&ctx->lock);
 
+	crypto_init_queue(&ctx->queue, 100);
+	INIT_WORK(&ctx->postponed, chainiv_do_postponed);
+
 	tfm->crt_ablkcipher.reqsize = sizeof(struct ablkcipher_request) +
 				      crypto_ablkcipher_reqsize(cipher);
 
@@ -103,6 +192,9 @@ static int chainiv_init(struct crypto_tfm *tfm)
 static void chainiv_exit(struct crypto_tfm *tfm)
 {
 	struct chainiv_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	BUG_ON(test_bit(CHAINIV_STATE_INUSE, &ctx->state) || ctx->queue.qlen);
+
 	crypto_free_ablkcipher(ctx->cipher);
 }
 
@@ -117,6 +209,8 @@ static struct crypto_instance *chainiv_alloc(struct rtattr **tb)
 	if (IS_ERR(inst))
 		goto out;
 
+	inst->alg.cra_flags |= CRYPTO_ALG_ASYNC;
+
 	inst->alg.cra_ablkcipher.givcrypt = chainiv_givcrypt_first;
 
 	inst->alg.cra_init = chainiv_init;
