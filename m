Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A80A6C04A94
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Jul 2023 11:44:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235365AbjGNLoP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 14 Jul 2023 07:44:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235273AbjGNLoN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 Jul 2023 07:44:13 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D61830CB;
        Fri, 14 Jul 2023 04:44:11 -0700 (PDT)
Received: from kwepemm600009.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4R2V0g61F5zNm5n;
        Fri, 14 Jul 2023 19:40:51 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 kwepemm600009.china.huawei.com (7.193.23.164) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 14 Jul 2023 19:44:09 +0800
From:   Weili Qian <qianweili@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <liulongfang@huawei.com>
Subject: [PATCH 3/4] crypto: hisilicon/qm - increase device doorbell timeout
Date:   Fri, 14 Jul 2023 19:41:37 +0800
Message-ID: <20230714114138.1582-4-qianweili@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230714114138.1582-1-qianweili@huawei.com>
References: <20230714114138.1582-1-qianweili@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600009.china.huawei.com (7.193.23.164)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When both the accelerator device and SMMU are busy,
the processing time of the doorbell may be prolonged.
As a result, the doorbell may timeout, especially in the sva
scenario. Therefore, the doorbell timeout is increased.

Signed-off-by: Weili Qian <qianweili@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index fdff87c09aaf..a99fd589445c 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -88,6 +88,8 @@
 #define QM_DB_PRIORITY_SHIFT_V1		48
 #define QM_PAGE_SIZE			0x0034
 #define QM_QP_DB_INTERVAL		0x10000
+#define QM_DB_TIMEOUT_CFG		0x100074
+#define QM_DB_TIMEOUT_SET		0x1fffff
 
 #define QM_MEM_START_INIT		0x100040
 #define QM_MEM_INIT_DONE		0x100044
@@ -5381,6 +5383,8 @@ int hisi_qm_init(struct hisi_qm *qm)
 		goto err_pci_init;
 
 	if (qm->fun_type == QM_HW_PF) {
+		/* Set the doorbell timeout to QM_DB_TIMEOUT_CFG ns. */
+		writel(QM_DB_TIMEOUT_SET, qm->io_base + QM_DB_TIMEOUT_CFG);
 		qm_disable_clock_gate(qm);
 		ret = qm_dev_mem_reset(qm);
 		if (ret) {
@@ -5548,6 +5552,8 @@ static int qm_rebuild_for_resume(struct hisi_qm *qm)
 
 	qm_cmd_init(qm);
 	hisi_qm_dev_err_init(qm);
+	/* Set the doorbell timeout to QM_DB_TIMEOUT_CFG ns. */
+	writel(QM_DB_TIMEOUT_SET, qm->io_base + QM_DB_TIMEOUT_CFG);
 	qm_disable_clock_gate(qm);
 	ret = qm_dev_mem_reset(qm);
 	if (ret)
-- 
2.33.0

