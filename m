Return-Path: <SRS0=wDfx=ON=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41348 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726391AbeLDNNq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Dec 2018 08:13:46 -0500
Received: by mail-wr1-f68.google.com with SMTP id x10so15900596wrs.8
        for <linux-crypto@vger.kernel.org>; Tue, 04 Dec 2018 05:13:43 -0800 (PST)
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Martin Willi <martin@strongswan.org>
Subject: [PATCH v2 3/3] crypto: arm64/chacha - use combined SIMD/ALU routine for more speed
Date: Tue,  4 Dec 2018 14:13:33 +0100
Message-Id: <20181204131333.15046-4-ard.biesheuvel@linaro.org>
In-Reply-To: <20181204131333.15046-1-ard.biesheuvel@linaro.org>
References: <20181204131333.15046-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

To some degree, most known AArch64 micro-architectures appear to be
able to issue ALU instructions in parellel to SIMD instructions
without affecting the SIMD throughput. This means we can use the ALU
to process a fifth ChaCha block while the SIMD is processing four
blocks in parallel.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/chacha-neon-core.S | 235 ++++++++++++++++++--
 arch/arm64/crypto/chacha-neon-glue.c |  39 ++--
 2 files changed, 239 insertions(+), 35 deletions(-)

diff --git a/arch/arm64/crypto/chacha-neon-core.S b/arch/arm64/crypto/chacha-neon-core.S
index 32086709e6b3..534e0a3fafa4 100644
--- a/arch/arm64/crypto/chacha-neon-core.S
+++ b/arch/arm64/crypto/chacha-neon-core.S
@@ -1,13 +1,13 @@
 /*
  * ChaCha/XChaCha NEON helper functions
  *
- * Copyright (C) 2016 Linaro, Ltd. <ard.biesheuvel@linaro.org>
+ * Copyright (C) 2016-2018 Linaro, Ltd. <ard.biesheuvel@linaro.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  *
- * Based on:
+ * Originally based on:
  * ChaCha20 256-bit cipher algorithm, RFC7539, x64 SSSE3 functions
  *
  * Copyright (C) 2015 Martin Willi
@@ -160,8 +160,27 @@ ENTRY(hchacha_block_neon)
 	ret		x9
 ENDPROC(hchacha_block_neon)
 
+	a0		.req	w12
+	a1		.req	w13
+	a2		.req	w14
+	a3		.req	w15
+	a4		.req	w16
+	a5		.req	w17
+	a6		.req	w19
+	a7		.req	w20
+	a8		.req	w21
+	a9		.req	w22
+	a10		.req	w23
+	a11		.req	w24
+	a12		.req	w25
+	a13		.req	w26
+	a14		.req	w27
+	a15		.req	w28
+
 	.align		6
 ENTRY(chacha_4block_xor_neon)
+	frame_push	10
+
 	// x0: Input state matrix, s
 	// x1: 4 data blocks output, o
 	// x2: 4 data blocks input, i
@@ -181,6 +200,9 @@ ENTRY(chacha_4block_xor_neon)
 	// matrix by interleaving 32- and then 64-bit words, which allows us to
 	// do XOR in NEON registers.
 	//
+	// At the same time, a fifth block is encrypted in parallel using
+	// scalar registers
+	//
 	adr_l		x9, CTRINC		// ... and ROT8
 	ld1		{v30.4s-v31.4s}, [x9]
 
@@ -191,7 +213,24 @@ ENTRY(chacha_4block_xor_neon)
 	ld4r		{ v8.4s-v11.4s}, [x8], #16
 	ld4r		{v12.4s-v15.4s}, [x8]
 
-	// x12 += counter values 0-3
+	mov		a0, v0.s[0]
+	mov		a1, v1.s[0]
+	mov		a2, v2.s[0]
+	mov		a3, v3.s[0]
+	mov		a4, v4.s[0]
+	mov		a5, v5.s[0]
+	mov		a6, v6.s[0]
+	mov		a7, v7.s[0]
+	mov		a8, v8.s[0]
+	mov		a9, v9.s[0]
+	mov		a10, v10.s[0]
+	mov		a11, v11.s[0]
+	mov		a12, v12.s[0]
+	mov		a13, v13.s[0]
+	mov		a14, v14.s[0]
+	mov		a15, v15.s[0]
+
+	// x12 += counter values 1-4
 	add		v12.4s, v12.4s, v30.4s
 
 .Ldoubleround4:
@@ -200,33 +239,53 @@ ENTRY(chacha_4block_xor_neon)
 	// x2 += x6, x14 = rotl32(x14 ^ x2, 16)
 	// x3 += x7, x15 = rotl32(x15 ^ x3, 16)
 	add		v0.4s, v0.4s, v4.4s
+	  add		a0, a0, a4
 	add		v1.4s, v1.4s, v5.4s
+	  add		a1, a1, a5
 	add		v2.4s, v2.4s, v6.4s
+	  add		a2, a2, a6
 	add		v3.4s, v3.4s, v7.4s
+	  add		a3, a3, a7
 
 	eor		v12.16b, v12.16b, v0.16b
+	  eor		a12, a12, a0
 	eor		v13.16b, v13.16b, v1.16b
+	  eor		a13, a13, a1
 	eor		v14.16b, v14.16b, v2.16b
+	  eor		a14, a14, a2
 	eor		v15.16b, v15.16b, v3.16b
+	  eor		a15, a15, a3
 
 	rev32		v12.8h, v12.8h
+	  ror		a12, a12, #16
 	rev32		v13.8h, v13.8h
+	  ror		a13, a13, #16
 	rev32		v14.8h, v14.8h
+	  ror		a14, a14, #16
 	rev32		v15.8h, v15.8h
+	  ror		a15, a15, #16
 
 	// x8 += x12, x4 = rotl32(x4 ^ x8, 12)
 	// x9 += x13, x5 = rotl32(x5 ^ x9, 12)
 	// x10 += x14, x6 = rotl32(x6 ^ x10, 12)
 	// x11 += x15, x7 = rotl32(x7 ^ x11, 12)
 	add		v8.4s, v8.4s, v12.4s
+	  add		a8, a8, a12
 	add		v9.4s, v9.4s, v13.4s
+	  add		a9, a9, a13
 	add		v10.4s, v10.4s, v14.4s
+	  add		a10, a10, a14
 	add		v11.4s, v11.4s, v15.4s
+	  add		a11, a11, a15
 
 	eor		v16.16b, v4.16b, v8.16b
+	  eor		a4, a4, a8
 	eor		v17.16b, v5.16b, v9.16b
+	  eor		a5, a5, a9
 	eor		v18.16b, v6.16b, v10.16b
+	  eor		a6, a6, a10
 	eor		v19.16b, v7.16b, v11.16b
+	  eor		a7, a7, a11
 
 	shl		v4.4s, v16.4s, #12
 	shl		v5.4s, v17.4s, #12
@@ -234,42 +293,66 @@ ENTRY(chacha_4block_xor_neon)
 	shl		v7.4s, v19.4s, #12
 
 	sri		v4.4s, v16.4s, #20
+	  ror		a4, a4, #20
 	sri		v5.4s, v17.4s, #20
+	  ror		a5, a5, #20
 	sri		v6.4s, v18.4s, #20
+	  ror		a6, a6, #20
 	sri		v7.4s, v19.4s, #20
+	  ror		a7, a7, #20
 
 	// x0 += x4, x12 = rotl32(x12 ^ x0, 8)
 	// x1 += x5, x13 = rotl32(x13 ^ x1, 8)
 	// x2 += x6, x14 = rotl32(x14 ^ x2, 8)
 	// x3 += x7, x15 = rotl32(x15 ^ x3, 8)
 	add		v0.4s, v0.4s, v4.4s
+	  add		a0, a0, a4
 	add		v1.4s, v1.4s, v5.4s
+	  add		a1, a1, a5
 	add		v2.4s, v2.4s, v6.4s
+	  add		a2, a2, a6
 	add		v3.4s, v3.4s, v7.4s
+	  add		a3, a3, a7
 
 	eor		v12.16b, v12.16b, v0.16b
+	  eor		a12, a12, a0
 	eor		v13.16b, v13.16b, v1.16b
+	  eor		a13, a13, a1
 	eor		v14.16b, v14.16b, v2.16b
+	  eor		a14, a14, a2
 	eor		v15.16b, v15.16b, v3.16b
+	  eor		a15, a15, a3
 
 	tbl		v12.16b, {v12.16b}, v31.16b
+	  ror		a12, a12, #24
 	tbl		v13.16b, {v13.16b}, v31.16b
+	  ror		a13, a13, #24
 	tbl		v14.16b, {v14.16b}, v31.16b
+	  ror		a14, a14, #24
 	tbl		v15.16b, {v15.16b}, v31.16b
+	  ror		a15, a15, #24
 
 	// x8 += x12, x4 = rotl32(x4 ^ x8, 7)
 	// x9 += x13, x5 = rotl32(x5 ^ x9, 7)
 	// x10 += x14, x6 = rotl32(x6 ^ x10, 7)
 	// x11 += x15, x7 = rotl32(x7 ^ x11, 7)
 	add		v8.4s, v8.4s, v12.4s
+	  add		a8, a8, a12
 	add		v9.4s, v9.4s, v13.4s
+	  add		a9, a9, a13
 	add		v10.4s, v10.4s, v14.4s
+	  add		a10, a10, a14
 	add		v11.4s, v11.4s, v15.4s
+	  add		a11, a11, a15
 
 	eor		v16.16b, v4.16b, v8.16b
+	  eor		a4, a4, a8
 	eor		v17.16b, v5.16b, v9.16b
+	  eor		a5, a5, a9
 	eor		v18.16b, v6.16b, v10.16b
+	  eor		a6, a6, a10
 	eor		v19.16b, v7.16b, v11.16b
+	  eor		a7, a7, a11
 
 	shl		v4.4s, v16.4s, #7
 	shl		v5.4s, v17.4s, #7
@@ -277,42 +360,66 @@ ENTRY(chacha_4block_xor_neon)
 	shl		v7.4s, v19.4s, #7
 
 	sri		v4.4s, v16.4s, #25
+	  ror		a4, a4, #25
 	sri		v5.4s, v17.4s, #25
+	  ror		a5, a5, #25
 	sri		v6.4s, v18.4s, #25
+	 ror		a6, a6, #25
 	sri		v7.4s, v19.4s, #25
+	  ror		a7, a7, #25
 
 	// x0 += x5, x15 = rotl32(x15 ^ x0, 16)
 	// x1 += x6, x12 = rotl32(x12 ^ x1, 16)
 	// x2 += x7, x13 = rotl32(x13 ^ x2, 16)
 	// x3 += x4, x14 = rotl32(x14 ^ x3, 16)
 	add		v0.4s, v0.4s, v5.4s
+	  add		a0, a0, a5
 	add		v1.4s, v1.4s, v6.4s
+	  add		a1, a1, a6
 	add		v2.4s, v2.4s, v7.4s
+	  add		a2, a2, a7
 	add		v3.4s, v3.4s, v4.4s
+	  add		a3, a3, a4
 
 	eor		v15.16b, v15.16b, v0.16b
+	  eor		a15, a15, a0
 	eor		v12.16b, v12.16b, v1.16b
+	  eor		a12, a12, a1
 	eor		v13.16b, v13.16b, v2.16b
+	  eor		a13, a13, a2
 	eor		v14.16b, v14.16b, v3.16b
+	  eor		a14, a14, a3
 
 	rev32		v15.8h, v15.8h
+	  ror		a15, a15, #16
 	rev32		v12.8h, v12.8h
+	  ror		a12, a12, #16
 	rev32		v13.8h, v13.8h
+	  ror		a13, a13, #16
 	rev32		v14.8h, v14.8h
+	  ror		a14, a14, #16
 
 	// x10 += x15, x5 = rotl32(x5 ^ x10, 12)
 	// x11 += x12, x6 = rotl32(x6 ^ x11, 12)
 	// x8 += x13, x7 = rotl32(x7 ^ x8, 12)
 	// x9 += x14, x4 = rotl32(x4 ^ x9, 12)
 	add		v10.4s, v10.4s, v15.4s
+	  add		a10, a10, a15
 	add		v11.4s, v11.4s, v12.4s
+	  add		a11, a11, a12
 	add		v8.4s, v8.4s, v13.4s
+	  add		a8, a8, a13
 	add		v9.4s, v9.4s, v14.4s
+	  add		a9, a9, a14
 
 	eor		v16.16b, v5.16b, v10.16b
+	  eor		a5, a5, a10
 	eor		v17.16b, v6.16b, v11.16b
+	  eor		a6, a6, a11
 	eor		v18.16b, v7.16b, v8.16b
+	  eor		a7, a7, a8
 	eor		v19.16b, v4.16b, v9.16b
+	  eor		a4, a4, a9
 
 	shl		v5.4s, v16.4s, #12
 	shl		v6.4s, v17.4s, #12
@@ -320,42 +427,66 @@ ENTRY(chacha_4block_xor_neon)
 	shl		v4.4s, v19.4s, #12
 
 	sri		v5.4s, v16.4s, #20
+	  ror		a5, a5, #20
 	sri		v6.4s, v17.4s, #20
+	  ror		a6, a6, #20
 	sri		v7.4s, v18.4s, #20
+	  ror		a7, a7, #20
 	sri		v4.4s, v19.4s, #20
+	  ror		a4, a4, #20
 
 	// x0 += x5, x15 = rotl32(x15 ^ x0, 8)
 	// x1 += x6, x12 = rotl32(x12 ^ x1, 8)
 	// x2 += x7, x13 = rotl32(x13 ^ x2, 8)
 	// x3 += x4, x14 = rotl32(x14 ^ x3, 8)
 	add		v0.4s, v0.4s, v5.4s
+	  add		a0, a0, a5
 	add		v1.4s, v1.4s, v6.4s
+	  add		a1, a1, a6
 	add		v2.4s, v2.4s, v7.4s
+	  add		a2, a2, a7
 	add		v3.4s, v3.4s, v4.4s
+	  add		a3, a3, a4
 
 	eor		v15.16b, v15.16b, v0.16b
+	  eor		a15, a15, a0
 	eor		v12.16b, v12.16b, v1.16b
+	  eor		a12, a12, a1
 	eor		v13.16b, v13.16b, v2.16b
+	  eor		a13, a13, a2
 	eor		v14.16b, v14.16b, v3.16b
+	  eor		a14, a14, a3
 
 	tbl		v15.16b, {v15.16b}, v31.16b
+	  ror		a15, a15, #24
 	tbl		v12.16b, {v12.16b}, v31.16b
+	  ror		a12, a12, #24
 	tbl		v13.16b, {v13.16b}, v31.16b
+	  ror		a13, a13, #24
 	tbl		v14.16b, {v14.16b}, v31.16b
+	  ror		a14, a14, #24
 
 	// x10 += x15, x5 = rotl32(x5 ^ x10, 7)
 	// x11 += x12, x6 = rotl32(x6 ^ x11, 7)
 	// x8 += x13, x7 = rotl32(x7 ^ x8, 7)
 	// x9 += x14, x4 = rotl32(x4 ^ x9, 7)
 	add		v10.4s, v10.4s, v15.4s
+	  add		a10, a10, a15
 	add		v11.4s, v11.4s, v12.4s
+	  add		a11, a11, a12
 	add		v8.4s, v8.4s, v13.4s
+	  add		a8, a8, a13
 	add		v9.4s, v9.4s, v14.4s
+	  add		a9, a9, a14
 
 	eor		v16.16b, v5.16b, v10.16b
+	  eor		a5, a5, a10
 	eor		v17.16b, v6.16b, v11.16b
+	  eor		a6, a6, a11
 	eor		v18.16b, v7.16b, v8.16b
+	  eor		a7, a7, a8
 	eor		v19.16b, v4.16b, v9.16b
+	  eor		a4, a4, a9
 
 	shl		v5.4s, v16.4s, #7
 	shl		v6.4s, v17.4s, #7
@@ -363,9 +494,13 @@ ENTRY(chacha_4block_xor_neon)
 	shl		v4.4s, v19.4s, #7
 
 	sri		v5.4s, v16.4s, #25
+	  ror		a5, a5, #25
 	sri		v6.4s, v17.4s, #25
+	  ror		a6, a6, #25
 	sri		v7.4s, v18.4s, #25
+	  ror		a7, a7, #25
 	sri		v4.4s, v19.4s, #25
+	  ror		a4, a4, #25
 
 	subs		w3, w3, #2
 	b.ne		.Ldoubleround4
@@ -381,9 +516,17 @@ ENTRY(chacha_4block_xor_neon)
 	// x2[0-3] += s0[2]
 	// x3[0-3] += s0[3]
 	add		v0.4s, v0.4s, v16.4s
+	  mov		w6, v16.s[0]
+	  mov		w7, v17.s[0]
 	add		v1.4s, v1.4s, v17.4s
+	  mov		w8, v18.s[0]
+	  mov		w9, v19.s[0]
 	add		v2.4s, v2.4s, v18.4s
+	  add		a0, a0, w6
+	  add		a1, a1, w7
 	add		v3.4s, v3.4s, v19.4s
+	  add		a2, a2, w8
+	  add		a3, a3, w9
 
 	ld4r		{v24.4s-v27.4s}, [x0], #16
 	ld4r		{v28.4s-v31.4s}, [x0]
@@ -393,48 +536,96 @@ ENTRY(chacha_4block_xor_neon)
 	// x6[0-3] += s1[2]
 	// x7[0-3] += s1[3]
 	add		v4.4s, v4.4s, v20.4s
+	  mov		w6, v20.s[0]
+	  mov		w7, v21.s[0]
 	add		v5.4s, v5.4s, v21.4s
+	  mov		w8, v22.s[0]
+	  mov		w9, v23.s[0]
 	add		v6.4s, v6.4s, v22.4s
+	  add		a4, a4, w6
+	  add		a5, a5, w7
 	add		v7.4s, v7.4s, v23.4s
+	  add		a6, a6, w8
+	  add		a7, a7, w9
 
 	// x8[0-3] += s2[0]
 	// x9[0-3] += s2[1]
 	// x10[0-3] += s2[2]
 	// x11[0-3] += s2[3]
 	add		v8.4s, v8.4s, v24.4s
+	  mov		w6, v24.s[0]
+	  mov		w7, v25.s[0]
 	add		v9.4s, v9.4s, v25.4s
+	  mov		w8, v26.s[0]
+	  mov		w9, v27.s[0]
 	add		v10.4s, v10.4s, v26.4s
+	  add		a8, a8, w6
+	  add		a9, a9, w7
 	add		v11.4s, v11.4s, v27.4s
+	  add		a10, a10, w8
+	  add		a11, a11, w9
 
 	// x12[0-3] += s3[0]
 	// x13[0-3] += s3[1]
 	// x14[0-3] += s3[2]
 	// x15[0-3] += s3[3]
 	add		v12.4s, v12.4s, v28.4s
+	  mov		w6, v28.s[0]
+	  mov		w7, v29.s[0]
 	add		v13.4s, v13.4s, v29.4s
+	  mov		w8, v30.s[0]
+	  mov		w9, v31.s[0]
 	add		v14.4s, v14.4s, v30.4s
+	  add		a12, a12, w6
+	  add		a13, a13, w7
 	add		v15.4s, v15.4s, v31.4s
+	  add		a14, a14, w8
+	  add		a15, a15, w9
 
 	// interleave 32-bit words in state n, n+1
+	  ldp		w6, w7, [x2], #64
 	zip1		v16.4s, v0.4s, v1.4s
+	  ldp		w8, w9, [x2, #-56]
+	  eor		a0, a0, w6
 	zip2		v17.4s, v0.4s, v1.4s
+	  eor		a1, a1, w7
 	zip1		v18.4s, v2.4s, v3.4s
+	  eor		a2, a2, w8
 	zip2		v19.4s, v2.4s, v3.4s
+	  eor		a3, a3, w9
+	  ldp		w6, w7, [x2, #-48]
 	zip1		v20.4s, v4.4s, v5.4s
+	  ldp		w8, w9, [x2, #-40]
+	  eor		a4, a4, w6
 	zip2		v21.4s, v4.4s, v5.4s
+	  eor		a5, a5, w7
 	zip1		v22.4s, v6.4s, v7.4s
+	  eor		a6, a6, w8
 	zip2		v23.4s, v6.4s, v7.4s
+	  eor		a7, a7, w9
+	  ldp		w6, w7, [x2, #-32]
 	zip1		v24.4s, v8.4s, v9.4s
+	  ldp		w8, w9, [x2, #-24]
+	  eor		a8, a8, w6
 	zip2		v25.4s, v8.4s, v9.4s
+	  eor		a9, a9, w7
 	zip1		v26.4s, v10.4s, v11.4s
+	  eor		a10, a10, w8
 	zip2		v27.4s, v10.4s, v11.4s
+	  eor		a11, a11, w9
+	  ldp		w6, w7, [x2, #-16]
 	zip1		v28.4s, v12.4s, v13.4s
+	  ldp		w8, w9, [x2, #-8]
+	  eor		a12, a12, w6
 	zip2		v29.4s, v12.4s, v13.4s
+	  eor		a13, a13, w7
 	zip1		v30.4s, v14.4s, v15.4s
+	  eor		a14, a14, w8
 	zip2		v31.4s, v14.4s, v15.4s
+	  eor		a15, a15, w9
 
 	mov		x3, #64
-	subs		x5, x4, #64
+	subs		x5, x4, #128
 	add		x6, x5, x2
 	csel		x3, x3, xzr, ge
 	csel		x2, x2, x6, ge
@@ -442,11 +633,13 @@ ENTRY(chacha_4block_xor_neon)
 	// interleave 64-bit words in state n, n+2
 	zip1		v0.2d, v16.2d, v18.2d
 	zip2		v4.2d, v16.2d, v18.2d
+	  stp		a0, a1, [x1], #64
 	zip1		v8.2d, v17.2d, v19.2d
 	zip2		v12.2d, v17.2d, v19.2d
+	  stp		a2, a3, [x1, #-56]
 	ld1		{v16.16b-v19.16b}, [x2], x3
 
-	subs		x6, x4, #128
+	subs		x6, x4, #192
 	ccmp		x3, xzr, #4, lt
 	add		x7, x6, x2
 	csel		x3, x3, xzr, eq
@@ -454,11 +647,13 @@ ENTRY(chacha_4block_xor_neon)
 
 	zip1		v1.2d, v20.2d, v22.2d
 	zip2		v5.2d, v20.2d, v22.2d
+	  stp		a4, a5, [x1, #-48]
 	zip1		v9.2d, v21.2d, v23.2d
 	zip2		v13.2d, v21.2d, v23.2d
+	  stp		a6, a7, [x1, #-40]
 	ld1		{v20.16b-v23.16b}, [x2], x3
 
-	subs		x7, x4, #192
+	subs		x7, x4, #256
 	ccmp		x3, xzr, #4, lt
 	add		x8, x7, x2
 	csel		x3, x3, xzr, eq
@@ -466,19 +661,23 @@ ENTRY(chacha_4block_xor_neon)
 
 	zip1		v2.2d, v24.2d, v26.2d
 	zip2		v6.2d, v24.2d, v26.2d
+	  stp		a8, a9, [x1, #-32]
 	zip1		v10.2d, v25.2d, v27.2d
 	zip2		v14.2d, v25.2d, v27.2d
+	  stp		a10, a11, [x1, #-24]
 	ld1		{v24.16b-v27.16b}, [x2], x3
 
-	subs		x8, x4, #256
+	subs		x8, x4, #320
 	ccmp		x3, xzr, #4, lt
 	add		x9, x8, x2
 	csel		x2, x2, x9, eq
 
 	zip1		v3.2d, v28.2d, v30.2d
 	zip2		v7.2d, v28.2d, v30.2d
+	  stp		a12, a13, [x1, #-16]
 	zip1		v11.2d, v29.2d, v31.2d
 	zip2		v15.2d, v29.2d, v31.2d
+	  stp		a14, a15, [x1, #-8]
 	ld1		{v28.16b-v31.16b}, [x2]
 
 	// xor with corresponding input, write to output
@@ -488,6 +687,7 @@ ENTRY(chacha_4block_xor_neon)
 	eor		v18.16b, v18.16b, v2.16b
 	eor		v19.16b, v19.16b, v3.16b
 	st1		{v16.16b-v19.16b}, [x1], #64
+	cbz		x5, .Lout
 
 	tbnz		x6, #63, 1f
 	eor		v20.16b, v20.16b, v4.16b
@@ -495,6 +695,7 @@ ENTRY(chacha_4block_xor_neon)
 	eor		v22.16b, v22.16b, v6.16b
 	eor		v23.16b, v23.16b, v7.16b
 	st1		{v20.16b-v23.16b}, [x1], #64
+	cbz		x6, .Lout
 
 	tbnz		x7, #63, 2f
 	eor		v24.16b, v24.16b, v8.16b
@@ -502,6 +703,7 @@ ENTRY(chacha_4block_xor_neon)
 	eor		v26.16b, v26.16b, v10.16b
 	eor		v27.16b, v27.16b, v11.16b
 	st1		{v24.16b-v27.16b}, [x1], #64
+	cbz		x7, .Lout
 
 	tbnz		x8, #63, 3f
 	eor		v28.16b, v28.16b, v12.16b
@@ -510,9 +712,10 @@ ENTRY(chacha_4block_xor_neon)
 	eor		v31.16b, v31.16b, v15.16b
 	st1		{v28.16b-v31.16b}, [x1]
 
+.Lout:	frame_pop
 	ret
 
-	// fewer than 64 bytes of in/output
+	// fewer than 128 bytes of in/output
 0:	ld1		{v8.16b}, [x10]
 	ld1		{v9.16b}, [x11]
 	movi		v10.16b, #16
@@ -539,9 +742,9 @@ ENTRY(chacha_4block_xor_neon)
 	eor		v22.16b, v22.16b, v6.16b
 	eor		v23.16b, v23.16b, v7.16b
 	st1		{v20.16b-v23.16b}, [x1]
-	ret
+	b		.Lout
 
-	// fewer than 128 bytes of in/output
+	// fewer than 192 bytes of in/output
 1:	ld1		{v8.16b}, [x10]
 	ld1		{v9.16b}, [x11]
 	movi		v10.16b, #16
@@ -566,9 +769,9 @@ ENTRY(chacha_4block_xor_neon)
 	eor		v22.16b, v22.16b, v2.16b
 	eor		v23.16b, v23.16b, v3.16b
 	st1		{v20.16b-v23.16b}, [x1]
-	ret
+	b		.Lout
 
-	// fewer than 192 bytes of in/output
+	// fewer than 256 bytes of in/output
 2:	ld1		{v4.16b}, [x10]
 	ld1		{v5.16b}, [x11]
 	movi		v6.16b, #16
@@ -593,9 +796,9 @@ ENTRY(chacha_4block_xor_neon)
 	eor		v26.16b, v26.16b, v2.16b
 	eor		v27.16b, v27.16b, v3.16b
 	st1		{v24.16b-v27.16b}, [x1]
-	ret
+	b		.Lout
 
-	// fewer than 256 bytes of in/output
+	// fewer than 320 bytes of in/output
 3:	ld1		{v4.16b}, [x10]
 	ld1		{v5.16b}, [x11]
 	movi		v6.16b, #16
@@ -620,7 +823,7 @@ ENTRY(chacha_4block_xor_neon)
 	eor		v30.16b, v30.16b, v2.16b
 	eor		v31.16b, v31.16b, v3.16b
 	st1		{v28.16b-v31.16b}, [x1]
-	ret
+	b		.Lout
 ENDPROC(chacha_4block_xor_neon)
 
 	.section	".rodata", "a", %progbits
@@ -632,5 +835,5 @@ ENDPROC(chacha_4block_xor_neon)
 	.set		.Li, .Li + 1
 	.endr
 
-CTRINC:	.word		0, 1, 2, 3
+CTRINC:	.word		1, 2, 3, 4
 ROT8:	.word		0x02010003, 0x06050407, 0x0a09080b, 0x0e0d0c0f
diff --git a/arch/arm64/crypto/chacha-neon-glue.c b/arch/arm64/crypto/chacha-neon-glue.c
index 67f8feb0c717..bece1d85bd81 100644
--- a/arch/arm64/crypto/chacha-neon-glue.c
+++ b/arch/arm64/crypto/chacha-neon-glue.c
@@ -38,22 +38,23 @@ asmlinkage void hchacha_block_neon(const u32 *state, u32 *out, int nrounds);
 static void chacha_doneon(u32 *state, u8 *dst, const u8 *src,
 			  int bytes, int nrounds)
 {
-	u8 buf[CHACHA_BLOCK_SIZE];
-
-	if (bytes < CHACHA_BLOCK_SIZE) {
-		memcpy(buf, src, bytes);
-		chacha_block_xor_neon(state, buf, buf, nrounds);
-		memcpy(dst, buf, bytes);
-		return;
-	}
-
 	while (bytes > 0) {
-		chacha_4block_xor_neon(state, dst, src, nrounds,
-				       min(bytes, CHACHA_BLOCK_SIZE * 4));
-		bytes -= CHACHA_BLOCK_SIZE * 4;
-		src += CHACHA_BLOCK_SIZE * 4;
-		dst += CHACHA_BLOCK_SIZE * 4;
-		state[12] += 4;
+		int l = min(bytes, CHACHA_BLOCK_SIZE * 5);
+
+		if (l <= CHACHA_BLOCK_SIZE) {
+			u8 buf[CHACHA_BLOCK_SIZE];
+
+			memcpy(buf, src, l);
+			chacha_block_xor_neon(state, buf, buf, nrounds);
+			memcpy(dst, buf, l);
+			state[12] += 1;
+			break;
+		}
+		chacha_4block_xor_neon(state, dst, src, nrounds, l);
+		bytes -= CHACHA_BLOCK_SIZE * 5;
+		src += CHACHA_BLOCK_SIZE * 5;
+		dst += CHACHA_BLOCK_SIZE * 5;
+		state[12] += 5;
 	}
 }
 
@@ -72,7 +73,7 @@ static int chacha_neon_stream_xor(struct skcipher_request *req,
 		unsigned int nbytes = walk.nbytes;
 
 		if (nbytes < walk.total)
-			nbytes = round_down(nbytes, walk.stride);
+			nbytes = rounddown(nbytes, walk.stride);
 
 		kernel_neon_begin();
 		chacha_doneon(state, walk.dst.virt.addr, walk.src.virt.addr,
@@ -131,7 +132,7 @@ static struct skcipher_alg algs[] = {
 		.max_keysize		= CHACHA_KEY_SIZE,
 		.ivsize			= CHACHA_IV_SIZE,
 		.chunksize		= CHACHA_BLOCK_SIZE,
-		.walksize		= 4 * CHACHA_BLOCK_SIZE,
+		.walksize		= 5 * CHACHA_BLOCK_SIZE,
 		.setkey			= crypto_chacha20_setkey,
 		.encrypt		= chacha_neon,
 		.decrypt		= chacha_neon,
@@ -147,7 +148,7 @@ static struct skcipher_alg algs[] = {
 		.max_keysize		= CHACHA_KEY_SIZE,
 		.ivsize			= XCHACHA_IV_SIZE,
 		.chunksize		= CHACHA_BLOCK_SIZE,
-		.walksize		= 4 * CHACHA_BLOCK_SIZE,
+		.walksize		= 5 * CHACHA_BLOCK_SIZE,
 		.setkey			= crypto_chacha20_setkey,
 		.encrypt		= xchacha_neon,
 		.decrypt		= xchacha_neon,
@@ -163,7 +164,7 @@ static struct skcipher_alg algs[] = {
 		.max_keysize		= CHACHA_KEY_SIZE,
 		.ivsize			= XCHACHA_IV_SIZE,
 		.chunksize		= CHACHA_BLOCK_SIZE,
-		.walksize		= 4 * CHACHA_BLOCK_SIZE,
+		.walksize		= 5 * CHACHA_BLOCK_SIZE,
 		.setkey			= crypto_chacha12_setkey,
 		.encrypt		= xchacha_neon,
 		.decrypt		= xchacha_neon,
-- 
2.19.2
