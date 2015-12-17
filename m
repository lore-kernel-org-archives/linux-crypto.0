From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: [PATCH 16/24] crypto: atmel-aes: improve performances of data transfer
Date: Thu, 17 Dec 2015 18:13:00 +0100
Message-ID: <d1013d894c5d96fde04a0d663721fde37b009bf2.1450366831.git.cyrille.pitchen@atmel.com>
References: <cover.1450366831.git.cyrille.pitchen@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	Cyrille Pitchen <cyrille.pitchen@atmel.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<nicolas.ferre@atmel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:58659 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbbLQRMr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 17 Dec 2015 12:12:47 -0500
In-Reply-To: <cover.1450366831.git.cyrille.pitchen@atmel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch totally reworks data transfer.

1 - DMA

The new code now fully supports scatter-gather lists hence reducing the
number of interrupts in some cases. Also buffer alignments are better
managed to avoid useless copies.

2 - CPU

The new code allows to use PIO accesses even when transferring more than
one AES block, so futher patches could tune the DMA threshold
(ATMEL_AES_DMA_THRESHOLD).
Moreover, CPU transfers now have a chance to be processed synchronously,
hence reducing the latency by avoiding context switches when possible
(less interrupts to process, less scheduling of the 'done' task).
Indeed the 'DATA READY' bit is polled only one time in the Interrupt
Status Register before enabling then waiting for the associated interrupt.
In some condition, this single poll is enough as the data have already
been processed by the AES hardware and so are ready.

Signed-off-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>
---
 drivers/crypto/atmel-aes.c | 764 +++++++++++++++++++++++----------------------
 1 file changed, 386 insertions(+), 378 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 343199cfed23..9ef38eca4ae7 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -42,11 +42,16 @@
 
 #define ATMEL_AES_PRIORITY	300
 
+#define ATMEL_AES_BUFFER_ORDER	2
+#define ATMEL_AES_BUFFER_SIZE	(PAGE_SIZE << ATMEL_AES_BUFFER_ORDER)
+
 #define CFB8_BLOCK_SIZE		1
 #define CFB16_BLOCK_SIZE	2
 #define CFB32_BLOCK_SIZE	4
 #define CFB64_BLOCK_SIZE	8
 
+#define SIZE_IN_WORDS(x)	((x) >> 2)
+
 /* AES flags */
 /* Reserve bits [18:16] [14:12] [0] for mode (same as for AES_MR) */
 #define AES_FLAGS_ENCRYPT	AES_MR_CYPHER_ENC
@@ -66,7 +71,6 @@
 
 #define AES_FLAGS_INIT		BIT(2)
 #define AES_FLAGS_BUSY		BIT(3)
-#define AES_FLAGS_FAST		BIT(5)
 
 #define AES_FLAGS_PERSISTENT	(AES_FLAGS_INIT | AES_FLAGS_BUSY)
 
@@ -106,8 +110,11 @@ struct atmel_aes_reqctx {
 };
 
 struct atmel_aes_dma {
-	struct dma_chan			*chan;
-	struct dma_slave_config dma_conf;
+	struct dma_chan		*chan;
+	struct scatterlist	*sg;
+	int			nents;
+	unsigned int		remainder;
+	unsigned int		sg_len;
 };
 
 struct atmel_aes_dev {
@@ -120,6 +127,7 @@ struct atmel_aes_dev {
 
 	bool			is_async;
 	atmel_aes_fn_t		resume;
+	atmel_aes_fn_t		cpu_transfer_complete;
 
 	struct device		*dev;
 	struct clk		*iclk;
@@ -133,28 +141,17 @@ struct atmel_aes_dev {
 	struct tasklet_struct	done_task;
 	struct tasklet_struct	queue_task;
 
-	size_t	total;
-
-	struct scatterlist	*in_sg;
-	unsigned int		nb_in_sg;
-	size_t				in_offset;
-	struct scatterlist	*out_sg;
-	unsigned int		nb_out_sg;
-	size_t				out_offset;
-
-	size_t	bufcnt;
-	size_t	buflen;
-	size_t	dma_size;
+	size_t			total;
+	size_t			datalen;
+	u32			*data;
 
-	void	*buf_in;
-	int		dma_in;
-	dma_addr_t	dma_addr_in;
-	struct atmel_aes_dma	dma_lch_in;
+	struct atmel_aes_dma	src;
+	struct atmel_aes_dma	dst;
 
-	void	*buf_out;
-	int		dma_out;
-	dma_addr_t	dma_addr_out;
-	struct atmel_aes_dma	dma_lch_out;
+	size_t			buflen;
+	void			*buf;
+	struct scatterlist	aligned_sg;
+	struct scatterlist	*real_dst;
 
 	struct atmel_aes_caps	caps;
 
@@ -171,62 +168,6 @@ static struct atmel_aes_drv atmel_aes = {
 	.lock = __SPIN_LOCK_UNLOCKED(atmel_aes.lock),
 };
 
-static int atmel_aes_sg_length(struct ablkcipher_request *req,
-			struct scatterlist *sg)
-{
-	unsigned int total = req->nbytes;
-	int sg_nb;
-	unsigned int len;
-	struct scatterlist *sg_list;
-
-	sg_nb = 0;
-	sg_list = sg;
-	total = req->nbytes;
-
-	while (total) {
-		len = min(sg_list->length, total);
-
-		sg_nb++;
-		total -= len;
-
-		sg_list = sg_next(sg_list);
-		if (!sg_list)
-			total = 0;
-	}
-
-	return sg_nb;
-}
-
-static int atmel_aes_sg_copy(struct scatterlist **sg, size_t *offset,
-			void *buf, size_t buflen, size_t total, int out)
-{
-	size_t count, off = 0;
-
-	while (buflen && total) {
-		count = min((*sg)->length - *offset, total);
-		count = min(count, buflen);
-
-		if (!count)
-			return off;
-
-		scatterwalk_map_and_copy(buf + off, *sg, *offset, count, out);
-
-		off += count;
-		buflen -= count;
-		*offset += count;
-		total -= count;
-
-		if (*offset == (*sg)->length) {
-			*sg = sg_next(*sg);
-			if (*sg)
-				*offset = 0;
-			else
-				total = 0;
-		}
-	}
-
-	return off;
-}
 
 static inline u32 atmel_aes_read(struct atmel_aes_dev *dd, u32 offset)
 {
@@ -253,6 +194,37 @@ static void atmel_aes_write_n(struct atmel_aes_dev *dd, u32 offset,
 		atmel_aes_write(dd, offset, *value);
 }
 
+static inline void atmel_aes_read_block(struct atmel_aes_dev *dd, u32 offset,
+					u32 *value)
+{
+	atmel_aes_read_n(dd, offset, value, SIZE_IN_WORDS(AES_BLOCK_SIZE));
+}
+
+static inline void atmel_aes_write_block(struct atmel_aes_dev *dd, u32 offset,
+					 const u32 *value)
+{
+	atmel_aes_write_n(dd, offset, value, SIZE_IN_WORDS(AES_BLOCK_SIZE));
+}
+
+static inline int atmel_aes_wait_for_data_ready(struct atmel_aes_dev *dd,
+						atmel_aes_fn_t resume)
+{
+	u32 isr = atmel_aes_read(dd, AES_ISR);
+
+	if (unlikely(isr & AES_INT_DATARDY))
+		return resume(dd);
+
+	dd->resume = resume;
+	atmel_aes_write(dd, AES_IER, AES_INT_DATARDY);
+	return -EINPROGRESS;
+}
+
+static inline size_t atmel_aes_padlen(size_t len, size_t block_size)
+{
+	len &= block_size - 1;
+	return len ? block_size - len : 0;
+}
+
 static struct atmel_aes_dev *atmel_aes_find_dev(struct atmel_aes_base_ctx *ctx)
 {
 	struct atmel_aes_dev *aes_dd = NULL;
@@ -332,204 +304,363 @@ static inline int atmel_aes_complete(struct atmel_aes_dev *dd, int err)
 	return err;
 }
 
-static void atmel_aes_dma_callback(void *data)
+
+/* CPU transfer */
+
+static int atmel_aes_cpu_transfer(struct atmel_aes_dev *dd)
 {
-	struct atmel_aes_dev *dd = data;
+	int err = 0;
+	u32 isr;
 
-	dd->is_async = true;
-	(void)dd->resume(dd);
+	for (;;) {
+		atmel_aes_read_block(dd, AES_ODATAR(0), dd->data);
+		dd->data += 4;
+		dd->datalen -= AES_BLOCK_SIZE;
+
+		if (dd->datalen < AES_BLOCK_SIZE)
+			break;
+
+		atmel_aes_write_block(dd, AES_IDATAR(0), dd->data);
+
+		isr = atmel_aes_read(dd, AES_ISR);
+		if (!(isr & AES_INT_DATARDY)) {
+			dd->resume = atmel_aes_cpu_transfer;
+			atmel_aes_write(dd, AES_IER, AES_INT_DATARDY);
+			return -EINPROGRESS;
+		}
+	}
+
+	if (!sg_copy_from_buffer(dd->real_dst, sg_nents(dd->real_dst),
+				 dd->buf, dd->total))
+		err = -EINVAL;
+
+	if (err)
+		return atmel_aes_complete(dd, err);
+
+	return dd->cpu_transfer_complete(dd);
 }
 
-static int atmel_aes_crypt_dma(struct atmel_aes_dev *dd,
-		dma_addr_t dma_addr_in, dma_addr_t dma_addr_out, int length)
+static int atmel_aes_cpu_start(struct atmel_aes_dev *dd,
+			       struct scatterlist *src,
+			       struct scatterlist *dst,
+			       size_t len,
+			       atmel_aes_fn_t resume)
 {
-	struct scatterlist sg[2];
-	struct dma_async_tx_descriptor	*in_desc, *out_desc;
-	enum dma_slave_buswidth addr_width;
-	u32 maxburst;
+	size_t padlen = atmel_aes_padlen(len, AES_BLOCK_SIZE);
 
-	switch (dd->ctx->block_size) {
-	case CFB8_BLOCK_SIZE:
-		addr_width = DMA_SLAVE_BUSWIDTH_1_BYTE;
-		maxburst = 1;
-		break;
+	if (unlikely(len == 0))
+		return -EINVAL;
 
-	case CFB16_BLOCK_SIZE:
-		addr_width = DMA_SLAVE_BUSWIDTH_2_BYTES;
-		maxburst = 1;
-		break;
+	sg_copy_to_buffer(src, sg_nents(src), dd->buf, len);
 
-	case CFB32_BLOCK_SIZE:
-	case CFB64_BLOCK_SIZE:
-		addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
-		maxburst = 1;
-		break;
+	dd->total = len;
+	dd->real_dst = dst;
+	dd->cpu_transfer_complete = resume;
+	dd->datalen = len + padlen;
+	dd->data = (u32 *)dd->buf;
+	atmel_aes_write_block(dd, AES_IDATAR(0), dd->data);
+	return atmel_aes_wait_for_data_ready(dd, atmel_aes_cpu_transfer);
+}
 
-	case AES_BLOCK_SIZE:
-		addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
-		maxburst = dd->caps.max_burst_size;
-		break;
 
-	default:
-		return -EINVAL;
+/* DMA transfer */
+
+static void atmel_aes_dma_callback(void *data);
+
+static bool atmel_aes_check_aligned(struct atmel_aes_dev *dd,
+				    struct scatterlist *sg,
+				    size_t len,
+				    struct atmel_aes_dma *dma)
+{
+	int nents;
+
+	if (!IS_ALIGNED(len, dd->ctx->block_size))
+		return false;
+
+	for (nents = 0; sg; sg = sg_next(sg), ++nents) {
+		if (!IS_ALIGNED(sg->offset, sizeof(u32)))
+			return false;
+
+		if (len <= sg->length) {
+			if (!IS_ALIGNED(len, dd->ctx->block_size))
+				return false;
+
+			dma->nents = nents+1;
+			dma->remainder = sg->length - len;
+			sg->length = len;
+			return true;
+		}
+
+		if (!IS_ALIGNED(sg->length, dd->ctx->block_size))
+			return false;
+
+		len -= sg->length;
 	}
 
-	dd->dma_size = length;
+	return false;
+}
 
-	dma_sync_single_for_device(dd->dev, dma_addr_in, length,
-				   DMA_TO_DEVICE);
-	dma_sync_single_for_device(dd->dev, dma_addr_out, length,
-				   DMA_FROM_DEVICE);
+static inline void atmel_aes_restore_sg(const struct atmel_aes_dma *dma)
+{
+	struct scatterlist *sg = dma->sg;
+	int nents = dma->nents;
 
-	dd->dma_lch_in.dma_conf.dst_addr_width = addr_width;
-	dd->dma_lch_in.dma_conf.src_maxburst = maxburst;
-	dd->dma_lch_in.dma_conf.dst_maxburst = maxburst;
+	if (!dma->remainder)
+		return;
 
-	dd->dma_lch_out.dma_conf.src_addr_width = addr_width;
-	dd->dma_lch_out.dma_conf.src_maxburst = maxburst;
-	dd->dma_lch_out.dma_conf.dst_maxburst = maxburst;
+	while (--nents > 0 && sg)
+		sg = sg_next(sg);
 
-	dmaengine_slave_config(dd->dma_lch_in.chan, &dd->dma_lch_in.dma_conf);
-	dmaengine_slave_config(dd->dma_lch_out.chan, &dd->dma_lch_out.dma_conf);
+	if (!sg)
+		return;
 
-	sg_init_table(&sg[0], 1);
-	sg_dma_address(&sg[0]) = dma_addr_in;
-	sg_dma_len(&sg[0]) = length;
+	sg->length += dma->remainder;
+}
 
-	sg_init_table(&sg[1], 1);
-	sg_dma_address(&sg[1]) = dma_addr_out;
-	sg_dma_len(&sg[1]) = length;
+static int atmel_aes_map(struct atmel_aes_dev *dd,
+			 struct scatterlist *src,
+			 struct scatterlist *dst,
+			 size_t len)
+{
+	bool src_aligned, dst_aligned;
+	size_t padlen;
 
-	in_desc = dmaengine_prep_slave_sg(dd->dma_lch_in.chan, &sg[0],
-				1, DMA_MEM_TO_DEV,
-				DMA_PREP_INTERRUPT  |  DMA_CTRL_ACK);
-	if (!in_desc)
-		return -EINVAL;
+	dd->total = len;
+	dd->src.sg = src;
+	dd->dst.sg = dst;
+	dd->real_dst = dst;
 
-	out_desc = dmaengine_prep_slave_sg(dd->dma_lch_out.chan, &sg[1],
-				1, DMA_DEV_TO_MEM,
-				DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
-	if (!out_desc)
-		return -EINVAL;
+	src_aligned = atmel_aes_check_aligned(dd, src, len, &dd->src);
+	if (src == dst)
+		dst_aligned = src_aligned;
+	else
+		dst_aligned = atmel_aes_check_aligned(dd, dst, len, &dd->dst);
+	if (!src_aligned || !dst_aligned) {
+		padlen = atmel_aes_padlen(len, dd->ctx->block_size);
+
+		if (dd->buflen < len + padlen)
+			return -ENOMEM;
+
+		if (!src_aligned) {
+			sg_copy_to_buffer(src, sg_nents(src), dd->buf, len);
+			dd->src.sg = &dd->aligned_sg;
+			dd->src.nents = 1;
+			dd->src.remainder = 0;
+		}
 
-	out_desc->callback = atmel_aes_dma_callback;
-	out_desc->callback_param = dd;
+		if (!dst_aligned) {
+			dd->dst.sg = &dd->aligned_sg;
+			dd->dst.nents = 1;
+			dd->dst.remainder = 0;
+		}
 
-	dmaengine_submit(out_desc);
-	dma_async_issue_pending(dd->dma_lch_out.chan);
+		sg_init_table(&dd->aligned_sg, 1);
+		sg_set_buf(&dd->aligned_sg, dd->buf, len + padlen);
+	}
 
-	dmaengine_submit(in_desc);
-	dma_async_issue_pending(dd->dma_lch_in.chan);
+	if (dd->src.sg == dd->dst.sg) {
+		dd->src.sg_len = dma_map_sg(dd->dev, dd->src.sg, dd->src.nents,
+					    DMA_BIDIRECTIONAL);
+		dd->dst.sg_len = dd->src.sg_len;
+		if (!dd->src.sg_len)
+			return -EFAULT;
+	} else {
+		dd->src.sg_len = dma_map_sg(dd->dev, dd->src.sg, dd->src.nents,
+					    DMA_TO_DEVICE);
+		if (!dd->src.sg_len)
+			return -EFAULT;
+
+		dd->dst.sg_len = dma_map_sg(dd->dev, dd->dst.sg, dd->dst.nents,
+					    DMA_FROM_DEVICE);
+		if (!dd->dst.sg_len) {
+			dma_unmap_sg(dd->dev, dd->src.sg, dd->src.nents,
+				     DMA_TO_DEVICE);
+			return -EFAULT;
+		}
+	}
 
 	return 0;
 }
 
-static int atmel_aes_cpu_complete(struct atmel_aes_dev *dd);
-
-static int atmel_aes_crypt_cpu_start(struct atmel_aes_dev *dd)
+static void atmel_aes_unmap(struct atmel_aes_dev *dd)
 {
-	struct ablkcipher_request *req = ablkcipher_request_cast(dd->areq);
+	if (dd->src.sg == dd->dst.sg) {
+		dma_unmap_sg(dd->dev, dd->src.sg, dd->src.nents,
+			     DMA_BIDIRECTIONAL);
 
-	dma_sync_single_for_cpu(dd->dev, dd->dma_addr_in,
-				dd->dma_size, DMA_TO_DEVICE);
-	dma_sync_single_for_cpu(dd->dev, dd->dma_addr_out,
-				dd->dma_size, DMA_FROM_DEVICE);
+		if (dd->src.sg != &dd->aligned_sg)
+			atmel_aes_restore_sg(&dd->src);
+	} else {
+		dma_unmap_sg(dd->dev, dd->dst.sg, dd->dst.nents,
+			     DMA_FROM_DEVICE);
 
-	/* use cache buffers */
-	dd->nb_in_sg = atmel_aes_sg_length(req, dd->in_sg);
-	if (!dd->nb_in_sg)
-		return -EINVAL;
+		if (dd->dst.sg != &dd->aligned_sg)
+			atmel_aes_restore_sg(&dd->dst);
 
-	dd->nb_out_sg = atmel_aes_sg_length(req, dd->out_sg);
-	if (!dd->nb_out_sg)
-		return -EINVAL;
+		dma_unmap_sg(dd->dev, dd->src.sg, dd->src.nents,
+			     DMA_TO_DEVICE);
+
+		if (dd->src.sg != &dd->aligned_sg)
+			atmel_aes_restore_sg(&dd->src);
+	}
+
+	if (dd->dst.sg == &dd->aligned_sg)
+		sg_copy_from_buffer(dd->real_dst, sg_nents(dd->real_dst),
+				    dd->buf, dd->total);
+}
 
-	dd->bufcnt = sg_copy_to_buffer(dd->in_sg, dd->nb_in_sg,
-					dd->buf_in, dd->total);
+static int atmel_aes_dma_transfer_start(struct atmel_aes_dev *dd,
+					enum dma_slave_buswidth addr_width,
+					enum dma_transfer_direction dir,
+					u32 maxburst)
+{
+	struct dma_async_tx_descriptor *desc;
+	struct dma_slave_config config;
+	dma_async_tx_callback callback;
+	struct atmel_aes_dma *dma;
+	int err;
+
+	memset(&config, 0, sizeof(config));
+	config.direction = dir;
+	config.src_addr_width = addr_width;
+	config.dst_addr_width = addr_width;
+	config.src_maxburst = maxburst;
+	config.dst_maxburst = maxburst;
+
+	switch (dir) {
+	case DMA_MEM_TO_DEV:
+		dma = &dd->src;
+		callback = NULL;
+		config.dst_addr = dd->phys_base + AES_IDATAR(0);
+		break;
 
-	if (!dd->bufcnt)
+	case DMA_DEV_TO_MEM:
+		dma = &dd->dst;
+		callback = atmel_aes_dma_callback;
+		config.src_addr = dd->phys_base + AES_ODATAR(0);
+		break;
+
+	default:
 		return -EINVAL;
+	}
 
-	dd->total -= dd->bufcnt;
+	err = dmaengine_slave_config(dma->chan, &config);
+	if (err)
+		return err;
 
-	atmel_aes_write(dd, AES_IER, AES_INT_DATARDY);
-	atmel_aes_write_n(dd, AES_IDATAR(0), (u32 *) dd->buf_in,
-				dd->bufcnt >> 2);
+	desc = dmaengine_prep_slave_sg(dma->chan, dma->sg, dma->sg_len, dir,
+				       DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+	if (!desc)
+		return -ENOMEM;
 
-	dd->resume = atmel_aes_cpu_complete;
-	return -EINPROGRESS;
-}
+	desc->callback = callback;
+	desc->callback_param = dd;
+	dmaengine_submit(desc);
+	dma_async_issue_pending(dma->chan);
 
-static int atmel_aes_dma_complete(struct atmel_aes_dev *dd);
+	return 0;
+}
 
-static int atmel_aes_crypt_dma_start(struct atmel_aes_dev *dd)
+static void atmel_aes_dma_transfer_stop(struct atmel_aes_dev *dd,
+					enum dma_transfer_direction dir)
 {
-	int err, fast = 0, in, out;
-	size_t count;
-	dma_addr_t addr_in, addr_out;
+	struct atmel_aes_dma *dma;
 
-	if ((!dd->in_offset) && (!dd->out_offset)) {
-		/* check for alignment */
-		in = IS_ALIGNED((u32)dd->in_sg->offset, sizeof(u32)) &&
-			IS_ALIGNED(dd->in_sg->length, dd->ctx->block_size);
-		out = IS_ALIGNED((u32)dd->out_sg->offset, sizeof(u32)) &&
-			IS_ALIGNED(dd->out_sg->length, dd->ctx->block_size);
-		fast = in && out;
+	switch (dir) {
+	case DMA_MEM_TO_DEV:
+		dma = &dd->src;
+		break;
+
+	case DMA_DEV_TO_MEM:
+		dma = &dd->dst;
+		break;
 
-		if (sg_dma_len(dd->in_sg) != sg_dma_len(dd->out_sg))
-			fast = 0;
+	default:
+		return;
 	}
 
+	dmaengine_terminate_all(dma->chan);
+}
 
-	if (fast)  {
-		count = min_t(size_t, dd->total, sg_dma_len(dd->in_sg));
-		count = min_t(size_t, count, sg_dma_len(dd->out_sg));
+static int atmel_aes_dma_start(struct atmel_aes_dev *dd,
+			       struct scatterlist *src,
+			       struct scatterlist *dst,
+			       size_t len,
+			       atmel_aes_fn_t resume)
+{
+	enum dma_slave_buswidth addr_width;
+	u32 maxburst;
+	int err;
 
-		err = dma_map_sg(dd->dev, dd->in_sg, 1, DMA_TO_DEVICE);
-		if (!err) {
-			dev_err(dd->dev, "dma_map_sg() error\n");
-			return -EINVAL;
-		}
+	switch (dd->ctx->block_size) {
+	case CFB8_BLOCK_SIZE:
+		addr_width = DMA_SLAVE_BUSWIDTH_1_BYTE;
+		maxburst = 1;
+		break;
 
-		err = dma_map_sg(dd->dev, dd->out_sg, 1,
-				DMA_FROM_DEVICE);
-		if (!err) {
-			dev_err(dd->dev, "dma_map_sg() error\n");
-			dma_unmap_sg(dd->dev, dd->in_sg, 1,
-				DMA_TO_DEVICE);
-			return -EINVAL;
-		}
+	case CFB16_BLOCK_SIZE:
+		addr_width = DMA_SLAVE_BUSWIDTH_2_BYTES;
+		maxburst = 1;
+		break;
 
-		addr_in = sg_dma_address(dd->in_sg);
-		addr_out = sg_dma_address(dd->out_sg);
+	case CFB32_BLOCK_SIZE:
+	case CFB64_BLOCK_SIZE:
+		addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
+		maxburst = 1;
+		break;
 
-		dd->flags |= AES_FLAGS_FAST;
+	case AES_BLOCK_SIZE:
+		addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
+		maxburst = dd->caps.max_burst_size;
+		break;
 
-	} else {
-		dma_sync_single_for_cpu(dd->dev, dd->dma_addr_in,
-					dd->dma_size, DMA_TO_DEVICE);
+	default:
+		err = -EINVAL;
+		goto exit;
+	}
 
-		/* use cache buffers */
-		count = atmel_aes_sg_copy(&dd->in_sg, &dd->in_offset,
-				dd->buf_in, dd->buflen, dd->total, 0);
+	err = atmel_aes_map(dd, src, dst, len);
+	if (err)
+		goto exit;
 
-		addr_in = dd->dma_addr_in;
-		addr_out = dd->dma_addr_out;
+	dd->resume = resume;
 
-		dd->flags &= ~AES_FLAGS_FAST;
-	}
+	/* Set output DMA transfer first */
+	err = atmel_aes_dma_transfer_start(dd, addr_width, DMA_DEV_TO_MEM,
+					   maxburst);
+	if (err)
+		goto unmap;
 
-	dd->total -= count;
+	/* Then set input DMA transfer */
+	err = atmel_aes_dma_transfer_start(dd, addr_width, DMA_MEM_TO_DEV,
+					   maxburst);
+	if (err)
+		goto output_transfer_stop;
 
-	err = atmel_aes_crypt_dma(dd, addr_in, addr_out, count);
+	return -EINPROGRESS;
 
-	if (err && (dd->flags & AES_FLAGS_FAST)) {
-		dma_unmap_sg(dd->dev, dd->in_sg, 1, DMA_TO_DEVICE);
-		dma_unmap_sg(dd->dev, dd->out_sg, 1, DMA_TO_DEVICE);
-	}
+output_transfer_stop:
+	atmel_aes_dma_transfer_stop(dd, DMA_DEV_TO_MEM);
+unmap:
+	atmel_aes_unmap(dd);
+exit:
+	return atmel_aes_complete(dd, err);
+}
 
-	dd->resume = atmel_aes_dma_complete;
-	return err ? : -EINPROGRESS;
+static void atmel_aes_dma_stop(struct atmel_aes_dev *dd)
+{
+	atmel_aes_dma_transfer_stop(dd, DMA_MEM_TO_DEV);
+	atmel_aes_dma_transfer_stop(dd, DMA_DEV_TO_MEM);
+	atmel_aes_unmap(dd);
+}
+
+static void atmel_aes_dma_callback(void *data)
+{
+	struct atmel_aes_dev *dd = data;
+
+	atmel_aes_dma_stop(dd);
+	dd->is_async = true;
+	(void)dd->resume(dd);
 }
 
 static void atmel_aes_write_ctrl(struct atmel_aes_dev *dd, bool use_dma,
@@ -601,119 +732,52 @@ static int atmel_aes_handle_queue(struct atmel_aes_dev *dd,
 	return (dd->is_async) ? ret : err;
 }
 
+static int atmel_aes_transfer_complete(struct atmel_aes_dev *dd)
+{
+	return atmel_aes_complete(dd, 0);
+}
+
 static int atmel_aes_start(struct atmel_aes_dev *dd)
 {
 	struct ablkcipher_request *req = ablkcipher_request_cast(dd->areq);
-	struct atmel_aes_reqctx *rctx;
-	bool use_dma;
+	struct atmel_aes_reqctx *rctx = ablkcipher_request_ctx(req);
+	bool use_dma = (req->nbytes >= ATMEL_AES_DMA_THRESHOLD ||
+			dd->ctx->block_size != AES_BLOCK_SIZE);
 	int err;
 
-	/* assign new request to device */
-	dd->total = req->nbytes;
-	dd->in_offset = 0;
-	dd->in_sg = req->src;
-	dd->out_offset = 0;
-	dd->out_sg = req->dst;
-
-	rctx = ablkcipher_request_ctx(req);
 	atmel_aes_set_mode(dd, rctx);
 
 	err = atmel_aes_hw_init(dd);
-	if (!err) {
-		use_dma = (dd->total > ATMEL_AES_DMA_THRESHOLD);
-		atmel_aes_write_ctrl(dd, use_dma, req->info);
-		if (use_dma)
-			err = atmel_aes_crypt_dma_start(dd);
-		else
-			err = atmel_aes_crypt_cpu_start(dd);
-	}
-	if (err && err != -EINPROGRESS) {
-		/* aes_task will not finish it, so do it here */
+	if (err)
 		return atmel_aes_complete(dd, err);
-	}
-
-	return -EINPROGRESS;
-}
-
-static int atmel_aes_crypt_dma_stop(struct atmel_aes_dev *dd)
-{
-	int err = 0;
-	size_t count;
 
-	if  (dd->flags & AES_FLAGS_FAST) {
-		dma_unmap_sg(dd->dev, dd->out_sg, 1, DMA_FROM_DEVICE);
-		dma_unmap_sg(dd->dev, dd->in_sg, 1, DMA_TO_DEVICE);
-	} else {
-		dma_sync_single_for_cpu(dd->dev, dd->dma_addr_out,
-					dd->dma_size, DMA_FROM_DEVICE);
-
-		/* copy data */
-		count = atmel_aes_sg_copy(&dd->out_sg, &dd->out_offset,
-					  dd->buf_out, dd->buflen,
-					  dd->dma_size, 1);
-		if (count != dd->dma_size) {
-			err = -EINVAL;
-			pr_err("not all data converted: %zu\n", count);
-		}
-	}
+	atmel_aes_write_ctrl(dd, use_dma, req->info);
+	if (use_dma)
+		return atmel_aes_dma_start(dd, req->src, req->dst, req->nbytes,
+					   atmel_aes_transfer_complete);
 
-	return err;
+	return atmel_aes_cpu_start(dd, req->src, req->dst, req->nbytes,
+				   atmel_aes_transfer_complete);
 }
 
 
 static int atmel_aes_buff_init(struct atmel_aes_dev *dd)
 {
-	int err = -ENOMEM;
-
-	dd->buf_in = (void *)__get_free_pages(GFP_KERNEL, 0);
-	dd->buf_out = (void *)__get_free_pages(GFP_KERNEL, 0);
-	dd->buflen = PAGE_SIZE;
+	dd->buf = (void *)__get_free_pages(GFP_KERNEL, ATMEL_AES_BUFFER_ORDER);
+	dd->buflen = ATMEL_AES_BUFFER_SIZE;
 	dd->buflen &= ~(AES_BLOCK_SIZE - 1);
 
-	if (!dd->buf_in || !dd->buf_out) {
+	if (!dd->buf) {
 		dev_err(dd->dev, "unable to alloc pages.\n");
-		goto err_alloc;
-	}
-
-	/* MAP here */
-	dd->dma_addr_in = dma_map_single(dd->dev, dd->buf_in,
-					dd->buflen, DMA_TO_DEVICE);
-	if (dma_mapping_error(dd->dev, dd->dma_addr_in)) {
-		dev_err(dd->dev, "dma %zd bytes error\n", dd->buflen);
-		err = -EINVAL;
-		goto err_map_in;
-	}
-
-	dd->dma_addr_out = dma_map_single(dd->dev, dd->buf_out,
-					dd->buflen, DMA_FROM_DEVICE);
-	if (dma_mapping_error(dd->dev, dd->dma_addr_out)) {
-		dev_err(dd->dev, "dma %zd bytes error\n", dd->buflen);
-		err = -EINVAL;
-		goto err_map_out;
+		return -ENOMEM;
 	}
 
 	return 0;
-
-err_map_out:
-	dma_unmap_single(dd->dev, dd->dma_addr_in, dd->buflen,
-		DMA_TO_DEVICE);
-err_map_in:
-err_alloc:
-	free_page((unsigned long)dd->buf_out);
-	free_page((unsigned long)dd->buf_in);
-	if (err)
-		pr_err("error: %d\n", err);
-	return err;
 }
 
 static void atmel_aes_buff_cleanup(struct atmel_aes_dev *dd)
 {
-	dma_unmap_single(dd->dev, dd->dma_addr_out, dd->buflen,
-			 DMA_FROM_DEVICE);
-	dma_unmap_single(dd->dev, dd->dma_addr_in, dd->buflen,
-		DMA_TO_DEVICE);
-	free_page((unsigned long)dd->buf_out);
-	free_page((unsigned long)dd->buf_in);
+	free_page((unsigned long)dd->buf);
 }
 
 static int atmel_aes_crypt(struct ablkcipher_request *req, unsigned long mode)
@@ -767,8 +831,9 @@ static bool atmel_aes_filter(struct dma_chan *chan, void *slave)
 }
 
 static int atmel_aes_dma_init(struct atmel_aes_dev *dd,
-	struct crypto_platform_data *pdata)
+			      struct crypto_platform_data *pdata)
 {
+	struct at_dma_slave *slave;
 	int err = -ENOMEM;
 	dma_cap_mask_t mask;
 
@@ -776,42 +841,22 @@ static int atmel_aes_dma_init(struct atmel_aes_dev *dd,
 	dma_cap_set(DMA_SLAVE, mask);
 
 	/* Try to grab 2 DMA channels */
-	dd->dma_lch_in.chan = dma_request_slave_channel_compat(mask,
-			atmel_aes_filter, &pdata->dma_slave->rxdata, dd->dev, "tx");
-	if (!dd->dma_lch_in.chan)
+	slave = &pdata->dma_slave->rxdata;
+	dd->src.chan = dma_request_slave_channel_compat(mask, atmel_aes_filter,
+							slave, dd->dev, "tx");
+	if (!dd->src.chan)
 		goto err_dma_in;
 
-	dd->dma_lch_in.dma_conf.direction = DMA_MEM_TO_DEV;
-	dd->dma_lch_in.dma_conf.dst_addr = dd->phys_base +
-		AES_IDATAR(0);
-	dd->dma_lch_in.dma_conf.src_maxburst = dd->caps.max_burst_size;
-	dd->dma_lch_in.dma_conf.src_addr_width =
-		DMA_SLAVE_BUSWIDTH_4_BYTES;
-	dd->dma_lch_in.dma_conf.dst_maxburst = dd->caps.max_burst_size;
-	dd->dma_lch_in.dma_conf.dst_addr_width =
-		DMA_SLAVE_BUSWIDTH_4_BYTES;
-	dd->dma_lch_in.dma_conf.device_fc = false;
-
-	dd->dma_lch_out.chan = dma_request_slave_channel_compat(mask,
-			atmel_aes_filter, &pdata->dma_slave->txdata, dd->dev, "rx");
-	if (!dd->dma_lch_out.chan)
+	slave = &pdata->dma_slave->txdata;
+	dd->dst.chan = dma_request_slave_channel_compat(mask, atmel_aes_filter,
+							slave, dd->dev, "rx");
+	if (!dd->dst.chan)
 		goto err_dma_out;
 
-	dd->dma_lch_out.dma_conf.direction = DMA_DEV_TO_MEM;
-	dd->dma_lch_out.dma_conf.src_addr = dd->phys_base +
-		AES_ODATAR(0);
-	dd->dma_lch_out.dma_conf.src_maxburst = dd->caps.max_burst_size;
-	dd->dma_lch_out.dma_conf.src_addr_width =
-		DMA_SLAVE_BUSWIDTH_4_BYTES;
-	dd->dma_lch_out.dma_conf.dst_maxburst = dd->caps.max_burst_size;
-	dd->dma_lch_out.dma_conf.dst_addr_width =
-		DMA_SLAVE_BUSWIDTH_4_BYTES;
-	dd->dma_lch_out.dma_conf.device_fc = false;
-
 	return 0;
 
 err_dma_out:
-	dma_release_channel(dd->dma_lch_in.chan);
+	dma_release_channel(dd->src.chan);
 err_dma_in:
 	dev_warn(dd->dev, "no DMA channel available\n");
 	return err;
@@ -819,8 +864,8 @@ err_dma_in:
 
 static void atmel_aes_dma_cleanup(struct atmel_aes_dev *dd)
 {
-	dma_release_channel(dd->dma_lch_in.chan);
-	dma_release_channel(dd->dma_lch_out.chan);
+	dma_release_channel(dd->dst.chan);
+	dma_release_channel(dd->src.chan);
 }
 
 static int atmel_aes_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
@@ -1157,43 +1202,6 @@ static void atmel_aes_done_task(unsigned long data)
 	(void)dd->resume(dd);
 }
 
-static int atmel_aes_dma_complete(struct atmel_aes_dev *dd)
-{
-	int err;
-
-	err = atmel_aes_crypt_dma_stop(dd);
-	if (dd->total && !err) {
-		if (dd->flags & AES_FLAGS_FAST) {
-			dd->in_sg = sg_next(dd->in_sg);
-			dd->out_sg = sg_next(dd->out_sg);
-			if (!dd->in_sg || !dd->out_sg)
-				err = -EINVAL;
-		}
-		if (!err)
-			err = atmel_aes_crypt_dma_start(dd);
-		if (!err || err == -EINPROGRESS)
-			return -EINPROGRESS; /* DMA started. Not fininishing. */
-	}
-
-	return atmel_aes_complete(dd, err);
-}
-
-static int atmel_aes_cpu_complete(struct atmel_aes_dev *dd)
-{
-	int err;
-
-	atmel_aes_read_n(dd, AES_ODATAR(0), (u32 *) dd->buf_out,
-			 dd->bufcnt >> 2);
-
-	if (sg_copy_from_buffer(dd->out_sg, dd->nb_out_sg,
-				dd->buf_out, dd->bufcnt))
-		err = 0;
-	else
-		err = -EINVAL;
-
-	return atmel_aes_complete(dd, err);
-}
-
 static irqreturn_t atmel_aes_irq(int irq, void *dev_id)
 {
 	struct atmel_aes_dev *aes_dd = dev_id;
@@ -1430,8 +1438,8 @@ static int atmel_aes_probe(struct platform_device *pdev)
 		goto err_algs;
 
 	dev_info(dev, "Atmel AES - Using %s, %s for DMA transfers\n",
-			dma_chan_name(aes_dd->dma_lch_in.chan),
-			dma_chan_name(aes_dd->dma_lch_out.chan));
+			dma_chan_name(aes_dd->src.chan),
+			dma_chan_name(aes_dd->dst.chan));
 
 	return 0;
 
-- 
1.8.2.2
