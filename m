Return-Path: <SRS0=oFif=NX=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-pf1-f193.google.com ([209.85.210.193]:34788 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728237AbeKLRwQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Nov 2018 12:52:16 -0500
From: Kenneth Lee <nek.in.cn@gmail.com>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Tim Sell <timothy.sell@unisys.com>,
        Sanyog Kale <sanyog.r.kale@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?=
        <u.kleine-koenig@pengutronix.de>, Vinod Koul <vkoul@kernel.org>,
        David Kershner <david.kershner@unisys.com>,
        Sagar Dharia <sdharia@codeaurora.org>,
        Gavin Schenk <g.schenk@eckelmann.de>,
        Jens Axboe <axboe@kernel.dk>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Cyrille Pitchen <cyrille.pitchen@free-electrons.com>,
        Johan Hovold <johan@kernel.org>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Hao Fang <fanghao11@huawei.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Zaibo Xu <xuzaibo@huawei.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-accelerators@lists.ozlabs.org
Cc: linuxarm@huawei.com, guodong.xu@linaro.org,
        zhangfei.gao@foxmail.com, haojian.zhuang@linaro.org,
        Kenneth Lee <liguozhu@hisilicon.com>
Subject: [RFCv3 PATCH 3/6] crypto/hisilicon: add hisilicon Queue Manager driver
Date: Mon, 12 Nov 2018 15:58:04 +0800
Message-Id: <20181112075807.9291-4-nek.in.cn@gmail.com>
In-Reply-To: <20181112075807.9291-1-nek.in.cn@gmail.com>
References: <20181112075807.9291-1-nek.in.cn@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Kenneth Lee <liguozhu@hisilicon.com>

Hisilicon QM is a general IP used by some Hisilicon accelerators. It
provides a general PCIE device interface for the CPU and the accelerator
to share a group of queues.

QM is implemented as an End Point of the virtual PCI-E bus in Hisilicon
SoC. It is actually a interface wrapper of ARM SMMU and GIC standard.

A QM provides 1024 channels, namely queue pairs, to the CPU. It also
support SR-IOV with maximum 64 VFs. The queue pairs can be distributed
to the PF or VFs according to configuration to the PF. The hardware
configuration and notification is done in the VF/PF BAR space, while the
queue elements are stored in memory.  Software application sends
requests as messages to the accelerator via the queue protocol, which is
FIFO ring buffer protocol based on share memory.

The accelerator integrating a QM, has its own vendor, device ID, and
message format. The QM just forwards the message accordingly. Every QM
has its own SMMU (Unit) for address translation. It does not support
ATS/PRI, but it support SMMU stall mode. So it can do page fault from
the devices side.

This patch includes a library used by the accelerator driver to access
the QM hardware.

Signed-off-by: Kenneth Lee <liguozhu@hisilicon.com>
Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
Signed-off-by: Hao Fang <fanghao11@huawei.com>
---
 drivers/crypto/hisilicon/Kconfig     |   5 +-
 drivers/crypto/hisilicon/Makefile    |   1 +
 drivers/crypto/hisilicon/qm.c        | 743 +++++++++++++++++++++++++++
 drivers/crypto/hisilicon/qm.h        | 213 ++++++++
 drivers/crypto/hisilicon/qm_usr_if.h |  32 ++
 5 files changed, 993 insertions(+), 1 deletion(-)
 create mode 100644 drivers/crypto/hisilicon/qm.c
 create mode 100644 drivers/crypto/hisilicon/qm.h
 create mode 100644 drivers/crypto/hisilicon/qm_usr_if.h

diff --git a/drivers/crypto/hisilicon/Kconfig b/drivers/crypto/hisilicon/Kconfig
index 8ca9c503bcb0..0e40f4a6666b 100644
--- a/drivers/crypto/hisilicon/Kconfig
+++ b/drivers/crypto/hisilicon/Kconfig
@@ -1,5 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0
-
 config CRYPTO_DEV_HISI_SEC
 	tristate "Support for Hisilicon SEC crypto block cipher accelerator"
 	select CRYPTO_BLKCIPHER
@@ -12,3 +11,7 @@ config CRYPTO_DEV_HISI_SEC
 
 	  To compile this as a module, choose M here: the module
 	  will be called hisi_sec.
+
+config CRYPTO_DEV_HISI_QM
+	tristate
+	depends on ARM64 && PCI
diff --git a/drivers/crypto/hisilicon/Makefile b/drivers/crypto/hisilicon/Makefile
index 463f46ace182..05e9052e0f52 100644
--- a/drivers/crypto/hisilicon/Makefile
+++ b/drivers/crypto/hisilicon/Makefile
@@ -1,2 +1,3 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_CRYPTO_DEV_HISI_SEC) += sec/
+obj-$(CONFIG_CRYPTO_DEV_HISI_QM) += qm.o
diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
new file mode 100644
index 000000000000..5b810a6f4dd5
--- /dev/null
+++ b/drivers/crypto/hisilicon/qm.c
@@ -0,0 +1,743 @@
+// SPDX-License-Identifier: GPL-2.0+
+#include <asm/page.h>
+#include <linux/bitmap.h>
+#include <linux/dma-mapping.h>
+#include <linux/io.h>
+#include <linux/irqreturn.h>
+#include <linux/log2.h>
+#include "qm.h"
+
+#define QM_DEF_Q_NUM			128
+
+/* eq/aeq irq enable */
+#define QM_VF_AEQ_INT_SOURCE		0x0
+#define QM_VF_AEQ_INT_MASK		0x4
+#define QM_VF_EQ_INT_SOURCE		0x8
+#define QM_VF_EQ_INT_MASK		0xc
+
+/* mailbox */
+#define MAILBOX_CMD_SQC			0x0
+#define MAILBOX_CMD_CQC			0x1
+#define MAILBOX_CMD_EQC			0x2
+#define MAILBOX_CMD_AEQC		0x3
+#define MAILBOX_CMD_SQC_BT		0x4
+#define MAILBOX_CMD_CQC_BT		0x5
+
+#define MAILBOX_CMD_SEND_BASE		0x300
+#define MAILBOX_EVENT_SHIFT		8
+#define MAILBOX_STATUS_SHIFT		9
+#define MAILBOX_BUSY_SHIFT		13
+#define MAILBOX_OP_SHIFT		14
+#define MAILBOX_QUEUE_SHIFT		16
+
+/* sqc shift */
+#define SQ_HEAD_SHIFT			0
+#define SQ_TAIL_SHIFT			16
+#define SQ_HOP_NUM_SHIFT		0
+#define SQ_PAGE_SIZE_SHIFT		4
+#define SQ_BUF_SIZE_SHIFT		8
+#define SQ_SQE_SIZE_SHIFT		12
+#define SQ_HEAD_IDX_SIG_SHIFT		0
+#define SQ_TAIL_IDX_SIG_SHIFT		0
+#define SQ_CQN_SHIFT			0
+#define SQ_PRIORITY_SHIFT		0
+#define SQ_ORDERS_SHIFT			4
+#define SQ_TYPE_SHIFT			8
+
+#define SQ_TYPE_MASK			0xf
+
+/* cqc shift */
+#define CQ_HEAD_SHIFT			0
+#define CQ_TAIL_SHIFT			16
+#define CQ_HOP_NUM_SHIFT		0
+#define CQ_PAGE_SIZE_SHIFT		4
+#define CQ_BUF_SIZE_SHIFT		8
+#define CQ_SQE_SIZE_SHIFT		12
+#define CQ_PASID			0
+#define CQ_HEAD_IDX_SIG_SHIFT		0
+#define CQ_TAIL_IDX_SIG_SHIFT		0
+#define CQ_CQN_SHIFT			0
+#define CQ_PRIORITY_SHIFT		16
+#define CQ_ORDERS_SHIFT			0
+#define CQ_TYPE_SHIFT			0
+#define CQ_PHASE_SHIFT			0
+#define CQ_FLAG_SHIFT			1
+
+#define CQC_HEAD_INDEX(cqc)		((cqc)->cq_head)
+#define CQC_PHASE(cqc)			(((cqc)->dw6) & 0x1)
+#define CQC_CQ_ADDRESS(cqc)		(((u64)((cqc)->cq_base_h) << 32) | \
+					 ((cqc)->cq_base_l))
+#define CQC_PHASE_BIT			0x1
+
+/* eqc shift */
+#define MB_EQC_EQE_SHIFT		12
+#define MB_EQC_PHASE_SHIFT		16
+
+#define EQC_HEAD_INDEX(eqc)		((eqc)->eq_head)
+#define EQC_TAIL_INDEX(eqc)		((eqc)->eq_tail)
+#define EQC_PHASE(eqc)			((((eqc)->dw6) >> 16) & 0x1)
+
+#define EQC_PHASE_BIT			0x00010000
+
+/* aeqc shift */
+#define MB_AEQC_AEQE_SHIFT		12
+#define MB_AEQC_PHASE_SHIFT		16
+
+/* cqe shift */
+#define CQE_PHASE(cqe)			((cqe)->w7 & 0x1)
+
+/* eqe shift */
+#define EQE_PHASE(eqe)			(((eqe)->dw0 >> 16) & 0x1)
+#define EQE_CQN(eqe)			(((eqe)->dw0) & 0xffff)
+
+#define QM_EQE_CQN_MASK			0xffff
+
+/* doorbell */
+#define DOORBELL_CMD_SQ			0
+#define DOORBELL_CMD_CQ			1
+#define DOORBELL_CMD_EQ			2
+#define DOORBELL_CMD_AEQ		3
+
+#define DOORBELL_CMD_SEND_BASE		0x340
+
+#define QM_MEM_START_INIT		0x100040
+#define QM_MEM_INIT_DONE		0x100044
+#define QM_VFT_CFG_RDY			0x10006c
+#define QM_VFT_CFG_OP_WR		0x100058
+#define QM_VFT_CFG_TYPE			0x10005c
+#define QM_SQC_VFT			0x0
+#define QM_CQC_VFT			0x1
+#define QM_VFT_CFG_ADDRESS		0x100060
+#define QM_VFT_CFG_OP_ENABLE		0x100054
+
+#define QM_VFT_CFG_DATA_L		0x100064
+#define QM_VFT_CFG_DATA_H		0x100068
+#define QM_SQC_VFT_BUF_SIZE		(7ULL << 8)
+#define QM_SQC_VFT_SQC_SIZE		(5ULL << 12)
+#define QM_SQC_VFT_INDEX_NUMBER		(1ULL << 16)
+#define QM_SQC_VFT_BT_INDEX_SHIFT	22
+#define QM_SQC_VFT_START_SQN_SHIFT	28
+#define QM_SQC_VFT_VALID		(1ULL << 44)
+#define QM_CQC_VFT_BUF_SIZE		(7ULL << 8)
+#define QM_CQC_VFT_SQC_SIZE		(5ULL << 12)
+#define QM_CQC_VFT_INDEX_NUMBER		(1ULL << 16)
+#define QM_CQC_VFT_BT_INDEX_SHIFT	22
+#define QM_CQC_VFT_VALID		(1ULL << 28)
+
+
+#define QM_MK_SQC_DW3(hop_num, page_sz, buf_sz, sqe_sz) \
+	((hop_num << SQ_HOP_NUM_SHIFT) | \
+	 (page_sz << SQ_PAGE_SIZE_SHIFT) | \
+	 (buf_sz << SQ_BUF_SIZE_SHIFT) | \
+	 (sqe_sz << SQ_SQE_SIZE_SHIFT))
+#define QM_MK_SQC_W13(priority, orders, type) \
+	((priority << SQ_PRIORITY_SHIFT) | \
+	 (orders << SQ_ORDERS_SHIFT) | \
+	 ((type & SQ_TYPE_MASK) << SQ_TYPE_SHIFT))
+#define QM_MK_CQC_DW3(hop_num, page_sz, buf_sz, sqe_sz) \
+	((hop_num << CQ_HOP_NUM_SHIFT) | \
+	 (page_sz << CQ_PAGE_SIZE_SHIFT) | \
+	 (buf_sz << CQ_BUF_SIZE_SHIFT) | \
+	 (sqe_sz << CQ_SQE_SIZE_SHIFT))
+#define QM_MK_CQC_DW6(phase, flag) \
+	((phase << CQ_PHASE_SHIFT) | (flag << CQ_FLAG_SHIFT))
+
+static inline void qm_writel(struct qm_info *qm, u32 val, u32 offset)
+{
+	writel(val, qm->io_base + offset);
+}
+
+struct qm_info;
+
+struct hisi_acc_qm_hw_ops {
+	int (*vft_config)(struct qm_info *qm, u16 base, u32 number);
+};
+
+static inline int hacc_qm_mb_is_busy(struct qm_info *qm)
+{
+	u32 val;
+
+	return readl_relaxed_poll_timeout(QM_ADDR(qm, MAILBOX_CMD_SEND_BASE),
+		val, !((val >> MAILBOX_BUSY_SHIFT) & 0x1), 10, 1000);
+}
+
+static inline void qm_mb_write(struct qm_info *qm, void *src)
+{
+	void __iomem *fun_base = QM_ADDR(qm, MAILBOX_CMD_SEND_BASE);
+	unsigned long tmp0 = 0, tmp1 = 0;
+
+	asm volatile("ldp %0, %1, %3\n"
+		     "stp %0, %1, %2\n"
+		     "dsb sy\n"
+		     : "=&r" (tmp0),
+		       "=&r" (tmp1),
+		       "+Q" (*((char *)fun_base))
+		     : "Q" (*((char *)src))
+		     : "memory");
+}
+
+static int qm_mb(struct qm_info *qm, u8 cmd, phys_addr_t phys_addr, u16 queue,
+		   bool op, bool event)
+{
+	struct mailbox mailbox;
+	int ret;
+
+	dev_dbg(&qm->pdev->dev, "QM HW request to q-%u: %d-%llx\n", queue, cmd,
+		phys_addr);
+
+	mailbox.w0 = cmd |
+		     (event ? 0x1 << MAILBOX_EVENT_SHIFT : 0) |
+		     (op ? 0x1 << MAILBOX_OP_SHIFT : 0) |
+		     (0x1 << MAILBOX_BUSY_SHIFT);
+	mailbox.queue_num = queue;
+	mailbox.base_l = lower_32_bits(phys_addr);
+	mailbox.base_h = upper_32_bits(phys_addr);
+	mailbox.rsvd = 0;
+
+	mutex_lock(&qm->mailbox_lock);
+
+	ret = hacc_qm_mb_is_busy(qm);
+	if (unlikely(ret))
+		goto out_with_lock;
+
+	qm_mb_write(qm, &mailbox);
+	ret = hacc_qm_mb_is_busy(qm);
+	if (unlikely(ret))
+		goto out_with_lock;
+
+out_with_lock:
+	mutex_unlock(&qm->mailbox_lock);
+	return ret;
+}
+
+static void qm_db(struct qm_info *qm, u16 qn, u8 cmd, u16 index, u8 priority)
+{
+	u64 doorbell = 0;
+
+	dev_dbg(&qm->pdev->dev, "doorbell(qn=%d, cmd=%d, index=%d, pri=%d)\n",
+		qn, cmd, index, priority);
+
+	doorbell = qn | (cmd << 16) | ((u64)((index | (priority << 16)))) << 32;
+	writeq(doorbell, QM_ADDR(qm, DOORBELL_CMD_SEND_BASE));
+}
+
+/* @return 0 - cq/eq event, 1 - async event, 2 - abnormal error */
+static u32 qm_get_irq_source(struct qm_info *qm)
+{
+	return readl(QM_ADDR(qm, QM_VF_EQ_INT_SOURCE));
+}
+
+static inline struct hisi_qp *to_hisi_qp(struct qm_info *qm, struct eqe *eqe)
+{
+	u16 cqn = eqe->dw0 & QM_EQE_CQN_MASK;
+	struct hisi_qp *qp;
+
+	read_lock(&qm->qps_lock);
+	qp = qm->qp_array[cqn];
+	read_unlock(&qm->qps_lock);
+
+	return qp;
+}
+
+static inline void qm_cq_head_update(struct hisi_qp *qp)
+{
+	if (qp->qp_status.cq_head == QM_Q_DEPTH - 1) {
+		qp->cqc->dw6 = qp->cqc->dw6 ^ CQC_PHASE_BIT;
+		qp->qp_status.cq_head = 0;
+	} else {
+		qp->qp_status.cq_head++;
+	}
+}
+
+static inline void qm_poll_qp(struct hisi_qp *qp, struct qm_info *qm)
+{
+	struct cqe *cqe;
+
+	cqe = qp->cqe + qp->qp_status.cq_head;
+
+	if (qp->req_cb) {
+		while (CQE_PHASE(cqe) == CQC_PHASE(qp->cqc)) {
+			dma_rmb();
+			qp->req_cb(qp, (unsigned long)(qp->sqe +
+				   qm->sqe_size * cqe->sq_head));
+			qm_cq_head_update(qp);
+			cqe = qp->cqe + qp->qp_status.cq_head;
+		}
+	} else if (qp->event_cb) {
+		qp->event_cb(qp);
+		qm_cq_head_update(qp);
+		cqe = qp->cqe + qp->qp_status.cq_head;
+	}
+
+	qm_db(qm, qp->queue_id, DOORBELL_CMD_CQ, qp->qp_status.cq_head, 0);
+	qm_db(qm, qp->queue_id, DOORBELL_CMD_CQ, qp->qp_status.cq_head, 1);
+}
+
+static irqreturn_t qm_irq_thread(int irq, void *data)
+{
+	struct qm_info *qm = data;
+	struct eqe *eqe = qm->eqe + qm->eq_head;
+	struct eqc *eqc = qm->eqc;
+	struct hisi_qp *qp;
+
+	while (EQE_PHASE(eqe) == EQC_PHASE(eqc)) {
+		qp = to_hisi_qp(qm, eqe);
+		if (qp)
+			qm_poll_qp(qp, qm);
+
+		if (qm->eq_head == QM_Q_DEPTH - 1) {
+			eqc->dw6 = eqc->dw6 ^ EQC_PHASE_BIT;
+			eqe = qm->eqe;
+			qm->eq_head = 0;
+		} else {
+			eqe++;
+			qm->eq_head++;
+		}
+	}
+
+	qm_db(qm, 0, DOORBELL_CMD_EQ, qm->eq_head, 0);
+
+	return IRQ_HANDLED;
+}
+
+static void qm_init_qp_status(struct hisi_qp *qp)
+{
+	struct hisi_acc_qp_status *qp_status = &qp->qp_status;
+
+	qp_status->sq_tail = 0;
+	qp_status->sq_head = 0;
+	qp_status->cq_head = 0;
+	qp_status->sqn = 0;
+	qp_status->cqc_phase = 1;
+	qp_status->is_sq_full = 0;
+}
+
+/* check if bit in regs is 1 */
+static inline int qm_reg_wait_bit(struct qm_info *qm, u32 offset, u32 bit)
+{
+	int val;
+
+	return readl_relaxed_poll_timeout(QM_ADDR(qm, offset), val,
+					  val & BIT(bit), 10, 1000);
+}
+
+/* the config should be conducted after hisi_acc_init_qm_mem() */
+static int qm_vft_common_config(struct qm_info *qm, u16 base, u32 number)
+{
+	u64 tmp;
+	int ret;
+
+	ret = qm_reg_wait_bit(qm, QM_VFT_CFG_RDY, 0);
+	if (ret)
+		return ret;
+	qm_writel(qm, 0x0, QM_VFT_CFG_OP_WR);
+	qm_writel(qm, QM_SQC_VFT, QM_VFT_CFG_TYPE);
+	qm_writel(qm, qm->pdev->devfn, QM_VFT_CFG_ADDRESS);
+
+	tmp = QM_SQC_VFT_BUF_SIZE			|
+	      QM_SQC_VFT_SQC_SIZE			|
+	      QM_SQC_VFT_INDEX_NUMBER			|
+	      QM_SQC_VFT_VALID				|
+	      (u64)base << QM_SQC_VFT_START_SQN_SHIFT;
+
+	qm_writel(qm, tmp & 0xffffffff, QM_VFT_CFG_DATA_L);
+	qm_writel(qm, tmp >> 32, QM_VFT_CFG_DATA_H);
+
+	qm_writel(qm, 0x0, QM_VFT_CFG_RDY);
+	qm_writel(qm, 0x1, QM_VFT_CFG_OP_ENABLE);
+	ret = qm_reg_wait_bit(qm, QM_VFT_CFG_RDY, 0);
+	if (ret)
+		return ret;
+	tmp = 0;
+
+	qm_writel(qm, 0x0, QM_VFT_CFG_OP_WR);
+	qm_writel(qm, QM_CQC_VFT, QM_VFT_CFG_TYPE);
+	qm_writel(qm, qm->pdev->devfn, QM_VFT_CFG_ADDRESS);
+
+	tmp = QM_CQC_VFT_BUF_SIZE			|
+	      QM_CQC_VFT_SQC_SIZE			|
+	      QM_CQC_VFT_INDEX_NUMBER			|
+	      QM_CQC_VFT_VALID;
+
+	qm_writel(qm, tmp & 0xffffffff, QM_VFT_CFG_DATA_L);
+	qm_writel(qm, tmp >> 32, QM_VFT_CFG_DATA_H);
+
+	qm_writel(qm, 0x0, QM_VFT_CFG_RDY);
+	qm_writel(qm, 0x1, QM_VFT_CFG_OP_ENABLE);
+	ret = qm_reg_wait_bit(qm, QM_VFT_CFG_RDY, 0);
+	if (ret)
+		return ret;
+	return 0;
+}
+
+/*
+ * v1: For Hi1620ES
+ * v2: For Hi1620CS (Not implemented yet)
+ */
+static struct hisi_acc_qm_hw_ops qm_hw_ops_v1 = {
+	.vft_config = qm_vft_common_config,
+};
+
+struct hisi_qp *hisi_qm_create_qp(struct qm_info *qm, u8 alg_type)
+{
+	struct hisi_qp *qp;
+	int qp_index;
+	int ret;
+
+	write_lock(&qm->qps_lock);
+	qp_index = find_first_zero_bit(qm->qp_bitmap, qm->qp_num);
+	if (qp_index >= qm->qp_num) {
+		write_unlock(&qm->qps_lock);
+		return ERR_PTR(-EBUSY);
+	}
+
+	qp = kzalloc(sizeof(*qp), GFP_KERNEL);
+	if (!qp) {
+		ret = -ENOMEM;
+		write_unlock(&qm->qps_lock);
+		goto err_with_bitset;
+	}
+
+	qp->queue_id = qp_index;
+	qp->qm = qm;
+	qp->alg_type = alg_type;
+	qm_init_qp_status(qp);
+	set_bit(qp_index, qm->qp_bitmap);
+
+	write_unlock(&qm->qps_lock);
+	return qp;
+
+err_with_bitset:
+	write_unlock(&qm->qps_lock);
+	return ERR_PTR(ret);
+}
+EXPORT_SYMBOL_GPL(hisi_qm_create_qp);
+
+int hisi_qm_start_qp(struct hisi_qp *qp, unsigned long arg)
+{
+	struct qm_info *qm = qp->qm;
+	struct device *dev = &qm->pdev->dev;
+	int ret;
+	struct sqc *sqc;
+	struct cqc *cqc;
+	int qp_index = qp->queue_id;
+	int pasid = arg;
+	size_t off = 0;
+
+#define QP_INIT_BUF(qp, type, size) do { \
+	(qp)->type = (struct type *)((void *)(qp)->qdma.va + (off)); \
+	(qp)->type##_dma = (qp)->qdma.dma + (off); \
+	off += size; \
+} while (0)
+
+	sqc = qp->sqc = qm->sqc + qp_index;
+	cqc = qp->cqc = qm->cqc + qp_index;
+	qp->sqc_dma = qm->sqc_dma + qp_index * sizeof(struct sqc);
+	qp->cqc_dma = qm->cqc_dma + qp_index * sizeof(struct cqc);
+
+	qp->qdma.size = qm->sqe_size * QM_Q_DEPTH +
+			sizeof(struct cqe) * QM_Q_DEPTH,
+	qp->qdma.va = dma_alloc_coherent(dev, qp->qdma.size,
+					 &qp->qdma.dma,
+					 GFP_KERNEL | __GFP_ZERO);
+	dev_dbg(dev, "allocate qp dma buf(va=%p, dma=%pad, size=%lx)\n",
+		qp->qdma.va, &qp->qdma.dma, qp->qdma.size);
+
+	if (!qp->qdma.va) {
+		dev_err(dev, "cannot get qm dma buffer\n");
+		return -ENOMEM;
+	}
+
+	QP_INIT_BUF(qp, sqe, qm->sqe_size * QM_Q_DEPTH);
+	QP_INIT_BUF(qp, cqe, sizeof(struct cqe) * QM_Q_DEPTH);
+
+	INIT_QC(sqc, qp->sqe_dma);
+	sqc->pasid = pasid;
+	sqc->dw3 = QM_MK_SQC_DW3(0, 0, 0, ilog2(qm->sqe_size));
+	sqc->cq_num = qp_index;
+	sqc->w13 = QM_MK_SQC_W13(0, 1, qp->alg_type);
+
+	ret = qm_mb(qm, MAILBOX_CMD_SQC, qp->sqc_dma, qp_index, 0, 0);
+	if (ret)
+		return ret;
+
+	INIT_QC(cqc, qp->cqe_dma);
+	cqc->dw3 = QM_MK_CQC_DW3(0, 0, 0, 4);
+	cqc->dw6 = QM_MK_CQC_DW6(1, 1);
+	ret = qm_mb(qm, MAILBOX_CMD_CQC, (u64)qp->cqc_dma, qp_index, 0, 0);
+	if (ret)
+		return ret;
+
+	write_lock(&qm->qps_lock);
+	qm->qp_array[qp_index] = qp;
+	init_completion(&qp->completion);
+	write_unlock(&qm->qps_lock);
+
+	dev_dbg(&qm->pdev->dev, "qp %d started\n", qp_index);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(hisi_qm_start_qp);
+
+void hisi_qm_release_qp(struct hisi_qp *qp)
+{
+	struct qm_info *qm = qp->qm;
+	struct qm_dma *qdma = &qp->qdma;
+	struct device *dev = &qm->pdev->dev;
+	int qid = qp->queue_id;
+
+	write_lock(&qm->qps_lock);
+	qm->qp_array[qp->queue_id] = NULL;
+	bitmap_clear(qm->qp_bitmap, qid, 1);
+	write_unlock(&qm->qps_lock);
+
+	dma_free_coherent(dev, qdma->size, qdma->va, qdma->dma);
+
+	kfree(qp);
+}
+EXPORT_SYMBOL_GPL(hisi_qm_release_qp);
+
+static void *qm_get_avail_sqe(struct hisi_qp *qp)
+{
+	struct hisi_acc_qp_status *qp_status = &qp->qp_status;
+	u16 sq_tail = qp_status->sq_tail;
+
+	if (qp_status->is_sq_full == 1)
+		return NULL;
+
+	return qp->sqe + sq_tail * qp->qm->sqe_size;
+}
+
+int hisi_qp_send(struct hisi_qp *qp, void *msg)
+{
+	struct hisi_acc_qp_status *qp_status = &qp->qp_status;
+	u16 sq_tail = qp_status->sq_tail;
+	u16 sq_tail_next = (sq_tail + 1) % QM_Q_DEPTH;
+	unsigned long timeout = 100;
+	void *sqe = qm_get_avail_sqe(qp);
+
+	if (!sqe)
+		return -EBUSY;
+
+	memcpy(sqe, msg, qp->qm->sqe_size);
+
+	qm_db(qp->qm, qp->queue_id, DOORBELL_CMD_SQ, sq_tail_next, 0);
+
+	/* wait until job finished */
+	wait_for_completion_timeout(&qp->completion, timeout);
+
+	qp_status->sq_tail = sq_tail_next;
+
+	if (qp_status->sq_tail == qp_status->sq_head)
+		qp_status->is_sq_full = 1;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(hisi_qp_send);
+
+static irqreturn_t qm_irq(int irq, void *data)
+{
+	struct qm_info *qm = data;
+	u32 int_source;
+
+	int_source = qm_get_irq_source(qm);
+	if (int_source)
+		return IRQ_WAKE_THREAD;
+
+	dev_err(&qm->pdev->dev, "invalid int source %d\n", int_source);
+
+	return IRQ_HANDLED;
+}
+
+/* put qm into init state, so the acce config become available */
+static int hisi_qm_mem_start(struct qm_info *qm)
+{
+	u32 val;
+
+	qm_writel(qm, 0x1, QM_MEM_START_INIT);
+	return readl_relaxed_poll_timeout(QM_ADDR(qm, QM_MEM_INIT_DONE), val,
+					  val & BIT(0), 10, 1000);
+}
+
+/* todo: The VF case is not considerred carefullly */
+int hisi_qm_init(struct qm_info *qm)
+{
+	int ret;
+	u16 ecam_val16;
+	struct pci_dev *pdev = qm->pdev;
+	struct device *dev = &pdev->dev;
+
+	pci_set_power_state(pdev, PCI_D0);
+	ecam_val16 = PCI_COMMAND_MASTER | PCI_COMMAND_MEMORY;
+	pci_write_config_word(pdev, PCI_COMMAND, ecam_val16);
+
+	ret = pci_enable_device_mem(pdev);
+	if (ret < 0) {
+		dev_err(dev, "Can't enable device mem!\n");
+		return ret;
+	}
+
+	ret = pci_request_mem_regions(pdev, dev_name(dev));
+	if (ret < 0) {
+		dev_err(dev, "Can't request mem regions!\n");
+		goto err_with_pcidev;
+	}
+
+	qm->phys_base = pci_resource_start(pdev, 2);
+	qm->size = pci_resource_len(qm->pdev, 2);
+	qm->io_base = devm_ioremap(dev, qm->phys_base, qm->size);
+	if (!qm->io_base) {
+		dev_err(dev, "Map IO space fail!\n");
+		ret = -EIO;
+		goto err_with_mem_regions;
+	}
+
+	dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64));
+	pci_set_master(pdev);
+
+	ret = pci_alloc_irq_vectors(pdev, 1, 1, PCI_IRQ_MSI);
+	if (ret < 0) {
+		dev_err(dev, "Enable MSI vectors fail!\n");
+		goto err_with_mem_regions;
+	}
+
+	qm->eq_head = 0;
+	mutex_init(&qm->mailbox_lock);
+	rwlock_init(&qm->qps_lock);
+
+	if (qm->ver == 1)
+		qm->ops = &qm_hw_ops_v1;
+	else {
+		dev_err(dev, "qm version not support %d\n", qm->ver);
+		return -EINVAL;
+	}
+
+	ret = devm_request_threaded_irq(dev, pci_irq_vector(pdev, 0),
+					qm_irq, qm_irq_thread, IRQF_SHARED,
+					dev_name(dev), qm);
+	if (ret)
+		goto err_with_irq_vec;
+
+	qm->qp_bitmap = devm_kcalloc(dev, BITS_TO_LONGS(qm->qp_num),
+				     sizeof(long), GFP_KERNEL);
+	qm->qp_array = devm_kcalloc(dev, qm->qp_num,
+				    sizeof(struct hisi_qp *), GFP_KERNEL);
+	if (!qm->qp_bitmap || !qm->qp_array) {
+		ret = -ENOMEM;
+		goto err_with_irq;
+	}
+
+	if (pdev->is_physfn) {
+		ret = hisi_qm_mem_start(qm);
+		if (ret) {
+			dev_err(dev, "mem start fail\n");
+			goto err_with_irq;
+		}
+	}
+
+	qm->qdma.size = max_t(size_t, sizeof(struct eqc),
+			      sizeof(struct aeqc)) +
+			sizeof(struct eqe) * QM_Q_DEPTH +
+			sizeof(struct sqc) * qm->qp_num +
+			sizeof(struct cqc) * qm->qp_num;
+	qm->qdma.va = dma_alloc_coherent(dev, qm->qdma.size,
+					 &qm->qdma.dma,
+					 GFP_KERNEL | __GFP_ZERO);
+	dev_dbg(dev, "allocate qm dma buf(va=%p, dma=%pad, size=%lx)\n",
+		qm->qdma.va, &qm->qdma.dma, qm->qdma.size);
+	ret = qm->qdma.va ? 0 : -ENOMEM;
+
+	if (ret)
+		goto err_with_irq;
+
+	return 0;
+
+err_with_irq:
+	/* even for devm, it should be removed for the irq vec to be freed */
+	devm_free_irq(dev, pci_irq_vector(pdev, 0), qm);
+err_with_irq_vec:
+	pci_free_irq_vectors(pdev);
+err_with_mem_regions:
+	pci_release_mem_regions(pdev);
+err_with_pcidev:
+	pci_disable_device(pdev);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(hisi_qm_init);
+
+void hisi_qm_uninit(struct qm_info *qm)
+{
+	struct pci_dev *pdev = qm->pdev;
+
+	dma_free_coherent(&pdev->dev, qm->qdma.size, qm->qdma.va, qm->qdma.dma);
+
+	devm_free_irq(&pdev->dev, pci_irq_vector(pdev, 0), qm);
+	pci_free_irq_vectors(pdev);
+	pci_release_mem_regions(pdev);
+	pci_disable_device(pdev);
+}
+EXPORT_SYMBOL_GPL(hisi_qm_uninit);
+
+int hisi_qm_start(struct qm_info *qm)
+{
+	size_t off = 0;
+	int ret;
+
+#define QM_INIT_BUF(qm, type, size) do { \
+	(qm)->type = (struct type *)((void *)(qm)->qdma.va + (off)); \
+	(qm)->type##_dma = (qm)->qdma.dma + (off); \
+	off += size; \
+} while (0)
+
+	if (!qm->qdma.va)
+		return -EINVAL;
+
+	if (qm->pdev->is_physfn)
+		qm->ops->vft_config(qm, qm->qp_base, qm->qp_num);
+
+	/*
+	 * notes: the order is important because the buffer should be stay in
+	 * alignment boundary
+	 */
+	QM_INIT_BUF(qm, eqe, sizeof(struct eqe) * QM_Q_DEPTH);
+	QM_INIT_BUF(qm, sqc, sizeof(struct sqc) * qm->qp_num);
+	QM_INIT_BUF(qm, cqc, sizeof(struct cqc) * qm->qp_num);
+	QM_INIT_BUF(qm, eqc,
+		    max_t(size_t, sizeof(struct eqc), sizeof(struct aeqc)));
+
+	qm->eqc->base_l = lower_32_bits(qm->eqe_dma);
+	qm->eqc->base_h = upper_32_bits(qm->eqe_dma);
+	qm->eqc->dw3 = 2 << MB_EQC_EQE_SHIFT;
+	qm->eqc->dw6 = (QM_Q_DEPTH - 1) | (1 << MB_EQC_PHASE_SHIFT);
+	ret = qm_mb(qm, MAILBOX_CMD_EQC, qm->eqc_dma, 0, 0, 0);
+	if (ret)
+		return ret;
+
+	ret = qm_mb(qm, MAILBOX_CMD_SQC_BT, qm->sqc_dma, 0, 0, 0);
+	if (ret)
+		return ret;
+
+	ret = qm_mb(qm, MAILBOX_CMD_CQC_BT, qm->cqc_dma, 0, 0, 0);
+	if (ret)
+		return ret;
+
+	writel(0x0, QM_ADDR(qm, QM_VF_EQ_INT_MASK));
+
+	dev_dbg(&qm->pdev->dev, "qm started\n");
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(hisi_qm_start);
+
+
+void hisi_qm_stop(struct qm_info *qm)
+{
+	/* todo: recheck if this is the right way to disable the hw irq */
+	writel(0x1, QM_ADDR(qm, QM_VF_EQ_INT_MASK));
+
+}
+EXPORT_SYMBOL_GPL(hisi_qm_stop);
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Zhou Wang <wangzhou1@hisilicon.com>");
+MODULE_DESCRIPTION("HiSilicon Accelerator queue manager driver");
diff --git a/drivers/crypto/hisilicon/qm.h b/drivers/crypto/hisilicon/qm.h
new file mode 100644
index 000000000000..6d124d948738
--- /dev/null
+++ b/drivers/crypto/hisilicon/qm.h
@@ -0,0 +1,213 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+#ifndef HISI_ACC_QM_H
+#define HISI_ACC_QM_H
+
+#include <linux/dmapool.h>
+#include <linux/iopoll.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/slab.h>
+#include "qm_usr_if.h"
+
+/* qm user domain */
+#define QM_ARUSER_M_CFG_1		0x100088
+#define QM_ARUSER_M_CFG_ENABLE		0x100090
+#define QM_AWUSER_M_CFG_1		0x100098
+#define QM_AWUSER_M_CFG_ENABLE		0x1000a0
+#define QM_WUSER_M_CFG_ENABLE		0x1000a8
+
+/* qm cache */
+#define QM_CACHE_CTL			0x100050
+#define QM_AXI_M_CFG			0x1000ac
+#define QM_AXI_M_CFG_ENABLE		0x1000b0
+#define QM_PEH_AXUSER_CFG		0x1000cc
+#define QM_PEH_AXUSER_CFG_ENABLE	0x1000d0
+
+struct eqe {
+	__le32 dw0;
+};
+
+struct aeqe {
+	__le32 dw0;
+};
+
+struct sqc {
+	__le16 head;
+	__le16 tail;
+	__le32 base_l;
+	__le32 base_h;
+	__le32 dw3;
+	__le16 qes;
+	__le16 rsvd0;
+	__le16 pasid;
+	__le16 w11;
+	__le16 cq_num;
+	__le16 w13;
+	__le32 rsvd1;
+};
+
+struct cqc {
+	__le16 head;
+	__le16 tail;
+	__le32 base_l;
+	__le32 base_h;
+	__le32 dw3;
+	__le16 qes;
+	__le16 rsvd0;
+	__le16 pasid;
+	__le16 w11;
+	__le32 dw6;
+	__le32 rsvd1;
+};
+
+#define INIT_QC(qc, base) do { \
+	(qc)->head = 0; \
+	(qc)->tail = 0; \
+	(qc)->base_l = lower_32_bits((unsigned long)base); \
+	(qc)->base_h = upper_32_bits((unsigned long)base); \
+	(qc)->pasid = 0; \
+	(qc)->w11 = 0; \
+	(qc)->rsvd1 = 0; \
+	(qc)->qes = QM_Q_DEPTH - 1; \
+} while (0)
+
+struct eqc {
+	__le16 head;
+	__le16 tail;
+	__le32 base_l;
+	__le32 base_h;
+	__le32 dw3;
+	__le32 rsvd[2];
+	__le32 dw6;
+};
+
+struct aeqc {
+	__le16 head;
+	__le16 tail;
+	__le32 base_l;
+	__le32 base_h;
+	__le32 rsvd[3];
+	__le32 dw6;
+};
+
+struct mailbox {
+	__le16 w0;
+	__le16 queue_num;
+	__le32 base_l;
+	__le32 base_h;
+	__le32 rsvd;
+};
+
+struct doorbell {
+	__le16 queue_num;
+	__le16 cmd;
+	__le16 index;
+	__le16 priority;
+};
+
+struct qm_dma {
+	void *va;
+	dma_addr_t dma;
+	size_t size;
+};
+
+struct qm_info {
+	int ver;
+	struct pci_dev *pdev;
+
+	resource_size_t phys_base;
+	resource_size_t size;
+	void __iomem *io_base;
+
+	u32 sqe_size;
+	u32 qp_base;
+	u32 qp_num;
+
+	struct qm_dma qdma;
+	struct sqc *sqc;
+	struct cqc *cqc;
+	struct eqc *eqc;
+	struct eqe *eqe;
+	struct aeqc *aeqc;
+	struct aeqe *aeqe;
+	unsigned long sqc_dma,
+		      cqc_dma,
+		      eqc_dma,
+		      eqe_dma,
+		      aeqc_dma,
+		      aeqe_dma;
+
+	u32 eq_head;
+
+	rwlock_t qps_lock;
+	unsigned long *qp_bitmap;
+	struct hisi_qp **qp_array;
+
+	struct mutex mailbox_lock;
+
+	struct hisi_acc_qm_hw_ops *ops;
+};
+#define QM_ADDR(qm, off) ((qm)->io_base + off)
+
+struct hisi_acc_qp_status {
+	u16 sq_tail;
+	u16 sq_head;
+	u16 cq_head;
+	u16 sqn;
+	bool cqc_phase;
+	int is_sq_full;
+};
+
+struct hisi_qp;
+
+struct hisi_qp_ops {
+	int (*fill_sqe)(void *sqe, void *q_parm, void *d_parm);
+};
+
+struct hisi_qp {
+	/* sq number in this function */
+	u32 queue_id;
+	u8 alg_type;
+	u8 req_type;
+	int pasid;
+
+	struct qm_dma qdma;
+	struct sqc *sqc;
+	struct cqc *cqc;
+	void *sqe;
+	struct cqe *cqe;
+
+	unsigned long sqc_dma,
+		      cqc_dma,
+		      sqe_dma,
+		      cqe_dma;
+
+	struct hisi_acc_qp_status qp_status;
+
+	struct qm_info *qm;
+
+	/* for crypto sync API */
+	struct completion completion;
+
+	struct hisi_qp_ops *hw_ops;
+	void *qp_ctx;
+	void (*event_cb)(struct hisi_qp *qp);
+	void (*req_cb)(struct hisi_qp *qp, unsigned long data);
+};
+
+/* QM external interface for accelerator driver.
+ * To use qm:
+ * 1. Set qm with pdev, and sqe_size set accordingly
+ * 2. hisi_qm_init()
+ * 3. config the accelerator hardware
+ * 4. hisi_qm_start()
+ */
+extern int hisi_qm_init(struct qm_info *qm);
+extern void hisi_qm_uninit(struct qm_info *qm);
+extern int hisi_qm_start(struct qm_info *qm);
+extern void hisi_qm_stop(struct qm_info *qm);
+extern struct hisi_qp *hisi_qm_create_qp(struct qm_info *qm, u8 alg_type);
+extern int hisi_qm_start_qp(struct hisi_qp *qp, unsigned long arg);
+extern void hisi_qm_release_qp(struct hisi_qp *qp);
+extern int hisi_qp_send(struct hisi_qp *qp, void *msg);
+#endif
diff --git a/drivers/crypto/hisilicon/qm_usr_if.h b/drivers/crypto/hisilicon/qm_usr_if.h
new file mode 100644
index 000000000000..13aab94adb05
--- /dev/null
+++ b/drivers/crypto/hisilicon/qm_usr_if.h
@@ -0,0 +1,32 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+#ifndef HISI_QM_USR_IF_H
+#define HISI_QM_USR_IF_H
+
+#define QM_CQE_SIZE			16
+
+/* default queue depth for sq/cq/eq */
+#define QM_Q_DEPTH			1024
+
+/* page number for queue file region */
+#define QM_DOORBELL_PAGE_NR	1
+#define QM_DKO_PAGE_NR		3
+#define QM_DUS_PAGE_NR		36
+
+#define QM_DOORBELL_PG_START 0
+#define QM_DKO_PAGE_START (QM_DOORBELL_PG_START + QM_DOORBELL_PAGE_NR)
+#define QM_DUS_PAGE_START (QM_DKO_PAGE_START + QM_DKO_PAGE_NR)
+#define QM_SS_PAGE_START (QM_DUS_PAGE_START + QM_DUS_PAGE_NR)
+
+#define QM_DOORBELL_OFFSET      0x340
+
+struct cqe {
+	__le32 rsvd0;
+	__le16 cmd_id;
+	__le16 rsvd1;
+	__le16 sq_head;
+	__le16 sq_num;
+	__le16 rsvd2;
+	__le16 w7;
+};
+
+#endif
-- 
2.17.1
