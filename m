From: Harsh Jain <harsh@chelsio.com>
Subject: [PATCH 4/6] chcr: Use SHASH_DESC_ON_STACK
Date: Thu, 13 Oct 2016 16:39:37 +0530
Message-ID: <9fadfd5c2cc19a1d90accea566aa15ffe8fa2014.1476263960.git.harsh@chelsio.com>
References: <cover.1476263960.git.harsh@chelsio.com>
Cc: jlulla@chelsio.com, atul.gupta@chelsio.com, yeshaswi@chelsio.com,
        hariprasad@chelsio.com, Harsh Jain <harsh@chelsio.com>
To: dan.carpenter@oracle.com, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:14540 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754123AbcJMLNM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Oct 2016 07:13:12 -0400
In-Reply-To: <cover.1476263960.git.harsh@chelsio.com>
In-Reply-To: <cover.1476263960.git.harsh@chelsio.com>
References: <cover.1476263960.git.harsh@chelsio.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Use SHASH_DESC_ON_STACK macro to allocate memory for ipad/opad
calculation.

Signed-off-by: Harsh Jain <harsh@chelsio.com>
---
 drivers/crypto/chelsio/chcr_algo.c   | 63 +++++++++++++++---------------------
 drivers/crypto/chelsio/chcr_crypto.h |  2 +-
 2 files changed, 27 insertions(+), 38 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index 17d0c1f..7262bb3 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -228,40 +228,29 @@ static void get_aes_decrypt_key(unsigned char *dec_key,
 	}
 }
 
-static struct shash_desc *chcr_alloc_shash(unsigned int ds)
+static struct crypto_shash *chcr_alloc_shash(unsigned int ds)
 {
 	struct crypto_shash *base_hash = NULL;
-	struct shash_desc *desc;
 
 	switch (ds) {
 	case SHA1_DIGEST_SIZE:
-		base_hash = crypto_alloc_shash("sha1-generic", 0, 0);
+		base_hash = crypto_alloc_shash("sha1", 0, 0);
 		break;
 	case SHA224_DIGEST_SIZE:
-		base_hash = crypto_alloc_shash("sha224-generic", 0, 0);
+		base_hash = crypto_alloc_shash("sha224", 0, 0);
 		break;
 	case SHA256_DIGEST_SIZE:
-		base_hash = crypto_alloc_shash("sha256-generic", 0, 0);
+		base_hash = crypto_alloc_shash("sha256", 0, 0);
 		break;
 	case SHA384_DIGEST_SIZE:
-		base_hash = crypto_alloc_shash("sha384-generic", 0, 0);
+		base_hash = crypto_alloc_shash("sha384", 0, 0);
 		break;
 	case SHA512_DIGEST_SIZE:
-		base_hash = crypto_alloc_shash("sha512-generic", 0, 0);
+		base_hash = crypto_alloc_shash("sha512", 0, 0);
 		break;
 	}
-	if (IS_ERR(base_hash)) {
-		pr_err("Can not allocate sha-generic algo.\n");
-		return (void *)base_hash;
-	}
 
-	desc = kmalloc(sizeof(*desc) + crypto_shash_descsize(base_hash),
-		       GFP_KERNEL);
-	if (!desc)
-		return ERR_PTR(-ENOMEM);
-	desc->tfm = base_hash;
-	desc->flags = crypto_shash_get_flags(base_hash);
-	return desc;
+	return base_hash;
 }
 
 static int chcr_compute_partial_hash(struct shash_desc *desc,
@@ -770,6 +759,11 @@ static int get_alg_config(struct algo_param *params,
 	return 0;
 }
 
+static inline void chcr_free_shash(struct crypto_shash *base_hash)
+{
+		crypto_free_shash(base_hash);
+}
+
 /**
  *	create_hash_wr - Create hash work request
  *	@req - Cipher req base
@@ -1106,15 +1100,16 @@ static int chcr_ahash_setkey(struct crypto_ahash *tfm, const u8 *key,
 	unsigned int bs = crypto_tfm_alg_blocksize(crypto_ahash_tfm(tfm));
 	unsigned int i, err = 0, updated_digestsize;
 
-	/*
-	 * use the key to calculate the ipad and opad. ipad will sent with the
+	SHASH_DESC_ON_STACK(shash, hmacctx->base_hash);
+
+	/* use the key to calculate the ipad and opad. ipad will sent with the
 	 * first request's data. opad will be sent with the final hash result
 	 * ipad in hmacctx->ipad and opad in hmacctx->opad location
 	 */
-	if (!hmacctx->desc)
-		return -EINVAL;
+	shash->tfm = hmacctx->base_hash;
+	shash->flags = crypto_shash_get_flags(hmacctx->base_hash);
 	if (keylen > bs) {
-		err = crypto_shash_digest(hmacctx->desc, key, keylen,
+		err = crypto_shash_digest(shash, key, keylen,
 					  hmacctx->ipad);
 		if (err)
 			goto out;
@@ -1135,13 +1130,13 @@ static int chcr_ahash_setkey(struct crypto_ahash *tfm, const u8 *key,
 		updated_digestsize = SHA256_DIGEST_SIZE;
 	else if (digestsize == SHA384_DIGEST_SIZE)
 		updated_digestsize = SHA512_DIGEST_SIZE;
-	err = chcr_compute_partial_hash(hmacctx->desc, hmacctx->ipad,
+	err = chcr_compute_partial_hash(shash, hmacctx->ipad,
 					hmacctx->ipad, digestsize);
 	if (err)
 		goto out;
 	chcr_change_order(hmacctx->ipad, updated_digestsize);
 
-	err = chcr_compute_partial_hash(hmacctx->desc, hmacctx->opad,
+	err = chcr_compute_partial_hash(shash, hmacctx->opad,
 					hmacctx->opad, digestsize);
 	if (err)
 		goto out;
@@ -1237,26 +1232,20 @@ static int chcr_hmac_cra_init(struct crypto_tfm *tfm)
 
 	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
 				 sizeof(struct chcr_ahash_req_ctx));
-	hmacctx->desc = chcr_alloc_shash(digestsize);
-	if (IS_ERR(hmacctx->desc))
-		return PTR_ERR(hmacctx->desc);
+	hmacctx->base_hash = chcr_alloc_shash(digestsize);
+	if (IS_ERR(hmacctx->base_hash))
+		return PTR_ERR(hmacctx->base_hash);
 	return chcr_device_init(crypto_tfm_ctx(tfm));
 }
 
-static void chcr_free_shash(struct shash_desc *desc)
-{
-	crypto_free_shash(desc->tfm);
-	kfree(desc);
-}
-
 static void chcr_hmac_cra_exit(struct crypto_tfm *tfm)
 {
 	struct chcr_context *ctx = crypto_tfm_ctx(tfm);
 	struct hmac_ctx *hmacctx = HMAC_CTX(ctx);
 
-	if (hmacctx->desc) {
-		chcr_free_shash(hmacctx->desc);
-		hmacctx->desc = NULL;
+	if (hmacctx->base_hash) {
+		chcr_free_shash(hmacctx->base_hash);
+		hmacctx->base_hash = NULL;
 	}
 }
 
diff --git a/drivers/crypto/chelsio/chcr_crypto.h b/drivers/crypto/chelsio/chcr_crypto.h
index 7ed6d2b..977d205 100644
--- a/drivers/crypto/chelsio/chcr_crypto.h
+++ b/drivers/crypto/chelsio/chcr_crypto.h
@@ -132,7 +132,7 @@ struct ablk_ctx {
 };
 
 struct hmac_ctx {
-	struct shash_desc *desc;
+	struct crypto_shash *base_hash;
 	u8 ipad[CHCR_HASH_MAX_BLOCK_SIZE_128];
 	u8 opad[CHCR_HASH_MAX_BLOCK_SIZE_128];
 };
-- 
1.8.2.3
