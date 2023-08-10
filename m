Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F553C001B0
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Aug 2023 11:59:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbjHJL73 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Aug 2023 07:59:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbjHJL73 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Aug 2023 07:59:29 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5E84E4B
        for <linux-crypto@vger.kernel.org>; Thu, 10 Aug 2023 04:59:28 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4RM56C2cxBz1L9p5;
        Thu, 10 Aug 2023 19:58:11 +0800 (CST)
Received: from huawei.com (10.67.175.31) by dggpemm500024.china.huawei.com
 (7.185.36.203) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Thu, 10 Aug
 2023 19:59:23 +0800
From:   GUO Zihua <guozihua@huawei.com>
To:     <olivia@selenic.com>, <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>
Subject: [PATCH -next] hwrng: Remove duplicated include
Date:   Thu, 10 Aug 2023 19:58:58 +0800
Message-ID: <20230810115858.24735-1-guozihua@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.175.31]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500024.china.huawei.com (7.185.36.203)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Remove duplicated include of linux/random.h. Resolves checkincludes
message.

Signed-off-by: GUO Zihua <guozihua@huawei.com>
---
 drivers/char/hw_random/core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index f34d356fe2c0..ead998ca0c40 100644
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
2.17.1

