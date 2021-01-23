Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64AEBC433DB
	for <linux-crypto@archiver.kernel.org>; Sat, 23 Jan 2021 07:30:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3718E239D4
	for <linux-crypto@archiver.kernel.org>; Sat, 23 Jan 2021 07:30:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726677AbhAWHau (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 23 Jan 2021 02:30:50 -0500
Received: from mga12.intel.com ([192.55.52.136]:5181 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726554AbhAWHas (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 23 Jan 2021 02:30:48 -0500
IronPort-SDR: IgHqt4c2KomdEsU6xKkV2ENeLQZljcWOzrXHkGQvKwL1l3yXypOWj8XGoGdN5kczHNWo1COu0C
 aYT8zcuXHWcw==
X-IronPort-AV: E=McAfee;i="6000,8403,9872"; a="158731942"
X-IronPort-AV: E=Sophos;i="5.79,368,1602572400"; 
   d="scan'208";a="158731942"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2021 23:29:46 -0800
IronPort-SDR: C4MUQXPzs4sRnVAOzAUHR6OELwgYqFQDkLPtPuuxG2afm4N4KFGI7Af/BFbMydztl87Vesg++7
 eRafQ2k/t6OQ==
X-IronPort-AV: E=Sophos;i="5.79,368,1602572400"; 
   d="scan'208";a="468448079"
Received: from megha-z97x-ud7-th.sc.intel.com ([143.183.85.154])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-SHA; 22 Jan 2021 23:29:46 -0800
From:   Megha Dey <megha.dey@intel.com>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net
Cc:     ravi.v.shankar@intel.com, tim.c.chen@intel.com,
        andi.kleen@intel.com, dave.hansen@intel.com, megha.dey@intel.com,
        greg.b.tucker@intel.com, robert.a.kasten@intel.com,
        rajendrakumar.chinnaiyan@intel.com, tomasz.kantecki@intel.com,
        ryan.d.saffores@intel.com, ilya.albrekht@intel.com,
        kyung.min.park@intel.com, tony.luck@intel.com, ira.weiny@intel.com,
        ebiggers@kernel.org, ardb@kernel.org
Subject: [RFC V2 3/5] crypto: crct10dif - Accelerated CRC T10 DIF with vectorized instruction
Date:   Fri, 22 Jan 2021 23:28:38 -0800
Message-Id: <1611386920-28579-4-git-send-email-megha.dey@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1611386920-28579-1-git-send-email-megha.dey@intel.com>
References: <1611386920-28579-1-git-send-email-megha.dey@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Kyung Min Park <kyung.min.park@intel.com>

Update the crc_pcl function that calculates T10 Data Integrity Field
CRC16 (CRC T10 DIF) using VPCLMULQDQ instruction. VPCLMULQDQ instruction
with AVX-512F adds EVEX encoded 512 bit version of PCLMULQDQ instruction.
The advantage comes from packing multiples of 4 * 128 bit data into AVX512
reducing instruction latency.

The glue code in crct10diff module overrides the existing PCLMULQDQ version
with the VPCLMULQDQ version when the following criteria are met:
At compile time:
1. CONFIG_CRYPTO_AVX512 is enabled
2. toolchain(assembler) supports VPCLMULQDQ instructions
At runtime:
1. VPCLMULQDQ and AVX512VL features are supported on a platform (currently
   only Icelake)
2. If compiled as built-in or loadable  module, crct10dif_pclmul.use_avx512
   is set at boot time

A typical run of tcrypt with CRC T10 DIF calculation with PCLMULQDQ
instruction and VPCLMULQDQ instruction shows the following results:
For bytes per update >= 1KB, we see the average improvement of 46%(~1.4x)
For bytes per update < 1KB, we see the average improvement of 13%.
Test was performed on an Icelake based platform with constant frequency
set for CPU.

Detailed results for a variety of block sizes and update sizes are in
the table below.

---------------------------------------------------------------------------
|            |            |         cycles/operation         |            |
|            |            |       (the lower the better)     |            |
|    byte    |   bytes    |----------------------------------| percentage |
|   blocks   | per update |   CRC T10 DIF  |  CRC T10 DIF    | loss/gain  |
|            |            | with PCLMULQDQ | with VPCLMULQDQ |            |
|------------|------------|----------------|-----------------|------------|
|      16    |     16     |        77      |        106      |   -27.0    |
|      64    |     16     |       411      |        390      |     5.4    |
|      64    |     64     |        71      |         85      |   -16.0    |
|     256    |     16     |      1224      |       1308      |    -6.4    |
|     256    |     64     |       393      |        407      |    -3.4    |
|     256    |    256     |        93      |         86      |     8.1    |
|    1024    |     16     |      4564      |       5020      |    -9.0    |
|    1024    |    256     |       486      |        475      |     2.3    |
|    1024    |   1024     |       221      |        148      |    49.3    |
|    2048    |     16     |      8945      |       9851      |    -9.1    |
|    2048    |    256     |       982      |        951      |     3.3    |
|    2048    |   1024     |       500      |        369      |    35.5    |
|    2048    |   2048     |       413      |        265      |    55.8    |
|    4096    |     16     |     17885      |      19351      |    -7.5    |
|    4096    |    256     |      1828      |       1713      |     6.7    |
|    4096    |   1024     |       968      |        805      |    20.0    |
|    4096    |   4096     |       739      |        475      |    55.6    |
|    8192    |     16     |     48339      |      41556      |    16.3    |
|    8192    |    256     |      3494      |       3342      |     4.5    |
|    8192    |   1024     |      1959      |       1462      |    34.0    |
|    8192    |   4096     |      1561      |       1036      |    50.7    |
|    8192    |   8192     |      1540      |       1004      |    53.4    |
---------------------------------------------------------------------------

This work was inspired by the CRC T10 DIF AVX512 optimization published
in Intel Intelligent Storage Acceleration Library.
https://github.com/intel/isa-l/blob/master/crc/crc16_t10dif_by16_10.asm

Co-developed-by: Greg Tucker <greg.b.tucker@intel.com>
Signed-off-by: Greg Tucker <greg.b.tucker@intel.com>
Co-developed-by: Tomasz Kantecki <tomasz.kantecki@intel.com>
Signed-off-by: Tomasz Kantecki <tomasz.kantecki@intel.com>
Signed-off-by: Kyung Min Park <kyung.min.park@intel.com>
Signed-off-by: Megha Dey <megha.dey@intel.com>
---
 arch/x86/crypto/Makefile                  |   1 +
 arch/x86/crypto/crct10dif-avx512-asm_64.S | 482 ++++++++++++++++++++++++++++++
 arch/x86/crypto/crct10dif-pclmul_glue.c   |  17 +-
 arch/x86/include/asm/disabled-features.h  |   8 +-
 crypto/Kconfig                            |  26 ++
 5 files changed, 531 insertions(+), 3 deletions(-)
 create mode 100644 arch/x86/crypto/crct10dif-avx512-asm_64.S

diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index b28e36b..662c16d 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -78,6 +78,7 @@ crc32-pclmul-y := crc32-pclmul_asm.o crc32-pclmul_glue.o
 
 obj-$(CONFIG_CRYPTO_CRCT10DIF_PCLMUL) += crct10dif-pclmul.o
 crct10dif-pclmul-y := crct10dif-pcl-asm_64.o crct10dif-pclmul_glue.o
+crct10dif-pclmul-$(CONFIG_CRYPTO_CRCT10DIF_AVX512) += crct10dif-avx512-asm_64.o
 
 obj-$(CONFIG_CRYPTO_POLY1305_X86_64) += poly1305-x86_64.o
 poly1305-x86_64-y := poly1305-x86_64-cryptogams.o poly1305_glue.o
diff --git a/arch/x86/crypto/crct10dif-avx512-asm_64.S b/arch/x86/crypto/crct10dif-avx512-asm_64.S
new file mode 100644
index 0000000..256de00
--- /dev/null
+++ b/arch/x86/crypto/crct10dif-avx512-asm_64.S
@@ -0,0 +1,482 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/* Copyright(c) 2021 Intel Corporation.
+ *
+ * Implement CRC T10 DIF calculation with AVX512 instructions. (x86_64)
+ *
+ * This is CRC T10 DIF calculation with AVX512 instructions. It requires
+ * the support of Intel(R) AVX512F and VPCLMULQDQ instructions.
+ */
+
+#include <linux/linkage.h>
+
+.text
+#define		init_crc	%edi
+#define		buf		%rsi
+#define		len		%rdx
+#define		VARIABLE_OFFSET 16*2+8
+
+/*
+ * u16 crct10dif-avx512-asm_64(u16 init_crc, const u8 *buf, size_t len);
+ */
+.align 16
+SYM_FUNC_START(crct10dif_pcl_avx512)
+
+	shl		$16, init_crc
+	/*
+	 * The code flow is exactly same as a 32-bit CRC. The only difference
+	 * is before returning eax, we will shift it right 16 bits, to scale
+	 * back to 16 bits.
+	 */
+	sub		$(VARIABLE_OFFSET), %rsp
+
+	vbroadcasti32x4 SHUF_MASK(%rip), %zmm18
+
+	/* For sizes less than 256 bytes, we can't fold 256 bytes at a time. */
+	cmp		$256, len
+	jl		.less_than_256
+
+	/* load the initial crc value */
+	vmovd		init_crc, %xmm10
+
+	/*
+	 * crc value does not need to be byte-reflected, but it needs to be
+	 * moved to the high part of the register because data will be
+	 * byte-reflected and will align with initial crc at correct place.
+	 */
+	vpslldq		$12, %xmm10, %xmm10
+
+	/* receive the initial 64B data, xor the initial crc value. */
+	vmovdqu8	(buf), %zmm0
+	vmovdqu8	16*4(buf), %zmm4
+	vpshufb		%zmm18, %zmm0, %zmm0
+	vpshufb		%zmm18, %zmm4, %zmm4
+	vpxorq		%zmm10, %zmm0, %zmm0
+	vbroadcasti32x4	rk3(%rip), %zmm10
+
+	sub		$256, len
+	cmp		$256, len
+	jl		.fold_128_B_loop
+
+	vmovdqu8	16*8(buf), %zmm7
+	vmovdqu8	16*12(buf), %zmm8
+	vpshufb		%zmm18, %zmm7, %zmm7
+	vpshufb		%zmm18, %zmm8, %zmm8
+	vbroadcasti32x4 rk_1(%rip), %zmm16
+	sub		$256, len
+
+.fold_256_B_loop:
+	add		$256, buf
+	vmovdqu8	(buf), %zmm3
+	vpshufb		%zmm18, %zmm3, %zmm3
+	vpclmulqdq	$0x00, %zmm16, %zmm0, %zmm1
+	vpclmulqdq	$0x11, %zmm16, %zmm0, %zmm2
+	vpxorq		%zmm2, %zmm1, %zmm0
+	vpxorq		%zmm3, %zmm0, %zmm0
+
+	vmovdqu8	16*4(buf), %zmm9
+	vpshufb		%zmm18, %zmm9, %zmm9
+	vpclmulqdq	$0x00, %zmm16, %zmm4, %zmm5
+	vpclmulqdq	$0x11, %zmm16, %zmm4, %zmm6
+	vpxorq		%zmm6, %zmm5, %zmm4
+	vpxorq		%zmm9, %zmm4, %zmm4
+
+	vmovdqu8	16*8(buf), %zmm11
+	vpshufb		%zmm18, %zmm11, %zmm11
+	vpclmulqdq	$0x00, %zmm16, %zmm7, %zmm12
+	vpclmulqdq	$0x11, %zmm16, %zmm7, %zmm13
+	vpxorq		%zmm13, %zmm12, %zmm7
+	vpxorq		%zmm11, %zmm7, %zmm7
+
+	vmovdqu8	16*12(buf), %zmm17
+	vpshufb		%zmm18, %zmm17, %zmm17
+	vpclmulqdq	$0x00, %zmm16, %zmm8, %zmm14
+	vpclmulqdq	$0x11, %zmm16, %zmm8, %zmm15
+	vpxorq		%zmm15, %zmm14, %zmm8
+	vpxorq		%zmm17, %zmm8, %zmm8
+
+	sub		$256, len
+	jge		.fold_256_B_loop
+
+	/* Fold 256 into 128 */
+	add		$256, buf
+	vpclmulqdq	$0x00, %zmm10, %zmm0, %zmm1
+	vpclmulqdq	$0x11, %zmm10, %zmm0, %zmm2
+	vpternlogq	$0x96, %zmm2, %zmm1, %zmm7
+
+	vpclmulqdq	$0x00, %zmm10, %zmm4, %zmm5
+	vpclmulqdq	$0x11, %zmm10, %zmm4, %zmm6
+	vpternlogq	$0x96, %zmm6, %zmm5, %zmm8
+
+	vmovdqa32	%zmm7, %zmm0
+	vmovdqa32	%zmm8, %zmm4
+
+	add		$128, len
+	jmp		.fold_128_B_register
+
+	/*
+	 * At this section of the code, there is 128*x + y (0 <= y < 128) bytes
+	 * of buffer. The fold_128_B_loop will fold 128B at a time until we have
+	 * 128 + y Bytes of buffer.
+	 * Fold 128B at a time. This section of the code folds 8 xmm registers
+	 * in parallel.
+	 */
+.fold_128_B_loop:
+	add		$128, buf
+	vmovdqu8	(buf), %zmm8
+	vpshufb		%zmm18, %zmm8, %zmm8
+	vpclmulqdq	$0x00, %zmm10, %zmm0, %zmm2
+	vpclmulqdq	$0x11, %zmm10, %zmm0, %zmm1
+	vpxorq		%zmm1, %zmm2, %zmm0
+	vpxorq		%zmm8, %zmm0, %zmm0
+
+	vmovdqu8	16*4(buf), %zmm9
+	vpshufb		%zmm18, %zmm9, %zmm9
+	vpclmulqdq	$0x00, %zmm10, %zmm4, %zmm5
+	vpclmulqdq	$0x11, %zmm10, %zmm4, %zmm6
+	vpxorq		%zmm6, %zmm5, %zmm4
+	vpxorq		%zmm9, %zmm4, %zmm4
+
+	sub		$128, len
+	jge		.fold_128_B_loop
+
+	add		$128, buf
+
+	/*
+	 * At this point, the buffer pointer is pointing at the last y Bytes
+	 * of the buffer, where 0 <= y < 128. The 128B of folded data is in
+	 * 8 of the xmm registers: xmm0 - xmm7.
+	 */
+.fold_128_B_register:
+	/* fold the 8 128b parts into 1 xmm register with different constant. */
+	vmovdqu8	rk9(%rip), %zmm16
+	vmovdqu8	rk17(%rip), %zmm11
+	vpclmulqdq	$0x00, %zmm16, %zmm0, %zmm1
+	vpclmulqdq	$0x11, %zmm16, %zmm0, %zmm2
+	vextracti64x2	$3, %zmm4, %xmm7
+
+	vpclmulqdq	$0x00, %zmm11, %zmm4, %zmm5
+	vpclmulqdq	$0x11, %zmm11, %zmm4, %zmm6
+	vmovdqa		rk1(%rip), %xmm10
+	vpternlogq	$0x96, %zmm5, %zmm2, %zmm1
+	vpternlogq	$0x96, %zmm7, %zmm6, %zmm1
+
+	vshufi64x2      $0x4e, %zmm1, %zmm1, %zmm8
+	vpxorq          %ymm1, %ymm8, %ymm8
+	vextracti64x2   $1, %ymm8, %xmm5
+	vpxorq          %xmm8, %xmm5, %xmm7
+
+	/*
+	 * Instead of 128, we add 128 - 16 to the loop counter to save one
+	 * instruction from the loop. Instead of a cmp instruction, we use
+	 * the negative flag with the jl instruction.
+	 */
+	add		$(128 - 16), len
+	jl		.final_reduction_for_128
+
+	/*
+	 * Now we have 16 + y bytes left to reduce. 16 Bytes is in register xmm7
+	 * and the rest is in memory we can fold 16 bytes at a time if y >= 16.
+	 * continue folding 16B at a time.
+	 */
+.16B_reduction_loop:
+	vpclmulqdq	$0x11, %xmm10, %xmm7, %xmm8
+	vpclmulqdq	$0x00, %xmm10, %xmm7, %xmm7
+	vpxor		%xmm8, %xmm7, %xmm7
+	vmovdqu		(buf), %xmm0
+	vpshufb		%xmm18, %xmm0, %xmm0
+	vpxor		%xmm0, %xmm7, %xmm7
+	add		$16, buf
+	sub		$16, len
+
+	/*
+	 * Instead of a cmp instruction, we utilize the flags with the jge
+	 * instruction equivalent of: cmp len, 16-16. Check if there is any
+	 * more 16B in the buffer to be able to fold.
+	 */
+	jge		.16B_reduction_loop
+
+	/*
+	 * now we have 16+z bytes left to reduce, where 0 <= z < 16.
+	 * first, we reduce the data in the xmm7 register.
+	 */
+.final_reduction_for_128:
+	add		$16, len
+	je		.128_done
+
+	/*
+	 * Here we are getting data that is less than 16 bytes. since we know
+	 * that there was data before the pointer, we can offset the input
+	 * pointer before the actual point to receive exactly 16 bytes.
+	 * After that, the registers need to be adjusted.
+	 */
+.get_last_two_xmms:
+	vmovdqa		%xmm7, %xmm2
+	vmovdqu		-16(buf, len), %xmm1
+	vpshufb		%xmm18, %xmm1, %xmm1
+
+	/*
+	 * get rid of the extra data that was loaded before.
+	 * load the shift constant
+	 */
+	lea		16 + pshufb_shf_table(%rip), %rax
+	sub		len, %rax
+	vmovdqu		(%rax), %xmm0
+
+	vpshufb		%xmm0, %xmm2, %xmm2
+	vpxor		mask1(%rip), %xmm0, %xmm0
+	vpshufb		%xmm0, %xmm7, %xmm7
+	vpblendvb	%xmm0, %xmm2, %xmm1, %xmm1
+
+	vpclmulqdq	$0x11, %xmm10, %xmm7, %xmm8
+	vpclmulqdq	$0x00, %xmm10, %xmm7, %xmm7
+	vpxor		%xmm8, %xmm7, %xmm7
+	vpxor		%xmm1, %xmm7, %xmm7
+
+.128_done:
+	/* compute crc of a 128-bit value. */
+	vmovdqa		rk5(%rip), %xmm10
+	vmovdqa		%xmm7, %xmm0
+
+	vpclmulqdq	$0x01, %xmm10, %xmm7, %xmm7
+	vpslldq		$8, %xmm0, %xmm0
+	vpxor		%xmm0, %xmm7, %xmm7
+
+	vmovdqa		%xmm7, %xmm0
+	vpand		mask2(%rip), %xmm0, %xmm0
+	vpsrldq		$12, %xmm7, %xmm7
+	vpclmulqdq	$0x10, %xmm10, %xmm7, %xmm7
+	vpxor		%xmm0, %xmm7, %xmm7
+
+	/* barrett reduction */
+.barrett:
+	vmovdqa		rk7(%rip), %xmm10
+	vmovdqa		%xmm7, %xmm0
+	vpclmulqdq	$0x01, %xmm10, %xmm7, %xmm7
+	vpslldq		$4, %xmm7, %xmm7
+	vpclmulqdq	$0x11, %xmm10, %xmm7, %xmm7
+
+	vpslldq		$4, %xmm7, %xmm7
+	vpxor		%xmm0, %xmm7, %xmm7
+	vpextrd		$1, %xmm7, %eax
+
+.cleanup:
+	/* scale the result back to 16 bits. */
+	shr		$16, %eax
+	add		$(VARIABLE_OFFSET), %rsp
+	ret
+
+.align 16
+.less_than_256:
+	/* check if there is enough buffer to be able to fold 16B at a time. */
+	cmp		$32, len
+	jl		.less_than_32
+
+	/* If there is, load the constants. */
+	vmovdqa		rk1(%rip), %xmm10
+
+	/*
+	 * get the initial crc value and align it to its correct place.
+	 * And load the plaintext and byte-reflect it.
+	 */
+	vmovd		init_crc, %xmm0
+	vpslldq		$12, %xmm0, %xmm0
+	vmovdqu		(buf), %xmm7
+	vpshufb		%xmm18, %xmm7, %xmm7
+	vpxor		%xmm0, %xmm7, %xmm7
+
+	/* update the buffer pointer */
+	add		$16, buf
+
+	/* subtract 32 instead of 16 to save one instruction from the loop */
+	sub		$32, len
+
+	jmp		.16B_reduction_loop
+
+.align 16
+.less_than_32:
+	/*
+	 * mov initial crc to the return value. This is necessary for
+	 * zero-length buffers.
+	 */
+	mov		init_crc, %eax
+	test		len, len
+	je		.cleanup
+
+	vmovd		init_crc, %xmm0
+	vpslldq		$12, %xmm0, %xmm0
+
+	cmp		$16, len
+	je		.exact_16_left
+	jl		.less_than_16_left
+
+	vmovdqu		(buf), %xmm7
+	vpshufb		%xmm18, %xmm7, %xmm7
+	vpxor		%xmm0, %xmm7, %xmm7
+	add		$16, buf
+	sub		$16, len
+	vmovdqa		rk1(%rip), %xmm10
+	jmp		.get_last_two_xmms
+
+.align 16
+.less_than_16_left:
+	/*
+	 * use stack space to load data less than 16 bytes, zero-out the 16B
+	 * in the memory first.
+	 */
+	vpxor		%xmm1, %xmm1, %xmm1
+	mov		%rsp, %r11
+	vmovdqa		%xmm1, (%r11)
+
+	cmp		$4, len
+	jl		.only_less_than_4
+
+	mov		len, %r9
+	cmp		$8, len
+	jl		.less_than_8_left
+
+	mov		(buf), %rax
+	mov		%rax, (%r11)
+	add		$8, %r11
+	sub		$8, len
+	add		$8, buf
+.less_than_8_left:
+	cmp		$4, len
+	jl		.less_than_4_left
+
+	mov		(buf), %eax
+	mov		%eax, (%r11)
+	add		$4, %r11
+	sub		$4, len
+	add		$4, buf
+
+.less_than_4_left:
+	cmp		$2, len
+	jl		.less_than_2_left
+
+	mov		(buf), %ax
+	mov		%ax, (%r11)
+	add		$2, %r11
+	sub		$2, len
+	add		$2, buf
+.less_than_2_left:
+	cmp		$1, len
+	jl		.zero_left
+
+	mov		(buf), %al
+	mov		%al, (%r11)
+
+.zero_left:
+	vmovdqa		(%rsp), %xmm7
+	vpshufb		%xmm18, %xmm7, %xmm7
+	vpxor		%xmm0, %xmm7, %xmm7
+
+	lea		16 + pshufb_shf_table(%rip), %rax
+	sub		%r9, %rax
+	vmovdqu		(%rax), %xmm0
+	vpxor		mask1(%rip), %xmm0, %xmm0
+
+	vpshufb		%xmm0,%xmm7, %xmm7
+	jmp		.128_done
+
+.align 16
+.exact_16_left:
+	vmovdqu		(buf), %xmm7
+	vpshufb		%xmm18, %xmm7, %xmm7
+	vpxor		%xmm0, %xmm7, %xmm7
+	jmp		.128_done
+
+.only_less_than_4:
+	cmp		$3, len
+	jl		.only_less_than_3
+
+	mov		(buf), %al
+	mov		%al, (%r11)
+
+	mov		1(buf), %al
+	mov		%al, 1(%r11)
+
+	mov		2(buf), %al
+	mov		%al, 2(%r11)
+
+	vmovdqa		(%rsp), %xmm7
+	vpshufb		%xmm18, %xmm7, %xmm7
+	vpxor		%xmm0, %xmm7, %xmm7
+
+	vpsrldq		$5, %xmm7, %xmm7
+	jmp		.barrett
+
+.only_less_than_3:
+	cmp		$2, len
+	jl		.only_less_than_2
+
+	mov		(buf), %al
+	mov		%al, (%r11)
+
+	mov		1(buf), %al
+	mov		%al, 1(%r11)
+
+	vmovdqa		(%rsp), %xmm7
+	vpshufb		%xmm18, %xmm7, %xmm7
+	vpxor		%xmm0, %xmm7, %xmm7
+
+	vpsrldq		$6, %xmm7, %xmm7
+	jmp		.barrett
+
+.only_less_than_2:
+	mov		(buf), %al
+	mov		%al, (%r11)
+
+	vmovdqa		(%rsp), %xmm7
+	vpshufb		%xmm18, %xmm7, %xmm7
+	vpxor		%xmm0, %xmm7, %xmm7
+
+	vpsrldq		$7, %xmm7, %xmm7
+	jmp		.barrett
+SYM_FUNC_END(crct10dif_pcl_avx512)
+
+.section        .data
+.align 32
+rk_1:		.quad 0xdccf000000000000
+rk_2:		.quad 0x4b0b000000000000
+rk1:		.quad 0x2d56000000000000
+rk2:		.quad 0x06df000000000000
+rk3:		.quad 0x9d9d000000000000
+rk4:		.quad 0x7cf5000000000000
+rk5:		.quad 0x2d56000000000000
+rk6:		.quad 0x1368000000000000
+rk7:		.quad 0x00000001f65a57f8
+rk8:		.quad 0x000000018bb70000
+rk9:		.quad 0xceae000000000000
+rk10:		.quad 0xbfd6000000000000
+rk11:		.quad 0x1e16000000000000
+rk12:		.quad 0x713c000000000000
+rk13:		.quad 0xf7f9000000000000
+rk14:		.quad 0x80a6000000000000
+rk15:		.quad 0x044c000000000000
+rk16:		.quad 0xe658000000000000
+rk17:		.quad 0xad18000000000000
+rk18:		.quad 0xa497000000000000
+rk19:		.quad 0x6ee3000000000000
+rk20:		.quad 0xe7b5000000000000
+rk_1b:		.quad 0x2d56000000000000
+rk_2b:		.quad 0x06df000000000000
+		.quad 0x0000000000000000
+		.quad 0x0000000000000000
+
+.align 16
+mask1:
+	.octa	0x80808080808080808080808080808080
+
+.align 16
+mask2:
+	.octa	0x00000000FFFFFFFFFFFFFFFFFFFFFFFF
+
+.align 16
+SHUF_MASK:
+	.octa	0x000102030405060708090A0B0C0D0E0F
+
+.align 16
+pshufb_shf_table:	.octa 0x8f8e8d8c8b8a89888786858483828100
+			.octa 0x000e0d0c0b0a09080706050403020100
+			.octa 0x0f0e0d0c0b0a09088080808080808080
+			.octa 0x80808080808080808080808080808080
diff --git a/arch/x86/crypto/crct10dif-pclmul_glue.c b/arch/x86/crypto/crct10dif-pclmul_glue.c
index 71291d5a..a546c4f 100644
--- a/arch/x86/crypto/crct10dif-pclmul_glue.c
+++ b/arch/x86/crypto/crct10dif-pclmul_glue.c
@@ -33,8 +33,16 @@
 #include <asm/cpufeatures.h>
 #include <asm/cpu_device_id.h>
 #include <asm/simd.h>
+#include <linux/static_call.h>
 
 asmlinkage u16 crc_t10dif_pcl(u16 init_crc, const u8 *buf, size_t len);
+asmlinkage u16 crct10dif_pcl_avx512(u16 init_crc, const u8 *buf, size_t len);
+
+DEFINE_STATIC_CALL(crc_t10dif, crc_t10dif_pcl);
+
+static bool use_avx512;
+module_param(use_avx512, bool, 0644);
+MODULE_PARM_DESC(use_avx512, "Use AVX512 optimized algorithm, if available");
 
 struct chksum_desc_ctx {
 	__u16 crc;
@@ -56,7 +64,7 @@ static int chksum_update(struct shash_desc *desc, const u8 *data,
 
 	if (length >= 16 && crypto_simd_usable()) {
 		kernel_fpu_begin();
-		ctx->crc = crc_t10dif_pcl(ctx->crc, data, length);
+		ctx->crc = static_call(crc_t10dif)(ctx->crc, data, length);
 		kernel_fpu_end();
 	} else
 		ctx->crc = crc_t10dif_generic(ctx->crc, data, length);
@@ -75,7 +83,7 @@ static int __chksum_finup(__u16 crc, const u8 *data, unsigned int len, u8 *out)
 {
 	if (len >= 16 && crypto_simd_usable()) {
 		kernel_fpu_begin();
-		*(__u16 *)out = crc_t10dif_pcl(crc, data, len);
+		*(__u16 *)out = static_call(crc_t10dif)(crc, data, len);
 		kernel_fpu_end();
 	} else
 		*(__u16 *)out = crc_t10dif_generic(crc, data, len);
@@ -124,6 +132,11 @@ static int __init crct10dif_intel_mod_init(void)
 	if (!x86_match_cpu(crct10dif_cpu_id))
 		return -ENODEV;
 
+	if (IS_ENABLED(CONFIG_CRYPTO_CRCT10DIF_AVX512) &&
+	    cpu_feature_enabled(X86_FEATURE_VPCLMULQDQ) &&
+	    use_avx512)
+		static_call_update(crc_t10dif, crct10dif_pcl_avx512);
+
 	return crypto_register_shash(&alg);
 }
 
diff --git a/arch/x86/include/asm/disabled-features.h b/arch/x86/include/asm/disabled-features.h
index 7947cb1..e6e3b9f 100644
--- a/arch/x86/include/asm/disabled-features.h
+++ b/arch/x86/include/asm/disabled-features.h
@@ -56,6 +56,12 @@
 # define DISABLE_PTI		(1 << (X86_FEATURE_PTI & 31))
 #endif
 
+#if defined(CONFIG_AS_VPCLMULQDQ)
+# define DISABLE_VPCLMULQDQ	0
+#else
+# define DISABLE_VPCLMULQDQ	(1 << (X86_FEATURE_VPCLMULQDQ & 31))
+#endif
+
 #ifdef CONFIG_IOMMU_SUPPORT
 # define DISABLE_ENQCMD	0
 #else
@@ -88,7 +94,7 @@
 #define DISABLED_MASK14	0
 #define DISABLED_MASK15	0
 #define DISABLED_MASK16	(DISABLE_PKU|DISABLE_OSPKE|DISABLE_LA57|DISABLE_UMIP| \
-			 DISABLE_ENQCMD)
+			 DISABLE_ENQCMD|DISABLE_VPCLMULQDQ)
 #define DISABLED_MASK17	0
 #define DISABLED_MASK18	0
 #define DISABLED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 19)
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 94f0fde..3059b07 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -608,6 +608,32 @@ config CRYPTO_CRC32C_VPMSUM
 	  (vpmsum) instructions, introduced in POWER8. Enable on POWER8
 	  and newer processors for improved performance.
 
+config CRYPTO_AVX512
+	bool "AVX512 hardware acceleration for crypto algorithms"
+	depends on X86
+	depends on 64BIT
+	help
+	  This option will compile in AVX512 hardware accelerated crypto
+	  algorithms. These optimized algorithms provide substantial(2-10x)
+	  improvements over existing crypto algorithms for large data size.
+	  However, it may also incur a frequency penalty (aka. "bin drops")
+	  and cause collateral damage to other workloads running on the
+	  same core. Only enabling this option will not ensure that AVX512
+	  optimized crypto algorithms are selected. User would also need
+	  to enable the use_avx512 module parameter associated with each
+	  of the AVX512 optimized crypto algorithms
+
+# We default CRYPTO_CRCT10DIF_AVX512 to Y but depend on CRYPTO_AVX512 in
+# order to have a singular option (CRYPTO_AVX512) select multiple algorithms
+# when supported. Specifically, if the platform and/or toolset does not
+# support VPLMULQDQ. Then this algorithm should not be supported as part of
+# the set that CRYPTO_AVX512 selects.
+config CRYPTO_CRCT10DIF_AVX512
+	bool
+	default y
+	depends on CRYPTO_AVX512
+	depends on CRYPTO_CRCT10DIF_PCLMUL
+	depends on AS_VPCLMULQDQ
 
 config CRYPTO_CRC32C_SPARC64
 	tristate "CRC32c CRC algorithm (SPARC64)"
-- 
2.7.4

