Return-Path: <SRS0=Yf/g=65=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E2E3C433E1
	for <linux-crypto@archiver.kernel.org>; Fri, 15 May 2020 09:15:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4EFCE2065C
	for <linux-crypto@archiver.kernel.org>; Fri, 15 May 2020 09:15:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727896AbgEOJPW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 May 2020 05:15:22 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:58010 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727858AbgEOJPW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 May 2020 05:15:22 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id B3847196B0CAB809318F;
        Fri, 15 May 2020 17:15:18 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Fri, 15 May 2020 17:15:08 +0800
From:   Shukun Tan <tanshukun1@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>
Subject: [PATCH 1/7] crypto: hisilicon/qm - add debugfs for QM
Date:   Fri, 15 May 2020 17:13:54 +0800
Message-ID: <1589534040-50725-2-git-send-email-tanshukun1@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1589534040-50725-1-git-send-email-tanshukun1@huawei.com>
References: <1589534040-50725-1-git-send-email-tanshukun1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Longfang Liu <liulongfang@huawei.com>

Add DebugFS method to get the information of IRQ/Requests/QP .etc of QM
for HPRE/ZIP/SEC drivers.

Signed-off-by: Longfang Liu <liulongfang@huawei.com>
Signed-off-by: Shukun Tan <tanshukun1@huawei.com>
Reviewed-by: Zaibo Xu <xuzaibo@huawei.com>
Reviewed-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 Documentation/ABI/testing/debugfs-hisi-hpre | 31 ++++++++++++++++++
 Documentation/ABI/testing/debugfs-hisi-sec  | 31 ++++++++++++++++++
 Documentation/ABI/testing/debugfs-hisi-zip  | 31 ++++++++++++++++++
 drivers/crypto/hisilicon/qm.c               | 51 +++++++++++++++++++++++++++++
 drivers/crypto/hisilicon/qm.h               |  9 +++++
 5 files changed, 153 insertions(+)

diff --git a/Documentation/ABI/testing/debugfs-hisi-hpre b/Documentation/ABI/testing/debugfs-hisi-hpre
index ec4a79e..1f96665 100644
--- a/Documentation/ABI/testing/debugfs-hisi-hpre
+++ b/Documentation/ABI/testing/debugfs-hisi-hpre
@@ -55,3 +55,34 @@ Description:    QM debug registers(qm_regs) read clear control. 1 means enable
 		Writing to this file has no functional effect, only enable or
 		disable counters clear after reading of these registers.
 		Only available for PF.
+
+What:           /sys/kernel/debug/hisi_hpre/<bdf>/qm/err_irq
+Date:           Apr 2020
+Contact:        linux-crypto@vger.kernel.org
+Description:    Dump the number of invalid interrupts for
+		QM task completion.
+		Available for both PF and VF, and take no other effect on HPRE.
+
+What:           /sys/kernel/debug/hisi_hpre/<bdf>/qm/aeq_irq
+Date:           Apr 2020
+Contact:        linux-crypto@vger.kernel.org
+Description:    Dump the number of QM async event queue interrupts.
+		Available for both PF and VF, and take no other effect on HPRE.
+
+What:           /sys/kernel/debug/hisi_hpre/<bdf>/qm/abnormal_irq
+Date:           Apr 2020
+Contact:        linux-crypto@vger.kernel.org
+Description:    Dump the number of interrupts for QM abnormal event.
+		Available for both PF and VF, and take no other effect on HPRE.
+
+What:           /sys/kernel/debug/hisi_hpre/<bdf>/qm/create_qp_err
+Date:           Apr 2020
+Contact:        linux-crypto@vger.kernel.org
+Description:    Dump the number of queue allocation errors.
+		Available for both PF and VF, and take no other effect on HPRE.
+
+What:           /sys/kernel/debug/hisi_hpre/<bdf>/qm/mb_err
+Date:           Apr 2020
+Contact:        linux-crypto@vger.kernel.org
+Description:    Dump the number of failed QM mailbox commands.
+		Available for both PF and VF, and take no other effect on HPRE.
diff --git a/Documentation/ABI/testing/debugfs-hisi-sec b/Documentation/ABI/testing/debugfs-hisi-sec
index 06adb89..c3ba09c 100644
--- a/Documentation/ABI/testing/debugfs-hisi-sec
+++ b/Documentation/ABI/testing/debugfs-hisi-sec
@@ -41,3 +41,34 @@ Description:    Enabling/disabling of clear action after reading
 		the SEC's QM debug registers.
 		0: disable, 1: enable.
 		Only available for PF, and take no other effect on SEC.
+
+What:           /sys/kernel/debug/hisi_sec2/<bdf>/qm/err_irq
+Date:           Apr 2020
+Contact:        linux-crypto@vger.kernel.org
+Description:    Dump the number of invalid interrupts for
+		QM task completion.
+		Available for both PF and VF, and take no other effect on SEC.
+
+What:           /sys/kernel/debug/hisi_sec2/<bdf>/qm/aeq_irq
+Date:           Apr 2020
+Contact:        linux-crypto@vger.kernel.org
+Description:    Dump the number of QM async event queue interrupts.
+		Available for both PF and VF, and take no other effect on SEC.
+
+What:           /sys/kernel/debug/hisi_sec2/<bdf>/qm/abnormal_irq
+Date:           Apr 2020
+Contact:        linux-crypto@vger.kernel.org
+Description:    Dump the number of interrupts for QM abnormal event.
+		Available for both PF and VF, and take no other effect on SEC.
+
+What:           /sys/kernel/debug/hisi_sec2/<bdf>/qm/create_qp_err
+Date:           Apr 2020
+Contact:        linux-crypto@vger.kernel.org
+Description:    Dump the number of queue allocation errors.
+		Available for both PF and VF, and take no other effect on SEC.
+
+What:           /sys/kernel/debug/hisi_sec2/<bdf>/qm/mb_err
+Date:           Apr 2020
+Contact:        linux-crypto@vger.kernel.org
+Description:    Dump the number of failed QM mailbox commands.
+		Available for both PF and VF, and take no other effect on SEC.
diff --git a/Documentation/ABI/testing/debugfs-hisi-zip b/Documentation/ABI/testing/debugfs-hisi-zip
index a7c63e6..cc568fd 100644
--- a/Documentation/ABI/testing/debugfs-hisi-zip
+++ b/Documentation/ABI/testing/debugfs-hisi-zip
@@ -48,3 +48,34 @@ Description:    QM debug registers(qm_regs) read clear control. 1 means enable
 		Writing to this file has no functional effect, only enable or
 		disable counters clear after reading of these registers.
 		Only available for PF.
+
+What:           /sys/kernel/debug/hisi_zip/<bdf>/qm/err_irq
+Date:           Apr 2020
+Contact:        linux-crypto@vger.kernel.org
+Description:    Dump the number of invalid interrupts for
+		QM task completion.
+		Available for both PF and VF, and take no other effect on ZIP.
+
+What:           /sys/kernel/debug/hisi_zip/<bdf>/qm/aeq_irq
+Date:           Apr 2020
+Contact:        linux-crypto@vger.kernel.org
+Description:    Dump the number of QM async event queue interrupts.
+		Available for both PF and VF, and take no other effect on ZIP.
+
+What:           /sys/kernel/debug/hisi_zip/<bdf>/qm/abnormal_irq
+Date:           Apr 2020
+Contact:        linux-crypto@vger.kernel.org
+Description:    Dump the number of interrupts for QM abnormal event.
+		Available for both PF and VF, and take no other effect on ZIP.
+
+What:           /sys/kernel/debug/hisi_zip/<bdf>/qm/create_qp_err
+Date:           Apr 2020
+Contact:        linux-crypto@vger.kernel.org
+Description:    Dump the number of queue allocation errors.
+		Available for both PF and VF, and take no other effect on ZIP.
+
+What:           /sys/kernel/debug/hisi_zip/<bdf>/qm/mb_err
+Date:           Apr 2020
+Contact:        linux-crypto@vger.kernel.org
+Description:    Dump the number of failed QM mailbox commands.
+		Available for both PF and VF, and take no other effect on ZIP.
diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 6365f93..744d131 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -324,6 +324,19 @@ struct hisi_qm_hw_ops {
 	enum acc_err_result (*hw_error_handle)(struct hisi_qm *qm);
 };
 
+struct qm_dfx_item {
+	const char *name;
+	u32 offset;
+};
+
+static struct qm_dfx_item qm_dfx_files[] = {
+	{"err_irq", offsetof(struct qm_dfx, err_irq_cnt)},
+	{"aeq_irq", offsetof(struct qm_dfx, aeq_irq_cnt)},
+	{"abnormal_irq", offsetof(struct qm_dfx, abnormal_irq_cnt)},
+	{"create_qp_err", offsetof(struct qm_dfx, create_qp_err_cnt)},
+	{"mb_err", offsetof(struct qm_dfx, mb_err_cnt)},
+};
+
 static const char * const qm_debug_file_name[] = {
 	[CURRENT_Q]    = "current_q",
 	[CLEAR_ENABLE] = "clear_enable",
@@ -514,6 +527,8 @@ static int qm_mb(struct hisi_qm *qm, u8 cmd, dma_addr_t dma_addr, u16 queue,
 busy_unlock:
 	mutex_unlock(&qm->mailbox_lock);
 
+	if (ret)
+		atomic64_inc(&qm->debug.dfx.mb_err_cnt);
 	return ret;
 }
 
@@ -671,6 +686,7 @@ static irqreturn_t qm_irq(int irq, void *data)
 	if (readl(qm->io_base + QM_VF_EQ_INT_SOURCE))
 		return do_qm_irq(irq, data);
 
+	atomic64_inc(&qm->debug.dfx.err_irq_cnt);
 	dev_err(&qm->pdev->dev, "invalid int source\n");
 	qm_db(qm, 0, QM_DOORBELL_CMD_EQ, qm->status.eq_head, 0);
 
@@ -683,6 +699,7 @@ static irqreturn_t qm_aeq_irq(int irq, void *data)
 	struct qm_aeqe *aeqe = qm->aeqe + qm->status.aeq_head;
 	u32 type;
 
+	atomic64_inc(&qm->debug.dfx.aeq_irq_cnt);
 	if (!readl(qm->io_base + QM_VF_AEQ_INT_SOURCE))
 		return IRQ_NONE;
 
@@ -1192,6 +1209,7 @@ static struct hisi_qp *qm_create_qp_nolock(struct hisi_qm *qm, u8 alg_type)
 	if (qm->qp_in_used == qm->qp_num) {
 		dev_info_ratelimited(dev, "All %u queues of QM are busy!\n",
 				     qm->qp_num);
+		atomic64_inc(&qm->debug.dfx.create_qp_err_cnt);
 		return ERR_PTR(-EBUSY);
 	}
 
@@ -1199,6 +1217,7 @@ static struct hisi_qp *qm_create_qp_nolock(struct hisi_qm *qm, u8 alg_type)
 	if (qp_id < 0) {
 		dev_info_ratelimited(dev, "All %u queues of QM are busy!\n",
 				    qm->qp_num);
+		atomic64_inc(&qm->debug.dfx.create_qp_err_cnt);
 		return ERR_PTR(-EBUSY);
 	}
 
@@ -2249,6 +2268,26 @@ int hisi_qm_stop(struct hisi_qm *qm)
 }
 EXPORT_SYMBOL_GPL(hisi_qm_stop);
 
+static int qm_debugfs_atomic64_set(void *data, u64 val)
+{
+	if (val)
+		return -EINVAL;
+
+	atomic64_set((atomic64_t *)data, 0);
+
+	return 0;
+}
+
+static int qm_debugfs_atomic64_get(void *data, u64 *val)
+{
+	*val = atomic64_read((atomic64_t *)data);
+
+	return 0;
+}
+
+DEFINE_DEBUGFS_ATTRIBUTE(qm_atomic64_ops, qm_debugfs_atomic64_get,
+			 qm_debugfs_atomic64_set, "%llu\n");
+
 /**
  * hisi_qm_debug_init() - Initialize qm related debugfs files.
  * @qm: The qm for which we want to add debugfs files.
@@ -2257,7 +2296,9 @@ EXPORT_SYMBOL_GPL(hisi_qm_stop);
  */
 int hisi_qm_debug_init(struct hisi_qm *qm)
 {
+	struct qm_dfx *dfx = &qm->debug.dfx;
 	struct dentry *qm_d;
+	void *data;
 	int i, ret;
 
 	qm_d = debugfs_create_dir("qm", qm->debug.debug_root);
@@ -2273,6 +2314,15 @@ int hisi_qm_debug_init(struct hisi_qm *qm)
 
 	debugfs_create_file("qm_regs", 0444, qm->debug.qm_d, qm, &qm_regs_fops);
 
+	for (i = 0; i < ARRAY_SIZE(qm_dfx_files); i++) {
+		data = (atomic64_t *)((uintptr_t)dfx + qm_dfx_files[i].offset);
+		debugfs_create_file(qm_dfx_files[i].name,
+			0644,
+			qm_d,
+			data,
+			&qm_atomic64_ops);
+	}
+
 	return 0;
 
 failed_to_create:
@@ -3311,6 +3361,7 @@ static irqreturn_t qm_abnormal_irq(int irq, void *data)
 	struct hisi_qm *qm = data;
 	enum acc_err_result ret;
 
+	atomic64_inc(&qm->debug.dfx.abnormal_irq_cnt);
 	ret = qm_process_dev_error(qm);
 	if (ret == ACC_ERR_NEED_RESET)
 		schedule_work(&qm->rst_work);
diff --git a/drivers/crypto/hisilicon/qm.h b/drivers/crypto/hisilicon/qm.h
index a431ff2..e4b46a7 100644
--- a/drivers/crypto/hisilicon/qm.h
+++ b/drivers/crypto/hisilicon/qm.h
@@ -121,6 +121,14 @@ enum qm_debug_file {
 	DEBUG_FILE_NUM,
 };
 
+struct qm_dfx {
+	atomic64_t err_irq_cnt;
+	atomic64_t aeq_irq_cnt;
+	atomic64_t abnormal_irq_cnt;
+	atomic64_t create_qp_err_cnt;
+	atomic64_t mb_err_cnt;
+};
+
 struct debugfs_file {
 	enum qm_debug_file index;
 	struct mutex lock;
@@ -129,6 +137,7 @@ struct debugfs_file {
 
 struct qm_debug {
 	u32 curr_qm_qp_num;
+	struct qm_dfx dfx;
 	struct dentry *debug_root;
 	struct dentry *qm_d;
 	struct debugfs_file files[DEBUG_FILE_NUM];
-- 
2.7.4

