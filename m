From: Jamie Iles <jamie@jamieiles.com>
Subject: [PATCH 1/3] crypto: picoxcell - convert to platform ID table
Date: Mon,  1 Aug 2011 17:25:17 +0100
Message-ID: <1312215919-24419-1-git-send-email-jamie@jamieiles.com>
Cc: Jamie Iles <jamie@jamieiles.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43793 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041Ab1HAQZ0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Aug 2011 12:25:26 -0400
Received: by wwe5 with SMTP id 5so5816427wwe.1
        for <linux-crypto@vger.kernel.org>; Mon, 01 Aug 2011 09:25:25 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Use a platform ID table and a single platform_driver.  It's neater and
makes the device tree addition easier and more consistent.  Rename the
match values to be inline with what they'll be in the device tree
bindings.  There aren't any current in-tree users of the existing device
names.

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Jamie Iles <jamie@jamieiles.com>
---
 drivers/crypto/picoxcell_crypto.c |   93 +++++++++++++------------------------
 1 files changed, 33 insertions(+), 60 deletions(-)

diff --git a/drivers/crypto/picoxcell_crypto.c b/drivers/crypto/picoxcell_crypto.c
index 230b5b8..4ffb903 100644
--- a/drivers/crypto/picoxcell_crypto.c
+++ b/drivers/crypto/picoxcell_crypto.c
@@ -1657,25 +1657,38 @@ static struct spacc_alg l2_engine_algs[] = {
 	},
 };
 
-static int __devinit spacc_probe(struct platform_device *pdev,
-				 unsigned max_ctxs, size_t cipher_pg_sz,
-				 size_t hash_pg_sz, size_t fifo_sz,
-				 struct spacc_alg *algs, size_t num_algs)
+static int __devinit spacc_probe(struct platform_device *pdev)
 {
 	int i, err, ret = -EINVAL;
 	struct resource *mem, *irq;
+	const struct platform_device_id *platid = platform_get_device_id(pdev);
 	struct spacc_engine *engine = devm_kzalloc(&pdev->dev, sizeof(*engine),
 						   GFP_KERNEL);
 	if (!engine)
 		return -ENOMEM;
 
-	engine->max_ctxs	= max_ctxs;
-	engine->cipher_pg_sz	= cipher_pg_sz;
-	engine->hash_pg_sz	= hash_pg_sz;
-	engine->fifo_sz		= fifo_sz;
-	engine->algs		= algs;
-	engine->num_algs	= num_algs;
-	engine->name		= dev_name(&pdev->dev);
+	if (!platid)
+		return -EINVAL;
+
+	if (!strcmp(platid->name, "picoxcell-ipsec")) {
+		engine->max_ctxs	= SPACC_CRYPTO_IPSEC_MAX_CTXS;
+		engine->cipher_pg_sz	= SPACC_CRYPTO_IPSEC_CIPHER_PG_SZ;
+		engine->hash_pg_sz	= SPACC_CRYPTO_IPSEC_HASH_PG_SZ;
+		engine->fifo_sz		= SPACC_CRYPTO_IPSEC_FIFO_SZ;
+		engine->algs		= ipsec_engine_algs;
+		engine->num_algs	= ARRAY_SIZE(ipsec_engine_algs);
+	} else if (!strcmp(platid->name, "picoxcell-l2")) {
+		engine->max_ctxs	= SPACC_CRYPTO_L2_MAX_CTXS;
+		engine->cipher_pg_sz	= SPACC_CRYPTO_L2_CIPHER_PG_SZ;
+		engine->hash_pg_sz	= SPACC_CRYPTO_L2_HASH_PG_SZ;
+		engine->fifo_sz		= SPACC_CRYPTO_L2_FIFO_SZ;
+		engine->algs		= l2_engine_algs;
+		engine->num_algs	= ARRAY_SIZE(l2_engine_algs);
+	} else {
+		return -EINVAL;
+	}
+
+	engine->name = dev_name(&pdev->dev);
 
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
@@ -1800,72 +1813,32 @@ static int __devexit spacc_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static int __devinit ipsec_probe(struct platform_device *pdev)
-{
-	return spacc_probe(pdev, SPACC_CRYPTO_IPSEC_MAX_CTXS,
-			   SPACC_CRYPTO_IPSEC_CIPHER_PG_SZ,
-			   SPACC_CRYPTO_IPSEC_HASH_PG_SZ,
-			   SPACC_CRYPTO_IPSEC_FIFO_SZ, ipsec_engine_algs,
-			   ARRAY_SIZE(ipsec_engine_algs));
-}
-
-static struct platform_driver ipsec_driver = {
-	.probe		= ipsec_probe,
-	.remove		= __devexit_p(spacc_remove),
-	.driver		= {
-		.name	= "picoxcell-ipsec",
-#ifdef CONFIG_PM
-		.pm	= &spacc_pm_ops,
-#endif /* CONFIG_PM */
-	},
+static const struct platform_device_id spacc_id_table[] = {
+	{ "picochip,spacc-ipsec", },
+	{ "picochip,spacc-l2", },
 };
 
-static int __devinit l2_probe(struct platform_device *pdev)
-{
-	return spacc_probe(pdev, SPACC_CRYPTO_L2_MAX_CTXS,
-			   SPACC_CRYPTO_L2_CIPHER_PG_SZ,
-			   SPACC_CRYPTO_L2_HASH_PG_SZ, SPACC_CRYPTO_L2_FIFO_SZ,
-			   l2_engine_algs, ARRAY_SIZE(l2_engine_algs));
-}
-
-static struct platform_driver l2_driver = {
-	.probe		= l2_probe,
+static struct platform_driver spacc_driver = {
+	.probe		= spacc_probe,
 	.remove		= __devexit_p(spacc_remove),
 	.driver		= {
-		.name	= "picoxcell-l2",
+		.name	= "picochip,spacc",
 #ifdef CONFIG_PM
 		.pm	= &spacc_pm_ops,
 #endif /* CONFIG_PM */
 	},
+	.id_table	= spacc_id_table,
 };
 
 static int __init spacc_init(void)
 {
-	int ret = platform_driver_register(&ipsec_driver);
-	if (ret) {
-		pr_err("failed to register ipsec spacc driver");
-		goto out;
-	}
-
-	ret = platform_driver_register(&l2_driver);
-	if (ret) {
-		pr_err("failed to register l2 spacc driver");
-		goto l2_failed;
-	}
-
-	return 0;
-
-l2_failed:
-	platform_driver_unregister(&ipsec_driver);
-out:
-	return ret;
+	return platform_driver_register(&spacc_driver);
 }
 module_init(spacc_init);
 
 static void __exit spacc_exit(void)
 {
-	platform_driver_unregister(&ipsec_driver);
-	platform_driver_unregister(&l2_driver);
+	platform_driver_unregister(&spacc_driver);
 }
 module_exit(spacc_exit);
 
-- 
1.7.4.1
