Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA90BC3526D
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Dec 2020 21:07:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3C1323B88
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Dec 2020 21:07:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726430AbgLRVHj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Dec 2020 16:07:39 -0500
Received: from mga06.intel.com ([134.134.136.31]:16592 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726288AbgLRVHi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Dec 2020 16:07:38 -0500
IronPort-SDR: pOkTBeu3qt1Ro5S2oFX/EfW0VZgO29LZ6v11Sp3nmPvr9UiiSFVSp93wwwmrasZ9mnoO61U5O4
 G5xyuHFO7elw==
X-IronPort-AV: E=McAfee;i="6000,8403,9839"; a="237075268"
X-IronPort-AV: E=Sophos;i="5.78,431,1599548400"; 
   d="scan'208";a="237075268"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2020 13:06:42 -0800
IronPort-SDR: YzIsv9HfpXbx2zeA36XLYfoa4DKB/L8uzSyfTbxYdDyPWx7kcLoAwGuq54YCyHHm2mfcXW8UR/
 UA50YDrRlq6Q==
X-IronPort-AV: E=Sophos;i="5.78,431,1599548400"; 
   d="scan'208";a="370785947"
Received: from megha-z97x-ud7-th.sc.intel.com ([143.183.85.154])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-SHA; 18 Dec 2020 13:06:42 -0800
From:   Megha Dey <megha.dey@intel.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        ravi.v.shankar@intel.com, tim.c.chen@intel.com,
        andi.kleen@intel.com, dave.hansen@intel.com, megha.dey@intel.com,
        wajdi.k.feghali@intel.com, greg.b.tucker@intel.com,
        robert.a.kasten@intel.com, rajendrakumar.chinnaiyan@intel.com,
        tomasz.kantecki@intel.com, ryan.d.saffores@intel.com,
        ilya.albrekht@intel.com, kyung.min.park@intel.com,
        tony.luck@intel.com, ira.weiny@intel.com
Subject: [RFC V1 3/7] crypto: ghash - Optimized GHASH computations
Date:   Fri, 18 Dec 2020 13:11:00 -0800
Message-Id: <1608325864-4033-4-git-send-email-megha.dey@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1608325864-4033-1-git-send-email-megha.dey@intel.com>
References: <1608325864-4033-1-git-send-email-megha.dey@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Kyung Min Park <kyung.min.park@intel.com>

Optimize GHASH computations with the 512 bit wide VPCLMULQDQ instructions.
The new instruction allows to work on 4 x 16 byte blocks at the time.
For best parallelism and deeper out of order execution, the main loop of
the code works on 16 x 16 byte blocks at the time and performs reduction
every 48 x 16 byte blocks. Such approach needs 48 precomputed GHASH subkeys
and the precompute operation has been optimized as well to leverage 512 bit
registers, parallel carry less multiply and reduction.

VPCLMULQDQ instruction is used to accelerate the most time-consuming
part of GHASH, carry-less multiplication. VPCLMULQDQ instruction
with AVX-512F adds EVEX encoded 512 bit version of PCLMULQDQ instruction.

The glue code in ghash_clmulni_intel module overrides existing PCLMULQDQ
version with the VPCLMULQDQ version when the following criteria are met:
At compile time:
1. CONFIG_CRYPTO_AVX512 is enabled
2. toolchain(assembler) supports VPCLMULQDQ instructions
At runtime:
1. VPCLMULQDQ and AVX512VL features are supported on a platform (currently
   only Icelake)
2. If compiled as built-in module, ghash_clmulni_intel.use_avx512 is set at
   boot time or /sys/module/ghash_clmulni_intel/parameters/use_avx512 is set
   to 1 after boot.
   If compiled as loadable module, use_avx512 module parameter must be set:
   modprobe ghash_clmulni_intel use_avx512=1

With new implementation, tcrypt ghash speed test shows about 4x to 10x
speedup improvement for GHASH calculation compared to the original
implementation with PCLMULQDQ when the bytes per update size is 256 Bytes
or above. Detailed results for a variety of block sizes and update
sizes are in the table below. The test was performed on Icelake based
platform with constant frequency set for CPU.

The average performance improvement of the AVX512 version over the current
implementation is as follows:
For bytes per update >= 1KB, we see the average improvement of 882%(~8.8x).
For bytes per update < 1KB, we see the average improvement of 370%(~3.7x).

A typical run of tcrypt with GHASH calculation with PCLMULQDQ instruction
and VPCLMULQDQ instruction shows the following results.

---------------------------------------------------------------------------
|            |            |         cycles/operation         |            |
|            |            |       (the lower the better)     |            |
|    byte    |   bytes    |----------------------------------| percentage |
|   blocks   | per update |   GHASH test   |   GHASH test    | loss/gain  |
|            |            | with PCLMULQDQ | with VPCLMULQDQ |            |
|------------|------------|----------------|-----------------|------------|
|      16    |     16     |       144      |        233      |   -38.0    |
|      64    |     16     |       535      |        709      |   -24.5    |
|      64    |     64     |       210      |        146      |    43.8    |
|     256    |     16     |      1808      |       1911      |    -5.4    |
|     256    |     64     |       865      |        581      |    48.9    |
|     256    |    256     |       682      |        170      |   301.0    |
|    1024    |     16     |      6746      |       6935      |    -2.7    |
|    1024    |    256     |      2829      |        714      |   296.0    |
|    1024    |   1024     |      2543      |        341      |   645.0    |
|    2048    |     16     |     13219      |      13403      |    -1.3    |
|    2048    |    256     |      5435      |       1408      |   286.0    |
|    2048    |   1024     |      5218      |        685      |   661.0    |
|    2048    |   2048     |      5061      |        565      |   796.0    |
|    4096    |     16     |     40793      |      27615      |    47.8    |
|    4096    |    256     |     10662      |       2689      |   297.0    |
|    4096    |   1024     |     10196      |       1333      |   665.0    |
|    4096    |   4096     |     10049      |       1011      |   894.0    |
|    8192    |     16     |     51672      |      54599      |    -5.3    |
|    8192    |    256     |     21228      |       5284      |   301.0    |
|    8192    |   1024     |     20306      |       2556      |   694.0    |
|    8192    |   4096     |     20076      |       2044      |   882.0    |
|    8192    |   8192     |     20071      |       2017      |   895.0    |
---------------------------------------------------------------------------

This work was inspired by the AES GCM mode optimization published
in Intel Optimized IPSEC Cryptographic library.
https://github.com/intel/intel-ipsec-mb/lib/avx512/gcm_vaes_avx512.asm

Co-developed-by: Greg Tucker <greg.b.tucker@intel.com>
Signed-off-by: Greg Tucker <greg.b.tucker@intel.com>
Co-developed-by: Tomasz Kantecki <tomasz.kantecki@intel.com>
Signed-off-by: Tomasz Kantecki <tomasz.kantecki@intel.com>
Signed-off-by: Kyung Min Park <kyung.min.park@intel.com>
Co-developed-by: Megha Dey <megha.dey@intel.com>
Signed-off-by: Megha Dey <megha.dey@intel.com>
---
 arch/x86/crypto/Makefile                     |    1 +
 arch/x86/crypto/avx512_vaes_common.S         | 1211 ++++++++++++++++++++++++++
 arch/x86/crypto/ghash-clmulni-intel_avx512.S |   68 ++
 arch/x86/crypto/ghash-clmulni-intel_glue.c   |   39 +-
 crypto/Kconfig                               |   12 +
 5 files changed, 1329 insertions(+), 2 deletions(-)
 create mode 100644 arch/x86/crypto/avx512_vaes_common.S
 create mode 100644 arch/x86/crypto/ghash-clmulni-intel_avx512.S

diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index bf0b0fc..0a86cfb 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -70,6 +70,7 @@ blake2s-x86_64-y := blake2s-core.o blake2s-glue.o
 
 obj-$(CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL) += ghash-clmulni-intel.o
 ghash-clmulni-intel-y := ghash-clmulni-intel_asm.o ghash-clmulni-intel_glue.o
+ghash-clmulni-intel-$(CONFIG_CRYPTO_GHASH_CLMUL_NI_AVX512) += ghash-clmulni-intel_avx512.o
 
 obj-$(CONFIG_CRYPTO_CRC32C_INTEL) += crc32c-intel.o
 crc32c-intel-y := crc32c-intel_glue.o
diff --git a/arch/x86/crypto/avx512_vaes_common.S b/arch/x86/crypto/avx512_vaes_common.S
new file mode 100644
index 0000000..f3ee898
--- /dev/null
+++ b/arch/x86/crypto/avx512_vaes_common.S
@@ -0,0 +1,1211 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright © 2020 Intel Corporation.
+ *
+ * Collection of macros which can be used by any crypto code using VAES,
+ * VPCLMULQDQ and AVX512 optimizations.
+ */
+
+#include <linux/linkage.h>
+#include <asm/inst.h>
+
+#define zmm31y ymm31
+#define zmm30y ymm30
+#define zmm29y ymm29
+#define zmm28y ymm28
+#define zmm27y ymm27
+#define zmm26y ymm26
+#define zmm25y ymm25
+#define zmm24y ymm24
+#define zmm23y ymm23
+#define zmm22y ymm22
+#define zmm21y ymm21
+#define zmm20y ymm20
+#define zmm19y ymm19
+#define zmm18y ymm18
+#define zmm17y ymm17
+#define zmm16y ymm16
+#define zmm15y ymm15
+#define zmm13y ymm13
+#define zmm12y ymm12
+#define zmm11y ymm11
+#define zmm10y ymm10
+#define zmm9y  ymm9
+#define zmm8y  ymm8
+#define zmm7y  ymm7
+#define zmm6y  ymm6
+#define zmm5y  ymm5
+#define zmm4y  ymm4
+#define zmm3y  ymm3
+#define zmm2y  ymm2
+#define zmm1y  ymm1
+#define zmm0y  ymm0
+
+#define zmm31x xmm31
+#define zmm30x xmm30
+#define zmm29x xmm29
+#define zmm28x xmm28
+#define zmm27x xmm27
+#define zmm26x xmm26
+#define zmm25x xmm25
+#define zmm24x xmm24
+#define zmm23x xmm23
+#define zmm22x xmm22
+#define zmm21x xmm21
+#define zmm20x xmm20
+#define zmm19x xmm19
+#define zmm18x xmm18
+#define zmm17x xmm17
+#define zmm16x xmm16
+#define zmm15x xmm15
+#define zmm14x xmm14
+#define zmm13x xmm13
+#define zmm12x xmm12
+#define zmm11x xmm11
+#define zmm10x xmm10
+#define zmm9x  xmm9
+#define zmm8x  xmm8
+#define zmm7x  xmm7
+#define zmm6x  xmm6
+#define zmm5x  xmm5
+#define zmm4x  xmm4
+#define zmm3x  xmm3
+#define zmm2x  xmm2
+#define zmm1x  xmm1
+#define zmm0x xmm0
+
+#define ymm5y ymm5
+#define ymm4y ymm4
+#define ymm3y ymm3
+#define ymm2y ymm2
+#define ymm1y ymm1
+
+#define ymm12x xmm12
+#define ymm11x xmm11
+#define ymm7x xmm7
+#define ymm6x xmm6
+#define ymm5x xmm5
+#define ymm4x xmm4
+#define ymm3x xmm3
+#define ymm2x xmm2
+#define ymm1x xmm1
+
+#define xmm14z zmm14
+#define xmm10z zmm10
+#define xmm2z zmm2
+#define xmm0z zmm0
+#define xmm5z zmm5
+#define xmm4z zmm4
+#define xmm3z zmm3
+#define xmm1z zmm1
+#define xmm6z zmm6
+#define xmm7z zmm7
+#define xmm8z zmm8
+#define xmm9z zmm9
+
+#define xmm11y ymm11
+#define xmm9y ymm9
+#define xmm5y ymm5
+#define xmm4y ymm4
+#define xmm3y ymm3
+#define xmm2y ymm2
+#define xmm1y ymm1
+#define xmm0y ymm0
+
+#define xmm14x xmm14
+#define xmm8x xmm8
+#define xmm7x xmm7
+#define xmm6x xmm6
+#define xmm5x xmm5
+#define xmm4x xmm4
+#define xmm3x xmm3
+#define xmm2x xmm2
+#define xmm1x xmm1
+#define xmm0x xmm0
+
+#define xmm0z  zmm0
+#define xmm0y  ymm0
+#define xmm0x  xmm0
+
+#define stringify(reg,y)       reg##y
+#define str(reg,y)	       stringify(reg,y)
+#define concat(reg,y)	       str(reg,y)
+
+#define YWORD(reg)     concat(reg, y)
+#define XWORD(reg)     concat(reg, x)
+#define ZWORD(reg)     concat(reg, z)
+#define DWORD(reg)     concat(reg, d)
+#define WORD(reg)      concat(reg, w)
+#define BYTE(reg)      concat(reg, b)
+
+#define arg1	%rdi
+#define arg2	%rsi
+#define arg3	%rdx
+#define arg4	%rcx
+#define arg5	%r8
+#define arg6	%r9
+
+#define STACK_LOCAL_OFFSET	  64
+#define LOCAL_STORAGE		  (48*16)	 //space for up to 128 AES blocks
+#define STACK_FRAME_SIZE_GHASH	  (STACK_LOCAL_OFFSET + LOCAL_STORAGE)
+
+#define HashKey_48	(16*0)
+#define HashKey_47	(16*1)
+#define HashKey_46	(16*2)
+#define HashKey_45	(16*3)
+#define HashKey_44	(16*4)
+#define HashKey_43	(16*5)
+#define HashKey_42	(16*6)
+#define HashKey_41	(16*7)
+#define HashKey_40	(16*8)
+#define HashKey_39	(16*9)
+#define HashKey_38	(16*10)
+#define HashKey_37	(16*11)
+#define HashKey_36	(16*12)
+#define HashKey_35	(16*13)
+#define HashKey_34	(16*14)
+#define HashKey_33	(16*15)
+#define HashKey_32	(16*16)
+#define HashKey_31	(16*17)
+#define HashKey_30	(16*18)
+#define HashKey_29	(16*19)
+#define HashKey_28	(16*20)
+#define HashKey_27	(16*21)
+#define HashKey_26	(16*22)
+#define HashKey_25	(16*23)
+#define HashKey_24	(16*24)
+#define HashKey_23	(16*25)
+#define HashKey_22     (16*26)
+#define HashKey_21     (16*27)
+#define HashKey_20     (16*28)
+#define HashKey_19     (16*29)
+#define HashKey_18     (16*30)
+#define HashKey_17     (16*31)
+#define HashKey_16	(16*32)
+#define HashKey_15	(16*33)
+#define HashKey_14	(16*34)
+#define HashKey_13	(16*35)
+#define HashKey_12	(16*36)
+#define HashKey_11	(16*37)
+#define HashKey_10	(16*38)
+#define HashKey_9      (16*39)
+#define HashKey_8      (16*40)
+#define HashKey_7      (16*41)
+#define HashKey_6      (16*42)
+#define HashKey_5      (16*43)
+#define HashKey_4      (16*44)
+#define HashKey_3      (16*45)
+#define HashKey_2      (16*46)
+#define HashKey_1      (16*47)
+#define HashKey      (16*47)
+
+.data
+
+.align 16
+ONE:
+.octa	0x00000000000000000000000000000001
+
+.align 16
+POLY:
+.octa	0xC2000000000000000000000000000001
+
+.align 16
+TWOONE:
+.octa	0x00000001000000000000000000000001
+
+/*
+ * Order of these constants should not change.
+ * ALL_F should follow SHIFT_MASK, ZERO should follow ALL_F
+ */
+.align 16
+SHIFT_MASK:
+.octa	0x0f0e0d0c0b0a09080706050403020100
+
+ALL_F:
+.octa	0xffffffffffffffffffffffffffffffff
+
+ZERO:
+.octa	0x00000000000000000000000000000000
+
+.align 16
+ONEf:
+.octa	0x01000000000000000000000000000000
+
+.align 64
+SHUF_MASK:
+.octa	0x000102030405060708090A0B0C0D0E0F
+.octa	0x000102030405060708090A0B0C0D0E0F
+.octa	0x000102030405060708090A0B0C0D0E0F
+.octa	0x000102030405060708090A0B0C0D0E0F
+
+.align 64
+byte_len_to_mask_table:
+.quad	0x0007000300010000
+.quad	0x007f003f001f000f
+.quad	0x07ff03ff01ff00ff
+.quad	0x7fff3fff1fff0fff
+.quad	0xffff
+
+.align 64
+byte64_len_to_mask_table:
+.octa	0x00000000000000010000000000000000
+.octa	0x00000000000000070000000000000003
+.octa	0x000000000000001f000000000000000f
+.octa	0x000000000000007f000000000000003f
+.octa	0x00000000000001ff00000000000000ff
+.octa	0x00000000000007ff00000000000003ff
+.octa	0x0000000000001fff0000000000000fff
+.octa	0x0000000000007fff0000000000003fff
+.octa	0x000000000001ffff000000000000ffff
+.octa	0x000000000007ffff000000000003ffff
+.octa	0x00000000001fffff00000000000fffff
+.octa	0x00000000007fffff00000000003fffff
+.octa	0x0000000001ffffff0000000000ffffff
+.octa	0x0000000007ffffff0000000003ffffff
+.octa	0x000000001fffffff000000000fffffff
+.octa	0x000000007fffffff000000003fffffff
+.octa	0x00000001ffffffff00000000ffffffff
+.octa	0x00000007ffffffff00000003ffffffff
+.octa	0x0000001fffffffff0000000fffffffff
+.octa	0x0000007fffffffff0000003fffffffff
+.octa	0x000001ffffffffff000000ffffffffff
+.octa	0x000007ffffffffff000003ffffffffff
+.octa	0x00001fffffffffff00000fffffffffff
+.octa	0x00007fffffffffff00003fffffffffff
+.octa	0x0001ffffffffffff0000ffffffffffff
+.octa	0x0007ffffffffffff0003ffffffffffff
+.octa	0x001fffffffffffff000fffffffffffff
+.octa	0x007fffffffffffff003fffffffffffff
+.octa	0x01ffffffffffffff00ffffffffffffff
+.octa	0x07ffffffffffffff03ffffffffffffff
+.octa	0x1fffffffffffffff0fffffffffffffff
+.octa	0x7fffffffffffffff3fffffffffffffff
+.octa	0xffffffffffffffff
+
+.align 64
+mask_out_top_block:
+.octa	0xffffffffffffffffffffffffffffffff
+.octa	0xffffffffffffffffffffffffffffffff
+.octa	0xffffffffffffffffffffffffffffffff
+.octa	0x00000000000000000000000000000000
+
+.align 64
+ddq_add_1234:
+.octa	0x00000000000000000000000000000001
+.octa	0x00000000000000000000000000000002
+.octa	0x00000000000000000000000000000003
+.octa	0x00000000000000000000000000000004
+
+.align 64
+ddq_add_5678:
+.octa	0x00000000000000000000000000000005
+.octa	0x00000000000000000000000000000006
+.octa	0x00000000000000000000000000000007
+.octa	0x00000000000000000000000000000008
+
+.align 64
+ddq_add_4444:
+.octa	0x00000000000000000000000000000004
+.octa	0x00000000000000000000000000000004
+.octa	0x00000000000000000000000000000004
+.octa	0x00000000000000000000000000000004
+
+.align 64
+ddq_add_8888:
+.octa	0x00000000000000000000000000000008
+.octa	0x00000000000000000000000000000008
+.octa	0x00000000000000000000000000000008
+.octa	0x00000000000000000000000000000008
+
+.align 64
+ddq_addbe_1234:
+.octa	0x01000000000000000000000000000000
+.octa	0x02000000000000000000000000000000
+.octa	0x03000000000000000000000000000000
+.octa	0x04000000000000000000000000000000
+
+.align 64
+ddq_addbe_4444:
+.octa	0x04000000000000000000000000000000
+.octa	0x04000000000000000000000000000000
+.octa	0x04000000000000000000000000000000
+.octa	0x04000000000000000000000000000000
+
+.align 64
+ddq_addbe_8888:
+.octa	0x08000000000000000000000000000000
+.octa	0x08000000000000000000000000000000
+.octa	0x08000000000000000000000000000000
+.octa	0x08000000000000000000000000000000
+
+.align 64
+POLY2:
+.octa	0xC20000000000000000000001C2000000
+.octa	0xC20000000000000000000001C2000000
+.octa	0xC20000000000000000000001C2000000
+.octa	0xC20000000000000000000001C2000000
+
+.align 16
+byteswap_const:
+.octa	0x000102030405060708090A0B0C0D0E0F
+
+.text
+
+/* Save register content for the caller */
+#define FUNC_SAVE_GHASH()			\
+	mov	%rsp, %rax;		\
+	sub	$STACK_FRAME_SIZE_GHASH, %rsp;\
+	and	$~63, %rsp;		\
+	mov	%r12, 0*8(%rsp);	\
+	mov	%r13, 1*8(%rsp);	\
+	mov	%r14, 2*8(%rsp);	\
+	mov	%r15, 3*8(%rsp);	\
+	mov	%rax, 4*8(%rsp);	\
+	mov	%rax, 4*8(%rsp);	\
+	mov	%rax, %r14;		\
+	mov	%rbp, 5*8(%rsp);	\
+	mov	%rbx, 6*8(%rsp);	\
+
+/* Restore register content for the caller */
+#define FUNC_RESTORE_GHASH()		  \
+	mov	5*8(%rsp), %rbp;	\
+	mov	6*8(%rsp), %rbx;	\
+	mov	0*8(%rsp), %r12;	\
+	mov	1*8(%rsp), %r13;	\
+	mov	2*8(%rsp), %r14;	\
+	mov	3*8(%rsp), %r15;	\
+	mov	4*8(%rsp), %rsp;	\
+
+/*
+ * GHASH school book multiplication
+ */
+#define GHASH_MUL(GH, HK, T1, T2, T3, T4, T5)			\
+	vpclmulqdq	$0x11, HK, GH, T1;			\
+	vpclmulqdq	$0x00, HK, GH, T2;			\
+	vpclmulqdq	$0x01, HK, GH, T3;			\
+	vpclmulqdq	$0x10, HK, GH, GH;			\
+	vpxorq		T3, GH, GH;				\
+	vpsrldq		$8, GH, T3;				\
+	vpslldq		$8, GH, GH;				\
+	vpxorq		T3, T1, T1;				\
+	vpxorq		T2, GH, GH;				\
+	vmovdqu64	POLY2(%rip), T3;			\
+	vpclmulqdq	$0x01, GH, T3, T2;			\
+	vpslldq		$8, T2, T2;				\
+	vpxorq		T2, GH, GH;				\
+	vpclmulqdq	$0x00, GH, T3, T2;			\
+	vpsrldq		$4, T2, T2;				\
+	vpclmulqdq	$0x10, GH, T3, GH;			\
+	vpslldq		$4, GH, GH;				\
+	vpternlogq	$0x96, T2, T1, GH;
+
+/*
+ * Precomputation of hash keys. These precomputated keys
+ * are saved in memory and reused for as many 8 blocks sets
+ * as necessary.
+ */
+#define PRECOMPUTE(GDATA, HK, T1, T2, T3, T4, T5, T6, T7, T8) \
+\
+	vmovdqa64	HK, T5; \
+	vinserti64x2	$3, HK, ZWORD(T7), ZWORD(T7); \
+	GHASH_MUL(T5, HK, T1, T3, T4, T6, T2) \
+	vmovdqu64	T5, HashKey_2(GDATA); \
+	vinserti64x2	$2, T5, ZWORD(T7), ZWORD(T7); \
+	GHASH_MUL(T5, HK, T1, T3, T4, T6, T2) \
+	vmovdqu64	T5, HashKey_3(GDATA); \
+	vinserti64x2	$1, T5, ZWORD(T7), ZWORD(T7); \
+	GHASH_MUL(T5, HK, T1, T3, T4, T6, T2) \
+	vmovdqu64	T5, HashKey_4(GDATA); \
+	vinserti64x2	$0, T5, ZWORD(T7), ZWORD(T7); \
+	vshufi64x2	$0x00, ZWORD(T5), ZWORD(T5), ZWORD(T5); \
+	vmovdqa64	ZWORD(T7), ZWORD(T8); \
+	GHASH_MUL(ZWORD(T7), ZWORD(T5), ZWORD(T1), ZWORD(T3), ZWORD(T4), ZWORD(T6), ZWORD(T2)) \
+	vmovdqu64	ZWORD(T7), HashKey_8(GDATA); \
+	vshufi64x2	$0x00, ZWORD(T7), ZWORD(T7), ZWORD(T5); \
+	GHASH_MUL(ZWORD(T8), ZWORD(T5), ZWORD(T1), ZWORD(T3), ZWORD(T4), ZWORD(T6), ZWORD(T2)) \
+	vmovdqu64 ZWORD(T8), HashKey_12(GDATA); \
+	GHASH_MUL(ZWORD(T7), ZWORD(T5), ZWORD(T1), ZWORD(T3), ZWORD(T4), ZWORD(T6), ZWORD(T2)) \
+	vmovdqu64 ZWORD(T7), HashKey_16(GDATA); \
+	GHASH_MUL(ZWORD(T8), ZWORD(T5), ZWORD(T1), ZWORD(T3), ZWORD(T4), ZWORD(T6), ZWORD(T2)) \
+	vmovdqu64 ZWORD(T8), HashKey_20(GDATA); \
+	GHASH_MUL(ZWORD(T7), ZWORD(T5), ZWORD(T1), ZWORD(T3), ZWORD(T4), ZWORD(T6), ZWORD(T2)) \
+	vmovdqu64 ZWORD(T7), HashKey_24(GDATA); \
+	GHASH_MUL(ZWORD(T8), ZWORD(T5), ZWORD(T1), ZWORD(T3), ZWORD(T4), ZWORD(T6), ZWORD(T2)) \
+	vmovdqu64 ZWORD(T8), HashKey_28(GDATA); \
+	GHASH_MUL(ZWORD(T7), ZWORD(T5), ZWORD(T1), ZWORD(T3), ZWORD(T4), ZWORD(T6), ZWORD(T2)) \
+	vmovdqu64 ZWORD(T7), HashKey_32(GDATA); \
+	GHASH_MUL(ZWORD(T8), ZWORD(T5), ZWORD(T1), ZWORD(T3), ZWORD(T4), ZWORD(T6), ZWORD(T2)) \
+	vmovdqu64 ZWORD(T8), HashKey_36(GDATA); \
+	GHASH_MUL(ZWORD(T7), ZWORD(T5), ZWORD(T1), ZWORD(T3), ZWORD(T4), ZWORD(T6), ZWORD(T2)) \
+	vmovdqu64 ZWORD(T7), HashKey_40(GDATA); \
+	GHASH_MUL(ZWORD(T8), ZWORD(T5), ZWORD(T1), ZWORD(T3), ZWORD(T4), ZWORD(T6), ZWORD(T2)) \
+	vmovdqu64 ZWORD(T8), HashKey_44(GDATA); \
+	GHASH_MUL(ZWORD(T7), ZWORD(T5), ZWORD(T1), ZWORD(T3), ZWORD(T4), ZWORD(T6), ZWORD(T2)) \
+	vmovdqu64 ZWORD(T7), HashKey_48(GDATA);
+
+#define VHPXORI4x128(REG,TMP)					\
+	vextracti64x4	$1, REG, YWORD(TMP);			\
+	vpxorq		YWORD(TMP), YWORD(REG), YWORD(REG);	\
+	vextracti32x4	$1, YWORD(REG), XWORD(TMP);		\
+	vpxorq		XWORD(TMP), XWORD(REG), XWORD(REG);
+
+#define VCLMUL_REDUCE(OUT, POLY, HI128, LO128, TMP0, TMP1)	\
+	vpclmulqdq	$0x01, LO128, POLY, TMP0;		\
+	vpslldq		$8, TMP0, TMP0;				\
+	vpxorq		TMP0, LO128, TMP0;			\
+	vpclmulqdq	$0x00, TMP0, POLY, TMP1;		\
+	vpsrldq		$4, TMP1, TMP1;				\
+	vpclmulqdq	$0x10, TMP0, POLY, OUT;			\
+	vpslldq		$4, OUT, OUT;				\
+	vpternlogq	$0x96, HI128, TMP1, OUT;
+
+/*
+ * GHASH 1 to 16 blocks of the input buffer.
+ *  - It performs reduction at the end.
+ *  - It can take intermediate GHASH sums as input.
+ */
+#define GHASH_1_TO_16(KP, OFFSET, GHASH, T1, T2, T3, T4, T5, T6, T7, T8, T9, AAD_HASH_IN, CIPHER_IN0, CIPHER_IN1, CIPHER_IN2, CIPHER_IN3, NUM_BLOCKS, BOOL, INSTANCE_TYPE, ROUND, HKEY_START, PREV_H, PREV_L, PREV_M1, PREV_M2) \
+.set	reg_idx, 0;	\
+.set	blocks_left, NUM_BLOCKS;	\
+.ifc INSTANCE_TYPE, single_call; \
+	.if BOOL == 1; \
+	.set	hashk, concat(HashKey_, NUM_BLOCKS);	\
+	.else; \
+	.set	hashk, concat(HashKey_, NUM_BLOCKS) + 0x11;	 \
+	.endif; \
+	.set	first_result, 1; \
+	.set	reduce, 1; \
+	vpxorq		AAD_HASH_IN, CIPHER_IN0, CIPHER_IN0; \
+.else;	\
+	.set	hashk, concat(HashKey_, HKEY_START);	\
+	.ifc ROUND, first; \
+		.set first_result, 1; \
+		.set reduce, 0; \
+		vpxorq		AAD_HASH_IN, CIPHER_IN0, CIPHER_IN0; \
+	.else; \
+		.ifc ROUND, mid; \
+		    .set first_result, 0; \
+		    .set reduce, 0; \
+		    vmovdqa64	    PREV_H, T1; \
+		    vmovdqa64	    PREV_L, T2; \
+		    vmovdqa64	    PREV_M1, T3; \
+		    vmovdqa64	    PREV_M2, T4; \
+		.else; \
+		    .set first_result, 0; \
+		    .set reduce, 1; \
+		    vmovdqa64	    PREV_H, T1; \
+		    vmovdqa64	    PREV_L, T2; \
+		    vmovdqa64	    PREV_M1, T3; \
+		    vmovdqa64	    PREV_M2, T4; \
+		.endif; \
+	.endif; \
+.endif; \
+.if NUM_BLOCKS < 4;	\
+	.if blocks_left == 1; \
+		.if first_result == 1;	\
+			vmovdqu64	hashk + OFFSET(KP), XWORD(T9); \
+			vpclmulqdq	$0x11, XWORD(T9), XWORD(CIPHER_IN0), XWORD(T1); \
+			vpclmulqdq	$0x00, XWORD(T9), XWORD(CIPHER_IN0), XWORD(T2); \
+			vpclmulqdq	$0x01, XWORD(T9), XWORD(CIPHER_IN0), XWORD(T3); \
+			vpclmulqdq	$0x10, XWORD(T9), XWORD(CIPHER_IN0), XWORD(T4); \
+		.else;	\
+			vmovdqu64	hashk + OFFSET(KP), XWORD(T9); \
+			vpclmulqdq	$0x11, XWORD(T9), XWORD(CIPHER_IN0), XWORD(T5); \
+			vpclmulqdq	$0x00, XWORD(T9), XWORD(CIPHER_IN0), XWORD(T6); \
+			vpclmulqdq	$0x01, XWORD(T9), XWORD(CIPHER_IN0), XWORD(T7); \
+			vpclmulqdq	$0x10, XWORD(T9), XWORD(CIPHER_IN0), XWORD(T8); \
+		.endif; \
+	.elseif blocks_left == 2; \
+		.if first_result == 1;	\
+			vmovdqu64	hashk + OFFSET(KP), YWORD(T9); \
+			vpclmulqdq	$0x11, YWORD(T9), YWORD(CIPHER_IN0), YWORD(T1); \
+			vpclmulqdq	$0x00, YWORD(T9), YWORD(CIPHER_IN0), YWORD(T2); \
+			vpclmulqdq	$0x01, YWORD(T9), YWORD(CIPHER_IN0), YWORD(T3); \
+			vpclmulqdq	$0x10, YWORD(T9), YWORD(CIPHER_IN0), YWORD(T4); \
+		.else;	\
+			vmovdqu64	hashk + OFFSET(KP), YWORD(T9); \
+			vpclmulqdq	$0x11, YWORD(T9), YWORD(CIPHER_IN0), YWORD(T5); \
+			vpclmulqdq	$0x00, YWORD(T9), YWORD(CIPHER_IN0), YWORD(T6); \
+			vpclmulqdq	$0x01, YWORD(T9), YWORD(CIPHER_IN0), YWORD(T7); \
+			vpclmulqdq	$0x10, YWORD(T9), YWORD(CIPHER_IN0), YWORD(T8); \
+		.endif; \
+	.elseif blocks_left == 3;	\
+		.if first_result == 1;	\
+			vmovdqu64	hashk + OFFSET(KP), YWORD(T9); \
+			vinserti64x2	$2, 32 + hashk + OFFSET(KP), T9, T9; \
+			vpclmulqdq	$0x11, T9, CIPHER_IN0, T1; \
+			vpclmulqdq	$0x00, T9, CIPHER_IN0, T2; \
+			vpclmulqdq	$0x01, T9, CIPHER_IN0, T3; \
+			vpclmulqdq	$0x10, T9, CIPHER_IN0, T4; \
+		.else;	\
+			vmovdqu64	hashk + OFFSET(KP), YWORD(T9); \
+			vinserti64x2	$2, 32 + hashk + OFFSET(KP), T9, T9; \
+			vpclmulqdq	$0x11, T9, CIPHER_IN0, T5; \
+			vpclmulqdq	$0x00, T9, CIPHER_IN0, T6; \
+			vpclmulqdq	$0x01, T9, CIPHER_IN0, T7; \
+			vpclmulqdq	$0x10, T9, CIPHER_IN0, T8; \
+		.endif; \
+	.endif; \
+	.if first_result != 1; \
+		 vpxorq		 T5, T1, T1; \
+		 vpxorq		 T6, T2, T2; \
+		 vpxorq		 T7, T3, T3; \
+		 vpxorq		 T8, T4, T4; \
+	.endif; \
+.elseif (NUM_BLOCKS >= 4) && (NUM_BLOCKS < 8); \
+	vmovdqu64	hashk + OFFSET(KP), T9; \
+	.if first_result == 1; \
+		vpclmulqdq	$0x11, T9, CIPHER_IN0, T1; \
+		vpclmulqdq	$0x00, T9, CIPHER_IN0, T2; \
+		vpclmulqdq	$0x01, T9, CIPHER_IN0, T3; \
+		vpclmulqdq	$0x10, T9, CIPHER_IN0, T4; \
+		.set first_result, 0; \
+	.else; \
+		vpclmulqdq	$0x11, T9, CIPHER_IN0, T5; \
+		vpclmulqdq	$0x00, T9, CIPHER_IN0, T6; \
+		vpclmulqdq	$0x01, T9, CIPHER_IN0, T7; \
+		vpclmulqdq	$0x10, T9, CIPHER_IN0, T8; \
+		vpxorq		T5, T1, T1; \
+		vpxorq		T6, T2, T2; \
+		vpxorq		T7, T3, T3; \
+		vpxorq		T8, T4, T4; \
+	.endif; \
+	.set hashk, hashk + 64; \
+	.set blocks_left, blocks_left - 4;	\
+	.set reg_idx, reg_idx + 1;	\
+	.if blocks_left > 0;	\
+	.if blocks_left == 1; \
+		.if first_result == 1;	\
+			vmovdqu64	hashk + OFFSET(KP), XWORD(T9); \
+			vpclmulqdq	$0x11, XWORD(T9), XWORD(CIPHER_IN1), XWORD(T1); \
+			vpclmulqdq	$0x00, XWORD(T9), XWORD(CIPHER_IN1), XWORD(T2); \
+			vpclmulqdq	$0x01, XWORD(T9), XWORD(CIPHER_IN1), XWORD(T3); \
+			vpclmulqdq	$0x10, XWORD(T9), XWORD(CIPHER_IN1), XWORD(T4); \
+		.else;	\
+			vmovdqu64	hashk + OFFSET(KP), XWORD(T9); \
+			vpclmulqdq	$0x11, XWORD(T9), XWORD(CIPHER_IN1), XWORD(T5); \
+			vpclmulqdq	$0x00, XWORD(T9), XWORD(CIPHER_IN1), XWORD(T6); \
+			vpclmulqdq	$0x01, XWORD(T9), XWORD(CIPHER_IN1), XWORD(T7); \
+			vpclmulqdq	$0x10, XWORD(T9), XWORD(CIPHER_IN1), XWORD(T8); \
+		.endif; \
+	.elseif blocks_left == 2; \
+		.if first_result == 1;	\
+			vmovdqu64	hashk + OFFSET(KP), YWORD(T9); \
+			vpclmulqdq	$0x11, YWORD(T9), YWORD(CIPHER_IN1), YWORD(T1); \
+			vpclmulqdq	$0x00, YWORD(T9), YWORD(CIPHER_IN1), YWORD(T2); \
+			vpclmulqdq	$0x01, YWORD(T9), YWORD(CIPHER_IN1), YWORD(T3); \
+			vpclmulqdq	$0x10, YWORD(T9), YWORD(CIPHER_IN1), YWORD(T4); \
+		.else;	\
+			vmovdqu64	hashk + OFFSET(KP), YWORD(T9); \
+			vpclmulqdq	$0x11, YWORD(T9), YWORD(CIPHER_IN1), YWORD(T5); \
+			vpclmulqdq	$0x00, YWORD(T9), YWORD(CIPHER_IN1), YWORD(T6); \
+			vpclmulqdq	$0x01, YWORD(T9), YWORD(CIPHER_IN1), YWORD(T7); \
+			vpclmulqdq	$0x10, YWORD(T9), YWORD(CIPHER_IN1), YWORD(T8); \
+		.endif; \
+	.elseif blocks_left == 3;  \
+		.if first_result == 1;	\
+			vmovdqu64	hashk + OFFSET(KP), YWORD(T9); \
+			vinserti64x2	$2, 32 + hashk + OFFSET(KP), T9, T9; \
+			vpclmulqdq	$0x11, T9, CIPHER_IN1, T1; \
+			vpclmulqdq	$0x00, T9, CIPHER_IN1, T2; \
+			vpclmulqdq	$0x01, T9, CIPHER_IN1, T3; \
+			vpclmulqdq	$0x10, T9, CIPHER_IN1, T4; \
+		.else;	\
+			vmovdqu64	hashk + OFFSET(KP), YWORD(T9); \
+			vinserti64x2	$2, 32 + hashk + OFFSET(KP), T9, T9; \
+			vpclmulqdq	$0x11, T9, CIPHER_IN1, T5; \
+			vpclmulqdq	$0x00, T9, CIPHER_IN1, T6; \
+			vpclmulqdq	$0x01, T9, CIPHER_IN1, T7; \
+			vpclmulqdq	$0x10, T9, CIPHER_IN1, T8; \
+		.endif; \
+	.endif; \
+	.if first_result != 1; \
+			vpxorq		T5, T1, T1; \
+			vpxorq		T6, T2, T2; \
+			vpxorq		T7, T3, T3; \
+			vpxorq		T8, T4, T4; \
+	.endif; \
+	.endif; \
+.elseif (NUM_BLOCKS >= 8) && (NUM_BLOCKS < 12); \
+	vmovdqu64	hashk + OFFSET(KP), T9; \
+	.if first_result == 1; \
+		vpclmulqdq	$0x11, T9, CIPHER_IN0, T1; \
+		vpclmulqdq	$0x00, T9, CIPHER_IN0, T2; \
+		vpclmulqdq	$0x01, T9, CIPHER_IN0, T3; \
+		vpclmulqdq	$0x10, T9, CIPHER_IN0, T4; \
+		.set first_result, 0; \
+	.else; \
+		vpclmulqdq	$0x11, T9, CIPHER_IN0, T5; \
+		vpclmulqdq	$0x00, T9, CIPHER_IN0, T6; \
+		vpclmulqdq	$0x01, T9, CIPHER_IN0, T7; \
+		vpclmulqdq	$0x10, T9, CIPHER_IN0, T8; \
+		vpxorq		T5, T1, T1; \
+		vpxorq		T6, T2, T2; \
+		vpxorq		T7, T3, T3; \
+		vpxorq		T8, T4, T4; \
+	.endif; \
+	.set hashk, hashk + 64; \
+	.set blocks_left, blocks_left - 4; \
+	.set reg_idx, reg_idx + 1;	\
+	vmovdqu64	hashk + OFFSET(KP), T9; \
+	.if first_result == 1; \
+		vpclmulqdq	$0x11, T9, CIPHER_IN1, T1; \
+		vpclmulqdq	$0x00, T9, CIPHER_IN1, T2; \
+		vpclmulqdq	$0x01, T9, CIPHER_IN1, T3; \
+		vpclmulqdq	$0x10, T9, CIPHER_IN1, T4; \
+		.set first_result, 0; \
+	.else; \
+		vpclmulqdq	$0x11, T9, CIPHER_IN1, T5; \
+		vpclmulqdq	$0x00, T9, CIPHER_IN1, T6; \
+		vpclmulqdq	$0x01, T9, CIPHER_IN1, T7; \
+		vpclmulqdq	$0x10, T9, CIPHER_IN1, T8; \
+		vpxorq		T5, T1, T1; \
+		vpxorq		T6, T2, T2; \
+		vpxorq		T7, T3, T3; \
+		vpxorq		T8, T4, T4; \
+	.endif; \
+	.set hashk, hashk + 64; \
+	.set blocks_left, blocks_left - 4; \
+	.set reg_idx, reg_idx + 1;	\
+	.if blocks_left > 0; \
+	.if blocks_left == 1; \
+		.if first_result == 1;	\
+			vmovdqu64	hashk + OFFSET(KP), XWORD(T9); \
+			vpclmulqdq	$0x11, XWORD(T9), XWORD(CIPHER_IN2), XWORD(T1); \
+			vpclmulqdq	$0x00, XWORD(T9), XWORD(CIPHER_IN2), XWORD(T2); \
+			vpclmulqdq	$0x01, XWORD(T9), XWORD(CIPHER_IN2), XWORD(T3); \
+			vpclmulqdq	$0x10, XWORD(T9), XWORD(CIPHER_IN2), XWORD(T4); \
+		.else;	\
+			vmovdqu64	hashk + OFFSET(KP), XWORD(T9); \
+			vpclmulqdq	$0x11, XWORD(T9), XWORD(CIPHER_IN2), XWORD(T5); \
+			vpclmulqdq	$0x00, XWORD(T9), XWORD(CIPHER_IN2), XWORD(T6); \
+			vpclmulqdq	$0x01, XWORD(T9), XWORD(CIPHER_IN2), XWORD(T7); \
+			vpclmulqdq	$0x10, XWORD(T9), XWORD(CIPHER_IN2), XWORD(T8); \
+		.endif; \
+	.elseif blocks_left == 2; \
+		.if first_result == 1;	\
+			vmovdqu64	hashk + OFFSET(KP), YWORD(T9); \
+			vpclmulqdq	$0x11, YWORD(T9), YWORD(CIPHER_IN2), YWORD(T1); \
+			vpclmulqdq	$0x00, YWORD(T9), YWORD(CIPHER_IN2), YWORD(T2); \
+			vpclmulqdq	$0x01, YWORD(T9), YWORD(CIPHER_IN2), YWORD(T3); \
+			vpclmulqdq	$0x10, YWORD(T9), YWORD(CIPHER_IN2), YWORD(T4); \
+		.else;	\
+			vmovdqu64	hashk + OFFSET(KP), YWORD(T9); \
+			vpclmulqdq	$0x11, YWORD(T9), YWORD(CIPHER_IN2), YWORD(T5); \
+			vpclmulqdq	$0x00, YWORD(T9), YWORD(CIPHER_IN2), YWORD(T6); \
+			vpclmulqdq	$0x01, YWORD(T9), YWORD(CIPHER_IN2), YWORD(T7); \
+			vpclmulqdq	$0x10, YWORD(T9), YWORD(CIPHER_IN2), YWORD(T8); \
+		.endif; \
+	.elseif blocks_left == 3;  \
+		.if first_result == 1;	\
+			vmovdqu64	hashk + OFFSET(KP), YWORD(T9); \
+			vinserti64x2	$2, 32 + hashk + OFFSET(KP), T9, T9; \
+			vpclmulqdq	$0x11, T9, CIPHER_IN2, T1; \
+			vpclmulqdq	$0x00, T9, CIPHER_IN2, T2; \
+			vpclmulqdq	$0x01, T9, CIPHER_IN2, T3; \
+			vpclmulqdq	$0x10, T9, CIPHER_IN2, T4; \
+		.else;	\
+			vmovdqu64	hashk + OFFSET(KP), YWORD(T9); \
+			vinserti64x2	$2, 32 + hashk + OFFSET(KP), T9, T9; \
+			vpclmulqdq	$0x11, T9, CIPHER_IN2, T5; \
+			vpclmulqdq	$0x00, T9, CIPHER_IN2, T6; \
+			vpclmulqdq	$0x01, T9, CIPHER_IN2, T7; \
+			vpclmulqdq	$0x10, T9, CIPHER_IN2, T8; \
+		.endif; \
+	.endif; \
+	.if first_result != 1; \
+		vpxorq		T5, T1, T1; \
+		vpxorq		T6, T2, T2; \
+		vpxorq		T7, T3, T3; \
+		vpxorq		T8, T4, T4; \
+	.endif; \
+	.endif; \
+.elseif (NUM_BLOCKS >= 12) && (NUM_BLOCKS < 16); \
+	vmovdqu64	hashk + OFFSET(KP), T9; \
+	.if first_result == 1; \
+		vpclmulqdq	$0x11, T9, CIPHER_IN0, T1; \
+		vpclmulqdq	$0x00, T9, CIPHER_IN0, T2; \
+		vpclmulqdq	$0x01, T9, CIPHER_IN0, T3; \
+		vpclmulqdq	$0x10, T9, CIPHER_IN0, T4; \
+		first_result = 0; \
+	.else; \
+		vpclmulqdq	$0x11, T9, CIPHER_IN0, T5; \
+		vpclmulqdq	$0x00, T9, CIPHER_IN0, T6; \
+		vpclmulqdq	$0x01, T9, CIPHER_IN0, T7; \
+		vpclmulqdq	$0x10, T9, CIPHER_IN0, T8; \
+		vpxorq		T5, T1, T1; \
+		vpxorq		T6, T2, T2; \
+		vpxorq		T7, T3, T3; \
+		vpxorq		T8, T4, T4; \
+	.endif; \
+	.set hashk, hashk + 64; \
+	.set blocks_left, blocks_left - 4; \
+	.set reg_idx, reg_idx + 1;	\
+	vmovdqu64	hashk + OFFSET(KP), T9; \
+	.if first_result == 1; \
+		vpclmulqdq	$0x11, T9, CIPHER_IN1, T1; \
+		vpclmulqdq	$0x00, T9, CIPHER_IN1, T2; \
+		vpclmulqdq	$0x01, T9, CIPHER_IN1, T3; \
+		vpclmulqdq	$0x10, T9, CIPHER_IN1, T4; \
+		first_result = 0; \
+	.else; \
+		vpclmulqdq	$0x11, T9, CIPHER_IN1, T5; \
+		vpclmulqdq	$0x00, T9, CIPHER_IN1, T6; \
+		vpclmulqdq	$0x01, T9, CIPHER_IN1, T7; \
+		vpclmulqdq	$0x10, T9, CIPHER_IN1, T8; \
+		vpxorq		T5, T1, T1; \
+		vpxorq		T6, T2, T2; \
+		vpxorq		T7, T3, T3; \
+		vpxorq		T8, T4, T4; \
+	.endif; \
+	.set hashk, hashk + 64; \
+	.set blocks_left, blocks_left - 4; \
+	.set reg_idx, reg_idx + 1;	\
+	vmovdqu64	hashk + OFFSET(KP), T9; \
+	.if first_result == 1; \
+		vpclmulqdq	$0x11, T9, CIPHER_IN2, T1; \
+		vpclmulqdq	$0x00, T9, CIPHER_IN2, T2; \
+		vpclmulqdq	$0x01, T9, CIPHER_IN2, T3; \
+		vpclmulqdq	$0x10, T9, CIPHER_IN2, T4; \
+		first_result = 0; \
+	.else; \
+		vpclmulqdq	$0x11, T9, CIPHER_IN2, T5; \
+		vpclmulqdq	$0x00, T9, CIPHER_IN2, T6; \
+		vpclmulqdq	$0x01, T9, CIPHER_IN2, T7; \
+		vpclmulqdq	$0x10, T9, CIPHER_IN2, T8; \
+		vpxorq		T5, T1, T1; \
+		vpxorq		T6, T2, T2; \
+		vpxorq		T7, T3, T3; \
+		vpxorq		T8, T4, T4; \
+	.endif; \
+	.set hashk, hashk + 64; \
+	.set blocks_left, blocks_left - 4; \
+	.set reg_idx, reg_idx + 1;	\
+	.if blocks_left > 0;	\
+	.if blocks_left == 1; \
+		.if first_result == 1;	\
+			vmovdqu64	hashk + OFFSET(KP), XWORD(T9); \
+			vpclmulqdq	$0x11, XWORD(T9), XWORD(CIPHER_IN3), XWORD(T1); \
+			vpclmulqdq	$0x00, XWORD(T9), XWORD(CIPHER_IN3), XWORD(T2); \
+			vpclmulqdq	$0x01, XWORD(T9), XWORD(CIPHER_IN3), XWORD(T3); \
+			vpclmulqdq	$0x10, XWORD(T9), XWORD(CIPHER_IN3), XWORD(T4); \
+		.else;	\
+			vmovdqu64	hashk + OFFSET(KP), XWORD(T9); \
+			vpclmulqdq	$0x11, XWORD(T9), XWORD(CIPHER_IN3), XWORD(T5); \
+			vpclmulqdq	$0x00, XWORD(T9), XWORD(CIPHER_IN3), XWORD(T6); \
+			vpclmulqdq	$0x01, XWORD(T9), XWORD(CIPHER_IN3), XWORD(T7); \
+			vpclmulqdq	$0x10, XWORD(T9), XWORD(CIPHER_IN3), XWORD(T8); \
+		.endif; \
+	.elseif blocks_left == 2; \
+		.if first_result == 1;	\
+			vmovdqu64	hashk + OFFSET(KP), YWORD(T9); \
+			vpclmulqdq	$0x11, YWORD(T9), YWORD(CIPHER_IN3), YWORD(T1); \
+			vpclmulqdq	$0x00, YWORD(T9), YWORD(CIPHER_IN3), YWORD(T2); \
+			vpclmulqdq	$0x01, YWORD(T9), YWORD(CIPHER_IN3), YWORD(T3); \
+			vpclmulqdq	$0x10, YWORD(T9), YWORD(CIPHER_IN3), YWORD(T4); \
+		.else;	\
+			vmovdqu64	hashk + OFFSET(KP), YWORD(T9); \
+			vpclmulqdq	$0x11, YWORD(T9), YWORD(CIPHER_IN3), YWORD(T5); \
+			vpclmulqdq	$0x00, YWORD(T9), YWORD(CIPHER_IN3), YWORD(T6); \
+			vpclmulqdq	$0x01, YWORD(T9), YWORD(CIPHER_IN3), YWORD(T7); \
+			vpclmulqdq	$0x10, YWORD(T9), YWORD(CIPHER_IN3), YWORD(T8); \
+		.endif; \
+	.elseif blocks_left == 3;  \
+		.if first_result == 1;	\
+			vmovdqu64	hashk + OFFSET(KP), YWORD(T9); \
+			vinserti64x2	$2, 32 + hashk + OFFSET(KP), T9, T9; \
+			vpclmulqdq	$0x11, T9, CIPHER_IN3, T1; \
+			vpclmulqdq	$0x00, T9, CIPHER_IN3, T2; \
+			vpclmulqdq	$0x01, T9, CIPHER_IN3, T3; \
+			vpclmulqdq	$0x10, T9, CIPHER_IN3, T4; \
+		.else;	\
+			vmovdqu64	hashk + OFFSET(KP), YWORD(T9); \
+			vinserti64x2	$2, 32 + hashk + OFFSET(KP), T9, T9; \
+			vpclmulqdq	$0x11, T9, CIPHER_IN3, T5; \
+			vpclmulqdq	$0x00, T9, CIPHER_IN3, T6; \
+			vpclmulqdq	$0x01, T9, CIPHER_IN3, T7; \
+			vpclmulqdq	$0x10, T9, CIPHER_IN3, T8; \
+		.endif; \
+	.endif; \
+	.if first_result != 1; \
+			vpxorq		T5, T1, T1; \
+			vpxorq		T6, T2, T2; \
+			vpxorq		T7, T3, T3; \
+			vpxorq		T8, T4, T4; \
+	.endif; \
+	.endif; \
+.else;	\
+	vmovdqu64	hashk + OFFSET(KP), T9; \
+	.if first_result == 1; \
+		vpclmulqdq	$0x11, T9, CIPHER_IN0, T1; \
+		vpclmulqdq	$0x00, T9, CIPHER_IN0, T2; \
+		vpclmulqdq	$0x01, T9, CIPHER_IN0, T3; \
+		vpclmulqdq	$0x10, T9, CIPHER_IN0, T4; \
+		first_result = 0; \
+	.else; \
+		vpclmulqdq	$0x11, T9, CIPHER_IN0, T5; \
+		vpclmulqdq	$0x00, T9, CIPHER_IN0, T6; \
+		vpclmulqdq	$0x01, T9, CIPHER_IN0, T7; \
+		vpclmulqdq	$0x10, T9, CIPHER_IN0, T8; \
+		vpxorq		T5, T1, T1; \
+		vpxorq		T6, T2, T2; \
+		vpxorq		T7, T3, T3; \
+		vpxorq		T8, T4, T4; \
+	.endif; \
+	.set hashk, hashk + 64; \
+	.set blocks_left, blocks_left - 4; \
+	.set reg_idx, reg_idx + 1;     \
+	vmovdqu64	hashk + OFFSET(KP), T9; \
+	.if first_result == 1; \
+		vpclmulqdq	$0x11, T9, CIPHER_IN1, T1; \
+		vpclmulqdq	$0x00, T9, CIPHER_IN1, T2; \
+		vpclmulqdq	$0x01, T9, CIPHER_IN1, T3; \
+		vpclmulqdq	$0x10, T9, CIPHER_IN1, T4; \
+		first_result = 0; \
+	.else; \
+		vpclmulqdq	$0x11, T9, CIPHER_IN1, T5; \
+		vpclmulqdq	$0x00, T9, CIPHER_IN1, T6; \
+		vpclmulqdq	$0x01, T9, CIPHER_IN1, T7; \
+		vpclmulqdq	$0x10, T9, CIPHER_IN1, T8; \
+		vpxorq		T5, T1, T1; \
+		vpxorq		T6, T2, T2; \
+		vpxorq		T7, T3, T3; \
+		vpxorq		T8, T4, T4; \
+	.endif; \
+	.set hashk, hashk + 64; \
+	.set blocks_left, blocks_left - 4; \
+	.set reg_idx, reg_idx + 1;	\
+	vmovdqu64	hashk + OFFSET(KP), T9; \
+	.if first_result == 1; \
+		vpclmulqdq	$0x11, T9, CIPHER_IN2, T1; \
+		vpclmulqdq	$0x00, T9, CIPHER_IN2, T2; \
+		vpclmulqdq	$0x01, T9, CIPHER_IN2, T3; \
+		vpclmulqdq	$0x10, T9, CIPHER_IN2, T4; \
+		first_result = 0; \
+	.else; \
+		vpclmulqdq	$0x11, T9, CIPHER_IN2, T5; \
+		vpclmulqdq	$0x00, T9, CIPHER_IN2, T6; \
+		vpclmulqdq	$0x01, T9, CIPHER_IN2, T7; \
+		vpclmulqdq	$0x10, T9, CIPHER_IN2, T8; \
+		vpxorq		T5, T1, T1; \
+		vpxorq		T6, T2, T2; \
+		vpxorq		T7, T3, T3; \
+		vpxorq		T8, T4, T4; \
+	.endif; \
+	.set hashk, hashk + 64; \
+	.set blocks_left, blocks_left - 4; \
+	.set reg_idx, reg_idx + 1;	\
+	vmovdqu64	hashk + OFFSET(KP), T9; \
+	.if first_result == 1; \
+		vpclmulqdq	$0x11, T9, CIPHER_IN3, T1; \
+		vpclmulqdq	$0x00, T9, CIPHER_IN3, T2; \
+		vpclmulqdq	$0x01, T9, CIPHER_IN3, T3; \
+		vpclmulqdq	$0x10, T9, CIPHER_IN3, T4; \
+		first_result = 0; \
+	.else; \
+		vpclmulqdq	$0x11, T9, CIPHER_IN3, T5; \
+		vpclmulqdq	$0x00, T9, CIPHER_IN3, T6; \
+		vpclmulqdq	$0x01, T9, CIPHER_IN3, T7; \
+		vpclmulqdq	$0x10, T9, CIPHER_IN3, T8; \
+		vpxorq		T5, T1, T1; \
+		vpxorq		T6, T2, T2; \
+		vpxorq		T7, T3, T3; \
+		vpxorq		T8, T4, T4; \
+	.endif; \
+	.set hashk, hashk + 64; \
+	.set blocks_left, blocks_left - 4; \
+	.set reg_idx, reg_idx + 1;	\
+.endif; \
+.if reduce == 1; \
+	vpxorq		T4, T3, T3; \
+	vpsrldq		$8, T3, T7; \
+	vpslldq		$8, T3, T8; \
+	vpxorq		T7, T1, T1; \
+	vpxorq		T8, T2, T2; \
+	VHPXORI4x128(T1, T7); \
+	VHPXORI4x128(T2, T8); \
+	vmovdqa64	POLY2(%rip), XWORD(T9); \
+	VCLMUL_REDUCE(XWORD(GHASH), XWORD(T9), XWORD(T1), XWORD(T2), XWORD(T3), XWORD(T4)) \
+.else; \
+	vmovdqa64	T1, PREV_H; \
+	vmovdqa64	T2, PREV_L; \
+	vmovdqa64	T3, PREV_M1; \
+	vmovdqa64	T4, PREV_M2; \
+.endif;
+
+/*
+ * Calculates the hash of the data which will not be encrypted.
+ * Input: The input data (A_IN), that data's length (A_LEN), and the hash key (GDATA_KEY).
+ * Output: The hash of the data (AAD_HASH).
+ */
+#define CALC_AAD_HASH(A_IN, A_LEN, AAD_HASH, GDATA_KEY, ZT0, ZT1, ZT2, ZT3, ZT4, ZT5, ZT6, ZT7, ZT8, ZT9, ZT10, ZT11, ZT12, ZT13, ZT14, ZT15, ZT16, ZT17, T1, T2, T3, MASKREG, OFFSET) \
+	mov	A_IN, T1; \
+	mov	A_LEN, T2; \
+	or	T2, T2; \
+	jz	0f; \
+	vmovdqa64	SHUF_MASK(%rip), ZT13; \
+20:; \
+	cmp	$(48*16), T2; \
+	jl	21f; \
+	vmovdqu64	64*0(T1), ZT1; \
+	vmovdqu64	64*1(T1), ZT2; \
+	vmovdqu64	64*2(T1), ZT3; \
+	vmovdqu64	64*3(T1), ZT4; \
+	vpshufb ZT13, ZT1, ZT1; \
+	vpshufb ZT13, ZT2, ZT2; \
+	vpshufb ZT13, ZT3, ZT3; \
+	vpshufb ZT13, ZT4, ZT4; \
+	GHASH_1_TO_16(GDATA_KEY, OFFSET, ZWORD(AAD_HASH), ZT0, ZT5, ZT6, ZT7, ZT8, ZT9, ZT10, ZT11, ZT12, ZWORD(AAD_HASH), ZT1, ZT2, ZT3, ZT4, 16, 1, multi_call, first, 48, ZT14, ZT15, ZT16, ZT17) \
+	vmovdqu64     0 + 256(T1), ZT1; \
+	vmovdqu64     64 + 256(T1), ZT2; \
+	vmovdqu64     128 + 256(T1), ZT3; \
+	vmovdqu64     192 + 256(T1), ZT4; \
+	vpshufb ZT13, ZT1, ZT1; \
+	vpshufb ZT13, ZT2, ZT2; \
+	vpshufb ZT13, ZT3, ZT3; \
+	vpshufb ZT13, ZT4, ZT4; \
+	GHASH_1_TO_16(GDATA_KEY, OFFSET, ZWORD(AAD_HASH), ZT0, ZT5, ZT6, ZT7, ZT8, ZT9, ZT10, ZT11, ZT12, ZWORD(AAD_HASH), ZT1, ZT2, ZT3, ZT4, 16, 1, multi_call, mid, 32, ZT14, ZT15, ZT16, ZT17) \
+	vmovdqu64     0 + 512(T1), ZT1; \
+	vmovdqu64     64 + 512(T1), ZT2; \
+	vmovdqu64     128 + 512(T1), ZT3; \
+	vmovdqu64     192 + 512(T1), ZT4; \
+	vpshufb ZT13, ZT1, ZT1; \
+	vpshufb ZT13, ZT2, ZT2; \
+	vpshufb ZT13, ZT3, ZT3; \
+	vpshufb ZT13, ZT4, ZT4; \
+	GHASH_1_TO_16(GDATA_KEY, OFFSET, ZWORD(AAD_HASH), ZT0, ZT5, ZT6, ZT7, ZT8, ZT9, ZT10, ZT11, ZT12, ZWORD(AAD_HASH), ZT1, ZT2, ZT3, ZT4, 16, 1, multi_call, last, 16, ZT14, ZT15, ZT16, ZT17) \
+	sub	$(48*16), T2; \
+	je	0f; \
+	add	$(48*16), T1; \
+	jmp	20b; \
+21:; \
+	cmp	$(32*16), T2; \
+	jl	22f; \
+	vmovdqu64	64*0(T1), ZT1; \
+	vmovdqu64	64*1(T1), ZT2; \
+	vmovdqu64	64*2(T1), ZT3; \
+	vmovdqu64	64*3(T1), ZT4; \
+	vpshufb ZT13, ZT1, ZT1; \
+	vpshufb ZT13, ZT2, ZT2; \
+	vpshufb ZT13, ZT3, ZT3; \
+	vpshufb ZT13, ZT4, ZT4; \
+	GHASH_1_TO_16(GDATA_KEY, OFFSET, ZWORD(AAD_HASH), ZT0, ZT5, ZT6, ZT7, ZT8, ZT9, ZT10, ZT11, ZT12, ZWORD(AAD_HASH), ZT1, ZT2, ZT3, ZT4, 16, 1, multi_call, first, 32, ZT14, ZT15, ZT16, ZT17) \
+	vmovdqu64     0 + 256(T1), ZT1; \
+	vmovdqu64     64 + 256(T1), ZT2; \
+	vmovdqu64     128 + 256(T1), ZT3; \
+	vmovdqu64     192 + 256(T1), ZT4; \
+	vpshufb ZT13, ZT1, ZT1; \
+	vpshufb ZT13, ZT2, ZT2; \
+	vpshufb ZT13, ZT3, ZT3; \
+	vpshufb ZT13, ZT4, ZT4; \
+	GHASH_1_TO_16(GDATA_KEY, OFFSET, ZWORD(AAD_HASH), ZT0, ZT5, ZT6, ZT7, ZT8, ZT9, ZT10, ZT11, ZT12, ZWORD(AAD_HASH), ZT1, ZT2, ZT3, ZT4, 16, 1, multi_call, last, 16, ZT14, ZT15, ZT16, ZT17) \
+	sub	$(32*16), T2; \
+	je	0f; \
+	add	$(32*16), T1; \
+	jmp	23f; \
+22:; \
+	cmp	$(16*16), T2; \
+	jl	23f; \
+	vmovdqu64	64*0(T1), ZT1; \
+	vmovdqu64	64*1(T1), ZT2; \
+	vmovdqu64	64*2(T1), ZT3; \
+	vmovdqu64	64*3(T1), ZT4; \
+	vpshufb ZT13, ZT1, ZT1; \
+	vpshufb ZT13, ZT2, ZT2; \
+	vpshufb ZT13, ZT3, ZT3; \
+	vpshufb ZT13, ZT4, ZT4; \
+	GHASH_1_TO_16(GDATA_KEY, OFFSET, ZWORD(AAD_HASH), ZT0, ZT5, ZT6, ZT7, ZT8, ZT9, ZT10, ZT11, ZT12, ZWORD(AAD_HASH), ZT1, ZT2, ZT3, ZT4, 16, 1, single_call, NULL, NULL, NULL, NULL, NULL, NULL) \
+	sub	$(16*16), T2; \
+	je	0f; \
+	add	$(16*16), T1; \
+23:; \
+	lea	byte64_len_to_mask_table(%rip), T3; \
+	lea	(T3, T2, 8), T3; \
+	add	$15, T2; \
+	and	$-16, T2; \
+	shr	$4, T2; \
+	cmp	$1, T2; \
+	je	1f; \
+	cmp	$2, T2; \
+	je	2f; \
+	cmp	$3, T2; \
+	je	3f; \
+	cmp	$4, T2; \
+	je	4f; \
+	cmp	$5, T2; \
+	je	5f; \
+	cmp	$6, T2; \
+	je	6f; \
+	cmp	$7, T2; \
+	je	7f; \
+	cmp	$8, T2; \
+	je	8f; \
+	cmp	$9, T2; \
+	je	9f; \
+	cmp	$10, T2; \
+	je	10f; \
+	cmp	$11, T2; \
+	je	11f; \
+	cmp	$12, T2; \
+	je	12f; \
+	cmp	$13, T2; \
+	je	13f; \
+	cmp	$14, T2; \
+	je	14f; \
+	cmp	$15, T2; \
+	je	15f; \
+16:; \
+	sub $(64*3*8), T3; \
+	kmovq	(T3), MASKREG; \
+	vmovdqu8  64*0(T1), ZT1; \
+	vmovdqu8  64*1(T1), ZT2; \
+	vmovdqu8  64*2(T1), ZT3; \
+	vmovdqu8  64*3(T1), ZT4{MASKREG}{z}; \
+	vpshufb ZT13, ZT1, ZT1; \
+	vpshufb ZT13, ZT2, ZT2; \
+	vpshufb ZT13, ZT3, ZT3; \
+	vpshufb ZT13, ZT4, ZT4; \
+	GHASH_1_TO_16(GDATA_KEY, OFFSET, ZWORD(AAD_HASH), ZT0, ZT5, ZT6, ZT7, ZT8, ZT9, ZT10, ZT11, ZT12, ZWORD(AAD_HASH), ZT1, ZT2, ZT3, ZT4, 16, 1, single_call, NULL, NULL, NULL, NULL, NULL, NULL) \
+	jmp	0f; \
+15:; \
+	sub $(64*3*8), T3; \
+	kmovq	(T3), MASKREG; \
+	vmovdqu8  64*0(T1), ZT1; \
+	vmovdqu8  64*1(T1), ZT2; \
+	vmovdqu8  64*2(T1), ZT3; \
+	vmovdqu8  64*3(T1), ZT4{MASKREG}{z}; \
+	vpshufb ZT13, ZT1, ZT1; \
+	vpshufb ZT13, ZT2, ZT2; \
+	vpshufb ZT13, ZT3, ZT3; \
+	vpshufb ZT13, ZT4, ZT4; \
+	GHASH_1_TO_16(GDATA_KEY, OFFSET, ZWORD(AAD_HASH), ZT0, ZT5, ZT6, ZT7, ZT8, ZT9, ZT10, ZT11, ZT12, ZWORD(AAD_HASH), ZT1, ZT2, ZT3, ZT4, 15, 1, single_call, NULL, NULL, NULL, NULL, NULL, NULL) \
+	jmp	0f; \
+14:; \
+	sub $(64*3*8), T3; \
+	kmovq	(T3), MASKREG; \
+	vmovdqu8  64*0(T1), ZT1; \
+	vmovdqu8  64*1(T1), ZT2; \
+	vmovdqu8  64*2(T1), ZT3; \
+	vmovdqu8  64*3(T1), ZT4{MASKREG}{z}; \
+	vpshufb ZT13, ZT1, ZT1; \
+	vpshufb ZT13, ZT2, ZT2; \
+	vpshufb ZT13, ZT3, ZT3; \
+	vpshufb ZT13, ZT4, ZT4; \
+	GHASH_1_TO_16(GDATA_KEY, OFFSET, ZWORD(AAD_HASH), ZT0, ZT5, ZT6, ZT7, ZT8, ZT9, ZT10, ZT11, ZT12, ZWORD(AAD_HASH), ZT1, ZT2, ZT3, ZT4, 14, 1, single_call, NULL, NULL, NULL, NULL, NULL, NULL) \
+	jmp	0f; \
+13:; \
+	sub $(64*3*8), T3; \
+	kmovq	(T3), MASKREG; \
+	vmovdqu8  64*0(T1), ZT1; \
+	vmovdqu8  64*1(T1), ZT2; \
+	vmovdqu8  64*2(T1), ZT3; \
+	vmovdqu8  64*3(T1), ZT4{MASKREG}{z}; \
+	vpshufb ZT13, ZT1, ZT1; \
+	vpshufb ZT13, ZT2, ZT2; \
+	vpshufb ZT13, ZT3, ZT3; \
+	vpshufb ZT13, ZT4, ZT4; \
+	GHASH_1_TO_16(GDATA_KEY, OFFSET, ZWORD(AAD_HASH), ZT0, ZT5, ZT6, ZT7, ZT8, ZT9, ZT10, ZT11, ZT12, ZWORD(AAD_HASH), ZT1, ZT2, ZT3, ZT4, 13, 1, single_call, NULL, NULL, NULL, NULL, NULL, NULL) \
+	jmp	0f; \
+12:; \
+	sub $(64*2*8), T3; \
+	kmovq	(T3), MASKREG; \
+	vmovdqu8  64*0(T1), ZT1; \
+	vmovdqu8  64*1(T1), ZT2; \
+	vmovdqu8  64*2(T1), ZT3{MASKREG}{z}; \
+	vpshufb ZT13, ZT1, ZT1; \
+	vpshufb ZT13, ZT2, ZT2; \
+	vpshufb ZT13, ZT3, ZT3; \
+	GHASH_1_TO_16(GDATA_KEY, OFFSET, ZWORD(AAD_HASH), ZT0, ZT5, ZT6, ZT7, ZT8, ZT9, ZT10, ZT11, ZT12, ZWORD(AAD_HASH), ZT1, ZT2, ZT3, no_zmm, 12, 1, single_call, NULL, NULL, NULL, NULL, NULL, NULL) \
+	jmp	0f; \
+11:; \
+	sub $(64*2*8), T3; \
+	kmovq	(T3), MASKREG; \
+	vmovdqu8  64*0(T1), ZT1; \
+	vmovdqu8  64*1(T1), ZT2; \
+	vmovdqu8  64*2(T1), ZT3{MASKREG}{z}; \
+	vpshufb ZT13, ZT1, ZT1; \
+	vpshufb ZT13, ZT2, ZT2; \
+	vpshufb ZT13, ZT3, ZT3; \
+	GHASH_1_TO_16(GDATA_KEY, OFFSET, ZWORD(AAD_HASH), ZT0, ZT5, ZT6, ZT7, ZT8, ZT9, ZT10, ZT11, ZT12, ZWORD(AAD_HASH), ZT1, ZT2, ZT3, no_zmm, 11, 1, single_call, NULL, NULL, NULL, NULL, NULL, NULL) \
+	jmp	0f; \
+10:; \
+	sub $(64*2*8), T3; \
+	kmovq	(T3), MASKREG; \
+	vmovdqu8  64*0(T1), ZT1; \
+	vmovdqu8  64*1(T1), ZT2; \
+	vmovdqu8  64*2(T1), ZT3{MASKREG}{z}; \
+	vpshufb ZT13, ZT1, ZT1; \
+	vpshufb ZT13, ZT2, ZT2; \
+	vpshufb ZT13, ZT3, ZT3; \
+	GHASH_1_TO_16(GDATA_KEY, OFFSET, ZWORD(AAD_HASH), ZT0, ZT5, ZT6, ZT7, ZT8, ZT9, ZT10, ZT11, ZT12, ZWORD(AAD_HASH), ZT1, ZT2, ZT3, no_zmm, 10, 1, single_call, NULL, NULL, NULL, NULL, NULL, NULL) \
+	jmp	0f; \
+9:; \
+	sub $(64*2*8), T3; \
+	kmovq	(T3), MASKREG; \
+	vmovdqu8  64*0(T1), ZT1; \
+	vmovdqu8  64*1(T1), ZT2; \
+	vmovdqu8  64*2(T1), ZT3{MASKREG}{z}; \
+	vpshufb ZT13, ZT1, ZT1; \
+	vpshufb ZT13, ZT2, ZT2; \
+	vpshufb ZT13, ZT3, ZT3; \
+	GHASH_1_TO_16(GDATA_KEY, OFFSET, ZWORD(AAD_HASH), ZT0, ZT5, ZT6, ZT7, ZT8, ZT9, ZT10, ZT11, ZT12, ZWORD(AAD_HASH), ZT1, ZT2, ZT3, no_zmm, 9, 1, single_call, NULL, NULL, NULL, NULL, NULL, NULL) \
+	jmp	0f; \
+8:; \
+	sub $(64*8), T3; \
+	kmovq	(T3), MASKREG; \
+	vmovdqu8  64*0(T1), ZT1; \
+	vmovdqu8  64*1(T1), ZT2{MASKREG}{z}; \
+	vpshufb ZT13, ZT1, ZT1; \
+	vpshufb ZT13, ZT2, ZT2; \
+	GHASH_1_TO_16(GDATA_KEY, OFFSET, ZWORD(AAD_HASH), ZT0, ZT3, ZT4, ZT5, ZT6, ZT7, ZT8, ZT9, ZT10, ZWORD(AAD_HASH), ZT1, ZT2, no_zmm, no_zmm, 8, 1, single_call, NULL, NULL, NULL, NULL, NULL, NULL) \
+	jmp	0f; \
+7:; \
+	sub $(64*8), T3; \
+	kmovq	(T3), MASKREG; \
+	vmovdqu8  64*0(T1), ZT1; \
+	vmovdqu8  64*1(T1), ZT2{MASKREG}{z}; \
+	vpshufb ZT13, ZT1, ZT1; \
+	vpshufb ZT13, ZT2, ZT2; \
+	GHASH_1_TO_16(GDATA_KEY, OFFSET, ZWORD(AAD_HASH), ZT0, ZT3, ZT4, ZT5, ZT6, ZT7, ZT8, ZT9, ZT10, ZWORD(AAD_HASH), ZT1, ZT2, no_zmm, no_zmm, 7, 1, single_call, NULL, NULL, NULL, NULL, NULL, NULL) \
+	jmp	0f; \
+6:; \
+	sub $(64*8), T3; \
+	kmovq	(T3), MASKREG; \
+	vmovdqu8  64*0(T1), ZT1; \
+	vmovdqu8  64*1(T1), YWORD(ZT2){MASKREG}{z}; \
+	vpshufb ZT13, ZT1, ZT1; \
+	vpshufb YWORD(ZT13), YWORD(ZT2), YWORD(ZT2); \
+	GHASH_1_TO_16(GDATA_KEY, OFFSET, ZWORD(AAD_HASH), ZT0, ZT3, ZT4, ZT5, ZT6, ZT7, ZT8, ZT9, ZT10, ZWORD(AAD_HASH), ZT1, ZT2, no_zmm, no_zmm, 6, 1, single_call, NULL, NULL, NULL, NULL, NULL, NULL) \
+	jmp	0f; \
+5:; \
+	sub $(64*8), T3; \
+	kmovq	(T3), MASKREG; \
+	vmovdqu8  64*0(T1), ZT1; \
+	vmovdqu8  64*1(T1), XWORD(ZT2){MASKREG}{z}; \
+	vpshufb ZT13, ZT1, ZT1; \
+	vpshufb XWORD(ZT13), XWORD(ZT2), XWORD(ZT2); \
+	GHASH_1_TO_16(GDATA_KEY, OFFSET, ZWORD(AAD_HASH), ZT0, ZT3, ZT4, ZT5, ZT6, ZT7, ZT8, ZT9, ZT10, ZWORD(AAD_HASH), ZT1, ZT2, no_zmm, no_zmm, 5, 1, single_call, NULL, NULL, NULL, NULL, NULL, NULL) \
+	jmp	0f; \
+4:; \
+	kmovq	(T3), MASKREG; \
+	vmovdqu8  64*0(T1), ZT1{MASKREG}{z}; \
+	vpshufb ZT13, ZT1, ZT1; \
+	GHASH_1_TO_16(GDATA_KEY, OFFSET, ZWORD(AAD_HASH), ZT0, ZT3, ZT4, ZT5, ZT6, ZT7, ZT8, ZT9, ZT10, ZWORD(AAD_HASH), ZT1, no_zmm, no_zmm, no_zmm, 4, 1, single_call, NULL, NULL, NULL, NULL, NULL, NULL) \
+	jmp	0f; \
+3:; \
+	kmovq	(T3), MASKREG; \
+	vmovdqu8  64*0(T1), ZT1{MASKREG}{z}; \
+	vpshufb ZT13, ZT1, ZT1; \
+	GHASH_1_TO_16(GDATA_KEY, OFFSET, ZWORD(AAD_HASH), ZT0, ZT3, ZT4, ZT5, ZT6, ZT7, ZT8, ZT9, ZT10, ZWORD(AAD_HASH), ZT1, no_zmm, no_zmm, no_zmm, 3, 1, single_call, NULL, NULL, NULL, NULL, NULL, NULL) \
+	jmp	0f; \
+2:; \
+	kmovq	(T3), MASKREG; \
+	vmovdqu8  64*0(T1), YWORD(ZT1){MASKREG}{z}; \
+	vpshufb YWORD(ZT13), YWORD(ZT1), YWORD(ZT1); \
+	GHASH_1_TO_16(GDATA_KEY, OFFSET, ZWORD(AAD_HASH), ZT0, ZT3, ZT4, ZT5, ZT6, ZT7, ZT8, ZT9, ZT10, ZWORD(AAD_HASH), ZT1, no_zmm, no_zmm, no_zmm, 2, 1, single_call, NULL, NULL, NULL, NULL, NULL, NULL) \
+	jmp	0f; \
+1:; \
+	kmovq	(T3), MASKREG; \
+	vmovdqu8  64*0(T1), XWORD(ZT1){MASKREG}{z}; \
+	vpshufb XWORD(ZT13), XWORD(ZT1), XWORD(ZT1); \
+	GHASH_1_TO_16(GDATA_KEY, OFFSET, ZWORD(AAD_HASH), ZT0, ZT3, ZT4, ZT5, ZT6, ZT7, ZT8, ZT9, ZT10, ZWORD(AAD_HASH), ZT1, no_zmm, no_zmm, no_zmm, 1, 1, single_call, NULL, NULL, NULL, NULL, NULL, NULL) \
+0:;
diff --git a/arch/x86/crypto/ghash-clmulni-intel_avx512.S b/arch/x86/crypto/ghash-clmulni-intel_avx512.S
new file mode 100644
index 0000000..9cbc40f
--- /dev/null
+++ b/arch/x86/crypto/ghash-clmulni-intel_avx512.S
@@ -0,0 +1,68 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright © 2020 Intel Corporation.
+ *
+ * Implement GHASH calculation with AVX512 instructions. (x86_64)
+ *
+ * This is GHASH calculation with AVX512 instructions. It requires
+ * the support of Intel(R) AVX512F and VPCLMULQDQ instructions.
+ */
+
+#include "avx512_vaes_common.S"
+
+/*
+ * void ghash_precomp_avx512(u8 *key_data);
+ */
+SYM_FUNC_START(ghash_precomp_avx512)
+        FUNC_SAVE_GHASH()
+
+        /* move original key to xmm6 */
+        vmovdqu HashKey_1(arg1), %xmm6
+
+        vpshufb SHUF_MASK(%rip), %xmm6, %xmm6
+
+        vmovdqa %xmm6, %xmm2
+        vpsllq  $1, %xmm6, %xmm6
+        vpsrlq  $63, %xmm2, %xmm2
+        vmovdqa %xmm2, %xmm1
+        vpslldq $8, %xmm2, %xmm2
+        vpsrldq $8, %xmm1, %xmm1
+        vpor %xmm2, %xmm6, %xmm6
+        vpshufd $36, %xmm1, %xmm2
+        vpcmpeqd TWOONE(%rip), %xmm2, %xmm2
+        vpand POLY(%rip), %xmm2, %xmm2
+        vpxor %xmm2, %xmm6, %xmm6
+        vmovdqu %xmm6, HashKey_1(arg1)
+
+        PRECOMPUTE(arg1, %xmm6, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm7, %xmm8)
+
+        FUNC_RESTORE_GHASH()
+
+        ret
+SYM_FUNC_END(ghash_precomp_avx512)
+
+/*
+ * void clmul_ghash_update_avx512
+ *      (uint8_t *dst,
+ *       const uint8_t *src,
+ *       unsigned int srclen,
+ *       struct ghash_ctx_new *key_data);
+ */
+SYM_FUNC_START(clmul_ghash_update_avx512)
+        FUNC_SAVE_GHASH()
+
+        /* Read current hash value from dst */
+        vmovdqa (arg1), %xmm0
+
+        /* Bswap current hash value */
+        vpshufb SHUF_MASK(%rip), %xmm0, %xmm0
+
+        CALC_AAD_HASH(arg2, arg3, %xmm0, arg4, %zmm1, %zmm2, %zmm3, %zmm4, %zmm5, %zmm6, %zmm7, %zmm8, %zmm9, %zmm10, %zmm11, %zmm12, %zmm13, %zmm15, %zmm16, %zmm17, %zmm18, %zmm19, %r10, %r11, %r12, %k1, 0)
+
+        /* Bswap current hash value before storing */
+        vpshufb SHUF_MASK(%rip), %xmm0, %xmm0
+        vmovdqu %xmm0, (arg1)
+
+        FUNC_RESTORE_GHASH()
+
+        ret
+SYM_FUNC_END(clmul_ghash_update_avx512)
diff --git a/arch/x86/crypto/ghash-clmulni-intel_glue.c b/arch/x86/crypto/ghash-clmulni-intel_glue.c
index 1f1a95f..3a3e8ea 100644
--- a/arch/x86/crypto/ghash-clmulni-intel_glue.c
+++ b/arch/x86/crypto/ghash-clmulni-intel_glue.c
@@ -22,18 +22,39 @@
 
 #define GHASH_BLOCK_SIZE	16
 #define GHASH_DIGEST_SIZE	16
+#define GHASH_KEY_LEN		16
+
+static bool use_avx512;
+module_param(use_avx512, bool, 0644);
+MODULE_PARM_DESC(use_avx512, "Use AVX512 optimized algorithm, if available");
 
 void clmul_ghash_mul(char *dst, const u128 *shash);
 
 void clmul_ghash_update(char *dst, const char *src, unsigned int srclen,
 			const u128 *shash);
 
+extern void ghash_precomp_avx512(u8 *key_data);
+#ifdef CONFIG_CRYPTO_GHASH_CLMUL_NI_AVX512
+extern void clmul_ghash_update_avx512(char *dst, const char *src, unsigned int srclen,
+				      u8 *shash);
+#else
+static void clmul_ghash_update_avx512(char *dst, const char *src, unsigned int srclen,
+			       u8 *shash)
+{}
+#endif
+
 struct ghash_async_ctx {
 	struct cryptd_ahash *cryptd_tfm;
 };
 
+/*
+ * This is needed for schoolbook multiply purposes.
+ * (HashKey << 1 mod poly), (HashKey^2 << 1 mod poly), ...,
+ * (Hashkey^48 << 1 mod poly)
+ */
 struct ghash_ctx {
 	u128 shash;
+	u8 hkey[GHASH_KEY_LEN * 48];
 };
 
 struct ghash_desc_ctx {
@@ -56,6 +77,15 @@ static int ghash_setkey(struct crypto_shash *tfm,
 	struct ghash_ctx *ctx = crypto_shash_ctx(tfm);
 	be128 *x = (be128 *)key;
 	u64 a, b;
+	int i;
+
+	if (IS_ENABLED(CONFIG_CRYPTO_GHASH_CLMUL_NI_AVX512) &&
+	    cpu_feature_enabled(X86_FEATURE_VPCLMULQDQ) && use_avx512) {
+		for (i = 0; i < 16; i++)
+			ctx->hkey[(16 * 47) + i] = key[i];
+
+		ghash_precomp_avx512(ctx->hkey);
+	}
 
 	if (keylen != GHASH_BLOCK_SIZE)
 		return -EINVAL;
@@ -94,8 +124,13 @@ static int ghash_update(struct shash_desc *desc,
 		if (!dctx->bytes)
 			clmul_ghash_mul(dst, &ctx->shash);
 	}
-
-	clmul_ghash_update(dst, src, srclen, &ctx->shash);
+	if (IS_ENABLED(CONFIG_CRYPTO_GHASH_CLMUL_NI_AVX512) &&
+	    cpu_feature_enabled(X86_FEATURE_VPCLMULQDQ) && use_avx512) {
+		/* Assembly code handles fragments in 16 byte multiples */
+		srclen = ALIGN_DOWN(srclen, 16);
+		clmul_ghash_update_avx512(dst, src, srclen, ctx->hkey);
+	} else
+		clmul_ghash_update(dst, src, srclen, &ctx->shash);
 	kernel_fpu_end();
 
 	if (srclen & 0xf) {
diff --git a/crypto/Kconfig b/crypto/Kconfig
index b090f14..70d1d35 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -637,6 +637,18 @@ config CRYPTO_CRCT10DIF_AVX512
 	depends on CRYPTO_CRCT10DIF_PCLMUL
 	depends on AS_VPCLMULQDQ
 
+# We default CRYPTO_GHASH_CLMUL_NI_AVX512 to Y but depend on CRYPTO_AVX512 in
+# order to have a singular option (CRYPTO_AVX512) select multiple algorithms
+# when supported. Specifically, if the platform and/or toolset does not
+# support VPLMULQDQ. Then this algorithm should not be supported as part of
+# the set that CRYPTO_AVX512 selects.
+config CRYPTO_GHASH_CLMUL_NI_AVX512
+	bool
+	default y
+	depends on CRYPTO_AVX512
+	depends on CRYPTO_GHASH_CLMUL_NI_INTEL
+	depends on AS_VPCLMULQDQ
+
 config CRYPTO_CRC32C_SPARC64
 	tristate "CRC32c CRC algorithm (SPARC64)"
 	depends on SPARC64
-- 
2.7.4

