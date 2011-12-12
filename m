From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH 7/7] crypto: caam - remove DECO access initialization code
Date: Mon, 12 Dec 2011 14:59:16 -0600
Message-ID: <1323723556-7100-8-git-send-email-kim.phillips@freescale.com>
References: <1323723556-7100-1-git-send-email-kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:19008 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754014Ab1LLVAf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 12 Dec 2011 16:00:35 -0500
In-Reply-To: <1323723556-7100-1-git-send-email-kim.phillips@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Access to the SEC4 DECOs (DEscriptor COntrollers) (for debug purposes)
isn't supported or used, and its register access initialization code
erroneously makes illegal i/o accesses that show up as errors when
run under simulation.  Remove it until proper support (via DECORR)
is added.

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/caam/ctrl.c |   13 -------------
 drivers/crypto/caam/regs.h |    1 -
 2 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 048bb23..8ae3ba2 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -52,8 +52,6 @@ static int caam_probe(struct platform_device *pdev)
 	struct caam_ctrl __iomem *ctrl;
 	struct caam_full __iomem *topregs;
 	struct caam_drv_private *ctrlpriv;
-	struct caam_deco **deco;
-	u32 deconum;
 #ifdef CONFIG_DEBUG_FS
 	struct caam_perfmon *perfmon;
 #endif
@@ -92,17 +90,6 @@ static int caam_probe(struct platform_device *pdev)
 	if (sizeof(dma_addr_t) == sizeof(u64))
 		dma_set_mask(dev, DMA_BIT_MASK(36));
 
-	/* Find out how many DECOs are present */
-	deconum = (rd_reg64(&topregs->ctrl.perfmon.cha_num) &
-		   CHA_NUM_DECONUM_MASK) >> CHA_NUM_DECONUM_SHIFT;
-
-	ctrlpriv->deco = kmalloc(deconum * sizeof(struct caam_deco *),
-				 GFP_KERNEL);
-
-	deco = (struct caam_deco __force **)&topregs->deco;
-	for (d = 0; d < deconum; d++)
-		ctrlpriv->deco[d] = deco[d];
-
 	/*
 	 * Detect and enable JobRs
 	 * First, find out how many ring spec'ed, allocate references
diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h
index aee394e..e9f7a70 100644
--- a/drivers/crypto/caam/regs.h
+++ b/drivers/crypto/caam/regs.h
@@ -657,7 +657,6 @@ struct caam_full {
 	u64 rsvd[512];
 	struct caam_assurance assure;
 	struct caam_queue_if qi;
-	struct caam_deco *deco;
 };
 
 #endif /* REGS_H */
-- 
1.7.8
