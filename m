From: Sonic Zhang <sonic.adi@gmail.com>
Subject: [PATCH v2 1/2] crypto: bfin_crc: ignore duplicated registration of the same algorithm
Date: Fri, 11 Apr 2014 13:10:24 +0800
Message-ID: <1397193024-17802-1-git-send-email-sonic.adi@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>,
	<adi-buildroot-devel@lists.sourceforge.net>,
	Sonic Zhang <sonic.zhang@analog.com>
To: Marek Vasut <marex@denx.de>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:8738 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755130AbaDKFIi (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 11 Apr 2014 01:08:38 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Sonic Zhang <sonic.zhang@analog.com>

in case of multiple crc devices are probed.
Call platform_set_drvdata() before adding new CRC device into the list.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
---
v2-chagnes:
- check the CRC list and avoid call crypto_register_ahash() if not empty
- move platform_set_drvdata() before adding CRC device into the list

 drivers/crypto/bfin_crc.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/bfin_crc.c b/drivers/crypto/bfin_crc.c
index cea3e8c..7154d68 100644
--- a/drivers/crypto/bfin_crc.c
+++ b/drivers/crypto/bfin_crc.c
@@ -665,20 +665,23 @@ static int bfin_crypto_crc_probe(struct platform_device *pdev)
 	if (timeout == 0)
 		dev_info(&pdev->dev, "init crc poly timeout\n");
 
+	platform_set_drvdata(pdev, crc);
+
 	spin_lock(&crc_list.lock);
-	list_add(&crc->list, &crc_list.dev_list);
-	spin_unlock(&crc_list.lock);
 
-	platform_set_drvdata(pdev, crc);
+	if (list_empty(&crc_list.dev_list)) {
+		list_add(&crc->list, &crc_list.dev_list);
+		ret = crypto_register_ahash(&algs);
+		if (ret) {
+			spin_unlock(&crc_list.lock);
+			dev_err(&pdev->dev,
+				"Cann't register crypto ahash device\n");
+			goto out_error_dma;
+		}
+	} else
+		list_add(&crc->list, &crc_list.dev_list);
 
-	ret = crypto_register_ahash(&algs);
-	if (ret) {
-		spin_lock(&crc_list.lock);
-		list_del(&crc->list);
-		spin_unlock(&crc_list.lock);
-		dev_err(&pdev->dev, "Cann't register crypto ahash device\n");
-		goto out_error_dma;
-	}
+	spin_unlock(&crc_list.lock);
 
 	dev_info(&pdev->dev, "initialized\n");
 
-- 
1.8.2.3
