Return-Path: <SRS0=ziyG=YE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82DD1C47404
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Oct 2019 10:01:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 562BF214AF
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Oct 2019 10:01:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727470AbfJKKBB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Oct 2019 06:01:01 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3734 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726458AbfJKKBB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Oct 2019 06:01:01 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 395DD878D3DF5126D678;
        Fri, 11 Oct 2019 18:00:59 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.439.0; Fri, 11 Oct 2019
 18:00:51 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <ndesaulniers@google.com>, <linux-crypto@vger.kernel.org>
CC:     <zhengbin13@huawei.com>
Subject: [PATCH] crypto: ux500: Remove set but not used variable 'cookie'
Date:   Fri, 11 Oct 2019 18:08:02 +0800
Message-ID: <1570788482-104009-1-git-send-email-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/crypto/ux500/hash/hash_core.c: In function hash_set_dma_transfer:
drivers/crypto/ux500/hash/hash_core.c:143:15: warning: variable cookie set but not used [-Wunused-but-set-variable]

It is not used since commit 8a63b1994c50 ("crypto:
ux500 - Add driver for HASH hardware")

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 drivers/crypto/ux500/hash/hash_core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
index c172a69..c24f2db 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -140,7 +140,6 @@ static int hash_set_dma_transfer(struct hash_ctx *ctx, struct scatterlist *sg,
 {
 	struct dma_async_tx_descriptor *desc = NULL;
 	struct dma_chan *channel = NULL;
-	dma_cookie_t cookie;

 	if (direction != DMA_TO_DEVICE) {
 		dev_err(ctx->device->dev, "%s: Invalid DMA direction\n",
@@ -176,7 +175,7 @@ static int hash_set_dma_transfer(struct hash_ctx *ctx, struct scatterlist *sg,
 	desc->callback = hash_dma_callback;
 	desc->callback_param = ctx;

-	cookie = dmaengine_submit(desc);
+	dmaengine_submit(desc);
 	dma_async_issue_pending(channel);

 	return 0;
--
2.7.4

