Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D7FDC433FE
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Mar 2022 23:01:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352468AbiCOXCV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 15 Mar 2022 19:02:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352481AbiCOXCT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Mar 2022 19:02:19 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 433215D66B
        for <linux-crypto@vger.kernel.org>; Tue, 15 Mar 2022 16:01:00 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-2d07ae11467so3785847b3.12
        for <linux-crypto@vger.kernel.org>; Tue, 15 Mar 2022 16:01:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=0FtnjqSXTwq44TeiiLB6nV54vg2mRQ4QWwcc+7GrBec=;
        b=T9G0nH4M4nQIo/mGvex2+gPae//GeCXBLs3roLPnYmHH4Z1v3lTkkIwits3sd4n7rK
         KxjlxZyVMQVKNG1zRyiGZNZEqeiJ3Fd+JHlIUX5hwGUZ8seonX9u06ZXW1Xwa0J/WAs5
         PnnyvwMMTG+12+GMx5tt99HyfCXgn6BuAAeEjG14jloaFX0i6O+VHo16gj3+XR1ozLuI
         AYJutuDii3PXe8s+9GJlo5A/VpPpVXy5DbbMmWpG5xLJOTbcTnVRlYv0+HqltJt7qjQo
         n0D2wpDMF1shVnpZUzbhWzq9VDCDRTKiGMFZx/nD7oow3cSvmhmKDVs3ZIzyH9hlwAI4
         XIwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=0FtnjqSXTwq44TeiiLB6nV54vg2mRQ4QWwcc+7GrBec=;
        b=cN7Hii0ZqifW64TFNIog5GchJJVJVi1Vbbz0lmWHESFD16x/fYWW05eLTT+P4ov48d
         VhCDD/9xvt3jjbkGj6BVAwvyFjK98rrgvOrHii37t+WgG+Ha9Bga05XeaT8XqcXqXq3S
         B3cewZ7SQJ66pqNQvBJpIxjXeBBqVyIro6MJHhut5omuMM9XnktG7+dCKgEGA2jxcHQH
         lv+/sBpZjiFcowb8ai7FbcWVt4U+Xb+N6kxQEvP+bvF90UBvKfPDkfGu6ZzhbfFxGNgJ
         bhPxHakrm6zBB/K/ttzPVAFa5+GZsO60ChD33DQBb9FdxLuJQ8Ou9fJlyqaDReRU5tm8
         dk/g==
X-Gm-Message-State: AOAM533Qm8BDwLSv/cQWqdUcNC4XIpSlV7STw4h0uEKheEvkiJ0o6Y+/
        w7vJbcIapMyhiqoLgdJE6zy7heQbIrNt5ZThKIIDYzSkOtg1iwYA294p3efXxLXfl3Zz72nFCZ7
        ld34N3VKap8eWo7oG2PUEuKvvfW3sEHEVIzS9UmFZz5CohiOI4yghTjS0v4Xs3zE2tRg=
X-Google-Smtp-Source: ABdhPJxqwICWnAZ1Y4TayEZVrZ5n/LFrSJh6CoRp7sqGhJxzXt5Ngyx+w52nN//a6qv0KIHjQny6jTvUuQ==
X-Received: from nhuck.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:39cc])
 (user=nhuck job=sendgmr) by 2002:a81:6c08:0:b0:2dc:23b:f9e3 with SMTP id
 h8-20020a816c08000000b002dc023bf9e3mr27471831ywc.287.1647385259348; Tue, 15
 Mar 2022 16:00:59 -0700 (PDT)
Date:   Tue, 15 Mar 2022 23:00:34 +0000
In-Reply-To: <20220315230035.3792663-1-nhuck@google.com>
Message-Id: <20220315230035.3792663-8-nhuck@google.com>
Mime-Version: 1.0
References: <20220315230035.3792663-1-nhuck@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v3 7/8] crypto: arm64/polyval: Add PMULL accelerated
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

Add hardware accelerated version of POLYVAL for ARM64 CPUs with
Crypto Extension support.

This implementation is accelerated using PMULL instructions to perform
the finite field computations.  For added efficiency, 8 blocks of the
message are processed simultaneously by precomputing the first 8
powers of the key.

Karatsuba multiplication is used instead of Schoolbook multiplication
because it was found to be slightly faster on ARM64 CPUs.  Montgomery
reduction must be used instead of Barrett reduction due to the
difference in modulus between POLYVAL's field and other finite fields.

Signed-off-by: Nathan Huckleberry <nhuck@google.com>
---
 arch/arm64/crypto/Kconfig           |   7 +
 arch/arm64/crypto/Makefile          |   3 +
 arch/arm64/crypto/polyval-ce-core.S | 372 ++++++++++++++++++++++++++++
 arch/arm64/crypto/polyval-ce-glue.c | 363 +++++++++++++++++++++++++++
 4 files changed, 745 insertions(+)
 create mode 100644 arch/arm64/crypto/polyval-ce-core.S
 create mode 100644 arch/arm64/crypto/polyval-ce-glue.c

diff --git a/arch/arm64/crypto/Kconfig b/arch/arm64/crypto/Kconfig
index 897f9a4b5b67..f7fbe8637e5c 100644
--- a/arch/arm64/crypto/Kconfig
+++ b/arch/arm64/crypto/Kconfig
@@ -60,6 +60,13 @@ config CRYPTO_GHASH_ARM64_CE
 	select CRYPTO_GF128MUL
 	select CRYPTO_LIB_AES
 
+config CRYPTO_POLYVAL_ARM64_CE
+	tristate "POLYVAL using ARMv8 Crypto Extensions (for HCTR2)"
+	depends on KERNEL_MODE_NEON
+	select CRYPTO_CRYPTD
+	select CRYPTO_HASH
+	select CRYPTO_POLYVAL
+
 config CRYPTO_CRCT10DIF_ARM64_CE
 	tristate "CRCT10DIF digest algorithm using PMULL instructions"
 	depends on KERNEL_MODE_NEON && CRC_T10DIF
diff --git a/arch/arm64/crypto/Makefile b/arch/arm64/crypto/Makefile
index 09a805cc32d7..53f9af962b86 100644
--- a/arch/arm64/crypto/Makefile
+++ b/arch/arm64/crypto/Makefile
@@ -26,6 +26,9 @@ sm4-ce-y := sm4-ce-glue.o sm4-ce-core.o
 obj-$(CONFIG_CRYPTO_GHASH_ARM64_CE) += ghash-ce.o
 ghash-ce-y := ghash-ce-glue.o ghash-ce-core.o
 
+obj-$(CONFIG_CRYPTO_POLYVAL_ARM64_CE) += polyval-ce.o
+polyval-ce-y := polyval-ce-glue.o polyval-ce-core.o
+
 obj-$(CONFIG_CRYPTO_CRCT10DIF_ARM64_CE) += crct10dif-ce.o
 crct10dif-ce-y := crct10dif-ce-core.o crct10dif-ce-glue.o
 
diff --git a/arch/arm64/crypto/polyval-ce-core.S b/arch/arm64/crypto/polyval-ce-core.S
new file mode 100644
index 000000000000..9c0fba11716c
--- /dev/null
+++ b/arch/arm64/crypto/polyval-ce-core.S
@@ -0,0 +1,372 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Implementation of POLYVAL using ARMv8 Crypto Extensions.
+ *
+ * Copyright 2021 Google LLC
+ */
+/*
+ * This is an efficient implementation of POLYVAL using ARMv8 Crypto Extensions
+ * It works on 8 blocks at a time, by precomputing the first 8 keys powers h^8,
+ * ..., h^1 in the POLYVAL finite field. This precomputation allows us to split
+ * finite field multiplication into two steps.
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
+#define NUM_PRECOMPUTE_POWERS 8
+
+BLOCKS_LEFT	.req	x2
+KEY_START	.req	x10
+EXTRA_BYTES	.req	x11
+IND	.req	x12
+TMP	.req	x13
+PARTIAL_LEFT	.req	x14
+
+M0	.req	v0
+M1	.req	v1
+M2	.req	v2
+M3	.req	v3
+M4	.req	v4
+M5	.req	v5
+M6	.req	v6
+M7	.req	v7
+KEY8	.req	v8
+KEY7	.req	v9
+KEY6	.req	v10
+KEY5	.req	v11
+KEY4	.req	v12
+KEY3	.req	v13
+KEY2	.req	v14
+KEY1	.req	v15
+PL	.req	v16
+PH	.req	v17
+T	.req	v18
+V	.req	v19
+LO	.req	v20
+MI	.req	v21
+HI	.req	v22
+SUM	.req	v23
+GSTAR	.req	v24
+
+	.text
+	.align	4
+
+	.arch	armv8-a+crypto
+	.align	4
+
+.Lgstar:
+	.quad	0xc200000000000000, 0xc200000000000000
+
+/*
+ * Computes the product of two 128-bit polynomials in X and Y and XORs the
+ * components of the 256-bit product into LO, MI, HI.
+ *
+ * The multiplication produces four parts:
+ *   LOW: The polynomial given by performing carryless multiplication of X_L and
+ *   Y_L
+ *   MID: The polynomial given by performing carryless multiplication of (X_L ^
+ *   X_H) and (Y_L ^ Y_H)
+ *   HIGH: The polynomial given by performing carryless multiplication of X_H
+ *   and Y_H
+ *
+ * We compute:
+ *  LO ^= LOW
+ *  MI ^= MID
+ *  HI ^= HIGH
+ *
+ * Later, the 256-bit result can be extracted as:
+ *   [HI_H : HI_L ^ HI_H ^ MI_H ^ LO_H :: LO_H ^ HI_L ^ MI_L ^ LO_L : LO_L]
+ * This step is done when computing the polynomial reduction for efficiency
+ * reasons.
+ */
+.macro karatsuba1 X Y
+	X .req \X
+	Y .req \Y
+	ext	v25.16b, X.16b, Y.16b, #8
+	ext	v26.16b, Y.16b, Y.16b, #8
+	eor	v25.16b, v25.16b, X.16b
+	eor	v26.16b, v26.16b, Y.16b
+	pmull	v27.1q, v25.1d, v26.1d
+	pmull2	v28.1q, X.2d, Y.2d
+	pmull	v29.1q, X.1d, Y.1d
+	eor	HI.16b, HI.16b, v27.16b
+	eor	LO.16b, LO.16b, v28.16b
+	eor	MI.16b, MI.16b, v29.16b
+	.unreq X
+	.unreq Y
+.endm
+
+/*
+ * Computes the 256-bit polynomial represented by LO, HI, MI. Stores
+ * the result in PL, PH.
+ *   [PH :: PL] = [HI_H : HI_L ^ HI_H ^ MI_H ^ LO_H :: LO_H ^ HI_L ^ MI_L ^ LO_L
+ *   : LO_L]
+ */
+.macro karatsuba2
+	ext	v4.16b, MI.16b, LO.16b, #8
+	eor	HI.16b, HI.16b, v4.16b //[HI1 ^ LO0 : HI0 ^ MI1]
+	eor	v4.16b, LO.16b, MI.16b //[LO1 ^ MI1 : LO0 ^ MI0]
+	//[LO0 ^ LO1 ^ MI1 ^ HI1 : MI1 ^ LO0 ^ MI0 ^ HI0]
+	eor	v4.16b, HI.16b, v4.16b
+	ext	LO.16b, LO.16b, LO.16b, #8 // [LO0 : LO1]
+	ext	MI.16b, MI.16b, MI.16b, #8 // [MI0 : MI1]
+	ext	PH.16b, v4.16b, LO.16b, #8 //[LO1 : LO1 ^ MI1 ^ HI1 ^ LO0]
+	ext	PL.16b, MI.16b, v4.16b, #8 //[MI1 ^ LO0 ^ MI0 ^ HI0 : MI0]
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
+ * ^ T_1 and XORing it into V, rather than directly XORing P_1 : P_0, T_0 : T1
+ * into PH.  This allows us to reuse P_1 ^ T_0 when computing V.
+ */
+.macro montgomery_reduction
+	pmull	T.1q, GSTAR.1d, PL.1d
+	ext	T.16b, T.16b, T.16b, #8
+	eor	PL.16b, PL.16b, T.16b
+	pmull2	V.1q, GSTAR.2d, PL.2d
+	eor	V.16b, PL.16b, V.16b
+	eor	PH.16b, PH.16b, V.16b
+.endm
+
+/*
+ * Compute Polyval on 8 blocks.
+ *
+ * If reduce is set, also computes the montgomery reduction of the
+ * previous full_stride call and XORs with the first message block.
+ * (m_0 + REDUCE(PL, PH))h^8 + ... + m_7h^1.
+ * I.e., the first multiplication uses m_0 + REDUCE(PL, PH) instead of m_0.
+ *
+ * Sets PL, PH.
+ */
+.macro full_stride reduce
+	eor		LO.16b, LO.16b, LO.16b
+	eor		MI.16b, MI.16b, MI.16b
+	eor		HI.16b, HI.16b, HI.16b
+
+	ld1		{M0.16b, M1.16b, M2.16b, M3.16b}, [x0], #64
+	ld1		{M4.16b, M5.16b, M6.16b, M7.16b}, [x0], #64
+
+	karatsuba1 M7 KEY1
+	.if (\reduce)
+	pmull	T.1q, GSTAR.1d, PL.1d
+	.endif
+
+	karatsuba1 M6 KEY2
+	.if (\reduce)
+	ext	T.16b, T.16b, T.16b, #8
+	.endif
+
+	karatsuba1 M5 KEY3
+	.if (\reduce)
+	eor	PL.16b, PL.16b, T.16b
+	.endif
+
+	karatsuba1 M4 KEY4
+	.if (\reduce)
+	pmull2	V.1q, GSTAR.2d, PL.2d
+	.endif
+
+	karatsuba1 M3 KEY5
+	.if (\reduce)
+	eor	V.16b, PL.16b, V.16b
+	.endif
+
+	karatsuba1 M2 KEY6
+	.if (\reduce)
+	eor	PH.16b, PH.16b, V.16b
+	.endif
+
+	karatsuba1 M1 KEY7
+	.if (\reduce)
+	mov	SUM.16b, PH.16b
+	.endif
+	eor	M0.16b, M0.16b, SUM.16b
+
+	karatsuba1 M0 KEY8
+
+	karatsuba2
+.endm
+
+/*
+ * Handle any extra blocks before
+ * full_stride loop.
+ */
+.macro partial_stride
+	eor		LO.16b, LO.16b, LO.16b
+	eor		MI.16b, MI.16b, MI.16b
+	eor		HI.16b, HI.16b, HI.16b
+	add		KEY_START, x1, #(NUM_PRECOMPUTE_POWERS << 4)
+	sub		KEY_START, KEY_START, PARTIAL_LEFT, lsl #4
+	ld1		{v0.16b}, [KEY_START]
+	mov		v1.16b, SUM.16b
+	karatsuba1 v0 v1
+	karatsuba2
+	montgomery_reduction
+	mov		SUM.16b, PH.16b
+	eor		LO.16b, LO.16b, LO.16b
+	eor		MI.16b, MI.16b, MI.16b
+	eor		HI.16b, HI.16b, HI.16b
+	mov		IND, XZR
+.LloopPartial:
+	cmp		IND, PARTIAL_LEFT
+	bge		.LloopExitPartial
+
+	sub		TMP, IND, PARTIAL_LEFT
+
+	cmp		TMP, #-4
+	bgt		.Lgt4Partial
+	ld1		{M0.16b, M1.16b,  M2.16b, M3.16b}, [x0], #64
+	// Clobber key registers
+	ld1		{KEY8.16b, KEY7.16b, KEY6.16b,  KEY5.16b}, [KEY_START], #64
+	karatsuba1 M0 KEY8
+	karatsuba1 M1 KEY7
+	karatsuba1 M2 KEY6
+	karatsuba1 M3 KEY5
+	add		IND, IND, #4
+	b		.LoutPartial
+
+.Lgt4Partial:
+	cmp		TMP, #-3
+	bgt		.Lgt3Partial
+	ld1		{M0.16b, M1.16b, M2.16b}, [x0], #48
+	// Clobber key registers
+	ld1		{KEY8.16b, KEY7.16b, KEY6.16b}, [KEY_START], #48
+	karatsuba1 M0 KEY8
+	karatsuba1 M1 KEY7
+	karatsuba1 M2 KEY6
+	add		IND, IND, #3
+	b		.LoutPartial
+
+.Lgt3Partial:
+	cmp		TMP, #-2
+	bgt		.Lgt2Partial
+	ld1		{M0.16b, M1.16b}, [x0], #32
+	// Clobber key registers
+	ld1		{KEY8.16b, KEY7.16b}, [KEY_START], #32
+	karatsuba1 M0 KEY8
+	karatsuba1 M1 KEY7
+	add		IND, IND, #2
+	b		.LoutPartial
+
+.Lgt2Partial:
+	ld1		{M0.16b}, [x0], #16
+	// Clobber key registers
+	ld1		{KEY8.16b}, [KEY_START], #16
+	karatsuba1 M0 KEY8
+	add		IND, IND, #1
+.LoutPartial:
+	b .LloopPartial
+.LloopExitPartial:
+	karatsuba2
+	montgomery_reduction
+	eor		SUM.16b, SUM.16b, PH.16b
+.endm
+
+/*
+ * Perform montgomery multiplication in GF(2^128) and store result in op1.
+ *
+ * Computes op1*op2*x^{-128} mod x^128 + x^127 + x^126 + x^121 + 1
+ * If op1, op2 are in montgomery form, this computes the montgomery
+ * form of op1*op2.
+ *
+ * void pmull_polyval_mul(u8 *op1, const u8 *op2);
+ */
+SYM_FUNC_START(pmull_polyval_mul)
+	adr		TMP, .Lgstar
+	ld1		{GSTAR.2d}, [TMP]
+	eor		LO.16b, LO.16b, LO.16b
+	eor		MI.16b, MI.16b, MI.16b
+	eor		HI.16b, HI.16b, HI.16b
+	ld1		{v0.16b}, [x0]
+	ld1		{v1.16b}, [x1]
+	karatsuba1 v0 v1
+	karatsuba2
+	montgomery_reduction
+	st1		{PH.16b}, [x0]
+	ret
+SYM_FUNC_END(pmull_polyval_mul)
+
+/*
+ * Perform polynomial evaluation as specified by POLYVAL.  This computes:
+ * 	h^n * accumulator + h^n * m_0 + ... + h^1 * m_{n-1}
+ * where n=nblocks, h is the hash key, and m_i are the message blocks.
+ *
+ * x0 - pointer to message blocks
+ * x1 - pointer to precomputed key powers h^8 ... h^1
+ * x2 - number of blocks to hash
+ * x3 - pointer to accumulator
+ *
+ * void pmull_polyval_update(const u8 *in, const struct polyval_ctx *ctx,
+ *			     size_t nblocks, u8 *accumulator);
+ */
+SYM_FUNC_START(pmull_polyval_update)
+	adr		TMP, .Lgstar
+	ld1		{GSTAR.2d}, [TMP]
+	ld1		{SUM.16b}, [x3]
+	ands		PARTIAL_LEFT, BLOCKS_LEFT, #7
+	beq		.LskipPartial
+	partial_stride
+.LskipPartial:
+	subs		BLOCKS_LEFT, BLOCKS_LEFT, #NUM_PRECOMPUTE_POWERS
+	blt		.LstrideLoopExit
+	ld1		{KEY8.16b, KEY7.16b, KEY6.16b, KEY5.16b}, [x1], #64
+	ld1		{KEY4.16b, KEY3.16b, KEY2.16b, KEY1.16b}, [x1], #64
+	full_stride 0
+	subs		BLOCKS_LEFT, BLOCKS_LEFT, #NUM_PRECOMPUTE_POWERS
+	blt		.LstrideLoopExitReduce
+.LstrideLoop:
+	full_stride 1
+	subs		BLOCKS_LEFT, BLOCKS_LEFT, #NUM_PRECOMPUTE_POWERS
+	bge		.LstrideLoop
+.LstrideLoopExitReduce:
+	montgomery_reduction
+	mov		SUM.16b, PH.16b
+.LstrideLoopExit:
+	st1		{SUM.16b}, [x3]
+	ret
+SYM_FUNC_END(pmull_polyval_update)
diff --git a/arch/arm64/crypto/polyval-ce-glue.c b/arch/arm64/crypto/polyval-ce-glue.c
new file mode 100644
index 000000000000..52cf87c36043
--- /dev/null
+++ b/arch/arm64/crypto/polyval-ce-glue.c
@@ -0,0 +1,363 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Accelerated POLYVAL implementation with ARMv8 Crypto Extension
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
+ * This implementation of POLYVAL uses montgomery multiplication accelerated by
+ * ARMv8 Crypto Extension instructions to implement the finite field operations.
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
+#include <linux/cpufeature.h>
+#include <asm/neon.h>
+#include <asm/simd.h>
+#include <asm/unaligned.h>
+
+#define NUM_PRECOMPUTE_POWERS	8
+
+struct polyval_async_ctx {
+	struct cryptd_ahash *cryptd_tfm;
+};
+
+struct polyval_ctx {
+	u8 key_powers[NUM_PRECOMPUTE_POWERS][POLYVAL_BLOCK_SIZE];
+};
+
+struct polyval_desc_ctx {
+	u8 buffer[POLYVAL_BLOCK_SIZE];
+	u32 bytes;
+};
+
+asmlinkage void pmull_polyval_update(const u8 *in, const struct polyval_ctx
+				     *ctx, size_t nblocks, u8 *accumulator);
+asmlinkage void pmull_polyval_mul(u8 *op1, const u8 *op2);
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
+	memcpy(ctx->key_powers[NUM_PRECOMPUTE_POWERS-1], key,
+	       POLYVAL_BLOCK_SIZE);
+
+	kernel_neon_begin();
+	for (i = NUM_PRECOMPUTE_POWERS-2; i >= 0; i--) {
+		memcpy(ctx->key_powers[i], key, POLYVAL_BLOCK_SIZE);
+		pmull_polyval_mul(ctx->key_powers[i], ctx->key_powers[i+1]);
+	}
+	kernel_neon_end();
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
+	unsigned int n;
+
+	kernel_neon_begin();
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
+			pmull_polyval_mul(dctx->buffer,
+				ctx->key_powers[NUM_PRECOMPUTE_POWERS-1]);
+	}
+
+	nblocks = srclen/POLYVAL_BLOCK_SIZE;
+	pmull_polyval_update(src, ctx, nblocks, dctx->buffer);
+	srclen -= nblocks*POLYVAL_BLOCK_SIZE;
+	kernel_neon_end();
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
+		kernel_neon_begin();
+		pmull_polyval_mul(dctx->buffer,
+			ctx->key_powers[NUM_PRECOMPUTE_POWERS-1]);
+		kernel_neon_end();
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
+		.cra_driver_name	= "__polyval-ce",
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
+	cryptd_tfm = cryptd_alloc_ahash("__polyval-ce",
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
+			.cra_driver_name	= "polyval-ce",
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
+static int __init polyval_ce_mod_init(void)
+{
+	int err;
+
+	if (!cpu_have_named_feature(ASIMD))
+		return -ENODEV;
+
+	if (!cpu_have_named_feature(PMULL))
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
+static void __exit polyval_ce_mod_exit(void)
+{
+	crypto_unregister_ahash(&polyval_async_alg);
+	crypto_unregister_shash(&polyval_alg);
+}
+
+static const struct cpu_feature polyval_cpu_feature[] = {
+	{ cpu_feature(PMULL) }, { }
+};
+MODULE_DEVICE_TABLE(cpu, polyval_cpu_feature);
+
+module_init(polyval_ce_mod_init);
+module_exit(polyval_ce_mod_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("POLYVAL hash function accelerated by ARMv8 Crypto Extension");
+MODULE_ALIAS_CRYPTO("polyval");
+MODULE_ALIAS_CRYPTO("polyval-ce");
-- 
2.35.1.723.g4982287a31-goog

