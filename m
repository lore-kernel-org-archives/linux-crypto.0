From: Tero Kristo <t-kristo@ti.com>
Subject: [PATCH 15/28] crypto: omap-des: fix crypto engine initialization order
Date: Wed, 1 Jun 2016 11:56:16 +0300
Message-ID: <1464771389-10640-16-git-send-email-t-kristo@ti.com>
References: <1464771389-10640-1-git-send-email-t-kristo@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-arm-kernel@lists.infradead.org>, <lokeshvutla@ti.com>,
	Tero Kristo <t-kristo@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<tony@atomide.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([198.47.19.11]:50181 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751415AbcFAI6Q (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 1 Jun 2016 04:58:16 -0400
In-Reply-To: <1464771389-10640-1-git-send-email-t-kristo@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The crypto engine must be initialized before registering algorithms,
otherwise the test manager will crash as it attempts to execute
tests for the algos while they are being registered.

Fixes: f1b77aaca85a ("crypto: omap-des - Integrate with the crypto engine framework")
Signed-off-by: Tero Kristo <t-kristo@ti.com>
---
 drivers/crypto/omap-des.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
index e4c87bc..f5bf0d1 100644
--- a/drivers/crypto/omap-des.c
+++ b/drivers/crypto/omap-des.c
@@ -1079,6 +1079,17 @@ static int omap_des_probe(struct platform_device *pdev)
 	list_add_tail(&dd->list, &dev_list);
 	spin_unlock(&list_lock);
 
+	/* Initialize des crypto engine */
+	dd->engine = crypto_engine_alloc_init(dev, 1);
+	if (!dd->engine)
+		goto err_engine;
+
+	dd->engine->prepare_request = omap_des_prepare_req;
+	dd->engine->crypt_one_request = omap_des_crypt_req;
+	err = crypto_engine_start(dd->engine);
+	if (err)
+		goto err_engine;
+
 	for (i = 0; i < dd->pdata->algs_info_size; i++) {
 		for (j = 0; j < dd->pdata->algs_info[i].size; j++) {
 			algp = &dd->pdata->algs_info[i].algs_list[j];
@@ -1094,27 +1105,18 @@ static int omap_des_probe(struct platform_device *pdev)
 		}
 	}
 
-	/* Initialize des crypto engine */
-	dd->engine = crypto_engine_alloc_init(dev, 1);
-	if (!dd->engine)
-		goto err_algs;
-
-	dd->engine->prepare_request = omap_des_prepare_req;
-	dd->engine->crypt_one_request = omap_des_crypt_req;
-	err = crypto_engine_start(dd->engine);
-	if (err)
-		goto err_engine;
-
 	return 0;
 
-err_engine:
-	crypto_engine_exit(dd->engine);
 err_algs:
 	for (i = dd->pdata->algs_info_size - 1; i >= 0; i--)
 		for (j = dd->pdata->algs_info[i].registered - 1; j >= 0; j--)
 			crypto_unregister_alg(
 					&dd->pdata->algs_info[i].algs_list[j]);
 
+err_engine:
+	if (dd->engine)
+		crypto_engine_exit(dd->engine);
+
 	omap_des_dma_cleanup(dd);
 err_irq:
 	tasklet_kill(&dd->done_task);
-- 
1.9.1
