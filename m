Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B373CC433B4
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Apr 2021 03:21:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8066761186
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Apr 2021 03:21:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbhDHDVq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 7 Apr 2021 23:21:46 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:15958 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbhDHDVp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Apr 2021 23:21:45 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FG61k1nkkzyNXH;
        Thu,  8 Apr 2021 11:19:22 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.498.0; Thu, 8 Apr 2021 11:21:26 +0800
From:   Tian Tao <tiantao6@hisilicon.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, Tian Tao <tiantao6@hisilicon.com>,
        "Zhiqi Song" <songzhiqi1@huawei.com>
Subject: [PATCH] crypto: cavium - remove unused including <linux/version.h>
Date:   Thu, 8 Apr 2021 11:21:51 +0800
Message-ID: <1617852111-26441-1-git-send-email-tiantao6@hisilicon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Remove including <linux/version.h> that don't need it.

Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
Signed-off-by: Zhiqi Song <songzhiqi1@huawei.com>
---
 drivers/crypto/cavium/zip/common.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/cavium/zip/common.h b/drivers/crypto/cavium/zip/common.h
index 58fb3ed..54f6fb0 100644
--- a/drivers/crypto/cavium/zip/common.h
+++ b/drivers/crypto/cavium/zip/common.h
@@ -56,7 +56,6 @@
 #include <linux/seq_file.h>
 #include <linux/string.h>
 #include <linux/types.h>
-#include <linux/version.h>
 
 /* Device specific zlib function definitions */
 #include "zip_device.h"
-- 
2.7.4

