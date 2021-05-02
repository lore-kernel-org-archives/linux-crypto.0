Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DDF3C43603
	for <linux-crypto@archiver.kernel.org>; Sun,  2 May 2021 14:05:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3388E613E4
	for <linux-crypto@archiver.kernel.org>; Sun,  2 May 2021 14:05:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233502AbhEBOGi (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 2 May 2021 10:06:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:51998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233286AbhEBOGH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 2 May 2021 10:06:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D03BA613E1;
        Sun,  2 May 2021 14:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619964314;
        bh=DJ6lTPQfh2oqjFCxz6P1fQUvpi4zL4U2WFI9R1UsHcc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tRRntkEOP2atcBhwWqzNIo9vEdPJNPWZ4zn+k5y6pTDrhUoJJTwtnuDfSL8y/Xm3F
         L9i/8SEpLPNGqRhfBvJY4xGWEMMKUACdEhEgKtOmjt363tpJcvkFuQumbR8UMf2XWV
         LgzbxsEDYFnnqiXIBH3bktxohV/SAVUi2OB97c/ChXenRdlVFRGENwXOabo9JnEjZX
         oftps/jaGsV6DFohSUrthOBTemjvpS5qpb40hTleQntq6+D99Ir5IcdGjhbEYVcP4z
         1Pku/+77gbQUUvqTQ8X6s43YDLJIc6jklxRRH2ZqMnFx/wFW88Z89eYtVCsk8URj/0
         c5jBKBx1AVrEg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shixin Liu <liushixin2@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 32/34] crypto: omap-aes - Fix PM reference leak on omap-aes.c
Date:   Sun,  2 May 2021 10:04:32 -0400
Message-Id: <20210502140434.2719553-32-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502140434.2719553-1-sashal@kernel.org>
References: <20210502140434.2719553-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Shixin Liu <liushixin2@huawei.com>

[ Upstream commit 1f34cc4a8da34fbb250efb928f9b8c6fe7ee0642 ]

pm_runtime_get_sync will increment pm usage counter even it failed.
Forgetting to putting operation will result in reference leak here.
Fix it by replacing it with pm_runtime_resume_and_get to keep usage
counter balanced.

Signed-off-by: Shixin Liu <liushixin2@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/omap-aes.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index 103e704c1469..72edb10181b8 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -103,7 +103,7 @@ static int omap_aes_hw_init(struct omap_aes_dev *dd)
 		dd->err = 0;
 	}
 
-	err = pm_runtime_get_sync(dd->dev);
+	err = pm_runtime_resume_and_get(dd->dev);
 	if (err < 0) {
 		dev_err(dd->dev, "failed to get sync: %d\n", err);
 		return err;
@@ -1153,7 +1153,7 @@ static int omap_aes_probe(struct platform_device *pdev)
 	pm_runtime_set_autosuspend_delay(dev, DEFAULT_AUTOSUSPEND_DELAY);
 
 	pm_runtime_enable(dev);
-	err = pm_runtime_get_sync(dev);
+	err = pm_runtime_resume_and_get(dev);
 	if (err < 0) {
 		dev_err(dev, "%s: failed to get_sync(%d)\n",
 			__func__, err);
@@ -1318,7 +1318,7 @@ static int omap_aes_suspend(struct device *dev)
 
 static int omap_aes_resume(struct device *dev)
 {
-	pm_runtime_get_sync(dev);
+	pm_runtime_resume_and_get(dev);
 	return 0;
 }
 #endif
-- 
2.30.2

