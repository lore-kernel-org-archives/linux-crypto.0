From: Vakul Garg <vakul@freescale.com>
Subject: RE: [PATCH] crypto: caam - fix memleak in caam_jr module
Date: Thu, 3 Jul 2014 07:52:51 +0000
Message-ID: <75b67e0fc305452fb5075e5bee5fff9c@BL2PR03MB162.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: "cristian.stoica@freescale.com" <cristian.stoica@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2lp0207.outbound.protection.outlook.com ([207.46.163.207]:11986
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755954AbaGCHxX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 3 Jul 2014 03:53:23 -0400
Content-Language: en-US
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

Can you replace kmalloc for jrpriv with devm_kzalloc() instead?
This will fix leaks for jrpriv in other places as well and make code compact.
 
 	return ret;
 }
-- 
1.8.3.1

--
