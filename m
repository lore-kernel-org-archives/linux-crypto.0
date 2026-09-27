Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC55142254A;
	Sun, 27 Sep 2026 22:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790549083; cv=none; b=m11chms4RZwsRFIUQ4IYOyufP0prc7/GWB8t4TFKdVN+98bAhQJ0AUMXHZ4lyC1TZJxdBxKhUtFpzO4uGVpp3OpaZWs/6LudCBducGkQgnt4DNHz7ulkL45dIeJkcifHBiIYe6JugVIhpZLgsfBwV2v3VAuZrHQTMK4g/2XMd8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790549083; c=relaxed/simple;
	bh=xSpyF+XabvBfRJFcH9KPRkrrqH3q6VPigcY5K8PkQ9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dNOwkLkn+NmXpu3OiaiDii7GmlVp8sNl6RsBOsHVvisZq9OH7quI+0zCiylxEan3m20oqKw8SiHHUy345bpElsRGAaGl0B1LGSdqd1gW0PwoE/4SXo3lCubAHx8m/+wow4c93d0e9K8iRvcrs9ch7bEKOCD+d0ZWj5UTyGLskZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nZTMJI7Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nZTMJI7Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A89D1F00898;
	Sun, 27 Sep 2026 22:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790549081;
	bh=jqVeure4QdTfa5m7/8wPehOSwHOaHKhaYgPAEZYhP70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nZTMJI7QgPARd+ANoaQDmervY2LlsKBJ1ILmcc8BVV6ombd3hQTR7ShA4u/lXfc6n
	 lPyCDL7ht5oxsMaadHYN8b14HCDeXxQXloghdsOVn9h2LI6uQwXe308Em7dzO+NYMd
	 wpAeYloxwi3ZXh6wNZGaJxiB6YqLh6gZ5d3ohuwAk/sH/8wLhsuL4cGd+zi+tpOgjd
	 yJEURD06VrYB6eyZUbzmSO3clB23mwz+AkkG9tGy0B0UFrrER4sr2t0lEFNXUZ33Es
	 2Qc+1JHBa3HIeXwT6tXVMv3tr4gUVWYHmJXpVvhKdPuqTIaJdrys5OltQbVMbBAwEc
	 mp6g1drWr+F4w==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org,
	linux-riscv@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 08/20] crypto: x86/aes - Drop superseded 32-bit build support
Date: Sun, 27 Sep 2026 15:42:59 -0700
Message-ID: <20260927224418.109759-9-ebiggers@kernel.org>
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

Now that bare AES, AES-ECB, AES-CBC, AES-CBC-CTS, and AES-XTS are
accelerated on 32-bit x86 kernels via libaes, the equivalent code in
aesni-intel is redundant.  Only the 64-bit-only code in aesni-intel is
still needed.  Thus, drop the 32-bit build support from aesni-intel.
These AES modes remain accelerated on 32-bit kernels via libaes.

aesni-intel_asm.S is left untouched, as later commits remove that file
entirely one mode at a time anyway.  This commit just drops 32-bit
support right away to prevent bisection hazards during that.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/x86/crypto/Kconfig            |  6 ++----
 arch/x86/crypto/Makefile           | 13 +++++++------
 arch/x86/crypto/aesni-intel_glue.c | 22 +---------------------
 3 files changed, 10 insertions(+), 31 deletions(-)

diff --git a/arch/x86/crypto/Kconfig b/arch/x86/crypto/Kconfig
index f65d7b83702f..3c4c582e7f2d 100644
--- a/arch/x86/crypto/Kconfig
+++ b/arch/x86/crypto/Kconfig
@@ -4,6 +4,7 @@ menu "Accelerated Cryptographic Algorithms for CPU (x86)"
 
 config CRYPTO_AES_NI_INTEL
 	tristate "Ciphers: AES, modes: ECB, CBC, CTS, CTR, XCTR, XTS, GCM (AES-NI/VAES)"
+	depends on 64BIT
 	select CRYPTO_AEAD
 	select CRYPTO_LIB_AES
 	select CRYPTO_LIB_GF128MUL
@@ -12,13 +13,10 @@ config CRYPTO_AES_NI_INTEL
 	  AEAD cipher: AES with GCM
 	  Length-preserving ciphers: AES with ECB, CBC, CTS, CTR, XCTR, XTS
 
-	  Architecture: x86 (32-bit and 64-bit) using:
+	  Architecture: x86_64 using:
 	  - AES-NI (AES new instructions)
 	  - VAES (Vector AES)
 
-	  Some algorithm implementations are supported only in 64-bit builds,
-	  and some have additional prerequisites such as AVX2 or AVX512.
-
 config CRYPTO_BLOWFISH_X86_64
 	tristate "Ciphers: Blowfish, modes: ECB, CBC"
 	depends on 64BIT
diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index e04ff8718d6b..1c3feb6d72b7 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -40,12 +40,13 @@ obj-$(CONFIG_CRYPTO_AEGIS128_AESNI_SSE2) += aegis128-aesni.o
 aegis128-aesni-y := aegis128-aesni-asm.o aegis128-aesni-glue.o
 
 obj-$(CONFIG_CRYPTO_AES_NI_INTEL) += aesni-intel.o
-aesni-intel-y := aesni-intel_asm.o aesni-intel_glue.o
-aesni-intel-$(CONFIG_64BIT) += aes-ctr-avx-x86_64.o \
-			       aes-gcm-aesni-x86_64.o \
-			       aes-gcm-vaes-avx2.o \
-			       aes-gcm-vaes-avx512.o \
-			       aes-xts-avx-x86_64.o
+aesni-intel-y := aesni-intel_asm.o \
+		 aesni-intel_glue.o \
+		 aes-ctr-avx-x86_64.o \
+		 aes-gcm-aesni-x86_64.o \
+		 aes-gcm-vaes-avx2.o \
+		 aes-gcm-vaes-avx512.o \
+		 aes-xts-avx-x86_64.o
 
 obj-$(CONFIG_CRYPTO_SM4_AESNI_AVX_X86_64) += sm4-aesni-avx-x86_64.o
 sm4-aesni-avx-x86_64-y := sm4-aesni-avx-asm_64.o sm4_aesni_avx_glue.o
diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index f522fff9231e..259e319ff92b 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -80,10 +80,8 @@ asmlinkage void aesni_xts_enc(const struct crypto_aes_ctx *ctx, u8 *out,
 asmlinkage void aesni_xts_dec(const struct crypto_aes_ctx *ctx, u8 *out,
 			      const u8 *in, unsigned int len, u8 *iv);
 
-#ifdef CONFIG_X86_64
 asmlinkage void aesni_ctr_enc(struct crypto_aes_ctx *ctx, u8 *out,
 			      const u8 *in, unsigned int len, u8 *iv);
-#endif
 
 static inline struct crypto_aes_ctx *aes_ctx(void *raw_ctx)
 {
@@ -319,7 +317,6 @@ static int cts_cbc_decrypt(struct skcipher_request *req)
 	return skcipher_walk_done(&walk, 0);
 }
 
-#ifdef CONFIG_X86_64
 /* This is the non-AVX version. */
 static int ctr_crypt_aesni(struct skcipher_request *req)
 {
@@ -353,7 +350,6 @@ static int ctr_crypt_aesni(struct skcipher_request *req)
 	}
 	return err;
 }
-#endif
 
 static int xts_setkey_aesni(struct crypto_skcipher *tfm, const u8 *key,
 			    unsigned int keylen)
@@ -469,8 +465,7 @@ xts_crypt(struct skcipher_request *req, xts_encrypt_iv_func encrypt_iv,
 	 * single-scatterlist-element messages as efficiently as possible.  The
 	 * code is 64-bit specific, as it assumes no page mapping is needed.
 	 */
-	if (IS_ENABLED(CONFIG_X86_64) &&
-	    likely(req->src->length >= req->cryptlen &&
+	if (likely(req->src->length >= req->cryptlen &&
 		   req->dst->length >= req->cryptlen)) {
 		(*crypt_func)(&ctx->crypt_ctx, sg_virt(req->src),
 			      sg_virt(req->dst), req->cryptlen, req->iv);
@@ -557,7 +552,6 @@ static struct skcipher_alg aesni_skciphers[] = {
 		.setkey		= aesni_skcipher_setkey,
 		.encrypt	= cts_cbc_encrypt,
 		.decrypt	= cts_cbc_decrypt,
-#ifdef CONFIG_X86_64
 	}, {
 		.base = {
 			.cra_name		= "ctr(aes)",
@@ -574,7 +568,6 @@ static struct skcipher_alg aesni_skciphers[] = {
 		.setkey		= aesni_skcipher_setkey,
 		.encrypt	= ctr_crypt_aesni,
 		.decrypt	= ctr_crypt_aesni,
-#endif
 	}, {
 		.base = {
 			.cra_name		= "xts(aes)",
@@ -594,7 +587,6 @@ static struct skcipher_alg aesni_skciphers[] = {
 	}
 };
 
-#ifdef CONFIG_X86_64
 asmlinkage void aes_xts_encrypt_iv(const struct crypto_aes_ctx *tweak_key,
 				   u8 iv[AES_BLOCK_SIZE]);
 
@@ -1604,18 +1596,6 @@ static void unregister_avx_algs(void)
 	unregister_aeads(aes_gcm_algs_vaes_avx2);
 	unregister_aeads(aes_gcm_algs_vaes_avx512);
 }
-#else /* CONFIG_X86_64 */
-static struct aead_alg aes_gcm_algs_aesni[0];
-
-static int __init register_avx_algs(void)
-{
-	return 0;
-}
-
-static void unregister_avx_algs(void)
-{
-}
-#endif /* !CONFIG_X86_64 */
 
 static const struct x86_cpu_id aesni_cpu_id[] = {
 	X86_MATCH_FEATURE(X86_FEATURE_AES, NULL),
-- 
2.55.0

