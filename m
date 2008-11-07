From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 8/10] crypto: crc32c - Switch to shash
Date: Fri, 07 Nov 2008 16:37:03 +0800
Message-ID: <E1KyMpz-0002lP-6x@gondolin.me.apana.org.au>
References: <20081107083536.GA10169@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:39129 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751609AbYKGIhG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Nov 2008 03:37:06 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1KyMpz-0006AX-DX
	for <linux-crypto@vger.kernel.org>; Fri, 07 Nov 2008 19:37:03 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: crc32c - Switch to shash

This patch changes crc32c to the new shash interface.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/crc32c.c |  185 ++++++++++++++++----------------------------------------
 1 file changed, 53 insertions(+), 132 deletions(-)

diff --git a/crypto/crc32c.c b/crypto/crc32c.c
index a882d9e..b21b93f 100644
--- a/crypto/crc32c.c
+++ b/crypto/crc32c.c
@@ -25,20 +25,26 @@
 #define CHKSUM_DIGEST_SIZE	4
 
 struct chksum_ctx {
-	u32 crc;
 	u32 key;
 };
 
+struct chksum_desc_ctx {
+	u32 crc;
+};
+
 /*
  * Steps through buffer one byte at at time, calculates reflected 
  * crc using table.
  */
 
-static void chksum_init(struct crypto_tfm *tfm)
+static int chksum_init(struct shash_desc *desc)
 {
-	struct chksum_ctx *mctx = crypto_tfm_ctx(tfm);
+	struct chksum_ctx *mctx = crypto_shash_ctx(desc->tfm);
+	struct chksum_desc_ctx *ctx = shash_desc_ctx(desc);
+
+	ctx->crc = mctx->key;
 
-	mctx->crc = mctx->key;
+	return 0;
 }
 
 /*
@@ -46,180 +52,95 @@ static void chksum_init(struct crypto_tfm *tfm)
  * If your algorithm starts with ~0, then XOR with ~0 before you set
  * the seed.
  */
-static int chksum_setkey(struct crypto_tfm *tfm, const u8 *key,
+static int chksum_setkey(struct crypto_shash *tfm, const u8 *key,
 			 unsigned int keylen)
 {
-	struct chksum_ctx *mctx = crypto_tfm_ctx(tfm);
+	struct chksum_ctx *mctx = crypto_shash_ctx(tfm);
 
-	if (keylen != sizeof(mctx->crc)) {
-		tfm->crt_flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
+	if (keylen != sizeof(mctx->key)) {
+		crypto_shash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
 		return -EINVAL;
 	}
 	mctx->key = le32_to_cpu(*(__le32 *)key);
 	return 0;
 }
 
-static void chksum_update(struct crypto_tfm *tfm, const u8 *data,
-			  unsigned int length)
+static int chksum_update(struct shash_desc *desc, const u8 *data,
+			 unsigned int length)
 {
-	struct chksum_ctx *mctx = crypto_tfm_ctx(tfm);
+	struct chksum_desc_ctx *ctx = shash_desc_ctx(desc);
 
-	mctx->crc = crc32c(mctx->crc, data, length);
-}
-
-static void chksum_final(struct crypto_tfm *tfm, u8 *out)
-{
-	struct chksum_ctx *mctx = crypto_tfm_ctx(tfm);
-	
-	*(__le32 *)out = ~cpu_to_le32(mctx->crc);
-}
-
-static int crc32c_cra_init_old(struct crypto_tfm *tfm)
-{
-	struct chksum_ctx *mctx = crypto_tfm_ctx(tfm);
-
-	mctx->key = ~0;
+	ctx->crc = crc32c(ctx->crc, data, length);
 	return 0;
 }
 
-static struct crypto_alg old_alg = {
-	.cra_name	=	"crc32c",
-	.cra_flags	=	CRYPTO_ALG_TYPE_DIGEST,
-	.cra_blocksize	=	CHKSUM_BLOCK_SIZE,
-	.cra_ctxsize	=	sizeof(struct chksum_ctx),
-	.cra_module	=	THIS_MODULE,
-	.cra_list	=	LIST_HEAD_INIT(old_alg.cra_list),
-	.cra_init	=	crc32c_cra_init_old,
-	.cra_u		=	{
-		.digest = {
-			 .dia_digestsize=	CHKSUM_DIGEST_SIZE,
-			 .dia_setkey	=	chksum_setkey,
-			 .dia_init   	= 	chksum_init,
-			 .dia_update 	=	chksum_update,
-			 .dia_final  	=	chksum_final
-		 }
-	}
-};
-
-/*
- * Setting the seed allows arbitrary accumulators and flexible XOR policy
- * If your algorithm starts with ~0, then XOR with ~0 before you set
- * the seed.
- */
-static int crc32c_setkey(struct crypto_ahash *hash, const u8 *key,
-			 unsigned int keylen)
+static int chksum_final(struct shash_desc *desc, u8 *out)
 {
-	u32 *mctx = crypto_ahash_ctx(hash);
+	struct chksum_desc_ctx *ctx = shash_desc_ctx(desc);
 
-	if (keylen != sizeof(u32)) {
-		crypto_ahash_set_flags(hash, CRYPTO_TFM_RES_BAD_KEY_LEN);
-		return -EINVAL;
-	}
-	*mctx = le32_to_cpup((__le32 *)key);
+	*(__le32 *)out = ~cpu_to_le32p(&ctx->crc);
 	return 0;
 }
 
-static int crc32c_init(struct ahash_request *req)
+static int __chksum_finup(u32 *crcp, const u8 *data, unsigned int len, u8 *out)
 {
-	u32 *mctx = crypto_ahash_ctx(crypto_ahash_reqtfm(req));
-	u32 *crcp = ahash_request_ctx(req);
-
-	*crcp = *mctx;
+	*(__le32 *)out = ~cpu_to_le32(crc32c(*crcp, data, len));
 	return 0;
 }
 
-static int crc32c_update(struct ahash_request *req)
+static int chksum_finup(struct shash_desc *desc, const u8 *data,
+			unsigned int len, u8 *out)
 {
-	struct crypto_hash_walk walk;
-	u32 *crcp = ahash_request_ctx(req);
-	u32 crc = *crcp;
-	int nbytes;
-
-	for (nbytes = crypto_hash_walk_first(req, &walk); nbytes;
-	     nbytes = crypto_hash_walk_done(&walk, 0))
-		crc = crc32c(crc, walk.data, nbytes);
+	struct chksum_desc_ctx *ctx = shash_desc_ctx(desc);
 
-	*crcp = crc;
-	return 0;
+	return __chksum_finup(&ctx->crc, data, len, out);
 }
 
-static int crc32c_final(struct ahash_request *req)
+static int chksum_digest(struct shash_desc *desc, const u8 *data,
+			 unsigned int length, u8 *out)
 {
-	u32 *crcp = ahash_request_ctx(req);
-	
-	*(__le32 *)req->result = ~cpu_to_le32p(crcp);
-	return 0;
-}
+	struct chksum_ctx *mctx = crypto_shash_ctx(desc->tfm);
 
-static int crc32c_digest(struct ahash_request *req)
-{
-	struct crypto_hash_walk walk;
-	u32 *mctx = crypto_ahash_ctx(crypto_ahash_reqtfm(req));
-	u32 crc = *mctx;
-	int nbytes;
-
-	for (nbytes = crypto_hash_walk_first(req, &walk); nbytes;
-	     nbytes = crypto_hash_walk_done(&walk, 0))
-		crc = crc32c(crc, walk.data, nbytes);
-
-	*(__le32 *)req->result = ~cpu_to_le32(crc);
-	return 0;
+	return __chksum_finup(&mctx->key, data, length, out);
 }
 
 static int crc32c_cra_init(struct crypto_tfm *tfm)
 {
-	u32 *key = crypto_tfm_ctx(tfm);
-
-	*key = ~0;
-
-	tfm->crt_ahash.reqsize = sizeof(u32);
+	struct chksum_ctx *mctx = crypto_tfm_ctx(tfm);
 
+	mctx->key = ~0;
 	return 0;
 }
 
-static struct crypto_alg alg = {
-	.cra_name		=	"crc32c",
-	.cra_driver_name	=	"crc32c-generic",
-	.cra_priority		=	100,
-	.cra_flags		=	CRYPTO_ALG_TYPE_AHASH,
-	.cra_blocksize		=	CHKSUM_BLOCK_SIZE,
-	.cra_alignmask		=	3,
-	.cra_ctxsize		=	sizeof(u32),
-	.cra_module		=	THIS_MODULE,
-	.cra_list		=	LIST_HEAD_INIT(alg.cra_list),
-	.cra_init		=	crc32c_cra_init,
-	.cra_type		=	&crypto_ahash_type,
-	.cra_u			=	{
-		.ahash = {
-			 .digestsize	=	CHKSUM_DIGEST_SIZE,
-			 .setkey	=	crc32c_setkey,
-			 .init   	= 	crc32c_init,
-			 .update 	=	crc32c_update,
-			 .final  	=	crc32c_final,
-			 .digest  	=	crc32c_digest,
-		 }
+static struct shash_alg alg = {
+	.digestsize		=	CHKSUM_DIGEST_SIZE,
+	.setkey			=	chksum_setkey,
+	.init   		= 	chksum_init,
+	.update 		=	chksum_update,
+	.final  		=	chksum_final,
+	.finup  		=	chksum_finup,
+	.digest  		=	chksum_digest,
+	.descsize		=	sizeof(struct chksum_desc_ctx),
+	.base			=	{
+		.cra_name		=	"crc32c",
+		.cra_driver_name	=	"crc32c-generic",
+		.cra_priority		=	100,
+		.cra_blocksize		=	CHKSUM_BLOCK_SIZE,
+		.cra_alignmask		=	3,
+		.cra_ctxsize		=	sizeof(struct chksum_ctx),
+		.cra_module		=	THIS_MODULE,
+		.cra_init		=	crc32c_cra_init,
 	}
 };
 
 static int __init crc32c_mod_init(void)
 {
-	int err;
-
-	err = crypto_register_alg(&old_alg);
-	if (err)
-		return err;
-
-	err = crypto_register_alg(&alg);
-	if (err)
-		crypto_unregister_alg(&old_alg);
