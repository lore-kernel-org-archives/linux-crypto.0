Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8B7EC433ED
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Apr 2021 10:26:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91F8E61175
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Apr 2021 10:26:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbhDHK0v (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 8 Apr 2021 06:26:51 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:15185 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbhDHK0s (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 8 Apr 2021 06:26:48 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FGHRT00hVzpWLd;
        Thu,  8 Apr 2021 18:23:48 +0800 (CST)
Received: from huawei.com (10.67.165.24) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.498.0; Thu, 8 Apr 2021
 18:26:25 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yekai13@huawei.com>
Subject: [PATCH 1/2] crypto/atmel - use the correct print format
Date:   Thu, 8 Apr 2021 18:23:50 +0800
Message-ID: <1617877431-38290-2-git-send-email-yekai13@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1617877431-38290-1-git-send-email-yekai13@huawei.com>
References: <1617877431-38290-1-git-send-email-yekai13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

According to Documentation/core-api/printk-formats.rst, Use
the correct print format. Printing an unsigned int value should use %u
instead of %d.

Signed-off-by: Kai Ye <yekai13@huawei.com>
---
 drivers/crypto/atmel-i2c.c | 2 +-
 drivers/crypto/atmel-sha.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/atmel-i2c.c b/drivers/crypto/atmel-i2c.c
index e8e8281..6fd3e96 100644
--- a/drivers/crypto/atmel-i2c.c
+++ b/drivers/crypto/atmel-i2c.c
@@ -339,7 +339,7 @@ int atmel_i2c_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	}
 
 	if (bus_clk_rate > 1000000L) {
-		dev_err(dev, "%d exceeds maximum supported clock frequency (1MHz)\n",
+		dev_err(dev, "%u exceeds maximum supported clock frequency (1MHz)\n",
 			bus_clk_rate);
 		return -EINVAL;
 	}
diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index 352d80c..1b13f60 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -434,7 +434,7 @@ static int atmel_sha_init(struct ahash_request *req)
 
 	ctx->flags = 0;
 
-	dev_dbg(dd->dev, "init: digest size: %d\n",
+	dev_dbg(dd->dev, "init: digest size: %u\n",
 		crypto_ahash_digestsize(tfm));
 
 	switch (crypto_ahash_digestsize(tfm)) {
@@ -1102,7 +1102,7 @@ static int atmel_sha_start(struct atmel_sha_dev *dd)
 	struct atmel_sha_reqctx *ctx = ahash_request_ctx(req);
 	int err;
 
-	dev_dbg(dd->dev, "handling new req, op: %lu, nbytes: %d\n",
+	dev_dbg(dd->dev, "handling new req, op: %lu, nbytes: %u\n",
 						ctx->op, req->nbytes);
 
 	err = atmel_sha_hw_init(dd);
-- 
2.8.1

