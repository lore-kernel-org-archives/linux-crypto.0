From: Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH 1/2] crypto: move CCP device driver to misc
Date: Thu, 19 Jan 2017 13:08:01 -0500
Message-ID: <148484928147.30852.7911360215597694759.stgit@brijesh-build-machine>
References: <148484927002.30852.10568570584817827556.stgit@brijesh-build-machine>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <brijesh.singh@amd.com>
To: <thomas.lendacky@amd.com>, <herbert@gondor.apana.org.au>,
        <arnd@arndb.de>, <gregkh@linuxfoundation.org>,
        <lambert.quentin@gmail.com>, <gary.hook@amd.com>,
        <linux-kernel@vger.kernel.org>, <Julia.Lawall@lip6.fr>,
        <weiyongjun1@huawei.com>, <linux-crypto@vger.kernel.org>,
        <umgwanakikbuti@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <148484927002.30852.10568570584817827556.stgit@brijesh-build-machine>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The CCP device is part of the AMD Secure Processor, which is not dedicated
solely to crypto. Move the CCP device driver to the misc directory in
prepration for expanding the usage of the AMD Secure Processor. Leaving the
CCP cryptographic layer (the ccp-crypto* files) in their current directory.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/crypto/Kconfig              |   11 
 drivers/crypto/Makefile             |    2 
 drivers/crypto/ccp/Kconfig          |   21 
 drivers/crypto/ccp/Makefile         |    9 
 drivers/crypto/ccp/ccp-dev-v3.c     |  574 -----------
 drivers/crypto/ccp/ccp-dev-v5.c     | 1021 -------------------
 drivers/crypto/ccp/ccp-dev.c        |  588 -----------
 drivers/crypto/ccp/ccp-dev.h        |  647 ------------
 drivers/crypto/ccp/ccp-dmaengine.c  |  728 --------------
 drivers/crypto/ccp/ccp-ops.c        | 1876 -----------------------------------
 drivers/crypto/ccp/ccp-pci.c        |  354 -------
 drivers/crypto/ccp/ccp-platform.c   |  293 -----
 drivers/misc/Kconfig                |    1 
 drivers/misc/Makefile               |    1 
 drivers/misc/amd-sp/Kconfig         |   14 
 drivers/misc/amd-sp/Makefile        |    8 
 drivers/misc/amd-sp/ccp-dev-v3.c    |  574 +++++++++++
 drivers/misc/amd-sp/ccp-dev-v5.c    | 1021 +++++++++++++++++++
 drivers/misc/amd-sp/ccp-dev.c       |  588 +++++++++++
 drivers/misc/amd-sp/ccp-dev.h       |  647 ++++++++++++
 drivers/misc/amd-sp/ccp-dmaengine.c |  728 ++++++++++++++
 drivers/misc/amd-sp/ccp-ops.c       | 1876 +++++++++++++++++++++++++++++++++++
 drivers/misc/amd-sp/ccp-pci.c       |  354 +++++++
 drivers/misc/amd-sp/ccp-platform.c  |  293 +++++
 include/linux/ccp.h                 |    3 
 25 files changed, 6111 insertions(+), 6121 deletions(-)
 delete mode 100644 drivers/crypto/ccp/ccp-dev-v3.c
 delete mode 100644 drivers/crypto/ccp/ccp-dev-v5.c
 delete mode 100644 drivers/crypto/ccp/ccp-dev.c
 delete mode 100644 drivers/crypto/ccp/ccp-dev.h
 delete mode 100644 drivers/crypto/ccp/ccp-dmaengine.c
 delete mode 100644 drivers/crypto/ccp/ccp-ops.c
 delete mode 100644 drivers/crypto/ccp/ccp-pci.c
 delete mode 100644 drivers/crypto/ccp/ccp-platform.c
 create mode 100644 drivers/misc/amd-sp/Kconfig
 create mode 100644 drivers/misc/amd-sp/Makefile
 create mode 100644 drivers/misc/amd-sp/ccp-dev-v3.c
 create mode 100644 drivers/misc/amd-sp/ccp-dev-v5.c
 create mode 100644 drivers/misc/amd-sp/ccp-dev.c
 create mode 100644 drivers/misc/amd-sp/ccp-dev.h
 create mode 100644 drivers/misc/amd-sp/ccp-dmaengine.c
 create mode 100644 drivers/misc/amd-sp/ccp-ops.c
 create mode 100644 drivers/misc/amd-sp/ccp-pci.c
 create mode 100644 drivers/misc/amd-sp/ccp-platform.c

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 8ded3af..48e733c 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -456,16 +456,7 @@ config CRYPTO_DEV_ATMEL_SHA
 	  To compile this driver as a module, choose M here: the module
 	  will be called atmel-sha.
 
-config CRYPTO_DEV_CCP
-	bool "Support for AMD Cryptographic Coprocessor"
-	depends on ((X86 && PCI) || (ARM64 && (OF_ADDRESS || ACPI))) && HAS_IOMEM
-	help
-	  The AMD Cryptographic Coprocessor provides hardware offload support
-	  for encryption, hashing and related operations.
-
-if CRYPTO_DEV_CCP
-	source "drivers/crypto/ccp/Kconfig"
-endif
+source "drivers/crypto/ccp/Kconfig"
 
 config CRYPTO_DEV_MXS_DCP
 	tristate "Support for Freescale MXS DCP"
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index 8891ccc..a697e1d 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -2,7 +2,7 @@ obj-$(CONFIG_CRYPTO_DEV_ATMEL_AES) += atmel-aes.o
 obj-$(CONFIG_CRYPTO_DEV_ATMEL_SHA) += atmel-sha.o
 obj-$(CONFIG_CRYPTO_DEV_ATMEL_TDES) += atmel-tdes.o
 obj-$(CONFIG_CRYPTO_DEV_BFIN_CRC) += bfin_crc.o
-obj-$(CONFIG_CRYPTO_DEV_CCP) += ccp/
+obj-$(CONFIG_CRYPTO_DEV_CCP_CRYPTO) += ccp/
 obj-$(CONFIG_CRYPTO_DEV_CHELSIO) += chelsio/
 obj-$(CONFIG_CRYPTO_DEV_FSL_CAAM) += caam/
 obj-$(CONFIG_CRYPTO_DEV_GEODE) += geode-aes.o
diff --git a/drivers/crypto/ccp/Kconfig b/drivers/crypto/ccp/Kconfig
index 2238f77..523d0f5 100644
--- a/drivers/crypto/ccp/Kconfig
+++ b/drivers/crypto/ccp/Kconfig
@@ -1,22 +1,7 @@
-config CRYPTO_DEV_CCP_DD
-	tristate "Cryptographic Coprocessor device driver"
-	depends on CRYPTO_DEV_CCP
-	default m
-	select HW_RANDOM
-	select DMA_ENGINE
-	select DMADEVICES
-	select CRYPTO_SHA1
-	select CRYPTO_SHA256
-	help
-	  Provides the interface to use the AMD Cryptographic Coprocessor
-	  which can be used to offload encryption operations such as SHA,
-	  AES and more. If you choose 'M' here, this module will be called
-	  ccp.
-
 config CRYPTO_DEV_CCP_CRYPTO
-	tristate "Encryption and hashing offload support"
-	depends on CRYPTO_DEV_CCP_DD
-	default m
+	tristate "Support for AMD Cryptographic Coprocessor"
+	default n
+	select AMD_CCP
 	select CRYPTO_HASH
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_AUTHENC
diff --git a/drivers/crypto/ccp/Makefile b/drivers/crypto/ccp/Makefile
index 346ceb8..613b333 100644
--- a/drivers/crypto/ccp/Makefile
+++ b/drivers/crypto/ccp/Makefile
@@ -1,12 +1,3 @@
-obj-$(CONFIG_CRYPTO_DEV_CCP_DD) += ccp.o
-ccp-objs := ccp-dev.o \
-	    ccp-ops.o \
-	    ccp-dev-v3.o \
-	    ccp-dev-v5.o \
-	    ccp-platform.o \
-	    ccp-dmaengine.o
-ccp-$(CONFIG_PCI) += ccp-pci.o
-
 obj-$(CONFIG_CRYPTO_DEV_CCP_CRYPTO) += ccp-crypto.o
 ccp-crypto-objs := ccp-crypto-main.o \
 		   ccp-crypto-aes.o \
diff --git a/drivers/crypto/ccp/ccp-dev-v3.c b/drivers/crypto/ccp/ccp-dev-v3.c
deleted file mode 100644
index 7bc0998..0000000
--- a/drivers/crypto/ccp/ccp-dev-v3.c
+++ /dev/null
@@ -1,574 +0,0 @@
-/*
- * AMD Cryptographic Coprocessor (CCP) driver
- *
- * Copyright (C) 2013,2016 Advanced Micro Devices, Inc.
- *
- * Author: Tom Lendacky <thomas.lendacky@amd.com>
- * Author: Gary R Hook <gary.hook@amd.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/pci.h>
-#include <linux/kthread.h>
-#include <linux/interrupt.h>
-#include <linux/ccp.h>
-
-#include "ccp-dev.h"
-
-static u32 ccp_alloc_ksb(struct ccp_cmd_queue *cmd_q, unsigned int count)
-{
-	int start;
-	struct ccp_device *ccp = cmd_q->ccp;
-
-	for (;;) {
-		mutex_lock(&ccp->sb_mutex);
-
-		start = (u32)bitmap_find_next_zero_area(ccp->sb,
-							ccp->sb_count,
-							ccp->sb_start,
-							count, 0);
-		if (start <= ccp->sb_count) {
-			bitmap_set(ccp->sb, start, count);
-
-			mutex_unlock(&ccp->sb_mutex);
-			break;
-		}
-
-		ccp->sb_avail = 0;
-
-		mutex_unlock(&ccp->sb_mutex);
-
-		/* Wait for KSB entries to become available */
-		if (wait_event_interruptible(ccp->sb_queue, ccp->sb_avail))
-			return 0;
-	}
-
-	return KSB_START + start;
-}
-
-static void ccp_free_ksb(struct ccp_cmd_queue *cmd_q, unsigned int start,
-			 unsigned int count)
-{
-	struct ccp_device *ccp = cmd_q->ccp;
-
-	if (!start)
-		return;
-
-	mutex_lock(&ccp->sb_mutex);
-
-	bitmap_clear(ccp->sb, start - KSB_START, count);
-
-	ccp->sb_avail = 1;
-
-	mutex_unlock(&ccp->sb_mutex);
-
-	wake_up_interruptible_all(&ccp->sb_queue);
-}
-
-static unsigned int ccp_get_free_slots(struct ccp_cmd_queue *cmd_q)
-{
-	return CMD_Q_DEPTH(ioread32(cmd_q->reg_status));
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
-			if (cmd_q->cmd_error)
-				ccp_log_error(cmd_q->ccp,
-					      cmd_q->cmd_error);
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
-		| (op->sb_key << REQ1_KEY_KSB_SHIFT);
-	cr[1] = op->src.u.dma.length - 1;
-	cr[2] = ccp_addr_lo(&op->src.u.dma);
-	cr[3] = (op->sb_ctx << REQ4_KSB_SHIFT)
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
-		| (op->sb_key << REQ1_KEY_KSB_SHIFT);
-	cr[1] = op->src.u.dma.length - 1;
-	cr[2] = ccp_addr_lo(&op->src.u.dma);
-	cr[3] = (op->sb_ctx << REQ4_KSB_SHIFT)
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
-	cr[3] = (op->sb_ctx << REQ4_KSB_SHIFT)
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
-		| (op->sb_key << REQ1_KEY_KSB_SHIFT)
-		| REQ1_EOM;
-	cr[1] = op->u.rsa.input_len - 1;
-	cr[2] = ccp_addr_lo(&op->src.u.dma);
-	cr[3] = (op->sb_ctx << REQ4_KSB_SHIFT)
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
-			cr[3] |= (op->sb_key << REQ4_KSB_SHIFT);
-	} else {
-		cr[2] = op->src.u.sb * CCP_SB_BYTES;
-		cr[3] = (CCP_MEMTYPE_SB << REQ4_MEMTYPE_SHIFT);
-	}
-
-	if (op->dst.type == CCP_MEMTYPE_SYSTEM) {
-		cr[4] = ccp_addr_lo(&op->dst.u.dma);
-		cr[5] = (CCP_MEMTYPE_SYSTEM << REQ6_MEMTYPE_SHIFT)
-			| ccp_addr_hi(&op->dst.u.dma);
-	} else {
-		cr[4] = op->dst.u.sb * CCP_SB_BYTES;
-		cr[5] = (CCP_MEMTYPE_SB << REQ6_MEMTYPE_SHIFT);
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
-static int ccp_init(struct ccp_device *ccp)
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
-		cmd_q->sb_key = KSB_START + ccp->sb_start++;
-		cmd_q->sb_ctx = KSB_START + ccp->sb_start++;
-		ccp->sb_count -= 2;
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
-		cmd_q->free_slots = ccp_get_free_slots(cmd_q);
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
-	dev_dbg(dev, "Starting threads...\n");
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
-	dev_dbg(dev, "Enabling interrupts...\n");
-	/* Enable interrupts */
-	iowrite32(qim, ccp->io_regs + IRQ_MASK_REG);
-
-	dev_dbg(dev, "Registering device...\n");
-	ccp_add_device(ccp);
-
-	ret = ccp_register_rng(ccp);
-	if (ret)
-		goto e_kthread;
-
-	/* Register the DMA engine support */
-	ret = ccp_dmaengine_register(ccp);
-	if (ret)
-		goto e_hwrng;
-
-	return 0;
-
-e_hwrng:
-	ccp_unregister_rng(ccp);
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
-static void ccp_destroy(struct ccp_device *ccp)
-{
-	struct ccp_cmd_queue *cmd_q;
-	struct ccp_cmd *cmd;
-	unsigned int qim, i;
-
-	/* Unregister the DMA engine */
-	ccp_dmaengine_unregister(ccp);
-
-	/* Unregister the RNG */
-	ccp_unregister_rng(ccp);
-
-	/* Remove this device from the list of available units */
-	ccp_del_device(ccp);
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
-	/* Stop the queue kthreads */
-	for (i = 0; i < ccp->cmd_q_count; i++)
-		if (ccp->cmd_q[i].kthread)
-			kthread_stop(ccp->cmd_q[i].kthread);
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
-static irqreturn_t ccp_irq_handler(int irq, void *data)
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
-static const struct ccp_actions ccp3_actions = {
-	.aes = ccp_perform_aes,
-	.xts_aes = ccp_perform_xts_aes,
-	.sha = ccp_perform_sha,
-	.rsa = ccp_perform_rsa,
-	.passthru = ccp_perform_passthru,
-	.ecc = ccp_perform_ecc,
-	.sballoc = ccp_alloc_ksb,
-	.sbfree = ccp_free_ksb,
-	.init = ccp_init,
-	.destroy = ccp_destroy,
-	.get_free_slots = ccp_get_free_slots,
-	.irqhandler = ccp_irq_handler,
-};
-
-const struct ccp_vdata ccpv3 = {
-	.version = CCP_VERSION(3, 0),
-	.setup = NULL,
-	.perform = &ccp3_actions,
-	.bar = 2,
-	.offset = 0x20000,
-};
diff --git a/drivers/crypto/ccp/ccp-dev-v5.c b/drivers/crypto/ccp/ccp-dev-v5.c
deleted file mode 100644
index e2ce819..0000000
--- a/drivers/crypto/ccp/ccp-dev-v5.c
+++ /dev/null
@@ -1,1021 +0,0 @@
-/*
- * AMD Cryptographic Coprocessor (CCP) driver
- *
- * Copyright (C) 2016 Advanced Micro Devices, Inc.
- *
- * Author: Gary R Hook <gary.hook@amd.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/pci.h>
-#include <linux/kthread.h>
-#include <linux/dma-mapping.h>
-#include <linux/interrupt.h>
-#include <linux/compiler.h>
-#include <linux/ccp.h>
-
-#include "ccp-dev.h"
-
-/* Allocate the requested number of contiguous LSB slots
- * from the LSB bitmap. Look in the private range for this
- * queue first; failing that, check the public area.
- * If no space is available, wait around.
- * Return: first slot number
- */
-static u32 ccp_lsb_alloc(struct ccp_cmd_queue *cmd_q, unsigned int count)
-{
-	struct ccp_device *ccp;
-	int start;
-
-	/* First look at the map for the queue */
-	if (cmd_q->lsb >= 0) {
-		start = (u32)bitmap_find_next_zero_area(cmd_q->lsbmap,
-							LSB_SIZE,
-							0, count, 0);
-		if (start < LSB_SIZE) {
-			bitmap_set(cmd_q->lsbmap, start, count);
-			return start + cmd_q->lsb * LSB_SIZE;
-		}
-	}
-
-	/* No joy; try to get an entry from the shared blocks */
-	ccp = cmd_q->ccp;
-	for (;;) {
-		mutex_lock(&ccp->sb_mutex);
-
-		start = (u32)bitmap_find_next_zero_area(ccp->lsbmap,
-							MAX_LSB_CNT * LSB_SIZE,
-							0,
-							count, 0);
-		if (start <= MAX_LSB_CNT * LSB_SIZE) {
-			bitmap_set(ccp->lsbmap, start, count);
-
-			mutex_unlock(&ccp->sb_mutex);
-			return start;
-		}
-
-		ccp->sb_avail = 0;
-
-		mutex_unlock(&ccp->sb_mutex);
-
-		/* Wait for KSB entries to become available */
-		if (wait_event_interruptible(ccp->sb_queue, ccp->sb_avail))
-			return 0;
-	}
-}
-
-/* Free a number of LSB slots from the bitmap, starting at
- * the indicated starting slot number.
- */
-static void ccp_lsb_free(struct ccp_cmd_queue *cmd_q, unsigned int start,
-			 unsigned int count)
-{
-	if (!start)
-		return;
-
-	if (cmd_q->lsb == start) {
-		/* An entry from the private LSB */
-		bitmap_clear(cmd_q->lsbmap, start, count);
-	} else {
-		/* From the shared LSBs */
-		struct ccp_device *ccp = cmd_q->ccp;
-
-		mutex_lock(&ccp->sb_mutex);
-		bitmap_clear(ccp->lsbmap, start, count);
-		ccp->sb_avail = 1;
-		mutex_unlock(&ccp->sb_mutex);
-		wake_up_interruptible_all(&ccp->sb_queue);
-	}
-}
-
-/* CCP version 5: Union to define the function field (cmd_reg1/dword0) */
-union ccp_function {
-	struct {
-		u16 size:7;
-		u16 encrypt:1;
-		u16 mode:5;
-		u16 type:2;
-	} aes;
-	struct {
-		u16 size:7;
-		u16 encrypt:1;
-		u16 rsvd:5;
-		u16 type:2;
-	} aes_xts;
-	struct {
-		u16 rsvd1:10;
-		u16 type:4;
-		u16 rsvd2:1;
-	} sha;
-	struct {
-		u16 mode:3;
-		u16 size:12;
-	} rsa;
-	struct {
-		u16 byteswap:2;
-		u16 bitwise:3;
-		u16 reflect:2;
-		u16 rsvd:8;
-	} pt;
-	struct  {
-		u16 rsvd:13;
-	} zlib;
-	struct {
-		u16 size:10;
-		u16 type:2;
-		u16 mode:3;
-	} ecc;
-	u16 raw;
-};
-
-#define	CCP_AES_SIZE(p)		((p)->aes.size)
-#define	CCP_AES_ENCRYPT(p)	((p)->aes.encrypt)
-#define	CCP_AES_MODE(p)		((p)->aes.mode)
-#define	CCP_AES_TYPE(p)		((p)->aes.type)
-#define	CCP_XTS_SIZE(p)		((p)->aes_xts.size)
-#define	CCP_XTS_ENCRYPT(p)	((p)->aes_xts.encrypt)
-#define	CCP_SHA_TYPE(p)		((p)->sha.type)
-#define	CCP_RSA_SIZE(p)		((p)->rsa.size)
-#define	CCP_PT_BYTESWAP(p)	((p)->pt.byteswap)
-#define	CCP_PT_BITWISE(p)	((p)->pt.bitwise)
-#define	CCP_ECC_MODE(p)		((p)->ecc.mode)
-#define	CCP_ECC_AFFINE(p)	((p)->ecc.one)
-
-/* Word 0 */
-#define CCP5_CMD_DW0(p)		((p)->dw0)
-#define CCP5_CMD_SOC(p)		(CCP5_CMD_DW0(p).soc)
-#define CCP5_CMD_IOC(p)		(CCP5_CMD_DW0(p).ioc)
-#define CCP5_CMD_INIT(p)	(CCP5_CMD_DW0(p).init)
-#define CCP5_CMD_EOM(p)		(CCP5_CMD_DW0(p).eom)
-#define CCP5_CMD_FUNCTION(p)	(CCP5_CMD_DW0(p).function)
-#define CCP5_CMD_ENGINE(p)	(CCP5_CMD_DW0(p).engine)
-#define CCP5_CMD_PROT(p)	(CCP5_CMD_DW0(p).prot)
-
-/* Word 1 */
-#define CCP5_CMD_DW1(p)		((p)->length)
-#define CCP5_CMD_LEN(p)		(CCP5_CMD_DW1(p))
-
-/* Word 2 */
-#define CCP5_CMD_DW2(p)		((p)->src_lo)
-#define CCP5_CMD_SRC_LO(p)	(CCP5_CMD_DW2(p))
-
-/* Word 3 */
-#define CCP5_CMD_DW3(p)		((p)->dw3)
-#define CCP5_CMD_SRC_MEM(p)	((p)->dw3.src_mem)
-#define CCP5_CMD_SRC_HI(p)	((p)->dw3.src_hi)
-#define CCP5_CMD_LSB_ID(p)	((p)->dw3.lsb_cxt_id)
-#define CCP5_CMD_FIX_SRC(p)	((p)->dw3.fixed)
-
-/* Words 4/5 */
-#define CCP5_CMD_DW4(p)		((p)->dw4)
-#define CCP5_CMD_DST_LO(p)	(CCP5_CMD_DW4(p).dst_lo)
-#define CCP5_CMD_DW5(p)		((p)->dw5.fields.dst_hi)
-#define CCP5_CMD_DST_HI(p)	(CCP5_CMD_DW5(p))
-#define CCP5_CMD_DST_MEM(p)	((p)->dw5.fields.dst_mem)
-#define CCP5_CMD_FIX_DST(p)	((p)->dw5.fields.fixed)
-#define CCP5_CMD_SHA_LO(p)	((p)->dw4.sha_len_lo)
-#define CCP5_CMD_SHA_HI(p)	((p)->dw5.sha_len_hi)
-
-/* Word 6/7 */
-#define CCP5_CMD_DW6(p)		((p)->key_lo)
-#define CCP5_CMD_KEY_LO(p)	(CCP5_CMD_DW6(p))
-#define CCP5_CMD_DW7(p)		((p)->dw7)
-#define CCP5_CMD_KEY_HI(p)	((p)->dw7.key_hi)
-#define CCP5_CMD_KEY_MEM(p)	((p)->dw7.key_mem)
-
-static inline u32 low_address(unsigned long addr)
-{
-	return (u64)addr & 0x0ffffffff;
-}
-
-static inline u32 high_address(unsigned long addr)
-{
-	return ((u64)addr >> 32) & 0x00000ffff;
-}
-
-static unsigned int ccp5_get_free_slots(struct ccp_cmd_queue *cmd_q)
-{
-	unsigned int head_idx, n;
-	u32 head_lo, queue_start;
-
-	queue_start = low_address(cmd_q->qdma_tail);
-	head_lo = ioread32(cmd_q->reg_head_lo);
-	head_idx = (head_lo - queue_start) / sizeof(struct ccp5_desc);
-
-	n = head_idx + COMMANDS_PER_QUEUE - cmd_q->qidx - 1;
-
-	return n % COMMANDS_PER_QUEUE; /* Always one unused spot */
-}
-
-static int ccp5_do_cmd(struct ccp5_desc *desc,
-		       struct ccp_cmd_queue *cmd_q)
-{
-	u32 *mP;
-	__le32 *dP;
-	u32 tail;
-	int	i;
-	int ret = 0;
-
-	if (CCP5_CMD_SOC(desc)) {
-		CCP5_CMD_IOC(desc) = 1;
-		CCP5_CMD_SOC(desc) = 0;
-	}
-	mutex_lock(&cmd_q->q_mutex);
-
-	mP = (u32 *) &cmd_q->qbase[cmd_q->qidx];
-	dP = (__le32 *) desc;
-	for (i = 0; i < 8; i++)
-		mP[i] = cpu_to_le32(dP[i]); /* handle endianness */
-
-	cmd_q->qidx = (cmd_q->qidx + 1) % COMMANDS_PER_QUEUE;
-
-	/* The data used by this command must be flushed to memory */
-	wmb();
-
-	/* Write the new tail address back to the queue register */
-	tail = low_address(cmd_q->qdma_tail + cmd_q->qidx * Q_DESC_SIZE);
-	iowrite32(tail, cmd_q->reg_tail_lo);
-
-	/* Turn the queue back on using our cached control register */
-	iowrite32(cmd_q->qcontrol | CMD5_Q_RUN, cmd_q->reg_control);
-	mutex_unlock(&cmd_q->q_mutex);
-
-	if (CCP5_CMD_IOC(desc)) {
-		/* Wait for the job to complete */
-		ret = wait_event_interruptible(cmd_q->int_queue,
-					       cmd_q->int_rcvd);
-		if (ret || cmd_q->cmd_error) {
-			if (cmd_q->cmd_error)
-				ccp_log_error(cmd_q->ccp,
-					      cmd_q->cmd_error);
-			/* A version 5 device doesn't use Job IDs... */
-			if (!ret)
-				ret = -EIO;
-		}
-		cmd_q->int_rcvd = 0;
-	}
-
-	return 0;
-}
-
-static int ccp5_perform_aes(struct ccp_op *op)
-{
-	struct ccp5_desc desc;
-	union ccp_function function;
-	u32 key_addr = op->sb_key * LSB_ITEM_SIZE;
-
-	/* Zero out all the fields of the command desc */
-	memset(&desc, 0, Q_DESC_SIZE);
-
-	CCP5_CMD_ENGINE(&desc) = CCP_ENGINE_AES;
-
-	CCP5_CMD_SOC(&desc) = op->soc;
-	CCP5_CMD_IOC(&desc) = 1;
-	CCP5_CMD_INIT(&desc) = op->init;
-	CCP5_CMD_EOM(&desc) = op->eom;
-	CCP5_CMD_PROT(&desc) = 0;
-
-	function.raw = 0;
-	CCP_AES_ENCRYPT(&function) = op->u.aes.action;
-	CCP_AES_MODE(&function) = op->u.aes.mode;
-	CCP_AES_TYPE(&function) = op->u.aes.type;
-	if (op->u.aes.mode == CCP_AES_MODE_CFB)
-		CCP_AES_SIZE(&function) = 0x7f;
-
-	CCP5_CMD_FUNCTION(&desc) = function.raw;
-
-	CCP5_CMD_LEN(&desc) = op->src.u.dma.length;
-
-	CCP5_CMD_SRC_LO(&desc) = ccp_addr_lo(&op->src.u.dma);
-	CCP5_CMD_SRC_HI(&desc) = ccp_addr_hi(&op->src.u.dma);
-	CCP5_CMD_SRC_MEM(&desc) = CCP_MEMTYPE_SYSTEM;
-
-	CCP5_CMD_DST_LO(&desc) = ccp_addr_lo(&op->dst.u.dma);
-	CCP5_CMD_DST_HI(&desc) = ccp_addr_hi(&op->dst.u.dma);
-	CCP5_CMD_DST_MEM(&desc) = CCP_MEMTYPE_SYSTEM;
-
-	CCP5_CMD_KEY_LO(&desc) = lower_32_bits(key_addr);
-	CCP5_CMD_KEY_HI(&desc) = 0;
-	CCP5_CMD_KEY_MEM(&desc) = CCP_MEMTYPE_SB;
-	CCP5_CMD_LSB_ID(&desc) = op->sb_ctx;
-
-	return ccp5_do_cmd(&desc, op->cmd_q);
-}
-
-static int ccp5_perform_xts_aes(struct ccp_op *op)
-{
-	struct ccp5_desc desc;
-	union ccp_function function;
-	u32 key_addr = op->sb_key * LSB_ITEM_SIZE;
-
-	/* Zero out all the fields of the command desc */
-	memset(&desc, 0, Q_DESC_SIZE);
-
-	CCP5_CMD_ENGINE(&desc) = CCP_ENGINE_XTS_AES_128;
-
-	CCP5_CMD_SOC(&desc) = op->soc;
-	CCP5_CMD_IOC(&desc) = 1;
-	CCP5_CMD_INIT(&desc) = op->init;
-	CCP5_CMD_EOM(&desc) = op->eom;
-	CCP5_CMD_PROT(&desc) = 0;
-
-	function.raw = 0;
-	CCP_XTS_ENCRYPT(&function) = op->u.xts.action;
-	CCP_XTS_SIZE(&function) = op->u.xts.unit_size;
-	CCP5_CMD_FUNCTION(&desc) = function.raw;
-
-	CCP5_CMD_LEN(&desc) = op->src.u.dma.length;
-
-	CCP5_CMD_SRC_LO(&desc) = ccp_addr_lo(&op->src.u.dma);
-	CCP5_CMD_SRC_HI(&desc) = ccp_addr_hi(&op->src.u.dma);
-	CCP5_CMD_SRC_MEM(&desc) = CCP_MEMTYPE_SYSTEM;
-
-	CCP5_CMD_DST_LO(&desc) = ccp_addr_lo(&op->dst.u.dma);
-	CCP5_CMD_DST_HI(&desc) = ccp_addr_hi(&op->dst.u.dma);
-	CCP5_CMD_DST_MEM(&desc) = CCP_MEMTYPE_SYSTEM;
-
-	CCP5_CMD_KEY_LO(&desc) = lower_32_bits(key_addr);
-	CCP5_CMD_KEY_HI(&desc) =  0;
-	CCP5_CMD_KEY_MEM(&desc) = CCP_MEMTYPE_SB;
-	CCP5_CMD_LSB_ID(&desc) = op->sb_ctx;
-
-	return ccp5_do_cmd(&desc, op->cmd_q);
-}
-
-static int ccp5_perform_sha(struct ccp_op *op)
-{
-	struct ccp5_desc desc;
-	union ccp_function function;
-
-	/* Zero out all the fields of the command desc */
-	memset(&desc, 0, Q_DESC_SIZE);
-
-	CCP5_CMD_ENGINE(&desc) = CCP_ENGINE_SHA;
-
-	CCP5_CMD_SOC(&desc) = op->soc;
-	CCP5_CMD_IOC(&desc) = 1;
-	CCP5_CMD_INIT(&desc) = 1;
-	CCP5_CMD_EOM(&desc) = op->eom;
-	CCP5_CMD_PROT(&desc) = 0;
-
-	function.raw = 0;
-	CCP_SHA_TYPE(&function) = op->u.sha.type;
-	CCP5_CMD_FUNCTION(&desc) = function.raw;
-
-	CCP5_CMD_LEN(&desc) = op->src.u.dma.length;
-
-	CCP5_CMD_SRC_LO(&desc) = ccp_addr_lo(&op->src.u.dma);
-	CCP5_CMD_SRC_HI(&desc) = ccp_addr_hi(&op->src.u.dma);
-	CCP5_CMD_SRC_MEM(&desc) = CCP_MEMTYPE_SYSTEM;
-
-	CCP5_CMD_LSB_ID(&desc) = op->sb_ctx;
-
-	if (op->eom) {
-		CCP5_CMD_SHA_LO(&desc) = lower_32_bits(op->u.sha.msg_bits);
-		CCP5_CMD_SHA_HI(&desc) = upper_32_bits(op->u.sha.msg_bits);
-	} else {
-		CCP5_CMD_SHA_LO(&desc) = 0;
-		CCP5_CMD_SHA_HI(&desc) = 0;
-	}
-
-	return ccp5_do_cmd(&desc, op->cmd_q);
-}
-
-static int ccp5_perform_rsa(struct ccp_op *op)
-{
-	struct ccp5_desc desc;
-	union ccp_function function;
-
-	/* Zero out all the fields of the command desc */
-	memset(&desc, 0, Q_DESC_SIZE);
-
-	CCP5_CMD_ENGINE(&desc) = CCP_ENGINE_RSA;
-
-	CCP5_CMD_SOC(&desc) = op->soc;
-	CCP5_CMD_IOC(&desc) = 1;
-	CCP5_CMD_INIT(&desc) = 0;
-	CCP5_CMD_EOM(&desc) = 1;
-	CCP5_CMD_PROT(&desc) = 0;
-
-	function.raw = 0;
-	CCP_RSA_SIZE(&function) = op->u.rsa.mod_size >> 3;
-	CCP5_CMD_FUNCTION(&desc) = function.raw;
-
-	CCP5_CMD_LEN(&desc) = op->u.rsa.input_len;
-
-	/* Source is from external memory */
-	CCP5_CMD_SRC_LO(&desc) = ccp_addr_lo(&op->src.u.dma);
-	CCP5_CMD_SRC_HI(&desc) = ccp_addr_hi(&op->src.u.dma);
-	CCP5_CMD_SRC_MEM(&desc) = CCP_MEMTYPE_SYSTEM;
-
-	/* Destination is in external memory */
-	CCP5_CMD_DST_LO(&desc) = ccp_addr_lo(&op->dst.u.dma);
-	CCP5_CMD_DST_HI(&desc) = ccp_addr_hi(&op->dst.u.dma);
-	CCP5_CMD_DST_MEM(&desc) = CCP_MEMTYPE_SYSTEM;
-
-	/* Exponent is in LSB memory */
-	CCP5_CMD_KEY_LO(&desc) = op->sb_key * LSB_ITEM_SIZE;
-	CCP5_CMD_KEY_HI(&desc) = 0;
-	CCP5_CMD_KEY_MEM(&desc) = CCP_MEMTYPE_SB;
-
-	return ccp5_do_cmd(&desc, op->cmd_q);
-}
-
-static int ccp5_perform_passthru(struct ccp_op *op)
-{
-	struct ccp5_desc desc;
-	union ccp_function function;
-	struct ccp_dma_info *saddr = &op->src.u.dma;
-	struct ccp_dma_info *daddr = &op->dst.u.dma;
-
-	memset(&desc, 0, Q_DESC_SIZE);
-
-	CCP5_CMD_ENGINE(&desc) = CCP_ENGINE_PASSTHRU;
-
-	CCP5_CMD_SOC(&desc) = 0;
-	CCP5_CMD_IOC(&desc) = 1;
-	CCP5_CMD_INIT(&desc) = 0;
-	CCP5_CMD_EOM(&desc) = op->eom;
-	CCP5_CMD_PROT(&desc) = 0;
-
-	function.raw = 0;
-	CCP_PT_BYTESWAP(&function) = op->u.passthru.byte_swap;
-	CCP_PT_BITWISE(&function) = op->u.passthru.bit_mod;
-	CCP5_CMD_FUNCTION(&desc) = function.raw;
-
-	/* Length of source data is always 256 bytes */
-	if (op->src.type == CCP_MEMTYPE_SYSTEM)
-		CCP5_CMD_LEN(&desc) = saddr->length;
-	else
-		CCP5_CMD_LEN(&desc) = daddr->length;
-
-	if (op->src.type == CCP_MEMTYPE_SYSTEM) {
-		CCP5_CMD_SRC_LO(&desc) = ccp_addr_lo(&op->src.u.dma);
-		CCP5_CMD_SRC_HI(&desc) = ccp_addr_hi(&op->src.u.dma);
-		CCP5_CMD_SRC_MEM(&desc) = CCP_MEMTYPE_SYSTEM;
-
-		if (op->u.passthru.bit_mod != CCP_PASSTHRU_BITWISE_NOOP)
-			CCP5_CMD_LSB_ID(&desc) = op->sb_key;
-	} else {
-		u32 key_addr = op->src.u.sb * CCP_SB_BYTES;
-
-		CCP5_CMD_SRC_LO(&desc) = lower_32_bits(key_addr);
-		CCP5_CMD_SRC_HI(&desc) = 0;
-		CCP5_CMD_SRC_MEM(&desc) = CCP_MEMTYPE_SB;
-	}
-
-	if (op->dst.type == CCP_MEMTYPE_SYSTEM) {
-		CCP5_CMD_DST_LO(&desc) = ccp_addr_lo(&op->dst.u.dma);
-		CCP5_CMD_DST_HI(&desc) = ccp_addr_hi(&op->dst.u.dma);
-		CCP5_CMD_DST_MEM(&desc) = CCP_MEMTYPE_SYSTEM;
-	} else {
-		u32 key_addr = op->dst.u.sb * CCP_SB_BYTES;
-
-		CCP5_CMD_DST_LO(&desc) = lower_32_bits(key_addr);
-		CCP5_CMD_DST_HI(&desc) = 0;
-		CCP5_CMD_DST_MEM(&desc) = CCP_MEMTYPE_SB;
-	}
-
-	return ccp5_do_cmd(&desc, op->cmd_q);
-}
-
-static int ccp5_perform_ecc(struct ccp_op *op)
-{
-	struct ccp5_desc desc;
-	union ccp_function function;
-
-	/* Zero out all the fields of the command desc */
-	memset(&desc, 0, Q_DESC_SIZE);
-
-	CCP5_CMD_ENGINE(&desc) = CCP_ENGINE_ECC;
-
-	CCP5_CMD_SOC(&desc) = 0;
-	CCP5_CMD_IOC(&desc) = 1;
-	CCP5_CMD_INIT(&desc) = 0;
-	CCP5_CMD_EOM(&desc) = 1;
-	CCP5_CMD_PROT(&desc) = 0;
-
-	function.raw = 0;
-	function.ecc.mode = op->u.ecc.function;
-	CCP5_CMD_FUNCTION(&desc) = function.raw;
-
-	CCP5_CMD_LEN(&desc) = op->src.u.dma.length;
-
-	CCP5_CMD_SRC_LO(&desc) = ccp_addr_lo(&op->src.u.dma);
-	CCP5_CMD_SRC_HI(&desc) = ccp_addr_hi(&op->src.u.dma);
-	CCP5_CMD_SRC_MEM(&desc) = CCP_MEMTYPE_SYSTEM;
-
-	CCP5_CMD_DST_LO(&desc) = ccp_addr_lo(&op->dst.u.dma);
-	CCP5_CMD_DST_HI(&desc) = ccp_addr_hi(&op->dst.u.dma);
-	CCP5_CMD_DST_MEM(&desc) = CCP_MEMTYPE_SYSTEM;
-
-	return ccp5_do_cmd(&desc, op->cmd_q);
-}
-
-static int ccp_find_lsb_regions(struct ccp_cmd_queue *cmd_q, u64 status)
-{
-	int q_mask = 1 << cmd_q->id;
-	int queues = 0;
-	int j;
-
-	/* Build a bit mask to know which LSBs this queue has access to.
-	 * Don't bother with segment 0 as it has special privileges.
-	 */
-	for (j = 1; j < MAX_LSB_CNT; j++) {
-		if (status & q_mask)
-			bitmap_set(cmd_q->lsbmask, j, 1);
-		status >>= LSB_REGION_WIDTH;
-	}
-	queues = bitmap_weight(cmd_q->lsbmask, MAX_LSB_CNT);
-	dev_info(cmd_q->ccp->dev, "Queue %d can access %d LSB regions\n",
-		 cmd_q->id, queues);
-
-	return queues ? 0 : -EINVAL;
-}
-
-
-static int ccp_find_and_assign_lsb_to_q(struct ccp_device *ccp,
-					int lsb_cnt, int n_lsbs,
-					unsigned long *lsb_pub)
-{
-	DECLARE_BITMAP(qlsb, MAX_LSB_CNT);
-	int bitno;
-	int qlsb_wgt;
-	int i;
-
-	/* For each queue:
-	 * If the count of potential LSBs available to a queue matches the
-	 * ordinal given to us in lsb_cnt:
-	 * Copy the mask of possible LSBs for this queue into "qlsb";
-	 * For each bit in qlsb, see if the corresponding bit in the
-	 * aggregation mask is set; if so, we have a match.
-	 *     If we have a match, clear the bit in the aggregation to
-	 *     mark it as no longer available.
-	 *     If there is no match, clear the bit in qlsb and keep looking.
-	 */
-	for (i = 0; i < ccp->cmd_q_count; i++) {
-		struct ccp_cmd_queue *cmd_q = &ccp->cmd_q[i];
-
-		qlsb_wgt = bitmap_weight(cmd_q->lsbmask, MAX_LSB_CNT);
-
-		if (qlsb_wgt == lsb_cnt) {
-			bitmap_copy(qlsb, cmd_q->lsbmask, MAX_LSB_CNT);
-
-			bitno = find_first_bit(qlsb, MAX_LSB_CNT);
-			while (bitno < MAX_LSB_CNT) {
-				if (test_bit(bitno, lsb_pub)) {
-					/* We found an available LSB
-					 * that this queue can access
-					 */
-					cmd_q->lsb = bitno;
-					bitmap_clear(lsb_pub, bitno, 1);
-					dev_info(ccp->dev,
-						 "Queue %d gets LSB %d\n",
-						 i, bitno);
-					break;
-				}
-				bitmap_clear(qlsb, bitno, 1);
-				bitno = find_first_bit(qlsb, MAX_LSB_CNT);
-			}
-			if (bitno >= MAX_LSB_CNT)
-				return -EINVAL;
-			n_lsbs--;
-		}
-	}
-	return n_lsbs;
-}
-
-/* For each queue, from the most- to least-constrained:
- * find an LSB that can be assigned to the queue. If there are N queues that
- * can only use M LSBs, where N > M, fail; otherwise, every queue will get a
- * dedicated LSB. Remaining LSB regions become a shared resource.
- * If we have fewer LSBs than queues, all LSB regions become shared resources.
- */
-static int ccp_assign_lsbs(struct ccp_device *ccp)
-{
-	DECLARE_BITMAP(lsb_pub, MAX_LSB_CNT);
-	DECLARE_BITMAP(qlsb, MAX_LSB_CNT);
-	int n_lsbs = 0;
-	int bitno;
-	int i, lsb_cnt;
-	int rc = 0;
-
-	bitmap_zero(lsb_pub, MAX_LSB_CNT);
-
-	/* Create an aggregate bitmap to get a total count of available LSBs */
-	for (i = 0; i < ccp->cmd_q_count; i++)
-		bitmap_or(lsb_pub,
-			  lsb_pub, ccp->cmd_q[i].lsbmask,
-			  MAX_LSB_CNT);
-
-	n_lsbs = bitmap_weight(lsb_pub, MAX_LSB_CNT);
-
-	if (n_lsbs >= ccp->cmd_q_count) {
-		/* We have enough LSBS to give every queue a private LSB.
-		 * Brute force search to start with the queues that are more
-		 * constrained in LSB choice. When an LSB is privately
-		 * assigned, it is removed from the public mask.
-		 * This is an ugly N squared algorithm with some optimization.
-		 */
-		for (lsb_cnt = 1;
-		     n_lsbs && (lsb_cnt <= MAX_LSB_CNT);
-		     lsb_cnt++) {
-			rc = ccp_find_and_assign_lsb_to_q(ccp, lsb_cnt, n_lsbs,
-							  lsb_pub);
-			if (rc < 0)
-				return -EINVAL;
-			n_lsbs = rc;
-		}
-	}
-
-	rc = 0;
-	/* What's left of the LSBs, according to the public mask, now become
-	 * shared. Any zero bits in the lsb_pub mask represent an LSB region
-	 * that can't be used as a shared resource, so mark the LSB slots for
-	 * them as "in use".
-	 */
-	bitmap_copy(qlsb, lsb_pub, MAX_LSB_CNT);
-
-	bitno = find_first_zero_bit(qlsb, MAX_LSB_CNT);
-	while (bitno < MAX_LSB_CNT) {
-		bitmap_set(ccp->lsbmap, bitno * LSB_SIZE, LSB_SIZE);
-		bitmap_set(qlsb, bitno, 1);
-		bitno = find_first_zero_bit(qlsb, MAX_LSB_CNT);
-	}
-
-	return rc;
-}
-
-static int ccp5_init(struct ccp_device *ccp)
-{
-	struct device *dev = ccp->dev;
-	struct ccp_cmd_queue *cmd_q;
-	struct dma_pool *dma_pool;
-	char dma_pool_name[MAX_DMAPOOL_NAME_LEN];
-	unsigned int qmr, qim, i;
-	u64 status;
-	u32 status_lo, status_hi;
-	int ret;
-
-	/* Find available queues */
-	qim = 0;
-	qmr = ioread32(ccp->io_regs + Q_MASK_REG);
-	for (i = 0; i < MAX_HW_QUEUES; i++) {
-
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
-		}
-
-		cmd_q = &ccp->cmd_q[ccp->cmd_q_count];
-		ccp->cmd_q_count++;
-
-		cmd_q->ccp = ccp;
-		cmd_q->id = i;
-		cmd_q->dma_pool = dma_pool;
-		mutex_init(&cmd_q->q_mutex);
-
-		/* Page alignment satisfies our needs for N <= 128 */
-		BUILD_BUG_ON(COMMANDS_PER_QUEUE > 128);
-		cmd_q->qsize = Q_SIZE(Q_DESC_SIZE);
-		cmd_q->qbase = dma_zalloc_coherent(dev, cmd_q->qsize,
-						   &cmd_q->qbase_dma,
-						   GFP_KERNEL);
-		if (!cmd_q->qbase) {
-			dev_err(dev, "unable to allocate command queue\n");
-			ret = -ENOMEM;
-			goto e_pool;
-		}
-
-		cmd_q->qidx = 0;
-		/* Preset some register values and masks that are queue
-		 * number dependent
-		 */
-		cmd_q->reg_control = ccp->io_regs +
-				     CMD5_Q_STATUS_INCR * (i + 1);
-		cmd_q->reg_tail_lo = cmd_q->reg_control + CMD5_Q_TAIL_LO_BASE;
-		cmd_q->reg_head_lo = cmd_q->reg_control + CMD5_Q_HEAD_LO_BASE;
-		cmd_q->reg_int_enable = cmd_q->reg_control +
-					CMD5_Q_INT_ENABLE_BASE;
-		cmd_q->reg_interrupt_status = cmd_q->reg_control +
-					      CMD5_Q_INTERRUPT_STATUS_BASE;
-		cmd_q->reg_status = cmd_q->reg_control + CMD5_Q_STATUS_BASE;
-		cmd_q->reg_int_status = cmd_q->reg_control +
-					CMD5_Q_INT_STATUS_BASE;
-		cmd_q->reg_dma_status = cmd_q->reg_control +
-					CMD5_Q_DMA_STATUS_BASE;
-		cmd_q->reg_dma_read_status = cmd_q->reg_control +
-					     CMD5_Q_DMA_READ_STATUS_BASE;
-		cmd_q->reg_dma_write_status = cmd_q->reg_control +
-					      CMD5_Q_DMA_WRITE_STATUS_BASE;
-
-		init_waitqueue_head(&cmd_q->int_queue);
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
-	/* Turn off the queues and disable interrupts until ready */
-	for (i = 0; i < ccp->cmd_q_count; i++) {
-		cmd_q = &ccp->cmd_q[i];
-
-		cmd_q->qcontrol = 0; /* Start with nothing */
-		iowrite32(cmd_q->qcontrol, cmd_q->reg_control);
-
-		/* Disable the interrupts */
-		iowrite32(0x00, cmd_q->reg_int_enable);
-		ioread32(cmd_q->reg_int_status);
-		ioread32(cmd_q->reg_status);
-
-		/* Clear the interrupts */
-		iowrite32(ALL_INTERRUPTS, cmd_q->reg_interrupt_status);
-	}
-
-	dev_dbg(dev, "Requesting an IRQ...\n");
-	/* Request an irq */
-	ret = ccp->get_irq(ccp);
-	if (ret) {
-		dev_err(dev, "unable to allocate an IRQ\n");
-		goto e_pool;
-	}
-
-	dev_dbg(dev, "Loading LSB map...\n");
-	/* Copy the private LSB mask to the public registers */
-	status_lo = ioread32(ccp->io_regs + LSB_PRIVATE_MASK_LO_OFFSET);
-	status_hi = ioread32(ccp->io_regs + LSB_PRIVATE_MASK_HI_OFFSET);
-	iowrite32(status_lo, ccp->io_regs + LSB_PUBLIC_MASK_LO_OFFSET);
-	iowrite32(status_hi, ccp->io_regs + LSB_PUBLIC_MASK_HI_OFFSET);
-	status = ((u64)status_hi<<30) | (u64)status_lo;
-
-	dev_dbg(dev, "Configuring virtual queues...\n");
-	/* Configure size of each virtual queue accessible to host */
-	for (i = 0; i < ccp->cmd_q_count; i++) {
-		u32 dma_addr_lo;
-		u32 dma_addr_hi;
-
-		cmd_q = &ccp->cmd_q[i];
-
-		cmd_q->qcontrol &= ~(CMD5_Q_SIZE << CMD5_Q_SHIFT);
-		cmd_q->qcontrol |= QUEUE_SIZE_VAL << CMD5_Q_SHIFT;
-
-		cmd_q->qdma_tail = cmd_q->qbase_dma;
-		dma_addr_lo = low_address(cmd_q->qdma_tail);
-		iowrite32((u32)dma_addr_lo, cmd_q->reg_tail_lo);
-		iowrite32((u32)dma_addr_lo, cmd_q->reg_head_lo);
-
-		dma_addr_hi = high_address(cmd_q->qdma_tail);
-		cmd_q->qcontrol |= (dma_addr_hi << 16);
-		iowrite32(cmd_q->qcontrol, cmd_q->reg_control);
-
-		/* Find the LSB regions accessible to the queue */
-		ccp_find_lsb_regions(cmd_q, status);
-		cmd_q->lsb = -1; /* Unassigned value */
-	}
-
-	dev_dbg(dev, "Assigning LSBs...\n");
-	ret = ccp_assign_lsbs(ccp);
-	if (ret) {
-		dev_err(dev, "Unable to assign LSBs (%d)\n", ret);
-		goto e_irq;
-	}
-
-	/* Optimization: pre-allocate LSB slots for each queue */
-	for (i = 0; i < ccp->cmd_q_count; i++) {
-		ccp->cmd_q[i].sb_key = ccp_lsb_alloc(&ccp->cmd_q[i], 2);
-		ccp->cmd_q[i].sb_ctx = ccp_lsb_alloc(&ccp->cmd_q[i], 2);
-	}
-
-	dev_dbg(dev, "Starting threads...\n");
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
-	dev_dbg(dev, "Enabling interrupts...\n");
-	/* Enable interrupts */
-	for (i = 0; i < ccp->cmd_q_count; i++) {
-		cmd_q = &ccp->cmd_q[i];
-		iowrite32(ALL_INTERRUPTS, cmd_q->reg_int_enable);
-	}
-
-	dev_dbg(dev, "Registering device...\n");
-	/* Put this on the unit list to make it available */
-	ccp_add_device(ccp);
-
-	ret = ccp_register_rng(ccp);
-	if (ret)
-		goto e_kthread;
-
-	/* Register the DMA engine support */
-	ret = ccp_dmaengine_register(ccp);
-	if (ret)
-		goto e_hwrng;
-
-	return 0;
-
-e_hwrng:
-	ccp_unregister_rng(ccp);
-
-e_kthread:
-	for (i = 0; i < ccp->cmd_q_count; i++)
-		if (ccp->cmd_q[i].kthread)
-			kthread_stop(ccp->cmd_q[i].kthread);
-
-e_irq:
-	ccp->free_irq(ccp);
-
-e_pool:
-	for (i = 0; i < ccp->cmd_q_count; i++)
-		dma_pool_destroy(ccp->cmd_q[i].dma_pool);
-
-	return ret;
-}
-
-static void ccp5_destroy(struct ccp_device *ccp)
-{
-	struct device *dev = ccp->dev;
-	struct ccp_cmd_queue *cmd_q;
-	struct ccp_cmd *cmd;
-	unsigned int i;
-
-	/* Unregister the DMA engine */
-	ccp_dmaengine_unregister(ccp);
-
-	/* Unregister the RNG */
-	ccp_unregister_rng(ccp);
-
-	/* Remove this device from the list of available units first */
-	ccp_del_device(ccp);
-
-	/* Disable and clear interrupts */
-	for (i = 0; i < ccp->cmd_q_count; i++) {
-		cmd_q = &ccp->cmd_q[i];
-
-		/* Turn off the run bit */
-		iowrite32(cmd_q->qcontrol & ~CMD5_Q_RUN, cmd_q->reg_control);
-
-		/* Disable the interrupts */
-		iowrite32(ALL_INTERRUPTS, cmd_q->reg_interrupt_status);
-
-		/* Clear the interrupt status */
-		iowrite32(0x00, cmd_q->reg_int_enable);
-		ioread32(cmd_q->reg_int_status);
-		ioread32(cmd_q->reg_status);
-	}
-
-	/* Stop the queue kthreads */
-	for (i = 0; i < ccp->cmd_q_count; i++)
-		if (ccp->cmd_q[i].kthread)
-			kthread_stop(ccp->cmd_q[i].kthread);
-
-	ccp->free_irq(ccp);
-
-	for (i = 0; i < ccp->cmd_q_count; i++) {
-		cmd_q = &ccp->cmd_q[i];
-		dma_free_coherent(dev, cmd_q->qsize, cmd_q->qbase,
-				  cmd_q->qbase_dma);
-	}
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
-static irqreturn_t ccp5_irq_handler(int irq, void *data)
-{
-	struct device *dev = data;
-	struct ccp_device *ccp = dev_get_drvdata(dev);
-	u32 status;
-	unsigned int i;
-
-	for (i = 0; i < ccp->cmd_q_count; i++) {
-		struct ccp_cmd_queue *cmd_q = &ccp->cmd_q[i];
-
-		status = ioread32(cmd_q->reg_interrupt_status);
-
-		if (status) {
-			cmd_q->int_status = status;
-			cmd_q->q_status = ioread32(cmd_q->reg_status);
-			cmd_q->q_int_status = ioread32(cmd_q->reg_int_status);
-
-			/* On error, only save the first error value */
-			if ((status & INT_ERROR) && !cmd_q->cmd_error)
-				cmd_q->cmd_error = CMD_Q_ERROR(cmd_q->q_status);
-
-			cmd_q->int_rcvd = 1;
-
-			/* Acknowledge the interrupt and wake the kthread */
-			iowrite32(ALL_INTERRUPTS, cmd_q->reg_interrupt_status);
-			wake_up_interruptible(&cmd_q->int_queue);
-		}
-	}
-
-	return IRQ_HANDLED;
-}
-
-static void ccp5_config(struct ccp_device *ccp)
-{
-	/* Public side */
-	iowrite32(0x00001249, ccp->io_regs + CMD5_REQID_CONFIG_OFFSET);
-}
-
-static void ccp5other_config(struct ccp_device *ccp)
-{
-	int i;
-	u32 rnd;
-
-	/* We own all of the queues on the NTB CCP */
-
-	iowrite32(0x00012D57, ccp->io_regs + CMD5_TRNG_CTL_OFFSET);
-	iowrite32(0x00000003, ccp->io_regs + CMD5_CONFIG_0_OFFSET);
-	for (i = 0; i < 12; i++) {
-		rnd = ioread32(ccp->io_regs + TRNG_OUT_REG);
-		iowrite32(rnd, ccp->io_regs + CMD5_AES_MASK_OFFSET);
-	}
-
-	iowrite32(0x0000001F, ccp->io_regs + CMD5_QUEUE_MASK_OFFSET);
-	iowrite32(0x00005B6D, ccp->io_regs + CMD5_QUEUE_PRIO_OFFSET);
-	iowrite32(0x00000000, ccp->io_regs + CMD5_CMD_TIMEOUT_OFFSET);
-
-	iowrite32(0x3FFFFFFF, ccp->io_regs + LSB_PRIVATE_MASK_LO_OFFSET);
-	iowrite32(0x000003FF, ccp->io_regs + LSB_PRIVATE_MASK_HI_OFFSET);
-
-	iowrite32(0x00108823, ccp->io_regs + CMD5_CLK_GATE_CTL_OFFSET);
-
-	ccp5_config(ccp);
-}
-
-/* Version 5 adds some function, but is essentially the same as v5 */
-static const struct ccp_actions ccp5_actions = {
-	.aes = ccp5_perform_aes,
-	.xts_aes = ccp5_perform_xts_aes,
-	.sha = ccp5_perform_sha,
-	.rsa = ccp5_perform_rsa,
-	.passthru = ccp5_perform_passthru,
-	.ecc = ccp5_perform_ecc,
-	.sballoc = ccp_lsb_alloc,
-	.sbfree = ccp_lsb_free,
-	.init = ccp5_init,
-	.destroy = ccp5_destroy,
-	.get_free_slots = ccp5_get_free_slots,
-	.irqhandler = ccp5_irq_handler,
-};
-
-const struct ccp_vdata ccpv5a = {
-	.version = CCP_VERSION(5, 0),
-	.setup = ccp5_config,
-	.perform = &ccp5_actions,
-	.bar = 2,
-	.offset = 0x0,
-};
-
-const struct ccp_vdata ccpv5b = {
-	.version = CCP_VERSION(5, 0),
-	.setup = ccp5other_config,
-	.perform = &ccp5_actions,
-	.bar = 2,
-	.offset = 0x0,
-};
diff --git a/drivers/crypto/ccp/ccp-dev.c b/drivers/crypto/ccp/ccp-dev.c
deleted file mode 100644
index 511ab04..0000000
--- a/drivers/crypto/ccp/ccp-dev.c
+++ /dev/null
@@ -1,588 +0,0 @@
-/*
- * AMD Cryptographic Coprocessor (CCP) driver
- *
- * Copyright (C) 2013,2016 Advanced Micro Devices, Inc.
- *
- * Author: Tom Lendacky <thomas.lendacky@amd.com>
- * Author: Gary R Hook <gary.hook@amd.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/kthread.h>
-#include <linux/sched.h>
-#include <linux/interrupt.h>
-#include <linux/spinlock.h>
-#include <linux/spinlock_types.h>
-#include <linux/types.h>
-#include <linux/mutex.h>
-#include <linux/delay.h>
-#include <linux/hw_random.h>
-#include <linux/cpu.h>
-#ifdef CONFIG_X86
-#include <asm/cpu_device_id.h>
-#endif
-#include <linux/ccp.h>
-
-#include "ccp-dev.h"
-
-MODULE_AUTHOR("Tom Lendacky <thomas.lendacky@amd.com>");
-MODULE_LICENSE("GPL");
-MODULE_VERSION("1.0.0");
-MODULE_DESCRIPTION("AMD Cryptographic Coprocessor driver");
-
-struct ccp_tasklet_data {
-	struct completion completion;
-	struct ccp_cmd *cmd;
-};
-
-/* Human-readable error strings */
-static char *ccp_error_codes[] = {
-	"",
-	"ERR 01: ILLEGAL_ENGINE",
-	"ERR 02: ILLEGAL_KEY_ID",
-	"ERR 03: ILLEGAL_FUNCTION_TYPE",
-	"ERR 04: ILLEGAL_FUNCTION_MODE",
-	"ERR 05: ILLEGAL_FUNCTION_ENCRYPT",
-	"ERR 06: ILLEGAL_FUNCTION_SIZE",
-	"ERR 07: Zlib_MISSING_INIT_EOM",
-	"ERR 08: ILLEGAL_FUNCTION_RSVD",
-	"ERR 09: ILLEGAL_BUFFER_LENGTH",
-	"ERR 10: VLSB_FAULT",
-	"ERR 11: ILLEGAL_MEM_ADDR",
-	"ERR 12: ILLEGAL_MEM_SEL",
-	"ERR 13: ILLEGAL_CONTEXT_ID",
-	"ERR 14: ILLEGAL_KEY_ADDR",
-	"ERR 15: 0xF Reserved",
-	"ERR 16: Zlib_ILLEGAL_MULTI_QUEUE",
-	"ERR 17: Zlib_ILLEGAL_JOBID_CHANGE",
-	"ERR 18: CMD_TIMEOUT",
-	"ERR 19: IDMA0_AXI_SLVERR",
-	"ERR 20: IDMA0_AXI_DECERR",
-	"ERR 21: 0x15 Reserved",
-	"ERR 22: IDMA1_AXI_SLAVE_FAULT",
-	"ERR 23: IDMA1_AIXI_DECERR",
-	"ERR 24: 0x18 Reserved",
-	"ERR 25: ZLIBVHB_AXI_SLVERR",
-	"ERR 26: ZLIBVHB_AXI_DECERR",
-	"ERR 27: 0x1B Reserved",
-	"ERR 27: ZLIB_UNEXPECTED_EOM",
-	"ERR 27: ZLIB_EXTRA_DATA",
-	"ERR 30: ZLIB_BTYPE",
-	"ERR 31: ZLIB_UNDEFINED_SYMBOL",
-	"ERR 32: ZLIB_UNDEFINED_DISTANCE_S",
-	"ERR 33: ZLIB_CODE_LENGTH_SYMBOL",
-	"ERR 34: ZLIB _VHB_ILLEGAL_FETCH",
-	"ERR 35: ZLIB_UNCOMPRESSED_LEN",
-	"ERR 36: ZLIB_LIMIT_REACHED",
-	"ERR 37: ZLIB_CHECKSUM_MISMATCH0",
-	"ERR 38: ODMA0_AXI_SLVERR",
-	"ERR 39: ODMA0_AXI_DECERR",
-	"ERR 40: 0x28 Reserved",
-	"ERR 41: ODMA1_AXI_SLVERR",
-	"ERR 42: ODMA1_AXI_DECERR",
-	"ERR 43: LSB_PARITY_ERR",
-};
-
-void ccp_log_error(struct ccp_device *d, int e)
-{
-	dev_err(d->dev, "CCP error: %s (0x%x)\n", ccp_error_codes[e], e);
-}
-
-/* List of CCPs, CCP count, read-write access lock, and access functions
- *
- * Lock structure: get ccp_unit_lock for reading whenever we need to
- * examine the CCP list. While holding it for reading we can acquire
- * the RR lock to update the round-robin next-CCP pointer. The unit lock
- * must be acquired before the RR lock.
- *
- * If the unit-lock is acquired for writing, we have total control over
- * the list, so there's no value in getting the RR lock.
- */
-static DEFINE_RWLOCK(ccp_unit_lock);
-static LIST_HEAD(ccp_units);
-
-/* Round-robin counter */
-static DEFINE_SPINLOCK(ccp_rr_lock);
-static struct ccp_device *ccp_rr;
-
-/* Ever-increasing value to produce unique unit numbers */
-static atomic_t ccp_unit_ordinal;
-static unsigned int ccp_increment_unit_ordinal(void)
-{
-	return atomic_inc_return(&ccp_unit_ordinal);
-}
-
-/**
- * ccp_add_device - add a CCP device to the list
- *
- * @ccp: ccp_device struct pointer
- *
- * Put this CCP on the unit list, which makes it available
- * for use.
- *
- * Returns zero if a CCP device is present, -ENODEV otherwise.
- */
-void ccp_add_device(struct ccp_device *ccp)
-{
-	unsigned long flags;
-
-	write_lock_irqsave(&ccp_unit_lock, flags);
-	list_add_tail(&ccp->entry, &ccp_units);
-	if (!ccp_rr)
-		/* We already have the list lock (we're first) so this
-		 * pointer can't change on us. Set its initial value.
-		 */
-		ccp_rr = ccp;
-	write_unlock_irqrestore(&ccp_unit_lock, flags);
-}
-
-/**
- * ccp_del_device - remove a CCP device from the list
- *
- * @ccp: ccp_device struct pointer
- *
- * Remove this unit from the list of devices. If the next device
- * up for use is this one, adjust the pointer. If this is the last
- * device, NULL the pointer.
- */
-void ccp_del_device(struct ccp_device *ccp)
-{
-	unsigned long flags;
-
-	write_lock_irqsave(&ccp_unit_lock, flags);
-	if (ccp_rr == ccp) {
-		/* ccp_unit_lock is read/write; any read access
-		 * will be suspended while we make changes to the
-		 * list and RR pointer.
-		 */
-		if (list_is_last(&ccp_rr->entry, &ccp_units))
-			ccp_rr = list_first_entry(&ccp_units, struct ccp_device,
-						  entry);
-		else
-			ccp_rr = list_next_entry(ccp_rr, entry);
-	}
-	list_del(&ccp->entry);
-	if (list_empty(&ccp_units))
-		ccp_rr = NULL;
-	write_unlock_irqrestore(&ccp_unit_lock, flags);
-}
-
-
-
-int ccp_register_rng(struct ccp_device *ccp)
-{
-	int ret = 0;
-
-	dev_dbg(ccp->dev, "Registering RNG...\n");
-	/* Register an RNG */
-	ccp->hwrng.name = ccp->rngname;
-	ccp->hwrng.read = ccp_trng_read;
-	ret = hwrng_register(&ccp->hwrng);
-	if (ret)
-		dev_err(ccp->dev, "error registering hwrng (%d)\n", ret);
-
-	return ret;
-}
-
-void ccp_unregister_rng(struct ccp_device *ccp)
-{
-	if (ccp->hwrng.name)
-		hwrng_unregister(&ccp->hwrng);
-}
-
-static struct ccp_device *ccp_get_device(void)
-{
-	unsigned long flags;
-	struct ccp_device *dp = NULL;
-
-	/* We round-robin through the unit list.
-	 * The (ccp_rr) pointer refers to the next unit to use.
-	 */
-	read_lock_irqsave(&ccp_unit_lock, flags);
-	if (!list_empty(&ccp_units)) {
-		spin_lock(&ccp_rr_lock);
-		dp = ccp_rr;
-		if (list_is_last(&ccp_rr->entry, &ccp_units))
-			ccp_rr = list_first_entry(&ccp_units, struct ccp_device,
-						  entry);
-		else
-			ccp_rr = list_next_entry(ccp_rr, entry);
-		spin_unlock(&ccp_rr_lock);
-	}
-	read_unlock_irqrestore(&ccp_unit_lock, flags);
-
-	return dp;
-}
-
-/**
- * ccp_present - check if a CCP device is present
- *
- * Returns zero if a CCP device is present, -ENODEV otherwise.
- */
-int ccp_present(void)
-{
-	unsigned long flags;
-	int ret;
-
-	read_lock_irqsave(&ccp_unit_lock, flags);
-	ret = list_empty(&ccp_units);
-	read_unlock_irqrestore(&ccp_unit_lock, flags);
-
-	return ret ? -ENODEV : 0;
-}
-EXPORT_SYMBOL_GPL(ccp_present);
-
-/**
- * ccp_version - get the version of the CCP device
- *
- * Returns the version from the first unit on the list;
- * otherwise a zero if no CCP device is present
- */
-unsigned int ccp_version(void)
-{
-	struct ccp_device *dp;
-	unsigned long flags;
-	int ret = 0;
-
-	read_lock_irqsave(&ccp_unit_lock, flags);
-	if (!list_empty(&ccp_units)) {
-		dp = list_first_entry(&ccp_units, struct ccp_device, entry);
-		ret = dp->vdata->version;
-	}
-	read_unlock_irqrestore(&ccp_unit_lock, flags);
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(ccp_version);
-
-/**
- * ccp_enqueue_cmd - queue an operation for processing by the CCP
- *
- * @cmd: ccp_cmd struct to be processed
- *
- * Queue a cmd to be processed by the CCP. If queueing the cmd
- * would exceed the defined length of the cmd queue the cmd will
- * only be queued if the CCP_CMD_MAY_BACKLOG flag is set and will
- * result in a return code of -EBUSY.
- *
- * The callback routine specified in the ccp_cmd struct will be
- * called to notify the caller of completion (if the cmd was not
- * backlogged) or advancement out of the backlog. If the cmd has
- * advanced out of the backlog the "err" value of the callback
- * will be -EINPROGRESS. Any other "err" value during callback is
- * the result of the operation.
- *
- * The cmd has been successfully queued if:
- *   the return code is -EINPROGRESS or
- *   the return code is -EBUSY and CCP_CMD_MAY_BACKLOG flag is set
- */
-int ccp_enqueue_cmd(struct ccp_cmd *cmd)
-{
-	struct ccp_device *ccp = ccp_get_device();
-	unsigned long flags;
-	unsigned int i;
-	int ret;
-
-	if (!ccp)
-		return -ENODEV;
-
-	/* Caller must supply a callback routine */
-	if (!cmd->callback)
-		return -EINVAL;
-
-	cmd->ccp = ccp;
-
-	spin_lock_irqsave(&ccp->cmd_lock, flags);
-
-	i = ccp->cmd_q_count;
-
-	if (ccp->cmd_count >= MAX_CMD_QLEN) {
-		ret = -EBUSY;
-		if (cmd->flags & CCP_CMD_MAY_BACKLOG)
-			list_add_tail(&cmd->entry, &ccp->backlog);
-	} else {
-		ret = -EINPROGRESS;
-		ccp->cmd_count++;
-		list_add_tail(&cmd->entry, &ccp->cmd);
-
-		/* Find an idle queue */
-		if (!ccp->suspending) {
-			for (i = 0; i < ccp->cmd_q_count; i++) {
-				if (ccp->cmd_q[i].active)
-					continue;
-
-				break;
-			}
-		}
-	}
-
-	spin_unlock_irqrestore(&ccp->cmd_lock, flags);
-
-	/* If we found an idle queue, wake it up */
-	if (i < ccp->cmd_q_count)
-		wake_up_process(ccp->cmd_q[i].kthread);
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(ccp_enqueue_cmd);
-
-static void ccp_do_cmd_backlog(struct work_struct *work)
-{
-	struct ccp_cmd *cmd = container_of(work, struct ccp_cmd, work);
-	struct ccp_device *ccp = cmd->ccp;
-	unsigned long flags;
-	unsigned int i;
-
-	cmd->callback(cmd->data, -EINPROGRESS);
-
-	spin_lock_irqsave(&ccp->cmd_lock, flags);
-
-	ccp->cmd_count++;
-	list_add_tail(&cmd->entry, &ccp->cmd);
-
-	/* Find an idle queue */
-	for (i = 0; i < ccp->cmd_q_count; i++) {
-		if (ccp->cmd_q[i].active)
-			continue;
-
-		break;
-	}
-
-	spin_unlock_irqrestore(&ccp->cmd_lock, flags);
-
-	/* If we found an idle queue, wake it up */
-	if (i < ccp->cmd_q_count)
-		wake_up_process(ccp->cmd_q[i].kthread);
-}
-
-static struct ccp_cmd *ccp_dequeue_cmd(struct ccp_cmd_queue *cmd_q)
-{
-	struct ccp_device *ccp = cmd_q->ccp;
-	struct ccp_cmd *cmd = NULL;
-	struct ccp_cmd *backlog = NULL;
-	unsigned long flags;
-
-	spin_lock_irqsave(&ccp->cmd_lock, flags);
-
-	cmd_q->active = 0;
-
-	if (ccp->suspending) {
-		cmd_q->suspended = 1;
-
-		spin_unlock_irqrestore(&ccp->cmd_lock, flags);
-		wake_up_interruptible(&ccp->suspend_queue);
-
-		return NULL;
-	}
-
-	if (ccp->cmd_count) {
-		cmd_q->active = 1;
-
-		cmd = list_first_entry(&ccp->cmd, struct ccp_cmd, entry);
-		list_del(&cmd->entry);
-
-		ccp->cmd_count--;
-	}
-
-	if (!list_empty(&ccp->backlog)) {
-		backlog = list_first_entry(&ccp->backlog, struct ccp_cmd,
-					   entry);
-		list_del(&backlog->entry);
-	}
-
-	spin_unlock_irqrestore(&ccp->cmd_lock, flags);
-
-	if (backlog) {
-		INIT_WORK(&backlog->work, ccp_do_cmd_backlog);
-		schedule_work(&backlog->work);
-	}
-
-	return cmd;
-}
-
-static void ccp_do_cmd_complete(unsigned long data)
-{
-	struct ccp_tasklet_data *tdata = (struct ccp_tasklet_data *)data;
-	struct ccp_cmd *cmd = tdata->cmd;
-
-	cmd->callback(cmd->data, cmd->ret);
-	complete(&tdata->completion);
-}
-
-/**
- * ccp_cmd_queue_thread - create a kernel thread to manage a CCP queue
- *
- * @data: thread-specific data
- */
-int ccp_cmd_queue_thread(void *data)
-{
-	struct ccp_cmd_queue *cmd_q = (struct ccp_cmd_queue *)data;
-	struct ccp_cmd *cmd;
-	struct ccp_tasklet_data tdata;
-	struct tasklet_struct tasklet;
-
-	tasklet_init(&tasklet, ccp_do_cmd_complete, (unsigned long)&tdata);
-
-	set_current_state(TASK_INTERRUPTIBLE);
-	while (!kthread_should_stop()) {
-		schedule();
-
-		set_current_state(TASK_INTERRUPTIBLE);
-
-		cmd = ccp_dequeue_cmd(cmd_q);
-		if (!cmd)
-			continue;
-
-		__set_current_state(TASK_RUNNING);
-
-		/* Execute the command */
-		cmd->ret = ccp_run_cmd(cmd_q, cmd);
-
-		/* Schedule the completion callback */
-		tdata.cmd = cmd;
-		init_completion(&tdata.completion);
-		tasklet_schedule(&tasklet);
-		wait_for_completion(&tdata.completion);
-	}
-
-	__set_current_state(TASK_RUNNING);
-
-	return 0;
-}
-
-/**
- * ccp_alloc_struct - allocate and initialize the ccp_device struct
- *
- * @dev: device struct of the CCP
- */
-struct ccp_device *ccp_alloc_struct(struct device *dev)
-{
-	struct ccp_device *ccp;
-
-	ccp = devm_kzalloc(dev, sizeof(*ccp), GFP_KERNEL);
-	if (!ccp)
-		return NULL;
-	ccp->dev = dev;
-
-	INIT_LIST_HEAD(&ccp->cmd);
-	INIT_LIST_HEAD(&ccp->backlog);
-
-	spin_lock_init(&ccp->cmd_lock);
-	mutex_init(&ccp->req_mutex);
-	mutex_init(&ccp->sb_mutex);
-	ccp->sb_count = KSB_COUNT;
-	ccp->sb_start = 0;
-
-	/* Initialize the wait queues */
-	init_waitqueue_head(&ccp->sb_queue);
-	init_waitqueue_head(&ccp->suspend_queue);
-
-	ccp->ord = ccp_increment_unit_ordinal();
-	snprintf(ccp->name, MAX_CCP_NAME_LEN, "ccp-%u", ccp->ord);
-	snprintf(ccp->rngname, MAX_CCP_NAME_LEN, "ccp-%u-rng", ccp->ord);
-
-	return ccp;
-}
-
-int ccp_trng_read(struct hwrng *rng, void *data, size_t max, bool wait)
-{
-	struct ccp_device *ccp = container_of(rng, struct ccp_device, hwrng);
-	u32 trng_value;
-	int len = min_t(int, sizeof(trng_value), max);
-
-	/* Locking is provided by the caller so we can update device
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
-#ifdef CONFIG_PM
-bool ccp_queues_suspended(struct ccp_device *ccp)
-{
-	unsigned int suspended = 0;
-	unsigned long flags;
-	unsigned int i;
-
-	spin_lock_irqsave(&ccp->cmd_lock, flags);
-
-	for (i = 0; i < ccp->cmd_q_count; i++)
-		if (ccp->cmd_q[i].suspended)
-			suspended++;
-
-	spin_unlock_irqrestore(&ccp->cmd_lock, flags);
-
-	return ccp->cmd_q_count == suspended;
-}
-#endif
-
-static int __init ccp_mod_init(void)
-{
-#ifdef CONFIG_X86
-	int ret;
-
-	ret = ccp_pci_init();
-	if (ret)
-		return ret;
-
-	/* Don't leave the driver loaded if init failed */
-	if (ccp_present() != 0) {
-		ccp_pci_exit();
-		return -ENODEV;
-	}
-
-	return 0;
-#endif
-
-#ifdef CONFIG_ARM64
-	int ret;
-
-	ret = ccp_platform_init();
-	if (ret)
-		return ret;
-
-	/* Don't leave the driver loaded if init failed */
-	if (ccp_present() != 0) {
-		ccp_platform_exit();
-		return -ENODEV;
-	}
-
-	return 0;
-#endif
-
-	return -ENODEV;
-}
-
-static void __exit ccp_mod_exit(void)
-{
-#ifdef CONFIG_X86
-	ccp_pci_exit();
-#endif
-
-#ifdef CONFIG_ARM64
-	ccp_platform_exit();
-#endif
-}
-
-module_init(ccp_mod_init);
-module_exit(ccp_mod_exit);
diff --git a/drivers/crypto/ccp/ccp-dev.h b/drivers/crypto/ccp/ccp-dev.h
deleted file mode 100644
index 830f35e..0000000
--- a/drivers/crypto/ccp/ccp-dev.h
+++ /dev/null
@@ -1,647 +0,0 @@
-/*
- * AMD Cryptographic Coprocessor (CCP) driver
- *
- * Copyright (C) 2013,2016 Advanced Micro Devices, Inc.
- *
- * Author: Tom Lendacky <thomas.lendacky@amd.com>
- * Author: Gary R Hook <gary.hook@amd.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#ifndef __CCP_DEV_H__
-#define __CCP_DEV_H__
-
-#include <linux/device.h>
-#include <linux/pci.h>
-#include <linux/spinlock.h>
-#include <linux/mutex.h>
-#include <linux/list.h>
-#include <linux/wait.h>
-#include <linux/dmapool.h>
-#include <linux/hw_random.h>
-#include <linux/bitops.h>
-#include <linux/interrupt.h>
-#include <linux/irqreturn.h>
-#include <linux/dmaengine.h>
-
-#define MAX_CCP_NAME_LEN		16
-#define MAX_DMAPOOL_NAME_LEN		32
-
-#define MAX_HW_QUEUES			5
-#define MAX_CMD_QLEN			100
-
-#define TRNG_RETRIES			10
-
-#define CACHE_NONE			0x00
-#define CACHE_WB_NO_ALLOC		0xb7
-
-/****** Register Mappings ******/
-#define Q_MASK_REG			0x000
-#define TRNG_OUT_REG			0x00c
-#define IRQ_MASK_REG			0x040
-#define IRQ_STATUS_REG			0x200
-
-#define DEL_CMD_Q_JOB			0x124
-#define DEL_Q_ACTIVE			0x00000200
-#define DEL_Q_ID_SHIFT			6
-
-#define CMD_REQ0			0x180
-#define CMD_REQ_INCR			0x04
-
-#define CMD_Q_STATUS_BASE		0x210
-#define CMD_Q_INT_STATUS_BASE		0x214
-#define CMD_Q_STATUS_INCR		0x20
-
-#define CMD_Q_CACHE_BASE		0x228
-#define CMD_Q_CACHE_INC			0x20
-
-#define CMD_Q_ERROR(__qs)		((__qs) & 0x0000003f)
-#define CMD_Q_DEPTH(__qs)		(((__qs) >> 12) & 0x0000000f)
-
-/* ------------------------ CCP Version 5 Specifics ------------------------ */
-#define CMD5_QUEUE_MASK_OFFSET		0x00
-#define	CMD5_QUEUE_PRIO_OFFSET		0x04
-#define CMD5_REQID_CONFIG_OFFSET	0x08
-#define	CMD5_CMD_TIMEOUT_OFFSET		0x10
-#define LSB_PUBLIC_MASK_LO_OFFSET	0x18
-#define LSB_PUBLIC_MASK_HI_OFFSET	0x1C
-#define LSB_PRIVATE_MASK_LO_OFFSET	0x20
-#define LSB_PRIVATE_MASK_HI_OFFSET	0x24
-
-#define CMD5_Q_CONTROL_BASE		0x0000
-#define CMD5_Q_TAIL_LO_BASE		0x0004
-#define CMD5_Q_HEAD_LO_BASE		0x0008
-#define CMD5_Q_INT_ENABLE_BASE		0x000C
-#define CMD5_Q_INTERRUPT_STATUS_BASE	0x0010
-
-#define CMD5_Q_STATUS_BASE		0x0100
-#define CMD5_Q_INT_STATUS_BASE		0x0104
-#define CMD5_Q_DMA_STATUS_BASE		0x0108
-#define CMD5_Q_DMA_READ_STATUS_BASE	0x010C
-#define CMD5_Q_DMA_WRITE_STATUS_BASE	0x0110
-#define CMD5_Q_ABORT_BASE		0x0114
-#define CMD5_Q_AX_CACHE_BASE		0x0118
-
-#define	CMD5_CONFIG_0_OFFSET		0x6000
-#define	CMD5_TRNG_CTL_OFFSET		0x6008
-#define	CMD5_AES_MASK_OFFSET		0x6010
-#define	CMD5_CLK_GATE_CTL_OFFSET	0x603C
-
-/* Address offset between two virtual queue registers */
-#define CMD5_Q_STATUS_INCR		0x1000
-
-/* Bit masks */
-#define CMD5_Q_RUN			0x1
-#define CMD5_Q_HALT			0x2
-#define CMD5_Q_MEM_LOCATION		0x4
-#define CMD5_Q_SIZE			0x1F
-#define CMD5_Q_SHIFT			3
-#define COMMANDS_PER_QUEUE		16
-#define QUEUE_SIZE_VAL			((ffs(COMMANDS_PER_QUEUE) - 2) & \
-					  CMD5_Q_SIZE)
-#define Q_PTR_MASK			(2 << (QUEUE_SIZE_VAL + 5) - 1)
-#define Q_DESC_SIZE			sizeof(struct ccp5_desc)
-#define Q_SIZE(n)			(COMMANDS_PER_QUEUE*(n))
-
-#define INT_COMPLETION			0x1
-#define INT_ERROR			0x2
-#define INT_QUEUE_STOPPED		0x4
-#define ALL_INTERRUPTS			(INT_COMPLETION| \
-					 INT_ERROR| \
-					 INT_QUEUE_STOPPED)
-
-#define LSB_REGION_WIDTH		5
-#define MAX_LSB_CNT			8
-
-#define LSB_SIZE			16
-#define LSB_ITEM_SIZE			32
-#define PLSB_MAP_SIZE			(LSB_SIZE)
-#define SLSB_MAP_SIZE			(MAX_LSB_CNT * LSB_SIZE)
-
-#define LSB_ENTRY_NUMBER(LSB_ADDR)	(LSB_ADDR / LSB_ITEM_SIZE)
-
-/* ------------------------ CCP Version 3 Specifics ------------------------ */
-#define REQ0_WAIT_FOR_WRITE		0x00000004
-#define REQ0_INT_ON_COMPLETE		0x00000002
-#define REQ0_STOP_ON_COMPLETE		0x00000001
-
-#define REQ0_CMD_Q_SHIFT		9
-#define REQ0_JOBID_SHIFT		3
-
-/****** REQ1 Related Values ******/
-#define REQ1_PROTECT_SHIFT		27
-#define REQ1_ENGINE_SHIFT		23
-#define REQ1_KEY_KSB_SHIFT		2
-
-#define REQ1_EOM			0x00000002
-#define REQ1_INIT			0x00000001
-
-/* AES Related Values */
-#define REQ1_AES_TYPE_SHIFT		21
-#define REQ1_AES_MODE_SHIFT		18
-#define REQ1_AES_ACTION_SHIFT		17
-#define REQ1_AES_CFB_SIZE_SHIFT		10
-
-/* XTS-AES Related Values */
-#define REQ1_XTS_AES_SIZE_SHIFT		10
-
-/* SHA Related Values */
-#define REQ1_SHA_TYPE_SHIFT		21
-
-/* RSA Related Values */
-#define REQ1_RSA_MOD_SIZE_SHIFT		10
-
-/* Pass-Through Related Values */
-#define REQ1_PT_BW_SHIFT		12
-#define REQ1_PT_BS_SHIFT		10
-
-/* ECC Related Values */
-#define REQ1_ECC_AFFINE_CONVERT		0x00200000
-#define REQ1_ECC_FUNCTION_SHIFT		18
-
-/****** REQ4 Related Values ******/
-#define REQ4_KSB_SHIFT			18
-#define REQ4_MEMTYPE_SHIFT		16
-
-/****** REQ6 Related Values ******/
-#define REQ6_MEMTYPE_SHIFT		16
-
-/****** Key Storage Block ******/
-#define KSB_START			77
-#define KSB_END				127
-#define KSB_COUNT			(KSB_END - KSB_START + 1)
-#define CCP_SB_BITS			256
-
-#define CCP_JOBID_MASK			0x0000003f
-
-/* ------------------------ General CCP Defines ------------------------ */
-
-#define CCP_DMAPOOL_MAX_SIZE		64
-#define CCP_DMAPOOL_ALIGN		BIT(5)
-
-#define CCP_REVERSE_BUF_SIZE		64
-
-#define CCP_AES_KEY_SB_COUNT		1
-#define CCP_AES_CTX_SB_COUNT		1
-
-#define CCP_XTS_AES_KEY_SB_COUNT	1
-#define CCP_XTS_AES_CTX_SB_COUNT	1
-
-#define CCP_SHA_SB_COUNT		1
-
-#define CCP_RSA_MAX_WIDTH		4096
-
-#define CCP_PASSTHRU_BLOCKSIZE		256
-#define CCP_PASSTHRU_MASKSIZE		32
-#define CCP_PASSTHRU_SB_COUNT		1
-
-#define CCP_ECC_MODULUS_BYTES		48      /* 384-bits */
-#define CCP_ECC_MAX_OPERANDS		6
-#define CCP_ECC_MAX_OUTPUTS		3
-#define CCP_ECC_SRC_BUF_SIZE		448
-#define CCP_ECC_DST_BUF_SIZE		192
-#define CCP_ECC_OPERAND_SIZE		64
-#define CCP_ECC_OUTPUT_SIZE		64
-#define CCP_ECC_RESULT_OFFSET		60
-#define CCP_ECC_RESULT_SUCCESS		0x0001
-
-#define CCP_SB_BYTES			32
-
-struct ccp_op;
-struct ccp_device;
-struct ccp_cmd;
-struct ccp_fns;
-
-struct ccp_dma_cmd {
-	struct list_head entry;
-
-	struct ccp_cmd ccp_cmd;
-};
-
-struct ccp_dma_desc {
-	struct list_head entry;
-
-	struct ccp_device *ccp;
-
-	struct list_head pending;
-	struct list_head active;
-
-	enum dma_status status;
-	struct dma_async_tx_descriptor tx_desc;
-	size_t len;
-};
-
-struct ccp_dma_chan {
-	struct ccp_device *ccp;
-
-	spinlock_t lock;
-	struct list_head pending;
-	struct list_head active;
-	struct list_head complete;
-
-	struct tasklet_struct cleanup_tasklet;
-
-	enum dma_status status;
-	struct dma_chan dma_chan;
-};
-
-struct ccp_cmd_queue {
-	struct ccp_device *ccp;
-
-	/* Queue identifier */
-	u32 id;
-
-	/* Queue dma pool */
-	struct dma_pool *dma_pool;
-
-	/* Queue base address (not neccessarily aligned)*/
-	struct ccp5_desc *qbase;
-
-	/* Aligned queue start address (per requirement) */
-	struct mutex q_mutex ____cacheline_aligned;
-	unsigned int qidx;
-
-	/* Version 5 has different requirements for queue memory */
-	unsigned int qsize;
-	dma_addr_t qbase_dma;
-	dma_addr_t qdma_tail;
-
-	/* Per-queue reserved storage block(s) */
-	u32 sb_key;
-	u32 sb_ctx;
-
-	/* Bitmap of LSBs that can be accessed by this queue */
-	DECLARE_BITMAP(lsbmask, MAX_LSB_CNT);
-	/* Private LSB that is assigned to this queue, or -1 if none.
-	 * Bitmap for my private LSB, unused otherwise
-	 */
-	int lsb;
-	DECLARE_BITMAP(lsbmap, PLSB_MAP_SIZE);
-
-	/* Queue processing thread */
-	struct task_struct *kthread;
-	unsigned int active;
-	unsigned int suspended;
-
-	/* Number of free command slots available */
-	unsigned int free_slots;
-
-	/* Interrupt masks */
-	u32 int_ok;
-	u32 int_err;
-
-	/* Register addresses for queue */
-	void __iomem *reg_control;
-	void __iomem *reg_tail_lo;
-	void __iomem *reg_head_lo;
-	void __iomem *reg_int_enable;
-	void __iomem *reg_interrupt_status;
-	void __iomem *reg_status;
-	void __iomem *reg_int_status;
-	void __iomem *reg_dma_status;
-	void __iomem *reg_dma_read_status;
-	void __iomem *reg_dma_write_status;
-	u32 qcontrol; /* Cached control register */
-
-	/* Status values from job */
-	u32 int_status;
-	u32 q_status;
-	u32 q_int_status;
-	u32 cmd_error;
-
-	/* Interrupt wait queue */
-	wait_queue_head_t int_queue;
-	unsigned int int_rcvd;
-} ____cacheline_aligned;
-
-struct ccp_device {
-	struct list_head entry;
-
-	struct ccp_vdata *vdata;
-	unsigned int ord;
-	char name[MAX_CCP_NAME_LEN];
-	char rngname[MAX_CCP_NAME_LEN];
-
-	struct device *dev;
-
-	/* Bus specific device information
-	 */
-	void *dev_specific;
-	int (*get_irq)(struct ccp_device *ccp);
-	void (*free_irq)(struct ccp_device *ccp);
-	unsigned int irq;
-
-	/* I/O area used for device communication. The register mapping
-	 * starts at an offset into the mapped bar.
-	 *   The CMD_REQx registers and the Delete_Cmd_Queue_Job register
-	 *   need to be protected while a command queue thread is accessing
-	 *   them.
-	 */
-	struct mutex req_mutex ____cacheline_aligned;
-	void __iomem *io_map;
-	void __iomem *io_regs;
-
-	/* Master lists that all cmds are queued on. Because there can be
-	 * more than one CCP command queue that can process a cmd a separate
-	 * backlog list is neeeded so that the backlog completion call
-	 * completes before the cmd is available for execution.
-	 */
-	spinlock_t cmd_lock ____cacheline_aligned;
-	unsigned int cmd_count;
-	struct list_head cmd;
-	struct list_head backlog;
-
-	/* The command queues. These represent the queues available on the
-	 * CCP that are available for processing cmds
-	 */
-	struct ccp_cmd_queue cmd_q[MAX_HW_QUEUES];
-	unsigned int cmd_q_count;
-
-	/* Support for the CCP True RNG
-	 */
-	struct hwrng hwrng;
-	unsigned int hwrng_retries;
-
-	/* Support for the CCP DMA capabilities
-	 */
-	struct dma_device dma_dev;
-	struct ccp_dma_chan *ccp_dma_chan;
-	struct kmem_cache *dma_cmd_cache;
-	struct kmem_cache *dma_desc_cache;
-
-	/* A counter used to generate job-ids for cmds submitted to the CCP
-	 */
-	atomic_t current_id ____cacheline_aligned;
-
-	/* The v3 CCP uses key storage blocks (SB) to maintain context for
-	 * certain operations. To prevent multiple cmds from using the same
-	 * SB range a command queue reserves an SB range for the duration of
-	 * the cmd. Each queue, will however, reserve 2 SB blocks for
-	 * operations that only require single SB entries (eg. AES context/iv
-	 * and key) in order to avoid allocation contention.  This will reserve
-	 * at most 10 SB entries, leaving 40 SB entries available for dynamic
-	 * allocation.
-	 *
-	 * The v5 CCP Local Storage Block (LSB) is broken up into 8
-	 * memrory ranges, each of which can be enabled for access by one
-	 * or more queues. Device initialization takes this into account,
-	 * and attempts to assign one region for exclusive use by each
-	 * available queue; the rest are then aggregated as "public" use.
-	 * If there are fewer regions than queues, all regions are shared
-	 * amongst all queues.
-	 */
-	struct mutex sb_mutex ____cacheline_aligned;
-	DECLARE_BITMAP(sb, KSB_COUNT);
-	wait_queue_head_t sb_queue;
-	unsigned int sb_avail;
-	unsigned int sb_count;
-	u32 sb_start;
-
-	/* Bitmap of shared LSBs, if any */
-	DECLARE_BITMAP(lsbmap, SLSB_MAP_SIZE);
-
-	/* Suspend support */
-	unsigned int suspending;
-	wait_queue_head_t suspend_queue;
-
-	/* DMA caching attribute support */
-	unsigned int axcache;
-};
-
-enum ccp_memtype {
-	CCP_MEMTYPE_SYSTEM = 0,
-	CCP_MEMTYPE_SB,
-	CCP_MEMTYPE_LOCAL,
-	CCP_MEMTYPE__LAST,
-};
-#define	CCP_MEMTYPE_LSB	CCP_MEMTYPE_KSB
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
-		u32 sb;
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
-	u32 sb_key;
-	u32 sb_ctx;
-	u32 init;
-	u32 eom;
-
-	struct ccp_mem src;
-	struct ccp_mem dst;
-	struct ccp_mem exp;
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
-static inline u32 ccp_addr_lo(struct ccp_dma_info *info)
-{
-	return lower_32_bits(info->address + info->offset);
-}
-
-static inline u32 ccp_addr_hi(struct ccp_dma_info *info)
-{
-	return upper_32_bits(info->address + info->offset) & 0x0000ffff;
-}
-
-/**
- * descriptor for version 5 CPP commands
- * 8 32-bit words:
- * word 0: function; engine; control bits
- * word 1: length of source data
- * word 2: low 32 bits of source pointer
- * word 3: upper 16 bits of source pointer; source memory type
- * word 4: low 32 bits of destination pointer
- * word 5: upper 16 bits of destination pointer; destination memory type
- * word 6: low 32 bits of key pointer
- * word 7: upper 16 bits of key pointer; key memory type
- */
-struct dword0 {
-	unsigned int soc:1;
-	unsigned int ioc:1;
-	unsigned int rsvd1:1;
-	unsigned int init:1;
-	unsigned int eom:1;		/* AES/SHA only */
-	unsigned int function:15;
-	unsigned int engine:4;
-	unsigned int prot:1;
-	unsigned int rsvd2:7;
-};
-
-struct dword3 {
-	unsigned int  src_hi:16;
-	unsigned int  src_mem:2;
-	unsigned int  lsb_cxt_id:8;
-	unsigned int  rsvd1:5;
-	unsigned int  fixed:1;
-};
-
-union dword4 {
-	__le32 dst_lo;		/* NON-SHA	*/
-	__le32 sha_len_lo;	/* SHA		*/
-};
-
-union dword5 {
-	struct {
-		unsigned int  dst_hi:16;
-		unsigned int  dst_mem:2;
-		unsigned int  rsvd1:13;
-		unsigned int  fixed:1;
-	} fields;
-	__le32 sha_len_hi;
-};
-
-struct dword7 {
-	unsigned int  key_hi:16;
-	unsigned int  key_mem:2;
-	unsigned int  rsvd1:14;
-};
-
-struct ccp5_desc {
-	struct dword0 dw0;
-	__le32 length;
-	__le32 src_lo;
-	struct dword3 dw3;
-	union dword4 dw4;
-	union dword5 dw5;
-	__le32 key_lo;
-	struct dword7 dw7;
-};
-
-int ccp_pci_init(void);
-void ccp_pci_exit(void);
-
-int ccp_platform_init(void);
-void ccp_platform_exit(void);
-
-void ccp_add_device(struct ccp_device *ccp);
-void ccp_del_device(struct ccp_device *ccp);
-
-extern void ccp_log_error(struct ccp_device *, int);
-
-struct ccp_device *ccp_alloc_struct(struct device *dev);
-bool ccp_queues_suspended(struct ccp_device *ccp);
-int ccp_cmd_queue_thread(void *data);
-int ccp_trng_read(struct hwrng *rng, void *data, size_t max, bool wait);
-
-int ccp_run_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd);
-
-int ccp_register_rng(struct ccp_device *ccp);
-void ccp_unregister_rng(struct ccp_device *ccp);
-int ccp_dmaengine_register(struct ccp_device *ccp);
-void ccp_dmaengine_unregister(struct ccp_device *ccp);
-
-/* Structure for computation functions that are device-specific */
-struct ccp_actions {
-	int (*aes)(struct ccp_op *);
-	int (*xts_aes)(struct ccp_op *);
-	int (*sha)(struct ccp_op *);
-	int (*rsa)(struct ccp_op *);
-	int (*passthru)(struct ccp_op *);
-	int (*ecc)(struct ccp_op *);
-	u32 (*sballoc)(struct ccp_cmd_queue *, unsigned int);
-	void (*sbfree)(struct ccp_cmd_queue *, unsigned int,
-			       unsigned int);
-	unsigned int (*get_free_slots)(struct ccp_cmd_queue *);
-	int (*init)(struct ccp_device *);
-	void (*destroy)(struct ccp_device *);
-	irqreturn_t (*irqhandler)(int, void *);
-};
-
-/* Structure to hold CCP version-specific values */
-struct ccp_vdata {
-	const unsigned int version;
-	void (*setup)(struct ccp_device *);
-	const struct ccp_actions *perform;
-	const unsigned int bar;
-	const unsigned int offset;
-};
-
-extern const struct ccp_vdata ccpv3;
-extern const struct ccp_vdata ccpv5a;
-extern const struct ccp_vdata ccpv5b;
-
-#endif
diff --git a/drivers/crypto/ccp/ccp-dmaengine.c b/drivers/crypto/ccp/ccp-dmaengine.c
deleted file mode 100644
index 6553912..0000000
--- a/drivers/crypto/ccp/ccp-dmaengine.c
+++ /dev/null
@@ -1,728 +0,0 @@
-/*
- * AMD Cryptographic Coprocessor (CCP) driver
- *
- * Copyright (C) 2016 Advanced Micro Devices, Inc.
- *
- * Author: Gary R Hook <gary.hook@amd.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/kernel.h>
-#include <linux/dmaengine.h>
-#include <linux/spinlock.h>
-#include <linux/mutex.h>
-#include <linux/ccp.h>
-
-#include "ccp-dev.h"
-#include "../../dma/dmaengine.h"
-
-#define CCP_DMA_WIDTH(_mask)		\
-({					\
-	u64 mask = _mask + 1;		\
-	(mask == 0) ? 64 : fls64(mask);	\
-})
-
-static void ccp_free_cmd_resources(struct ccp_device *ccp,
-				   struct list_head *list)
-{
-	struct ccp_dma_cmd *cmd, *ctmp;
-
-	list_for_each_entry_safe(cmd, ctmp, list, entry) {
-		list_del(&cmd->entry);
-		kmem_cache_free(ccp->dma_cmd_cache, cmd);
-	}
-}
-
-static void ccp_free_desc_resources(struct ccp_device *ccp,
-				    struct list_head *list)
-{
-	struct ccp_dma_desc *desc, *dtmp;
-
-	list_for_each_entry_safe(desc, dtmp, list, entry) {
-		ccp_free_cmd_resources(ccp, &desc->active);
-		ccp_free_cmd_resources(ccp, &desc->pending);
-
-		list_del(&desc->entry);
-		kmem_cache_free(ccp->dma_desc_cache, desc);
-	}
-}
-
-static void ccp_free_chan_resources(struct dma_chan *dma_chan)
-{
-	struct ccp_dma_chan *chan = container_of(dma_chan, struct ccp_dma_chan,
-						 dma_chan);
-	unsigned long flags;
-
-	dev_dbg(chan->ccp->dev, "%s - chan=%p\n", __func__, chan);
-
-	spin_lock_irqsave(&chan->lock, flags);
-
-	ccp_free_desc_resources(chan->ccp, &chan->complete);
-	ccp_free_desc_resources(chan->ccp, &chan->active);
-	ccp_free_desc_resources(chan->ccp, &chan->pending);
-
-	spin_unlock_irqrestore(&chan->lock, flags);
-}
-
-static void ccp_cleanup_desc_resources(struct ccp_device *ccp,
-				       struct list_head *list)
-{
-	struct ccp_dma_desc *desc, *dtmp;
-
-	list_for_each_entry_safe_reverse(desc, dtmp, list, entry) {
-		if (!async_tx_test_ack(&desc->tx_desc))
-			continue;
-
-		dev_dbg(ccp->dev, "%s - desc=%p\n", __func__, desc);
-
-		ccp_free_cmd_resources(ccp, &desc->active);
-		ccp_free_cmd_resources(ccp, &desc->pending);
-
-		list_del(&desc->entry);
-		kmem_cache_free(ccp->dma_desc_cache, desc);
-	}
-}
-
-static void ccp_do_cleanup(unsigned long data)
-{
-	struct ccp_dma_chan *chan = (struct ccp_dma_chan *)data;
-	unsigned long flags;
-
-	dev_dbg(chan->ccp->dev, "%s - chan=%s\n", __func__,
-		dma_chan_name(&chan->dma_chan));
-
-	spin_lock_irqsave(&chan->lock, flags);
-
-	ccp_cleanup_desc_resources(chan->ccp, &chan->complete);
-
-	spin_unlock_irqrestore(&chan->lock, flags);
-}
-
-static int ccp_issue_next_cmd(struct ccp_dma_desc *desc)
-{
-	struct ccp_dma_cmd *cmd;
-	int ret;
-
-	cmd = list_first_entry(&desc->pending, struct ccp_dma_cmd, entry);
-	list_move(&cmd->entry, &desc->active);
-
-	dev_dbg(desc->ccp->dev, "%s - tx %d, cmd=%p\n", __func__,
-		desc->tx_desc.cookie, cmd);
-
-	ret = ccp_enqueue_cmd(&cmd->ccp_cmd);
-	if (!ret || (ret == -EINPROGRESS) || (ret == -EBUSY))
-		return 0;
-
-	dev_dbg(desc->ccp->dev, "%s - error: ret=%d, tx %d, cmd=%p\n", __func__,
-		ret, desc->tx_desc.cookie, cmd);
-
-	return ret;
-}
-
-static void ccp_free_active_cmd(struct ccp_dma_desc *desc)
-{
-	struct ccp_dma_cmd *cmd;
-
-	cmd = list_first_entry_or_null(&desc->active, struct ccp_dma_cmd,
-				       entry);
-	if (!cmd)
-		return;
-
-	dev_dbg(desc->ccp->dev, "%s - freeing tx %d cmd=%p\n",
-		__func__, desc->tx_desc.cookie, cmd);
-
-	list_del(&cmd->entry);
-	kmem_cache_free(desc->ccp->dma_cmd_cache, cmd);
-}
-
-static struct ccp_dma_desc *__ccp_next_dma_desc(struct ccp_dma_chan *chan,
-						struct ccp_dma_desc *desc)
-{
-	/* Move current DMA descriptor to the complete list */
-	if (desc)
-		list_move(&desc->entry, &chan->complete);
-
-	/* Get the next DMA descriptor on the active list */
-	desc = list_first_entry_or_null(&chan->active, struct ccp_dma_desc,
-					entry);
-
-	return desc;
-}
-
-static struct ccp_dma_desc *ccp_handle_active_desc(struct ccp_dma_chan *chan,
-						   struct ccp_dma_desc *desc)
-{
-	struct dma_async_tx_descriptor *tx_desc;
-	unsigned long flags;
-
-	/* Loop over descriptors until one is found with commands */
-	do {
-		if (desc) {
-			/* Remove the DMA command from the list and free it */
-			ccp_free_active_cmd(desc);
-
-			if (!list_empty(&desc->pending)) {
-				/* No errors, keep going */
-				if (desc->status != DMA_ERROR)
-					return desc;
-
-				/* Error, free remaining commands and move on */
-				ccp_free_cmd_resources(desc->ccp,
-						       &desc->pending);
-			}
-
-			tx_desc = &desc->tx_desc;
-		} else {
-			tx_desc = NULL;
-		}
-
-		spin_lock_irqsave(&chan->lock, flags);
-
-		if (desc) {
-			if (desc->status != DMA_ERROR)
-				desc->status = DMA_COMPLETE;
-
-			dev_dbg(desc->ccp->dev,
-				"%s - tx %d complete, status=%u\n", __func__,
-				desc->tx_desc.cookie, desc->status);
-
-			dma_cookie_complete(tx_desc);
-		}
-
-		desc = __ccp_next_dma_desc(chan, desc);
-
-		spin_unlock_irqrestore(&chan->lock, flags);
-
-		if (tx_desc) {
-			if (tx_desc->callback &&
-			    (tx_desc->flags & DMA_PREP_INTERRUPT))
-				tx_desc->callback(tx_desc->callback_param);
-
-			dma_run_dependencies(tx_desc);
-		}
-	} while (desc);
-
-	return NULL;
-}
-
-static struct ccp_dma_desc *__ccp_pending_to_active(struct ccp_dma_chan *chan)
-{
-	struct ccp_dma_desc *desc;
-
-	if (list_empty(&chan->pending))
-		return NULL;
-
-	desc = list_empty(&chan->active)
-		? list_first_entry(&chan->pending, struct ccp_dma_desc, entry)
-		: NULL;
-
-	list_splice_tail_init(&chan->pending, &chan->active);
-
-	return desc;
-}
-
-static void ccp_cmd_callback(void *data, int err)
-{
-	struct ccp_dma_desc *desc = data;
-	struct ccp_dma_chan *chan;
-	int ret;
-
-	if (err == -EINPROGRESS)
-		return;
-
-	chan = container_of(desc->tx_desc.chan, struct ccp_dma_chan,
-			    dma_chan);
-
-	dev_dbg(chan->ccp->dev, "%s - tx %d callback, err=%d\n",
-		__func__, desc->tx_desc.cookie, err);
-
-	if (err)
-		desc->status = DMA_ERROR;
-
-	while (true) {
-		/* Check for DMA descriptor completion */
-		desc = ccp_handle_active_desc(chan, desc);
-
-		/* Don't submit cmd if no descriptor or DMA is paused */
-		if (!desc || (chan->status == DMA_PAUSED))
-			break;
-
-		ret = ccp_issue_next_cmd(desc);
-		if (!ret)
-			break;
-
-		desc->status = DMA_ERROR;
-	}
-
-	tasklet_schedule(&chan->cleanup_tasklet);
-}
-
-static dma_cookie_t ccp_tx_submit(struct dma_async_tx_descriptor *tx_desc)
-{
-	struct ccp_dma_desc *desc = container_of(tx_desc, struct ccp_dma_desc,
-						 tx_desc);
-	struct ccp_dma_chan *chan;
-	dma_cookie_t cookie;
-	unsigned long flags;
-
-	chan = container_of(tx_desc->chan, struct ccp_dma_chan, dma_chan);
-
-	spin_lock_irqsave(&chan->lock, flags);
-
-	cookie = dma_cookie_assign(tx_desc);
-	list_add_tail(&desc->entry, &chan->pending);
-
-	spin_unlock_irqrestore(&chan->lock, flags);
-
-	dev_dbg(chan->ccp->dev, "%s - added tx descriptor %d to pending list\n",
-		__func__, cookie);
-
-	return cookie;
-}
-
-static struct ccp_dma_cmd *ccp_alloc_dma_cmd(struct ccp_dma_chan *chan)
-{
-	struct ccp_dma_cmd *cmd;
-
-	cmd = kmem_cache_alloc(chan->ccp->dma_cmd_cache, GFP_NOWAIT);
-	if (cmd)
-		memset(cmd, 0, sizeof(*cmd));
-
-	return cmd;
-}
-
-static struct ccp_dma_desc *ccp_alloc_dma_desc(struct ccp_dma_chan *chan,
-					       unsigned long flags)
-{
-	struct ccp_dma_desc *desc;
-
-	desc = kmem_cache_zalloc(chan->ccp->dma_desc_cache, GFP_NOWAIT);
-	if (!desc)
-		return NULL;
-
-	dma_async_tx_descriptor_init(&desc->tx_desc, &chan->dma_chan);
-	desc->tx_desc.flags = flags;
-	desc->tx_desc.tx_submit = ccp_tx_submit;
-	desc->ccp = chan->ccp;
-	INIT_LIST_HEAD(&desc->pending);
-	INIT_LIST_HEAD(&desc->active);
-	desc->status = DMA_IN_PROGRESS;
-
-	return desc;
-}
-
-static struct ccp_dma_desc *ccp_create_desc(struct dma_chan *dma_chan,
-					    struct scatterlist *dst_sg,
-					    unsigned int dst_nents,
-					    struct scatterlist *src_sg,
-					    unsigned int src_nents,
-					    unsigned long flags)
-{
-	struct ccp_dma_chan *chan = container_of(dma_chan, struct ccp_dma_chan,
-						 dma_chan);
-	struct ccp_device *ccp = chan->ccp;
-	struct ccp_dma_desc *desc;
-	struct ccp_dma_cmd *cmd;
-	struct ccp_cmd *ccp_cmd;
-	struct ccp_passthru_nomap_engine *ccp_pt;
-	unsigned int src_offset, src_len;
-	unsigned int dst_offset, dst_len;
-	unsigned int len;
-	unsigned long sflags;
-	size_t total_len;
-
-	if (!dst_sg || !src_sg)
-		return NULL;
-
-	if (!dst_nents || !src_nents)
-		return NULL;
-
-	desc = ccp_alloc_dma_desc(chan, flags);
-	if (!desc)
-		return NULL;
-
-	total_len = 0;
-
-	src_len = sg_dma_len(src_sg);
-	src_offset = 0;
-
-	dst_len = sg_dma_len(dst_sg);
-	dst_offset = 0;
-
-	while (true) {
-		if (!src_len) {
-			src_nents--;
-			if (!src_nents)
-				break;
-
-			src_sg = sg_next(src_sg);
-			if (!src_sg)
-				break;
-
-			src_len = sg_dma_len(src_sg);
-			src_offset = 0;
-			continue;
-		}
-
-		if (!dst_len) {
-			dst_nents--;
-			if (!dst_nents)
-				break;
-
-			dst_sg = sg_next(dst_sg);
-			if (!dst_sg)
-				break;
-
-			dst_len = sg_dma_len(dst_sg);
-			dst_offset = 0;
-			continue;
-		}
-
-		len = min(dst_len, src_len);
-
-		cmd = ccp_alloc_dma_cmd(chan);
-		if (!cmd)
-			goto err;
-
-		ccp_cmd = &cmd->ccp_cmd;
-		ccp_pt = &ccp_cmd->u.passthru_nomap;
-		ccp_cmd->flags = CCP_CMD_MAY_BACKLOG;
-		ccp_cmd->flags |= CCP_CMD_PASSTHRU_NO_DMA_MAP;
-		ccp_cmd->engine = CCP_ENGINE_PASSTHRU;
-		ccp_pt->bit_mod = CCP_PASSTHRU_BITWISE_NOOP;
-		ccp_pt->byte_swap = CCP_PASSTHRU_BYTESWAP_NOOP;
-		ccp_pt->src_dma = sg_dma_address(src_sg) + src_offset;
-		ccp_pt->dst_dma = sg_dma_address(dst_sg) + dst_offset;
-		ccp_pt->src_len = len;
-		ccp_pt->final = 1;
-		ccp_cmd->callback = ccp_cmd_callback;
-		ccp_cmd->data = desc;
-
-		list_add_tail(&cmd->entry, &desc->pending);
-
-		dev_dbg(ccp->dev,
-			"%s - cmd=%p, src=%pad, dst=%pad, len=%llu\n", __func__,
-			cmd, &ccp_pt->src_dma,
-			&ccp_pt->dst_dma, ccp_pt->src_len);
-
-		total_len += len;
-
-		src_len -= len;
-		src_offset += len;
-
-		dst_len -= len;
-		dst_offset += len;
-	}
-
-	desc->len = total_len;
-
-	if (list_empty(&desc->pending))
-		goto err;
-
-	dev_dbg(ccp->dev, "%s - desc=%p\n", __func__, desc);
-
-	spin_lock_irqsave(&chan->lock, sflags);
-
-	list_add_tail(&desc->entry, &chan->pending);
-
-	spin_unlock_irqrestore(&chan->lock, sflags);
-
-	return desc;
-
-err:
-	ccp_free_cmd_resources(ccp, &desc->pending);
-	kmem_cache_free(ccp->dma_desc_cache, desc);
-
-	return NULL;
-}
-
-static struct dma_async_tx_descriptor *ccp_prep_dma_memcpy(
-	struct dma_chan *dma_chan, dma_addr_t dst, dma_addr_t src, size_t len,
-	unsigned long flags)
-{
-	struct ccp_dma_chan *chan = container_of(dma_chan, struct ccp_dma_chan,
-						 dma_chan);
-	struct ccp_dma_desc *desc;
-	struct scatterlist dst_sg, src_sg;
-
-	dev_dbg(chan->ccp->dev,
-		"%s - src=%pad, dst=%pad, len=%zu, flags=%#lx\n",
-		__func__, &src, &dst, len, flags);
-
-	sg_init_table(&dst_sg, 1);
-	sg_dma_address(&dst_sg) = dst;
-	sg_dma_len(&dst_sg) = len;
-
-	sg_init_table(&src_sg, 1);
-	sg_dma_address(&src_sg) = src;
-	sg_dma_len(&src_sg) = len;
-
-	desc = ccp_create_desc(dma_chan, &dst_sg, 1, &src_sg, 1, flags);
-	if (!desc)
-		return NULL;
-
-	return &desc->tx_desc;
-}
-
-static struct dma_async_tx_descriptor *ccp_prep_dma_sg(
-	struct dma_chan *dma_chan, struct scatterlist *dst_sg,
-	unsigned int dst_nents, struct scatterlist *src_sg,
-	unsigned int src_nents, unsigned long flags)
-{
-	struct ccp_dma_chan *chan = container_of(dma_chan, struct ccp_dma_chan,
-						 dma_chan);
-	struct ccp_dma_desc *desc;
-
-	dev_dbg(chan->ccp->dev,
-		"%s - src=%p, src_nents=%u dst=%p, dst_nents=%u, flags=%#lx\n",
-		__func__, src_sg, src_nents, dst_sg, dst_nents, flags);
-
-	desc = ccp_create_desc(dma_chan, dst_sg, dst_nents, src_sg, src_nents,
-			       flags);
-	if (!desc)
-		return NULL;
-
-	return &desc->tx_desc;
-}
-
-static struct dma_async_tx_descriptor *ccp_prep_dma_interrupt(
-	struct dma_chan *dma_chan, unsigned long flags)
-{
-	struct ccp_dma_chan *chan = container_of(dma_chan, struct ccp_dma_chan,
-						 dma_chan);
-	struct ccp_dma_desc *desc;
-
-	desc = ccp_alloc_dma_desc(chan, flags);
-	if (!desc)
-		return NULL;
-
-	return &desc->tx_desc;
-}
-
-static void ccp_issue_pending(struct dma_chan *dma_chan)
-{
-	struct ccp_dma_chan *chan = container_of(dma_chan, struct ccp_dma_chan,
-						 dma_chan);
-	struct ccp_dma_desc *desc;
-	unsigned long flags;
-
-	dev_dbg(chan->ccp->dev, "%s\n", __func__);
-
-	spin_lock_irqsave(&chan->lock, flags);
-
-	desc = __ccp_pending_to_active(chan);
-
-	spin_unlock_irqrestore(&chan->lock, flags);
-
-	/* If there was nothing active, start processing */
-	if (desc)
-		ccp_cmd_callback(desc, 0);
-}
-
-static enum dma_status ccp_tx_status(struct dma_chan *dma_chan,
-				     dma_cookie_t cookie,
-				     struct dma_tx_state *state)
-{
-	struct ccp_dma_chan *chan = container_of(dma_chan, struct ccp_dma_chan,
-						 dma_chan);
-	struct ccp_dma_desc *desc;
-	enum dma_status ret;
-	unsigned long flags;
-
-	if (chan->status == DMA_PAUSED) {
-		ret = DMA_PAUSED;
-		goto out;
-	}
-
-	ret = dma_cookie_status(dma_chan, cookie, state);
-	if (ret == DMA_COMPLETE) {
-		spin_lock_irqsave(&chan->lock, flags);
-
-		/* Get status from complete chain, if still there */
-		list_for_each_entry(desc, &chan->complete, entry) {
-			if (desc->tx_desc.cookie != cookie)
-				continue;
-
-			ret = desc->status;
-			break;
-		}
-
-		spin_unlock_irqrestore(&chan->lock, flags);
-	}
-
-out:
-	dev_dbg(chan->ccp->dev, "%s - %u\n", __func__, ret);
-
-	return ret;
-}
-
-static int ccp_pause(struct dma_chan *dma_chan)
-{
-	struct ccp_dma_chan *chan = container_of(dma_chan, struct ccp_dma_chan,
-						 dma_chan);
-
-	chan->status = DMA_PAUSED;
-
-	/*TODO: Wait for active DMA to complete before returning? */
-
-	return 0;
-}
-
-static int ccp_resume(struct dma_chan *dma_chan)
-{
-	struct ccp_dma_chan *chan = container_of(dma_chan, struct ccp_dma_chan,
-						 dma_chan);
-	struct ccp_dma_desc *desc;
-	unsigned long flags;
-
-	spin_lock_irqsave(&chan->lock, flags);
-
-	desc = list_first_entry_or_null(&chan->active, struct ccp_dma_desc,
-					entry);
-
-	spin_unlock_irqrestore(&chan->lock, flags);
-
-	/* Indicate the channel is running again */
-	chan->status = DMA_IN_PROGRESS;
-
-	/* If there was something active, re-start */
-	if (desc)
-		ccp_cmd_callback(desc, 0);
-
-	return 0;
-}
-
-static int ccp_terminate_all(struct dma_chan *dma_chan)
-{
-	struct ccp_dma_chan *chan = container_of(dma_chan, struct ccp_dma_chan,
-						 dma_chan);
-	unsigned long flags;
-
-	dev_dbg(chan->ccp->dev, "%s\n", __func__);
-
-	/*TODO: Wait for active DMA to complete before continuing */
-
-	spin_lock_irqsave(&chan->lock, flags);
-
-	/*TODO: Purge the complete list? */
-	ccp_free_desc_resources(chan->ccp, &chan->active);
-	ccp_free_desc_resources(chan->ccp, &chan->pending);
-
-	spin_unlock_irqrestore(&chan->lock, flags);
-
-	return 0;
-}
-
-int ccp_dmaengine_register(struct ccp_device *ccp)
-{
-	struct ccp_dma_chan *chan;
-	struct dma_device *dma_dev = &ccp->dma_dev;
-	struct dma_chan *dma_chan;
-	char *dma_cmd_cache_name;
-	char *dma_desc_cache_name;
-	unsigned int i;
-	int ret;
-
-	ccp->ccp_dma_chan = devm_kcalloc(ccp->dev, ccp->cmd_q_count,
-					 sizeof(*(ccp->ccp_dma_chan)),
-					 GFP_KERNEL);
-	if (!ccp->ccp_dma_chan)
-		return -ENOMEM;
-
-	dma_cmd_cache_name = devm_kasprintf(ccp->dev, GFP_KERNEL,
-					    "%s-dmaengine-cmd-cache",
-					    ccp->name);
-	if (!dma_cmd_cache_name)
-		return -ENOMEM;
-
-	ccp->dma_cmd_cache = kmem_cache_create(dma_cmd_cache_name,
-					       sizeof(struct ccp_dma_cmd),
-					       sizeof(void *),
-					       SLAB_HWCACHE_ALIGN, NULL);
-	if (!ccp->dma_cmd_cache)
-		return -ENOMEM;
-
-	dma_desc_cache_name = devm_kasprintf(ccp->dev, GFP_KERNEL,
-					     "%s-dmaengine-desc-cache",
-					     ccp->name);
-	if (!dma_desc_cache_name) {
-		ret = -ENOMEM;
-		goto err_cache;
-	}
-
-	ccp->dma_desc_cache = kmem_cache_create(dma_desc_cache_name,
-						sizeof(struct ccp_dma_desc),
-						sizeof(void *),
-						SLAB_HWCACHE_ALIGN, NULL);
-	if (!ccp->dma_desc_cache) {
-		ret = -ENOMEM;
-		goto err_cache;
-	}
-
-	dma_dev->dev = ccp->dev;
-	dma_dev->src_addr_widths = CCP_DMA_WIDTH(dma_get_mask(ccp->dev));
-	dma_dev->dst_addr_widths = CCP_DMA_WIDTH(dma_get_mask(ccp->dev));
-	dma_dev->directions = DMA_MEM_TO_MEM;
-	dma_dev->residue_granularity = DMA_RESIDUE_GRANULARITY_DESCRIPTOR;
-	dma_cap_set(DMA_MEMCPY, dma_dev->cap_mask);
-	dma_cap_set(DMA_SG, dma_dev->cap_mask);
-	dma_cap_set(DMA_INTERRUPT, dma_dev->cap_mask);
-
-	INIT_LIST_HEAD(&dma_dev->channels);
-	for (i = 0; i < ccp->cmd_q_count; i++) {
-		chan = ccp->ccp_dma_chan + i;
-		dma_chan = &chan->dma_chan;
-
-		chan->ccp = ccp;
-
-		spin_lock_init(&chan->lock);
-		INIT_LIST_HEAD(&chan->pending);
-		INIT_LIST_HEAD(&chan->active);
-		INIT_LIST_HEAD(&chan->complete);
-
-		tasklet_init(&chan->cleanup_tasklet, ccp_do_cleanup,
-			     (unsigned long)chan);
-
-		dma_chan->device = dma_dev;
-		dma_cookie_init(dma_chan);
-
-		list_add_tail(&dma_chan->device_node, &dma_dev->channels);
-	}
-
-	dma_dev->device_free_chan_resources = ccp_free_chan_resources;
-	dma_dev->device_prep_dma_memcpy = ccp_prep_dma_memcpy;
-	dma_dev->device_prep_dma_sg = ccp_prep_dma_sg;
-	dma_dev->device_prep_dma_interrupt = ccp_prep_dma_interrupt;
-	dma_dev->device_issue_pending = ccp_issue_pending;
-	dma_dev->device_tx_status = ccp_tx_status;
-	dma_dev->device_pause = ccp_pause;
-	dma_dev->device_resume = ccp_resume;
-	dma_dev->device_terminate_all = ccp_terminate_all;
-
-	ret = dma_async_device_register(dma_dev);
-	if (ret)
-		goto err_reg;
-
-	return 0;
-
-err_reg:
-	kmem_cache_destroy(ccp->dma_desc_cache);
-
-err_cache:
-	kmem_cache_destroy(ccp->dma_cmd_cache);
-
-	return ret;
-}
-
-void ccp_dmaengine_unregister(struct ccp_device *ccp)
-{
-	struct dma_device *dma_dev = &ccp->dma_dev;
-
-	dma_async_device_unregister(dma_dev);
-
-	kmem_cache_destroy(ccp->dma_desc_cache);
-	kmem_cache_destroy(ccp->dma_cmd_cache);
-}
diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
deleted file mode 100644
index 50fae44..0000000
--- a/drivers/crypto/ccp/ccp-ops.c
+++ /dev/null
@@ -1,1876 +0,0 @@
-/*
- * AMD Cryptographic Coprocessor (CCP) driver
- *
- * Copyright (C) 2013,2016 Advanced Micro Devices, Inc.
- *
- * Author: Tom Lendacky <thomas.lendacky@amd.com>
- * Author: Gary R Hook <gary.hook@amd.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/pci.h>
-#include <linux/interrupt.h>
-#include <crypto/scatterwalk.h>
-#include <linux/ccp.h>
-
-#include "ccp-dev.h"
-
-/* SHA initial context values */
-static const __be32 ccp_sha1_init[SHA1_DIGEST_SIZE / sizeof(__be32)] = {
-	cpu_to_be32(SHA1_H0), cpu_to_be32(SHA1_H1),
-	cpu_to_be32(SHA1_H2), cpu_to_be32(SHA1_H3),
-	cpu_to_be32(SHA1_H4),
-};
-
-static const __be32 ccp_sha224_init[SHA256_DIGEST_SIZE / sizeof(__be32)] = {
-	cpu_to_be32(SHA224_H0), cpu_to_be32(SHA224_H1),
-	cpu_to_be32(SHA224_H2), cpu_to_be32(SHA224_H3),
-	cpu_to_be32(SHA224_H4), cpu_to_be32(SHA224_H5),
-	cpu_to_be32(SHA224_H6), cpu_to_be32(SHA224_H7),
-};
-
-static const __be32 ccp_sha256_init[SHA256_DIGEST_SIZE / sizeof(__be32)] = {
-	cpu_to_be32(SHA256_H0), cpu_to_be32(SHA256_H1),
-	cpu_to_be32(SHA256_H2), cpu_to_be32(SHA256_H3),
-	cpu_to_be32(SHA256_H4), cpu_to_be32(SHA256_H5),
-	cpu_to_be32(SHA256_H6), cpu_to_be32(SHA256_H7),
-};
-
-#define	CCP_NEW_JOBID(ccp)	((ccp->vdata->version == CCP_VERSION(3, 0)) ? \
-					ccp_gen_jobid(ccp) : 0)
-
-static u32 ccp_gen_jobid(struct ccp_device *ccp)
-{
-	return atomic_inc_return(&ccp->current_id) & CCP_JOBID_MASK;
-}
-
-static void ccp_sg_free(struct ccp_sg_workarea *wa)
-{
-	if (wa->dma_count)
-		dma_unmap_sg(wa->dma_dev, wa->dma_sg, wa->nents, wa->dma_dir);
-
-	wa->dma_count = 0;
-}
-
-static int ccp_init_sg_workarea(struct ccp_sg_workarea *wa, struct device *dev,
-				struct scatterlist *sg, u64 len,
-				enum dma_data_direction dma_dir)
-{
-	memset(wa, 0, sizeof(*wa));
-
-	wa->sg = sg;
-	if (!sg)
-		return 0;
-
-	wa->nents = sg_nents_for_len(sg, len);
-	if (wa->nents < 0)
-		return wa->nents;
-
-	wa->bytes_left = len;
-	wa->sg_used = 0;
-
-	if (len == 0)
-		return 0;
-
-	if (dma_dir == DMA_NONE)
-		return 0;
-
-	wa->dma_sg = sg;
-	wa->dma_dev = dev;
-	wa->dma_dir = dma_dir;
-	wa->dma_count = dma_map_sg(dev, sg, wa->nents, dma_dir);
-	if (!wa->dma_count)
-		return -ENOMEM;
-
-	return 0;
-}
-
-static void ccp_update_sg_workarea(struct ccp_sg_workarea *wa, unsigned int len)
-{
-	unsigned int nbytes = min_t(u64, len, wa->bytes_left);
-
-	if (!wa->sg)
-		return;
-
-	wa->sg_used += nbytes;
-	wa->bytes_left -= nbytes;
-	if (wa->sg_used == wa->sg->length) {
-		wa->sg = sg_next(wa->sg);
-		wa->sg_used = 0;
-	}
-}
-
-static void ccp_dm_free(struct ccp_dm_workarea *wa)
-{
-	if (wa->length <= CCP_DMAPOOL_MAX_SIZE) {
-		if (wa->address)
-			dma_pool_free(wa->dma_pool, wa->address,
-				      wa->dma.address);
-	} else {
-		if (wa->dma.address)
-			dma_unmap_single(wa->dev, wa->dma.address, wa->length,
-					 wa->dma.dir);
-		kfree(wa->address);
-	}
-
-	wa->address = NULL;
-	wa->dma.address = 0;
-}
-
-static int ccp_init_dm_workarea(struct ccp_dm_workarea *wa,
-				struct ccp_cmd_queue *cmd_q,
-				unsigned int len,
-				enum dma_data_direction dir)
-{
-	memset(wa, 0, sizeof(*wa));
-
-	if (!len)
-		return 0;
-
-	wa->dev = cmd_q->ccp->dev;
-	wa->length = len;
-
-	if (len <= CCP_DMAPOOL_MAX_SIZE) {
-		wa->dma_pool = cmd_q->dma_pool;
-
-		wa->address = dma_pool_alloc(wa->dma_pool, GFP_KERNEL,
-					     &wa->dma.address);
-		if (!wa->address)
-			return -ENOMEM;
-
-		wa->dma.length = CCP_DMAPOOL_MAX_SIZE;
-
-		memset(wa->address, 0, CCP_DMAPOOL_MAX_SIZE);
-	} else {
-		wa->address = kzalloc(len, GFP_KERNEL);
-		if (!wa->address)
-			return -ENOMEM;
-
-		wa->dma.address = dma_map_single(wa->dev, wa->address, len,
-						 dir);
-		if (!wa->dma.address)
-			return -ENOMEM;
-
-		wa->dma.length = len;
-	}
-	wa->dma.dir = dir;
-
-	return 0;
-}
-
-static void ccp_set_dm_area(struct ccp_dm_workarea *wa, unsigned int wa_offset,
-			    struct scatterlist *sg, unsigned int sg_offset,
-			    unsigned int len)
-{
-	WARN_ON(!wa->address);
-
-	scatterwalk_map_and_copy(wa->address + wa_offset, sg, sg_offset, len,
-				 0);
-}
-
-static void ccp_get_dm_area(struct ccp_dm_workarea *wa, unsigned int wa_offset,
-			    struct scatterlist *sg, unsigned int sg_offset,
-			    unsigned int len)
-{
-	WARN_ON(!wa->address);
-
-	scatterwalk_map_and_copy(wa->address + wa_offset, sg, sg_offset, len,
-				 1);
-}
-
-static int ccp_reverse_set_dm_area(struct ccp_dm_workarea *wa,
-				   struct scatterlist *sg,
-				   unsigned int len, unsigned int se_len,
-				   bool sign_extend)
-{
-	unsigned int nbytes, sg_offset, dm_offset, sb_len, i;
-	u8 buffer[CCP_REVERSE_BUF_SIZE];
-
-	if (WARN_ON(se_len > sizeof(buffer)))
-		return -EINVAL;
-
-	sg_offset = len;
-	dm_offset = 0;
-	nbytes = len;
-	while (nbytes) {
-		sb_len = min_t(unsigned int, nbytes, se_len);
-		sg_offset -= sb_len;
-
-		scatterwalk_map_and_copy(buffer, sg, sg_offset, sb_len, 0);
-		for (i = 0; i < sb_len; i++)
-			wa->address[dm_offset + i] = buffer[sb_len - i - 1];
-
-		dm_offset += sb_len;
-		nbytes -= sb_len;
-
-		if ((sb_len != se_len) && sign_extend) {
-			/* Must sign-extend to nearest sign-extend length */
-			if (wa->address[dm_offset - 1] & 0x80)
-				memset(wa->address + dm_offset, 0xff,
-				       se_len - sb_len);
-		}
-	}
-
-	return 0;
-}
-
-static void ccp_reverse_get_dm_area(struct ccp_dm_workarea *wa,
-				    struct scatterlist *sg,
-				    unsigned int len)
-{
-	unsigned int nbytes, sg_offset, dm_offset, sb_len, i;
-	u8 buffer[CCP_REVERSE_BUF_SIZE];
-
-	sg_offset = 0;
-	dm_offset = len;
-	nbytes = len;
-	while (nbytes) {
-		sb_len = min_t(unsigned int, nbytes, sizeof(buffer));
-		dm_offset -= sb_len;
-
-		for (i = 0; i < sb_len; i++)
-			buffer[sb_len - i - 1] = wa->address[dm_offset + i];
-		scatterwalk_map_and_copy(buffer, sg, sg_offset, sb_len, 1);
-
-		sg_offset += sb_len;
-		nbytes -= sb_len;
-	}
-}
-
-static void ccp_free_data(struct ccp_data *data, struct ccp_cmd_queue *cmd_q)
-{
-	ccp_dm_free(&data->dm_wa);
-	ccp_sg_free(&data->sg_wa);
-}
-
-static int ccp_init_data(struct ccp_data *data, struct ccp_cmd_queue *cmd_q,
-			 struct scatterlist *sg, u64 sg_len,
-			 unsigned int dm_len,
-			 enum dma_data_direction dir)
-{
-	int ret;
-
-	memset(data, 0, sizeof(*data));
-
-	ret = ccp_init_sg_workarea(&data->sg_wa, cmd_q->ccp->dev, sg, sg_len,
-				   dir);
-	if (ret)
-		goto e_err;
-
-	ret = ccp_init_dm_workarea(&data->dm_wa, cmd_q, dm_len, dir);
-	if (ret)
-		goto e_err;
-
-	return 0;
-
-e_err:
-	ccp_free_data(data, cmd_q);
-
-	return ret;
-}
-
-static unsigned int ccp_queue_buf(struct ccp_data *data, unsigned int from)
-{
-	struct ccp_sg_workarea *sg_wa = &data->sg_wa;
-	struct ccp_dm_workarea *dm_wa = &data->dm_wa;
-	unsigned int buf_count, nbytes;
-
-	/* Clear the buffer if setting it */
-	if (!from)
-		memset(dm_wa->address, 0, dm_wa->length);
-
-	if (!sg_wa->sg)
-		return 0;
-
-	/* Perform the copy operation
-	 *   nbytes will always be <= UINT_MAX because dm_wa->length is
-	 *   an unsigned int
-	 */
-	nbytes = min_t(u64, sg_wa->bytes_left, dm_wa->length);
-	scatterwalk_map_and_copy(dm_wa->address, sg_wa->sg, sg_wa->sg_used,
-				 nbytes, from);
-
-	/* Update the structures and generate the count */
-	buf_count = 0;
-	while (sg_wa->bytes_left && (buf_count < dm_wa->length)) {
-		nbytes = min(sg_wa->sg->length - sg_wa->sg_used,
-			     dm_wa->length - buf_count);
-		nbytes = min_t(u64, sg_wa->bytes_left, nbytes);
-
-		buf_count += nbytes;
-		ccp_update_sg_workarea(sg_wa, nbytes);
-	}
-
-	return buf_count;
-}
-
-static unsigned int ccp_fill_queue_buf(struct ccp_data *data)
-{
-	return ccp_queue_buf(data, 0);
-}
-
-static unsigned int ccp_empty_queue_buf(struct ccp_data *data)
-{
-	return ccp_queue_buf(data, 1);
-}
-
-static void ccp_prepare_data(struct ccp_data *src, struct ccp_data *dst,
-			     struct ccp_op *op, unsigned int block_size,
-			     bool blocksize_op)
-{
-	unsigned int sg_src_len, sg_dst_len, op_len;
-
-	/* The CCP can only DMA from/to one address each per operation. This
-	 * requires that we find the smallest DMA area between the source
-	 * and destination. The resulting len values will always be <= UINT_MAX
-	 * because the dma length is an unsigned int.
-	 */
-	sg_src_len = sg_dma_len(src->sg_wa.sg) - src->sg_wa.sg_used;
-	sg_src_len = min_t(u64, src->sg_wa.bytes_left, sg_src_len);
-
-	if (dst) {
-		sg_dst_len = sg_dma_len(dst->sg_wa.sg) - dst->sg_wa.sg_used;
-		sg_dst_len = min_t(u64, src->sg_wa.bytes_left, sg_dst_len);
-		op_len = min(sg_src_len, sg_dst_len);
-	} else {
-		op_len = sg_src_len;
-	}
-
-	/* The data operation length will be at least block_size in length
-	 * or the smaller of available sg room remaining for the source or
-	 * the destination
-	 */
-	op_len = max(op_len, block_size);
-
-	/* Unless we have to buffer data, there's no reason to wait */
-	op->soc = 0;
-
-	if (sg_src_len < block_size) {
-		/* Not enough data in the sg element, so it
-		 * needs to be buffered into a blocksize chunk
-		 */
-		int cp_len = ccp_fill_queue_buf(src);
-
-		op->soc = 1;
-		op->src.u.dma.address = src->dm_wa.dma.address;
-		op->src.u.dma.offset = 0;
-		op->src.u.dma.length = (blocksize_op) ? block_size : cp_len;
-	} else {
-		/* Enough data in the sg element, but we need to
-		 * adjust for any previously copied data
-		 */
-		op->src.u.dma.address = sg_dma_address(src->sg_wa.sg);
-		op->src.u.dma.offset = src->sg_wa.sg_used;
-		op->src.u.dma.length = op_len & ~(block_size - 1);
-
-		ccp_update_sg_workarea(&src->sg_wa, op->src.u.dma.length);
-	}
-
-	if (dst) {
-		if (sg_dst_len < block_size) {
-			/* Not enough room in the sg element or we're on the
-			 * last piece of data (when using padding), so the
-			 * output needs to be buffered into a blocksize chunk
-			 */
-			op->soc = 1;
-			op->dst.u.dma.address = dst->dm_wa.dma.address;
-			op->dst.u.dma.offset = 0;
-			op->dst.u.dma.length = op->src.u.dma.length;
-		} else {
-			/* Enough room in the sg element, but we need to
-			 * adjust for any previously used area
-			 */
-			op->dst.u.dma.address = sg_dma_address(dst->sg_wa.sg);
-			op->dst.u.dma.offset = dst->sg_wa.sg_used;
-			op->dst.u.dma.length = op->src.u.dma.length;
-		}
-	}
-}
-
-static void ccp_process_data(struct ccp_data *src, struct ccp_data *dst,
-			     struct ccp_op *op)
-{
-	op->init = 0;
-
-	if (dst) {
-		if (op->dst.u.dma.address == dst->dm_wa.dma.address)
-			ccp_empty_queue_buf(dst);
-		else
-			ccp_update_sg_workarea(&dst->sg_wa,
-					       op->dst.u.dma.length);
-	}
-}
-
-static int ccp_copy_to_from_sb(struct ccp_cmd_queue *cmd_q,
-			       struct ccp_dm_workarea *wa, u32 jobid, u32 sb,
-			       u32 byte_swap, bool from)
-{
-	struct ccp_op op;
-
-	memset(&op, 0, sizeof(op));
-
-	op.cmd_q = cmd_q;
-	op.jobid = jobid;
-	op.eom = 1;
-
-	if (from) {
-		op.soc = 1;
-		op.src.type = CCP_MEMTYPE_SB;
-		op.src.u.sb = sb;
-		op.dst.type = CCP_MEMTYPE_SYSTEM;
-		op.dst.u.dma.address = wa->dma.address;
-		op.dst.u.dma.length = wa->length;
-	} else {
-		op.src.type = CCP_MEMTYPE_SYSTEM;
-		op.src.u.dma.address = wa->dma.address;
-		op.src.u.dma.length = wa->length;
-		op.dst.type = CCP_MEMTYPE_SB;
-		op.dst.u.sb = sb;
-	}
-
-	op.u.passthru.byte_swap = byte_swap;
-
-	return cmd_q->ccp->vdata->perform->passthru(&op);
-}
-
-static int ccp_copy_to_sb(struct ccp_cmd_queue *cmd_q,
-			  struct ccp_dm_workarea *wa, u32 jobid, u32 sb,
-			  u32 byte_swap)
-{
-	return ccp_copy_to_from_sb(cmd_q, wa, jobid, sb, byte_swap, false);
-}
-
-static int ccp_copy_from_sb(struct ccp_cmd_queue *cmd_q,
-			    struct ccp_dm_workarea *wa, u32 jobid, u32 sb,
-			    u32 byte_swap)
-{
-	return ccp_copy_to_from_sb(cmd_q, wa, jobid, sb, byte_swap, true);
-}
-
-static int ccp_run_aes_cmac_cmd(struct ccp_cmd_queue *cmd_q,
-				struct ccp_cmd *cmd)
-{
-	struct ccp_aes_engine *aes = &cmd->u.aes;
-	struct ccp_dm_workarea key, ctx;
-	struct ccp_data src;
-	struct ccp_op op;
-	unsigned int dm_offset;
-	int ret;
-
-	if (!((aes->key_len == AES_KEYSIZE_128) ||
-	      (aes->key_len == AES_KEYSIZE_192) ||
-	      (aes->key_len == AES_KEYSIZE_256)))
-		return -EINVAL;
-
-	if (aes->src_len & (AES_BLOCK_SIZE - 1))
-		return -EINVAL;
-
-	if (aes->iv_len != AES_BLOCK_SIZE)
-		return -EINVAL;
-
-	if (!aes->key || !aes->iv || !aes->src)
-		return -EINVAL;
-
-	if (aes->cmac_final) {
-		if (aes->cmac_key_len != AES_BLOCK_SIZE)
-			return -EINVAL;
-
-		if (!aes->cmac_key)
-			return -EINVAL;
-	}
-
-	BUILD_BUG_ON(CCP_AES_KEY_SB_COUNT != 1);
-	BUILD_BUG_ON(CCP_AES_CTX_SB_COUNT != 1);
-
-	ret = -EIO;
-	memset(&op, 0, sizeof(op));
-	op.cmd_q = cmd_q;
-	op.jobid = CCP_NEW_JOBID(cmd_q->ccp);
-	op.sb_key = cmd_q->sb_key;
-	op.sb_ctx = cmd_q->sb_ctx;
-	op.init = 1;
-	op.u.aes.type = aes->type;
-	op.u.aes.mode = aes->mode;
-	op.u.aes.action = aes->action;
-
-	/* All supported key sizes fit in a single (32-byte) SB entry
-	 * and must be in little endian format. Use the 256-bit byte
-	 * swap passthru option to convert from big endian to little
-	 * endian.
-	 */
-	ret = ccp_init_dm_workarea(&key, cmd_q,
-				   CCP_AES_KEY_SB_COUNT * CCP_SB_BYTES,
-				   DMA_TO_DEVICE);
-	if (ret)
-		return ret;
-
-	dm_offset = CCP_SB_BYTES - aes->key_len;
-	ccp_set_dm_area(&key, dm_offset, aes->key, 0, aes->key_len);
-	ret = ccp_copy_to_sb(cmd_q, &key, op.jobid, op.sb_key,
-			     CCP_PASSTHRU_BYTESWAP_256BIT);
-	if (ret) {
-		cmd->engine_error = cmd_q->cmd_error;
-		goto e_key;
-	}
-
-	/* The AES context fits in a single (32-byte) SB entry and
-	 * must be in little endian format. Use the 256-bit byte swap
-	 * passthru option to convert from big endian to little endian.
-	 */
-	ret = ccp_init_dm_workarea(&ctx, cmd_q,
-				   CCP_AES_CTX_SB_COUNT * CCP_SB_BYTES,
-				   DMA_BIDIRECTIONAL);
-	if (ret)
-		goto e_key;
-
-	dm_offset = CCP_SB_BYTES - AES_BLOCK_SIZE;
-	ccp_set_dm_area(&ctx, dm_offset, aes->iv, 0, aes->iv_len);
-	ret = ccp_copy_to_sb(cmd_q, &ctx, op.jobid, op.sb_ctx,
-			     CCP_PASSTHRU_BYTESWAP_256BIT);
-	if (ret) {
-		cmd->engine_error = cmd_q->cmd_error;
-		goto e_ctx;
-	}
-
-	/* Send data to the CCP AES engine */
-	ret = ccp_init_data(&src, cmd_q, aes->src, aes->src_len,
-			    AES_BLOCK_SIZE, DMA_TO_DEVICE);
-	if (ret)
-		goto e_ctx;
-
-	while (src.sg_wa.bytes_left) {
-		ccp_prepare_data(&src, NULL, &op, AES_BLOCK_SIZE, true);
-		if (aes->cmac_final && !src.sg_wa.bytes_left) {
-			op.eom = 1;
-
-			/* Push the K1/K2 key to the CCP now */
-			ret = ccp_copy_from_sb(cmd_q, &ctx, op.jobid,
-					       op.sb_ctx,
-					       CCP_PASSTHRU_BYTESWAP_256BIT);
-			if (ret) {
-				cmd->engine_error = cmd_q->cmd_error;
-				goto e_src;
-			}
-
-			ccp_set_dm_area(&ctx, 0, aes->cmac_key, 0,
-					aes->cmac_key_len);
-			ret = ccp_copy_to_sb(cmd_q, &ctx, op.jobid, op.sb_ctx,
-					     CCP_PASSTHRU_BYTESWAP_256BIT);
-			if (ret) {
-				cmd->engine_error = cmd_q->cmd_error;
-				goto e_src;
-			}
-		}
-
-		ret = cmd_q->ccp->vdata->perform->aes(&op);
-		if (ret) {
-			cmd->engine_error = cmd_q->cmd_error;
-			goto e_src;
-		}
-
-		ccp_process_data(&src, NULL, &op);
-	}
-
-	/* Retrieve the AES context - convert from LE to BE using
-	 * 32-byte (256-bit) byteswapping
-	 */
-	ret = ccp_copy_from_sb(cmd_q, &ctx, op.jobid, op.sb_ctx,
-			       CCP_PASSTHRU_BYTESWAP_256BIT);
-	if (ret) {
-		cmd->engine_error = cmd_q->cmd_error;
-		goto e_src;
-	}
-
-	/* ...but we only need AES_BLOCK_SIZE bytes */
-	dm_offset = CCP_SB_BYTES - AES_BLOCK_SIZE;
-	ccp_get_dm_area(&ctx, dm_offset, aes->iv, 0, aes->iv_len);
-
-e_src:
-	ccp_free_data(&src, cmd_q);
-
-e_ctx:
-	ccp_dm_free(&ctx);
-
-e_key:
-	ccp_dm_free(&key);
-
-	return ret;
-}
-
-static int ccp_run_aes_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
-{
-	struct ccp_aes_engine *aes = &cmd->u.aes;
-	struct ccp_dm_workarea key, ctx;
-	struct ccp_data src, dst;
-	struct ccp_op op;
-	unsigned int dm_offset;
-	bool in_place = false;
-	int ret;
-
-	if (aes->mode == CCP_AES_MODE_CMAC)
-		return ccp_run_aes_cmac_cmd(cmd_q, cmd);
-
-	if (!((aes->key_len == AES_KEYSIZE_128) ||
-	      (aes->key_len == AES_KEYSIZE_192) ||
-	      (aes->key_len == AES_KEYSIZE_256)))
-		return -EINVAL;
-
-	if (((aes->mode == CCP_AES_MODE_ECB) ||
-	     (aes->mode == CCP_AES_MODE_CBC) ||
-	     (aes->mode == CCP_AES_MODE_CFB)) &&
-	    (aes->src_len & (AES_BLOCK_SIZE - 1)))
-		return -EINVAL;
-
-	if (!aes->key || !aes->src || !aes->dst)
-		return -EINVAL;
-
-	if (aes->mode != CCP_AES_MODE_ECB) {
-		if (aes->iv_len != AES_BLOCK_SIZE)
-			return -EINVAL;
-
-		if (!aes->iv)
-			return -EINVAL;
-	}
-
-	BUILD_BUG_ON(CCP_AES_KEY_SB_COUNT != 1);
-	BUILD_BUG_ON(CCP_AES_CTX_SB_COUNT != 1);
-
-	ret = -EIO;
-	memset(&op, 0, sizeof(op));
-	op.cmd_q = cmd_q;
-	op.jobid = CCP_NEW_JOBID(cmd_q->ccp);
-	op.sb_key = cmd_q->sb_key;
-	op.sb_ctx = cmd_q->sb_ctx;
-	op.init = (aes->mode == CCP_AES_MODE_ECB) ? 0 : 1;
-	op.u.aes.type = aes->type;
-	op.u.aes.mode = aes->mode;
-	op.u.aes.action = aes->action;
-
-	/* All supported key sizes fit in a single (32-byte) SB entry
-	 * and must be in little endian format. Use the 256-bit byte
-	 * swap passthru option to convert from big endian to little
-	 * endian.
-	 */
-	ret = ccp_init_dm_workarea(&key, cmd_q,
-				   CCP_AES_KEY_SB_COUNT * CCP_SB_BYTES,
-				   DMA_TO_DEVICE);
-	if (ret)
-		return ret;
-
-	dm_offset = CCP_SB_BYTES - aes->key_len;
-	ccp_set_dm_area(&key, dm_offset, aes->key, 0, aes->key_len);
-	ret = ccp_copy_to_sb(cmd_q, &key, op.jobid, op.sb_key,
-			     CCP_PASSTHRU_BYTESWAP_256BIT);
-	if (ret) {
-		cmd->engine_error = cmd_q->cmd_error;
-		goto e_key;
-	}
-
-	/* The AES context fits in a single (32-byte) SB entry and
-	 * must be in little endian format. Use the 256-bit byte swap
-	 * passthru option to convert from big endian to little endian.
-	 */
-	ret = ccp_init_dm_workarea(&ctx, cmd_q,
-				   CCP_AES_CTX_SB_COUNT * CCP_SB_BYTES,
-				   DMA_BIDIRECTIONAL);
-	if (ret)
-		goto e_key;
-
-	if (aes->mode != CCP_AES_MODE_ECB) {
-		/* Load the AES context - convert to LE */
-		dm_offset = CCP_SB_BYTES - AES_BLOCK_SIZE;
-		ccp_set_dm_area(&ctx, dm_offset, aes->iv, 0, aes->iv_len);
-		ret = ccp_copy_to_sb(cmd_q, &ctx, op.jobid, op.sb_ctx,
-				     CCP_PASSTHRU_BYTESWAP_256BIT);
-		if (ret) {
-			cmd->engine_error = cmd_q->cmd_error;
-			goto e_ctx;
-		}
-	}
-
-	/* Prepare the input and output data workareas. For in-place
-	 * operations we need to set the dma direction to BIDIRECTIONAL
-	 * and copy the src workarea to the dst workarea.
-	 */
-	if (sg_virt(aes->src) == sg_virt(aes->dst))
-		in_place = true;
-
-	ret = ccp_init_data(&src, cmd_q, aes->src, aes->src_len,
-			    AES_BLOCK_SIZE,
-			    in_place ? DMA_BIDIRECTIONAL : DMA_TO_DEVICE);
-	if (ret)
-		goto e_ctx;
-
-	if (in_place) {
-		dst = src;
-	} else {
-		ret = ccp_init_data(&dst, cmd_q, aes->dst, aes->src_len,
-				    AES_BLOCK_SIZE, DMA_FROM_DEVICE);
-		if (ret)
-			goto e_src;
-	}
-
-	/* Send data to the CCP AES engine */
-	while (src.sg_wa.bytes_left) {
-		ccp_prepare_data(&src, &dst, &op, AES_BLOCK_SIZE, true);
-		if (!src.sg_wa.bytes_left) {
-			op.eom = 1;
-
-			/* Since we don't retrieve the AES context in ECB
-			 * mode we have to wait for the operation to complete
-			 * on the last piece of data
-			 */
-			if (aes->mode == CCP_AES_MODE_ECB)
-				op.soc = 1;
-		}
-
-		ret = cmd_q->ccp->vdata->perform->aes(&op);
-		if (ret) {
-			cmd->engine_error = cmd_q->cmd_error;
-			goto e_dst;
-		}
-
-		ccp_process_data(&src, &dst, &op);
-	}
-
-	if (aes->mode != CCP_AES_MODE_ECB) {
-		/* Retrieve the AES context - convert from LE to BE using
-		 * 32-byte (256-bit) byteswapping
-		 */
-		ret = ccp_copy_from_sb(cmd_q, &ctx, op.jobid, op.sb_ctx,
-				       CCP_PASSTHRU_BYTESWAP_256BIT);
-		if (ret) {
-			cmd->engine_error = cmd_q->cmd_error;
-			goto e_dst;
-		}
-
-		/* ...but we only need AES_BLOCK_SIZE bytes */
-		dm_offset = CCP_SB_BYTES - AES_BLOCK_SIZE;
-		ccp_get_dm_area(&ctx, dm_offset, aes->iv, 0, aes->iv_len);
-	}
-
-e_dst:
-	if (!in_place)
-		ccp_free_data(&dst, cmd_q);
-
-e_src:
-	ccp_free_data(&src, cmd_q);
-
-e_ctx:
-	ccp_dm_free(&ctx);
-
-e_key:
-	ccp_dm_free(&key);
-
-	return ret;
-}
-
-static int ccp_run_xts_aes_cmd(struct ccp_cmd_queue *cmd_q,
-			       struct ccp_cmd *cmd)
-{
-	struct ccp_xts_aes_engine *xts = &cmd->u.xts;
-	struct ccp_dm_workarea key, ctx;
-	struct ccp_data src, dst;
-	struct ccp_op op;
-	unsigned int unit_size, dm_offset;
-	bool in_place = false;
-	int ret;
-
-	switch (xts->unit_size) {
-	case CCP_XTS_AES_UNIT_SIZE_16:
-		unit_size = 16;
-		break;
-	case CCP_XTS_AES_UNIT_SIZE_512:
-		unit_size = 512;
-		break;
-	case CCP_XTS_AES_UNIT_SIZE_1024:
-		unit_size = 1024;
-		break;
-	case CCP_XTS_AES_UNIT_SIZE_2048:
-		unit_size = 2048;
-		break;
-	case CCP_XTS_AES_UNIT_SIZE_4096:
-		unit_size = 4096;
-		break;
-
-	default:
-		return -EINVAL;
-	}
-
-	if (xts->key_len != AES_KEYSIZE_128)
-		return -EINVAL;
-
-	if (!xts->final && (xts->src_len & (AES_BLOCK_SIZE - 1)))
-		return -EINVAL;
-
-	if (xts->iv_len != AES_BLOCK_SIZE)
-		return -EINVAL;
-
-	if (!xts->key || !xts->iv || !xts->src || !xts->dst)
-		return -EINVAL;
-
-	BUILD_BUG_ON(CCP_XTS_AES_KEY_SB_COUNT != 1);
-	BUILD_BUG_ON(CCP_XTS_AES_CTX_SB_COUNT != 1);
-
-	ret = -EIO;
-	memset(&op, 0, sizeof(op));
-	op.cmd_q = cmd_q;
-	op.jobid = CCP_NEW_JOBID(cmd_q->ccp);
-	op.sb_key = cmd_q->sb_key;
-	op.sb_ctx = cmd_q->sb_ctx;
-	op.init = 1;
-	op.u.xts.action = xts->action;
-	op.u.xts.unit_size = xts->unit_size;
-
-	/* All supported key sizes fit in a single (32-byte) SB entry
-	 * and must be in little endian format. Use the 256-bit byte
-	 * swap passthru option to convert from big endian to little
-	 * endian.
-	 */
-	ret = ccp_init_dm_workarea(&key, cmd_q,
-				   CCP_XTS_AES_KEY_SB_COUNT * CCP_SB_BYTES,
-				   DMA_TO_DEVICE);
-	if (ret)
-		return ret;
-
-	dm_offset = CCP_SB_BYTES - AES_KEYSIZE_128;
-	ccp_set_dm_area(&key, dm_offset, xts->key, 0, xts->key_len);
-	ccp_set_dm_area(&key, 0, xts->key, dm_offset, xts->key_len);
-	ret = ccp_copy_to_sb(cmd_q, &key, op.jobid, op.sb_key,
-			     CCP_PASSTHRU_BYTESWAP_256BIT);
-	if (ret) {
-		cmd->engine_error = cmd_q->cmd_error;
-		goto e_key;
-	}
-
-	/* The AES context fits in a single (32-byte) SB entry and
-	 * for XTS is already in little endian format so no byte swapping
-	 * is needed.
-	 */
-	ret = ccp_init_dm_workarea(&ctx, cmd_q,
-				   CCP_XTS_AES_CTX_SB_COUNT * CCP_SB_BYTES,
-				   DMA_BIDIRECTIONAL);
-	if (ret)
-		goto e_key;
-
-	ccp_set_dm_area(&ctx, 0, xts->iv, 0, xts->iv_len);
-	ret = ccp_copy_to_sb(cmd_q, &ctx, op.jobid, op.sb_ctx,
-			     CCP_PASSTHRU_BYTESWAP_NOOP);
-	if (ret) {
-		cmd->engine_error = cmd_q->cmd_error;
-		goto e_ctx;
-	}
-
-	/* Prepare the input and output data workareas. For in-place
-	 * operations we need to set the dma direction to BIDIRECTIONAL
-	 * and copy the src workarea to the dst workarea.
-	 */
-	if (sg_virt(xts->src) == sg_virt(xts->dst))
-		in_place = true;
-
-	ret = ccp_init_data(&src, cmd_q, xts->src, xts->src_len,
-			    unit_size,
-			    in_place ? DMA_BIDIRECTIONAL : DMA_TO_DEVICE);
-	if (ret)
-		goto e_ctx;
-
-	if (in_place) {
-		dst = src;
-	} else {
-		ret = ccp_init_data(&dst, cmd_q, xts->dst, xts->src_len,
-				    unit_size, DMA_FROM_DEVICE);
-		if (ret)
-			goto e_src;
-	}
-
-	/* Send data to the CCP AES engine */
-	while (src.sg_wa.bytes_left) {
-		ccp_prepare_data(&src, &dst, &op, unit_size, true);
-		if (!src.sg_wa.bytes_left)
-			op.eom = 1;
-
-		ret = cmd_q->ccp->vdata->perform->xts_aes(&op);
-		if (ret) {
-			cmd->engine_error = cmd_q->cmd_error;
-			goto e_dst;
-		}
-
-		ccp_process_data(&src, &dst, &op);
-	}
-
-	/* Retrieve the AES context - convert from LE to BE using
-	 * 32-byte (256-bit) byteswapping
-	 */
-	ret = ccp_copy_from_sb(cmd_q, &ctx, op.jobid, op.sb_ctx,
-			       CCP_PASSTHRU_BYTESWAP_256BIT);
-	if (ret) {
-		cmd->engine_error = cmd_q->cmd_error;
-		goto e_dst;
-	}
-
-	/* ...but we only need AES_BLOCK_SIZE bytes */
-	dm_offset = CCP_SB_BYTES - AES_BLOCK_SIZE;
-	ccp_get_dm_area(&ctx, dm_offset, xts->iv, 0, xts->iv_len);
-
-e_dst:
-	if (!in_place)
-		ccp_free_data(&dst, cmd_q);
-
-e_src:
-	ccp_free_data(&src, cmd_q);
-
-e_ctx:
-	ccp_dm_free(&ctx);
-
-e_key:
-	ccp_dm_free(&key);
-
-	return ret;
-}
-
-static int ccp_run_sha_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
-{
-	struct ccp_sha_engine *sha = &cmd->u.sha;
-	struct ccp_dm_workarea ctx;
-	struct ccp_data src;
-	struct ccp_op op;
-	unsigned int ioffset, ooffset;
-	unsigned int digest_size;
-	int sb_count;
-	const void *init;
-	u64 block_size;
-	int ctx_size;
-	int ret;
-
-	switch (sha->type) {
-	case CCP_SHA_TYPE_1:
-		if (sha->ctx_len < SHA1_DIGEST_SIZE)
-			return -EINVAL;
-		block_size = SHA1_BLOCK_SIZE;
-		break;
-	case CCP_SHA_TYPE_224:
-		if (sha->ctx_len < SHA224_DIGEST_SIZE)
-			return -EINVAL;
-		block_size = SHA224_BLOCK_SIZE;
-		break;
-	case CCP_SHA_TYPE_256:
-		if (sha->ctx_len < SHA256_DIGEST_SIZE)
-			return -EINVAL;
-		block_size = SHA256_BLOCK_SIZE;
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	if (!sha->ctx)
-		return -EINVAL;
-
-	if (!sha->final && (sha->src_len & (block_size - 1)))
-		return -EINVAL;
-
-	/* The version 3 device can't handle zero-length input */
-	if (cmd_q->ccp->vdata->version == CCP_VERSION(3, 0)) {
-
-		if (!sha->src_len) {
-			unsigned int digest_len;
-			const u8 *sha_zero;
-
-			/* Not final, just return */
-			if (!sha->final)
-				return 0;
-
-			/* CCP can't do a zero length sha operation so the
-			 * caller must buffer the data.
-			 */
-			if (sha->msg_bits)
-				return -EINVAL;
-
-			/* The CCP cannot perform zero-length sha operations
-			 * so the caller is required to buffer data for the
-			 * final operation. However, a sha operation for a
-			 * message with a total length of zero is valid so
-			 * known values are required to supply the result.
-			 */
-			switch (sha->type) {
-			case CCP_SHA_TYPE_1:
-				sha_zero = sha1_zero_message_hash;
-				digest_len = SHA1_DIGEST_SIZE;
-				break;
-			case CCP_SHA_TYPE_224:
-				sha_zero = sha224_zero_message_hash;
-				digest_len = SHA224_DIGEST_SIZE;
-				break;
-			case CCP_SHA_TYPE_256:
-				sha_zero = sha256_zero_message_hash;
-				digest_len = SHA256_DIGEST_SIZE;
-				break;
-			default:
-				return -EINVAL;
-			}
-
-			scatterwalk_map_and_copy((void *)sha_zero, sha->ctx, 0,
-						 digest_len, 1);
-
-			return 0;
-		}
-	}
-
-	/* Set variables used throughout */
-	switch (sha->type) {
-	case CCP_SHA_TYPE_1:
-		digest_size = SHA1_DIGEST_SIZE;
-		init = (void *) ccp_sha1_init;
-		ctx_size = SHA1_DIGEST_SIZE;
-		sb_count = 1;
-		if (cmd_q->ccp->vdata->version != CCP_VERSION(3, 0))
-			ooffset = ioffset = CCP_SB_BYTES - SHA1_DIGEST_SIZE;
-		else
-			ooffset = ioffset = 0;
-		break;
-	case CCP_SHA_TYPE_224:
-		digest_size = SHA224_DIGEST_SIZE;
-		init = (void *) ccp_sha224_init;
-		ctx_size = SHA256_DIGEST_SIZE;
-		sb_count = 1;
-		ioffset = 0;
-		if (cmd_q->ccp->vdata->version != CCP_VERSION(3, 0))
-			ooffset = CCP_SB_BYTES - SHA224_DIGEST_SIZE;
-		else
-			ooffset = 0;
-		break;
-	case CCP_SHA_TYPE_256:
-		digest_size = SHA256_DIGEST_SIZE;
-		init = (void *) ccp_sha256_init;
-		ctx_size = SHA256_DIGEST_SIZE;
-		sb_count = 1;
-		ooffset = ioffset = 0;
-		break;
-	default:
-		ret = -EINVAL;
-		goto e_data;
-	}
-
-	/* For zero-length plaintext the src pointer is ignored;
-	 * otherwise both parts must be valid
-	 */
-	if (sha->src_len && !sha->src)
-		return -EINVAL;
-
-	memset(&op, 0, sizeof(op));
-	op.cmd_q = cmd_q;
-	op.jobid = CCP_NEW_JOBID(cmd_q->ccp);
-	op.sb_ctx = cmd_q->sb_ctx; /* Pre-allocated */
-	op.u.sha.type = sha->type;
-	op.u.sha.msg_bits = sha->msg_bits;
-
-	ret = ccp_init_dm_workarea(&ctx, cmd_q, sb_count * CCP_SB_BYTES,
-				   DMA_BIDIRECTIONAL);
-	if (ret)
-		return ret;
-	if (sha->first) {
-		switch (sha->type) {
-		case CCP_SHA_TYPE_1:
-		case CCP_SHA_TYPE_224:
-		case CCP_SHA_TYPE_256:
-			memcpy(ctx.address + ioffset, init, ctx_size);
-			break;
-		default:
-			ret = -EINVAL;
-			goto e_ctx;
-		}
-	} else {
-		/* Restore the context */
-		ccp_set_dm_area(&ctx, 0, sha->ctx, 0,
-				sb_count * CCP_SB_BYTES);
-	}
-
-	ret = ccp_copy_to_sb(cmd_q, &ctx, op.jobid, op.sb_ctx,
-			     CCP_PASSTHRU_BYTESWAP_256BIT);
-	if (ret) {
-		cmd->engine_error = cmd_q->cmd_error;
-		goto e_ctx;
-	}
-
-	if (sha->src) {
-		/* Send data to the CCP SHA engine; block_size is set above */
-		ret = ccp_init_data(&src, cmd_q, sha->src, sha->src_len,
-				    block_size, DMA_TO_DEVICE);
-		if (ret)
-			goto e_ctx;
-
-		while (src.sg_wa.bytes_left) {
-			ccp_prepare_data(&src, NULL, &op, block_size, false);
-			if (sha->final && !src.sg_wa.bytes_left)
-				op.eom = 1;
-
-			ret = cmd_q->ccp->vdata->perform->sha(&op);
-			if (ret) {
-				cmd->engine_error = cmd_q->cmd_error;
-				goto e_data;
-			}
-
-			ccp_process_data(&src, NULL, &op);
-		}
-	} else {
-		op.eom = 1;
-		ret = cmd_q->ccp->vdata->perform->sha(&op);
-		if (ret) {
-			cmd->engine_error = cmd_q->cmd_error;
-			goto e_data;
-		}
-	}
-
-	/* Retrieve the SHA context - convert from LE to BE using
-	 * 32-byte (256-bit) byteswapping to BE
-	 */
-	ret = ccp_copy_from_sb(cmd_q, &ctx, op.jobid, op.sb_ctx,
-			       CCP_PASSTHRU_BYTESWAP_256BIT);
-	if (ret) {
-		cmd->engine_error = cmd_q->cmd_error;
-		goto e_data;
-	}
-
-	if (sha->final) {
-		/* Finishing up, so get the digest */
-		switch (sha->type) {
-		case CCP_SHA_TYPE_1:
-		case CCP_SHA_TYPE_224:
-		case CCP_SHA_TYPE_256:
-			ccp_get_dm_area(&ctx, ooffset,
-					sha->ctx, 0,
-					digest_size);
-			break;
-		default:
-			ret = -EINVAL;
-			goto e_ctx;
-		}
-	} else {
-		/* Stash the context */
-		ccp_get_dm_area(&ctx, 0, sha->ctx, 0,
-				sb_count * CCP_SB_BYTES);
-	}
-
-	if (sha->final && sha->opad) {
-		/* HMAC operation, recursively perform final SHA */
-		struct ccp_cmd hmac_cmd;
-		struct scatterlist sg;
-		u8 *hmac_buf;
-
-		if (sha->opad_len != block_size) {
-			ret = -EINVAL;
-			goto e_data;
-		}
-
-		hmac_buf = kmalloc(block_size + digest_size, GFP_KERNEL);
-		if (!hmac_buf) {
-			ret = -ENOMEM;
-			goto e_data;
-		}
-		sg_init_one(&sg, hmac_buf, block_size + digest_size);
-
-		scatterwalk_map_and_copy(hmac_buf, sha->opad, 0, block_size, 0);
-		switch (sha->type) {
-		case CCP_SHA_TYPE_1:
-		case CCP_SHA_TYPE_224:
-		case CCP_SHA_TYPE_256:
-			memcpy(hmac_buf + block_size,
-			       ctx.address + ooffset,
-			       digest_size);
-			break;
-		default:
-			ret = -EINVAL;
-			goto e_ctx;
-		}
-
-		memset(&hmac_cmd, 0, sizeof(hmac_cmd));
-		hmac_cmd.engine = CCP_ENGINE_SHA;
-		hmac_cmd.u.sha.type = sha->type;
-		hmac_cmd.u.sha.ctx = sha->ctx;
-		hmac_cmd.u.sha.ctx_len = sha->ctx_len;
-		hmac_cmd.u.sha.src = &sg;
-		hmac_cmd.u.sha.src_len = block_size + digest_size;
-		hmac_cmd.u.sha.opad = NULL;
-		hmac_cmd.u.sha.opad_len = 0;
-		hmac_cmd.u.sha.first = 1;
-		hmac_cmd.u.sha.final = 1;
-		hmac_cmd.u.sha.msg_bits = (block_size + digest_size) << 3;
-
-		ret = ccp_run_sha_cmd(cmd_q, &hmac_cmd);
-		if (ret)
-			cmd->engine_error = hmac_cmd.engine_error;
-
-		kfree(hmac_buf);
-	}
-
-e_data:
-	if (sha->src)
-		ccp_free_data(&src, cmd_q);
-
-e_ctx:
-	ccp_dm_free(&ctx);
-
-	return ret;
-}
-
-static int ccp_run_rsa_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
-{
-	struct ccp_rsa_engine *rsa = &cmd->u.rsa;
-	struct ccp_dm_workarea exp, src;
-	struct ccp_data dst;
-	struct ccp_op op;
-	unsigned int sb_count, i_len, o_len;
-	int ret;
-
-	if (rsa->key_size > CCP_RSA_MAX_WIDTH)
-		return -EINVAL;
-
-	if (!rsa->exp || !rsa->mod || !rsa->src || !rsa->dst)
-		return -EINVAL;
-
-	/* The RSA modulus must precede the message being acted upon, so
-	 * it must be copied to a DMA area where the message and the
-	 * modulus can be concatenated.  Therefore the input buffer
-	 * length required is twice the output buffer length (which
-	 * must be a multiple of 256-bits).
-	 */
-	o_len = ((rsa->key_size + 255) / 256) * 32;
-	i_len = o_len * 2;
-
-	sb_count = o_len / CCP_SB_BYTES;
-
-	memset(&op, 0, sizeof(op));
-	op.cmd_q = cmd_q;
-	op.jobid = ccp_gen_jobid(cmd_q->ccp);
-	op.sb_key = cmd_q->ccp->vdata->perform->sballoc(cmd_q, sb_count);
-
-	if (!op.sb_key)
-		return -EIO;
-
-	/* The RSA exponent may span multiple (32-byte) SB entries and must
-	 * be in little endian format. Reverse copy each 32-byte chunk
-	 * of the exponent (En chunk to E0 chunk, E(n-1) chunk to E1 chunk)
-	 * and each byte within that chunk and do not perform any byte swap
-	 * operations on the passthru operation.
-	 */
-	ret = ccp_init_dm_workarea(&exp, cmd_q, o_len, DMA_TO_DEVICE);
-	if (ret)
-		goto e_sb;
-
-	ret = ccp_reverse_set_dm_area(&exp, rsa->exp, rsa->exp_len,
-				      CCP_SB_BYTES, false);
-	if (ret)
-		goto e_exp;
-	ret = ccp_copy_to_sb(cmd_q, &exp, op.jobid, op.sb_key,
-			     CCP_PASSTHRU_BYTESWAP_NOOP);
-	if (ret) {
-		cmd->engine_error = cmd_q->cmd_error;
-		goto e_exp;
-	}
-
-	/* Concatenate the modulus and the message. Both the modulus and
-	 * the operands must be in little endian format.  Since the input
-	 * is in big endian format it must be converted.
-	 */
-	ret = ccp_init_dm_workarea(&src, cmd_q, i_len, DMA_TO_DEVICE);
-	if (ret)
-		goto e_exp;
-
-	ret = ccp_reverse_set_dm_area(&src, rsa->mod, rsa->mod_len,
-				      CCP_SB_BYTES, false);
-	if (ret)
-		goto e_src;
-	src.address += o_len;	/* Adjust the address for the copy operation */
-	ret = ccp_reverse_set_dm_area(&src, rsa->src, rsa->src_len,
-				      CCP_SB_BYTES, false);
-	if (ret)
-		goto e_src;
-	src.address -= o_len;	/* Reset the address to original value */
-
-	/* Prepare the output area for the operation */
-	ret = ccp_init_data(&dst, cmd_q, rsa->dst, rsa->mod_len,
-			    o_len, DMA_FROM_DEVICE);
-	if (ret)
-		goto e_src;
-
-	op.soc = 1;
-	op.src.u.dma.address = src.dma.address;
-	op.src.u.dma.offset = 0;
-	op.src.u.dma.length = i_len;
-	op.dst.u.dma.address = dst.dm_wa.dma.address;
-	op.dst.u.dma.offset = 0;
-	op.dst.u.dma.length = o_len;
-
-	op.u.rsa.mod_size = rsa->key_size;
-	op.u.rsa.input_len = i_len;
-
-	ret = cmd_q->ccp->vdata->perform->rsa(&op);
-	if (ret) {
-		cmd->engine_error = cmd_q->cmd_error;
-		goto e_dst;
-	}
-
-	ccp_reverse_get_dm_area(&dst.dm_wa, rsa->dst, rsa->mod_len);
-
-e_dst:
-	ccp_free_data(&dst, cmd_q);
-
-e_src:
-	ccp_dm_free(&src);
-
-e_exp:
-	ccp_dm_free(&exp);
-
-e_sb:
-	cmd_q->ccp->vdata->perform->sbfree(cmd_q, op.sb_key, sb_count);
-
-	return ret;
-}
-
-static int ccp_run_passthru_cmd(struct ccp_cmd_queue *cmd_q,
-				struct ccp_cmd *cmd)
-{
-	struct ccp_passthru_engine *pt = &cmd->u.passthru;
-	struct ccp_dm_workarea mask;
-	struct ccp_data src, dst;
-	struct ccp_op op;
-	bool in_place = false;
-	unsigned int i;
-	int ret = 0;
-
-	if (!pt->final && (pt->src_len & (CCP_PASSTHRU_BLOCKSIZE - 1)))
-		return -EINVAL;
-
-	if (!pt->src || !pt->dst)
-		return -EINVAL;
-
-	if (pt->bit_mod != CCP_PASSTHRU_BITWISE_NOOP) {
-		if (pt->mask_len != CCP_PASSTHRU_MASKSIZE)
-			return -EINVAL;
-		if (!pt->mask)
-			return -EINVAL;
-	}
-
-	BUILD_BUG_ON(CCP_PASSTHRU_SB_COUNT != 1);
-
-	memset(&op, 0, sizeof(op));
-	op.cmd_q = cmd_q;
-	op.jobid = CCP_NEW_JOBID(cmd_q->ccp);
-
-	if (pt->bit_mod != CCP_PASSTHRU_BITWISE_NOOP) {
-		/* Load the mask */
-		op.sb_key = cmd_q->sb_key;
-
-		ret = ccp_init_dm_workarea(&mask, cmd_q,
-					   CCP_PASSTHRU_SB_COUNT *
-					   CCP_SB_BYTES,
-					   DMA_TO_DEVICE);
-		if (ret)
-			return ret;
-
-		ccp_set_dm_area(&mask, 0, pt->mask, 0, pt->mask_len);
-		ret = ccp_copy_to_sb(cmd_q, &mask, op.jobid, op.sb_key,
-				     CCP_PASSTHRU_BYTESWAP_NOOP);
-		if (ret) {
-			cmd->engine_error = cmd_q->cmd_error;
-			goto e_mask;
-		}
-	}
-
-	/* Prepare the input and output data workareas. For in-place
-	 * operations we need to set the dma direction to BIDIRECTIONAL
-	 * and copy the src workarea to the dst workarea.
-	 */
-	if (sg_virt(pt->src) == sg_virt(pt->dst))
-		in_place = true;
-
-	ret = ccp_init_data(&src, cmd_q, pt->src, pt->src_len,
-			    CCP_PASSTHRU_MASKSIZE,
-			    in_place ? DMA_BIDIRECTIONAL : DMA_TO_DEVICE);
-	if (ret)
-		goto e_mask;
-
-	if (in_place) {
-		dst = src;
-	} else {
-		ret = ccp_init_data(&dst, cmd_q, pt->dst, pt->src_len,
-				    CCP_PASSTHRU_MASKSIZE, DMA_FROM_DEVICE);
-		if (ret)
-			goto e_src;
-	}
-
-	/* Send data to the CCP Passthru engine
-	 *   Because the CCP engine works on a single source and destination
-	 *   dma address at a time, each entry in the source scatterlist
-	 *   (after the dma_map_sg call) must be less than or equal to the
-	 *   (remaining) length in the destination scatterlist entry and the
-	 *   length must be a multiple of CCP_PASSTHRU_BLOCKSIZE
-	 */
-	dst.sg_wa.sg_used = 0;
-	for (i = 1; i <= src.sg_wa.dma_count; i++) {
-		if (!dst.sg_wa.sg ||
-		    (dst.sg_wa.sg->length < src.sg_wa.sg->length)) {
-			ret = -EINVAL;
-			goto e_dst;
-		}
-
-		if (i == src.sg_wa.dma_count) {
-			op.eom = 1;
-			op.soc = 1;
-		}
-
-		op.src.type = CCP_MEMTYPE_SYSTEM;
-		op.src.u.dma.address = sg_dma_address(src.sg_wa.sg);
-		op.src.u.dma.offset = 0;
-		op.src.u.dma.length = sg_dma_len(src.sg_wa.sg);
-
-		op.dst.type = CCP_MEMTYPE_SYSTEM;
-		op.dst.u.dma.address = sg_dma_address(dst.sg_wa.sg);
-		op.dst.u.dma.offset = dst.sg_wa.sg_used;
-		op.dst.u.dma.length = op.src.u.dma.length;
-
-		ret = cmd_q->ccp->vdata->perform->passthru(&op);
-		if (ret) {
-			cmd->engine_error = cmd_q->cmd_error;
-			goto e_dst;
-		}
-
-		dst.sg_wa.sg_used += src.sg_wa.sg->length;
-		if (dst.sg_wa.sg_used == dst.sg_wa.sg->length) {
-			dst.sg_wa.sg = sg_next(dst.sg_wa.sg);
-			dst.sg_wa.sg_used = 0;
-		}
-		src.sg_wa.sg = sg_next(src.sg_wa.sg);
-	}
-
-e_dst:
-	if (!in_place)
-		ccp_free_data(&dst, cmd_q);
-
-e_src:
-	ccp_free_data(&src, cmd_q);
-
-e_mask:
-	if (pt->bit_mod != CCP_PASSTHRU_BITWISE_NOOP)
-		ccp_dm_free(&mask);
-
-	return ret;
-}
-
-static int ccp_run_passthru_nomap_cmd(struct ccp_cmd_queue *cmd_q,
-				      struct ccp_cmd *cmd)
-{
-	struct ccp_passthru_nomap_engine *pt = &cmd->u.passthru_nomap;
-	struct ccp_dm_workarea mask;
-	struct ccp_op op;
-	int ret;
-
-	if (!pt->final && (pt->src_len & (CCP_PASSTHRU_BLOCKSIZE - 1)))
-		return -EINVAL;
-
-	if (!pt->src_dma || !pt->dst_dma)
-		return -EINVAL;
-
-	if (pt->bit_mod != CCP_PASSTHRU_BITWISE_NOOP) {
-		if (pt->mask_len != CCP_PASSTHRU_MASKSIZE)
-			return -EINVAL;
-		if (!pt->mask)
-			return -EINVAL;
-	}
-
-	BUILD_BUG_ON(CCP_PASSTHRU_SB_COUNT != 1);
-
-	memset(&op, 0, sizeof(op));
-	op.cmd_q = cmd_q;
-	op.jobid = ccp_gen_jobid(cmd_q->ccp);
-
-	if (pt->bit_mod != CCP_PASSTHRU_BITWISE_NOOP) {
-		/* Load the mask */
-		op.sb_key = cmd_q->sb_key;
-
-		mask.length = pt->mask_len;
-		mask.dma.address = pt->mask;
-		mask.dma.length = pt->mask_len;
-
-		ret = ccp_copy_to_sb(cmd_q, &mask, op.jobid, op.sb_key,
-				     CCP_PASSTHRU_BYTESWAP_NOOP);
-		if (ret) {
-			cmd->engine_error = cmd_q->cmd_error;
-			return ret;
-		}
-	}
-
-	/* Send data to the CCP Passthru engine */
-	op.eom = 1;
-	op.soc = 1;
-
-	op.src.type = CCP_MEMTYPE_SYSTEM;
-	op.src.u.dma.address = pt->src_dma;
-	op.src.u.dma.offset = 0;
-	op.src.u.dma.length = pt->src_len;
-
-	op.dst.type = CCP_MEMTYPE_SYSTEM;
-	op.dst.u.dma.address = pt->dst_dma;
-	op.dst.u.dma.offset = 0;
-	op.dst.u.dma.length = pt->src_len;
-
-	ret = cmd_q->ccp->vdata->perform->passthru(&op);
-	if (ret)
-		cmd->engine_error = cmd_q->cmd_error;
-
-	return ret;
-}
-
-static int ccp_run_ecc_mm_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
-{
-	struct ccp_ecc_engine *ecc = &cmd->u.ecc;
-	struct ccp_dm_workarea src, dst;
-	struct ccp_op op;
-	int ret;
-	u8 *save;
-
-	if (!ecc->u.mm.operand_1 ||
-	    (ecc->u.mm.operand_1_len > CCP_ECC_MODULUS_BYTES))
-		return -EINVAL;
-
-	if (ecc->function != CCP_ECC_FUNCTION_MINV_384BIT)
-		if (!ecc->u.mm.operand_2 ||
-		    (ecc->u.mm.operand_2_len > CCP_ECC_MODULUS_BYTES))
-			return -EINVAL;
-
-	if (!ecc->u.mm.result ||
-	    (ecc->u.mm.result_len < CCP_ECC_MODULUS_BYTES))
-		return -EINVAL;
-
-	memset(&op, 0, sizeof(op));
-	op.cmd_q = cmd_q;
-	op.jobid = CCP_NEW_JOBID(cmd_q->ccp);
-
-	/* Concatenate the modulus and the operands. Both the modulus and
-	 * the operands must be in little endian format.  Since the input
-	 * is in big endian format it must be converted and placed in a
-	 * fixed length buffer.
-	 */
-	ret = ccp_init_dm_workarea(&src, cmd_q, CCP_ECC_SRC_BUF_SIZE,
-				   DMA_TO_DEVICE);
-	if (ret)
-		return ret;
-
-	/* Save the workarea address since it is updated in order to perform
-	 * the concatenation
-	 */
-	save = src.address;
-
-	/* Copy the ECC modulus */
-	ret = ccp_reverse_set_dm_area(&src, ecc->mod, ecc->mod_len,
-				      CCP_ECC_OPERAND_SIZE, false);
-	if (ret)
-		goto e_src;
-	src.address += CCP_ECC_OPERAND_SIZE;
-
-	/* Copy the first operand */
-	ret = ccp_reverse_set_dm_area(&src, ecc->u.mm.operand_1,
-				      ecc->u.mm.operand_1_len,
-				      CCP_ECC_OPERAND_SIZE, false);
-	if (ret)
-		goto e_src;
-	src.address += CCP_ECC_OPERAND_SIZE;
-
-	if (ecc->function != CCP_ECC_FUNCTION_MINV_384BIT) {
-		/* Copy the second operand */
-		ret = ccp_reverse_set_dm_area(&src, ecc->u.mm.operand_2,
-					      ecc->u.mm.operand_2_len,
-					      CCP_ECC_OPERAND_SIZE, false);
-		if (ret)
-			goto e_src;
-		src.address += CCP_ECC_OPERAND_SIZE;
-	}
-
-	/* Restore the workarea address */
-	src.address = save;
-
-	/* Prepare the output area for the operation */
-	ret = ccp_init_dm_workarea(&dst, cmd_q, CCP_ECC_DST_BUF_SIZE,
-				   DMA_FROM_DEVICE);
-	if (ret)
-		goto e_src;
-
-	op.soc = 1;
-	op.src.u.dma.address = src.dma.address;
-	op.src.u.dma.offset = 0;
-	op.src.u.dma.length = src.length;
-	op.dst.u.dma.address = dst.dma.address;
-	op.dst.u.dma.offset = 0;
-	op.dst.u.dma.length = dst.length;
-
-	op.u.ecc.function = cmd->u.ecc.function;
-
-	ret = cmd_q->ccp->vdata->perform->ecc(&op);
-	if (ret) {
-		cmd->engine_error = cmd_q->cmd_error;
-		goto e_dst;
-	}
-
-	ecc->ecc_result = le16_to_cpup(
-		(const __le16 *)(dst.address + CCP_ECC_RESULT_OFFSET));
-	if (!(ecc->ecc_result & CCP_ECC_RESULT_SUCCESS)) {
-		ret = -EIO;
-		goto e_dst;
-	}
-
-	/* Save the ECC result */
-	ccp_reverse_get_dm_area(&dst, ecc->u.mm.result, CCP_ECC_MODULUS_BYTES);
-
-e_dst:
-	ccp_dm_free(&dst);
-
-e_src:
-	ccp_dm_free(&src);
-
-	return ret;
-}
-
-static int ccp_run_ecc_pm_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
-{
-	struct ccp_ecc_engine *ecc = &cmd->u.ecc;
-	struct ccp_dm_workarea src, dst;
-	struct ccp_op op;
-	int ret;
-	u8 *save;
-
-	if (!ecc->u.pm.point_1.x ||
-	    (ecc->u.pm.point_1.x_len > CCP_ECC_MODULUS_BYTES) ||
-	    !ecc->u.pm.point_1.y ||
-	    (ecc->u.pm.point_1.y_len > CCP_ECC_MODULUS_BYTES))
-		return -EINVAL;
-
-	if (ecc->function == CCP_ECC_FUNCTION_PADD_384BIT) {
-		if (!ecc->u.pm.point_2.x ||
-		    (ecc->u.pm.point_2.x_len > CCP_ECC_MODULUS_BYTES) ||
-		    !ecc->u.pm.point_2.y ||
-		    (ecc->u.pm.point_2.y_len > CCP_ECC_MODULUS_BYTES))
-			return -EINVAL;
-	} else {
-		if (!ecc->u.pm.domain_a ||
-		    (ecc->u.pm.domain_a_len > CCP_ECC_MODULUS_BYTES))
-			return -EINVAL;
-
-		if (ecc->function == CCP_ECC_FUNCTION_PMUL_384BIT)
-			if (!ecc->u.pm.scalar ||
-			    (ecc->u.pm.scalar_len > CCP_ECC_MODULUS_BYTES))
-				return -EINVAL;
-	}
-
-	if (!ecc->u.pm.result.x ||
-	    (ecc->u.pm.result.x_len < CCP_ECC_MODULUS_BYTES) ||
-	    !ecc->u.pm.result.y ||
-	    (ecc->u.pm.result.y_len < CCP_ECC_MODULUS_BYTES))
-		return -EINVAL;
-
-	memset(&op, 0, sizeof(op));
-	op.cmd_q = cmd_q;
-	op.jobid = CCP_NEW_JOBID(cmd_q->ccp);
-
-	/* Concatenate the modulus and the operands. Both the modulus and
-	 * the operands must be in little endian format.  Since the input
-	 * is in big endian format it must be converted and placed in a
-	 * fixed length buffer.
-	 */
-	ret = ccp_init_dm_workarea(&src, cmd_q, CCP_ECC_SRC_BUF_SIZE,
-				   DMA_TO_DEVICE);
-	if (ret)
-		return ret;
-
-	/* Save the workarea address since it is updated in order to perform
-	 * the concatenation
-	 */
-	save = src.address;
-
-	/* Copy the ECC modulus */
-	ret = ccp_reverse_set_dm_area(&src, ecc->mod, ecc->mod_len,
-				      CCP_ECC_OPERAND_SIZE, false);
-	if (ret)
-		goto e_src;
-	src.address += CCP_ECC_OPERAND_SIZE;
-
-	/* Copy the first point X and Y coordinate */
-	ret = ccp_reverse_set_dm_area(&src, ecc->u.pm.point_1.x,
-				      ecc->u.pm.point_1.x_len,
-				      CCP_ECC_OPERAND_SIZE, false);
-	if (ret)
-		goto e_src;
-	src.address += CCP_ECC_OPERAND_SIZE;
-	ret = ccp_reverse_set_dm_area(&src, ecc->u.pm.point_1.y,
-				      ecc->u.pm.point_1.y_len,
-				      CCP_ECC_OPERAND_SIZE, false);
-	if (ret)
-		goto e_src;
-	src.address += CCP_ECC_OPERAND_SIZE;
-
-	/* Set the first point Z coordinate to 1 */
-	*src.address = 0x01;
-	src.address += CCP_ECC_OPERAND_SIZE;
-
-	if (ecc->function == CCP_ECC_FUNCTION_PADD_384BIT) {
-		/* Copy the second point X and Y coordinate */
-		ret = ccp_reverse_set_dm_area(&src, ecc->u.pm.point_2.x,
-					      ecc->u.pm.point_2.x_len,
-					      CCP_ECC_OPERAND_SIZE, false);
-		if (ret)
-			goto e_src;
-		src.address += CCP_ECC_OPERAND_SIZE;
-		ret = ccp_reverse_set_dm_area(&src, ecc->u.pm.point_2.y,
-					      ecc->u.pm.point_2.y_len,
-					      CCP_ECC_OPERAND_SIZE, false);
-		if (ret)
-			goto e_src;
-		src.address += CCP_ECC_OPERAND_SIZE;
-
-		/* Set the second point Z coordinate to 1 */
-		*src.address = 0x01;
-		src.address += CCP_ECC_OPERAND_SIZE;
-	} else {
-		/* Copy the Domain "a" parameter */
-		ret = ccp_reverse_set_dm_area(&src, ecc->u.pm.domain_a,
-					      ecc->u.pm.domain_a_len,
-					      CCP_ECC_OPERAND_SIZE, false);
-		if (ret)
-			goto e_src;
-		src.address += CCP_ECC_OPERAND_SIZE;
-
-		if (ecc->function == CCP_ECC_FUNCTION_PMUL_384BIT) {
-			/* Copy the scalar value */
-			ret = ccp_reverse_set_dm_area(&src, ecc->u.pm.scalar,
-						      ecc->u.pm.scalar_len,
-						      CCP_ECC_OPERAND_SIZE,
-						      false);
-			if (ret)
-				goto e_src;
-			src.address += CCP_ECC_OPERAND_SIZE;
-		}
-	}
-
-	/* Restore the workarea address */
-	src.address = save;
-
-	/* Prepare the output area for the operation */
-	ret = ccp_init_dm_workarea(&dst, cmd_q, CCP_ECC_DST_BUF_SIZE,
-				   DMA_FROM_DEVICE);
-	if (ret)
-		goto e_src;
-
-	op.soc = 1;
-	op.src.u.dma.address = src.dma.address;
-	op.src.u.dma.offset = 0;
-	op.src.u.dma.length = src.length;
-	op.dst.u.dma.address = dst.dma.address;
-	op.dst.u.dma.offset = 0;
-	op.dst.u.dma.length = dst.length;
-
-	op.u.ecc.function = cmd->u.ecc.function;
-
-	ret = cmd_q->ccp->vdata->perform->ecc(&op);
-	if (ret) {
-		cmd->engine_error = cmd_q->cmd_error;
-		goto e_dst;
-	}
-
-	ecc->ecc_result = le16_to_cpup(
-		(const __le16 *)(dst.address + CCP_ECC_RESULT_OFFSET));
-	if (!(ecc->ecc_result & CCP_ECC_RESULT_SUCCESS)) {
-		ret = -EIO;
-		goto e_dst;
-	}
-
-	/* Save the workarea address since it is updated as we walk through
-	 * to copy the point math result
-	 */
-	save = dst.address;
-
-	/* Save the ECC result X and Y coordinates */
-	ccp_reverse_get_dm_area(&dst, ecc->u.pm.result.x,
-				CCP_ECC_MODULUS_BYTES);
-	dst.address += CCP_ECC_OUTPUT_SIZE;
-	ccp_reverse_get_dm_area(&dst, ecc->u.pm.result.y,
-				CCP_ECC_MODULUS_BYTES);
-	dst.address += CCP_ECC_OUTPUT_SIZE;
-
-	/* Restore the workarea address */
-	dst.address = save;
-
-e_dst:
-	ccp_dm_free(&dst);
-
-e_src:
-	ccp_dm_free(&src);
-
-	return ret;
-}
-
-static int ccp_run_ecc_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
-{
-	struct ccp_ecc_engine *ecc = &cmd->u.ecc;
-
-	ecc->ecc_result = 0;
-
-	if (!ecc->mod ||
-	    (ecc->mod_len > CCP_ECC_MODULUS_BYTES))
-		return -EINVAL;
-
-	switch (ecc->function) {
-	case CCP_ECC_FUNCTION_MMUL_384BIT:
-	case CCP_ECC_FUNCTION_MADD_384BIT:
-	case CCP_ECC_FUNCTION_MINV_384BIT:
-		return ccp_run_ecc_mm_cmd(cmd_q, cmd);
-
-	case CCP_ECC_FUNCTION_PADD_384BIT:
-	case CCP_ECC_FUNCTION_PMUL_384BIT:
-	case CCP_ECC_FUNCTION_PDBL_384BIT:
-		return ccp_run_ecc_pm_cmd(cmd_q, cmd);
-
-	default:
-		return -EINVAL;
-	}
-}
-
-int ccp_run_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
-{
-	int ret;
-
-	cmd->engine_error = 0;
-	cmd_q->cmd_error = 0;
-	cmd_q->int_rcvd = 0;
-	cmd_q->free_slots = cmd_q->ccp->vdata->perform->get_free_slots(cmd_q);
-
-	switch (cmd->engine) {
-	case CCP_ENGINE_AES:
-		ret = ccp_run_aes_cmd(cmd_q, cmd);
-		break;
-	case CCP_ENGINE_XTS_AES_128:
-		ret = ccp_run_xts_aes_cmd(cmd_q, cmd);
-		break;
-	case CCP_ENGINE_SHA:
-		ret = ccp_run_sha_cmd(cmd_q, cmd);
-		break;
-	case CCP_ENGINE_RSA:
-		ret = ccp_run_rsa_cmd(cmd_q, cmd);
-		break;
-	case CCP_ENGINE_PASSTHRU:
-		if (cmd->flags & CCP_CMD_PASSTHRU_NO_DMA_MAP)
-			ret = ccp_run_passthru_nomap_cmd(cmd_q, cmd);
-		else
-			ret = ccp_run_passthru_cmd(cmd_q, cmd);
-		break;
-	case CCP_ENGINE_ECC:
-		ret = ccp_run_ecc_cmd(cmd_q, cmd);
-		break;
-	default:
-		ret = -EINVAL;
-	}
-
-	return ret;
-}
diff --git a/drivers/crypto/ccp/ccp-pci.c b/drivers/crypto/ccp/ccp-pci.c
deleted file mode 100644
index 28a9996..0000000
--- a/drivers/crypto/ccp/ccp-pci.c
+++ /dev/null
@@ -1,354 +0,0 @@
-/*
- * AMD Cryptographic Coprocessor (CCP) driver
- *
- * Copyright (C) 2013,2016 Advanced Micro Devices, Inc.
- *
- * Author: Tom Lendacky <thomas.lendacky@amd.com>
- * Author: Gary R Hook <gary.hook@amd.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/device.h>
-#include <linux/pci.h>
-#include <linux/pci_ids.h>
-#include <linux/dma-mapping.h>
-#include <linux/kthread.h>
-#include <linux/sched.h>
-#include <linux/interrupt.h>
-#include <linux/spinlock.h>
-#include <linux/delay.h>
-#include <linux/ccp.h>
-
-#include "ccp-dev.h"
-
-#define MSIX_VECTORS			2
-
-struct ccp_msix {
-	u32 vector;
-	char name[16];
-};
-
-struct ccp_pci {
-	int msix_count;
-	struct ccp_msix msix[MSIX_VECTORS];
-};
-
-static int ccp_get_msix_irqs(struct ccp_device *ccp)
-{
-	struct ccp_pci *ccp_pci = ccp->dev_specific;
-	struct device *dev = ccp->dev;
-	struct pci_dev *pdev = to_pci_dev(dev);
-	struct msix_entry msix_entry[MSIX_VECTORS];
-	unsigned int name_len = sizeof(ccp_pci->msix[0].name) - 1;
-	int v, ret;
-
-	for (v = 0; v < ARRAY_SIZE(msix_entry); v++)
-		msix_entry[v].entry = v;
-
-	ret = pci_enable_msix_range(pdev, msix_entry, 1, v);
-	if (ret < 0)
-		return ret;
-
-	ccp_pci->msix_count = ret;
-	for (v = 0; v < ccp_pci->msix_count; v++) {
-		/* Set the interrupt names and request the irqs */
-		snprintf(ccp_pci->msix[v].name, name_len, "%s-%u",
-			 ccp->name, v);
-		ccp_pci->msix[v].vector = msix_entry[v].vector;
-		ret = request_irq(ccp_pci->msix[v].vector,
-				  ccp->vdata->perform->irqhandler,
-				  0, ccp_pci->msix[v].name, dev);
-		if (ret) {
-			dev_notice(dev, "unable to allocate MSI-X IRQ (%d)\n",
-				   ret);
-			goto e_irq;
-		}
-	}
-
-	return 0;
-
-e_irq:
-	while (v--)
-		free_irq(ccp_pci->msix[v].vector, dev);
-
-	pci_disable_msix(pdev);
-
-	ccp_pci->msix_count = 0;
-
-	return ret;
-}
-
-static int ccp_get_msi_irq(struct ccp_device *ccp)
-{
-	struct device *dev = ccp->dev;
-	struct pci_dev *pdev = to_pci_dev(dev);
-	int ret;
-
-	ret = pci_enable_msi(pdev);
-	if (ret)
-		return ret;
-
-	ccp->irq = pdev->irq;
-	ret = request_irq(ccp->irq, ccp->vdata->perform->irqhandler, 0,
-			  ccp->name, dev);
-	if (ret) {
-		dev_notice(dev, "unable to allocate MSI IRQ (%d)\n", ret);
-		goto e_msi;
-	}
-
-	return 0;
-
-e_msi:
-	pci_disable_msi(pdev);
-
-	return ret;
-}
-
-static int ccp_get_irqs(struct ccp_device *ccp)
-{
-	struct device *dev = ccp->dev;
-	int ret;
-
-	ret = ccp_get_msix_irqs(ccp);
-	if (!ret)
-		return 0;
-
-	/* Couldn't get MSI-X vectors, try MSI */
-	dev_notice(dev, "could not enable MSI-X (%d), trying MSI\n", ret);
-	ret = ccp_get_msi_irq(ccp);
-	if (!ret)
-		return 0;
-
-	/* Couldn't get MSI interrupt */
-	dev_notice(dev, "could not enable MSI (%d)\n", ret);
-
-	return ret;
-}
-
-static void ccp_free_irqs(struct ccp_device *ccp)
-{
-	struct ccp_pci *ccp_pci = ccp->dev_specific;
-	struct device *dev = ccp->dev;
-	struct pci_dev *pdev = to_pci_dev(dev);
-
-	if (ccp_pci->msix_count) {
-		while (ccp_pci->msix_count--)
-			free_irq(ccp_pci->msix[ccp_pci->msix_count].vector,
-				 dev);
-		pci_disable_msix(pdev);
-	} else if (ccp->irq) {
-		free_irq(ccp->irq, dev);
-		pci_disable_msi(pdev);
-	}
-	ccp->irq = 0;
-}
-
-static int ccp_find_mmio_area(struct ccp_device *ccp)
-{
-	struct device *dev = ccp->dev;
-	struct pci_dev *pdev = to_pci_dev(dev);
-	resource_size_t io_len;
-	unsigned long io_flags;
-
-	io_flags = pci_resource_flags(pdev, ccp->vdata->bar);
-	io_len = pci_resource_len(pdev, ccp->vdata->bar);
-	if ((io_flags & IORESOURCE_MEM) &&
-	    (io_len >= (ccp->vdata->offset + 0x800)))
-		return ccp->vdata->bar;
-
-	return -EIO;
-}
-
-static int ccp_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
-{
-	struct ccp_device *ccp;
-	struct ccp_pci *ccp_pci;
-	struct device *dev = &pdev->dev;
-	unsigned int bar;
-	int ret;
-
-	ret = -ENOMEM;
-	ccp = ccp_alloc_struct(dev);
-	if (!ccp)
-		goto e_err;
-
-	ccp_pci = devm_kzalloc(dev, sizeof(*ccp_pci), GFP_KERNEL);
-	if (!ccp_pci)
-		goto e_err;
-
-	ccp->dev_specific = ccp_pci;
-	ccp->vdata = (struct ccp_vdata *)id->driver_data;
-	if (!ccp->vdata || !ccp->vdata->version) {
-		ret = -ENODEV;
-		dev_err(dev, "missing driver data\n");
-		goto e_err;
-	}
-	ccp->get_irq = ccp_get_irqs;
-	ccp->free_irq = ccp_free_irqs;
-
-	ret = pci_request_regions(pdev, "ccp");
-	if (ret) {
-		dev_err(dev, "pci_request_regions failed (%d)\n", ret);
-		goto e_err;
-	}
-
-	ret = pci_enable_device(pdev);
-	if (ret) {
-		dev_err(dev, "pci_enable_device failed (%d)\n", ret);
-		goto e_regions;
-	}
-
-	pci_set_master(pdev);
-
-	ret = ccp_find_mmio_area(ccp);
-	if (ret < 0)
-		goto e_device;
-	bar = ret;
-
-	ret = -EIO;
-	ccp->io_map = pci_iomap(pdev, bar, 0);
-	if (!ccp->io_map) {
-		dev_err(dev, "pci_iomap failed\n");
-		goto e_device;
-	}
-	ccp->io_regs = ccp->io_map + ccp->vdata->offset;
-
-	ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(48));
-	if (ret) {
-		ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32));
-		if (ret) {
-			dev_err(dev, "dma_set_mask_and_coherent failed (%d)\n",
-				ret);
-			goto e_iomap;
-		}
-	}
-
-	dev_set_drvdata(dev, ccp);
-
-	if (ccp->vdata->setup)
-		ccp->vdata->setup(ccp);
-
-	ret = ccp->vdata->perform->init(ccp);
-	if (ret)
-		goto e_iomap;
-
-	dev_notice(dev, "enabled\n");
-
-	return 0;
-
-e_iomap:
-	pci_iounmap(pdev, ccp->io_map);
-
-e_device:
-	pci_disable_device(pdev);
-
-e_regions:
-	pci_release_regions(pdev);
-
-e_err:
-	dev_notice(dev, "initialization failed\n");
-	return ret;
-}
-
-static void ccp_pci_remove(struct pci_dev *pdev)
-{
-	struct device *dev = &pdev->dev;
-	struct ccp_device *ccp = dev_get_drvdata(dev);
-
-	if (!ccp)
-		return;
-
-	ccp->vdata->perform->destroy(ccp);
-
-	pci_iounmap(pdev, ccp->io_map);
-
-	pci_disable_device(pdev);
-
-	pci_release_regions(pdev);
-
-	dev_notice(dev, "disabled\n");
-}
-
-#ifdef CONFIG_PM
-static int ccp_pci_suspend(struct pci_dev *pdev, pm_message_t state)
-{
-	struct device *dev = &pdev->dev;
-	struct ccp_device *ccp = dev_get_drvdata(dev);
-	unsigned long flags;
-	unsigned int i;
-
-	spin_lock_irqsave(&ccp->cmd_lock, flags);
-
-	ccp->suspending = 1;
-
-	/* Wake all the queue kthreads to prepare for suspend */
-	for (i = 0; i < ccp->cmd_q_count; i++)
-		wake_up_process(ccp->cmd_q[i].kthread);
-
-	spin_unlock_irqrestore(&ccp->cmd_lock, flags);
-
-	/* Wait for all queue kthreads to say they're done */
-	while (!ccp_queues_suspended(ccp))
-		wait_event_interruptible(ccp->suspend_queue,
-					 ccp_queues_suspended(ccp));
-
-	return 0;
-}
-
-static int ccp_pci_resume(struct pci_dev *pdev)
-{
-	struct device *dev = &pdev->dev;
-	struct ccp_device *ccp = dev_get_drvdata(dev);
-	unsigned long flags;
-	unsigned int i;
-
-	spin_lock_irqsave(&ccp->cmd_lock, flags);
-
-	ccp->suspending = 0;
-
-	/* Wake up all the kthreads */
-	for (i = 0; i < ccp->cmd_q_count; i++) {
-		ccp->cmd_q[i].suspended = 0;
-		wake_up_process(ccp->cmd_q[i].kthread);
-	}
-
-	spin_unlock_irqrestore(&ccp->cmd_lock, flags);
-
-	return 0;
-}
-#endif
-
-static const struct pci_device_id ccp_pci_table[] = {
-	{ PCI_VDEVICE(AMD, 0x1537), (kernel_ulong_t)&ccpv3 },
-	{ PCI_VDEVICE(AMD, 0x1456), (kernel_ulong_t)&ccpv5a },
-	{ PCI_VDEVICE(AMD, 0x1468), (kernel_ulong_t)&ccpv5b },
-	/* Last entry must be zero */
-	{ 0, }
-};
-MODULE_DEVICE_TABLE(pci, ccp_pci_table);
-
-static struct pci_driver ccp_pci_driver = {
-	.name = "ccp",
-	.id_table = ccp_pci_table,
-	.probe = ccp_pci_probe,
-	.remove = ccp_pci_remove,
-#ifdef CONFIG_PM
-	.suspend = ccp_pci_suspend,
-	.resume = ccp_pci_resume,
-#endif
-};
-
-int ccp_pci_init(void)
-{
-	return pci_register_driver(&ccp_pci_driver);
-}
-
-void ccp_pci_exit(void)
-{
-	pci_unregister_driver(&ccp_pci_driver);
-}
diff --git a/drivers/crypto/ccp/ccp-platform.c b/drivers/crypto/ccp/ccp-platform.c
deleted file mode 100644
index 351f28d8..0000000
--- a/drivers/crypto/ccp/ccp-platform.c
+++ /dev/null
@@ -1,293 +0,0 @@
-/*
- * AMD Cryptographic Coprocessor (CCP) driver
- *
- * Copyright (C) 2014,2016 Advanced Micro Devices, Inc.
- *
- * Author: Tom Lendacky <thomas.lendacky@amd.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/device.h>
-#include <linux/platform_device.h>
-#include <linux/ioport.h>
-#include <linux/dma-mapping.h>
-#include <linux/kthread.h>
-#include <linux/sched.h>
-#include <linux/interrupt.h>
-#include <linux/spinlock.h>
-#include <linux/delay.h>
-#include <linux/ccp.h>
-#include <linux/of.h>
-#include <linux/of_address.h>
-#include <linux/acpi.h>
-
-#include "ccp-dev.h"
-
-struct ccp_platform {
-	int coherent;
-};
-
-static const struct acpi_device_id ccp_acpi_match[];
-static const struct of_device_id ccp_of_match[];
-
-static struct ccp_vdata *ccp_get_of_version(struct platform_device *pdev)
-{
-#ifdef CONFIG_OF
-	const struct of_device_id *match;
-
-	match = of_match_node(ccp_of_match, pdev->dev.of_node);
-	if (match && match->data)
-		return (struct ccp_vdata *)match->data;
-#endif
-	return 0;
-}
-
-static struct ccp_vdata *ccp_get_acpi_version(struct platform_device *pdev)
-{
-#ifdef CONFIG_ACPI
-	const struct acpi_device_id *match;
-
-	match = acpi_match_device(ccp_acpi_match, &pdev->dev);
-	if (match && match->driver_data)
-		return (struct ccp_vdata *)match->driver_data;
-#endif
-	return 0;
-}
-
-static int ccp_get_irq(struct ccp_device *ccp)
-{
-	struct device *dev = ccp->dev;
-	struct platform_device *pdev = to_platform_device(dev);
-	int ret;
-
-	ret = platform_get_irq(pdev, 0);
-	if (ret < 0)
-		return ret;
-
-	ccp->irq = ret;
-	ret = request_irq(ccp->irq, ccp->vdata->perform->irqhandler, 0,
-			  ccp->name, dev);
-	if (ret) {
-		dev_notice(dev, "unable to allocate IRQ (%d)\n", ret);
-		return ret;
-	}
-
-	return 0;
-}
-
-static int ccp_get_irqs(struct ccp_device *ccp)
-{
-	struct device *dev = ccp->dev;
-	int ret;
-
-	ret = ccp_get_irq(ccp);
-	if (!ret)
-		return 0;
-
-	/* Couldn't get an interrupt */
-	dev_notice(dev, "could not enable interrupts (%d)\n", ret);
-
-	return ret;
-}
-
-static void ccp_free_irqs(struct ccp_device *ccp)
-{
-	struct device *dev = ccp->dev;
-
-	free_irq(ccp->irq, dev);
-}
-
-static struct resource *ccp_find_mmio_area(struct ccp_device *ccp)
-{
-	struct device *dev = ccp->dev;
-	struct platform_device *pdev = to_platform_device(dev);
-	struct resource *ior;
-
-	ior = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (ior && (resource_size(ior) >= 0x800))
-		return ior;
-
-	return NULL;
-}
-
-static int ccp_platform_probe(struct platform_device *pdev)
-{
-	struct ccp_device *ccp;
-	struct ccp_platform *ccp_platform;
-	struct device *dev = &pdev->dev;
-	enum dev_dma_attr attr;
-	struct resource *ior;
-	int ret;
-
-	ret = -ENOMEM;
-	ccp = ccp_alloc_struct(dev);
-	if (!ccp)
-		goto e_err;
-
-	ccp_platform = devm_kzalloc(dev, sizeof(*ccp_platform), GFP_KERNEL);
-	if (!ccp_platform)
-		goto e_err;
-
-	ccp->dev_specific = ccp_platform;
-	ccp->vdata = pdev->dev.of_node ? ccp_get_of_version(pdev)
-					 : ccp_get_acpi_version(pdev);
-	if (!ccp->vdata || !ccp->vdata->version) {
-		ret = -ENODEV;
-		dev_err(dev, "missing driver data\n");
-		goto e_err;
-	}
-	ccp->get_irq = ccp_get_irqs;
-	ccp->free_irq = ccp_free_irqs;
-
-	ior = ccp_find_mmio_area(ccp);
-	ccp->io_map = devm_ioremap_resource(dev, ior);
-	if (IS_ERR(ccp->io_map)) {
-		ret = PTR_ERR(ccp->io_map);
-		goto e_err;
-	}
-	ccp->io_regs = ccp->io_map;
-
-	attr = device_get_dma_attr(dev);
-	if (attr == DEV_DMA_NOT_SUPPORTED) {
-		dev_err(dev, "DMA is not supported");
-		goto e_err;
-	}
-
-	ccp_platform->coherent = (attr == DEV_DMA_COHERENT);
-	if (ccp_platform->coherent)
-		ccp->axcache = CACHE_WB_NO_ALLOC;
-	else
-		ccp->axcache = CACHE_NONE;
-
-	ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(48));
-	if (ret) {
-		dev_err(dev, "dma_set_mask_and_coherent failed (%d)\n", ret);
-		goto e_err;
-	}
-
-	dev_set_drvdata(dev, ccp);
-
-	ret = ccp->vdata->perform->init(ccp);
-	if (ret)
-		goto e_err;
-
-	dev_notice(dev, "enabled\n");
-
-	return 0;
-
-e_err:
-	dev_notice(dev, "initialization failed\n");
-	return ret;
-}
-
-static int ccp_platform_remove(struct platform_device *pdev)
-{
-	struct device *dev = &pdev->dev;
-	struct ccp_device *ccp = dev_get_drvdata(dev);
-
-	ccp->vdata->perform->destroy(ccp);
-
-	dev_notice(dev, "disabled\n");
-
-	return 0;
-}
-
-#ifdef CONFIG_PM
-static int ccp_platform_suspend(struct platform_device *pdev,
-				pm_message_t state)
-{
-	struct device *dev = &pdev->dev;
-	struct ccp_device *ccp = dev_get_drvdata(dev);
-	unsigned long flags;
-	unsigned int i;
-
-	spin_lock_irqsave(&ccp->cmd_lock, flags);
-
-	ccp->suspending = 1;
-
-	/* Wake all the queue kthreads to prepare for suspend */
-	for (i = 0; i < ccp->cmd_q_count; i++)
-		wake_up_process(ccp->cmd_q[i].kthread);
-
-	spin_unlock_irqrestore(&ccp->cmd_lock, flags);
-
-	/* Wait for all queue kthreads to say they're done */
-	while (!ccp_queues_suspended(ccp))
-		wait_event_interruptible(ccp->suspend_queue,
-					 ccp_queues_suspended(ccp));
-
-	return 0;
-}
-
-static int ccp_platform_resume(struct platform_device *pdev)
-{
-	struct device *dev = &pdev->dev;
-	struct ccp_device *ccp = dev_get_drvdata(dev);
-	unsigned long flags;
-	unsigned int i;
-
-	spin_lock_irqsave(&ccp->cmd_lock, flags);
-
-	ccp->suspending = 0;
-
-	/* Wake up all the kthreads */
-	for (i = 0; i < ccp->cmd_q_count; i++) {
-		ccp->cmd_q[i].suspended = 0;
-		wake_up_process(ccp->cmd_q[i].kthread);
-	}
-
-	spin_unlock_irqrestore(&ccp->cmd_lock, flags);
-
-	return 0;
-}
-#endif
-
-#ifdef CONFIG_ACPI
-static const struct acpi_device_id ccp_acpi_match[] = {
-	{ "AMDI0C00", (kernel_ulong_t)&ccpv3 },
-	{ },
-};
-MODULE_DEVICE_TABLE(acpi, ccp_acpi_match);
-#endif
-
-#ifdef CONFIG_OF
-static const struct of_device_id ccp_of_match[] = {
-	{ .compatible = "amd,ccp-seattle-v1a",
-	  .data = (const void *)&ccpv3 },
-	{ },
-};
-MODULE_DEVICE_TABLE(of, ccp_of_match);
-#endif
-
-static struct platform_driver ccp_platform_driver = {
-	.driver = {
-		.name = "ccp",
-#ifdef CONFIG_ACPI
-		.acpi_match_table = ccp_acpi_match,
-#endif
-#ifdef CONFIG_OF
-		.of_match_table = ccp_of_match,
-#endif
-	},
-	.probe = ccp_platform_probe,
-	.remove = ccp_platform_remove,
-#ifdef CONFIG_PM
-	.suspend = ccp_platform_suspend,
-	.resume = ccp_platform_resume,
-#endif
-};
-
-int ccp_platform_init(void)
-{
-	return platform_driver_register(&ccp_platform_driver);
-}
-
-void ccp_platform_exit(void)
-{
-	platform_driver_unregister(&ccp_platform_driver);
-}
diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 64971ba..01e08f4 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -778,4 +778,5 @@ source "drivers/misc/mic/Kconfig"
 source "drivers/misc/genwqe/Kconfig"
 source "drivers/misc/echo/Kconfig"
 source "drivers/misc/cxl/Kconfig"
+source "drivers/misc/amd-sp/Kconfig"
 endmenu
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 3198336..fe0056d 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -53,6 +53,7 @@ obj-$(CONFIG_ECHO)		+= echo/
 obj-$(CONFIG_VEXPRESS_SYSCFG)	+= vexpress-syscfg.o
 obj-$(CONFIG_CXL_BASE)		+= cxl/
 obj-$(CONFIG_PANEL)             += panel.o
+obj-$(CONFIG_AMD_CCP)		+= amd-sp/
 
 lkdtm-$(CONFIG_LKDTM)		+= lkdtm_core.o
 lkdtm-$(CONFIG_LKDTM)		+= lkdtm_bugs.o
diff --git a/drivers/misc/amd-sp/Kconfig b/drivers/misc/amd-sp/Kconfig
new file mode 100644
index 0000000..dbf7baa
--- /dev/null
+++ b/drivers/misc/amd-sp/Kconfig
@@ -0,0 +1,14 @@
+config AMD_CCP
+	tristate "Support for AMD Cryptographic Coprocessor"
+	default n
+	depends on ((X86 && PCI) || (ARM64 && (OF_ADDRESS || ACPI))) && HAS_IOMEM
+	select HW_RANDOM
+	select DMA_ENGINE
+	select DMADEVICES
+	select CRYPTO_SHA1
+	select CRYPTO_SHA256
+	help
+	  Provides the interface to use the AMD Cryptographic Coprocessor
+	  which can be used to offload encryption operations such as SHA,
+	  AES and more. If you choose 'M' here, this module will be called
+	  ccp.
diff --git a/drivers/misc/amd-sp/Makefile b/drivers/misc/amd-sp/Makefile
new file mode 100644
index 0000000..85991a5
--- /dev/null
+++ b/drivers/misc/amd-sp/Makefile
@@ -0,0 +1,8 @@
+obj-$(CONFIG_AMD_CCP) += ccp.o
+ccp-objs := ccp-dev.o \
+	    ccp-ops.o \
+	    ccp-dev-v3.o \
+	    ccp-dev-v5.o \
+	    ccp-platform.o \
+	    ccp-dmaengine.o
+ccp-$(CONFIG_PCI) += ccp-pci.o
diff --git a/drivers/misc/amd-sp/ccp-dev-v3.c b/drivers/misc/amd-sp/ccp-dev-v3.c
new file mode 100644
index 0000000..7bc0998
--- /dev/null
+++ b/drivers/misc/amd-sp/ccp-dev-v3.c
@@ -0,0 +1,574 @@
+/*
+ * AMD Cryptographic Coprocessor (CCP) driver
+ *
+ * Copyright (C) 2013,2016 Advanced Micro Devices, Inc.
+ *
+ * Author: Tom Lendacky <thomas.lendacky@amd.com>
+ * Author: Gary R Hook <gary.hook@amd.com>
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
+static u32 ccp_alloc_ksb(struct ccp_cmd_queue *cmd_q, unsigned int count)
+{
+	int start;
+	struct ccp_device *ccp = cmd_q->ccp;
+
+	for (;;) {
+		mutex_lock(&ccp->sb_mutex);
+
+		start = (u32)bitmap_find_next_zero_area(ccp->sb,
+							ccp->sb_count,
+							ccp->sb_start,
+							count, 0);
+		if (start <= ccp->sb_count) {
+			bitmap_set(ccp->sb, start, count);
+
+			mutex_unlock(&ccp->sb_mutex);
+			break;
+		}
+
+		ccp->sb_avail = 0;
+
+		mutex_unlock(&ccp->sb_mutex);
+
+		/* Wait for KSB entries to become available */
+		if (wait_event_interruptible(ccp->sb_queue, ccp->sb_avail))
+			return 0;
+	}
+
+	return KSB_START + start;
+}
+
+static void ccp_free_ksb(struct ccp_cmd_queue *cmd_q, unsigned int start,
+			 unsigned int count)
+{
+	struct ccp_device *ccp = cmd_q->ccp;
+
+	if (!start)
+		return;
+
+	mutex_lock(&ccp->sb_mutex);
+
+	bitmap_clear(ccp->sb, start - KSB_START, count);
+
+	ccp->sb_avail = 1;
+
+	mutex_unlock(&ccp->sb_mutex);
+
+	wake_up_interruptible_all(&ccp->sb_queue);
+}
+
+static unsigned int ccp_get_free_slots(struct ccp_cmd_queue *cmd_q)
+{
+	return CMD_Q_DEPTH(ioread32(cmd_q->reg_status));
+}
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
+			if (cmd_q->cmd_error)
+				ccp_log_error(cmd_q->ccp,
+					      cmd_q->cmd_error);
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
+		| (op->sb_key << REQ1_KEY_KSB_SHIFT);
+	cr[1] = op->src.u.dma.length - 1;
+	cr[2] = ccp_addr_lo(&op->src.u.dma);
+	cr[3] = (op->sb_ctx << REQ4_KSB_SHIFT)
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
+		| (op->sb_key << REQ1_KEY_KSB_SHIFT);
+	cr[1] = op->src.u.dma.length - 1;
+	cr[2] = ccp_addr_lo(&op->src.u.dma);
+	cr[3] = (op->sb_ctx << REQ4_KSB_SHIFT)
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
+	cr[3] = (op->sb_ctx << REQ4_KSB_SHIFT)
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
+		| (op->sb_key << REQ1_KEY_KSB_SHIFT)
+		| REQ1_EOM;
+	cr[1] = op->u.rsa.input_len - 1;
+	cr[2] = ccp_addr_lo(&op->src.u.dma);
+	cr[3] = (op->sb_ctx << REQ4_KSB_SHIFT)
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
+			cr[3] |= (op->sb_key << REQ4_KSB_SHIFT);
+	} else {
+		cr[2] = op->src.u.sb * CCP_SB_BYTES;
+		cr[3] = (CCP_MEMTYPE_SB << REQ4_MEMTYPE_SHIFT);
+	}
+
+	if (op->dst.type == CCP_MEMTYPE_SYSTEM) {
+		cr[4] = ccp_addr_lo(&op->dst.u.dma);
+		cr[5] = (CCP_MEMTYPE_SYSTEM << REQ6_MEMTYPE_SHIFT)
+			| ccp_addr_hi(&op->dst.u.dma);
+	} else {
+		cr[4] = op->dst.u.sb * CCP_SB_BYTES;
+		cr[5] = (CCP_MEMTYPE_SB << REQ6_MEMTYPE_SHIFT);
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
+		cmd_q->sb_key = KSB_START + ccp->sb_start++;
+		cmd_q->sb_ctx = KSB_START + ccp->sb_start++;
+		ccp->sb_count -= 2;
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
+		cmd_q->free_slots = ccp_get_free_slots(cmd_q);
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
+	dev_dbg(dev, "Starting threads...\n");
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
+	dev_dbg(dev, "Enabling interrupts...\n");
+	/* Enable interrupts */
+	iowrite32(qim, ccp->io_regs + IRQ_MASK_REG);
+
+	dev_dbg(dev, "Registering device...\n");
+	ccp_add_device(ccp);
+
+	ret = ccp_register_rng(ccp);
+	if (ret)
+		goto e_kthread;
+
+	/* Register the DMA engine support */
+	ret = ccp_dmaengine_register(ccp);
+	if (ret)
+		goto e_hwrng;
+
+	return 0;
+
+e_hwrng:
+	ccp_unregister_rng(ccp);
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
+	/* Unregister the DMA engine */
+	ccp_dmaengine_unregister(ccp);
+
+	/* Unregister the RNG */
+	ccp_unregister_rng(ccp);
+
+	/* Remove this device from the list of available units */
+	ccp_del_device(ccp);
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
+	/* Stop the queue kthreads */
+	for (i = 0; i < ccp->cmd_q_count; i++)
+		if (ccp->cmd_q[i].kthread)
+			kthread_stop(ccp->cmd_q[i].kthread);
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
+static const struct ccp_actions ccp3_actions = {
+	.aes = ccp_perform_aes,
+	.xts_aes = ccp_perform_xts_aes,
+	.sha = ccp_perform_sha,
+	.rsa = ccp_perform_rsa,
+	.passthru = ccp_perform_passthru,
+	.ecc = ccp_perform_ecc,
+	.sballoc = ccp_alloc_ksb,
+	.sbfree = ccp_free_ksb,
+	.init = ccp_init,
+	.destroy = ccp_destroy,
+	.get_free_slots = ccp_get_free_slots,
+	.irqhandler = ccp_irq_handler,
+};
+
+const struct ccp_vdata ccpv3 = {
+	.version = CCP_VERSION(3, 0),
+	.setup = NULL,
+	.perform = &ccp3_actions,
+	.bar = 2,
+	.offset = 0x20000,
+};
diff --git a/drivers/misc/amd-sp/ccp-dev-v5.c b/drivers/misc/amd-sp/ccp-dev-v5.c
new file mode 100644
index 0000000..e2ce819
--- /dev/null
+++ b/drivers/misc/amd-sp/ccp-dev-v5.c
@@ -0,0 +1,1021 @@
+/*
+ * AMD Cryptographic Coprocessor (CCP) driver
+ *
+ * Copyright (C) 2016 Advanced Micro Devices, Inc.
+ *
+ * Author: Gary R Hook <gary.hook@amd.com>
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
+#include <linux/dma-mapping.h>
+#include <linux/interrupt.h>
+#include <linux/compiler.h>
+#include <linux/ccp.h>
+
+#include "ccp-dev.h"
+
+/* Allocate the requested number of contiguous LSB slots
+ * from the LSB bitmap. Look in the private range for this
+ * queue first; failing that, check the public area.
+ * If no space is available, wait around.
+ * Return: first slot number
+ */
+static u32 ccp_lsb_alloc(struct ccp_cmd_queue *cmd_q, unsigned int count)
+{
+	struct ccp_device *ccp;
+	int start;
+
+	/* First look at the map for the queue */
+	if (cmd_q->lsb >= 0) {
+		start = (u32)bitmap_find_next_zero_area(cmd_q->lsbmap,
+							LSB_SIZE,
+							0, count, 0);
+		if (start < LSB_SIZE) {
+			bitmap_set(cmd_q->lsbmap, start, count);
+			return start + cmd_q->lsb * LSB_SIZE;
+		}
+	}
+
+	/* No joy; try to get an entry from the shared blocks */
+	ccp = cmd_q->ccp;
+	for (;;) {
+		mutex_lock(&ccp->sb_mutex);
+
+		start = (u32)bitmap_find_next_zero_area(ccp->lsbmap,
+							MAX_LSB_CNT * LSB_SIZE,
+							0,
+							count, 0);
+		if (start <= MAX_LSB_CNT * LSB_SIZE) {
+			bitmap_set(ccp->lsbmap, start, count);
+
+			mutex_unlock(&ccp->sb_mutex);
+			return start;
+		}
+
+		ccp->sb_avail = 0;
+
+		mutex_unlock(&ccp->sb_mutex);
+
+		/* Wait for KSB entries to become available */
+		if (wait_event_interruptible(ccp->sb_queue, ccp->sb_avail))
+			return 0;
+	}
+}
+
+/* Free a number of LSB slots from the bitmap, starting at
+ * the indicated starting slot number.
+ */
+static void ccp_lsb_free(struct ccp_cmd_queue *cmd_q, unsigned int start,
+			 unsigned int count)
+{
+	if (!start)
+		return;
+
+	if (cmd_q->lsb == start) {
+		/* An entry from the private LSB */
+		bitmap_clear(cmd_q->lsbmap, start, count);
+	} else {
+		/* From the shared LSBs */
+		struct ccp_device *ccp = cmd_q->ccp;
+
+		mutex_lock(&ccp->sb_mutex);
+		bitmap_clear(ccp->lsbmap, start, count);
+		ccp->sb_avail = 1;
+		mutex_unlock(&ccp->sb_mutex);
+		wake_up_interruptible_all(&ccp->sb_queue);
+	}
+}
+
+/* CCP version 5: Union to define the function field (cmd_reg1/dword0) */
+union ccp_function {
+	struct {
+		u16 size:7;
+		u16 encrypt:1;
+		u16 mode:5;
+		u16 type:2;
+	} aes;
+	struct {
+		u16 size:7;
+		u16 encrypt:1;
+		u16 rsvd:5;
+		u16 type:2;
+	} aes_xts;
+	struct {
+		u16 rsvd1:10;
+		u16 type:4;
+		u16 rsvd2:1;
+	} sha;
+	struct {
+		u16 mode:3;
+		u16 size:12;
+	} rsa;
+	struct {
+		u16 byteswap:2;
+		u16 bitwise:3;
+		u16 reflect:2;
+		u16 rsvd:8;
+	} pt;
+	struct  {
+		u16 rsvd:13;
+	} zlib;
+	struct {
+		u16 size:10;
+		u16 type:2;
+		u16 mode:3;
+	} ecc;
+	u16 raw;
+};
+
+#define	CCP_AES_SIZE(p)		((p)->aes.size)
+#define	CCP_AES_ENCRYPT(p)	((p)->aes.encrypt)
+#define	CCP_AES_MODE(p)		((p)->aes.mode)
+#define	CCP_AES_TYPE(p)		((p)->aes.type)
+#define	CCP_XTS_SIZE(p)		((p)->aes_xts.size)
+#define	CCP_XTS_ENCRYPT(p)	((p)->aes_xts.encrypt)
+#define	CCP_SHA_TYPE(p)		((p)->sha.type)
+#define	CCP_RSA_SIZE(p)		((p)->rsa.size)
+#define	CCP_PT_BYTESWAP(p)	((p)->pt.byteswap)
+#define	CCP_PT_BITWISE(p)	((p)->pt.bitwise)
+#define	CCP_ECC_MODE(p)		((p)->ecc.mode)
+#define	CCP_ECC_AFFINE(p)	((p)->ecc.one)
+
+/* Word 0 */
+#define CCP5_CMD_DW0(p)		((p)->dw0)
+#define CCP5_CMD_SOC(p)		(CCP5_CMD_DW0(p).soc)
+#define CCP5_CMD_IOC(p)		(CCP5_CMD_DW0(p).ioc)
+#define CCP5_CMD_INIT(p)	(CCP5_CMD_DW0(p).init)
+#define CCP5_CMD_EOM(p)		(CCP5_CMD_DW0(p).eom)
+#define CCP5_CMD_FUNCTION(p)	(CCP5_CMD_DW0(p).function)
+#define CCP5_CMD_ENGINE(p)	(CCP5_CMD_DW0(p).engine)
+#define CCP5_CMD_PROT(p)	(CCP5_CMD_DW0(p).prot)
+
+/* Word 1 */
+#define CCP5_CMD_DW1(p)		((p)->length)
+#define CCP5_CMD_LEN(p)		(CCP5_CMD_DW1(p))
+
+/* Word 2 */
+#define CCP5_CMD_DW2(p)		((p)->src_lo)
+#define CCP5_CMD_SRC_LO(p)	(CCP5_CMD_DW2(p))
+
+/* Word 3 */
+#define CCP5_CMD_DW3(p)		((p)->dw3)
+#define CCP5_CMD_SRC_MEM(p)	((p)->dw3.src_mem)
+#define CCP5_CMD_SRC_HI(p)	((p)->dw3.src_hi)
+#define CCP5_CMD_LSB_ID(p)	((p)->dw3.lsb_cxt_id)
+#define CCP5_CMD_FIX_SRC(p)	((p)->dw3.fixed)
+
+/* Words 4/5 */
+#define CCP5_CMD_DW4(p)		((p)->dw4)
+#define CCP5_CMD_DST_LO(p)	(CCP5_CMD_DW4(p).dst_lo)
+#define CCP5_CMD_DW5(p)		((p)->dw5.fields.dst_hi)
+#define CCP5_CMD_DST_HI(p)	(CCP5_CMD_DW5(p))
+#define CCP5_CMD_DST_MEM(p)	((p)->dw5.fields.dst_mem)
+#define CCP5_CMD_FIX_DST(p)	((p)->dw5.fields.fixed)
+#define CCP5_CMD_SHA_LO(p)	((p)->dw4.sha_len_lo)
+#define CCP5_CMD_SHA_HI(p)	((p)->dw5.sha_len_hi)
+
+/* Word 6/7 */
+#define CCP5_CMD_DW6(p)		((p)->key_lo)
+#define CCP5_CMD_KEY_LO(p)	(CCP5_CMD_DW6(p))
+#define CCP5_CMD_DW7(p)		((p)->dw7)
+#define CCP5_CMD_KEY_HI(p)	((p)->dw7.key_hi)
+#define CCP5_CMD_KEY_MEM(p)	((p)->dw7.key_mem)
+
+static inline u32 low_address(unsigned long addr)
+{
+	return (u64)addr & 0x0ffffffff;
+}
+
+static inline u32 high_address(unsigned long addr)
+{
+	return ((u64)addr >> 32) & 0x00000ffff;
+}
+
+static unsigned int ccp5_get_free_slots(struct ccp_cmd_queue *cmd_q)
+{
+	unsigned int head_idx, n;
+	u32 head_lo, queue_start;
+
+	queue_start = low_address(cmd_q->qdma_tail);
+	head_lo = ioread32(cmd_q->reg_head_lo);
+	head_idx = (head_lo - queue_start) / sizeof(struct ccp5_desc);
+
+	n = head_idx + COMMANDS_PER_QUEUE - cmd_q->qidx - 1;
+
+	return n % COMMANDS_PER_QUEUE; /* Always one unused spot */
+}
+
+static int ccp5_do_cmd(struct ccp5_desc *desc,
+		       struct ccp_cmd_queue *cmd_q)
+{
+	u32 *mP;
+	__le32 *dP;
+	u32 tail;
+	int	i;
+	int ret = 0;
+
+	if (CCP5_CMD_SOC(desc)) {
+		CCP5_CMD_IOC(desc) = 1;
+		CCP5_CMD_SOC(desc) = 0;
+	}
+	mutex_lock(&cmd_q->q_mutex);
+
+	mP = (u32 *) &cmd_q->qbase[cmd_q->qidx];
+	dP = (__le32 *) desc;
+	for (i = 0; i < 8; i++)
+		mP[i] = cpu_to_le32(dP[i]); /* handle endianness */
+
+	cmd_q->qidx = (cmd_q->qidx + 1) % COMMANDS_PER_QUEUE;
+
+	/* The data used by this command must be flushed to memory */
+	wmb();
+
+	/* Write the new tail address back to the queue register */
+	tail = low_address(cmd_q->qdma_tail + cmd_q->qidx * Q_DESC_SIZE);
+	iowrite32(tail, cmd_q->reg_tail_lo);
+
+	/* Turn the queue back on using our cached control register */
+	iowrite32(cmd_q->qcontrol | CMD5_Q_RUN, cmd_q->reg_control);
+	mutex_unlock(&cmd_q->q_mutex);
+
+	if (CCP5_CMD_IOC(desc)) {
+		/* Wait for the job to complete */
+		ret = wait_event_interruptible(cmd_q->int_queue,
+					       cmd_q->int_rcvd);
+		if (ret || cmd_q->cmd_error) {
+			if (cmd_q->cmd_error)
+				ccp_log_error(cmd_q->ccp,
+					      cmd_q->cmd_error);
+			/* A version 5 device doesn't use Job IDs... */
+			if (!ret)
+				ret = -EIO;
+		}
+		cmd_q->int_rcvd = 0;
+	}
+
+	return 0;
+}
+
+static int ccp5_perform_aes(struct ccp_op *op)
+{
+	struct ccp5_desc desc;
+	union ccp_function function;
+	u32 key_addr = op->sb_key * LSB_ITEM_SIZE;
+
+	/* Zero out all the fields of the command desc */
+	memset(&desc, 0, Q_DESC_SIZE);
+
+	CCP5_CMD_ENGINE(&desc) = CCP_ENGINE_AES;
+
+	CCP5_CMD_SOC(&desc) = op->soc;
+	CCP5_CMD_IOC(&desc) = 1;
+	CCP5_CMD_INIT(&desc) = op->init;
+	CCP5_CMD_EOM(&desc) = op->eom;
+	CCP5_CMD_PROT(&desc) = 0;
+
+	function.raw = 0;
+	CCP_AES_ENCRYPT(&function) = op->u.aes.action;
+	CCP_AES_MODE(&function) = op->u.aes.mode;
+	CCP_AES_TYPE(&function) = op->u.aes.type;
+	if (op->u.aes.mode == CCP_AES_MODE_CFB)
+		CCP_AES_SIZE(&function) = 0x7f;
+
+	CCP5_CMD_FUNCTION(&desc) = function.raw;
+
+	CCP5_CMD_LEN(&desc) = op->src.u.dma.length;
+
+	CCP5_CMD_SRC_LO(&desc) = ccp_addr_lo(&op->src.u.dma);
+	CCP5_CMD_SRC_HI(&desc) = ccp_addr_hi(&op->src.u.dma);
+	CCP5_CMD_SRC_MEM(&desc) = CCP_MEMTYPE_SYSTEM;
+
+	CCP5_CMD_DST_LO(&desc) = ccp_addr_lo(&op->dst.u.dma);
+	CCP5_CMD_DST_HI(&desc) = ccp_addr_hi(&op->dst.u.dma);
+	CCP5_CMD_DST_MEM(&desc) = CCP_MEMTYPE_SYSTEM;
+
+	CCP5_CMD_KEY_LO(&desc) = lower_32_bits(key_addr);
+	CCP5_CMD_KEY_HI(&desc) = 0;
+	CCP5_CMD_KEY_MEM(&desc) = CCP_MEMTYPE_SB;
+	CCP5_CMD_LSB_ID(&desc) = op->sb_ctx;
+
+	return ccp5_do_cmd(&desc, op->cmd_q);
+}
+
+static int ccp5_perform_xts_aes(struct ccp_op *op)
+{
+	struct ccp5_desc desc;
+	union ccp_function function;
+	u32 key_addr = op->sb_key * LSB_ITEM_SIZE;
+
+	/* Zero out all the fields of the command desc */
+	memset(&desc, 0, Q_DESC_SIZE);
+
+	CCP5_CMD_ENGINE(&desc) = CCP_ENGINE_XTS_AES_128;
+
+	CCP5_CMD_SOC(&desc) = op->soc;
+	CCP5_CMD_IOC(&desc) = 1;
+	CCP5_CMD_INIT(&desc) = op->init;
+	CCP5_CMD_EOM(&desc) = op->eom;
+	CCP5_CMD_PROT(&desc) = 0;
+
+	function.raw = 0;
+	CCP_XTS_ENCRYPT(&function) = op->u.xts.action;
+	CCP_XTS_SIZE(&function) = op->u.xts.unit_size;
+	CCP5_CMD_FUNCTION(&desc) = function.raw;
+
+	CCP5_CMD_LEN(&desc) = op->src.u.dma.length;
+
+	CCP5_CMD_SRC_LO(&desc) = ccp_addr_lo(&op->src.u.dma);
+	CCP5_CMD_SRC_HI(&desc) = ccp_addr_hi(&op->src.u.dma);
+	CCP5_CMD_SRC_MEM(&desc) = CCP_MEMTYPE_SYSTEM;
+
+	CCP5_CMD_DST_LO(&desc) = ccp_addr_lo(&op->dst.u.dma);
+	CCP5_CMD_DST_HI(&desc) = ccp_addr_hi(&op->dst.u.dma);
+	CCP5_CMD_DST_MEM(&desc) = CCP_MEMTYPE_SYSTEM;
+
+	CCP5_CMD_KEY_LO(&desc) = lower_32_bits(key_addr);
+	CCP5_CMD_KEY_HI(&desc) =  0;
+	CCP5_CMD_KEY_MEM(&desc) = CCP_MEMTYPE_SB;
+	CCP5_CMD_LSB_ID(&desc) = op->sb_ctx;
+
+	return ccp5_do_cmd(&desc, op->cmd_q);
+}
+
+static int ccp5_perform_sha(struct ccp_op *op)
+{
+	struct ccp5_desc desc;
+	union ccp_function function;
+
+	/* Zero out all the fields of the command desc */
+	memset(&desc, 0, Q_DESC_SIZE);
+
+	CCP5_CMD_ENGINE(&desc) = CCP_ENGINE_SHA;
+
+	CCP5_CMD_SOC(&desc) = op->soc;
+	CCP5_CMD_IOC(&desc) = 1;
+	CCP5_CMD_INIT(&desc) = 1;
+	CCP5_CMD_EOM(&desc) = op->eom;
+	CCP5_CMD_PROT(&desc) = 0;
+
+	function.raw = 0;
+	CCP_SHA_TYPE(&function) = op->u.sha.type;
+	CCP5_CMD_FUNCTION(&desc) = function.raw;
+
+	CCP5_CMD_LEN(&desc) = op->src.u.dma.length;
+
+	CCP5_CMD_SRC_LO(&desc) = ccp_addr_lo(&op->src.u.dma);
+	CCP5_CMD_SRC_HI(&desc) = ccp_addr_hi(&op->src.u.dma);
+	CCP5_CMD_SRC_MEM(&desc) = CCP_MEMTYPE_SYSTEM;
+
+	CCP5_CMD_LSB_ID(&desc) = op->sb_ctx;
+
+	if (op->eom) {
+		CCP5_CMD_SHA_LO(&desc) = lower_32_bits(op->u.sha.msg_bits);
+		CCP5_CMD_SHA_HI(&desc) = upper_32_bits(op->u.sha.msg_bits);
+	} else {
+		CCP5_CMD_SHA_LO(&desc) = 0;
+		CCP5_CMD_SHA_HI(&desc) = 0;
+	}
+
+	return ccp5_do_cmd(&desc, op->cmd_q);
+}
+
+static int ccp5_perform_rsa(struct ccp_op *op)
+{
+	struct ccp5_desc desc;
+	union ccp_function function;
+
+	/* Zero out all the fields of the command desc */
+	memset(&desc, 0, Q_DESC_SIZE);
+
+	CCP5_CMD_ENGINE(&desc) = CCP_ENGINE_RSA;
+
+	CCP5_CMD_SOC(&desc) = op->soc;
+	CCP5_CMD_IOC(&desc) = 1;
+	CCP5_CMD_INIT(&desc) = 0;
+	CCP5_CMD_EOM(&desc) = 1;
+	CCP5_CMD_PROT(&desc) = 0;
+
+	function.raw = 0;
+	CCP_RSA_SIZE(&function) = op->u.rsa.mod_size >> 3;
+	CCP5_CMD_FUNCTION(&desc) = function.raw;
+
+	CCP5_CMD_LEN(&desc) = op->u.rsa.input_len;
+
+	/* Source is from external memory */
+	CCP5_CMD_SRC_LO(&desc) = ccp_addr_lo(&op->src.u.dma);
+	CCP5_CMD_SRC_HI(&desc) = ccp_addr_hi(&op->src.u.dma);
+	CCP5_CMD_SRC_MEM(&desc) = CCP_MEMTYPE_SYSTEM;
+
+	/* Destination is in external memory */
+	CCP5_CMD_DST_LO(&desc) = ccp_addr_lo(&op->dst.u.dma);
+	CCP5_CMD_DST_HI(&desc) = ccp_addr_hi(&op->dst.u.dma);
+	CCP5_CMD_DST_MEM(&desc) = CCP_MEMTYPE_SYSTEM;
+
+	/* Exponent is in LSB memory */
+	CCP5_CMD_KEY_LO(&desc) = op->sb_key * LSB_ITEM_SIZE;
+	CCP5_CMD_KEY_HI(&desc) = 0;
+	CCP5_CMD_KEY_MEM(&desc) = CCP_MEMTYPE_SB;
+
+	return ccp5_do_cmd(&desc, op->cmd_q);
+}
+
+static int ccp5_perform_passthru(struct ccp_op *op)
+{
+	struct ccp5_desc desc;
+	union ccp_function function;
+	struct ccp_dma_info *saddr = &op->src.u.dma;
+	struct ccp_dma_info *daddr = &op->dst.u.dma;
+
+	memset(&desc, 0, Q_DESC_SIZE);
+
+	CCP5_CMD_ENGINE(&desc) = CCP_ENGINE_PASSTHRU;
+
+	CCP5_CMD_SOC(&desc) = 0;
+	CCP5_CMD_IOC(&desc) = 1;
+	CCP5_CMD_INIT(&desc) = 0;
+	CCP5_CMD_EOM(&desc) = op->eom;
+	CCP5_CMD_PROT(&desc) = 0;
+
+	function.raw = 0;
+	CCP_PT_BYTESWAP(&function) = op->u.passthru.byte_swap;
+	CCP_PT_BITWISE(&function) = op->u.passthru.bit_mod;
+	CCP5_CMD_FUNCTION(&desc) = function.raw;
+
+	/* Length of source data is always 256 bytes */
+	if (op->src.type == CCP_MEMTYPE_SYSTEM)
+		CCP5_CMD_LEN(&desc) = saddr->length;
+	else
+		CCP5_CMD_LEN(&desc) = daddr->length;
+
+	if (op->src.type == CCP_MEMTYPE_SYSTEM) {
+		CCP5_CMD_SRC_LO(&desc) = ccp_addr_lo(&op->src.u.dma);
+		CCP5_CMD_SRC_HI(&desc) = ccp_addr_hi(&op->src.u.dma);
+		CCP5_CMD_SRC_MEM(&desc) = CCP_MEMTYPE_SYSTEM;
+
+		if (op->u.passthru.bit_mod != CCP_PASSTHRU_BITWISE_NOOP)
+			CCP5_CMD_LSB_ID(&desc) = op->sb_key;
+	} else {
+		u32 key_addr = op->src.u.sb * CCP_SB_BYTES;
+
+		CCP5_CMD_SRC_LO(&desc) = lower_32_bits(key_addr);
+		CCP5_CMD_SRC_HI(&desc) = 0;
+		CCP5_CMD_SRC_MEM(&desc) = CCP_MEMTYPE_SB;
+	}
+
+	if (op->dst.type == CCP_MEMTYPE_SYSTEM) {
+		CCP5_CMD_DST_LO(&desc) = ccp_addr_lo(&op->dst.u.dma);
+		CCP5_CMD_DST_HI(&desc) = ccp_addr_hi(&op->dst.u.dma);
+		CCP5_CMD_DST_MEM(&desc) = CCP_MEMTYPE_SYSTEM;
+	} else {
+		u32 key_addr = op->dst.u.sb * CCP_SB_BYTES;
+
+		CCP5_CMD_DST_LO(&desc) = lower_32_bits(key_addr);
+		CCP5_CMD_DST_HI(&desc) = 0;
+		CCP5_CMD_DST_MEM(&desc) = CCP_MEMTYPE_SB;
+	}
+
+	return ccp5_do_cmd(&desc, op->cmd_q);
+}
+
+static int ccp5_perform_ecc(struct ccp_op *op)
+{
+	struct ccp5_desc desc;
+	union ccp_function function;
+
+	/* Zero out all the fields of the command desc */
+	memset(&desc, 0, Q_DESC_SIZE);
+
+	CCP5_CMD_ENGINE(&desc) = CCP_ENGINE_ECC;
+
+	CCP5_CMD_SOC(&desc) = 0;
+	CCP5_CMD_IOC(&desc) = 1;
+	CCP5_CMD_INIT(&desc) = 0;
+	CCP5_CMD_EOM(&desc) = 1;
+	CCP5_CMD_PROT(&desc) = 0;
+
+	function.raw = 0;
+	function.ecc.mode = op->u.ecc.function;
+	CCP5_CMD_FUNCTION(&desc) = function.raw;
+
+	CCP5_CMD_LEN(&desc) = op->src.u.dma.length;
+
+	CCP5_CMD_SRC_LO(&desc) = ccp_addr_lo(&op->src.u.dma);
+	CCP5_CMD_SRC_HI(&desc) = ccp_addr_hi(&op->src.u.dma);
+	CCP5_CMD_SRC_MEM(&desc) = CCP_MEMTYPE_SYSTEM;
+
+	CCP5_CMD_DST_LO(&desc) = ccp_addr_lo(&op->dst.u.dma);
+	CCP5_CMD_DST_HI(&desc) = ccp_addr_hi(&op->dst.u.dma);
+	CCP5_CMD_DST_MEM(&desc) = CCP_MEMTYPE_SYSTEM;
+
+	return ccp5_do_cmd(&desc, op->cmd_q);
+}
+
+static int ccp_find_lsb_regions(struct ccp_cmd_queue *cmd_q, u64 status)
+{
+	int q_mask = 1 << cmd_q->id;
+	int queues = 0;
+	int j;
+
+	/* Build a bit mask to know which LSBs this queue has access to.
+	 * Don't bother with segment 0 as it has special privileges.
+	 */
+	for (j = 1; j < MAX_LSB_CNT; j++) {
+		if (status & q_mask)
+			bitmap_set(cmd_q->lsbmask, j, 1);
+		status >>= LSB_REGION_WIDTH;
+	}
+	queues = bitmap_weight(cmd_q->lsbmask, MAX_LSB_CNT);
+	dev_info(cmd_q->ccp->dev, "Queue %d can access %d LSB regions\n",
+		 cmd_q->id, queues);
+
+	return queues ? 0 : -EINVAL;
+}
+
+
+static int ccp_find_and_assign_lsb_to_q(struct ccp_device *ccp,
+					int lsb_cnt, int n_lsbs,
+					unsigned long *lsb_pub)
+{
+	DECLARE_BITMAP(qlsb, MAX_LSB_CNT);
+	int bitno;
+	int qlsb_wgt;
+	int i;
+
+	/* For each queue:
+	 * If the count of potential LSBs available to a queue matches the
+	 * ordinal given to us in lsb_cnt:
+	 * Copy the mask of possible LSBs for this queue into "qlsb";
+	 * For each bit in qlsb, see if the corresponding bit in the
+	 * aggregation mask is set; if so, we have a match.
+	 *     If we have a match, clear the bit in the aggregation to
+	 *     mark it as no longer available.
+	 *     If there is no match, clear the bit in qlsb and keep looking.
+	 */
+	for (i = 0; i < ccp->cmd_q_count; i++) {
+		struct ccp_cmd_queue *cmd_q = &ccp->cmd_q[i];
+
+		qlsb_wgt = bitmap_weight(cmd_q->lsbmask, MAX_LSB_CNT);
+
+		if (qlsb_wgt == lsb_cnt) {
+			bitmap_copy(qlsb, cmd_q->lsbmask, MAX_LSB_CNT);
+
+			bitno = find_first_bit(qlsb, MAX_LSB_CNT);
+			while (bitno < MAX_LSB_CNT) {
+				if (test_bit(bitno, lsb_pub)) {
+					/* We found an available LSB
+					 * that this queue can access
+					 */
+					cmd_q->lsb = bitno;
+					bitmap_clear(lsb_pub, bitno, 1);
+					dev_info(ccp->dev,
+						 "Queue %d gets LSB %d\n",
+						 i, bitno);
+					break;
+				}
+				bitmap_clear(qlsb, bitno, 1);
+				bitno = find_first_bit(qlsb, MAX_LSB_CNT);
+			}
+			if (bitno >= MAX_LSB_CNT)
+				return -EINVAL;
+			n_lsbs--;
+		}
+	}
+	return n_lsbs;
+}
+
+/* For each queue, from the most- to least-constrained:
+ * find an LSB that can be assigned to the queue. If there are N queues that
+ * can only use M LSBs, where N > M, fail; otherwise, every queue will get a
+ * dedicated LSB. Remaining LSB regions become a shared resource.
+ * If we have fewer LSBs than queues, all LSB regions become shared resources.
+ */
+static int ccp_assign_lsbs(struct ccp_device *ccp)
+{
+	DECLARE_BITMAP(lsb_pub, MAX_LSB_CNT);
+	DECLARE_BITMAP(qlsb, MAX_LSB_CNT);
+	int n_lsbs = 0;
+	int bitno;
+	int i, lsb_cnt;
+	int rc = 0;
+
+	bitmap_zero(lsb_pub, MAX_LSB_CNT);
+
+	/* Create an aggregate bitmap to get a total count of available LSBs */
+	for (i = 0; i < ccp->cmd_q_count; i++)
+		bitmap_or(lsb_pub,
+			  lsb_pub, ccp->cmd_q[i].lsbmask,
+			  MAX_LSB_CNT);
+
+	n_lsbs = bitmap_weight(lsb_pub, MAX_LSB_CNT);
+
+	if (n_lsbs >= ccp->cmd_q_count) {
+		/* We have enough LSBS to give every queue a private LSB.
+		 * Brute force search to start with the queues that are more
+		 * constrained in LSB choice. When an LSB is privately
+		 * assigned, it is removed from the public mask.
+		 * This is an ugly N squared algorithm with some optimization.
+		 */
+		for (lsb_cnt = 1;
+		     n_lsbs && (lsb_cnt <= MAX_LSB_CNT);
+		     lsb_cnt++) {
+			rc = ccp_find_and_assign_lsb_to_q(ccp, lsb_cnt, n_lsbs,
+							  lsb_pub);
+			if (rc < 0)
+				return -EINVAL;
+			n_lsbs = rc;
+		}
+	}
+
+	rc = 0;
+	/* What's left of the LSBs, according to the public mask, now become
+	 * shared. Any zero bits in the lsb_pub mask represent an LSB region
+	 * that can't be used as a shared resource, so mark the LSB slots for
+	 * them as "in use".
+	 */
+	bitmap_copy(qlsb, lsb_pub, MAX_LSB_CNT);
+
+	bitno = find_first_zero_bit(qlsb, MAX_LSB_CNT);
+	while (bitno < MAX_LSB_CNT) {
+		bitmap_set(ccp->lsbmap, bitno * LSB_SIZE, LSB_SIZE);
+		bitmap_set(qlsb, bitno, 1);
+		bitno = find_first_zero_bit(qlsb, MAX_LSB_CNT);
+	}
+
+	return rc;
+}
+
+static int ccp5_init(struct ccp_device *ccp)
+{
+	struct device *dev = ccp->dev;
+	struct ccp_cmd_queue *cmd_q;
+	struct dma_pool *dma_pool;
+	char dma_pool_name[MAX_DMAPOOL_NAME_LEN];
+	unsigned int qmr, qim, i;
+	u64 status;
+	u32 status_lo, status_hi;
+	int ret;
+
+	/* Find available queues */
+	qim = 0;
+	qmr = ioread32(ccp->io_regs + Q_MASK_REG);
+	for (i = 0; i < MAX_HW_QUEUES; i++) {
+
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
+		}
+
+		cmd_q = &ccp->cmd_q[ccp->cmd_q_count];
+		ccp->cmd_q_count++;
+
+		cmd_q->ccp = ccp;
+		cmd_q->id = i;
+		cmd_q->dma_pool = dma_pool;
+		mutex_init(&cmd_q->q_mutex);
+
+		/* Page alignment satisfies our needs for N <= 128 */
+		BUILD_BUG_ON(COMMANDS_PER_QUEUE > 128);
+		cmd_q->qsize = Q_SIZE(Q_DESC_SIZE);
+		cmd_q->qbase = dma_zalloc_coherent(dev, cmd_q->qsize,
+						   &cmd_q->qbase_dma,
+						   GFP_KERNEL);
+		if (!cmd_q->qbase) {
+			dev_err(dev, "unable to allocate command queue\n");
+			ret = -ENOMEM;
+			goto e_pool;
+		}
+
+		cmd_q->qidx = 0;
+		/* Preset some register values and masks that are queue
+		 * number dependent
+		 */
+		cmd_q->reg_control = ccp->io_regs +
+				     CMD5_Q_STATUS_INCR * (i + 1);
+		cmd_q->reg_tail_lo = cmd_q->reg_control + CMD5_Q_TAIL_LO_BASE;
+		cmd_q->reg_head_lo = cmd_q->reg_control + CMD5_Q_HEAD_LO_BASE;
+		cmd_q->reg_int_enable = cmd_q->reg_control +
+					CMD5_Q_INT_ENABLE_BASE;
+		cmd_q->reg_interrupt_status = cmd_q->reg_control +
+					      CMD5_Q_INTERRUPT_STATUS_BASE;
+		cmd_q->reg_status = cmd_q->reg_control + CMD5_Q_STATUS_BASE;
+		cmd_q->reg_int_status = cmd_q->reg_control +
+					CMD5_Q_INT_STATUS_BASE;
+		cmd_q->reg_dma_status = cmd_q->reg_control +
+					CMD5_Q_DMA_STATUS_BASE;
+		cmd_q->reg_dma_read_status = cmd_q->reg_control +
+					     CMD5_Q_DMA_READ_STATUS_BASE;
+		cmd_q->reg_dma_write_status = cmd_q->reg_control +
+					      CMD5_Q_DMA_WRITE_STATUS_BASE;
+
+		init_waitqueue_head(&cmd_q->int_queue);
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
+	/* Turn off the queues and disable interrupts until ready */
+	for (i = 0; i < ccp->cmd_q_count; i++) {
+		cmd_q = &ccp->cmd_q[i];
+
+		cmd_q->qcontrol = 0; /* Start with nothing */
+		iowrite32(cmd_q->qcontrol, cmd_q->reg_control);
+
+		/* Disable the interrupts */
+		iowrite32(0x00, cmd_q->reg_int_enable);
+		ioread32(cmd_q->reg_int_status);
+		ioread32(cmd_q->reg_status);
+
+		/* Clear the interrupts */
+		iowrite32(ALL_INTERRUPTS, cmd_q->reg_interrupt_status);
+	}
+
+	dev_dbg(dev, "Requesting an IRQ...\n");
+	/* Request an irq */
+	ret = ccp->get_irq(ccp);
+	if (ret) {
+		dev_err(dev, "unable to allocate an IRQ\n");
+		goto e_pool;
+	}
+
+	dev_dbg(dev, "Loading LSB map...\n");
+	/* Copy the private LSB mask to the public registers */
+	status_lo = ioread32(ccp->io_regs + LSB_PRIVATE_MASK_LO_OFFSET);
+	status_hi = ioread32(ccp->io_regs + LSB_PRIVATE_MASK_HI_OFFSET);
+	iowrite32(status_lo, ccp->io_regs + LSB_PUBLIC_MASK_LO_OFFSET);
+	iowrite32(status_hi, ccp->io_regs + LSB_PUBLIC_MASK_HI_OFFSET);
+	status = ((u64)status_hi<<30) | (u64)status_lo;
+
+	dev_dbg(dev, "Configuring virtual queues...\n");
+	/* Configure size of each virtual queue accessible to host */
+	for (i = 0; i < ccp->cmd_q_count; i++) {
+		u32 dma_addr_lo;
+		u32 dma_addr_hi;
+
+		cmd_q = &ccp->cmd_q[i];
+
+		cmd_q->qcontrol &= ~(CMD5_Q_SIZE << CMD5_Q_SHIFT);
+		cmd_q->qcontrol |= QUEUE_SIZE_VAL << CMD5_Q_SHIFT;
+
+		cmd_q->qdma_tail = cmd_q->qbase_dma;
+		dma_addr_lo = low_address(cmd_q->qdma_tail);
+		iowrite32((u32)dma_addr_lo, cmd_q->reg_tail_lo);
+		iowrite32((u32)dma_addr_lo, cmd_q->reg_head_lo);
+
+		dma_addr_hi = high_address(cmd_q->qdma_tail);
+		cmd_q->qcontrol |= (dma_addr_hi << 16);
+		iowrite32(cmd_q->qcontrol, cmd_q->reg_control);
+
+		/* Find the LSB regions accessible to the queue */
+		ccp_find_lsb_regions(cmd_q, status);
+		cmd_q->lsb = -1; /* Unassigned value */
+	}
+
+	dev_dbg(dev, "Assigning LSBs...\n");
+	ret = ccp_assign_lsbs(ccp);
+	if (ret) {
+		dev_err(dev, "Unable to assign LSBs (%d)\n", ret);
+		goto e_irq;
+	}
+
+	/* Optimization: pre-allocate LSB slots for each queue */
+	for (i = 0; i < ccp->cmd_q_count; i++) {
+		ccp->cmd_q[i].sb_key = ccp_lsb_alloc(&ccp->cmd_q[i], 2);
+		ccp->cmd_q[i].sb_ctx = ccp_lsb_alloc(&ccp->cmd_q[i], 2);
+	}
+
+	dev_dbg(dev, "Starting threads...\n");
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
+	dev_dbg(dev, "Enabling interrupts...\n");
+	/* Enable interrupts */
+	for (i = 0; i < ccp->cmd_q_count; i++) {
+		cmd_q = &ccp->cmd_q[i];
+		iowrite32(ALL_INTERRUPTS, cmd_q->reg_int_enable);
+	}
+
+	dev_dbg(dev, "Registering device...\n");
+	/* Put this on the unit list to make it available */
+	ccp_add_device(ccp);
+
+	ret = ccp_register_rng(ccp);
+	if (ret)
+		goto e_kthread;
+
+	/* Register the DMA engine support */
+	ret = ccp_dmaengine_register(ccp);
+	if (ret)
+		goto e_hwrng;
+
+	return 0;
+
+e_hwrng:
+	ccp_unregister_rng(ccp);
+
+e_kthread:
+	for (i = 0; i < ccp->cmd_q_count; i++)
+		if (ccp->cmd_q[i].kthread)
+			kthread_stop(ccp->cmd_q[i].kthread);
+
+e_irq:
+	ccp->free_irq(ccp);
+
+e_pool:
+	for (i = 0; i < ccp->cmd_q_count; i++)
+		dma_pool_destroy(ccp->cmd_q[i].dma_pool);
+
+	return ret;
+}
+
+static void ccp5_destroy(struct ccp_device *ccp)
+{
+	struct device *dev = ccp->dev;
+	struct ccp_cmd_queue *cmd_q;
+	struct ccp_cmd *cmd;
+	unsigned int i;
+
+	/* Unregister the DMA engine */
+	ccp_dmaengine_unregister(ccp);
+
+	/* Unregister the RNG */
+	ccp_unregister_rng(ccp);
+
+	/* Remove this device from the list of available units first */
+	ccp_del_device(ccp);
+
+	/* Disable and clear interrupts */
+	for (i = 0; i < ccp->cmd_q_count; i++) {
+		cmd_q = &ccp->cmd_q[i];
+
+		/* Turn off the run bit */
+		iowrite32(cmd_q->qcontrol & ~CMD5_Q_RUN, cmd_q->reg_control);
+
+		/* Disable the interrupts */
+		iowrite32(ALL_INTERRUPTS, cmd_q->reg_interrupt_status);
+
+		/* Clear the interrupt status */
+		iowrite32(0x00, cmd_q->reg_int_enable);
+		ioread32(cmd_q->reg_int_status);
+		ioread32(cmd_q->reg_status);
+	}
+
+	/* Stop the queue kthreads */
+	for (i = 0; i < ccp->cmd_q_count; i++)
+		if (ccp->cmd_q[i].kthread)
+			kthread_stop(ccp->cmd_q[i].kthread);
+
+	ccp->free_irq(ccp);
+
+	for (i = 0; i < ccp->cmd_q_count; i++) {
+		cmd_q = &ccp->cmd_q[i];
+		dma_free_coherent(dev, cmd_q->qsize, cmd_q->qbase,
+				  cmd_q->qbase_dma);
+	}
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
+static irqreturn_t ccp5_irq_handler(int irq, void *data)
+{
+	struct device *dev = data;
+	struct ccp_device *ccp = dev_get_drvdata(dev);
+	u32 status;
+	unsigned int i;
+
+	for (i = 0; i < ccp->cmd_q_count; i++) {
+		struct ccp_cmd_queue *cmd_q = &ccp->cmd_q[i];
+
+		status = ioread32(cmd_q->reg_interrupt_status);
+
+		if (status) {
+			cmd_q->int_status = status;
+			cmd_q->q_status = ioread32(cmd_q->reg_status);
+			cmd_q->q_int_status = ioread32(cmd_q->reg_int_status);
+
+			/* On error, only save the first error value */
+			if ((status & INT_ERROR) && !cmd_q->cmd_error)
+				cmd_q->cmd_error = CMD_Q_ERROR(cmd_q->q_status);
+
+			cmd_q->int_rcvd = 1;
+
+			/* Acknowledge the interrupt and wake the kthread */
+			iowrite32(ALL_INTERRUPTS, cmd_q->reg_interrupt_status);
+			wake_up_interruptible(&cmd_q->int_queue);
+		}
+	}
+
+	return IRQ_HANDLED;
+}
+
+static void ccp5_config(struct ccp_device *ccp)
+{
+	/* Public side */
+	iowrite32(0x00001249, ccp->io_regs + CMD5_REQID_CONFIG_OFFSET);
+}
+
+static void ccp5other_config(struct ccp_device *ccp)
+{
+	int i;
+	u32 rnd;
+
+	/* We own all of the queues on the NTB CCP */
+
+	iowrite32(0x00012D57, ccp->io_regs + CMD5_TRNG_CTL_OFFSET);
+	iowrite32(0x00000003, ccp->io_regs + CMD5_CONFIG_0_OFFSET);
+	for (i = 0; i < 12; i++) {
+		rnd = ioread32(ccp->io_regs + TRNG_OUT_REG);
+		iowrite32(rnd, ccp->io_regs + CMD5_AES_MASK_OFFSET);
+	}
+
+	iowrite32(0x0000001F, ccp->io_regs + CMD5_QUEUE_MASK_OFFSET);
+	iowrite32(0x00005B6D, ccp->io_regs + CMD5_QUEUE_PRIO_OFFSET);
+	iowrite32(0x00000000, ccp->io_regs + CMD5_CMD_TIMEOUT_OFFSET);
+
+	iowrite32(0x3FFFFFFF, ccp->io_regs + LSB_PRIVATE_MASK_LO_OFFSET);
+	iowrite32(0x000003FF, ccp->io_regs + LSB_PRIVATE_MASK_HI_OFFSET);
+
+	iowrite32(0x00108823, ccp->io_regs + CMD5_CLK_GATE_CTL_OFFSET);
+
+	ccp5_config(ccp);
+}
+
+/* Version 5 adds some function, but is essentially the same as v5 */
+static const struct ccp_actions ccp5_actions = {
+	.aes = ccp5_perform_aes,
+	.xts_aes = ccp5_perform_xts_aes,
+	.sha = ccp5_perform_sha,
+	.rsa = ccp5_perform_rsa,
+	.passthru = ccp5_perform_passthru,
+	.ecc = ccp5_perform_ecc,
+	.sballoc = ccp_lsb_alloc,
+	.sbfree = ccp_lsb_free,
+	.init = ccp5_init,
+	.destroy = ccp5_destroy,
+	.get_free_slots = ccp5_get_free_slots,
+	.irqhandler = ccp5_irq_handler,
+};
+
+const struct ccp_vdata ccpv5a = {
+	.version = CCP_VERSION(5, 0),
+	.setup = ccp5_config,
+	.perform = &ccp5_actions,
+	.bar = 2,
+	.offset = 0x0,
+};
+
+const struct ccp_vdata ccpv5b = {
+	.version = CCP_VERSION(5, 0),
+	.setup = ccp5other_config,
+	.perform = &ccp5_actions,
+	.bar = 2,
+	.offset = 0x0,
+};
diff --git a/drivers/misc/amd-sp/ccp-dev.c b/drivers/misc/amd-sp/ccp-dev.c
new file mode 100644
index 0000000..511ab04
--- /dev/null
+++ b/drivers/misc/amd-sp/ccp-dev.c
@@ -0,0 +1,588 @@
+/*
+ * AMD Cryptographic Coprocessor (CCP) driver
+ *
+ * Copyright (C) 2013,2016 Advanced Micro Devices, Inc.
+ *
+ * Author: Tom Lendacky <thomas.lendacky@amd.com>
+ * Author: Gary R Hook <gary.hook@amd.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/kthread.h>
+#include <linux/sched.h>
+#include <linux/interrupt.h>
+#include <linux/spinlock.h>
+#include <linux/spinlock_types.h>
+#include <linux/types.h>
+#include <linux/mutex.h>
+#include <linux/delay.h>
+#include <linux/hw_random.h>
+#include <linux/cpu.h>
+#ifdef CONFIG_X86
+#include <asm/cpu_device_id.h>
+#endif
+#include <linux/ccp.h>
+
+#include "ccp-dev.h"
+
+MODULE_AUTHOR("Tom Lendacky <thomas.lendacky@amd.com>");
+MODULE_LICENSE("GPL");
+MODULE_VERSION("1.0.0");
+MODULE_DESCRIPTION("AMD Cryptographic Coprocessor driver");
+
+struct ccp_tasklet_data {
+	struct completion completion;
+	struct ccp_cmd *cmd;
+};
+
+/* Human-readable error strings */
+static char *ccp_error_codes[] = {
+	"",
+	"ERR 01: ILLEGAL_ENGINE",
+	"ERR 02: ILLEGAL_KEY_ID",
+	"ERR 03: ILLEGAL_FUNCTION_TYPE",
+	"ERR 04: ILLEGAL_FUNCTION_MODE",
+	"ERR 05: ILLEGAL_FUNCTION_ENCRYPT",
+	"ERR 06: ILLEGAL_FUNCTION_SIZE",
+	"ERR 07: Zlib_MISSING_INIT_EOM",
+	"ERR 08: ILLEGAL_FUNCTION_RSVD",
+	"ERR 09: ILLEGAL_BUFFER_LENGTH",
+	"ERR 10: VLSB_FAULT",
+	"ERR 11: ILLEGAL_MEM_ADDR",
+	"ERR 12: ILLEGAL_MEM_SEL",
+	"ERR 13: ILLEGAL_CONTEXT_ID",
+	"ERR 14: ILLEGAL_KEY_ADDR",
+	"ERR 15: 0xF Reserved",
+	"ERR 16: Zlib_ILLEGAL_MULTI_QUEUE",
+	"ERR 17: Zlib_ILLEGAL_JOBID_CHANGE",
+	"ERR 18: CMD_TIMEOUT",
+	"ERR 19: IDMA0_AXI_SLVERR",
+	"ERR 20: IDMA0_AXI_DECERR",
+	"ERR 21: 0x15 Reserved",
+	"ERR 22: IDMA1_AXI_SLAVE_FAULT",
+	"ERR 23: IDMA1_AIXI_DECERR",
+	"ERR 24: 0x18 Reserved",
+	"ERR 25: ZLIBVHB_AXI_SLVERR",
+	"ERR 26: ZLIBVHB_AXI_DECERR",
+	"ERR 27: 0x1B Reserved",
+	"ERR 27: ZLIB_UNEXPECTED_EOM",
+	"ERR 27: ZLIB_EXTRA_DATA",
+	"ERR 30: ZLIB_BTYPE",
+	"ERR 31: ZLIB_UNDEFINED_SYMBOL",
+	"ERR 32: ZLIB_UNDEFINED_DISTANCE_S",
+	"ERR 33: ZLIB_CODE_LENGTH_SYMBOL",
+	"ERR 34: ZLIB _VHB_ILLEGAL_FETCH",
+	"ERR 35: ZLIB_UNCOMPRESSED_LEN",
+	"ERR 36: ZLIB_LIMIT_REACHED",
+	"ERR 37: ZLIB_CHECKSUM_MISMATCH0",
+	"ERR 38: ODMA0_AXI_SLVERR",
+	"ERR 39: ODMA0_AXI_DECERR",
+	"ERR 40: 0x28 Reserved",
+	"ERR 41: ODMA1_AXI_SLVERR",
+	"ERR 42: ODMA1_AXI_DECERR",
+	"ERR 43: LSB_PARITY_ERR",
+};
+
+void ccp_log_error(struct ccp_device *d, int e)
+{
+	dev_err(d->dev, "CCP error: %s (0x%x)\n", ccp_error_codes[e], e);
+}
+
+/* List of CCPs, CCP count, read-write access lock, and access functions
+ *
+ * Lock structure: get ccp_unit_lock for reading whenever we need to
+ * examine the CCP list. While holding it for reading we can acquire
+ * the RR lock to update the round-robin next-CCP pointer. The unit lock
+ * must be acquired before the RR lock.
+ *
+ * If the unit-lock is acquired for writing, we have total control over
+ * the list, so there's no value in getting the RR lock.
+ */
+static DEFINE_RWLOCK(ccp_unit_lock);
+static LIST_HEAD(ccp_units);
+
+/* Round-robin counter */
+static DEFINE_SPINLOCK(ccp_rr_lock);
+static struct ccp_device *ccp_rr;
+
+/* Ever-increasing value to produce unique unit numbers */
+static atomic_t ccp_unit_ordinal;
+static unsigned int ccp_increment_unit_ordinal(void)
+{
+	return atomic_inc_return(&ccp_unit_ordinal);
+}
+
+/**
+ * ccp_add_device - add a CCP device to the list
+ *
+ * @ccp: ccp_device struct pointer
+ *
+ * Put this CCP on the unit list, which makes it available
+ * for use.
+ *
+ * Returns zero if a CCP device is present, -ENODEV otherwise.
+ */
+void ccp_add_device(struct ccp_device *ccp)
+{
+	unsigned long flags;
+
+	write_lock_irqsave(&ccp_unit_lock, flags);
+	list_add_tail(&ccp->entry, &ccp_units);
+	if (!ccp_rr)
+		/* We already have the list lock (we're first) so this
+		 * pointer can't change on us. Set its initial value.
+		 */
+		ccp_rr = ccp;
+	write_unlock_irqrestore(&ccp_unit_lock, flags);
+}
+
+/**
+ * ccp_del_device - remove a CCP device from the list
+ *
+ * @ccp: ccp_device struct pointer
+ *
+ * Remove this unit from the list of devices. If the next device
+ * up for use is this one, adjust the pointer. If this is the last
+ * device, NULL the pointer.
+ */
+void ccp_del_device(struct ccp_device *ccp)
+{
+	unsigned long flags;
+
+	write_lock_irqsave(&ccp_unit_lock, flags);
+	if (ccp_rr == ccp) {
+		/* ccp_unit_lock is read/write; any read access
+		 * will be suspended while we make changes to the
+		 * list and RR pointer.
+		 */
+		if (list_is_last(&ccp_rr->entry, &ccp_units))
+			ccp_rr = list_first_entry(&ccp_units, struct ccp_device,
+						  entry);
+		else
+			ccp_rr = list_next_entry(ccp_rr, entry);
+	}
+	list_del(&ccp->entry);
+	if (list_empty(&ccp_units))
+		ccp_rr = NULL;
+	write_unlock_irqrestore(&ccp_unit_lock, flags);
+}
+
+
+
+int ccp_register_rng(struct ccp_device *ccp)
+{
+	int ret = 0;
+
+	dev_dbg(ccp->dev, "Registering RNG...\n");
+	/* Register an RNG */
+	ccp->hwrng.name = ccp->rngname;
+	ccp->hwrng.read = ccp_trng_read;
+	ret = hwrng_register(&ccp->hwrng);
+	if (ret)
+		dev_err(ccp->dev, "error registering hwrng (%d)\n", ret);
+
+	return ret;
+}
+
+void ccp_unregister_rng(struct ccp_device *ccp)
+{
+	if (ccp->hwrng.name)
+		hwrng_unregister(&ccp->hwrng);
+}
+
+static struct ccp_device *ccp_get_device(void)
+{
+	unsigned long flags;
+	struct ccp_device *dp = NULL;
+
+	/* We round-robin through the unit list.
+	 * The (ccp_rr) pointer refers to the next unit to use.
+	 */
+	read_lock_irqsave(&ccp_unit_lock, flags);
+	if (!list_empty(&ccp_units)) {
+		spin_lock(&ccp_rr_lock);
+		dp = ccp_rr;
+		if (list_is_last(&ccp_rr->entry, &ccp_units))
+			ccp_rr = list_first_entry(&ccp_units, struct ccp_device,
+						  entry);
+		else
+			ccp_rr = list_next_entry(ccp_rr, entry);
+		spin_unlock(&ccp_rr_lock);
+	}
+	read_unlock_irqrestore(&ccp_unit_lock, flags);
+
+	return dp;
+}
+
+/**
+ * ccp_present - check if a CCP device is present
+ *
+ * Returns zero if a CCP device is present, -ENODEV otherwise.
+ */
+int ccp_present(void)
+{
+	unsigned long flags;
+	int ret;
+
+	read_lock_irqsave(&ccp_unit_lock, flags);
+	ret = list_empty(&ccp_units);
+	read_unlock_irqrestore(&ccp_unit_lock, flags);
+
+	return ret ? -ENODEV : 0;
+}
+EXPORT_SYMBOL_GPL(ccp_present);
+
+/**
+ * ccp_version - get the version of the CCP device
+ *
+ * Returns the version from the first unit on the list;
+ * otherwise a zero if no CCP device is present
+ */
+unsigned int ccp_version(void)
+{
+	struct ccp_device *dp;
+	unsigned long flags;
+	int ret = 0;
+
+	read_lock_irqsave(&ccp_unit_lock, flags);
+	if (!list_empty(&ccp_units)) {
+		dp = list_first_entry(&ccp_units, struct ccp_device, entry);
+		ret = dp->vdata->version;
+	}
+	read_unlock_irqrestore(&ccp_unit_lock, flags);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(ccp_version);
+
+/**
+ * ccp_enqueue_cmd - queue an operation for processing by the CCP
+ *
+ * @cmd: ccp_cmd struct to be processed
+ *
+ * Queue a cmd to be processed by the CCP. If queueing the cmd
+ * would exceed the defined length of the cmd queue the cmd will
+ * only be queued if the CCP_CMD_MAY_BACKLOG flag is set and will
+ * result in a return code of -EBUSY.
+ *
+ * The callback routine specified in the ccp_cmd struct will be
+ * called to notify the caller of completion (if the cmd was not
+ * backlogged) or advancement out of the backlog. If the cmd has
+ * advanced out of the backlog the "err" value of the callback
+ * will be -EINPROGRESS. Any other "err" value during callback is
+ * the result of the operation.
+ *
+ * The cmd has been successfully queued if:
+ *   the return code is -EINPROGRESS or
+ *   the return code is -EBUSY and CCP_CMD_MAY_BACKLOG flag is set
+ */
+int ccp_enqueue_cmd(struct ccp_cmd *cmd)
+{
+	struct ccp_device *ccp = ccp_get_device();
+	unsigned long flags;
+	unsigned int i;
+	int ret;
+
+	if (!ccp)
+		return -ENODEV;
+
+	/* Caller must supply a callback routine */
+	if (!cmd->callback)
+		return -EINVAL;
+
+	cmd->ccp = ccp;
+
+	spin_lock_irqsave(&ccp->cmd_lock, flags);
+
+	i = ccp->cmd_q_count;
+
+	if (ccp->cmd_count >= MAX_CMD_QLEN) {
+		ret = -EBUSY;
+		if (cmd->flags & CCP_CMD_MAY_BACKLOG)
+			list_add_tail(&cmd->entry, &ccp->backlog);
+	} else {
+		ret = -EINPROGRESS;
+		ccp->cmd_count++;
+		list_add_tail(&cmd->entry, &ccp->cmd);
+
+		/* Find an idle queue */
+		if (!ccp->suspending) {
+			for (i = 0; i < ccp->cmd_q_count; i++) {
+				if (ccp->cmd_q[i].active)
+					continue;
+
+				break;
+			}
+		}
+	}
+
+	spin_unlock_irqrestore(&ccp->cmd_lock, flags);
+
+	/* If we found an idle queue, wake it up */
+	if (i < ccp->cmd_q_count)
+		wake_up_process(ccp->cmd_q[i].kthread);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(ccp_enqueue_cmd);
+
+static void ccp_do_cmd_backlog(struct work_struct *work)
+{
+	struct ccp_cmd *cmd = container_of(work, struct ccp_cmd, work);
+	struct ccp_device *ccp = cmd->ccp;
+	unsigned long flags;
+	unsigned int i;
+
+	cmd->callback(cmd->data, -EINPROGRESS);
+
+	spin_lock_irqsave(&ccp->cmd_lock, flags);
+
+	ccp->cmd_count++;
+	list_add_tail(&cmd->entry, &ccp->cmd);
+
+	/* Find an idle queue */
+	for (i = 0; i < ccp->cmd_q_count; i++) {
+		if (ccp->cmd_q[i].active)
+			continue;
+
+		break;
+	}
+
+	spin_unlock_irqrestore(&ccp->cmd_lock, flags);
+
+	/* If we found an idle queue, wake it up */
+	if (i < ccp->cmd_q_count)
+		wake_up_process(ccp->cmd_q[i].kthread);
+}
+
+static struct ccp_cmd *ccp_dequeue_cmd(struct ccp_cmd_queue *cmd_q)
+{
+	struct ccp_device *ccp = cmd_q->ccp;
+	struct ccp_cmd *cmd = NULL;
+	struct ccp_cmd *backlog = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ccp->cmd_lock, flags);
+
+	cmd_q->active = 0;
+
+	if (ccp->suspending) {
+		cmd_q->suspended = 1;
+
+		spin_unlock_irqrestore(&ccp->cmd_lock, flags);
+		wake_up_interruptible(&ccp->suspend_queue);
+
+		return NULL;
+	}
+
+	if (ccp->cmd_count) {
+		cmd_q->active = 1;
+
+		cmd = list_first_entry(&ccp->cmd, struct ccp_cmd, entry);
+		list_del(&cmd->entry);
+
+		ccp->cmd_count--;
+	}
+
+	if (!list_empty(&ccp->backlog)) {
+		backlog = list_first_entry(&ccp->backlog, struct ccp_cmd,
+					   entry);
+		list_del(&backlog->entry);
+	}
+
+	spin_unlock_irqrestore(&ccp->cmd_lock, flags);
+
+	if (backlog) {
+		INIT_WORK(&backlog->work, ccp_do_cmd_backlog);
+		schedule_work(&backlog->work);
+	}
+
+	return cmd;
+}
+
+static void ccp_do_cmd_complete(unsigned long data)
+{
+	struct ccp_tasklet_data *tdata = (struct ccp_tasklet_data *)data;
+	struct ccp_cmd *cmd = tdata->cmd;
+
+	cmd->callback(cmd->data, cmd->ret);
+	complete(&tdata->completion);
+}
+
+/**
+ * ccp_cmd_queue_thread - create a kernel thread to manage a CCP queue
+ *
+ * @data: thread-specific data
+ */
+int ccp_cmd_queue_thread(void *data)
+{
+	struct ccp_cmd_queue *cmd_q = (struct ccp_cmd_queue *)data;
+	struct ccp_cmd *cmd;
+	struct ccp_tasklet_data tdata;
+	struct tasklet_struct tasklet;
+
+	tasklet_init(&tasklet, ccp_do_cmd_complete, (unsigned long)&tdata);
+
+	set_current_state(TASK_INTERRUPTIBLE);
+	while (!kthread_should_stop()) {
+		schedule();
+
+		set_current_state(TASK_INTERRUPTIBLE);
+
+		cmd = ccp_dequeue_cmd(cmd_q);
+		if (!cmd)
+			continue;
+
+		__set_current_state(TASK_RUNNING);
+
+		/* Execute the command */
+		cmd->ret = ccp_run_cmd(cmd_q, cmd);
+
+		/* Schedule the completion callback */
+		tdata.cmd = cmd;
+		init_completion(&tdata.completion);
+		tasklet_schedule(&tasklet);
+		wait_for_completion(&tdata.completion);
+	}
+
+	__set_current_state(TASK_RUNNING);
+
+	return 0;
+}
+
+/**
+ * ccp_alloc_struct - allocate and initialize the ccp_device struct
+ *
+ * @dev: device struct of the CCP
+ */
+struct ccp_device *ccp_alloc_struct(struct device *dev)
+{
+	struct ccp_device *ccp;
+
+	ccp = devm_kzalloc(dev, sizeof(*ccp), GFP_KERNEL);
+	if (!ccp)
+		return NULL;
+	ccp->dev = dev;
+
+	INIT_LIST_HEAD(&ccp->cmd);
+	INIT_LIST_HEAD(&ccp->backlog);
+
+	spin_lock_init(&ccp->cmd_lock);
+	mutex_init(&ccp->req_mutex);
+	mutex_init(&ccp->sb_mutex);
+	ccp->sb_count = KSB_COUNT;
+	ccp->sb_start = 0;
+
+	/* Initialize the wait queues */
+	init_waitqueue_head(&ccp->sb_queue);
+	init_waitqueue_head(&ccp->suspend_queue);
+
+	ccp->ord = ccp_increment_unit_ordinal();
+	snprintf(ccp->name, MAX_CCP_NAME_LEN, "ccp-%u", ccp->ord);
+	snprintf(ccp->rngname, MAX_CCP_NAME_LEN, "ccp-%u-rng", ccp->ord);
+
+	return ccp;
+}
+
+int ccp_trng_read(struct hwrng *rng, void *data, size_t max, bool wait)
+{
+	struct ccp_device *ccp = container_of(rng, struct ccp_device, hwrng);
+	u32 trng_value;
+	int len = min_t(int, sizeof(trng_value), max);
+
+	/* Locking is provided by the caller so we can update device
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
+#ifdef CONFIG_PM
+bool ccp_queues_suspended(struct ccp_device *ccp)
+{
+	unsigned int suspended = 0;
+	unsigned long flags;
+	unsigned int i;
+
+	spin_lock_irqsave(&ccp->cmd_lock, flags);
+
+	for (i = 0; i < ccp->cmd_q_count; i++)
+		if (ccp->cmd_q[i].suspended)
+			suspended++;
+
+	spin_unlock_irqrestore(&ccp->cmd_lock, flags);
+
+	return ccp->cmd_q_count == suspended;
+}
+#endif
+
+static int __init ccp_mod_init(void)
+{
+#ifdef CONFIG_X86
+	int ret;
+
+	ret = ccp_pci_init();
+	if (ret)
+		return ret;
+
+	/* Don't leave the driver loaded if init failed */
+	if (ccp_present() != 0) {
+		ccp_pci_exit();
+		return -ENODEV;
+	}
+
+	return 0;
+#endif
+
+#ifdef CONFIG_ARM64
+	int ret;
+
+	ret = ccp_platform_init();
+	if (ret)
+		return ret;
+
+	/* Don't leave the driver loaded if init failed */
+	if (ccp_present() != 0) {
+		ccp_platform_exit();
+		return -ENODEV;
+	}
+
+	return 0;
+#endif
+
+	return -ENODEV;
+}
+
+static void __exit ccp_mod_exit(void)
+{
+#ifdef CONFIG_X86
+	ccp_pci_exit();
+#endif
+
+#ifdef CONFIG_ARM64
+	ccp_platform_exit();
+#endif
+}
+
+module_init(ccp_mod_init);
+module_exit(ccp_mod_exit);
diff --git a/drivers/misc/amd-sp/ccp-dev.h b/drivers/misc/amd-sp/ccp-dev.h
new file mode 100644
index 0000000..830f35e
--- /dev/null
+++ b/drivers/misc/amd-sp/ccp-dev.h
@@ -0,0 +1,647 @@
+/*
+ * AMD Cryptographic Coprocessor (CCP) driver
+ *
+ * Copyright (C) 2013,2016 Advanced Micro Devices, Inc.
+ *
+ * Author: Tom Lendacky <thomas.lendacky@amd.com>
+ * Author: Gary R Hook <gary.hook@amd.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __CCP_DEV_H__
+#define __CCP_DEV_H__
+
+#include <linux/device.h>
+#include <linux/pci.h>
+#include <linux/spinlock.h>
+#include <linux/mutex.h>
+#include <linux/list.h>
+#include <linux/wait.h>
+#include <linux/dmapool.h>
+#include <linux/hw_random.h>
+#include <linux/bitops.h>
+#include <linux/interrupt.h>
+#include <linux/irqreturn.h>
+#include <linux/dmaengine.h>
+
+#define MAX_CCP_NAME_LEN		16
+#define MAX_DMAPOOL_NAME_LEN		32
+
+#define MAX_HW_QUEUES			5
+#define MAX_CMD_QLEN			100
+
+#define TRNG_RETRIES			10
+
+#define CACHE_NONE			0x00
+#define CACHE_WB_NO_ALLOC		0xb7
+
+/****** Register Mappings ******/
+#define Q_MASK_REG			0x000
+#define TRNG_OUT_REG			0x00c
+#define IRQ_MASK_REG			0x040
+#define IRQ_STATUS_REG			0x200
+
+#define DEL_CMD_Q_JOB			0x124
+#define DEL_Q_ACTIVE			0x00000200
+#define DEL_Q_ID_SHIFT			6
+
+#define CMD_REQ0			0x180
+#define CMD_REQ_INCR			0x04
+
+#define CMD_Q_STATUS_BASE		0x210
+#define CMD_Q_INT_STATUS_BASE		0x214
+#define CMD_Q_STATUS_INCR		0x20
+
+#define CMD_Q_CACHE_BASE		0x228
+#define CMD_Q_CACHE_INC			0x20
+
+#define CMD_Q_ERROR(__qs)		((__qs) & 0x0000003f)
+#define CMD_Q_DEPTH(__qs)		(((__qs) >> 12) & 0x0000000f)
+
+/* ------------------------ CCP Version 5 Specifics ------------------------ */
+#define CMD5_QUEUE_MASK_OFFSET		0x00
+#define	CMD5_QUEUE_PRIO_OFFSET		0x04
+#define CMD5_REQID_CONFIG_OFFSET	0x08
+#define	CMD5_CMD_TIMEOUT_OFFSET		0x10
+#define LSB_PUBLIC_MASK_LO_OFFSET	0x18
+#define LSB_PUBLIC_MASK_HI_OFFSET	0x1C
+#define LSB_PRIVATE_MASK_LO_OFFSET	0x20
+#define LSB_PRIVATE_MASK_HI_OFFSET	0x24
+
+#define CMD5_Q_CONTROL_BASE		0x0000
+#define CMD5_Q_TAIL_LO_BASE		0x0004
+#define CMD5_Q_HEAD_LO_BASE		0x0008
+#define CMD5_Q_INT_ENABLE_BASE		0x000C
+#define CMD5_Q_INTERRUPT_STATUS_BASE	0x0010
+
+#define CMD5_Q_STATUS_BASE		0x0100
+#define CMD5_Q_INT_STATUS_BASE		0x0104
+#define CMD5_Q_DMA_STATUS_BASE		0x0108
+#define CMD5_Q_DMA_READ_STATUS_BASE	0x010C
+#define CMD5_Q_DMA_WRITE_STATUS_BASE	0x0110
+#define CMD5_Q_ABORT_BASE		0x0114
+#define CMD5_Q_AX_CACHE_BASE		0x0118
+
+#define	CMD5_CONFIG_0_OFFSET		0x6000
+#define	CMD5_TRNG_CTL_OFFSET		0x6008
+#define	CMD5_AES_MASK_OFFSET		0x6010
+#define	CMD5_CLK_GATE_CTL_OFFSET	0x603C
+
+/* Address offset between two virtual queue registers */
+#define CMD5_Q_STATUS_INCR		0x1000
+
+/* Bit masks */
+#define CMD5_Q_RUN			0x1
+#define CMD5_Q_HALT			0x2
+#define CMD5_Q_MEM_LOCATION		0x4
+#define CMD5_Q_SIZE			0x1F
+#define CMD5_Q_SHIFT			3
+#define COMMANDS_PER_QUEUE		16
+#define QUEUE_SIZE_VAL			((ffs(COMMANDS_PER_QUEUE) - 2) & \
+					  CMD5_Q_SIZE)
+#define Q_PTR_MASK			(2 << (QUEUE_SIZE_VAL + 5) - 1)
+#define Q_DESC_SIZE			sizeof(struct ccp5_desc)
+#define Q_SIZE(n)			(COMMANDS_PER_QUEUE*(n))
+
+#define INT_COMPLETION			0x1
+#define INT_ERROR			0x2
+#define INT_QUEUE_STOPPED		0x4
+#define ALL_INTERRUPTS			(INT_COMPLETION| \
+					 INT_ERROR| \
+					 INT_QUEUE_STOPPED)
+
+#define LSB_REGION_WIDTH		5
+#define MAX_LSB_CNT			8
+
+#define LSB_SIZE			16
+#define LSB_ITEM_SIZE			32
+#define PLSB_MAP_SIZE			(LSB_SIZE)
+#define SLSB_MAP_SIZE			(MAX_LSB_CNT * LSB_SIZE)
+
+#define LSB_ENTRY_NUMBER(LSB_ADDR)	(LSB_ADDR / LSB_ITEM_SIZE)
+
+/* ------------------------ CCP Version 3 Specifics ------------------------ */
+#define REQ0_WAIT_FOR_WRITE		0x00000004
+#define REQ0_INT_ON_COMPLETE		0x00000002
+#define REQ0_STOP_ON_COMPLETE		0x00000001
+
+#define REQ0_CMD_Q_SHIFT		9
+#define REQ0_JOBID_SHIFT		3
+
+/****** REQ1 Related Values ******/
+#define REQ1_PROTECT_SHIFT		27
+#define REQ1_ENGINE_SHIFT		23
+#define REQ1_KEY_KSB_SHIFT		2
+
+#define REQ1_EOM			0x00000002
+#define REQ1_INIT			0x00000001
+
+/* AES Related Values */
+#define REQ1_AES_TYPE_SHIFT		21
+#define REQ1_AES_MODE_SHIFT		18
+#define REQ1_AES_ACTION_SHIFT		17
+#define REQ1_AES_CFB_SIZE_SHIFT		10
+
+/* XTS-AES Related Values */
+#define REQ1_XTS_AES_SIZE_SHIFT		10
+
+/* SHA Related Values */
+#define REQ1_SHA_TYPE_SHIFT		21
+
+/* RSA Related Values */
+#define REQ1_RSA_MOD_SIZE_SHIFT		10
+
+/* Pass-Through Related Values */
+#define REQ1_PT_BW_SHIFT		12
+#define REQ1_PT_BS_SHIFT		10
+
+/* ECC Related Values */
+#define REQ1_ECC_AFFINE_CONVERT		0x00200000
+#define REQ1_ECC_FUNCTION_SHIFT		18
+
+/****** REQ4 Related Values ******/
+#define REQ4_KSB_SHIFT			18
+#define REQ4_MEMTYPE_SHIFT		16
+
+/****** REQ6 Related Values ******/
+#define REQ6_MEMTYPE_SHIFT		16
+
+/****** Key Storage Block ******/
+#define KSB_START			77
+#define KSB_END				127
+#define KSB_COUNT			(KSB_END - KSB_START + 1)
+#define CCP_SB_BITS			256
+
+#define CCP_JOBID_MASK			0x0000003f
+
+/* ------------------------ General CCP Defines ------------------------ */
+
+#define CCP_DMAPOOL_MAX_SIZE		64
+#define CCP_DMAPOOL_ALIGN		BIT(5)
+
+#define CCP_REVERSE_BUF_SIZE		64
+
+#define CCP_AES_KEY_SB_COUNT		1
+#define CCP_AES_CTX_SB_COUNT		1
+
+#define CCP_XTS_AES_KEY_SB_COUNT	1
+#define CCP_XTS_AES_CTX_SB_COUNT	1
+
+#define CCP_SHA_SB_COUNT		1
+
+#define CCP_RSA_MAX_WIDTH		4096
+
+#define CCP_PASSTHRU_BLOCKSIZE		256
+#define CCP_PASSTHRU_MASKSIZE		32
+#define CCP_PASSTHRU_SB_COUNT		1
+
+#define CCP_ECC_MODULUS_BYTES		48      /* 384-bits */
+#define CCP_ECC_MAX_OPERANDS		6
+#define CCP_ECC_MAX_OUTPUTS		3
+#define CCP_ECC_SRC_BUF_SIZE		448
+#define CCP_ECC_DST_BUF_SIZE		192
+#define CCP_ECC_OPERAND_SIZE		64
+#define CCP_ECC_OUTPUT_SIZE		64
+#define CCP_ECC_RESULT_OFFSET		60
+#define CCP_ECC_RESULT_SUCCESS		0x0001
+
+#define CCP_SB_BYTES			32
+
+struct ccp_op;
+struct ccp_device;
+struct ccp_cmd;
+struct ccp_fns;
+
+struct ccp_dma_cmd {
+	struct list_head entry;
+
+	struct ccp_cmd ccp_cmd;
+};
+
+struct ccp_dma_desc {
+	struct list_head entry;
+
+	struct ccp_device *ccp;
+
+	struct list_head pending;
+	struct list_head active;
+
+	enum dma_status status;
+	struct dma_async_tx_descriptor tx_desc;
+	size_t len;
+};
+
+struct ccp_dma_chan {
+	struct ccp_device *ccp;
+
+	spinlock_t lock;
+	struct list_head pending;
+	struct list_head active;
+	struct list_head complete;
+
+	struct tasklet_struct cleanup_tasklet;
+
+	enum dma_status status;
+	struct dma_chan dma_chan;
+};
+
+struct ccp_cmd_queue {
+	struct ccp_device *ccp;
+
+	/* Queue identifier */
+	u32 id;
+
+	/* Queue dma pool */
+	struct dma_pool *dma_pool;
+
+	/* Queue base address (not neccessarily aligned)*/
+	struct ccp5_desc *qbase;
+
+	/* Aligned queue start address (per requirement) */
+	struct mutex q_mutex ____cacheline_aligned;
+	unsigned int qidx;
+
+	/* Version 5 has different requirements for queue memory */
+	unsigned int qsize;
+	dma_addr_t qbase_dma;
+	dma_addr_t qdma_tail;
+
+	/* Per-queue reserved storage block(s) */
+	u32 sb_key;
+	u32 sb_ctx;
+
+	/* Bitmap of LSBs that can be accessed by this queue */
+	DECLARE_BITMAP(lsbmask, MAX_LSB_CNT);
+	/* Private LSB that is assigned to this queue, or -1 if none.
+	 * Bitmap for my private LSB, unused otherwise
+	 */
+	int lsb;
+	DECLARE_BITMAP(lsbmap, PLSB_MAP_SIZE);
+
+	/* Queue processing thread */
+	struct task_struct *kthread;
+	unsigned int active;
+	unsigned int suspended;
+
+	/* Number of free command slots available */
+	unsigned int free_slots;
+
+	/* Interrupt masks */
+	u32 int_ok;
+	u32 int_err;
+
+	/* Register addresses for queue */
+	void __iomem *reg_control;
+	void __iomem *reg_tail_lo;
+	void __iomem *reg_head_lo;
+	void __iomem *reg_int_enable;
+	void __iomem *reg_interrupt_status;
+	void __iomem *reg_status;
+	void __iomem *reg_int_status;
+	void __iomem *reg_dma_status;
+	void __iomem *reg_dma_read_status;
+	void __iomem *reg_dma_write_status;
+	u32 qcontrol; /* Cached control register */
+
+	/* Status values from job */
+	u32 int_status;
+	u32 q_status;
+	u32 q_int_status;
+	u32 cmd_error;
+
+	/* Interrupt wait queue */
+	wait_queue_head_t int_queue;
+	unsigned int int_rcvd;
+} ____cacheline_aligned;
+
+struct ccp_device {
+	struct list_head entry;
+
+	struct ccp_vdata *vdata;
+	unsigned int ord;
+	char name[MAX_CCP_NAME_LEN];
+	char rngname[MAX_CCP_NAME_LEN];
+
+	struct device *dev;
+
+	/* Bus specific device information
+	 */
+	void *dev_specific;
+	int (*get_irq)(struct ccp_device *ccp);
+	void (*free_irq)(struct ccp_device *ccp);
+	unsigned int irq;
+
+	/* I/O area used for device communication. The register mapping
+	 * starts at an offset into the mapped bar.
+	 *   The CMD_REQx registers and the Delete_Cmd_Queue_Job register
+	 *   need to be protected while a command queue thread is accessing
+	 *   them.
+	 */
+	struct mutex req_mutex ____cacheline_aligned;
+	void __iomem *io_map;
+	void __iomem *io_regs;
+
+	/* Master lists that all cmds are queued on. Because there can be
+	 * more than one CCP command queue that can process a cmd a separate
+	 * backlog list is neeeded so that the backlog completion call
+	 * completes before the cmd is available for execution.
+	 */
+	spinlock_t cmd_lock ____cacheline_aligned;
+	unsigned int cmd_count;
+	struct list_head cmd;
+	struct list_head backlog;
+
+	/* The command queues. These represent the queues available on the
+	 * CCP that are available for processing cmds
+	 */
+	struct ccp_cmd_queue cmd_q[MAX_HW_QUEUES];
+	unsigned int cmd_q_count;
+
+	/* Support for the CCP True RNG
+	 */
+	struct hwrng hwrng;
+	unsigned int hwrng_retries;
+
+	/* Support for the CCP DMA capabilities
+	 */
+	struct dma_device dma_dev;
+	struct ccp_dma_chan *ccp_dma_chan;
+	struct kmem_cache *dma_cmd_cache;
+	struct kmem_cache *dma_desc_cache;
+
+	/* A counter used to generate job-ids for cmds submitted to the CCP
+	 */
+	atomic_t current_id ____cacheline_aligned;
+
+	/* The v3 CCP uses key storage blocks (SB) to maintain context for
+	 * certain operations. To prevent multiple cmds from using the same
+	 * SB range a command queue reserves an SB range for the duration of
+	 * the cmd. Each queue, will however, reserve 2 SB blocks for
+	 * operations that only require single SB entries (eg. AES context/iv
+	 * and key) in order to avoid allocation contention.  This will reserve
+	 * at most 10 SB entries, leaving 40 SB entries available for dynamic
+	 * allocation.
+	 *
+	 * The v5 CCP Local Storage Block (LSB) is broken up into 8
+	 * memrory ranges, each of which can be enabled for access by one
+	 * or more queues. Device initialization takes this into account,
+	 * and attempts to assign one region for exclusive use by each
+	 * available queue; the rest are then aggregated as "public" use.
+	 * If there are fewer regions than queues, all regions are shared
+	 * amongst all queues.
+	 */
+	struct mutex sb_mutex ____cacheline_aligned;
+	DECLARE_BITMAP(sb, KSB_COUNT);
+	wait_queue_head_t sb_queue;
+	unsigned int sb_avail;
+	unsigned int sb_count;
+	u32 sb_start;
+
+	/* Bitmap of shared LSBs, if any */
+	DECLARE_BITMAP(lsbmap, SLSB_MAP_SIZE);
+
+	/* Suspend support */
+	unsigned int suspending;
+	wait_queue_head_t suspend_queue;
+
+	/* DMA caching attribute support */
+	unsigned int axcache;
+};
+
+enum ccp_memtype {
+	CCP_MEMTYPE_SYSTEM = 0,
+	CCP_MEMTYPE_SB,
+	CCP_MEMTYPE_LOCAL,
+	CCP_MEMTYPE__LAST,
+};
+#define	CCP_MEMTYPE_LSB	CCP_MEMTYPE_KSB
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
+		u32 sb;
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
+	u32 sb_key;
+	u32 sb_ctx;
+	u32 init;
+	u32 eom;
+
+	struct ccp_mem src;
+	struct ccp_mem dst;
+	struct ccp_mem exp;
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
+/**
+ * descriptor for version 5 CPP commands
+ * 8 32-bit words:
+ * word 0: function; engine; control bits
+ * word 1: length of source data
+ * word 2: low 32 bits of source pointer
+ * word 3: upper 16 bits of source pointer; source memory type
+ * word 4: low 32 bits of destination pointer
+ * word 5: upper 16 bits of destination pointer; destination memory type
+ * word 6: low 32 bits of key pointer
+ * word 7: upper 16 bits of key pointer; key memory type
+ */
+struct dword0 {
+	unsigned int soc:1;
+	unsigned int ioc:1;
+	unsigned int rsvd1:1;
+	unsigned int init:1;
+	unsigned int eom:1;		/* AES/SHA only */
+	unsigned int function:15;
+	unsigned int engine:4;
+	unsigned int prot:1;
+	unsigned int rsvd2:7;
+};
+
+struct dword3 {
+	unsigned int  src_hi:16;
+	unsigned int  src_mem:2;
+	unsigned int  lsb_cxt_id:8;
+	unsigned int  rsvd1:5;
+	unsigned int  fixed:1;
+};
+
+union dword4 {
+	__le32 dst_lo;		/* NON-SHA	*/
+	__le32 sha_len_lo;	/* SHA		*/
+};
+
+union dword5 {
+	struct {
+		unsigned int  dst_hi:16;
+		unsigned int  dst_mem:2;
+		unsigned int  rsvd1:13;
+		unsigned int  fixed:1;
+	} fields;
+	__le32 sha_len_hi;
+};
+
+struct dword7 {
+	unsigned int  key_hi:16;
+	unsigned int  key_mem:2;
+	unsigned int  rsvd1:14;
+};
+
+struct ccp5_desc {
+	struct dword0 dw0;
+	__le32 length;
+	__le32 src_lo;
+	struct dword3 dw3;
+	union dword4 dw4;
+	union dword5 dw5;
+	__le32 key_lo;
+	struct dword7 dw7;
+};
+
+int ccp_pci_init(void);
+void ccp_pci_exit(void);
+
+int ccp_platform_init(void);
+void ccp_platform_exit(void);
+
+void ccp_add_device(struct ccp_device *ccp);
+void ccp_del_device(struct ccp_device *ccp);
+
+extern void ccp_log_error(struct ccp_device *, int);
+
+struct ccp_device *ccp_alloc_struct(struct device *dev);
+bool ccp_queues_suspended(struct ccp_device *ccp);
+int ccp_cmd_queue_thread(void *data);
+int ccp_trng_read(struct hwrng *rng, void *data, size_t max, bool wait);
+
+int ccp_run_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd);
+
+int ccp_register_rng(struct ccp_device *ccp);
+void ccp_unregister_rng(struct ccp_device *ccp);
+int ccp_dmaengine_register(struct ccp_device *ccp);
+void ccp_dmaengine_unregister(struct ccp_device *ccp);
+
+/* Structure for computation functions that are device-specific */
+struct ccp_actions {
+	int (*aes)(struct ccp_op *);
+	int (*xts_aes)(struct ccp_op *);
+	int (*sha)(struct ccp_op *);
+	int (*rsa)(struct ccp_op *);
+	int (*passthru)(struct ccp_op *);
+	int (*ecc)(struct ccp_op *);
+	u32 (*sballoc)(struct ccp_cmd_queue *, unsigned int);
+	void (*sbfree)(struct ccp_cmd_queue *, unsigned int,
+			       unsigned int);
+	unsigned int (*get_free_slots)(struct ccp_cmd_queue *);
+	int (*init)(struct ccp_device *);
+	void (*destroy)(struct ccp_device *);
+	irqreturn_t (*irqhandler)(int, void *);
+};
+
+/* Structure to hold CCP version-specific values */
+struct ccp_vdata {
+	const unsigned int version;
+	void (*setup)(struct ccp_device *);
+	const struct ccp_actions *perform;
+	const unsigned int bar;
+	const unsigned int offset;
+};
+
+extern const struct ccp_vdata ccpv3;
+extern const struct ccp_vdata ccpv5a;
+extern const struct ccp_vdata ccpv5b;
+
+#endif
diff --git a/drivers/misc/amd-sp/ccp-dmaengine.c b/drivers/misc/amd-sp/ccp-dmaengine.c
new file mode 100644
index 0000000..6553912
--- /dev/null
+++ b/drivers/misc/amd-sp/ccp-dmaengine.c
@@ -0,0 +1,728 @@
+/*
+ * AMD Cryptographic Coprocessor (CCP) driver
+ *
+ * Copyright (C) 2016 Advanced Micro Devices, Inc.
+ *
+ * Author: Gary R Hook <gary.hook@amd.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/dmaengine.h>
+#include <linux/spinlock.h>
+#include <linux/mutex.h>
+#include <linux/ccp.h>
+
+#include "ccp-dev.h"
+#include "../../dma/dmaengine.h"
+
+#define CCP_DMA_WIDTH(_mask)		\
+({					\
+	u64 mask = _mask + 1;		\
+	(mask == 0) ? 64 : fls64(mask);	\
+})
+
+static void ccp_free_cmd_resources(struct ccp_device *ccp,
+				   struct list_head *list)
+{
+	struct ccp_dma_cmd *cmd, *ctmp;
+
+	list_for_each_entry_safe(cmd, ctmp, list, entry) {
+		list_del(&cmd->entry);
+		kmem_cache_free(ccp->dma_cmd_cache, cmd);
+	}
+}
+
+static void ccp_free_desc_resources(struct ccp_device *ccp,
+				    struct list_head *list)
+{
+	struct ccp_dma_desc *desc, *dtmp;
+
+	list_for_each_entry_safe(desc, dtmp, list, entry) {
+		ccp_free_cmd_resources(ccp, &desc->active);
+		ccp_free_cmd_resources(ccp, &desc->pending);
+
+		list_del(&desc->entry);
+		kmem_cache_free(ccp->dma_desc_cache, desc);
+	}
+}
+
+static void ccp_free_chan_resources(struct dma_chan *dma_chan)
+{
+	struct ccp_dma_chan *chan = container_of(dma_chan, struct ccp_dma_chan,
+						 dma_chan);
+	unsigned long flags;
+
+	dev_dbg(chan->ccp->dev, "%s - chan=%p\n", __func__, chan);
+
+	spin_lock_irqsave(&chan->lock, flags);
+
+	ccp_free_desc_resources(chan->ccp, &chan->complete);
+	ccp_free_desc_resources(chan->ccp, &chan->active);
+	ccp_free_desc_resources(chan->ccp, &chan->pending);
+
+	spin_unlock_irqrestore(&chan->lock, flags);
+}
+
+static void ccp_cleanup_desc_resources(struct ccp_device *ccp,
+				       struct list_head *list)
+{
+	struct ccp_dma_desc *desc, *dtmp;
+
+	list_for_each_entry_safe_reverse(desc, dtmp, list, entry) {
+		if (!async_tx_test_ack(&desc->tx_desc))
+			continue;
+
+		dev_dbg(ccp->dev, "%s - desc=%p\n", __func__, desc);
+
+		ccp_free_cmd_resources(ccp, &desc->active);
+		ccp_free_cmd_resources(ccp, &desc->pending);
+
+		list_del(&desc->entry);
+		kmem_cache_free(ccp->dma_desc_cache, desc);
+	}
+}
+
+static void ccp_do_cleanup(unsigned long data)
+{
+	struct ccp_dma_chan *chan = (struct ccp_dma_chan *)data;
+	unsigned long flags;
+
+	dev_dbg(chan->ccp->dev, "%s - chan=%s\n", __func__,
+		dma_chan_name(&chan->dma_chan));
+
+	spin_lock_irqsave(&chan->lock, flags);
+
+	ccp_cleanup_desc_resources(chan->ccp, &chan->complete);
+
+	spin_unlock_irqrestore(&chan->lock, flags);
+}
+
+static int ccp_issue_next_cmd(struct ccp_dma_desc *desc)
+{
+	struct ccp_dma_cmd *cmd;
+	int ret;
+
+	cmd = list_first_entry(&desc->pending, struct ccp_dma_cmd, entry);
+	list_move(&cmd->entry, &desc->active);
+
+	dev_dbg(desc->ccp->dev, "%s - tx %d, cmd=%p\n", __func__,
+		desc->tx_desc.cookie, cmd);
+
+	ret = ccp_enqueue_cmd(&cmd->ccp_cmd);
+	if (!ret || (ret == -EINPROGRESS) || (ret == -EBUSY))
+		return 0;
+
+	dev_dbg(desc->ccp->dev, "%s - error: ret=%d, tx %d, cmd=%p\n", __func__,
+		ret, desc->tx_desc.cookie, cmd);
+
+	return ret;
+}
+
+static void ccp_free_active_cmd(struct ccp_dma_desc *desc)
+{
+	struct ccp_dma_cmd *cmd;
+
+	cmd = list_first_entry_or_null(&desc->active, struct ccp_dma_cmd,
+				       entry);
+	if (!cmd)
+		return;
+
+	dev_dbg(desc->ccp->dev, "%s - freeing tx %d cmd=%p\n",
+		__func__, desc->tx_desc.cookie, cmd);
+
+	list_del(&cmd->entry);
+	kmem_cache_free(desc->ccp->dma_cmd_cache, cmd);
+}
+
+static struct ccp_dma_desc *__ccp_next_dma_desc(struct ccp_dma_chan *chan,
+						struct ccp_dma_desc *desc)
+{
+	/* Move current DMA descriptor to the complete list */
+	if (desc)
+		list_move(&desc->entry, &chan->complete);
+
+	/* Get the next DMA descriptor on the active list */
+	desc = list_first_entry_or_null(&chan->active, struct ccp_dma_desc,
+					entry);
+
+	return desc;
+}
+
+static struct ccp_dma_desc *ccp_handle_active_desc(struct ccp_dma_chan *chan,
+						   struct ccp_dma_desc *desc)
+{
+	struct dma_async_tx_descriptor *tx_desc;
+	unsigned long flags;
+
+	/* Loop over descriptors until one is found with commands */
+	do {
+		if (desc) {
+			/* Remove the DMA command from the list and free it */
+			ccp_free_active_cmd(desc);
+
+			if (!list_empty(&desc->pending)) {
+				/* No errors, keep going */
+				if (desc->status != DMA_ERROR)
+					return desc;
+
+				/* Error, free remaining commands and move on */
+				ccp_free_cmd_resources(desc->ccp,
+						       &desc->pending);
+			}
+
+			tx_desc = &desc->tx_desc;
+		} else {
+			tx_desc = NULL;
+		}
+
+		spin_lock_irqsave(&chan->lock, flags);
+
+		if (desc) {
+			if (desc->status != DMA_ERROR)
+				desc->status = DMA_COMPLETE;
+
+			dev_dbg(desc->ccp->dev,
+				"%s - tx %d complete, status=%u\n", __func__,
+				desc->tx_desc.cookie, desc->status);
+
+			dma_cookie_complete(tx_desc);
+		}
+
+		desc = __ccp_next_dma_desc(chan, desc);
+
+		spin_unlock_irqrestore(&chan->lock, flags);
+
+		if (tx_desc) {
+			if (tx_desc->callback &&
+			    (tx_desc->flags & DMA_PREP_INTERRUPT))
+				tx_desc->callback(tx_desc->callback_param);
+
+			dma_run_dependencies(tx_desc);
+		}
+	} while (desc);
+
+	return NULL;
+}
+
+static struct ccp_dma_desc *__ccp_pending_to_active(struct ccp_dma_chan *chan)
+{
+	struct ccp_dma_desc *desc;
+
+	if (list_empty(&chan->pending))
+		return NULL;
+
+	desc = list_empty(&chan->active)
+		? list_first_entry(&chan->pending, struct ccp_dma_desc, entry)
+		: NULL;
+
+	list_splice_tail_init(&chan->pending, &chan->active);
+
+	return desc;
+}
+
+static void ccp_cmd_callback(void *data, int err)
+{
+	struct ccp_dma_desc *desc = data;
+	struct ccp_dma_chan *chan;
+	int ret;
+
+	if (err == -EINPROGRESS)
+		return;
+
+	chan = container_of(desc->tx_desc.chan, struct ccp_dma_chan,
+			    dma_chan);
+
+	dev_dbg(chan->ccp->dev, "%s - tx %d callback, err=%d\n",
+		__func__, desc->tx_desc.cookie, err);
+
+	if (err)
+		desc->status = DMA_ERROR;
+
+	while (true) {
+		/* Check for DMA descriptor completion */
+		desc = ccp_handle_active_desc(chan, desc);
+
+		/* Don't submit cmd if no descriptor or DMA is paused */
+		if (!desc || (chan->status == DMA_PAUSED))
+			break;
+
+		ret = ccp_issue_next_cmd(desc);
+		if (!ret)
+			break;
+
+		desc->status = DMA_ERROR;
+	}
+
+	tasklet_schedule(&chan->cleanup_tasklet);
+}
+
+static dma_cookie_t ccp_tx_submit(struct dma_async_tx_descriptor *tx_desc)
+{
+	struct ccp_dma_desc *desc = container_of(tx_desc, struct ccp_dma_desc,
+						 tx_desc);
+	struct ccp_dma_chan *chan;
+	dma_cookie_t cookie;
+	unsigned long flags;
+
+	chan = container_of(tx_desc->chan, struct ccp_dma_chan, dma_chan);
+
+	spin_lock_irqsave(&chan->lock, flags);
+
+	cookie = dma_cookie_assign(tx_desc);
+	list_add_tail(&desc->entry, &chan->pending);
+
+	spin_unlock_irqrestore(&chan->lock, flags);
+
+	dev_dbg(chan->ccp->dev, "%s - added tx descriptor %d to pending list\n",
+		__func__, cookie);
+
+	return cookie;
+}
+
+static struct ccp_dma_cmd *ccp_alloc_dma_cmd(struct ccp_dma_chan *chan)
+{
+	struct ccp_dma_cmd *cmd;
+
+	cmd = kmem_cache_alloc(chan->ccp->dma_cmd_cache, GFP_NOWAIT);
+	if (cmd)
+		memset(cmd, 0, sizeof(*cmd));
+
+	return cmd;
+}
+
+static struct ccp_dma_desc *ccp_alloc_dma_desc(struct ccp_dma_chan *chan,
+					       unsigned long flags)
+{
+	struct ccp_dma_desc *desc;
+
+	desc = kmem_cache_zalloc(chan->ccp->dma_desc_cache, GFP_NOWAIT);
+	if (!desc)
+		return NULL;
+
+	dma_async_tx_descriptor_init(&desc->tx_desc, &chan->dma_chan);
+	desc->tx_desc.flags = flags;
+	desc->tx_desc.tx_submit = ccp_tx_submit;
+	desc->ccp = chan->ccp;
+	INIT_LIST_HEAD(&desc->pending);
+	INIT_LIST_HEAD(&desc->active);
+	desc->status = DMA_IN_PROGRESS;
+
+	return desc;
+}
+
+static struct ccp_dma_desc *ccp_create_desc(struct dma_chan *dma_chan,
+					    struct scatterlist *dst_sg,
+					    unsigned int dst_nents,
+					    struct scatterlist *src_sg,
+					    unsigned int src_nents,
+					    unsigned long flags)
+{
+	struct ccp_dma_chan *chan = container_of(dma_chan, struct ccp_dma_chan,
+						 dma_chan);
+	struct ccp_device *ccp = chan->ccp;
+	struct ccp_dma_desc *desc;
+	struct ccp_dma_cmd *cmd;
+	struct ccp_cmd *ccp_cmd;
+	struct ccp_passthru_nomap_engine *ccp_pt;
+	unsigned int src_offset, src_len;
+	unsigned int dst_offset, dst_len;
+	unsigned int len;
+	unsigned long sflags;
+	size_t total_len;
+
+	if (!dst_sg || !src_sg)
+		return NULL;
+
+	if (!dst_nents || !src_nents)
+		return NULL;
+
+	desc = ccp_alloc_dma_desc(chan, flags);
+	if (!desc)
+		return NULL;
+
+	total_len = 0;
+
+	src_len = sg_dma_len(src_sg);
+	src_offset = 0;
+
+	dst_len = sg_dma_len(dst_sg);
+	dst_offset = 0;
+
+	while (true) {
+		if (!src_len) {
+			src_nents--;
+			if (!src_nents)
+				break;
+
+			src_sg = sg_next(src_sg);
+			if (!src_sg)
+				break;
+
+			src_len = sg_dma_len(src_sg);
+			src_offset = 0;
+			continue;
+		}
+
+		if (!dst_len) {
+			dst_nents--;
+			if (!dst_nents)
+				break;
+
+			dst_sg = sg_next(dst_sg);
+			if (!dst_sg)
+				break;
+
+			dst_len = sg_dma_len(dst_sg);
+			dst_offset = 0;
+			continue;
+		}
+
+		len = min(dst_len, src_len);
+
+		cmd = ccp_alloc_dma_cmd(chan);
+		if (!cmd)
+			goto err;
+
+		ccp_cmd = &cmd->ccp_cmd;
+		ccp_pt = &ccp_cmd->u.passthru_nomap;
+		ccp_cmd->flags = CCP_CMD_MAY_BACKLOG;
+		ccp_cmd->flags |= CCP_CMD_PASSTHRU_NO_DMA_MAP;
+		ccp_cmd->engine = CCP_ENGINE_PASSTHRU;
+		ccp_pt->bit_mod = CCP_PASSTHRU_BITWISE_NOOP;
+		ccp_pt->byte_swap = CCP_PASSTHRU_BYTESWAP_NOOP;
+		ccp_pt->src_dma = sg_dma_address(src_sg) + src_offset;
+		ccp_pt->dst_dma = sg_dma_address(dst_sg) + dst_offset;
+		ccp_pt->src_len = len;
+		ccp_pt->final = 1;
+		ccp_cmd->callback = ccp_cmd_callback;
+		ccp_cmd->data = desc;
+
+		list_add_tail(&cmd->entry, &desc->pending);
+
+		dev_dbg(ccp->dev,
+			"%s - cmd=%p, src=%pad, dst=%pad, len=%llu\n", __func__,
+			cmd, &ccp_pt->src_dma,
+			&ccp_pt->dst_dma, ccp_pt->src_len);
+
+		total_len += len;
+
+		src_len -= len;
+		src_offset += len;
+
+		dst_len -= len;
+		dst_offset += len;
+	}
+
+	desc->len = total_len;
+
+	if (list_empty(&desc->pending))
+		goto err;
+
+	dev_dbg(ccp->dev, "%s - desc=%p\n", __func__, desc);
+
+	spin_lock_irqsave(&chan->lock, sflags);
+
+	list_add_tail(&desc->entry, &chan->pending);
+
+	spin_unlock_irqrestore(&chan->lock, sflags);
+
+	return desc;
+
+err:
+	ccp_free_cmd_resources(ccp, &desc->pending);
+	kmem_cache_free(ccp->dma_desc_cache, desc);
+
+	return NULL;
+}
+
+static struct dma_async_tx_descriptor *ccp_prep_dma_memcpy(
+	struct dma_chan *dma_chan, dma_addr_t dst, dma_addr_t src, size_t len,
+	unsigned long flags)
+{
+	struct ccp_dma_chan *chan = container_of(dma_chan, struct ccp_dma_chan,
+						 dma_chan);
+	struct ccp_dma_desc *desc;
+	struct scatterlist dst_sg, src_sg;
+
+	dev_dbg(chan->ccp->dev,
+		"%s - src=%pad, dst=%pad, len=%zu, flags=%#lx\n",
+		__func__, &src, &dst, len, flags);
+
+	sg_init_table(&dst_sg, 1);
+	sg_dma_address(&dst_sg) = dst;
+	sg_dma_len(&dst_sg) = len;
+
+	sg_init_table(&src_sg, 1);
+	sg_dma_address(&src_sg) = src;
+	sg_dma_len(&src_sg) = len;
+
+	desc = ccp_create_desc(dma_chan, &dst_sg, 1, &src_sg, 1, flags);
+	if (!desc)
+		return NULL;
+
+	return &desc->tx_desc;
+}
+
+static struct dma_async_tx_descriptor *ccp_prep_dma_sg(
+	struct dma_chan *dma_chan, struct scatterlist *dst_sg,
+	unsigned int dst_nents, struct scatterlist *src_sg,
+	unsigned int src_nents, unsigned long flags)
+{
+	struct ccp_dma_chan *chan = container_of(dma_chan, struct ccp_dma_chan,
+						 dma_chan);
+	struct ccp_dma_desc *desc;
+
+	dev_dbg(chan->ccp->dev,
+		"%s - src=%p, src_nents=%u dst=%p, dst_nents=%u, flags=%#lx\n",
+		__func__, src_sg, src_nents, dst_sg, dst_nents, flags);
+
+	desc = ccp_create_desc(dma_chan, dst_sg, dst_nents, src_sg, src_nents,
+			       flags);
+	if (!desc)
+		return NULL;
+
+	return &desc->tx_desc;
+}
+
+static struct dma_async_tx_descriptor *ccp_prep_dma_interrupt(
+	struct dma_chan *dma_chan, unsigned long flags)
+{
+	struct ccp_dma_chan *chan = container_of(dma_chan, struct ccp_dma_chan,
+						 dma_chan);
+	struct ccp_dma_desc *desc;
+
+	desc = ccp_alloc_dma_desc(chan, flags);
+	if (!desc)
+		return NULL;
+
+	return &desc->tx_desc;
+}
+
+static void ccp_issue_pending(struct dma_chan *dma_chan)
+{
+	struct ccp_dma_chan *chan = container_of(dma_chan, struct ccp_dma_chan,
+						 dma_chan);
+	struct ccp_dma_desc *desc;
+	unsigned long flags;
+
+	dev_dbg(chan->ccp->dev, "%s\n", __func__);
+
+	spin_lock_irqsave(&chan->lock, flags);
+
+	desc = __ccp_pending_to_active(chan);
+
+	spin_unlock_irqrestore(&chan->lock, flags);
+
+	/* If there was nothing active, start processing */
+	if (desc)
+		ccp_cmd_callback(desc, 0);
+}
+
+static enum dma_status ccp_tx_status(struct dma_chan *dma_chan,
+				     dma_cookie_t cookie,
+				     struct dma_tx_state *state)
+{
+	struct ccp_dma_chan *chan = container_of(dma_chan, struct ccp_dma_chan,
+						 dma_chan);
+	struct ccp_dma_desc *desc;
+	enum dma_status ret;
+	unsigned long flags;
+
+	if (chan->status == DMA_PAUSED) {
+		ret = DMA_PAUSED;
+		goto out;
+	}
+
+	ret = dma_cookie_status(dma_chan, cookie, state);
+	if (ret == DMA_COMPLETE) {
+		spin_lock_irqsave(&chan->lock, flags);
+
+		/* Get status from complete chain, if still there */
+		list_for_each_entry(desc, &chan->complete, entry) {
+			if (desc->tx_desc.cookie != cookie)
+				continue;
+
+			ret = desc->status;
+			break;
+		}
+
+		spin_unlock_irqrestore(&chan->lock, flags);
+	}
+
+out:
+	dev_dbg(chan->ccp->dev, "%s - %u\n", __func__, ret);
+
+	return ret;
+}
+
+static int ccp_pause(struct dma_chan *dma_chan)
+{
+	struct ccp_dma_chan *chan = container_of(dma_chan, struct ccp_dma_chan,
+						 dma_chan);
+
+	chan->status = DMA_PAUSED;
+
+	/*TODO: Wait for active DMA to complete before returning? */
+
+	return 0;
+}
+
+static int ccp_resume(struct dma_chan *dma_chan)
+{
+	struct ccp_dma_chan *chan = container_of(dma_chan, struct ccp_dma_chan,
+						 dma_chan);
+	struct ccp_dma_desc *desc;
+	unsigned long flags;
+
+	spin_lock_irqsave(&chan->lock, flags);
+
+	desc = list_first_entry_or_null(&chan->active, struct ccp_dma_desc,
+					entry);
+
+	spin_unlock_irqrestore(&chan->lock, flags);
+
+	/* Indicate the channel is running again */
+	chan->status = DMA_IN_PROGRESS;
+
+	/* If there was something active, re-start */
+	if (desc)
+		ccp_cmd_callback(desc, 0);
+
+	return 0;
+}
+
+static int ccp_terminate_all(struct dma_chan *dma_chan)
+{
+	struct ccp_dma_chan *chan = container_of(dma_chan, struct ccp_dma_chan,
+						 dma_chan);
+	unsigned long flags;
+
+	dev_dbg(chan->ccp->dev, "%s\n", __func__);
+
+	/*TODO: Wait for active DMA to complete before continuing */
+
+	spin_lock_irqsave(&chan->lock, flags);
+
+	/*TODO: Purge the complete list? */
+	ccp_free_desc_resources(chan->ccp, &chan->active);
+	ccp_free_desc_resources(chan->ccp, &chan->pending);
+
+	spin_unlock_irqrestore(&chan->lock, flags);
+
+	return 0;
+}
+
+int ccp_dmaengine_register(struct ccp_device *ccp)
+{
+	struct ccp_dma_chan *chan;
+	struct dma_device *dma_dev = &ccp->dma_dev;
+	struct dma_chan *dma_chan;
+	char *dma_cmd_cache_name;
+	char *dma_desc_cache_name;
+	unsigned int i;
+	int ret;
+
+	ccp->ccp_dma_chan = devm_kcalloc(ccp->dev, ccp->cmd_q_count,
+					 sizeof(*(ccp->ccp_dma_chan)),
+					 GFP_KERNEL);
+	if (!ccp->ccp_dma_chan)
+		return -ENOMEM;
+
+	dma_cmd_cache_name = devm_kasprintf(ccp->dev, GFP_KERNEL,
+					    "%s-dmaengine-cmd-cache",
+					    ccp->name);
+	if (!dma_cmd_cache_name)
+		return -ENOMEM;
+
+	ccp->dma_cmd_cache = kmem_cache_create(dma_cmd_cache_name,
+					       sizeof(struct ccp_dma_cmd),
+					       sizeof(void *),
+					       SLAB_HWCACHE_ALIGN, NULL);
+	if (!ccp->dma_cmd_cache)
+		return -ENOMEM;
+
+	dma_desc_cache_name = devm_kasprintf(ccp->dev, GFP_KERNEL,
+					     "%s-dmaengine-desc-cache",
+					     ccp->name);
+	if (!dma_desc_cache_name) {
+		ret = -ENOMEM;
+		goto err_cache;
+	}
+
+	ccp->dma_desc_cache = kmem_cache_create(dma_desc_cache_name,
+						sizeof(struct ccp_dma_desc),
+						sizeof(void *),
+						SLAB_HWCACHE_ALIGN, NULL);
+	if (!ccp->dma_desc_cache) {
+		ret = -ENOMEM;
+		goto err_cache;
+	}
+
+	dma_dev->dev = ccp->dev;
+	dma_dev->src_addr_widths = CCP_DMA_WIDTH(dma_get_mask(ccp->dev));
+	dma_dev->dst_addr_widths = CCP_DMA_WIDTH(dma_get_mask(ccp->dev));
+	dma_dev->directions = DMA_MEM_TO_MEM;
+	dma_dev->residue_granularity = DMA_RESIDUE_GRANULARITY_DESCRIPTOR;
+	dma_cap_set(DMA_MEMCPY, dma_dev->cap_mask);
+	dma_cap_set(DMA_SG, dma_dev->cap_mask);
+	dma_cap_set(DMA_INTERRUPT, dma_dev->cap_mask);
+
+	INIT_LIST_HEAD(&dma_dev->channels);
+	for (i = 0; i < ccp->cmd_q_count; i++) {
+		chan = ccp->ccp_dma_chan + i;
+		dma_chan = &chan->dma_chan;
+
+		chan->ccp = ccp;
+
+		spin_lock_init(&chan->lock);
+		INIT_LIST_HEAD(&chan->pending);
+		INIT_LIST_HEAD(&chan->active);
+		INIT_LIST_HEAD(&chan->complete);
+
+		tasklet_init(&chan->cleanup_tasklet, ccp_do_cleanup,
+			     (unsigned long)chan);
+
+		dma_chan->device = dma_dev;
+		dma_cookie_init(dma_chan);
+
+		list_add_tail(&dma_chan->device_node, &dma_dev->channels);
+	}
+
+	dma_dev->device_free_chan_resources = ccp_free_chan_resources;
+	dma_dev->device_prep_dma_memcpy = ccp_prep_dma_memcpy;
+	dma_dev->device_prep_dma_sg = ccp_prep_dma_sg;
+	dma_dev->device_prep_dma_interrupt = ccp_prep_dma_interrupt;
+	dma_dev->device_issue_pending = ccp_issue_pending;
+	dma_dev->device_tx_status = ccp_tx_status;
+	dma_dev->device_pause = ccp_pause;
+	dma_dev->device_resume = ccp_resume;
+	dma_dev->device_terminate_all = ccp_terminate_all;
+
+	ret = dma_async_device_register(dma_dev);
+	if (ret)
+		goto err_reg;
+
+	return 0;
+
+err_reg:
+	kmem_cache_destroy(ccp->dma_desc_cache);
+
+err_cache:
+	kmem_cache_destroy(ccp->dma_cmd_cache);
+
+	return ret;
+}
+
+void ccp_dmaengine_unregister(struct ccp_device *ccp)
+{
+	struct dma_device *dma_dev = &ccp->dma_dev;
+
+	dma_async_device_unregister(dma_dev);
+
+	kmem_cache_destroy(ccp->dma_desc_cache);
+	kmem_cache_destroy(ccp->dma_cmd_cache);
+}
diff --git a/drivers/misc/amd-sp/ccp-ops.c b/drivers/misc/amd-sp/ccp-ops.c
new file mode 100644
index 0000000..50fae44
--- /dev/null
+++ b/drivers/misc/amd-sp/ccp-ops.c
@@ -0,0 +1,1876 @@
+/*
+ * AMD Cryptographic Coprocessor (CCP) driver
+ *
+ * Copyright (C) 2013,2016 Advanced Micro Devices, Inc.
+ *
+ * Author: Tom Lendacky <thomas.lendacky@amd.com>
+ * Author: Gary R Hook <gary.hook@amd.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/pci.h>
+#include <linux/interrupt.h>
+#include <crypto/scatterwalk.h>
+#include <linux/ccp.h>
+
+#include "ccp-dev.h"
+
+/* SHA initial context values */
+static const __be32 ccp_sha1_init[SHA1_DIGEST_SIZE / sizeof(__be32)] = {
+	cpu_to_be32(SHA1_H0), cpu_to_be32(SHA1_H1),
+	cpu_to_be32(SHA1_H2), cpu_to_be32(SHA1_H3),
+	cpu_to_be32(SHA1_H4),
+};
+
+static const __be32 ccp_sha224_init[SHA256_DIGEST_SIZE / sizeof(__be32)] = {
+	cpu_to_be32(SHA224_H0), cpu_to_be32(SHA224_H1),
+	cpu_to_be32(SHA224_H2), cpu_to_be32(SHA224_H3),
+	cpu_to_be32(SHA224_H4), cpu_to_be32(SHA224_H5),
+	cpu_to_be32(SHA224_H6), cpu_to_be32(SHA224_H7),
+};
+
+static const __be32 ccp_sha256_init[SHA256_DIGEST_SIZE / sizeof(__be32)] = {
+	cpu_to_be32(SHA256_H0), cpu_to_be32(SHA256_H1),
+	cpu_to_be32(SHA256_H2), cpu_to_be32(SHA256_H3),
+	cpu_to_be32(SHA256_H4), cpu_to_be32(SHA256_H5),
+	cpu_to_be32(SHA256_H6), cpu_to_be32(SHA256_H7),
+};
+
+#define	CCP_NEW_JOBID(ccp)	((ccp->vdata->version == CCP_VERSION(3, 0)) ? \
+					ccp_gen_jobid(ccp) : 0)
+
+static u32 ccp_gen_jobid(struct ccp_device *ccp)
+{
+	return atomic_inc_return(&ccp->current_id) & CCP_JOBID_MASK;
+}
+
+static void ccp_sg_free(struct ccp_sg_workarea *wa)
+{
+	if (wa->dma_count)
+		dma_unmap_sg(wa->dma_dev, wa->dma_sg, wa->nents, wa->dma_dir);
+
+	wa->dma_count = 0;
+}
+
+static int ccp_init_sg_workarea(struct ccp_sg_workarea *wa, struct device *dev,
+				struct scatterlist *sg, u64 len,
+				enum dma_data_direction dma_dir)
+{
+	memset(wa, 0, sizeof(*wa));
+
+	wa->sg = sg;
+	if (!sg)
+		return 0;
+
+	wa->nents = sg_nents_for_len(sg, len);
+	if (wa->nents < 0)
+		return wa->nents;
+
+	wa->bytes_left = len;
+	wa->sg_used = 0;
+
+	if (len == 0)
+		return 0;
+
+	if (dma_dir == DMA_NONE)
+		return 0;
+
+	wa->dma_sg = sg;
+	wa->dma_dev = dev;
+	wa->dma_dir = dma_dir;
+	wa->dma_count = dma_map_sg(dev, sg, wa->nents, dma_dir);
+	if (!wa->dma_count)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void ccp_update_sg_workarea(struct ccp_sg_workarea *wa, unsigned int len)
+{
+	unsigned int nbytes = min_t(u64, len, wa->bytes_left);
+
+	if (!wa->sg)
+		return;
+
+	wa->sg_used += nbytes;
+	wa->bytes_left -= nbytes;
+	if (wa->sg_used == wa->sg->length) {
+		wa->sg = sg_next(wa->sg);
+		wa->sg_used = 0;
+	}
+}
+
+static void ccp_dm_free(struct ccp_dm_workarea *wa)
+{
+	if (wa->length <= CCP_DMAPOOL_MAX_SIZE) {
+		if (wa->address)
+			dma_pool_free(wa->dma_pool, wa->address,
+				      wa->dma.address);
+	} else {
+		if (wa->dma.address)
+			dma_unmap_single(wa->dev, wa->dma.address, wa->length,
+					 wa->dma.dir);
+		kfree(wa->address);
+	}
+
+	wa->address = NULL;
+	wa->dma.address = 0;
+}
+
+static int ccp_init_dm_workarea(struct ccp_dm_workarea *wa,
+				struct ccp_cmd_queue *cmd_q,
+				unsigned int len,
+				enum dma_data_direction dir)
+{
+	memset(wa, 0, sizeof(*wa));
+
+	if (!len)
+		return 0;
+
+	wa->dev = cmd_q->ccp->dev;
+	wa->length = len;
+
+	if (len <= CCP_DMAPOOL_MAX_SIZE) {
+		wa->dma_pool = cmd_q->dma_pool;
+
+		wa->address = dma_pool_alloc(wa->dma_pool, GFP_KERNEL,
+					     &wa->dma.address);
+		if (!wa->address)
+			return -ENOMEM;
+
+		wa->dma.length = CCP_DMAPOOL_MAX_SIZE;
+
+		memset(wa->address, 0, CCP_DMAPOOL_MAX_SIZE);
+	} else {
+		wa->address = kzalloc(len, GFP_KERNEL);
+		if (!wa->address)
+			return -ENOMEM;
+
+		wa->dma.address = dma_map_single(wa->dev, wa->address, len,
+						 dir);
+		if (!wa->dma.address)
+			return -ENOMEM;
+
+		wa->dma.length = len;
+	}
+	wa->dma.dir = dir;
+
+	return 0;
+}
+
+static void ccp_set_dm_area(struct ccp_dm_workarea *wa, unsigned int wa_offset,
+			    struct scatterlist *sg, unsigned int sg_offset,
+			    unsigned int len)
+{
+	WARN_ON(!wa->address);
+
+	scatterwalk_map_and_copy(wa->address + wa_offset, sg, sg_offset, len,
+				 0);
+}
+
+static void ccp_get_dm_area(struct ccp_dm_workarea *wa, unsigned int wa_offset,
+			    struct scatterlist *sg, unsigned int sg_offset,
+			    unsigned int len)
+{
+	WARN_ON(!wa->address);
+
+	scatterwalk_map_and_copy(wa->address + wa_offset, sg, sg_offset, len,
+				 1);
+}
+
+static int ccp_reverse_set_dm_area(struct ccp_dm_workarea *wa,
+				   struct scatterlist *sg,
+				   unsigned int len, unsigned int se_len,
+				   bool sign_extend)
+{
+	unsigned int nbytes, sg_offset, dm_offset, sb_len, i;
+	u8 buffer[CCP_REVERSE_BUF_SIZE];
+
+	if (WARN_ON(se_len > sizeof(buffer)))
+		return -EINVAL;
+
+	sg_offset = len;
+	dm_offset = 0;
+	nbytes = len;
+	while (nbytes) {
+		sb_len = min_t(unsigned int, nbytes, se_len);
+		sg_offset -= sb_len;
+
+		scatterwalk_map_and_copy(buffer, sg, sg_offset, sb_len, 0);
+		for (i = 0; i < sb_len; i++)
+			wa->address[dm_offset + i] = buffer[sb_len - i - 1];
+
+		dm_offset += sb_len;
+		nbytes -= sb_len;
+
+		if ((sb_len != se_len) && sign_extend) {
+			/* Must sign-extend to nearest sign-extend length */
+			if (wa->address[dm_offset - 1] & 0x80)
+				memset(wa->address + dm_offset, 0xff,
+				       se_len - sb_len);
+		}
+	}
+
+	return 0;
+}
+
+static void ccp_reverse_get_dm_area(struct ccp_dm_workarea *wa,
+				    struct scatterlist *sg,
+				    unsigned int len)
+{
+	unsigned int nbytes, sg_offset, dm_offset, sb_len, i;
+	u8 buffer[CCP_REVERSE_BUF_SIZE];
+
+	sg_offset = 0;
+	dm_offset = len;
+	nbytes = len;
+	while (nbytes) {
+		sb_len = min_t(unsigned int, nbytes, sizeof(buffer));
+		dm_offset -= sb_len;
+
+		for (i = 0; i < sb_len; i++)
+			buffer[sb_len - i - 1] = wa->address[dm_offset + i];
+		scatterwalk_map_and_copy(buffer, sg, sg_offset, sb_len, 1);
+
+		sg_offset += sb_len;
+		nbytes -= sb_len;
+	}
+}
+
+static void ccp_free_data(struct ccp_data *data, struct ccp_cmd_queue *cmd_q)
+{
+	ccp_dm_free(&data->dm_wa);
+	ccp_sg_free(&data->sg_wa);
+}
+
+static int ccp_init_data(struct ccp_data *data, struct ccp_cmd_queue *cmd_q,
+			 struct scatterlist *sg, u64 sg_len,
+			 unsigned int dm_len,
+			 enum dma_data_direction dir)
+{
+	int ret;
+
+	memset(data, 0, sizeof(*data));
+
+	ret = ccp_init_sg_workarea(&data->sg_wa, cmd_q->ccp->dev, sg, sg_len,
+				   dir);
+	if (ret)
+		goto e_err;
+
+	ret = ccp_init_dm_workarea(&data->dm_wa, cmd_q, dm_len, dir);
+	if (ret)
+		goto e_err;
+
+	return 0;
+
+e_err:
+	ccp_free_data(data, cmd_q);
+
+	return ret;
+}
+
+static unsigned int ccp_queue_buf(struct ccp_data *data, unsigned int from)
+{
+	struct ccp_sg_workarea *sg_wa = &data->sg_wa;
+	struct ccp_dm_workarea *dm_wa = &data->dm_wa;
+	unsigned int buf_count, nbytes;
+
+	/* Clear the buffer if setting it */
+	if (!from)
+		memset(dm_wa->address, 0, dm_wa->length);
+
+	if (!sg_wa->sg)
+		return 0;
+
+	/* Perform the copy operation
+	 *   nbytes will always be <= UINT_MAX because dm_wa->length is
+	 *   an unsigned int
+	 */
+	nbytes = min_t(u64, sg_wa->bytes_left, dm_wa->length);
+	scatterwalk_map_and_copy(dm_wa->address, sg_wa->sg, sg_wa->sg_used,
+				 nbytes, from);
+
+	/* Update the structures and generate the count */
+	buf_count = 0;
+	while (sg_wa->bytes_left && (buf_count < dm_wa->length)) {
+		nbytes = min(sg_wa->sg->length - sg_wa->sg_used,
+			     dm_wa->length - buf_count);
+		nbytes = min_t(u64, sg_wa->bytes_left, nbytes);
+
+		buf_count += nbytes;
+		ccp_update_sg_workarea(sg_wa, nbytes);
+	}
+
+	return buf_count;
+}
+
+static unsigned int ccp_fill_queue_buf(struct ccp_data *data)
+{
+	return ccp_queue_buf(data, 0);
+}
+
+static unsigned int ccp_empty_queue_buf(struct ccp_data *data)
+{
+	return ccp_queue_buf(data, 1);
+}
+
+static void ccp_prepare_data(struct ccp_data *src, struct ccp_data *dst,
+			     struct ccp_op *op, unsigned int block_size,
+			     bool blocksize_op)
+{
+	unsigned int sg_src_len, sg_dst_len, op_len;
+
+	/* The CCP can only DMA from/to one address each per operation. This
+	 * requires that we find the smallest DMA area between the source
+	 * and destination. The resulting len values will always be <= UINT_MAX
+	 * because the dma length is an unsigned int.
+	 */
+	sg_src_len = sg_dma_len(src->sg_wa.sg) - src->sg_wa.sg_used;
+	sg_src_len = min_t(u64, src->sg_wa.bytes_left, sg_src_len);
+
+	if (dst) {
+		sg_dst_len = sg_dma_len(dst->sg_wa.sg) - dst->sg_wa.sg_used;
+		sg_dst_len = min_t(u64, src->sg_wa.bytes_left, sg_dst_len);
+		op_len = min(sg_src_len, sg_dst_len);
+	} else {
+		op_len = sg_src_len;
+	}
+
+	/* The data operation length will be at least block_size in length
+	 * or the smaller of available sg room remaining for the source or
+	 * the destination
+	 */
+	op_len = max(op_len, block_size);
+
+	/* Unless we have to buffer data, there's no reason to wait */
+	op->soc = 0;
+
+	if (sg_src_len < block_size) {
+		/* Not enough data in the sg element, so it
+		 * needs to be buffered into a blocksize chunk
+		 */
+		int cp_len = ccp_fill_queue_buf(src);
+
+		op->soc = 1;
+		op->src.u.dma.address = src->dm_wa.dma.address;
+		op->src.u.dma.offset = 0;
+		op->src.u.dma.length = (blocksize_op) ? block_size : cp_len;
+	} else {
+		/* Enough data in the sg element, but we need to
+		 * adjust for any previously copied data
+		 */
+		op->src.u.dma.address = sg_dma_address(src->sg_wa.sg);
+		op->src.u.dma.offset = src->sg_wa.sg_used;
+		op->src.u.dma.length = op_len & ~(block_size - 1);
+
+		ccp_update_sg_workarea(&src->sg_wa, op->src.u.dma.length);
+	}
+
+	if (dst) {
+		if (sg_dst_len < block_size) {
+			/* Not enough room in the sg element or we're on the
+			 * last piece of data (when using padding), so the
+			 * output needs to be buffered into a blocksize chunk
+			 */
+			op->soc = 1;
+			op->dst.u.dma.address = dst->dm_wa.dma.address;
+			op->dst.u.dma.offset = 0;
+			op->dst.u.dma.length = op->src.u.dma.length;
+		} else {
+			/* Enough room in the sg element, but we need to
+			 * adjust for any previously used area
+			 */
+			op->dst.u.dma.address = sg_dma_address(dst->sg_wa.sg);
+			op->dst.u.dma.offset = dst->sg_wa.sg_used;
+			op->dst.u.dma.length = op->src.u.dma.length;
+		}
+	}
+}
+
+static void ccp_process_data(struct ccp_data *src, struct ccp_data *dst,
+			     struct ccp_op *op)
+{
+	op->init = 0;
+
+	if (dst) {
+		if (op->dst.u.dma.address == dst->dm_wa.dma.address)
+			ccp_empty_queue_buf(dst);
+		else
+			ccp_update_sg_workarea(&dst->sg_wa,
+					       op->dst.u.dma.length);
+	}
+}
+
+static int ccp_copy_to_from_sb(struct ccp_cmd_queue *cmd_q,
+			       struct ccp_dm_workarea *wa, u32 jobid, u32 sb,
+			       u32 byte_swap, bool from)
+{
+	struct ccp_op op;
+
+	memset(&op, 0, sizeof(op));
+
+	op.cmd_q = cmd_q;
+	op.jobid = jobid;
+	op.eom = 1;
+
+	if (from) {
+		op.soc = 1;
+		op.src.type = CCP_MEMTYPE_SB;
+		op.src.u.sb = sb;
+		op.dst.type = CCP_MEMTYPE_SYSTEM;
+		op.dst.u.dma.address = wa->dma.address;
+		op.dst.u.dma.length = wa->length;
+	} else {
+		op.src.type = CCP_MEMTYPE_SYSTEM;
+		op.src.u.dma.address = wa->dma.address;
+		op.src.u.dma.length = wa->length;
+		op.dst.type = CCP_MEMTYPE_SB;
+		op.dst.u.sb = sb;
+	}
+
+	op.u.passthru.byte_swap = byte_swap;
+
+	return cmd_q->ccp->vdata->perform->passthru(&op);
+}
+
+static int ccp_copy_to_sb(struct ccp_cmd_queue *cmd_q,
+			  struct ccp_dm_workarea *wa, u32 jobid, u32 sb,
+			  u32 byte_swap)
+{
+	return ccp_copy_to_from_sb(cmd_q, wa, jobid, sb, byte_swap, false);
+}
+
+static int ccp_copy_from_sb(struct ccp_cmd_queue *cmd_q,
+			    struct ccp_dm_workarea *wa, u32 jobid, u32 sb,
+			    u32 byte_swap)
+{
+	return ccp_copy_to_from_sb(cmd_q, wa, jobid, sb, byte_swap, true);
+}
+
+static int ccp_run_aes_cmac_cmd(struct ccp_cmd_queue *cmd_q,
+				struct ccp_cmd *cmd)
+{
+	struct ccp_aes_engine *aes = &cmd->u.aes;
+	struct ccp_dm_workarea key, ctx;
+	struct ccp_data src;
+	struct ccp_op op;
+	unsigned int dm_offset;
+	int ret;
+
+	if (!((aes->key_len == AES_KEYSIZE_128) ||
+	      (aes->key_len == AES_KEYSIZE_192) ||
+	      (aes->key_len == AES_KEYSIZE_256)))
+		return -EINVAL;
+
+	if (aes->src_len & (AES_BLOCK_SIZE - 1))
+		return -EINVAL;
+
+	if (aes->iv_len != AES_BLOCK_SIZE)
+		return -EINVAL;
+
+	if (!aes->key || !aes->iv || !aes->src)
+		return -EINVAL;
+
+	if (aes->cmac_final) {
+		if (aes->cmac_key_len != AES_BLOCK_SIZE)
+			return -EINVAL;
+
+		if (!aes->cmac_key)
+			return -EINVAL;
+	}
+
+	BUILD_BUG_ON(CCP_AES_KEY_SB_COUNT != 1);
+	BUILD_BUG_ON(CCP_AES_CTX_SB_COUNT != 1);
+
+	ret = -EIO;
+	memset(&op, 0, sizeof(op));
+	op.cmd_q = cmd_q;
+	op.jobid = CCP_NEW_JOBID(cmd_q->ccp);
+	op.sb_key = cmd_q->sb_key;
+	op.sb_ctx = cmd_q->sb_ctx;
+	op.init = 1;
+	op.u.aes.type = aes->type;
+	op.u.aes.mode = aes->mode;
+	op.u.aes.action = aes->action;
+
+	/* All supported key sizes fit in a single (32-byte) SB entry
+	 * and must be in little endian format. Use the 256-bit byte
+	 * swap passthru option to convert from big endian to little
+	 * endian.
+	 */
+	ret = ccp_init_dm_workarea(&key, cmd_q,
+				   CCP_AES_KEY_SB_COUNT * CCP_SB_BYTES,
+				   DMA_TO_DEVICE);
+	if (ret)
+		return ret;
+
+	dm_offset = CCP_SB_BYTES - aes->key_len;
+	ccp_set_dm_area(&key, dm_offset, aes->key, 0, aes->key_len);
+	ret = ccp_copy_to_sb(cmd_q, &key, op.jobid, op.sb_key,
+			     CCP_PASSTHRU_BYTESWAP_256BIT);
+	if (ret) {
+		cmd->engine_error = cmd_q->cmd_error;
+		goto e_key;
+	}
+
+	/* The AES context fits in a single (32-byte) SB entry and
+	 * must be in little endian format. Use the 256-bit byte swap
+	 * passthru option to convert from big endian to little endian.
+	 */
+	ret = ccp_init_dm_workarea(&ctx, cmd_q,
+				   CCP_AES_CTX_SB_COUNT * CCP_SB_BYTES,
+				   DMA_BIDIRECTIONAL);
+	if (ret)
+		goto e_key;
+
+	dm_offset = CCP_SB_BYTES - AES_BLOCK_SIZE;
+	ccp_set_dm_area(&ctx, dm_offset, aes->iv, 0, aes->iv_len);
+	ret = ccp_copy_to_sb(cmd_q, &ctx, op.jobid, op.sb_ctx,
+			     CCP_PASSTHRU_BYTESWAP_256BIT);
+	if (ret) {
+		cmd->engine_error = cmd_q->cmd_error;
+		goto e_ctx;
+	}
+
+	/* Send data to the CCP AES engine */
+	ret = ccp_init_data(&src, cmd_q, aes->src, aes->src_len,
+			    AES_BLOCK_SIZE, DMA_TO_DEVICE);
+	if (ret)
+		goto e_ctx;
+
+	while (src.sg_wa.bytes_left) {
+		ccp_prepare_data(&src, NULL, &op, AES_BLOCK_SIZE, true);
+		if (aes->cmac_final && !src.sg_wa.bytes_left) {
+			op.eom = 1;
+
+			/* Push the K1/K2 key to the CCP now */
+			ret = ccp_copy_from_sb(cmd_q, &ctx, op.jobid,
+					       op.sb_ctx,
+					       CCP_PASSTHRU_BYTESWAP_256BIT);
+			if (ret) {
+				cmd->engine_error = cmd_q->cmd_error;
+				goto e_src;
+			}
+
+			ccp_set_dm_area(&ctx, 0, aes->cmac_key, 0,
+					aes->cmac_key_len);
+			ret = ccp_copy_to_sb(cmd_q, &ctx, op.jobid, op.sb_ctx,
+					     CCP_PASSTHRU_BYTESWAP_256BIT);
+			if (ret) {
+				cmd->engine_error = cmd_q->cmd_error;
+				goto e_src;
+			}
+		}
+
+		ret = cmd_q->ccp->vdata->perform->aes(&op);
+		if (ret) {
+			cmd->engine_error = cmd_q->cmd_error;
+			goto e_src;
+		}
+
+		ccp_process_data(&src, NULL, &op);
+	}
+
+	/* Retrieve the AES context - convert from LE to BE using
+	 * 32-byte (256-bit) byteswapping
+	 */
+	ret = ccp_copy_from_sb(cmd_q, &ctx, op.jobid, op.sb_ctx,
+			       CCP_PASSTHRU_BYTESWAP_256BIT);
+	if (ret) {
+		cmd->engine_error = cmd_q->cmd_error;
+		goto e_src;
+	}
+
+	/* ...but we only need AES_BLOCK_SIZE bytes */
+	dm_offset = CCP_SB_BYTES - AES_BLOCK_SIZE;
+	ccp_get_dm_area(&ctx, dm_offset, aes->iv, 0, aes->iv_len);
+
+e_src:
+	ccp_free_data(&src, cmd_q);
+
+e_ctx:
+	ccp_dm_free(&ctx);
+
+e_key:
+	ccp_dm_free(&key);
+
+	return ret;
+}
+
+static int ccp_run_aes_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
+{
+	struct ccp_aes_engine *aes = &cmd->u.aes;
+	struct ccp_dm_workarea key, ctx;
+	struct ccp_data src, dst;
+	struct ccp_op op;
+	unsigned int dm_offset;
+	bool in_place = false;
+	int ret;
+
+	if (aes->mode == CCP_AES_MODE_CMAC)
+		return ccp_run_aes_cmac_cmd(cmd_q, cmd);
+
+	if (!((aes->key_len == AES_KEYSIZE_128) ||
+	      (aes->key_len == AES_KEYSIZE_192) ||
+	      (aes->key_len == AES_KEYSIZE_256)))
+		return -EINVAL;
+
+	if (((aes->mode == CCP_AES_MODE_ECB) ||
+	     (aes->mode == CCP_AES_MODE_CBC) ||
+	     (aes->mode == CCP_AES_MODE_CFB)) &&
+	    (aes->src_len & (AES_BLOCK_SIZE - 1)))
+		return -EINVAL;
+
+	if (!aes->key || !aes->src || !aes->dst)
+		return -EINVAL;
+
+	if (aes->mode != CCP_AES_MODE_ECB) {
+		if (aes->iv_len != AES_BLOCK_SIZE)
+			return -EINVAL;
+
+		if (!aes->iv)
+			return -EINVAL;
+	}
+
+	BUILD_BUG_ON(CCP_AES_KEY_SB_COUNT != 1);
+	BUILD_BUG_ON(CCP_AES_CTX_SB_COUNT != 1);
+
+	ret = -EIO;
+	memset(&op, 0, sizeof(op));
+	op.cmd_q = cmd_q;
+	op.jobid = CCP_NEW_JOBID(cmd_q->ccp);
+	op.sb_key = cmd_q->sb_key;
+	op.sb_ctx = cmd_q->sb_ctx;
+	op.init = (aes->mode == CCP_AES_MODE_ECB) ? 0 : 1;
+	op.u.aes.type = aes->type;
+	op.u.aes.mode = aes->mode;
+	op.u.aes.action = aes->action;
+
+	/* All supported key sizes fit in a single (32-byte) SB entry
+	 * and must be in little endian format. Use the 256-bit byte
+	 * swap passthru option to convert from big endian to little
+	 * endian.
+	 */
+	ret = ccp_init_dm_workarea(&key, cmd_q,
+				   CCP_AES_KEY_SB_COUNT * CCP_SB_BYTES,
+				   DMA_TO_DEVICE);
+	if (ret)
+		return ret;
+
+	dm_offset = CCP_SB_BYTES - aes->key_len;
+	ccp_set_dm_area(&key, dm_offset, aes->key, 0, aes->key_len);
+	ret = ccp_copy_to_sb(cmd_q, &key, op.jobid, op.sb_key,
+			     CCP_PASSTHRU_BYTESWAP_256BIT);
+	if (ret) {
+		cmd->engine_error = cmd_q->cmd_error;
+		goto e_key;
+	}
+
+	/* The AES context fits in a single (32-byte) SB entry and
+	 * must be in little endian format. Use the 256-bit byte swap
+	 * passthru option to convert from big endian to little endian.
+	 */
+	ret = ccp_init_dm_workarea(&ctx, cmd_q,
+				   CCP_AES_CTX_SB_COUNT * CCP_SB_BYTES,
+				   DMA_BIDIRECTIONAL);
+	if (ret)
+		goto e_key;
+
+	if (aes->mode != CCP_AES_MODE_ECB) {
+		/* Load the AES context - convert to LE */
+		dm_offset = CCP_SB_BYTES - AES_BLOCK_SIZE;
+		ccp_set_dm_area(&ctx, dm_offset, aes->iv, 0, aes->iv_len);
+		ret = ccp_copy_to_sb(cmd_q, &ctx, op.jobid, op.sb_ctx,
+				     CCP_PASSTHRU_BYTESWAP_256BIT);
+		if (ret) {
+			cmd->engine_error = cmd_q->cmd_error;
+			goto e_ctx;
+		}
+	}
+
+	/* Prepare the input and output data workareas. For in-place
+	 * operations we need to set the dma direction to BIDIRECTIONAL
+	 * and copy the src workarea to the dst workarea.
+	 */
+	if (sg_virt(aes->src) == sg_virt(aes->dst))
+		in_place = true;
+
+	ret = ccp_init_data(&src, cmd_q, aes->src, aes->src_len,
+			    AES_BLOCK_SIZE,
+			    in_place ? DMA_BIDIRECTIONAL : DMA_TO_DEVICE);
+	if (ret)
+		goto e_ctx;
+
+	if (in_place) {
+		dst = src;
+	} else {
+		ret = ccp_init_data(&dst, cmd_q, aes->dst, aes->src_len,
+				    AES_BLOCK_SIZE, DMA_FROM_DEVICE);
+		if (ret)
+			goto e_src;
+	}
+
+	/* Send data to the CCP AES engine */
+	while (src.sg_wa.bytes_left) {
+		ccp_prepare_data(&src, &dst, &op, AES_BLOCK_SIZE, true);
+		if (!src.sg_wa.bytes_left) {
+			op.eom = 1;
+
+			/* Since we don't retrieve the AES context in ECB
+			 * mode we have to wait for the operation to complete
+			 * on the last piece of data
+			 */
+			if (aes->mode == CCP_AES_MODE_ECB)
+				op.soc = 1;
+		}
+
+		ret = cmd_q->ccp->vdata->perform->aes(&op);
+		if (ret) {
+			cmd->engine_error = cmd_q->cmd_error;
+			goto e_dst;
+		}
+
+		ccp_process_data(&src, &dst, &op);
+	}
+
+	if (aes->mode != CCP_AES_MODE_ECB) {
+		/* Retrieve the AES context - convert from LE to BE using
+		 * 32-byte (256-bit) byteswapping
+		 */
+		ret = ccp_copy_from_sb(cmd_q, &ctx, op.jobid, op.sb_ctx,
+				       CCP_PASSTHRU_BYTESWAP_256BIT);
+		if (ret) {
+			cmd->engine_error = cmd_q->cmd_error;
+			goto e_dst;
+		}
+
+		/* ...but we only need AES_BLOCK_SIZE bytes */
+		dm_offset = CCP_SB_BYTES - AES_BLOCK_SIZE;
+		ccp_get_dm_area(&ctx, dm_offset, aes->iv, 0, aes->iv_len);
+	}
+
+e_dst:
+	if (!in_place)
+		ccp_free_data(&dst, cmd_q);
+
+e_src:
+	ccp_free_data(&src, cmd_q);
+
+e_ctx:
+	ccp_dm_free(&ctx);
+
+e_key:
+	ccp_dm_free(&key);
+
+	return ret;
+}
+
+static int ccp_run_xts_aes_cmd(struct ccp_cmd_queue *cmd_q,
+			       struct ccp_cmd *cmd)
+{
+	struct ccp_xts_aes_engine *xts = &cmd->u.xts;
+	struct ccp_dm_workarea key, ctx;
+	struct ccp_data src, dst;
+	struct ccp_op op;
+	unsigned int unit_size, dm_offset;
+	bool in_place = false;
+	int ret;
+
+	switch (xts->unit_size) {
+	case CCP_XTS_AES_UNIT_SIZE_16:
+		unit_size = 16;
+		break;
+	case CCP_XTS_AES_UNIT_SIZE_512:
+		unit_size = 512;
+		break;
+	case CCP_XTS_AES_UNIT_SIZE_1024:
+		unit_size = 1024;
+		break;
+	case CCP_XTS_AES_UNIT_SIZE_2048:
+		unit_size = 2048;
+		break;
+	case CCP_XTS_AES_UNIT_SIZE_4096:
+		unit_size = 4096;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	if (xts->key_len != AES_KEYSIZE_128)
+		return -EINVAL;
+
+	if (!xts->final && (xts->src_len & (AES_BLOCK_SIZE - 1)))
+		return -EINVAL;
+
+	if (xts->iv_len != AES_BLOCK_SIZE)
+		return -EINVAL;
+
+	if (!xts->key || !xts->iv || !xts->src || !xts->dst)
+		return -EINVAL;
+
+	BUILD_BUG_ON(CCP_XTS_AES_KEY_SB_COUNT != 1);
+	BUILD_BUG_ON(CCP_XTS_AES_CTX_SB_COUNT != 1);
+
+	ret = -EIO;
+	memset(&op, 0, sizeof(op));
+	op.cmd_q = cmd_q;
+	op.jobid = CCP_NEW_JOBID(cmd_q->ccp);
+	op.sb_key = cmd_q->sb_key;
+	op.sb_ctx = cmd_q->sb_ctx;
+	op.init = 1;
+	op.u.xts.action = xts->action;
+	op.u.xts.unit_size = xts->unit_size;
+
+	/* All supported key sizes fit in a single (32-byte) SB entry
+	 * and must be in little endian format. Use the 256-bit byte
+	 * swap passthru option to convert from big endian to little
+	 * endian.
+	 */
+	ret = ccp_init_dm_workarea(&key, cmd_q,
+				   CCP_XTS_AES_KEY_SB_COUNT * CCP_SB_BYTES,
+				   DMA_TO_DEVICE);
+	if (ret)
+		return ret;
+
+	dm_offset = CCP_SB_BYTES - AES_KEYSIZE_128;
+	ccp_set_dm_area(&key, dm_offset, xts->key, 0, xts->key_len);
+	ccp_set_dm_area(&key, 0, xts->key, dm_offset, xts->key_len);
+	ret = ccp_copy_to_sb(cmd_q, &key, op.jobid, op.sb_key,
+			     CCP_PASSTHRU_BYTESWAP_256BIT);
+	if (ret) {
+		cmd->engine_error = cmd_q->cmd_error;
+		goto e_key;
+	}
+
+	/* The AES context fits in a single (32-byte) SB entry and
+	 * for XTS is already in little endian format so no byte swapping
+	 * is needed.
+	 */
+	ret = ccp_init_dm_workarea(&ctx, cmd_q,
+				   CCP_XTS_AES_CTX_SB_COUNT * CCP_SB_BYTES,
+				   DMA_BIDIRECTIONAL);
+	if (ret)
+		goto e_key;
+
+	ccp_set_dm_area(&ctx, 0, xts->iv, 0, xts->iv_len);
+	ret = ccp_copy_to_sb(cmd_q, &ctx, op.jobid, op.sb_ctx,
+			     CCP_PASSTHRU_BYTESWAP_NOOP);
+	if (ret) {
+		cmd->engine_error = cmd_q->cmd_error;
+		goto e_ctx;
+	}
+
+	/* Prepare the input and output data workareas. For in-place
+	 * operations we need to set the dma direction to BIDIRECTIONAL
+	 * and copy the src workarea to the dst workarea.
+	 */
+	if (sg_virt(xts->src) == sg_virt(xts->dst))
+		in_place = true;
+
+	ret = ccp_init_data(&src, cmd_q, xts->src, xts->src_len,
+			    unit_size,
+			    in_place ? DMA_BIDIRECTIONAL : DMA_TO_DEVICE);
+	if (ret)
+		goto e_ctx;
+
+	if (in_place) {
+		dst = src;
+	} else {
+		ret = ccp_init_data(&dst, cmd_q, xts->dst, xts->src_len,
+				    unit_size, DMA_FROM_DEVICE);
+		if (ret)
+			goto e_src;
+	}
+
+	/* Send data to the CCP AES engine */
+	while (src.sg_wa.bytes_left) {
+		ccp_prepare_data(&src, &dst, &op, unit_size, true);
+		if (!src.sg_wa.bytes_left)
+			op.eom = 1;
+
+		ret = cmd_q->ccp->vdata->perform->xts_aes(&op);
+		if (ret) {
+			cmd->engine_error = cmd_q->cmd_error;
+			goto e_dst;
+		}
+
+		ccp_process_data(&src, &dst, &op);
+	}
+
+	/* Retrieve the AES context - convert from LE to BE using
+	 * 32-byte (256-bit) byteswapping
+	 */
+	ret = ccp_copy_from_sb(cmd_q, &ctx, op.jobid, op.sb_ctx,
+			       CCP_PASSTHRU_BYTESWAP_256BIT);
+	if (ret) {
+		cmd->engine_error = cmd_q->cmd_error;
+		goto e_dst;
+	}
+
+	/* ...but we only need AES_BLOCK_SIZE bytes */
+	dm_offset = CCP_SB_BYTES - AES_BLOCK_SIZE;
+	ccp_get_dm_area(&ctx, dm_offset, xts->iv, 0, xts->iv_len);
+
+e_dst:
+	if (!in_place)
+		ccp_free_data(&dst, cmd_q);
+
+e_src:
+	ccp_free_data(&src, cmd_q);
+
+e_ctx:
+	ccp_dm_free(&ctx);
+
+e_key:
+	ccp_dm_free(&key);
+
+	return ret;
+}
+
+static int ccp_run_sha_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
+{
+	struct ccp_sha_engine *sha = &cmd->u.sha;
+	struct ccp_dm_workarea ctx;
+	struct ccp_data src;
+	struct ccp_op op;
+	unsigned int ioffset, ooffset;
+	unsigned int digest_size;
+	int sb_count;
+	const void *init;
+	u64 block_size;
+	int ctx_size;
+	int ret;
+
+	switch (sha->type) {
+	case CCP_SHA_TYPE_1:
+		if (sha->ctx_len < SHA1_DIGEST_SIZE)
+			return -EINVAL;
+		block_size = SHA1_BLOCK_SIZE;
+		break;
+	case CCP_SHA_TYPE_224:
+		if (sha->ctx_len < SHA224_DIGEST_SIZE)
+			return -EINVAL;
+		block_size = SHA224_BLOCK_SIZE;
+		break;
+	case CCP_SHA_TYPE_256:
+		if (sha->ctx_len < SHA256_DIGEST_SIZE)
+			return -EINVAL;
+		block_size = SHA256_BLOCK_SIZE;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (!sha->ctx)
+		return -EINVAL;
+
+	if (!sha->final && (sha->src_len & (block_size - 1)))
+		return -EINVAL;
+
+	/* The version 3 device can't handle zero-length input */
+	if (cmd_q->ccp->vdata->version == CCP_VERSION(3, 0)) {
+
+		if (!sha->src_len) {
+			unsigned int digest_len;
+			const u8 *sha_zero;
+
+			/* Not final, just return */
+			if (!sha->final)
+				return 0;
+
+			/* CCP can't do a zero length sha operation so the
+			 * caller must buffer the data.
+			 */
+			if (sha->msg_bits)
+				return -EINVAL;
+
+			/* The CCP cannot perform zero-length sha operations
+			 * so the caller is required to buffer data for the
+			 * final operation. However, a sha operation for a
+			 * message with a total length of zero is valid so
+			 * known values are required to supply the result.
+			 */
+			switch (sha->type) {
+			case CCP_SHA_TYPE_1:
+				sha_zero = sha1_zero_message_hash;
+				digest_len = SHA1_DIGEST_SIZE;
+				break;
+			case CCP_SHA_TYPE_224:
+				sha_zero = sha224_zero_message_hash;
+				digest_len = SHA224_DIGEST_SIZE;
+				break;
+			case CCP_SHA_TYPE_256:
+				sha_zero = sha256_zero_message_hash;
+				digest_len = SHA256_DIGEST_SIZE;
+				break;
+			default:
+				return -EINVAL;
+			}
+
+			scatterwalk_map_and_copy((void *)sha_zero, sha->ctx, 0,
+						 digest_len, 1);
+
+			return 0;
+		}
+	}
+
+	/* Set variables used throughout */
+	switch (sha->type) {
+	case CCP_SHA_TYPE_1:
+		digest_size = SHA1_DIGEST_SIZE;
+		init = (void *) ccp_sha1_init;
+		ctx_size = SHA1_DIGEST_SIZE;
+		sb_count = 1;
+		if (cmd_q->ccp->vdata->version != CCP_VERSION(3, 0))
+			ooffset = ioffset = CCP_SB_BYTES - SHA1_DIGEST_SIZE;
+		else
+			ooffset = ioffset = 0;
+		break;
+	case CCP_SHA_TYPE_224:
+		digest_size = SHA224_DIGEST_SIZE;
+		init = (void *) ccp_sha224_init;
+		ctx_size = SHA256_DIGEST_SIZE;
+		sb_count = 1;
+		ioffset = 0;
+		if (cmd_q->ccp->vdata->version != CCP_VERSION(3, 0))
+			ooffset = CCP_SB_BYTES - SHA224_DIGEST_SIZE;
+		else
+			ooffset = 0;
+		break;
+	case CCP_SHA_TYPE_256:
+		digest_size = SHA256_DIGEST_SIZE;
+		init = (void *) ccp_sha256_init;
+		ctx_size = SHA256_DIGEST_SIZE;
+		sb_count = 1;
+		ooffset = ioffset = 0;
+		break;
+	default:
+		ret = -EINVAL;
+		goto e_data;
+	}
+
+	/* For zero-length plaintext the src pointer is ignored;
+	 * otherwise both parts must be valid
+	 */
+	if (sha->src_len && !sha->src)
+		return -EINVAL;
+
+	memset(&op, 0, sizeof(op));
+	op.cmd_q = cmd_q;
+	op.jobid = CCP_NEW_JOBID(cmd_q->ccp);
+	op.sb_ctx = cmd_q->sb_ctx; /* Pre-allocated */
+	op.u.sha.type = sha->type;
+	op.u.sha.msg_bits = sha->msg_bits;
+
+	ret = ccp_init_dm_workarea(&ctx, cmd_q, sb_count * CCP_SB_BYTES,
+				   DMA_BIDIRECTIONAL);
+	if (ret)
+		return ret;
+	if (sha->first) {
+		switch (sha->type) {
+		case CCP_SHA_TYPE_1:
+		case CCP_SHA_TYPE_224:
+		case CCP_SHA_TYPE_256:
+			memcpy(ctx.address + ioffset, init, ctx_size);
+			break;
+		default:
+			ret = -EINVAL;
+			goto e_ctx;
+		}
+	} else {
+		/* Restore the context */
+		ccp_set_dm_area(&ctx, 0, sha->ctx, 0,
+				sb_count * CCP_SB_BYTES);
+	}
+
+	ret = ccp_copy_to_sb(cmd_q, &ctx, op.jobid, op.sb_ctx,
+			     CCP_PASSTHRU_BYTESWAP_256BIT);
+	if (ret) {
+		cmd->engine_error = cmd_q->cmd_error;
+		goto e_ctx;
+	}
+
+	if (sha->src) {
+		/* Send data to the CCP SHA engine; block_size is set above */
+		ret = ccp_init_data(&src, cmd_q, sha->src, sha->src_len,
+				    block_size, DMA_TO_DEVICE);
+		if (ret)
+			goto e_ctx;
+
+		while (src.sg_wa.bytes_left) {
+			ccp_prepare_data(&src, NULL, &op, block_size, false);
+			if (sha->final && !src.sg_wa.bytes_left)
+				op.eom = 1;
+
+			ret = cmd_q->ccp->vdata->perform->sha(&op);
+			if (ret) {
+				cmd->engine_error = cmd_q->cmd_error;
+				goto e_data;
+			}
+
+			ccp_process_data(&src, NULL, &op);
+		}
+	} else {
+		op.eom = 1;
+		ret = cmd_q->ccp->vdata->perform->sha(&op);
+		if (ret) {
+			cmd->engine_error = cmd_q->cmd_error;
+			goto e_data;
+		}
+	}
+
+	/* Retrieve the SHA context - convert from LE to BE using
+	 * 32-byte (256-bit) byteswapping to BE
+	 */
+	ret = ccp_copy_from_sb(cmd_q, &ctx, op.jobid, op.sb_ctx,
+			       CCP_PASSTHRU_BYTESWAP_256BIT);
+	if (ret) {
+		cmd->engine_error = cmd_q->cmd_error;
+		goto e_data;
+	}
+
+	if (sha->final) {
+		/* Finishing up, so get the digest */
+		switch (sha->type) {
+		case CCP_SHA_TYPE_1:
+		case CCP_SHA_TYPE_224:
+		case CCP_SHA_TYPE_256:
+			ccp_get_dm_area(&ctx, ooffset,
+					sha->ctx, 0,
+					digest_size);
+			break;
+		default:
+			ret = -EINVAL;
+			goto e_ctx;
+		}
+	} else {
+		/* Stash the context */
+		ccp_get_dm_area(&ctx, 0, sha->ctx, 0,
+				sb_count * CCP_SB_BYTES);
+	}
+
+	if (sha->final && sha->opad) {
+		/* HMAC operation, recursively perform final SHA */
+		struct ccp_cmd hmac_cmd;
+		struct scatterlist sg;
+		u8 *hmac_buf;
+
+		if (sha->opad_len != block_size) {
+			ret = -EINVAL;
+			goto e_data;
+		}
+
+		hmac_buf = kmalloc(block_size + digest_size, GFP_KERNEL);
+		if (!hmac_buf) {
+			ret = -ENOMEM;
+			goto e_data;
+		}
+		sg_init_one(&sg, hmac_buf, block_size + digest_size);
+
+		scatterwalk_map_and_copy(hmac_buf, sha->opad, 0, block_size, 0);
+		switch (sha->type) {
+		case CCP_SHA_TYPE_1:
+		case CCP_SHA_TYPE_224:
+		case CCP_SHA_TYPE_256:
+			memcpy(hmac_buf + block_size,
+			       ctx.address + ooffset,
+			       digest_size);
+			break;
+		default:
+			ret = -EINVAL;
+			goto e_ctx;
+		}
+
+		memset(&hmac_cmd, 0, sizeof(hmac_cmd));
+		hmac_cmd.engine = CCP_ENGINE_SHA;
+		hmac_cmd.u.sha.type = sha->type;
+		hmac_cmd.u.sha.ctx = sha->ctx;
+		hmac_cmd.u.sha.ctx_len = sha->ctx_len;
+		hmac_cmd.u.sha.src = &sg;
+		hmac_cmd.u.sha.src_len = block_size + digest_size;
+		hmac_cmd.u.sha.opad = NULL;
+		hmac_cmd.u.sha.opad_len = 0;
+		hmac_cmd.u.sha.first = 1;
+		hmac_cmd.u.sha.final = 1;
+		hmac_cmd.u.sha.msg_bits = (block_size + digest_size) << 3;
+
+		ret = ccp_run_sha_cmd(cmd_q, &hmac_cmd);
+		if (ret)
+			cmd->engine_error = hmac_cmd.engine_error;
+
+		kfree(hmac_buf);
+	}
+
+e_data:
+	if (sha->src)
+		ccp_free_data(&src, cmd_q);
+
+e_ctx:
+	ccp_dm_free(&ctx);
+
+	return ret;
+}
+
+static int ccp_run_rsa_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
+{
+	struct ccp_rsa_engine *rsa = &cmd->u.rsa;
+	struct ccp_dm_workarea exp, src;
+	struct ccp_data dst;
+	struct ccp_op op;
+	unsigned int sb_count, i_len, o_len;
+	int ret;
+
+	if (rsa->key_size > CCP_RSA_MAX_WIDTH)
+		return -EINVAL;
+
+	if (!rsa->exp || !rsa->mod || !rsa->src || !rsa->dst)
+		return -EINVAL;
+
+	/* The RSA modulus must precede the message being acted upon, so
+	 * it must be copied to a DMA area where the message and the
+	 * modulus can be concatenated.  Therefore the input buffer
+	 * length required is twice the output buffer length (which
+	 * must be a multiple of 256-bits).
+	 */
+	o_len = ((rsa->key_size + 255) / 256) * 32;
+	i_len = o_len * 2;
+
+	sb_count = o_len / CCP_SB_BYTES;
+
+	memset(&op, 0, sizeof(op));
+	op.cmd_q = cmd_q;
+	op.jobid = ccp_gen_jobid(cmd_q->ccp);
+	op.sb_key = cmd_q->ccp->vdata->perform->sballoc(cmd_q, sb_count);
+
+	if (!op.sb_key)
+		return -EIO;
+
+	/* The RSA exponent may span multiple (32-byte) SB entries and must
+	 * be in little endian format. Reverse copy each 32-byte chunk
+	 * of the exponent (En chunk to E0 chunk, E(n-1) chunk to E1 chunk)
+	 * and each byte within that chunk and do not perform any byte swap
+	 * operations on the passthru operation.
+	 */
+	ret = ccp_init_dm_workarea(&exp, cmd_q, o_len, DMA_TO_DEVICE);
+	if (ret)
+		goto e_sb;
+
+	ret = ccp_reverse_set_dm_area(&exp, rsa->exp, rsa->exp_len,
+				      CCP_SB_BYTES, false);
+	if (ret)
+		goto e_exp;
+	ret = ccp_copy_to_sb(cmd_q, &exp, op.jobid, op.sb_key,
+			     CCP_PASSTHRU_BYTESWAP_NOOP);
+	if (ret) {
+		cmd->engine_error = cmd_q->cmd_error;
+		goto e_exp;
+	}
+
+	/* Concatenate the modulus and the message. Both the modulus and
+	 * the operands must be in little endian format.  Since the input
+	 * is in big endian format it must be converted.
+	 */
+	ret = ccp_init_dm_workarea(&src, cmd_q, i_len, DMA_TO_DEVICE);
+	if (ret)
+		goto e_exp;
+
+	ret = ccp_reverse_set_dm_area(&src, rsa->mod, rsa->mod_len,
+				      CCP_SB_BYTES, false);
+	if (ret)
+		goto e_src;
+	src.address += o_len;	/* Adjust the address for the copy operation */
+	ret = ccp_reverse_set_dm_area(&src, rsa->src, rsa->src_len,
+				      CCP_SB_BYTES, false);
+	if (ret)
+		goto e_src;
+	src.address -= o_len;	/* Reset the address to original value */
+
+	/* Prepare the output area for the operation */
+	ret = ccp_init_data(&dst, cmd_q, rsa->dst, rsa->mod_len,
+			    o_len, DMA_FROM_DEVICE);
+	if (ret)
+		goto e_src;
+
+	op.soc = 1;
+	op.src.u.dma.address = src.dma.address;
+	op.src.u.dma.offset = 0;
+	op.src.u.dma.length = i_len;
+	op.dst.u.dma.address = dst.dm_wa.dma.address;
+	op.dst.u.dma.offset = 0;
+	op.dst.u.dma.length = o_len;
+
+	op.u.rsa.mod_size = rsa->key_size;
+	op.u.rsa.input_len = i_len;
+
+	ret = cmd_q->ccp->vdata->perform->rsa(&op);
+	if (ret) {
+		cmd->engine_error = cmd_q->cmd_error;
+		goto e_dst;
+	}
+
+	ccp_reverse_get_dm_area(&dst.dm_wa, rsa->dst, rsa->mod_len);
+
+e_dst:
+	ccp_free_data(&dst, cmd_q);
+
+e_src:
+	ccp_dm_free(&src);
+
+e_exp:
+	ccp_dm_free(&exp);
+
+e_sb:
+	cmd_q->ccp->vdata->perform->sbfree(cmd_q, op.sb_key, sb_count);
+
+	return ret;
+}
+
+static int ccp_run_passthru_cmd(struct ccp_cmd_queue *cmd_q,
+				struct ccp_cmd *cmd)
+{
+	struct ccp_passthru_engine *pt = &cmd->u.passthru;
+	struct ccp_dm_workarea mask;
+	struct ccp_data src, dst;
+	struct ccp_op op;
+	bool in_place = false;
+	unsigned int i;
+	int ret = 0;
+
+	if (!pt->final && (pt->src_len & (CCP_PASSTHRU_BLOCKSIZE - 1)))
+		return -EINVAL;
+
+	if (!pt->src || !pt->dst)
+		return -EINVAL;
+
+	if (pt->bit_mod != CCP_PASSTHRU_BITWISE_NOOP) {
+		if (pt->mask_len != CCP_PASSTHRU_MASKSIZE)
+			return -EINVAL;
+		if (!pt->mask)
+			return -EINVAL;
+	}
+
+	BUILD_BUG_ON(CCP_PASSTHRU_SB_COUNT != 1);
+
+	memset(&op, 0, sizeof(op));
+	op.cmd_q = cmd_q;
+	op.jobid = CCP_NEW_JOBID(cmd_q->ccp);
+
+	if (pt->bit_mod != CCP_PASSTHRU_BITWISE_NOOP) {
+		/* Load the mask */
+		op.sb_key = cmd_q->sb_key;
+
+		ret = ccp_init_dm_workarea(&mask, cmd_q,
+					   CCP_PASSTHRU_SB_COUNT *
+					   CCP_SB_BYTES,
+					   DMA_TO_DEVICE);
+		if (ret)
+			return ret;
+
+		ccp_set_dm_area(&mask, 0, pt->mask, 0, pt->mask_len);
+		ret = ccp_copy_to_sb(cmd_q, &mask, op.jobid, op.sb_key,
+				     CCP_PASSTHRU_BYTESWAP_NOOP);
+		if (ret) {
+			cmd->engine_error = cmd_q->cmd_error;
+			goto e_mask;
+		}
+	}
+
+	/* Prepare the input and output data workareas. For in-place
+	 * operations we need to set the dma direction to BIDIRECTIONAL
+	 * and copy the src workarea to the dst workarea.
+	 */
+	if (sg_virt(pt->src) == sg_virt(pt->dst))
+		in_place = true;
+
+	ret = ccp_init_data(&src, cmd_q, pt->src, pt->src_len,
+			    CCP_PASSTHRU_MASKSIZE,
+			    in_place ? DMA_BIDIRECTIONAL : DMA_TO_DEVICE);
+	if (ret)
+		goto e_mask;
+
+	if (in_place) {
+		dst = src;
+	} else {
+		ret = ccp_init_data(&dst, cmd_q, pt->dst, pt->src_len,
+				    CCP_PASSTHRU_MASKSIZE, DMA_FROM_DEVICE);
+		if (ret)
+			goto e_src;
+	}
+
+	/* Send data to the CCP Passthru engine
+	 *   Because the CCP engine works on a single source and destination
+	 *   dma address at a time, each entry in the source scatterlist
+	 *   (after the dma_map_sg call) must be less than or equal to the
+	 *   (remaining) length in the destination scatterlist entry and the
+	 *   length must be a multiple of CCP_PASSTHRU_BLOCKSIZE
+	 */
+	dst.sg_wa.sg_used = 0;
+	for (i = 1; i <= src.sg_wa.dma_count; i++) {
+		if (!dst.sg_wa.sg ||
+		    (dst.sg_wa.sg->length < src.sg_wa.sg->length)) {
+			ret = -EINVAL;
+			goto e_dst;
+		}
+
+		if (i == src.sg_wa.dma_count) {
+			op.eom = 1;
+			op.soc = 1;
+		}
+
+		op.src.type = CCP_MEMTYPE_SYSTEM;
+		op.src.u.dma.address = sg_dma_address(src.sg_wa.sg);
+		op.src.u.dma.offset = 0;
+		op.src.u.dma.length = sg_dma_len(src.sg_wa.sg);
+
+		op.dst.type = CCP_MEMTYPE_SYSTEM;
+		op.dst.u.dma.address = sg_dma_address(dst.sg_wa.sg);
+		op.dst.u.dma.offset = dst.sg_wa.sg_used;
+		op.dst.u.dma.length = op.src.u.dma.length;
+
+		ret = cmd_q->ccp->vdata->perform->passthru(&op);
+		if (ret) {
+			cmd->engine_error = cmd_q->cmd_error;
+			goto e_dst;
+		}
+
+		dst.sg_wa.sg_used += src.sg_wa.sg->length;
+		if (dst.sg_wa.sg_used == dst.sg_wa.sg->length) {
+			dst.sg_wa.sg = sg_next(dst.sg_wa.sg);
+			dst.sg_wa.sg_used = 0;
+		}
+		src.sg_wa.sg = sg_next(src.sg_wa.sg);
+	}
+
+e_dst:
+	if (!in_place)
+		ccp_free_data(&dst, cmd_q);
+
+e_src:
+	ccp_free_data(&src, cmd_q);
+
+e_mask:
+	if (pt->bit_mod != CCP_PASSTHRU_BITWISE_NOOP)
+		ccp_dm_free(&mask);
+
+	return ret;
+}
+
+static int ccp_run_passthru_nomap_cmd(struct ccp_cmd_queue *cmd_q,
+				      struct ccp_cmd *cmd)
+{
+	struct ccp_passthru_nomap_engine *pt = &cmd->u.passthru_nomap;
+	struct ccp_dm_workarea mask;
+	struct ccp_op op;
+	int ret;
+
+	if (!pt->final && (pt->src_len & (CCP_PASSTHRU_BLOCKSIZE - 1)))
+		return -EINVAL;
+
+	if (!pt->src_dma || !pt->dst_dma)
+		return -EINVAL;
+
+	if (pt->bit_mod != CCP_PASSTHRU_BITWISE_NOOP) {
+		if (pt->mask_len != CCP_PASSTHRU_MASKSIZE)
+			return -EINVAL;
+		if (!pt->mask)
+			return -EINVAL;
+	}
+
+	BUILD_BUG_ON(CCP_PASSTHRU_SB_COUNT != 1);
+
+	memset(&op, 0, sizeof(op));
+	op.cmd_q = cmd_q;
+	op.jobid = ccp_gen_jobid(cmd_q->ccp);
+
+	if (pt->bit_mod != CCP_PASSTHRU_BITWISE_NOOP) {
+		/* Load the mask */
+		op.sb_key = cmd_q->sb_key;
+
+		mask.length = pt->mask_len;
+		mask.dma.address = pt->mask;
+		mask.dma.length = pt->mask_len;
+
+		ret = ccp_copy_to_sb(cmd_q, &mask, op.jobid, op.sb_key,
+				     CCP_PASSTHRU_BYTESWAP_NOOP);
+		if (ret) {
+			cmd->engine_error = cmd_q->cmd_error;
+			return ret;
+		}
+	}
+
+	/* Send data to the CCP Passthru engine */
+	op.eom = 1;
+	op.soc = 1;
+
+	op.src.type = CCP_MEMTYPE_SYSTEM;
+	op.src.u.dma.address = pt->src_dma;
+	op.src.u.dma.offset = 0;
+	op.src.u.dma.length = pt->src_len;
+
+	op.dst.type = CCP_MEMTYPE_SYSTEM;
+	op.dst.u.dma.address = pt->dst_dma;
+	op.dst.u.dma.offset = 0;
+	op.dst.u.dma.length = pt->src_len;
+
+	ret = cmd_q->ccp->vdata->perform->passthru(&op);
+	if (ret)
+		cmd->engine_error = cmd_q->cmd_error;
+
+	return ret;
+}
+
+static int ccp_run_ecc_mm_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
+{
+	struct ccp_ecc_engine *ecc = &cmd->u.ecc;
+	struct ccp_dm_workarea src, dst;
+	struct ccp_op op;
+	int ret;
+	u8 *save;
+
+	if (!ecc->u.mm.operand_1 ||
+	    (ecc->u.mm.operand_1_len > CCP_ECC_MODULUS_BYTES))
+		return -EINVAL;
+
+	if (ecc->function != CCP_ECC_FUNCTION_MINV_384BIT)
+		if (!ecc->u.mm.operand_2 ||
+		    (ecc->u.mm.operand_2_len > CCP_ECC_MODULUS_BYTES))
+			return -EINVAL;
+
+	if (!ecc->u.mm.result ||
+	    (ecc->u.mm.result_len < CCP_ECC_MODULUS_BYTES))
+		return -EINVAL;
+
+	memset(&op, 0, sizeof(op));
+	op.cmd_q = cmd_q;
+	op.jobid = CCP_NEW_JOBID(cmd_q->ccp);
+
+	/* Concatenate the modulus and the operands. Both the modulus and
+	 * the operands must be in little endian format.  Since the input
+	 * is in big endian format it must be converted and placed in a
+	 * fixed length buffer.
+	 */
+	ret = ccp_init_dm_workarea(&src, cmd_q, CCP_ECC_SRC_BUF_SIZE,
+				   DMA_TO_DEVICE);
+	if (ret)
+		return ret;
+
+	/* Save the workarea address since it is updated in order to perform
+	 * the concatenation
+	 */
+	save = src.address;
+
+	/* Copy the ECC modulus */
+	ret = ccp_reverse_set_dm_area(&src, ecc->mod, ecc->mod_len,
+				      CCP_ECC_OPERAND_SIZE, false);
+	if (ret)
+		goto e_src;
+	src.address += CCP_ECC_OPERAND_SIZE;
+
+	/* Copy the first operand */
+	ret = ccp_reverse_set_dm_area(&src, ecc->u.mm.operand_1,
+				      ecc->u.mm.operand_1_len,
+				      CCP_ECC_OPERAND_SIZE, false);
+	if (ret)
+		goto e_src;
+	src.address += CCP_ECC_OPERAND_SIZE;
+
+	if (ecc->function != CCP_ECC_FUNCTION_MINV_384BIT) {
+		/* Copy the second operand */
+		ret = ccp_reverse_set_dm_area(&src, ecc->u.mm.operand_2,
+					      ecc->u.mm.operand_2_len,
+					      CCP_ECC_OPERAND_SIZE, false);
+		if (ret)
+			goto e_src;
+		src.address += CCP_ECC_OPERAND_SIZE;
+	}
+
+	/* Restore the workarea address */
+	src.address = save;
+
+	/* Prepare the output area for the operation */
+	ret = ccp_init_dm_workarea(&dst, cmd_q, CCP_ECC_DST_BUF_SIZE,
+				   DMA_FROM_DEVICE);
+	if (ret)
+		goto e_src;
+
+	op.soc = 1;
+	op.src.u.dma.address = src.dma.address;
+	op.src.u.dma.offset = 0;
+	op.src.u.dma.length = src.length;
+	op.dst.u.dma.address = dst.dma.address;
+	op.dst.u.dma.offset = 0;
+	op.dst.u.dma.length = dst.length;
+
+	op.u.ecc.function = cmd->u.ecc.function;
+
+	ret = cmd_q->ccp->vdata->perform->ecc(&op);
+	if (ret) {
+		cmd->engine_error = cmd_q->cmd_error;
+		goto e_dst;
+	}
+
+	ecc->ecc_result = le16_to_cpup(
+		(const __le16 *)(dst.address + CCP_ECC_RESULT_OFFSET));
+	if (!(ecc->ecc_result & CCP_ECC_RESULT_SUCCESS)) {
+		ret = -EIO;
+		goto e_dst;
+	}
+
+	/* Save the ECC result */
+	ccp_reverse_get_dm_area(&dst, ecc->u.mm.result, CCP_ECC_MODULUS_BYTES);
+
+e_dst:
+	ccp_dm_free(&dst);
+
+e_src:
+	ccp_dm_free(&src);
+
+	return ret;
+}
+
+static int ccp_run_ecc_pm_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
+{
+	struct ccp_ecc_engine *ecc = &cmd->u.ecc;
+	struct ccp_dm_workarea src, dst;
+	struct ccp_op op;
+	int ret;
+	u8 *save;
+
+	if (!ecc->u.pm.point_1.x ||
+	    (ecc->u.pm.point_1.x_len > CCP_ECC_MODULUS_BYTES) ||
+	    !ecc->u.pm.point_1.y ||
+	    (ecc->u.pm.point_1.y_len > CCP_ECC_MODULUS_BYTES))
+		return -EINVAL;
+
+	if (ecc->function == CCP_ECC_FUNCTION_PADD_384BIT) {
+		if (!ecc->u.pm.point_2.x ||
+		    (ecc->u.pm.point_2.x_len > CCP_ECC_MODULUS_BYTES) ||
+		    !ecc->u.pm.point_2.y ||
+		    (ecc->u.pm.point_2.y_len > CCP_ECC_MODULUS_BYTES))
+			return -EINVAL;
+	} else {
+		if (!ecc->u.pm.domain_a ||
+		    (ecc->u.pm.domain_a_len > CCP_ECC_MODULUS_BYTES))
+			return -EINVAL;
+
+		if (ecc->function == CCP_ECC_FUNCTION_PMUL_384BIT)
+			if (!ecc->u.pm.scalar ||
+			    (ecc->u.pm.scalar_len > CCP_ECC_MODULUS_BYTES))
+				return -EINVAL;
+	}
+
+	if (!ecc->u.pm.result.x ||
+	    (ecc->u.pm.result.x_len < CCP_ECC_MODULUS_BYTES) ||
+	    !ecc->u.pm.result.y ||
+	    (ecc->u.pm.result.y_len < CCP_ECC_MODULUS_BYTES))
+		return -EINVAL;
+
+	memset(&op, 0, sizeof(op));
+	op.cmd_q = cmd_q;
+	op.jobid = CCP_NEW_JOBID(cmd_q->ccp);
+
+	/* Concatenate the modulus and the operands. Both the modulus and
+	 * the operands must be in little endian format.  Since the input
+	 * is in big endian format it must be converted and placed in a
+	 * fixed length buffer.
+	 */
+	ret = ccp_init_dm_workarea(&src, cmd_q, CCP_ECC_SRC_BUF_SIZE,
+				   DMA_TO_DEVICE);
+	if (ret)
+		return ret;
+
+	/* Save the workarea address since it is updated in order to perform
+	 * the concatenation
+	 */
+	save = src.address;
+
+	/* Copy the ECC modulus */
+	ret = ccp_reverse_set_dm_area(&src, ecc->mod, ecc->mod_len,
+				      CCP_ECC_OPERAND_SIZE, false);
+	if (ret)
+		goto e_src;
+	src.address += CCP_ECC_OPERAND_SIZE;
+
+	/* Copy the first point X and Y coordinate */
+	ret = ccp_reverse_set_dm_area(&src, ecc->u.pm.point_1.x,
+				      ecc->u.pm.point_1.x_len,
+				      CCP_ECC_OPERAND_SIZE, false);
+	if (ret)
+		goto e_src;
+	src.address += CCP_ECC_OPERAND_SIZE;
+	ret = ccp_reverse_set_dm_area(&src, ecc->u.pm.point_1.y,
+				      ecc->u.pm.point_1.y_len,
+				      CCP_ECC_OPERAND_SIZE, false);
+	if (ret)
+		goto e_src;
+	src.address += CCP_ECC_OPERAND_SIZE;
+
+	/* Set the first point Z coordinate to 1 */
+	*src.address = 0x01;
+	src.address += CCP_ECC_OPERAND_SIZE;
+
+	if (ecc->function == CCP_ECC_FUNCTION_PADD_384BIT) {
+		/* Copy the second point X and Y coordinate */
+		ret = ccp_reverse_set_dm_area(&src, ecc->u.pm.point_2.x,
+					      ecc->u.pm.point_2.x_len,
+					      CCP_ECC_OPERAND_SIZE, false);
+		if (ret)
+			goto e_src;
+		src.address += CCP_ECC_OPERAND_SIZE;
+		ret = ccp_reverse_set_dm_area(&src, ecc->u.pm.point_2.y,
+					      ecc->u.pm.point_2.y_len,
+					      CCP_ECC_OPERAND_SIZE, false);
+		if (ret)
+			goto e_src;
+		src.address += CCP_ECC_OPERAND_SIZE;
+
+		/* Set the second point Z coordinate to 1 */
+		*src.address = 0x01;
+		src.address += CCP_ECC_OPERAND_SIZE;
+	} else {
+		/* Copy the Domain "a" parameter */
+		ret = ccp_reverse_set_dm_area(&src, ecc->u.pm.domain_a,
+					      ecc->u.pm.domain_a_len,
+					      CCP_ECC_OPERAND_SIZE, false);
+		if (ret)
+			goto e_src;
+		src.address += CCP_ECC_OPERAND_SIZE;
+
+		if (ecc->function == CCP_ECC_FUNCTION_PMUL_384BIT) {
+			/* Copy the scalar value */
+			ret = ccp_reverse_set_dm_area(&src, ecc->u.pm.scalar,
+						      ecc->u.pm.scalar_len,
+						      CCP_ECC_OPERAND_SIZE,
+						      false);
+			if (ret)
+				goto e_src;
+			src.address += CCP_ECC_OPERAND_SIZE;
+		}
+	}
+
+	/* Restore the workarea address */
+	src.address = save;
+
+	/* Prepare the output area for the operation */
+	ret = ccp_init_dm_workarea(&dst, cmd_q, CCP_ECC_DST_BUF_SIZE,
+				   DMA_FROM_DEVICE);
+	if (ret)
+		goto e_src;
+
+	op.soc = 1;
+	op.src.u.dma.address = src.dma.address;
+	op.src.u.dma.offset = 0;
+	op.src.u.dma.length = src.length;
+	op.dst.u.dma.address = dst.dma.address;
+	op.dst.u.dma.offset = 0;
+	op.dst.u.dma.length = dst.length;
+
+	op.u.ecc.function = cmd->u.ecc.function;
+
+	ret = cmd_q->ccp->vdata->perform->ecc(&op);
+	if (ret) {
+		cmd->engine_error = cmd_q->cmd_error;
+		goto e_dst;
+	}
+
+	ecc->ecc_result = le16_to_cpup(
+		(const __le16 *)(dst.address + CCP_ECC_RESULT_OFFSET));
+	if (!(ecc->ecc_result & CCP_ECC_RESULT_SUCCESS)) {
+		ret = -EIO;
+		goto e_dst;
+	}
+
+	/* Save the workarea address since it is updated as we walk through
+	 * to copy the point math result
+	 */
+	save = dst.address;
+
+	/* Save the ECC result X and Y coordinates */
+	ccp_reverse_get_dm_area(&dst, ecc->u.pm.result.x,
+				CCP_ECC_MODULUS_BYTES);
+	dst.address += CCP_ECC_OUTPUT_SIZE;
+	ccp_reverse_get_dm_area(&dst, ecc->u.pm.result.y,
+				CCP_ECC_MODULUS_BYTES);
+	dst.address += CCP_ECC_OUTPUT_SIZE;
+
+	/* Restore the workarea address */
+	dst.address = save;
+
+e_dst:
+	ccp_dm_free(&dst);
+
+e_src:
+	ccp_dm_free(&src);
+
+	return ret;
+}
+
+static int ccp_run_ecc_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
+{
+	struct ccp_ecc_engine *ecc = &cmd->u.ecc;
+
+	ecc->ecc_result = 0;
+
+	if (!ecc->mod ||
+	    (ecc->mod_len > CCP_ECC_MODULUS_BYTES))
+		return -EINVAL;
+
+	switch (ecc->function) {
+	case CCP_ECC_FUNCTION_MMUL_384BIT:
+	case CCP_ECC_FUNCTION_MADD_384BIT:
+	case CCP_ECC_FUNCTION_MINV_384BIT:
+		return ccp_run_ecc_mm_cmd(cmd_q, cmd);
+
+	case CCP_ECC_FUNCTION_PADD_384BIT:
+	case CCP_ECC_FUNCTION_PMUL_384BIT:
+	case CCP_ECC_FUNCTION_PDBL_384BIT:
+		return ccp_run_ecc_pm_cmd(cmd_q, cmd);
+
+	default:
+		return -EINVAL;
+	}
+}
+
+int ccp_run_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
+{
+	int ret;
+
+	cmd->engine_error = 0;
+	cmd_q->cmd_error = 0;
+	cmd_q->int_rcvd = 0;
+	cmd_q->free_slots = cmd_q->ccp->vdata->perform->get_free_slots(cmd_q);
+
+	switch (cmd->engine) {
+	case CCP_ENGINE_AES:
+		ret = ccp_run_aes_cmd(cmd_q, cmd);
+		break;
+	case CCP_ENGINE_XTS_AES_128:
+		ret = ccp_run_xts_aes_cmd(cmd_q, cmd);
+		break;
+	case CCP_ENGINE_SHA:
+		ret = ccp_run_sha_cmd(cmd_q, cmd);
+		break;
+	case CCP_ENGINE_RSA:
+		ret = ccp_run_rsa_cmd(cmd_q, cmd);
+		break;
+	case CCP_ENGINE_PASSTHRU:
+		if (cmd->flags & CCP_CMD_PASSTHRU_NO_DMA_MAP)
+			ret = ccp_run_passthru_nomap_cmd(cmd_q, cmd);
+		else
+			ret = ccp_run_passthru_cmd(cmd_q, cmd);
+		break;
+	case CCP_ENGINE_ECC:
+		ret = ccp_run_ecc_cmd(cmd_q, cmd);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
diff --git a/drivers/misc/amd-sp/ccp-pci.c b/drivers/misc/amd-sp/ccp-pci.c
new file mode 100644
index 0000000..28a9996
--- /dev/null
+++ b/drivers/misc/amd-sp/ccp-pci.c
@@ -0,0 +1,354 @@
+/*
+ * AMD Cryptographic Coprocessor (CCP) driver
+ *
+ * Copyright (C) 2013,2016 Advanced Micro Devices, Inc.
+ *
+ * Author: Tom Lendacky <thomas.lendacky@amd.com>
+ * Author: Gary R Hook <gary.hook@amd.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/pci.h>
+#include <linux/pci_ids.h>
+#include <linux/dma-mapping.h>
+#include <linux/kthread.h>
+#include <linux/sched.h>
+#include <linux/interrupt.h>
+#include <linux/spinlock.h>
+#include <linux/delay.h>
+#include <linux/ccp.h>
+
+#include "ccp-dev.h"
+
+#define MSIX_VECTORS			2
+
+struct ccp_msix {
+	u32 vector;
+	char name[16];
+};
+
+struct ccp_pci {
+	int msix_count;
+	struct ccp_msix msix[MSIX_VECTORS];
+};
+
+static int ccp_get_msix_irqs(struct ccp_device *ccp)
+{
+	struct ccp_pci *ccp_pci = ccp->dev_specific;
+	struct device *dev = ccp->dev;
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct msix_entry msix_entry[MSIX_VECTORS];
+	unsigned int name_len = sizeof(ccp_pci->msix[0].name) - 1;
+	int v, ret;
+
+	for (v = 0; v < ARRAY_SIZE(msix_entry); v++)
+		msix_entry[v].entry = v;
+
+	ret = pci_enable_msix_range(pdev, msix_entry, 1, v);
+	if (ret < 0)
+		return ret;
+
+	ccp_pci->msix_count = ret;
+	for (v = 0; v < ccp_pci->msix_count; v++) {
+		/* Set the interrupt names and request the irqs */
+		snprintf(ccp_pci->msix[v].name, name_len, "%s-%u",
+			 ccp->name, v);
+		ccp_pci->msix[v].vector = msix_entry[v].vector;
+		ret = request_irq(ccp_pci->msix[v].vector,
+				  ccp->vdata->perform->irqhandler,
+				  0, ccp_pci->msix[v].name, dev);
+		if (ret) {
+			dev_notice(dev, "unable to allocate MSI-X IRQ (%d)\n",
+				   ret);
+			goto e_irq;
+		}
+	}
+
+	return 0;
+
+e_irq:
+	while (v--)
+		free_irq(ccp_pci->msix[v].vector, dev);
+
+	pci_disable_msix(pdev);
+
+	ccp_pci->msix_count = 0;
+
+	return ret;
+}
+
+static int ccp_get_msi_irq(struct ccp_device *ccp)
+{
+	struct device *dev = ccp->dev;
+	struct pci_dev *pdev = to_pci_dev(dev);
+	int ret;
+
+	ret = pci_enable_msi(pdev);
+	if (ret)
+		return ret;
+
+	ccp->irq = pdev->irq;
+	ret = request_irq(ccp->irq, ccp->vdata->perform->irqhandler, 0,
+			  ccp->name, dev);
+	if (ret) {
+		dev_notice(dev, "unable to allocate MSI IRQ (%d)\n", ret);
+		goto e_msi;
+	}
+
+	return 0;
+
+e_msi:
+	pci_disable_msi(pdev);
+
+	return ret;
+}
+
+static int ccp_get_irqs(struct ccp_device *ccp)
+{
+	struct device *dev = ccp->dev;
+	int ret;
+
+	ret = ccp_get_msix_irqs(ccp);
+	if (!ret)
+		return 0;
+
+	/* Couldn't get MSI-X vectors, try MSI */
+	dev_notice(dev, "could not enable MSI-X (%d), trying MSI\n", ret);
+	ret = ccp_get_msi_irq(ccp);
+	if (!ret)
+		return 0;
+
+	/* Couldn't get MSI interrupt */
+	dev_notice(dev, "could not enable MSI (%d)\n", ret);
+
+	return ret;
+}
+
+static void ccp_free_irqs(struct ccp_device *ccp)
+{
+	struct ccp_pci *ccp_pci = ccp->dev_specific;
+	struct device *dev = ccp->dev;
+	struct pci_dev *pdev = to_pci_dev(dev);
+
+	if (ccp_pci->msix_count) {
+		while (ccp_pci->msix_count--)
+			free_irq(ccp_pci->msix[ccp_pci->msix_count].vector,
+				 dev);
+		pci_disable_msix(pdev);
+	} else if (ccp->irq) {
+		free_irq(ccp->irq, dev);
+		pci_disable_msi(pdev);
+	}
+	ccp->irq = 0;
+}
+
+static int ccp_find_mmio_area(struct ccp_device *ccp)
+{
+	struct device *dev = ccp->dev;
+	struct pci_dev *pdev = to_pci_dev(dev);
+	resource_size_t io_len;
+	unsigned long io_flags;
+
+	io_flags = pci_resource_flags(pdev, ccp->vdata->bar);
+	io_len = pci_resource_len(pdev, ccp->vdata->bar);
+	if ((io_flags & IORESOURCE_MEM) &&
+	    (io_len >= (ccp->vdata->offset + 0x800)))
+		return ccp->vdata->bar;
+
+	return -EIO;
+}
+
+static int ccp_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	struct ccp_device *ccp;
+	struct ccp_pci *ccp_pci;
+	struct device *dev = &pdev->dev;
+	unsigned int bar;
+	int ret;
+
+	ret = -ENOMEM;
+	ccp = ccp_alloc_struct(dev);
+	if (!ccp)
+		goto e_err;
+
+	ccp_pci = devm_kzalloc(dev, sizeof(*ccp_pci), GFP_KERNEL);
+	if (!ccp_pci)
+		goto e_err;
+
+	ccp->dev_specific = ccp_pci;
+	ccp->vdata = (struct ccp_vdata *)id->driver_data;
+	if (!ccp->vdata || !ccp->vdata->version) {
+		ret = -ENODEV;
+		dev_err(dev, "missing driver data\n");
+		goto e_err;
+	}
+	ccp->get_irq = ccp_get_irqs;
+	ccp->free_irq = ccp_free_irqs;
+
+	ret = pci_request_regions(pdev, "ccp");
+	if (ret) {
+		dev_err(dev, "pci_request_regions failed (%d)\n", ret);
+		goto e_err;
+	}
+
+	ret = pci_enable_device(pdev);
+	if (ret) {
+		dev_err(dev, "pci_enable_device failed (%d)\n", ret);
+		goto e_regions;
+	}
+
+	pci_set_master(pdev);
+
+	ret = ccp_find_mmio_area(ccp);
+	if (ret < 0)
+		goto e_device;
+	bar = ret;
+
+	ret = -EIO;
+	ccp->io_map = pci_iomap(pdev, bar, 0);
+	if (!ccp->io_map) {
+		dev_err(dev, "pci_iomap failed\n");
+		goto e_device;
+	}
+	ccp->io_regs = ccp->io_map + ccp->vdata->offset;
+
+	ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(48));
+	if (ret) {
+		ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32));
+		if (ret) {
+			dev_err(dev, "dma_set_mask_and_coherent failed (%d)\n",
+				ret);
+			goto e_iomap;
+		}
+	}
+
+	dev_set_drvdata(dev, ccp);
+
+	if (ccp->vdata->setup)
+		ccp->vdata->setup(ccp);
+
+	ret = ccp->vdata->perform->init(ccp);
+	if (ret)
+		goto e_iomap;
+
+	dev_notice(dev, "enabled\n");
+
+	return 0;
+
+e_iomap:
+	pci_iounmap(pdev, ccp->io_map);
+
+e_device:
+	pci_disable_device(pdev);
+
+e_regions:
+	pci_release_regions(pdev);
+
+e_err:
+	dev_notice(dev, "initialization failed\n");
+	return ret;
+}
+
+static void ccp_pci_remove(struct pci_dev *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct ccp_device *ccp = dev_get_drvdata(dev);
+
+	if (!ccp)
+		return;
+
+	ccp->vdata->perform->destroy(ccp);
+
+	pci_iounmap(pdev, ccp->io_map);
+
+	pci_disable_device(pdev);
+
+	pci_release_regions(pdev);
+
+	dev_notice(dev, "disabled\n");
+}
+
+#ifdef CONFIG_PM
+static int ccp_pci_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	struct device *dev = &pdev->dev;
+	struct ccp_device *ccp = dev_get_drvdata(dev);
+	unsigned long flags;
+	unsigned int i;
+
+	spin_lock_irqsave(&ccp->cmd_lock, flags);
+
+	ccp->suspending = 1;
+
+	/* Wake all the queue kthreads to prepare for suspend */
+	for (i = 0; i < ccp->cmd_q_count; i++)
+		wake_up_process(ccp->cmd_q[i].kthread);
+
+	spin_unlock_irqrestore(&ccp->cmd_lock, flags);
+
+	/* Wait for all queue kthreads to say they're done */
+	while (!ccp_queues_suspended(ccp))
+		wait_event_interruptible(ccp->suspend_queue,
+					 ccp_queues_suspended(ccp));
+
+	return 0;
+}
+
+static int ccp_pci_resume(struct pci_dev *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct ccp_device *ccp = dev_get_drvdata(dev);
+	unsigned long flags;
+	unsigned int i;
+
+	spin_lock_irqsave(&ccp->cmd_lock, flags);
+
+	ccp->suspending = 0;
+
+	/* Wake up all the kthreads */
+	for (i = 0; i < ccp->cmd_q_count; i++) {
+		ccp->cmd_q[i].suspended = 0;
+		wake_up_process(ccp->cmd_q[i].kthread);
+	}
+
+	spin_unlock_irqrestore(&ccp->cmd_lock, flags);
+
+	return 0;
+}
+#endif
+
+static const struct pci_device_id ccp_pci_table[] = {
+	{ PCI_VDEVICE(AMD, 0x1537), (kernel_ulong_t)&ccpv3 },
+	{ PCI_VDEVICE(AMD, 0x1456), (kernel_ulong_t)&ccpv5a },
+	{ PCI_VDEVICE(AMD, 0x1468), (kernel_ulong_t)&ccpv5b },
+	/* Last entry must be zero */
+	{ 0, }
+};
+MODULE_DEVICE_TABLE(pci, ccp_pci_table);
+
+static struct pci_driver ccp_pci_driver = {
+	.name = "ccp",
+	.id_table = ccp_pci_table,
+	.probe = ccp_pci_probe,
+	.remove = ccp_pci_remove,
+#ifdef CONFIG_PM
+	.suspend = ccp_pci_suspend,
+	.resume = ccp_pci_resume,
+#endif
+};
+
+int ccp_pci_init(void)
+{
+	return pci_register_driver(&ccp_pci_driver);
+}
+
+void ccp_pci_exit(void)
+{
+	pci_unregister_driver(&ccp_pci_driver);
+}
diff --git a/drivers/misc/amd-sp/ccp-platform.c b/drivers/misc/amd-sp/ccp-platform.c
new file mode 100644
index 0000000..351f28d8
--- /dev/null
+++ b/drivers/misc/amd-sp/ccp-platform.c
@@ -0,0 +1,293 @@
+/*
+ * AMD Cryptographic Coprocessor (CCP) driver
+ *
+ * Copyright (C) 2014,2016 Advanced Micro Devices, Inc.
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
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/ioport.h>
+#include <linux/dma-mapping.h>
+#include <linux/kthread.h>
+#include <linux/sched.h>
+#include <linux/interrupt.h>
+#include <linux/spinlock.h>
+#include <linux/delay.h>
+#include <linux/ccp.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/acpi.h>
+
+#include "ccp-dev.h"
+
+struct ccp_platform {
+	int coherent;
+};
+
+static const struct acpi_device_id ccp_acpi_match[];
+static const struct of_device_id ccp_of_match[];
+
+static struct ccp_vdata *ccp_get_of_version(struct platform_device *pdev)
+{
+#ifdef CONFIG_OF
+	const struct of_device_id *match;
+
+	match = of_match_node(ccp_of_match, pdev->dev.of_node);
+	if (match && match->data)
+		return (struct ccp_vdata *)match->data;
+#endif
+	return 0;
+}
+
+static struct ccp_vdata *ccp_get_acpi_version(struct platform_device *pdev)
+{
+#ifdef CONFIG_ACPI
+	const struct acpi_device_id *match;
+
+	match = acpi_match_device(ccp_acpi_match, &pdev->dev);
+	if (match && match->driver_data)
+		return (struct ccp_vdata *)match->driver_data;
+#endif
+	return 0;
+}
+
+static int ccp_get_irq(struct ccp_device *ccp)
+{
+	struct device *dev = ccp->dev;
+	struct platform_device *pdev = to_platform_device(dev);
+	int ret;
+
+	ret = platform_get_irq(pdev, 0);
+	if (ret < 0)
+		return ret;
+
+	ccp->irq = ret;
+	ret = request_irq(ccp->irq, ccp->vdata->perform->irqhandler, 0,
+			  ccp->name, dev);
+	if (ret) {
+		dev_notice(dev, "unable to allocate IRQ (%d)\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int ccp_get_irqs(struct ccp_device *ccp)
+{
+	struct device *dev = ccp->dev;
+	int ret;
+
+	ret = ccp_get_irq(ccp);
+	if (!ret)
+		return 0;
+
+	/* Couldn't get an interrupt */
+	dev_notice(dev, "could not enable interrupts (%d)\n", ret);
+
+	return ret;
+}
+
+static void ccp_free_irqs(struct ccp_device *ccp)
+{
+	struct device *dev = ccp->dev;
+
+	free_irq(ccp->irq, dev);
+}
+
+static struct resource *ccp_find_mmio_area(struct ccp_device *ccp)
+{
+	struct device *dev = ccp->dev;
+	struct platform_device *pdev = to_platform_device(dev);
+	struct resource *ior;
+
+	ior = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (ior && (resource_size(ior) >= 0x800))
+		return ior;
+
+	return NULL;
+}
+
+static int ccp_platform_probe(struct platform_device *pdev)
+{
+	struct ccp_device *ccp;
+	struct ccp_platform *ccp_platform;
+	struct device *dev = &pdev->dev;
+	enum dev_dma_attr attr;
+	struct resource *ior;
+	int ret;
+
+	ret = -ENOMEM;
+	ccp = ccp_alloc_struct(dev);
+	if (!ccp)
+		goto e_err;
+
+	ccp_platform = devm_kzalloc(dev, sizeof(*ccp_platform), GFP_KERNEL);
+	if (!ccp_platform)
+		goto e_err;
+
+	ccp->dev_specific = ccp_platform;
+	ccp->vdata = pdev->dev.of_node ? ccp_get_of_version(pdev)
+					 : ccp_get_acpi_version(pdev);
+	if (!ccp->vdata || !ccp->vdata->version) {
+		ret = -ENODEV;
+		dev_err(dev, "missing driver data\n");
+		goto e_err;
+	}
+	ccp->get_irq = ccp_get_irqs;
+	ccp->free_irq = ccp_free_irqs;
+
+	ior = ccp_find_mmio_area(ccp);
+	ccp->io_map = devm_ioremap_resource(dev, ior);
+	if (IS_ERR(ccp->io_map)) {
+		ret = PTR_ERR(ccp->io_map);
+		goto e_err;
+	}
+	ccp->io_regs = ccp->io_map;
+
+	attr = device_get_dma_attr(dev);
+	if (attr == DEV_DMA_NOT_SUPPORTED) {
+		dev_err(dev, "DMA is not supported");
+		goto e_err;
+	}
+
+	ccp_platform->coherent = (attr == DEV_DMA_COHERENT);
+	if (ccp_platform->coherent)
+		ccp->axcache = CACHE_WB_NO_ALLOC;
+	else
+		ccp->axcache = CACHE_NONE;
+
+	ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(48));
+	if (ret) {
+		dev_err(dev, "dma_set_mask_and_coherent failed (%d)\n", ret);
+		goto e_err;
+	}
+
+	dev_set_drvdata(dev, ccp);
+
+	ret = ccp->vdata->perform->init(ccp);
+	if (ret)
+		goto e_err;
+
+	dev_notice(dev, "enabled\n");
+
+	return 0;
+
+e_err:
+	dev_notice(dev, "initialization failed\n");
+	return ret;
+}
+
+static int ccp_platform_remove(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct ccp_device *ccp = dev_get_drvdata(dev);
+
+	ccp->vdata->perform->destroy(ccp);
+
+	dev_notice(dev, "disabled\n");
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int ccp_platform_suspend(struct platform_device *pdev,
+				pm_message_t state)
+{
+	struct device *dev = &pdev->dev;
+	struct ccp_device *ccp = dev_get_drvdata(dev);
+	unsigned long flags;
+	unsigned int i;
+
+	spin_lock_irqsave(&ccp->cmd_lock, flags);
+
+	ccp->suspending = 1;
+
+	/* Wake all the queue kthreads to prepare for suspend */
+	for (i = 0; i < ccp->cmd_q_count; i++)
+		wake_up_process(ccp->cmd_q[i].kthread);
+
+	spin_unlock_irqrestore(&ccp->cmd_lock, flags);
+
+	/* Wait for all queue kthreads to say they're done */
+	while (!ccp_queues_suspended(ccp))
+		wait_event_interruptible(ccp->suspend_queue,
+					 ccp_queues_suspended(ccp));
+
+	return 0;
+}
+
+static int ccp_platform_resume(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct ccp_device *ccp = dev_get_drvdata(dev);
+	unsigned long flags;
+	unsigned int i;
+
+	spin_lock_irqsave(&ccp->cmd_lock, flags);
+
+	ccp->suspending = 0;
+
+	/* Wake up all the kthreads */
+	for (i = 0; i < ccp->cmd_q_count; i++) {
+		ccp->cmd_q[i].suspended = 0;
+		wake_up_process(ccp->cmd_q[i].kthread);
+	}
+
+	spin_unlock_irqrestore(&ccp->cmd_lock, flags);
+
+	return 0;
+}
+#endif
+
+#ifdef CONFIG_ACPI
+static const struct acpi_device_id ccp_acpi_match[] = {
+	{ "AMDI0C00", (kernel_ulong_t)&ccpv3 },
+	{ },
+};
+MODULE_DEVICE_TABLE(acpi, ccp_acpi_match);
+#endif
+
+#ifdef CONFIG_OF
+static const struct of_device_id ccp_of_match[] = {
+	{ .compatible = "amd,ccp-seattle-v1a",
+	  .data = (const void *)&ccpv3 },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, ccp_of_match);
+#endif
+
+static struct platform_driver ccp_platform_driver = {
+	.driver = {
+		.name = "ccp",
+#ifdef CONFIG_ACPI
+		.acpi_match_table = ccp_acpi_match,
+#endif
+#ifdef CONFIG_OF
+		.of_match_table = ccp_of_match,
+#endif
+	},
+	.probe = ccp_platform_probe,
+	.remove = ccp_platform_remove,
+#ifdef CONFIG_PM
+	.suspend = ccp_platform_suspend,
+	.resume = ccp_platform_resume,
+#endif
+};
+
+int ccp_platform_init(void)
+{
+	return platform_driver_register(&ccp_platform_driver);
+}
+
+void ccp_platform_exit(void)
+{
+	platform_driver_unregister(&ccp_platform_driver);
+}
diff --git a/include/linux/ccp.h b/include/linux/ccp.h
index c71dd8f..9679257 100644
--- a/include/linux/ccp.h
+++ b/include/linux/ccp.h
@@ -24,8 +24,7 @@
 struct ccp_device;
 struct ccp_cmd;
 
-#if defined(CONFIG_CRYPTO_DEV_CCP_DD) || \
-	defined(CONFIG_CRYPTO_DEV_CCP_DD_MODULE)
+#if defined(CONFIG_AMD_CCP) || defined(CONFIG_AMD_CCP_MODULE)
 
 /**
  * ccp_present - check if a CCP device is present
