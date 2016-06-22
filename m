From: Tero Kristo <t-kristo@ti.com>
Subject: [PATCHv2 13/27] crypto: omap-aes: fix crypto engine initialization order
Date: Wed, 22 Jun 2016 16:23:46 +0300
Message-ID: <1466601840-18486-14-git-send-email-t-kristo@ti.com>
References: <1466601840-18486-1-git-send-email-t-kristo@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-arm-kernel@lists.infradead.org>
To: <linux-omap@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<tony@atomide.com>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>, <lokeshvutla@ti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:41161 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752389AbcFVNZ3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jun 2016 09:25:29 -0400
In-Reply-To: <1466601840-18486-1-git-send-email-t-kristo@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The crypto engine must be initialized before registering algorithms,
otherwise the test manager will crash as it attempts to execute
tests for the algos while they are being registered.

Fixes: 0529900a01cb ("crypto: omap-aes - Support crypto engine framework")
Signed-off-by: Tero Kristo <t-kristo@ti.com>
---
 drivers/crypto/omap-aes.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index 867e56a..2d0978a 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -1204,6 +1204,17 @@ static int omap_aes_probe(struct platform_device *pdev)
 	list_add_tail(&dd->list, &dev_list);
 	spin_unlock(&list_lock);
 
+	/* Initialize crypto engine */
+	dd->engine = crypto_engine_alloc_init(dev, 1);
+	if (!dd->engine)
+		goto err_engine;
+
+	dd->engine->prepare_request = omap_aes_prepare_req;
+	dd->engine->crypt_one_request = omap_aes_crypt_req;
+	err = crypto_engine_start(dd->engine);
+	if (err)
+		goto err_engine;
+
 	for (i = 0; i < dd->pdata->algs_info_size; i++) {
 		if (!dd->pdata->algs_info[i].registered) {
 			for (j = 0; j < dd->pdata->algs_info[i].size; j++) {
@@ -1221,26 +1232,17 @@ static int omap_aes_probe(struct platform_device *pdev)
 		}
 	}
 
-	/* Initialize crypto engine */
-	dd->engine = crypto_engine_alloc_init(dev, 1);
-	if (!dd->engine)
-		goto err_algs;
-
-	dd->engine->prepare_request = omap_aes_prepare_req;
-	dd->engine->crypt_one_request = omap_aes_crypt_req;
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
 	omap_aes_dma_cleanup(dd);
 err_irq:
 	tasklet_kill(&dd->done_task);
-- 
1.9.1
