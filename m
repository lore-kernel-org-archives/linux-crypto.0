Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AE6FC433ED
	for <linux-crypto@archiver.kernel.org>; Fri, 14 May 2021 16:13:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 647D36145A
	for <linux-crypto@archiver.kernel.org>; Fri, 14 May 2021 16:13:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234168AbhENQOY (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 14 May 2021 12:14:24 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:38414 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233384AbhENQOX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 May 2021 12:14:23 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 14EGD71b130858;
        Fri, 14 May 2021 11:13:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1621008787;
        bh=mEP1drGQdY1DIPP5kt3sswSyjbGDBGVFQU+imuQkVZ8=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=Svu7RKNaGvzax5WH/XgSCzkuwEH5KKUKiuwuSKveN9TLFYA9QojjlaXgW91XByHNc
         6Wqd83+ERHpXQ4Jn9Ps3/0qQKMwGe4QgPGvnEwNNYNmmRlGLkcMwcx30/f+MXI0XN3
         11APruwqqJgOikRyS6U+HD8PYj0TebzXkrGEYxbk=
Received: from DFLE107.ent.ti.com (dfle107.ent.ti.com [10.64.6.28])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 14EGD7ao008254
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 14 May 2021 11:13:07 -0500
Received: from DFLE107.ent.ti.com (10.64.6.28) by DFLE107.ent.ti.com
 (10.64.6.28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Fri, 14
 May 2021 11:13:07 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE107.ent.ti.com
 (10.64.6.28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2 via
 Frontend Transport; Fri, 14 May 2021 11:13:07 -0500
Received: from lelv0597.itg.ti.com (lelv0597.itg.ti.com [10.181.64.32])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 14EGD7OY049818;
        Fri, 14 May 2021 11:13:07 -0500
Received: from localhost ([10.250.35.60])
        by lelv0597.itg.ti.com (8.14.7/8.14.7) with ESMTP id 14EGD7sB009693;
        Fri, 14 May 2021 11:13:07 -0500
From:   Suman Anna <s-anna@ti.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC:     Deepak Saxena <dsaxena@plexity.net>,
        Tero Kristo <kristo@kernel.org>, Keerthy <j-keerthy@ti.com>,
        Gowtham Tammana <g-tammana@ti.com>,
        Vaibhav Gupta <v_gupta@ti.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Suman Anna <s-anna@ti.com>
Subject: [PATCH 4/6] crypto: sa2ul - Use of_device_get_match_data() helper
Date:   Fri, 14 May 2021 11:12:44 -0500
Message-ID: <20210514161246.22517-5-s-anna@ti.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210514161246.22517-1-s-anna@ti.com>
References: <20210514161246.22517-1-s-anna@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Simplify the probe function by using the of_device_get_match_data()
helper instead of open coding. The logic is also moved up to fix the
missing pm_runtime cleanup in case of a match failure.

Fixes: 0bc42311cdff ("crypto: sa2ul - Add support for AM64")
Signed-off-by: Suman Anna <s-anna@ti.com>
---
 drivers/crypto/sa2ul.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index a215daedf78a..9f077ec9dbb7 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -2388,7 +2388,6 @@ MODULE_DEVICE_TABLE(of, of_match);
 
 static int sa_ul_probe(struct platform_device *pdev)
 {
-	const struct of_device_id *match;
 	struct device *dev = &pdev->dev;
 	struct device_node *node = dev->of_node;
 	struct resource *res;
@@ -2400,6 +2399,10 @@ static int sa_ul_probe(struct platform_device *pdev)
 	if (!dev_data)
 		return -ENOMEM;
 
+	dev_data->match_data = of_device_get_match_data(dev);
+	if (!dev_data->match_data)
+		return -ENODEV;
+
 	sa_k3_dev = dev;
 	dev_data->dev = dev;
 	dev_data->pdev = pdev;
@@ -2420,13 +2423,6 @@ static int sa_ul_probe(struct platform_device *pdev)
 	if (ret)
 		goto destroy_dma_pool;
 
-	match = of_match_node(of_match, dev->of_node);
-	if (!match) {
-		dev_err(dev, "No compatible match found\n");
-		return -ENODEV;
-	}
-	dev_data->match_data = match->data;
-
 	spin_lock_init(&dev_data->scid_lock);
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	saul_base = devm_ioremap_resource(dev, res);
-- 
2.30.1

