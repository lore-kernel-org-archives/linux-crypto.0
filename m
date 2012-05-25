From: Phil Sutter <phil.sutter@viprinet.com>
Subject: [PATCH 09/13] mv_cesa: implementing packet chain mode, only aes for now
Date: Fri, 25 May 2012 18:08:35 +0200
Message-ID: <1337962119-5509-10-git-send-email-phil.sutter@viprinet.com>
References: <1337962119-5509-1-git-send-email-phil.sutter@viprinet.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zimbra.vipri.net ([89.207.250.15]:47911 "EHLO zimbra.vipri.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932399Ab2EYQJD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 25 May 2012 12:09:03 -0400
In-Reply-To: <1337962119-5509-1-git-send-email-phil.sutter@viprinet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This introduces a pool of four-byte DMA buffers for security
accelerator config updates.

Signed-off-by: Phil Sutter <phil.sutter@viprinet.com>
---
 drivers/crypto/mv_cesa.c |  134 ++++++++++++++++++++++++++++++++++++----------
 drivers/crypto/mv_cesa.h |    1 +
 2 files changed, 106 insertions(+), 29 deletions(-)

diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
index bc2692e..8e66080 100644
--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@ -10,6 +10,7 @@
 #include <crypto/algapi.h>
 #include <linux/crypto.h>
 #include <linux/dma-mapping.h>
+#include <linux/dmapool.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/kthread.h>
@@ -27,6 +28,9 @@
 #define MAX_HW_HASH_SIZE	0xFFFF
 #define MV_CESA_EXPIRE		500 /* msec */
 
+#define MV_DMA_INIT_POOLSIZE 16
+#define MV_DMA_ALIGN 16
+
 static int count_sgs(struct scatterlist *, unsigned int);
 
 /*
@@ -96,6 +100,11 @@ struct sec_accel_sram {
 #define sa_ivo	type.hash.ivo
 } __attribute__((packed));
 
+struct u32_mempair {
+	u32 *vaddr;
+	dma_addr_t daddr;
+};
+
 struct crypto_priv {
 	struct device *dev;
 	void __iomem *reg;
@@ -118,6 +127,11 @@ struct crypto_priv {
 
 	struct sec_accel_sram sa_sram;
 	dma_addr_t sa_sram_dma;
+
+	struct dma_pool *u32_pool;
+	struct u32_mempair *u32_list;
+	int u32_list_len;
+	int u32_usage;
 };
 
 static struct crypto_priv *cpg;
@@ -189,6 +203,54 @@ static void mv_setup_timer(void)
 			jiffies + msecs_to_jiffies(MV_CESA_EXPIRE));
 }
 
+#define U32_ITEM(x)		(cpg->u32_list[x].vaddr)
+#define U32_ITEM_DMA(x)		(cpg->u32_list[x].daddr)
+
+static inline int set_u32_poolsize(int nelem)
+{
+	/* need to increase size first if requested */
+	if (nelem > cpg->u32_list_len) {
+		struct u32_mempair *newmem;
+		int newsize = nelem * sizeof(struct u32_mempair);
+
+		newmem = krealloc(cpg->u32_list, newsize, GFP_KERNEL);
+		if (!newmem)
+			return -ENOMEM;
+		cpg->u32_list = newmem;
+	}
+
+	/* allocate/free dma descriptors, adjusting cpg->u32_list_len on the go */
+	for (; cpg->u32_list_len < nelem; cpg->u32_list_len++) {
+		U32_ITEM(cpg->u32_list_len) = dma_pool_alloc(cpg->u32_pool,
+				GFP_KERNEL, &U32_ITEM_DMA(cpg->u32_list_len));
+		if (!U32_ITEM((cpg->u32_list_len)))
+			return -ENOMEM;
+	}
+	for (; cpg->u32_list_len > nelem; cpg->u32_list_len--)
+		dma_pool_free(cpg->u32_pool, U32_ITEM(cpg->u32_list_len - 1),
+				U32_ITEM_DMA(cpg->u32_list_len - 1));
+
+	/* ignore size decreases but those to zero */
+	if (!nelem) {
+		kfree(cpg->u32_list);
+		cpg->u32_list = 0;
+	}
+	return 0;
+}
+
+static inline void mv_tdma_u32_copy(dma_addr_t dst, u32 val)
+{
+	if (unlikely(cpg->u32_usage == cpg->u32_list_len)
+	    && set_u32_poolsize(cpg->u32_list_len << 1)) {
+		printk(KERN_ERR MV_CESA "resizing poolsize to %d failed\n",
+				cpg->u32_list_len << 1);
+		return;
+	}
+	*(U32_ITEM(cpg->u32_usage)) = val;
+	mv_tdma_memcpy(dst, U32_ITEM_DMA(cpg->u32_usage), sizeof(u32));
+	cpg->u32_usage++;
+}
+
 static inline bool
 mv_dma_map_sg(struct scatterlist *sg, int nbytes, enum dma_data_direction dir)
 {
@@ -390,36 +452,13 @@ static void mv_init_crypt_config(struct ablkcipher_request *req)
 			sizeof(struct sec_accel_sram), DMA_TO_DEVICE);
 	mv_tdma_memcpy(cpg->sram_phys + SRAM_CONFIG, cpg->sa_sram_dma,
 			sizeof(struct sec_accel_sram));
-
-	mv_tdma_separator();
-	dma_copy_buf_to_dst(&cpg->p, cpg->sram_phys + SRAM_DATA_OUT_START, cpg->p.crypt_len);
-
-	/* GO */
-	mv_setup_timer();
-	mv_tdma_trigger();
-	writel(SEC_CMD_EN_SEC_ACCL0, cpg->reg + SEC_ACCEL_CMD);
 }
 
 static void mv_update_crypt_config(void)
 {
-	struct sec_accel_config *op = &cpg->sa_sram.op;
-
 	/* update the enc_len field only */
-
-	op->enc_len = cpg->p.crypt_len;
-
-	dma_sync_single_for_device(cpg->dev, cpg->sa_sram_dma + 2 * sizeof(u32),
-			sizeof(u32), DMA_TO_DEVICE);
-	mv_tdma_memcpy(cpg->sram_phys + SRAM_CONFIG + 2 * sizeof(u32),
-			cpg->sa_sram_dma + 2 * sizeof(u32), sizeof(u32));
-
-	mv_tdma_separator();
-	dma_copy_buf_to_dst(&cpg->p, cpg->sram_phys + SRAM_DATA_OUT_START, cpg->p.crypt_len);
-
-	/* GO */
-	mv_setup_timer();
-	mv_tdma_trigger();
-	writel(SEC_CMD_EN_SEC_ACCL0, cpg->reg + SEC_ACCEL_CMD);
+	mv_tdma_u32_copy(cpg->sram_phys + SRAM_CONFIG + 2 * sizeof(u32),
+			(u32)cpg->p.crypt_len);
 }
 
 static void mv_crypto_algo_completion(void)
@@ -658,6 +697,7 @@ static void dequeue_complete_req(void)
 	cpg->p.crypt_len = 0;
 
 	mv_tdma_clear();
+	cpg->u32_usage = 0;
 
 	BUG_ON(cpg->eng_st != ENGINE_W_DEQUEUE);
 	if (cpg->p.hw_processed_bytes < cpg->p.hw_nbytes) {
@@ -699,7 +739,6 @@ static void mv_start_new_crypt_req(struct ablkcipher_request *req)
 	memset(p, 0, sizeof(struct req_progress));
 	p->hw_nbytes = req->nbytes;
 	p->complete = mv_crypto_algo_completion;
-	p->process = mv_update_crypt_config;
 
 	/* assume inplace request */
 	if (req->src == req->dst) {
@@ -726,6 +765,24 @@ static void mv_start_new_crypt_req(struct ablkcipher_request *req)
 
 	setup_data_in();
 	mv_init_crypt_config(req);
+	mv_tdma_separator();
+	dma_copy_buf_to_dst(&cpg->p, cpg->sram_phys + SRAM_DATA_OUT_START, cpg->p.crypt_len);
+	cpg->p.hw_processed_bytes += cpg->p.crypt_len;
+	while (cpg->p.hw_processed_bytes < cpg->p.hw_nbytes) {
+		cpg->p.crypt_len = 0;
+
+		setup_data_in();
+		mv_update_crypt_config();
+		mv_tdma_separator();
+		dma_copy_buf_to_dst(&cpg->p, cpg->sram_phys + SRAM_DATA_OUT_START, cpg->p.crypt_len);
+		cpg->p.hw_processed_bytes += cpg->p.crypt_len;
+	}
+
+
+	/* GO */
+	mv_setup_timer();
+	mv_tdma_trigger();
+	writel(SEC_CMD_EN_SEC_ACCL0, cpg->reg + SEC_ACCEL_CMD);
 }
 
 static void mv_start_new_hash_req(struct ahash_request *req)
@@ -1285,18 +1342,29 @@ static int mv_probe(struct platform_device *pdev)
 
 	writel(0, cpg->reg + SEC_ACCEL_INT_STATUS);
 	writel(SEC_INT_ACC0_IDMA_DONE, cpg->reg + SEC_ACCEL_INT_MASK);
-	writel((SEC_CFG_STOP_DIG_ERR | SEC_CFG_CH0_W_IDMA |
+	writel((SEC_CFG_STOP_DIG_ERR | SEC_CFG_CH0_W_IDMA | SEC_CFG_MP_CHAIN |
 	        SEC_CFG_ACT_CH0_IDMA), cpg->reg + SEC_ACCEL_CFG);
 	writel(SRAM_CONFIG, cpg->reg + SEC_ACCEL_DESC_P0);
 
 	cp->sa_sram_dma = dma_map_single(&pdev->dev, &cp->sa_sram,
 			sizeof(struct sec_accel_sram), DMA_TO_DEVICE);
 
+	cpg->u32_pool = dma_pool_create("CESA U32 Item Pool",
+			&pdev->dev, sizeof(u32), MV_DMA_ALIGN, 0);
+	if (!cpg->u32_pool) {
+		ret = -ENOMEM;
+		goto err_mapping;
+	}
+	if (set_u32_poolsize(MV_DMA_INIT_POOLSIZE)) {
+		printk(KERN_ERR MV_CESA "failed to initialise poolsize\n");
+		goto err_pool;
+	}
+
 	ret = crypto_register_alg(&mv_aes_alg_ecb);
 	if (ret) {
 		printk(KERN_WARNING MV_CESA
 		       "Could not register aes-ecb driver\n");
-		goto err_irq;
+		goto err_poolsize;
 	}
 
 	ret = crypto_register_alg(&mv_aes_alg_cbc);
@@ -1323,7 +1391,13 @@ static int mv_probe(struct platform_device *pdev)
 	return 0;
 err_unreg_ecb:
 	crypto_unregister_alg(&mv_aes_alg_ecb);
-err_irq:
+err_poolsize:
+	set_u32_poolsize(0);
+err_pool:
+	dma_pool_destroy(cpg->u32_pool);
+err_mapping:
+	dma_unmap_single(&pdev->dev, cpg->sa_sram_dma,
+			sizeof(struct sec_accel_sram), DMA_TO_DEVICE);
 	free_irq(irq, cp);
 err_thread:
 	kthread_stop(cp->queue_th);
@@ -1352,6 +1426,8 @@ static int mv_remove(struct platform_device *pdev)
 	free_irq(cp->irq, cp);
 	dma_unmap_single(&pdev->dev, cpg->sa_sram_dma,
 			sizeof(struct sec_accel_sram), DMA_TO_DEVICE);
+	set_u32_poolsize(0);
+	dma_pool_destroy(cpg->u32_pool);
 	memset(cp->sram, 0, cp->sram_size);
 	iounmap(cp->sram);
 	iounmap(cp->reg);
diff --git a/drivers/crypto/mv_cesa.h b/drivers/crypto/mv_cesa.h
index 81ce109..83730ca 100644
--- a/drivers/crypto/mv_cesa.h
+++ b/drivers/crypto/mv_cesa.h
@@ -24,6 +24,7 @@
 #define SEC_CFG_CH1_W_IDMA	(1 << 8)
 #define SEC_CFG_ACT_CH0_IDMA	(1 << 9)
 #define SEC_CFG_ACT_CH1_IDMA	(1 << 10)
+#define SEC_CFG_MP_CHAIN	(1 << 11)
 
 #define SEC_ACCEL_STATUS	0xde0c
 #define SEC_ST_ACT_0		(1 << 0)
-- 
1.7.3.4
