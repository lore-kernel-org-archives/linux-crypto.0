From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v3 09/27] staging: ccree: break send_request and fix ret val
Date: Sun,  7 Jan 2018 12:14:20 +0000
Message-ID: <1515327285-8948-10-git-send-email-gilad@benyossef.com>
References: <1515327285-8948-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1515327285-8948-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The send_request() function was handling both synchronous
and asynchronous invocations, but were not handling
the asynchronous case, which may be called in an atomic
context, properly as it was sleeping.

Start to fix the problem by breaking up the two use
cases to separate functions calling a common internal
service function and return error instead of sleeping
for the asynchronous case.

The next patch will complete the fix by implementing
proper backlog handling.

Fixes: abefd6741d ("staging: ccree: introduce CryptoCell HW driver").
Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_aead.c        |   6 +-
 drivers/staging/ccree/ssi_cipher.c      |   3 +-
 drivers/staging/ccree/ssi_hash.c        |  22 ++--
 drivers/staging/ccree/ssi_request_mgr.c | 180 ++++++++++++++++++--------------
 drivers/staging/ccree/ssi_request_mgr.h |  11 +-
 5 files changed, 128 insertions(+), 94 deletions(-)

diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index 414098a..c2ae6f3 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -531,7 +531,7 @@ cc_get_plain_hmac_key(struct crypto_aead *tfm, const u8 *key,
 		idx++;
 	}
 
-	rc = send_request(ctx->drvdata, &cc_req, desc, idx, 0);
+	rc = cc_send_sync_request(ctx->drvdata, &cc_req, desc, idx);
 	if (rc)
 		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
 
@@ -630,7 +630,7 @@ cc_aead_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
 	/* STAT_PHASE_3: Submit sequence to HW */
 
 	if (seq_len > 0) { /* For CCM there is no sequence to setup the key */
-		rc = send_request(ctx->drvdata, &cc_req, desc, seq_len, 0);
+		rc = cc_send_sync_request(ctx->drvdata, &cc_req, desc, seq_len);
 		if (rc) {
 			dev_err(dev, "send_request() failed (rc=%d)\n", rc);
 			goto setkey_error;
@@ -2039,7 +2039,7 @@ static int cc_proc_aead(struct aead_request *req,
 
 	/* STAT_PHASE_3: Lock HW and push sequence */
 
-	rc = send_request(ctx->drvdata, &cc_req, desc, seq_len, 1);
+	rc = cc_send_request(ctx->drvdata, &cc_req, desc, seq_len, &req->base);
 
 	if (rc != -EINPROGRESS) {
 		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
index 933a452..beeed9c 100644
--- a/drivers/staging/ccree/ssi_cipher.c
+++ b/drivers/staging/ccree/ssi_cipher.c
@@ -717,7 +717,8 @@ static int cc_cipher_process(struct ablkcipher_request *req,
 
 	/* STAT_PHASE_3: Lock HW and push sequence */
 
-	rc = send_request(ctx_p->drvdata, &cc_req, desc, seq_len, 1);
+	rc = cc_send_request(ctx_p->drvdata, &cc_req, desc, seq_len,
+			     &req->base);
 	if (rc != -EINPROGRESS) {
 		/* Failed to send the request or request completed
 		 * synchronously
diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index b51a1d4..b05fd40 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -532,7 +532,7 @@ static int cc_hash_digest(struct ahash_request *req)
 	cc_set_endianity(ctx->hash_mode, &desc[idx]);
 	idx++;
 
-	rc = send_request(ctx->drvdata, &cc_req, desc, idx, 1);
+	rc = cc_send_request(ctx->drvdata, &cc_req, desc, idx, &req->base);
 	if (rc != -EINPROGRESS) {
 		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
 		cc_unmap_hash_request(dev, state, src, true);
@@ -620,7 +620,7 @@ static int cc_hash_update(struct ahash_request *req)
 	set_setup_mode(&desc[idx], SETUP_WRITE_STATE1);
 	idx++;
 
-	rc = send_request(ctx->drvdata, &cc_req, desc, idx, 1);
+	rc = cc_send_request(ctx->drvdata, &cc_req, desc, idx, &req->base);
 	if (rc != -EINPROGRESS) {
 		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
 		cc_unmap_hash_request(dev, state, src, true);
@@ -741,7 +741,7 @@ static int cc_hash_finup(struct ahash_request *req)
 	set_cipher_mode(&desc[idx], ctx->hw_mode);
 	idx++;
 
-	rc = send_request(ctx->drvdata, &cc_req, desc, idx, 1);
+	rc = cc_send_request(ctx->drvdata, &cc_req, desc, idx, &req->base);
 	if (rc != -EINPROGRESS) {
 		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
 		cc_unmap_hash_request(dev, state, src, true);
@@ -873,7 +873,7 @@ static int cc_hash_final(struct ahash_request *req)
 	set_cipher_mode(&desc[idx], ctx->hw_mode);
 	idx++;
 
-	rc = send_request(ctx->drvdata, &cc_req, desc, idx, 1);
+	rc = cc_send_request(ctx->drvdata, &cc_req, desc, idx, &req->base);
 	if (rc != -EINPROGRESS) {
 		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
 		cc_unmap_hash_request(dev, state, src, true);
@@ -1014,7 +1014,7 @@ static int cc_hash_setkey(struct crypto_ahash *ahash, const u8 *key,
 		idx++;
 	}
 
-	rc = send_request(ctx->drvdata, &cc_req, desc, idx, 0);
+	rc = cc_send_sync_request(ctx->drvdata, &cc_req, desc, idx);
 	if (rc) {
 		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
 		goto out;
@@ -1071,7 +1071,7 @@ static int cc_hash_setkey(struct crypto_ahash *ahash, const u8 *key,
 		idx++;
 	}
 
-	rc = send_request(ctx->drvdata, &cc_req, desc, idx, 0);
+	rc = cc_send_sync_request(ctx->drvdata, &cc_req, desc, idx);
 
 out:
 	if (rc)
@@ -1154,7 +1154,7 @@ static int cc_xcbc_setkey(struct crypto_ahash *ahash,
 			       CC_AES_128_BIT_KEY_SIZE, NS_BIT, 0);
 	idx++;
 
-	rc = send_request(ctx->drvdata, &cc_req, desc, idx, 0);
+	rc = cc_send_sync_request(ctx->drvdata, &cc_req, desc, idx);
 
 	if (rc)
 		crypto_ahash_set_flags(ahash, CRYPTO_TFM_RES_BAD_KEY_LEN);
@@ -1355,7 +1355,7 @@ static int cc_mac_update(struct ahash_request *req)
 	cc_req.user_cb = (void *)cc_update_complete;
 	cc_req.user_arg = (void *)req;
 
-	rc = send_request(ctx->drvdata, &cc_req, desc, idx, 1);
+	rc = cc_send_request(ctx->drvdata, &cc_req, desc, idx, &req->base);
 	if (rc != -EINPROGRESS) {
 		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
 		cc_unmap_hash_request(dev, state, req->src, true);
@@ -1468,7 +1468,7 @@ static int cc_mac_final(struct ahash_request *req)
 	set_cipher_mode(&desc[idx], ctx->hw_mode);
 	idx++;
 
-	rc = send_request(ctx->drvdata, &cc_req, desc, idx, 1);
+	rc = cc_send_request(ctx->drvdata, &cc_req, desc, idx, &req->base);
 	if (rc != -EINPROGRESS) {
 		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
 		cc_unmap_hash_request(dev, state, req->src, true);
@@ -1541,7 +1541,7 @@ static int cc_mac_finup(struct ahash_request *req)
 	set_cipher_mode(&desc[idx], ctx->hw_mode);
 	idx++;
 
-	rc = send_request(ctx->drvdata, &cc_req, desc, idx, 1);
+	rc = cc_send_request(ctx->drvdata, &cc_req, desc, idx, &req->base);
 	if (rc != -EINPROGRESS) {
 		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
 		cc_unmap_hash_request(dev, state, req->src, true);
@@ -1615,7 +1615,7 @@ static int cc_mac_digest(struct ahash_request *req)
 	set_cipher_mode(&desc[idx], ctx->hw_mode);
 	idx++;
 
-	rc = send_request(ctx->drvdata, &cc_req, desc, idx, 1);
+	rc = cc_send_request(ctx->drvdata, &cc_req, desc, idx, &req->base);
 	if (rc != -EINPROGRESS) {
 		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
 		cc_unmap_hash_request(dev, state, req->src, true);
diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
index e1c01da..f82eda1 100644
--- a/drivers/staging/ccree/ssi_request_mgr.c
+++ b/drivers/staging/ccree/ssi_request_mgr.c
@@ -172,7 +172,7 @@ static void enqueue_seq(struct cc_drvdata *drvdata, struct cc_hw_desc seq[],
 
 /*!
  * Completion will take place if and only if user requested completion
- * by setting "is_dout = 0" in send_request().
+ * by cc_send_sync_request().
  *
  * \param dev
  * \param dx_compl_h The completion event to signal
@@ -199,7 +199,7 @@ static int cc_queues_status(struct cc_drvdata *drvdata,
 	    req_mgr_h->req_queue_tail) {
 		dev_err(dev, "SW FIFO is full. req_queue_head=%d sw_fifo_len=%d\n",
 			req_mgr_h->req_queue_head, MAX_REQUEST_QUEUE_SIZE);
-		return -EBUSY;
+		return -ENOSPC;
 	}
 
 	if (req_mgr_h->q_free_slots >= total_seq_len)
@@ -224,24 +224,25 @@ static int cc_queues_status(struct cc_drvdata *drvdata,
 	dev_dbg(dev, "HW FIFO full, timeout. req_queue_head=%d sw_fifo_len=%d q_free_slots=%d total_seq_len=%d\n",
 		req_mgr_h->req_queue_head, MAX_REQUEST_QUEUE_SIZE,
 		req_mgr_h->q_free_slots, total_seq_len);
-	return -EAGAIN;
+	return -ENOSPC;
 }
 
 /*!
  * Enqueue caller request to crypto hardware.
+ * Need to be called with HW lock held and PM running
  *
  * \param drvdata
  * \param cc_req The request to enqueue
  * \param desc The crypto sequence
  * \param len The crypto sequence length
- * \param is_dout If "true": completion is handled by the caller
- *	  If "false": this function adds a dummy descriptor completion
- *	  and waits upon completion signal.
+ * \param add_comp If "true": add an artificial dout DMA to mark completion
  *
- * \return int Returns -EINPROGRESS if "is_dout=true"; "0" if "is_dout=false"
+ * \return int Returns -EINPROGRESS or error code
  */
-int send_request(struct cc_drvdata *drvdata, struct cc_crypto_req *cc_req,
-		 struct cc_hw_desc *desc, unsigned int len, bool is_dout)
+static int cc_do_send_request(struct cc_drvdata *drvdata,
+			      struct cc_crypto_req *cc_req,
+			      struct cc_hw_desc *desc, unsigned int len,
+				bool add_comp, bool ivgen)
 {
 	struct cc_req_mgr_handle *req_mgr_h = drvdata->request_mgr_handle;
 	unsigned int used_sw_slots;
@@ -250,59 +251,8 @@ int send_request(struct cc_drvdata *drvdata, struct cc_crypto_req *cc_req,
 	struct cc_hw_desc iv_seq[CC_IVPOOL_SEQ_LEN];
 	struct device *dev = drvdata_to_dev(drvdata);
 	int rc;
-	unsigned int max_required_seq_len =
-		(total_seq_len +
-		 ((cc_req->ivgen_dma_addr_len == 0) ? 0 :
-		  CC_IVPOOL_SEQ_LEN) + (!is_dout ? 1 : 0));
-
-#if defined(CONFIG_PM)
-	rc = cc_pm_get(dev);
-	if (rc) {
-		dev_err(dev, "ssi_power_mgr_runtime_get returned %x\n", rc);
-		return rc;
-	}
-#endif
-
-	do {
-		spin_lock_bh(&req_mgr_h->hw_lock);
-
-		/* Check if there is enough place in the SW/HW queues
-		 * in case iv gen add the max size and in case of no dout add 1
-		 * for the internal completion descriptor
-		 */
-		rc = cc_queues_status(drvdata, req_mgr_h, max_required_seq_len);
-		if (rc == 0)
-			/* There is enough place in the queue */
-			break;
-		/* something wrong release the spinlock*/
-		spin_unlock_bh(&req_mgr_h->hw_lock);
-
-		if (rc != -EAGAIN) {
-			/* Any error other than HW queue full
-			 * (SW queue is full)
-			 */
-#if defined(CONFIG_PM)
-			cc_pm_put_suspend(dev);
-#endif
-			return rc;
-		}
-
-		/* HW queue is full - wait for it to clear up */
-		wait_for_completion_interruptible(&drvdata->hw_queue_avail);
-		reinit_completion(&drvdata->hw_queue_avail);
-	} while (1);
 
-	/* Additional completion descriptor is needed incase caller did not
-	 * enabled any DLLI/MLLI DOUT bit in the given sequence
-	 */
-	if (!is_dout) {
-		init_completion(&cc_req->seq_compl);
-		cc_req->user_cb = request_mgr_complete;
-		cc_req->user_arg = &cc_req->seq_compl;
-		total_seq_len++;
-	}
-
-	if (cc_req->ivgen_dma_addr_len > 0) {
+	if (ivgen) {
 		dev_dbg(dev, "Acquire IV from pool into %d DMA addresses %pad, %pad, %pad, IV-size=%u\n",
 			cc_req->ivgen_dma_addr_len,
 			&cc_req->ivgen_dma_addr[0],
@@ -318,10 +268,6 @@ int send_request(struct cc_drvdata *drvdata, struct cc_crypto_req *cc_req,
 
 		if (rc) {
 			dev_err(dev, "Failed to generate IV (rc=%d)\n", rc);
-			spin_unlock_bh(&req_mgr_h->hw_lock);
-#if defined(CONFIG_PM)
-			cc_pm_put_suspend(dev);
-#endif
 			return rc;
 		}
 
@@ -350,9 +296,15 @@ int send_request(struct cc_drvdata *drvdata, struct cc_crypto_req *cc_req,
 	wmb();
 
 	/* STAT_PHASE_4: Push sequence */
-	enqueue_seq(drvdata, iv_seq, iv_seq_len);
+	if (ivgen)
+		enqueue_seq(drvdata, iv_seq, iv_seq_len);
+
 	enqueue_seq(drvdata, desc, len);
-	enqueue_seq(drvdata, &req_mgr_h->compl_desc, (is_dout ? 0 : 1));
+
+	if (add_comp) {
+		enqueue_seq(drvdata, &req_mgr_h->compl_desc, 1);
+		total_seq_len++;
+	}
 
 	if (req_mgr_h->q_free_slots < total_seq_len) {
 		/* This situation should never occur. Maybe indicating problem
@@ -366,19 +318,95 @@ int send_request(struct cc_drvdata *drvdata, struct cc_crypto_req *cc_req,
 		req_mgr_h->q_free_slots -= total_seq_len;
 	}
 
-	spin_unlock_bh(&req_mgr_h->hw_lock);
-
-	if (!is_dout) {
-		/* Wait upon sequence completion.
-		 *  Return "0" -Operation done successfully.
-		 */
-		wait_for_completion(&cc_req->seq_compl);
-		return 0;
-	}
 	/* Operation still in process */
 	return -EINPROGRESS;
 }
 
+int cc_send_request(struct cc_drvdata *drvdata, struct cc_crypto_req *cc_req,
+		    struct cc_hw_desc *desc, unsigned int len,
+		    struct crypto_async_request *req)
+{
+	int rc;
+	struct cc_req_mgr_handle *mgr = drvdata->request_mgr_handle;
+	bool ivgen = !!cc_req->ivgen_dma_addr_len;
+	unsigned int total_len = len + (ivgen ? CC_IVPOOL_SEQ_LEN : 0);
+	struct device *dev = drvdata_to_dev(drvdata);
+
+#if defined(CONFIG_PM)
+	rc = cc_pm_get(dev);
+	if (rc) {
+		dev_err(dev, "ssi_power_mgr_runtime_get returned %x\n", rc);
+		return rc;
+	}
+#endif
+	spin_lock_bh(&mgr->hw_lock);
+	rc = cc_queues_status(drvdata, mgr, total_len);
+
+	if (!rc)
+		rc = cc_do_send_request(drvdata, cc_req, desc, len, false,
+					ivgen);
+
+	spin_unlock_bh(&mgr->hw_lock);
+
+#if defined(CONFIG_PM)
+	if (rc != -EINPROGRESS)
+		cc_pm_put_suspend(dev);
+#endif
+
+	return rc;
+}
+
+int cc_send_sync_request(struct cc_drvdata *drvdata,
+			 struct cc_crypto_req *cc_req, struct cc_hw_desc *desc,
+			 unsigned int len)
+{
+	int rc;
+	struct device *dev = drvdata_to_dev(drvdata);
+	struct cc_req_mgr_handle *mgr = drvdata->request_mgr_handle;
+
+	init_completion(&cc_req->seq_compl);
+	cc_req->user_cb = request_mgr_complete;
+	cc_req->user_arg = &cc_req->seq_compl;
+
+#if defined(CONFIG_PM)
+	rc = cc_pm_get(dev);
+	if (rc) {
+		dev_err(dev, "ssi_power_mgr_runtime_get returned %x\n", rc);
+		return rc;
+	}
+#endif
+	while (true) {
+		spin_lock_bh(&mgr->hw_lock);
+		rc = cc_queues_status(drvdata, mgr, len + 1);
+
+		if (!rc)
+			break;
+
+		spin_unlock_bh(&mgr->hw_lock);
+		if (rc != -EAGAIN) {
+#if defined(CONFIG_PM)
+			cc_pm_put_suspend(dev);
+#endif
+			return rc;
+		}
+		wait_for_completion_interruptible(&drvdata->hw_queue_avail);
+		reinit_completion(&drvdata->hw_queue_avail);
+	}
+
+	rc = cc_do_send_request(drvdata, cc_req, desc, len, true, false);
+	spin_unlock_bh(&mgr->hw_lock);
+
+	if (rc != -EINPROGRESS) {
+#if defined(CONFIG_PM)
+		cc_pm_put_suspend(dev);
+#endif
+		return rc;
+	}
+
+	wait_for_completion(&cc_req->seq_compl);
+	return 0;
+}
+
 /*!
  * Enqueue caller request to crypto hardware during init process.
  * assume this function is not called in middle of a flow,
diff --git a/drivers/staging/ccree/ssi_request_mgr.h b/drivers/staging/ccree/ssi_request_mgr.h
index 8f9a9d3..f11a26a 100644
--- a/drivers/staging/ccree/ssi_request_mgr.h
+++ b/drivers/staging/ccree/ssi_request_mgr.h
@@ -23,10 +23,15 @@ int cc_req_mgr_init(struct cc_drvdata *drvdata);
  *	  If "false": this function adds a dummy descriptor completion
  *	  and waits upon completion signal.
  *
- * \return int Returns -EINPROGRESS if "is_dout=true"; "0" if "is_dout=false"
+ * \return int Returns -EINPROGRESS or error
  */
-int send_request(struct cc_drvdata *drvdata, struct cc_crypto_req *cc_req,
-		 struct cc_hw_desc *desc, unsigned int len, bool is_dout);
+int cc_send_request(struct cc_drvdata *drvdata, struct cc_crypto_req *cc_req,
+		    struct cc_hw_desc *desc, unsigned int len,
+		    struct crypto_async_request *req);
+
+int cc_send_sync_request(struct cc_drvdata *drvdata,
+			 struct cc_crypto_req *cc_req, struct cc_hw_desc *desc,
+			 unsigned int len);
 
 int send_request_init(struct cc_drvdata *drvdata, struct cc_hw_desc *desc,
 		      unsigned int len);
-- 
2.7.4
