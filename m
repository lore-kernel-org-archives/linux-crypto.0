From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: [PATCH 3/3] crypto: [sha] Restructure x86 sha512 glue code to
 expose all the available sha512 transforms
Date: Wed, 16 Sep 2015 16:35:53 -0700
Message-ID: <1442446553.6240.4.camel@schen9-desk2.jf.intel.com>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1442451609.git.tim.c.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


Restructure the x86 sha512 glue code so we will expose sha512 transforms
based on SSSE3, AVX or AVX2 as separate individual drivers when cpu
provides support. This will make it easy for alternative algorithms to
be used if desired and makes the code cleaner and easier to maintain.

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 arch/x86/crypto/sha512_ssse3_glue.c | 249 +++++++++++++++++++++++++++++-------
 1 file changed, 204 insertions(+), 45 deletions(-)

diff --git a/arch/x86/crypto/sha512_ssse3_glue.c b/arch/x86/crypto/sha512_ssse3_glue.c
index 2edad7b..0dfe9a2 100644
--- a/arch/x86/crypto/sha512_ssse3_glue.c
+++ b/arch/x86/crypto/sha512_ssse3_glue.c
@@ -41,19 +41,11 @@
 
 asmlinkage void sha512_transform_ssse3(u64 *digest, const char *data,
 				       u64 rounds);
-#ifdef CONFIG_AS_AVX
-asmlinkage void sha512_transform_avx(u64 *digest, const char *data,
-				     u64 rounds);
-#endif
-#ifdef CONFIG_AS_AVX2
-asmlinkage void sha512_transform_rorx(u64 *digest, const char *data,
-				      u64 rounds);
-#endif
 
-static void (*sha512_transform_asm)(u64 *, const char *, u64);
+typedef void (sha512_transform_fn)(u64 *digest, const char *data, u64 rounds);
 
-static int sha512_ssse3_update(struct shash_desc *desc, const u8 *data,
-			       unsigned int len)
+static int sha512_update(struct shash_desc *desc, const u8 *data,
+		       unsigned int len, sha512_transform_fn *sha512_xform)
 {
 	struct sha512_state *sctx = shash_desc_ctx(desc);
 
@@ -66,14 +58,14 @@ static int sha512_ssse3_update(struct shash_desc *desc, const u8 *data,
 
 	kernel_fpu_begin();
 	sha512_base_do_update(desc, data, len,
-			      (sha512_block_fn *)sha512_transform_asm);
+			      (sha512_block_fn *)sha512_xform);
 	kernel_fpu_end();
 
 	return 0;
 }
 
-static int sha512_ssse3_finup(struct shash_desc *desc, const u8 *data,
-			      unsigned int len, u8 *out)
+static int sha512_finup(struct shash_desc *desc, const u8 *data,
+	      unsigned int len, u8 *out, sha512_transform_fn *sha512_xform)
 {
 	if (!irq_fpu_usable())
 		return crypto_sha512_finup(desc, data, len, out);
@@ -81,20 +73,32 @@ static int sha512_ssse3_finup(struct shash_desc *desc, const u8 *data,
 	kernel_fpu_begin();
 	if (len)
 		sha512_base_do_update(desc, data, len,
-				      (sha512_block_fn *)sha512_transform_asm);
-	sha512_base_do_finalize(desc, (sha512_block_fn *)sha512_transform_asm);
+				      (sha512_block_fn *)sha512_xform);
+	sha512_base_do_finalize(desc, (sha512_block_fn *)sha512_xform);
 	kernel_fpu_end();
 
 	return sha512_base_finish(desc, out);
 }
 
+static int sha512_ssse3_update(struct shash_desc *desc, const u8 *data,
+		       unsigned int len)
+{
+	return sha512_update(desc, data, len, sha512_transform_ssse3);
+}
+
+static int sha512_ssse3_finup(struct shash_desc *desc, const u8 *data,
+	      unsigned int len, u8 *out)
+{
+	return sha512_finup(desc, data, len, out, sha512_transform_ssse3);
+}
+
 /* Add padding and return the message digest. */
 static int sha512_ssse3_final(struct shash_desc *desc, u8 *out)
 {
 	return sha512_ssse3_finup(desc, NULL, 0, out);
 }
 
-static struct shash_alg algs[] = { {
+static struct shash_alg sha512_ssse3_algs[] = { {
 	.digestsize	=	SHA512_DIGEST_SIZE,
 	.init		=	sha512_base_init,
 	.update		=	sha512_ssse3_update,
@@ -126,8 +130,25 @@ static struct shash_alg algs[] = { {
 	}
 } };
 
+static int register_sha512_ssse3(void)
+{
+	if (boot_cpu_has(X86_FEATURE_SSSE3))
+		return crypto_register_shashes(sha512_ssse3_algs,
+			ARRAY_SIZE(sha512_ssse3_algs));
+	return 0;
+}
+
+static void unregister_sha512_ssse3(void)
+{
+	if (boot_cpu_has(X86_FEATURE_SSSE3))
+		crypto_unregister_shashes(sha512_ssse3_algs,
+			ARRAY_SIZE(sha512_ssse3_algs));
+}
+
 #ifdef CONFIG_AS_AVX
-static bool __init avx_usable(void)
+asmlinkage void sha512_transform_avx(u64 *digest, const char *data,
+				     u64 rounds);
+static bool avx_usable(void)
 {
 	if (!cpu_has_xfeatures(XSTATE_SSE | XSTATE_YMM, NULL)) {
 		if (cpu_has_avx)
@@ -137,47 +158,185 @@ static bool __init avx_usable(void)
 
 	return true;
 }
-#endif
 
-static int __init sha512_ssse3_mod_init(void)
+static int sha512_avx_update(struct shash_desc *desc, const u8 *data,
+		       unsigned int len)
 {
-	/* test for SSSE3 first */
-	if (cpu_has_ssse3)
-		sha512_transform_asm = sha512_transform_ssse3;
+	return sha512_update(desc, data, len, sha512_transform_avx);
+}
 
-#ifdef CONFIG_AS_AVX
-	/* allow AVX to override SSSE3, it's a little faster */
-	if (avx_usable()) {
-#ifdef CONFIG_AS_AVX2
-		if (boot_cpu_has(X86_FEATURE_AVX2))
-			sha512_transform_asm = sha512_transform_rorx;
-		else
-#endif
-			sha512_transform_asm = sha512_transform_avx;
+static int sha512_avx_finup(struct shash_desc *desc, const u8 *data,
+	      unsigned int len, u8 *out)
+{
+	return sha512_finup(desc, data, len, out, sha512_transform_avx);
+}
+
+/* Add padding and return the message digest. */
+static int sha512_avx_final(struct shash_desc *desc, u8 *out)
+{
+	return sha512_avx_finup(desc, NULL, 0, out);
+}
+
+static struct shash_alg sha512_avx_algs[] = { {
+	.digestsize	=	SHA512_DIGEST_SIZE,
+	.init		=	sha512_base_init,
+	.update		=	sha512_avx_update,
+	.final		=	sha512_avx_final,
+	.finup		=	sha512_avx_finup,
+	.descsize	=	sizeof(struct sha512_state),
+	.base		=	{
+		.cra_name	=	"sha512",
+		.cra_driver_name =	"sha512-avx",
+		.cra_priority	=	160,
+		.cra_flags	=	CRYPTO_ALG_TYPE_SHASH,
+		.cra_blocksize	=	SHA512_BLOCK_SIZE,
+		.cra_module	=	THIS_MODULE,
 	}
-#endif
+},  {
+	.digestsize	=	SHA384_DIGEST_SIZE,
+	.init		=	sha384_base_init,
+	.update		=	sha512_avx_update,
+	.final		=	sha512_avx_final,
+	.finup		=	sha512_avx_finup,
+	.descsize	=	sizeof(struct sha512_state),
+	.base		=	{
+		.cra_name	=	"sha384",
+		.cra_driver_name =	"sha384-avx",
+		.cra_priority	=	160,
+		.cra_flags	=	CRYPTO_ALG_TYPE_SHASH,
+		.cra_blocksize	=	SHA384_BLOCK_SIZE,
+		.cra_module	=	THIS_MODULE,
+	}
+} };
 
-	if (sha512_transform_asm) {
-#ifdef CONFIG_AS_AVX
-		if (sha512_transform_asm == sha512_transform_avx)
-			pr_info("Using AVX optimized SHA-512 implementation\n");
-#ifdef CONFIG_AS_AVX2
-		else if (sha512_transform_asm == sha512_transform_rorx)
-			pr_info("Using AVX2 optimized SHA-512 implementation\n");
+static int register_sha512_avx(void)
+{
+	if (avx_usable())
+		return crypto_register_shashes(sha512_avx_algs,
+			ARRAY_SIZE(sha512_avx_algs));
+	return 0;
+}
+
+static void unregister_sha512_avx(void)
+{
+	if (avx_usable())
+		crypto_unregister_shashes(sha512_avx_algs,
+			ARRAY_SIZE(sha512_avx_algs));
+}
+#else
+static inline int register_sha512_avx(void) { return 0; }
+static inline void unregister_sha512_avx(void) { }
 #endif
-		else
+
+#if defined(CONFIG_AS_AVX2) && defined(CONFIG_AS_AVX)
+asmlinkage void sha512_transform_rorx(u64 *digest, const char *data,
+				      u64 rounds);
+
+static int sha512_avx2_update(struct shash_desc *desc, const u8 *data,
+		       unsigned int len)
+{
+	return sha512_update(desc, data, len, sha512_transform_rorx);
+}
+
+static int sha512_avx2_finup(struct shash_desc *desc, const u8 *data,
+	      unsigned int len, u8 *out)
+{
+	return sha512_finup(desc, data, len, out, sha512_transform_rorx);
+}
+
+/* Add padding and return the message digest. */
+static int sha512_avx2_final(struct shash_desc *desc, u8 *out)
+{
+	return sha512_avx2_finup(desc, NULL, 0, out);
+}
+
+static struct shash_alg sha512_avx2_algs[] = { {
+	.digestsize	=	SHA512_DIGEST_SIZE,
+	.init		=	sha512_base_init,
+	.update		=	sha512_avx2_update,
+	.final		=	sha512_avx2_final,
+	.finup		=	sha512_avx2_finup,
+	.descsize	=	sizeof(struct sha512_state),
+	.base		=	{
+		.cra_name	=	"sha512",
+		.cra_driver_name =	"sha512-avx2",
+		.cra_priority	=	170,
+		.cra_flags	=	CRYPTO_ALG_TYPE_SHASH,
+		.cra_blocksize	=	SHA512_BLOCK_SIZE,
+		.cra_module	=	THIS_MODULE,
+	}
+},  {
+	.digestsize	=	SHA384_DIGEST_SIZE,
+	.init		=	sha384_base_init,
+	.update		=	sha512_avx2_update,
+	.final		=	sha512_avx2_final,
+	.finup		=	sha512_avx2_finup,
+	.descsize	=	sizeof(struct sha512_state),
+	.base		=	{
+		.cra_name	=	"sha384",
+		.cra_driver_name =	"sha384-avx2",
+		.cra_priority	=	170,
+		.cra_flags	=	CRYPTO_ALG_TYPE_SHASH,
+		.cra_blocksize	=	SHA384_BLOCK_SIZE,
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
+static int register_sha512_avx2(void)
+{
+	if (avx2_usable())
+		return crypto_register_shashes(sha512_avx2_algs,
+			ARRAY_SIZE(sha512_avx2_algs));
+	return 0;
+}
+
+static void unregister_sha512_avx2(void)
+{
+	if (avx2_usable())
+		crypto_unregister_shashes(sha512_avx2_algs,
+			ARRAY_SIZE(sha512_avx2_algs));
+}
+#else
+static inline int register_sha512_avx2(void) { return 0; }
+static inline void unregister_sha512_avx2(void) { }
 #endif
-			pr_info("Using SSSE3 optimized SHA-512 implementation\n");
-		return crypto_register_shashes(algs, ARRAY_SIZE(algs));
+
+static int __init sha512_ssse3_mod_init(void)
+{
+
+	if (register_sha512_ssse3())
+		goto fail;
+
+	if (register_sha512_avx()) {
+		unregister_sha512_ssse3();
+		goto fail;
 	}
-	pr_info("Neither AVX nor SSSE3 is available/usable.\n");
 
+	if (register_sha512_avx2()) {
+		unregister_sha512_avx();
+		unregister_sha512_ssse3();
+		goto fail;
+	}
+
+	return 0;
+fail:
 	return -ENODEV;
 }
 
 static void __exit sha512_ssse3_mod_fini(void)
 {
-	crypto_unregister_shashes(algs, ARRAY_SIZE(algs));
+	unregister_sha512_avx2();
+	unregister_sha512_avx();
+	unregister_sha512_ssse3();
 }
 
 module_init(sha512_ssse3_mod_init);
-- 
1.7.11.7
