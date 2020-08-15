Return-Path: <SRS0=CHgJ=B2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5F91C433E5
	for <linux-crypto@archiver.kernel.org>; Sun, 16 Aug 2020 01:44:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A586920675
	for <linux-crypto@archiver.kernel.org>; Sun, 16 Aug 2020 01:44:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729494AbgHPBoT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 15 Aug 2020 21:44:19 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:33846 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729404AbgHPBoS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 15 Aug 2020 21:44:18 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id E344B9E201535795670E;
        Sat, 15 Aug 2020 17:58:28 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Sat, 15 Aug 2020 17:58:23 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <xuzaibo@huawei.com>, <wangzhou1@hisilicon.com>
Subject: [PATCH v5 01/10] crypto: hisilicon/qm - fix wrong release after using strsep
Date:   Sat, 15 Aug 2020 17:56:08 +0800
Message-ID: <1597485377-2678-2-git-send-email-shenyang39@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1597485377-2678-1-git-send-email-shenyang39@huawei.com>
References: <1597485377-2678-1-git-send-email-shenyang39@huawei.com>
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
Signed-off-by: Sihang Chen <chensihang1@hisilicon.com>
Signed-off-by: Yang Shen <shenyang39@huawei.com>
Reviewed-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 drivers/crypto/hisilicon/qm.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 6527c53..fb389c0 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -1420,17 +1420,18 @@ static int qm_dbg_help(struct hisi_qm *qm, char *s)
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
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err_buffer_free;
 	}
 
 	if (!strcmp(presult, "sqc"))
@@ -1459,7 +1460,8 @@ static int qm_cmd_write_dump(struct hisi_qm *qm, const char *cmd_buf)
 	if (ret)
 		dev_info(dev, "Please echo help\n");
 
-	kfree(s);
+err_buffer_free:
+	kfree(s_tmp);
 
 	return ret;
 }
-- 
2.7.4

