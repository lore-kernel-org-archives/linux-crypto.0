From: Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 1/2] crypto: Implement a generic crypto statistics
Date: Thu, 11 Jan 2018 19:56:56 +0000
Message-ID: <1515700617-3513-2-git-send-email-clabbe@baylibre.com>
References: <1515700617-3513-1-git-send-email-clabbe@baylibre.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
To: davem@davemloft.net, herbert@gondor.apana.org.au,
        nhorman@tuxdriver.com, smueller@chronox.de
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:43043 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934577AbeAKUBB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Jan 2018 15:01:01 -0500
Received: by mail-wm0-f68.google.com with SMTP id g1so7813848wmg.2
        for <linux-crypto@vger.kernel.org>; Thu, 11 Jan 2018 12:01:00 -0800 (PST)
In-Reply-To: <1515700617-3513-1-git-send-email-clabbe@baylibre.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch implement a generic way to get statistics about all crypto
usages.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 crypto/Kconfig                  | 11 ++++++++
 crypto/ablkcipher.c             |  9 +++++++
 crypto/acompress.c              |  9 +++++++
 crypto/aead.c                   | 10 ++++++++
 crypto/ahash.c                  |  8 ++++++
 crypto/akcipher.c               | 13 ++++++++++
 crypto/algapi.c                 |  6 +++++
 crypto/blkcipher.c              |  9 +++++++
 crypto/crypto_user.c            | 28 +++++++++++++++++++++
 crypto/kpp.c                    |  7 ++++++
 crypto/rng.c                    |  8 ++++++
 crypto/scompress.c              |  9 +++++++
 crypto/shash.c                  |  5 ++++
 crypto/skcipher.c               |  9 +++++++
 include/crypto/acompress.h      | 22 ++++++++++++++++
 include/crypto/aead.h           | 22 ++++++++++++++++
 include/crypto/akcipher.h       | 42 +++++++++++++++++++++++++++++++
 include/crypto/hash.h           | 21 ++++++++++++++++
 include/crypto/kpp.h            | 28 +++++++++++++++++++++
 include/crypto/rng.h            | 17 +++++++++++++
 include/crypto/skcipher.h       | 22 ++++++++++++++++
 include/linux/crypto.h          | 56 +++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/cryptouser.h | 34 +++++++++++++++++++++++++
 23 files changed, 405 insertions(+)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 971d558494c3..3b88fba14b59 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1780,6 +1780,17 @@ config CRYPTO_USER_API_AEAD
 	  This option enables the user-spaces interface for AEAD
 	  cipher algorithms.
 
+config CRYPTO_STATS
+	bool "Crypto usage statistics for User-space"
+	help
+	  This option enables the gathering of crypto stats.
+	  This will collect:
+	  - encrypt/decrypt size and numbers of symmeric operations
+	  - compress/decompress size and numbers of compress operations
+	  - size and numbers of hash operations
+	  - encrypt/decrypt/sign/verify numbers for asymmetric operations
+	  - generate/seed numbers for rng operations
+
 config CRYPTO_HASH_INFO
 	bool
 
diff --git a/crypto/ablkcipher.c b/crypto/ablkcipher.c
index d880a4897159..f6d20e4ca977 100644
--- a/crypto/ablkcipher.c
+++ b/crypto/ablkcipher.c
@@ -369,6 +369,7 @@ static int crypto_init_ablkcipher_ops(struct crypto_tfm *tfm, u32 type,
 static int crypto_ablkcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
 {
 	struct crypto_report_blkcipher rblkcipher;
+	u64 v;
 
 	strncpy(rblkcipher.type, "ablkcipher", sizeof(rblkcipher.type));
 	strncpy(rblkcipher.geniv, alg->cra_ablkcipher.geniv ?: "<default>",
@@ -378,6 +379,14 @@ static int crypto_ablkcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
 	rblkcipher.min_keysize = alg->cra_ablkcipher.min_keysize;
 	rblkcipher.max_keysize = alg->cra_ablkcipher.max_keysize;
 	rblkcipher.ivsize = alg->cra_ablkcipher.ivsize;
+	v = atomic_read(&alg->encrypt_cnt);
+	rblkcipher.stat_encrypt_cnt = v;
+	v = atomic_read(&alg->encrypt_tlen);
+	rblkcipher.stat_encrypt_tlen = v;
+	v = atomic_read(&alg->decrypt_cnt);
+	rblkcipher.stat_decrypt_cnt = v;
+	v = atomic_read(&alg->decrypt_tlen);
+	rblkcipher.stat_decrypt_tlen = v;
 
 	if (nla_put(skb, CRYPTOCFGA_REPORT_BLKCIPHER,
 		    sizeof(struct crypto_report_blkcipher), &rblkcipher))
diff --git a/crypto/acompress.c b/crypto/acompress.c
index 1544b7c057fb..524c8a3e3f80 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -32,8 +32,17 @@ static const struct crypto_type crypto_acomp_type;
 static int crypto_acomp_report(struct sk_buff *skb, struct crypto_alg *alg)
 {
 	struct crypto_report_acomp racomp;
+	u64 v;
 
 	strncpy(racomp.type, "acomp", sizeof(racomp.type));
+	v = atomic_read(&alg->compress_cnt);
+	racomp.stat_compress_cnt = v;
+	v = atomic_read(&alg->compress_tlen);
+	racomp.stat_compress_tlen = v;
+	v = atomic_read(&alg->decompress_cnt);
+	racomp.stat_decompress_cnt = v;
+	v = atomic_read(&alg->decompress_tlen);
+	racomp.stat_decompress_tlen = v;
 
 	if (nla_put(skb, CRYPTOCFGA_REPORT_ACOMP,
 		    sizeof(struct crypto_report_acomp), &racomp))
diff --git a/crypto/aead.c b/crypto/aead.c
index fe00cbd7243d..de13bd345d8b 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -109,6 +109,7 @@ static int crypto_aead_report(struct sk_buff *skb, struct crypto_alg *alg)
 {
 	struct crypto_report_aead raead;
 	struct aead_alg *aead = container_of(alg, struct aead_alg, base);
+	u64 v;
 
 	strncpy(raead.type, "aead", sizeof(raead.type));
 	strncpy(raead.geniv, "<none>", sizeof(raead.geniv));
@@ -116,6 +117,15 @@ static int crypto_aead_report(struct sk_buff *skb, struct crypto_alg *alg)
 	raead.blocksize = alg->cra_blocksize;
 	raead.maxauthsize = aead->maxauthsize;
 	raead.ivsize = aead->ivsize;
+	v = atomic_read(&alg->encrypt_cnt);
+	raead.stat_encrypt_cnt = v;
+	v = atomic_read(&alg->encrypt_tlen);
+	raead.stat_encrypt_tlen = v;
+	v = atomic_read(&alg->decrypt_cnt);
+	raead.stat_decrypt_cnt = v;
+	v = atomic_read(&alg->decrypt_tlen);
+	raead.stat_decrypt_tlen = v;
+
 
 	if (nla_put(skb, CRYPTOCFGA_REPORT_AEAD,
 		    sizeof(struct crypto_report_aead), &raead))
diff --git a/crypto/ahash.c b/crypto/ahash.c
index 3a35d67de7d9..e718f387039c 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -356,18 +356,21 @@ static int crypto_ahash_op(struct ahash_request *req,
 
 int crypto_ahash_final(struct ahash_request *req)
 {
+	crypto_stat_ahash_final(req);
 	return crypto_ahash_op(req, crypto_ahash_reqtfm(req)->final);
 }
 EXPORT_SYMBOL_GPL(crypto_ahash_final);
 
 int crypto_ahash_finup(struct ahash_request *req)
 {
+	crypto_stat_ahash_final(req);
 	return crypto_ahash_op(req, crypto_ahash_reqtfm(req)->finup);
 }
 EXPORT_SYMBOL_GPL(crypto_ahash_finup);
 
 int crypto_ahash_digest(struct ahash_request *req)
 {
+	crypto_stat_ahash_final(req);
 	return crypto_ahash_op(req, crypto_ahash_reqtfm(req)->digest);
 }
 EXPORT_SYMBOL_GPL(crypto_ahash_digest);
@@ -487,11 +490,16 @@ static unsigned int crypto_ahash_extsize(struct crypto_alg *alg)
 static int crypto_ahash_report(struct sk_buff *skb, struct crypto_alg *alg)
 {
 	struct crypto_report_hash rhash;
+	u64 v;
 
 	strncpy(rhash.type, "ahash", sizeof(rhash.type));
 
 	rhash.blocksize = alg->cra_blocksize;
 	rhash.digestsize = __crypto_hash_alg_common(alg)->digestsize;
+	v = atomic_read(&alg->hash_cnt);
+	rhash.stat_hash = v;
+	v = atomic_read(&alg->hash_tlen);
+	rhash.stat_hash_tlen = v;
 
 	if (nla_put(skb, CRYPTOCFGA_REPORT_HASH,
 		    sizeof(struct crypto_report_hash), &rhash))
diff --git a/crypto/akcipher.c b/crypto/akcipher.c
index cfbdb06d8ca8..02cb06824637 100644
--- a/crypto/akcipher.c
+++ b/crypto/akcipher.c
@@ -29,8 +29,21 @@
 static int crypto_akcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
 {
 	struct crypto_report_akcipher rakcipher;
+	u64 v;
 
 	strncpy(rakcipher.type, "akcipher", sizeof(rakcipher.type));
+	v = atomic_read(&alg->encrypt_cnt);
+	rakcipher.stat_encrypt_cnt = v;
+	v = atomic_read(&alg->encrypt_tlen);
+	rakcipher.stat_encrypt_tlen = v;
+	v = atomic_read(&alg->decrypt_cnt);
+	rakcipher.stat_decrypt_cnt = v;
+	v = atomic_read(&alg->decrypt_tlen);
+	rakcipher.stat_decrypt_tlen = v;
+	v = atomic_read(&alg->sign_cnt);
+	rakcipher.stat_sign_cnt = v;
+	v = atomic_read(&alg->verify_cnt);
+	rakcipher.stat_verify_cnt = v;
 
 	if (nla_put(skb, CRYPTOCFGA_REPORT_AKCIPHER,
 		    sizeof(struct crypto_report_akcipher), &rakcipher))
diff --git a/crypto/algapi.c b/crypto/algapi.c
index 395b082d03a9..cf563f9f4be9 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -243,6 +243,12 @@ static struct crypto_larval *__crypto_register_alg(struct crypto_alg *alg)
 	list_add(&alg->cra_list, &crypto_alg_list);
 	list_add(&larval->alg.cra_list, &crypto_alg_list);
 
+	atomic_set(&alg->encrypt_cnt, 0);
+	atomic_set(&alg->decrypt_cnt, 0);
+	atomic_set(&alg->encrypt_tlen, 0);
+	atomic_set(&alg->decrypt_tlen, 0);
+	atomic_set(&alg->verify_cnt, 0);
+
 out:
 	return larval;
 
diff --git a/crypto/blkcipher.c b/crypto/blkcipher.c
index 01c0d4aa2563..bae369c1a1d1 100644
--- a/crypto/blkcipher.c
+++ b/crypto/blkcipher.c
@@ -508,6 +508,7 @@ static int crypto_init_blkcipher_ops(struct crypto_tfm *tfm, u32 type, u32 mask)
 static int crypto_blkcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
 {
 	struct crypto_report_blkcipher rblkcipher;
+	u64 v;
 
 	strncpy(rblkcipher.type, "blkcipher", sizeof(rblkcipher.type));
 	strncpy(rblkcipher.geniv, alg->cra_blkcipher.geniv ?: "<default>",
@@ -517,6 +518,14 @@ static int crypto_blkcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
 	rblkcipher.min_keysize = alg->cra_blkcipher.min_keysize;
 	rblkcipher.max_keysize = alg->cra_blkcipher.max_keysize;
 	rblkcipher.ivsize = alg->cra_blkcipher.ivsize;
+	v = atomic_read(&alg->encrypt_cnt);
+	rblkcipher.stat_encrypt_cnt = v;
+	v = atomic_read(&alg->encrypt_tlen);
+	rblkcipher.stat_encrypt_tlen = v;
+	v = atomic_read(&alg->decrypt_cnt);
+	rblkcipher.stat_decrypt_cnt = v;
+	v = atomic_read(&alg->decrypt_tlen);
+	rblkcipher.stat_decrypt_tlen = v;
 
 	if (nla_put(skb, CRYPTOCFGA_REPORT_BLKCIPHER,
 		    sizeof(struct crypto_report_blkcipher), &rblkcipher))
diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
index 5c291eedaa70..bd62f71a1ed1 100644
--- a/crypto/crypto_user.c
+++ b/crypto/crypto_user.c
@@ -82,12 +82,21 @@ static struct crypto_alg *crypto_alg_match(struct crypto_user_alg *p, int exact)
 static int crypto_report_cipher(struct sk_buff *skb, struct crypto_alg *alg)
 {
 	struct crypto_report_cipher rcipher;
+	u64 v;
 
 	strlcpy(rcipher.type, "cipher", sizeof(rcipher.type));
 
 	rcipher.blocksize = alg->cra_blocksize;
 	rcipher.min_keysize = alg->cra_cipher.cia_min_keysize;
 	rcipher.max_keysize = alg->cra_cipher.cia_max_keysize;
+	v = atomic_read(&alg->encrypt_cnt);
+	rcipher.stat_encrypt_cnt = v;
+	v = atomic_read(&alg->encrypt_tlen);
+	rcipher.stat_encrypt_tlen = v;
+	v = atomic_read(&alg->decrypt_cnt);
+	rcipher.stat_decrypt_cnt = v;
+	v = atomic_read(&alg->decrypt_tlen);
+	rcipher.stat_decrypt_tlen = v;
 
 	if (nla_put(skb, CRYPTOCFGA_REPORT_CIPHER,
 		    sizeof(struct crypto_report_cipher), &rcipher))
@@ -101,8 +110,18 @@ static int crypto_report_cipher(struct sk_buff *skb, struct crypto_alg *alg)
 static int crypto_report_comp(struct sk_buff *skb, struct crypto_alg *alg)
 {
 	struct crypto_report_comp rcomp;
+	u64 v;
 
 	strlcpy(rcomp.type, "compression", sizeof(rcomp.type));
+	v = atomic_read(&alg->compress_cnt);
+	rcomp.stat_compress_cnt = v;
+	v = atomic_read(&alg->compress_tlen);
+	rcomp.stat_compress_tlen = v;
+	v = atomic_read(&alg->decompress_cnt);
+	rcomp.stat_decompress_cnt = v;
+	v = atomic_read(&alg->decompress_tlen);
+	rcomp.stat_decompress_tlen = v;
+
 	if (nla_put(skb, CRYPTOCFGA_REPORT_COMPRESS,
 		    sizeof(struct crypto_report_comp), &rcomp))
 		goto nla_put_failure;
@@ -115,8 +134,17 @@ static int crypto_report_comp(struct sk_buff *skb, struct crypto_alg *alg)
 static int crypto_report_acomp(struct sk_buff *skb, struct crypto_alg *alg)
 {
 	struct crypto_report_acomp racomp;
+	u64 v;
 
 	strlcpy(racomp.type, "acomp", sizeof(racomp.type));
+	v = atomic_read(&alg->compress_cnt);
+	racomp.stat_compress_cnt = v;
+	v = atomic_read(&alg->compress_tlen);
+	racomp.stat_compress_tlen = v;
+	v = atomic_read(&alg->decompress_cnt);
+	racomp.stat_decompress_cnt = v;
+	v = atomic_read(&alg->decompress_tlen);
+	racomp.stat_decompress_tlen = v;
 
 	if (nla_put(skb, CRYPTOCFGA_REPORT_ACOMP,
 		    sizeof(struct crypto_report_acomp), &racomp))
diff --git a/crypto/kpp.c b/crypto/kpp.c
index a90edc27af77..3db941345818 100644
--- a/crypto/kpp.c
+++ b/crypto/kpp.c
@@ -29,8 +29,15 @@
 static int crypto_kpp_report(struct sk_buff *skb, struct crypto_alg *alg)
 {
 	struct crypto_report_kpp rkpp;
+	u64 v;
 
 	strncpy(rkpp.type, "kpp", sizeof(rkpp.type));
+	v = atomic_read(&alg->setsecret_cnt);
+	rkpp.stat_setsecret_cnt = v;
+	v = atomic_read(&alg->generate_public_key_cnt);
+	rkpp.stat_generate_public_key_cnt = v;
+	v = atomic_read(&alg->compute_shared_secret_cnt);
+	rkpp.stat_compute_shared_secret_cnt = v;
 
 	if (nla_put(skb, CRYPTOCFGA_REPORT_KPP,
 		    sizeof(struct crypto_report_kpp), &rkpp))
diff --git a/crypto/rng.c b/crypto/rng.c
index b4a618668161..4cf1de1722ee 100644
--- a/crypto/rng.c
+++ b/crypto/rng.c
@@ -49,6 +49,7 @@ int crypto_rng_reset(struct crypto_rng *tfm, const u8 *seed, unsigned int slen)
 		seed = buf;
 	}
 
+	crypto_stat_rng_seed(tfm);
 	err = crypto_rng_alg(tfm)->seed(tfm, seed, slen);
 out:
 	kzfree(buf);
@@ -72,10 +73,17 @@ static unsigned int seedsize(struct crypto_alg *alg)
 static int crypto_rng_report(struct sk_buff *skb, struct crypto_alg *alg)
 {
 	struct crypto_report_rng rrng;
+	u64 v;
 
 	strncpy(rrng.type, "rng", sizeof(rrng.type));
 
 	rrng.seedsize = seedsize(alg);
+	v = atomic_read(&alg->generate_cnt);
+	rrng.stat_generate_cnt = v;
+	v = atomic_read(&alg->generate_tlen);
+	rrng.stat_generate_tlen = v;
+	v = atomic_read(&alg->seed_cnt);
+	rrng.stat_seed_cnt = v;
 
 	if (nla_put(skb, CRYPTOCFGA_REPORT_RNG,
 		    sizeof(struct crypto_report_rng), &rrng))
diff --git a/crypto/scompress.c b/crypto/scompress.c
index 968bbcf65c94..3c3115f5378e 100644
--- a/crypto/scompress.c
+++ b/crypto/scompress.c
@@ -39,8 +39,17 @@ static DEFINE_MUTEX(scomp_lock);
 static int crypto_scomp_report(struct sk_buff *skb, struct crypto_alg *alg)
 {
 	struct crypto_report_comp rscomp;
+	u64 v;
 
 	strncpy(rscomp.type, "scomp", sizeof(rscomp.type));
+	v = atomic_read(&alg->compress_cnt);
+	rscomp.stat_compress_cnt = v;
+	v = atomic_read(&alg->compress_tlen);
+	rscomp.stat_compress_tlen = v;
+	v = atomic_read(&alg->decompress_cnt);
+	rscomp.stat_decompress_cnt = v;
+	v = atomic_read(&alg->decompress_tlen);
+	rscomp.stat_decompress_tlen = v;
 
 	if (nla_put(skb, CRYPTOCFGA_REPORT_COMPRESS,
 		    sizeof(struct crypto_report_comp), &rscomp))
diff --git a/crypto/shash.c b/crypto/shash.c
index e849d3ee2e27..c1d086fa03e7 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -385,11 +385,16 @@ static int crypto_shash_report(struct sk_buff *skb, struct crypto_alg *alg)
 {
 	struct crypto_report_hash rhash;
 	struct shash_alg *salg = __crypto_shash_alg(alg);
+	u64 v;
 
 	strncpy(rhash.type, "shash", sizeof(rhash.type));
 
 	rhash.blocksize = alg->cra_blocksize;
 	rhash.digestsize = salg->digestsize;
+	v = atomic_read(&alg->hash_cnt);
+	rhash.stat_hash = v;
+	v = atomic_read(&alg->hash_tlen);
+	rhash.stat_hash_tlen = v;
 
 	if (nla_put(skb, CRYPTOCFGA_REPORT_HASH,
 		    sizeof(struct crypto_report_hash), &rhash))
diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 11af5fd6a443..102194ecaa7d 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -875,6 +875,7 @@ static int crypto_skcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
 	struct crypto_report_blkcipher rblkcipher;
 	struct skcipher_alg *skcipher = container_of(alg, struct skcipher_alg,
 						     base);
+	u64 v;
 
 	strncpy(rblkcipher.type, "skcipher", sizeof(rblkcipher.type));
 	strncpy(rblkcipher.geniv, "<none>", sizeof(rblkcipher.geniv));
@@ -883,6 +884,14 @@ static int crypto_skcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
 	rblkcipher.min_keysize = skcipher->min_keysize;
 	rblkcipher.max_keysize = skcipher->max_keysize;
 	rblkcipher.ivsize = skcipher->ivsize;
+	v = atomic_read(&alg->encrypt_cnt);
+	rblkcipher.stat_encrypt_cnt = v;
+	v = atomic_read(&alg->encrypt_tlen);
+	rblkcipher.stat_encrypt_tlen = v;
+	v = atomic_read(&alg->decrypt_cnt);
+	rblkcipher.stat_decrypt_cnt = v;
+	v = atomic_read(&alg->decrypt_tlen);
+	rblkcipher.stat_decrypt_tlen = v;
 
 	if (nla_put(skb, CRYPTOCFGA_REPORT_BLKCIPHER,
 		    sizeof(struct crypto_report_blkcipher), &rblkcipher))
diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index e328b52425a8..aed36031c6c1 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -234,6 +234,26 @@ static inline void acomp_request_set_params(struct acomp_req *req,
 		req->flags |= CRYPTO_ACOMP_ALLOC_OUTPUT;
 }
 
+static inline void crypto_stat_compress(struct acomp_req *req)
+{
+#ifdef CONFIG_CRYPTO_STATS
+	struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
+
+	atomic_inc(&tfm->base.__crt_alg->compress_cnt);
+	atomic_add(req->slen, &tfm->base.__crt_alg->compress_tlen);
+#endif
+}
+
+static inline void crypto_stat_decompress(struct acomp_req *req)
+{
+#ifdef CONFIG_CRYPTO_STATS
+	struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
+
+	atomic_inc(&tfm->base.__crt_alg->decompress_cnt);
+	atomic_add(req->slen, &tfm->base.__crt_alg->decompress_tlen);
+#endif
+}
+
 /**
  * crypto_acomp_compress() -- Invoke asynchronous compress operation
  *
@@ -247,6 +267,7 @@ static inline int crypto_acomp_compress(struct acomp_req *req)
 {
 	struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
 
+	crypto_stat_compress(req);
 	return tfm->compress(req);
 }
 
@@ -263,6 +284,7 @@ static inline int crypto_acomp_decompress(struct acomp_req *req)
 {
 	struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
 
+	crypto_stat_decompress(req);
 	return tfm->decompress(req);
 }
 
diff --git a/include/crypto/aead.h b/include/crypto/aead.h
index 03b97629442c..951f530b5abc 100644
--- a/include/crypto/aead.h
+++ b/include/crypto/aead.h
@@ -306,6 +306,26 @@ static inline struct crypto_aead *crypto_aead_reqtfm(struct aead_request *req)
 	return __crypto_aead_cast(req->base.tfm);
 }
 
+static inline void crypto_stat_aead_encrypt(struct aead_request *req)
+{
+#ifdef CONFIG_CRYPTO_STATS
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+
+	atomic_inc(&tfm->base.__crt_alg->encrypt_cnt);
+	atomic_add(req->cryptlen, &tfm->base.__crt_alg->encrypt_tlen);
+#endif
+}
+
+static inline void crypto_stat_aead_decrypt(struct aead_request *req)
+{
+#ifdef CONFIG_CRYPTO_STATS
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+
+	atomic_inc(&tfm->base.__crt_alg->decrypt_cnt);
+	atomic_add(req->cryptlen, &tfm->base.__crt_alg->decrypt_tlen);
+#endif
+}
+
 /**
  * crypto_aead_encrypt() - encrypt plaintext
  * @req: reference to the aead_request handle that holds all information
@@ -327,6 +347,7 @@ static inline struct crypto_aead *crypto_aead_reqtfm(struct aead_request *req)
  */
 static inline int crypto_aead_encrypt(struct aead_request *req)
 {
+	crypto_stat_aead_encrypt(req);
 	return crypto_aead_alg(crypto_aead_reqtfm(req))->encrypt(req);
 }
 
@@ -359,6 +380,7 @@ static inline int crypto_aead_decrypt(struct aead_request *req)
 	if (req->cryptlen < crypto_aead_authsize(aead))
 		return -EINVAL;
 
+	crypto_stat_aead_decrypt(req);
 	return crypto_aead_alg(aead)->decrypt(req);
 }
 
diff --git a/include/crypto/akcipher.h b/include/crypto/akcipher.h
index 8e0f752286e4..eb4fed99bce7 100644
--- a/include/crypto/akcipher.h
+++ b/include/crypto/akcipher.h
@@ -271,6 +271,44 @@ static inline unsigned int crypto_akcipher_maxsize(struct crypto_akcipher *tfm)
 	return alg->max_size(tfm);
 }
 
+static inline void crypto_stat_akcipher_encrypt(struct akcipher_request *req)
+{
+#ifdef CONFIG_CRYPTO_STATS
+	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
+
+	atomic_inc(&tfm->base.__crt_alg->encrypt_cnt);
+	atomic_add(req->src_len, &tfm->base.__crt_alg->encrypt_tlen);
+#endif
+}
+
+static inline void crypto_stat_akcipher_decrypt(struct akcipher_request *req)
+{
+#ifdef CONFIG_CRYPTO_STATS
+	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
+
+	atomic_inc(&tfm->base.__crt_alg->decrypt_cnt);
+	atomic_add(req->src_len, &tfm->base.__crt_alg->decrypt_tlen);
+#endif
+}
+
+static inline void crypto_stat_akcipher_sign(struct akcipher_request *req)
+{
+#ifdef CONFIG_CRYPTO_STATS
+	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
+
+	atomic_inc(&tfm->base.__crt_alg->sign_cnt);
+#endif
+}
+
+static inline void crypto_stat_akcipher_verify(struct akcipher_request *req)
+{
+#ifdef CONFIG_CRYPTO_STATS
+	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
+
+	atomic_inc(&tfm->base.__crt_alg->verify_cnt);
+#endif
+}
+
 /**
  * crypto_akcipher_encrypt() - Invoke public key encrypt operation
  *
@@ -286,6 +324,7 @@ static inline int crypto_akcipher_encrypt(struct akcipher_request *req)
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
 	struct akcipher_alg *alg = crypto_akcipher_alg(tfm);
 
+	crypto_stat_akcipher_encrypt(req);
 	return alg->encrypt(req);
 }
 
@@ -304,6 +343,7 @@ static inline int crypto_akcipher_decrypt(struct akcipher_request *req)
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
 	struct akcipher_alg *alg = crypto_akcipher_alg(tfm);
 
+	crypto_stat_akcipher_decrypt(req);
 	return alg->decrypt(req);
 }
 
@@ -322,6 +362,7 @@ static inline int crypto_akcipher_sign(struct akcipher_request *req)
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
 	struct akcipher_alg *alg = crypto_akcipher_alg(tfm);
 
+	crypto_stat_akcipher_sign(req);
 	return alg->sign(req);
 }
 
@@ -340,6 +381,7 @@ static inline int crypto_akcipher_verify(struct akcipher_request *req)
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
 	struct akcipher_alg *alg = crypto_akcipher_alg(tfm);
 
+	crypto_stat_akcipher_verify(req);
 	return alg->verify(req);
 }
 
diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index 0ed31fd80242..fd12d575e72f 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -415,6 +415,25 @@ static inline bool crypto_ahash_has_setkey(struct crypto_ahash *tfm)
 	return tfm->has_setkey;
 }
 
+static inline void crypto_stat_ahash_update(struct ahash_request *req)
+{
+#ifdef CONFIG_CRYPTO_STATS
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+
+	atomic_add(req->nbytes, &tfm->base.__crt_alg->hash_tlen);
+#endif
+}
+
+static inline void crypto_stat_ahash_final(struct ahash_request *req)
+{
+#ifdef CONFIG_CRYPTO_STATS
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+
+	atomic_inc(&tfm->base.__crt_alg->hash_cnt);
+	atomic_add(req->nbytes, &tfm->base.__crt_alg->hash_tlen);
+#endif
+}
+
 /**
  * crypto_ahash_finup() - update and finalize message digest
  * @req: reference to the ahash_request handle that holds all information
@@ -519,6 +538,8 @@ static inline int crypto_ahash_init(struct ahash_request *req)
  */
 static inline int crypto_ahash_update(struct ahash_request *req)
 {
+
+	crypto_stat_ahash_update(req);
 	return crypto_ahash_reqtfm(req)->update(req);
 }
 
diff --git a/include/crypto/kpp.h b/include/crypto/kpp.h
index 1bde0a6514fa..734fc70a80e7 100644
--- a/include/crypto/kpp.h
+++ b/include/crypto/kpp.h
@@ -268,6 +268,31 @@ struct kpp_secret {
 	unsigned short len;
 };
 
+static inline void crypto_stat_kpp_set_secret(struct crypto_kpp *tfm)
+{
+#ifdef CONFIG_CRYPTO_STATS
+	atomic_inc(&tfm->base.__crt_alg->setsecret_cnt);
+#endif
+}
+
+static inline void crypto_stat_kpp_generate_public_key(struct kpp_request *req)
+{
+#ifdef CONFIG_CRYPTO_STATS
+	struct crypto_kpp *tfm = crypto_kpp_reqtfm(req);
+
+	atomic_inc(&tfm->base.__crt_alg->generate_public_key_cnt);
+#endif
+}
+
+static inline void crypto_stat_kpp_compute_shared_secret(struct kpp_request *req)
+{
+#ifdef CONFIG_CRYPTO_STATS
+	struct crypto_kpp *tfm = crypto_kpp_reqtfm(req);
+
+	atomic_inc(&tfm->base.__crt_alg->compute_shared_secret_cnt);
+#endif
+}
+
 /**
  * crypto_kpp_set_secret() - Invoke kpp operation
  *
@@ -288,6 +313,7 @@ static inline int crypto_kpp_set_secret(struct crypto_kpp *tfm,
 {
 	struct kpp_alg *alg = crypto_kpp_alg(tfm);
 
+	crypto_stat_kpp_set_secret(tfm);
 	return alg->set_secret(tfm, buffer, len);
 }
 
@@ -309,6 +335,7 @@ static inline int crypto_kpp_generate_public_key(struct kpp_request *req)
 	struct crypto_kpp *tfm = crypto_kpp_reqtfm(req);
 	struct kpp_alg *alg = crypto_kpp_alg(tfm);
 
+	crypto_stat_kpp_generate_public_key(req);
 	return alg->generate_public_key(req);
 }
 
@@ -327,6 +354,7 @@ static inline int crypto_kpp_compute_shared_secret(struct kpp_request *req)
 	struct crypto_kpp *tfm = crypto_kpp_reqtfm(req);
 	struct kpp_alg *alg = crypto_kpp_alg(tfm);
 
+	crypto_stat_kpp_compute_shared_secret(req);
 	return alg->compute_shared_secret(req);
 }
 
diff --git a/include/crypto/rng.h b/include/crypto/rng.h
index 42811936a361..a50d8ce464e3 100644
--- a/include/crypto/rng.h
+++ b/include/crypto/rng.h
@@ -122,6 +122,22 @@ static inline void crypto_free_rng(struct crypto_rng *tfm)
 	crypto_destroy_tfm(tfm, crypto_rng_tfm(tfm));
 }
 
+static inline void crypto_stat_rng_seed(struct crypto_rng *tfm)
+{
+#ifdef CONFIG_CRYPTO_STATS
+	atomic_inc(&tfm->base.__crt_alg->seed_cnt);
+#endif
+}
+
+static inline void crypto_stat_rng_generate(struct crypto_rng *tfm,
+					    unsigned int dlen)
+{
+#ifdef CONFIG_CRYPTO_STATS
+	atomic_inc(&tfm->base.__crt_alg->generate_cnt);
+	atomic_add(dlen, &tfm->base.__crt_alg->generate_tlen);
+#endif
+}
+
 /**
  * crypto_rng_generate() - get random number
  * @tfm: cipher handle
@@ -140,6 +156,7 @@ static inline int crypto_rng_generate(struct crypto_rng *tfm,
 				      const u8 *src, unsigned int slen,
 				      u8 *dst, unsigned int dlen)
 {
+	crypto_stat_rng_generate(tfm, dlen);
 	return crypto_rng_alg(tfm)->generate(tfm, src, slen, dst, dlen);
 }
 
diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index 562001cb412b..476502a80861 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -427,6 +427,26 @@ static inline struct crypto_skcipher *crypto_skcipher_reqtfm(
 	return __crypto_skcipher_cast(req->base.tfm);
 }
 
+static inline void crypto_stat_skcipher_encrypt(struct skcipher_request *req)
+{
+#ifdef CONFIG_CRYPTO_STATS
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+
+	atomic_inc(&tfm->base.__crt_alg->encrypt_cnt);
+	atomic_add(req->cryptlen, &tfm->base.__crt_alg->encrypt_tlen);
+#endif
+}
+
+static inline void crypto_stat_skcipher_decrypt(struct skcipher_request *req)
+{
+#ifdef CONFIG_CRYPTO_STATS
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+
+	atomic_inc(&tfm->base.__crt_alg->decrypt_cnt);
+	atomic_add(req->cryptlen, &tfm->base.__crt_alg->decrypt_tlen);
+#endif
+}
+
 /**
  * crypto_skcipher_encrypt() - encrypt plaintext
  * @req: reference to the skcipher_request handle that holds all information
@@ -442,6 +462,7 @@ static inline int crypto_skcipher_encrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 
+	crypto_stat_skcipher_encrypt(req);
 	return tfm->encrypt(req);
 }
 
@@ -460,6 +481,7 @@ static inline int crypto_skcipher_decrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 
+	crypto_stat_skcipher_decrypt(req);
 	return tfm->decrypt(req);
 }
 
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 231e59f90d32..3ba299720aaa 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -466,6 +466,36 @@ struct crypto_alg {
 	void (*cra_destroy)(struct crypto_alg *alg);
 	
 	struct module *cra_module;
+
+	union {
+		atomic_t encrypt_cnt;
+		atomic_t compress_cnt;
+		atomic_t generate_cnt;
+		atomic_t hash_cnt;
+		atomic_t setsecret_cnt;
+	};
+	union {
+		atomic_t encrypt_tlen;
+		atomic_t compress_tlen;
+		atomic_t generate_tlen;
+		atomic_t hash_tlen;
+	};
+	union {
+		atomic_t decrypt_cnt;
+		atomic_t decompress_cnt;
+		atomic_t seed_cnt;
+		atomic_t generate_public_key_cnt;
+	};
+	union {
+		atomic_t decrypt_tlen;
+		atomic_t decompress_tlen;
+	};
+	union {
+		atomic_t verify_cnt;
+		atomic_t compute_shared_secret_cnt;
+	};
+	atomic_t sign_cnt;
+
 } CRYPTO_MINALIGN_ATTR;
 
 /*
@@ -886,6 +916,28 @@ static inline struct crypto_ablkcipher *crypto_ablkcipher_reqtfm(
 	return __crypto_ablkcipher_cast(req->base.tfm);
 }
 
+static inline void crypto_stat_ablkcipher_encrypt(struct ablkcipher_request *req)
+{
+#ifdef CONFIG_CRYPTO_STATS
+	struct ablkcipher_tfm *crt =
+		crypto_ablkcipher_crt(crypto_ablkcipher_reqtfm(req));
+
+	atomic_inc(&crt->base->base.__crt_alg->encrypt_cnt);
+	atomic_add(req->nbytes, &crt->base->base.__crt_alg->encrypt_tlen);
+#endif
+}
+
+static inline void crypto_stat_ablkcipher_decrypt(struct ablkcipher_request *req)
+{
+#ifdef CONFIG_CRYPTO_STATS
+	struct ablkcipher_tfm *crt =
+		crypto_ablkcipher_crt(crypto_ablkcipher_reqtfm(req));
+
+	atomic_inc(&crt->base->base.__crt_alg->decrypt_cnt);
+	atomic_add(req->nbytes, &crt->base->base.__crt_alg->decrypt_tlen);
+#endif
+}
+
 /**
  * crypto_ablkcipher_encrypt() - encrypt plaintext
  * @req: reference to the ablkcipher_request handle that holds all information
@@ -901,6 +953,8 @@ static inline int crypto_ablkcipher_encrypt(struct ablkcipher_request *req)
 {
 	struct ablkcipher_tfm *crt =
 		crypto_ablkcipher_crt(crypto_ablkcipher_reqtfm(req));
+
+	crypto_stat_ablkcipher_encrypt(req);
 	return crt->encrypt(req);
 }
 
@@ -919,6 +973,8 @@ static inline int crypto_ablkcipher_decrypt(struct ablkcipher_request *req)
 {
 	struct ablkcipher_tfm *crt =
 		crypto_ablkcipher_crt(crypto_ablkcipher_reqtfm(req));
+
+	crypto_stat_ablkcipher_decrypt(req);
 	return crt->decrypt(req);
 }
 
diff --git a/include/uapi/linux/cryptouser.h b/include/uapi/linux/cryptouser.h
index 19bf0ca6d635..15e51ccb3679 100644
--- a/include/uapi/linux/cryptouser.h
+++ b/include/uapi/linux/cryptouser.h
@@ -73,6 +73,8 @@ struct crypto_report_hash {
 	char type[CRYPTO_MAX_NAME];
 	unsigned int blocksize;
 	unsigned int digestsize;
+	__u64 stat_hash;
+	__u64 stat_hash_tlen;
 };
 
 struct crypto_report_cipher {
@@ -80,6 +82,10 @@ struct crypto_report_cipher {
 	unsigned int blocksize;
 	unsigned int min_keysize;
 	unsigned int max_keysize;
+	__u64 stat_encrypt_cnt;
+	__u64 stat_encrypt_tlen;
+	__u64 stat_decrypt_cnt;
+	__u64 stat_decrypt_tlen;
 };
 
 struct crypto_report_blkcipher {
@@ -89,6 +95,10 @@ struct crypto_report_blkcipher {
 	unsigned int min_keysize;
 	unsigned int max_keysize;
 	unsigned int ivsize;
+	__u64 stat_encrypt_cnt;
+	__u64 stat_encrypt_tlen;
+	__u64 stat_decrypt_cnt;
+	__u64 stat_decrypt_tlen;
 };
 
 struct crypto_report_aead {
@@ -97,27 +107,51 @@ struct crypto_report_aead {
 	unsigned int blocksize;
 	unsigned int maxauthsize;
 	unsigned int ivsize;
+	__u64 stat_encrypt_cnt;
+	__u64 stat_encrypt_tlen;
+	__u64 stat_decrypt_cnt;
+	__u64 stat_decrypt_tlen;
 };
 
 struct crypto_report_comp {
 	char type[CRYPTO_MAX_NAME];
+	__u64 stat_compress_cnt;
+	__u64 stat_compress_tlen;
+	__u64 stat_decompress_cnt;
+	__u64 stat_decompress_tlen;
 };
 
 struct crypto_report_rng {
 	char type[CRYPTO_MAX_NAME];
 	unsigned int seedsize;
+	__u64 stat_generate_cnt;
+	__u64 stat_generate_tlen;
+	__u64 stat_seed_cnt;
 };
 
 struct crypto_report_akcipher {
 	char type[CRYPTO_MAX_NAME];
+	__u64 stat_encrypt_cnt;
+	__u64 stat_encrypt_tlen;
+	__u64 stat_decrypt_cnt;
+	__u64 stat_decrypt_tlen;
+	__u64 stat_verify_cnt;
+	__u64 stat_sign_cnt;
 };
 
 struct crypto_report_kpp {
 	char type[CRYPTO_MAX_NAME];
+	__u64 stat_setsecret_cnt;
+	__u64 stat_generate_public_key_cnt;
+	__u64 stat_compute_shared_secret_cnt;
 };
 
 struct crypto_report_acomp {
 	char type[CRYPTO_MAX_NAME];
+	__u64 stat_compress_cnt;
+	__u64 stat_compress_tlen;
+	__u64 stat_decompress_cnt;
+	__u64 stat_decompress_tlen;
 };
 
 #define CRYPTO_REPORT_MAXSIZE (sizeof(struct crypto_user_alg) + \
-- 
2.13.6
