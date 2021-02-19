Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78735C433E0
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Feb 2021 11:21:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26D7164E92
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Feb 2021 11:21:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbhBSLVz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Feb 2021 06:21:55 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:12193 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230435AbhBSLUu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Feb 2021 06:20:50 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Dhpw46PpMzlMT3;
        Fri, 19 Feb 2021 19:17:56 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Fri, 19 Feb 2021 19:19:49 +0800
From:   Tian Tao <tiantao6@hisilicon.com>
To:     <dsaxena@plexity.net>, <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>
Subject: [PATCH] hwrng: omap - Fix included header from 'asm'
Date:   Fri, 19 Feb 2021 19:19:18 +0800
Message-ID: <1613733558-61854-1-git-send-email-tiantao6@hisilicon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This commit fixes the checkpatch warning:
WARNING: Use #include <linux/io.h> instead of <asm/io.h>
drivers/char/hw_random/omap-rng.c:34

Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
---
 drivers/char/hw_random/omap-rng.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/omap-rng.c b/drivers/char/hw_random/omap-rng.c
index 5cc5fc5..4380c23 100644
--- a/drivers/char/hw_random/omap-rng.c
+++ b/drivers/char/hw_random/omap-rng.c
@@ -30,8 +30,7 @@
 #include <linux/of_address.h>
 #include <linux/interrupt.h>
 #include <linux/clk.h>
-
-#include <asm/io.h>
+#include <linux/io.h>
 
 #define RNG_REG_STATUS_RDY			(1 << 0)
 
-- 
2.7.4

