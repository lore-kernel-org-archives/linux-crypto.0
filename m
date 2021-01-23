Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16DEFC433DB
	for <linux-crypto@archiver.kernel.org>; Sat, 23 Jan 2021 07:31:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2588239D4
	for <linux-crypto@archiver.kernel.org>; Sat, 23 Jan 2021 07:31:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbhAWHbJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 23 Jan 2021 02:31:09 -0500
Received: from mga12.intel.com ([192.55.52.136]:5178 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726554AbhAWHbA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 23 Jan 2021 02:31:00 -0500
IronPort-SDR: MOv3/Y6PZJ0ulGPPjHflYO/FHitCAKgsIFXin+Y8a75iM++MxJbO7otdWpsw00QLi9+ANjBF8F
 ZkT262PcRYPQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9872"; a="158731943"
X-IronPort-AV: E=Sophos;i="5.79,368,1602572400"; 
   d="scan'208";a="158731943"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2021 23:29:46 -0800
IronPort-SDR: FIVbqqYhIEty4ZMWreKEunqmKmvuGwvg9ScFHFSainpjvECoGdhgDlWQs6QmcfOhQiXJbE6Hcp
 BeCb+MJ6bfPQ==
X-IronPort-AV: E=Sophos;i="5.79,368,1602572400"; 
   d="scan'208";a="468448082"
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
Subject: [RFC V2 4/5] crypto: aesni - AES CTR x86_64 "by16" AVX512 optimization
Date:   Fri, 22 Jan 2021 23:28:39 -0800
Message-Id: <1611386920-28579-5-git-send-email-megha.dey@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1611386920-28579-1-git-send-email-megha.dey@intel.com>
References: <1611386920-28579-1-git-send-email-megha.dey@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Introduce the "by16" implementation of the AES CTR mode using AVX512
optimizations. "by16" means that 16 independent blocks (each block
being 128 bits) can be ciphered simultaneously as opposed to the
current 8 blocks.

The glue code in AESNI module overrides the existing "by8" CTR mode
encryption/decryption routines with the "by16" ones when the following
criteria are met:
At compile time:
1. CONFIG_CRYPTO_AVX512 is enabled
2. toolchain(assembler) supports VAES instructions
At runtime:
1. VAES and AVX512VL features are supported on platform (currently
   only Icelake)
2. If compiled as built-in or loadable module, aesni_intel.use_avx512
   is set at boot time.

The functions aes_ctr_enc_128_avx512_by16(), aes_ctr_enc_192_avx512_by16()
and aes_ctr_enc_256_avx512_by16() are adapted from Intel Optimized IPSEC
Cryptographic library.

On a Icelake desktop, with turbo disabled and all CPUs running at maximum
frequency, the "by16" CTR mode optimization shows better performance
across data & key sizes as measured by tcrypt.

The average performance improvement of the "by16" version over the "by8"
version is as follows:
For all key sizes(128/192/256 bits),
        data sizes < 128 bytes/block, negligible improvement(~3% loss)
        data sizes > 128 bytes/block, there is an average improvement of
48% for both encryption and decryption.

A typical run of tcrypt with AES CTR mode encryption/decryption of the
"by8" and "by16" optimization on a Icelake desktop shows the following
results:
--------------------------------------------------------------
|  key   | bytes | cycles/op (lower is better)| percentage   |
| length |  per  |  encryption  |  decryption |  loss/gain   |
| (bits) | block |-------------------------------------------|
|        |       | by8  | by16  | by8  | by16 |  enc | dec   |
|------------------------------------------------------------|
|  128   |  16   | 156  | 168   | 164  | 168  | -7.7 |  -2.5 |
|  128   |  64   | 180  | 190   | 157  | 146  | -5.6 |   7.1 |
|  128   |  256  | 248  | 158   | 251  | 161  | 36.3 |  35.9 |
|  128   |  1024 | 633  | 316   | 642  | 319  | 50.1 |  50.4 |
|  128   |  1472 | 853  | 411   | 877  | 407  | 51.9 |  53.6 |
|  128   |  8192 | 4463 | 1959  | 4447 | 1940 | 56.2 |  56.4 |
|  192   |  16   | 136  | 145   | 149  | 166  | -6.7 | -11.5 |
|  192   |  64   | 159  | 154   | 157  | 160  |  3.2 |  -2   |
|  192   |  256  | 268  | 172   | 274  | 177  | 35.9 |  35.5 |
|  192   |  1024 | 710  | 358   | 720  | 355  | 49.6 |  50.7 |
|  192   |  1472 | 989  | 468   | 983  | 469  | 52.7 |  52.3 |
|  192   |  8192 | 6326 | 3551  | 6301 | 3567 | 43.9 |  43.4 |
|  256   |  16   | 153  | 165   | 139  | 156  | -7.9 | -12.3 |
|  256   |  64   | 158  | 152   | 174  | 161  |  3.8 |   7.5 |
|  256   |  256  | 283  | 176   | 287  | 202  | 37.9 |  29.7 |
|  256   |  1024 | 797  | 393   | 807  | 395  | 50.7 |  51.1 |
|  256   |  1472 | 1108 | 534   | 1107 | 527  | 51.9 |  52.4 |
|  256   |  8192 | 5763 | 2616  | 5773 | 2617 | 54.7 |  54.7 |
--------------------------------------------------------------

This work was inspired by the AES CTR mode optimization published
in Intel Optimized IPSEC Cryptographic library.
https://github.com/intel/intel-ipsec-mb/blob/master/lib/avx512/cntr_vaes_avx512.asm

Co-developed-by: Tomasz Kantecki <tomasz.kantecki@intel.com>
Signed-off-by: Tomasz Kantecki <tomasz.kantecki@intel.com>
Signed-off-by: Megha Dey <megha.dey@intel.com>
---
 arch/x86/crypto/Makefile                    |   1 +
 arch/x86/crypto/aes_avx512_common.S         | 341 ++++++++++
 arch/x86/crypto/aes_ctrby16_avx512-x86_64.S | 955 ++++++++++++++++++++++++++++
 arch/x86/crypto/aesni-intel_glue.c          |  42 +-
 arch/x86/include/asm/disabled-features.h    |   8 +-
 crypto/Kconfig                              |  12 +
 6 files changed, 1357 insertions(+), 2 deletions(-)
 create mode 100644 arch/x86/crypto/aes_avx512_common.S
 create mode 100644 arch/x86/crypto/aes_ctrby16_avx512-x86_64.S

diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index 662c16d..3f48460 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -51,6 +51,7 @@ chacha-x86_64-$(CONFIG_AS_AVX512) += chacha-avx512vl-x86_64.o
 obj-$(CONFIG_CRYPTO_AES_NI_INTEL) += aesni-intel.o
 aesni-intel-y := aesni-intel_asm.o aesni-intel_glue.o
 aesni-intel-$(CONFIG_64BIT) += aesni-intel_avx-x86_64.o aes_ctrby8_avx-x86_64.o
+aesni-intel-$(CONFIG_CRYPTO_AES_CTR_AVX512) += aes_ctrby16_avx512-x86_64.o
 
 obj-$(CONFIG_CRYPTO_SHA1_SSSE3) += sha1-ssse3.o
 sha1-ssse3-y := sha1_avx2_x86_64_asm.o sha1_ssse3_asm.o sha1_ssse3_glue.o
diff --git a/arch/x86/crypto/aes_avx512_common.S b/arch/x86/crypto/aes_avx512_common.S
new file mode 100644
index 0000000..61c012b
--- /dev/null
+++ b/arch/x86/crypto/aes_avx512_common.S
@@ -0,0 +1,341 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright © 2021 Intel Corporation.
+ *
+ * Collection of macros which are shared between AVX512 versions of
+ * AESNI CTR and GCM algorithms.
+ */
+
+#include <linux/linkage.h>
+#include <asm/inst.h>
+
+/*
+ * Generic macro to produce code that executes OPCODE instruction
+ * on selected number of AES blocks (16 bytes long ) between 0 and 16.
+ * All three operands of the instruction come from registers.
+ */
+#define ZMM_OPCODE3_DSTR_SRC1R_SRC2R_BLOCKS_0_16(NUM_BLOCKS, OPCODE, DST0, DST1, DST2, DST3, SRC1_0, SRC1_1, SRC1_2, SRC1_3, SRC2_0, SRC2_1, SRC2_2, SRC2_3) \
+.set blocks_left,NUM_BLOCKS;						\
+.if NUM_BLOCKS < 4;							\
+	.if blocks_left == 1;						\
+		OPCODE	XWORD(SRC2_0), XWORD(SRC1_0), XWORD(DST0);	\
+	.elseif blocks_left == 2;					\
+		OPCODE	YWORD(SRC2_0), YWORD(SRC1_0), YWORD(DST0);	\
+	.elseif blocks_left == 3;					\
+		OPCODE	SRC2_0, SRC1_0, DST0;				\
+	.endif;								\
+.elseif NUM_BLOCKS >= 4 && NUM_BLOCKS < 8;				\
+	OPCODE	SRC2_0, SRC1_0, DST0;					\
+	.set blocks_left, blocks_left - 4;				\
+	.if blocks_left == 1;						\
+		OPCODE	XWORD(SRC2_1), XWORD(SRC1_1), XWORD(DST1);	\
+	.elseif blocks_left == 2;					\
+		OPCODE	YWORD(SRC2_1), YWORD(SRC1_1), YWORD(DST1);	\
+	.elseif blocks_left == 3;					\
+		OPCODE	SRC2_1, SRC1_1, DST1;				\
+	.endif;								\
+.elseif NUM_BLOCKS >= 8 && NUM_BLOCKS < 12;				\
+	OPCODE	SRC2_0, SRC1_0, DST0;					\
+	.set blocks_left, blocks_left - 4;				\
+	OPCODE	SRC2_1, SRC1_1, DST1;					\
+	.set blocks_left, blocks_left - 4;				\
+	.if blocks_left == 1;						\
+		OPCODE	XWORD(SRC2_2), XWORD(SRC1_2), XWORD(DST2);	\
+	.elseif blocks_left == 2;					\
+		OPCODE	YWORD(SRC2_2), YWORD(SRC1_2), YWORD(DST2);	\
+	.elseif blocks_left == 3;					\
+		OPCODE	SRC2_2, SRC1_2, DST2;				\
+	.endif;								\
+.elseif NUM_BLOCKS >= 12 && NUM_BLOCKS < 16;				\
+	OPCODE	SRC2_0, SRC1_0, DST0;					\
+	.set blocks_left, blocks_left - 4;				\
+	OPCODE	SRC2_1, SRC1_1, DST1;					\
+	.set blocks_left, blocks_left - 4;				\
+	OPCODE	SRC2_2, SRC1_2, DST2;					\
+	.set blocks_left, blocks_left - 4;				\
+	.if blocks_left == 1;						\
+		OPCODE	XWORD(SRC2_3), XWORD(SRC1_3), XWORD(DST3);	\
+	.elseif blocks_left == 2;					\
+		OPCODE	YWORD(SRC2_3), YWORD(SRC1_3), YWORD(DST3);	\
+	.elseif blocks_left == 3;					\
+		OPCODE	SRC2_3, SRC1_3, DST3;				\
+	.endif;								\
+.else;									\
+	OPCODE	SRC2_0, SRC1_0, DST0;					\
+	.set blocks_left, blocks_left - 4;				\
+	OPCODE	SRC2_1, SRC1_1, DST1;					\
+	.set blocks_left, blocks_left - 4;				\
+	OPCODE	SRC2_2, SRC1_2, DST2;					\
+	.set blocks_left, blocks_left - 4;				\
+	OPCODE	SRC2_3, SRC1_3, DST3;					\
+	.set blocks_left, blocks_left - 4;				\
+.endif;
+
+/*
+ * Handles AES encryption rounds. It handles special cases: the last and
+ * first rounds. Optionally, it performs XOR with data after the last AES
+ * round. Uses NROUNDS parameter to check what needs to be done for the
+ * current round.
+ */
+#define ZMM_AESENC_ROUND_BLOCKS_0_16(L0B0_3, L0B4_7, L0B8_11, L0B12_15, KEY, ROUND, D0_3, D4_7, D8_11, D12_15, NUMBL, NROUNDS) \
+.if ROUND < 1;				\
+	ZMM_OPCODE3_DSTR_SRC1R_SRC2R_BLOCKS_0_16(NUMBL, vpxorq, L0B0_3, L0B4_7, L0B8_11, L0B12_15, L0B0_3, L0B4_7, L0B8_11, L0B12_15, KEY, KEY, KEY, KEY)	\
+.endif;					\
+.if (ROUND >= 1) && (ROUND <= NROUNDS);	\
+	ZMM_OPCODE3_DSTR_SRC1R_SRC2R_BLOCKS_0_16(NUMBL, vaesenc, L0B0_3, L0B4_7, L0B8_11, L0B12_15, L0B0_3, L0B4_7, L0B8_11, L0B12_15, KEY, KEY, KEY, KEY)	\
+.endif;					\
+.if ROUND > NROUNDS;			\
+	ZMM_OPCODE3_DSTR_SRC1R_SRC2R_BLOCKS_0_16(NUMBL, vaesenclast, L0B0_3, L0B4_7, L0B8_11, L0B12_15, L0B0_3, L0B4_7, L0B8_11, L0B12_15, KEY, KEY, KEY, KEY)	\
+	.ifnc D0_3, no_data;		\
+	.ifnc D4_7, no_data;		\
+	.ifnc D8_11, no_data;		\
+	.ifnc D12_15, no_data;		\
+	ZMM_OPCODE3_DSTR_SRC1R_SRC2R_BLOCKS_0_16(NUMBL, vpxorq, L0B0_3, L0B4_7, L0B8_11, L0B12_15, L0B0_3, L0B4_7, L0B8_11, L0B12_15, D0_3, D4_7, D8_11, D12_15)	\
+	.endif;				\
+	.endif;				\
+	.endif;				\
+	.endif;				\
+.endif;
+
+/*
+ * Loads specified number of AES blocks into ZMM registers using mask register
+ * for the last loaded register (xmm, ymm or zmm). Loads take place at 1 byte
+ * granularity.
+ */
+#define ZMM_LOAD_MASKED_BLOCKS_0_16(NUM_BLOCKS, INP, DATA_OFFSET, DST0, DST1, DST2, DST3, MASK)	\
+.set src_offset,0;						\
+.set blocks_left, NUM_BLOCKS;					\
+.if NUM_BLOCKS <= 4;						\
+	.if blocks_left == 1;					\
+		vmovdqu8	src_offset(INP, DATA_OFFSET), XWORD(DST0){MASK}{z};	\
+	.elseif blocks_left == 2;				\
+		vmovdqu8	src_offset(INP, DATA_OFFSET), YWORD(DST0){MASK}{z};	\
+	.elseif (blocks_left == 3 || blocks_left == 4);		\
+		vmovdqu8	src_offset(INP, DATA_OFFSET), DST0{MASK}{z};		\
+	.endif;							\
+.elseif NUM_BLOCKS > 4 && NUM_BLOCKS <= 8;			\
+	vmovdqu8	src_offset(INP, DATA_OFFSET), DST0;	\
+	.set blocks_left, blocks_left - 4;			\
+	.set src_offset, src_offset + 64;			\
+	.if blocks_left == 1;					\
+		vmovdqu8	src_offset(INP, DATA_OFFSET), XWORD(DST1){MASK}{z};	\
+	.elseif blocks_left == 2;				\
+		vmovdqu8	src_offset(INP, DATA_OFFSET), YWORD(DST1){MASK}{z};	\
+	.elseif (blocks_left == 3 || blocks_left == 4);		\
+		vmovdqu8	src_offset(INP, DATA_OFFSET), DST1{MASK}{z};		\
+	.endif;							\
+.elseif NUM_BLOCKS > 8 && NUM_BLOCKS <= 12;			\
+	vmovdqu8	src_offset(INP, DATA_OFFSET), DST0;	\
+	.set blocks_left, blocks_left - 4;			\
+	.set src_offset, src_offset + 64;			\
+	vmovdqu8	src_offset(INP, DATA_OFFSET), DST1;	\
+	.set blocks_left, blocks_left - 4;			\
+	.set src_offset, src_offset + 64;			\
+	.if blocks_left == 1;					\
+		vmovdqu8	src_offset(INP, DATA_OFFSET), XWORD(DST2){MASK}{z};	\
+	.elseif blocks_left == 2;				\
+		vmovdqu8	src_offset(INP, DATA_OFFSET), YWORD(DST2){MASK}{z};	\
+	.elseif (blocks_left == 3 || blocks_left == 4);		\
+		vmovdqu8	src_offset(INP, DATA_OFFSET), DST2{MASK}{z};		\
+	.endif;							\
+.else;								\
+	vmovdqu8	src_offset(INP, DATA_OFFSET), DST0;	\
+	.set blocks_left, blocks_left - 4;			\
+	.set src_offset, src_offset + 64;			\
+	vmovdqu8	src_offset(INP, DATA_OFFSET), DST1;	\
+	.set blocks_left, blocks_left - 4;			\
+	.set src_offset, src_offset + 64;			\
+	vmovdqu8	src_offset(INP, DATA_OFFSET), DST2;	\
+	.set blocks_left, blocks_left - 4;			\
+	.set src_offset, src_offset + 64;			\
+	.if blocks_left == 1;					\
+		vmovdqu8	src_offset(INP, DATA_OFFSET), XWORD(DST3){MASK}{z};	\
+	.elseif blocks_left == 2;				\
+		vmovdqu8	src_offset(INP, DATA_OFFSET), YWORD(DST3){MASK}{z};	\
+	.elseif (blocks_left == 3 || blocks_left == 4);		\
+		vmovdqu8	src_offset(INP, DATA_OFFSET), DST3{MASK}{z};		\
+	.endif;							\
+.endif;
+
+/*
+ * Stores specified number of AES blocks from ZMM registers with mask register
+ * for the last loaded register (xmm, ymm or zmm). Stores take place at 1 byte
+ * granularity.
+ */
+#define ZMM_STORE_MASKED_BLOCKS_0_16(NUM_BLOCKS, OUTP, DATA_OFFSET, SRC0, SRC1, SRC2, SRC3, MASK) \
+.set blocks_left, NUM_BLOCKS;								\
+.set dst_offset, 0;									\
+.if NUM_BLOCKS <= 4;									\
+	.if blocks_left == 1;								\
+		vmovdqu8	XWORD(SRC0), dst_offset(OUTP, DATA_OFFSET){MASK};	\
+	.elseif blocks_left == 2;							\
+		vmovdqu8	YWORD(SRC0), dst_offset(OUTP, DATA_OFFSET){MASK};	\
+	.elseif (blocks_left == 3 || blocks_left == 4);					\
+		vmovdqu8	SRC0, dst_offset(OUTP, DATA_OFFSET){MASK};		\
+	.endif;										\
+.elseif NUM_BLOCKS > 4 && NUM_BLOCKS <=8;						\
+	vmovdqu8	SRC0, dst_offset(OUTP, DATA_OFFSET);				\
+	.set blocks_left, blocks_left - 4;						\
+	.set dst_offset, dst_offset + 64;						\
+	.if blocks_left == 1;								\
+		vmovdqu8	XWORD(SRC1), dst_offset(OUTP, DATA_OFFSET){MASK};	\
+	.elseif blocks_left == 2;							\
+		vmovdqu8	YWORD(SRC1), dst_offset(OUTP, DATA_OFFSET){MASK};	\
+	.elseif (blocks_left == 3 || blocks_left == 4);					\
+		vmovdqu8	SRC1, dst_offset(OUTP, DATA_OFFSET){MASK};		\
+	.endif;										\
+.elseif NUM_BLOCKS > 8 && NUM_BLOCKS <= 12;						\
+	vmovdqu8	SRC0, dst_offset(OUTP, DATA_OFFSET);				\
+	.set blocks_left, blocks_left - 4;						\
+	.set dst_offset, dst_offset + 64;						\
+	vmovdqu8	SRC1, dst_offset(OUTP, DATA_OFFSET);				\
+	.set blocks_left, blocks_left - 4;						\
+	.set dst_offset, dst_offset + 64;						\
+	.if blocks_left == 1;								\
+		vmovdqu8	XWORD(SRC2), dst_offset(OUTP, DATA_OFFSET){MASK};	\
+	.elseif blocks_left == 2;							\
+		vmovdqu8	YWORD(SRC2), dst_offset(OUTP, DATA_OFFSET){MASK};	\
+	.elseif (blocks_left == 3 || blocks_left == 4);					\
+		vmovdqu8	SRC2, dst_offset(OUTP, DATA_OFFSET){MASK};		\
+	.endif;										\
+.else;											\
+	vmovdqu8	SRC0, dst_offset(OUTP, DATA_OFFSET);				\
+	.set blocks_left, blocks_left - 4;						\
+	.set dst_offset, dst_offset + 64;						\
+	vmovdqu8	SRC1, dst_offset(OUTP, DATA_OFFSET);				\
+	.set blocks_left, blocks_left - 4;						\
+	.set dst_offset, dst_offset + 64;						\
+	vmovdqu8	SRC2, dst_offset(OUTP, DATA_OFFSET);				\
+	.set blocks_left, blocks_left - 4;						\
+	.set dst_offset, dst_offset + 64;						\
+	.if blocks_left == 1;								\
+		vmovdqu8	XWORD(SRC3), dst_offset(OUTP, DATA_OFFSET){MASK};	\
+	.elseif blocks_left == 2;							\
+		vmovdqu8	YWORD(SRC3), dst_offset(OUTP, DATA_OFFSET){MASK};	\
+	.elseif (blocks_left == 3 || blocks_left == 4);					\
+		vmovdqu8	SRC3, dst_offset(OUTP, DATA_OFFSET){MASK};		\
+	.endif;										\
+.endif;
+
+/* Loads specified number of AES blocks into ZMM registers */
+#define ZMM_LOAD_BLOCKS_0_16(NUM_BLOCKS, INP, DATA_OFFSET, DST0, DST1, DST2, DST3, FLAGS) \
+.set src_offset, 0;									\
+.set blocks_left, NUM_BLOCKS % 4;							\
+.if NUM_BLOCKS < 4;									\
+	.if blocks_left == 1;								\
+		vmovdqu8	src_offset(INP, DATA_OFFSET), XWORD(DST0);      	\
+	.elseif blocks_left == 2;							\
+		vmovdqu8	src_offset(INP, DATA_OFFSET), YWORD(DST0);      	\
+	.elseif blocks_left == 3;							\
+		.ifc FLAGS, load_4_instead_of_3;					\
+			vmovdqu8	src_offset(INP, DATA_OFFSET), DST0;     	\
+		.else;									\
+			vmovdqu8	src_offset(INP, DATA_OFFSET), YWORD(DST0);	\
+			vinserti64x2    $2, src_offset + 32(INP, DATA_OFFSET), DST0, DST0;	\
+		.endif;									\
+	.endif;										\
+.elseif NUM_BLOCKS >= 4 && NUM_BLOCKS < 8;						\
+	vmovdqu8	src_offset(INP, DATA_OFFSET), DST0;				\
+	.set src_offset, src_offset + 64;						\
+	.if blocks_left == 1;								\
+		vmovdqu8	src_offset(INP, DATA_OFFSET), XWORD(DST1);		\
+	.elseif blocks_left == 2;							\
+		vmovdqu8	src_offset(INP, DATA_OFFSET), YWORD(DST1);		\
+	.elseif blocks_left == 3;							\
+		.ifc FLAGS, load_4_instead_of_3;					\
+			vmovdqu8	src_offset(INP, DATA_OFFSET), DST1;		\
+		.else;									\
+			vmovdqu8	src_offset(INP, DATA_OFFSET), YWORD(DST1);	\
+			vinserti64x2	$2, src_offset + 32(INP, DATA_OFFSET), DST1, DST1;	\
+		.endif;									\
+	.endif;										\
+.elseif NUM_BLOCKS >= 8 && NUM_BLOCKS < 12;						\
+	vmovdqu8	src_offset(INP, DATA_OFFSET), DST0;				\
+	.set src_offset, src_offset + 64;						\
+	vmovdqu8	src_offset(INP, DATA_OFFSET), DST1;				\
+	.set src_offset, src_offset + 64;						\
+	.if blocks_left == 1;								\
+		vmovdqu8	src_offset(INP, DATA_OFFSET), XWORD(DST2);		\
+	.elseif blocks_left == 2;							\
+		vmovdqu8	src_offset(INP, DATA_OFFSET), YWORD(DST2);		\
+	.elseif blocks_left == 3;							\
+		.ifc FLAGS, load_4_instead_of_3;					\
+		vmovdqu8	src_offset(INP, DATA_OFFSET), DST2;			\
+		.else;									\
+		vmovdqu8	src_offset(INP, DATA_OFFSET), YWORD(DST2);		\
+		vinserti64x2	$2, src_offset + 32(INP, DATA_OFFSET), DST2, DST2;	\
+		.endif;									\
+       .endif;										\
+.else;											\
+	vmovdqu8	src_offset(INP, DATA_OFFSET), DST0;				\
+	.set src_offset, src_offset + 64;			      			\
+	vmovdqu8	src_offset(INP, DATA_OFFSET), DST1;				\
+	.set src_offset, src_offset + 64;						\
+	vmovdqu8	src_offset(INP, DATA_OFFSET), DST2;				\
+	.set src_offset, src_offset + 64;						\
+	.if blocks_left == 1;								\
+		vmovdqu8	src_offset(INP, DATA_OFFSET), XWORD(DST3);		\
+	.elseif blocks_left == 2;							\
+		vmovdqu8	src_offset(INP, DATA_OFFSET), YWORD(DST3);		\
+	.elseif blocks_left == 3;							\
+		.ifc FLAGS, load_4_instead_of_3;					\
+		vmovdqu8	src_offset(INP, DATA_OFFSET), DST3;			\
+		.else;									\
+		vmovdqu8	src_offset(INP, DATA_OFFSET), YWORD(DST3);		\
+		vinserti64x2    $2, src_offset + 32(INP, DATA_OFFSET), DST3, DST3;	\
+		.endif;									\
+	.endif;										\
+.endif;
+
+/* Stores specified number of AES blocks from ZMM registers */
+#define ZMM_STORE_BLOCKS_0_16(NUM_BLOCKS, OUTP, DATA_OFFSET, SRC0, SRC1, SRC2, SRC3)	\
+.set dst_offset, 0;								\
+.set blocks_left, NUM_BLOCKS % 4;						\
+.if NUM_BLOCKS < 4;								\
+	.if blocks_left == 1;							\
+		vmovdqu8	XWORD(SRC0), dst_offset(OUTP, DATA_OFFSET);	\
+	.elseif blocks_left == 2;						\
+		vmovdqu8	YWORD(SRC0), dst_offset(OUTP, DATA_OFFSET);	\
+	.elseif blocks_left == 3;						\
+		vmovdqu8	YWORD(SRC0), dst_offset(OUTP, DATA_OFFSET);	\
+		vextracti32x4	$2, SRC0, dst_offset + 32(OUTP, DATA_OFFSET);	\
+	.endif;									\
+.elseif NUM_BLOCKS >= 4 && NUM_BLOCKS < 8;					\
+	vmovdqu8	SRC0, dst_offset(OUTP, DATA_OFFSET);			\
+	.set dst_offset, dst_offset + 64;					\
+	.if blocks_left == 1;							\
+		vmovdqu8	XWORD(SRC1), dst_offset(OUTP, DATA_OFFSET);	\
+	.elseif blocks_left == 2;						\
+		vmovdqu8	YWORD(SRC1), dst_offset(OUTP, DATA_OFFSET);	\
+	.elseif blocks_left == 3;						\
+		vmovdqu8	YWORD(SRC1), dst_offset(OUTP, DATA_OFFSET);	\
+		vextracti32x4	$2, SRC1, dst_offset + 32(OUTP, DATA_OFFSET);	\
+	.endif;									\
+.elseif NUM_BLOCKS >= 8 && NUM_BLOCKS < 12;					\
+	vmovdqu8	SRC0, dst_offset(OUTP, DATA_OFFSET);			\
+	.set dst_offset, dst_offset + 64;					\
+	vmovdqu8	SRC1, dst_offset(OUTP, DATA_OFFSET);			\
+	.set dst_offset, dst_offset + 64;					\
+	.if blocks_left == 1;							\
+		vmovdqu8	XWORD(SRC2), dst_offset(OUTP, DATA_OFFSET);     \
+	.elseif blocks_left == 2;						\
+		vmovdqu8	YWORD(SRC2), dst_offset(OUTP, DATA_OFFSET);	\
+	.elseif blocks_left == 3;						\
+		vmovdqu8	YWORD(SRC2), dst_offset(OUTP, DATA_OFFSET);	\
+		vextracti32x4   $2, SRC2, dst_offset + 32(OUTP, DATA_OFFSET);	\
+	.endif;									\
+.else;										\
+	vmovdqu8	SRC0, dst_offset(OUTP, DATA_OFFSET);			\
+	.set dst_offset, dst_offset + 64;					\
+	vmovdqu8	SRC1, dst_offset(OUTP, DATA_OFFSET);			\
+	.set dst_offset, dst_offset + 64;					\
+	vmovdqu8	SRC2, dst_offset(OUTP, DATA_OFFSET);			\
+	.set dst_offset, dst_offset + 64;					\
+	.if blocks_left == 1;							\
+		vmovdqu8	XWORD(SRC3), dst_offset(OUTP, DATA_OFFSET);	\
+	.elseif blocks_left == 2;						\
+		vmovdqu8	YWORD(SRC3), dst_offset(OUTP, DATA_OFFSET);	\
+	.elseif blocks_left == 3;						\
+		vmovdqu8	YWORD(SRC3), dst_offset(OUTP, DATA_OFFSET);	\
+		vextracti32x4	$2, SRC3, dst_offset + 32(OUTP, DATA_OFFSET);	\
+	.endif;									\
+.endif;
diff --git a/arch/x86/crypto/aes_ctrby16_avx512-x86_64.S b/arch/x86/crypto/aes_ctrby16_avx512-x86_64.S
new file mode 100644
index 0000000..787ea47
--- /dev/null
+++ b/arch/x86/crypto/aes_ctrby16_avx512-x86_64.S
@@ -0,0 +1,955 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright © 2021 Intel Corporation.
+ *
+ * Implement AES CTR mode by16 optimization with VAES instructions. (x86_64)
+ *
+ * This is AES128/192/256 CTR mode optimization implementation. It requires
+ * the support of Intel(R) AVX512VL and VAES instructions.
+ */
+
+#include "aes_avx512_common.S"
+
+#define ZKEY0	%zmm17
+#define ZKEY1	%zmm18
+#define ZKEY2	%zmm19
+#define ZKEY3	%zmm20
+#define ZKEY4	%zmm21
+#define ZKEY5	%zmm22
+#define ZKEY6	%zmm23
+#define ZKEY7	%zmm24
+#define ZKEY8	%zmm25
+#define ZKEY9	%zmm26
+#define ZKEY10	%zmm27
+#define ZKEY11	%zmm28
+#define ZKEY12	%zmm29
+#define ZKEY13	%zmm30
+#define ZKEY14	%zmm31
+
+#define TMP0		%r10
+#define TMP1		%r11
+#define TMP2		%r12
+#define	TMP3		%rax
+#define DATA_OFFSET	%r13
+#define RBITS		%r14
+#define MASKREG		%k1
+#define SHUFREG		%zmm13
+#define ADD8REG		%zmm14
+
+#define CTR_BLOCKx	%xmm0
+#define CTR_BLOCK_1_4	%zmm1
+#define CTR_BLOCK_5_8	%zmm2
+#define CTR_BLOCK_9_12	%zmm3
+#define CTR_BLOCK_13_16	%zmm4
+
+#define ZTMP0		%zmm5
+#define ZTMP1		%zmm6
+#define ZTMP2		%zmm7
+#define ZTMP3		%zmm8
+#define ZTMP4		%zmm9
+#define ZTMP5		%zmm10
+#define ZTMP6		%zmm11
+#define ZTMP7		%zmm12
+
+#define	XTMP		%xmm15
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
+#define zmm13y ymm13
+#define zmm12y ymm12
+#define zmm11y ymm11
+#define zmm10y ymm10
+#define zmm9y  ymm9
+#define zmm8y  ymm8
+#define zmm7y  ymm7
+#define zmm6y  ymm6
+#define zmm5y  ymm5
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
+#define xmm0y ymm0
+#define xmm0z zmm0
+#define xmm15x xmm15
+#define xmm0x  xmm0
+
+#define stringify(reg,y)       reg##y
+#define str(reg,y)	       stringify(reg,y)
+#define concat(reg,y)	       str(reg,y)
+
+#define YWORD(reg)     concat(reg, y)
+#define XWORD(reg)     concat(reg, x)
+#define ZWORD(reg)     concat(reg, z)
+
+#define arg1	%rdi
+#define arg2	%rsi
+#define arg3	%rdx
+#define arg4	%rcx
+#define arg5	%r8
+#define arg6	%r9
+
+#define STACK_FRAME_SIZE_CTR	(5*8)	/* space for 5 GP registers */
+
+.data
+.align 16
+ONE:
+.octa	0x00000000000000000000000000000001
+
+.align 16
+ddq_low_msk:
+.octa	0x0000000000000000FFFFFFFFFFFFFFFF
+
+.align 16
+ddq_high_add_1:
+.octa	0x00000000000000010000000000000000
+
+.align 16
+ddq_add_1:
+.octa	0x00000000000000000000000000000001
+
+.align 64
+SHUF_MASK:
+.octa	0x000102030405060708090A0B0C0D0E0F
+.octa	0x000102030405060708090A0B0C0D0E0F
+.octa	0x000102030405060708090A0B0C0D0E0F
+.octa	0x000102030405060708090A0B0C0D0E0F
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
+ddq_add_12_15:
+.octa	0x0000000000000000000000000000000c
+.octa	0x0000000000000000000000000000000d
+.octa	0x0000000000000000000000000000000e
+.octa	0x0000000000000000000000000000000f
+
+.align 64
+ddq_add_8_11:
+.octa	0x00000000000000000000000000000008
+.octa	0x00000000000000000000000000000009
+.octa	0x0000000000000000000000000000000a
+.octa	0x0000000000000000000000000000000b
+
+.align 64
+ddq_add_4_7:
+.octa	0x00000000000000000000000000000004
+.octa	0x00000000000000000000000000000005
+.octa	0x00000000000000000000000000000006
+.octa	0x00000000000000000000000000000007
+
+.align 64
+ddq_add_0_3:
+.octa	0x00000000000000000000000000000000
+.octa	0x00000000000000000000000000000001
+.octa	0x00000000000000000000000000000002
+.octa	0x00000000000000000000000000000003
+
+.align 64
+ddq_add_13_16:
+.octa	0x0000000000000000000000000000000d
+.octa	0x0000000000000000000000000000000e
+.octa	0x0000000000000000000000000000000f
+.octa	0x00000000000000000000000000000010
+
+.align 64
+ddq_add_9_12:
+.octa	0x00000000000000000000000000000009
+.octa	0x0000000000000000000000000000000a
+.octa	0x0000000000000000000000000000000b
+.octa	0x0000000000000000000000000000000c
+
+.align 64
+ddq_add_5_8:
+.octa	0x00000000000000000000000000000005
+.octa	0x00000000000000000000000000000006
+.octa	0x00000000000000000000000000000007
+.octa	0x00000000000000000000000000000008
+
+.align 64
+ddq_add_1_4:
+.octa	0x00000000000000000000000000000001
+.octa	0x00000000000000000000000000000002
+.octa	0x00000000000000000000000000000003
+.octa	0x00000000000000000000000000000004
+
+.align 64
+ddq_add_16:
+.octa	0x00000000000000000000000000000010
+.octa	0x00000000000000000000000000000010
+.octa	0x00000000000000000000000000000010
+.octa	0x00000000000000000000000000000010
+
+.text
+/* Save register content for the caller */
+#define FUNC_SAVE_CTR()				\
+	mov	%rsp, %rax;			\
+	sub	$STACK_FRAME_SIZE_CTR, %rsp;	\
+	and	$~63, %rsp;			\
+	mov	%r12, (%rsp);			\
+	mov	%r13, 0x8(%rsp);		\
+	mov	%rax, 0x18(%rsp);
+
+/* Restore register content for the caller */
+#define FUNC_RESTORE_CTR()			\
+	vzeroupper;				\
+	mov	(%rsp), %r12;			\
+	mov	0x8(%rsp), %r13;		\
+	mov	0x18(%rsp), %rsp;
+
+/* Update next counter value. */
+#define GET_NEXT_COUNTER(CTR, XTMP)				\
+	vpaddq	ddq_add_1(%rip), XWORD(CTR), XWORD(XTMP);	\
+	vptest	ddq_low_msk(%rip), XWORD(XTMP);			\
+	/* If next counter overflows, add 1 to upper 64 bits	\
+	 * ensure 128 bit addition				\
+	 */							\
+	jnz	80f;						\
+	vpaddq	ddq_high_add_1(%rip), XWORD(XTMP), XWORD(XTMP);	\
+80:
+
+/*
+ * CTR(128 bits) needs to be incremented. Since there is no 128-bit add
+ * instruction, we need to increment 64-bit (least significant) and if an
+ * overflow is detected, increment the most significant 64-bits.
+ */
+#define INCR_CNTR_128(CTR, ZT, XTMP, num)		\
+	GET_NEXT_COUNTER(CTR, XTMP)			\
+	vinserti64x2	$num, XTMP, ZT, ZT;		\
+	vmovdqa64	XTMP, XWORD(CTR);
+
+/* Increment 4, 128 bit counters stored in a ZMM register */
+#define INCR_4_CNTRS(CTR, ZT)			\
+	vmovdqa64	XWORD(CTR), XWORD(ZT);	\
+	INCR_CNTR_128(CTR, ZT, XTMP, 1)		\
+	INCR_CNTR_128(CTR, ZT, XTMP, 2)		\
+	INCR_CNTR_128(CTR, ZT, XTMP, 3)		\
+	vextracti32x4	$3, ZT, XWORD(CTR);
+
+/* Increment 1 to 16 counters (1 to 4 ZMM registers) based on number of blocks */
+#define INCR_CNTR_NUM_BLOCKS(CNTR, ZTMP0, ZTMP1, ZTMP2, ZTMP3, NUM)	\
+.if NUM > 0;				\
+	INCR_4_CNTRS(CNTR, ZTMP0)	\
+.endif;					\
+.if NUM > 1;				\
+	GET_NEXT_COUNTER(CNTR, CNTR)	\
+	INCR_4_CNTRS(CNTR, ZTMP1)	\
+.endif;					\
+.if NUM > 2;				\
+	GET_NEXT_COUNTER(CNTR, CNTR)	\
+	INCR_4_CNTRS(CNTR, ZTMP2)	\
+.endif;					\
+.if NUM > 3;				\
+	GET_NEXT_COUNTER(CNTR, CNTR)	\
+	INCR_4_CNTRS(CNTR, ZTMP3)	\
+.endif;
+
+/* Update counters based on number of blocks */
+#define UPDATE_COUNTERS(CTR, ZT1, ZT2, ZT3, ZT4, num_initial_blocks)	\
+	vshufi64x2	$0, ZWORD(CTR), ZWORD(CTR), ZWORD(CTR);	\
+	vmovq		XWORD(CTR), TMP3;			\
+.if num_initial_blocks <=4;					\
+	cmp	$3, TMP3;					\
+	jb	77f;						\
+	INCR_CNTR_NUM_BLOCKS(CTR, ZT1, ZT2, ZT3, ZT4, 1)	\
+	jmp	78f;						\
+.elseif num_initial_blocks <=8;					\
+	cmp	$7, TMP3;					\
+	jb	77f;						\
+	INCR_CNTR_NUM_BLOCKS(CTR, ZT1, ZT2, ZT3, ZT4, 2)	\
+	jmp	78f;						\
+.elseif num_initial_blocks <=12;				\
+	cmp	$11, TMP3;					\
+	jb	77f;						\
+	INCR_CNTR_NUM_BLOCKS(CTR, ZT1, ZT2, ZT3, ZT4, 3)	\
+	jmp	78f;						\
+.else;								\
+	cmp	$15, TMP3;					\
+	jb	77f;						\
+	INCR_CNTR_NUM_BLOCKS(CTR, ZT1, ZT2, ZT3, ZT4, 4)	\
+	jmp	78f;						\
+.endif;								\
+77:;								\
+.if num_initial_blocks >= 1;					\
+	vpaddq	ddq_add_0_3(%rip), ZWORD(CTR), ZT1;		\
+.endif;								\
+.if num_initial_blocks > 4;					\
+	vpaddq	ddq_add_4_7(%rip), ZWORD(CTR), ZT2;		\
+.endif;								\
+.if num_initial_blocks > 8;					\
+	vpaddq	ddq_add_8_11(%rip), ZWORD(CTR), ZT3;		\
+.endif;								\
+.if num_initial_blocks > 12;					\
+	vpaddq	ddq_add_12_15(%rip), ZWORD(CTR), ZT4;		\
+.endif;								\
+78:;
+
+/* Prepares the AES counter blocks */
+#define PREPARE_COUNTER_BLOCKS(CTR, ZT1, ZT2, ZT3, ZT4, num_blocks)	\
+.if num_blocks == 1;						\
+	vmovdqa64	XWORD(CTR), XWORD(ZT1);			\
+.elseif num_blocks == 2;					\
+	vshufi64x2	$0, YWORD(CTR), YWORD(CTR), YWORD(ZT1); \
+	vmovq		XWORD(CTR), TMP3;			\
+	cmp		$~1, TMP3;				\
+	jb		50f;					\
+	vpaddq		ddq_add_1(%rip), XWORD(CTR), XTMP;	\
+	vptest		ddq_low_msk(%rip), XTMP;		\
+	jnz		64f;					\
+	vpaddq		ddq_high_add_1(%rip), XTMP, XTMP;	\
+64:;								\
+	vinserti64x2	$1, XTMP, YWORD(ZT1) , YWORD(ZT1);	\
+	jmp		55f;					\
+50:;								\
+	vpaddq	ddq_add_0_3(%rip), YWORD(ZT1), YWORD(ZT1);	\
+.else;								\
+	UPDATE_COUNTERS(CTR, ZT1, ZT2, ZT3, ZT4, num_blocks)	\
+.endif;								\
+55:;
+
+/* Extract and Shuffle the updated counters for AES rounds */
+#define	EXTRACT_CNTR_VAL(ZT1, ZT2, ZT3, ZT4, SHUFREG, CTR, num_initial_blocks)	\
+.if num_initial_blocks == 1;					\
+	vpshufb		XWORD(SHUFREG), CTR, XWORD(ZT1);	\
+.elseif num_initial_blocks == 2;				\
+	vextracti32x4	$1, YWORD(ZT1), CTR;			\
+	vpshufb		YWORD(SHUFREG), YWORD(ZT1), YWORD(ZT1); \
+.elseif num_initial_blocks <= 4;				\
+	vextracti32x4	$(num_initial_blocks - 1), ZT1, CTR;	\
+	vpshufb		SHUFREG, ZT1, ZT1;			\
+.elseif num_initial_blocks == 5;				\
+	vmovdqa64	XWORD(ZT2), CTR;			\
+	vpshufb		SHUFREG, ZT1, ZT1;			\
+	vpshufb		XWORD(SHUFREG), XWORD(ZT2), XWORD(ZT2); \
+.elseif num_initial_blocks == 6;				\
+	vextracti32x4	$1, YWORD(ZT2), CTR;			\
+	vpshufb		SHUFREG, ZT1, ZT1;			\
+	vpshufb		YWORD(SHUFREG), YWORD(ZT2), YWORD(ZT2); \
+.elseif num_initial_blocks == 7;				\
+	vextracti32x4	$2, ZT2, CTR;				\
+	vpshufb		SHUFREG, ZT1, ZT1;			\
+	vpshufb		SHUFREG, ZT2, ZT2;			\
+.elseif num_initial_blocks == 8;				\
+	vextracti32x4	$3, ZT2, CTR;				\
+	vpshufb		SHUFREG, ZT1, ZT1;			\
+	vpshufb		SHUFREG, ZT2, ZT2;			\
+.elseif num_initial_blocks == 9;				\
+	vmovdqa64	XWORD(ZT3), CTR;			\
+	vpshufb		SHUFREG, ZT1, ZT1;			\
+	vpshufb		SHUFREG, ZT2, ZT2;			\
+	vpshufb		XWORD(SHUFREG), XWORD(ZT3), XWORD(ZT3); \
+.elseif num_initial_blocks == 10;				\
+	vextracti32x4	$1, YWORD(ZT3), CTR;			\
+	vpshufb		SHUFREG, ZT1, ZT1;			\
+	vpshufb		SHUFREG, ZT2, ZT2;			\
+	vpshufb		YWORD(SHUFREG), YWORD(ZT3), YWORD(ZT3); \
+.elseif num_initial_blocks == 11;				\
+	vextracti32x4	$2, ZT3, CTR;				\
+	vpshufb		SHUFREG, ZT1, ZT1;			\
+	vpshufb		SHUFREG, ZT2, ZT2;			\
+	vpshufb		SHUFREG, ZT3, ZT3;			\
+.elseif num_initial_blocks == 12;				\
+	vextracti32x4	$3, ZT3, CTR;				\
+	vpshufb		SHUFREG, ZT1, ZT1;			\
+	vpshufb		SHUFREG, ZT2, ZT2;			\
+	vpshufb		SHUFREG, ZT3, ZT3;			\
+.elseif num_initial_blocks == 13;				\
+	vmovdqa64	XWORD(ZT4), CTR;			\
+	vpshufb		SHUFREG, ZT1, ZT1;			\
+	vpshufb		SHUFREG, ZT2, ZT2;			\
+	vpshufb		SHUFREG, ZT3, ZT3;			\
+	vpshufb		XWORD(SHUFREG), XWORD(ZT4), XWORD(ZT4);	\
+.elseif num_initial_blocks == 14;				\
+	vextracti32x4	$1, YWORD(ZT4), CTR;			\
+	vpshufb		SHUFREG, ZT1, ZT1;			\
+	vpshufb		SHUFREG, ZT2, ZT2;			\
+	vpshufb		SHUFREG, ZT3, ZT3;			\
+	vpshufb		YWORD(SHUFREG), YWORD(ZT4), YWORD(ZT4);	\
+.elseif num_initial_blocks == 15;				\
+	vextracti32x4	$2, ZT4, CTR;				\
+	vpshufb		SHUFREG, ZT1, ZT1;			\
+	vpshufb		SHUFREG, ZT2, ZT2;			\
+	vpshufb		SHUFREG, ZT3, ZT3;			\
+	vpshufb		SHUFREG, ZT4, ZT4;			\
+.endif;
+
+/* AES rounds and XOR with plain/cipher text */
+#define AES_XOR_ROUNDS(ZT1, ZT2, ZT3, ZT4, ZKEY_0, ZKEY_1, ZKEY_2, ZKEY_3, ZKEY_4, ZKEY_5, ZKEY_6, ZKEY_7, ZKEY_8, ZKEY_9, ZKEY_10, ZKEY_11, ZKEY_12, ZKEY_13, ZKEY_14, ZT5, ZT6, ZT7, ZT8, num_initial_blocks, NROUNDS)	\
+	ZMM_AESENC_ROUND_BLOCKS_0_16(ZT1, ZT2, ZT3, ZT4, ZKEY0, 0, ZT5, ZT6, ZT7, ZT8, num_initial_blocks, NROUNDS)	\
+	ZMM_AESENC_ROUND_BLOCKS_0_16(ZT1, ZT2, ZT3, ZT4, ZKEY1, 1, ZT5, ZT6, ZT7, ZT8, num_initial_blocks, NROUNDS)	\
+	ZMM_AESENC_ROUND_BLOCKS_0_16(ZT1, ZT2, ZT3, ZT4, ZKEY2, 2, ZT5, ZT6, ZT7, ZT8, num_initial_blocks, NROUNDS)	\
+	ZMM_AESENC_ROUND_BLOCKS_0_16(ZT1, ZT2, ZT3, ZT4, ZKEY3, 3, ZT5, ZT6, ZT7, ZT8, num_initial_blocks, NROUNDS)	\
+	ZMM_AESENC_ROUND_BLOCKS_0_16(ZT1, ZT2, ZT3, ZT4, ZKEY4, 4, ZT5, ZT6, ZT7, ZT8, num_initial_blocks, NROUNDS)	\
+	ZMM_AESENC_ROUND_BLOCKS_0_16(ZT1, ZT2, ZT3, ZT4, ZKEY5, 5, ZT5, ZT6, ZT7, ZT8, num_initial_blocks, NROUNDS)	\
+	ZMM_AESENC_ROUND_BLOCKS_0_16(ZT1, ZT2, ZT3, ZT4, ZKEY6, 6, ZT5, ZT6, ZT7, ZT8, num_initial_blocks, NROUNDS)	\
+	ZMM_AESENC_ROUND_BLOCKS_0_16(ZT1, ZT2, ZT3, ZT4, ZKEY7, 7, ZT5, ZT6, ZT7, ZT8, num_initial_blocks, NROUNDS)	\
+	ZMM_AESENC_ROUND_BLOCKS_0_16(ZT1, ZT2, ZT3, ZT4, ZKEY8, 8, ZT5, ZT6, ZT7, ZT8, num_initial_blocks, NROUNDS)	\
+	ZMM_AESENC_ROUND_BLOCKS_0_16(ZT1, ZT2, ZT3, ZT4, ZKEY9, 9, ZT5, ZT6, ZT7, ZT8, num_initial_blocks, NROUNDS)	\
+	ZMM_AESENC_ROUND_BLOCKS_0_16(ZT1, ZT2, ZT3, ZT4, ZKEY10, 10, ZT5, ZT6, ZT7, ZT8, num_initial_blocks, NROUNDS)	\
+.if NROUNDS == 9;													\
+	jmp 29f;													\
+.else;															\
+	ZMM_AESENC_ROUND_BLOCKS_0_16(ZT1, ZT2, ZT3, ZT4, ZKEY11, 11, ZT5, ZT6, ZT7, ZT8, num_initial_blocks, NROUNDS)	\
+	ZMM_AESENC_ROUND_BLOCKS_0_16(ZT1, ZT2, ZT3, ZT4, ZKEY12, 12, ZT5, ZT6, ZT7, ZT8, num_initial_blocks, NROUNDS)	\
+.if NROUNDS == 11;													\
+	jmp 29f;													\
+.else;															\
+	ZMM_AESENC_ROUND_BLOCKS_0_16(ZT1, ZT2, ZT3, ZT4, ZKEY13, 13, ZT5, ZT6, ZT7, ZT8, num_initial_blocks, NROUNDS)	\
+	ZMM_AESENC_ROUND_BLOCKS_0_16(ZT1, ZT2, ZT3, ZT4, ZKEY14, 14, ZT5, ZT6, ZT7, ZT8, num_initial_blocks, NROUNDS)	\
+.endif;															\
+.endif;															\
+29:;
+
+/*
+ * This macro may look similar to INITIAL_BLOCKS but its usage is
+ * different. It is not meant to cipher counter blocks for the main
+ * by16 loop. Just ciphers amount of blocks. Used for small packets
+ * (<256 bytes).
+ */
+#define INITIAL_BLOCKS_SMALL(CYPH_PLAIN_OUT, PLAIN_CYPH_IN, LEN, num_blks, CTR, ZT1, ZT2, ZT3, ZT4, ZT5, ZT6, ZT7, ZT8, IA0, IA1, MASKREG, SHUFREG, NROUNDS)	\
+	/* get load/store mask */				\
+	lea	byte64_len_to_mask_table(%rip), IA0;		\
+	mov	LEN, IA1;					\
+.if num_blks > 12;						\
+	sub	 $192, IA1;					\
+.elseif num_blks > 8;						\
+	sub	$128, IA1;					\
+.elseif num_blks > 4;						\
+	sub	$64, IA1;					\
+.endif;								\
+	kmovq	(IA0, IA1, 8), MASKREG;				\
+	ZMM_LOAD_MASKED_BLOCKS_0_16(num_blks, PLAIN_CYPH_IN, 1, ZT5, ZT6, ZT7, ZT8, MASKREG)	\
+	PREPARE_COUNTER_BLOCKS(CTR, ZT1, ZT2, ZT3, ZT4, num_blks)	\
+	EXTRACT_CNTR_VAL(ZT1, ZT2, ZT3, ZT4, SHUFREG, CTR, num_blks)	\
+	AES_XOR_ROUNDS(ZT1, ZT2, ZT3, ZT4, ZKEY0, ZKEY1, ZKEY2, ZKEY3, ZKEY4, ZKEY5, ZKEY6, ZKEY7, ZKEY8, ZKEY9, ZKEY10, ZKEY11, ZKEY12, ZKEY13, ZKEY14, ZT5, ZT6, ZT7, ZT8, num_blks, NROUNDS)					\
+	/* write cipher/plain text back to output */		\
+	ZMM_STORE_MASKED_BLOCKS_0_16(num_blks, CYPH_PLAIN_OUT, 1, ZT1, ZT2, ZT3, ZT4, MASKREG)
+
+/* This macro is used to "warm-up" pipeline for ENCRYPT_16_PARALLEL macro
+ * code. It is called only for data lengths 256 and above. The flow is as
+ * follows:
+ * - encrypt the initial num_initial_blocks blocks (can be 0)
+ * - encrypt the next 16 blocks
+ */
+#define INITIAL_BLOCKS(CYPH_PLAIN_OUT, PLAIN_CYPH_IN, LENGTH, DATA_OFFSET, num_initial_blocks, CTR, CTR_1_4, CTR_5_8, CTR_9_12, CTR_13_16, ZT1, ZT2, ZT3, ZT4, ZT5, ZT6, ZT7, ZT8, IA0, IA1, MASKREG, SHUFREG, NROUNDS)	\
+.if num_initial_blocks > 0;						\
+	/* load plain/cipher text */					\
+	ZMM_LOAD_BLOCKS_0_16(num_initial_blocks, PLAIN_CYPH_IN, 1, ZT5, ZT6, ZT7, ZT8, load_4_instead_of_3)	\
+	PREPARE_COUNTER_BLOCKS(CTR, ZT1, ZT2, ZT3, ZT4, num_initial_blocks)	\
+	EXTRACT_CNTR_VAL(ZT1, ZT2, ZT3, ZT4, SHUFREG, CTR, num_initial_blocks)	\
+	AES_XOR_ROUNDS(ZT1, ZT2, ZT3, ZT4, ZKEY0, ZKEY1, ZKEY2, ZKEY3, ZKEY4, ZKEY5, ZKEY6, ZKEY7, ZKEY8, ZKEY9, ZKEY10, ZKEY11, ZKEY12, ZKEY13, ZKEY14, ZT5, ZT6, ZT7, ZT8, num_initial_blocks, NROUNDS)	\
+	/* write cipher/plain text back to output */			\
+	ZMM_STORE_BLOCKS_0_16(num_initial_blocks, CYPH_PLAIN_OUT, 1, ZT1, ZT2, ZT3, ZT4)	\
+	/* adjust data offset and length */				\
+	sub	$(num_initial_blocks * 16), LENGTH;			\
+	add	$(num_initial_blocks * 16), DATA_OFFSET;		\
+.endif;									\
+\
+	/* - cipher of num_initial_blocks is done			\
+	 * - prepare counter blocks for the next 16 blocks (ZT5-ZT8)	\
+	 * - shuffle the blocks for AES					\
+	 * - encrypt the next 16 blocks					\
+	 */								\
+\
+	 /* get text load/store mask (assume full mask by default) */	\
+	 mov	 $~0, IA0;						\
+.if num_initial_blocks > 0;						\
+	/* This macro is executed for length 256 and up, zero length	\
+	 * is checked in CNTR_ENC_DEC. We know there is a partial block	\
+	 * if: LENGTH - 16*num_initial_blocks < 256			\
+	 */								\
+	cmp	$256, LENGTH;						\
+	jge	56f;							\
+	mov	%rcx, IA1;						\
+	mov	$256, %ecx;						\
+	sub	LENGTH, %rcx;						\
+	shr	%cl, IA0;						\
+	mov	IA1, %rcx;						\
+56:;									\
+.endif;									\
+	kmovq	IA0, MASKREG;						\
+	/* load plain or cipher text */					\
+	vmovdqu8	(PLAIN_CYPH_IN, DATA_OFFSET, 1), ZT5;		\
+	vmovdqu8	64(PLAIN_CYPH_IN, DATA_OFFSET), ZT6;		\
+	vmovdqu8	128(PLAIN_CYPH_IN, DATA_OFFSET), ZT7;		\
+	vmovdqu8	192(PLAIN_CYPH_IN, DATA_OFFSET), ZT8{MASKREG}{z};	\
+\
+	/* prepare next counter blocks */				\
+	vshufi64x2	$0, ZWORD(CTR), ZWORD(CTR), ZWORD(CTR);		\
+.if num_initial_blocks > 0;						\
+	vmovq	XWORD(CTR), TMP3;					\
+	cmp	$~16, TMP3;						\
+	jb	58f;							\
+	vpaddq	ddq_add_1(%rip), XWORD(CTR), XWORD(CTR);		\
+	vptest	ddq_low_msk(%rip), XWORD(CTR);				\
+	jnz 57f;							\
+	vpaddq	ddq_high_add_1(%rip), XWORD(CTR), XWORD(CTR);		\
+57:;	\
+	INCR_CNTR_NUM_BLOCKS(CTR, CTR_1_4, CTR_5_8, CTR_9_12, CTR_13_16, 4)	\
+	jmp 60f;							\
+58:;									\
+	vpaddq	      ddq_add_1_4(%rip), ZWORD(CTR), CTR_1_4;		\
+	vpaddq	      ddq_add_5_8(%rip), ZWORD(CTR), CTR_5_8;		\
+	vpaddq	      ddq_add_9_12(%rip), ZWORD(CTR), CTR_9_12;		\
+	vpaddq	      ddq_add_13_16(%rip), ZWORD(CTR), CTR_13_16;	\
+.else;									\
+	vmovq	XWORD(CTR), TMP3;					\
+	cmp    $~15, TMP3;						\
+	jb	59f;							\
+	INCR_CNTR_NUM_BLOCKS(CTR, CTR_1_4, CTR_5_8, CTR_9_12, CTR_13_16, 4)	\
+	jmp 60f;							\
+59:;									\
+	vpaddq	      ddq_add_0_3(%rip), ZWORD(CTR), CTR_1_4;		\
+	vpaddq	      ddq_add_4_7(%rip), ZWORD(CTR), CTR_5_8;		\
+	vpaddq	      ddq_add_8_11(%rip), ZWORD(CTR), CTR_9_12;		\
+	vpaddq	      ddq_add_12_15(%rip), ZWORD(CTR), CTR_13_16;	\
+.endif;	\
+60:;									\
+	vextracti32x4 $3, CTR_13_16, XWORD(CTR);			\
+	vpshufb		SHUFREG, CTR_1_4, ZT1;				\
+	vpshufb		SHUFREG, CTR_5_8, ZT2;				\
+	vpshufb		SHUFREG, CTR_9_12, ZT3;				\
+	vpshufb		SHUFREG, CTR_13_16, ZT4;			\
+\
+	AES_XOR_ROUNDS(ZT1, ZT2, ZT3, ZT4, ZKEY0, ZKEY1, ZKEY2, ZKEY3, ZKEY4, ZKEY5, ZKEY6, ZKEY7, ZKEY8, ZKEY9, ZKEY10, ZKEY11, ZKEY12, ZKEY13, ZKEY14, ZT5, ZT6, ZT7, ZT8, 16, NROUNDS)	\
+\
+	/* write cipher/plain text back to output */			\
+	vmovdqu8	ZT1, (CYPH_PLAIN_OUT, DATA_OFFSET);		\
+	vmovdqu8	ZT2, 64(CYPH_PLAIN_OUT, DATA_OFFSET, 1);	\
+	vmovdqu8	ZT3, 128(CYPH_PLAIN_OUT, DATA_OFFSET, 1);	\
+	vmovdqu8	ZT4, 192(CYPH_PLAIN_OUT, DATA_OFFSET, 1){MASKREG};	\
+\
+	/* adjust offset and length */					\
+	add	$256, DATA_OFFSET;					\
+	sub	$256, LENGTH;						\
+
+/*
+ * This macro ciphers payloads shorter than 256 bytes. The number of blocks in
+ * the message comes as an argument. Depending on the number of blocks, an
+ * optimized variant of INITIAL_BLOCKS_SMALL is invoked
+ */
+#define CNTR_ENC_DEC_SMALL(KEY, CYPH_PLAIN_OUT, PLAIN_CYPH_IN, LENGTH, NUM_BLOCKS, CTR, ZTMP1, ZTMP2, ZTMP3, ZTMP4, ZTMP5, ZTMP6, ZTMP7, ZTMP8, IA0, IA1, MASKREG, SHUFREG, NROUNDS)  \
+	cmp	$8, NUM_BLOCKS;		\
+	je	38f;			\
+	jl	48f;			\
+	/* Initial blocks 9-16 */	\
+	cmp	$12, NUM_BLOCKS;	\
+	je	42f;			\
+	jl	49f;			\
+	/* Initial blocks 13-16 */	\
+	cmp	$16, NUM_BLOCKS;	\
+	je	46f;			\
+	cmp	$15, NUM_BLOCKS;	\
+	je	45f;			\
+	cmp	$14, NUM_BLOCKS;	\
+	je	44f;			\
+	cmp	$13, NUM_BLOCKS;	\
+	je	43f;			\
+49:;					\
+	cmp	$11, NUM_BLOCKS;	\
+	je	41f;			\
+	cmp	$10, NUM_BLOCKS;	\
+	je	40f;			\
+	cmp	$9, NUM_BLOCKS;		\
+	je	39f;			\
+48:;					\
+	cmp	$4, NUM_BLOCKS;		\
+	je	34f;			\
+	jl	47f;			\
+	/* Initial blocks 5-7 */	\
+	cmp	$7, NUM_BLOCKS;		\
+	je	37f;			\
+	cmp	$6, NUM_BLOCKS;		\
+	je	36f;			\
+	cmp	$5, NUM_BLOCKS;		\
+	je	35f;			\
+47:;					\
+	cmp	$3, NUM_BLOCKS;		\
+	je	33f;			\
+	cmp	$2, NUM_BLOCKS;		\
+	je	32f;			\
+	jmp	31f;			\
+46:;	\
+	INITIAL_BLOCKS_SMALL(CYPH_PLAIN_OUT, PLAIN_CYPH_IN, LENGTH, 16, CTR, ZTMP1, ZTMP2, ZTMP3, ZTMP4, ZTMP5, ZTMP6, ZTMP7, ZTMP8, IA0, IA1, MASKREG, SHUFREG, NROUNDS)      \
+	jmp	30f;	\
+45:;	\
+	INITIAL_BLOCKS_SMALL(CYPH_PLAIN_OUT, PLAIN_CYPH_IN, LENGTH, 15, CTR, ZTMP1, ZTMP2, ZTMP3, ZTMP4, ZTMP5, ZTMP6, ZTMP7, ZTMP8, IA0, IA1, MASKREG, SHUFREG, NROUNDS)      \
+	jmp	30f;	\
+44:;	\
+	INITIAL_BLOCKS_SMALL(CYPH_PLAIN_OUT, PLAIN_CYPH_IN, LENGTH, 14, CTR, ZTMP1, ZTMP2, ZTMP3, ZTMP4, ZTMP5, ZTMP6, ZTMP7, ZTMP8, IA0, IA1, MASKREG, SHUFREG, NROUNDS)      \
+	jmp	30f;	\
+43:;	\
+	INITIAL_BLOCKS_SMALL(CYPH_PLAIN_OUT, PLAIN_CYPH_IN, LENGTH, 13, CTR, ZTMP1, ZTMP2, ZTMP3, ZTMP4, ZTMP5, ZTMP6, ZTMP7, ZTMP8, IA0, IA1, MASKREG, SHUFREG, NROUNDS)      \
+	jmp	30f;	\
+42:;	\
+	INITIAL_BLOCKS_SMALL(CYPH_PLAIN_OUT, PLAIN_CYPH_IN, LENGTH, 12, CTR, ZTMP1, ZTMP2, ZTMP3, ZTMP4, ZTMP5, ZTMP6, ZTMP7, ZTMP8, IA0, IA1, MASKREG, SHUFREG, NROUNDS)      \
+	jmp	30f;	\
+41:;	\
+	INITIAL_BLOCKS_SMALL(CYPH_PLAIN_OUT, PLAIN_CYPH_IN, LENGTH, 11, CTR, ZTMP1, ZTMP2, ZTMP3, ZTMP4, ZTMP5, ZTMP6, ZTMP7, ZTMP8, IA0, IA1, MASKREG, SHUFREG, NROUNDS)      \
+	jmp	30f;	\
+40:;	\
+	INITIAL_BLOCKS_SMALL(CYPH_PLAIN_OUT, PLAIN_CYPH_IN, LENGTH, 10, CTR, ZTMP1, ZTMP2, ZTMP3, ZTMP4, ZTMP5, ZTMP6, ZTMP7, ZTMP8, IA0, IA1, MASKREG, SHUFREG, NROUNDS)      \
+	jmp	30f;	\
+39:;	\
+	INITIAL_BLOCKS_SMALL(CYPH_PLAIN_OUT, PLAIN_CYPH_IN, LENGTH, 9, CTR, ZTMP1, ZTMP2, ZTMP3, ZTMP4, ZTMP5, ZTMP6, ZTMP7, ZTMP8, IA0, IA1, MASKREG, SHUFREG, NROUNDS)	    \
+	jmp	30f;	\
+38:;	\
+	INITIAL_BLOCKS_SMALL(CYPH_PLAIN_OUT, PLAIN_CYPH_IN, LENGTH, 8, CTR, ZTMP1, ZTMP2, ZTMP3, ZTMP4, ZTMP5, ZTMP6, ZTMP7, ZTMP8, IA0, IA1, MASKREG, SHUFREG, NROUNDS)	    \
+	jmp	30f;	\
+37:;	\
+	INITIAL_BLOCKS_SMALL(CYPH_PLAIN_OUT, PLAIN_CYPH_IN, LENGTH, 7, CTR, ZTMP1, ZTMP2, ZTMP3, ZTMP4, ZTMP5, ZTMP6, ZTMP7, ZTMP8, IA0, IA1, MASKREG, SHUFREG, NROUNDS)	    \
+	jmp	30f;	\
+36:;	\
+	INITIAL_BLOCKS_SMALL(CYPH_PLAIN_OUT, PLAIN_CYPH_IN, LENGTH, 6, CTR, ZTMP1, ZTMP2, ZTMP3, ZTMP4, ZTMP5, ZTMP6, ZTMP7, ZTMP8, IA0, IA1, MASKREG, SHUFREG, NROUNDS)	    \
+	jmp	30f;	\
+35:;	\
+	INITIAL_BLOCKS_SMALL(CYPH_PLAIN_OUT, PLAIN_CYPH_IN, LENGTH, 5, CTR, ZTMP1, ZTMP2, ZTMP3, ZTMP4, ZTMP5, ZTMP6, ZTMP7, ZTMP8, IA0, IA1, MASKREG, SHUFREG, NROUNDS)	    \
+	jmp	30f;	\
+34:;	\
+	INITIAL_BLOCKS_SMALL(CYPH_PLAIN_OUT, PLAIN_CYPH_IN, LENGTH, 4, CTR, ZTMP1, ZTMP2, ZTMP3, ZTMP4, ZTMP5, ZTMP6, ZTMP7, ZTMP8, IA0, IA1, MASKREG, SHUFREG, NROUNDS)	    \
+	jmp	30f;	\
+33:;	\
+	INITIAL_BLOCKS_SMALL(CYPH_PLAIN_OUT, PLAIN_CYPH_IN, LENGTH, 3, CTR, ZTMP1, ZTMP2, ZTMP3, ZTMP4, ZTMP5, ZTMP6, ZTMP7, ZTMP8, IA0, IA1, MASKREG, SHUFREG, NROUNDS)	    \
+	jmp	30f;	\
+32:;	\
+	INITIAL_BLOCKS_SMALL(CYPH_PLAIN_OUT, PLAIN_CYPH_IN, LENGTH, 2, CTR, ZTMP1, ZTMP2, ZTMP3, ZTMP4, ZTMP5, ZTMP6, ZTMP7, ZTMP8, IA0, IA1, MASKREG, SHUFREG, NROUNDS)	    \
+	jmp	30f;	\
+31:;	\
+	INITIAL_BLOCKS_SMALL(CYPH_PLAIN_OUT, PLAIN_CYPH_IN, LENGTH, 1, CTR, ZTMP1, ZTMP2, ZTMP3, ZTMP4, ZTMP5, ZTMP6, ZTMP7, ZTMP8, IA0, IA1, MASKREG, SHUFREG, NROUNDS)	    \
+30:;
+
+/*
+ * This is the main CNTR macro. It operates on single stream and encrypts 16
+ * blocks at a time
+ */
+#define ENCRYPT_16_PARALLEL(CYPH_PLAIN_OUT, PLAIN_CYPH_IN, DATA_OFFSET, CTR_1_4, CTR_5_8, CTR_9_12, CTR_13_16, IA0, ZT1, ZT2, ZT3, ZT4, ZT5, ZT6, ZT7, ZT8, SHUFREG, ADD8REG, NROUNDS, CTR)	\
+	/* load the text data */	\
+	vmovdqu8	(PLAIN_CYPH_IN, DATA_OFFSET, 1), ZT5;		\
+	vmovdqu8	64(PLAIN_CYPH_IN, DATA_OFFSET, 1), ZT6;		\
+	vmovdqu8	128(PLAIN_CYPH_IN, DATA_OFFSET, 1), ZT7;	\
+	vmovdqu8	192(PLAIN_CYPH_IN, DATA_OFFSET, 1), ZT8;	\
+	/* Populate counter blocks */					\
+	vmovq	XWORD(CTR_1_4), IA0;					\
+	cmp   $~0x1F, IA0;				\
+	jb	26f;							\
+	vpaddq	ddq_add_1(%rip), CTR, CTR;				\
+	vptest	ddq_low_msk(%rip), CTR;					\
+	jnz 27f;							\
+	vpaddq	ddq_high_add_1(%rip), CTR, CTR;				\
+27:;									\
+	INCR_CNTR_NUM_BLOCKS(CTR, CTR_1_4, CTR_5_8, CTR_9_12, CTR_13_16, 4)	\
+	jmp 28f;							\
+26:;									\
+	vpaddq		ADD8REG, CTR_1_4, CTR_1_4;			\
+	vpaddq		ADD8REG, CTR_5_8, CTR_5_8;			\
+	vpaddq		ADD8REG, CTR_9_12, CTR_9_12;			\
+	vpaddq		ADD8REG, CTR_13_16, CTR_13_16;			\
+28:;									\
+	vpshufb		SHUFREG, CTR_1_4, ZT1;				\
+	vpshufb		SHUFREG, CTR_5_8, ZT2;				\
+	vpshufb		SHUFREG, CTR_9_12, ZT3;				\
+	vpshufb		SHUFREG, CTR_13_16, ZT4;			\
+	AES_XOR_ROUNDS(ZT1, ZT2, ZT3, ZT4, ZKEY0, ZKEY1, ZKEY2, ZKEY3, ZKEY4, ZKEY5, ZKEY6, ZKEY7, ZKEY8, ZKEY9, ZKEY10, ZKEY11, ZKEY12, ZKEY13, ZKEY14, ZT5, ZT6, ZT7, ZT8, 16, NROUNDS)     \
+	/*store the text data */					\
+	vmovdqu8	ZT1, (CYPH_PLAIN_OUT, DATA_OFFSET);		\
+	vmovdqu8	ZT2, 64(CYPH_PLAIN_OUT, DATA_OFFSET, 1);	\
+	vmovdqu8	ZT3, 128(CYPH_PLAIN_OUT, DATA_OFFSET, 1);	\
+	vmovdqu8	ZT4, 192(CYPH_PLAIN_OUT, DATA_OFFSET, 1);	\
+	vextracti32x4 $3, CTR_BLOCK_13_16, CTR;
+
+/*
+ * CNTR_ENC_DEC Encodes/Decodes given data. Requires the input data be
+ * at least 1 byte long because of READ_SMALL_INPUT_DATA.
+ */
+#define CNTR_ENC_DEC(KEYS, DST, SRC, LEN, IV, NROUNDS)		\
+	or	LEN, LEN;					\
+	je	22f;						\
+/*								\
+ * Macro flow:							\
+ * - calculate the number of 16byte blocks in the message	\
+ * - process (number of 16byte blocks) mod 16			\
+ * - process 16x16 byte blocks at a time until all are done	\
+ */								\
+	xor	DATA_OFFSET, DATA_OFFSET;			\
+/* Prepare round keys */					\
+	vbroadcastf64x2 16*0(KEYS), ZKEY0;			\
+	vbroadcastf64x2 16*1(KEYS), ZKEY1;			\
+	vbroadcastf64x2 16*2(KEYS), ZKEY2;			\
+	vbroadcastf64x2 16*3(KEYS), ZKEY3;			\
+	vbroadcastf64x2 16*4(KEYS), ZKEY4;			\
+	vbroadcastf64x2 16*5(KEYS), ZKEY5;			\
+	vbroadcastf64x2 16*6(KEYS), ZKEY6;			\
+	vbroadcastf64x2 16*7(KEYS), ZKEY7;			\
+	vbroadcastf64x2 16*8(KEYS), ZKEY8;			\
+	vbroadcastf64x2 16*9(KEYS), ZKEY9;			\
+	vbroadcastf64x2 16*10(KEYS), ZKEY10;			\
+.if NROUNDS == 9;						\
+	jmp 23f;						\
+.else;								\
+	vbroadcastf64x2 16*11(KEYS), ZKEY11;			\
+	vbroadcastf64x2 16*12(KEYS), ZKEY12;			\
+.if NROUNDS == 11;						\
+	jmp 23f;						\
+.else;								\
+	vbroadcastf64x2 16*13(KEYS), ZKEY13;			\
+	vbroadcastf64x2 16*14(KEYS), ZKEY14;			\
+.endif;								\
+.endif;								\
+23:;								\
+	/* Set mask to read 16 IV bytes */			\
+	vmovdqu8	(IV), CTR_BLOCKx;			\
+	vmovdqa64	SHUF_MASK(%rip), SHUFREG;		\
+	/* Store IV as counter in LE format */			\
+	vpshufb XWORD(SHUFREG), CTR_BLOCKx, CTR_BLOCKx;		\
+	/* Determine how many blocks to process in INITIAL */	\
+	mov	LEN, TMP1;					\
+	shr	$4, TMP1;					\
+	and	$0xf, TMP1;					\
+	/* Less than 256B will be handled by the small message	\
+	 * code, which can process up to 16x blocks (16 bytes)	\
+	 */							\
+	cmp	$256, LEN;					\
+	jge	20f;						\
+	CNTR_ENC_DEC_SMALL(KEYS, DST, SRC, LEN, TMP1, CTR_BLOCKx, ZTMP0, ZTMP1, ZTMP2, ZTMP3, ZTMP4, ZTMP5, ZTMP6, ZTMP7, TMP0, TMP2, MASKREG, SHUFREG, NROUNDS)	\
+	jmp	22f;						\
+20:;								\
+	and	$0xf, TMP1;					\
+	je	16f;						\
+	cmp	$15, TMP1;					\
+	je	15f;						\
+	cmp	$14, TMP1;					\
+	je	14f;						\
+	cmp	$13, TMP1;					\
+	je	13f;						\
+	cmp	$12, TMP1;					\
+	je	12f;						\
+	cmp	$11, TMP1;					\
+	je	11f;						\
+	cmp	$10, TMP1;					\
+	je	10f;						\
+	cmp	$9, TMP1;					\
+	je	9f;						\
+	cmp	$8, TMP1;					\
+	je	8f;						\
+	cmp	$7, TMP1;					\
+	je	7f;						\
+	cmp	$6, TMP1;					\
+	je	6f;						\
+	cmp	$5, TMP1;					\
+	je	5f;						\
+	cmp	$4, TMP1;					\
+	je	4f;						\
+	cmp	$3, TMP1;					\
+	je	3f;						\
+	cmp	$2, TMP1;					\
+	je	2f;						\
+	jmp	1f;						\
+\
+	and	$0xf, TMP1;					\
+	je	16f;						\
+	cmp	$8, TMP1;					\
+	je	8f;						\
+	jl	18f;						\
+	/* Initial blocks 9-15 */				\
+	cmp	$12, TMP1;					\
+	je	12f;						\
+	jl	19f;						\
+	/* Initial blocks 13-15 */				\
+	cmp	$15, TMP1;					\
+	je	15f;						\
+	cmp	$14, TMP1;					\
+	je	14f;						\
+	cmp	$13, TMP1;					\
+	je	13f;						\
+19:;								\
+	cmp	$11, TMP1;					\
+	je	11f;						\
+	cmp	$10, TMP1;					\
+	je	10f;						\
+	cmp	$9, TMP1;					\
+	je	9f;						\
+18:;								\
+	cmp	$4, TMP1;					\
+	je	4f;						\
+	jl	17f;						\
+	/* Initial blocks 5-7 */				\
+	cmp	$7, TMP1;					\
+	je	7f;						\
+	cmp	$6, TMP1;					\
+	je	6f;						\
+	cmp	$5, TMP1;					\
+	je	5f;						\
+17:;								\
+	cmp	$3, TMP1;					\
+	je	3f;						\
+	cmp	$2, TMP1;					\
+	je	2f;						\
+	jmp	1f;						\
+15:;								\
+	INITIAL_BLOCKS(DST, SRC, LEN, DATA_OFFSET, 15, CTR_BLOCKx, CTR_BLOCK_1_4, CTR_BLOCK_5_8, CTR_BLOCK_9_12, CTR_BLOCK_13_16, ZTMP0, ZTMP1, ZTMP2, ZTMP3, ZTMP4, ZTMP5, ZTMP6, ZTMP7, TMP0, TMP1, MASKREG, SHUFREG, NROUNDS)	\
+	jmp	21f;	\
+14:;	\
+	INITIAL_BLOCKS(DST, SRC, LEN, DATA_OFFSET, 14, CTR_BLOCKx, CTR_BLOCK_1_4, CTR_BLOCK_5_8, CTR_BLOCK_9_12, CTR_BLOCK_13_16, ZTMP0, ZTMP1, ZTMP2, ZTMP3, ZTMP4, ZTMP5, ZTMP6, ZTMP7, TMP0, TMP1, MASKREG, SHUFREG, NROUNDS)	\
+	jmp	21f;	\
+13:;	\
+	INITIAL_BLOCKS(DST, SRC, LEN, DATA_OFFSET, 13, CTR_BLOCKx, CTR_BLOCK_1_4, CTR_BLOCK_5_8, CTR_BLOCK_9_12, CTR_BLOCK_13_16, ZTMP0, ZTMP1, ZTMP2, ZTMP3, ZTMP4, ZTMP5, ZTMP6, ZTMP7, TMP0, TMP1, MASKREG, SHUFREG, NROUNDS)	\
+	jmp	21f;	\
+12:;	\
+	INITIAL_BLOCKS(DST, SRC, LEN, DATA_OFFSET, 12, CTR_BLOCKx, CTR_BLOCK_1_4, CTR_BLOCK_5_8, CTR_BLOCK_9_12, CTR_BLOCK_13_16, ZTMP0, ZTMP1, ZTMP2, ZTMP3, ZTMP4, ZTMP5, ZTMP6, ZTMP7, TMP0, TMP1, MASKREG, SHUFREG, NROUNDS)	\
+	jmp	21f;	\
+11:;	\
+	INITIAL_BLOCKS(DST, SRC, LEN, DATA_OFFSET, 11, CTR_BLOCKx, CTR_BLOCK_1_4, CTR_BLOCK_5_8, CTR_BLOCK_9_12, CTR_BLOCK_13_16, ZTMP0, ZTMP1, ZTMP2, ZTMP3, ZTMP4, ZTMP5, ZTMP6, ZTMP7, TMP0, TMP1, MASKREG, SHUFREG, NROUNDS)	\
+	jmp	21f;	\
+10:;	\
+	INITIAL_BLOCKS(DST, SRC, LEN, DATA_OFFSET, 10, CTR_BLOCKx, CTR_BLOCK_1_4, CTR_BLOCK_5_8, CTR_BLOCK_9_12, CTR_BLOCK_13_16, ZTMP0, ZTMP1, ZTMP2, ZTMP3, ZTMP4, ZTMP5, ZTMP6, ZTMP7, TMP0, TMP1, MASKREG, SHUFREG, NROUNDS)	\
+	jmp	21f;	\
+9:;	\
+	INITIAL_BLOCKS(DST, SRC, LEN, DATA_OFFSET, 9, CTR_BLOCKx, CTR_BLOCK_1_4, CTR_BLOCK_5_8, CTR_BLOCK_9_12, CTR_BLOCK_13_16, ZTMP0, ZTMP1, ZTMP2, ZTMP3, ZTMP4, ZTMP5, ZTMP6, ZTMP7, TMP0, TMP1, MASKREG, SHUFREG, NROUNDS)	\
+	jmp	21f;	\
+8:;	\
+	INITIAL_BLOCKS(DST, SRC, LEN, DATA_OFFSET, 8, CTR_BLOCKx, CTR_BLOCK_1_4, CTR_BLOCK_5_8, CTR_BLOCK_9_12, CTR_BLOCK_13_16, ZTMP0, ZTMP1, ZTMP2, ZTMP3, ZTMP4, ZTMP5, ZTMP6, ZTMP7, TMP0, TMP1, MASKREG, SHUFREG, NROUNDS)	\
+	jmp	21f;	\
+7:;	\
+	INITIAL_BLOCKS(DST, SRC, LEN, DATA_OFFSET, 7, CTR_BLOCKx, CTR_BLOCK_1_4, CTR_BLOCK_5_8, CTR_BLOCK_9_12, CTR_BLOCK_13_16, ZTMP0, ZTMP1, ZTMP2, ZTMP3, ZTMP4, ZTMP5, ZTMP6, ZTMP7, TMP0, TMP1, MASKREG, SHUFREG, NROUNDS)	\
+	jmp	21f;	\
+6:;	\
+	INITIAL_BLOCKS(DST, SRC, LEN, DATA_OFFSET, 6, CTR_BLOCKx, CTR_BLOCK_1_4, CTR_BLOCK_5_8, CTR_BLOCK_9_12, CTR_BLOCK_13_16, ZTMP0, ZTMP1, ZTMP2, ZTMP3, ZTMP4, ZTMP5, ZTMP6, ZTMP7, TMP0, TMP1, MASKREG, SHUFREG, NROUNDS)	\
+	jmp	21f;	\
+5:;	\
+	INITIAL_BLOCKS(DST, SRC, LEN, DATA_OFFSET, 5, CTR_BLOCKx, CTR_BLOCK_1_4, CTR_BLOCK_5_8, CTR_BLOCK_9_12, CTR_BLOCK_13_16, ZTMP0, ZTMP1, ZTMP2, ZTMP3, ZTMP4, ZTMP5, ZTMP6, ZTMP7, TMP0, TMP1, MASKREG, SHUFREG, NROUNDS)	\
+	jmp	21f;	\
+4:;	\
+	INITIAL_BLOCKS(DST, SRC, LEN, DATA_OFFSET, 4, CTR_BLOCKx, CTR_BLOCK_1_4, CTR_BLOCK_5_8, CTR_BLOCK_9_12, CTR_BLOCK_13_16, ZTMP0, ZTMP1, ZTMP2, ZTMP3, ZTMP4, ZTMP5, ZTMP6, ZTMP7, TMP0, TMP1, MASKREG, SHUFREG, NROUNDS)	\
+	jmp	21f;	\
+3:;	\
+	INITIAL_BLOCKS(DST, SRC, LEN, DATA_OFFSET, 3, CTR_BLOCKx, CTR_BLOCK_1_4, CTR_BLOCK_5_8, CTR_BLOCK_9_12, CTR_BLOCK_13_16, ZTMP0, ZTMP1, ZTMP2, ZTMP3, ZTMP4, ZTMP5, ZTMP6, ZTMP7, TMP0, TMP1, MASKREG, SHUFREG, NROUNDS)	\
+	jmp	21f;	\
+2:;	\
+	INITIAL_BLOCKS(DST, SRC, LEN, DATA_OFFSET, 2, CTR_BLOCKx, CTR_BLOCK_1_4, CTR_BLOCK_5_8, CTR_BLOCK_9_12, CTR_BLOCK_13_16, ZTMP0, ZTMP1, ZTMP2, ZTMP3, ZTMP4, ZTMP5, ZTMP6, ZTMP7, TMP0, TMP1, MASKREG, SHUFREG, NROUNDS)	\
+	jmp	21f;	\
+1:;	\
+	INITIAL_BLOCKS(DST, SRC, LEN, DATA_OFFSET, 1, CTR_BLOCKx, CTR_BLOCK_1_4, CTR_BLOCK_5_8, CTR_BLOCK_9_12, CTR_BLOCK_13_16, ZTMP0, ZTMP1, ZTMP2, ZTMP3, ZTMP4, ZTMP5, ZTMP6, ZTMP7, TMP0, TMP1, MASKREG, SHUFREG, NROUNDS)	\
+	jmp	21f;	\
+16:;	\
+	INITIAL_BLOCKS(DST, SRC, LEN, DATA_OFFSET, 0, CTR_BLOCKx, CTR_BLOCK_1_4, CTR_BLOCK_5_8, CTR_BLOCK_9_12, CTR_BLOCK_13_16, ZTMP0, ZTMP1, ZTMP2, ZTMP3, ZTMP4, ZTMP5, ZTMP6, ZTMP7, TMP0, TMP1, MASKREG, SHUFREG, NROUNDS)	\
+21:;	\
+	or		LEN, LEN;				\
+	je		22f;					\
+	vmovdqa64	ddq_add_16(%rip), ADD8REG;		\
+25:;								\
+	ENCRYPT_16_PARALLEL(DST, SRC, DATA_OFFSET, CTR_BLOCK_1_4, CTR_BLOCK_5_8, CTR_BLOCK_9_12, CTR_BLOCK_13_16, TMP0, ZTMP0, ZTMP1, ZTMP2, ZTMP3, ZTMP4, ZTMP5, ZTMP6, ZTMP7, SHUFREG, ADD8REG, NROUNDS, CTR_BLOCKx)		\
+	add	$256, DATA_OFFSET;				\
+	sub	$256, LEN;					\
+	cmp	$256, LEN;					\
+	jge	25b;						\
+22:;								\
+	/* Update IV for next round */				\
+	vpaddq	ONE(%rip), CTR_BLOCKx, CTR_BLOCKx;		\
+	vptest	ddq_low_msk(%rip), CTR_BLOCKx;			\
+	jnz 24f;						\
+	vpaddq	ddq_high_add_1(%rip), CTR_BLOCKx, CTR_BLOCKx;;	\
+24:;								\
+	vpshufb SHUF_MASK(%rip), CTR_BLOCKx, CTR_BLOCKx;;	\
+	vmovdqu CTR_BLOCKx, (IV);
+
+#define AES_CNTR_ENC_AVX512_BY16(keys, out, in, len, iv, NROUNDS)	\
+	FUNC_SAVE_CTR()							\
+	/* call the aes main loop */					\
+	CNTR_ENC_DEC(keys, out, in, len, iv, NROUNDS)			\
+	FUNC_RESTORE_CTR()						\
+	ret;
+
+/* Routine to do AES128/192/256 CTR enc/decrypt "by16"
+ * void aes_ctr_enc_128_avx512_by16/ aes_ctr_enc_192_avx512_by16/
+ *	aes_ctr_enc_256_avx512_by16/
+ *		(void *keys,
+ *		 u8 *out,
+ *		 const u8 *in,
+ *		 unsigned int num_bytes,
+ *		 u8 *iv);
+ */
+SYM_FUNC_START(aes_ctr_enc_128_avx512_by16)
+	AES_CNTR_ENC_AVX512_BY16(arg1, arg2, arg3, arg4, arg5, 9)
+SYM_FUNC_END(aes_ctr_enc_128_avx512_by16)
+
+SYM_FUNC_START(aes_ctr_enc_192_avx512_by16)
+	AES_CNTR_ENC_AVX512_BY16(arg1, arg2, arg3, arg4, arg5, 11)
+SYM_FUNC_END(aes_ctr_enc_192_avx512_by16)
+
+SYM_FUNC_START(aes_ctr_enc_256_avx512_by16)
+	AES_CNTR_ENC_AVX512_BY16(arg1, arg2, arg3, arg4, arg5, 13)
+SYM_FUNC_END(aes_ctr_enc_256_avx512_by16)
diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index e2aae07..edf0056 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -45,6 +45,10 @@
 #define CRYPTO_AES_CTX_SIZE (sizeof(struct crypto_aes_ctx) + AESNI_ALIGN_EXTRA)
 #define XTS_AES_CTX_SIZE (sizeof(struct aesni_xts_ctx) + AESNI_ALIGN_EXTRA)
 
+static bool use_avx512;
+module_param(use_avx512, bool, 0644);
+MODULE_PARM_DESC(use_avx512, "Use AVX512 optimized algorithm, if available");
+
 /* This data is stored at the end of the crypto_tfm struct.
  * It's a type of per "session" data storage location.
  * This needs to be 16 byte aligned.
@@ -135,6 +139,20 @@ asmlinkage void aes_ctr_enc_192_avx_by8(const u8 *in, u8 *iv,
 		void *keys, u8 *out, unsigned int num_bytes);
 asmlinkage void aes_ctr_enc_256_avx_by8(const u8 *in, u8 *iv,
 		void *keys, u8 *out, unsigned int num_bytes);
+
+asmlinkage void aes_ctr_enc_128_avx512_by16(void *keys, u8 *out,
+					    const u8 *in,
+					    unsigned int num_bytes,
+					    u8 *iv);
+asmlinkage void aes_ctr_enc_192_avx512_by16(void *keys, u8 *out,
+					    const u8 *in,
+					    unsigned int num_bytes,
+					    u8 *iv);
+asmlinkage void aes_ctr_enc_256_avx512_by16(void *keys, u8 *out,
+					    const u8 *in,
+					    unsigned int num_bytes,
+					    u8 *iv);
+
 /*
  * asmlinkage void aesni_gcm_init_avx_gen2()
  * gcm_data *my_ctx_data, context data
@@ -493,6 +511,23 @@ static void aesni_ctr_enc_avx_tfm(struct crypto_aes_ctx *ctx, u8 *out,
 		aes_ctr_enc_256_avx_by8(in, iv, (void *)ctx, out, len);
 }
 
+static void aesni_ctr_enc_avx512_tfm(struct crypto_aes_ctx *ctx, u8 *out,
+				     const u8 *in, unsigned int len, u8 *iv)
+{
+	/*
+	 * Based on key length, override with the by16 version
+	 * of ctr mode encryption/decryption for improved performance.
+	 * aes_set_key_common() ensures that key length is one of
+	 * {128,192,256}
+	 */
+	if (ctx->key_length == AES_KEYSIZE_128)
+		aes_ctr_enc_128_avx512_by16((void *)ctx, out, in, len, iv);
+	else if (ctx->key_length == AES_KEYSIZE_192)
+		aes_ctr_enc_192_avx512_by16((void *)ctx, out, in, len, iv);
+	else
+		aes_ctr_enc_256_avx512_by16((void *)ctx, out, in, len, iv);
+}
+
 static int ctr_crypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
@@ -1152,7 +1187,12 @@ static int __init aesni_init(void)
 	} else {
 		pr_info("SSE version of gcm_enc/dec engaged.\n");
 	}
-	if (boot_cpu_has(X86_FEATURE_AVX)) {
+	if (use_avx512 && IS_ENABLED(CONFIG_CRYPTO_AES_CTR_AVX512) &&
+	    cpu_feature_enabled(X86_FEATURE_VAES)) {
+		/* Ctr mode performance optimization using AVX512 */
+		static_call_update(aesni_ctr_enc_tfm, aesni_ctr_enc_avx512_tfm);
+		pr_info("AES CTR mode by16 optimization enabled\n");
+	} else if (boot_cpu_has(X86_FEATURE_AVX)) {
 		/* optimize performance of ctr mode encryption transform */
 		static_call_update(aesni_ctr_enc_tfm, aesni_ctr_enc_avx_tfm);
 		pr_info("AES CTR mode by8 optimization enabled\n");
diff --git a/arch/x86/include/asm/disabled-features.h b/arch/x86/include/asm/disabled-features.h
index e6e3b9f..a4f5dd9 100644
--- a/arch/x86/include/asm/disabled-features.h
+++ b/arch/x86/include/asm/disabled-features.h
@@ -62,6 +62,12 @@
 # define DISABLE_VPCLMULQDQ	(1 << (X86_FEATURE_VPCLMULQDQ & 31))
 #endif
 
+#if defined(CONFIG_AS_VAES_AVX512)
+# define DISABLE_VAES		0
+#else
+# define DISABLE_VAES		(1 << (X86_FEATURE_VAES & 31))
+#endif
+
 #ifdef CONFIG_IOMMU_SUPPORT
 # define DISABLE_ENQCMD	0
 #else
@@ -94,7 +100,7 @@
 #define DISABLED_MASK14	0
 #define DISABLED_MASK15	0
 #define DISABLED_MASK16	(DISABLE_PKU|DISABLE_OSPKE|DISABLE_LA57|DISABLE_UMIP| \
-			 DISABLE_ENQCMD|DISABLE_VPCLMULQDQ)
+			 DISABLE_ENQCMD|DISABLE_VPCLMULQDQ|DISABLE_VAES)
 #define DISABLED_MASK17	0
 #define DISABLED_MASK18	0
 #define DISABLED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 19)
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 3059b07..5c15471 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -635,6 +635,18 @@ config CRYPTO_CRCT10DIF_AVX512
 	depends on CRYPTO_CRCT10DIF_PCLMUL
 	depends on AS_VPCLMULQDQ
 
+# We default CRYPTO_AES_CTR_AVX512 to Y but depend on CRYPTO_AVX512 in
+# order to have a singular option (CRYPTO_AVX512) select multiple algorithms
+# when supported. Specifically, if the platform and/or toolset does not
+# support VPLMULQDQ. Then this algorithm should not be supported as part of
+# the set that CRYPTO_AVX512 selects.
+config CRYPTO_AES_CTR_AVX512
+       bool
+       default y
+       depends on CRYPTO_AVX512
+       depends on CRYPTO_AES_NI_INTEL
+       depends on AS_VAES_AVX512
+
 config CRYPTO_CRC32C_SPARC64
 	tristate "CRC32c CRC algorithm (SPARC64)"
 	depends on SPARC64
-- 
2.7.4

