Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794975055;
	b=OpHhPptmX1I6mIFNJlK+QolK2Yq1qcMOexG4cDv0Nv86ay0kNI/dDQPuvw4lo3d5Jj+9
	 k6YSBfvMTtgEH35XeVjktdV3lGhYN0ruanq7HtUaPA388USx6wsj2pS93VNh2ZDmVjssZ
	 JOk8o+c+K2IQfLvL3iUIRUdoiid8Zj6qiF8JaXeEg6gB3H7CHaEjGls5xI1bUObDQKGNi
	 UyFR5s3iz0xGpbPdCupSWmXiuKSo/ZGmIs1szC+L3w4i7rmrQGEZyA7PtCqVgioHs+09M
	 HVSgYaYQFE8DX+xGe9TfbcrSwS5RhbVIo2J/Eo/ZxUyfaereyQl1uFY2qykVC1BMFKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794975055;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=QDAZx2dML8dGThmbIfoHf6BNfXAFebt1cuVY2NRS5XA=;
	b=E0fEYyW9FhQ+KYI915vANnNlTddjbtuIFlKBFZY+6CVt0WxJXlHWwFoIC+eJpHPhCq8D
	 xYH2KZgcvVGcrkUk1YzxCYqhmZTeciEIiIj0ZV7nDbWRBciDqUGIt+T9Put4XuyC/iWiT
	 Biad5JVyGq9DwzE/WCi/CkHwzIdOUg5m+BwK+8nqqzd2nGBED6Xhg63q9lTKtBgUQwYDo
	 2H3J0zSQY191dPKI0/n1YGRc0Fs5o/typDshCefyGdN/SAeWOkSTX9IfzZ6F5NTy0+f//
	 ZmGs4hp3n+KdL1l7hRUll2m57C5z2uTkdCZeMfDpCP2j9Y/9QuGtxt24hHWtDvvFKCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S08ZvWBe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A139B606A33D;
	Wed, 18 Nov 2026 04:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S08ZvWBe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 318C81F000CC;
	Wed, 18 Nov 2026 04:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794975055;
	bh=QDAZx2dML8dGThmbIfoHf6BNfXAFebt1cuVY2NRS5XA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S08ZvWBeQti+BVkkFzJ36ODeMHPZVlkHS0rpAg/k7RnjOtPWF7GxkPgLbvK1p7yC3
	 hDSCh2cjKzbxblUgdusHEPVYK2hRMMENIZ6BN0NFeCbMy+1HjfE9qyusV9MpWXQgKy
	 rplXMf9cQB3rHc3Zc3NTAtp031eTldJyqDyxRBSik/Vq5cyG/kEHg7bqXP+KiR3V+E
	 jagLd12zQjN+D6XyLE941DtNOxFIzP1QdrC7r6MU4z3QipYotL+xmb+O1T0IS1qht8
	 BCmgDTJzgdIypGoOQACuvVyPE9YHj5KXzBCRTZClbmsTzQYvH9KU5dbhCyJhjhmXXE
	 kxoMiThAKHxag==
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
Subject: [PATCH 2/4] lib/crypto: sparc/aes-ctr: Migrate optimized code into library
Date: Tue, 17 Nov 2026 20:10:31 -0800
Message-ID: <20261118041033.50014-3-ebiggers@kernel.org>
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

Instead of exposing the sparc64-optimized AES-CTR code via a
sparc64-specific crypto_skcipher algorithm, implement the AES-CTR
library function.  This is simpler, makes the AES-CTR library function
sparc64-optimized, and fixes the longstanding issue where the
sparc64-optimized AES-CTR code was disabled by default.  AES-CTR support
remains available through crypto_skcipher via crypto/aes.c.

The library functions take size_t lengths, so update the CTR assembly
functions to match.

Handle the CTR assembly code's data alignment requirement by explicitly
using an on-stack bounce buffer when the data is misaligned.  (Note that
bounce buffering was used in the old code too; it was just hidden in the
skcipher_walk_* functions via the configured cra_alignmask=7.)  Also use
a bounce buffer to handle any partial block at the end of the message.

Now that ctr-aes-sparc64 is removed, also increase the priority of
ctr-aes-lib on SPARC, and re-enable ccm-aes-lib, gcm-aes-lib, and
rfc4106-gcm-aes-lib.

Tested in QEMU (commit 97c88c61d45d) with aes_ctr_kunit
(https://lore.kernel.org/r/20261116062849.1071038-6-ebiggers@kernel.org/)
and CONFIG_CRYPTO_SELFTESTS_FULL=y, using the patch that makes the SPARC
kernel detect QEMU's support for the SPARC crypto opcodes
(https://lore.kernel.org/r/20261117112914.2300417-1-stian@itx.no/).

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/sparc/crypto/Kconfig    |  4 +-
 arch/sparc/crypto/aes_glue.c | 63 ------------------------
 crypto/aes.c                 |  7 ++-
 include/crypto/aes.h         |  6 ---
 lib/crypto/sparc/aes.h       | 92 ++++++++++++++++++++++++++++++++++--
 lib/crypto/sparc/aes_asm.S   |  8 ++--
 6 files changed, 99 insertions(+), 81 deletions(-)

diff --git a/arch/sparc/crypto/Kconfig b/arch/sparc/crypto/Kconfig
index 8db3f6eea5dc3..b7edee0da73e6 100644
--- a/arch/sparc/crypto/Kconfig
+++ b/arch/sparc/crypto/Kconfig
@@ -3,12 +3,12 @@
 menu "Accelerated Cryptographic Algorithms for CPU (sparc64)"
 
 config CRYPTO_AES_SPARC64
-	tristate "Ciphers: AES, modes: ECB, CBC, CTR"
+	tristate "Ciphers: AES, modes: ECB, CBC"
 	depends on SPARC64
 	select CRYPTO_LIB_AES
 	select CRYPTO_SKCIPHER
 	help
-	  Length-preseving ciphers: AES with ECB, CBC, and CTR modes
+	  Length-preserving ciphers: AES with ECB and CBC modes
 
 	  Architecture: sparc64 using crypto instructions
 
diff --git a/arch/sparc/crypto/aes_glue.c b/arch/sparc/crypto/aes_glue.c
index 661561837415a..8fa231ab595c2 100644
--- a/arch/sparc/crypto/aes_glue.c
+++ b/arch/sparc/crypto/aes_glue.c
@@ -42,8 +42,6 @@ struct aes_ops {
 			    unsigned int len, u64 *iv);
 	void (*cbc_decrypt)(const u64 *key, const u64 *input, u64 *output,
 			    unsigned int len, u64 *iv);
-	void (*ctr_crypt)(const u64 *key, const u64 *input, u64 *output,
-			  unsigned int len, u64 *iv);
 };
 
 struct crypto_sparc64_aes_ctx {
@@ -60,7 +58,6 @@ static struct aes_ops aes128_ops = {
 	.ecb_decrypt		= aes_sparc64_ecb_decrypt_128,
 	.cbc_encrypt		= aes_sparc64_cbc_encrypt_128,
 	.cbc_decrypt		= aes_sparc64_cbc_decrypt_128,
-	.ctr_crypt		= aes_sparc64_ctr_crypt_128,
 };
 
 static struct aes_ops aes192_ops = {
@@ -70,7 +67,6 @@ static struct aes_ops aes192_ops = {
 	.ecb_decrypt		= aes_sparc64_ecb_decrypt_192,
 	.cbc_encrypt		= aes_sparc64_cbc_encrypt_192,
 	.cbc_decrypt		= aes_sparc64_cbc_decrypt_192,
-	.ctr_crypt		= aes_sparc64_ctr_crypt_192,
 };
 
 static struct aes_ops aes256_ops = {
@@ -80,7 +76,6 @@ static struct aes_ops aes256_ops = {
 	.ecb_decrypt		= aes_sparc64_ecb_decrypt_256,
 	.cbc_encrypt		= aes_sparc64_cbc_encrypt_256,
 	.cbc_decrypt		= aes_sparc64_cbc_decrypt_256,
-	.ctr_crypt		= aes_sparc64_ctr_crypt_256,
 };
 
 static int aes_set_key_skcipher(struct crypto_skcipher *tfm, const u8 *in_key,
@@ -214,49 +209,6 @@ static int cbc_decrypt(struct skcipher_request *req)
 	return err;
 }
 
-static void ctr_crypt_final(const struct crypto_sparc64_aes_ctx *ctx,
-			    struct skcipher_walk *walk)
-{
-	u8 *ctrblk = walk->iv;
-	u64 keystream[AES_BLOCK_SIZE / sizeof(u64)];
-	const u8 *src = walk->src.virt.addr;
-	u8 *dst = walk->dst.virt.addr;
-	unsigned int nbytes = walk->nbytes;
-
-	ctx->ops->ecb_encrypt(&ctx->key[0], (const u64 *)ctrblk,
-			      keystream, AES_BLOCK_SIZE);
-	crypto_xor_cpy(dst, (u8 *) keystream, src, nbytes);
-	crypto_inc(ctrblk, AES_BLOCK_SIZE);
-}
-
-static int ctr_crypt(struct skcipher_request *req)
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
-	while ((nbytes = walk.nbytes) >= AES_BLOCK_SIZE) {
-		ctx->ops->ctr_crypt(&ctx->key[0], walk.src.virt.addr,
-				    walk.dst.virt.addr,
-				    round_down(nbytes, AES_BLOCK_SIZE),
-				    walk.iv);
-		err = skcipher_walk_done(&walk, nbytes % AES_BLOCK_SIZE);
-	}
-	if (walk.nbytes) {
-		ctr_crypt_final(ctx, &walk);
-		err = skcipher_walk_done(&walk, 0);
-	}
-	fprs_write(0);
-	return err;
-}
-
 static struct skcipher_alg skcipher_algs[] = {
 	{
 		.base.cra_name		= "ecb(aes)",
@@ -285,21 +237,6 @@ static struct skcipher_alg skcipher_algs[] = {
 		.setkey			= aes_set_key_skcipher,
 		.encrypt		= cbc_encrypt,
 		.decrypt		= cbc_decrypt,
-	}, {
-		.base.cra_name		= "ctr(aes)",
-		.base.cra_driver_name	= "ctr-aes-sparc64",
-		.base.cra_priority	= SPARC_CR_OPCODE_PRIORITY,
-		.base.cra_blocksize	= 1,
-		.base.cra_ctxsize	= sizeof(struct crypto_sparc64_aes_ctx),
-		.base.cra_alignmask	= 7,
-		.base.cra_module	= THIS_MODULE,
-		.min_keysize		= AES_MIN_KEY_SIZE,
-		.max_keysize		= AES_MAX_KEY_SIZE,
-		.ivsize			= AES_BLOCK_SIZE,
-		.setkey			= aes_set_key_skcipher,
-		.encrypt		= ctr_crypt,
-		.decrypt		= ctr_crypt,
-		.chunksize		= AES_BLOCK_SIZE,
 	}
 };
 
diff --git a/crypto/aes.c b/crypto/aes.c
index 9508a975d8eaf..96639c96b0497 100644
--- a/crypto/aes.c
+++ b/crypto/aes.c
@@ -672,6 +672,7 @@ static struct skcipher_alg skcipher_algs[] = {
 		.base.cra_name = "ctr(aes)",
 		.base.cra_driver_name = "ctr-aes-lib",
 		.base.cra_priority = (IS_ENABLED(CONFIG_RISCV) ||
+				      IS_ENABLED(CONFIG_SPARC) ||
 				      IS_ENABLED(CONFIG_X86)) ? 500 : 110,
 		.base.cra_blocksize = 1,
 		.base.cra_ctxsize = sizeof(struct aes_enckey),
@@ -1008,8 +1009,7 @@ static struct aead_alg aead_algs[] = {
 	!(IS_ENABLED(CONFIG_ARM) || \
 	  IS_ENABLED(CONFIG_ARM64) || \
 	  IS_ENABLED(CONFIG_PPC) || \
-	  IS_ENABLED(CONFIG_S390) || \
-	  IS_ENABLED(CONFIG_SPARC))
+	  IS_ENABLED(CONFIG_S390))
 	{
 		.base.cra_name = "gcm(aes)",
 		.base.cra_driver_name = "gcm-aes-lib",
@@ -1051,8 +1051,7 @@ static struct aead_alg aead_algs[] = {
 	!(IS_ENABLED(CONFIG_ARM) || \
 	  IS_ENABLED(CONFIG_ARM64) || \
 	  IS_ENABLED(CONFIG_PPC) || \
-	  IS_ENABLED(CONFIG_S390) || \
-	  IS_ENABLED(CONFIG_SPARC))
+	  IS_ENABLED(CONFIG_S390))
 	{
 		.base.cra_name = "ccm(aes)",
 		.base.cra_driver_name = "ccm-aes-lib",
diff --git a/include/crypto/aes.h b/include/crypto/aes.h
index fa5c3d363ac9b..6dd6d394235cc 100644
--- a/include/crypto/aes.h
+++ b/include/crypto/aes.h
@@ -332,12 +332,6 @@ void aes_sparc64_cbc_decrypt_192(const u64 *key, const u64 *input, u64 *output,
 				 unsigned int len, u64 *iv);
 void aes_sparc64_cbc_decrypt_256(const u64 *key, const u64 *input, u64 *output,
 				 unsigned int len, u64 *iv);
-void aes_sparc64_ctr_crypt_128(const u64 *key, const u64 *input, u64 *output,
-			       unsigned int len, u64 *iv);
-void aes_sparc64_ctr_crypt_192(const u64 *key, const u64 *input, u64 *output,
-			       unsigned int len, u64 *iv);
-void aes_sparc64_ctr_crypt_256(const u64 *key, const u64 *input, u64 *output,
-			       unsigned int len, u64 *iv);
 #endif
 
 /**
diff --git a/lib/crypto/sparc/aes.h b/lib/crypto/sparc/aes.h
index 8b8ab0820bb3e..c9c21b6505d0a 100644
--- a/lib/crypto/sparc/aes.h
+++ b/lib/crypto/sparc/aes.h
@@ -33,9 +33,6 @@ EXPORT_SYMBOL_GPL(aes_sparc64_cbc_encrypt_256);
 EXPORT_SYMBOL_GPL(aes_sparc64_cbc_decrypt_128);
 EXPORT_SYMBOL_GPL(aes_sparc64_cbc_decrypt_192);
 EXPORT_SYMBOL_GPL(aes_sparc64_cbc_decrypt_256);
-EXPORT_SYMBOL_GPL(aes_sparc64_ctr_crypt_128);
-EXPORT_SYMBOL_GPL(aes_sparc64_ctr_crypt_192);
-EXPORT_SYMBOL_GPL(aes_sparc64_ctr_crypt_256);
 
 void aes_sparc64_encrypt_128(const u64 *key, const u32 *input, u32 *output);
 void aes_sparc64_encrypt_192(const u64 *key, const u32 *input, u32 *output);
@@ -156,6 +153,95 @@ static __always_inline void aes_sparc64_load_round_keys(aes_encrypt_arg key_arg,
 	}
 }
 
+/*
+ * Size of the on-stack bounce buffer used when src or dst is not 8-byte aligned
+ * (required by the SPARC64 AES assembly).  8 AES blocks (128 bytes) keeps stack
+ * usage small while remaining below 192 bytes, the lowest threshold at which
+ * any SPARC64 memcpy() implementation (U3memcpy) unconditionally enters VIS/FPU
+ * code and would clobber the round keys loaded in %f8-%f62 and clear %fprs.
+ * (NG4memcpy and M7memcpy on real crypto-capable CPUs check FPRS_FEF and fall
+ * back to integer copies, but QEMU may emulate older CPUs with +crypto.)
+ */
+#define MISALIGNED_CHUNK_SIZE (8 * AES_BLOCK_SIZE)
+
+#if IS_ENABLED(CONFIG_CRYPTO_LIB_AES_CTR)
+void aes_sparc64_ctr_crypt_128(const u64 *key, const u64 *input, u64 *output,
+			       size_t len, u64 iv[2]);
+void aes_sparc64_ctr_crypt_192(const u64 *key, const u64 *input, u64 *output,
+			       size_t len, u64 iv[2]);
+void aes_sparc64_ctr_crypt_256(const u64 *key, const u64 *input, u64 *output,
+			       size_t len, u64 iv[2]);
+
+static __always_inline void aes_sparc64_ctr_crypt(const struct aes_enckey *key,
+						  const u64 *in, u64 *out,
+						  size_t len, u64 ctr[2])
+{
+	const u64 *rk = key->k.sparc_rndkeys;
+
+	if (key->len == AES_KEYSIZE_128)
+		aes_sparc64_ctr_crypt_128(rk, in, out, len, ctr);
+	else if (key->len == AES_KEYSIZE_192)
+		aes_sparc64_ctr_crypt_192(rk, in, out, len, ctr);
+	else
+		aes_sparc64_ctr_crypt_256(rk, in, out, len, ctr);
+}
+
+/* len may be any value here. */
+#define aes_ctr_arch aes_ctr_arch
+static bool aes_ctr_arch(u8 *dst, const u8 *src, size_t len,
+			 u8 ctr[AES_BLOCK_SIZE], const struct aes_enckey *key)
+{
+	u64 aligned_ctr[2];
+
+	if (!static_branch_likely(&have_aes_opcodes))
+		return false;
+
+	if (unlikely(len == 0))
+		return true;
+
+	memcpy(aligned_ctr, ctr, sizeof(aligned_ctr));
+	aes_sparc64_load_round_keys(key, /* enc= */ true);
+	if (IS_ALIGNED((uintptr_t)src | (uintptr_t)dst, 8)) {
+		size_t blocks_len = round_down(len, AES_BLOCK_SIZE);
+
+		if (blocks_len)
+			aes_sparc64_ctr_crypt(key, (const u64 *)src, (u64 *)dst,
+					      blocks_len, aligned_ctr);
+		len -= blocks_len;
+		if (len) {
+			u64 tmp[2] = {};
+
+			memcpy(tmp, src + blocks_len, len);
+			aes_sparc64_ctr_crypt(key, tmp, tmp, AES_BLOCK_SIZE,
+					      aligned_ctr);
+			memcpy(dst + blocks_len, tmp, len);
+			memzero_explicit(tmp, sizeof(tmp));
+		}
+	} else {
+		u64 tmp[MISALIGNED_CHUNK_SIZE / sizeof(u64)];
+
+		do {
+			size_t n = min(len, sizeof(tmp));
+			size_t blocks_len = round_up(n, AES_BLOCK_SIZE);
+
+			if (unlikely(n < blocks_len))
+				memset((u8 *)tmp + n, 0, blocks_len - n);
+			memcpy(tmp, src, n);
+			aes_sparc64_ctr_crypt(key, tmp, tmp, blocks_len,
+					      aligned_ctr);
+			memcpy(dst, tmp, n);
+			src += n;
+			dst += n;
+			len -= n;
+		} while (len);
+		memzero_explicit(tmp, sizeof(tmp));
+	}
+	fprs_write(0);
+	memcpy(ctr, aligned_ctr, sizeof(aligned_ctr));
+	return true;
+}
+#endif /* CONFIG_CRYPTO_LIB_AES_CTR */
+
 #if IS_ENABLED(CONFIG_CRYPTO_LIB_AES_XTS)
 void aes_sparc64_xts_encrypt_128(const u64 *key, const u64 *input, u64 *output,
 				 size_t len, u64 tweak[2]);
diff --git a/lib/crypto/sparc/aes_asm.S b/lib/crypto/sparc/aes_asm.S
index fd90b129972fb..c95a86462b776 100644
--- a/lib/crypto/sparc/aes_asm.S
+++ b/lib/crypto/sparc/aes_asm.S
@@ -1356,6 +1356,7 @@ ENTRY(aes_sparc64_cbc_decrypt_256)
 	 nop
 ENDPROC(aes_sparc64_cbc_decrypt_256)
 
+#if IS_ENABLED(CONFIG_CRYPTO_LIB_AES_CTR)
 	.align		32
 ENTRY(aes_sparc64_ctr_crypt_128)
 	/* %o0=key, %o1=input, %o2=output, %o3=len, %o4=IV */
@@ -1363,7 +1364,7 @@ ENTRY(aes_sparc64_ctr_crypt_128)
 	ldx		[%o4 + 0x08], %g7
 	subcc		%o3, 0x10, %o3
 	ldx		[%o0 + 0x00], %g1
-	be		10f
+	be,pn		%xcc, 10f
 	 ldx		[%o0 + 0x08], %g2
 1:	xor		%g1, %g3, %o5
 	MOVXTOD_O5_F0
@@ -1424,7 +1425,7 @@ ENTRY(aes_sparc64_ctr_crypt_192)
 	ldx		[%o4 + 0x08], %g7
 	subcc		%o3, 0x10, %o3
 	ldx		[%o0 + 0x00], %g1
-	be		10f
+	be,pn		%xcc, 10f
 	 ldx		[%o0 + 0x08], %g2
 1:	xor		%g1, %g3, %o5
 	MOVXTOD_O5_F0
@@ -1485,7 +1486,7 @@ ENTRY(aes_sparc64_ctr_crypt_256)
 	ldx		[%o4 + 0x08], %g7
 	subcc		%o3, 0x10, %o3
 	ldx		[%o0 + 0x00], %g1
-	be		10f
+	be,pn		%xcc, 10f
 	 ldx		[%o0 + 0x08], %g2
 1:	xor		%g1, %g3, %o5
 	MOVXTOD_O5_F0
@@ -1542,6 +1543,7 @@ ENTRY(aes_sparc64_ctr_crypt_256)
 	retl
 	 stx		%g7, [%o4 + 0x08]
 ENDPROC(aes_sparc64_ctr_crypt_256)
+#endif /* CONFIG_CRYPTO_LIB_AES_CTR */
 
 #if IS_ENABLED(CONFIG_CRYPTO_LIB_AES_XTS)
 	/* XTS.  The tweak is kept in %l0/%l1 as little-endian words, so that
-- 
2.56.1

