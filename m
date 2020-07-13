Return-Path: <SRS0=38jD=AY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7250C433E5
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Jul 2020 08:34:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 970FE2073A
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Jul 2020 08:34:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="vqz/i5RU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbgGMIe4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 13 Jul 2020 04:34:56 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:38450 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726725AbgGMIez (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 13 Jul 2020 04:34:55 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 06D8YjOS064100;
        Mon, 13 Jul 2020 03:34:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1594629285;
        bh=sMcPS/YUvX5L9aCcnOwSIxhQM5LhlKSAZq/8Pvhkcrk=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=vqz/i5RUwSrdW5o0dRqZ/FNlD0l6VrTFoIcstQLY5Eg1/e4TNax9+GUo119AZ4Fho
         3WxHgI30I2CfpvIwijKTmIlgQPWh5qtfHDQGJP7fdLGqm3COOYBNZEjUWFAsRUY5av
         3mdiyqJnfZIYqLGRVMuNOhR+0NgJVr3Z/WZjZbDU=
Received: from DFLE102.ent.ti.com (dfle102.ent.ti.com [10.64.6.23])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 06D8YjkC041259;
        Mon, 13 Jul 2020 03:34:45 -0500
Received: from DFLE113.ent.ti.com (10.64.6.34) by DFLE102.ent.ti.com
 (10.64.6.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 13
 Jul 2020 03:34:45 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 13 Jul 2020 03:34:45 -0500
Received: from sokoban.bb.dnainternet.fi (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 06D8YYi7032127;
        Mon, 13 Jul 2020 03:34:43 -0500
From:   Tero Kristo <t-kristo@ti.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>
CC:     <j-keerthy@ti.com>, <linux-arm-kernel@lists.infradead.org>
Subject: [PATCHv6 5/7] crypto: sa2ul: add device links to child devices
Date:   Mon, 13 Jul 2020 11:34:25 +0300
Message-ID: <20200713083427.30117-6-t-kristo@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200713083427.30117-1-t-kristo@ti.com>
References: <20200713083427.30117-1-t-kristo@ti.com>
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
index fb4c0aba9048..ebcdffcdb686 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -2302,6 +2302,15 @@ static int sa_dma_init(struct sa_crypto_data *dd)
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
@@ -2352,6 +2361,8 @@ static int sa_ul_probe(struct platform_device *pdev)
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
