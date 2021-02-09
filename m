Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D93A2C433DB
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Feb 2021 07:04:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACDF864D9E
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Feb 2021 07:04:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbhBIHEo (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Feb 2021 02:04:44 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:11716 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbhBIHEf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Feb 2021 02:04:35 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DZYjT2Y9ZzlHsL;
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
Subject: [PATCH 3/4] crypto: ux500 - Fix the parameter of dma_unmap_sg()
Date:   Tue, 9 Feb 2021 14:59:24 +0800
Message-ID: <1612853965-67777-4-git-send-email-chenxiang66@hisilicon.com>
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
 drivers/crypto/ux500/cryp/cryp_core.c | 4 ++--
 drivers/crypto/ux500/hash/hash_core.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/ux500/cryp/cryp_core.c b/drivers/crypto/ux500/cryp/cryp_core.c
index c3adeb2..9abf00e 100644
--- a/drivers/crypto/ux500/cryp/cryp_core.c
+++ b/drivers/crypto/ux500/cryp/cryp_core.c
@@ -608,12 +608,12 @@ static void cryp_dma_done(struct cryp_ctx *ctx)
 	chan = ctx->device->dma.chan_mem2cryp;
 	dmaengine_terminate_all(chan);
 	dma_unmap_sg(chan->device->dev, ctx->device->dma.sg_src,
-		     ctx->device->dma.sg_src_len, DMA_TO_DEVICE);
+		     ctx->device->dma.nents_src, DMA_TO_DEVICE);
 
 	chan = ctx->device->dma.chan_cryp2mem;
 	dmaengine_terminate_all(chan);
 	dma_unmap_sg(chan->device->dev, ctx->device->dma.sg_dst,
-		     ctx->device->dma.sg_dst_len, DMA_FROM_DEVICE);
+		     ctx->device->dma.nents_dst, DMA_FROM_DEVICE);
 }
 
 static int cryp_dma_write(struct cryp_ctx *ctx, struct scatterlist *sg,
diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
index da284b0..67b1237 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -190,7 +190,7 @@ static void hash_dma_done(struct hash_ctx *ctx)
 	chan = ctx->device->dma.chan_mem2hash;
 	dmaengine_terminate_all(chan);
 	dma_unmap_sg(chan->device->dev, ctx->device->dma.sg,
-		     ctx->device->dma.sg_len, DMA_TO_DEVICE);
+		     ctx->device->dma.nents, DMA_TO_DEVICE);
 }
 
 static int hash_dma_write(struct hash_ctx *ctx,
-- 
2.8.1

