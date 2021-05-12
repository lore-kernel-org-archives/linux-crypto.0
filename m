Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48D6AC433ED
	for <linux-crypto@archiver.kernel.org>; Wed, 12 May 2021 07:10:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B4E761260
	for <linux-crypto@archiver.kernel.org>; Wed, 12 May 2021 07:10:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbhELHLj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 May 2021 03:11:39 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:2637 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbhELHLj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 May 2021 03:11:39 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4Fg5V95T8Zzldbw;
        Wed, 12 May 2021 15:08:17 +0800 (CST)
Received: from linux-lmwb.huawei.com (10.175.103.112) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.498.0; Wed, 12 May 2021 15:10:19 +0800
From:   Zou Wei <zou_wei@huawei.com>
To:     <wangzhou1@hisilicon.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Zou Wei <zou_wei@huawei.com>
Subject: [PATCH -next v2] crypto: hisilicon - switch to memdup_user_nul()
Date:   Wed, 12 May 2021 15:27:19 +0800
Message-ID: <1620804439-21392-1-git-send-email-zou_wei@huawei.com>
X-Mailer: git-send-email 2.6.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.103.112]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use memdup_user_nul() helper instead of open-coding to
simplify the code.

v1-->v2:
   fixed patch title error

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index ce439a0..83a5d30 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -1570,17 +1570,10 @@ static ssize_t qm_cmd_write(struct file *filp, const char __user *buffer,
 	if (count > QM_DBG_WRITE_LEN)
 		return -ENOSPC;
 
-	cmd_buf = kzalloc(count + 1, GFP_KERNEL);
-	if (!cmd_buf)
+	cmd_buf = memdup_user_nul(buffer, count);
+	if (IS_ERR(cmd_buf))
 		return -ENOMEM;
 
-	if (copy_from_user(cmd_buf, buffer, count)) {
-		kfree(cmd_buf);
-		return -EFAULT;
-	}
-
-	cmd_buf[count] = '\0';
-
 	cmd_buf_tmp = strchr(cmd_buf, '\n');
 	if (cmd_buf_tmp) {
 		*cmd_buf_tmp = '\0';
-- 
2.6.2

