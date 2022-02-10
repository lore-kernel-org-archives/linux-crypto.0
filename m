Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84769C43217
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Feb 2022 23:28:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345654AbiBJX2x (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Feb 2022 18:28:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345659AbiBJX2s (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Feb 2022 18:28:48 -0500
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88F3B5F67
        for <linux-crypto@vger.kernel.org>; Thu, 10 Feb 2022 15:28:46 -0800 (PST)
Received: by mail-qv1-xf4a.google.com with SMTP id w14-20020a0cfc4e000000b0042c1ac91249so5129204qvp.4
        for <linux-crypto@vger.kernel.org>; Thu, 10 Feb 2022 15:28:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=uvOO8ZNH1ZfcGkGuvFcfNS7K5FAXvaqzIa8ApkAjUlk=;
        b=KWviO3Q6aZAotjrk9w73/Dg+Jm3U5xwpsluhcSQmxk2NmT7heyhGNqgkvAeD3xVMR2
         ku0pyHpq3/LitKCgEa2Cvyp/VzY7FZD4YM/PMIDnhivFg7yXDtZv79d1dG2WeCaKz3qg
         /pei6XJb2fQvMwF3wytez6tTklLcIRvAa+9a4Gsy5rEaNjVWc5yNq17tduHJuqOxsP3T
         q8+YiybRbvYupGxCALTsdWG8o1FY+nQ75sRXbhFPWVr3Ont3Xu8KXSmtbjwZn53n6S64
         FXyd+mj4TIHs+Bi2KrKoFWcapOzquagxgmwJ+4LQy1+l4e2+EIsU+QJhZfFrohHUDgQX
         ezhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=uvOO8ZNH1ZfcGkGuvFcfNS7K5FAXvaqzIa8ApkAjUlk=;
        b=8OvxNcOCUp0YxAljl2D9MLkRKI/Hdpu2VTNPp8vnkwqfWfUen8z+O+yabjANOtq44Y
         al5gbkg8ZxxNNET+b8HVZYSY3fyajfZOUfKePi0LdfIaJJOf9/uUMeYE8AwNFQTBe/Lr
         D9d/RXY/9pCc51lUauOhb77uWdiszw/eg4Bg3ZHKOSCDLoh3P3TLRUbsrXHl4111HDwZ
         +ovmJXs1YzcLEYWrkNfM3DFxrlvvLJ5GSYMetST3BAUZY3Uz099HesrVBYd3hwr0XYoZ
         JgsIRKOhayyBdDVTd6YfsYxrYtGiZpnoeuEu5l2PxpGaLKZWQIDI6aHIo5yGj8/9j3jV
         jLjg==
X-Gm-Message-State: AOAM533ZxJC69E8cP//tzUC1kE04Ma/mIUW/0QmPNRLnb+dGuFJGLOGq
        pfLRzj36TNc53iKcTC0IQd9Ia9/K00RWf3ym1P1bHxb6rq9i8TjO8FR1VIqPEKiirec6/GoTGK4
        as7teppoLGjoygEcXblyFkpD/TXFWED1FG3iRhYyE11OfwX9hMdI5Bp9Hvov2CANOmFA=
X-Google-Smtp-Source: ABdhPJy1qb2FgD/k24haM+CpfYV7QoTJ0Jaa1kUdux1WeSG+locnVGiQL977gmiAc1sO4farcpPRsVEjZg==
X-Received: from nhuck.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:39cc])
 (user=nhuck job=sendgmr) by 2002:a05:6214:20ca:: with SMTP id
 10mr6898460qve.96.1644535725641; Thu, 10 Feb 2022 15:28:45 -0800 (PST)
Date:   Thu, 10 Feb 2022 23:28:11 +0000
In-Reply-To: <20220210232812.798387-1-nhuck@google.com>
Message-Id: <20220210232812.798387-7-nhuck@google.com>
Mime-Version: 1.0
References: <20220210232812.798387-1-nhuck@google.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [RFC PATCH v2 6/7] crypto: x86/polyval: Add PCLMULQDQ accelerated
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

Changes since v1:
 * Rename C, D, EF to LO, MI, HI
 * Add comments explaining POLYVAL
 * Fix bug in handling of non-block-multiple messages
 * Wrap shash in ahash (as done in ghash)

 arch/x86/crypto/Makefile               |   3 +
 arch/x86/crypto/polyval-clmulni_asm.S  | 414 +++++++++++++++++++++++++
 arch/x86/crypto/polyval-clmulni_glue.c | 365 ++++++++++++++++++++++
 crypto/Kconfig                         |  10 +
 4 files changed, 792 insertions(+)
 create mode 100644 arch/x86/crypto/polyval-clmulni_asm.S
 create mode 100644 arch/x86/crypto/polyval-clmulni_glue.c

diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index ee2df489b0d9..c0f13801afba 100644
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
index 000000000000..bec1a2046b18
--- /dev/null
+++ b/arch/x86/crypto/polyval-clmulni_asm.S
@@ -0,0 +1,414 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright 2021 Google LLC
+ *
+ * Use of this source code is governed by an MIT-style
+ * license that can be found in the LICENSE file or at
+ * https://opensource.org/licenses/MIT.
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
+#define OP1 %rdi
+#define OP2 %r10
+#define IDX %r11
+#define TMP %rax
+
+.section    .rodata.cst16.gstar, "aM", @progbits, 16
+.align 16
+
+Lgstar:
+	.quad 0xc200000000000000, 0xc200000000000000
+
+.text
+
+/*
+ * Performs schoolbook1_iteration on two lists of 128-bit polynomials of length
+ * b pointed to by OP1 and OP2.
+ */
+.macro schoolbook1 b
+	.set by, \b
+	.set i, 0
+	.rept (by)
+		schoolbook1_iteration i 0
+		.set i, (i +1)
+	.endr
+.endm
+
+/*
+ * Computes the product of two 128-bit polynomials at the memory locations
+ * specified by (OP1 + 16*i) and (OP2 + 16*i) and XORs the components of the
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
+ *  Mi ^= MID1 ^ MID2
+ *  Hi ^= HIGH
+ *
+ * Later, the 256-bit result can be extracted as:
+ *   [HI_H : HI_L ^ MI_H : LO_H ^ MI_L : LO_L]
+ * This step is done when computing the polynomial reduction for efficiency
+ * reasons.
+ *
+ * If xor_sum == 1 then XOR the value of SUM into m_0.
+ * This avoids an extra multication of SUM and h^N.
+ */
+.macro schoolbook1_iteration i xor_sum
+	.set i, \i
+	.set xor_sum, \xor_sum
+	movups (16*i)(OP1), %xmm0
+	.if(i == 0 && xor_sum == 1)
+		pxor SUM, %xmm0
+	.endif
+	vpclmulqdq $0x01, (16*i)(OP2), %xmm0, %xmm1
+	vpxor %xmm1, MI, MI
+	vpclmulqdq $0x00, (16*i)(OP2), %xmm0, %xmm2
+	vpxor %xmm2, LO, LO
+	vpclmulqdq $0x11, (16*i)(OP2), %xmm0, %xmm3
+	vpxor %xmm3, HI, HI
+	vpclmulqdq $0x10, (16*i)(OP2), %xmm0, %xmm4
+	vpxor %xmm4, MI, MI
+.endm
+
+/*
+ * Performs the same computation as schoolbook1_iteration, except we expect the
+ * arguments to already be loaded into xmm0 and xmm1.
+ */
+.macro schoolbook1_noload
+	vpclmulqdq $0x01, %xmm0, %xmm1, %xmm2
+	vpxor %xmm2, MI, MI
+	vpclmulqdq $0x00, %xmm0, %xmm1, %xmm3
+	vpxor %xmm3, LO, LO
+	vpclmulqdq $0x11, %xmm0, %xmm1, %xmm4
+	vpxor %xmm4, HI, HI
+	vpclmulqdq $0x10, %xmm0, %xmm1, %xmm5
+	vpxor %xmm5, MI, MI
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
+ * The montgomery form of a polynomial p(x) is p(x)x^{128}. Montgomery reduction
+ * works by simultaneously dividing by x^{128} and computing the modular
+ * reduction.
+ *
+ * Suppose we wish to reduce the montgomery form of p(x) = [P_3 : P_2 : P_1 :
+ * P_0] where P_i is a polynomial of degree at most 64 represented as 64-bits.
+ * Thus we would like to compute:
+ *   p(x) / x^{128} mod g(x)
+ *   = (P_3*x^{192} + P_2*x^{128} + P_1*x^{64} + P_0) / x^{128} mod g(x)
+ *
+ * We would like to divide by x^{128} efficiently. Since P_3*x^{128},
+ * P_2*x^{128} are multiples of x^{128}, we can simply bitshift right by 128.
+ *
+ * We now focus on dividing P_1*x^{64} + P_0 by x^{128}. We do this by making
+ * P_1*x^{64} + P_0 divisble by x^{128} then bitshifting. To add divisibility,
+ * we consider the polynomials mod x^{128}.
+ *
+ * Let c(x) = P_1*x^{64} + P_0.
+ *
+ * Now let m(x) = c(x) mod x^{128}
+ * and
+ * Let z(x) = [c(x) + m(x)g(x)] / x^{128}
+ *
+ * First notice that:
+ * c(x) + m(x)g(x) = c(x) mod g(x).
+ * Furthermore, g(x) mod x^{128} = 1, so we have
+ * c(x) + m(x)g(x) = c(x) + c(x) = 0 (mod x^{128}).
+ *
+ * Thus c(x) + m(x)g(x) is divisible by x^{128} and is equivalent to c(x) mod
+ * g(x).
+ *
+ * In practice we use a slight modification of this idea, by using g*(x) =
+ * x^{63} + x^{62} + x^{57}. This is because we can only multiply 64-bit
+ * polynomials.  Notice that g(x) = x^128 + g*(x)*x^{64} + 1
+ *
+ * We do this by substituting g(x) = x^{128} + g*(x)x^{64} + 1
+ *   z(x) = [c(x) + c(x)*(x^{128} + g*(x)*x^{64} + 1)] / x^{128}
+ *     = [P_1*x^{192} + P_0*x^{128} + P_1*g*(x)x^{128} + P_0*g*(x)*x^{64} z(x)]
+ *     / x^{128}
+ *     = P_1*x^{64} + P_0 + P_1*g*(x) + P_0*g*(x)*x^{-64}
+ *
+ * The only difficulty left in this expression is P_0*g*(x)x^{-64}.
+ * Let t(x) = P_0*g*(x) = [T_1 : T_0]
+ * Notice that we can repeat the above process:
+ *   g(x) mod x^{64} = 1
+ *   m'(x) = t(x) mod x^{64}
+ *   z'(x) = [t(x) + m'(x)g(x)] / x^64
+ * Thus we get
+ *   z'(x) = [t(x) + (x^{128} + g*(x)x^{64} + 1)T_0] / x^64
+ *     = T_1 + T_0*x^{64} + g*(x)*T_0
+ *
+ * Recall that this is only the reduction for [P_1*x^{64} + P_0] / x^{64}. The
+ * full computation we need to make is:
+ *   p(x) / x^{128} = P_3*x^{64} + P_2 + P_1*x^{64} + P_0 + P_1*g*(x) +
+ *   T_1 + T_0*x^{64} + g*(x)*T_0
+ *
+ * Thus we have:
+ *   t(x) = g*(x) * P_0 = [T_1 : T_0]
+ *   v(x) = g*(x) * (T_0 ^ P_1) = [V_1 : V_0]
+ *   p(x) / x^{128} mod g(x) = [P_3 ^ P_1 ^ V_1 ^ T_0 : P_2 ^ P_0 ^ V_0 ^ T_1]
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
+ * M_0h^8 + ... + M_7h^1 (no constant term)
+ *
+ * If reduce is set, computes the montgomery reduction of the
+ * previous full_stride call and XORs with the first message block.
+ * (M_0 + REDUCE(PL, PH))h^8 + ... + M_7h^1 (no constant term)
+ *
+ * Sets PL, PH
+ * Clobbers LO, HI, MI
+ *
+ */
+.macro full_stride reduce
+	.set reduce, \reduce
+	mov %rsi, OP2
+	pxor LO, LO
+	pxor HI, HI
+	pxor MI, MI
+
+	schoolbook1_iteration 7 0
+	.if(reduce)
+		movdqa PL, T
+	.endif
+
+	schoolbook1_iteration 6 0
+	.if(reduce)
+		pclmulqdq $0x00, GSTAR, T # T = [X0 * g*(x)]
+	.endif
+
+	schoolbook1_iteration 5 0
+	.if(reduce)
+		pshufd $0b01001110, T, V # V = [T0 : T1]
+	.endif
+
+	schoolbook1_iteration 4 0
+	.if(reduce)
+		pxor V, PL # PL = [X1 ^ T0 : X0 ^ T1]
+	.endif
+
+	schoolbook1_iteration 3 0
+	.if(reduce)
+		pxor PL, PH # PH = [X1 ^ T0 ^ X3 : X0 ^ T1 ^ X2]
+	.endif
+
+	schoolbook1_iteration 2 0
+	.if(reduce)
+		pclmulqdq $0x11, GSTAR, PL # PL = [X1 ^ T0 * g*(x)]
+	.endif
+
+	schoolbook1_iteration 1 0
+	.if(reduce)
+		pxor PL, PH
+		movdqa PH, SUM
+	.endif
+
+	schoolbook1_iteration 0 1
+
+	addq $(8*16), OP1
+	addq $(8*16), OP2
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
+	mov %rsi, OP2
+	addq $(16*NUM_PRECOMPUTE_POWERS), OP2
+	subq TMP, OP2
+	# Multiply sum by h^N
+	movups (OP2), %xmm0
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
+	addq $(4*16), OP1
+	addq $(4*16), OP2
+	jmp .LoutPartial
+.Llt4Partial:
+	cmp $3, TMP # TMP < 3 ?
+	jl .Llt3Partial
+	schoolbook1 3
+	addq $3, IDX
+	addq $(3*16), OP1
+	addq $(3*16), OP2
+	jmp .LoutPartial
+.Llt3Partial:
+	cmp $2, TMP # TMP < 2 ?
+	jl .Llt2Partial
+	schoolbook1 2
+	addq $2, IDX
+	addq $(2*16), OP1
+	addq $(2*16), OP2
+	jmp .LoutPartial
+.Llt2Partial:
+	schoolbook1 1 # TMP < 1 ?
+	addq $1, IDX
+	addq $(1*16), OP1
+	addq $(1*16), OP2
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
+	vmovdqa Lgstar(%rip), GSTAR
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
+ * Perform polynomial evaluation as specified by POLYVAL. If nblocks = k, this
+ * routine multiplies the value stored at accumulator by h^k and XORs the
+ * evaluated polynomial into it.
+ *
+ * Computes h^k * accumulator + h^kM_0 + ... + h^1M_{k-1} (No constant term)
+ *
+ * rdi (OP1) - pointer to message blocks
+ * rsi - pointer to precomputed key struct
+ * rdx - number of blocks to hash
+ * rcx - location to XOR with evaluated polynomial
+ *
+ * void clmul_polyval_update(const u8 *in, const struct polyhash_ctx* ctx,
+ *			     size_t nblocks, u8* accumulator);
+ */
+SYM_FUNC_START(clmul_polyval_update)
+	FRAME_BEGIN
+	vmovdqa Lgstar(%rip), GSTAR
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
index 000000000000..78cbb19658ac
--- /dev/null
+++ b/arch/x86/crypto/polyval-clmulni_glue.c
@@ -0,0 +1,365 @@
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
+#include <linux/crypto.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <asm/cpu_device_id.h>
+#include <asm/simd.h>
+
+#define POLYVAL_BLOCK_SIZE	16
+#define POLYVAL_DIGEST_SIZE	16
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
+	u128 key_powers[NUM_PRECOMPUTE_POWERS];
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
+	BUILD_BUG_ON(sizeof(u128) != POLYVAL_BLOCK_SIZE);
+
+	memcpy(&ctx->key_powers[NUM_PRECOMPUTE_POWERS-1], key, sizeof(u128));
+
+	kernel_fpu_begin();
+	for (i = NUM_PRECOMPUTE_POWERS-2; i >= 0; i--) {
+		memcpy(&ctx->key_powers[i], key, sizeof(u128));
+		clmul_polyval_mul((u8 *)&ctx->key_powers[i],
+				  (u8 *)&ctx->key_powers[i+1]);
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
+	u8 *dst = dctx->buffer;
+	u8 *pos;
+	unsigned int nblocks;
+	int n;
+
+	kernel_fpu_begin();
+	if (dctx->bytes) {
+		n = min(srclen, dctx->bytes);
+		pos = dst + POLYVAL_BLOCK_SIZE - dctx->bytes;
+
+		dctx->bytes -= n;
+		srclen -= n;
+
+		while (n--)
+			*pos++ ^= *src++;
+
+		if (!dctx->bytes)
+			clmul_polyval_mul(dst,
+				(u8 *)&ctx->key_powers[NUM_PRECOMPUTE_POWERS-1]);
+	}
+
+	nblocks = srclen/POLYVAL_BLOCK_SIZE;
+	clmul_polyval_update(src, ctx, nblocks, dst);
+	srclen -= nblocks*POLYVAL_BLOCK_SIZE;
+	kernel_fpu_end();
+
+	if (srclen) {
+		dctx->bytes = POLYVAL_BLOCK_SIZE - srclen;
+		src += nblocks*POLYVAL_BLOCK_SIZE;
+		pos = dst;
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
+	u8 *buf = dctx->buffer;
+
+	if (dctx->bytes) {
+		kernel_fpu_begin();
+		clmul_polyval_mul((u8 *)buf,
+			(u8 *)&ctx->key_powers[NUM_PRECOMPUTE_POWERS-1]);
+		kernel_fpu_end();
+	}
+
+	dctx->bytes = 0;
+	memcpy(dst, buf, POLYVAL_BLOCK_SIZE);
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
+		.cra_driver_name	= "__polyval-pclmulqdqni",
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
+	cryptd_tfm = cryptd_alloc_ahash("__polyval-pclmulqdqni",
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
+static int __init polyval_pclmulqdqni_mod_init(void)
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
+static void __exit polyval_pclmulqdqni_mod_exit(void)
+{
+	crypto_unregister_ahash(&polyval_async_alg);
+	crypto_unregister_shash(&polyval_alg);
+}
+
+module_init(polyval_pclmulqdqni_mod_init);
+module_exit(polyval_pclmulqdqni_mod_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("POLYVAL hash function accelerated by PCLMULQDQ-NI");
+MODULE_ALIAS_CRYPTO("polyval");
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 2a9029f51caf..b539a5bdc45e 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -773,12 +773,22 @@ config CRYPTO_GHASH
 
 config CRYPTO_POLYVAL
 	tristate
+	select CRYPTO_CRYPTD
 	select CRYPTO_GF128MUL
 	select CRYPTO_HASH
 	help
 	  POLYVAL is the hash function used in HCTR2.  It is not a general-purpose
 	  cryptographic hash function.
 
+config CRYPTO_POLYVAL_CLMUL_NI
+	tristate "POLYVAL hash function (CLMUL-NI accelerated)"
+	depends on X86 && 64BIT
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
2.35.1.265.g69c8d7142f-goog

