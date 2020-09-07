Return-Path: <SRS0=lAP7=CQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CABEC2BB84
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Sep 2020 08:25:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C3502166E
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Sep 2020 08:25:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728168AbgIGIZT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Sep 2020 04:25:19 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:10784 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728004AbgIGIYm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Sep 2020 04:24:42 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id F225D5B34AAA300B1629;
        Mon,  7 Sep 2020 16:24:34 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Mon, 7 Sep 2020 16:24:24 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <xuzaibo@huawei.com>, <wangzhou1@hisilicon.com>
Subject: [PATCH v2 04/10] crypto: hisilicon/zip - replace 'sprintf' with 'scnprintf'
Date:   Mon, 7 Sep 2020 16:21:56 +0800
Message-ID: <1599466922-10323-5-git-send-email-shenyang39@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1599466922-10323-1-git-send-email-shenyang39@huawei.com>
References: <1599466922-10323-1-git-send-email-shenyang39@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Replace 'sprintf' with 'scnprintf' to avoid overrun.

Signed-off-by: Yang Shen <shenyang39@huawei.com>
Reviewed-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 drivers/crypto/hisilicon/zip/zip_main.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index df1a16f..dd2c326 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -428,7 +428,7 @@ static ssize_t hisi_zip_ctrl_debug_read(struct file *filp, char __user *buf,
 		return -EINVAL;
 	}
 	spin_unlock_irq(&file->lock);
-	ret = sprintf(tbuf, "%u\n", val);
+	ret = scnprintf(tbuf, sizeof(tbuf), "%u\n", val);
 	return simple_read_from_buffer(buf, count, pos, tbuf, ret);
 }
 
@@ -518,9 +518,10 @@ static int hisi_zip_core_debug_init(struct hisi_qm *qm)
 
 	for (i = 0; i < HZIP_CORE_NUM; i++) {
 		if (i < HZIP_COMP_CORE_NUM)
-			sprintf(buf, "comp_core%d", i);
+			scnprintf(buf, sizeof(buf), "comp_core%d", i);
 		else
-			sprintf(buf, "decomp_core%d", i - HZIP_COMP_CORE_NUM);
+			scnprintf(buf, sizeof(buf), "decomp_core%d",
+				  i - HZIP_COMP_CORE_NUM);
 
 		regset = devm_kzalloc(dev, sizeof(*regset), GFP_KERNEL);
 		if (!regset)
-- 
2.7.4

