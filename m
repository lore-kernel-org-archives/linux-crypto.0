From: "NiteshNarayanLal@freescale.com" <NiteshNarayanLal@freescale.com>
Subject: RE: [PATCH] crypto: caam - Dynamic allocation of addresses for
 various memory blocks in CAAM.
Date: Mon, 15 Sep 2014 07:26:08 +0000
Message-ID: <df0e3eae74b64ac49884b19e18c0c354@BN1PR0301MB0628.namprd03.prod.outlook.com>
References: <1409563844-5477-1-git-send-email-b44382@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: Ruchika Gupta <ruchika.gupta@freescale.com>
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2on0105.outbound.protection.outlook.com ([65.55.169.105]:38655
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753387AbaIOH6g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Sep 2014 03:58:36 -0400
In-Reply-To: <1409563844-5477-1-git-send-email-b44382@freescale.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

Can you please pick this patch up.

Regards
Nitesh

-----Original Message-----
From: Nitesh Narayan Lal [mailto:b44382@freescale.com] 
Sent: Monday, September 01, 2014 3:01 PM
To: linux-crypto@vger.kernel.org; herbert@gondor.apana.org.au; Garg Vakul-B16394; davem@davemloft.net; Porosanu Alexandru-B06830; Geanta Neag Horia Ioan-B05471; Phillips Kim-R1AAHA; dan.carpenter@oracle.com; linux-kernel@vger.kernel.org
Cc: Lal Nitesh-B44382; Gupta Ruchika-R66431
Subject: [PATCH] crypto: caam - Dynamic allocation of addresses for various memory blocks in CAAM.

CAAM's memory is broken into following address blocks:
Block           Included Registers
0               General Registers
1-4             Job ring registers
6               RTIC registers
7               QI registers
8               DECO and CCB

Size of the above stated blocks varies in various platforms. The block size can be 4K or 64K.
The block size can be dynamically determined by reading CTPR register in CAAM.
This patch initializes the block addresses dynamically based on the value read from this register.

Signed-off-by: Ruchika Gupta <r66431@freescale.com>
Signed-off-by: Nitesh Narayan Lal <b44382@freescale.com>
---
 drivers/crypto/caam/ctrl.c   | 114 ++++++++++++++++++++++++++-----------------
 drivers/crypto/caam/intern.h |   9 ++--
 drivers/crypto/caam/regs.h   |  38 +++------------
 3 files changed, 81 insertions(+), 80 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c index 3cade79..cd7af27 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -1,5 +1,4 @@
-/*
- * CAAM control-plane driver backend
+/* * CAAM control-plane driver backend
  * Controller-level driver, kernel property detection, initialization
  *
  * Copyright 2008-2012 Freescale Semiconductor, Inc.
@@ -81,38 +80,37 @@ static inline int run_descriptor_deco0(struct device *ctrldev, u32 *desc,
 					u32 *status)
 {
 	struct caam_drv_private *ctrlpriv = dev_get_drvdata(ctrldev);
-	struct caam_full __iomem *topregs;
+	struct caam_ctrl __iomem *ctrl = ctrlpriv->ctrl;
+	struct caam_deco __iomem *deco = ctrlpriv->deco;
 	unsigned int timeout = 100000;
 	u32 deco_dbg_reg, flags;
 	int i;
 
-	/* Set the bit to request direct access to DECO0 */
-	topregs = (struct caam_full __iomem *)ctrlpriv->ctrl;
 
 	if (ctrlpriv->virt_en == 1) {
-		setbits32(&topregs->ctrl.deco_rsr, DECORSR_JR0);
+		setbits32(&ctrl->deco_rsr, DECORSR_JR0);
 
-		while (!(rd_reg32(&topregs->ctrl.deco_rsr) & DECORSR_VALID) &&
+		while (!(rd_reg32(&ctrl->deco_rsr) & DECORSR_VALID) &&
 		       --timeout)
 			cpu_relax();
 
 		timeout = 100000;
 	}
 
-	setbits32(&topregs->ctrl.deco_rq, DECORR_RQD0ENABLE);
+	setbits32(&ctrl->deco_rq, DECORR_RQD0ENABLE);
 
-	while (!(rd_reg32(&topregs->ctrl.deco_rq) & DECORR_DEN0) &&
+	while (!(rd_reg32(&ctrl->deco_rq) & DECORR_DEN0) &&
 								 --timeout)
 		cpu_relax();
 
 	if (!timeout) {
 		dev_err(ctrldev, "failed to acquire DECO 0\n");
-		clrbits32(&topregs->ctrl.deco_rq, DECORR_RQD0ENABLE);
+		clrbits32(&ctrl->deco_rq, DECORR_RQD0ENABLE);
 		return -ENODEV;
 	}
 
 	for (i = 0; i < desc_len(desc); i++)
-		wr_reg32(&topregs->deco.descbuf[i], *(desc + i));
+		wr_reg32(&deco->descbuf[i], *(desc + i));
 
 	flags = DECO_JQCR_WHL;
 	/*
@@ -123,11 +121,11 @@ static inline int run_descriptor_deco0(struct device *ctrldev, u32 *desc,
 		flags |= DECO_JQCR_FOUR;
 
 	/* Instruct the DECO to execute it */
-	wr_reg32(&topregs->deco.jr_ctl_hi, flags);
+	wr_reg32(&deco->jr_ctl_hi, flags);
 
 	timeout = 10000000;
 	do {
-		deco_dbg_reg = rd_reg32(&topregs->deco.desc_dbg);
+		deco_dbg_reg = rd_reg32(&deco->desc_dbg);
 		/*
 		 * If an error occured in the descriptor, then
 		 * the DECO status field will be set to 0x0D @@ -138,14 +136,14 @@ static inline int run_descriptor_deco0(struct device *ctrldev, u32 *desc,
 		cpu_relax();
 	} while ((deco_dbg_reg & DESC_DBG_DECO_STAT_VALID) && --timeout);
 
-	*status = rd_reg32(&topregs->deco.op_status_hi) &
+	*status = rd_reg32(&deco->op_status_hi) &
 		  DECO_OP_STATUS_HI_ERR_MASK;
 
 	if (ctrlpriv->virt_en == 1)
-		clrbits32(&topregs->ctrl.deco_rsr, DECORSR_JR0);
+		clrbits32(&ctrl->deco_rsr, DECORSR_JR0);
 
 	/* Mark the DECO as free */
-	clrbits32(&topregs->ctrl.deco_rq, DECORR_RQD0ENABLE);
+	clrbits32(&ctrl->deco_rq, DECORR_RQD0ENABLE);
 
 	if (!timeout)
 		return -EAGAIN;
@@ -176,13 +174,13 @@ static int instantiate_rng(struct device *ctrldev, int state_handle_mask,
 			   int gen_sk)
 {
 	struct caam_drv_private *ctrlpriv = dev_get_drvdata(ctrldev);
-	struct caam_full __iomem *topregs;
+	struct caam_ctrl __iomem *ctrl;
 	struct rng4tst __iomem *r4tst;
 	u32 *desc, status, rdsta_val;
 	int ret = 0, sh_idx;
 
-	topregs = (struct caam_full __iomem *)ctrlpriv->ctrl;
-	r4tst = &topregs->ctrl.r4tst[0];
+	ctrl = (struct caam_ctrl __iomem *)ctrlpriv->ctrl;
+	r4tst = &ctrl->r4tst[0];
 
 	desc = kmalloc(CAAM_CMD_SZ * 7, GFP_KERNEL);
 	if (!desc)
@@ -212,12 +210,11 @@ static int instantiate_rng(struct device *ctrldev, int state_handle_mask,
 		 * CAAM eras), then try again.
 		 */
 		rdsta_val =
-			rd_reg32(&topregs->ctrl.r4tst[0].rdsta) & RDSTA_IFMASK;
+			rd_reg32(&ctrl->r4tst[0].rdsta) & RDSTA_IFMASK;
 		if (status || !(rdsta_val & (1 << sh_idx)))
 			ret = -EAGAIN;
 		if (ret)
 			break;
-
 		dev_info(ctrldev, "Instantiated RNG4 SH%d\n", sh_idx);
 		/* Clear the contents before recreating the descriptor */
 		memset(desc, 0x00, CAAM_CMD_SZ * 7);
@@ -285,12 +282,12 @@ static int caam_remove(struct platform_device *pdev)  {
 	struct device *ctrldev;
 	struct caam_drv_private *ctrlpriv;
-	struct caam_full __iomem *topregs;
+	struct caam_ctrl __iomem *ctrl;
 	int ring, ret = 0;
 
 	ctrldev = &pdev->dev;
 	ctrlpriv = dev_get_drvdata(ctrldev);
-	topregs = (struct caam_full __iomem *)ctrlpriv->ctrl;
+	ctrl = (struct caam_ctrl __iomem *)ctrlpriv->ctrl;
 
 	/* Remove platform devices for JobRs */
 	for (ring = 0; ring < ctrlpriv->total_jobrs; ring++) { @@ -308,7 +305,7 @@ static int caam_remove(struct platform_device *pdev)  #endif
 
 	/* Unmap controller region */
-	iounmap(&topregs->ctrl);
+	iounmap(&ctrl);
 
 	return ret;
 }
@@ -323,12 +320,12 @@ static void kick_trng(struct platform_device *pdev, int ent_delay)  {
 	struct device *ctrldev = &pdev->dev;
 	struct caam_drv_private *ctrlpriv = dev_get_drvdata(ctrldev);
-	struct caam_full __iomem *topregs;
+	struct caam_ctrl __iomem *ctrl;
 	struct rng4tst __iomem *r4tst;
 	u32 val;
 
-	topregs = (struct caam_full __iomem *)ctrlpriv->ctrl;
-	r4tst = &topregs->ctrl.r4tst[0];
+	ctrl = (struct caam_ctrl __iomem *)ctrlpriv->ctrl;
+	r4tst = &ctrl->r4tst[0];
 
 	/* put RNG4 into program mode */
 	setbits32(&r4tst->rtmctl, RTMCTL_PRGM); @@ -387,13 +384,14 @@ static int caam_probe(struct platform_device *pdev)
 	struct device *dev;
 	struct device_node *nprop, *np;
 	struct caam_ctrl __iomem *ctrl;
-	struct caam_full __iomem *topregs;
 	struct caam_drv_private *ctrlpriv;
 #ifdef CONFIG_DEBUG_FS
 	struct caam_perfmon *perfmon;
 #endif
 	u32 scfgr, comp_params;
 	u32 cha_vid_ls;
+	int pg_size;
+	int BLOCK_OFFSET = 0;
 
 	ctrlpriv = devm_kzalloc(&pdev->dev, sizeof(struct caam_drv_private),
 				GFP_KERNEL);
@@ -412,10 +410,27 @@ static int caam_probe(struct platform_device *pdev)
 		dev_err(dev, "caam: of_iomap() failed\n");
 		return -ENOMEM;
 	}
-	ctrlpriv->ctrl = (struct caam_ctrl __force *)ctrl;
+	/* Finding the page size for using the CTPR_MS register */
+	comp_params = rd_reg32(&ctrl->perfmon.comp_parms_ms);
+	pg_size = (comp_params & CTPR_MS_PG_SZ_MASK) >> CTPR_MS_PG_SZ_SHIFT;
 
-	/* topregs used to derive pointers to CAAM sub-blocks only */
-	topregs = (struct caam_full __iomem *)ctrl;
+	/* Allocating the BLOCK_OFFSET based on the supported page size on
+	 * the platform
+	 */
+	if (pg_size == 0)
+		BLOCK_OFFSET = PG_SIZE_4K;
+	else
+		BLOCK_OFFSET = PG_SIZE_64K;
+
+	ctrlpriv->ctrl = (struct caam_ctrl __force *)ctrl;
+	ctrlpriv->assure = (struct caam_assurance __force *)
+			   ((uint8_t *)ctrl +
+			    BLOCK_OFFSET * ASSURE_BLOCK_NUMBER
+			   );
+	ctrlpriv->deco = (struct caam_deco __force *)
+			 ((uint8_t *)ctrl +
+			 BLOCK_OFFSET * DECO_BLOCK_NUMBER
+			 );
 
 	/* Get the IRQ of the controller (for security violations only) */
 	ctrlpriv->secvio_irq = irq_of_parse_and_map(nprop, 0); @@ -424,15 +439,14 @@ static int caam_probe(struct platform_device *pdev)
 	 * Enable DECO watchdogs and, if this is a PHYS_ADDR_T_64BIT kernel,
 	 * long pointers in master configuration register
 	 */
-	setbits32(&topregs->ctrl.mcr, MCFGR_WDENABLE |
+	setbits32(&ctrl->mcr, MCFGR_WDENABLE |
 		  (sizeof(dma_addr_t) == sizeof(u64) ? MCFGR_LONG_PTR : 0));
 
 	/*
 	 *  Read the Compile Time paramters and SCFGR to determine
 	 * if Virtualization is enabled for this platform
 	 */
-	comp_params = rd_reg32(&topregs->ctrl.perfmon.comp_parms_ms);
-	scfgr = rd_reg32(&topregs->ctrl.scfgr);
+	scfgr = rd_reg32(&ctrl->scfgr);
 
 	ctrlpriv->virt_en = 0;
 	if (comp_params & CTPR_MS_VIRT_EN_INCL) { @@ -450,7 +464,7 @@ static int caam_probe(struct platform_device *pdev)
 	}
 
 	if (ctrlpriv->virt_en == 1)
-		setbits32(&topregs->ctrl.jrstart, JRSTART_JR0_START |
+		setbits32(&ctrl->jrstart, JRSTART_JR0_START |
 			  JRSTART_JR1_START | JRSTART_JR2_START |
 			  JRSTART_JR3_START);
 
@@ -477,7 +491,7 @@ static int caam_probe(struct platform_device *pdev)
 					sizeof(struct platform_device *) * rspec,
 					GFP_KERNEL);
 	if (ctrlpriv->jrpdev == NULL) {
-		iounmap(&topregs->ctrl);
+		iounmap(&ctrl);
 		return -ENOMEM;
 	}
 
@@ -493,18 +507,26 @@ static int caam_probe(struct platform_device *pdev)
 					ring);
 				continue;
 			}
+			ctrlpriv->jr[ring] = (struct caam_job_ring __force *)
+					     ((uint8_t *)ctrl +
+					     (ring + JR_BLOCK_NUMBER) *
+					      BLOCK_OFFSET
+					     );
 			ctrlpriv->total_jobrs++;
 			ring++;
-		}
+	}
 
 	/* Check to see if QI present. If so, enable */
 	ctrlpriv->qi_present =
-			!!(rd_reg32(&topregs->ctrl.perfmon.comp_parms_ms) &
+			!!(rd_reg32(&ctrl->perfmon.comp_parms_ms) &
 			   CTPR_MS_QI_MASK);
 	if (ctrlpriv->qi_present) {
-		ctrlpriv->qi = (struct caam_queue_if __force *)&topregs->qi;
+		ctrlpriv->qi = (struct caam_queue_if __force *)
+			       ((uint8_t *)ctrl +
+				 BLOCK_OFFSET * QI_BLOCK_NUMBER
+			       );
 		/* This is all that's required to physically enable QI */
-		wr_reg32(&topregs->qi.qi_control_lo, QICTL_DQEN);
+		wr_reg32(&ctrlpriv->qi->qi_control_lo, QICTL_DQEN);
 	}
 
 	/* If no QI and no rings specified, quit and go home */ @@ -514,7 +536,7 @@ static int caam_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	cha_vid_ls = rd_reg32(&topregs->ctrl.perfmon.cha_id_ls);
+	cha_vid_ls = rd_reg32(&ctrl->perfmon.cha_id_ls);
 
 	/*
 	 * If SEC has RNG version >= 4 and RNG state handle has not been @@ -522,7 +544,7 @@ static int caam_probe(struct platform_device *pdev)
 	 */
 	if ((cha_vid_ls & CHA_ID_LS_RNG_MASK) >> CHA_ID_LS_RNG_SHIFT >= 4) {
 		ctrlpriv->rng4_sh_init =
-			rd_reg32(&topregs->ctrl.r4tst[0].rdsta);
+			rd_reg32(&ctrl->r4tst[0].rdsta);
 		/*
 		 * If the secure keys (TDKEK, JDKEK, TDSK), were already
 		 * generated, signal this to the function that is instantiating @@ -533,7 +555,7 @@ static int caam_probe(struct platform_device *pdev)
 		ctrlpriv->rng4_sh_init &= RDSTA_IFMASK;
 		do {
 			int inst_handles =
-				rd_reg32(&topregs->ctrl.r4tst[0].rdsta) &
+				rd_reg32(&ctrl->r4tst[0].rdsta) &
 								RDSTA_IFMASK;
 			/*
 			 * If either SH were instantiated by somebody else @@ -569,13 +591,13 @@ static int caam_probe(struct platform_device *pdev)
 		ctrlpriv->rng4_sh_init = ~ctrlpriv->rng4_sh_init & RDSTA_IFMASK;
 
 		/* Enable RDB bit so that RNG works faster */
-		setbits32(&topregs->ctrl.scfgr, SCFGR_RDBENABLE);
+		setbits32(&ctrl->scfgr, SCFGR_RDBENABLE);
 	}
 
 	/* NOTE: RTIC detection ought to go here, around Si time */
 
-	caam_id = (u64)rd_reg32(&topregs->ctrl.perfmon.caam_id_ms) << 32 |
-		  (u64)rd_reg32(&topregs->ctrl.perfmon.caam_id_ls);
+	caam_id = (u64)rd_reg32(&ctrl->perfmon.caam_id_ms) << 32 |
+		  (u64)rd_reg32(&ctrl->perfmon.caam_id_ls);
 
 	/* Report "alive" for developer to see */
 	dev_info(dev, "device ID = 0x%016llx (Era %d)\n", caam_id, diff --git a/drivers/crypto/caam/intern.h b/drivers/crypto/caam/intern.h index 97363db..89b94cc 100644
--- a/drivers/crypto/caam/intern.h
+++ b/drivers/crypto/caam/intern.h
@@ -70,10 +70,11 @@ struct caam_drv_private {
 	struct platform_device *pdev;
 
 	/* Physical-presence section */
-	struct caam_ctrl *ctrl; /* controller region */
-	struct caam_deco **deco; /* DECO/CCB views */
-	struct caam_assurance *ac;
-	struct caam_queue_if *qi; /* QI control region */
+	struct caam_ctrl __iomem *ctrl; /* controller region */
+	struct caam_deco __iomem *deco; /* DECO/CCB views */
+	struct caam_assurance __iomem *assure;
+	struct caam_queue_if __iomem *qi; /* QI control region */
+	struct caam_job_ring __iomem *jr[4];	/* JobR's register space */
 
 	/*
 	 * Detected geometry block. Filled in from device tree if powerpc, diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h index f48e344..d742131 100644
--- a/drivers/crypto/caam/regs.h
+++ b/drivers/crypto/caam/regs.h
@@ -194,6 +194,8 @@ struct caam_perfmon {
 #define CTPR_MS_QI_MASK		(0x1ull << CTPR_MS_QI_SHIFT)
 #define CTPR_MS_VIRT_EN_INCL	0x00000001
 #define CTPR_MS_VIRT_EN_POR	0x00000002
+#define CTPR_MS_PG_SZ_MASK	0x10
+#define CTPR_MS_PG_SZ_SHIFT	4
 	u32 comp_parms_ms;	/* CTPR - Compile Parameters Register	*/
 	u32 comp_parms_ls;	/* CTPR - Compile Parameters Register	*/
 	u64 rsvd1[2];
@@ -758,34 +760,10 @@ struct caam_deco {
 #define DECO_JQCR_WHL		0x20000000
 #define DECO_JQCR_FOUR		0x10000000
 
-/*
- * Current top-level view of memory map is:
- *
- * 0x0000 - 0x0fff - CAAM Top-Level Control
- * 0x1000 - 0x1fff - Job Ring 0
- * 0x2000 - 0x2fff - Job Ring 1
- * 0x3000 - 0x3fff - Job Ring 2
- * 0x4000 - 0x4fff - Job Ring 3
- * 0x5000 - 0x5fff - (unused)
- * 0x6000 - 0x6fff - Assurance Controller
- * 0x7000 - 0x7fff - Queue Interface
- * 0x8000 - 0x8fff - DECO-CCB 0
- * 0x9000 - 0x9fff - DECO-CCB 1
- * 0xa000 - 0xafff - DECO-CCB 2
- * 0xb000 - 0xbfff - DECO-CCB 3
- * 0xc000 - 0xcfff - DECO-CCB 4
- *
- * caam_full describes the full register view of CAAM if useful,
- * although many configurations may choose to implement parts of
- * the register map separately, in differing privilege regions
- */
-struct caam_full {
-	struct caam_ctrl __iomem ctrl;
-	struct caam_job_ring jr[4];
-	u64 rsvd[512];
-	struct caam_assurance assure;
-	struct caam_queue_if qi;
-	struct caam_deco deco;
-};
-
+#define JR_BLOCK_NUMBER		1
+#define ASSURE_BLOCK_NUMBER	6
+#define QI_BLOCK_NUMBER		7
+#define DECO_BLOCK_NUMBER	8
+#define PG_SIZE_4K		0x1000
+#define PG_SIZE_64K		0x10000
 #endif /* REGS_H */
--
1.8.3.2
