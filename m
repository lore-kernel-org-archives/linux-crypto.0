Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38689C636D4
	for <linux-crypto@archiver.kernel.org>; Wed, 15 Feb 2023 09:25:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233939AbjBOJZ6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 15 Feb 2023 04:25:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233915AbjBOJZv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 Feb 2023 04:25:51 -0500
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75EAC37559
        for <linux-crypto@vger.kernel.org>; Wed, 15 Feb 2023 01:25:16 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pSE2J-00BVkj-B0; Wed, 15 Feb 2023 17:25:12 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 15 Feb 2023 17:25:11 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Wed, 15 Feb 2023 17:25:11 +0800
Subject: [PATCH 3/10] crypto: akcipher - Count error stats differently
References: <Y+ykvcAIAH5Rsn7C@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Message-Id: <E1pSE2J-00BVkj-B0@formenos.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Move all stat code specific to akcipher into the akcipher code.

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

 crypto/akcipher.c         |   43 ++++++++++++++++---
 crypto/algapi.c           |   46 --------------------
 crypto/crypto_user_stat.c |   24 ----------
 include/crypto/akcipher.h |  102 +++++++++++++++++++++++++++++++++-------------
 include/linux/crypto.h    |   34 ---------------
 5 files changed, 111 insertions(+), 138 deletions(-)

diff --git a/crypto/akcipher.c b/crypto/akcipher.c
index ab975a420e1e..d298baf9f312 100644
--- a/crypto/akcipher.c
+++ b/crypto/akcipher.c
@@ -5,19 +5,16 @@
  * Copyright (c) 2015, Intel Corporation
  * Authors: Tadeusz Struk <tadeusz.struk@intel.com>
  */
+#include <crypto/internal/akcipher.h>
+#include <linux/cryptouser.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/string.h>
-#include <linux/crypto.h>
-#include <linux/compiler.h>
-#include <crypto/algapi.h>
-#include <linux/cryptouser.h>
 #include <net/netlink.h>
-#include <crypto/akcipher.h>
-#include <crypto/internal/akcipher.h>
+
 #include "internal.h"
 
 #ifdef CONFIG_NET
@@ -76,6 +73,33 @@ static void crypto_akcipher_free_instance(struct crypto_instance *inst)
 	akcipher->free(akcipher);
 }
 
+static int crypto_akcipher_report_stat(struct sk_buff *skb,
+				       struct crypto_alg *alg)
+	__maybe_unused;
+static int crypto_akcipher_report_stat(struct sk_buff *skb,
+				       struct crypto_alg *alg)
+{
+	struct akcipher_alg *akcipher = __crypto_akcipher_alg(alg);
+	struct crypto_istat_akcipher *istat;
+	struct crypto_stat_akcipher rakcipher;
+
+	istat = akcipher_get_stat(akcipher);
+
+	memset(&rakcipher, 0, sizeof(rakcipher));
+
+	strscpy(rakcipher.type, "akcipher", sizeof(rakcipher.type));
+	rakcipher.stat_encrypt_cnt = atomic64_read(&istat->encrypt_cnt);
+	rakcipher.stat_encrypt_tlen = atomic64_read(&istat->encrypt_tlen);
+	rakcipher.stat_decrypt_cnt = atomic64_read(&istat->decrypt_cnt);
+	rakcipher.stat_decrypt_tlen = atomic64_read(&istat->decrypt_tlen);
+	rakcipher.stat_sign_cnt = atomic64_read(&istat->sign_cnt);
+	rakcipher.stat_verify_cnt = atomic64_read(&istat->verify_cnt);
+	rakcipher.stat_err_cnt = atomic64_read(&istat->err_cnt);
+
+	return nla_put(skb, CRYPTOCFGA_STAT_AKCIPHER,
+		       sizeof(rakcipher), &rakcipher);
+}
+
 static const struct crypto_type crypto_akcipher_type = {
 	.extsize = crypto_alg_extsize,
 	.init_tfm = crypto_akcipher_init_tfm,
@@ -84,6 +108,9 @@ static const struct crypto_type crypto_akcipher_type = {
 	.show = crypto_akcipher_show,
 #endif
 	.report = crypto_akcipher_report,
+#ifdef CONFIG_CRYPTO_STATS
+	.report_stat = crypto_akcipher_report_stat,
+#endif
 	.maskclear = ~CRYPTO_ALG_TYPE_MASK,
 	.maskset = CRYPTO_ALG_TYPE_MASK,
 	.type = CRYPTO_ALG_TYPE_AKCIPHER,
@@ -108,11 +135,15 @@ EXPORT_SYMBOL_GPL(crypto_alloc_akcipher);
 
 static void akcipher_prepare_alg(struct akcipher_alg *alg)
 {
+	struct crypto_istat_akcipher *istat = akcipher_get_stat(alg);
 	struct crypto_alg *base = &alg->base;
 
 	base->cra_type = &crypto_akcipher_type;
 	base->cra_flags &= ~CRYPTO_ALG_TYPE_MASK;
 	base->cra_flags |= CRYPTO_ALG_TYPE_AKCIPHER;
+
+	if (IS_ENABLED(CONFIG_CRYPTO_STATS))
+		memset(istat, 0, sizeof(*istat));
 }
 
 static int akcipher_default_op(struct akcipher_request *req)
diff --git a/crypto/algapi.c b/crypto/algapi.c
index f7f7c61d456a..33dc82ffe20a 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -1051,52 +1051,6 @@ void crypto_stats_get(struct crypto_alg *alg)
 }
 EXPORT_SYMBOL_GPL(crypto_stats_get);
 
-void crypto_stats_akcipher_encrypt(unsigned int src_len, int ret,
-				   struct crypto_alg *alg)
-{
-	if (ret && ret != -EINPROGRESS && ret != -EBUSY) {
-		atomic64_inc(&alg->stats.akcipher.err_cnt);
-	} else {
-		atomic64_inc(&alg->stats.akcipher.encrypt_cnt);
-		atomic64_add(src_len, &alg->stats.akcipher.encrypt_tlen);
-	}
-	crypto_alg_put(alg);
-}
-EXPORT_SYMBOL_GPL(crypto_stats_akcipher_encrypt);
-
-void crypto_stats_akcipher_decrypt(unsigned int src_len, int ret,
-				   struct crypto_alg *alg)
-{
-	if (ret && ret != -EINPROGRESS && ret != -EBUSY) {
-		atomic64_inc(&alg->stats.akcipher.err_cnt);
-	} else {
-		atomic64_inc(&alg->stats.akcipher.decrypt_cnt);
-		atomic64_add(src_len, &alg->stats.akcipher.decrypt_tlen);
-	}
-	crypto_alg_put(alg);
-}
-EXPORT_SYMBOL_GPL(crypto_stats_akcipher_decrypt);
-
-void crypto_stats_akcipher_sign(int ret, struct crypto_alg *alg)
-{
-	if (ret && ret != -EINPROGRESS && ret != -EBUSY)
-		atomic64_inc(&alg->stats.akcipher.err_cnt);
-	else
-		atomic64_inc(&alg->stats.akcipher.sign_cnt);
-	crypto_alg_put(alg);
-}
-EXPORT_SYMBOL_GPL(crypto_stats_akcipher_sign);
-
-void crypto_stats_akcipher_verify(int ret, struct crypto_alg *alg)
-{
-	if (ret && ret != -EINPROGRESS && ret != -EBUSY)
-		atomic64_inc(&alg->stats.akcipher.err_cnt);
-	else
-		atomic64_inc(&alg->stats.akcipher.verify_cnt);
-	crypto_alg_put(alg);
-}
-EXPORT_SYMBOL_GPL(crypto_stats_akcipher_verify);
-
 void crypto_stats_compress(unsigned int slen, int ret, struct crypto_alg *alg)
 {
 	if (ret && ret != -EINPROGRESS && ret != -EBUSY) {
diff --git a/crypto/crypto_user_stat.c b/crypto/crypto_user_stat.c
index 50ec076507a1..7a5a2591c95f 100644
--- a/crypto/crypto_user_stat.c
+++ b/crypto/crypto_user_stat.c
@@ -13,7 +13,6 @@
 #include <net/sock.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/internal/rng.h>
-#include <crypto/akcipher.h>
 #include <crypto/kpp.h>
 #include <crypto/internal/cryptouser.h>
 
@@ -77,25 +76,6 @@ static int crypto_report_acomp(struct sk_buff *skb, struct crypto_alg *alg)
 	return nla_put(skb, CRYPTOCFGA_STAT_ACOMP, sizeof(racomp), &racomp);
 }
 
-static int crypto_report_akcipher(struct sk_buff *skb, struct crypto_alg *alg)
-{
-	struct crypto_stat_akcipher rakcipher;
-
-	memset(&rakcipher, 0, sizeof(rakcipher));
-
-	strscpy(rakcipher.type, "akcipher", sizeof(rakcipher.type));
-	rakcipher.stat_encrypt_cnt = atomic64_read(&alg->stats.akcipher.encrypt_cnt);
-	rakcipher.stat_encrypt_tlen = atomic64_read(&alg->stats.akcipher.encrypt_tlen);
-	rakcipher.stat_decrypt_cnt = atomic64_read(&alg->stats.akcipher.decrypt_cnt);
-	rakcipher.stat_decrypt_tlen = atomic64_read(&alg->stats.akcipher.decrypt_tlen);
-	rakcipher.stat_sign_cnt = atomic64_read(&alg->stats.akcipher.sign_cnt);
-	rakcipher.stat_verify_cnt = atomic64_read(&alg->stats.akcipher.verify_cnt);
-	rakcipher.stat_err_cnt = atomic64_read(&alg->stats.akcipher.err_cnt);
-
-	return nla_put(skb, CRYPTOCFGA_STAT_AKCIPHER,
-		       sizeof(rakcipher), &rakcipher);
-}
-
 static int crypto_report_kpp(struct sk_buff *skb, struct crypto_alg *alg)
 {
 	struct crypto_stat_kpp rkpp;
@@ -214,10 +194,6 @@ static int crypto_reportstat_one(struct crypto_alg *alg,
 		if (crypto_report_acomp(skb, alg))
 			goto nla_put_failure;
 		break;
-	case CRYPTO_ALG_TYPE_AKCIPHER:
-		if (crypto_report_akcipher(skb, alg))
-			goto nla_put_failure;
-		break;
 	case CRYPTO_ALG_TYPE_KPP:
 		if (crypto_report_kpp(skb, alg))
 			goto nla_put_failure;
diff --git a/include/crypto/akcipher.h b/include/crypto/akcipher.h
index 734c213918bd..f35fd653e4e5 100644
--- a/include/crypto/akcipher.h
+++ b/include/crypto/akcipher.h
@@ -7,6 +7,8 @@
  */
 #ifndef _CRYPTO_AKCIPHER_H
 #define _CRYPTO_AKCIPHER_H
+
+#include <linux/atomic.h>
 #include <linux/crypto.h>
 
 /**
@@ -52,6 +54,26 @@ struct crypto_akcipher {
 	struct crypto_tfm base;
 };
 
+/*
+ * struct crypto_istat_akcipher - statistics for akcipher algorithm
+ * @encrypt_cnt:	number of encrypt requests
+ * @encrypt_tlen:	total data size handled by encrypt requests
+ * @decrypt_cnt:	number of decrypt requests
+ * @decrypt_tlen:	total data size handled by decrypt requests
+ * @verify_cnt:		number of verify operation
+ * @sign_cnt:		number of sign requests
+ * @err_cnt:		number of error for akcipher requests
+ */
+struct crypto_istat_akcipher {
+	atomic64_t encrypt_cnt;
+	atomic64_t encrypt_tlen;
+	atomic64_t decrypt_cnt;
+	atomic64_t decrypt_tlen;
+	atomic64_t verify_cnt;
+	atomic64_t sign_cnt;
+	atomic64_t err_cnt;
+};
+
 /**
  * struct akcipher_alg - generic public key algorithm
  *
@@ -88,6 +110,7 @@ struct crypto_akcipher {
  * @exit:	Deinitialize the cryptographic transformation object. This is a
  *		counterpart to @init, used to remove various changes set in
  *		@init.
+ * @stat:	Statistics for akcipher algorithm
  *
  * @base:	Common crypto API algorithm data structure
  */
@@ -104,6 +127,10 @@ struct akcipher_alg {
 	int (*init)(struct crypto_akcipher *tfm);
 	void (*exit)(struct crypto_akcipher *tfm);
 
+#ifdef CONFIG_CRYPTO_STATS
+	struct crypto_istat_akcipher stat;
+#endif
+
 	struct crypto_alg base;
 };
 
@@ -275,6 +302,27 @@ static inline unsigned int crypto_akcipher_maxsize(struct crypto_akcipher *tfm)
 	return alg->max_size(tfm);
 }
 
+static inline struct crypto_istat_akcipher *akcipher_get_stat(
+	struct akcipher_alg *alg)
+{
+#ifdef CONFIG_CRYPTO_STATS
+	return &alg->stat;
+#else
+	return NULL;
+#endif
+}
+
+static inline int crypto_akcipher_errstat(struct akcipher_alg *alg, int err)
+{
+	if (!IS_ENABLED(CONFIG_CRYPTO_STATS))
+		return err;
+
+	if (err && err != -EINPROGRESS && err != -EBUSY)
+		atomic64_inc(&akcipher_get_stat(alg)->err_cnt);
+
+	return err;
+}
+
 /**
  * crypto_akcipher_encrypt() - Invoke public key encrypt operation
  *
@@ -289,14 +337,15 @@ static inline int crypto_akcipher_encrypt(struct akcipher_request *req)
 {
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
 	struct akcipher_alg *alg = crypto_akcipher_alg(tfm);
-	struct crypto_alg *calg = tfm->base.__crt_alg;
-	unsigned int src_len = req->src_len;
-	int ret;
-
-	crypto_stats_get(calg);
-	ret = alg->encrypt(req);
-	crypto_stats_akcipher_encrypt(src_len, ret, calg);
-	return ret;
+
+	if (IS_ENABLED(CONFIG_CRYPTO_STATS)) {
+		struct crypto_istat_akcipher *istat = akcipher_get_stat(alg);
+
+		atomic64_inc(&istat->encrypt_cnt);
+		atomic64_add(req->src_len, &istat->encrypt_tlen);
+	}
+
+	return crypto_akcipher_errstat(alg, alg->encrypt(req));
 }
 
 /**
@@ -313,14 +362,15 @@ static inline int crypto_akcipher_decrypt(struct akcipher_request *req)
 {
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
 	struct akcipher_alg *alg = crypto_akcipher_alg(tfm);
-	struct crypto_alg *calg = tfm->base.__crt_alg;
-	unsigned int src_len = req->src_len;
-	int ret;
-
-	crypto_stats_get(calg);
-	ret = alg->decrypt(req);
-	crypto_stats_akcipher_decrypt(src_len, ret, calg);
-	return ret;
+
+	if (IS_ENABLED(CONFIG_CRYPTO_STATS)) {
+		struct crypto_istat_akcipher *istat = akcipher_get_stat(alg);
+
+		atomic64_inc(&istat->decrypt_cnt);
+		atomic64_add(req->src_len, &istat->decrypt_tlen);
+	}
+
+	return crypto_akcipher_errstat(alg, alg->decrypt(req));
 }
 
 /**
@@ -337,13 +387,11 @@ static inline int crypto_akcipher_sign(struct akcipher_request *req)
 {
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
 	struct akcipher_alg *alg = crypto_akcipher_alg(tfm);
-	struct crypto_alg *calg = tfm->base.__crt_alg;
-	int ret;
 
-	crypto_stats_get(calg);
-	ret = alg->sign(req);
-	crypto_stats_akcipher_sign(ret, calg);
-	return ret;
+	if (IS_ENABLED(CONFIG_CRYPTO_STATS))
+		atomic64_inc(&akcipher_get_stat(alg)->sign_cnt);
+
+	return crypto_akcipher_errstat(alg, alg->sign(req));
 }
 
 /**
@@ -364,13 +412,11 @@ static inline int crypto_akcipher_verify(struct akcipher_request *req)
 {
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
 	struct akcipher_alg *alg = crypto_akcipher_alg(tfm);
-	struct crypto_alg *calg = tfm->base.__crt_alg;
-	int ret;
 
-	crypto_stats_get(calg);
-	ret = alg->verify(req);
-	crypto_stats_akcipher_verify(ret, calg);
-	return ret;
+	if (IS_ENABLED(CONFIG_CRYPTO_STATS))
+		atomic64_inc(&akcipher_get_stat(alg)->verify_cnt);
+
+	return crypto_akcipher_errstat(alg, alg->verify(req));
 }
 
 /**
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 9eb6fc8ab69c..778cc05f76a8 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -276,26 +276,6 @@ struct compress_alg {
 };
 
 #ifdef CONFIG_CRYPTO_STATS
-/*
- * struct crypto_istat_akcipher - statistics for akcipher algorithm
- * @encrypt_cnt:	number of encrypt requests
- * @encrypt_tlen:	total data size handled by encrypt requests
- * @decrypt_cnt:	number of decrypt requests
- * @decrypt_tlen:	total data size handled by decrypt requests
- * @verify_cnt:		number of verify operation
- * @sign_cnt:		number of sign requests
- * @err_cnt:		number of error for akcipher requests
- */
-struct crypto_istat_akcipher {
-	atomic64_t encrypt_cnt;
-	atomic64_t encrypt_tlen;
-	atomic64_t decrypt_cnt;
-	atomic64_t decrypt_tlen;
-	atomic64_t verify_cnt;
-	atomic64_t sign_cnt;
-	atomic64_t err_cnt;
-};
-
 /*
  * struct crypto_istat_cipher - statistics for cipher algorithm
  * @encrypt_cnt:	number of encrypt requests
@@ -447,7 +427,6 @@ struct crypto_istat_rng {
  * @cra_destroy: internally used
  *
  * @stats: union of all possible crypto_istat_xxx structures
- * @stats.akcipher:	statistics for akcipher algorithm
  * @stats.cipher:	statistics for cipher algorithm
  * @stats.compress:	statistics for compress algorithm
  * @stats.hash:		statistics for hash algorithm
@@ -488,7 +467,6 @@ struct crypto_alg {
 
 #ifdef CONFIG_CRYPTO_STATS
 	union {
-		struct crypto_istat_akcipher akcipher;
 		struct crypto_istat_cipher cipher;
 		struct crypto_istat_compress compress;
 		struct crypto_istat_hash hash;
@@ -504,10 +482,6 @@ void crypto_stats_init(struct crypto_alg *alg);
 void crypto_stats_get(struct crypto_alg *alg);
 void crypto_stats_ahash_update(unsigned int nbytes, int ret, struct crypto_alg *alg);
 void crypto_stats_ahash_final(unsigned int nbytes, int ret, struct crypto_alg *alg);
-void crypto_stats_akcipher_encrypt(unsigned int src_len, int ret, struct crypto_alg *alg);
-void crypto_stats_akcipher_decrypt(unsigned int src_len, int ret, struct crypto_alg *alg);
-void crypto_stats_akcipher_sign(int ret, struct crypto_alg *alg);
-void crypto_stats_akcipher_verify(int ret, struct crypto_alg *alg);
 void crypto_stats_compress(unsigned int slen, int ret, struct crypto_alg *alg);
 void crypto_stats_decompress(unsigned int slen, int ret, struct crypto_alg *alg);
 void crypto_stats_kpp_set_secret(struct crypto_alg *alg, int ret);
@@ -526,14 +500,6 @@ static inline void crypto_stats_ahash_update(unsigned int nbytes, int ret, struc
 {}
 static inline void crypto_stats_ahash_final(unsigned int nbytes, int ret, struct crypto_alg *alg)
 {}
-static inline void crypto_stats_akcipher_encrypt(unsigned int src_len, int ret, struct crypto_alg *alg)
-{}
-static inline void crypto_stats_akcipher_decrypt(unsigned int src_len, int ret, struct crypto_alg *alg)
-{}
-static inline void crypto_stats_akcipher_sign(int ret, struct crypto_alg *alg)
-{}
-static inline void crypto_stats_akcipher_verify(int ret, struct crypto_alg *alg)
-{}
 static inline void crypto_stats_compress(unsigned int slen, int ret, struct crypto_alg *alg)
 {}
 static inline void crypto_stats_decompress(unsigned int slen, int ret, struct crypto_alg *alg)
