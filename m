From: Huang Ying <ying.huang@intel.com>
Subject: [BUGFIX] Fix AES-NI CTR optimization compiling failure with gas
 2.16.1
Date: Fri, 12 Mar 2010 15:01:47 +0800
Message-ID: <1268377307.1640.491.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:61130 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753057Ab0CLHBt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 12 Mar 2010 02:01:49 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Andrew Morton reported that AES-NI CTR optimization failed to compile
with gas 2.16.1, the error message is as follow:

arch/x86/crypto/aesni-intel_asm.S: Assembler messages:
arch/x86/crypto/aesni-intel_asm.S:752: Error: suffix or operands invalid for `movq'
arch/x86/crypto/aesni-intel_asm.S:753: Error: suffix or operands invalid for `movq'

To fix this, a gas macro is defined to assemble movq with 64bit
general purpose registers and XMM registers. The macro will generate
the raw .byte sequence for needed instructions.

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 arch/x86/crypto/aesni-intel_asm.S |    4 -
 arch/x86/include/asm/inst.h       |   96 ++++++++++++++++++++++++++++++++++++--
 2 files changed, 95 insertions(+), 5 deletions(-)

--- a/arch/x86/crypto/aesni-intel_asm.S
+++ b/arch/x86/crypto/aesni-intel_asm.S
@@ -749,8 +749,8 @@ _aesni_inc_init:
 	movaps IV, CTR
 	PSHUFB_XMM BSWAP_MASK CTR
 	mov $1, TCTR_LOW
-	movq TCTR_LOW, INC
-	movq CTR, TCTR_LOW
+	MOVQ_R64_XMM TCTR_LOW INC
+	MOVQ_R64_XMM CTR TCTR_LOW
 	ret
 
 /*
--- a/arch/x86/include/asm/inst.h
+++ b/arch/x86/include/asm/inst.h
@@ -7,7 +7,66 @@
 
 #ifdef __ASSEMBLY__
 
+#define REG_NUM_INVALID		100
+
+#define REG_TYPE_R64		0
+#define REG_TYPE_XMM		1
+#define REG_TYPE_INVALID	100
+
+	.macro R64_NUM opd r64
+	\opd = REG_NUM_INVALID
+	.ifc \r64,%rax
+	\opd = 0
+	.endif
+	.ifc \r64,%rcx
+	\opd = 1
+	.endif
+	.ifc \r64,%rdx
+	\opd = 2
+	.endif
+	.ifc \r64,%rbx
+	\opd = 3
+	.endif
+	.ifc \r64,%rsp
+	\opd = 4
+	.endif
+	.ifc \r64,%rbp
+	\opd = 5
+	.endif
+	.ifc \r64,%rsi
+	\opd = 6
+	.endif
+	.ifc \r64,%rdi
+	\opd = 7
+	.endif
+	.ifc \r64,%r8
+	\opd = 8
+	.endif
+	.ifc \r64,%r9
+	\opd = 9
+	.endif
+	.ifc \r64,%r10
+	\opd = 10
+	.endif
+	.ifc \r64,%r11
+	\opd = 11
+	.endif
+	.ifc \r64,%r12
+	\opd = 12
+	.endif
+	.ifc \r64,%r13
+	\opd = 13
+	.endif
+	.ifc \r64,%r14
+	\opd = 14
+	.endif
+	.ifc \r64,%r15
+	\opd = 15
+	.endif
+	.endm
+
 	.macro XMM_NUM opd xmm
+	\opd = REG_NUM_INVALID
 	.ifc \xmm,%xmm0
 	\opd = 0
 	.endif
@@ -58,13 +117,25 @@
 	.endif
 	.endm
 
+	.macro REG_TYPE type reg
+	R64_NUM reg_type_r64 \reg
+	XMM_NUM reg_type_xmm \reg
+	.if reg_type_r64 != REG_NUM_INVALID
+	\type = REG_TYPE_R64
+	.elseif reg_type_xmm != REG_NUM_INVALID
+	\type = REG_TYPE_XMM
+	.else
+	\type = REG_TYPE_INVALID
+	.endif
+	.endm
+
 	.macro PFX_OPD_SIZE
 	.byte 0x66
 	.endm
 
-	.macro PFX_REX opd1 opd2
-	.if (\opd1 | \opd2) & 8
-	.byte 0x40 | ((\opd1 & 8) >> 3) | ((\opd2 & 8) >> 1)
+	.macro PFX_REX opd1 opd2 W=0
+	.if ((\opd1 | \opd2) & 8) || \W
+	.byte 0x40 | ((\opd1 & 8) >> 3) | ((\opd2 & 8) >> 1) | (\W << 3)
 	.endif
 	.endm
 
@@ -145,6 +216,25 @@
 	.byte 0x0f, 0x38, 0xdf
 	MODRM 0xc0 aesdeclast_opd1 aesdeclast_opd2
 	.endm
+
+	.macro MOVQ_R64_XMM opd1 opd2
+	REG_TYPE movq_r64_xmm_opd1_type \opd1
+	.if movq_r64_xmm_opd1_type == REG_TYPE_XMM
+	XMM_NUM movq_r64_xmm_opd1 \opd1
+	R64_NUM movq_r64_xmm_opd2 \opd2
+	.else
+	R64_NUM movq_r64_xmm_opd1 \opd1
+	XMM_NUM movq_r64_xmm_opd2 \opd2
+	.endif
+	PFX_OPD_SIZE
+	PFX_REX movq_r64_xmm_opd1 movq_r64_xmm_opd2 1
+	.if movq_r64_xmm_opd1_type == REG_TYPE_XMM
+	.byte 0x0f, 0x7e
+	.else
+	.byte 0x0f, 0x6e
+	.endif
+	MODRM 0xc0 movq_r64_xmm_opd1 movq_r64_xmm_opd2
+	.endm
 #endif
 
 #endif


