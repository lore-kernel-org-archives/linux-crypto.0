Return-Path: <SRS0=yJek=4W=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7F53C3F2D1
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Mar 2020 02:10:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC74A20866
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Mar 2020 02:10:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726079AbgCECKP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 4 Mar 2020 21:10:15 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:10727 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726004AbgCECKN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 Mar 2020 21:10:13 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 10BF391CC35432D2C8FB;
        Thu,  5 Mar 2020 10:10:10 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.439.0; Thu, 5 Mar 2020 10:10:01 +0800
From:   Zaibo Xu <xuzaibo@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <linuxarm@huawei.com>,
        <jonathan.cameron@huawei.com>, <wangzhou1@hisilicon.com>,
        <tanghui20@huawei.com>, <yekai13@huawei.com>,
        <liulongfang@huawei.com>, <qianweili@huawei.com>,
        <zhangwei375@huawei.com>, <fanghao11@huawei.com>,
        <forest.zhouchang@huawei.com>
Subject: [PATCH v3 3/5] crypto: hisilicon/sec2 - Add iommu status check
Date:   Thu, 5 Mar 2020 10:06:23 +0800
Message-ID: <1583373985-718-4-git-send-email-xuzaibo@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1583373985-718-1-git-send-email-xuzaibo@huawei.com>
References: <1583373985-718-1-git-send-email-xuzaibo@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Longfang Liu <liulongfang@huawei.com>

In order to improve performance of small packets (<512Bytes)
in SMMU translation scenario, we need to identify the type of IOMMU
in the SEC probe to process small packets by a different method.

Signed-off-by: Longfang Liu <liulongfang@huawei.com>
Signed-off-by: Zaibo Xu <xuzaibo@huawei.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
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
index 1fe2558..4f354d7 100644
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
@@ -832,6 +833,23 @@ static void sec_probe_uninit(struct hisi_qm *qm)
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
@@ -845,6 +863,7 @@ static int sec_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	pci_set_drvdata(pdev, sec);
 
 	sec->ctx_q_num = ctx_q_num;
+	sec_iommu_used_check(sec);
 
 	qm = &sec->qm;
 
-- 
2.8.1

