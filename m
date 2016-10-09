From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 6/6] crypto: arm64/aes-neon - fix for big endian
Date: Sun,  9 Oct 2016 18:42:25 +0100
Message-ID: <1476034945-9186-7-git-send-email-ard.biesheuvel@linaro.org>
References: <1476034945-9186-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: catalin.marinas@arm.com, will.deacon@arm.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:33054 "EHLO
        mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752039AbcJIRmr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 9 Oct 2016 13:42:47 -0400
Received: by mail-lf0-f52.google.com with SMTP id x79so84678629lff.0
        for <linux-crypto@vger.kernel.org>; Sun, 09 Oct 2016 10:42:46 -0700 (PDT)
In-Reply-To: <1476034945-9186-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The AES implementation using pure NEON instructions relies on the generic
AES key schedule generation routines, which store the round keys as arrays
of 32-bit quantities stored in memory using native endianness. This means
we should refer to these round keys using 4x4 loads rather than 16x1 loads.
In addition, the ShiftRows tables are loading using a single scalar load,
which is also affected by endianness, so emit these tables in the correct
order depending on whether we are building for big endian or not.

Fixes: 49788fe2a128 ("arm64/crypto: AES-ECB/CBC/CTR/XTS using ARMv8 NEON and Crypto Extensions")
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/aes-neon.S | 25 ++++++++++++--------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/crypto/aes-neon.S b/arch/arm64/crypto/aes-neon.S
index b93170e1cc93..85f07ead7c5c 100644
--- a/arch/arm64/crypto/aes-neon.S
+++ b/arch/arm64/crypto/aes-neon.S
@@ -9,6 +9,7 @@
  */
 
 #include <linux/linkage.h>
+#include <asm/assembler.h>
 
 #define AES_ENTRY(func)		ENTRY(neon_ ## func)
 #define AES_ENDPROC(func)	ENDPROC(neon_ ## func)
@@ -83,13 +84,13 @@
 	.endm
 
 	.macro		do_block, enc, in, rounds, rk, rkp, i
-	ld1		{v15.16b}, [\rk]
+	ld1		{v15.4s}, [\rk]
 	add		\rkp, \rk, #16
 	mov		\i, \rounds
 1111:	eor		\in\().16b, \in\().16b, v15.16b		/* ^round key */
 	tbl		\in\().16b, {\in\().16b}, v13.16b	/* ShiftRows */
 	sub_bytes	\in
-	ld1		{v15.16b}, [\rkp], #16
+	ld1		{v15.4s}, [\rkp], #16
 	subs		\i, \i, #1
 	beq		2222f
 	.if		\enc == 1
@@ -229,7 +230,7 @@
 	.endm
 
 	.macro		do_block_2x, enc, in0, in1 rounds, rk, rkp, i
-	ld1		{v15.16b}, [\rk]
+	ld1		{v15.4s}, [\rk]
 	add		\rkp, \rk, #16
 	mov		\i, \rounds
 1111:	eor		\in0\().16b, \in0\().16b, v15.16b	/* ^round key */
@@ -237,7 +238,7 @@
 	sub_bytes_2x	\in0, \in1
 	tbl		\in0\().16b, {\in0\().16b}, v13.16b	/* ShiftRows */
 	tbl		\in1\().16b, {\in1\().16b}, v13.16b	/* ShiftRows */
-	ld1		{v15.16b}, [\rkp], #16
+	ld1		{v15.4s}, [\rkp], #16
 	subs		\i, \i, #1
 	beq		2222f
 	.if		\enc == 1
@@ -254,7 +255,7 @@
 	.endm
 
 	.macro		do_block_4x, enc, in0, in1, in2, in3, rounds, rk, rkp, i
-	ld1		{v15.16b}, [\rk]
+	ld1		{v15.4s}, [\rk]
 	add		\rkp, \rk, #16
 	mov		\i, \rounds
 1111:	eor		\in0\().16b, \in0\().16b, v15.16b	/* ^round key */
@@ -266,7 +267,7 @@
 	tbl		\in1\().16b, {\in1\().16b}, v13.16b	/* ShiftRows */
 	tbl		\in2\().16b, {\in2\().16b}, v13.16b	/* ShiftRows */
 	tbl		\in3\().16b, {\in3\().16b}, v13.16b	/* ShiftRows */
-	ld1		{v15.16b}, [\rkp], #16
+	ld1		{v15.4s}, [\rkp], #16
 	subs		\i, \i, #1
 	beq		2222f
 	.if		\enc == 1
@@ -306,12 +307,16 @@
 	.text
 	.align		4
 .LForward_ShiftRows:
-	.byte		0x0, 0x5, 0xa, 0xf, 0x4, 0x9, 0xe, 0x3
-	.byte		0x8, 0xd, 0x2, 0x7, 0xc, 0x1, 0x6, 0xb
+CPU_LE(	.byte		0x0, 0x5, 0xa, 0xf, 0x4, 0x9, 0xe, 0x3	)
+CPU_LE(	.byte		0x8, 0xd, 0x2, 0x7, 0xc, 0x1, 0x6, 0xb	)
+CPU_BE(	.byte		0xb, 0x6, 0x1, 0xc, 0x7, 0x2, 0xd, 0x8	)
+CPU_BE(	.byte		0x3, 0xe, 0x9, 0x4, 0xf, 0xa, 0x5, 0x0	)
 
 .LReverse_ShiftRows:
-	.byte		0x0, 0xd, 0xa, 0x7, 0x4, 0x1, 0xe, 0xb
-	.byte		0x8, 0x5, 0x2, 0xf, 0xc, 0x9, 0x6, 0x3
+CPU_LE(	.byte		0x0, 0xd, 0xa, 0x7, 0x4, 0x1, 0xe, 0xb	)
+CPU_LE(	.byte		0x8, 0x5, 0x2, 0xf, 0xc, 0x9, 0x6, 0x3	)
+CPU_BE(	.byte		0x3, 0x6, 0x9, 0xc, 0xf, 0x2, 0x5, 0x8	)
+CPU_BE(	.byte		0xb, 0xe, 0x1, 0x4, 0x7, 0xa, 0xd, 0x0	)
 
 .LForward_Sbox:
 	.byte		0x63, 0x7c, 0x77, 0x7b, 0xf2, 0x6b, 0x6f, 0xc5
-- 
2.7.4
