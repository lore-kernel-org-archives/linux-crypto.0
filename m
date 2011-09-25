From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH] talitos: handle descriptor not found in error path
Date: Sat, 24 Sep 2011 19:16:49 -0500
Message-ID: <20110924191649.a42c86d2.kim.phillips@freescale.com>
References: <877h544vh6.fsf@begreifnix.stackframe.org>
	<20110919162001.e296597e.kim.phillips@freescale.com>
	<8762kn2v8m.fsf@begreifnix.stackframe.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>
To: Sven Schnelle <svens@stackframe.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:26634 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750946Ab1IYARe (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 24 Sep 2011 20:17:34 -0400
In-Reply-To: <8762kn2v8m.fsf@begreifnix.stackframe.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The CDPR (Current Descriptor Pointer Register) can be unreliable
when trying to locate an offending descriptor.  Handle that case by
(a) not OOPSing, and (b) reverting to the machine internal copy of
the descriptor header in order to report the correct execution unit
error.

Note: printing all execution units' ISRs is not effective because it
results in an internal time out (ITO) error and the EU resetting its
ISR value (at least when specifying an invalid key length on an SEC
2.2/MPC8313E).

Reported-by: Sven Schnelle <svens@stackframe.org>
Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
please test, as it seems I cannot reproduce the descriptor not found
case.

 drivers/crypto/talitos.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 8a0bb41..dbe76b5 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -416,7 +416,7 @@ static void talitos_done(unsigned long data)
 /*
  * locate current (offending) descriptor
  */
-static struct talitos_desc *current_desc(struct device *dev, int ch)
+static u32 current_desc_hdr(struct device *dev, int ch)
 {
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	int tail = priv->chan[ch].tail;
@@ -428,23 +428,25 @@ static struct talitos_desc *current_desc(struct device *dev, int ch)
 		tail = (tail + 1) & (priv->fifo_len - 1);
 		if (tail == priv->chan[ch].tail) {
 			dev_err(dev, "couldn't locate current descriptor\n");
-			return NULL;
+			return 0;
 		}
 	}
 
-	return priv->chan[ch].fifo[tail].desc;
+	return priv->chan[ch].fifo[tail].desc->hdr;
 }
 
 /*
  * user diagnostics; report root cause of error based on execution unit status
  */
-static void report_eu_error(struct device *dev, int ch,
-			    struct talitos_desc *desc)
+static void report_eu_error(struct device *dev, int ch, u32 desc_hdr)
 {
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	int i;
 
-	switch (desc->hdr & DESC_HDR_SEL0_MASK) {
+	if (!desc_hdr)
+		desc_hdr = in_be32(priv->reg + TALITOS_DESCBUF(ch));
+
+	switch (desc_hdr & DESC_HDR_SEL0_MASK) {
 	case DESC_HDR_SEL0_AFEU:
 		dev_err(dev, "AFEUISR 0x%08x_%08x\n",
 			in_be32(priv->reg + TALITOS_AFEUISR),
@@ -488,7 +490,7 @@ static void report_eu_error(struct device *dev, int ch,
 		break;
 	}
 
-	switch (desc->hdr & DESC_HDR_SEL1_MASK) {
+	switch (desc_hdr & DESC_HDR_SEL1_MASK) {
 	case DESC_HDR_SEL1_MDEUA:
 	case DESC_HDR_SEL1_MDEUB:
 		dev_err(dev, "MDEUISR 0x%08x_%08x\n",
@@ -550,7 +552,7 @@ static void talitos_error(unsigned long data, u32 isr, u32 isr_lo)
 		if (v_lo & TALITOS_CCPSR_LO_IEU)
 			dev_err(dev, "invalid execution unit error\n");
 		if (v_lo & TALITOS_CCPSR_LO_EU)
-			report_eu_error(dev, ch, current_desc(dev, ch));
+			report_eu_error(dev, ch, current_desc_hdr(dev, ch));
 		if (v_lo & TALITOS_CCPSR_LO_GB)
 			dev_err(dev, "gather boundary error\n");
 		if (v_lo & TALITOS_CCPSR_LO_GRL)
-- 
1.7.6
