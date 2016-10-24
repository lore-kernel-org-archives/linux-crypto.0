From: Fabio Estevam <festevam@gmail.com>
Subject: [PATCH v2] crypto: mxs-dcp - Remove hash support
Date: Mon, 24 Oct 2016 14:43:14 -0200
Message-ID: <1477327394-2976-1-git-send-email-festevam@gmail.com>
Cc: marex@denx.de, gianfranco.costamagna@abinsula.com,
        linux-crypto@vger.kernel.org, Fabio Estevam <fabio.estevam@nxp.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:32942 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754187AbcJXSnq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Oct 2016 14:43:46 -0400
Received: by mail-qt0-f193.google.com with SMTP id 12so26964qtm.0
        for <linux-crypto@vger.kernel.org>; Mon, 24 Oct 2016 11:43:45 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@nxp.com>

mxs-dcp driver does not probe for a long time:

mxs-dcp 80028000.dcp: Failed to register sha1 hash!
mxs-dcp: probe of 80028000.dcp failed with error -22

There were some previous attempts to fix this, and the following
feedback was given by Herbert Xu [1]:

"This driver is hopelessly broken as its request context doesn't
contain the hash state at all.  Unless someone can fix that we
should probably just remove the hash implementations altogether."

[1] http://www.spinics.net/lists/linux-crypto/msg18187.html

So remove the hash support for now.

Signed-off-by: Fabio Estevam <fabio.estevam@nxp.com>
---
Changes since v1:
- Fix typo in commit log

 drivers/crypto/mxs-dcp.c | 367 +----------------------------------------------
 1 file changed, 2 insertions(+), 365 deletions(-)

diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
index 625ee50..b1b1dda 100644
--- a/drivers/crypto/mxs-dcp.c
+++ b/drivers/crypto/mxs-dcp.c
@@ -498,278 +498,6 @@ static void mxs_dcp_aes_fallback_exit(struct crypto_tfm *tfm)
 	crypto_free_skcipher(actx->fallback);
 }
 
-/*
- * Hashing (SHA1/SHA256)
- */
-static int mxs_dcp_run_sha(struct ahash_request *req)
-{
-	struct dcp *sdcp = global_sdcp;
-	int ret;
-
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct dcp_async_ctx *actx = crypto_ahash_ctx(tfm);
-	struct dcp_sha_req_ctx *rctx = ahash_request_ctx(req);
-	struct hash_alg_common *halg = crypto_hash_alg_common(tfm);
-
-	struct dcp_dma_desc *desc = &sdcp->coh->desc[actx->chan];
-
-	dma_addr_t digest_phys = 0;
-	dma_addr_t buf_phys = dma_map_single(sdcp->dev, sdcp->coh->sha_in_buf,
-					     DCP_BUF_SZ, DMA_TO_DEVICE);
-
-	/* Fill in the DMA descriptor. */
-	desc->control0 = MXS_DCP_CONTROL0_DECR_SEMAPHORE |
-		    MXS_DCP_CONTROL0_INTERRUPT |
-		    MXS_DCP_CONTROL0_ENABLE_HASH;
-	if (rctx->init)
-		desc->control0 |= MXS_DCP_CONTROL0_HASH_INIT;
-
-	desc->control1 = actx->alg;
-	desc->next_cmd_addr = 0;
-	desc->source = buf_phys;
-	desc->destination = 0;
-	desc->size = actx->fill;
-	desc->payload = 0;
-	desc->status = 0;
-
-	/* Set HASH_TERM bit for last transfer block. */
-	if (rctx->fini) {
-		digest_phys = dma_map_single(sdcp->dev, req->result,
-					     halg->digestsize, DMA_FROM_DEVICE);
-		desc->control0 |= MXS_DCP_CONTROL0_HASH_TERM;
-		desc->payload = digest_phys;
-	}
-
-	ret = mxs_dcp_start_dma(actx);
-
-	if (rctx->fini)
-		dma_unmap_single(sdcp->dev, digest_phys, halg->digestsize,
-				 DMA_FROM_DEVICE);
-
-	dma_unmap_single(sdcp->dev, buf_phys, DCP_BUF_SZ, DMA_TO_DEVICE);
-
-	return ret;
-}
-
-static int dcp_sha_req_to_buf(struct crypto_async_request *arq)
-{
-	struct dcp *sdcp = global_sdcp;
-
-	struct ahash_request *req = ahash_request_cast(arq);
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct dcp_async_ctx *actx = crypto_ahash_ctx(tfm);
-	struct dcp_sha_req_ctx *rctx = ahash_request_ctx(req);
-	struct hash_alg_common *halg = crypto_hash_alg_common(tfm);
-	const int nents = sg_nents(req->src);
-
-	uint8_t *in_buf = sdcp->coh->sha_in_buf;
-
-	uint8_t *src_buf;
-
-	struct scatterlist *src;
-
-	unsigned int i, len, clen;
-	int ret;
-
-	int fin = rctx->fini;
-	if (fin)
-		rctx->fini = 0;
-
-	for_each_sg(req->src, src, nents, i) {
-		src_buf = sg_virt(src);
-		len = sg_dma_len(src);
-
-		do {
-			if (actx->fill + len > DCP_BUF_SZ)
-				clen = DCP_BUF_SZ - actx->fill;
-			else
-				clen = len;
-
-			memcpy(in_buf + actx->fill, src_buf, clen);
-			len -= clen;
-			src_buf += clen;
-			actx->fill += clen;
-
-			/*
-			 * If we filled the buffer and still have some
-			 * more data, submit the buffer.
-			 */
-			if (len && actx->fill == DCP_BUF_SZ) {
-				ret = mxs_dcp_run_sha(req);
-				if (ret)
-					return ret;
-				actx->fill = 0;
-				rctx->init = 0;
-			}
-		} while (len);
-	}
-
-	if (fin) {
-		rctx->fini = 1;
-
-		/* Submit whatever is left. */
-		if (!req->result)
-			return -EINVAL;
-
-		ret = mxs_dcp_run_sha(req);
-		if (ret)
-			return ret;
-
-		actx->fill = 0;
-
-		/* For some reason, the result is flipped. */
-		for (i = 0; i < halg->digestsize / 2; i++) {
-			swap(req->result[i],
-			     req->result[halg->digestsize - i - 1]);
-		}
-	}
-
-	return 0;
-}
-
-static int dcp_chan_thread_sha(void *data)
-{
-	struct dcp *sdcp = global_sdcp;
-	const int chan = DCP_CHAN_HASH_SHA;
-
-	struct crypto_async_request *backlog;
-	struct crypto_async_request *arq;
-
-	struct dcp_sha_req_ctx *rctx;
-
-	struct ahash_request *req;
-	int ret, fini;
-
-	do {
-		__set_current_state(TASK_INTERRUPTIBLE);
-
-		mutex_lock(&sdcp->mutex[chan]);
-		backlog = crypto_get_backlog(&sdcp->queue[chan]);
-		arq = crypto_dequeue_request(&sdcp->queue[chan]);
-		mutex_unlock(&sdcp->mutex[chan]);
-
-		if (backlog)
-			backlog->complete(backlog, -EINPROGRESS);
-
-		if (arq) {
-			req = ahash_request_cast(arq);
-			rctx = ahash_request_ctx(req);
-
-			ret = dcp_sha_req_to_buf(arq);
-			fini = rctx->fini;
-			arq->complete(arq, ret);
-			if (!fini)
-				continue;
-		}
-
-		schedule();
-	} while (!kthread_should_stop());
-
-	return 0;
-}
-
-static int dcp_sha_init(struct ahash_request *req)
-{
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct dcp_async_ctx *actx = crypto_ahash_ctx(tfm);
-
-	struct hash_alg_common *halg = crypto_hash_alg_common(tfm);
-
-	/*
-	 * Start hashing session. The code below only inits the
-	 * hashing session context, nothing more.
-	 */
-	memset(actx, 0, sizeof(*actx));
-
-	if (strcmp(halg->base.cra_name, "sha1") == 0)
-		actx->alg = MXS_DCP_CONTROL1_HASH_SELECT_SHA1;
-	else
-		actx->alg = MXS_DCP_CONTROL1_HASH_SELECT_SHA256;
-
-	actx->fill = 0;
-	actx->hot = 0;
-	actx->chan = DCP_CHAN_HASH_SHA;
-
-	mutex_init(&actx->mutex);
-
-	return 0;
-}
-
-static int dcp_sha_update_fx(struct ahash_request *req, int fini)
-{
-	struct dcp *sdcp = global_sdcp;
-
-	struct dcp_sha_req_ctx *rctx = ahash_request_ctx(req);
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct dcp_async_ctx *actx = crypto_ahash_ctx(tfm);
-
-	int ret;
-
-	/*
-	 * Ignore requests that have no data in them and are not
-	 * the trailing requests in the stream of requests.
-	 */
-	if (!req->nbytes && !fini)
-		return 0;
-
-	mutex_lock(&actx->mutex);
-
-	rctx->fini = fini;
-
-	if (!actx->hot) {
-		actx->hot = 1;
-		rctx->init = 1;
-	}
-
-	mutex_lock(&sdcp->mutex[actx->chan]);
-	ret = crypto_enqueue_request(&sdcp->queue[actx->chan], &req->base);
-	mutex_unlock(&sdcp->mutex[actx->chan]);
-
-	wake_up_process(sdcp->thread[actx->chan]);
-	mutex_unlock(&actx->mutex);
-
-	return -EINPROGRESS;
-}
-
-static int dcp_sha_update(struct ahash_request *req)
-{
-	return dcp_sha_update_fx(req, 0);
-}
-
-static int dcp_sha_final(struct ahash_request *req)
-{
-	ahash_request_set_crypt(req, NULL, req->result, 0);
-	req->nbytes = 0;
-	return dcp_sha_update_fx(req, 1);
-}
-
-static int dcp_sha_finup(struct ahash_request *req)
-{
-	return dcp_sha_update_fx(req, 1);
-}
-
-static int dcp_sha_digest(struct ahash_request *req)
-{
-	int ret;
-
-	ret = dcp_sha_init(req);
-	if (ret)
-		return ret;
-
-	return dcp_sha_finup(req);
-}
-
-static int dcp_sha_cra_init(struct crypto_tfm *tfm)
-{
-	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
-				 sizeof(struct dcp_sha_req_ctx));
-	return 0;
-}
-
-static void dcp_sha_cra_exit(struct crypto_tfm *tfm)
-{
-}
-
 /* AES 128 ECB and AES 128 CBC */
 static struct crypto_alg dcp_aes_algs[] = {
 	{
@@ -822,54 +550,6 @@ static struct crypto_alg dcp_aes_algs[] = {
 	},
 };
 
-/* SHA1 */
-static struct ahash_alg dcp_sha1_alg = {
-	.init	= dcp_sha_init,
-	.update	= dcp_sha_update,
-	.final	= dcp_sha_final,
-	.finup	= dcp_sha_finup,
-	.digest	= dcp_sha_digest,
-	.halg	= {
-		.digestsize	= SHA1_DIGEST_SIZE,
-		.base		= {
-			.cra_name		= "sha1",
-			.cra_driver_name	= "sha1-dcp",
-			.cra_priority		= 400,
-			.cra_alignmask		= 63,
-			.cra_flags		= CRYPTO_ALG_ASYNC,
-			.cra_blocksize		= SHA1_BLOCK_SIZE,
-			.cra_ctxsize		= sizeof(struct dcp_async_ctx),
-			.cra_module		= THIS_MODULE,
-			.cra_init		= dcp_sha_cra_init,
-			.cra_exit		= dcp_sha_cra_exit,
-		},
-	},
-};
-
-/* SHA256 */
-static struct ahash_alg dcp_sha256_alg = {
-	.init	= dcp_sha_init,
-	.update	= dcp_sha_update,
-	.final	= dcp_sha_final,
-	.finup	= dcp_sha_finup,
-	.digest	= dcp_sha_digest,
-	.halg	= {
-		.digestsize	= SHA256_DIGEST_SIZE,
-		.base		= {
-			.cra_name		= "sha256",
-			.cra_driver_name	= "sha256-dcp",
-			.cra_priority		= 400,
-			.cra_alignmask		= 63,
-			.cra_flags		= CRYPTO_ALG_ASYNC,
-			.cra_blocksize		= SHA256_BLOCK_SIZE,
-			.cra_ctxsize		= sizeof(struct dcp_async_ctx),
-			.cra_module		= THIS_MODULE,
-			.cra_init		= dcp_sha_cra_init,
-			.cra_exit		= dcp_sha_cra_exit,
-		},
-	},
-};
-
 static irqreturn_t mxs_dcp_irq(int irq, void *context)
 {
 	struct dcp *sdcp = context;
@@ -984,20 +664,12 @@ static int mxs_dcp_probe(struct platform_device *pdev)
 		crypto_init_queue(&sdcp->queue[i], 50);
 	}
 
-	/* Create the SHA and AES handler threads. */
-	sdcp->thread[DCP_CHAN_HASH_SHA] = kthread_run(dcp_chan_thread_sha,
-						      NULL, "mxs_dcp_chan/sha");
-	if (IS_ERR(sdcp->thread[DCP_CHAN_HASH_SHA])) {
-		dev_err(dev, "Error starting SHA thread!\n");
-		return PTR_ERR(sdcp->thread[DCP_CHAN_HASH_SHA]);
-	}
-
+	/* Create the AES handler threads. */
 	sdcp->thread[DCP_CHAN_CRYPTO] = kthread_run(dcp_chan_thread_aes,
 						    NULL, "mxs_dcp_chan/aes");
 	if (IS_ERR(sdcp->thread[DCP_CHAN_CRYPTO])) {
 		dev_err(dev, "Error starting SHA thread!\n");
-		ret = PTR_ERR(sdcp->thread[DCP_CHAN_CRYPTO]);
-		goto err_destroy_sha_thread;
+		return PTR_ERR(sdcp->thread[DCP_CHAN_CRYPTO]);
 	}
 
 	/* Register the various crypto algorithms. */
@@ -1013,39 +685,10 @@ static int mxs_dcp_probe(struct platform_device *pdev)
 		}
 	}
 
-	if (sdcp->caps & MXS_DCP_CAPABILITY1_SHA1) {
-		ret = crypto_register_ahash(&dcp_sha1_alg);
-		if (ret) {
-			dev_err(dev, "Failed to register %s hash!\n",
-				dcp_sha1_alg.halg.base.cra_name);
-			goto err_unregister_aes;
-		}
-	}
-
-	if (sdcp->caps & MXS_DCP_CAPABILITY1_SHA256) {
-		ret = crypto_register_ahash(&dcp_sha256_alg);
-		if (ret) {
-			dev_err(dev, "Failed to register %s hash!\n",
-				dcp_sha256_alg.halg.base.cra_name);
-			goto err_unregister_sha1;
-		}
-	}
-
 	return 0;
 
-err_unregister_sha1:
-	if (sdcp->caps & MXS_DCP_CAPABILITY1_SHA1)
-		crypto_unregister_ahash(&dcp_sha1_alg);
-
-err_unregister_aes:
-	if (sdcp->caps & MXS_DCP_CAPABILITY1_AES128)
-		crypto_unregister_algs(dcp_aes_algs, ARRAY_SIZE(dcp_aes_algs));
-
 err_destroy_aes_thread:
 	kthread_stop(sdcp->thread[DCP_CHAN_CRYPTO]);
-
-err_destroy_sha_thread:
-	kthread_stop(sdcp->thread[DCP_CHAN_HASH_SHA]);
 	return ret;
 }
 
@@ -1053,12 +696,6 @@ static int mxs_dcp_remove(struct platform_device *pdev)
 {
 	struct dcp *sdcp = platform_get_drvdata(pdev);
 
-	if (sdcp->caps & MXS_DCP_CAPABILITY1_SHA256)
-		crypto_unregister_ahash(&dcp_sha256_alg);
-
-	if (sdcp->caps & MXS_DCP_CAPABILITY1_SHA1)
-		crypto_unregister_ahash(&dcp_sha1_alg);
-
 	if (sdcp->caps & MXS_DCP_CAPABILITY1_AES128)
 		crypto_unregister_algs(dcp_aes_algs, ARRAY_SIZE(dcp_aes_algs));
 
-- 
2.7.4
