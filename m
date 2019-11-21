Return-Path: <SRS0=AlHk=ZN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE535C432C0
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Nov 2019 07:27:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A7030208C0
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Nov 2019 07:27:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="LyrJZ7l5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727106AbfKUH1s (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Nov 2019 02:27:48 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:50826 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727099AbfKUH1r (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Nov 2019 02:27:47 -0500
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id xAL7RYMn081649;
        Thu, 21 Nov 2019 01:27:34 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1574321254;
        bh=RcakxV3bAZDzJDpxzPCwkMvlEl/J6Nybe5yk/wSebPw=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=LyrJZ7l5EFx4+cBCDrc/0Y9TB6hzkinL+YsqSDleFRTXSO0RH/YA8xbG3okajL2y8
         WOddJlxOJfvTcUKwv9QKnH2lttt81nuzCmxLXFZfL/9nDYxk4oLduo1S/jqB0vdPtm
         rKO0gouc0UrNrjIHDq99JRUANZF3ruYCyCNqOK1o=
Received: from DFLE100.ent.ti.com (dfle100.ent.ti.com [10.64.6.21])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id xAL7RYGN013855
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 21 Nov 2019 01:27:34 -0600
Received: from DFLE103.ent.ti.com (10.64.6.24) by DFLE100.ent.ti.com
 (10.64.6.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Thu, 21
 Nov 2019 01:27:34 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Thu, 21 Nov 2019 01:27:34 -0600
Received: from feketebors.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id xAL7RNTt079857;
        Thu, 21 Nov 2019 01:27:31 -0600
From:   Peter Ujfalusi <peter.ujfalusi@ti.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <nicolas.ferre@microchip.com>, <alexandre.belloni@bootlin.com>,
        <ludovic.desroches@microchip.com>
CC:     <vkoul@kernel.org>, <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] crypto: atmel-tdes - Retire dma_request_slave_channel_compat()
Date:   Thu, 21 Nov 2019 09:27:23 +0200
Message-ID: <20191121072723.28479-4-peter.ujfalusi@ti.com>
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
 drivers/crypto/atmel-tdes.c | 47 ++++++++++---------------------------
 1 file changed, 13 insertions(+), 34 deletions(-)

diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index 1a6c86ae6148..44fdc7456769 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -702,31 +702,17 @@ static int atmel_tdes_crypt(struct ablkcipher_request *req, unsigned long mode)
 	return atmel_tdes_handle_queue(ctx->dd, req);
 }
 
-static bool atmel_tdes_filter(struct dma_chan *chan, void *slave)
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
 static int atmel_tdes_dma_init(struct atmel_tdes_dev *dd,
 			struct crypto_platform_data *pdata)
 {
-	dma_cap_mask_t mask;
-
-	dma_cap_zero(mask);
-	dma_cap_set(DMA_SLAVE, mask);
+	int ret;
 
 	/* Try to grab 2 DMA channels */
-	dd->dma_lch_in.chan = dma_request_slave_channel_compat(mask,
-			atmel_tdes_filter, &pdata->dma_slave->rxdata, dd->dev, "tx");
-	if (!dd->dma_lch_in.chan)
+	dd->dma_lch_in.chan = dma_request_chan(dd->dev, "tx");
+	if (IS_ERR(dd->dma_lch_in.chan)) {
+		ret = PTR_ERR(dd->dma_lch_in.chan);
 		goto err_dma_in;
+	}
 
 	dd->dma_lch_in.dma_conf.direction = DMA_MEM_TO_DEV;
 	dd->dma_lch_in.dma_conf.dst_addr = dd->phys_base +
@@ -739,10 +725,11 @@ static int atmel_tdes_dma_init(struct atmel_tdes_dev *dd,
 		DMA_SLAVE_BUSWIDTH_4_BYTES;
 	dd->dma_lch_in.dma_conf.device_fc = false;
 
-	dd->dma_lch_out.chan = dma_request_slave_channel_compat(mask,
-			atmel_tdes_filter, &pdata->dma_slave->txdata, dd->dev, "rx");
-	if (!dd->dma_lch_out.chan)
+	dd->dma_lch_out.chan = dma_request_chan(dd->dev, "rx");
+	if (IS_ERR(dd->dma_lch_out.chan)) {
+		ret = PTR_ERR(dd->dma_lch_out.chan);
 		goto err_dma_out;
+	}
 
 	dd->dma_lch_out.dma_conf.direction = DMA_DEV_TO_MEM;
 	dd->dma_lch_out.dma_conf.src_addr = dd->phys_base +
@@ -760,8 +747,9 @@ static int atmel_tdes_dma_init(struct atmel_tdes_dev *dd,
 err_dma_out:
 	dma_release_channel(dd->dma_lch_in.chan);
 err_dma_in:
-	dev_warn(dd->dev, "no DMA channel available\n");
-	return -ENODEV;
+	if (ret != -EPROBE_DEFER)
+		dev_warn(dd->dev, "no DMA channel available\n");
+	return ret;
 }
 
 static void atmel_tdes_dma_cleanup(struct atmel_tdes_dev *dd)
@@ -1212,12 +1200,6 @@ static struct crypto_platform_data *atmel_tdes_of_init(struct platform_device *p
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
@@ -1311,10 +1293,7 @@ static int atmel_tdes_probe(struct platform_device *pdev)
 				goto err_pdata;
 			}
 		}
-		if (!pdata->dma_slave) {
-			err = -ENXIO;
-			goto err_pdata;
-		}
+
 		err = atmel_tdes_dma_init(tdes_dd, pdata);
 		if (err)
 			goto err_tdes_dma;
-- 
Peter

Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki.
Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki

