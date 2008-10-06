From: Lee Nipper <lee.nipper@freescale.com>
Subject: [PATCH 1/3] crypto: talitos - pass correct interrupt status to
	error handler
Date: Mon, 06 Oct 2008 15:09:00 -0500
Message-ID: <1223323740.24986.12.camel@al08linux99>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-crypto <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from az33egw01.freescale.net ([192.88.158.102]:56153 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565AbYJFT6r (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 6 Oct 2008 15:58:47 -0400
Received: from az33smr01.freescale.net (az33smr01.freescale.net [10.64.34.199])
	by az33egw01.freescale.net (8.12.11/az33egw01) with ESMTP id m96JwiMr013919
	for <linux-crypto@vger.kernel.org>; Mon, 6 Oct 2008 12:58:45 -0700 (MST)
Received: from az33exm25.fsl.freescale.net (az33exm25.am.freescale.net [10.64.32.16])
	by az33smr01.freescale.net (8.13.1/8.13.0) with ESMTP id m96JwiSf017030
	for <linux-crypto@vger.kernel.org>; Mon, 6 Oct 2008 14:58:44 -0500 (CDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Kim Phillips <kim.phillips@freescale.com>

since we ack early, the re-read interrupt status in talitos_error
may be already updated with a new value.  Pass the error ISR value
directly in order to report and handle the error based on the correct
error status.

Also remove unused error tasklet.

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
Signed-off-by: Lee Nipper <lee.nipper@freescale.com>
---
In this series, patches 1 and 3 authored by Kim, patch 2 by Lee.

 drivers/crypto/talitos.c |   12 +++---------
 1 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 4c47fe5..b6705a3 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -127,7 +127,6 @@ struct talitos_private {
 
 	/* request callback tasklet */
 	struct tasklet_struct done_task;
-	struct tasklet_struct error_task;
 
 	/* list of registered algorithms */
 	struct list_head alg_list;
@@ -469,16 +468,13 @@ static void report_eu_error(struct device *dev, int ch, struct talitos_desc *des
 /*
  * recover from error interrupts
  */
-static void talitos_error(unsigned long data)
+static void talitos_error(unsigned long data, u32 isr, u32 isr_lo)
 {
 	struct device *dev = (struct device *)data;
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	unsigned int timeout = TALITOS_TIMEOUT;
 	int ch, error, reset_dev = 0, reset_ch = 0;
-	u32 isr, isr_lo, v, v_lo;
-
-	isr = in_be32(priv->reg + TALITOS_ISR);
-	isr_lo = in_be32(priv->reg + TALITOS_ISR_LO);
+	u32 v, v_lo;
 
 	for (ch = 0; ch < priv->num_channels; ch++) {
 		/* skip channels without errors */
@@ -566,7 +562,7 @@ static irqreturn_t talitos_interrupt(int irq, void *data)
 	out_be32(priv->reg + TALITOS_ICR_LO, isr_lo);
 
 	if (unlikely((isr & ~TALITOS_ISR_CHDONE) || isr_lo))
-		talitos_error((unsigned long)data);
+		talitos_error((unsigned long)data, isr, isr_lo);
 	else
 		if (likely(isr & TALITOS_ISR_CHDONE))
 			tasklet_schedule(&priv->done_task);
@@ -1391,7 +1387,6 @@ static int __devexit talitos_remove(struct of_device *ofdev)
 	}
 
 	tasklet_kill(&priv->done_task);
-	tasklet_kill(&priv->error_task);
 
 	iounmap(priv->reg);
 
@@ -1452,7 +1447,6 @@ static int talitos_probe(struct of_device *ofdev,
 	priv->ofdev = ofdev;
 
 	tasklet_init(&priv->done_task, talitos_done, (unsigned long)dev);
-	tasklet_init(&priv->error_task, talitos_error, (unsigned long)dev);
 
 	priv->irq = irq_of_parse_and_map(np, 0);
 
-- 
1.5.6.2


