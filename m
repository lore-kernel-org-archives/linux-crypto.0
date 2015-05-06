From: Dan Streetman <ddstreet@ieee.org>
Subject: [PATCH 02/10] powerpc: Add ICSWX instruction
Date: Wed,  6 May 2015 12:50:58 -0400
Message-ID: <1430931066-4536-3-git-send-email-ddstreet@ieee.org>
References: <1428428070-17803-1-git-send-email-ddstreet@ieee.org>
 <1430931066-4536-1-git-send-email-ddstreet@ieee.org>
Cc: Dan Streetman <ddstreet@ieee.org>,
	Seth Jennings <sjennings@variantweb.net>,
	Robert Jennings <rob@pochix.net>, linux-crypto@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Paul Mackerras <paulus@samba.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1430931066-4536-1-git-send-email-ddstreet@ieee.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Add the asm ICSWX and ICSWEPX opcodes.  Add definitions for the
Coprocessor Request structures needed to use the icswx calls to
coprocessors.  Add icswx() function to perform the ICSWX asm
using the provided Coprocessor Command Word value and
Coprocessor Request Block structure.

This is required for communication with the NX-842 coprocessor on
a PowerNV system.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
---
 arch/powerpc/include/asm/icswx.h      | 184 ++++++++++++++++++++++++++++++++++
 arch/powerpc/include/asm/ppc-opcode.h |  13 +++
 2 files changed, 197 insertions(+)
 create mode 100644 arch/powerpc/include/asm/icswx.h

diff --git a/arch/powerpc/include/asm/icswx.h b/arch/powerpc/include/asm/icswx.h
new file mode 100644
index 0000000..9f8402b
--- /dev/null
+++ b/arch/powerpc/include/asm/icswx.h
@@ -0,0 +1,184 @@
+/*
+ * ICSWX api
+ *
+ * Copyright (C) 2015 IBM Corp.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ *
+ * This provides the Initiate Coprocessor Store Word Indexed (ICSWX)
+ * instruction.  This instruction is used to communicate with PowerPC
+ * coprocessors.  This also provides definitions of the structures used
+ * to communicate with the coprocessor.
+ *
+ * The RFC02130: Coprocessor Architecture document is the reference for
+ * everything in this file unless otherwise noted.
+ */
+#ifndef _ARCH_POWERPC_INCLUDE_ASM_ICSWX_H_
+#define _ARCH_POWERPC_INCLUDE_ASM_ICSWX_H_
+
+#include <asm/ppc-opcode.h> /* for PPC_ICSWX */
+
+/* Chapter 6.5.8 Coprocessor-Completion Block (CCB) */
+
+#define CCB_VALUE		(0x3fffffffffffffff)
+#define CCB_ADDRESS		(0xfffffffffffffff8)
+#define CCB_CM			(0x0000000000000007)
+#define CCB_CM0			(0x0000000000000004)
+#define CCB_CM12		(0x0000000000000003)
+
+#define CCB_CM0_ALL_COMPLETIONS	(0x0)
+#define CCB_CM0_LAST_IN_CHAIN	(0x4)
+#define CCB_CM12_STORE		(0x0)
+#define CCB_CM12_INTERRUPT	(0x1)
+
+#define CCB_SIZE		(0x10)
+#define CCB_ALIGN		CCB_SIZE
+
+struct coprocessor_completion_block {
+	__be64 value;
+	__be64 address;
+} __packed __aligned(CCB_ALIGN);
+
+
+/* Chapter 6.5.7 Coprocessor-Status Block (CSB) */
+
+#define CSB_V			(0x80)
+#define CSB_F			(0x04)
+#define CSB_CH			(0x03)
+#define CSB_CE_INCOMPLETE	(0x80)
+#define CSB_CE_TERMINATION	(0x40)
+#define CSB_CE_TPBC		(0x20)
+
+#define CSB_CC_SUCCESS		(0)
+#define CSB_CC_INVALID_ALIGN	(1)
+#define CSB_CC_OPERAND_OVERLAP	(2)
+#define CSB_CC_DATA_LENGTH	(3)
+#define CSB_CC_TRANSLATION	(5)
+#define CSB_CC_PROTECTION	(6)
+#define CSB_CC_RD_EXTERNAL	(7)
+#define CSB_CC_INVALID_OPERAND	(8)
+#define CSB_CC_PRIVILEGE	(9)
+#define CSB_CC_INTERNAL		(10)
+#define CSB_CC_WR_EXTERNAL	(12)
+#define CSB_CC_NOSPC		(13)
+#define CSB_CC_EXCESSIVE_DDE	(14)
+#define CSB_CC_WR_TRANSLATION	(15)
+#define CSB_CC_WR_PROTECTION	(16)
+#define CSB_CC_UNKNOWN_CODE	(17)
+#define CSB_CC_ABORT		(18)
+#define CSB_CC_TRANSPORT	(20)
+#define CSB_CC_SEGMENTED_DDL	(31)
+#define CSB_CC_PROGRESS_POINT	(32)
+#define CSB_CC_DDE_OVERFLOW	(33)
+#define CSB_CC_SESSION		(34)
+#define CSB_CC_PROVISION	(36)
+#define CSB_CC_CHAIN		(37)
+#define CSB_CC_SEQUENCE		(38)
+#define CSB_CC_HW		(39)
+
+#define CSB_SIZE		(0x10)
+#define CSB_ALIGN		CSB_SIZE
+
+struct coprocessor_status_block {
+	u8 flags;
+	u8 cs;
+	u8 cc;
+	u8 ce;
+	__be32 count;
+	__be64 address;
+} __packed __aligned(CSB_ALIGN);
+
+
+/* Chapter 6.5.10 Data-Descriptor List (DDL)
+ * each list contains one or more Data-Descriptor Entries (DDE)
+ */
+
+#define DDE_P			(0x8000)
+
+#define DDE_SIZE		(0x10)
+#define DDE_ALIGN		DDE_SIZE
+
+struct data_descriptor_entry {
+	__be16 flags;
+	u8 count;
+	u8 index;
+	__be32 length;
+	__be64 address;
+} __packed __aligned(DDE_ALIGN);
+
+
+/* Chapter 6.5.2 Coprocessor-Request Block (CRB) */
+
+#define CRB_SIZE		(0x80)
+#define CRB_ALIGN		(0x100) /* Errata: requires 256 alignment */
+
+/* Coprocessor Status Block field
+ *   ADDRESS	address of CSB
+ *   C		CCB is valid
+ *   AT		0 = addrs are virtual, 1 = addrs are phys
+ *   M		enable perf monitor
+ */
+#define CRB_CSB_ADDRESS		(0xfffffffffffffff0)
+#define CRB_CSB_C		(0x0000000000000008)
+#define CRB_CSB_AT		(0x0000000000000002)
+#define CRB_CSB_M		(0x0000000000000001)
+
+struct coprocessor_request_block {
+	__be32 ccw;
+	__be32 flags;
+	__be64 csb_addr;
+
+	struct data_descriptor_entry source;
+	struct data_descriptor_entry target;
+
+	struct coprocessor_completion_block ccb;
+
+	u8 reserved[48];
+
+	struct coprocessor_status_block csb;
+} __packed __aligned(CRB_ALIGN);
+
+
+/* RFC02167 Initiate Coprocessor Instructions document
+ * Chapter 8.2.1.1.1 RS
+ * Chapter 8.2.3 Coprocessor Directive
+ * Chapter 8.2.4 Execution
+ *
+ * The CCW must be converted to BE before passing to icswx()
+ */
+
+#define CCW_PS			(0xff000000)
+#define CCW_CT			(0x00ff0000)
+#define CCW_CD			(0x0000ffff)
+#define CCW_CL			(0x0000c000)
+
+
+/* RFC02167 Initiate Coprocessor Instructions document
+ * Chapter 8.2.1 Initiate Coprocessor Store Word Indexed (ICSWX)
+ * Chapter 8.2.4.1 Condition Register 0
+ */
+
+#define ICSWX_INITIATED		(0x8)
+#define ICSWX_BUSY		(0x4)
+#define ICSWX_REJECTED		(0x2)
+
+static inline int icswx(__be32 ccw, struct coprocessor_request_block *crb)
+{
+	__be64 ccw_reg = ccw;
+	u32 cr;
+
+	__asm__ __volatile__(
+	PPC_ICSWX(%1,0,%2) "\n"
+	"mfcr %0\n"
+	: "=r" (cr)
+	: "r" (ccw_reg), "r" (crb)
+	: "cr0", "memory");
+
+	return (int)((cr >> 28) & 0xf);
+}
+
+
+#endif /* _ARCH_POWERPC_INCLUDE_ASM_ICSWX_H_ */
diff --git a/arch/powerpc/include/asm/ppc-opcode.h b/arch/powerpc/include/asm/ppc-opcode.h
index 5c93f69..8452335 100644
--- a/arch/powerpc/include/asm/ppc-opcode.h
+++ b/arch/powerpc/include/asm/ppc-opcode.h
@@ -136,6 +136,8 @@
 #define PPC_INST_DCBAL			0x7c2005ec
 #define PPC_INST_DCBZL			0x7c2007ec
 #define PPC_INST_ICBT			0x7c00002c
+#define PPC_INST_ICSWX			0x7c00032d
+#define PPC_INST_ICSWEPX		0x7c00076d
 #define PPC_INST_ISEL			0x7c00001e
 #define PPC_INST_ISEL_MASK		0xfc00003e
 #define PPC_INST_LDARX			0x7c0000a8
@@ -403,4 +405,15 @@
 #define MFTMR(tmr, r)		stringify_in_c(.long PPC_INST_MFTMR | \
 					       TMRN(tmr) | ___PPC_RT(r))
 
+/* Coprocessor instructions */
+#define PPC_ICSWX(s, a, b)	stringify_in_c(.long PPC_INST_ICSWX |	\
+					       ___PPC_RS(s) |		\
+					       ___PPC_RA(a) |		\
+					       ___PPC_RB(b))
+#define PPC_ICSWEPX(s, a, b)	stringify_in_c(.long PPC_INST_ICSWEPX | \
+					       ___PPC_RS(s) |		\
+					       ___PPC_RA(a) |		\
+					       ___PPC_RB(b))
+
+
 #endif /* _ASM_POWERPC_PPC_OPCODE_H */
-- 
2.1.0
