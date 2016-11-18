From: gcherianv@gmail.com
Subject: [PATCH 1/3] drivers: crypto: Add Support for Octeon-tx CPT Engine
Date: Fri, 18 Nov 2016 15:00:07 +0000
Message-ID: <1479481209-11475-2-git-send-email-gcherianv@gmail.com>
References: <1479481209-11475-1-git-send-email-gcherianv@gmail.com>
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        George Cherian <george.cherian@cavium.com>
To: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1479481209-11475-1-git-send-email-gcherianv@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: George Cherian <george.cherian@cavium.com>

Enable the Physical Function diver for the Cavium Crypto Engine (CPT)
found in Octeon-tx series of SoC's. CPT is the Cryptographic Acceleration
Unit. CPT includes microcoded GigaCypher symmetric engines (SEs) and
asymmetric engines (AEs).

Signed-off-by: George Cherian <george.cherian@cavium.com>
---
 drivers/crypto/cavium/cpt/Kconfig        |  22 +
 drivers/crypto/cavium/cpt/Makefile       |   2 +
 drivers/crypto/cavium/cpt/cpt.h          |  90 +++
 drivers/crypto/cavium/cpt/cpt_common.h   | 377 +++++++++++++
 drivers/crypto/cavium/cpt/cpt_hw_types.h | 940 +++++++++++++++++++++++++++++++
 drivers/crypto/cavium/cpt/cpt_main.c     | 891 +++++++++++++++++++++++++++++
 drivers/crypto/cavium/cpt/cpt_pf_mbox.c  | 174 ++++++
 7 files changed, 2496 insertions(+)
 create mode 100644 drivers/crypto/cavium/cpt/Kconfig
 create mode 100644 drivers/crypto/cavium/cpt/Makefile
 create mode 100644 drivers/crypto/cavium/cpt/cpt.h
 create mode 100644 drivers/crypto/cavium/cpt/cpt_common.h
 create mode 100644 drivers/crypto/cavium/cpt/cpt_hw_types.h
 create mode 100644 drivers/crypto/cavium/cpt/cpt_main.c
 create mode 100644 drivers/crypto/cavium/cpt/cpt_pf_mbox.c

diff --git a/drivers/crypto/cavium/cpt/Kconfig b/drivers/crypto/cavium/cpt/Kconfig
new file mode 100644
index 0000000..8fe3f44
--- /dev/null
+++ b/drivers/crypto/cavium/cpt/Kconfig
@@ -0,0 +1,22 @@
+#
+# Cavium crypto device configuration
+#
+
+config CRYPTO_DEV_CPT
+	tristate
+	select HW_RANDOM_OCTEON
+	select CRYPTO_AES
+	select CRYPTO_DES
+	select CRYPTO_BLKCIPHER
+	select FW_LOADER
+
+config OCTEONTX_CPT_PF
+	tristate "Octeon-tx CPT Physical function driver"
+	depends on ARCH_THUNDER
+	select CRYPTO_DEV_CPT
+	help
+	  Support for Cavium CPT block found in octeon-tx series of
+	  processors.
+
+	  To compile this as a module, choose M here: the module will be
+	  called cptpf.
diff --git a/drivers/crypto/cavium/cpt/Makefile b/drivers/crypto/cavium/cpt/Makefile
new file mode 100644
index 0000000..bf758e2
--- /dev/null
+++ b/drivers/crypto/cavium/cpt/Makefile
@@ -0,0 +1,2 @@
+obj-$(CONFIG_OCTEONTX_CPT_PF) += cptpf.o
+cptpf-objs := cpt_main.o cpt_pf_mbox.o
diff --git a/drivers/crypto/cavium/cpt/cpt.h b/drivers/crypto/cavium/cpt/cpt.h
new file mode 100644
index 0000000..63d12da
--- /dev/null
+++ b/drivers/crypto/cavium/cpt/cpt.h
@@ -0,0 +1,90 @@
+/*
+ * Copyright (C) 2016 Cavium, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License
+ * as published by the Free Software Foundation.
+ */
+
+#ifndef __CPT_H
+#define __CPT_H
+
+#include "cpt_common.h"
+
+#define BASE_PROC_DIR	"cavium"
+
+#define PF  0
+#define VF  1
+
+struct cpt_device;
+
+struct microcode {
+	uint8_t  is_mc_valid;
+	uint8_t  is_ae;
+	uint8_t  group;
+	uint32_t code_size;
+	void    *code;
+	uint8_t  num_cores;
+	uint64_t core_mask_low; /* Used as long as num # cores are <= 64 */
+	uint64_t core_mask_hi;  /* Unused for now */
+	uint8_t  version[32];
+
+	/* Base info */
+	dma_addr_t dma;
+	dma_addr_t phys_base;
+	void *base;
+};
+
+#define VF_STATE_DOWN	(0)
+#define VF_STATE_UP	(1)
+
+struct cpt_vf_info {
+	uint8_t state;
+	uint8_t priority;
+	uint32_t qlen;
+	union cpt_chipid_vfid id;
+};
+
+/**
+ * cpt device structure
+ */
+struct cpt_device {
+	uint32_t chip_id; /**< CPT Device ID */
+	uint16_t core_freq; /**< CPT Device Frequency */
+	uint16_t flags;	/**< Flags to hold device status bits */
+	uint8_t idx; /**< Device Index (0...MAX_CPT_DEVICES) */
+	uint8_t num_vf_en; /**< Number of VFs enabled (0...CPT_MAX_VF_NUM) */
+
+	struct cpt_vf_info vfinfo[CPT_MAX_VF_NUM]; /* Per VF info */
+	uint8_t next_mc_idx; /**< next microcode index */
+	uint8_t next_group;
+
+	uint8_t max_se_cores;
+	uint8_t max_ae_cores;
+	uint8_t avail_se_cores;
+	uint8_t avail_ae_cores;
+
+	void __iomem *reg_base; /* Register start address */
+
+	/* MSI-X */
+	bool msix_enabled;
+	uint8_t	num_vec;
+	struct msix_entry msix_entries[CPT_PF_MSIX_VECTORS];
+	bool irq_allocated[CPT_PF_MSIX_VECTORS];
+
+	bool mbx_lock[CPT_MAX_VF_NUM]; /* Mailbox locks per VF */
+
+	struct pci_dev *pdev; /**< pci device handle */
+	void *proc; /**< proc dir */
+	struct microcode mcode[CPT_MAX_CORE_GROUPS];
+};
+
+struct cpt_device_list {
+	/* device list lock */
+	spinlock_t lock;
+	uint32_t nr_device;
+	struct cpt_device *device_ptr[MAX_CPT_DEVICES];
+};
+
+void cpt_mbox_intr_handler(struct cpt_device *cpt, int mbx);
+#endif /* __CPT_H */
diff --git a/drivers/crypto/cavium/cpt/cpt_common.h b/drivers/crypto/cavium/cpt/cpt_common.h
new file mode 100644
index 0000000..351ed4a
--- /dev/null
+++ b/drivers/crypto/cavium/cpt/cpt_common.h
@@ -0,0 +1,377 @@
+/*
+ * Copyright (C) 2016 Cavium, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License
+ * as published by the Free Software Foundation.
+ */
+
+#ifndef __CPT_COMMON_H
+#define __CPT_COMMON_H
+
+#include <asm/byteorder.h>
+#include <linux/uaccess.h>
+#include <linux/types.h>
+#include <linux/spinlock.h>
+#include <linux/pci.h>
+#include <linux/cpumask.h>
+#include <linux/string.h>
+#include <linux/pci_regs.h>
+#include <linux/delay.h>
+#include <linux/printk.h>
+#include <linux/sched.h>
+#include <linux/completion.h>
+#include <asm/arch_timer.h>
+#include <linux/types.h>
+
+#include "cpt_hw_types.h"
+
+/* configuration space offsets */
+#ifndef PCI_VENDOR_ID
+#define PCI_VENDOR_ID 0x00 /* 16 bits */
+#endif
+#ifndef PCI_DEVICE_ID
+#define PCI_DEVICE_ID 0x02 /* 16 bits */
+#endif
+#ifndef PCI_REVISION_ID
+#define PCI_REVISION_ID 0x08 /* Revision ID */
+#endif
+#ifndef PCI_CAPABILITY_LIST
+#define PCI_CAPABILITY_LIST 0x34 /* first capability list entry */
+#endif
+
+/* Device ID */
+#define PCI_VENDOR_ID_CAVIUM 0x177d
+#define CPT_81XX_PCI_PF_DEVICE_ID 0xa040
+#define CPT_81XX_PCI_VF_DEVICE_ID 0xa041
+
+#define PASS_1_0 0x0
+
+/* CPT Models ((Device ID<<16)|Revision ID) */
+/* CPT models */
+#define CPT_81XX_PASS1_0 ((CPT_81XX_PCI_PF_DEVICE_ID << 8) | PASS_1_0)
+#define CPTVF_81XX_PASS1_0 ((CPT_81XX_PCI_VF_DEVICE_ID << 8) | PASS_1_0)
+
+#define PF 0
+#define VF 1
+
+#define DEFAULT_DEVICE_QUEUES CPT_NUM_QS_PER_VF
+
+#define SUCCESS	(0)
+#define FAIL	(1)
+
+#ifndef ROUNDUP4
+#define ROUNDUP4(val) (((val) + 3) & 0xfffffffc)
+#endif
+
+#ifndef ROUNDUP8
+#define ROUNDUP8(val) (((val) + 7) & 0xfffffff8)
+#endif
+
+#ifndef ROUNDUP16
+#define ROUNDUP16(val) (((val) + 15) & 0xfffffff0)
+#endif
+
+#define ERR_ADDR_LEN 8
+
+#define CPT_MBOX_MSG_TIMEOUT 2000
+#define VF_STATE_DOWN (0)
+#define VF_STATE_UP (1)
+
+/**< flags to indicate the features supported */
+#define CPT_FLAG_DMA_64BIT (uint16_t)(1 << 0)
+#define CPT_FLAG_MSIX_ENABLED (uint16_t)(1 << 1)
+#define CPT_FLAG_SRIOV_ENABLED (uint16_t)(1 << 2)
+#define CPT_FLAG_VF_DRIVER (uint16_t)(1 << 3)
+#define CPT_FLAG_DEVICE_READY (uint16_t)(1 << 4)
+
+#define cpt_msix_enabled(cpt) ((cpt)->flags & CPT_FLAG_MSIX_ENABLED)
+#define cpt_sriov_enabled(cpt) ((cpt)->flags & CPT_FLAG_SRIOV_ENABLED)
+#define cpt_vf_driver(cpt) ((cpt)->flags & CPT_FLAG_VF_DRIVER)
+#define cpt_pf_driver(cpt) (!((cpt)->flags & CPT_FLAG_VF_DRIVER))
+#define cpt_device_ready(cpt) ((cpt)->flags & CPT_FLAG_DEVICE_READY)
+
+#define MAX_CPT_DEVICES	2
+
+/* Default command queue length */
+#define DEFAULT_CMD_QLEN 2046
+#define DEFAULT_CMD_QCHUNK_SIZE 1023
+
+/* Max command queue length allowed. This is to restrict host memory usage */
+#define MAX_CMD_QLEN 16000
+
+/* Completion Interrupt threshold */
+#define COMPLETION_INTR_THOLD 1
+
+/* Default command timeout in seconds */
+#define DEFAULT_COMMAND_TIMEOUT 4
+
+/* Default Mailbox ACK timeout */
+#define DEFAULT_MBOX_ACK_TIMEOUT 4
+
+#define CPT_MBOX_MSG_TYPE_REQ 0
+#define CPT_MBOX_MSG_TYPE_ACK 1
+#define CPT_MBOX_MSG_TYPE_NACK 2
+#define CPT_MBOX_MSG_TYPE_NOP 3
+
+#define CPT_COUNT_THOLD 1
+#define CPT_TIMER_THOLD	0xFFFF
+#define CPT_DBELL_THOLD	1
+
+/*
+ * CPT Registers map for 81xx
+ */
+
+/* PF registers */
+#define CPTX_PF_CONSTANTS(a) (0x0ll + 0x1000000000ll * ((a) & 0x1))
+#define CPTX_PF_RESET(a) (0x100ll + 0x1000000000ll * ((a) & 0x1))
+#define CPTX_PF_DIAG(a) (0x120ll + 0x1000000000ll * ((a) & 0x1))
+#define CPTX_PF_BIST_STATUS(a) (0x160ll + 0x1000000000ll * ((a) & 0x1))
+#define CPTX_PF_ECC0_CTL(a) (0x200ll + 0x1000000000ll * ((a) & 0x1))
+#define CPTX_PF_ECC0_FLIP(a) (0x210ll + 0x1000000000ll * ((a) & 0x1))
+#define CPTX_PF_ECC0_INT(a) (0x220ll + 0x1000000000ll * ((a) & 0x1))
+#define CPTX_PF_ECC0_INT_W1S(a) (0x230ll + 0x1000000000ll * ((a) & 0x1))
+#define CPTX_PF_ECC0_ENA_W1S(a)	(0x240ll + 0x1000000000ll * ((a) & 0x1))
+#define CPTX_PF_ECC0_ENA_W1C(a)	(0x250ll + 0x1000000000ll * ((a) & 0x1))
+#define CPTX_PF_MBOX_INTX(a, b)	\
+	(0x400ll + 0x1000000000ll * ((a) & 0x1) + 8ll * ((b) & 0x0))
+#define CPTX_PF_MBOX_INT_W1SX(a, b) \
+	(0x420ll + 0x1000000000ll * ((a) & 0x1) + 8ll * ((b) & 0x0))
+#define CPTX_PF_MBOX_ENA_W1CX(a, b) \
+	(0x440ll + 0x1000000000ll * ((a) & 0x1) + 8ll * ((b) & 0x0))
+#define CPTX_PF_MBOX_ENA_W1SX(a, b) \
+	(0x460ll + 0x1000000000ll * ((a) & 0x1) + 8ll * ((b) & 0x0))
+#define CPTX_PF_EXEC_INT(a) (0x500ll + 0x1000000000ll * ((a) & 0x1))
+#define CPTX_PF_EXEC_INT_W1S(a)	(0x520ll + 0x1000000000ll * ((a) & 0x1))
+#define CPTX_PF_EXEC_ENA_W1C(a)	(0x540ll + 0x1000000000ll * ((a) & 0x1))
+#define CPTX_PF_EXEC_ENA_W1S(a)	(0x560ll + 0x1000000000ll * ((a) & 0x1))
+#define CPTX_PF_GX_EN(a, b) \
+	(0x600ll + 0x1000000000ll * ((a) & 0x1) + 8ll * ((b) & 0x7))
+#define CPTX_PF_EXEC_INFO(a) (0x700ll + 0x1000000000ll * ((a) & 0x1))
+#define CPTX_PF_EXEC_BUSY(a) (0x800ll + 0x1000000000ll * ((a) & 0x1))
+#define CPTX_PF_EXEC_INFO0(a) (0x900ll + 0x1000000000ll * ((a) & 0x1))
+#define CPTX_PF_EXEC_INFO1(a) (0x910ll + 0x1000000000ll * ((a) & 0x1))
+#define CPTX_PF_INST_REQ_PC(a) (0x10000ll + 0x1000000000ll * ((a) & 0x1))
+#define CPTX_PF_INST_LATENCY_PC(a) \
+	(0x10020ll + 0x1000000000ll * ((a) & 0x1))
+#define CPTX_PF_RD_REQ_PC(a) (0x10040ll + 0x1000000000ll * ((a) & 0x1))
+#define CPTX_PF_RD_LATENCY_PC(a) (0x10060ll + 0x1000000000ll * ((a) & 0x1))
+#define CPTX_PF_RD_UC_PC(a) (0x10080ll + 0x1000000000ll * ((a) & 0x1))
+#define CPTX_PF_ACTIVE_CYCLES_PC(a) \
+	(0x10100ll + 0x1000000000ll * ((a) & 0x1))
+#define CPTX_PF_EXE_CTL(a) (0x4000000ll + 0x1000000000ll * ((a) & 0x1))
+#define CPTX_PF_EXE_STATUS(a) (0x4000008ll + 0x1000000000ll * ((a) & 0x1))
+#define CPTX_PF_EXE_CLK(a) (0x4000010ll + 0x1000000000ll * ((a) & 0x1))
+#define CPTX_PF_EXE_DBG_CTL(a) (0x4000018ll + 0x1000000000ll * ((a) & 0x1))
+#define CPTX_PF_EXE_DBG_DATA(a)	(0x4000020ll + 0x1000000000ll * ((a) & 0x1))
+#define CPTX_PF_EXE_BIST_STATUS(a) \
+	(0x4000028ll + 0x1000000000ll * ((a) & 0x1))
+#define CPTX_PF_EXE_REQ_TIMER(a) (0x4000030ll + 0x1000000000ll * ((a) & 0x1))
+#define CPTX_PF_EXE_MEM_CTL(a) (0x4000038ll + 0x1000000000ll * ((a) & 0x1))
+#define CPTX_PF_EXE_PERF_CTL(a)	(0x4001000ll + 0x1000000000ll * ((a) & 0x1))
+#define CPTX_PF_EXE_DBG_CNTX(a, b) \
+	(0x4001100ll + 0x1000000000ll * ((a) & 0x1) + 8ll * ((b) & 0xf))
+#define CPTX_PF_EXE_PERF_EVENT_CNT(a) \
+	(0x4001180ll + 0x1000000000ll * ((a) & 0x1))
+#define CPTX_PF_EXE_EPCI_INBX_CNT(a, b) \
+	(0x4001200ll + 0x1000000000ll * ((a) & 0x1) + 8ll * ((b) & 0x0))
+#define CPTX_PF_EXE_EPCI_OUTBX_CNT(a, b) \
+	(0x4001240ll + 0x1000000000ll * ((a) & 0x1) + 8ll * ((b) & 0x0))
+#define CPTX_PF_ENGX_UCODE_BASE(a, b) \
+	(0x4002000ll + 0x1000000000ll * ((a) & 0x1) + 8ll * ((b) & 0x3f))
+#define CPTX_PF_QX_CTL(a, b) \
+	(0x8000000ll + 0x1000000000ll * ((a) & 0x1) + 0x100000ll * ((b) & 0xf))
+#define CPTX_PF_QX_GMCTL(a, b) \
+	(0x8000020ll + 0x1000000000ll * ((a) & 0x1) + 0x100000ll * ((b) & 0xf))
+#define CPTX_PF_QX_CTL2(a, b) \
+	(0x8000100ll + 0x1000000000ll * ((a) & 0x1) + 0x100000ll * ((b) & 0xf))
+#define CPTX_PF_VFX_MBOXX(a, b, c) \
+	(0x8001000ll + 0x1000000000ll * ((a) & 0x1) + 0x100000ll * ((b) & 0xf) + 0x100ll * ((c) & 0x1))
+#define CPTX_PF_MSIX_VECX_ADDR(a, b) \
+	(0x0ll + 0x1000000000ll * ((a) & 0x1) + 0x10ll * ((b) & 0x3))
+#define CPTX_PF_MSIX_VECX_CTL(a, b) \
+	(0x8ll + 0x1000000000ll * ((a) & 0x1) + 0x10ll * ((b) & 0x3))
+#define CPTX_PF_MSIX_PBAX(a, b)	\
+	(0xf0000ll + 0x1000000000ll * ((a) & 0x1) + 8ll * ((b) & 0x0))
+
+/* VF registers */
+#define CPTX_VQX_CTL(a, b) \
+	(0x100ll + 0x1000000000ll * ((a) & 0x0) + 0x100000ll * ((b) & 0xf))
+#define CPTX_VQX_SADDR(a, b) \
+	(0x200ll + 0x1000000000ll * ((a) & 0x0) + 0x100000ll * ((b) & 0xf))
+#define CPTX_VQX_DONE_WAIT(a, b) \
+	(0x400ll + 0x1000000000ll * ((a) & 0x0) + 0x100000ll * ((b) & 0xf))
+#define CPTX_VQX_INPROG(a, b) \
+	(0x410ll + 0x1000000000ll * ((a) & 0x0) + 0x100000ll * ((b) & 0xf))
+#define CPTX_VQX_DONE(a, b) \
+	(0x420ll + 0x1000000000ll * ((a) & 0x1) + 0x100000ll * ((b) & 0xf))
+#define CPTX_VQX_DONE_ACK(a, b) \
+	(0x440ll + 0x1000000000ll * ((a) & 0x1) + 0x100000ll * ((b) & 0xf))
+#define CPTX_VQX_DONE_INT_W1S(a, b) \
+	(0x460ll + 0x1000000000ll * ((a) & 0x1) + 0x100000ll * ((b) & 0xf))
+#define CPTX_VQX_DONE_INT_W1C(a, b) \
+	(0x468ll + 0x1000000000ll * ((a) & 0x1) + 0x100000ll * ((b) & 0xf))
+#define CPTX_VQX_DONE_ENA_W1S(a, b) \
+	(0x470ll + 0x1000000000ll * ((a) & 0x1) + 0x100000ll * ((b) & 0xf))
+#define CPTX_VQX_DONE_ENA_W1C(a, b) \
+	(0x478ll + 0x1000000000ll * ((a) & 0x1) + 0x100000ll * ((b) & 0xf))
+#define CPTX_VQX_MISC_INT(a, b)	\
+	(0x500ll + 0x1000000000ll * ((a) & 0x1) + 0x100000ll * ((b) & 0xf))
+#define CPTX_VQX_MISC_INT_W1S(a, b) \
+	(0x508ll + 0x1000000000ll * ((a) & 0x1) + 0x100000ll * ((b) & 0xf))
+#define CPTX_VQX_MISC_ENA_W1S(a, b) \
+	(0x510ll + 0x1000000000ll * ((a) & 0x1) + 0x100000ll * ((b) & 0xf))
+#define CPTX_VQX_MISC_ENA_W1C(a, b) \
+	(0x518ll + 0x1000000000ll * ((a) & 0x1) + 0x100000ll * ((b) & 0xf))
+#define CPTX_VQX_DOORBELL(a, b)	\
+	(0x600ll + 0x1000000000ll * ((a) & 0x1) + 0x100000ll * ((b) & 0xf))
+#define CPTX_VFX_PF_MBOXX(a, b, c) \
+	(0x1000ll + 0x1000000000ll * ((a) & 0x1) + 0x100000ll * ((b) & 0xf) + 8ll * ((c) & 0x1))
+#define CPTX_VFX_MSIX_VECX_ADDR(a, b, c) \
+	(0x0ll + 0x1000000000ll * ((a) & 0x1) + 0x100000ll * ((b) & 0xf) + 0x10ll * ((c) & 0x1))
+#define CPTX_VFX_MSIX_VECX_CTL(a, b, c) \
+	(0x8ll + 0x1000000000ll * ((a) & 0x1) + 0x100000ll * ((b) & 0xf) + 0x10ll * ((c) & 0x1))
+#define CPTX_VFX_MSIX_PBAX(a, b, c) \
+	(0xf0000ll + 0x1000000000ll * ((a) & 0x1) + 0x100000ll * ((b) & 0xf) + 8ll * ((c) & 0x0))
+
+/* Future extensions */
+#define CPTX_BRIDGE_BP_TEST(a) (0x1c0ll + 0x1000000000ll * ((a) & 0x1))
+#define CPTX_CQM_CORE_OBS0(a) (0x1a0ll + 0x1000000000ll * ((a) & 0x1))
+#define CPTX_CQM_CORE_OBS1(a) (0x1a8ll + 0x1000000000ll * ((a) & 0x1))
+#define CPTX_NCBI_OBS(a) (0x190ll + 0x1000000000ll * ((a) & 0x1))
+#define CPTX_PF_BP_TEST(a) (0x180ll + 0x1000000000ll * ((a) & 0x1))
+#define CPTX_PF_ECO(a) (0x140ll + 0x1000000000ll * ((a) & 0x1))
+
+/*###### PCIE EP-Mode Configuration Registers #########*/
+#define PCIEEP0_CFG000 (0x0)
+#define PCIEEP0_CFG002 (0x8)
+#define PCIEEP0_CFG011 (0x2C)
+#define PCIEEP0_CFG020 (0x50)
+#define PCIEEP0_CFG025 (0x64)
+#define PCIEEP0_CFG030 (0x78)
+#define PCIEEP0_CFG044 (0xB0)
+#define PCIEEP0_CFG045 (0xB4)
+#define PCIEEP0_CFG082 (0x148)
+#define PCIEEP0_CFG095 (0x17C)
+#define PCIEEP0_CFG096 (0x180)
+#define PCIEEP0_CFG097 (0x184)
+#define PCIEEP0_CFG103 (0x19C)
+#define PCIEEP0_CFG460 (0x730)
+#define PCIEEP0_CFG461 (0x734)
+#define PCIEEP0_CFG462 (0x738)
+
+/*#######  PCIe EP-Mode SR-IOV Configuration Registers  #####*/
+#define PCIEEPVF0_CFG000 (0x0)
+#define PCIEEPVF0_CFG002 (0x8)
+#define PCIEEPVF0_CFG011 (0x2C)
+#define PCIEEPVF0_CFG030 (0x78)
+#define PCIEEPVF0_CFG044 (0xB0)
+
+enum vftype {
+	AE_TYPES = 1,
+	SE_TYPES = 2,
+	BAD_CPT_TYPES,
+};
+
+static inline int32_t count_set_bits(uint64_t mask)
+{
+	int32_t count = 0;
+
+	while (mask) {
+		if (mask & 1ULL)
+			count++;
+		mask = mask >> 1;
+	}
+
+	return count;
+}
+
+static const uint8_t cpt_device_name[] = "CPT81XX";
+static const uint8_t cptvf_device_name[] = "CPT81XX-VF";
+static const uint8_t cpt_device_file[] = "cpt";
+static const uint8_t cptvf_device_file[] = "cptvf";
+
+static const uint8_t cpt_driver_name[] = "CPT Driver";
+static const uint8_t cpt_driver_class[] = "crypto";
+static const uint8_t cptvf_driver_class[] = "cryptovf";
+
+/* Max CPT devices supported */
+enum cpt_mbox_opcode {
+	CPT_MSG_VF_CFG = 1,
+	CPT_MSG_VF_UP,
+	CPT_MSG_VF_DOWN,
+	CPT_MSG_CHIPID_VFID,
+	CPT_MSG_READY,
+	CPT_MSG_QLEN,
+	CPT_MSG_QBIND_GRP,
+	CPT_MSG_VQ_PRIORITY,
+	CPT_MSG_VF_QUERY_HEALTH,
+};
+
+union cpt_chipid_vfid {
+	uint16_t u16;
+	struct {
+#if defined(__BIG_ENDIAN_BITFIELD)
+		uint16_t chip_id:8;
+		uint16_t vfid:8;
+#else
+		uint16_t vfid:8;
+		uint16_t chip_id:8;
+#endif
+	} s;
+};
+
+/* CPT mailbox structure */
+struct cpt_mbox {
+	uint64_t msg; /* Message type MBOX[0] */
+	uint64_t data;/* Data         MBOX[1] */
+};
+
+/* The Cryptographic Acceleration Unit can *only* be found in SoCs
+ * containing the ThunderX ARM64 CPU implementation.  All accesses to the device
+ * registers on this platform are implicitly strongly ordered with respect
+ * to memory accesses. So writeq_relaxed() and readq_relaxed() are safe to use
+ * with no memory barriers in this driver.  The readq()/writeq() functions add
+ * explicit ordering operation which in this case are redundant, and only
+ * add overhead.
+ */
+/* Register read/write APIs */
+static inline void cpt_write_csr64(uint8_t __iomem *hw_addr, uint64_t offset,
+				   uint64_t val)
+{
+	uint8_t __iomem *base = ACCESS_ONCE(hw_addr);
+
+	writeq_relaxed(val, base + offset);
+}
+
+static inline uint64_t cpt_read_csr64(uint8_t __iomem *hw_addr, uint64_t offset)
+{
+	uint8_t __iomem *base = ACCESS_ONCE(hw_addr);
+
+	return readq_relaxed(base + offset);
+}
+
+static inline void byte_swap_64(uint64_t *data)
+{
+	uint64_t val = 0ULL;
+	uint8_t *a, *b;
+
+	a = (uint8_t *)data;
+	b = (uint8_t *)&val;
+	b[0] = a[7];
+	b[1] = a[6];
+	b[2] = a[5];
+	b[3] = a[4];
+	b[4] = a[3];
+	b[5] = a[2];
+	b[6] = a[1];
+	b[7] = a[0];
+	*data = val;
+}
+
+static inline void byte_swap_16(uint16_t *data)
+{
+	uint16_t val = *data;
+	*data = (val >> 8) | (val << 8);
+}
+#endif /* __CPT_COMMON_H */
diff --git a/drivers/crypto/cavium/cpt/cpt_hw_types.h b/drivers/crypto/cavium/cpt/cpt_hw_types.h
new file mode 100644
index 0000000..a6def18
--- /dev/null
+++ b/drivers/crypto/cavium/cpt/cpt_hw_types.h
@@ -0,0 +1,940 @@
+/*
+ * Copyright (C) 2016 Cavium, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License
+ * as published by the Free Software Foundation.
+ */
+
+#ifndef __CPT_HW_TYPES_H
+#define __CPT_HW_TYPES_H
+
+#include "cpt_common.h"
+
+#define NR_CLUSTER (4)
+#define CSR_DELAY (30)
+
+#define CPT_NUM_QS_PER_VF (1)
+#define CPT_INST_SIZE (64)
+#define CPT_VQ_CHUNK_ALIGN (128) /**< 128 byte align */
+#define CPT_NEXT_CHUNK_PTR_SIZE (8)
+#define CPT_INST_CHUNK_MAX_SIZE (1023)
+
+#define CPT_MAX_CORE_GROUPS (8)
+#define CPT_MAX_SE_CORES (10)
+#define CPT_MAX_AE_CORES (6)
+#define CPT_MAX_TOTAL_CORES (CPT_MAX_SE_CORES + CPT_MAX_AE_CORES)
+#define CPT_MAX_VF_NUM (16)
+#define CPT_MAX_VQ_NUM (16)
+#define CPT_PF_VF_MAILBOX_SIZE (2)
+
+/* MSI-X interrupts */
+#define	CPT_PF_MSIX_VECTORS (3)
+#define	CPT_VF_MSIX_VECTORS (2)
+
+/* Configuration and Status registers are in BAR 0 */
+#define CPT_CSR_BAR 0
+#define CPT_MSIX_BAR 4
+
+/**
+ * Enumeration cpt_bar_e
+ *
+ * CPT Base Address Register Enumeration
+ * Enumerates the base address registers.
+ */
+#define CPT_BAR_E_CPTX_PF_BAR0(a) (0x872000000000ll + 0x1000000000ll * (a))
+#define CPT_BAR_E_CPTX_PF_BAR4(a) (0x872010000000ll + 0x1000000000ll * (a))
+#define CPT_BAR_E_CPTX_VFX_BAR0(a, b) \
+	(0x872020000000ll + 0x1000000000ll * (a) + 0x100000ll * (b))
+#define CPT_BAR_E_CPTX_VFX_BAR4(a, b) \
+	(0x872030000000ll + 0x1000000000ll * (a) + 0x100000ll * (b))
+
+/**
+ * Enumeration cpt_comp_e
+ *
+ * CPT Completion Enumeration
+ * Enumerates the values of CPT_RES_S[COMPCODE].
+ */
+enum cpt_comp_e {
+	CPT_COMP_E_NOTDONE = 0x00,
+	CPT_COMP_E_GOOD = 0x01,
+	CPT_COMP_E_FAULT = 0x02,
+	CPT_COMP_E_SWERR = 0x03,
+	CPT_COMP_E_LAST_ENTRY = 0xFF
+};
+
+/**
+ * Enumeration cpt_engine_err_type_e
+ *
+ * CPT Engine Error Code Enumeration
+ * Enumerates the values of CPT_RES_S[COMPCODE].
+ */
+enum cpt_engine_err_type_e {
+	CPT_ENGINE_ERR_TYPE_E_NOERR = 0x00,
+	CPT_ENGINE_ERR_TYPE_E_RF = 0x01,
+	CPT_ENGINE_ERR_TYPE_E_UC = 0x02,
+	CPT_ENGINE_ERR_TYPE_E_WD = 0x04,
+	CPT_ENGINE_ERR_TYPE_E_GE = 0x08,
+	CPT_ENGINE_ERR_TYPE_E_BUS = 0x20,
+	CPT_ENGINE_ERR_TYPE_E_LAST = 0xFF
+};
+
+/**
+ * Enumeration cpt_eop_e
+ *
+ * CPT EOP (EPCI Opcodes) Enumeration
+ * Opcodes on the epci bus.
+ */
+enum cpt_eop_e {
+	CPT_EOP_E_DMA_RD_LDT = 0x01,
+	CPT_EOP_E_DMA_RD_LDI = 0x02,
+	CPT_EOP_E_DMA_RD_LDY = 0x06,
+	CPT_EOP_E_DMA_RD_LDD = 0x08,
+	CPT_EOP_E_DMA_RD_LDE = 0x0b,
+	CPT_EOP_E_DMA_RD_LDWB = 0x0d,
+	CPT_EOP_E_DMA_WR_STY = 0x0e,
+	CPT_EOP_E_DMA_WR_STT = 0x11,
+	CPT_EOP_E_DMA_WR_STP = 0x12,
+	CPT_EOP_E_ATM_FAA64 = 0x3b,
+	CPT_EOP_E_RANDOM1_REQ = 0x61,
+	CPT_EOP_E_RANDOM_REQ = 0x60,
+	CPT_EOP_E_ERR_REQUEST = 0xfb,
+	CPT_EOP_E_UCODE_REQ = 0xfc,
+	CPT_EOP_E_MEMB = 0xfd,
+	CPT_EOP_E_NEW_WORK_REQ = 0xff,
+};
+
+/**
+ * Enumeration cpt_pf_int_vec_e
+ *
+ * CPT PF MSI-X Vector Enumeration
+ * Enumerates the MSI-X interrupt vectors.
+ */
+enum cpt_pf_int_vec_e {
+	CPT_PF_INT_VEC_E_ECC0 = 0x00,
+	CPT_PF_INT_VEC_E_EXEC = 0x01
+};
+
+#define CPT_PF_INT_VEC_E_MBOXX(a) (0x02 + (a))
+
+/**
+ * Enumeration cpt_rams_e
+ *
+ * CPT RAM Field Enumeration
+ * Enumerates the relative bit positions within CPT()_PF_ECC0_CTL[CDIS].
+ */
+enum cpt_rams_e {
+	CPT_RAMS_E_NCBI_DATFIF = 0x00,
+	CPT_RAMS_E_NCBO_MEM0 = 0x01,
+	CPT_RAMS_E_CQM_CTLMEM = 0x02,
+	CPT_RAMS_E_CQM_BPTR = 0x03,
+	CPT_RAMS_E_CQM_GMID = 0x04,
+	CPT_RAMS_E_CQM_INSTFIF0 = 0x05,
+	CPT_RAMS_E_CQM_INSTFIF1 = 0x06,
+	CPT_RAMS_E_CQM_INSTFIF2 = 0x07,
+	CPT_RAMS_E_CQM_INSTFIF3 = 0x08,
+	CPT_RAMS_E_CQM_INSTFIF4 = 0x09,
+	CPT_RAMS_E_CQM_INSTFIF5 = 0x0a,
+	CPT_RAMS_E_CQM_INSTFIF6 = 0x0b,
+	CPT_RAMS_E_CQM_INSTFIF7 = 0x0c,
+	CPT_RAMS_E_CQM_DONE_CNT = 0x0d,
+	CPT_RAMS_E_CQM_DONE_TIMER = 0x0e,
+	CPT_RAMS_E_COMP_FIFO = 0x0f,
+	CPT_RAMS_E_MBOX_MEM = 0x10,
+	CPT_RAMS_E_FPA_MEM = 0x11,
+	CPT_RAMS_E_CDEI_UCODE = 0x12,
+	CPT_RAMS_E_COMP_ARRAY0 = 0x13,
+	CPT_RAMS_E_COMP_ARRAY1 = 0x14,
+	CPT_RAMS_E_CSR_VMEM = 0x15,
+	CPT_RAMS_E_RSP_MAP = 0x16,
+	CPT_RAMS_E_RSP_INST = 0x17,
+	CPT_RAMS_E_RSP_NCBO = 0x18,
+	CPT_RAMS_E_RSP_RNM = 0x19,
+	CPT_RAMS_E_CDEI_FIFO0 = 0x1a,
+	CPT_RAMS_E_CDEI_FIFO1 = 0x1b,
+	CPT_RAMS_E_EPCO_FIFO0 = 0x1c,
+	CPT_RAMS_E_EPCO_FIFO1 = 0x1d,
+	CPT_RAMS_E_LAST_ENTRY = 0xff
+};
+
+/**
+ * Enumeration cpt_vf_int_vec_e
+ *
+ * CPT VF MSI-X Vector Enumeration
+ * Enumerates the MSI-X interrupt vectors.
+ */
+enum cpt_vf_int_vec_e {
+	CPT_VF_INT_VEC_E_MISC = 0x00,
+	CPT_VF_INT_VEC_E_DONE = 0x01
+};
+
+#define CPT_VF_INTR_MBOX_MASK BIT(0)
+#define CPT_VF_INTR_DOVF_MASK BIT(1)
+#define CPT_VF_INTR_IRDE_MASK BIT(2)
+#define CPT_VF_INTR_NWRP_MASK BIT(3)
+#define CPT_VF_INTR_SERR_MASK BIT(4)
+
+/**
+ * Structure cpt_inst_s
+ *
+ * CPT Instruction Structure
+ * This structure specifies the instruction layout. Instructions are
+ * stored in memory as little-endian unless CPT()_PF_Q()_CTL[INST_BE] is set.
+ * cpt_inst_s_s
+ * Word 0
+ * doneint:1 Done interrupt.
+ *	0 = No interrupts related to this instruction.
+ *	1 = When the instruction completes, CPT()_VQ()_DONE[DONE] will be
+ *	incremented,and based on the rules described there an interrupt may
+ *	occur.
+ * Word 1
+ * res_addr:64 [127: 64] Result IOVA.
+ *	If nonzero, specifies where to write CPT_RES_S.
+ *	If zero, no result structure will be written.
+ *	Address must be 16-byte aligned.
+ *	Bits <63:49> are ignored by hardware; software should use a
+ *	sign-extended bit <48> for forward compatibility.
+ * Word 2
+ *  grp:10 [171:162] If [WQ_PTR] is nonzero, the SSO guest-group to use when
+ *	CPT submits work SSO.
+ *	For the SSO to not discard the add-work request, FPA_PF_MAP() must map
+ *	[GRP] and CPT()_PF_Q()_GMCTL[GMID] as valid.
+ *  tt:2 [161:160] If [WQ_PTR] is nonzero, the SSO tag type to use when CPT
+ *	submits work to SSO
+ *  tag:32 [159:128] If [WQ_PTR] is nonzero, the SSO tag to use when CPT
+ *	submits work to SSO.
+ * Word 3
+ *  wq_ptr:64 [255:192] If [WQ_PTR] is nonzero, it is a pointer to a
+ *	work-queue entry that CPT submits work to SSO after all context,
+ *	output data, and result write operations are visible to other
+ *	CNXXXX units and the cores. Bits <2:0> must be zero.
+ *	Bits <63:49> are ignored by hardware; software should
+ *	use a sign-extended bit <48> for forward compatibility.
+ *	Internal:
+ *	Bits <63:49>, <2:0> are ignored by hardware, treated as always 0x0.
+ * Word 4
+ *  ei0:64; [319:256] Engine instruction word 0. Passed to the AE/SE.
+ * Word 5
+ *  ei1:64; [383:320] Engine instruction word 1. Passed to the AE/SE.
+ * Word 6
+ *  ei2:64; [447:384] Engine instruction word 1. Passed to the AE/SE.
+ * Word 7
+ *  ei3:64; [511:448] Engine instruction word 1. Passed to the AE/SE.
+ *
+ */
+union cpt_inst_s {
+	uint64_t u[8];
+	struct cpt_inst_s_s {
+#if defined(__BIG_ENDIAN_BITFIELD) /* Word 0 - Big Endian */
+		uint64_t reserved_17_63:47;
+		uint64_t doneint:1;
+		uint64_t reserved_0_1:16;
+#else /* Word 0 - Little Endian */
+		uint64_t reserved_0_15:16;
+		uint64_t doneint:1;
+		uint64_t reserved_17_63:47;
+#endif /* Word 0 - End */
+#if defined(__BIG_ENDIAN_BITFIELD) /* Word 1 - Big Endian */
+		uint64_t res_addr:64;
+#else /* Word 1 - Little Endian */
+		uint64_t res_addr:64;
+#endif /* Word 1 - End */
+#if defined(__BIG_ENDIAN_BITFIELD) /* Word 2 - Big Endian */
+		uint64_t reserved_172_19:20;
+		uint64_t grp:10;
+		uint64_t tt:2;
+		uint64_t tag:32;
+#else /* Word 2 - Little Endian */
+		uint64_t tag:32;
+		uint64_t tt:2;
+		uint64_t grp:10;
+		uint64_t reserved_172_191:20;
+#endif /* Word 2 - End */
+#if defined(__BIG_ENDIAN_BITFIELD) /* Word 3 - Big Endian */
+		uint64_t wq_ptr:64;
+#else /* Word 3 - Little Endian */
+		uint64_t wq_ptr:64;
+#endif /* Word 3 - End */
+#if defined(__BIG_ENDIAN_BITFIELD) /* Word 4 - Big Endian */
+		uint64_t ei0:64;
+#else /* Word 4 - Little Endian */
+		uint64_t ei0:64;
+#endif /* Word 4 - End */
+#if defined(__BIG_ENDIAN_BITFIELD) /* Word 5 - Big Endian */
+		uint64_t ei1:64;
+#else /* Word 5 - Little Endian */
+		uint64_t ei1:64;
+#endif /* Word 5 - End */
+#if defined(__BIG_ENDIAN_BITFIELD) /* Word 6 - Big Endian */
+		uint64_t ei2:64;
+#else /* Word 6 - Little Endian */
+		uint64_t ei2:64;
+#endif /* Word 6 - End */
+#if defined(__BIG_ENDIAN_BITFIELD) /* Word 7 - Big Endian */
+		uint64_t ei3:64;
+#else /* Word 7 - Little Endian */
+		uint64_t ei3:64;
+#endif /* Word 7 - End */
+	} s;
+};
+
+/**
+ * Structure cpt_res_s
+ *
+ * CPT Result Structure
+ * The CPT coprocessor writes the result structure after it completes a
+ * CPT_INST_S instruction. The result structure is exactly 16 bytes, and
+ * each instruction completion produces exactly one result structure.
+ *
+ * This structure is stored in memory as little-endian unless
+ * CPT()_PF_Q()_CTL[INST_BE] is set.
+ * cpt_res_s_s
+ * Word 0
+ *  doneint:1 [16:16] Done interrupt. This bit is copied from the
+ *	corresponding instruction's CPT_INST_S[DONEINT].
+ *  compcode:8 [7:0] Indicates completion/error status of the CPT coprocessor
+ *	for the	associated instruction, as enumerated by CPT_COMP_E.
+ *	Core software may write the memory location containing [COMPCODE] to
+ *	0x0 before ringing the doorbell, and then poll for completion by
+ *	checking for a nonzero value.
+ *	Once the core observes a nonzero [COMPCODE] value in this case,the CPT
+ *	coprocessor will have also completed L2/DRAM write operations.
+ * Word 1
+ *  reserved
+ *
+ */
+union cpt_res_s {
+	uint64_t u[2];
+	struct cpt_res_s_s {
+#if defined(__BIG_ENDIAN_BITFIELD) /* Word 0 - Big Endian */
+		uint64_t reserved_17_63:47;
+		uint64_t doneint:1;
+		uint64_t reserved_8_15:8;
+		uint64_t compcode:8;
+#else /* Word 0 - Little Endian */
+		uint64_t compcode:8;
+		uint64_t reserved_8_15:8;
+		uint64_t doneint:1;
+		uint64_t reserved_17_63:47;
+#endif /* Word 0 - End */
+#if defined(__BIG_ENDIAN_BITFIELD) /* Word 1 - Big Endian */
+		uint64_t reserved_64_127:64;
+#else /* Word 1 - Little Endian */
+		uint64_t reserved_64_127:64;
+#endif /* Word 1 - End */
+	} s;
+};
+
+/**
+ * Register (NCB) cpt#_pf_bist_status
+ *
+ * CPT PF Control Bist Status Register
+ * This register has the BIST status of memories. Each bit is the BIST result
+ * of an individual memory (per bit, 0 = pass and 1 = fail).
+ * cptx_pf_bist_status_s
+ * Word0
+ *  bstatus [29:0](RO/H) BIST status. One bit per memory, enumerated by
+ *	CPT_RAMS_E.
+ */
+union cptx_pf_bist_status {
+	uint64_t u;
+	struct cptx_pf_bist_status_s {
+#if defined(__BIG_ENDIAN_BITFIELD) /* Word 0 - Big Endian */
+		uint64_t reserved_30_63:34;
+		uint64_t bstatus:30;
+#else /* Word 0 - Little Endian */
+		uint64_t bstatus:30;
+		uint64_t reserved_30_63:34;
+#endif /* Word 0 - End */
+	} s;
+};
+
+/**
+ * Register (NCB) cpt#_pf_constants
+ *
+ * CPT PF Constants Register
+ * This register contains implementation-related parameters of CPT in CNXXXX.
+ * cptx_pf_constants_s
+ * Word 0
+ *  reserved_40_63:24 [63:40] Reserved.
+ *  epcis:8 [39:32](RO) Number of EPCI busses.
+ *  grps:8 [31:24](RO) Number of engine groups implemented.
+ *  ae:8 [23:16](RO/H) Number of AEs. In CNXXXX, for CPT0 returns 0x0,
+ *	for CPT1 returns 0x18, or less if there are fuse-disables.
+ *  se:8 [15:8](RO/H) Number of SEs. In CNXXXX, for CPT0 returns 0x30,
+ *	or less if there are fuse-disables, for CPT1 returns 0x0.
+ *  vq:8 [7:0](RO) Number of VQs.
+ * cptx_pf_constants_cn81xx
+ * Word 0
+ *  reserved_40_63:24 [63:40] Reserved
+ *  epcis:8 [39:32](RO) Number of EPCI busses.
+ *  grps:8 [31:24](RO) Number of engine groups implemented.
+ *  ae:8 [23:16](RO/H) Number of AEs. In CNXXXX, returns 0x6 or less
+ *	if there are fuse-disables.
+ *  se:8 [15: 8](RO/H) Number of SEs. In CNXXXX, returns 0xA, or less
+ *	if there are fuse-disables.
+ *  vq:8 [7:0](RO) Number of VQs.
+ *
+ */
+union cptx_pf_constants {
+	uint64_t u;
+	struct cptx_pf_constants_s {
+#if defined(__BIG_ENDIAN_BITFIELD) /* Word 0 - Big Endian */
+		uint64_t reserved_40_63:24;
+		uint64_t epcis:8;
+		uint64_t grps:8;
+		uint64_t ae:8;
+		uint64_t se:8;
+		uint64_t vq:8;
+#else /* Word 0 - Little Endian */
+		uint64_t vq:8;
+		uint64_t se:8;
+		uint64_t ae:8;
+		uint64_t grps:8;
+		uint64_t epcis:8;
+		uint64_t reserved_40_63:24;
+#endif /* Word 0 - End */
+	} s;
+	struct cptx_pf_constants_cn81xx {
+#if defined(__BIG_ENDIAN_BITFIELD) /* Word 0 - Big Endian */
+		uint64_t reserved_40_63:24;
+		uint64_t epcis:8;
+		uint64_t grps:8;
+		uint64_t ae:8;
+		uint64_t se:8;
+		uint64_t vq:8;
+#else /* Word 0 - Little Endian */
+		uint64_t vq:8;
+		uint64_t se:8;
+		uint64_t ae:8;
+		uint64_t grps:8;
+		uint64_t epcis:8;
+		uint64_t reserved_40_63:24;
+#endif /* Word 0 - End */
+	} cn81xx;
+};
+
+/**
+ * Register (NCB) cpt#_pf_exe_bist_status
+ *
+ * CPT PF Engine Bist Status Register
+ * This register has the BIST status of each engine.  Each bit is the
+ * BIST result of an individual engine (per bit, 0 = pass and 1 = fail).
+ * cptx_pf_exe_bist_status_s
+ * Word0
+ *  reserved_48_63:16 [63:48] reserved
+ *  bstatus:48 [47:0](RO/H) BIST status. One bit per engine.
+ *
+ */
+union cptx_pf_exe_bist_status {
+	uint64_t u;
+	struct cptx_pf_exe_bist_status_s {
+#if defined(__BIG_ENDIAN_BITFIELD) /* Word 0 - Big Endian */
+		uint64_t reserved_48_63:16;
+		uint64_t bstatus:48
+#else /* Word 0 - Little Endian */
+		uint64_t bstatus:48;
+		uint64_t reserved_48_63:16;
+#endif /* Word 0 - End */
+	} s;
+	struct cptx_pf_exe_bist_status_cn81xx {
+#if defined(__BIG_ENDIAN_BITFIELD) /* Word 0 - Big Endian */
+		uint64_t reserved_16_63:48;
+		uint64_t bstatus:16;
+#else /* Word 0 - Little Endian */
+		uint64_t bstatus:16;
+		uint64_t reserved_16_63:48;
+#endif /* Word 0 - End */
+	} cn81xx;
+};
+
+/**
+ * Register (NCB) cpt#_pf_exe_ctl
+ *
+ * CPT PF Engine Control Register
+ * This register enables the engines.
+ * cptx_pf_exe_ctl_s
+ * Word0
+ *  enable:64 [63:0](R/W) Individual enables for each of the engines.
+ */
+union cptx_pf_exe_ctl {
+	uint64_t u;
+	struct cptx_pf_exe_ctl_s {
+#if defined(__BIG_ENDIAN_BITFIELD) /* Word 0 - Big Endian */
+		uint64_t enable:64;
+#else /* Word 0 - Little Endian */
+		uint64_t enable:64;
+#endif /* Word 0 - End */
+	} s;
+};
+
+/**
+ * Register (NCB) cpt#_pf_q#_ctl
+ *
+ * CPT Queue Control Register
+ * This register configures queues. This register should be changed only
+ * when quiescent (see CPT()_VQ()_INPROG[INFLIGHT]).
+ * cptx_pf_qx_ctl_s
+ * Word0
+ *  reserved_60_63:4 [63:60] reserved.
+ *  aura:12; [59:48](R/W) Guest-aura for returning this queue's
+ *	instruction-chunk buffers to FPA. Only used when [INST_FREE] is set.
+ *	For the FPA to not discard the request, FPA_PF_MAP() must map
+ *	[AURA] and CPT()_PF_Q()_GMCTL[GMID] as valid.
+ *  reserved_45_47:3 [47:45] reserved.
+ *  size:13 [44:32](R/W) Command-buffer size, in number of 64-bit words per
+ *	command buffer segment. Must be 8*n + 1, where n is the number of
+ *	instructions per buffer segment.
+ *  reserved_11_31:21 [31:11] Reserved.
+ *  cont_err:1 [10:10](R/W) Continue on error.
+ *	0 = When CPT()_VQ()_MISC_INT[NWRP], CPT()_VQ()_MISC_INT[IRDE] or
+ *	CPT()_VQ()_MISC_INT[DOVF] are set by hardware or software via
+ *	CPT()_VQ()_MISC_INT_W1S, then CPT()_VQ()_CTL[ENA] is cleared.  Due to
+ *	pipelining, additional instructions may have been processed between the
+ *	instruction causing the error and the next instruction in the disabled
+ *	queue (the instruction at CPT()_VQ()_SADDR).
+ *	1 = Ignore errors and continue processing instructions.
+ *	For diagnostic use only.
+ *  inst_free:1 [9:9](R/W) Instruction FPA free. When set, when CPT reaches the
+ *	end of an instruction chunk, that chunk will be freed to the FPA.
+ *  inst_be:1 [8:8](R/W) Instruction big-endian control. When set, instructions,
+ *	instruction next chunk pointers, and result structures are stored in
+ *	big-endian format in memory.
+ *  iqb_ldwb:1 [7:7](R/W) Instruction load don't write back.
+ *	0 = The hardware issues NCB transient load (LDT) towards the cache,
+ *	which if the line hits and is is dirty will cause the line to be
+ *	written back before being replaced.
+ *	1 = The hardware issues NCB LDWB read-and-invalidate command towards
+ *	the cache when fetching the last word of instructions; as a result the
+ *	line will not be written back when replaced.  This improves
+ *	performance, but software must not read the instructions after they are
+ *	posted to the hardware.	Reads that do not consume the last word of a
+ *	cache line always use LDI.
+ *  reserved_4_6:3 [6:4] Reserved.
+ *  grp:3; [3:1](R/W) Engine group.
+ *  pri:1; [0:0](R/W) Queue priority.
+ *	1 = This queue has higher priority. Round-robin between higher
+ *	priority queues.
+ *	0 = This queue has lower priority. Round-robin between lower
+ *	priority queues.
+ */
+union cptx_pf_qx_ctl {
+	uint64_t u;
+	struct cptx_pf_qx_ctl_s {
+#if defined(__BIG_ENDIAN_BITFIELD) /* Word 0 - Big Endian */
+		uint64_t reserved_60_63:4;
+		uint64_t aura:12;
+		uint64_t reserved_45_47:3;
+		uint64_t size:13;
+		uint64_t reserved_11_31:21;
+		uint64_t cont_err:1;
+		uint64_t inst_free:1;
+		uint64_t inst_be:1;
+		uint64_t iqb_ldwb:1;
+		uint64_t reserved_4_6:3;
+		uint64_t grp:3;
+		uint64_t pri:1;
+#else /* Word 0 - Little Endian */
+		uint64_t pri:1;
+		uint64_t grp:3;
+		uint64_t reserved_4_6:3;
+		uint64_t iqb_ldwb:1;
+		uint64_t inst_be:1;
+		uint64_t inst_free:1;
+		uint64_t cont_err:1;
+		uint64_t reserved_11_31:21;
+		uint64_t size:13;
+		uint64_t reserved_45_47:3;
+		uint64_t aura:12;
+		uint64_t reserved_60_63:4;
+#endif /* Word 0 - End */
+	} s;
+    /* struct cptx_pf_qx_ctl_s cn; */
+};
+
+/**
+ * Register (NCB) cpt#_pf_g#_en
+ *
+ * CPT PF Group Control Register
+ * This register configures engine groups.
+ * cptx_pf_gx_en_s
+ * Word0
+ *  en: 64; [63:0](R/W/H) Engine group enable. One bit corresponds to each
+ *	engine, with the bit set to indicate this engine can service this group.
+ *	Bits corresponding to unimplemented engines read as zero, i.e. only bit
+ *	numbers	less than CPT()_PF_CONSTANTS[AE] + CPT()_PF_CONSTANTS[SE] are
+ *	writable. AE engine bits follow SE engine bits.
+ *	E.g. if CPT()_PF_CONSTANTS[AE] = 0x1, and CPT()_PF_CONSTANTS[SE] = 0x2,
+ *	then bits <2:0> are read/writable with bit <2> corresponding to AE<0>,
+ *	and bit <1> to SE<1>, and bit<0> to SE<0>. Before disabling an engine,
+ *	the corresponding bit in each group must be cleared. CPT()_PF_EXEC_BUSY
+ *	can then be polled to determing when the engine becomes	idle.
+ *	At the point, the engine can be disabled.
+ */
+union cptx_pf_gx_en {
+	uint64_t u;
+	struct cptx_pf_gx_en_s {
+#if defined(__BIG_ENDIAN_BITFIELD) /* Word 0 - Big Endian */
+		uint64_t en:64;
+#else /* Word 0 - Little Endian */
+		uint64_t en:64;
+#endif /* Word 0 - End */
+	} s;
+};
+
+/**
+ * Register (NCB) cpt#_vq#_saddr
+ *
+ * CPT Queue Starting Buffer Address Registers
+ * These registers set the instruction buffer starting address.
+ * cptx_vqx_saddr_s
+ * Word0
+ *  reserved_49_63:15 [63:49] Reserved.
+ *  ptr:43 [48:6](R/W/H) Instruction buffer IOVA <48:6> (64-byte aligned).
+ *	When written, it is the initial buffer starting address; when read,
+ *	it is the next read pointer to be requested from L2C. The PTR field
+ *	is overwritten with the next pointer each time that the command buffer
+ *	segment is exhausted. New commands will then be read from the newly
+ *	specified command buffer pointer.
+ *  reserved_0_5:6 [5:0] Reserved.
+ *
+ */
+union cptx_vqx_saddr {
+	uint64_t u;
+	struct cptx_vqx_saddr_s {
+#if defined(__BIG_ENDIAN_BITFIELD) /* Word 0 - Big Endian */
+		uint64_t reserved_49_63:15;
+		uint64_t ptr:43
+		uint64_t reserved_0_5:6;
+#else /* Word 0 - Little Endian */
+		uint64_t reserved_0_5:6;
+		uint64_t ptr:43;
+		uint64_t reserved_49_63:15;
+#endif /* Word 0 - End */
+	} s;
+};
+
+/**
+ * Register (NCB) cpt#_vq#_misc_ena_w1s
+ *
+ * CPT Queue Misc Interrupt Enable Set Register
+ * This register sets interrupt enable bits.
+ * cptx_vqx_misc_ena_w1s_s
+ * Word0
+ * reserved_5_63:59 [63:5] Reserved.
+ * swerr:1 [4:4](R/W1S/H) Reads or sets enable for
+ *	CPT(0..1)_VQ(0..63)_MISC_INT[SWERR].
+ * nwrp:1 [3:3](R/W1S/H) Reads or sets enable for
+ *	CPT(0..1)_VQ(0..63)_MISC_INT[NWRP].
+ * irde:1 [2:2](R/W1S/H) Reads or sets enable for
+ *	CPT(0..1)_VQ(0..63)_MISC_INT[IRDE].
+ * dovf:1 [1:1](R/W1S/H) Reads or sets enable for
+ *	CPT(0..1)_VQ(0..63)_MISC_INT[DOVF].
+ * mbox:1 [0:0](R/W1S/H) Reads or sets enable for
+ *	CPT(0..1)_VQ(0..63)_MISC_INT[MBOX].
+ *
+ */
+union cptx_vqx_misc_ena_w1s {
+	uint64_t u;
+	struct cptx_vqx_misc_ena_w1s_s {
+#if defined(__BIG_ENDIAN_BITFIELD) /* Word 0 - Big Endian */
+		uint64_t reserved_5_63:59;
+		uint64_t swerr:1;
+		uint64_t nwrp:1;
+		uint64_t irde:1;
+		uint64_t dovf:1;
+		uint64_t mbox:1;
+#else /* Word 0 - Little Endian */
+		uint64_t mbox:1;
+		uint64_t dovf:1;
+		uint64_t irde:1;
+		uint64_t nwrp:1;
+		uint64_t swerr:1;
+		uint64_t reserved_5_63:59;
+#endif /* Word 0 - End */
+	} s;
+	struct cptx_vqx_misc_ena_w1s_cn81xx {
+#if defined(__BIG_ENDIAN_BITFIELD) /* Word 0 - Big Endian */
+		uint64_t reserved_5_63:59;
+		uint64_t swerr:1;
+		uint64_t nwrp:1;
+		uint64_t irde:1;
+		uint64_t dovf:1;
+		uint64_t mbox:1;
+#else /* Word 0 - Little Endian */
+		uint64_t mbox:1;
+		uint64_t dovf:1;
+		uint64_t irde:1;
+		uint64_t nwrp:1;
+		uint64_t swerr:1;
+		uint64_t reserved_5_63:59;
+#endif /* Word 0 - End */
+	} cn81xx;
+};
+
+/**
+ * Register (NCB) cpt#_vq#_doorbell
+ *
+ * CPT Queue Doorbell Registers
+ * Doorbells for the CPT instruction queues.
+ * cptx_vqx_doorbell_s
+ * Word0
+ *  reserved_20_63:44 [63:20] Reserved.
+ *  dbell_cnt:20 [19:0](R/W/H) Number of instruction queue 64-bit words to add
+ *	to the CPT instruction doorbell count. Readback value is the the
+ *	current number of pending doorbell requests. If counter overflows
+ *	CPT()_VQ()_MISC_INT[DBELL_DOVF] is set. To reset the count back to
+ *	zero, write one to clear CPT()_VQ()_MISC_INT_ENA_W1C[DBELL_DOVF],
+ *	then write a value of 2^20 minus the read [DBELL_CNT], then write one
+ *	to CPT()_VQ()_MISC_INT_W1C[DBELL_DOVF] and
+ *	CPT()_VQ()_MISC_INT_ENA_W1S[DBELL_DOVF]. Must be a multiple of 8.
+ *	All CPT instructions are 8 words and require a doorbell count of
+ *	multiple of 8.
+ */
+union cptx_vqx_doorbell {
+	uint64_t u;
+	struct cptx_vqx_doorbell_s {
+#if defined(__BIG_ENDIAN_BITFIELD) /* Word 0 - Big Endian */
+		uint64_t reserved_20_63:44;
+		uint64_t dbell_cnt:20;
+#else /* Word 0 - Little Endian */
+		uint64_t dbell_cnt:20;
+		uint64_t reserved_20_63:44;
+#endif /* Word 0 - End */
+	} s;
+};
+
+/**
+ * Register (NCB) cpt#_vq#_inprog
+ *
+ * CPT Queue In Progress Count Registers
+ * These registers contain the per-queue instruction in flight registers.
+ * cptx_vqx_inprog_s
+ * Word0
+ *  reserved_8_63:56 [63:8] Reserved.
+ *  inflight:8 [7:0](RO/H) Inflight count. Counts the number of instructions
+ *	for the VF for which CPT is fetching, executing or responding to
+ *	instructions. However this does not include any interrupts that are
+ *	awaiting software handling (CPT()_VQ()_DONE[DONE] != 0x0).
+ *	A queue may not be reconfigured until:
+ *	1. CPT()_VQ()_CTL[ENA] is cleared by software.
+ *	2. [INFLIGHT] is polled until equals to zero.
+ */
+union cptx_vqx_inprog {
+	uint64_t u;
+	struct cptx_vqx_inprog_s {
+#if defined(__BIG_ENDIAN_BITFIELD) /* Word 0 - Big Endian */
+		uint64_t reserved_8_63:56;
+		uint64_t inflight:8;
+#else /* Word 0 - Little Endian */
+		uint64_t inflight:8;
+		uint64_t reserved_8_63:56;
+#endif /* Word 0 - End */
+	} s;
+};
+
+/**
+ * Register (NCB) cpt#_vq#_misc_int
+ *
+ * CPT Queue Misc Interrupt Register
+ * These registers contain the per-queue miscellaneous interrupts.
+ * cptx_vqx_misc_int_s
+ * Word 0
+ *  reserved_5_63:59 [63:5] Reserved.
+ *  swerr:1 [4:4](R/W1C/H) Software error from engines.
+ *  nwrp:1  [3:3](R/W1C/H) NCB result write response error.
+ *  irde:1  [2:2](R/W1C/H) Instruction NCB read response error.
+ *  dovf:1 [1:1](R/W1C/H) Doorbell overflow.
+ *  mbox:1 [0:0](R/W1C/H) PF to VF mailbox interrupt. Set when
+ *	CPT()_VF()_PF_MBOX(0) is written.
+ *
+ */
+union cptx_vqx_misc_int {
+	uint64_t u;
+	struct cptx_vqx_misc_int_s {
+#if defined(__BIG_ENDIAN_BITFIELD) /* Word 0 - Big Endian */
+		uint64_t reserved_5_63:59;
+		uint64_t swerr:1;
+		uint64_t nwrp:1;
+		uint64_t irde:1;
+		uint64_t dovf:1;
+		uint64_t mbox:1;
+#else /* Word 0 - Little Endian */
+		uint64_t mbox:1;
+		uint64_t dovf:1;
+		uint64_t irde:1;
+		uint64_t nwrp:1;
+		uint64_t swerr:1;
+		uint64_t reserved_5_63:59;
+#endif /* Word 0 - End */
+	} s;
+};
+
+/**
+ * Register (NCB) cpt#_vq#_done_ack
+ *
+ * CPT Queue Done Count Ack Registers
+ * This register is written by software to acknowledge interrupts.
+ * cptx_vqx_done_ack_s
+ * Word0
+ *  reserved_20_63:44 [63:20] Reserved.
+ *  done_ack:20 [19:0](R/W/H) Number of decrements to CPT()_VQ()_DONE[DONE].
+ *	Reads CPT()_VQ()_DONE[DONE]. Written by software to acknowledge
+ *	interrupts. If CPT()_VQ()_DONE[DONE] is still nonzero the interrupt
+ *	will be re-sent if the conditions described in CPT()_VQ()_DONE[DONE]
+ *	are satisfied.
+ *
+ */
+union cptx_vqx_done_ack {
+	uint64_t u;
+	struct cptx_vqx_done_ack_s {
+#if defined(__BIG_ENDIAN_BITFIELD) /* Word 0 - Big Endian */
+		uint64_t reserved_20_63:44;
+		uint64_t done_ack:20;
+#else /* Word 0 - Little Endian */
+		uint64_t done_ack:20;
+		uint64_t reserved_20_63:44;
+#endif /* Word 0 - End */
+	} s;
+};
+
+/**
+ * Register (NCB) cpt#_vq#_done
+ *
+ * CPT Queue Done Count Registers
+ * These registers contain the per-queue instruction done count.
+ * cptx_vqx_done_s
+ * Word0
+ *  reserved_20_63:44 [63:20] Reserved.
+ *  done:20 [19:0](R/W/H) Done count. When CPT_INST_S[DONEINT] set and that
+ *	instruction completes, CPT()_VQ()_DONE[DONE] is incremented when the
+ *	instruction finishes. Write to this field are for diagnostic use only;
+ *	instead software writes CPT()_VQ()_DONE_ACK with the number of
+ *	decrements for this field.
+ *	Interrupts are sent as follows:
+ *	* When CPT()_VQ()_DONE[DONE] = 0, then no results are pending, the
+ *	interrupt coalescing timer is held to zero, and an interrupt is not
+ *	sent.
+ *	* When CPT()_VQ()_DONE[DONE] != 0, then the interrupt coalescing timer
+ *	counts. If the counter is >= CPT()_VQ()_DONE_WAIT[TIME_WAIT]*1024, or
+ *	CPT()_VQ()_DONE[DONE] >= CPT()_VQ()_DONE_WAIT[NUM_WAIT], i.e. enough
+ *	time has passed or enough results have arrived, then the interrupt is
+ *	sent.
+ *	* When CPT()_VQ()_DONE_ACK is written (or CPT()_VQ()_DONE is written
+ *	but this is not typical), the interrupt coalescing timer restarts.
+ *	Note after decrementing this interrupt equation is recomputed,
+ *	for example if CPT()_VQ()_DONE[DONE] >= CPT()_VQ()_DONE_WAIT[NUM_WAIT]
+ *	and because the timer is zero, the interrupt will be resent immediately.
+ *	(This covers the race case between software acknowledging an interrupt
+ *	and a result returning.)
+ *	* When CPT()_VQ()_DONE_ENA_W1S[DONE] = 0, interrupts are not sent,
+ *	but the counting described above still occurs.
+ *	Since CPT instructions complete out-of-order, if software is using
+ *	completion interrupts the suggested scheme is to request a DONEINT on
+ *	each request, and when an interrupt arrives perform a "greedy" scan for
+ *	completions; even if a later command is acknowledged first this will
+ *	not result in missing a completion.
+ *	Software is responsible for making sure [DONE] does not overflow;
+ *	for example by insuring there are not more than 2^20-1 instructions in
+ *	flight that may request interrupts.
+ *
+ */
+union cptx_vqx_done {
+	uint64_t u;
+	struct cptx_vqx_done_s {
+#if defined(__BIG_ENDIAN_BITFIELD) /* Word 0 - Big Endian */
+		uint64_t reserved_20_63:44;
+		uint64_t done:20;
+#else /* Word 0 - Little Endian */
+		uint64_t done:20;
+		uint64_t reserved_20_63:44;
+#endif /* Word 0 - End */
+	} s;
+};
+
+/**
+ * Register (NCB) cpt#_vq#_done_wait
+ *
+ * CPT Queue Done Interrupt Coalescing Wait Registers
+ * Specifies the per queue interrupt coalescing settings.
+ * cptx_vqx_done_wait_s
+ * Word0
+ *  reserved_48_63:16 [63:48] Reserved.
+ *  time_wait:16; [47:32](R/W) Time hold-off. When CPT()_VQ()_DONE[DONE] = 0
+ *	or CPT()_VQ()_DONE_ACK is written a timer is cleared. When the timer
+ *	reaches [TIME_WAIT]*1024 then interrupt coalescing ends.
+ *	see CPT()_VQ()_DONE[DONE]. If 0x0, time coalescing is disabled.
+ *  reserved_20_31:12 [31:20] Reserved.
+ *  num_wait:20 [19:0](R/W) Number of messages hold-off.
+ *	When CPT()_VQ()_DONE[DONE] >= [NUM_WAIT] then interrupt coalescing ends
+ *	see CPT()_VQ()_DONE[DONE]. If 0x0, same behavior as 0x1.
+ *
+ */
+union cptx_vqx_done_wait {
+	uint64_t u;
+	struct cptx_vqx_done_wait_s {
+#if defined(__BIG_ENDIAN_BITFIELD) /* Word 0 - Big Endian */
+		uint64_t reserved_48_63:16;
+		uint64_t time_wait:16;
+		uint64_t reserved_20_31:12;
+		uint64_t num_wait:20;
+#else /* Word 0 - Little Endian */
+		uint64_t num_wait:20;
+		uint64_t reserved_20_31:12;
+		uint64_t time_wait:16;
+		uint64_t reserved_48_63:16;
+#endif /* Word 0 - End */
+	} s;
+};
+
+/**
+ * Register (NCB) cpt#_vq#_done_ena_w1s
+ *
+ * CPT Queue Done Interrupt Enable Set Registers
+ * Write 1 to these registers will enable the DONEINT interrupt for the queue.
+ * cptx_vqx_done_ena_w1s_s
+ * Word0
+ *  reserved_1_63:63 [63:1] Reserved.
+ *  done:1 [0:0](R/W1S/H) Write 1 will enable DONEINT for this queue.
+ *	Write 0 has no effect. Read will return the enable bit.
+ */
+union cptx_vqx_done_ena_w1s {
+	uint64_t u;
+	struct cptx_vqx_done_ena_w1s_s {
+#if defined(__BIG_ENDIAN_BITFIELD) /* Word 0 - Big Endian */
+		uint64_t reserved_1_63:63;
+		uint64_t done:1;
+#else /* Word 0 - Little Endian */
+		uint64_t done:1;
+		uint64_t reserved_1_63:63;
+#endif /* Word 0 - End */
+	} s;
+};
+
+/**
+ * Register (NCB) cpt#_vq#_ctl
+ *
+ * CPT VF Queue Control Registers
+ * This register configures queues. This register should be changed (other than
+ * clearing [ENA]) only when quiescent (see CPT()_VQ()_INPROG[INFLIGHT]).
+ * cptx_vqx_ctl_s
+ * Word0
+ *  reserved_1_63:63 [63:1] Reserved.
+ *  ena:1 [0:0](R/W/H) Enables the logical instruction queue.
+ *	See also CPT()_PF_Q()_CTL[CONT_ERR] and	CPT()_VQ()_INPROG[INFLIGHT].
+ *	1 = Queue is enabled.
+ *	0 = Queue is disabled.
+ */
+union cptx_vqx_ctl {
+	uint64_t u;
+	struct cptx_vqx_ctl_s {
+#if defined(__BIG_ENDIAN_BITFIELD) /* Word 0 - Big Endian */
+		uint64_t reserved_1_63:63;
+		uint64_t ena:1;
+#else /* Word 0 - Little Endian */
+		uint64_t ena:1;
+		uint64_t reserved_1_63:63;
+#endif /* Word 0 - End */
+	} s;
+};
+#endif /*__CPT_HW_TYPES_H*/
diff --git a/drivers/crypto/cavium/cpt/cpt_main.c b/drivers/crypto/cavium/cpt/cpt_main.c
new file mode 100644
index 0000000..f5a89f9
--- /dev/null
+++ b/drivers/crypto/cavium/cpt/cpt_main.c
@@ -0,0 +1,891 @@
+/*
+ * Copyright (C) 2016 Cavium, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License
+ * as published by the Free Software Foundation.
+ */
+
+#include <linux/version.h>
+#include <linux/aer.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/printk.h>
+#include <linux/device.h>
+#include <linux/interrupt.h>
+#include <linux/firmware.h>
+#include <linux/pci.h>
+
+#include "cpt.h"
+
+#define DRV_NAME	"thunder-cpt"
+#define DRV_VERSION	"1.0"
+
+/* Global list for holding all cpt_device pointers */
+struct cpt_device_list cpt_dev_list;
+
+static uint32_t num_vfs = 1; /* Default 1 VF enabled */
+module_param(num_vfs, uint, 0);
+MODULE_PARM_DESC(num_vfs, "Number of VFs to enable(1-16)");
+
+static inline void cpt_init_device_list(struct cpt_device_list *cpt_list)
+{
+	cpt_list->nr_device = 0;
+	spin_lock_init(&cpt_list->lock);
+
+	memset(cpt_list->device_ptr, 0, (sizeof(void *) * MAX_CPT_DEVICES));
+}
+
+static inline int32_t cpt_get_device_number(struct cpt_device_list *cpt_list,
+					    void *dev)
+{
+	struct cpt_device *cpt = (struct cpt_device *)dev;
+	int32_t i = 0;
+
+	spin_lock(&cpt_list->lock);
+
+	for (i = 0; i < MAX_CPT_DEVICES; i++) {
+		if (cpt_list->device_ptr[i] == cpt) {
+			spin_unlock(&cpt_list->lock);
+			return i;
+		}
+	}
+	spin_unlock(&cpt_list->lock);
+
+	return -1;
+}
+
+static inline int32_t cpt_add_device(struct cpt_device_list *cpt_list,
+				     struct cpt_device *cpt)
+{
+	/* lock the global device list */
+	spin_lock(&cpt_list->lock);
+
+	if (cpt_list->nr_device > MAX_CPT_DEVICES) {
+		/* unlock the global device list */
+		spin_unlock(&cpt_list->lock);
+		return -ENOMEM;
+	}
+
+	cpt->idx = cpt_list->nr_device;
+
+	cpt_list->device_ptr[cpt_list->nr_device] = cpt;
+	cpt_list->nr_device++;
+
+	/* unlock the global device list */
+	spin_unlock(&cpt_list->lock);
+
+	return 0;
+}
+
+static inline void cpt_remove_device(struct cpt_device_list *cpt_list,
+				     struct cpt_device *cpt)
+{
+	int32_t i = 0;
+
+	/* lock the global device list */
+	spin_lock(&cpt_list->lock);
+
+	while (i < MAX_CPT_DEVICES) {
+		if (cpt_list->device_ptr[i] == cpt) {
+			cpt_list->device_ptr[i] = NULL;
+			cpt_list->nr_device--;
+			break;
+		}
+		i++;
+	}
+
+	/* unlock the global device list */
+	spin_unlock(&cpt_list->lock);
+}
+
+struct cpt_device *cpt_get_device(struct cpt_device_list *cpt_list,
+				  int32_t dev_no)
+{
+	if (dev_no >= cpt_list->nr_device)
+		return NULL;
+
+	return cpt_list->device_ptr[dev_no];
+}
+
+int32_t nr_cpt_devices(struct cpt_device_list *cpt_list)
+{
+	return cpt_list->nr_device;
+}
+
+static uint64_t get_mask_from_value(int32_t value)
+{
+	uint64_t mask = 0ULL;
+	int32_t i;
+
+	for (i = 0; i < value; i++)
+		mask |= ((uint64_t)1 << i);
+
+	return mask;
+}
+
+/*
+ * Disable cores specified by coremask
+ */
+static void cpt_disable_cores(struct cpt_device *cpt, uint64_t coremask,
+			      uint8_t type, uint8_t grp)
+{
+	union cptx_pf_exe_ctl pf_exe_ctl;
+	uint32_t timeout = 0xFFFFFFFF;
+	uint64_t grpmask = 0;
+	struct device *dev = &cpt->pdev->dev;
+
+	if (type == AE_TYPES)
+		coremask = (coremask << cpt->max_se_cores);
+
+	/* Disengage the cores from groups */
+	grpmask = cpt_read_csr64(cpt->reg_base, CPTX_PF_GX_EN(0, grp));
+	cpt_write_csr64(cpt->reg_base, CPTX_PF_GX_EN(0, grp),
+			(grpmask & ~coremask));
+	udelay(CSR_DELAY);
+	grp = cpt_read_csr64(cpt->reg_base, CPTX_PF_EXEC_BUSY(0));
+	while (grp & coremask) {
+		dev_err(dev, "Cores still busy %llx", coremask);
+		grp = cpt_read_csr64(cpt->reg_base,
+				     CPTX_PF_EXEC_BUSY(0));
+		if (timeout--)
+			break;
+	}
+
+	/* Disable the cores */
+	pf_exe_ctl.u = cpt_read_csr64(cpt->reg_base, CPTX_PF_EXE_CTL(0));
+	cpt_write_csr64(cpt->reg_base, CPTX_PF_EXE_CTL(0),
+			(pf_exe_ctl.u & ~coremask));
+	udelay(CSR_DELAY);
+}
+
+/*
+ * Enable cores specified by coremask
+ */
+static void cpt_enable_cores(struct cpt_device *cpt, uint64_t coremask,
+			     uint8_t type)
+{
+	union cptx_pf_exe_ctl pf_exe_ctl;
+
+	if (type == AE_TYPES)
+		coremask = (coremask << cpt->max_se_cores);
+
+	pf_exe_ctl.u = cpt_read_csr64(cpt->reg_base, CPTX_PF_EXE_CTL(0));
+	cpt_write_csr64(cpt->reg_base, CPTX_PF_EXE_CTL(0),
+			(pf_exe_ctl.u | coremask));
+	udelay(CSR_DELAY);
+}
+
+static void cpt_configure_group(struct cpt_device *cpt, uint8_t grp,
+				uint64_t coremask, uint8_t type)
+{
+	union cptx_pf_gx_en pf_gx_en = {0};
+
+	if (type == AE_TYPES)
+		coremask = (coremask << cpt->max_se_cores);
+
+	pf_gx_en.u = cpt_read_csr64(cpt->reg_base, CPTX_PF_GX_EN(0, grp));
+	cpt_write_csr64(cpt->reg_base, CPTX_PF_GX_EN(0, grp),
+			(pf_gx_en.u | coremask));
+	udelay(CSR_DELAY);
+}
+
+static void cpt_disable_mbox_interrupts(struct cpt_device *cpt)
+{
+	/* Clear mbox(0) interupts for all vfs */
+	cpt_write_csr64(cpt->reg_base, CPTX_PF_MBOX_ENA_W1CX(0, 0), ~0ull);
+}
+
+static void cpt_disable_ecc_interrupts(struct cpt_device *cpt)
+{
+	/* Clear ecc(0) interupts for all vfs */
+	cpt_write_csr64(cpt->reg_base, CPTX_PF_ECC0_ENA_W1C(0), ~0ull);
+}
+
+static void cpt_disable_exec_interrupts(struct cpt_device *cpt)
+{
+	/* Clear exec interupts for all vfs */
+	cpt_write_csr64(cpt->reg_base, CPTX_PF_EXEC_ENA_W1C(0), ~0ull);
+}
+
+static void cpt_disable_all_interrupts(struct cpt_device *cpt)
+{
+	cpt_disable_mbox_interrupts(cpt);
+	cpt_disable_ecc_interrupts(cpt);
+	cpt_disable_exec_interrupts(cpt);
+}
+
+static void cpt_enable_mbox_interrupts(struct cpt_device *cpt)
+{
+	/* Set mbox(0) interupts for all vfs */
+	cpt_write_csr64(cpt->reg_base, CPTX_PF_MBOX_ENA_W1SX(0, 0), ~0ull);
+}
+
+static void cpt_enable_ecc_interrupts(struct cpt_device *cpt)
+{
+	/* Set ecc(0) interupts for all vfs */
+	cpt_write_csr64(cpt->reg_base, CPTX_PF_ECC0_ENA_W1S(0), ~0ull);
+}
+
+static void cpt_enable_exec_interrupts(struct cpt_device *cpt)
+{
+	/* Set exec interupts for all vfs */
+	cpt_write_csr64(cpt->reg_base, CPTX_PF_EXEC_ENA_W1S(0), ~0ull);
+}
+
+static void cpt_enable_all_interrupts(struct cpt_device *cpt)
+{
+	cpt_enable_mbox_interrupts(cpt);
+	cpt_enable_ecc_interrupts(cpt);
+	cpt_enable_exec_interrupts(cpt);
+}
+
+static int32_t cpt_load_microcode(struct cpt_device *cpt,
+				  struct microcode *mcode)
+{
+	int32_t ret = 0, core = 0, shift = 0;
+	uint32_t total_cores = 0;
+	struct device *dev = &cpt->pdev->dev;
+
+	if (!mcode || !mcode->code) {
+		dev_err(dev, "Either the mcode is null or data is NULL\n");
+		return 1;
+	}
+
+	if (mcode->code_size == 0) {
+		dev_err(dev, "microcode size is 0\n");
+		return 1;
+	}
+
+	/* Assumes 0-9 are SE cores for UCODE_BASE registers and
+	 * AE core bases follow
+	 */
+	if (mcode->is_ae) {
+		core = CPT_MAX_SE_CORES; /* start couting from 10 */
+		total_cores = CPT_MAX_TOTAL_CORES; /* upto 15 */
+	} else {
+		core = 0; /* start couting from 0 */
+		total_cores = CPT_MAX_SE_CORES; /* upto 9 */
+	}
+
+	/* Point to microcode for each core of the group */
+	for (; core < total_cores ; core++, shift++) {
+		if (mcode->core_mask_low & (1 << shift)) {
+			cpt_write_csr64(cpt->reg_base,
+					CPTX_PF_ENGX_UCODE_BASE(0, core),
+					(uint64_t)mcode->phys_base);
+		}
+	}
+	return ret;
+}
+
+static int32_t do_cpt_init(struct cpt_device *cpt, struct microcode *mcode)
+{
+	int32_t ret = 0;
+	struct device *dev = &cpt->pdev->dev;
+
+	/* Make device not ready */
+	cpt->flags &= ~CPT_FLAG_DEVICE_READY;
+	/* Disable All PF interrupts */
+	cpt_disable_all_interrupts(cpt);
+	/* Calculate mcode group and coremasks */
+	if (mcode->is_ae) {
+		if (mcode->num_cores > cpt->avail_ae_cores) {
+			dev_err(dev, "Requested for more cores than available AE cores\n");
+			ret = -1;
+			goto cpt_init_fail;
+		}
+
+		if (cpt->next_group >= CPT_MAX_CORE_GROUPS) {
+			dev_err(dev, "Can't load, all eight microcode groups in use");
+			return -ENFILE;
+		}
+
+		mcode->group = cpt->next_group;
+		/* Convert requested cores to mask */
+		mcode->core_mask_low = get_mask_from_value(mcode->num_cores);
+		mcode->core_mask_low <<= (cpt->max_ae_cores -
+					  cpt->avail_ae_cores);
+		/* Deduct the available ae cores */
+		cpt->avail_ae_cores -= mcode->num_cores;
+		cpt_disable_cores(cpt, mcode->core_mask_low, AE_TYPES,
+				  mcode->group);
+		/* Load microcode for AE engines */
+		if (cpt_load_microcode(cpt, mcode)) {
+			dev_err(dev, "Microcode load Failed for %s\n",
+				mcode->version);
+			ret = -1;
+			goto cpt_init_fail;
+		}
+		cpt->next_group++;
+		/* Configure group mask for the mcode */
+		cpt_configure_group(cpt, mcode->group, mcode->core_mask_low,
+				    AE_TYPES);
+		/* Enable AE cores for the group mask */
+		cpt_enable_cores(cpt, mcode->core_mask_low, AE_TYPES);
+	} else {
+		if (mcode->num_cores > cpt->avail_se_cores) {
+			dev_err(dev, "Requested for more cores than available SE cores\n");
+			ret = -1;
+			goto cpt_init_fail;
+		}
+		if (cpt->next_group >= CPT_MAX_CORE_GROUPS) {
+			dev_err(dev, "Can't load, all eight microcode groups in use");
+			return -ENFILE;
+		}
+
+		mcode->group = cpt->next_group;
+		/* Covert requested cores to mask */
+		mcode->core_mask_low = get_mask_from_value(mcode->num_cores);
+		mcode->core_mask_low <<= (cpt->max_se_cores -
+					  cpt->avail_se_cores);
+		/* Deduct the available se cores */
+		cpt->avail_se_cores -= mcode->num_cores;
+		cpt_disable_cores(cpt, mcode->core_mask_low, SE_TYPES,
+				  mcode->group);
+		/* Load microcode for SE engines */
+		if (cpt_load_microcode(cpt, mcode)) {
+			dev_err(dev, "Microcode load Failed for %s\n",
+				mcode->version);
+			ret = -1;
+			goto cpt_init_fail;
+		}
+		cpt->next_group++;
+		/* Configure group mask for the mcode */
+		cpt_configure_group(cpt, mcode->group, mcode->core_mask_low,
+				    SE_TYPES);
+		/* Enable SE cores for the group mask */
+		cpt_enable_cores(cpt, mcode->core_mask_low, SE_TYPES);
+	}
+
+	/* Enabled PF mailbox interrupts */
+	cpt_enable_mbox_interrupts(cpt);
+	cpt->flags |= CPT_FLAG_DEVICE_READY;
+
+	return ret;
+
+cpt_init_fail:
+	/* Enabled PF mailbox interrupts */
+	cpt_enable_mbox_interrupts(cpt);
+	/* Reset coremask values */
+	/* TODO: Revisit this failure case for more loads case */
+	cpt->avail_ae_cores = cpt->max_ae_cores;
+	cpt->avail_se_cores = cpt->max_se_cores;
+
+	return ret;
+}
+
+struct ucode_header {
+	uint8_t version[32];
+	uint32_t code_length;
+	uint32_t data_length;
+	uint64_t sram_address;
+};
+
+static int32_t cpt_ucode_load_fw(struct cpt_device *cpt, const uint8_t *fw,
+				 bool is_ae)
+{
+	const struct firmware *fw_entry;
+	struct device *dev = &cpt->pdev->dev;
+	struct ucode_header *ucode;
+	struct microcode *mcode;
+	int j, ret = 0;
+
+	ret = request_firmware(&fw_entry, fw, dev);
+	if (ret)
+		return ret;
+
+	mcode = &cpt->mcode[cpt->next_mc_idx];
+	ucode = (struct ucode_header *)fw_entry->data;
+	memcpy(mcode->version, (uint8_t *)fw_entry->data, 32);
+	mcode->code_size = ntohl(ucode->code_length) * 2;
+	mcode->is_ae = is_ae;
+	mcode->core_mask_low  = 0ULL;
+	mcode->core_mask_hi   = 0ULL;
+	mcode->num_cores = is_ae ? 6 : 10;
+
+	/*  Allocate DMAable space */
+	mcode->code = dma_zalloc_coherent(&cpt->pdev->dev, mcode->code_size,
+					  &mcode->dma, GFP_KERNEL);
+	if (!mcode->code) {
+		dev_err(dev, "Unable to allocate space for microcode");
+		return -ENOMEM;
+	}
+	/* Align memory address for 'align_bytes' */
+	/* Neglect Bits 6:0 and 49:63: Align for 128-bytes */
+	mcode->phys_base = ALIGN((uint64_t)mcode->dma, 128);
+	mcode->base = mcode->code + (mcode->phys_base - mcode->dma);
+	memcpy((void *)mcode->base, (void *)(fw_entry->data + 48),
+	       mcode->code_size);
+
+	/* Byte swap 64-bit */
+	for (j = 0; j < (mcode->code_size / 8); j++)
+		byte_swap_64(&((uint64_t *)mcode->base)[j]);
+	/*  MC needs 16-bit swap */
+	for (j = 0; j < (mcode->code_size / 2); j++)
+		byte_swap_16(&((uint16_t *)mcode->base)[j]);
+
+	dev_dbg(dev, "mcode->code_size = %u\n", mcode->code_size);
+	dev_dbg(dev, "mcode->is_ae       = %u\n", mcode->is_ae);
+	dev_dbg(dev, "mcode->num_cores   = %u\n", mcode->num_cores);
+	dev_dbg(dev, "mcode->code = %llx\n", (uint64_t)mcode->code);
+	dev_dbg(dev, "mcode->phys_base = %llx\n", mcode->phys_base);
+	dev_dbg(dev, "mcode->base = %llx\n", (uint64_t)mcode->base);
+	dev_dbg(dev, "mcode->is_mc_valid = %u\n", mcode->is_mc_valid);
+
+	ret = do_cpt_init(cpt, mcode);
+	if (ret) {
+		dev_err(dev, "do_cpt_init failed with ret: %d\n", ret);
+		return ret;
+	}
+
+	dev_dbg(dev, "Microcode Loaded\n");
+	mcode->is_mc_valid = 1;
+	cpt->next_mc_idx++;
+	dev_dbg(dev, "mcode->is_mc_valid = %u\n", mcode->is_mc_valid);
+	release_firmware(fw_entry);
+
+	return ret;
+}
+
+static int32_t cpt_ucode_load(struct cpt_device *cpt)
+{
+	int32_t ret = 0;
+	struct device *dev = &cpt->pdev->dev;
+
+	ret = cpt_ucode_load_fw(cpt, "cpt8x-mc-ae.out", true);
+	if (ret) {
+		dev_err(dev, "ae:cpt_ucode_load failed with ret: %d\n", ret);
+		return ret;
+	}
+	ret = cpt_ucode_load_fw(cpt, "cpt8x-mc-se.out", false);
+	if (ret) {
+		dev_err(dev, "se:cpt_ucode_load failed with ret: %d\n", ret);
+		return ret;
+	}
+
+	return ret;
+}
+
+uint16_t active_cpt_devmask(struct cpt_device_list *cpt_list)
+{
+	struct cpt_device *cpt;
+	uint16_t mask = 0;
+	int32_t i = 0;
+
+	while (i < MAX_CPT_DEVICES) {
+		cpt = cpt_list->device_ptr[i];
+		if (cpt && cpt_device_ready(cpt))
+			mask |= (1 << i);
+		i++;
+	}
+
+	return mask;
+}
+
+static int32_t cpt_enable_msix(struct cpt_device *cpt)
+{
+	int32_t i, ret;
+
+	cpt->num_vec = CPT_PF_MSIX_VECTORS;
+
+	for (i = 0; i < cpt->num_vec; i++)
+		cpt->msix_entries[i].entry = i;
+
+	ret = pci_enable_msix(cpt->pdev, cpt->msix_entries, cpt->num_vec);
+	if (ret) {
+		dev_err(&cpt->pdev->dev, "Request for #%d msix vectors failed\n",
+			cpt->num_vec);
+		return ret;
+	}
+
+	cpt->msix_enabled = 1;
+	return 0;
+}
+
+static irqreturn_t cpt_mbx0_intr_handler (int32_t irq, void *cpt_irq)
+{
+	struct cpt_device *cpt = (struct cpt_device *)cpt_irq;
+
+	cpt_mbox_intr_handler(cpt, 0);
+
+	return IRQ_HANDLED;
+}
+
+static void cpt_disable_msix(struct cpt_device *cpt)
+{
+	if (cpt->msix_enabled) {
+		pci_disable_msix(cpt->pdev);
+		cpt->msix_enabled = 0;
+		cpt->num_vec = 0;
+	}
+}
+
+static void cpt_free_all_interrupts(struct cpt_device *cpt)
+{
+	int32_t irq;
+
+	for (irq = 0; irq < cpt->num_vec; irq++) {
+		if (cpt->irq_allocated[irq])
+			free_irq(cpt->msix_entries[irq].vector, cpt);
+		cpt->irq_allocated[irq] = false;
+	}
+}
+
+static void cpt_reset(struct cpt_device *cpt)
+{
+	cpt_write_csr64(cpt->reg_base, CPTX_PF_RESET(0), 1);
+}
+
+static void cpt_find_max_enabled_cores(struct cpt_device *cpt)
+{
+	union cptx_pf_constants pf_cnsts = {0};
+
+	pf_cnsts.u = cpt_read_csr64(cpt->reg_base, CPTX_PF_CONSTANTS(0));
+	cpt->max_se_cores = pf_cnsts.s.se;
+	cpt->max_ae_cores = pf_cnsts.s.ae;
+}
+
+static uint32_t cpt_check_bist_status(struct cpt_device *cpt)
+{
+	union cptx_pf_bist_status bist_sts = {0};
+
+	bist_sts.u = cpt_read_csr64(cpt->reg_base,
+				    CPTX_PF_BIST_STATUS(0));
+
+	return bist_sts.u;
+}
+
+static uint64_t cpt_check_exe_bist_status(struct cpt_device *cpt)
+{
+	union cptx_pf_exe_bist_status bist_sts = {0};
+
+	bist_sts.u = cpt_read_csr64(cpt->reg_base,
+				    CPTX_PF_EXE_BIST_STATUS(0));
+
+	return bist_sts.u;
+}
+
+static void cpt_disable_all_cores(struct cpt_device *cpt)
+{
+	uint32_t grp, timeout = 0xFFFFFFFF;
+	struct device *dev = &cpt->pdev->dev;
+
+	/* Disengage the cores from groups */
+	for (grp = 0; grp < CPT_MAX_CORE_GROUPS; grp++) {
+		cpt_write_csr64(cpt->reg_base, CPTX_PF_GX_EN(0, grp), 0);
+		udelay(CSR_DELAY);
+	}
+
+	grp = cpt_read_csr64(cpt->reg_base, CPTX_PF_EXEC_BUSY(0));
+	while (grp) {
+		dev_err(dev, "Cores still busy");
+		grp = cpt_read_csr64(cpt->reg_base,
+				     CPTX_PF_EXEC_BUSY(0));
+		if (timeout--)
+			break;
+	}
+	/* Disable the cores */
+	cpt_write_csr64(cpt->reg_base, CPTX_PF_EXE_CTL(0), 0);
+}
+
+/**
+ * Ensure all cores are disenganed from all groups by
+ * calling cpt_disable_all_cores() before calling this
+ * function.
+ */
+static void cpt_unload_microcode(struct cpt_device *cpt)
+{
+	uint32_t grp = 0, core;
+
+	/* Free microcode bases and reset group masks */
+	for (grp = 0; grp < CPT_MAX_CORE_GROUPS; grp++) {
+		struct microcode *mcode = &cpt->mcode[grp];
+
+		if (cpt->mcode[grp].code)
+			dma_free_coherent(&cpt->pdev->dev, mcode->code_size,
+					  mcode->code, mcode->dma);
+		mcode->code = NULL;
+		mcode->base = NULL;
+	}
+	/* Clear UCODE_BASE registers for all engines */
+	for (core = 0; core < CPT_MAX_TOTAL_CORES; core++)
+		cpt_write_csr64(cpt->reg_base,
+				CPTX_PF_ENGX_UCODE_BASE(0, core), 0ull);
+}
+
+static int32_t cpt_device_init(struct cpt_device *cpt)
+{
+	uint16_t device_id;
+	uint8_t rev_id;
+	uint64_t bist;
+	struct device *dev = &cpt->pdev->dev;
+
+	/* Reset the PF when probed first */
+	cpt_reset(cpt);
+	mdelay((100));
+
+	pci_read_config_word(cpt->pdev, PCI_DEVICE_ID, &device_id);
+	pci_read_config_byte(cpt->pdev, PCI_REVISION_ID, &rev_id);
+	cpt->chip_id = (device_id << 8) | rev_id;
+	dev_dbg(dev, "CPT Chip ID: 0x%0x ", cpt->chip_id);
+
+	/*Check BIST status*/
+	bist = (uint64_t)cpt_check_bist_status(cpt);
+	if (bist) {
+		dev_err(dev, "RAM BIST failed with code 0x%llx", bist);
+		return -ENODEV;
+	}
+
+	bist = cpt_check_exe_bist_status(cpt);
+	if (bist) {
+		dev_err(dev, "Engine BIST failed with code 0x%llx", bist);
+	return -ENODEV;
+	}
+
+	/*Get CLK frequency*/
+	/*Get max enabled cores */
+	cpt_find_max_enabled_cores(cpt);
+	/*Disable all cores*/
+	cpt_disable_all_cores(cpt);
+	/*Reset device parameters*/
+	cpt->next_mc_idx   = 0;
+	cpt->next_group = 0;
+	cpt->avail_se_cores = cpt->max_se_cores;
+	cpt->avail_ae_cores = cpt->max_ae_cores;
+	/* PF is ready */
+	cpt->flags |= CPT_FLAG_DEVICE_READY;
+
+	return 0;
+}
+
+static int32_t cpt_register_interrupts(struct cpt_device *cpt)
+{
+	int32_t ret;
+	struct device *dev = &cpt->pdev->dev;
+
+	/* Enable MSI-X */
+	ret = cpt_enable_msix(cpt);
+	if (ret)
+		return ret;
+
+	/* Register mailbox interrupt handlers */
+	ret = request_irq(cpt->msix_entries[CPT_PF_INT_VEC_E_MBOXX(0)].vector,
+			  cpt_mbx0_intr_handler, 0, "CPT Mbox0", cpt);
+	if (ret)
+		goto fail;
+
+	cpt->irq_allocated[CPT_PF_INT_VEC_E_MBOXX(0)] = true;
+
+	/* Enable mailbox interrupt */
+	cpt_enable_mbox_interrupts(cpt);
+	return 0;
+
+fail:
+	dev_err(dev, "Request irq failed\n");
+	cpt_free_all_interrupts(cpt);
+	return ret;
+}
+
+static void cpt_unregister_interrupts(struct cpt_device *cpt)
+{
+	cpt_free_all_interrupts(cpt);
+	cpt_disable_msix(cpt);
+}
+
+static int32_t cpt_sriov_init(struct cpt_device *cpt, int32_t num_vfs)
+{
+	int32_t pos = 0;
+	int32_t err;
+	uint16_t total_vf_cnt;
+	struct pci_dev *pdev = cpt->pdev;
+
+	pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_SRIOV);
+	if (!pos) {
+		dev_err(&pdev->dev, "SRIOV capability is not found in PCIe config space\n");
+		return -ENODEV;
+	}
+
+	cpt->num_vf_en = num_vfs; /* User requested VFs */
+	pci_read_config_word(pdev, (pos + PCI_SRIOV_TOTAL_VF), &total_vf_cnt);
+	if (total_vf_cnt < cpt->num_vf_en)
+		cpt->num_vf_en = total_vf_cnt;
+
+	if (!total_vf_cnt)
+		return 0;
+
+	/*Enabled the available VFs */
+	err = pci_enable_sriov(pdev, cpt->num_vf_en);
+	if (err) {
+		dev_err(&pdev->dev, "SRIOV enable failed, num VF is %d\n",
+			cpt->num_vf_en);
+		cpt->num_vf_en = 0;
+		return err;
+	}
+
+	/* TODO: Optionally enable static VQ priorities feature */
+
+	dev_info(&pdev->dev, "SRIOV enabled, number of VF available %d\n",
+		 cpt->num_vf_en);
+
+	cpt->flags |= CPT_FLAG_SRIOV_ENABLED;
+
+	return 0;
+}
+
+static int32_t cpt_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
+{
+	struct device *dev = &pdev->dev;
+	struct cpt_device *cpt;
+	int32_t    err;
+
+	cpt = devm_kzalloc(dev, sizeof(struct cpt_device), GFP_KERNEL);
+	if (!cpt)
+		return -ENOMEM;
+
+	pci_set_drvdata(pdev, cpt);
+	cpt->pdev = pdev;
+	err = pci_enable_device(pdev);
+	if (err) {
+		dev_err(dev, "Failed to enable PCI device\n");
+		pci_set_drvdata(pdev, NULL);
+		return err;
+	}
+
+	err = pci_request_regions(pdev, DRV_NAME);
+	if (err) {
+		dev_err(dev, "PCI request regions failed 0x%x\n", err);
+		goto cpt_err_disable_device;
+	}
+
+	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(48));
+	if (err) {
+		dev_err(dev, "Unable to get usable DMA configuration\n");
+		goto cpt_err_release_regions;
+	}
+
+	err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(48));
+	if (err) {
+		dev_err(dev, "Unable to get 48-bit DMA for consistent allocations\n");
+		goto cpt_err_release_regions;
+	}
+
+	/* MAP PF's configuration registers */
+	cpt->reg_base = pcim_iomap(pdev, CPT_CSR_BAR, 0);
+	if (!cpt->reg_base) {
+		dev_err(dev, "Cannot map config register space, aborting\n");
+		err = -ENOMEM;
+		goto cpt_err_release_regions;
+	}
+
+	/* CPT device HW initialization */
+	cpt_device_init(cpt);
+
+	/* Register interrupts */
+	err = cpt_register_interrupts(cpt);
+	if (err)
+		goto cpt_err_release_regions;
+
+	err = cpt_ucode_load(cpt);
+	if (err)
+		goto cpt_err_unregister_interrupts;
+
+	/* Configure SRIOV */
+	err = cpt_sriov_init(cpt, num_vfs);
+	if (err)
+		goto cpt_err_unregister_interrupts;
+
+	/* Add device to global device list */
+	cpt_add_device(&cpt_dev_list, cpt);
+
+	return 0;
+
+cpt_err_unregister_interrupts:
+	cpt_unregister_interrupts(cpt);
+cpt_err_release_regions:
+	pci_release_regions(pdev);
+cpt_err_disable_device:
+	pci_disable_device(pdev);
+	pci_set_drvdata(pdev, NULL);
+	return err;
+}
+
+static void cpt_remove(struct pci_dev *pdev)
+{
+	struct cpt_device *cpt = pci_get_drvdata(pdev);
+
+	/* Disengage SE and AE cores from all groups*/
+	cpt_disable_all_cores(cpt);
+	/* Unload microcodes */
+	cpt_unload_microcode(cpt);
+	cpt_unregister_interrupts(cpt);
+	pci_disable_sriov(pdev);
+	pci_release_regions(pdev);
+	pci_disable_device(pdev);
+	pci_set_drvdata(pdev, NULL);
+}
+
+static void cpt_shutdown(struct pci_dev *pdev)
+{
+	struct cpt_device *cpt = pci_get_drvdata(pdev);
+
+	if (!cpt)
+		return;
+
+	dev_info(&pdev->dev, "Shutdown device %x:%x.\n",
+		 (uint32_t)pdev->vendor, (uint32_t)pdev->device);
+
+	cpt_unregister_interrupts(cpt);
+	pci_release_regions(pdev);
+	pci_disable_device(pdev);
+	pci_set_drvdata(pdev, NULL);
+	kzfree(cpt);
+}
+
+/* Supported devices */
+static const struct pci_device_id cpt_id_table[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_CAVIUM, CPT_81XX_PCI_PF_DEVICE_ID) },
+	{ 0, }  /* end of table */
+};
+
+static struct pci_driver cpt_pci_driver = {
+	.name = DRV_NAME,
+	.id_table = cpt_id_table,
+	.probe = cpt_probe,
+	.remove = cpt_remove,
+	.shutdown = cpt_shutdown,
+};
+
+static int32_t __init cpt_init_module(void)
+{
+	int32_t ret = -1;
+
+	pr_info("%s, ver %s\n", DRV_NAME, DRV_VERSION);
+
+	if (num_vfs > 16) {
+		pr_warn("Invalid vf count %d, Resetting it to 1(default)\n",
+			num_vfs);
+		num_vfs = 1;
+	}
+
+	cpt_init_device_list(&cpt_dev_list);
+	ret = pci_register_driver(&cpt_pci_driver);
+	if (ret)
+		pr_err("pci_register_driver() failed");
+
+	return ret;
+}
+
+static void __exit cpt_cleanup_module(void)
+{
+	pci_unregister_driver(&cpt_pci_driver);
+}
+
+module_init(cpt_init_module);
+module_exit(cpt_cleanup_module);
+
+MODULE_AUTHOR("George Cherian <george.cherian@cavium.com>, Murthy Nidadavolu");
+MODULE_DESCRIPTION("Cavium Thunder CPT Physical Function Driver");
+MODULE_LICENSE("GPL v2");
+MODULE_VERSION(DRV_VERSION);
+MODULE_DEVICE_TABLE(pci, cpt_id_table);
diff --git a/drivers/crypto/cavium/cpt/cpt_pf_mbox.c b/drivers/crypto/cavium/cpt/cpt_pf_mbox.c
new file mode 100644
index 0000000..7ed2d9c
--- /dev/null
+++ b/drivers/crypto/cavium/cpt/cpt_pf_mbox.c
@@ -0,0 +1,174 @@
+/*
+ * Copyright (C) 2016 Cavium, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License
+ * as published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+
+#include "cpt.h"
+
+static void cpt_send_msg_to_vf(struct cpt_device *cpt, int vf,
+			       struct cpt_mbox *mbx)
+{
+	/* Writing mbox(0) causes interrupt */
+	cpt_write_csr64(cpt->reg_base, CPTX_PF_VFX_MBOXX(0, vf, 1),
+			mbx->data);
+	cpt_write_csr64(cpt->reg_base, CPTX_PF_VFX_MBOXX(0, vf, 0), mbx->msg);
+}
+
+/* ACKs VF's mailbox message
+ * @vf: VF to which ACK to be sent
+ */
+static void cpt_mbox_send_ack(struct cpt_device *cpt, int vf,
+			      struct cpt_mbox *mbx)
+{
+	mbx->data = 0ull;
+	mbx->msg = CPT_MBOX_MSG_TYPE_ACK;
+	cpt_send_msg_to_vf(cpt, vf, mbx);
+}
+
+static void cpt_clear_mbox_intr(struct cpt_device *cpt, uint32_t vf)
+{
+	/* W1C for the VF */
+	cpt_write_csr64(cpt->reg_base, CPTX_PF_MBOX_INTX(0, 0), (1 << vf));
+}
+
+/*
+ *  Configure QLEN/Chunk sizes for VF
+ */
+static void cpt_cfg_qlen_for_vf(struct cpt_device *cpt, int vf, uint32_t size)
+{
+	union cptx_pf_qx_ctl pf_qx_ctl;
+
+	pf_qx_ctl.u = cpt_read_csr64(cpt->reg_base, CPTX_PF_QX_CTL(0, vf));
+	pf_qx_ctl.s.size = size;
+	pf_qx_ctl.s.cont_err = true;
+	cpt_write_csr64(cpt->reg_base, CPTX_PF_QX_CTL(0, vf), pf_qx_ctl.u);
+}
+
+/*
+ * Configure VQ priority
+ */
+static void cpt_cfg_vq_priority(struct cpt_device *cpt, int vf, uint32_t pri)
+{
+	union cptx_pf_qx_ctl pf_qx_ctl;
+
+	pf_qx_ctl.u = cpt_read_csr64(cpt->reg_base, CPTX_PF_QX_CTL(0, vf));
+	pf_qx_ctl.s.pri = pri;
+	cpt_write_csr64(cpt->reg_base, CPTX_PF_QX_CTL(0, vf), pf_qx_ctl.u);
+}
+
+static uint8_t cpt_bind_vq_to_grp(struct cpt_device *cpt, uint8_t q,
+				  uint8_t grp)
+{
+	struct microcode *mcode = cpt->mcode;
+	union cptx_pf_qx_ctl pf_qx_ctl;
+	struct device *dev = &cpt->pdev->dev;
+
+	if (q >= CPT_MAX_VQ_NUM) {
+		dev_err(dev, "Queues are more than cores in the group");
+		return -EINVAL;
+	}
+	if (grp >= CPT_MAX_CORE_GROUPS) {
+		dev_err(dev, "Request group is more than possible groups");
+		return -EINVAL;
+	}
+	if (grp >= cpt->next_mc_idx) {
+		dev_err(dev, "Request group is higher than available functional groups");
+		return -EINVAL;
+	}
+	pf_qx_ctl.u = cpt_read_csr64(cpt->reg_base, CPTX_PF_QX_CTL(0, q));
+	pf_qx_ctl.s.grp = mcode[grp].group;
+	cpt_write_csr64(cpt->reg_base, CPTX_PF_QX_CTL(0, q), pf_qx_ctl.u);
+	dev_dbg(dev, "VF %d TYPE %s", q, (mcode[grp].is_ae ? "AE" : "SE"));
+
+	return mcode[grp].is_ae ? AE_TYPES : SE_TYPES;
+}
+
+/* Interrupt handler to handle mailbox messages from VFs */
+static void cpt_handle_mbox_intr(struct cpt_device *cpt, int vf)
+{
+	struct cpt_vf_info *vfx = &cpt->vfinfo[vf];
+	struct cpt_mbox mbx = {};
+	union cpt_chipid_vfid chipid_vfid;
+	uint8_t vftype;
+	struct device *dev = &cpt->pdev->dev;
+	/* Take mbox lock */
+	cpt->mbx_lock[vf] = true;
+	/*
+	 * MBOX[0] contains msg
+	 * MBOX[1] contains data
+	 */
+	mbx.msg  = cpt_read_csr64(cpt->reg_base, CPTX_PF_VFX_MBOXX(0, vf, 0));
+	mbx.data = cpt_read_csr64(cpt->reg_base, CPTX_PF_VFX_MBOXX(0, vf, 1));
+	dev_dbg(dev, "%s: Mailbox msg 0x%llx from VF%d", __func__, mbx.msg, vf);
+	switch (mbx.msg) {
+	case CPT_MSG_VF_UP:
+		vfx->state = VF_STATE_UP;
+		try_module_get(THIS_MODULE);
+		cpt_mbox_send_ack(cpt, vf, &mbx);
+		break;
+	case CPT_MSG_READY:
+		chipid_vfid.u16 = 0;
+		chipid_vfid.s.chip_id = cpt->chip_id;
+		chipid_vfid.s.vfid = vf;
+		mbx.msg  = CPT_MSG_READY;
+		mbx.data = chipid_vfid.u16;
+		cpt_send_msg_to_vf(cpt, vf, &mbx);
+		break;
+	case CPT_MSG_VF_DOWN:
+		/* First msg in VF teardown sequence */
+		vfx->state = VF_STATE_DOWN;
+		module_put(THIS_MODULE);
+		cpt_mbox_send_ack(cpt, vf, &mbx);
+		break;
+	case CPT_MSG_QLEN:
+		vfx->qlen = mbx.data;
+		cpt_cfg_qlen_for_vf(cpt, vf, vfx->qlen);
+		cpt_mbox_send_ack(cpt, vf, &mbx);
+		break;
+	case CPT_MSG_QBIND_GRP:
+		vftype = cpt_bind_vq_to_grp(cpt, vf, (uint8_t)mbx.data);
+		if ((vftype != AE_TYPES) && (vftype != SE_TYPES))
+			dev_err(dev, "Queue %d binding to group %llu failed",
+				vf, mbx.data);
+		else {
+			dev_dbg(dev, "Queue %d binding to group %llu successful",
+				vf, mbx.data);
+			mbx.msg = CPT_MSG_QBIND_GRP;
+			mbx.data = vftype;
+			cpt_send_msg_to_vf(cpt, vf, &mbx);
+		}
+		break;
+	case CPT_MSG_VQ_PRIORITY:
+		vfx->priority = mbx.data;
+		cpt_cfg_vq_priority(cpt, vf, vfx->priority);
+		cpt_mbox_send_ack(cpt, vf, &mbx);
+		break;
+	default:
+		dev_err(&cpt->pdev->dev, "Invalid msg from VF%d, msg 0x%llx\n",
+			vf, mbx.msg);
+		break;
+	}
+	/* Unlock mailbox */
+	cpt->mbx_lock[vf] = false;
+}
+
+void cpt_mbox_intr_handler (struct cpt_device *cpt, int mbx)
+{
+	uint64_t intr;
+	uint8_t  vf;
+
+	intr = cpt_read_csr64(cpt->reg_base, CPTX_PF_MBOX_INTX(0, 0));
+	dev_dbg(&cpt->pdev->dev, "PF interrupt Mbox%d 0x%llx\n", mbx, intr);
+	for (vf = 0; vf < CPT_MAX_VF_NUM; vf++) {
+		if (intr & (1ULL << vf)) {
+			dev_dbg(&cpt->pdev->dev, "Intr from VF %d\n", vf);
+			cpt_handle_mbox_intr(cpt, vf);
+			cpt_clear_mbox_intr(cpt, vf);
+		}
+	}
+}
-- 
2.1.4
