Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C3A6C433E9
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Jan 2021 06:19:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3186E227C3
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Jan 2021 06:19:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725766AbhAEGTq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Jan 2021 01:19:46 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:9670 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbhAEGTq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Jan 2021 01:19:46 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4D92Nd2j10z15pCm;
        Tue,  5 Jan 2021 14:17:53 +0800 (CST)
Received: from huawei.com (10.67.165.24) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.498.0; Tue, 5 Jan 2021
 14:18:43 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] crypto: hisilicon/sec - register SEC device to uacce
Date:   Tue, 5 Jan 2021 14:16:44 +0800
Message-ID: <1609827404-6024-4-git-send-email-yekai13@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1609827404-6024-1-git-send-email-yekai13@huawei.com>
References: <1609827404-6024-1-git-send-email-yekai13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Register SEC device to uacce framework for user space.

Signed-off-by: Kai Ye <yekai13@huawei.com>
Reviewed-by: Zhou Wang <wangzhou1@hisilicon.com>
Reviewed-by: Zaibo Xu <xuzaibo@huawei.com>
---
 drivers/crypto/hisilicon/sec2/sec_main.c | 39 +++++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index b35c1c2..4809c19 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -13,6 +13,7 @@
 #include <linux/pci.h>
 #include <linux/seq_file.h>
 #include <linux/topology.h>
+#include <linux/uacce.h>
 
 #include "sec.h"
 
@@ -74,6 +75,16 @@
 
 #define SEC_USER0_SMMU_NORMAL		(BIT(23) | BIT(15))
 #define SEC_USER1_SMMU_NORMAL		(BIT(31) | BIT(23) | BIT(15) | BIT(7))
+#define SEC_USER1_ENABLE_CONTEXT_SSV	BIT(24)
+#define SEC_USER1_ENABLE_DATA_SSV	BIT(16)
+#define SEC_USER1_WB_CONTEXT_SSV	BIT(8)
+#define SEC_USER1_WB_DATA_SSV		BIT(0)
+#define SEC_USER1_SVA_SET		(SEC_USER1_ENABLE_CONTEXT_SSV | \
+					SEC_USER1_ENABLE_DATA_SSV | \
+					SEC_USER1_WB_CONTEXT_SSV |  \
+					SEC_USER1_WB_DATA_SSV)
+#define SEC_USER1_SMMU_SVA		(SEC_USER1_SMMU_NORMAL | SEC_USER1_SVA_SET)
+#define SEC_USER1_SMMU_MASK		(~SEC_USER1_SVA_SET)
 #define SEC_CORE_INT_STATUS_M_ECC	BIT(2)
 
 #define SEC_DELAY_10_US			10
@@ -233,6 +244,18 @@ struct hisi_qp **sec_create_qps(void)
 	return NULL;
 }
 
+static const struct kernel_param_ops sec_uacce_mode_ops = {
+	.set = uacce_mode_set,
+	.get = param_get_int,
+};
+
+/*
+ * uacce_mode = 0 means sec only register to crypto,
+ * uacce_mode = 1 means sec both register to crypto and uacce.
+ */
+static u32 uacce_mode = UACCE_MODE_NOUACCE;
+module_param_cb(uacce_mode, &sec_uacce_mode_ops, &uacce_mode, 0444);
+MODULE_PARM_DESC(uacce_mode, UACCE_MODE_DESC);
 
 static const struct pci_device_id sec_dev_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_HUAWEI, SEC_PF_PCI_DEVICE_ID) },
@@ -299,7 +322,11 @@ static int sec_engine_init(struct hisi_qm *qm)
 	writel_relaxed(reg, SEC_ADDR(qm, SEC_INTERFACE_USER_CTRL0_REG));
 
 	reg = readl_relaxed(SEC_ADDR(qm, SEC_INTERFACE_USER_CTRL1_REG));
-	reg |= SEC_USER1_SMMU_NORMAL;
+	reg &= SEC_USER1_SMMU_MASK;
+	if (qm->use_sva)
+		reg |= SEC_USER1_SMMU_SVA;
+	else
+		reg |= SEC_USER1_SMMU_NORMAL;
 	writel_relaxed(reg, SEC_ADDR(qm, SEC_INTERFACE_USER_CTRL1_REG));
 
 	writel(SEC_SINGLE_PORT_MAX_TRANS,
@@ -758,6 +785,8 @@ static int sec_qm_init(struct hisi_qm *qm, struct pci_dev *pdev)
 
 	qm->pdev = pdev;
 	qm->ver = pdev->revision;
+	qm->algs = "cipher\ndigest\naead\n";
+	qm->mode = uacce_mode;
 	qm->sqe_size = SEC_SQE_SIZE;
 	qm->dev_name = sec_name;
 
@@ -885,6 +914,14 @@ static int sec_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err_qm_stop;
 	}
 
+	if (qm->uacce) {
+		ret = uacce_register(qm->uacce);
+		if (ret) {
+			pci_err(pdev, "failed to register uacce (%d)!\n", ret);
+			goto err_alg_unregister;
+		}
+	}
+
 	if (qm->fun_type == QM_HW_PF && vfs_num) {
 		ret = hisi_qm_sriov_enable(pdev, vfs_num);
 		if (ret < 0)
-- 
2.8.1

