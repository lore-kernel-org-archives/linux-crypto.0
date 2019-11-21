Return-Path: <SRS0=AlHk=ZN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E4C3C43215
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Nov 2019 07:27:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 270382089F
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Nov 2019 07:27:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="mCpZyDZv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbfKUH1t (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Nov 2019 02:27:49 -0500
Received: from lelv0142.ext.ti.com ([198.47.23.249]:46102 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727047AbfKUH1q (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Nov 2019 02:27:46 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id xAL7RUiO121185;
        Thu, 21 Nov 2019 01:27:30 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1574321250;
        bh=avftAO4KNvNoNRnpg3sOK4jR51D3tqR6xIXLBziuwm4=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=mCpZyDZvfCGTIzoWPtVWDzd/XcwuhhgyfatJ71YIw2A08zGYBfbsHvqg/ygBnziSy
         wYnHN1xcpFE2ROUvGff8vSH37e/o/2DaB9+NK3hENqkcTj2xygch2uefBMdUz7Shtt
         XHDslgQY30nvqlK1pfqjE3fHX8ndLEQip6hbGzAw=
Received: from DLEE105.ent.ti.com (dlee105.ent.ti.com [157.170.170.35])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id xAL7RUQK006777
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 21 Nov 2019 01:27:30 -0600
Received: from DLEE103.ent.ti.com (157.170.170.33) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Thu, 21
 Nov 2019 01:27:29 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Thu, 21 Nov 2019 01:27:29 -0600
Received: from feketebors.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id xAL7RNTr079857;
        Thu, 21 Nov 2019 01:27:26 -0600
From:   Peter Ujfalusi <peter.ujfalusi@ti.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <nicolas.ferre@microchip.com>, <alexandre.belloni@bootlin.com>,
        <ludovic.desroches@microchip.com>
CC:     <vkoul@kernel.org>, <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] crypto: atmel-aes - Retire dma_request_slave_channel_compat()
Date:   Thu, 21 Nov 2019 09:27:21 +0200
Message-ID: <20191121072723.28479-2-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191121072723.28479-1-peter.ujfalusi@ti.com>
References: <20191121072723.28479-1-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The driver no longer boots in legacy mode, only via DT. This makes the
dma_request_slave_channel_compat() redundant.
If ever the filter function would be executed it will return false as the
dma_slave is not really initialized.

Switch to use dma_request_chan() which would allow legacy boot if ever
needed again by configuring dma_slave_map for the DMA driver.

At the same time skip allocating memory for dma_slave as it is not used
anymore.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/crypto/atmel-aes.c | 50 ++++++++------------------------------
 1 file changed, 10 insertions(+), 40 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index f24af212260b..363a2f3b1e9e 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -37,7 +37,6 @@
 #include <crypto/xts.h>
 #include <crypto/internal/aead.h>
 #include <linux/platform_data/crypto-atmel.h>
-#include <dt-bindings/dma/at91.h>
 #include "atmel-aes-regs.h"
 #include "atmel-authenc.h"
 
@@ -2381,39 +2380,23 @@ static void atmel_aes_buff_cleanup(struct atmel_aes_dev *dd)
 	free_page((unsigned long)dd->buf);
 }
 
-static bool atmel_aes_filter(struct dma_chan *chan, void *slave)
-{
-	struct at_dma_slave	*sl = slave;
-
-	if (sl && sl->dma_dev == chan->device->dev) {
-		chan->private = sl;
-		return true;
-	} else {
-		return false;
-	}
-}
-
 static int atmel_aes_dma_init(struct atmel_aes_dev *dd,
 			      struct crypto_platform_data *pdata)
 {
-	struct at_dma_slave *slave;
-	dma_cap_mask_t mask;
-
-	dma_cap_zero(mask);
-	dma_cap_set(DMA_SLAVE, mask);
+	int ret;
 
 	/* Try to grab 2 DMA channels */
-	slave = &pdata->dma_slave->rxdata;
-	dd->src.chan = dma_request_slave_channel_compat(mask, atmel_aes_filter,
-							slave, dd->dev, "tx");
-	if (!dd->src.chan)
+	dd->src.chan = dma_request_chan(dd->dev, "tx");
+	if (IS_ERR(dd->src.chan)) {
+		ret = PTR_ERR(dd->src.chan);
 		goto err_dma_in;
+	}
 
-	slave = &pdata->dma_slave->txdata;
-	dd->dst.chan = dma_request_slave_channel_compat(mask, atmel_aes_filter,
-							slave, dd->dev, "rx");
-	if (!dd->dst.chan)
+	dd->dst.chan = dma_request_chan(dd->dev, "rx");
+	if (IS_ERR(dd->dst.chan)) {
+		ret = PTR_ERR(dd->dst.chan);
 		goto err_dma_out;
+	}
 
 	return 0;
 
@@ -2421,7 +2404,7 @@ static int atmel_aes_dma_init(struct atmel_aes_dev *dd,
 	dma_release_channel(dd->src.chan);
 err_dma_in:
 	dev_warn(dd->dev, "no DMA channel available\n");
-	return -ENODEV;
+	return ret;
 }
 
 static void atmel_aes_dma_cleanup(struct atmel_aes_dev *dd)
@@ -2609,14 +2592,6 @@ static struct crypto_platform_data *atmel_aes_of_init(struct platform_device *pd
 	if (!pdata)
 		return ERR_PTR(-ENOMEM);
 
-	pdata->dma_slave = devm_kzalloc(&pdev->dev,
-					sizeof(*(pdata->dma_slave)),
-					GFP_KERNEL);
-	if (!pdata->dma_slave) {
-		devm_kfree(&pdev->dev, pdata);
-		return ERR_PTR(-ENOMEM);
-	}
-
 	return pdata;
 }
 #else
@@ -2643,11 +2618,6 @@ static int atmel_aes_probe(struct platform_device *pdev)
 		}
 	}
 
-	if (!pdata->dma_slave) {
-		err = -ENXIO;
-		goto aes_dd_err;
-	}
-
 	aes_dd = devm_kzalloc(&pdev->dev, sizeof(*aes_dd), GFP_KERNEL);
 	if (aes_dd == NULL) {
 		err = -ENOMEM;
-- 
Peter

Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki.
Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki

