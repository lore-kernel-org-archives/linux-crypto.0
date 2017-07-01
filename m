From: =?UTF-8?q?Simon=20Sandstr=C3=B6m?= <simon@nikanor.nu>
Subject: [PATCH 08/10] staging: ccree: Fix alignment issues in ssi_request_mgr.c
Date: Sun,  2 Jul 2017 01:25:53 +0200
Message-ID: <20170701232555.5538-9-simon@nikanor.nu>
References: <20170701232555.5538-1-simon@nikanor.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: gregkh@linuxfoundation.org, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        =?UTF-8?q?Simon=20Sandstr=C3=B6m?= <simon@nikanor.nu>
To: gilad@benyossef.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lf0-f41.google.com ([209.85.215.41]:35619 "EHLO
        mail-lf0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751976AbdGAX0h (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 1 Jul 2017 19:26:37 -0400
Received: by mail-lf0-f41.google.com with SMTP id b207so86273092lfg.2
        for <linux-crypto@vger.kernel.org>; Sat, 01 Jul 2017 16:26:36 -0700 (PDT)
In-Reply-To: <20170701232555.5538-1-simon@nikanor.nu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fixes checkpatch.pl alignment warnings.

Signed-off-by: Simon Sandström <simon@nikanor.nu>
---
 drivers/staging/ccree/ssi_request_mgr.c | 42 ++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
index 46d9396f9ff9..efdaeea0f394 100644
--- a/drivers/staging/ccree/ssi_request_mgr.c
+++ b/drivers/staging/ccree/ssi_request_mgr.c
@@ -129,7 +129,7 @@ int request_mgr_init(struct ssi_drvdata *drvdata)
 	SSI_LOG_DEBUG("hw_queue_size=0x%08X\n", req_mgr_h->hw_queue_size);
 	if (req_mgr_h->hw_queue_size < MIN_HW_QUEUE_SIZE) {
 		SSI_LOG_ERR("Invalid HW queue size = %u (Min. required is %u)\n",
-			req_mgr_h->hw_queue_size, MIN_HW_QUEUE_SIZE);
+			    req_mgr_h->hw_queue_size, MIN_HW_QUEUE_SIZE);
 		rc = -ENOMEM;
 		goto req_mgr_init_err;
 	}
@@ -177,7 +177,8 @@ static inline void enqueue_seq(
 		writel_relaxed(seq[i].word[5], (volatile void __iomem *)(cc_base + CC_REG_OFFSET(CRY_KERNEL, DSCRPTR_QUEUE_WORD0)));
 #ifdef DX_DUMP_DESCS
 		SSI_LOG_DEBUG("desc[%02d]: 0x%08X 0x%08X 0x%08X 0x%08X 0x%08X 0x%08X\n", i,
-			seq[i].word[0], seq[i].word[1], seq[i].word[2], seq[i].word[3], seq[i].word[4], seq[i].word[5]);
+			      seq[i].word[0], seq[i].word[1], seq[i].word[2],
+			      seq[i].word[3], seq[i].word[4], seq[i].word[5]);
 #endif
 	}
 }
@@ -211,7 +212,7 @@ static inline int request_mgr_queues_status_check(
 		      (MAX_REQUEST_QUEUE_SIZE - 1)) ==
 		     req_mgr_h->req_queue_tail)) {
 		SSI_LOG_ERR("SW FIFO is full. req_queue_head=%d sw_fifo_len=%d\n",
-			   req_mgr_h->req_queue_head, MAX_REQUEST_QUEUE_SIZE);
+			    req_mgr_h->req_queue_head, MAX_REQUEST_QUEUE_SIZE);
 		return -EBUSY;
 	}
 
@@ -221,9 +222,8 @@ static inline int request_mgr_queues_status_check(
 	/* Wait for space in HW queue. Poll constant num of iterations. */
 	for (poll_queue = 0; poll_queue < SSI_MAX_POLL_ITER ; poll_queue++) {
 		req_mgr_h->q_free_slots =
-			CC_HAL_READ_REGISTER(
-				CC_REG_OFFSET(CRY_KERNEL,
-						 DSCRPTR_QUEUE_CONTENT));
+			CC_HAL_READ_REGISTER(CC_REG_OFFSET(CRY_KERNEL,
+							   DSCRPTR_QUEUE_CONTENT));
 		if (unlikely(req_mgr_h->q_free_slots <
 						req_mgr_h->min_free_hw_slots)) {
 			req_mgr_h->min_free_hw_slots = req_mgr_h->q_free_slots;
@@ -235,7 +235,7 @@ static inline int request_mgr_queues_status_check(
 		}
 
 		SSI_LOG_DEBUG("HW FIFO is full. q_free_slots=%d total_seq_len=%d\n",
-			req_mgr_h->q_free_slots, total_seq_len);
+			      req_mgr_h->q_free_slots, total_seq_len);
 	}
 	/* No room in the HW queue try again later */
 	SSI_LOG_DEBUG("HW FIFO full, timeout. req_queue_head=%d "
@@ -291,9 +291,8 @@ int send_request(
 		 * in case iv gen add the max size and in case of no dout add 1
 		 * for the internal completion descriptor
 		 */
-		rc = request_mgr_queues_status_check(req_mgr_h,
-					       cc_base,
-					       max_required_seq_len);
+		rc = request_mgr_queues_status_check(req_mgr_h, cc_base,
+						     max_required_seq_len);
 		if (likely(rc == 0))
 			/* There is enough place in the queue */
 			break;
@@ -326,15 +325,16 @@ int send_request(
 
 	if (ssi_req->ivgen_dma_addr_len > 0) {
 		SSI_LOG_DEBUG("Acquire IV from pool into %d DMA addresses 0x%llX, 0x%llX, 0x%llX, IV-size=%u\n",
-			ssi_req->ivgen_dma_addr_len,
-			(unsigned long long)ssi_req->ivgen_dma_addr[0],
-			(unsigned long long)ssi_req->ivgen_dma_addr[1],
-			(unsigned long long)ssi_req->ivgen_dma_addr[2],
-			ssi_req->ivgen_size);
+			      ssi_req->ivgen_dma_addr_len,
+			      (unsigned long long)ssi_req->ivgen_dma_addr[0],
+			      (unsigned long long)ssi_req->ivgen_dma_addr[1],
+			      (unsigned long long)ssi_req->ivgen_dma_addr[2],
+			      ssi_req->ivgen_size);
 
 		/* Acquire IV from pool */
-		rc = ssi_ivgen_getiv(drvdata, ssi_req->ivgen_dma_addr, ssi_req->ivgen_dma_addr_len,
-			ssi_req->ivgen_size, iv_seq, &iv_seq_len);
+		rc = ssi_ivgen_getiv(drvdata, ssi_req->ivgen_dma_addr,
+				     ssi_req->ivgen_dma_addr_len,
+				     ssi_req->ivgen_size, iv_seq, &iv_seq_len);
 
 		if (unlikely(rc != 0)) {
 			SSI_LOG_ERR("Failed to generate IV (rc=%d)\n", rc);
@@ -418,9 +418,8 @@ int send_request_init(
 	enqueue_seq(cc_base, desc, len);
 
 	/* Update the free slots in HW queue */
-	req_mgr_h->q_free_slots = CC_HAL_READ_REGISTER(
-					CC_REG_OFFSET(CRY_KERNEL,
-					 DSCRPTR_QUEUE_CONTENT));
+	req_mgr_h->q_free_slots = CC_HAL_READ_REGISTER(CC_REG_OFFSET(CRY_KERNEL,
+								     DSCRPTR_QUEUE_CONTENT));
 
 	return 0;
 }
@@ -545,8 +544,7 @@ static void comp_handler(unsigned long devarg)
 	}
 	/* after verifing that there is nothing to do, Unmask AXI completion interrupt */
 	CC_HAL_WRITE_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_IMR),
-		CC_HAL_READ_REGISTER(
-		CC_REG_OFFSET(HOST_RGF, HOST_IMR)) & ~irq);
+			      CC_HAL_READ_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_IMR)) & ~irq);
 }
 
 /*
-- 
2.11.0
