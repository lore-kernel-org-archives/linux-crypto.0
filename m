Return-Path: <SRS0=Oy//=6L=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 860DEC5519B
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Apr 2020 06:43:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6846A2072D
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Apr 2020 06:43:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=st.com header.i=@st.com header.b="JVZbmY8Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbgD0GnW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Apr 2020 02:43:22 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:1735 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726604AbgD0GnV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Apr 2020 02:43:21 -0400
Received: from pps.filterd (m0046660.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03R6cO6E024040;
        Mon, 27 Apr 2020 08:42:58 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=STMicroelectronics;
 bh=qTrXLMk8kkMPS+GB6wCw5fDokR6i+JUeBx7KNCnu20M=;
 b=JVZbmY8YF3kq5dC1pmWwppQKYL0W48nwqEgXn5vsvIbeHhEc+A0W+68/Iw7C9bKgryM+
 VRPjL2cVSvkuQso/VoTVX/jGsDMbWMTzC5d7oCRlzHwmHYnkEnZvXwoTDJJcj+ryLAcj
 mor5PXc40TgpjAr5K6XIB9Uux4PMFo6yE1eGG6nzCq9zsAB5Uy6NSGDug4E2BgYiFH4K
 Ns7gy5M2cR/h0SsBslll6Z9Dg0Kt1ZMzpxgwOVnEmnio0O4Rk3Iqo052ZfWAETTAW5gj
 rDb4ov6ldGUJ04MUSwfEBc9tlkk17X7eR5MZvRI/PRmbRG6VkYAgFYE8bdI6ifykuE5M 3Q== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 30mhq5r2h6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Apr 2020 08:42:58 +0200
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 6E980100039;
        Mon, 27 Apr 2020 08:42:57 +0200 (CEST)
Received: from Webmail-eu.st.com (sfhdag7node2.st.com [10.75.127.20])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 5F18521F67B;
        Mon, 27 Apr 2020 08:42:57 +0200 (CEST)
Received: from localhost (10.75.127.45) by SFHDAG7NODE2.st.com (10.75.127.20)
 with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 27 Apr 2020 08:42:56
 +0200
From:   Lionel Debieve <lionel.debieve@st.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        <linux-crypto@vger.kernel.org>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>
Subject: [PATCH 2/3] crypto: stm32/hash - defer probe for dma device
Date:   Mon, 27 Apr 2020 08:42:25 +0200
Message-ID: <20200427064226.6991-3-lionel.debieve@st.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200427064226.6991-1-lionel.debieve@st.com>
References: <20200427064226.6991-1-lionel.debieve@st.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.75.127.45]
X-ClientProxiedBy: SFHDAG7NODE3.st.com (10.75.127.21) To SFHDAG7NODE2.st.com
 (10.75.127.20)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-27_03:2020-04-24,2020-04-27 signatures=0
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Etienne Carriere <etienne.carriere@st.com>

Change stm32 HASH driver to defer its probe operation when
DMA channel device is registered but has not been probed yet.

Signed-off-by: Etienne Carriere <etienne.carriere@st.com>
Reviewed-by: Lionel DEBIEVE <lionel.debieve@st.com>
---
 drivers/crypto/stm32/stm32-hash.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-hash.c b/drivers/crypto/stm32/stm32-hash.c
index fad6190be088..0d592f55a271 100644
--- a/drivers/crypto/stm32/stm32-hash.c
+++ b/drivers/crypto/stm32/stm32-hash.c
@@ -507,6 +507,7 @@ static int stm32_hash_hmac_dma_send(struct stm32_hash_dev *hdev)
 static int stm32_hash_dma_init(struct stm32_hash_dev *hdev)
 {
 	struct dma_slave_config dma_conf;
+	struct dma_chan *chan;
 	int err;
 
 	memset(&dma_conf, 0, sizeof(dma_conf));
@@ -518,11 +519,11 @@ static int stm32_hash_dma_init(struct stm32_hash_dev *hdev)
 	dma_conf.dst_maxburst = hdev->dma_maxburst;
 	dma_conf.device_fc = false;
 
-	hdev->dma_lch = dma_request_chan(hdev->dev, "in");
-	if (IS_ERR(hdev->dma_lch)) {
-		dev_err(hdev->dev, "Couldn't acquire a slave DMA channel.\n");
-		return PTR_ERR(hdev->dma_lch);
-	}
+	chan = dma_request_chan(hdev->dev, "in");
+	if (IS_ERR(chan))
+		return PTR_ERR(chan);
+
+	hdev->dma_lch = chan;
 
 	err = dmaengine_slave_config(hdev->dma_lch, &dma_conf);
 	if (err) {
@@ -1498,8 +1499,15 @@ static int stm32_hash_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, hdev);
 
 	ret = stm32_hash_dma_init(hdev);
-	if (ret)
+	switch (ret) {
+	case 0:
+		break;
+	case -ENOENT:
 		dev_dbg(dev, "DMA mode not available\n");
+		break;
+	default:
+		goto err_dma;
+	}
 
 	spin_lock(&stm32_hash.lock);
 	list_add_tail(&hdev->list, &stm32_hash.dev_list);
@@ -1537,7 +1545,7 @@ static int stm32_hash_probe(struct platform_device *pdev)
 	spin_lock(&stm32_hash.lock);
 	list_del(&hdev->list);
 	spin_unlock(&stm32_hash.lock);
-
+err_dma:
 	if (hdev->dma_lch)
 		dma_release_channel(hdev->dma_lch);
 err_reset:
-- 
2.17.1

