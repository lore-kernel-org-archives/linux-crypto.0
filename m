Return-Path: <SRS0=0i+u=ZA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8346EFA372C
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 12:23:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B24922459
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 12:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573215812;
	bh=j8F4v6QpziQ2HyzBrhg1ETe2HZKR57BqE2qQGuziYT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=JgbX+ddJbNgkVPFlHS8wcDfpcZ3iwiAt2MUk4n0HfYvSCg3I6BR8JmSiDtk4DUPX5
	 IO+rn/Lr8iDa0RSXwjjmBhgHo6RI1xyNTvNK9o4EEjqQe/KnHPeED5UWS+jJxt1Dvd
	 MI7EMgEvvZCPKQJsVTKYvQNgsSkCO9CMWcKNpzZw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732289AbfKHMXb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Nov 2019 07:23:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:37974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727598AbfKHMXb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Nov 2019 07:23:31 -0500
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr [92.154.90.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4D142245A;
        Fri,  8 Nov 2019 12:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573215810;
        bh=j8F4v6QpziQ2HyzBrhg1ETe2HZKR57BqE2qQGuziYT0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K5MFooFJTUaFLAC0G0yXi3c7g6L97u8xloYMyQhmDg3t/GHA4gAiAFMckSvR1+gg5
         5UIRmIjoAVnOaa42ig8/2u9Y81aD4ZWFRKyVnC7druinygdFBkpWoHKWU1su0E0gXF
         BIEUZOTHj1D7j0c9p1HBIJMEX1t2GExnA1005y14=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Martin Willi <martin@strongswan.org>,
        Rene van Dorst <opensource@vdorst.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH v5 10/34] crypto: mips/chacha - import 32r2 ChaCha code from Zinc
Date:   Fri,  8 Nov 2019 13:22:16 +0100
Message-Id: <20191108122240.28479-11-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108122240.28479-1-ardb@kernel.org>
References: <20191108122240.28479-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

This imports the accelerated MIPS 32r2 ChaCha20 implementation from the
Zinc patch set.

Co-developed-by: René van Dorst <opensource@vdorst.com>
Signed-off-by: René van Dorst <opensource@vdorst.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/mips/crypto/chacha-core.S | 424 ++++++++++++++++++++
 1 file changed, 424 insertions(+)

diff --git a/arch/mips/crypto/chacha-core.S b/arch/mips/crypto/chacha-core.S
new file mode 100644
index 000000000000..a81e02db95e7
--- /dev/null
+++ b/arch/mips/crypto/chacha-core.S
@@ -0,0 +1,424 @@
+/* SPDX-License-Identifier: GPL-2.0 OR MIT */
+/*
+ * Copyright (C) 2016-2018 René van Dorst <opensource@vdorst.com>. All Rights Reserved.
+ * Copyright (C) 2015-2019 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
+ */
+
+#define MASK_U32		0x3c
+#define CHACHA20_BLOCK_SIZE	64
+#define STACK_SIZE		32
+
+#define X0	$t0
+#define X1	$t1
+#define X2	$t2
+#define X3	$t3
+#define X4	$t4
+#define X5	$t5
+#define X6	$t6
+#define X7	$t7
+#define X8	$t8
+#define X9	$t9
+#define X10	$v1
+#define X11	$s6
+#define X12	$s5
+#define X13	$s4
+#define X14	$s3
+#define X15	$s2
+/* Use regs which are overwritten on exit for Tx so we don't leak clear data. */
+#define T0	$s1
+#define T1	$s0
+#define T(n)	T ## n
+#define X(n)	X ## n
+
+/* Input arguments */
+#define STATE		$a0
+#define OUT		$a1
+#define IN		$a2
+#define BYTES		$a3
+
+/* Output argument */
+/* NONCE[0] is kept in a register and not in memory.
+ * We don't want to touch original value in memory.
+ * Must be incremented every loop iteration.
+ */
+#define NONCE_0		$v0
+
+/* SAVED_X and SAVED_CA are set in the jump table.
+ * Use regs which are overwritten on exit else we don't leak clear data.
+ * They are used to handling the last bytes which are not multiple of 4.
+ */
+#define SAVED_X		X15
+#define SAVED_CA	$s7
+
+#define IS_UNALIGNED	$s7
+
+#if __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
+#define MSB 0
+#define LSB 3
+#define ROTx rotl
+#define ROTR(n) rotr n, 24
+#define	CPU_TO_LE32(n) \
+	wsbh	n; \
+	rotr	n, 16;
+#else
+#define MSB 3
+#define LSB 0
+#define ROTx rotr
+#define CPU_TO_LE32(n)
+#define ROTR(n)
+#endif
+
+#define FOR_EACH_WORD(x) \
+	x( 0); \
+	x( 1); \
+	x( 2); \
+	x( 3); \
+	x( 4); \
+	x( 5); \
+	x( 6); \
+	x( 7); \
+	x( 8); \
+	x( 9); \
+	x(10); \
+	x(11); \
+	x(12); \
+	x(13); \
+	x(14); \
+	x(15);
+
+#define FOR_EACH_WORD_REV(x) \
+	x(15); \
+	x(14); \
+	x(13); \
+	x(12); \
+	x(11); \
+	x(10); \
+	x( 9); \
+	x( 8); \
+	x( 7); \
+	x( 6); \
+	x( 5); \
+	x( 4); \
+	x( 3); \
+	x( 2); \
+	x( 1); \
+	x( 0);
+
+#define PLUS_ONE_0	 1
+#define PLUS_ONE_1	 2
+#define PLUS_ONE_2	 3
+#define PLUS_ONE_3	 4
+#define PLUS_ONE_4	 5
+#define PLUS_ONE_5	 6
+#define PLUS_ONE_6	 7
+#define PLUS_ONE_7	 8
+#define PLUS_ONE_8	 9
+#define PLUS_ONE_9	10
+#define PLUS_ONE_10	11
+#define PLUS_ONE_11	12
+#define PLUS_ONE_12	13
+#define PLUS_ONE_13	14
+#define PLUS_ONE_14	15
+#define PLUS_ONE_15	16
+#define PLUS_ONE(x)	PLUS_ONE_ ## x
+#define _CONCAT3(a,b,c)	a ## b ## c
+#define CONCAT3(a,b,c)	_CONCAT3(a,b,c)
+
+#define STORE_UNALIGNED(x) \
+CONCAT3(.Lchacha20_mips_xor_unaligned_, PLUS_ONE(x), _b: ;) \
+	.if (x != 12); \
+		lw	T0, (x*4)(STATE); \
+	.endif; \
+	lwl	T1, (x*4)+MSB ## (IN); \
+	lwr	T1, (x*4)+LSB ## (IN); \
+	.if (x == 12); \
+		addu	X ## x, NONCE_0; \
+	.else; \
+		addu	X ## x, T0; \
+	.endif; \
+	CPU_TO_LE32(X ## x); \
+	xor	X ## x, T1; \
+	swl	X ## x, (x*4)+MSB ## (OUT); \
+	swr	X ## x, (x*4)+LSB ## (OUT);
+
+#define STORE_ALIGNED(x) \
+CONCAT3(.Lchacha20_mips_xor_aligned_, PLUS_ONE(x), _b: ;) \
+	.if (x != 12); \
+		lw	T0, (x*4)(STATE); \
+	.endif; \
+	lw	T1, (x*4) ## (IN); \
+	.if (x == 12); \
+		addu	X ## x, NONCE_0; \
+	.else; \
+		addu	X ## x, T0; \
+	.endif; \
+	CPU_TO_LE32(X ## x); \
+	xor	X ## x, T1; \
+	sw	X ## x, (x*4) ## (OUT);
+
+/* Jump table macro.
+ * Used for setup and handling the last bytes, which are not multiple of 4.
+ * X15 is free to store Xn
+ * Every jumptable entry must be equal in size.
+ */
+#define JMPTBL_ALIGNED(x) \
+.Lchacha20_mips_jmptbl_aligned_ ## x: ; \
+	.set	noreorder; \
+	b	.Lchacha20_mips_xor_aligned_ ## x ## _b; \
+	.if (x == 12); \
+		addu	SAVED_X, X ## x, NONCE_0; \
+	.else; \
+		addu	SAVED_X, X ## x, SAVED_CA; \
+	.endif; \
+	.set	reorder
+
+#define JMPTBL_UNALIGNED(x) \
+.Lchacha20_mips_jmptbl_unaligned_ ## x: ; \
+	.set	noreorder; \
+	b	.Lchacha20_mips_xor_unaligned_ ## x ## _b; \
+	.if (x == 12); \
+		addu	SAVED_X, X ## x, NONCE_0; \
+	.else; \
+		addu	SAVED_X, X ## x, SAVED_CA; \
+	.endif; \
+	.set	reorder
+
+#define AXR(A, B, C, D,  K, L, M, N,  V, W, Y, Z,  S) \
+	addu	X(A), X(K); \
+	addu	X(B), X(L); \
+	addu	X(C), X(M); \
+	addu	X(D), X(N); \
+	xor	X(V), X(A); \
+	xor	X(W), X(B); \
+	xor	X(Y), X(C); \
+	xor	X(Z), X(D); \
+	rotl	X(V), S;    \
+	rotl	X(W), S;    \
+	rotl	X(Y), S;    \
+	rotl	X(Z), S;
+
+.text
+.set	reorder
+.set	noat
+.globl	chacha20_mips
+.ent	chacha20_mips
+chacha20_mips:
+	.frame	$sp, STACK_SIZE, $ra
+
+	addiu	$sp, -STACK_SIZE
+
+	/* Return bytes = 0. */
+	beqz	BYTES, .Lchacha20_mips_end
+
+	lw	NONCE_0, 48(STATE)
+
+	/* Save s0-s7 */
+	sw	$s0,  0($sp)
+	sw	$s1,  4($sp)
+	sw	$s2,  8($sp)
+	sw	$s3, 12($sp)
+	sw	$s4, 16($sp)
+	sw	$s5, 20($sp)
+	sw	$s6, 24($sp)
+	sw	$s7, 28($sp)
+
+	/* Test IN or OUT is unaligned.
+	 * IS_UNALIGNED = ( IN | OUT ) & 0x00000003
+	 */
+	or	IS_UNALIGNED, IN, OUT
+	andi	IS_UNALIGNED, 0x3
+
+	/* Set number of rounds */
+	li	$at, 20
+
+	b	.Lchacha20_rounds_start
+
+.align 4
+.Loop_chacha20_rounds:
+	addiu	IN,  CHACHA20_BLOCK_SIZE
+	addiu	OUT, CHACHA20_BLOCK_SIZE
+	addiu	NONCE_0, 1
+
+.Lchacha20_rounds_start:
+	lw	X0,  0(STATE)
+	lw	X1,  4(STATE)
+	lw	X2,  8(STATE)
+	lw	X3,  12(STATE)
+
+	lw	X4,  16(STATE)
+	lw	X5,  20(STATE)
+	lw	X6,  24(STATE)
+	lw	X7,  28(STATE)
+	lw	X8,  32(STATE)
+	lw	X9,  36(STATE)
+	lw	X10, 40(STATE)
+	lw	X11, 44(STATE)
+
+	move	X12, NONCE_0
+	lw	X13, 52(STATE)
+	lw	X14, 56(STATE)
+	lw	X15, 60(STATE)
+
+.Loop_chacha20_xor_rounds:
+	addiu	$at, -2
+	AXR( 0, 1, 2, 3,  4, 5, 6, 7, 12,13,14,15, 16);
+	AXR( 8, 9,10,11, 12,13,14,15,  4, 5, 6, 7, 12);
+	AXR( 0, 1, 2, 3,  4, 5, 6, 7, 12,13,14,15,  8);
+	AXR( 8, 9,10,11, 12,13,14,15,  4, 5, 6, 7,  7);
+	AXR( 0, 1, 2, 3,  5, 6, 7, 4, 15,12,13,14, 16);
+	AXR(10,11, 8, 9, 15,12,13,14,  5, 6, 7, 4, 12);
+	AXR( 0, 1, 2, 3,  5, 6, 7, 4, 15,12,13,14,  8);
+	AXR(10,11, 8, 9, 15,12,13,14,  5, 6, 7, 4,  7);
+	bnez	$at, .Loop_chacha20_xor_rounds
+
+	addiu	BYTES, -(CHACHA20_BLOCK_SIZE)
+
+	/* Is data src/dst unaligned? Jump */
+	bnez	IS_UNALIGNED, .Loop_chacha20_unaligned
+
+	/* Set number rounds here to fill delayslot. */
+	li	$at, 20
+
+	/* BYTES < 0, it has no full block. */
+	bltz	BYTES, .Lchacha20_mips_no_full_block_aligned
+
+	FOR_EACH_WORD_REV(STORE_ALIGNED)
+
+	/* BYTES > 0? Loop again. */
+	bgtz	BYTES, .Loop_chacha20_rounds
+
+	/* Place this here to fill delay slot */
+	addiu	NONCE_0, 1
+
+	/* BYTES < 0? Handle last bytes */
+	bltz	BYTES, .Lchacha20_mips_xor_bytes
+
+.Lchacha20_mips_xor_done:
+	/* Restore used registers */
+	lw	$s0,  0($sp)
+	lw	$s1,  4($sp)
+	lw	$s2,  8($sp)
+	lw	$s3, 12($sp)
+	lw	$s4, 16($sp)
+	lw	$s5, 20($sp)
+	lw	$s6, 24($sp)
+	lw	$s7, 28($sp)
+
+	/* Write NONCE_0 back to right location in state */
+	sw	NONCE_0, 48(STATE)
+
+.Lchacha20_mips_end:
+	addiu	$sp, STACK_SIZE
+	jr	$ra
+
+.Lchacha20_mips_no_full_block_aligned:
+	/* Restore the offset on BYTES */
+	addiu	BYTES, CHACHA20_BLOCK_SIZE
+
+	/* Get number of full WORDS */
+	andi	$at, BYTES, MASK_U32
+
+	/* Load upper half of jump table addr */
+	lui	T0, %hi(.Lchacha20_mips_jmptbl_aligned_0)
+
+	/* Calculate lower half jump table offset */
+	ins	T0, $at, 1, 6
+
+	/* Add offset to STATE */
+	addu	T1, STATE, $at
+
+	/* Add lower half jump table addr */
+	addiu	T0, %lo(.Lchacha20_mips_jmptbl_aligned_0)
+
+	/* Read value from STATE */
+	lw	SAVED_CA, 0(T1)
+
+	/* Store remaining bytecounter as negative value */
+	subu	BYTES, $at, BYTES
+
+	jr	T0
+
+	/* Jump table */
+	FOR_EACH_WORD(JMPTBL_ALIGNED)
+
+
+.Loop_chacha20_unaligned:
+	/* Set number rounds here to fill delayslot. */
+	li	$at, 20
+
+	/* BYTES > 0, it has no full block. */
+	bltz	BYTES, .Lchacha20_mips_no_full_block_unaligned
+
+	FOR_EACH_WORD_REV(STORE_UNALIGNED)
+
+	/* BYTES > 0? Loop again. */
+	bgtz	BYTES, .Loop_chacha20_rounds
+
+	/* Write NONCE_0 back to right location in state */
+	sw	NONCE_0, 48(STATE)
+
+	.set noreorder
+	/* Fall through to byte handling */
+	bgez	BYTES, .Lchacha20_mips_xor_done
+.Lchacha20_mips_xor_unaligned_0_b:
+.Lchacha20_mips_xor_aligned_0_b:
+	/* Place this here to fill delay slot */
+	addiu	NONCE_0, 1
+	.set reorder
+
+.Lchacha20_mips_xor_bytes:
+	addu	IN, $at
+	addu	OUT, $at
+	/* First byte */
+	lbu	T1, 0(IN)
+	addiu	$at, BYTES, 1
+	CPU_TO_LE32(SAVED_X)
+	ROTR(SAVED_X)
+	xor	T1, SAVED_X
+	sb	T1, 0(OUT)
+	beqz	$at, .Lchacha20_mips_xor_done
+	/* Second byte */
+	lbu	T1, 1(IN)
+	addiu	$at, BYTES, 2
+	ROTx	SAVED_X, 8
+	xor	T1, SAVED_X
+	sb	T1, 1(OUT)
+	beqz	$at, .Lchacha20_mips_xor_done
+	/* Third byte */
+	lbu	T1, 2(IN)
+	ROTx	SAVED_X, 8
+	xor	T1, SAVED_X
+	sb	T1, 2(OUT)
+	b	.Lchacha20_mips_xor_done
+
+.Lchacha20_mips_no_full_block_unaligned:
+	/* Restore the offset on BYTES */
+	addiu	BYTES, CHACHA20_BLOCK_SIZE
+
+	/* Get number of full WORDS */
+	andi	$at, BYTES, MASK_U32
+
+	/* Load upper half of jump table addr */
+	lui	T0, %hi(.Lchacha20_mips_jmptbl_unaligned_0)
+
+	/* Calculate lower half jump table offset */
+	ins	T0, $at, 1, 6
+
+	/* Add offset to STATE */
+	addu	T1, STATE, $at
+
+	/* Add lower half jump table addr */
+	addiu	T0, %lo(.Lchacha20_mips_jmptbl_unaligned_0)
+
+	/* Read value from STATE */
+	lw	SAVED_CA, 0(T1)
+
+	/* Store remaining bytecounter as negative value */
+	subu	BYTES, $at, BYTES
+
+	jr	T0
+
+	/* Jump table */
+	FOR_EACH_WORD(JMPTBL_UNALIGNED)
+.end chacha20_mips
+.set at
-- 
2.20.1

