Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64E2AC433ED
	for <linux-crypto@archiver.kernel.org>; Mon, 10 May 2021 09:05:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B65360FD9
	for <linux-crypto@archiver.kernel.org>; Mon, 10 May 2021 09:05:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbhEJJG6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 10 May 2021 05:06:58 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:2482 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbhEJJG6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 May 2021 05:06:58 -0400
Received: from dggeml703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Fdw7x2rdHzRfHC;
        Mon, 10 May 2021 17:03:25 +0800 (CST)
Received: from dggemi760-chm.china.huawei.com (10.1.198.146) by
 dggeml703-chm.china.huawei.com (10.3.17.136) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 10 May 2021 17:05:51 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi760-chm.china.huawei.com (10.1.198.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 10 May 2021 17:05:51 +0800
From:   Hui Tang <tanghui20@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] crypto: hisilicon/hpre - fix unmapping invalid dma address
Date:   Mon, 10 May 2021 17:02:55 +0800
Message-ID: <1620637375-39155-1-git-send-email-tanghui20@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggemi760-chm.china.huawei.com (10.1.198.146)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Currently, an invalid dma address may be unmapped when calling
'xx_data_clr_all' in error path, so check dma address of sqe in/out
if initialized before calling 'dma_free_coherent' or 'dma_unmap_single'.

Fixes: a9214b0b6ed2(crypto: hisilicon - fix the check on dma address)
Signed-off-by: Hui Tang <tanghui20@huawei.com>
---
v1 -> v2: Fix sparse warning.
---
 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
index a380087..782ddff 100644
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
@@ -524,6 +528,8 @@ static int hpre_msg_request_set(struct hpre_ctx *ctx, void *req, bool is_rsa)
 		msg->key = cpu_to_le64(ctx->dh.dma_xa_p);
 	}
 
+	msg->in = cpu_to_le64(DMA_MAPPING_ERROR);
+	msg->out = cpu_to_le64(DMA_MAPPING_ERROR);
 	msg->dw0 |= cpu_to_le32(0x1 << HPRE_SQE_DONE_SHIFT);
 	msg->task_len1 = (ctx->key_sz >> HPRE_BITS_2_BYTES_SHIFT) - 1;
 	h_req->ctx = ctx;
@@ -1372,11 +1378,15 @@ static void hpre_ecdh_hw_data_clr_all(struct hpre_ctx *ctx,
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
@@ -1431,6 +1441,8 @@ static int hpre_ecdh_msg_request_set(struct hpre_ctx *ctx,
 	h_req->areq.ecdh = req;
 	msg = &h_req->req;
 	memset(msg, 0, sizeof(*msg));
+	msg->in = cpu_to_le64(DMA_MAPPING_ERROR);
+	msg->out = cpu_to_le64(DMA_MAPPING_ERROR);
 	msg->key = cpu_to_le64(ctx->ecdh.dma_p);
 
 	msg->dw0 |= cpu_to_le32(0x1U << HPRE_SQE_DONE_SHIFT);
@@ -1667,11 +1679,15 @@ static void hpre_curve25519_hw_data_clr_all(struct hpre_ctx *ctx,
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
@@ -1722,6 +1738,8 @@ static int hpre_curve25519_msg_request_set(struct hpre_ctx *ctx,
 	h_req->areq.curve25519 = req;
 	msg = &h_req->req;
 	memset(msg, 0, sizeof(*msg));
+	msg->in = cpu_to_le64(DMA_MAPPING_ERROR);
+	msg->out = cpu_to_le64(DMA_MAPPING_ERROR);
 	msg->key = cpu_to_le64(ctx->curve25519.dma_p);
 
 	msg->dw0 |= cpu_to_le32(0x1U << HPRE_SQE_DONE_SHIFT);
-- 
2.8.1

