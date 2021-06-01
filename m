Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DC4CC47080
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Jun 2021 14:37:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11E2A613B9
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Jun 2021 14:37:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234014AbhFAOjG (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Jun 2021 10:39:06 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:3375 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233797AbhFAOjE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Jun 2021 10:39:04 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4FvZQm6J35z64Q1;
        Tue,  1 Jun 2021 22:33:36 +0800 (CST)
Received: from dggema755-chm.china.huawei.com (10.1.198.197) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 1 Jun 2021 22:37:20 +0800
Received: from huawei.com (10.90.53.225) by dggema755-chm.china.huawei.com
 (10.1.198.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Tue, 1 Jun
 2021 22:37:20 +0800
From:   Zhang Qilong <zhangqilong3@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <pali@kernel.org>, <pavel@ucw.cz>, <linux-crypto@vger.kernel.org>
Subject: [PATCH -next 1/2] crypto: omap-des - using pm_runtime_resume_and_get instead of pm_runtime_get_sync
Date:   Tue, 1 Jun 2021 22:51:17 +0800
Message-ID: <20210601145118.126169-2-zhangqilong3@huawei.com>
X-Mailer: git-send-email 2.26.0.106.g9fadedd
In-Reply-To: <20210601145118.126169-1-zhangqilong3@huawei.com>
References: <20210601145118.126169-1-zhangqilong3@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.90.53.225]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggema755-chm.china.huawei.com (10.1.198.197)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Using pm_runtime_resume_and_get() to replace pm_runtime_get_sync and
pm_runtime_put_noidle. This change is just to simplify the code, no
actual functional changes.

Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
---
 drivers/crypto/omap-des.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
index c9d38bcfd1c7..bc8631363d72 100644
--- a/drivers/crypto/omap-des.c
+++ b/drivers/crypto/omap-des.c
@@ -229,9 +229,8 @@ static int omap_des_hw_init(struct omap_des_dev *dd)
 	 * It may be long delays between requests.
 	 * Device might go to off mode to save power.
 	 */
-	err = pm_runtime_get_sync(dd->dev);
+	err = pm_runtime_resume_and_get(dd->dev);
 	if (err < 0) {
-		pm_runtime_put_noidle(dd->dev);
 		dev_err(dd->dev, "%s: failed to get_sync(%d)\n", __func__, err);
 		return err;
 	}
@@ -994,9 +993,8 @@ static int omap_des_probe(struct platform_device *pdev)
 	pm_runtime_set_autosuspend_delay(dev, DEFAULT_AUTOSUSPEND_DELAY);
 
 	pm_runtime_enable(dev);
-	err = pm_runtime_get_sync(dev);
+	err = pm_runtime_resume_and_get(dev);
 	if (err < 0) {
-		pm_runtime_put_noidle(dev);
 		dev_err(dd->dev, "%s: failed to get_sync(%d)\n", __func__, err);
 		goto err_get;
 	}
@@ -1124,9 +1122,8 @@ static int omap_des_resume(struct device *dev)
 {
 	int err;
 
-	err = pm_runtime_get_sync(dev);
+	err = pm_runtime_resume_and_get(dev);
 	if (err < 0) {
-		pm_runtime_put_noidle(dev);
 		dev_err(dev, "%s: failed to get_sync(%d)\n", __func__, err);
 		return err;
 	}
-- 
2.17.1

