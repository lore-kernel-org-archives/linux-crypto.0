Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12954C433E1
	for <linux-crypto@archiver.kernel.org>; Sat, 27 Mar 2021 09:32:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7A6661A05
	for <linux-crypto@archiver.kernel.org>; Sat, 27 Mar 2021 09:32:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbhC0JcC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 27 Mar 2021 05:32:02 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:15353 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbhC0JcB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 27 Mar 2021 05:32:01 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4F6tpn2m5zz8vRN;
        Sat, 27 Mar 2021 17:29:53 +0800 (CST)
Received: from huawei.com (10.67.165.24) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.498.0; Sat, 27 Mar 2021
 17:31:45 +0800
From:   Longfang Liu <liulongfang@huawei.com>
To:     <herbert@gondor.apana.org.au>, <wangzhou1@hisilicon.com>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <liulongfang@huawei.com>
Subject: [PATCH] crypto: hisilicon/sec - Fixes AES algorithm mode parameter problem
Date:   Sat, 27 Mar 2021 17:29:18 +0800
Message-ID: <1616837358-15112-2-git-send-email-liulongfang@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1616837358-15112-1-git-send-email-liulongfang@huawei.com>
References: <1616837358-15112-1-git-send-email-liulongfang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The input data of the ECB (AES) algorithm needs to be aligned
with 16 bytes, and the input data of the XTS (AES) algorithm is
at least 16 bytes. Otherwise the SEC hardware will go wrong.

Signed-off-by: Longfang Liu <liulongfang@huawei.com>
---
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 37 ++++++++++++++++++++++++++----
 1 file changed, 32 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index c74082c..71c0125 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -1397,6 +1397,36 @@ static int sec_aead_sha512_ctx_init(struct crypto_aead *tfm)
 	return sec_aead_ctx_init(tfm, "sha512");
 }
 
+
+static int sec_skcipher_cryptlen_ckeck(struct sec_ctx *ctx,
+	struct sec_req *sreq)
+{
+	u32 cryptlen = sreq->c_req.sk_req->cryptlen;
+	struct device *dev = ctx->dev;
+	u8 c_mode = ctx->c_ctx.c_mode;
+	int ret = 0;
+
+	switch (c_mode) {
+	case SEC_CMODE_XTS:
+		if (unlikely(cryptlen < AES_BLOCK_SIZE)) {
+			dev_err(dev, "skcipher XTS mode input length error!\n");
+			ret = -EINVAL;
+		}
+		break;
+	case SEC_CMODE_ECB:
+	case SEC_CMODE_CBC:
+		if (unlikely(cryptlen & (AES_BLOCK_SIZE - 1))) {
+			dev_err(dev, "skcipher AES input length error!\n");
+			ret = -EINVAL;
+		}
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
 static int sec_skcipher_param_check(struct sec_ctx *ctx, struct sec_req *sreq)
 {
 	struct skcipher_request *sk_req = sreq->c_req.sk_req;
@@ -1421,12 +1451,9 @@ static int sec_skcipher_param_check(struct sec_ctx *ctx, struct sec_req *sreq)
 		}
 		return 0;
 	} else if (c_alg == SEC_CALG_AES || c_alg == SEC_CALG_SM4) {
-		if (unlikely(sk_req->cryptlen & (AES_BLOCK_SIZE - 1))) {
-			dev_err(dev, "skcipher aes input length error!\n");
-			return -EINVAL;
-		}
-		return 0;
+		return sec_skcipher_cryptlen_ckeck(ctx, sreq);
 	}
+
 	dev_err(dev, "skcipher algorithm error!\n");
 
 	return -EINVAL;
-- 
2.8.1

