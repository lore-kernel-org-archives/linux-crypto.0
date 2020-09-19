Return-Path: <SRS0=oEI+=C4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28068C43463
	for <linux-crypto@archiver.kernel.org>; Sat, 19 Sep 2020 03:15:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E39DB207D3
	for <linux-crypto@archiver.kernel.org>; Sat, 19 Sep 2020 03:15:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726009AbgISDPn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Sep 2020 23:15:43 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:13325 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726280AbgISDPm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Sep 2020 23:15:42 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 446F1658B7FA1F81F415;
        Sat, 19 Sep 2020 11:15:24 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Sat, 19 Sep 2020 11:15:17 +0800
From:   yumeng 00484669 <yumeng18@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <yumeng18@huawei.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 1/3] crypto: hisilicon/hpre - remove useless code
Date:   Sat, 19 Sep 2020 11:13:50 +0800
Message-ID: <1600485232-39831-2-git-send-email-yumeng18@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1600485232-39831-1-git-send-email-yumeng18@huawei.com>
References: <1600485232-39831-1-git-send-email-yumeng18@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Meng Yu <yumeng18@huawei.com>

1. Remove unused member 'debug_root' in 'struct hpre_debug';
2. The u64 cast is redundant in 'cpu_to_le64'.

Fixes: 848974151618("crypto: hisilicon - Add debugfs for HPRE")
Fixes: dadbe4c11753("crypto: hisilicon/hpre - update debugfs ...")
Signed-off-by: Meng Yu <yumeng18@huawei.com>
Reviewed-by: Zaibo Xu <xuzaibo@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre.h        | 1 -
 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 8 ++++----
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre.h b/drivers/crypto/hisilicon/hpre/hpre.h
index ed730d1..f69252b 100644
--- a/drivers/crypto/hisilicon/hpre/hpre.h
+++ b/drivers/crypto/hisilicon/hpre/hpre.h
@@ -56,7 +56,6 @@ struct hpre_dfx {
  * Just relevant for PF.
  */
 struct hpre_debug {
-	struct dentry *debug_root;
 	struct hpre_dfx dfx[HPRE_DFX_FILE_NUM];
 	struct hpre_debugfs_file files[HPRE_DEBUGFS_FILE_NUM];
 };
diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
index d685992..678a5ee 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -474,7 +474,7 @@ static int hpre_msg_request_set(struct hpre_ctx *ctx, void *req, bool is_rsa)
 		h_req->areq.dh = kreq;
 		msg = &h_req->req;
 		memset(msg, 0, sizeof(*msg));
-		msg->key = cpu_to_le64((u64)ctx->dh.dma_xa_p);
+		msg->key = cpu_to_le64(ctx->dh.dma_xa_p);
 	}
 
 	msg->dw0 |= cpu_to_le32(0x1 << HPRE_SQE_DONE_SHIFT);
@@ -740,7 +740,7 @@ static int hpre_rsa_enc(struct akcipher_request *req)
 		return ret;
 
 	msg->dw0 |= cpu_to_le32(HPRE_ALG_NC_NCRT);
-	msg->key = cpu_to_le64((u64)ctx->rsa.dma_pubkey);
+	msg->key = cpu_to_le64(ctx->rsa.dma_pubkey);
 
 	ret = hpre_hw_data_init(hpre_req, req->src, req->src_len, 1, 0);
 	if (unlikely(ret))
@@ -788,11 +788,11 @@ static int hpre_rsa_dec(struct akcipher_request *req)
 		return ret;
 
 	if (ctx->crt_g2_mode) {
-		msg->key = cpu_to_le64((u64)ctx->rsa.dma_crt_prikey);
+		msg->key = cpu_to_le64(ctx->rsa.dma_crt_prikey);
 		msg->dw0 = cpu_to_le32(le32_to_cpu(msg->dw0) |
 				       HPRE_ALG_NC_CRT);
 	} else {
-		msg->key = cpu_to_le64((u64)ctx->rsa.dma_prikey);
+		msg->key = cpu_to_le64(ctx->rsa.dma_prikey);
 		msg->dw0 = cpu_to_le32(le32_to_cpu(msg->dw0) |
 				       HPRE_ALG_NC_NCRT);
 	}
-- 
2.8.1

