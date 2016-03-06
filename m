From: Vladimir Zapolskiy <vz@mleia.com>
Subject: [PATCH] crypto: ux500: fix checks of error code returned by devm_ioremap_resource()
Date: Sun,  6 Mar 2016 03:22:04 +0200
Message-ID: <1457227324-3243-1-git-send-email-vz@mleia.com>
Cc: LABBE Corentin <clabbe.montjoie@gmail.com>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mleia.com ([178.79.152.223]:41554 "EHLO mail.mleia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751116AbcCFBWL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 5 Mar 2016 20:22:11 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The change fixes potential oops while accessing iomem on invalid
address, if devm_ioremap_resource() fails due to some reason.

The devm_ioremap_resource() function returns ERR_PTR() and never
returns NULL, which makes useless a following check for NULL.

Signed-off-by: Vladimir Zapolskiy <vz@mleia.com>
Fixes: 5a4eea2658c93 ("crypto: ux500 - Use devm_xxx() managed function")
---
 drivers/crypto/ux500/cryp/cryp_core.c | 4 ++--
 drivers/crypto/ux500/hash/hash_core.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/ux500/cryp/cryp_core.c b/drivers/crypto/ux500/cryp/cryp_core.c
index 4c243c1..790f7ca 100644
--- a/drivers/crypto/ux500/cryp/cryp_core.c
+++ b/drivers/crypto/ux500/cryp/cryp_core.c
@@ -1440,9 +1440,9 @@ static int ux500_cryp_probe(struct platform_device *pdev)
 
 	device_data->phybase = res->start;
 	device_data->base = devm_ioremap_resource(dev, res);
-	if (!device_data->base) {
+	if (IS_ERR(device_data->base)) {
 		dev_err(dev, "[%s]: ioremap failed!", __func__);
-		ret = -ENOMEM;
+		ret = PTR_ERR(device_data->base);
 		goto out;
 	}
 
diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
index d6fdc58..574e87c 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -1659,9 +1659,9 @@ static int ux500_hash_probe(struct platform_device *pdev)
 
 	device_data->phybase = res->start;
 	device_data->base = devm_ioremap_resource(dev, res);
-	if (!device_data->base) {
+	if (IS_ERR(device_data->base)) {
 		dev_err(dev, "%s: ioremap() failed!\n", __func__);
-		ret = -ENOMEM;
+		ret = PTR_ERR(device_data->base);
 		goto out;
 	}
 	spin_lock_init(&device_data->ctx_lock);
-- 
2.1.4
