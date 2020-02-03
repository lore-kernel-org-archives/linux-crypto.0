Return-Path: <SRS0=nOCY=3X=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B637C33CAC
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Feb 2020 10:27:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B2F852080D
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Feb 2020 10:27:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=tq-group.com header.i=@tq-group.com header.b="FQhXxTwE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727165AbgBCK1q (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 3 Feb 2020 05:27:46 -0500
Received: from mx1.tq-group.com ([62.157.118.193]:51690 "EHLO mx1.tq-group.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726100AbgBCK1p (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Feb 2020 05:27:45 -0500
X-Greylist: delayed 428 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Feb 2020 05:27:44 EST
IronPort-SDR: X1Gz/oUg2tDO+KeeBbID8o/+NyshHFoLcFqQjiUnk7LIik9RWLlCrmVbCuxrXzlqhUNlKcU8j8
 fOMDCDG9Baa5t/FsrZerhwXcnKhkMbldApDeC9NkW3ciEA28p8N2XSwbkhCgvhhAjaqVQVM6pe
 YAjnC9k5l5/Sqejrv647jV8/qivic2LjlZz2kS5D0H7BO/8j/jxb2G6bbyRnjgORpXQg3BJjgX
 YGMCP4Ds4PPwg/msfhNfy7msu81op68+57uzh22t/WXU7Dpx/hQ/maTVZvGYgdsgFWH/wygVm1
 gxc=
X-IronPort-AV: E=Sophos;i="5.70,397,1574118000"; 
   d="scan'208";a="10771158"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 03 Feb 2020 11:20:35 +0100
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Mon, 03 Feb 2020 11:20:35 +0100
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Mon, 03 Feb 2020 11:20:35 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1580725235; x=1612261235;
  h=from:to:cc:subject:date:message-id;
  bh=D1tHKRm9/T8SfmVVqmQjih0yc81AuYCA3oGPGsPn+YE=;
  b=FQhXxTwE6Pt62rPMDxweje/LiYgCfSxl/rwALdTyNU9QRx5Gd0Bk2RRD
   dZjpuU4DpKTjk1Rgd3Fib+kTGX3pcUKHHmCA7ZQSBsWG9KRauhzzd/Zjw
   E7ph7iltbyu6860wgckYLbAV//ZsTaZlwZN6GHil+YPFk0d0HfcSxwZ+z
   d5sgPhxwQjV3jSiAJEs2wGA5/Pxq9SnvP94udf0LKW9KEFLcl/5DWTR+A
   hkke88G6HidkmoAuOi6pwTCPLQcH+c3ashYBpCvYpbawaMPlfjhMqRiYt
   KUvEe4Y4U2Oin/QXY/o5pialF5z6kLNst9BzDbjOJGayCj9+LNu3R4sEJ
   w==;
IronPort-SDR: mim3VmcPh0LqA7R+lC6X8G4512MuGwfV4r/yUaOvfKLTPFOEOGzV7/ZblatpikgN6nwNl06Run
 qgvYCVUiF8ZjBm6dGi+F+rwgVQhensHMOQLG3LyAAEBdeddoEFeQk5CeLDvjL1znO3QXfgCAcs
 Gr+4nwxM6RdyqzB3jxAuzQiXWyEaaLfVDVkxsScoOMPtWSeR5vJkbMRFP3ATXFCH2x9ImX06sR
 fQyF4dZLtna4RrfQZ9Yhk6B5z4gXFKmYJjsfASK84Hp/mz2omlpcqmbB4MR1KKKTfyAUzogM+s
 si0=
X-IronPort-AV: E=Sophos;i="5.70,397,1574118000"; 
   d="scan'208";a="10771157"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 03 Feb 2020 11:20:35 +0100
Received: from schifferm-ubuntu4.tq-net.de (schifferm-ubuntu4.tq-net.de [10.117.49.26])
        by vtuxmail01.tq-net.de (Postfix) with ESMTPA id 5A659280065;
        Mon,  3 Feb 2020 11:20:37 +0100 (CET)
From:   Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
To:     horia.geanta@nxp.com, aymen.sghaier@nxp.com
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Subject: [RFC] crypto: caam: re-init JR on resume
Date:   Mon,  3 Feb 2020 11:18:50 +0100
Message-Id: <20200203101850.22570-1-matthias.schiffer@ew.tq-group.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The JR loses its configuration during suspend-to-RAM (at least on
i.MX6UL). Re-initialize the hardware on resume.

Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
---

I've come across the issue that the CAAM would not work anymore after
deep sleep on i.MX6UL. It turned out that the CAAM loses its state
during suspend-to-RAM, so all registers read as zero and need to be
reinitialized.

This patch is my first attempt at fixing the issue. It seems to work
well enough, but I assume I'm missing some synchronization to prevent
that some CAAM operation is currently under way when the suspend
happens? I don't know the PM and crypto subsystems well enough to judge
if this is possible, and if it is, how to prevent it.

I've only compile-tested this version of the patch, as I had to port it
from our board kernel, which is based on the heavily-modified NXP branch.


 drivers/crypto/caam/intern.h |  3 ++
 drivers/crypto/caam/jr.c     | 62 +++++++++++++++++++++++++-----------
 2 files changed, 46 insertions(+), 19 deletions(-)

diff --git a/drivers/crypto/caam/intern.h b/drivers/crypto/caam/intern.h
index c7c10c90464b..5d2e9091d5c2 100644
--- a/drivers/crypto/caam/intern.h
+++ b/drivers/crypto/caam/intern.h
@@ -47,6 +47,9 @@ struct caam_drv_private_jr {
 	struct tasklet_struct irqtask;
 	int irq;			/* One per queue */
 
+	dma_addr_t inpbusaddr;
+	dma_addr_t outbusaddr;
+
 	/* Number of scatterlist crypt transforms active on the JobR */
 	atomic_t tfm_count ____cacheline_aligned;
 
diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index fc97cde27059..2dabf5fd7818 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -418,13 +418,31 @@ int caam_jr_enqueue(struct device *dev, u32 *desc,
 }
 EXPORT_SYMBOL(caam_jr_enqueue);
 
+static void caam_jr_setup_rings(struct caam_drv_private_jr *jrp)
+{
+	jrp->out_ring_read_index = 0;
+	jrp->head = 0;
+	jrp->tail = 0;
+
+	wr_reg64(&jrp->rregs->inpring_base, jrp->inpbusaddr);
+	wr_reg64(&jrp->rregs->outring_base, jrp->outbusaddr);
+	wr_reg32(&jrp->rregs->inpring_size, JOBR_DEPTH);
+	wr_reg32(&jrp->rregs->outring_size, JOBR_DEPTH);
+
+	jrp->inpring_avail = JOBR_DEPTH;
+
+	/* Select interrupt coalescing parameters */
+	clrsetbits_32(&jrp->rregs->rconfig_lo, 0, JOBR_INTC |
+		      (JOBR_INTC_COUNT_THLD << JRCFG_ICDCT_SHIFT) |
+		      (JOBR_INTC_TIME_THLD << JRCFG_ICTT_SHIFT));
+}
+
 /*
  * Init JobR independent of platform property detection
  */
 static int caam_jr_init(struct device *dev)
 {
 	struct caam_drv_private_jr *jrp;
-	dma_addr_t inpbusaddr, outbusaddr;
 	int i, error;
 
 	jrp = dev_get_drvdata(dev);
@@ -434,13 +452,13 @@ static int caam_jr_init(struct device *dev)
 		return error;
 
 	jrp->inpring = dmam_alloc_coherent(dev, SIZEOF_JR_INPENTRY *
-					   JOBR_DEPTH, &inpbusaddr,
+					   JOBR_DEPTH, &jrp->inpbusaddr,
 					   GFP_KERNEL);
 	if (!jrp->inpring)
 		return -ENOMEM;
 
 	jrp->outring = dmam_alloc_coherent(dev, SIZEOF_JR_OUTENTRY *
-					   JOBR_DEPTH, &outbusaddr,
+					   JOBR_DEPTH, &jrp->outbusaddr,
 					   GFP_KERNEL);
 	if (!jrp->outring)
 		return -ENOMEM;
@@ -453,24 +471,9 @@ static int caam_jr_init(struct device *dev)
 	for (i = 0; i < JOBR_DEPTH; i++)
 		jrp->entinfo[i].desc_addr_dma = !0;
 
-	/* Setup rings */
-	jrp->out_ring_read_index = 0;
-	jrp->head = 0;
-	jrp->tail = 0;
-
-	wr_reg64(&jrp->rregs->inpring_base, inpbusaddr);
-	wr_reg64(&jrp->rregs->outring_base, outbusaddr);
-	wr_reg32(&jrp->rregs->inpring_size, JOBR_DEPTH);
-	wr_reg32(&jrp->rregs->outring_size, JOBR_DEPTH);
-
-	jrp->inpring_avail = JOBR_DEPTH;
-
 	spin_lock_init(&jrp->inplock);
 
-	/* Select interrupt coalescing parameters */
-	clrsetbits_32(&jrp->rregs->rconfig_lo, 0, JOBR_INTC |
-		      (JOBR_INTC_COUNT_THLD << JRCFG_ICDCT_SHIFT) |
-		      (JOBR_INTC_TIME_THLD << JRCFG_ICTT_SHIFT));
+	caam_jr_setup_rings(jrp);
 
 	tasklet_init(&jrp->irqtask, caam_jr_dequeue, (unsigned long)dev);
 
@@ -486,6 +489,20 @@ static int caam_jr_init(struct device *dev)
 	return error;
 }
 
+static int caam_jr_reinit(struct device *dev)
+{
+	struct caam_drv_private_jr *jrp = dev_get_drvdata(dev);
+	int error;
+
+	error = caam_reset_hw_jr(dev);
+	if (error)
+		return error;
+
+	caam_jr_setup_rings(jrp);
+
+	return 0;
+}
+
 static void caam_jr_irq_dispose_mapping(void *data)
 {
 	irq_dispose_mapping((unsigned long)data);
@@ -578,10 +595,17 @@ static const struct of_device_id caam_jr_match[] = {
 };
 MODULE_DEVICE_TABLE(of, caam_jr_match);
 
+#ifdef CONFIG_PM
+static SIMPLE_DEV_PM_OPS(caam_jr_pm_ops, caam_reset_hw_jr, caam_jr_reinit);
+#endif
+
 static struct platform_driver caam_jr_driver = {
 	.driver = {
 		.name = "caam_jr",
 		.of_match_table = caam_jr_match,
+#ifdef CONFIG_PM
+		.pm = &caam_jr_pm_ops,
+#endif
 	},
 	.probe       = caam_jr_probe,
 	.remove      = caam_jr_remove,
-- 
2.17.1

