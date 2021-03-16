Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E509CC433E0
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Mar 2021 02:00:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AAC4F65012
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Mar 2021 02:00:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233878AbhCPB7y (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Mar 2021 21:59:54 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:13958 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231668AbhCPB7v (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Mar 2021 21:59:51 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DzxJK6X6RzrWkn;
        Tue, 16 Mar 2021 09:57:53 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.498.0; Tue, 16 Mar 2021 09:59:36 +0800
From:   chenxiang <chenxiang66@hisilicon.com>
To:     <clabbe.montjoie@gmail.com>, <clabbe@baylibre.com>,
        <gcherian@marvell.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <linuxarm@openeuler.org>,
        Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH v2 4/4] crypto: allwinner - Fix the parameter of dma_unmap_sg()
Date:   Tue, 16 Mar 2021 09:55:26 +0800
Message-ID: <1615859726-57062-5-git-send-email-chenxiang66@hisilicon.com>
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
Acked-by: Corentin LABBE <clabbe.montjoie@gmail.com>
Tested-by: Corentin LABBE <clabbe.montjoie@gmail.com>
---
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c | 9 ++++++---
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c   | 3 ++-
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c | 9 ++++++---
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c   | 3 ++-
 4 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
index 33707a2..54ae8d1 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
@@ -240,11 +240,14 @@ static int sun8i_ce_cipher_prepare(struct crypto_engine *engine, void *async_req
 
 theend_sgs:
 	if (areq->src == areq->dst) {
-		dma_unmap_sg(ce->dev, areq->src, nr_sgs, DMA_BIDIRECTIONAL);
+		dma_unmap_sg(ce->dev, areq->src, sg_nents(areq->src),
+			     DMA_BIDIRECTIONAL);
 	} else {
 		if (nr_sgs > 0)
-			dma_unmap_sg(ce->dev, areq->src, nr_sgs, DMA_TO_DEVICE);
-		dma_unmap_sg(ce->dev, areq->dst, nr_sgd, DMA_FROM_DEVICE);
+			dma_unmap_sg(ce->dev, areq->src, sg_nents(areq->src),
+				     DMA_TO_DEVICE);
+		dma_unmap_sg(ce->dev, areq->dst, sg_nents(areq->dst),
+			     DMA_FROM_DEVICE);
 	}
 
 theend_iv:
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
index 2f09a37..8819471 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
@@ -405,7 +405,8 @@ int sun8i_ce_hash_run(struct crypto_engine *engine, void *breq)
 	err = sun8i_ce_run_task(ce, flow, crypto_tfm_alg_name(areq->base.tfm));
 
 	dma_unmap_single(ce->dev, addr_pad, j * 4, DMA_TO_DEVICE);
-	dma_unmap_sg(ce->dev, areq->src, nr_sgs, DMA_TO_DEVICE);
+	dma_unmap_sg(ce->dev, areq->src, sg_nents(areq->src),
+		     DMA_TO_DEVICE);
 	dma_unmap_single(ce->dev, addr_res, digestsize, DMA_FROM_DEVICE);
 
 
diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
index ed2a69f..f945750 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
@@ -232,10 +232,13 @@ static int sun8i_ss_cipher(struct skcipher_request *areq)
 
 theend_sgs:
 	if (areq->src == areq->dst) {
-		dma_unmap_sg(ss->dev, areq->src, nr_sgs, DMA_BIDIRECTIONAL);
+		dma_unmap_sg(ss->dev, areq->src, sg_nents(areq->src),
+			     DMA_BIDIRECTIONAL);
 	} else {
-		dma_unmap_sg(ss->dev, areq->src, nr_sgs, DMA_TO_DEVICE);
-		dma_unmap_sg(ss->dev, areq->dst, nr_sgd, DMA_FROM_DEVICE);
+		dma_unmap_sg(ss->dev, areq->src, sg_nents(areq->src),
+			     DMA_TO_DEVICE);
+		dma_unmap_sg(ss->dev, areq->dst, sg_nents(areq->dst),
+			     DMA_FROM_DEVICE);
 	}
 
 theend_iv:
diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
index 0b9aa24..7d1fc9a 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
@@ -432,7 +432,8 @@ int sun8i_ss_hash_run(struct crypto_engine *engine, void *breq)
 	err = sun8i_ss_run_hash_task(ss, rctx, crypto_tfm_alg_name(areq->base.tfm));
 
 	dma_unmap_single(ss->dev, addr_pad, j * 4, DMA_TO_DEVICE);
-	dma_unmap_sg(ss->dev, areq->src, nr_sgs, DMA_TO_DEVICE);
+	dma_unmap_sg(ss->dev, areq->src, sg_nents(areq->src),
+		     DMA_TO_DEVICE);
 	dma_unmap_single(ss->dev, addr_res, digestsize, DMA_FROM_DEVICE);
 
 	kfree(pad);
-- 
2.8.1

