Return-Path: <SRS0=Ic7o=YK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 697E1FA372A
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Oct 2019 19:10:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2516621925
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Oct 2019 19:10:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MrdkDQWG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503391AbfJQTKM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Oct 2019 15:10:12 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39615 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503389AbfJQTKM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Oct 2019 15:10:12 -0400
Received: by mail-wr1-f68.google.com with SMTP id r3so3601536wrj.6
        for <linux-crypto@vger.kernel.org>; Thu, 17 Oct 2019 12:10:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=P3r0SNveEzz6kBEf2u//BowK+MATklg4k02/2yYEq4I=;
        b=MrdkDQWGOkQlbhbp1xeNS9nh4EBAjlZkAXbNgUP7aWXf5m1R+q3bSpdCa0FQVRV1Zl
         8NBuGOw2Bf0t9a/M7hO0FkNFYRzlt1OUYDAQZHF1Tovedlt9UaTMLXYcW7OQfagiFFtz
         +3013jquhkcTlDmoMjE+iSCa0n0kTJI0B4Yoqxedt5gTSghy3mM1ZVRpMBBzE9JCT6n9
         Ow362fJgj6071RQQCrlyVx2kFZufYkzJvMTCpugCzs0B1/hxOoIldILF0TqSWrBFipEj
         0MYPVmb2US/aUR4lKa797GYjfMOL82t6bl8SaQChUAu4s4BkD2lNyVwxEaSnBcK+tbhX
         9KeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=P3r0SNveEzz6kBEf2u//BowK+MATklg4k02/2yYEq4I=;
        b=BTXXaBRBrd5MK8RH02qo2xu4oBgrb+JWzqzDtDx2GlerJC+JG6PSj4EaaUITN4unSx
         OBBzSYnaSmP9J+JHqIrdcoKNiGJ1nVAyJswXkb1DXYPGuoYYZvby/nvAilUAT989bGwY
         OkzIJjTqz9DfPpkzdmIeUkj7Y1SwOgJrf9Kn2IU0XYyj2qe1bc3cWgpzKogEGgWTNJSt
         +knJWYKjl4OAD/BDsNGl5/k58qrFmTdwgduFYQkZMUAgt7JpEbH+Amnlfu/tvjOrNWU3
         J6SpF1WNJS6QsEDLgjFok9szxCLKarafvXyqjNLAI+K1p6MGzoeYXJAoZR4mSKykAEwn
         kOsA==
X-Gm-Message-State: APjAAAUhmhk7uaEzjHruBKh2dF3T/SamYcYDXxyMqN71qDZioA5R+PGT
        IsNzK/1MpeYXhay+6T53tkSb5wIDmAAEdM/k
X-Google-Smtp-Source: APXvYqzlbu0U57EzlMcH9Rx3A4TXg3aPEcskO8vXZu+fwWT90rzklLaV7lG/eGvIf+90b70TeuYwUQ==
X-Received: by 2002:adf:f342:: with SMTP id e2mr4642072wrp.61.1571339408546;
        Thu, 17 Oct 2019 12:10:08 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:ccb6:e9d4:c1bc:d107])
        by smtp.gmail.com with ESMTPSA id y3sm5124528wro.36.2019.10.17.12.10.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Oct 2019 12:10:07 -0700 (PDT)
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
Subject: [PATCH v4 11/35] crypto: mips/chacha - wire up accelerated 32r2 code from Zinc
Date:   Thu, 17 Oct 2019 21:09:08 +0200
Message-Id: <20191017190932.1947-12-ard.biesheuvel@linaro.org>
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
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/mips/Makefile             |   2 +-
 arch/mips/crypto/Makefile      |   4 +
 arch/mips/crypto/chacha-core.S | 159 +++++++++++++------
 arch/mips/crypto/chacha-glue.c | 162 ++++++++++++++++++++
 crypto/Kconfig                 |   6 +
 5 files changed, 289 insertions(+), 44 deletions(-)

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
index e07aca572c2e..b528b9d300f1 100644
--- a/arch/mips/crypto/Makefile
+++ b/arch/mips/crypto/Makefile
@@ -4,3 +4,7 @@
 #
 
 obj-$(CONFIG_CRYPTO_CRC32_MIPS) += crc32-mips.o
+
+obj-$(CONFIG_CRYPTO_CHACHA_MIPS) += chacha-mips.o
+chacha-mips-y := chacha-core.o chacha-glue.o
+AFLAGS_chacha-core.o += -O2 # needed to fill branch delay slots
diff --git a/arch/mips/crypto/chacha-core.S b/arch/mips/crypto/chacha-core.S
index a81e02db95e7..5755f69cfe00 100644
--- a/arch/mips/crypto/chacha-core.S
+++ b/arch/mips/crypto/chacha-core.S
@@ -125,7 +125,7 @@
 #define CONCAT3(a,b,c)	_CONCAT3(a,b,c)
 
 #define STORE_UNALIGNED(x) \
-CONCAT3(.Lchacha20_mips_xor_unaligned_, PLUS_ONE(x), _b: ;) \
+CONCAT3(.Lchacha_mips_xor_unaligned_, PLUS_ONE(x), _b: ;) \
 	.if (x != 12); \
 		lw	T0, (x*4)(STATE); \
 	.endif; \
@@ -142,7 +142,7 @@ CONCAT3(.Lchacha20_mips_xor_unaligned_, PLUS_ONE(x), _b: ;) \
 	swr	X ## x, (x*4)+LSB ## (OUT);
 
 #define STORE_ALIGNED(x) \
-CONCAT3(.Lchacha20_mips_xor_aligned_, PLUS_ONE(x), _b: ;) \
+CONCAT3(.Lchacha_mips_xor_aligned_, PLUS_ONE(x), _b: ;) \
 	.if (x != 12); \
 		lw	T0, (x*4)(STATE); \
 	.endif; \
@@ -162,9 +162,9 @@ CONCAT3(.Lchacha20_mips_xor_aligned_, PLUS_ONE(x), _b: ;) \
  * Every jumptable entry must be equal in size.
  */
 #define JMPTBL_ALIGNED(x) \
-.Lchacha20_mips_jmptbl_aligned_ ## x: ; \
+.Lchacha_mips_jmptbl_aligned_ ## x: ; \
 	.set	noreorder; \
-	b	.Lchacha20_mips_xor_aligned_ ## x ## _b; \
+	b	.Lchacha_mips_xor_aligned_ ## x ## _b; \
 	.if (x == 12); \
 		addu	SAVED_X, X ## x, NONCE_0; \
 	.else; \
@@ -173,9 +173,9 @@ CONCAT3(.Lchacha20_mips_xor_aligned_, PLUS_ONE(x), _b: ;) \
 	.set	reorder
 
 #define JMPTBL_UNALIGNED(x) \
-.Lchacha20_mips_jmptbl_unaligned_ ## x: ; \
+.Lchacha_mips_jmptbl_unaligned_ ## x: ; \
 	.set	noreorder; \
-	b	.Lchacha20_mips_xor_unaligned_ ## x ## _b; \
+	b	.Lchacha_mips_xor_unaligned_ ## x ## _b; \
 	.if (x == 12); \
 		addu	SAVED_X, X ## x, NONCE_0; \
 	.else; \
@@ -200,15 +200,18 @@ CONCAT3(.Lchacha20_mips_xor_aligned_, PLUS_ONE(x), _b: ;) \
 .text
 .set	reorder
 .set	noat
-.globl	chacha20_mips
-.ent	chacha20_mips
-chacha20_mips:
+.globl	chacha_crypt_arch
+.ent	chacha_crypt_arch
+chacha_crypt_arch:
 	.frame	$sp, STACK_SIZE, $ra
 
+	/* Load number of rounds */
+	lw	$at, 16($sp)
+
 	addiu	$sp, -STACK_SIZE
 
 	/* Return bytes = 0. */
-	beqz	BYTES, .Lchacha20_mips_end
+	beqz	BYTES, .Lchacha_mips_end
 
 	lw	NONCE_0, 48(STATE)
 
@@ -228,18 +231,15 @@ chacha20_mips:
 	or	IS_UNALIGNED, IN, OUT
 	andi	IS_UNALIGNED, 0x3
 
-	/* Set number of rounds */
-	li	$at, 20
-
-	b	.Lchacha20_rounds_start
+	b	.Lchacha_rounds_start
 
 .align 4
-.Loop_chacha20_rounds:
+.Loop_chacha_rounds:
 	addiu	IN,  CHACHA20_BLOCK_SIZE
 	addiu	OUT, CHACHA20_BLOCK_SIZE
 	addiu	NONCE_0, 1
 
-.Lchacha20_rounds_start:
+.Lchacha_rounds_start:
 	lw	X0,  0(STATE)
 	lw	X1,  4(STATE)
 	lw	X2,  8(STATE)
@@ -259,7 +259,7 @@ chacha20_mips:
 	lw	X14, 56(STATE)
 	lw	X15, 60(STATE)
 
-.Loop_chacha20_xor_rounds:
+.Loop_chacha_xor_rounds:
 	addiu	$at, -2
 	AXR( 0, 1, 2, 3,  4, 5, 6, 7, 12,13,14,15, 16);
 	AXR( 8, 9,10,11, 12,13,14,15,  4, 5, 6, 7, 12);
@@ -269,31 +269,31 @@ chacha20_mips:
 	AXR(10,11, 8, 9, 15,12,13,14,  5, 6, 7, 4, 12);
 	AXR( 0, 1, 2, 3,  5, 6, 7, 4, 15,12,13,14,  8);
 	AXR(10,11, 8, 9, 15,12,13,14,  5, 6, 7, 4,  7);
-	bnez	$at, .Loop_chacha20_xor_rounds
+	bnez	$at, .Loop_chacha_xor_rounds
 
 	addiu	BYTES, -(CHACHA20_BLOCK_SIZE)
 
 	/* Is data src/dst unaligned? Jump */
-	bnez	IS_UNALIGNED, .Loop_chacha20_unaligned
+	bnez	IS_UNALIGNED, .Loop_chacha_unaligned
 
 	/* Set number rounds here to fill delayslot. */
-	li	$at, 20
+	lw	$at, (STACK_SIZE+16)($sp)
 
 	/* BYTES < 0, it has no full block. */
-	bltz	BYTES, .Lchacha20_mips_no_full_block_aligned
+	bltz	BYTES, .Lchacha_mips_no_full_block_aligned
 
 	FOR_EACH_WORD_REV(STORE_ALIGNED)
 
 	/* BYTES > 0? Loop again. */
-	bgtz	BYTES, .Loop_chacha20_rounds
+	bgtz	BYTES, .Loop_chacha_rounds
 
 	/* Place this here to fill delay slot */
 	addiu	NONCE_0, 1
 
 	/* BYTES < 0? Handle last bytes */
-	bltz	BYTES, .Lchacha20_mips_xor_bytes
+	bltz	BYTES, .Lchacha_mips_xor_bytes
 
-.Lchacha20_mips_xor_done:
+.Lchacha_mips_xor_done:
 	/* Restore used registers */
 	lw	$s0,  0($sp)
 	lw	$s1,  4($sp)
@@ -307,11 +307,11 @@ chacha20_mips:
 	/* Write NONCE_0 back to right location in state */
 	sw	NONCE_0, 48(STATE)
 
-.Lchacha20_mips_end:
+.Lchacha_mips_end:
 	addiu	$sp, STACK_SIZE
 	jr	$ra
 
-.Lchacha20_mips_no_full_block_aligned:
+.Lchacha_mips_no_full_block_aligned:
 	/* Restore the offset on BYTES */
 	addiu	BYTES, CHACHA20_BLOCK_SIZE
 
@@ -319,7 +319,7 @@ chacha20_mips:
 	andi	$at, BYTES, MASK_U32
 
 	/* Load upper half of jump table addr */
-	lui	T0, %hi(.Lchacha20_mips_jmptbl_aligned_0)
+	lui	T0, %hi(.Lchacha_mips_jmptbl_aligned_0)
 
 	/* Calculate lower half jump table offset */
 	ins	T0, $at, 1, 6
@@ -328,7 +328,7 @@ chacha20_mips:
 	addu	T1, STATE, $at
 
 	/* Add lower half jump table addr */
-	addiu	T0, %lo(.Lchacha20_mips_jmptbl_aligned_0)
+	addiu	T0, %lo(.Lchacha_mips_jmptbl_aligned_0)
 
 	/* Read value from STATE */
 	lw	SAVED_CA, 0(T1)
@@ -342,31 +342,31 @@ chacha20_mips:
 	FOR_EACH_WORD(JMPTBL_ALIGNED)
 
 
-.Loop_chacha20_unaligned:
+.Loop_chacha_unaligned:
 	/* Set number rounds here to fill delayslot. */
-	li	$at, 20
+	lw	$at, (STACK_SIZE+16)($sp)
 
 	/* BYTES > 0, it has no full block. */
-	bltz	BYTES, .Lchacha20_mips_no_full_block_unaligned
+	bltz	BYTES, .Lchacha_mips_no_full_block_unaligned
 
 	FOR_EACH_WORD_REV(STORE_UNALIGNED)
 
 	/* BYTES > 0? Loop again. */
-	bgtz	BYTES, .Loop_chacha20_rounds
+	bgtz	BYTES, .Loop_chacha_rounds
 
 	/* Write NONCE_0 back to right location in state */
 	sw	NONCE_0, 48(STATE)
 
 	.set noreorder
 	/* Fall through to byte handling */
-	bgez	BYTES, .Lchacha20_mips_xor_done
-.Lchacha20_mips_xor_unaligned_0_b:
-.Lchacha20_mips_xor_aligned_0_b:
+	bgez	BYTES, .Lchacha_mips_xor_done
+.Lchacha_mips_xor_unaligned_0_b:
+.Lchacha_mips_xor_aligned_0_b:
 	/* Place this here to fill delay slot */
 	addiu	NONCE_0, 1
 	.set reorder
 
-.Lchacha20_mips_xor_bytes:
+.Lchacha_mips_xor_bytes:
 	addu	IN, $at
 	addu	OUT, $at
 	/* First byte */
@@ -376,22 +376,22 @@ chacha20_mips:
 	ROTR(SAVED_X)
 	xor	T1, SAVED_X
 	sb	T1, 0(OUT)
-	beqz	$at, .Lchacha20_mips_xor_done
+	beqz	$at, .Lchacha_mips_xor_done
 	/* Second byte */
 	lbu	T1, 1(IN)
 	addiu	$at, BYTES, 2
 	ROTx	SAVED_X, 8
 	xor	T1, SAVED_X
 	sb	T1, 1(OUT)
-	beqz	$at, .Lchacha20_mips_xor_done
+	beqz	$at, .Lchacha_mips_xor_done
 	/* Third byte */
 	lbu	T1, 2(IN)
 	ROTx	SAVED_X, 8
 	xor	T1, SAVED_X
 	sb	T1, 2(OUT)
-	b	.Lchacha20_mips_xor_done
+	b	.Lchacha_mips_xor_done
 
-.Lchacha20_mips_no_full_block_unaligned:
+.Lchacha_mips_no_full_block_unaligned:
 	/* Restore the offset on BYTES */
 	addiu	BYTES, CHACHA20_BLOCK_SIZE
 
@@ -399,7 +399,7 @@ chacha20_mips:
 	andi	$at, BYTES, MASK_U32
 
 	/* Load upper half of jump table addr */
-	lui	T0, %hi(.Lchacha20_mips_jmptbl_unaligned_0)
+	lui	T0, %hi(.Lchacha_mips_jmptbl_unaligned_0)
 
 	/* Calculate lower half jump table offset */
 	ins	T0, $at, 1, 6
@@ -408,7 +408,7 @@ chacha20_mips:
 	addu	T1, STATE, $at
 
 	/* Add lower half jump table addr */
-	addiu	T0, %lo(.Lchacha20_mips_jmptbl_unaligned_0)
+	addiu	T0, %lo(.Lchacha_mips_jmptbl_unaligned_0)
 
 	/* Read value from STATE */
 	lw	SAVED_CA, 0(T1)
@@ -420,5 +420,78 @@ chacha20_mips:
 
 	/* Jump table */
 	FOR_EACH_WORD(JMPTBL_UNALIGNED)
-.end chacha20_mips
+.end chacha_crypt_arch
+.set at
+
+/* Input arguments
+ * STATE	$a0
+ * OUT		$a1
+ * NROUND	$a2
+ */
+
+#undef X12
+#undef X13
+#undef X14
+#undef X15
+
+#define X12	$a3
+#define X13	$at
+#define X14	$v0
+#define X15	STATE
+
+.set noat
+.globl	hchacha_block_arch
+.ent	hchacha_block_arch
+hchacha_block_arch:
+	.frame	$sp, STACK_SIZE, $ra
+
+	addiu	$sp, -STACK_SIZE
+
+	/* Save X11(s6) */
+	sw	X11, 0($sp)
+
+	lw	X0,  0(STATE)
+	lw	X1,  4(STATE)
+	lw	X2,  8(STATE)
+	lw	X3,  12(STATE)
+	lw	X4,  16(STATE)
+	lw	X5,  20(STATE)
+	lw	X6,  24(STATE)
+	lw	X7,  28(STATE)
+	lw	X8,  32(STATE)
+	lw	X9,  36(STATE)
+	lw	X10, 40(STATE)
+	lw	X11, 44(STATE)
+	lw	X12, 48(STATE)
+	lw	X13, 52(STATE)
+	lw	X14, 56(STATE)
+	lw	X15, 60(STATE)
+
+.Loop_hchacha_xor_rounds:
+	addiu	$a2, -2
+	AXR( 0, 1, 2, 3,  4, 5, 6, 7, 12,13,14,15, 16);
+	AXR( 8, 9,10,11, 12,13,14,15,  4, 5, 6, 7, 12);
+	AXR( 0, 1, 2, 3,  4, 5, 6, 7, 12,13,14,15,  8);
+	AXR( 8, 9,10,11, 12,13,14,15,  4, 5, 6, 7,  7);
+	AXR( 0, 1, 2, 3,  5, 6, 7, 4, 15,12,13,14, 16);
+	AXR(10,11, 8, 9, 15,12,13,14,  5, 6, 7, 4, 12);
+	AXR( 0, 1, 2, 3,  5, 6, 7, 4, 15,12,13,14,  8);
+	AXR(10,11, 8, 9, 15,12,13,14,  5, 6, 7, 4,  7);
+	bnez	$a2, .Loop_hchacha_xor_rounds
+
+	/* Restore used register */
+	lw	X11, 0($sp)
+
+	sw	X0,  0(OUT)
+	sw	X1,  4(OUT)
+	sw	X2,  8(OUT)
+	sw	X3,  12(OUT)
+	sw	X12, 16(OUT)
+	sw	X13, 20(OUT)
+	sw	X14, 24(OUT)
+	sw	X15, 28(OUT)
+
+	addiu	$sp, STACK_SIZE
+	jr	$ra
+.end hchacha_block_arch
 .set at
diff --git a/arch/mips/crypto/chacha-glue.c b/arch/mips/crypto/chacha-glue.c
new file mode 100644
index 000000000000..2cf64af9dd89
--- /dev/null
+++ b/arch/mips/crypto/chacha-glue.c
@@ -0,0 +1,162 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * MIPS accelerated ChaCha and XChaCha stream ciphers,
+ * including ChaCha20 (RFC7539)
+ *
+ * Copyright (C) 2019 Linaro, Ltd. <ard.biesheuvel@linaro.org>
+ */
+
+#include <asm/byteorder.h>
+#include <crypto/algapi.h>
+#include <crypto/internal/chacha.h>
+#include <crypto/internal/skcipher.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+asmlinkage void chacha_crypt_arch(u32 *state, u8 *dst, const u8 *src,
+				  unsigned int bytes, int nrounds);
+EXPORT_SYMBOL(chacha_crypt_arch);
+
+asmlinkage void hchacha_block_arch(const u32 *state, u32 *stream, int nrounds);
+EXPORT_SYMBOL(hchacha_block_arch);
+
+void chacha_init_arch(u32 *state, const u32 *key, const u8 *iv)
+{
+	chacha_init_generic(state, key, iv);
+}
+EXPORT_SYMBOL(chacha_init_arch);
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
+	chacha_init_generic(state, ctx->key, iv);
+
+	while (walk.nbytes > 0) {
+		unsigned int nbytes = walk.nbytes;
+
+		if (nbytes < walk.total)
+			nbytes = round_down(nbytes, walk.stride);
+
+		chacha_crypt(state, walk.dst.virt.addr, walk.src.virt.addr,
+			     nbytes, ctx->nrounds);
+		err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
+	}
+
+	return err;
+}
+
+static int chacha_mips(struct skcipher_request *req)
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
+	chacha_init_generic(state, ctx->key, req->iv);
+
+	hchacha_block(state, subctx.key, ctx->nrounds);
+	subctx.nrounds = ctx->nrounds;
+
+	memcpy(&real_iv[0], req->iv + 24, 8);
+	memcpy(&real_iv[8], req->iv + 16, 8);
+	return chacha_mips_stream_xor(req, &subctx, real_iv);
+}
+
+static int chacha20_setkey(struct crypto_skcipher *tfm, const u8 *key,
+		    unsigned int keysize)
+{
+	return chacha_setkey(tfm, key, keysize, 20);
+}
+
+static int chacha12_setkey(struct crypto_skcipher *tfm, const u8 *key,
+		    unsigned int keysize)
+{
+	return chacha_setkey(tfm, key, keysize, 12);
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
+		.setkey			= chacha20_setkey,
+		.encrypt		= chacha_mips,
+		.decrypt		= chacha_mips,
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
+		.setkey			= chacha20_setkey,
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
+		.setkey			= chacha12_setkey,
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
index 4f7212fa0170..46944c6c8f9b 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1423,6 +1423,12 @@ config CRYPTO_CHACHA20_X86_64
 	  SSSE3, AVX2, and AVX-512VL optimized implementations of the ChaCha20,
 	  XChaCha20, and XChaCha12 stream ciphers.
 
+config CRYPTO_CHACHA_MIPS
+	tristate "ChaCha stream cipher algorithms (MIPS 32r2 optimized)"
+	depends on CPU_MIPS32_R2
+	select CRYPTO_BLKCIPHER
+	select CRYPTO_ARCH_HAVE_LIB_CHACHA
+
 config CRYPTO_SEED
 	tristate "SEED cipher algorithm"
 	select CRYPTO_ALGAPI
-- 
2.20.1

