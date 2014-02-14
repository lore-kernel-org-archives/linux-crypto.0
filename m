From: Fabio Estevam <festevam@gmail.com>
Subject: [PATCH] crypto: mxs-dcp: Fix platform_get_irq() error handling
Date: Fri, 14 Feb 2014 01:04:44 -0200
Message-ID: <1392347084-7801-1-git-send-email-festevam@gmail.com>
Cc: marex@denx.de, linux-crypto@vger.kernel.org,
	Fabio Estevam <fabio.estevam@freescale.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yk0-f178.google.com ([209.85.160.178]:43089 "EHLO
	mail-yk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbaBNDEx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 13 Feb 2014 22:04:53 -0500
Received: by mail-yk0-f178.google.com with SMTP id 79so21705306ykr.9
        for <linux-crypto@vger.kernel.org>; Thu, 13 Feb 2014 19:04:52 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@freescale.com>

We should test the error case for each platform_get_irq() assignment and
propagate the error accordingly.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/crypto/mxs-dcp.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
index 37e0706..08761d6 100644
--- a/drivers/crypto/mxs-dcp.c
+++ b/drivers/crypto/mxs-dcp.c
@@ -908,9 +908,14 @@ static int mxs_dcp_probe(struct platform_device *pdev)
 
 	iores = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	dcp_vmi_irq = platform_get_irq(pdev, 0);
+	if (dcp_vmi_irq < 0) {
+		ret = dcp_vmi_irq;
+		goto err_mutex;
+	}
+
 	dcp_irq = platform_get_irq(pdev, 1);
-	if (dcp_vmi_irq < 0 || dcp_irq < 0) {
-		ret = -EINVAL;
+	if (dcp_irq < 0) {
+		ret = dcp_irq;
 		goto err_mutex;
 	}
 
-- 
1.8.1.2
