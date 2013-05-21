From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Subject: [PATCH 2/2] crypto: sha256_ssse3 - add sha224 support
Date: Tue, 21 May 2013 17:10:49 +0300
Message-ID: <20130521141049.16352.97486.stgit@localhost6.localdomain6>
References: <20130521141044.16352.75962.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Tim Chen <tim.c.chen@linux.intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:51192 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827Ab3EUOKv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 21 May 2013 10:10:51 -0400
In-Reply-To: <20130521141044.16352.75962.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add sha224 implementation to sha256_ssse3 module.

This also fixes sha256_ssse3 module autoloading issue when 'sha224' is used
before 'sha256'. Previously in such case, just sha256_generic was loaded and
not sha256_ssse3 (since it did not provide sha224). Now if 'sha256' was used
after 'sha224' usage, sha256_ssse3 would remain unloaded.

Cc: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
---
 arch/x86/crypto/sha256_ssse3_glue.c |   57 ++++++++++++++++++++++++++++++++---
 1 file changed, 52 insertions(+), 5 deletions(-)

diff --git a/arch/x86/crypto/sha256_ssse3_glue.c b/arch/x86/crypto/sha256_ssse3_glue.c
index 597d4da..50226c4 100644
--- a/arch/x86/crypto/sha256_ssse3_glue.c
+++ b/arch/x86/crypto/sha256_ssse3_glue.c
@@ -187,7 +187,36 @@ static int sha256_ssse3_import(struct shash_desc *desc, const void *in)
 	return 0;
 }
 
-static struct shash_alg alg = {
+static int sha224_ssse3_init(struct shash_desc *desc)
+{
+	struct sha256_state *sctx = shash_desc_ctx(desc);
+
+	sctx->state[0] = SHA224_H0;
+	sctx->state[1] = SHA224_H1;
+	sctx->state[2] = SHA224_H2;
+	sctx->state[3] = SHA224_H3;
+	sctx->state[4] = SHA224_H4;
+	sctx->state[5] = SHA224_H5;
+	sctx->state[6] = SHA224_H6;
+	sctx->state[7] = SHA224_H7;
+	sctx->count = 0;
+
+	return 0;
+}
+
+static int sha224_ssse3_final(struct shash_desc *desc, u8 *hash)
+{
+	u8 D[SHA256_DIGEST_SIZE];
+
+	sha256_ssse3_final(desc, D);
+
+	memcpy(hash, D, SHA224_DIGEST_SIZE);
+	memset(D, 0, SHA256_DIGEST_SIZE);
+
+	return 0;
+}
+
+static struct shash_alg algs[] = { {
 	.digestsize	=	SHA256_DIGEST_SIZE,
 	.init		=	sha256_ssse3_init,
 	.update		=	sha256_ssse3_update,
@@ -204,7 +233,24 @@ static struct shash_alg alg = {
 		.cra_blocksize	=	SHA256_BLOCK_SIZE,
 		.cra_module	=	THIS_MODULE,
 	}
-};
+}, {
+	.digestsize	=	SHA224_DIGEST_SIZE,
+	.init		=	sha224_ssse3_init,
+	.update		=	sha256_ssse3_update,
+	.final		=	sha224_ssse3_final,
+	.export		=	sha256_ssse3_export,
+	.import		=	sha256_ssse3_import,
+	.descsize	=	sizeof(struct sha256_state),
+	.statesize	=	sizeof(struct sha256_state),
+	.base		=	{
+		.cra_name	=	"sha224",
+		.cra_driver_name =	"sha224-ssse3",
+		.cra_priority	=	150,
+		.cra_flags	=	CRYPTO_ALG_TYPE_SHASH,
+		.cra_blocksize	=	SHA224_BLOCK_SIZE,
+		.cra_module	=	THIS_MODULE,
+	}
+} };
 
 #ifdef CONFIG_AS_AVX
 static bool __init avx_usable(void)
@@ -227,7 +273,7 @@ static bool __init avx_usable(void)
 
 static int __init sha256_ssse3_mod_init(void)
 {
-	/* test for SSE3 first */
+	/* test for SSSE3 first */
 	if (cpu_has_ssse3)
 		sha256_transform_asm = sha256_transform_ssse3;
 
@@ -254,7 +300,7 @@ static int __init sha256_ssse3_mod_init(void)
 		else
 #endif
 			pr_info("Using SSSE3 optimized SHA-256 implementation\n");
-		return crypto_register_shash(&alg);
+		return crypto_register_shashes(algs, ARRAY_SIZE(algs));
 	}
 	pr_info("Neither AVX nor SSSE3 is available/usable.\n");
 
@@ -263,7 +309,7 @@ static int __init sha256_ssse3_mod_init(void)
 
 static void __exit sha256_ssse3_mod_fini(void)
 {
-	crypto_unregister_shash(&alg);
+	crypto_unregister_shashes(algs, ARRAY_SIZE(algs));
 }
 
 module_init(sha256_ssse3_mod_init);
@@ -273,3 +319,4 @@ MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("SHA256 Secure Hash Algorithm, Supplemental SSE3 accelerated");
 
 MODULE_ALIAS("sha256");
+MODULE_ALIAS("sha384");
