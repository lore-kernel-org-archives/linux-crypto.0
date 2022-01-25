Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FEFCC433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Jan 2022 02:21:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S3419860AbiAYCUr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Jan 2022 21:20:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S3415596AbiAYBsE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Jan 2022 20:48:04 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 463CCC04D61E
        for <linux-crypto@vger.kernel.org>; Mon, 24 Jan 2022 17:45:45 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id z15-20020a25bb0f000000b00613388c7d99so38743037ybg.8
        for <linux-crypto@vger.kernel.org>; Mon, 24 Jan 2022 17:45:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=eB5vxN0GT8DN2YSHGdODSEc9z/+4GXVgUB43PVkm+uQ=;
        b=Vuj20fLDWPSXy2gqXHXxSPSdfxkcvxeHkbMwORUYvjZAmGHdMkjmpyksBoDHH9Oib6
         6BcaQ46Jka++aKbYYTsV1ejwFcluHywdd76/zIT0zfG7s6pBe5kC77Dc/BgQVutSGPZk
         XBVS8uAlOZOpO/1bSztH1vwvzKieWDa3/B1dM/YDNX82yBDle2K7vTSwjNHos7qSj29i
         VcnXb3j67Pp+0DBvmFAVKZttO3l8jI08uIVhK6OEowOPNoVydoo2wbnNtICd7spOhaDB
         i0xo6jCBJhWvbvsuowvCOmNrr4nolGvL1vCGCE9bmqT6zDMFySOgX4yJ1izTEGyjut98
         acAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=eB5vxN0GT8DN2YSHGdODSEc9z/+4GXVgUB43PVkm+uQ=;
        b=nU64yRW25ftIHPLAaC6oyMZZXs9t5IJH1SxxiZWWKXw2Si53nLdNe/G9aALjj1dBun
         Mo6cXjOcmEYE8CB16z1S0oWX8iodbokDTAf1c8nnxvkNQeVRgdWUbUzutyfWqaULSmzl
         4R+010Cx5kBk/171CB6rMkBZXTP8s/ENnXHx3wo24o3JC2NrkWnclHg8dVOk0D2ukaSY
         pDnc9c06e1UCtHV+1Gw7gJ+q51AvCFfcCbi5doRQFTSByOvT+Uq036rN4RKAXY2jTn2v
         RdXLPqfJXDQeSw0U8NPBc1lOkLWQf7cjKkxeGbtiuOP6P3/g7/69skCfOsrzMSkLMm6f
         IEzQ==
X-Gm-Message-State: AOAM533rt/DTbHbun87HYM4ALgizdzjUFvNdOm1PhEYFX3DLLgLorWWv
        uP7ZfePG2jP3eBX234u64+QxvLMa2bjbFu/tajIawvNi87qAz/ukuQbXaoTYoYoAVDBrnuB8BZW
        dRrGxQT6nc18rJpXmhmdXztQEmfVut1k4S8SDnYlYjA4sAKA7XKOW8rD8XG0jKAKsUpY=
X-Google-Smtp-Source: ABdhPJyOFa3549oXn0GuLsabtW/6TS4mlkHiqFnGkQhr1hL4+UOX6yyXRaEH/VpIQuXMCaOFle8LafEedw==
X-Received: from nhuck.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:39cc])
 (user=nhuck job=sendgmr) by 2002:a25:ae27:: with SMTP id a39mr26272213ybj.211.1643075144441;
 Mon, 24 Jan 2022 17:45:44 -0800 (PST)
Date:   Mon, 24 Jan 2022 19:44:22 -0600
In-Reply-To: <20220125014422.80552-1-nhuck@google.com>
Message-Id: <20220125014422.80552-8-nhuck@google.com>
Mime-Version: 1.0
References: <20220125014422.80552-1-nhuck@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [RFC PATCH 7/7] crypto: arm64/polyval: Add PMULL accelerated
 implementation of POLYVAL
From:   Nathan Huckleberry <nhuck@google.com>
To:     linux-crypto@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Paul Crowley <paulcrowley@google.com>,
        Eric Biggers <ebiggers@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Nathan Huckleberry <nhuck@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add hardware accelerated version of POLYVAL for ARM64 CPUs with
Crypto Extension support.

This implementation is accelerated using PMULL instructions to perform
the finite field computations.  For added efficiency, 8 blocks of the
plaintext are processed simultaneously by precomputing the first 8
powers of the key.

Karatsuba multiplication is used instead of Schoolbook multiplication
because it was found to be slightly faster on ARM64 CPUs.  Montgomery
reduction must be used instead of Barrett reduction due to the
difference in modulus between POLYVAL's field and other finite fields.

Signed-off-by: Nathan Huckleberry <nhuck@google.com>
---
 arch/arm64/crypto/Kconfig           |   6 +
 arch/arm64/crypto/Makefile          |   3 +
 arch/arm64/crypto/polyval-ce-core.S | 317 ++++++++++++++++++++++++++++
 arch/arm64/crypto/polyval-ce-glue.c | 164 ++++++++++++++
 4 files changed, 490 insertions(+)
 create mode 100644 arch/arm64/crypto/polyval-ce-core.S
 create mode 100644 arch/arm64/crypto/polyval-ce-glue.c

diff --git a/arch/arm64/crypto/Kconfig b/arch/arm64/crypto/Kconfig
index cab469e279ec..b858f84b85eb 100644
--- a/arch/arm64/crypto/Kconfig
+++ b/arch/arm64/crypto/Kconfig
@@ -60,6 +60,12 @@ config CRYPTO_GHASH_ARM64_CE
 	select CRYPTO_GF128MUL
 	select CRYPTO_LIB_AES
 
+config CRYPTO_POLYVAL_ARM64_CE
+	tristate "POLYVAL using ARMv8 Crypto Extensions (for HCTR2)"
+	depends on KERNEL_MODE_NEON
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
index 000000000000..04677c636aa1
--- /dev/null
+++ b/arch/arm64/crypto/polyval-ce-core.S
@@ -0,0 +1,317 @@
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
+ * instructions. It works on 8 blocks at a time, computing the 256 degree
+ * polynomial p(x) = h^8m_0 + ... + h^1m_7. It then computes the modular
+ * reduction of p(x) and XORs with the current digest.
+ */
+
+#include <linux/linkage.h>
+#define NUM_PRECOMPUTE_POWERS 8
+
+BLOCKS_LEFT	.req	x2
+OP1	.req	x9
+KEY_START	.req	x10
+EXTRA_BYTES	.req	x11
+IDX	.req	x12
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
+Z	.req	v19
+C	.req	v20
+D	.req	v21
+E	.req	v22
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
+ * Computes the first step of Karatsuba multiplication of
+ * registers X, Y.
+ *
+ * Updates C, D, E
+ * Clobbers v25, v26, X, Y
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
+	eor	E.16b, E.16b, v26.16b
+	eor	C.16b, C.16b, v25.16b
+	eor	D.16b, D.16b, X.16b
+	.unreq X
+	.unreq Y
+.endm
+
+/*
+ * Computes the 256-bit polynomial represented by C, D, E.
+ * Stores this polynomial in PH, PL.
+ *
+ * Sets PH, PL
+ * Clobbers C, D, E, v4
+ */
+.macro karatsuba2
+	ext	v4.16b, D.16b, C.16b, #8
+	eor	E.16b, E.16b, v4.16b //[E1 ^ C0 : E0 ^ D1]
+	eor	v4.16b, C.16b, D.16b //[C1 ^ D1 : C0 ^ D0]
+	eor	v4.16b, E.16b, v4.16b //[C0 ^ C1 ^ D1 ^ E1 : D1 ^ C0 ^ D0 ^ E0]
+	ext	C.16b, C.16b, C.16b, #8 // [C0 : C1]
+	ext	D.16b, D.16b, D.16b, #8 // [D0 : D1]
+	ext	PH.16b, v4.16b, C.16b, #8 //[C1 : C1 ^ D1 ^ E1 ^ C0]
+	ext	PL.16b, D.16b, v4.16b, #8 //[D1 ^ C0 ^ D0 ^ E0 : D0]
+.endm
+
+/*
+ * Perform montgomery reduction of the polynomial
+ * represented by PH, PL. Stores the reduced polynomial
+ * in PH.
+ *
+ * Sets PH
+ * Clobbers T, Z, PL
+ */
+.macro montgomery_reduction
+	pmull	T.1q, GSTAR.1d, PL.1d
+	ext	T.16b, T.16b, T.16b, #8
+	eor	PL.16b, PL.16b, T.16b
+	pmull2	Z.1q, GSTAR.2d, PL.2d
+	eor	Z.16b, PL.16b, Z.16b
+	eor	PH.16b, PH.16b, Z.16b
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
+	eor		C.16b, C.16b, C.16b
+	eor		D.16b, D.16b, D.16b
+	eor		E.16b, E.16b, E.16b
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
+	pmull2	Z.1q, GSTAR.2d, PL.2d
+	.endif
+
+	karatsuba1 M3 KEY5
+	.if(reduce)
+	eor	Z.16b, PL.16b, Z.16b
+	.endif
+
+	karatsuba1 M2 KEY6
+	.if(reduce)
+	eor	PH.16b, PH.16b, Z.16b
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
+	eor		C.16b, C.16b, C.16b
+	eor		D.16b, D.16b, D.16b
+	eor		E.16b, E.16b, E.16b
+	add		KEY_START, x1, #(NUM_PRECOMPUTE_POWERS << 4)
+	sub		KEY_START, KEY_START, PARTIAL_LEFT, lsl #4
+	ld1		{v0.16b}, [KEY_START]
+	mov		v1.16b, SUM.16b
+	karatsuba1 v0 v1
+	karatsuba2
+	montgomery_reduction
+	mov		SUM.16b, PH.16b
+	eor		C.16b, C.16b, C.16b
+	eor		D.16b, D.16b, D.16b
+	eor		E.16b, E.16b, E.16b
+	mov		IDX, XZR
+.LloopPartial:
+	cmp		IDX, PARTIAL_LEFT
+	bge		.LloopExitPartial
+
+	sub		TMP, IDX, PARTIAL_LEFT
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
+	add		IDX, IDX, #4
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
+	add		IDX, IDX, #3
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
+	add		IDX, IDX, #2
+	b		.LoutPartial
+
+.Lgt2Partial:
+	ld1		{M0.16b}, [x0], #16
+	// Clobber key registers
+	ld1		{KEY8.16b}, [KEY_START], #16
+	karatsuba1 M0 KEY8
+	add		IDX, IDX, #1
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
+ * void pmull_polyval_mul(ble128 *op1, const ble128 *op2);
+ */
+SYM_FUNC_START(pmull_polyval_mul)
+	adr		TMP, .Lgstar
+	ld1		{GSTAR.2d}, [TMP]
+	eor		C.16b, C.16b, C.16b
+	eor		D.16b, D.16b, D.16b
+	eor		E.16b, E.16b, E.16b
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
+ * Perform polynomial evaluation as specified by POLYVAL. Multiplies the value
+ * stored at accumulator by h^n and XORs the evaluated polynomial into it.
+ *
+ * Computes h^k*accumulator + h^kM_0 + ... + h^1M_{k-1} (No constant term)
+ *
+ * x0 (OP1) - pointer to message blocks
+ * x1 - pointer to precomputed key struct
+ * x2 - number of blocks to hash
+ * x3 - location to XOR with evaluated polynomial
+ *
+ * void pmull_polyval_update(const u8 *in, const struct polyhash_key *keys,
+ *			     size_t nblocks, ble128 *accumulator);
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
index 000000000000..2a83a931069a
--- /dev/null
+++ b/arch/arm64/crypto/polyval-ce-glue.c
@@ -0,0 +1,164 @@
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
+#include <crypto/gf128mul.h>
+#include <crypto/internal/hash.h>
+#include <linux/crypto.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <asm/neon.h>
+
+#define POLYVAL_BLOCK_SIZE	16
+#define POLYVAL_DIGEST_SIZE	16
+#define NUM_PRECOMPUTE_POWERS	8
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
+asmlinkage void pmull_polyval_update(const u8 *in, const be128 *keys, size_t
+				     nblocks, be128 *accumulator);
+asmlinkage void pmull_polyval_mul(be128 *op1, const be128 *op2);
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
+	memcpy(&ctx->key_powers[NUM_PRECOMPUTE_POWERS-1], key, sizeof(be128));
+
+	for (i = NUM_PRECOMPUTE_POWERS-2; i >= 0; i--) {
+		memcpy(&ctx->key_powers[i], key, sizeof(be128));
+		pmull_polyval_mul(&ctx->key_powers[i], &ctx->key_powers[i+1]);
+	}
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
+			pmull_polyval_mul((be128 *)dst, &ctx->key_powers[NUM_PRECOMPUTE_POWERS-1]);
+	}
+
+	nblocks = srclen/POLYVAL_BLOCK_SIZE;
+	pmull_polyval_update(src, ctx->key_powers, nblocks, (be128 *)dst);
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
+		pmull_polyval_mul((be128 *)dst, &ctx->key_powers[NUM_PRECOMPUTE_POWERS-1]);
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
+		.cra_name		= "polyval",
+		.cra_driver_name	= "polyval-ce",
+		.cra_priority		= 200,
+		.cra_blocksize		= POLYVAL_BLOCK_SIZE,
+		.cra_ctxsize		= sizeof(struct polyval_ctx),
+		.cra_module		= THIS_MODULE,
+	},
+};
+
+static int __init polyval_mod_init(void)
+{
+	return crypto_register_shash(&polyval_alg);
+}
+
+static void __exit polyval_mod_exit(void)
+{
+	crypto_unregister_shash(&polyval_alg);
+}
+
+subsys_initcall(polyval_mod_init);
+module_exit(polyval_mod_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("POLYVAL hash function accelerated by ARMv8 Crypto Extension");
+MODULE_ALIAS_CRYPTO("polyval");
-- 
2.35.0.rc0.227.g00780c9af4-goog

