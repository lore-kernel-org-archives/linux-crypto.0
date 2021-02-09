Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2929CC433DB
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Feb 2021 07:04:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE2E864EB6
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Feb 2021 07:04:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbhBIHEc (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Feb 2021 02:04:32 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:11713 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbhBIHEc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Feb 2021 02:04:32 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DZYjT2pT7zlHvJ;
        Tue,  9 Feb 2021 15:02:05 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Tue, 9 Feb 2021 15:03:30 +0800
From:   chenxiang <chenxiang66@hisilicon.com>
To:     <clabbe.montjoie@gmail.com>, <clabbe@baylibre.com>,
        <gcherian@marvell.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <linuxarm@openeuler.org>,
        <prime.zeng@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH 1/4] crypto: amlogic - Fix the parameter of dma_unmap_sg()
Date:   Tue, 9 Feb 2021 14:59:22 +0800
Message-ID: <1612853965-67777-2-git-send-email-chenxiang66@hisilicon.com>
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
 drivers/crypto/amlogic/amlogic-gxl-cipher.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/amlogic/amlogic-gxl-cipher.c b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
index 8b5e073..c6865cbd 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-cipher.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
@@ -236,10 +236,10 @@ static int meson_cipher(struct skcipher_request *areq)
 	dma_unmap_single(mc->dev, phykeyiv, keyivlen, DMA_TO_DEVICE);
 
 	if (areq->src == areq->dst) {
-		dma_unmap_sg(mc->dev, areq->src, nr_sgs, DMA_BIDIRECTIONAL);
+		dma_unmap_sg(mc->dev, areq->src, sg_nents(areq->src), DMA_BIDIRECTIONAL);
 	} else {
-		dma_unmap_sg(mc->dev, areq->src, nr_sgs, DMA_TO_DEVICE);
-		dma_unmap_sg(mc->dev, areq->dst, nr_sgd, DMA_FROM_DEVICE);
+		dma_unmap_sg(mc->dev, areq->src, sg_nents(areq->src), DMA_TO_DEVICE);
+		dma_unmap_sg(mc->dev, areq->dst, sg_nents(areq->dst), DMA_FROM_DEVICE);
 	}
 
 	if (areq->iv && ivsize > 0) {
-- 
2.8.1

