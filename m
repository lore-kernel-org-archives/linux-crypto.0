From: Jean Delvare <jdelvare@suse.de>
Subject: [PATCH] crypto: Add 2 missing __exit_p
Date: Thu, 29 May 2014 09:54:35 +0200
Message-ID: <20140529095435.72cb6b6e@endymion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Robert Jennings <rcj@linux.vnet.ibm.com>,
	Marcelo Henrique Cerri <mhcerri@linux.vnet.ibm.com>,
	Fionnuala Gunter <fin@linux.vnet.ibm.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42964 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751206AbaE2Hyj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 29 May 2014 03:54:39 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

References to __exit functions must be wrapped with __exit_p.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Robert Jennings <rcj@linux.vnet.ibm.com>
Cc: Marcelo Henrique Cerri <mhcerri@linux.vnet.ibm.com>
Cc: Fionnuala Gunter <fin@linux.vnet.ibm.com>
---
 drivers/crypto/amcc/crypto4xx_core.c |    2 +-
 drivers/crypto/nx/nx-842.c           |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- linux-3.15-rc7.orig/drivers/crypto/amcc/crypto4xx_core.c	2014-03-31 05:40:15.000000000 +0200
+++ linux-3.15-rc7/drivers/crypto/amcc/crypto4xx_core.c	2014-05-28 16:03:06.856588584 +0200
@@ -1292,7 +1292,7 @@ static struct platform_driver crypto4xx_
 		.of_match_table = crypto4xx_match,
 	},
 	.probe		= crypto4xx_probe,
-	.remove		= crypto4xx_remove,
+	.remove		= __exit_p(crypto4xx_remove),
 };
 
 module_platform_driver(crypto4xx_driver);
--- linux-3.15-rc7.orig/drivers/crypto/nx/nx-842.c	2014-05-28 15:37:10.831538018 +0200
+++ linux-3.15-rc7/drivers/crypto/nx/nx-842.c	2014-05-28 16:02:44.926136000 +0200
@@ -1247,7 +1247,7 @@ static struct vio_device_id nx842_driver
 static struct vio_driver nx842_driver = {
 	.name = MODULE_NAME,
 	.probe = nx842_probe,
-	.remove = nx842_remove,
+	.remove = __exit_p(nx842_remove),
 	.get_desired_dma = nx842_get_desired_dma,
 	.id_table = nx842_driver_ids,
 };


-- 
Jean Delvare
SUSE L3 Support
