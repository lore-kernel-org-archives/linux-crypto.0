Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793840181;
	b=Qrsl0NGSYrGEv9VF3C611P8lh2PFNURSWCJ9HS6Ig95N9sN1SqLhiVsK4M4tWU8zbs9b
	 ztNFyUUwYVNSeOryB51mtp1bmCInwaBVx6aF9ZHWBj/juWrdxRC/2Zf13fyTOPT1W49T5
	 63wIDXXqKz88EDWE55h7BQQ6pcvsMA3LKb45N2oU1gtxcKP/aKX+G7oh5+B52mc1Mt3ZQ
	 ioRh5up4pk8klAjyPi6OFS7ULQ80P9cFrw3bV6RJ5drvmf8kLZByzeXM+CEZceVX4YTaU
	 r5kglSN0qRkmh+KUQYTGjQ6VxEX8aIsN1niZLkfQ7GMn9uCjd7V5j4INMHmBMmliFSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793840181;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=a7HqO70vIfLrmyRfsQppVgIXn+/RpSONQV4rOvrkfms=;
	b=MDvomsELByAqB/2oE0chOs8Z1CMI7El2iffmO2cHwdh/PBSAay479+f52KYniF2IaAYK
	 2Wl/cQum9XzCgkOElqu8DRM1Oj2zpXxBW/LrEfnQCjLg64hqoDWWtYsGoA1UNNf03tZqF
	 Zi1aXAXR7nZih+PQdAqJF+cYAvkAUEEJ30IBcj7BcjnRT2DsieerFOSuvAFKckOovRYWw
	 RUZ+SD9f4TUl9z+I0vu0Kl2SCcFCL65BrhBqXyj0hVb0w9onpbP2sIPkmk6cvxjN/kEdC
	 iUr6+4iBStCuniF9Tz+SUbMmvyvBE4iLJWu8V6kG05rPuFQu5ArSboXG1DLv2GnKtUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cZlfRbAs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF70606D818
	for <linux-crypto@vger.kernel.org>; Thu,  5 Nov 2026 00:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cZlfRbAs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2172E1F000C1;
	Thu,  5 Nov 2026 00:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793840181;
	bh=a7HqO70vIfLrmyRfsQppVgIXn+/RpSONQV4rOvrkfms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cZlfRbAsEn1gkCltB7OLJQaX/zPYtwpyBVX+Yi0egoXkPQMNM9BvrpDEDV6r0LFis
	 imdEaelji3Ez6sgH8M45ajX4Q8RL7uMIerDKVbJRyFBEl1Eu/VD6+MK9zwrXR9RGe8
	 O+XZI4RZzLTyGlrjGqMj40VtQI8huMukohdM08Wyv1uPPsJlWrVEJBboorxHpyjWyh
	 IAYBrJ4Y7KsS4oO9b49vz718AAqsY6wSA6OnTOuU3cwCzpq7EpV9O6xg9SR7aP7dgu
	 V9qvOBAQMMSeL8LbnkRI2g7ZyeUL2sKauvDVRiaHXumLmYrnSufhfet/cNOCtF8Gdl
	 mUAEIqer5dBcg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 3/3] crypto: x86 - Opt out of initializing MXCSR and 387 state
Date: Wed,  4 Nov 2026 16:55:23 -0800
Message-ID: <20261105005523.84925-4-ebiggers@kernel.org>
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
 arch/x86/crypto/aegis128-aesni-glue.c   |  6 +++---
 arch/x86/crypto/aesni-intel_glue.c      | 10 +++++-----
 arch/x86/crypto/aria_aesni_avx2_glue.c  |  4 ++--
 arch/x86/crypto/aria_aesni_avx_glue.c   |  2 +-
 arch/x86/crypto/aria_gfni_avx512_glue.c |  6 +++---
 arch/x86/crypto/ecb_cbc_helpers.h       |  2 +-
 arch/x86/crypto/sm4_aesni_avx_glue.c    |  6 +++---
 7 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/arch/x86/crypto/aegis128-aesni-glue.c b/arch/x86/crypto/aegis128-aesni-glue.c
index 09fc0b15b0e9..5aa0adf9b285 100644
--- a/arch/x86/crypto/aegis128-aesni-glue.c
+++ b/arch/x86/crypto/aegis128-aesni-glue.c
@@ -124,7 +124,7 @@ crypto_aegis128_aesni_process_crypt(struct aegis_state *state,
 		kernel_fpu_end();
 		err = skcipher_walk_done(walk,
 					 walk->nbytes % AEGIS128_BLOCK_SIZE);
-		kernel_fpu_begin();
+		kernel_fpu_begin_mask(0);
 	}
 
 	if (walk->nbytes) {
@@ -138,7 +138,7 @@ crypto_aegis128_aesni_process_crypt(struct aegis_state *state,
 						walk->nbytes);
 		kernel_fpu_end();
 		err = skcipher_walk_done(walk, 0);
-		kernel_fpu_begin();
+		kernel_fpu_begin_mask(0);
 	}
 	return err;
 }
@@ -191,7 +191,7 @@ crypto_aegis128_aesni_crypt(struct aead_request *req,
 	if (err)
 		return err;
 
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(0);
 
 	aegis128_aesni_init(&state, &ctx->key, req->iv);
 	crypto_aegis128_aesni_process_ad(&state, req->src, req->assoclen);
diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index d2fb53e23eda..3b58d77d2f5d 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -458,7 +458,7 @@ static int gcm_setkey(struct crypto_aead *tfm, const u8 *raw_key,
 		return err;
 
 	if (likely(crypto_simd_usable())) {
-		kernel_fpu_begin();
+		kernel_fpu_begin_mask(0);
 		aes_gcm_precompute(key, flags);
 		kernel_fpu_end();
 	} else {
@@ -527,7 +527,7 @@ static int gcm_setkey(struct crypto_aead *tfm, const u8 *raw_key,
 /*
  * Initialize @ghash_acc, then pass all @assoclen bytes of associated data
  * (a.k.a. additional authenticated data) from @sg_src through the GHASH update
- * assembly function.  kernel_fpu_begin() must have already been called.
+ * assembly function.  The caller must be in a kernel-mode FPU section.
  */
 static void gcm_process_assoc(const struct aes_gcm_key *key, u8 ghash_acc[16],
 			      struct scatterlist *sg_src, unsigned int assoclen,
@@ -578,7 +578,7 @@ static void gcm_process_assoc(const struct aes_gcm_key *key, u8 ghash_acc[16],
 		scatterwalk_done_src(&walk, orig_len_this_step);
 		if (need_resched()) {
 			kernel_fpu_end();
-			kernel_fpu_begin();
+			kernel_fpu_begin_mask(0);
 		}
 	}
 	if (unlikely(pos))
@@ -631,7 +631,7 @@ gcm_crypt(struct aead_request *req, int flags)
 	 * section and start a new one if there are multiple data segments or if
 	 * rescheduling is needed while processing the associated data.
 	 */
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(0);
 
 	/* Pass the associated data through GHASH. */
 	gcm_process_assoc(key, ghash_acc, req->src, assoclen, flags);
@@ -653,7 +653,7 @@ gcm_crypt(struct aead_request *req, int flags)
 		err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
 		if (err)
 			return err;
-		kernel_fpu_begin();
+		kernel_fpu_begin_mask(0);
 	}
 	/* Last segment: process all remaining data. */
 	aes_gcm_update(key, le_ctr, ghash_acc, walk.src.virt.addr,
diff --git a/arch/x86/crypto/aria_aesni_avx2_glue.c b/arch/x86/crypto/aria_aesni_avx2_glue.c
index 371be2fb6469..7eece77fde91 100644
--- a/arch/x86/crypto/aria_aesni_avx2_glue.c
+++ b/arch/x86/crypto/aria_aesni_avx2_glue.c
@@ -99,7 +99,7 @@ static int aria_avx2_ctr_encrypt(struct skcipher_request *req)
 		u8 *dst = walk.dst.virt.addr;
 
 		while (nbytes >= ARIA_AESNI_AVX2_PARALLEL_BLOCK_SIZE) {
-			kernel_fpu_begin();
+			kernel_fpu_begin_mask(0);
 			aria_ops.aria_ctr_crypt_32way(ctx, dst, src,
 						      &req_ctx->keystream[0],
 						      walk.iv);
@@ -110,7 +110,7 @@ static int aria_avx2_ctr_encrypt(struct skcipher_request *req)
 		}
 
 		while (nbytes >= ARIA_AESNI_PARALLEL_BLOCK_SIZE) {
-			kernel_fpu_begin();
+			kernel_fpu_begin_mask(0);
 			aria_ops.aria_ctr_crypt_16way(ctx, dst, src,
 						      &req_ctx->keystream[0],
 						      walk.iv);
diff --git a/arch/x86/crypto/aria_aesni_avx_glue.c b/arch/x86/crypto/aria_aesni_avx_glue.c
index d23fc91c0ebd..29f0aa96d8dc 100644
--- a/arch/x86/crypto/aria_aesni_avx_glue.c
+++ b/arch/x86/crypto/aria_aesni_avx_glue.c
@@ -97,7 +97,7 @@ static int aria_avx_ctr_encrypt(struct skcipher_request *req)
 		u8 *dst = walk.dst.virt.addr;
 
 		while (nbytes >= ARIA_AESNI_PARALLEL_BLOCK_SIZE) {
-			kernel_fpu_begin();
+			kernel_fpu_begin_mask(0);
 			aria_ops.aria_ctr_crypt_16way(ctx, dst, src,
 						      &req_ctx->keystream[0],
 						      walk.iv);
diff --git a/arch/x86/crypto/aria_gfni_avx512_glue.c b/arch/x86/crypto/aria_gfni_avx512_glue.c
index e05bbeb22d4a..d58a26cc2646 100644
--- a/arch/x86/crypto/aria_gfni_avx512_glue.c
+++ b/arch/x86/crypto/aria_gfni_avx512_glue.c
@@ -87,7 +87,7 @@ static int aria_avx512_ctr_encrypt(struct skcipher_request *req)
 		u8 *dst = walk.dst.virt.addr;
 
 		while (nbytes >= ARIA_GFNI_AVX512_PARALLEL_BLOCK_SIZE) {
-			kernel_fpu_begin();
+			kernel_fpu_begin_mask(0);
 			aria_ops.aria_ctr_crypt_64way(ctx, dst, src,
 						      &req_ctx->keystream[0],
 						      walk.iv);
@@ -98,7 +98,7 @@ static int aria_avx512_ctr_encrypt(struct skcipher_request *req)
 		}
 
 		while (nbytes >= ARIA_AESNI_AVX2_PARALLEL_BLOCK_SIZE) {
-			kernel_fpu_begin();
+			kernel_fpu_begin_mask(0);
 			aria_ops.aria_ctr_crypt_32way(ctx, dst, src,
 						      &req_ctx->keystream[0],
 						      walk.iv);
@@ -109,7 +109,7 @@ static int aria_avx512_ctr_encrypt(struct skcipher_request *req)
 		}
 
 		while (nbytes >= ARIA_AESNI_PARALLEL_BLOCK_SIZE) {
-			kernel_fpu_begin();
+			kernel_fpu_begin_mask(0);
 			aria_ops.aria_ctr_crypt_16way(ctx, dst, src,
 						      &req_ctx->keystream[0],
 						      walk.iv);
diff --git a/arch/x86/crypto/ecb_cbc_helpers.h b/arch/x86/crypto/ecb_cbc_helpers.h
index 11955bd01af1..ef0bb85a2ce0 100644
--- a/arch/x86/crypto/ecb_cbc_helpers.h
+++ b/arch/x86/crypto/ecb_cbc_helpers.h
@@ -24,7 +24,7 @@
 		const u8 *src = walk.src.virt.addr;			\
 		u8 *dst = walk.dst.virt.addr;				\
 		u8 __maybe_unused buf[(bsize)];				\
-		if (do_fpu) kernel_fpu_begin()
+		if (do_fpu) kernel_fpu_begin_mask(0)
 
 #define CBC_WALK_START(req, bsize, fpu_blocks)				\
 	ECB_WALK_START(req, bsize, fpu_blocks)
diff --git a/arch/x86/crypto/sm4_aesni_avx_glue.c b/arch/x86/crypto/sm4_aesni_avx_glue.c
index ed383da5ff46..1521587665e5 100644
--- a/arch/x86/crypto/sm4_aesni_avx_glue.c
+++ b/arch/x86/crypto/sm4_aesni_avx_glue.c
@@ -48,7 +48,7 @@ static int ecb_do_crypt(struct skcipher_request *req, const u32 *rkey)
 		const u8 *src = walk.src.virt.addr;
 		u8 *dst = walk.dst.virt.addr;
 
-		kernel_fpu_begin();
+		kernel_fpu_begin_mask(0);
 		while (nbytes >= SM4_CRYPT8_BLOCK_SIZE) {
 			sm4_aesni_avx_crypt8(rkey, dst, src, 8);
 			dst += SM4_CRYPT8_BLOCK_SIZE;
@@ -136,7 +136,7 @@ int sm4_avx_cbc_decrypt(struct skcipher_request *req,
 		const u8 *src = walk.src.virt.addr;
 		u8 *dst = walk.dst.virt.addr;
 
-		kernel_fpu_begin();
+		kernel_fpu_begin_mask(0);
 
 		while (nbytes >= bsize) {
 			func(ctx->rkey_dec, dst, src, walk.iv);
@@ -201,7 +201,7 @@ int sm4_avx_ctr_crypt(struct skcipher_request *req,
 		const u8 *src = walk.src.virt.addr;
 		u8 *dst = walk.dst.virt.addr;
 
-		kernel_fpu_begin();
+		kernel_fpu_begin_mask(0);
 
 		while (nbytes >= bsize) {
 			func(ctx->rkey_enc, dst, src, walk.iv);
-- 
2.56.0

