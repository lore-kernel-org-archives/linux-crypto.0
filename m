Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66DABC47091
	for <linux-crypto@archiver.kernel.org>; Sat, 29 May 2021 14:18:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D26261157
	for <linux-crypto@archiver.kernel.org>; Sat, 29 May 2021 14:18:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbhE2OUZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 29 May 2021 10:20:25 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:2356 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbhE2OUX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 29 May 2021 10:20:23 -0400
Received: from dggeme768-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Fsk7f4z0kz1BG7g;
        Sat, 29 May 2021 22:14:06 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggeme768-chm.china.huawei.com (10.3.19.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sat, 29 May 2021 22:18:44 +0800
From:   Weili Qian <qianweili@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <wangzhou1@hisilicon.com>, <liulongfang@huawei.com>,
        Weili Qian <qianweili@huawei.com>
Subject: [PATCH 3/4] crypto: hisilicon/qm - add callback to support communication
Date:   Sat, 29 May 2021 22:15:36 +0800
Message-ID: <1622297737-46604-4-git-send-email-qianweili@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1622297737-46604-1-git-send-email-qianweili@huawei.com>
References: <1622297737-46604-1-git-send-email-qianweili@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggeme768-chm.china.huawei.com (10.3.19.114)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds 'ping_all_vfs' callback that supports pf send message to
all vfs and 'ping_pf' callback that supports vf send message to pf. After
receiving the interrupt, the communication destination gets the message
by sending mailbox.

Signed-off-by: Weili Qian <qianweili@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 217 ++++++++++++++++++++++++++++++++++++------
 1 file changed, 190 insertions(+), 27 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index a7c16c5..111142a 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -41,6 +41,8 @@
 #define QM_MB_CMD_CQC_BT		0x5
 #define QM_MB_CMD_SQC_VFT_V2		0x6
 #define QM_MB_CMD_STOP_QP		0x8
+#define QM_MB_CMD_SRC			0xc
+#define QM_MB_CMD_DST			0xd
 
 #define QM_MB_CMD_SEND_BASE		0x300
 #define QM_MB_EVENT_SHIFT		8
@@ -48,6 +50,8 @@
 #define QM_MB_OP_SHIFT			14
 #define QM_MB_CMD_DATA_ADDR_L		0x304
 #define QM_MB_CMD_DATA_ADDR_H		0x308
+#define QM_MB_PING_ALL_VFS		0xffff
+#define QM_MB_CMD_DATA_MASK		GENMASK(31, 0)
 
 /* sqc shift */
 #define QM_SQ_HOP_NUM_SHIFT		0
@@ -180,14 +184,24 @@
 #define QM_MSI_CAP_ENABLE		BIT(16)
 
 /* interfunction communication */
+#define QM_IFC_READY_STATUS		0x100128
+#define QM_IFC_INT_SET_P		0x100130
+#define QM_IFC_INT_CFG			0x100134
 #define QM_IFC_INT_SOURCE_P		0x100138
 #define QM_IFC_INT_SOURCE_V		0x0020
 #define QM_IFC_INT_MASK			0x0024
 #define QM_IFC_INT_STATUS		0x0028
+#define QM_IFC_INT_SET_V		0x002C
+#define QM_IFC_SEND_ALL_VFS		GENMASK(6, 0)
 #define QM_IFC_INT_SOURCE_CLR		GENMASK(63, 0)
 #define QM_IFC_INT_SOURCE_MASK		BIT(0)
 #define QM_IFC_INT_DISABLE		BIT(0)
 #define QM_IFC_INT_STATUS_MASK		BIT(0)
+#define QM_IFC_INT_SET_MASK		BIT(0)
+#define QM_WAIT_DST_ACK			10
+#define QM_MAX_PF_WAIT_COUNT		10
+#define QM_MAX_VF_WAIT_COUNT		40
+
 
 #define QM_DFX_MB_CNT_VF		0x104010
 #define QM_DFX_DB_CNT_VF		0x104020
@@ -370,6 +384,8 @@ struct hisi_qm_hw_ops {
 	enum acc_err_result (*hw_error_handle)(struct hisi_qm *qm);
 	int (*stop_qp)(struct hisi_qp *qp);
 	int (*set_msi)(struct hisi_qm *qm, bool set);
+	int (*ping_all_vfs)(struct hisi_qm *qm, u64 cmd);
+	int (*ping_pf)(struct hisi_qm *qm, u64 cmd);
 };
 
 struct qm_dfx_item {
@@ -510,6 +526,18 @@ static bool qm_qp_avail_state(struct hisi_qm *qm, struct hisi_qp *qp,
 	return avail;
 }
 
+static void qm_mb_pre_init(struct qm_mailbox *mailbox, u8 cmd,
+			   u64 base, u16 queue, bool op)
+{
+	mailbox->w0 = cpu_to_le16((cmd) |
+		((op) ? 0x1 << QM_MB_OP_SHIFT : 0) |
+		(0x1 << QM_MB_BUSY_SHIFT));
+	mailbox->queue_num = cpu_to_le16(queue);
+	mailbox->base_l = cpu_to_le32(lower_32_bits(base));
+	mailbox->base_h = cpu_to_le32(upper_32_bits(base));
+	mailbox->rsvd = 0;
+}
+
 /* return 0 mailbox ready, -ETIMEDOUT hardware timeout */
 static int qm_wait_mb_ready(struct hisi_qm *qm)
 {
@@ -542,44 +570,42 @@ static void qm_mb_write(struct hisi_qm *qm, const void *src)
 		     : "memory");
 }
 
-static int qm_mb(struct hisi_qm *qm, u8 cmd, dma_addr_t dma_addr, u16 queue,
-		 bool op)
+static int qm_mb_nolock(struct hisi_qm *qm, struct qm_mailbox *mailbox)
 {
-	struct qm_mailbox mailbox;
-	int ret = 0;
-
-	dev_dbg(&qm->pdev->dev, "QM mailbox request to q%u: %u-%llx\n",
-		queue, cmd, (unsigned long long)dma_addr);
-
-	mailbox.w0 = cpu_to_le16(cmd |
-		     (op ? 0x1 << QM_MB_OP_SHIFT : 0) |
-		     (0x1 << QM_MB_BUSY_SHIFT));
-	mailbox.queue_num = cpu_to_le16(queue);
-	mailbox.base_l = cpu_to_le32(lower_32_bits(dma_addr));
-	mailbox.base_h = cpu_to_le32(upper_32_bits(dma_addr));
-	mailbox.rsvd = 0;
-
-	mutex_lock(&qm->mailbox_lock);
-
 	if (unlikely(qm_wait_mb_ready(qm))) {
-		ret = -EBUSY;
 		dev_err(&qm->pdev->dev, "QM mailbox is busy to start!\n");
-		goto busy_unlock;
+		goto mb_busy;
 	}
 
-	qm_mb_write(qm, &mailbox);
+	qm_mb_write(qm, mailbox);
 
 	if (unlikely(qm_wait_mb_ready(qm))) {
-		ret = -EBUSY;
 		dev_err(&qm->pdev->dev, "QM mailbox operation timeout!\n");
-		goto busy_unlock;
+		goto mb_busy;
 	}
 
-busy_unlock:
+	return 0;
+
+mb_busy:
+	atomic64_inc(&qm->debug.dfx.mb_err_cnt);
+	return -EBUSY;
+}
+
+static int qm_mb(struct hisi_qm *qm, u8 cmd, dma_addr_t dma_addr, u16 queue,
+		 bool op)
+{
+	struct qm_mailbox mailbox;
+	int ret;
+
+	dev_dbg(&qm->pdev->dev, "QM mailbox request to q%u: %u-%llx\n",
+		queue, cmd, (unsigned long long)dma_addr);
+
+	qm_mb_pre_init(&mailbox, cmd, dma_addr, queue, op);
+
+	mutex_lock(&qm->mailbox_lock);
+	ret = qm_mb_nolock(qm, &mailbox);
 	mutex_unlock(&qm->mailbox_lock);
 
-	if (ret)
-		atomic64_inc(&qm->debug.dfx.mb_err_cnt);
 	return ret;
 }
 
@@ -1840,6 +1866,25 @@ static int qm_check_dev_error(struct hisi_qm *qm)
 	       (dev_val & (~qm->err_info.dev_ce_mask));
 }
 
+static int qm_get_mb_cmd(struct hisi_qm *qm, u64 *msg, u16 fun_num)
+{
+	struct qm_mailbox mailbox;
+	int ret;
+
+	qm_mb_pre_init(&mailbox, QM_MB_CMD_DST, 0, fun_num, 0);
+	mutex_lock(&qm->mailbox_lock);
+	ret = qm_mb_nolock(qm, &mailbox);
+	if (ret)
+		goto err_unlock;
+
+	*msg = readl(qm->io_base + QM_MB_CMD_DATA_ADDR_L) |
+		  ((u64)readl(qm->io_base + QM_MB_CMD_DATA_ADDR_H) << 32);
+
+err_unlock:
+	mutex_unlock(&qm->mailbox_lock);
+	return ret;
+}
+
 static void qm_clear_cmd_interrupt(struct hisi_qm *qm, u64 vf_mask)
 {
 	u32 val;
@@ -1857,6 +1902,108 @@ static int qm_wait_vf_prepare_finish(struct hisi_qm *qm)
 	return 0;
 }
 
+static void qm_trigger_vf_interrupt(struct hisi_qm *qm, u32 fun_num)
+{
+	u32 val;
+
+	val = readl(qm->io_base + QM_IFC_INT_CFG);
+	val |= ~QM_IFC_SEND_ALL_VFS;
+	val |= fun_num;
+	writel(val, qm->io_base + QM_IFC_INT_CFG);
+
+	val = readl(qm->io_base + QM_IFC_INT_SET_P);
+	val |= QM_IFC_INT_SET_MASK;
+	writel(val, qm->io_base + QM_IFC_INT_SET_P);
+}
+
+static void qm_trigger_pf_interrupt(struct hisi_qm *qm)
+{
+	u32 val;
+
+	val = readl(qm->io_base + QM_IFC_INT_SET_V);
+	val |= QM_IFC_INT_SET_MASK;
+	writel(val, qm->io_base + QM_IFC_INT_SET_V);
+}
+
+static int qm_ping_all_vfs(struct hisi_qm *qm, u64 cmd)
+{
+	struct device *dev = &qm->pdev->dev;
+	u32 vfs_num = qm->vfs_num;
+	struct qm_mailbox mailbox;
+	u64 val = 0;
+	int cnt = 0;
+	int ret;
+	u32 i;
+
+	qm_mb_pre_init(&mailbox, QM_MB_CMD_SRC, cmd, QM_MB_PING_ALL_VFS, 0);
+	mutex_lock(&qm->mailbox_lock);
+	/* PF sends command to all VFs by mailbox */
+	ret = qm_mb_nolock(qm, &mailbox);
+	if (ret) {
+		dev_err(dev, "failed to send command to VFs!\n");
+		mutex_unlock(&qm->mailbox_lock);
+		return ret;
+	}
+
+	qm_trigger_vf_interrupt(qm, QM_IFC_SEND_ALL_VFS);
+	while (true) {
+		msleep(QM_WAIT_DST_ACK);
+		val = readq(qm->io_base + QM_IFC_READY_STATUS);
+		/* If all VFs acked, PF notifies VFs successfully. */
+		if (!(val & GENMASK(vfs_num, 1))) {
+			mutex_unlock(&qm->mailbox_lock);
+			return 0;
+		}
+
+		if (++cnt > QM_MAX_PF_WAIT_COUNT)
+			break;
+	}
+
+	mutex_unlock(&qm->mailbox_lock);
+
+	/* Check which vf respond timeout. */
+	for (i = 1; i <= vfs_num; i++) {
+		if (val & BIT(i))
+			dev_err(dev, "failed to get response from VF(%u)!\n", i);
+	}
+
+	return -ETIMEDOUT;
+}
+
+static int qm_ping_pf(struct hisi_qm *qm, u64 cmd)
+{
+	struct qm_mailbox mailbox;
+	int cnt = 0;
+	u32 val;
+	int ret;
+
+	qm_mb_pre_init(&mailbox, QM_MB_CMD_SRC, cmd, 0, 0);
+	mutex_lock(&qm->mailbox_lock);
+	ret = qm_mb_nolock(qm, &mailbox);
+	if (ret) {
+		dev_err(&qm->pdev->dev, "failed to send command to PF!\n");
+		goto unlock;
+	}
+
+	qm_trigger_pf_interrupt(qm);
+	/* Waiting for PF response */
+	while (true) {
+		msleep(QM_WAIT_DST_ACK);
+		val = readl(qm->io_base + QM_IFC_INT_SET_V);
+		if (!(val & QM_IFC_INT_STATUS_MASK))
+			break;
+
+		if (++cnt > QM_MAX_VF_WAIT_COUNT) {
+			ret = -ETIMEDOUT;
+			break;
+		}
+	}
+
+unlock:
+	mutex_unlock(&qm->mailbox_lock);
+	return ret;
+}
+
 static int qm_stop_qp(struct hisi_qp *qp)
 {
 	return qm_mb(qp->qm, QM_MB_CMD_STOP_QP, 0, qp->qp_id, 0);
@@ -1975,6 +2122,8 @@ static const struct hisi_qm_hw_ops qm_hw_ops_v3 = {
 	.hw_error_handle = qm_hw_error_handle_v2,
 	.stop_qp = qm_stop_qp,
 	.set_msi = qm_set_msi_v3,
+	.ping_all_vfs = qm_ping_all_vfs,
+	.ping_pf = qm_ping_pf,
 };
 
 static void *qm_get_avail_sqe(struct hisi_qp *qp)
@@ -4481,7 +4630,21 @@ static void hisi_qm_controller_reset(struct work_struct *rst_work)
 
 static void qm_cmd_process(struct work_struct *cmd_process)
 {
-	/* handling messages sent by communication source */
+	struct hisi_qm *qm = container_of(cmd_process,
+					struct hisi_qm, cmd_process);
+	struct device *dev = &qm->pdev->dev;
+	u64 msg;
+	int ret;
+
+	/*
+	 * Get the msg from source by sending mailbox. Whether message is got
+	 * successfully, destination needs to ack source by clearing the interrupt.
+	 */
+	ret = qm_get_mb_cmd(qm, &msg, 0);
+	qm_clear_cmd_interrupt(qm, 0);
+	if (ret)
+		dev_err(dev, "failed to get msg from source!\n");
+
 }
 
 /**
-- 
2.8.1

