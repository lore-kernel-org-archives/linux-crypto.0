Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE6E9213E9F;
	Wed,  5 Feb 2025 03:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738727466; cv=none; b=u2+crxlTfObkQVLOc8d6ACy/gGrtLCxS+oQz7AYLxOrWBiHb2VC2FA00K/KDoaS4krMgeI1MUGum3ZUHoraEoK4j0YB7XiK2S03A8i+R06VeLwVupkxeZQYjDkcq7TyihhFyvSJH6eCUy0fwabp+G1TsgbtZAQX07DYUgF+tdl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738727466; c=relaxed/simple;
	bh=g19QypyPUBhdQqYdeifkwuCQwH/ucoDnEdkDJy6FXjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a8N+4UHsTo2U/VzPxPR6aiYVTTOsB58qHZ/OX7ISkWfeqx+L5i6hLBASGrpaU40hsxCb3ldf1hX4/Aj6mzXCfNnFGLatUn0cfEXjuS+EB3EDn9dYYUMqlRL/JreU4pMMJ4/yK7EkDsegCBvNGFN8d6kA0efEGbh2RpE24L9QYZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DShfGORC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DShfGORC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FDADC4CEE5;
	Wed,  5 Feb 2025 03:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738727465;
	bh=g19QypyPUBhdQqYdeifkwuCQwH/ucoDnEdkDJy6FXjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DShfGORCJycpYPIMR7dIuttwRb1lGp5NblC6+obaxRJZ6JT3if5LL8N+fFHVHaRcX
	 cjGStvS8QBnTCaoMMr6CKZEWy8wZBVkBjiyLi4lbp4LZPUt8b7FUtMfvpzGHTaNp1G
	 auz8GIL15HYoNhwF9XUuvm/+kl9MVeqDQW5NHpprt+AzWv0R6yGOan8ONdR0iNI+rr
	 mbpPZ8pURWpYPoAdVOaZEv9xeImagH0xX6ZqJl3iKkhWd8dsgC+qHxbfm/syawGe/l
	 6vnu/QIHL8LHDx0opuS9qyFB6PcOUVoWb8ZacLosd9k4rpYCto8htHB4wXkRdkiuq6
	 W+tCAwa0Wph3w==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] crypto: x86/aes-ctr - remove non-AVX implementation of AES-CTR
Date: Tue,  4 Feb 2025 19:50:26 -0800
Message-ID: <20250205035026.116976-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205035026.116976-1-ebiggers@kernel.org>
References: <20250205035026.116976-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Nearly all x86_64 CPUs with AES-NI also support AVX.  The exceptions are
Intel Westmere from 2010, and the low-power Intel CPU microarchitectures
Silvermont, Goldmont, and Tremont from 2013 through 2020.  Tremont's
successor, Gracemont (launched in 2021), supports AVX.  It is unlikely
that any more non-AVX-capable x86_64 CPUs will be released.

Supporting non-AVX x86_64 SIMD assembly code is a major burden, given
the differences between VEX and non-VEX code.  It is probably still
worth doing for the most common algorithms like xts(aes) and gcm(aes).
ctr(aes) seems unlikely to be one of these; it can be used in IPsec
together with a standalone MAC if the better option of gcm(aes) is not
being used, but it is not useful for much else in the kernel.

Therefore, let's drop the non-AVX implementation of ctr(aes).

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/aesni-intel_asm.S  | 125 -----------------------------
 arch/x86/crypto/aesni-intel_glue.c |  59 --------------
 2 files changed, 184 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_asm.S b/arch/x86/crypto/aesni-intel_asm.S
index eb153eff9331a..8a78e6b5940c0 100644
--- a/arch/x86/crypto/aesni-intel_asm.S
+++ b/arch/x86/crypto/aesni-intel_asm.S
@@ -30,14 +30,10 @@
 #define IN4	%xmm9
 #define IN	IN1
 #define KEY	%xmm2
 #define IV	%xmm3
 
-#define BSWAP_MASK %xmm10
-#define CTR	%xmm11
-#define INC	%xmm12
-
 #define GF128MUL_MASK %xmm7
 
 #ifdef __x86_64__
 #define AREG	%rax
 #define KEYP	%rdi
@@ -47,12 +43,10 @@
 #define LEN	%rcx
 #define IVP	%r8
 #define KLEN	%r9d
 #define T1	%r10
 #define TKEYP	T1
-#define T2	%r11
-#define TCTR_LOW T2
 #else
 #define AREG	%eax
 #define KEYP	%edi
 #define OUTP	AREG
 #define UKEYP	OUTP
@@ -1008,131 +1002,12 @@ SYM_FUNC_END(aesni_cts_cbc_dec)
 	.byte		0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80
 	.byte		0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07
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
 	.octa 0x00000000000000010000000000000087
 .previous
diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 06cc0ae4bb200..150ee2f690151 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -78,15 +78,10 @@ asmlinkage void aesni_xts_enc(const struct crypto_aes_ctx *ctx, u8 *out,
 			      const u8 *in, unsigned int len, u8 *iv);
 
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
 }
 
@@ -350,45 +345,10 @@ static int cts_cbc_decrypt(struct skcipher_request *req)
 	kernel_fpu_end();
 
 	return skcipher_walk_done(&walk, 0);
 }
 
-#ifdef CONFIG_X86_64
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
 	struct aesni_xts_ctx *ctx = aes_xts_ctx(tfm);
 	int err;
@@ -619,29 +579,10 @@ static struct skcipher_alg aesni_skciphers[] = {
 		.ivsize		= AES_BLOCK_SIZE,
 		.walksize	= 2 * AES_BLOCK_SIZE,
 		.setkey		= aesni_skcipher_setkey,
 		.encrypt	= cts_cbc_encrypt,
 		.decrypt	= cts_cbc_decrypt,
-#ifdef CONFIG_X86_64
-	}, {
-		.base = {
-			.cra_name		= "__ctr(aes)",
-			.cra_driver_name	= "__ctr-aes-aesni",
-			.cra_priority		= 400,
-			.cra_flags		= CRYPTO_ALG_INTERNAL,
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
-#endif
 	}, {
 		.base = {
 			.cra_name		= "__xts(aes)",
 			.cra_driver_name	= "__xts-aes-aesni",
 			.cra_priority		= 401,
-- 
2.48.1

