Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793840181;
	b=YMpIyflQofneseH1eP6pr17y7tJBx9MN7y6ExLiZgjxI1xPrQefmRj0lWsQdEgd+wW6k
	 EMPcLXNmLztJbobfMvVwFfRK20ilwpGm2+bzM6GdjcE9iTMX/R+M48s6i4tCow9qPwhhP
	 AR3sX18ccnAZckiYQjjMbQIo/fKP/ywUqbRcq0TQ1L04E/vu0RNCEC/6MyJBH+2z/FdTf
	 dxccGcvgZl18Kc4OGyOBX9Z/JVf1OexYEyKzkRxaIj0ALNsHPoYfcC4CBB9DRB8R38jpn
	 2JYnYCXPwe/Ooxvo+ohFawd/fko1Nf8qfNE6BMhxU5u+lwzNJVHW/ZeEtPjrj+YPtMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793840181;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=bW9Y/zHyUVjeX+w7bt0c4GRvVcqBbUI3Gf+3V3zBKYk=;
	b=L2eGTfINXySWJ8RHNVYm16347xFqhRGfe0Slzt15LespjXXRdoQ2iWUTukB+yWYLGHIA
	 w/nY6QPnFzeoyfl/bnsIf+8NDRwAAhzlHUHGaueV5oTKd6O35ZoYu/egYBaFFJ76HDOBC
	 n0XLZPfGrl0Yi8hpWIq4G1lEIw3AoOcQ12p8xwrMzXOuloADyIDGoa2niWm6CsYLRAtDT
	 J7dE0ik+z3L7JwQiN0taZW08SS+ZV71+M2Ude74r7ZsWuIdCDSQcYE5hHjYPJRNiIBRcJ
	 6EpGGo1iZjVUcjiwXnB8WnXQOlacBgGv4136uDVPn/cCn71fHheG2TH9ID/GblPBNqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PW6zzK8M;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 535E6606D814
	for <linux-crypto@vger.kernel.org>; Thu,  5 Nov 2026 00:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PW6zzK8M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C71BB1F00919;
	Thu,  5 Nov 2026 00:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793840181;
	bh=bW9Y/zHyUVjeX+w7bt0c4GRvVcqBbUI3Gf+3V3zBKYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PW6zzK8MNItbeKgPXwP9WlqcoAnEhmJB0XWVfI16eISTeSoD4ubJrkCtCol3K0qK5
	 qULzwEQUrrpr5mzS2uocFoIml8zWYzpNVIgE6OfO1CJmcu2Z3bhorAEXzXOGkwhuIb
	 b+plxsnUxUjoKAEBnf89EOBgxvn0WJgGoupklG2ki70gw5X1L98Z9u/0rfrwEv5hGa
	 33ko29kcEZP0Ohl1vz1Bmi9s/A2lkdK7llZ4CKYuVNck9st2aSx5Olvg0Anqyh7UEd
	 azNnQvZJExRuYpa3xBf9K1s72ddcMx8C9iWLR/klIkkdzjhWTr6VksvMhV1/WT0l3d
	 jBhU/UbMdhe3w==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 2/3] lib/crypto: x86: Opt out of initializing MXCSR and 387 state
Date: Wed,  4 Nov 2026 16:55:22 -0800
Message-ID: <20261105005523.84925-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261105005523.84925-1-ebiggers@kernel.org>
References: <20261105005523.84925-1-ebiggers@kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The crypto code using "kernel-mode FPU" is integer code that does not
use any MMX or x87 instructions.  To the extent that float-domain
instructions are used at all, they are only moves and shuffles, neither
of which raises SIMD floating-point exceptions or depends on MXCSR.

Therefore, there's no need to initialize MXCSR or the 387 FPU state.

Opt out of this initialization by using kernel_fpu_begin_mask(0) instead
of kernel_fpu_begin().  This eliminates an 'ldmxcsr' instruction in
every kernel-mode FPU section, reducing overhead, which matters most for
short input lengths.  On 32-bit kernels it also eliminates 'fninit'.

A precedent for this optimization can be found in
commit a58db7ad80e8 ("netfilter: nft_set_pipapo_avx2: Skip LDMXCSR, we
don't need a valid MXCSR state").

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/x86/aes.h       | 24 ++++++++++++------------
 lib/crypto/x86/blake2s.h   |  2 +-
 lib/crypto/x86/chacha.h    |  4 ++--
 lib/crypto/x86/gf128hash.h |  8 ++++----
 lib/crypto/x86/nh.h        |  2 +-
 lib/crypto/x86/poly1305.h  |  2 +-
 lib/crypto/x86/sha1.h      |  4 ++--
 lib/crypto/x86/sha256.h    |  4 ++--
 lib/crypto/x86/sha512.h    |  2 +-
 lib/crypto/x86/sm3.h       |  2 +-
 10 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/lib/crypto/x86/aes.h b/lib/crypto/x86/aes.h
index b555290ab075..01af1a522b42 100644
--- a/lib/crypto/x86/aes.h
+++ b/lib/crypto/x86/aes.h
@@ -50,7 +50,7 @@ static void aes_preparekey_arch(union aes_enckey_arch *k,
 
 	if (static_branch_likely(&have_aesni) && key_len != AES_KEYSIZE_192 &&
 	    irq_fpu_usable()) {
-		kernel_fpu_begin();
+		kernel_fpu_begin_mask(0);
 		if (key_len == AES_KEYSIZE_128)
 			aes128_expandkey_aesni(rndkeys, inv_rndkeys, in_key);
 		else
@@ -66,7 +66,7 @@ static void aes_encrypt_arch(const struct aes_enckey *key,
 			     const u8 in[AES_BLOCK_SIZE])
 {
 	if (static_branch_likely(&have_aesni) && irq_fpu_usable()) {
-		kernel_fpu_begin();
+		kernel_fpu_begin_mask(0);
 		aes_encrypt_aesni(out, in, key);
 		kernel_fpu_end();
 	} else {
@@ -79,7 +79,7 @@ static void aes_decrypt_arch(const struct aes_key *key,
 			     const u8 in[AES_BLOCK_SIZE])
 {
 	if (static_branch_likely(&have_aesni) && irq_fpu_usable()) {
-		kernel_fpu_begin();
+		kernel_fpu_begin_mask(0);
 		aes_decrypt_aesni(out, in, key);
 		kernel_fpu_end();
 	} else {
@@ -101,7 +101,7 @@ static bool aes_ecb_encrypt_arch(u8 *dst, const u8 *src, size_t len,
 {
 	if (!static_branch_likely(&have_aesni) || unlikely(!irq_fpu_usable()))
 		return false;
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(0);
 	aes_ecb_encrypt_aesni(dst, src, len / AES_BLOCK_SIZE, key);
 	kernel_fpu_end();
 	return true;
@@ -114,7 +114,7 @@ static bool aes_ecb_decrypt_arch(u8 *dst, const u8 *src, size_t len,
 {
 	if (!static_branch_likely(&have_aesni) || unlikely(!irq_fpu_usable()))
 		return false;
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(0);
 	aes_ecb_decrypt_aesni(dst, src, len / AES_BLOCK_SIZE, key);
 	kernel_fpu_end();
 	return true;
@@ -141,7 +141,7 @@ static bool aes_cbc_encrypt_arch(u8 *dst, const u8 *src, size_t len,
 {
 	if (!static_branch_likely(&have_aesni) || unlikely(!irq_fpu_usable()))
 		return false;
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(0);
 	aes_cbc_encrypt_aesni(dst, src, len / AES_BLOCK_SIZE, iv, key);
 	kernel_fpu_end();
 	return true;
@@ -155,7 +155,7 @@ static bool aes_cbc_decrypt_arch(u8 *dst, const u8 *src, size_t len,
 {
 	if (!static_branch_likely(&have_aesni) || unlikely(!irq_fpu_usable()))
 		return false;
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(0);
 	aes_cbc_decrypt_aesni(dst, src, len / AES_BLOCK_SIZE, iv, key);
 	kernel_fpu_end();
 	return true;
@@ -173,7 +173,7 @@ static bool aes_cbc_cts_encrypt_arch(u8 *dst, const u8 *src, size_t len,
 	if (!static_branch_likely(&have_aesni) || unlikely(!irq_fpu_usable()))
 		return false;
 
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(0);
 	if (cbc_blocks) {
 		aes_cbc_encrypt_aesni(dst, src, cbc_blocks, iv, key);
 		dst += cbc_blocks * AES_BLOCK_SIZE;
@@ -197,7 +197,7 @@ static bool aes_cbc_cts_decrypt_arch(u8 *dst, const u8 *src, size_t len,
 	if (!static_branch_likely(&have_aesni) || unlikely(!irq_fpu_usable()))
 		return false;
 
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(0);
 	if (cbc_blocks) {
 		aes_cbc_decrypt_aesni(dst, src, cbc_blocks, iv, key);
 		dst += cbc_blocks * AES_BLOCK_SIZE;
@@ -260,7 +260,7 @@ static bool aes_ctr_arch(u8 *dst, const u8 *src, size_t len,
 	ctr64 = le_ctr[0] = get_unaligned_be64(&ctr[8]);
 	le_ctr[1] = get_unaligned_be64(&ctr[0]);
 
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(0);
 
 	nblocks = DIV_ROUND_UP(len, AES_BLOCK_SIZE);
 	ctr64 += nblocks;
@@ -296,7 +296,7 @@ static bool aes_xctr_arch(u8 *dst, const u8 *src, size_t len, u64 ctr,
 	if (!static_branch_likely(&have_aesni_avx) ||
 	    unlikely(!irq_fpu_usable()))
 		return false;
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(0);
 	if (static_branch_likely(&have_vaes_avx512))
 		aes_xctr_crypt_vaes_avx512(dst, src, len, ctr, iv, key);
 	else if (static_branch_likely(&have_vaes_avx2))
@@ -344,7 +344,7 @@ aes_xts_crypt_x86(u8 *dst, const u8 *src, size_t len, u8 tweak[AES_BLOCK_SIZE],
 	if (!static_branch_likely(&have_aesni) || unlikely(!irq_fpu_usable()))
 		return false;
 
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(0);
 	if (IS_ENABLED(CONFIG_X86_64) &&
 	    static_branch_likely(&have_vaes_avx512)) {
 		if (!cont)
diff --git a/lib/crypto/x86/blake2s.h b/lib/crypto/x86/blake2s.h
index 0f7c51f055c8..952db559eed3 100644
--- a/lib/crypto/x86/blake2s.h
+++ b/lib/crypto/x86/blake2s.h
@@ -34,7 +34,7 @@ static void blake2s_compress(struct blake2s_ctx *ctx,
 		const size_t blocks = min_t(size_t, nblocks,
 					    SZ_4K / BLAKE2S_BLOCK_SIZE);
 
-		kernel_fpu_begin();
+		kernel_fpu_begin_mask(0);
 		if (static_branch_likely(&blake2s_use_avx512))
 			blake2s_compress_avx512(ctx, data, blocks, inc);
 		else
diff --git a/lib/crypto/x86/chacha.h b/lib/crypto/x86/chacha.h
index fdf01b07742e..3bbfd21255de 100644
--- a/lib/crypto/x86/chacha.h
+++ b/lib/crypto/x86/chacha.h
@@ -152,7 +152,7 @@ static void hchacha_block_arch(const struct chacha_state *state,
 	if (!static_branch_likely(&chacha_use_simd)) {
 		hchacha_block_generic(state, out, nrounds);
 	} else {
-		kernel_fpu_begin();
+		kernel_fpu_begin_mask(0);
 		hchacha_block_ssse3(state, out, nrounds);
 		kernel_fpu_end();
 	}
@@ -168,7 +168,7 @@ static void chacha_crypt_arch(struct chacha_state *state, u8 *dst,
 	do {
 		size_t todo = min(bytes, SZ_4K);
 
-		kernel_fpu_begin();
+		kernel_fpu_begin_mask(0);
 		chacha_dosimd(state, dst, src, todo, nrounds);
 		kernel_fpu_end();
 
diff --git a/lib/crypto/x86/gf128hash.h b/lib/crypto/x86/gf128hash.h
index 6b79b06caab0..5ef8f2f7b6f3 100644
--- a/lib/crypto/x86/gf128hash.h
+++ b/lib/crypto/x86/gf128hash.h
@@ -31,7 +31,7 @@ static void polyval_preparekey_arch(struct polyval_key *key,
 	static_assert(ARRAY_SIZE(key->h_powers) == NUM_H_POWERS);
 	memcpy(&key->h_powers[NUM_H_POWERS - 1], raw_key, POLYVAL_BLOCK_SIZE);
 	if (static_branch_likely(&have_pclmul_avx) && irq_fpu_usable()) {
-		kernel_fpu_begin();
+		kernel_fpu_begin_mask(0);
 		for (int i = NUM_H_POWERS - 2; i >= 0; i--) {
 			key->h_powers[i] = key->h_powers[i + 1];
 			polyval_mul_pclmul_avx(
@@ -52,7 +52,7 @@ static void polyval_mul_x86(struct polyval_elem *a,
 			    const struct polyval_elem *b)
 {
 	if (static_branch_likely(&have_pclmul) && irq_fpu_usable()) {
-		kernel_fpu_begin();
+		kernel_fpu_begin_mask(0);
 		if (static_branch_likely(&have_pclmul_avx))
 			polyval_mul_pclmul_avx(a, b);
 		else
@@ -88,7 +88,7 @@ static void ghash_blocks_arch(struct polyval_elem *acc,
 			size_t n = min_t(size_t, nblocks,
 					 4096 / GHASH_BLOCK_SIZE);
 
-			kernel_fpu_begin();
+			kernel_fpu_begin_mask(0);
 			ghash_blocks_pclmul(acc, &key->h, data, n);
 			kernel_fpu_end();
 			data += n * GHASH_BLOCK_SIZE;
@@ -110,7 +110,7 @@ static void polyval_blocks_arch(struct polyval_elem *acc,
 			size_t n = min_t(size_t, nblocks,
 					 4096 / POLYVAL_BLOCK_SIZE);
 
-			kernel_fpu_begin();
+			kernel_fpu_begin_mask(0);
 			polyval_blocks_pclmul_avx(acc, key, data, n);
 			kernel_fpu_end();
 			data += n * POLYVAL_BLOCK_SIZE;
diff --git a/lib/crypto/x86/nh.h b/lib/crypto/x86/nh.h
index 342636dcb750..e41512e5b4bb 100644
--- a/lib/crypto/x86/nh.h
+++ b/lib/crypto/x86/nh.h
@@ -21,7 +21,7 @@ static bool nh_arch(const u32 *key, const u8 *message, size_t message_len,
 {
 	if (message_len >= 64 && static_branch_likely(&have_sse2) &&
 	    irq_fpu_usable()) {
-		kernel_fpu_begin();
+		kernel_fpu_begin_mask(0);
 		if (static_branch_likely(&have_avx2))
 			nh_avx2(key, message, message_len, hash);
 		else
diff --git a/lib/crypto/x86/poly1305.h b/lib/crypto/x86/poly1305.h
index a2034809b97b..3b92e20f4f9b 100644
--- a/lib/crypto/x86/poly1305.h
+++ b/lib/crypto/x86/poly1305.h
@@ -117,7 +117,7 @@ static void poly1305_blocks(struct poly1305_block_state *state, const u8 *inp,
 	do {
 		const size_t bytes = min(len, SZ_4K);
 
-		kernel_fpu_begin();
+		kernel_fpu_begin_mask(0);
 		if (static_branch_likely(&poly1305_use_avx512))
 			poly1305_blocks_avx512(ctx, inp, bytes, padbit);
 		else if (static_branch_likely(&poly1305_use_avx2))
diff --git a/lib/crypto/x86/sha1.h b/lib/crypto/x86/sha1.h
index 6aff433466e7..9de5f388055e 100644
--- a/lib/crypto/x86/sha1.h
+++ b/lib/crypto/x86/sha1.h
@@ -16,7 +16,7 @@ DEFINE_STATIC_CALL(sha1_blocks_x86, sha1_blocks_generic);
 			 const u8 *data, size_t nblocks)           \
 	{                                                          \
 		if (likely(irq_fpu_usable())) {                    \
-			kernel_fpu_begin();                        \
+			kernel_fpu_begin_mask(0);                  \
 			asm_fn(state, data, nblocks);              \
 			kernel_fpu_end();                          \
 		} else {                                           \
@@ -36,7 +36,7 @@ static void sha1_blocks_avx2(struct sha1_block_state *state,
 			     const u8 *data, size_t nblocks)
 {
 	if (likely(irq_fpu_usable())) {
-		kernel_fpu_begin();
+		kernel_fpu_begin_mask(0);
 		/* Select the optimal transform based on the number of blocks */
 		if (nblocks >= SHA1_AVX2_BLOCK_OPTSIZE)
 			sha1_transform_avx2(state, data, nblocks);
diff --git a/lib/crypto/x86/sha256.h b/lib/crypto/x86/sha256.h
index e98ffdaf4b14..72bce769aa92 100644
--- a/lib/crypto/x86/sha256.h
+++ b/lib/crypto/x86/sha256.h
@@ -18,7 +18,7 @@ DEFINE_STATIC_CALL(sha256_blocks_x86, sha256_blocks_generic);
 			 size_t nblocks)                                   \
 	{                                                                  \
 		if (likely(irq_fpu_usable())) {                            \
-			kernel_fpu_begin();                                \
+			kernel_fpu_begin_mask(0);                          \
 			asm_fn(state, data, nblocks);                      \
 			kernel_fpu_end();                                  \
 		} else {                                                   \
@@ -79,7 +79,7 @@ static bool sha256_finup_2x_arch(const struct __sha256_ctx *ctx,
 	 */
 	if (static_branch_likely(&have_sha_ni) && len >= SHA256_BLOCK_SIZE &&
 	    len <= 65536 && likely(irq_fpu_usable())) {
-		kernel_fpu_begin();
+		kernel_fpu_begin_mask(0);
 		sha256_ni_finup2x(ctx, data1, data2, len, out1, out2);
 		kernel_fpu_end();
 		kmsan_unpoison_memory(out1, SHA256_DIGEST_SIZE);
diff --git a/lib/crypto/x86/sha512.h b/lib/crypto/x86/sha512.h
index 4e177b4606bd..d16be7c03a41 100644
--- a/lib/crypto/x86/sha512.h
+++ b/lib/crypto/x86/sha512.h
@@ -16,7 +16,7 @@ DEFINE_STATIC_CALL(sha512_blocks_x86, sha512_blocks_generic);
 			 size_t nblocks)                                   \
 	{                                                                  \
 		if (likely(irq_fpu_usable())) {                            \
-			kernel_fpu_begin();                                \
+			kernel_fpu_begin_mask(0);                          \
 			asm_fn(state, data, nblocks);                      \
 			kernel_fpu_end();                                  \
 		} else {                                                   \
diff --git a/lib/crypto/x86/sm3.h b/lib/crypto/x86/sm3.h
index e06d4a22e4fa..493887838888 100644
--- a/lib/crypto/x86/sm3.h
+++ b/lib/crypto/x86/sm3.h
@@ -14,7 +14,7 @@ static void sm3_blocks_avx(struct sm3_block_state *state,
 			   const u8 *data, size_t nblocks)
 {
 	if (likely(irq_fpu_usable())) {
-		kernel_fpu_begin();
+		kernel_fpu_begin_mask(0);
 		sm3_transform_avx(state, data, nblocks);
 		kernel_fpu_end();
 	} else {
-- 
2.56.0

