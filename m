Return-Path: <SRS0=Oq1A=OC=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43691 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2504038AbeKWWqt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Nov 2018 17:46:49 -0500
Received: by mail-wr1-f68.google.com with SMTP id r10so12083427wrs.10
        for <linux-crypto@vger.kernel.org>; Fri, 23 Nov 2018 04:02:50 -0800 (PST)
From: Corentin Labbe <clabbe@baylibre.com>
To: davem@davemloft.net, ebiggers@kernel.org,
        herbert@gondor.apana.org.au, nhorman@tuxdriver.com
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v4 10/11] crypto: crypto_user_stat: rename err_cnt parameter
Date: Fri, 23 Nov 2018 12:02:20 +0000
Message-Id: <1542974541-23024-11-git-send-email-clabbe@baylibre.com>
In-Reply-To: <1542974541-23024-1-git-send-email-clabbe@baylibre.com>
References: <1542974541-23024-1-git-send-email-clabbe@baylibre.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Since now all crypto stats are on their own structures, it is now
useless to have the algorithm name in the err_cnt member.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 crypto/algapi.c                 | 38 ++++++++++++++++-----------------
 crypto/crypto_user_stat.c       | 18 ++++++++--------
 include/linux/crypto.h          | 28 ++++++++++++------------
 include/uapi/linux/cryptouser.h | 14 ++++++------
 tools/crypto/getstat.c          | 18 ++++++++--------
 5 files changed, 58 insertions(+), 58 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 62a275b6d352..84e9b4e5389a 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -1082,7 +1082,7 @@ void crypto_stats_ablkcipher_encrypt(unsigned int nbytes, int ret,
 				     struct crypto_alg *alg)
 {
 	if (ret && ret != -EINPROGRESS && ret != -EBUSY) {
-		atomic64_inc(&alg->stats.cipher.cipher_err_cnt);
+		atomic64_inc(&alg->stats.cipher.err_cnt);
 	} else {
 		atomic64_inc(&alg->stats.cipher.encrypt_cnt);
 		atomic64_add(nbytes, &alg->stats.cipher.encrypt_tlen);
@@ -1094,7 +1094,7 @@ void crypto_stats_ablkcipher_decrypt(unsigned int nbytes, int ret,
 				     struct crypto_alg *alg)
 {
 	if (ret && ret != -EINPROGRESS && ret != -EBUSY) {
-		atomic64_inc(&alg->stats.cipher.cipher_err_cnt);
+		atomic64_inc(&alg->stats.cipher.err_cnt);
 	} else {
 		atomic64_inc(&alg->stats.cipher.decrypt_cnt);
 		atomic64_add(nbytes, &alg->stats.cipher.decrypt_tlen);
@@ -1106,7 +1106,7 @@ void crypto_stats_aead_encrypt(unsigned int cryptlen, struct crypto_alg *alg,
 			       int ret)
 {
 	if (ret && ret != -EINPROGRESS && ret != -EBUSY) {
-		atomic64_inc(&alg->stats.aead.aead_err_cnt);
+		atomic64_inc(&alg->stats.aead.err_cnt);
 	} else {
 		atomic64_inc(&alg->stats.aead.encrypt_cnt);
 		atomic64_add(cryptlen, &alg->stats.aead.encrypt_tlen);
@@ -1118,7 +1118,7 @@ void crypto_stats_aead_decrypt(unsigned int cryptlen, struct crypto_alg *alg,
 			       int ret)
 {
 	if (ret && ret != -EINPROGRESS && ret != -EBUSY) {
-		atomic64_inc(&alg->stats.aead.aead_err_cnt);
+		atomic64_inc(&alg->stats.aead.err_cnt);
 	} else {
 		atomic64_inc(&alg->stats.aead.decrypt_cnt);
 		atomic64_add(cryptlen, &alg->stats.aead.decrypt_tlen);
@@ -1130,7 +1130,7 @@ void crypto_stats_akcipher_encrypt(unsigned int src_len, int ret,
 				   struct crypto_alg *alg)
 {
 	if (ret && ret != -EINPROGRESS && ret != -EBUSY) {
-		atomic64_inc(&alg->stats.akcipher.akcipher_err_cnt);
+		atomic64_inc(&alg->stats.akcipher.err_cnt);
 	} else {
 		atomic64_inc(&alg->stats.akcipher.encrypt_cnt);
 		atomic64_add(src_len, &alg->stats.akcipher.encrypt_tlen);
@@ -1142,7 +1142,7 @@ void crypto_stats_akcipher_decrypt(unsigned int src_len, int ret,
 				   struct crypto_alg *alg)
 {
 	if (ret && ret != -EINPROGRESS && ret != -EBUSY) {
-		atomic64_inc(&alg->stats.akcipher.akcipher_err_cnt);
+		atomic64_inc(&alg->stats.akcipher.err_cnt);
 	} else {
 		atomic64_inc(&alg->stats.akcipher.decrypt_cnt);
 		atomic64_add(src_len, &alg->stats.akcipher.decrypt_tlen);
@@ -1153,7 +1153,7 @@ void crypto_stats_akcipher_decrypt(unsigned int src_len, int ret,
 void crypto_stats_akcipher_sign(int ret, struct crypto_alg *alg)
 {
 	if (ret && ret != -EINPROGRESS && ret != -EBUSY)
-		atomic64_inc(&alg->stats.akcipher.akcipher_err_cnt);
+		atomic64_inc(&alg->stats.akcipher.err_cnt);
 	else
 		atomic64_inc(&alg->stats.akcipher.sign_cnt);
 	crypto_alg_put(alg);
@@ -1162,7 +1162,7 @@ void crypto_stats_akcipher_sign(int ret, struct crypto_alg *alg)
 void crypto_stats_akcipher_verify(int ret, struct crypto_alg *alg)
 {
 	if (ret && ret != -EINPROGRESS && ret != -EBUSY)
-		atomic64_inc(&alg->stats.akcipher.akcipher_err_cnt);
+		atomic64_inc(&alg->stats.akcipher.err_cnt);
 	else
 		atomic64_inc(&alg->stats.akcipher.verify_cnt);
 	crypto_alg_put(alg);
@@ -1171,7 +1171,7 @@ void crypto_stats_akcipher_verify(int ret, struct crypto_alg *alg)
 void crypto_stats_compress(unsigned int slen, int ret, struct crypto_alg *alg)
 {
 	if (ret && ret != -EINPROGRESS && ret != -EBUSY) {
-		atomic64_inc(&alg->stats.compress.compress_err_cnt);
+		atomic64_inc(&alg->stats.compress.err_cnt);
 	} else {
 		atomic64_inc(&alg->stats.compress.compress_cnt);
 		atomic64_add(slen, &alg->stats.compress.compress_tlen);
@@ -1182,7 +1182,7 @@ void crypto_stats_compress(unsigned int slen, int ret, struct crypto_alg *alg)
 void crypto_stats_decompress(unsigned int slen, int ret, struct crypto_alg *alg)
 {
 	if (ret && ret != -EINPROGRESS && ret != -EBUSY) {
-		atomic64_inc(&alg->stats.compress.compress_err_cnt);
+		atomic64_inc(&alg->stats.compress.err_cnt);
 	} else {
 		atomic64_inc(&alg->stats.compress.decompress_cnt);
 		atomic64_add(slen, &alg->stats.compress.decompress_tlen);
@@ -1194,7 +1194,7 @@ void crypto_stats_ahash_update(unsigned int nbytes, int ret,
 			       struct crypto_alg *alg)
 {
 	if (ret && ret != -EINPROGRESS && ret != -EBUSY)
-		atomic64_inc(&alg->stats.hash.hash_err_cnt);
+		atomic64_inc(&alg->stats.hash.err_cnt);
 	else
 		atomic64_add(nbytes, &alg->stats.hash.hash_tlen);
 	crypto_alg_put(alg);
@@ -1204,7 +1204,7 @@ void crypto_stats_ahash_final(unsigned int nbytes, int ret,
 			      struct crypto_alg *alg)
 {
 	if (ret && ret != -EINPROGRESS && ret != -EBUSY) {
-		atomic64_inc(&alg->stats.hash.hash_err_cnt);
+		atomic64_inc(&alg->stats.hash.err_cnt);
 	} else {
 		atomic64_inc(&alg->stats.hash.hash_cnt);
 		atomic64_add(nbytes, &alg->stats.hash.hash_tlen);
@@ -1215,7 +1215,7 @@ void crypto_stats_ahash_final(unsigned int nbytes, int ret,
 void crypto_stats_kpp_set_secret(struct crypto_alg *alg, int ret)
 {
 	if (ret)
-		atomic64_inc(&alg->stats.kpp.kpp_err_cnt);
+		atomic64_inc(&alg->stats.kpp.err_cnt);
 	else
 		atomic64_inc(&alg->stats.kpp.setsecret_cnt);
 	crypto_alg_put(alg);
@@ -1224,7 +1224,7 @@ void crypto_stats_kpp_set_secret(struct crypto_alg *alg, int ret)
 void crypto_stats_kpp_generate_public_key(struct crypto_alg *alg, int ret)
 {
 	if (ret)
-		atomic64_inc(&alg->stats.kpp.kpp_err_cnt);
+		atomic64_inc(&alg->stats.kpp.err_cnt);
 	else
 		atomic64_inc(&alg->stats.kpp.generate_public_key_cnt);
 	crypto_alg_put(alg);
@@ -1233,7 +1233,7 @@ void crypto_stats_kpp_generate_public_key(struct crypto_alg *alg, int ret)
 void crypto_stats_kpp_compute_shared_secret(struct crypto_alg *alg, int ret)
 {
 	if (ret)
-		atomic64_inc(&alg->stats.kpp.kpp_err_cnt);
+		atomic64_inc(&alg->stats.kpp.err_cnt);
 	else
 		atomic64_inc(&alg->stats.kpp.compute_shared_secret_cnt);
 	crypto_alg_put(alg);
@@ -1242,7 +1242,7 @@ void crypto_stats_kpp_compute_shared_secret(struct crypto_alg *alg, int ret)
 void crypto_stats_rng_seed(struct crypto_alg *alg, int ret)
 {
 	if (ret && ret != -EINPROGRESS && ret != -EBUSY)
-		atomic64_inc(&alg->stats.rng.rng_err_cnt);
+		atomic64_inc(&alg->stats.rng.err_cnt);
 	else
 		atomic64_inc(&alg->stats.rng.seed_cnt);
 	crypto_alg_put(alg);
@@ -1252,7 +1252,7 @@ void crypto_stats_rng_generate(struct crypto_alg *alg, unsigned int dlen,
 			       int ret)
 {
 	if (ret && ret != -EINPROGRESS && ret != -EBUSY) {
-		atomic64_inc(&alg->stats.rng.rng_err_cnt);
+		atomic64_inc(&alg->stats.rng.err_cnt);
 	} else {
 		atomic64_inc(&alg->stats.rng.generate_cnt);
 		atomic64_add(dlen, &alg->stats.rng.generate_tlen);
@@ -1264,7 +1264,7 @@ void crypto_stats_skcipher_encrypt(unsigned int cryptlen, int ret,
 				   struct crypto_alg *alg)
 {
 	if (ret && ret != -EINPROGRESS && ret != -EBUSY) {
-		atomic64_inc(&alg->stats.cipher.cipher_err_cnt);
+		atomic64_inc(&alg->stats.cipher.err_cnt);
 	} else {
 		atomic64_inc(&alg->stats.cipher.encrypt_cnt);
 		atomic64_add(cryptlen, &alg->stats.cipher.encrypt_tlen);
@@ -1276,7 +1276,7 @@ void crypto_stats_skcipher_decrypt(unsigned int cryptlen, int ret,
 				   struct crypto_alg *alg)
 {
 	if (ret && ret != -EINPROGRESS && ret != -EBUSY) {
-		atomic64_inc(&alg->stats.cipher.cipher_err_cnt);
+		atomic64_inc(&alg->stats.cipher.err_cnt);
 	} else {
 		atomic64_inc(&alg->stats.cipher.decrypt_cnt);
 		atomic64_add(cryptlen, &alg->stats.cipher.decrypt_tlen);
diff --git a/crypto/crypto_user_stat.c b/crypto/crypto_user_stat.c
index 113bf1691560..0ba00aaeb810 100644
--- a/crypto/crypto_user_stat.c
+++ b/crypto/crypto_user_stat.c
@@ -43,7 +43,7 @@ static int crypto_report_aead(struct sk_buff *skb, struct crypto_alg *alg)
 	raead.stat_encrypt_tlen = atomic64_read(&alg->stats.aead.encrypt_tlen);
 	raead.stat_decrypt_cnt = atomic64_read(&alg->stats.aead.decrypt_cnt);
 	raead.stat_decrypt_tlen = atomic64_read(&alg->stats.aead.decrypt_tlen);
-	raead.stat_aead_err_cnt = atomic64_read(&alg->stats.aead.aead_err_cnt);
+	raead.stat_err_cnt = atomic64_read(&alg->stats.aead.err_cnt);
 
 	return nla_put(skb, CRYPTOCFGA_STAT_AEAD, sizeof(raead), &raead);
 }
@@ -60,7 +60,7 @@ static int crypto_report_cipher(struct sk_buff *skb, struct crypto_alg *alg)
 	rcipher.stat_encrypt_tlen = atomic64_read(&alg->stats.cipher.encrypt_tlen);
 	rcipher.stat_decrypt_cnt =  atomic64_read(&alg->stats.cipher.decrypt_cnt);
 	rcipher.stat_decrypt_tlen = atomic64_read(&alg->stats.cipher.decrypt_tlen);
-	rcipher.stat_cipher_err_cnt =  atomic64_read(&alg->stats.cipher.cipher_err_cnt);
+	rcipher.stat_err_cnt =  atomic64_read(&alg->stats.cipher.err_cnt);
 
 	return nla_put(skb, CRYPTOCFGA_STAT_CIPHER, sizeof(rcipher), &rcipher);
 }
@@ -76,7 +76,7 @@ static int crypto_report_comp(struct sk_buff *skb, struct crypto_alg *alg)
 	rcomp.stat_compress_tlen = atomic64_read(&alg->stats.compress.compress_tlen);
 	rcomp.stat_decompress_cnt = atomic64_read(&alg->stats.compress.decompress_cnt);
 	rcomp.stat_decompress_tlen = atomic64_read(&alg->stats.compress.decompress_tlen);
-	rcomp.stat_compress_err_cnt = atomic64_read(&alg->stats.compress.compress_err_cnt);
+	rcomp.stat_err_cnt = atomic64_read(&alg->stats.compress.err_cnt);
 
 	return nla_put(skb, CRYPTOCFGA_STAT_COMPRESS, sizeof(rcomp), &rcomp);
 }
@@ -92,7 +92,7 @@ static int crypto_report_acomp(struct sk_buff *skb, struct crypto_alg *alg)
 	racomp.stat_compress_tlen = atomic64_read(&alg->stats.compress.compress_tlen);
 	racomp.stat_decompress_cnt =  atomic64_read(&alg->stats.compress.decompress_cnt);
 	racomp.stat_decompress_tlen = atomic64_read(&alg->stats.compress.decompress_tlen);
-	racomp.stat_compress_err_cnt = atomic64_read(&alg->stats.compress.compress_err_cnt);
+	racomp.stat_err_cnt = atomic64_read(&alg->stats.compress.err_cnt);
 
 	return nla_put(skb, CRYPTOCFGA_STAT_ACOMP, sizeof(racomp), &racomp);
 }
@@ -110,7 +110,7 @@ static int crypto_report_akcipher(struct sk_buff *skb, struct crypto_alg *alg)
 	rakcipher.stat_decrypt_tlen = atomic64_read(&alg->stats.akcipher.decrypt_tlen);
 	rakcipher.stat_sign_cnt = atomic64_read(&alg->stats.akcipher.sign_cnt);
 	rakcipher.stat_verify_cnt = atomic64_read(&alg->stats.akcipher.verify_cnt);
-	rakcipher.stat_akcipher_err_cnt = atomic64_read(&alg->stats.akcipher.akcipher_err_cnt);
+	rakcipher.stat_err_cnt = atomic64_read(&alg->stats.akcipher.err_cnt);
 
 	return nla_put(skb, CRYPTOCFGA_STAT_AKCIPHER,
 		       sizeof(rakcipher), &rakcipher);
@@ -127,7 +127,7 @@ static int crypto_report_kpp(struct sk_buff *skb, struct crypto_alg *alg)
 	rkpp.stat_setsecret_cnt = atomic64_read(&alg->stats.kpp.setsecret_cnt);
 	rkpp.stat_generate_public_key_cnt = atomic64_read(&alg->stats.kpp.generate_public_key_cnt);
 	rkpp.stat_compute_shared_secret_cnt = atomic64_read(&alg->stats.kpp.compute_shared_secret_cnt);
-	rkpp.stat_kpp_err_cnt = atomic64_read(&alg->stats.kpp.kpp_err_cnt);
+	rkpp.stat_err_cnt = atomic64_read(&alg->stats.kpp.err_cnt);
 
 	return nla_put(skb, CRYPTOCFGA_STAT_KPP, sizeof(rkpp), &rkpp);
 }
@@ -142,7 +142,7 @@ static int crypto_report_ahash(struct sk_buff *skb, struct crypto_alg *alg)
 
 	rhash.stat_hash_cnt = atomic64_read(&alg->stats.hash.hash_cnt);
 	rhash.stat_hash_tlen = atomic64_read(&alg->stats.hash.hash_tlen);
-	rhash.stat_hash_err_cnt = atomic64_read(&alg->stats.hash.hash_err_cnt);
+	rhash.stat_err_cnt = atomic64_read(&alg->stats.hash.err_cnt);
 
 	return nla_put(skb, CRYPTOCFGA_STAT_HASH, sizeof(rhash), &rhash);
 }
@@ -157,7 +157,7 @@ static int crypto_report_shash(struct sk_buff *skb, struct crypto_alg *alg)
 
 	rhash.stat_hash_cnt =  atomic64_read(&alg->stats.hash.hash_cnt);
 	rhash.stat_hash_tlen = atomic64_read(&alg->stats.hash.hash_tlen);
-	rhash.stat_hash_err_cnt = atomic64_read(&alg->stats.hash.hash_err_cnt);
+	rhash.stat_err_cnt = atomic64_read(&alg->stats.hash.err_cnt);
 
 	return nla_put(skb, CRYPTOCFGA_STAT_HASH, sizeof(rhash), &rhash);
 }
@@ -173,7 +173,7 @@ static int crypto_report_rng(struct sk_buff *skb, struct crypto_alg *alg)
 	rrng.stat_generate_cnt = atomic64_read(&alg->stats.rng.generate_cnt);
 	rrng.stat_generate_tlen = atomic64_read(&alg->stats.rng.generate_tlen);
 	rrng.stat_seed_cnt = atomic64_read(&alg->stats.rng.seed_cnt);
-	rrng.stat_rng_err_cnt = atomic64_read(&alg->stats.rng.rng_err_cnt);
+	rrng.stat_err_cnt = atomic64_read(&alg->stats.rng.err_cnt);
 
 	return nla_put(skb, CRYPTOCFGA_STAT_RNG, sizeof(rrng), &rrng);
 }
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index e5616b311104..132a052b3483 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -376,14 +376,14 @@ struct compress_alg {
  * @encrypt_tlen:	total data size handled by encrypt requests
  * @decrypt_cnt:	number of decrypt requests
  * @decrypt_tlen:	total data size handled by decrypt requests
- * @aead_err_cnt:	number of error for AEAD requests
+ * @err_cnt:		number of error for AEAD requests
  */
 struct crypto_istat_aead {
 	atomic64_t encrypt_cnt;
 	atomic64_t encrypt_tlen;
 	atomic64_t decrypt_cnt;
 	atomic64_t decrypt_tlen;
-	atomic64_t aead_err_cnt;
+	atomic64_t err_cnt;
 };
 
 /*
@@ -394,7 +394,7 @@ struct crypto_istat_aead {
  * @decrypt_tlen:	total data size handled by decrypt requests
  * @verify_cnt:		number of verify operation
  * @sign_cnt:		number of sign requests
- * @akcipher_err_cnt:	number of error for akcipher requests
+ * @err_cnt:		number of error for akcipher requests
  */
 struct crypto_istat_akcipher {
 	atomic64_t encrypt_cnt;
@@ -403,7 +403,7 @@ struct crypto_istat_akcipher {
 	atomic64_t decrypt_tlen;
 	atomic64_t verify_cnt;
 	atomic64_t sign_cnt;
-	atomic64_t akcipher_err_cnt;
+	atomic64_t err_cnt;
 };
 
 /*
@@ -412,14 +412,14 @@ struct crypto_istat_akcipher {
  * @encrypt_tlen:	total data size handled by encrypt requests
  * @decrypt_cnt:	number of decrypt requests
  * @decrypt_tlen:	total data size handled by decrypt requests
- * @cipher_err_cnt:	number of error for cipher requests
+ * @err_cnt:		number of error for cipher requests
  */
 struct crypto_istat_cipher {
 	atomic64_t encrypt_cnt;
 	atomic64_t encrypt_tlen;
 	atomic64_t decrypt_cnt;
 	atomic64_t decrypt_tlen;
-	atomic64_t cipher_err_cnt;
+	atomic64_t err_cnt;
 };
 
 /*
@@ -428,26 +428,26 @@ struct crypto_istat_cipher {
  * @compress_tlen:	total data size handled by compress requests
  * @decompress_cnt:	number of decompress requests
  * @decompress_tlen:	total data size handled by decompress requests
- * @compress_err_cnt:	number of error for compress requests
+ * @err_cnt:		number of error for compress requests
  */
 struct crypto_istat_compress {
 	atomic64_t compress_cnt;
 	atomic64_t compress_tlen;
 	atomic64_t decompress_cnt;
 	atomic64_t decompress_tlen;
-	atomic64_t compress_err_cnt;
+	atomic64_t err_cnt;
 };
 
 /*
  * struct crypto_istat_hash - statistics for has algorithm
  * @hash_cnt:		number of hash requests
  * @hash_tlen:		total data size hashed
- * @hash_err_cnt:	number of error for hash requests
+ * @err_cnt:		number of error for hash requests
  */
 struct crypto_istat_hash {
 	atomic64_t hash_cnt;
 	atomic64_t hash_tlen;
-	atomic64_t hash_err_cnt;
+	atomic64_t err_cnt;
 };
 
 /*
@@ -455,13 +455,13 @@ struct crypto_istat_hash {
  * @setsecret_cnt:		number of setsecrey operation
  * @generate_public_key_cnt:	number of generate_public_key operation
  * @compute_shared_secret_cnt:	number of compute_shared_secret operation
- * @kpp_err_cnt:		number of error for KPP requests
+ * @err_cnt:			number of error for KPP requests
  */
 struct crypto_istat_kpp {
 	atomic64_t setsecret_cnt;
 	atomic64_t generate_public_key_cnt;
 	atomic64_t compute_shared_secret_cnt;
-	atomic64_t kpp_err_cnt;
+	atomic64_t err_cnt;
 };
 
 /*
@@ -469,13 +469,13 @@ struct crypto_istat_kpp {
  * @generate_cnt:	number of RNG generate requests
  * @generate_tlen:	total data size of generated data by the RNG
  * @seed_cnt:		number of times the RNG was seeded
- * @rng_err_cnt:	number of error for RNG requests
+ * @err_cnt:		number of error for RNG requests
  */
 struct crypto_istat_rng {
 	atomic64_t generate_cnt;
 	atomic64_t generate_tlen;
 	atomic64_t seed_cnt;
-	atomic64_t rng_err_cnt;
+	atomic64_t err_cnt;
 };
 #endif /* CONFIG_CRYPTO_STATS */
 
diff --git a/include/uapi/linux/cryptouser.h b/include/uapi/linux/cryptouser.h
index 3a70f025e27d..4dc1603919ce 100644
--- a/include/uapi/linux/cryptouser.h
+++ b/include/uapi/linux/cryptouser.h
@@ -82,7 +82,7 @@ struct crypto_stat_aead {
 	__u64 stat_encrypt_tlen;
 	__u64 stat_decrypt_cnt;
 	__u64 stat_decrypt_tlen;
-	__u64 stat_aead_err_cnt;
+	__u64 stat_err_cnt;
 };
 
 struct crypto_stat_akcipher {
@@ -93,7 +93,7 @@ struct crypto_stat_akcipher {
 	__u64 stat_decrypt_tlen;
 	__u64 stat_verify_cnt;
 	__u64 stat_sign_cnt;
-	__u64 stat_akcipher_err_cnt;
+	__u64 stat_err_cnt;
 };
 
 struct crypto_stat_cipher {
@@ -102,7 +102,7 @@ struct crypto_stat_cipher {
 	__u64 stat_encrypt_tlen;
 	__u64 stat_decrypt_cnt;
 	__u64 stat_decrypt_tlen;
-	__u64 stat_cipher_err_cnt;
+	__u64 stat_err_cnt;
 };
 
 struct crypto_stat_compress {
@@ -111,14 +111,14 @@ struct crypto_stat_compress {
 	__u64 stat_compress_tlen;
 	__u64 stat_decompress_cnt;
 	__u64 stat_decompress_tlen;
-	__u64 stat_compress_err_cnt;
+	__u64 stat_err_cnt;
 };
 
 struct crypto_stat_hash {
 	char type[CRYPTO_MAX_NAME];
 	__u64 stat_hash_cnt;
 	__u64 stat_hash_tlen;
-	__u64 stat_hash_err_cnt;
+	__u64 stat_err_cnt;
 };
 
 struct crypto_stat_kpp {
@@ -126,7 +126,7 @@ struct crypto_stat_kpp {
 	__u64 stat_setsecret_cnt;
 	__u64 stat_generate_public_key_cnt;
 	__u64 stat_compute_shared_secret_cnt;
-	__u64 stat_kpp_err_cnt;
+	__u64 stat_err_cnt;
 };
 
 struct crypto_stat_rng {
@@ -134,7 +134,7 @@ struct crypto_stat_rng {
 	__u64 stat_generate_cnt;
 	__u64 stat_generate_tlen;
 	__u64 stat_seed_cnt;
-	__u64 stat_rng_err_cnt;
+	__u64 stat_err_cnt;
 };
 
 struct crypto_stat_larval {
diff --git a/tools/crypto/getstat.c b/tools/crypto/getstat.c
index 57fbb94608d4..9e8ff76420fa 100644
--- a/tools/crypto/getstat.c
+++ b/tools/crypto/getstat.c
@@ -157,7 +157,7 @@ static int get_stat(const char *drivername)
 		printf("%s\tHash\n\tHash: %llu bytes: %llu\n\tErrors: %llu\n",
 			drivername,
 			rhash->stat_hash_cnt, rhash->stat_hash_tlen,
-			rhash->stat_hash_err_cnt);
+			rhash->stat_err_cnt);
 	} else if (tb[CRYPTOCFGA_STAT_COMPRESS]) {
 		struct rtattr *rta = tb[CRYPTOCFGA_STAT_COMPRESS];
 		struct crypto_stat_compress *rblk =
@@ -166,7 +166,7 @@ static int get_stat(const char *drivername)
 			drivername,
 			rblk->stat_compress_cnt, rblk->stat_compress_tlen,
 			rblk->stat_decompress_cnt, rblk->stat_decompress_tlen,
-			rblk->stat_compress_err_cnt);
+			rblk->stat_err_cnt);
 	} else if (tb[CRYPTOCFGA_STAT_ACOMP]) {
 		struct rtattr *rta = tb[CRYPTOCFGA_STAT_ACOMP];
 		struct crypto_stat_compress *rcomp =
@@ -175,7 +175,7 @@ static int get_stat(const char *drivername)
 			drivername,
 			rcomp->stat_compress_cnt, rcomp->stat_compress_tlen,
 			rcomp->stat_decompress_cnt, rcomp->stat_decompress_tlen,
-			rcomp->stat_compress_err_cnt);
+			rcomp->stat_err_cnt);
 	} else if (tb[CRYPTOCFGA_STAT_AEAD]) {
 		struct rtattr *rta = tb[CRYPTOCFGA_STAT_AEAD];
 		struct crypto_stat_aead *raead =
@@ -184,7 +184,7 @@ static int get_stat(const char *drivername)
 			drivername,
 			raead->stat_encrypt_cnt, raead->stat_encrypt_tlen,
 			raead->stat_decrypt_cnt, raead->stat_decrypt_tlen,
-			raead->stat_aead_err_cnt);
+			raead->stat_err_cnt);
 	} else if (tb[CRYPTOCFGA_STAT_BLKCIPHER]) {
 		struct rtattr *rta = tb[CRYPTOCFGA_STAT_BLKCIPHER];
 		struct crypto_stat_cipher *rblk =
@@ -193,7 +193,7 @@ static int get_stat(const char *drivername)
 			drivername,
 			rblk->stat_encrypt_cnt, rblk->stat_encrypt_tlen,
 			rblk->stat_decrypt_cnt, rblk->stat_decrypt_tlen,
-			rblk->stat_cipher_err_cnt);
+			rblk->stat_err_cnt);
 	} else if (tb[CRYPTOCFGA_STAT_AKCIPHER]) {
 		struct rtattr *rta = tb[CRYPTOCFGA_STAT_AKCIPHER];
 		struct crypto_stat_akcipher *rblk =
@@ -203,7 +203,7 @@ static int get_stat(const char *drivername)
 			rblk->stat_encrypt_cnt, rblk->stat_encrypt_tlen,
 			rblk->stat_decrypt_cnt, rblk->stat_decrypt_tlen,
 			rblk->stat_sign_cnt, rblk->stat_verify_cnt,
-			rblk->stat_akcipher_err_cnt);
+			rblk->stat_err_cnt);
 	} else if (tb[CRYPTOCFGA_STAT_CIPHER]) {
 		struct rtattr *rta = tb[CRYPTOCFGA_STAT_CIPHER];
 		struct crypto_stat_cipher *rblk =
@@ -212,7 +212,7 @@ static int get_stat(const char *drivername)
 			drivername,
 			rblk->stat_encrypt_cnt, rblk->stat_encrypt_tlen,
 			rblk->stat_decrypt_cnt, rblk->stat_decrypt_tlen,
-			rblk->stat_cipher_err_cnt);
+			rblk->stat_err_cnt);
 	} else if (tb[CRYPTOCFGA_STAT_RNG]) {
 		struct rtattr *rta = tb[CRYPTOCFGA_STAT_RNG];
 		struct crypto_stat_rng *rrng =
@@ -221,7 +221,7 @@ static int get_stat(const char *drivername)
 			drivername,
 			rrng->stat_seed_cnt,
 			rrng->stat_generate_cnt, rrng->stat_generate_tlen,
-			rrng->stat_rng_err_cnt);
+			rrng->stat_err_cnt);
 	} else if (tb[CRYPTOCFGA_STAT_KPP]) {
 		struct rtattr *rta = tb[CRYPTOCFGA_STAT_KPP];
 		struct crypto_stat_kpp *rkpp =
@@ -231,7 +231,7 @@ static int get_stat(const char *drivername)
 			rkpp->stat_setsecret_cnt,
 			rkpp->stat_generate_public_key_cnt,
 			rkpp->stat_compute_shared_secret_cnt,
-			rkpp->stat_kpp_err_cnt);
+			rkpp->stat_err_cnt);
 	} else {
 		fprintf(stderr, "%s is of an unknown algorithm\n", drivername);
 	}
-- 
2.18.1
