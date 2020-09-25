Return-Path: <SRS0=J/bj=DC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 014C6C4727D
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Sep 2020 14:09:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C580220936
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Sep 2020 14:09:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728995AbgIYOJB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Sep 2020 10:09:01 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:47126 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726990AbgIYOJB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Sep 2020 10:09:01 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 504C634EFF37630B7607;
        Fri, 25 Sep 2020 22:08:56 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Fri, 25 Sep 2020 22:08:49 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <xuzaibo@huawei.com>, <wangzhou1@hisilicon.com>
Subject: [PATCH RESEND 1/4] crypto: hisilicon/zip - fix the uncleared debug registers
Date:   Fri, 25 Sep 2020 22:06:14 +0800
Message-ID: <1601042777-26150-2-git-send-email-shenyang39@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1601042777-26150-1-git-send-email-shenyang39@huawei.com>
References: <1601042777-26150-1-git-send-email-shenyang39@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Hao Fang <fanghao11@huawei.com>

ZIP debug registers aren't cleared even if its driver is removed,
so add a clearing operation when remove driver.

Signed-off-by: Hao Fang <fanghao11@huawei.com>
Signed-off-by: Yang Shen <shenyang39@huawei.com>
Reviewed-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 drivers/crypto/hisilicon/zip/zip_main.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index bd53ee7..f10bf99 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -91,6 +91,11 @@
 #define HZIP_SQE_MASK_OFFSET		64
 #define HZIP_SQE_MASK_LEN		48
 
+#define HZIP_CNT_CLR_CE_EN		BIT(0)
+#define HZIP_RO_CNT_CLR_CE_EN		BIT(2)
+#define HZIP_RD_CNT_CLR_CE_EN		(HZIP_CNT_CLR_CE_EN | \
+					 HZIP_RO_CNT_CLR_CE_EN)
+
 static const char hisi_zip_name[] = "hisi_zip";
 static struct dentry *hzip_debugfs_root;
 
@@ -604,10 +609,23 @@ static int hisi_zip_debugfs_init(struct hisi_qm *qm)
 	return ret;
 }
 
+/* hisi_zip_debug_regs_clear() - clear the zip debug regs */
 static void hisi_zip_debug_regs_clear(struct hisi_qm *qm)
 {
+	int i, j;
+
+	/* clear current_qm */
 	writel(0x0, qm->io_base + QM_DFX_MB_CNT_VF);
 	writel(0x0, qm->io_base + QM_DFX_DB_CNT_VF);
+
+	/* enable register read_clear bit */
+	writel(HZIP_RD_CNT_CLR_CE_EN, qm->io_base + HZIP_SOFT_CTRL_CNT_CLR_CE);
+	for (i = 0; i < ARRAY_SIZE(core_offsets); i++)
+		for (j = 0; j < ARRAY_SIZE(hzip_dfx_regs); j++)
+			readl(qm->io_base + core_offsets[i] +
+			      hzip_dfx_regs[j].offset);
+
+	/* disable register read_clear bit */
 	writel(0x0, qm->io_base + HZIP_SOFT_CTRL_CNT_CLR_CE);
 
 	hisi_qm_debug_regs_clear(qm);
-- 
2.7.4

