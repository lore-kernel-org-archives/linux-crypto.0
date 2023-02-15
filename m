Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEF0EC636CC
	for <linux-crypto@archiver.kernel.org>; Wed, 15 Feb 2023 09:25:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233899AbjBOJZ6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 15 Feb 2023 04:25:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233885AbjBOJZw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 Feb 2023 04:25:52 -0500
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68AA027996
        for <linux-crypto@vger.kernel.org>; Wed, 15 Feb 2023 01:25:18 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pSE2L-00BVkw-GI; Wed, 15 Feb 2023 17:25:14 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 15 Feb 2023 17:25:13 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Wed, 15 Feb 2023 17:25:13 +0800
Subject: [PATCH 4/10] crypto: hash - Count error stats differently
References: <Y+ykvcAIAH5Rsn7C@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Message-Id: <E1pSE2L-00BVkw-GI@formenos.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Move all stat code specific to hash into the hash code.

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

 crypto/ahash.c            |   82 +++++++++++++++++------------
 crypto/algapi.c           |   24 --------
 crypto/crypto_user_stat.c |   38 -------------
 crypto/hash.h             |   37 +++++++++++++
 crypto/shash.c            |  128 ++++++++++++++++++++++++++++++++++++----------
 include/crypto/hash.h     |   85 +++++++++++++++++++++++-------
 include/linux/crypto.h    |   20 -------
 7 files changed, 250 insertions(+), 164 deletions(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index ff8c79d975c1..3030caf8b1af 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -8,19 +8,18 @@
  * Copyright (c) 2008 Loc Ho <lho@amcc.com>
  */
 
-#include <crypto/internal/hash.h>
 #include <crypto/scatterwalk.h>
+#include <linux/cryptouser.h>
 #include <linux/err.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/seq_file.h>
-#include <linux/cryptouser.h>
-#include <linux/compiler.h>
+#include <linux/string.h>
 #include <net/netlink.h>
 
-#include "internal.h"
+#include "hash.h"
 
 static const struct crypto_type crypto_ahash_type;
 
@@ -296,55 +295,60 @@ static int crypto_ahash_op(struct ahash_request *req,
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	unsigned long alignmask = crypto_ahash_alignmask(tfm);
+	int err;
 
 	if ((unsigned long)req->result & alignmask)
-		return ahash_op_unaligned(req, op, has_state);
+		err = ahash_op_unaligned(req, op, has_state);
+	else
+		err = op(req);
 
-	return op(req);
+	return crypto_hash_errstat(crypto_hash_alg_common(tfm), err);
 }
 
 int crypto_ahash_final(struct ahash_request *req)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct crypto_alg *alg = tfm->base.__crt_alg;
-	unsigned int nbytes = req->nbytes;
-	int ret;
+	struct hash_alg_common *alg = crypto_hash_alg_common(tfm);
 
-	crypto_stats_get(alg);
-	ret = crypto_ahash_op(req, crypto_ahash_reqtfm(req)->final, true);
-	crypto_stats_ahash_final(nbytes, ret, alg);
-	return ret;
+	if (IS_ENABLED(CONFIG_CRYPTO_STATS))
+		atomic64_inc(&hash_get_stat(alg)->hash_cnt);
+
+	return crypto_ahash_op(req, tfm->final, true);
 }
 EXPORT_SYMBOL_GPL(crypto_ahash_final);
 
 int crypto_ahash_finup(struct ahash_request *req)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct crypto_alg *alg = tfm->base.__crt_alg;
-	unsigned int nbytes = req->nbytes;
-	int ret;
+	struct hash_alg_common *alg = crypto_hash_alg_common(tfm);
 
-	crypto_stats_get(alg);
-	ret = crypto_ahash_op(req, crypto_ahash_reqtfm(req)->finup, true);
-	crypto_stats_ahash_final(nbytes, ret, alg);
-	return ret;
+	if (IS_ENABLED(CONFIG_CRYPTO_STATS)) {
+		struct crypto_istat_hash *istat = hash_get_stat(alg);
+
+		atomic64_inc(&istat->hash_cnt);
+		atomic64_add(req->nbytes, &istat->hash_tlen);
+	}
+
+	return crypto_ahash_op(req, tfm->finup, true);
 }
 EXPORT_SYMBOL_GPL(crypto_ahash_finup);
 
 int crypto_ahash_digest(struct ahash_request *req)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct crypto_alg *alg = tfm->base.__crt_alg;
-	unsigned int nbytes = req->nbytes;
-	int ret;
+	struct hash_alg_common *alg = crypto_hash_alg_common(tfm);
+
+	if (IS_ENABLED(CONFIG_CRYPTO_STATS)) {
+		struct crypto_istat_hash *istat = hash_get_stat(alg);
+
+		atomic64_inc(&istat->hash_cnt);
+		atomic64_add(req->nbytes, &istat->hash_tlen);
+	}
 
-	crypto_stats_get(alg);
 	if (crypto_ahash_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
-		ret = -ENOKEY;
-	else
-		ret = crypto_ahash_op(req, tfm->digest, false);
-	crypto_stats_ahash_final(nbytes, ret, alg);
-	return ret;
+		return crypto_hash_errstat(alg, -ENOKEY);
+
+	return crypto_ahash_op(req, tfm->digest, false);
 }
 EXPORT_SYMBOL_GPL(crypto_ahash_digest);
 
@@ -498,6 +502,14 @@ static void crypto_ahash_show(struct seq_file *m, struct crypto_alg *alg)
 		   __crypto_hash_alg_common(alg)->digestsize);
 }
 
+static int crypto_ahash_report_stat(struct sk_buff *skb,
+				    struct crypto_alg *alg) __maybe_unused;
+static int crypto_ahash_report_stat(struct sk_buff *skb,
+				    struct crypto_alg *alg)
+{
+	return crypto_hash_report_stat(skb, alg, "ahash");
+}
+
 static const struct crypto_type crypto_ahash_type = {
 	.extsize = crypto_ahash_extsize,
 	.init_tfm = crypto_ahash_init_tfm,
@@ -506,6 +518,9 @@ static const struct crypto_type crypto_ahash_type = {
 	.show = crypto_ahash_show,
 #endif
 	.report = crypto_ahash_report,
+#ifdef CONFIG_CRYPTO_STATS
+	.report_stat = crypto_ahash_report_stat,
+#endif
 	.maskclear = ~CRYPTO_ALG_TYPE_MASK,
 	.maskset = CRYPTO_ALG_TYPE_AHASH_MASK,
 	.type = CRYPTO_ALG_TYPE_AHASH,
@@ -537,14 +552,13 @@ EXPORT_SYMBOL_GPL(crypto_has_ahash);
 static int ahash_prepare_alg(struct ahash_alg *alg)
 {
 	struct crypto_alg *base = &alg->halg.base;
+	int err;
 
-	if (alg->halg.digestsize > HASH_MAX_DIGESTSIZE ||
-	    alg->halg.statesize > HASH_MAX_STATESIZE ||
-	    alg->halg.statesize == 0)
-		return -EINVAL;
+	err = hash_prepare_alg(&alg->halg);
+	if (err)
+		return err;
 
 	base->cra_type = &crypto_ahash_type;
-	base->cra_flags &= ~CRYPTO_ALG_TYPE_MASK;
 	base->cra_flags |= CRYPTO_ALG_TYPE_AHASH;
 
 	return 0;
diff --git a/crypto/algapi.c b/crypto/algapi.c
index 33dc82ffe20a..deabd2d42216 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -1075,30 +1075,6 @@ void crypto_stats_decompress(unsigned int slen, int ret, struct crypto_alg *alg)
 }
 EXPORT_SYMBOL_GPL(crypto_stats_decompress);
 
-void crypto_stats_ahash_update(unsigned int nbytes, int ret,
-			       struct crypto_alg *alg)
-{
-	if (ret && ret != -EINPROGRESS && ret != -EBUSY)
-		atomic64_inc(&alg->stats.hash.err_cnt);
-	else
-		atomic64_add(nbytes, &alg->stats.hash.hash_tlen);
-	crypto_alg_put(alg);
-}
-EXPORT_SYMBOL_GPL(crypto_stats_ahash_update);
-
-void crypto_stats_ahash_final(unsigned int nbytes, int ret,
-			      struct crypto_alg *alg)
-{
-	if (ret && ret != -EINPROGRESS && ret != -EBUSY) {
-		atomic64_inc(&alg->stats.hash.err_cnt);
-	} else {
-		atomic64_inc(&alg->stats.hash.hash_cnt);
-		atomic64_add(nbytes, &alg->stats.hash.hash_tlen);
-	}
-	crypto_alg_put(alg);
-}
-EXPORT_SYMBOL_GPL(crypto_stats_ahash_final);
-
 void crypto_stats_kpp_set_secret(struct crypto_alg *alg, int ret)
 {
 	if (ret)
diff --git a/crypto/crypto_user_stat.c b/crypto/crypto_user_stat.c
index 7a5a2591c95f..d65f10f71f11 100644
--- a/crypto/crypto_user_stat.c
+++ b/crypto/crypto_user_stat.c
@@ -92,36 +92,6 @@ static int crypto_report_kpp(struct sk_buff *skb, struct crypto_alg *alg)
 	return nla_put(skb, CRYPTOCFGA_STAT_KPP, sizeof(rkpp), &rkpp);
 }
 
-static int crypto_report_ahash(struct sk_buff *skb, struct crypto_alg *alg)
-{
-	struct crypto_stat_hash rhash;
-
-	memset(&rhash, 0, sizeof(rhash));
-
-	strscpy(rhash.type, "ahash", sizeof(rhash.type));
-
-	rhash.stat_hash_cnt = atomic64_read(&alg->stats.hash.hash_cnt);
-	rhash.stat_hash_tlen = atomic64_read(&alg->stats.hash.hash_tlen);
-	rhash.stat_err_cnt = atomic64_read(&alg->stats.hash.err_cnt);
-
-	return nla_put(skb, CRYPTOCFGA_STAT_HASH, sizeof(rhash), &rhash);
-}
-
-static int crypto_report_shash(struct sk_buff *skb, struct crypto_alg *alg)
-{
-	struct crypto_stat_hash rhash;
-
-	memset(&rhash, 0, sizeof(rhash));
-
-	strscpy(rhash.type, "shash", sizeof(rhash.type));
-
-	rhash.stat_hash_cnt =  atomic64_read(&alg->stats.hash.hash_cnt);
-	rhash.stat_hash_tlen = atomic64_read(&alg->stats.hash.hash_tlen);
-	rhash.stat_err_cnt = atomic64_read(&alg->stats.hash.err_cnt);
-
-	return nla_put(skb, CRYPTOCFGA_STAT_HASH, sizeof(rhash), &rhash);
-}
-
 static int crypto_report_rng(struct sk_buff *skb, struct crypto_alg *alg)
 {
 	struct crypto_stat_rng rrng;
@@ -198,14 +168,6 @@ static int crypto_reportstat_one(struct crypto_alg *alg,
 		if (crypto_report_kpp(skb, alg))
 			goto nla_put_failure;
 		break;
-	case CRYPTO_ALG_TYPE_AHASH:
-		if (crypto_report_ahash(skb, alg))
-			goto nla_put_failure;
-		break;
-	case CRYPTO_ALG_TYPE_HASH:
-		if (crypto_report_shash(skb, alg))
-			goto nla_put_failure;
-		break;
 	case CRYPTO_ALG_TYPE_RNG:
 		if (crypto_report_rng(skb, alg))
 			goto nla_put_failure;
diff --git a/crypto/hash.h b/crypto/hash.h
new file mode 100644
index 000000000000..008accc0ce24
--- /dev/null
+++ b/crypto/hash.h
@@ -0,0 +1,37 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Cryptographic API.
+ *
+ * Copyright (c) 2023 Herbert Xu <herbert@gondor.apana.org.au>
+ */
+#ifndef _LOCAL_CRYPTO_HASH_H
+#define _LOCAL_CRYPTO_HASH_H
+
+#include <crypto/internal/hash.h>
+#include <linux/cryptouser.h>
+
+#include "internal.h"
+
+static inline int crypto_hash_report_stat(struct sk_buff *skb,
+					  struct crypto_alg *alg,
+					  const char *type)
+{
+	struct hash_alg_common *halg = __crypto_hash_alg_common(alg);
+	struct crypto_istat_hash *istat = hash_get_stat(halg);
+	struct crypto_stat_hash rhash;
+
+	memset(&rhash, 0, sizeof(rhash));
+
+	strscpy(rhash.type, type, sizeof(rhash.type));
+
+	rhash.stat_hash_cnt = atomic64_read(&istat->hash_cnt);
+	rhash.stat_hash_tlen = atomic64_read(&istat->hash_tlen);
+	rhash.stat_err_cnt = atomic64_read(&istat->err_cnt);
+
+	return nla_put(skb, CRYPTOCFGA_STAT_HASH, sizeof(rhash), &rhash);
+}
+
+int hash_prepare_alg(struct hash_alg_common *alg);
+
+#endif	/* _LOCAL_CRYPTO_HASH_H */
+
diff --git a/crypto/shash.c b/crypto/shash.c
index 58b46f198449..3ccacdbee73f 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -6,22 +6,31 @@
  */
 
 #include <crypto/scatterwalk.h>
-#include <crypto/internal/hash.h>
+#include <linux/cryptouser.h>
 #include <linux/err.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/seq_file.h>
-#include <linux/cryptouser.h>
+#include <linux/string.h>
 #include <net/netlink.h>
-#include <linux/compiler.h>
 
-#include "internal.h"
+#include "hash.h"
 
 #define MAX_SHASH_ALIGNMASK 63
 
 static const struct crypto_type crypto_shash_type;
 
+static inline struct crypto_istat_hash *shash_get_stat(struct shash_alg *alg)
+{
+	return hash_get_stat(&alg->halg);
+}
+
+static inline int crypto_shash_errstat(struct shash_alg *alg, int err)
+{
+	return crypto_hash_errstat(&alg->halg, err);
+}
+
 int shash_no_setkey(struct crypto_shash *tfm, const u8 *key,
 		    unsigned int keylen)
 {
@@ -114,11 +123,17 @@ int crypto_shash_update(struct shash_desc *desc, const u8 *data,
 	struct crypto_shash *tfm = desc->tfm;
 	struct shash_alg *shash = crypto_shash_alg(tfm);
 	unsigned long alignmask = crypto_shash_alignmask(tfm);
+	int err;
+
+	if (IS_ENABLED(CONFIG_CRYPTO_STATS))
+		atomic64_add(len, &shash_get_stat(shash)->hash_tlen);
 
 	if ((unsigned long)data & alignmask)
-		return shash_update_unaligned(desc, data, len);
+		err = shash_update_unaligned(desc, data, len);
+	else
+		err = shash->update(desc, data, len);
 
-	return shash->update(desc, data, len);
+	return crypto_shash_errstat(shash, err);
 }
 EXPORT_SYMBOL_GPL(crypto_shash_update);
 
@@ -155,19 +170,25 @@ int crypto_shash_final(struct shash_desc *desc, u8 *out)
 	struct crypto_shash *tfm = desc->tfm;
 	struct shash_alg *shash = crypto_shash_alg(tfm);
 	unsigned long alignmask = crypto_shash_alignmask(tfm);
+	int err;
+
+	if (IS_ENABLED(CONFIG_CRYPTO_STATS))
+		atomic64_inc(&shash_get_stat(shash)->hash_cnt);
 
 	if ((unsigned long)out & alignmask)
-		return shash_final_unaligned(desc, out);
+		err = shash_final_unaligned(desc, out);
+	else
+		err = shash->final(desc, out);
 
-	return shash->final(desc, out);
+	return crypto_shash_errstat(shash, err);
 }
 EXPORT_SYMBOL_GPL(crypto_shash_final);
 
 static int shash_finup_unaligned(struct shash_desc *desc, const u8 *data,
 				 unsigned int len, u8 *out)
 {
-	return crypto_shash_update(desc, data, len) ?:
-	       crypto_shash_final(desc, out);
+	return shash_update_unaligned(desc, data, len) ?:
+	       shash_final_unaligned(desc, out);
 }
 
 int crypto_shash_finup(struct shash_desc *desc, const u8 *data,
@@ -176,11 +197,22 @@ int crypto_shash_finup(struct shash_desc *desc, const u8 *data,
 	struct crypto_shash *tfm = desc->tfm;
 	struct shash_alg *shash = crypto_shash_alg(tfm);
 	unsigned long alignmask = crypto_shash_alignmask(tfm);
+	int err;
+
+	if (IS_ENABLED(CONFIG_CRYPTO_STATS)) {
+		struct crypto_istat_hash *istat = shash_get_stat(shash);
+
+		atomic64_inc(&istat->hash_cnt);
+		atomic64_add(len, &istat->hash_tlen);
+	}
 
 	if (((unsigned long)data | (unsigned long)out) & alignmask)
-		return shash_finup_unaligned(desc, data, len, out);
+		err = shash_finup_unaligned(desc, data, len, out);
+	else
+		err = shash->finup(desc, data, len, out);
 
-	return shash->finup(desc, data, len, out);
+
+	return crypto_shash_errstat(shash, err);
 }
 EXPORT_SYMBOL_GPL(crypto_shash_finup);
 
@@ -188,7 +220,8 @@ static int shash_digest_unaligned(struct shash_desc *desc, const u8 *data,
 				  unsigned int len, u8 *out)
 {
 	return crypto_shash_init(desc) ?:
-	       crypto_shash_finup(desc, data, len, out);
+	       shash_update_unaligned(desc, data, len) ?:
+	       shash_final_unaligned(desc, out);
 }
 
 int crypto_shash_digest(struct shash_desc *desc, const u8 *data,
@@ -197,14 +230,23 @@ int crypto_shash_digest(struct shash_desc *desc, const u8 *data,
 	struct crypto_shash *tfm = desc->tfm;
 	struct shash_alg *shash = crypto_shash_alg(tfm);
 	unsigned long alignmask = crypto_shash_alignmask(tfm);
+	int err;
 
-	if (crypto_shash_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
-		return -ENOKEY;
+	if (IS_ENABLED(CONFIG_CRYPTO_STATS)) {
+		struct crypto_istat_hash *istat = shash_get_stat(shash);
 
-	if (((unsigned long)data | (unsigned long)out) & alignmask)
-		return shash_digest_unaligned(desc, data, len, out);
+		atomic64_inc(&istat->hash_cnt);
+		atomic64_add(len, &istat->hash_tlen);
+	}
 
-	return shash->digest(desc, data, len, out);
+	if (crypto_shash_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
+		err = -ENOKEY;
+	else if (((unsigned long)data | (unsigned long)out) & alignmask)
+		err = shash_digest_unaligned(desc, data, len, out);
+	else
+		err = shash->digest(desc, data, len, out);
+
+	return crypto_shash_errstat(shash, err);
 }
 EXPORT_SYMBOL_GPL(crypto_shash_digest);
 
@@ -481,6 +523,14 @@ static void crypto_shash_show(struct seq_file *m, struct crypto_alg *alg)
 	seq_printf(m, "digestsize   : %u\n", salg->digestsize);
 }
 
+static int crypto_shash_report_stat(struct sk_buff *skb,
+				    struct crypto_alg *alg) __maybe_unused;
+static int crypto_shash_report_stat(struct sk_buff *skb,
+				    struct crypto_alg *alg)
+{
+	return crypto_hash_report_stat(skb, alg, "shash");
+}
+
 static const struct crypto_type crypto_shash_type = {
 	.extsize = crypto_alg_extsize,
 	.init_tfm = crypto_shash_init_tfm,
@@ -489,6 +539,9 @@ static const struct crypto_type crypto_shash_type = {
 	.show = crypto_shash_show,
 #endif
 	.report = crypto_shash_report,
+#ifdef CONFIG_CRYPTO_STATS
+	.report_stat = crypto_shash_report_stat,
+#endif
 	.maskclear = ~CRYPTO_ALG_TYPE_MASK,
 	.maskset = CRYPTO_ALG_TYPE_MASK,
 	.type = CRYPTO_ALG_TYPE_SHASH,
@@ -517,13 +570,30 @@ int crypto_has_shash(const char *alg_name, u32 type, u32 mask)
 }
 EXPORT_SYMBOL_GPL(crypto_has_shash);
 
-static int shash_prepare_alg(struct shash_alg *alg)
+int hash_prepare_alg(struct hash_alg_common *alg)
 {
+	struct crypto_istat_hash *istat = hash_get_stat(alg);
 	struct crypto_alg *base = &alg->base;
 
 	if (alg->digestsize > HASH_MAX_DIGESTSIZE ||
-	    alg->descsize > HASH_MAX_DESCSIZE ||
-	    alg->statesize > HASH_MAX_STATESIZE)
+	    alg->statesize > HASH_MAX_STATESIZE ||
+	    !alg->statesize)
+		return -EINVAL;
+
+	base->cra_flags &= ~CRYPTO_ALG_TYPE_MASK;
+
+	if (IS_ENABLED(CONFIG_CRYPTO_STATS))
+		memset(istat, 0, sizeof(*istat));
+
+	return 0;
+}
+
+static int shash_prepare_alg(struct shash_alg *alg)
+{
+	struct crypto_alg *base = &alg->halg.base;
+	int err;
+
+	if (alg->descsize > HASH_MAX_DESCSIZE)
 		return -EINVAL;
 
 	if (base->cra_alignmask > MAX_SHASH_ALIGNMASK)
@@ -532,19 +602,23 @@ static int shash_prepare_alg(struct shash_alg *alg)
 	if ((alg->export && !alg->import) || (alg->import && !alg->export))
 		return -EINVAL;
 
+	if (!alg->export) {
+		alg->export = shash_default_export;
+		alg->import = shash_default_import;
+		alg->halg.statesize = alg->descsize;
+	}
+
+	err = hash_prepare_alg(&alg->halg);
+	if (err)
+		return err;
+
 	base->cra_type = &crypto_shash_type;
-	base->cra_flags &= ~CRYPTO_ALG_TYPE_MASK;
 	base->cra_flags |= CRYPTO_ALG_TYPE_SHASH;
 
 	if (!alg->finup)
 		alg->finup = shash_finup_unaligned;
 	if (!alg->digest)
 		alg->digest = shash_digest_unaligned;
-	if (!alg->export) {
-		alg->export = shash_default_export;
-		alg->import = shash_default_import;
-		alg->statesize = alg->descsize;
-	}
 	if (!alg->setkey)
 		alg->setkey = shash_no_setkey;
 
diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index f5841992dc9b..206f75bfb44e 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -8,6 +8,7 @@
 #ifndef _CRYPTO_HASH_H
 #define _CRYPTO_HASH_H
 
+#include <linux/atomic.h>
 #include <linux/crypto.h>
 #include <linux/string.h>
 
@@ -22,8 +23,27 @@ struct crypto_ahash;
  * crypto_unregister_shash().
  */
 
+/*
+ * struct crypto_istat_hash - statistics for has algorithm
+ * @hash_cnt:		number of hash requests
+ * @hash_tlen:		total data size hashed
+ * @err_cnt:		number of error for hash requests
+ */
+struct crypto_istat_hash {
+	atomic64_t hash_cnt;
+	atomic64_t hash_tlen;
+	atomic64_t err_cnt;
+};
+
+#ifdef CONFIG_CRYPTO_STATS
+#define HASH_ALG_COMMON_STAT struct crypto_istat_hash stat;
+#else
+#define HASH_ALG_COMMON_STAT
+#endif
+
 /**
  * struct hash_alg_common - define properties of message digest
+ * @stat: Statistics for hash algorithm.
  * @digestsize: Size of the result of the transformation. A buffer of this size
  *	        must be available to the @final and @finup calls, so they can
  *	        store the resulting hash into it. For various predefined sizes,
@@ -39,12 +59,15 @@ struct crypto_ahash;
  *	  The hash_alg_common data structure now adds the hash-specific
  *	  information.
  */
-struct hash_alg_common {
-	unsigned int digestsize;
-	unsigned int statesize;
-
-	struct crypto_alg base;
-};
+#define HASH_ALG_COMMON {		\
+	struct crypto_alg base;		\
+					\
+	HASH_ALG_COMMON_STAT		\
+					\
+	unsigned int digestsize;	\
+	unsigned int statesize;		\
+}
+struct hash_alg_common HASH_ALG_COMMON;
 
 struct ahash_request {
 	struct crypto_async_request base;
@@ -190,6 +213,7 @@ struct shash_desc {
  *	      various changes set in @init_tfm.
  * @digestsize: see struct ahash_alg
  * @statesize: see struct ahash_alg
+ * @halg: see struct hash_alg_common
  * @descsize: Size of the operational state for the message digest. This state
  * 	      size is the memory size that needs to be allocated for
  *	      shash_desc.__ctx
@@ -211,15 +235,15 @@ struct shash_alg {
 	int (*init_tfm)(struct crypto_shash *tfm);
 	void (*exit_tfm)(struct crypto_shash *tfm);
 
-	unsigned int descsize;
-
-	/* These fields must match hash_alg_common. */
-	unsigned int digestsize
-		__attribute__ ((aligned(__alignof__(struct hash_alg_common))));
-	unsigned int statesize;
+	union {
+		struct HASH_ALG_COMMON;
+		struct hash_alg_common halg;
+	};
 
-	struct crypto_alg base;
+	unsigned int descsize;
 };
+#undef HASH_ALG_COMMON
+#undef HASH_ALG_COMMON_STAT
 
 struct crypto_ahash {
 	int (*init)(struct ahash_request *req);
@@ -535,6 +559,27 @@ static inline int crypto_ahash_init(struct ahash_request *req)
 	return tfm->init(req);
 }
 
+static inline struct crypto_istat_hash *hash_get_stat(
+	struct hash_alg_common *alg)
+{
+#ifdef CONFIG_CRYPTO_STATS
+	return &alg->stat;
+#else
+	return NULL;
+#endif
+}
+
+static inline int crypto_hash_errstat(struct hash_alg_common *alg, int err)
+{
+	if (!IS_ENABLED(CONFIG_CRYPTO_STATS))
+		return err;
+
+	if (err && err != -EINPROGRESS && err != -EBUSY)
+		atomic64_inc(&hash_get_stat(alg)->err_cnt);
+
+	return err;
+}
+
 /**
  * crypto_ahash_update() - add data to message digest for processing
  * @req: ahash_request handle that was previously initialized with the
@@ -549,14 +594,12 @@ static inline int crypto_ahash_init(struct ahash_request *req)
 static inline int crypto_ahash_update(struct ahash_request *req)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct crypto_alg *alg = tfm->base.__crt_alg;
-	unsigned int nbytes = req->nbytes;
-	int ret;
-
-	crypto_stats_get(alg);
-	ret = crypto_ahash_reqtfm(req)->update(req);
-	crypto_stats_ahash_update(nbytes, ret, alg);
-	return ret;
+	struct hash_alg_common *alg = crypto_hash_alg_common(tfm);
+
+	if (IS_ENABLED(CONFIG_CRYPTO_STATS))
+		atomic64_add(req->nbytes, &hash_get_stat(alg)->hash_tlen);
+
+	return crypto_hash_errstat(alg, tfm->update(req));
 }
 
 /**
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 778cc05f76a8..caf759e4201c 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -308,18 +308,6 @@ struct crypto_istat_compress {
 	atomic64_t err_cnt;
 };
 
-/*
- * struct crypto_istat_hash - statistics for has algorithm
- * @hash_cnt:		number of hash requests
- * @hash_tlen:		total data size hashed
- * @err_cnt:		number of error for hash requests
- */
-struct crypto_istat_hash {
-	atomic64_t hash_cnt;
-	atomic64_t hash_tlen;
-	atomic64_t err_cnt;
-};
-
 /*
  * struct crypto_istat_kpp - statistics for KPP algorithm
  * @setsecret_cnt:		number of setsecrey operation
@@ -429,7 +417,6 @@ struct crypto_istat_rng {
  * @stats: union of all possible crypto_istat_xxx structures
  * @stats.cipher:	statistics for cipher algorithm
  * @stats.compress:	statistics for compress algorithm
- * @stats.hash:		statistics for hash algorithm
  * @stats.rng:		statistics for rng algorithm
  * @stats.kpp:		statistics for KPP algorithm
  *
@@ -469,7 +456,6 @@ struct crypto_alg {
 	union {
 		struct crypto_istat_cipher cipher;
 		struct crypto_istat_compress compress;
-		struct crypto_istat_hash hash;
 		struct crypto_istat_rng rng;
 		struct crypto_istat_kpp kpp;
 	} stats;
@@ -480,8 +466,6 @@ struct crypto_alg {
 #ifdef CONFIG_CRYPTO_STATS
 void crypto_stats_init(struct crypto_alg *alg);
 void crypto_stats_get(struct crypto_alg *alg);
-void crypto_stats_ahash_update(unsigned int nbytes, int ret, struct crypto_alg *alg);
-void crypto_stats_ahash_final(unsigned int nbytes, int ret, struct crypto_alg *alg);
 void crypto_stats_compress(unsigned int slen, int ret, struct crypto_alg *alg);
 void crypto_stats_decompress(unsigned int slen, int ret, struct crypto_alg *alg);
 void crypto_stats_kpp_set_secret(struct crypto_alg *alg, int ret);
@@ -496,10 +480,6 @@ static inline void crypto_stats_init(struct crypto_alg *alg)
 {}
 static inline void crypto_stats_get(struct crypto_alg *alg)
 {}
-static inline void crypto_stats_ahash_update(unsigned int nbytes, int ret, struct crypto_alg *alg)
-{}
-static inline void crypto_stats_ahash_final(unsigned int nbytes, int ret, struct crypto_alg *alg)
-{}
 static inline void crypto_stats_compress(unsigned int slen, int ret, struct crypto_alg *alg)
 {}
 static inline void crypto_stats_decompress(unsigned int slen, int ret, struct crypto_alg *alg)
