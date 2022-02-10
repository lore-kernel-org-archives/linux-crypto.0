Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36171C433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Feb 2022 23:28:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345649AbiBJX2u (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Feb 2022 18:28:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345661AbiBJX2t (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Feb 2022 18:28:49 -0500
Received: from mail-vs1-xe49.google.com (mail-vs1-xe49.google.com [IPv6:2607:f8b0:4864:20::e49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C9E35F6B
        for <linux-crypto@vger.kernel.org>; Thu, 10 Feb 2022 15:28:48 -0800 (PST)
Received: by mail-vs1-xe49.google.com with SMTP id b12-20020a67fe8c000000b0031a490e8b9dso644536vsr.15
        for <linux-crypto@vger.kernel.org>; Thu, 10 Feb 2022 15:28:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=aI+ZZN/XgFx9qNVpwESSjNwjrEMAlNEJZKE9wM7Vg8M=;
        b=szJN+mEd6nLTGyWwqNr7fYO0/2rktvhHXQztqi/tX90V+UH1y5L56DnLAVXvuM+dZj
         KZ6aBrbekNOSCcuB1MNM/4UXyLMoVCAw5jnWNZiXlpmrpCn2K00MUoT5nJ6k/BdBQ+1B
         4tU4JvSvK2ie5atiyYMBkZY2iIxFQQzy7gH6OSY0toUs9PDHSIrr1susNs1Te5EXhJwN
         EgB6sVHg8+YTEoi2lzbS563wEaReTAkyWSF4zBxnEPhjKHqE4bU0uDPNWEutBEBHyvkq
         +Q9pmtChWIia2FBJ8PltcLBnY2ZSWjwBk40Wqx3OokYV0FZ7RwBL30C5YbZbBZFvjRPw
         pj8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=aI+ZZN/XgFx9qNVpwESSjNwjrEMAlNEJZKE9wM7Vg8M=;
        b=mBBw44sTzlPI7K6bXXlMh+/Vj+yjhXaRTS6aM6sEgOscZf9i74uVlm6wtx8SivHV8K
         uSfaCsEa3IIABHCCy2aA8fLKn5fbmMnonTMpqpf3uEFDzzLN7w/D2rNyQc+NAR7ZkRc2
         HkT+6hEqF3SNbLaqUs8ndGOFV3+AZgU1l/q3sGAgV23gUvqfP2Bli7vlU+kEBog2oNH4
         8jGaECglvChfQLlXfTEPf9Tuc80cBa5z43ORvsFFdrM4ZjyHyOQ4Iy9DeJHjx/3cWCoR
         ZWykfidF8GJ8rzhlDPXbq1jTiBL3itKER63jsaZEWH8fG9ZAgh4+gvQ+L33FJWljwJG1
         goKg==
X-Gm-Message-State: AOAM533/KnetsFWDmePZmHj5UeNINiA/uI6a2RRZGUQirT/DCjTKk+k3
        Ya1TY8JpvnR80LG11Du6Wh7CmGyKbPYk4bfNbLmQ3eDNEjnjTG0fuwtfMSN8bFG5MZ//a7i8d2X
        gGRx0hU3TVsCA3JkeLRHNGwtEdKOTW8NYtqZ/YlLmM3os6cAPybN95J00fR5/4rfRBQE=
X-Google-Smtp-Source: ABdhPJzCBY0mrmEviuzKIse40qgMrfXkf3Pj774y8cx6D6m7AiAAbw5HhZBEYCXE4J1+fE0/KjzeZZYC5w==
X-Received: from nhuck.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:39cc])
 (user=nhuck job=sendgmr) by 2002:a67:fb0b:: with SMTP id d11mr2991237vsr.35.1644535727137;
 Thu, 10 Feb 2022 15:28:47 -0800 (PST)
Date:   Thu, 10 Feb 2022 23:28:12 +0000
In-Reply-To: <20220210232812.798387-1-nhuck@google.com>
Message-Id: <20220210232812.798387-8-nhuck@google.com>
Mime-Version: 1.0
References: <20220210232812.798387-1-nhuck@google.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [RFC PATCH v2 7/7] crypto: arm64/polyval: Add PMULL accelerated
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

Changes since v1:
 * Rename C, D, E to LO, MI, HI
 * Add comments explaining POLYVAL
 * Fix bug in handling of non-block-multiple messages
 * Wrap shash in ahash (as done in ghash)

 arch/arm64/crypto/Kconfig           |   7 +
 arch/arm64/crypto/Makefile          |   3 +
 arch/arm64/crypto/polyval-ce-core.S | 405 ++++++++++++++++++++++++++++
 arch/arm64/crypto/polyval-ce-glue.c | 365 +++++++++++++++++++++++++
 4 files changed, 780 insertions(+)
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
index 000000000000..3b2a5adf8987
--- /dev/null
+++ b/arch/arm64/crypto/polyval-ce-core.S
@@ -0,0 +1,405 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright 2021 Google LLC
+ *
+ * Use of this source code is governed by an MIT-style
+ * license that can be found in the LICENSE file or at
+ * https://opensource.org/licenses/MIT.
+ */
+/*
+ * This is an efficient implementation of POLYVAL using ARMv8 Crypto Extension
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
+#define NUM_PRECOMPUTE_POWERS 8
+
+BLOCKS_LEFT	.req	x2
+OP1	.req	x9
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
+	eor	v25.16b, v25.16b, X.16b
+	ext	v26.16b, Y.16b, Y.16b, #8
+	eor	v26.16b, v26.16b, Y.16b
+	pmull	v26.1q, v25.1d, v26.1d
+	pmull2	v25.1q, X.2d, Y.2d
+	pmull	X.1q, X.1d, Y.1d
+	eor	HI.16b, HI.16b, v26.16b
+	eor	LO.16b, LO.16b, v25.16b
+	eor	MI.16b, MI.16b, X.16b
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
+ * If reduce is set, performs interleaved montgomery reduction
+ * on the last full_stride iteration's PL, PH.
+ *
+ * Sets PL, PH.
+ */
+.macro full_stride reduce
+	.set reduce, \reduce
+	eor		LO.16b, LO.16b, LO.16b
+	eor		MI.16b, MI.16b, MI.16b
+	eor		HI.16b, HI.16b, HI.16b
+
+	ld1		{M0.16b, M1.16b, M2.16b, M3.16b}, [x0], #64
+	ld1		{M4.16b, M5.16b, M6.16b, M7.16b}, [x0], #64
+
+	karatsuba1 M7 KEY1
+	.if(reduce)
+	pmull	T.1q, GSTAR.1d, PL.1d
+	.endif
+
+	karatsuba1 M6 KEY2
+	.if(reduce)
+	ext	T.16b, T.16b, T.16b, #8
+	.endif
+
+	karatsuba1 M5 KEY3
+	.if(reduce)
+	eor	PL.16b, PL.16b, T.16b
+	.endif
+
+	karatsuba1 M4 KEY4
+	.if(reduce)
+	pmull2	V.1q, GSTAR.2d, PL.2d
+	.endif
+
+	karatsuba1 M3 KEY5
+	.if(reduce)
+	eor	V.16b, PL.16b, V.16b
+	.endif
+
+	karatsuba1 M2 KEY6
+	.if(reduce)
+	eor	PH.16b, PH.16b, V.16b
+	.endif
+
+	karatsuba1 M1 KEY7
+	.if(reduce)
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
+ * If op1, op2 are in montgomery form,  this computes the montgomery
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
+ * Perform polynomial evaluation as specified by POLYVAL. If nblocks = k, this
+ * routine multiplies the value stored at accumulator by h^k and XORs the
+ * evaluated polynomial into it.
+ *
+ * Computes h^k * accumulator + h^kM_0 + ... + h^1M_{k-1} (No constant term)
+ *
+ * x0 (OP1) - pointer to message blocks
+ * x1 - pointer to precomputed key struct
+ * x2 - number of blocks to hash
+ * x3 - location to XOR with evaluated polynomial
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
index 000000000000..ca92e027b4ec
--- /dev/null
+++ b/arch/arm64/crypto/polyval-ce-glue.c
@@ -0,0 +1,365 @@
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
+#include <linux/crypto.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/cpufeature.h>
+#include <asm/neon.h>
+#include <asm/simd.h>
+#include <asm/unaligned.h>
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
+	be128 key_powers[NUM_PRECOMPUTE_POWERS];
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
+	memcpy(&ctx->key_powers[NUM_PRECOMPUTE_POWERS-1], key, sizeof(be128));
+
+	kernel_neon_begin();
+	for (i = NUM_PRECOMPUTE_POWERS-2; i >= 0; i--) {
+		memcpy(&ctx->key_powers[i], key, sizeof(be128));
+		pmull_polyval_mul((u8 *)&ctx->key_powers[i],
+				  (u8 *)&ctx->key_powers[i+1]);
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
+	u8 *dst = dctx->buffer;
+	u8 *pos;
+	unsigned int nblocks;
+	unsigned int n;
+
+	kernel_neon_begin();
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
+			pmull_polyval_mul(dst,
+				(u8 *)&ctx->key_powers[NUM_PRECOMPUTE_POWERS-1]);
+	}
+
+	nblocks = srclen/POLYVAL_BLOCK_SIZE;
+	pmull_polyval_update(src, ctx, nblocks, dst);
+	srclen -= nblocks*POLYVAL_BLOCK_SIZE;
+	kernel_neon_end();
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
+		kernel_neon_begin();
+		pmull_polyval_mul(buf,
+			(u8 *)&ctx->key_powers[NUM_PRECOMPUTE_POWERS-1]);
+		kernel_neon_end();
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
-- 
2.35.1.265.g69c8d7142f-goog

