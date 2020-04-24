Return-Path: <SRS0=W4lJ=6I=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66385C55186
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Apr 2020 16:45:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 383EA20728
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Apr 2020 16:45:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="wafU2YYN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbgDXQpG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 Apr 2020 12:45:06 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:36512 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728019AbgDXQpF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Apr 2020 12:45:05 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 03OGixLo125924;
        Fri, 24 Apr 2020 11:44:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1587746699;
        bh=+/rJ66yfIL9PSoHKozQYJ2beJgBvd6f7/ijouyoq3kA=;
        h=From:To:Subject:Date:In-Reply-To:References;
        b=wafU2YYNdtnGgqYDvEiUvJPyVXDRUfBh2jdrfoh06mIa3wdefI6hNKKn0i/j/pb34
         5G80CKSMSVyIyBvVnPKmuZNVJ39kVSXTSqhzhkF5kt1mDZfNpuQieTBCglg8BTJIZo
         +nSZARzeh1LowYa663yUDVCyda3GAPFR4Rf6iAgE=
Received: from DFLE104.ent.ti.com (dfle104.ent.ti.com [10.64.6.25])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 03OGix3E014393
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 24 Apr 2020 11:44:59 -0500
Received: from DFLE108.ent.ti.com (10.64.6.29) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 24
 Apr 2020 11:44:58 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 24 Apr 2020 11:44:59 -0500
Received: from sokoban.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 03OGinTA033554;
        Fri, 24 Apr 2020 11:44:58 -0500
From:   Tero Kristo <t-kristo@ti.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>
Subject: [PATCHv2 5/7] crypto: sa2ul: add device links to child devices
Date:   Fri, 24 Apr 2020 19:44:28 +0300
Message-ID: <20200424164430.3288-6-t-kristo@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200424164430.3288-1-t-kristo@ti.com>
References: <20200424164430.3288-1-t-kristo@ti.com>
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
index 899ef90a3d76..9483b199df6c 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -2339,6 +2339,15 @@ static int sa_dma_init(struct sa_crypto_data *dd)
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
@@ -2389,6 +2398,8 @@ static int sa_ul_probe(struct platform_device *pdev)
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
