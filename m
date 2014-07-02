From: Cristian Stoica <cristian.stoica@freescale.com>
Subject: [PATCH] crypto: caam - fix memleak in caam_jr module
Date: Wed, 2 Jul 2014 14:49:53 +0300
Message-ID: <1404301793-12930-1-git-send-email-cristian.stoica@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1blp0183.outbound.protection.outlook.com ([207.46.163.183]:7043
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751134AbaGBLuO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 2 Jul 2014 07:50:14 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch fixes a memory leak that appears when caam_jr module is unloaded.

Cc: <stable@vger.kernel.org> # 3.13+
Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>
---
 drivers/crypto/caam/jr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index 1d80bd3..f127f86 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -117,6 +117,7 @@ static int caam_jr_remove(struct platform_device *pdev)
 	if (ret)
 		dev_err(jrdev, "Failed to shut down job ring\n");
 	irq_dispose_mapping(jrpriv->irq);
+	kfree(jrpriv);
 
 	return ret;
 }
-- 
1.8.3.1
