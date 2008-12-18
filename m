From: Lee Nipper <lee.nipper@freescale.com>
Subject: [PATCH] crypto: talitos - ack done interrupt in isr instead of
	tasklet
Date: Thu, 18 Dec 2008 12:35:05 -0600
Message-ID: <1229625305.26363.190.camel@al08linux99>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Kim Phillips <kim.phillips@freescale.com>
To: linux-crypto <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from az33egw02.freescale.net ([192.88.158.103]:47095 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbYLRSet (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 18 Dec 2008 13:34:49 -0500
Received: from de01smr02.am.mot.com (de01smr02.freescale.net [10.208.0.151])
	by az33egw02.freescale.net (8.14.3/az33egw02) with ESMTP id mBIIYlxZ016887
	for <linux-crypto@vger.kernel.org>; Thu, 18 Dec 2008 11:34:47 -0700 (MST)
Received: from az33exm25.fsl.freescale.net (az33exm25.am.freescale.net [10.64.32.16])
	by de01smr02.am.mot.com (8.13.1/8.13.0) with ESMTP id mBIIYjLN011609
	for <linux-crypto@vger.kernel.org>; Thu, 18 Dec 2008 12:34:46 -0600 (CST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Previous commit for interrupt mitigation moved the done interrupt
acknowlegement from the isr to the talitos_done tasklet.
This patch moves the done interrupt acknowledgement back
into the isr so that done interrupts will always be acknowledged.
This covers the case for acknowledging interrupts for channel done processing
that has actually already been completed by the tasklet prior to fielding
a pending interrupt.

Signed-off-by: Lee Nipper <lee.nipper@freescale.com>
Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
This patch applies to
git://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git

 drivers/crypto/talitos.c |   20 +++++++-------------
 1 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index c2294f2..d14c68d 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -330,11 +330,9 @@ static void flush_channel(struct device *dev, int ch, int error, int reset_ch)
 
 		/* descriptors with their done bits set don't get the error */
 		rmb();
-		if ((request->desc->hdr & DESC_HDR_DONE) == DESC_HDR_DONE) {
+		if ((request->desc->hdr & DESC_HDR_DONE) == DESC_HDR_DONE)
 			status = 0;
-			/* Ack each pkt completed on channel */
-			out_be32(priv->reg + TALITOS_ICR, (1 << (ch * 2)));
-		} else
+		else
 			if (!error)
 				break;
 			else
@@ -575,17 +573,13 @@ static irqreturn_t talitos_interrupt(int irq, void *data)
 
 	isr = in_be32(priv->reg + TALITOS_ISR);
 	isr_lo = in_be32(priv->reg + TALITOS_ISR_LO);
+	/* Acknowledge interrupt */
+	out_be32(priv->reg + TALITOS_ICR, isr);
+	out_be32(priv->reg + TALITOS_ICR_LO, isr_lo);
 
-	if (unlikely((isr & ~TALITOS_ISR_CHDONE) || isr_lo)) {
-		/*
-		 * Acknowledge error interrupts here.
-		 * Done interrupts are ack'ed as part of done_task.
-		 */
-		out_be32(priv->reg + TALITOS_ICR, isr);
-		out_be32(priv->reg + TALITOS_ICR_LO, isr_lo);
