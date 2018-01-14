From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 2/3] crypto/arm64: sha3 - new scalar + v8.2 Crypto Extensions implementation
Date: Sun, 14 Jan 2018 16:41:17 +0000
Message-ID: <20180114164118.18330-3-ard.biesheuvel@linaro.org>
References: <20180114164118.18330-1-ard.biesheuvel@linaro.org>
Cc: herbert@gondor.apana.org.au, will.deacon@arm.com,
        catalin.marinas@arm.com, steve.capper@linaro.org,
        jgarzik@redhat.com, arnd@arndb.de,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:37415 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751759AbeANQlf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 14 Jan 2018 11:41:35 -0500
Received: by mail-wr0-f195.google.com with SMTP id f8so9424782wre.4
        for <linux-crypto@vger.kernel.org>; Sun, 14 Jan 2018 08:41:34 -0800 (PST)
In-Reply-To: <20180114164118.18330-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Implement the various flavours of SHA3 using scalar instructions, and
using the new optional EOR3/RAX1/XAR/BCAX instructions introduced by
ARMv8.2.

Note that the scalar asm version is *much* faster than the C based
generic implementation: the SHA3 state matrix already occupies 25
registers, leaving very little to perform the computation, and the
compiler appears to give up and spill the state to memory.

  Performance comparison of SHA3-256 (cycles per byte)

                        generic     scalar arm64     speedup
  Cortex-A53 @ 1GHz    224.4 cpb      12.4 cpb        18.1x
  Cortex-A57 @ 2GHz    101.6 cpb      11.8 cpb         8.6x

The ARMv8.2 version has only been tested against emulators, so no
performance data is available yet.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/Kconfig           |   4 +
 arch/arm64/crypto/Makefile          |   3 +
 arch/arm64/crypto/sha3-arm64-core.S | 512 ++++++++++++++++++++
 arch/arm64/crypto/sha3-arm64-glue.c | 192 ++++++++
 4 files changed, 711 insertions(+)

diff --git a/arch/arm64/crypto/Kconfig b/arch/arm64/crypto/Kconfig
index aad288f4b9de..71293e049a5d 100644
--- a/arch/arm64/crypto/Kconfig
+++ b/arch/arm64/crypto/Kconfig
@@ -35,6 +35,10 @@ config CRYPTO_SHA512_ARM64_CE
 	select CRYPTO_HASH
 	select CRYPTO_SHA512_ARM64
 
+config CRYPTO_SHA3_ARM64
+	tristate "SHA3 digest algorithm (scalar + ARMv8.2 Crypto Extensions)"
+	select CRYPTO_HASH
+
 config CRYPTO_GHASH_ARM64_CE
 	tristate "GHASH/AES-GCM using ARMv8 Crypto Extensions"
 	depends on KERNEL_MODE_NEON
diff --git a/arch/arm64/crypto/Makefile b/arch/arm64/crypto/Makefile
index d7573d31d397..267764473ef6 100644
--- a/arch/arm64/crypto/Makefile
+++ b/arch/arm64/crypto/Makefile
@@ -17,6 +17,9 @@ sha2-ce-y := sha2-ce-glue.o sha2-ce-core.o
 obj-$(CONFIG_CRYPTO_SHA512_ARM64_CE) += sha512-ce.o
 sha512-ce-y := sha512-ce-glue.o sha512-ce-core.o
 
+obj-$(CONFIG_CRYPTO_SHA3_ARM64) += sha3-arm64.o
+sha3-arm64-y := sha3-arm64-glue.o sha3-arm64-core.o
+
 obj-$(CONFIG_CRYPTO_GHASH_ARM64_CE) += ghash-ce.o
 ghash-ce-y := ghash-ce-glue.o ghash-ce-core.o
 
diff --git a/arch/arm64/crypto/sha3-arm64-core.S b/arch/arm64/crypto/sha3-arm64-core.S
new file mode 100644
index 000000000000..e32f1e3e5b42
--- /dev/null
+++ b/arch/arm64/crypto/sha3-arm64-core.S
@@ -0,0 +1,512 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * sha3-arm64-core.S - core SHA-3 transform using scalar or v8.2 Crypto
+ *                     Extensions instructions
+ *
+ * Copyright (C) 2018 Linaro Ltd <ard.biesheuvel@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/linkage.h>
+#include <asm/assembler.h>
+
+	/*
+	 * sha3_arm64_transform(u64 *st, const u8 *data, int blocks, int dg_size)
+	 */
+	.align		4
+ENTRY(sha3_arm64_transform)
+	/* preserve callee save registers - no room for a frame pointer! */
+	stp		x29, x30, [sp, #-144]!
+	stp		x19, x20, [sp, #16]
+	stp		x21, x22, [sp, #32]
+	stp		x23, x24, [sp, #48]
+	stp		x25, x26, [sp, #64]
+	stp		x27, x28, [sp, #80]
+
+	stp		 x0, x1, [sp, #96]	// preserve st, data
+	str		 x3, [sp, #112]		// preserve dg_size
+	mov		x30, x2			// preserve #blocks
+
+	/* load state */
+	mov		x25,  x0
+	ldp		 x0,  x1, [x0]
+	ldp		 x2,  x3, [x25, #16]
+	ldp		 x4,  x5, [x25, #32]
+	ldp		 x6,  x7, [x25, #48]
+	ldp		 x8,  x9, [x25, #64]
+	ldp		x10, x11, [x25, #80]
+	ldp		x12, x13, [x25, #96]
+	ldp		x14, x15, [x25, #112]
+	ldp		x16, x17, [x25, #128]
+	ldp		x18, x19, [x25, #144]
+	ldp		x20, x21, [x25, #160]
+	ldp		x22, x23, [x25, #176]
+	ldr		x24, [x25, #192]
+
+0:	adr_l		x29, .Lsha3_rcon + 72
+	stp		x29, x30, [sp, #120]	// preserve rc pointer, #blocks
+	ldp		x29, x30, [sp, #104]	// load data, dg_size
+
+	/* load input */
+	ldp		x25, x26, [x29], #32
+	ldp		x27, x28, [x29, #-16]
+CPU_BE(	rev		x25, x25		)
+CPU_BE(	rev		x26, x26		)
+CPU_BE(	rev		x27, x27		)
+CPU_BE(	rev		x28, x28		)
+	eor		 x0,  x0, x25
+	eor		 x1,  x1, x26
+	eor		 x2,  x2, x27
+	eor		 x3,  x3, x28
+
+	ldp		x25, x26, [x29], #24
+	ldr		x27, [x29, #-8]
+CPU_BE(	rev		x25, x25		)
+CPU_BE(	rev		x26, x26		)
+CPU_BE(	rev		x27, x27		)
+	eor		 x4,  x4, x25
+	eor		 x5,  x5, x26
+	eor		 x6,  x6, x27
+
+	tbnz		x30, #6, 2f		// SHA3-512
+
+	ldp		x25, x26, [x29], #32
+	ldp		x27, x28, [x29, #-16]
+CPU_BE(	rev		x25, x25		)
+CPU_BE(	rev		x26, x26		)
+CPU_BE(	rev		x27, x27		)
+CPU_BE(	rev		x28, x28		)
+	eor		 x7,  x7, x25
+	eor		 x8,  x8, x26
+	eor		 x9,  x9, x27
+	eor		x10, x10, x28
+
+	ldp		x25, x26, [x29], #16
+CPU_BE(	rev		x25, x25		)
+CPU_BE(	rev		x26, x26		)
+	eor		x11, x11, x25
+	eor		x12, x12, x26
+
+	tbnz		x30, #4, 1f		// SHA3-384 or SHA3-224
+
+	// SHA3-256
+	ldp		x25, x26, [x29], #32
+	ldp		x27, x28, [x29, #-16]
+CPU_BE(	rev		x25, x25		)
+CPU_BE(	rev		x26, x26		)
+CPU_BE(	rev		x27, x27		)
+CPU_BE(	rev		x28, x28		)
+	eor		x13, x13, x25
+	eor		x14, x14, x26
+	eor		x15, x15, x27
+	eor		x16, x16, x28
+	b		3f
+
+1:	tbz		x30, #2, 3f		// bit 2 cleared? SHA-384
+
+	// SHA3-224
+	ldp		x25, x26, [x29], #40
+	ldp		x27, x28, [x29, #-24]
+	ldr		x30, [x29, #-8]
+CPU_BE(	rev		x25, x25		)
+CPU_BE(	rev		x26, x26		)
+CPU_BE(	rev		x27, x27		)
+CPU_BE(	rev		x28, x28		)
+CPU_BE(	rev		x30, x30		)
+	eor		x13, x13, x25
+	eor		x14, x14, x26
+	eor		x15, x15, x27
+	eor		x16, x16, x28
+	eor		x17, x17, x30
+	b		3f
+
+	// SHA3-512
+2:	ldp		x25, x26, [x29], #16
+CPU_BE(	rev		x25, x25		)
+CPU_BE(	rev		x26, x26		)
+	eor		 x7,  x7, x25
+	eor		 x8,  x8, x26
+
+3:	str		x29, [sp, #104]		// preserve data pointer
+
+	/* inner loop */
+4:	eor		x29,  x4,  x9
+	eor		x26,  x1,  x6
+	eor		x28,  x3,  x8
+	eor		x25,  x0,  x5
+	eor		x27,  x2,  x7
+	eor		x29, x29, x14
+	eor		x26, x26, x11
+	eor		x28, x28, x13
+	eor		x25, x25, x10
+	eor		x27, x27, x12
+	eor		x29, x29, x19
+	eor		x26, x26, x16
+	eor		x28, x28, x18
+	eor		x25, x25, x15
+	eor		x27, x27, x17
+	eor		x29, x29, x24
+	eor		x26, x26, x21
+	eor		x28, x28, x23
+	eor		x25, x25, x20
+	eor		x27, x27, x22
+
+	eor		x30, x29, x26, ror #63	// bc[0]
+	eor		x26, x26, x28, ror #63	// bc[2]
+	eor		x28, x28, x25, ror #63	// bc[4]
+	eor		x25, x25, x27, ror #63	// bc[1]
+	eor		x27, x27, x29, ror #63	// bc[3]
+
+	eor		 x0,  x0, x30
+	eor		x29,  x6, x25
+	eor		 x6,  x9, x28
+	eor		 x9, x22, x26
+	eor		x22, x14, x28
+	eor		x14, x20, x30
+	eor		x20,  x2, x26
+	eor		 x2, x12, x26
+	eor		x12, x13, x27
+	eor		x13, x19, x28
+	eor		x19, x23, X27
+	eor		x23, x15, x30
+	eor		x15,  x4, x28
+	eor		 x4, x24, x28
+	eor		x24, x21, x25
+	eor		x21,  x8, x27
+	eor		 x8, x16, x25
+	eor		x16,  x5, x30
+	eor		 x5,  x3, x27
+	eor		 x3, x18, x27
+	eor		x18, x17, x26
+	eor		x17, x11, x25
+	eor		x11,  x7, x26
+	eor		 x7, x10, x30
+	eor		x10,  x1, x25
+
+	ldr		x30, [sp, #120]		// load rc pointer
+
+	ror		 x1, x29, #(64 - 44)
+	ror		 x6,  x6, #(64 - 20)
+	ror		 x9,  x9, #(64 - 61)
+	ror		x22, x22, #(64 - 39)
+	ror		x14, x14, #(64 - 18)
+	ror		x20, x20, #(64 - 62)
+	ror		 x2,  x2, #(64 - 43)
+	ror		x12, x12, #(64 - 25)
+	ror		x13, x13, #(64 - 8)
+	ror		x19, x19, #(64 - 56)
+	ror		x23, x23, #(64 - 41)
+	ror		x15, x15, #(64 - 27)
+	ror		 x4,  x4, #(64 - 14)
+	ror		x24, x24, #(64 - 2)
+	ror		x21, x21, #(64 - 55)
+	ror		 x8,  x8, #(64 - 45)
+	ror		x16, x16, #(64 - 36)
+	ror		 x5,  x5, #(64 - 28)
+	ror		 x3,  x3, #(64 - 21)
+	ror		x18, x18, #(64 - 15)
+	ror		x17, x17, #(64 - 10)
+	ror		x11, x11, #(64 - 6)
+	ror		 x7,  x7, #(64 - 3)
+	ror		x10, x10, #(64 - 1)
+
+	add		x29, x30, #8		// advance rc pointer
+	tst		x30, #0xff		// last round?
+	ldr		x30, [x30, #-72]	// load rc
+	str		x29, [sp, #120]		// store rc pointer
+
+	bic		x25,  x2,  x1
+	bic		x26,  x3,  x2
+	bic		x27,  x4,  x3
+	bic		x28,  x0,  x4
+	bic		x29,  x1,  x0
+	eor		 x0,  x0, x25
+	eor		 x1,  x1, x26
+	eor		 x2,  x2, x27
+	eor		 x3,  x3, x28
+	eor		 x4,  x4, x29
+
+	bic		x25,  x7,  x6
+	bic		x26,  x8,  x7
+	bic		x27,  x9,  x8
+	bic		x28,  x5,  x9
+	bic		x29,  x6,  x5
+	eor		 x5,  x5, x25
+	eor		 x6,  x6, x26
+	eor		 x7,  x7, x27
+	eor		 x8,  x8, x28
+	eor		 x9,  x9, x29
+
+	bic		x25, x12, x11
+	bic		x26, x13, x12
+	bic		x27, x14, x13
+	bic		x28, x10, x14
+	bic		x29, x11, x10
+	eor		x10, x10, x25
+	eor		x11, x11, x26
+	eor		x12, x12, x27
+	eor		x13, x13, x28
+	eor		x14, x14, x29
+
+	eor		 x0,  x0, x30		// iota
+	ldr		x30, [sp, #128]		// preload #blocks
+
+	bic		x25, x17, x16
+	bic		x26, x18, x17
+	bic		x27, x19, x18
+	bic		x28, x15, x19
+	bic		x29, x16, x15
+	eor		x15, x15, x25
+	eor		x16, x16, x26
+	eor		x17, x17, x27
+	eor		x18, x18, x28
+	eor		x19, x19, x29
+
+	bic		x25, x22, x21
+	bic		x26, x23, x22
+	bic		x27, x24, x23
+	bic		x28, x20, x24
+	bic		x29, x21, x20
+	eor		x20, x20, x25
+	eor		x21, x21, x26
+	eor		x22, x22, x27
+	eor		x23, x23, x28
+	eor		x24, x24, x29
+
+	b.ne		4b
+
+	subs		x30, x30, #1
+	b.ne		0b
+
+	/* save state */
+	ldr		x25, [sp, #96]
+	stp		 x0,  x1, [x25]
+	stp		 x2,  x3, [x25, #16]
+	stp		 x4,  x5, [x25, #32]
+	stp		 x6,  x7, [x25, #48]
+	stp		 x8,  x9, [x25, #64]
+	stp		x10, x11, [x25, #80]
+	stp		x12, x13, [x25, #96]
+	stp		x14, x15, [x25, #112]
+	stp		x16, x17, [x25, #128]
+	stp		x18, x19, [x25, #144]
+	stp		x20, x21, [x25, #160]
+	stp		x22, x23, [x25, #176]
+	str		x24, [x25, #192]
+
+	/* restore callee save registers */
+	ldp		x19, x20, [sp, #16]
+	ldp		x21, x22, [sp, #32]
+	ldp		x23, x24, [sp, #48]
+	ldp		x25, x26, [sp, #64]
+	ldp		x27, x28, [sp, #80]
+	ldp		x29, x30, [sp], #144
+	ret
+ENDPROC(sha3_arm64_transform)
+
+	.irp		b,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
+	.set		.Lv\b\().2d, \b
+	.set		.Lv\b\().16b, \b
+	.endr
+
+	/*
+	 * ARMv8.2 Crypto Extensions instructions
+	 */
+	.macro		eor3, rd, rn, rm, ra
+	.inst		0xce000000 | .L\rd | (.L\rn << 5) | (.L\ra << 10) | (.L\rm << 16)
+	.endm
+
+	.macro		rax1, rd, rn, rm
+	.inst		0xce608c00 | .L\rd | (.L\rn << 5) | (.L\rm << 16)
+	.endm
+
+	.macro		bcax, rd, rn, rm, ra
+	.inst		0xce200000 | .L\rd | (.L\rn << 5) | (.L\ra << 10) | (.L\rm << 16)
+	.endm
+
+	.macro		xar, rd, rn, rm, imm6
+	.inst		0xce800000 | .L\rd | (.L\rn << 5) | ((\imm6) << 10) | (.L\rm << 16)
+	.endm
+
+#ifdef CONFIG_KERNEL_MODE_NEON
+	/*
+	 * sha3_ce_transform(u64 *st, const u8 *data, int blocks, int dg_size)
+	 */
+	.text
+	.align		4
+ENTRY(sha3_ce_transform)
+	/* load state */
+	add		x8, x0, #32
+	ld1		{ v0.1d- v3.1d}, [x0]
+	ld1		{ v4.1d- v7.1d}, [x8], #32
+	ld1		{ v8.1d-v11.1d}, [x8], #32
+	ld1		{v12.1d-v15.1d}, [x8], #32
+	ld1		{v16.1d-v19.1d}, [x8], #32
+	ld1		{v20.1d-v23.1d}, [x8], #32
+	ld1		{v24.1d}, [x8]
+
+0:	sub		w2, w2, #1
+	mov		w8, #24
+	adr_l		x9, .Lsha3_rcon
+
+	/* load input */
+	ld1		{v25.8b-v28.8b}, [x1], #32
+	ld1		{v29.8b-v31.8b}, [x1], #24
+	eor		v0.8b, v0.8b, v25.8b
+	eor		v1.8b, v1.8b, v26.8b
+	eor		v2.8b, v2.8b, v27.8b
+	eor		v3.8b, v3.8b, v28.8b
+	eor		v4.8b, v4.8b, v29.8b
+	eor		v5.8b, v5.8b, v30.8b
+	eor		v6.8b, v6.8b, v31.8b
+
+	tbnz		x3, #6, 2f		// SHA3-512
+
+	ld1		{v25.8b-v28.8b}, [x1], #32
+	ld1		{v29.8b-v30.8b}, [x1], #16
+	eor		 v7.8b,  v7.8b, v25.8b
+	eor		 v8.8b,  v8.8b, v26.8b
+	eor		 v9.8b,  v9.8b, v27.8b
+	eor		v10.8b, v10.8b, v28.8b
+	eor		v11.8b, v11.8b, v29.8b
+	eor		v12.8b, v12.8b, v30.8b
+
+	tbnz		x3, #4, 1f		// SHA3-384 or SHA3-224
+
+	// SHA3-256
+	ld1		{v25.8b-v28.8b}, [x1], #32
+	eor		v13.8b, v13.8b, v25.8b
+	eor		v14.8b, v14.8b, v26.8b
+	eor		v15.8b, v15.8b, v27.8b
+	eor		v16.8b, v16.8b, v28.8b
+	b		3f
+
+1:	tbz		x3, #2, 3f		// bit 2 cleared? SHA-384
+
+	// SHA3-224
+	ld1		{v25.8b-v28.8b}, [x1], #32
+	ld1		{v29.8b}, [x1], #8
+	eor		v13.8b, v13.8b, v25.8b
+	eor		v14.8b, v14.8b, v26.8b
+	eor		v15.8b, v15.8b, v27.8b
+	eor		v16.8b, v16.8b, v28.8b
+	eor		v17.8b, v17.8b, v29.8b
+	b		3f
+
+	// SHA3-512
+2:	ld1		{v25.8b-v26.8b}, [x1], #16
+	eor		 v7.8b,  v7.8b, v25.8b
+	eor		 v8.8b,  v8.8b, v26.8b
+
+3:	sub		w8, w8, #1
+
+	eor3		v29.16b,  v4.16b,  v9.16b, v14.16b
+	eor3		v26.16b,  v1.16b,  v6.16b, v11.16b
+	eor3		v28.16b,  v3.16b,  v8.16b, v13.16b
+	eor3		v25.16b,  v0.16b,  v5.16b, v10.16b
+	eor3		v27.16b,  v2.16b,  v7.16b, v12.16b
+	eor3		v29.16b, v29.16b, v19.16b, v24.16b
+	eor3		v26.16b, v26.16b, v16.16b, v21.16b
+	eor3		v28.16b, v28.16b, v18.16b, v23.16b
+	eor3		v25.16b, v25.16b, v15.16b, v20.16b
+	eor3		v27.16b, v27.16b, v17.16b, v22.16b
+
+	rax1		v30.2d, v29.2d, v26.2d	// bc[0]
+	rax1		v26.2d, v26.2d, v28.2d	// bc[2]
+	rax1		v28.2d, v28.2d, v25.2d	// bc[4]
+	rax1		v25.2d, v25.2d, v27.2d	// bc[1]
+	rax1		v27.2d, v27.2d, v29.2d	// bc[3]
+
+	eor		 v0.16b,  v0.16b, v30.16b
+	xar		 v29.2d,   v1.2d,  v25.2d, (64 - 1)
+	xar		  v1.2d,   v6.2d,  v25.2d, (64 - 44)
+	xar		  v6.2d,   v9.2d,  v28.2d, (64 - 20)
+	xar		  v9.2d,  v22.2d,  v26.2d, (64 - 61)
+	xar		 v22.2d,  v14.2d,  v28.2d, (64 - 39)
+	xar		 v14.2d,  v20.2d,  v30.2d, (64 - 18)
+	xar		 v31.2d,   v2.2d,  v26.2d, (64 - 62)
+	xar		  v2.2d,  v12.2d,  v26.2d, (64 - 43)
+	xar		 v12.2d,  v13.2d,  v27.2d, (64 - 25)
+	xar		 v13.2d,  v19.2d,  v28.2d, (64 - 8)
+	xar		 v19.2d,  v23.2d,  v27.2d, (64 - 56)
+	xar		 v23.2d,  v15.2d,  v30.2d, (64 - 41)
+	xar		 v15.2d,   v4.2d,  v28.2d, (64 - 27)
+	xar		 v28.2d,  v24.2d,  v28.2d, (64 - 14)
+	xar		 v24.2d,  v21.2d,  v25.2d, (64 - 2)
+	xar		  v8.2d,   v8.2d,  v27.2d, (64 - 55)
+	xar		  v4.2d,  v16.2d,  v25.2d, (64 - 45)
+	xar		 v16.2d,   v5.2d,  v30.2d, (64 - 36)
+	xar		  v5.2d,   v3.2d,  v27.2d, (64 - 28)
+	xar		 v27.2d,  v18.2d,  v27.2d, (64 - 21)
+	xar		  v3.2d,  v17.2d,  v26.2d, (64 - 15)
+	xar		 v25.2d,  v11.2d,  v25.2d, (64 - 10)
+	xar		 v26.2d,   v7.2d,  v26.2d, (64 - 6)
+	xar		 v30.2d,  v10.2d,  v30.2d, (64 - 3)
+
+	bcax		v20.16b, v31.16b, v22.16b,  v8.16b
+	bcax		v21.16b,  v8.16b, v23.16b, v22.16b
+	bcax		v22.16b, v22.16b, v24.16b, v23.16b
+	bcax		v23.16b, v23.16b, v31.16b, v24.16b
+	bcax		v24.16b, v24.16b,  v8.16b, v31.16b
+
+	ld1r		{v31.2d}, [x9], #8
+
+	bcax		v17.16b, v25.16b, v19.16b,  v3.16b
+	bcax		v18.16b,  v3.16b, v15.16b, v19.16b
+	bcax		v19.16b, v19.16b, v16.16b, v15.16b
+	bcax		v15.16b, v15.16b, v25.16b, v16.16b
+	bcax		v16.16b, v16.16b,  v3.16b, v25.16b
+
+	bcax		v10.16b, v29.16b, v12.16b, v26.16b
+	bcax		v11.16b, v26.16b, v13.16b, v12.16b
+	bcax		v12.16b, v12.16b, v14.16b, v13.16b
+	bcax		v13.16b, v13.16b, v29.16b, v14.16b
+	bcax		v14.16b, v14.16b, v26.16b, v29.16b
+
+	bcax		 v7.16b, v30.16b,  v9.16b,  v4.16b
+	bcax		 v8.16b,  v4.16b,  v5.16b,  v9.16b
+	bcax		 v9.16b,  v9.16b,  v6.16b,  v5.16b
+	bcax		 v5.16b,  v5.16b, v30.16b,  v6.16b
+	bcax		 v6.16b,  v6.16b,  v4.16b, v30.16b
+
+	bcax		 v3.16b, v27.16b,  v0.16b, v28.16b
+	bcax		 v4.16b, v28.16b,  v1.16b,  v0.16b
+	bcax		 v0.16b,  v0.16b,  v2.16b,  v1.16b
+	bcax		 v1.16b,  v1.16b, v27.16b,  v2.16b
+	bcax		 v2.16b,  v2.16b, v28.16b, v27.16b
+
+	eor		 v0.16b,  v0.16b, v31.16b
+
+	cbnz		w8, 3b
+	cbnz		w2, 0b
+
+	/* save state */
+	st1		{ v0.1d- v3.1d}, [x0], #32
+	st1		{ v4.1d- v7.1d}, [x0], #32
+	st1		{ v8.1d-v11.1d}, [x0], #32
+	st1		{v12.1d-v15.1d}, [x0], #32
+	st1		{v16.1d-v19.1d}, [x0], #32
+	st1		{v20.1d-v23.1d}, [x0], #32
+	st1		{v24.1d}, [x0]
+	ret
+ENDPROC(sha3_ce_transform)
+#endif
+
+	.section	".rodata", "a"
+	.align		8
+.Lsha3_rcon:
+	.quad		0x0000000000000001, 0x0000000000008082
+	.quad		0x800000000000808a, 0x8000000080008000
+	.quad		0x000000000000808b, 0x0000000080000001
+	.quad		0x8000000080008081, 0x8000000000008009
+	.quad		0x000000000000008a, 0x0000000000000088
+	.quad		0x0000000080008009, 0x000000008000000a
+	.quad		0x000000008000808b, 0x800000000000008b
+	.quad		0x8000000000008089, 0x8000000000008003
+	.quad		0x8000000000008002, 0x8000000000000080
+	.quad		0x000000000000800a, 0x800000008000000a
+	.quad		0x8000000080008081, 0x8000000000008080
+	.quad		0x0000000080000001, 0x8000000080008008
diff --git a/arch/arm64/crypto/sha3-arm64-glue.c b/arch/arm64/crypto/sha3-arm64-glue.c
new file mode 100644
index 000000000000..c4297bab23f0
--- /dev/null
+++ b/arch/arm64/crypto/sha3-arm64-glue.c
@@ -0,0 +1,192 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * sha3-arm64-glue.c - core SHA-3 transform using scalar or v8.2 Crypto
+ *                     Extensions instructions
+ *
+ * Copyright (C) 2018 Linaro Ltd <ard.biesheuvel@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <asm/hwcap.h>
+#include <asm/neon.h>
+#include <asm/simd.h>
+#include <asm/unaligned.h>
+#include <crypto/internal/hash.h>
+#include <crypto/sha3.h>
+#include <linux/cpufeature.h>
+#include <linux/crypto.h>
+#include <linux/module.h>
+
+MODULE_DESCRIPTION("SHA3 secure hash for arm64 (scalar + v8.2 Crypto Extensions)");
+MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
+MODULE_LICENSE("GPL v2");
+
+asmlinkage void sha3_ce_transform(u64 *st, const u8 *data, int blocks,
+				  int md_len);
+
+asmlinkage void sha3_arm64_transform(u64 *st, const u8 *data, int blocks,
+				     int md_len);
+
+static void __ro_after_init
+	(*sha3_transform)(u64 *, const u8 *, int, int) = sha3_arm64_transform;
+
+static void sha3_neon_transform(u64 *st, const u8 *data, int blocks, int md_len)
+{
+	if (may_use_simd()) {
+		kernel_neon_begin();
+		sha3_ce_transform(st, data, blocks, md_len);
+		kernel_neon_end();
+	} else {
+		sha3_arm64_transform(st, data, blocks, md_len);
+	}
+}
+
+static int sha3_init(struct shash_desc *desc)
+{
+	struct sha3_state *sctx = shash_desc_ctx(desc);
+	unsigned int digest_size = crypto_shash_digestsize(desc->tfm);
+
+	sctx->rsiz = 200 - 2 * digest_size;
+	sctx->rsizw = sctx->rsiz / 8;
+	sctx->partial = 0;
+
+	memset(sctx->st, 0, sizeof(sctx->st));
+	return 0;
+}
+
+static int sha3_update(struct shash_desc *desc, const u8 *data,
+		       unsigned int len)
+{
+	struct sha3_state *sctx = shash_desc_ctx(desc);
+	unsigned int digest_size = crypto_shash_digestsize(desc->tfm);
+
+	if ((sctx->partial + len) >= sctx->rsiz) {
+		int blocks;
+
+		if (sctx->partial) {
+			int p = sctx->rsiz - sctx->partial;
+
+			memcpy(sctx->buf + sctx->partial, data, p);
+			sha3_transform(sctx->st, sctx->buf, 1, digest_size);
+
+			data += p;
+			len -= p;
+			sctx->partial = 0;
+		}
+
+		blocks = len / sctx->rsiz;
+		len %= sctx->rsiz;
+
+		if (blocks) {
+			sha3_transform(sctx->st, data, blocks, digest_size);
+			data += blocks * sctx->rsiz;
+		}
+	}
+
+	if (len) {
+		memcpy(sctx->buf + sctx->partial, data, len);
+		sctx->partial += len;
+	}
+	return 0;
+}
+
+static int sha3_final(struct shash_desc *desc, u8 *out)
+{
+	struct sha3_state *sctx = shash_desc_ctx(desc);
+	unsigned int digest_size = crypto_shash_digestsize(desc->tfm);
+	__le64 *digest = (__le64 *)out;
+	int i;
+
+	sctx->buf[sctx->partial++] = 0x06;
+	memset(sctx->buf + sctx->partial, 0, sctx->rsiz - sctx->partial);
+	sctx->buf[sctx->rsiz - 1] |= 0x80;
+
+	sha3_transform(sctx->st, sctx->buf, 1, digest_size);
+
+	for (i = 0; i < digest_size / 8; i++)
+		put_unaligned_le64(sctx->st[i], digest++);
+
+	if (digest_size & 4)
+		put_unaligned_le32(sctx->st[i], (__le32 *)digest);
+
+	*sctx = (struct sha3_state){};
+	return 0;
+}
+
+static struct shash_alg algs[] = { {
+	.digestsize		= SHA3_224_DIGEST_SIZE,
+	.init			= sha3_init,
+	.update			= sha3_update,
+	.final			= sha3_final,
+	.descsize		= sizeof(struct sha3_state),
+	.base.cra_name		= "sha3-224",
+	.base.cra_driver_name	= "sha3-224-arm64",
+	.base.cra_flags		= CRYPTO_ALG_TYPE_SHASH,
+	.base.cra_blocksize	= SHA3_224_BLOCK_SIZE,
+	.base.cra_module	= THIS_MODULE,
+	.base.cra_priority	= 200,
+}, {
+	.digestsize		= SHA3_256_DIGEST_SIZE,
+	.init			= sha3_init,
+	.update			= sha3_update,
+	.final			= sha3_final,
+	.descsize		= sizeof(struct sha3_state),
+	.base.cra_name		= "sha3-256",
+	.base.cra_driver_name	= "sha3-256-arm64",
+	.base.cra_flags		= CRYPTO_ALG_TYPE_SHASH,
+	.base.cra_blocksize	= SHA3_256_BLOCK_SIZE,
+	.base.cra_module	= THIS_MODULE,
+	.base.cra_priority	= 200,
+}, {
+	.digestsize		= SHA3_384_DIGEST_SIZE,
+	.init			= sha3_init,
+	.update			= sha3_update,
+	.final			= sha3_final,
+	.descsize		= sizeof(struct sha3_state),
+	.base.cra_name		= "sha3-384",
+	.base.cra_driver_name	= "sha3-384-arm64",
+	.base.cra_flags		= CRYPTO_ALG_TYPE_SHASH,
+	.base.cra_blocksize	= SHA3_384_BLOCK_SIZE,
+	.base.cra_module	= THIS_MODULE,
+	.base.cra_priority	= 200,
+}, {
+	.digestsize		= SHA3_512_DIGEST_SIZE,
+	.init			= sha3_init,
+	.update			= sha3_update,
+	.final			= sha3_final,
+	.descsize		= sizeof(struct sha3_state),
+	.base.cra_name		= "sha3-512",
+	.base.cra_driver_name	= "sha3-512-arm64",
+	.base.cra_flags		= CRYPTO_ALG_TYPE_SHASH,
+	.base.cra_blocksize	= SHA3_512_BLOCK_SIZE,
+	.base.cra_module	= THIS_MODULE,
+	.base.cra_priority	= 200,
+} };
+
+static int __init sha3_neon_mod_init(void)
+{
+	if (IS_ENABLED(CONFIG_KERNEL_MODE_NEON) && (elf_hwcap & HWCAP_SHA3))
+		sha3_transform = sha3_neon_transform;
+
+	return crypto_register_shashes(algs, ARRAY_SIZE(algs));
+}
+
+static void __exit sha3_neon_mod_fini(void)
+{
+	crypto_unregister_shashes(algs, ARRAY_SIZE(algs));
+}
+
+module_init(sha3_neon_mod_init);
+module_exit(sha3_neon_mod_fini);
+
+MODULE_ALIAS_CRYPTO("sha3-224");
+MODULE_ALIAS_CRYPTO("sha3-224-arm64");
+MODULE_ALIAS_CRYPTO("sha3-256");
+MODULE_ALIAS_CRYPTO("sha3-256-arm64");
+MODULE_ALIAS_CRYPTO("sha3-384");
+MODULE_ALIAS_CRYPTO("sha3-384-arm64");
+MODULE_ALIAS_CRYPTO("sha3-512");
+MODULE_ALIAS_CRYPTO("sha3-512-arm64");
-- 
2.11.0
