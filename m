Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8F82364E98;
	Mon, 21 Sep 2026 05:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789967773; cv=none; b=h9WCuPzewQvtyDOoz2dFOeXkGBmGFfu7uCDT+bMaMAtZwkFzSkwNbKxtYbnn5qgFmY4novMIso0Scq+RLGbVK0OEwlv+emYDNvcTH2Bu5N453PkWasQJVyWXUCyINcb9yUlolXyJIvxIRUbEOOFXhbGLhpl88d4EyzuYY9/AJ+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789967773; c=relaxed/simple;
	bh=3Oix9rxWfCPGMJLQY0b6ysQ93dwLwQKQNObL47lLbsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zhly90EK7swxgiiyUV7Jlg/OFaaSjpnGWqDSYXWv/A8q6dv0/nK5GL1GGqiGXF+ar8HrkNhoBbWGjrIFb3rVTszq1rcmDGWJJVRbYCYbsUbuz8GisjaisBOhuCw2mif42sDi1kUWVfKnzeJscc/CAOdR90QVTnWCW+hPQDj4KsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iLMSvSP+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iLMSvSP+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C56B1F008A1;
	Mon, 21 Sep 2026 05:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789967769;
	bh=1rXrCsJ2jBFqqSsvzm3pQPgVrApubNgiwE9EAaJKpl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iLMSvSP+hsDozBuQYXP0wdq5wiw3kG4EQ5otrQB8aIyQlyO6zoT1k6SafjV+cw3m6
	 6N86uX9mSqp40btGQ7PaFBulg+sdHQdvRqxi/qzE83Gn4kUCSHwTuPxa4TsyTaohgi
	 hL6eeBOY4NfwFtxg7ZVW9LBRaQTdfSAdlL9UG+mEzbaH09meRm4OElxLde0UBfCX6f
	 0vwbcGo3QgvkMm+3htI4JgebrJWK54USFIGEMgqh5VW0TB3GHQZfrqmqez2/NI38nT
	 d6p2h4G0QaVDJDGBbtZzMx6dSE5jYg7dSbmWVrRA2C6s+HNmYSgKUMEPbbwu7gVkeC
	 blPlCqf+waU0g==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org,
	linux-riscv@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 17/20] lib/crypto: riscv/aes-ecb: Migrate optimized code into library
Date: Sun, 20 Sep 2026 22:09:03 -0700
Message-ID: <20260921050910.296144-18-ebiggers@kernel.org>
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

Instead of exposing the riscv-optimized AES-ECB code via a
riscv-specific crypto_skcipher algorithm, just implement the AES-ECB
library functions.  This is simpler, it makes the AES-ECB library
functions be riscv-optimized, and it also fixes the longstanding issue
where the riscv-optimized AES-ECB code was disabled by default.  AES-ECB
support still remains available through crypto_skcipher via
crypto/aes.c, but individual architectures no longer need to handle it.

To match what the library expects, update the assembly functions to
operate on struct aes_enckey or struct aes_key rather than struct
crypto_aes_ctx, and adjust the argument order.

Bump up the priority of the corresponding library-based algorithm on
riscv now that it no longer has to be lower than arch/riscv/crypto/.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/riscv/crypto/Kconfig              |  4 +-
 arch/riscv/crypto/aes-riscv64-glue.c   | 61 +-------------------------
 arch/riscv/crypto/aes-riscv64-zvkned.S | 39 ----------------
 crypto/aes.c                           |  3 +-
 lib/crypto/riscv/aes-riscv64-zvkned.S  | 51 +++++++++++++++++++++
 lib/crypto/riscv/aes.h                 | 33 ++++++++++++++
 6 files changed, 89 insertions(+), 102 deletions(-)

diff --git a/arch/riscv/crypto/Kconfig b/arch/riscv/crypto/Kconfig
index 6905232ddb03..84c41824b433 100644
--- a/arch/riscv/crypto/Kconfig
+++ b/arch/riscv/crypto/Kconfig
@@ -3,13 +3,13 @@
 menu "Accelerated Cryptographic Algorithms for CPU (riscv)"
 
 config CRYPTO_AES_RISCV64
-	tristate "Ciphers: AES, modes: ECB, CBC, CTS, CTR, XTS"
+	tristate "Ciphers: AES, modes: CBC, CTS, CTR, XTS"
 	depends on 64BIT && TOOLCHAIN_HAS_VECTOR_CRYPTO && \
 		   RISCV_EFFICIENT_VECTOR_UNALIGNED_ACCESS
 	select CRYPTO_LIB_AES
 	select CRYPTO_SKCIPHER
 	help
-	  Length-preserving ciphers: AES with ECB, CBC, CTS, CTR, XTS
+	  Length-preserving ciphers: AES with CBC, CTS, CTR, XTS
 
 	  Architecture: riscv64 using:
 	  - Zvkned vector crypto extension
diff --git a/arch/riscv/crypto/aes-riscv64-glue.c b/arch/riscv/crypto/aes-riscv64-glue.c
index bbd920c9e29d..f7c492dcfd57 100644
--- a/arch/riscv/crypto/aes-riscv64-glue.c
+++ b/arch/riscv/crypto/aes-riscv64-glue.c
@@ -22,11 +22,6 @@
 #include <linux/minmax.h>
 #include <linux/module.h>
 
-asmlinkage void aes_ecb_encrypt_zvkned(const struct crypto_aes_ctx *key,
-				       const u8 *in, u8 *out, size_t len);
-asmlinkage void aes_ecb_decrypt_zvkned(const struct crypto_aes_ctx *key,
-				       const u8 *in, u8 *out, size_t len);
-
 asmlinkage void aes_cbc_encrypt_zvkned(const struct crypto_aes_ctx *key,
 				       const u8 *in, u8 *out, size_t len,
 				       u8 iv[AES_BLOCK_SIZE]);
@@ -86,44 +81,6 @@ static int riscv64_aes_setkey_skcipher(struct crypto_skcipher *tfm,
 	return riscv64_aes_setkey(ctx, key, keylen);
 }
 
-/* AES-ECB */
-
-static inline int riscv64_aes_ecb_crypt(struct skcipher_request *req, bool enc)
-{
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	const struct crypto_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct skcipher_walk walk;
-	unsigned int nbytes;
-	int err;
-
-	err = skcipher_walk_virt(&walk, req, false);
-	while ((nbytes = walk.nbytes) != 0) {
-		kernel_vector_begin();
-		if (enc)
-			aes_ecb_encrypt_zvkned(ctx, walk.src.virt.addr,
-					       walk.dst.virt.addr,
-					       nbytes & ~(AES_BLOCK_SIZE - 1));
-		else
-			aes_ecb_decrypt_zvkned(ctx, walk.src.virt.addr,
-					       walk.dst.virt.addr,
-					       nbytes & ~(AES_BLOCK_SIZE - 1));
-		kernel_vector_end();
-		err = skcipher_walk_done(&walk, nbytes & (AES_BLOCK_SIZE - 1));
-	}
-
-	return err;
-}
-
-static int riscv64_aes_ecb_encrypt(struct skcipher_request *req)
-{
-	return riscv64_aes_ecb_crypt(req, true);
-}
-
-static int riscv64_aes_ecb_decrypt(struct skcipher_request *req)
-{
-	return riscv64_aes_ecb_crypt(req, false);
-}
-
 /* AES-CBC */
 
 static int riscv64_aes_cbc_crypt(struct skcipher_request *req, bool enc)
@@ -411,21 +368,6 @@ static int riscv64_aes_xts_decrypt(struct skcipher_request *req)
 
 static struct skcipher_alg riscv64_zvkned_aes_skcipher_algs[] = {
 	{
-		.setkey = riscv64_aes_setkey_skcipher,
-		.encrypt = riscv64_aes_ecb_encrypt,
-		.decrypt = riscv64_aes_ecb_decrypt,
-		.min_keysize = AES_MIN_KEY_SIZE,
-		.max_keysize = AES_MAX_KEY_SIZE,
-		.walksize = 8 * AES_BLOCK_SIZE, /* matches LMUL=8 */
-		.base = {
-			.cra_blocksize = AES_BLOCK_SIZE,
-			.cra_ctxsize = sizeof(struct crypto_aes_ctx),
-			.cra_priority = 300,
-			.cra_name = "ecb(aes)",
-			.cra_driver_name = "ecb-aes-riscv64-zvkned",
-			.cra_module = THIS_MODULE,
-		},
-	}, {
 		.setkey = riscv64_aes_setkey_skcipher,
 		.encrypt = riscv64_aes_cbc_encrypt,
 		.decrypt = riscv64_aes_cbc_decrypt,
@@ -555,11 +497,10 @@ static void __exit riscv64_aes_mod_exit(void)
 module_init(riscv64_aes_mod_init);
 module_exit(riscv64_aes_mod_exit);
 
-MODULE_DESCRIPTION("AES-ECB/CBC/CTS/CTR/XTS (RISC-V accelerated)");
+MODULE_DESCRIPTION("AES-CBC/CTS/CTR/XTS (RISC-V accelerated)");
 MODULE_AUTHOR("Jerry Shih <jerry.shih@sifive.com>");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_CRYPTO("aes");
-MODULE_ALIAS_CRYPTO("ecb(aes)");
 MODULE_ALIAS_CRYPTO("cbc(aes)");
 MODULE_ALIAS_CRYPTO("cts(cbc(aes))");
 MODULE_ALIAS_CRYPTO("ctr(aes)");
diff --git a/arch/riscv/crypto/aes-riscv64-zvkned.S b/arch/riscv/crypto/aes-riscv64-zvkned.S
index d0fc4581a380..00f8a06596d3 100644
--- a/arch/riscv/crypto/aes-riscv64-zvkned.S
+++ b/arch/riscv/crypto/aes-riscv64-zvkned.S
@@ -56,45 +56,6 @@
 #define LEN		a3
 #define IVP		a4
 
-.macro	__aes_ecb_crypt	enc, keylen
-	srli		t0, LEN, 2
-	// t0 is the remaining length in 32-bit words.  It's a multiple of 4.
-1:
-	vsetvli		t1, t0, e32, m8, ta, ma
-	sub		t0, t0, t1	// Subtract number of words processed
-	slli		t1, t1, 2	// Words to bytes
-	vle32.v		v16, (INP)
-	aes_crypt	v16, \enc, \keylen
-	vse32.v		v16, (OUTP)
-	add		INP, INP, t1
-	add		OUTP, OUTP, t1
-	bnez		t0, 1b
-
-	ret
-.endm
-
-.macro	aes_ecb_crypt	enc
-	aes_begin	KEYP, 128f, 192f
-	__aes_ecb_crypt	\enc, 256
-128:
-	__aes_ecb_crypt	\enc, 128
-192:
-	__aes_ecb_crypt	\enc, 192
-.endm
-
-// void aes_ecb_encrypt_zvkned(const struct crypto_aes_ctx *key,
-//			       const u8 *in, u8 *out, size_t len);
-//
-// |len| must be nonzero and a multiple of 16 (AES_BLOCK_SIZE).
-SYM_FUNC_START(aes_ecb_encrypt_zvkned)
-	aes_ecb_crypt	1
-SYM_FUNC_END(aes_ecb_encrypt_zvkned)
-
-// Same prototype and calling convention as the encryption function
-SYM_FUNC_START(aes_ecb_decrypt_zvkned)
-	aes_ecb_crypt	0
-SYM_FUNC_END(aes_ecb_decrypt_zvkned)
-
 .macro	aes_cbc_encrypt	keylen
 	vle32.v		v16, (IVP)	// Load IV
 1:
diff --git a/crypto/aes.c b/crypto/aes.c
index c19234f8a31c..0e72351d7f71 100644
--- a/crypto/aes.c
+++ b/crypto/aes.c
@@ -610,7 +610,8 @@ static struct skcipher_alg skcipher_algs[] = {
 	{
 		.base.cra_name = "ecb(aes)",
 		.base.cra_driver_name = "ecb-aes-lib",
-		.base.cra_priority = IS_ENABLED(CONFIG_X86) ? 300 : 110,
+		.base.cra_priority = (IS_ENABLED(CONFIG_RISCV) ||
+				      IS_ENABLED(CONFIG_X86)) ? 300 : 110,
 		.base.cra_blocksize = AES_BLOCK_SIZE,
 		.base.cra_ctxsize = sizeof(struct aes_key),
 		.base.cra_module = THIS_MODULE,
diff --git a/lib/crypto/riscv/aes-riscv64-zvkned.S b/lib/crypto/riscv/aes-riscv64-zvkned.S
index 374fc4dba11b..b722bc90fd30 100644
--- a/lib/crypto/riscv/aes-riscv64-zvkned.S
+++ b/lib/crypto/riscv/aes-riscv64-zvkned.S
@@ -81,3 +81,54 @@ SYM_FUNC_END(aes_encrypt_zvkned)
 SYM_FUNC_START(aes_decrypt_zvkned)
 	aes_crypt_zvkned	0
 SYM_FUNC_END(aes_decrypt_zvkned)
+
+#undef KEYP
+#undef OUTP
+#undef INP
+
+#define DST	a0
+#define SRC	a1
+#define LEN	a2
+#define KEYP	a3
+
+.macro	__aes_ecb_crypt	enc, keylen
+	srli		t0, LEN, 2
+	// t0 is the remaining length in 32-bit words.  It's a multiple of 4.
+1:
+	vsetvli		t1, t0, e32, m8, ta, ma
+	sub		t0, t0, t1	// Subtract number of words processed
+	slli		t1, t1, 2	// Words to bytes
+	vle32.v		v16, (SRC)
+	aes_crypt	v16, \enc, \keylen
+	vse32.v		v16, (DST)
+	add		SRC, SRC, t1
+	add		DST, DST, t1
+	bnez		t0, 1b
+
+	ret
+.endm
+
+.macro	aes_ecb_crypt	enc
+	aes_begin	KEYP, 128f, 192f
+	__aes_ecb_crypt	\enc, 256
+128:
+	__aes_ecb_crypt	\enc, 128
+192:
+	__aes_ecb_crypt	\enc, 192
+.endm
+
+// void aes_ecb_encrypt_zvkned(u8 *dst, const u8 *src, size_t len,
+//			       const struct aes_enckey *key);
+//
+// |len| must be nonzero and a multiple of 16 (AES_BLOCK_SIZE).
+SYM_FUNC_START(aes_ecb_encrypt_zvkned)
+	aes_ecb_crypt	1
+SYM_FUNC_END(aes_ecb_encrypt_zvkned)
+
+// void aes_ecb_decrypt_zvkned(u8 *dst, const u8 *src, size_t len,
+//			       const struct aes_key *key);
+//
+// |len| must be nonzero and a multiple of 16 (AES_BLOCK_SIZE).
+SYM_FUNC_START(aes_ecb_decrypt_zvkned)
+	aes_ecb_crypt	0
+SYM_FUNC_END(aes_ecb_decrypt_zvkned)
diff --git a/lib/crypto/riscv/aes.h b/lib/crypto/riscv/aes.h
index a288b4c5b493..f97d27fa5985 100644
--- a/lib/crypto/riscv/aes.h
+++ b/lib/crypto/riscv/aes.h
@@ -58,6 +58,39 @@ static void aes_decrypt_arch(const struct aes_key *key,
 	}
 }
 
+#if IS_ENABLED(CONFIG_CRYPTO_LIB_AES_ECB)
+void aes_ecb_encrypt_zvkned(u8 *dst, const u8 *src, size_t len,
+			    const struct aes_enckey *key);
+void aes_ecb_decrypt_zvkned(u8 *dst, const u8 *src, size_t len,
+			    const struct aes_key *key);
+
+/* len is always a positive multiple of AES_BLOCK_SIZE here. */
+#define aes_ecb_encrypt_arch aes_ecb_encrypt_arch
+static bool aes_ecb_encrypt_arch(u8 *dst, const u8 *src, size_t len,
+				 const struct aes_enckey *key)
+{
+	if (!static_branch_likely(&have_zvkned) || unlikely(!may_use_simd()))
+		return false;
+	kernel_vector_begin();
+	aes_ecb_encrypt_zvkned(dst, src, len, key);
+	kernel_vector_end();
+	return true;
+}
+
+/* len is always a positive multiple of AES_BLOCK_SIZE here. */
+#define aes_ecb_decrypt_arch aes_ecb_decrypt_arch
+static bool aes_ecb_decrypt_arch(u8 *dst, const u8 *src, size_t len,
+				 const struct aes_key *key)
+{
+	if (!static_branch_likely(&have_zvkned) || unlikely(!may_use_simd()))
+		return false;
+	kernel_vector_begin();
+	aes_ecb_decrypt_zvkned(dst, src, len, key);
+	kernel_vector_end();
+	return true;
+}
+#endif /* CONFIG_CRYPTO_LIB_AES_ECB */
+
 #define aes_mod_init_arch aes_mod_init_arch
 static void aes_mod_init_arch(void)
 {
-- 
2.55.0

