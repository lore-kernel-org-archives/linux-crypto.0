Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E565225B2
	for <linux-crypto@vger.kernel.org>; Tue, 13 Feb 2024 09:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707815804; cv=none; b=uCE8ksTfHuSlMKWs0G0u7pyp5Weq3jgPiGrOh0CMeiPLMKjOWsTGYhbGz8eay987Nmf2NK0UM93VtSJfvkgtwnRZe6LWmitwkzF654wPwF7S3fzTvEw6UhQiePQ88uno1EL7AwWdzc8FT/c3uZEBcYB9EphSthZa9CVMjMkmit8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707815804; c=relaxed/simple;
	bh=qeoDLBlzTaw+1LvPT49RZSpDxScjocOdk6coMMeyucA=;
	h=Message-Id:In-Reply-To:References:From:Date:Subject:To; b=pYF4s3FTv/ZR/bxz9tCUynEGzEXmljqFFtQvf6jtb8NPL7femdgVSLBnfVlKIoqPVpq9rhwhSfXo7yYt6TvrZi3hIHe4PzXJcGkxZvjJU8cSkcpj+556YHtd2tsO5M40uwHJPVeQl8uNtpkvxpm7S/i13zrafxSi2QLEp0zPNa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rZou6-00D1qM-Lf; Tue, 13 Feb 2024 17:16:39 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 13 Feb 2024 17:16:52 +0800
Message-Id: <3ec460107b256268dd00069fff7d92bcc975259e.1707815065.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1707815065.git.herbert@gondor.apana.org.au>
References: <cover.1707815065.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Tue, 5 Dec 2023 17:52:33 +0800
Subject: [PATCH 07/15] crypto: adiantum - Use lskcipher instead of cipher
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Use the new lskcipher interface for simple block cipher.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/adiantum.c | 130 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 96 insertions(+), 34 deletions(-)

diff --git a/crypto/adiantum.c b/crypto/adiantum.c
index 60f3883b736a..ee55b1f8565c 100644
--- a/crypto/adiantum.c
+++ b/crypto/adiantum.c
@@ -32,7 +32,6 @@
 
 #include <crypto/b128ops.h>
 #include <crypto/chacha.h>
-#include <crypto/internal/cipher.h>
 #include <crypto/internal/hash.h>
 #include <crypto/internal/poly1305.h>
 #include <crypto/internal/skcipher.h>
@@ -63,13 +62,13 @@
 
 struct adiantum_instance_ctx {
 	struct crypto_skcipher_spawn streamcipher_spawn;
-	struct crypto_cipher_spawn blockcipher_spawn;
+	struct crypto_lskcipher_spawn blockcipher_spawn;
 	struct crypto_shash_spawn hash_spawn;
 };
 
 struct adiantum_tfm_ctx {
 	struct crypto_skcipher *streamcipher;
-	struct crypto_cipher *blockcipher;
+	struct crypto_lskcipher *blockcipher;
 	struct crypto_shash *hash;
 	struct poly1305_core_key header_hash_key;
 };
@@ -157,12 +156,12 @@ static int adiantum_setkey(struct crypto_skcipher *tfm, const u8 *key,
 	keyp = data->derived_keys;
 
 	/* Set the block cipher key (K_E) */
-	crypto_cipher_clear_flags(tctx->blockcipher, CRYPTO_TFM_REQ_MASK);
-	crypto_cipher_set_flags(tctx->blockcipher,
-				crypto_skcipher_get_flags(tfm) &
-				CRYPTO_TFM_REQ_MASK);
-	err = crypto_cipher_setkey(tctx->blockcipher, keyp,
-				   BLOCKCIPHER_KEY_SIZE);
+	crypto_lskcipher_clear_flags(tctx->blockcipher, CRYPTO_TFM_REQ_MASK);
+	crypto_lskcipher_set_flags(tctx->blockcipher,
+				   crypto_skcipher_get_flags(tfm) &
+				   CRYPTO_TFM_REQ_MASK);
+	err = crypto_lskcipher_setkey(tctx->blockcipher, keyp,
+				     BLOCKCIPHER_KEY_SIZE);
 	if (err)
 		goto out;
 	keyp += BLOCKCIPHER_KEY_SIZE;
@@ -287,9 +286,14 @@ static int adiantum_finish(struct skcipher_request *req)
 	int err;
 
 	/* If decrypting, decrypt C_M with the block cipher to get P_M */
-	if (!rctx->enc)
-		crypto_cipher_decrypt_one(tctx->blockcipher, rctx->rbuf.bytes,
-					  rctx->rbuf.bytes);
+	if (!rctx->enc) {
+		err = crypto_lskcipher_decrypt(tctx->blockcipher,
+					       rctx->rbuf.bytes,
+					       rctx->rbuf.bytes,
+					       BLOCKCIPHER_BLOCK_SIZE, NULL);
+		if (err)
+			return err;
+	}
 
 	/*
 	 * Second hash step
@@ -379,9 +383,14 @@ static int adiantum_crypt(struct skcipher_request *req, bool enc)
 	le128_add(&rctx->rbuf.bignum, &rctx->rbuf.bignum, &digest);
 
 	/* If encrypting, encrypt P_M with the block cipher to get C_M */
-	if (enc)
-		crypto_cipher_encrypt_one(tctx->blockcipher, rctx->rbuf.bytes,
-					  rctx->rbuf.bytes);
+	if (enc) {
+		err = crypto_lskcipher_encrypt(tctx->blockcipher,
+					       rctx->rbuf.bytes,
+					       rctx->rbuf.bytes,
+					       BLOCKCIPHER_BLOCK_SIZE, NULL);
+		if (err)
+			return err;
+	}
 
 	/* Initialize the rest of the XChaCha IV (first part is C_M) */
 	BUILD_BUG_ON(BLOCKCIPHER_BLOCK_SIZE != 16);
@@ -430,7 +439,7 @@ static int adiantum_init_tfm(struct crypto_skcipher *tfm)
 	struct adiantum_instance_ctx *ictx = skcipher_instance_ctx(inst);
 	struct adiantum_tfm_ctx *tctx = crypto_skcipher_ctx(tfm);
 	struct crypto_skcipher *streamcipher;
-	struct crypto_cipher *blockcipher;
+	struct crypto_lskcipher *blockcipher;
 	struct crypto_shash *hash;
 	unsigned int subreq_size;
 	int err;
@@ -439,7 +448,7 @@ static int adiantum_init_tfm(struct crypto_skcipher *tfm)
 	if (IS_ERR(streamcipher))
 		return PTR_ERR(streamcipher);
 
-	blockcipher = crypto_spawn_cipher(&ictx->blockcipher_spawn);
+	blockcipher = crypto_spawn_lskcipher(&ictx->blockcipher_spawn);
 	if (IS_ERR(blockcipher)) {
 		err = PTR_ERR(blockcipher);
 		goto err_free_streamcipher;
@@ -470,7 +479,7 @@ static int adiantum_init_tfm(struct crypto_skcipher *tfm)
 	return 0;
 
 err_free_blockcipher:
-	crypto_free_cipher(blockcipher);
+	crypto_free_lskcipher(blockcipher);
 err_free_streamcipher:
 	crypto_free_skcipher(streamcipher);
 	return err;
@@ -481,7 +490,7 @@ static void adiantum_exit_tfm(struct crypto_skcipher *tfm)
 	struct adiantum_tfm_ctx *tctx = crypto_skcipher_ctx(tfm);
 
 	crypto_free_skcipher(tctx->streamcipher);
-	crypto_free_cipher(tctx->blockcipher);
+	crypto_free_lskcipher(tctx->blockcipher);
 	crypto_free_shash(tctx->hash);
 }
 
@@ -490,7 +499,7 @@ static void adiantum_free_instance(struct skcipher_instance *inst)
 	struct adiantum_instance_ctx *ictx = skcipher_instance_ctx(inst);
 
 	crypto_drop_skcipher(&ictx->streamcipher_spawn);
-	crypto_drop_cipher(&ictx->blockcipher_spawn);
+	crypto_drop_lskcipher(&ictx->blockcipher_spawn);
 	crypto_drop_shash(&ictx->hash_spawn);
 	kfree(inst);
 }
@@ -500,17 +509,21 @@ static void adiantum_free_instance(struct skcipher_instance *inst)
  * See the comment at the beginning of this file.
  */
 static bool adiantum_supported_algorithms(struct skcipher_alg_common *streamcipher_alg,
-					  struct crypto_alg *blockcipher_alg,
+					  struct lskcipher_alg *blockcipher_alg,
 					  struct shash_alg *hash_alg)
 {
 	if (strcmp(streamcipher_alg->base.cra_name, "xchacha12") != 0 &&
 	    strcmp(streamcipher_alg->base.cra_name, "xchacha20") != 0)
 		return false;
 
-	if (blockcipher_alg->cra_cipher.cia_min_keysize > BLOCKCIPHER_KEY_SIZE ||
-	    blockcipher_alg->cra_cipher.cia_max_keysize < BLOCKCIPHER_KEY_SIZE)
+	if (blockcipher_alg->co.min_keysize > BLOCKCIPHER_KEY_SIZE ||
+	    blockcipher_alg->co.max_keysize < BLOCKCIPHER_KEY_SIZE)
 		return false;
-	if (blockcipher_alg->cra_blocksize != BLOCKCIPHER_BLOCK_SIZE)
+	if (blockcipher_alg->co.base.cra_blocksize != BLOCKCIPHER_BLOCK_SIZE)
+		return false;
+	if (blockcipher_alg->co.ivsize)
+		return false;
+	if (blockcipher_alg->co.statesize)
 		return false;
 
 	if (strcmp(hash_alg->base.cra_name, "nhpoly1305") != 0)
@@ -526,8 +539,12 @@ static int adiantum_create(struct crypto_template *tmpl, struct rtattr **tb)
 	struct skcipher_instance *inst;
 	struct adiantum_instance_ctx *ictx;
 	struct skcipher_alg_common *streamcipher_alg;
-	struct crypto_alg *blockcipher_alg;
+	char ecb_driver_name[CRYPTO_MAX_ALG_NAME];
+	struct lskcipher_alg *blockcipher_alg;
+	char ecb_name[CRYPTO_MAX_ALG_NAME];
+	const char *cipher_driver_name;
 	struct shash_alg *hash_alg;
+	const char *cipher_name;
 	int err;
 
 	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_SKCIPHER, &mask);
@@ -548,12 +565,27 @@ static int adiantum_create(struct crypto_template *tmpl, struct rtattr **tb)
 	streamcipher_alg = crypto_spawn_skcipher_alg_common(&ictx->streamcipher_spawn);
 
 	/* Block cipher, e.g. "aes" */
-	err = crypto_grab_cipher(&ictx->blockcipher_spawn,
-				 skcipher_crypto_instance(inst),
-				 crypto_attr_alg_name(tb[2]), 0, mask);
+	cipher_name = crypto_attr_alg_name(tb[2]);
+	cipher_driver_name = cipher_name;
+	err = crypto_grab_lskcipher(&ictx->blockcipher_spawn,
+				    skcipher_crypto_instance(inst),
+				    cipher_name, 0, mask);
+
+	ecb_name[0] = 0;
+	if (err == -ENOENT) {
+		err = -ENAMETOOLONG;
+		if (snprintf(ecb_name, CRYPTO_MAX_ALG_NAME, "ecb(%s)",
+			     cipher_name) >= CRYPTO_MAX_ALG_NAME)
+			goto err_free_inst;
+
+		err = crypto_grab_lskcipher(&ictx->blockcipher_spawn,
+					    skcipher_crypto_instance(inst),
+					    ecb_name, 0, mask);
+	}
+
 	if (err)
 		goto err_free_inst;
-	blockcipher_alg = crypto_spawn_cipher_alg(&ictx->blockcipher_spawn);
+	blockcipher_alg = crypto_spawn_lskcipher_alg(&ictx->blockcipher_spawn);
 
 	/* NHPoly1305 ε-∆U hash function */
 	nhpoly1305_name = crypto_attr_alg_name(tb[3]);
@@ -571,22 +603,52 @@ static int adiantum_create(struct crypto_template *tmpl, struct rtattr **tb)
 					   hash_alg)) {
 		pr_warn("Unsupported Adiantum instantiation: (%s,%s,%s)\n",
 			streamcipher_alg->base.cra_name,
-			blockcipher_alg->cra_name, hash_alg->base.cra_name);
+			blockcipher_alg->co.base.cra_name,
+			hash_alg->base.cra_name);
 		err = -EINVAL;
 		goto err_free_inst;
 	}
 
 	/* Instance fields */
 
+	cipher_name = blockcipher_alg->co.base.cra_name;
+	cipher_driver_name = blockcipher_alg->co.base.cra_driver_name;
+	if (ecb_name[0]) {
+		int len;
+
+		err = -EINVAL;
+		len = strscpy(ecb_name, &blockcipher_alg->co.base.cra_name[4],
+			      sizeof(ecb_name));
+		if (len < 2)
+			goto err_free_inst;
+
+		if (ecb_name[len - 1] != ')')
+			goto err_free_inst;
+
+		ecb_name[len - 1] = 0;
+		cipher_name = ecb_name;
+
+		len = strscpy(ecb_driver_name, &blockcipher_alg->co.base.cra_driver_name[4],
+			      sizeof(ecb_driver_name));
+		if (len < 2)
+			goto err_free_inst;
+
+		if (ecb_driver_name[len - 1] != ')')
+			goto err_free_inst;
+
+		ecb_driver_name[len - 1] = 0;
+		cipher_driver_name = ecb_driver_name;
+	}
+
 	err = -ENAMETOOLONG;
 	if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME,
 		     "adiantum(%s,%s)", streamcipher_alg->base.cra_name,
-		     blockcipher_alg->cra_name) >= CRYPTO_MAX_ALG_NAME)
+		     cipher_name) >= CRYPTO_MAX_ALG_NAME)
 		goto err_free_inst;
 	if (snprintf(inst->alg.base.cra_driver_name, CRYPTO_MAX_ALG_NAME,
 		     "adiantum(%s,%s,%s)",
 		     streamcipher_alg->base.cra_driver_name,
-		     blockcipher_alg->cra_driver_name,
+		     cipher_driver_name,
 		     hash_alg->base.cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
 		goto err_free_inst;
 
@@ -601,7 +663,7 @@ static int adiantum_create(struct crypto_template *tmpl, struct rtattr **tb)
 	 */
 	inst->alg.base.cra_priority = (4 * streamcipher_alg->base.cra_priority +
 				       2 * hash_alg->base.cra_priority +
-				       blockcipher_alg->cra_priority) / 7;
+				       blockcipher_alg->co.base.cra_priority) / 7;
 
 	inst->alg.setkey = adiantum_setkey;
 	inst->alg.encrypt = adiantum_encrypt;
@@ -611,6 +673,7 @@ static int adiantum_create(struct crypto_template *tmpl, struct rtattr **tb)
 	inst->alg.min_keysize = streamcipher_alg->min_keysize;
 	inst->alg.max_keysize = streamcipher_alg->max_keysize;
 	inst->alg.ivsize = TWEAK_SIZE;
+	inst->alg.co.twopass = true;
 
 	inst->free = adiantum_free_instance;
 
@@ -646,4 +709,3 @@ MODULE_DESCRIPTION("Adiantum length-preserving encryption mode");
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Eric Biggers <ebiggers@google.com>");
 MODULE_ALIAS_CRYPTO("adiantum");
-MODULE_IMPORT_NS(CRYPTO_INTERNAL);
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

