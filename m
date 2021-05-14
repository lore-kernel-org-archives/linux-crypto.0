Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03CAFC433ED
	for <linux-crypto@archiver.kernel.org>; Fri, 14 May 2021 16:13:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8A956145A
	for <linux-crypto@archiver.kernel.org>; Fri, 14 May 2021 16:13:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234418AbhENQO3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 14 May 2021 12:14:29 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:39806 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234260AbhENQO2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 May 2021 12:14:28 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 14EGDC1E083346;
        Fri, 14 May 2021 11:13:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1621008792;
        bh=nTvoG7IcDUE5QgvCR9+wp9roskkizRNjKsd/AlyiTm8=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=LMZCxOpoYvWyxekoA0+0thc+RIgcwvnk4gRA9cOOYqIK60k8zRfC4dpAB7736vS4p
         /oaLmhtW6WLGFeQiZTm+6jhvVn4VYiNe7F2n0o5Y7cwqrWeoD+mgrUwQRIKfN4FtMD
         mWly//yo/ckGR7PTC50WinQT6aHRYCLZc1NAVdqQ=
Received: from DFLE107.ent.ti.com (dfle107.ent.ti.com [10.64.6.28])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 14EGDCDm065863
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 14 May 2021 11:13:12 -0500
Received: from DFLE107.ent.ti.com (10.64.6.28) by DFLE107.ent.ti.com
 (10.64.6.28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Fri, 14
 May 2021 11:13:12 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE107.ent.ti.com
 (10.64.6.28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2 via
 Frontend Transport; Fri, 14 May 2021 11:13:12 -0500
Received: from fllv0103.dal.design.ti.com (fllv0103.dal.design.ti.com [10.247.120.73])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 14EGDCFT053166;
        Fri, 14 May 2021 11:13:12 -0500
Received: from localhost ([10.250.35.60])
        by fllv0103.dal.design.ti.com (8.14.7/8.14.7) with ESMTP id 14EGDC7Z035820;
        Fri, 14 May 2021 11:13:12 -0500
From:   Suman Anna <s-anna@ti.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC:     Deepak Saxena <dsaxena@plexity.net>,
        Tero Kristo <kristo@kernel.org>, Keerthy <j-keerthy@ti.com>,
        Gowtham Tammana <g-tammana@ti.com>,
        Vaibhav Gupta <v_gupta@ti.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Suman Anna <s-anna@ti.com>
Subject: [PATCH 5/6] crypto: sa2ul - Use devm_platform_ioremap_resource()
Date:   Fri, 14 May 2021 11:12:45 -0500
Message-ID: <20210514161246.22517-6-s-anna@ti.com>
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

Simplify the platform_get_resource() and devm_ioremap_resource()
calls with devm_platform_ioremap_resource(). Also add error checking
and move up this block to simplify the cleanup in sa_ul_probe().

Signed-off-by: Suman Anna <s-anna@ti.com>
---
 drivers/crypto/sa2ul.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 9f077ec9dbb7..216702fef945 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -2390,7 +2390,6 @@ static int sa_ul_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct device_node *node = dev->of_node;
-	struct resource *res;
 	static void __iomem *saul_base;
 	struct sa_crypto_data *dev_data;
 	int ret;
@@ -2403,9 +2402,14 @@ static int sa_ul_probe(struct platform_device *pdev)
 	if (!dev_data->match_data)
 		return -ENODEV;
 
+	saul_base = devm_platform_ioremap_resource(pdev, 0);
+	if (IS_ERR(saul_base))
+		return PTR_ERR(saul_base);
+
 	sa_k3_dev = dev;
 	dev_data->dev = dev;
 	dev_data->pdev = pdev;
+	dev_data->base = saul_base;
 	platform_set_drvdata(pdev, dev_data);
 	dev_set_drvdata(sa_k3_dev, dev_data);
 
@@ -2424,10 +2428,6 @@ static int sa_ul_probe(struct platform_device *pdev)
 		goto destroy_dma_pool;
 
 	spin_lock_init(&dev_data->scid_lock);
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	saul_base = devm_ioremap_resource(dev, res);
-
-	dev_data->base = saul_base;
 
 	if (!dev_data->match_data->skip_engine_control) {
 		u32 val = SA_EEC_ENCSS_EN | SA_EEC_AUTHSS_EN | SA_EEC_CTXCACH_EN |
-- 
2.30.1

