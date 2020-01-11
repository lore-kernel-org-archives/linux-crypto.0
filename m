Return-Path: <SRS0=WlNz=3A=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7727C3F68F
	for <linux-crypto@archiver.kernel.org>; Sat, 11 Jan 2020 09:02:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7FA9D2082E
	for <linux-crypto@archiver.kernel.org>; Sat, 11 Jan 2020 09:02:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728275AbgAKJCN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 11 Jan 2020 04:02:13 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:8696 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728031AbgAKJCN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 11 Jan 2020 04:02:13 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id E292FFD7BEA9DCD671EC;
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
Subject: [PATCH 3/4] crypto: hisilicon - adjust hpre_crt_para_get
Date:   Sat, 11 Jan 2020 16:58:17 +0800
Message-ID: <1578733098-13863-4-git-send-email-xuzaibo@huawei.com>
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

Reorder the input parameters of hpre_crt_para_get to
make it cleaner.

Signed-off-by: Zaibo Xu <xuzaibo@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
index 76540a1..954134d 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -827,17 +827,17 @@ static int hpre_rsa_set_d(struct hpre_ctx *ctx, const char *value,
 	return 0;
 }
 
-static int hpre_crt_para_get(char *para, const char *raw,
-			     unsigned int raw_sz, unsigned int para_size)
+static int hpre_crt_para_get(char *para, size_t para_sz,
+			     const char *raw, size_t raw_sz)
 {
 	const char *ptr = raw;
 	size_t len = raw_sz;
 
 	hpre_rsa_drop_leading_zeros(&ptr, &len);
-	if (!len || len > para_size)
+	if (!len || len > para_sz)
 		return -EINVAL;
 
-	memcpy(para + para_size - len, ptr, len);
+	memcpy(para + para_sz - len, ptr, len);
 
 	return 0;
 }
@@ -855,32 +855,32 @@ static int hpre_rsa_setkey_crt(struct hpre_ctx *ctx, struct rsa_key *rsa_key)
 	if (!ctx->rsa.crt_prikey)
 		return -ENOMEM;
 
-	ret = hpre_crt_para_get(ctx->rsa.crt_prikey, rsa_key->dq,
-				rsa_key->dq_sz, hlf_ksz);
+	ret = hpre_crt_para_get(ctx->rsa.crt_prikey, hlf_ksz,
+				rsa_key->dq, rsa_key->dq_sz);
 	if (ret)
 		goto free_key;
 
 	offset = hlf_ksz;
-	ret = hpre_crt_para_get(ctx->rsa.crt_prikey + offset, rsa_key->dp,
-				rsa_key->dp_sz, hlf_ksz);
+	ret = hpre_crt_para_get(ctx->rsa.crt_prikey + offset, hlf_ksz,
+				rsa_key->dp, rsa_key->dp_sz);
 	if (ret)
 		goto free_key;
 
 	offset = hlf_ksz * HPRE_CRT_Q;
-	ret = hpre_crt_para_get(ctx->rsa.crt_prikey + offset,
-				rsa_key->q, rsa_key->q_sz, hlf_ksz);
+	ret = hpre_crt_para_get(ctx->rsa.crt_prikey + offset, hlf_ksz,
+				rsa_key->q, rsa_key->q_sz);
 	if (ret)
 		goto free_key;
 
 	offset = hlf_ksz * HPRE_CRT_P;
-	ret = hpre_crt_para_get(ctx->rsa.crt_prikey + offset,
-				rsa_key->p, rsa_key->p_sz, hlf_ksz);
+	ret = hpre_crt_para_get(ctx->rsa.crt_prikey + offset, hlf_ksz,
+				rsa_key->p, rsa_key->p_sz);
 	if (ret)
 		goto free_key;
 
 	offset = hlf_ksz * HPRE_CRT_INV;
-	ret = hpre_crt_para_get(ctx->rsa.crt_prikey + offset,
-				rsa_key->qinv, rsa_key->qinv_sz, hlf_ksz);
+	ret = hpre_crt_para_get(ctx->rsa.crt_prikey + offset, hlf_ksz,
+				rsa_key->qinv, rsa_key->qinv_sz);
 	if (ret)
 		goto free_key;
 
-- 
2.8.1

