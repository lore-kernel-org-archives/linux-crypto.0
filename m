From: Evgeniy Polyakov <zbr@ioremap.net>
Subject: [PATCH] Fix queue management.
Date: Wed, 19 Nov 2008 17:03:33 +0300
Message-ID: <1227103414719-git-send-email-zbr@ioremap.net>
References: <12271034133347-git-send-email-zbr@ioremap.net>
 <12271034132587-git-send-email-zbr@ioremap.net>
 <12271034131753-git-send-email-zbr@ioremap.net>
 <1227103414646-git-send-email-zbr@ioremap.net>
 <1227103414418-git-send-email-zbr@ioremap.net>
 <12271034142436-git-send-email-zbr@ioremap.net>
 <12271034143351-git-send-email-zbr@ioremap.net>
 <1227103414231-git-send-email-zbr@ioremap.net>
Cc: linux-crypto@vger.kernel.org, Evgeniy Polyakov <zbr@ioremap.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zbr.yandex.ru ([213.180.219.33]:37390 "EHLO gavana.yandex.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753993AbYKSOH4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 19 Nov 2008 09:07:56 -0500
In-Reply-To: <1227103414231-git-send-email-zbr@ioremap.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fix queue management. Change ring size and perform its check not
one after another descriptor, but using stored pointers to the last
checked descriptors.

Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>
---
 drivers/crypto/hifn_795x.c |  174 ++++++++++++++++++++-----------------------
 1 files changed, 81 insertions(+), 93 deletions(-)

diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index 73aef49..26384e7 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -360,14 +360,14 @@ static atomic_t hifn_dev_number;
 #define HIFN_NAMESIZE			32
 #define HIFN_MAX_RESULT_ORDER		5
 
-#define	HIFN_D_CMD_RSIZE		24*4
-#define	HIFN_D_SRC_RSIZE		80*4
-#define	HIFN_D_DST_RSIZE		80*4
-#define	HIFN_D_RES_RSIZE		24*4
+#define	HIFN_D_CMD_RSIZE		24*1
+#define	HIFN_D_SRC_RSIZE		80*1
+#define	HIFN_D_DST_RSIZE		80*1
+#define	HIFN_D_RES_RSIZE		24*1
 
 #define HIFN_D_DST_DALIGN		4
 
-#define HIFN_QUEUE_LENGTH		HIFN_D_CMD_RSIZE-1
+#define HIFN_QUEUE_LENGTH		(HIFN_D_CMD_RSIZE - 1)
 
 #define AES_MIN_KEY_SIZE		16
 #define AES_MAX_KEY_SIZE		32
@@ -1256,6 +1256,7 @@ static int hifn_setup_cmd_desc(struct hifn_device *dev,
 	}
 
 	dev->sa[sa_idx] = priv;
+	dev->started++;
 
 	cmd_len = buf_pos - buf;
 	dma->cmdr[dma->cmdi].l = __cpu_to_le32(cmd_len | HIFN_D_VALID |
@@ -1382,9 +1383,6 @@ static int hifn_setup_dma(struct hifn_device *dev,
 		soff = src->offset;
 		len = min(src->length, n);
 
-		dprintk("%s: spage: %p, soffset: %u, nbytes: %u, "
-			"priv: %p, rctx: %p.\n",
-			dev->name, spage, soff, nbytes, priv, rctx);
 		hifn_setup_src_desc(dev, spage, soff, len, n - len == 0);
 
 		src++;
@@ -1405,9 +1403,6 @@ static int hifn_setup_dma(struct hifn_device *dev,
 		}
 		len = min(len, n);
 
-		dprintk("%s: dpage: %p, doffset: %u, nbytes: %u, "
-			"priv: %p, rctx: %p.\n",
-			dev->name, dpage, doff, nbytes, priv, rctx);
 		hifn_setup_dst_desc(dev, dpage, doff, len, n - len == 0);
 
 		dst++;
@@ -1620,13 +1615,12 @@ static int hifn_setup_session(struct ablkcipher_request *req)
 		goto err_out;
 	}
 
-	dev->snum++;
-	dev->started++;
-
 	err = hifn_setup_dma(dev, ctx, rctx, req->src, req->dst, req->nbytes, req);
 	if (err)
 		goto err_out;
 
+	dev->snum++;
+
 	dev->active = HIFN_DEFAULT_ACTIVE_NUM;
 	spin_unlock_irqrestore(&dev->lock, flags);
 
@@ -1635,12 +1629,13 @@ static int hifn_setup_session(struct ablkcipher_request *req)
 err_out:
 	spin_unlock_irqrestore(&dev->lock, flags);
 err_out_exit:
-	if (err)
-		dprintk("%s: iv: %p [%d], key: %p [%d], mode: %u, op: %u, "
+	if (err) {
+		printk("%s: iv: %p [%d], key: %p [%d], mode: %u, op: %u, "
 				"type: %u, err: %d.\n",
 			dev->name, rctx->iv, rctx->ivsize,
 			ctx->key, ctx->keysize,
 			rctx->mode, rctx->op, rctx->type, err);
+	}
 
 	return err;
 }
@@ -1676,6 +1671,7 @@ static int hifn_test(struct hifn_device *dev, int encdec, u8 snum)
 	if (err)
 		goto err_out;
 
+	dev->started = 0;
 	msleep(200);
 
 	dprintk("%s: decoded: ", dev->name);
@@ -1702,6 +1698,7 @@ static int hifn_start_device(struct hifn_device *dev)
 {
 	int err;
 
+	dev->started = dev->active = 0;
 	hifn_reset_dma(dev, 1);
 
 	err = hifn_enable_crypto(dev);
@@ -1755,19 +1752,22 @@ static int ablkcipher_get(void *saddr, unsigned int *srestp, unsigned int offset
 	return idx;
 }
 
-static void hifn_process_ready(struct ablkcipher_request *req, int error)
+static inline void hifn_complete_sa(struct hifn_device *dev, int i)
 {
-	struct hifn_context *ctx = crypto_tfm_ctx(req->base.tfm);
-	struct hifn_request_context *rctx = ablkcipher_request_ctx(req);
-	struct hifn_device *dev;
-
-	dprintk("%s: req: %p, ctx: %p rctx: %p.\n", __func__, req, ctx, rctx);
+	unsigned long flags;
 
-	dev = ctx->dev;
-	dprintk("%s: req: %p, started: %d.\n", __func__, req, dev->started);
+	spin_lock_irqsave(&dev->lock, flags);
+	dev->sa[i] = NULL;
+	dev->started--;
+	if (dev->started < 0)
+		printk("%s: started: %d.\n", __func__, dev->started);
+	spin_unlock_irqrestore(&dev->lock, flags);
+	BUG_ON(dev->started < 0);
+}
 
-	if (--dev->started < 0)
-		BUG();
+static void hifn_process_ready(struct ablkcipher_request *req, int error)
+{
+	struct hifn_request_context *rctx = ablkcipher_request_ctx(req);
 
 	if (rctx->walk.flags & ASYNC_FLAGS_MISALIGNED) {
 		unsigned int nbytes = req->nbytes;
@@ -1810,33 +1810,7 @@ static void hifn_process_ready(struct ablkcipher_request *req, int error)
 	req->base.complete(&req->base, error);
 }
 
-static void hifn_check_for_completion(struct hifn_device *dev, int error)
-{
-	int i;
-	struct hifn_dma *dma = (struct hifn_dma *)dev->desc_virt;
-
-	for (i=0; i<HIFN_D_RES_RSIZE; ++i) {
-		struct hifn_desc *d = &dma->resr[i];
-
-		if (!(d->l & __cpu_to_le32(HIFN_D_VALID)) && dev->sa[i]) {
-			dev->success++;
-			dev->reset = 0;
-			hifn_process_ready(dev->sa[i], error);
-			dev->sa[i] = NULL;
-		}
-
-		if (d->l & __cpu_to_le32(HIFN_D_DESTOVER | HIFN_D_OVER))
-			if (printk_ratelimit())
-				printk("%s: overflow detected [d: %u, o: %u] "
-						"at %d resr: l: %08x, p: %08x.\n",
-					dev->name,
-					!!(d->l & __cpu_to_le32(HIFN_D_DESTOVER)),
-					!!(d->l & __cpu_to_le32(HIFN_D_OVER)),
-					i, d->l, d->p);
-	}
-}
-
-static void hifn_clear_rings(struct hifn_device *dev)
+static void hifn_clear_rings(struct hifn_device *dev, int error)
 {
 	struct hifn_dma *dma = (struct hifn_dma *)dev->desc_virt;
 	int i, u;
@@ -1853,21 +1827,26 @@ static void hifn_clear_rings(struct hifn_device *dev)
 		if (dma->resr[i].l & __cpu_to_le32(HIFN_D_VALID))
 			break;
 
-		if (i != HIFN_D_RES_RSIZE)
-			u--;
+		if (dev->sa[i]) {
+			dev->success++;
+			dev->reset = 0;
+			hifn_process_ready(dev->sa[i], error);
+			hifn_complete_sa(dev, i);
+		}
 
-		if (++i == (HIFN_D_RES_RSIZE + 1))
+		if (++i == HIFN_D_RES_RSIZE)
 			i = 0;
+		u--;
 	}
 	dma->resk = i; dma->resu = u;
 
 	i = dma->srck; u = dma->srcu;
 	while (u != 0) {
-		if (i == HIFN_D_SRC_RSIZE)
-			i = 0;
 		if (dma->srcr[i].l & __cpu_to_le32(HIFN_D_VALID))
 			break;
-		i++, u--;
+		if (++i == HIFN_D_SRC_RSIZE)
+			i = 0;
+		u--;
 	}
 	dma->srck = i; dma->srcu = u;
 
@@ -1875,20 +1854,19 @@ static void hifn_clear_rings(struct hifn_device *dev)
 	while (u != 0) {
 		if (dma->cmdr[i].l & __cpu_to_le32(HIFN_D_VALID))
 			break;
-		if (i != HIFN_D_CMD_RSIZE)
-			u--;
-		if (++i == (HIFN_D_CMD_RSIZE + 1))
+		if (++i == HIFN_D_CMD_RSIZE)
 			i = 0;
+		u--;
 	}
 	dma->cmdk = i; dma->cmdu = u;
 
 	i = dma->dstk; u = dma->dstu;
 	while (u != 0) {
-		if (i == HIFN_D_DST_RSIZE)
-			i = 0;
 		if (dma->dstr[i].l & __cpu_to_le32(HIFN_D_VALID))
 			break;
-		i++, u--;
+		if (++i == HIFN_D_DST_RSIZE)
+			i = 0;
+		u--;
 	}
 	dma->dstk = i; dma->dstu = u;
 
@@ -1933,30 +1911,39 @@ static void hifn_work(struct work_struct *work)
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
+			struct hifn_dma *dma = (struct hifn_dma *)dev->desc_virt;
+
+			printk("%s: r: %08x, active: %d, started: %d, "
+				"success: %lu: qlen: %u/%u, reset: %d.\n",
+				dev->name, r, dev->active, dev->started,
+				dev->success, dev->queue.qlen, dev->queue.max_qlen,
+				reset);
+
+			printk("%s: res: ", __func__);
+			for (i=0; i<HIFN_D_RES_RSIZE; ++i) {
+				printk("%x.%p ", dma->resr[i].l, dev->sa[i]);
+				if (dev->sa[i]) {
+					hifn_process_ready(dev->sa[i], -ENODEV);
+					hifn_complete_sa(dev, i);
+				}
+			}
+			printk("\n");
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
@@ -1973,8 +1960,8 @@ static irqreturn_t hifn_interrupt(int irq, void *data)
 	dprintk("%s: 1 dmacsr: %08x, dmareg: %08x, res: %08x [%d], "
 			"i: %d.%d.%d.%d, u: %d.%d.%d.%d.\n",
 		dev->name, dmacsr, dev->dmareg, dmacsr & dev->dmareg, dma->cmdi,
-		dma->cmdu, dma->srcu, dma->dstu, dma->resu,
-		dma->cmdi, dma->srci, dma->dsti, dma->resi);
+		dma->cmdi, dma->srci, dma->dsti, dma->resi,
+		dma->cmdu, dma->srcu, dma->dstu, dma->resu);
 
 	if ((dmacsr & dev->dmareg) == 0)
 		return IRQ_NONE;
@@ -1991,11 +1978,10 @@ static irqreturn_t hifn_interrupt(int irq, void *data)
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
@@ -2005,12 +1991,11 @@ static irqreturn_t hifn_interrupt(int irq, void *data)
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
@@ -2023,7 +2008,6 @@ static irqreturn_t hifn_interrupt(int irq, void *data)
 	}
 
 	tasklet_schedule(&dev->tasklet);
-	hifn_clear_rings(dev);
 
 	return IRQ_HANDLED;
 }
@@ -2037,21 +2021,25 @@ static void hifn_flush(struct hifn_device *dev)
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
@@ -2568,7 +2556,7 @@ static void hifn_tasklet_callback(unsigned long data)
 	 * (like dev->success), but they are used in process
 	 * context or update is atomic (like setting dev->sa[i] to NULL).
 	 */
-	hifn_check_for_completion(dev, 0);
+	hifn_clear_rings(dev, 0);
 
 	if (dev->started < HIFN_QUEUE_LENGTH &&	dev->queue.qlen)
 		hifn_process_queue(dev);
-- 
1.5.2.5

