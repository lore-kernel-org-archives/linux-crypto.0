From: Ruchika Gupta <ruchika.gupta@freescale.com>
Subject: [PATCH] crypto:caam - Modify width of few read only registers
Date: Tue, 29 Apr 2014 15:34:37 +0530
Message-ID: <1398765877-24779-1-git-send-email-ruchika.gupta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Ruchika Gupta <ruchika.gupta@freescale.com>
To: <linux-crypto@vger.kernel.org>, <herbert@gondor.apana.org.au>,
	<kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1blp0182.outbound.protection.outlook.com ([207.46.163.182]:14103
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933570AbaD2KHG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 29 Apr 2014 06:07:06 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Few read only registers like CHAVID, CTPR etc were wrongly defined
as 64 bit registers. This functioned properly on the powerpc platforms.
However ARM SoC's wouldn't function correctly if these registers
are defined as 64 bit. So correcting the definition to two 32 bit registers.

Signed-off-by: Ruchika Gupta <ruchika.gupta@freescale.com>
---
 drivers/crypto/caam/ctrl.c | 17 +++++------
 drivers/crypto/caam/regs.h | 71 +++++++++++++++++++++++++---------------------
 2 files changed, 47 insertions(+), 41 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 1c38f86..5d8782e8 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -371,7 +371,7 @@ EXPORT_SYMBOL(caam_get_era);
 static int caam_probe(struct platform_device *pdev)
 {
 	int ret, ring, rspec, gen_sk, ent_delay = RTSDCTL_ENT_DLY_MIN;
-	u64 caam_id;
+	u32 caam_id;
 	struct device *dev;
 	struct device_node *nprop, *np;
 	struct caam_ctrl __iomem *ctrl;
@@ -380,7 +380,7 @@ static int caam_probe(struct platform_device *pdev)
 #ifdef CONFIG_DEBUG_FS
 	struct caam_perfmon *perfmon;
 #endif
-	u64 cha_vid;
+	u32 cha_vid_ls;
 
 	ctrlpriv = kzalloc(sizeof(struct caam_drv_private), GFP_KERNEL);
 	if (!ctrlpriv)
@@ -456,8 +456,9 @@ static int caam_probe(struct platform_device *pdev)
 		}
 
 	/* Check to see if QI present. If so, enable */
-	ctrlpriv->qi_present = !!(rd_reg64(&topregs->ctrl.perfmon.comp_parms) &
-				  CTPR_QI_MASK);
+	ctrlpriv->qi_present =
+			!!(rd_reg32(&topregs->ctrl.perfmon.comp_parms_ms) &
+				  CTPR_MS_QI_MASK);
 	if (ctrlpriv->qi_present) {
 		ctrlpriv->qi = (struct caam_queue_if __force *)&topregs->qi;
 		/* This is all that's required to physically enable QI */
@@ -471,13 +472,13 @@ static int caam_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	cha_vid = rd_reg64(&topregs->ctrl.perfmon.cha_id);
+	cha_vid_ls = rd_reg32(&topregs->ctrl.perfmon.cha_id_ls);
 
 	/*
 	 * If SEC has RNG version >= 4 and RNG state handle has not been
 	 * already instantiated, do RNG instantiation
 	 */
-	if ((cha_vid & CHA_ID_RNG_MASK) >> CHA_ID_RNG_SHIFT >= 4) {
+	if ((cha_vid_ls & CHA_ID_LS_RNG_MASK) >> CHA_ID_LS_RNG_SHIFT >= 4) {
 		ctrlpriv->rng4_sh_init =
 			rd_reg32(&topregs->ctrl.r4tst[0].rdsta);
 		/*
@@ -531,10 +532,10 @@ static int caam_probe(struct platform_device *pdev)
 
 	/* NOTE: RTIC detection ought to go here, around Si time */
 
-	caam_id = rd_reg64(&topregs->ctrl.perfmon.caam_id);
+	caam_id = rd_reg32(&topregs->ctrl.perfmon.caam_id_ms);
 
 	/* Report "alive" for developer to see */
-	dev_info(dev, "device ID = 0x%016llx (Era %d)\n", caam_id,
+	dev_info(dev, "device ID = 0x%08x (Era %d)\n", caam_id,
 		 caam_get_era());
 	dev_info(dev, "job rings = %d, qi = %d\n",
 		 ctrlpriv->total_jobrs, ctrlpriv->qi_present);
diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h
index cbde8b9..7bb898d 100644
--- a/drivers/crypto/caam/regs.h
+++ b/drivers/crypto/caam/regs.h
@@ -114,45 +114,45 @@ struct jr_outentry {
  */
 
 /* Number of DECOs */
-#define CHA_NUM_DECONUM_SHIFT	56
-#define CHA_NUM_DECONUM_MASK	(0xfull << CHA_NUM_DECONUM_SHIFT)
+#define CHA_NUM_MS_DECONUM_SHIFT	24
+#define CHA_NUM_MS_DECONUM_MASK	(0xfull << CHA_NUM_MS_DECONUM_SHIFT)
 
 /* CHA Version IDs */
-#define CHA_ID_AES_SHIFT	0
-#define CHA_ID_AES_MASK		(0xfull << CHA_ID_AES_SHIFT)
+#define CHA_ID_LS_AES_SHIFT	0
+#define CHA_ID_LS_AES_MASK		(0xfull << CHA_ID_LS_AES_SHIFT)
 
-#define CHA_ID_DES_SHIFT	4
-#define CHA_ID_DES_MASK		(0xfull << CHA_ID_DES_SHIFT)
+#define CHA_ID_LS_DES_SHIFT	4
+#define CHA_ID_LS_DES_MASK		(0xfull << CHA_ID_LS_DES_SHIFT)
 
-#define CHA_ID_ARC4_SHIFT	8
-#define CHA_ID_ARC4_MASK	(0xfull << CHA_ID_ARC4_SHIFT)
+#define CHA_ID_LS_ARC4_SHIFT	8
+#define CHA_ID_LS_ARC4_MASK	(0xfull << CHA_ID_LS_ARC4_SHIFT)
 
-#define CHA_ID_MD_SHIFT		12
-#define CHA_ID_MD_MASK		(0xfull << CHA_ID_MD_SHIFT)
+#define CHA_ID_LS_MD_SHIFT	12
+#define CHA_ID_LS_MD_MASK	(0xfull << CHA_ID_LS_MD_SHIFT)
 
-#define CHA_ID_RNG_SHIFT	16
-#define CHA_ID_RNG_MASK		(0xfull << CHA_ID_RNG_SHIFT)
+#define CHA_ID_LS_RNG_SHIFT	16
+#define CHA_ID_LS_RNG_MASK	(0xfull << CHA_ID_LS_RNG_SHIFT)
 
-#define CHA_ID_SNW8_SHIFT	20
-#define CHA_ID_SNW8_MASK	(0xfull << CHA_ID_SNW8_SHIFT)
+#define CHA_ID_LS_SNW8_SHIFT	20
+#define CHA_ID_LS_SNW8_MASK	(0xfull << CHA_ID_LS_SNW8_SHIFT)
 
-#define CHA_ID_KAS_SHIFT	24
-#define CHA_ID_KAS_MASK		(0xfull << CHA_ID_KAS_SHIFT)
+#define CHA_ID_LS_KAS_SHIFT	24
+#define CHA_ID_LS_KAS_MASK	(0xfull << CHA_ID_LS_KAS_SHIFT)
 
-#define CHA_ID_PK_SHIFT		28
-#define CHA_ID_PK_MASK		(0xfull << CHA_ID_PK_SHIFT)
+#define CHA_ID_LS_PK_SHIFT	28
+#define CHA_ID_LS_PK_MASK	(0xfull << CHA_ID_LS_PK_SHIFT)
 
-#define CHA_ID_CRC_SHIFT	32
-#define CHA_ID_CRC_MASK		(0xfull << CHA_ID_CRC_SHIFT)
+#define CHA_ID_MS_CRC_SHIFT	0
+#define CHA_ID_MS_CRC_MASK	(0xfull << CHA_ID_MS_CRC_SHIFT)
 
-#define CHA_ID_SNW9_SHIFT	36
-#define CHA_ID_SNW9_MASK	(0xfull << CHA_ID_SNW9_SHIFT)
+#define CHA_ID_MS_SNW9_SHIFT	4
+#define CHA_ID_MS_SNW9_MASK	(0xfull << CHA_ID_MS_SNW9_SHIFT)
 
-#define CHA_ID_DECO_SHIFT	56
-#define CHA_ID_DECO_MASK	(0xfull << CHA_ID_DECO_SHIFT)
+#define CHA_ID_MS_DECO_SHIFT	24
+#define CHA_ID_MS_DECO_MASK	(0xfull << CHA_ID_MS_DECO_SHIFT)
 
-#define CHA_ID_JR_SHIFT		60
-#define CHA_ID_JR_MASK		(0xfull << CHA_ID_JR_SHIFT)
+#define CHA_ID_MS_JR_SHIFT	28
+#define CHA_ID_MS_JR_MASK	(0xfull << CHA_ID_MS_JR_SHIFT)
 
 struct sec_vid {
 	u16 ip_id;
@@ -172,10 +172,12 @@ struct caam_perfmon {
 	u64 rsvd[13];
 
 	/* CAAM Hardware Instantiation Parameters		fa0-fbf */
-	u64 cha_rev;		/* CRNR - CHA Revision Number		*/
-#define CTPR_QI_SHIFT		57
-#define CTPR_QI_MASK		(0x1ull << CTPR_QI_SHIFT)
-	u64 comp_parms;	/* CTPR - Compile Parameters Register	*/
+	u32 cha_rev_ms;		/* CRNR - CHA Rev No. Most significant half*/
+	u32 cha_rev_ls;		/* CRNR - CHA Rev No. Least significant half*/
+#define CTPR_MS_QI_SHIFT	25
+#define CTPR_MS_QI_MASK		(0x1ull << CTPR_MS_QI_SHIFT)
+	u32 comp_parms_ms;	/* CTPR - Compile Parameters Register	*/
+	u32 comp_parms_ls;	/* CTPR - Compile Parameters Register	*/
 	u64 rsvd1[2];
 
 	/* CAAM Global Status					fc0-fdf */
@@ -189,9 +191,12 @@ struct caam_perfmon {
 	/* Component Instantiation Parameters			fe0-fff */
 	u32 rtic_id;		/* RVID - RTIC Version ID	*/
 	u32 ccb_id;		/* CCBVID - CCB Version ID	*/
-	u64 cha_id;		/* CHAVID - CHA Version ID	*/
-	u64 cha_num;		/* CHANUM - CHA Number		*/
-	u64 caam_id;		/* CAAMVID - CAAM Version ID	*/
+	u32 cha_id_ms;		/* CHAVID - CHA Version ID Most Significant*/
+	u32 cha_id_ls;		/* CHAVID - CHA Version ID Least Significant*/
+	u32 cha_num_ms;		/* CHANUM - CHA Number Most Significant	*/
+	u32 cha_num_ls;		/* CHANUM - CHA Number Least Significant*/
+	u32 caam_id_ms;		/* CAAMVID - CAAM Version ID MS	*/
+	u32 caam_id_ls;		/* CAAMVID - CAAM Version ID LS	*/
 };
 
 /* LIODN programming for DMA configuration */
-- 
1.8.1.4
