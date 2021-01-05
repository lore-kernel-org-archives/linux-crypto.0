Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86D21C433E0
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Jan 2021 06:19:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20348227C3
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Jan 2021 06:19:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726059AbhAEGTc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Jan 2021 01:19:32 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:10385 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbhAEGTa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Jan 2021 01:19:30 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4D92Nd6d5fz7PKj;
        Tue,  5 Jan 2021 14:17:53 +0800 (CST)
Received: from huawei.com (10.67.165.24) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.498.0; Tue, 5 Jan 2021
 14:18:43 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] crypto: hisilicon - add ZIP device using mode parameter
Date:   Tue, 5 Jan 2021 14:16:42 +0800
Message-ID: <1609827404-6024-2-git-send-email-yekai13@huawei.com>
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

Add 'uacce_mode' parameter for ZIP, which can be set as 0(default) or 1.
'0' means ZIP is only registered to kernel crypto, and '1' means it's
registered to both kernel crypto and UACCE.

Signed-off-by: Kai Ye <yekai13@huawei.com>
Reviewed-by: Zhou Wang <wangzhou1@hisilicon.com>
Reviewed-by: Zaibo Xu <xuzaibo@huawei.com>
---
 drivers/crypto/hisilicon/qm.c           |  2 +-
 drivers/crypto/hisilicon/qm.h           | 27 +++++++++++++++++++++++++++
 drivers/crypto/hisilicon/zip/zip_main.c | 14 ++++++++++++++
 3 files changed, 42 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 10a04ab..904b99a 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -2206,7 +2206,7 @@ static int qm_alloc_uacce(struct hisi_qm *qm)
 	if (IS_ERR(uacce))
 		return PTR_ERR(uacce);
 
-	if (uacce->flags & UACCE_DEV_SVA) {
+	if (uacce->flags & UACCE_DEV_SVA && qm->mode == UACCE_MODE_SVA) {
 		qm->use_sva = true;
 	} else {
 		/* only consider sva case */
diff --git a/drivers/crypto/hisilicon/qm.h b/drivers/crypto/hisilicon/qm.h
index 8624d12..c1dd0fc 100644
--- a/drivers/crypto/hisilicon/qm.h
+++ b/drivers/crypto/hisilicon/qm.h
@@ -85,6 +85,11 @@
 /* page number for queue file region */
 #define QM_DOORBELL_PAGE_NR		1
 
+/* uacce mode of the driver */
+#define UACCE_MODE_NOUACCE		0 /* don't use uacce */
+#define UACCE_MODE_SVA			1 /* use uacce sva mode */
+#define UACCE_MODE_DESC	"0(default) means only register to crypto, 1 means both register to crypto and uacce"
+
 enum qm_stop_reason {
 	QM_NORMAL,
 	QM_SOFT_RESET,
@@ -249,6 +254,7 @@ struct hisi_qm {
 	resource_size_t phys_base;
 	resource_size_t phys_size;
 	struct uacce_device *uacce;
+	int mode;
 };
 
 struct hisi_qp_status {
@@ -333,6 +339,27 @@ static inline int vfs_num_set(const char *val, const struct kernel_param *kp)
 	return param_set_int(val, kp);
 }
 
+static inline int mode_set(const char *val, const struct kernel_param *kp)
+{
+	u32 n;
+	int ret;
+
+	if (!val)
+		return -EINVAL;
+
+	ret = kstrtou32(val, 10, &n);
+	if (ret != 0 || (n != UACCE_MODE_SVA &&
+			 n != UACCE_MODE_NOUACCE))
+		return -EINVAL;
+
+	return param_set_int(val, kp);
+}
+
+static inline int uacce_mode_set(const char *val, const struct kernel_param *kp)
+{
+	return mode_set(val, kp);
+}
+
 static inline void hisi_qm_init_list(struct hisi_qm_list *qm_list)
 {
 	INIT_LIST_HEAD(&qm_list->list);
diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index 4fb5a32b..9cdecff 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -211,6 +211,19 @@ static const struct debugfs_reg32 hzip_dfx_regs[] = {
 	{"HZIP_DECOMP_LZ77_CURR_ST       ",  0x9cull},
 };
 
+static const struct kernel_param_ops zip_uacce_mode_ops = {
+	.set = uacce_mode_set,
+	.get = param_get_int,
+};
+
+/*
+ * uacce_mode = 0 means zip only register to crypto,
+ * uacce_mode = 1 means zip both register to crypto and uacce.
+ */
+static u32 uacce_mode = UACCE_MODE_NOUACCE;
+module_param_cb(uacce_mode, &zip_uacce_mode_ops, &uacce_mode, 0444);
+MODULE_PARM_DESC(uacce_mode, UACCE_MODE_DESC);
+
 static int pf_q_num_set(const char *val, const struct kernel_param *kp)
 {
 	return q_num_set(val, kp, PCI_DEVICE_ID_ZIP_PF);
@@ -752,6 +765,7 @@ static int hisi_zip_qm_init(struct hisi_qm *qm, struct pci_dev *pdev)
 	qm->pdev = pdev;
 	qm->ver = pdev->revision;
 	qm->algs = "zlib\ngzip";
+	qm->mode = uacce_mode;
 	qm->sqe_size = HZIP_SQE_SIZE;
 	qm->dev_name = hisi_zip_name;
 
-- 
2.8.1

