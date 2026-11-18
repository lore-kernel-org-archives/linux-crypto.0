Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794975056;
	b=sjJZMzR1Kgk6N77iYAU0of16hZ+CUlw8ShrTQOq3Y684til2Oi30LIzXGnHeQIaFMIM4
	 idkw2AwhJ2Gu69rF6qoaqhkK5HZ7TaSgjQR00WOuA6PqPjYgB8FdABJ0SNqpQlDMFKiac
	 PP4lodQVUrrOBSLrwpfVqxdVpbt756aDrbyHjufl5qRAA5oUP6dag5/tsiE9dWfSonpa1
	 HYrgIf+j5/sNSCfs4Ji+4hJUEOPmRqlNSAj2vQ8zYo+RPE0U0ZkjzdUCPTiR4qHJWFKAc
	 e6EPsql19JOUsLY0tx66zyDG3VcECtnxihja16+hto7G3Ethn5iBgW2gi5u70HjSpPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794975056;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=KU6ZGYcBeuGf4orxIT3f5XPYBQ51Uqm/sdwsHt6Rl3E=;
	b=agw+K1sJbcpwTBt598qLeyFNL1ZztoceKyWu//McLXYPksa7NOgiROgKYrChwoh7SyFx
	 gY3ns3AVm5/Cytixrtv/sN733440KRRrshvSIBYhhncX7A4tJOTWcsL/J+8h5yENpI0ip
	 4mBXFeSukA8uNqhadLE6qMLtLL0ELvhBTttIIkUUlvIJ6r4yB0HzQVsATwPlcIrVq8pSF
	 tQyasBiDYug+3M5yMwYnSnXn5cjwxyDUULY6gfkah6qO1RfuMpZg6R+UIM3qDoMUUl5CN
	 ix5UITbQFtLM/vpe5RkvLjK5CtQs6Fa9MX3V4/VzY4QRzSLVNxGHRx+Q+PzcrmKer3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KaFOR6EI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31D57606A881;
	Wed, 18 Nov 2026 04:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KaFOR6EI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A154D1F000C8;
	Wed, 18 Nov 2026 04:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794975056;
	bh=KU6ZGYcBeuGf4orxIT3f5XPYBQ51Uqm/sdwsHt6Rl3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KaFOR6EIjX2Uke770mkPRnFuhtUZZAbWTPX/OgwEl2YBE3D6gXA2n/gcv99gEF9MN
	 D7KiD49j2JXIsxf7SlQm6zpVxYy2GOJ4JHivzrwfBDnj7uJ0Qw3PeLNEKaigsJ/zD7
	 6am/swLWs6jr1nqm5v1+hDteODSEYoZ/gbaGMb1r8Ss9q4bCHq06fySLzKZvpU7QZd
	 IjxuMhLONFLHImTIv+gwviXPaW1C4qXYYAmVmygyqBdkzkWSM5WspTTWwaKkom6N1H
	 9Wy0SnJQjUEptPoQciWuhrY6lobsVLZHtQHvLc3O1JFF+Wg3mNyQ+8bkT8ylGlZYYL
	 obtqbPHBiIHWQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	sparclinux@vger.kernel.org,
	Andreas Larsson <andreas@gaisler.com>,
	"David S . Miller" <davem@davemloft.net>,
	Stian Halseth <stian@itx.no>,
	Magnus Lindholm <linmag7@gmail.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 3/4] lib/crypto: sparc/aes-ecb: Migrate optimized code into library
Date: Tue, 17 Nov 2026 20:10:32 -0800
Message-ID: <20261118041033.50014-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261118041033.50014-1-ebiggers@kernel.org>
References: <20261118041033.50014-1-ebiggers@kernel.org>
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

Instead of exposing the sparc64-optimized AES-ECB code via a
sparc64-specific crypto_skcipher algorithm, implement the AES-ECB
library functions.  This is simpler, makes the AES-ECB library
functions sparc64-optimized, and fixes the longstanding issue where
the sparc64-optimized AES-ECB code was disabled by default.  AES-ECB
support remains available through crypto_skcipher via crypto/aes.c.

The library functions take size_t lengths, so update the ECB assembly
functions to match.

Handle the ECB assembly code's data alignment requirement by explicitly
using an on-stack bounce buffer when the data is misaligned.  (Note that
bounce buffering was used in the old code too; it was just hidden in the
skcipher_walk_* functions via the configured cra_alignmask=7.)

Now that ecb-aes-sparc64 is removed, also increase the priority of
ecb-aes-lib on SPARC.

Tested in QEMU (commit 97c88c61d45d) with aes_ecb_kunit
(https://lore.kernel.org/r/20261116062849.1071038-3-ebiggers@kernel.org/)
and CONFIG_CRYPTO_SELFTESTS_FULL=y, using the patch that makes the SPARC
kernel detect QEMU's support for the SPARC crypto opcodes
(https://lore.kernel.org/r/20261117112914.2300417-1-stian@itx.no/).

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/sparc/crypto/Kconfig    |  4 +-
 arch/sparc/crypto/aes_glue.c | 72 ---------------------------
 crypto/aes.c                 |  1 +
 include/crypto/aes.h         | 12 -----
 lib/crypto/sparc/aes.h       | 94 +++++++++++++++++++++++++++++++++---
 lib/crypto/sparc/aes_asm.S   | 14 +++---
 6 files changed, 99 insertions(+), 98 deletions(-)

diff --git a/arch/sparc/crypto/Kconfig b/arch/sparc/crypto/Kconfig
index b7edee0da73e6..783b057aeebfb 100644
--- a/arch/sparc/crypto/Kconfig
+++ b/arch/sparc/crypto/Kconfig
@@ -3,12 +3,12 @@
 menu "Accelerated Cryptographic Algorithms for CPU (sparc64)"
 
 config CRYPTO_AES_SPARC64
-	tristate "Ciphers: AES, modes: ECB, CBC"
+	tristate "Ciphers: AES, modes: CBC"
 	depends on SPARC64
 	select CRYPTO_LIB_AES
 	select CRYPTO_SKCIPHER
 	help
-	  Length-preserving ciphers: AES with ECB and CBC modes
+	  Length-preserving ciphers: AES with CBC mode
 
 	  Architecture: sparc64 using crypto instructions
 
diff --git a/arch/sparc/crypto/aes_glue.c b/arch/sparc/crypto/aes_glue.c
index 8fa231ab595c2..cb36070ca39bf 100644
--- a/arch/sparc/crypto/aes_glue.c
+++ b/arch/sparc/crypto/aes_glue.c
@@ -34,10 +34,6 @@
 struct aes_ops {
 	void (*load_encrypt_keys)(const u64 *key);
 	void (*load_decrypt_keys)(const u64 *key);
-	void (*ecb_encrypt)(const u64 *key, const u64 *input, u64 *output,
-			    unsigned int len);
-	void (*ecb_decrypt)(const u64 *key, const u64 *input, u64 *output,
-			    unsigned int len);
 	void (*cbc_encrypt)(const u64 *key, const u64 *input, u64 *output,
 			    unsigned int len, u64 *iv);
 	void (*cbc_decrypt)(const u64 *key, const u64 *input, u64 *output,
@@ -54,8 +50,6 @@ struct crypto_sparc64_aes_ctx {
 static struct aes_ops aes128_ops = {
 	.load_encrypt_keys	= aes_sparc64_load_encrypt_keys_128,
 	.load_decrypt_keys	= aes_sparc64_load_decrypt_keys_128,
-	.ecb_encrypt		= aes_sparc64_ecb_encrypt_128,
-	.ecb_decrypt		= aes_sparc64_ecb_decrypt_128,
 	.cbc_encrypt		= aes_sparc64_cbc_encrypt_128,
 	.cbc_decrypt		= aes_sparc64_cbc_decrypt_128,
 };
@@ -63,8 +57,6 @@ static struct aes_ops aes128_ops = {
 static struct aes_ops aes192_ops = {
 	.load_encrypt_keys	= aes_sparc64_load_encrypt_keys_192,
 	.load_decrypt_keys	= aes_sparc64_load_decrypt_keys_192,
-	.ecb_encrypt		= aes_sparc64_ecb_encrypt_192,
-	.ecb_decrypt		= aes_sparc64_ecb_decrypt_192,
 	.cbc_encrypt		= aes_sparc64_cbc_encrypt_192,
 	.cbc_decrypt		= aes_sparc64_cbc_decrypt_192,
 };
@@ -72,8 +64,6 @@ static struct aes_ops aes192_ops = {
 static struct aes_ops aes256_ops = {
 	.load_encrypt_keys	= aes_sparc64_load_encrypt_keys_256,
 	.load_decrypt_keys	= aes_sparc64_load_decrypt_keys_256,
-	.ecb_encrypt		= aes_sparc64_ecb_encrypt_256,
-	.ecb_decrypt		= aes_sparc64_ecb_decrypt_256,
 	.cbc_encrypt		= aes_sparc64_cbc_encrypt_256,
 	.cbc_decrypt		= aes_sparc64_cbc_decrypt_256,
 };
@@ -109,55 +99,6 @@ static int aes_set_key_skcipher(struct crypto_skcipher *tfm, const u8 *in_key,
 	return 0;
 }
 
-static int ecb_encrypt(struct skcipher_request *req)
-{
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	const struct crypto_sparc64_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct skcipher_walk walk;
-	unsigned int nbytes;
-	int err;
-
-	err = skcipher_walk_virt(&walk, req, true);
-	if (err)
-		return err;
-
-	ctx->ops->load_encrypt_keys(&ctx->key[0]);
-	while ((nbytes = walk.nbytes) != 0) {
-		ctx->ops->ecb_encrypt(&ctx->key[0], walk.src.virt.addr,
-				      walk.dst.virt.addr,
-				      round_down(nbytes, AES_BLOCK_SIZE));
-		err = skcipher_walk_done(&walk, nbytes % AES_BLOCK_SIZE);
-	}
-	fprs_write(0);
-	return err;
-}
-
-static int ecb_decrypt(struct skcipher_request *req)
-{
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	const struct crypto_sparc64_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
-	const u64 *key_end;
-	struct skcipher_walk walk;
-	unsigned int nbytes;
-	int err;
-
-	err = skcipher_walk_virt(&walk, req, true);
-	if (err)
-		return err;
-
-	ctx->ops->load_decrypt_keys(&ctx->key[0]);
-	key_end = &ctx->key[ctx->expanded_key_length / sizeof(u64)];
-	while ((nbytes = walk.nbytes) != 0) {
-		ctx->ops->ecb_decrypt(key_end, walk.src.virt.addr,
-				      walk.dst.virt.addr,
-				      round_down(nbytes, AES_BLOCK_SIZE));
-		err = skcipher_walk_done(&walk, nbytes % AES_BLOCK_SIZE);
-	}
-	fprs_write(0);
-
-	return err;
-}
-
 static int cbc_encrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
@@ -211,19 +152,6 @@ static int cbc_decrypt(struct skcipher_request *req)
 
 static struct skcipher_alg skcipher_algs[] = {
 	{
-		.base.cra_name		= "ecb(aes)",
-		.base.cra_driver_name	= "ecb-aes-sparc64",
-		.base.cra_priority	= SPARC_CR_OPCODE_PRIORITY,
-		.base.cra_blocksize	= AES_BLOCK_SIZE,
-		.base.cra_ctxsize	= sizeof(struct crypto_sparc64_aes_ctx),
-		.base.cra_alignmask	= 7,
-		.base.cra_module	= THIS_MODULE,
-		.min_keysize		= AES_MIN_KEY_SIZE,
-		.max_keysize		= AES_MAX_KEY_SIZE,
-		.setkey			= aes_set_key_skcipher,
-		.encrypt		= ecb_encrypt,
-		.decrypt		= ecb_decrypt,
-	}, {
 		.base.cra_name		= "cbc(aes)",
 		.base.cra_driver_name	= "cbc-aes-sparc64",
 		.base.cra_priority	= SPARC_CR_OPCODE_PRIORITY,
diff --git a/crypto/aes.c b/crypto/aes.c
index 96639c96b0497..2e4ea9d7a74d8 100644
--- a/crypto/aes.c
+++ b/crypto/aes.c
@@ -611,6 +611,7 @@ static struct skcipher_alg skcipher_algs[] = {
 		.base.cra_name = "ecb(aes)",
 		.base.cra_driver_name = "ecb-aes-lib",
 		.base.cra_priority = (IS_ENABLED(CONFIG_RISCV) ||
+				      IS_ENABLED(CONFIG_SPARC) ||
 				      IS_ENABLED(CONFIG_X86)) ? 500 : 110,
 		.base.cra_blocksize = AES_BLOCK_SIZE,
 		.base.cra_ctxsize = sizeof(struct aes_key),
diff --git a/include/crypto/aes.h b/include/crypto/aes.h
index 6dd6d394235cc..e77e8660f347e 100644
--- a/include/crypto/aes.h
+++ b/include/crypto/aes.h
@@ -308,18 +308,6 @@ void aes_sparc64_load_encrypt_keys_256(const u64 *key);
 void aes_sparc64_load_decrypt_keys_128(const u64 *key);
 void aes_sparc64_load_decrypt_keys_192(const u64 *key);
 void aes_sparc64_load_decrypt_keys_256(const u64 *key);
-void aes_sparc64_ecb_encrypt_128(const u64 *key, const u64 *input, u64 *output,
-				 unsigned int len);
-void aes_sparc64_ecb_encrypt_192(const u64 *key, const u64 *input, u64 *output,
-				 unsigned int len);
-void aes_sparc64_ecb_encrypt_256(const u64 *key, const u64 *input, u64 *output,
-				 unsigned int len);
-void aes_sparc64_ecb_decrypt_128(const u64 *key, const u64 *input, u64 *output,
-				 unsigned int len);
-void aes_sparc64_ecb_decrypt_192(const u64 *key, const u64 *input, u64 *output,
-				 unsigned int len);
-void aes_sparc64_ecb_decrypt_256(const u64 *key, const u64 *input, u64 *output,
-				 unsigned int len);
 void aes_sparc64_cbc_encrypt_128(const u64 *key, const u64 *input, u64 *output,
 				 unsigned int len, u64 *iv);
 void aes_sparc64_cbc_encrypt_192(const u64 *key, const u64 *input, u64 *output,
diff --git a/lib/crypto/sparc/aes.h b/lib/crypto/sparc/aes.h
index c9c21b6505d0a..b13e8046467ea 100644
--- a/lib/crypto/sparc/aes.h
+++ b/lib/crypto/sparc/aes.h
@@ -21,12 +21,6 @@ EXPORT_SYMBOL_GPL(aes_sparc64_load_encrypt_keys_256);
 EXPORT_SYMBOL_GPL(aes_sparc64_load_decrypt_keys_128);
 EXPORT_SYMBOL_GPL(aes_sparc64_load_decrypt_keys_192);
 EXPORT_SYMBOL_GPL(aes_sparc64_load_decrypt_keys_256);
-EXPORT_SYMBOL_GPL(aes_sparc64_ecb_encrypt_128);
-EXPORT_SYMBOL_GPL(aes_sparc64_ecb_encrypt_192);
-EXPORT_SYMBOL_GPL(aes_sparc64_ecb_encrypt_256);
-EXPORT_SYMBOL_GPL(aes_sparc64_ecb_decrypt_128);
-EXPORT_SYMBOL_GPL(aes_sparc64_ecb_decrypt_192);
-EXPORT_SYMBOL_GPL(aes_sparc64_ecb_decrypt_256);
 EXPORT_SYMBOL_GPL(aes_sparc64_cbc_encrypt_128);
 EXPORT_SYMBOL_GPL(aes_sparc64_cbc_encrypt_192);
 EXPORT_SYMBOL_GPL(aes_sparc64_cbc_encrypt_256);
@@ -164,6 +158,94 @@ static __always_inline void aes_sparc64_load_round_keys(aes_encrypt_arg key_arg,
  */
 #define MISALIGNED_CHUNK_SIZE (8 * AES_BLOCK_SIZE)
 
+#if IS_ENABLED(CONFIG_CRYPTO_LIB_AES_ECB)
+void aes_sparc64_ecb_encrypt_128(const u64 *key, const u64 *input, u64 *output,
+				 size_t len);
+void aes_sparc64_ecb_encrypt_192(const u64 *key, const u64 *input, u64 *output,
+				 size_t len);
+void aes_sparc64_ecb_encrypt_256(const u64 *key, const u64 *input, u64 *output,
+				 size_t len);
+void aes_sparc64_ecb_decrypt_128(const u64 *key_end, const u64 *input,
+				 u64 *output, size_t len);
+void aes_sparc64_ecb_decrypt_192(const u64 *key_end, const u64 *input,
+				 u64 *output, size_t len);
+void aes_sparc64_ecb_decrypt_256(const u64 *key_end, const u64 *input,
+				 u64 *output, size_t len);
+
+static __always_inline void aes_sparc64_ecb_crypt(const struct aes_enckey *key,
+						  const u64 *in, u64 *out,
+						  size_t len, bool enc)
+{
+	const u64 *rk = key->k.sparc_rndkeys;
+	const u64 *rk_end = &rk[2 * (key->nrounds + 1)];
+
+	if (enc) {
+		if (key->len == AES_KEYSIZE_128)
+			aes_sparc64_ecb_encrypt_128(rk, in, out, len);
+		else if (key->len == AES_KEYSIZE_192)
+			aes_sparc64_ecb_encrypt_192(rk, in, out, len);
+		else
+			aes_sparc64_ecb_encrypt_256(rk, in, out, len);
+	} else {
+		if (key->len == AES_KEYSIZE_128)
+			aes_sparc64_ecb_decrypt_128(rk_end, in, out, len);
+		else if (key->len == AES_KEYSIZE_192)
+			aes_sparc64_ecb_decrypt_192(rk_end, in, out, len);
+		else
+			aes_sparc64_ecb_decrypt_256(rk_end, in, out, len);
+	}
+}
+
+/* len is always a positive multiple of AES_BLOCK_SIZE here. */
+static __always_inline bool aes_ecb_crypt_sparc64(u8 *dst, const u8 *src,
+						  size_t len,
+						  aes_encrypt_arg key_arg,
+						  bool enc)
+{
+	const struct aes_enckey *key = key_arg.enc_key;
+
+	if (!static_branch_likely(&have_aes_opcodes))
+		return false;
+
+	aes_sparc64_load_round_keys(key, enc);
+
+	if (IS_ALIGNED((uintptr_t)src | (uintptr_t)dst, 8)) {
+		aes_sparc64_ecb_crypt(key, (const u64 *)src, (u64 *)dst, len,
+				      enc);
+	} else {
+		u64 tmp[MISALIGNED_CHUNK_SIZE / sizeof(u64)];
+
+		do {
+			size_t n = min(len, sizeof(tmp));
+
+			memcpy(tmp, src, n);
+			aes_sparc64_ecb_crypt(key, tmp, tmp, n, enc);
+			memcpy(dst, tmp, n);
+			src += n;
+			dst += n;
+			len -= n;
+		} while (len);
+		memzero_explicit(tmp, sizeof(tmp));
+	}
+	fprs_write(0);
+	return true;
+}
+
+#define aes_ecb_encrypt_arch aes_ecb_encrypt_arch
+static bool aes_ecb_encrypt_arch(u8 *dst, const u8 *src, size_t len,
+				 const struct aes_enckey *key)
+{
+	return aes_ecb_crypt_sparc64(dst, src, len, key, true);
+}
+
+#define aes_ecb_decrypt_arch aes_ecb_decrypt_arch
+static bool aes_ecb_decrypt_arch(u8 *dst, const u8 *src, size_t len,
+				 const struct aes_key *key)
+{
+	return aes_ecb_crypt_sparc64(dst, src, len, key, false);
+}
+#endif /* CONFIG_CRYPTO_LIB_AES_ECB */
+
 #if IS_ENABLED(CONFIG_CRYPTO_LIB_AES_CTR)
 void aes_sparc64_ctr_crypt_128(const u64 *key, const u64 *input, u64 *output,
 			       size_t len, u64 iv[2]);
diff --git a/lib/crypto/sparc/aes_asm.S b/lib/crypto/sparc/aes_asm.S
index c95a86462b776..fc63f3233ca23 100644
--- a/lib/crypto/sparc/aes_asm.S
+++ b/lib/crypto/sparc/aes_asm.S
@@ -909,12 +909,13 @@ ENTRY(aes_sparc64_load_decrypt_keys_256)
 	 ldd		[%o0 + 0x00], %f62
 ENDPROC(aes_sparc64_load_decrypt_keys_256)
 
+#if IS_ENABLED(CONFIG_CRYPTO_LIB_AES_ECB)
 	.align		32
 ENTRY(aes_sparc64_ecb_encrypt_128)
 	/* %o0=key, %o1=input, %o2=output, %o3=len */
 	ldx		[%o0 + 0x00], %g1
 	subcc		%o3, 0x10, %o3
-	be		10f
+	be,pn		%xcc, 10f
 	 ldx		[%o0 + 0x08], %g2
 1:	ldx		[%o1 + 0x00], %g3
 	ldx		[%o1 + 0x08], %g7
@@ -957,7 +958,7 @@ ENTRY(aes_sparc64_ecb_encrypt_192)
 	/* %o0=key, %o1=input, %o2=output, %o3=len */
 	ldx		[%o0 + 0x00], %g1
 	subcc		%o3, 0x10, %o3
-	be		10f
+	be,pn		%xcc, 10f
 	 ldx		[%o0 + 0x08], %g2
 1:	ldx		[%o1 + 0x00], %g3
 	ldx		[%o1 + 0x08], %g7
@@ -1000,7 +1001,7 @@ ENTRY(aes_sparc64_ecb_encrypt_256)
 	/* %o0=key, %o1=input, %o2=output, %o3=len */
 	ldx		[%o0 + 0x00], %g1
 	subcc		%o3, 0x10, %o3
-	be		10f
+	be,pn		%xcc, 10f
 	 ldx		[%o0 + 0x08], %g2
 1:	ldx		[%o1 + 0x00], %g3
 	ldx		[%o1 + 0x08], %g7
@@ -1047,7 +1048,7 @@ ENTRY(aes_sparc64_ecb_decrypt_128)
 	/* %o0=&key[key_len], %o1=input, %o2=output, %o3=len */
 	ldx		[%o0 - 0x10], %g1
 	subcc		%o3, 0x10, %o3
-	be		10f
+	be,pn		%xcc, 10f
 	 ldx		[%o0 - 0x08], %g2
 1:	ldx		[%o1 + 0x00], %g3
 	ldx		[%o1 + 0x08], %g7
@@ -1090,7 +1091,7 @@ ENTRY(aes_sparc64_ecb_decrypt_192)
 	/* %o0=&key[key_len], %o1=input, %o2=output, %o3=len */
 	ldx		[%o0 - 0x10], %g1
 	subcc		%o3, 0x10, %o3
-	be		10f
+	be,pn		%xcc, 10f
 	 ldx		[%o0 - 0x08], %g2
 1:	ldx		[%o1 + 0x00], %g3
 	ldx		[%o1 + 0x08], %g7
@@ -1134,7 +1135,7 @@ ENTRY(aes_sparc64_ecb_decrypt_256)
 	ldx		[%o0 - 0x10], %g1
 	subcc		%o3, 0x10, %o3
 	ldx		[%o0 - 0x08], %g2
-	be		10f
+	be,pn		%xcc, 10f
 	 sub		%o0, 0xf0, %o0
 1:	ldx		[%o1 + 0x00], %g3
 	ldx		[%o1 + 0x08], %g7
@@ -1175,6 +1176,7 @@ ENTRY(aes_sparc64_ecb_decrypt_256)
 11:	retl
 	 nop
 ENDPROC(aes_sparc64_ecb_decrypt_256)
+#endif /* CONFIG_CRYPTO_LIB_AES_ECB */
 
 	.align		32
 ENTRY(aes_sparc64_cbc_encrypt_128)
-- 
2.56.1

