From: Alexey Khoroshilov <khoroshilov@ispras.ru>
Subject: [PATCH] crypto: picoxcell - Fix error handling in spacc_probe()
Date: Sat, 20 Jan 2018 00:53:15 +0300
Message-ID: <1516398795-9018-1-git-send-email-khoroshilov@ispras.ru>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
To: Jamie Iles <jamie@jamieiles.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.ispras.ru ([83.149.199.45]:33740 "EHLO mail.ispras.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756461AbeASVxb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Jan 2018 16:53:31 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

If clk_get() fails, device_remove_file() looks inappropriate.

The error path, where all crypto_register fail, misses resource
deallocations.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/crypto/picoxcell_crypto.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/picoxcell_crypto.c b/drivers/crypto/picoxcell_crypto.c
index 5a6dc53b2b9d..4ef52c9d72fc 100644
--- a/drivers/crypto/picoxcell_crypto.c
+++ b/drivers/crypto/picoxcell_crypto.c
@@ -1618,7 +1618,7 @@ MODULE_DEVICE_TABLE(of, spacc_of_id_table);
 
 static int spacc_probe(struct platform_device *pdev)
 {
-	int i, err, ret = -EINVAL;
+	int i, err, ret;
 	struct resource *mem, *irq;
 	struct device_node *np = pdev->dev.of_node;
 	struct spacc_engine *engine = devm_kzalloc(&pdev->dev, sizeof(*engine),
@@ -1679,22 +1679,18 @@ static int spacc_probe(struct platform_device *pdev)
 	engine->clk = clk_get(&pdev->dev, "ref");
 	if (IS_ERR(engine->clk)) {
 		dev_info(&pdev->dev, "clk unavailable\n");
-		device_remove_file(&pdev->dev, &dev_attr_stat_irq_thresh);
 		return PTR_ERR(engine->clk);
 	}
 
 	if (clk_prepare_enable(engine->clk)) {
 		dev_info(&pdev->dev, "unable to prepare/enable clk\n");
-		clk_put(engine->clk);
-		return -EIO;
+		ret = -EIO;
+		goto err_clk_put;
 	}
 
-	err = device_create_file(&pdev->dev, &dev_attr_stat_irq_thresh);
-	if (err) {
-		clk_disable_unprepare(engine->clk);
-		clk_put(engine->clk);
-		return err;
-	}
+	ret = device_create_file(&pdev->dev, &dev_attr_stat_irq_thresh);
+	if (ret)
+		goto err_clk_disable;
 
 
 	/*
@@ -1725,6 +1721,7 @@ static int spacc_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, engine);
 
+	ret = -EINVAL;
 	INIT_LIST_HEAD(&engine->registered_algs);
 	for (i = 0; i < engine->num_algs; ++i) {
 		engine->algs[i].engine = engine;
@@ -1759,6 +1756,16 @@ static int spacc_probe(struct platform_device *pdev)
 				engine->aeads[i].alg.base.cra_name);
 	}
 
+	if (!ret)
+		return 0;
+
+	del_timer_sync(&engine->packet_timeout);
+	device_remove_file(&pdev->dev, &dev_attr_stat_irq_thresh);
+err_clk_disable:
+	clk_disable_unprepare(engine->clk);
+err_clk_put:
+	clk_put(engine->clk);
+
 	return ret;
 }
 
-- 
2.7.4
