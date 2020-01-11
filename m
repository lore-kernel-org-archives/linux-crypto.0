Return-Path: <SRS0=WlNz=3A=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C05A1C33CA4
	for <linux-crypto@archiver.kernel.org>; Sat, 11 Jan 2020 09:02:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0A512077C
	for <linux-crypto@archiver.kernel.org>; Sat, 11 Jan 2020 09:02:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728031AbgAKJCO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 11 Jan 2020 04:02:14 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:8694 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728346AbgAKJCN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 11 Jan 2020 04:02:13 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id DA5FF426E62474ECB505;
        Sat, 11 Jan 2020 17:02:11 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.439.0; Sat, 11 Jan 2020 17:02:04 +0800
From:   Zaibo Xu <xuzaibo@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <linuxarm@huawei.com>,
        <jonathan.cameron@huawei.com>, <wangzhou1@hisilicon.com>,
        <tanghui20@huawei.com>, <yekai13@huawei.com>,
        <liulongfang@huawei.com>, <qianweili@huawei.com>,
        <fanghao11@huawei.com>, <forest.zhouchang@huawei.com>
Subject: [PATCH 4/4] crypto: hisilicon - add branch prediction macro
Date:   Sat, 11 Jan 2020 16:58:18 +0800
Message-ID: <1578733098-13863-5-git-send-email-xuzaibo@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1578733098-13863-1-git-send-email-xuzaibo@huawei.com>
References: <1578733098-13863-1-git-send-email-xuzaibo@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This branch prediction macro on the hot path can improve
small performance(about 2%) according to the test.

Signed-off-by: Zaibo Xu <xuzaibo@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 44 ++++++++++++++---------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
index 954134d..5d400d6 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -123,7 +123,7 @@ static int hpre_add_req_to_ctx(struct hpre_asym_request *hpre_req)
 
 	ctx = hpre_req->ctx;
 	id = hpre_alloc_req_id(ctx);
-	if (id < 0)
+	if (unlikely(id < 0))
 		return -EINVAL;
 
 	ctx->req_list[id] = hpre_req;
@@ -190,7 +190,7 @@ static int hpre_get_data_dma_addr(struct hpre_asym_request *hpre_req,
 	}
 	*tmp = dma_map_single(dev, sg_virt(data),
 			      len, dma_dir);
-	if (dma_mapping_error(dev, *tmp)) {
+	if (unlikely(dma_mapping_error(dev, *tmp))) {
 		dev_err(dev, "dma map data err!\n");
 		return -ENOMEM;
 	}
@@ -208,11 +208,11 @@ static int hpre_prepare_dma_buf(struct hpre_asym_request *hpre_req,
 	int shift;
 
 	shift = ctx->key_sz - len;
-	if (shift < 0)
+	if (unlikely(shift < 0))
 		return -EINVAL;
 
 	ptr = dma_alloc_coherent(dev, ctx->key_sz, tmp, GFP_KERNEL);
-	if (!ptr)
+	if (unlikely(!ptr))
 		return -ENOMEM;
 
 	if (is_src) {
@@ -241,7 +241,7 @@ static int hpre_hw_data_init(struct hpre_asym_request *hpre_req,
 	else
 		ret = hpre_prepare_dma_buf(hpre_req, data, len,
 					  is_src, &tmp);
-	if (ret)
+	if (unlikely(ret))
 		return ret;
 
 	if (is_src)
@@ -262,7 +262,7 @@ static void hpre_hw_data_clr_all(struct hpre_ctx *ctx,
 	dma_addr_t tmp;
 
 	tmp = le64_to_cpu(sqe->in);
-	if (!tmp)
+	if (unlikely(!tmp))
 		return;
 
 	if (src) {
@@ -275,7 +275,7 @@ static void hpre_hw_data_clr_all(struct hpre_ctx *ctx,
 	}
 
 	tmp = le64_to_cpu(sqe->out);
-	if (!tmp)
+	if (unlikely(!tmp))
 		return;
 
 	if (req->dst) {
@@ -309,7 +309,7 @@ static int hpre_alg_res_post_hf(struct hpre_ctx *ctx, struct hpre_sqe *sqe,
 	done = (le32_to_cpu(sqe->dw0) >> HPRE_SQE_DONE_SHIFT) &
 		HREE_SQE_DONE_MASK;
 
-	if (err == HPRE_NO_HW_ERR &&  done == HPRE_HW_TASK_DONE)
+	if (likely(err == HPRE_NO_HW_ERR && done == HPRE_HW_TASK_DONE))
 		return  0;
 
 	return -EINVAL;
@@ -456,17 +456,17 @@ static int hpre_dh_compute_value(struct kpp_request *req)
 	int ret;
 
 	ret = hpre_msg_request_set(ctx, req, false);
-	if (ret)
+	if (unlikely(ret))
 		return ret;
 
 	if (req->src) {
 		ret = hpre_hw_data_init(hpre_req, req->src, req->src_len, 1, 1);
-		if (ret)
+		if (unlikely(ret))
 			goto clear_all;
 	}
 
 	ret = hpre_hw_data_init(hpre_req, req->dst, req->dst_len, 0, 1);
-	if (ret)
+	if (unlikely(ret))
 		goto clear_all;
 
 	if (ctx->crt_g2_mode && !req->src)
@@ -478,7 +478,7 @@ static int hpre_dh_compute_value(struct kpp_request *req)
 	} while (ret == -EBUSY && ctr++ < HPRE_TRY_SEND_TIMES);
 
 	/* success */
-	if (!ret)
+	if (likely(!ret))
 		return -EINPROGRESS;
 
 clear_all:
@@ -667,22 +667,22 @@ static int hpre_rsa_enc(struct akcipher_request *req)
 		return ret;
 	}
 
-	if (!ctx->rsa.pubkey)
+	if (unlikely(!ctx->rsa.pubkey))
 		return -EINVAL;
 
 	ret = hpre_msg_request_set(ctx, req, true);
-	if (ret)
+	if (unlikely(ret))
 		return ret;
 
 	msg->dw0 |= cpu_to_le32(HPRE_ALG_NC_NCRT);
 	msg->key = cpu_to_le64((u64)ctx->rsa.dma_pubkey);
 
 	ret = hpre_hw_data_init(hpre_req, req->src, req->src_len, 1, 0);
-	if (ret)
+	if (unlikely(ret))
 		goto clear_all;
 
 	ret = hpre_hw_data_init(hpre_req, req->dst, req->dst_len, 0, 0);
-	if (ret)
+	if (unlikely(ret))
 		goto clear_all;
 
 	do {
@@ -690,7 +690,7 @@ static int hpre_rsa_enc(struct akcipher_request *req)
 	} while (ret == -EBUSY && ctr++ < HPRE_TRY_SEND_TIMES);
 
 	/* success */
-	if (!ret)
+	if (likely(!ret))
 		return -EINPROGRESS;
 
 clear_all:
@@ -719,11 +719,11 @@ static int hpre_rsa_dec(struct akcipher_request *req)
 		return ret;
 	}
 
-	if (!ctx->rsa.prikey)
+	if (unlikely(!ctx->rsa.prikey))
 		return -EINVAL;
 
 	ret = hpre_msg_request_set(ctx, req, true);
-	if (ret)
+	if (unlikely(ret))
 		return ret;
 
 	if (ctx->crt_g2_mode) {
@@ -737,11 +737,11 @@ static int hpre_rsa_dec(struct akcipher_request *req)
 	}
 
 	ret = hpre_hw_data_init(hpre_req, req->src, req->src_len, 1, 0);
-	if (ret)
+	if (unlikely(ret))
 		goto clear_all;
 
 	ret = hpre_hw_data_init(hpre_req, req->dst, req->dst_len, 0, 0);
-	if (ret)
+	if (unlikely(ret))
 		goto clear_all;
 
 	do {
@@ -749,7 +749,7 @@ static int hpre_rsa_dec(struct akcipher_request *req)
 	} while (ret == -EBUSY && ctr++ < HPRE_TRY_SEND_TIMES);
 
 	/* success */
-	if (!ret)
+	if (likely(!ret))
 		return -EINPROGRESS;
 
 clear_all:
-- 
2.8.1

