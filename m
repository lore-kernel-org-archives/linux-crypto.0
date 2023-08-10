Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A10DCC001E0
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Aug 2023 13:01:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231600AbjHJNBQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Aug 2023 09:01:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235254AbjHJNBQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Aug 2023 09:01:16 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C67082691
        for <linux-crypto@vger.kernel.org>; Thu, 10 Aug 2023 06:01:14 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4RM6Qv67C0zCrW3;
        Thu, 10 Aug 2023 20:57:43 +0800 (CST)
Received: from huawei.com (10.67.175.31) by dggpemm500024.china.huawei.com
 (7.185.36.203) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Thu, 10 Aug
 2023 21:01:12 +0800
From:   GUO Zihua <guozihua@huawei.com>
To:     <herbert@gondor.apana.org.au>, <olivia@selenic.com>
CC:     <linux-crypto@vger.kernel.org>
Subject: [PATCH -next v2] hwrng: Remove duplicated include
Date:   Thu, 10 Aug 2023 21:00:43 +0800
Message-ID: <20230810130043.19216-1-guozihua@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.175.31]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500024.china.huawei.com (7.185.36.203)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Remove duplicated include of linux/random.h. Resolves checkincludes
message. And adjust includes in alphabetical order.

Signed-off-by: GUO Zihua <guozihua@huawei.com>

---

v2:
  Adjust incldues in alphabetical order as well.
---
 drivers/char/hw_random/core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index f34d356fe2c0..e3598ec9cfca 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -15,14 +15,13 @@
 #include <linux/err.h>
 #include <linux/fs.h>
 #include <linux/hw_random.h>
-#include <linux/random.h>
 #include <linux/kernel.h>
 #include <linux/kthread.h>
-#include <linux/sched/signal.h>
 #include <linux/miscdevice.h>
 #include <linux/module.h>
 #include <linux/random.h>
 #include <linux/sched.h>
+#include <linux/sched/signal.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
 
-- 
2.17.1

