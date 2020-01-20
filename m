Return-Path: <SRS0=QLPS=3J=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 912E5C33CA1
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Jan 2020 07:30:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F3782077C
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Jan 2020 07:30:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbgATHaU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 20 Jan 2020 02:30:20 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:42990 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726400AbgATHaU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Jan 2020 02:30:20 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id C0F0898919F69634C870;
        Mon, 20 Jan 2020 15:30:17 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.439.0; Mon, 20 Jan 2020 15:30:11 +0800
From:   Shukun Tan <tanshukun1@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <linuxarm@huawei.com>
Subject: [PATCH 1/4] crypto: hisilicon: Unify hardware error init/uninit into QM
Date:   Mon, 20 Jan 2020 15:30:06 +0800
Message-ID: <1579505409-3776-2-git-send-email-tanshukun1@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1579505409-3776-1-git-send-email-tanshukun1@huawei.com>
References: <1579505409-3776-1-git-send-email-tanshukun1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The initialization and uninitialization of zip/hpre/sec/qm hardware error
is processed in respective drivers, which could be unified into qm.c. We
add struct hisi_qm_err_ini into struct hisi_qm, which involve all error
handlers of device and assignment should be done in driver probe.

Signed-off-by: Shukun Tan <tanshukun1@huawei.com>
Signed-off-by: Zaibo Xu <xuzaibo@huawei.com>
Reviewed-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 drivers/crypto/hisilicon/hpre/hpre_main.c | 33 ++++++------
 drivers/crypto/hisilicon/qm.c             | 86 +++++++++++++++++++++++--------
 drivers/crypto/hisilicon/qm.h             | 20 ++++++-
 drivers/crypto/hisilicon/sec2/sec_main.c  | 51 ++++++++----------
 drivers/crypto/hisilicon/zip/zip_main.c   | 58 +++++++++++----------
 5 files changed, 149 insertions(+), 99 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index 401747d..5bf274c 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -349,18 +349,14 @@ static void hpre_cnt_regs_clear(struct hisi_qm *qm)
 	hisi_qm_debug_regs_clear(qm);
 }
 
-static void hpre_hw_error_disable(struct hpre *hpre)
+static void hpre_hw_error_disable(struct hisi_qm *qm)
 {
-	struct hisi_qm *qm = &hpre->qm;
-
 	/* disable hpre hw error interrupts */
 	writel(HPRE_CORE_INT_DISABLE, qm->io_base + HPRE_INT_MASK);
 }
 
-static void hpre_hw_error_enable(struct hpre *hpre)
+static void hpre_hw_error_enable(struct hisi_qm *qm)
 {
-	struct hisi_qm *qm = &hpre->qm;
-
 	/* enable hpre hw error interrupts */
 	writel(HPRE_CORE_INT_ENABLE, qm->io_base + HPRE_INT_MASK);
 	writel(HPRE_HAC_RAS_CE_ENABLE, qm->io_base + HPRE_RAS_CE_ENB);
@@ -713,12 +709,16 @@ static int hpre_qm_pre_init(struct hisi_qm *qm, struct pci_dev *pdev)
 	return 0;
 }
 
-static void hpre_hw_err_init(struct hpre *hpre)
-{
-	hisi_qm_hw_error_init(&hpre->qm, QM_BASE_CE, QM_BASE_NFE,
-			      0, QM_DB_RANDOM_INVALID);
-	hpre_hw_error_enable(hpre);
-}
+static const struct hisi_qm_err_ini hpre_err_ini = {
+	.hw_err_enable	= hpre_hw_error_enable,
+	.hw_err_disable	= hpre_hw_error_disable,
+	.err_info	= {
+		.ce		= QM_BASE_CE,
+		.nfe		= QM_BASE_NFE | QM_ACC_DO_TASK_TIMEOUT,
+		.fe		= 0,
+		.msi		= QM_DB_RANDOM_INVALID,
+	}
+};
 
 static int hpre_pf_probe_init(struct hpre *hpre)
 {
@@ -731,7 +731,8 @@ static int hpre_pf_probe_init(struct hpre *hpre)
 	if (ret)
 		return ret;
 
-	hpre_hw_err_init(hpre);
+	qm->err_ini = &hpre_err_ini;
+	hisi_qm_dev_err_init(qm);
 
 	return 0;
 }
@@ -790,8 +791,7 @@ static int hpre_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	hisi_qm_stop(qm);
 
 err_with_err_init:
-	if (pdev->is_physfn)
-		hpre_hw_error_disable(hpre);
+	hisi_qm_dev_err_uninit(qm);
 
 err_with_qm_init:
 	hisi_qm_uninit(qm);
@@ -922,8 +922,7 @@ static void hpre_remove(struct pci_dev *pdev)
 
 	hpre_debugfs_exit(hpre);
 	hisi_qm_stop(qm);
-	if (qm->fun_type == QM_HW_PF)
-		hpre_hw_error_disable(hpre);
+	hisi_qm_dev_err_uninit(qm);
 	hisi_qm_uninit(qm);
 }
 
diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index b57da5e..e1d08e8 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -277,6 +277,7 @@ struct hisi_qm_hw_ops {
 	int (*debug_init)(struct hisi_qm *qm);
 	void (*hw_error_init)(struct hisi_qm *qm, u32 ce, u32 nfe, u32 fe,
 			      u32 msi);
+	void (*hw_error_uninit)(struct hisi_qm *qm);
 	pci_ers_result_t (*hw_error_handle)(struct hisi_qm *qm);
 };
 
@@ -1011,6 +1012,11 @@ static void qm_hw_error_init_v2(struct hisi_qm *qm, u32 ce, u32 nfe, u32 fe,
 	writel(irq_unmask, qm->io_base + QM_ABNORMAL_INT_MASK);
 }
 
+static void qm_hw_error_uninit_v2(struct hisi_qm *qm)
+{
+	writel(QM_ABNORMAL_INT_MASK_VALUE, qm->io_base + QM_ABNORMAL_INT_MASK);
+}
+
 static void qm_log_hw_error(struct hisi_qm *qm, u32 error_status)
 {
 	const struct hisi_qm_hw_error *err = qm_hw_error;
@@ -1082,6 +1088,7 @@ static const struct hisi_qm_hw_ops qm_hw_ops_v2 = {
 	.qm_db = qm_db_v2,
 	.get_irq_num = qm_get_irq_num_v2,
 	.hw_error_init = qm_hw_error_init_v2,
+	.hw_error_uninit = qm_hw_error_uninit_v2,
 	.hw_error_handle = qm_hw_error_handle_v2,
 };
 
@@ -1856,35 +1863,28 @@ void hisi_qm_debug_regs_clear(struct hisi_qm *qm)
 }
 EXPORT_SYMBOL_GPL(hisi_qm_debug_regs_clear);
 
-/**
- * hisi_qm_hw_error_init() - Configure qm hardware error report method.
- * @qm: The qm which we want to configure.
- * @ce: Bit mask of correctable error configure.
- * @nfe: Bit mask of non-fatal error configure.
- * @fe: Bit mask of fatal error configure.
- * @msi: Bit mask of error reported by message signal interrupt.
- *
- * Hardware errors of qm can be reported either by RAS interrupts which will
- * be handled by UEFI and then PCIe AER or by device MSI. User can configure
- * each error to use either of above two methods. For RAS interrupts, we can
- * configure an error as one of correctable error, non-fatal error or
- * fatal error.
- *
- * Bits indicating errors can be configured to ce, nfe, fe and msi to enable
- * related report methods. Error report will be masked if related error bit
- * does not configure.
- */
-void hisi_qm_hw_error_init(struct hisi_qm *qm, u32 ce, u32 nfe, u32 fe,
-			   u32 msi)
+static void qm_hw_error_init(struct hisi_qm *qm)
 {
+	const struct hisi_qm_err_info *err_info = &qm->err_ini->err_info;
+
 	if (!qm->ops->hw_error_init) {
 		dev_err(&qm->pdev->dev, "QM doesn't support hw error handling!\n");
 		return;
 	}
 
-	qm->ops->hw_error_init(qm, ce, nfe, fe, msi);
+	qm->ops->hw_error_init(qm, err_info->ce, err_info->nfe,
+			       err_info->fe, err_info->msi);
+}
+
+static void qm_hw_error_uninit(struct hisi_qm *qm)
+{
+	if (!qm->ops->hw_error_uninit) {
+		dev_err(&qm->pdev->dev, "Unexpected QM hw error uninit!\n");
+		return;
+	}
+
+	qm->ops->hw_error_uninit(qm);
 }
-EXPORT_SYMBOL_GPL(hisi_qm_hw_error_init);
 
 /**
  * hisi_qm_hw_error_handle() - Handle qm non-fatal hardware errors.
@@ -1922,6 +1922,48 @@ enum qm_hw_ver hisi_qm_get_hw_version(struct pci_dev *pdev)
 }
 EXPORT_SYMBOL_GPL(hisi_qm_get_hw_version);
 
+/**
+ * hisi_qm_dev_err_init() - Initialize device error configuration.
+ * @qm: The qm for which we want to do error initialization.
+ *
+ * Initialize QM and device error related configuration.
+ */
+void hisi_qm_dev_err_init(struct hisi_qm *qm)
+{
+	if (qm->fun_type == QM_HW_VF)
+		return;
+
+	qm_hw_error_init(qm);
+
+	if (!qm->err_ini->hw_err_enable) {
+		dev_err(&qm->pdev->dev, "Device doesn't support hw error init!\n");
+		return;
+	}
+	qm->err_ini->hw_err_enable(qm);
+}
+EXPORT_SYMBOL_GPL(hisi_qm_dev_err_init);
+
+/**
+ * hisi_qm_dev_err_uninit() - Uninitialize device error configuration.
+ * @qm: The qm for which we want to do error uninitialization.
+ *
+ * Uninitialize QM and device error related configuration.
+ */
+void hisi_qm_dev_err_uninit(struct hisi_qm *qm)
+{
+	if (qm->fun_type == QM_HW_VF)
+		return;
+
+	qm_hw_error_uninit(qm);
+
+	if (!qm->err_ini->hw_err_disable) {
+		dev_err(&qm->pdev->dev, "Unexpected device hw error uninit!\n");
+		return;
+	}
+	qm->err_ini->hw_err_disable(qm);
+}
+EXPORT_SYMBOL_GPL(hisi_qm_dev_err_uninit);
+
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Zhou Wang <wangzhou1@hisilicon.com>");
 MODULE_DESCRIPTION("HiSilicon Accelerator queue manager driver");
diff --git a/drivers/crypto/hisilicon/qm.h b/drivers/crypto/hisilicon/qm.h
index 078b8f1..325f6d5 100644
--- a/drivers/crypto/hisilicon/qm.h
+++ b/drivers/crypto/hisilicon/qm.h
@@ -125,6 +125,21 @@ struct hisi_qm_status {
 	unsigned long flags;
 };
 
+struct hisi_qm;
+
+struct hisi_qm_err_info {
+	u32 ce;
+	u32 nfe;
+	u32 fe;
+	u32 msi;
+};
+
+struct hisi_qm_err_ini {
+	void (*hw_err_enable)(struct hisi_qm *qm);
+	void (*hw_err_disable)(struct hisi_qm *qm);
+	struct hisi_qm_err_info err_info;
+};
+
 struct hisi_qm {
 	enum qm_hw_ver ver;
 	enum qm_fun_type fun_type;
@@ -148,6 +163,7 @@ struct hisi_qm {
 	dma_addr_t aeqe_dma;
 
 	struct hisi_qm_status status;
+	const struct hisi_qm_err_ini *err_ini;
 
 	rwlock_t qps_lock;
 	unsigned long *qp_bitmap;
@@ -211,11 +227,11 @@ int hisi_qm_get_free_qp_num(struct hisi_qm *qm);
 int hisi_qm_get_vft(struct hisi_qm *qm, u32 *base, u32 *number);
 int hisi_qm_set_vft(struct hisi_qm *qm, u32 fun_num, u32 base, u32 number);
 int hisi_qm_debug_init(struct hisi_qm *qm);
-void hisi_qm_hw_error_init(struct hisi_qm *qm, u32 ce, u32 nfe, u32 fe,
-			   u32 msi);
 pci_ers_result_t hisi_qm_hw_error_handle(struct hisi_qm *qm);
 enum qm_hw_ver hisi_qm_get_hw_version(struct pci_dev *pdev);
 void hisi_qm_debug_regs_clear(struct hisi_qm *qm);
+void hisi_qm_dev_err_init(struct hisi_qm *qm);
+void hisi_qm_dev_err_uninit(struct hisi_qm *qm);
 
 struct hisi_acc_sgl_pool;
 struct hisi_acc_hw_sgl *hisi_acc_sg_buf_map_to_hw_sgl(struct device *dev,
diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index 2bbaf1e..3cb5fd3 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -384,9 +384,8 @@ static void sec_debug_regs_clear(struct hisi_qm *qm)
 	hisi_qm_debug_regs_clear(qm);
 }
 
-static void sec_hw_error_enable(struct sec_dev *sec)
+static void sec_hw_error_enable(struct hisi_qm *qm)
 {
-	struct hisi_qm *qm = &sec->qm;
 	u32 val;
 
 	if (qm->ver == QM_HW_V1) {
@@ -414,9 +413,8 @@ static void sec_hw_error_enable(struct sec_dev *sec)
 	writel(val, qm->io_base + SEC_CONTROL_REG);
 }
 
-static void sec_hw_error_disable(struct sec_dev *sec)
+static void sec_hw_error_disable(struct hisi_qm *qm)
 {
-	struct hisi_qm *qm = &sec->qm;
 	u32 val;
 
 	val = readl(qm->io_base + SEC_CONTROL_REG);
@@ -435,27 +433,6 @@ static void sec_hw_error_disable(struct sec_dev *sec)
 	writel(val, qm->io_base + SEC_CONTROL_REG);
 }
 
-static void sec_hw_error_init(struct sec_dev *sec)
-{
-	if (sec->qm.fun_type == QM_HW_VF)
-		return;
-
-	hisi_qm_hw_error_init(&sec->qm, QM_BASE_CE,
-			      QM_BASE_NFE | QM_ACC_DO_TASK_TIMEOUT
-			      | QM_ACC_WB_NOT_READY_TIMEOUT, 0,
-			      QM_DB_RANDOM_INVALID);
-	sec_hw_error_enable(sec);
-}
-
-static void sec_hw_error_uninit(struct sec_dev *sec)
-{
-	if (sec->qm.fun_type == QM_HW_VF)
-		return;
-
-	sec_hw_error_disable(sec);
-	writel(GENMASK(12, 0), sec->qm.io_base + SEC_QM_ABNORMAL_INT_MASK);
-}
-
 static u32 sec_current_qm_read(struct sec_debug_file *file)
 {
 	struct hisi_qm *qm = file->qm;
@@ -695,6 +672,18 @@ static void sec_debugfs_exit(struct sec_dev *sec)
 	debugfs_remove_recursive(sec->qm.debug.debug_root);
 }
 
+static const struct hisi_qm_err_ini sec_err_ini = {
+	.hw_err_enable	= sec_hw_error_enable,
+	.hw_err_disable	= sec_hw_error_disable,
+	.err_info	= {
+		.ce		= QM_BASE_CE,
+		.nfe		= QM_BASE_NFE | QM_ACC_DO_TASK_TIMEOUT |
+				  QM_ACC_WB_NOT_READY_TIMEOUT,
+		.fe		= 0,
+		.msi		= QM_DB_RANDOM_INVALID,
+	}
+};
+
 static int sec_pf_probe_init(struct sec_dev *sec)
 {
 	struct hisi_qm *qm = &sec->qm;
@@ -713,11 +702,13 @@ static int sec_pf_probe_init(struct sec_dev *sec)
 		return -EINVAL;
 	}
 
+	qm->err_ini = &sec_err_ini;
+
 	ret = sec_set_user_domain_and_cache(sec);
 	if (ret)
 		return ret;
 
-	sec_hw_error_init(sec);
+	hisi_qm_dev_err_init(qm);
 	sec_debug_regs_clear(qm);
 
 	return 0;
@@ -777,9 +768,9 @@ static int sec_probe_init(struct hisi_qm *qm, struct sec_dev *sec)
 	return 0;
 }
 
-static void sec_probe_uninit(struct sec_dev *sec)
+static void sec_probe_uninit(struct hisi_qm *qm)
 {
-	sec_hw_error_uninit(sec);
+	hisi_qm_dev_err_uninit(qm);
 }
 
 static int sec_probe(struct pci_dev *pdev, const struct pci_device_id *id)
@@ -836,7 +827,7 @@ static int sec_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	hisi_qm_stop(qm);
 
 err_probe_uninit:
-	sec_probe_uninit(sec);
+	sec_probe_uninit(qm);
 
 err_qm_uninit:
 	sec_qm_uninit(qm);
@@ -967,7 +958,7 @@ static void sec_remove(struct pci_dev *pdev)
 	if (qm->fun_type == QM_HW_PF)
 		sec_debug_regs_clear(qm);
 
-	sec_probe_uninit(sec);
+	sec_probe_uninit(qm);
 
 	sec_qm_uninit(qm);
 }
diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index e1bab1a..4f60b93 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -60,13 +60,13 @@
 #define HZIP_CORE_DEBUG_DECOMP_5	0x309000
 
 #define HZIP_CORE_INT_SOURCE		0x3010A0
-#define HZIP_CORE_INT_MASK		0x3010A4
+#define HZIP_CORE_INT_MASK_REG		0x3010A4
 #define HZIP_CORE_INT_STATUS		0x3010AC
 #define HZIP_CORE_INT_STATUS_M_ECC	BIT(1)
 #define HZIP_CORE_SRAM_ECC_ERR_INFO	0x301148
 #define SRAM_ECC_ERR_NUM_SHIFT		16
 #define SRAM_ECC_ERR_ADDR_SHIFT		24
-#define HZIP_CORE_INT_DISABLE		0x000007FF
+#define HZIP_CORE_INT_MASK_ALL		GENMASK(10, 0)
 #define HZIP_COMP_CORE_NUM		2
 #define HZIP_DECOMP_CORE_NUM		6
 #define HZIP_CORE_NUM			(HZIP_COMP_CORE_NUM + \
@@ -366,27 +366,26 @@ static void hisi_zip_set_user_domain_and_cache(struct hisi_zip *hisi_zip)
 	       FIELD_PREP(CQC_CACHE_WB_THRD, 1), base + QM_CACHE_CTL);
 }
 
-static void hisi_zip_hw_error_set_state(struct hisi_zip *hisi_zip, bool state)
+static void hisi_zip_hw_error_enable(struct hisi_qm *qm)
 {
-	struct hisi_qm *qm = &hisi_zip->qm;
-
 	if (qm->ver == QM_HW_V1) {
-		writel(HZIP_CORE_INT_DISABLE, qm->io_base + HZIP_CORE_INT_MASK);
+		writel(HZIP_CORE_INT_MASK_ALL,
+		       qm->io_base + HZIP_CORE_INT_MASK_REG);
 		dev_info(&qm->pdev->dev, "Does not support hw error handle\n");
 		return;
 	}
 
-	if (state) {
-		/* clear ZIP hw error source if having */
-		writel(HZIP_CORE_INT_DISABLE, hisi_zip->qm.io_base +
-					      HZIP_CORE_INT_SOURCE);
-		/* enable ZIP hw error interrupts */
-		writel(0, hisi_zip->qm.io_base + HZIP_CORE_INT_MASK);
-	} else {
-		/* disable ZIP hw error interrupts */
-		writel(HZIP_CORE_INT_DISABLE,
-		       hisi_zip->qm.io_base + HZIP_CORE_INT_MASK);
-	}
+	/* clear ZIP hw error source if having */
+	writel(HZIP_CORE_INT_MASK_ALL, qm->io_base + HZIP_CORE_INT_SOURCE);
+
+	/* enable ZIP hw error interrupts */
+	writel(0, qm->io_base + HZIP_CORE_INT_MASK_REG);
+}
+
+static void hisi_zip_hw_error_disable(struct hisi_qm *qm)
+{
+	/* disable ZIP hw error interrupts */
+	writel(HZIP_CORE_INT_MASK_ALL, qm->io_base + HZIP_CORE_INT_MASK_REG);
 }
 
 static inline struct hisi_qm *file_to_qm(struct ctrl_debug_file *file)
@@ -638,13 +637,16 @@ static void hisi_zip_debugfs_exit(struct hisi_zip *hisi_zip)
 		hisi_zip_debug_regs_clear(hisi_zip);
 }
 
-static void hisi_zip_hw_error_init(struct hisi_zip *hisi_zip)
-{
-	hisi_qm_hw_error_init(&hisi_zip->qm, QM_BASE_CE,
-			      QM_BASE_NFE | QM_ACC_WB_NOT_READY_TIMEOUT, 0,
-			      QM_DB_RANDOM_INVALID);
-	hisi_zip_hw_error_set_state(hisi_zip, true);
-}
+static const struct hisi_qm_err_ini hisi_zip_err_ini = {
+	.hw_err_enable	= hisi_zip_hw_error_enable,
+	.hw_err_disable	= hisi_zip_hw_error_disable,
+	.err_info	= {
+		.ce		= QM_BASE_CE,
+		.nfe		= QM_BASE_NFE | QM_ACC_WB_NOT_READY_TIMEOUT,
+		.fe		= 0,
+		.msi		= QM_DB_RANDOM_INVALID,
+	}
+};
 
 static int hisi_zip_pf_probe_init(struct hisi_zip *hisi_zip)
 {
@@ -671,8 +673,10 @@ static int hisi_zip_pf_probe_init(struct hisi_zip *hisi_zip)
 		return -EINVAL;
 	}
 
+	qm->err_ini = &hisi_zip_err_ini;
+
 	hisi_zip_set_user_domain_and_cache(hisi_zip);
-	hisi_zip_hw_error_init(hisi_zip);
+	hisi_qm_dev_err_init(qm);
 	hisi_zip_debug_regs_clear(hisi_zip);
 
 	return 0;
@@ -887,9 +891,7 @@ static void hisi_zip_remove(struct pci_dev *pdev)
 	hisi_zip_debugfs_exit(hisi_zip);
 	hisi_qm_stop(qm);
 
-	if (qm->fun_type == QM_HW_PF)
-		hisi_zip_hw_error_set_state(hisi_zip, false);
-
+	hisi_qm_dev_err_uninit(qm);
 	hisi_qm_uninit(qm);
 	hisi_zip_remove_from_list(hisi_zip);
 }
-- 
2.7.4

