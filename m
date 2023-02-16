Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E77A9C61DA4
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Feb 2023 10:36:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbjBPKgZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Feb 2023 05:36:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbjBPKgX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Feb 2023 05:36:23 -0500
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FE441EBD9
        for <linux-crypto@vger.kernel.org>; Thu, 16 Feb 2023 02:35:56 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pSbbn-00BwJk-Q0; Thu, 16 Feb 2023 18:35:24 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 16 Feb 2023 18:35:23 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Thu, 16 Feb 2023 18:35:23 +0800
Subject: [v2 PATCH 8/10] crypto: rng - Count error stats differently
References: <Y+4GpkkLQjyv7KUt@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Message-Id: <E1pSbbn-00BwJk-Q0@formenos.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Move all stat code specific to rng into the rng code.

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

 crypto/algapi.c           |   39 ---------------------------
 crypto/crypto_user_stat.c |   33 ++++-------------------
 crypto/rng.c              |   53 +++++++++++++++++++++++++++++--------
 include/crypto/rng.h      |   65 ++++++++++++++++++++++++++++++++++++++++------
 include/linux/crypto.h    |   41 -----------------------------
 5 files changed, 105 insertions(+), 126 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 3259be84169b..9b7e263ed469 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -339,8 +339,6 @@ __crypto_register_alg(struct crypto_alg *alg, struct list_head *algs_to_put)
 
 	list_add(&alg->cra_list, &crypto_alg_list);
 
-	crypto_stats_init(alg);
-
 	if (larval) {
 		/* No cheating! */
 		alg->cra_flags &= ~CRYPTO_ALG_TESTED;
@@ -1038,43 +1036,6 @@ int crypto_type_has_alg(const char *name, const struct crypto_type *frontend,
 }
 EXPORT_SYMBOL_GPL(crypto_type_has_alg);
 
-#ifdef CONFIG_CRYPTO_STATS
-void crypto_stats_init(struct crypto_alg *alg)
-{
-	memset(&alg->stats, 0, sizeof(alg->stats));
-}
-EXPORT_SYMBOL_GPL(crypto_stats_init);
-
-void crypto_stats_get(struct crypto_alg *alg)
-{
-	crypto_alg_get(alg);
-}
-EXPORT_SYMBOL_GPL(crypto_stats_get);
-
-void crypto_stats_rng_seed(struct crypto_alg *alg, int ret)
-{
-	if (ret && ret != -EINPROGRESS && ret != -EBUSY)
-		atomic64_inc(&alg->stats.rng.err_cnt);
-	else
-		atomic64_inc(&alg->stats.rng.seed_cnt);
-	crypto_alg_put(alg);
-}
-EXPORT_SYMBOL_GPL(crypto_stats_rng_seed);
-
-void crypto_stats_rng_generate(struct crypto_alg *alg, unsigned int dlen,
-			       int ret)
-{
-	if (ret && ret != -EINPROGRESS && ret != -EBUSY) {
-		atomic64_inc(&alg->stats.rng.err_cnt);
-	} else {
-		atomic64_inc(&alg->stats.rng.generate_cnt);
-		atomic64_add(dlen, &alg->stats.rng.generate_tlen);
-	}
-	crypto_alg_put(alg);
-}
-EXPORT_SYMBOL_GPL(crypto_stats_rng_generate);
-#endif
-
 static void __init crypto_start_tests(void)
 {
 	if (IS_ENABLED(CONFIG_CRYPTO_MANAGER_DISABLE_TESTS))
diff --git a/crypto/crypto_user_stat.c b/crypto/crypto_user_stat.c
index b57e43278ee1..d4f3d39b5137 100644
--- a/crypto/crypto_user_stat.c
+++ b/crypto/crypto_user_stat.c
@@ -6,15 +6,14 @@
  *
  */
 
-#include <linux/crypto.h>
-#include <linux/cryptouser.h>
-#include <linux/sched.h>
+#include <crypto/algapi.h>
+#include <crypto/internal/cryptouser.h>
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/string.h>
 #include <net/netlink.h>
 #include <net/sock.h>
-#include <crypto/internal/rng.h>
-#include <crypto/internal/cryptouser.h>
-
-#include "internal.h"
 
 #define null_terminated(x)	(strnlen(x, sizeof(x)) < sizeof(x))
 
@@ -47,22 +46,6 @@ static int crypto_report_comp(struct sk_buff *skb, struct crypto_alg *alg)
 	return nla_put(skb, CRYPTOCFGA_STAT_COMPRESS, sizeof(rcomp), &rcomp);
 }
 
-static int crypto_report_rng(struct sk_buff *skb, struct crypto_alg *alg)
-{
-	struct crypto_stat_rng rrng;
-
-	memset(&rrng, 0, sizeof(rrng));
-
-	strscpy(rrng.type, "rng", sizeof(rrng.type));
-
-	rrng.stat_generate_cnt = atomic64_read(&alg->stats.rng.generate_cnt);
-	rrng.stat_generate_tlen = atomic64_read(&alg->stats.rng.generate_tlen);
-	rrng.stat_seed_cnt = atomic64_read(&alg->stats.rng.seed_cnt);
-	rrng.stat_err_cnt = atomic64_read(&alg->stats.rng.err_cnt);
-
-	return nla_put(skb, CRYPTOCFGA_STAT_RNG, sizeof(rrng), &rrng);
-}
-
 static int crypto_reportstat_one(struct crypto_alg *alg,
 				 struct crypto_user_alg *ualg,
 				 struct sk_buff *skb)
@@ -107,10 +90,6 @@ static int crypto_reportstat_one(struct crypto_alg *alg,
 		if (crypto_report_comp(skb, alg))
 			goto nla_put_failure;
 		break;
-	case CRYPTO_ALG_TYPE_RNG:
-		if (crypto_report_rng(skb, alg))
-			goto nla_put_failure;
-		break;
 	default:
 		pr_err("ERROR: Unhandled alg %d in %s\n",
 		       alg->cra_flags & (CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_LARVAL),
diff --git a/crypto/rng.c b/crypto/rng.c
index fea082b25fe4..ef56c71bda50 100644
--- a/crypto/rng.c
+++ b/crypto/rng.c
@@ -8,17 +8,17 @@
  * Copyright (c) 2015 Herbert Xu <herbert@gondor.apana.org.au>
  */
 
-#include <linux/atomic.h>
 #include <crypto/internal/rng.h>
+#include <linux/atomic.h>
+#include <linux/cryptouser.h>
 #include <linux/err.h>
+#include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/random.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/string.h>
-#include <linux/cryptouser.h>
-#include <linux/compiler.h>
 #include <net/netlink.h>
 
 #include "internal.h"
@@ -30,27 +30,30 @@ static int crypto_default_rng_refcnt;
 
 int crypto_rng_reset(struct crypto_rng *tfm, const u8 *seed, unsigned int slen)
 {
-	struct crypto_alg *alg = tfm->base.__crt_alg;
+	struct rng_alg *alg = crypto_rng_alg(tfm);
 	u8 *buf = NULL;
 	int err;
 
+	if (IS_ENABLED(CONFIG_CRYPTO_STATS))
+		atomic64_inc(&rng_get_stat(alg)->seed_cnt);
+
 	if (!seed && slen) {
 		buf = kmalloc(slen, GFP_KERNEL);
+		err = -ENOMEM;
 		if (!buf)
-			return -ENOMEM;
+			goto out;
 
 		err = get_random_bytes_wait(buf, slen);
 		if (err)
-			goto out;
+			goto free_buf;
 		seed = buf;
 	}
 
-	crypto_stats_get(alg);
-	err = crypto_rng_alg(tfm)->seed(tfm, seed, slen);
-	crypto_stats_rng_seed(alg, err);
-out:
+	err = alg->seed(tfm, seed, slen);
+free_buf:
 	kfree_sensitive(buf);
-	return err;
+out:
+	return crypto_rng_errstat(alg, err);
 }
 EXPORT_SYMBOL_GPL(crypto_rng_reset);
 
@@ -94,6 +97,27 @@ static void crypto_rng_show(struct seq_file *m, struct crypto_alg *alg)
 	seq_printf(m, "seedsize     : %u\n", seedsize(alg));
 }
 
+static int __maybe_unused crypto_rng_report_stat(
+	struct sk_buff *skb, struct crypto_alg *alg)
+{
+	struct rng_alg *rng = __crypto_rng_alg(alg);
+	struct crypto_istat_rng *istat;
+	struct crypto_stat_rng rrng;
+
+	istat = rng_get_stat(rng);
+
+	memset(&rrng, 0, sizeof(rrng));
+
+	strscpy(rrng.type, "rng", sizeof(rrng.type));
+
+	rrng.stat_generate_cnt = atomic64_read(&istat->generate_cnt);
+	rrng.stat_generate_tlen = atomic64_read(&istat->generate_tlen);
+	rrng.stat_seed_cnt = atomic64_read(&istat->seed_cnt);
+	rrng.stat_err_cnt = atomic64_read(&istat->err_cnt);
+
+	return nla_put(skb, CRYPTOCFGA_STAT_RNG, sizeof(rrng), &rrng);
+}
+
 static const struct crypto_type crypto_rng_type = {
 	.extsize = crypto_alg_extsize,
 	.init_tfm = crypto_rng_init_tfm,
@@ -101,6 +125,9 @@ static const struct crypto_type crypto_rng_type = {
 	.show = crypto_rng_show,
 #endif
 	.report = crypto_rng_report,
+#ifdef CONFIG_CRYPTO_STATS
+	.report_stat = crypto_rng_report_stat,
+#endif
 	.maskclear = ~CRYPTO_ALG_TYPE_MASK,
 	.maskset = CRYPTO_ALG_TYPE_MASK,
 	.type = CRYPTO_ALG_TYPE_RNG,
@@ -176,6 +203,7 @@ EXPORT_SYMBOL_GPL(crypto_del_default_rng);
 
 int crypto_register_rng(struct rng_alg *alg)
 {
+	struct crypto_istat_rng *istat = rng_get_stat(alg);
 	struct crypto_alg *base = &alg->base;
 
 	if (alg->seedsize > PAGE_SIZE / 8)
@@ -185,6 +213,9 @@ int crypto_register_rng(struct rng_alg *alg)
 	base->cra_flags &= ~CRYPTO_ALG_TYPE_MASK;
 	base->cra_flags |= CRYPTO_ALG_TYPE_RNG;
 
+	if (IS_ENABLED(CONFIG_CRYPTO_STATS))
+		memset(istat, 0, sizeof(*istat));
+
 	return crypto_register_alg(base);
 }
 EXPORT_SYMBOL_GPL(crypto_register_rng);
diff --git a/include/crypto/rng.h b/include/crypto/rng.h
index 17bb3673d3c1..6abe5102e5fb 100644
--- a/include/crypto/rng.h
+++ b/include/crypto/rng.h
@@ -9,10 +9,26 @@
 #ifndef _CRYPTO_RNG_H
 #define _CRYPTO_RNG_H
 
+#include <linux/atomic.h>
+#include <linux/container_of.h>
 #include <linux/crypto.h>
 
 struct crypto_rng;
 
+/*
+ * struct crypto_istat_rng: statistics for RNG algorithm
+ * @generate_cnt:	number of RNG generate requests
+ * @generate_tlen:	total data size of generated data by the RNG
+ * @seed_cnt:		number of times the RNG was seeded
+ * @err_cnt:		number of error for RNG requests
+ */
+struct crypto_istat_rng {
+	atomic64_t generate_cnt;
+	atomic64_t generate_tlen;
+	atomic64_t seed_cnt;
+	atomic64_t err_cnt;
+};
+
 /**
  * struct rng_alg - random number generator definition
  *
@@ -30,6 +46,7 @@ struct crypto_rng;
  *		size of the seed is defined with @seedsize .
  * @set_ent:	Set entropy that would otherwise be obtained from
  *		entropy source.  Internal use only.
+ * @stat:	Statistics for rng algorithm
  * @seedsize:	The seed size required for a random number generator
  *		initialization defined with this variable. Some
  *		random number generators does not require a seed
@@ -46,6 +63,10 @@ struct rng_alg {
 	void (*set_ent)(struct crypto_rng *tfm, const u8 *data,
 			unsigned int len);
 
+#ifdef CONFIG_CRYPTO_STATS
+	struct crypto_istat_rng stat;
+#endif
+
 	unsigned int seedsize;
 
 	struct crypto_alg base;
@@ -94,6 +115,11 @@ static inline struct crypto_tfm *crypto_rng_tfm(struct crypto_rng *tfm)
 	return &tfm->base;
 }
 
+static inline struct rng_alg *__crypto_rng_alg(struct crypto_alg *alg)
+{
+	return container_of(alg, struct rng_alg, base);
+}
+
 /**
  * crypto_rng_alg - obtain name of RNG
  * @tfm: cipher handle
@@ -104,8 +130,7 @@ static inline struct crypto_tfm *crypto_rng_tfm(struct crypto_rng *tfm)
  */
 static inline struct rng_alg *crypto_rng_alg(struct crypto_rng *tfm)
 {
-	return container_of(crypto_rng_tfm(tfm)->__crt_alg,
-			    struct rng_alg, base);
+	return __crypto_rng_alg(crypto_rng_tfm(tfm)->__crt_alg);
 }
 
 /**
@@ -119,6 +144,26 @@ static inline void crypto_free_rng(struct crypto_rng *tfm)
 	crypto_destroy_tfm(tfm, crypto_rng_tfm(tfm));
 }
 
+static inline struct crypto_istat_rng *rng_get_stat(struct rng_alg *alg)
+{
+#ifdef CONFIG_CRYPTO_STATS
+	return &alg->stat;
+#else
+	return NULL;
+#endif
+}
+
+static inline int crypto_rng_errstat(struct rng_alg *alg, int err)
+{
+	if (!IS_ENABLED(CONFIG_CRYPTO_STATS))
+		return err;
+
+	if (err && err != -EINPROGRESS && err != -EBUSY)
+		atomic64_inc(&rng_get_stat(alg)->err_cnt);
+
+	return err;
+}
+
 /**
  * crypto_rng_generate() - get random number
  * @tfm: cipher handle
@@ -137,13 +182,17 @@ static inline int crypto_rng_generate(struct crypto_rng *tfm,
 				      const u8 *src, unsigned int slen,
 				      u8 *dst, unsigned int dlen)
 {
-	struct crypto_alg *alg = tfm->base.__crt_alg;
-	int ret;
+	struct rng_alg *alg = crypto_rng_alg(tfm);
+
+	if (IS_ENABLED(CONFIG_CRYPTO_STATS)) {
+		struct crypto_istat_rng *istat = rng_get_stat(alg);
+
+		atomic64_inc(&istat->generate_cnt);
+		atomic64_add(dlen, &istat->generate_tlen);
+	}
 
-	crypto_stats_get(alg);
-	ret = crypto_rng_alg(tfm)->generate(tfm, src, slen, dst, dlen);
-	crypto_stats_rng_generate(alg, dlen, ret);
-	return ret;
+	return crypto_rng_errstat(alg,
+				  alg->generate(tfm, src, slen, dst, dlen));
 }
 
 /**
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index e2db56160d5c..c26e59bb7bca 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -275,22 +275,6 @@ struct compress_alg {
 			      unsigned int slen, u8 *dst, unsigned int *dlen);
 };
 
-#ifdef CONFIG_CRYPTO_STATS
-/*
- * struct crypto_istat_rng: statistics for RNG algorithm
- * @generate_cnt:	number of RNG generate requests
- * @generate_tlen:	total data size of generated data by the RNG
- * @seed_cnt:		number of times the RNG was seeded
- * @err_cnt:		number of error for RNG requests
- */
-struct crypto_istat_rng {
-	atomic64_t generate_cnt;
-	atomic64_t generate_tlen;
-	atomic64_t seed_cnt;
-	atomic64_t err_cnt;
-};
-#endif /* CONFIG_CRYPTO_STATS */
-
 #define cra_cipher	cra_u.cipher
 #define cra_compress	cra_u.compress
 
@@ -368,9 +352,6 @@ struct crypto_istat_rng {
  * @cra_refcnt: internally used
  * @cra_destroy: internally used
  *
- * @stats: union of all possible crypto_istat_xxx structures
- * @stats.rng:		statistics for rng algorithm
- *
  * The struct crypto_alg describes a generic Crypto API algorithm and is common
  * for all of the transformations. Any variable not documented here shall not
  * be used by a cipher implementation as it is internal to the Crypto API.
@@ -402,30 +383,8 @@ struct crypto_alg {
 	void (*cra_destroy)(struct crypto_alg *alg);
 	
 	struct module *cra_module;
-
-#ifdef CONFIG_CRYPTO_STATS
-	union {
-		struct crypto_istat_rng rng;
-	} stats;
-#endif /* CONFIG_CRYPTO_STATS */
-
 } CRYPTO_MINALIGN_ATTR;
 
-#ifdef CONFIG_CRYPTO_STATS
-void crypto_stats_init(struct crypto_alg *alg);
-void crypto_stats_get(struct crypto_alg *alg);
-void crypto_stats_rng_seed(struct crypto_alg *alg, int ret);
-void crypto_stats_rng_generate(struct crypto_alg *alg, unsigned int dlen, int ret);
-#else
-static inline void crypto_stats_init(struct crypto_alg *alg)
-{}
-static inline void crypto_stats_get(struct crypto_alg *alg)
-{}
-static inline void crypto_stats_rng_seed(struct crypto_alg *alg, int ret)
-{}
-static inline void crypto_stats_rng_generate(struct crypto_alg *alg, unsigned int dlen, int ret)
-{}
-#endif
 /*
  * A helper struct for waiting for completion of async crypto ops
  */
