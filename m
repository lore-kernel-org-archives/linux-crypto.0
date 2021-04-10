Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9166C43460
	for <linux-crypto@archiver.kernel.org>; Sat, 10 Apr 2021 09:50:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92B6361028
	for <linux-crypto@archiver.kernel.org>; Sat, 10 Apr 2021 09:50:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234618AbhDJJuz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 10 Apr 2021 05:50:55 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:16563 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233943AbhDJJuy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 10 Apr 2021 05:50:54 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FHVYg25JQz17RFW;
        Sat, 10 Apr 2021 17:48:23 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Sat, 10 Apr 2021 17:50:28 +0800
From:   Hui Tang <tanghui20@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] crypto: hisilicon/hpre - add debug log
Date:   Sat, 10 Apr 2021 17:47:01 +0800
Message-ID: <1618048021-50335-4-git-send-email-tanghui20@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1618048021-50335-1-git-send-email-tanghui20@huawei.com>
References: <1618048021-50335-1-git-send-email-tanghui20@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When the received sqe is abnormal, the error message in the sqe written
back by the hardware is printed to help to analyze the abnormal causes.

Signed-off-by: Hui Tang <tanghui20@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
index 0adaf92..c8531c0 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -325,14 +325,16 @@ static void hpre_hw_data_clr_all(struct hpre_ctx *ctx,
 static int hpre_alg_res_post_hf(struct hpre_ctx *ctx, struct hpre_sqe *sqe,
 				void **kreq)
 {
+	struct device *dev = HPRE_DEV(ctx);
 	struct hpre_asym_request *req;
-	unsigned int err, done;
+	unsigned int err, done, alg;
 	int id;

 #define HPRE_NO_HW_ERR		0
 #define HPRE_HW_TASK_DONE	3
 #define HREE_HW_ERR_MASK	0x7ff
 #define HREE_SQE_DONE_MASK	0x3
+#define HREE_ALG_TYPE_MASK	0x1f
 	id = (int)le16_to_cpu(sqe->tag);
 	req = ctx->req_list[id];
 	hpre_rm_req_from_ctx(req);
@@ -347,6 +349,10 @@ static int hpre_alg_res_post_hf(struct hpre_ctx *ctx, struct hpre_sqe *sqe,
 	if (likely(err == HPRE_NO_HW_ERR && done == HPRE_HW_TASK_DONE))
 		return 0;

+	alg = le32_to_cpu(sqe->dw0) & HREE_ALG_TYPE_MASK;
+	dev_err_ratelimited(dev, "alg[0x%x] error: done[0x%x], etype[0x%x]\n",
+		alg, done, err);
+
 	return -EINVAL;
 }

--
2.8.1

