Return-Path: <SRS0=YoIG=C6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88FD0C43468
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 13:14:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65126218AC
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 13:14:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727494AbgIUNOX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Sep 2020 09:14:23 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:58830 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727056AbgIUNJz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Sep 2020 09:09:55 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 59B12778451AA172D40D;
        Mon, 21 Sep 2020 21:09:51 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Mon, 21 Sep 2020 21:09:45 +0800
From:   Qinglang Miao <miaoqinglang@huawei.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Matthias Brugger <matthias.bgg@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Qinglang Miao <miaoqinglang@huawei.com>
Subject: [PATCH -next] crypto: mediatek - simplify the return expression of mtk_dfe_dse_reset()
Date:   Mon, 21 Sep 2020 21:10:09 +0800
Message-ID: <20200921131009.91191-1-miaoqinglang@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Simplify the return expression.

Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
---
 drivers/crypto/mediatek/mtk-platform.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/crypto/mediatek/mtk-platform.c b/drivers/crypto/mediatek/mtk-platform.c
index ef4339e84..66bb2378b 100644
--- a/drivers/crypto/mediatek/mtk-platform.c
+++ b/drivers/crypto/mediatek/mtk-platform.c
@@ -185,8 +185,6 @@ static int mtk_dfe_dse_state_check(struct mtk_cryp *cryp)
 
 static int mtk_dfe_dse_reset(struct mtk_cryp *cryp)
 {
-	int err;
-
 	/* Reset DSE/DFE and correct system priorities for all rings. */
 	writel(MTK_DFSE_THR_CTRL_RESET, cryp->base + DFE_THR_CTRL);
 	writel(0, cryp->base + DFE_PRIO_0);
@@ -200,11 +198,7 @@ static int mtk_dfe_dse_reset(struct mtk_cryp *cryp)
 	writel(0, cryp->base + DSE_PRIO_2);
 	writel(0, cryp->base + DSE_PRIO_3);
 
-	err = mtk_dfe_dse_state_check(cryp);
-	if (err)
-		return err;
-
-	return 0;
+	return mtk_dfe_dse_state_check(cryp);
 }
 
 static void mtk_cmd_desc_ring_setup(struct mtk_cryp *cryp,
-- 
2.23.0

