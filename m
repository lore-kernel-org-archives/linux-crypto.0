Return-Path: <SRS0=UIra=5S=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0693DC2BA12
	for <linux-crypto@archiver.kernel.org>; Thu,  2 Apr 2020 06:54:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC1732078B
	for <linux-crypto@archiver.kernel.org>; Thu,  2 Apr 2020 06:54:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387502AbgDBGyM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Apr 2020 02:54:12 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:43212 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728135AbgDBGyM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Apr 2020 02:54:12 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id D14E530F1E965BA665F4;
        Thu,  2 Apr 2020 14:54:08 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Thu, 2 Apr 2020 14:53:58 +0800
From:   Shukun Tan <tanshukun1@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <fanghao11@huawei.com>,
        Shukun Tan <tanshukun1@huawei.com>
Subject: [PATCH 3/3] crypto: hisilicon - add vfs_num module parameter for hpre/sec
Date:   Thu, 2 Apr 2020 14:53:03 +0800
Message-ID: <1585810383-49392-4-git-send-email-tanshukun1@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1585810383-49392-1-git-send-email-tanshukun1@huawei.com>
References: <1585810383-49392-1-git-send-email-tanshukun1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Hao Fang <fanghao11@huawei.com>

The vfs_num module parameter has been used in zip driver, this patch adds
this for HPRE and SEC driver.

Signed-off-by: Hao Fang <fanghao11@huawei.com>
Signed-off-by: Shukun Tan <tanshukun1@huawei.com>
Reviewed-by: Zhou Wang <wangzhou1@hisilicon.com>
Reviewed-by: Zaibo Xu <xuzaibo@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_main.c | 19 +++++++++++++++++++
 drivers/crypto/hisilicon/qm.h             | 20 ++++++++++++++++++++
 drivers/crypto/hisilicon/sec2/sec_main.c  | 18 ++++++++++++++++++
 drivers/crypto/hisilicon/zip/zip_main.c   |  9 +++++++--
 4 files changed, 64 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index 4e41d30..9cff5c1 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -195,6 +195,15 @@ static u32 hpre_pf_q_num = HPRE_PF_DEF_Q_NUM;
 module_param_cb(hpre_pf_q_num, &hpre_pf_q_num_ops, &hpre_pf_q_num, 0444);
 MODULE_PARM_DESC(hpre_pf_q_num, "Number of queues in PF of CS(1-1024)");
 
+static const struct kernel_param_ops vfs_num_ops = {
+	.set = vfs_num_set,
+	.get = param_get_int,
+};
+
+static u32 vfs_num;
+module_param_cb(vfs_num, &vfs_num_ops, &vfs_num, 0444);
+MODULE_PARM_DESC(vfs_num, "Number of VFs to enable(1-63), 0(default)");
+
 struct hisi_qp *hpre_create_qp(void)
 {
 	int node = cpu_to_node(smp_processor_id());
@@ -777,8 +786,18 @@ static int hpre_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		pci_err(pdev, "fail to register algs to crypto!\n");
 		goto err_with_qm_start;
 	}
+
+	if (qm->fun_type == QM_HW_PF && vfs_num) {
+		ret = hisi_qm_sriov_enable(pdev, vfs_num);
+		if (ret < 0)
+			goto err_with_crypto_register;
+	}
+
 	return 0;
 
+err_with_crypto_register:
+	hpre_algs_unregister();
+
 err_with_qm_start:
 	hisi_qm_del_from_list(qm, &hpre_devices);
 	hisi_qm_stop(qm);
diff --git a/drivers/crypto/hisilicon/qm.h b/drivers/crypto/hisilicon/qm.h
index 665e53d..1b5171b 100644
--- a/drivers/crypto/hisilicon/qm.h
+++ b/drivers/crypto/hisilicon/qm.h
@@ -8,6 +8,8 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 
+#define QM_MAX_VFS_NUM_V2		63
+
 /* qm user domain */
 #define QM_ARUSER_M_CFG_1		0x100088
 #define AXUSER_SNOOP_ENABLE		BIT(30)
@@ -235,6 +237,24 @@ struct hisi_qp {
 	struct uacce_queue *uacce_q;
 };
 
+static inline int vfs_num_set(const char *val, const struct kernel_param *kp)
+{
+	u32 n;
+	int ret;
+
+	if (!val)
+		return -EINVAL;
+
+	ret = kstrtou32(val, 10, &n);
+	if (ret < 0)
+		return ret;
+
+	if (n > QM_MAX_VFS_NUM_V2)
+		return -EINVAL;
+
+	return param_set_int(val, kp);
+}
+
 static inline void hisi_qm_init_list(struct hisi_qm_list *qm_list)
 {
 	INIT_LIST_HEAD(&qm_list->list);
diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index 129648a..c76c49e 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -207,6 +207,15 @@ static u32 ctx_q_num = SEC_CTX_Q_NUM_DEF;
 module_param_cb(ctx_q_num, &sec_ctx_q_num_ops, &ctx_q_num, 0444);
 MODULE_PARM_DESC(ctx_q_num, "Queue num in ctx (24 default, 2, 4, ..., 32)");
 
+static const struct kernel_param_ops vfs_num_ops = {
+	.set = vfs_num_set,
+	.get = param_get_int,
+};
+
+static u32 vfs_num;
+module_param_cb(vfs_num, &vfs_num_ops, &vfs_num, 0444);
+MODULE_PARM_DESC(vfs_num, "Number of VFs to enable(1-63), 0(default)");
+
 void sec_destroy_qps(struct hisi_qp **qps, int qp_num)
 {
 	hisi_qm_free_qps(qps, qp_num);
@@ -876,8 +885,17 @@ static int sec_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err_remove_from_list;
 	}
 
+	if (qm->fun_type == QM_HW_PF && vfs_num) {
+		ret = hisi_qm_sriov_enable(pdev, vfs_num);
+		if (ret < 0)
+			goto err_crypto_unregister;
+	}
+
 	return 0;
 
+err_crypto_unregister:
+	sec_unregister_from_crypto();
+
 err_remove_from_list:
 	hisi_qm_del_from_list(qm, &sec_devices);
 	sec_debugfs_exit(sec);
diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index 5dcda7b..fe9d6d2 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -231,9 +231,14 @@ static u32 pf_q_num = HZIP_PF_DEF_Q_NUM;
 module_param_cb(pf_q_num, &pf_q_num_ops, &pf_q_num, 0444);
 MODULE_PARM_DESC(pf_q_num, "Number of queues in PF(v1 1-4096, v2 1-1024)");
 
+static const struct kernel_param_ops vfs_num_ops = {
+	.set = vfs_num_set,
+	.get = param_get_int,
+};
+
 static u32 vfs_num;
-module_param(vfs_num, uint, 0444);
-MODULE_PARM_DESC(vfs_num, "Number of VFs to enable(1-63)");
+module_param_cb(vfs_num, &vfs_num_ops, &vfs_num, 0444);
+MODULE_PARM_DESC(vfs_num, "Number of VFs to enable(1-63), 0(default)");
 
 static const struct pci_device_id hisi_zip_dev_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_HUAWEI, PCI_DEVICE_ID_ZIP_PF) },
-- 
2.7.4

