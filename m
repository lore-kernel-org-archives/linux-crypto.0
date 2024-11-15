Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E314E1A3035;
	Fri, 15 Nov 2024 11:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731670043; cv=none; b=shOhh6PHlhxOZiPdQBfcP6sP6B+7/JV6Y1+lrxzup4Hord3XfGRA053WWdjW8HRp7pXLT3GQjT09WUyI2fQyMHyJtpvZR0Roc/y7SCaD0yqnO1AnJucPq4eBVwyKW2jYL/9thn7+lbWiMb0txyQLLE33a7Rf3CGHmsWTMD9HMV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731670043; c=relaxed/simple;
	bh=6WvGI5zZn1ofoJGqkpPQMx1SGOxvpm7XzqzAjOakUBQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iIQA7INieMCXohidfoFlZy6SEoGhJxrntXKcKbtByh3pFaqyJUUygb4ujSz9QN4BGH2MbRXFG41kKauISHCtGcmhMywhIzeoP7STsr5JPl9MrZE/6BIOYSHVw1lH5WRMidqDDimHB9JKgu1DWgIw+/qWmrJoO2Opkw0E2skytwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4XqZSh5nDhz1T4fR;
	Fri, 15 Nov 2024 19:25:24 +0800 (CST)
Received: from kwepemk500010.china.huawei.com (unknown [7.202.194.95])
	by mail.maildlp.com (Postfix) with ESMTPS id 03A341401F4;
	Fri, 15 Nov 2024 19:27:18 +0800 (CST)
Received: from ubuntu.huawei.com (10.69.192.56) by
 kwepemk500010.china.huawei.com (7.202.194.95) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 15 Nov 2024 19:27:17 +0800
From: Weili Qian <qianweili@huawei.com>
To: <herbert@gondor.apana.org.au>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<liulongfang@huawei.com>, <shenyang39@huawei.com>
Subject: [PATCH 1/2] crypto: hisilicon/zip - add data aggregation feature
Date: Fri, 15 Nov 2024 19:26:50 +0800
Message-ID: <20241115112651.54299-2-qianweili@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20241115112651.54299-1-qianweili@huawei.com>
References: <20241115112651.54299-1-qianweili@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemk500010.china.huawei.com (7.202.194.95)

The zip device adds data aggregation feature, data with the
same key can be combined.

This patch enables the device data aggregation feature.
New feature is called "hashagg" name and registered to
the uacce subsystem to allow applications to submit data
aggregation operations in user space.

Signed-off-by: Weili Qian <qianweili@huawei.com>
---
 drivers/crypto/hisilicon/qm.c           | 12 ++---
 drivers/crypto/hisilicon/zip/Makefile   |  2 +-
 drivers/crypto/hisilicon/zip/dae_main.c | 70 +++++++++++++++++++++++++
 drivers/crypto/hisilicon/zip/zip.h      |  2 +
 drivers/crypto/hisilicon/zip/zip_main.c | 15 ++++--
 include/linux/hisi_acc_qm.h             |  3 ++
 6 files changed, 93 insertions(+), 11 deletions(-)
 create mode 100644 drivers/crypto/hisilicon/zip/dae_main.c

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 19c1b5d3c954..97404efa2e41 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -119,6 +119,7 @@
 #define QM_SQC_VFT_BASE_MASK_V2		GENMASK(15, 0)
 #define QM_SQC_VFT_NUM_SHIFT_V2		45
 #define QM_SQC_VFT_NUM_MASK_V2		GENMASK(9, 0)
+#define QM_MAX_QC_TYPE                  2
 
 #define QM_ABNORMAL_INT_SOURCE		0x100000
 #define QM_ABNORMAL_INT_MASK		0x100004
@@ -234,8 +235,6 @@
 #define QM_QOS_MAX_CIR_U		6
 #define QM_AUTOSUSPEND_DELAY		3000
 
-#define QM_DEV_ALG_MAX_LEN		256
-
  /* abnormal status value for stopping queue */
 #define QM_STOP_QUEUE_FAIL		1
 #define	QM_DUMP_SQC_FAIL		3
@@ -333,6 +332,7 @@ static const struct hisi_qm_cap_info qm_cap_info_comm[] = {
 	{QM_SUPPORT_STOP_FUNC,     0x3100, 0, BIT(10), 0x0, 0x0, 0x1},
 	{QM_SUPPORT_MB_COMMAND,   0x3100, 0, BIT(11), 0x0, 0x0, 0x1},
 	{QM_SUPPORT_SVA_PREFETCH, 0x3100, 0, BIT(14), 0x0, 0x0, 0x1},
+	{QM_SUPPORT_DAE,          0x3100, 0, BIT(15), 0x0, 0x0, 0x0},
 };
 
 static const struct hisi_qm_cap_info qm_cap_info_pf[] = {
@@ -855,10 +855,10 @@ int hisi_qm_set_algs(struct hisi_qm *qm, u64 alg_msk, const struct qm_dev_alg *d
 			strcat(algs, dev_algs[i].alg);
 
 	ptr = strrchr(algs, '\n');
-	if (ptr) {
+	if (ptr)
 		*ptr = '\0';
-		qm->uacce->algs = algs;
-	}
+
+	qm->uacce->algs = algs;
 
 	return 0;
 }
@@ -2475,7 +2475,7 @@ static long hisi_qm_uacce_ioctl(struct uacce_queue *q, unsigned int cmd,
 				   sizeof(struct hisi_qp_ctx)))
 			return -EFAULT;
 
-		if (qp_ctx.qc_type != 0 && qp_ctx.qc_type != 1)
+		if (qp_ctx.qc_type > QM_MAX_QC_TYPE)
 			return -EINVAL;
 
 		qm_set_sqctype(q, qp_ctx.qc_type);
diff --git a/drivers/crypto/hisilicon/zip/Makefile b/drivers/crypto/hisilicon/zip/Makefile
index a936f099ee22..13de020b77d6 100644
--- a/drivers/crypto/hisilicon/zip/Makefile
+++ b/drivers/crypto/hisilicon/zip/Makefile
@@ -1,2 +1,2 @@
 obj-$(CONFIG_CRYPTO_DEV_HISI_ZIP) += hisi_zip.o
-hisi_zip-objs = zip_main.o zip_crypto.o
+hisi_zip-objs = zip_main.o zip_crypto.o dae_main.o
diff --git a/drivers/crypto/hisilicon/zip/dae_main.c b/drivers/crypto/hisilicon/zip/dae_main.c
new file mode 100644
index 000000000000..4369c5a7e2d5
--- /dev/null
+++ b/drivers/crypto/hisilicon/zip/dae_main.c
@@ -0,0 +1,70 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2024 HiSilicon Limited. */
+
+#include <linux/bitops.h>
+#include <linux/io.h>
+#include <linux/uacce.h>
+#include "zip.h"
+
+/* memory */
+#define DAE_MEM_START_OFFSET		0x331040
+#define DAE_MEM_DONE_OFFSET		0x331044
+#define DAE_MEM_START_MASK		0x1
+#define DAE_MEM_DONE_MASK		0x1
+#define DAE_REG_RD_INTVRL_US		10
+#define DAE_REG_RD_TMOUT_US		USEC_PER_SEC
+
+#define DAE_ALG_NAME			"hashagg"
+
+static inline bool dae_is_support(struct hisi_qm *qm)
+{
+	if (test_bit(QM_SUPPORT_DAE, &qm->caps))
+		return true;
+
+	return false;
+}
+
+int hisi_dae_set_user_domain(struct hisi_qm *qm)
+{
+	u32 val;
+	int ret;
+
+	if (!dae_is_support(qm))
+		return 0;
+
+	val = readl(qm->io_base + DAE_MEM_START_OFFSET);
+	val |= DAE_MEM_START_MASK;
+	writel(val, qm->io_base + DAE_MEM_START_OFFSET);
+	ret = readl_relaxed_poll_timeout(qm->io_base + DAE_MEM_DONE_OFFSET, val,
+					 val & DAE_MEM_DONE_MASK,
+					 DAE_REG_RD_INTVRL_US, DAE_REG_RD_TMOUT_US);
+	if (ret)
+		pci_err(qm->pdev, "failed to init dae memory!\n");
+
+	return ret;
+}
+
+int hisi_dae_set_alg(struct hisi_qm *qm)
+{
+	size_t len;
+
+	if (!dae_is_support(qm))
+		return 0;
+
+	if (!qm->uacce)
+		return 0;
+
+	len = strlen(qm->uacce->algs);
+	/* A line break may be required */
+	if (len + strlen(DAE_ALG_NAME) + 1 >= QM_DEV_ALG_MAX_LEN) {
+		pci_err(qm->pdev, "algorithm name is too long!\n");
+		return -EINVAL;
+	}
+
+	if (len)
+		strcat((char *)qm->uacce->algs, "\n");
+
+	strcat((char *)qm->uacce->algs, DAE_ALG_NAME);
+
+	return 0;
+}
diff --git a/drivers/crypto/hisilicon/zip/zip.h b/drivers/crypto/hisilicon/zip/zip.h
index 2fecf346c3c9..a44ce7f06786 100644
--- a/drivers/crypto/hisilicon/zip/zip.h
+++ b/drivers/crypto/hisilicon/zip/zip.h
@@ -103,4 +103,6 @@ int zip_create_qps(struct hisi_qp **qps, int qp_num, int node);
 int hisi_zip_register_to_crypto(struct hisi_qm *qm);
 void hisi_zip_unregister_from_crypto(struct hisi_qm *qm);
 bool hisi_zip_alg_support(struct hisi_qm *qm, u32 alg);
+int hisi_dae_set_user_domain(struct hisi_qm *qm);
+int hisi_dae_set_alg(struct hisi_qm *qm);
 #endif
diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index 9239b251c2d7..63a18c26c4ea 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -582,7 +582,7 @@ static int hisi_zip_set_user_domain_and_cache(struct hisi_qm *qm)
 
 	hisi_zip_enable_clock_gate(qm);
 
-	return 0;
+	return hisi_dae_set_user_domain(qm);
 }
 
 static void hisi_zip_master_ooo_ctrl(struct hisi_qm *qm, bool enable)
@@ -1301,17 +1301,24 @@ static int hisi_zip_qm_init(struct hisi_qm *qm, struct pci_dev *pdev)
 	ret = zip_pre_store_cap_reg(qm);
 	if (ret) {
 		pci_err(qm->pdev, "Failed to pre-store capability registers!\n");
-		hisi_qm_uninit(qm);
-		return ret;
+		goto err_qm_uninit;
 	}
 
 	alg_msk = qm->cap_tables.dev_cap_table[ZIP_ALG_BITMAP].cap_val;
 	ret = hisi_qm_set_algs(qm, alg_msk, zip_dev_algs, ARRAY_SIZE(zip_dev_algs));
 	if (ret) {
 		pci_err(qm->pdev, "Failed to set zip algs!\n");
-		hisi_qm_uninit(qm);
+		goto err_qm_uninit;
 	}
 
+	ret = hisi_dae_set_alg(qm);
+	if (ret)
+		goto err_qm_uninit;
+
+	return 0;
+
+err_qm_uninit:
+	hisi_qm_uninit(qm);
 	return ret;
 }
 
diff --git a/include/linux/hisi_acc_qm.h b/include/linux/hisi_acc_qm.h
index 6dbd0d49628f..3a13fb719dd0 100644
--- a/include/linux/hisi_acc_qm.h
+++ b/include/linux/hisi_acc_qm.h
@@ -97,6 +97,8 @@
 /* page number for queue file region */
 #define QM_DOORBELL_PAGE_NR		1
 
+#define QM_DEV_ALG_MAX_LEN		256
+
 /* uacce mode of the driver */
 #define UACCE_MODE_NOUACCE		0 /* don't use uacce */
 #define UACCE_MODE_SVA			1 /* use uacce sva mode */
@@ -156,6 +158,7 @@ enum qm_cap_bits {
 	QM_SUPPORT_MB_COMMAND,
 	QM_SUPPORT_SVA_PREFETCH,
 	QM_SUPPORT_RPM,
+	QM_SUPPORT_DAE,
 };
 
 struct qm_dev_alg {
-- 
2.33.0

