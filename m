Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FCB92628D;
	Fri,  5 Sep 2025 03:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757041586; cv=none; b=MsRObuZIYEByJnL39S+kgHVoI17TkwSRW7eV9rjbFEWNre2R7wf3BQAKu7Mb3XFV262Fh5PEMW2HppAGIwFblhY/XivVmnBda2v+oiXvw/x39Yuo4DETNPmDVEr3Pxfxgc+qccw950v6wOh0md0uMfP5fsvBR7MAvg38fnUyZtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757041586; c=relaxed/simple;
	bh=Xc9Y8UmFeW4BhH5F3M94AxgXrG6Fci8OHdvSofPMl9s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NZinMuerCfYvciRQjs9/2xbG+x3EjSwLlUwRHG7AErWe+9ThNRPr2YWHD1yARQiICtqxnRD1XDa3g5r8kgRm+TjUg33BsTUTzdjFknFyyyjwjoQCe0aw4NGj11eQFfzvRyrmYMi3sHrZyl4d8Vf8Vzo9wPE/+VETOtggegKw6OE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nGqffFU8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nGqffFU8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97015C4CEF0;
	Fri,  5 Sep 2025 03:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757041585;
	bh=Xc9Y8UmFeW4BhH5F3M94AxgXrG6Fci8OHdvSofPMl9s=;
	h=From:To:Cc:Subject:Date:From;
	b=nGqffFU8zZILNV4bHjtGEjZ6hwOosKqhuZpzhV6T2F9gIWNVW7yxevbu896TSkoar
	 hV8LufANcQV+QEOgcnRWZ7MwFrJ0j+Zx+3CuhPMVlztlm60DuAFqhHTNrAyaQdHyya
	 hgNmIeJ5HytwMGIwKoo3200OWkoEh+1kR6PF+XyZjiWy9w9ryLlnSGLPzqNDN0JLzI
	 JS1+t97ZVVdpAQRsPRfWepBQqsOCpRL6+OQKGKPIoTnct1GvXlzjhQ2pF1gphzH720
	 jEtVzogl90idQ7UnJ6jbgcl1ed2EnPo2y5hbZOYXdbDU7jit3RfC8ncZj0/5a9B919
	 cY8g8w4N0M0gw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Ayush Sawal <ayush.sawal@chelsio.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v2] crypto: chelsio - Use library to prepare HMAC keys
Date: Thu,  4 Sep 2025 20:04:28 -0700
Message-ID: <20250905030428.21790-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To prepare HMAC keys, just use the library functions instead of
crypto_shash.  This is much simpler, avoids depending on the fragile
export_core and import_core methods, and is faster too.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

This is the same diff as v1, but with an updated commit message and now
targeting cryptodev/master instead of libcrypto-fixes.  Since I'm going
with
https://lore.kernel.org/r/20250901165013.48649-1-ebiggers@kernel.org/ to
fix the reported regression instead, this patch is now "just" a library
conversion and not a fix per se.  If needed I'd be glad to take this
through libcrypto-next instead, but usually these conversions have been
going through subsystem trees (which is Herbert's in this case).

 drivers/crypto/chelsio/Kconfig       |   6 +-
 drivers/crypto/chelsio/chcr_algo.c   | 259 +++++++--------------------
 drivers/crypto/chelsio/chcr_crypto.h |   1 -
 3 files changed, 63 insertions(+), 203 deletions(-)

diff --git a/drivers/crypto/chelsio/Kconfig b/drivers/crypto/chelsio/Kconfig
index 5dd3f6a4781a2..37294bb740031 100644
--- a/drivers/crypto/chelsio/Kconfig
+++ b/drivers/crypto/chelsio/Kconfig
@@ -2,13 +2,13 @@
 config CRYPTO_DEV_CHELSIO
 	tristate "Chelsio Crypto Co-processor Driver"
 	depends on CHELSIO_T4
 	select CRYPTO_LIB_AES
 	select CRYPTO_LIB_GF128MUL
-	select CRYPTO_SHA1
-	select CRYPTO_SHA256
-	select CRYPTO_SHA512
+	select CRYPTO_LIB_SHA1
+	select CRYPTO_LIB_SHA256
+	select CRYPTO_LIB_SHA512
 	select CRYPTO_AUTHENC
 	help
 	  The Chelsio Crypto Co-processor driver for T6 adapters.
 
 	  For general information about Chelsio and our products, visit
diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index be21e4e2016c5..22cbc343198aa 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -49,11 +49,10 @@
 #include <linux/highmem.h>
 #include <linux/scatterlist.h>
 
 #include <crypto/aes.h>
 #include <crypto/algapi.h>
-#include <crypto/hash.h>
 #include <crypto/gcm.h>
 #include <crypto/sha1.h>
 #include <crypto/sha2.h>
 #include <crypto/authenc.h>
 #include <crypto/ctr.h>
@@ -275,92 +274,64 @@ static void get_aes_decrypt_key(unsigned char *dec_key,
 		if (j < 0)
 			j += nk;
 	}
 }
 
-static struct crypto_shash *chcr_alloc_shash(unsigned int ds)
+static int chcr_prepare_hmac_key(const u8 *raw_key, unsigned int raw_key_len,
+				 int digestsize, void *istate, void *ostate)
 {
-	struct crypto_shash *base_hash = ERR_PTR(-EINVAL);
-
-	switch (ds) {
+	__be32 *istate32 = istate, *ostate32 = ostate;
+	__be64 *istate64 = istate, *ostate64 = ostate;
+	union {
+		struct hmac_sha1_key sha1;
+		struct hmac_sha224_key sha224;
+		struct hmac_sha256_key sha256;
+		struct hmac_sha384_key sha384;
+		struct hmac_sha512_key sha512;
+	} k;
+
+	switch (digestsize) {
 	case SHA1_DIGEST_SIZE:
-		base_hash = crypto_alloc_shash("sha1", 0, 0);
+		hmac_sha1_preparekey(&k.sha1, raw_key, raw_key_len);
+		for (int i = 0; i < ARRAY_SIZE(k.sha1.istate.h); i++) {
+			istate32[i] = cpu_to_be32(k.sha1.istate.h[i]);
+			ostate32[i] = cpu_to_be32(k.sha1.ostate.h[i]);
+		}
 		break;
 	case SHA224_DIGEST_SIZE:
-		base_hash = crypto_alloc_shash("sha224", 0, 0);
+		hmac_sha224_preparekey(&k.sha224, raw_key, raw_key_len);
+		for (int i = 0; i < ARRAY_SIZE(k.sha224.key.istate.h); i++) {
+			istate32[i] = cpu_to_be32(k.sha224.key.istate.h[i]);
+			ostate32[i] = cpu_to_be32(k.sha224.key.ostate.h[i]);
+		}
 		break;
 	case SHA256_DIGEST_SIZE:
-		base_hash = crypto_alloc_shash("sha256", 0, 0);
+		hmac_sha256_preparekey(&k.sha256, raw_key, raw_key_len);
+		for (int i = 0; i < ARRAY_SIZE(k.sha256.key.istate.h); i++) {
+			istate32[i] = cpu_to_be32(k.sha256.key.istate.h[i]);
+			ostate32[i] = cpu_to_be32(k.sha256.key.ostate.h[i]);
+		}
 		break;
 	case SHA384_DIGEST_SIZE:
-		base_hash = crypto_alloc_shash("sha384", 0, 0);
+		hmac_sha384_preparekey(&k.sha384, raw_key, raw_key_len);
+		for (int i = 0; i < ARRAY_SIZE(k.sha384.key.istate.h); i++) {
+			istate64[i] = cpu_to_be64(k.sha384.key.istate.h[i]);
+			ostate64[i] = cpu_to_be64(k.sha384.key.ostate.h[i]);
+		}
 		break;
 	case SHA512_DIGEST_SIZE:
-		base_hash = crypto_alloc_shash("sha512", 0, 0);
+		hmac_sha512_preparekey(&k.sha512, raw_key, raw_key_len);
+		for (int i = 0; i < ARRAY_SIZE(k.sha512.key.istate.h); i++) {
+			istate64[i] = cpu_to_be64(k.sha512.key.istate.h[i]);
+			ostate64[i] = cpu_to_be64(k.sha512.key.ostate.h[i]);
+		}
 		break;
+	default:
+		return -EINVAL;
 	}
-
-	return base_hash;
-}
-
-static int chcr_compute_partial_hash(struct shash_desc *desc,
-				     char *iopad, char *result_hash,
-				     int digest_size)
-{
-	struct sha1_state sha1_st;
-	struct sha256_state sha256_st;
-	struct sha512_state sha512_st;
-	int error;
-
-	if (digest_size == SHA1_DIGEST_SIZE) {
-		error = crypto_shash_init(desc) ?:
-			crypto_shash_update(desc, iopad, SHA1_BLOCK_SIZE) ?:
-			crypto_shash_export_core(desc, &sha1_st);
-		memcpy(result_hash, sha1_st.state, SHA1_DIGEST_SIZE);
-	} else if (digest_size == SHA224_DIGEST_SIZE) {
-		error = crypto_shash_init(desc) ?:
-			crypto_shash_update(desc, iopad, SHA256_BLOCK_SIZE) ?:
-			crypto_shash_export_core(desc, &sha256_st);
-		memcpy(result_hash, sha256_st.state, SHA256_DIGEST_SIZE);
-
-	} else if (digest_size == SHA256_DIGEST_SIZE) {
-		error = crypto_shash_init(desc) ?:
-			crypto_shash_update(desc, iopad, SHA256_BLOCK_SIZE) ?:
-			crypto_shash_export_core(desc, &sha256_st);
-		memcpy(result_hash, sha256_st.state, SHA256_DIGEST_SIZE);
-
-	} else if (digest_size == SHA384_DIGEST_SIZE) {
-		error = crypto_shash_init(desc) ?:
-			crypto_shash_update(desc, iopad, SHA512_BLOCK_SIZE) ?:
-			crypto_shash_export_core(desc, &sha512_st);
-		memcpy(result_hash, sha512_st.state, SHA512_DIGEST_SIZE);
-
-	} else if (digest_size == SHA512_DIGEST_SIZE) {
-		error = crypto_shash_init(desc) ?:
-			crypto_shash_update(desc, iopad, SHA512_BLOCK_SIZE) ?:
-			crypto_shash_export_core(desc, &sha512_st);
-		memcpy(result_hash, sha512_st.state, SHA512_DIGEST_SIZE);
-	} else {
-		error = -EINVAL;
-		pr_err("Unknown digest size %d\n", digest_size);
-	}
-	return error;
-}
-
-static void chcr_change_order(char *buf, int ds)
-{
-	int i;
-
-	if (ds == SHA512_DIGEST_SIZE) {
-		for (i = 0; i < (ds / sizeof(u64)); i++)
-			*((__be64 *)buf + i) =
-				cpu_to_be64(*((u64 *)buf + i));
-	} else {
-		for (i = 0; i < (ds / sizeof(u32)); i++)
-			*((__be32 *)buf + i) =
-				cpu_to_be32(*((u32 *)buf + i));
-	}
+	memzero_explicit(&k, sizeof(k));
+	return 0;
 }
 
 static inline int is_hmac(struct crypto_tfm *tfm)
 {
 	struct crypto_alg *alg = tfm->__crt_alg;
@@ -1545,15 +1516,10 @@ static int get_alg_config(struct algo_param *params,
 		return -EINVAL;
 	}
 	return 0;
 }
 
-static inline void chcr_free_shash(struct crypto_shash *base_hash)
-{
-		crypto_free_shash(base_hash);
-}
-
 /**
  *	create_hash_wr - Create hash work request
  *	@req: Cipher req base
  *	@param: Container for create_hash_wr()'s parameters
  */
@@ -2200,57 +2166,17 @@ static int chcr_ahash_import(struct ahash_request *areq, const void *in)
 
 static int chcr_ahash_setkey(struct crypto_ahash *tfm, const u8 *key,
 			     unsigned int keylen)
 {
 	struct hmac_ctx *hmacctx = HMAC_CTX(h_ctx(tfm));
-	unsigned int digestsize = crypto_ahash_digestsize(tfm);
-	unsigned int bs = crypto_tfm_alg_blocksize(crypto_ahash_tfm(tfm));
-	unsigned int i, err = 0, updated_digestsize;
-
-	SHASH_DESC_ON_STACK(shash, hmacctx->base_hash);
 
 	/* use the key to calculate the ipad and opad. ipad will sent with the
 	 * first request's data. opad will be sent with the final hash result
 	 * ipad in hmacctx->ipad and opad in hmacctx->opad location
 	 */
-	shash->tfm = hmacctx->base_hash;
-	if (keylen > bs) {
-		err = crypto_shash_digest(shash, key, keylen,
-					  hmacctx->ipad);
-		if (err)
-			goto out;
-		keylen = digestsize;
-	} else {
-		memcpy(hmacctx->ipad, key, keylen);
-	}
-	memset(hmacctx->ipad + keylen, 0, bs - keylen);
-	unsafe_memcpy(hmacctx->opad, hmacctx->ipad, bs,
-		      "fortified memcpy causes -Wrestrict warning");
-
-	for (i = 0; i < bs / sizeof(int); i++) {
-		*((unsigned int *)(&hmacctx->ipad) + i) ^= IPAD_DATA;
-		*((unsigned int *)(&hmacctx->opad) + i) ^= OPAD_DATA;
-	}
-
-	updated_digestsize = digestsize;
-	if (digestsize == SHA224_DIGEST_SIZE)
-		updated_digestsize = SHA256_DIGEST_SIZE;
-	else if (digestsize == SHA384_DIGEST_SIZE)
-		updated_digestsize = SHA512_DIGEST_SIZE;
-	err = chcr_compute_partial_hash(shash, hmacctx->ipad,
-					hmacctx->ipad, digestsize);
-	if (err)
-		goto out;
-	chcr_change_order(hmacctx->ipad, updated_digestsize);
-
-	err = chcr_compute_partial_hash(shash, hmacctx->opad,
-					hmacctx->opad, digestsize);
-	if (err)
-		goto out;
-	chcr_change_order(hmacctx->opad, updated_digestsize);
-out:
-	return err;
+	return chcr_prepare_hmac_key(key, keylen, crypto_ahash_digestsize(tfm),
+				     hmacctx->ipad, hmacctx->opad);
 }
 
 static int chcr_aes_xts_setkey(struct crypto_skcipher *cipher, const u8 *key,
 			       unsigned int key_len)
 {
@@ -2342,34 +2268,15 @@ static int chcr_hmac_init(struct ahash_request *areq)
 	return 0;
 }
 
 static int chcr_hmac_cra_init(struct crypto_tfm *tfm)
 {
-	struct chcr_context *ctx = crypto_tfm_ctx(tfm);
-	struct hmac_ctx *hmacctx = HMAC_CTX(ctx);
-	unsigned int digestsize =
-		crypto_ahash_digestsize(__crypto_ahash_cast(tfm));
-
 	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
 				 sizeof(struct chcr_ahash_req_ctx));
-	hmacctx->base_hash = chcr_alloc_shash(digestsize);
-	if (IS_ERR(hmacctx->base_hash))
-		return PTR_ERR(hmacctx->base_hash);
 	return chcr_device_init(crypto_tfm_ctx(tfm));
 }
 
-static void chcr_hmac_cra_exit(struct crypto_tfm *tfm)
-{
-	struct chcr_context *ctx = crypto_tfm_ctx(tfm);
-	struct hmac_ctx *hmacctx = HMAC_CTX(ctx);
-
-	if (hmacctx->base_hash) {
-		chcr_free_shash(hmacctx->base_hash);
-		hmacctx->base_hash = NULL;
-	}
-}
-
 inline void chcr_aead_common_exit(struct aead_request *req)
 {
 	struct chcr_aead_reqctx *reqctx = aead_request_ctx_dma(req);
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct uld_ctx *u_ctx = ULD_CTX(a_ctx(tfm));
@@ -3555,19 +3462,16 @@ static int chcr_authenc_setkey(struct crypto_aead *authenc, const u8 *key,
 {
 	struct chcr_aead_ctx *aeadctx = AEAD_CTX(a_ctx(authenc));
 	struct chcr_authenc_ctx *actx = AUTHENC_CTX(aeadctx);
 	/* it contains auth and cipher key both*/
 	struct crypto_authenc_keys keys;
-	unsigned int bs, subtype;
+	unsigned int subtype;
 	unsigned int max_authsize = crypto_aead_alg(authenc)->maxauthsize;
-	int err = 0, i, key_ctx_len = 0;
+	int err = 0, key_ctx_len = 0;
 	unsigned char ck_size = 0;
-	unsigned char pad[CHCR_HASH_MAX_BLOCK_SIZE_128] = { 0 };
-	struct crypto_shash *base_hash = ERR_PTR(-EINVAL);
 	struct algo_param param;
 	int align;
-	u8 *o_ptr = NULL;
 
 	crypto_aead_clear_flags(aeadctx->sw_cipher, CRYPTO_TFM_REQ_MASK);
 	crypto_aead_set_flags(aeadctx->sw_cipher, crypto_aead_get_flags(authenc)
 			      & CRYPTO_TFM_REQ_MASK);
 	err = crypto_aead_setkey(aeadctx->sw_cipher, key, keylen);
@@ -3611,72 +3515,30 @@ static int chcr_authenc_setkey(struct crypto_aead *authenc, const u8 *key,
 		subtype == CRYPTO_ALG_SUB_TYPE_CBC_NULL) {
 
 		get_aes_decrypt_key(actx->dec_rrkey, aeadctx->key,
 			    aeadctx->enckey_len << 3);
 	}
-	base_hash  = chcr_alloc_shash(max_authsize);
-	if (IS_ERR(base_hash)) {
-		pr_err("Base driver cannot be loaded\n");
+
+	align = KEYCTX_ALIGN_PAD(max_authsize);
+	err = chcr_prepare_hmac_key(keys.authkey, keys.authkeylen, max_authsize,
+				    actx->h_iopad,
+				    actx->h_iopad + param.result_size + align);
+	if (err)
 		goto out;
-	}
-	{
-		SHASH_DESC_ON_STACK(shash, base_hash);
-
-		shash->tfm = base_hash;
-		bs = crypto_shash_blocksize(base_hash);
-		align = KEYCTX_ALIGN_PAD(max_authsize);
-		o_ptr =  actx->h_iopad + param.result_size + align;
-
-		if (keys.authkeylen > bs) {
-			err = crypto_shash_digest(shash, keys.authkey,
-						  keys.authkeylen,
-						  o_ptr);
-			if (err) {
-				pr_err("Base driver cannot be loaded\n");
-				goto out;
-			}
-			keys.authkeylen = max_authsize;
-		} else
-			memcpy(o_ptr, keys.authkey, keys.authkeylen);
-
-		/* Compute the ipad-digest*/
-		memset(pad + keys.authkeylen, 0, bs - keys.authkeylen);
-		memcpy(pad, o_ptr, keys.authkeylen);
-		for (i = 0; i < bs >> 2; i++)
-			*((unsigned int *)pad + i) ^= IPAD_DATA;
-
-		if (chcr_compute_partial_hash(shash, pad, actx->h_iopad,
-					      max_authsize))
-			goto out;
-		/* Compute the opad-digest */
-		memset(pad + keys.authkeylen, 0, bs - keys.authkeylen);
-		memcpy(pad, o_ptr, keys.authkeylen);
-		for (i = 0; i < bs >> 2; i++)
-			*((unsigned int *)pad + i) ^= OPAD_DATA;
 
-		if (chcr_compute_partial_hash(shash, pad, o_ptr, max_authsize))
-			goto out;
+	key_ctx_len = sizeof(struct _key_ctx) + roundup(keys.enckeylen, 16) +
+		      (param.result_size + align) * 2;
+	aeadctx->key_ctx_hdr = FILL_KEY_CTX_HDR(ck_size, param.mk_size, 0, 1,
+						key_ctx_len >> 4);
+	actx->auth_mode = param.auth_mode;
+
+	memzero_explicit(&keys, sizeof(keys));
+	return 0;
 
-		/* convert the ipad and opad digest to network order */
-		chcr_change_order(actx->h_iopad, param.result_size);
-		chcr_change_order(o_ptr, param.result_size);
-		key_ctx_len = sizeof(struct _key_ctx) +
-			roundup(keys.enckeylen, 16) +
-			(param.result_size + align) * 2;
-		aeadctx->key_ctx_hdr = FILL_KEY_CTX_HDR(ck_size, param.mk_size,
-						0, 1, key_ctx_len >> 4);
-		actx->auth_mode = param.auth_mode;
-		chcr_free_shash(base_hash);
-
-		memzero_explicit(&keys, sizeof(keys));
-		return 0;
-	}
 out:
 	aeadctx->enckey_len = 0;
 	memzero_explicit(&keys, sizeof(keys));
-	if (!IS_ERR(base_hash))
-		chcr_free_shash(base_hash);
 	return -EINVAL;
 }
 
 static int chcr_aead_digest_null_setkey(struct crypto_aead *authenc,
 					const u8 *key, unsigned int keylen)
@@ -4488,11 +4350,10 @@ static int chcr_register_alg(void)
 			a_hash->halg.base.cra_alignmask = 0;
 			a_hash->halg.base.cra_exit = NULL;
 
 			if (driver_algs[i].type == CRYPTO_ALG_TYPE_HMAC) {
 				a_hash->halg.base.cra_init = chcr_hmac_cra_init;
-				a_hash->halg.base.cra_exit = chcr_hmac_cra_exit;
 				a_hash->init = chcr_hmac_init;
 				a_hash->setkey = chcr_ahash_setkey;
 				a_hash->halg.base.cra_ctxsize = SZ_AHASH_H_CTX;
 			} else {
 				a_hash->init = chcr_sha_init;
diff --git a/drivers/crypto/chelsio/chcr_crypto.h b/drivers/crypto/chelsio/chcr_crypto.h
index 1d693b8436e6f..e1e79e5f01e75 100644
--- a/drivers/crypto/chelsio/chcr_crypto.h
+++ b/drivers/crypto/chelsio/chcr_crypto.h
@@ -239,11 +239,10 @@ struct chcr_aead_ctx {
 	u16 mayverify;
 	struct	__aead_ctx ctx[];
 };
 
 struct hmac_ctx {
-	struct crypto_shash *base_hash;
 	u8 ipad[CHCR_HASH_MAX_BLOCK_SIZE_128];
 	u8 opad[CHCR_HASH_MAX_BLOCK_SIZE_128];
 };
 
 struct __crypto_ctx {

base-commit: 41eab2a95950682cdc9c5e60cb3457e29f186540
-- 
2.50.1

