Return-Path: <SRS0=MAzA=AM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A111EC433DF
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Jul 2020 08:06:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B70E2073E
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Jul 2020 08:06:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="L1jatucP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728560AbgGAIGO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 1 Jul 2020 04:06:14 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:47378 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728593AbgGAIGN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Jul 2020 04:06:13 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 061869Fn050747;
        Wed, 1 Jul 2020 03:06:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1593590769;
        bh=qss1T0kR8Yhb6TuZ9w3U+BLn6FFmNM3CzQg7mdrYzlk=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=L1jatucPogf/8rTK3dCVdJNT6H1OI3P1A9THV6C103cat40b8Y7jHsZjySiY2a7Jm
         tPzRT1E5QfiDi6aDcaCsiE/b5ruDyJbwGn+9ciCgeIoiLEokKCz8F2MIOm0Oqguc5J
         XdzKF2Ec0/zdJQVwYqLmLMRAVuxDIcQanizNwFHo=
Received: from DFLE100.ent.ti.com (dfle100.ent.ti.com [10.64.6.21])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 061869Sd089858
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 1 Jul 2020 03:06:09 -0500
Received: from DFLE115.ent.ti.com (10.64.6.36) by DFLE100.ent.ti.com
 (10.64.6.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 1 Jul
 2020 03:06:08 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 1 Jul 2020 03:06:08 -0500
Received: from sokoban.bb.dnainternet.fi (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 06185wUh078048;
        Wed, 1 Jul 2020 03:06:07 -0500
From:   Tero Kristo <t-kristo@ti.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>
CC:     <j-keerthy@ti.com>
Subject: [PATCHv5 5/7] crypto: sa2ul: add device links to child devices
Date:   Wed, 1 Jul 2020 11:05:51 +0300
Message-ID: <20200701080553.22604-6-t-kristo@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200701080553.22604-1-t-kristo@ti.com>
References: <20200701080553.22604-1-t-kristo@ti.com>
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
index 6fc57d10e04a..aa080c65389e 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -2303,6 +2303,15 @@ static int sa_dma_init(struct sa_crypto_data *dd)
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
@@ -2353,6 +2362,8 @@ static int sa_ul_probe(struct platform_device *pdev)
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
