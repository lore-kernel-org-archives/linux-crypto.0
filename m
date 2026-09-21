Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBCB535E1AD;
	Mon, 21 Sep 2026 05:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789967770; cv=none; b=oaXL4eXSQm3MFDJJ+0Pb9gCa0gvUhXGAAPok5XChwH4tS4zsV0kkRyy+fL0WklcZfx9dECC5IXVa/Vcko/2n9hp70laSUcKsTE3fC0E9pop1xn0cTUOP1zwxKYDToVre1tLQXI26t1p63a7lUZru/B6ppoH48w9a743Ji1aeFzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789967770; c=relaxed/simple;
	bh=Abgb3bfjc8JiCh+4D+HkRFdBmtZGT2b9NyaqT/809wM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nLAmyrOID66mbfo9gjTgP/aNqiYnrZCbV0JRJQldqhmsVpXDGwG8vv+p/ZzYYBvdDkoQ0nHTcqyyvURhmA6f2Dcjk4pEeMqowgZvwtPvE8kSMRJNTO48xGrGnIPp21rM8Db/4SclK42Ligt3f4VvSPmLeTYOueGjRHzOt90tTg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UGjJTpob; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UGjJTpob"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEE4E1F0089D;
	Mon, 21 Sep 2026 05:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789967767;
	bh=W+V1/Q6lb2YF3sLGA0HiySZ/5F17viwdUxWS8D02K14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UGjJTpobLoggxG2oZd7jBpjnwA32p7ppsSycTiiALJIm9qJAyrXKdzNCcmt029LyP
	 kuXX+mexKTH/8OE6sBuq5k8fPOBOmGZ5mRZKVgDwq921FvGoXj9CDwqdEIZOhoyI9U
	 6AfIN0BTfoGwCgzKFrw+dGI2w3kFJj3vgsAVfS82BR1fuAcmCxH6GvFRWrYb4U94Hq
	 WyjdRQT9R/WWGk6pDYlkNauijcZnYWdsnH0VuDvgc/l9M84L54APLfDidrUtarDO7t
	 Vwdz8H/rO9S4k/kSVv7dofezGfT3NJ0DkTIeu4mQEIZguYqLG8rz1XHzTTlQ/8NNmb
	 V5eyrpn17sxIw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org,
	linux-riscv@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 10/20] crypto: x86/aes-ctr - Remove superseded CTR skcipher
Date: Sun, 20 Sep 2026 22:08:56 -0700
Message-ID: <20260921050910.296144-11-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260921050910.296144-1-ebiggers@kernel.org>
References: <20260921050910.296144-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that the crypto library's AES-CTR support is optimized with AES-NI
(without AVX), the similar code in aesni-intel is redundant.  Remove it.

This only affects the non-AVX implementation ("ctr-aes-aesni"), not
aes-ctr-avx-x86_64.S which is handled later.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/x86/crypto/aesni-intel_asm.S  | 125 -----------------------------
 arch/x86/crypto/aesni-intel_glue.c |  60 --------------
 2 files changed, 185 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_asm.S b/arch/x86/crypto/aesni-intel_asm.S
index 16c406781b24..c4d54c4a2c23 100644
--- a/arch/x86/crypto/aesni-intel_asm.S
+++ b/arch/x86/crypto/aesni-intel_asm.S
@@ -33,10 +33,6 @@
 #define KEY	%xmm2
 #define IV	%xmm3
 
-#define BSWAP_MASK %xmm10
-#define CTR	%xmm11
-#define INC	%xmm12
-
 #define GF128MUL_MASK %xmm7
 
 #ifdef __x86_64__
@@ -51,7 +47,6 @@
 #define T1	%r10
 #define TKEYP	T1
 #define T2	%r11
-#define TCTR_LOW T2
 #else
 #define AREG	%eax
 #define KEYP	%edi
@@ -610,128 +605,8 @@ SYM_FUNC_END(_aesni_dec4)
 	.byte		0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f
 	.byte		0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80
 	.byte		0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80
-#ifdef __x86_64__
-.Lbswap_mask:
-	.byte 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0
-#endif
 .popsection
 
-#ifdef __x86_64__
-/*
- * _aesni_inc_init:	internal ABI
- *	setup registers used by _aesni_inc
- * input:
- *	IV
- * output:
- *	CTR:	== IV, in little endian
- *	TCTR_LOW: == lower qword of CTR
- *	INC:	== 1, in little endian
- *	BSWAP_MASK == endian swapping mask
- */
-SYM_FUNC_START_LOCAL(_aesni_inc_init)
-	movaps .Lbswap_mask(%rip), BSWAP_MASK
-	movaps IV, CTR
-	pshufb BSWAP_MASK, CTR
-	mov $1, TCTR_LOW
-	movq TCTR_LOW, INC
-	movq CTR, TCTR_LOW
-	RET
-SYM_FUNC_END(_aesni_inc_init)
-
-/*
- * _aesni_inc:		internal ABI
- *	Increase IV by 1, IV is in big endian
- * input:
- *	IV
- *	CTR:	== IV, in little endian
- *	TCTR_LOW: == lower qword of CTR
- *	INC:	== 1, in little endian
- *	BSWAP_MASK == endian swapping mask
- * output:
- *	IV:	Increase by 1
- * changed:
- *	CTR:	== output IV, in little endian
- *	TCTR_LOW: == lower qword of CTR
- */
-SYM_FUNC_START_LOCAL(_aesni_inc)
-	paddq INC, CTR
-	add $1, TCTR_LOW
-	jnc .Linc_low
-	pslldq $8, INC
-	paddq INC, CTR
-	psrldq $8, INC
-.Linc_low:
-	movaps CTR, IV
-	pshufb BSWAP_MASK, IV
-	RET
-SYM_FUNC_END(_aesni_inc)
-
-/*
- * void aesni_ctr_enc(struct crypto_aes_ctx *ctx, const u8 *dst, u8 *src,
- *		      size_t len, u8 *iv)
- */
-SYM_FUNC_START(aesni_ctr_enc)
-	ANNOTATE_NOENDBR
-	FRAME_BEGIN
-	cmp $16, LEN
-	jb .Lctr_enc_just_ret
-	mov 480(KEYP), KLEN
-	movups (IVP), IV
-	call _aesni_inc_init
-	cmp $64, LEN
-	jb .Lctr_enc_loop1
-.align 4
-.Lctr_enc_loop4:
-	movaps IV, STATE1
-	call _aesni_inc
-	movups (INP), IN1
-	movaps IV, STATE2
-	call _aesni_inc
-	movups 0x10(INP), IN2
-	movaps IV, STATE3
-	call _aesni_inc
-	movups 0x20(INP), IN3
-	movaps IV, STATE4
-	call _aesni_inc
-	movups 0x30(INP), IN4
-	call _aesni_enc4
-	pxor IN1, STATE1
-	movups STATE1, (OUTP)
-	pxor IN2, STATE2
-	movups STATE2, 0x10(OUTP)
-	pxor IN3, STATE3
-	movups STATE3, 0x20(OUTP)
-	pxor IN4, STATE4
-	movups STATE4, 0x30(OUTP)
-	sub $64, LEN
-	add $64, INP
-	add $64, OUTP
-	cmp $64, LEN
-	jge .Lctr_enc_loop4
-	cmp $16, LEN
-	jb .Lctr_enc_ret
-.align 4
-.Lctr_enc_loop1:
-	movaps IV, STATE
-	call _aesni_inc
-	movups (INP), IN
-	call _aesni_enc1
-	pxor IN, STATE
-	movups STATE, (OUTP)
-	sub $16, LEN
-	add $16, INP
-	add $16, OUTP
-	cmp $16, LEN
-	jge .Lctr_enc_loop1
-.Lctr_enc_ret:
-	movups IV, (IVP)
-.Lctr_enc_just_ret:
-	FRAME_END
-	RET
-SYM_FUNC_END(aesni_ctr_enc)
-
-#endif
-
 .section	.rodata.cst16.gf128mul_x_ble_mask, "aM", @progbits, 16
 .align 16
 .Lgf128mul_x_ble_mask:
diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 00b74acd01bd..7d248f2719c2 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -68,11 +68,6 @@ asmlinkage void aesni_xts_enc(const struct crypto_aes_ctx *ctx, u8 *out,
 asmlinkage void aesni_xts_dec(const struct crypto_aes_ctx *ctx, u8 *out,
 			      const u8 *in, unsigned int len, u8 *iv);
 
-#ifdef CONFIG_X86_64
-asmlinkage void aesni_ctr_enc(struct crypto_aes_ctx *ctx, u8 *out,
-			      const u8 *in, unsigned int len, u8 *iv);
-#endif
-
 static inline struct crypto_aes_ctx *aes_ctx(void *raw_ctx)
 {
 	return aes_align_addr(raw_ctx);
@@ -107,42 +102,6 @@ static int aesni_skcipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
 	return aes_set_key_common(aes_ctx(crypto_skcipher_ctx(tfm)), key, len);
 }
 
-#ifdef CONFIG_X86_64
-/* This is the non-AVX version. */
-static int ctr_crypt_aesni(struct skcipher_request *req)
-{
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct crypto_aes_ctx *ctx = aes_ctx(crypto_skcipher_ctx(tfm));
-	u8 keystream[AES_BLOCK_SIZE];
-	struct skcipher_walk walk;
-	unsigned int nbytes;
-	int err;
-
-	err = skcipher_walk_virt(&walk, req, false);
-
-	while ((nbytes = walk.nbytes) > 0) {
-		kernel_fpu_begin();
-		if (nbytes & AES_BLOCK_MASK)
-			aesni_ctr_enc(ctx, walk.dst.virt.addr,
-				      walk.src.virt.addr,
-				      nbytes & AES_BLOCK_MASK, walk.iv);
-		nbytes &= ~AES_BLOCK_MASK;
-
-		if (walk.nbytes == walk.total && nbytes > 0) {
-			aesni_enc(ctx, keystream, walk.iv);
-			crypto_xor_cpy(walk.dst.virt.addr + walk.nbytes - nbytes,
-				       walk.src.virt.addr + walk.nbytes - nbytes,
-				       keystream, nbytes);
-			crypto_inc(walk.iv, AES_BLOCK_SIZE);
-			nbytes = 0;
-		}
-		kernel_fpu_end();
-		err = skcipher_walk_done(&walk, nbytes);
-	}
-	return err;
-}
-#endif
-
 static int xts_setkey_aesni(struct crypto_skcipher *tfm, const u8 *key,
 			    unsigned int keylen)
 {
@@ -300,25 +259,6 @@ static int xts_decrypt_aesni(struct skcipher_request *req)
 }
 
 static struct skcipher_alg aesni_skciphers[] = {
-#ifdef CONFIG_X86_64
-	{
-		.base = {
-			.cra_name		= "ctr(aes)",
-			.cra_driver_name	= "ctr-aes-aesni",
-			.cra_priority		= 400,
-			.cra_blocksize		= 1,
-			.cra_ctxsize		= CRYPTO_AES_CTX_SIZE,
-			.cra_module		= THIS_MODULE,
-		},
-		.min_keysize	= AES_MIN_KEY_SIZE,
-		.max_keysize	= AES_MAX_KEY_SIZE,
-		.ivsize		= AES_BLOCK_SIZE,
-		.chunksize	= AES_BLOCK_SIZE,
-		.setkey		= aesni_skcipher_setkey,
-		.encrypt	= ctr_crypt_aesni,
-		.decrypt	= ctr_crypt_aesni,
-	},
-#endif
 	{
 		.base = {
 			.cra_name		= "xts(aes)",
-- 
2.55.0

