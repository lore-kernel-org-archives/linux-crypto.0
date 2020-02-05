Return-Path: <SRS0=oWw0=3Z=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7483C35254
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Feb 2020 14:07:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3643217BA
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Feb 2020 14:07:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbgBEOHT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 5 Feb 2020 09:07:19 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:55946 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726575AbgBEOHT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Feb 2020 09:07:19 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id C70FF382BE53C4C5180A;
        Wed,  5 Feb 2020 22:07:16 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.439.0; Wed, 5 Feb 2020 22:07:09 +0800
From:   Chen Zhou <chenzhou10@huawei.com>
To:     <clabbe.montjoie@gmail.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>, <mripard@kernel.org>, <wens@csie.org>
CC:     <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <chenzhou10@huawei.com>
Subject: [PATCH -next] crypto: allwinner - remove redundant platform_get_irq error message
Date:   Wed, 5 Feb 2020 22:01:30 +0800
Message-ID: <20200205140130.164805-1-chenzhou10@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Function dev_err() after platform_get_irq() is redundant because
platform_get_irq() already prints an error.

Signed-off-by: Chen Zhou <chenzhou10@huawei.com>
---
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
index f72346a..3e4e4bb 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
@@ -565,10 +565,8 @@ static int sun8i_ce_probe(struct platform_device *pdev)
 
 	/* Get Non Secure IRQ */
 	irq = platform_get_irq(pdev, 0);
-	if (irq < 0) {
-		dev_err(ce->dev, "Cannot get CryptoEngine Non-secure IRQ\n");
+	if (irq < 0)
 		return irq;
-	}
 
 	ce->reset = devm_reset_control_get(&pdev->dev, NULL);
 	if (IS_ERR(ce->reset)) {
-- 
2.7.4

