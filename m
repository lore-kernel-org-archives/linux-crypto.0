Return-Path: <SRS0=0DWe=YJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03A7FFA372B
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Oct 2019 10:47:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D027C2067D
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Oct 2019 10:47:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392551AbfJPKqy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Oct 2019 06:46:54 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:44064 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727291AbfJPKqx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Oct 2019 06:46:53 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 86ECA4684DCFA3037407;
        Wed, 16 Oct 2019 18:46:51 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.439.0; Wed, 16 Oct 2019
 18:46:45 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <herbert@gondor.apana.org.au>, <mpm@selenic.com>, <arnd@arndb.de>,
        <gregkh@linuxfoundation.org>, <nicolas.ferre@microchip.com>,
        <alexandre.belloni@bootlin.com>, <ludovic.desroches@microchip.com>,
        <f.fainelli@gmail.com>, <rjui@broadcom.com>,
        <sbranden@broadcom.com>, <bcm-kernel-feedback-list@broadcom.com>,
        <eric@anholt.net>, <wahrenst@gmx.net>, <l.stelmach@samsung.com>,
        <kgene@kernel.org>, <krzk@kernel.org>, <khilman@baylibre.com>,
        <dsaxena@plexity.net>, <patrice.chotard@st.com>
CC:     <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-rpi-kernel@lists.infradead.org>,
        <linux-samsung-soc@vger.kernel.org>,
        <linux-amlogic@lists.infradead.org>,
        <linuxppc-dev@lists.ozlabs.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next 05/13] hwrng: ks-sa - use devm_platform_ioremap_resource() to simplify code
Date:   Wed, 16 Oct 2019 18:46:13 +0800
Message-ID: <20191016104621.26056-6-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
In-Reply-To: <20191016104621.26056-1-yuehaibing@huawei.com>
References: <20191016104621.26056-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use devm_platform_ioremap_resource() to simplify the code a bit.
This is detected by coccinelle.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/char/hw_random/ks-sa-rng.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/char/hw_random/ks-sa-rng.c b/drivers/char/hw_random/ks-sa-rng.c
index a674300..556400a 100644
--- a/drivers/char/hw_random/ks-sa-rng.c
+++ b/drivers/char/hw_random/ks-sa-rng.c
@@ -174,7 +174,6 @@ static int ks_sa_rng_probe(struct platform_device *pdev)
 	struct ks_sa_rng	*ks_sa_rng;
 	struct device		*dev = &pdev->dev;
 	int			ret;
-	struct resource		*mem;
 
 	ks_sa_rng = devm_kzalloc(dev, sizeof(*ks_sa_rng), GFP_KERNEL);
 	if (!ks_sa_rng)
@@ -190,8 +189,7 @@ static int ks_sa_rng_probe(struct platform_device *pdev)
 	};
 	ks_sa_rng->rng.priv = (unsigned long)dev;
 
-	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	ks_sa_rng->reg_rng = devm_ioremap_resource(dev, mem);
+	ks_sa_rng->reg_rng = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(ks_sa_rng->reg_rng))
 		return PTR_ERR(ks_sa_rng->reg_rng);
 
-- 
2.7.4


