From: Vaishali Thakkar <vthakkar1994@gmail.com>
Subject: [PATCH] crypto: sahara: Use dmam_alloc_coherent
Date: Tue, 18 Aug 2015 11:36:05 +0530
Message-ID: <20150818060605.GA29208@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch moves the data allocated using dma_alloc_coherent to the
corresponding managed interface. To be compatible with the change,
various gotos are replaced with direct returns and unneeded labels
are dropped.

Signed-off-by: Vaishali Thakkar <vthakkar1994@gmail.com>
---
 drivers/crypto/sahara.c | 46 +++++++++-------------------------------------
 1 file changed, 9 insertions(+), 37 deletions(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index 397a500..1c19e44 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -1516,7 +1516,7 @@ static int sahara_probe(struct platform_device *pdev)
 	}
 
 	/* Allocate HW descriptors */
-	dev->hw_desc[0] = dma_alloc_coherent(&pdev->dev,
+	dev->hw_desc[0] = dmam_alloc_coherent(&pdev->dev,
 			SAHARA_MAX_HW_DESC * sizeof(struct sahara_hw_desc),
 			&dev->hw_phys_desc[0], GFP_KERNEL);
 	if (!dev->hw_desc[0]) {
@@ -1528,34 +1528,31 @@ static int sahara_probe(struct platform_device *pdev)
 				sizeof(struct sahara_hw_desc);
 
 	/* Allocate space for iv and key */
-	dev->key_base = dma_alloc_coherent(&pdev->dev, 2 * AES_KEYSIZE_128,
+	dev->key_base = dmam_alloc_coherent(&pdev->dev, 2 * AES_KEYSIZE_128,
 				&dev->key_phys_base, GFP_KERNEL);
 	if (!dev->key_base) {
 		dev_err(&pdev->dev, "Could not allocate memory for key\n");
-		err = -ENOMEM;
-		goto err_key;
+		return -ENOMEM;
 	}
 	dev->iv_base = dev->key_base + AES_KEYSIZE_128;
 	dev->iv_phys_base = dev->key_phys_base + AES_KEYSIZE_128;
 
 	/* Allocate space for context: largest digest + message length field */
-	dev->context_base = dma_alloc_coherent(&pdev->dev,
+	dev->context_base = dmam_alloc_coherent(&pdev->dev,
 					SHA256_DIGEST_SIZE + 4,
 					&dev->context_phys_base, GFP_KERNEL);
 	if (!dev->context_base) {
 		dev_err(&pdev->dev, "Could not allocate memory for MDHA context\n");
-		err = -ENOMEM;
-		goto err_key;
+		return -ENOMEM;
 	}
 
 	/* Allocate space for HW links */
-	dev->hw_link[0] = dma_alloc_coherent(&pdev->dev,
+	dev->hw_link[0] = dmam_alloc_coherent(&pdev->dev,
 			SAHARA_MAX_HW_LINK * sizeof(struct sahara_hw_link),
 			&dev->hw_phys_link[0], GFP_KERNEL);
 	if (!dev->hw_link[0]) {
 		dev_err(&pdev->dev, "Could not allocate hw links\n");
-		err = -ENOMEM;
-		goto err_link;
+		return -ENOMEM;
 	}
 	for (i = 1; i < SAHARA_MAX_HW_LINK; i++) {
 		dev->hw_phys_link[i] = dev->hw_phys_link[i - 1] +
@@ -1572,15 +1569,14 @@ static int sahara_probe(struct platform_device *pdev)
 
 	dev->kthread = kthread_run(sahara_queue_manage, dev, "sahara_crypto");
 	if (IS_ERR(dev->kthread)) {
-		err = PTR_ERR(dev->kthread);
-		goto err_link;
+		return PTR_ERR(dev->kthread);
 	}
 
 	init_completion(&dev->dma_completion);
 
 	err = clk_prepare_enable(dev->clk_ipg);
 	if (err)
-		goto err_link;
+		return err;
 	err = clk_prepare_enable(dev->clk_ahb);
 	if (err)
 		goto clk_ipg_disable;
@@ -1620,25 +1616,11 @@ static int sahara_probe(struct platform_device *pdev)
 	return 0;
 
 err_algs:
-	dma_free_coherent(&pdev->dev,
-			  SAHARA_MAX_HW_LINK * sizeof(struct sahara_hw_link),
-			  dev->hw_link[0], dev->hw_phys_link[0]);
 	kthread_stop(dev->kthread);
 	dev_ptr = NULL;
 	clk_disable_unprepare(dev->clk_ahb);
 clk_ipg_disable:
 	clk_disable_unprepare(dev->clk_ipg);
-err_link:
-	dma_free_coherent(&pdev->dev,
-			  2 * AES_KEYSIZE_128,
-			  dev->key_base, dev->key_phys_base);
-	dma_free_coherent(&pdev->dev,
-			  SHA256_DIGEST_SIZE,
-			  dev->context_base, dev->context_phys_base);
-err_key:
-	dma_free_coherent(&pdev->dev,
-			  SAHARA_MAX_HW_DESC * sizeof(struct sahara_hw_desc),
-			  dev->hw_desc[0], dev->hw_phys_desc[0]);
 
 	return err;
 }
@@ -1647,16 +1629,6 @@ static int sahara_remove(struct platform_device *pdev)
 {
 	struct sahara_dev *dev = platform_get_drvdata(pdev);
 
-	dma_free_coherent(&pdev->dev,
-			  SAHARA_MAX_HW_LINK * sizeof(struct sahara_hw_link),
-			  dev->hw_link[0], dev->hw_phys_link[0]);
-	dma_free_coherent(&pdev->dev,
-			  2 * AES_KEYSIZE_128,
-			  dev->key_base, dev->key_phys_base);
-	dma_free_coherent(&pdev->dev,
-			  SAHARA_MAX_HW_DESC * sizeof(struct sahara_hw_desc),
-			  dev->hw_desc[0], dev->hw_phys_desc[0]);
-
 	kthread_stop(dev->kthread);
 
 	sahara_unregister_algs(dev);
-- 
1.9.1
