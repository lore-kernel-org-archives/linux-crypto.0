From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] crypto: mxs-dcp: print error message on platform_get_irq
 failure
Date: Fri, 30 Jun 2017 01:54:16 -0500
Message-ID: <20170630065416.GA14743@embeddedgus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from gateway22.websitewelcome.com ([192.185.47.100]:33916 "EHLO
        gateway22.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751532AbdF3GyT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Jun 2017 02:54:19 -0400
Received: from cm14.websitewelcome.com (cm14.websitewelcome.com [100.42.49.7])
        by gateway22.websitewelcome.com (Postfix) with ESMTP id 2829F634C9
        for <linux-crypto@vger.kernel.org>; Fri, 30 Jun 2017 01:54:17 -0500 (CDT)
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Print error message on platform_get_irq failure before return.

Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/crypto/mxs-dcp.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
index 625ee50..764be3e 100644
--- a/drivers/crypto/mxs-dcp.c
+++ b/drivers/crypto/mxs-dcp.c
@@ -908,12 +908,16 @@ static int mxs_dcp_probe(struct platform_device *pdev)
 
 	iores = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	dcp_vmi_irq = platform_get_irq(pdev, 0);
-	if (dcp_vmi_irq < 0)
+	if (dcp_vmi_irq < 0) {
+		dev_err(dev, "Failed to get IRQ: (%d)!\n", dcp_vmi_irq);
 		return dcp_vmi_irq;
+	}
 
 	dcp_irq = platform_get_irq(pdev, 1);
-	if (dcp_irq < 0)
+	if (dcp_irq < 0) {
+		dev_err(dev, "Failed to get IRQ: (%d)!\n", dcp_irq);
 		return dcp_irq;
+	}
 
 	sdcp = devm_kzalloc(dev, sizeof(*sdcp), GFP_KERNEL);
 	if (!sdcp)
-- 
2.5.0
