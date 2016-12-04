From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 4/6] crypto: arm/crct10dif - port x86 SSE implementation to ARM
Date: Sun,  4 Dec 2016 11:54:05 +0000
Message-ID: <1480852447-25082-5-git-send-email-ard.biesheuvel@linaro.org>
References: <1480852447-25082-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:35791 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750881AbcLDLyY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 4 Dec 2016 06:54:24 -0500
Received: by mail-wm0-f42.google.com with SMTP id a197so57471923wmd.0
        for <linux-crypto@vger.kernel.org>; Sun, 04 Dec 2016 03:54:23 -0800 (PST)
In-Reply-To: <1480852447-25082-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is a transliteration of the Intel algorithm implemented
using SSE and PCLMULQDQ instructions that resides in the file
arch/x86/crypto/crct10dif-pcl-asm_64.S, but simplified to only
operate on multiples of 16 bytes. The residual data is handled
by the generic C implementation.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/Kconfig             |   5 +
 arch/arm/crypto/Makefile            |   2 +
 arch/arm/crypto/crct10dif-ce-core.S | 349 ++++++++++++++++++++
 arch/arm/crypto/crct10dif-ce-glue.c |  95 ++++++
 4 files changed, 451 insertions(+)

diff --git a/arch/arm/crypto/Kconfig b/arch/arm/crypto/Kconfig
index 27ed1b1cd1d7..fce801fa52a1 100644
--- a/arch/arm/crypto/Kconfig
+++ b/arch/arm/crypto/Kconfig
@@ -120,4 +120,9 @@ config CRYPTO_GHASH_ARM_CE
 	  that uses the 64x64 to 128 bit polynomial multiplication (vmull.p64)
 	  that is part of the ARMv8 Crypto Extensions
 
+config CRYPTO_CRCT10DIF_ARM_CE
+	tristate "CRCT10DIF digest algorithm using PMULL instructions"
+	depends on KERNEL_MODE_NEON && CRC_T10DIF
+	select CRYPTO_HASH
+
 endif
diff --git a/arch/arm/crypto/Makefile b/arch/arm/crypto/Makefile
index fc5150702b64..fc77265014b7 100644
--- a/arch/arm/crypto/Makefile
+++ b/arch/arm/crypto/Makefile
@@ -13,6 +13,7 @@ ce-obj-$(CONFIG_CRYPTO_AES_ARM_CE) += aes-arm-ce.o
 ce-obj-$(CONFIG_CRYPTO_SHA1_ARM_CE) += sha1-arm-ce.o
 ce-obj-$(CONFIG_CRYPTO_SHA2_ARM_CE) += sha2-arm-ce.o
 ce-obj-$(CONFIG_CRYPTO_GHASH_ARM_CE) += ghash-arm-ce.o
+ce-obj-$(CONFIG_CRYPTO_CRCT10DIF_ARM_CE) += crct10dif-arm-ce.o
 
 ifneq ($(ce-obj-y)$(ce-obj-m),)
 ifeq ($(call as-instr,.fpu crypto-neon-fp-armv8,y,n),y)
@@ -36,6 +37,7 @@ sha1-arm-ce-y	:= sha1-ce-core.o sha1-ce-glue.o
 sha2-arm-ce-y	:= sha2-ce-core.o sha2-ce-glue.o
 aes-arm-ce-y	:= aes-ce-core.o aes-ce-glue.o
 ghash-arm-ce-y	:= ghash-ce-core.o ghash-ce-glue.o
+crct10dif-arm-ce-y	:= crct10dif-ce-core.o crct10dif-ce-glue.o
 
 quiet_cmd_perl = PERL    $@
       cmd_perl = $(PERL) $(<) > $(@)
diff --git a/arch/arm/crypto/crct10dif-ce-core.S b/arch/arm/crypto/crct10dif-ce-core.S
new file mode 100644
index 000000000000..ae2adb54e905
--- /dev/null
+++ b/arch/arm/crypto/crct10dif-ce-core.S
@@ -0,0 +1,349 @@
+//
+// Accelerated CRC-T10DIF using ARM NEON and Crypto Extensions instructions
+//
+// Copyright (C) 2016 Linaro Ltd <ard.biesheuvel@linaro.org>
+//
+// This program is free software; you can redistribute it and/or modify
+// it under the terms of the GNU General Public License version 2 as
+// published by the Free Software Foundation.
+//
+
+//
+// Implement fast CRC-T10DIF computation with SSE and PCLMULQDQ instructions
+//
+// Copyright (c) 2013, Intel Corporation
+//
+// Authors:
+//     Erdinc Ozturk <erdinc.ozturk@intel.com>
+//     Vinodh Gopal <vinodh.gopal@intel.com>
+//     James Guilford <james.guilford@intel.com>
+//     Tim Chen <tim.c.chen@linux.intel.com>
+//
+// This software is available to you under a choice of one of two
+// licenses.  You may choose to be licensed under the terms of the GNU
+// General Public License (GPL) Version 2, available from the file
+// COPYING in the main directory of this source tree, or the
+// OpenIB.org BSD license below:
+//
+// Redistribution and use in source and binary forms, with or without
+// modification, are permitted provided that the following conditions are
+// met:
+//
+// * Redistributions of source code must retain the above copyright
+//   notice, this list of conditions and the following disclaimer.
+//
+// * Redistributions in binary form must reproduce the above copyright
+//   notice, this list of conditions and the following disclaimer in the
+//   documentation and/or other materials provided with the
+//   distribution.
+//
+// * Neither the name of the Intel Corporation nor the names of its
+//   contributors may be used to endorse or promote products derived from
+//   this software without specific prior written permission.
+//
+//
+// THIS SOFTWARE IS PROVIDED BY INTEL CORPORATION ""AS IS"" AND ANY
+// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
+// PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL INTEL CORPORATION OR
+// CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
+// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
+// PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
+// PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
+// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
+// NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
+// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+//
+//       Function API:
+//       UINT16 crc_t10dif_pcl(
+//               UINT16 init_crc, //initial CRC value, 16 bits
+//               const unsigned char *buf, //buffer pointer to calculate CRC on
+//               UINT64 len //buffer length in bytes (64-bit data)
+//       );
+//
+//       Reference paper titled "Fast CRC Computation for Generic
+//	Polynomials Using PCLMULQDQ Instruction"
+//       URL: http://www.intel.com/content/dam/www/public/us/en/documents
+//  /white-papers/fast-crc-computation-generic-polynomials-pclmulqdq-paper.pdf
+//
+//
+
+#include <linux/linkage.h>
+#include <asm/assembler.h>
+
+#ifdef CONFIG_CPU_ENDIAN_BE8
+#define CPU_LE(code...)
+#else
+#define CPU_LE(code...)		code
+#endif
+
+	.text
+	.fpu		crypto-neon-fp-armv8
+
+	arg1_low32	.req	r0
+	arg2		.req	r1
+	arg3		.req	r2
+
+	qzr		.req	q13
+
+	q0l		.req	d0
+	q0h		.req	d1
+	q1l		.req	d2
+	q1h		.req	d3
+	q2l		.req	d4
+	q2h		.req	d5
+	q3l		.req	d6
+	q3h		.req	d7
+	q4l		.req	d8
+	q4h		.req	d9
+	q5l		.req	d10
+	q5h		.req	d11
+	q6l		.req	d12
+	q6h		.req	d13
+	q7l		.req	d14
+	q7h		.req	d15
+
+ENTRY(crc_t10dif_pmull)
+	push		{r4, lr}
+
+	vmov.i8		qzr, #0			// init zero register
+
+	// adjust the 16-bit initial_crc value, scale it to 32 bits
+	lsl		arg1_low32, arg1_low32, #16
+
+	// check if smaller than 256
+	cmp		arg3, #256
+
+	// for sizes less than 128, we can't fold 64B at a time...
+	blt		_less_than_128
+
+	// load the initial crc value
+	// crc value does not need to be byte-reflected, but it needs
+	// to be moved to the high part of the register.
+	// because data will be byte-reflected and will align with
+	// initial crc at correct place.
+	vmov		s0, arg1_low32		// initial crc
+	vext.8		q10, qzr, q0, #4
+
+	// receive the initial 64B data, xor the initial crc value
+	vld1.64		{q0-q1}, [arg2]!
+	vld1.64		{q2-q3}, [arg2]!
+	vld1.64		{q4-q5}, [arg2]!
+	vld1.64		{q6-q7}, [arg2]!
+CPU_LE(	vrev64.8	q0, q0			)
+CPU_LE(	vrev64.8	q1, q1			)
+CPU_LE(	vrev64.8	q2, q2			)
+CPU_LE(	vrev64.8	q3, q3			)
+CPU_LE(	vrev64.8	q4, q4			)
+CPU_LE(	vrev64.8	q5, q5			)
+CPU_LE(	vrev64.8	q6, q6			)
+CPU_LE(	vrev64.8	q7, q7			)
+
+	vswp		d0, d1
+	vswp		d2, d3
+	vswp		d4, d5
+	vswp		d6, d7
+	vswp		d8, d9
+	vswp		d10, d11
+	vswp		d12, d13
+	vswp		d14, d15
+
+	// XOR the initial_crc value
+	veor.8		q0, q0, q10
+
+	adr		ip, rk3
+	vld1.64		{q10}, [ip]	// xmm10 has rk3 and rk4
+					// type of pmull instruction
+					// will determine which constant to use
+
+	//
+	// we subtract 256 instead of 128 to save one instruction from the loop
+	//
+	sub		arg3, arg3, #256
+
+	// at this section of the code, there is 64*x+y (0<=y<64) bytes of
+	// buffer. The _fold_64_B_loop will fold 64B at a time
+	// until we have 64+y Bytes of buffer
+
+
+	// fold 64B at a time. This section of the code folds 4 vector
+	// registers in parallel
+_fold_64_B_loop:
+
+	.macro		fold64, reg1, reg2
+	vld1.64		{q11-q12}, [arg2]!
+
+	vmull.p64	q8, \reg1\()h, d21
+	vmull.p64	\reg1, \reg1\()l, d20
+	vmull.p64	q9, \reg2\()h, d21
+	vmull.p64	\reg2, \reg2\()l, d20
+
+CPU_LE(	vrev64.8	q11, q11		)
+CPU_LE(	vrev64.8	q12, q12		)
+	vswp		d22, d23
+	vswp		d24, d25
+
+	veor.8		\reg1, \reg1, q8
+	veor.8		\reg2, \reg2, q9
+	veor.8		\reg1, \reg1, q11
+	veor.8		\reg2, \reg2, q12
+	.endm
+
+	fold64		q0, q1
+	fold64		q2, q3
+	fold64		q4, q5
+	fold64		q6, q7
+
+	subs		arg3, arg3, #128
+
+	// check if there is another 64B in the buffer to be able to fold
+	bge		_fold_64_B_loop
+
+	// at this point, the buffer pointer is pointing at the last y Bytes
+	// of the buffer the 64B of folded data is in 4 of the vector
+	// registers: v0, v1, v2, v3
+
+	// fold the 8 vector registers to 1 vector register with different
+	// constants
+
+	adr		ip, rk9
+	vld1.64		{q10}, [ip]!
+
+	.macro		fold16, reg, rk
+	vmull.p64	q8, \reg\()l, d20
+	vmull.p64	\reg, \reg\()h, d21
+	.ifnb		\rk
+	vld1.64		{q10}, [ip]!
+	.endif
+	veor.8		q7, q7, q8
+	veor.8		q7, q7, \reg
+	.endm
+
+	fold16		q0, rk11
+	fold16		q1, rk13
+	fold16		q2, rk15
+	fold16		q3, rk17
+	fold16		q4, rk19
+	fold16		q5, rk1
+	fold16		q6
+
+	// instead of 64, we add 48 to the loop counter to save 1 instruction
+	// from the loop instead of a cmp instruction, we use the negative
+	// flag with the jl instruction
+	adds		arg3, arg3, #(128-16)
+	blt		_final_reduction_for_128
+
+	// now we have 16+y bytes left to reduce. 16 Bytes is in register v7
+	// and the rest is in memory. We can fold 16 bytes at a time if y>=16
+	// continue folding 16B at a time
+
+_16B_reduction_loop:
+	vmull.p64	q8, d14, d20
+	vmull.p64	q7, d15, d21
+	veor.8		q7, q7, q8
+
+	vld1.64		{q0}, [arg2]!
+CPU_LE(	vrev64.8	q0, q0		)
+	vswp		d0, d1
+	veor.8		q7, q7, q0
+	subs		arg3, arg3, #16
+
+	// instead of a cmp instruction, we utilize the flags with the
+	// jge instruction equivalent of: cmp arg3, 16-16
+	// check if there is any more 16B in the buffer to be able to fold
+	bge		_16B_reduction_loop
+
+_final_reduction_for_128:
+	// compute crc of a 128-bit value
+	vldr		d20, rk5
+	vldr		d21, rk6		// rk5 and rk6 in xmm10
+
+	// 64b fold
+	vext.8		q0, qzr, q7, #8
+	vmull.p64	q7, d15, d20
+	veor.8		q7, q7, q0
+
+	// 32b fold
+	vext.8		q0, q7, qzr, #12
+	vmov		s31, s3
+	vmull.p64	q0, d0, d21
+	veor.8		q7, q0, q7
+
+	// barrett reduction
+_barrett:
+	vldr		d20, rk7
+	vldr		d21, rk8
+
+	vmull.p64	q0, d15, d20
+	vext.8		q0, qzr, q0, #12
+	vmull.p64	q0, d1, d21
+	vext.8		q0, qzr, q0, #12
+	veor.8		q7, q7, q0
+	vmov		r0, s29
+
+_cleanup:
+	// scale the result back to 16 bits
+	lsr		r0, r0, #16
+	pop		{r4, pc}
+
+_less_than_128:
+	teq		arg3, #0
+	beq		_cleanup
+
+	vmov.i8		q0, #0
+	vmov		s3, arg1_low32		// get the initial crc value
+
+	vld1.64		{q7}, [arg2]!
+CPU_LE(	vrev64.8	q7, q7		)
+	vswp		d14, d15
+	veor.8		q7, q7, q0
+
+	// check if there is enough buffer to be able to fold 16B at a time
+	cmp		arg3, #32
+	blt		_final_reduction_for_128
+
+	// now if there is, load the constants
+	vldr		d20, rk1
+	vldr		d21, rk2		// rk1 and rk2 in xmm10
+
+	// update the counter. subtract 32 instead of 16 to save one
+	// instruction from the loop
+	sub		arg3, arg3, #32
+
+	b		_16B_reduction_loop
+ENDPROC(crc_t10dif_pmull)
+
+// precomputed constants
+// these constants are precomputed from the poly:
+// 0x8bb70000 (0x8bb7 scaled to 32 bits)
+	.align		4
+// Q = 0x18BB70000
+// rk1 = 2^(32*3) mod Q << 32
+// rk2 = 2^(32*5) mod Q << 32
+// rk3 = 2^(32*15) mod Q << 32
+// rk4 = 2^(32*17) mod Q << 32
+// rk5 = 2^(32*3) mod Q << 32
+// rk6 = 2^(32*2) mod Q << 32
+// rk7 = floor(2^64/Q)
+// rk8 = Q
+
+rk3:	.quad		0x9d9d000000000000
+rk4:	.quad		0x7cf5000000000000
+rk5:	.quad		0x2d56000000000000
+rk6:	.quad		0x1368000000000000
+rk7:	.quad		0x00000001f65a57f8
+rk8:	.quad		0x000000018bb70000
+rk9:	.quad		0xceae000000000000
+rk10:	.quad		0xbfd6000000000000
+rk11:	.quad		0x1e16000000000000
+rk12:	.quad		0x713c000000000000
+rk13:	.quad		0xf7f9000000000000
+rk14:	.quad		0x80a6000000000000
+rk15:	.quad		0x044c000000000000
+rk16:	.quad		0xe658000000000000
+rk17:	.quad		0xad18000000000000
+rk18:	.quad		0xa497000000000000
+rk19:	.quad		0x6ee3000000000000
+rk20:	.quad		0xe7b5000000000000
+rk1:	.quad		0x2d56000000000000
+rk2:	.quad		0x06df000000000000
diff --git a/arch/arm/crypto/crct10dif-ce-glue.c b/arch/arm/crypto/crct10dif-ce-glue.c
new file mode 100644
index 000000000000..8225422c34a7
--- /dev/null
+++ b/arch/arm/crypto/crct10dif-ce-glue.c
@@ -0,0 +1,95 @@
+/*
+ * Accelerated CRC-T10DIF using ARM NEON and Crypto Extensions instructions
+ *
+ * Copyright (C) 2016 Linaro Ltd <ard.biesheuvel@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/crc-t10dif.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/string.h>
+
+#include <crypto/internal/hash.h>
+
+#include <asm/neon.h>
+#include <asm/simd.h>
+
+#define CRC_T10DIF_PMULL_CHUNK_SIZE	16U
+
+asmlinkage u16 crc_t10dif_pmull(u16 init_crc, const u8 buf[], u64 len);
+
+static int crct10dif_init(struct shash_desc *desc)
+{
+	u16 *crc = shash_desc_ctx(desc);
+
+	*crc = 0;
+	return 0;
+}
+
+static int crct10dif_update(struct shash_desc *desc, const u8 *data,
+			 unsigned int length)
+{
+	u16 *crc = shash_desc_ctx(desc);
+
+	if (may_use_simd() && length >= CRC_T10DIF_PMULL_CHUNK_SIZE) {
+		unsigned int l = length & ~(CRC_T10DIF_PMULL_CHUNK_SIZE - 1);
+
+		kernel_neon_begin();
+		*crc = crc_t10dif_pmull(*crc, data, l);
+		kernel_neon_end();
+
+		length -= l;
+		data += l;
+	}
+	if (length > 0)
+		*crc = crc_t10dif_generic(*crc, data, length);
+
+	return 0;
+}
+
+static int crct10dif_final(struct shash_desc *desc, u8 *out)
+{
+	u16 *crc = shash_desc_ctx(desc);
+
+	*(u16 *)out = *crc;
+	return 0;
+}
+
+static struct shash_alg crc_t10dif_alg = {
+	.digestsize		= CRC_T10DIF_DIGEST_SIZE,
+	.init			= crct10dif_init,
+	.update			= crct10dif_update,
+	.final			= crct10dif_final,
+	.descsize		= CRC_T10DIF_DIGEST_SIZE,
+
+	.base.cra_name		= "crct10dif",
+	.base.cra_driver_name	= "crct10dif-arm-ce",
+	.base.cra_priority	= 200,
+	.base.cra_blocksize	= CRC_T10DIF_BLOCK_SIZE,
+	.base.cra_module	= THIS_MODULE,
+};
+
+static int __init crc_t10dif_mod_init(void)
+{
+	if (!(elf_hwcap2 & HWCAP2_PMULL))
+		return -ENODEV;
+
+	return crypto_register_shash(&crc_t10dif_alg);
+}
+
+static void __exit crc_t10dif_mod_exit(void)
+{
+	crypto_unregister_shash(&crc_t10dif_alg);
+}
+
+module_init(crc_t10dif_mod_init);
+module_exit(crc_t10dif_mod_exit);
+
+MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS_CRYPTO("crct10dif");
-- 
2.7.4
