Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 307D2C43460
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Apr 2021 12:00:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F21DC613BD
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Apr 2021 12:00:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343653AbhDFMAb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 6 Apr 2021 08:00:31 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:15611 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235453AbhDFMAa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Apr 2021 08:00:30 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FF5dG2Zkhz1BFPK;
        Tue,  6 Apr 2021 19:58:10 +0800 (CST)
Received: from mdc.localdomain (10.175.104.57) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.498.0; Tue, 6 Apr 2021 20:00:09 +0800
From:   Huang Guobin <huangguobin4@huawei.com>
To:     <huangguobin4@huawei.com>, "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>
CC:     <linux-geode@lists.infradead.org>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] crypto: geode -: use DEFINE_SPINLOCK() for spinlock
Date:   Tue, 6 Apr 2021 20:00:03 +0800
Message-ID: <1617710403-48471-1-git-send-email-huangguobin4@huawei.com>
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
 drivers/crypto/geode-aes.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
index 4ee010f39912..fa5a9f207bc9 100644
--- a/drivers/crypto/geode-aes.c
+++ b/drivers/crypto/geode-aes.c
@@ -21,7 +21,7 @@
 /* Static structures */
 
 static void __iomem *_iobase;
-static spinlock_t lock;
+static DEFINE_SPINLOCK(lock);
 
 /* Write a 128 bit field (either a writable key or IV) */
 static inline void
@@ -383,8 +383,6 @@ static int geode_aes_probe(struct pci_dev *dev, const struct pci_device_id *id)
 		goto erequest;
 	}
 
-	spin_lock_init(&lock);
-
 	/* Clear any pending activity */
 	iowrite32(AES_INTR_PENDING | AES_INTR_MASK, _iobase + AES_INTR_REG);
 

