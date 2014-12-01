From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Subject: [PATCH v4 4/4] crypto: sahara - add support for SHA1/256
Date: Mon,  1 Dec 2014 13:26:34 +0100
Message-ID: <1417436794-7804-5-git-send-email-s.trumtrar@pengutronix.de>
References: <1417436794-7804-1-git-send-email-s.trumtrar@pengutronix.de>
Cc: linux-crypto@vger.kernel.org, kernel@pengutronix.de,
	Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37790 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044AbaLAM0y (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Dec 2014 07:26:54 -0500
In-Reply-To: <1417436794-7804-1-git-send-email-s.trumtrar@pengutronix.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add support for the MDHA unit in the SAHARA core.
The MDHA can generate hash digests for MD5 and SHA1 in version 3 and
additionally SHA224 and SHA256 in version 4.

Add the SHA1 and SHA256 algorithms to the driver.

The implementation was tested with the in-kernel testmgr and a userspace
testprogram using AF_ALG with+without upto 128 pthreads on each AES and
SHA256 on i.MX53.

Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
---
 drivers/crypto/sahara.c | 626 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 621 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index 04d3b4309e4c..579f539e5975 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -3,6 +3,7 @@
  *
  * Support for SAHARA cryptographic accelerator.
  *
+ * Copyright (c) 2014 Steffen Trumtrar <s.trumtrar@pengutronix.de>
  * Copyright (c) 2013 Vista Silicon S.L.
  * Author: Javier Martin <javier.martin@vista-silicon.com>
  *
@@ -15,6 +16,10 @@
 
 #include <crypto/algapi.h>
 #include <crypto/aes.h>
+#include <crypto/hash.h>
+#include <crypto/internal/hash.h>
+#include <crypto/scatterwalk.h>
+#include <crypto/sha.h>
 
 #include <linux/clk.h>
 #include <linux/crypto.h>
@@ -29,6 +34,9 @@
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
 
+#define SHA_BUFFER_LEN		PAGE_SIZE
+#define SAHARA_MAX_SHA_BLOCK_SIZE	SHA256_BLOCK_SIZE
+
 #define SAHARA_NAME "sahara"
 #define SAHARA_VERSION_3	3
 #define SAHARA_VERSION_4	4
@@ -53,6 +61,23 @@
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
 
@@ -121,15 +146,58 @@ struct sahara_hw_link {
 
 struct sahara_ctx {
 	unsigned long flags;
+
+	/* AES-specific context */
 	int keylen;
 	u8 key[AES_KEYSIZE_128];
 	struct crypto_ablkcipher *fallback;
+
+	/* SHA-specific context */
+	struct crypto_shash *shash_fallback;
 };
 
 struct sahara_aes_reqctx {
 	unsigned long mode;
 };
 
+/*
+ * struct sahara_sha_reqctx - private data per request
+ * @buf: holds data for requests smaller than block_size
+ * @rembuf: used to prepare one block_size-aligned request
+ * @context: hw-specific context for request. Digest is extracted from this
+ * @mode: specifies what type of hw-descriptor needs to be built
+ * @digest_size: length of digest for this request
+ * @context_size: length of hw-context for this request.
+ *                Always digest_size + 4
+ * @buf_cnt: number of bytes saved in buf
+ * @sg_in_idx: number of hw links
+ * @in_sg: scatterlist for input data
+ * @in_sg_chain: scatterlists for chained input data
+ * @in_sg_chained: specifies if chained scatterlists are used or not
+ * @total: total number of bytes for transfer
+ * @last: is this the last block
+ * @first: is this the first block
+ * @active: inside a transfer
+ */
+struct sahara_sha_reqctx {
+	u8			buf[SAHARA_MAX_SHA_BLOCK_SIZE];
+	u8			rembuf[SAHARA_MAX_SHA_BLOCK_SIZE];
+	u8			context[SHA256_DIGEST_SIZE + 4];
+	struct mutex		mutex;
+	unsigned int		mode;
+	unsigned int		digest_size;
+	unsigned int		context_size;
+	unsigned int		buf_cnt;
+	unsigned int		sg_in_idx;
+	struct scatterlist	*in_sg;
+	struct scatterlist	in_sg_chain[2];
+	bool			in_sg_chained;
+	size_t			total;
+	unsigned int		last;
+	unsigned int		first;
+	unsigned int		active;
+};
+
 struct sahara_dev {
 	struct device		*device;
 	unsigned int		version;
@@ -154,6 +222,9 @@ struct sahara_dev {
 	u8			*iv_base;
 	dma_addr_t		iv_phys_base;
 
+	u8			*context_base;
+	dma_addr_t		context_phys_base;
+
 	struct sahara_hw_link	*hw_link[SAHARA_MAX_HW_LINK];
 	dma_addr_t		hw_phys_link[SAHARA_MAX_HW_LINK];
 
@@ -707,6 +778,316 @@ static void sahara_aes_cra_exit(struct crypto_tfm *tfm)
 	ctx->fallback = NULL;
 }
 
+static u32 sahara_sha_init_hdr(struct sahara_dev *dev,
+			      struct sahara_sha_reqctx *rctx)
+{
+	u32 hdr = 0;
+
+	hdr = rctx->mode;
+
+	if (rctx->first) {
+		hdr |= SAHARA_HDR_MDHA_SET_MODE_HASH;
+		hdr |= SAHARA_HDR_MDHA_INIT;
+	} else {
+		hdr |= SAHARA_HDR_MDHA_SET_MODE_MD_KEY;
+	}
+
+	if (rctx->last)
+		hdr |= SAHARA_HDR_MDHA_PDATA;
+
+	if (hweight_long(hdr) % 2 == 0)
+		hdr |= SAHARA_HDR_PARITY_BIT;
+
+	return hdr;
+}
+
+static int sahara_sha_hw_links_create(struct sahara_dev *dev,
+				       struct sahara_sha_reqctx *rctx,
+				       int start)
+{
+	struct scatterlist *sg;
+	unsigned int i;
+	int ret;
+
+	dev->in_sg = rctx->in_sg;
+
+	dev->nb_in_sg = sahara_sg_length(dev->in_sg, rctx->total);
+	if ((dev->nb_in_sg) > SAHARA_MAX_HW_LINK) {
+		dev_err(dev->device, "not enough hw links (%d)\n",
+			dev->nb_in_sg + dev->nb_out_sg);
+		return -EINVAL;
+	}
+
+	if (rctx->in_sg_chained) {
+		i = start;
+		sg = dev->in_sg;
+		while (sg) {
+			ret = dma_map_sg(dev->device, sg, 1,
+					 DMA_TO_DEVICE);
+			if (!ret)
+				return -EFAULT;
+
+			dev->hw_link[i]->len = sg->length;
+			dev->hw_link[i]->p = sg->dma_address;
+			dev->hw_link[i]->next = dev->hw_phys_link[i + 1];
+			sg = sg_next(sg);
+			i += 1;
+		}
+		dev->hw_link[i-1]->next = 0;
+	} else {
+		sg = dev->in_sg;
+		ret = dma_map_sg(dev->device, dev->in_sg, dev->nb_in_sg,
+				 DMA_TO_DEVICE);
+		if (!ret)
+			return -EFAULT;
+
+		for (i = start; i < dev->nb_in_sg + start; i++) {
+			dev->hw_link[i]->len = sg->length;
+			dev->hw_link[i]->p = sg->dma_address;
+			if (i == (dev->nb_in_sg + start - 1)) {
+				dev->hw_link[i]->next = 0;
+			} else {
+				dev->hw_link[i]->next = dev->hw_phys_link[i + 1];
+				sg = sg_next(sg);
+			}
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
+	unsigned result_len;
+	int i = index;
+
+	if (rctx->first)
+		/* Create initial descriptor: #8*/
+		dev->hw_desc[index]->hdr = sahara_sha_init_hdr(dev, rctx);
+	else
+		/* Create hash descriptor: #10. Must follow #6. */
+		dev->hw_desc[index]->hdr = SAHARA_HDR_MDHA_HASH;
+
+	dev->hw_desc[index]->len1 = rctx->total;
+	if (dev->hw_desc[index]->len1 == 0) {
+		/* if len1 is 0, p1 must be 0, too */
+		dev->hw_desc[index]->p1 = 0;
+		rctx->sg_in_idx = 0;
+	} else {
+		/* Create input links */
+		dev->hw_desc[index]->p1 = dev->hw_phys_link[index];
+		i = sahara_sha_hw_links_create(dev, rctx, index);
+
+		rctx->sg_in_idx = index;
+		if (i < 0)
+			return i;
+	}
+
+	dev->hw_desc[index]->p2 = dev->hw_phys_link[i];
+
+	/* Save the context for the next operation */
+	result_len = rctx->context_size;
+	dev->hw_link[i]->p = dev->context_phys_base;
+
+	dev->hw_link[i]->len = result_len;
+	dev->hw_desc[index]->len2 = result_len;
+
+	dev->hw_link[i]->next = 0;
+
+	return 0;
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
+static int sahara_walk_and_recalc(struct scatterlist *sg, unsigned int nbytes)
+{
+	if (!sg || !sg->length)
+		return nbytes;
+
+	while (nbytes && sg) {
+		if (nbytes <= sg->length) {
+			sg->length = nbytes;
+			sg_mark_end(sg);
+			break;
+		}
+		nbytes -= sg->length;
+		sg = scatterwalk_sg_next(sg);
+	}
+
+	return nbytes;
+}
+
+static int sahara_sha_prepare_request(struct ahash_request *req)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct sahara_sha_reqctx *rctx = ahash_request_ctx(req);
+	unsigned int hash_later;
+	unsigned int block_size;
+	unsigned int len;
+
+	block_size = crypto_tfm_alg_blocksize(crypto_ahash_tfm(tfm));
+
+	/* append bytes from previous operation */
+	len = rctx->buf_cnt + req->nbytes;
+
+	/* only the last transfer can be padded in hardware */
+	if (!rctx->last && (len < block_size)) {
+		/* to few data, save for next operation */
+		scatterwalk_map_and_copy(rctx->buf + rctx->buf_cnt, req->src,
+					 0, req->nbytes, 0);
+		rctx->buf_cnt += req->nbytes;
+
+		return 0;
+	}
+
+	/* add data from previous operation first */
+	if (rctx->buf_cnt)
+		memcpy(rctx->rembuf, rctx->buf, rctx->buf_cnt);
+
+	/* data must always be a multiple of block_size */
+	hash_later = rctx->last ? 0 : len & (block_size - 1);
+	if (hash_later) {
+		unsigned int offset = req->nbytes - hash_later;
+		/* Save remaining bytes for later use */
+		scatterwalk_map_and_copy(rctx->buf, req->src, offset,
+					hash_later, 0);
+	}
+
+	/* nbytes should now be multiple of blocksize */
+	req->nbytes = req->nbytes - hash_later;
+
+	sahara_walk_and_recalc(req->src, req->nbytes);
+
+	/* have data from previous operation and current */
+	if (rctx->buf_cnt && req->nbytes) {
+		sg_init_table(rctx->in_sg_chain, 2);
+		sg_set_buf(rctx->in_sg_chain, rctx->rembuf, rctx->buf_cnt);
+
+		scatterwalk_sg_chain(rctx->in_sg_chain, 2, req->src);
+
+		rctx->total = req->nbytes + rctx->buf_cnt;
+		rctx->in_sg = rctx->in_sg_chain;
+
+		rctx->in_sg_chained = true;
+		req->src = rctx->in_sg_chain;
+	/* only data from previous operation */
+	} else if (rctx->buf_cnt) {
+		if (req->src)
+			rctx->in_sg = req->src;
+		else
+			rctx->in_sg = rctx->in_sg_chain;
+		/* buf was copied into rembuf above */
+		sg_init_one(rctx->in_sg, rctx->rembuf, rctx->buf_cnt);
+		rctx->total = rctx->buf_cnt;
+		rctx->in_sg_chained = false;
+	/* no data from previous operation */
+	} else {
+		rctx->in_sg = req->src;
+		rctx->total = req->nbytes;
+		req->src = rctx->in_sg;
+		rctx->in_sg_chained = false;
+	}
+
+	/* on next call, we only have the remaining data in the buffer */
+	rctx->buf_cnt = hash_later;
+
+	return -EINPROGRESS;
+}
+
+static void sahara_sha_unmap_sg(struct sahara_dev *dev,
+				struct sahara_sha_reqctx *rctx)
+{
+	struct scatterlist *sg;
+
+	if (rctx->in_sg_chained) {
+		sg = dev->in_sg;
+		while (sg) {
+			dma_unmap_sg(dev->device, sg, 1, DMA_TO_DEVICE);
+			sg = sg_next(sg);
+		}
+	} else {
+		dma_unmap_sg(dev->device, dev->in_sg, dev->nb_in_sg,
+			DMA_TO_DEVICE);
+	}
+}
+
+static int sahara_sha_process(struct ahash_request *req)
+{
+	struct sahara_dev *dev = dev_ptr;
+	struct sahara_sha_reqctx *rctx = ahash_request_ctx(req);
+	int ret = -EINPROGRESS;
+
+	ret = sahara_sha_prepare_request(req);
+	if (!ret)
+		return ret;
+
+	if (rctx->first) {
+		sahara_sha_hw_data_descriptor_create(dev, rctx, req, 0);
+		dev->hw_desc[0]->next = 0;
+		rctx->first = 0;
+	} else {
+		memcpy(dev->context_base, rctx->context, rctx->context_size);
+
+		sahara_sha_hw_context_descriptor_create(dev, rctx, req, 0);
+		dev->hw_desc[0]->next = dev->hw_phys_desc[1];
+		sahara_sha_hw_data_descriptor_create(dev, rctx, req, 1);
+		dev->hw_desc[1]->next = 0;
+	}
+
+	sahara_dump_descriptors(dev);
+	sahara_dump_links(dev);
+
+	reinit_completion(&dev->dma_completion);
+
+	sahara_write(dev, dev->hw_phys_desc[0], SAHARA_REG_DAR);
+
+	ret = wait_for_completion_timeout(&dev->dma_completion,
+				msecs_to_jiffies(SAHARA_TIMEOUT_MS));
+	if (!ret) {
+		dev_err(dev->device, "SHA timeout\n");
+		return -ETIMEDOUT;
+	}
+
+	if (rctx->sg_in_idx)
+		sahara_sha_unmap_sg(dev, rctx);
+
+	memcpy(rctx->context, dev->context_base, rctx->context_size);
+
+	if (req->result)
+		memcpy(req->result, rctx->context, rctx->digest_size);
+
+	return 0;
+}
+
 static int sahara_queue_manage(void *data)
 {
 	struct sahara_dev *dev = (struct sahara_dev *)data;
@@ -721,10 +1102,18 @@ static int sahara_queue_manage(void *data)
 		mutex_unlock(&dev->queue_mutex);
 
 		if (async_req) {
-			struct ablkcipher_request *req =
-				ablkcipher_request_cast(async_req);
+			if (crypto_tfm_alg_type(async_req->tfm) ==
+			    CRYPTO_ALG_TYPE_AHASH) {
+				struct ahash_request *req =
+					ahash_request_cast(async_req);
+
+				ret = sahara_sha_process(req);
+			} else {
+				struct ablkcipher_request *req =
+					ablkcipher_request_cast(async_req);
 
-			ret = sahara_aes_process(req);
+				ret = sahara_aes_process(req);
+			}
 
 			async_req->complete(async_req, ret);
 
@@ -737,6 +1126,136 @@ static int sahara_queue_manage(void *data)
 	return 0;
 }
 
+static int sahara_sha_enqueue(struct ahash_request *req, int last)
+{
+	struct sahara_sha_reqctx *rctx = ahash_request_ctx(req);
+	struct sahara_dev *dev = dev_ptr;
+	int ret;
+
+	if (!req->nbytes && !last)
+		return 0;
+
+	mutex_lock(&rctx->mutex);
+	rctx->last = last;
+
+	if (!rctx->active) {
+		rctx->active = 1;
+		rctx->first = 1;
+	}
+
+	mutex_lock(&dev->queue_mutex);
+	ret = crypto_enqueue_request(&dev->queue, &req->base);
+	mutex_unlock(&dev->queue_mutex);
+
+	wake_up_process(dev->kthread);
+	mutex_unlock(&rctx->mutex);
+
+	return ret;
+}
+
+static int sahara_sha_init(struct ahash_request *req)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
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
+	rctx->active = 0;
+
+	mutex_init(&rctx->mutex);
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
+static int sahara_sha_export(struct ahash_request *req, void *out)
+{
+	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
+	struct sahara_ctx *ctx = crypto_ahash_ctx(ahash);
+	struct sahara_sha_reqctx *rctx = ahash_request_ctx(req);
+
+	memcpy(out, ctx, sizeof(struct sahara_ctx));
+	memcpy(out + sizeof(struct sahara_sha_reqctx), rctx,
+	       sizeof(struct sahara_sha_reqctx));
+
+	return 0;
+}
+
+static int sahara_sha_import(struct ahash_request *req, const void *in)
+{
+	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
+	struct sahara_ctx *ctx = crypto_ahash_ctx(ahash);
+	struct sahara_sha_reqctx *rctx = ahash_request_ctx(req);
+
+	memcpy(ctx, in, sizeof(struct sahara_ctx));
+	memcpy(rctx, in + sizeof(struct sahara_sha_reqctx),
+	       sizeof(struct sahara_sha_reqctx));
+
+	return 0;
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
@@ -782,6 +1301,60 @@ static struct crypto_alg aes_algs[] = {
 }
 };
 
+static struct ahash_alg sha_v3_algs[] = {
+{
+	.init		= sahara_sha_init,
+	.update		= sahara_sha_update,
+	.final		= sahara_sha_final,
+	.finup		= sahara_sha_finup,
+	.digest		= sahara_sha_digest,
+	.export		= sahara_sha_export,
+	.import		= sahara_sha_import,
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
+	.export		= sahara_sha_export,
+	.import		= sahara_sha_import,
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
@@ -810,7 +1383,8 @@ static irqreturn_t sahara_irq_handler(int irq, void *data)
 
 static int sahara_register_algs(struct sahara_dev *dev)
 {
-	int err, i, j;
+	int err;
+	unsigned int i, j, k, l;
 
 	for (i = 0; i < ARRAY_SIZE(aes_algs); i++) {
 		INIT_LIST_HEAD(&aes_algs[i].cra_list);
@@ -819,8 +1393,29 @@ static int sahara_register_algs(struct sahara_dev *dev)
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
@@ -830,10 +1425,17 @@ err_aes_algs:
 
 static void sahara_unregister_algs(struct sahara_dev *dev)
 {
-	int i;
+	unsigned int i;
 
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
@@ -923,6 +1525,16 @@ static int sahara_probe(struct platform_device *pdev)
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
@@ -1002,6 +1614,9 @@ err_link:
 	dma_free_coherent(&pdev->dev,
 			  2 * AES_KEYSIZE_128,
 			  dev->key_base, dev->key_phys_base);
+	dma_free_coherent(&pdev->dev,
+			  SHA256_DIGEST_SIZE,
+			  dev->context_base, dev->context_phys_base);
 err_key:
 	dma_free_coherent(&pdev->dev,
 			  SAHARA_MAX_HW_DESC * sizeof(struct sahara_hw_desc),
@@ -1051,4 +1666,5 @@ module_platform_driver(sahara_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Javier Martin <javier.martin@vista-silicon.com>");
+MODULE_AUTHOR("Steffen Trumtrar <s.trumtrar@pengutronix.de>");
 MODULE_DESCRIPTION("SAHARA2 HW crypto accelerator");
-- 
2.1.3
