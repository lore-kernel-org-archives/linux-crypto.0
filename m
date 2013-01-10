From: Vakul Garg <vakul@freescale.com>
Subject: [PATCH] crypto: caam - fix job ring cleanup code
Date: Thu, 10 Jan 2013 16:36:11 +0530
Message-ID: <1357815971-31462-1-git-send-email-vakul@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:48687 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753282Ab3AJLId (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 Jan 2013 06:08:33 -0500
Received: from mail104-tx2 (localhost [127.0.0.1])	by
 mail104-tx2-R.bigfish.com (Postfix) with ESMTP id 2FD9726013D	for
 <linux-crypto@vger.kernel.org>; Thu, 10 Jan 2013 11:08:33 +0000 (UTC)
Received: from TX2EHSMHS029.bigfish.com (unknown [10.9.14.235])	by
 mail104-tx2.bigfish.com (Postfix) with ESMTP id 4CAC6120066	for
 <linux-crypto@vger.kernel.org>; Thu, 10 Jan 2013 11:08:30 +0000 (UTC)
Received: from b16394-desktop.ap.freescale.net
 (b16394-desktop.ap.freescale.net [10.232.132.33])	by az84smr01.freescale.net
 (8.14.3/8.14.0) with ESMTP id r0AB8RX0015329	for
 <linux-crypto@vger.kernel.org>; Thu, 10 Jan 2013 04:08:28 -0700
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The job ring init function creates a platform device for each job ring.
While the job ring is shutdown, e.g. while module removal, its platform
device was not being removed. This lead to failure while reinserting
caam module again. Same problem appears while platform device for caam
is bound, unbound and then bound again to caam platform driver.

Signed-off-by: Vakul Garg <vakul@freescale.com>
Signed-off-by: Bharat Bhushan <bharat.bhushan@freescale.com>
---
 drivers/crypto/caam/intern.h |    1 +
 drivers/crypto/caam/jr.c     |    4 ++++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/crypto/caam/intern.h b/drivers/crypto/caam/intern.h
index 5cd4c1b..e4a16b7 100644
--- a/drivers/crypto/caam/intern.h
+++ b/drivers/crypto/caam/intern.h
@@ -41,6 +41,7 @@ struct caam_jrentry_info {
 /* Private sub-storage for a single JobR */
 struct caam_drv_private_jr {
 	struct device *parentdev;	/* points back to controller dev */
+	struct platform_device *jr_pdev;/* points to platform device for JR */
 	int ridx;
 	struct caam_job_ring __iomem *rregs;	/* JobR's register space */
 	struct tasklet_struct irqtask;
diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index 93d1407..b4aa773e 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -407,6 +407,7 @@ int caam_jr_shutdown(struct device *dev)
 	dma_free_coherent(dev, sizeof(struct jr_outentry) * JOBR_DEPTH,
 			  jrp->outring, outbusaddr);
 	kfree(jrp->entinfo);
+	of_device_unregister(jrp->jr_pdev);
 
 	return ret;
 }
@@ -454,6 +455,8 @@ int caam_jr_probe(struct platform_device *pdev, struct device_node *np,
 		kfree(jrpriv);
 		return -EINVAL;
 	}
+
+	jrpriv->jr_pdev = jr_pdev;
 	jrdev = &jr_pdev->dev;
 	dev_set_drvdata(jrdev, jrpriv);
 	ctrlpriv->jrdev[ring] = jrdev;
@@ -472,6 +475,7 @@ int caam_jr_probe(struct platform_device *pdev, struct device_node *np,
 	/* Now do the platform independent part */
 	error = caam_jr_init(jrdev); /* now turn on hardware */
 	if (error) {
+		of_device_unregister(jr_pdev);
 		kfree(jrpriv);
 		return error;
 	}
-- 
1.7.7
