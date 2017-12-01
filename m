From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 2/5] crypto: arm64/aes-blk - move kernel mode neon en/disable into loop
Date: Fri,  1 Dec 2017 21:19:24 +0000
Message-ID: <20171201211927.24653-3-ard.biesheuvel@linaro.org>
References: <20171201211927.24653-1-ard.biesheuvel@linaro.org>
Cc: herbert@gondor.apana.org.au, linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Dave Martin <Dave.Martin@arm.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-rt-users@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:41134 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751182AbdLAV0D (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Dec 2017 16:26:03 -0500
Received: by mail-wr0-f193.google.com with SMTP id z18so11482573wrb.8
        for <linux-crypto@vger.kernel.org>; Fri, 01 Dec 2017 13:26:02 -0800 (PST)
In-Reply-To: <20171201211927.24653-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

When kernel mode NEON was first introduced on arm64, the preserve and
restore of the userland NEON state was completely unoptimized, and
involved saving all registers on each call to kernel_neon_begin(),
and restoring them on each call to kernel_neon_end(). For this reason,
the NEON crypto code that was introduced at the time keeps the NEON
enabled throughout the execution of the crypto API methods, which may
include calls back into the crypto API that could result in memory
allocation or other actions that we should avoid when running with
preemption disabled.

Since then, we have optimized the kernel mode NEON handling, which now
restores lazily (upon return to userland), and so the preserve action
is only costly the first time it is called after entering the kernel.

So let's put the kernel_neon_begin() and kernel_neon_end() calls around
the actual invocations of the NEON crypto code, and run the remainder of
the code with kernel mode NEON disabled (and preemption enabled)

Note that this requires some reshuffling of the registers in the asm
code, because the XTS routines can no longer rely on the registers to
retain their contents between invocations.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/aes-glue.c        | 81 +++++++++---------
 arch/arm64/crypto/aes-modes.S       | 90 ++++++++++----------
 arch/arm64/crypto/aes-neonbs-glue.c | 14 ++-
 3 files changed, 90 insertions(+), 95 deletions(-)

diff --git a/arch/arm64/crypto/aes-glue.c b/arch/arm64/crypto/aes-glue.c
index 998ba519a026..c983a2bfebe3 100644
--- a/arch/arm64/crypto/aes-glue.c
+++ b/arch/arm64/crypto/aes-glue.c
@@ -64,17 +64,17 @@ MODULE_LICENSE("GPL v2");
 
 /* defined in aes-modes.S */
 asmlinkage void aes_ecb_encrypt(u8 out[], u8 const in[], u8 const rk[],
-				int rounds, int blocks, int first);
+				int rounds, int blocks);
 asmlinkage void aes_ecb_decrypt(u8 out[], u8 const in[], u8 const rk[],
-				int rounds, int blocks, int first);
+				int rounds, int blocks);
 
 asmlinkage void aes_cbc_encrypt(u8 out[], u8 const in[], u8 const rk[],
-				int rounds, int blocks, u8 iv[], int first);
+				int rounds, int blocks, u8 iv[]);
 asmlinkage void aes_cbc_decrypt(u8 out[], u8 const in[], u8 const rk[],
-				int rounds, int blocks, u8 iv[], int first);
+				int rounds, int blocks, u8 iv[]);
 
 asmlinkage void aes_ctr_encrypt(u8 out[], u8 const in[], u8 const rk[],
-				int rounds, int blocks, u8 ctr[], int first);
+				int rounds, int blocks, u8 ctr[]);
 
 asmlinkage void aes_xts_encrypt(u8 out[], u8 const in[], u8 const rk1[],
 				int rounds, int blocks, u8 const rk2[], u8 iv[],
@@ -133,19 +133,19 @@ static int ecb_encrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct crypto_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
-	int err, first, rounds = 6 + ctx->key_length / 4;
+	int err, rounds = 6 + ctx->key_length / 4;
 	struct skcipher_walk walk;
 	unsigned int blocks;
 
 	err = skcipher_walk_virt(&walk, req, true);
 
-	kernel_neon_begin();
-	for (first = 1; (blocks = (walk.nbytes / AES_BLOCK_SIZE)); first = 0) {
+	while ((blocks = (walk.nbytes / AES_BLOCK_SIZE))) {
+		kernel_neon_begin();
 		aes_ecb_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
-				(u8 *)ctx->key_enc, rounds, blocks, first);
+				(u8 *)ctx->key_enc, rounds, blocks);
+		kernel_neon_end();
 		err = skcipher_walk_done(&walk, walk.nbytes % AES_BLOCK_SIZE);
 	}
-	kernel_neon_end();
 	return err;
 }
 
@@ -153,19 +153,19 @@ static int ecb_decrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct crypto_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
-	int err, first, rounds = 6 + ctx->key_length / 4;
+	int err, rounds = 6 + ctx->key_length / 4;
 	struct skcipher_walk walk;
 	unsigned int blocks;
 
 	err = skcipher_walk_virt(&walk, req, true);
 
-	kernel_neon_begin();
-	for (first = 1; (blocks = (walk.nbytes / AES_BLOCK_SIZE)); first = 0) {
+	while ((blocks = (walk.nbytes / AES_BLOCK_SIZE))) {
+		kernel_neon_begin();
 		aes_ecb_decrypt(walk.dst.virt.addr, walk.src.virt.addr,
-				(u8 *)ctx->key_dec, rounds, blocks, first);
+				(u8 *)ctx->key_dec, rounds, blocks);
+		kernel_neon_end();
 		err = skcipher_walk_done(&walk, walk.nbytes % AES_BLOCK_SIZE);
 	}
-	kernel_neon_end();
 	return err;
 }
 
@@ -173,20 +173,19 @@ static int cbc_encrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct crypto_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
-	int err, first, rounds = 6 + ctx->key_length / 4;
+	int err, rounds = 6 + ctx->key_length / 4;
 	struct skcipher_walk walk;
 	unsigned int blocks;
 
 	err = skcipher_walk_virt(&walk, req, true);
 
-	kernel_neon_begin();
-	for (first = 1; (blocks = (walk.nbytes / AES_BLOCK_SIZE)); first = 0) {
+	while ((blocks = (walk.nbytes / AES_BLOCK_SIZE))) {
+		kernel_neon_begin();
 		aes_cbc_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
-				(u8 *)ctx->key_enc, rounds, blocks, walk.iv,
-				first);
+				(u8 *)ctx->key_enc, rounds, blocks, walk.iv);
+		kernel_neon_end();
 		err = skcipher_walk_done(&walk, walk.nbytes % AES_BLOCK_SIZE);
 	}
-	kernel_neon_end();
 	return err;
 }
 
@@ -194,20 +193,19 @@ static int cbc_decrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct crypto_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
-	int err, first, rounds = 6 + ctx->key_length / 4;
+	int err, rounds = 6 + ctx->key_length / 4;
 	struct skcipher_walk walk;
 	unsigned int blocks;
 
 	err = skcipher_walk_virt(&walk, req, true);
 
-	kernel_neon_begin();
-	for (first = 1; (blocks = (walk.nbytes / AES_BLOCK_SIZE)); first = 0) {
+	while ((blocks = (walk.nbytes / AES_BLOCK_SIZE))) {
+		kernel_neon_begin();
 		aes_cbc_decrypt(walk.dst.virt.addr, walk.src.virt.addr,
-				(u8 *)ctx->key_dec, rounds, blocks, walk.iv,
-				first);
+				(u8 *)ctx->key_dec, rounds, blocks, walk.iv);
+		kernel_neon_end();
 		err = skcipher_walk_done(&walk, walk.nbytes % AES_BLOCK_SIZE);
 	}
-	kernel_neon_end();
 	return err;
 }
 
@@ -215,20 +213,18 @@ static int ctr_encrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct crypto_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
-	int err, first, rounds = 6 + ctx->key_length / 4;
+	int err, rounds = 6 + ctx->key_length / 4;
 	struct skcipher_walk walk;
 	int blocks;
 
 	err = skcipher_walk_virt(&walk, req, true);
 
-	first = 1;
-	kernel_neon_begin();
 	while ((blocks = (walk.nbytes / AES_BLOCK_SIZE))) {
+		kernel_neon_begin();
 		aes_ctr_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
-				(u8 *)ctx->key_enc, rounds, blocks, walk.iv,
-				first);
+				(u8 *)ctx->key_enc, rounds, blocks, walk.iv);
 		err = skcipher_walk_done(&walk, walk.nbytes % AES_BLOCK_SIZE);
-		first = 0;
+		kernel_neon_end();
 	}
 	if (walk.nbytes) {
 		u8 __aligned(8) tail[AES_BLOCK_SIZE];
@@ -241,12 +237,13 @@ static int ctr_encrypt(struct skcipher_request *req)
 		 */
 		blocks = -1;
 
+		kernel_neon_begin();
 		aes_ctr_encrypt(tail, NULL, (u8 *)ctx->key_enc, rounds,
-				blocks, walk.iv, first);
+				blocks, walk.iv);
+		kernel_neon_end();
 		crypto_xor_cpy(tdst, tsrc, tail, nbytes);
 		err = skcipher_walk_done(&walk, 0);
 	}
-	kernel_neon_end();
 
 	return err;
 }
@@ -272,14 +269,14 @@ static int xts_encrypt(struct skcipher_request *req)
 
 	err = skcipher_walk_virt(&walk, req, true);
 
-	kernel_neon_begin();
 	for (first = 1; (blocks = (walk.nbytes / AES_BLOCK_SIZE)); first = 0) {
+		kernel_neon_begin();
 		aes_xts_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
 				(u8 *)ctx->key1.key_enc, rounds, blocks,
 				(u8 *)ctx->key2.key_enc, walk.iv, first);
+		kernel_neon_end();
 		err = skcipher_walk_done(&walk, walk.nbytes % AES_BLOCK_SIZE);
 	}
-	kernel_neon_end();
 
 	return err;
 }
@@ -294,14 +291,14 @@ static int xts_decrypt(struct skcipher_request *req)
 
 	err = skcipher_walk_virt(&walk, req, true);
 
-	kernel_neon_begin();
 	for (first = 1; (blocks = (walk.nbytes / AES_BLOCK_SIZE)); first = 0) {
+		kernel_neon_begin();
 		aes_xts_decrypt(walk.dst.virt.addr, walk.src.virt.addr,
 				(u8 *)ctx->key1.key_dec, rounds, blocks,
 				(u8 *)ctx->key2.key_enc, walk.iv, first);
+		kernel_neon_end();
 		err = skcipher_walk_done(&walk, walk.nbytes % AES_BLOCK_SIZE);
 	}
-	kernel_neon_end();
 
 	return err;
 }
@@ -425,7 +422,7 @@ static int cmac_setkey(struct crypto_shash *tfm, const u8 *in_key,
 
 	/* encrypt the zero vector */
 	kernel_neon_begin();
-	aes_ecb_encrypt(ctx->consts, (u8[AES_BLOCK_SIZE]){}, rk, rounds, 1, 1);
+	aes_ecb_encrypt(ctx->consts, (u8[AES_BLOCK_SIZE]){}, rk, rounds, 1);
 	kernel_neon_end();
 
 	cmac_gf128_mul_by_x(consts, consts);
@@ -454,8 +451,8 @@ static int xcbc_setkey(struct crypto_shash *tfm, const u8 *in_key,
 		return err;
 
 	kernel_neon_begin();
-	aes_ecb_encrypt(key, ks[0], rk, rounds, 1, 1);
-	aes_ecb_encrypt(ctx->consts, ks[1], rk, rounds, 2, 0);
+	aes_ecb_encrypt(key, ks[0], rk, rounds, 1);
+	aes_ecb_encrypt(ctx->consts, ks[1], rk, rounds, 2);
 	kernel_neon_end();
 
 	return cbcmac_setkey(tfm, key, sizeof(key));
diff --git a/arch/arm64/crypto/aes-modes.S b/arch/arm64/crypto/aes-modes.S
index 2674d43d1384..65b273667b34 100644
--- a/arch/arm64/crypto/aes-modes.S
+++ b/arch/arm64/crypto/aes-modes.S
@@ -40,24 +40,24 @@
 #if INTERLEAVE == 2
 
 aes_encrypt_block2x:
-	encrypt_block2x	v0, v1, w3, x2, x6, w7
+	encrypt_block2x	v0, v1, w3, x2, x8, w7
 	ret
 ENDPROC(aes_encrypt_block2x)
 
 aes_decrypt_block2x:
-	decrypt_block2x	v0, v1, w3, x2, x6, w7
+	decrypt_block2x	v0, v1, w3, x2, x8, w7
 	ret
 ENDPROC(aes_decrypt_block2x)
 
 #elif INTERLEAVE == 4
 
 aes_encrypt_block4x:
-	encrypt_block4x	v0, v1, v2, v3, w3, x2, x6, w7
+	encrypt_block4x	v0, v1, v2, v3, w3, x2, x8, w7
 	ret
 ENDPROC(aes_encrypt_block4x)
 
 aes_decrypt_block4x:
-	decrypt_block4x	v0, v1, v2, v3, w3, x2, x6, w7
+	decrypt_block4x	v0, v1, v2, v3, w3, x2, x8, w7
 	ret
 ENDPROC(aes_decrypt_block4x)
 
@@ -86,33 +86,32 @@ ENDPROC(aes_decrypt_block4x)
 #define FRAME_POP
 
 	.macro		do_encrypt_block2x
-	encrypt_block2x	v0, v1, w3, x2, x6, w7
+	encrypt_block2x	v0, v1, w3, x2, x8, w7
 	.endm
 
 	.macro		do_decrypt_block2x
-	decrypt_block2x	v0, v1, w3, x2, x6, w7
+	decrypt_block2x	v0, v1, w3, x2, x8, w7
 	.endm
 
 	.macro		do_encrypt_block4x
-	encrypt_block4x	v0, v1, v2, v3, w3, x2, x6, w7
+	encrypt_block4x	v0, v1, v2, v3, w3, x2, x8, w7
 	.endm
 
 	.macro		do_decrypt_block4x
-	decrypt_block4x	v0, v1, v2, v3, w3, x2, x6, w7
+	decrypt_block4x	v0, v1, v2, v3, w3, x2, x8, w7
 	.endm
 
 #endif
 
 	/*
 	 * aes_ecb_encrypt(u8 out[], u8 const in[], u8 const rk[], int rounds,
-	 *		   int blocks, int first)
+	 *		   int blocks)
 	 * aes_ecb_decrypt(u8 out[], u8 const in[], u8 const rk[], int rounds,
-	 *		   int blocks, int first)
+	 *		   int blocks)
 	 */
 
 AES_ENTRY(aes_ecb_encrypt)
 	FRAME_PUSH
-	cbz		w5, .LecbencloopNx
 
 	enc_prepare	w3, x2, x5
 
@@ -148,7 +147,6 @@ AES_ENDPROC(aes_ecb_encrypt)
 
 AES_ENTRY(aes_ecb_decrypt)
 	FRAME_PUSH
-	cbz		w5, .LecbdecloopNx
 
 	dec_prepare	w3, x2, x5
 
@@ -184,14 +182,12 @@ AES_ENDPROC(aes_ecb_decrypt)
 
 	/*
 	 * aes_cbc_encrypt(u8 out[], u8 const in[], u8 const rk[], int rounds,
-	 *		   int blocks, u8 iv[], int first)
+	 *		   int blocks, u8 iv[])
 	 * aes_cbc_decrypt(u8 out[], u8 const in[], u8 const rk[], int rounds,
-	 *		   int blocks, u8 iv[], int first)
+	 *		   int blocks, u8 iv[])
 	 */
 
 AES_ENTRY(aes_cbc_encrypt)
-	cbz		w6, .Lcbcencloop
-
 	ld1		{v0.16b}, [x5]			/* get iv */
 	enc_prepare	w3, x2, x6
 
@@ -209,7 +205,6 @@ AES_ENDPROC(aes_cbc_encrypt)
 
 AES_ENTRY(aes_cbc_decrypt)
 	FRAME_PUSH
-	cbz		w6, .LcbcdecloopNx
 
 	ld1		{v7.16b}, [x5]			/* get iv */
 	dec_prepare	w3, x2, x6
@@ -264,20 +259,19 @@ AES_ENDPROC(aes_cbc_decrypt)
 
 	/*
 	 * aes_ctr_encrypt(u8 out[], u8 const in[], u8 const rk[], int rounds,
-	 *		   int blocks, u8 ctr[], int first)
+	 *		   int blocks, u8 ctr[])
 	 */
 
 AES_ENTRY(aes_ctr_encrypt)
 	FRAME_PUSH
-	cbz		w6, .Lctrnotfirst	/* 1st time around? */
+
 	enc_prepare	w3, x2, x6
 	ld1		{v4.16b}, [x5]
 
-.Lctrnotfirst:
-	umov		x8, v4.d[1]		/* keep swabbed ctr in reg */
-	rev		x8, x8
+	umov		x6, v4.d[1]		/* keep swabbed ctr in reg */
+	rev		x6, x6
 #if INTERLEAVE >= 2
-	cmn		w8, w4			/* 32 bit overflow? */
+	cmn		w6, w4			/* 32 bit overflow? */
 	bcs		.Lctrloop
 .LctrloopNx:
 	subs		w4, w4, #INTERLEAVE
@@ -285,11 +279,11 @@ AES_ENTRY(aes_ctr_encrypt)
 #if INTERLEAVE == 2
 	mov		v0.8b, v4.8b
 	mov		v1.8b, v4.8b
-	rev		x7, x8
-	add		x8, x8, #1
+	rev		x7, x6
+	add		x6, x6, #1
 	ins		v0.d[1], x7
-	rev		x7, x8
-	add		x8, x8, #1
+	rev		x7, x6
+	add		x6, x6, #1
 	ins		v1.d[1], x7
 	ld1		{v2.16b-v3.16b}, [x1], #32	/* get 2 input blocks */
 	do_encrypt_block2x
@@ -298,7 +292,7 @@ AES_ENTRY(aes_ctr_encrypt)
 	st1		{v0.16b-v1.16b}, [x0], #32
 #else
 	ldr		q8, =0x30000000200000001	/* addends 1,2,3[,0] */
-	dup		v7.4s, w8
+	dup		v7.4s, w6
 	mov		v0.16b, v4.16b
 	add		v7.4s, v7.4s, v8.4s
 	mov		v1.16b, v4.16b
@@ -316,9 +310,9 @@ AES_ENTRY(aes_ctr_encrypt)
 	eor		v2.16b, v7.16b, v2.16b
 	eor		v3.16b, v5.16b, v3.16b
 	st1		{v0.16b-v3.16b}, [x0], #64
-	add		x8, x8, #INTERLEAVE
+	add		x6, x6, #INTERLEAVE
 #endif
-	rev		x7, x8
+	rev		x7, x6
 	ins		v4.d[1], x7
 	cbz		w4, .Lctrout
 	b		.LctrloopNx
@@ -328,10 +322,10 @@ AES_ENTRY(aes_ctr_encrypt)
 #endif
 .Lctrloop:
 	mov		v0.16b, v4.16b
-	encrypt_block	v0, w3, x2, x6, w7
+	encrypt_block	v0, w3, x2, x8, w7
 
-	adds		x8, x8, #1		/* increment BE ctr */
-	rev		x7, x8
+	adds		x6, x6, #1		/* increment BE ctr */
+	rev		x7, x6
 	ins		v4.d[1], x7
 	bcs		.Lctrcarry		/* overflow? */
 
@@ -385,15 +379,17 @@ CPU_BE(	.quad		0x87, 1		)
 
 AES_ENTRY(aes_xts_encrypt)
 	FRAME_PUSH
-	cbz		w7, .LxtsencloopNx
-
 	ld1		{v4.16b}, [x6]
-	enc_prepare	w3, x5, x6
-	encrypt_block	v4, w3, x5, x6, w7		/* first tweak */
-	enc_switch_key	w3, x2, x6
+	cbz		w7, .Lxtsencnotfirst
+
+	enc_prepare	w3, x5, x8
+	encrypt_block	v4, w3, x5, x8, w7		/* first tweak */
+	enc_switch_key	w3, x2, x8
 	ldr		q7, .Lxts_mul_x
 	b		.LxtsencNx
 
+.Lxtsencnotfirst:
+	enc_prepare	w3, x2, x8
 .LxtsencloopNx:
 	ldr		q7, .Lxts_mul_x
 	next_tweak	v4, v4, v7, v8
@@ -442,7 +438,7 @@ AES_ENTRY(aes_xts_encrypt)
 .Lxtsencloop:
 	ld1		{v1.16b}, [x1], #16
 	eor		v0.16b, v1.16b, v4.16b
-	encrypt_block	v0, w3, x2, x6, w7
+	encrypt_block	v0, w3, x2, x8, w7
 	eor		v0.16b, v0.16b, v4.16b
 	st1		{v0.16b}, [x0], #16
 	subs		w4, w4, #1
@@ -450,6 +446,7 @@ AES_ENTRY(aes_xts_encrypt)
 	next_tweak	v4, v4, v7, v8
 	b		.Lxtsencloop
 .Lxtsencout:
+	st1		{v4.16b}, [x6]
 	FRAME_POP
 	ret
 AES_ENDPROC(aes_xts_encrypt)
@@ -457,15 +454,17 @@ AES_ENDPROC(aes_xts_encrypt)
 
 AES_ENTRY(aes_xts_decrypt)
 	FRAME_PUSH
-	cbz		w7, .LxtsdecloopNx
-
 	ld1		{v4.16b}, [x6]
-	enc_prepare	w3, x5, x6
-	encrypt_block	v4, w3, x5, x6, w7		/* first tweak */
-	dec_prepare	w3, x2, x6
+	cbz		w7, .Lxtsdecnotfirst
+
+	enc_prepare	w3, x5, x8
+	encrypt_block	v4, w3, x5, x8, w7		/* first tweak */
+	dec_prepare	w3, x2, x8
 	ldr		q7, .Lxts_mul_x
 	b		.LxtsdecNx
 
+.Lxtsdecnotfirst:
+	dec_prepare	w3, x2, x8
 .LxtsdecloopNx:
 	ldr		q7, .Lxts_mul_x
 	next_tweak	v4, v4, v7, v8
@@ -514,7 +513,7 @@ AES_ENTRY(aes_xts_decrypt)
 .Lxtsdecloop:
 	ld1		{v1.16b}, [x1], #16
 	eor		v0.16b, v1.16b, v4.16b
-	decrypt_block	v0, w3, x2, x6, w7
+	decrypt_block	v0, w3, x2, x8, w7
 	eor		v0.16b, v0.16b, v4.16b
 	st1		{v0.16b}, [x0], #16
 	subs		w4, w4, #1
@@ -522,6 +521,7 @@ AES_ENTRY(aes_xts_decrypt)
 	next_tweak	v4, v4, v7, v8
 	b		.Lxtsdecloop
 .Lxtsdecout:
+	st1		{v4.16b}, [x6]
 	FRAME_POP
 	ret
 AES_ENDPROC(aes_xts_decrypt)
diff --git a/arch/arm64/crypto/aes-neonbs-glue.c b/arch/arm64/crypto/aes-neonbs-glue.c
index c55d68ccb89f..9d823c77ec84 100644
--- a/arch/arm64/crypto/aes-neonbs-glue.c
+++ b/arch/arm64/crypto/aes-neonbs-glue.c
@@ -46,10 +46,9 @@ asmlinkage void aesbs_xts_decrypt(u8 out[], u8 const in[], u8 const rk[],
 
 /* borrowed from aes-neon-blk.ko */
 asmlinkage void neon_aes_ecb_encrypt(u8 out[], u8 const in[], u32 const rk[],
-				     int rounds, int blocks, int first);
+				     int rounds, int blocks);
 asmlinkage void neon_aes_cbc_encrypt(u8 out[], u8 const in[], u32 const rk[],
-				     int rounds, int blocks, u8 iv[],
-				     int first);
+				     int rounds, int blocks, u8 iv[]);
 
 struct aesbs_ctx {
 	u8	rk[13 * (8 * AES_BLOCK_SIZE) + 32];
@@ -157,7 +156,7 @@ static int cbc_encrypt(struct skcipher_request *req)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct aesbs_cbc_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct skcipher_walk walk;
-	int err, first = 1;
+	int err;
 
 	err = skcipher_walk_virt(&walk, req, true);
 
@@ -167,10 +166,9 @@ static int cbc_encrypt(struct skcipher_request *req)
 
 		/* fall back to the non-bitsliced NEON implementation */
 		neon_aes_cbc_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
-				     ctx->enc, ctx->key.rounds, blocks, walk.iv,
-				     first);
+				     ctx->enc, ctx->key.rounds, blocks,
+				     walk.iv);
 		err = skcipher_walk_done(&walk, walk.nbytes % AES_BLOCK_SIZE);
-		first = 0;
 	}
 	kernel_neon_end();
 	return err;
@@ -311,7 +309,7 @@ static int __xts_crypt(struct skcipher_request *req,
 	kernel_neon_begin();
 
 	neon_aes_ecb_encrypt(walk.iv, walk.iv, ctx->twkey,
-			     ctx->key.rounds, 1, 1);
+			     ctx->key.rounds, 1);
 
 	while (walk.nbytes >= AES_BLOCK_SIZE) {
 		unsigned int blocks = walk.nbytes / AES_BLOCK_SIZE;
-- 
2.11.0
