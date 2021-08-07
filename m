Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE741C4338F
	for <linux-crypto@archiver.kernel.org>; Sat,  7 Aug 2021 06:32:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D40C66101C
	for <linux-crypto@archiver.kernel.org>; Sat,  7 Aug 2021 06:32:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231357AbhHGGdO (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 7 Aug 2021 02:33:14 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:13293 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231309AbhHGGdO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 7 Aug 2021 02:33:14 -0400
Received: from dggeme768-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4GhXTX6Rhvz7ydp;
        Sat,  7 Aug 2021 14:28:00 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggeme768-chm.china.huawei.com (10.3.19.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sat, 7 Aug 2021 14:32:54 +0800
From:   Weili Qian <qianweili@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <wangzhou1@hisilicon.com>, <liulongfang@huawei.com>,
        Weili Qian <qianweili@huawei.com>
Subject: [PATCH 1/3] crypto: hisilicon - enable zip device clock gating
Date:   Sat, 7 Aug 2021 14:29:09 +0800
Message-ID: <1628317751-3396-2-git-send-email-qianweili@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1628317751-3396-1-git-send-email-qianweili@huawei.com>
References: <1628317751-3396-1-git-send-email-qianweili@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggeme768-chm.china.huawei.com (10.3.19.114)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Kunpeng930 zip device supports dynamic clock gating. When executing tasks,
the algorithm core is opened, and when idle, the algorithm core is closed.
This patch enables zip dynamic clock gating by writing hardware registers.

Signed-off-by: Weili Qian <qianweili@huawei.com>
---
 drivers/crypto/hisilicon/zip/zip_main.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index f8482ce..d1ca474 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -107,6 +107,14 @@
 #define HZIP_DELAY_1_US		1
 #define HZIP_POLL_TIMEOUT_US	1000
 
+/* clock gating */
+#define HZIP_PEH_CFG_AUTO_GATE		0x3011A8
+#define HZIP_PEH_CFG_AUTO_GATE_EN	BIT(0)
+#define HZIP_CORE_GATED_EN		GENMASK(15, 8)
+#define HZIP_CORE_GATED_OOO_EN		BIT(29)
+#define HZIP_CLOCK_GATED_EN		(HZIP_CORE_GATED_EN | \
+					 HZIP_CORE_GATED_OOO_EN)
+
 static const char hisi_zip_name[] = "hisi_zip";
 static struct dentry *hzip_debugfs_root;
 
@@ -312,6 +320,22 @@ static void hisi_zip_close_sva_prefetch(struct hisi_qm *qm)
 		pci_err(qm->pdev, "failed to close sva prefetch\n");
 }
 
+static void hisi_zip_enable_clock_gate(struct hisi_qm *qm)
+{
+	u32 val;
+
+	if (qm->ver < QM_HW_V3)
+		return;
+
+	val = readl(qm->io_base + HZIP_CLOCK_GATE_CTRL);
+	val |= HZIP_CLOCK_GATED_EN;
+	writel(val, qm->io_base + HZIP_CLOCK_GATE_CTRL);
+
+	val = readl(qm->io_base + HZIP_PEH_CFG_AUTO_GATE);
+	val |= HZIP_PEH_CFG_AUTO_GATE_EN;
+	writel(val, qm->io_base + HZIP_PEH_CFG_AUTO_GATE);
+}
+
 static int hisi_zip_set_user_domain_and_cache(struct hisi_qm *qm)
 {
 	void __iomem *base = qm->io_base;
@@ -359,6 +383,8 @@ static int hisi_zip_set_user_domain_and_cache(struct hisi_qm *qm)
 	       CQC_CACHE_WB_ENABLE | FIELD_PREP(SQC_CACHE_WB_THRD, 1) |
 	       FIELD_PREP(CQC_CACHE_WB_THRD, 1), base + QM_CACHE_CTL);
 
+	hisi_zip_enable_clock_gate(qm);
+
 	return 0;
 }
 
-- 
2.8.1

