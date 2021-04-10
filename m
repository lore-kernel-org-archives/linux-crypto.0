Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9C01C433ED
	for <linux-crypto@archiver.kernel.org>; Sat, 10 Apr 2021 09:52:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DDBA610C8
	for <linux-crypto@archiver.kernel.org>; Sat, 10 Apr 2021 09:52:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234594AbhDJJwp (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 10 Apr 2021 05:52:45 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:16518 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234433AbhDJJwp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 10 Apr 2021 05:52:45 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FHVb71sgwzPnxM;
        Sat, 10 Apr 2021 17:49:39 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.498.0; Sat, 10 Apr 2021 17:52:18 +0800
From:   Hui Tang <tanghui20@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] crypto: hisilicon/hpre - fix unmapping invalid dma address
Date:   Sat, 10 Apr 2021 17:49:17 +0800
Message-ID: <1618048157-6289-1-git-send-email-tanghui20@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Currently, an invalid dma address may be unmapped when calling
'xx_data_clr_all' in error path, so check dma address of sqe in/out
whether it has been mapped before calling 'dma_free_coherent' or
'dma_unmap_single'.

An abnormal case is as follows:
hpre_curve25519_compute_value
	-> hpre_curve25519_src_init
	-> hpre_curve25519_hw_data_clr_all

Fixes: a9214b0b6ed2(crypto: hisilicon - fix the check on dma address)
Signed-off-by: Hui Tang <tanghui20@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
index f363653..d23893a 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -298,6 +298,8 @@ static void hpre_hw_data_clr_all(struct hpre_ctx *ctx,
 	dma_addr_t tmp;
 
 	tmp = le64_to_cpu(sqe->in);
+	if (unlikely(dma_mapping_error(dev, tmp)))
+		return;
 
 	if (src) {
 		if (req->src)
@@ -307,6 +309,8 @@ static void hpre_hw_data_clr_all(struct hpre_ctx *ctx,
 	}
 
 	tmp = le64_to_cpu(sqe->out);
+	if (unlikely(dma_mapping_error(dev, tmp)))
+		return;
 
 	if (req->dst) {
 		if (dst)
@@ -517,6 +521,8 @@ static int hpre_msg_request_set(struct hpre_ctx *ctx, void *req, bool is_rsa)
 		msg->key = cpu_to_le64(ctx->dh.dma_xa_p);
 	}
 
+	msg->in = DMA_MAPPING_ERROR;
+	msg->out = DMA_MAPPING_ERROR;
 	msg->dw0 |= cpu_to_le32(0x1 << HPRE_SQE_DONE_SHIFT);
 	msg->task_len1 = (ctx->key_sz >> HPRE_BITS_2_BYTES_SHIFT) - 1;
 	h_req->ctx = ctx;
@@ -1365,11 +1371,15 @@ static void hpre_ecdh_hw_data_clr_all(struct hpre_ctx *ctx,
 	dma_addr_t dma;
 
 	dma = le64_to_cpu(sqe->in);
+	if (unlikely(dma_mapping_error(dev, dma)))
+		return;
 
 	if (src && req->src)
 		dma_free_coherent(dev, ctx->key_sz << 2, req->src, dma);
 
 	dma = le64_to_cpu(sqe->out);
+	if (unlikely(dma_mapping_error(dev, dma)))
+		return;
 
 	if (req->dst)
 		dma_free_coherent(dev, ctx->key_sz << 1, req->dst, dma);
@@ -1424,6 +1434,8 @@ static int hpre_ecdh_msg_request_set(struct hpre_ctx *ctx,
 	h_req->areq.ecdh = req;
 	msg = &h_req->req;
 	memset(msg, 0, sizeof(*msg));
+	msg->in = DMA_MAPPING_ERROR;
+	msg->out = DMA_MAPPING_ERROR;
 	msg->key = cpu_to_le64(ctx->ecdh.dma_p);
 
 	msg->dw0 |= cpu_to_le32(0x1U << HPRE_SQE_DONE_SHIFT);
@@ -1660,11 +1672,15 @@ static void hpre_curve25519_hw_data_clr_all(struct hpre_ctx *ctx,
 	dma_addr_t dma;
 
 	dma = le64_to_cpu(sqe->in);
+	if (unlikely(dma_mapping_error(dev, dma)))
+		return;
 
 	if (src && req->src)
 		dma_free_coherent(dev, ctx->key_sz, req->src, dma);
 
 	dma = le64_to_cpu(sqe->out);
+	if (unlikely(dma_mapping_error(dev, dma)))
+		return;
 
 	if (req->dst)
 		dma_free_coherent(dev, ctx->key_sz, req->dst, dma);
@@ -1715,6 +1731,8 @@ static int hpre_curve25519_msg_request_set(struct hpre_ctx *ctx,
 	h_req->areq.curve25519 = req;
 	msg = &h_req->req;
 	memset(msg, 0, sizeof(*msg));
+	msg->in = DMA_MAPPING_ERROR;
+	msg->out = DMA_MAPPING_ERROR;
 	msg->key = cpu_to_le64(ctx->curve25519.dma_p);
 
 	msg->dw0 |= cpu_to_le32(0x1U << HPRE_SQE_DONE_SHIFT);
-- 
2.8.1

