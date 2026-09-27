Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F510443E56;
	Sun, 27 Sep 2026 22:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790549088; cv=none; b=tc/ulO/u7Nsh9r1U0t5GNnZS/fGXQKm/OFsCsVeqD5C+e9cwjbQUYou7zcss2LeDpZ4vM8Rm7crIpWE02Ef+tC5wKld71h/lCK3ti+HcRH+aHuedusbqJGQCmrlxztY787UbmxjzVUnKEMNQtu08KZJoVx7oHyZGAXlOtOCXzTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790549088; c=relaxed/simple;
	bh=j6nhMm9AqTPYbL0jmB6CW8ZZbqV64b3SpwzRO4T4GKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VEgtxYcR2cx41qEEG0wF3iu97G5pJIqoZjZCbzn6DqJSlD9oB4MqUpF0ArEB6jDQVPIWGfbcKH54yOCmGhY1OsrMvT6JPsbnf3GQNBne9Rg04MNTE1B16Dhn4XLQj9Uo3x2/0G2Ul00UuajHYY/5uqW5sHMAoR1Tb3WR3roBnF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UT6rv67M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UT6rv67M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D25A11F00899;
	Sun, 27 Sep 2026 22:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790549086;
	bh=/b4bmz0NZboPlEa5qyblJ8JERsWxab+3vydUZD9cnzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UT6rv67M57GGEVvMbefbbN4z1SRcfAVpe8QQnGMYzYGFalOxa5EwdbvI3VQH/f+cV
	 rd/7WLTG7k0+puMzxsO3h5yzEAH9tBraVHx3k0LkETyOCxGPTBm15LcED2OBvs/4cV
	 eHqvR+4XIbqUTdCMr1nwkjoGSSLYTJJwYVtXzxX+1Rcb9jN35BCPXLOOi3wbVkvCTY
	 Y+63zHC1mK4k1WC+304JXAuTU7pUI1sMDAoWQwESLovpKl7cM/rbe2ZoQvBNPSj/Z3
	 klgjvIoewDBb3PAqBc85v9wT80X9yBQ5SDrA/MKq3Z0XAJj/TSZ2l+N2F6APGFaelX
	 llYo1mu37NEng==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org,
	linux-riscv@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 19/20] lib/crypto: riscv/aes-ctr: Migrate optimized code into library
Date: Sun, 27 Sep 2026 15:43:10 -0700
Message-ID: <20260927224418.109759-20-ebiggers@kernel.org>
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

Instead of exposing the riscv-optimized AES-CTR code via a
riscv-specific crypto_skcipher algorithm, just implement the AES-CTR
library functions.  This is simpler, it makes the AES-CTR library
functions be riscv-optimized, and it also fixes the longstanding issue
where the riscv-optimized AES-CTR code was disabled by default.  AES-CTR
support still remains available through crypto_skcipher via
crypto/aes.c, but individual architectures no longer need to handle it.

To match what the library expects, update the assembly functions to
operate on struct aes_enckey rather than struct crypto_aes_ctx, and
adjust the argument order.

Bump up the priority of the corresponding library-based algorithm on
riscv now that it no longer has to be lower than arch/riscv/crypto/.
Also re-enable the library-based "ccm(aes)" and "gcm(aes)".

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/riscv/crypto/Kconfig                     |   5 +-
 arch/riscv/crypto/Makefile                    |   2 +-
 arch/riscv/crypto/aes-riscv64-glue.c          | 114 +-----------------
 crypto/aes.c                                  |   5 +-
 lib/crypto/Makefile                           |   4 +
 .../crypto/riscv}/aes-riscv64-zvkned-zvkb.S   |  23 ++--
 lib/crypto/riscv/aes.h                        |  72 ++++++++++-
 7 files changed, 94 insertions(+), 131 deletions(-)
 rename {arch/riscv/crypto => lib/crypto/riscv}/aes-riscv64-zvkned-zvkb.S (93%)

diff --git a/arch/riscv/crypto/Kconfig b/arch/riscv/crypto/Kconfig
index 0a3f87ad384e..0733d4894401 100644
--- a/arch/riscv/crypto/Kconfig
+++ b/arch/riscv/crypto/Kconfig
@@ -3,18 +3,17 @@
 menu "Accelerated Cryptographic Algorithms for CPU (riscv)"
 
 config CRYPTO_AES_RISCV64
-	tristate "Ciphers: AES, modes: CTR, XTS"
+	tristate "Ciphers: AES, modes: XTS"
 	depends on 64BIT && TOOLCHAIN_HAS_VECTOR_CRYPTO && \
 		   RISCV_EFFICIENT_VECTOR_UNALIGNED_ACCESS
 	select CRYPTO_LIB_AES
 	select CRYPTO_SKCIPHER
 	help
-	  Length-preserving ciphers: AES with CTR, XTS
+	  Length-preserving ciphers: AES with XTS
 
 	  Architecture: riscv64 using:
 	  - Zvkned vector crypto extension
 	  - Zvbb vector extension (XTS)
-	  - Zvkb vector crypto extension (CTR)
 	  - Zvkg vector crypto extension (XTS)
 
 config CRYPTO_SM4_RISCV64
diff --git a/arch/riscv/crypto/Makefile b/arch/riscv/crypto/Makefile
index d8b85afa6d0b..08904603fc94 100644
--- a/arch/riscv/crypto/Makefile
+++ b/arch/riscv/crypto/Makefile
@@ -2,7 +2,7 @@
 
 obj-$(CONFIG_CRYPTO_AES_RISCV64) += aes-riscv64.o
 aes-riscv64-y := aes-riscv64-glue.o \
-		 aes-riscv64-zvkned-zvbb-zvkg.o aes-riscv64-zvkned-zvkb.o
+		 aes-riscv64-zvkned-zvbb-zvkg.o
 
 obj-$(CONFIG_CRYPTO_SM4_RISCV64) += sm4-riscv64.o
 sm4-riscv64-y := sm4-riscv64-glue.o sm4-riscv64-zvksed-zvkb.o
diff --git a/arch/riscv/crypto/aes-riscv64-glue.c b/arch/riscv/crypto/aes-riscv64-glue.c
index 97f5369d7e71..a7dcceb77c49 100644
--- a/arch/riscv/crypto/aes-riscv64-glue.c
+++ b/arch/riscv/crypto/aes-riscv64-glue.c
@@ -22,10 +22,6 @@
 #include <linux/minmax.h>
 #include <linux/module.h>
 
-asmlinkage void aes_ctr32_crypt_zvkned_zvkb(const struct crypto_aes_ctx *key,
-					    const u8 *in, u8 *out, size_t len,
-					    u8 iv[AES_BLOCK_SIZE]);
-
 asmlinkage void aes_xts_encrypt_zvkned_zvbb_zvkg(
 			const struct crypto_aes_ctx *key,
 			const u8 *in, u8 *out, size_t len,
@@ -62,75 +58,6 @@ static int riscv64_aes_setkey(struct crypto_aes_ctx *ctx,
 	return aes_expandkey(ctx, key, keylen);
 }
 
-static int riscv64_aes_setkey_skcipher(struct crypto_skcipher *tfm,
-				       const u8 *key, unsigned int keylen)
-{
-	struct crypto_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
-
-	return riscv64_aes_setkey(ctx, key, keylen);
-}
-
-/* AES-CTR */
-
-static int riscv64_aes_ctr_crypt(struct skcipher_request *req)
-{
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	const struct crypto_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
-	unsigned int nbytes, p1_nbytes;
-	struct skcipher_walk walk;
-	u32 ctr32, nblocks;
-	int err;
-
-	/* Get the low 32-bit word of the 128-bit big endian counter. */
-	ctr32 = get_unaligned_be32(req->iv + 12);
-
-	err = skcipher_walk_virt(&walk, req, false);
-	while ((nbytes = walk.nbytes) != 0) {
-		if (nbytes < walk.total) {
-			/* Not the end yet, so keep the length block-aligned. */
-			nbytes = round_down(nbytes, AES_BLOCK_SIZE);
-			nblocks = nbytes / AES_BLOCK_SIZE;
-		} else {
-			/* It's the end, so include any final partial block. */
-			nblocks = DIV_ROUND_UP(nbytes, AES_BLOCK_SIZE);
-		}
-		ctr32 += nblocks;
-
-		kernel_vector_begin();
-		if (ctr32 >= nblocks) {
-			/* The low 32-bit word of the counter won't overflow. */
-			aes_ctr32_crypt_zvkned_zvkb(ctx, walk.src.virt.addr,
-						    walk.dst.virt.addr, nbytes,
-						    req->iv);
-		} else {
-			/*
-			 * The low 32-bit word of the counter will overflow.
-			 * The assembly doesn't handle this case, so split the
-			 * operation into two at the point where the overflow
-			 * will occur.  After the first part, add the carry bit.
-			 */
-			p1_nbytes = min(nbytes, (nblocks - ctr32) * AES_BLOCK_SIZE);
-			aes_ctr32_crypt_zvkned_zvkb(ctx, walk.src.virt.addr,
-						    walk.dst.virt.addr,
-						    p1_nbytes, req->iv);
-			crypto_inc(req->iv, 12);
-
-			if (ctr32) {
-				aes_ctr32_crypt_zvkned_zvkb(
-					ctx,
-					walk.src.virt.addr + p1_nbytes,
-					walk.dst.virt.addr + p1_nbytes,
-					nbytes - p1_nbytes, req->iv);
-			}
-		}
-		kernel_vector_end();
-
-		err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
-	}
-
-	return err;
-}
-
 /* AES-XTS */
 
 struct riscv64_aes_xts_ctx {
@@ -251,25 +178,6 @@ static int riscv64_aes_xts_decrypt(struct skcipher_request *req)
 
 /* Algorithm definitions */
 
-static struct skcipher_alg riscv64_zvkned_zvkb_aes_skcipher_alg = {
-	.setkey = riscv64_aes_setkey_skcipher,
-	.encrypt = riscv64_aes_ctr_crypt,
-	.decrypt = riscv64_aes_ctr_crypt,
-	.min_keysize = AES_MIN_KEY_SIZE,
-	.max_keysize = AES_MAX_KEY_SIZE,
-	.ivsize = AES_BLOCK_SIZE,
-	.chunksize = AES_BLOCK_SIZE,
-	.walksize = 4 * AES_BLOCK_SIZE, /* matches LMUL=4 */
-	.base = {
-		.cra_blocksize = 1,
-		.cra_ctxsize = sizeof(struct crypto_aes_ctx),
-		.cra_priority = 300,
-		.cra_name = "ctr(aes)",
-		.cra_driver_name = "ctr-aes-riscv64-zvkned-zvkb",
-		.cra_module = THIS_MODULE,
-	},
-};
-
 static struct skcipher_alg riscv64_zvkned_zvbb_zvkg_aes_skcipher_alg = {
 	.setkey = riscv64_aes_xts_setkey,
 	.encrypt = riscv64_aes_xts_encrypt,
@@ -302,43 +210,27 @@ static int __init riscv64_aes_mod_init(void)
 
 	if (riscv_isa_extension_available(NULL, ZVKNED) &&
 	    riscv_vector_vlen() >= 128) {
-		if (riscv_isa_extension_available(NULL, ZVKB)) {
-			err = crypto_register_skcipher(
-				&riscv64_zvkned_zvkb_aes_skcipher_alg);
-			if (err)
-				return err;
-		}
-
 		if (riscv64_aes_xts_supported()) {
 			err = crypto_register_skcipher(
 				&riscv64_zvkned_zvbb_zvkg_aes_skcipher_alg);
 			if (err)
-				goto unregister_zvkned_zvkb_skcipher_alg;
+				return err;
 		}
 	}
 
 	return err;
-
-unregister_zvkned_zvkb_skcipher_alg:
-	if (riscv_isa_extension_available(NULL, ZVKB))
-		crypto_unregister_skcipher(&riscv64_zvkned_zvkb_aes_skcipher_alg);
-	return err;
 }
 
 static void __exit riscv64_aes_mod_exit(void)
 {
-	if (riscv64_aes_xts_supported())
-		crypto_unregister_skcipher(&riscv64_zvkned_zvbb_zvkg_aes_skcipher_alg);
-	if (riscv_isa_extension_available(NULL, ZVKB))
-		crypto_unregister_skcipher(&riscv64_zvkned_zvkb_aes_skcipher_alg);
+	crypto_unregister_skcipher(&riscv64_zvkned_zvbb_zvkg_aes_skcipher_alg);
 }
 
 module_init(riscv64_aes_mod_init);
 module_exit(riscv64_aes_mod_exit);
 
-MODULE_DESCRIPTION("AES-CTR/XTS (RISC-V accelerated)");
+MODULE_DESCRIPTION("AES-XTS (RISC-V accelerated)");
 MODULE_AUTHOR("Jerry Shih <jerry.shih@sifive.com>");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_CRYPTO("aes");
-MODULE_ALIAS_CRYPTO("ctr(aes)");
 MODULE_ALIAS_CRYPTO("xts(aes)");
diff --git a/crypto/aes.c b/crypto/aes.c
index 1daaa59d0cdf..1b84953c5deb 100644
--- a/crypto/aes.c
+++ b/crypto/aes.c
@@ -670,7 +670,8 @@ static struct skcipher_alg skcipher_algs[] = {
 	{
 		.base.cra_name = "ctr(aes)",
 		.base.cra_driver_name = "ctr-aes-lib",
-		.base.cra_priority = IS_ENABLED(CONFIG_X86) ? 300 : 110,
+		.base.cra_priority = (IS_ENABLED(CONFIG_RISCV) ||
+				      IS_ENABLED(CONFIG_X86)) ? 300 : 110,
 		.base.cra_blocksize = 1,
 		.base.cra_ctxsize = sizeof(struct aes_enckey),
 		.base.cra_module = THIS_MODULE,
@@ -1002,7 +1003,6 @@ static struct aead_alg aead_algs[] = {
 	!(IS_ENABLED(CONFIG_ARM) || \
 	  IS_ENABLED(CONFIG_ARM64) || \
 	  IS_ENABLED(CONFIG_PPC) || \
-	  IS_ENABLED(CONFIG_RISCV) || \
 	  IS_ENABLED(CONFIG_S390) || \
 	  IS_ENABLED(CONFIG_SPARC))
 	{
@@ -1045,7 +1045,6 @@ static struct aead_alg aead_algs[] = {
 	!(IS_ENABLED(CONFIG_ARM) || \
 	  IS_ENABLED(CONFIG_ARM64) || \
 	  IS_ENABLED(CONFIG_PPC) || \
-	  IS_ENABLED(CONFIG_RISCV) || \
 	  IS_ENABLED(CONFIG_S390) || \
 	  IS_ENABLED(CONFIG_SPARC))
 	{
diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
index 02d89a226377..ff34aeda37ba 100644
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -51,6 +51,10 @@ endif # !CONFIG_SPE
 endif # CONFIG_PPC
 
 libaes-$(CONFIG_RISCV) += riscv/aes-riscv64-zvkned.o
+ifneq ($(CONFIG_CRYPTO_LIB_AES_CTR),)
+libaes-$(CONFIG_RISCV) += riscv/aes-riscv64-zvkned-zvkb.o
+endif
+
 libaes-$(CONFIG_SPARC) += sparc/aes_asm.o
 
 libaes-$(CONFIG_X86) += x86/aes-aesni.o
diff --git a/arch/riscv/crypto/aes-riscv64-zvkned-zvkb.S b/lib/crypto/riscv/aes-riscv64-zvkned-zvkb.S
similarity index 93%
rename from arch/riscv/crypto/aes-riscv64-zvkned-zvkb.S
rename to lib/crypto/riscv/aes-riscv64-zvkned-zvkb.S
index 9962d4500587..2981d8182de6 100644
--- a/arch/riscv/crypto/aes-riscv64-zvkned-zvkb.S
+++ b/lib/crypto/riscv/aes-riscv64-zvkned-zvkb.S
@@ -49,11 +49,11 @@
 
 #include "aes-macros.S"
 
-#define KEYP		a0
-#define INP		a1
-#define OUTP		a2
-#define LEN		a3
-#define IVP		a4
+#define DST		a0
+#define SRC		a1
+#define LEN		a2
+#define IVP		a3
+#define KEYP		a4
 
 #define LEN32		a5
 #define VL_E32		a6
@@ -110,13 +110,13 @@
 
 	// XOR the data with the keystream.
 	vsetvli		t0, LEN, e8, m4, ta, ma
-	vle8.v		v20, (INP)
+	vle8.v		v20, (SRC)
 	vxor.vv		v20, v20, v24
-	vse8.v		v20, (OUTP)
+	vse8.v		v20, (DST)
 
 	// Advance the pointers and update the remaining length.
-	add		INP, INP, t0
-	add		OUTP, OUTP, t0
+	add		SRC, SRC, t0
+	add		DST, DST, t0
 	sub		LEN, LEN, t0
 	sub		LEN32, LEN32, VL_E32
 	srli		VL_BLOCKS, VL_E32, 2
@@ -133,9 +133,8 @@
 	ret
 .endm
 
-// void aes_ctr32_crypt_zvkned_zvkb(const struct crypto_aes_ctx *key,
-//				    const u8 *in, u8 *out, size_t len,
-//				    u8 iv[16]);
+// void aes_ctr32_crypt_zvkned_zvkb(u8 *dst, const u8 *src, size_t len,
+//				    u8 iv[16], const struct aes_enckey *key);
 SYM_FUNC_START(aes_ctr32_crypt_zvkned_zvkb)
 	aes_begin	KEYP, 128f, 192f
 	aes_ctr32_crypt	256
diff --git a/lib/crypto/riscv/aes.h b/lib/crypto/riscv/aes.h
index 150cda82cb89..c04e04cf7019 100644
--- a/lib/crypto/riscv/aes.h
+++ b/lib/crypto/riscv/aes.h
@@ -9,6 +9,7 @@
 #include <asm/vector.h>
 
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_zvkned);
+static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_zvkned_zvkb);
 
 /* The assembly code assumes the following offsets. */
 static_assert(offsetof(struct aes_enckey, len) == 0);
@@ -161,10 +162,79 @@ static bool aes_cbc_cts_decrypt_arch(u8 *dst, const u8 *src, size_t len,
 }
 #endif /* CONFIG_CRYPTO_LIB_AES_CBC */
 
+#if IS_ENABLED(CONFIG_CRYPTO_LIB_AES_CTR)
+void aes_ctr32_crypt_zvkned_zvkb(u8 *dst, const u8 *src, size_t len, u8 iv[16],
+				 const struct aes_enckey *key);
+
+static void aes_ctr_riscv(u8 *dst, const u8 *src, size_t len,
+			  u8 ctr[AES_BLOCK_SIZE], const struct aes_enckey *key)
+{
+	u32 ctr32 = get_unaligned_be32(&ctr[12]);
+	u32 nblocks;
+	size_t part1_len;
+
+	/* This assumes len <= U32_MAX * AES_BLOCK_SIZE. */
+	nblocks = DIV_ROUND_UP(len, AES_BLOCK_SIZE);
+	ctr32 += nblocks;
+
+	if (likely(ctr32 >= nblocks)) {
+		/* The low 32 bits of the counter won't overflow. */
+		aes_ctr32_crypt_zvkned_zvkb(dst, src, len, ctr, key);
+	} else {
+		/*
+		 * The low 32 bits of the counter will overflow.  The
+		 * assembly doesn't handle this case, so split the
+		 * operation into two at the point where the overflow
+		 * will occur.  After the first part, add the carry bit.
+		 */
+		part1_len =
+			min(len, (size_t)(nblocks - ctr32) * AES_BLOCK_SIZE);
+		aes_ctr32_crypt_zvkned_zvkb(dst, src, part1_len, ctr, key);
+		for (int i = AES_BLOCK_SIZE - 5; i >= 0; i--) {
+			if (++ctr[i] != 0)
+				break;
+		}
+		if (part1_len < len)
+			aes_ctr32_crypt_zvkned_zvkb(dst + part1_len,
+						    src + part1_len,
+						    len - part1_len, ctr, key);
+	}
+}
+
+#define aes_ctr_arch aes_ctr_arch
+static bool aes_ctr_arch(u8 *dst, const u8 *src, size_t len,
+			 u8 ctr[AES_BLOCK_SIZE], const struct aes_enckey *key)
+{
+	if (!static_branch_likely(&have_zvkned_zvkb) ||
+	    unlikely(!may_use_simd()))
+		return false;
+	kernel_vector_begin();
+	while (len) {
+		/*
+		 * Split super long messages into chunks that each need at most
+		 * 1 carry bit out of the low 32-bit word of the counter.  Up to
+		 * U32_MAX * AES_BLOCK_SIZE bytes could be allowed per chunk,
+		 * but use a lower limit to guard against other errors.
+		 */
+		size_t n = min(len, round_down(S32_MAX, 32 * AES_BLOCK_SIZE));
+
+		aes_ctr_riscv(dst, src, n, ctr, key);
+		dst += n;
+		src += n;
+		len -= n;
+	}
+	kernel_vector_end();
+	return true;
+}
+#endif /* CONFIG_CRYPTO_LIB_AES_CTR */
+
 #define aes_mod_init_arch aes_mod_init_arch
 static void aes_mod_init_arch(void)
 {
 	if (riscv_isa_extension_available(NULL, ZVKNED) &&
-	    riscv_vector_vlen() >= 128)
+	    riscv_vector_vlen() >= 128) {
 		static_branch_enable(&have_zvkned);
+		if (riscv_isa_extension_available(NULL, ZVKB))
+			static_branch_enable(&have_zvkned_zvkb);
+	}
 }
-- 
2.55.0

