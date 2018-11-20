Return-Path: <SRS0=vxh5=N7=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41251 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729650AbeKTXC0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Nov 2018 18:02:26 -0500
Received: by mail-wr1-f65.google.com with SMTP id x10so1781605wrs.8
        for <linux-crypto@vger.kernel.org>; Tue, 20 Nov 2018 04:33:29 -0800 (PST)
From: Corentin Labbe <clabbe@baylibre.com>
To: davem@davemloft.net, ebiggers@kernel.org,
        herbert@gondor.apana.org.au, nhorman@tuxdriver.com
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v3 09/10] crypto: crypto_user_stat: Split stats in multiple structures
Date: Tue, 20 Nov 2018 12:32:25 +0000
Message-Id: <1542717146-34917-10-git-send-email-clabbe@baylibre.com>
In-Reply-To: <1542717146-34917-1-git-send-email-clabbe@baylibre.com>
References: <1542717146-34917-1-git-send-email-clabbe@baylibre.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Like for userspace, this patch splits stats into multiple structures,
one for each algorithm class.
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 crypto/algapi.c           | 108 +++++++++++------------
 crypto/crypto_user_stat.c |  82 ++++++++---------
 include/linux/crypto.h    | 180 +++++++++++++++++++++++++-------------
 3 files changed, 210 insertions(+), 160 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 6c98851f3a28..7ef812c4872f 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -259,13 +259,7 @@ static struct crypto_larval *__crypto_register_alg(struct crypto_alg *alg)
 	list_add(&larval->alg.cra_list, &crypto_alg_list);
 
 #ifdef CONFIG_CRYPTO_STATS
-	atomic64_set(&alg->encrypt_cnt, 0);
-	atomic64_set(&alg->decrypt_cnt, 0);
-	atomic64_set(&alg->encrypt_tlen, 0);
-	atomic64_set(&alg->decrypt_tlen, 0);
-	atomic64_set(&alg->verify_cnt, 0);
-	atomic64_set(&alg->cipher_err_cnt, 0);
-	atomic64_set(&alg->sign_cnt, 0);
+	memset(&alg->stats, 0, sizeof(alg->stats));
 #endif
 
 out:
@@ -1088,10 +1082,10 @@ void crypto_stats_ablkcipher_encrypt(unsigned int nbytes, int ret,
 						  struct crypto_alg *alg)
 {
 	if (ret && ret != -EINPROGRESS && ret != -EBUSY) {
-		atomic64_inc(&alg->cipher_err_cnt);
+		atomic64_inc(&alg->stats.cipher.cipher_err_cnt);
 	} else {
-		atomic64_inc(&alg->encrypt_cnt);
-		atomic64_add(nbytes, &alg->encrypt_tlen);
+		atomic64_inc(&alg->stats.cipher.encrypt_cnt);
+		atomic64_add(nbytes, &alg->stats.cipher.encrypt_tlen);
 	}
 	crypto_alg_put(alg);
 }
@@ -1100,10 +1094,10 @@ void crypto_stats_ablkcipher_decrypt(unsigned int nbytes, int ret,
 						  struct crypto_alg *alg)
 {
 	if (ret && ret != -EINPROGRESS && ret != -EBUSY) {
-		atomic64_inc(&alg->cipher_err_cnt);
+		atomic64_inc(&alg->stats.cipher.cipher_err_cnt);
 	} else {
-		atomic64_inc(&alg->decrypt_cnt);
-		atomic64_add(nbytes, &alg->decrypt_tlen);
+		atomic64_inc(&alg->stats.cipher.decrypt_cnt);
+		atomic64_add(nbytes, &alg->stats.cipher.decrypt_tlen);
 	}
 	crypto_alg_put(alg);
 }
@@ -1112,10 +1106,10 @@ void crypto_stats_aead_encrypt(unsigned int cryptlen,
 					    struct crypto_alg *alg, int ret)
 {
 	if (ret && ret != -EINPROGRESS && ret != -EBUSY) {
-		atomic64_inc(&alg->aead_err_cnt);
+		atomic64_inc(&alg->stats.aead.aead_err_cnt);
 	} else {
-		atomic64_inc(&alg->encrypt_cnt);
-		atomic64_add(cryptlen, &alg->encrypt_tlen);
+		atomic64_inc(&alg->stats.aead.encrypt_cnt);
+		atomic64_add(cryptlen, &alg->stats.aead.encrypt_tlen);
 	}
 	crypto_alg_put(alg);
 }
@@ -1124,10 +1118,10 @@ void crypto_stats_aead_decrypt(unsigned int cryptlen,
 					    struct crypto_alg *alg, int ret)
 {
 	if (ret && ret != -EINPROGRESS && ret != -EBUSY) {
-		atomic64_inc(&alg->aead_err_cnt);
+		atomic64_inc(&alg->stats.aead.aead_err_cnt);
 	} else {
-		atomic64_inc(&alg->decrypt_cnt);
-		atomic64_add(cryptlen, &alg->decrypt_tlen);
+		atomic64_inc(&alg->stats.aead.decrypt_cnt);
+		atomic64_add(cryptlen, &alg->stats.aead.decrypt_tlen);
 	}
 	crypto_alg_put(alg);
 }
@@ -1136,10 +1130,10 @@ void crypto_stats_akcipher_encrypt(unsigned int src_len, int ret,
 						struct crypto_alg *alg)
 {
 	if (ret && ret != -EINPROGRESS && ret != -EBUSY) {
-		atomic64_inc(&alg->akcipher_err_cnt);
+		atomic64_inc(&alg->stats.akcipher.akcipher_err_cnt);
 	} else {
-		atomic64_inc(&alg->encrypt_cnt);
-		atomic64_add(src_len, &alg->encrypt_tlen);
+		atomic64_inc(&alg->stats.akcipher.encrypt_cnt);
+		atomic64_add(src_len, &alg->stats.akcipher.encrypt_tlen);
 	}
 	crypto_alg_put(alg);
 }
@@ -1148,10 +1142,10 @@ void crypto_stats_akcipher_decrypt(unsigned int src_len, int ret,
 						struct crypto_alg *alg)
 {
 	if (ret && ret != -EINPROGRESS && ret != -EBUSY) {
-		atomic64_inc(&alg->akcipher_err_cnt);
+		atomic64_inc(&alg->stats.akcipher.akcipher_err_cnt);
 	} else {
-		atomic64_inc(&alg->decrypt_cnt);
-		atomic64_add(src_len, &alg->decrypt_tlen);
+		atomic64_inc(&alg->stats.akcipher.decrypt_cnt);
+		atomic64_add(src_len, &alg->stats.akcipher.decrypt_tlen);
 	}
 	crypto_alg_put(alg);
 }
@@ -1159,18 +1153,18 @@ void crypto_stats_akcipher_decrypt(unsigned int src_len, int ret,
 void crypto_stats_akcipher_sign(int ret, struct crypto_alg *alg)
 {
 	if (ret && ret != -EINPROGRESS && ret != -EBUSY)
-		atomic64_inc(&alg->akcipher_err_cnt);
+		atomic64_inc(&alg->stats.akcipher.akcipher_err_cnt);
 	else
-		atomic64_inc(&alg->sign_cnt);
+		atomic64_inc(&alg->stats.akcipher.sign_cnt);
 	crypto_alg_put(alg);
 }
 
 void crypto_stats_akcipher_verify(int ret, struct crypto_alg *alg)
 {
 	if (ret && ret != -EINPROGRESS && ret != -EBUSY)
-		atomic64_inc(&alg->akcipher_err_cnt);
+		atomic64_inc(&alg->stats.akcipher.akcipher_err_cnt);
 	else
-		atomic64_inc(&alg->verify_cnt);
+		atomic64_inc(&alg->stats.akcipher.verify_cnt);
 	crypto_alg_put(alg);
 }
 
@@ -1178,10 +1172,10 @@ void crypto_stats_compress(unsigned int slen, int ret,
 					struct crypto_alg *alg)
 {
 	if (ret && ret != -EINPROGRESS && ret != -EBUSY) {
-		atomic64_inc(&alg->compress_err_cnt);
+		atomic64_inc(&alg->stats.compress.compress_err_cnt);
 	} else {
-		atomic64_inc(&alg->compress_cnt);
-		atomic64_add(slen, &alg->compress_tlen);
+		atomic64_inc(&alg->stats.compress.compress_cnt);
+		atomic64_add(slen, &alg->stats.compress.compress_tlen);
 	}
 	crypto_alg_put(alg);
 }
@@ -1190,10 +1184,10 @@ void crypto_stats_decompress(unsigned int slen, int ret,
 					  struct crypto_alg *alg)
 {
 	if (ret && ret != -EINPROGRESS && ret != -EBUSY) {
-		atomic64_inc(&alg->compress_err_cnt);
+		atomic64_inc(&alg->stats.compress.compress_err_cnt);
 	} else {
-		atomic64_inc(&alg->decompress_cnt);
-		atomic64_add(slen, &alg->decompress_tlen);
+		atomic64_inc(&alg->stats.compress.decompress_cnt);
+		atomic64_add(slen, &alg->stats.compress.decompress_tlen);
 	}
 	crypto_alg_put(alg);
 }
@@ -1202,9 +1196,9 @@ void crypto_stats_ahash_update(unsigned int nbytes, int ret,
 					    struct crypto_alg *alg)
 {
 	if (ret && ret != -EINPROGRESS && ret != -EBUSY)
-		atomic64_inc(&alg->hash_err_cnt);
+		atomic64_inc(&alg->stats.hash.hash_err_cnt);
 	else
-		atomic64_add(nbytes, &alg->hash_tlen);
+		atomic64_add(nbytes, &alg->stats.hash.hash_tlen);
 	crypto_alg_put(alg);
 }
 
@@ -1212,10 +1206,10 @@ void crypto_stats_ahash_final(unsigned int nbytes, int ret,
 					   struct crypto_alg *alg)
 {
 	if (ret && ret != -EINPROGRESS && ret != -EBUSY) {
-		atomic64_inc(&alg->hash_err_cnt);
+		atomic64_inc(&alg->stats.hash.hash_err_cnt);
 	} else {
-		atomic64_inc(&alg->hash_cnt);
-		atomic64_add(nbytes, &alg->hash_tlen);
+		atomic64_inc(&alg->stats.hash.hash_cnt);
+		atomic64_add(nbytes, &alg->stats.hash.hash_tlen);
 	}
 	crypto_alg_put(alg);
 }
@@ -1223,46 +1217,46 @@ void crypto_stats_ahash_final(unsigned int nbytes, int ret,
 void crypto_stats_kpp_set_secret(struct crypto_alg *alg, int ret)
 {
 	if (ret)
-		atomic64_inc(&alg->kpp_err_cnt);
+		atomic64_inc(&alg->stats.kpp.kpp_err_cnt);
 	else
-		atomic64_inc(&alg->setsecret_cnt);
+		atomic64_inc(&alg->stats.kpp.setsecret_cnt);
 	crypto_alg_put(alg);
 }
 
 void crypto_stats_kpp_generate_public_key(struct crypto_alg *alg, int ret)
 {
 	if (ret)
-		atomic64_inc(&alg->kpp_err_cnt);
+		atomic64_inc(&alg->stats.kpp.kpp_err_cnt);
 	else
-		atomic64_inc(&alg->generate_public_key_cnt);
+		atomic64_inc(&alg->stats.kpp.generate_public_key_cnt);
 	crypto_alg_put(alg);
 }
 
 void crypto_stats_kpp_compute_shared_secret(struct crypto_alg *alg, int ret)
 {
 	if (ret)
-		atomic64_inc(&alg->kpp_err_cnt);
+		atomic64_inc(&alg->stats.kpp.kpp_err_cnt);
 	else
-		atomic64_inc(&alg->compute_shared_secret_cnt);
+		atomic64_inc(&alg->stats.kpp.compute_shared_secret_cnt);
 	crypto_alg_put(alg);
 }
 
 void crypto_stats_rng_seed(struct crypto_alg *alg, int ret)
 {
 	if (ret && ret != -EINPROGRESS && ret != -EBUSY)
-		atomic64_inc(&alg->rng_err_cnt);
+		atomic64_inc(&alg->stats.rng.rng_err_cnt);
 	else
-		atomic64_inc(&alg->seed_cnt);
+		atomic64_inc(&alg->stats.rng.seed_cnt);
 	crypto_alg_put(alg);
 }
 
 void crypto_stats_rng_generate(struct crypto_alg *alg, unsigned int dlen, int ret)
 {
 	if (ret && ret != -EINPROGRESS && ret != -EBUSY) {
-		atomic64_inc(&alg->rng_err_cnt);
+		atomic64_inc(&alg->stats.rng.rng_err_cnt);
 	} else {
-		atomic64_inc(&alg->generate_cnt);
-		atomic64_add(dlen, &alg->generate_tlen);
+		atomic64_inc(&alg->stats.rng.generate_cnt);
+		atomic64_add(dlen, &alg->stats.rng.generate_tlen);
 	}
 	crypto_alg_put(alg);
 }
@@ -1271,10 +1265,10 @@ void crypto_stats_skcipher_encrypt(unsigned int cryptlen,
 						int ret, struct crypto_alg *alg)
 {
 	if (ret && ret != -EINPROGRESS && ret != -EBUSY) {
-		atomic64_inc(&alg->cipher_err_cnt);
+		atomic64_inc(&alg->stats.cipher.cipher_err_cnt);
 	} else {
-		atomic64_inc(&alg->encrypt_cnt);
-		atomic64_add(cryptlen, &alg->encrypt_tlen);
+		atomic64_inc(&alg->stats.cipher.encrypt_cnt);
+		atomic64_add(cryptlen, &alg->stats.cipher.encrypt_tlen);
 	}
 	crypto_alg_put(alg);
 }
@@ -1283,10 +1277,10 @@ void crypto_stats_skcipher_decrypt(unsigned int cryptlen,
 						int ret, struct crypto_alg *alg)
 {
 	if (ret && ret != -EINPROGRESS && ret != -EBUSY) {
-		atomic64_inc(&alg->cipher_err_cnt);
+		atomic64_inc(&alg->stats.cipher.cipher_err_cnt);
 	} else {
-		atomic64_inc(&alg->decrypt_cnt);
-		atomic64_add(cryptlen, &alg->decrypt_tlen);
+		atomic64_inc(&alg->stats.cipher.decrypt_cnt);
+		atomic64_add(cryptlen, &alg->stats.cipher.decrypt_tlen);
 	}
 	crypto_alg_put(alg);
 }
diff --git a/crypto/crypto_user_stat.c b/crypto/crypto_user_stat.c
index 7b668c659122..113bf1691560 100644
--- a/crypto/crypto_user_stat.c
+++ b/crypto/crypto_user_stat.c
@@ -39,11 +39,11 @@ static int crypto_report_aead(struct sk_buff *skb, struct crypto_alg *alg)
 
 	strscpy(raead.type, "aead", sizeof(raead.type));
 
-	raead.stat_encrypt_cnt = atomic64_read(&alg->encrypt_cnt);
-	raead.stat_encrypt_tlen = atomic64_read(&alg->encrypt_tlen);
-	raead.stat_decrypt_cnt = atomic64_read(&alg->decrypt_cnt);
-	raead.stat_decrypt_tlen = atomic64_read(&alg->decrypt_tlen);
-	raead.stat_aead_err_cnt = atomic64_read(&alg->aead_err_cnt);
+	raead.stat_encrypt_cnt = atomic64_read(&alg->stats.aead.encrypt_cnt);
+	raead.stat_encrypt_tlen = atomic64_read(&alg->stats.aead.encrypt_tlen);
+	raead.stat_decrypt_cnt = atomic64_read(&alg->stats.aead.decrypt_cnt);
+	raead.stat_decrypt_tlen = atomic64_read(&alg->stats.aead.decrypt_tlen);
+	raead.stat_aead_err_cnt = atomic64_read(&alg->stats.aead.aead_err_cnt);
 
 	return nla_put(skb, CRYPTOCFGA_STAT_AEAD, sizeof(raead), &raead);
 }
@@ -56,11 +56,11 @@ static int crypto_report_cipher(struct sk_buff *skb, struct crypto_alg *alg)
 
 	strscpy(rcipher.type, "cipher", sizeof(rcipher.type));
 
-	rcipher.stat_encrypt_cnt = atomic64_read(&alg->encrypt_cnt);
-	rcipher.stat_encrypt_tlen = atomic64_read(&alg->encrypt_tlen);
-	rcipher.stat_decrypt_cnt =  atomic64_read(&alg->decrypt_cnt);
-	rcipher.stat_decrypt_tlen = atomic64_read(&alg->decrypt_tlen);
-	rcipher.stat_cipher_err_cnt =  atomic64_read(&alg->cipher_err_cnt);
+	rcipher.stat_encrypt_cnt = atomic64_read(&alg->stats.cipher.encrypt_cnt);
+	rcipher.stat_encrypt_tlen = atomic64_read(&alg->stats.cipher.encrypt_tlen);
+	rcipher.stat_decrypt_cnt =  atomic64_read(&alg->stats.cipher.decrypt_cnt);
+	rcipher.stat_decrypt_tlen = atomic64_read(&alg->stats.cipher.decrypt_tlen);
+	rcipher.stat_cipher_err_cnt =  atomic64_read(&alg->stats.cipher.cipher_err_cnt);
 
 	return nla_put(skb, CRYPTOCFGA_STAT_CIPHER, sizeof(rcipher), &rcipher);
 }
@@ -72,11 +72,11 @@ static int crypto_report_comp(struct sk_buff *skb, struct crypto_alg *alg)
 	memset(&rcomp, 0, sizeof(rcomp));
 
 	strscpy(rcomp.type, "compression", sizeof(rcomp.type));
-	rcomp.stat_compress_cnt = atomic64_read(&alg->compress_cnt);
-	rcomp.stat_compress_tlen = atomic64_read(&alg->compress_tlen);
-	rcomp.stat_decompress_cnt = atomic64_read(&alg->decompress_cnt);
-	rcomp.stat_decompress_tlen = atomic64_read(&alg->decompress_tlen);
-	rcomp.stat_compress_err_cnt = atomic64_read(&alg->compress_err_cnt);
+	rcomp.stat_compress_cnt = atomic64_read(&alg->stats.compress.compress_cnt);
+	rcomp.stat_compress_tlen = atomic64_read(&alg->stats.compress.compress_tlen);
+	rcomp.stat_decompress_cnt = atomic64_read(&alg->stats.compress.decompress_cnt);
+	rcomp.stat_decompress_tlen = atomic64_read(&alg->stats.compress.decompress_tlen);
+	rcomp.stat_compress_err_cnt = atomic64_read(&alg->stats.compress.compress_err_cnt);
 
 	return nla_put(skb, CRYPTOCFGA_STAT_COMPRESS, sizeof(rcomp), &rcomp);
 }
@@ -88,11 +88,11 @@ static int crypto_report_acomp(struct sk_buff *skb, struct crypto_alg *alg)
 	memset(&racomp, 0, sizeof(racomp));
 
 	strscpy(racomp.type, "acomp", sizeof(racomp.type));
-	racomp.stat_compress_cnt = atomic64_read(&alg->compress_cnt);
-	racomp.stat_compress_tlen = atomic64_read(&alg->compress_tlen);
-	racomp.stat_decompress_cnt =  atomic64_read(&alg->decompress_cnt);
-	racomp.stat_decompress_tlen = atomic64_read(&alg->decompress_tlen);
-	racomp.stat_compress_err_cnt = atomic64_read(&alg->compress_err_cnt);
+	racomp.stat_compress_cnt = atomic64_read(&alg->stats.compress.compress_cnt);
+	racomp.stat_compress_tlen = atomic64_read(&alg->stats.compress.compress_tlen);
+	racomp.stat_decompress_cnt =  atomic64_read(&alg->stats.compress.decompress_cnt);
+	racomp.stat_decompress_tlen = atomic64_read(&alg->stats.compress.decompress_tlen);
+	racomp.stat_compress_err_cnt = atomic64_read(&alg->stats.compress.compress_err_cnt);
 
 	return nla_put(skb, CRYPTOCFGA_STAT_ACOMP, sizeof(racomp), &racomp);
 }
@@ -104,13 +104,13 @@ static int crypto_report_akcipher(struct sk_buff *skb, struct crypto_alg *alg)
 	memset(&rakcipher, 0, sizeof(rakcipher));
 
 	strscpy(rakcipher.type, "akcipher", sizeof(rakcipher.type));
-	rakcipher.stat_encrypt_cnt = atomic64_read(&alg->encrypt_cnt);
-	rakcipher.stat_encrypt_tlen = atomic64_read(&alg->encrypt_tlen);
-	rakcipher.stat_decrypt_cnt = atomic64_read(&alg->decrypt_cnt);
-	rakcipher.stat_decrypt_tlen = atomic64_read(&alg->decrypt_tlen);
-	rakcipher.stat_sign_cnt = atomic64_read(&alg->sign_cnt);
-	rakcipher.stat_verify_cnt = atomic64_read(&alg->verify_cnt);
-	rakcipher.stat_akcipher_err_cnt = atomic64_read(&alg->akcipher_err_cnt);
+	rakcipher.stat_encrypt_cnt = atomic64_read(&alg->stats.akcipher.encrypt_cnt);
+	rakcipher.stat_encrypt_tlen = atomic64_read(&alg->stats.akcipher.encrypt_tlen);
+	rakcipher.stat_decrypt_cnt = atomic64_read(&alg->stats.akcipher.decrypt_cnt);
+	rakcipher.stat_decrypt_tlen = atomic64_read(&alg->stats.akcipher.decrypt_tlen);
+	rakcipher.stat_sign_cnt = atomic64_read(&alg->stats.akcipher.sign_cnt);
+	rakcipher.stat_verify_cnt = atomic64_read(&alg->stats.akcipher.verify_cnt);
+	rakcipher.stat_akcipher_err_cnt = atomic64_read(&alg->stats.akcipher.akcipher_err_cnt);
 
 	return nla_put(skb, CRYPTOCFGA_STAT_AKCIPHER,
 		       sizeof(rakcipher), &rakcipher);
@@ -124,10 +124,10 @@ static int crypto_report_kpp(struct sk_buff *skb, struct crypto_alg *alg)
 
 	strscpy(rkpp.type, "kpp", sizeof(rkpp.type));
 
-	rkpp.stat_setsecret_cnt = atomic64_read(&alg->setsecret_cnt);
-	rkpp.stat_generate_public_key_cnt = atomic64_read(&alg->generate_public_key_cnt);
-	rkpp.stat_compute_shared_secret_cnt = atomic64_read(&alg->compute_shared_secret_cnt);
-	rkpp.stat_kpp_err_cnt = atomic64_read(&alg->kpp_err_cnt);
+	rkpp.stat_setsecret_cnt = atomic64_read(&alg->stats.kpp.setsecret_cnt);
+	rkpp.stat_generate_public_key_cnt = atomic64_read(&alg->stats.kpp.generate_public_key_cnt);
+	rkpp.stat_compute_shared_secret_cnt = atomic64_read(&alg->stats.kpp.compute_shared_secret_cnt);
+	rkpp.stat_kpp_err_cnt = atomic64_read(&alg->stats.kpp.kpp_err_cnt);
 
 	return nla_put(skb, CRYPTOCFGA_STAT_KPP, sizeof(rkpp), &rkpp);
 }
@@ -140,9 +140,9 @@ static int crypto_report_ahash(struct sk_buff *skb, struct crypto_alg *alg)
 
 	strscpy(rhash.type, "ahash", sizeof(rhash.type));
 
-	rhash.stat_hash_cnt = atomic64_read(&alg->hash_cnt);
-	rhash.stat_hash_tlen = atomic64_read(&alg->hash_tlen);
-	rhash.stat_hash_err_cnt = atomic64_read(&alg->hash_err_cnt);
+	rhash.stat_hash_cnt = atomic64_read(&alg->stats.hash.hash_cnt);
+	rhash.stat_hash_tlen = atomic64_read(&alg->stats.hash.hash_tlen);
+	rhash.stat_hash_err_cnt = atomic64_read(&alg->stats.hash.hash_err_cnt);
 
 	return nla_put(skb, CRYPTOCFGA_STAT_HASH, sizeof(rhash), &rhash);
 }
@@ -155,9 +155,9 @@ static int crypto_report_shash(struct sk_buff *skb, struct crypto_alg *alg)
 
 	strscpy(rhash.type, "shash", sizeof(rhash.type));
 
-	rhash.stat_hash_cnt =  atomic64_read(&alg->hash_cnt);
-	rhash.stat_hash_tlen = atomic64_read(&alg->hash_tlen);
-	rhash.stat_hash_err_cnt = atomic64_read(&alg->hash_err_cnt);
+	rhash.stat_hash_cnt =  atomic64_read(&alg->stats.hash.hash_cnt);
+	rhash.stat_hash_tlen = atomic64_read(&alg->stats.hash.hash_tlen);
+	rhash.stat_hash_err_cnt = atomic64_read(&alg->stats.hash.hash_err_cnt);
 
 	return nla_put(skb, CRYPTOCFGA_STAT_HASH, sizeof(rhash), &rhash);
 }
@@ -170,10 +170,10 @@ static int crypto_report_rng(struct sk_buff *skb, struct crypto_alg *alg)
 
 	strscpy(rrng.type, "rng", sizeof(rrng.type));
 
-	rrng.stat_generate_cnt = atomic64_read(&alg->generate_cnt);
-	rrng.stat_generate_tlen = atomic64_read(&alg->generate_tlen);
-	rrng.stat_seed_cnt = atomic64_read(&alg->seed_cnt);
-	rrng.stat_rng_err_cnt = atomic64_read(&alg->rng_err_cnt);
+	rrng.stat_generate_cnt = atomic64_read(&alg->stats.rng.generate_cnt);
+	rrng.stat_generate_tlen = atomic64_read(&alg->stats.rng.generate_tlen);
+	rrng.stat_seed_cnt = atomic64_read(&alg->stats.rng.seed_cnt);
+	rrng.stat_rng_err_cnt = atomic64_read(&alg->stats.rng.rng_err_cnt);
 
 	return nla_put(skb, CRYPTOCFGA_STAT_RNG, sizeof(rrng), &rrng);
 }
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 7af63cb9c815..e5616b311104 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -369,6 +369,115 @@ struct compress_alg {
 			      unsigned int slen, u8 *dst, unsigned int *dlen);
 };
 
+#ifdef CONFIG_CRYPTO_STATS
+/*
+ * struct crypto_istat_aead - statistics for AEAD algorithm
+ * @encrypt_cnt:	number of encrypt requests
+ * @encrypt_tlen:	total data size handled by encrypt requests
+ * @decrypt_cnt:	number of decrypt requests
+ * @decrypt_tlen:	total data size handled by decrypt requests
+ * @aead_err_cnt:	number of error for AEAD requests
+ */
+struct crypto_istat_aead {
+	atomic64_t encrypt_cnt;
+	atomic64_t encrypt_tlen;
+	atomic64_t decrypt_cnt;
+	atomic64_t decrypt_tlen;
+	atomic64_t aead_err_cnt;
+};
+
+/*
+ * struct crypto_istat_akcipher - statistics for akcipher algorithm
+ * @encrypt_cnt:	number of encrypt requests
+ * @encrypt_tlen:	total data size handled by encrypt requests
+ * @decrypt_cnt:	number of decrypt requests
+ * @decrypt_tlen:	total data size handled by decrypt requests
+ * @verify_cnt:		number of verify operation
+ * @sign_cnt:		number of sign requests
+ * @akcipher_err_cnt:	number of error for akcipher requests
+ */
+struct crypto_istat_akcipher {
+	atomic64_t encrypt_cnt;
+	atomic64_t encrypt_tlen;
+	atomic64_t decrypt_cnt;
+	atomic64_t decrypt_tlen;
+	atomic64_t verify_cnt;
+	atomic64_t sign_cnt;
+	atomic64_t akcipher_err_cnt;
+};
+
+/*
+ * struct crypto_istat_cipher - statistics for cipher algorithm
+ * @encrypt_cnt:	number of encrypt requests
+ * @encrypt_tlen:	total data size handled by encrypt requests
+ * @decrypt_cnt:	number of decrypt requests
+ * @decrypt_tlen:	total data size handled by decrypt requests
+ * @cipher_err_cnt:	number of error for cipher requests
+ */
+struct crypto_istat_cipher {
+	atomic64_t encrypt_cnt;
+	atomic64_t encrypt_tlen;
+	atomic64_t decrypt_cnt;
+	atomic64_t decrypt_tlen;
+	atomic64_t cipher_err_cnt;
+};
+
+/*
+ * struct crypto_istat_compress - statistics for compress algorithm
+ * @compress_cnt:	number of compress requests
+ * @compress_tlen:	total data size handled by compress requests
+ * @decompress_cnt:	number of decompress requests
+ * @decompress_tlen:	total data size handled by decompress requests
+ * @compress_err_cnt:	number of error for compress requests
+ */
+struct crypto_istat_compress {
+	atomic64_t compress_cnt;
+	atomic64_t compress_tlen;
+	atomic64_t decompress_cnt;
+	atomic64_t decompress_tlen;
+	atomic64_t compress_err_cnt;
+};
+
+/*
+ * struct crypto_istat_hash - statistics for has algorithm
+ * @hash_cnt:		number of hash requests
+ * @hash_tlen:		total data size hashed
+ * @hash_err_cnt:	number of error for hash requests
+ */
+struct crypto_istat_hash {
+	atomic64_t hash_cnt;
+	atomic64_t hash_tlen;
+	atomic64_t hash_err_cnt;
+};
+
+/*
+ * struct crypto_istat_kpp - statistics for KPP algorithm
+ * @setsecret_cnt:		number of setsecrey operation
+ * @generate_public_key_cnt:	number of generate_public_key operation
+ * @compute_shared_secret_cnt:	number of compute_shared_secret operation
+ * @kpp_err_cnt:		number of error for KPP requests
+ */
+struct crypto_istat_kpp {
+	atomic64_t setsecret_cnt;
+	atomic64_t generate_public_key_cnt;
+	atomic64_t compute_shared_secret_cnt;
+	atomic64_t kpp_err_cnt;
+};
+
+/*
+ * struct crypto_istat_rng: statistics for RNG algorithm
+ * @generate_cnt:	number of RNG generate requests
+ * @generate_tlen:	total data size of generated data by the RNG
+ * @seed_cnt:		number of times the RNG was seeded
+ * @rng_err_cnt:	number of error for RNG requests
+ */
+struct crypto_istat_rng {
+	atomic64_t generate_cnt;
+	atomic64_t generate_tlen;
+	atomic64_t seed_cnt;
+	atomic64_t rng_err_cnt;
+};
+#endif /* CONFIG_CRYPTO_STATS */
 
 #define cra_ablkcipher	cra_u.ablkcipher
 #define cra_blkcipher	cra_u.blkcipher
@@ -454,32 +563,7 @@ struct compress_alg {
  * @cra_refcnt: internally used
  * @cra_destroy: internally used
  *
- * All following statistics are for this crypto_alg
- * @encrypt_cnt:	number of encrypt requests
- * @decrypt_cnt:	number of decrypt requests
- * @compress_cnt:	number of compress requests
- * @decompress_cnt:	number of decompress requests
- * @generate_cnt:	number of RNG generate requests
- * @seed_cnt:		number of times the rng was seeded
- * @hash_cnt:		number of hash requests
- * @sign_cnt:		number of sign requests
- * @setsecret_cnt:	number of setsecrey operation
- * @generate_public_key_cnt:	number of generate_public_key operation
- * @verify_cnt:			number of verify operation
- * @compute_shared_secret_cnt:	number of compute_shared_secret operation
- * @encrypt_tlen:	total data size handled by encrypt requests
- * @decrypt_tlen:	total data size handled by decrypt requests
- * @compress_tlen:	total data size handled by compress requests
- * @decompress_tlen:	total data size handled by decompress requests
- * @generate_tlen:	total data size of generated data by the RNG
- * @hash_tlen:		total data size hashed
- * @akcipher_err_cnt:	number of error for akcipher requests
- * @cipher_err_cnt:	number of error for akcipher requests
- * @compress_err_cnt:	number of error for akcipher requests
- * @aead_err_cnt:	number of error for akcipher requests
- * @hash_err_cnt:	number of error for akcipher requests
- * @rng_err_cnt:	number of error for akcipher requests
- * @kpp_err_cnt:	number of error for akcipher requests
+ * @stats: union of all possible crypto_istat_xxx structures
  *
  * The struct crypto_alg describes a generic Crypto API algorithm and is common
  * for all of the transformations. Any variable not documented here shall not
@@ -517,42 +601,14 @@ struct crypto_alg {
 
 #ifdef CONFIG_CRYPTO_STATS
 	union {
-		atomic64_t encrypt_cnt;
-		atomic64_t compress_cnt;
-		atomic64_t generate_cnt;
-		atomic64_t hash_cnt;
-		atomic64_t setsecret_cnt;
-	};
-	union {
-		atomic64_t encrypt_tlen;
-		atomic64_t compress_tlen;
-		atomic64_t generate_tlen;
-		atomic64_t hash_tlen;
-	};
-	union {
-		atomic64_t akcipher_err_cnt;
-		atomic64_t cipher_err_cnt;
-		atomic64_t compress_err_cnt;
-		atomic64_t aead_err_cnt;
-		atomic64_t hash_err_cnt;
-		atomic64_t rng_err_cnt;
-		atomic64_t kpp_err_cnt;
-	};
-	union {
-		atomic64_t decrypt_cnt;
-		atomic64_t decompress_cnt;
-		atomic64_t seed_cnt;
-		atomic64_t generate_public_key_cnt;
-	};
-	union {
-		atomic64_t decrypt_tlen;
-		atomic64_t decompress_tlen;
-	};
-	union {
-		atomic64_t verify_cnt;
-		atomic64_t compute_shared_secret_cnt;
-	};
-	atomic64_t sign_cnt;
+		struct crypto_istat_aead aead;
+		struct crypto_istat_akcipher akcipher;
+		struct crypto_istat_cipher cipher;
+		struct crypto_istat_compress compress;
+		struct crypto_istat_hash hash;
+		struct crypto_istat_rng rng;
+		struct crypto_istat_kpp kpp;
+	} stats;
 #endif /* CONFIG_CRYPTO_STATS */
 
 } CRYPTO_MINALIGN_ATTR;
-- 
2.18.1
