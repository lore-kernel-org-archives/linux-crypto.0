From: Tero Kristo <t-kristo@ti.com>
Subject: [PATCHv3 11/11] crypto: omap-des: fix crypto engine initialization order
Date: Thu, 4 Aug 2016 13:28:46 +0300
Message-ID: <1470306526-27219-12-git-send-email-t-kristo@ti.com>
References: <1470306526-27219-1-git-send-email-t-kristo@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-arm-kernel@lists.infradead.org>
To: <herbert@gondor.apana.org.au>, <lokeshvutla@ti.com>,
	<davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
	<tony@atomide.com>, <linux-omap@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:50519 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754644AbcHDKaV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Aug 2016 06:30:21 -0400
In-Reply-To: <1470306526-27219-1-git-send-email-t-kristo@ti.com>
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
index d0b59f6..2b07e60 100644
--- a/drivers/crypto/omap-des.c
+++ b/drivers/crypto/omap-des.c
@@ -1085,6 +1085,17 @@ static int omap_des_probe(struct platform_device *pdev)
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
@@ -1100,27 +1111,18 @@ static int omap_des_probe(struct platform_device *pdev)
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
