From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 5/7] arm64/crypto: crct10dif: move literal data to .rodata section
Date: Wed, 10 Jan 2018 12:11:40 +0000
Message-ID: <20180110121142.18291-6-ard.biesheuvel@linaro.org>
References: <20180110121142.18291-1-ard.biesheuvel@linaro.org>
Cc: herbert@gondor.apana.org.au, will.deacon@arm.com,
        catalin.marinas@arm.com, marc.zyngier@arm.com,
        mark.rutland@arm.com, dann.frazier@canonical.com,
        steve.capper@linaro.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:36333 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964973AbeAJMNo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Jan 2018 07:13:44 -0500
Received: by mail-wr0-f196.google.com with SMTP id d9so1830589wre.3
        for <linux-crypto@vger.kernel.org>; Wed, 10 Jan 2018 04:13:43 -0800 (PST)
In-Reply-To: <20180110121142.18291-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Move the CRC-T10DIF literal data to the .rodata section where it is
safe from being exploited by speculative execution.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/crct10dif-ce-core.S | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/crypto/crct10dif-ce-core.S b/arch/arm64/crypto/crct10dif-ce-core.S
index d5b5a8c038c8..f179c01bd55c 100644
--- a/arch/arm64/crypto/crct10dif-ce-core.S
+++ b/arch/arm64/crypto/crct10dif-ce-core.S
@@ -128,7 +128,7 @@ CPU_LE(	ext		v7.16b, v7.16b, v7.16b, #8	)
 	// XOR the initial_crc value
 	eor		v0.16b, v0.16b, v10.16b
 
-	ldr		q10, rk3	// xmm10 has rk3 and rk4
+	ldr_l		q10, rk3, x8	// xmm10 has rk3 and rk4
 					// type of pmull instruction
 					// will determine which constant to use
 
@@ -184,13 +184,13 @@ CPU_LE(	ext		v12.16b, v12.16b, v12.16b, #8	)
 	// fold the 8 vector registers to 1 vector register with different
 	// constants
 
-	ldr		q10, rk9
+	ldr_l		q10, rk9, x8
 
 	.macro		fold16, reg, rk
 	pmull		v8.1q, \reg\().1d, v10.1d
 	pmull2		\reg\().1q, \reg\().2d, v10.2d
 	.ifnb		\rk
-	ldr		q10, \rk
+	ldr_l		q10, \rk, x8
 	.endif
 	eor		v7.16b, v7.16b, v8.16b
 	eor		v7.16b, v7.16b, \reg\().16b
@@ -251,7 +251,7 @@ CPU_LE(	ext		v1.16b, v1.16b, v1.16b, #8	)
 
 	// get rid of the extra data that was loaded before
 	// load the shift constant
-	adr		x4, tbl_shf_table + 16
+	adr_l		x4, tbl_shf_table + 16
 	sub		x4, x4, arg3
 	ld1		{v0.16b}, [x4]
 
@@ -275,7 +275,7 @@ CPU_LE(	ext		v1.16b, v1.16b, v1.16b, #8	)
 
 _128_done:
 	// compute crc of a 128-bit value
-	ldr		q10, rk5		// rk5 and rk6 in xmm10
+	ldr_l		q10, rk5, x8		// rk5 and rk6 in xmm10
 
 	// 64b fold
 	ext		v0.16b, vzr.16b, v7.16b, #8
@@ -291,7 +291,7 @@ _128_done:
 
 	// barrett reduction
 _barrett:
-	ldr		q10, rk7
+	ldr_l		q10, rk7, x8
 	mov		v0.d[0], v7.d[1]
 
 	pmull		v0.1q, v0.1d, v10.1d
@@ -321,7 +321,7 @@ CPU_LE(	ext		v7.16b, v7.16b, v7.16b, #8	)
 	b.eq		_128_done		// exactly 16 left
 	b.lt		_less_than_16_left
 
-	ldr		q10, rk1		// rk1 and rk2 in xmm10
+	ldr_l		q10, rk1, x8		// rk1 and rk2 in xmm10
 
 	// update the counter. subtract 32 instead of 16 to save one
 	// instruction from the loop
@@ -333,7 +333,7 @@ CPU_LE(	ext		v7.16b, v7.16b, v7.16b, #8	)
 
 _less_than_16_left:
 	// shl r9, 4
-	adr		x0, tbl_shf_table + 16
+	adr_l		x0, tbl_shf_table + 16
 	sub		x0, x0, arg3
 	ld1		{v0.16b}, [x0]
 	movi		v9.16b, #0x80
@@ -345,6 +345,7 @@ ENDPROC(crc_t10dif_pmull)
 // precomputed constants
 // these constants are precomputed from the poly:
 // 0x8bb70000 (0x8bb7 scaled to 32 bits)
+	.section	".rodata", "a"
 	.align		4
 // Q = 0x18BB70000
 // rk1 = 2^(32*3) mod Q << 32
-- 
2.11.0
