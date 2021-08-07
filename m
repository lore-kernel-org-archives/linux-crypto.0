Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6A7DC4338F
	for <linux-crypto@archiver.kernel.org>; Sat,  7 Aug 2021 10:36:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B986C610FB
	for <linux-crypto@archiver.kernel.org>; Sat,  7 Aug 2021 10:36:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231935AbhHGKgs (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 7 Aug 2021 06:36:48 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:13297 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231827AbhHGKgh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 7 Aug 2021 06:36:37 -0400
Received: from dggeme768-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4GhdtM116pz83jW;
        Sat,  7 Aug 2021 18:31:23 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggeme768-chm.china.huawei.com (10.3.19.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sat, 7 Aug 2021 18:36:17 +0800
From:   Weili Qian <qianweili@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <wangzhou1@hisilicon.com>, <liulongfang@huawei.com>
Subject: [PATCH 1/5] crypto: hisilicon - using 'debugfs_create_file' instead of 'debugfs_create_regset32'
Date:   Sat, 7 Aug 2021 18:32:32 +0800
Message-ID: <1628332356-33278-2-git-send-email-qianweili@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1628332356-33278-1-git-send-email-qianweili@huawei.com>
References: <1628332356-33278-1-git-send-email-qianweili@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggeme768-chm.china.huawei.com (10.3.19.114)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The accelerator devices support runtime PM, when device is in suspended, an
exception will occur if reading registers. Therefore, this patch uses
'debugfs_create_file' instead of 'debugfs_create_regset32' to create
debugfs file, and then the driver can get the device status before
reading the register.

Signed-off-by: Weili Qian <qianweili@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_main.c | 25 +++++++++++--
 drivers/crypto/hisilicon/qm.c             | 58 +++++++++++++++++++------------
 drivers/crypto/hisilicon/qm.h             |  2 ++
 drivers/crypto/hisilicon/sec2/sec_main.c  | 11 +++++-
 drivers/crypto/hisilicon/zip/zip_main.c   | 12 ++++++-
 5 files changed, 81 insertions(+), 27 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index 8b0640f..df302e0 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -700,6 +700,24 @@ static int hpre_debugfs_atomic64_set(void *data, u64 val)
 DEFINE_DEBUGFS_ATTRIBUTE(hpre_atomic64_ops, hpre_debugfs_atomic64_get,
 			 hpre_debugfs_atomic64_set, "%llu\n");
 
+static int hpre_com_regs_show(struct seq_file *s, void *unused)
+{
+	hisi_qm_regs_dump(s, s->private);
+
+	return 0;
+}
+
+DEFINE_SHOW_ATTRIBUTE(hpre_com_regs);
+
+static int hpre_cluster_regs_show(struct seq_file *s, void *unused)
+{
+	hisi_qm_regs_dump(s, s->private);
+
+	return 0;
+}
+
+DEFINE_SHOW_ATTRIBUTE(hpre_cluster_regs);
+
 static int hpre_create_debugfs_file(struct hisi_qm *qm, struct dentry *dir,
 				    enum hpre_ctrl_dbgfs_file type, int indx)
 {
@@ -738,7 +756,9 @@ static int hpre_pf_comm_regs_debugfs_init(struct hisi_qm *qm)
 	regset->nregs = ARRAY_SIZE(hpre_com_dfx_regs);
 	regset->base = qm->io_base;
 
-	debugfs_create_regset32("regs", 0444,  qm->debug.debug_root, regset);
+	debugfs_create_file("regs", 0444, qm->debug.debug_root,
+			    regset, &hpre_com_regs_fops);
+
 	return 0;
 }
 
@@ -765,7 +785,8 @@ static int hpre_cluster_debugfs_init(struct hisi_qm *qm)
 		regset->nregs = ARRAY_SIZE(hpre_cluster_dfx_regs);
 		regset->base = qm->io_base + hpre_cluster_offsets[i];
 
-		debugfs_create_regset32("regs", 0444, tmp_d, regset);
+		debugfs_create_file("regs", 0444, tmp_d, regset,
+				    &hpre_cluster_regs_fops);
 		ret = hpre_create_debugfs_file(qm, tmp_d, HPRE_CLUSTER_CTRL,
 					       i + HPRE_CLUSTER_CTRL);
 		if (ret)
diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 1d67f94..e417cd0 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -4,7 +4,6 @@
 #include <linux/acpi.h>
 #include <linux/aer.h>
 #include <linux/bitmap.h>
-#include <linux/debugfs.h>
 #include <linux/dma-mapping.h>
 #include <linux/idr.h>
 #include <linux/io.h>
@@ -1337,13 +1336,8 @@ static const struct file_operations qm_debug_fops = {
 	.write = qm_debug_write,
 };
 
-struct qm_dfx_registers {
-	char  *reg_name;
-	u64   reg_offset;
-};
-
 #define CNT_CYC_REGS_NUM		10
-static struct qm_dfx_registers qm_dfx_regs[] = {
+static const struct debugfs_reg32 qm_dfx_regs[] = {
 	/* XXX_CNT are reading clear register */
 	{"QM_ECC_1BIT_CNT               ",  0x104000ull},
 	{"QM_ECC_MBIT_CNT               ",  0x104008ull},
@@ -1369,31 +1363,49 @@ static struct qm_dfx_registers qm_dfx_regs[] = {
 	{"QM_DFX_FF_ST5                 ",  0x1040dcull},
 	{"QM_DFX_FF_ST6                 ",  0x1040e0ull},
 	{"QM_IN_IDLE_ST                 ",  0x1040e4ull},
-	{ NULL, 0}
 };
 
-static struct qm_dfx_registers qm_vf_dfx_regs[] = {
+static const struct debugfs_reg32 qm_vf_dfx_regs[] = {
 	{"QM_DFX_FUNS_ACTIVE_ST         ",  0x200ull},
-	{ NULL, 0}
 };
 
-static int qm_regs_show(struct seq_file *s, void *unused)
+/**
+ * hisi_qm_regs_dump() - Dump registers's value.
+ * @s: debugfs file handle.
+ * @regset: accelerator registers information.
+ *
+ * Dump accelerator registers.
+ */
+void hisi_qm_regs_dump(struct seq_file *s, struct debugfs_regset32 *regset)
 {
-	struct hisi_qm *qm = s->private;
-	struct qm_dfx_registers *regs;
+	const struct debugfs_reg32 *regs = regset->regs;
+	int regs_len = regset->nregs;
 	u32 val;
+	int i;
 
-	if (qm->fun_type == QM_HW_PF)
-		regs = qm_dfx_regs;
-	else
-		regs = qm_vf_dfx_regs;
+	for (i = 0; i < regs_len; i++) {
+		val = readl(regset->base + regs[i].offset);
+		seq_printf(s, "%s= 0x%08x\n", regs[i].name, val);
+	}
+}
+EXPORT_SYMBOL_GPL(hisi_qm_regs_dump);
 
-	while (regs->reg_name) {
-		val = readl(qm->io_base + regs->reg_offset);
-		seq_printf(s, "%s= 0x%08x\n", regs->reg_name, val);
-		regs++;
+static int qm_regs_show(struct seq_file *s, void *unused)
+{
+	struct hisi_qm *qm = s->private;
+	struct debugfs_regset32 regset;
+
+	if (qm->fun_type == QM_HW_PF) {
+		regset.regs = qm_dfx_regs;
+		regset.nregs = ARRAY_SIZE(qm_dfx_regs);
+	} else {
+		regset.regs = qm_vf_dfx_regs;
+		regset.nregs = ARRAY_SIZE(qm_vf_dfx_regs);
 	}
 
+	regset.base = qm->io_base;
+	hisi_qm_regs_dump(s, &regset);
+
 	return 0;
 }
 
@@ -4245,7 +4257,7 @@ EXPORT_SYMBOL_GPL(hisi_qm_debug_init);
  */
 void hisi_qm_debug_regs_clear(struct hisi_qm *qm)
 {
-	struct qm_dfx_registers *regs;
+	const struct debugfs_reg32 *regs;
 	int i;
 
 	/* clear current_qm */
@@ -4264,7 +4276,7 @@ void hisi_qm_debug_regs_clear(struct hisi_qm *qm)
 
 	regs = qm_dfx_regs;
 	for (i = 0; i < CNT_CYC_REGS_NUM; i++) {
-		readl(qm->io_base + regs->reg_offset);
+		readl(qm->io_base + regs->offset);
 		regs++;
 	}
 
diff --git a/drivers/crypto/hisilicon/qm.h b/drivers/crypto/hisilicon/qm.h
index 035eaf8..0e5df1c 100644
--- a/drivers/crypto/hisilicon/qm.h
+++ b/drivers/crypto/hisilicon/qm.h
@@ -4,6 +4,7 @@
 #define HISI_ACC_QM_H
 
 #include <linux/bitfield.h>
+#include <linux/debugfs.h>
 #include <linux/iopoll.h>
 #include <linux/module.h>
 #include <linux/pci.h>
@@ -430,4 +431,5 @@ void hisi_qm_dev_shutdown(struct pci_dev *pdev);
 void hisi_qm_wait_task_finish(struct hisi_qm *qm, struct hisi_qm_list *qm_list);
 int hisi_qm_alg_register(struct hisi_qm *qm, struct hisi_qm_list *qm_list);
 void hisi_qm_alg_unregister(struct hisi_qm *qm, struct hisi_qm_list *qm_list);
+void hisi_qm_regs_dump(struct seq_file *s, struct debugfs_regset32 *regset);
 #endif
diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index 490db7b..bc9b766 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -653,6 +653,15 @@ static int sec_debugfs_atomic64_set(void *data, u64 val)
 DEFINE_DEBUGFS_ATTRIBUTE(sec_atomic64_ops, sec_debugfs_atomic64_get,
 			 sec_debugfs_atomic64_set, "%lld\n");
 
+static int sec_regs_show(struct seq_file *s, void *unused)
+{
+	hisi_qm_regs_dump(s, s->private);
+
+	return 0;
+}
+
+DEFINE_SHOW_ATTRIBUTE(sec_regs);
+
 static int sec_core_debug_init(struct hisi_qm *qm)
 {
 	struct sec_dev *sec = container_of(qm, struct sec_dev, qm);
@@ -673,7 +682,7 @@ static int sec_core_debug_init(struct hisi_qm *qm)
 	regset->base = qm->io_base;
 
 	if (qm->pdev->device == SEC_PF_PCI_DEVICE_ID)
-		debugfs_create_regset32("regs", 0444, tmp_d, regset);
+		debugfs_create_file("regs", 0444, tmp_d, regset, &sec_regs_fops);
 
 	for (i = 0; i < ARRAY_SIZE(sec_dfx_labels); i++) {
 		atomic64_t *data = (atomic64_t *)((uintptr_t)dfx +
diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index f8482ce..a85e4b4 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -538,6 +538,15 @@ static int zip_debugfs_atomic64_get(void *data, u64 *val)
 DEFINE_DEBUGFS_ATTRIBUTE(zip_atomic64_ops, zip_debugfs_atomic64_get,
 			 zip_debugfs_atomic64_set, "%llu\n");
 
+static int hisi_zip_regs_show(struct seq_file *s, void *unused)
+{
+	hisi_qm_regs_dump(s, s->private);
+
+	return 0;
+}
+
+DEFINE_SHOW_ATTRIBUTE(hisi_zip_regs);
+
 static int hisi_zip_core_debug_init(struct hisi_qm *qm)
 {
 	struct device *dev = &qm->pdev->dev;
@@ -562,7 +571,8 @@ static int hisi_zip_core_debug_init(struct hisi_qm *qm)
 		regset->base = qm->io_base + core_offsets[i];
 
 		tmp_d = debugfs_create_dir(buf, qm->debug.debug_root);
-		debugfs_create_regset32("regs", 0444, tmp_d, regset);
+		debugfs_create_file("regs", 0444, tmp_d, regset,
+				     &hisi_zip_regs_fops);
 	}
 
 	return 0;
-- 
2.8.1

