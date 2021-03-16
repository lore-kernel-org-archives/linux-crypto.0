Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D4FBC433E0
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Mar 2021 02:00:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4406165012
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Mar 2021 02:00:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231668AbhCPCAY (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Mar 2021 22:00:24 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:13957 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234013AbhCPB7x (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Mar 2021 21:59:53 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DzxJK6Gw0zrWkd;
        Tue, 16 Mar 2021 09:57:53 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.498.0; Tue, 16 Mar 2021 09:59:35 +0800
From:   chenxiang <chenxiang66@hisilicon.com>
To:     <clabbe.montjoie@gmail.com>, <clabbe@baylibre.com>,
        <gcherian@marvell.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <linuxarm@openeuler.org>,
        Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH v2 2/4] crypto: cavium - Fix the parameter of dma_unmap_sg()
Date:   Tue, 16 Mar 2021 09:55:24 +0800
Message-ID: <1615859726-57062-3-git-send-email-chenxiang66@hisilicon.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1615859726-57062-1-git-send-email-chenxiang66@hisilicon.com>
References: <1615859726-57062-1-git-send-email-chenxiang66@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

For function dma_unmap_sg(), the <nents> parameter should be number of
elements in the scatterlist prior to the mapping, not after the mapping.
So fix this usage.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/crypto/cavium/nitrox/nitrox_reqmgr.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c b/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c
index 53ef067..df95ba2 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c
@@ -58,14 +58,15 @@ static void softreq_unmap_sgbufs(struct nitrox_softreq *sr)
 	struct device *dev = DEV(ndev);
 
 
-	dma_unmap_sg(dev, sr->in.sg, sr->in.sgmap_cnt, DMA_BIDIRECTIONAL);
+	dma_unmap_sg(dev, sr->in.sg, sg_nents(sr->in.sg),
+		     DMA_BIDIRECTIONAL);
 	dma_unmap_single(dev, sr->in.sgcomp_dma, sr->in.sgcomp_len,
 			 DMA_TO_DEVICE);
 	kfree(sr->in.sgcomp);
 	sr->in.sg = NULL;
 	sr->in.sgmap_cnt = 0;
 
-	dma_unmap_sg(dev, sr->out.sg, sr->out.sgmap_cnt,
+	dma_unmap_sg(dev, sr->out.sg, sg_nents(sr->out.sg),
 		     DMA_BIDIRECTIONAL);
 	dma_unmap_single(dev, sr->out.sgcomp_dma, sr->out.sgcomp_len,
 			 DMA_TO_DEVICE);
@@ -178,7 +179,7 @@ static int dma_map_inbufs(struct nitrox_softreq *sr,
 	return 0;
 
 incomp_err:
-	dma_unmap_sg(dev, req->src, nents, DMA_BIDIRECTIONAL);
+	dma_unmap_sg(dev, req->src, sg_nents(req->src), DMA_BIDIRECTIONAL);
 	sr->in.sgmap_cnt = 0;
 	return ret;
 }
@@ -203,7 +204,7 @@ static int dma_map_outbufs(struct nitrox_softreq *sr,
 	return 0;
 
 outcomp_map_err:
-	dma_unmap_sg(dev, req->dst, nents, DMA_BIDIRECTIONAL);
+	dma_unmap_sg(dev, req->dst, sg_nents(req->dst), DMA_BIDIRECTIONAL);
 	sr->out.sgmap_cnt = 0;
 	sr->out.sg = NULL;
 	return ret;
-- 
2.8.1

