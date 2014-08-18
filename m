From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Subject: [PATCH 2/2] crypto: sahara - add support for SHA1/256
Date: Mon, 18 Aug 2014 15:13:39 +0200
Message-ID: <1408367619-3436-2-git-send-email-s.trumtrar@pengutronix.de>
References: <1408367619-3436-1-git-send-email-s.trumtrar@pengutronix.de>
Cc: linux-crypto@vger.kernel.org,
	Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43341 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618AbaHRNNy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 18 Aug 2014 09:13:54 -0400
In-Reply-To: <1408367619-3436-1-git-send-email-s.trumtrar@pengutronix.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add support for the MDHA unit in the SAHARA core.
The MDHA can generate hash digests for MD5 and SHA1 in version 3 and
additionally SHA224 and SHA256 in version 4.

Add the SHA1 and SHA256 algorithms to the driver.

The implementation was tested with the in-kernel testmgr on i.MX27 and
i.MX53.

Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
---
 drivers/crypto/sahara.c | 637 ++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 617 insertions(+), 20 deletions(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index 85df5b5..05be949 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -15,6 +15,10 @@
 
 #include <crypto/algapi.h>
 #include <crypto/aes.h>
+#include <crypto/hash.h>
+#include <crypto/internal/hash.h>
+#include <crypto/scatterwalk.h>
+#include <crypto/sha.h>
 
 #include <linux/clk.h>
 #include <linux/crypto.h>
@@ -27,6 +31,9 @@
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
 
+#define SHA_BUFFER_LEN		PAGE_SIZE
+#define SAHARA_MAX_SHA_BLOCK_SIZE	SHA256_BLOCK_SIZE
+
 #define SAHARA_NAME "sahara"
 #define SAHARA_VERSION_3	3
 #define SAHARA_VERSION_4	4
@@ -52,8 +59,26 @@
 #define SAHARA_HDR_CHA_MDHA		(2 << 28)
 #define SAHARA_HDR_PARITY_BIT		(1 << 31)
 
+#define SAHARA_HDR_MDHA_SET_MODE_MD_KEY	0x20880000
+#define SAHARA_HDR_MDHA_SET_MODE_HASH	0x208D0000
+#define SAHARA_HDR_MDHA_HASH		0xA0850000
+#define SAHARA_HDR_MDHA_STORE_DIGEST	0x20820000
+#define SAHARA_HDR_MDHA_ALG_SHA1	0
+#define SAHARA_HDR_MDHA_ALG_MD5		1
+#define SAHARA_HDR_MDHA_ALG_SHA256	2
+#define SAHARA_HDR_MDHA_ALG_SHA224	3
+#define SAHARA_HDR_MDHA_PDATA		(1 << 2)
+#define SAHARA_HDR_MDHA_HMAC		(1 << 3)
+#define SAHARA_HDR_MDHA_INIT		(1 << 5)
+#define SAHARA_HDR_MDHA_IPAD		(1 << 6)
+#define SAHARA_HDR_MDHA_OPAD		(1 << 7)
+#define SAHARA_HDR_MDHA_SWAP		(1 << 8)
+#define SAHARA_HDR_MDHA_MAC_FULL	(1 << 9)
+#define SAHARA_HDR_MDHA_SSL		(1 << 10)
+
 /* SAHARA can only process one request at a time */
 #define SAHARA_QUEUE_LENGTH	1
+#define SAHARA_CHANS		2
 
 #define SAHARA_REG_VERSION	0x00
 #define SAHARA_REG_DAR		0x04
@@ -121,28 +146,58 @@ struct sahara_hw_link {
 struct sahara_ctx {
 	struct sahara_dev *dev;
 	unsigned long flags;
+	unsigned int first;
+	unsigned int last;
+	unsigned int active;
+
+	/* AES-specific context */
 	int keylen;
 	u8 key[AES_KEYSIZE_128];
 	struct crypto_ablkcipher *fallback;
+
+	/* SHA-specific context */
+	struct crypto_shash *shash_fallback;
+};
+
+enum sahara_chan {
+	SAHARA_CHAN_SHA	= 0,
+	SAHARA_CHAN_AES	= 1,
 };
 
 struct sahara_aes_reqctx {
 	unsigned long mode;
 };
 
+struct sahara_sha_reqctx {
+	unsigned int mode;
+	unsigned int digest_size;
+	unsigned int context_size;
+	u8 buf[SAHARA_MAX_SHA_BLOCK_SIZE];
+	unsigned int buf_cnt;
+	unsigned int hash_rem;
+	struct sg_table data_sg;
+	struct scatterlist buf_sg;
+	unsigned int sg_in_idx;
+	unsigned int result_idx;
+};
+
 struct sahara_dev {
 	struct device		*device;
+	unsigned int		version;
 	void __iomem		*regs_base;
 	struct clk		*clk_ipg;
 	struct clk		*clk_ahb;
 
 	struct sahara_ctx	*ctx;
+	struct sahara_sha_reqctx	*rctx;
 	spinlock_t		lock;
-	struct crypto_queue	queue;
+	struct crypto_queue	queue[SAHARA_CHANS];
 	unsigned long		flags;
+	unsigned int		skha;
+	unsigned int		mdha;
 
-	struct tasklet_struct	done_task;
-	struct tasklet_struct	queue_task;
+	struct tasklet_struct	done_task[SAHARA_CHANS];
+	struct tasklet_struct	queue_task[SAHARA_CHANS];
 
 	struct sahara_hw_desc	*hw_desc[SAHARA_MAX_HW_DESC];
 	dma_addr_t		hw_phys_desc[SAHARA_MAX_HW_DESC];
@@ -153,10 +208,13 @@ struct sahara_dev {
 	u8			*iv_base;
 	dma_addr_t		iv_phys_base;
 
+	u8			*context_base;
+	dma_addr_t		context_phys_base;
+
 	struct sahara_hw_link	*hw_link[SAHARA_MAX_HW_LINK];
 	dma_addr_t		hw_phys_link[SAHARA_MAX_HW_LINK];
 
-	struct ablkcipher_request *req;
+	struct crypto_async_request *req[SAHARA_CHANS];
 	size_t			total;
 	struct scatterlist	*in_sg;
 	unsigned int		nb_in_sg;
@@ -416,9 +474,40 @@ static void sahara_aes_done_task(unsigned long data)
 	clear_bit(FLAGS_BUSY, &dev->flags);
 	spin_unlock(&dev->lock);
 
-	dev->req->base.complete(&dev->req->base, dev->error);
+	dev->skha = 0;
+	dev->req[SAHARA_CHAN_AES]->complete(dev->req[SAHARA_CHAN_AES],
+					dev->error);
 }
 
+static void sahara_sha_done_task(unsigned long data)
+{
+	struct sahara_dev *dev = (struct sahara_dev *)data;
+	struct sahara_ctx *ctx = dev->ctx;
+	struct sahara_sha_reqctx *rctx = dev->rctx;
+
+	if (rctx->sg_in_idx)
+		dma_unmap_sg(dev->device, dev->in_sg, dev->nb_in_sg,
+			DMA_TO_DEVICE);
+
+	if (ctx->last)
+		dma_unmap_single(dev->device, dev->hw_link[rctx->result_idx]->p,
+			rctx->digest_size, DMA_FROM_DEVICE);
+
+	if (rctx->hash_rem)
+		rctx->buf_cnt = rctx->hash_rem;
+	else
+		rctx->buf_cnt = 0;
+
+	spin_lock(&dev->lock);
+	clear_bit(FLAGS_BUSY, &dev->flags);
+	spin_unlock(&dev->lock);
+
+	dev->mdha = 0;
+	dev->req[SAHARA_CHAN_SHA]->complete(dev->req[SAHARA_CHAN_SHA],
+					dev->error);
+}
+
+
 static void sahara_watchdog(unsigned long data)
 {
 	struct sahara_dev *dev = (struct sahara_dev *)data;
@@ -428,7 +517,11 @@ static void sahara_watchdog(unsigned long data)
 	sahara_decode_status(dev, stat);
 	sahara_decode_error(dev, err);
 	dev->error = -ETIMEDOUT;
-	sahara_aes_done_task(data);
+
+	if (dev->skha)
+		sahara_aes_done_task(data);
+	else if (dev->mdha)
+		sahara_sha_done_task(data);
 }
 
 static int sahara_hw_descriptor_create(struct sahara_dev *dev)
@@ -540,9 +633,10 @@ static void sahara_aes_queue_task(unsigned long data)
 	struct ablkcipher_request *req;
 	int ret;
 
+
 	spin_lock(&dev->lock);
-	backlog = crypto_get_backlog(&dev->queue);
-	async_req = crypto_dequeue_request(&dev->queue);
+	backlog = crypto_get_backlog(&dev->queue[SAHARA_CHAN_AES]);
+	async_req = crypto_dequeue_request(&dev->queue[SAHARA_CHAN_AES]);
 	if (!async_req)
 		clear_bit(FLAGS_BUSY, &dev->flags);
 	spin_unlock(&dev->lock);
@@ -561,7 +655,7 @@ static void sahara_aes_queue_task(unsigned long data)
 		req->nbytes, req->src, req->dst);
 
 	/* assign new request to device */
-	dev->req = req;
+	dev->req[SAHARA_CHAN_AES] = async_req;
 	dev->total = req->nbytes;
 	dev->in_sg = req->src;
 	dev->out_sg = req->dst;
@@ -583,7 +677,8 @@ static void sahara_aes_queue_task(unsigned long data)
 		spin_lock(&dev->lock);
 		clear_bit(FLAGS_BUSY, &dev->flags);
 		spin_unlock(&dev->lock);
-		dev->req->base.complete(&dev->req->base, ret);
+		dev->req[SAHARA_CHAN_AES]->complete(dev->req[SAHARA_CHAN_AES],
+						ret);
 	}
 }
 
@@ -646,12 +741,14 @@ static int sahara_aes_crypt(struct ablkcipher_request *req, unsigned long mode)
 
 	rctx->mode = mode;
 	spin_lock_bh(&dev->lock);
-	err = ablkcipher_enqueue_request(&dev->queue, req);
+	err = ablkcipher_enqueue_request(&dev->queue[SAHARA_CHAN_AES], req);
 	busy = test_and_set_bit(FLAGS_BUSY, &dev->flags);
 	spin_unlock_bh(&dev->lock);
 
-	if (!busy)
-		tasklet_schedule(&dev->queue_task);
+	if (!busy && !dev->mdha) {
+		ctx->dev->skha = 1;
+		tasklet_schedule(&dev->queue_task[SAHARA_CHAN_AES]);
+	}
 
 	return err;
 }
@@ -754,6 +851,403 @@ static void sahara_aes_cra_exit(struct crypto_tfm *tfm)
 	ctx->fallback = NULL;
 }
 
+static u32 sahara_sha_init_hdr(struct sahara_dev *dev,
+			      struct sahara_sha_reqctx *rctx)
+{
+	struct sahara_ctx *ctx = dev->ctx;
+	u32 hdr = 0;
+
+	hdr = rctx->mode;
+
+	if (ctx->first) {
+		hdr |= SAHARA_HDR_MDHA_SET_MODE_HASH;
+		hdr |= SAHARA_HDR_MDHA_INIT;
+	} else {
+		hdr |= SAHARA_HDR_MDHA_SET_MODE_MD_KEY;
+	}
+
+	if (ctx->last)
+		hdr |= SAHARA_HDR_MDHA_PDATA;
+
+	if (hweight_long(hdr) % 2 == 0)
+		hdr |= SAHARA_HDR_PARITY_BIT;
+
+	return hdr;
+}
+
+static int sahara_hw_links_create(struct sahara_dev *dev, int start)
+{
+	struct scatterlist *sg;
+	int i, ret;
+
+	dev->nb_in_sg = sahara_sg_length(dev->in_sg, dev->total);
+	if ((dev->nb_in_sg) > SAHARA_MAX_HW_LINK) {
+		dev_err(dev->device, "not enough hw links (%d)\n",
+			dev->nb_in_sg + dev->nb_out_sg);
+		return -EINVAL;
+	}
+
+	ret = dma_map_sg(dev->device, dev->in_sg, dev->nb_in_sg,
+			 DMA_TO_DEVICE);
+	if (ret != dev->nb_in_sg) {
+		dev_err(dev->device, "couldn't map in sg\n");
+		return -EINVAL;
+	}
+
+	sg = dev->in_sg;
+	for (i = start; i < dev->nb_in_sg + start; i++) {
+		dev->hw_link[i]->len = sg->length;
+		dev->hw_link[i]->p = sg->dma_address;
+		if (i == (dev->nb_in_sg + start - 1)) {
+			dev->hw_link[i]->next = 0;
+		} else {
+			dev->hw_link[i]->next = dev->hw_phys_link[i + 1];
+			sg = sg_next(sg);
+		}
+	}
+
+	return i;
+}
+
+static int sahara_sha_hw_data_descriptor_create(struct sahara_dev *dev,
+						struct sahara_sha_reqctx *rctx,
+						struct ahash_request *req,
+						int index)
+{
+	struct sahara_ctx *ctx = dev->ctx;
+	unsigned result_len;
+	int i = index;
+
+	if (ctx->first)
+		/* Create initial descriptor: #8*/
+		dev->hw_desc[index]->hdr = sahara_sha_init_hdr(dev, rctx);
+	else
+		/* Create hash descriptor: #10. Must follow #6. */
+		dev->hw_desc[index]->hdr = SAHARA_HDR_MDHA_HASH;
+
+	dev->hw_desc[index]->len1 = dev->total;
+	if (dev->hw_desc[index]->len1 == 0) {
+		/* if len1 is 0, p1 must be 0, too */
+		dev->hw_desc[index]->p1 = 0;
+		rctx->sg_in_idx = 0;
+	} else {
+		/* Create input links */
+		dev->hw_desc[index]->p1 = dev->hw_phys_link[index];
+		i = sahara_hw_links_create(dev, index);
+
+		rctx->sg_in_idx = index;
+		if (i < 0)
+			return i;
+	}
+
+	dev->hw_desc[index]->p2 = dev->hw_phys_link[i];
+
+	if (ctx->last) {
+		/* Write the result to the ahash_request on the final call */
+		result_len = rctx->digest_size;
+		dev->hw_link[i]->p = dma_map_single(dev->device, req->result,
+						result_len, DMA_FROM_DEVICE);
+		if (dma_mapping_error(dev->device, dev->hw_link[i]->p)) {
+			dev_err(dev->device, "dma %u bytes error\n",
+				result_len);
+			goto unmap_links;
+		}
+
+		rctx->result_idx = i;
+	} else {
+		/* Save the context for the next operation */
+		result_len = rctx->context_size;
+		dev->hw_link[i]->p = dev->context_phys_base;
+	}
+
+	dev->hw_link[i]->len = result_len;
+	dev->hw_desc[index]->len2 = result_len;
+
+	dev->hw_link[i]->next = 0;
+
+	return 0;
+
+unmap_links:
+	if (rctx->sg_in_idx)
+		dma_unmap_sg(dev->device, dev->in_sg, dev->nb_in_sg, DMA_TO_DEVICE);
+
+	return -EINVAL;
+}
+
+/*
+ * Load descriptor aka #6
+ *
+ * To load a previously saved context back to the MDHA unit
+ *
+ * p1: Saved Context
+ * p2: NULL
+ *
+ */
+static int sahara_sha_hw_context_descriptor_create(struct sahara_dev *dev,
+						struct sahara_sha_reqctx *rctx,
+						struct ahash_request *req,
+						int index)
+{
+	dev->hw_desc[index]->hdr = sahara_sha_init_hdr(dev, rctx);
+
+	dev->hw_desc[index]->len1 = rctx->context_size;
+	dev->hw_desc[index]->p1 = dev->hw_phys_link[index];
+	dev->hw_desc[index]->len2 = 0;
+	dev->hw_desc[index]->p2 = 0;
+
+	dev->hw_link[index]->len = rctx->context_size;
+	dev->hw_link[index]->p = dev->context_phys_base;
+	dev->hw_link[index]->next = 0;
+
+	return 0;
+}
+
+static int sahara_sha_hw_descriptor_create(struct sahara_dev *dev,
+					   struct sahara_sha_reqctx *rctx,
+					   struct ahash_request *req)
+{
+	struct sahara_ctx *ctx = dev->ctx;
+
+	if (ctx->first) {
+		sahara_sha_hw_data_descriptor_create(dev, rctx, req, 0);
+		dev->hw_desc[0]->next = 0;
+		ctx->first = 0;
+	} else {
+		sahara_sha_hw_context_descriptor_create(dev, rctx, req, 0);
+		dev->hw_desc[0]->next = dev->hw_phys_desc[1];
+		sahara_sha_hw_data_descriptor_create(dev, rctx, req, 1);
+		dev->hw_desc[1]->next = 0;
+	}
+
+	sahara_dump_descriptors(dev);
+	sahara_dump_links(dev);
+
+	/* Start processing descriptor chain. */
+	mod_timer(&dev->watchdog,
+		  jiffies + msecs_to_jiffies(SAHARA_TIMEOUT_MS));
+	sahara_write(dev, dev->hw_phys_desc[0], SAHARA_REG_DAR);
+
+	return 0;
+}
+
+static void sahara_sha_queue_task(unsigned long data)
+{
+	struct sahara_dev *dev = (struct sahara_dev *)data;
+	struct crypto_async_request *async_req, *backlog;
+	struct sahara_ctx *ctx;
+	struct sahara_sha_reqctx *rctx;
+	struct ahash_request *req;
+	int ret;
+
+	spin_lock(&dev->lock);
+	backlog = crypto_get_backlog(&dev->queue[SAHARA_CHAN_SHA]);
+	async_req = crypto_dequeue_request(&dev->queue[SAHARA_CHAN_SHA]);
+	if (!async_req)
+		clear_bit(FLAGS_BUSY, &dev->flags);
+	spin_unlock(&dev->lock);
+
+	if (!async_req)
+		return;
+
+	if (backlog)
+		backlog->complete(backlog, -EINPROGRESS);
+
+	dev->req[SAHARA_CHAN_SHA] = async_req;
+	req = ahash_request_cast(async_req);
+	rctx = ahash_request_ctx(req);
+	ctx = crypto_tfm_ctx(req->base.tfm);
+
+	dev->ctx = ctx;
+	dev->rctx = rctx;
+
+	ret = sahara_sha_hw_descriptor_create(dev, rctx, req);
+	if (ret < 0) {
+		spin_lock(&dev->lock);
+		clear_bit(FLAGS_BUSY, &dev->flags);
+		spin_unlock(&dev->lock);
+		dev->req[SAHARA_CHAN_SHA]->complete(dev->req[SAHARA_CHAN_SHA],
+						ret);
+	}
+}
+
+static int sahara_sha_enqueue(struct ahash_request *req, int last)
+{
+	struct sahara_ctx *tctx = crypto_tfm_ctx(req->base.tfm);
+	struct sahara_dev *dev = dev_ptr;
+	int err = 0;
+	struct sahara_sha_reqctx *rctx;
+	unsigned int block_size;
+	unsigned int len;
+	int busy;
+
+	if (!req->nbytes && !last)
+		return 0;
+
+	tctx->dev = dev;
+	tctx->last = last;
+
+	if (!tctx->active) {
+		tctx->active = 1;
+		tctx->first = 1;
+	}
+
+	rctx = ahash_request_ctx(req);
+
+	block_size = 64;
+
+	len = rctx->buf_cnt + req->nbytes;
+	rctx->hash_rem = last ? 0 : len & (block_size - 1);
+
+	/*
+	 * Only the last request can be padded. All others need to be
+	 * n*block_size bytes
+	 */
+	if (!last && rctx->hash_rem) {
+		scatterwalk_map_and_copy(rctx->buf + rctx->buf_cnt, req->src,
+					req->nbytes - rctx->hash_rem,
+					rctx->hash_rem, 0);
+		rctx->buf_cnt += rctx->hash_rem;
+		req->nbytes -= rctx->hash_rem;
+
+		req->src->length -= rctx->hash_rem;
+
+		if (req->nbytes < block_size)
+			return 0;
+	}
+
+	dev->total = req->nbytes;
+
+	/* req is now multiple of block_size and can be sent */
+	if (req->nbytes >= block_size) {
+		dev->in_sg = req->src;
+	} else if (rctx->buf_cnt && req->nbytes) {
+		unsigned int sg_count;
+		struct scatterlist *sg;
+		gfp_t gfp;
+		int ret;
+
+		gfp = req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ?
+			GFP_KERNEL : GFP_ATOMIC;
+		sg_count = sg_nents(req->src) + 1;
+
+		ret = sg_alloc_table(&rctx->data_sg, sg_count, gfp);
+		if (ret)
+			return ret;
+
+		sg_init_one(&rctx->buf_sg, rctx->buf, rctx->buf_cnt);
+
+		sg = rctx->data_sg.sgl;
+
+		/* append buf_sg to empty data_sg */
+		sg_set_page(sg, sg_page(&rctx->buf_sg), rctx->buf_sg.length,
+				rctx->buf_sg.offset);
+		sg = sg_last(sg, sg_count);
+
+		/* append req->src to buf_sg */
+		sg_set_page(sg, sg_page(req->src), req->src->length,
+				req->src->offset);
+		sg_mark_end(sg);
+
+		dev->in_sg = rctx->data_sg.sgl;
+		dev->total += rctx->buf_cnt;
+
+	} else if (rctx->buf_cnt) {
+		sg_init_one(&rctx->buf_sg, rctx->buf, rctx->buf_cnt);
+		dev->in_sg = &rctx->buf_sg;
+		dev->total = rctx->buf_cnt;
+	} else {
+		dev->in_sg = req->src;
+	}
+
+	spin_lock_bh(&dev->lock);
+	err = crypto_enqueue_request(&dev->queue[SAHARA_CHAN_SHA], &req->base);
+	busy = test_and_set_bit(FLAGS_BUSY, &dev->flags);
+	spin_unlock_bh(&dev->lock);
+
+	if (!busy && !dev->skha) {
+		dev->mdha = 1;
+		tasklet_schedule(&dev->queue_task[SAHARA_CHAN_SHA]);
+	}
+
+	return -EINPROGRESS;
+}
+
+static int sahara_sha_init(struct ahash_request *req)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct sahara_ctx *tctx = crypto_tfm_ctx(crypto_ahash_tfm(tfm));
+	struct sahara_sha_reqctx *rctx = ahash_request_ctx(req);
+
+	memset(rctx, 0, sizeof(*rctx));
+
+	switch (crypto_ahash_digestsize(tfm)) {
+	case SHA1_DIGEST_SIZE:
+		rctx->mode |= SAHARA_HDR_MDHA_ALG_SHA1;
+		rctx->digest_size = SHA1_DIGEST_SIZE;
+		break;
+	case SHA256_DIGEST_SIZE:
+		rctx->mode |= SAHARA_HDR_MDHA_ALG_SHA256;
+		rctx->digest_size = SHA256_DIGEST_SIZE;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	rctx->context_size = rctx->digest_size + 4;
+	tctx->active = 0;
+
+	return 0;
+}
+
+static int sahara_sha_update(struct ahash_request *req)
+{
+	return sahara_sha_enqueue(req, 0);
+}
+
+static int sahara_sha_final(struct ahash_request *req)
+{
+	req->nbytes = 0;
+	return sahara_sha_enqueue(req, 1);
+}
+
+static int sahara_sha_finup(struct ahash_request *req)
+{
+	return sahara_sha_enqueue(req, 1);
+}
+
+static int sahara_sha_digest(struct ahash_request *req)
+{
+	sahara_sha_init(req);
+
+	return sahara_sha_finup(req);
+}
+
+static int sahara_sha_cra_init(struct crypto_tfm *tfm)
+{
+	const char *name = crypto_tfm_alg_name(tfm);
+	struct sahara_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	ctx->shash_fallback = crypto_alloc_shash(name, 0,
+					CRYPTO_ALG_NEED_FALLBACK);
+	if (IS_ERR(ctx->shash_fallback)) {
+		pr_err("Error allocating fallback algo %s\n", name);
+		return PTR_ERR(ctx->shash_fallback);
+	}
+	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
+				 sizeof(struct sahara_sha_reqctx) +
+				 SHA_BUFFER_LEN + SHA256_BLOCK_SIZE);
+
+	return 0;
+}
+
+static void sahara_sha_cra_exit(struct crypto_tfm *tfm)
+{
+	struct sahara_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	crypto_free_shash(ctx->shash_fallback);
+	ctx->shash_fallback = NULL;
+}
+
 static struct crypto_alg aes_algs[] = {
 {
 	.cra_name		= "ecb(aes)",
@@ -799,6 +1293,56 @@ static struct crypto_alg aes_algs[] = {
 }
 };
 
+static struct ahash_alg sha_v3_algs[] = {
+{
+	.init		= sahara_sha_init,
+	.update		= sahara_sha_update,
+	.final		= sahara_sha_final,
+	.finup		= sahara_sha_finup,
+	.digest		= sahara_sha_digest,
+	.halg.digestsize	= SHA1_DIGEST_SIZE,
+	.halg.base	= {
+		.cra_name		= "sha1",
+		.cra_driver_name	= "sahara-sha1",
+		.cra_priority		= 300,
+		.cra_flags		= CRYPTO_ALG_TYPE_AHASH |
+						CRYPTO_ALG_ASYNC |
+						CRYPTO_ALG_NEED_FALLBACK,
+		.cra_blocksize		= SHA1_BLOCK_SIZE,
+		.cra_ctxsize		= sizeof(struct sahara_ctx),
+		.cra_alignmask		= 0,
+		.cra_module		= THIS_MODULE,
+		.cra_init		= sahara_sha_cra_init,
+		.cra_exit		= sahara_sha_cra_exit,
+	}
+},
+};
+
+static struct ahash_alg sha_v4_algs[] = {
+{
+	.init		= sahara_sha_init,
+	.update		= sahara_sha_update,
+	.final		= sahara_sha_final,
+	.finup		= sahara_sha_finup,
+	.digest		= sahara_sha_digest,
+	.halg.digestsize	= SHA256_DIGEST_SIZE,
+	.halg.base	= {
+		.cra_name		= "sha256",
+		.cra_driver_name	= "sahara-sha256",
+		.cra_priority		= 300,
+		.cra_flags		= CRYPTO_ALG_TYPE_AHASH |
+						CRYPTO_ALG_ASYNC |
+						CRYPTO_ALG_NEED_FALLBACK,
+		.cra_blocksize		= SHA256_BLOCK_SIZE,
+		.cra_ctxsize		= sizeof(struct sahara_ctx),
+		.cra_alignmask		= 0,
+		.cra_module		= THIS_MODULE,
+		.cra_init		= sahara_sha_cra_init,
+		.cra_exit		= sahara_sha_cra_exit,
+	}
+},
+};
+
 static irqreturn_t sahara_irq_handler(int irq, void *data)
 {
 	struct sahara_dev *dev = (struct sahara_dev *)data;
@@ -821,7 +1365,10 @@ static irqreturn_t sahara_irq_handler(int irq, void *data)
 		dev->error = -EINVAL;
 	}
 
-	tasklet_schedule(&dev->done_task);
+	if (dev->skha)
+		tasklet_schedule(&dev->done_task[SAHARA_CHAN_AES]);
+	else if (dev->mdha)
+		tasklet_schedule(&dev->done_task[SAHARA_CHAN_SHA]);
 
 	return IRQ_HANDLED;
 }
@@ -829,7 +1376,7 @@ static irqreturn_t sahara_irq_handler(int irq, void *data)
 
 static int sahara_register_algs(struct sahara_dev *dev)
 {
-	int err, i, j;
+	int err, i, j, k, l;
 
 	for (i = 0; i < ARRAY_SIZE(aes_algs); i++) {
 		INIT_LIST_HEAD(&aes_algs[i].cra_list);
@@ -838,8 +1385,29 @@ static int sahara_register_algs(struct sahara_dev *dev)
 			goto err_aes_algs;
 	}
 
+	for (k = 0; k < ARRAY_SIZE(sha_v3_algs); k++) {
+		err = crypto_register_ahash(&sha_v3_algs[k]);
+		if (err)
+			goto err_sha_v3_algs;
+	}
+
+	if (dev->version > SAHARA_VERSION_3)
+		for (l = 0; l < ARRAY_SIZE(sha_v4_algs); l++) {
+			err = crypto_register_ahash(&sha_v4_algs[l]);
+			if (err)
+				goto err_sha_v4_algs;
+		}
+
 	return 0;
 
+err_sha_v4_algs:
+	for (j = 0; j < l; j++)
+		crypto_unregister_ahash(&sha_v4_algs[j]);
+
+err_sha_v3_algs:
+	for (j = 0; j < k; j++)
+		crypto_unregister_ahash(&sha_v4_algs[j]);
+
 err_aes_algs:
 	for (j = 0; j < i; j++)
 		crypto_unregister_alg(&aes_algs[j]);
@@ -853,6 +1421,13 @@ static void sahara_unregister_algs(struct sahara_dev *dev)
 
 	for (i = 0; i < ARRAY_SIZE(aes_algs); i++)
 		crypto_unregister_alg(&aes_algs[i]);
+
+	for (i = 0; i < ARRAY_SIZE(sha_v4_algs); i++)
+		crypto_unregister_ahash(&sha_v3_algs[i]);
+
+	if (dev->version > SAHARA_VERSION_3)
+		for (i = 0; i < ARRAY_SIZE(sha_v4_algs); i++)
+			crypto_unregister_ahash(&sha_v4_algs[i]);
 }
 
 static struct platform_device_id sahara_platform_ids[] = {
@@ -942,6 +1517,16 @@ static int sahara_probe(struct platform_device *pdev)
 	dev->iv_base = dev->key_base + AES_KEYSIZE_128;
 	dev->iv_phys_base = dev->key_phys_base + AES_KEYSIZE_128;
 
+	/* Allocate space for context: largest digest + message length field */
+	dev->context_base = dma_alloc_coherent(&pdev->dev,
+					SHA256_DIGEST_SIZE + 4,
+					&dev->context_phys_base, GFP_KERNEL);
+	if (!dev->context_base) {
+		dev_err(&pdev->dev, "Could not allocate memory for MDHA context\n");
+		err = -ENOMEM;
+		goto err_key;
+	}
+
 	/* Allocate space for HW links */
 	dev->hw_link[0] = dma_alloc_coherent(&pdev->dev,
 			SAHARA_MAX_HW_LINK * sizeof(struct sahara_hw_link),
@@ -957,13 +1542,18 @@ static int sahara_probe(struct platform_device *pdev)
 		dev->hw_link[i] = dev->hw_link[i - 1] + 1;
 	}
 
-	crypto_init_queue(&dev->queue, SAHARA_QUEUE_LENGTH);
+	crypto_init_queue(&dev->queue[SAHARA_CHAN_AES], SAHARA_QUEUE_LENGTH);
+	crypto_init_queue(&dev->queue[SAHARA_CHAN_SHA], SAHARA_QUEUE_LENGTH);
 
 	dev_ptr = dev;
 
-	tasklet_init(&dev->queue_task, sahara_aes_queue_task,
+	tasklet_init(&dev->queue_task[SAHARA_CHAN_AES], sahara_aes_queue_task,
+		     (unsigned long)dev);
+	tasklet_init(&dev->done_task[SAHARA_CHAN_AES], sahara_aes_done_task,
 		     (unsigned long)dev);
-	tasklet_init(&dev->done_task, sahara_aes_done_task,
+	tasklet_init(&dev->queue_task[SAHARA_CHAN_SHA], sahara_sha_queue_task,
+		     (unsigned long)dev);
+	tasklet_init(&dev->done_task[SAHARA_CHAN_SHA], sahara_sha_done_task,
 		     (unsigned long)dev);
 
 	init_timer(&dev->watchdog);
@@ -989,6 +1579,8 @@ static int sahara_probe(struct platform_device *pdev)
 		goto err_algs;
 	}
 
+	dev->version = version;
+
 	sahara_write(dev, SAHARA_CMD_RESET | SAHARA_CMD_MODE_BATCH,
 		     SAHARA_REG_CMD);
 	sahara_write(dev, SAHARA_CONTROL_SET_THROTTLE(0) |
@@ -1016,6 +1608,9 @@ err_link:
 	dma_free_coherent(&pdev->dev,
 			  2 * AES_KEYSIZE_128,
 			  dev->key_base, dev->key_phys_base);
+	dma_free_coherent(&pdev->dev,
+			  SHA256_DIGEST_SIZE,
+			  dev->context_base, dev->context_phys_base);
 err_key:
 	dma_free_coherent(&pdev->dev,
 			  SAHARA_MAX_HW_DESC * sizeof(struct sahara_hw_desc),
@@ -1038,8 +1633,10 @@ static int sahara_remove(struct platform_device *pdev)
 			  SAHARA_MAX_HW_DESC * sizeof(struct sahara_hw_desc),
 			  dev->hw_desc[0], dev->hw_phys_desc[0]);
 
-	tasklet_kill(&dev->done_task);
-	tasklet_kill(&dev->queue_task);
+	tasklet_kill(&dev->done_task[SAHARA_CHAN_AES]);
+	tasklet_kill(&dev->queue_task[SAHARA_CHAN_AES]);
+	tasklet_kill(&dev->done_task[SAHARA_CHAN_SHA]);
+	tasklet_kill(&dev->queue_task[SAHARA_CHAN_SHA]);
 
 	sahara_unregister_algs(dev);
 
-- 
2.1.0.rc1
