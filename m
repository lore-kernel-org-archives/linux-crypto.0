Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B7FEC433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Feb 2022 00:55:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232065AbiBOAzU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Feb 2022 19:55:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231485AbiBOAzT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Feb 2022 19:55:19 -0500
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5525BB40;
        Mon, 14 Feb 2022 16:55:10 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0V4VOuCZ_1644886507;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0V4VOuCZ_1644886507)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 15 Feb 2022 08:55:07 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     mpm@selenic.com
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next] hwrng: core: Remove duplicated include in core.c
Date:   Tue, 15 Feb 2022 08:55:05 +0800
Message-Id: <20220215005505.80430-1-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fix following includecheck warning:
./drivers/char/hw_random/core.c: linux/random.h is included more than
once.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/char/hw_random/core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index be2953aa5145..94626f533361 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -21,7 +21,6 @@
 #include <linux/sched/signal.h>
 #include <linux/miscdevice.h>
 #include <linux/module.h>
-#include <linux/random.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
-- 
2.20.1.7.g153144c

