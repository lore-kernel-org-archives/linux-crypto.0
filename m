From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v3 10/27] staging: ccree: add backlog processing
Date: Sun,  7 Jan 2018 12:14:21 +0000
Message-ID: <1515327285-8948-11-git-send-email-gilad@benyossef.com>
References: <1515327285-8948-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1515327285-8948-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Crypto API tfm providers are required to provide a backlog
service, if so indicated, that queues up requests in the case
of the provider being busy and processing them later.

The ccree driver did not provide this facility. Add it now.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_aead.c        |  26 +++---
 drivers/staging/ccree/ssi_cipher.c      |  13 ++-
 drivers/staging/ccree/ssi_driver.h      |   2 +-
 drivers/staging/ccree/ssi_hash.c        |  28 +++----
 drivers/staging/ccree/ssi_request_mgr.c | 136 ++++++++++++++++++++++++++++++--
 5 files changed, 163 insertions(+), 42 deletions(-)

diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index c2ae6f3..6f41a00 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -211,19 +211,21 @@ static int cc_aead_init(struct crypto_aead *tfm)
 	return -ENOMEM;
 }
 
-static void cc_aead_complete(struct device *dev, void *cc_req)
+static void cc_aead_complete(struct device *dev, void *cc_req, int err)
 {
 	struct aead_request *areq = (struct aead_request *)cc_req;
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(areq);
 	struct crypto_aead *tfm = crypto_aead_reqtfm(cc_req);
 	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
-	int err = 0;
 
 	cc_unmap_aead_request(dev, areq);
 
 	/* Restore ordinary iv pointer */
 	areq->iv = areq_ctx->backup_iv;
 
+	if (err)
+		goto done;
+
 	if (areq_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_DECRYPT) {
 		if (memcmp(areq_ctx->mac_buf, areq_ctx->icv_virt_addr,
 			   ctx->authsize) != 0) {
@@ -258,7 +260,7 @@ static void cc_aead_complete(struct device *dev, void *cc_req)
 				       CCM_BLOCK_IV_OFFSET, CCM_BLOCK_IV_SIZE);
 		}
 	}
-
+done:
 	aead_request_complete(areq, err);
 }
 
@@ -2041,7 +2043,7 @@ static int cc_proc_aead(struct aead_request *req,
 
 	rc = cc_send_request(ctx->drvdata, &cc_req, desc, seq_len, &req->base);
 
-	if (rc != -EINPROGRESS) {
+	if (rc != -EINPROGRESS && rc != -EBUSY) {
 		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
 		cc_unmap_aead_request(dev, req);
 	}
@@ -2063,7 +2065,7 @@ static int cc_aead_encrypt(struct aead_request *req)
 	areq_ctx->plaintext_authenticate_only = false;
 
 	rc = cc_proc_aead(req, DRV_CRYPTO_DIRECTION_ENCRYPT);
-	if (rc != -EINPROGRESS)
+	if (rc != -EINPROGRESS && rc != -EBUSY)
 		req->iv = areq_ctx->backup_iv;
 
 	return rc;
@@ -2092,7 +2094,7 @@ static int cc_rfc4309_ccm_encrypt(struct aead_request *req)
 	cc_proc_rfc4309_ccm(req);
 
 	rc = cc_proc_aead(req, DRV_CRYPTO_DIRECTION_ENCRYPT);
-	if (rc != -EINPROGRESS)
+	if (rc != -EINPROGRESS && rc != -EBUSY)
 		req->iv = areq_ctx->backup_iv;
 out:
 	return rc;
@@ -2111,7 +2113,7 @@ static int cc_aead_decrypt(struct aead_request *req)
 	areq_ctx->plaintext_authenticate_only = false;
 
 	rc = cc_proc_aead(req, DRV_CRYPTO_DIRECTION_DECRYPT);
-	if (rc != -EINPROGRESS)
+	if (rc != -EINPROGRESS && rc != -EBUSY)
 		req->iv = areq_ctx->backup_iv;
 
 	return rc;
@@ -2138,7 +2140,7 @@ static int cc_rfc4309_ccm_decrypt(struct aead_request *req)
 	cc_proc_rfc4309_ccm(req);
 
 	rc = cc_proc_aead(req, DRV_CRYPTO_DIRECTION_DECRYPT);
-	if (rc != -EINPROGRESS)
+	if (rc != -EINPROGRESS && rc != -EBUSY)
 		req->iv = areq_ctx->backup_iv;
 
 out:
@@ -2257,7 +2259,7 @@ static int cc_rfc4106_gcm_encrypt(struct aead_request *req)
 	areq_ctx->is_gcm4543 = true;
 
 	rc = cc_proc_aead(req, DRV_CRYPTO_DIRECTION_ENCRYPT);
-	if (rc != -EINPROGRESS)
+	if (rc != -EINPROGRESS && rc != -EBUSY)
 		req->iv = areq_ctx->backup_iv;
 out:
 	return rc;
@@ -2281,7 +2283,7 @@ static int cc_rfc4543_gcm_encrypt(struct aead_request *req)
 	areq_ctx->is_gcm4543 = true;
 
 	rc = cc_proc_aead(req, DRV_CRYPTO_DIRECTION_ENCRYPT);
-	if (rc != -EINPROGRESS)
+	if (rc != -EINPROGRESS && rc != -EBUSY)
 		req->iv = areq_ctx->backup_iv;
 
 	return rc;
@@ -2312,7 +2314,7 @@ static int cc_rfc4106_gcm_decrypt(struct aead_request *req)
 	areq_ctx->is_gcm4543 = true;
 
 	rc = cc_proc_aead(req, DRV_CRYPTO_DIRECTION_DECRYPT);
-	if (rc != -EINPROGRESS)
+	if (rc != -EINPROGRESS && rc != -EBUSY)
 		req->iv = areq_ctx->backup_iv;
 out:
 	return rc;
@@ -2336,7 +2338,7 @@ static int cc_rfc4543_gcm_decrypt(struct aead_request *req)
 	areq_ctx->is_gcm4543 = true;
 
 	rc = cc_proc_aead(req, DRV_CRYPTO_DIRECTION_DECRYPT);
-	if (rc != -EINPROGRESS)
+	if (rc != -EINPROGRESS && rc != -EBUSY)
 		req->iv = areq_ctx->backup_iv;
 
 	return rc;
diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
index beeed9c..a0e7d00 100644
--- a/drivers/staging/ccree/ssi_cipher.c
+++ b/drivers/staging/ccree/ssi_cipher.c
@@ -52,7 +52,7 @@ struct cc_cipher_ctx {
 	struct crypto_shash *shash_tfm;
 };
 
-static void cc_cipher_complete(struct device *dev, void *cc_req);
+static void cc_cipher_complete(struct device *dev, void *cc_req, int err);
 
 static int validate_keys_sizes(struct cc_cipher_ctx *ctx_p, u32 size)
 {
@@ -590,7 +590,7 @@ static void cc_setup_cipher_data(struct crypto_tfm *tfm,
 	}
 }
 
-static void cc_cipher_complete(struct device *dev, void *cc_req)
+static void cc_cipher_complete(struct device *dev, void *cc_req, int err)
 {
 	struct ablkcipher_request *areq = (struct ablkcipher_request *)cc_req;
 	struct scatterlist *dst = areq->dst;
@@ -598,7 +598,6 @@ static void cc_cipher_complete(struct device *dev, void *cc_req)
 	struct blkcipher_req_ctx *req_ctx = ablkcipher_request_ctx(areq);
 	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(areq);
 	unsigned int ivsize = crypto_ablkcipher_ivsize(tfm);
-	int completion_error = 0;
 	struct ablkcipher_request *req = (struct ablkcipher_request *)areq;
 
 	cc_unmap_blkcipher_request(dev, req_ctx, ivsize, src, dst);
@@ -614,13 +613,13 @@ static void cc_cipher_complete(struct device *dev, void *cc_req)
 	if (req_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_DECRYPT)  {
 		memcpy(req->info, req_ctx->backup_info, ivsize);
 		kfree(req_ctx->backup_info);
-	} else {
+	} else if (!err) {
 		scatterwalk_map_and_copy(req->info, req->dst,
 					 (req->nbytes - ivsize),
 					 ivsize, 0);
 	}
 
-	ablkcipher_request_complete(areq, completion_error);
+	ablkcipher_request_complete(areq, err);
 }
 
 static int cc_cipher_process(struct ablkcipher_request *req,
@@ -719,7 +718,7 @@ static int cc_cipher_process(struct ablkcipher_request *req,
 
 	rc = cc_send_request(ctx_p->drvdata, &cc_req, desc, seq_len,
 			     &req->base);
-	if (rc != -EINPROGRESS) {
+	if (rc != -EINPROGRESS && rc != -EBUSY) {
 		/* Failed to send the request or request completed
 		 * synchronously
 		 */
@@ -730,7 +729,7 @@ static int cc_cipher_process(struct ablkcipher_request *req,
 	if (cts_restore_flag)
 		ctx_p->cipher_mode = DRV_CIPHER_CBC_CTS;
 
-	if (rc != -EINPROGRESS) {
+	if (rc != -EINPROGRESS && rc != -EBUSY) {
 		kfree(req_ctx->backup_info);
 		kfree(req_ctx->iv);
 	}
diff --git a/drivers/staging/ccree/ssi_driver.h b/drivers/staging/ccree/ssi_driver.h
index f71c602..c2b978b 100644
--- a/drivers/staging/ccree/ssi_driver.h
+++ b/drivers/staging/ccree/ssi_driver.h
@@ -81,7 +81,7 @@ extern bool cc_dump_bytes;
 
 #define CC_MAX_IVGEN_DMA_ADDRESSES	3
 struct cc_crypto_req {
-	void (*user_cb)(struct device *dev, void *req);
+	void (*user_cb)(struct device *dev, void *req, int err);
 	void *user_arg;
 	dma_addr_t ivgen_dma_addr[CC_MAX_IVGEN_DMA_ADDRESSES];
 	/* For the first 'ivgen_dma_addr_len' addresses of this array,
diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index b05fd40..ff05ac8 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -342,7 +342,7 @@ static void cc_unmap_result(struct device *dev, struct ahash_req_ctx *state,
 	state->digest_result_dma_addr = 0;
 }
 
-static void cc_update_complete(struct device *dev, void *cc_req)
+static void cc_update_complete(struct device *dev, void *cc_req, int err)
 {
 	struct ahash_request *req = (struct ahash_request *)cc_req;
 	struct ahash_req_ctx *state = ahash_request_ctx(req);
@@ -350,10 +350,10 @@ static void cc_update_complete(struct device *dev, void *cc_req)
 	dev_dbg(dev, "req=%pK\n", req);
 
 	cc_unmap_hash_request(dev, state, req->src, false);
-	req->base.complete(&req->base, 0);
+	req->base.complete(&req->base, err);
 }
 
-static void cc_digest_complete(struct device *dev, void *cc_req)
+static void cc_digest_complete(struct device *dev, void *cc_req, int err)
 {
 	struct ahash_request *req = (struct ahash_request *)cc_req;
 	struct ahash_req_ctx *state = ahash_request_ctx(req);
@@ -366,10 +366,10 @@ static void cc_digest_complete(struct device *dev, void *cc_req)
 	cc_unmap_hash_request(dev, state, req->src, false);
 	cc_unmap_result(dev, state, digestsize, req->result);
 	cc_unmap_req(dev, state, ctx);
-	req->base.complete(&req->base, 0);
+	req->base.complete(&req->base, err);
 }
 
-static void cc_hash_complete(struct device *dev, void *cc_req)
+static void cc_hash_complete(struct device *dev, void *cc_req, int err)
 {
 	struct ahash_request *req = (struct ahash_request *)cc_req;
 	struct ahash_req_ctx *state = ahash_request_ctx(req);
@@ -382,7 +382,7 @@ static void cc_hash_complete(struct device *dev, void *cc_req)
 	cc_unmap_hash_request(dev, state, req->src, false);
 	cc_unmap_result(dev, state, digestsize, req->result);
 	cc_unmap_req(dev, state, ctx);
-	req->base.complete(&req->base, 0);
+	req->base.complete(&req->base, err);
 }
 
 static int cc_hash_digest(struct ahash_request *req)
@@ -533,7 +533,7 @@ static int cc_hash_digest(struct ahash_request *req)
 	idx++;
 
 	rc = cc_send_request(ctx->drvdata, &cc_req, desc, idx, &req->base);
-	if (rc != -EINPROGRESS) {
+	if (rc != -EINPROGRESS && rc != -EBUSY) {
 		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
 		cc_unmap_hash_request(dev, state, src, true);
 		cc_unmap_result(dev, state, digestsize, result);
@@ -621,7 +621,7 @@ static int cc_hash_update(struct ahash_request *req)
 	idx++;
 
 	rc = cc_send_request(ctx->drvdata, &cc_req, desc, idx, &req->base);
-	if (rc != -EINPROGRESS) {
+	if (rc != -EINPROGRESS && rc != -EBUSY) {
 		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
 		cc_unmap_hash_request(dev, state, src, true);
 	}
@@ -742,7 +742,7 @@ static int cc_hash_finup(struct ahash_request *req)
 	idx++;
 
 	rc = cc_send_request(ctx->drvdata, &cc_req, desc, idx, &req->base);
-	if (rc != -EINPROGRESS) {
+	if (rc != -EINPROGRESS && rc != -EBUSY) {
 		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
 		cc_unmap_hash_request(dev, state, src, true);
 		cc_unmap_result(dev, state, digestsize, result);
@@ -874,7 +874,7 @@ static int cc_hash_final(struct ahash_request *req)
 	idx++;
 
 	rc = cc_send_request(ctx->drvdata, &cc_req, desc, idx, &req->base);
-	if (rc != -EINPROGRESS) {
+	if (rc != -EINPROGRESS && rc != -EBUSY) {
 		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
 		cc_unmap_hash_request(dev, state, src, true);
 		cc_unmap_result(dev, state, digestsize, result);
@@ -1356,7 +1356,7 @@ static int cc_mac_update(struct ahash_request *req)
 	cc_req.user_arg = (void *)req;
 
 	rc = cc_send_request(ctx->drvdata, &cc_req, desc, idx, &req->base);
-	if (rc != -EINPROGRESS) {
+	if (rc != -EINPROGRESS && rc != -EBUSY) {
 		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
 		cc_unmap_hash_request(dev, state, req->src, true);
 	}
@@ -1469,7 +1469,7 @@ static int cc_mac_final(struct ahash_request *req)
 	idx++;
 
 	rc = cc_send_request(ctx->drvdata, &cc_req, desc, idx, &req->base);
-	if (rc != -EINPROGRESS) {
+	if (rc != -EINPROGRESS && rc != -EBUSY) {
 		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
 		cc_unmap_hash_request(dev, state, req->src, true);
 		cc_unmap_result(dev, state, digestsize, req->result);
@@ -1542,7 +1542,7 @@ static int cc_mac_finup(struct ahash_request *req)
 	idx++;
 
 	rc = cc_send_request(ctx->drvdata, &cc_req, desc, idx, &req->base);
-	if (rc != -EINPROGRESS) {
+	if (rc != -EINPROGRESS && rc != -EBUSY) {
 		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
 		cc_unmap_hash_request(dev, state, req->src, true);
 		cc_unmap_result(dev, state, digestsize, req->result);
@@ -1616,7 +1616,7 @@ static int cc_mac_digest(struct ahash_request *req)
 	idx++;
 
 	rc = cc_send_request(ctx->drvdata, &cc_req, desc, idx, &req->base);
-	if (rc != -EINPROGRESS) {
+	if (rc != -EINPROGRESS && rc != -EBUSY) {
 		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
 		cc_unmap_hash_request(dev, state, req->src, true);
 		cc_unmap_result(dev, state, digestsize, req->result);
diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
index f82eda1..1d13756 100644
--- a/drivers/staging/ccree/ssi_request_mgr.c
+++ b/drivers/staging/ccree/ssi_request_mgr.c
@@ -14,6 +14,8 @@
 #include "ssi_pm.h"
 
 #define CC_MAX_POLL_ITER	10
+/* The highest descriptor count in used */
+#define CC_MAX_DESC_SEQ_LEN	23
 
 struct cc_req_mgr_handle {
 	/* Request manager resources */
@@ -33,6 +35,11 @@ struct cc_req_mgr_handle {
 	u8 *dummy_comp_buff;
 	dma_addr_t dummy_comp_buff_dma;
 
+	/* backlog queue */
+	struct list_head backlog;
+	unsigned int bl_len;
+	spinlock_t bl_lock; /* protect backlog queue */
+
 #ifdef COMP_IN_WQ
 	struct workqueue_struct *workq;
 	struct delayed_work compwork;
@@ -44,6 +51,14 @@ struct cc_req_mgr_handle {
 #endif
 };
 
+struct cc_bl_item {
+	struct cc_crypto_req creq;
+	struct cc_hw_desc desc[CC_MAX_DESC_SEQ_LEN];
+	unsigned int len;
+	struct list_head list;
+	bool notif;
+};
+
 static void comp_handler(unsigned long devarg);
 #ifdef COMP_IN_WQ
 static void comp_work_handler(struct work_struct *work);
@@ -93,6 +108,9 @@ int cc_req_mgr_init(struct cc_drvdata *drvdata)
 	drvdata->request_mgr_handle = req_mgr_h;
 
 	spin_lock_init(&req_mgr_h->hw_lock);
+	spin_lock_init(&req_mgr_h->bl_lock);
+	INIT_LIST_HEAD(&req_mgr_h->backlog);
+
 #ifdef COMP_IN_WQ
 	dev_dbg(dev, "Initializing completion workqueue\n");
 	req_mgr_h->workq = create_singlethread_workqueue("arm_cc7x_wq");
@@ -177,7 +195,8 @@ static void enqueue_seq(struct cc_drvdata *drvdata, struct cc_hw_desc seq[],
  * \param dev
  * \param dx_compl_h The completion event to signal
  */
-static void request_mgr_complete(struct device *dev, void *dx_compl_h)
+static void request_mgr_complete(struct device *dev, void *dx_compl_h,
+				 int dummy)
 {
 	struct completion *this_compl = dx_compl_h;
 
@@ -322,6 +341,84 @@ static int cc_do_send_request(struct cc_drvdata *drvdata,
 	return -EINPROGRESS;
 }
 
+static void cc_enqueue_backlog(struct cc_drvdata *drvdata,
+			       struct cc_bl_item *bli)
+{
+	struct cc_req_mgr_handle *mgr = drvdata->request_mgr_handle;
+
+	spin_lock_bh(&mgr->bl_lock);
+	list_add_tail(&bli->list, &mgr->backlog);
+	++mgr->bl_len;
+	spin_unlock_bh(&mgr->bl_lock);
+	tasklet_schedule(&mgr->comptask);
+}
+
+static void cc_proc_backlog(struct cc_drvdata *drvdata)
+{
+	struct cc_req_mgr_handle *mgr = drvdata->request_mgr_handle;
+	struct cc_bl_item *bli;
+	struct cc_crypto_req *creq;
+	struct crypto_async_request *req;
+	bool ivgen;
+	unsigned int total_len;
+	struct device *dev = drvdata_to_dev(drvdata);
+	int rc;
+
+	spin_lock(&mgr->bl_lock);
+
+	while (mgr->bl_len) {
+		bli = list_first_entry(&mgr->backlog, struct cc_bl_item, list);
+		spin_unlock(&mgr->bl_lock);
+
+		creq = &bli->creq;
+		req = (struct crypto_async_request *)creq->user_arg;
+
+		/*
+		 * Notify the request we're moving out of the backlog
+		 * but only if we haven't done so already.
+		 */
+		if (!bli->notif) {
+			req->complete(req, -EINPROGRESS);
+			bli->notif = true;
+		}
+
+		ivgen = !!creq->ivgen_dma_addr_len;
+		total_len = bli->len + (ivgen ? CC_IVPOOL_SEQ_LEN : 0);
+
+		spin_lock(&mgr->hw_lock);
+
+		rc = cc_queues_status(drvdata, mgr, total_len);
+		if (rc) {
+			/*
+			 * There is still not room in the FIFO for
+			 * this request. Bail out. We'll return here
+			 * on the next completion irq.
+			 */
+			spin_unlock(&mgr->hw_lock);
+			return;
+		}
+
+		rc = cc_do_send_request(drvdata, &bli->creq, bli->desc,
+					bli->len, false, ivgen);
+
+		spin_unlock(&mgr->hw_lock);
+
+		if (rc != -EINPROGRESS) {
+#if defined(CONFIG_PM)
+			cc_pm_put_suspend(dev);
+#endif
+			creq->user_cb(dev, req, rc);
+		}
+
+		/* Remove ourselves from the backlog list */
+		spin_lock(&mgr->bl_lock);
+		list_del(&bli->list);
+		--mgr->bl_len;
+	}
+
+	spin_unlock(&mgr->bl_lock);
+}
+
 int cc_send_request(struct cc_drvdata *drvdata, struct cc_crypto_req *cc_req,
 		    struct cc_hw_desc *desc, unsigned int len,
 		    struct crypto_async_request *req)
@@ -331,6 +428,9 @@ int cc_send_request(struct cc_drvdata *drvdata, struct cc_crypto_req *cc_req,
 	bool ivgen = !!cc_req->ivgen_dma_addr_len;
 	unsigned int total_len = len + (ivgen ? CC_IVPOOL_SEQ_LEN : 0);
 	struct device *dev = drvdata_to_dev(drvdata);
+	bool backlog_ok = req->flags & CRYPTO_TFM_REQ_MAY_BACKLOG;
+	gfp_t flags = cc_gfp_flags(req);
+	struct cc_bl_item *bli;
 
 #if defined(CONFIG_PM)
 	rc = cc_pm_get(dev);
@@ -342,17 +442,35 @@ int cc_send_request(struct cc_drvdata *drvdata, struct cc_crypto_req *cc_req,
 	spin_lock_bh(&mgr->hw_lock);
 	rc = cc_queues_status(drvdata, mgr, total_len);
 
-	if (!rc)
-		rc = cc_do_send_request(drvdata, cc_req, desc, len, false,
-					ivgen);
+#ifdef CC_DEBUG_FORCE_BACKLOG
+	if (backlog_ok)
+		rc = -ENOSPC;
+#endif /* CC_DEBUG_FORCE_BACKLOG */
 
-	spin_unlock_bh(&mgr->hw_lock);
+	if (rc == -ENOSPC && backlog_ok) {
+		spin_unlock_bh(&mgr->hw_lock);
 
+		bli = kmalloc(sizeof(*bli), flags);
+		if (!bli) {
 #if defined(CONFIG_PM)
-	if (rc != -EINPROGRESS)
-		cc_pm_put_suspend(dev);
+			cc_pm_put_suspend(dev);
 #endif
+			return -ENOMEM;
+		}
+
+		memcpy(&bli->creq, cc_req, sizeof(*cc_req));
+		memcpy(&bli->desc, desc, len * sizeof(*desc));
+		bli->len = len;
+		bli->notif = false;
+		cc_enqueue_backlog(drvdata, bli);
+		return -EBUSY;
+	}
 
+	if (!rc)
+		rc = cc_do_send_request(drvdata, cc_req, desc, len, false,
+					ivgen);
+
+	spin_unlock_bh(&mgr->hw_lock);
 	return rc;
 }
 
@@ -501,7 +619,7 @@ static void proc_completions(struct cc_drvdata *drvdata)
 		cc_req = &request_mgr_handle->req_queue[*tail];
 
 		if (cc_req->user_cb)
-			cc_req->user_cb(dev, cc_req->user_arg);
+			cc_req->user_cb(dev, cc_req->user_arg, 0);
 		*tail = (*tail + 1) & (MAX_REQUEST_QUEUE_SIZE - 1);
 		dev_dbg(dev, "Dequeue request tail=%u\n", *tail);
 		dev_dbg(dev, "Request completed. axi_completed=%d\n",
@@ -566,6 +684,8 @@ static void comp_handler(unsigned long devarg)
 	 */
 	cc_iowrite(drvdata, CC_REG(HOST_IMR),
 		   cc_ioread(drvdata, CC_REG(HOST_IMR)) & ~irq);
+
+	cc_proc_backlog(drvdata);
 }
 
 /*
-- 
2.7.4
