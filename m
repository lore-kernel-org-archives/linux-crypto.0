From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: [PATCH 2/3] crypto: [sha] Restructure x86 sha256 glue code to
 expose all the available sha256 transforms
Date: Wed, 16 Sep 2015 16:35:23 -0700
Message-ID: <1442446523.6240.3.camel@schen9-desk2.jf.intel.com>
References: <cover.1442451609.git.tim.c.chen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Sean Gulley <sean.m.gulley@intel.com>,
	Chandramouli Narayanan <mouli_7982@yahoo.com>,
	Vinodh Gopal <vinodh.gopal@intel.com>,
	James Guilford <james.guilford@intel.com>,
	Wajdi Feghali <wajdi.k.feghali@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"David S.Miller" <davem@davemloft.net>,
	Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:36890 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752556AbbIPXfZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 16 Sep 2015 19:35:25 -0400
In-Reply-To: <cover.1442451609.git.tim.c.chen@linux.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Restructure the x86 sha256 glue code so we will expose sha256 transforms
based on SSSE3, AVX, AVX2 or SHA-NI extension as separate individual
drivers when cpu provides such support. This will make it easy for
alternative algorithms to be used if desired and makes the code cleaner
and easier to maintain.

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 arch/x86/crypto/sha256_ssse3_glue.c | 331 ++++++++++++++++++++++++++++++------
 1 file changed, 281 insertions(+), 50 deletions(-)

diff --git a/arch/x86/crypto/sha256_ssse3_glue.c b/arch/x86/crypto/sha256_ssse3_glue.c
index 9c7b22c..863e2f6 100644
--- a/arch/x86/crypto/sha256_ssse3_glue.c
+++ b/arch/x86/crypto/sha256_ssse3_glue.c
@@ -42,23 +42,10 @@
 
 asmlinkage void sha256_transform_ssse3(u32 *digest, const char *data,
 				       u64 rounds);
-#ifdef CONFIG_AS_AVX
-asmlinkage void sha256_transform_avx(u32 *digest, const char *data,
-				     u64 rounds);
-#endif
-#ifdef CONFIG_AS_AVX2
-asmlinkage void sha256_transform_rorx(u32 *digest, const char *data,
-				      u64 rounds);
-#endif
-#ifdef CONFIG_AS_SHA256_NI
-asmlinkage void sha256_ni_transform(u32 *digest, const char *data,
-				   u64 rounds); /*unsigned int rounds);*/
-#endif
+typedef void (sha256_transform_fn)(u32 *digest, const char *data, u64 rounds);
 
-static void (*sha256_transform_asm)(u32 *, const char *, u64);
-
-static int sha256_ssse3_update(struct shash_desc *desc, const u8 *data,
-			     unsigned int len)
+static int sha256_update(struct shash_desc *desc, const u8 *data,
+			 unsigned int len, sha256_transform_fn *sha256_xform)
 {
 	struct sha256_state *sctx = shash_desc_ctx(desc);
 
@@ -71,14 +58,14 @@ static int sha256_ssse3_update(struct shash_desc *desc, const u8 *data,
 
 	kernel_fpu_begin();
 	sha256_base_do_update(desc, data, len,
-			      (sha256_block_fn *)sha256_transform_asm);
+			      (sha256_block_fn *)sha256_xform);
 	kernel_fpu_end();
 
 	return 0;
 }
 
-static int sha256_ssse3_finup(struct shash_desc *desc, const u8 *data,
-			      unsigned int len, u8 *out)
+static int sha256_finup(struct shash_desc *desc, const u8 *data,
+	      unsigned int len, u8 *out, sha256_transform_fn *sha256_xform)
 {
 	if (!irq_fpu_usable())
 		return crypto_sha256_finup(desc, data, len, out);
@@ -86,20 +73,32 @@ static int sha256_ssse3_finup(struct shash_desc *desc, const u8 *data,
 	kernel_fpu_begin();
 	if (len)
 		sha256_base_do_update(desc, data, len,
-				      (sha256_block_fn *)sha256_transform_asm);
-	sha256_base_do_finalize(desc, (sha256_block_fn *)sha256_transform_asm);
+				      (sha256_block_fn *)sha256_xform);
+	sha256_base_do_finalize(desc, (sha256_block_fn *)sha256_xform);
 	kernel_fpu_end();
 
 	return sha256_base_finish(desc, out);
 }
 
+static int sha256_ssse3_update(struct shash_desc *desc, const u8 *data,
+			 unsigned int len)
+{
+	return sha256_update(desc, data, len, sha256_transform_ssse3);
+}
+
+static int sha256_ssse3_finup(struct shash_desc *desc, const u8 *data,
+	      unsigned int len, u8 *out)
+{
+	return sha256_finup(desc, data, len, out, sha256_transform_ssse3);
+}
+
 /* Add padding and return the message digest. */
 static int sha256_ssse3_final(struct shash_desc *desc, u8 *out)
 {
 	return sha256_ssse3_finup(desc, NULL, 0, out);
 }
 
-static struct shash_alg algs[] = { {
+static struct shash_alg sha256_ssse3_algs[] = { {
 	.digestsize	=	SHA256_DIGEST_SIZE,
 	.init		=	sha256_base_init,
 	.update		=	sha256_ssse3_update,
@@ -131,8 +130,75 @@ static struct shash_alg algs[] = { {
 	}
 } };
 
+static int register_sha256_ssse3(void)
+{
+	if (boot_cpu_has(X86_FEATURE_SSSE3))
+		return crypto_register_shashes(sha256_ssse3_algs,
+				ARRAY_SIZE(sha256_ssse3_algs));
+	return 0;
+}
+
+static void unregister_sha256_ssse3(void)
+{
+	if (boot_cpu_has(X86_FEATURE_SSSE3))
+		crypto_unregister_shashes(sha256_ssse3_algs,
+				ARRAY_SIZE(sha256_ssse3_algs));
+}
+
 #ifdef CONFIG_AS_AVX
-static bool __init avx_usable(void)
+asmlinkage void sha256_transform_avx(u32 *digest, const char *data,
+				     u64 rounds);
+
+static int sha256_avx_update(struct shash_desc *desc, const u8 *data,
+			 unsigned int len)
+{
+	return sha256_update(desc, data, len, sha256_transform_avx);
+}
+
+static int sha256_avx_finup(struct shash_desc *desc, const u8 *data,
+		      unsigned int len, u8 *out)
+{
+	return sha256_finup(desc, data, len, out, sha256_transform_avx);
+}
+
+static int sha256_avx_final(struct shash_desc *desc, u8 *out)
+{
+	return sha256_avx_finup(desc, NULL, 0, out);
+}
+
+static struct shash_alg sha256_avx_algs[] = { {
+	.digestsize	=	SHA256_DIGEST_SIZE,
+	.init		=	sha256_base_init,
+	.update		=	sha256_avx_update,
+	.final		=	sha256_avx_final,
+	.finup		=	sha256_avx_finup,
+	.descsize	=	sizeof(struct sha256_state),
+	.base		=	{
+		.cra_name	=	"sha256",
+		.cra_driver_name =	"sha256-avx",
+		.cra_priority	=	160,
+		.cra_flags	=	CRYPTO_ALG_TYPE_SHASH,
+		.cra_blocksize	=	SHA256_BLOCK_SIZE,
+		.cra_module	=	THIS_MODULE,
+	}
+}, {
+	.digestsize	=	SHA224_DIGEST_SIZE,
+	.init		=	sha224_base_init,
+	.update		=	sha256_avx_update,
+	.final		=	sha256_avx_final,
+	.finup		=	sha256_avx_finup,
+	.descsize	=	sizeof(struct sha256_state),
+	.base		=	{
+		.cra_name	=	"sha224",
+		.cra_driver_name =	"sha224-avx",
+		.cra_priority	=	160,
+		.cra_flags	=	CRYPTO_ALG_TYPE_SHASH,
+		.cra_blocksize	=	SHA224_BLOCK_SIZE,
+		.cra_module	=	THIS_MODULE,
+	}
+} };
+
+static bool avx_usable(void)
 {
 	if (!cpu_has_xfeatures(XSTATE_SSE | XSTATE_YMM, NULL)) {
 		if (cpu_has_avx)
@@ -142,51 +208,216 @@ static bool __init avx_usable(void)
 
 	return true;
 }
-#endif
 
-static int __init sha256_ssse3_mod_init(void)
+static int register_sha256_avx(void)
 {
-	char *algo;
+	if (avx_usable())
+		return crypto_register_shashes(sha256_avx_algs,
+				ARRAY_SIZE(sha256_avx_algs));
+	return 0;
+}
 
-	/* test for SSSE3 first */
-	if (cpu_has_ssse3) {
-		sha256_transform_asm = sha256_transform_ssse3;
-		algo = "SSSE3";
-	}
+static void unregister_sha256_avx(void)
+{
+	if (avx_usable())
+		crypto_unregister_shashes(sha256_avx_algs,
+				ARRAY_SIZE(sha256_avx_algs));
+}
 
-#ifdef CONFIG_AS_AVX
-	/* allow AVX to override SSSE3, it's a little faster */
-	if (avx_usable()) {
-		sha256_transform_asm = sha256_transform_avx;
-		algo = "AVX";
-#ifdef CONFIG_AS_AVX2
-		if (boot_cpu_has(X86_FEATURE_AVX2) &&
-		    boot_cpu_has(X86_FEATURE_BMI2)) {
-			sha256_transform_asm = sha256_transform_rorx;
-			algo = "AVX2";
-		}
+#else
+static inline int register_sha256_avx(void) { return 0; }
+static inline void unregister_sha256_avx(void) { }
 #endif
+
+#if defined(CONFIG_AS_AVX2) && defined(CONFIG_AS_AVX)
+asmlinkage void sha256_transform_rorx(u32 *digest, const char *data,
+				      u64 rounds);
+
+static int sha256_avx2_update(struct shash_desc *desc, const u8 *data,
+			 unsigned int len)
+{
+	return sha256_update(desc, data, len, sha256_transform_rorx);
+}
+
+static int sha256_avx2_finup(struct shash_desc *desc, const u8 *data,
+		      unsigned int len, u8 *out)
+{
+	return sha256_finup(desc, data, len, out, sha256_transform_rorx);
+}
+
+static int sha256_avx2_final(struct shash_desc *desc, u8 *out)
+{
+	return sha256_avx2_finup(desc, NULL, 0, out);
+}
+
+static struct shash_alg sha256_avx2_algs[] = { {
+	.digestsize	=	SHA256_DIGEST_SIZE,
+	.init		=	sha256_base_init,
+	.update		=	sha256_avx2_update,
+	.final		=	sha256_avx2_final,
+	.finup		=	sha256_avx2_finup,
+	.descsize	=	sizeof(struct sha256_state),
+	.base		=	{
+		.cra_name	=	"sha256",
+		.cra_driver_name =	"sha256-avx2",
+		.cra_priority	=	170,
+		.cra_flags	=	CRYPTO_ALG_TYPE_SHASH,
+		.cra_blocksize	=	SHA256_BLOCK_SIZE,
+		.cra_module	=	THIS_MODULE,
 	}
+}, {
+	.digestsize	=	SHA224_DIGEST_SIZE,
+	.init		=	sha224_base_init,
+	.update		=	sha256_avx2_update,
+	.final		=	sha256_avx2_final,
+	.finup		=	sha256_avx2_finup,
+	.descsize	=	sizeof(struct sha256_state),
+	.base		=	{
+		.cra_name	=	"sha224",
+		.cra_driver_name =	"sha224-avx2",
+		.cra_priority	=	170,
+		.cra_flags	=	CRYPTO_ALG_TYPE_SHASH,
+		.cra_blocksize	=	SHA224_BLOCK_SIZE,
+		.cra_module	=	THIS_MODULE,
+	}
+} };
+
+static bool avx2_usable(void)
+{
+	if (avx_usable() && boot_cpu_has(X86_FEATURE_AVX2) &&
+		    boot_cpu_has(X86_FEATURE_BMI2))
+		return true;
+
+	return false;
+}
+
+static int register_sha256_avx2(void)
+{
+	if (avx2_usable())
+		return crypto_register_shashes(sha256_avx2_algs,
+				ARRAY_SIZE(sha256_avx2_algs));
+	return 0;
+}
+
+static void unregister_sha256_avx2(void)
+{
+	if (avx2_usable())
+		crypto_unregister_shashes(sha256_avx2_algs,
+				ARRAY_SIZE(sha256_avx2_algs));
+}
+
+#else
+static inline int register_sha256_avx2(void) { return 0; }
+static inline void unregister_sha256_avx2(void) { }
 #endif
+
 #ifdef CONFIG_AS_SHA256_NI
-	if (boot_cpu_has(X86_FEATURE_SHA_NI)) {
-		sha256_transform_asm = sha256_ni_transform;
-		algo = "SHA-256-NI";
+asmlinkage void sha256_ni_transform(u32 *digest, const char *data,
+				   u64 rounds); /*unsigned int rounds);*/
+
+static int sha256_ni_update(struct shash_desc *desc, const u8 *data,
+			 unsigned int len)
+{
+	return sha256_update(desc, data, len, sha256_ni_transform);
+}
+
+static int sha256_ni_finup(struct shash_desc *desc, const u8 *data,
+		      unsigned int len, u8 *out)
+{
+	return sha256_finup(desc, data, len, out, sha256_ni_transform);
+}
+
+static int sha256_ni_final(struct shash_desc *desc, u8 *out)
+{
+	return sha256_ni_finup(desc, NULL, 0, out);
+}
+
+static struct shash_alg sha256_ni_algs[] = { {
+	.digestsize	=	SHA256_DIGEST_SIZE,
+	.init		=	sha256_base_init,
+	.update		=	sha256_ni_update,
+	.final		=	sha256_ni_final,
+	.finup		=	sha256_ni_finup,
+	.descsize	=	sizeof(struct sha256_state),
+	.base		=	{
+		.cra_name	=	"sha256",
+		.cra_driver_name =	"sha256-ni",
+		.cra_priority	=	250,
+		.cra_flags	=	CRYPTO_ALG_TYPE_SHASH,
+		.cra_blocksize	=	SHA256_BLOCK_SIZE,
+		.cra_module	=	THIS_MODULE,
+	}
+}, {
+	.digestsize	=	SHA224_DIGEST_SIZE,
+	.init		=	sha224_base_init,
+	.update		=	sha256_ni_update,
+	.final		=	sha256_ni_final,
+	.finup		=	sha256_ni_finup,
+	.descsize	=	sizeof(struct sha256_state),
+	.base		=	{
+		.cra_name	=	"sha224",
+		.cra_driver_name =	"sha224-ni",
+		.cra_priority	=	250,
+		.cra_flags	=	CRYPTO_ALG_TYPE_SHASH,
+		.cra_blocksize	=	SHA224_BLOCK_SIZE,
+		.cra_module	=	THIS_MODULE,
 	}
+} };
+
+static int register_sha256_ni(void)
+{
+	if (boot_cpu_has(X86_FEATURE_SHA_NI))
+		return crypto_register_shashes(sha256_ni_algs,
+				ARRAY_SIZE(sha256_ni_algs));
+	return 0;
+}
+
+static void unregister_sha256_ni(void)
+{
+	if (boot_cpu_has(X86_FEATURE_SHA_NI))
+		crypto_unregister_shashes(sha256_ni_algs,
+				ARRAY_SIZE(sha256_ni_algs));
+}
+
+#else
+static inline int register_sha256_ni(void) { return 0; }
+static inline void unregister_sha256_ni(void) { }
 #endif
 
-	if (sha256_transform_asm) {
-		pr_info("Using %s optimized SHA-256 implementation\n", algo);
-		return crypto_register_shashes(algs, ARRAY_SIZE(algs));
+static int __init sha256_ssse3_mod_init(void)
+{
+	if (register_sha256_ssse3())
+		goto fail;
+
+	if (register_sha256_avx()) {
+		unregister_sha256_ssse3();
+		goto fail;
 	}
-	pr_info("Neither AVX nor SSSE3/SHA-NI is available/usable.\n");
 
+	if (register_sha256_avx2()) {
+		unregister_sha256_avx();
+		unregister_sha256_ssse3();
+		goto fail;
+	}
+
+	if (register_sha256_ni()) {
+		unregister_sha256_avx2();
+		unregister_sha256_avx();
+		unregister_sha256_ssse3();
+		goto fail;
+	}
+
+	return 0;
+fail:
 	return -ENODEV;
 }
 
 static void __exit sha256_ssse3_mod_fini(void)
 {
-	crypto_unregister_shashes(algs, ARRAY_SIZE(algs));
+	unregister_sha256_ni();
+	unregister_sha256_avx2();
+	unregister_sha256_avx();
+	unregister_sha256_ssse3();
 }
 
 module_init(sha256_ssse3_mod_init);
-- 
1.7.11.7
