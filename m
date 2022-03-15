Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33CBAC43219
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Mar 2022 23:01:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352463AbiCOXCW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 15 Mar 2022 19:02:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352482AbiCOXCT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Mar 2022 19:02:19 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A19495D669
        for <linux-crypto@vger.kernel.org>; Tue, 15 Mar 2022 16:00:58 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id o70-20020a25d749000000b006291c691122so600934ybg.1
        for <linux-crypto@vger.kernel.org>; Tue, 15 Mar 2022 16:00:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=qGgDExHP+hAg7SyMnfp9A2IJEQW1G94fzO/VYpBhAsU=;
        b=ncfLnFG9KRJ4M121mR4bJFNjrj8M0zN9ZToDJ2WKDxPzcj41vMPelac+sepUi2J1Ix
         biBsNmp4JS8n7QZW9V9FOSTBvvFoFlvL5/WNZIe9i9FpVwxksnYYgw8aXjw4v0qGxN9j
         lTV+rzbGwQ2P7DlzjR83bqen2R47Soc5g6oH/0coo/GO37WWWlzGQz/P7f4kpmEdwVl6
         NeDHauY0fQMqikDmvaAHGjgOlwJG0w/U+d0m3z8VfdPHwb9Tnu5XbFyD2ATrKPErgbaa
         hRG0PJQR+lBVQfH5NOUy3Lgld9NctxTpOmScXTWYXnSFC15+CmZtIP0BY8vWOhTop7NL
         JtvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=qGgDExHP+hAg7SyMnfp9A2IJEQW1G94fzO/VYpBhAsU=;
        b=PpDyf38Bz3YtDfgH/vm2KCEWQopaFqUd2lVY2PlEl9iPl2S50QEoQM85Jklk0KUhDC
         4q2aOk7cJRicGTdnhiRf3aRQj1wj4HoiT/6VXRGkv1nXTy0ZfI7lSWMNIsoOLxyPGScP
         LIhstE7CnZ6zGj9mX0VFhicq3fIlpN9D635xaTSnLCG34sGn9VHEHl+lxrYrU7g2hwcb
         9/E/9dmNT1/qc+UDwCEbYE+kd/bIMlPAZv/i9t1SKW+k7AvxT5ZMxHU3P+eR00YkTMmH
         oT6sipPENrkljKr3hi7npync1MIKktMq5rMoBAjhunvB7zj+gH1V5kjzKB7Xq95AOLg4
         RIPw==
X-Gm-Message-State: AOAM533VMhRdYikOt6yDo2STum1XjpNFvhjcazIUSqUi6IQYzcpdBy0J
        tp6bUcgp7SpO8+9MG4URcsRNvab0oDuSCChkX6gcfAuTuhf2UI7zUvhvHZiz3AylRGJEe0JEa58
        FvUtPgHeJpXZSQfCqUTo0Zyzm+j7u5n2ELlwCtgaUg9DiIb7fVXCATwdy3iZ2ZVc/p1s=
X-Google-Smtp-Source: ABdhPJyfBXWOZPk1CVhlPtuq95LEDRwzRfG+5RftU+ggYAtYSYnt9/VZ/j4VQW27Pm7Pv64ead4vBKIZNw==
X-Received: from nhuck.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:39cc])
 (user=nhuck job=sendgmr) by 2002:a25:86:0:b0:633:8c55:a831 with SMTP id
 128-20020a250086000000b006338c55a831mr512617yba.192.1647385257719; Tue, 15
 Mar 2022 16:00:57 -0700 (PDT)
Date:   Tue, 15 Mar 2022 23:00:33 +0000
In-Reply-To: <20220315230035.3792663-1-nhuck@google.com>
Message-Id: <20220315230035.3792663-7-nhuck@google.com>
Mime-Version: 1.0
References: <20220315230035.3792663-1-nhuck@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v3 6/8] crypto: x86/polyval: Add PCLMULQDQ accelerated
 implementation of POLYVAL
From:   Nathan Huckleberry <nhuck@google.com>
To:     linux-crypto@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Paul Crowley <paulcrowley@google.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nathan Huckleberry <nhuck@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add hardware accelerated version of POLYVAL for x86-64 CPUs with
PCLMULQDQ support.

This implementation is accelerated using PCLMULQDQ instructions to
perform the finite field computations.  For added efficiency, 8 blocks
of the message are processed simultaneously by precomputing the first
8 powers of the key.

Schoolbook multiplication is used instead of Karatsuba multiplication
because it was found to be slightly faster on x86-64 machines.
Montgomery reduction must be used instead of Barrett reduction due to
the difference in modulus between POLYVAL's field and other finite
fields.

More information on POLYVAL can be found in the HCTR2 paper:
Length-preserving encryption with HCTR2:
https://eprint.iacr.org/2021/1441.pdf

Signed-off-by: Nathan Huckleberry <nhuck@google.com>
---
 arch/x86/crypto/Makefile               |   3 +
 arch/x86/crypto/polyval-clmulni_asm.S  | 376 +++++++++++++++++++++++++
 arch/x86/crypto/polyval-clmulni_glue.c | 361 ++++++++++++++++++++++++
 crypto/Kconfig                         |  10 +
 4 files changed, 750 insertions(+)
 create mode 100644 arch/x86/crypto/polyval-clmulni_asm.S
 create mode 100644 arch/x86/crypto/polyval-clmulni_glue.c

diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index 2831685adf6f..b9847152acd8 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -69,6 +69,9 @@ libblake2s-x86_64-y := blake2s-core.o blake2s-glue.o
 obj-$(CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL) += ghash-clmulni-intel.o
 ghash-clmulni-intel-y := ghash-clmulni-intel_asm.o ghash-clmulni-intel_glue.o
 
+obj-$(CONFIG_CRYPTO_POLYVAL_CLMUL_NI) += polyval-clmulni.o
+polyval-clmulni-y := polyval-clmulni_asm.o polyval-clmulni_glue.o
+
 obj-$(CONFIG_CRYPTO_CRC32C_INTEL) += crc32c-intel.o
 crc32c-intel-y := crc32c-intel_glue.o
 crc32c-intel-$(CONFIG_64BIT) += crc32c-pcl-intel-asm_64.o
diff --git a/arch/x86/crypto/polyval-clmulni_asm.S b/arch/x86/crypto/polyval-clmulni_asm.S
new file mode 100644
index 000000000000..ad7126d9f0ff
--- /dev/null
+++ b/arch/x86/crypto/polyval-clmulni_asm.S
@@ -0,0 +1,376 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright 2021 Google LLC
+ */
+/*
+ * This is an efficient implementation of POLYVAL using intel PCLMULQDQ-NI
+ * instructions. It works on 8 blocks at a time, by precomputing the first 8
+ * keys powers h^8, ..., h^1 in the POLYVAL finite field. This precomputation
+ * allows us to split finite field multiplication into two steps.
+ *
+ * In the first step, we consider h^i, m_i as normal polynomials of degree less
+ * than 128. We then compute p(x) = h^8m_0 + ... + h^1m_7 where multiplication
+ * is simply polynomial multiplication.
+ *
+ * In the second step, we compute the reduction of p(x) modulo the finite field
+ * modulus g(x) = x^128 + x^127 + x^126 + x^121 + 1.
+ *
+ * This two step process is equivalent to computing h^8m_0 + ... + h^1m_7 where
+ * multiplication is finite field multiplication. The advantage is that the
+ * two-step process  only requires 1 finite field reduction for every 8
+ * polynomial multiplications. Further parallelism is gained by interleaving the
+ * multiplications and polynomial reductions.
+ */
+
+#include <linux/linkage.h>
+#include <asm/frame.h>
+
+#define NUM_PRECOMPUTE_POWERS 8
+
+#define GSTAR %xmm7
+#define PL %xmm8
+#define PH %xmm9
+#define T %xmm10
+#define V %xmm11
+#define LO %xmm12
+#define HI %xmm13
+#define MI %xmm14
+#define SUM %xmm15
+
+#define BLOCKS_LEFT %rdx
+#define MSG %rdi
+#define KEY_POWERS %r10
+#define IDX %r11
+#define TMP %rax
+
+.section    .rodata.cst16.gstar, "aM", @progbits, 16
+.align 16
+
+.Lgstar:
+	.quad 0xc200000000000000, 0xc200000000000000
+
+.text
+
+/*
+ * Performs schoolbook1_iteration on two lists of 128-bit polynomials of length
+ * b pointed to by MSG and KEY_POWERS.
+ */
+.macro schoolbook1 count
+	.set i, 0
+	.rept (\count)
+		schoolbook1_iteration i 0
+		.set i, (i +1)
+	.endr
+.endm
+
+/*
+ * Computes the product of two 128-bit polynomials at the memory locations
+ * specified by (MSG + 16*i) and (KEY_POWERS + 16*i) and XORs the components of the
+ * 256-bit product into LO, MI, HI.
+ *
+ * The multiplication produces four parts:
+ *   LOW: The polynomial given by performing carryless multiplication of the
+ *   bottom 64-bits of each polynomial
+ *   MID1: The polynomial given by performing carryless multiplication of the
+ *   bottom 64-bits of the first polynomial and the top 64-bits of the second
+ *   MID2: The polynomial given by performing carryless multiplication of the
+ *   bottom 64-bits of the second polynomial and the top 64-bits of the first
+ *   HIGH: The polynomial given by performing carryless multiplication of the
+ *   top 64-bits of each polynomial
+ *
+ * We compute:
+ *  LO ^= LOW
+ *  MI ^= MID1 ^ MID2
+ *  HI ^= HIGH
+ *
+ * Later, the 256-bit result can be extracted as:
+ *   [HI_H : HI_L ^ MI_H : LO_H ^ MI_L : LO_L]
+ * This step is done when computing the polynomial reduction for efficiency
+ * reasons.
+ *
+ * If xor_sum == 1, then also XOR the value of SUM into m_0.  This avoids an
+ * extra multiplication of SUM and h^N.
+ */
+.macro schoolbook1_iteration i xor_sum
+	movups (16*\i)(MSG), %xmm0
+	.if (\i == 0 && \xor_sum == 1)
+		pxor SUM, %xmm0
+	.endif
+	vpclmulqdq $0x00, (16*\i)(KEY_POWERS), %xmm0, %xmm2
+	vpclmulqdq $0x01, (16*\i)(KEY_POWERS), %xmm0, %xmm1
+	vpclmulqdq $0x11, (16*\i)(KEY_POWERS), %xmm0, %xmm3
+	vpclmulqdq $0x10, (16*\i)(KEY_POWERS), %xmm0, %xmm4
+	vpxor %xmm2, LO, LO
+	vpxor %xmm1, MI, MI
+	vpxor %xmm4, MI, MI
+	vpxor %xmm3, HI, HI
+.endm
+
+/*
+ * Performs the same computation as schoolbook1_iteration, except we expect the
+ * arguments to already be loaded into xmm0 and xmm1.
+ */
+.macro schoolbook1_noload
+	vpclmulqdq $0x01, %xmm0, %xmm1, %xmm2
+	vpclmulqdq $0x00, %xmm0, %xmm1, %xmm3
+	vpclmulqdq $0x11, %xmm0, %xmm1, %xmm4
+	vpclmulqdq $0x10, %xmm0, %xmm1, %xmm5
+	vpxor %xmm2, MI, MI
+	vpxor %xmm3, LO, LO
+	vpxor %xmm5, MI, MI
+	vpxor %xmm4, HI, HI
+.endm
+
+/*
+ * Computes the 256-bit polynomial represented by LO, HI, MI. Stores
+ * the result in PL, PH.
+ *   [PH :: PL] = [HI_H : HI_L ^ MI_H :: LO_H ^ MI_L : LO_L]
+ */
+.macro schoolbook2
+	vpslldq $8, MI, PL
+	vpsrldq $8, MI, PH
+	pxor LO, PL
+	pxor HI, PH
+.endm
+
+/*
+ * Computes the 128-bit reduction of PL, PH. Stores the result in PH.
+ *
+ * This macro computes p(x) mod g(x) where p(x) is in montgomery form and g(x) =
+ * x^128 + x^127 + x^126 + x^121 + 1.
+ *
+ * We have a 256-bit polynomial P_3 : P_2 : P_1 : P_0 that is the product of
+ * two 128-bit polynomials in Montgomery form.  We need to reduce it mod g(x).
+ * Also, since polynomials in Montgomery form have an "extra" factor of x^128,
+ * this product has two extra factors of x^128.  To get it back into Montgomery
+ * form, we need to remove one of these factors by dividing by x^128.
+ *
+ * To accomplish both of these goals, we add multiples of g(x) that cancel out
+ * the low 128 bits P_1 : P_0, leaving just the high 128 bits. Since the low
+ * bits are zero, the polynomial division by x^128 can be done by right shifting.
+ *
+ * Since the only nonzero term in the low 64 bits of g(x) is the constant term,
+ * the multiple of g(x) needed to cancel out P_0 is P_0 * g(x).  The CPU can
+ * only do 64x64 bit multiplications, so split P_0 * g(x) into x^128 * P_0 +
+ * x^64 g*(x) * P_0 + P_0, where g*(x) is bits 64-127 of g(x).  Adding this to
+ * the original polynomial gives P_3 : P_2 + P_0 + T_1 : P_1 + T_0 : 0, where T
+ * = T_1 : T_0 = g*(x) * P0.  Thus, bits 0-63 got "folded" into bits 64-191.
+ *
+ * Repeating this same process on the next 64 bits "folds" bits 64-127 into bits
+ * 128-255, giving the answer in bits 128-255. This time, we need to cancel P_1
+ * + T_0 in bits 64-127. The multiple of g(x) required is (P_1 + T_0) * g(x) *
+ * x^64. Adding this to our previous computation gives P_3 + P_1 + T_0 + V_1 :
+ * P_2 + P_0 + T_1 + V_0 : 0 : 0, where V = V_1 : V_0 = g*(x) * (P_1 + T_0).
+ *
+ * So our final computation is:
+ *   T = T_1 : T_0 = g*(x) * P_0
+ *   V = V_1 : V_0 = g*(x) * (T_0 ^ P_1)
+ *   p(x) / x^{128} mod g(x) = P_3 ^ P_1 ^ V_1 ^ T_0 : P_2 ^ P_0 ^ V_0 ^ T_1
+ *
+ * The implementation below saves a XOR instruction by computing P_1 ^ T_0 : P_0
+ * ^ T_1 and XORing into PH, rather than directly XORing P_1 : P_0, T_0 : T1
+ * into PH.  This allows us to reuse P_1 ^ T_0 when computing V.
+ */
+.macro montgomery_reduction
+	movdqa PL, T
+	pclmulqdq $0x00, GSTAR, T # T = [P_0 * g*(x)]
+	pshufd $0b01001110, T, V # V = [T_0 : T_1]
+	pxor V, PL # PL = [P_1 ^ T_0 : P_0 ^ T_1]
+	pxor PL, PH # PH = [P_1 ^ T_0 ^ P_3 : P_0 ^ T_1 ^ P_2]
+	pclmulqdq $0x11, GSTAR, PL # PL = [(P_1 ^ T_0) * g*(x)]
+	pxor PL, PH
+.endm
+
+/*
+ * Compute schoolbook multiplication for 8 blocks
+ * m_0h^8 + ... + m_7h^1
+ *
+ * If reduce is set, also computes the montgomery reduction of the
+ * previous full_stride call and XORs with the first message block.
+ * (m_0 + REDUCE(PL, PH))h^8 + ... + m_7h^1.
+ * I.e., the first multiplication uses m_0 + REDUCE(PL, PH) instead of m_0.
+ *
+ * Sets PL, PH
+ * Clobbers LO, HI, MI
+ *
+ */
+.macro full_stride reduce
+	mov %rsi, KEY_POWERS
+	pxor LO, LO
+	pxor HI, HI
+	pxor MI, MI
+
+	schoolbook1_iteration 7 0
+	.if (\reduce)
+		movdqa PL, T
+	.endif
+
+	schoolbook1_iteration 6 0
+	.if (\reduce)
+		pclmulqdq $0x00, GSTAR, T # T = [X0 * g*(x)]
+	.endif
+
+	schoolbook1_iteration 5 0
+	.if (\reduce)
+		pshufd $0b01001110, T, V # V = [T0 : T1]
+	.endif
+
+	schoolbook1_iteration 4 0
+	.if (\reduce)
+		pxor V, PL # PL = [X1 ^ T0 : X0 ^ T1]
+	.endif
+
+	schoolbook1_iteration 3 0
+	.if (\reduce)
+		pxor PL, PH # PH = [X1 ^ T0 ^ X3 : X0 ^ T1 ^ X2]
+	.endif
+
+	schoolbook1_iteration 2 0
+	.if (\reduce)
+		pclmulqdq $0x11, GSTAR, PL # PL = [X1 ^ T0 * g*(x)]
+	.endif
+
+	schoolbook1_iteration 1 0
+	.if (\reduce)
+		pxor PL, PH
+		movdqa PH, SUM
+	.endif
+
+	schoolbook1_iteration 0 1
+
+	addq $(8*16), MSG
+	addq $(8*16), KEY_POWERS
+	schoolbook2
+.endm
+
+/*
+ * Compute poly on window size of %rdx blocks
+ * 0 < %rdx < NUM_PRECOMPUTE_POWERS
+ */
+.macro partial_stride
+	pxor LO, LO
+	pxor HI, HI
+	pxor MI, MI
+	mov BLOCKS_LEFT, TMP
+	shlq $4, TMP
+	mov %rsi, KEY_POWERS
+	addq $(16*NUM_PRECOMPUTE_POWERS), KEY_POWERS
+	subq TMP, KEY_POWERS
+	# Multiply sum by h^N
+	movups (KEY_POWERS), %xmm0
+	movdqa SUM, %xmm1
+	schoolbook1_noload
+	schoolbook2
+	montgomery_reduction
+	movdqa PH, SUM
+	pxor LO, LO
+	pxor HI, HI
+	pxor MI, MI
+	xor IDX, IDX
+.LloopPartial:
+	cmpq BLOCKS_LEFT, IDX # IDX < rdx
+	jae .LloopExitPartial
+
+	movq BLOCKS_LEFT, TMP
+	subq IDX, TMP # TMP = rdx - IDX
+
+	cmp $4, TMP # TMP < 4 ?
+	jl .Llt4Partial
+	schoolbook1 4
+	addq $4, IDX
+	addq $(4*16), MSG
+	addq $(4*16), KEY_POWERS
+	jmp .LoutPartial
+.Llt4Partial:
+	cmp $3, TMP # TMP < 3 ?
+	jl .Llt3Partial
+	schoolbook1 3
+	addq $3, IDX
+	addq $(3*16), MSG
+	addq $(3*16), KEY_POWERS
+	jmp .LoutPartial
+.Llt3Partial:
+	cmp $2, TMP # TMP < 2 ?
+	jl .Llt2Partial
+	schoolbook1 2
+	addq $2, IDX
+	addq $(2*16), MSG
+	addq $(2*16), KEY_POWERS
+	jmp .LoutPartial
+.Llt2Partial:
+	schoolbook1 1 # TMP < 1 ?
+	addq $1, IDX
+	addq $(1*16), MSG
+	addq $(1*16), KEY_POWERS
+.LoutPartial:
+	jmp .LloopPartial
+.LloopExitPartial:
+	schoolbook2
+	montgomery_reduction
+	pxor PH, SUM
+.endm
+
+/*
+ * Perform montgomery multiplication in GF(2^128) and store result in op1.
+ *
+ * Computes op1*op2*x^{-128} mod x^128 + x^127 + x^126 + x^121 + 1
+ * If op1, op2 are in montgomery form,  this computes the montgomery
+ * form of op1*op2.
+ *
+ * void clmul_polyval_mul(u8 *op1, const u8 *op2);
+ */
+SYM_FUNC_START(clmul_polyval_mul)
+	FRAME_BEGIN
+	vmovdqa .Lgstar(%rip), GSTAR
+	pxor LO, LO
+	pxor HI, HI
+	pxor MI, MI
+	movups (%rdi), %xmm0
+	movups (%rsi), %xmm1
+	schoolbook1_noload
+	schoolbook2
+	montgomery_reduction
+	movups PH, (%rdi)
+	FRAME_END
+	ret
+SYM_FUNC_END(clmul_polyval_mul)
+
+/*
+ * Perform polynomial evaluation as specified by POLYVAL.  This computes:
+ * 	h^n * accumulator + h^n * m_0 + ... + h^1 * m_{n-1}
+ * where n=nblocks, h is the hash key, and m_i are the message blocks.
+ *
+ * rdi - pointer to message blocks
+ * rsi - pointer to precomputed key powers h^8 ... h^1
+ * rdx - number of blocks to hash
+ * rcx - pointer to the accumulator
+ *
+ * void clmul_polyval_update(const u8 *in, const struct polyval_ctx *ctx,
+ *			     size_t nblocks, u8 *accumulator);
+ */
+SYM_FUNC_START(clmul_polyval_update)
+	FRAME_BEGIN
+	vmovdqa .Lgstar(%rip), GSTAR
+	movups (%rcx), SUM
+	cmpq $NUM_PRECOMPUTE_POWERS, BLOCKS_LEFT
+	jb .LstrideLoopExit
+	full_stride 0
+	subq $NUM_PRECOMPUTE_POWERS, BLOCKS_LEFT
+.LstrideLoop:
+	cmpq $NUM_PRECOMPUTE_POWERS, BLOCKS_LEFT
+	jb .LstrideLoopExitReduce
+	full_stride 1
+	subq $NUM_PRECOMPUTE_POWERS, BLOCKS_LEFT
+	jmp .LstrideLoop
+.LstrideLoopExitReduce:
+	montgomery_reduction
+	movdqa PH, SUM
+.LstrideLoopExit:
+	test BLOCKS_LEFT, BLOCKS_LEFT
+	je .LskipPartial
+	partial_stride
+.LskipPartial:
+	movups SUM, (%rcx)
+	FRAME_END
+	ret
+SYM_FUNC_END(clmul_polyval_update)
diff --git a/arch/x86/crypto/polyval-clmulni_glue.c b/arch/x86/crypto/polyval-clmulni_glue.c
new file mode 100644
index 000000000000..ae73750ba059
--- /dev/null
+++ b/arch/x86/crypto/polyval-clmulni_glue.c
@@ -0,0 +1,361 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Accelerated POLYVAL implementation with Intel PCLMULQDQ-NI
+ * instructions. This file contains glue code.
+ *
+ * Copyright (c) 2007 Nokia Siemens Networks - Mikko Herranen <mh1@iki.fi>
+ * Copyright (c) 2009 Intel Corp.
+ *   Author: Huang Ying <ying.huang@intel.com>
+ * Copyright 2021 Google LLC
+ */
+/*
+ * Glue code based on ghash-clmulni-intel_glue.c.
+ *
+ * This implementation of POLYVAL uses montgomery multiplication
+ * accelerated by PCLMULQDQ-NI to implement the finite field
+ * operations.
+ *
+ */
+
+#include <crypto/algapi.h>
+#include <crypto/cryptd.h>
+#include <crypto/gf128mul.h>
+#include <crypto/internal/hash.h>
+#include <crypto/internal/simd.h>
+#include <crypto/polyval.h>
+#include <linux/crypto.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <asm/cpu_device_id.h>
+#include <asm/simd.h>
+
+#define NUM_PRECOMPUTE_POWERS	8
+
+struct polyval_async_ctx {
+	struct cryptd_ahash *cryptd_tfm;
+};
+
+struct polyval_ctx {
+	/*
+	 * These powers must be in the order h^8, ..., h^1.
+	 */
+	u8 key_powers[NUM_PRECOMPUTE_POWERS][POLYVAL_BLOCK_SIZE];
+};
+
+struct polyval_desc_ctx {
+	u8 buffer[POLYVAL_BLOCK_SIZE];
+	u32 bytes;
+};
+
+asmlinkage void clmul_polyval_update(const u8 *in, struct polyval_ctx *keys,
+				     size_t nblocks, u8 *accumulator);
+asmlinkage void clmul_polyval_mul(u8 *op1, const u8 *op2);
+
+static int polyval_init(struct shash_desc *desc)
+{
+	struct polyval_desc_ctx *dctx = shash_desc_ctx(desc);
+
+	memset(dctx, 0, sizeof(*dctx));
+
+	return 0;
+}
+
+static int polyval_setkey(struct crypto_shash *tfm,
+			const u8 *key, unsigned int keylen)
+{
+	struct polyval_ctx *ctx = crypto_shash_ctx(tfm);
+	int i;
+
+	if (keylen != POLYVAL_BLOCK_SIZE)
+		return -EINVAL;
+
+	memcpy(ctx->key_powers[NUM_PRECOMPUTE_POWERS-1], key,
+	       POLYVAL_BLOCK_SIZE);
+
+	kernel_fpu_begin();
+	for (i = NUM_PRECOMPUTE_POWERS-2; i >= 0; i--) {
+		memcpy(ctx->key_powers[i], key, POLYVAL_BLOCK_SIZE);
+		clmul_polyval_mul(ctx->key_powers[i], ctx->key_powers[i+1]);
+	}
+	kernel_fpu_end();
+
+	return 0;
+}
+
+static int polyval_update(struct shash_desc *desc,
+			 const u8 *src, unsigned int srclen)
+{
+	struct polyval_desc_ctx *dctx = shash_desc_ctx(desc);
+	struct polyval_ctx *ctx = crypto_shash_ctx(desc->tfm);
+	u8 *pos;
+	unsigned int nblocks;
+	int n;
+
+	kernel_fpu_begin();
+	if (dctx->bytes) {
+		n = min(srclen, dctx->bytes);
+		pos = dctx->buffer + POLYVAL_BLOCK_SIZE - dctx->bytes;
+
+		dctx->bytes -= n;
+		srclen -= n;
+
+		while (n--)
+			*pos++ ^= *src++;
+
+		if (!dctx->bytes)
+			clmul_polyval_mul(dctx->buffer,
+				ctx->key_powers[NUM_PRECOMPUTE_POWERS-1]);
+	}
+
+	nblocks = srclen/POLYVAL_BLOCK_SIZE;
+	clmul_polyval_update(src, ctx, nblocks, dctx->buffer);
+	srclen -= nblocks*POLYVAL_BLOCK_SIZE;
+	kernel_fpu_end();
+
+	if (srclen) {
+		dctx->bytes = POLYVAL_BLOCK_SIZE - srclen;
+		src += nblocks*POLYVAL_BLOCK_SIZE;
+		pos = dctx->buffer;
+		while (srclen--)
+			*pos++ ^= *src++;
+	}
+
+	return 0;
+}
+
+static int polyval_final(struct shash_desc *desc, u8 *dst)
+{
+	struct polyval_desc_ctx *dctx = shash_desc_ctx(desc);
+	struct polyval_ctx *ctx = crypto_shash_ctx(desc->tfm);
+
+	if (dctx->bytes) {
+		kernel_fpu_begin();
+		clmul_polyval_mul(dctx->buffer,
+			ctx->key_powers[NUM_PRECOMPUTE_POWERS-1]);
+		kernel_fpu_end();
+	}
+
+	dctx->bytes = 0;
+	memcpy(dst, dctx->buffer, POLYVAL_BLOCK_SIZE);
+
+	return 0;
+}
+
+static struct shash_alg polyval_alg = {
+	.digestsize	= POLYVAL_DIGEST_SIZE,
+	.init		= polyval_init,
+	.update		= polyval_update,
+	.final		= polyval_final,
+	.setkey		= polyval_setkey,
+	.descsize	= sizeof(struct polyval_desc_ctx),
+	.base		= {
+		.cra_name		= "__polyval",
+		.cra_driver_name	= "__polyval-clmulni",
+		.cra_priority		= 0,
+		.cra_flags		= CRYPTO_ALG_INTERNAL,
+		.cra_blocksize		= POLYVAL_BLOCK_SIZE,
+		.cra_ctxsize		= sizeof(struct polyval_ctx),
+		.cra_module		= THIS_MODULE,
+	},
+};
+
+static int polyval_async_init(struct ahash_request *req)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct polyval_async_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct ahash_request *cryptd_req = ahash_request_ctx(req);
+	struct cryptd_ahash *cryptd_tfm = ctx->cryptd_tfm;
+	struct shash_desc *desc = cryptd_shash_desc(cryptd_req);
+	struct crypto_shash *child = cryptd_ahash_child(cryptd_tfm);
+
+	desc->tfm = child;
+	return crypto_shash_init(desc);
+}
+
+static int polyval_async_update(struct ahash_request *req)
+{
+	struct ahash_request *cryptd_req = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct polyval_async_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct cryptd_ahash *cryptd_tfm = ctx->cryptd_tfm;
+	struct shash_desc *desc;
+
+	if (!crypto_simd_usable() ||
+	    (in_atomic() && cryptd_ahash_queued(cryptd_tfm))) {
+		memcpy(cryptd_req, req, sizeof(*req));
+		ahash_request_set_tfm(cryptd_req, &cryptd_tfm->base);
+		return crypto_ahash_update(cryptd_req);
+	}
+	desc = cryptd_shash_desc(cryptd_req);
+
+	return shash_ahash_update(req, desc);
+}
+
+static int polyval_async_final(struct ahash_request *req)
+{
+	struct ahash_request *cryptd_req = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct polyval_async_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct cryptd_ahash *cryptd_tfm = ctx->cryptd_tfm;
+	struct shash_desc *desc;
+
+	if (!crypto_simd_usable() ||
+	    (in_atomic() && cryptd_ahash_queued(cryptd_tfm))) {
+		memcpy(cryptd_req, req, sizeof(*req));
+		ahash_request_set_tfm(cryptd_req, &cryptd_tfm->base);
+		return crypto_ahash_final(cryptd_req);
+	}
+	desc = cryptd_shash_desc(cryptd_req);
+
+	return crypto_shash_final(desc, req->result);
+}
+
+static int polyval_async_import(struct ahash_request *req, const void *in)
+{
+	struct ahash_request *cryptd_req = ahash_request_ctx(req);
+	struct shash_desc *desc = cryptd_shash_desc(cryptd_req);
+	struct polyval_desc_ctx *dctx = shash_desc_ctx(desc);
+
+	polyval_async_init(req);
+	memcpy(dctx, in, sizeof(*dctx));
+	return 0;
+
+}
+
+static int polyval_async_export(struct ahash_request *req, void *out)
+{
+	struct ahash_request *cryptd_req = ahash_request_ctx(req);
+	struct shash_desc *desc = cryptd_shash_desc(cryptd_req);
+	struct polyval_desc_ctx *dctx = shash_desc_ctx(desc);
+
+	memcpy(out, dctx, sizeof(*dctx));
+	return 0;
+
+}
+
+static int polyval_async_digest(struct ahash_request *req)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct polyval_async_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct ahash_request *cryptd_req = ahash_request_ctx(req);
+	struct cryptd_ahash *cryptd_tfm = ctx->cryptd_tfm;
+	struct shash_desc *desc;
+	struct crypto_shash *child;
+
+	if (!crypto_simd_usable() ||
+	    (in_atomic() && cryptd_ahash_queued(cryptd_tfm))) {
+		memcpy(cryptd_req, req, sizeof(*req));
+		ahash_request_set_tfm(cryptd_req, &cryptd_tfm->base);
+		return crypto_ahash_digest(cryptd_req);
+	}
+	desc = cryptd_shash_desc(cryptd_req);
+	child = cryptd_ahash_child(cryptd_tfm);
+
+	desc->tfm = child;
+	return shash_ahash_digest(req, desc);
+}
+
+static int polyval_async_setkey(struct crypto_ahash *tfm, const u8 *key,
+			      unsigned int keylen)
+{
+	struct polyval_async_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct crypto_ahash *child = &ctx->cryptd_tfm->base;
+
+	crypto_ahash_clear_flags(child, CRYPTO_TFM_REQ_MASK);
+	crypto_ahash_set_flags(child, crypto_ahash_get_flags(tfm)
+			       & CRYPTO_TFM_REQ_MASK);
+	return crypto_ahash_setkey(child, key, keylen);
+}
+
+static int polyval_async_init_tfm(struct crypto_tfm *tfm)
+{
+	struct cryptd_ahash *cryptd_tfm;
+	struct polyval_async_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	cryptd_tfm = cryptd_alloc_ahash("__polyval-clmulni",
+					CRYPTO_ALG_INTERNAL,
+					CRYPTO_ALG_INTERNAL);
+	if (IS_ERR(cryptd_tfm))
+		return PTR_ERR(cryptd_tfm);
+	ctx->cryptd_tfm = cryptd_tfm;
+	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
+				 sizeof(struct ahash_request) +
+				 crypto_ahash_reqsize(&cryptd_tfm->base));
+
+	return 0;
+}
+
+static void polyval_async_exit_tfm(struct crypto_tfm *tfm)
+{
+	struct polyval_async_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	cryptd_free_ahash(ctx->cryptd_tfm);
+}
+
+static struct ahash_alg polyval_async_alg = {
+	.init		= polyval_async_init,
+	.update		= polyval_async_update,
+	.final		= polyval_async_final,
+	.setkey		= polyval_async_setkey,
+	.digest		= polyval_async_digest,
+	.export		= polyval_async_export,
+	.import		= polyval_async_import,
+	.halg = {
+		.digestsize	= POLYVAL_DIGEST_SIZE,
+		.statesize = sizeof(struct polyval_desc_ctx),
+		.base = {
+			.cra_name		= "polyval",
+			.cra_driver_name	= "polyval-clmulni",
+			.cra_priority		= 200,
+			.cra_ctxsize		= sizeof(struct polyval_async_ctx),
+			.cra_flags		= CRYPTO_ALG_ASYNC,
+			.cra_blocksize		= POLYVAL_BLOCK_SIZE,
+			.cra_module		= THIS_MODULE,
+			.cra_init		= polyval_async_init_tfm,
+			.cra_exit		= polyval_async_exit_tfm,
+		},
+	},
+};
+
+static const struct x86_cpu_id pcmul_cpu_id[] = {
+	X86_MATCH_FEATURE(X86_FEATURE_PCLMULQDQ, NULL), /* Pickle-Mickle-Duck */
+	{}
+};
+MODULE_DEVICE_TABLE(x86cpu, pcmul_cpu_id);
+
+static int __init polyval_clmulni_mod_init(void)
+{
+	int err;
+
+	if (!x86_match_cpu(pcmul_cpu_id))
+		return -ENODEV;
+
+	err = crypto_register_shash(&polyval_alg);
+	if (err)
+		goto err_out;
+	err = crypto_register_ahash(&polyval_async_alg);
+	if (err)
+		goto err_shash;
+
+	return 0;
+
+err_shash:
+	crypto_unregister_shash(&polyval_alg);
+err_out:
+	return err;
+}
+
+static void __exit polyval_clmulni_mod_exit(void)
+{
+	crypto_unregister_ahash(&polyval_async_alg);
+	crypto_unregister_shash(&polyval_alg);
+}
+
+module_init(polyval_clmulni_mod_init);
+module_exit(polyval_clmulni_mod_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("POLYVAL hash function accelerated by PCLMULQDQ-NI");
+MODULE_ALIAS_CRYPTO("polyval");
+MODULE_ALIAS_CRYPTO("polyval-clmulni");
diff --git a/crypto/Kconfig b/crypto/Kconfig
index aa06af0e0ebe..c6aec88213b1 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -787,6 +787,16 @@ config CRYPTO_POLYVAL
 	  POLYVAL is the hash function used in HCTR2.  It is not a general-purpose
 	  cryptographic hash function.
 
+config CRYPTO_POLYVAL_CLMUL_NI
+	tristate "POLYVAL hash function (CLMUL-NI accelerated)"
+	depends on X86 && 64BIT
+	select CRYPTO_CRYPTD
+	select CRYPTO_POLYVAL
+	help
+	  This is the x86_64 CLMUL-NI accelerated implementation of POLYVAL. It is
+	  used to efficiently implement HCTR2 on x86-64 processors that support
+	  carry-less multiplication instructions.
+
 config CRYPTO_POLY1305
 	tristate "Poly1305 authenticator algorithm"
 	select CRYPTO_HASH
-- 
2.35.1.723.g4982287a31-goog

