Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E942635C689;
	Mon, 21 Sep 2026 05:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789967770; cv=none; b=S+hIi2za5HwYeGOeKBgjfCORbuzb64IZ3t80GJ/+wRdnw24VJ2k0PAhPsLkgQz0/aegvPHDHa7zL54GR5R6qrrf/udHyBOsghltdji7oTTTlTQJkeUtaYLWIcyPT4Rp8TMhvSdZt46daw+ek58XjNJPIt6gOAAuRTtoctqldDag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789967770; c=relaxed/simple;
	bh=TvLg+dq279b46+A4Gq7t5hNia4AK/Oag2NDKCoX56A0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lkRgW3Ifrxz8LGufPxre6O2iNOZy7jDuTurQcmJWq1WYbwytc7xoRJDDBo8iLoAo6Y09AyJiv+WtTOO1C1q6v2UJuulIZ+vJUHm7xgnFkUH84zPNxBeAHWWHWnwGYf7gzxHqPIaEdBELr6KWtc7aQa/IGjXL+ZESf/GZ3FQIMgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f4twR0Dp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f4twR0Dp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7367B1F0089F;
	Mon, 21 Sep 2026 05:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789967766;
	bh=C4Sum1Eo67MmuYPujINFCyTxdf5JAlfxhIYWhng7ASo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f4twR0Dpt6hubSLnA+MUarIVMkfLkmGdDKjE8d/AABHLr+UqEaknCOa0iRm7FuQfe
	 ZNwAaO6LWHpt0Z4Lz04myMYW8bvd+6FKZ+3PKMineMOxRg8s0FcQZMIoSZcnxLLm/E
	 QZ8CNVEX62k0p67SVcdxGR06pcZCiWTc07YdlWz3tFsQYLUWJxuva2osdzVtaoqziI
	 vn1vm2d0Z9Di8Gi4UMxBCzlFx/1p7lSHw2kFNolBTe1WWv73BvHUaB9gO8F/kYK1eV
	 f1KLcMLF+DctppE9ie0tidAKx4BPyvMwuqh3TCVwXIGc4xuXJ1SweiOgkTXhFHv/HU
	 bcAEKgHbp729g==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org,
	linux-riscv@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 09/20] crypto: x86/aes-cbc - Remove superseded CBC skciphers
Date: Sun, 20 Sep 2026 22:08:55 -0700
Message-ID: <20260921050910.296144-10-ebiggers@kernel.org>
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

Now that the AES-CBC (and AES-CBC-CTS) library functions are optimized
with dedicated AES-NI code and exposed via the skcipher API via
crypto/aes.c, the similar implementation in aesni-intel is redundant.
Remove it.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/x86/crypto/Kconfig            |   4 +-
 arch/x86/crypto/aesni-intel_asm.S  | 255 -----------------------------
 arch/x86/crypto/aesni-intel_glue.c | 200 +---------------------
 3 files changed, 5 insertions(+), 454 deletions(-)

diff --git a/arch/x86/crypto/Kconfig b/arch/x86/crypto/Kconfig
index ecd4931557a3..6dbf5e083966 100644
--- a/arch/x86/crypto/Kconfig
+++ b/arch/x86/crypto/Kconfig
@@ -3,14 +3,14 @@
 menu "Accelerated Cryptographic Algorithms for CPU (x86)"
 
 config CRYPTO_AES_NI_INTEL
-	tristate "Ciphers: AES, modes: CBC, CTS, CTR, XCTR, XTS, GCM (AES-NI/VAES)"
+	tristate "Ciphers: AES, modes: CTR, XCTR, XTS, GCM (AES-NI/VAES)"
 	select CRYPTO_AEAD
 	select CRYPTO_LIB_AES
 	select CRYPTO_LIB_GF128MUL
 	select CRYPTO_SKCIPHER
 	help
 	  AEAD cipher: AES with GCM
-	  Length-preserving ciphers: AES with CBC, CTS, CTR, XCTR, XTS
+	  Length-preserving ciphers: AES with CTR, XCTR, XTS
 
 	  Architecture: x86 (32-bit and 64-bit) using:
 	  - AES-NI (AES new instructions)
diff --git a/arch/x86/crypto/aesni-intel_asm.S b/arch/x86/crypto/aesni-intel_asm.S
index db7f259ee8ab..16c406781b24 100644
--- a/arch/x86/crypto/aesni-intel_asm.S
+++ b/arch/x86/crypto/aesni-intel_asm.S
@@ -601,261 +601,6 @@ SYM_FUNC_START_LOCAL(_aesni_dec4)
 	RET
 SYM_FUNC_END(_aesni_dec4)
 
-/*
- * void aesni_cbc_enc(struct crypto_aes_ctx *ctx, const u8 *dst, u8 *src,
- *		      size_t len, u8 *iv)
- */
-SYM_FUNC_START(aesni_cbc_enc)
-	FRAME_BEGIN
-#ifndef __x86_64__
-	pushl IVP
-	pushl LEN
-	pushl KEYP
-	pushl KLEN
-	movl (FRAME_OFFSET+20)(%esp), KEYP	# ctx
-	movl (FRAME_OFFSET+24)(%esp), OUTP	# dst
-	movl (FRAME_OFFSET+28)(%esp), INP	# src
-	movl (FRAME_OFFSET+32)(%esp), LEN	# len
-	movl (FRAME_OFFSET+36)(%esp), IVP	# iv
-#endif
-	cmp $16, LEN
-	jb .Lcbc_enc_ret
-	mov 480(KEYP), KLEN
-	movups (IVP), STATE	# load iv as initial state
-.align 4
-.Lcbc_enc_loop:
-	movups (INP), IN	# load input
-	pxor IN, STATE
-	call _aesni_enc1
-	movups STATE, (OUTP)	# store output
-	sub $16, LEN
-	add $16, INP
-	add $16, OUTP
-	cmp $16, LEN
-	jge .Lcbc_enc_loop
-	movups STATE, (IVP)
-.Lcbc_enc_ret:
-#ifndef __x86_64__
-	popl KLEN
-	popl KEYP
-	popl LEN
-	popl IVP
-#endif
-	FRAME_END
-	RET
-SYM_FUNC_END(aesni_cbc_enc)
-
-/*
- * void aesni_cbc_dec(struct crypto_aes_ctx *ctx, const u8 *dst, u8 *src,
- *		      size_t len, u8 *iv)
- */
-SYM_FUNC_START(aesni_cbc_dec)
-	FRAME_BEGIN
-#ifndef __x86_64__
-	pushl IVP
-	pushl LEN
-	pushl KEYP
-	pushl KLEN
-	movl (FRAME_OFFSET+20)(%esp), KEYP	# ctx
-	movl (FRAME_OFFSET+24)(%esp), OUTP	# dst
-	movl (FRAME_OFFSET+28)(%esp), INP	# src
-	movl (FRAME_OFFSET+32)(%esp), LEN	# len
-	movl (FRAME_OFFSET+36)(%esp), IVP	# iv
-#endif
-	cmp $16, LEN
-	jb .Lcbc_dec_just_ret
-	mov 480(KEYP), KLEN
-	add $240, KEYP
-	movups (IVP), IV
-	cmp $64, LEN
-	jb .Lcbc_dec_loop1
-.align 4
-.Lcbc_dec_loop4:
-	movups (INP), IN1
-	movaps IN1, STATE1
-	movups 0x10(INP), IN2
-	movaps IN2, STATE2
-#ifdef __x86_64__
-	movups 0x20(INP), IN3
-	movaps IN3, STATE3
-	movups 0x30(INP), IN4
-	movaps IN4, STATE4
-#else
-	movups 0x20(INP), IN1
-	movaps IN1, STATE3
-	movups 0x30(INP), IN2
-	movaps IN2, STATE4
-#endif
-	call _aesni_dec4
-	pxor IV, STATE1
-#ifdef __x86_64__
-	pxor IN1, STATE2
-	pxor IN2, STATE3
-	pxor IN3, STATE4
-	movaps IN4, IV
-#else
-	pxor IN1, STATE4
-	movaps IN2, IV
-	movups (INP), IN1
-	pxor IN1, STATE2
-	movups 0x10(INP), IN2
-	pxor IN2, STATE3
-#endif
-	movups STATE1, (OUTP)
-	movups STATE2, 0x10(OUTP)
-	movups STATE3, 0x20(OUTP)
-	movups STATE4, 0x30(OUTP)
-	sub $64, LEN
-	add $64, INP
-	add $64, OUTP
-	cmp $64, LEN
-	jge .Lcbc_dec_loop4
-	cmp $16, LEN
-	jb .Lcbc_dec_ret
-.align 4
-.Lcbc_dec_loop1:
-	movups (INP), IN
-	movaps IN, STATE
-	call _aesni_dec1
-	pxor IV, STATE
-	movups STATE, (OUTP)
-	movaps IN, IV
-	sub $16, LEN
-	add $16, INP
-	add $16, OUTP
-	cmp $16, LEN
-	jge .Lcbc_dec_loop1
-.Lcbc_dec_ret:
-	movups IV, (IVP)
-.Lcbc_dec_just_ret:
-#ifndef __x86_64__
-	popl KLEN
-	popl KEYP
-	popl LEN
-	popl IVP
-#endif
-	FRAME_END
-	RET
-SYM_FUNC_END(aesni_cbc_dec)
-
-/*
- * void aesni_cts_cbc_enc(struct crypto_aes_ctx *ctx, const u8 *dst, u8 *src,
- *			  size_t len, u8 *iv)
- */
-SYM_FUNC_START(aesni_cts_cbc_enc)
-	FRAME_BEGIN
-#ifndef __x86_64__
-	pushl IVP
-	pushl LEN
-	pushl KEYP
-	pushl KLEN
-	movl (FRAME_OFFSET+20)(%esp), KEYP	# ctx
-	movl (FRAME_OFFSET+24)(%esp), OUTP	# dst
-	movl (FRAME_OFFSET+28)(%esp), INP	# src
-	movl (FRAME_OFFSET+32)(%esp), LEN	# len
-	movl (FRAME_OFFSET+36)(%esp), IVP	# iv
-	lea .Lcts_permute_table, T1
-#else
-	lea .Lcts_permute_table(%rip), T1
-#endif
-	mov 480(KEYP), KLEN
-	movups (IVP), STATE
-	sub $16, LEN
-	mov T1, IVP
-	add $32, IVP
-	add LEN, T1
-	sub LEN, IVP
-	movups (T1), %xmm4
-	movups (IVP), %xmm5
-
-	movups (INP), IN1
-	add LEN, INP
-	movups (INP), IN2
-
-	pxor IN1, STATE
-	call _aesni_enc1
-
-	pshufb %xmm5, IN2
-	pxor STATE, IN2
-	pshufb %xmm4, STATE
-	add OUTP, LEN
-	movups STATE, (LEN)
-
-	movaps IN2, STATE
-	call _aesni_enc1
-	movups STATE, (OUTP)
-
-#ifndef __x86_64__
-	popl KLEN
-	popl KEYP
-	popl LEN
-	popl IVP
-#endif
-	FRAME_END
-	RET
-SYM_FUNC_END(aesni_cts_cbc_enc)
-
-/*
- * void aesni_cts_cbc_dec(struct crypto_aes_ctx *ctx, const u8 *dst, u8 *src,
- *			  size_t len, u8 *iv)
- */
-SYM_FUNC_START(aesni_cts_cbc_dec)
-	FRAME_BEGIN
-#ifndef __x86_64__
-	pushl IVP
-	pushl LEN
-	pushl KEYP
-	pushl KLEN
-	movl (FRAME_OFFSET+20)(%esp), KEYP	# ctx
-	movl (FRAME_OFFSET+24)(%esp), OUTP	# dst
-	movl (FRAME_OFFSET+28)(%esp), INP	# src
-	movl (FRAME_OFFSET+32)(%esp), LEN	# len
-	movl (FRAME_OFFSET+36)(%esp), IVP	# iv
-	lea .Lcts_permute_table, T1
-#else
-	lea .Lcts_permute_table(%rip), T1
-#endif
-	mov 480(KEYP), KLEN
-	add $240, KEYP
-	movups (IVP), IV
-	sub $16, LEN
-	mov T1, IVP
-	add $32, IVP
-	add LEN, T1
-	sub LEN, IVP
-	movups (T1), %xmm4
-
-	movups (INP), STATE
-	add LEN, INP
-	movups (INP), IN1
-
-	call _aesni_dec1
-	movaps STATE, IN2
-	pshufb %xmm4, STATE
-	pxor IN1, STATE
-
-	add OUTP, LEN
-	movups STATE, (LEN)
-
-	movups (IVP), %xmm0
-	pshufb %xmm0, IN1
-	pblendvb IN2, IN1
-	movaps IN1, STATE
-	call _aesni_dec1
-
-	pxor IV, STATE
-	movups STATE, (OUTP)
-
-#ifndef __x86_64__
-	popl KLEN
-	popl KEYP
-	popl LEN
-	popl IVP
-#endif
-	FRAME_END
-	RET
-SYM_FUNC_END(aesni_cts_cbc_dec)
-
 .pushsection .rodata
 .align 16
 .Lcts_permute_table:
diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index f3b9cfb0b813..00b74acd01bd 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -61,14 +61,6 @@ static inline void *aes_align_addr(void *addr)
 asmlinkage void aesni_set_key(struct crypto_aes_ctx *ctx, const u8 *in_key,
 			      unsigned int key_len);
 asmlinkage void aesni_enc(const void *ctx, u8 *out, const u8 *in);
-asmlinkage void aesni_cbc_enc(struct crypto_aes_ctx *ctx, u8 *out,
-			      const u8 *in, unsigned int len, u8 *iv);
-asmlinkage void aesni_cbc_dec(struct crypto_aes_ctx *ctx, u8 *out,
-			      const u8 *in, unsigned int len, u8 *iv);
-asmlinkage void aesni_cts_cbc_enc(struct crypto_aes_ctx *ctx, u8 *out,
-				  const u8 *in, unsigned int len, u8 *iv);
-asmlinkage void aesni_cts_cbc_dec(struct crypto_aes_ctx *ctx, u8 *out,
-				  const u8 *in, unsigned int len, u8 *iv);
 
 asmlinkage void aesni_xts_enc(const struct crypto_aes_ctx *ctx, u8 *out,
 			      const u8 *in, unsigned int len, u8 *iv);
@@ -115,162 +107,6 @@ static int aesni_skcipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
 	return aes_set_key_common(aes_ctx(crypto_skcipher_ctx(tfm)), key, len);
 }
 
-static int cbc_encrypt(struct skcipher_request *req)
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
-		aesni_cbc_enc(ctx, walk.dst.virt.addr, walk.src.virt.addr,
-			      nbytes & AES_BLOCK_MASK, walk.iv);
-		kernel_fpu_end();
-		nbytes &= AES_BLOCK_SIZE - 1;
-		err = skcipher_walk_done(&walk, nbytes);
-	}
-
-	return err;
-}
-
-static int cbc_decrypt(struct skcipher_request *req)
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
-		aesni_cbc_dec(ctx, walk.dst.virt.addr, walk.src.virt.addr,
-			      nbytes & AES_BLOCK_MASK, walk.iv);
-		kernel_fpu_end();
-		nbytes &= AES_BLOCK_SIZE - 1;
-		err = skcipher_walk_done(&walk, nbytes);
-	}
-
-	return err;
-}
-
-static int cts_cbc_encrypt(struct skcipher_request *req)
-{
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct crypto_aes_ctx *ctx = aes_ctx(crypto_skcipher_ctx(tfm));
-	int cbc_blocks = DIV_ROUND_UP(req->cryptlen, AES_BLOCK_SIZE) - 2;
-	struct scatterlist *src = req->src, *dst = req->dst;
-	struct scatterlist sg_src[2], sg_dst[2];
-	struct skcipher_request subreq;
-	struct skcipher_walk walk;
-	int err;
-
-	skcipher_request_set_tfm(&subreq, tfm);
-	skcipher_request_set_callback(&subreq, skcipher_request_flags(req),
-				      NULL, NULL);
-
-	if (req->cryptlen <= AES_BLOCK_SIZE) {
-		if (req->cryptlen < AES_BLOCK_SIZE)
-			return -EINVAL;
-		cbc_blocks = 1;
-	}
-
-	if (cbc_blocks > 0) {
-		skcipher_request_set_crypt(&subreq, req->src, req->dst,
-					   cbc_blocks * AES_BLOCK_SIZE,
-					   req->iv);
-
-		err = cbc_encrypt(&subreq);
-		if (err)
-			return err;
-
-		if (req->cryptlen == AES_BLOCK_SIZE)
-			return 0;
-
-		dst = src = scatterwalk_ffwd(sg_src, req->src, subreq.cryptlen);
-		if (req->dst != req->src)
-			dst = scatterwalk_ffwd(sg_dst, req->dst,
-					       subreq.cryptlen);
-	}
-
-	/* handle ciphertext stealing */
-	skcipher_request_set_crypt(&subreq, src, dst,
-				   req->cryptlen - cbc_blocks * AES_BLOCK_SIZE,
-				   req->iv);
-
-	err = skcipher_walk_virt(&walk, &subreq, false);
-	if (err)
-		return err;
-
-	kernel_fpu_begin();
-	aesni_cts_cbc_enc(ctx, walk.dst.virt.addr, walk.src.virt.addr,
-			  walk.nbytes, walk.iv);
-	kernel_fpu_end();
-
-	return skcipher_walk_done(&walk, 0);
-}
-
-static int cts_cbc_decrypt(struct skcipher_request *req)
-{
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct crypto_aes_ctx *ctx = aes_ctx(crypto_skcipher_ctx(tfm));
-	int cbc_blocks = DIV_ROUND_UP(req->cryptlen, AES_BLOCK_SIZE) - 2;
-	struct scatterlist *src = req->src, *dst = req->dst;
-	struct scatterlist sg_src[2], sg_dst[2];
-	struct skcipher_request subreq;
-	struct skcipher_walk walk;
-	int err;
-
-	skcipher_request_set_tfm(&subreq, tfm);
-	skcipher_request_set_callback(&subreq, skcipher_request_flags(req),
-				      NULL, NULL);
-
-	if (req->cryptlen <= AES_BLOCK_SIZE) {
-		if (req->cryptlen < AES_BLOCK_SIZE)
-			return -EINVAL;
-		cbc_blocks = 1;
-	}
-
-	if (cbc_blocks > 0) {
-		skcipher_request_set_crypt(&subreq, req->src, req->dst,
-					   cbc_blocks * AES_BLOCK_SIZE,
-					   req->iv);
-
-		err = cbc_decrypt(&subreq);
-		if (err)
-			return err;
-
-		if (req->cryptlen == AES_BLOCK_SIZE)
-			return 0;
-
-		dst = src = scatterwalk_ffwd(sg_src, req->src, subreq.cryptlen);
-		if (req->dst != req->src)
-			dst = scatterwalk_ffwd(sg_dst, req->dst,
-					       subreq.cryptlen);
-	}
-
-	/* handle ciphertext stealing */
-	skcipher_request_set_crypt(&subreq, src, dst,
-				   req->cryptlen - cbc_blocks * AES_BLOCK_SIZE,
-				   req->iv);
-
-	err = skcipher_walk_virt(&walk, &subreq, false);
-	if (err)
-		return err;
-
-	kernel_fpu_begin();
-	aesni_cts_cbc_dec(ctx, walk.dst.virt.addr, walk.src.virt.addr,
-			  walk.nbytes, walk.iv);
-	kernel_fpu_end();
-
-	return skcipher_walk_done(&walk, 0);
-}
-
 #ifdef CONFIG_X86_64
 /* This is the non-AVX version. */
 static int ctr_crypt_aesni(struct skcipher_request *req)
@@ -464,39 +300,8 @@ static int xts_decrypt_aesni(struct skcipher_request *req)
 }
 
 static struct skcipher_alg aesni_skciphers[] = {
-	{
-		.base = {
-			.cra_name		= "cbc(aes)",
-			.cra_driver_name	= "cbc-aes-aesni",
-			.cra_priority		= 400,
-			.cra_blocksize		= AES_BLOCK_SIZE,
-			.cra_ctxsize		= CRYPTO_AES_CTX_SIZE,
-			.cra_module		= THIS_MODULE,
-		},
-		.min_keysize	= AES_MIN_KEY_SIZE,
-		.max_keysize	= AES_MAX_KEY_SIZE,
-		.ivsize		= AES_BLOCK_SIZE,
-		.setkey		= aesni_skcipher_setkey,
-		.encrypt	= cbc_encrypt,
-		.decrypt	= cbc_decrypt,
-	}, {
-		.base = {
-			.cra_name		= "cts(cbc(aes))",
-			.cra_driver_name	= "cts-cbc-aes-aesni",
-			.cra_priority		= 400,
-			.cra_blocksize		= AES_BLOCK_SIZE,
-			.cra_ctxsize		= CRYPTO_AES_CTX_SIZE,
-			.cra_module		= THIS_MODULE,
-		},
-		.min_keysize	= AES_MIN_KEY_SIZE,
-		.max_keysize	= AES_MAX_KEY_SIZE,
-		.ivsize		= AES_BLOCK_SIZE,
-		.walksize	= 2 * AES_BLOCK_SIZE,
-		.setkey		= aesni_skcipher_setkey,
-		.encrypt	= cts_cbc_encrypt,
-		.decrypt	= cts_cbc_decrypt,
 #ifdef CONFIG_X86_64
-	}, {
+	{
 		.base = {
 			.cra_name		= "ctr(aes)",
 			.cra_driver_name	= "ctr-aes-aesni",
@@ -512,8 +317,9 @@ static struct skcipher_alg aesni_skciphers[] = {
 		.setkey		= aesni_skcipher_setkey,
 		.encrypt	= ctr_crypt_aesni,
 		.decrypt	= ctr_crypt_aesni,
+	},
 #endif
-	}, {
+	{
 		.base = {
 			.cra_name		= "xts(aes)",
 			.cra_driver_name	= "xts-aes-aesni",
-- 
2.55.0

