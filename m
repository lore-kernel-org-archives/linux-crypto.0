From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH 2/7] crypto: talitos - remove NO_IRQ references
Date: Mon, 12 Dec 2011 14:59:11 -0600
Message-ID: <1323723556-7100-3-git-send-email-kim.phillips@freescale.com>
References: <1323723556-7100-1-git-send-email-kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:16842 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002Ab1LLVAk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 12 Dec 2011 16:00:40 -0500
In-Reply-To: <1323723556-7100-1-git-send-email-kim.phillips@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

As prescribed by Linus:

https://lkml.org/lkml/2011/12/2/290

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/talitos.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index d376cc7..503d0d8 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -234,7 +234,7 @@ static int reset_device(struct device *dev)
 	       && --timeout)
 		cpu_relax();
 
-	if (priv->irq[1] != NO_IRQ) {
+	if (priv->irq[1]) {
 		mcr = TALITOS_MCR_RCA1 | TALITOS_MCR_RCA3;
 		setbits32(priv->reg + TALITOS_MCR, mcr);
 	}
@@ -2581,13 +2581,13 @@ static int talitos_remove(struct platform_device *ofdev)
 	kfree(priv->chan);
 
 	for (i = 0; i < 2; i++)
-		if (priv->irq[i] != NO_IRQ) {
+		if (priv->irq[i]) {
 			free_irq(priv->irq[i], dev);
 			irq_dispose_mapping(priv->irq[i]);
 		}
 
 	tasklet_kill(&priv->done_task[0]);
-	if (priv->irq[1] != NO_IRQ)
+	if (priv->irq[1])
 		tasklet_kill(&priv->done_task[1]);
 
 	iounmap(priv->reg);
@@ -2663,7 +2663,7 @@ static int talitos_probe_irq(struct platform_device *ofdev)
 	int err;
 
 	priv->irq[0] = irq_of_parse_and_map(np, 0);
-	if (priv->irq[0] == NO_IRQ) {
+	if (!priv->irq[0]) {
 		dev_err(dev, "failed to map irq\n");
 		return -EINVAL;
 	}
@@ -2671,7 +2671,7 @@ static int talitos_probe_irq(struct platform_device *ofdev)
 	priv->irq[1] = irq_of_parse_and_map(np, 1);
 
 	/* get the primary irq line */
-	if (priv->irq[1] == NO_IRQ) {
+	if (!priv->irq[1]) {
 		err = request_irq(priv->irq[0], talitos_interrupt_4ch, 0,
 				  dev_driver_string(dev), dev);
 		goto primary_out;
@@ -2688,7 +2688,7 @@ static int talitos_probe_irq(struct platform_device *ofdev)
 	if (err) {
 		dev_err(dev, "failed to request secondary irq\n");
 		irq_dispose_mapping(priv->irq[1]);
-		priv->irq[1] = NO_IRQ;
+		priv->irq[1] = 0;
 	}
 
 	return err;
@@ -2697,7 +2697,7 @@ primary_out:
 	if (err) {
 		dev_err(dev, "failed to request primary irq\n");
 		irq_dispose_mapping(priv->irq[0]);
-		priv->irq[0] = NO_IRQ;
+		priv->irq[0] = 0;
 	}
 
 	return err;
@@ -2723,7 +2723,7 @@ static int talitos_probe(struct platform_device *ofdev)
 	if (err)
 		goto err_out;
 
-	if (priv->irq[1] == NO_IRQ) {
+	if (!priv->irq[1]) {
 		tasklet_init(&priv->done_task[0], talitos_done_4ch,
 			     (unsigned long)dev);
 	} else {
@@ -2784,7 +2784,7 @@ static int talitos_probe(struct platform_device *ofdev)
 
 	for (i = 0; i < priv->num_channels; i++) {
 		priv->chan[i].reg = priv->reg + TALITOS_CH_STRIDE * (i + 1);
-		if ((priv->irq[1] == NO_IRQ) || !(i & 1))
+		if (!priv->irq[1] || !(i & 1))
 			priv->chan[i].reg += TALITOS_CH_BASE_OFFSET;
 	}
 
-- 
1.7.8
