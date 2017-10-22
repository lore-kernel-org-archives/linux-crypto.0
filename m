From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH] crypto-ccp: Use common error handling code in sp_get_irqs()
Date: Sun, 22 Oct 2017 14:16:53 +0200
Message-ID: <0abcf065-56e9-dd3c-e210-0b0c21828a84@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
To: linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Gary Hook <gary.hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Tom Lendacky <thomas.lendacky@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.web.de ([217.72.192.78]:56134 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750736AbdJVMRO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 22 Oct 2017 08:17:14 -0400
Content-Language: en-GB
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 22 Oct 2017 14:10:33 +0200

Add a jump target so that a bit of exception handling can be better reused
at the end of this function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/crypto/ccp/sp-platform.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/ccp/sp-platform.c b/drivers/crypto/ccp/sp-platform.c
index 71734f254fd1..7d7670c7484a 100644
--- a/drivers/crypto/ccp/sp-platform.c
+++ b/drivers/crypto/ccp/sp-platform.c
@@ -78,25 +78,25 @@ static int sp_get_irqs(struct sp_device *sp)
 	sp_platform->irq_count = count;
 
 	ret = platform_get_irq(pdev, 0);
-	if (ret < 0) {
-		dev_notice(dev, "unable to get IRQ (%d)\n", ret);
-		return ret;
-	}
+	if (ret < 0)
+		goto report_failure;
 
 	sp->psp_irq = ret;
 	if (count == 1) {
 		sp->ccp_irq = ret;
 	} else {
 		ret = platform_get_irq(pdev, 1);
-		if (ret < 0) {
-			dev_notice(dev, "unable to get IRQ (%d)\n", ret);
-			return ret;
-		}
+		if (ret < 0)
+			goto report_failure;
 
 		sp->ccp_irq = ret;
 	}
 
 	return 0;
+
+report_failure:
+	dev_notice(dev, "unable to get IRQ (%d)\n", ret);
+	return ret;
 }
 
 static int sp_platform_probe(struct platform_device *pdev)
-- 
2.14.2
