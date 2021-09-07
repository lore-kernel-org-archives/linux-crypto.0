Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91218C433EF
	for <linux-crypto@archiver.kernel.org>; Tue,  7 Sep 2021 07:40:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A2DB6109D
	for <linux-crypto@archiver.kernel.org>; Tue,  7 Sep 2021 07:40:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233441AbhIGHl5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 7 Sep 2021 03:41:57 -0400
Received: from mx20.baidu.com ([111.202.115.85]:42602 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233439AbhIGHl4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 Sep 2021 03:41:56 -0400
Received: from BC-Mail-HQEx02.internal.baidu.com (unknown [172.31.51.58])
        by Forcepoint Email with ESMTPS id 63D01B5E0DF535D7C67F;
        Tue,  7 Sep 2021 15:40:48 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BC-Mail-HQEx02.internal.baidu.com (172.31.51.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Tue, 7 Sep 2021 15:40:48 +0800
Received: from LAPTOP-UKSR4ENP.internal.baidu.com (172.31.63.8) by
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Tue, 7 Sep 2021 15:40:47 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     <caihuoqing@baidu.com>
CC:     Deepak Saxena <dsaxena@plexity.net>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] hw_random: ixp4xx: Make use of the helper function devm_platform_ioremap_resource()
Date:   Tue, 7 Sep 2021 15:40:41 +0800
Message-ID: <20210907074042.1992-1-caihuoqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BJHW-Mail-Ex09.internal.baidu.com (10.127.64.32) To
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use the devm_platform_ioremap_resource() helper instead of
calling platform_get_resource() and devm_ioremap_resource()
separately

Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
---
 drivers/char/hw_random/ixp4xx-rng.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/char/hw_random/ixp4xx-rng.c b/drivers/char/hw_random/ixp4xx-rng.c
index 188854dd16a9..7df5e9f7519d 100644
--- a/drivers/char/hw_random/ixp4xx-rng.c
+++ b/drivers/char/hw_random/ixp4xx-rng.c
@@ -42,13 +42,11 @@ static int ixp4xx_rng_probe(struct platform_device *pdev)
 {
 	void __iomem * rng_base;
 	struct device *dev = &pdev->dev;
-	struct resource *res;
 
 	if (!cpu_is_ixp46x()) /* includes IXP455 */
 		return -ENOSYS;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	rng_base = devm_ioremap_resource(dev, res);
+	rng_base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(rng_base))
 		return PTR_ERR(rng_base);
 
-- 
2.25.1

