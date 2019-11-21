Return-Path: <SRS0=AlHk=ZN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3F64C432C0
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Nov 2019 07:28:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72B6E208C0
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Nov 2019 07:28:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="IB/u1Mki"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbfKUH1s (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Nov 2019 02:27:48 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:50828 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726962AbfKUH1s (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Nov 2019 02:27:48 -0500
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id xAL7RYFr081645;
        Thu, 21 Nov 2019 01:27:34 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1574321254;
        bh=pE69mjXGRtzpdlcRpFWBhAVSwz09Tx2CA10ZtUiAstA=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=IB/u1MkiR06t8hyB7ae/x/pZ3PFrFA5LRBna9BHimQORrxNZVqwo3h7h6JBj+F/SB
         Eexs8ceoCxQ0iycEGVCJmyzT5ohJNw0MjylUFZesEoSx95A7D6B6udnQIZ2LXVVv6c
         Oxk0ynuzDakj1kBf9Vw/dYtjbXLMw4DpK1fcwOHo=
Received: from DLEE100.ent.ti.com (dlee100.ent.ti.com [157.170.170.30])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id xAL7RY84100906
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 21 Nov 2019 01:27:34 -0600
Received: from DLEE112.ent.ti.com (157.170.170.23) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Thu, 21
 Nov 2019 01:27:31 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Thu, 21 Nov 2019 01:27:31 -0600
Received: from feketebors.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id xAL7RNTs079857;
        Thu, 21 Nov 2019 01:27:29 -0600
From:   Peter Ujfalusi <peter.ujfalusi@ti.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <nicolas.ferre@microchip.com>, <alexandre.belloni@bootlin.com>,
        <ludovic.desroches@microchip.com>
CC:     <vkoul@kernel.org>, <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] crypto: atmel-sha - Retire dma_request_slave_channel_compat()
Date:   Thu, 21 Nov 2019 09:27:22 +0200
Message-ID: <20191121072723.28479-3-peter.ujfalusi@ti.com>
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
 drivers/crypto/atmel-sha.c | 39 +++++++-------------------------------
 1 file changed, 7 insertions(+), 32 deletions(-)

diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index 8ea0e4bcde0d..9d392c5ff06b 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -2608,32 +2608,16 @@ static int atmel_sha_register_algs(struct atmel_sha_dev *dd)
 	return err;
 }
 
-static bool atmel_sha_filter(struct dma_chan *chan, void *slave)
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
 static int atmel_sha_dma_init(struct atmel_sha_dev *dd,
 				struct crypto_platform_data *pdata)
 {
-	dma_cap_mask_t mask_in;
+	dd->dma_lch_in.chan = dma_request_chan(dd->dev, "tx");
+	if (IS_ERR(dd->dma_lch_in.chan)) {
+		int ret = PTR_ERR(dd->dma_lch_in.chan);
 
-	/* Try to grab DMA channel */
-	dma_cap_zero(mask_in);
-	dma_cap_set(DMA_SLAVE, mask_in);
-
-	dd->dma_lch_in.chan = dma_request_slave_channel_compat(mask_in,
-			atmel_sha_filter, &pdata->dma_slave->rxdata, dd->dev, "tx");
-	if (!dd->dma_lch_in.chan) {
-		dev_warn(dd->dev, "no DMA channel available\n");
-		return -ENODEV;
+		if (ret != -EPROBE_DEFER)
+			dev_warn(dd->dev, "no DMA channel available\n");
+		return ret;
 	}
 
 	dd->dma_lch_in.dma_conf.direction = DMA_MEM_TO_DEV;
@@ -2724,12 +2708,6 @@ static struct crypto_platform_data *atmel_sha_of_init(struct platform_device *pd
 	if (!pdata)
 		return ERR_PTR(-ENOMEM);
 
-	pdata->dma_slave = devm_kzalloc(&pdev->dev,
-					sizeof(*(pdata->dma_slave)),
-					GFP_KERNEL);
-	if (!pdata->dma_slave)
-		return ERR_PTR(-ENOMEM);
-
 	return pdata;
 }
 #else /* CONFIG_OF */
@@ -2823,10 +2801,7 @@ static int atmel_sha_probe(struct platform_device *pdev)
 				goto iclk_unprepare;
 			}
 		}
-		if (!pdata->dma_slave) {
-			err = -ENXIO;
-			goto iclk_unprepare;
-		}
+
 		err = atmel_sha_dma_init(sha_dd, pdata);
 		if (err)
 			goto err_sha_dma;
-- 
Peter

Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki.
Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki

