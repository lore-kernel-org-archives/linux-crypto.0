Return-Path: <SRS0=RX8q=B4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1E09C433E1
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Aug 2020 14:00:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD7762054F
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Aug 2020 14:00:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbgHROAd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 Aug 2020 10:00:33 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:36494 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726617AbgHROAO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Aug 2020 10:00:14 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 66249FFEBE769B686D95;
        Tue, 18 Aug 2020 22:00:10 +0800 (CST)
Received: from localhost (10.174.179.108) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.487.0; Tue, 18 Aug 2020
 22:00:03 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <j-keerthy@ti.com>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] crypto: sa2ul - Fix pointer-to-int-cast warning
Date:   Tue, 18 Aug 2020 22:00:01 +0800
Message-ID: <20200818140001.55140-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.108]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

drivers/crypto/sa2ul.c: In function ‘sa_sha_init’:
drivers/crypto/sa2ul.c:1486:33: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
   crypto_ahash_digestsize(tfm), (u64)rctx);
                                 ^
./include/linux/dev_printk.h:123:47: note: in definition of macro ‘dev_dbg’
   dev_printk(KERN_DEBUG, dev, dev_fmt(fmt), ##__VA_ARGS__); \
                                               ^~~~~~~~~~~

Use %p to print rctx pointer.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/crypto/sa2ul.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 5bc099052bd2..acabb8ddacb6 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -1482,8 +1482,8 @@ static int sa_sha_init(struct ahash_request *req)
 	struct sa_sha_req_ctx *rctx = ahash_request_ctx(req);
 	struct sa_tfm_ctx *ctx = crypto_ahash_ctx(tfm);
 
-	dev_dbg(sa_k3_dev, "init: digest size: %d, rctx=%llx\n",
-		crypto_ahash_digestsize(tfm), (u64)rctx);
+	dev_dbg(sa_k3_dev, "init: digest size: %u, rctx=%p\n",
+		crypto_ahash_digestsize(tfm), rctx);
 
 	ahash_request_set_tfm(&rctx->fallback_req, ctx->fallback.ahash);
 	rctx->fallback_req.base.flags =
-- 
2.17.1


