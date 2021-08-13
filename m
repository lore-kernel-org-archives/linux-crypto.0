Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6428C4320A
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Aug 2021 09:41:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C628660F00
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Aug 2021 09:41:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239592AbhHMJl5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Aug 2021 05:41:57 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:13420 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239207AbhHMJl4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Aug 2021 05:41:56 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GmJPl59WNzdZXg;
        Fri, 13 Aug 2021 17:37:47 +0800 (CST)
Received: from dggpeml500012.china.huawei.com (7.185.36.15) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 13 Aug 2021 17:41:28 +0800
Received: from huawei.com (10.69.192.56) by dggpeml500012.china.huawei.com
 (7.185.36.15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Fri, 13 Aug
 2021 17:41:28 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wangzhou1@hisilicon.com>, <yekai13@huawei.com>
Subject: [PATCH 3/5] crypto: hisilicon/sec - support the larger packets for digest mode
Date:   Fri, 13 Aug 2021 17:40:24 +0800
Message-ID: <1628847626-24383-4-git-send-email-yekai13@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1628847626-24383-1-git-send-email-yekai13@huawei.com>
References: <1628847626-24383-1-git-send-email-yekai13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500012.china.huawei.com (7.185.36.15)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Support the larger packets inputing for digest mode. By split the larger
packet, the driver input one block size packet to the hardware every time.
Setting one block size is PAGE_SIZE(4K). Based on the long hash feature,
the soft waits until the previous packet is complete and then sends the
next packet.

Signed-off-by: Kai Ye <yekai13@huawei.com>
---
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 76 ++++++++++++++++++++++++++++++
 1 file changed, 76 insertions(+)

diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index 35a6ca1..2c6cfa7 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -2719,6 +2719,80 @@ static int sec_ahash_finup(struct ahash_request *req)
 	return sec_ahash_process(req);
 }
 
+static int digest_hardware_update(struct sec_req *sreq, struct scatterlist *src,
+				  u32 start, u32 nbytes)
+{
+	struct sec_ahash_req *sareq = &sreq->hash_req;
+	struct scatterlist *pingpong_sg;
+	struct sec_ctx *ctx = sreq->ctx;
+	int nents = sg_nents(src);
+	int sid = sareq->sid;
+	u8 idx;
+
+	idx = ctx->pingpong_idx[sid];
+	pingpong_sg = &ctx->pingpong_sg[sid][idx];
+
+	sareq->op = SEC_SHA_UPDATE;
+	sareq->pp_sg = pingpong_sg;
+
+	/* The pingpong buffer can hold the one block input of this request */
+	sg_pcopy_to_buffer(src, nents, sg_virt(pingpong_sg), nbytes, start);
+	ctx->pp_data_len[sid][idx] = nbytes;
+
+	sareq->req_data_len = 0;
+	sareq->pp_data_len = nbytes;
+	sareq->block_data_len = nbytes;
+	sareq->total_data_len += nbytes;
+
+	return ctx->req_op->process(ctx, sreq);
+}
+
+static int sec_ahash_larger_digest(struct ahash_request *req)
+{
+	struct sec_req *sreq = ahash_request_ctx(req);
+	struct sec_ahash_req *sareq = &sreq->hash_req;
+	u32 input_len = req->nbytes;
+	struct scatterlist *pingpong_sg;
+	struct sec_ctx *ctx = sreq->ctx;
+	u32 sid = sareq->sid;
+	u8 idx = ctx->pingpong_idx[sid];
+	u32 start = 0;
+	int ret;
+
+	while (input_len > SEC_SID_BUF_LEN) {
+		/* setting one block size is PAGE_SIZE */
+		req->nbytes = SEC_SID_BUF_LEN;
+		input_len -= SEC_SID_BUF_LEN;
+
+		ret = digest_hardware_update(sreq, req->src, start,
+					     req->nbytes);
+		if (unlikely(ret == -EINVAL)) {
+			pr_err("ahash digest: hardware update process is error!\n");
+			return ret;
+		}
+
+		stream_hash_wait(sareq);
+
+		start += SEC_SID_BUF_LEN;
+	}
+
+	/* last packet send to the hardware */
+	req->nbytes = input_len;
+	sareq->req_data_len = 0;
+
+	pingpong_sg = &ctx->pingpong_sg[sid][idx];
+	sg_pcopy_to_buffer(req->src, sg_nents(req->src), sg_virt(pingpong_sg),
+			   input_len, start);
+	ctx->pp_data_len[sid][idx] = input_len;
+	sareq->pp_data_len = input_len;
+	sareq->block_data_len = input_len;
+	sareq->total_data_len += input_len;
+
+	sareq->op = SEC_SHA_FINAL;
+
+	return ctx->req_op->process(ctx, sreq);
+}
+
 static int sec_ahash_digest(struct ahash_request *req)
 {
 	struct sec_req *sreq = ahash_request_ctx(req);
@@ -2735,6 +2809,8 @@ static int sec_ahash_digest(struct ahash_request *req)
 
 	ctx = sreq->ctx;
 	a_ctx = &ctx->a_ctx;
+	if (req->nbytes > SEC_HW_MAX_LEN)
+		return sec_ahash_larger_digest(req);
 
 	sareq->op = SEC_SHA_DIGEST;
 
-- 
2.7.4

