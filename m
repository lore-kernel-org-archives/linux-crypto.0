From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 6/8] crypto: arm64/aes - avoid expanded lookup tables in the final round
Date: Tue, 18 Jul 2017 13:06:43 +0100
Message-ID: <20170718120645.15880-7-ard.biesheuvel@linaro.org>
References: <20170718120645.15880-1-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        nico@linaro.org, ebiggers@google.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f171.google.com ([209.85.128.171]:34481 "EHLO
        mail-wr0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751371AbdGRMHL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jul 2017 08:07:11 -0400
Received: by mail-wr0-f171.google.com with SMTP id 12so26326657wrb.1
        for <linux-crypto@vger.kernel.org>; Tue, 18 Jul 2017 05:07:11 -0700 (PDT)
In-Reply-To: <20170718120645.15880-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

For the final round, avoid the expanded and padded lookup tables
exported by the generic AES driver. Instead, for encryption, we can
perform byte loads from the same table we used for the inner rounds,
which will still be hot in the caches. For decryption, use the inverse
AES Sbox exported by the generic AES driver, which is 4x smaller than
the inverse table exported by the generic driver.

This significantly reduces the Dcache footprint of our code, and does
not introduce any additional module dependencies, given that we already
rely on the core AES module for the shared key expansion routines. It
also frees up register x18, which is not available as a scratch register
on all platforms, which and so avoiding it improves shareability of this
code.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/aes-cipher-core.S | 155 ++++++++++++++------
 1 file changed, 108 insertions(+), 47 deletions(-)

diff --git a/arch/arm64/crypto/aes-cipher-core.S b/arch/arm64/crypto/aes-cipher-core.S
index bbe5dd96135c..fe807f164d83 100644
--- a/arch/arm64/crypto/aes-cipher-core.S
+++ b/arch/arm64/crypto/aes-cipher-core.S
@@ -18,99 +18,160 @@
 	out		.req	x1
 	in		.req	x2
 	rounds		.req	x3
-	tt		.req	x4
-	lt		.req	x2
+	tt		.req	x2
 
-	.macro		__pair, enc, reg0, reg1, in0, in1e, in1d, shift
+	.macro		__ubf1, reg0, reg1, in0, in1e, in1d, sz, shift
 	ubfx		\reg0, \in0, #\shift, #8
-	.if		\enc
 	ubfx		\reg1, \in1e, #\shift, #8
-	.else
+	.endm
+
+	.macro		__ubf0, reg0, reg1, in0, in1e, in1d, sz, shift
+	ubfx		\reg0, \in0, #\shift, #8
 	ubfx		\reg1, \in1d, #\shift, #8
+	.endm
+
+	.macro		__ubf1b, reg0, reg1, in0, in1e, in1d, sz, shift
+	.if		\shift == 0 && \sz > 0
+	ubfiz		\reg0, \in0, #\sz, #8
+	ubfiz		\reg1, \in1e, #\sz, #8
+	.else
+	__ubf1		\reg0, \reg1, \in0, \in1e, \in1d, \sz, \shift
+	.endif
+	.endm
+
+	.macro		__ubf0b, reg0, reg1, in0, in1e, in1d, sz, shift
+	.if		\shift == 0 && \sz > 0
+	ubfiz		\reg0, \in0, #\sz, #8
+	ubfiz		\reg1, \in1d, #\sz, #8
+	.else
+	__ubf0		\reg0, \reg1, \in0, \in1e, \in1d, \sz, \shift
 	.endif
+	.endm
+
+	/*
+	 * AArch64 cannot do byte size indexed loads from a table containing
+	 * 32-bit quantities, i.e., 'ldrb w12, [tt, w12, uxtw #2]' is not a
+	 * valid instruction.
+	 *
+	 * For shift == 0, we can simply fold the size shift of the index
+	 * into the ubfx instruction, by switcing to ubfiz and using \sz as
+	 * the destination offset.
+	 * For shift > 0, we perform a 32-byte wide load instead, which does
+	 * allow an index shift of 2, and discard the high bytes later using
+	 * uxtb or lsl #24.
+	 */
+	.macro		__pair, enc, sz, op, reg0, reg1, in0, in1e, in1d, shift
+	__ubf\enc\op	\reg0, \reg1, \in0, \in1e, \in1d, \sz, \shift
+	.ifnc		\op\sz, b2
+	ldr\op		\reg0, [tt, \reg0, uxtw #\sz]
+	ldr\op		\reg1, [tt, \reg1, uxtw #\sz]
+	.elseif		\shift == 0
+	ldrb		\reg0, [tt, \reg0, uxtw]
+	ldrb		\reg1, [tt, \reg1, uxtw]
+	.else
 	ldr		\reg0, [tt, \reg0, uxtw #2]
 	ldr		\reg1, [tt, \reg1, uxtw #2]
+	.endif
 	.endm
 
-	.macro		__hround, out0, out1, in0, in1, in2, in3, t0, t1, enc
+	.macro		__hround, out0, out1, in0, in1, in2, in3, t0, t1, enc, sz, op
 	ldp		\out0, \out1, [rk], #8
 
-	__pair		\enc, w13, w14, \in0, \in1, \in3, 0
-	__pair		\enc, w15, w16, \in1, \in2, \in0, 8
-	__pair		\enc, w17, w18, \in2, \in3, \in1, 16
-	__pair		\enc, \t0, \t1, \in3, \in0, \in2, 24
-
-	eor		\out0, \out0, w13
-	eor		\out1, \out1, w14
-	eor		\out0, \out0, w15, ror #24
-	eor		\out1, \out1, w16, ror #24
-	eor		\out0, \out0, w17, ror #16
-	eor		\out1, \out1, w18, ror #16
-	eor		\out0, \out0, \t0, ror #8
-	eor		\out1, \out1, \t1, ror #8
+	__pair		\enc, \sz, \op, w12, w13, \in0, \in1, \in3, 0
+	__pair		\enc, \sz, \op, w14, w15, \in3, \in0, \in2, 24
+	__pair		\enc, \sz, \op, w16, w17, \in2, \in3, \in1, 16
+	__pair		\enc, \sz, \op, \t0, \t1, \in1, \in2, \in0, 8
+
+	eor		\out0, \out0, w12
+	eor		\out1, \out1, w13
+
+	.ifnc		\op\sz, b2
+	eor		\out0, \out0, w14, ror #8
+	eor		\out1, \out1, w15, ror #8
+	.else
+CPU_BE(	lsr		w14, w14, #24		)
+CPU_BE(	lsr		w15, w15, #24		)
+
+	eor		\out0, \out0, w14, lsl #24
+	eor		\out1, \out1, w15, lsl #24
+
+CPU_LE(	uxtb		w16, w16		)
+CPU_LE(	uxtb		w17, w17		)
+CPU_LE(	uxtb		\t0, \t0		)
+CPU_LE(	uxtb		\t1, \t1		)
+
+CPU_BE(	lsr		w16, w16, #24		)
+CPU_BE(	lsr		w17, w17, #24		)
+CPU_BE(	lsr		\t0, \t0, #24		)
+CPU_BE(	lsr		\t1, \t1, #24		)
+	.endif
+
+	eor		\out0, \out0, w16, ror #16
+	eor		\out1, \out1, w17, ror #16
+	eor		\out0, \out0, \t0, ror #24
+	eor		\out1, \out1, \t1, ror #24
 	.endm
 
-	.macro		fround, out0, out1, out2, out3, in0, in1, in2, in3
-	__hround	\out0, \out1, \in0, \in1, \in2, \in3, \out2, \out3, 1
-	__hround	\out2, \out3, \in2, \in3, \in0, \in1, \in1, \in2, 1
+	.macro		fround, out0, out1, out2, out3, in0, in1, in2, in3, sz=2, op
+	__hround	\out0, \out1, \in0, \in1, \in2, \in3, \out2, \out3, 1, \sz, \op
+	__hround	\out2, \out3, \in2, \in3, \in0, \in1, \in1, \in2, 1, \sz, \op
 	.endm
 
-	.macro		iround, out0, out1, out2, out3, in0, in1, in2, in3
-	__hround	\out0, \out1, \in0, \in3, \in2, \in1, \out2, \out3, 0
-	__hround	\out2, \out3, \in2, \in1, \in0, \in3, \in1, \in0, 0
+	.macro		iround, out0, out1, out2, out3, in0, in1, in2, in3, sz=2, op
+	__hround	\out0, \out1, \in0, \in3, \in2, \in1, \out2, \out3, 0, \sz, \op
+	__hround	\out2, \out3, \in2, \in1, \in0, \in3, \in1, \in0, 0, \sz, \op
 	.endm
 
-	.macro		do_crypt, round, ttab, ltab
-	ldp		w5, w6, [in]
-	ldp		w7, w8, [in, #8]
-	ldp		w9, w10, [rk], #16
-	ldp		w11, w12, [rk, #-8]
+	.macro		do_crypt, round, ttab, ltab, bsz
+	ldp		w4, w5, [in]
+	ldp		w6, w7, [in, #8]
+	ldp		w8, w9, [rk], #16
+	ldp		w10, w11, [rk, #-8]
 
+CPU_BE(	rev		w4, w4		)
 CPU_BE(	rev		w5, w5		)
 CPU_BE(	rev		w6, w6		)
 CPU_BE(	rev		w7, w7		)
-CPU_BE(	rev		w8, w8		)
 
+	eor		w4, w4, w8
 	eor		w5, w5, w9
 	eor		w6, w6, w10
 	eor		w7, w7, w11
-	eor		w8, w8, w12
 
 	adr_l		tt, \ttab
-	adr_l		lt, \ltab
 
 	tbnz		rounds, #1, 1f
 
-0:	\round		w9, w10, w11, w12, w5, w6, w7, w8
-	\round		w5, w6, w7, w8, w9, w10, w11, w12
+0:	\round		w8, w9, w10, w11, w4, w5, w6, w7
+	\round		w4, w5, w6, w7, w8, w9, w10, w11
 
 1:	subs		rounds, rounds, #4
-	\round		w9, w10, w11, w12, w5, w6, w7, w8
-	csel		tt, tt, lt, hi
-	\round		w5, w6, w7, w8, w9, w10, w11, w12
-	b.hi		0b
-
+	\round		w8, w9, w10, w11, w4, w5, w6, w7
+	b.ls		3f
+2:	\round		w4, w5, w6, w7, w8, w9, w10, w11
+	b		0b
+3:	adr_l		tt, \ltab
+	\round		w4, w5, w6, w7, w8, w9, w10, w11, \bsz, b
+
+CPU_BE(	rev		w4, w4		)
 CPU_BE(	rev		w5, w5		)
 CPU_BE(	rev		w6, w6		)
 CPU_BE(	rev		w7, w7		)
-CPU_BE(	rev		w8, w8		)
 
-	stp		w5, w6, [out]
-	stp		w7, w8, [out, #8]
+	stp		w4, w5, [out]
+	stp		w6, w7, [out, #8]
 	ret
 	.endm
 
 	.align			7
 	aes_table_reduced	crypto_ft_tab
-	aes_table_reduced	crypto_fl_tab
 	aes_table_reduced	crypto_it_tab
-	aes_table_reduced	crypto_il_tab
 
 ENTRY(__aes_arm64_encrypt)
-	do_crypt	fround, crypto_ft_tab, crypto_fl_tab
+	do_crypt	fround, crypto_ft_tab, crypto_ft_tab + 1, 2
 ENDPROC(__aes_arm64_encrypt)
 
 	.align		5
 ENTRY(__aes_arm64_decrypt)
-	do_crypt	iround, crypto_it_tab, crypto_il_tab
+	do_crypt	iround, crypto_it_tab, crypto_aes_inv_sbox, 0
 ENDPROC(__aes_arm64_decrypt)
-- 
2.9.3
