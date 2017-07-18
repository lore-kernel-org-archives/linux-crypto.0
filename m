From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 5/8] crypto: arm/aes - avoid expanded lookup tables in the final round
Date: Tue, 18 Jul 2017 13:06:42 +0100
Message-ID: <20170718120645.15880-6-ard.biesheuvel@linaro.org>
References: <20170718120645.15880-1-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        nico@linaro.org, ebiggers@google.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f179.google.com ([209.85.128.179]:34929 "EHLO
        mail-wr0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751378AbdGRMHI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jul 2017 08:07:08 -0400
Received: by mail-wr0-f179.google.com with SMTP id w4so25816743wrb.2
        for <linux-crypto@vger.kernel.org>; Tue, 18 Jul 2017 05:07:08 -0700 (PDT)
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
rely on the core AES module for the shared key expansion routines.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/aes-cipher-core.S | 51 ++++++++++----------
 1 file changed, 26 insertions(+), 25 deletions(-)

diff --git a/arch/arm/crypto/aes-cipher-core.S b/arch/arm/crypto/aes-cipher-core.S
index a727692cd9c1..5e9ddc576ec1 100644
--- a/arch/arm/crypto/aes-cipher-core.S
+++ b/arch/arm/crypto/aes-cipher-core.S
@@ -33,19 +33,19 @@
 	.endif
 	.endm
 
-	.macro		__load, out, in, idx
+	.macro		__load, out, in, idx, sz, op
 	.if		__LINUX_ARM_ARCH__ < 7 && \idx > 0
-	ldr		\out, [ttab, \in, lsr #(8 * \idx) - 2]
+	ldr\op		\out, [ttab, \in, lsr #(8 * \idx) - \sz]
 	.else
-	ldr		\out, [ttab, \in, lsl #2]
+	ldr\op		\out, [ttab, \in, lsl #\sz]
 	.endif
 	.endm
 
-	.macro		__hround, out0, out1, in0, in1, in2, in3, t3, t4, enc
+	.macro		__hround, out0, out1, in0, in1, in2, in3, t3, t4, enc, sz, op
 	__select	\out0, \in0, 0
 	__select	t0, \in1, 1
-	__load		\out0, \out0, 0
-	__load		t0, t0, 1
+	__load		\out0, \out0, 0, \sz, \op
+	__load		t0, t0, 1, \sz, \op
 
 	.if		\enc
 	__select	\out1, \in1, 0
@@ -54,10 +54,10 @@
 	__select	\out1, \in3, 0
 	__select	t1, \in0, 1
 	.endif
-	__load		\out1, \out1, 0
+	__load		\out1, \out1, 0, \sz, \op
 	__select	t2, \in2, 2
-	__load		t1, t1, 1
-	__load		t2, t2, 2
+	__load		t1, t1, 1, \sz, \op
+	__load		t2, t2, 2, \sz, \op
 
 	eor		\out0, \out0, t0, ror #24
 
@@ -69,9 +69,9 @@
 	__select	\t3, \in1, 2
 	__select	\t4, \in2, 3
 	.endif
-	__load		\t3, \t3, 2
-	__load		t0, t0, 3
-	__load		\t4, \t4, 3
+	__load		\t3, \t3, 2, \sz, \op
+	__load		t0, t0, 3, \sz, \op
+	__load		\t4, \t4, 3, \sz, \op
 
 	eor		\out1, \out1, t1, ror #24
 	eor		\out0, \out0, t2, ror #16
@@ -83,14 +83,14 @@
 	eor		\out1, \out1, t2
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
 
 	.macro		__rev, out, in
@@ -115,7 +115,7 @@
 	.endif
 	.endm
 
-	.macro		do_crypt, round, ttab, ltab
+	.macro		do_crypt, round, ttab, ltab, bsz
 	push		{r3-r11, lr}
 
 	ldr		r4, [in]
@@ -147,9 +147,12 @@
 
 1:	subs		rounds, rounds, #4
 	\round		r8, r9, r10, r11, r4, r5, r6, r7
-	__adrl		ttab, \ltab, ls
+	bls		2f
 	\round		r4, r5, r6, r7, r8, r9, r10, r11
-	bhi		0b
+	b		0b
+
+2:	__adrl		ttab, \ltab
+	\round		r4, r5, r6, r7, r8, r9, r10, r11, \bsz, b
 
 #ifdef CONFIG_CPU_BIG_ENDIAN
 	__rev		r4, r4
@@ -173,14 +176,12 @@
 
 	.align			6
 	aes_table_reduced	crypto_ft_tab
-	aes_table_reduced	crypto_fl_tab
 	aes_table_reduced	crypto_it_tab
-	aes_table_reduced	crypto_il_tab
 
 ENTRY(__aes_arm_encrypt)
-	do_crypt	fround, crypto_ft_tab, crypto_fl_tab
+	do_crypt	fround, crypto_ft_tab, crypto_ft_tab + 1, 2
 ENDPROC(__aes_arm_encrypt)
 
 ENTRY(__aes_arm_decrypt)
-	do_crypt	iround, crypto_it_tab, crypto_il_tab
+	do_crypt	iround, crypto_it_tab, crypto_aes_inv_sbox, 0
 ENDPROC(__aes_arm_decrypt)
-- 
2.9.3
