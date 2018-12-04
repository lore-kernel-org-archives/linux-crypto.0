Return-Path: <SRS0=wDfx=ON=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53536 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726134AbeLDNNo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Dec 2018 08:13:44 -0500
Received: by mail-wm1-f66.google.com with SMTP id y1so9492655wmi.3
        for <linux-crypto@vger.kernel.org>; Tue, 04 Dec 2018 05:13:42 -0800 (PST)
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Martin Willi <martin@strongswan.org>
Subject: [PATCH v2 2/3] crypto: arm64/chacha - optimize for arbitrary length inputs
Date: Tue,  4 Dec 2018 14:13:32 +0100
Message-Id: <20181204131333.15046-3-ard.biesheuvel@linaro.org>
In-Reply-To: <20181204131333.15046-1-ard.biesheuvel@linaro.org>
References: <20181204131333.15046-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Update the 4-way NEON ChaCha routine so it can handle input of any
length >64 bytes in its entirety, rather than having to call into
the 1-way routine and/or memcpy()s via temp buffers to handle the
tail of a ChaCha invocation that is not a multiple of 256 bytes.

On inputs that are a multiple of 256 bytes (and thus in tcrypt
benchmarks), performance drops by around 1% on Cortex-A57, while
performance for inputs drawn randomly from the range [64, 1024)
increases by around 30%.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/chacha-neon-core.S | 183 ++++++++++++++++++--
 arch/arm64/crypto/chacha-neon-glue.c |  38 ++--
 2 files changed, 184 insertions(+), 37 deletions(-)

diff --git a/arch/arm64/crypto/chacha-neon-core.S b/arch/arm64/crypto/chacha-neon-core.S
index 75b4e06cee79..32086709e6b3 100644
--- a/arch/arm64/crypto/chacha-neon-core.S
+++ b/arch/arm64/crypto/chacha-neon-core.S
@@ -19,6 +19,8 @@
  */
 
 #include <linux/linkage.h>
+#include <asm/assembler.h>
+#include <asm/cache.h>
 
 	.text
 	.align		6
@@ -36,7 +38,7 @@
  */
 chacha_permute:
 
-	adr		x10, ROT8
+	adr_l		x10, ROT8
 	ld1		{v12.4s}, [x10]
 
 .Ldoubleround:
@@ -164,6 +166,12 @@ ENTRY(chacha_4block_xor_neon)
 	// x1: 4 data blocks output, o
 	// x2: 4 data blocks input, i
 	// w3: nrounds
+	// x4: byte count
+
+	adr_l		x10, .Lpermute
+	and		x5, x4, #63
+	add		x10, x10, x5
+	add		x11, x10, #64
 
 	//
 	// This function encrypts four consecutive ChaCha blocks by loading
@@ -173,15 +181,15 @@ ENTRY(chacha_4block_xor_neon)
 	// matrix by interleaving 32- and then 64-bit words, which allows us to
 	// do XOR in NEON registers.
 	//
-	adr		x9, CTRINC		// ... and ROT8
+	adr_l		x9, CTRINC		// ... and ROT8
 	ld1		{v30.4s-v31.4s}, [x9]
 
 	// x0..15[0-3] = s0..3[0..3]
-	mov		x4, x0
-	ld4r		{ v0.4s- v3.4s}, [x4], #16
-	ld4r		{ v4.4s- v7.4s}, [x4], #16
-	ld4r		{ v8.4s-v11.4s}, [x4], #16
-	ld4r		{v12.4s-v15.4s}, [x4]
+	add		x8, x0, #16
+	ld4r		{ v0.4s- v3.4s}, [x0]
+	ld4r		{ v4.4s- v7.4s}, [x8], #16
+	ld4r		{ v8.4s-v11.4s}, [x8], #16
+	ld4r		{v12.4s-v15.4s}, [x8]
 
 	// x12 += counter values 0-3
 	add		v12.4s, v12.4s, v30.4s
@@ -425,24 +433,47 @@ ENTRY(chacha_4block_xor_neon)
 	zip1		v30.4s, v14.4s, v15.4s
 	zip2		v31.4s, v14.4s, v15.4s
 
+	mov		x3, #64
+	subs		x5, x4, #64
+	add		x6, x5, x2
+	csel		x3, x3, xzr, ge
+	csel		x2, x2, x6, ge
+
 	// interleave 64-bit words in state n, n+2
 	zip1		v0.2d, v16.2d, v18.2d
 	zip2		v4.2d, v16.2d, v18.2d
 	zip1		v8.2d, v17.2d, v19.2d
 	zip2		v12.2d, v17.2d, v19.2d
-	ld1		{v16.16b-v19.16b}, [x2], #64
+	ld1		{v16.16b-v19.16b}, [x2], x3
+
+	subs		x6, x4, #128
+	ccmp		x3, xzr, #4, lt
+	add		x7, x6, x2
+	csel		x3, x3, xzr, eq
+	csel		x2, x2, x7, eq
 
 	zip1		v1.2d, v20.2d, v22.2d
 	zip2		v5.2d, v20.2d, v22.2d
 	zip1		v9.2d, v21.2d, v23.2d
 	zip2		v13.2d, v21.2d, v23.2d
-	ld1		{v20.16b-v23.16b}, [x2], #64
+	ld1		{v20.16b-v23.16b}, [x2], x3
+
+	subs		x7, x4, #192
+	ccmp		x3, xzr, #4, lt
+	add		x8, x7, x2
+	csel		x3, x3, xzr, eq
+	csel		x2, x2, x8, eq
 
 	zip1		v2.2d, v24.2d, v26.2d
 	zip2		v6.2d, v24.2d, v26.2d
 	zip1		v10.2d, v25.2d, v27.2d
 	zip2		v14.2d, v25.2d, v27.2d
-	ld1		{v24.16b-v27.16b}, [x2], #64
+	ld1		{v24.16b-v27.16b}, [x2], x3
+
+	subs		x8, x4, #256
+	ccmp		x3, xzr, #4, lt
+	add		x9, x8, x2
+	csel		x2, x2, x9, eq
 
 	zip1		v3.2d, v28.2d, v30.2d
 	zip2		v7.2d, v28.2d, v30.2d
@@ -451,29 +482,155 @@ ENTRY(chacha_4block_xor_neon)
 	ld1		{v28.16b-v31.16b}, [x2]
 
 	// xor with corresponding input, write to output
+	tbnz		x5, #63, 0f
 	eor		v16.16b, v16.16b, v0.16b
 	eor		v17.16b, v17.16b, v1.16b
 	eor		v18.16b, v18.16b, v2.16b
 	eor		v19.16b, v19.16b, v3.16b
+	st1		{v16.16b-v19.16b}, [x1], #64
+
+	tbnz		x6, #63, 1f
 	eor		v20.16b, v20.16b, v4.16b
 	eor		v21.16b, v21.16b, v5.16b
-	st1		{v16.16b-v19.16b}, [x1], #64
 	eor		v22.16b, v22.16b, v6.16b
 	eor		v23.16b, v23.16b, v7.16b
+	st1		{v20.16b-v23.16b}, [x1], #64
+
+	tbnz		x7, #63, 2f
 	eor		v24.16b, v24.16b, v8.16b
 	eor		v25.16b, v25.16b, v9.16b
-	st1		{v20.16b-v23.16b}, [x1], #64
 	eor		v26.16b, v26.16b, v10.16b
 	eor		v27.16b, v27.16b, v11.16b
-	eor		v28.16b, v28.16b, v12.16b
 	st1		{v24.16b-v27.16b}, [x1], #64
+
+	tbnz		x8, #63, 3f
+	eor		v28.16b, v28.16b, v12.16b
 	eor		v29.16b, v29.16b, v13.16b
 	eor		v30.16b, v30.16b, v14.16b
 	eor		v31.16b, v31.16b, v15.16b
 	st1		{v28.16b-v31.16b}, [x1]
 
 	ret
+
+	// fewer than 64 bytes of in/output
+0:	ld1		{v8.16b}, [x10]
+	ld1		{v9.16b}, [x11]
+	movi		v10.16b, #16
+	sub		x2, x1, #64
+	add		x1, x1, x5
+	ld1		{v16.16b-v19.16b}, [x2]
+	tbl		v4.16b, {v0.16b-v3.16b}, v8.16b
+	tbx		v20.16b, {v16.16b-v19.16b}, v9.16b
+	add		v8.16b, v8.16b, v10.16b
+	add		v9.16b, v9.16b, v10.16b
+	tbl		v5.16b, {v0.16b-v3.16b}, v8.16b
+	tbx		v21.16b, {v16.16b-v19.16b}, v9.16b
+	add		v8.16b, v8.16b, v10.16b
+	add		v9.16b, v9.16b, v10.16b
+	tbl		v6.16b, {v0.16b-v3.16b}, v8.16b
+	tbx		v22.16b, {v16.16b-v19.16b}, v9.16b
+	add		v8.16b, v8.16b, v10.16b
+	add		v9.16b, v9.16b, v10.16b
+	tbl		v7.16b, {v0.16b-v3.16b}, v8.16b
+	tbx		v23.16b, {v16.16b-v19.16b}, v9.16b
+
+	eor		v20.16b, v20.16b, v4.16b
+	eor		v21.16b, v21.16b, v5.16b
+	eor		v22.16b, v22.16b, v6.16b
+	eor		v23.16b, v23.16b, v7.16b
+	st1		{v20.16b-v23.16b}, [x1]
+	ret
+
+	// fewer than 128 bytes of in/output
+1:	ld1		{v8.16b}, [x10]
+	ld1		{v9.16b}, [x11]
+	movi		v10.16b, #16
+	add		x1, x1, x6
+	tbl		v0.16b, {v4.16b-v7.16b}, v8.16b
+	tbx		v20.16b, {v16.16b-v19.16b}, v9.16b
+	add		v8.16b, v8.16b, v10.16b
+	add		v9.16b, v9.16b, v10.16b
+	tbl		v1.16b, {v4.16b-v7.16b}, v8.16b
+	tbx		v21.16b, {v16.16b-v19.16b}, v9.16b
+	add		v8.16b, v8.16b, v10.16b
+	add		v9.16b, v9.16b, v10.16b
+	tbl		v2.16b, {v4.16b-v7.16b}, v8.16b
+	tbx		v22.16b, {v16.16b-v19.16b}, v9.16b
+	add		v8.16b, v8.16b, v10.16b
+	add		v9.16b, v9.16b, v10.16b
+	tbl		v3.16b, {v4.16b-v7.16b}, v8.16b
+	tbx		v23.16b, {v16.16b-v19.16b}, v9.16b
+
+	eor		v20.16b, v20.16b, v0.16b
+	eor		v21.16b, v21.16b, v1.16b
+	eor		v22.16b, v22.16b, v2.16b
+	eor		v23.16b, v23.16b, v3.16b
+	st1		{v20.16b-v23.16b}, [x1]
+	ret
+
+	// fewer than 192 bytes of in/output
+2:	ld1		{v4.16b}, [x10]
+	ld1		{v5.16b}, [x11]
+	movi		v6.16b, #16
+	add		x1, x1, x7
+	tbl		v0.16b, {v8.16b-v11.16b}, v4.16b
+	tbx		v24.16b, {v20.16b-v23.16b}, v5.16b
+	add		v4.16b, v4.16b, v6.16b
+	add		v5.16b, v5.16b, v6.16b
+	tbl		v1.16b, {v8.16b-v11.16b}, v4.16b
+	tbx		v25.16b, {v20.16b-v23.16b}, v5.16b
+	add		v4.16b, v4.16b, v6.16b
+	add		v5.16b, v5.16b, v6.16b
+	tbl		v2.16b, {v8.16b-v11.16b}, v4.16b
+	tbx		v26.16b, {v20.16b-v23.16b}, v5.16b
+	add		v4.16b, v4.16b, v6.16b
+	add		v5.16b, v5.16b, v6.16b
+	tbl		v3.16b, {v8.16b-v11.16b}, v4.16b
+	tbx		v27.16b, {v20.16b-v23.16b}, v5.16b
+
+	eor		v24.16b, v24.16b, v0.16b
+	eor		v25.16b, v25.16b, v1.16b
+	eor		v26.16b, v26.16b, v2.16b
+	eor		v27.16b, v27.16b, v3.16b
+	st1		{v24.16b-v27.16b}, [x1]
+	ret
+
+	// fewer than 256 bytes of in/output
+3:	ld1		{v4.16b}, [x10]
+	ld1		{v5.16b}, [x11]
+	movi		v6.16b, #16
+	add		x1, x1, x8
+	tbl		v0.16b, {v12.16b-v15.16b}, v4.16b
+	tbx		v28.16b, {v24.16b-v27.16b}, v5.16b
+	add		v4.16b, v4.16b, v6.16b
+	add		v5.16b, v5.16b, v6.16b
+	tbl		v1.16b, {v12.16b-v15.16b}, v4.16b
+	tbx		v29.16b, {v24.16b-v27.16b}, v5.16b
+	add		v4.16b, v4.16b, v6.16b
+	add		v5.16b, v5.16b, v6.16b
+	tbl		v2.16b, {v12.16b-v15.16b}, v4.16b
+	tbx		v30.16b, {v24.16b-v27.16b}, v5.16b
+	add		v4.16b, v4.16b, v6.16b
+	add		v5.16b, v5.16b, v6.16b
+	tbl		v3.16b, {v12.16b-v15.16b}, v4.16b
+	tbx		v31.16b, {v24.16b-v27.16b}, v5.16b
+
+	eor		v28.16b, v28.16b, v0.16b
+	eor		v29.16b, v29.16b, v1.16b
+	eor		v30.16b, v30.16b, v2.16b
+	eor		v31.16b, v31.16b, v3.16b
+	st1		{v28.16b-v31.16b}, [x1]
+	ret
 ENDPROC(chacha_4block_xor_neon)
 
+	.section	".rodata", "a", %progbits
+	.align		L1_CACHE_SHIFT
+.Lpermute:
+	.set		.Li, 0
+	.rept		192
+	.byte		(.Li - 64)
+	.set		.Li, .Li + 1
+	.endr
+
 CTRINC:	.word		0, 1, 2, 3
 ROT8:	.word		0x02010003, 0x06050407, 0x0a09080b, 0x0e0d0c0f
diff --git a/arch/arm64/crypto/chacha-neon-glue.c b/arch/arm64/crypto/chacha-neon-glue.c
index 346eb85498a1..67f8feb0c717 100644
--- a/arch/arm64/crypto/chacha-neon-glue.c
+++ b/arch/arm64/crypto/chacha-neon-glue.c
@@ -32,41 +32,29 @@
 asmlinkage void chacha_block_xor_neon(u32 *state, u8 *dst, const u8 *src,
 				      int nrounds);
 asmlinkage void chacha_4block_xor_neon(u32 *state, u8 *dst, const u8 *src,
-				       int nrounds);
+				       int nrounds, int bytes);
 asmlinkage void hchacha_block_neon(const u32 *state, u32 *out, int nrounds);
 
 static void chacha_doneon(u32 *state, u8 *dst, const u8 *src,
-			  unsigned int bytes, int nrounds)
+			  int bytes, int nrounds)
 {
 	u8 buf[CHACHA_BLOCK_SIZE];
 
-	while (bytes >= CHACHA_BLOCK_SIZE * 4) {
-		kernel_neon_begin();
-		chacha_4block_xor_neon(state, dst, src, nrounds);
-		kernel_neon_end();
+	if (bytes < CHACHA_BLOCK_SIZE) {
+		memcpy(buf, src, bytes);
+		chacha_block_xor_neon(state, buf, buf, nrounds);
+		memcpy(dst, buf, bytes);
+		return;
+	}
+
+	while (bytes > 0) {
+		chacha_4block_xor_neon(state, dst, src, nrounds,
+				       min(bytes, CHACHA_BLOCK_SIZE * 4));
 		bytes -= CHACHA_BLOCK_SIZE * 4;
 		src += CHACHA_BLOCK_SIZE * 4;
 		dst += CHACHA_BLOCK_SIZE * 4;
 		state[12] += 4;
 	}
-
-	if (!bytes)
-		return;
-
-	kernel_neon_begin();
-	while (bytes >= CHACHA_BLOCK_SIZE) {
-		chacha_block_xor_neon(state, dst, src, nrounds);
-		bytes -= CHACHA_BLOCK_SIZE;
-		src += CHACHA_BLOCK_SIZE;
-		dst += CHACHA_BLOCK_SIZE;
-		state[12]++;
-	}
-	if (bytes) {
-		memcpy(buf, src, bytes);
-		chacha_block_xor_neon(state, buf, buf, nrounds);
-		memcpy(dst, buf, bytes);
-	}
-	kernel_neon_end();
 }
 
 static int chacha_neon_stream_xor(struct skcipher_request *req,
@@ -86,8 +74,10 @@ static int chacha_neon_stream_xor(struct skcipher_request *req,
 		if (nbytes < walk.total)
 			nbytes = round_down(nbytes, walk.stride);
 
+		kernel_neon_begin();
 		chacha_doneon(state, walk.dst.virt.addr, walk.src.virt.addr,
 			      nbytes, ctx->nrounds);
+		kernel_neon_end();
 		err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
 	}
 
-- 
2.19.2
