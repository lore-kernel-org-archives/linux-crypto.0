From: Alex Porosanu <alexandru.porosanu@freescale.com>
Subject: [PATCH 3/7] crypto: caam - fix RNG4 instantiation
Date: Mon, 9 Sep 2013 18:56:30 +0300
Message-ID: <1378742194-32194-4-git-send-email-alexandru.porosanu@freescale.com>
References: <1378742194-32194-1-git-send-email-alexandru.porosanu@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <herbert@gondor.hengli.com.au>, <horia.geanta@freescale.com>,
	<vakul@freescale.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:30526
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751113Ab3IIP71 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 9 Sep 2013 11:59:27 -0400
In-Reply-To: <1378742194-32194-1-git-send-email-alexandru.porosanu@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The RNG4 block in CAAM needs to be 'seeded' first before being used
for generating pseudo-random data. The 'seeding' is done by getting
entropy from the TRNG ring oscillator. The RTFRQMAX register controls
the maximum allowable number of samples that can be aquired during
an entropy sample. Depending on the clock at which the RNG4 block
(and for that matter the SEC block) runs, it's possible that a
hard-coded value for the maximum frequency is inadequate, i.e. more
samples than needed are taken. This is an error, and thus the RNG4
block doesn't get initialized.  The patch attempts to alleviate
this issue by trying with progressivly larger frequencies, until
the number of samples is adequate.
This patch also fixes how a descriptor is deemed as being finished:
instead of checking the VALID field in the DECO debug register,
it makes sure that the DECO is idle, by checking the DECO state field
of the said register.

Signed-off-by: Alex Porosanu <alexandru.porosanu@freescale.com>
---
 drivers/crypto/caam/ctrl.c |   63 ++++++++++++++++++++++++++++++++-----------
 drivers/crypto/caam/regs.h |    7 +++-
 2 files changed, 52 insertions(+), 18 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 11c7f29..d5fe5f5 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -82,7 +82,7 @@ static int instantiate_rng(struct device *ctrldev)
 	struct caam_drv_private *ctrlpriv = dev_get_drvdata(ctrldev);
 	struct caam_full __iomem *topregs;
 	unsigned int timeout = 100000;
-	u32 *desc;
+	u32 *desc, deco_dbg_reg;
 	int i, ret = 0;
 
 	desc = kmalloc(CAAM_CMD_SZ * 7, GFP_KERNEL | GFP_DMA);
@@ -112,9 +112,17 @@ static int instantiate_rng(struct device *ctrldev)
 	wr_reg32(&topregs->deco.jr_ctl_hi, DECO_JQCR_WHL | DECO_JQCR_FOUR);
 
 	timeout = 10000000;
-	while ((rd_reg32(&topregs->deco.desc_dbg) & DECO_DBG_VALID) &&
-								 --timeout)
+	do {
+		deco_dbg_reg = rd_reg32(&topregs->deco.desc_dbg);
+		/*
+		 * If an error occured in the descriptor, then
+		 * the DECO status field will be set to 0x0D
+		 */
+		if ((deco_dbg_reg & DESC_DBG_DECO_STAT_MASK) ==
+		    DESC_DBG_DECO_STAT_HOST_ERR)
+			break;
 		cpu_relax();
+	} while ((deco_dbg_reg & DESC_DBG_DECO_STAT_VALID) && --timeout);
 
 	if (!timeout) {
 		dev_err(ctrldev, "failed to instantiate RNG\n");
@@ -128,10 +136,12 @@ out:
 }
 
 /*
- * By default, the TRNG runs for 200 clocks per sample;
- * 1600 clocks per sample generates better entropy.
+ * kick_trng - sets the various parameters for enabling the initialization
+ *	       of the RNG4 block in CAAM
+ * @pdev - pointer to the platform device
+ * @ent_delay - Defines the length (in system clocks) of each entropy sample.
  */
-static void kick_trng(struct platform_device *pdev)
+static void kick_trng(struct platform_device *pdev, int ent_delay)
 {
 	struct device *ctrldev = &pdev->dev;
 	struct caam_drv_private *ctrlpriv = dev_get_drvdata(ctrldev);
@@ -144,14 +154,31 @@ static void kick_trng(struct platform_device *pdev)
 
 	/* put RNG4 into program mode */
 	setbits32(&r4tst->rtmctl, RTMCTL_PRGM);
-	/* 1600 clocks per sample */
+
+	/*
+	 * Performance-wise, it does not make sense to
+	 * set the delay to a value that is lower
+	 * than the last one that worked (i.e. the state handles
+	 * were instantiated properly. Thus, instead of wasting
+	 * time trying to set the values controlling the sample
+	 * frequency, the function simply returns.
+	 */
+	val = (rd_reg32(&r4tst->rtsdctl) & RTSDCTL_ENT_DLY_MASK)
+	      >> RTSDCTL_ENT_DLY_SHIFT;
+	if (ent_delay <= val) {
+		/* put RNG4 into run mode */
+		clrbits32(&r4tst->rtmctl, RTMCTL_PRGM);
+		return;
+	}
+
 	val = rd_reg32(&r4tst->rtsdctl);
-	val = (val & ~RTSDCTL_ENT_DLY_MASK) | (1600 << RTSDCTL_ENT_DLY_SHIFT);
+	val = (val & ~RTSDCTL_ENT_DLY_MASK) |
+	      (ent_delay << RTSDCTL_ENT_DLY_SHIFT);
 	wr_reg32(&r4tst->rtsdctl, val);
-	/* min. freq. count */
-	wr_reg32(&r4tst->rtfrqmin, 400);
-	/* max. freq. count */
-	wr_reg32(&r4tst->rtfrqmax, 6400);
+	/* min. freq. count, equal to 1/4 of the entropy sample length */
+	wr_reg32(&r4tst->rtfrqmin, ent_delay >> 2);
+	/* max. freq. count, equal to 8 times the entropy sample length */
+	wr_reg32(&r4tst->rtfrqmax, ent_delay << 3);
 	/* put RNG4 into run mode */
 	clrbits32(&r4tst->rtmctl, RTMCTL_PRGM);
 }
@@ -192,7 +219,7 @@ EXPORT_SYMBOL(caam_get_era);
 /* Probe routine for CAAM top (controller) level */
 static int caam_probe(struct platform_device *pdev)
 {
-	int ret, ring, rspec;
+	int ret, ring, rspec, ent_delay = RTSDCTL_ENT_DLY_MIN;
 	u64 caam_id;
 	struct device *dev;
 	struct device_node *nprop, *np;
@@ -298,13 +325,17 @@ static int caam_probe(struct platform_device *pdev)
 
 	/*
 	 * If SEC has RNG version >= 4 and RNG state handle has not been
-	 * already instantiated ,do RNG instantiation
+	 * already instantiated, do RNG instantiation
 	 */
 	if ((cha_vid & CHA_ID_RNG_MASK) >> CHA_ID_RNG_SHIFT >= 4 &&
 	    !(rd_reg32(&topregs->ctrl.r4tst[0].rdsta) & RDSTA_IF0)) {
-		kick_trng(pdev);
-		ret = instantiate_rng(dev);
+		do {
+			kick_trng(pdev, ent_delay);
+			ret = instantiate_rng(dev);
+			ent_delay += 400;
+		} while ((ret == -EIO) && (ent_delay < RTSDCTL_ENT_DLY_MAX));
 		if (ret) {
+			dev_err(dev, "failed to instantiate RNG");
 			caam_remove(pdev);
 			return ret;
 		}
diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h
index 4455396..9aa9f71 100644
--- a/drivers/crypto/caam/regs.h
+++ b/drivers/crypto/caam/regs.h
@@ -255,6 +255,8 @@ struct rng4tst {
 	};
 #define RTSDCTL_ENT_DLY_SHIFT 16
 #define RTSDCTL_ENT_DLY_MASK (0xffff << RTSDCTL_ENT_DLY_SHIFT)
+#define RTSDCTL_ENT_DLY_MIN 1200
+#define RTSDCTL_ENT_DLY_MAX 12800
 	u32 rtsdctl;		/* seed control register */
 	union {
 		u32 rtsblim;	/* PRGM=1: sparse bit limit register */
@@ -706,12 +708,13 @@ struct caam_deco {
 	u32 rsvd29[48];
 	u32 descbuf[64];	/* DxDESB - Descriptor buffer */
 	u32 rscvd30[193];
+#define DESC_DBG_DECO_STAT_HOST_ERR	0x00D00000
+#define DESC_DBG_DECO_STAT_VALID	0x80000000
+#define DESC_DBG_DECO_STAT_MASK		0x00F00000
 	u32 desc_dbg;		/* DxDDR - DECO Debug Register */
 	u32 rsvd31[126];
 };
 
-/* DECO DBG Register Valid Bit*/
-#define DECO_DBG_VALID		0x80000000
 #define DECO_JQCR_WHL		0x20000000
 #define DECO_JQCR_FOUR		0x10000000
 
-- 
1.7.7.6
