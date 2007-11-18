From: Patrick McHardy <kaber@trash.net>
Subject: [HIFN 02/03]: Improve PLL initialization
Date: Sun, 18 Nov 2007 22:32:55 +0100 (MET)
Message-ID: <20071118213245.9217.79272.sendpatchset@localhost.localdomain>
References: <20071118213241.9217.7696.sendpatchset@localhost.localdomain>
Cc: johnpol@2ka.mipt.ru, Patrick McHardy <kaber@trash.net>,
	linux-crypto@vger.kernel.org, mb@bu3sch.de,
	linux-kernel@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46276 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754101AbXKRVc5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 18 Nov 2007 16:32:57 -0500
In-Reply-To: <20071118213241.9217.7696.sendpatchset@localhost.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

[HIFN]: Improve PLL initialization

The current PLL initalization has a number of deficiencies:

- uses fixed multiplier of 8, which overclocks the chip when using a
  reference clock that operates at frequencies above 33MHz. According
  to a comment in the BSD source, this is true for the external clock
  on almost all every board.

- writes to a reserved bit

- doesn't follow the initialization procedure specified in chapter
  6.11.1 of the HIFN hardware users guide

- doesn't allow to use the PCI clock

This patch adds a module parameter to specify the reference clock
(pci or external) and its frequency and uses that to calculate the
optimum multiplier to reach the maximal speed. By default it uses
the external clock and assumes a speed of 66MHz, which effectively
halfs the frequency currently used.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 70467fae3a656562f86adefdfe6d54e3ca20feeb
tree 9fc347d453e04e21f243693ede743f6a8e280ef2
parent 5632554998aafc5605635f842bca50d5353cd9d4
author Patrick McHardy <kaber@trash.net> Sun, 18 Nov 2007 22:09:17 +0100
committer Patrick McHardy <kaber@trash.net> Sun, 18 Nov 2007 22:09:17 +0100

 drivers/crypto/hifn_795x.c |  110 +++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 108 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index bf817d4..de594bc 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -19,6 +19,7 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/moduleparam.h>
 #include <linux/mod_devicetable.h>
 #include <linux/interrupt.h>
 #include <linux/pci.h>
@@ -47,6 +48,11 @@
 #define dprintk(f, a...)	do {} while (0)
 #endif
 
+static char hifn_pll_ref[sizeof("extNNN")] = "ext";
+module_param_string(hifn_pll_ref, hifn_pll_ref, sizeof(hifn_pll_ref), 0444);
+MODULE_PARM_DESC(hifn_pll_ref,
+		 "PLL reference clock (pci[freq] or ext[freq], default ext)");
+
 static atomic_t hifn_dev_number;
 
 #define ACRYPTO_OP_DECRYPT	0
@@ -286,7 +292,26 @@ static atomic_t hifn_dev_number;
 #define	HIFN_DMACNFG_DMARESET	0x00000002	/* DMA Reset # */
 #define	HIFN_DMACNFG_MSTRESET	0x00000001	/* Master Reset # */
 
-#define	HIFN_PLL_7956		0x00001d18	/* 7956 PLL config value */
+/* PLL configuration register */
+#define HIFN_PLL_REF_CLK_HBI	0x00000000	/* HBI reference clock */
+#define HIFN_PLL_REF_CLK_PLL	0x00000001	/* PLL reference clock */
+#define HIFN_PLL_BP		0x00000002	/* Reference clock bypass */
+#define HIFN_PLL_PK_CLK_HBI	0x00000000	/* PK engine HBI clock */
+#define HIFN_PLL_PK_CLK_PLL	0x00000008	/* PK engine PLL clock */
+#define HIFN_PLL_PE_CLK_HBI	0x00000000	/* PE engine HBI clock */
+#define HIFN_PLL_PE_CLK_PLL	0x00000010	/* PE engine PLL clock */
+#define HIFN_PLL_RESERVED_1	0x00000400	/* Reserved bit, must be 1 */
+#define HIFN_PLL_ND_SHIFT	11		/* Clock multiplier shift */
+#define HIFN_PLL_ND_MULT_2	0x00000000	/* PLL clock multiplier 2 */
+#define HIFN_PLL_ND_MULT_4	0x00000800	/* PLL clock multiplier 4 */
+#define HIFN_PLL_ND_MULT_6	0x00001000	/* PLL clock multiplier 6 */
+#define HIFN_PLL_ND_MULT_8	0x00001800	/* PLL clock multiplier 8 */
+#define HIFN_PLL_ND_MULT_10	0x00002000	/* PLL clock multiplier 10 */
+#define HIFN_PLL_ND_MULT_12	0x00002800	/* PLL clock multiplier 12 */
+#define HIFN_PLL_IS_1_8		0x00000000	/* charge pump (mult. 1-8) */
+#define HIFN_PLL_IS_9_12	0x00010000	/* charge pump (mult. 9-12) */
+
+#define HIFN_PLL_FCK_MAX	266		/* Maximum PLL frequency */
 
 /* Public key reset register (HIFN_1_PUB_RESET) */
 #define	HIFN_PUBRST_RESET	0x00000001	/* reset public/rng unit */
@@ -871,6 +896,64 @@ static void hifn_init_dma(struct hifn_device *dev)
 	dma->cmdk = dma->srck = dma->dstk = dma->resk = 0;
 }
 
+/*
+ * Initialize the PLL. We need to know the frequency of the reference clock
+ * to calculate the optimal multiplier. For PCI we assume 66MHz, since that
+ * allows us to operate without the risk of overclocking the chip. If it
+ * actually uses 33MHz, the chip will operate at half the speed, this can be
+ * overriden by specifying the frequency as module parameter (pci33).
+ *
+ * Unfortunately the PCI clock is not very suitable since the HIFN needs a
+ * stable clock and the PCI clock frequency may vary, so the default is the
+ * external clock. There is no way to find out its frequency, we default to
+ * 66MHz since according to Mike Ham of HiFn, almost every board in existence
+ * has an external crystal populated at 66MHz.
+ */
+static void hifn_init_pll(struct hifn_device *dev)
+{
+	unsigned int freq, m;
+	u32 pllcfg;
+
+	pllcfg = HIFN_1_PLL | HIFN_PLL_RESERVED_1;
+
+	if (strncmp(hifn_pll_ref, "ext", 3) == 0)
+		pllcfg |= HIFN_PLL_REF_CLK_PLL;
+	else
+		pllcfg |= HIFN_PLL_REF_CLK_HBI;
+
+	if (hifn_pll_ref[3] != '\0')
+		freq = simple_strtoul(hifn_pll_ref + 3, NULL, 10);
+	else {
+		freq = 66;
+		printk(KERN_INFO "hifn795x: assuming %uMHz clock speed, "
+				 "override with hifn_pll_ref=%.3s<frequency>\n",
+		       freq, hifn_pll_ref);
+	}
+
+	m = HIFN_PLL_FCK_MAX / freq;
+
+	pllcfg |= (m / 2 - 1) << HIFN_PLL_ND_SHIFT;
+	if (m <= 8)
+		pllcfg |= HIFN_PLL_IS_1_8;
+	else
+		pllcfg |= HIFN_PLL_IS_9_12;
+
+	/* Select clock source and enable clock bypass */
+	hifn_write_1(dev, HIFN_1_PLL, pllcfg |
+		     HIFN_PLL_PK_CLK_HBI | HIFN_PLL_PE_CLK_HBI | HIFN_PLL_BP);
+
+	/* Let the chip lock to the input clock */
+	mdelay(10);
+
+	/* Disable clock bypass */
+	hifn_write_1(dev, HIFN_1_PLL, pllcfg |
+		     HIFN_PLL_PK_CLK_HBI | HIFN_PLL_PE_CLK_HBI);
+
+	/* Switch the engines to the PLL */
+	hifn_write_1(dev, HIFN_1_PLL, pllcfg |
+		     HIFN_PLL_PK_CLK_PLL | HIFN_PLL_PE_CLK_PLL);
+}
+
 static void hifn_init_registers(struct hifn_device *dev)
 {
 	u32 dptr = dev->desc_dma;
@@ -938,7 +1021,7 @@ static void hifn_init_registers(struct hifn_device *dev)
 #else
 	hifn_write_0(dev, HIFN_0_PUCNFG, 0x10342);
 #endif
-	hifn_write_1(dev, HIFN_1_PLL, HIFN_PLL_7956);
+	hifn_init_pll(dev);
 
 	hifn_write_0(dev, HIFN_0_PUISR, HIFN_PUISR_DSTOVER);
 	hifn_write_1(dev, HIFN_1_DMA_CNFG, HIFN_DMACNFG_MSTRESET |
@@ -2621,8 +2704,31 @@ static struct pci_driver hifn_pci_driver = {
 
 static int __devinit hifn_init(void)
 {
+	unsigned int freq;
 	int err;
 
+	if (strncmp(hifn_pll_ref, "ext", 3) &&
+	    strncmp(hifn_pll_ref, "pci", 3)) {
+		printk(KERN_ERR "hifn795x: invalid hifn_pll_ref clock, "
+				"must be pci or ext");
+		return -EINVAL;
+	}
+
+	/*
+	 * For the 7955/7956 the reference clock frequency must be in the
+	 * range of 20MHz-100MHz. For the 7954 the upper bound is 66.67MHz,
+	 * but this chip is currently not supported.
+	 */
+	if (hifn_pll_ref[3] != '\0') {
+		freq = simple_strtoul(hifn_pll_ref + 3, NULL, 10);
+		if (freq < 20 || freq > 100) {
+			printk(KERN_ERR "hifn795x: invalid hifn_pll_ref "
+					"frequency, must be in the range "
+					"of 20-100");
+			return -EINVAL;
+		}
+	}
+
 	err = pci_register_driver(&hifn_pci_driver);
 	if (err < 0) {
 		dprintk("Failed to register PCI driver for %s device.\n",
