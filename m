Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6515DC433DB
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Feb 2021 09:28:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CA7964F95
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Feb 2021 09:28:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233406AbhBCJ1u (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Feb 2021 04:27:50 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:12408 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233448AbhBCJZ6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Feb 2021 04:25:58 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4DVx8B0ZGszjHHh;
        Wed,  3 Feb 2021 17:24:10 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.498.0; Wed, 3 Feb 2021 17:25:09 +0800
From:   Tian Tao <tiantao6@hisilicon.com>
To:     <sumit.garg@linaro.org>, <herbert@gondor.apana.org.au>
CC:     <op-tee@lists.trustedfirmware.org>, <linux-crypto@vger.kernel.org>
Subject: [PATCH] hwrng: optee -: Use device-managed registration API
Date:   Wed, 3 Feb 2021 17:24:48 +0800
Message-ID: <1612344288-12201-1-git-send-email-tiantao6@hisilicon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use devm_hwrng_register to get rid of manual unregistration.

Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
---
 drivers/char/hw_random/optee-rng.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/optee-rng.c b/drivers/char/hw_random/optee-rng.c
index a99d829..135a825 100644
--- a/drivers/char/hw_random/optee-rng.c
+++ b/drivers/char/hw_random/optee-rng.c
@@ -243,7 +243,7 @@ static int optee_rng_probe(struct device *dev)
 	if (err)
 		goto out_sess;
 
-	err = hwrng_register(&pvt_data.optee_rng);
+	err = devm_hwrng_register(dev, &pvt_data.optee_rng);
 	if (err) {
 		dev_err(dev, "hwrng registration failed (%d)\n", err);
 		goto out_sess;
@@ -263,7 +263,6 @@ static int optee_rng_probe(struct device *dev)
 
 static int optee_rng_remove(struct device *dev)
 {
-	hwrng_unregister(&pvt_data.optee_rng);
 	tee_client_close_session(pvt_data.ctx, pvt_data.session_id);
 	tee_client_close_context(pvt_data.ctx);
 
-- 
2.7.4

