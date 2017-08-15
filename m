From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v3 22/22] staging: ccree: remove BUG macro usage
Date: Tue, 15 Aug 2017 09:26:50 +0300
Message-ID: <1502778412-16255-23-git-send-email-gilad@benyossef.com>
References: <1502778412-16255-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1502778412-16255-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Replace BUG() macro usage that crash the kernel with alternatives
that signal error and/or try to recover.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_buffer_mgr.c  | 14 ++++++--------
 drivers/staging/ccree/ssi_cipher.c      |  1 -
 drivers/staging/ccree/ssi_pm.c          |  3 ++-
 drivers/staging/ccree/ssi_request_mgr.c | 23 +++++++++++++++++------
 4 files changed, 25 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index 051d948..6d5af50 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -86,11 +86,6 @@ static unsigned int ssi_buffer_mgr_get_sgl_nents(
 	unsigned int nents = 0;
 
 	while (nbytes != 0) {
-		if (sg_is_chain(sg_list)) {
-			SSI_LOG_ERR("Unexpected chained entry in sg (entry =0x%X)\n",
-				    nents);
-			BUG();
-		}
 		if (sg_list->length != 0) {
 			nents++;
 			/* get the number of bytes in the last entry */
@@ -861,7 +856,8 @@ static inline int ssi_buffer_mgr_aead_chain_assoc(
 			 * unexpected
 			 */			if (!current_sg) {
 				SSI_LOG_ERR("reached end of sg list. unexpected\n");
-				BUG();
+				rc = -EINVAL;
+				goto chain_assoc_exit;
 			}
 			sg_index += current_sg->length;
 			mapped_nents++;
@@ -1163,7 +1159,8 @@ static inline int ssi_buffer_mgr_aead_chain_data(
 		//if have reached the end of the sgl, then this is unexpected
 		if (!areq_ctx->src_sgl) {
 			SSI_LOG_ERR("reached end of sg list. unexpected\n");
-			BUG();
+			return -EINVAL;
+			goto chain_data_exit;
 		}
 		sg_index += areq_ctx->src_sgl->length;
 		src_mapped_nents--;
@@ -1207,7 +1204,8 @@ static inline int ssi_buffer_mgr_aead_chain_data(
 		//if have reached the end of the sgl, then this is unexpected
 		if (!areq_ctx->dst_sgl) {
 			SSI_LOG_ERR("reached end of sg list. unexpected\n");
-			BUG();
+			rc = -EINVAL;
+			goto chain_data_exit;
 		}
 		sg_index += areq_ctx->dst_sgl->length;
 		dst_mapped_nents--;
diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
index cc550b5..73ba4eb 100644
--- a/drivers/staging/ccree/ssi_cipher.c
+++ b/drivers/staging/ccree/ssi_cipher.c
@@ -543,7 +543,6 @@ ssi_blkcipher_create_setup_desc(
 		break;
 	default:
 		SSI_LOG_ERR("Unsupported cipher mode (%d)\n", cipher_mode);
-		BUG();
 	}
 }
 
diff --git a/drivers/staging/ccree/ssi_pm.c b/drivers/staging/ccree/ssi_pm.c
index 31325e6..a50671a 100644
--- a/drivers/staging/ccree/ssi_pm.c
+++ b/drivers/staging/ccree/ssi_pm.c
@@ -109,7 +109,8 @@ int ssi_power_mgr_runtime_put_suspend(struct device *dev)
 		rc = pm_runtime_put_autosuspend(dev);
 	} else {
 		/* Something wrong happens*/
-		BUG();
+		SSI_LOG_ERR("request to suspend already suspended queue");
+		rc = -EBUSY;
 	}
 	return rc;
 }
diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
index b671eff..8bf72e7 100644
--- a/drivers/staging/ccree/ssi_request_mgr.c
+++ b/drivers/staging/ccree/ssi_request_mgr.c
@@ -366,11 +366,16 @@ int send_request(
 	enqueue_seq(cc_base, &req_mgr_h->compl_desc, (is_dout ? 0 : 1));
 
 	if (unlikely(req_mgr_h->q_free_slots < total_seq_len)) {
-		/*This means that there was a problem with the resume*/
-		BUG();
+		/* This situation should never occur. Maybe indicating problem
+		 * with resuming power. Set the free slot count to 0 and hope
+		 * for the best.
+		 */
+		SSI_LOG_ERR("HW free slot count mismatch.");
+		req_mgr_h->q_free_slots = 0;
+	} else {
+		/* Update the free slots in HW queue */
+		req_mgr_h->q_free_slots -= total_seq_len;
 	}
-	/* Update the free slots in HW queue */
-	req_mgr_h->q_free_slots -= total_seq_len;
 
 	spin_unlock_bh(&req_mgr_h->hw_lock);
 
@@ -459,8 +464,13 @@ static void proc_completions(struct ssi_drvdata *drvdata)
 
 		/* Dequeue request */
 		if (unlikely(request_mgr_handle->req_queue_head == request_mgr_handle->req_queue_tail)) {
-			SSI_LOG_ERR("Request queue is empty req_queue_head==req_queue_tail==%u\n", request_mgr_handle->req_queue_head);
-			BUG();
+			/* We are supposed to handle a completion but our
+			 * queue is empty. This is not normal. Return and
+			 * hope for the best.
+			 */
+			SSI_LOG_ERR("Request queue is empty head == tail %u\n",
+				    request_mgr_handle->req_queue_head);
+			goto out;
 		}
 
 		ssi_req = &request_mgr_handle->req_queue[request_mgr_handle->req_queue_tail];
@@ -486,6 +496,7 @@ static void proc_completions(struct ssi_drvdata *drvdata)
 		request_mgr_handle->req_queue_tail = (request_mgr_handle->req_queue_tail + 1) & (MAX_REQUEST_QUEUE_SIZE - 1);
 		SSI_LOG_DEBUG("Dequeue request tail=%u\n", request_mgr_handle->req_queue_tail);
 		SSI_LOG_DEBUG("Request completed. axi_completed=%d\n", request_mgr_handle->axi_completed);
+out:
 #if defined(CONFIG_PM_RUNTIME) || defined(CONFIG_PM_SLEEP)
 		rc = ssi_power_mgr_runtime_put_suspend(&plat_dev->dev);
 		if (rc != 0)
-- 
2.1.4
