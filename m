From: Victoria Milhoan <vicki.milhoan@freescale.com>
Subject: [PATCH RFC 10/11] crypto: caam - Provide correct value to iounmap() in controller driver
Date: Mon, 15 Jun 2015 16:52:58 -0700
Message-ID: <1434412379-11623-11-git-send-email-vicki.milhoan@freescale.com>
References: <1434412379-11623-1-git-send-email-vicki.milhoan@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <herbert@gondor.apana.org.au>, <horia.geanta@freescale.com>,
	<ruchika.gupta@freescale.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1bon0140.outbound.protection.outlook.com ([157.56.111.140]:12000
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751397AbbFOXxM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Jun 2015 19:53:12 -0400
In-Reply-To: <1434412379-11623-1-git-send-email-vicki.milhoan@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fix a "Trying to vfree() nonexistent vm area" error when unloading the CAAM
controller module by providing the correct pointer value to iounmap().

Signed-off-by: Victoria Milhoan <vicki.milhoan@freescale.com>
---
 drivers/crypto/caam/ctrl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 3226eb8..8a4b239 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -301,7 +301,7 @@ static int caam_remove(struct platform_device *pdev)
 #endif
 
 	/* Unmap controller region */
-	iounmap(&ctrl);
+	iounmap(ctrl);
 
 #ifdef CONFIG_ARM
 	/* shut clocks off before finalizing shutdown */
@@ -577,7 +577,7 @@ static int caam_probe(struct platform_device *pdev)
 					sizeof(struct platform_device *) * rspec,
 					GFP_KERNEL);
 	if (ctrlpriv->jrpdev == NULL) {
-		iounmap(&ctrl);
+		iounmap(ctrl);
 		return -ENOMEM;
 	}
 
-- 
2.1.4
