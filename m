Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F974C433B4
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Apr 2021 12:03:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DAC761019
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Apr 2021 12:03:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238555AbhDFMDT (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 6 Apr 2021 08:03:19 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:15556 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235453AbhDFMDT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Apr 2021 08:03:19 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FF5gs1HXDzPnrd;
        Tue,  6 Apr 2021 20:00:25 +0800 (CST)
Received: from mdc.localdomain (10.175.104.57) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.498.0; Tue, 6 Apr 2021 20:03:02 +0800
From:   Huang Guobin <huangguobin4@huawei.com>
To:     <huangguobin4@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] crypto: ixp4xx -: use DEFINE_SPINLOCK() for spinlock
Date:   Tue, 6 Apr 2021 20:02:57 +0800
Message-ID: <1617710577-48660-1-git-send-email-huangguobin4@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.175.104.57]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Guobin Huang <huangguobin4@huawei.com>

spinlock can be initialized automatically with DEFINE_SPINLOCK()
rather than explicitly calling spin_lock_init().

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Guobin Huang <huangguobin4@huawei.com>
---
 drivers/crypto/ixp4xx_crypto.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index 8b0f17fc09fb..0616e369522e 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -265,7 +265,7 @@ static int setup_crypt_desc(void)
 	return 0;
 }
 
-static spinlock_t desc_lock;
+static DEFINE_SPINLOCK(desc_lock);
 static struct crypt_ctl *get_crypt_desc(void)
 {
 	int i;
@@ -293,7 +293,7 @@ static struct crypt_ctl *get_crypt_desc(void)
 	}
 }
 
-static spinlock_t emerg_lock;
+static DEFINE_SPINLOCK(emerg_lock);
 static struct crypt_ctl *get_crypt_desc_emerg(void)
 {
 	int i;
@@ -1379,9 +1379,6 @@ static int __init ixp_module_init(void)
 	if (IS_ERR(pdev))
 		return PTR_ERR(pdev);
 
-	spin_lock_init(&desc_lock);
-	spin_lock_init(&emerg_lock);
-
 	err = init_ixp_crypto(&pdev->dev);
 	if (err) {
 		platform_device_unregister(pdev);

