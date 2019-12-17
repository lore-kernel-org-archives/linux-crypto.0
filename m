Return-Path: <SRS0=akto=2H=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E80AC43603
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Dec 2019 07:33:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 057F32146E
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Dec 2019 07:33:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="Q4wIdNlR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbfLQHdP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Dec 2019 02:33:15 -0500
Received: from lelv0142.ext.ti.com ([198.47.23.249]:53160 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbfLQHdP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Dec 2019 02:33:15 -0500
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id xBH7WqUl004981;
        Tue, 17 Dec 2019 01:32:52 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1576567972;
        bh=eSQ2dhkByo6FgeZrI6vTF+HFoYKLR2l6HPaoPta+Z3I=;
        h=From:To:CC:Subject:Date;
        b=Q4wIdNlR+Ewu19kOFNosgMC1SS0Y3tRYcj6Hu/+9kipLxunNJVii3JMZSSeX8KJIt
         CouoVv1wMm96V786m6idYYUoeLxv7j+ZlDWiL0ItcYvF9LKlt5ocFjVgzDL9YgsWzY
         tzRiDAh6tnWbXPRn+tcds7pygefMmdnAk0CBKRI4=
Received: from DLEE105.ent.ti.com (dlee105.ent.ti.com [157.170.170.35])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id xBH7WqwJ128240;
        Tue, 17 Dec 2019 01:32:52 -0600
Received: from DLEE110.ent.ti.com (157.170.170.21) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Tue, 17
 Dec 2019 01:32:51 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE110.ent.ti.com
 (157.170.170.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Tue, 17 Dec 2019 01:32:51 -0600
Received: from feketebors.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id xBH7WnRn081690;
        Tue, 17 Dec 2019 01:32:50 -0600
From:   Peter Ujfalusi <peter.ujfalusi@ti.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <vkoul@kernel.org>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] crypto: img-hash - Use dma_request_chan instead dma_request_slave_channel
Date:   Tue, 17 Dec 2019 09:33:05 +0200
Message-ID: <20191217073305.20492-1-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

dma_request_slave_channel() is a wrapper on top of dma_request_chan()
eating up the error code.

By using dma_request_chan() directly the driver can support deferred
probing against DMA.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/crypto/img-hash.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/img-hash.c b/drivers/crypto/img-hash.c
index fe4cc8babe1c..25d5227f74a1 100644
--- a/drivers/crypto/img-hash.c
+++ b/drivers/crypto/img-hash.c
@@ -332,10 +332,10 @@ static int img_hash_dma_init(struct img_hash_dev *hdev)
 	struct dma_slave_config dma_conf;
 	int err = -EINVAL;
 
-	hdev->dma_lch = dma_request_slave_channel(hdev->dev, "tx");
-	if (!hdev->dma_lch) {
+	hdev->dma_lch = dma_request_chan(hdev->dev, "tx");
+	if (IS_ERR(hdev->dma_lch)) {
 		dev_err(hdev->dev, "Couldn't acquire a slave DMA channel.\n");
-		return -EBUSY;
+		return PTR_ERR(hdev->dma_lch);
 	}
 	dma_conf.direction = DMA_MEM_TO_DEV;
 	dma_conf.dst_addr = hdev->bus_addr;
-- 
Peter

Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki.
Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki

