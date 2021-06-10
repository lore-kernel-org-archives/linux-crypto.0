Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52832C47094
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Jun 2021 13:45:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 271BB61404
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Jun 2021 13:45:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbhFJNrC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Jun 2021 09:47:02 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:41108 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230035AbhFJNrB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Jun 2021 09:47:01 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0Ubz5Z10_1623332701;
Received: from localhost(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0Ubz5Z10_1623332701)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 10 Jun 2021 21:45:01 +0800
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "Markku-Juhani O . Saarinen" <mjos@iki.fi>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>, x86@kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Subject: [PATCH 3/3] crypto: x86/sm4 - add AES-NI/AVX/x86_64 assembler implementation
Date:   Thu, 10 Jun 2021 21:44:59 +0800
Message-Id: <20210610134459.28541-4-tianjia.zhang@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.3.ge56e4f7
In-Reply-To: <20210610134459.28541-1-tianjia.zhang@linux.alibaba.com>
References: <20210610134459.28541-1-tianjia.zhang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds AES-NI/AVX/x86_64 assembler implementation of SM4
block cipher. Through two affine transforms, we can use the AES
S-Box to simulate the SM4 S-Box to achieve the effect of instruction
acceleration.

Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
---
 arch/x86/crypto/Makefile               |   3 +
 arch/x86/crypto/sm4-aesni-avx-asm_64.S | 339 +++++++++++++++++++++++++
 arch/x86/crypto/sm4_aesni_avx_glue.c   | 115 +++++++++
 crypto/Kconfig                         |  29 +++
 4 files changed, 486 insertions(+)
 create mode 100644 arch/x86/crypto/sm4-aesni-avx-asm_64.S
 create mode 100644 arch/x86/crypto/sm4_aesni_avx_glue.c

diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index d0959e7b809f..08f95d4e1e7c 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -88,6 +88,9 @@ nhpoly1305-avx2-y := nh-avx2-x86_64.o nhpoly1305-avx2-glue.o
 
 obj-$(CONFIG_CRYPTO_CURVE25519_X86) += curve25519-x86_64.o
 
+obj-$(CONFIG_CRYPTO_SM4_AESNI_AVX_X86_64) += sm4-aesni-avx-x86_64.o
+sm4-aesni-avx-x86_64-y := sm4-aesni-avx-asm_64.o sm4_aesni_avx_glue.o
+
 quiet_cmd_perlasm = PERLASM $@
       cmd_perlasm = $(PERL) $< > $@
 $(obj)/%.S: $(src)/%.pl FORCE
diff --git a/arch/x86/crypto/sm4-aesni-avx-asm_64.S b/arch/x86/crypto/sm4-aesni-avx-asm_64.S
new file mode 100644
index 000000000000..c7cbb7e90bec
--- /dev/null
+++ b/arch/x86/crypto/sm4-aesni-avx-asm_64.S
@@ -0,0 +1,339 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * SM4 Cipher Algorithm, AES-NI/AVX optimized.
+ * as specified in
+ * https://tools.ietf.org/id/draft-ribose-cfrg-sm4-04.html
+ *
+ * Copyright (C) 2018 Markku-Juhani O. Saarinen <mjos@iki.fi>
+ * Copyright (C) 2020 Jussi Kivilinna <jussi.kivilinna@iki.fi>
+ * Copyright (c) 2021 Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
+ */
+
+/* Based on SM4 AES-NI work by libgcrypt and Markku-Juhani O. Saarinen at:
+ *  https://github.com/mjosaarinen/sm4ni
+ */
+
+#include <linux/linkage.h>
+#include <asm/frame.h>
+
+#define rRIP         (%rip)
+
+#define RX0          %xmm0
+#define RX1          %xmm1
+#define MASK_4BIT    %xmm2
+#define RTMP0        %xmm3
+#define RTMP1        %xmm4
+#define RTMP2        %xmm5
+#define RTMP3        %xmm6
+#define RTMP4        %xmm7
+
+#define RA0          %xmm8
+#define RA1          %xmm9
+#define RA2          %xmm10
+#define RA3          %xmm11
+
+#define RB0          %xmm12
+#define RB1          %xmm13
+#define RB2          %xmm14
+#define RB3          %xmm15
+
+#define RNOT         %xmm0
+#define RBSWAP       %xmm1
+
+
+/* Transpose four 32-bit words between 128-bit vectors. */
+#define transpose_4x4(x0, x1, x2, x3, t1, t2) \
+	vpunpckhdq x1, x0, t2;                \
+	vpunpckldq x1, x0, x0;                \
+	                                      \
+	vpunpckldq x3, x2, t1;                \
+	vpunpckhdq x3, x2, x2;                \
+	                                      \
+	vpunpckhqdq t1, x0, x1;               \
+	vpunpcklqdq t1, x0, x0;               \
+	                                      \
+	vpunpckhqdq x2, t2, x3;               \
+	vpunpcklqdq x2, t2, x2;
+
+/* pre-SubByte transform. */
+#define transform_pre(x, lo_t, hi_t, mask4bit, tmp0) \
+	vpand x, mask4bit, tmp0;                     \
+	vpandn x, mask4bit, x;                       \
+	vpsrld $4, x, x;                             \
+	                                             \
+	vpshufb tmp0, lo_t, tmp0;                    \
+	vpshufb x, hi_t, x;                          \
+	vpxor tmp0, x, x;
+
+/* post-SubByte transform. Note: x has been XOR'ed with mask4bit by
+ * 'vaeslastenc' instruction.
+ */
+#define transform_post(x, lo_t, hi_t, mask4bit, tmp0) \
+	vpandn mask4bit, x, tmp0;                     \
+	vpsrld $4, x, x;                              \
+	vpand x, mask4bit, x;                         \
+	                                              \
+	vpshufb tmp0, lo_t, tmp0;                     \
+	vpshufb x, hi_t, x;                           \
+	vpxor tmp0, x, x;
+
+
+.section	.rodata.cst16, "aM", @progbits, 16
+.align 16
+
+/*
+ * Following four affine transform look-up tables are from work by
+ * Markku-Juhani O. Saarinen, at https://github.com/mjosaarinen/sm4ni
+ *
+ * These allow exposing SM4 S-Box from AES SubByte.
+ */
+
+/* pre-SubByte affine transform, from SM4 field to AES field. */
+.Lpre_tf_lo_s:
+	.quad 0x9197E2E474720701, 0xC7C1B4B222245157
+.Lpre_tf_hi_s:
+	.quad 0xE240AB09EB49A200, 0xF052B91BF95BB012
+
+/* post-SubByte affine transform, from AES field to SM4 field. */
+.Lpost_tf_lo_s:
+	.quad 0x5B67F2CEA19D0834, 0xEDD14478172BBE82
+.Lpost_tf_hi_s:
+	.quad 0xAE7201DD73AFDC00, 0x11CDBE62CC1063BF
+
+/* For isolating SubBytes from AESENCLAST, inverse shift row */
+.Linv_shift_row:
+	.byte 0x00, 0x0d, 0x0a, 0x07, 0x04, 0x01, 0x0e, 0x0b
+	.byte 0x08, 0x05, 0x02, 0x0f, 0x0c, 0x09, 0x06, 0x03
+
+/* Inverse shift row + Rotate left by 8 bits on 32-bit words with vpshufb */
+.Linv_shift_row_rol_8:
+	.byte 0x07, 0x00, 0x0d, 0x0a, 0x0b, 0x04, 0x01, 0x0e
+	.byte 0x0f, 0x08, 0x05, 0x02, 0x03, 0x0c, 0x09, 0x06
+
+/* Inverse shift row + Rotate left by 16 bits on 32-bit words with vpshufb */
+.Linv_shift_row_rol_16:
+	.byte 0x0a, 0x07, 0x00, 0x0d, 0x0e, 0x0b, 0x04, 0x01
+	.byte 0x02, 0x0f, 0x08, 0x05, 0x06, 0x03, 0x0c, 0x09
+
+/* Inverse shift row + Rotate left by 24 bits on 32-bit words with vpshufb */
+.Linv_shift_row_rol_24:
+	.byte 0x0d, 0x0a, 0x07, 0x00, 0x01, 0x0e, 0x0b, 0x04
+	.byte 0x05, 0x02, 0x0f, 0x08, 0x09, 0x06, 0x03, 0x0c
+
+/* For CTR-mode IV byteswap */
+.Lbswap128_mask:
+	.byte 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0
+
+/* For input word byte-swap */
+.Lbswap32_mask:
+	.byte 3, 2, 1, 0, 7, 6, 5, 4, 11, 10, 9, 8, 15, 14, 13, 12
+
+.align 4
+/* 4-bit mask */
+.L0f0f0f0f:
+	.long 0x0f0f0f0f
+
+
+.text
+.align 16
+
+/*
+ * void sm4_aesni_avx_expand_key(const u8 *key, u32 *rk_enc,
+ *                  u32 *rk_dec, const u32 *fk, const u32 *ck);
+ */
+SYM_FUNC_START(sm4_aesni_avx_expand_key)
+	/* input:
+	 *	%rdi: 128-bit key
+	 *	%rsi: rkey_enc
+	 *	%rdx: rkey_dec
+	 *	%rcx: fk array
+	 *	%r8: ck array
+	 */
+	FRAME_BEGIN
+
+	vmovd 0*4(%rdi), RA0;
+	vmovd 1*4(%rdi), RA1;
+	vmovd 2*4(%rdi), RA2;
+	vmovd 3*4(%rdi), RA3;
+
+	vmovdqa .Lbswap32_mask rRIP, RTMP2;
+	vpshufb RTMP2, RA0, RA0;
+	vpshufb RTMP2, RA1, RA1;
+	vpshufb RTMP2, RA2, RA2;
+	vpshufb RTMP2, RA3, RA3;
+
+	vmovd 0*4(%rcx), RB0;
+	vmovd 1*4(%rcx), RB1;
+	vmovd 2*4(%rcx), RB2;
+	vmovd 3*4(%rcx), RB3;
+	vpxor RB0, RA0, RA0;
+	vpxor RB1, RA1, RA1;
+	vpxor RB2, RA2, RA2;
+	vpxor RB3, RA3, RA3;
+
+	vbroadcastss .L0f0f0f0f rRIP, MASK_4BIT;
+	vmovdqa .Lpre_tf_lo_s rRIP, RTMP4;
+	vmovdqa .Lpre_tf_hi_s rRIP, RB0;
+	vmovdqa .Lpost_tf_lo_s rRIP, RB1;
+	vmovdqa .Lpost_tf_hi_s rRIP, RB2;
+	vmovdqa .Linv_shift_row rRIP, RB3;
+
+#define ROUND(round, s0, s1, s2, s3)                              \
+	vbroadcastss (4*(round))(%r8), RX0;                       \
+	vpxor s1, RX0, RX0;                                       \
+	vpxor s2, RX0, RX0;                                       \
+	vpxor s3, RX0, RX0; /* s1 ^ s2 ^ s3 ^ rk */               \
+	                                                          \
+	/* sbox, non-linear part */                               \
+	transform_pre(RX0, RTMP4, RB0, MASK_4BIT, RTMP0);         \
+	vaesenclast MASK_4BIT, RX0, RX0;                          \
+	transform_post(RX0, RB1, RB2, MASK_4BIT, RTMP0);          \
+	                                                          \
+	/* linear part */                                         \
+	vpshufb RB3, RX0, RX0;                                    \
+	vpxor RX0, s0, s0; /* s0 ^ x */                           \
+	vpslld $13, RX0, RTMP0;                                   \
+	vpsrld $19, RX0, RTMP1;                                   \
+	vpslld $23, RX0, RTMP2;                                   \
+	vpsrld $9, RX0, RTMP3;                                    \
+	vpxor RTMP0, RTMP1, RTMP1;                                \
+	vpxor RTMP2, RTMP3, RTMP3;                                \
+	vpxor RTMP1, s0, s0; /* s0 ^ x ^ rol(x,13) */             \
+	vpxor RTMP3, s0, s0; /* s0 ^ x ^ rol(x,13) ^ rol(x,23) */
+
+	leaq (32*4)(%r8), %rax;
+	leaq (32*4)(%rdx), %rdx;
+.align 16
+.Lroundloop_expand_key:
+	leaq (-4*4)(%rdx), %rdx;
+	ROUND(0, RA0, RA1, RA2, RA3);
+	ROUND(1, RA1, RA2, RA3, RA0);
+	ROUND(2, RA2, RA3, RA0, RA1);
+	ROUND(3, RA3, RA0, RA1, RA2);
+	leaq (4*4)(%r8), %r8;
+	vmovd RA0, (0*4)(%rsi);
+	vmovd RA1, (1*4)(%rsi);
+	vmovd RA2, (2*4)(%rsi);
+	vmovd RA3, (3*4)(%rsi);
+	vmovd RA0, (3*4)(%rdx);
+	vmovd RA1, (2*4)(%rdx);
+	vmovd RA2, (1*4)(%rdx);
+	vmovd RA3, (0*4)(%rdx);
+	leaq (4*4)(%rsi), %rsi;
+	cmpq %rax, %r8;
+	jne .Lroundloop_expand_key;
+
+#undef ROUND
+
+	vzeroall;
+	FRAME_END
+	ret;
+SYM_FUNC_END(sm4_aesni_avx_expand_key)
+
+
+/*
+ * void sm4_aesni_avx_crypt4(const u32 *rk, u8 *dst,
+ *                          const u8 *src, int nblocks)
+ */
+SYM_FUNC_START(sm4_aesni_avx_crypt4)
+	/* input:
+	 *	%rdi: round key array, CTX
+	 *	%rsi: dst (1..4 blocks)
+	 *	%rdx: src (1..4 blocks)
+	 *	%rcx: num blocks (1..4)
+	 */
+	FRAME_BEGIN
+
+	vmovdqu 0*16(%rdx), RA0;
+	vmovdqa RA0, RA1;
+	vmovdqa RA0, RA2;
+	vmovdqa RA0, RA3;
+	cmpq $2, %rcx;
+	jb .Lblk4_load_input_done;
+	vmovdqu 1*16(%rdx), RA1;
+	je .Lblk4_load_input_done;
+	vmovdqu 2*16(%rdx), RA2;
+	cmpq $3, %rcx;
+	je .Lblk4_load_input_done;
+	vmovdqu 3*16(%rdx), RA3;
+
+.Lblk4_load_input_done:
+
+	vmovdqa .Lbswap32_mask rRIP, RTMP2;
+	vpshufb RTMP2, RA0, RA0;
+	vpshufb RTMP2, RA1, RA1;
+	vpshufb RTMP2, RA2, RA2;
+	vpshufb RTMP2, RA3, RA3;
+
+	vbroadcastss .L0f0f0f0f rRIP, MASK_4BIT;
+	vmovdqa .Lpre_tf_lo_s rRIP, RTMP4;
+	vmovdqa .Lpre_tf_hi_s rRIP, RB0;
+	vmovdqa .Lpost_tf_lo_s rRIP, RB1;
+	vmovdqa .Lpost_tf_hi_s rRIP, RB2;
+	vmovdqa .Linv_shift_row rRIP, RB3;
+	vmovdqa .Linv_shift_row_rol_8 rRIP, RTMP2;
+	vmovdqa .Linv_shift_row_rol_16 rRIP, RTMP3;
+	transpose_4x4(RA0, RA1, RA2, RA3, RTMP0, RTMP1);
+
+#define ROUND(round, s0, s1, s2, s3)                                \
+	vbroadcastss (4*(round))(%rdi), RX0;                        \
+	vpxor s1, RX0, RX0;                                         \
+	vpxor s2, RX0, RX0;                                         \
+	vpxor s3, RX0, RX0; /* s1 ^ s2 ^ s3 ^ rk */                 \
+	                                                            \
+	/* sbox, non-linear part */                                 \
+	transform_pre(RX0, RTMP4, RB0, MASK_4BIT, RTMP0);           \
+	vaesenclast MASK_4BIT, RX0, RX0;                            \
+	transform_post(RX0, RB1, RB2, MASK_4BIT, RTMP0);            \
+	                                                            \
+	/* linear part */                                           \
+	vpshufb RB3, RX0, RTMP0;                                    \
+	vpxor RTMP0, s0, s0; /* s0 ^ x */                           \
+	vpshufb RTMP2, RX0, RTMP1;                                  \
+	vpxor RTMP1, RTMP0, RTMP0; /* x ^ rol(x,8) */               \
+	vpshufb RTMP3, RX0, RTMP1;                                  \
+	vpxor RTMP1, RTMP0, RTMP0; /* x ^ rol(x,8) ^ rol(x,16) */   \
+	vpshufb .Linv_shift_row_rol_24 rRIP, RX0, RTMP1;            \
+	vpxor RTMP1, s0, s0; /* s0 ^ x ^ rol(x,24) */               \
+	vpslld $2, RTMP0, RTMP1;                                    \
+	vpsrld $30, RTMP0, RTMP0;                                   \
+	vpxor RTMP0, s0, s0;                                        \
+	/* s0 ^ x ^ rol(x,2) ^ rol(x,10) ^ rol(x,18) ^ rol(x,24) */ \
+	vpxor RTMP1, s0, s0;
+
+	leaq (32*4)(%rdi), %rax;
+.align 16
+.Lroundloop_blk4:
+	ROUND(0, RA0, RA1, RA2, RA3);
+	ROUND(1, RA1, RA2, RA3, RA0);
+	ROUND(2, RA2, RA3, RA0, RA1);
+	ROUND(3, RA3, RA0, RA1, RA2);
+	leaq (4*4)(%rdi), %rdi;
+	cmpq %rax, %rdi;
+	jne .Lroundloop_blk4;
+
+#undef ROUND
+
+	vmovdqa .Lbswap128_mask rRIP, RTMP2;
+
+	transpose_4x4(RA0, RA1, RA2, RA3, RTMP0, RTMP1);
+	vpshufb RTMP2, RA0, RA0;
+	vpshufb RTMP2, RA1, RA1;
+	vpshufb RTMP2, RA2, RA2;
+	vpshufb RTMP2, RA3, RA3;
+
+	vmovdqu RA0, 0*16(%rsi);
+	cmpq $2, %rcx;
+	jb .Lblk4_store_output_done;
+	vmovdqu RA1, 1*16(%rsi);
+	je .Lblk4_store_output_done;
+	vmovdqu RA2, 2*16(%rsi);
+	cmpq $3, %rcx;
+	je .Lblk4_store_output_done;
+	vmovdqu RA3, 3*16(%rsi);
+
+.Lblk4_store_output_done:
+	vzeroall;
+	FRAME_END
+	ret;
+SYM_FUNC_END(sm4_aesni_avx_crypt4)
diff --git a/arch/x86/crypto/sm4_aesni_avx_glue.c b/arch/x86/crypto/sm4_aesni_avx_glue.c
new file mode 100644
index 000000000000..3f822fa1070a
--- /dev/null
+++ b/arch/x86/crypto/sm4_aesni_avx_glue.c
@@ -0,0 +1,115 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * SM4 Cipher Algorithm, AES-NI/AVX optimized.
+ * as specified in
+ * https://tools.ietf.org/id/draft-ribose-cfrg-sm4-04.html
+ *
+ * Copyright (c) 2021 Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
+ */
+
+#include <linux/module.h>
+#include <linux/crypto.h>
+#include <asm/simd.h>
+#include <crypto/internal/simd.h>
+#include <crypto/sm4.h>
+
+asmlinkage void sm4_aesni_avx_expand_key(const u8 *key, u32 *rk_enc,
+				u32 *rk_dec, const u32 *fk, const u32 *ck);
+asmlinkage void sm4_aesni_avx_crypt4(const u32 *rk, u8 *dst,
+				const u8 *src, int nblocks);
+
+static int sm4_setkey(struct crypto_tfm *tfm, const u8 *in_key,
+			unsigned int key_len)
+{
+	struct crypto_sm4_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	if (key_len != SM4_KEY_SIZE)
+		return -EINVAL;
+
+	if (crypto_simd_usable()) {
+		kernel_fpu_begin();
+		sm4_aesni_avx_expand_key(in_key, ctx->rkey_enc,
+				ctx->rkey_dec, crypto_sm4_fk, crypto_sm4_ck);
+		kernel_fpu_end();
+	} else
+		crypto_sm4_expand_key(ctx, in_key, key_len);
+
+	return 0;
+}
+
+static void sm4_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
+{
+	const struct crypto_sm4_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	if (crypto_simd_usable()) {
+		kernel_fpu_begin();
+		sm4_aesni_avx_crypt4(ctx->rkey_enc, out, in, 1);
+		kernel_fpu_end();
+	} else
+		crypto_sm4_do_crypt(ctx->rkey_enc, out, in);
+}
+
+static void sm4_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
+{
+	const struct crypto_sm4_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	if (crypto_simd_usable()) {
+		kernel_fpu_begin();
+		sm4_aesni_avx_crypt4(ctx->rkey_dec, out, in, 1);
+		kernel_fpu_end();
+	} else
+		crypto_sm4_do_crypt(ctx->rkey_dec, out, in);
+}
+
+static struct crypto_alg sm4_asm_alg = {
+	.cra_name		= "sm4",
+	.cra_driver_name	= "sm4-asm",
+	.cra_priority		= 200,
+	.cra_flags		= CRYPTO_ALG_TYPE_CIPHER,
+	.cra_blocksize		= SM4_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct crypto_sm4_ctx),
+	.cra_module		= THIS_MODULE,
+	.cra_u			= {
+		.cipher = {
+			.cia_min_keysize	= SM4_KEY_SIZE,
+			.cia_max_keysize	= SM4_KEY_SIZE,
+			.cia_setkey		= sm4_setkey,
+			.cia_encrypt		= sm4_encrypt,
+			.cia_decrypt		= sm4_decrypt
+		}
+	}
+};
+
+static int __init sm4_init(void)
+{
+	const char *feature_name;
+
+	if (!boot_cpu_has(X86_FEATURE_AVX) ||
+	    !boot_cpu_has(X86_FEATURE_AES) ||
+	    !boot_cpu_has(X86_FEATURE_OSXSAVE)) {
+		pr_info("AVX or AES-NI instructions are not detected.\n");
+		return -ENODEV;
+	}
+
+	if (!cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM,
+				&feature_name)) {
+		pr_info("CPU feature '%s' is not supported.\n", feature_name);
+		return -ENODEV;
+	}
+
+	return crypto_register_alg(&sm4_asm_alg);
+}
+
+static void __exit sm4_exit(void)
+{
+	crypto_unregister_alg(&sm4_asm_alg);
+}
+
+module_init(sm4_init);
+module_exit(sm4_exit);
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Tianjia Zhang <tianjia.zhang@linux.alibaba.com>");
+MODULE_DESCRIPTION("SM4 Cipher Algorithm, AES-NI/AVX optimized");
+MODULE_ALIAS_CRYPTO("sm4");
+MODULE_ALIAS_CRYPTO("sm4-asm");
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 4fbc9c080ca9..9f639395c667 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1570,6 +1570,35 @@ config CRYPTO_SM4
 
 	  If unsure, say N.
 
+config CRYPTO_SM4_AESNI_AVX_X86_64
+	tristate "SM4 cipher algorithm (x86_64/AES-NI/AVX)"
+	depends on X86 && 64BIT
+	select CRYPTO_SKCIPHER
+	select CRYPTO_SIMD
+	select CRYPTO_ALGAPI
+	select CRYPTO_LIB_SM4
+	help
+	  SM4 cipher algorithms (OSCCA GB/T 32907-2016) (x86_64/AES-NI/AVX).
+
+	  SM4 (GBT.32907-2016) is a cryptographic standard issued by the
+	  Organization of State Commercial Administration of China (OSCCA)
+	  as an authorized cryptographic algorithms for the use within China.
+
+	  SMS4 was originally created for use in protecting wireless
+	  networks, and is mandated in the Chinese National Standard for
+	  Wireless LAN WAPI (Wired Authentication and Privacy Infrastructure)
+	  (GB.15629.11-2003).
+
+	  The latest SM4 standard (GBT.32907-2016) was proposed by OSCCA and
+	  standardized through TC 260 of the Standardization Administration
+	  of the People's Republic of China (SAC).
+
+	  The input, output, and key of SMS4 are each 128 bits.
+
+	  See also: <https://eprint.iacr.org/2008/329.pdf>
+
+	  If unsure, say N.
+
 config CRYPTO_TEA
 	tristate "TEA, XTEA and XETA cipher algorithms"
 	depends on CRYPTO_USER_API_ENABLE_OBSOLETE
-- 
2.19.1.3.ge56e4f7

