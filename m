From: Evgeniy Polyakov <zbr@ioremap.net>
Subject: Re: dm-crypt using hifn_795x - still broken
Date: Wed, 12 Nov 2008 23:51:21 +0300
Message-ID: <20081112205121.GB7854@ioremap.net>
References: <200811121710.41666.tobias.geiger@vido.info> <20081112162009.GA2051@ioremap.net> <200811122043.06790.tobias.geiger@vido.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Tobias Geiger <tobias.geiger@vido.info>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from genesysrack.ru ([195.178.208.66]:39760 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753182AbYKLUvZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 12 Nov 2008 15:51:25 -0500
Content-Disposition: inline
In-Reply-To: <200811122043.06790.tobias.geiger@vido.info>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 12, 2008 at 08:43:06PM +0100, Tobias Geiger (tobias.geiger@vido.info) wrote:
> Hello Evgeniy,
> 
> i tried that, know it just hangs while mounting the decrypted device. No 
> special dmesg error or anything.:

Please try attached patch against vanilla driver.
Likely I messed up with ring size.

diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index 4d22b21..c743cfc 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -38,9 +38,6 @@
 
 #include <asm/kmap_types.h>
 
-#undef dprintk
-
-#define HIFN_TEST
 //#define HIFN_DEBUG
 
 #ifdef HIFN_DEBUG
@@ -370,7 +367,7 @@ static atomic_t hifn_dev_number;
 
 #define HIFN_D_DST_DALIGN		4
 
-#define HIFN_QUEUE_LENGTH		HIFN_D_CMD_RSIZE-1
+#define HIFN_QUEUE_LENGTH		(HIFN_D_CMD_RSIZE - 1)
 
 #define AES_MIN_KEY_SIZE		16
 #define AES_MAX_KEY_SIZE		32
@@ -406,8 +403,6 @@ struct hifn_dma {
 	u8			command_bufs[HIFN_D_CMD_RSIZE][HIFN_MAX_COMMAND];
 	u8			result_bufs[HIFN_D_CMD_RSIZE][HIFN_MAX_RESULT];
 
-	u64			test_src, test_dst;
-
 	/*
 	 *  Our current positions for insertion and removal from the descriptor
 	 *  rings.
@@ -434,9 +429,6 @@ struct hifn_device
 	struct pci_dev		*pdev;
 	void __iomem		*bar[3];
 
-	unsigned long		result_mem;
-	dma_addr_t		dst;
-
 	void			*desc_virt;
 	dma_addr_t		desc_dma;
 
@@ -446,8 +438,6 @@ struct hifn_device
 
 	spinlock_t		lock;
 
-	void 			*priv;
-
 	u32			flags;
 	int			active, started;
 	struct delayed_work	work;
@@ -657,12 +647,17 @@ struct ablkcipher_walk
 
 struct hifn_context
 {
-	u8			key[HIFN_MAX_CRYPT_KEY_LENGTH], *iv;
+	u8			key[HIFN_MAX_CRYPT_KEY_LENGTH];
 	struct hifn_device	*dev;
-	unsigned int		keysize, ivsize;
+	unsigned int		keysize;
+};
+
+struct hifn_request_context
+{
+	u8			*iv;
+	unsigned int		ivsize;
 	u8			op, type, mode, unused;
 	struct ablkcipher_walk	walk;
-	atomic_t		sg_num;
 };
 
 #define crypto_alg_to_hifn(a)	container_of(a, struct hifn_crypto_alg, alg)
@@ -1168,7 +1163,8 @@ static int hifn_setup_crypto_command(struct hifn_device *dev,
 }
 
 static int hifn_setup_cmd_desc(struct hifn_device *dev,
-		struct hifn_context *ctx, void *priv, unsigned int nbytes)
+		struct hifn_context *ctx, struct hifn_request_context *rctx,
+		void *priv, unsigned int nbytes)
 {
 	struct hifn_dma *dma = (struct hifn_dma *)dev->desc_virt;
 	int cmd_len, sa_idx;
@@ -1179,7 +1175,7 @@ static int hifn_setup_cmd_desc(struct hifn_device *dev,
 	buf_pos = buf = dma->command_bufs[dma->cmdi];
 
 	mask = 0;
-	switch (ctx->op) {
+	switch (rctx->op) {
 		case ACRYPTO_OP_DECRYPT:
 			mask = HIFN_BASE_CMD_CRYPT | HIFN_BASE_CMD_DECODE;
 			break;
@@ -1196,15 +1192,15 @@ static int hifn_setup_cmd_desc(struct hifn_device *dev,
 	buf_pos += hifn_setup_base_command(dev, buf_pos, nbytes,
 			nbytes, mask, dev->snum);
 
-	if (ctx->op == ACRYPTO_OP_ENCRYPT || ctx->op == ACRYPTO_OP_DECRYPT) {
+	if (rctx->op == ACRYPTO_OP_ENCRYPT || rctx->op == ACRYPTO_OP_DECRYPT) {
 		u16 md = 0;
 
 		if (ctx->keysize)
 			md |= HIFN_CRYPT_CMD_NEW_KEY;
-		if (ctx->iv && ctx->mode != ACRYPTO_MODE_ECB)
+		if (rctx->iv && rctx->mode != ACRYPTO_MODE_ECB)
 			md |= HIFN_CRYPT_CMD_NEW_IV;
 
-		switch (ctx->mode) {
+		switch (rctx->mode) {
 			case ACRYPTO_MODE_ECB:
 				md |= HIFN_CRYPT_CMD_MODE_ECB;
 				break;
@@ -1221,7 +1217,7 @@ static int hifn_setup_cmd_desc(struct hifn_device *dev,
 				goto err_out;
 		}
 
-		switch (ctx->type) {
+		switch (rctx->type) {
 			case ACRYPTO_TYPE_AES_128:
 				if (ctx->keysize != 16)
 					goto err_out;
@@ -1256,17 +1252,18 @@ static int hifn_setup_cmd_desc(struct hifn_device *dev,
 
 		buf_pos += hifn_setup_crypto_command(dev, buf_pos,
 				nbytes, nbytes, ctx->key, ctx->keysize,
-				ctx->iv, ctx->ivsize, md);
+				rctx->iv, rctx->ivsize, md);
 	}
 
 	dev->sa[sa_idx] = priv;
+	dev->started++;
 
 	cmd_len = buf_pos - buf;
 	dma->cmdr[dma->cmdi].l = __cpu_to_le32(cmd_len | HIFN_D_VALID |
 			HIFN_D_LAST | HIFN_D_MASKDONEIRQ);
 
 	if (++dma->cmdi == HIFN_D_CMD_RSIZE) {
-		dma->cmdr[dma->cmdi].l = __cpu_to_le32(HIFN_MAX_COMMAND |
+		dma->cmdr[dma->cmdi].l = __cpu_to_le32(
 			HIFN_D_VALID | HIFN_D_LAST |
 			HIFN_D_MASKDONEIRQ | HIFN_D_JUMP);
 		dma->cmdi = 0;
@@ -1284,7 +1281,7 @@ err_out:
 }
 
 static int hifn_setup_src_desc(struct hifn_device *dev, struct page *page,
-		unsigned int offset, unsigned int size)
+		unsigned int offset, unsigned int size, int last)
 {
 	struct hifn_dma *dma = (struct hifn_dma *)dev->desc_virt;
 	int idx;
@@ -1296,12 +1293,12 @@ static int hifn_setup_src_desc(struct hifn_device *dev, struct page *page,
 
 	dma->srcr[idx].p = __cpu_to_le32(addr);
 	dma->srcr[idx].l = __cpu_to_le32(size | HIFN_D_VALID |
-			HIFN_D_MASKDONEIRQ | HIFN_D_LAST);
+			HIFN_D_MASKDONEIRQ | (last ? HIFN_D_LAST : 0));
 
 	if (++idx == HIFN_D_SRC_RSIZE) {
 		dma->srcr[idx].l = __cpu_to_le32(HIFN_D_VALID |
-				HIFN_D_JUMP |
-				HIFN_D_MASKDONEIRQ | HIFN_D_LAST);
+				HIFN_D_JUMP | HIFN_D_MASKDONEIRQ |
+				(last ? HIFN_D_LAST : 0));
 		idx = 0;
 	}
 
@@ -1342,7 +1339,7 @@ static void hifn_setup_res_desc(struct hifn_device *dev)
 }
 
 static void hifn_setup_dst_desc(struct hifn_device *dev, struct page *page,
-		unsigned offset, unsigned size)
+		unsigned offset, unsigned size, int last)
 {
 	struct hifn_dma *dma = (struct hifn_dma *)dev->desc_virt;
 	int idx;
@@ -1353,12 +1350,12 @@ static void hifn_setup_dst_desc(struct hifn_device *dev, struct page *page,
 	idx = dma->dsti;
 	dma->dstr[idx].p = __cpu_to_le32(addr);
 	dma->dstr[idx].l = __cpu_to_le32(size |	HIFN_D_VALID |
-			HIFN_D_MASKDONEIRQ | HIFN_D_LAST);
+			HIFN_D_MASKDONEIRQ | (last ? HIFN_D_LAST : 0));
 
 	if (++idx == HIFN_D_DST_RSIZE) {
 		dma->dstr[idx].l = __cpu_to_le32(HIFN_D_VALID |
 				HIFN_D_JUMP | HIFN_D_MASKDONEIRQ |
-				HIFN_D_LAST);
+				(last ? HIFN_D_LAST : 0));
 		idx = 0;
 	}
 	dma->dsti = idx;
@@ -1370,16 +1367,56 @@ static void hifn_setup_dst_desc(struct hifn_device *dev, struct page *page,
 	}
 }
 
-static int hifn_setup_dma(struct hifn_device *dev, struct page *spage, unsigned int soff,
-		struct page *dpage, unsigned int doff, unsigned int nbytes, void *priv,
-		struct hifn_context *ctx)
+static int hifn_setup_dma(struct hifn_device *dev,
+		struct hifn_context *ctx, struct hifn_request_context *rctx,
+		struct scatterlist *src, struct scatterlist *dst,
+		unsigned int nbytes, void *priv)
 {
-	dprintk("%s: spage: %p, soffset: %u, dpage: %p, doffset: %u, nbytes: %u, priv: %p, ctx: %p.\n",
-			dev->name, spage, soff, dpage, doff, nbytes, priv, ctx);
+	struct scatterlist *t;
+	struct page *spage, *dpage;
+	unsigned int soff, doff;
+	unsigned int n, len;
+
+	n = nbytes;
+	while (n) {
+		spage = sg_page(src);
+		soff = src->offset;
+		len = min(src->length, n);
+
+		dprintk("%s: spage: %p, soffset: %u, nbytes: %u, "
+			"priv: %p, rctx: %p.\n",
+			dev->name, spage, soff, nbytes, priv, rctx);
+		hifn_setup_src_desc(dev, spage, soff, len, n - len == 0);
+
+		src++;
+		n -= len;
+	}
 
-	hifn_setup_src_desc(dev, spage, soff, nbytes);
-	hifn_setup_cmd_desc(dev, ctx, priv, nbytes);
-	hifn_setup_dst_desc(dev, dpage, doff, nbytes);
+	t = &rctx->walk.cache[0];
+	n = nbytes;
+	while (n) {
+		if (t->length && rctx->walk.flags & ASYNC_FLAGS_MISALIGNED) {
+			dpage = sg_page(t);
+			doff = 0;
+			len = t->length;
+		} else {
+			dpage = sg_page(dst);
+			doff = dst->offset;
+			len = dst->length;
+		}
+		len = min(len, n);
+
+		dprintk("%s: dpage: %p, doffset: %u, nbytes: %u, "
+			"priv: %p, rctx: %p.\n",
+			dev->name, dpage, doff, nbytes, priv, rctx);
+		hifn_setup_dst_desc(dev, dpage, doff, len, n - len == 0);
+
+		dst++;
+		t++;
+		n -= len;
+	}
+
+	hifn_setup_cmd_desc(dev, ctx, rctx, priv, nbytes);
 	hifn_setup_res_desc(dev);
 	return 0;
 }
@@ -1424,32 +1461,26 @@ static void ablkcipher_walk_exit(struct ablkcipher_walk *w)
 	w->num = 0;
 }
 
-static int ablkcipher_add(void *daddr, unsigned int *drestp, struct scatterlist *src,
+static int ablkcipher_add(unsigned int *drestp, struct scatterlist *dst,
 		unsigned int size, unsigned int *nbytesp)
 {
 	unsigned int copy, drest = *drestp, nbytes = *nbytesp;
 	int idx = 0;
-	void *saddr;
 
 	if (drest < size || size > nbytes)
 		return -EINVAL;
 
 	while (size) {
-		copy = min(drest, min(size, src->length));
-
-		saddr = kmap_atomic(sg_page(src), KM_SOFTIRQ1);
-		memcpy(daddr, saddr + src->offset, copy);
-		kunmap_atomic(saddr, KM_SOFTIRQ1);
+		copy = min(drest, min(size, dst->length));
 
 		size -= copy;
 		drest -= copy;
 		nbytes -= copy;
-		daddr += copy;
 
 		dprintk("%s: copy: %u, size: %u, drest: %u, nbytes: %u.\n",
 				__func__, copy, size, drest, nbytes);
 
-		src++;
+		dst++;
 		idx++;
 	}
 
@@ -1462,8 +1493,7 @@ static int ablkcipher_add(void *daddr, unsigned int *drestp, struct scatterlist
 static int ablkcipher_walk(struct ablkcipher_request *req,
 		struct ablkcipher_walk *w)
 {
-	struct scatterlist *src, *dst, *t;
-	void *daddr;
+	struct scatterlist *dst, *t;
 	unsigned int nbytes = req->nbytes, offset, copy, diff;
 	int idx, tidx, err;
 
@@ -1473,26 +1503,22 @@ static int ablkcipher_walk(struct ablkcipher_request *req,
 		if (idx >= w->num && (w->flags & ASYNC_FLAGS_MISALIGNED))
 			return -EINVAL;
 
-		src = &req->src[idx];
 		dst = &req->dst[idx];
 
-		dprintk("\n%s: slen: %u, dlen: %u, soff: %u, doff: %u, offset: %u, "
-				"nbytes: %u.\n",
-				__func__, src->length, dst->length, src->offset,
-				dst->offset, offset, nbytes);
+		dprintk("\n%s: dlen: %u, doff: %u, offset: %u, nbytes: %u.\n",
+			__func__, dst->length, dst->offset, offset, nbytes);
 
 		if (!IS_ALIGNED(dst->offset, HIFN_D_DST_DALIGN) ||
 		    !IS_ALIGNED(dst->length, HIFN_D_DST_DALIGN) ||
 		    offset) {
-			unsigned slen = min(src->length - offset, nbytes);
+			unsigned slen = min(dst->length - offset, nbytes);
 			unsigned dlen = PAGE_SIZE;
 
 			t = &w->cache[idx];
 
-			daddr = kmap_atomic(sg_page(t), KM_SOFTIRQ0);
-			err = ablkcipher_add(daddr, &dlen, src, slen, &nbytes);
+			err = ablkcipher_add(&dlen, dst, slen, &nbytes);
 			if (err < 0)
-				goto err_out_unmap;
+				return err;
 
 			idx += err;
 
@@ -1528,21 +1554,19 @@ static int ablkcipher_walk(struct ablkcipher_request *req,
 			} else {
 				copy += diff + nbytes;
 
-				src = &req->src[idx];
+				dst = &req->dst[idx];
 
-				err = ablkcipher_add(daddr + slen, &dlen, src, nbytes, &nbytes);
+				err = ablkcipher_add(&dlen, dst, nbytes, &nbytes);
 				if (err < 0)
-					goto err_out_unmap;
+					return err;
 
 				idx += err;
 			}
 
 			t->length = copy;
 			t->offset = offset;
-
-			kunmap_atomic(daddr, KM_SOFTIRQ0);
 		} else {
-			nbytes -= min(src->length, nbytes);
+			nbytes -= min(dst->length, nbytes);
 			idx++;
 		}
 
@@ -1550,26 +1574,22 @@ static int ablkcipher_walk(struct ablkcipher_request *req,
 	}
 
 	return tidx;
-
-err_out_unmap:
-	kunmap_atomic(daddr, KM_SOFTIRQ0);
-	return err;
 }
 
 static int hifn_setup_session(struct ablkcipher_request *req)
 {
 	struct hifn_context *ctx = crypto_tfm_ctx(req->base.tfm);
+	struct hifn_request_context *rctx = ablkcipher_request_ctx(req);
 	struct hifn_device *dev = ctx->dev;
-	struct page *spage, *dpage;
-	unsigned long soff, doff, dlen, flags;
-	unsigned int nbytes = req->nbytes, idx = 0, len;
+	unsigned long dlen, flags;
+	unsigned int nbytes = req->nbytes, idx = 0;
 	int err = -EINVAL, sg_num;
-	struct scatterlist *src, *dst, *t;
+	struct scatterlist *dst;
 
-	if (ctx->iv && !ctx->ivsize && ctx->mode != ACRYPTO_MODE_ECB)
+	if (rctx->iv && !rctx->ivsize && rctx->mode != ACRYPTO_MODE_ECB)
 		goto err_out_exit;
 
-	ctx->walk.flags = 0;
+	rctx->walk.flags = 0;
 
 	while (nbytes) {
 		dst = &req->dst[idx];
@@ -1577,27 +1597,23 @@ static int hifn_setup_session(struct ablkcipher_request *req)
 
 		if (!IS_ALIGNED(dst->offset, HIFN_D_DST_DALIGN) ||
 		    !IS_ALIGNED(dlen, HIFN_D_DST_DALIGN))
-			ctx->walk.flags |= ASYNC_FLAGS_MISALIGNED;
+			rctx->walk.flags |= ASYNC_FLAGS_MISALIGNED;
 
 		nbytes -= dlen;
 		idx++;
 	}
 
-	if (ctx->walk.flags & ASYNC_FLAGS_MISALIGNED) {
-		err = ablkcipher_walk_init(&ctx->walk, idx, GFP_ATOMIC);
+	if (rctx->walk.flags & ASYNC_FLAGS_MISALIGNED) {
+		err = ablkcipher_walk_init(&rctx->walk, idx, GFP_ATOMIC);
 		if (err < 0)
 			return err;
 	}
 
-	nbytes = req->nbytes;
-	idx = 0;
-
-	sg_num = ablkcipher_walk(req, &ctx->walk);
+	sg_num = ablkcipher_walk(req, &rctx->walk);
 	if (sg_num < 0) {
 		err = sg_num;
 		goto err_out_exit;
 	}
-	atomic_set(&ctx->sg_num, sg_num);
 
 	spin_lock_irqsave(&dev->lock, flags);
 	if (dev->started + sg_num > HIFN_QUEUE_LENGTH) {
@@ -1605,37 +1621,11 @@ static int hifn_setup_session(struct ablkcipher_request *req)
 		goto err_out;
 	}
 
-	dev->snum++;
-	dev->started += sg_num;
-
-	while (nbytes) {
-		src = &req->src[idx];
-		dst = &req->dst[idx];
-		t = &ctx->walk.cache[idx];
-
-		if (t->length) {
-			spage = dpage = sg_page(t);
-			soff = doff = 0;
-			len = t->length;
-		} else {
-			spage = sg_page(src);
-			soff = src->offset;
-
-			dpage = sg_page(dst);
-			doff = dst->offset;
-
-			len = dst->length;
-		}
-
-		idx++;
-
-		err = hifn_setup_dma(dev, spage, soff, dpage, doff, nbytes,
-				req, ctx);
-		if (err)
-			goto err_out;
+	err = hifn_setup_dma(dev, ctx, rctx, req->src, req->dst, req->nbytes, req);
+	if (err)
+		goto err_out;
 
-		nbytes -= min(len, nbytes);
-	}
+	dev->snum++;
 
 	dev->active = HIFN_DEFAULT_ACTIVE_NUM;
 	spin_unlock_irqrestore(&dev->lock, flags);
@@ -1645,12 +1635,13 @@ static int hifn_setup_session(struct ablkcipher_request *req)
 err_out:
 	spin_unlock_irqrestore(&dev->lock, flags);
 err_out_exit:
-	if (err)
-		dprintk("%s: iv: %p [%d], key: %p [%d], mode: %u, op: %u, "
+	if (err) {
+		printk("%s: iv: %p [%d], key: %p [%d], mode: %u, op: %u, "
 				"type: %u, err: %d.\n",
-			dev->name, ctx->iv, ctx->ivsize,
+			dev->name, rctx->iv, rctx->ivsize,
 			ctx->key, ctx->keysize,
-			ctx->mode, ctx->op, ctx->type, err);
+			rctx->mode, rctx->op, rctx->type, err);
+	}
 
 	return err;
 }
@@ -1660,31 +1651,33 @@ static int hifn_test(struct hifn_device *dev, int encdec, u8 snum)
 	int n, err;
 	u8 src[16];
 	struct hifn_context ctx;
+	struct hifn_request_context rctx;
 	u8 fips_aes_ecb_from_zero[16] = {
 		0x66, 0xE9, 0x4B, 0xD4,
 		0xEF, 0x8A, 0x2C, 0x3B,
 		0x88, 0x4C, 0xFA, 0x59,
 		0xCA, 0x34, 0x2B, 0x2E};
+	struct scatterlist sg;
 
 	memset(src, 0, sizeof(src));
 	memset(ctx.key, 0, sizeof(ctx.key));
 
 	ctx.dev = dev;
 	ctx.keysize = 16;
-	ctx.ivsize = 0;
-	ctx.iv = NULL;
-	ctx.op = (encdec)?ACRYPTO_OP_ENCRYPT:ACRYPTO_OP_DECRYPT;
-	ctx.mode = ACRYPTO_MODE_ECB;
-	ctx.type = ACRYPTO_TYPE_AES_128;
-	atomic_set(&ctx.sg_num, 1);
-
-	err = hifn_setup_dma(dev,
-			virt_to_page(src), offset_in_page(src),
-			virt_to_page(src), offset_in_page(src),
-			sizeof(src), NULL, &ctx);
+	rctx.ivsize = 0;
+	rctx.iv = NULL;
+	rctx.op = (encdec)?ACRYPTO_OP_ENCRYPT:ACRYPTO_OP_DECRYPT;
+	rctx.mode = ACRYPTO_MODE_ECB;
+	rctx.type = ACRYPTO_TYPE_AES_128;
+	rctx.walk.cache[0].length = 0;
+
+	sg_init_one(&sg, &src, sizeof(src));
+
+	err = hifn_setup_dma(dev, &ctx, &rctx, &sg, &sg, sizeof(src), NULL);
 	if (err)
 		goto err_out;
 
+	dev->started = 0;
 	msleep(200);
 
 	dprintk("%s: decoded: ", dev->name);
@@ -1711,6 +1704,7 @@ static int hifn_start_device(struct hifn_device *dev)
 {
 	int err;
 
+	dev->started = dev->active = 0;
 	hifn_reset_dma(dev, 1);
 
 	err = hifn_enable_crypto(dev);
@@ -1764,61 +1758,64 @@ static int ablkcipher_get(void *saddr, unsigned int *srestp, unsigned int offset
 	return idx;
 }
 
-static void hifn_process_ready(struct ablkcipher_request *req, int error)
+static inline void hifn_complete_sa(struct hifn_device *dev, int i)
 {
-	struct hifn_context *ctx = crypto_tfm_ctx(req->base.tfm);
-	struct hifn_device *dev;
+	unsigned long flags;
 
-	dprintk("%s: req: %p, ctx: %p.\n", __func__, req, ctx);
+	spin_lock_irqsave(&dev->lock, flags);
+	dev->sa[i] = NULL;
+	dev->started--;
+	if (dev->started < 0)
+		printk("%s: started: %d.\n", __func__, dev->started);
+	spin_unlock_irqrestore(&dev->lock, flags);
+	BUG_ON(dev->started < 0);
+}
 
-	dev = ctx->dev;
-	dprintk("%s: req: %p, started: %d, sg_num: %d.\n",
-		__func__, req, dev->started, atomic_read(&ctx->sg_num));
+static void hifn_process_ready(struct ablkcipher_request *req, int error)
+{
+	struct hifn_request_context *rctx = ablkcipher_request_ctx(req);
 
-	if (--dev->started < 0)
-		BUG();
+	dprintk("%s: req: %p, ctx: %p rctx: %p.\n", __func__, req, ctx, rctx);
 
-	if (atomic_dec_and_test(&ctx->sg_num)) {
+	if (rctx->walk.flags & ASYNC_FLAGS_MISALIGNED) {
 		unsigned int nbytes = req->nbytes;
 		int idx = 0, err;
 		struct scatterlist *dst, *t;
 		void *saddr;
 
-		if (ctx->walk.flags & ASYNC_FLAGS_MISALIGNED) {
-			while (nbytes) {
-				t = &ctx->walk.cache[idx];
-				dst = &req->dst[idx];
-
-				dprintk("\n%s: sg_page(t): %p, t->length: %u, "
-					"sg_page(dst): %p, dst->length: %u, "
-					"nbytes: %u.\n",
-					__func__, sg_page(t), t->length,
-					sg_page(dst), dst->length, nbytes);
+		while (nbytes) {
+			t = &rctx->walk.cache[idx];
+			dst = &req->dst[idx];
 
-				if (!t->length) {
-					nbytes -= min(dst->length, nbytes);
-					idx++;
-					continue;
-				}
+			dprintk("\n%s: sg_page(t): %p, t->length: %u, "
+				"sg_page(dst): %p, dst->length: %u, "
+				"nbytes: %u.\n",
+				__func__, sg_page(t), t->length,
+				sg_page(dst), dst->length, nbytes);
 
-				saddr = kmap_atomic(sg_page(t), KM_IRQ1);
+			if (!t->length) {
+				nbytes -= min(dst->length, nbytes);
+				idx++;
+				continue;
+			}
 
-				err = ablkcipher_get(saddr, &t->length, t->offset,
-						dst, nbytes, &nbytes);
-				if (err < 0) {
-					kunmap_atomic(saddr, KM_IRQ1);
-					break;
-				}
+			saddr = kmap_atomic(sg_page(t), KM_IRQ1);
 
-				idx += err;
+			err = ablkcipher_get(saddr, &t->length, t->offset,
+					dst, nbytes, &nbytes);
+			if (err < 0) {
 				kunmap_atomic(saddr, KM_IRQ1);
+				break;
 			}
 
-			ablkcipher_walk_exit(&ctx->walk);
+			idx += err;
+			kunmap_atomic(saddr, KM_IRQ1);
 		}
 
-		req->base.complete(&req->base, error);
+		ablkcipher_walk_exit(&rctx->walk);
 	}
+
+	req->base.complete(&req->base, error);
 }
 
 static void hifn_check_for_completion(struct hifn_device *dev, int error)
@@ -1833,12 +1830,12 @@ static void hifn_check_for_completion(struct hifn_device *dev, int error)
 			dev->success++;
 			dev->reset = 0;
 			hifn_process_ready(dev->sa[i], error);
-			dev->sa[i] = NULL;
+			hifn_complete_sa(dev, i);
 		}
 
 		if (d->l & __cpu_to_le32(HIFN_D_DESTOVER | HIFN_D_OVER))
 			if (printk_ratelimit())
-				printk("%s: overflow detected [d: %u, o: %u] "
+				printk(KERN_WARNING "%s: overflow detected [d: %u, o: %u] "
 						"at %d resr: l: %08x, p: %08x.\n",
 					dev->name,
 					!!(d->l & __cpu_to_le32(HIFN_D_DESTOVER)),
@@ -1847,6 +1844,7 @@ static void hifn_check_for_completion(struct hifn_device *dev, int error)
 	}
 }
 
+#if 0
 static void hifn_clear_rings(struct hifn_device *dev)
 {
 	struct hifn_dma *dma = (struct hifn_dma *)dev->desc_virt;
@@ -1910,6 +1908,7 @@ static void hifn_clear_rings(struct hifn_device *dev)
 			dma->cmdu, dma->srcu, dma->dstu, dma->resu,
 			dma->cmdk, dma->srck, dma->dstk, dma->resk);
 }
+#endif
 
 static void hifn_work(struct work_struct *work)
 {
@@ -1944,30 +1943,35 @@ static void hifn_work(struct work_struct *work)
 	} else
 		dev->active--;
 
-	if (dev->prev_success == dev->success && dev->started)
+	if ((dev->prev_success == dev->success) && dev->started)
 		reset = 1;
 	dev->prev_success = dev->success;
 	spin_unlock_irqrestore(&dev->lock, flags);
 
 	if (reset) {
-		dprintk("%s: r: %08x, active: %d, started: %d, "
-				"success: %lu: reset: %d.\n",
-			dev->name, r, dev->active, dev->started,
-			dev->success, reset);
-
 		if (++dev->reset >= 5) {
-			dprintk("%s: really hard reset.\n", dev->name);
+			int i;
+
+			printk("%s: r: %08x, active: %d, started: %d, "
+				"success: %lu: qlen: %u/%u, reset: %d.\n",
+				dev->name, r, dev->active, dev->started,
+				dev->success, dev->queue.qlen, dev->queue.max_qlen,
+				reset);
+
+			for (i=0; i<HIFN_D_RES_RSIZE; ++i) {
+				if (dev->sa[i]) {
+					hifn_process_ready(dev->sa[i], -ENODEV);
+					hifn_complete_sa(dev, i);
+				}
+			}
+
 			hifn_reset_dma(dev, 1);
 			hifn_stop_device(dev);
 			hifn_start_device(dev);
 			dev->reset = 0;
 		}
 
-		spin_lock_irqsave(&dev->lock, flags);
-		hifn_check_for_completion(dev, -EBUSY);
-		hifn_clear_rings(dev);
-		dev->started = 0;
-		spin_unlock_irqrestore(&dev->lock, flags);
+		tasklet_schedule(&dev->tasklet);
 	}
 
 	schedule_delayed_work(&dev->work, HZ);
@@ -2002,11 +2006,10 @@ static irqreturn_t hifn_interrupt(int irq, void *data)
 	if (restart) {
 		u32 puisr = hifn_read_0(dev, HIFN_0_PUISR);
 
-		if (printk_ratelimit())
-			printk("%s: overflow: r: %d, d: %d, puisr: %08x, d: %u.\n",
-				dev->name, !!(dmacsr & HIFN_DMACSR_R_OVER),
-				!!(dmacsr & HIFN_DMACSR_D_OVER),
-				puisr, !!(puisr & HIFN_PUISR_DSTOVER));
+		printk(KERN_WARNING "%s: overflow: r: %d, d: %d, puisr: %08x, d: %u.\n",
+			dev->name, !!(dmacsr & HIFN_DMACSR_R_OVER),
+			!!(dmacsr & HIFN_DMACSR_D_OVER),
+			puisr, !!(puisr & HIFN_PUISR_DSTOVER));
 		if (!!(puisr & HIFN_PUISR_DSTOVER))
 			hifn_write_0(dev, HIFN_0_PUISR, HIFN_PUISR_DSTOVER);
 		hifn_write_1(dev, HIFN_1_DMA_CSR, dmacsr & (HIFN_DMACSR_R_OVER |
@@ -2016,12 +2019,11 @@ static irqreturn_t hifn_interrupt(int irq, void *data)
 	restart = dmacsr & (HIFN_DMACSR_C_ABORT | HIFN_DMACSR_S_ABORT |
 			HIFN_DMACSR_D_ABORT | HIFN_DMACSR_R_ABORT);
 	if (restart) {
-		if (printk_ratelimit())
-			printk("%s: abort: c: %d, s: %d, d: %d, r: %d.\n",
-				dev->name, !!(dmacsr & HIFN_DMACSR_C_ABORT),
-				!!(dmacsr & HIFN_DMACSR_S_ABORT),
-				!!(dmacsr & HIFN_DMACSR_D_ABORT),
-				!!(dmacsr & HIFN_DMACSR_R_ABORT));
+		printk(KERN_WARNING "%s: abort: c: %d, s: %d, d: %d, r: %d.\n",
+			dev->name, !!(dmacsr & HIFN_DMACSR_C_ABORT),
+			!!(dmacsr & HIFN_DMACSR_S_ABORT),
+			!!(dmacsr & HIFN_DMACSR_D_ABORT),
+			!!(dmacsr & HIFN_DMACSR_R_ABORT));
 		hifn_reset_dma(dev, 1);
 		hifn_init_dma(dev);
 		hifn_init_registers(dev);
@@ -2034,7 +2036,6 @@ static irqreturn_t hifn_interrupt(int irq, void *data)
 	}
 
 	tasklet_schedule(&dev->tasklet);
-	hifn_clear_rings(dev);
 
 	return IRQ_HANDLED;
 }
@@ -2048,21 +2049,25 @@ static void hifn_flush(struct hifn_device *dev)
 	struct hifn_dma *dma = (struct hifn_dma *)dev->desc_virt;
 	int i;
 
-	spin_lock_irqsave(&dev->lock, flags);
 	for (i=0; i<HIFN_D_RES_RSIZE; ++i) {
 		struct hifn_desc *d = &dma->resr[i];
 
 		if (dev->sa[i]) {
 			hifn_process_ready(dev->sa[i],
 				(d->l & __cpu_to_le32(HIFN_D_VALID))?-ENODEV:0);
+			hifn_complete_sa(dev, i);
 		}
 	}
 
+	spin_lock_irqsave(&dev->lock, flags);
 	while ((async_req = crypto_dequeue_request(&dev->queue))) {
 		ctx = crypto_tfm_ctx(async_req->tfm);
 		req = container_of(async_req, struct ablkcipher_request, base);
+		spin_unlock_irqrestore(&dev->lock, flags);
 
 		hifn_process_ready(req, -ENODEV);
+
+		spin_lock_irqsave(&dev->lock, flags);
 	}
 	spin_unlock_irqrestore(&dev->lock, flags);
 }
@@ -2121,6 +2126,7 @@ static int hifn_setup_crypto_req(struct ablkcipher_request *req, u8 op,
 		u8 type, u8 mode)
 {
 	struct hifn_context *ctx = crypto_tfm_ctx(req->base.tfm);
+	struct hifn_request_context *rctx = ablkcipher_request_ctx(req);
 	unsigned ivsize;
 
 	ivsize = crypto_ablkcipher_ivsize(crypto_ablkcipher_reqtfm(req));
@@ -2141,11 +2147,11 @@ static int hifn_setup_crypto_req(struct ablkcipher_request *req, u8 op,
 			type = ACRYPTO_TYPE_AES_256;
 	}
 
-	ctx->op = op;
-	ctx->mode = mode;
-	ctx->type = type;
-	ctx->iv = req->info;
-	ctx->ivsize = ivsize;
+	rctx->op = op;
+	rctx->mode = mode;
+	rctx->type = type;
+	rctx->iv = req->info;
+	rctx->ivsize = ivsize;
 
 	/*
 	 * HEAVY TODO: needs to kick Herbert XU to write documentation.
@@ -2158,7 +2164,7 @@ static int hifn_setup_crypto_req(struct ablkcipher_request *req, u8 op,
 
 static int hifn_process_queue(struct hifn_device *dev)
 {
-	struct crypto_async_request *async_req;
+	struct crypto_async_request *async_req, *backlog;
 	struct hifn_context *ctx;
 	struct ablkcipher_request *req;
 	unsigned long flags;
@@ -2166,12 +2172,16 @@ static int hifn_process_queue(struct hifn_device *dev)
 
 	while (dev->started < HIFN_QUEUE_LENGTH) {
 		spin_lock_irqsave(&dev->lock, flags);
+		backlog = crypto_get_backlog(&dev->queue);
 		async_req = crypto_dequeue_request(&dev->queue);
 		spin_unlock_irqrestore(&dev->lock, flags);
 
 		if (!async_req)
 			break;
 
+		if (backlog)
+			backlog->complete(backlog, -EINPROGRESS);
+
 		ctx = crypto_tfm_ctx(async_req->tfm);
 		req = container_of(async_req, struct ablkcipher_request, base);
 
@@ -2496,7 +2506,7 @@ static int hifn_cra_init(struct crypto_tfm *tfm)
 	struct hifn_context *ctx = crypto_tfm_ctx(tfm);
 
 	ctx->dev = ha->dev;
-
+	tfm->crt_ablkcipher.reqsize = sizeof(struct hifn_request_context);
 	return 0;
 }
 
@@ -2575,6 +2585,10 @@ static void hifn_tasklet_callback(unsigned long data)
 	 * context or update is atomic (like setting dev->sa[i] to NULL).
 	 */
 	hifn_check_for_completion(dev, 0);
+
+	if (dev->started < HIFN_QUEUE_LENGTH &&	dev->queue.qlen)
+		hifn_process_queue(dev);
+	//hifn_clear_rings(dev);
 }
 
 static int hifn_probe(struct pci_dev *pdev, const struct pci_device_id *id)
@@ -2631,22 +2645,11 @@ static int hifn_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 			goto err_out_unmap_bars;
 	}
 
-	dev->result_mem = __get_free_pages(GFP_KERNEL, HIFN_MAX_RESULT_ORDER);
-	if (!dev->result_mem) {
-		dprintk("Failed to allocate %d pages for result_mem.\n",
-				HIFN_MAX_RESULT_ORDER);
-		goto err_out_unmap_bars;
-	}
-	memset((void *)dev->result_mem, 0, PAGE_SIZE*(1<<HIFN_MAX_RESULT_ORDER));
-
-	dev->dst = pci_map_single(pdev, (void *)dev->result_mem,
-			PAGE_SIZE << HIFN_MAX_RESULT_ORDER, PCI_DMA_FROMDEVICE);
-
 	dev->desc_virt = pci_alloc_consistent(pdev, sizeof(struct hifn_dma),
 			&dev->desc_dma);
 	if (!dev->desc_virt) {
 		dprintk("Failed to allocate descriptor rings.\n");
-		goto err_out_free_result_pages;
+		goto err_out_unmap_bars;
 	}
 	memset(dev->desc_virt, 0, sizeof(struct hifn_dma));
 
@@ -2706,11 +2709,6 @@ err_out_free_desc:
 	pci_free_consistent(pdev, sizeof(struct hifn_dma),
 			dev->desc_virt, dev->desc_dma);
 
-err_out_free_result_pages:
-	pci_unmap_single(pdev, dev->dst, PAGE_SIZE << HIFN_MAX_RESULT_ORDER,
-			PCI_DMA_FROMDEVICE);
-	free_pages(dev->result_mem, HIFN_MAX_RESULT_ORDER);
