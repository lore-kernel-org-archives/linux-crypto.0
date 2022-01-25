Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 609D4C433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Jan 2022 02:21:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346972AbiAYCUa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Jan 2022 21:20:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S3415595AbiAYBsE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Jan 2022 20:48:04 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86B18C019B13
        for <linux-crypto@vger.kernel.org>; Mon, 24 Jan 2022 17:45:41 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id c7-20020a25a2c7000000b00613e4dbaf97so34725911ybn.13
        for <linux-crypto@vger.kernel.org>; Mon, 24 Jan 2022 17:45:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=s+RcsGSLd+BuMVXes3OXJe3awd84fm4HnoiXC4X/KlY=;
        b=VU2yhe+pKAD0wL7rxvTWev7ubWnpPtQ2jXf9w0479roUU3ycs5m/fC+HYMHBhUOTmk
         6oiU6YNS9PdLOPsdKnaqbKQWG8IXllA9xKa2T+eG6WWaIrDyrXzmVuuiFz5ARqIE3xU0
         OZNQTj/x1BaTLbJKNKl/QjHt0+8IkDyggFtL/bKOpQg102K0oaEfJ8ncwLGIBqG3uGS8
         82esVpg/QRfanYdROfjnM4fujqsG91Tds9kem8NPSgDXlYOasusC3HI82HkSkcq4BkHd
         d+U0xHxm4uN+Gy/UdHyysOrQ4nWTxaBvIlCc7KYny1YeWiftECyJiNOhHyuYV06otasM
         yChg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=s+RcsGSLd+BuMVXes3OXJe3awd84fm4HnoiXC4X/KlY=;
        b=rPYSKyX6IrU+HKzo3s/VRqGXOF2FI7teiDzVJ4ZhcsatYVvM+PKIY4IZEv70u7h61t
         DigQfuDr5bNHiKQr618207nSIfjWh9M226C4+4gc6eA8+4E4Ac2ikkuWX0Y85BrsVZS7
         fSn0MAgoJsuh/as5zHm0oloBeerwBP8N49wlT7p1jn3kKECpEj2Y8ZHnimfi2ZPz/T7v
         vUCphMRuLHaZCJpzZfxJtCOtR/0rpjJldM/2a2eeEcwC79zCNZffAP+FPDfQkPEi2qgs
         3wC8HqOjZAQuOAtkNc6HKmTqxk3c+LzVnZoUdsRzkD1GG4OMlsn3bTOHOpPQNp68frPf
         UHrA==
X-Gm-Message-State: AOAM5305X9H7LD8eveCNmGDiYpfn1E+oqcQFPIBUuUSx5EbZ1p+DKfET
        j5Nv1WfEPf8U1AIQcxAQNIh2lb1qE8Bu7CI++xI0A3fYCqmzJOEC5pFX7wnx3zf2oTNjhZZh+lc
        T5xxOYJ8AUr4xli9EOdmmkdfv/wZ2GRqTmtHP1tjs/kaCh7AzuhX7FpIK/bB/VtO4gko=
X-Google-Smtp-Source: ABdhPJxFuIFKXeLM3/tiPt43CDC78jm19oZCnIEcNLiSqIvz4SLKHSWlqgJkbMz7d8XNvHte0g+wHGR6rQ==
X-Received: from nhuck.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:39cc])
 (user=nhuck job=sendgmr) by 2002:a81:1cc6:0:b0:2ca:287c:6ce8 with SMTP id
 00721157ae682-2ca287c6f30mr2827747b3.397.1643075139016; Mon, 24 Jan 2022
 17:45:39 -0800 (PST)
Date:   Mon, 24 Jan 2022 19:44:21 -0600
In-Reply-To: <20220125014422.80552-1-nhuck@google.com>
Message-Id: <20220125014422.80552-7-nhuck@google.com>
Mime-Version: 1.0
References: <20220125014422.80552-1-nhuck@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [RFC PATCH 6/7] crypto: x86/polyval: Add PCLMULQDQ accelerated
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

Add hardware accelerated version of POLYVAL for x86-64 CPUs with
PCLMULQDQ support.

This implementation is accelerated using PCLMULQDQ instructions to
perform the finite field computations.  For added efficiency, 8 blocks
of the plaintext are processed simultaneously by precomputing the first
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
 arch/x86/crypto/Makefile                     |   3 +
 arch/x86/crypto/polyval-clmulni-intel_asm.S  | 319 +++++++++++++++++++
 arch/x86/crypto/polyval-clmulni-intel_glue.c | 165 ++++++++++
 crypto/Kconfig                               |   9 +
 4 files changed, 496 insertions(+)
 create mode 100644 arch/x86/crypto/polyval-clmulni-intel_asm.S
 create mode 100644 arch/x86/crypto/polyval-clmulni-intel_glue.c

diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index ed187fcd0b01..0214c5f22606 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -69,6 +69,9 @@ libblake2s-x86_64-y := blake2s-core.o blake2s-glue.o
 obj-$(CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL) += ghash-clmulni-intel.o
 ghash-clmulni-intel-y := ghash-clmulni-intel_asm.o ghash-clmulni-intel_glue.o
 
+obj-$(CONFIG_CRYPTO_POLYVAL_CLMUL_NI_INTEL) += polyval-clmulni-intel.o
+polyval-clmulni-intel-y := polyval-clmulni-intel_asm.o polyval-clmulni-intel_glue.o
+
 obj-$(CONFIG_CRYPTO_CRC32C_INTEL) += crc32c-intel.o
 crc32c-intel-y := crc32c-intel_glue.o
 crc32c-intel-$(CONFIG_64BIT) += crc32c-pcl-intel-asm_64.o
diff --git a/arch/x86/crypto/polyval-clmulni-intel_asm.S b/arch/x86/crypto/polyval-clmulni-intel_asm.S
new file mode 100644
index 000000000000..4339b58e610d
--- /dev/null
+++ b/arch/x86/crypto/polyval-clmulni-intel_asm.S
@@ -0,0 +1,319 @@
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
+ * instructions. It works on 8 blocks at a time, computing the 256 degree
+ * polynomial p(x) = h^8m_0 + ... + h^1m_7. It then computes the modular
+ * reduction of p(x) and XORs p(x) with the current digest.
+ */
+
+#include <linux/linkage.h>
+#include <asm/frame.h>
+
+#define NUM_PRECOMPUTE_POWERS 8
+
+.align 16
+
+#define GSTAR %xmm7
+#define PL %xmm8
+#define PH %xmm9
+#define T %xmm10
+#define Z %xmm11
+#define C %xmm12
+#define D %xmm13
+#define EF %xmm14
+#define SUM %xmm15
+
+#define BLOCKS_LEFT %rdx
+#define OP1 %rdi
+#define OP2 %r10
+#define IDX %r11
+#define TMP %rax
+
+Lgstar:
+	.quad 0xc200000000000000, 0xc200000000000000
+
+.text
+
+/*
+ * Accepts operand lists of length b in rdi and rsi. Computes the product of
+ * each rdi,rsi pair then XORs the products into A, B, C, D.
+ *
+ * If first == 1 then XOR the value of SUM into the first block processed.
+ * This avoids an extra multication of SUM and h^N.
+ *
+ * XORs product into C, D, EF
+ * Preserves SUM
+ * All other xmm registers clobbered
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
+.macro schoolbook1_iteration i first
+	.set first, \first
+	.set i, \i
+	movups (16*i)(OP1), %xmm0
+	.if(i == 0 && first == 1)
+		pxor SUM, %xmm0
+	.endif
+	vpclmulqdq $0x01, (16*i)(OP2), %xmm0, %xmm1
+	vpxor %xmm1, EF, EF
+	vpclmulqdq $0x00, (16*i)(OP2), %xmm0, %xmm2
+	vpxor %xmm2, C, C
+	vpclmulqdq $0x11, (16*i)(OP2), %xmm0, %xmm3
+	vpxor %xmm3, D, D
+	vpclmulqdq $0x10, (16*i)(OP2), %xmm0, %xmm4
+	vpxor %xmm4, EF, EF
+.endm
+
+/*
+ * Computes first schoolbook step of values loaded into xmm0 and xmm1. Used to
+ * multiply intermediate register values rather than memory stored values.
+ *
+ * XORs product into C, D, EF
+ * Preserves SUM
+ * All other xmm registers clobbered
+ */
+.macro schoolbook1_noload
+	vpclmulqdq $0x01, %xmm0, %xmm1, %xmm2
+	vpxor %xmm2, EF, EF
+	vpclmulqdq $0x00, %xmm0, %xmm1, %xmm3
+	vpxor %xmm3, C, C
+	vpclmulqdq $0x11, %xmm0, %xmm1, %xmm4
+	vpxor %xmm4, D, D
+	vpclmulqdq $0x10, %xmm0, %xmm1, %xmm5
+	vpxor %xmm5, EF, EF
+.endm
+
+/*
+ * Computes the 256-bit polynomial represented by C, D, EF. Stores
+ * the result in PL, PH.
+ *
+ * All other xmm registers are preserved.
+ */
+.macro schoolbook2
+	vpslldq $8, EF, PL
+	vpsrldq $8, EF, PH
+	pxor C, PL
+	pxor D, PH
+.endm
+
+/*
+ * Computes the 128-bit reduction of PL, PH. Stores the result in PH.
+ *
+ * PL, PH, Z, T.
+ * All other xmm registers are preserved.
+ */
+.macro montgomery_reduction
+	movdqa PL, T
+	pclmulqdq $0x00, GSTAR, T # T = [X0 * g*(x)]
+	pshufd $0b01001110, T, Z # Z = [T0 : T1]
+	pxor Z, PL # PL = [X1 ^ T0 : X0 ^ T1]
+	pxor PL, PH # PH = [X1 ^ T0 ^ X3 : X0 ^ T1 ^ X2]
+	pclmulqdq $0x11, GSTAR, PL # PL = [X1 ^ T0 * g*(x)]
+	pxor PL, PH
+.endm
+
+/*
+ * Compute schoolbook multiplication for 8 blocks
+ * (M_0h + REDUCE(PL, PH))h^8 + ... + M_{7}h^1 (no constant term)
+ *
+ * Sets PL, PH
+ * Clobbers C, D, E
+ *
+ * If reduce is set, computes the montgomery reduction of the
+ * previous full_stride call.
+ */
+.macro full_stride reduce
+	.set reduce, \reduce
+	mov %rsi, OP2
+	pxor C, C
+	pxor D, D
+	pxor EF, EF
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
+		pshufd $0b01001110, T, Z # Z = [T0 : T1]
+	.endif
+
+	schoolbook1_iteration 4 0
+	.if(reduce)
+		pxor Z, PL # PL = [X1 ^ T0 : X0 ^ T1]
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
+	pxor C, C
+	pxor D, D
+	pxor EF, EF
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
+	pxor C, C
+	pxor D, D
+	pxor EF, EF
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
+ * void clmul_polyval_mul(ble128 *op1, const ble128 *op2);
+ */
+SYM_FUNC_START(clmul_polyval_mul)
+	FRAME_BEGIN
+	vmovdqa Lgstar(%rip), GSTAR
+	pxor C, C
+	pxor D, D
+	pxor EF, EF
+	mov %rsi, OP2
+	schoolbook1 1
+	schoolbook2
+	montgomery_reduction
+	movups PH, (%rdi)
+	FRAME_END
+	ret
+SYM_FUNC_END(clmul_polyval_mul)
+
+/*
+ * Perform polynomial evaluation as specified by POLYVAL. Multiplies the value
+ * stored at accumulator by h^k and XORs the evaluated polynomial into it.
+ *
+ * Computes h^k*accumulator + h^kM_0 + ... + h^1M_{k-1} (No constant term)
+ *
+ * rdi (OP1) - pointer to message blocks
+ * rsi - pointer to precomputed key struct
+ * rdx - number of blocks to hash
+ * rcx - location to XOR with evaluated polynomial
+ *
+ * void clmul_polyval_update(const u8 *in, const struct polyhash_key* keys,
+ *			     size_t nblocks, ble128* accumulator);
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
diff --git a/arch/x86/crypto/polyval-clmulni-intel_glue.c b/arch/x86/crypto/polyval-clmulni-intel_glue.c
new file mode 100644
index 000000000000..64a432b67b49
--- /dev/null
+++ b/arch/x86/crypto/polyval-clmulni-intel_glue.c
@@ -0,0 +1,165 @@
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
+#include <crypto/gf128mul.h>
+#include <crypto/internal/hash.h>
+#include <linux/crypto.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <asm/simd.h>
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
+asmlinkage void clmul_polyval_update(const u8 *in, const be128 *keys, size_t
+	nblocks, be128 *accumulator);
+asmlinkage void clmul_polyval_mul(be128 *op1, const be128 *op2);
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
+		clmul_polyval_mul(&ctx->key_powers[i], &ctx->key_powers[i+1]);
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
+			clmul_polyval_mul((be128 *)dst, &ctx->key_powers[NUM_PRECOMPUTE_POWERS-1]);
+	}
+
+	nblocks = srclen/POLYVAL_BLOCK_SIZE;
+	clmul_polyval_update(src, ctx->key_powers, nblocks, (be128 *)dst);
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
+		clmul_polyval_mul((be128 *)dst, &ctx->key_powers[NUM_PRECOMPUTE_POWERS-1]);
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
+		.cra_name		= "polyval",
+		.cra_driver_name	= "polyval-pclmulqdqni",
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
+MODULE_DESCRIPTION("POLYVAL hash function accelerated by PCLMULQDQ-NI");
+MODULE_ALIAS_CRYPTO("polyval");
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 3cdb6c351062..ecff82b77b42 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -779,6 +779,15 @@ config CRYPTO_POLYVAL
 	  POLYVAL is the hash function used in HCTR2.  It is not a general-purpose
 	  cryptographic hash function.
 
+config CRYPTO_POLYVAL_CLMUL_NI_INTEL
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
2.35.0.rc0.227.g00780c9af4-goog

