From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: [PATCH 1/3] crypto: [sha] Restructure x86 sha1 glue code to expose
 all the available sha1 transforms
Date: Wed, 16 Sep 2015 16:34:53 -0700
Message-ID: <1442446493.6240.2.camel@schen9-desk2.jf.intel.com>
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
Received: from mga11.intel.com ([192.55.52.93]:22283 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752811AbbIPXey (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 16 Sep 2015 19:34:54 -0400
In-Reply-To: <cover.1442451609.git.tim.c.chen@linux.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Restructure the x86 sha1 glue code so we will expose sha1 transforms based
on SSSE3, AVX, AVX2 or SHA-NI extension as separate individual drivers
when cpu provides such support. This will make it easy for alternative
algorithms to be used if desired and makes the code cleaner and easier
to maintain.

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 arch/x86/crypto/sha1_ssse3_glue.c | 324 +++++++++++++++++++++++++++++---------
 1 file changed, 250 insertions(+), 74 deletions(-)

diff --git a/arch/x86/crypto/sha1_ssse3_glue.c b/arch/x86/crypto/sha1_ssse3_glue.c
index 98be8cc..c934197 100644
--- a/arch/x86/crypto/sha1_ssse3_glue.c
+++ b/arch/x86/crypto/sha1_ssse3_glue.c
@@ -31,28 +31,11 @@
 #include <crypto/sha1_base.h>
 #include <asm/fpu/api.h>
 
+typedef void (sha1_transform_fn)(u32 *digest, const char *data,
+				unsigned int rounds);
 
-asmlinkage void sha1_transform_ssse3(u32 *digest, const char *data,
-				     unsigned int rounds);
-#ifdef CONFIG_AS_AVX
-asmlinkage void sha1_transform_avx(u32 *digest, const char *data,
-				   unsigned int rounds);
-#endif
-#ifdef CONFIG_AS_AVX2
-#define SHA1_AVX2_BLOCK_OPTSIZE	4	/* optimal 4*64 bytes of SHA1 blocks */
-
-asmlinkage void sha1_transform_avx2(u32 *digest, const char *data,
-				    unsigned int rounds);
-#endif
-#ifdef CONFIG_AS_SHA1_NI
-asmlinkage void sha1_ni_transform(u32 *digest, const char *data,
-				   unsigned int rounds);
-#endif
-
-static void (*sha1_transform_asm)(u32 *, const char *, unsigned int);
-
-static int sha1_ssse3_update(struct shash_desc *desc, const u8 *data,
-			     unsigned int len)
+static int sha1_update(struct shash_desc *desc, const u8 *data,
+			     unsigned int len, sha1_transform_fn *sha1_xform)
 {
 	struct sha1_state *sctx = shash_desc_ctx(desc);
 
@@ -65,14 +48,14 @@ static int sha1_ssse3_update(struct shash_desc *desc, const u8 *data,
 
 	kernel_fpu_begin();
 	sha1_base_do_update(desc, data, len,
-			    (sha1_block_fn *)sha1_transform_asm);
+			    (sha1_block_fn *)sha1_xform);
 	kernel_fpu_end();
 
 	return 0;
 }
 
-static int sha1_ssse3_finup(struct shash_desc *desc, const u8 *data,
-			      unsigned int len, u8 *out)
+static int sha1_finup(struct shash_desc *desc, const u8 *data,
+		      unsigned int len, u8 *out, sha1_transform_fn *sha1_xform)
 {
 	if (!irq_fpu_usable())
 		return crypto_sha1_finup(desc, data, len, out);
@@ -80,32 +63,37 @@ static int sha1_ssse3_finup(struct shash_desc *desc, const u8 *data,
 	kernel_fpu_begin();
 	if (len)
 		sha1_base_do_update(desc, data, len,
-				    (sha1_block_fn *)sha1_transform_asm);
-	sha1_base_do_finalize(desc, (sha1_block_fn *)sha1_transform_asm);
+				    (sha1_block_fn *)sha1_xform);
+	sha1_base_do_finalize(desc, (sha1_block_fn *)sha1_xform);
 	kernel_fpu_end();
 
 	return sha1_base_finish(desc, out);
 }
 
-/* Add padding and return the message digest. */
-static int sha1_ssse3_final(struct shash_desc *desc, u8 *out)
+asmlinkage void sha1_transform_ssse3(u32 *digest, const char *data,
+				     unsigned int rounds);
+
+static int sha1_ssse3_update(struct shash_desc *desc, const u8 *data,
+			     unsigned int len)
 {
-	return sha1_ssse3_finup(desc, NULL, 0, out);
+	return sha1_update(desc, data, len,
+			(sha1_transform_fn *) sha1_transform_ssse3);
 }
 
-#ifdef CONFIG_AS_AVX2
-static void sha1_apply_transform_avx2(u32 *digest, const char *data,
-				unsigned int rounds)
+static int sha1_ssse3_finup(struct shash_desc *desc, const u8 *data,
+			      unsigned int len, u8 *out)
 {
-	/* Select the optimal transform based on data block size */
-	if (rounds >= SHA1_AVX2_BLOCK_OPTSIZE)
-		sha1_transform_avx2(digest, data, rounds);
-	else
-		sha1_transform_avx(digest, data, rounds);
+	return sha1_finup(desc, data, len, out,
+			(sha1_transform_fn *) sha1_transform_ssse3);
+}
+
+/* Add padding and return the message digest. */
+static int sha1_ssse3_final(struct shash_desc *desc, u8 *out)
+{
+	return sha1_ssse3_finup(desc, NULL, 0, out);
 }
-#endif
 
-static struct shash_alg alg = {
+static struct shash_alg sha1_ssse3_alg = {
 	.digestsize	=	SHA1_DIGEST_SIZE,
 	.init		=	sha1_base_init,
 	.update		=	sha1_ssse3_update,
@@ -114,7 +102,7 @@ static struct shash_alg alg = {
 	.descsize	=	sizeof(struct sha1_state),
 	.base		=	{
 		.cra_name	=	"sha1",
-		.cra_driver_name=	"sha1-ssse3",
+		.cra_driver_name =	"sha1-ssse3",
 		.cra_priority	=	150,
 		.cra_flags	=	CRYPTO_ALG_TYPE_SHASH,
 		.cra_blocksize	=	SHA1_BLOCK_SIZE,
@@ -122,8 +110,60 @@ static struct shash_alg alg = {
 	}
 };
 
+static int register_sha1_ssse3(void)
+{
+	if (boot_cpu_has(X86_FEATURE_SSSE3))
+		return crypto_register_shash(&sha1_ssse3_alg);
+	return 0;
+}
+
+static void unregister_sha1_ssse3(void)
+{
+	if (boot_cpu_has(X86_FEATURE_SSSE3))
+		crypto_unregister_shash(&sha1_ssse3_alg);
+}
+
 #ifdef CONFIG_AS_AVX
-static bool __init avx_usable(void)
+asmlinkage void sha1_transform_avx(u32 *digest, const char *data,
+				   unsigned int rounds);
+
+static int sha1_avx_update(struct shash_desc *desc, const u8 *data,
+			     unsigned int len)
+{
+	return sha1_update(desc, data, len,
+			(sha1_transform_fn *) sha1_transform_avx);
+}
+
+static int sha1_avx_finup(struct shash_desc *desc, const u8 *data,
+			      unsigned int len, u8 *out)
+{
+	return sha1_finup(desc, data, len, out,
+			(sha1_transform_fn *) sha1_transform_avx);
+}
+
+static int sha1_avx_final(struct shash_desc *desc, u8 *out)
+{
+	return sha1_avx_finup(desc, NULL, 0, out);
+}
+
+static struct shash_alg sha1_avx_alg = {
+	.digestsize	=	SHA1_DIGEST_SIZE,
+	.init		=	sha1_base_init,
+	.update		=	sha1_avx_update,
+	.final		=	sha1_avx_final,
+	.finup		=	sha1_avx_finup,
+	.descsize	=	sizeof(struct sha1_state),
+	.base		=	{
+		.cra_name	=	"sha1",
+		.cra_driver_name =	"sha1-avx",
+		.cra_priority	=	160,
+		.cra_flags	=	CRYPTO_ALG_TYPE_SHASH,
+		.cra_blocksize	=	SHA1_BLOCK_SIZE,
+		.cra_module	=	THIS_MODULE,
+	}
+};
+
+static bool avx_usable(void)
 {
 	if (!cpu_has_xfeatures(XSTATE_SSE | XSTATE_YMM, NULL)) {
 		if (cpu_has_avx)
@@ -134,61 +174,197 @@ static bool __init avx_usable(void)
 	return true;
 }
 
-#ifdef CONFIG_AS_AVX2
-static bool __init avx2_usable(void)
+static int register_sha1_avx(void)
+{
+	if (avx_usable())
+		return crypto_register_shash(&sha1_avx_alg);
+	return 0;
+}
+
+static void unregister_sha1_avx(void)
+{
+	if (avx_usable())
+		crypto_unregister_shash(&sha1_avx_alg);
+}
+
+#else  /* CONFIG_AS_AVX */
+static inline int register_sha1_avx(void) { return 0; }
+static inline void unregister_sha1_avx(void) { }
+#endif /* CONFIG_AS_AVX */
+
+
+#if defined(CONFIG_AS_AVX2) && (CONFIG_AS_AVX)
+#define SHA1_AVX2_BLOCK_OPTSIZE	4	/* optimal 4*64 bytes of SHA1 blocks */
+
+asmlinkage void sha1_transform_avx2(u32 *digest, const char *data,
+				    unsigned int rounds);
+
+static bool avx2_usable(void)
 {
-	if (avx_usable() && cpu_has_avx2 && boot_cpu_has(X86_FEATURE_BMI1) &&
-	    boot_cpu_has(X86_FEATURE_BMI2))
+	if (avx_usable() && boot_cpu_has(X86_FEATURE_AVX2)
+		&& boot_cpu_has(X86_FEATURE_BMI1)
+		&& boot_cpu_has(X86_FEATURE_BMI2))
 		return true;
 
 	return false;
 }
-#endif
-#endif
 
-static int __init sha1_ssse3_mod_init(void)
+static void sha1_apply_transform_avx2(u32 *digest, const char *data,
+				unsigned int rounds)
 {
-	char *algo_name;
+	/* Select the optimal transform based on data block size */
+	if (rounds >= SHA1_AVX2_BLOCK_OPTSIZE)
+		sha1_transform_avx2(digest, data, rounds);
+	else
+		sha1_transform_avx(digest, data, rounds);
+}
 
-	/* test for SSSE3 first */
-	if (cpu_has_ssse3) {
-		sha1_transform_asm = sha1_transform_ssse3;
-		algo_name = "SSSE3";
-	}
+static int sha1_avx2_update(struct shash_desc *desc, const u8 *data,
+			     unsigned int len)
+{
+	return sha1_update(desc, data, len,
+		(sha1_transform_fn *) sha1_apply_transform_avx2);
+}
 
-#ifdef CONFIG_AS_AVX
-	/* allow AVX to override SSSE3, it's a little faster */
-	if (avx_usable()) {
-		sha1_transform_asm = sha1_transform_avx;
-		algo_name = "AVX";
-#ifdef CONFIG_AS_AVX2
-		/* allow AVX2 to override AVX, it's a little faster */
-		if (avx2_usable()) {
-			sha1_transform_asm = sha1_apply_transform_avx2;
-			algo_name = "AVX2";
-		}
-#endif
+static int sha1_avx2_finup(struct shash_desc *desc, const u8 *data,
+			      unsigned int len, u8 *out)
+{
+	return sha1_finup(desc, data, len, out,
+		(sha1_transform_fn *) sha1_apply_transform_avx2);
+}
+
+static int sha1_avx2_final(struct shash_desc *desc, u8 *out)
+{
+	return sha1_avx2_finup(desc, NULL, 0, out);
+}
+
+static struct shash_alg sha1_avx2_alg = {
+	.digestsize	=	SHA1_DIGEST_SIZE,
+	.init		=	sha1_base_init,
+	.update		=	sha1_avx2_update,
+	.final		=	sha1_avx2_final,
+	.finup		=	sha1_avx2_finup,
+	.descsize	=	sizeof(struct sha1_state),
+	.base		=	{
+		.cra_name	=	"sha1",
+		.cra_driver_name =	"sha1-avx2",
+		.cra_priority	=	170,
+		.cra_flags	=	CRYPTO_ALG_TYPE_SHASH,
+		.cra_blocksize	=	SHA1_BLOCK_SIZE,
+		.cra_module	=	THIS_MODULE,
 	}
+};
+
+static int register_sha1_avx2(void)
+{
+	if (avx2_usable())
+		return crypto_register_shash(&sha1_avx2_alg);
+	return 0;
+}
+
+static void unregister_sha1_avx2(void)
+{
+	if (avx2_usable())
+		crypto_unregister_shash(&sha1_avx2_alg);
+}
+
+#else
+static inline int register_sha1_avx2(void) { return 0; }
+static inline void unregister_sha1_avx2(void) { }
 #endif
+
 #ifdef CONFIG_AS_SHA1_NI
-	if (boot_cpu_has(X86_FEATURE_SHA_NI)) {
-		sha1_transform_asm = sha1_ni_transform;
-		algo_name = "SHA-NI";
+asmlinkage void sha1_ni_transform(u32 *digest, const char *data,
+				   unsigned int rounds);
+
+static int sha1_ni_update(struct shash_desc *desc, const u8 *data,
+			     unsigned int len)
+{
+	return sha1_update(desc, data, len,
+		(sha1_transform_fn *) sha1_ni_transform);
+}
+
+static int sha1_ni_finup(struct shash_desc *desc, const u8 *data,
+			      unsigned int len, u8 *out)
+{
+	return sha1_finup(desc, data, len, out,
+		(sha1_transform_fn *) sha1_ni_transform);
+}
+
+static int sha1_ni_final(struct shash_desc *desc, u8 *out)
+{
+	return sha1_ni_finup(desc, NULL, 0, out);
+}
+
+static struct shash_alg sha1_ni_alg = {
+	.digestsize	=	SHA1_DIGEST_SIZE,
+	.init		=	sha1_base_init,
+	.update		=	sha1_ni_update,
+	.final		=	sha1_ni_final,
+	.finup		=	sha1_ni_finup,
+	.descsize	=	sizeof(struct sha1_state),
+	.base		=	{
+		.cra_name	=	"sha1",
+		.cra_driver_name =	"sha1-ni",
+		.cra_priority	=	250,
+		.cra_flags	=	CRYPTO_ALG_TYPE_SHASH,
+		.cra_blocksize	=	SHA1_BLOCK_SIZE,
+		.cra_module	=	THIS_MODULE,
 	}
+};
+
+static int register_sha1_ni(void)
+{
+	if (boot_cpu_has(X86_FEATURE_SHA_NI))
+		return crypto_register_shash(&sha1_ni_alg);
+	return 0;
+}
+
+static void unregister_sha1_ni(void)
+{
+	if (boot_cpu_has(X86_FEATURE_SHA_NI))
+		crypto_unregister_shash(&sha1_ni_alg);
+}
+
+#else
+static inline int register_sha1_ni(void) { return 0; }
+static inline void unregister_sha1_ni(void) { }
 #endif
 
-	if (sha1_transform_asm) {
-		pr_info("Using %s optimized SHA-1 implementation\n", algo_name);
-		return crypto_register_shash(&alg);
+static int __init sha1_ssse3_mod_init(void)
+{
+	if (register_sha1_ssse3())
+		goto fail;
+
+	if (register_sha1_avx()) {
+		unregister_sha1_ssse3();
+		goto fail;
 	}
-	pr_info("Neither AVX nor AVX2 nor SSSE3/SHA-NI is available/usable.\n");
 
+	if (register_sha1_avx2()) {
+		unregister_sha1_avx();
+		unregister_sha1_ssse3();
+		goto fail;
+	}
+
+	if (register_sha1_ni()) {
+		unregister_sha1_avx2();
+		unregister_sha1_avx();
+		unregister_sha1_ssse3();
+		goto fail;
+	}
+
+	return 0;
+fail:
 	return -ENODEV;
 }
 
 static void __exit sha1_ssse3_mod_fini(void)
 {
-	crypto_unregister_shash(&alg);
+	unregister_sha1_ni();
+	unregister_sha1_avx2();
+	unregister_sha1_avx();
+	unregister_sha1_ssse3();
 }
 
 module_init(sha1_ssse3_mod_init);
-- 
1.7.11.7
