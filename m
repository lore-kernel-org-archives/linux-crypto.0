From: Fabio Estevam <festevam@gmail.com>
Subject: [PATCH 1/2] crypto: mxs-dcp: Use devm_kzalloc()
Date: Tue, 28 Jan 2014 22:36:11 -0200
Message-ID: <1390955772-6936-1-git-send-email-festevam@gmail.com>
Cc: marex@denx.de, linux-crypto@vger.kernel.org,
	Fabio Estevam <fabio.estevam@freescale.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yk0-f176.google.com ([209.85.160.176]:50846 "EHLO
	mail-yk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026AbaA2Aoe (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 28 Jan 2014 19:44:34 -0500
Received: by mail-yk0-f176.google.com with SMTP id 131so5389548ykp.7
        for <linux-crypto@vger.kernel.org>; Tue, 28 Jan 2014 16:44:33 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@freescale.com>

Using devm_kzalloc() can make the code cleaner.

While at it, remove the devm_kzalloc error message as there is standard OOM
message done by the core.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/crypto/mxs-dcp.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
index a6db7fa..2d7d497 100644
--- a/drivers/crypto/mxs-dcp.c
+++ b/drivers/crypto/mxs-dcp.c
@@ -935,9 +935,8 @@ static int mxs_dcp_probe(struct platform_device *pdev)
 	}
 
 	/* Allocate coherent helper block. */
-	sdcp->coh = kzalloc(sizeof(struct dcp_coherent_block), GFP_KERNEL);
+	sdcp->coh = devm_kzalloc(dev, sizeof(*sdcp->coh), GFP_KERNEL);
 	if (!sdcp->coh) {
-		dev_err(dev, "Error allocating coherent block\n");
 		ret = -ENOMEM;
 		goto err_mutex;
 	}
@@ -982,7 +981,7 @@ static int mxs_dcp_probe(struct platform_device *pdev)
 	if (IS_ERR(sdcp->thread[DCP_CHAN_HASH_SHA])) {
 		dev_err(dev, "Error starting SHA thread!\n");
 		ret = PTR_ERR(sdcp->thread[DCP_CHAN_HASH_SHA]);
-		goto err_free_coherent;
+		goto err_mutex;
 	}
 
 	sdcp->thread[DCP_CHAN_CRYPTO] = kthread_run(dcp_chan_thread_aes,
@@ -1040,8 +1039,6 @@ err_destroy_aes_thread:
 err_destroy_sha_thread:
 	kthread_stop(sdcp->thread[DCP_CHAN_HASH_SHA]);
 
-err_free_coherent:
-	kfree(sdcp->coh);
 err_mutex:
 	mutex_unlock(&global_mutex);
 	return ret;
@@ -1051,8 +1048,6 @@ static int mxs_dcp_remove(struct platform_device *pdev)
 {
 	struct dcp *sdcp = platform_get_drvdata(pdev);
 
-	kfree(sdcp->coh);
-
 	if (sdcp->caps & MXS_DCP_CAPABILITY1_SHA256)
 		crypto_unregister_ahash(&dcp_sha256_alg);
 
-- 
1.8.1.2
