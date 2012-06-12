From: Phil Sutter <phil.sutter@viprinet.com>
Subject: [PATCH 05/13] add a driver for the Marvell IDMA/TDMA engines
Date: Tue, 12 Jun 2012 19:17:19 +0200
Message-ID: <1339521447-17721-6-git-send-email-phil.sutter@viprinet.com>
References: <20120612113941.GA14757@gondor.apana.org.au>
 <1339521447-17721-1-git-send-email-phil.sutter@viprinet.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zimbra.vipri.net ([89.207.250.15]:58657 "EHLO zimbra.vipri.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753417Ab2FLRR6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 Jun 2012 13:17:58 -0400
In-Reply-To: <1339521447-17721-1-git-send-email-phil.sutter@viprinet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

These are DMA engines integrated into the Marvell Orion/Kirkwood SoCs,
designed to offload data transfers from/to the CESA crypto engine.

Signed-off-by: Phil Sutter <phil.sutter@viprinet.com>
---
 arch/arm/mach-kirkwood/common.c              |   33 ++
 arch/arm/mach-kirkwood/include/mach/irqs.h   |    1 +
 arch/arm/mach-orion5x/common.c               |   33 ++
 arch/arm/mach-orion5x/include/mach/orion5x.h |    2 +
 drivers/crypto/Kconfig                       |    5 +
 drivers/crypto/Makefile                      |    3 +-
 drivers/crypto/mv_dma.c                      |  464 ++++++++++++++++++++++++++
 drivers/crypto/mv_dma.h                      |  127 +++++++
 8 files changed, 667 insertions(+), 1 deletions(-)
 create mode 100644 drivers/crypto/mv_dma.c
 create mode 100644 drivers/crypto/mv_dma.h

diff --git a/arch/arm/mach-kirkwood/common.c b/arch/arm/mach-kirkwood/common.c
index 25fb3fd..dcd1327 100644
--- a/arch/arm/mach-kirkwood/common.c
+++ b/arch/arm/mach-kirkwood/common.c
@@ -426,8 +426,41 @@ void __init kirkwood_uart1_init(void)
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
+static u64 mv_tdma_dma_mask = DMA_BIT_MASK(32);
+
+static struct platform_device kirkwood_tdma_device = {
+	.name		= "mv_tdma",
+	.id		= -1,
+	.dev		= {
+		.dma_mask		= &mv_tdma_dma_mask,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
+	},
+	.num_resources	= ARRAY_SIZE(kirkwood_tdma_res),
+	.resource	= kirkwood_tdma_res,
+};
+
 void __init kirkwood_crypto_init(void)
 {
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
diff --git a/arch/arm/mach-orion5x/common.c b/arch/arm/mach-orion5x/common.c
index 9148b22..553ccf2 100644
--- a/arch/arm/mach-orion5x/common.c
+++ b/arch/arm/mach-orion5x/common.c
@@ -181,9 +181,42 @@ void __init orion5x_xor_init(void)
 /*****************************************************************************
  * Cryptographic Engines and Security Accelerator (CESA)
  ****************************************************************************/
+static struct resource orion_idma_res[] = {
+	{
+		.name	= "regs deco",
+		.start	= ORION5X_IDMA_PHYS_BASE + 0xA00,
+		.end	= ORION5X_IDMA_PHYS_BASE + 0xA24,
+		.flags	= IORESOURCE_MEM,
+	}, {
+		.name	= "regs control and error",
+		.start	= ORION5X_IDMA_PHYS_BASE + 0x800,
+		.end	= ORION5X_IDMA_PHYS_BASE + 0x8CF,
+		.flags	= IORESOURCE_MEM,
+	}, {
+		.name   = "crypto error",
+		.start  = IRQ_ORION5X_IDMA_ERR,
+		.end    = IRQ_ORION5X_IDMA_ERR,
+		.flags  = IORESOURCE_IRQ,
+	},
+};
+
+static u64 mv_idma_dma_mask = DMA_BIT_MASK(32);
+
+static struct platform_device orion_idma_device = {
+	.name		= "mv_idma",
+	.id		= -1,
+	.dev		= {
+		.dma_mask		= &mv_idma_dma_mask,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
+	},
+	.num_resources	= ARRAY_SIZE(orion_idma_res),
+	.resource	= orion_idma_res,
+};
+
 static void __init orion5x_crypto_init(void)
 {
 	orion5x_setup_sram_win();
+	platform_device_register(&orion_idma_device);
 	orion_crypto_init(ORION5X_CRYPTO_PHYS_BASE, ORION5X_SRAM_PHYS_BASE,
 			  SZ_8K, IRQ_ORION5X_CESA);
 }
diff --git a/arch/arm/mach-orion5x/include/mach/orion5x.h b/arch/arm/mach-orion5x/include/mach/orion5x.h
index 2745f5d..a31ac88 100644
--- a/arch/arm/mach-orion5x/include/mach/orion5x.h
+++ b/arch/arm/mach-orion5x/include/mach/orion5x.h
@@ -90,6 +90,8 @@
 #define ORION5X_USB0_PHYS_BASE		(ORION5X_REGS_PHYS_BASE | 0x50000)
 #define ORION5X_USB0_VIRT_BASE		(ORION5X_REGS_VIRT_BASE | 0x50000)
 
+#define ORION5X_IDMA_PHYS_BASE		(ORION5X_REGS_PHYS_BASE | 0x60000)
+
 #define ORION5X_XOR_PHYS_BASE		(ORION5X_REGS_PHYS_BASE | 0x60900)
 #define ORION5X_XOR_VIRT_BASE		(ORION5X_REGS_VIRT_BASE | 0x60900)
 
diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 1092a77..3709f38 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -159,6 +159,10 @@ config CRYPTO_GHASH_S390
 
 	  It is available as of z196.
 
+config CRYPTO_DEV_MV_DMA
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
+	select CRYPTO_DEV_MV_DMA
 	help
 	  This driver allows you to utilize the Cryptographic Engines and
 	  Security Accelerator (CESA) which can be found on the Marvell Orion
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index 0139032..cb655ad 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -4,6 +4,7 @@ obj-$(CONFIG_CRYPTO_DEV_GEODE) += geode-aes.o
 obj-$(CONFIG_CRYPTO_DEV_NIAGARA2) += n2_crypto.o
 n2_crypto-y := n2_core.o n2_asm.o
 obj-$(CONFIG_CRYPTO_DEV_HIFN_795X) += hifn_795x.o
+obj-$(CONFIG_CRYPTO_DEV_MV_DMA) += mv_dma.o
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
diff --git a/drivers/crypto/mv_dma.c b/drivers/crypto/mv_dma.c
new file mode 100644
index 0000000..24c5256
--- /dev/null
+++ b/drivers/crypto/mv_dma.c
@@ -0,0 +1,464 @@
+/*
+ * Support for Marvell's IDMA/TDMA engines found on Orion/Kirkwood chips,
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
+#include "mv_dma.h"
+
+#define MV_DMA "MV-DMA: "
+
+#define MV_DMA_INIT_POOLSIZE 16
+#define MV_DMA_ALIGN 16
+
+struct mv_dma_desc {
+	u32 count;
+	u32 src;
+	u32 dst;
+	u32 next;
+} __attribute__((packed));
+
+struct desc_mempair {
+	struct mv_dma_desc *vaddr;
+	dma_addr_t daddr;
+};
+
+struct mv_dma_priv {
+	bool idma_registered, tdma_registered;
+	struct device *dev;
+	void __iomem *reg;
+	int irq;
+	/* protecting the dma descriptors and stuff */
+	spinlock_t lock;
+	struct dma_pool *descpool;
+	struct desc_mempair *desclist;
+	int desclist_len;
+	int desc_usage;
+	u32 (*print_and_clear_irq)(void);
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
+static inline void wait_for_dma_idle(void)
+{
+	while (readl(tpg.reg + DMA_CTRL) & DMA_CTRL_ACTIVE)
+		mdelay(100);
+}
+
+static inline void switch_dma_engine(bool state)
+{
+	u32 val = readl(tpg.reg + DMA_CTRL);
+
+	val |=  ( state * DMA_CTRL_ENABLE);
+	val &= ~(!state * DMA_CTRL_ENABLE);
+
+	writel(val, tpg.reg + DMA_CTRL);
+}
+
+static struct mv_dma_desc *get_new_last_desc(void)
+{
+	if (unlikely(tpg.desc_usage == tpg.desclist_len) &&
+	    set_poolsize(tpg.desclist_len << 1)) {
+		printk(KERN_ERR MV_DMA "failed to increase DMA pool to %d\n",
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
+static inline void mv_dma_desc_dump(void)
+{
+	struct mv_dma_desc *tmp;
+	int i;
+
+	if (!tpg.desc_usage) {
+		printk(KERN_WARNING MV_DMA "DMA descriptor list is empty\n");
+		return;
+	}
+
+	printk(KERN_WARNING MV_DMA "DMA descriptor list:\n");
+	for (i = 0; i < tpg.desc_usage; i++) {
+		tmp = DESC(i);
+		printk(KERN_WARNING MV_DMA "entry %d at 0x%x: dma addr 0x%x, "
+		       "src 0x%x, dst 0x%x, count %u, own %d, next 0x%x", i,
+		       (u32)tmp, DESC_DMA(i) , tmp->src, tmp->dst,
+		       tmp->count & DMA_BYTE_COUNT_MASK, !!(tmp->count & DMA_OWN_BIT),
+		       tmp->next);
+	}
+}
+
+static inline void mv_dma_reg_dump(void)
+{
+#define PRINTREG(offset) \
+	printk(KERN_WARNING MV_DMA "tpg.reg + " #offset " = 0x%x\n", \
+			readl(tpg.reg + offset))
+
+	PRINTREG(DMA_CTRL);
+	PRINTREG(DMA_BYTE_COUNT);
+	PRINTREG(DMA_SRC_ADDR);
+	PRINTREG(DMA_DST_ADDR);
+	PRINTREG(DMA_NEXT_DESC);
+	PRINTREG(DMA_CURR_DESC);
+
+#undef PRINTREG
+}
+
+static inline void mv_dma_clear_desc_reg(void)
+{
+	writel(0, tpg.reg + DMA_BYTE_COUNT);
+	writel(0, tpg.reg + DMA_SRC_ADDR);
+	writel(0, tpg.reg + DMA_DST_ADDR);
+	writel(0, tpg.reg + DMA_CURR_DESC);
+	writel(0, tpg.reg + DMA_NEXT_DESC);
+}
+
+void mv_dma_clear(void)
+{
+	if (!tpg.dev)
+		return;
+
+	spin_lock(&tpg.lock);
+
+	/* make sure engine is idle */
+	wait_for_dma_idle();
+	switch_dma_engine(0);
+	wait_for_dma_idle();
+
+	/* clear descriptor registers */
+	mv_dma_clear_desc_reg();
+
+	tpg.desc_usage = 0;
+
+	switch_dma_engine(1);
+
+	/* finally free system lock again */
+	spin_unlock(&tpg.lock);
+}
+EXPORT_SYMBOL_GPL(mv_dma_clear);
+
+void mv_dma_trigger(void)
+{
+	if (!tpg.dev)
+		return;
+
+	spin_lock(&tpg.lock);
+
+	writel(DESC_DMA(0), tpg.reg + DMA_NEXT_DESC);
+
+	spin_unlock(&tpg.lock);
+}
+EXPORT_SYMBOL_GPL(mv_dma_trigger);
+
+void mv_dma_separator(void)
+{
+	struct mv_dma_desc *tmp;
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
+EXPORT_SYMBOL_GPL(mv_dma_separator);
+
+void mv_dma_memcpy(dma_addr_t dst, dma_addr_t src, unsigned int size)
+{
+	struct mv_dma_desc *tmp;
+
+	if (!tpg.dev)
+		return;
+
+	spin_lock(&tpg.lock);
+
+	tmp = get_new_last_desc();
+	tmp->count = size | DMA_OWN_BIT;
+	tmp->src = src;
+	tmp->dst = dst;
+	tmp->next = 0;
+
+	spin_unlock(&tpg.lock);
+}
+EXPORT_SYMBOL_GPL(mv_dma_memcpy);
+
+static u32 idma_print_and_clear_irq(void)
+{
+	u32 val, val2, addr;
+
+	val = readl(tpg.reg + IDMA_INT_CAUSE);
+	val2 = readl(tpg.reg + IDMA_ERR_SELECT);
+	addr = readl(tpg.reg + IDMA_ERR_ADDR);
+
+	if (val & IDMA_INT_MISS(0))
+		printk(KERN_ERR MV_DMA "%s: address miss @%x!\n",
+				__func__, val2 & IDMA_INT_MISS(0) ? addr : 0);
+	if (val & IDMA_INT_APROT(0))
+		printk(KERN_ERR MV_DMA "%s: access protection @%x!\n",
+				__func__, val2 & IDMA_INT_APROT(0) ? addr : 0);
+	if (val & IDMA_INT_WPROT(0))
+		printk(KERN_ERR MV_DMA "%s: write protection @%x!\n",
+				__func__, val2 & IDMA_INT_WPROT(0) ? addr : 0);
+
+	/* clear interrupt cause register */
+	writel(0, tpg.reg + IDMA_INT_CAUSE);
+
+	return val;
+}
+
+static u32 tdma_print_and_clear_irq(void)
+{
+	u32 val;
+
+	val = readl(tpg.reg + TDMA_ERR_CAUSE);
+
+	if (val & TDMA_INT_MISS)
+		printk(KERN_ERR MV_DMA "%s: miss!\n", __func__);
+	if (val & TDMA_INT_DOUBLE_HIT)
+		printk(KERN_ERR MV_DMA "%s: double hit!\n", __func__);
+	if (val & TDMA_INT_BOTH_HIT)
+		printk(KERN_ERR MV_DMA "%s: both hit!\n", __func__);
+	if (val & TDMA_INT_DATA_ERROR)
+		printk(KERN_ERR MV_DMA "%s: data error!\n", __func__);
+
+	/* clear error cause register */
+	writel(0, tpg.reg + TDMA_ERR_CAUSE);
+
+	return val;
+}
+
+irqreturn_t mv_dma_int(int irq, void *priv)
+{
+	int handled;
+
+	handled = (*tpg.print_and_clear_irq)();
+
+	if (handled) {
+		mv_dma_reg_dump();
+		mv_dma_desc_dump();
+	}
+
+	switch_dma_engine(0);
+	wait_for_dma_idle();
+
+	/* clear descriptor registers */
+	mv_dma_clear_desc_reg();
+
+	switch_dma_engine(1);
+	wait_for_dma_idle();
+
+	return (handled ? IRQ_HANDLED : IRQ_NONE);
+}
+
+/* initialise the global tpg structure */
+static int mv_init_engine(struct platform_device *pdev,
+		u32 ctrl_init_val, u32 (*print_and_clear_irq)(void))
+{
+	struct resource *res;
+	int rc;
+
+	if (tpg.dev) {
+		printk(KERN_ERR MV_DMA "second DMA device?!\n");
+		return -ENXIO;
+	}
+	tpg.dev = &pdev->dev;
+	tpg.print_and_clear_irq = print_and_clear_irq;
+
+	/* get register start address */
+	res = platform_get_resource_byname(pdev,
+			IORESOURCE_MEM, "regs control and error");
+	if (!res)
+		return -ENXIO;
+	if (!(tpg.reg = ioremap(res->start, resource_size(res))))
+		return -ENOMEM;
+
+	/* get the IRQ */
+	tpg.irq = platform_get_irq(pdev, 0);
+	if (tpg.irq < 0 || tpg.irq == NO_IRQ) {
+		rc = -ENXIO;
+		goto out_unmap_reg;
+	}
+
+	/* initialise DMA descriptor list */
+	tpg.descpool = dma_pool_create("MV_DMA Descriptor Pool", tpg.dev,
+			sizeof(struct mv_dma_desc), MV_DMA_ALIGN, 0);
+	if (!tpg.descpool) {
+		rc = -ENOMEM;
+		goto out_free_irq;
+	}
+	set_poolsize(MV_DMA_INIT_POOLSIZE);
+
+	platform_set_drvdata(pdev, &tpg);
+
+	spin_lock_init(&tpg.lock);
+
+	switch_dma_engine(0);
+	wait_for_dma_idle();
+
+	/* clear descriptor registers */
+	mv_dma_clear_desc_reg();
+
+	/* initialize control register (also enables engine) */
+	writel(ctrl_init_val, tpg.reg + DMA_CTRL);
+	wait_for_dma_idle();
+
+	if (request_irq(tpg.irq, mv_dma_int, IRQF_DISABLED,
+				dev_name(tpg.dev), &tpg)) {
+		rc = -ENXIO;
+		goto out_free_all;
+	}
+
+	return 0;
+
+out_free_all:
+	switch_dma_engine(0);
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
+	switch_dma_engine(0);
+	platform_set_drvdata(pdev, NULL);
+	set_poolsize(0);
+	dma_pool_destroy(tpg.descpool);
+	free_irq(tpg.irq, &tpg);
+	iounmap(tpg.reg);
+	tpg.dev = NULL;
+	return 0;
+}
+
+static int mv_probe_tdma(struct platform_device *pdev)
+{
+	int rc;
+
+	rc = mv_init_engine(pdev, TDMA_CTRL_INIT_VALUE,
+			&tdma_print_and_clear_irq);
+	if (rc)
+		return rc;
+
+	/* have an ear for occurring errors */
+	writel(TDMA_INT_ALL, tpg.reg + TDMA_ERR_MASK);
+	writel(0, tpg.reg + TDMA_ERR_CAUSE);
+
+	printk(KERN_INFO MV_DMA
+			"TDMA engine up and running, IRQ %d\n", tpg.irq);
+	return 0;
+}
+
+static int mv_probe_idma(struct platform_device *pdev)
+{
+	int rc;
+
+	rc = mv_init_engine(pdev, IDMA_CTRL_INIT_VALUE,
+			&idma_print_and_clear_irq);
+	if (rc)
+		return rc;
+
+	/* have an ear for occurring errors */
+	writel(IDMA_INT_MISS(0) | IDMA_INT_APROT(0) | IDMA_INT_WPROT(0),
+			tpg.reg + IDMA_INT_MASK);
+	writel(0, tpg.reg + IDMA_INT_CAUSE);
+
+	printk(KERN_INFO MV_DMA
+			"IDMA engine up and running, IRQ %d\n", tpg.irq);
+	return 0;
+}
+
+static struct platform_driver marvell_tdma = {
+	.probe          = mv_probe_tdma,
+	.remove         = mv_remove,
+	.driver         = {
+		.owner  = THIS_MODULE,
+		.name   = "mv_tdma",
+	},
+}, marvell_idma = {
+	.probe          = mv_probe_idma,
+	.remove         = mv_remove,
+	.driver         = {
+		.owner  = THIS_MODULE,
+		.name   = "mv_idma",
+	},
+};
+MODULE_ALIAS("platform:mv_tdma");
+MODULE_ALIAS("platform:mv_idma");
+
+static int __init mv_dma_init(void)
+{
+	tpg.tdma_registered = !platform_driver_register(&marvell_tdma);
+	tpg.idma_registered = !platform_driver_register(&marvell_idma);
+	return !(tpg.tdma_registered || tpg.idma_registered);
+}
+module_init(mv_dma_init);
+
+static void __exit mv_dma_exit(void)
+{
+	if (tpg.tdma_registered)
+		platform_driver_unregister(&marvell_tdma);
+	if (tpg.idma_registered)
+		platform_driver_unregister(&marvell_idma);
+}
+module_exit(mv_dma_exit);
+
+MODULE_AUTHOR("Phil Sutter <phil.sutter@viprinet.com>");
+MODULE_DESCRIPTION("Support for Marvell's IDMA/TDMA engines");
+MODULE_LICENSE("GPL");
+
diff --git a/drivers/crypto/mv_dma.h b/drivers/crypto/mv_dma.h
new file mode 100644
index 0000000..d0c9d0c
--- /dev/null
+++ b/drivers/crypto/mv_dma.h
@@ -0,0 +1,127 @@
+#ifndef _MV_DMA_H
+#define _MV_DMA_H
+
+/* common TDMA_CTRL/IDMA_CTRL_LOW bits */
+#define DMA_CTRL_DST_BURST(x)	(x)
+#define DMA_CTRL_SRC_BURST(x)	(x << 6)
+#define DMA_CTRL_NO_CHAIN_MODE	(1 << 9)
+#define DMA_CTRL_ENABLE		(1 << 12)
+#define DMA_CTRL_FETCH_ND	(1 << 13)
+#define DMA_CTRL_ACTIVE		(1 << 14)
+
+/* TDMA_CTRL register bits */
+#define TDMA_CTRL_DST_BURST_32	DMA_CTRL_DST_BURST(3)
+#define TDMA_CTRL_DST_BURST_128	DMA_CTRL_DST_BURST(4)
+#define TDMA_CTRL_OUTST_RD_EN	(1 << 4)
+#define TDMA_CTRL_SRC_BURST_32	DMA_CTRL_SRC_BURST(3)
+#define TDMA_CTRL_SRC_BURST_128	DMA_CTRL_SRC_BURST(4)
+#define TDMA_CTRL_NO_BYTE_SWAP	(1 << 11)
+
+#define TDMA_CTRL_INIT_VALUE ( \
+	TDMA_CTRL_DST_BURST_128 | TDMA_CTRL_SRC_BURST_128 | \
+	TDMA_CTRL_NO_BYTE_SWAP | DMA_CTRL_ENABLE \
+)
+
+/* IDMA_CTRL_LOW register bits */
+#define IDMA_CTRL_DST_BURST_8	DMA_CTRL_DST_BURST(0)
+#define IDMA_CTRL_DST_BURST_16	DMA_CTRL_DST_BURST(1)
+#define IDMA_CTRL_DST_BURST_32	DMA_CTRL_DST_BURST(3)
+#define IDMA_CTRL_DST_BURST_64	DMA_CTRL_DST_BURST(7)
+#define IDMA_CTRL_DST_BURST_128	DMA_CTRL_DST_BURST(4)
+#define IDMA_CTRL_SRC_HOLD	(1 << 3)
+#define IDMA_CTRL_DST_HOLD	(1 << 5)
+#define IDMA_CTRL_SRC_BURST_8	DMA_CTRL_SRC_BURST(0)
+#define IDMA_CTRL_SRC_BURST_16	DMA_CTRL_SRC_BURST(1)
+#define IDMA_CTRL_SRC_BURST_32	DMA_CTRL_SRC_BURST(3)
+#define IDMA_CTRL_SRC_BURST_64	DMA_CTRL_SRC_BURST(7)
+#define IDMA_CTRL_SRC_BURST_128	DMA_CTRL_SRC_BURST(4)
+#define IDMA_CTRL_INT_MODE	(1 << 10)
+#define IDMA_CTRL_BLOCK_MODE	(1 << 11)
+#define IDMA_CTRL_CLOSE_DESC	(1 << 17)
+#define IDMA_CTRL_ABORT		(1 << 20)
+#define IDMA_CTRL_SADDR_OVR(x)	(x << 21)
+#define IDMA_CTRL_NO_SADDR_OVR	IDMA_CTRL_SADDR_OVR(0)
+#define IDMA_CTRL_SADDR_OVR_1	IDMA_CTRL_SADDR_OVR(1)
+#define IDMA_CTRL_SADDR_OVR_2	IDMA_CTRL_SADDR_OVR(2)
+#define IDMA_CTRL_SADDR_OVR_3	IDMA_CTRL_SADDR_OVR(3)
+#define IDMA_CTRL_DADDR_OVR(x)	(x << 23)
+#define IDMA_CTRL_NO_DADDR_OVR	IDMA_CTRL_DADDR_OVR(0)
+#define IDMA_CTRL_DADDR_OVR_1	IDMA_CTRL_DADDR_OVR(1)
+#define IDMA_CTRL_DADDR_OVR_2	IDMA_CTRL_DADDR_OVR(2)
+#define IDMA_CTRL_DADDR_OVR_3	IDMA_CTRL_DADDR_OVR(3)
+#define IDMA_CTRL_NADDR_OVR(x)	(x << 25)
+#define IDMA_CTRL_NO_NADDR_OVR	IDMA_CTRL_NADDR_OVR(0)
+#define IDMA_CTRL_NADDR_OVR_1	IDMA_CTRL_NADDR_OVR(1)
+#define IDMA_CTRL_NADDR_OVR_2	IDMA_CTRL_NADDR_OVR(2)
+#define IDMA_CTRL_NADDR_OVR_3	IDMA_CTRL_NADDR_OVR(3)
+#define IDMA_CTRL_DESC_MODE_16M	(1 << 31)
+
+#define IDMA_CTRL_INIT_VALUE ( \
+	IDMA_CTRL_DST_BURST_128 | IDMA_CTRL_SRC_BURST_128 | \
+	IDMA_CTRL_INT_MODE | IDMA_CTRL_BLOCK_MODE | \
+	DMA_CTRL_ENABLE | IDMA_CTRL_DESC_MODE_16M \
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
+#define IDMA_BYTE_COUNT(chan)	(0x00 + (chan) * 4)
+#define IDMA_SRC_ADDR(chan)	(0x10 + (chan) * 4)
+#define IDMA_DST_ADDR(chan)	(0x20 + (chan) * 4)
+#define IDMA_NEXT_DESC(chan)	(0x30 + (chan) * 4)
+#define IDMA_CTRL_LOW(chan)	(0x40 + (chan) * 4)
+#define IDMA_CURR_DESC(chan)	(0x70 + (chan) * 4)
+#define IDMA_CTRL_HIGH(chan)	(0x80 + (chan) * 4)
+#define IDMA_INT_CAUSE		(0xc0)
+#define IDMA_INT_MASK		(0xc4)
+#define IDMA_ERR_ADDR		(0xc8)
+#define IDMA_ERR_SELECT		(0xcc)
+
+/* register offsets common to TDMA and IDMA channel 0 */
+#define DMA_BYTE_COUNT		TDMA_BYTE_COUNT
+#define DMA_SRC_ADDR		TDMA_SRC_ADDR
+#define DMA_DST_ADDR		TDMA_DST_ADDR
+#define DMA_NEXT_DESC		TDMA_NEXT_DESC
+#define DMA_CTRL		TDMA_CTRL
+#define DMA_CURR_DESC		TDMA_CURR_DESC
+
+/* IDMA_INT_CAUSE and IDMA_INT_MASK bits */
+#define IDMA_INT_COMP(chan)	((1 << 0) << ((chan) * 8))
+#define IDMA_INT_MISS(chan)	((1 << 1) << ((chan) * 8))
+#define IDMA_INT_APROT(chan)	((1 << 2) << ((chan) * 8))
+#define IDMA_INT_WPROT(chan)	((1 << 3) << ((chan) * 8))
+#define IDMA_INT_OWN(chan)	((1 << 4) << ((chan) * 8))
+#define IDMA_INT_ALL(chan)	(0x1f << (chan) * 8)
+
+/* Owner bit in DMA_BYTE_COUNT and descriptors' count field, used
+ * to signal input data completion in descriptor chain */
+#define DMA_OWN_BIT		(1 << 31)
+
+/* IDMA also has a "Left Byte Count" bit,
+ * indicating not everything was transfered */
+#define IDMA_LEFT_BYTE_COUNT	(1 << 30)
+
+/* filter the actual byte count value from the DMA_BYTE_COUNT field */
+#define DMA_BYTE_COUNT_MASK	(~(DMA_OWN_BIT | IDMA_LEFT_BYTE_COUNT))
+
+extern void mv_dma_memcpy(dma_addr_t, dma_addr_t, unsigned int);
+extern void mv_dma_separator(void);
+extern void mv_dma_clear(void);
+extern void mv_dma_trigger(void);
+
+
+#endif /* _MV_DMA_H */
-- 
1.7.3.4
