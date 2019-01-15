Return-Path: <SRS0=hYBA=PX=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:50768 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729245AbfAONns (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Jan 2019 08:43:48 -0500
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] crypto: ccree: shared irq lines are not a bug
Date: Tue, 15 Jan 2019 15:43:16 +0200
Message-Id: <20190115134318.28712-7-gilad@benyossef.com>
In-Reply-To: <20190115134318.28712-1-gilad@benyossef.com>
References: <20190115134318.28712-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The ccree driver was logging an error if it got an interrupt but
HW indicated nothing to do as might happen if sharing an irq line.
Remove the error as this is normal and we already have a debug
print for the IRR register value.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/crypto/ccree/cc_driver.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/ccree/cc_driver.c b/drivers/crypto/ccree/cc_driver.c
index 8ada308d72ee..e75fbe7a8f84 100644
--- a/drivers/crypto/ccree/cc_driver.c
+++ b/drivers/crypto/ccree/cc_driver.c
@@ -103,10 +103,10 @@ static irqreturn_t cc_isr(int irq, void *dev_id)
 	/* read the interrupt status */
 	irr = cc_ioread(drvdata, CC_REG(HOST_IRR));
 	dev_dbg(dev, "Got IRR=0x%08X\n", irr);
-	if (irr == 0) { /* Probably shared interrupt line */
-		dev_err(dev, "Got interrupt with empty IRR\n");
+
+	if (irr == 0) /* Probably shared interrupt line */
 		return IRQ_NONE;
-	}
+
 	imr = cc_ioread(drvdata, CC_REG(HOST_IMR));
 
 	/* clear interrupt - must be before processing events */
-- 
2.20.1
