From: Phil Sutter <phil.sutter@viprinet.com>
Subject: [PATCH 05/13] add a driver for the Marvell TDMA engine
Date: Fri, 25 May 2012 18:08:31 +0200
Message-ID: <1337962119-5509-6-git-send-email-phil.sutter@viprinet.com>
References: <1337962119-5509-1-git-send-email-phil.sutter@viprinet.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zimbra.vipri.net ([89.207.250.15]:47907 "EHLO zimbra.vipri.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756140Ab2EYQI7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 25 May 2012 12:08:59 -0400
In-Reply-To: <1337962119-5509-1-git-send-email-phil.sutter@viprinet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is a DMA engine integrated into the Marvell Kirkwood SoC, designed
to offload data transfers from/to the CESA crypto engine.

Signed-off-by: Phil Sutter <phil.sutter@viprinet.com>
---
 arch/arm/mach-kirkwood/common.c            |   33 +++
 arch/arm/mach-kirkwood/include/mach/irqs.h |    1 +
 drivers/crypto/Kconfig                     |    5 +
 drivers/crypto/Makefile                    |    3 +-
 drivers/crypto/mv_tdma.c                   |  377 ++++++++++++++++++++++++++++
 drivers/crypto/mv_tdma.h                   |   50 ++++
 6 files changed, 468 insertions(+), 1 deletions(-)
 create mode 100644 drivers/crypto/mv_tdma.c
 create mode 100644 drivers/crypto/mv_tdma.h

diff --git a/arch/arm/mach-kirkwood/common.c b/arch/arm/mach-kirkwood/common.c
index 3ad0373..adc6eff 100644
--- a/arch/arm/mach-kirkwood/common.c
+++ b/arch/arm/mach-kirkwood/common.c
@@ -269,9 +269,42 @@ void __init kirkwood_uart1_init(void)
 /*****************************************************************************
  * Cryptographic Engines and Security Accelerator (CESA)
  ****************************************************************************/
+static struct resource kirkwood_tdma_res[] = {
+	{
+		.name	= "regs deco",
+		.start	= CRYPTO_PHYS_BASE + 0xA00,
+		.end	= CRYPTO_PHYS_BASE + 0xA24,
+		.flags	= IORESOURCE_MEM,
+	}, {
+		.name	= "regs control and error",
+		.start	= CRYPTO_PHYS_BASE + 0x800,
+		.end	= CRYPTO_PHYS_BASE + 0x8CF,
+		.flags	= IORESOURCE_MEM,
+	}, {
+		.name   = "crypto error",
+		.start  = IRQ_KIRKWOOD_TDMA_ERR,
+		.end    = IRQ_KIRKWOOD_TDMA_ERR,
+		.flags  = IORESOURCE_IRQ,
+	},
+};
+
+static u64 mv_tdma_dma_mask = 0xffffffffUL;
+
+static struct platform_device kirkwood_tdma_device = {
+	.name		= "mv_tdma",
+	.id		= -1,
+	.dev		= {
+		.dma_mask		= &mv_tdma_dma_mask,
+		.coherent_dma_mask	= 0xffffffff,
+	},
+	.num_resources	= ARRAY_SIZE(kirkwood_tdma_res),
+	.resource	= kirkwood_tdma_res,
+};
+
 void __init kirkwood_crypto_init(void)
 {
 	kirkwood_clk_ctrl |= CGC_CRYPTO;
+	platform_device_register(&kirkwood_tdma_device);
 	orion_crypto_init(CRYPTO_PHYS_BASE, KIRKWOOD_SRAM_PHYS_BASE,
 			  KIRKWOOD_SRAM_SIZE, IRQ_KIRKWOOD_CRYPTO);
 }
diff --git a/arch/arm/mach-kirkwood/include/mach/irqs.h b/arch/arm/mach-kirkwood/include/mach/irqs.h
index 2bf8161..a66aa3f 100644
--- a/arch/arm/mach-kirkwood/include/mach/irqs.h
+++ b/arch/arm/mach-kirkwood/include/mach/irqs.h
@@ -51,6 +51,7 @@
 #define IRQ_KIRKWOOD_GPIO_HIGH_16_23	41
 #define IRQ_KIRKWOOD_GE00_ERR	46
 #define IRQ_KIRKWOOD_GE01_ERR	47
+#define IRQ_KIRKWOOD_TDMA_ERR	49
 #define IRQ_KIRKWOOD_RTC        53
 
 /*
diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 1092a77..17becf3 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -159,6 +159,10 @@ config CRYPTO_GHASH_S390
 
 	  It is available as of z196.
 
+config CRYPTO_DEV_MV_TDMA
+	tristate
+	default no
+
 config CRYPTO_DEV_MV_CESA
 	tristate "Marvell's Cryptographic Engine"
 	depends on PLAT_ORION
@@ -166,6 +170,7 @@ config CRYPTO_DEV_MV_CESA
 	select CRYPTO_AES
 	select CRYPTO_BLKCIPHER2
 	select CRYPTO_HASH
+	select CRYPTO_DEV_MV_TDMA
 	help
 	  This driver allows you to utilize the Cryptographic Engines and
 	  Security Accelerator (CESA) which can be found on the Marvell Orion
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index 0139032..65806e8 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -4,6 +4,7 @@ obj-$(CONFIG_CRYPTO_DEV_GEODE) += geode-aes.o
 obj-$(CONFIG_CRYPTO_DEV_NIAGARA2) += n2_crypto.o
 n2_crypto-y := n2_core.o n2_asm.o
 obj-$(CONFIG_CRYPTO_DEV_HIFN_795X) += hifn_795x.o
+obj-$(CONFIG_CRYPTO_DEV_MV_TDMA) += mv_tdma.o
 obj-$(CONFIG_CRYPTO_DEV_MV_CESA) += mv_cesa.o
 obj-$(CONFIG_CRYPTO_DEV_TALITOS) += talitos.o
 obj-$(CONFIG_CRYPTO_DEV_FSL_CAAM) += caam/
@@ -14,4 +15,4 @@ obj-$(CONFIG_CRYPTO_DEV_OMAP_AES) += omap-aes.o
 obj-$(CONFIG_CRYPTO_DEV_PICOXCELL) += picoxcell_crypto.o
 obj-$(CONFIG_CRYPTO_DEV_S5P) += s5p-sss.o
 obj-$(CONFIG_CRYPTO_DEV_TEGRA_AES) += tegra-aes.o
-obj-$(CONFIG_CRYPTO_DEV_UX500) += ux500/
\ No newline at end of file
+obj-$(CONFIG_CRYPTO_DEV_UX500) += ux500/
diff --git a/drivers/crypto/mv_tdma.c b/drivers/crypto/mv_tdma.c
new file mode 100644
index 0000000..aa5316a
--- /dev/null
+++ b/drivers/crypto/mv_tdma.c
@@ -0,0 +1,377 @@
+/*
+ * Support for Marvell's TDMA engine found on Kirkwood chips,
+ * used exclusively by the CESA crypto accelerator.
+ *
+ * Based on unpublished code for IDMA written by Sebastian Siewior.
+ *
+ * Copyright (C) 2012 Phil Sutter <phil.sutter@viprinet.com>
+ * License: GPLv2
+ */
+
+#include <linux/delay.h>
+#include <linux/dma-mapping.h>
+#include <linux/dmapool.h>
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/platform_device.h>
+
+#include "mv_tdma.h"
+
+#define MV_TDMA "MV-TDMA: "
+
+#define MV_DMA_INIT_POOLSIZE 16
+#define MV_DMA_ALIGN 16
+
+struct tdma_desc {
+	u32 count;
+	u32 src;
+	u32 dst;
+	u32 next;
+} __attribute__((packed));
+
+struct desc_mempair {
+	struct tdma_desc *vaddr;
+	dma_addr_t daddr;
+};
+
+struct tdma_priv {
+	struct device *dev;
+	void __iomem *reg;
+	int irq;
+	/* protecting the dma descriptors and stuff */
+	spinlock_t lock;
+	struct dma_pool *descpool;
+	struct desc_mempair *desclist;
+	int desclist_len;
+	int desc_usage;
+} tpg;
+
+#define DESC(x)		(tpg.desclist[x].vaddr)
+#define DESC_DMA(x)	(tpg.desclist[x].daddr)
+
+static inline int set_poolsize(int nelem)
+{
+	/* need to increase size first if requested */
+	if (nelem > tpg.desclist_len) {
+		struct desc_mempair *newmem;
+		int newsize = nelem * sizeof(struct desc_mempair);
+
+		newmem = krealloc(tpg.desclist, newsize, GFP_KERNEL);
+		if (!newmem)
+			return -ENOMEM;
+		tpg.desclist = newmem;
+	}
+
+	/* allocate/free dma descriptors, adjusting tpg.desclist_len on the go */
+	for (; tpg.desclist_len < nelem; tpg.desclist_len++) {
+		DESC(tpg.desclist_len) = dma_pool_alloc(tpg.descpool,
+				GFP_KERNEL, &DESC_DMA(tpg.desclist_len));
+		if (!DESC((tpg.desclist_len)))
+			return -ENOMEM;
+	}
+	for (; tpg.desclist_len > nelem; tpg.desclist_len--)
+		dma_pool_free(tpg.descpool, DESC(tpg.desclist_len - 1),
+				DESC_DMA(tpg.desclist_len - 1));
+
+	/* ignore size decreases but those to zero */
+	if (!nelem) {
+		kfree(tpg.desclist);
+		tpg.desclist = 0;
+	}
+	return 0;
+}
+
+static inline void wait_for_tdma_idle(void)
+{
+	while (readl(tpg.reg + TDMA_CTRL) & TDMA_CTRL_ACTIVE)
+		mdelay(100);
+}
+
+static inline void switch_tdma_engine(bool state)
+{
+	u32 val = readl(tpg.reg + TDMA_CTRL);
+
+	val |=  ( state * TDMA_CTRL_ENABLE);
+	val &= ~(!state * TDMA_CTRL_ENABLE);
+
+	writel(val, tpg.reg + TDMA_CTRL);
+}
+
+static struct tdma_desc *get_new_last_desc(void)
+{
+	if (unlikely(tpg.desc_usage == tpg.desclist_len) &&
+	    set_poolsize(tpg.desclist_len << 1)) {
+		printk(KERN_ERR MV_TDMA "failed to increase DMA pool to %d\n",
+				tpg.desclist_len << 1);
+		return NULL;
+	}
+
+	if (likely(tpg.desc_usage))
+		DESC(tpg.desc_usage - 1)->next = DESC_DMA(tpg.desc_usage);
+
+	return DESC(tpg.desc_usage++);
+}
+
+static inline void mv_tdma_desc_dump(void)
+{
+	struct tdma_desc *tmp;
+	int i;
+
+	if (!tpg.desc_usage) {
+		printk(KERN_WARNING MV_TDMA "DMA descriptor list is empty\n");
+		return;
+	}
+
+	printk(KERN_WARNING MV_TDMA "DMA descriptor list:\n");
+	for (i = 0; i < tpg.desc_usage; i++) {
+		tmp = DESC(i);
+		printk(KERN_WARNING MV_TDMA "entry %d at 0x%x: dma addr 0x%x, "
+		       "src 0x%x, dst 0x%x, count %u, own %d, next 0x%x", i,
+		       (u32)tmp, DESC_DMA(i) , tmp->src, tmp->dst,
+		       tmp->count & ~TDMA_OWN_BIT, !!(tmp->count & TDMA_OWN_BIT),
+		       tmp->next);
+	}
+}
+
+static inline void mv_tdma_reg_dump(void)
+{
+#define PRINTREG(offset) \
+	printk(KERN_WARNING MV_TDMA "tpg.reg + " #offset " = 0x%x\n", \
+			readl(tpg.reg + offset))
+
+	PRINTREG(TDMA_CTRL);
+	PRINTREG(TDMA_BYTE_COUNT);
+	PRINTREG(TDMA_SRC_ADDR);
+	PRINTREG(TDMA_DST_ADDR);
+	PRINTREG(TDMA_NEXT_DESC);
+	PRINTREG(TDMA_CURR_DESC);
+
+#undef PRINTREG
+}
+
+void mv_tdma_clear(void)
+{
+	if (!tpg.dev)
+		return;
+
+	spin_lock(&tpg.lock);
+
+	/* make sure tdma is idle */
+	wait_for_tdma_idle();
+	switch_tdma_engine(0);
+	wait_for_tdma_idle();
+
+	/* clear descriptor registers */
+	writel(0, tpg.reg + TDMA_BYTE_COUNT);
+	writel(0, tpg.reg + TDMA_CURR_DESC);
+	writel(0, tpg.reg + TDMA_NEXT_DESC);
+
+	tpg.desc_usage = 0;
+
+	switch_tdma_engine(1);
+
+	/* finally free system lock again */
+	spin_unlock(&tpg.lock);
+}
+EXPORT_SYMBOL_GPL(mv_tdma_clear);
+
+void mv_tdma_trigger(void)
+{
+	if (!tpg.dev)
+		return;
+
+	spin_lock(&tpg.lock);
+
+	writel(DESC_DMA(0), tpg.reg + TDMA_NEXT_DESC);
+
+	spin_unlock(&tpg.lock);
+}
+EXPORT_SYMBOL_GPL(mv_tdma_trigger);
+
+void mv_tdma_separator(void)
+{
+	struct tdma_desc *tmp;
+
+	if (!tpg.dev)
+		return;
+
+	spin_lock(&tpg.lock);
+
+	tmp = get_new_last_desc();
+	memset(tmp, 0, sizeof(*tmp));
+
+	spin_unlock(&tpg.lock);
+}
+EXPORT_SYMBOL_GPL(mv_tdma_separator);
+
+void mv_tdma_memcpy(dma_addr_t dst, dma_addr_t src, unsigned int size)
+{
+	struct tdma_desc *tmp;
+
+	if (!tpg.dev)
+		return;
+
+	spin_lock(&tpg.lock);
+
+	tmp = get_new_last_desc();
+	tmp->count = size | TDMA_OWN_BIT;
+	tmp->src = src;
+	tmp->dst = dst;
+	tmp->next = 0;
+
+	spin_unlock(&tpg.lock);
+}
+EXPORT_SYMBOL_GPL(mv_tdma_memcpy);
+
+irqreturn_t tdma_int(int irq, void *priv)
+{
+	u32 val;
+
+	val = readl(tpg.reg + TDMA_ERR_CAUSE);
+
+	if (val & TDMA_INT_MISS)
+		printk(KERN_ERR MV_TDMA "%s: miss!\n", __func__);
+	if (val & TDMA_INT_DOUBLE_HIT)
+		printk(KERN_ERR MV_TDMA "%s: double hit!\n", __func__);
+	if (val & TDMA_INT_BOTH_HIT)
+		printk(KERN_ERR MV_TDMA "%s: both hit!\n", __func__);
+	if (val & TDMA_INT_DATA_ERROR)
+		printk(KERN_ERR MV_TDMA "%s: data error!\n", __func__);
+	if (val) {
+		mv_tdma_reg_dump();
+		mv_tdma_desc_dump();
+	}
+
+	switch_tdma_engine(0);
+	wait_for_tdma_idle();
+
+	/* clear descriptor registers */
+	writel(0, tpg.reg + TDMA_BYTE_COUNT);
+	writel(0, tpg.reg + TDMA_SRC_ADDR);
+	writel(0, tpg.reg + TDMA_DST_ADDR);
+	writel(0, tpg.reg + TDMA_CURR_DESC);
+
+	/* clear error cause register */
+	writel(0, tpg.reg + TDMA_ERR_CAUSE);
+
+	/* initialize control register (also enables engine) */
+	writel(TDMA_CTRL_INIT_VALUE, tpg.reg + TDMA_CTRL);
+	wait_for_tdma_idle();
+
+	return (val ? IRQ_HANDLED : IRQ_NONE);
+}
+
+static int mv_probe(struct platform_device *pdev)
+{
+	struct resource *res;
+	int rc;
+
+	if (tpg.dev) {
+		printk(KERN_ERR MV_TDMA "second TDMA device?!\n");
+		return -ENXIO;
+	}
+	tpg.dev = &pdev->dev;
+
+	res = platform_get_resource_byname(pdev,
+			IORESOURCE_MEM, "regs control and error");
+	if (!res)
+		return -ENXIO;
+
+	if (!(tpg.reg = ioremap(res->start, resource_size(res))))
+		return -ENOMEM;
+
+	tpg.irq = platform_get_irq(pdev, 0);
+	if (tpg.irq < 0 || tpg.irq == NO_IRQ) {
+		rc = -ENXIO;
+		goto out_unmap_reg;
+	}
+
+	tpg.descpool = dma_pool_create("TDMA Descriptor Pool", tpg.dev,
+			sizeof(struct tdma_desc), MV_DMA_ALIGN, 0);
+	if (!tpg.descpool) {
+		rc = -ENOMEM;
+		goto out_free_irq;
+	}
+	set_poolsize(MV_DMA_INIT_POOLSIZE);
+
+	platform_set_drvdata(pdev, &tpg);
+
+	switch_tdma_engine(0);
+	wait_for_tdma_idle();
+
+	/* clear descriptor registers */
+	writel(0, tpg.reg + TDMA_BYTE_COUNT);
+	writel(0, tpg.reg + TDMA_SRC_ADDR);
+	writel(0, tpg.reg + TDMA_DST_ADDR);
+	writel(0, tpg.reg + TDMA_CURR_DESC);
+
+	/* have an ear for occurring errors */
+	writel(TDMA_INT_ALL, tpg.reg + TDMA_ERR_MASK);
+	writel(0, tpg.reg + TDMA_ERR_CAUSE);
+
+	/* initialize control register (also enables engine) */
+	writel(TDMA_CTRL_INIT_VALUE, tpg.reg + TDMA_CTRL);
+	wait_for_tdma_idle();
+
+	if (request_irq(tpg.irq, tdma_int, IRQF_DISABLED,
+				dev_name(tpg.dev), &tpg)) {
+		rc = -ENXIO;
+		goto out_free_all;
+	}
+
+	spin_lock_init(&tpg.lock);
+
+	printk(KERN_INFO MV_TDMA "up and running, IRQ %d\n", tpg.irq);
+	return 0;
+out_free_all:
+	switch_tdma_engine(0);
+	platform_set_drvdata(pdev, NULL);
+	set_poolsize(0);
+	dma_pool_destroy(tpg.descpool);
+out_free_irq:
+	free_irq(tpg.irq, &tpg);
+out_unmap_reg:
+	iounmap(tpg.reg);
+	tpg.dev = NULL;
+	return rc;
+}
+
+static int mv_remove(struct platform_device *pdev)
+{
+	switch_tdma_engine(0);
+	platform_set_drvdata(pdev, NULL);
+	set_poolsize(0);
+	dma_pool_destroy(tpg.descpool);
+	free_irq(tpg.irq, &tpg);
+	iounmap(tpg.reg);
+	tpg.dev = NULL;
+	return 0;
+}
+
+static struct platform_driver marvell_tdma = {
+	.probe          = mv_probe,
+	.remove         = mv_remove,
+	.driver         = {
+		.owner  = THIS_MODULE,
+		.name   = "mv_tdma",
+	},
+};
+MODULE_ALIAS("platform:mv_tdma");
+
+static int __init mv_tdma_init(void)
+{
+	return platform_driver_register(&marvell_tdma);
+}
+module_init(mv_tdma_init);
+
+static void __exit mv_tdma_exit(void)
+{
+	platform_driver_unregister(&marvell_tdma);
+}
+module_exit(mv_tdma_exit);
+
+MODULE_AUTHOR("Phil Sutter <phil.sutter@viprinet.com>");
+MODULE_DESCRIPTION("Support for Marvell's TDMA engine");
+MODULE_LICENSE("GPL");
+
diff --git a/drivers/crypto/mv_tdma.h b/drivers/crypto/mv_tdma.h
new file mode 100644
index 0000000..3efa44c3
--- /dev/null
+++ b/drivers/crypto/mv_tdma.h
@@ -0,0 +1,50 @@
+#ifndef _MV_TDMA_H
+#define _MV_TDMA_H
+
+/* TDMA_CTRL register bits */
+#define TDMA_CTRL_DST_BURST(x)	(x)
+#define TDMA_CTRL_DST_BURST_32	TDMA_CTRL_DST_BURST(3)
+#define TDMA_CTRL_DST_BURST_128	TDMA_CTRL_DST_BURST(4)
+#define TDMA_CTRL_OUTST_RD_EN	(1 << 4)
+#define TDMA_CTRL_SRC_BURST(x)	(x << 6)
+#define TDMA_CTRL_SRC_BURST_32	TDMA_CTRL_SRC_BURST(3)
+#define TDMA_CTRL_SRC_BURST_128	TDMA_CTRL_SRC_BURST(4)
+#define TDMA_CTRL_NO_CHAIN_MODE	(1 << 9)
+#define TDMA_CTRL_NO_BYTE_SWAP	(1 << 11)
+#define TDMA_CTRL_ENABLE	(1 << 12)
+#define TDMA_CTRL_FETCH_ND	(1 << 13)
+#define TDMA_CTRL_ACTIVE	(1 << 14)
+
+#define TDMA_CTRL_INIT_VALUE ( \
+	TDMA_CTRL_DST_BURST_128 | TDMA_CTRL_SRC_BURST_128 | \
+	TDMA_CTRL_NO_BYTE_SWAP | TDMA_CTRL_ENABLE \
+)
+
+/* TDMA_ERR_CAUSE bits */
+#define TDMA_INT_MISS		(1 << 0)
+#define TDMA_INT_DOUBLE_HIT	(1 << 1)
+#define TDMA_INT_BOTH_HIT	(1 << 2)
+#define TDMA_INT_DATA_ERROR	(1 << 3)
+#define TDMA_INT_ALL		0x0f
+
+/* offsets of registers, starting at "regs control and error" */
+#define TDMA_BYTE_COUNT		0x00
+#define TDMA_SRC_ADDR		0x10
+#define TDMA_DST_ADDR		0x20
+#define TDMA_NEXT_DESC		0x30
+#define TDMA_CTRL		0x40
+#define TDMA_CURR_DESC		0x70
+#define TDMA_ERR_CAUSE		0xc8
+#define TDMA_ERR_MASK		0xcc
+
+/* Owner bit in TDMA_BYTE_COUNT and descriptors' count field, used
+ * to signal TDMA in descriptor chain when input data is complete. */
+#define TDMA_OWN_BIT		(1 << 31)
+
+extern void mv_tdma_memcpy(dma_addr_t, dma_addr_t, unsigned int);
+extern void mv_tdma_separator(void);
+extern void mv_tdma_clear(void);
+extern void mv_tdma_trigger(void);
+
+
+#endif /* _MV_TDMA_H */
-- 
1.7.3.4
