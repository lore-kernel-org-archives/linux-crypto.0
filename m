Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66D38C2D0E4
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Nov 2020 13:36:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18AF8204EC
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Nov 2020 13:36:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730127AbgKWNgc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 23 Nov 2020 08:36:32 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7668 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730212AbgKWNgb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Nov 2020 08:36:31 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Cfp893mkwz15QRj;
        Mon, 23 Nov 2020 21:36:09 +0800 (CST)
Received: from huawei.com (10.175.124.27) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.487.0; Mon, 23 Nov 2020
 21:36:27 +0800
From:   Wang Xiaojun <wangxiaojun11@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: omap-sham - fix several reference count leaks due to pm_runtime_get_sync
Date:   Mon, 23 Nov 2020 21:41:15 +0800
Message-ID: <20201123134115.2702127-1-wangxiaojun11@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On calling pm_runtime_get_sync() the reference count of the device
is incremented. In case of failure, should decrement the reference
count before returning the error. So we fixed it by replacing it
with pm_runtime_resume_and_get.

Signed-off-by: Wang Xiaojun <wangxiaojun11@huawei.com>
---
 drivers/crypto/omap-sham.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index a3b38d2c92e7..4a4da0cc444c 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -371,7 +371,7 @@ static int omap_sham_hw_init(struct omap_sham_dev *dd)
 {
 	int err;
 
-	err = pm_runtime_get_sync(dd->dev);
+	err = pm_runtime_resume_and_get(dd->dev);
 	if (err < 0) {
 		dev_err(dd->dev, "failed to get sync: %d\n", err);
 		return err;
@@ -2130,7 +2130,7 @@ static int omap_sham_probe(struct platform_device *pdev)
 	pm_runtime_enable(dev);
 	pm_runtime_irq_safe(dev);
 
-	err = pm_runtime_get_sync(dev);
+	err = pm_runtime_resume_and_get(dev);
 	if (err < 0) {
 		dev_err(dev, "failed to get sync: %d\n", err);
 		goto err_pm;
@@ -2243,7 +2243,7 @@ static int omap_sham_suspend(struct device *dev)
 
 static int omap_sham_resume(struct device *dev)
 {
-	int err = pm_runtime_get_sync(dev);
+	int err = pm_runtime_resume_and_get(dev);
 	if (err < 0) {
 		dev_err(dev, "failed to get sync: %d\n", err);
 		return err;
-- 
2.25.1

