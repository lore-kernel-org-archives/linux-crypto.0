Return-Path: <SRS0=akto=2H=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D0E8C2D0C5
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Dec 2019 07:35:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D71EE2067C
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Dec 2019 07:35:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="UUA+YQja"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbfLQHfL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Dec 2019 02:35:11 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:51448 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbfLQHfL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Dec 2019 02:35:11 -0500
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id xBH7YsuK075971;
        Tue, 17 Dec 2019 01:34:54 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1576568094;
        bh=0FwLBx8XfykMdjHah7/EtEeo+R5IsHmwRrAh/bmn7U4=;
        h=From:To:CC:Subject:Date;
        b=UUA+YQjalhxvPMh5NdESQCFfzVRQt2XhwqSL3G3PxYYsp3oW28ySWeHVVVoE/lGba
         3bd/pHENNNi++tbecyc6j1GI45euxvXFSitWivdhI+x8nPRzhte0iRF0btn3SAdeQ1
         S2rWKAewPtsdaowSrgNsac+nJie8ugQeaU8rUIjI=
Received: from DFLE105.ent.ti.com (dfle105.ent.ti.com [10.64.6.26])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id xBH7YrYM001109;
        Tue, 17 Dec 2019 01:34:54 -0600
Received: from DFLE104.ent.ti.com (10.64.6.25) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Tue, 17
 Dec 2019 01:34:53 -0600
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Tue, 17 Dec 2019 01:34:53 -0600
Received: from feketebors.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id xBH7YoW6058420;
        Tue, 17 Dec 2019 01:34:51 -0600
From:   Peter Ujfalusi <peter.ujfalusi@ti.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <mcoquelin.stm32@gmail.com>, <alexandre.torgue@st.com>
CC:     <vkoul@kernel.org>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH] crypto: stm32/hash - Use dma_request_chan() instead dma_request_slave_channel()
Date:   Tue, 17 Dec 2019 09:35:06 +0200
Message-ID: <20191217073506.20861-1-peter.ujfalusi@ti.com>
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
 drivers/crypto/stm32/stm32-hash.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-hash.c b/drivers/crypto/stm32/stm32-hash.c
index cfc8e0e37bee..167b80eec437 100644
--- a/drivers/crypto/stm32/stm32-hash.c
+++ b/drivers/crypto/stm32/stm32-hash.c
@@ -518,10 +518,10 @@ static int stm32_hash_dma_init(struct stm32_hash_dev *hdev)
 	dma_conf.dst_maxburst = hdev->dma_maxburst;
 	dma_conf.device_fc = false;
 
-	hdev->dma_lch = dma_request_slave_channel(hdev->dev, "in");
-	if (!hdev->dma_lch) {
+	hdev->dma_lch = dma_request_chan(hdev->dev, "in");
+	if (IS_ERR(hdev->dma_lch)) {
 		dev_err(hdev->dev, "Couldn't acquire a slave DMA channel.\n");
-		return -EBUSY;
+		return PTR_ERR(hdev->dma_lch);
 	}
 
 	err = dmaengine_slave_config(hdev->dma_lch, &dma_conf);
-- 
Peter

Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki.
Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki

