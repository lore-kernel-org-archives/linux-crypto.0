From: Ryder Lee <ryder.lee@mediatek.com>
Subject: [PATCH 3/8] crypto: mediatek - make crypto request queue management more generic
Date: Fri, 20 Jan 2017 13:41:10 +0800
Message-ID: <1484890875-57105-4-git-send-email-ryder.lee@mediatek.com>
References: <1484890875-57105-1-git-send-email-ryder.lee@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Ryder Lee <ryder.lee@mediatek.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1484890875-57105-1-git-send-email-ryder.lee@mediatek.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch changes mtk_aes_handle_queue() to make it more generic.
The function argument is now a pointer to struct crypto_async_request,
which is the common base of struct ablkcipher_request and
struct aead_request.

Also this patch introduces struct mtk_aes_base_ctx which will be the
common base of all the transformation contexts.

Hence the very same queue will be used to manage both block cipher and
AEAD requests (such as gcm and authenc implemented in further patches).

Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
---
 drivers/crypto/mediatek/mtk-aes.c      | 75 ++++++++++++++++++++--------------
 drivers/crypto/mediatek/mtk-platform.h | 14 ++++---
 2 files changed, 53 insertions(+), 36 deletions(-)

diff --git a/drivers/crypto/mediatek/mtk-aes.c b/drivers/crypto/mediatek/mtk-aes.c
index b658cb9..7e5a8e0 100644
--- a/drivers/crypto/mediatek/mtk-aes.c
+++ b/drivers/crypto/mediatek/mtk-aes.c
@@ -73,9 +73,10 @@ struct mtk_aes_reqctx {
 	u64 mode;
 };
 
-struct mtk_aes_ctx {
+struct mtk_aes_base_ctx {
 	struct mtk_cryp *cryp;
 	u32 keylen;
+	mtk_aes_fn start;
 
 	struct mtk_aes_ct ct;
 	dma_addr_t ct_dma;
@@ -86,6 +87,10 @@ struct mtk_aes_ctx {
 	u32 ct_size;
 };
 
+struct mtk_aes_ctx {
+	struct mtk_aes_base_ctx	base;
+};
+
 struct mtk_aes_drv {
 	struct list_head dev_list;
 	/* Device list lock */
@@ -108,7 +113,7 @@ static inline void mtk_aes_write(struct mtk_cryp *cryp,
 	writel_relaxed(value, cryp->base + offset);
 }
 
-static struct mtk_cryp *mtk_aes_find_dev(struct mtk_aes_ctx *ctx)
+static struct mtk_cryp *mtk_aes_find_dev(struct mtk_aes_base_ctx *ctx)
 {
 	struct mtk_cryp *cryp = NULL;
 	struct mtk_cryp *tmp;
@@ -170,7 +175,8 @@ static int mtk_aes_info_map(struct mtk_cryp *cryp,
 			    struct mtk_aes_rec *aes,
 			    size_t len)
 {
-	struct mtk_aes_ctx *ctx = aes->ctx;
+	struct ablkcipher_request *req = ablkcipher_request_cast(aes->areq);
+	struct mtk_aes_base_ctx *ctx = aes->ctx;
 
 	ctx->ct_hdr = AES_CT_CTRL_HDR | cpu_to_le32(len);
 	ctx->ct.cmd[0] = AES_CMD0 | cpu_to_le32(len);
@@ -189,7 +195,7 @@ static int mtk_aes_info_map(struct mtk_cryp *cryp,
 		ctx->tfm.ctrl[0] |= AES_TFM_192BITS;
 
 	if (aes->flags & AES_FLAGS_CBC) {
-		const u32 *iv = (const u32 *)aes->req->info;
+		const u32 *iv = (const u32 *)req->info;
 		u32 *iv_state = ctx->tfm.state + ctx->keylen;
 		int i;
 
@@ -299,11 +305,10 @@ static inline void mtk_aes_restore_sg(const struct mtk_aes_dma *dma)
 	sg->length += dma->remainder;
 }
 
-static int mtk_aes_map(struct mtk_cryp *cryp, struct mtk_aes_rec *aes)
+static int mtk_aes_map(struct mtk_cryp *cryp, struct mtk_aes_rec *aes,
+		       struct scatterlist *src, struct scatterlist *dst,
+		       size_t len)
 {
-	struct scatterlist *src = aes->req->src;
-	struct scatterlist *dst = aes->req->dst;
-	size_t len = aes->req->nbytes;
 	size_t padlen = 0;
 	bool src_aligned, dst_aligned;
 
@@ -366,18 +371,17 @@ static int mtk_aes_map(struct mtk_cryp *cryp, struct mtk_aes_rec *aes)
 }
 
 static int mtk_aes_handle_queue(struct mtk_cryp *cryp, u8 id,
-				struct ablkcipher_request *req)
+				struct crypto_async_request *new_areq)
 {
 	struct mtk_aes_rec *aes = cryp->aes[id];
 	struct crypto_async_request *areq, *backlog;
-	struct mtk_aes_reqctx *rctx;
-	struct mtk_aes_ctx *ctx;
+	struct mtk_aes_base_ctx *ctx;
 	unsigned long flags;
-	int err, ret = 0;
+	int ret = 0;
 
 	spin_lock_irqsave(&aes->lock, flags);
-	if (req)
-		ret = ablkcipher_enqueue_request(&aes->queue, req);
+	if (new_areq)
+		ret = crypto_enqueue_request(&aes->queue, new_areq);
 	if (aes->flags & AES_FLAGS_BUSY) {
 		spin_unlock_irqrestore(&aes->lock, flags);
 		return ret;
@@ -394,16 +398,25 @@ static int mtk_aes_handle_queue(struct mtk_cryp *cryp, u8 id,
 	if (backlog)
 		backlog->complete(backlog, -EINPROGRESS);
 
-	req = ablkcipher_request_cast(areq);
-	ctx = crypto_ablkcipher_ctx(crypto_ablkcipher_reqtfm(req));
+	ctx = crypto_tfm_ctx(areq->tfm);
+
+	aes->areq = areq;
+	aes->ctx = ctx;
+
+	return ctx->start(cryp, aes);
+}
+
+static int mtk_aes_start(struct mtk_cryp *cryp, struct mtk_aes_rec *aes)
+{
+	struct ablkcipher_request *req = ablkcipher_request_cast(aes->areq);
+	struct mtk_aes_reqctx *rctx = ablkcipher_request_ctx(req);
+	int err;
+
 	rctx = ablkcipher_request_ctx(req);
 	rctx->mode &= AES_FLAGS_MODE_MSK;
-	/* Assign new request to device */
-	aes->req = req;
-	aes->ctx = ctx;
 	aes->flags = (aes->flags & ~AES_FLAGS_MODE_MSK) | rctx->mode;
 
-	err = mtk_aes_map(cryp, aes);
+	err = mtk_aes_map(cryp, aes, req->src, req->dst, req->nbytes);
 	if (err)
 		return err;
 
@@ -412,7 +425,7 @@ static int mtk_aes_handle_queue(struct mtk_cryp *cryp, u8 id,
 
 static void mtk_aes_unmap(struct mtk_cryp *cryp, struct mtk_aes_rec *aes)
 {
-	struct mtk_aes_ctx *ctx = aes->ctx;
+	struct mtk_aes_base_ctx *ctx = aes->ctx;
 
 	dma_unmap_single(cryp->dev, ctx->ct_dma, sizeof(ctx->ct),
 			 DMA_TO_DEVICE);
@@ -449,8 +462,7 @@ static inline void mtk_aes_complete(struct mtk_cryp *cryp,
 				    struct mtk_aes_rec *aes)
 {
 	aes->flags &= ~AES_FLAGS_BUSY;
-
-	aes->req->base.complete(&aes->req->base, 0);
+	aes->areq->complete(aes->areq, 0);
 
 	/* Handle new request */
 	mtk_aes_handle_queue(cryp, aes->id, NULL);
@@ -460,7 +472,7 @@ static inline void mtk_aes_complete(struct mtk_cryp *cryp,
 static int mtk_aes_setkey(struct crypto_ablkcipher *tfm,
 			  const u8 *key, u32 keylen)
 {
-	struct mtk_aes_ctx *ctx = crypto_ablkcipher_ctx(tfm);
+	struct mtk_aes_base_ctx *ctx = crypto_ablkcipher_ctx(tfm);
 	const u32 *key_tmp = (const u32 *)key;
 	u32 *key_state = ctx->tfm.state;
 	int i;
@@ -482,14 +494,15 @@ static int mtk_aes_setkey(struct crypto_ablkcipher *tfm,
 
 static int mtk_aes_crypt(struct ablkcipher_request *req, u64 mode)
 {
-	struct mtk_aes_ctx *ctx = crypto_ablkcipher_ctx(
-			crypto_ablkcipher_reqtfm(req));
-	struct mtk_aes_reqctx *rctx = ablkcipher_request_ctx(req);
+	struct mtk_aes_base_ctx *ctx;
+	struct mtk_aes_reqctx *rctx;
 
+	ctx = crypto_ablkcipher_ctx(crypto_ablkcipher_reqtfm(req));
+	rctx = ablkcipher_request_ctx(req);
 	rctx->mode = mode;
 
 	return mtk_aes_handle_queue(ctx->cryp,
-			!(mode & AES_FLAGS_ENCRYPT), req);
+			!(mode & AES_FLAGS_ENCRYPT), &req->base);
 }
 
 static int mtk_ecb_encrypt(struct ablkcipher_request *req)
@@ -517,14 +530,14 @@ static int mtk_aes_cra_init(struct crypto_tfm *tfm)
 	struct mtk_aes_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct mtk_cryp *cryp = NULL;
 
-	tfm->crt_ablkcipher.reqsize = sizeof(struct mtk_aes_reqctx);
-
-	cryp = mtk_aes_find_dev(ctx);
+	cryp = mtk_aes_find_dev(&ctx->base);
 	if (!cryp) {
 		pr_err("can't find crypto device\n");
 		return -ENODEV;
 	}
 
+	tfm->crt_ablkcipher.reqsize = sizeof(struct mtk_aes_reqctx);
+	ctx->base.start = mtk_aes_start;
 	return 0;
 }
 
diff --git a/drivers/crypto/mediatek/mtk-platform.h b/drivers/crypto/mediatek/mtk-platform.h
index 8c50b74..9f5210c 100644
--- a/drivers/crypto/mediatek/mtk-platform.h
+++ b/drivers/crypto/mediatek/mtk-platform.h
@@ -115,12 +115,16 @@ struct mtk_aes_dma {
 	u32 sg_len;
 };
 
-struct mtk_aes_ctx;
+struct mtk_aes_base_ctx;
+struct mtk_aes_rec;
+struct mtk_cryp;
+
+typedef int (*mtk_aes_fn)(struct mtk_cryp *cryp, struct mtk_aes_rec *aes);
 
 /**
  * struct mtk_aes_rec - AES operation record
  * @queue:	crypto request queue
- * @req:	pointer to ablkcipher request
+ * @req:	pointer to async request
  * @task:	the tasklet is use in AES interrupt
  * @ctx:	pointer to current context
  * @src:	the structure that holds source sg list info
@@ -131,15 +135,15 @@ struct mtk_aes_dma {
  * @buf:	pointer to page buffer
  * @id:		record identification
  * @flags:	it's describing AES operation state
- * @lock:	the ablkcipher queue lock
+ * @lock:	the async queue lock
  *
  * Structure used to record AES execution state.
  */
 struct mtk_aes_rec {
 	struct crypto_queue queue;
-	struct ablkcipher_request *req;
+	struct crypto_async_request *areq;
 	struct tasklet_struct task;
-	struct mtk_aes_ctx *ctx;
+	struct mtk_aes_base_ctx *ctx;
 	struct mtk_aes_dma src;
 	struct mtk_aes_dma dst;
 
-- 
1.9.1
