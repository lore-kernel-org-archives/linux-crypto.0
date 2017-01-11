From: George Cherian <george.cherian@cavium.com>
Subject: [PATCH v4 1/3] drivers: crypto: Add Support for Octeon-tx CPT Engine
Date: Wed, 11 Jan 2017 10:56:49 +0000
Message-ID: <1484132211-917-2-git-send-email-george.cherian@cavium.com>
References: <1484132211-917-1-git-send-email-george.cherian@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <david.daney@cavium.com>, <clabbe.montjoie@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        George Cherian <george.cherian@cavium.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1484132211-917-1-git-send-email-george.cherian@cavium.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Enable the Physical Function driver for the Cavium Crypto Engine (CPT)
found in Octeon-tx series of SoC's. CPT is the Cryptographic Accelaration
Unit. CPT includes microcoded GigaCypher symmetric engines (SEs) and
asymmetric engines (AEs).

Signed-off-by: George Cherian <george.cherian@cavium.com>
Reviewed-by: David Daney <david.daney@cavium.com>
---
 drivers/crypto/cavium/cpt/Kconfig        |  16 +
 drivers/crypto/cavium/cpt/Makefile       |   2 +
 drivers/crypto/cavium/cpt/cpt_common.h   | 158 +++++++
 drivers/crypto/cavium/cpt/cpt_hw_types.h | 658 ++++++++++++++++++++++++++++
 drivers/crypto/cavium/cpt/cptpf.h        |  69 +++
 drivers/crypto/cavium/cpt/cptpf_main.c   | 708 +++++++++++++++++++++++++++++++
 drivers/crypto/cavium/cpt/cptpf_mbox.c   | 163 +++++++
 7 files changed, 1774 insertions(+)
 create mode 100644 drivers/crypto/cavium/cpt/Kconfig
 create mode 100644 drivers/crypto/cavium/cpt/Makefile
 create mode 100644 drivers/crypto/cavium/cpt/cpt_common.h
 create mode 100644 drivers/crypto/cavium/cpt/cpt_hw_types.h
 create mode 100644 drivers/crypto/cavium/cpt/cptpf.h
 create mode 100644 drivers/crypto/cavium/cpt/cptpf_main.c
 create mode 100644 drivers/crypto/cavium/cpt/cptpf_mbox.c

diff --git a/drivers/crypto/cavium/cpt/Kconfig b/drivers/crypto/cavium/cpt/Kconfig
new file mode 100644
index 0000000..1f6ace3
--- /dev/null
+++ b/drivers/crypto/cavium/cpt/Kconfig
@@ -0,0 +1,16 @@
+#
+# Cavium crypto device configuration
+#
+
+config CRYPTO_DEV_CPT
+	tristate
+
+config CAVIUM_CPT
+	tristate "Cavium Cryptographic Accelerator driver"
+	depends on ARCH_THUNDER || COMPILE_TEST
+	select CRYPTO_DEV_CPT
+	help
+	  Support for Cavium CPT block found in octeon-tx series of
+	  processors.
+
+	  To compile this as a module, choose M here.
diff --git a/drivers/crypto/cavium/cpt/Makefile b/drivers/crypto/cavium/cpt/Makefile
new file mode 100644
index 0000000..fe3d454
--- /dev/null
+++ b/drivers/crypto/cavium/cpt/Makefile
@@ -0,0 +1,2 @@
+obj-$(CONFIG_CAVIUM_CPT) += cptpf.o
+cptpf-objs := cptpf_main.o cptpf_mbox.o
diff --git a/drivers/crypto/cavium/cpt/cpt_common.h b/drivers/crypto/cavium/cpt/cpt_common.h
new file mode 100644
index 0000000..ede612f
--- /dev/null
+++ b/drivers/crypto/cavium/cpt/cpt_common.h
@@ -0,0 +1,158 @@
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
+#include <linux/delay.h>
+#include <linux/pci.h>
+
+#include "cpt_hw_types.h"
+
+/* Device ID */
+#define CPT_81XX_PCI_PF_DEVICE_ID 0xa040
+#define CPT_81XX_PCI_VF_DEVICE_ID 0xa041
+
+/* flags to indicate the features supported */
+#define CPT_FLAG_MSIX_ENABLED BIT(0)
+#define CPT_FLAG_SRIOV_ENABLED BIT(1)
+#define CPT_FLAG_VF_DRIVER BIT(2)
+#define CPT_FLAG_DEVICE_READY BIT(3)
+
+#define cpt_msix_enabled(cpt) ((cpt)->flags & CPT_FLAG_MSIX_ENABLED)
+#define cpt_sriov_enabled(cpt) ((cpt)->flags & CPT_FLAG_SRIOV_ENABLED)
+#define cpt_vf_driver(cpt) ((cpt)->flags & CPT_FLAG_VF_DRIVER)
+#define cpt_device_ready(cpt) ((cpt)->flags & CPT_FLAG_DEVICE_READY)
+
+#define CPT_MBOX_MSG_TYPE_ACK 1
+#define CPT_MBOX_MSG_TYPE_NACK 2
+#define CPT_MBOX_MSG_TIMEOUT 2000
+#define VF_STATE_DOWN 0
+#define VF_STATE_UP 1
+
+/*
+ * CPT Registers map for 81xx
+ */
+
+/* PF registers */
+#define CPTX_PF_CONSTANTS(a) (0x0ll + ((u64)(a) << 36))
+#define CPTX_PF_RESET(a) (0x100ll + ((u64)(a) << 36))
+#define CPTX_PF_DIAG(a) (0x120ll + ((u64)(a) << 36))
+#define CPTX_PF_BIST_STATUS(a) (0x160ll + ((u64)(a) << 36))
+#define CPTX_PF_ECC0_CTL(a) (0x200ll + ((u64)(a) << 36))
+#define CPTX_PF_ECC0_FLIP(a) (0x210ll + ((u64)(a) << 36))
+#define CPTX_PF_ECC0_INT(a) (0x220ll + ((u64)(a) << 36))
+#define CPTX_PF_ECC0_INT_W1S(a) (0x230ll + ((u64)(a) << 36))
+#define CPTX_PF_ECC0_ENA_W1S(a)	(0x240ll + ((u64)(a) << 36))
+#define CPTX_PF_ECC0_ENA_W1C(a)	(0x250ll + ((u64)(a) << 36))
+#define CPTX_PF_MBOX_INTX(a, b)	\
+	(0x400ll + ((u64)(a) << 36) + ((b) << 3))
+#define CPTX_PF_MBOX_INT_W1SX(a, b) \
+	(0x420ll + ((u64)(a) << 36) + ((b) << 3))
+#define CPTX_PF_MBOX_ENA_W1CX(a, b) \
+	(0x440ll + ((u64)(a) << 36) + ((b) << 3))
+#define CPTX_PF_MBOX_ENA_W1SX(a, b) \
+	(0x460ll + ((u64)(a) << 36) + ((b) << 3))
+#define CPTX_PF_EXEC_INT(a) (0x500ll + 0x1000000000ll * ((a) & 0x1))
+#define CPTX_PF_EXEC_INT_W1S(a)	(0x520ll + ((u64)(a) << 36))
+#define CPTX_PF_EXEC_ENA_W1C(a)	(0x540ll + ((u64)(a) << 36))
+#define CPTX_PF_EXEC_ENA_W1S(a)	(0x560ll + ((u64)(a) << 36))
+#define CPTX_PF_GX_EN(a, b) \
+	(0x600ll + ((u64)(a) << 36) + ((b) << 3))
+#define CPTX_PF_EXEC_INFO(a) (0x700ll + ((u64)(a) << 36))
+#define CPTX_PF_EXEC_BUSY(a) (0x800ll + ((u64)(a) << 36))
+#define CPTX_PF_EXEC_INFO0(a) (0x900ll + ((u64)(a) << 36))
+#define CPTX_PF_EXEC_INFO1(a) (0x910ll + ((u64)(a) << 36))
+#define CPTX_PF_INST_REQ_PC(a) (0x10000ll + ((u64)(a) << 36))
+#define CPTX_PF_INST_LATENCY_PC(a) \
+	(0x10020ll + ((u64)(a) << 36))
+#define CPTX_PF_RD_REQ_PC(a) (0x10040ll + ((u64)(a) << 36))
+#define CPTX_PF_RD_LATENCY_PC(a) (0x10060ll + ((u64)(a) << 36))
+#define CPTX_PF_RD_UC_PC(a) (0x10080ll + ((u64)(a) << 36))
+#define CPTX_PF_ACTIVE_CYCLES_PC(a) (0x10100ll + ((u64)(a) << 36))
+#define CPTX_PF_EXE_CTL(a) (0x4000000ll + ((u64)(a) << 36))
+#define CPTX_PF_EXE_STATUS(a) (0x4000008ll + ((u64)(a) << 36))
+#define CPTX_PF_EXE_CLK(a) (0x4000010ll + ((u64)(a) << 36))
+#define CPTX_PF_EXE_DBG_CTL(a) (0x4000018ll + ((u64)(a) << 36))
+#define CPTX_PF_EXE_DBG_DATA(a)	(0x4000020ll + ((u64)(a) << 36))
+#define CPTX_PF_EXE_BIST_STATUS(a) (0x4000028ll + ((u64)(a) << 36))
+#define CPTX_PF_EXE_REQ_TIMER(a) (0x4000030ll + ((u64)(a) << 36))
+#define CPTX_PF_EXE_MEM_CTL(a) (0x4000038ll + ((u64)(a) << 36))
+#define CPTX_PF_EXE_PERF_CTL(a)	(0x4001000ll + ((u64)(a) << 36))
+#define CPTX_PF_EXE_DBG_CNTX(a, b) \
+	(0x4001100ll + ((u64)(a) << 36) + ((b) << 3))
+#define CPTX_PF_EXE_PERF_EVENT_CNT(a) (0x4001180ll + ((u64)(a) << 36))
+#define CPTX_PF_EXE_EPCI_INBX_CNT(a, b) \
+	(0x4001200ll + ((u64)(a) << 36) + ((b) << 3))
+#define CPTX_PF_EXE_EPCI_OUTBX_CNT(a, b) \
+	(0x4001240ll + ((u64)(a) << 36) + ((b) << 3))
+#define CPTX_PF_ENGX_UCODE_BASE(a, b) \
+	(0x4002000ll + ((u64)(a) << 36) + ((b) << 3))
+#define CPTX_PF_QX_CTL(a, b) \
+	(0x8000000ll + ((u64)(a) << 36) + ((b) << 20))
+#define CPTX_PF_QX_GMCTL(a, b) \
+	(0x8000020ll + ((u64)(a) << 36) + ((b) << 20))
+#define CPTX_PF_QX_CTL2(a, b) \
+	(0x8000100ll + ((u64)(a) << 36) + ((b) << 20))
+#define CPTX_PF_VFX_MBOXX(a, b, c) \
+	(0x8001000ll + ((u64)(a) << 36) + ((b) << 20) + ((c) << 8))
+
+/* VF registers */
+#define CPTX_VQX_CTL(a, b) (0x100ll + ((u64)(a) << 36) + ((b) << 20))
+#define CPTX_VQX_SADDR(a, b) (0x200ll + ((u64)(a) << 36) + ((b) << 20))
+#define CPTX_VQX_DONE_WAIT(a, b) (0x400ll + ((u64)(a) << 36) + ((b) << 20))
+#define CPTX_VQX_INPROG(a, b) (0x410ll + ((u64)(a) << 36) + ((b) << 20))
+#define CPTX_VQX_DONE(a, b) (0x420ll + ((u64)(a) << 36) + ((b) << 20))
+#define CPTX_VQX_DONE_ACK(a, b) (0x440ll + ((u64)(a) << 36) + ((b) << 20))
+#define CPTX_VQX_DONE_INT_W1S(a, b) (0x460ll + ((u64)(a) << 36) + ((b) << 20))
+#define CPTX_VQX_DONE_INT_W1C(a, b) (0x468ll + ((u64)(a) << 36) + ((b) << 20))
+#define CPTX_VQX_DONE_ENA_W1S(a, b) (0x470ll + ((u64)(a) << 36) + ((b) << 20))
+#define CPTX_VQX_DONE_ENA_W1C(a, b) (0x478ll + ((u64)(a) << 36) + ((b) << 20))
+#define CPTX_VQX_MISC_INT(a, b)	(0x500ll + ((u64)(a) << 36) + ((b) << 20))
+#define CPTX_VQX_MISC_INT_W1S(a, b) (0x508ll + ((u64)(a) << 36) + ((b) << 20))
+#define CPTX_VQX_MISC_ENA_W1S(a, b) (0x510ll + ((u64)(a) << 36) + ((b) << 20))
+#define CPTX_VQX_MISC_ENA_W1C(a, b) (0x518ll + ((u64)(a) << 36) + ((b) << 20))
+#define CPTX_VQX_DOORBELL(a, b) (0x600ll + ((u64)(a) << 36) + ((b) << 20))
+#define CPTX_VFX_PF_MBOXX(a, b, c) \
+	(0x1000ll + ((u64)(a) << 36) + ((b) << 20) + ((c) << 3))
+
+enum vftype {
+	AE_TYPES = 1,
+	SE_TYPES = 2,
+	BAD_CPT_TYPES,
+};
+
+/* Max CPT devices supported */
+enum cpt_mbox_opcode {
+	CPT_MSG_VF_UP = 1,
+	CPT_MSG_VF_DOWN,
+	CPT_MSG_READY,
+	CPT_MSG_QLEN,
+	CPT_MSG_QBIND_GRP,
+	CPT_MSG_VQ_PRIORITY,
+};
+
+/* CPT mailbox structure */
+struct cpt_mbox {
+	u64 msg; /* Message type MBOX[0] */
+	u64 data;/* Data         MBOX[1] */
+};
+
+/* Register read/write APIs */
+static inline void cpt_write_csr64(u8 __iomem *hw_addr, u64 offset,
+				   u64 val)
+{
+	writeq(val, hw_addr + offset);
+}
+
+static inline u64 cpt_read_csr64(u8 __iomem *hw_addr, u64 offset)
+{
+	return readq(hw_addr + offset);
+}
+#endif /* __CPT_COMMON_H */
diff --git a/drivers/crypto/cavium/cpt/cpt_hw_types.h b/drivers/crypto/cavium/cpt/cpt_hw_types.h
new file mode 100644
index 0000000..2796694
--- /dev/null
+++ b/drivers/crypto/cavium/cpt/cpt_hw_types.h
@@ -0,0 +1,658 @@
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
+ * res_addr [127: 64] Result IOVA.
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
+ *  wq_ptr [255:192] If [WQ_PTR] is nonzero, it is a pointer to a
+ *	work-queue entry that CPT submits work to SSO after all context,
+ *	output data, and result write operations are visible to other
+ *	CNXXXX units and the cores. Bits <2:0> must be zero.
+ *	Bits <63:49> are ignored by hardware; software should
+ *	use a sign-extended bit <48> for forward compatibility.
+ *	Internal:
+ *	Bits <63:49>, <2:0> are ignored by hardware, treated as always 0x0.
+ * Word 4
+ *  ei0; [319:256] Engine instruction word 0. Passed to the AE/SE.
+ * Word 5
+ *  ei1; [383:320] Engine instruction word 1. Passed to the AE/SE.
+ * Word 6
+ *  ei2; [447:384] Engine instruction word 1. Passed to the AE/SE.
+ * Word 7
+ *  ei3; [511:448] Engine instruction word 1. Passed to the AE/SE.
+ *
+ */
+union cpt_inst_s {
+	u64 u[8];
+	struct cpt_inst_s_s {
+#if defined(__BIG_ENDIAN_BITFIELD) /* Word 0 - Big Endian */
+		u64 reserved_17_63:47;
+		u64 doneint:1;
+		u64 reserved_0_1:16;
+#else /* Word 0 - Little Endian */
+		u64 reserved_0_15:16;
+		u64 doneint:1;
+		u64 reserved_17_63:47;
+#endif /* Word 0 - End */
+		u64 res_addr;
+#if defined(__BIG_ENDIAN_BITFIELD) /* Word 2 - Big Endian */
+		u64 reserved_172_19:20;
+		u64 grp:10;
+		u64 tt:2;
+		u64 tag:32;
+#else /* Word 2 - Little Endian */
+		u64 tag:32;
+		u64 tt:2;
+		u64 grp:10;
+		u64 reserved_172_191:20;
+#endif /* Word 2 - End */
+		u64 wq_ptr;
+		u64 ei0;
+		u64 ei1;
+		u64 ei2;
+		u64 ei3;
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
+	u64 u[2];
+	struct cpt_res_s_s {
+#if defined(__BIG_ENDIAN_BITFIELD) /* Word 0 - Big Endian */
+		u64 reserved_17_63:47;
+		u64 doneint:1;
+		u64 reserved_8_15:8;
+		u64 compcode:8;
+#else /* Word 0 - Little Endian */
+		u64 compcode:8;
+		u64 reserved_8_15:8;
+		u64 doneint:1;
+		u64 reserved_17_63:47;
+#endif /* Word 0 - End */
+		u64 reserved_64_127;
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
+	u64 u;
+	struct cptx_pf_bist_status_s {
+#if defined(__BIG_ENDIAN_BITFIELD) /* Word 0 - Big Endian */
+		u64 reserved_30_63:34;
+		u64 bstatus:30;
+#else /* Word 0 - Little Endian */
+		u64 bstatus:30;
+		u64 reserved_30_63:34;
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
+ */
+union cptx_pf_constants {
+	u64 u;
+	struct cptx_pf_constants_s {
+#if defined(__BIG_ENDIAN_BITFIELD) /* Word 0 - Big Endian */
+		u64 reserved_40_63:24;
+		u64 epcis:8;
+		u64 grps:8;
+		u64 ae:8;
+		u64 se:8;
+		u64 vq:8;
+#else /* Word 0 - Little Endian */
+		u64 vq:8;
+		u64 se:8;
+		u64 ae:8;
+		u64 grps:8;
+		u64 epcis:8;
+		u64 reserved_40_63:24;
+#endif /* Word 0 - End */
+	} s;
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
+	u64 u;
+	struct cptx_pf_exe_bist_status_s {
+#if defined(__BIG_ENDIAN_BITFIELD) /* Word 0 - Big Endian */
+		u64 reserved_48_63:16;
+		u64 bstatus:48;
+#else /* Word 0 - Little Endian */
+		u64 bstatus:48;
+		u64 reserved_48_63:16;
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
+	u64 u;
+	struct cptx_pf_qx_ctl_s {
+#if defined(__BIG_ENDIAN_BITFIELD) /* Word 0 - Big Endian */
+		u64 reserved_60_63:4;
+		u64 aura:12;
+		u64 reserved_45_47:3;
+		u64 size:13;
+		u64 reserved_11_31:21;
+		u64 cont_err:1;
+		u64 inst_free:1;
+		u64 inst_be:1;
+		u64 iqb_ldwb:1;
+		u64 reserved_4_6:3;
+		u64 grp:3;
+		u64 pri:1;
+#else /* Word 0 - Little Endian */
+		u64 pri:1;
+		u64 grp:3;
+		u64 reserved_4_6:3;
+		u64 iqb_ldwb:1;
+		u64 inst_be:1;
+		u64 inst_free:1;
+		u64 cont_err:1;
+		u64 reserved_11_31:21;
+		u64 size:13;
+		u64 reserved_45_47:3;
+		u64 aura:12;
+		u64 reserved_60_63:4;
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
+	u64 u;
+	struct cptx_vqx_saddr_s {
+#if defined(__BIG_ENDIAN_BITFIELD) /* Word 0 - Big Endian */
+		u64 reserved_49_63:15;
+		u64 ptr:43;
+		u64 reserved_0_5:6;
+#else /* Word 0 - Little Endian */
+		u64 reserved_0_5:6;
+		u64 ptr:43;
+		u64 reserved_49_63:15;
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
+	u64 u;
+	struct cptx_vqx_misc_ena_w1s_s {
+#if defined(__BIG_ENDIAN_BITFIELD) /* Word 0 - Big Endian */
+		u64 reserved_5_63:59;
+		u64 swerr:1;
+		u64 nwrp:1;
+		u64 irde:1;
+		u64 dovf:1;
+		u64 mbox:1;
+#else /* Word 0 - Little Endian */
+		u64 mbox:1;
+		u64 dovf:1;
+		u64 irde:1;
+		u64 nwrp:1;
+		u64 swerr:1;
+		u64 reserved_5_63:59;
+#endif /* Word 0 - End */
+	} s;
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
+	u64 u;
+	struct cptx_vqx_doorbell_s {
+#if defined(__BIG_ENDIAN_BITFIELD) /* Word 0 - Big Endian */
+		u64 reserved_20_63:44;
+		u64 dbell_cnt:20;
+#else /* Word 0 - Little Endian */
+		u64 dbell_cnt:20;
+		u64 reserved_20_63:44;
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
+	u64 u;
+	struct cptx_vqx_inprog_s {
+#if defined(__BIG_ENDIAN_BITFIELD) /* Word 0 - Big Endian */
+		u64 reserved_8_63:56;
+		u64 inflight:8;
+#else /* Word 0 - Little Endian */
+		u64 inflight:8;
+		u64 reserved_8_63:56;
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
+	u64 u;
+	struct cptx_vqx_misc_int_s {
+#if defined(__BIG_ENDIAN_BITFIELD) /* Word 0 - Big Endian */
+		u64 reserved_5_63:59;
+		u64 swerr:1;
+		u64 nwrp:1;
+		u64 irde:1;
+		u64 dovf:1;
+		u64 mbox:1;
+#else /* Word 0 - Little Endian */
+		u64 mbox:1;
+		u64 dovf:1;
+		u64 irde:1;
+		u64 nwrp:1;
+		u64 swerr:1;
+		u64 reserved_5_63:59;
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
+	u64 u;
+	struct cptx_vqx_done_ack_s {
+#if defined(__BIG_ENDIAN_BITFIELD) /* Word 0 - Big Endian */
+		u64 reserved_20_63:44;
+		u64 done_ack:20;
+#else /* Word 0 - Little Endian */
+		u64 done_ack:20;
+		u64 reserved_20_63:44;
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
+	u64 u;
+	struct cptx_vqx_done_s {
+#if defined(__BIG_ENDIAN_BITFIELD) /* Word 0 - Big Endian */
+		u64 reserved_20_63:44;
+		u64 done:20;
+#else /* Word 0 - Little Endian */
+		u64 done:20;
+		u64 reserved_20_63:44;
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
+	u64 u;
+	struct cptx_vqx_done_wait_s {
+#if defined(__BIG_ENDIAN_BITFIELD) /* Word 0 - Big Endian */
+		u64 reserved_48_63:16;
+		u64 time_wait:16;
+		u64 reserved_20_31:12;
+		u64 num_wait:20;
+#else /* Word 0 - Little Endian */
+		u64 num_wait:20;
+		u64 reserved_20_31:12;
+		u64 time_wait:16;
+		u64 reserved_48_63:16;
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
+	u64 u;
+	struct cptx_vqx_done_ena_w1s_s {
+#if defined(__BIG_ENDIAN_BITFIELD) /* Word 0 - Big Endian */
+		u64 reserved_1_63:63;
+		u64 done:1;
+#else /* Word 0 - Little Endian */
+		u64 done:1;
+		u64 reserved_1_63:63;
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
+	u64 u;
+	struct cptx_vqx_ctl_s {
+#if defined(__BIG_ENDIAN_BITFIELD) /* Word 0 - Big Endian */
+		u64 reserved_1_63:63;
+		u64 ena:1;
+#else /* Word 0 - Little Endian */
+		u64 ena:1;
+		u64 reserved_1_63:63;
+#endif /* Word 0 - End */
+	} s;
+};
+#endif /*__CPT_HW_TYPES_H*/
diff --git a/drivers/crypto/cavium/cpt/cptpf.h b/drivers/crypto/cavium/cpt/cptpf.h
new file mode 100644
index 0000000..8a2a8e5
--- /dev/null
+++ b/drivers/crypto/cavium/cpt/cptpf.h
@@ -0,0 +1,69 @@
+/*
+ * Copyright (C) 2016 Cavium, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License
+ * as published by the Free Software Foundation.
+ */
+
+#ifndef __CPTPF_H
+#define __CPTPF_H
+
+#include "cpt_common.h"
+
+#define CSR_DELAY 30
+#define CPT_MAX_CORE_GROUPS 8
+#define CPT_MAX_SE_CORES 10
+#define CPT_MAX_AE_CORES 6
+#define CPT_MAX_TOTAL_CORES (CPT_MAX_SE_CORES + CPT_MAX_AE_CORES)
+#define CPT_MAX_VF_NUM 16
+#define	CPT_PF_MSIX_VECTORS 3
+#define CPT_PF_INT_VEC_E_MBOXX(a) (0x02 + (a))
+#define CPT_UCODE_VERSION_SZ 32
+struct cpt_device;
+
+struct microcode {
+	u8 is_mc_valid;
+	u8 is_ae;
+	u8 group;
+	u8 num_cores;
+	u32 code_size;
+	u64 core_mask;
+	u8 version[CPT_UCODE_VERSION_SZ];
+	/* Base info */
+	dma_addr_t phys_base;
+	void *code;
+};
+
+struct cpt_vf_info {
+	u8 state;
+	u8 priority;
+	u8 id;
+	u32 qlen;
+};
+
+/**
+ * cpt device structure
+ */
+struct cpt_device {
+	u16 flags;	/* Flags to hold device status bits */
+	u8 num_vf_en; /* Number of VFs enabled (0...CPT_MAX_VF_NUM) */
+	struct cpt_vf_info vfinfo[CPT_MAX_VF_NUM]; /* Per VF info */
+
+	void __iomem *reg_base; /* Register start address */
+	/* MSI-X */
+	u8 num_vec;
+	bool msix_enabled;
+	struct msix_entry msix_entries[CPT_PF_MSIX_VECTORS];
+	bool irq_allocated[CPT_PF_MSIX_VECTORS];
+	struct pci_dev *pdev; /* pci device handle */
+
+	struct microcode mcode[CPT_MAX_CORE_GROUPS];
+	u8 next_mc_idx; /* next microcode index */
+	u8 next_group;
+	u8 max_se_cores;
+	u8 max_ae_cores;
+};
+
+void cpt_mbox_intr_handler(struct cpt_device *cpt, int mbx);
+#endif /* __CPTPF_H */
diff --git a/drivers/crypto/cavium/cpt/cptpf_main.c b/drivers/crypto/cavium/cpt/cptpf_main.c
new file mode 100644
index 0000000..e1573c4
--- /dev/null
+++ b/drivers/crypto/cavium/cpt/cptpf_main.c
@@ -0,0 +1,708 @@
+/*
+ * Copyright (C) 2016 Cavium, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License
+ * as published by the Free Software Foundation.
+ */
+
+#include <linux/device.h>
+#include <linux/firmware.h>
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/pci.h>
+#include <linux/printk.h>
+#include <linux/version.h>
+
+#include "cptpf.h"
+
+#define DRV_NAME	"thunder-cpt"
+#define DRV_VERSION	"1.0"
+
+static u32 num_vfs = 4; /* Default 4 VF enabled */
+module_param(num_vfs, uint, 0444);
+MODULE_PARM_DESC(num_vfs, "Number of VFs to enable(1-16)");
+
+/*
+ * Disable cores specified by coremask
+ */
+static void cpt_disable_cores(struct cpt_device *cpt, u64 coremask,
+			      u8 type, u8 grp)
+{
+	u64 pf_exe_ctl;
+	u32 timeout = 100;
+	u64 grpmask = 0;
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
+
+		udelay(CSR_DELAY);
+	}
+
+	/* Disable the cores */
+	pf_exe_ctl = cpt_read_csr64(cpt->reg_base, CPTX_PF_EXE_CTL(0));
+	cpt_write_csr64(cpt->reg_base, CPTX_PF_EXE_CTL(0),
+			(pf_exe_ctl & ~coremask));
+	udelay(CSR_DELAY);
+}
+
+/*
+ * Enable cores specified by coremask
+ */
+static void cpt_enable_cores(struct cpt_device *cpt, u64 coremask,
+			     u8 type)
+{
+	u64 pf_exe_ctl;
+
+	if (type == AE_TYPES)
+		coremask = (coremask << cpt->max_se_cores);
+
+	pf_exe_ctl = cpt_read_csr64(cpt->reg_base, CPTX_PF_EXE_CTL(0));
+	cpt_write_csr64(cpt->reg_base, CPTX_PF_EXE_CTL(0),
+			(pf_exe_ctl | coremask));
+	udelay(CSR_DELAY);
+}
+
+static void cpt_configure_group(struct cpt_device *cpt, u8 grp,
+				u64 coremask, u8 type)
+{
+	u64 pf_gx_en = 0;
+
+	if (type == AE_TYPES)
+		coremask = (coremask << cpt->max_se_cores);
+
+	pf_gx_en = cpt_read_csr64(cpt->reg_base, CPTX_PF_GX_EN(0, grp));
+	cpt_write_csr64(cpt->reg_base, CPTX_PF_GX_EN(0, grp),
+			(pf_gx_en | coremask));
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
+static int cpt_load_microcode(struct cpt_device *cpt, struct microcode *mcode)
+{
+	int ret = 0, core = 0, shift = 0;
+	u32 total_cores = 0;
+	struct device *dev = &cpt->pdev->dev;
+
+	if (!mcode || !mcode->code) {
+		dev_err(dev, "Either the mcode is null or data is NULL\n");
+		return -EINVAL;
+	}
+
+	if (mcode->code_size == 0) {
+		dev_err(dev, "microcode size is 0\n");
+		return -EINVAL;
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
+		if (mcode->core_mask & (1 << shift)) {
+			cpt_write_csr64(cpt->reg_base,
+					CPTX_PF_ENGX_UCODE_BASE(0, core),
+					(u64)mcode->phys_base);
+		}
+	}
+	return ret;
+}
+
+static int do_cpt_init(struct cpt_device *cpt, struct microcode *mcode)
+{
+	int ret = 0;
+	struct device *dev = &cpt->pdev->dev;
+
+	/* Make device not ready */
+	cpt->flags &= ~CPT_FLAG_DEVICE_READY;
+	/* Disable All PF interrupts */
+	cpt_disable_all_interrupts(cpt);
+	/* Calculate mcode group and coremasks */
+	if (mcode->is_ae) {
+		if (mcode->num_cores > cpt->max_ae_cores) {
+			dev_err(dev, "Requested for more cores than available AE cores\n");
+			ret = -EINVAL;
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
+		mcode->core_mask = GENMASK(mcode->num_cores, 0);
+		cpt_disable_cores(cpt, mcode->core_mask, AE_TYPES,
+				  mcode->group);
+		/* Load microcode for AE engines */
+		ret = cpt_load_microcode(cpt, mcode);
+		if (ret) {
+			dev_err(dev, "Microcode load Failed for %s\n",
+				mcode->version);
+			goto cpt_init_fail;
+		}
+		cpt->next_group++;
+		/* Configure group mask for the mcode */
+		cpt_configure_group(cpt, mcode->group, mcode->core_mask,
+				    AE_TYPES);
+		/* Enable AE cores for the group mask */
+		cpt_enable_cores(cpt, mcode->core_mask, AE_TYPES);
+	} else {
+		if (mcode->num_cores > cpt->max_se_cores) {
+			dev_err(dev, "Requested for more cores than available SE cores\n");
+			ret = -EINVAL;
+			goto cpt_init_fail;
+		}
+		if (cpt->next_group >= CPT_MAX_CORE_GROUPS) {
+			dev_err(dev, "Can't load, all eight microcode groups in use");
+			return -ENFILE;
+		}
+
+		mcode->group = cpt->next_group;
+		/* Covert requested cores to mask */
+		mcode->core_mask = GENMASK(mcode->num_cores, 0);
+		cpt_disable_cores(cpt, mcode->core_mask, SE_TYPES,
+				  mcode->group);
+		/* Load microcode for SE engines */
+		ret = cpt_load_microcode(cpt, mcode);
+		if (ret) {
+			dev_err(dev, "Microcode load Failed for %s\n",
+				mcode->version);
+			goto cpt_init_fail;
+		}
+		cpt->next_group++;
+		/* Configure group mask for the mcode */
+		cpt_configure_group(cpt, mcode->group, mcode->core_mask,
+				    SE_TYPES);
+		/* Enable SE cores for the group mask */
+		cpt_enable_cores(cpt, mcode->core_mask, SE_TYPES);
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
+
+	return ret;
+}
+
+struct ucode_header {
+	u8 version[CPT_UCODE_VERSION_SZ];
+	u32 code_length;
+	u32 data_length;
+	u64 sram_address;
+};
+
+static int cpt_ucode_load_fw(struct cpt_device *cpt, const u8 *fw, bool is_ae)
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
+	ucode = (struct ucode_header *)fw_entry->data;
+	mcode = &cpt->mcode[cpt->next_mc_idx];
+	memcpy(mcode->version, (u8 *)fw_entry->data, CPT_UCODE_VERSION_SZ);
+	mcode->code_size = ntohl(ucode->code_length) * 2;
+	if (!mcode->code_size)
+		return -EINVAL;
+
+	mcode->is_ae = is_ae;
+	mcode->core_mask = 0ULL;
+	mcode->num_cores = is_ae ? 6 : 10;
+
+	/*  Allocate DMAable space */
+	mcode->code = dma_zalloc_coherent(&cpt->pdev->dev, mcode->code_size,
+					  &mcode->phys_base, GFP_KERNEL);
+	if (!mcode->code) {
+		dev_err(dev, "Unable to allocate space for microcode");
+		return -ENOMEM;
+	}
+
+	memcpy((void *)mcode->code, (void *)(fw_entry->data + sizeof(*ucode)),
+	       mcode->code_size);
+
+	/* Byte swap 64-bit */
+	for (j = 0; j < (mcode->code_size / 8); j++)
+		((u64 *)mcode->code)[j] = cpu_to_be64(((u64 *)mcode->code)[j]);
+	/*  MC needs 16-bit swap */
+	for (j = 0; j < (mcode->code_size / 2); j++)
+		((u16 *)mcode->code)[j] = cpu_to_be16(((u16 *)mcode->code)[j]);
+
+	dev_dbg(dev, "mcode->code_size = %u\n", mcode->code_size);
+	dev_dbg(dev, "mcode->is_ae = %u\n", mcode->is_ae);
+	dev_dbg(dev, "mcode->num_cores = %u\n", mcode->num_cores);
+	dev_dbg(dev, "mcode->code = %llx\n", (u64)mcode->code);
+	dev_dbg(dev, "mcode->phys_base = %llx\n", mcode->phys_base);
+
+	ret = do_cpt_init(cpt, mcode);
+	if (ret) {
+		dev_err(dev, "do_cpt_init failed with ret: %d\n", ret);
+		return ret;
+	}
+
+	dev_info(dev, "Microcode Loaded %s\n", mcode->version);
+	mcode->is_mc_valid = 1;
+	cpt->next_mc_idx++;
+	release_firmware(fw_entry);
+
+	return ret;
+}
+
+static int cpt_ucode_load(struct cpt_device *cpt)
+{
+	int ret = 0;
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
+static int cpt_enable_msix(struct cpt_device *cpt)
+{
+	int i, ret;
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
+static irqreturn_t cpt_mbx0_intr_handler(int irq, void *cpt_irq)
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
+	int irq;
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
+static u32 cpt_check_bist_status(struct cpt_device *cpt)
+{
+	union cptx_pf_bist_status bist_sts = {0};
+
+	bist_sts.u = cpt_read_csr64(cpt->reg_base,
+				    CPTX_PF_BIST_STATUS(0));
+
+	return bist_sts.u;
+}
+
+static u64 cpt_check_exe_bist_status(struct cpt_device *cpt)
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
+	u32 grp, timeout = 100;
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
+
+		udelay(CSR_DELAY);
+	}
+	/* Disable the cores */
+	cpt_write_csr64(cpt->reg_base, CPTX_PF_EXE_CTL(0), 0);
+}
+
+/**
+ * Ensure all cores are disengaged from all groups by
+ * calling cpt_disable_all_cores() before calling this
+ * function.
+ */
+static void cpt_unload_microcode(struct cpt_device *cpt)
+{
+	u32 grp = 0, core;
+
+	/* Free microcode bases and reset group masks */
+	for (grp = 0; grp < CPT_MAX_CORE_GROUPS; grp++) {
+		struct microcode *mcode = &cpt->mcode[grp];
+
+		if (cpt->mcode[grp].code)
+			dma_free_coherent(&cpt->pdev->dev, mcode->code_size,
+					  mcode->code, mcode->phys_base);
+		mcode->code = NULL;
+	}
+	/* Clear UCODE_BASE registers for all engines */
+	for (core = 0; core < CPT_MAX_TOTAL_CORES; core++)
+		cpt_write_csr64(cpt->reg_base,
+				CPTX_PF_ENGX_UCODE_BASE(0, core), 0ull);
+}
+
+static int cpt_device_init(struct cpt_device *cpt)
+{
+	u64 bist;
+	struct device *dev = &cpt->pdev->dev;
+
+	/* Reset the PF when probed first */
+	cpt_reset(cpt);
+	mdelay(100);
+
+	/*Check BIST status*/
+	bist = (u64)cpt_check_bist_status(cpt);
+	if (bist) {
+		dev_err(dev, "RAM BIST failed with code 0x%llx", bist);
+		return -ENODEV;
+	}
+
+	bist = cpt_check_exe_bist_status(cpt);
+	if (bist) {
+		dev_err(dev, "Engine BIST failed with code 0x%llx", bist);
+		return -ENODEV;
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
+	/* PF is ready */
+	cpt->flags |= CPT_FLAG_DEVICE_READY;
+
+	return 0;
+}
+
+static int cpt_register_interrupts(struct cpt_device *cpt)
+{
+	int ret;
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
+static int cpt_sriov_init(struct cpt_device *cpt, int num_vfs)
+{
+	int pos = 0;
+	int err;
+	u16 total_vf_cnt;
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
+static int cpt_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
+{
+	struct device *dev = &pdev->dev;
+	struct cpt_device *cpt;
+	int err;
+
+	if (num_vfs > 16) {
+		dev_warn(dev, "Invalid vf count %d, Resetting it to 4(default)\n",
+			 num_vfs);
+		num_vfs = 4;
+	}
+
+	cpt = devm_kzalloc(dev, sizeof(*cpt), GFP_KERNEL);
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
+	cpt->reg_base = pcim_iomap(pdev, 0, 0);
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
+		 (u32)pdev->vendor, (u32)pdev->device);
+
+	cpt_unregister_interrupts(cpt);
+	pci_release_regions(pdev);
+	pci_disable_device(pdev);
+	pci_set_drvdata(pdev, NULL);
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
+module_pci_driver(cpt_pci_driver);
+
+MODULE_AUTHOR("George Cherian <george.cherian@cavium.com>");
+MODULE_DESCRIPTION("Cavium Thunder CPT Physical Function Driver");
+MODULE_LICENSE("GPL v2");
+MODULE_VERSION(DRV_VERSION);
+MODULE_DEVICE_TABLE(pci, cpt_id_table);
diff --git a/drivers/crypto/cavium/cpt/cptpf_mbox.c b/drivers/crypto/cavium/cpt/cptpf_mbox.c
new file mode 100644
index 0000000..5818b41
--- /dev/null
+++ b/drivers/crypto/cavium/cpt/cptpf_mbox.c
@@ -0,0 +1,163 @@
+/*
+ * Copyright (C) 2016 Cavium, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License
+ * as published by the Free Software Foundation.
+ */
+#include <linux/module.h>
+#include "cptpf.h"
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
+static void cpt_clear_mbox_intr(struct cpt_device *cpt, u32 vf)
+{
+	/* W1C for the VF */
+	cpt_write_csr64(cpt->reg_base, CPTX_PF_MBOX_INTX(0, 0), (1 << vf));
+}
+
+/*
+ *  Configure QLEN/Chunk sizes for VF
+ */
+static void cpt_cfg_qlen_for_vf(struct cpt_device *cpt, int vf, u32 size)
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
+static void cpt_cfg_vq_priority(struct cpt_device *cpt, int vf, u32 pri)
+{
+	union cptx_pf_qx_ctl pf_qx_ctl;
+
+	pf_qx_ctl.u = cpt_read_csr64(cpt->reg_base, CPTX_PF_QX_CTL(0, vf));
+	pf_qx_ctl.s.pri = pri;
+	cpt_write_csr64(cpt->reg_base, CPTX_PF_QX_CTL(0, vf), pf_qx_ctl.u);
+}
+
+static u8 cpt_bind_vq_to_grp(struct cpt_device *cpt, u8 q, u8 grp)
+{
+	struct microcode *mcode = cpt->mcode;
+	union cptx_pf_qx_ctl pf_qx_ctl;
+	struct device *dev = &cpt->pdev->dev;
+
+	if (q >= CPT_MAX_VF_NUM) {
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
+	u8 vftype;
+	struct device *dev = &cpt->pdev->dev;
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
+		mbx.msg  = CPT_MSG_READY;
+		mbx.data = vf;
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
+		vftype = cpt_bind_vq_to_grp(cpt, vf, (u8)mbx.data);
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
+}
+
+void cpt_mbox_intr_handler (struct cpt_device *cpt, int mbx)
+{
+	u64 intr;
+	u8  vf;
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
