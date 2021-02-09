Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DD08C433E0
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Feb 2021 07:04:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14C2664EB6
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Feb 2021 07:04:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbhBIHEo (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Feb 2021 02:04:44 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:11715 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbhBIHEe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Feb 2021 02:04:34 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DZYjT3MmXzlJ0t;
        Tue,  9 Feb 2021 15:02:05 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Tue, 9 Feb 2021 15:03:31 +0800
From:   chenxiang <chenxiang66@hisilicon.com>
To:     <clabbe.montjoie@gmail.com>, <clabbe@baylibre.com>,
        <gcherian@marvell.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <linuxarm@openeuler.org>,
        <prime.zeng@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH 2/4] crypto: cavium - Fix the parameter of dma_unmap_sg()
Date:   Tue, 9 Feb 2021 14:59:23 +0800
Message-ID: <1612853965-67777-3-git-send-email-chenxiang66@hisilicon.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1612853965-67777-1-git-send-email-chenxiang66@hisilicon.com>
References: <1612853965-67777-1-git-send-email-chenxiang66@hisilicon.com>
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
 drivers/crypto/cavium/nitrox/nitrox_reqmgr.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c b/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c
index 53ef067..1263194 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c
@@ -170,7 +170,7 @@ static int dma_map_inbufs(struct nitrox_softreq *sr,
 		sr->in.total_bytes += sg_dma_len(sg);
 
 	sr->in.sg = req->src;
-	sr->in.sgmap_cnt = nents;
+	sr->in.sgmap_cnt = sg_nents(req->src);
 	ret = create_sg_component(sr, &sr->in, sr->in.sgmap_cnt);
 	if (ret)
 		goto incomp_err;
@@ -178,7 +178,7 @@ static int dma_map_inbufs(struct nitrox_softreq *sr,
 	return 0;
 
 incomp_err:
-	dma_unmap_sg(dev, req->src, nents, DMA_BIDIRECTIONAL);
+	dma_unmap_sg(dev, req->src, sg_nents(req->src), DMA_BIDIRECTIONAL);
 	sr->in.sgmap_cnt = 0;
 	return ret;
 }
@@ -195,7 +195,7 @@ static int dma_map_outbufs(struct nitrox_softreq *sr,
 		return -EINVAL;
 
 	sr->out.sg = req->dst;
-	sr->out.sgmap_cnt = nents;
+	sr->out.sgmap_cnt = sg_nents(req->dst);
 	ret = create_sg_component(sr, &sr->out, sr->out.sgmap_cnt);
 	if (ret)
 		goto outcomp_map_err;
@@ -203,7 +203,7 @@ static int dma_map_outbufs(struct nitrox_softreq *sr,
 	return 0;
 
 outcomp_map_err:
-	dma_unmap_sg(dev, req->dst, nents, DMA_BIDIRECTIONAL);
+	dma_unmap_sg(dev, req->dst, sg_nents(req->dst), DMA_BIDIRECTIONAL);
 	sr->out.sgmap_cnt = 0;
 	sr->out.sg = NULL;
 	return ret;
-- 
2.8.1

