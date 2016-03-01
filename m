From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH 4/4] crypto: ccp - Add abstraction for device-specific calls
Date: Tue, 1 Mar 2016 13:49:25 -0600
Message-ID: <20160301194925.6788.93319.stgit@taos.amd.com>
References: <20160301194831.6788.2154.stgit@taos.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <thomas.lendacky@amd.com>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2on0083.outbound.protection.outlook.com ([65.55.169.83]:53408
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750813AbcCAUFB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 1 Mar 2016 15:05:01 -0500
In-Reply-To: <20160301194831.6788.2154.stgit@taos.amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Support for different generations of the coprocessor
requires that an abstraction layer be implemented for
interacting with the hardware. This patch splits out
version-specific functions to a separate file and populates
the version structure (acting as a driver) with function
pointers.

Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/Makefile       |    2 
 drivers/crypto/ccp/ccp-dev-v3.c   |  534 +++++++++++++++++++++++++++++++++++++
 drivers/crypto/ccp/ccp-dev.c      |  306 +--------------------
 drivers/crypto/ccp/ccp-dev.h      |  138 +++++++++-
 drivers/crypto/ccp/ccp-ops.c      |  381 +-------------------------
 drivers/crypto/ccp/ccp-pci.c      |   10 -
 drivers/crypto/ccp/ccp-platform.c |    7 
 7 files changed, 711 insertions(+), 667 deletions(-)
 create mode 100644 drivers/crypto/ccp/ccp-dev-v3.c

diff --git a/drivers/crypto/ccp/Makefile b/drivers/crypto/ccp/Makefile
index 55a1f39..b750592 100644
--- a/drivers/crypto/ccp/Makefile
+++ b/drivers/crypto/ccp/Makefile
@@ -1,5 +1,5 @@
 obj-$(CONFIG_CRYPTO_DEV_CCP_DD) += ccp.o
-ccp-objs := ccp-dev.o ccp-ops.o ccp-platform.o
+ccp-objs := ccp-dev.o ccp-ops.o ccp-dev-v3.o ccp-platform.o
 ccp-$(CONFIG_PCI) += ccp-pci.o
 
 obj-$(CONFIG_CRYPTO_DEV_CCP_CRYPTO) += ccp-crypto.o
diff --git a/drivers/crypto/ccp/ccp-dev-v3.c b/drivers/crypto/ccp/ccp-dev-v3.c
new file mode 100644
index 0000000..4f81c9f
--- /dev/null
+++ b/drivers/crypto/ccp/ccp-dev-v3.c
@@ -0,0 +1,534 @@
+/*
+ * AMD Cryptographic Coprocessor (CCP) driver
+ *
+ * Copyright (C) 2013,2016 Advanced Micro Devices, Inc.
+ *
+ * Author: Tom Lendacky <thomas.lendacky@amd.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/pci.h>
+#include <linux/kthread.h>
+#include <linux/interrupt.h>
+#include <linux/ccp.h>
+
+#include "ccp-dev.h"
+
+static int ccp_do_cmd(struct ccp_op *op, u32 *cr, unsigned int cr_count)
+{
+	struct ccp_cmd_queue *cmd_q = op->cmd_q;
+	struct ccp_device *ccp = cmd_q->ccp;
+	void __iomem *cr_addr;
+	u32 cr0, cmd;
+	unsigned int i;
+	int ret = 0;
+
+	/* We could read a status register to see how many free slots
+	 * are actually available, but reading that register resets it
+	 * and you could lose some error information.
+	 */
+	cmd_q->free_slots--;
+
+	cr0 = (cmd_q->id << REQ0_CMD_Q_SHIFT)
+	      | (op->jobid << REQ0_JOBID_SHIFT)
+	      | REQ0_WAIT_FOR_WRITE;
+
+	if (op->soc)
+		cr0 |= REQ0_STOP_ON_COMPLETE
+		       | REQ0_INT_ON_COMPLETE;
+
+	if (op->ioc || !cmd_q->free_slots)
+		cr0 |= REQ0_INT_ON_COMPLETE;
+
+	/* Start at CMD_REQ1 */
+	cr_addr = ccp->io_regs + CMD_REQ0 + CMD_REQ_INCR;
+
+	mutex_lock(&ccp->req_mutex);
+
+	/* Write CMD_REQ1 through CMD_REQx first */
+	for (i = 0; i < cr_count; i++, cr_addr += CMD_REQ_INCR)
+		iowrite32(*(cr + i), cr_addr);
+
+	/* Tell the CCP to start */
+	wmb();
+	iowrite32(cr0, ccp->io_regs + CMD_REQ0);
+
+	mutex_unlock(&ccp->req_mutex);
+
+	if (cr0 & REQ0_INT_ON_COMPLETE) {
+		/* Wait for the job to complete */
+		ret = wait_event_interruptible(cmd_q->int_queue,
+					       cmd_q->int_rcvd);
+		if (ret || cmd_q->cmd_error) {
+			/* On error delete all related jobs from the queue */
+			cmd = (cmd_q->id << DEL_Q_ID_SHIFT)
+			      | op->jobid;
+
+			iowrite32(cmd, ccp->io_regs + DEL_CMD_Q_JOB);
+
+			if (!ret)
+				ret = -EIO;
+		} else if (op->soc) {
+			/* Delete just head job from the queue on SoC */
+			cmd = DEL_Q_ACTIVE
+			      | (cmd_q->id << DEL_Q_ID_SHIFT)
+			      | op->jobid;
+
+			iowrite32(cmd, ccp->io_regs + DEL_CMD_Q_JOB);
+		}
+
+		cmd_q->free_slots = CMD_Q_DEPTH(cmd_q->q_status);
+
+		cmd_q->int_rcvd = 0;
+	}
+
+	return ret;
+}
+
+static int ccp_perform_aes(struct ccp_op *op)
+{
+	u32 cr[6];
+
+	/* Fill out the register contents for REQ1 through REQ6 */
+	cr[0] = (CCP_ENGINE_AES << REQ1_ENGINE_SHIFT)
+		| (op->u.aes.type << REQ1_AES_TYPE_SHIFT)
+		| (op->u.aes.mode << REQ1_AES_MODE_SHIFT)
+		| (op->u.aes.action << REQ1_AES_ACTION_SHIFT)
+		| (op->ksb_key << REQ1_KEY_KSB_SHIFT);
+	cr[1] = op->src.u.dma.length - 1;
+	cr[2] = ccp_addr_lo(&op->src.u.dma);
+	cr[3] = (op->ksb_ctx << REQ4_KSB_SHIFT)
+		| (CCP_MEMTYPE_SYSTEM << REQ4_MEMTYPE_SHIFT)
+		| ccp_addr_hi(&op->src.u.dma);
+	cr[4] = ccp_addr_lo(&op->dst.u.dma);
+	cr[5] = (CCP_MEMTYPE_SYSTEM << REQ6_MEMTYPE_SHIFT)
+		| ccp_addr_hi(&op->dst.u.dma);
+
+	if (op->u.aes.mode == CCP_AES_MODE_CFB)
+		cr[0] |= ((0x7f) << REQ1_AES_CFB_SIZE_SHIFT);
+
+	if (op->eom)
+		cr[0] |= REQ1_EOM;
+
+	if (op->init)
+		cr[0] |= REQ1_INIT;
+
+	return ccp_do_cmd(op, cr, ARRAY_SIZE(cr));
+}
+
+static int ccp_perform_xts_aes(struct ccp_op *op)
+{
+	u32 cr[6];
+
+	/* Fill out the register contents for REQ1 through REQ6 */
+	cr[0] = (CCP_ENGINE_XTS_AES_128 << REQ1_ENGINE_SHIFT)
+		| (op->u.xts.action << REQ1_AES_ACTION_SHIFT)
+		| (op->u.xts.unit_size << REQ1_XTS_AES_SIZE_SHIFT)
+		| (op->ksb_key << REQ1_KEY_KSB_SHIFT);
+	cr[1] = op->src.u.dma.length - 1;
+	cr[2] = ccp_addr_lo(&op->src.u.dma);
+	cr[3] = (op->ksb_ctx << REQ4_KSB_SHIFT)
+		| (CCP_MEMTYPE_SYSTEM << REQ4_MEMTYPE_SHIFT)
+		| ccp_addr_hi(&op->src.u.dma);
+	cr[4] = ccp_addr_lo(&op->dst.u.dma);
+	cr[5] = (CCP_MEMTYPE_SYSTEM << REQ6_MEMTYPE_SHIFT)
+		| ccp_addr_hi(&op->dst.u.dma);
+
+	if (op->eom)
+		cr[0] |= REQ1_EOM;
+
+	if (op->init)
+		cr[0] |= REQ1_INIT;
+
+	return ccp_do_cmd(op, cr, ARRAY_SIZE(cr));
+}
+
+static int ccp_perform_sha(struct ccp_op *op)
+{
+	u32 cr[6];
+
+	/* Fill out the register contents for REQ1 through REQ6 */
+	cr[0] = (CCP_ENGINE_SHA << REQ1_ENGINE_SHIFT)
+		| (op->u.sha.type << REQ1_SHA_TYPE_SHIFT)
+		| REQ1_INIT;
+	cr[1] = op->src.u.dma.length - 1;
+	cr[2] = ccp_addr_lo(&op->src.u.dma);
+	cr[3] = (op->ksb_ctx << REQ4_KSB_SHIFT)
+		| (CCP_MEMTYPE_SYSTEM << REQ4_MEMTYPE_SHIFT)
+		| ccp_addr_hi(&op->src.u.dma);
+
+	if (op->eom) {
+		cr[0] |= REQ1_EOM;
+		cr[4] = lower_32_bits(op->u.sha.msg_bits);
+		cr[5] = upper_32_bits(op->u.sha.msg_bits);
+	} else {
+		cr[4] = 0;
+		cr[5] = 0;
+	}
+
+	return ccp_do_cmd(op, cr, ARRAY_SIZE(cr));
+}
+
+static int ccp_perform_rsa(struct ccp_op *op)
+{
+	u32 cr[6];
+
+	/* Fill out the register contents for REQ1 through REQ6 */
+	cr[0] = (CCP_ENGINE_RSA << REQ1_ENGINE_SHIFT)
+		| (op->u.rsa.mod_size << REQ1_RSA_MOD_SIZE_SHIFT)
+		| (op->ksb_key << REQ1_KEY_KSB_SHIFT)
+		| REQ1_EOM;
+	cr[1] = op->u.rsa.input_len - 1;
+	cr[2] = ccp_addr_lo(&op->src.u.dma);
+	cr[3] = (op->ksb_ctx << REQ4_KSB_SHIFT)
+		| (CCP_MEMTYPE_SYSTEM << REQ4_MEMTYPE_SHIFT)
+		| ccp_addr_hi(&op->src.u.dma);
+	cr[4] = ccp_addr_lo(&op->dst.u.dma);
+	cr[5] = (CCP_MEMTYPE_SYSTEM << REQ6_MEMTYPE_SHIFT)
+		| ccp_addr_hi(&op->dst.u.dma);
+
+	return ccp_do_cmd(op, cr, ARRAY_SIZE(cr));
+}
+
+static int ccp_perform_passthru(struct ccp_op *op)
+{
+	u32 cr[6];
+
+	/* Fill out the register contents for REQ1 through REQ6 */
+	cr[0] = (CCP_ENGINE_PASSTHRU << REQ1_ENGINE_SHIFT)
+		| (op->u.passthru.bit_mod << REQ1_PT_BW_SHIFT)
+		| (op->u.passthru.byte_swap << REQ1_PT_BS_SHIFT);
+
+	if (op->src.type == CCP_MEMTYPE_SYSTEM)
+		cr[1] = op->src.u.dma.length - 1;
+	else
+		cr[1] = op->dst.u.dma.length - 1;
+
+	if (op->src.type == CCP_MEMTYPE_SYSTEM) {
+		cr[2] = ccp_addr_lo(&op->src.u.dma);
+		cr[3] = (CCP_MEMTYPE_SYSTEM << REQ4_MEMTYPE_SHIFT)
+			| ccp_addr_hi(&op->src.u.dma);
+
+		if (op->u.passthru.bit_mod != CCP_PASSTHRU_BITWISE_NOOP)
+			cr[3] |= (op->ksb_key << REQ4_KSB_SHIFT);
+	} else {
+		cr[2] = op->src.u.ksb * CCP_KSB_BYTES;
+		cr[3] = (CCP_MEMTYPE_KSB << REQ4_MEMTYPE_SHIFT);
+	}
+
+	if (op->dst.type == CCP_MEMTYPE_SYSTEM) {
+		cr[4] = ccp_addr_lo(&op->dst.u.dma);
+		cr[5] = (CCP_MEMTYPE_SYSTEM << REQ6_MEMTYPE_SHIFT)
+			| ccp_addr_hi(&op->dst.u.dma);
+	} else {
+		cr[4] = op->dst.u.ksb * CCP_KSB_BYTES;
+		cr[5] = (CCP_MEMTYPE_KSB << REQ6_MEMTYPE_SHIFT);
+	}
+
+	if (op->eom)
+		cr[0] |= REQ1_EOM;
+
+	return ccp_do_cmd(op, cr, ARRAY_SIZE(cr));
+}
+
+static int ccp_perform_ecc(struct ccp_op *op)
+{
+	u32 cr[6];
+
+	/* Fill out the register contents for REQ1 through REQ6 */
+	cr[0] = REQ1_ECC_AFFINE_CONVERT
+		| (CCP_ENGINE_ECC << REQ1_ENGINE_SHIFT)
+		| (op->u.ecc.function << REQ1_ECC_FUNCTION_SHIFT)
+		| REQ1_EOM;
+	cr[1] = op->src.u.dma.length - 1;
+	cr[2] = ccp_addr_lo(&op->src.u.dma);
+	cr[3] = (CCP_MEMTYPE_SYSTEM << REQ4_MEMTYPE_SHIFT)
+		| ccp_addr_hi(&op->src.u.dma);
+	cr[4] = ccp_addr_lo(&op->dst.u.dma);
+	cr[5] = (CCP_MEMTYPE_SYSTEM << REQ6_MEMTYPE_SHIFT)
+		| ccp_addr_hi(&op->dst.u.dma);
+
+	return ccp_do_cmd(op, cr, ARRAY_SIZE(cr));
+}
+
+static int ccp_trng_read(struct hwrng *rng, void *data, size_t max, bool wait)
+{
+	struct ccp_device *ccp = container_of(rng, struct ccp_device, hwrng);
+	u32 trng_value;
+	int len = min_t(int, sizeof(trng_value), max);
+
+	/*
+	 * Locking is provided by the caller so we can update device
+	 * hwrng-related fields safely
+	 */
+	trng_value = ioread32(ccp->io_regs + TRNG_OUT_REG);
+	if (!trng_value) {
+		/* Zero is returned if not data is available or if a
+		 * bad-entropy error is present. Assume an error if
+		 * we exceed TRNG_RETRIES reads of zero.
+		 */
+		if (ccp->hwrng_retries++ > TRNG_RETRIES)
+			return -EIO;
+
+		return 0;
+	}
+
+	/* Reset the counter and save the rng value */
+	ccp->hwrng_retries = 0;
+	memcpy(data, &trng_value, len);
+
+	return len;
+}
+
+static int ccp_init(struct ccp_device *ccp)
+{
+	struct device *dev = ccp->dev;
+	struct ccp_cmd_queue *cmd_q;
+	struct dma_pool *dma_pool;
+	char dma_pool_name[MAX_DMAPOOL_NAME_LEN];
+	unsigned int qmr, qim, i;
+	int ret;
+
+	/* Find available queues */
+	qim = 0;
+	qmr = ioread32(ccp->io_regs + Q_MASK_REG);
+	for (i = 0; i < MAX_HW_QUEUES; i++) {
+		if (!(qmr & (1 << i)))
+			continue;
+
+		/* Allocate a dma pool for this queue */
+		snprintf(dma_pool_name, sizeof(dma_pool_name), "%s_q%d",
+			 ccp->name, i);
+		dma_pool = dma_pool_create(dma_pool_name, dev,
+					   CCP_DMAPOOL_MAX_SIZE,
+					   CCP_DMAPOOL_ALIGN, 0);
+		if (!dma_pool) {
+			dev_err(dev, "unable to allocate dma pool\n");
+			ret = -ENOMEM;
+			goto e_pool;
+		}
+
+		cmd_q = &ccp->cmd_q[ccp->cmd_q_count];
+		ccp->cmd_q_count++;
+
+		cmd_q->ccp = ccp;
+		cmd_q->id = i;
+		cmd_q->dma_pool = dma_pool;
+
+		/* Reserve 2 KSB regions for the queue */
+		cmd_q->ksb_key = KSB_START + ccp->ksb_start++;
+		cmd_q->ksb_ctx = KSB_START + ccp->ksb_start++;
+		ccp->ksb_count -= 2;
+
+		/* Preset some register values and masks that are queue
+		 * number dependent
+		 */
+		cmd_q->reg_status = ccp->io_regs + CMD_Q_STATUS_BASE +
+				    (CMD_Q_STATUS_INCR * i);
+		cmd_q->reg_int_status = ccp->io_regs + CMD_Q_INT_STATUS_BASE +
+					(CMD_Q_STATUS_INCR * i);
+		cmd_q->int_ok = 1 << (i * 2);
+		cmd_q->int_err = 1 << ((i * 2) + 1);
+
+		cmd_q->free_slots = CMD_Q_DEPTH(ioread32(cmd_q->reg_status));
+
+		init_waitqueue_head(&cmd_q->int_queue);
+
+		/* Build queue interrupt mask (two interrupts per queue) */
+		qim |= cmd_q->int_ok | cmd_q->int_err;
+
+#ifdef CONFIG_ARM64
+		/* For arm64 set the recommended queue cache settings */
+		iowrite32(ccp->axcache, ccp->io_regs + CMD_Q_CACHE_BASE +
+			  (CMD_Q_CACHE_INC * i));
+#endif
+
+		dev_dbg(dev, "queue #%u available\n", i);
+	}
+	if (ccp->cmd_q_count == 0) {
+		dev_notice(dev, "no command queues available\n");
+		ret = -EIO;
+		goto e_pool;
+	}
+	dev_notice(dev, "%u command queues available\n", ccp->cmd_q_count);
+
+	/* Disable and clear interrupts until ready */
+	iowrite32(0x00, ccp->io_regs + IRQ_MASK_REG);
+	for (i = 0; i < ccp->cmd_q_count; i++) {
+		cmd_q = &ccp->cmd_q[i];
+
+		ioread32(cmd_q->reg_int_status);
+		ioread32(cmd_q->reg_status);
+	}
+	iowrite32(qim, ccp->io_regs + IRQ_STATUS_REG);
+
+	/* Request an irq */
+	ret = ccp->get_irq(ccp);
+	if (ret) {
+		dev_err(dev, "unable to allocate an IRQ\n");
+		goto e_pool;
+	}
+
+	/* Initialize the queues used to wait for KSB space and suspend */
+	init_waitqueue_head(&ccp->ksb_queue);
+	init_waitqueue_head(&ccp->suspend_queue);
+
+	/* Create a kthread for each queue */
+	for (i = 0; i < ccp->cmd_q_count; i++) {
+		struct task_struct *kthread;
+
+		cmd_q = &ccp->cmd_q[i];
+
+		kthread = kthread_create(ccp_cmd_queue_thread, cmd_q,
+					 "%s-q%u", ccp->name, cmd_q->id);
+		if (IS_ERR(kthread)) {
+			dev_err(dev, "error creating queue thread (%ld)\n",
+				PTR_ERR(kthread));
+			ret = PTR_ERR(kthread);
+			goto e_kthread;
+		}
+
+		cmd_q->kthread = kthread;
+		wake_up_process(kthread);
+	}
+
+	/* Register the RNG */
+	ccp->hwrng.name = ccp->rngname;
+	ccp->hwrng.read = ccp_trng_read;
+	ret = hwrng_register(&ccp->hwrng);
+	if (ret) {
+		dev_err(dev, "error registering hwrng (%d)\n", ret);
+		goto e_kthread;
+	}
+
+	ccp_add_device(ccp);
+
+	/* Enable interrupts */
+	iowrite32(qim, ccp->io_regs + IRQ_MASK_REG);
+
+	return 0;
+
+e_kthread:
+	for (i = 0; i < ccp->cmd_q_count; i++)
+		if (ccp->cmd_q[i].kthread)
+			kthread_stop(ccp->cmd_q[i].kthread);
+
+	ccp->free_irq(ccp);
+
+e_pool:
+	for (i = 0; i < ccp->cmd_q_count; i++)
+		dma_pool_destroy(ccp->cmd_q[i].dma_pool);
+
+	return ret;
+}
+
+static void ccp_destroy(struct ccp_device *ccp)
+{
+	struct ccp_cmd_queue *cmd_q;
+	struct ccp_cmd *cmd;
+	unsigned int qim, i;
+
+	/* Remove this device from the list of available units first */
+	ccp_del_device(ccp);
+
+	/* Unregister the RNG */
+	hwrng_unregister(&ccp->hwrng);
+
+	/* Stop the queue kthreads */
+	for (i = 0; i < ccp->cmd_q_count; i++)
+		if (ccp->cmd_q[i].kthread)
+			kthread_stop(ccp->cmd_q[i].kthread);
+
+	/* Build queue interrupt mask (two interrupt masks per queue) */
+	qim = 0;
+	for (i = 0; i < ccp->cmd_q_count; i++) {
+		cmd_q = &ccp->cmd_q[i];
+		qim |= cmd_q->int_ok | cmd_q->int_err;
+	}
+
+	/* Disable and clear interrupts */
+	iowrite32(0x00, ccp->io_regs + IRQ_MASK_REG);
+	for (i = 0; i < ccp->cmd_q_count; i++) {
+		cmd_q = &ccp->cmd_q[i];
+
+		ioread32(cmd_q->reg_int_status);
+		ioread32(cmd_q->reg_status);
+	}
+	iowrite32(qim, ccp->io_regs + IRQ_STATUS_REG);
+
+	ccp->free_irq(ccp);
+
+	for (i = 0; i < ccp->cmd_q_count; i++)
+		dma_pool_destroy(ccp->cmd_q[i].dma_pool);
+
+	/* Flush the cmd and backlog queue */
+	while (!list_empty(&ccp->cmd)) {
+		/* Invoke the callback directly with an error code */
+		cmd = list_first_entry(&ccp->cmd, struct ccp_cmd, entry);
+		list_del(&cmd->entry);
+		cmd->callback(cmd->data, -ENODEV);
+	}
+	while (!list_empty(&ccp->backlog)) {
+		/* Invoke the callback directly with an error code */
+		cmd = list_first_entry(&ccp->backlog, struct ccp_cmd, entry);
+		list_del(&cmd->entry);
+		cmd->callback(cmd->data, -ENODEV);
+	}
+}
+
+static irqreturn_t ccp_irq_handler(int irq, void *data)
+{
+	struct device *dev = data;
+	struct ccp_device *ccp = dev_get_drvdata(dev);
+	struct ccp_cmd_queue *cmd_q;
+	u32 q_int, status;
+	unsigned int i;
+
+	status = ioread32(ccp->io_regs + IRQ_STATUS_REG);
+
+	for (i = 0; i < ccp->cmd_q_count; i++) {
+		cmd_q = &ccp->cmd_q[i];
+
+		q_int = status & (cmd_q->int_ok | cmd_q->int_err);
+		if (q_int) {
+			cmd_q->int_status = status;
+			cmd_q->q_status = ioread32(cmd_q->reg_status);
+			cmd_q->q_int_status = ioread32(cmd_q->reg_int_status);
+
+			/* On error, only save the first error value */
+			if ((q_int & cmd_q->int_err) && !cmd_q->cmd_error)
+				cmd_q->cmd_error = CMD_Q_ERROR(cmd_q->q_status);
+
+			cmd_q->int_rcvd = 1;
+
+			/* Acknowledge the interrupt and wake the kthread */
+			iowrite32(q_int, ccp->io_regs + IRQ_STATUS_REG);
+			wake_up_interruptible(&cmd_q->int_queue);
+		}
+	}
+
+	return IRQ_HANDLED;
+}
+
+static struct ccp_actions ccp3_actions = {
+	.perform_aes = ccp_perform_aes,
+	.perform_xts_aes = ccp_perform_xts_aes,
+	.perform_sha = ccp_perform_sha,
+	.perform_rsa = ccp_perform_rsa,
+	.perform_passthru = ccp_perform_passthru,
+	.perform_ecc = ccp_perform_ecc,
+	.init = ccp_init,
+	.destroy = ccp_destroy,
+	.irqhandler = ccp_irq_handler,
+};
+
+struct ccp_vdata ccpv3 = {
+	.version = CCP_VERSION(3, 0),
+	.perform = &ccp3_actions,
+};
+
diff --git a/drivers/crypto/ccp/ccp-dev.c b/drivers/crypto/ccp/ccp-dev.c
index 5348512..336e5b7 100644
--- a/drivers/crypto/ccp/ccp-dev.c
+++ b/drivers/crypto/ccp/ccp-dev.c
@@ -63,11 +63,17 @@ unsigned int ccp_increment_unit_ordinal(void)
 	return atomic_inc_return(&ccp_unit_ordinal);
 }
 
-/*
+/**
+ * ccp_add_device - add a CCP device to the list
+ *
+ * @ccp: ccp_device struct pointer
+ *
  * Put this CCP on the unit list, which makes it available
  * for use.
+ *
+ * Returns zero if a CCP device is present, -ENODEV otherwise.
  */
-static inline void ccp_add_device(struct ccp_device *ccp)
+void ccp_add_device(struct ccp_device *ccp)
 {
 	unsigned long flags;
 
@@ -81,11 +87,16 @@ static inline void ccp_add_device(struct ccp_device *ccp)
 	write_unlock_irqrestore(&ccp_unit_lock, flags);
 }
 
-/* Remove this unit from the list of devices. If the next device
+/**
+ * ccp_del_device - remove a CCP device from the list
+ *
+ * @ccp: ccp_device struct pointer
+ *
+ * Remove this unit from the list of devices. If the next device
  * up for use is this one, adjust the pointer. If this is the last
  * device, NULL the pointer.
  */
-static inline void ccp_del_device(struct ccp_device *ccp)
+void ccp_del_device(struct ccp_device *ccp)
 {
 	unsigned long flags;
 
@@ -326,7 +337,12 @@ static void ccp_do_cmd_complete(unsigned long data)
 	complete(&tdata->completion);
 }
 
-static int ccp_cmd_queue_thread(void *data)
+/**
+ * ccp_cmd_queue_thread - create a kernel thread to manage a CCP queue
+ *
+ * @data: thread-specific data
+ */
+int ccp_cmd_queue_thread(void *data)
 {
 	struct ccp_cmd_queue *cmd_q = (struct ccp_cmd_queue *)data;
 	struct ccp_cmd *cmd;
@@ -362,35 +378,6 @@ static int ccp_cmd_queue_thread(void *data)
 	return 0;
 }
 
-static int ccp_trng_read(struct hwrng *rng, void *data, size_t max, bool wait)
-{
-	struct ccp_device *ccp = container_of(rng, struct ccp_device, hwrng);
-	u32 trng_value;
-	int len = min_t(int, sizeof(trng_value), max);
-
-	/*
-	 * Locking is provided by the caller so we can update device
-	 * hwrng-related fields safely
-	 */
-	trng_value = ioread32(ccp->io_regs + TRNG_OUT_REG);
-	if (!trng_value) {
-		/* Zero is returned if not data is available or if a
-		 * bad-entropy error is present. Assume an error if
-		 * we exceed TRNG_RETRIES reads of zero.
-		 */
-		if (ccp->hwrng_retries++ > TRNG_RETRIES)
-			return -EIO;
-
-		return 0;
-	}
-
-	/* Reset the counter and save the rng value */
-	ccp->hwrng_retries = 0;
-	memcpy(data, &trng_value, len);
-
-	return len;
-}
-
 /**
  * ccp_alloc_struct - allocate and initialize the ccp_device struct
  *
@@ -421,253 +408,6 @@ struct ccp_device *ccp_alloc_struct(struct device *dev)
 	return ccp;
 }
 
-/**
- * ccp_init - initialize the CCP device
- *
- * @ccp: ccp_device struct
- */
-int ccp_init(struct ccp_device *ccp)
-{
-	struct device *dev = ccp->dev;
-	struct ccp_cmd_queue *cmd_q;
-	struct dma_pool *dma_pool;
-	char dma_pool_name[MAX_DMAPOOL_NAME_LEN];
-	unsigned int qmr, qim, i;
-	int ret;
-
-	/* Find available queues */
-	qim = 0;
-	qmr = ioread32(ccp->io_regs + Q_MASK_REG);
-	for (i = 0; i < MAX_HW_QUEUES; i++) {
-		if (!(qmr & (1 << i)))
-			continue;
-
-		/* Allocate a dma pool for this queue */
-		snprintf(dma_pool_name, sizeof(dma_pool_name), "%s_q%d",
-			 ccp->name, i);
-		dma_pool = dma_pool_create(dma_pool_name, dev,
-					   CCP_DMAPOOL_MAX_SIZE,
-					   CCP_DMAPOOL_ALIGN, 0);
-		if (!dma_pool) {
-			dev_err(dev, "unable to allocate dma pool\n");
-			ret = -ENOMEM;
-			goto e_pool;
-		}
-
-		cmd_q = &ccp->cmd_q[ccp->cmd_q_count];
-		ccp->cmd_q_count++;
-
-		cmd_q->ccp = ccp;
-		cmd_q->id = i;
-		cmd_q->dma_pool = dma_pool;
-
-		/* Reserve 2 KSB regions for the queue */
-		cmd_q->ksb_key = KSB_START + ccp->ksb_start++;
-		cmd_q->ksb_ctx = KSB_START + ccp->ksb_start++;
-		ccp->ksb_count -= 2;
-
-		/* Preset some register values and masks that are queue
-		 * number dependent
-		 */
-		cmd_q->reg_status = ccp->io_regs + CMD_Q_STATUS_BASE +
-				    (CMD_Q_STATUS_INCR * i);
-		cmd_q->reg_int_status = ccp->io_regs + CMD_Q_INT_STATUS_BASE +
-					(CMD_Q_STATUS_INCR * i);
-		cmd_q->int_ok = 1 << (i * 2);
-		cmd_q->int_err = 1 << ((i * 2) + 1);
-
-		cmd_q->free_slots = CMD_Q_DEPTH(ioread32(cmd_q->reg_status));
-
-		init_waitqueue_head(&cmd_q->int_queue);
-
-		/* Build queue interrupt mask (two interrupts per queue) */
-		qim |= cmd_q->int_ok | cmd_q->int_err;
-
-#ifdef CONFIG_ARM64
-		/* For arm64 set the recommended queue cache settings */
-		iowrite32(ccp->axcache, ccp->io_regs + CMD_Q_CACHE_BASE +
-			  (CMD_Q_CACHE_INC * i));
-#endif
-
-		dev_dbg(dev, "queue #%u available\n", i);
-	}
-	if (ccp->cmd_q_count == 0) {
-		dev_notice(dev, "no command queues available\n");
-		ret = -EIO;
-		goto e_pool;
-	}
-	dev_notice(dev, "%u command queues available\n", ccp->cmd_q_count);
-
-	/* Disable and clear interrupts until ready */
-	iowrite32(0x00, ccp->io_regs + IRQ_MASK_REG);
-	for (i = 0; i < ccp->cmd_q_count; i++) {
-		cmd_q = &ccp->cmd_q[i];
-
-		ioread32(cmd_q->reg_int_status);
-		ioread32(cmd_q->reg_status);
-	}
-	iowrite32(qim, ccp->io_regs + IRQ_STATUS_REG);
-
-	/* Request an irq */
-	ret = ccp->get_irq(ccp);
-	if (ret) {
-		dev_err(dev, "unable to allocate an IRQ\n");
-		goto e_pool;
-	}
-
-	/* Initialize the queues used to wait for KSB space and suspend */
-	init_waitqueue_head(&ccp->ksb_queue);
-	init_waitqueue_head(&ccp->suspend_queue);
-
-	/* Create a kthread for each queue */
-	for (i = 0; i < ccp->cmd_q_count; i++) {
-		struct task_struct *kthread;
-
-		cmd_q = &ccp->cmd_q[i];
-
-		kthread = kthread_create(ccp_cmd_queue_thread, cmd_q,
-					 "%s-q%u", ccp->name, cmd_q->id);
-		if (IS_ERR(kthread)) {
-			dev_err(dev, "error creating queue thread (%ld)\n",
-				PTR_ERR(kthread));
-			ret = PTR_ERR(kthread);
-			goto e_kthread;
-		}
-
-		cmd_q->kthread = kthread;
-		wake_up_process(kthread);
-	}
-
-	/* Register the RNG */
-	ccp->hwrng.name = ccp->rngname;
-	ccp->hwrng.read = ccp_trng_read;
-	ret = hwrng_register(&ccp->hwrng);
-	if (ret) {
-		dev_err(dev, "error registering hwrng (%d)\n", ret);
-		goto e_kthread;
-	}
-
-	/* Make the device struct available before enabling interrupts */
-	ccp_add_device(ccp);
-
-	/* Enable interrupts */
-	iowrite32(qim, ccp->io_regs + IRQ_MASK_REG);
-
-	return 0;
-
-e_kthread:
-	for (i = 0; i < ccp->cmd_q_count; i++)
-		if (ccp->cmd_q[i].kthread)
-			kthread_stop(ccp->cmd_q[i].kthread);
-
-	ccp->free_irq(ccp);
-
-e_pool:
-	for (i = 0; i < ccp->cmd_q_count; i++)
-		dma_pool_destroy(ccp->cmd_q[i].dma_pool);
-
-	return ret;
-}
-
-/**
- * ccp_destroy - tear down the CCP device
- *
- * @ccp: ccp_device struct
- */
-void ccp_destroy(struct ccp_device *ccp)
-{
-	struct ccp_cmd_queue *cmd_q;
-	struct ccp_cmd *cmd;
-	unsigned int qim, i;
-
-	/* Remove general access to the device struct */
-	ccp_del_device(ccp);
-
-	/* Unregister the RNG */
-	hwrng_unregister(&ccp->hwrng);
-
-	/* Stop the queue kthreads */
-	for (i = 0; i < ccp->cmd_q_count; i++)
-		if (ccp->cmd_q[i].kthread)
-			kthread_stop(ccp->cmd_q[i].kthread);
-
-	/* Build queue interrupt mask (two interrupt masks per queue) */
-	qim = 0;
-	for (i = 0; i < ccp->cmd_q_count; i++) {
-		cmd_q = &ccp->cmd_q[i];
-		qim |= cmd_q->int_ok | cmd_q->int_err;
-	}
-
-	/* Disable and clear interrupts */
-	iowrite32(0x00, ccp->io_regs + IRQ_MASK_REG);
-	for (i = 0; i < ccp->cmd_q_count; i++) {
-		cmd_q = &ccp->cmd_q[i];
-
-		ioread32(cmd_q->reg_int_status);
-		ioread32(cmd_q->reg_status);
-	}
-	iowrite32(qim, ccp->io_regs + IRQ_STATUS_REG);
-
-	ccp->free_irq(ccp);
-
-	for (i = 0; i < ccp->cmd_q_count; i++)
-		dma_pool_destroy(ccp->cmd_q[i].dma_pool);
-
-	/* Flush the cmd and backlog queue */
-	while (!list_empty(&ccp->cmd)) {
-		/* Invoke the callback directly with an error code */
-		cmd = list_first_entry(&ccp->cmd, struct ccp_cmd, entry);
-		list_del(&cmd->entry);
-		cmd->callback(cmd->data, -ENODEV);
-	}
-	while (!list_empty(&ccp->backlog)) {
-		/* Invoke the callback directly with an error code */
-		cmd = list_first_entry(&ccp->backlog, struct ccp_cmd, entry);
-		list_del(&cmd->entry);
-		cmd->callback(cmd->data, -ENODEV);
-	}
-}
-
-/**
- * ccp_irq_handler - handle interrupts generated by the CCP device
- *
- * @irq: the irq associated with the interrupt
- * @data: the data value supplied when the irq was created
- */
-irqreturn_t ccp_irq_handler(int irq, void *data)
-{
-	struct device *dev = data;
-	struct ccp_device *ccp = dev_get_drvdata(dev);
-	struct ccp_cmd_queue *cmd_q;
-	u32 q_int, status;
-	unsigned int i;
-
-	status = ioread32(ccp->io_regs + IRQ_STATUS_REG);
-
-	for (i = 0; i < ccp->cmd_q_count; i++) {
-		cmd_q = &ccp->cmd_q[i];
-
-		q_int = status & (cmd_q->int_ok | cmd_q->int_err);
-		if (q_int) {
-			cmd_q->int_status = status;
-			cmd_q->q_status = ioread32(cmd_q->reg_status);
-			cmd_q->q_int_status = ioread32(cmd_q->reg_int_status);
-
-			/* On error, only save the first error value */
-			if ((q_int & cmd_q->int_err) && !cmd_q->cmd_error)
-				cmd_q->cmd_error = CMD_Q_ERROR(cmd_q->q_status);
-
-			cmd_q->int_rcvd = 1;
-
-			/* Acknowledge the interrupt and wake the kthread */
-			iowrite32(q_int, ccp->io_regs + IRQ_STATUS_REG);
-			wake_up_interruptible(&cmd_q->int_queue);
-		}
-	}
-
-	return IRQ_HANDLED;
-}
-
 #ifdef CONFIG_PM
 bool ccp_queues_suspended(struct ccp_device *ccp)
 {
@@ -687,10 +427,6 @@ bool ccp_queues_suspended(struct ccp_device *ccp)
 }
 #endif
 
-struct ccp_vdata ccpv3 = {
-	.version = CCP_VERSION(3, 0),
-};
-
 static int __init ccp_mod_init(void)
 {
 #ifdef CONFIG_X86
diff --git a/drivers/crypto/ccp/ccp-dev.h b/drivers/crypto/ccp/ccp-dev.h
index 90a8cc8..7745d0b 100644
--- a/drivers/crypto/ccp/ccp-dev.h
+++ b/drivers/crypto/ccp/ccp-dev.h
@@ -141,9 +141,25 @@
 #define CCP_ECC_RESULT_OFFSET		60
 #define CCP_ECC_RESULT_SUCCESS		0x0001
 
+struct ccp_op;
+
+/* Structure for computation functions that are device-specific */
+struct ccp_actions {
+	int (*perform_aes)(struct ccp_op *);
+	int (*perform_xts_aes)(struct ccp_op *);
+	int (*perform_sha)(struct ccp_op *);
+	int (*perform_rsa)(struct ccp_op *);
+	int (*perform_passthru)(struct ccp_op *);
+	int (*perform_ecc)(struct ccp_op *);
+	int (*init)(struct ccp_device *);
+	void (*destroy)(struct ccp_device *);
+	irqreturn_t (*irqhandler)(int, void *);
+};
+
 /* Structure to hold CCP version-specific values */
 struct ccp_vdata {
 	unsigned int version;
+	struct ccp_actions *perform;
 };
 
 extern struct ccp_vdata ccpv3;
@@ -273,18 +289,132 @@ struct ccp_device {
 	unsigned int axcache;
 };
 
+enum ccp_memtype {
+	CCP_MEMTYPE_SYSTEM = 0,
+	CCP_MEMTYPE_KSB,
+	CCP_MEMTYPE_LOCAL,
+	CCP_MEMTYPE__LAST,
+};
+
+struct ccp_dma_info {
+	dma_addr_t address;
+	unsigned int offset;
+	unsigned int length;
+	enum dma_data_direction dir;
+};
+
+struct ccp_dm_workarea {
+	struct device *dev;
+	struct dma_pool *dma_pool;
+	unsigned int length;
+
+	u8 *address;
+	struct ccp_dma_info dma;
+};
+
+struct ccp_sg_workarea {
+	struct scatterlist *sg;
+	int nents;
+
+	struct scatterlist *dma_sg;
+	struct device *dma_dev;
+	unsigned int dma_count;
+	enum dma_data_direction dma_dir;
+
+	unsigned int sg_used;
+
+	u64 bytes_left;
+};
+
+struct ccp_data {
+	struct ccp_sg_workarea sg_wa;
+	struct ccp_dm_workarea dm_wa;
+};
+
+struct ccp_mem {
+	enum ccp_memtype type;
+	union {
+		struct ccp_dma_info dma;
+		u32 ksb;
+	} u;
+};
+
+struct ccp_aes_op {
+	enum ccp_aes_type type;
+	enum ccp_aes_mode mode;
+	enum ccp_aes_action action;
+};
+
+struct ccp_xts_aes_op {
+	enum ccp_aes_action action;
+	enum ccp_xts_aes_unit_size unit_size;
+};
+
+struct ccp_sha_op {
+	enum ccp_sha_type type;
+	u64 msg_bits;
+};
+
+struct ccp_rsa_op {
+	u32 mod_size;
+	u32 input_len;
+};
+
+struct ccp_passthru_op {
+	enum ccp_passthru_bitwise bit_mod;
+	enum ccp_passthru_byteswap byte_swap;
+};
+
+struct ccp_ecc_op {
+	enum ccp_ecc_function function;
+};
+
+struct ccp_op {
+	struct ccp_cmd_queue *cmd_q;
+
+	u32 jobid;
+	u32 ioc;
+	u32 soc;
+	u32 ksb_key;
+	u32 ksb_ctx;
+	u32 init;
+	u32 eom;
+
+	struct ccp_mem src;
+	struct ccp_mem dst;
+
+	union {
+		struct ccp_aes_op aes;
+		struct ccp_xts_aes_op xts;
+		struct ccp_sha_op sha;
+		struct ccp_rsa_op rsa;
+		struct ccp_passthru_op passthru;
+		struct ccp_ecc_op ecc;
+	} u;
+};
+
+static inline u32 ccp_addr_lo(struct ccp_dma_info *info)
+{
+	return lower_32_bits(info->address + info->offset);
+}
+
+static inline u32 ccp_addr_hi(struct ccp_dma_info *info)
+{
+	return upper_32_bits(info->address + info->offset) & 0x0000ffff;
+}
+
 int ccp_pci_init(void);
 void ccp_pci_exit(void);
 
 int ccp_platform_init(void);
 void ccp_platform_exit(void);
 
+void ccp_add_device(struct ccp_device *ccp);
+void ccp_del_device(struct ccp_device *ccp);
+
 struct ccp_device *ccp_alloc_struct(struct device *dev);
-int ccp_init(struct ccp_device *ccp);
-void ccp_destroy(struct ccp_device *ccp);
 bool ccp_queues_suspended(struct ccp_device *ccp);
-
-irqreturn_t ccp_irq_handler(int irq, void *data);
+int ccp_cmd_queue_thread(void *data);
 
 int ccp_run_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd);
 
diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
index 6613aee..eefdf59 100644
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -1,7 +1,7 @@
 /*
  * AMD Cryptographic Coprocessor (CCP) driver
  *
- * Copyright (C) 2013 Advanced Micro Devices, Inc.
+ * Copyright (C) 2013,2016 Advanced Micro Devices, Inc.
  *
  * Author: Tom Lendacky <thomas.lendacky@amd.com>
  *
@@ -13,124 +13,12 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/pci.h>
-#include <linux/pci_ids.h>
-#include <linux/kthread.h>
-#include <linux/sched.h>
 #include <linux/interrupt.h>
-#include <linux/spinlock.h>
-#include <linux/mutex.h>
-#include <linux/delay.h>
-#include <linux/ccp.h>
-#include <linux/scatterlist.h>
 #include <crypto/scatterwalk.h>
-#include <crypto/sha.h>
+#include <linux/ccp.h>
 
 #include "ccp-dev.h"
 
-enum ccp_memtype {
-	CCP_MEMTYPE_SYSTEM = 0,
-	CCP_MEMTYPE_KSB,
-	CCP_MEMTYPE_LOCAL,
-	CCP_MEMTYPE__LAST,
-};
-
-struct ccp_dma_info {
-	dma_addr_t address;
-	unsigned int offset;
-	unsigned int length;
-	enum dma_data_direction dir;
-};
-
-struct ccp_dm_workarea {
-	struct device *dev;
-	struct dma_pool *dma_pool;
-	unsigned int length;
-
-	u8 *address;
-	struct ccp_dma_info dma;
-};
-
-struct ccp_sg_workarea {
-	struct scatterlist *sg;
-	int nents;
-
-	struct scatterlist *dma_sg;
-	struct device *dma_dev;
-	unsigned int dma_count;
-	enum dma_data_direction dma_dir;
-
-	unsigned int sg_used;
-
-	u64 bytes_left;
-};
-
-struct ccp_data {
-	struct ccp_sg_workarea sg_wa;
-	struct ccp_dm_workarea dm_wa;
-};
-
-struct ccp_mem {
-	enum ccp_memtype type;
-	union {
-		struct ccp_dma_info dma;
-		u32 ksb;
-	} u;
-};
-
-struct ccp_aes_op {
-	enum ccp_aes_type type;
-	enum ccp_aes_mode mode;
-	enum ccp_aes_action action;
-};
-
-struct ccp_xts_aes_op {
-	enum ccp_aes_action action;
-	enum ccp_xts_aes_unit_size unit_size;
-};
-
-struct ccp_sha_op {
-	enum ccp_sha_type type;
-	u64 msg_bits;
-};
-
-struct ccp_rsa_op {
-	u32 mod_size;
-	u32 input_len;
-};
-
-struct ccp_passthru_op {
-	enum ccp_passthru_bitwise bit_mod;
-	enum ccp_passthru_byteswap byte_swap;
-};
-
-struct ccp_ecc_op {
-	enum ccp_ecc_function function;
-};
-
-struct ccp_op {
-	struct ccp_cmd_queue *cmd_q;
-
-	u32 jobid;
-	u32 ioc;
-	u32 soc;
-	u32 ksb_key;
-	u32 ksb_ctx;
-	u32 init;
-	u32 eom;
-
-	struct ccp_mem src;
-	struct ccp_mem dst;
-
-	union {
-		struct ccp_aes_op aes;
-		struct ccp_xts_aes_op xts;
-		struct ccp_sha_op sha;
-		struct ccp_rsa_op rsa;
-		struct ccp_passthru_op passthru;
-		struct ccp_ecc_op ecc;
-	} u;
-};
-
 /* SHA initial context values */
 static const __be32 ccp_sha1_init[CCP_SHA_CTXSIZE / sizeof(__be32)] = {
 	cpu_to_be32(SHA1_H0), cpu_to_be32(SHA1_H1),
@@ -152,253 +40,6 @@ static const __be32 ccp_sha256_init[CCP_SHA_CTXSIZE / sizeof(__be32)] = {
 	cpu_to_be32(SHA256_H6), cpu_to_be32(SHA256_H7),
 };
 
-static u32 ccp_addr_lo(struct ccp_dma_info *info)
-{
-	return lower_32_bits(info->address + info->offset);
-}
-
-static u32 ccp_addr_hi(struct ccp_dma_info *info)
-{
-	return upper_32_bits(info->address + info->offset) & 0x0000ffff;
-}
-
-static int ccp_do_cmd(struct ccp_op *op, u32 *cr, unsigned int cr_count)
-{
-	struct ccp_cmd_queue *cmd_q = op->cmd_q;
-	struct ccp_device *ccp = cmd_q->ccp;
-	void __iomem *cr_addr;
-	u32 cr0, cmd;
-	unsigned int i;
-	int ret = 0;
-
-	/* We could read a status register to see how many free slots
-	 * are actually available, but reading that register resets it
-	 * and you could lose some error information.
-	 */
-	cmd_q->free_slots--;
-
-	cr0 = (cmd_q->id << REQ0_CMD_Q_SHIFT)
-	      | (op->jobid << REQ0_JOBID_SHIFT)
-	      | REQ0_WAIT_FOR_WRITE;
-
-	if (op->soc)
-		cr0 |= REQ0_STOP_ON_COMPLETE
-		       | REQ0_INT_ON_COMPLETE;
-
-	if (op->ioc || !cmd_q->free_slots)
-		cr0 |= REQ0_INT_ON_COMPLETE;
-
-	/* Start at CMD_REQ1 */
-	cr_addr = ccp->io_regs + CMD_REQ0 + CMD_REQ_INCR;
-
-	mutex_lock(&ccp->req_mutex);
-
-	/* Write CMD_REQ1 through CMD_REQx first */
-	for (i = 0; i < cr_count; i++, cr_addr += CMD_REQ_INCR)
-		iowrite32(*(cr + i), cr_addr);
-
-	/* Tell the CCP to start */
-	wmb();
-	iowrite32(cr0, ccp->io_regs + CMD_REQ0);
-
-	mutex_unlock(&ccp->req_mutex);
-
-	if (cr0 & REQ0_INT_ON_COMPLETE) {
-		/* Wait for the job to complete */
-		ret = wait_event_interruptible(cmd_q->int_queue,
-					       cmd_q->int_rcvd);
-		if (ret || cmd_q->cmd_error) {
-			/* On error delete all related jobs from the queue */
-			cmd = (cmd_q->id << DEL_Q_ID_SHIFT)
-			      | op->jobid;
-
-			iowrite32(cmd, ccp->io_regs + DEL_CMD_Q_JOB);
-
-			if (!ret)
-				ret = -EIO;
-		} else if (op->soc) {
-			/* Delete just head job from the queue on SoC */
-			cmd = DEL_Q_ACTIVE
-			      | (cmd_q->id << DEL_Q_ID_SHIFT)
-			      | op->jobid;
-
-			iowrite32(cmd, ccp->io_regs + DEL_CMD_Q_JOB);
-		}
-
-		cmd_q->free_slots = CMD_Q_DEPTH(cmd_q->q_status);
-
-		cmd_q->int_rcvd = 0;
-	}
-
-	return ret;
-}
-
-static int ccp_perform_aes(struct ccp_op *op)
-{
-	u32 cr[6];
-
-	/* Fill out the register contents for REQ1 through REQ6 */
-	cr[0] = (CCP_ENGINE_AES << REQ1_ENGINE_SHIFT)
-		| (op->u.aes.type << REQ1_AES_TYPE_SHIFT)
-		| (op->u.aes.mode << REQ1_AES_MODE_SHIFT)
-		| (op->u.aes.action << REQ1_AES_ACTION_SHIFT)
-		| (op->ksb_key << REQ1_KEY_KSB_SHIFT);
-	cr[1] = op->src.u.dma.length - 1;
-	cr[2] = ccp_addr_lo(&op->src.u.dma);
-	cr[3] = (op->ksb_ctx << REQ4_KSB_SHIFT)
-		| (CCP_MEMTYPE_SYSTEM << REQ4_MEMTYPE_SHIFT)
-		| ccp_addr_hi(&op->src.u.dma);
-	cr[4] = ccp_addr_lo(&op->dst.u.dma);
-	cr[5] = (CCP_MEMTYPE_SYSTEM << REQ6_MEMTYPE_SHIFT)
-		| ccp_addr_hi(&op->dst.u.dma);
-
-	if (op->u.aes.mode == CCP_AES_MODE_CFB)
-		cr[0] |= ((0x7f) << REQ1_AES_CFB_SIZE_SHIFT);
-
-	if (op->eom)
-		cr[0] |= REQ1_EOM;
-
-	if (op->init)
-		cr[0] |= REQ1_INIT;
-
-	return ccp_do_cmd(op, cr, ARRAY_SIZE(cr));
-}
-
-static int ccp_perform_xts_aes(struct ccp_op *op)
-{
-	u32 cr[6];
-
-	/* Fill out the register contents for REQ1 through REQ6 */
-	cr[0] = (CCP_ENGINE_XTS_AES_128 << REQ1_ENGINE_SHIFT)
-		| (op->u.xts.action << REQ1_AES_ACTION_SHIFT)
-		| (op->u.xts.unit_size << REQ1_XTS_AES_SIZE_SHIFT)
-		| (op->ksb_key << REQ1_KEY_KSB_SHIFT);
-	cr[1] = op->src.u.dma.length - 1;
-	cr[2] = ccp_addr_lo(&op->src.u.dma);
-	cr[3] = (op->ksb_ctx << REQ4_KSB_SHIFT)
-		| (CCP_MEMTYPE_SYSTEM << REQ4_MEMTYPE_SHIFT)
-		| ccp_addr_hi(&op->src.u.dma);
-	cr[4] = ccp_addr_lo(&op->dst.u.dma);
-	cr[5] = (CCP_MEMTYPE_SYSTEM << REQ6_MEMTYPE_SHIFT)
-		| ccp_addr_hi(&op->dst.u.dma);
-
-	if (op->eom)
-		cr[0] |= REQ1_EOM;
-
-	if (op->init)
-		cr[0] |= REQ1_INIT;
-
-	return ccp_do_cmd(op, cr, ARRAY_SIZE(cr));
-}
-
-static int ccp_perform_sha(struct ccp_op *op)
-{
-	u32 cr[6];
-
-	/* Fill out the register contents for REQ1 through REQ6 */
-	cr[0] = (CCP_ENGINE_SHA << REQ1_ENGINE_SHIFT)
-		| (op->u.sha.type << REQ1_SHA_TYPE_SHIFT)
-		| REQ1_INIT;
-	cr[1] = op->src.u.dma.length - 1;
-	cr[2] = ccp_addr_lo(&op->src.u.dma);
-	cr[3] = (op->ksb_ctx << REQ4_KSB_SHIFT)
-		| (CCP_MEMTYPE_SYSTEM << REQ4_MEMTYPE_SHIFT)
-		| ccp_addr_hi(&op->src.u.dma);
-
-	if (op->eom) {
-		cr[0] |= REQ1_EOM;
-		cr[4] = lower_32_bits(op->u.sha.msg_bits);
-		cr[5] = upper_32_bits(op->u.sha.msg_bits);
-	} else {
-		cr[4] = 0;
-		cr[5] = 0;
-	}
-
-	return ccp_do_cmd(op, cr, ARRAY_SIZE(cr));
-}
-
-static int ccp_perform_rsa(struct ccp_op *op)
-{
-	u32 cr[6];
-
-	/* Fill out the register contents for REQ1 through REQ6 */
-	cr[0] = (CCP_ENGINE_RSA << REQ1_ENGINE_SHIFT)
-		| (op->u.rsa.mod_size << REQ1_RSA_MOD_SIZE_SHIFT)
-		| (op->ksb_key << REQ1_KEY_KSB_SHIFT)
-		| REQ1_EOM;
-	cr[1] = op->u.rsa.input_len - 1;
-	cr[2] = ccp_addr_lo(&op->src.u.dma);
-	cr[3] = (op->ksb_ctx << REQ4_KSB_SHIFT)
-		| (CCP_MEMTYPE_SYSTEM << REQ4_MEMTYPE_SHIFT)
-		| ccp_addr_hi(&op->src.u.dma);
-	cr[4] = ccp_addr_lo(&op->dst.u.dma);
-	cr[5] = (CCP_MEMTYPE_SYSTEM << REQ6_MEMTYPE_SHIFT)
-		| ccp_addr_hi(&op->dst.u.dma);
-
-	return ccp_do_cmd(op, cr, ARRAY_SIZE(cr));
-}
-
-static int ccp_perform_passthru(struct ccp_op *op)
-{
-	u32 cr[6];
-
-	/* Fill out the register contents for REQ1 through REQ6 */
-	cr[0] = (CCP_ENGINE_PASSTHRU << REQ1_ENGINE_SHIFT)
-		| (op->u.passthru.bit_mod << REQ1_PT_BW_SHIFT)
-		| (op->u.passthru.byte_swap << REQ1_PT_BS_SHIFT);
-
-	if (op->src.type == CCP_MEMTYPE_SYSTEM)
-		cr[1] = op->src.u.dma.length - 1;
-	else
-		cr[1] = op->dst.u.dma.length - 1;
-
-	if (op->src.type == CCP_MEMTYPE_SYSTEM) {
-		cr[2] = ccp_addr_lo(&op->src.u.dma);
-		cr[3] = (CCP_MEMTYPE_SYSTEM << REQ4_MEMTYPE_SHIFT)
-			| ccp_addr_hi(&op->src.u.dma);
-
-		if (op->u.passthru.bit_mod != CCP_PASSTHRU_BITWISE_NOOP)
-			cr[3] |= (op->ksb_key << REQ4_KSB_SHIFT);
-	} else {
-		cr[2] = op->src.u.ksb * CCP_KSB_BYTES;
-		cr[3] = (CCP_MEMTYPE_KSB << REQ4_MEMTYPE_SHIFT);
-	}
-
-	if (op->dst.type == CCP_MEMTYPE_SYSTEM) {
-		cr[4] = ccp_addr_lo(&op->dst.u.dma);
-		cr[5] = (CCP_MEMTYPE_SYSTEM << REQ6_MEMTYPE_SHIFT)
-			| ccp_addr_hi(&op->dst.u.dma);
-	} else {
-		cr[4] = op->dst.u.ksb * CCP_KSB_BYTES;
-		cr[5] = (CCP_MEMTYPE_KSB << REQ6_MEMTYPE_SHIFT);
-	}
-
-	if (op->eom)
-		cr[0] |= REQ1_EOM;
-
-	return ccp_do_cmd(op, cr, ARRAY_SIZE(cr));
-}
-
-static int ccp_perform_ecc(struct ccp_op *op)
-{
-	u32 cr[6];
-
-	/* Fill out the register contents for REQ1 through REQ6 */
-	cr[0] = REQ1_ECC_AFFINE_CONVERT
-		| (CCP_ENGINE_ECC << REQ1_ENGINE_SHIFT)
-		| (op->u.ecc.function << REQ1_ECC_FUNCTION_SHIFT)
-		| REQ1_EOM;
-	cr[1] = op->src.u.dma.length - 1;
-	cr[2] = ccp_addr_lo(&op->src.u.dma);
-	cr[3] = (CCP_MEMTYPE_SYSTEM << REQ4_MEMTYPE_SHIFT)
-		| ccp_addr_hi(&op->src.u.dma);
-	cr[4] = ccp_addr_lo(&op->dst.u.dma);
-	cr[5] = (CCP_MEMTYPE_SYSTEM << REQ6_MEMTYPE_SHIFT)
-		| ccp_addr_hi(&op->dst.u.dma);
-
-	return ccp_do_cmd(op, cr, ARRAY_SIZE(cr));
-}
-
 static u32 ccp_alloc_ksb(struct ccp_device *ccp, unsigned int count)
 {
 	int start;
@@ -837,7 +478,7 @@ static int ccp_copy_to_from_ksb(struct ccp_cmd_queue *cmd_q,
 
 	op.u.passthru.byte_swap = byte_swap;
 
-	return ccp_perform_passthru(&op);
+	return cmd_q->ccp->vdata->perform->perform_passthru(&op);
 }
 
 static int ccp_copy_to_ksb(struct ccp_cmd_queue *cmd_q,
@@ -969,7 +610,7 @@ static int ccp_run_aes_cmac_cmd(struct ccp_cmd_queue *cmd_q,
 			}
 		}
 
-		ret = ccp_perform_aes(&op);
+		ret = cmd_q->ccp->vdata->perform->perform_aes(&op);
 		if (ret) {
 			cmd->engine_error = cmd_q->cmd_error;
 			goto e_src;
@@ -1131,7 +772,7 @@ static int ccp_run_aes_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 				op.soc = 1;
 		}
 
-		ret = ccp_perform_aes(&op);
+		ret = cmd_q->ccp->vdata->perform->perform_aes(&op);
 		if (ret) {
 			cmd->engine_error = cmd_q->cmd_error;
 			goto e_dst;
@@ -1296,7 +937,7 @@ static int ccp_run_xts_aes_cmd(struct ccp_cmd_queue *cmd_q,
 		if (!src.sg_wa.bytes_left)
 			op.eom = 1;
 
-		ret = ccp_perform_xts_aes(&op);
+		ret = cmd_q->ccp->vdata->perform->perform_xts_aes(&op);
 		if (ret) {
 			cmd->engine_error = cmd_q->cmd_error;
 			goto e_dst;
@@ -1453,7 +1094,7 @@ static int ccp_run_sha_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 		if (sha->final && !src.sg_wa.bytes_left)
 			op.eom = 1;
 
-		ret = ccp_perform_sha(&op);
+		ret = cmd_q->ccp->vdata->perform->perform_sha(&op);
 		if (ret) {
 			cmd->engine_error = cmd_q->cmd_error;
 			goto e_data;
@@ -1633,7 +1274,7 @@ static int ccp_run_rsa_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 	op.u.rsa.mod_size = rsa->key_size;
 	op.u.rsa.input_len = i_len;
 
-	ret = ccp_perform_rsa(&op);
+	ret = cmd_q->ccp->vdata->perform->perform_rsa(&op);
 	if (ret) {
 		cmd->engine_error = cmd_q->cmd_error;
 		goto e_dst;
@@ -1758,7 +1399,7 @@ static int ccp_run_passthru_cmd(struct ccp_cmd_queue *cmd_q,
 		op.dst.u.dma.offset = dst.sg_wa.sg_used;
 		op.dst.u.dma.length = op.src.u.dma.length;
 
-		ret = ccp_perform_passthru(&op);
+		ret = cmd_q->ccp->vdata->perform->perform_passthru(&op);
 		if (ret) {
 			cmd->engine_error = cmd_q->cmd_error;
 			goto e_dst;
@@ -1870,7 +1511,7 @@ static int ccp_run_ecc_mm_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 
 	op.u.ecc.function = cmd->u.ecc.function;
 
-	ret = ccp_perform_ecc(&op);
+	ret = cmd_q->ccp->vdata->perform->perform_ecc(&op);
 	if (ret) {
 		cmd->engine_error = cmd_q->cmd_error;
 		goto e_dst;
@@ -2034,7 +1675,7 @@ static int ccp_run_ecc_pm_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 
 	op.u.ecc.function = cmd->u.ecc.function;
 
-	ret = ccp_perform_ecc(&op);
+	ret = cmd_q->ccp->vdata->perform->perform_ecc(&op);
 	if (ret) {
 		cmd->engine_error = cmd_q->cmd_error;
 		goto e_dst;
diff --git a/drivers/crypto/ccp/ccp-pci.c b/drivers/crypto/ccp/ccp-pci.c
index d1a36af..0bf262e 100644
--- a/drivers/crypto/ccp/ccp-pci.c
+++ b/drivers/crypto/ccp/ccp-pci.c
@@ -62,7 +62,8 @@ static int ccp_get_msix_irqs(struct ccp_device *ccp)
 		snprintf(ccp_pci->msix[v].name, name_len, "%s-%u",
 			 ccp->name, v);
 		ccp_pci->msix[v].vector = msix_entry[v].vector;
-		ret = request_irq(ccp_pci->msix[v].vector, ccp_irq_handler,
+		ret = request_irq(ccp_pci->msix[v].vector,
+				  ccp->vdata->perform->irqhandler,
 				  0, ccp_pci->msix[v].name, dev);
 		if (ret) {
 			dev_notice(dev, "unable to allocate MSI-X IRQ (%d)\n",
@@ -95,7 +96,8 @@ static int ccp_get_msi_irq(struct ccp_device *ccp)
 		return ret;
 
 	ccp->irq = pdev->irq;
-	ret = request_irq(ccp->irq, ccp_irq_handler, 0, ccp->name, dev);
+	ret = request_irq(ccp->irq, ccp->vdata->perform->irqhandler, 0,
+			  ccp->name, dev);
 	if (ret) {
 		dev_notice(dev, "unable to allocate MSI IRQ (%d)\n", ret);
 		goto e_msi;
@@ -228,7 +230,7 @@ static int ccp_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	dev_set_drvdata(dev, ccp);
 
-	ret = ccp_init(ccp);
+	ret = ccp->vdata->perform->init(ccp);
 	if (ret)
 		goto e_iomap;
 
@@ -258,7 +260,7 @@ static void ccp_pci_remove(struct pci_dev *pdev)
 	if (!ccp)
 		return;
 
-	ccp_destroy(ccp);
+	ccp->vdata->perform->destroy(ccp);
 
 	pci_iounmap(pdev, ccp->io_map);
 
diff --git a/drivers/crypto/ccp/ccp-platform.c b/drivers/crypto/ccp/ccp-platform.c
index 6e1cf22..351f28d8 100644
--- a/drivers/crypto/ccp/ccp-platform.c
+++ b/drivers/crypto/ccp/ccp-platform.c
@@ -70,7 +70,8 @@ static int ccp_get_irq(struct ccp_device *ccp)
 		return ret;
 
 	ccp->irq = ret;
-	ret = request_irq(ccp->irq, ccp_irq_handler, 0, ccp->name, dev);
+	ret = request_irq(ccp->irq, ccp->vdata->perform->irqhandler, 0,
+			  ccp->name, dev);
 	if (ret) {
 		dev_notice(dev, "unable to allocate IRQ (%d)\n", ret);
 		return ret;
@@ -171,7 +172,7 @@ static int ccp_platform_probe(struct platform_device *pdev)
 
 	dev_set_drvdata(dev, ccp);
 
-	ret = ccp_init(ccp);
+	ret = ccp->vdata->perform->init(ccp);
 	if (ret)
 		goto e_err;
 
@@ -189,7 +190,7 @@ static int ccp_platform_remove(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct ccp_device *ccp = dev_get_drvdata(dev);
 
-	ccp_destroy(ccp);
+	ccp->vdata->perform->destroy(ccp);
 
 	dev_notice(dev, "disabled\n");
 
