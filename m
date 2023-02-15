Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6D98C6379F
	for <linux-crypto@archiver.kernel.org>; Wed, 15 Feb 2023 09:26:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233950AbjBOJZ7 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 15 Feb 2023 04:25:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233917AbjBOJZw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 Feb 2023 04:25:52 -0500
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A172523646
        for <linux-crypto@vger.kernel.org>; Wed, 15 Feb 2023 01:25:22 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pSE2P-00BVlM-Nv; Wed, 15 Feb 2023 17:25:18 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 15 Feb 2023 17:25:17 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Wed, 15 Feb 2023 17:25:17 +0800
Subject: [PATCH 6/10] crypto: kpp - Count error stats differently
References: <Y+ykvcAIAH5Rsn7C@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Message-Id: <E1pSE2P-00BVlM-Nv@formenos.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Move all stat code specific to kpp into the kpp code.

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

 crypto/algapi.c           |   30 ------------------
 crypto/crypto_user_stat.c |   21 -------------
 crypto/kpp.c              |   42 ++++++++++++++++++++++----
 include/crypto/kpp.h      |   73 ++++++++++++++++++++++++++++++++++------------
 include/linux/crypto.h    |   25 ---------------
 5 files changed, 90 insertions(+), 101 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index fe48ce1957e1..6fcb6192a3d7 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -1051,36 +1051,6 @@ void crypto_stats_get(struct crypto_alg *alg)
 }
 EXPORT_SYMBOL_GPL(crypto_stats_get);
 
-void crypto_stats_kpp_set_secret(struct crypto_alg *alg, int ret)
-{
-	if (ret)
-		atomic64_inc(&alg->stats.kpp.err_cnt);
-	else
-		atomic64_inc(&alg->stats.kpp.setsecret_cnt);
-	crypto_alg_put(alg);
-}
-EXPORT_SYMBOL_GPL(crypto_stats_kpp_set_secret);
-
-void crypto_stats_kpp_generate_public_key(struct crypto_alg *alg, int ret)
-{
-	if (ret)
-		atomic64_inc(&alg->stats.kpp.err_cnt);
-	else
-		atomic64_inc(&alg->stats.kpp.generate_public_key_cnt);
-	crypto_alg_put(alg);
-}
-EXPORT_SYMBOL_GPL(crypto_stats_kpp_generate_public_key);
-
-void crypto_stats_kpp_compute_shared_secret(struct crypto_alg *alg, int ret)
-{
-	if (ret)
-		atomic64_inc(&alg->stats.kpp.err_cnt);
-	else
-		atomic64_inc(&alg->stats.kpp.compute_shared_secret_cnt);
-	crypto_alg_put(alg);
-}
-EXPORT_SYMBOL_GPL(crypto_stats_kpp_compute_shared_secret);
-
 void crypto_stats_rng_seed(struct crypto_alg *alg, int ret)
 {
 	if (ret && ret != -EINPROGRESS && ret != -EBUSY)
diff --git a/crypto/crypto_user_stat.c b/crypto/crypto_user_stat.c
index ad616e19a3e1..6ace8b70866f 100644
--- a/crypto/crypto_user_stat.c
+++ b/crypto/crypto_user_stat.c
@@ -13,7 +13,6 @@
 #include <net/sock.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/internal/rng.h>
-#include <crypto/kpp.h>
 #include <crypto/internal/cryptouser.h>
 
 #include "internal.h"
@@ -55,22 +54,6 @@ static int crypto_report_comp(struct sk_buff *skb, struct crypto_alg *alg)
 	return nla_put(skb, CRYPTOCFGA_STAT_COMPRESS, sizeof(rcomp), &rcomp);
 }
 
-static int crypto_report_kpp(struct sk_buff *skb, struct crypto_alg *alg)
-{
-	struct crypto_stat_kpp rkpp;
-
-	memset(&rkpp, 0, sizeof(rkpp));
-
-	strscpy(rkpp.type, "kpp", sizeof(rkpp.type));
-
-	rkpp.stat_setsecret_cnt = atomic64_read(&alg->stats.kpp.setsecret_cnt);
-	rkpp.stat_generate_public_key_cnt = atomic64_read(&alg->stats.kpp.generate_public_key_cnt);
-	rkpp.stat_compute_shared_secret_cnt = atomic64_read(&alg->stats.kpp.compute_shared_secret_cnt);
-	rkpp.stat_err_cnt = atomic64_read(&alg->stats.kpp.err_cnt);
-
-	return nla_put(skb, CRYPTOCFGA_STAT_KPP, sizeof(rkpp), &rkpp);
-}
-
 static int crypto_report_rng(struct sk_buff *skb, struct crypto_alg *alg)
 {
 	struct crypto_stat_rng rrng;
@@ -135,10 +118,6 @@ static int crypto_reportstat_one(struct crypto_alg *alg,
 		if (crypto_report_comp(skb, alg))
 			goto nla_put_failure;
 		break;
-	case CRYPTO_ALG_TYPE_KPP:
-		if (crypto_report_kpp(skb, alg))
-			goto nla_put_failure;
-		break;
 	case CRYPTO_ALG_TYPE_RNG:
 		if (crypto_report_rng(skb, alg))
 			goto nla_put_failure;
diff --git a/crypto/kpp.c b/crypto/kpp.c
index 678e871ce418..8dd2289469a6 100644
--- a/crypto/kpp.c
+++ b/crypto/kpp.c
@@ -5,19 +5,16 @@
  * Copyright (c) 2016, Intel Corporation
  * Authors: Salvatore Benedetto <salvatore.benedetto@intel.com>
  */
+
+#include <crypto/internal/kpp.h>
+#include <linux/cryptouser.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/seq_file.h>
-#include <linux/slab.h>
 #include <linux/string.h>
-#include <linux/crypto.h>
-#include <crypto/algapi.h>
-#include <linux/cryptouser.h>
-#include <linux/compiler.h>
 #include <net/netlink.h>
-#include <crypto/kpp.h>
-#include <crypto/internal/kpp.h>
+
 #include "internal.h"
 
 #ifdef CONFIG_NET
@@ -75,6 +72,30 @@ static void crypto_kpp_free_instance(struct crypto_instance *inst)
 	kpp->free(kpp);
 }
 
+static int crypto_kpp_report_stat(struct sk_buff *skb, struct crypto_alg *alg)
+	__maybe_unused;
+static int crypto_kpp_report_stat(struct sk_buff *skb, struct crypto_alg *alg)
+{
+	struct kpp_alg *kpp = __crypto_kpp_alg(alg);
+	struct crypto_istat_kpp *istat;
+	struct crypto_stat_kpp rkpp;
+
+	istat = kpp_get_stat(kpp);
+
+	memset(&rkpp, 0, sizeof(rkpp));
+
+	strscpy(rkpp.type, "kpp", sizeof(rkpp.type));
+
+	rkpp.stat_setsecret_cnt = atomic64_read(&istat->setsecret_cnt);
+	rkpp.stat_generate_public_key_cnt =
+		atomic64_read(&istat->generate_public_key_cnt);
+	rkpp.stat_compute_shared_secret_cnt =
+		atomic64_read(&istat->compute_shared_secret_cnt);
+	rkpp.stat_err_cnt = atomic64_read(&istat->err_cnt);
+
+	return nla_put(skb, CRYPTOCFGA_STAT_KPP, sizeof(rkpp), &rkpp);
+}
+
 static const struct crypto_type crypto_kpp_type = {
 	.extsize = crypto_alg_extsize,
 	.init_tfm = crypto_kpp_init_tfm,
@@ -83,6 +104,9 @@ static const struct crypto_type crypto_kpp_type = {
 	.show = crypto_kpp_show,
 #endif
 	.report = crypto_kpp_report,
+#ifdef CONFIG_CRYPTO_STATS
+	.report_stat = crypto_kpp_report_stat,
+#endif
 	.maskclear = ~CRYPTO_ALG_TYPE_MASK,
 	.maskset = CRYPTO_ALG_TYPE_MASK,
 	.type = CRYPTO_ALG_TYPE_KPP,
@@ -112,11 +136,15 @@ EXPORT_SYMBOL_GPL(crypto_has_kpp);
 
 static void kpp_prepare_alg(struct kpp_alg *alg)
 {
+	struct crypto_istat_kpp *istat = kpp_get_stat(alg);
 	struct crypto_alg *base = &alg->base;
 
 	base->cra_type = &crypto_kpp_type;
 	base->cra_flags &= ~CRYPTO_ALG_TYPE_MASK;
 	base->cra_flags |= CRYPTO_ALG_TYPE_KPP;
+
+	if (IS_ENABLED(CONFIG_CRYPTO_STATS))
+		memset(istat, 0, sizeof(*istat));
 }
 
 int crypto_register_kpp(struct kpp_alg *alg)
diff --git a/include/crypto/kpp.h b/include/crypto/kpp.h
index 33ff32878802..1988e24a0d1d 100644
--- a/include/crypto/kpp.h
+++ b/include/crypto/kpp.h
@@ -8,7 +8,11 @@
 
 #ifndef _CRYPTO_KPP_
 #define _CRYPTO_KPP_
+
+#include <linux/atomic.h>
+#include <linux/container_of.h>
 #include <linux/crypto.h>
+#include <linux/slab.h>
 
 /**
  * struct kpp_request
@@ -47,6 +51,20 @@ struct crypto_kpp {
 	struct crypto_tfm base;
 };
 
+/*
+ * struct crypto_istat_kpp - statistics for KPP algorithm
+ * @setsecret_cnt:		number of setsecrey operation
+ * @generate_public_key_cnt:	number of generate_public_key operation
+ * @compute_shared_secret_cnt:	number of compute_shared_secret operation
+ * @err_cnt:			number of error for KPP requests
+ */
+struct crypto_istat_kpp {
+	atomic64_t setsecret_cnt;
+	atomic64_t generate_public_key_cnt;
+	atomic64_t compute_shared_secret_cnt;
+	atomic64_t err_cnt;
+};
+
 /**
  * struct kpp_alg - generic key-agreement protocol primitives
  *
@@ -69,6 +87,7 @@ struct crypto_kpp {
  * @exit:		Undo everything @init did.
  *
  * @base:		Common crypto API algorithm data structure
+ * @stat:		Statistics for KPP algorithm
  */
 struct kpp_alg {
 	int (*set_secret)(struct crypto_kpp *tfm, const void *buffer,
@@ -81,6 +100,10 @@ struct kpp_alg {
 	int (*init)(struct crypto_kpp *tfm);
 	void (*exit)(struct crypto_kpp *tfm);
 
+#ifdef CONFIG_CRYPTO_STATS
+	struct crypto_istat_kpp stat;
+#endif
+
 	struct crypto_alg base;
 };
 
@@ -268,6 +291,26 @@ struct kpp_secret {
 	unsigned short len;
 };
 
+static inline struct crypto_istat_kpp *kpp_get_stat(struct kpp_alg *alg)
+{
+#ifdef CONFIG_CRYPTO_STATS
+	return &alg->stat;
+#else
+	return NULL;
+#endif
+}
+
+static inline int crypto_kpp_errstat(struct kpp_alg *alg, int err)
+{
+	if (!IS_ENABLED(CONFIG_CRYPTO_STATS))
+		return err;
+
+	if (err && err != -EINPROGRESS && err != -EBUSY)
+		atomic64_inc(&kpp_get_stat(alg)->err_cnt);
+
+	return err;
+}
+
 /**
  * crypto_kpp_set_secret() - Invoke kpp operation
  *
@@ -287,13 +330,11 @@ static inline int crypto_kpp_set_secret(struct crypto_kpp *tfm,
 					const void *buffer, unsigned int len)
 {
 	struct kpp_alg *alg = crypto_kpp_alg(tfm);
-	struct crypto_alg *calg = tfm->base.__crt_alg;
-	int ret;
 
-	crypto_stats_get(calg);
-	ret = alg->set_secret(tfm, buffer, len);
-	crypto_stats_kpp_set_secret(calg, ret);
-	return ret;
+	if (IS_ENABLED(CONFIG_CRYPTO_STATS))
+		atomic64_inc(&kpp_get_stat(alg)->setsecret_cnt);
+
+	return crypto_kpp_errstat(alg, alg->set_secret(tfm, buffer, len));
 }
 
 /**
@@ -313,13 +354,11 @@ static inline int crypto_kpp_generate_public_key(struct kpp_request *req)
 {
 	struct crypto_kpp *tfm = crypto_kpp_reqtfm(req);
 	struct kpp_alg *alg = crypto_kpp_alg(tfm);
-	struct crypto_alg *calg = tfm->base.__crt_alg;
-	int ret;
 
-	crypto_stats_get(calg);
-	ret = alg->generate_public_key(req);
-	crypto_stats_kpp_generate_public_key(calg, ret);
-	return ret;
+	if (IS_ENABLED(CONFIG_CRYPTO_STATS))
+		atomic64_inc(&kpp_get_stat(alg)->generate_public_key_cnt);
+
+	return crypto_kpp_errstat(alg, alg->generate_public_key(req));
 }
 
 /**
@@ -336,13 +375,11 @@ static inline int crypto_kpp_compute_shared_secret(struct kpp_request *req)
 {
 	struct crypto_kpp *tfm = crypto_kpp_reqtfm(req);
 	struct kpp_alg *alg = crypto_kpp_alg(tfm);
-	struct crypto_alg *calg = tfm->base.__crt_alg;
-	int ret;
 
-	crypto_stats_get(calg);
-	ret = alg->compute_shared_secret(req);
-	crypto_stats_kpp_compute_shared_secret(calg, ret);
-	return ret;
+	if (IS_ENABLED(CONFIG_CRYPTO_STATS))
+		atomic64_inc(&kpp_get_stat(alg)->compute_shared_secret_cnt);
+
+	return crypto_kpp_errstat(alg, alg->compute_shared_secret(req));
 }
 
 /**
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 42bc55b642a0..c66f7dc21cbb 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -292,20 +292,6 @@ struct crypto_istat_cipher {
 	atomic64_t err_cnt;
 };
 
-/*
- * struct crypto_istat_kpp - statistics for KPP algorithm
- * @setsecret_cnt:		number of setsecrey operation
- * @generate_public_key_cnt:	number of generate_public_key operation
- * @compute_shared_secret_cnt:	number of compute_shared_secret operation
- * @err_cnt:			number of error for KPP requests
- */
-struct crypto_istat_kpp {
-	atomic64_t setsecret_cnt;
-	atomic64_t generate_public_key_cnt;
-	atomic64_t compute_shared_secret_cnt;
-	atomic64_t err_cnt;
-};
-
 /*
  * struct crypto_istat_rng: statistics for RNG algorithm
  * @generate_cnt:	number of RNG generate requests
@@ -401,7 +387,6 @@ struct crypto_istat_rng {
  * @stats: union of all possible crypto_istat_xxx structures
  * @stats.cipher:	statistics for cipher algorithm
  * @stats.rng:		statistics for rng algorithm
- * @stats.kpp:		statistics for KPP algorithm
  *
  * The struct crypto_alg describes a generic Crypto API algorithm and is common
  * for all of the transformations. Any variable not documented here shall not
@@ -439,7 +424,6 @@ struct crypto_alg {
 	union {
 		struct crypto_istat_cipher cipher;
 		struct crypto_istat_rng rng;
-		struct crypto_istat_kpp kpp;
 	} stats;
 #endif /* CONFIG_CRYPTO_STATS */
 
@@ -448,9 +432,6 @@ struct crypto_alg {
 #ifdef CONFIG_CRYPTO_STATS
 void crypto_stats_init(struct crypto_alg *alg);
 void crypto_stats_get(struct crypto_alg *alg);
-void crypto_stats_kpp_set_secret(struct crypto_alg *alg, int ret);
-void crypto_stats_kpp_generate_public_key(struct crypto_alg *alg, int ret);
-void crypto_stats_kpp_compute_shared_secret(struct crypto_alg *alg, int ret);
 void crypto_stats_rng_seed(struct crypto_alg *alg, int ret);
 void crypto_stats_rng_generate(struct crypto_alg *alg, unsigned int dlen, int ret);
 void crypto_stats_skcipher_encrypt(unsigned int cryptlen, int ret, struct crypto_alg *alg);
@@ -460,12 +441,6 @@ static inline void crypto_stats_init(struct crypto_alg *alg)
 {}
 static inline void crypto_stats_get(struct crypto_alg *alg)
 {}
-static inline void crypto_stats_kpp_set_secret(struct crypto_alg *alg, int ret)
-{}
-static inline void crypto_stats_kpp_generate_public_key(struct crypto_alg *alg, int ret)
-{}
-static inline void crypto_stats_kpp_compute_shared_secret(struct crypto_alg *alg, int ret)
-{}
 static inline void crypto_stats_rng_seed(struct crypto_alg *alg, int ret)
 {}
 static inline void crypto_stats_rng_generate(struct crypto_alg *alg, unsigned int dlen, int ret)
