Return-Path: <SRS0=ICHr=4I=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 568CDC11D04
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Feb 2020 09:09:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35C2024654
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Feb 2020 09:09:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbgBTJJJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 Feb 2020 04:09:09 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:56070 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726830AbgBTJJI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Feb 2020 04:09:08 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 3FF0DB8C96B5440A7545;
        Thu, 20 Feb 2020 17:09:06 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.439.0; Thu, 20 Feb 2020 17:08:57 +0800
From:   Zaibo Xu <xuzaibo@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <wangzhou1@hisilicon.com>,
        <linuxarm@huawei.com>, <fanghao11@huawei.com>,
        <yekai13@huawei.com>, <tanshukun1@huawei.com>,
        <qianweili@huawei.com>, <shenyang39@huawei.com>,
        <zhangwei375@huawei.com>, <tanghui20@huawei.com>,
        <liulongfang@huawei.com>, <forest.zhouchang@huawei.com>
Subject: [PATCH 3/4] crypto: hisilicon/sec2 - Add iommu status check
Date:   Thu, 20 Feb 2020 17:04:54 +0800
Message-ID: <1582189495-38051-4-git-send-email-xuzaibo@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1582189495-38051-1-git-send-email-xuzaibo@huawei.com>
References: <1582189495-38051-1-git-send-email-xuzaibo@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: liulongfang <liulongfang@huawei.com>

In order to improve performance of small packets (<512Bytes)
in SMMU translation scenario,We need to identify the type of IOMMU
in the SEC probe to process small packets by a different method.

Signed-off-by: liulongfang <liulongfang@huawei.com>
Signed-off-by: Zaibo Xu <xuzaibo@huawei.com>
---
 drivers/crypto/hisilicon/sec2/sec.h      |  1 +
 drivers/crypto/hisilicon/sec2/sec_main.c | 19 +++++++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/drivers/crypto/hisilicon/sec2/sec.h b/drivers/crypto/hisilicon/sec2/sec.h
index 13e2d8d..eab0d22 100644
--- a/drivers/crypto/hisilicon/sec2/sec.h
+++ b/drivers/crypto/hisilicon/sec2/sec.h
@@ -165,6 +165,7 @@ struct sec_dev {
 	struct list_head list;
 	struct sec_debug debug;
 	u32 ctx_q_num;
+	bool iommu_used;
 	u32 num_vfs;
 	unsigned long status;
 };
diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index ebafc1c..6466d90 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -7,6 +7,7 @@
 #include <linux/debugfs.h>
 #include <linux/init.h>
 #include <linux/io.h>
+#include <linux/iommu.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/pci.h>
@@ -826,6 +827,23 @@ static void sec_probe_uninit(struct hisi_qm *qm)
 	destroy_workqueue(qm->wq);
 }
 
+static void sec_iommu_used_check(struct sec_dev *sec)
+{
+	struct iommu_domain *domain;
+	struct device *dev = &sec->qm.pdev->dev;
+
+	domain = iommu_get_domain_for_dev(dev);
+
+	/* Check if iommu is used */
+	sec->iommu_used = false;
+	if (domain) {
+		if (domain->type & __IOMMU_DOMAIN_PAGING)
+			sec->iommu_used = true;
+		dev_info(dev, "SMMU Opened, the iommu type = %u\n",
+			domain->type);
+	}
+}
+
 static int sec_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct sec_dev *sec;
@@ -839,6 +857,7 @@ static int sec_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	pci_set_drvdata(pdev, sec);
 
 	sec->ctx_q_num = ctx_q_num;
+	sec_iommu_used_check(sec);
 
 	qm = &sec->qm;
 
-- 
2.8.1

