Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D2DDC61DA4
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Feb 2023 10:36:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbjBPKgO (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Feb 2023 05:36:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbjBPKgN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Feb 2023 05:36:13 -0500
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6DFD5454A
        for <linux-crypto@vger.kernel.org>; Thu, 16 Feb 2023 02:35:51 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pSbbl-00BwJW-MO; Thu, 16 Feb 2023 18:35:22 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 16 Feb 2023 18:35:21 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Thu, 16 Feb 2023 18:35:21 +0800
Subject: [v2 PATCH 7/10] crypto: skcipher - Count error stats differently
References: <Y+4GpkkLQjyv7KUt@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Message-Id: <E1pSbbl-00BwJW-MO@formenos.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Move all stat code specific to skcipher into the skcipher code.

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

 crypto/algapi.c           |   26 -----------
 crypto/crypto_user_stat.c |   11 ----
 crypto/skcipher.c         |  105 ++++++++++++++++++++++++++++++++++++++--------
 include/crypto/skcipher.h |   22 +++++++++
 include/linux/crypto.h    |   24 ----------
 5 files changed, 109 insertions(+), 79 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 6fcb6192a3d7..3259be84169b 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -1073,32 +1073,6 @@ void crypto_stats_rng_generate(struct crypto_alg *alg, unsigned int dlen,
 	crypto_alg_put(alg);
 }
 EXPORT_SYMBOL_GPL(crypto_stats_rng_generate);
-
-void crypto_stats_skcipher_encrypt(unsigned int cryptlen, int ret,
-				   struct crypto_alg *alg)
-{
-	if (ret && ret != -EINPROGRESS && ret != -EBUSY) {
-		atomic64_inc(&alg->stats.cipher.err_cnt);
-	} else {
-		atomic64_inc(&alg->stats.cipher.encrypt_cnt);
-		atomic64_add(cryptlen, &alg->stats.cipher.encrypt_tlen);
-	}
-	crypto_alg_put(alg);
-}
-EXPORT_SYMBOL_GPL(crypto_stats_skcipher_encrypt);
-
-void crypto_stats_skcipher_decrypt(unsigned int cryptlen, int ret,
-				   struct crypto_alg *alg)
-{
-	if (ret && ret != -EINPROGRESS && ret != -EBUSY) {
-		atomic64_inc(&alg->stats.cipher.err_cnt);
-	} else {
-		atomic64_inc(&alg->stats.cipher.decrypt_cnt);
-		atomic64_add(cryptlen, &alg->stats.cipher.decrypt_tlen);
-	}
-	crypto_alg_put(alg);
-}
-EXPORT_SYMBOL_GPL(crypto_stats_skcipher_decrypt);
 #endif
 
 static void __init crypto_start_tests(void)
diff --git a/crypto/crypto_user_stat.c b/crypto/crypto_user_stat.c
index 6ace8b70866f..b57e43278ee1 100644
--- a/crypto/crypto_user_stat.c
+++ b/crypto/crypto_user_stat.c
@@ -11,7 +11,6 @@
 #include <linux/sched.h>
 #include <net/netlink.h>
 #include <net/sock.h>
-#include <crypto/internal/skcipher.h>
 #include <crypto/internal/rng.h>
 #include <crypto/internal/cryptouser.h>
 
@@ -34,12 +33,6 @@ static int crypto_report_cipher(struct sk_buff *skb, struct crypto_alg *alg)
 
 	strscpy(rcipher.type, "cipher", sizeof(rcipher.type));
 
-	rcipher.stat_encrypt_cnt = atomic64_read(&alg->stats.cipher.encrypt_cnt);
-	rcipher.stat_encrypt_tlen = atomic64_read(&alg->stats.cipher.encrypt_tlen);
-	rcipher.stat_decrypt_cnt =  atomic64_read(&alg->stats.cipher.decrypt_cnt);
-	rcipher.stat_decrypt_tlen = atomic64_read(&alg->stats.cipher.decrypt_tlen);
-	rcipher.stat_err_cnt =  atomic64_read(&alg->stats.cipher.err_cnt);
-
 	return nla_put(skb, CRYPTOCFGA_STAT_CIPHER, sizeof(rcipher), &rcipher);
 }
 
@@ -106,10 +99,6 @@ static int crypto_reportstat_one(struct crypto_alg *alg,
 	}
 
 	switch (alg->cra_flags & (CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_LARVAL)) {
-	case CRYPTO_ALG_TYPE_SKCIPHER:
-		if (crypto_report_cipher(skb, alg))
-			goto nla_put_failure;
-		break;
 	case CRYPTO_ALG_TYPE_CIPHER:
 		if (crypto_report_cipher(skb, alg))
 			goto nla_put_failure;
diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 7bf4871fec80..0139f3416339 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -15,11 +15,14 @@
 #include <crypto/scatterwalk.h>
 #include <linux/bug.h>
 #include <linux/cryptouser.h>
-#include <linux/compiler.h>
+#include <linux/err.h>
+#include <linux/kernel.h>
 #include <linux/list.h>
+#include <linux/mm.h>
 #include <linux/module.h>
-#include <linux/rtnetlink.h>
 #include <linux/seq_file.h>
+#include <linux/slab.h>
+#include <linux/string.h>
 #include <net/netlink.h>
 
 #include "internal.h"
@@ -77,6 +80,35 @@ static inline u8 *skcipher_get_spot(u8 *start, unsigned int len)
 	return max(start, end_page);
 }
 
+static inline struct skcipher_alg *__crypto_skcipher_alg(
+	struct crypto_alg *alg)
+{
+	return container_of(alg, struct skcipher_alg, base);
+}
+
+static inline struct crypto_istat_cipher *skcipher_get_stat(
+	struct skcipher_alg *alg)
+{
+#ifdef CONFIG_CRYPTO_STATS
+	return &alg->stat;
+#else
+	return NULL;
+#endif
+}
+
+static inline int crypto_skcipher_errstat(struct skcipher_alg *alg, int err)
+{
+	struct crypto_istat_cipher *istat = skcipher_get_stat(alg);
+
+	if (!IS_ENABLED(CONFIG_CRYPTO_STATS))
+		return err;
+
+	if (err && err != -EINPROGRESS && err != -EBUSY)
+		atomic64_inc(&istat->err_cnt);
+
+	return err;
+}
+
 static int skcipher_done_slow(struct skcipher_walk *walk, unsigned int bsize)
 {
 	u8 *addr;
@@ -605,34 +637,44 @@ EXPORT_SYMBOL_GPL(crypto_skcipher_setkey);
 int crypto_skcipher_encrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct crypto_alg *alg = tfm->base.__crt_alg;
-	unsigned int cryptlen = req->cryptlen;
+	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
 	int ret;
 
-	crypto_stats_get(alg);
+	if (IS_ENABLED(CONFIG_CRYPTO_STATS)) {
+		struct crypto_istat_cipher *istat = skcipher_get_stat(alg);
+
+		atomic64_inc(&istat->encrypt_cnt);
+		atomic64_add(req->cryptlen, &istat->encrypt_tlen);
+	}
+
 	if (crypto_skcipher_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
 		ret = -ENOKEY;
 	else
-		ret = crypto_skcipher_alg(tfm)->encrypt(req);
-	crypto_stats_skcipher_encrypt(cryptlen, ret, alg);
-	return ret;
+		ret = alg->encrypt(req);
+
+	return crypto_skcipher_errstat(alg, ret);
 }
 EXPORT_SYMBOL_GPL(crypto_skcipher_encrypt);
 
 int crypto_skcipher_decrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct crypto_alg *alg = tfm->base.__crt_alg;
-	unsigned int cryptlen = req->cryptlen;
+	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
 	int ret;
 
-	crypto_stats_get(alg);
+	if (IS_ENABLED(CONFIG_CRYPTO_STATS)) {
+		struct crypto_istat_cipher *istat = skcipher_get_stat(alg);
+
+		atomic64_inc(&istat->decrypt_cnt);
+		atomic64_add(req->cryptlen, &istat->decrypt_tlen);
+	}
+
 	if (crypto_skcipher_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
 		ret = -ENOKEY;
 	else
-		ret = crypto_skcipher_alg(tfm)->decrypt(req);
-	crypto_stats_skcipher_decrypt(cryptlen, ret, alg);
-	return ret;
+		ret = alg->decrypt(req);
+
+	return crypto_skcipher_errstat(alg, ret);
 }
 EXPORT_SYMBOL_GPL(crypto_skcipher_decrypt);
 
@@ -672,8 +714,7 @@ static void crypto_skcipher_show(struct seq_file *m, struct crypto_alg *alg)
 	__maybe_unused;
 static void crypto_skcipher_show(struct seq_file *m, struct crypto_alg *alg)
 {
-	struct skcipher_alg *skcipher = container_of(alg, struct skcipher_alg,
-						     base);
+	struct skcipher_alg *skcipher = __crypto_skcipher_alg(alg);
 
 	seq_printf(m, "type         : skcipher\n");
 	seq_printf(m, "async        : %s\n",
@@ -689,9 +730,8 @@ static void crypto_skcipher_show(struct seq_file *m, struct crypto_alg *alg)
 #ifdef CONFIG_NET
 static int crypto_skcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
 {
+	struct skcipher_alg *skcipher = __crypto_skcipher_alg(alg);
 	struct crypto_report_blkcipher rblkcipher;
-	struct skcipher_alg *skcipher = container_of(alg, struct skcipher_alg,
-						     base);
 
 	memset(&rblkcipher, 0, sizeof(rblkcipher));
 
@@ -713,6 +753,28 @@ static int crypto_skcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
 }
 #endif
 
+static int __maybe_unused crypto_skcipher_report_stat(
+	struct sk_buff *skb, struct crypto_alg *alg)
+{
+	struct skcipher_alg *skcipher = __crypto_skcipher_alg(alg);
+	struct crypto_istat_cipher *istat;
+	struct crypto_stat_cipher rcipher;
+
+	istat = skcipher_get_stat(skcipher);
+
+	memset(&rcipher, 0, sizeof(rcipher));
+
+	strscpy(rcipher.type, "cipher", sizeof(rcipher.type));
+
+	rcipher.stat_encrypt_cnt = atomic64_read(&istat->encrypt_cnt);
+	rcipher.stat_encrypt_tlen = atomic64_read(&istat->encrypt_tlen);
+	rcipher.stat_decrypt_cnt =  atomic64_read(&istat->decrypt_cnt);
+	rcipher.stat_decrypt_tlen = atomic64_read(&istat->decrypt_tlen);
+	rcipher.stat_err_cnt =  atomic64_read(&istat->err_cnt);
+
+	return nla_put(skb, CRYPTOCFGA_STAT_CIPHER, sizeof(rcipher), &rcipher);
+}
+
 static const struct crypto_type crypto_skcipher_type = {
 	.extsize = crypto_alg_extsize,
 	.init_tfm = crypto_skcipher_init_tfm,
@@ -721,6 +783,9 @@ static const struct crypto_type crypto_skcipher_type = {
 	.show = crypto_skcipher_show,
 #endif
 	.report = crypto_skcipher_report,
+#ifdef CONFIG_CRYPTO_STATS
+	.report_stat = crypto_skcipher_report_stat,
+#endif
 	.maskclear = ~CRYPTO_ALG_TYPE_MASK,
 	.maskset = CRYPTO_ALG_TYPE_MASK,
 	.type = CRYPTO_ALG_TYPE_SKCIPHER,
@@ -775,6 +840,7 @@ EXPORT_SYMBOL_GPL(crypto_has_skcipher);
 
 static int skcipher_prepare_alg(struct skcipher_alg *alg)
 {
+	struct crypto_istat_cipher *istat = skcipher_get_stat(alg);
 	struct crypto_alg *base = &alg->base;
 
 	if (alg->ivsize > PAGE_SIZE / 8 || alg->chunksize > PAGE_SIZE / 8 ||
@@ -790,6 +856,9 @@ static int skcipher_prepare_alg(struct skcipher_alg *alg)
 	base->cra_flags &= ~CRYPTO_ALG_TYPE_MASK;
 	base->cra_flags |= CRYPTO_ALG_TYPE_SKCIPHER;
 
+	if (IS_ENABLED(CONFIG_CRYPTO_STATS))
+		memset(istat, 0, sizeof(*istat));
+
 	return 0;
 }
 
diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index 39f5b67c3069..080d1ba3611d 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -8,6 +8,7 @@
 #ifndef _CRYPTO_SKCIPHER_H
 #define _CRYPTO_SKCIPHER_H
 
+#include <linux/atomic.h>
 #include <linux/container_of.h>
 #include <linux/crypto.h>
 #include <linux/slab.h>
@@ -48,6 +49,22 @@ struct crypto_sync_skcipher {
 	struct crypto_skcipher base;
 };
 
+/*
+ * struct crypto_istat_cipher - statistics for cipher algorithm
+ * @encrypt_cnt:	number of encrypt requests
+ * @encrypt_tlen:	total data size handled by encrypt requests
+ * @decrypt_cnt:	number of decrypt requests
+ * @decrypt_tlen:	total data size handled by decrypt requests
+ * @err_cnt:		number of error for cipher requests
+ */
+struct crypto_istat_cipher {
+	atomic64_t encrypt_cnt;
+	atomic64_t encrypt_tlen;
+	atomic64_t decrypt_cnt;
+	atomic64_t decrypt_tlen;
+	atomic64_t err_cnt;
+};
+
 /**
  * struct skcipher_alg - symmetric key cipher definition
  * @min_keysize: Minimum key size supported by the transformation. This is the
@@ -101,6 +118,7 @@ struct crypto_sync_skcipher {
  * @walksize: Equal to the chunk size except in cases where the algorithm is
  * 	      considerably more efficient if it can operate on multiple chunks
  * 	      in parallel. Should be a multiple of chunksize.
+ * @stat: Statistics for cipher algorithm
  * @base: Definition of a generic crypto algorithm.
  *
  * All fields except @ivsize are mandatory and must be filled.
@@ -119,6 +137,10 @@ struct skcipher_alg {
 	unsigned int chunksize;
 	unsigned int walksize;
 
+#ifdef CONFIG_CRYPTO_STATS
+	struct crypto_istat_cipher stat;
+#endif
+
 	struct crypto_alg base;
 };
 
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index c66f7dc21cbb..e2db56160d5c 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -276,22 +276,6 @@ struct compress_alg {
 };
 
 #ifdef CONFIG_CRYPTO_STATS
-/*
- * struct crypto_istat_cipher - statistics for cipher algorithm
- * @encrypt_cnt:	number of encrypt requests
- * @encrypt_tlen:	total data size handled by encrypt requests
- * @decrypt_cnt:	number of decrypt requests
- * @decrypt_tlen:	total data size handled by decrypt requests
- * @err_cnt:		number of error for cipher requests
- */
-struct crypto_istat_cipher {
-	atomic64_t encrypt_cnt;
-	atomic64_t encrypt_tlen;
-	atomic64_t decrypt_cnt;
-	atomic64_t decrypt_tlen;
-	atomic64_t err_cnt;
-};
-
 /*
  * struct crypto_istat_rng: statistics for RNG algorithm
  * @generate_cnt:	number of RNG generate requests
@@ -385,7 +369,6 @@ struct crypto_istat_rng {
  * @cra_destroy: internally used
  *
  * @stats: union of all possible crypto_istat_xxx structures
- * @stats.cipher:	statistics for cipher algorithm
  * @stats.rng:		statistics for rng algorithm
  *
  * The struct crypto_alg describes a generic Crypto API algorithm and is common
@@ -422,7 +405,6 @@ struct crypto_alg {
 
 #ifdef CONFIG_CRYPTO_STATS
 	union {
-		struct crypto_istat_cipher cipher;
 		struct crypto_istat_rng rng;
 	} stats;
 #endif /* CONFIG_CRYPTO_STATS */
@@ -434,8 +416,6 @@ void crypto_stats_init(struct crypto_alg *alg);
 void crypto_stats_get(struct crypto_alg *alg);
 void crypto_stats_rng_seed(struct crypto_alg *alg, int ret);
 void crypto_stats_rng_generate(struct crypto_alg *alg, unsigned int dlen, int ret);
-void crypto_stats_skcipher_encrypt(unsigned int cryptlen, int ret, struct crypto_alg *alg);
-void crypto_stats_skcipher_decrypt(unsigned int cryptlen, int ret, struct crypto_alg *alg);
 #else
 static inline void crypto_stats_init(struct crypto_alg *alg)
 {}
@@ -445,10 +425,6 @@ static inline void crypto_stats_rng_seed(struct crypto_alg *alg, int ret)
 {}
 static inline void crypto_stats_rng_generate(struct crypto_alg *alg, unsigned int dlen, int ret)
 {}
-static inline void crypto_stats_skcipher_encrypt(unsigned int cryptlen, int ret, struct crypto_alg *alg)
-{}
-static inline void crypto_stats_skcipher_decrypt(unsigned int cryptlen, int ret, struct crypto_alg *alg)
-{}
 #endif
 /*
  * A helper struct for waiting for completion of async crypto ops
