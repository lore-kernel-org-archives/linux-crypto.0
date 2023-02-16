Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19D45C636CC
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Feb 2023 10:36:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbjBPKgN (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Feb 2023 05:36:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjBPKgN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Feb 2023 05:36:13 -0500
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D73975456D
        for <linux-crypto@vger.kernel.org>; Thu, 16 Feb 2023 02:35:51 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pSbbb-00BwIa-4w; Thu, 16 Feb 2023 18:35:12 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 16 Feb 2023 18:35:11 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Thu, 16 Feb 2023 18:35:11 +0800
Subject: [v2 PATCH 2/10] crypto: aead - Count error stats differently
References: <Y+4GpkkLQjyv7KUt@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Message-Id: <E1pSbbb-00BwIa-4w@formenos.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Move all stat code specific to aead into the aead code.

While we're at it, change the stats so that bytes and counts
are always incremented even in case of error.  This allows the
reference counting to be removed as we can now increment the
counters prior to the operation.

After the operation we simply increase the error count if necessary.
This is safe as errors can only occur synchronously (or rather,
the existing code already ignored asynchronous errors which are
only visible to the callback function).

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/aead.c             |   86 +++++++++++++++++++++++++++++++++++++++-------
 crypto/algapi.c           |   26 -------------
 crypto/crypto_user_stat.c |   21 -----------
 include/crypto/aead.h     |   22 +++++++++++
 include/linux/crypto.h    |   24 ------------
 5 files changed, 95 insertions(+), 84 deletions(-)

diff --git a/crypto/aead.c b/crypto/aead.c
index 16991095270d..5ea65c433608 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -8,17 +8,27 @@
  */
 
 #include <crypto/internal/aead.h>
+#include <linux/cryptouser.h>
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/seq_file.h>
-#include <linux/cryptouser.h>
+#include <linux/string.h>
 #include <net/netlink.h>
 
 #include "internal.h"
 
+static inline struct crypto_istat_aead *aead_get_stat(struct aead_alg *alg)
+{
+#ifdef CONFIG_CRYPTO_STATS
+	return &alg->stat;
+#else
+	return NULL;
+#endif
+}
+
 static int setkey_unaligned(struct crypto_aead *tfm, const u8 *key,
 			    unsigned int keylen)
 {
@@ -80,39 +90,62 @@ int crypto_aead_setauthsize(struct crypto_aead *tfm, unsigned int authsize)
 }
 EXPORT_SYMBOL_GPL(crypto_aead_setauthsize);
 
+static inline int crypto_aead_errstat(struct crypto_istat_aead *istat, int err)
+{
+	if (!IS_ENABLED(CONFIG_CRYPTO_STATS))
+		return err;
+
+	if (err && err != -EINPROGRESS && err != -EBUSY)
+		atomic64_inc(&istat->err_cnt);
+
+	return err;
+}
+
 int crypto_aead_encrypt(struct aead_request *req)
 {
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
-	struct crypto_alg *alg = aead->base.__crt_alg;
-	unsigned int cryptlen = req->cryptlen;
+	struct aead_alg *alg = crypto_aead_alg(aead);
+	struct crypto_istat_aead *istat;
 	int ret;
 
-	crypto_stats_get(alg);
+	istat = aead_get_stat(alg);
+
+	if (IS_ENABLED(CONFIG_CRYPTO_STATS)) {
+		atomic64_inc(&istat->encrypt_cnt);
+		atomic64_add(req->cryptlen, &istat->encrypt_tlen);
+	}
+
 	if (crypto_aead_get_flags(aead) & CRYPTO_TFM_NEED_KEY)
 		ret = -ENOKEY;
 	else
-		ret = crypto_aead_alg(aead)->encrypt(req);
-	crypto_stats_aead_encrypt(cryptlen, alg, ret);
-	return ret;
+		ret = alg->encrypt(req);
+
+	return crypto_aead_errstat(istat, ret);
 }
 EXPORT_SYMBOL_GPL(crypto_aead_encrypt);
 
 int crypto_aead_decrypt(struct aead_request *req)
 {
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
-	struct crypto_alg *alg = aead->base.__crt_alg;
-	unsigned int cryptlen = req->cryptlen;
+	struct aead_alg *alg = crypto_aead_alg(aead);
+	struct crypto_istat_aead *istat;
 	int ret;
 
-	crypto_stats_get(alg);
+	istat = aead_get_stat(alg);
+
+	if (IS_ENABLED(CONFIG_CRYPTO_STATS)) {
+		atomic64_inc(&istat->encrypt_cnt);
+		atomic64_add(req->cryptlen, &istat->encrypt_tlen);
+	}
+
 	if (crypto_aead_get_flags(aead) & CRYPTO_TFM_NEED_KEY)
 		ret = -ENOKEY;
 	else if (req->cryptlen < crypto_aead_authsize(aead))
 		ret = -EINVAL;
 	else
-		ret = crypto_aead_alg(aead)->decrypt(req);
-	crypto_stats_aead_decrypt(cryptlen, alg, ret);
-	return ret;
+		ret = alg->decrypt(req);
+
+	return crypto_aead_errstat(istat, ret);
 }
 EXPORT_SYMBOL_GPL(crypto_aead_decrypt);
 
@@ -188,6 +221,26 @@ static void crypto_aead_free_instance(struct crypto_instance *inst)
 	aead->free(aead);
 }
 
+static int __maybe_unused crypto_aead_report_stat(
+	struct sk_buff *skb, struct crypto_alg *alg)
+{
+	struct aead_alg *aead = container_of(alg, struct aead_alg, base);
+	struct crypto_istat_aead *istat = aead_get_stat(aead);
+	struct crypto_stat_aead raead;
+
+	memset(&raead, 0, sizeof(raead));
+
+	strscpy(raead.type, "aead", sizeof(raead.type));
+
+	raead.stat_encrypt_cnt = atomic64_read(&istat->encrypt_cnt);
+	raead.stat_encrypt_tlen = atomic64_read(&istat->encrypt_tlen);
+	raead.stat_decrypt_cnt = atomic64_read(&istat->decrypt_cnt);
+	raead.stat_decrypt_tlen = atomic64_read(&istat->decrypt_tlen);
+	raead.stat_err_cnt = atomic64_read(&istat->err_cnt);
+
+	return nla_put(skb, CRYPTOCFGA_STAT_AEAD, sizeof(raead), &raead);
+}
+
 static const struct crypto_type crypto_aead_type = {
 	.extsize = crypto_alg_extsize,
 	.init_tfm = crypto_aead_init_tfm,
@@ -196,6 +249,9 @@ static const struct crypto_type crypto_aead_type = {
 	.show = crypto_aead_show,
 #endif
 	.report = crypto_aead_report,
+#ifdef CONFIG_CRYPTO_STATS
+	.report_stat = crypto_aead_report_stat,
+#endif
 	.maskclear = ~CRYPTO_ALG_TYPE_MASK,
 	.maskset = CRYPTO_ALG_TYPE_MASK,
 	.type = CRYPTO_ALG_TYPE_AEAD,
@@ -219,6 +275,7 @@ EXPORT_SYMBOL_GPL(crypto_alloc_aead);
 
 static int aead_prepare_alg(struct aead_alg *alg)
 {
+	struct crypto_istat_aead *istat = aead_get_stat(alg);
 	struct crypto_alg *base = &alg->base;
 
 	if (max3(alg->maxauthsize, alg->ivsize, alg->chunksize) >
@@ -232,6 +289,9 @@ static int aead_prepare_alg(struct aead_alg *alg)
 	base->cra_flags &= ~CRYPTO_ALG_TYPE_MASK;
 	base->cra_flags |= CRYPTO_ALG_TYPE_AEAD;
 
+	if (IS_ENABLED(CONFIG_CRYPTO_STATS))
+		memset(istat, 0, sizeof(*istat));
+
 	return 0;
 }
 
diff --git a/crypto/algapi.c b/crypto/algapi.c
index d08f864f08be..f7f7c61d456a 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -1051,32 +1051,6 @@ void crypto_stats_get(struct crypto_alg *alg)
 }
 EXPORT_SYMBOL_GPL(crypto_stats_get);
 
-void crypto_stats_aead_encrypt(unsigned int cryptlen, struct crypto_alg *alg,
-			       int ret)
-{
-	if (ret && ret != -EINPROGRESS && ret != -EBUSY) {
-		atomic64_inc(&alg->stats.aead.err_cnt);
-	} else {
-		atomic64_inc(&alg->stats.aead.encrypt_cnt);
-		atomic64_add(cryptlen, &alg->stats.aead.encrypt_tlen);
-	}
-	crypto_alg_put(alg);
-}
-EXPORT_SYMBOL_GPL(crypto_stats_aead_encrypt);
-
-void crypto_stats_aead_decrypt(unsigned int cryptlen, struct crypto_alg *alg,
-			       int ret)
-{
-	if (ret && ret != -EINPROGRESS && ret != -EBUSY) {
-		atomic64_inc(&alg->stats.aead.err_cnt);
-	} else {
-		atomic64_inc(&alg->stats.aead.decrypt_cnt);
-		atomic64_add(cryptlen, &alg->stats.aead.decrypt_tlen);
-	}
-	crypto_alg_put(alg);
-}
-EXPORT_SYMBOL_GPL(crypto_stats_aead_decrypt);
-
 void crypto_stats_akcipher_encrypt(unsigned int src_len, int ret,
 				   struct crypto_alg *alg)
 {
diff --git a/crypto/crypto_user_stat.c b/crypto/crypto_user_stat.c
index 2369814029fa..50ec076507a1 100644
--- a/crypto/crypto_user_stat.c
+++ b/crypto/crypto_user_stat.c
@@ -28,23 +28,6 @@ struct crypto_dump_info {
 	u16 nlmsg_flags;
 };
 
-static int crypto_report_aead(struct sk_buff *skb, struct crypto_alg *alg)
-{
-	struct crypto_stat_aead raead;
-
-	memset(&raead, 0, sizeof(raead));
-
-	strscpy(raead.type, "aead", sizeof(raead.type));
-
-	raead.stat_encrypt_cnt = atomic64_read(&alg->stats.aead.encrypt_cnt);
-	raead.stat_encrypt_tlen = atomic64_read(&alg->stats.aead.encrypt_tlen);
-	raead.stat_decrypt_cnt = atomic64_read(&alg->stats.aead.decrypt_cnt);
-	raead.stat_decrypt_tlen = atomic64_read(&alg->stats.aead.decrypt_tlen);
-	raead.stat_err_cnt = atomic64_read(&alg->stats.aead.err_cnt);
-
-	return nla_put(skb, CRYPTOCFGA_STAT_AEAD, sizeof(raead), &raead);
-}
-
 static int crypto_report_cipher(struct sk_buff *skb, struct crypto_alg *alg)
 {
 	struct crypto_stat_cipher rcipher;
@@ -211,10 +194,6 @@ static int crypto_reportstat_one(struct crypto_alg *alg,
 	}
 
 	switch (alg->cra_flags & (CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_LARVAL)) {
-	case CRYPTO_ALG_TYPE_AEAD:
-		if (crypto_report_aead(skb, alg))
-			goto nla_put_failure;
-		break;
 	case CRYPTO_ALG_TYPE_SKCIPHER:
 		if (crypto_report_cipher(skb, alg))
 			goto nla_put_failure;
diff --git a/include/crypto/aead.h b/include/crypto/aead.h
index 4a2b7e6e0c1f..35e45b854a6f 100644
--- a/include/crypto/aead.h
+++ b/include/crypto/aead.h
@@ -8,6 +8,7 @@
 #ifndef _CRYPTO_AEAD_H
 #define _CRYPTO_AEAD_H
 
+#include <linux/atomic.h>
 #include <linux/container_of.h>
 #include <linux/crypto.h>
 #include <linux/slab.h>
@@ -100,6 +101,22 @@ struct aead_request {
 	void *__ctx[] CRYPTO_MINALIGN_ATTR;
 };
 
+/*
+ * struct crypto_istat_aead - statistics for AEAD algorithm
+ * @encrypt_cnt:	number of encrypt requests
+ * @encrypt_tlen:	total data size handled by encrypt requests
+ * @decrypt_cnt:	number of decrypt requests
+ * @decrypt_tlen:	total data size handled by decrypt requests
+ * @err_cnt:		number of error for AEAD requests
+ */
+struct crypto_istat_aead {
+	atomic64_t encrypt_cnt;
+	atomic64_t encrypt_tlen;
+	atomic64_t decrypt_cnt;
+	atomic64_t decrypt_tlen;
+	atomic64_t err_cnt;
+};
+
 /**
  * struct aead_alg - AEAD cipher definition
  * @maxauthsize: Set the maximum authentication tag size supported by the
@@ -118,6 +135,7 @@ struct aead_request {
  * @setkey: see struct skcipher_alg
  * @encrypt: see struct skcipher_alg
  * @decrypt: see struct skcipher_alg
+ * @stat: statistics for AEAD algorithm
  * @ivsize: see struct skcipher_alg
  * @chunksize: see struct skcipher_alg
  * @init: Initialize the cryptographic transformation object. This function
@@ -144,6 +162,10 @@ struct aead_alg {
 	int (*init)(struct crypto_aead *tfm);
 	void (*exit)(struct crypto_aead *tfm);
 
+#ifdef CONFIG_CRYPTO_STATS
+	struct crypto_istat_aead stat;
+#endif
+
 	unsigned int ivsize;
 	unsigned int maxauthsize;
 	unsigned int chunksize;
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index bb1d9b0e1647..9eb6fc8ab69c 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -276,22 +276,6 @@ struct compress_alg {
 };
 
 #ifdef CONFIG_CRYPTO_STATS
-/*
- * struct crypto_istat_aead - statistics for AEAD algorithm
- * @encrypt_cnt:	number of encrypt requests
- * @encrypt_tlen:	total data size handled by encrypt requests
- * @decrypt_cnt:	number of decrypt requests
- * @decrypt_tlen:	total data size handled by decrypt requests
- * @err_cnt:		number of error for AEAD requests
- */
-struct crypto_istat_aead {
-	atomic64_t encrypt_cnt;
-	atomic64_t encrypt_tlen;
-	atomic64_t decrypt_cnt;
-	atomic64_t decrypt_tlen;
-	atomic64_t err_cnt;
-};
-
 /*
  * struct crypto_istat_akcipher - statistics for akcipher algorithm
  * @encrypt_cnt:	number of encrypt requests
@@ -463,7 +447,6 @@ struct crypto_istat_rng {
  * @cra_destroy: internally used
  *
  * @stats: union of all possible crypto_istat_xxx structures
- * @stats.aead:		statistics for AEAD algorithm
  * @stats.akcipher:	statistics for akcipher algorithm
  * @stats.cipher:	statistics for cipher algorithm
  * @stats.compress:	statistics for compress algorithm
@@ -505,7 +488,6 @@ struct crypto_alg {
 
 #ifdef CONFIG_CRYPTO_STATS
 	union {
-		struct crypto_istat_aead aead;
 		struct crypto_istat_akcipher akcipher;
 		struct crypto_istat_cipher cipher;
 		struct crypto_istat_compress compress;
@@ -520,8 +502,6 @@ struct crypto_alg {
 #ifdef CONFIG_CRYPTO_STATS
 void crypto_stats_init(struct crypto_alg *alg);
 void crypto_stats_get(struct crypto_alg *alg);
-void crypto_stats_aead_encrypt(unsigned int cryptlen, struct crypto_alg *alg, int ret);
-void crypto_stats_aead_decrypt(unsigned int cryptlen, struct crypto_alg *alg, int ret);
 void crypto_stats_ahash_update(unsigned int nbytes, int ret, struct crypto_alg *alg);
 void crypto_stats_ahash_final(unsigned int nbytes, int ret, struct crypto_alg *alg);
 void crypto_stats_akcipher_encrypt(unsigned int src_len, int ret, struct crypto_alg *alg);
@@ -542,10 +522,6 @@ static inline void crypto_stats_init(struct crypto_alg *alg)
 {}
 static inline void crypto_stats_get(struct crypto_alg *alg)
 {}
-static inline void crypto_stats_aead_encrypt(unsigned int cryptlen, struct crypto_alg *alg, int ret)
-{}
-static inline void crypto_stats_aead_decrypt(unsigned int cryptlen, struct crypto_alg *alg, int ret)
-{}
 static inline void crypto_stats_ahash_update(unsigned int nbytes, int ret, struct crypto_alg *alg)
 {}
 static inline void crypto_stats_ahash_final(unsigned int nbytes, int ret, struct crypto_alg *alg)
