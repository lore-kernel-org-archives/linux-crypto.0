Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AAA3C00528
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Aug 2023 09:30:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233496AbjHCJaq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 3 Aug 2023 05:30:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235072AbjHCJaT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Aug 2023 05:30:19 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11B4FE48
        for <linux-crypto@vger.kernel.org>; Thu,  3 Aug 2023 02:30:15 -0700 (PDT)
Received: from kwepemi500008.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4RGk6d0Rg3zVjtJ;
        Thu,  3 Aug 2023 17:28:25 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemi500008.china.huawei.com
 (7.221.188.139) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Thu, 3 Aug
 2023 17:30:10 +0800
From:   Ruan Jinjie <ruanjinjie@huawei.com>
To:     <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC:     <ruanjinjie@huawei.com>
Subject: [PATCH -next] crypto: hisilicon/sec - Do not check for 0 return after calling platform_get_irq()
Date:   Thu, 3 Aug 2023 17:29:33 +0800
Message-ID: <20230803092933.720749-1-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemi500008.china.huawei.com (7.221.188.139)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Since commit ce753ad1549c ("platform: finally disallow IRQ0 in
platform_get_irq() and its ilk"), there is no possible for
platform_get_irq() to return 0. Use the return value
from platform_get_irq().

Signed-off-by: Ruan Jinjie <ruanjinjie@huawei.com>
---
 drivers/crypto/hisilicon/sec/sec_drv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec/sec_drv.c b/drivers/crypto/hisilicon/sec/sec_drv.c
index e75851326c1e..e1e08993de12 100644
--- a/drivers/crypto/hisilicon/sec/sec_drv.c
+++ b/drivers/crypto/hisilicon/sec/sec_drv.c
@@ -1107,8 +1107,8 @@ static int sec_queue_res_cfg(struct sec_queue *queue)
 	}
 	queue->task_irq = platform_get_irq(to_platform_device(dev),
 					   queue->queue_id * 2 + 1);
-	if (queue->task_irq <= 0) {
-		ret = -EINVAL;
+	if (queue->task_irq < 0) {
+		ret = queue->task_irq;
 		goto err_free_ring_db;
 	}
 
-- 
2.34.1

