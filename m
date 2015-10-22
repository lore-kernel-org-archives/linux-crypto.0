From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH 1/4] crypto: hifn_795x: replace simple_strtoul by kstrtouint
Date: Thu, 22 Oct 2015 08:51:49 +0200
Message-ID: <1445496712-5654-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: LABBE Corentin <clabbe.montjoie@gmail.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: davem@davemloft.net, herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The simple_strtoul function is marked as obsolete.
This patch replace it by kstrtouint at the cost of changing some function
return type from void to int.

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 drivers/crypto/hifn_795x.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index 8d2a772..079b995 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -970,10 +970,11 @@ static void hifn_init_dma(struct hifn_device *dev)
  * 66MHz since according to Mike Ham of HiFn, almost every board in existence
  * has an external crystal populated at 66MHz.
  */
-static void hifn_init_pll(struct hifn_device *dev)
+static int hifn_init_pll(struct hifn_device *dev)
 {
 	unsigned int freq, m;
 	u32 pllcfg;
+	int err;
 
 	pllcfg = HIFN_1_PLL | HIFN_PLL_RESERVED_1;
 
@@ -982,9 +983,11 @@ static void hifn_init_pll(struct hifn_device *dev)
 	else
 		pllcfg |= HIFN_PLL_REF_CLK_HBI;
 
-	if (hifn_pll_ref[3] != '\0')
-		freq = simple_strtoul(hifn_pll_ref + 3, NULL, 10);
-	else {
+	if (hifn_pll_ref[3] != '\0') {
+		err = kstrtouint(hifn_pll_ref + 3, 10, &freq);
+		if (err)
+			return err;
+	} else {
 		freq = 66;
 		printk(KERN_INFO "hifn795x: assuming %uMHz clock speed, "
 				 "override with hifn_pll_ref=%.3s<frequency>\n",
@@ -1021,11 +1024,13 @@ static void hifn_init_pll(struct hifn_device *dev)
 	 * in slightly larger intervals.
 	 */
 	dev->pk_clk_freq = 1000000 * (freq + 1) * m / 2;
+	return 0;
 }
 
-static void hifn_init_registers(struct hifn_device *dev)
+static int hifn_init_registers(struct hifn_device *dev)
 {
 	u32 dptr = dev->desc_dma;
+	int err;
 
 	/* Initialization magic... */
 	hifn_write_0(dev, HIFN_0_PUCTRL, HIFN_PUCTRL_DMAENA);
@@ -1090,13 +1095,16 @@ static void hifn_init_registers(struct hifn_device *dev)
 #else
 	hifn_write_0(dev, HIFN_0_PUCNFG, 0x10342);
 #endif
-	hifn_init_pll(dev);
+	err = hifn_init_pll(dev);
+	if (err)
+		return err;
 
 	hifn_write_0(dev, HIFN_0_PUISR, HIFN_PUISR_DSTOVER);
 	hifn_write_1(dev, HIFN_1_DMA_CNFG, HIFN_DMACNFG_MSTRESET |
 	    HIFN_DMACNFG_DMARESET | HIFN_DMACNFG_MODE | HIFN_DMACNFG_LAST |
 	    ((HIFN_POLL_FREQUENCY << 16 ) & HIFN_DMACNFG_POLLFREQ) |
 	    ((HIFN_POLL_SCALAR << 8) & HIFN_DMACNFG_POLLINVAL));
+	return 0;
 }
 
 static int hifn_setup_base_command(struct hifn_device *dev, u8 *buf,
@@ -1711,7 +1719,9 @@ static int hifn_start_device(struct hifn_device *dev)
 
 	hifn_init_dma(dev);
 
-	hifn_init_registers(dev);
+	err = hifn_init_registers(dev);
+	if (err)
+		return err;
 
 	hifn_init_pubrng(dev);
 
@@ -2763,7 +2773,9 @@ static int __init hifn_init(void)
 	 * but this chip is currently not supported.
 	 */
 	if (hifn_pll_ref[3] != '\0') {
-		freq = simple_strtoul(hifn_pll_ref + 3, NULL, 10);
+		err = kstrtouint(hifn_pll_ref + 3, 10, &freq);
+		if (err)
+			return err;
 		if (freq < 20 || freq > 100) {
 			printk(KERN_ERR "hifn795x: invalid hifn_pll_ref "
 					"frequency, must be in the range "
-- 
2.4.10
