From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 3/6] crypto: arm64/crct10dif - port x86 SSE implementation to arm64
Date: Sun,  4 Dec 2016 11:54:04 +0000
Message-ID: <1480852447-25082-4-git-send-email-ard.biesheuvel@linaro.org>
References: <1480852447-25082-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:37120 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750867AbcLDLyW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 4 Dec 2016 06:54:22 -0500
Received: by mail-wm0-f44.google.com with SMTP id t79so53665691wmt.0
        for <linux-crypto@vger.kernel.org>; Sun, 04 Dec 2016 03:54:21 -0800 (PST)
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
 arch/arm64/crypto/Kconfig             |   5 +
 arch/arm64/crypto/Makefile            |   3 +
 arch/arm64/crypto/crct10dif-ce-core.S | 317 ++++++++++++++++++++
 arch/arm64/crypto/crct10dif-ce-glue.c |  91 ++++++
 4 files changed, 416 insertions(+)

diff --git a/arch/arm64/crypto/Kconfig b/arch/arm64/crypto/Kconfig
index 2cf32e9887e1..d773c0659202 100644
--- a/arch/arm64/crypto/Kconfig
+++ b/arch/arm64/crypto/Kconfig
@@ -23,6 +23,11 @@ config CRYPTO_GHASH_ARM64_CE
 	depends on ARM64 && KERNEL_MODE_NEON
 	select CRYPTO_HASH
 
+config CRYPTO_CRCT10DIF_ARM64_CE
+	tristate "CRCT10DIF digest algorithm using PMULL instructions"
+	depends on KERNEL_MODE_NEON && CRC_T10DIF
+	select CRYPTO_HASH
+
 config CRYPTO_AES_ARM64_CE
 	tristate "AES core cipher using ARMv8 Crypto Extensions"
 	depends on ARM64 && KERNEL_MODE_NEON
diff --git a/arch/arm64/crypto/Makefile b/arch/arm64/crypto/Makefile
index abb79b3cfcfe..36fd3eb4201b 100644
--- a/arch/arm64/crypto/Makefile
+++ b/arch/arm64/crypto/Makefile
@@ -17,6 +17,9 @@ sha2-ce-y := sha2-ce-glue.o sha2-ce-core.o
 obj-$(CONFIG_CRYPTO_GHASH_ARM64_CE) += ghash-ce.o
 ghash-ce-y := ghash-ce-glue.o ghash-ce-core.o
 
+obj-$(CONFIG_CRYPTO_CRCT10DIF_ARM64_CE) += crct10dif-ce.o
+crct10dif-ce-y := crct10dif-ce-core.o crct10dif-ce-glue.o
+
 obj-$(CONFIG_CRYPTO_AES_ARM64_CE) += aes-ce-cipher.o
 CFLAGS_aes-ce-cipher.o += -march=armv8-a+crypto
 
diff --git a/arch/arm64/crypto/crct10dif-ce-core.S b/arch/arm64/crypto/crct10dif-ce-core.S
new file mode 100644
index 000000000000..641685effebd
--- /dev/null
+++ b/arch/arm64/crypto/crct10dif-ce-core.S
@@ -0,0 +1,317 @@
+//
+// Accelerated CRC-T10DIF using arm64 NEON and Crypto Extensions instructions
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
+	.text
+	.cpu		generic+crypto
+
+	arg1_low32	.req	w0
+	arg2		.req	x1
+	arg3		.req	x2
+
+	vzr		.req	v13
+
+ENTRY(crc_t10dif_pmull)
+	stp		x29, x30, [sp, #-16]!
+	mov		x29, sp
+
+	movi		vzr.16b, #0		// init zero register
+
+	// adjust the 16-bit initial_crc value, scale it to 32 bits
+	lsl		arg1_low32, arg1_low32, #16
+
+	// check if smaller than 256
+	cmp		arg3, #256
+
+	// for sizes less than 128, we can't fold 64B at a time...
+	b.lt		_less_than_128
+
+	// load the initial crc value
+	// crc value does not need to be byte-reflected, but it needs
+	// to be moved to the high part of the register.
+	// because data will be byte-reflected and will align with
+	// initial crc at correct place.
+	movi		v10.16b, #0
+	mov		v10.s[3], arg1_low32		// initial crc
+
+	// receive the initial 64B data, xor the initial crc value
+	ldp		q0, q1, [arg2]
+	ldp		q2, q3, [arg2, #0x20]
+	ldp		q4, q5, [arg2, #0x40]
+	ldp		q6, q7, [arg2, #0x60]
+	add		arg2, arg2, #0x80
+
+CPU_LE(	rev64		v0.16b, v0.16b			)
+CPU_LE(	rev64		v1.16b, v1.16b			)
+CPU_LE(	rev64		v2.16b, v2.16b			)
+CPU_LE(	rev64		v3.16b, v3.16b			)
+CPU_LE(	rev64		v4.16b, v4.16b			)
+CPU_LE(	rev64		v5.16b, v5.16b			)
+CPU_LE(	rev64		v6.16b, v6.16b			)
+CPU_LE(	rev64		v7.16b, v7.16b			)
+
+CPU_LE(	ext		v0.16b, v0.16b, v0.16b, #8	)
+CPU_LE(	ext		v1.16b, v1.16b, v1.16b, #8	)
+CPU_LE(	ext		v2.16b, v2.16b, v2.16b, #8	)
+CPU_LE(	ext		v3.16b, v3.16b, v3.16b, #8	)
+CPU_LE(	ext		v4.16b, v4.16b, v4.16b, #8	)
+CPU_LE(	ext		v5.16b, v5.16b, v5.16b, #8	)
+CPU_LE(	ext		v6.16b, v6.16b, v6.16b, #8	)
+CPU_LE(	ext		v7.16b, v7.16b, v7.16b, #8	)
+
+	// XOR the initial_crc value
+	eor		v0.16b, v0.16b, v10.16b
+
+	ldr		q10, rk3	// xmm10 has rk3 and rk4
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
+	ldp		q11, q12, [arg2], #0x20
+
+	pmull2		v8.1q, \reg1\().2d, v10.2d
+	pmull		\reg1\().1q, \reg1\().1d, v10.1d
+
+CPU_LE(	rev64		v11.16b, v11.16b		)
+CPU_LE(	rev64		v12.16b, v12.16b		)
+
+	pmull2		v9.1q, \reg2\().2d, v10.2d
+	pmull		\reg2\().1q, \reg2\().1d, v10.1d
+
+CPU_LE(	ext		v11.16b, v11.16b, v11.16b, #8	)
+CPU_LE(	ext		v12.16b, v12.16b, v12.16b, #8	)
+
+	eor		\reg1\().16b, \reg1\().16b, v8.16b
+	eor		\reg2\().16b, \reg2\().16b, v9.16b
+	eor		\reg1\().16b, \reg1\().16b, v11.16b
+	eor		\reg2\().16b, \reg2\().16b, v12.16b
+	.endm
+
+	fold64		v0, v1
+	fold64		v2, v3
+	fold64		v4, v5
+	fold64		v6, v7
+
+	subs		arg3, arg3, #128
+
+	// check if there is another 64B in the buffer to be able to fold
+	b.ge		_fold_64_B_loop
+
+	// at this point, the buffer pointer is pointing at the last y Bytes
+	// of the buffer the 64B of folded data is in 4 of the vector
+	// registers: v0, v1, v2, v3
+
+	// fold the 8 vector registers to 1 vector register with different
+	// constants
+
+	ldr		q10, rk9
+
+	.macro		fold16, reg, rk
+	pmull		v8.1q, \reg\().1d, v10.1d
+	pmull2		\reg\().1q, \reg\().2d, v10.2d
+	.ifnb		\rk
+	ldr		q10, \rk
+	.endif
+	eor		v7.16b, v7.16b, v8.16b
+	eor		v7.16b, v7.16b, \reg\().16b
+	.endm
+
+	fold16		v0, rk11
+	fold16		v1, rk13
+	fold16		v2, rk15
+	fold16		v3, rk17
+	fold16		v4, rk19
+	fold16		v5, rk1
+	fold16		v6
+
+	// instead of 64, we add 48 to the loop counter to save 1 instruction
+	// from the loop instead of a cmp instruction, we use the negative
+	// flag with the jl instruction
+	adds		arg3, arg3, #(128-16)
+	b.lt		_final_reduction_for_128
+
+	// now we have 16+y bytes left to reduce. 16 Bytes is in register v7
+	// and the rest is in memory. We can fold 16 bytes at a time if y>=16
+	// continue folding 16B at a time
+
+_16B_reduction_loop:
+	pmull		v8.1q, v7.1d, v10.1d
+	pmull2		v7.1q, v7.2d, v10.2d
+	eor		v7.16b, v7.16b, v8.16b
+
+	ldr		q0, [arg2], #16
+CPU_LE(	rev64		v0.16b, v0.16b			)
+CPU_LE(	ext		v0.16b, v0.16b, v0.16b, #8	)
+	eor		v7.16b, v7.16b, v0.16b
+	subs		arg3, arg3, #16
+
+	// instead of a cmp instruction, we utilize the flags with the
+	// jge instruction equivalent of: cmp arg3, 16-16
+	// check if there is any more 16B in the buffer to be able to fold
+	b.ge		_16B_reduction_loop
+
+_final_reduction_for_128:
+	// compute crc of a 128-bit value
+	ldr		q10, rk5		// rk5 and rk6 in xmm10
+
+	// 64b fold
+	ext		v0.16b, vzr.16b, v7.16b, #8
+	mov		v7.d[0], v7.d[1]
+	pmull		v7.1q, v7.1d, v10.1d
+	eor		v7.16b, v7.16b, v0.16b
+
+	// 32b fold
+	ext		v0.16b, v7.16b, vzr.16b, #4
+	mov		v7.s[3], vzr.s[0]
+	pmull2		v0.1q, v0.2d, v10.2d
+	eor		v7.16b, v7.16b, v0.16b
+
+	// barrett reduction
+_barrett:
+	ldr		q10, rk7
+	mov		v0.d[0], v7.d[1]
+
+	pmull		v0.1q, v0.1d, v10.1d
+	ext		v0.16b, vzr.16b, v0.16b, #12
+	pmull2		v0.1q, v0.2d, v10.2d
+	ext		v0.16b, vzr.16b, v0.16b, #12
+	eor		v7.16b, v7.16b, v0.16b
+	mov		w0, v7.s[1]
+
+_cleanup:
+	// scale the result back to 16 bits
+	lsr		x0, x0, #16
+	ldp		x29, x30, [sp], #16
+	ret
+
+_less_than_128:
+	cbz		arg3, _cleanup
+
+	movi		v0.16b, #0
+	mov		v0.s[3], arg1_low32	// get the initial crc value
+
+	ldr		q7, [arg2], #0x10
+CPU_LE(	rev64		v7.16b, v7.16b			)
+CPU_LE(	ext		v7.16b, v7.16b, v7.16b, #8	)
+	eor		v7.16b, v7.16b, v0.16b	// xor the initial crc value
+
+	// check if there is enough buffer to be able to fold 16B at a time
+	cmp		arg3, #32
+	b.lt		_final_reduction_for_128
+
+	// now if there is, load the constants
+	ldr		q10, rk1		// rk1 and rk2 in xmm10
+
+	// update the counter. subtract 32 instead of 16 to save one
+	// instruction from the loop
+	sub		arg3, arg3, #32
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
+rk1:	.octa		0x06df0000000000002d56000000000000
+rk3:	.octa		0x7cf50000000000009d9d000000000000
+rk5:	.octa		0x13680000000000002d56000000000000
+rk7:	.octa		0x000000018bb7000000000001f65a57f8
+rk9:	.octa		0xbfd6000000000000ceae000000000000
+rk11:	.octa		0x713c0000000000001e16000000000000
+rk13:	.octa		0x80a6000000000000f7f9000000000000
+rk15:	.octa		0xe658000000000000044c000000000000
+rk17:	.octa		0xa497000000000000ad18000000000000
+rk19:	.octa		0xe7b50000000000006ee3000000000000
diff --git a/arch/arm64/crypto/crct10dif-ce-glue.c b/arch/arm64/crypto/crct10dif-ce-glue.c
new file mode 100644
index 000000000000..735678884194
--- /dev/null
+++ b/arch/arm64/crypto/crct10dif-ce-glue.c
@@ -0,0 +1,91 @@
+/*
+ * Accelerated CRC-T10DIF using arm64 NEON and Crypto Extensions instructions
+ *
+ * Copyright (C) 2016 Linaro Ltd <ard.biesheuvel@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/cpufeature.h>
+#include <linux/crc-t10dif.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/string.h>
+
+#include <crypto/internal/hash.h>
+
+#include <asm/neon.h>
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
+	if (length >= CRC_T10DIF_PMULL_CHUNK_SIZE) {
+		unsigned int l = length & ~(CRC_T10DIF_PMULL_CHUNK_SIZE - 1);
+
+		kernel_neon_begin_partial(14);
+		*crc = crc_t10dif_pmull(*crc, data, l);
+		kernel_neon_end();
+
+		data += l;
+	}
+	if (length % CRC_T10DIF_PMULL_CHUNK_SIZE)
+		*crc = crc_t10dif_generic(*crc, data,
+					  length % CRC_T10DIF_PMULL_CHUNK_SIZE);
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
+	.base.cra_driver_name	= "crct10dif-arm64-ce",
+	.base.cra_priority	= 200,
+	.base.cra_blocksize	= CRC_T10DIF_BLOCK_SIZE,
+	.base.cra_module	= THIS_MODULE,
+};
+
+static int __init crc_t10dif_mod_init(void)
+{
+	return crypto_register_shash(&crc_t10dif_alg);
+}
+
+static void __exit crc_t10dif_mod_exit(void)
+{
+	crypto_unregister_shash(&crc_t10dif_alg);
+}
+
+module_cpu_feature_match(PMULL, crc_t10dif_mod_init);
+module_exit(crc_t10dif_mod_exit);
+
+MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
+MODULE_LICENSE("GPL v2");
-- 
2.7.4
