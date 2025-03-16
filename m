Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CBBC18B0F
	for <linux-crypto@vger.kernel.org>; Sun, 16 Mar 2025 04:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742101078; cv=none; b=E28/EQ2/fk5or359wSAMlMnV5sCgFMk8+f7ZGVpXToKnjZsn2Szcp952UuriUJhey/IEeb72vST4Sn/JWBGwCK8lqrqujUSy322rSngGImVmkivlUuZpRON16zCYlhxMzPMn4kVSuGhrVO2sgmWOI6BogvuymvSmVo4CatXoIQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742101078; c=relaxed/simple;
	bh=UvROAM2iPb0vpslXM9XkTzCNYRMHiSxC5hduygJwDFY=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=tFeR3D0J7VHUR71hB5aauAa7eKkKroMhn/l2tW9k8uMdo00YvV3uj9Os2U6liqYYALq9mbx/Ijd+MyoG9yvkfKJHWxYF+H24SPxDvKAXIkv5mKnqxZIkwCQqxY911GFzXrJCXx2uA61XaM6bM5dlueNKRtCNaIjhdm2gKnLkZLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r0VajtAg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r0VajtAg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A37E8C4CEDD
	for <linux-crypto@vger.kernel.org>; Sun, 16 Mar 2025 04:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742101077;
	bh=UvROAM2iPb0vpslXM9XkTzCNYRMHiSxC5hduygJwDFY=;
	h=From:To:Subject:Date:From;
	b=r0VajtAg2eOdrp7LmH8yq4S5Ypbaf3CMS/sH6MRI0oEXbBKwkTbO+EYRJOOXZBBGZ
	 CSPFjZIjqnNtSi7fuiNDNK9dHPuD5xVND55oLjMuAJ7MIYovNH8ZKot+tvpP1M+IIi
	 LbbA8oDG/nTCorSGaDDFIHAZOKgYQn01lCLtVrUBzLzTZgbF5KZTqx0dR8d+SOHm+H
	 bg7ARZkGuxVUbDLvcTzlQI7m3DIvKtNqAMOkIKTnWTzZa3fxLpnMspVc+sQKlPAE8S
	 5YdBDoR8XJEshMtBL5dAXUrv128YbC+KY/VkZ0vizQZ0BbvGw4N+OzmhYMazTg6980
	 gQ/+KbH3EvAhg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: lib/chacha - remove unused arch-specific init support
Date: Sat, 15 Mar 2025 21:57:47 -0700
Message-ID: <20250316045747.249992-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

All implementations of chacha_init_arch() just call
chacha_init_generic(), so it is pointless.  Just delete it, and replace
chacha_init() with what was previously chacha_init_generic().

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/arm/crypto/chacha-glue.c                    | 10 ++--------
 arch/arm64/crypto/chacha-neon-glue.c             | 10 ++--------
 arch/mips/crypto/chacha-glue.c                   | 10 ++--------
 arch/powerpc/crypto/chacha-p10-glue.c            | 10 ++--------
 arch/s390/crypto/chacha-glue.c                   |  8 +-------
 arch/x86/crypto/chacha_glue.c                    | 10 ++--------
 crypto/chacha_generic.c                          |  4 ++--
 include/crypto/chacha.h                          | 11 +----------
 tools/testing/crypto/chacha20-s390/test-cipher.c |  4 ++--
 9 files changed, 16 insertions(+), 61 deletions(-)

diff --git a/arch/arm/crypto/chacha-glue.c b/arch/arm/crypto/chacha-glue.c
index cdde8fd01f8f9..50e635512046e 100644
--- a/arch/arm/crypto/chacha-glue.c
+++ b/arch/arm/crypto/chacha-glue.c
@@ -74,16 +74,10 @@ void hchacha_block_arch(const u32 *state, u32 *stream, int nrounds)
 		kernel_neon_end();
 	}
 }
 EXPORT_SYMBOL(hchacha_block_arch);
 
-void chacha_init_arch(u32 *state, const u32 *key, const u8 *iv)
-{
-	chacha_init_generic(state, key, iv);
-}
-EXPORT_SYMBOL(chacha_init_arch);
-
 void chacha_crypt_arch(u32 *state, u8 *dst, const u8 *src, unsigned int bytes,
 		       int nrounds)
 {
 	if (!IS_ENABLED(CONFIG_KERNEL_MODE_NEON) || !neon_usable() ||
 	    bytes <= CHACHA_BLOCK_SIZE) {
@@ -114,11 +108,11 @@ static int chacha_stream_xor(struct skcipher_request *req,
 	u32 state[16];
 	int err;
 
 	err = skcipher_walk_virt(&walk, req, false);
 
-	chacha_init_generic(state, ctx->key, iv);
+	chacha_init(state, ctx->key, iv);
 
 	while (walk.nbytes > 0) {
 		unsigned int nbytes = walk.nbytes;
 
 		if (nbytes < walk.total)
@@ -164,11 +158,11 @@ static int do_xchacha(struct skcipher_request *req, bool neon)
 	struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct chacha_ctx subctx;
 	u32 state[16];
 	u8 real_iv[16];
 
-	chacha_init_generic(state, ctx->key, req->iv);
+	chacha_init(state, ctx->key, req->iv);
 
 	if (!IS_ENABLED(CONFIG_KERNEL_MODE_NEON) || !neon) {
 		hchacha_block_arm(state, subctx.key, ctx->nrounds);
 	} else {
 		kernel_neon_begin();
diff --git a/arch/arm64/crypto/chacha-neon-glue.c b/arch/arm64/crypto/chacha-neon-glue.c
index af2bbca38e70f..229876acfc581 100644
--- a/arch/arm64/crypto/chacha-neon-glue.c
+++ b/arch/arm64/crypto/chacha-neon-glue.c
@@ -72,16 +72,10 @@ void hchacha_block_arch(const u32 *state, u32 *stream, int nrounds)
 		kernel_neon_end();
 	}
 }
 EXPORT_SYMBOL(hchacha_block_arch);
 
-void chacha_init_arch(u32 *state, const u32 *key, const u8 *iv)
-{
-	chacha_init_generic(state, key, iv);
-}
-EXPORT_SYMBOL(chacha_init_arch);
-
 void chacha_crypt_arch(u32 *state, u8 *dst, const u8 *src, unsigned int bytes,
 		       int nrounds)
 {
 	if (!static_branch_likely(&have_neon) || bytes <= CHACHA_BLOCK_SIZE ||
 	    !crypto_simd_usable())
@@ -108,11 +102,11 @@ static int chacha_neon_stream_xor(struct skcipher_request *req,
 	u32 state[16];
 	int err;
 
 	err = skcipher_walk_virt(&walk, req, false);
 
-	chacha_init_generic(state, ctx->key, iv);
+	chacha_init(state, ctx->key, iv);
 
 	while (walk.nbytes > 0) {
 		unsigned int nbytes = walk.nbytes;
 
 		if (nbytes < walk.total)
@@ -149,11 +143,11 @@ static int xchacha_neon(struct skcipher_request *req)
 	struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct chacha_ctx subctx;
 	u32 state[16];
 	u8 real_iv[16];
 
-	chacha_init_generic(state, ctx->key, req->iv);
+	chacha_init(state, ctx->key, req->iv);
 	hchacha_block_arch(state, subctx.key, ctx->nrounds);
 	subctx.nrounds = ctx->nrounds;
 
 	memcpy(&real_iv[0], req->iv + 24, 8);
 	memcpy(&real_iv[8], req->iv + 16, 8);
diff --git a/arch/mips/crypto/chacha-glue.c b/arch/mips/crypto/chacha-glue.c
index d1fd23e6ef844..f6fc2e1079a19 100644
--- a/arch/mips/crypto/chacha-glue.c
+++ b/arch/mips/crypto/chacha-glue.c
@@ -18,26 +18,20 @@ asmlinkage void chacha_crypt_arch(u32 *state, u8 *dst, const u8 *src,
 EXPORT_SYMBOL(chacha_crypt_arch);
 
 asmlinkage void hchacha_block_arch(const u32 *state, u32 *stream, int nrounds);
 EXPORT_SYMBOL(hchacha_block_arch);
 
-void chacha_init_arch(u32 *state, const u32 *key, const u8 *iv)
-{
-	chacha_init_generic(state, key, iv);
-}
-EXPORT_SYMBOL(chacha_init_arch);
-
 static int chacha_mips_stream_xor(struct skcipher_request *req,
 				  const struct chacha_ctx *ctx, const u8 *iv)
 {
 	struct skcipher_walk walk;
 	u32 state[16];
 	int err;
 
 	err = skcipher_walk_virt(&walk, req, false);
 
-	chacha_init_generic(state, ctx->key, iv);
+	chacha_init(state, ctx->key, iv);
 
 	while (walk.nbytes > 0) {
 		unsigned int nbytes = walk.nbytes;
 
 		if (nbytes < walk.total)
@@ -65,11 +59,11 @@ static int xchacha_mips(struct skcipher_request *req)
 	struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct chacha_ctx subctx;
 	u32 state[16];
 	u8 real_iv[16];
 
-	chacha_init_generic(state, ctx->key, req->iv);
+	chacha_init(state, ctx->key, req->iv);
 
 	hchacha_block(state, subctx.key, ctx->nrounds);
 	subctx.nrounds = ctx->nrounds;
 
 	memcpy(&real_iv[0], req->iv + 24, 8);
diff --git a/arch/powerpc/crypto/chacha-p10-glue.c b/arch/powerpc/crypto/chacha-p10-glue.c
index 7c728755852e1..d8796decc1fb7 100644
--- a/arch/powerpc/crypto/chacha-p10-glue.c
+++ b/arch/powerpc/crypto/chacha-p10-glue.c
@@ -55,16 +55,10 @@ void hchacha_block_arch(const u32 *state, u32 *stream, int nrounds)
 {
 	hchacha_block_generic(state, stream, nrounds);
 }
 EXPORT_SYMBOL(hchacha_block_arch);
 
-void chacha_init_arch(u32 *state, const u32 *key, const u8 *iv)
-{
-	chacha_init_generic(state, key, iv);
-}
-EXPORT_SYMBOL(chacha_init_arch);
-
 void chacha_crypt_arch(u32 *state, u8 *dst, const u8 *src, unsigned int bytes,
 		       int nrounds)
 {
 	if (!static_branch_likely(&have_p10) || bytes <= CHACHA_BLOCK_SIZE ||
 	    !crypto_simd_usable())
@@ -93,11 +87,11 @@ static int chacha_p10_stream_xor(struct skcipher_request *req,
 
 	err = skcipher_walk_virt(&walk, req, false);
 	if (err)
 		return err;
 
-	chacha_init_generic(state, ctx->key, iv);
+	chacha_init(state, ctx->key, iv);
 
 	while (walk.nbytes > 0) {
 		unsigned int nbytes = walk.nbytes;
 
 		if (nbytes < walk.total)
@@ -135,11 +129,11 @@ static int xchacha_p10(struct skcipher_request *req)
 	struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct chacha_ctx subctx;
 	u32 state[16];
 	u8 real_iv[16];
 
-	chacha_init_generic(state, ctx->key, req->iv);
+	chacha_init(state, ctx->key, req->iv);
 	hchacha_block_arch(state, subctx.key, ctx->nrounds);
 	subctx.nrounds = ctx->nrounds;
 
 	memcpy(&real_iv[0], req->iv + 24, 8);
 	memcpy(&real_iv[8], req->iv + 16, 8);
diff --git a/arch/s390/crypto/chacha-glue.c b/arch/s390/crypto/chacha-glue.c
index f8b0c52e77a4f..920e9f0941e75 100644
--- a/arch/s390/crypto/chacha-glue.c
+++ b/arch/s390/crypto/chacha-glue.c
@@ -39,11 +39,11 @@ static int chacha20_s390(struct skcipher_request *req)
 	struct skcipher_walk walk;
 	unsigned int nbytes;
 	int rc;
 
 	rc = skcipher_walk_virt(&walk, req, false);
-	chacha_init_generic(state, ctx->key, req->iv);
+	chacha_init(state, ctx->key, req->iv);
 
 	while (walk.nbytes > 0) {
 		nbytes = walk.nbytes;
 		if (nbytes < walk.total)
 			nbytes = round_down(nbytes, walk.stride);
@@ -67,16 +67,10 @@ void hchacha_block_arch(const u32 *state, u32 *stream, int nrounds)
 	/* TODO: implement hchacha_block_arch() in assembly */
 	hchacha_block_generic(state, stream, nrounds);
 }
 EXPORT_SYMBOL(hchacha_block_arch);
 
-void chacha_init_arch(u32 *state, const u32 *key, const u8 *iv)
-{
-	chacha_init_generic(state, key, iv);
-}
-EXPORT_SYMBOL(chacha_init_arch);
-
 void chacha_crypt_arch(u32 *state, u8 *dst, const u8 *src,
 		       unsigned int bytes, int nrounds)
 {
 	/* s390 chacha20 implementation has 20 rounds hard-coded,
 	 * it cannot handle a block of data or less, but otherwise
diff --git a/arch/x86/crypto/chacha_glue.c b/arch/x86/crypto/chacha_glue.c
index 7b3a1cf0984be..8bb74a2728798 100644
--- a/arch/x86/crypto/chacha_glue.c
+++ b/arch/x86/crypto/chacha_glue.c
@@ -131,16 +131,10 @@ void hchacha_block_arch(const u32 *state, u32 *stream, int nrounds)
 		kernel_fpu_end();
 	}
 }
 EXPORT_SYMBOL(hchacha_block_arch);
 
-void chacha_init_arch(u32 *state, const u32 *key, const u8 *iv)
-{
-	chacha_init_generic(state, key, iv);
-}
-EXPORT_SYMBOL(chacha_init_arch);
-
 void chacha_crypt_arch(u32 *state, u8 *dst, const u8 *src, unsigned int bytes,
 		       int nrounds)
 {
 	if (!static_branch_likely(&chacha_use_simd) || !crypto_simd_usable() ||
 	    bytes <= CHACHA_BLOCK_SIZE)
@@ -167,11 +161,11 @@ static int chacha_simd_stream_xor(struct skcipher_request *req,
 	struct skcipher_walk walk;
 	int err;
 
 	err = skcipher_walk_virt(&walk, req, false);
 
-	chacha_init_generic(state, ctx->key, iv);
+	chacha_init(state, ctx->key, iv);
 
 	while (walk.nbytes > 0) {
 		unsigned int nbytes = walk.nbytes;
 
 		if (nbytes < walk.total)
@@ -209,11 +203,11 @@ static int xchacha_simd(struct skcipher_request *req)
 	struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
 	u32 state[CHACHA_STATE_WORDS] __aligned(8);
 	struct chacha_ctx subctx;
 	u8 real_iv[16];
 
-	chacha_init_generic(state, ctx->key, req->iv);
+	chacha_init(state, ctx->key, req->iv);
 
 	if (req->cryptlen > CHACHA_BLOCK_SIZE && crypto_simd_usable()) {
 		kernel_fpu_begin();
 		hchacha_block_ssse3(state, subctx.key, ctx->nrounds);
 		kernel_fpu_end();
diff --git a/crypto/chacha_generic.c b/crypto/chacha_generic.c
index ba7fcb47f9aa0..1fb9fbd302c6f 100644
--- a/crypto/chacha_generic.c
+++ b/crypto/chacha_generic.c
@@ -19,11 +19,11 @@ static int chacha_stream_xor(struct skcipher_request *req,
 	u32 state[16];
 	int err;
 
 	err = skcipher_walk_virt(&walk, req, false);
 
-	chacha_init_generic(state, ctx->key, iv);
+	chacha_init(state, ctx->key, iv);
 
 	while (walk.nbytes > 0) {
 		unsigned int nbytes = walk.nbytes;
 
 		if (nbytes < walk.total)
@@ -52,11 +52,11 @@ static int crypto_xchacha_crypt(struct skcipher_request *req)
 	struct chacha_ctx subctx;
 	u32 state[16];
 	u8 real_iv[16];
 
 	/* Compute the subkey given the original key and first 128 nonce bits */
-	chacha_init_generic(state, ctx->key, req->iv);
+	chacha_init(state, ctx->key, req->iv);
 	hchacha_block_generic(state, subctx.key, ctx->nrounds);
 	subctx.nrounds = ctx->nrounds;
 
 	/* Build the real IV */
 	memcpy(&real_iv[0], req->iv + 24, 8); /* stream position */
diff --git a/include/crypto/chacha.h b/include/crypto/chacha.h
index 5bae6a55b3337..f8cc073bba41b 100644
--- a/include/crypto/chacha.h
+++ b/include/crypto/chacha.h
@@ -60,12 +60,11 @@ static inline void chacha_init_consts(u32 *state)
 	state[1]  = CHACHA_CONSTANT_ND_3;
 	state[2]  = CHACHA_CONSTANT_2_BY;
 	state[3]  = CHACHA_CONSTANT_TE_K;
 }
 
-void chacha_init_arch(u32 *state, const u32 *key, const u8 *iv);
-static inline void chacha_init_generic(u32 *state, const u32 *key, const u8 *iv)
+static inline void chacha_init(u32 *state, const u32 *key, const u8 *iv)
 {
 	chacha_init_consts(state);
 	state[4]  = key[0];
 	state[5]  = key[1];
 	state[6]  = key[2];
@@ -78,18 +77,10 @@ static inline void chacha_init_generic(u32 *state, const u32 *key, const u8 *iv)
 	state[13] = get_unaligned_le32(iv +  4);
 	state[14] = get_unaligned_le32(iv +  8);
 	state[15] = get_unaligned_le32(iv + 12);
 }
 
-static inline void chacha_init(u32 *state, const u32 *key, const u8 *iv)
-{
-	if (IS_ENABLED(CONFIG_CRYPTO_ARCH_HAVE_LIB_CHACHA))
-		chacha_init_arch(state, key, iv);
-	else
-		chacha_init_generic(state, key, iv);
-}
-
 void chacha_crypt_arch(u32 *state, u8 *dst, const u8 *src,
 		       unsigned int bytes, int nrounds);
 void chacha_crypt_generic(u32 *state, u8 *dst, const u8 *src,
 			  unsigned int bytes, int nrounds);
 
diff --git a/tools/testing/crypto/chacha20-s390/test-cipher.c b/tools/testing/crypto/chacha20-s390/test-cipher.c
index 8141d45df51aa..35ea65c54ffa5 100644
--- a/tools/testing/crypto/chacha20-s390/test-cipher.c
+++ b/tools/testing/crypto/chacha20-s390/test-cipher.c
@@ -64,11 +64,11 @@ static int test_lib_chacha(u8 *revert, u8 *cipher, u8 *plain)
 		print_hex_dump(KERN_INFO, "iv:  ", DUMP_PREFIX_OFFSET,
 			       16, 1, iv, 16, 1);
 	}
 
 	/* Encrypt */
-	chacha_init_arch(chacha_state, (u32*)key, iv);
+	chacha_init(chacha_state, (u32 *)key, iv);
 
 	start = ktime_get_ns();
 	chacha_crypt_arch(chacha_state, cipher, plain, data_size, 20);
 	end = ktime_get_ns();
 
@@ -79,11 +79,11 @@ static int test_lib_chacha(u8 *revert, u8 *cipher, u8 *plain)
 			       (data_size > 64 ? 64 : data_size), 1);
 
 	pr_info("lib encryption took: %lld nsec", end - start);
 
 	/* Decrypt */
-	chacha_init_arch(chacha_state, (u32 *)key, iv);
+	chacha_init(chacha_state, (u32 *)key, iv);
 
 	start = ktime_get_ns();
 	chacha_crypt_arch(chacha_state, revert, cipher, data_size, 20);
 	end = ktime_get_ns();
 

base-commit: d2d072a313c1817a0d72d7b8301eaf29ce7f83fc
-- 
2.49.0

