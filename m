Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7375443933F;
	Sun, 27 Sep 2026 22:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790549084; cv=none; b=jd7wZIkjKXp9MiQxxlOtk88rvVuK2IgO3eGBxSG02rExKqvCV43xXhhb15Wn05uA5f3vb6qlha6fYKt8ycLikTqqc5ARWXWtELdemRyrqDypPpYqtyMmNTHjyv+MkWQi/V4cDDJ1dHNqM3vu3dGvuVvPtYVPPQ+bF9S1eP5XOOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790549084; c=relaxed/simple;
	bh=Vo7Vw+QFhxEUzAEOpIjkRBmTcLjtu4B689bXxLXY3eE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uv1YpCVwymzDOW/EyZGDXRxut3yPkSrsh6TmNYoD5nSLxkq35jboPGyN4eXLfSNN1w01J68LMLCM1L+82g2N61RlQkwTGB8zUT63rYOfvnhdnSlPGa/SAcF8H1jPPczSoiv0TlMGhvd40IRactWTPMikflxzrfu3tVfIFjohp+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A1B43ORS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A1B43ORS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E912B1F0089A;
	Sun, 27 Sep 2026 22:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790549082;
	bh=AZLhnhaBithMbn3TNQO0ewB/guRbssycY3Z3nXa82xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A1B43ORSYtZLfXzeUFrs2QHfLexjpVwS6U0NLIUTPq57dsJAQATNZKNHQX9iJ722r
	 OZBGwRRS6cFfB8DdNMfxMKfjnau9qfUEEpoaabCEwLBw8f7wYctDyPSWf+gZnyfEbs
	 hiUka+hMHkqiv0AtGvVNQZO4FST9joADyEZqs1ARjV/J5C8jTHoqVEUG+gxb/CNBdk
	 l3MPqBkCWCKVdVqNT4YkOeGL00bzWh6x6g06AtNOzGIkgukxeFtTVzffkGiHFP1dYI
	 JX4zmsLhEc6d+ME++gW5eJ69cVh4gMsufbtfnHwBvttHH4OmsCo2AsHretRqkw8ebi
	 Pvgx9c9AY2LiA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org,
	linux-riscv@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 09/20] crypto: x86/aes-ecb - Remove superseded ECB skcipher
Date: Sun, 27 Sep 2026 15:43:00 -0700
Message-ID: <20260927224418.109759-10-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260927224418.109759-1-ebiggers@kernel.org>
References: <20260927224418.109759-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that the AES-ECB library functions are optimized with dedicated
AES-NI code and exposed via the skcipher API via crypto/aes.c, the
similar implementation in aesni-intel is redundant.  Remove it.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/x86/crypto/Kconfig            |   4 +-
 arch/x86/crypto/aesni-intel_asm.S  | 121 -----------------------------
 arch/x86/crypto/aesni-intel_glue.c |  62 ---------------
 3 files changed, 2 insertions(+), 185 deletions(-)

diff --git a/arch/x86/crypto/Kconfig b/arch/x86/crypto/Kconfig
index 3c4c582e7f2d..f7c4243dd187 100644
--- a/arch/x86/crypto/Kconfig
+++ b/arch/x86/crypto/Kconfig
@@ -3,7 +3,7 @@
 menu "Accelerated Cryptographic Algorithms for CPU (x86)"
 
 config CRYPTO_AES_NI_INTEL
-	tristate "Ciphers: AES, modes: ECB, CBC, CTS, CTR, XCTR, XTS, GCM (AES-NI/VAES)"
+	tristate "Ciphers: AES, modes: CBC, CTS, CTR, XCTR, XTS, GCM (AES-NI/VAES)"
 	depends on 64BIT
 	select CRYPTO_AEAD
 	select CRYPTO_LIB_AES
@@ -11,7 +11,7 @@ config CRYPTO_AES_NI_INTEL
 	select CRYPTO_SKCIPHER
 	help
 	  AEAD cipher: AES with GCM
-	  Length-preserving ciphers: AES with ECB, CBC, CTS, CTR, XCTR, XTS
+	  Length-preserving ciphers: AES with CBC, CTS, CTR, XCTR, XTS
 
 	  Architecture: x86_64 using:
 	  - AES-NI (AES new instructions)
diff --git a/arch/x86/crypto/aesni-intel_asm.S b/arch/x86/crypto/aesni-intel_asm.S
index 6abe5e38a6d7..db7f259ee8ab 100644
--- a/arch/x86/crypto/aesni-intel_asm.S
+++ b/arch/x86/crypto/aesni-intel_asm.S
@@ -601,127 +601,6 @@ SYM_FUNC_START_LOCAL(_aesni_dec4)
 	RET
 SYM_FUNC_END(_aesni_dec4)
 
-/*
- * void aesni_ecb_enc(struct crypto_aes_ctx *ctx, const u8 *dst, u8 *src,
- *		      size_t len)
- */
-SYM_FUNC_START(aesni_ecb_enc)
-	FRAME_BEGIN
-#ifndef __x86_64__
-	pushl LEN
-	pushl KEYP
-	pushl KLEN
-	movl (FRAME_OFFSET+16)(%esp), KEYP	# ctx
-	movl (FRAME_OFFSET+20)(%esp), OUTP	# dst
-	movl (FRAME_OFFSET+24)(%esp), INP	# src
-	movl (FRAME_OFFSET+28)(%esp), LEN	# len
-#endif
-	test LEN, LEN		# check length
-	jz .Lecb_enc_ret
-	mov 480(KEYP), KLEN
-	cmp $16, LEN
-	jb .Lecb_enc_ret
-	cmp $64, LEN
-	jb .Lecb_enc_loop1
-.align 4
-.Lecb_enc_loop4:
-	movups (INP), STATE1
-	movups 0x10(INP), STATE2
-	movups 0x20(INP), STATE3
-	movups 0x30(INP), STATE4
-	call _aesni_enc4
-	movups STATE1, (OUTP)
-	movups STATE2, 0x10(OUTP)
-	movups STATE3, 0x20(OUTP)
-	movups STATE4, 0x30(OUTP)
-	sub $64, LEN
-	add $64, INP
-	add $64, OUTP
-	cmp $64, LEN
-	jge .Lecb_enc_loop4
-	cmp $16, LEN
-	jb .Lecb_enc_ret
-.align 4
-.Lecb_enc_loop1:
-	movups (INP), STATE1
-	call _aesni_enc1
-	movups STATE1, (OUTP)
-	sub $16, LEN
-	add $16, INP
-	add $16, OUTP
-	cmp $16, LEN
-	jge .Lecb_enc_loop1
-.Lecb_enc_ret:
-#ifndef __x86_64__
-	popl KLEN
-	popl KEYP
-	popl LEN
-#endif
-	FRAME_END
-	RET
-SYM_FUNC_END(aesni_ecb_enc)
-
-/*
- * void aesni_ecb_dec(struct crypto_aes_ctx *ctx, const u8 *dst, u8 *src,
- *		      size_t len);
- */
-SYM_FUNC_START(aesni_ecb_dec)
-	FRAME_BEGIN
-#ifndef __x86_64__
-	pushl LEN
-	pushl KEYP
-	pushl KLEN
-	movl (FRAME_OFFSET+16)(%esp), KEYP	# ctx
-	movl (FRAME_OFFSET+20)(%esp), OUTP	# dst
-	movl (FRAME_OFFSET+24)(%esp), INP	# src
-	movl (FRAME_OFFSET+28)(%esp), LEN	# len
-#endif
-	test LEN, LEN
-	jz .Lecb_dec_ret
-	mov 480(KEYP), KLEN
-	add $240, KEYP
-	cmp $16, LEN
-	jb .Lecb_dec_ret
-	cmp $64, LEN
-	jb .Lecb_dec_loop1
-.align 4
-.Lecb_dec_loop4:
-	movups (INP), STATE1
-	movups 0x10(INP), STATE2
-	movups 0x20(INP), STATE3
-	movups 0x30(INP), STATE4
-	call _aesni_dec4
-	movups STATE1, (OUTP)
-	movups STATE2, 0x10(OUTP)
-	movups STATE3, 0x20(OUTP)
-	movups STATE4, 0x30(OUTP)
-	sub $64, LEN
-	add $64, INP
-	add $64, OUTP
-	cmp $64, LEN
-	jge .Lecb_dec_loop4
-	cmp $16, LEN
-	jb .Lecb_dec_ret
-.align 4
-.Lecb_dec_loop1:
-	movups (INP), STATE1
-	call _aesni_dec1
-	movups STATE1, (OUTP)
-	sub $16, LEN
-	add $16, INP
-	add $16, OUTP
-	cmp $16, LEN
-	jge .Lecb_dec_loop1
-.Lecb_dec_ret:
-#ifndef __x86_64__
-	popl KLEN
-	popl KEYP
-	popl LEN
-#endif
-	FRAME_END
-	RET
-SYM_FUNC_END(aesni_ecb_dec)
-
 /*
  * void aesni_cbc_enc(struct crypto_aes_ctx *ctx, const u8 *dst, u8 *src,
  *		      size_t len, u8 *iv)
diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 259e319ff92b..c37976d06f45 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -61,10 +61,6 @@ static inline void *aes_align_addr(void *addr)
 asmlinkage void aesni_set_key(struct crypto_aes_ctx *ctx, const u8 *in_key,
 			      unsigned int key_len);
 asmlinkage void aesni_enc(const void *ctx, u8 *out, const u8 *in);
-asmlinkage void aesni_ecb_enc(struct crypto_aes_ctx *ctx, u8 *out,
-			      const u8 *in, unsigned int len);
-asmlinkage void aesni_ecb_dec(struct crypto_aes_ctx *ctx, u8 *out,
-			      const u8 *in, unsigned int len);
 asmlinkage void aesni_cbc_enc(struct crypto_aes_ctx *ctx, u8 *out,
 			      const u8 *in, unsigned int len, u8 *iv);
 asmlinkage void aesni_cbc_dec(struct crypto_aes_ctx *ctx, u8 *out,
@@ -117,50 +113,6 @@ static int aesni_skcipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
 	return aes_set_key_common(aes_ctx(crypto_skcipher_ctx(tfm)), key, len);
 }
 
-static int ecb_encrypt(struct skcipher_request *req)
-{
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct crypto_aes_ctx *ctx = aes_ctx(crypto_skcipher_ctx(tfm));
-	struct skcipher_walk walk;
-	unsigned int nbytes;
-	int err;
-
-	err = skcipher_walk_virt(&walk, req, false);
-
-	while ((nbytes = walk.nbytes)) {
-		kernel_fpu_begin();
-		aesni_ecb_enc(ctx, walk.dst.virt.addr, walk.src.virt.addr,
-			      nbytes & AES_BLOCK_MASK);
-		kernel_fpu_end();
-		nbytes &= AES_BLOCK_SIZE - 1;
-		err = skcipher_walk_done(&walk, nbytes);
-	}
-
-	return err;
-}
-
-static int ecb_decrypt(struct skcipher_request *req)
-{
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct crypto_aes_ctx *ctx = aes_ctx(crypto_skcipher_ctx(tfm));
-	struct skcipher_walk walk;
-	unsigned int nbytes;
-	int err;
-
-	err = skcipher_walk_virt(&walk, req, false);
-
-	while ((nbytes = walk.nbytes)) {
-		kernel_fpu_begin();
-		aesni_ecb_dec(ctx, walk.dst.virt.addr, walk.src.virt.addr,
-			      nbytes & AES_BLOCK_MASK);
-		kernel_fpu_end();
-		nbytes &= AES_BLOCK_SIZE - 1;
-		err = skcipher_walk_done(&walk, nbytes);
-	}
-
-	return err;
-}
-
 static int cbc_encrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
@@ -508,20 +460,6 @@ static int xts_decrypt_aesni(struct skcipher_request *req)
 
 static struct skcipher_alg aesni_skciphers[] = {
 	{
-		.base = {
-			.cra_name		= "ecb(aes)",
-			.cra_driver_name	= "ecb-aes-aesni",
-			.cra_priority		= 400,
-			.cra_blocksize		= AES_BLOCK_SIZE,
-			.cra_ctxsize		= CRYPTO_AES_CTX_SIZE,
-			.cra_module		= THIS_MODULE,
-		},
-		.min_keysize	= AES_MIN_KEY_SIZE,
-		.max_keysize	= AES_MAX_KEY_SIZE,
-		.setkey		= aesni_skcipher_setkey,
-		.encrypt	= ecb_encrypt,
-		.decrypt	= ecb_decrypt,
-	}, {
 		.base = {
 			.cra_name		= "cbc(aes)",
 			.cra_driver_name	= "cbc-aes-aesni",
-- 
2.55.0

