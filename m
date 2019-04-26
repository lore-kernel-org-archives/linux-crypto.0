Return-Path: <SRS0=Wqm9=S4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3087C43219
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Apr 2019 16:43:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C2B0208CA
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Apr 2019 16:43:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726353AbfDZQna (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Apr 2019 12:43:30 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:38512 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726252AbfDZQna (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Apr 2019 12:43:30 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 6C93494BAEAD3B25BDC9;
        Sat, 27 Apr 2019 00:43:28 +0800 (CST)
Received: from localhost (10.177.31.96) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.439.0; Sat, 27 Apr 2019
 00:43:17 +0800
From:   Yue Haibing <yuehaibing@huawei.com>
To:     <gilad@benyossef.com>, <herbert@gondor.apana.org.au>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <davem@davemloft.net>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] crypto: ccree - Make cc_sec_disable static
Date:   Sat, 27 Apr 2019 00:43:13 +0800
Message-ID: <20190426164313.32308-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

Fix sparse warning:

drivers/crypto/ccree/cc_driver.c:37:6: warning:
 symbol 'cc_sec_disable' was not declared. Should it be static?

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/crypto/ccree/cc_driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ccree/cc_driver.c b/drivers/crypto/ccree/cc_driver.c
index 902f196..4ea8e19 100644
--- a/drivers/crypto/ccree/cc_driver.c
+++ b/drivers/crypto/ccree/cc_driver.c
@@ -34,7 +34,7 @@ bool cc_dump_bytes;
 module_param_named(dump_bytes, cc_dump_bytes, bool, 0600);
 MODULE_PARM_DESC(cc_dump_bytes, "Dump buffers to kernel log as debugging aid");
 
-bool cc_sec_disable;
+static bool cc_sec_disable;
 module_param_named(sec_disable, cc_sec_disable, bool, 0600);
 MODULE_PARM_DESC(cc_sec_disable, "Disable security functions");
 
-- 
2.7.4


