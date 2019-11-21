Return-Path: <SRS0=AlHk=ZN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84FF7C432C0
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Nov 2019 10:16:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 593362073F
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Nov 2019 10:16:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="AqW9t2yj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727142AbfKUKQ2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Nov 2019 05:16:28 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:33384 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727125AbfKUKQ1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Nov 2019 05:16:27 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id xALAGEIi026633;
        Thu, 21 Nov 2019 04:16:14 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1574331374;
        bh=EeSIzZP6KADvh/f9LO5V0lquKd/w+xeZwK/dgc5hXNE=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=AqW9t2yjijXuUy2mcWi28Ldp2oswwej1CG0cB5ACOJngz+xK07GTKQT2NEdAIqral
         PDdOh3Y+wn03XMf1tDuDpnN9/vl2Jb+els2MJOi2qVb3IjQUbJeFPw1MMowVFOgi8p
         1k5p7fs1byhnPBUCuTPYtIBuKmssMDp8r7Lj44e0=
Received: from DLEE107.ent.ti.com (dlee107.ent.ti.com [157.170.170.37])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id xALAGExM019076
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 21 Nov 2019 04:16:14 -0600
Received: from DLEE115.ent.ti.com (157.170.170.26) by DLEE107.ent.ti.com
 (157.170.170.37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Thu, 21
 Nov 2019 04:16:14 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Thu, 21 Nov 2019 04:16:13 -0600
Received: from feketebors.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id xALAG3b7105173;
        Thu, 21 Nov 2019 04:16:11 -0600
From:   Peter Ujfalusi <peter.ujfalusi@ti.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <nicolas.ferre@microchip.com>, <alexandre.belloni@bootlin.com>,
        <ludovic.desroches@microchip.com>
CC:     <vkoul@kernel.org>, <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 3/3] crypto: atmel-tdes - Retire dma_request_slave_channel_compat()
Date:   Thu, 21 Nov 2019 12:16:02 +0200
Message-ID: <20191121101602.21941-4-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191121101602.21941-1-peter.ujfalusi@ti.com>
References: <20191121101602.21941-1-peter.ujfalusi@ti.com>
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
index bb7c0a387c04..fbc76edaef3e 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -703,31 +703,17 @@ static int atmel_tdes_crypt(struct skcipher_request *req, unsigned long mode)
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
@@ -740,10 +726,11 @@ static int atmel_tdes_dma_init(struct atmel_tdes_dev *dd,
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
@@ -761,8 +748,9 @@ static int atmel_tdes_dma_init(struct atmel_tdes_dev *dd,
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
@@ -1193,12 +1181,6 @@ static struct crypto_platform_data *atmel_tdes_of_init(struct platform_device *p
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
@@ -1292,10 +1274,7 @@ static int atmel_tdes_probe(struct platform_device *pdev)
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

