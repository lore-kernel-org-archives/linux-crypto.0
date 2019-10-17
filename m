Return-Path: <SRS0=Ic7o=YK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E58D7ECE58E
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Oct 2019 19:10:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE34921835
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Oct 2019 19:10:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jp+33FRA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503390AbfJQTKL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Oct 2019 15:10:11 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42912 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503322AbfJQTKL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Oct 2019 15:10:11 -0400
Received: by mail-wr1-f66.google.com with SMTP id n14so3579617wrw.9
        for <linux-crypto@vger.kernel.org>; Thu, 17 Oct 2019 12:10:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rWklFTiHrxlus42OzOmzMS995ImAfR7EKggriar/e8M=;
        b=jp+33FRA3WwFrt0BJSyafJffF4jFHogRfH+bFjKjlHozHVG3IR7gTOsGGoL+FThCx2
         /H7cQMtipKotbL05k6LFSravn1fbKDDGtZQJJEbAsvt68jiR8Cirp26gz8XZHBmQdHbU
         QPjDHhAFYml1Oxda8VozQSZgWfhZNU58qnRsiRYPZw2lv6ZQbNnDyu/gBxiYvTJ1HWBp
         EUBpRO4CxNt73wdRVYLTZJS6g9skLiO4wXEJ4488g5MxNZrHJKsLrW9P+mNafMuK+Mju
         hberK/Ch/eQ1R5E4C+pC/oQFMqQejHC+DBzgUeAjDwK+h0TkPcFqc6AIfSC0H7eveCal
         D+IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rWklFTiHrxlus42OzOmzMS995ImAfR7EKggriar/e8M=;
        b=igJEIau5vWpJTvsrFKE3Rvj7p0fxA93xtiPgjq4MS34JUb8Bdvcv6itV09Ogy5nUrw
         h5VLVxIzacZKTkOFSfgNuEGuSGwDVKE0slyUBOwP1cgHTZjA7ZMXUxMF6kfED04/V6dt
         1xMXTsAWcH3ZGmrmzz41RPHScAoL38nMxR9QYO7g9NmsmtfROu8/VZzWbp5DbSYNWJH1
         sbVBOwARvA8FVtm/gpn4gHu3G6blmRoqchy60NvXro0KXCeJqRVy+4qfgh2OtBDPnf2I
         Umix1vP35DaVkGqR32ZAqUlR5momO0cgEedkkLl44aMW+hk8aCRz107waG7JHaH4xMj4
         NPLg==
X-Gm-Message-State: APjAAAWyqmeE2GppEVqYCHqAS818o38dGt9xMWe7MxZJdVcclAx3jo5O
        mAiROXTsubwy+UdfHK4/0uSDh47MdmNejcoH
X-Google-Smtp-Source: APXvYqxF+C3NewSH3BGCzZWdxgbkJ/2+Fgha6XinvmTQSWV0HrsyqIJYAyuv9QIMz4jqE2tkF+0KmQ==
X-Received: by 2002:adf:e886:: with SMTP id d6mr4552462wrm.188.1571339406979;
        Thu, 17 Oct 2019 12:10:06 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:ccb6:e9d4:c1bc:d107])
        by smtp.gmail.com with ESMTPSA id y3sm5124528wro.36.2019.10.17.12.10.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Oct 2019 12:10:06 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Martin Willi <martin@strongswan.org>,
        Rene van Dorst <opensource@vdorst.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH v4 10/35] crypto: mips/chacha - import 32r2 ChaCha code from Zinc
Date:   Thu, 17 Oct 2019 21:09:07 +0200
Message-Id: <20191017190932.1947-11-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191017190932.1947-1-ard.biesheuvel@linaro.org>
References: <20191017190932.1947-1-ard.biesheuvel@linaro.org>
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
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
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

