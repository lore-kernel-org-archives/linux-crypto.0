From: Cristian Stoica <cristian.stoica@freescale.com>
Subject: [PATCH 2/2] crypto: caam: fix resource clean-up on error path for caam_jr_init
Date: Thu, 22 Jan 2015 16:00:49 +0200
Message-ID: <1421935249-27549-2-git-send-email-cristian.stoica@freescale.com>
References: <1421935249-27549-1-git-send-email-cristian.stoica@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <kim.phillips@freescale.com>, <horia.geanta@freescale.com>,
	"Cristian Stoica" <cristian.stoica@freescale.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2on0117.outbound.protection.outlook.com ([65.55.169.117]:22064
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751704AbbAVOBJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 22 Jan 2015 09:01:09 -0500
In-Reply-To: <1421935249-27549-1-git-send-email-cristian.stoica@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>
---
 drivers/crypto/caam/jr.c | 31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index bce2959..b8b5d47 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -384,28 +384,28 @@ static int caam_jr_init(struct device *dev)
 	if (error) {
 		dev_err(dev, "can't connect JobR %d interrupt (%d)\n",
 			jrp->ridx, jrp->irq);
-		return -EINVAL;
+		goto out_kill_deq;
 	}
 
 	error = caam_reset_hw_jr(dev);
 	if (error)
-		return error;
+		goto out_free_irq;
 
+	error = -ENOMEM;
 	jrp->inpring = dma_alloc_coherent(dev, sizeof(dma_addr_t) * JOBR_DEPTH,
 					  &inpbusaddr, GFP_KERNEL);
+	if (!jrp->inpring)
+		goto out_free_irq;
 
 	jrp->outring = dma_alloc_coherent(dev, sizeof(struct jr_outentry) *
 					  JOBR_DEPTH, &outbusaddr, GFP_KERNEL);
+	if (!jrp->outring)
+		goto out_free_inpring;
 
 	jrp->entinfo = kzalloc(sizeof(struct caam_jrentry_info) * JOBR_DEPTH,
 			       GFP_KERNEL);
-
-	if ((jrp->inpring == NULL) || (jrp->outring == NULL) ||
-	    (jrp->entinfo == NULL)) {
-		dev_err(dev, "can't allocate job rings for %d\n",
-			jrp->ridx);
-		return -ENOMEM;
-	}
+	if (!jrp->entinfo)
+		goto out_free_outring;
 
 	for (i = 0; i < JOBR_DEPTH; i++)
 		jrp->entinfo[i].desc_addr_dma = !0;
@@ -432,6 +432,19 @@ static int caam_jr_init(struct device *dev)
 		  (JOBR_INTC_TIME_THLD << JRCFG_ICTT_SHIFT));
 
 	return 0;
+
+out_free_outring:
+	dma_free_coherent(dev, sizeof(struct jr_outentry) * JOBR_DEPTH,
+			  jrp->outring, outbusaddr);
+out_free_inpring:
+	dma_free_coherent(dev, sizeof(dma_addr_t) * JOBR_DEPTH,
+			  jrp->inpring, inpbusaddr);
+	dev_err(dev, "can't allocate job rings for %d\n", jrp->ridx);
+out_free_irq:
+	free_irq(jrp->irq, dev);
+out_kill_deq:
+	tasklet_kill(&jrp->irqtask);
+	return error;
 }
 
 
-- 
2.2.0
