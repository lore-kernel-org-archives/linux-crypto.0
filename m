Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13E8BC433B4
	for <linux-crypto@archiver.kernel.org>; Wed, 14 Apr 2021 09:17:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED75A611EE
	for <linux-crypto@archiver.kernel.org>; Wed, 14 Apr 2021 09:17:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232755AbhDNJRy (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 14 Apr 2021 05:17:54 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:15677 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232715AbhDNJRy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 14 Apr 2021 05:17:54 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FKxct19WTzpXfC;
        Wed, 14 Apr 2021 17:14:38 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.498.0; Wed, 14 Apr 2021 17:17:23 +0800
From:   Tian Tao <tiantao6@hisilicon.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, Tian Tao <tiantao6@hisilicon.com>
Subject: [PATCH] crypto: ccp - Fix to return the correct return value
Date:   Wed, 14 Apr 2021 17:17:44 +0800
Message-ID: <1618391864-55601-1-git-send-email-tiantao6@hisilicon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

ccp_dev_suspend and ccp_dev_resume return 0 on error, which causes
ret to equal 0 in sp_suspend and sp_resume, making the if condition
impossible to use.

Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
---
 drivers/crypto/ccp/ccp-dev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-dev.c b/drivers/crypto/ccp/ccp-dev.c
index 0971ee6..6f2af7b 100644
--- a/drivers/crypto/ccp/ccp-dev.c
+++ b/drivers/crypto/ccp/ccp-dev.c
@@ -556,7 +556,7 @@ int ccp_dev_suspend(struct sp_device *sp)
 
 	/* If there's no device there's nothing to do */
 	if (!ccp)
-		return 0;
+		return -ENXIO;
 
 	spin_lock_irqsave(&ccp->cmd_lock, flags);
 
@@ -584,7 +584,7 @@ int ccp_dev_resume(struct sp_device *sp)
 
 	/* If there's no device there's nothing to do */
 	if (!ccp)
-		return 0;
+		return -ENXIO;
 
 	spin_lock_irqsave(&ccp->cmd_lock, flags);
 
-- 
2.7.4

