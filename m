From: Lee Nipper <lee.nipper@gmail.com>
Subject: [PATCH] crypto: talitos - protect against possible null ptr upon error
Date: Sun, 15 Mar 2009 20:21:47 -0500
Message-ID: <1237166510-7312-1-git-send-email-lee.nipper@gmail.com>
Cc: kim.phillips@freescale.com, Lee Nipper <lee.nipper@gmail.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qy0-f122.google.com ([209.85.221.122]:45351 "EHLO
	mail-qy0-f122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755225AbZCPBV6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 15 Mar 2009 21:21:58 -0400
Received: by qyk28 with SMTP id 28so3993521qyk.33
        for <linux-crypto@vger.kernel.org>; Sun, 15 Mar 2009 18:21:53 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Added test for null descriptor returned from current_desc.
Also removed the diagnostic from current_desc,
and added one instead in talitos_error
to report an EU error without finding the descriptor.

Signed-off-by: Lee Nipper <lee.nipper@gmail.com>
---
 drivers/crypto/talitos.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index a3918c1..d853530 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -401,10 +401,8 @@ static struct talitos_desc *current_desc(struct device *dev, int ch)
 
 	while (priv->fifo[ch][tail].dma_desc != cur_desc) {
 		tail = (tail + 1) & (priv->fifo_len - 1);
-		if (tail == priv->tail[ch]) {
-			dev_err(dev, "couldn't locate current descriptor\n");
+		if (tail == priv->tail[ch])
 			return NULL;
-		}
 	}
 
 	return priv->fifo[ch][tail].desc;
@@ -523,8 +521,14 @@ static void talitos_error(unsigned long data, u32 isr, u32 isr_lo)
 			dev_err(dev, "illegal descriptor header error\n");
 		if (v_lo & TALITOS_CCPSR_LO_IEU)
 			dev_err(dev, "invalid execution unit error\n");
-		if (v_lo & TALITOS_CCPSR_LO_EU)
-			report_eu_error(dev, ch, current_desc(dev, ch));
+		if (v_lo & TALITOS_CCPSR_LO_EU) {
+			struct talitos_desc *desc = current_desc(dev, ch);
+			if (desc)
+				report_eu_error(dev, ch, desc);
+			else
+				dev_err(dev,
+					"EU error, but no descriptor found.\n");
+		}
 		if (v_lo & TALITOS_CCPSR_LO_GB)
 			dev_err(dev, "gather boundary error\n");
 		if (v_lo & TALITOS_CCPSR_LO_GRL)
-- 
1.5.6.3

