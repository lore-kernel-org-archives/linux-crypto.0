From: Vladimir Zapolskiy <vz@mleia.com>
Subject: [PATCH] crypto: atmel: fix checks of error code returned by devm_ioremap_resource()
Date: Sun,  6 Mar 2016 03:21:52 +0200
Message-ID: <1457227312-3190-1-git-send-email-vz@mleia.com>
Cc: Cyrille Pitchen <cyrille.pitchen@atmel.com>,
	LABBE Corentin <clabbe.montjoie@gmail.com>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mleia.com ([178.79.152.223]:41538 "EHLO mail.mleia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751116AbcCFBWA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 5 Mar 2016 20:22:00 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The change fixes potential oops while accessing iomem on invalid
address, if devm_ioremap_resource() fails due to some reason.

The devm_ioremap_resource() function returns ERR_PTR() and never
returns NULL, which makes useless a following check for NULL.

Signed-off-by: Vladimir Zapolskiy <vz@mleia.com>
Fixes: b0e8b3417a62 ("crypto: atmel - use devm_xxx() managed function")
---
 drivers/crypto/atmel-aes.c  | 4 ++--
 drivers/crypto/atmel-sha.c  | 4 ++--
 drivers/crypto/atmel-tdes.c | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 3eb3f12..7de007a 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -2085,9 +2085,9 @@ static int atmel_aes_probe(struct platform_device *pdev)
 	}
 
 	aes_dd->io_base = devm_ioremap_resource(&pdev->dev, aes_res);
-	if (!aes_dd->io_base) {
+	if (IS_ERR(aes_dd->io_base)) {
 		dev_err(dev, "can't ioremap\n");
-		err = -ENOMEM;
+		err = PTR_ERR(aes_dd->io_base);
 		goto res_err;
 	}
 
diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index 8bf9914..68d47a2 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -1404,9 +1404,9 @@ static int atmel_sha_probe(struct platform_device *pdev)
 	}
 
 	sha_dd->io_base = devm_ioremap_resource(&pdev->dev, sha_res);
-	if (!sha_dd->io_base) {
+	if (IS_ERR(sha_dd->io_base)) {
 		dev_err(dev, "can't ioremap\n");
-		err = -ENOMEM;
+		err = PTR_ERR(sha_dd->io_base);
 		goto res_err;
 	}
 
diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index 2c7a628..bf467d7 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -1417,9 +1417,9 @@ static int atmel_tdes_probe(struct platform_device *pdev)
 	}
 
 	tdes_dd->io_base = devm_ioremap_resource(&pdev->dev, tdes_res);
-	if (!tdes_dd->io_base) {
+	if (IS_ERR(tdes_dd->io_base)) {
 		dev_err(dev, "can't ioremap\n");
-		err = -ENOMEM;
+		err = PTR_ERR(tdes_dd->io_base);
 		goto res_err;
 	}
 
-- 
2.1.4
