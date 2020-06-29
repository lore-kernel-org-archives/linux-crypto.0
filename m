Return-Path: <SRS0=qXKu=AK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0CAFC433E2
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jun 2020 21:14:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC1A92073E
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jun 2020 21:14:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730076AbgF2VOs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 29 Jun 2020 17:14:48 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:59518 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730075AbgF2S5D (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Jun 2020 14:57:03 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 36270B8D51D5EF15D635;
        Mon, 29 Jun 2020 19:10:58 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Mon, 29 Jun 2020 19:10:44 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>
Subject: [PATCH 1/9] crypto: hisilicon/qm - fix wrong release after using strsep
Date:   Mon, 29 Jun 2020 19:09:00 +0800
Message-ID: <1593428948-64634-2-git-send-email-shenyang39@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1593428948-64634-1-git-send-email-shenyang39@huawei.com>
References: <1593428948-64634-1-git-send-email-shenyang39@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Sihang Chen <chensihang1@hisilicon.com>

Save the string address before pass to strsep, release it at end.
Because strsep will update the string address to point after the
token.

Fixes: c31dc9fe165d("crypto: hisilicon/qm - add DebugFS for xQC and...")
Signed-off-by: Sihang Chen <chensihang1@huawei.com>
Signed-off-by: Shukun Tan <tanshukun1@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 9bb263c..ad0adcc 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -1429,16 +1429,17 @@ static int qm_dbg_help(struct hisi_qm *qm, char *s)
 static int qm_cmd_write_dump(struct hisi_qm *qm, const char *cmd_buf)
 {
 	struct device *dev = &qm->pdev->dev;
-	char *presult, *s;
+	char *presult, *s, *s_tmp;
 	int ret;
 
 	s = kstrdup(cmd_buf, GFP_KERNEL);
 	if (!s)
 		return -ENOMEM;
 
+	s_tmp = s;
 	presult = strsep(&s, " ");
 	if (!presult) {
-		kfree(s);
+		kfree(s_tmp);
 		return -EINVAL;
 	}
 
@@ -1468,7 +1469,7 @@ static int qm_cmd_write_dump(struct hisi_qm *qm, const char *cmd_buf)
 	if (ret)
 		dev_info(dev, "Please echo help\n");
 
-	kfree(s);
+	kfree(s_tmp);
 
 	return ret;
 }
-- 
2.7.4

