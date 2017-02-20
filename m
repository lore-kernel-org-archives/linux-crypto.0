From: Ryder Lee <ryder.lee@mediatek.com>
Subject: [PATCH 1/9] crypto: mediatek - rework interrupt handler
Date: Mon, 20 Feb 2017 17:26:54 +0800
Message-ID: <1487582822-30393-2-git-send-email-ryder.lee@mediatek.com>
References: <1487582822-30393-1-git-send-email-ryder.lee@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-mediatek@lists.infradead.org>,
        <linux-crypto@vger.kernel.org>, Ryder Lee <ryder.lee@mediatek.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:60433 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752460AbdBTJ1T (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Feb 2017 04:27:19 -0500
In-Reply-To: <1487582822-30393-1-git-send-email-ryder.lee@mediatek.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch removes redundant task that used to handle interrupt
from ring manager, so that the same task/handler can be shared.
It also uses aes->id and sha-id to distinguish interrupt sources.

Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
---
 drivers/crypto/mediatek/mtk-aes.c      | 73 +++++++++++-----------------------
 drivers/crypto/mediatek/mtk-platform.h |  4 ++
 drivers/crypto/mediatek/mtk-sha.c      | 73 ++++++++++------------------------
 3 files changed, 49 insertions(+), 101 deletions(-)

diff --git a/drivers/crypto/mediatek/mtk-aes.c b/drivers/crypto/mediatek/mtk-aes.c
index 3a47cdb..e67881f 100644
--- a/drivers/crypto/mediatek/mtk-aes.c
+++ b/drivers/crypto/mediatek/mtk-aes.c
@@ -1092,55 +1092,26 @@ static void mtk_aes_gcm_exit(struct crypto_aead *aead)
 	},
 };
 
-static void mtk_aes_enc_task(unsigned long data)
+static void mtk_aes_done_task(unsigned long data)
 {
-	struct mtk_cryp *cryp = (struct mtk_cryp *)data;
-	struct mtk_aes_rec *aes = cryp->aes[0];
+	struct mtk_aes_rec *aes = (struct mtk_aes_rec *)data;
+	struct mtk_cryp *cryp = aes->cryp;
 
 	mtk_aes_unmap(cryp, aes);
 	aes->resume(cryp, aes);
 }
 
-static void mtk_aes_dec_task(unsigned long data)
+static irqreturn_t mtk_aes_irq(int irq, void *dev_id)
 {
-	struct mtk_cryp *cryp = (struct mtk_cryp *)data;
-	struct mtk_aes_rec *aes = cryp->aes[1];
+	struct mtk_aes_rec *aes  = (struct mtk_aes_rec *)dev_id;
+	struct mtk_cryp *cryp = aes->cryp;
+	u32 val = mtk_aes_read(cryp, RDR_STAT(aes->id));
 
-	mtk_aes_unmap(cryp, aes);
-	aes->resume(cryp, aes);
-}
-
-static irqreturn_t mtk_aes_enc_irq(int irq, void *dev_id)
-{
-	struct mtk_cryp *cryp = (struct mtk_cryp *)dev_id;
-	struct mtk_aes_rec *aes = cryp->aes[0];
-	u32 val = mtk_aes_read(cryp, RDR_STAT(RING0));
-
-	mtk_aes_write(cryp, RDR_STAT(RING0), val);
-
-	if (likely(AES_FLAGS_BUSY & aes->flags)) {
-		mtk_aes_write(cryp, RDR_PROC_COUNT(RING0), MTK_CNT_RST);
-		mtk_aes_write(cryp, RDR_THRESH(RING0),
-			      MTK_RDR_PROC_THRESH | MTK_RDR_PROC_MODE);
-
-		tasklet_schedule(&aes->task);
-	} else {
-		dev_warn(cryp->dev, "AES interrupt when no active requests.\n");
-	}
-	return IRQ_HANDLED;
-}
-
-static irqreturn_t mtk_aes_dec_irq(int irq, void *dev_id)
-{
-	struct mtk_cryp *cryp = (struct mtk_cryp *)dev_id;
-	struct mtk_aes_rec *aes = cryp->aes[1];
-	u32 val = mtk_aes_read(cryp, RDR_STAT(RING1));
-
-	mtk_aes_write(cryp, RDR_STAT(RING1), val);
+	mtk_aes_write(cryp, RDR_STAT(aes->id), val);
 
 	if (likely(AES_FLAGS_BUSY & aes->flags)) {
-		mtk_aes_write(cryp, RDR_PROC_COUNT(RING1), MTK_CNT_RST);
-		mtk_aes_write(cryp, RDR_THRESH(RING1),
+		mtk_aes_write(cryp, RDR_PROC_COUNT(aes->id), MTK_CNT_RST);
+		mtk_aes_write(cryp, RDR_THRESH(aes->id),
 			      MTK_RDR_PROC_THRESH | MTK_RDR_PROC_MODE);
 
 		tasklet_schedule(&aes->task);
@@ -1171,14 +1142,18 @@ static int mtk_aes_record_init(struct mtk_cryp *cryp)
 		if (!aes[i]->buf)
 			goto err_cleanup;
 
-		aes[i]->id = i;
+		aes[i]->cryp = cryp;
 
 		spin_lock_init(&aes[i]->lock);
 		crypto_init_queue(&aes[i]->queue, AES_QUEUE_SIZE);
+
+		tasklet_init(&aes[i]->task, mtk_aes_done_task,
+			     (unsigned long)aes[i]);
 	}
 
-	tasklet_init(&aes[0]->task, mtk_aes_enc_task, (unsigned long)cryp);
-	tasklet_init(&aes[1]->task, mtk_aes_dec_task, (unsigned long)cryp);
+	/* Link to ring0 and ring1 respectively */
+	aes[0]->id = RING0;
+	aes[1]->id = RING1;
 
 	return 0;
 
@@ -1246,19 +1221,17 @@ int mtk_cipher_alg_register(struct mtk_cryp *cryp)
 	if (ret)
 		goto err_record;
 
-	/* Ring0 is use by encryption record */
-	ret = devm_request_irq(cryp->dev, cryp->irq[RING0], mtk_aes_enc_irq,
-			       IRQF_TRIGGER_LOW, "mtk-aes", cryp);
+	ret = devm_request_irq(cryp->dev, cryp->irq[RING0], mtk_aes_irq,
+			       0, "mtk-aes", cryp->aes[0]);
 	if (ret) {
-		dev_err(cryp->dev, "unable to request AES encryption irq.\n");
+		dev_err(cryp->dev, "unable to request AES irq.\n");
 		goto err_res;
 	}
 
-	/* Ring1 is use by decryption record */
-	ret = devm_request_irq(cryp->dev, cryp->irq[RING1], mtk_aes_dec_irq,
-			       IRQF_TRIGGER_LOW, "mtk-aes", cryp);
+	ret = devm_request_irq(cryp->dev, cryp->irq[RING1], mtk_aes_irq,
+			       0, "mtk-aes", cryp->aes[1]);
 	if (ret) {
-		dev_err(cryp->dev, "unable to request AES decryption irq.\n");
+		dev_err(cryp->dev, "unable to request AES irq.\n");
 		goto err_res;
 	}
 
diff --git a/drivers/crypto/mediatek/mtk-platform.h b/drivers/crypto/mediatek/mtk-platform.h
index ed6d871..d2a1db6 100644
--- a/drivers/crypto/mediatek/mtk-platform.h
+++ b/drivers/crypto/mediatek/mtk-platform.h
@@ -125,6 +125,7 @@ struct mtk_aes_dma {
 
 /**
  * struct mtk_aes_rec - AES operation record
+ * @cryp:	pointer to Cryptographic device
  * @queue:	crypto request queue
  * @areq:	pointer to async request
  * @task:	the tasklet is use in AES interrupt
@@ -143,6 +144,7 @@ struct mtk_aes_dma {
  * Structure used to record AES execution state.
  */
 struct mtk_aes_rec {
+	struct mtk_cryp *cryp;
 	struct crypto_queue queue;
 	struct crypto_async_request *areq;
 	struct tasklet_struct task;
@@ -166,6 +168,7 @@ struct mtk_aes_rec {
 
 /**
  * struct mtk_sha_rec - SHA operation record
+ * @cryp:	pointer to Cryptographic device
  * @queue:	crypto request queue
  * @req:	pointer to ahash request
  * @task:	the tasklet is use in SHA interrupt
@@ -176,6 +179,7 @@ struct mtk_aes_rec {
  * Structure used to record SHA execution state.
  */
 struct mtk_sha_rec {
+	struct mtk_cryp *cryp;
 	struct crypto_queue queue;
 	struct ahash_request *req;
 	struct tasklet_struct task;
diff --git a/drivers/crypto/mediatek/mtk-sha.c b/drivers/crypto/mediatek/mtk-sha.c
index 55e3805..1fb98f6 100644
--- a/drivers/crypto/mediatek/mtk-sha.c
+++ b/drivers/crypto/mediatek/mtk-sha.c
@@ -1216,60 +1216,31 @@ static void mtk_sha_cra_exit(struct crypto_tfm *tfm)
 },
 };
 
-static void mtk_sha_task0(unsigned long data)
+static void mtk_sha_done_task(unsigned long data)
 {
-	struct mtk_cryp *cryp = (struct mtk_cryp *)data;
-	struct mtk_sha_rec *sha = cryp->sha[0];
+	struct mtk_sha_rec *sha = (struct mtk_sha_rec *)data;
+	struct mtk_cryp *cryp = sha->cryp;
 
 	mtk_sha_unmap(cryp, sha);
 	mtk_sha_complete(cryp, sha);
 }
 
-static void mtk_sha_task1(unsigned long data)
+static irqreturn_t mtk_sha_irq(int irq, void *dev_id)
 {
-	struct mtk_cryp *cryp = (struct mtk_cryp *)data;
-	struct mtk_sha_rec *sha = cryp->sha[1];
+	struct mtk_sha_rec *sha = (struct mtk_sha_rec *)dev_id;
+	struct mtk_cryp *cryp = sha->cryp;
+	u32 val = mtk_sha_read(cryp, RDR_STAT(sha->id));
 
-	mtk_sha_unmap(cryp, sha);
-	mtk_sha_complete(cryp, sha);
-}
-
-static irqreturn_t mtk_sha_ring2_irq(int irq, void *dev_id)
-{
-	struct mtk_cryp *cryp = (struct mtk_cryp *)dev_id;
-	struct mtk_sha_rec *sha = cryp->sha[0];
-	u32 val = mtk_sha_read(cryp, RDR_STAT(RING2));
-
-	mtk_sha_write(cryp, RDR_STAT(RING2), val);
+	mtk_sha_write(cryp, RDR_STAT(sha->id), val);
 
 	if (likely((SHA_FLAGS_BUSY & sha->flags))) {
-		mtk_sha_write(cryp, RDR_PROC_COUNT(RING2), MTK_CNT_RST);
-		mtk_sha_write(cryp, RDR_THRESH(RING2),
+		mtk_sha_write(cryp, RDR_PROC_COUNT(sha->id), MTK_CNT_RST);
+		mtk_sha_write(cryp, RDR_THRESH(sha->id),
 			      MTK_RDR_PROC_THRESH | MTK_RDR_PROC_MODE);
 
 		tasklet_schedule(&sha->task);
 	} else {
-		dev_warn(cryp->dev, "AES interrupt when no active requests.\n");
-	}
-	return IRQ_HANDLED;
-}
-
-static irqreturn_t mtk_sha_ring3_irq(int irq, void *dev_id)
-{
-	struct mtk_cryp *cryp = (struct mtk_cryp *)dev_id;
-	struct mtk_sha_rec *sha = cryp->sha[1];
-	u32 val = mtk_sha_read(cryp, RDR_STAT(RING3));
-
-	mtk_sha_write(cryp, RDR_STAT(RING3), val);
-
-	if (likely((SHA_FLAGS_BUSY & sha->flags))) {
-		mtk_sha_write(cryp, RDR_PROC_COUNT(RING3), MTK_CNT_RST);
-		mtk_sha_write(cryp, RDR_THRESH(RING3),
-			      MTK_RDR_PROC_THRESH | MTK_RDR_PROC_MODE);
-
-		tasklet_schedule(&sha->task);
-	} else {
-		dev_warn(cryp->dev, "AES interrupt when no active requests.\n");
+		dev_warn(cryp->dev, "SHA interrupt when no active requests.\n");
 	}
 	return IRQ_HANDLED;
 }
@@ -1288,14 +1259,18 @@ static int mtk_sha_record_init(struct mtk_cryp *cryp)
 		if (!sha[i])
 			goto err_cleanup;
 
-		sha[i]->id = i + RING2;
+		sha[i]->cryp = cryp;
 
 		spin_lock_init(&sha[i]->lock);
 		crypto_init_queue(&sha[i]->queue, SHA_QUEUE_SIZE);
+
+		tasklet_init(&sha[i]->task, mtk_sha_done_task,
+			     (unsigned long)sha[i]);
 	}
 
-	tasklet_init(&sha[0]->task, mtk_sha_task0, (unsigned long)cryp);
-	tasklet_init(&sha[1]->task, mtk_sha_task1, (unsigned long)cryp);
+	/* Link to ring2 and ring3 respectively */
+	sha[0]->id = RING2;
+	sha[1]->id = RING3;
 
 	cryp->rec = 1;
 
@@ -1368,19 +1343,15 @@ int mtk_hash_alg_register(struct mtk_cryp *cryp)
 	if (err)
 		goto err_record;
 
-	/* Ring2 is use by SHA record0 */
-	err = devm_request_irq(cryp->dev, cryp->irq[RING2],
-			       mtk_sha_ring2_irq, IRQF_TRIGGER_LOW,
-			       "mtk-sha", cryp);
+	err = devm_request_irq(cryp->dev, cryp->irq[RING2], mtk_sha_irq,
+			       0, "mtk-sha", cryp->sha[0]);
 	if (err) {
 		dev_err(cryp->dev, "unable to request sha irq0.\n");
 		goto err_res;
 	}
 
-	/* Ring3 is use by SHA record1 */
-	err = devm_request_irq(cryp->dev, cryp->irq[RING3],
-			       mtk_sha_ring3_irq, IRQF_TRIGGER_LOW,
-			       "mtk-sha", cryp);
+	err = devm_request_irq(cryp->dev, cryp->irq[RING3], mtk_sha_irq,
+			       0, "mtk-sha", cryp->sha[1]);
 	if (err) {
 		dev_err(cryp->dev, "unable to request sha irq1.\n");
 		goto err_res;
-- 
1.9.1
