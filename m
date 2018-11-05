Return-Path: <SRS0=IFNk=NQ=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40436 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729332AbeKEWLI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Nov 2018 17:11:08 -0500
Received: by mail-wr1-f68.google.com with SMTP id i17-v6so9382170wre.7
        for <linux-crypto@vger.kernel.org>; Mon, 05 Nov 2018 04:51:30 -0800 (PST)
From: Corentin Labbe <clabbe@baylibre.com>
To: davem@davemloft.net, ebiggers@kernel.org,
        herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 5/5] crypto: crypto_user_stat: fix use_after_free of struct xxx_request
Date: Mon,  5 Nov 2018 12:51:14 +0000
Message-Id: <1541422274-40060-6-git-send-email-clabbe@baylibre.com>
In-Reply-To: <1541422274-40060-1-git-send-email-clabbe@baylibre.com>
References: <1541422274-40060-1-git-send-email-clabbe@baylibre.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

All crypto_stats functions use the struct xxx_request for feeding stats,
but in some case this structure could already be freed.

For fixing this, the needed parameters (len and alg) will be stored
before the request being executed.
Fixes: cac5818c25d0 ("crypto: user - Implement a generic crypto statistics")
Reported-by: syzbot <syzbot+6939a606a5305e9e9799@syzkaller.appspotmail.com>

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 crypto/ahash.c             | 14 ++++++++--
 include/crypto/acompress.h | 30 ++++++++++----------
 include/crypto/aead.h      | 30 ++++++++++----------
 include/crypto/akcipher.h  | 56 ++++++++++++++++++--------------------
 include/crypto/hash.h      | 25 +++++++++--------
 include/crypto/kpp.h       | 22 +++++++--------
 include/crypto/skcipher.h  | 16 +++++++----
 include/linux/crypto.h     | 34 +++++++++++------------
 8 files changed, 118 insertions(+), 109 deletions(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index 3a348fbcf8f9..3f4c44c1e80f 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -364,20 +364,26 @@ static int crypto_ahash_op(struct ahash_request *req,
 
 int crypto_ahash_final(struct ahash_request *req)
 {
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct crypto_alg *alg = tfm->base.__crt_alg;
+	unsigned int nbytes = req->nbytes;
 	int ret;
 
 	ret = crypto_ahash_op(req, crypto_ahash_reqtfm(req)->final);
-	crypto_stat_ahash_final(req, ret);
+	crypto_stat_ahash_final(nbytes, ret, alg);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(crypto_ahash_final);
 
 int crypto_ahash_finup(struct ahash_request *req)
 {
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct crypto_alg *alg = tfm->base.__crt_alg;
+	unsigned int nbytes = req->nbytes;
 	int ret;
 
 	ret = crypto_ahash_op(req, crypto_ahash_reqtfm(req)->finup);
-	crypto_stat_ahash_final(req, ret);
+	crypto_stat_ahash_final(nbytes, ret, alg);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(crypto_ahash_finup);
@@ -385,13 +391,15 @@ EXPORT_SYMBOL_GPL(crypto_ahash_finup);
 int crypto_ahash_digest(struct ahash_request *req)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct crypto_alg *alg = tfm->base.__crt_alg;
+	unsigned int nbytes = req->nbytes;
 	int ret;
 
 	if (crypto_ahash_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
 		ret = -ENOKEY;
 	else
 		ret = crypto_ahash_op(req, tfm->digest);
-	crypto_stat_ahash_final(req, ret);
+	crypto_stat_ahash_final(nbytes, ret, alg);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(crypto_ahash_digest);
diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index f79918196811..396407cc34c7 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -234,30 +234,28 @@ static inline void acomp_request_set_params(struct acomp_req *req,
 		req->flags |= CRYPTO_ACOMP_ALLOC_OUTPUT;
 }
 
-static inline void crypto_stat_compress(struct acomp_req *req, int ret)
+static inline void crypto_stat_compress(unsigned int slen, int ret,
+					struct crypto_alg *alg)
 {
 #ifdef CONFIG_CRYPTO_STATS
-	struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
-
 	if (ret && ret != -EINPROGRESS && ret != -EBUSY) {
-		atomic64_inc(&tfm->base.__crt_alg->compress_err_cnt);
+		atomic64_inc(&alg->compress_err_cnt);
 	} else {
-		atomic64_inc(&tfm->base.__crt_alg->compress_cnt);
-		atomic64_add(req->slen, &tfm->base.__crt_alg->compress_tlen);
+		atomic64_inc(&alg->compress_cnt);
+		atomic64_add(slen, &alg->compress_tlen);
 	}
 #endif
 }
 
-static inline void crypto_stat_decompress(struct acomp_req *req, int ret)
+static inline void crypto_stat_decompress(unsigned int slen, int ret,
+					  struct crypto_alg *alg)
 {
 #ifdef CONFIG_CRYPTO_STATS
-	struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
-
 	if (ret && ret != -EINPROGRESS && ret != -EBUSY) {
-		atomic64_inc(&tfm->base.__crt_alg->compress_err_cnt);
+		atomic64_inc(&alg->compress_err_cnt);
 	} else {
-		atomic64_inc(&tfm->base.__crt_alg->decompress_cnt);
-		atomic64_add(req->slen, &tfm->base.__crt_alg->decompress_tlen);
+		atomic64_inc(&alg->decompress_cnt);
+		atomic64_add(slen, &alg->decompress_tlen);
 	}
 #endif
 }
@@ -274,10 +272,12 @@ static inline void crypto_stat_decompress(struct acomp_req *req, int ret)
 static inline int crypto_acomp_compress(struct acomp_req *req)
 {
 	struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
+	struct crypto_alg *alg = tfm->base.__crt_alg;
+	unsigned int slen = req->slen;
 	int ret;
 
 	ret = tfm->compress(req);
-	crypto_stat_compress(req, ret);
+	crypto_stat_compress(slen, ret, alg);
 	return ret;
 }
 
@@ -293,10 +293,12 @@ static inline int crypto_acomp_compress(struct acomp_req *req)
 static inline int crypto_acomp_decompress(struct acomp_req *req)
 {
 	struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
+	struct crypto_alg *alg = tfm->base.__crt_alg;
+	unsigned int slen = req->slen;
 	int ret;
 
 	ret = tfm->decompress(req);
-	crypto_stat_decompress(req, ret);
+	crypto_stat_decompress(slen, ret, alg);
 	return ret;
 }
 
diff --git a/include/crypto/aead.h b/include/crypto/aead.h
index 99afd78c665d..c959cd39049d 100644
--- a/include/crypto/aead.h
+++ b/include/crypto/aead.h
@@ -306,30 +306,28 @@ static inline struct crypto_aead *crypto_aead_reqtfm(struct aead_request *req)
 	return __crypto_aead_cast(req->base.tfm);
 }
 
-static inline void crypto_stat_aead_encrypt(struct aead_request *req, int ret)
+static inline void crypto_stat_aead_encrypt(unsigned int cryptlen,
+					    struct crypto_alg *alg, int ret)
 {
 #ifdef CONFIG_CRYPTO_STATS
-	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-
 	if (ret && ret != -EINPROGRESS && ret != -EBUSY) {
-		atomic64_inc(&tfm->base.__crt_alg->aead_err_cnt);
+		atomic64_inc(&alg->aead_err_cnt);
 	} else {
-		atomic64_inc(&tfm->base.__crt_alg->encrypt_cnt);
-		atomic64_add(req->cryptlen, &tfm->base.__crt_alg->encrypt_tlen);
+		atomic64_inc(&alg->encrypt_cnt);
+		atomic64_add(cryptlen, &alg->encrypt_tlen);
 	}
 #endif
 }
 
-static inline void crypto_stat_aead_decrypt(struct aead_request *req, int ret)
+static inline void crypto_stat_aead_decrypt(unsigned int cryptlen,
+					    struct crypto_alg *alg, int ret)
 {
 #ifdef CONFIG_CRYPTO_STATS
-	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-
 	if (ret && ret != -EINPROGRESS && ret != -EBUSY) {
-		atomic64_inc(&tfm->base.__crt_alg->aead_err_cnt);
+		atomic64_inc(&alg->aead_err_cnt);
 	} else {
-		atomic64_inc(&tfm->base.__crt_alg->decrypt_cnt);
-		atomic64_add(req->cryptlen, &tfm->base.__crt_alg->decrypt_tlen);
+		atomic64_inc(&alg->decrypt_cnt);
+		atomic64_add(cryptlen, &alg->decrypt_tlen);
 	}
 #endif
 }
@@ -356,13 +354,15 @@ static inline void crypto_stat_aead_decrypt(struct aead_request *req, int ret)
 static inline int crypto_aead_encrypt(struct aead_request *req)
 {
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct crypto_alg *alg = aead->base.__crt_alg;
+	unsigned int cryptlen = req->cryptlen;
 	int ret;
 
 	if (crypto_aead_get_flags(aead) & CRYPTO_TFM_NEED_KEY)
 		ret = -ENOKEY;
 	else
 		ret = crypto_aead_alg(aead)->encrypt(req);
-	crypto_stat_aead_encrypt(req, ret);
+	crypto_stat_aead_encrypt(cryptlen, alg, ret);
 	return ret;
 }
 
@@ -391,6 +391,8 @@ static inline int crypto_aead_encrypt(struct aead_request *req)
 static inline int crypto_aead_decrypt(struct aead_request *req)
 {
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct crypto_alg *alg = aead->base.__crt_alg;
+	unsigned int cryptlen = req->cryptlen;
 	int ret;
 
 	if (crypto_aead_get_flags(aead) & CRYPTO_TFM_NEED_KEY)
@@ -399,7 +401,7 @@ static inline int crypto_aead_decrypt(struct aead_request *req)
 		ret = -EINVAL;
 	else
 		ret = crypto_aead_alg(aead)->decrypt(req);
-	crypto_stat_aead_decrypt(req, ret);
+	crypto_stat_aead_decrypt(cryptlen, alg, ret);
 	return ret;
 }
 
diff --git a/include/crypto/akcipher.h b/include/crypto/akcipher.h
index 97056fd5e718..f20cdb775674 100644
--- a/include/crypto/akcipher.h
+++ b/include/crypto/akcipher.h
@@ -271,59 +271,49 @@ static inline unsigned int crypto_akcipher_maxsize(struct crypto_akcipher *tfm)
 	return alg->max_size(tfm);
 }
 
-static inline void crypto_stat_akcipher_encrypt(struct akcipher_request *req,
-						int ret)
+static inline void crypto_stat_akcipher_encrypt(unsigned int src_len, int ret,
+						struct crypto_alg *alg)
 {
 #ifdef CONFIG_CRYPTO_STATS
-	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
-
 	if (ret && ret != -EINPROGRESS && ret != -EBUSY) {
-		atomic64_inc(&tfm->base.__crt_alg->akcipher_err_cnt);
+		atomic64_inc(&alg->akcipher_err_cnt);
 	} else {
-		atomic64_inc(&tfm->base.__crt_alg->encrypt_cnt);
-		atomic64_add(req->src_len, &tfm->base.__crt_alg->encrypt_tlen);
+		atomic64_inc(&alg->encrypt_cnt);
+		atomic64_add(src_len, &alg->encrypt_tlen);
 	}
 #endif
 }
 
-static inline void crypto_stat_akcipher_decrypt(struct akcipher_request *req,
-						int ret)
+static inline void crypto_stat_akcipher_decrypt(unsigned int src_len, int ret,
+						struct crypto_alg *alg)
 {
 #ifdef CONFIG_CRYPTO_STATS
-	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
-
 	if (ret && ret != -EINPROGRESS && ret != -EBUSY) {
-		atomic64_inc(&tfm->base.__crt_alg->akcipher_err_cnt);
+		atomic64_inc(&alg->akcipher_err_cnt);
 	} else {
-		atomic64_inc(&tfm->base.__crt_alg->decrypt_cnt);
-		atomic64_add(req->src_len, &tfm->base.__crt_alg->decrypt_tlen);
+		atomic64_inc(&alg->decrypt_cnt);
+		atomic64_add(src_len, &alg->decrypt_tlen);
 	}
 #endif
 }
 
-static inline void crypto_stat_akcipher_sign(struct akcipher_request *req,
-					     int ret)
+static inline void crypto_stat_akcipher_sign(int ret, struct crypto_alg *alg)
 {
 #ifdef CONFIG_CRYPTO_STATS
-	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
-
 	if (ret && ret != -EINPROGRESS && ret != -EBUSY)
-		atomic64_inc(&tfm->base.__crt_alg->akcipher_err_cnt);
+		atomic64_inc(&alg->akcipher_err_cnt);
 	else
-		atomic64_inc(&tfm->base.__crt_alg->sign_cnt);
+		atomic64_inc(&alg->sign_cnt);
 #endif
 }
 
-static inline void crypto_stat_akcipher_verify(struct akcipher_request *req,
-					       int ret)
+static inline void crypto_stat_akcipher_verify(int ret, struct crypto_alg *alg)
 {
 #ifdef CONFIG_CRYPTO_STATS
-	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
-
 	if (ret && ret != -EINPROGRESS && ret != -EBUSY)
-		atomic64_inc(&tfm->base.__crt_alg->akcipher_err_cnt);
+		atomic64_inc(&alg->akcipher_err_cnt);
 	else
-		atomic64_inc(&tfm->base.__crt_alg->verify_cnt);
+		atomic64_inc(&alg->verify_cnt);
 #endif
 }
 
@@ -341,10 +331,12 @@ static inline int crypto_akcipher_encrypt(struct akcipher_request *req)
 {
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
 	struct akcipher_alg *alg = crypto_akcipher_alg(tfm);
+	struct crypto_alg *calg = tfm->base.__crt_alg;
+	unsigned int src_len = req->src_len;
 	int ret;
 
 	ret = alg->encrypt(req);
-	crypto_stat_akcipher_encrypt(req, ret);
+	crypto_stat_akcipher_encrypt(src_len, ret, calg);
 	return ret;
 }
 
@@ -362,10 +354,12 @@ static inline int crypto_akcipher_decrypt(struct akcipher_request *req)
 {
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
 	struct akcipher_alg *alg = crypto_akcipher_alg(tfm);
+	struct crypto_alg *calg = tfm->base.__crt_alg;
+	unsigned int src_len = req->src_len;
 	int ret;
 
 	ret = alg->decrypt(req);
-	crypto_stat_akcipher_decrypt(req, ret);
+	crypto_stat_akcipher_decrypt(src_len, ret, calg);
 	return ret;
 }
 
@@ -383,10 +377,11 @@ static inline int crypto_akcipher_sign(struct akcipher_request *req)
 {
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
 	struct akcipher_alg *alg = crypto_akcipher_alg(tfm);
+	struct crypto_alg *calg = tfm->base.__crt_alg;
 	int ret;
 
 	ret = alg->sign(req);
-	crypto_stat_akcipher_sign(req, ret);
+	crypto_stat_akcipher_sign(ret, calg);
 	return ret;
 }
 
@@ -404,10 +399,11 @@ static inline int crypto_akcipher_verify(struct akcipher_request *req)
 {
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
 	struct akcipher_alg *alg = crypto_akcipher_alg(tfm);
+	struct crypto_alg *calg = tfm->base.__crt_alg;
 	int ret;
 
 	ret = alg->verify(req);
-	crypto_stat_akcipher_verify(req, ret);
+	crypto_stat_akcipher_verify(ret, calg);
 	return ret;
 }
 
diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index 52920bed05ba..83fe47f34db1 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -412,28 +412,26 @@ static inline void *ahash_request_ctx(struct ahash_request *req)
 int crypto_ahash_setkey(struct crypto_ahash *tfm, const u8 *key,
 			unsigned int keylen);
 
-static inline void crypto_stat_ahash_update(struct ahash_request *req, int ret)
+static inline void crypto_stat_ahash_update(unsigned int nbytes, int ret,
+					    struct crypto_alg *alg)
 {
 #ifdef CONFIG_CRYPTO_STATS
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-
 	if (ret && ret != -EINPROGRESS && ret != -EBUSY)
-		atomic64_inc(&tfm->base.__crt_alg->hash_err_cnt);
+		atomic64_inc(&alg->hash_err_cnt);
 	else
-		atomic64_add(req->nbytes, &tfm->base.__crt_alg->hash_tlen);
+		atomic64_add(nbytes, &alg->hash_tlen);
 #endif
 }
 
-static inline void crypto_stat_ahash_final(struct ahash_request *req, int ret)
+static inline void crypto_stat_ahash_final(unsigned int nbytes, int ret,
+					   struct crypto_alg *alg)
 {
 #ifdef CONFIG_CRYPTO_STATS
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-
 	if (ret && ret != -EINPROGRESS && ret != -EBUSY) {
-		atomic64_inc(&tfm->base.__crt_alg->hash_err_cnt);
+		atomic64_inc(&alg->hash_err_cnt);
 	} else {
-		atomic64_inc(&tfm->base.__crt_alg->hash_cnt);
-		atomic64_add(req->nbytes, &tfm->base.__crt_alg->hash_tlen);
+		atomic64_inc(&alg->hash_cnt);
+		atomic64_add(nbytes, &alg->hash_tlen);
 	}
 #endif
 }
@@ -552,10 +550,13 @@ static inline int crypto_ahash_init(struct ahash_request *req)
  */
 static inline int crypto_ahash_update(struct ahash_request *req)
 {
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct crypto_alg *alg = tfm->base.__crt_alg;
+	unsigned int nbytes = req->nbytes;
 	int ret;
 
 	ret = crypto_ahash_reqtfm(req)->update(req);
-	crypto_stat_ahash_update(req, ret);
+	crypto_stat_ahash_update(nbytes, ret, alg);
 	return ret;
 }
 
diff --git a/include/crypto/kpp.h b/include/crypto/kpp.h
index bd5103a80919..525689505b49 100644
--- a/include/crypto/kpp.h
+++ b/include/crypto/kpp.h
@@ -278,29 +278,25 @@ static inline void crypto_stat_kpp_set_secret(struct crypto_kpp *tfm, int ret)
 #endif
 }
 
-static inline void crypto_stat_kpp_generate_public_key(struct kpp_request *req,
+static inline void crypto_stat_kpp_generate_public_key(struct crypto_alg *alg,
 						       int ret)
 {
 #ifdef CONFIG_CRYPTO_STATS
-	struct crypto_kpp *tfm = crypto_kpp_reqtfm(req);
-
 	if (ret)
-		atomic64_inc(&tfm->base.__crt_alg->kpp_err_cnt);
+		atomic64_inc(&alg->kpp_err_cnt);
 	else
-		atomic64_inc(&tfm->base.__crt_alg->generate_public_key_cnt);
+		atomic64_inc(&alg->generate_public_key_cnt);
 #endif
 }
 
-static inline void crypto_stat_kpp_compute_shared_secret(struct kpp_request *req,
+static inline void crypto_stat_kpp_compute_shared_secret(struct crypto_alg *alg,
 							 int ret)
 {
 #ifdef CONFIG_CRYPTO_STATS
-	struct crypto_kpp *tfm = crypto_kpp_reqtfm(req);
-
 	if (ret)
-		atomic64_inc(&tfm->base.__crt_alg->kpp_err_cnt);
+		atomic64_inc(&alg->kpp_err_cnt);
 	else
-		atomic64_inc(&tfm->base.__crt_alg->compute_shared_secret_cnt);
+		atomic64_inc(&alg->compute_shared_secret_cnt);
 #endif
 }
 
@@ -347,10 +343,11 @@ static inline int crypto_kpp_generate_public_key(struct kpp_request *req)
 {
 	struct crypto_kpp *tfm = crypto_kpp_reqtfm(req);
 	struct kpp_alg *alg = crypto_kpp_alg(tfm);
+	struct crypto_alg *calg = tfm->base.__crt_alg;
 	int ret;
 
 	ret = alg->generate_public_key(req);
-	crypto_stat_kpp_generate_public_key(req, ret);
+	crypto_stat_kpp_generate_public_key(calg, ret);
 	return ret;
 }
 
@@ -368,10 +365,11 @@ static inline int crypto_kpp_compute_shared_secret(struct kpp_request *req)
 {
 	struct crypto_kpp *tfm = crypto_kpp_reqtfm(req);
 	struct kpp_alg *alg = crypto_kpp_alg(tfm);
+	struct crypto_alg *calg = tfm->base.__crt_alg;
 	int ret;
 
 	ret = alg->compute_shared_secret(req);
-	crypto_stat_kpp_compute_shared_secret(req, ret);
+	crypto_stat_kpp_compute_shared_secret(calg, ret);
 	return ret;
 }
 
diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index dff54731ddf4..a68b227de96c 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -486,7 +486,7 @@ static inline struct crypto_sync_skcipher *crypto_sync_skcipher_reqtfm(
 	return container_of(tfm, struct crypto_sync_skcipher, base);
 }
 
-static inline void crypto_stat_skcipher_encrypt(struct skcipher_request *req,
+static inline void crypto_stat_skcipher_encrypt(unsigned int cryptlen,
 						int ret, struct crypto_alg *alg)
 {
 #ifdef CONFIG_CRYPTO_STATS
@@ -494,12 +494,12 @@ static inline void crypto_stat_skcipher_encrypt(struct skcipher_request *req,
 		atomic64_inc(&alg->cipher_err_cnt);
 	} else {
 		atomic64_inc(&alg->encrypt_cnt);
-		atomic64_add(req->cryptlen, &alg->encrypt_tlen);
+		atomic64_add(cryptlen, &alg->encrypt_tlen);
 	}
 #endif
 }
 
-static inline void crypto_stat_skcipher_decrypt(struct skcipher_request *req,
+static inline void crypto_stat_skcipher_decrypt(unsigned int cryptlen,
 						int ret, struct crypto_alg *alg)
 {
 #ifdef CONFIG_CRYPTO_STATS
@@ -507,7 +507,7 @@ static inline void crypto_stat_skcipher_decrypt(struct skcipher_request *req,
 		atomic64_inc(&alg->cipher_err_cnt);
 	} else {
 		atomic64_inc(&alg->decrypt_cnt);
-		atomic64_add(req->cryptlen, &alg->decrypt_tlen);
+		atomic64_add(cryptlen, &alg->decrypt_tlen);
 	}
 #endif
 }
@@ -526,13 +526,15 @@ static inline void crypto_stat_skcipher_decrypt(struct skcipher_request *req,
 static inline int crypto_skcipher_encrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct crypto_alg *alg = tfm->base.__crt_alg;
+	unsigned int cryptlen = req->cryptlen;
 	int ret;
 
 	if (crypto_skcipher_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
 		ret = -ENOKEY;
 	else
 		ret = tfm->encrypt(req);
-	crypto_stat_skcipher_encrypt(req, ret, tfm->base.__crt_alg);
+	crypto_stat_skcipher_encrypt(cryptlen, ret, alg);
 	return ret;
 }
 
@@ -550,13 +552,15 @@ static inline int crypto_skcipher_encrypt(struct skcipher_request *req)
 static inline int crypto_skcipher_decrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct crypto_alg *alg = tfm->base.__crt_alg;
+	unsigned int cryptlen = req->cryptlen;
 	int ret;
 
 	if (crypto_skcipher_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
 		ret = -ENOKEY;
 	else
 		ret = tfm->decrypt(req);
-	crypto_stat_skcipher_decrypt(req, ret, tfm->base.__crt_alg);
+	crypto_stat_skcipher_decrypt(cryptlen, ret, alg);
 	return ret;
 }
 
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 7d913330402e..b9ab028ce862 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -975,34 +975,28 @@ static inline struct crypto_ablkcipher *crypto_ablkcipher_reqtfm(
 	return __crypto_ablkcipher_cast(req->base.tfm);
 }
 
-static inline void crypto_stat_ablkcipher_encrypt(struct ablkcipher_request *req,
-						  int ret)
+static inline void crypto_stat_ablkcipher_encrypt(unsigned int nbytes, int ret,
+						  struct crypto_alg *alg)
 {
 #ifdef CONFIG_CRYPTO_STATS
-	struct ablkcipher_tfm *crt =
-		crypto_ablkcipher_crt(crypto_ablkcipher_reqtfm(req));
-
 	if (ret && ret != -EINPROGRESS && ret != -EBUSY) {
-		atomic64_inc(&crt->base->base.__crt_alg->cipher_err_cnt);
+		atomic64_inc(&alg->cipher_err_cnt);
 	} else {
-		atomic64_inc(&crt->base->base.__crt_alg->encrypt_cnt);
-		atomic64_add(req->nbytes, &crt->base->base.__crt_alg->encrypt_tlen);
+		atomic64_inc(&alg->encrypt_cnt);
+		atomic64_add(nbytes, &alg->encrypt_tlen);
 	}
 #endif
 }
 
-static inline void crypto_stat_ablkcipher_decrypt(struct ablkcipher_request *req,
-						  int ret)
+static inline void crypto_stat_ablkcipher_decrypt(unsigned int nbytes, int ret,
+						  struct crypto_alg *alg)
 {
 #ifdef CONFIG_CRYPTO_STATS
-	struct ablkcipher_tfm *crt =
-		crypto_ablkcipher_crt(crypto_ablkcipher_reqtfm(req));
-
 	if (ret && ret != -EINPROGRESS && ret != -EBUSY) {
-		atomic64_inc(&crt->base->base.__crt_alg->cipher_err_cnt);
+		atomic64_inc(&alg->cipher_err_cnt);
 	} else {
-		atomic64_inc(&crt->base->base.__crt_alg->decrypt_cnt);
-		atomic64_add(req->nbytes, &crt->base->base.__crt_alg->decrypt_tlen);
+		atomic64_inc(&alg->decrypt_cnt);
+		atomic64_add(nbytes, &alg->decrypt_tlen);
 	}
 #endif
 }
@@ -1022,10 +1016,12 @@ static inline int crypto_ablkcipher_encrypt(struct ablkcipher_request *req)
 {
 	struct ablkcipher_tfm *crt =
 		crypto_ablkcipher_crt(crypto_ablkcipher_reqtfm(req));
+	struct crypto_alg *alg = crt->base->base.__crt_alg;
+	unsigned int nbytes = req->nbytes;
 	int ret;
 
 	ret = crt->encrypt(req);
-	crypto_stat_ablkcipher_encrypt(req, ret);
+	crypto_stat_ablkcipher_encrypt(nbytes, ret, alg);
 	return ret;
 }
 
@@ -1044,10 +1040,12 @@ static inline int crypto_ablkcipher_decrypt(struct ablkcipher_request *req)
 {
 	struct ablkcipher_tfm *crt =
 		crypto_ablkcipher_crt(crypto_ablkcipher_reqtfm(req));
+	struct crypto_alg *alg = crt->base->base.__crt_alg;
+	unsigned int nbytes = req->nbytes;
 	int ret;
 
 	ret = crt->decrypt(req);
-	crypto_stat_ablkcipher_decrypt(req, ret);
+	crypto_stat_ablkcipher_decrypt(nbytes, ret, alg);
 	return ret;
 }
 
-- 
2.18.1
