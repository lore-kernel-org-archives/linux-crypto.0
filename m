From: Lee Nipper <lee.nipper@freescale.com>
Subject: [PATCH 2/3] crypto: talitos - done interrupt mitigation
Date: Mon, 06 Oct 2008 15:09:05 -0500
Message-ID: <1223323745.24986.13.camel@al08linux99>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-crypto <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from de01egw02.freescale.net ([192.88.165.103]:63002 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453AbYJFT6x (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 6 Oct 2008 15:58:53 -0400
Received: from de01smr01.freescale.net (de01smr01.freescale.net [10.208.0.31])
	by de01egw02.freescale.net (8.12.11/de01egw02) with ESMTP id m96JwnoB017976
	for <linux-crypto@vger.kernel.org>; Mon, 6 Oct 2008 12:58:50 -0700 (MST)
Received: from az33exm25.fsl.freescale.net (az33exm25.am.freescale.net [10.64.32.16])
	by de01smr01.freescale.net (8.13.1/8.13.0) with ESMTP id m96JwnuE029611
	for <linux-crypto@vger.kernel.org>; Mon, 6 Oct 2008 14:58:49 -0500 (CDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In talitos_interrupt, upon one done interrupt, mask further done interrupts,
and ack only any error interrupt.
In talitos_done, unmask done interrupts after completing processing.
In flush_channel, ack each done channel processed.
Keep done overflow interrupts masked because even though each pkt
is ack'ed, a few done overflows still occur.

Signed-off-by: Lee Nipper <lee.nipper@freescale.com>
Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/talitos.c |   30 ++++++++++++++++++++++--------
 drivers/crypto/talitos.h |    3 ++-
 2 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index b6705a3..6ced894 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -319,9 +319,11 @@ static void flush_channel(struct device *dev, int ch, int error, int reset_ch)
 
 		/* descriptors with their done bits set don't get the error */
 		rmb();
-		if ((request->desc->hdr & DESC_HDR_DONE) == DESC_HDR_DONE)
+		if ((request->desc->hdr & DESC_HDR_DONE) == DESC_HDR_DONE) {
 			status = 0;
-		else
+			/* Ack each pkt completed on channel */
+			out_be32(priv->reg + TALITOS_ICR, (1 << (ch * 2)));
+		} else
 			if (!error)
 				break;
 			else
@@ -369,6 +371,11 @@ static void talitos_done(unsigned long data)
 
 	for (ch = 0; ch < priv->num_channels; ch++)
 		flush_channel(dev, ch, 0, 0);
+
+	/* At this point, all completed channels have been processed.
+	 * Unmask done interrupts for channels completed later on.
+	 */
+	setbits32(priv->reg + TALITOS_IMR, TALITOS_IMR_DONE);
 }
 
 /*
@@ -557,15 +564,22 @@ static irqreturn_t talitos_interrupt(int irq, void *data)
 	isr = in_be32(priv->reg + TALITOS_ISR);
 	isr_lo = in_be32(priv->reg + TALITOS_ISR_LO);
 
-	/* ack */
-	out_be32(priv->reg + TALITOS_ICR, isr);
-	out_be32(priv->reg + TALITOS_ICR_LO, isr_lo);
+	if (unlikely((isr & ~TALITOS_ISR_CHDONE) || isr_lo)) {
+		/*
+		 * Acknowledge error interrupts here.
+		 * Done interrupts are ack'ed as part of done_task.
+		 */
+		out_be32(priv->reg + TALITOS_ICR, isr);
+		out_be32(priv->reg + TALITOS_ICR_LO, isr_lo);
 
-	if (unlikely((isr & ~TALITOS_ISR_CHDONE) || isr_lo))
 		talitos_error((unsigned long)data, isr, isr_lo);
-	else
-		if (likely(isr & TALITOS_ISR_CHDONE))
+	} else
+		if (likely(isr & TALITOS_ISR_CHDONE)) {
+			/* mask further done interrupts. */
+			clrbits32(priv->reg + TALITOS_IMR, TALITOS_IMR_DONE);
+			/* done_task will unmask done interrupts at exit */
 			tasklet_schedule(&priv->done_task);
+		}
 
 	return (isr || isr_lo) ? IRQ_HANDLED : IRQ_NONE;
 }
diff --git a/drivers/crypto/talitos.h b/drivers/crypto/talitos.h
index c48a405..e6b8777 100644
--- a/drivers/crypto/talitos.h
+++ b/drivers/crypto/talitos.h
@@ -37,7 +37,8 @@
 #define TALITOS_MCR_LO			0x1038
 #define   TALITOS_MCR_SWR		0x1     /* s/w reset */
 #define TALITOS_IMR			0x1008  /* interrupt mask register */
-#define   TALITOS_IMR_INIT		0x10fff /* enable channel IRQs */
+#define   TALITOS_IMR_INIT		0x100ff /* enable channel IRQs */
+#define   TALITOS_IMR_DONE		0x00055 /* done IRQs */
 #define TALITOS_IMR_LO			0x100C
 #define   TALITOS_IMR_LO_INIT		0x20000 /* allow RNGU error IRQs */
 #define TALITOS_ISR			0x1010  /* interrupt status register */
-- 
1.5.6.2


