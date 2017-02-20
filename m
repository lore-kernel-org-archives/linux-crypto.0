From: Ryder Lee <ryder.lee@mediatek.com>
Subject: [PATCH 5/9] crypto: mediatek - add queue_task tasklet
Date: Mon, 20 Feb 2017 17:26:58 +0800
Message-ID: <1487582822-30393-6-git-send-email-ryder.lee@mediatek.com>
References: <1487582822-30393-1-git-send-email-ryder.lee@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-mediatek@lists.infradead.org>,
        <linux-crypto@vger.kernel.org>, Ryder Lee <ryder.lee@mediatek.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:60294 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752443AbdBTJ1P (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Feb 2017 04:27:15 -0500
In-Reply-To: <1487582822-30393-1-git-send-email-ryder.lee@mediatek.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds 'queue_task' to dequeue crypto requset. This will help to
avoid directly calling mtk_aes_handle_queue() / mtk_sha_handle_queue()
from done tasklet or error handler.

In order to avoid confusion, the new code properly renames DMA completion
"task" to "done_task".

Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
---
 drivers/crypto/mediatek/mtk-aes.c      | 20 ++++++++++++++++----
 drivers/crypto/mediatek/mtk-platform.h | 12 ++++++++----
 drivers/crypto/mediatek/mtk-sha.c      | 19 +++++++++++++++----
 3 files changed, 39 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/mediatek/mtk-aes.c b/drivers/crypto/mediatek/mtk-aes.c
index 21f3e59..140e9a3 100644
--- a/drivers/crypto/mediatek/mtk-aes.c
+++ b/drivers/crypto/mediatek/mtk-aes.c
@@ -533,7 +533,8 @@ static int mtk_aes_complete(struct mtk_cryp *cryp, struct mtk_aes_rec *aes)
 	aes->areq->complete(aes->areq, 0);
 
 	/* Handle new request */
-	return mtk_aes_handle_queue(cryp, aes->id, NULL);
+	tasklet_schedule(&aes->queue_task);
+	return 0;
 }
 
 static int mtk_aes_start(struct mtk_cryp *cryp, struct mtk_aes_rec *aes)
@@ -1094,6 +1095,13 @@ static void mtk_aes_gcm_exit(struct crypto_aead *aead)
 	},
 };
 
+static void mtk_aes_queue_task(unsigned long data)
+{
+	struct mtk_aes_rec *aes = (struct mtk_aes_rec *)data;
+
+	mtk_aes_handle_queue(aes->cryp, aes->id, NULL);
+}
+
 static void mtk_aes_done_task(unsigned long data)
 {
 	struct mtk_aes_rec *aes = (struct mtk_aes_rec *)data;
@@ -1116,7 +1124,7 @@ static irqreturn_t mtk_aes_irq(int irq, void *dev_id)
 		mtk_aes_write(cryp, RDR_THRESH(aes->id),
 			      MTK_RDR_PROC_THRESH | MTK_RDR_PROC_MODE);
 
-		tasklet_schedule(&aes->task);
+		tasklet_schedule(&aes->done_task);
 	} else {
 		dev_warn(cryp->dev, "AES interrupt when no active requests.\n");
 	}
@@ -1149,7 +1157,9 @@ static int mtk_aes_record_init(struct mtk_cryp *cryp)
 		spin_lock_init(&aes[i]->lock);
 		crypto_init_queue(&aes[i]->queue, AES_QUEUE_SIZE);
 
-		tasklet_init(&aes[i]->task, mtk_aes_done_task,
+		tasklet_init(&aes[i]->queue_task, mtk_aes_queue_task,
+			     (unsigned long)aes[i]);
+		tasklet_init(&aes[i]->done_task, mtk_aes_done_task,
 			     (unsigned long)aes[i]);
 	}
 
@@ -1173,7 +1183,9 @@ static void mtk_aes_record_free(struct mtk_cryp *cryp)
 	int i;
 
 	for (i = 0; i < MTK_REC_NUM; i++) {
-		tasklet_kill(&cryp->aes[i]->task);
+		tasklet_kill(&cryp->aes[i]->done_task);
+		tasklet_kill(&cryp->aes[i]->queue_task);
+
 		free_page((unsigned long)cryp->aes[i]->buf);
 		kfree(cryp->aes[i]);
 	}
diff --git a/drivers/crypto/mediatek/mtk-platform.h b/drivers/crypto/mediatek/mtk-platform.h
index 218e30d..cc98c2c 100644
--- a/drivers/crypto/mediatek/mtk-platform.h
+++ b/drivers/crypto/mediatek/mtk-platform.h
@@ -128,7 +128,8 @@ struct mtk_aes_dma {
  * @cryp:	pointer to Cryptographic device
  * @queue:	crypto request queue
  * @areq:	pointer to async request
- * @task:	the tasklet is use in AES interrupt
+ * @done_task:	the tasklet is use in AES interrupt
+ * @queue_task:	the tasklet is used to dequeue request
  * @ctx:	pointer to current context
  * @src:	the structure that holds source sg list info
  * @dst:	the structure that holds destination sg list info
@@ -147,7 +148,8 @@ struct mtk_aes_rec {
 	struct mtk_cryp *cryp;
 	struct crypto_queue queue;
 	struct crypto_async_request *areq;
-	struct tasklet_struct task;
+	struct tasklet_struct done_task;
+	struct tasklet_struct queue_task;
 	struct mtk_aes_base_ctx *ctx;
 	struct mtk_aes_dma src;
 	struct mtk_aes_dma dst;
@@ -171,7 +173,8 @@ struct mtk_aes_rec {
  * @cryp:	pointer to Cryptographic device
  * @queue:	crypto request queue
  * @req:	pointer to ahash request
- * @task:	the tasklet is use in SHA interrupt
+ * @done_task:	the tasklet is use in SHA interrupt
+ * @queue_task:	the tasklet is used to dequeue request
  * @id:		the current use of ring
  * @flags:	it's describing SHA operation state
  * @lock:	the async queue lock
@@ -182,7 +185,8 @@ struct mtk_sha_rec {
 	struct mtk_cryp *cryp;
 	struct crypto_queue queue;
 	struct ahash_request *req;
-	struct tasklet_struct task;
+	struct tasklet_struct done_task;
+	struct tasklet_struct queue_task;
 
 	u8 id;
 	unsigned long flags;
diff --git a/drivers/crypto/mediatek/mtk-sha.c b/drivers/crypto/mediatek/mtk-sha.c
index 0884d62..dd3582b 100644
--- a/drivers/crypto/mediatek/mtk-sha.c
+++ b/drivers/crypto/mediatek/mtk-sha.c
@@ -661,7 +661,7 @@ static void mtk_sha_finish_req(struct mtk_cryp *cryp,
 	sha->req->base.complete(&sha->req->base, err);
 
 	/* Handle new request */
-	mtk_sha_handle_queue(cryp, sha->id - MTK_RING2, NULL);
+	tasklet_schedule(&sha->queue_task);
 }
 
 static int mtk_sha_handle_queue(struct mtk_cryp *cryp, u8 id,
@@ -1183,6 +1183,13 @@ static void mtk_sha_cra_exit(struct crypto_tfm *tfm)
 },
 };
 
+static void mtk_sha_queue_task(unsigned long data)
+{
+	struct mtk_sha_rec *sha = (struct mtk_sha_rec *)data;
+
+	mtk_sha_handle_queue(sha->cryp, sha->id - MTK_RING2, NULL);
+}
+
 static void mtk_sha_done_task(unsigned long data)
 {
 	struct mtk_sha_rec *sha = (struct mtk_sha_rec *)data;
@@ -1205,7 +1212,7 @@ static irqreturn_t mtk_sha_irq(int irq, void *dev_id)
 		mtk_sha_write(cryp, RDR_THRESH(sha->id),
 			      MTK_RDR_PROC_THRESH | MTK_RDR_PROC_MODE);
 
-		tasklet_schedule(&sha->task);
+		tasklet_schedule(&sha->done_task);
 	} else {
 		dev_warn(cryp->dev, "SHA interrupt when no active requests.\n");
 	}
@@ -1231,7 +1238,9 @@ static int mtk_sha_record_init(struct mtk_cryp *cryp)
 		spin_lock_init(&sha[i]->lock);
 		crypto_init_queue(&sha[i]->queue, SHA_QUEUE_SIZE);
 
-		tasklet_init(&sha[i]->task, mtk_sha_done_task,
+		tasklet_init(&sha[i]->queue_task, mtk_sha_queue_task,
+			     (unsigned long)sha[i]);
+		tasklet_init(&sha[i]->done_task, mtk_sha_done_task,
 			     (unsigned long)sha[i]);
 	}
 
@@ -1254,7 +1263,9 @@ static void mtk_sha_record_free(struct mtk_cryp *cryp)
 	int i;
 
 	for (i = 0; i < MTK_REC_NUM; i++) {
-		tasklet_kill(&cryp->sha[i]->task);
+		tasklet_kill(&cryp->sha[i]->done_task);
+		tasklet_kill(&cryp->sha[i]->queue_task);
+
 		kfree(cryp->sha[i]);
 	}
 }
-- 
1.9.1
