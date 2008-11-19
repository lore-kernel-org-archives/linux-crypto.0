From: Evgeniy Polyakov <zbr@ioremap.net>
Subject: [PATCH] Fix DMA setup.
Date: Wed, 19 Nov 2008 17:03:28 +0300
Message-ID: <1227103414646-git-send-email-zbr@ioremap.net>
References: <12271034133347-git-send-email-zbr@ioremap.net>
 <12271034132587-git-send-email-zbr@ioremap.net>
 <12271034131753-git-send-email-zbr@ioremap.net>
Cc: linux-crypto@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
	Evgeniy Polyakov <zbr@ioremap.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zbr.yandex.ru ([213.180.219.33]:37391 "EHLO gavana.yandex.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753221AbYKSOH5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 19 Nov 2008 09:07:57 -0500
In-Reply-To: <12271034131753-git-send-email-zbr@ioremap.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>
---
 drivers/crypto/hifn_795x.c |  165 +++++++++++++++++++++----------------------
 1 files changed, 81 insertions(+), 84 deletions(-)

diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index 4d22b21..89e2e9a 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -662,7 +662,6 @@ struct hifn_context
 	unsigned int		keysize, ivsize;
 	u8			op, type, mode, unused;
 	struct ablkcipher_walk	walk;
-	atomic_t		sg_num;
 };
 
 #define crypto_alg_to_hifn(a)	container_of(a, struct hifn_crypto_alg, alg)
@@ -1284,7 +1283,7 @@ err_out:
 }
 
 static int hifn_setup_src_desc(struct hifn_device *dev, struct page *page,
-		unsigned int offset, unsigned int size)
+		unsigned int offset, unsigned int size, int last)
 {
 	struct hifn_dma *dma = (struct hifn_dma *)dev->desc_virt;
 	int idx;
@@ -1296,12 +1295,12 @@ static int hifn_setup_src_desc(struct hifn_device *dev, struct page *page,
 
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
 
@@ -1342,7 +1341,7 @@ static void hifn_setup_res_desc(struct hifn_device *dev)
 }
 
 static void hifn_setup_dst_desc(struct hifn_device *dev, struct page *page,
-		unsigned offset, unsigned size)
+		unsigned offset, unsigned size, int last)
 {
 	struct hifn_dma *dma = (struct hifn_dma *)dev->desc_virt;
 	int idx;
@@ -1353,12 +1352,12 @@ static void hifn_setup_dst_desc(struct hifn_device *dev, struct page *page,
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
@@ -1370,16 +1369,47 @@ static void hifn_setup_dst_desc(struct hifn_device *dev, struct page *page,
 	}
 }
 
-static int hifn_setup_dma(struct hifn_device *dev, struct page *spage, unsigned int soff,
-		struct page *dpage, unsigned int doff, unsigned int nbytes, void *priv,
-		struct hifn_context *ctx)
+static int hifn_setup_dma(struct hifn_device *dev, struct hifn_context *ctx,
+		struct scatterlist *src, struct scatterlist *dst,
+		unsigned int nbytes, void *priv)
 {
-	dprintk("%s: spage: %p, soffset: %u, dpage: %p, doffset: %u, nbytes: %u, priv: %p, ctx: %p.\n",
+	struct scatterlist *t;
+	struct page *spage, *dpage;
+	unsigned int soff, doff;
+	unsigned int n, len;
+
+	t = &ctx->walk.cache[0];
+	n = nbytes;
+	while (n) {
+		if (t->length) {
+			spage = dpage = sg_page(t);
+			soff = doff = 0;
+			len = t->length;
+		} else {
+			spage = sg_page(src);
+			soff = src->offset;
+
+			dpage = sg_page(dst);
+			doff = dst->offset;
+
+			len = dst->length;
+		}
+		len = min(len, n);
+
+		dprintk("%s: spage: %p, soffset: %u, dpage: %p, doffset: %u, "
+			"nbytes: %u, priv: %p, ctx: %p.\n",
 			dev->name, spage, soff, dpage, doff, nbytes, priv, ctx);
 
-	hifn_setup_src_desc(dev, spage, soff, nbytes);
+		hifn_setup_src_desc(dev, spage, soff, len, n - len == 0);
+		hifn_setup_dst_desc(dev, dpage, doff, len, n - len == 0);
+
+		src++;
+		dst++;
+		t++;
+		n -= len;
+	}
+
 	hifn_setup_cmd_desc(dev, ctx, priv, nbytes);
-	hifn_setup_dst_desc(dev, dpage, doff, nbytes);
 	hifn_setup_res_desc(dev);
 	return 0;
 }
@@ -1560,11 +1590,10 @@ static int hifn_setup_session(struct ablkcipher_request *req)
 {
 	struct hifn_context *ctx = crypto_tfm_ctx(req->base.tfm);
 	struct hifn_device *dev = ctx->dev;
-	struct page *spage, *dpage;
-	unsigned long soff, doff, dlen, flags;
-	unsigned int nbytes = req->nbytes, idx = 0, len;
+	unsigned long dlen, flags;
+	unsigned int nbytes = req->nbytes, idx = 0;
 	int err = -EINVAL, sg_num;
-	struct scatterlist *src, *dst, *t;
+	struct scatterlist *dst;
 
 	if (ctx->iv && !ctx->ivsize && ctx->mode != ACRYPTO_MODE_ECB)
 		goto err_out_exit;
@@ -1589,15 +1618,11 @@ static int hifn_setup_session(struct ablkcipher_request *req)
 			return err;
 	}
 
-	nbytes = req->nbytes;
-	idx = 0;
-
 	sg_num = ablkcipher_walk(req, &ctx->walk);
 	if (sg_num < 0) {
 		err = sg_num;
 		goto err_out_exit;
 	}
-	atomic_set(&ctx->sg_num, sg_num);
 
 	spin_lock_irqsave(&dev->lock, flags);
 	if (dev->started + sg_num > HIFN_QUEUE_LENGTH) {
@@ -1606,36 +1631,11 @@ static int hifn_setup_session(struct ablkcipher_request *req)
 	}
 
 	dev->snum++;
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
+	dev->started++;
 
-		err = hifn_setup_dma(dev, spage, soff, dpage, doff, nbytes,
-				req, ctx);
-		if (err)
-			goto err_out;
-
-		nbytes -= min(len, nbytes);
-	}
+	err = hifn_setup_dma(dev, ctx, req->src, req->dst, req->nbytes, req);
+	if (err)
+		goto err_out;
 
 	dev->active = HIFN_DEFAULT_ACTIVE_NUM;
 	spin_unlock_irqrestore(&dev->lock, flags);
@@ -1665,6 +1665,7 @@ static int hifn_test(struct hifn_device *dev, int encdec, u8 snum)
 		0xEF, 0x8A, 0x2C, 0x3B,
 		0x88, 0x4C, 0xFA, 0x59,
 		0xCA, 0x34, 0x2B, 0x2E};
+	struct scatterlist sg;
 
 	memset(src, 0, sizeof(src));
 	memset(ctx.key, 0, sizeof(ctx.key));
@@ -1676,12 +1677,11 @@ static int hifn_test(struct hifn_device *dev, int encdec, u8 snum)
 	ctx.op = (encdec)?ACRYPTO_OP_ENCRYPT:ACRYPTO_OP_DECRYPT;
 	ctx.mode = ACRYPTO_MODE_ECB;
 	ctx.type = ACRYPTO_TYPE_AES_128;
-	atomic_set(&ctx.sg_num, 1);
+	ctx.walk.cache[0].length = 0;
 
-	err = hifn_setup_dma(dev,
-			virt_to_page(src), offset_in_page(src),
-			virt_to_page(src), offset_in_page(src),
-			sizeof(src), NULL, &ctx);
+	sg_init_one(&sg, &src, sizeof(src));
+
+	err = hifn_setup_dma(dev, &ctx, &sg, &sg, sizeof(src), NULL);
 	if (err)
 		goto err_out;
 
@@ -1772,53 +1772,50 @@ static void hifn_process_ready(struct ablkcipher_request *req, int error)
 	dprintk("%s: req: %p, ctx: %p.\n", __func__, req, ctx);
 
 	dev = ctx->dev;
-	dprintk("%s: req: %p, started: %d, sg_num: %d.\n",
-		__func__, req, dev->started, atomic_read(&ctx->sg_num));
+	dprintk("%s: req: %p, started: %d.\n", __func__, req, dev->started);
 
 	if (--dev->started < 0)
 		BUG();
 
-	if (atomic_dec_and_test(&ctx->sg_num)) {
+	if (ctx->walk.flags & ASYNC_FLAGS_MISALIGNED) {
 		unsigned int nbytes = req->nbytes;
 		int idx = 0, err;
 		struct scatterlist *dst, *t;
 		void *saddr;
 
-		if (ctx->walk.flags & ASYNC_FLAGS_MISALIGNED) {
-			while (nbytes) {
-				t = &ctx->walk.cache[idx];
-				dst = &req->dst[idx];
+		while (nbytes) {
+			t = &ctx->walk.cache[idx];
+			dst = &req->dst[idx];
 
-				dprintk("\n%s: sg_page(t): %p, t->length: %u, "
-					"sg_page(dst): %p, dst->length: %u, "
-					"nbytes: %u.\n",
-					__func__, sg_page(t), t->length,
-					sg_page(dst), dst->length, nbytes);
-
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
+		ablkcipher_walk_exit(&ctx->walk);
 	}
+
+	req->base.complete(&req->base, error);
 }
 
 static void hifn_check_for_completion(struct hifn_device *dev, int error)
-- 
1.5.2.5

