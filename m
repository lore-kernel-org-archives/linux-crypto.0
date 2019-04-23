Return-Path: <SRS0=ov1/=SZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02FFEC10F14
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Apr 2019 07:42:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF74A20645
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Apr 2019 07:42:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbfDWHkV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 23 Apr 2019 03:40:21 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:6682 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726598AbfDWHkU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Apr 2019 03:40:20 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id DD7733A7DA54CA08499F;
        Tue, 23 Apr 2019 15:40:12 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.439.0; Tue, 23 Apr 2019 15:40:03 +0800
From:   Kefeng Wang <wangkefeng.wang@huawei.com>
To:     <linux-kernel@vger.kernel.org>
CC:     Masahiro Yamada <yamada.masahiro@socionext.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Jamie Iles <jamie@jamieiles.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH next 02/25] crypto: picoxcell: Use dev_get_drvdata()
Date:   Tue, 23 Apr 2019 15:49:57 +0800
Message-ID: <20190423075020.173734-3-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190423075020.173734-1-wangkefeng.wang@huawei.com>
References: <20190423075020.173734-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Using dev_get_drvdata directly.

Cc: Jamie Iles <jamie@jamieiles.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 drivers/crypto/picoxcell_crypto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/picoxcell_crypto.c b/drivers/crypto/picoxcell_crypto.c
index 1b3acdeffede..b275d2af365a 100644
--- a/drivers/crypto/picoxcell_crypto.c
+++ b/drivers/crypto/picoxcell_crypto.c
@@ -1196,7 +1196,7 @@ static const struct dev_pm_ops spacc_pm_ops = {
 
 static inline struct spacc_engine *spacc_dev_to_engine(struct device *dev)
 {
-	return dev ? platform_get_drvdata(to_platform_device(dev)) : NULL;
+	return dev ? dev_get_drvdata(dev) : NULL;
 }
 
 static ssize_t spacc_stat_irq_thresh_show(struct device *dev,
-- 
2.20.1

