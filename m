From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 2/5] crypto/generic: sha3 - simplify code
Date: Fri, 12 Jan 2018 13:15:19 +0000
Message-ID: <20180112131522.25663-3-ard.biesheuvel@linaro.org>
References: <20180112131522.25663-1-ard.biesheuvel@linaro.org>
Cc: herbert@gondor.apana.org.au, will.deacon@arm.com,
        catalin.marinas@arm.com, steve.capper@linaro.org,
        jgarzik@redhat.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:46706 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933581AbeALNPl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Jan 2018 08:15:41 -0500
Received: by mail-wr0-f196.google.com with SMTP id g21so5245515wrb.13
        for <linux-crypto@vger.kernel.org>; Fri, 12 Jan 2018 05:15:41 -0800 (PST)
In-Reply-To: <20180112131522.25663-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In preparation of exposing the generic SHA3 implementation to other
versions as a fallback, simplify the code, and remove an inconsistency
in the output handling (endian swabbing rsizw words of state before
writing the output does not make sense)

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/sha3_generic.c | 184 +++++++-------------
 include/crypto/sha3.h |   1 -
 2 files changed, 59 insertions(+), 126 deletions(-)

diff --git a/crypto/sha3_generic.c b/crypto/sha3_generic.c
index a68be626017c..677247d429a1 100644
--- a/crypto/sha3_generic.c
+++ b/crypto/sha3_generic.c
@@ -17,7 +17,6 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <crypto/sha3.h>
-#include <asm/byteorder.h>
 #include <asm/unaligned.h>
 
 #define KECCAK_ROUNDS 24
@@ -88,43 +87,16 @@ static void keccakf(u64 st[25])
 	}
 }
 
-static void sha3_init(struct sha3_state *sctx, unsigned int digest_sz)
-{
-	memset(sctx, 0, sizeof(*sctx));
-	sctx->md_len = digest_sz;
-	sctx->rsiz = 200 - 2 * digest_sz;
-	sctx->rsizw = sctx->rsiz / 8;
-}
-
-static int sha3_224_init(struct shash_desc *desc)
+static int sha3_init(struct shash_desc *desc)
 {
 	struct sha3_state *sctx = shash_desc_ctx(desc);
+	unsigned int digest_size = crypto_shash_digestsize(desc->tfm);
 
-	sha3_init(sctx, SHA3_224_DIGEST_SIZE);
-	return 0;
-}
-
-static int sha3_256_init(struct shash_desc *desc)
-{
-	struct sha3_state *sctx = shash_desc_ctx(desc);
-
-	sha3_init(sctx, SHA3_256_DIGEST_SIZE);
-	return 0;
-}
-
-static int sha3_384_init(struct shash_desc *desc)
-{
-	struct sha3_state *sctx = shash_desc_ctx(desc);
-
-	sha3_init(sctx, SHA3_384_DIGEST_SIZE);
-	return 0;
-}
-
-static int sha3_512_init(struct shash_desc *desc)
-{
-	struct sha3_state *sctx = shash_desc_ctx(desc);
+	sctx->rsiz = 200 - 2 * digest_size;
+	sctx->rsizw = sctx->rsiz / 8;
+	sctx->partial = 0;
 
-	sha3_init(sctx, SHA3_512_DIGEST_SIZE);
+	memset(sctx->st, 0, sizeof(sctx->st));
 	return 0;
 }
 
@@ -169,6 +141,8 @@ static int sha3_final(struct shash_desc *desc, u8 *out)
 {
 	struct sha3_state *sctx = shash_desc_ctx(desc);
 	unsigned int i, inlen = sctx->partial;
+	unsigned int digest_size = crypto_shash_digestsize(desc->tfm);
+	__le64 *digest = (__le64 *)out;
 
 	sctx->buf[inlen++] = 0x06;
 	memset(sctx->buf + inlen, 0, sctx->rsiz - inlen);
@@ -179,110 +153,70 @@ static int sha3_final(struct shash_desc *desc, u8 *out)
 
 	keccakf(sctx->st);
 
-	for (i = 0; i < sctx->rsizw; i++)
-		sctx->st[i] = cpu_to_le64(sctx->st[i]);
+	for (i = 0; i < digest_size / 8; i++)
+		put_unaligned_le64(sctx->st[i], digest++);
 
-	memcpy(out, sctx->st, sctx->md_len);
+	if (digest_size & 4)
+		put_unaligned_le32(sctx->st[i], (__le32 *)digest);
 
 	memset(sctx, 0, sizeof(*sctx));
 	return 0;
 }
 
-static struct shash_alg sha3_224 = {
-	.digestsize	=	SHA3_224_DIGEST_SIZE,
-	.init		=	sha3_224_init,
-	.update		=	sha3_update,
-	.final		=	sha3_final,
-	.descsize	=	sizeof(struct sha3_state),
-	.base		=	{
-		.cra_name	=	"sha3-224",
-		.cra_driver_name =	"sha3-224-generic",
-		.cra_flags	=	CRYPTO_ALG_TYPE_SHASH,
-		.cra_blocksize	=	SHA3_224_BLOCK_SIZE,
-		.cra_module	=	THIS_MODULE,
-	}
-};
-
-static struct shash_alg sha3_256 = {
-	.digestsize	=	SHA3_256_DIGEST_SIZE,
-	.init		=	sha3_256_init,
-	.update		=	sha3_update,
-	.final		=	sha3_final,
-	.descsize	=	sizeof(struct sha3_state),
-	.base		=	{
-		.cra_name	=	"sha3-256",
-		.cra_driver_name =	"sha3-256-generic",
-		.cra_flags	=	CRYPTO_ALG_TYPE_SHASH,
-		.cra_blocksize	=	SHA3_256_BLOCK_SIZE,
-		.cra_module	=	THIS_MODULE,
-	}
-};
-
-static struct shash_alg sha3_384 = {
-	.digestsize	=	SHA3_384_DIGEST_SIZE,
-	.init		=	sha3_384_init,
-	.update		=	sha3_update,
-	.final		=	sha3_final,
-	.descsize	=	sizeof(struct sha3_state),
-	.base		=	{
-		.cra_name	=	"sha3-384",
-		.cra_driver_name =	"sha3-384-generic",
-		.cra_flags	=	CRYPTO_ALG_TYPE_SHASH,
-		.cra_blocksize	=	SHA3_384_BLOCK_SIZE,
-		.cra_module	=	THIS_MODULE,
-	}
-};
-
-static struct shash_alg sha3_512 = {
-	.digestsize	=	SHA3_512_DIGEST_SIZE,
-	.init		=	sha3_512_init,
-	.update		=	sha3_update,
-	.final		=	sha3_final,
-	.descsize	=	sizeof(struct sha3_state),
-	.base		=	{
-		.cra_name	=	"sha3-512",
-		.cra_driver_name =	"sha3-512-generic",
-		.cra_flags	=	CRYPTO_ALG_TYPE_SHASH,
-		.cra_blocksize	=	SHA3_512_BLOCK_SIZE,
-		.cra_module	=	THIS_MODULE,
-	}
-};
+static struct shash_alg algs[] = { {
+	.digestsize		= SHA3_224_DIGEST_SIZE,
+	.init			= sha3_init,
+	.update			= sha3_update,
+	.final			= sha3_final,
+	.descsize		= sizeof(struct sha3_state),
+	.base.cra_name		= "sha3-224",
+	.base.cra_driver_name	= "sha3-224-generic",
+	.base.cra_flags		= CRYPTO_ALG_TYPE_SHASH,
+	.base.cra_blocksize	= SHA3_224_BLOCK_SIZE,
+	.base.cra_module	= THIS_MODULE,
+}, {
+	.digestsize		= SHA3_256_DIGEST_SIZE,
+	.init			= sha3_init,
+	.update			= sha3_update,
+	.final			= sha3_final,
+	.descsize		= sizeof(struct sha3_state),
+	.base.cra_name		= "sha3-256",
+	.base.cra_driver_name	= "sha3-256-generic",
+	.base.cra_flags		= CRYPTO_ALG_TYPE_SHASH,
+	.base.cra_blocksize	= SHA3_256_BLOCK_SIZE,
+	.base.cra_module	= THIS_MODULE,
+}, {
+	.digestsize		= SHA3_384_DIGEST_SIZE,
+	.init			= sha3_init,
+	.update			= sha3_update,
+	.final			= sha3_final,
+	.descsize		= sizeof(struct sha3_state),
+	.base.cra_name		= "sha3-384",
+	.base.cra_driver_name	= "sha3-384-generic",
+	.base.cra_flags		= CRYPTO_ALG_TYPE_SHASH,
+	.base.cra_blocksize	= SHA3_384_BLOCK_SIZE,
+	.base.cra_module	= THIS_MODULE,
+}, {
+	.digestsize		= SHA3_512_DIGEST_SIZE,
+	.init			= sha3_init,
+	.update			= sha3_update,
+	.final			= sha3_final,
+	.descsize		= sizeof(struct sha3_state),
+	.base.cra_name		= "sha3-512",
+	.base.cra_driver_name	= "sha3-512-generic",
+	.base.cra_flags		= CRYPTO_ALG_TYPE_SHASH,
+	.base.cra_blocksize	= SHA3_512_BLOCK_SIZE,
+	.base.cra_module	= THIS_MODULE,
+} };
 
 static int __init sha3_generic_mod_init(void)
 {
-	int ret;
-
-	ret = crypto_register_shash(&sha3_224);
-	if (ret < 0)
-		goto err_out;
-	ret = crypto_register_shash(&sha3_256);
-	if (ret < 0)
-		goto err_out_224;
-	ret = crypto_register_shash(&sha3_384);
-	if (ret < 0)
-		goto err_out_256;
-	ret = crypto_register_shash(&sha3_512);
-	if (ret < 0)
-		goto err_out_384;
-
-	return 0;
-
-err_out_384:
-	crypto_unregister_shash(&sha3_384);
-err_out_256:
-	crypto_unregister_shash(&sha3_256);
-err_out_224:
-	crypto_unregister_shash(&sha3_224);
-err_out:
-	return ret;
+	return crypto_register_shashes(algs, ARRAY_SIZE(algs));
 }
 
 static void __exit sha3_generic_mod_fini(void)
 {
-	crypto_unregister_shash(&sha3_224);
-	crypto_unregister_shash(&sha3_256);
-	crypto_unregister_shash(&sha3_384);
-	crypto_unregister_shash(&sha3_512);
+	crypto_unregister_shashes(algs, ARRAY_SIZE(algs));
 }
 
 module_init(sha3_generic_mod_init);
diff --git a/include/crypto/sha3.h b/include/crypto/sha3.h
index b9d9bd553b48..1339dcdbc9b2 100644
--- a/include/crypto/sha3.h
+++ b/include/crypto/sha3.h
@@ -19,7 +19,6 @@
 
 struct sha3_state {
 	u64		st[25];
-	unsigned int	md_len;
 	unsigned int	rsiz;
 	unsigned int	rsizw;
 
-- 
2.11.0
