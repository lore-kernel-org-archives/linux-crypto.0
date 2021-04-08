Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBEC8C433B4
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Apr 2021 07:19:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BAC9F610D0
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Apr 2021 07:19:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbhDHHT3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 8 Apr 2021 03:19:29 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:16826 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbhDHHT1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 8 Apr 2021 03:19:27 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4FGCHz0Sf4z93fN;
        Thu,  8 Apr 2021 15:17:03 +0800 (CST)
Received: from huawei.com (10.175.113.32) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.498.0; Thu, 8 Apr 2021
 15:19:06 +0800
From:   Shixin Liu <liushixin2@huawei.com>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        "Jernej Skrabec" <jernej.skrabec@siol.net>
CC:     <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-sunxi@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
        Shixin Liu <liushixin2@huawei.com>
Subject: [PATCH -next 2/7] crypto: sun8i-ss - Fix PM reference leak when pm_runtime_get_sync() fails
Date:   Thu, 8 Apr 2021 15:18:32 +0800
Message-ID: <20210408071832.836691-1-liushixin2@huawei.com>
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
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c | 2 +-
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
index f945750b65d9..9ef1c85c4aaa 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
@@ -354,7 +354,7 @@ int sun8i_ss_cipher_init(struct crypto_tfm *tfm)
 	op->enginectx.op.prepare_request = NULL;
 	op->enginectx.op.unprepare_request = NULL;
 
-	err = pm_runtime_get_sync(op->ss->dev);
+	err = pm_runtime_resume_and_get(op->ss->dev);
 	if (err < 0) {
 		dev_err(op->ss->dev, "pm error %d\n", err);
 		goto error_pm;
diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
index e0ddc684798d..80e89066dbd1 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
@@ -753,7 +753,7 @@ static int sun8i_ss_probe(struct platform_device *pdev)
 	if (err)
 		goto error_alg;
 
-	err = pm_runtime_get_sync(ss->dev);
+	err = pm_runtime_resume_and_get(ss->dev);
 	if (err < 0)
 		goto error_alg;
 
-- 
2.25.1

