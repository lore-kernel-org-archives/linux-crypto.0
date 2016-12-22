From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: [PATCH v2 08/12] crypto: atmel-sha: add simple DMA transfers
Date: Thu, 22 Dec 2016 17:37:57 +0100
Message-ID: <4c438dc06f85e151dea4a42078d5e1d32d4829c1.1482424395.git.cyrille.pitchen@atmel.com>
References: <cover.1482424395.git.cyrille.pitchen@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Cyrille Pitchen <cyrille.pitchen@atmel.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <nicolas.ferre@atmel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1482424395.git.cyrille.pitchen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch adds a simple function to perform data transfer with the DMA
controller.

Signed-off-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>
---
 drivers/crypto/atmel-sha.c | 116 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 116 insertions(+)

diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index 58d9ca8ac0f2..a4fc60b67099 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -123,6 +123,9 @@ struct atmel_sha_ctx {
 struct atmel_sha_dma {
 	struct dma_chan			*chan;
 	struct dma_slave_config dma_conf;
+	struct scatterlist	*sg;
+	int			nents;
+	unsigned int		last_sg_length;
 };
 
 struct atmel_sha_dev {
@@ -1321,6 +1324,119 @@ static irqreturn_t atmel_sha_irq(int irq, void *dev_id)
 }
 
 
+/* DMA transfer functions */
+
+static bool atmel_sha_dma_check_aligned(struct atmel_sha_dev *dd,
+					struct scatterlist *sg,
+					size_t len)
+{
+	struct atmel_sha_dma *dma = &dd->dma_lch_in;
+	struct ahash_request *req = dd->req;
+	struct atmel_sha_reqctx *ctx = ahash_request_ctx(req);
+	size_t bs = ctx->block_size;
+	int nents;
+
+	for (nents = 0; sg; sg = sg_next(sg), ++nents) {
+		if (!IS_ALIGNED(sg->offset, sizeof(u32)))
+			return false;
+
+		/*
+		 * This is the last sg, the only one that is allowed to
+		 * have an unaligned length.
+		 */
+		if (len <= sg->length) {
+			dma->nents = nents + 1;
+			dma->last_sg_length = sg->length;
+			sg->length = ALIGN(len, sizeof(u32));
+			return true;
+		}
+
+		/* All other sg lengths MUST be aligned to the block size. */
+		if (!IS_ALIGNED(sg->length, bs))
+			return false;
+
+		len -= sg->length;
+	}
+
+	return false;
+}
+
+static void atmel_sha_dma_callback2(void *data)
+{
+	struct atmel_sha_dev *dd = data;
+	struct atmel_sha_dma *dma = &dd->dma_lch_in;
+	struct scatterlist *sg;
+	int nents;
+
+	dmaengine_terminate_all(dma->chan);
+	dma_unmap_sg(dd->dev, dma->sg, dma->nents, DMA_TO_DEVICE);
+
+	sg = dma->sg;
+	for (nents = 0; nents < dma->nents - 1; ++nents)
+		sg = sg_next(sg);
+	sg->length = dma->last_sg_length;
+
+	dd->is_async = true;
+	(void)atmel_sha_wait_for_data_ready(dd, dd->resume);
+}
+
+static int atmel_sha_dma_start(struct atmel_sha_dev *dd,
+			       struct scatterlist *src,
+			       size_t len,
+			       atmel_sha_fn_t resume)
+{
+	struct atmel_sha_dma *dma = &dd->dma_lch_in;
+	struct dma_slave_config *config = &dma->dma_conf;
+	struct dma_chan *chan = dma->chan;
+	struct dma_async_tx_descriptor *desc;
+	dma_cookie_t cookie;
+	unsigned int sg_len;
+	int err;
+
+	dd->resume = resume;
+
+	/*
+	 * dma->nents has already been initialized by
+	 * atmel_sha_dma_check_aligned().
+	 */
+	dma->sg = src;
+	sg_len = dma_map_sg(dd->dev, dma->sg, dma->nents, DMA_TO_DEVICE);
+	if (!sg_len) {
+		err = -ENOMEM;
+		goto exit;
+	}
+
+	config->src_maxburst = 16;
+	config->dst_maxburst = 16;
+	err = dmaengine_slave_config(chan, config);
+	if (err)
+		goto unmap_sg;
+
+	desc = dmaengine_prep_slave_sg(chan, dma->sg, sg_len, DMA_MEM_TO_DEV,
+				       DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+	if (!desc) {
+		err = -ENOMEM;
+		goto unmap_sg;
+	}
+
+	desc->callback = atmel_sha_dma_callback2;
+	desc->callback_param = dd;
+	cookie = dmaengine_submit(desc);
+	err = dma_submit_error(cookie);
+	if (err)
+		goto unmap_sg;
+
+	dma_async_issue_pending(chan);
+
+	return -EINPROGRESS;
+
+unmap_sg:
+	dma_unmap_sg(dd->dev, dma->sg, dma->nents, DMA_TO_DEVICE);
+exit:
+	return atmel_sha_complete(dd, err);
+}
+
+
 /* CPU transfer functions */
 
 static int atmel_sha_cpu_transfer(struct atmel_sha_dev *dd)
-- 
2.7.4
