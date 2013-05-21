From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Subject: [PATCH 1/2] crypto: sha512_ssse3 - add sha384 support
Date: Tue, 21 May 2013 17:10:44 +0300
Message-ID: <20130521141044.16352.75962.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Tim Chen <tim.c.chen@linux.intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:51204 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475Ab3EUOKr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 21 May 2013 10:10:47 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add sha384 implementation to sha512_ssse3 module.

This also fixes sha512_ssse3 module autoloading issue when 'sha384' is used
before 'sha512'. Previously in such case, just sha512_generic was loaded and
not sha512_ssse3 (since it did not provide sha384). Now if 'sha512' was used
after 'sha384' usage, sha512_ssse3 would remain unloaded. For example, this
happens with tcrypt testing module since it tests 'sha384' before 'sha512'.

Cc: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
---
 arch/x86/crypto/sha512_ssse3_glue.c |   58 ++++++++++++++++++++++++++++++++---
 1 file changed, 53 insertions(+), 5 deletions(-)

diff --git a/arch/x86/crypto/sha512_ssse3_glue.c b/arch/x86/crypto/sha512_ssse3_glue.c
index 6cbd8df..f30cd10 100644
--- a/arch/x86/crypto/sha512_ssse3_glue.c
+++ b/arch/x86/crypto/sha512_ssse3_glue.c
@@ -194,7 +194,37 @@ static int sha512_ssse3_import(struct shash_desc *desc, const void *in)
 	return 0;
 }
 
-static struct shash_alg alg = {
+static int sha384_ssse3_init(struct shash_desc *desc)
+{
+	struct sha512_state *sctx = shash_desc_ctx(desc);
+
+	sctx->state[0] = SHA384_H0;
+	sctx->state[1] = SHA384_H1;
+	sctx->state[2] = SHA384_H2;
+	sctx->state[3] = SHA384_H3;
+	sctx->state[4] = SHA384_H4;
+	sctx->state[5] = SHA384_H5;
+	sctx->state[6] = SHA384_H6;
+	sctx->state[7] = SHA384_H7;
+
+	sctx->count[0] = sctx->count[1] = 0;
+
+	return 0;
+}
+
+static int sha384_ssse3_final(struct shash_desc *desc, u8 *hash)
+{
+	u8 D[SHA512_DIGEST_SIZE];
+
+	sha512_ssse3_final(desc, D);
+
+	memcpy(hash, D, SHA384_DIGEST_SIZE);
+	memset(D, 0, SHA512_DIGEST_SIZE);
+
+	return 0;
+}
+
+static struct shash_alg algs[] = { {
 	.digestsize	=	SHA512_DIGEST_SIZE,
 	.init		=	sha512_ssse3_init,
 	.update		=	sha512_ssse3_update,
@@ -211,7 +241,24 @@ static struct shash_alg alg = {
 		.cra_blocksize	=	SHA512_BLOCK_SIZE,
 		.cra_module	=	THIS_MODULE,
 	}
-};
+},  {
+	.digestsize	=	SHA384_DIGEST_SIZE,
+	.init		=	sha384_ssse3_init,
+	.update		=	sha512_ssse3_update,
+	.final		=	sha384_ssse3_final,
+	.export		=	sha512_ssse3_export,
+	.import		=	sha512_ssse3_import,
+	.descsize	=	sizeof(struct sha512_state),
+	.statesize	=	sizeof(struct sha512_state),
+	.base		=	{
+		.cra_name	=	"sha384",
+		.cra_driver_name =	"sha384-ssse3",
+		.cra_priority	=	150,
+		.cra_flags	=	CRYPTO_ALG_TYPE_SHASH,
+		.cra_blocksize	=	SHA384_BLOCK_SIZE,
+		.cra_module	=	THIS_MODULE,
+	}
+} };
 
 #ifdef CONFIG_AS_AVX
 static bool __init avx_usable(void)
@@ -234,7 +281,7 @@ static bool __init avx_usable(void)
 
 static int __init sha512_ssse3_mod_init(void)
 {
-	/* test for SSE3 first */
+	/* test for SSSE3 first */
 	if (cpu_has_ssse3)
 		sha512_transform_asm = sha512_transform_ssse3;
 
@@ -261,7 +308,7 @@ static int __init sha512_ssse3_mod_init(void)
 		else
 #endif
 			pr_info("Using SSSE3 optimized SHA-512 implementation\n");
-		return crypto_register_shash(&alg);
+		return crypto_register_shashes(algs, ARRAY_SIZE(algs));
 	}
 	pr_info("Neither AVX nor SSSE3 is available/usable.\n");
 
@@ -270,7 +317,7 @@ static int __init sha512_ssse3_mod_init(void)
 
 static void __exit sha512_ssse3_mod_fini(void)
 {
-	crypto_unregister_shash(&alg);
+	crypto_unregister_shashes(algs, ARRAY_SIZE(algs));
 }
 
 module_init(sha512_ssse3_mod_init);
@@ -280,3 +327,4 @@ MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("SHA512 Secure Hash Algorithm, Supplemental SSE3 accelerated");
 
 MODULE_ALIAS("sha512");
+MODULE_ALIAS("sha384");
