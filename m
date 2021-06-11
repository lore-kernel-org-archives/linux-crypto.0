Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5D2CC48BE0
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Jun 2021 09:07:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3A83613CA
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Jun 2021 09:07:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231532AbhFKJJU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Jun 2021 05:09:20 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3962 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231530AbhFKJJP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Jun 2021 05:09:15 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G1Zdz6hX9z6xXr;
        Fri, 11 Jun 2021 17:04:07 +0800 (CST)
Received: from dggpeml500012.china.huawei.com (7.185.36.15) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 11 Jun 2021 17:07:09 +0800
Received: from huawei.com (10.69.192.56) by dggpeml500012.china.huawei.com
 (7.185.36.15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Fri, 11 Jun
 2021 17:07:09 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wangzhou1@hisilicon.com>, <yekai13@huawei.com>
Subject: [PATCH 5/8] crypto: hisilicon/qm - supports to inquiry each function's QoS
Date:   Fri, 11 Jun 2021 17:06:47 +0800
Message-ID: <1623402410-63906-6-git-send-email-yekai13@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1623402410-63906-1-git-send-email-yekai13@huawei.com>
References: <1623402410-63906-1-git-send-email-yekai13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500012.china.huawei.com (7.185.36.15)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

1. The ACC driver supports to inquiry each function's QoS in the Host
and VM. The driver supports reading QoS by the device debug SysFS
attribute file "alg_qos", like "cat alg_qos".
2. Modify the communication process between pf and vf as needed.

Signed-off-by: Kai Ye <yekai13@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 181 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 174 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 72648dc..636432c 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -51,6 +51,7 @@
 #define QM_MB_CMD_DATA_ADDR_L		0x304
 #define QM_MB_CMD_DATA_ADDR_H		0x308
 #define QM_MB_PING_ALL_VFS		0xffff
+#define QM_MB_CMD_DATA_SHIFT		32
 #define QM_MB_CMD_DATA_MASK		GENMASK(31, 0)
 
 /* sqc shift */
@@ -185,6 +186,7 @@
 
 /* interfunction communication */
 #define QM_IFC_READY_STATUS		0x100128
+#define QM_IFC_C_STS_M			0x10012C
 #define QM_IFC_INT_SET_P		0x100130
 #define QM_IFC_INT_CFG			0x100134
 #define QM_IFC_INT_SOURCE_P		0x100138
@@ -256,6 +258,7 @@
 #define QM_SHAPER_CBS_B			1
 #define QM_SHAPER_CBS_S			16
 #define QM_SHAPER_VFT_OFFSET		6
+#define WAIT_FOR_QOS_VF			100
 #define QM_QOS_MIN_ERROR_RATE		5
 #define QM_QOS_TYPICAL_NUM		8
 #define QM_SHAPER_MIN_CBS_S		8
@@ -328,6 +331,8 @@ enum qm_mb_cmd {
 	QM_VF_PREPARE_FAIL,
 	QM_VF_START_DONE,
 	QM_VF_START_FAIL,
+	QM_PF_SET_QOS,
+	QM_VF_GET_QOS,
 };
 
 struct qm_cqe {
@@ -2124,7 +2129,7 @@ static void qm_trigger_vf_interrupt(struct hisi_qm *qm, u32 fun_num)
 	u32 val;
 
 	val = readl(qm->io_base + QM_IFC_INT_CFG);
-	val |= ~QM_IFC_SEND_ALL_VFS;
+	val &= ~QM_IFC_SEND_ALL_VFS;
 	val |= fun_num;
 	writel(val, qm->io_base + QM_IFC_INT_CFG);
 
@@ -3946,6 +3951,139 @@ static int qm_func_shaper_enable(struct hisi_qm *qm, u32 fun_index, u32 qos)
 	return 0;
 }
 
+static u32 qm_get_shaper_vft_qos(struct hisi_qm *qm, u32 fun_index)
+{
+	u64 cir_u = 0, cir_b = 0, cir_s = 0;
+	u64 shaper_vft, ir_calc, ir;
+	unsigned int val;
+	u32 error_rate;
+	int ret;
+
+	ret = readl_relaxed_poll_timeout(qm->io_base + QM_VFT_CFG_RDY, val,
+					 val & BIT(0), POLL_PERIOD,
+					 POLL_TIMEOUT);
+	if (ret)
+		return 0;
+
+	writel(0x1, qm->io_base + QM_VFT_CFG_OP_WR);
+	writel(SHAPER_VFT, qm->io_base + QM_VFT_CFG_TYPE);
+	writel(fun_index, qm->io_base + QM_VFT_CFG);
+
+	writel(0x0, qm->io_base + QM_VFT_CFG_RDY);
+	writel(0x1, qm->io_base + QM_VFT_CFG_OP_ENABLE);
+
+	ret = readl_relaxed_poll_timeout(qm->io_base + QM_VFT_CFG_RDY, val,
+					 val & BIT(0), POLL_PERIOD,
+					 POLL_TIMEOUT);
+	if (ret)
+		return 0;
+
+	shaper_vft = readl(qm->io_base + QM_VFT_CFG_DATA_L) |
+		  ((u64)readl(qm->io_base + QM_VFT_CFG_DATA_H) << 32);
+
+	cir_b = shaper_vft & QM_SHAPER_CIR_B_MASK;
+	cir_u = shaper_vft & QM_SHAPER_CIR_U_MASK;
+	cir_u = cir_u >> QM_SHAPER_FACTOR_CIR_U_SHIFT;
+
+	cir_s = shaper_vft & QM_SHAPER_CIR_S_MASK;
+	cir_s = cir_s >> QM_SHAPER_FACTOR_CIR_S_SHIFT;
+
+	ir_calc = acc_shaper_para_calc(cir_b, cir_u, cir_s);
+
+	ir = qm->factor[fun_index].func_qos * QM_QOS_RATE;
+
+	error_rate = QM_QOS_EXPAND_RATE * (u32)abs(ir_calc - ir) / ir;
+	if (error_rate > QM_QOS_MIN_ERROR_RATE) {
+		pci_err(qm->pdev, "error_rate: %u, get function qos is error!\n", error_rate);
+		return 0;
+	}
+
+	return ir;
+}
+
+static void qm_vf_get_qos(struct hisi_qm *qm, u32 fun_num)
+{
+	struct device *dev = &qm->pdev->dev;
+	u64 mb_cmd;
+	u32 qos;
+	int ret;
+
+	qos = qm_get_shaper_vft_qos(qm, fun_num);
+	if (!qos) {
+		dev_err(dev, "function(%u) failed to get qos by PF!\n", fun_num);
+		return;
+	}
+
+	mb_cmd = QM_PF_SET_QOS | (u64)qos << QM_MB_CMD_DATA_SHIFT;
+	ret = qm_ping_single_vf(qm, mb_cmd, fun_num);
+	if (ret)
+		dev_err(dev, "failed to send cmd to VF(%u)!\n", fun_num);
+}
+
+static int qm_vf_read_qos(struct hisi_qm *qm)
+{
+	int cnt = 0;
+	int ret;
+
+	/* reset mailbox qos val */
+	qm->mb_qos = 0;
+
+	/* vf ping pf to get function qos */
+	if (qm->ops->ping_pf) {
+		ret = qm->ops->ping_pf(qm, QM_VF_GET_QOS);
+		if (ret) {
+			pci_err(qm->pdev, "failed to send cmd to PF to get qos!\n");
+			return ret;
+		}
+	}
+
+	while (true) {
+		msleep(QM_WAIT_DST_ACK);
+		if (qm->mb_qos)
+			break;
+
+		if (++cnt > QM_MAX_VF_WAIT_COUNT) {
+			pci_err(qm->pdev, "PF ping VF timeout!\n");
+			return  -ETIMEDOUT;
+		}
+	}
+
+	return ret;
+}
+
+static ssize_t qm_algqos_read(struct file *filp, char __user *buf,
+			       size_t count, loff_t *pos)
+{
+	struct hisi_qm *qm = filp->private_data;
+	char tbuf[QM_DBG_READ_LEN];
+	u32 qos_val, ir;
+	int ret;
+
+	/* Mailbox and reset cannot be operated at the same time */
+	if (test_and_set_bit(QM_RESETTING, &qm->misc_ctl)) {
+		pci_err(qm->pdev, "dev resetting, read alg qos failed!\n");
+		return  -EAGAIN;
+	}
+
+	if (qm->fun_type == QM_HW_PF) {
+		ir = qm_get_shaper_vft_qos(qm, 0);
+	} else {
+		ret = qm_vf_read_qos(qm);
+		if (ret)
+			goto err_get_status;
+		ir = qm->mb_qos;
+	}
+
+	qos_val = ir / QM_QOS_RATE;
+	ret = scnprintf(tbuf, QM_DBG_READ_LEN, "%u\n", qos_val);
+
+	ret =  simple_read_from_buffer(buf, count, pos, tbuf, ret);
+
+err_get_status:
+	clear_bit(QM_RESETTING, &qm->misc_ctl);
+	return ret;
+}
+
 static ssize_t qm_qos_value_init(const char *buf, unsigned long *val)
 {
 	int buflen = strlen(buf);
@@ -4040,6 +4178,7 @@ static ssize_t qm_algqos_write(struct file *filp, const char __user *buf,
 static const struct file_operations qm_algqos_fops = {
 	.owner = THIS_MODULE,
 	.open = simple_open,
+	.read = qm_algqos_read,
 	.write = qm_algqos_write,
 };
 
@@ -5149,10 +5288,8 @@ static void qm_pf_reset_vf_process(struct hisi_qm *qm,
 	qm_reset_bit_clear(qm);
 }
 
-static void qm_cmd_process(struct work_struct *cmd_process)
+static void qm_handle_cmd_msg(struct hisi_qm *qm, u32 fun_num)
 {
-	struct hisi_qm *qm = container_of(cmd_process,
-					struct hisi_qm, cmd_process);
 	struct device *dev = &qm->pdev->dev;
 	u64 msg;
 	u32 cmd;
@@ -5162,8 +5299,8 @@ static void qm_cmd_process(struct work_struct *cmd_process)
 	 * Get the msg from source by sending mailbox. Whether message is got
 	 * successfully, destination needs to ack source by clearing the interrupt.
 	 */
-	ret = qm_get_mb_cmd(qm, &msg, 0);
-	qm_clear_cmd_interrupt(qm, 0);
+	ret = qm_get_mb_cmd(qm, &msg, fun_num);
+	qm_clear_cmd_interrupt(qm, BIT(fun_num));
 	if (ret) {
 		dev_err(dev, "failed to get msg from source!\n");
 		return;
@@ -5177,12 +5314,42 @@ static void qm_cmd_process(struct work_struct *cmd_process)
 	case QM_PF_SRST_PREPARE:
 		qm_pf_reset_vf_process(qm, QM_SOFT_RESET);
 		break;
+	case QM_VF_GET_QOS:
+		qm_vf_get_qos(qm, fun_num);
+		break;
+	case QM_PF_SET_QOS:
+		qm->mb_qos = msg >> QM_MB_CMD_DATA_SHIFT;
+		break;
 	default:
-		dev_err(dev, "unsupported cmd %u sent by PF!\n", cmd);
+		dev_err(dev, "unsupported cmd %u sent by function(%u)!\n", cmd, fun_num);
 		break;
 	}
 }
 
+static void qm_cmd_process(struct work_struct *cmd_process)
+{
+	struct hisi_qm *qm = container_of(cmd_process,
+					struct hisi_qm, cmd_process);
+	u32 vfs_num = qm->vfs_num;
+	u64 val;
+	u32 i;
+
+	if (qm->fun_type == QM_HW_PF) {
+		val = readq(qm->io_base + QM_IFC_INT_SOURCE_P);
+		if (!val)
+			return;
+
+		for (i = 1; i <= vfs_num; i++) {
+			if (val & BIT(i))
+				qm_handle_cmd_msg(qm, i);
+		}
+
+		return;
+	}
+
+	qm_handle_cmd_msg(qm, 0);
+}
+
 /**
  * hisi_qm_alg_register() - Register alg to crypto and add qm to qm_list.
  * @qm: The qm needs add.
-- 
2.7.4

