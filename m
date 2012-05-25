From: Phil Sutter <phil.sutter@viprinet.com>
Subject: [PATCH 13/13] mv_cesa, mv_tdma: outsource common dma-pool handling code
Date: Fri, 25 May 2012 18:08:39 +0200
Message-ID: <1337962119-5509-14-git-send-email-phil.sutter@viprinet.com>
References: <1337962119-5509-1-git-send-email-phil.sutter@viprinet.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zimbra.vipri.net ([89.207.250.15]:47883 "EHLO zimbra.vipri.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753598Ab2EYQIy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 25 May 2012 12:08:54 -0400
In-Reply-To: <1337962119-5509-1-git-send-email-phil.sutter@viprinet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Phil Sutter <phil.sutter@viprinet.com>
---
 drivers/crypto/dma_desclist.h |   79 +++++++++++++++++++++++++++++++++++
 drivers/crypto/mv_cesa.c      |   81 +++++++++----------------------------
 drivers/crypto/mv_tdma.c      |   91 ++++++++++++-----------------------------
 3 files changed, 125 insertions(+), 126 deletions(-)
 create mode 100644 drivers/crypto/dma_desclist.h

diff --git a/drivers/crypto/dma_desclist.h b/drivers/crypto/dma_desclist.h
new file mode 100644
index 0000000..c471ad6
--- /dev/null
+++ b/drivers/crypto/dma_desclist.h
@@ -0,0 +1,79 @@
+#ifndef __DMA_DESCLIST__
+#define __DMA_DESCLIST__
+
+struct dma_desc {
+	void *virt;
+	dma_addr_t phys;
+};
+
+struct dma_desclist {
+	struct dma_pool *itempool;
+	struct dma_desc *desclist;
+	unsigned long length;
+	unsigned long usage;
+};
+
+#define DESCLIST_ITEM(dl, x)		((dl).desclist[(x)].virt)
+#define DESCLIST_ITEM_DMA(dl, x)	((dl).desclist[(x)].phys)
+#define DESCLIST_FULL(dl)		((dl).length == (dl).usage)
+
+static inline int
+init_dma_desclist(struct dma_desclist *dl, struct device *dev,
+		size_t size, size_t align, size_t boundary)
+{
+#define STRX(x) #x
+#define STR(x) STRX(x)
+	dl->itempool = dma_pool_create(
+			"DMA Desclist Pool at "__FILE__"("STR(__LINE__)")",
+			dev, size, align, boundary);
+#undef STR
+#undef STRX
+	if (!dl->itempool)
+		return 1;
+	dl->desclist = NULL;
+	dl->length = dl->usage = 0;
+	return 0;
+}
+
+static inline int
+set_dma_desclist_size(struct dma_desclist *dl, unsigned long nelem)
+{
+	/* need to increase size first if requested */
+	if (nelem > dl->length) {
+		struct dma_desc *newmem;
+		int newsize = nelem * sizeof(struct dma_desc);
+
+		newmem = krealloc(dl->desclist, newsize, GFP_KERNEL);
+		if (!newmem)
+			return -ENOMEM;
+		dl->desclist = newmem;
+	}
+
+	/* allocate/free dma descriptors, adjusting dl->length on the go */
+	for (; dl->length < nelem; dl->length++) {
+		DESCLIST_ITEM(*dl, dl->length) = dma_pool_alloc(dl->itempool,
+				GFP_KERNEL, &DESCLIST_ITEM_DMA(*dl, dl->length));
+		if (!DESCLIST_ITEM(*dl, dl->length))
+			return -ENOMEM;
+	}
+	for (; dl->length > nelem; dl->length--)
+		dma_pool_free(dl->itempool, DESCLIST_ITEM(*dl, dl->length - 1),
+				DESCLIST_ITEM_DMA(*dl, dl->length - 1));
+
+	/* ignore size decreases but those to zero */
+	if (!nelem) {
+		kfree(dl->desclist);
+		dl->desclist = 0;
+	}
+	return 0;
+}
+
+static inline void
+fini_dma_desclist(struct dma_desclist *dl)
+{
+	set_dma_desclist_size(dl, 0);
+	dma_pool_destroy(dl->itempool);
+	dl->length = dl->usage = 0;
+}
+
+#endif /* __DMA_DESCLIST__ */
diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
index 9a2f413..367aa18 100644
--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@ -23,6 +23,7 @@
 
 #include "mv_cesa.h"
 #include "mv_tdma.h"
+#include "dma_desclist.h"
 
 #define MV_CESA	"MV-CESA:"
 #define MAX_HW_HASH_SIZE	0xFFFF
@@ -99,11 +100,6 @@ struct sec_accel_sram {
 #define sa_ivo	type.hash.ivo
 } __attribute__((packed));
 
-struct u32_mempair {
-	u32 *vaddr;
-	dma_addr_t daddr;
-};
-
 struct crypto_priv {
 	struct device *dev;
 	void __iomem *reg;
@@ -127,14 +123,14 @@ struct crypto_priv {
 	struct sec_accel_sram sa_sram;
 	dma_addr_t sa_sram_dma;
 
-	struct dma_pool *u32_pool;
-	struct u32_mempair *u32_list;
-	int u32_list_len;
-	int u32_usage;
+	struct dma_desclist desclist;
 };
 
 static struct crypto_priv *cpg;
 
+#define ITEM(x)		((u32 *)DESCLIST_ITEM(cpg->desclist, x))
+#define ITEM_DMA(x)	DESCLIST_ITEM_DMA(cpg->desclist, x)
+
 struct mv_ctx {
 	u8 aes_enc_key[AES_KEY_LEN];
 	u32 aes_dec_key[8];
@@ -202,52 +198,17 @@ static void mv_setup_timer(void)
 			jiffies + msecs_to_jiffies(MV_CESA_EXPIRE));
 }
 
-#define U32_ITEM(x)		(cpg->u32_list[x].vaddr)
-#define U32_ITEM_DMA(x)		(cpg->u32_list[x].daddr)
-
-static inline int set_u32_poolsize(int nelem)
-{
-	/* need to increase size first if requested */
-	if (nelem > cpg->u32_list_len) {
-		struct u32_mempair *newmem;
-		int newsize = nelem * sizeof(struct u32_mempair);
-
-		newmem = krealloc(cpg->u32_list, newsize, GFP_KERNEL);
-		if (!newmem)
-			return -ENOMEM;
-		cpg->u32_list = newmem;
-	}
-
-	/* allocate/free dma descriptors, adjusting cpg->u32_list_len on the go */
-	for (; cpg->u32_list_len < nelem; cpg->u32_list_len++) {
-		U32_ITEM(cpg->u32_list_len) = dma_pool_alloc(cpg->u32_pool,
-				GFP_KERNEL, &U32_ITEM_DMA(cpg->u32_list_len));
-		if (!U32_ITEM((cpg->u32_list_len)))
-			return -ENOMEM;
-	}
-	for (; cpg->u32_list_len > nelem; cpg->u32_list_len--)
-		dma_pool_free(cpg->u32_pool, U32_ITEM(cpg->u32_list_len - 1),
-				U32_ITEM_DMA(cpg->u32_list_len - 1));
-
-	/* ignore size decreases but those to zero */
-	if (!nelem) {
-		kfree(cpg->u32_list);
-		cpg->u32_list = 0;
-	}
-	return 0;
-}
-
 static inline void mv_tdma_u32_copy(dma_addr_t dst, u32 val)
 {
-	if (unlikely(cpg->u32_usage == cpg->u32_list_len)
-	    && set_u32_poolsize(cpg->u32_list_len << 1)) {
-		printk(KERN_ERR MV_CESA "resizing poolsize to %d failed\n",
-				cpg->u32_list_len << 1);
+	if (unlikely(DESCLIST_FULL(cpg->desclist)) &&
+	    set_dma_desclist_size(&cpg->desclist, cpg->desclist.length << 1)) {
+		printk(KERN_ERR MV_CESA "resizing poolsize to %lu failed\n",
+				cpg->desclist.length << 1);
 		return;
 	}
-	*(U32_ITEM(cpg->u32_usage)) = val;
-	mv_tdma_memcpy(dst, U32_ITEM_DMA(cpg->u32_usage), sizeof(u32));
-	cpg->u32_usage++;
+	*ITEM(cpg->desclist.usage) = val;
+	mv_tdma_memcpy(dst, ITEM_DMA(cpg->desclist.usage), sizeof(u32));
+	cpg->desclist.usage++;
 }
 
 static inline bool
@@ -649,7 +610,7 @@ static void dequeue_complete_req(void)
 	struct crypto_async_request *req = cpg->cur_req;
 
 	mv_tdma_clear();
-	cpg->u32_usage = 0;
+	cpg->desclist.usage = 0;
 
 	BUG_ON(cpg->eng_st != ENGINE_W_DEQUEUE);
 
@@ -1326,13 +1287,12 @@ static int mv_probe(struct platform_device *pdev)
 	cp->sa_sram_dma = dma_map_single(&pdev->dev, &cp->sa_sram,
 			sizeof(struct sec_accel_sram), DMA_TO_DEVICE);
 
-	cpg->u32_pool = dma_pool_create("CESA U32 Item Pool",
-			&pdev->dev, sizeof(u32), MV_DMA_ALIGN, 0);
-	if (!cpg->u32_pool) {
+	if (init_dma_desclist(&cpg->desclist, &pdev->dev,
+				sizeof(u32), MV_DMA_ALIGN, 0)) {
 		ret = -ENOMEM;
 		goto err_mapping;
 	}
-	if (set_u32_poolsize(MV_DMA_INIT_POOLSIZE)) {
+	if (set_dma_desclist_size(&cpg->desclist, MV_DMA_INIT_POOLSIZE)) {
 		printk(KERN_ERR MV_CESA "failed to initialise poolsize\n");
 		goto err_pool;
 	}
@@ -1341,7 +1301,7 @@ static int mv_probe(struct platform_device *pdev)
 	if (ret) {
 		printk(KERN_WARNING MV_CESA
 		       "Could not register aes-ecb driver\n");
-		goto err_poolsize;
+		goto err_pool;
 	}
 
 	ret = crypto_register_alg(&mv_aes_alg_cbc);
@@ -1368,10 +1328,8 @@ static int mv_probe(struct platform_device *pdev)
 	return 0;
 err_unreg_ecb:
 	crypto_unregister_alg(&mv_aes_alg_ecb);
-err_poolsize:
-	set_u32_poolsize(0);
 err_pool:
-	dma_pool_destroy(cpg->u32_pool);
+	fini_dma_desclist(&cpg->desclist);
 err_mapping:
 	dma_unmap_single(&pdev->dev, cpg->sa_sram_dma,
 			sizeof(struct sec_accel_sram), DMA_TO_DEVICE);
@@ -1403,8 +1361,7 @@ static int mv_remove(struct platform_device *pdev)
 	free_irq(cp->irq, cp);
 	dma_unmap_single(&pdev->dev, cpg->sa_sram_dma,
 			sizeof(struct sec_accel_sram), DMA_TO_DEVICE);
-	set_u32_poolsize(0);
-	dma_pool_destroy(cpg->u32_pool);
+	fini_dma_desclist(&cpg->desclist);
 	memset(cp->sram, 0, cp->sram_size);
 	iounmap(cp->sram);
 	iounmap(cp->reg);
diff --git a/drivers/crypto/mv_tdma.c b/drivers/crypto/mv_tdma.c
index aa5316a..d8e8c3f 100644
--- a/drivers/crypto/mv_tdma.c
+++ b/drivers/crypto/mv_tdma.c
@@ -17,6 +17,7 @@
 #include <linux/platform_device.h>
 
 #include "mv_tdma.h"
+#include "dma_desclist.h"
 
 #define MV_TDMA "MV-TDMA: "
 
@@ -30,57 +31,17 @@ struct tdma_desc {
 	u32 next;
 } __attribute__((packed));
 
-struct desc_mempair {
-	struct tdma_desc *vaddr;
-	dma_addr_t daddr;
-};
-
 struct tdma_priv {
 	struct device *dev;
 	void __iomem *reg;
 	int irq;
 	/* protecting the dma descriptors and stuff */
 	spinlock_t lock;
-	struct dma_pool *descpool;
-	struct desc_mempair *desclist;
-	int desclist_len;
-	int desc_usage;
+	struct dma_desclist desclist;
 } tpg;
 
-#define DESC(x)		(tpg.desclist[x].vaddr)
-#define DESC_DMA(x)	(tpg.desclist[x].daddr)
-
-static inline int set_poolsize(int nelem)
-{
-	/* need to increase size first if requested */
-	if (nelem > tpg.desclist_len) {
-		struct desc_mempair *newmem;
-		int newsize = nelem * sizeof(struct desc_mempair);
-
-		newmem = krealloc(tpg.desclist, newsize, GFP_KERNEL);
-		if (!newmem)
-			return -ENOMEM;
-		tpg.desclist = newmem;
-	}
-
-	/* allocate/free dma descriptors, adjusting tpg.desclist_len on the go */
-	for (; tpg.desclist_len < nelem; tpg.desclist_len++) {
-		DESC(tpg.desclist_len) = dma_pool_alloc(tpg.descpool,
-				GFP_KERNEL, &DESC_DMA(tpg.desclist_len));
-		if (!DESC((tpg.desclist_len)))
-			return -ENOMEM;
-	}
-	for (; tpg.desclist_len > nelem; tpg.desclist_len--)
-		dma_pool_free(tpg.descpool, DESC(tpg.desclist_len - 1),
-				DESC_DMA(tpg.desclist_len - 1));
-
-	/* ignore size decreases but those to zero */
-	if (!nelem) {
-		kfree(tpg.desclist);
-		tpg.desclist = 0;
-	}
-	return 0;
-}
+#define ITEM(x)		((struct tdma_desc *)DESCLIST_ITEM(tpg.desclist, x))
+#define ITEM_DMA(x)	DESCLIST_ITEM_DMA(tpg.desclist, x)
 
 static inline void wait_for_tdma_idle(void)
 {
@@ -100,17 +61,18 @@ static inline void switch_tdma_engine(bool state)
 
 static struct tdma_desc *get_new_last_desc(void)
 {
-	if (unlikely(tpg.desc_usage == tpg.desclist_len) &&
-	    set_poolsize(tpg.desclist_len << 1)) {
-		printk(KERN_ERR MV_TDMA "failed to increase DMA pool to %d\n",
-				tpg.desclist_len << 1);
+	if (unlikely(DESCLIST_FULL(tpg.desclist)) &&
+	    set_dma_desclist_size(&tpg.desclist, tpg.desclist.length << 1)) {
+		printk(KERN_ERR MV_TDMA "failed to increase DMA pool to %lu\n",
+				tpg.desclist.length << 1);
 		return NULL;
 	}
 
-	if (likely(tpg.desc_usage))
-		DESC(tpg.desc_usage - 1)->next = DESC_DMA(tpg.desc_usage);
+	if (likely(tpg.desclist.usage))
+		ITEM(tpg.desclist.usage - 1)->next =
+			ITEM_DMA(tpg.desclist.usage);
 
-	return DESC(tpg.desc_usage++);
+	return ITEM(tpg.desclist.usage++);
 }
 
 static inline void mv_tdma_desc_dump(void)
@@ -118,17 +80,17 @@ static inline void mv_tdma_desc_dump(void)
 	struct tdma_desc *tmp;
 	int i;
 
-	if (!tpg.desc_usage) {
+	if (!tpg.desclist.usage) {
 		printk(KERN_WARNING MV_TDMA "DMA descriptor list is empty\n");
 		return;
 	}
 
 	printk(KERN_WARNING MV_TDMA "DMA descriptor list:\n");
-	for (i = 0; i < tpg.desc_usage; i++) {
-		tmp = DESC(i);
+	for (i = 0; i < tpg.desclist.usage; i++) {
+		tmp = ITEM(i);
 		printk(KERN_WARNING MV_TDMA "entry %d at 0x%x: dma addr 0x%x, "
 		       "src 0x%x, dst 0x%x, count %u, own %d, next 0x%x", i,
-		       (u32)tmp, DESC_DMA(i) , tmp->src, tmp->dst,
+		       (u32)tmp, ITEM_DMA(i) , tmp->src, tmp->dst,
 		       tmp->count & ~TDMA_OWN_BIT, !!(tmp->count & TDMA_OWN_BIT),
 		       tmp->next);
 	}
@@ -167,7 +129,7 @@ void mv_tdma_clear(void)
 	writel(0, tpg.reg + TDMA_CURR_DESC);
 	writel(0, tpg.reg + TDMA_NEXT_DESC);
 
-	tpg.desc_usage = 0;
+	tpg.desclist.usage = 0;
 
 	switch_tdma_engine(1);
 
@@ -183,7 +145,7 @@ void mv_tdma_trigger(void)
 
 	spin_lock(&tpg.lock);
 
-	writel(DESC_DMA(0), tpg.reg + TDMA_NEXT_DESC);
+	writel(ITEM_DMA(0), tpg.reg + TDMA_NEXT_DESC);
 
 	spin_unlock(&tpg.lock);
 }
@@ -287,13 +249,15 @@ static int mv_probe(struct platform_device *pdev)
 		goto out_unmap_reg;
 	}
 
-	tpg.descpool = dma_pool_create("TDMA Descriptor Pool", tpg.dev,
-			sizeof(struct tdma_desc), MV_DMA_ALIGN, 0);
-	if (!tpg.descpool) {
+	if (init_dma_desclist(&tpg.desclist, tpg.dev,
+			sizeof(struct tdma_desc), MV_DMA_ALIGN, 0)) {
 		rc = -ENOMEM;
 		goto out_free_irq;
 	}
-	set_poolsize(MV_DMA_INIT_POOLSIZE);
+	if (set_dma_desclist_size(&tpg.desclist, MV_DMA_INIT_POOLSIZE)) {
+		rc = -ENOMEM;
+		goto out_free_desclist;
+	}
 
 	platform_set_drvdata(pdev, &tpg);
 
@@ -327,8 +291,8 @@ static int mv_probe(struct platform_device *pdev)
 out_free_all:
 	switch_tdma_engine(0);
 	platform_set_drvdata(pdev, NULL);
-	set_poolsize(0);
-	dma_pool_destroy(tpg.descpool);
+out_free_desclist:
+	fini_dma_desclist(&tpg.desclist);
 out_free_irq:
 	free_irq(tpg.irq, &tpg);
 out_unmap_reg:
@@ -341,8 +305,7 @@ static int mv_remove(struct platform_device *pdev)
 {
 	switch_tdma_engine(0);
 	platform_set_drvdata(pdev, NULL);
-	set_poolsize(0);
-	dma_pool_destroy(tpg.descpool);
+	fini_dma_desclist(&tpg.desclist);
 	free_irq(tpg.irq, &tpg);
 	iounmap(tpg.reg);
 	tpg.dev = NULL;
-- 
1.7.3.4
