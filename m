Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D46A3546D7;
	Mon, 21 Sep 2026 05:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789967767; cv=none; b=JfdlzPv/21ZjQ6z/Xprrk2dtuX40zkJqaJA0CB0Y8zm0llax9gqO3SbiqTPKqmHjBtjdta2JvKWzT+04+q8e33RatypQHSPD3JQ7deVdQCa5Zj4KohqXYk1h1UI2N9/vBxWAQJRwHmjsmqudg/vy8jLxTvlWJFjh5dsoIKFMgro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789967767; c=relaxed/simple;
	bh=zlkL4O2KlClb50FnJ5YALUCJCu2y++H0Wp/pk7st6Oo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bEGFa/7wl78pgAYqtAlcHMgz7p4oOtefTPzAw8afwO97t0JSmHw7Xo/vvBZD39MVSHe4/osxnTAlfALI0gPOqeCPQSfzNo94GXIsSehZwoTZ3n1yWAbwawsL53wcfcNFguxrue1KyPqiTFORgDokvYLVe7yoN6HrbsI5xviZlRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hRQANaMg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hRQANaMg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1A6E1F00893;
	Mon, 21 Sep 2026 05:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789967765;
	bh=lwSKS6W6HhL1Ql1jfyigEqHpJBGpQYQ2rJqm5NzIuGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hRQANaMgs17/6VSF0JU4mhvDouBHwJpPuIat0NoyyNtJhno0dv5U8+QUVYIeurOIo
	 uZpVEU8Z+JkWDZAA9LMWzUchYta29mlppSkgjjIMk9ibnDqbCAvOp4XDQZEY9hv0zx
	 zvOlojmxBE7PB4fUc0RrCcOaUjdX2cfpY1UB5tS81yCv26ylNp5BvlxMueHdLG7kjQ
	 CF933MMbv7U4nBIhbLyUumJL8V1AgORpBwoY++X9gofyZdsuzlru2cqD9If805e5c7
	 31fBSeABXpPJOX2HhtcvaUqS3jNmmfrlw7jnfa2IZGK6y4XAXQFutwXG+EEkiHSveU
	 MsRM6mshCk1Gw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org,
	linux-riscv@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 05/20] lib/crypto: x86/aes-cbc: Add AES-NI optimization
Date: Sun, 20 Sep 2026 22:08:51 -0700
Message-ID: <20260921050910.296144-6-ebiggers@kernel.org>
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

Optimize the crypto library's AES-CBC and AES-CBC-CTS support with
AES-NI, making their performance be at least at parity with the
"cbc-aes-aesni" and "cts-cbc-aes-aesni" skcipher algorithms that they
will supersede.

The new assembly functions are written from scratch to fit well into the
crypto library.  However, they are functionally very similar to the
functions in arch/x86/crypto/aesni-intel_asm.S that they will supersede
and are intended to provide parity with those -- including supporting
32-bit mode, having the inner loops do 4 AES blocks per iteration, etc.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/aes.c               |   4 +-
 lib/crypto/x86/aes-aesni.S | 246 +++++++++++++++++++++++++++++++++++++
 lib/crypto/x86/aes.h       |  89 ++++++++++++++
 3 files changed, 337 insertions(+), 2 deletions(-)

diff --git a/crypto/aes.c b/crypto/aes.c
index 5a97dc812e8b..cc2cd6b08eee 100644
--- a/crypto/aes.c
+++ b/crypto/aes.c
@@ -625,7 +625,7 @@ static struct skcipher_alg skcipher_algs[] = {
 	{
 		.base.cra_name = "cbc(aes)",
 		.base.cra_driver_name = "cbc-aes-lib",
-		.base.cra_priority = 110,
+		.base.cra_priority = IS_ENABLED(CONFIG_X86) ? 300 : 110,
 		.base.cra_blocksize = AES_BLOCK_SIZE,
 		.base.cra_ctxsize = sizeof(struct aes_key),
 		.base.cra_module = THIS_MODULE,
@@ -651,7 +651,7 @@ static struct skcipher_alg skcipher_algs[] = {
 	{
 		.base.cra_name = "cts(cbc(aes))",
 		.base.cra_driver_name = "cts-cbc-aes-lib",
-		.base.cra_priority = 110,
+		.base.cra_priority = IS_ENABLED(CONFIG_X86) ? 300 : 110,
 		.base.cra_blocksize = AES_BLOCK_SIZE,
 		.base.cra_ctxsize = sizeof(struct aes_key),
 		.base.cra_module = THIS_MODULE,
diff --git a/lib/crypto/x86/aes-aesni.S b/lib/crypto/x86/aes-aesni.S
index fdb2917deb59..17da4d710574 100644
--- a/lib/crypto/x86/aes-aesni.S
+++ b/lib/crypto/x86/aes-aesni.S
@@ -58,6 +58,14 @@
 	// The AES round constants, used during key expansion
 	.long	0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80, 0x1b, 0x36
 
+.Lcts_permute_table:
+	.byte	0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80
+	.byte	0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80
+	.byte	0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07
+	.byte	0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f
+	.byte	0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80
+	.byte	0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80
+
 .text
 
 // In 32-bit mode, push certain callee-saved GPRs and optionally load function
@@ -402,3 +410,241 @@ SYM_FUNC_END(aes_ecb_encrypt_aesni)
 SYM_FUNC_START(aes_ecb_decrypt_aesni)
 	_ecb_crypt	0
 SYM_FUNC_END(aes_ecb_decrypt_aesni)
+
+// void aes_cbc_encrypt_aesni(u8 *dst, const u8 *src, long nblocks,
+//			      u8 iv[AES_BLOCK_SIZE],
+//			      const struct aes_enckey *key);
+SYM_FUNC_START(aes_cbc_encrypt_aesni)
+	// Arguments
+	.set	DST,		ARG0
+	.set	SRC,		ARG1
+	.set	NBLOCKS,	ARG2
+	.set	IV_PTR,		ARG3
+	.set	KEY,		ARG4
+
+	// Other local variables
+#ifdef __x86_64__
+	.set	RNDKEY_PTR,	%r9
+#else
+	.set	RNDKEY_PTR,	IV_PTR // IV_PTR is clobbered and reloaded later
+#endif
+	.set	NROUNDS,	TMP_32
+	.set	AESDATA0,	%xmm0
+	.set	PTEXT,		%xmm1
+	_prologue	uses_arg3=2, uses_arg4=2
+
+	movdqu		(IV_PTR), AESDATA0
+.p2align 5
+.Lcbc_enc_loop:
+	movdqu		(SRC), PTEXT
+	pxor		PTEXT, AESDATA0
+	_do_aes		1, 0
+	movdqu		AESDATA0, (DST)
+	add		$16, DST
+	add		$16, SRC
+	dec		NBLOCKS
+	jnz		.Lcbc_enc_loop
+
+	// Store the next IV.  On 32-bit, reload IV_PTR from stack first.
+	_reload_arg3
+	movdqu		AESDATA0, (IV_PTR)
+	_epilogue
+SYM_FUNC_END(aes_cbc_encrypt_aesni)
+
+// void aes_cbc_decrypt_aesni(u8 *dst, const u8 *src, long nblocks,
+//			      u8 iv[AES_BLOCK_SIZE],
+//			      const struct aes_key *key);
+SYM_FUNC_START(aes_cbc_decrypt_aesni)
+	// Arguments
+	.set	DST,		ARG0
+	.set	SRC,		ARG1
+	.set	NBLOCKS,	ARG2
+	.set	NBLOCKS32,	ARG2_32	// Used for improved code density
+	.set	IV_PTR,		ARG3
+	.set	KEY,		ARG4
+
+	// Other local variables
+#ifdef __x86_64__
+	.set	RNDKEY_PTR,	%r9
+#else
+	.set	RNDKEY_PTR,	IV_PTR // IV_PTR is clobbered and reloaded later
+#endif
+	.set	NROUNDS, TMP_32
+	.set	AESDATA0,	%xmm0
+	.set	AESDATA1,	%xmm1
+	.set	AESDATA2,	%xmm2
+	.set	AESDATA3,	%xmm3
+	.set	RNDKEY,		%xmm4
+	.set	IV,		%xmm5
+	.set	CTEXT0,		%xmm6
+	.set	CTEXT1,		%xmm7
+#ifdef __x86_64__
+	.set	CTEXT2,		%xmm8
+	.set	CTEXT3,		%xmm9
+#endif
+	_prologue	uses_arg3=2, uses_arg4=2
+
+	movdqu		(IV_PTR), IV
+
+	sub		$4, NBLOCKS
+	jl		.Lcbc_dec_loop4_done
+
+.p2align 5
+.Lcbc_dec_loop4:
+	movdqu		0(SRC), AESDATA0
+	movdqu		16(SRC), AESDATA1
+	movdqu		32(SRC), AESDATA2
+	movdqu		48(SRC), AESDATA3
+	movdqa		AESDATA0, CTEXT0
+	movdqa		AESDATA1, CTEXT1
+#ifdef __x86_64__
+	movdqa		AESDATA2, CTEXT2
+	movdqa		AESDATA3, CTEXT3
+#endif
+	_do_aes		0, 0,1,2,3
+	pxor		IV, AESDATA0
+	pxor		CTEXT0, AESDATA1
+	pxor		CTEXT1, AESDATA2
+#ifdef __x86_64__
+	pxor		CTEXT2, AESDATA3
+	movdqa		CTEXT3, IV
+#else
+	movdqu		32(SRC), CTEXT0
+	pxor		CTEXT0, AESDATA3
+	movdqu		48(SRC), IV
+#endif
+	movdqu		AESDATA0, 0(DST)
+	movdqu		AESDATA1, 16(DST)
+	movdqu		AESDATA2, 32(DST)
+	movdqu		AESDATA3, 48(DST)
+	add		$64, DST
+	add		$64, SRC
+	sub		$4, NBLOCKS
+	jge		.Lcbc_dec_loop4
+.Lcbc_dec_loop4_done:
+	add		$4, NBLOCKS32
+	jz		.Lcbc_dec_done
+
+.Lcbc_dec_loop1:
+	movdqu		(SRC), AESDATA0
+	movdqa		AESDATA0, CTEXT0
+	_do_aes		0, 0
+	pxor		IV, AESDATA0
+	movdqa		CTEXT0, IV
+	movdqu		AESDATA0, (DST)
+	add		$16, DST
+	add		$16, SRC
+	dec		NBLOCKS32
+	jnz		.Lcbc_dec_loop1
+
+.Lcbc_dec_done:
+	// Store the next IV.  On 32-bit, reload IV_PTR from stack first.
+	_reload_arg3
+	movdqu		IV, (IV_PTR)
+	_epilogue
+SYM_FUNC_END(aes_cbc_decrypt_aesni)
+
+// void aes_cbc_cts_encrypt_aesni(u8 *dst, const u8 *src, long pn_len,
+//				  const u8 iv[AES_BLOCK_SIZE],
+//				  const struct aes_enckey *key);
+//
+// Encrypt the last two blocks using the CS3 variant of ciphertext stealing.
+// 1 <= pn_len <= 16 gives the length of the last plaintext block (i.e. P_n) in
+// bytes, so in total this processes 17 to 32 bytes inclusive.
+SYM_FUNC_START(aes_cbc_cts_encrypt_aesni)
+	.set	DST,		ARG0
+	.set	SRC,		ARG1
+	.set	PN_LEN,		ARG2
+	.set	IV_PTR,		ARG3
+	.set	KEY,		ARG4
+	.set	RNDKEY_PTR,	IV_PTR	// Temporary register for _do_aes
+	.set	NROUNDS,	TMP_32	// Temporary register for _do_aes
+	.set	AESDATA0,	%xmm0
+	.set	AESDATA1,	%xmm1
+	.set	RNDKEY,		%xmm2
+	.set	LSHIFT_MASK,	%xmm3 // [0x80, 0x80, ...] + range(PN_LEN)
+	.set	RSHIFT_MASK,	%xmm4 // range(16-PN_LEN,16) + [0x80, 0x80, ...]
+	.set	IV,		%xmm5
+
+	_prologue	uses_arg3=2, uses_arg4=2
+
+	lea		RODATA(.Lcts_permute_table), TMP
+	movdqu		(TMP,PN_LEN), LSHIFT_MASK
+	sub		PN_LEN, TMP
+	movdqu		32(TMP), RSHIFT_MASK
+
+	// Load the last two plaintext blocks.  Last one is left-aligned.
+	movdqu		(SRC), AESDATA0
+	movdqu		(SRC,PN_LEN), AESDATA1
+
+	// Encrypt the second-from-last block.
+	movdqu		(IV_PTR), IV
+	pxor		IV, AESDATA0
+	_do_aes		1, 0
+
+	// Right-align the last block, then encrypt it.
+	pshufb		RSHIFT_MASK, AESDATA1
+	pxor		AESDATA0, AESDATA1
+	_do_aes		1, 1
+
+	// Store the last two ciphertext blocks.
+	pshufb		LSHIFT_MASK, AESDATA0
+	movdqu		AESDATA0, (DST,PN_LEN)
+	movdqu		AESDATA1, (DST)
+
+	_epilogue
+SYM_FUNC_END(aes_cbc_cts_encrypt_aesni)
+
+// void aes_cbc_cts_decrypt_aesni(u8 *dst, const u8 *src, long pn_len,
+//				  const u8 iv[AES_BLOCK_SIZE],
+//				  const struct aes_key *key);
+//
+// Decrypt the last two blocks using the CS3 variant of ciphertext stealing.
+// 1 <= pn_len <= 16 gives the length of the last plaintext block (i.e. P_n) in
+// bytes, so in total this processes 17 to 32 bytes inclusive.
+SYM_FUNC_START(aes_cbc_cts_decrypt_aesni)
+	.set	DST,		ARG0
+	.set	SRC,		ARG1
+	.set	PN_LEN,		ARG2
+	.set	IV_PTR,		ARG3
+	.set	KEY,		ARG4
+	.set	RNDKEY_PTR,	IV_PTR	// Temporary register for _do_aes
+	.set	NROUNDS,	TMP_32	// Temporary register for _do_aes
+	.set	RSHIFT_MASK,	%xmm0 // range(16-PN_LEN,16) + [0x80, 0x80, ...]
+	.set	LSHIFT_MASK,	%xmm1 // [0x80, 0x80, ...] + range(PN_LEN)
+	.set	AESDATA0,	%xmm2
+	.set	AESDATA1,	%xmm3
+	.set	RNDKEY,		%xmm4
+	.set	IV,		%xmm5
+
+	_prologue	uses_arg3=2, uses_arg4=2
+
+	lea		RODATA(.Lcts_permute_table), TMP
+	movdqu		(TMP,PN_LEN), LSHIFT_MASK
+	sub		PN_LEN, TMP
+	movdqu		32(TMP), RSHIFT_MASK
+	movdqu		(IV_PTR), IV
+
+	// Load the last two ciphertext blocks.  Last one is left-aligned.
+	movdqu		(SRC), AESDATA0
+	movdqu		(SRC,PN_LEN), AESDATA1
+
+	// Decrypt the second-from-last ciphertext block.
+	_do_aes		0, 0
+
+	// Recover and store the last plaintext block, left-aligned.
+	movdqa		AESDATA0, %xmm6
+	pshufb		LSHIFT_MASK, %xmm6
+	pxor		AESDATA1, %xmm6
+	movdqu		%xmm6, (DST,PN_LEN)
+
+	// Recover and store the second-from-last plaintext block.
+	// Note that pblendvb uses %xmm0 (RSHIFT_MASK) as an implicit operand.
+	pshufb		RSHIFT_MASK, AESDATA1
+	pblendvb	AESDATA0, AESDATA1
+	_do_aes		0, 1
+	pxor		IV, AESDATA1
+	movdqu		AESDATA1, (DST)
+
+	_epilogue
+SYM_FUNC_END(aes_cbc_cts_decrypt_aesni)
diff --git a/lib/crypto/x86/aes.h b/lib/crypto/x86/aes.h
index 9ad4a84f0378..67a4178b7acd 100644
--- a/lib/crypto/x86/aes.h
+++ b/lib/crypto/x86/aes.h
@@ -114,6 +114,95 @@ static bool aes_ecb_decrypt_arch(u8 *dst, const u8 *src, size_t len,
 }
 #endif /* CONFIG_CRYPTO_LIB_AES_ECB */
 
+#if IS_ENABLED(CONFIG_CRYPTO_LIB_AES_CBC)
+void aes_cbc_encrypt_aesni(u8 *dst, const u8 *src, long nblocks,
+			   u8 iv[AES_BLOCK_SIZE], const struct aes_enckey *key);
+void aes_cbc_decrypt_aesni(u8 *dst, const u8 *src, long nblocks,
+			   u8 iv[AES_BLOCK_SIZE], const struct aes_key *key);
+void aes_cbc_cts_encrypt_aesni(u8 *dst, const u8 *src, long pn_len,
+			       const u8 iv[AES_BLOCK_SIZE],
+			       const struct aes_enckey *key);
+void aes_cbc_cts_decrypt_aesni(u8 *dst, const u8 *src, long pn_len,
+			       const u8 iv[AES_BLOCK_SIZE],
+			       const struct aes_key *key);
+
+/* len is always a positive multiple of AES_BLOCK_SIZE here. */
+#define aes_cbc_encrypt_arch aes_cbc_encrypt_arch
+static bool aes_cbc_encrypt_arch(u8 *dst, const u8 *src, size_t len,
+				 u8 iv[AES_BLOCK_SIZE],
+				 const struct aes_enckey *key)
+{
+	if (!static_branch_likely(&have_aesni) || unlikely(!irq_fpu_usable()))
+		return false;
+	kernel_fpu_begin();
+	aes_cbc_encrypt_aesni(dst, src, len / AES_BLOCK_SIZE, iv, key);
+	kernel_fpu_end();
+	return true;
+}
+
+/* len is always a positive multiple of AES_BLOCK_SIZE here. */
+#define aes_cbc_decrypt_arch aes_cbc_decrypt_arch
+static bool aes_cbc_decrypt_arch(u8 *dst, const u8 *src, size_t len,
+				 u8 iv[AES_BLOCK_SIZE],
+				 const struct aes_key *key)
+{
+	if (!static_branch_likely(&have_aesni) || unlikely(!irq_fpu_usable()))
+		return false;
+	kernel_fpu_begin();
+	aes_cbc_decrypt_aesni(dst, src, len / AES_BLOCK_SIZE, iv, key);
+	kernel_fpu_end();
+	return true;
+}
+
+/* len can be any value greater than AES_BLOCK_SIZE here. */
+#define aes_cbc_cts_encrypt_arch aes_cbc_cts_encrypt_arch
+static bool aes_cbc_cts_encrypt_arch(u8 *dst, const u8 *src, size_t len,
+				     u8 iv[AES_BLOCK_SIZE],
+				     const struct aes_enckey *key)
+{
+	const size_t cbc_blocks = (len - AES_BLOCK_SIZE - 1) / AES_BLOCK_SIZE;
+	const size_t pn_len = ((len - 1) % AES_BLOCK_SIZE) + 1;
+
+	if (!static_branch_likely(&have_aesni) || unlikely(!irq_fpu_usable()))
+		return false;
+
+	kernel_fpu_begin();
+	if (cbc_blocks) {
+		aes_cbc_encrypt_aesni(dst, src, cbc_blocks, iv, key);
+		dst += cbc_blocks * AES_BLOCK_SIZE;
+		src += cbc_blocks * AES_BLOCK_SIZE;
+	}
+	/* This part handles the final 17 to 32 bytes. */
+	aes_cbc_cts_encrypt_aesni(dst, src, pn_len, iv, key);
+	kernel_fpu_end();
+	return true;
+}
+
+/* len can be any value greater than AES_BLOCK_SIZE here. */
+#define aes_cbc_cts_decrypt_arch aes_cbc_cts_decrypt_arch
+static bool aes_cbc_cts_decrypt_arch(u8 *dst, const u8 *src, size_t len,
+				     u8 iv[AES_BLOCK_SIZE],
+				     const struct aes_key *key)
+{
+	const size_t cbc_blocks = (len - AES_BLOCK_SIZE - 1) / AES_BLOCK_SIZE;
+	const size_t pn_len = ((len - 1) % AES_BLOCK_SIZE) + 1;
+
+	if (!static_branch_likely(&have_aesni) || unlikely(!irq_fpu_usable()))
+		return false;
+
+	kernel_fpu_begin();
+	if (cbc_blocks) {
+		aes_cbc_decrypt_aesni(dst, src, cbc_blocks, iv, key);
+		dst += cbc_blocks * AES_BLOCK_SIZE;
+		src += cbc_blocks * AES_BLOCK_SIZE;
+	}
+	/* This part handles the final 17 to 32 bytes. */
+	aes_cbc_cts_decrypt_aesni(dst, src, pn_len, iv, key);
+	kernel_fpu_end();
+	return true;
+}
+#endif /* CONFIG_CRYPTO_LIB_AES_CBC */
+
 #define aes_mod_init_arch aes_mod_init_arch
 static void aes_mod_init_arch(void)
 {
-- 
2.55.0

