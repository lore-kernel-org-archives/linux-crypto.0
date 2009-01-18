From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: crypto: sha-s390 - Switch to shash
Date: Mon, 19 Jan 2009 09:55:17 +1100
Message-ID: <20090118225517.GA30510@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:40921 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752527AbZARWzY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 18 Jan 2009 17:55:24 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Martin:

Could you let me if this patch breaks s390?

commit 0fe7dddf02811152d7e58747bfe419ec0f43ea4e
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Sun Jan 18 20:33:33 2009 +1100

    crypto: sha-s390 - Switch to shash
    
    This patch converts the S390 sha algorithms to the new shash interface.
    
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/arch/s390/crypto/sha.h b/arch/s390/crypto/sha.h
index 1ceafa5..f4e9dc7 100644
--- a/arch/s390/crypto/sha.h
+++ b/arch/s390/crypto/sha.h
@@ -29,7 +29,9 @@ struct s390_sha_ctx {
 	int func;		/* KIMD function to use */
 };
 
-void s390_sha_update(struct crypto_tfm *tfm, const u8 *data, unsigned int len);
-void s390_sha_final(struct crypto_tfm *tfm, u8 *out);
+struct shash_desc;
+
+int s390_sha_update(struct shash_desc *desc, const u8 *data, unsigned int len);
+int s390_sha_final(struct shash_desc *desc, u8 *out);
 
 #endif
diff --git a/arch/s390/crypto/sha1_s390.c b/arch/s390/crypto/sha1_s390.c
index b3cb5a8..e85ba34 100644
--- a/arch/s390/crypto/sha1_s390.c
+++ b/arch/s390/crypto/sha1_s390.c
@@ -23,17 +23,17 @@
  * any later version.
  *
  */
+#include <crypto/internal/hash.h>
 #include <linux/init.h>
 #include <linux/module.h>
-#include <linux/crypto.h>
 #include <crypto/sha.h>
 
 #include "crypt_s390.h"
 #include "sha.h"
 
-static void sha1_init(struct crypto_tfm *tfm)
+static int sha1_init(struct shash_desc *desc)
 {
-	struct s390_sha_ctx *sctx = crypto_tfm_ctx(tfm);
+	struct s390_sha_ctx *sctx = shash_desc_ctx(desc);
 
 	sctx->state[0] = SHA1_H0;
 	sctx->state[1] = SHA1_H1;
@@ -42,34 +42,36 @@ static void sha1_init(struct crypto_tfm *tfm)
 	sctx->state[4] = SHA1_H4;
 	sctx->count = 0;
 	sctx->func = KIMD_SHA_1;
+
+	return 0;
 }
 
-static struct crypto_alg alg = {
-	.cra_name	=	"sha1",
-	.cra_driver_name=	"sha1-s390",
-	.cra_priority	=	CRYPT_S390_PRIORITY,
-	.cra_flags	=	CRYPTO_ALG_TYPE_DIGEST,
-	.cra_blocksize	=	SHA1_BLOCK_SIZE,
-	.cra_ctxsize	=	sizeof(struct s390_sha_ctx),
-	.cra_module	=	THIS_MODULE,
-	.cra_list	=	LIST_HEAD_INIT(alg.cra_list),
-	.cra_u		=	{ .digest = {
-	.dia_digestsize	=	SHA1_DIGEST_SIZE,
-	.dia_init	=	sha1_init,
-	.dia_update	=	s390_sha_update,
-	.dia_final	=	s390_sha_final } }
+static struct shash_alg alg = {
+	.digestsize	=	SHA1_DIGEST_SIZE,
+	.init		=	sha1_init,
+	.update		=	s390_sha_update,
+	.final		=	s390_sha_final,
+	.descsize	=	sizeof(struct s390_sha_ctx),
+	.base		=	{
+		.cra_name	=	"sha1",
+		.cra_driver_name=	"sha1-s390",
+		.cra_priority	=	CRYPT_S390_PRIORITY,
+		.cra_flags	=	CRYPTO_ALG_TYPE_SHASH,
+		.cra_blocksize	=	SHA1_BLOCK_SIZE,
+		.cra_module	=	THIS_MODULE,
+	}
 };
 
 static int __init sha1_s390_init(void)
 {
 	if (!crypt_s390_func_available(KIMD_SHA_1))
 		return -EOPNOTSUPP;
-	return crypto_register_alg(&alg);
+	return crypto_register_shash(&alg);
 }
 
 static void __exit sha1_s390_fini(void)
 {
-	crypto_unregister_alg(&alg);
+	crypto_unregister_shash(&alg);
 }
 
 module_init(sha1_s390_init);
diff --git a/arch/s390/crypto/sha256_s390.c b/arch/s390/crypto/sha256_s390.c
index 19c03fb..249619d 100644
--- a/arch/s390/crypto/sha256_s390.c
+++ b/arch/s390/crypto/sha256_s390.c
@@ -16,17 +16,17 @@
  * any later version.
  *
  */
+#include <crypto/internal/hash.h>
 #include <linux/init.h>
 #include <linux/module.h>
-#include <linux/crypto.h>
 #include <crypto/sha.h>
 
 #include "crypt_s390.h"
 #include "sha.h"
 
-static void sha256_init(struct crypto_tfm *tfm)
+static int sha256_init(struct shash_desc *desc)
 {
-	struct s390_sha_ctx *sctx = crypto_tfm_ctx(tfm);
+	struct s390_sha_ctx *sctx = shash_desc_ctx(tfm);
 
 	sctx->state[0] = SHA256_H0;
 	sctx->state[1] = SHA256_H1;
@@ -38,22 +38,24 @@ static void sha256_init(struct crypto_tfm *tfm)
 	sctx->state[7] = SHA256_H7;
 	sctx->count = 0;
 	sctx->func = KIMD_SHA_256;
+
+	return 0;
 }
 
-static struct crypto_alg alg = {
-	.cra_name	=	"sha256",
-	.cra_driver_name =	"sha256-s390",
-	.cra_priority	=	CRYPT_S390_PRIORITY,
-	.cra_flags	=	CRYPTO_ALG_TYPE_DIGEST,
-	.cra_blocksize	=	SHA256_BLOCK_SIZE,
-	.cra_ctxsize	=	sizeof(struct s390_sha_ctx),
-	.cra_module	=	THIS_MODULE,
-	.cra_list	=	LIST_HEAD_INIT(alg.cra_list),
-	.cra_u		=	{ .digest = {
-	.dia_digestsize	=	SHA256_DIGEST_SIZE,
-	.dia_init	=	sha256_init,
-	.dia_update	=	s390_sha_update,
-	.dia_final	=	s390_sha_final } }
+static struct shash_alg alg = {
+	.digestsize	=	SHA256_DIGEST_SIZE,
+	.init		=	sha256_init,
+	.update		=	s390_sha_update,
+	.final		=	s390_sha_final,
+	.descsize	=	sizeof(struct s390_sha_ctx),
+	.base		=	{
+		.cra_name	=	"sha256",
+		.cra_driver_name=	"sha256-s390",
+		.cra_priority	=	CRYPT_S390_PRIORITY,
+		.cra_flags	=	CRYPTO_ALG_TYPE_SHASH,
+		.cra_blocksize	=	SHA256_BLOCK_SIZE,
+		.cra_module	=	THIS_MODULE,
+	}
 };
 
 static int sha256_s390_init(void)
@@ -61,12 +63,12 @@ static int sha256_s390_init(void)
 	if (!crypt_s390_func_available(KIMD_SHA_256))
 		return -EOPNOTSUPP;
 
-	return crypto_register_alg(&alg);
+	return crypto_register_shash(&alg);
 }
 
 static void __exit sha256_s390_fini(void)
 {
-	crypto_unregister_alg(&alg);
+	crypto_unregister_shash(&alg);
 }
 
 module_init(sha256_s390_init);
diff --git a/arch/s390/crypto/sha512_s390.c b/arch/s390/crypto/sha512_s390.c
index 23c7861..420acf4 100644
--- a/arch/s390/crypto/sha512_s390.c
+++ b/arch/s390/crypto/sha512_s390.c
@@ -12,16 +12,16 @@
  * any later version.
  *
  */
+#include <crypto/internal/hash.h>
 #include <linux/init.h>
 #include <linux/module.h>
-#include <linux/crypto.h>
 
 #include "sha.h"
 #include "crypt_s390.h"
 
-static void sha512_init(struct crypto_tfm *tfm)
+static int sha512_init(struct shash_desc *desc)
 {
-	struct s390_sha_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct s390_sha_ctx *ctx = shash_desc_ctx(desc);
 
 	*(__u64 *)&ctx->state[0] = 0x6a09e667f3bcc908ULL;
 	*(__u64 *)&ctx->state[2] = 0xbb67ae8584caa73bULL;
@@ -33,29 +33,31 @@ static void sha512_init(struct crypto_tfm *tfm)
 	*(__u64 *)&ctx->state[14] = 0x5be0cd19137e2179ULL;
 	ctx->count = 0;
 	ctx->func = KIMD_SHA_512;
+
+	return 0;
 }
 
-static struct crypto_alg sha512_alg = {
-	.cra_name	=	"sha512",
-	.cra_driver_name =	"sha512-s390",
-	.cra_priority	=	CRYPT_S390_PRIORITY,
-	.cra_flags	=	CRYPTO_ALG_TYPE_DIGEST,
-	.cra_blocksize	=	SHA512_BLOCK_SIZE,
-	.cra_ctxsize	=	sizeof(struct s390_sha_ctx),
-	.cra_module	=	THIS_MODULE,
-	.cra_list	=	LIST_HEAD_INIT(sha512_alg.cra_list),
-	.cra_u		=	{ .digest = {
-	.dia_digestsize	=	SHA512_DIGEST_SIZE,
-	.dia_init	=	sha512_init,
-	.dia_update	=	s390_sha_update,
-	.dia_final	=	s390_sha_final } }
+static struct shash_alg sha512_alg = {
+	.digestsize	=	SHA512_DIGEST_SIZE,
+	.init		=	sha512_init,
+	.update		=	s390_sha_update,
+	.final		=	s390_sha_final,
+	.descsize	=	sizeof(struct s390_sha_ctx),
+	.base		=	{
+		.cra_name	=	"sha512",
+		.cra_driver_name=	"sha512-s390",
+		.cra_priority	=	CRYPT_S390_PRIORITY,
+		.cra_flags	=	CRYPTO_ALG_TYPE_SHASH,
+		.cra_blocksize	=	SHA512_BLOCK_SIZE,
+		.cra_module	=	THIS_MODULE,
+	}
 };
 
 MODULE_ALIAS("sha512");
 
-static void sha384_init(struct crypto_tfm *tfm)
+static int sha384_init(struct shash_desc *desc)
 {
-	struct s390_sha_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct s390_sha_ctx *ctx = shash_desc_ctx(desc);
 
 	*(__u64 *)&ctx->state[0] = 0xcbbb9d5dc1059ed8ULL;
 	*(__u64 *)&ctx->state[2] = 0x629a292a367cd507ULL;
@@ -67,22 +69,24 @@ static void sha384_init(struct crypto_tfm *tfm)
 	*(__u64 *)&ctx->state[14] = 0x47b5481dbefa4fa4ULL;
 	ctx->count = 0;
 	ctx->func = KIMD_SHA_512;
+
+	return 0;
 }
 
-static struct crypto_alg sha384_alg = {
-	.cra_name	=	"sha384",
-	.cra_driver_name =	"sha384-s390",
-	.cra_priority	=	CRYPT_S390_PRIORITY,
-	.cra_flags	=	CRYPTO_ALG_TYPE_DIGEST,
-	.cra_blocksize	=	SHA384_BLOCK_SIZE,
-	.cra_ctxsize	=	sizeof(struct s390_sha_ctx),
-	.cra_module	=	THIS_MODULE,
-	.cra_list	=	LIST_HEAD_INIT(sha384_alg.cra_list),
-	.cra_u		=	{ .digest = {
-	.dia_digestsize	=	SHA384_DIGEST_SIZE,
-	.dia_init	=	sha384_init,
-	.dia_update	=	s390_sha_update,
-	.dia_final	=	s390_sha_final } }
+static struct shash_alg sha384_alg = {
+	.digestsize	=	SHA384_DIGEST_SIZE,
+	.init		=	sha384_init,
+	.update		=	s390_sha_update,
+	.final		=	s390_sha_final,
+	.descsize	=	sizeof(struct s390_sha_ctx),
+	.base		=	{
+		.cra_name	=	"sha384",
+		.cra_driver_name=	"sha384-s390",
+		.cra_priority	=	CRYPT_S390_PRIORITY,
+		.cra_flags	=	CRYPTO_ALG_TYPE_SHASH,
+		.cra_ctxsize	=	sizeof(struct s390_sha_ctx),
+		.cra_module	=	THIS_MODULE,
+	}
 };
 
 MODULE_ALIAS("sha384");
@@ -93,18 +97,18 @@ static int __init init(void)
 
 	if (!crypt_s390_func_available(KIMD_SHA_512))
 		return -EOPNOTSUPP;
-	if ((ret = crypto_register_alg(&sha512_alg)) < 0)
+	if ((ret = crypto_register_shash(&sha512_alg)) < 0)
 		goto out;
-	if ((ret = crypto_register_alg(&sha384_alg)) < 0)
-		crypto_unregister_alg(&sha512_alg);
+	if ((ret = crypto_register_shash(&sha384_alg)) < 0)
+		crypto_unregister_shash(&sha512_alg);
 out:
 	return ret;
 }
 
 static void __exit fini(void)
 {
-	crypto_unregister_alg(&sha512_alg);
-	crypto_unregister_alg(&sha384_alg);
+	crypto_unregister_shash(&sha512_alg);
+	crypto_unregister_shash(&sha384_alg);
 }
 
 module_init(init);
diff --git a/arch/s390/crypto/sha_common.c b/arch/s390/crypto/sha_common.c
index 9d6eb8c..7903ec4 100644
--- a/arch/s390/crypto/sha_common.c
+++ b/arch/s390/crypto/sha_common.c
@@ -13,14 +13,14 @@
  *
  */
 
-#include <linux/crypto.h>
+#include <crypto/internal/hash.h>
 #include "sha.h"
 #include "crypt_s390.h"
 
-void s390_sha_update(struct crypto_tfm *tfm, const u8 *data, unsigned int len)
+int s390_sha_update(struct shash_desc *desc, const u8 *data, unsigned int len)
 {
-	struct s390_sha_ctx *ctx = crypto_tfm_ctx(tfm);
-	unsigned int bsize = crypto_tfm_alg_blocksize(tfm);
+	struct s390_sha_ctx *ctx = shash_desc_ctx(desc);
+	unsigned int bsize = crypto_shash_blocksize(desc->tfm);
 	unsigned int index;
 	int ret;
 
@@ -51,13 +51,15 @@ void s390_sha_update(struct crypto_tfm *tfm, const u8 *data, unsigned int len)
 store:
 	if (len)
 		memcpy(ctx->buf + index , data, len);
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(s390_sha_update);
 
-void s390_sha_final(struct crypto_tfm *tfm, u8 *out)
+int s390_sha_final(struct shash_desc *desc, u8 *out)
 {
-	struct s390_sha_ctx *ctx = crypto_tfm_ctx(tfm);
-	unsigned int bsize = crypto_tfm_alg_blocksize(tfm);
+	struct s390_sha_ctx *ctx = shash_desc_ctx(desc);
+	unsigned int bsize = crypto_shash_blocksize(desc->tfm);
 	u64 bits;
 	unsigned int index, end, plen;
 	int ret;
@@ -87,9 +89,11 @@ void s390_sha_final(struct crypto_tfm *tfm, u8 *out)
 	BUG_ON(ret != end);
 
 	/* copy digest to out */
-	memcpy(out, ctx->state, crypto_hash_digestsize(crypto_hash_cast(tfm)));
+	memcpy(out, ctx->state, crypto_shash_digestsize(desc->tfm));
 	/* wipe context */
 	memset(ctx, 0, sizeof *ctx);
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(s390_sha_final);
 
diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index e522144..5adbae7 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -86,7 +86,7 @@ config ZCRYPT_MONOLITHIC
 config CRYPTO_SHA1_S390
 	tristate "SHA1 digest algorithm"
 	depends on S390
-	select CRYPTO_ALGAPI
+	select CRYPTO_HASH
 	help
 	  This is the s390 hardware accelerated implementation of the
 	  SHA-1 secure hash standard (FIPS 180-1/DFIPS 180-2).
@@ -94,7 +94,7 @@ config CRYPTO_SHA1_S390
 config CRYPTO_SHA256_S390
 	tristate "SHA256 digest algorithm"
 	depends on S390
-	select CRYPTO_ALGAPI
+	select CRYPTO_HASH
 	help
 	  This is the s390 hardware accelerated implementation of the
 	  SHA256 secure hash standard (DFIPS 180-2).
@@ -105,7 +105,7 @@ config CRYPTO_SHA256_S390
 config CRYPTO_SHA512_S390
 	tristate "SHA384 and SHA512 digest algorithm"
 	depends on S390
-	select CRYPTO_ALGAPI
+	select CRYPTO_HASH
 	help
 	  This is the s390 hardware accelerated implementation of the
 	  SHA512 secure hash standard.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
