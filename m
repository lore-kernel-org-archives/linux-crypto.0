Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B45A3C433E0
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Mar 2021 10:48:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 735F064F53
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Mar 2021 10:48:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbhCSKrz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Mar 2021 06:47:55 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14100 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbhCSKri (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Mar 2021 06:47:38 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F20sx137Fz17N01;
        Fri, 19 Mar 2021 18:45:41 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.498.0; Fri, 19 Mar 2021 18:47:27 +0800
From:   Hui Tang <tanghui20@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] crypto: hisilicon - fix the check on dma address
Date:   Fri, 19 Mar 2021 18:45:05 +0800
Message-ID: <1616150705-11516-1-git-send-email-tanghui20@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

System may be able to get physical address of zero if not reserved by
firmware.

The dma address obtained by 'dma_alloc_coherent' is valid, since already
checking cpu va before, so do not check again.

Signed-off-by: Hui Tang <tanghui20@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 12 ------------
 drivers/crypto/hisilicon/qm.c               |  2 +-
 drivers/crypto/hisilicon/sec2/sec_crypto.c  |  6 ------
 3 files changed, 1 insertion(+), 19 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
index d7a4adf..d743c54 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -298,8 +298,6 @@ static void hpre_hw_data_clr_all(struct hpre_ctx *ctx,
 	dma_addr_t tmp;
 
 	tmp = le64_to_cpu(sqe->in);
-	if (unlikely(!tmp))
-		return;
 
 	if (src) {
 		if (req->src)
@@ -309,8 +307,6 @@ static void hpre_hw_data_clr_all(struct hpre_ctx *ctx,
 	}
 
 	tmp = le64_to_cpu(sqe->out);
-	if (unlikely(!tmp))
-		return;
 
 	if (req->dst) {
 		if (dst)
@@ -1369,15 +1365,11 @@ static void hpre_ecdh_hw_data_clr_all(struct hpre_ctx *ctx,
 	dma_addr_t dma;
 
 	dma = le64_to_cpu(sqe->in);
-	if (unlikely(!dma))
-		return;
 
 	if (src && req->src)
 		dma_free_coherent(dev, ctx->key_sz << 2, req->src, dma);
 
 	dma = le64_to_cpu(sqe->out);
-	if (unlikely(!dma))
-		return;
 
 	if (req->dst)
 		dma_free_coherent(dev, ctx->key_sz << 1, req->dst, dma);
@@ -1668,15 +1660,11 @@ static void hpre_curve25519_hw_data_clr_all(struct hpre_ctx *ctx,
 	dma_addr_t dma;
 
 	dma = le64_to_cpu(sqe->in);
-	if (unlikely(!dma))
-		return;
 
 	if (src && req->src)
 		dma_free_coherent(dev, ctx->key_sz, req->src, dma);
 
 	dma = le64_to_cpu(sqe->out);
-	if (unlikely(!dma))
-		return;
 
 	if (req->dst)
 		dma_free_coherent(dev, ctx->key_sz, req->dst, dma);
diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index bc23174..e3688bf 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -2681,7 +2681,7 @@ static int __hisi_qm_start(struct hisi_qm *qm)
 {
 	int ret;
 
-	WARN_ON(!qm->qdma.dma);
+	WARN_ON(!qm->qdma.va);
 
 	if (qm->fun_type == QM_HW_PF) {
 		ret = qm_dev_mem_reset(qm);
diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index f835514..6c91c90 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -710,12 +710,6 @@ static int sec_cipher_pbuf_map(struct sec_ctx *ctx, struct sec_req *req,
 	}
 
 	c_req->c_in_dma = qp_ctx->res[req_id].pbuf_dma;
-
-	if (!c_req->c_in_dma) {
-		dev_err(dev, "fail to set pbuffer address!\n");
-		return -ENOMEM;
-	}
-
 	c_req->c_out_dma = c_req->c_in_dma;
 
 	return 0;
-- 
2.8.1

