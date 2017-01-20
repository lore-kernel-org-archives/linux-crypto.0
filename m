From: Ryder Lee <ryder.lee-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 4/8] crypto: mediatek - rework crypto request completion
Date: Fri, 20 Jan 2017 13:41:11 +0800
Message-ID: <1484890875-57105-5-git-send-email-ryder.lee@mediatek.com>
References: <1484890875-57105-1-git-send-email-ryder.lee@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Ryder Lee <ryder.lee-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
 linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
 linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>, "David S. Miller"
 <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Return-path: <linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <1484890875-57105-1-git-send-email-ryder.lee-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
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

This patch introduces a new callback 'resume' in the struct mtk_aes_rec.
This callback is run to resume/complete the processing of the crypto
request when woken up by AES interrupts when DMA completion.

This callback will help implementing the GCM mode support in further
patches.

Signed-off-by: Ryder Lee <ryder.lee-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
---
 drivers/crypto/mediatek/mtk-aes.c      | 25 +++++++++++++------------
 drivers/crypto/mediatek/mtk-platform.h |  3 +++
 2 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/mediatek/mtk-aes.c b/drivers/crypto/mediatek/mtk-aes.c
index 7e5a8e0..9c4e468 100644
--- a/drivers/crypto/mediatek/mtk-aes.c
+++ b/drivers/crypto/mediatek/mtk-aes.c
@@ -406,6 +406,15 @@ static int mtk_aes_handle_queue(struct mtk_cryp *cryp, u8 id,
 	return ctx->start(cryp, aes);
 }
 
+static int mtk_aes_complete(struct mtk_cryp *cryp, struct mtk_aes_rec *aes)
+{
+	aes->flags &= ~AES_FLAGS_BUSY;
+	aes->areq->complete(aes->areq, 0);
+
+	/* Handle new request */
+	return mtk_aes_handle_queue(cryp, aes->id, NULL);
+}
+
 static int mtk_aes_start(struct mtk_cryp *cryp, struct mtk_aes_rec *aes)
 {
 	struct ablkcipher_request *req = ablkcipher_request_cast(aes->areq);
@@ -416,6 +425,8 @@ static int mtk_aes_start(struct mtk_cryp *cryp, struct mtk_aes_rec *aes)
 	rctx->mode &= AES_FLAGS_MODE_MSK;
 	aes->flags = (aes->flags & ~AES_FLAGS_MODE_MSK) | rctx->mode;
 
+	aes->resume = mtk_aes_complete;
+
 	err = mtk_aes_map(cryp, aes, req->src, req->dst, req->nbytes);
 	if (err)
 		return err;
@@ -458,16 +469,6 @@ static void mtk_aes_unmap(struct mtk_cryp *cryp, struct mtk_aes_rec *aes)
 				    aes->buf, aes->total);
 }
 
-static inline void mtk_aes_complete(struct mtk_cryp *cryp,
-				    struct mtk_aes_rec *aes)
-{
-	aes->flags &= ~AES_FLAGS_BUSY;
-	aes->areq->complete(aes->areq, 0);
-
-	/* Handle new request */
-	mtk_aes_handle_queue(cryp, aes->id, NULL);
-}
-
 /* Check and set the AES key to transform state buffer */
 static int mtk_aes_setkey(struct crypto_ablkcipher *tfm,
 			  const u8 *key, u32 keylen)
@@ -591,7 +592,7 @@ static void mtk_aes_enc_task(unsigned long data)
 	struct mtk_aes_rec *aes = cryp->aes[0];
 
 	mtk_aes_unmap(cryp, aes);
-	mtk_aes_complete(cryp, aes);
+	aes->resume(cryp, aes);
 }
 
 static void mtk_aes_dec_task(unsigned long data)
@@ -600,7 +601,7 @@ static void mtk_aes_dec_task(unsigned long data)
 	struct mtk_aes_rec *aes = cryp->aes[1];
 
 	mtk_aes_unmap(cryp, aes);
-	mtk_aes_complete(cryp, aes);
+	aes->resume(cryp, aes);
 }
 
 static irqreturn_t mtk_aes_enc_irq(int irq, void *dev_id)
diff --git a/drivers/crypto/mediatek/mtk-platform.h b/drivers/crypto/mediatek/mtk-platform.h
index 9f5210c..36d166b 100644
--- a/drivers/crypto/mediatek/mtk-platform.h
+++ b/drivers/crypto/mediatek/mtk-platform.h
@@ -131,6 +131,7 @@ struct mtk_aes_dma {
  * @dst:	the structure that holds destination sg list info
  * @aligned_sg:	the scatter list is use to alignment
  * @real_dst:	pointer to the destination sg list
+ * @resume:	pointer to resume function
  * @total:	request buffer length
  * @buf:	pointer to page buffer
  * @id:		record identification
@@ -150,6 +151,8 @@ struct mtk_aes_rec {
 	struct scatterlist aligned_sg;
 	struct scatterlist *real_dst;
 
+	mtk_aes_fn resume;
+
 	size_t total;
 	void *buf;
 
-- 
1.9.1
