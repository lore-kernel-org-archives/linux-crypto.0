From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] crypto: sahara: fix building as module
Date: Mon, 03 Jun 2013 23:57:37 +0200
Message-ID: <3573891.yE7nyLPekp@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Javier Martin <javier.martin@vista-silicon.com>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:60289 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757697Ab3FCV5V (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 3 Jun 2013 17:57:21 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The sahara crypto driver has an incorrect MODULE_DEVICE_TABLE, which
prevents us from actually building this driver as a loadable module.

sahara_dt_ids is a of_device_id array, so we have to use
MODULE_DEVICE_TABLE(of, ...).

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Javier Martin <javier.martin@vista-silicon.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index a97bb6c..c3dc1c0 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -863,7 +863,7 @@ static struct of_device_id sahara_dt_ids[] = {
 	{ .compatible = "fsl,imx27-sahara" },
 	{ /* sentinel */ }
 };
-MODULE_DEVICE_TABLE(platform, sahara_dt_ids);
+MODULE_DEVICE_TABLE(of, sahara_dt_ids);
 
 static int sahara_probe(struct platform_device *pdev)
 {
