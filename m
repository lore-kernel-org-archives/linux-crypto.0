Return-Path: <SRS0=UbUg=X3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F536C35280
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Oct 2019 14:17:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C18C721D7B
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Oct 2019 14:17:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="VcqlHLve"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727750AbfJBORu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Oct 2019 10:17:50 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:34020 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727647AbfJBORu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Oct 2019 10:17:50 -0400
Received: by mail-wm1-f67.google.com with SMTP id y135so5043071wmc.1
        for <linux-crypto@vger.kernel.org>; Wed, 02 Oct 2019 07:17:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=coAWaRSKi0UufjMCPROX1vufusbLbFwLMAdOm8AUAbg=;
        b=VcqlHLveVzS/i+x01l4c8IeKDBIDcla4rUcuQMTDepfCw3NUOtDDlpNvNVm0QdeuLn
         yh3GsAg48QM7KvqniPWJzzndgCNuqY/8zcv9mu5JsPW/bKebi1lZsYSmAfI2xhf5KY7U
         k+JchADBqamHLv+qCRAd6sourzCVGUI7WWHcHB+Km1P+ffwh0yd1kU77BLj8fAj9qbgw
         a/dtMdLUC0KokF/9bRAoq0Mcb/9Mnpzyo++uhLqNKBAXKte4twA/R+MKBaf0nMNidcnQ
         7qdQySTDGiA1SL4JyHK49PRXbXZEfTod5IPsG1uuY+RPB7cfFZ278Alp14fMPGUq//Zs
         sSLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=coAWaRSKi0UufjMCPROX1vufusbLbFwLMAdOm8AUAbg=;
        b=SyAmW5hBDYPQXxd/u+CQW591J+5qFgnO1LnNIg8edNO93eEFb1sWI3BYHV73coKTOi
         q8aWxmYuEQDlHapXdUl9HObt6OiqYmD0DP2VeW8ndtaCttFegvtfVbCXBKSzw07JyYf/
         jJ7spS5jznyhpiMVCmxY8qTNwMxOAWiRfS4abz/XUj6+T6KwUtdcFJIsB/IJKypApSAR
         2l9I0aI9pdIHNCbHsfjlufKSjsyyNBFp9tl+9p0SQ6hpsduDoYusszk7lPJQDn/kTsN9
         vs64StS3pr4dxEHFnckZVcmDM0ui+JYWswTuXVxIqIhaNAC/NPc/5wGG6mroamb2U4z0
         2tVw==
X-Gm-Message-State: APjAAAXNGNFH4xzPyBqX27pcom8cKSFY1aEjIjvfbjbghiI0yL7BC0e6
        XCgJb1C83wWLO8eMZieGF/yqlKLRkpS8diEv
X-Google-Smtp-Source: APXvYqwyEw9PZSSP2iSOyvs7cRX6pCi1bf7s0h65Zz0jlxMV23kBvOYYrFe/4rmNZi9GS5tth7HcKw==
X-Received: by 2002:a1c:c506:: with SMTP id v6mr2893693wmf.160.1570025865677;
        Wed, 02 Oct 2019 07:17:45 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:f145:3252:fc29:76c9])
        by smtp.gmail.com with ESMTPSA id t13sm41078149wra.70.2019.10.02.07.17.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 02 Oct 2019 07:17:44 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Martin Willi <martin@strongswan.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
Subject: [PATCH v2 05/20] crypto: mips/chacha - import accelerated 32r2 code from Zinc
Date:   Wed,  2 Oct 2019 16:16:58 +0200
Message-Id: <20191002141713.31189-6-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191002141713.31189-1-ard.biesheuvel@linaro.org>
References: <20191002141713.31189-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This integrates the accelerated MIPS 32r2 implementation of ChaCha
into both the API and library interfaces of the kernel crypto stack.

The significance of this is that, in addition to becoming available
as an accelerated library implementation, it can also be used by
existing crypto API code such as Adiantum (for block encryption on
ultra low performance cores) or IPsec using chacha20poly1305. These
are use cases that have already opted into using the abstract crypto
API. In order to support Adiantum, the core assembler routine has
been adapted to take the round count as a function argument rather
than hardcoding it to 20.

Co-developed-by: René van Dorst <opensource@vdorst.com>
Signed-off-by: René van Dorst <opensource@vdorst.com>
Co-developed-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/mips/Makefile             |   2 +-
 arch/mips/crypto/Makefile      |   3 +
 arch/mips/crypto/chacha-core.S | 424 ++++++++++++++++++++
 arch/mips/crypto/chacha-glue.c | 161 ++++++++
 crypto/Kconfig                 |   6 +
 5 files changed, 595 insertions(+), 1 deletion(-)

diff --git a/arch/mips/Makefile b/arch/mips/Makefile
index cdc09b71febe..8584c047ea59 100644
--- a/arch/mips/Makefile
+++ b/arch/mips/Makefile
@@ -323,7 +323,7 @@ libs-$(CONFIG_MIPS_FP_SUPPORT) += arch/mips/math-emu/
 # See arch/mips/Kbuild for content of core part of the kernel
 core-y += arch/mips/
 
-drivers-$(CONFIG_MIPS_CRC_SUPPORT) += arch/mips/crypto/
+drivers-y			+= arch/mips/crypto/
 drivers-$(CONFIG_OPROFILE)	+= arch/mips/oprofile/
 
 # suspend and hibernation support
diff --git a/arch/mips/crypto/Makefile b/arch/mips/crypto/Makefile
index e07aca572c2e..7f7ea0020cc2 100644
--- a/arch/mips/crypto/Makefile
+++ b/arch/mips/crypto/Makefile
@@ -4,3 +4,6 @@
 #
 
 obj-$(CONFIG_CRYPTO_CRC32_MIPS) += crc32-mips.o
+
+obj-$(CONFIG_CRYPTO_CHACHA_MIPS) += chacha-mips.o
+chacha-mips-y := chacha-core.o chacha-glue.o
diff --git a/arch/mips/crypto/chacha-core.S b/arch/mips/crypto/chacha-core.S
new file mode 100644
index 000000000000..42150d15fc88
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
+CONCAT3(.Lchacha_mips_xor_unaligned_, PLUS_ONE(x), _b: ;) \
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
+CONCAT3(.Lchacha_mips_xor_aligned_, PLUS_ONE(x), _b: ;) \
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
+.Lchacha_mips_jmptbl_aligned_ ## x: ; \
+	.set	noreorder; \
+	b	.Lchacha_mips_xor_aligned_ ## x ## _b; \
+	.if (x == 12); \
+		addu	SAVED_X, X ## x, NONCE_0; \
+	.else; \
+		addu	SAVED_X, X ## x, SAVED_CA; \
+	.endif; \
+	.set	reorder
+
+#define JMPTBL_UNALIGNED(x) \
+.Lchacha_mips_jmptbl_unaligned_ ## x: ; \
+	.set	noreorder; \
+	b	.Lchacha_mips_xor_unaligned_ ## x ## _b; \
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
+.globl	chacha_mips
+.ent	chacha_mips
+chacha_mips:
+	.frame	$sp, STACK_SIZE, $ra
+
+	/* Load number of rounds */
+	lw	$at, 16($sp)
+
+	addiu	$sp, -STACK_SIZE
+
+	/* Return bytes = 0. */
+	beqz	BYTES, .Lchacha_mips_end
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
+	b	.Lchacha_rounds_start
+
+.align 4
+.Loop_chacha_rounds:
+	addiu	IN,  CHACHA20_BLOCK_SIZE
+	addiu	OUT, CHACHA20_BLOCK_SIZE
+	addiu	NONCE_0, 1
+
+.Lchacha_rounds_start:
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
+.Loop_chacha_xor_rounds:
+	addiu	$at, -2
+	AXR( 0, 1, 2, 3,  4, 5, 6, 7, 12,13,14,15, 16);
+	AXR( 8, 9,10,11, 12,13,14,15,  4, 5, 6, 7, 12);
+	AXR( 0, 1, 2, 3,  4, 5, 6, 7, 12,13,14,15,  8);
+	AXR( 8, 9,10,11, 12,13,14,15,  4, 5, 6, 7,  7);
+	AXR( 0, 1, 2, 3,  5, 6, 7, 4, 15,12,13,14, 16);
+	AXR(10,11, 8, 9, 15,12,13,14,  5, 6, 7, 4, 12);
+	AXR( 0, 1, 2, 3,  5, 6, 7, 4, 15,12,13,14,  8);
+	AXR(10,11, 8, 9, 15,12,13,14,  5, 6, 7, 4,  7);
+	bnez	$at, .Loop_chacha_xor_rounds
+
+	addiu	BYTES, -(CHACHA20_BLOCK_SIZE)
+
+	/* Is data src/dst unaligned? Jump */
+	bnez	IS_UNALIGNED, .Loop_chacha_unaligned
+
+	/* Set number rounds here to fill delayslot. */
+	lw	$at, (STACK_SIZE+16)($sp)
+
+	/* BYTES < 0, it has no full block. */
+	bltz	BYTES, .Lchacha_mips_no_full_block_aligned
+
+	FOR_EACH_WORD_REV(STORE_ALIGNED)
+
+	/* BYTES > 0? Loop again. */
+	bgtz	BYTES, .Loop_chacha_rounds
+
+	/* Place this here to fill delay slot */
+	addiu	NONCE_0, 1
+
+	/* BYTES < 0? Handle last bytes */
+	bltz	BYTES, .Lchacha_mips_xor_bytes
+
+.Lchacha_mips_xor_done:
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
+.Lchacha_mips_end:
+	addiu	$sp, STACK_SIZE
+	jr	$ra
+
+.Lchacha_mips_no_full_block_aligned:
+	/* Restore the offset on BYTES */
+	addiu	BYTES, CHACHA20_BLOCK_SIZE
+
+	/* Get number of full WORDS */
+	andi	$at, BYTES, MASK_U32
+
+	/* Load upper half of jump table addr */
+	lui	T0, %hi(.Lchacha_mips_jmptbl_aligned_0)
+
+	/* Calculate lower half jump table offset */
+	ins	T0, $at, 1, 6
+
+	/* Add offset to STATE */
+	addu	T1, STATE, $at
+
+	/* Add lower half jump table addr */
+	addiu	T0, %lo(.Lchacha_mips_jmptbl_aligned_0)
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
+.Loop_chacha_unaligned:
+	/* Set number rounds here to fill delayslot. */
+	lw	$at, (STACK_SIZE+16)($sp)
+
+	/* BYTES > 0, it has no full block. */
+	bltz	BYTES, .Lchacha_mips_no_full_block_unaligned
+
+	FOR_EACH_WORD_REV(STORE_UNALIGNED)
+
+	/* BYTES > 0? Loop again. */
+	bgtz	BYTES, .Loop_chacha_rounds
+
+	/* Write NONCE_0 back to right location in state */
+	sw	NONCE_0, 48(STATE)
+
+	.set noreorder
+	/* Fall through to byte handling */
+	bgez	BYTES, .Lchacha_mips_xor_done
+.Lchacha_mips_xor_unaligned_0_b:
+.Lchacha_mips_xor_aligned_0_b:
+	/* Place this here to fill delay slot */
+	addiu	NONCE_0, 1
+	.set reorder
+
+.Lchacha_mips_xor_bytes:
+	addu	IN, $at
+	addu	OUT, $at
+	/* First byte */
+	lbu	T1, 0(IN)
+	addiu	$at, BYTES, 1
+	CPU_TO_LE32(SAVED_X)
+	ROTR(SAVED_X)
+	xor	T1, SAVED_X
+	sb	T1, 0(OUT)
+	beqz	$at, .Lchacha_mips_xor_done
+	/* Second byte */
+	lbu	T1, 1(IN)
+	addiu	$at, BYTES, 2
+	ROTx	SAVED_X, 8
+	xor	T1, SAVED_X
+	sb	T1, 1(OUT)
+	beqz	$at, .Lchacha_mips_xor_done
+	/* Third byte */
+	lbu	T1, 2(IN)
+	ROTx	SAVED_X, 8
+	xor	T1, SAVED_X
+	sb	T1, 2(OUT)
+	b	.Lchacha_mips_xor_done
+
+.Lchacha_mips_no_full_block_unaligned:
+	/* Restore the offset on BYTES */
+	addiu	BYTES, CHACHA20_BLOCK_SIZE
+
+	/* Get number of full WORDS */
+	andi	$at, BYTES, MASK_U32
+
+	/* Load upper half of jump table addr */
+	lui	T0, %hi(.Lchacha_mips_jmptbl_unaligned_0)
+
+	/* Calculate lower half jump table offset */
+	ins	T0, $at, 1, 6
+
+	/* Add offset to STATE */
+	addu	T1, STATE, $at
+
+	/* Add lower half jump table addr */
+	addiu	T0, %lo(.Lchacha_mips_jmptbl_unaligned_0)
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
+.end chacha_mips
+.set at
diff --git a/arch/mips/crypto/chacha-glue.c b/arch/mips/crypto/chacha-glue.c
new file mode 100644
index 000000000000..de01dc57751e
--- /dev/null
+++ b/arch/mips/crypto/chacha-glue.c
@@ -0,0 +1,161 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * MIPS accelerated ChaCha and XChaCha stream ciphers,
+ * including ChaCha20 (RFC7539)
+ *
+ * Copyright (C) 2019 Linaro, Ltd. <ard.biesheuvel@linaro.org>
+ */
+
+#include <crypto/algapi.h>
+#include <crypto/internal/chacha.h>
+#include <crypto/internal/skcipher.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+asmlinkage void chacha_mips(const u32 *state, u8 *dst, const u8 *src,
+			    unsigned int bytes, int nrounds);
+
+void hchacha_block(const u32 *state, u32 *stream, int nrounds)
+{
+	hchacha_block_generic(state, stream, nrounds);
+}
+EXPORT_SYMBOL(hchacha_block);
+
+void chacha_init(u32 *state, const u32 *key, const u8 *iv)
+{
+	chacha_init_generic(state, key, iv);
+}
+EXPORT_SYMBOL(chacha_init);
+
+void chacha_crypt(u32 *state, u8 *dst, const u8 *src, unsigned int bytes,
+		  int nrounds)
+{
+	chacha_mips(state, dst, src, bytes, nrounds);
+}
+EXPORT_SYMBOL(chacha_crypt);
+
+static int chacha_mips_stream_xor(struct skcipher_request *req,
+				  const struct chacha_ctx *ctx, const u8 *iv)
+{
+	struct skcipher_walk walk;
+	u32 state[16];
+	int err;
+
+	err = skcipher_walk_virt(&walk, req, false);
+
+	crypto_chacha_init(state, ctx, iv);
+
+	while (walk.nbytes > 0) {
+		unsigned int nbytes = walk.nbytes;
+
+		if (nbytes < walk.total)
+			nbytes = round_down(nbytes, walk.stride);
+
+		chacha_mips(state, walk.dst.virt.addr, walk.src.virt.addr,
+			    nbytes, ctx->nrounds);
+		err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
+	}
+
+	return err;
+}
+
+static int __chacha_mips(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
+
+	return chacha_mips_stream_xor(req, ctx, req->iv);
+}
+
+static int xchacha_mips(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct chacha_ctx subctx;
+	u32 state[16];
+	u8 real_iv[16];
+
+	crypto_chacha_init(state, ctx, req->iv);
+
+	hchacha_block_generic(state, subctx.key, ctx->nrounds);
+	subctx.nrounds = ctx->nrounds;
+
+	memcpy(&real_iv[0], req->iv + 24, 8);
+	memcpy(&real_iv[8], req->iv + 16, 8);
+	return chacha_mips_stream_xor(req, &subctx, real_iv);
+}
+
+static struct skcipher_alg algs[] = {
+	{
+		.base.cra_name		= "chacha20",
+		.base.cra_driver_name	= "chacha20-mips",
+		.base.cra_priority	= 200,
+		.base.cra_blocksize	= 1,
+		.base.cra_ctxsize	= sizeof(struct chacha_ctx),
+		.base.cra_module	= THIS_MODULE,
+
+		.min_keysize		= CHACHA_KEY_SIZE,
+		.max_keysize		= CHACHA_KEY_SIZE,
+		.ivsize			= CHACHA_IV_SIZE,
+		.chunksize		= CHACHA_BLOCK_SIZE,
+		.walksize		= 4 * CHACHA_BLOCK_SIZE,
+		.setkey			= crypto_chacha20_setkey,
+		.encrypt		= __chacha_mips,
+		.decrypt		= __chacha_mips,
+	}, {
+		.base.cra_name		= "xchacha20",
+		.base.cra_driver_name	= "xchacha20-mips",
+		.base.cra_priority	= 200,
+		.base.cra_blocksize	= 1,
+		.base.cra_ctxsize	= sizeof(struct chacha_ctx),
+		.base.cra_module	= THIS_MODULE,
+
+		.min_keysize		= CHACHA_KEY_SIZE,
+		.max_keysize		= CHACHA_KEY_SIZE,
+		.ivsize			= XCHACHA_IV_SIZE,
+		.chunksize		= CHACHA_BLOCK_SIZE,
+		.walksize		= 4 * CHACHA_BLOCK_SIZE,
+		.setkey			= crypto_chacha20_setkey,
+		.encrypt		= xchacha_mips,
+		.decrypt		= xchacha_mips,
+	}, {
+		.base.cra_name		= "xchacha12",
+		.base.cra_driver_name	= "xchacha12-mips",
+		.base.cra_priority	= 200,
+		.base.cra_blocksize	= 1,
+		.base.cra_ctxsize	= sizeof(struct chacha_ctx),
+		.base.cra_module	= THIS_MODULE,
+
+		.min_keysize		= CHACHA_KEY_SIZE,
+		.max_keysize		= CHACHA_KEY_SIZE,
+		.ivsize			= XCHACHA_IV_SIZE,
+		.chunksize		= CHACHA_BLOCK_SIZE,
+		.walksize		= 4 * CHACHA_BLOCK_SIZE,
+		.setkey			= crypto_chacha12_setkey,
+		.encrypt		= xchacha_mips,
+		.decrypt		= xchacha_mips,
+	}
+};
+
+static int __init chacha_simd_mod_init(void)
+{
+	return crypto_register_skciphers(algs, ARRAY_SIZE(algs));
+}
+
+static void __exit chacha_simd_mod_fini(void)
+{
+	crypto_unregister_skciphers(algs, ARRAY_SIZE(algs));
+}
+
+module_init(chacha_simd_mod_init);
+module_exit(chacha_simd_mod_fini);
+
+MODULE_DESCRIPTION("ChaCha and XChaCha stream ciphers (MIPS accelerated)");
+MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS_CRYPTO("chacha20");
+MODULE_ALIAS_CRYPTO("chacha20-mips");
+MODULE_ALIAS_CRYPTO("xchacha20");
+MODULE_ALIAS_CRYPTO("xchacha20-mips");
+MODULE_ALIAS_CRYPTO("xchacha12");
+MODULE_ALIAS_CRYPTO("xchacha12-mips");
diff --git a/crypto/Kconfig b/crypto/Kconfig
index f90b53a526ba..43e94ac5d117 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1441,6 +1441,12 @@ config CRYPTO_CHACHA20_X86_64
 	  SSSE3, AVX2, and AVX-512VL optimized implementations of the ChaCha20,
 	  XChaCha20, and XChaCha12 stream ciphers.
 
+config CRYPTO_CHACHA_MIPS
+	tristate "ChaCha stream cipher algorithms (MIPS 32r2 optimized)"
+	depends on CPU_MIPS32_R2
+	select CRYPTO_CHACHA20
+	select CRYPTO_ARCH_HAVE_LIB_CHACHA
+
 config CRYPTO_SEED
 	tristate "SEED cipher algorithm"
 	select CRYPTO_ALGAPI
-- 
2.20.1

