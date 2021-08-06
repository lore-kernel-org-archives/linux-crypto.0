Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF7F1C432BE
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Aug 2021 09:45:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D898A61040
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Aug 2021 09:45:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244684AbhHFJps (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Aug 2021 05:45:48 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:13394 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242840AbhHFJpo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Aug 2021 05:45:44 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Gh0qh0Pb2zclVs;
        Fri,  6 Aug 2021 17:41:52 +0800 (CST)
Received: from dggpeml500012.china.huawei.com (7.185.36.15) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 6 Aug 2021 17:45:23 +0800
Received: from huawei.com (10.69.192.56) by dggpeml500012.china.huawei.com
 (7.185.36.15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Fri, 6 Aug 2021
 17:45:23 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wangzhou1@hisilicon.com>, <yekai13@huawei.com>
Subject: [PATCH v2 2/5] crypto: hisilicon/sec - delete the print of fallback tfm application failure
Date:   Fri, 6 Aug 2021 17:44:23 +0800
Message-ID: <1628243066-32648-3-git-send-email-yekai13@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1628243066-32648-1-git-send-email-yekai13@huawei.com>
References: <1628243066-32648-1-git-send-email-yekai13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500012.china.huawei.com (7.185.36.15)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Modify the print of information that might lead to user misunderstanding.
Currently only XTS mode need the fallback tfm when using 192bit key.
Others algs not need soft fallback tfm. So others algs can return
directly.

Signed-off-by: Kai Ye <yekai13@huawei.com>
---
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index bf93c98..890faf8 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -641,15 +641,15 @@ static int sec_skcipher_fbtfm_init(struct crypto_skcipher *tfm)
 	struct sec_cipher_ctx *c_ctx = &ctx->c_ctx;
 
 	c_ctx->fallback = false;
+
+	/* Currently, only XTS mode need fallback tfm when using 192bit key */
 	if (likely(strncmp(alg, "xts", SEC_XTS_NAME_SZ)))
 		return 0;
 
 	c_ctx->fbtfm = crypto_alloc_sync_skcipher(alg, 0,
 						  CRYPTO_ALG_NEED_FALLBACK);
-	if (IS_ERR(c_ctx->fbtfm)) {
-		pr_err("failed to alloc fallback tfm!\n");
-		return PTR_ERR(c_ctx->fbtfm);
-	}
+	if (IS_ERR(c_ctx->fbtfm))
+		c_ctx->fbtfm = NULL;
 
 	return 0;
 }
@@ -808,7 +808,7 @@ static int sec_skcipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
 	}
 
 	memcpy(c_ctx->c_key, key, keylen);
-	if (c_ctx->fallback) {
+	if (c_ctx->fallback && c_ctx->fbtfm) {
 		ret = crypto_sync_skcipher_setkey(c_ctx->fbtfm, key, keylen);
 		if (ret) {
 			dev_err(dev, "failed to set fallback skcipher key!\n");
@@ -2032,13 +2032,12 @@ static int sec_skcipher_soft_crypto(struct sec_ctx *ctx,
 				    struct skcipher_request *sreq, bool encrypt)
 {
 	struct sec_cipher_ctx *c_ctx = &ctx->c_ctx;
+	SYNC_SKCIPHER_REQUEST_ON_STACK(subreq, c_ctx->fbtfm);
 	struct device *dev = ctx->dev;
 	int ret;
 
-	SYNC_SKCIPHER_REQUEST_ON_STACK(subreq, c_ctx->fbtfm);
-
 	if (!c_ctx->fbtfm) {
-		dev_err(dev, "failed to check fallback tfm\n");
+		dev_err_ratelimited(dev, "the soft tfm isn't supported in the current system.\n");
 		return -EINVAL;
 	}
 
-- 
2.7.4

