Return-Path: <SRS0=/mkk=BM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43B4EC433DF
	for <linux-crypto@archiver.kernel.org>; Sun,  2 Aug 2020 11:16:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B8D52087C
	for <linux-crypto@archiver.kernel.org>; Sun,  2 Aug 2020 11:16:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728132AbgHBLQg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 2 Aug 2020 07:16:36 -0400
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:54117 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728159AbgHBLPh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 2 Aug 2020 07:15:37 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R361e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0U4T1Vff_1596366933;
Received: from localhost(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0U4T1Vff_1596366933)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 02 Aug 2020 19:15:33 +0800
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        matthias.bgg@gmail.com, swboyd@chromium.org, yuehaibing@huawei.com,
        tianjia.zhang@linux.alibaba.com, ryder.lee@mediatek.com
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        tianjia.zhang@alibaba.com
Subject: [PATCH] crypto: mediatek - Fix wrong return value in mtk_desc_ring_alloc()
Date:   Sun,  2 Aug 2020 19:15:32 +0800
Message-Id: <20200802111532.5110-1-tianjia.zhang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In case of memory allocation failure, a negative error code should
be returned.

Fixes: 785e5c616c849 ("crypto: mediatek - Add crypto driver support for some MediaTek chips")
Cc: Ryder Lee <ryder.lee@mediatek.com>
Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
---
 drivers/crypto/mediatek/mtk-platform.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/mediatek/mtk-platform.c b/drivers/crypto/mediatek/mtk-platform.c
index 7e3ad085b5bd..ef4339e84d03 100644
--- a/drivers/crypto/mediatek/mtk-platform.c
+++ b/drivers/crypto/mediatek/mtk-platform.c
@@ -442,7 +442,7 @@ static void mtk_desc_dma_free(struct mtk_cryp *cryp)
 static int mtk_desc_ring_alloc(struct mtk_cryp *cryp)
 {
 	struct mtk_ring **ring = cryp->ring;
-	int i, err = ENOMEM;
+	int i;
 
 	for (i = 0; i < MTK_RING_MAX; i++) {
 		ring[i] = kzalloc(sizeof(**ring), GFP_KERNEL);
@@ -476,7 +476,7 @@ static int mtk_desc_ring_alloc(struct mtk_cryp *cryp)
 				  ring[i]->cmd_base, ring[i]->cmd_dma);
 		kfree(ring[i]);
 	}
-	return err;
+	return -ENOMEM;
 }
 
 static int mtk_crypto_probe(struct platform_device *pdev)
-- 
2.26.2

