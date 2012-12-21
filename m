From: "Mark A. Greer" <mgreer@animalcreek.com>
Subject: [PATCH 01/10] crypto: omap-aes - Remmove unnecessary pr_info noise
Date: Fri, 21 Dec 2012 10:04:51 -0700
Message-ID: <1356109500-11719-2-git-send-email-mgreer@animalcreek.com>
References: <1356109500-11719-1-git-send-email-mgreer@animalcreek.com>
Cc: linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	"Mark A. Greer" <mgreer@animalcreek.com>,
	Dmitry Kasatkin <dmitry.kasatkin@intel.com>
To: davem@davemloft.net, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail20.dotsterhost.com ([66.11.232.73]:49609 "EHLO
	mail20.dotsterhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515Ab2LURFK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 21 Dec 2012 12:05:10 -0500
In-Reply-To: <1356109500-11719-1-git-send-email-mgreer@animalcreek.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: "Mark A. Greer" <mgreer@animalcreek.com>

Remove the unnecessary pr_info() calls from omap_aes_probe()
and omap_aes_mod_init().

CC: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Signed-off-by: Mark A. Greer <mgreer@animalcreek.com>
---
 drivers/crypto/omap-aes.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index e66e8ee..481da71 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -880,8 +880,6 @@ static int omap_aes_probe(struct platform_device *pdev)
 			goto err_algs;
 	}
 
-	pr_info("probe() done\n");
-
 	return 0;
 err_algs:
 	for (j = 0; j < i; j++)
@@ -938,8 +936,6 @@ static struct platform_driver omap_aes_driver = {
 
 static int __init omap_aes_mod_init(void)
 {
-	pr_info("loading %s driver\n", "omap-aes");
-
 	return  platform_driver_register(&omap_aes_driver);
 }
 
-- 
1.7.12
