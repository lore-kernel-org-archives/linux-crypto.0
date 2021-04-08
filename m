Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 223C2C433ED
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Apr 2021 07:19:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA4E861182
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Apr 2021 07:19:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbhDHHTb (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 8 Apr 2021 03:19:31 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:16080 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbhDHHTa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 8 Apr 2021 03:19:30 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FGCJ271Msz1BGFm;
        Thu,  8 Apr 2021 15:17:06 +0800 (CST)
Received: from huawei.com (10.175.113.32) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.498.0; Thu, 8 Apr 2021
 15:19:08 +0800
From:   Shixin Liu <liushixin2@huawei.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "Alexandre Torgue" <alexandre.torgue@foss.st.com>
CC:     <linux-crypto@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Shixin Liu <liushixin2@huawei.com>
Subject: [PATCH -next 4/7] crypto: stm32/hash - Fix PM reference leak on stm32-hash.c
Date:   Thu, 8 Apr 2021 15:18:35 +0800
Message-ID: <20210408071835.836791-1-liushixin2@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.32]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

pm_runtime_get_sync will increment pm usage counter even it failed.
Forgetting to putting operation will result in reference leak here.
Fix it by replacing it with pm_runtime_resume_and_get to keep usage
counter balanced.

Signed-off-by: Shixin Liu <liushixin2@huawei.com>
---
 drivers/crypto/stm32/stm32-hash.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-hash.c b/drivers/crypto/stm32/stm32-hash.c
index 7ac0573ef663..389de9e3302d 100644
--- a/drivers/crypto/stm32/stm32-hash.c
+++ b/drivers/crypto/stm32/stm32-hash.c
@@ -813,7 +813,7 @@ static void stm32_hash_finish_req(struct ahash_request *req, int err)
 static int stm32_hash_hw_init(struct stm32_hash_dev *hdev,
 			      struct stm32_hash_request_ctx *rctx)
 {
-	pm_runtime_get_sync(hdev->dev);
+	pm_runtime_resume_and_get(hdev->dev);
 
 	if (!(HASH_FLAGS_INIT & hdev->flags)) {
 		stm32_hash_write(hdev, HASH_CR, HASH_CR_INIT);
@@ -962,7 +962,7 @@ static int stm32_hash_export(struct ahash_request *req, void *out)
 	u32 *preg;
 	unsigned int i;
 
-	pm_runtime_get_sync(hdev->dev);
+	pm_runtime_resume_and_get(hdev->dev);
 
 	while ((stm32_hash_read(hdev, HASH_SR) & HASH_SR_BUSY))
 		cpu_relax();
@@ -1000,7 +1000,7 @@ static int stm32_hash_import(struct ahash_request *req, const void *in)
 
 	preg = rctx->hw_context;
 
-	pm_runtime_get_sync(hdev->dev);
+	pm_runtime_resume_and_get(hdev->dev);
 
 	stm32_hash_write(hdev, HASH_IMR, *preg++);
 	stm32_hash_write(hdev, HASH_STR, *preg++);
@@ -1566,7 +1566,7 @@ static int stm32_hash_remove(struct platform_device *pdev)
 	if (!hdev)
 		return -ENODEV;
 
-	ret = pm_runtime_get_sync(hdev->dev);
+	ret = pm_runtime_resume_and_get(hdev->dev);
 	if (ret < 0)
 		return ret;
 
-- 
2.25.1

