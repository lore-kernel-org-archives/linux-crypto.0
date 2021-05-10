Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDE99C433B4
	for <linux-crypto@archiver.kernel.org>; Mon, 10 May 2021 09:09:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA3C161456
	for <linux-crypto@archiver.kernel.org>; Mon, 10 May 2021 09:09:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbhEJJLB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 10 May 2021 05:11:01 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2744 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbhEJJLA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 May 2021 05:11:00 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FdwCZ4PbTzqV0y;
        Mon, 10 May 2021 17:06:34 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.498.0; Mon, 10 May 2021 17:09:47 +0800
From:   Hui Tang <tanghui20@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/8] crypto: hisilicon/hpre - delete rudundant initialization
Date:   Mon, 10 May 2021 17:06:48 +0800
Message-ID: <1620637611-41643-6-git-send-email-tanghui20@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1620637611-41643-1-git-send-email-tanghui20@huawei.com>
References: <1620637611-41643-1-git-send-email-tanghui20@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Delete rudundant variable initialization.

Signed-off-by: Hui Tang <tanghui20@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
index b9197e9..3a3af82 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -1480,7 +1480,7 @@ static int hpre_ecdh_dst_data_init(struct hpre_asym_request *hpre_req,
 	struct hpre_sqe *msg = &hpre_req->req;
 	struct hpre_ctx *ctx = hpre_req->ctx;
 	struct device *dev = ctx->dev;
-	dma_addr_t dma = 0;
+	dma_addr_t dma;
 
 	if (unlikely(!data || !sg_is_last(data) || len != ctx->key_sz << 1)) {
 		dev_err(dev, "data or data length is illegal!\n");
@@ -1807,7 +1807,7 @@ static int hpre_curve25519_dst_init(struct hpre_asym_request *hpre_req,
 	struct hpre_sqe *msg = &hpre_req->req;
 	struct hpre_ctx *ctx = hpre_req->ctx;
 	struct device *dev = ctx->dev;
-	dma_addr_t dma = 0;
+	dma_addr_t dma;
 
 	if (!data || !sg_is_last(data) || len != ctx->key_sz) {
 		dev_err(dev, "data or data length is illegal!\n");
-- 
2.8.1

