From: Ryder Lee <ryder.lee-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1 2/8] crypto: mediatek - add MTK_* prefix and correct
 annotations.
Date: Thu, 9 Mar 2017 10:11:13 +0800
Message-ID: <1489025479-48036-3-git-send-email-ryder.lee@mediatek.com>
References: <1489025479-48036-1-git-send-email-ryder.lee@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Ryder Lee <ryder.lee-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
 linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Return-path: <linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <1489025479-48036-1-git-send-email-ryder.lee-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mediatek/>
List-Post: <mailto:linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "Linux-mediatek" <linux-mediatek-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Dummy patch to add MTK_* prefix to ring enum and fix incorrect annotations.

Signed-off-by: Ryder Lee <ryder.lee-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
---
 drivers/crypto/mediatek/mtk-aes.c      | 12 ++++++------
 drivers/crypto/mediatek/mtk-platform.c | 12 ++++++------
 drivers/crypto/mediatek/mtk-platform.h | 26 +++++++++++++-------------
 drivers/crypto/mediatek/mtk-sha.c      | 14 +++++++-------
 4 files changed, 32 insertions(+), 32 deletions(-)

diff --git a/drivers/crypto/mediatek/mtk-aes.c b/drivers/crypto/mediatek/mtk-aes.c
index e67881f..b57b68f 100644
--- a/drivers/crypto/mediatek/mtk-aes.c
+++ b/drivers/crypto/mediatek/mtk-aes.c
@@ -1152,8 +1152,8 @@ static int mtk_aes_record_init(struct mtk_cryp *cryp)
 	}
 
 	/* Link to ring0 and ring1 respectively */
-	aes[0]->id = RING0;
-	aes[1]->id = RING1;
+	aes[0]->id = MTK_RING0;
+	aes[1]->id = MTK_RING1;
 
 	return 0;
 
@@ -1221,14 +1221,14 @@ int mtk_cipher_alg_register(struct mtk_cryp *cryp)
 	if (ret)
 		goto err_record;
 
-	ret = devm_request_irq(cryp->dev, cryp->irq[RING0], mtk_aes_irq,
+	ret = devm_request_irq(cryp->dev, cryp->irq[MTK_RING0], mtk_aes_irq,
 			       0, "mtk-aes", cryp->aes[0]);
 	if (ret) {
 		dev_err(cryp->dev, "unable to request AES irq.\n");
 		goto err_res;
 	}
 
-	ret = devm_request_irq(cryp->dev, cryp->irq[RING1], mtk_aes_irq,
+	ret = devm_request_irq(cryp->dev, cryp->irq[MTK_RING1], mtk_aes_irq,
 			       0, "mtk-aes", cryp->aes[1]);
 	if (ret) {
 		dev_err(cryp->dev, "unable to request AES irq.\n");
@@ -1236,8 +1236,8 @@ int mtk_cipher_alg_register(struct mtk_cryp *cryp)
 	}
 
 	/* Enable ring0 and ring1 interrupt */
-	mtk_aes_write(cryp, AIC_ENABLE_SET(RING0), MTK_IRQ_RDR0);
-	mtk_aes_write(cryp, AIC_ENABLE_SET(RING1), MTK_IRQ_RDR1);
+	mtk_aes_write(cryp, AIC_ENABLE_SET(MTK_RING0), MTK_IRQ_RDR0);
+	mtk_aes_write(cryp, AIC_ENABLE_SET(MTK_RING1), MTK_IRQ_RDR1);
 
 	spin_lock(&mtk_aes.lock);
 	list_add_tail(&cryp->aes_list, &mtk_aes.dev_list);
diff --git a/drivers/crypto/mediatek/mtk-platform.c b/drivers/crypto/mediatek/mtk-platform.c
index a9c713d..50de335 100644
--- a/drivers/crypto/mediatek/mtk-platform.c
+++ b/drivers/crypto/mediatek/mtk-platform.c
@@ -334,7 +334,7 @@ static int mtk_packet_engine_setup(struct mtk_cryp *cryp)
 	/* Enable the 4 rings for the packet engines. */
 	mtk_desc_ring_link(cryp, 0xf);
 
-	for (i = 0; i < RING_MAX; i++) {
+	for (i = 0; i < MTK_RING_MAX; i++) {
 		mtk_cmd_desc_ring_setup(cryp, i, &cap);
 		mtk_res_desc_ring_setup(cryp, i, &cap);
 	}
@@ -359,7 +359,7 @@ static int mtk_aic_cap_check(struct mtk_cryp *cryp, int hw)
 {
 	u32 val;
 
-	if (hw == RING_MAX)
+	if (hw == MTK_RING_MAX)
 		val = readl(cryp->base + AIC_G_VERSION);
 	else
 		val = readl(cryp->base + AIC_VERSION(hw));
@@ -368,7 +368,7 @@ static int mtk_aic_cap_check(struct mtk_cryp *cryp, int hw)
 	if (val != MTK_AIC_VER11 && val != MTK_AIC_VER12)
 		return -ENXIO;
 
-	if (hw == RING_MAX)
+	if (hw == MTK_RING_MAX)
 		val = readl(cryp->base + AIC_G_OPTIONS);
 	else
 		val = readl(cryp->base + AIC_OPTIONS(hw));
@@ -389,7 +389,7 @@ static int mtk_aic_init(struct mtk_cryp *cryp, int hw)
 		return err;
 
 	/* Disable all interrupts and set initial configuration */
-	if (hw == RING_MAX) {
+	if (hw == MTK_RING_MAX) {
 		writel(0, cryp->base + AIC_G_ENABLE_CTRL);
 		writel(0, cryp->base + AIC_G_POL_CTRL);
 		writel(0, cryp->base + AIC_G_TYPE_CTRL);
@@ -431,7 +431,7 @@ static void mtk_desc_dma_free(struct mtk_cryp *cryp)
 {
 	int i;
 
-	for (i = 0; i < RING_MAX; i++) {
+	for (i = 0; i < MTK_RING_MAX; i++) {
 		dma_free_coherent(cryp->dev, MTK_DESC_RING_SZ,
 				  cryp->ring[i]->res_base,
 				  cryp->ring[i]->res_dma);
@@ -447,7 +447,7 @@ static int mtk_desc_ring_alloc(struct mtk_cryp *cryp)
 	struct mtk_ring **ring = cryp->ring;
 	int i, err = ENOMEM;
 
-	for (i = 0; i < RING_MAX; i++) {
+	for (i = 0; i < MTK_RING_MAX; i++) {
 		ring[i] = kzalloc(sizeof(**ring), GFP_KERNEL);
 		if (!ring[i])
 			goto err_cleanup;
diff --git a/drivers/crypto/mediatek/mtk-platform.h b/drivers/crypto/mediatek/mtk-platform.h
index d2a1db6..3bbe9b0 100644
--- a/drivers/crypto/mediatek/mtk-platform.h
+++ b/drivers/crypto/mediatek/mtk-platform.h
@@ -38,14 +38,14 @@
  * Ring 2/3 are used by SHA.
  */
 enum {
-	RING0 = 0,
-	RING1,
-	RING2,
-	RING3,
-	RING_MAX,
+	MTK_RING0,
+	MTK_RING1,
+	MTK_RING2,
+	MTK_RING3,
+	MTK_RING_MAX
 };
 
-#define MTK_REC_NUM		(RING_MAX / 2)
+#define MTK_REC_NUM		(MTK_RING_MAX / 2)
 #define MTK_IRQ_NUM		5
 
 /**
@@ -137,7 +137,7 @@ struct mtk_aes_dma {
  * @resume:	pointer to resume function
  * @total:	request buffer length
  * @buf:	pointer to page buffer
- * @id:		record identification
+ * @id:		the current use of ring
  * @flags:	it's describing AES operation state
  * @lock:	the async queue lock
  *
@@ -172,9 +172,9 @@ struct mtk_aes_rec {
  * @queue:	crypto request queue
  * @req:	pointer to ahash request
  * @task:	the tasklet is use in SHA interrupt
- * @id:		record identification
+ * @id:		the current use of ring
  * @flags:	it's describing SHA operation state
- * @lock:	the ablkcipher queue lock
+ * @lock:	the async queue lock
  *
  * Structure used to record SHA execution state.
  */
@@ -197,9 +197,9 @@ struct mtk_sha_rec {
  * @clk_ethif:	pointer to ethif clock
  * @clk_cryp:	pointer to crypto clock
  * @irq:	global system and rings IRQ
- * @ring:	pointer to execution state of AES
- * @aes:	pointer to execution state of SHA
- * @sha:	each execution record map to a ring
+ * @ring:	pointer to descriptor rings
+ * @aes:	pointer to operation record of AES
+ * @sha:	pointer to operation record of SHA
  * @aes_list:	device list of AES
  * @sha_list:	device list of SHA
  * @tmp:	pointer to temporary buffer for internal use
@@ -215,7 +215,7 @@ struct mtk_cryp {
 	struct clk *clk_cryp;
 	int irq[MTK_IRQ_NUM];
 
-	struct mtk_ring *ring[RING_MAX];
+	struct mtk_ring *ring[MTK_RING_MAX];
 	struct mtk_aes_rec *aes[MTK_REC_NUM];
 	struct mtk_sha_rec *sha[MTK_REC_NUM];
 
diff --git a/drivers/crypto/mediatek/mtk-sha.c b/drivers/crypto/mediatek/mtk-sha.c
index 1fb98f6..b4f0c62 100644
--- a/drivers/crypto/mediatek/mtk-sha.c
+++ b/drivers/crypto/mediatek/mtk-sha.c
@@ -694,7 +694,7 @@ static void mtk_sha_finish_req(struct mtk_cryp *cryp,
 	sha->req->base.complete(&sha->req->base, err);
 
 	/* Handle new request */
-	mtk_sha_handle_queue(cryp, sha->id - RING2, NULL);
+	mtk_sha_handle_queue(cryp, sha->id - MTK_RING2, NULL);
 }
 
 static int mtk_sha_handle_queue(struct mtk_cryp *cryp, u8 id,
@@ -1269,8 +1269,8 @@ static int mtk_sha_record_init(struct mtk_cryp *cryp)
 	}
 
 	/* Link to ring2 and ring3 respectively */
-	sha[0]->id = RING2;
-	sha[1]->id = RING3;
+	sha[0]->id = MTK_RING2;
+	sha[1]->id = MTK_RING3;
 
 	cryp->rec = 1;
 
@@ -1343,14 +1343,14 @@ int mtk_hash_alg_register(struct mtk_cryp *cryp)
 	if (err)
 		goto err_record;
 
-	err = devm_request_irq(cryp->dev, cryp->irq[RING2], mtk_sha_irq,
+	err = devm_request_irq(cryp->dev, cryp->irq[MTK_RING2], mtk_sha_irq,
 			       0, "mtk-sha", cryp->sha[0]);
 	if (err) {
 		dev_err(cryp->dev, "unable to request sha irq0.\n");
 		goto err_res;
 	}
 
-	err = devm_request_irq(cryp->dev, cryp->irq[RING3], mtk_sha_irq,
+	err = devm_request_irq(cryp->dev, cryp->irq[MTK_RING3], mtk_sha_irq,
 			       0, "mtk-sha", cryp->sha[1]);
 	if (err) {
 		dev_err(cryp->dev, "unable to request sha irq1.\n");
@@ -1358,8 +1358,8 @@ int mtk_hash_alg_register(struct mtk_cryp *cryp)
 	}
 
 	/* Enable ring2 and ring3 interrupt for hash */
-	mtk_sha_write(cryp, AIC_ENABLE_SET(RING2), MTK_IRQ_RDR2);
-	mtk_sha_write(cryp, AIC_ENABLE_SET(RING3), MTK_IRQ_RDR3);
+	mtk_sha_write(cryp, AIC_ENABLE_SET(MTK_RING2), MTK_IRQ_RDR2);
+	mtk_sha_write(cryp, AIC_ENABLE_SET(MTK_RING3), MTK_IRQ_RDR3);
 
 	cryp->tmp = dma_alloc_coherent(cryp->dev, SHA_TMP_BUF_SIZE,
 					&cryp->tmp_dma, GFP_KERNEL);
-- 
1.9.1
