From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH] crypto: amcc: remove incorrect __init/__exit markups
Date: Mon, 9 Mar 2015 13:35:39 -0700
Message-ID: <20150309203539.GA11240@dtor-ws>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ie0-f179.google.com ([209.85.223.179]:38578 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107AbbCIUfn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 9 Mar 2015 16:35:43 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Even if bus is not hot-pluggable, the devices can be bound and unbound
from the driver via sysfs, so we should not be using __init/__exit
annotations on probe() and remove() methods. The only exception is
drivers registered with platform_driver_probe() which specifically
disables sysfs bind/unbind attributes.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/crypto/amcc/crypto4xx_core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index d02b771..3b28e8c 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -1155,7 +1155,7 @@ struct crypto4xx_alg_common crypto4xx_alg[] = {
 /**
  * Module Initialization Routine
  */
-static int __init crypto4xx_probe(struct platform_device *ofdev)
+static int crypto4xx_probe(struct platform_device *ofdev)
 {
 	int rc;
 	struct resource res;
@@ -1263,7 +1263,7 @@ err_alloc_dev:
 	return rc;
 }
 
-static int __exit crypto4xx_remove(struct platform_device *ofdev)
+static int crypto4xx_remove(struct platform_device *ofdev)
 {
 	struct device *dev = &ofdev->dev;
 	struct crypto4xx_core_device *core_dev = dev_get_drvdata(dev);
@@ -1291,7 +1291,7 @@ static struct platform_driver crypto4xx_driver = {
 		.of_match_table = crypto4xx_match,
 	},
 	.probe		= crypto4xx_probe,
-	.remove		= __exit_p(crypto4xx_remove),
+	.remove		= crypto4xx_remove,
 };
 
 module_platform_driver(crypto4xx_driver);
-- 
2.2.0.rc0.207.ga3a616c


-- 
Dmitry
