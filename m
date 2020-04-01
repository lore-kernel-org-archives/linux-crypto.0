Return-Path: <SRS0=/HXT=5R=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D524C43331
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Apr 2020 12:13:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 13E9220776
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Apr 2020 12:13:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727661AbgDAMNU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 1 Apr 2020 08:13:20 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:12664 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727439AbgDAMNU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Apr 2020 08:13:20 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 0868D73DDF307F3E0398;
        Wed,  1 Apr 2020 20:13:17 +0800 (CST)
Received: from localhost (10.173.223.234) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.487.0; Wed, 1 Apr 2020
 20:13:08 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <ayush.sawal@chelsio.com>, <vinay.yadav@chelsio.com>,
        <rohitm@chelsio.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] crypto: chtls - Add missing include file <linux/highmem.h>
Date:   Wed, 1 Apr 2020 20:12:14 +0800
Message-ID: <20200401121214.34236-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.223.234]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

drivers/crypto/chelsio/chcr_ktls.c: In function ‘chcr_short_record_handler’:
drivers/crypto/chelsio/chcr_ktls.c:1770:12: error: implicit declaration of function ‘kmap_atomic’;
 did you mean ‘in_atomic’? [-Werror=implicit-function-declaration]
    vaddr = kmap_atomic(skb_frag_page(f));
            ^~~~~~~~~~~

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: dc05f3df8fac ("chcr: Handle first or middle part of record")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/crypto/chelsio/chcr_ktls.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/chelsio/chcr_ktls.c b/drivers/crypto/chelsio/chcr_ktls.c
index 73658b71d4a3..cd1769ecdc1c 100644
--- a/drivers/crypto/chelsio/chcr_ktls.c
+++ b/drivers/crypto/chelsio/chcr_ktls.c
@@ -2,6 +2,7 @@
 /* Copyright (C) 2020 Chelsio Communications.  All rights reserved. */
 
 #ifdef CONFIG_CHELSIO_TLS_DEVICE
+#include <linux/highmem.h>
 #include "chcr_ktls.h"
 #include "clip_tbl.h"
 
-- 
2.17.1


