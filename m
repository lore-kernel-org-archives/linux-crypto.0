From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH] crypto: atmel: Delete error messages for a failed memory
 allocation in six functions
Date: Thu, 15 Feb 2018 13:24:18 +0100
Message-ID: <77cf1006-966d-78a9-0fdc-b53ccdd80df2@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
To: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Language: en-US
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 15 Feb 2018 11:38:30 +0100

Omit extra messages for a memory allocation failure in these functions.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/crypto/atmel-aes.c  | 6 +-----
 drivers/crypto/atmel-sha.c  | 9 ++-------
 drivers/crypto/atmel-tdes.c | 9 ++-------
 3 files changed, 5 insertions(+), 19 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 691c6465b71e..6fb24fc94b1f 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -2602,16 +2602,13 @@ static struct crypto_platform_data *atmel_aes_of_init(struct platform_device *pd
 	}
 
 	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
-	if (!pdata) {
-		dev_err(&pdev->dev, "could not allocate memory for pdata\n");
+	if (!pdata)
 		return ERR_PTR(-ENOMEM);
-	}
 
 	pdata->dma_slave = devm_kzalloc(&pdev->dev,
 					sizeof(*(pdata->dma_slave)),
 					GFP_KERNEL);
 	if (!pdata->dma_slave) {
-		dev_err(&pdev->dev, "could not allocate memory for dma_slave\n");
 		devm_kfree(&pdev->dev, pdata);
 		return ERR_PTR(-ENOMEM);
 	}
@@ -2649,7 +2646,6 @@ static int atmel_aes_probe(struct platform_device *pdev)
 
 	aes_dd = devm_kzalloc(&pdev->dev, sizeof(*aes_dd), GFP_KERNEL);
 	if (aes_dd == NULL) {
-		dev_err(dev, "unable to alloc data struct.\n");
 		err = -ENOMEM;
 		goto aes_dd_err;
 	}
diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index 8874aa5ca0f7..4d43081120db 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -2726,18 +2726,14 @@ static struct crypto_platform_data *atmel_sha_of_init(struct platform_device *pd
 	}
 
 	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
-	if (!pdata) {
-		dev_err(&pdev->dev, "could not allocate memory for pdata\n");
+	if (!pdata)
 		return ERR_PTR(-ENOMEM);
-	}
 
 	pdata->dma_slave = devm_kzalloc(&pdev->dev,
 					sizeof(*(pdata->dma_slave)),
 					GFP_KERNEL);
-	if (!pdata->dma_slave) {
-		dev_err(&pdev->dev, "could not allocate memory for dma_slave\n");
+	if (!pdata->dma_slave)
 		return ERR_PTR(-ENOMEM);
-	}
 
 	return pdata;
 }
@@ -2758,7 +2754,6 @@ static int atmel_sha_probe(struct platform_device *pdev)
 
 	sha_dd = devm_kzalloc(&pdev->dev, sizeof(*sha_dd), GFP_KERNEL);
 	if (sha_dd == NULL) {
-		dev_err(dev, "unable to alloc data struct.\n");
 		err = -ENOMEM;
 		goto sha_dd_err;
 	}
diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index 592124f8382b..97b0423efa7f 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -1312,18 +1312,14 @@ static struct crypto_platform_data *atmel_tdes_of_init(struct platform_device *p
 	}
 
 	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
-	if (!pdata) {
-		dev_err(&pdev->dev, "could not allocate memory for pdata\n");
+	if (!pdata)
 		return ERR_PTR(-ENOMEM);
-	}
 
 	pdata->dma_slave = devm_kzalloc(&pdev->dev,
 					sizeof(*(pdata->dma_slave)),
 					GFP_KERNEL);
-	if (!pdata->dma_slave) {
-		dev_err(&pdev->dev, "could not allocate memory for dma_slave\n");
+	if (!pdata->dma_slave)
 		return ERR_PTR(-ENOMEM);
-	}
 
 	return pdata;
 }
@@ -1344,7 +1340,6 @@ static int atmel_tdes_probe(struct platform_device *pdev)
 
 	tdes_dd = devm_kmalloc(&pdev->dev, sizeof(*tdes_dd), GFP_KERNEL);
 	if (tdes_dd == NULL) {
-		dev_err(dev, "unable to alloc data struct.\n");
 		err = -ENOMEM;
 		goto tdes_dd_err;
 	}
-- 
2.16.1

