Return-Path: <SRS0=lAP7=CQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20A53C433E2
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Sep 2020 08:25:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E173E215A4
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Sep 2020 08:25:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728056AbgIGIYm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Sep 2020 04:24:42 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:10778 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727970AbgIGIYj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Sep 2020 04:24:39 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id DAD722C7C1FDC1E444CD;
        Mon,  7 Sep 2020 16:24:34 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Mon, 7 Sep 2020 16:24:23 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <xuzaibo@huawei.com>, <wangzhou1@hisilicon.com>
Subject: [PATCH v2 01/10] crypto: hisilicon/zip - remove some useless parameters
Date:   Mon, 7 Sep 2020 16:21:53 +0800
Message-ID: <1599466922-10323-2-git-send-email-shenyang39@huawei.com>
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

1.Remove the macro 'HZIP_VF_NUM'.
2.Remove 'list' of the struct 'hisi_zip'

Signed-off-by: Yang Shen <shenyang39@huawei.com>
Reviewed-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 drivers/crypto/hisilicon/zip/zip.h      | 1 -
 drivers/crypto/hisilicon/zip/zip_main.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/crypto/hisilicon/zip/zip.h b/drivers/crypto/hisilicon/zip/zip.h
index 4484be1..4b3aae8 100644
--- a/drivers/crypto/hisilicon/zip/zip.h
+++ b/drivers/crypto/hisilicon/zip/zip.h
@@ -39,7 +39,6 @@ struct hisi_zip_ctrl;
 
 struct hisi_zip {
 	struct hisi_qm qm;
-	struct list_head list;
 	struct hisi_zip_ctrl *ctrl;
 	struct hisi_zip_dfx dfx;
 };
diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index 7e86b0f..445db04 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -17,7 +17,6 @@
 #define PCI_DEVICE_ID_ZIP_PF		0xa250
 #define PCI_DEVICE_ID_ZIP_VF		0xa251
 
-#define HZIP_VF_NUM			63
 #define HZIP_QUEUE_NUM_V1		4096
 #define HZIP_QUEUE_NUM_V2		1024
 
-- 
2.7.4

