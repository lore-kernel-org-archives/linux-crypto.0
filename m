From: Phil Sutter <phil.sutter@viprinet.com>
Subject: [PATCH 06/13] mv_cesa: use TDMA engine for data transfers
Date: Fri, 25 May 2012 18:08:32 +0200
Message-ID: <1337962119-5509-7-git-send-email-phil.sutter@viprinet.com>
References: <1337962119-5509-1-git-send-email-phil.sutter@viprinet.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zimbra.vipri.net ([89.207.250.15]:47889 "EHLO zimbra.vipri.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753598Ab2EYQI5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 25 May 2012 12:08:57 -0400
In-Reply-To: <1337962119-5509-1-git-send-email-phil.sutter@viprinet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Simply chose the same DMA mask value as for mvsdio and ehci.

Signed-off-by: Phil Sutter <phil.sutter@viprinet.com>
---
 arch/arm/plat-orion/common.c |    6 +
 drivers/crypto/mv_cesa.c     |  214 +++++++++++++++++++++++++++++++++---------
 2 files changed, 175 insertions(+), 45 deletions(-)

diff --git a/arch/arm/plat-orion/common.c b/arch/arm/plat-orion/common.c
index 74daf5e..dd3a327 100644
--- a/arch/arm/plat-orion/common.c
+++ b/arch/arm/plat-orion/common.c
@@ -916,9 +916,15 @@ static struct resource orion_crypto_resources[] = {
 	},
 };
 
+static u64 mv_crypto_dmamask = DMA_BIT_MASK(32);
+
 static struct platform_device orion_crypto = {
 	.name           = "mv_crypto",
 	.id             = -1,
+	.dev		= {
+		.dma_mask = &mv_crypto_dmamask,
+		.coherent_dma_mask = DMA_BIT_MASK(32),
+	},
 };
 
 void __init orion_crypto_init(unsigned long mapbase,
diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
index 4a989ea..e10da2b 100644
--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@ -9,6 +9,7 @@
 #include <crypto/aes.h>
 #include <crypto/algapi.h>
 #include <linux/crypto.h>
+#include <linux/dma-mapping.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/kthread.h>
@@ -20,11 +21,14 @@
 #include <crypto/sha.h>
 
 #include "mv_cesa.h"
+#include "mv_tdma.h"
 
 #define MV_CESA	"MV-CESA:"
 #define MAX_HW_HASH_SIZE	0xFFFF
 #define MV_CESA_EXPIRE		500 /* msec */
 
+static int count_sgs(struct scatterlist *, unsigned int);
+
 /*
  * STM:
  *   /---------------------------------------\
@@ -49,7 +53,6 @@ enum engine_status {
  * @src_start:		offset to add to src start position (scatter list)
  * @crypt_len:		length of current hw crypt/hash process
  * @hw_nbytes:		total bytes to process in hw for this request
- * @copy_back:		whether to copy data back (crypt) or not (hash)
  * @sg_dst_left:	bytes left dst to process in this scatter list
  * @dst_start:		offset to add to dst start position (scatter list)
  * @hw_processed_bytes:	number of bytes processed by hw (request).
@@ -70,7 +73,6 @@ struct req_progress {
 	int crypt_len;
 	int hw_nbytes;
 	/* dst mostly */
-	int copy_back;
 	int sg_dst_left;
 	int dst_start;
 	int hw_processed_bytes;
@@ -95,8 +97,10 @@ struct sec_accel_sram {
 } __attribute__((packed));
 
 struct crypto_priv {
+	struct device *dev;
 	void __iomem *reg;
 	void __iomem *sram;
+	u32 sram_phys;
 	int irq;
 	struct task_struct *queue_th;
 
@@ -113,6 +117,7 @@ struct crypto_priv {
 	int has_hmac_sha1;
 
 	struct sec_accel_sram sa_sram;
+	dma_addr_t sa_sram_dma;
 };
 
 static struct crypto_priv *cpg;
@@ -181,6 +186,23 @@ static void mv_setup_timer(void)
 			jiffies + msecs_to_jiffies(MV_CESA_EXPIRE));
 }
 
+static inline bool
+mv_dma_map_sg(struct scatterlist *sg, int nbytes, enum dma_data_direction dir)
+{
+	int nents = count_sgs(sg, nbytes);
+
+	if (nbytes && dma_map_sg(cpg->dev, sg, nents, dir) != nents)
+		return false;
+	return true;
+}
+
+static inline void
+mv_dma_unmap_sg(struct scatterlist *sg, int nbytes, enum dma_data_direction dir)
+{
+	if (nbytes)
+		dma_unmap_sg(cpg->dev, sg, count_sgs(sg, nbytes), dir);
+}
+
 static void compute_aes_dec_key(struct mv_ctx *ctx)
 {
 	struct crypto_aes_ctx gen_aes_key;
@@ -255,12 +277,66 @@ static void copy_src_to_buf(struct req_progress *p, char *dbuf, int len)
 	}
 }
 
+static void dma_copy_src_to_buf(struct req_progress *p, dma_addr_t dbuf, int len)
+{
+	dma_addr_t sbuf;
+	int copy_len;
+
+	while (len) {
+		if (!p->sg_src_left) {
+			/* next sg please */
+			p->src_sg = sg_next(p->src_sg);
+			BUG_ON(!p->src_sg);
+			p->sg_src_left = sg_dma_len(p->src_sg);
+			p->src_start = 0;
+		}
+
+		sbuf = sg_dma_address(p->src_sg) + p->src_start;
+
+		copy_len = min(p->sg_src_left, len);
+		mv_tdma_memcpy(dbuf, sbuf, copy_len);
+
+		p->src_start += copy_len;
+		p->sg_src_left -= copy_len;
+
+		len -= copy_len;
+		dbuf += copy_len;
+	}
+}
+
+static void dma_copy_buf_to_dst(struct req_progress *p, dma_addr_t sbuf, int len)
+{
+	dma_addr_t dbuf;
+	int copy_len;
+
+	while (len) {
+		if (!p->sg_dst_left) {
+			/* next sg please */
+			p->dst_sg = sg_next(p->dst_sg);
+			BUG_ON(!p->dst_sg);
+			p->sg_dst_left = sg_dma_len(p->dst_sg);
+			p->dst_start = 0;
+		}
+
+		dbuf = sg_dma_address(p->dst_sg) + p->dst_start;
+
+		copy_len = min(p->sg_dst_left, len);
+		mv_tdma_memcpy(dbuf, sbuf, copy_len);
+
+		p->dst_start += copy_len;
+		p->sg_dst_left -= copy_len;
+
+		len -= copy_len;
+		sbuf += copy_len;
+	}
+}
+
 static void setup_data_in(void)
 {
 	struct req_progress *p = &cpg->p;
 	int data_in_sram =
 	    min(p->hw_nbytes - p->hw_processed_bytes, cpg->max_req_size);
-	copy_src_to_buf(p, cpg->sram + SRAM_DATA_IN_START + p->crypt_len,
+	dma_copy_src_to_buf(p, cpg->sram_phys + SRAM_DATA_IN_START + p->crypt_len,
 			data_in_sram - p->crypt_len);
 	p->crypt_len = data_in_sram;
 }
@@ -307,22 +383,39 @@ static void mv_init_crypt_config(struct ablkcipher_request *req)
 	op->enc_key_p = SRAM_DATA_KEY_P;
 	op->enc_len = cpg->p.crypt_len;
 
-	memcpy(cpg->sram + SRAM_CONFIG, &cpg->sa_sram,
+	dma_sync_single_for_device(cpg->dev, cpg->sa_sram_dma,
+			sizeof(struct sec_accel_sram), DMA_TO_DEVICE);
+	mv_tdma_memcpy(cpg->sram_phys + SRAM_CONFIG, cpg->sa_sram_dma,
 			sizeof(struct sec_accel_sram));
 
+	mv_tdma_separator();
+	dma_copy_buf_to_dst(&cpg->p, cpg->sram_phys + SRAM_DATA_OUT_START, cpg->p.crypt_len);
+
 	/* GO */
 	mv_setup_timer();
+	mv_tdma_trigger();
 	writel(SEC_CMD_EN_SEC_ACCL0, cpg->reg + SEC_ACCEL_CMD);
 }
 
 static void mv_update_crypt_config(void)
 {
+	struct sec_accel_config *op = &cpg->sa_sram.op;
+
 	/* update the enc_len field only */
-	memcpy(cpg->sram + SRAM_CONFIG + 2 * sizeof(u32),
-			&cpg->p.crypt_len, sizeof(u32));
+
+	op->enc_len = cpg->p.crypt_len;
+
+	dma_sync_single_for_device(cpg->dev, cpg->sa_sram_dma + 2 * sizeof(u32),
+			sizeof(u32), DMA_TO_DEVICE);
+	mv_tdma_memcpy(cpg->sram_phys + SRAM_CONFIG + 2 * sizeof(u32),
+			cpg->sa_sram_dma + 2 * sizeof(u32), sizeof(u32));
+
+	mv_tdma_separator();
+	dma_copy_buf_to_dst(&cpg->p, cpg->sram_phys + SRAM_DATA_OUT_START, cpg->p.crypt_len);
 
 	/* GO */
 	mv_setup_timer();
+	mv_tdma_trigger();
 	writel(SEC_CMD_EN_SEC_ACCL0, cpg->reg + SEC_ACCEL_CMD);
 }
 
@@ -331,6 +424,13 @@ static void mv_crypto_algo_completion(void)
 	struct ablkcipher_request *req = ablkcipher_request_cast(cpg->cur_req);
 	struct mv_req_ctx *req_ctx = ablkcipher_request_ctx(req);
 
+	if (req->src == req->dst) {
+		mv_dma_unmap_sg(req->src, req->nbytes, DMA_BIDIRECTIONAL);
+	} else {
+		mv_dma_unmap_sg(req->src, req->nbytes, DMA_TO_DEVICE);
+		mv_dma_unmap_sg(req->dst, req->nbytes, DMA_FROM_DEVICE);
+	}
+
 	if (req_ctx->op != COP_AES_CBC)
 		return ;
 
@@ -390,11 +490,20 @@ static void mv_init_hash_config(struct ahash_request *req)
 		writel(req_ctx->state[4], cpg->reg + DIGEST_INITIAL_VAL_E);
 	}
 
-	memcpy(cpg->sram + SRAM_CONFIG, &cpg->sa_sram,
+	dma_sync_single_for_device(cpg->dev, cpg->sa_sram_dma,
+			sizeof(struct sec_accel_sram), DMA_TO_DEVICE);
+	mv_tdma_memcpy(cpg->sram_phys + SRAM_CONFIG, cpg->sa_sram_dma,
 			sizeof(struct sec_accel_sram));
 
+	mv_tdma_separator();
+
+	/* XXX: this fixes some ugly register fuckup bug in the tdma engine
+	 *      (no need to sync since the data is ignored anyway) */
+	mv_tdma_memcpy(cpg->sa_sram_dma, cpg->sram_phys + SRAM_CONFIG, 1);
+
 	/* GO */
 	mv_setup_timer();
+	mv_tdma_trigger();
 	writel(SEC_CMD_EN_SEC_ACCL0, cpg->reg + SEC_ACCEL_CMD);
 }
 
@@ -424,13 +533,26 @@ static void mv_update_hash_config(void)
 		&& (req_ctx->count <= MAX_HW_HASH_SIZE);
 
 	op->config |= is_last ? CFG_LAST_FRAG : CFG_MID_FRAG;
-	memcpy(cpg->sram + SRAM_CONFIG, &op->config, sizeof(u32));
+	dma_sync_single_for_device(cpg->dev, cpg->sa_sram_dma,
+			sizeof(u32), DMA_TO_DEVICE);
+	mv_tdma_memcpy(cpg->sram_phys + SRAM_CONFIG,
+			cpg->sa_sram_dma, sizeof(u32));
 
 	op->mac_digest = MAC_DIGEST_P(SRAM_DIGEST_BUF) | MAC_FRAG_LEN(p->crypt_len);
-	memcpy(cpg->sram + SRAM_CONFIG + 6 * sizeof(u32), &op->mac_digest, sizeof(u32));
+	dma_sync_single_for_device(cpg->dev, cpg->sa_sram_dma + 6 * sizeof(u32),
+			sizeof(u32), DMA_TO_DEVICE);
+	mv_tdma_memcpy(cpg->sram_phys + SRAM_CONFIG + 6 * sizeof(u32),
+			cpg->sa_sram_dma + 6 * sizeof(u32), sizeof(u32));
+
+	mv_tdma_separator();
+
+	/* XXX: this fixes some ugly register fuckup bug in the tdma engine
+	 *      (no need to sync since the data is ignored anyway) */
+	mv_tdma_memcpy(cpg->sa_sram_dma, cpg->sram_phys + SRAM_CONFIG, 1);
 
 	/* GO */
 	mv_setup_timer();
+	mv_tdma_trigger();
 	writel(SEC_CMD_EN_SEC_ACCL0, cpg->reg + SEC_ACCEL_CMD);
 }
 
@@ -504,43 +626,18 @@ static void mv_hash_algo_completion(void)
 	} else {
 		mv_save_digest_state(ctx);
 	}
+
+	mv_dma_unmap_sg(req->src, req->nbytes, DMA_TO_DEVICE);
 }
 
 static void dequeue_complete_req(void)
 {
 	struct crypto_async_request *req = cpg->cur_req;
-	void *buf;
 	cpg->p.hw_processed_bytes += cpg->p.crypt_len;
-	if (cpg->p.copy_back) {
-		int need_copy_len = cpg->p.crypt_len;
-		int sram_offset = 0;
-		do {
-			int dst_copy;
-
-			if (!cpg->p.sg_dst_left) {
-				/* next sg please */
-				cpg->p.dst_sg = sg_next(cpg->p.dst_sg);
-				BUG_ON(!cpg->p.dst_sg);
-				cpg->p.sg_dst_left = cpg->p.dst_sg->length;
-				cpg->p.dst_start = 0;
-			}
-
-			buf = sg_virt(cpg->p.dst_sg) + cpg->p.dst_start;
-
-			dst_copy = min(need_copy_len, cpg->p.sg_dst_left);
-
-			memcpy(buf,
-			       cpg->sram + SRAM_DATA_OUT_START + sram_offset,
-			       dst_copy);
-			sram_offset += dst_copy;
-			cpg->p.sg_dst_left -= dst_copy;
-			need_copy_len -= dst_copy;
-			cpg->p.dst_start += dst_copy;
-		} while (need_copy_len > 0);
-	}
-
 	cpg->p.crypt_len = 0;
 
+	mv_tdma_clear();
+
 	BUG_ON(cpg->eng_st != ENGINE_W_DEQUEUE);
 	if (cpg->p.hw_processed_bytes < cpg->p.hw_nbytes) {
 		/* process next scatter list entry */
@@ -582,15 +679,28 @@ static void mv_start_new_crypt_req(struct ablkcipher_request *req)
 	p->hw_nbytes = req->nbytes;
 	p->complete = mv_crypto_algo_completion;
 	p->process = mv_update_crypt_config;
-	p->copy_back = 1;
+
+	/* assume inplace request */
+	if (req->src == req->dst) {
+		if (!mv_dma_map_sg(req->src, req->nbytes, DMA_BIDIRECTIONAL))
+			return;
+	} else {
+		if (!mv_dma_map_sg(req->src, req->nbytes, DMA_TO_DEVICE))
+			return;
+
+		if (!mv_dma_map_sg(req->dst, req->nbytes, DMA_FROM_DEVICE)) {
+			mv_dma_unmap_sg(req->src, req->nbytes, DMA_TO_DEVICE);
+			return;
+		}
+	}
 
 	p->src_sg = req->src;
 	p->dst_sg = req->dst;
 	if (req->nbytes) {
 		BUG_ON(!req->src);
 		BUG_ON(!req->dst);
-		p->sg_src_left = req->src->length;
-		p->sg_dst_left = req->dst->length;
+		p->sg_src_left = sg_dma_len(req->src);
+		p->sg_dst_left = sg_dma_len(req->dst);
 	}
 
 	setup_data_in();
@@ -602,6 +712,7 @@ static void mv_start_new_hash_req(struct ahash_request *req)
 	struct req_progress *p = &cpg->p;
 	struct mv_req_hash_ctx *ctx = ahash_request_ctx(req);
 	int hw_bytes, old_extra_bytes, rc;
+
 	cpg->cur_req = &req->base;
 	memset(p, 0, sizeof(struct req_progress));
 	hw_bytes = req->nbytes + ctx->extra_bytes;
@@ -631,6 +742,11 @@ static void mv_start_new_hash_req(struct ahash_request *req)
 			p->crypt_len = old_extra_bytes;
 		}
 
+		if (!mv_dma_map_sg(req->src, req->nbytes, DMA_TO_DEVICE)) {
+			printk(KERN_ERR "%s: out of memory\n", __func__);
+			return;
+		}
+
 		setup_data_in();
 		mv_init_hash_config(req);
 	} else {
@@ -966,14 +1082,14 @@ irqreturn_t crypto_int(int irq, void *priv)
 	u32 val;
 
 	val = readl(cpg->reg + SEC_ACCEL_INT_STATUS);
-	if (!(val & SEC_INT_ACCEL0_DONE))
+	if (!(val & SEC_INT_ACC0_IDMA_DONE))
 		return IRQ_NONE;
 
 	if (!del_timer(&cpg->completion_timer)) {
 		printk(KERN_WARNING MV_CESA
 		       "got an interrupt but no pending timer?\n");
 	}
-	val &= ~SEC_INT_ACCEL0_DONE;
+	val &= ~SEC_INT_ACC0_IDMA_DONE;
 	writel(val, cpg->reg + SEC_ACCEL_INT_STATUS);
 	BUG_ON(cpg->eng_st != ENGINE_BUSY);
 	cpg->eng_st = ENGINE_W_DEQUEUE;
@@ -1112,6 +1228,7 @@ static int mv_probe(struct platform_device *pdev)
 	}
 	cp->sram_size = resource_size(res);
 	cp->max_req_size = cp->sram_size - SRAM_CFG_SPACE;
+	cp->sram_phys = res->start;
 	cp->sram = ioremap(res->start, cp->sram_size);
 	if (!cp->sram) {
 		ret = -ENOMEM;
@@ -1127,6 +1244,7 @@ static int mv_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, cp);
 	cpg = cp;
+	cpg->dev = &pdev->dev;
 
 	cp->queue_th = kthread_run(queue_manag, cp, "mv_crypto");
 	if (IS_ERR(cp->queue_th)) {
@@ -1140,10 +1258,14 @@ static int mv_probe(struct platform_device *pdev)
 		goto err_thread;
 
 	writel(0, cpg->reg + SEC_ACCEL_INT_STATUS);
-	writel(SEC_INT_ACCEL0_DONE, cpg->reg + SEC_ACCEL_INT_MASK);
-	writel(SEC_CFG_STOP_DIG_ERR, cpg->reg + SEC_ACCEL_CFG);
+	writel(SEC_INT_ACC0_IDMA_DONE, cpg->reg + SEC_ACCEL_INT_MASK);
+	writel((SEC_CFG_STOP_DIG_ERR | SEC_CFG_CH0_W_IDMA |
+	        SEC_CFG_ACT_CH0_IDMA), cpg->reg + SEC_ACCEL_CFG);
 	writel(SRAM_CONFIG, cpg->reg + SEC_ACCEL_DESC_P0);
 
+	cp->sa_sram_dma = dma_map_single(&pdev->dev, &cp->sa_sram,
+			sizeof(struct sec_accel_sram), DMA_TO_DEVICE);
+
 	ret = crypto_register_alg(&mv_aes_alg_ecb);
 	if (ret) {
 		printk(KERN_WARNING MV_CESA
@@ -1202,6 +1324,8 @@ static int mv_remove(struct platform_device *pdev)
 		crypto_unregister_ahash(&mv_hmac_sha1_alg);
 	kthread_stop(cp->queue_th);
 	free_irq(cp->irq, cp);
+	dma_unmap_single(&pdev->dev, cpg->sa_sram_dma,
+			sizeof(struct sec_accel_sram), DMA_TO_DEVICE);
 	memset(cp->sram, 0, cp->sram_size);
 	iounmap(cp->sram);
 	iounmap(cp->reg);
-- 
1.7.3.4
