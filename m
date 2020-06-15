Return-Path: <SRS0=gCBe=74=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04932C433E2
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Jun 2020 07:15:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA467206E2
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Jun 2020 07:15:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="lPPe1l1V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728236AbgFOHPV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Jun 2020 03:15:21 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:43996 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728285AbgFOHPU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Jun 2020 03:15:20 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 05F7FAqN007649;
        Mon, 15 Jun 2020 02:15:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1592205310;
        bh=4Pjny+KuuRnsOS+xKmOJ82U7+HUtDjXvTlvk8R2riW0=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=lPPe1l1VRtOAZEiGx0LlPIhpnVSur15dcwiFDKXutEwqUduoUyx6L+HmhkaYOTGnX
         KMj98PlJR4V4KVBXmt3MX3SlqqEMlqjdTwVhKf1C4kOIW2NTUfoa839dd6ntwuac+n
         Wz3pmJ4RoS9QQ0XPrsathJ8OBLpcHxefYZHuO6rQ=
Received: from DLEE100.ent.ti.com (dlee100.ent.ti.com [157.170.170.30])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 05F7FAKF080023
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 15 Jun 2020 02:15:10 -0500
Received: from DLEE105.ent.ti.com (157.170.170.35) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 15
 Jun 2020 02:15:09 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 15 Jun 2020 02:15:09 -0500
Received: from sokoban.bb.dnainternet.fi (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 05F7ExrB062159;
        Mon, 15 Jun 2020 02:15:08 -0500
From:   Tero Kristo <t-kristo@ti.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
CC:     <j-keerthy@ti.com>
Subject: [PATCHv4 5/7] crypto: sa2ul: add device links to child devices
Date:   Mon, 15 Jun 2020 10:14:50 +0300
Message-ID: <20200615071452.25141-6-t-kristo@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200615071452.25141-1-t-kristo@ti.com>
References: <20200615071452.25141-1-t-kristo@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The child devices for sa2ul (like the RNG) have hard dependency towards
the parent, they can't function without the parent enabled. Add device
link for this purpose so that the dependencies are taken care of properly.

Signed-off-by: Tero Kristo <t-kristo@ti.com>
---
 drivers/crypto/sa2ul.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 52c204d91a44..7aca07931f04 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -2338,6 +2338,15 @@ static int sa_dma_init(struct sa_crypto_data *dd)
 	return ret;
 }
 
+static int sa_link_child(struct device *dev, void *data)
+{
+	struct device *parent = data;
+
+	device_link_add(dev, parent, DL_FLAG_AUTOPROBE_CONSUMER);
+
+	return 0;
+}
+
 static int sa_ul_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -2388,6 +2397,8 @@ static int sa_ul_probe(struct platform_device *pdev)
 	if (ret)
 		goto release_dma;
 
+	device_for_each_child(&pdev->dev, &pdev->dev, sa_link_child);
+
 	return 0;
 
 release_dma:
-- 
2.17.1

--
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki. Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
