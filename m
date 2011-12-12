From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH 3/7] crypto: talitos - convert talitos_error to struct device
Date: Mon, 12 Dec 2011 14:59:12 -0600
Message-ID: <1323723556-7100-4-git-send-email-kim.phillips@freescale.com>
References: <1323723556-7100-1-git-send-email-kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:15401
	"EHLO DB3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754006Ab1LLVAf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 12 Dec 2011 16:00:35 -0500
In-Reply-To: <1323723556-7100-1-git-send-email-kim.phillips@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

SEC2/3 h/w doesn't have a dedicated interrupt for errors,
and the only callsite for talitos_error has already done
the type conversion, so simplify talitos_error to take a
pointer to a struct device.

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/talitos.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 503d0d8..2d8c789 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -534,9 +534,8 @@ static void report_eu_error(struct device *dev, int ch, u32 desc_hdr)
 /*
  * recover from error interrupts
  */
-static void talitos_error(unsigned long data, u32 isr, u32 isr_lo)
+static void talitos_error(struct device *dev, u32 isr, u32 isr_lo)
 {
-	struct device *dev = (struct device *)data;
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	unsigned int timeout = TALITOS_TIMEOUT;
 	int ch, error, reset_dev = 0, reset_ch = 0;
@@ -628,7 +627,7 @@ static irqreturn_t talitos_interrupt_##name(int irq, void *data)	       \
 	out_be32(priv->reg + TALITOS_ICR_LO, isr_lo);			       \
 									       \
 	if (unlikely((isr & ~TALITOS_ISR_4CHDONE) & ch_err_mask || isr_lo))    \
-		talitos_error((unsigned long)data, isr, isr_lo);	       \
+		talitos_error(dev, isr, isr_lo);			       \
 	else								       \
 		if (likely(isr & ch_done_mask)) {			       \
 			/* mask further done interrupts. */		       \
-- 
1.7.8
