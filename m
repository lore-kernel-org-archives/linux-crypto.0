From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v3 8/8] staging: ccree: remove BUG macro usage
Date: Thu,  7 Sep 2017 12:00:16 +0300
Message-ID: <1504774817-11984-9-git-send-email-gilad@benyossef.com>
References: <1504774817-11984-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:57298 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755071AbdIGJBu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Sep 2017 05:01:50 -0400
In-Reply-To: <1504774817-11984-1-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Replace BUG() macro usage that crash the kernel with alternatives
that signal error and/or try to recover.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_buffer_mgr.c  | 18 ++++++------------
 drivers/staging/ccree/ssi_cipher.c      |  1 -
 drivers/staging/ccree/ssi_pm.c          |  3 ++-
 drivers/staging/ccree/ssi_request_mgr.c | 22 ++++++++++++++++------
 4 files changed, 24 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index 6393609..67c3296 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -81,11 +81,6 @@ static unsigned int ssi_buffer_mgr_get_sgl_nents(
 	unsigned int nents = 0;
 
 	while (nbytes != 0) {
-		if (sg_is_chain(sg_list)) {
-			SSI_LOG_ERR("Unexpected chained entry "
-				   "in sg (entry =0x%X)\n", nents);
-			BUG();
-		}
 		if (sg_list->length != 0) {
 			nents++;
 			/* get the number of bytes in the last entry */
@@ -854,7 +849,7 @@ static inline int ssi_buffer_mgr_aead_chain_assoc(
 			//if have reached the end of the sgl, then this is unexpected
 			if (!current_sg) {
 				SSI_LOG_ERR("reached end of sg list. unexpected\n");
-				BUG();
+				return -EINVAL;
 			}
 			sg_index += current_sg->length;
 			mapped_nents++;
@@ -1134,10 +1129,9 @@ static inline int ssi_buffer_mgr_aead_chain_data(
 
 	offset = size_to_skip;
 
-	if (!sg_data) {
-		rc = -EINVAL;
-		goto chain_data_exit;
-	}
+	if (!sg_data)
+		return -EINVAL;
+
 	areq_ctx->src_sgl = req->src;
 	areq_ctx->dst_sgl = req->dst;
 
@@ -1154,7 +1148,7 @@ static inline int ssi_buffer_mgr_aead_chain_data(
 		//if have reached the end of the sgl, then this is unexpected
 		if (!areq_ctx->src_sgl) {
 			SSI_LOG_ERR("reached end of sg list. unexpected\n");
-			BUG();
+			return -EINVAL;
 		}
 		sg_index += areq_ctx->src_sgl->length;
 		src_mapped_nents--;
@@ -1198,7 +1192,7 @@ static inline int ssi_buffer_mgr_aead_chain_data(
 		//if have reached the end of the sgl, then this is unexpected
 		if (!areq_ctx->dst_sgl) {
 			SSI_LOG_ERR("reached end of sg list. unexpected\n");
-			BUG();
+			return -EINVAL;
 		}
 		sg_index += areq_ctx->dst_sgl->length;
 		dst_mapped_nents--;
diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
index ab0349f..a462075 100644
--- a/drivers/staging/ccree/ssi_cipher.c
+++ b/drivers/staging/ccree/ssi_cipher.c
@@ -541,7 +541,6 @@ ssi_blkcipher_create_setup_desc(
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
index e5c2f92..97c2359 100644
--- a/drivers/staging/ccree/ssi_request_mgr.c
+++ b/drivers/staging/ccree/ssi_request_mgr.c
@@ -369,11 +369,16 @@ int send_request(
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
 
@@ -460,8 +465,13 @@ static void proc_completions(struct ssi_drvdata *drvdata)
 
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
+			break;
 		}
 
 		ssi_req = &request_mgr_handle->req_queue[request_mgr_handle->req_queue_tail];
-- 
2.1.4
