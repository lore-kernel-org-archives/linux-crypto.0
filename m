Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86684C433ED
	for <linux-crypto@archiver.kernel.org>; Wed, 19 May 2021 14:07:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67C0861363
	for <linux-crypto@archiver.kernel.org>; Wed, 19 May 2021 14:07:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353905AbhESOJD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 19 May 2021 10:09:03 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:3426 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353893AbhESOI7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 May 2021 10:08:59 -0400
Received: from dggems705-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4FlZPb1jYpzCtkL;
        Wed, 19 May 2021 22:04:51 +0800 (CST)
Received: from dggeml759-chm.china.huawei.com (10.1.199.138) by
 dggems705-chm.china.huawei.com (10.3.19.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 19 May 2021 22:07:36 +0800
Received: from localhost.localdomain (10.175.102.38) by
 dggeml759-chm.china.huawei.com (10.1.199.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 19 May 2021 22:07:35 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     <weiyongjun1@huawei.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Thara Gopinath <thara.gopinath@linaro.org>
CC:     <linux-crypto@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        "Hulk Robot" <hulkci@huawei.com>
Subject: [PATCH -next] crypto: qce - Fix some error handling path
Date:   Wed, 19 May 2021 14:16:50 +0000
Message-ID: <20210519141650.3059054-1-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.102.38]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggeml759-chm.china.huawei.com (10.1.199.138)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fix to return negative error code from the error handling
cases instead of 0.

Fixes: 9363efb4181c ("crypto: qce - Add support for AEAD algorithms")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/crypto/qce/aead.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/qce/aead.c b/drivers/crypto/qce/aead.c
index 6d06a19b48e4..d47f4171ad83 100644
--- a/drivers/crypto/qce/aead.c
+++ b/drivers/crypto/qce/aead.c
@@ -280,8 +280,10 @@ qce_aead_ccm_prepare_buf_assoclen(struct aead_request *req)
 
 	if (diff_dst) {
 		sg = qce_aead_prepare_dst_buf(req);
-		if (IS_ERR(sg))
+		if (IS_ERR(sg)) {
+			ret = PTR_ERR(sg);
 			goto err_free;
+		}
 	} else {
 		if (IS_ENCRYPT(rctx->flags))
 			rctx->dst_nents = rctx->src_nents + 1;
@@ -448,13 +450,17 @@ qce_aead_async_req_handle(struct crypto_async_request *async_req)
 	if (ret)
 		return ret;
 	dst_nents = dma_map_sg(qce->dev, rctx->dst_sg, rctx->dst_nents, dir_dst);
-	if (dst_nents < 0)
+	if (dst_nents < 0) {
+		ret = dst_nents;
 		goto error_free;
+	}
 
 	if (diff_dst) {
 		src_nents = dma_map_sg(qce->dev, rctx->src_sg, rctx->src_nents, dir_src);
-		if (src_nents < 0)
+		if (src_nents < 0) {
+			ret = src_nents;
 			goto error_unmap_dst;
+		}
 	} else {
 		if (IS_CCM(rctx->flags) && IS_DECRYPT(rctx->flags))
 			src_nents = dst_nents;

