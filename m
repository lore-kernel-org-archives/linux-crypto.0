Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF052C636D6
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Feb 2023 10:36:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbjBPKgO (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Feb 2023 05:36:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbjBPKgO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Feb 2023 05:36:14 -0500
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6A7E5356B
        for <linux-crypto@vger.kernel.org>; Thu, 16 Feb 2023 02:35:51 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pSbbh-00BwJ8-Fa; Thu, 16 Feb 2023 18:35:18 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 16 Feb 2023 18:35:17 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Thu, 16 Feb 2023 18:35:17 +0800
Subject: [v2 PATCH 5/10] crypto: acomp - Count error stats differently
References: <Y+4GpkkLQjyv7KUt@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Message-Id: <E1pSbbh-00BwJ8-Fa@formenos.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Move all stat code specific to acomp into the acomp code.

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

 crypto/acompress.c                  |   69 ++++++++++++++++---
 crypto/algapi.c                     |   24 ------
 crypto/compress.h                   |   27 +++++++
 crypto/crypto_user_stat.c           |   29 --------
 crypto/scompress.c                  |   27 ++++---
 include/crypto/acompress.h          |  128 ++++++++++++++++++++++--------------
 include/crypto/internal/acompress.h |   43 ++++++++++--
 include/crypto/internal/scompress.h |   15 ++--
 include/linux/crypto.h              |   24 ------
 9 files changed, 230 insertions(+), 156 deletions(-)

diff --git a/crypto/acompress.c b/crypto/acompress.c
index c32c72048a1c..022839ab457a 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -6,23 +6,33 @@
  * Authors: Weigang Li <weigang.li@intel.com>
  *          Giovanni Cabiddu <giovanni.cabiddu@intel.com>
  */
+
+#include <crypto/internal/acompress.h>
+#include <linux/cryptouser.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/string.h>
-#include <linux/crypto.h>
-#include <crypto/algapi.h>
-#include <linux/cryptouser.h>
-#include <linux/compiler.h>
 #include <net/netlink.h>
-#include <crypto/internal/acompress.h>
-#include <crypto/internal/scompress.h>
-#include "internal.h"
+
+#include "compress.h"
+
+struct crypto_scomp;
 
 static const struct crypto_type crypto_acomp_type;
 
+static inline struct acomp_alg *__crypto_acomp_alg(struct crypto_alg *alg)
+{
+	return container_of(alg, struct acomp_alg, calg.base);
+}
+
+static inline struct acomp_alg *crypto_acomp_alg(struct crypto_acomp *tfm)
+{
+	return __crypto_acomp_alg(crypto_acomp_tfm(tfm)->__crt_alg);
+}
+
 #ifdef CONFIG_NET
 static int crypto_acomp_report(struct sk_buff *skb, struct crypto_alg *alg)
 {
@@ -89,6 +99,32 @@ static unsigned int crypto_acomp_extsize(struct crypto_alg *alg)
 	return extsize;
 }
 
+static inline int __crypto_acomp_report_stat(struct sk_buff *skb,
+					     struct crypto_alg *alg)
+{
+	struct comp_alg_common *calg = __crypto_comp_alg_common(alg);
+	struct crypto_istat_compress *istat = comp_get_stat(calg);
+	struct crypto_stat_compress racomp;
+
+	memset(&racomp, 0, sizeof(racomp));
+
+	strscpy(racomp.type, "acomp", sizeof(racomp.type));
+	racomp.stat_compress_cnt = atomic64_read(&istat->compress_cnt);
+	racomp.stat_compress_tlen = atomic64_read(&istat->compress_tlen);
+	racomp.stat_decompress_cnt =  atomic64_read(&istat->decompress_cnt);
+	racomp.stat_decompress_tlen = atomic64_read(&istat->decompress_tlen);
+	racomp.stat_err_cnt = atomic64_read(&istat->err_cnt);
+
+	return nla_put(skb, CRYPTOCFGA_STAT_ACOMP, sizeof(racomp), &racomp);
+}
+
+#ifdef CONFIG_CRYPTO_STATS
+int crypto_acomp_report_stat(struct sk_buff *skb, struct crypto_alg *alg)
+{
+	return __crypto_acomp_report_stat(skb, alg);
+}
+#endif
+
 static const struct crypto_type crypto_acomp_type = {
 	.extsize = crypto_acomp_extsize,
 	.init_tfm = crypto_acomp_init_tfm,
@@ -96,6 +132,9 @@ static const struct crypto_type crypto_acomp_type = {
 	.show = crypto_acomp_show,
 #endif
 	.report = crypto_acomp_report,
+#ifdef CONFIG_CRYPTO_STATS
+	.report_stat = crypto_acomp_report_stat,
+#endif
 	.maskclear = ~CRYPTO_ALG_TYPE_MASK,
 	.maskset = CRYPTO_ALG_TYPE_ACOMPRESS_MASK,
 	.type = CRYPTO_ALG_TYPE_ACOMPRESS,
@@ -147,12 +186,24 @@ void acomp_request_free(struct acomp_req *req)
 }
 EXPORT_SYMBOL_GPL(acomp_request_free);
 
-int crypto_register_acomp(struct acomp_alg *alg)
+void comp_prepare_alg(struct comp_alg_common *alg)
 {
+	struct crypto_istat_compress *istat = comp_get_stat(alg);
 	struct crypto_alg *base = &alg->base;
 
-	base->cra_type = &crypto_acomp_type;
 	base->cra_flags &= ~CRYPTO_ALG_TYPE_MASK;
+
+	if (IS_ENABLED(CONFIG_CRYPTO_STATS))
+		memset(istat, 0, sizeof(*istat));
+}
+
+int crypto_register_acomp(struct acomp_alg *alg)
+{
+	struct crypto_alg *base = &alg->calg.base;
+
+	comp_prepare_alg(&alg->calg);
+
+	base->cra_type = &crypto_acomp_type;
 	base->cra_flags |= CRYPTO_ALG_TYPE_ACOMPRESS;
 
 	return crypto_register_alg(base);
diff --git a/crypto/algapi.c b/crypto/algapi.c
index deabd2d42216..fe48ce1957e1 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -1051,30 +1051,6 @@ void crypto_stats_get(struct crypto_alg *alg)
 }
 EXPORT_SYMBOL_GPL(crypto_stats_get);
 
-void crypto_stats_compress(unsigned int slen, int ret, struct crypto_alg *alg)
-{
-	if (ret && ret != -EINPROGRESS && ret != -EBUSY) {
-		atomic64_inc(&alg->stats.compress.err_cnt);
-	} else {
-		atomic64_inc(&alg->stats.compress.compress_cnt);
-		atomic64_add(slen, &alg->stats.compress.compress_tlen);
-	}
-	crypto_alg_put(alg);
-}
-EXPORT_SYMBOL_GPL(crypto_stats_compress);
-
-void crypto_stats_decompress(unsigned int slen, int ret, struct crypto_alg *alg)
-{
-	if (ret && ret != -EINPROGRESS && ret != -EBUSY) {
-		atomic64_inc(&alg->stats.compress.err_cnt);
-	} else {
-		atomic64_inc(&alg->stats.compress.decompress_cnt);
-		atomic64_add(slen, &alg->stats.compress.decompress_tlen);
-	}
-	crypto_alg_put(alg);
-}
-EXPORT_SYMBOL_GPL(crypto_stats_decompress);
-
 void crypto_stats_kpp_set_secret(struct crypto_alg *alg, int ret)
 {
 	if (ret)
diff --git a/crypto/compress.h b/crypto/compress.h
new file mode 100644
index 000000000000..e91cdd124382
--- /dev/null
+++ b/crypto/compress.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Cryptographic API.
+ *
+ * Copyright 2015 LG Electronics Inc.
+ * Copyright (c) 2016, Intel Corporation
+ * Copyright (c) 2023 Herbert Xu <herbert@gondor.apana.org.au>
+ */
+#ifndef _LOCAL_CRYPTO_COMPRESS_H
+#define _LOCAL_CRYPTO_COMPRESS_H
+
+#include "internal.h"
+
+struct acomp_req;
+struct comp_alg_common;
+struct sk_buff;
+
+int crypto_init_scomp_ops_async(struct crypto_tfm *tfm);
+struct acomp_req *crypto_acomp_scomp_alloc_ctx(struct acomp_req *req);
+void crypto_acomp_scomp_free_ctx(struct acomp_req *req);
+
+int crypto_acomp_report_stat(struct sk_buff *skb, struct crypto_alg *alg);
+
+void comp_prepare_alg(struct comp_alg_common *alg);
+
+#endif	/* _LOCAL_CRYPTO_COMPRESS_H */
+
diff --git a/crypto/crypto_user_stat.c b/crypto/crypto_user_stat.c
index d65f10f71f11..ad616e19a3e1 100644
--- a/crypto/crypto_user_stat.c
+++ b/crypto/crypto_user_stat.c
@@ -51,31 +51,10 @@ static int crypto_report_comp(struct sk_buff *skb, struct crypto_alg *alg)
 	memset(&rcomp, 0, sizeof(rcomp));
 
 	strscpy(rcomp.type, "compression", sizeof(rcomp.type));
-	rcomp.stat_compress_cnt = atomic64_read(&alg->stats.compress.compress_cnt);
-	rcomp.stat_compress_tlen = atomic64_read(&alg->stats.compress.compress_tlen);
-	rcomp.stat_decompress_cnt = atomic64_read(&alg->stats.compress.decompress_cnt);
-	rcomp.stat_decompress_tlen = atomic64_read(&alg->stats.compress.decompress_tlen);
-	rcomp.stat_err_cnt = atomic64_read(&alg->stats.compress.err_cnt);
 
 	return nla_put(skb, CRYPTOCFGA_STAT_COMPRESS, sizeof(rcomp), &rcomp);
 }
 
-static int crypto_report_acomp(struct sk_buff *skb, struct crypto_alg *alg)
-{
-	struct crypto_stat_compress racomp;
-
-	memset(&racomp, 0, sizeof(racomp));
-
-	strscpy(racomp.type, "acomp", sizeof(racomp.type));
-	racomp.stat_compress_cnt = atomic64_read(&alg->stats.compress.compress_cnt);
-	racomp.stat_compress_tlen = atomic64_read(&alg->stats.compress.compress_tlen);
-	racomp.stat_decompress_cnt =  atomic64_read(&alg->stats.compress.decompress_cnt);
-	racomp.stat_decompress_tlen = atomic64_read(&alg->stats.compress.decompress_tlen);
-	racomp.stat_err_cnt = atomic64_read(&alg->stats.compress.err_cnt);
-
-	return nla_put(skb, CRYPTOCFGA_STAT_ACOMP, sizeof(racomp), &racomp);
-}
-
 static int crypto_report_kpp(struct sk_buff *skb, struct crypto_alg *alg)
 {
 	struct crypto_stat_kpp rkpp;
@@ -156,14 +135,6 @@ static int crypto_reportstat_one(struct crypto_alg *alg,
 		if (crypto_report_comp(skb, alg))
 			goto nla_put_failure;
 		break;
-	case CRYPTO_ALG_TYPE_ACOMPRESS:
-		if (crypto_report_acomp(skb, alg))
-			goto nla_put_failure;
-		break;
-	case CRYPTO_ALG_TYPE_SCOMPRESS:
-		if (crypto_report_acomp(skb, alg))
-			goto nla_put_failure;
-		break;
 	case CRYPTO_ALG_TYPE_KPP:
 		if (crypto_report_kpp(skb, alg))
 			goto nla_put_failure;
diff --git a/crypto/scompress.c b/crypto/scompress.c
index 738f4f8f0f41..214283f7730a 100644
--- a/crypto/scompress.c
+++ b/crypto/scompress.c
@@ -6,23 +6,22 @@
  * Copyright (c) 2016, Intel Corporation
  * Author: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
  */
-#include <linux/errno.h>
+
+#include <crypto/internal/acompress.h>
+#include <crypto/internal/scompress.h>
+#include <crypto/scatterwalk.h>
+#include <linux/cryptouser.h>
+#include <linux/err.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/scatterlist.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/string.h>
-#include <linux/crypto.h>
-#include <linux/compiler.h>
 #include <linux/vmalloc.h>
-#include <crypto/algapi.h>
-#include <linux/cryptouser.h>
 #include <net/netlink.h>
-#include <linux/scatterlist.h>
-#include <crypto/scatterwalk.h>
-#include <crypto/internal/acompress.h>
-#include <crypto/internal/scompress.h>
-#include "internal.h"
+
+#include "compress.h"
 
 struct scomp_scratch {
 	spinlock_t	lock;
@@ -248,6 +247,9 @@ static const struct crypto_type crypto_scomp_type = {
 	.show = crypto_scomp_show,
 #endif
 	.report = crypto_scomp_report,
+#ifdef CONFIG_CRYPTO_STATS
+	.report_stat = crypto_acomp_report_stat,
+#endif
 	.maskclear = ~CRYPTO_ALG_TYPE_MASK,
 	.maskset = CRYPTO_ALG_TYPE_MASK,
 	.type = CRYPTO_ALG_TYPE_SCOMPRESS,
@@ -256,10 +258,11 @@ static const struct crypto_type crypto_scomp_type = {
 
 int crypto_register_scomp(struct scomp_alg *alg)
 {
-	struct crypto_alg *base = &alg->base;
+	struct crypto_alg *base = &alg->calg.base;
+
+	comp_prepare_alg(&alg->calg);
 
 	base->cra_type = &crypto_scomp_type;
-	base->cra_flags &= ~CRYPTO_ALG_TYPE_MASK;
 	base->cra_flags |= CRYPTO_ALG_TYPE_SCOMPRESS;
 
 	return crypto_register_alg(base);
diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index e4bc96528902..dff95e9060e6 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -8,6 +8,9 @@
  */
 #ifndef _CRYPTO_ACOMP_H
 #define _CRYPTO_ACOMP_H
+
+#include <linux/atomic.h>
+#include <linux/container_of.h>
 #include <linux/crypto.h>
 
 #define CRYPTO_ACOMP_ALLOC_OUTPUT	0x00000001
@@ -53,37 +56,35 @@ struct crypto_acomp {
 	struct crypto_tfm base;
 };
 
-/**
- * struct acomp_alg - asynchronous compression algorithm
- *
- * @compress:	Function performs a compress operation
- * @decompress:	Function performs a de-compress operation
- * @dst_free:	Frees destination buffer if allocated inside the algorithm
- * @init:	Initialize the cryptographic transformation object.
- *		This function is used to initialize the cryptographic
- *		transformation object. This function is called only once at
- *		the instantiation time, right after the transformation context
- *		was allocated. In case the cryptographic hardware has some
- *		special requirements which need to be handled by software, this
- *		function shall check for the precise requirement of the
- *		transformation and put any software fallbacks in place.
- * @exit:	Deinitialize the cryptographic transformation object. This is a
- *		counterpart to @init, used to remove various changes set in
- *		@init.
- *
- * @reqsize:	Context size for (de)compression requests
- * @base:	Common crypto API algorithm data structure
+/*
+ * struct crypto_istat_compress - statistics for compress algorithm
+ * @compress_cnt:	number of compress requests
+ * @compress_tlen:	total data size handled by compress requests
+ * @decompress_cnt:	number of decompress requests
+ * @decompress_tlen:	total data size handled by decompress requests
+ * @err_cnt:		number of error for compress requests
  */
-struct acomp_alg {
-	int (*compress)(struct acomp_req *req);
-	int (*decompress)(struct acomp_req *req);
-	void (*dst_free)(struct scatterlist *dst);
-	int (*init)(struct crypto_acomp *tfm);
-	void (*exit)(struct crypto_acomp *tfm);
-	unsigned int reqsize;
-	struct crypto_alg base;
+struct crypto_istat_compress {
+	atomic64_t compress_cnt;
+	atomic64_t compress_tlen;
+	atomic64_t decompress_cnt;
+	atomic64_t decompress_tlen;
+	atomic64_t err_cnt;
 };
 
+#ifdef CONFIG_CRYPTO_STATS
+#define COMP_ALG_COMMON_STATS struct crypto_istat_compress stat;
+#else
+#define COMP_ALG_COMMON_STATS
+#endif
+
+#define COMP_ALG_COMMON {			\
+	COMP_ALG_COMMON_STATS			\
+						\
+	struct crypto_alg base;			\
+}
+struct comp_alg_common COMP_ALG_COMMON;
+
 /**
  * DOC: Asynchronous Compression API
  *
@@ -131,9 +132,10 @@ static inline struct crypto_tfm *crypto_acomp_tfm(struct crypto_acomp *tfm)
 	return &tfm->base;
 }
 
-static inline struct acomp_alg *__crypto_acomp_alg(struct crypto_alg *alg)
+static inline struct comp_alg_common *__crypto_comp_alg_common(
+	struct crypto_alg *alg)
 {
-	return container_of(alg, struct acomp_alg, base);
+	return container_of(alg, struct comp_alg_common, base);
 }
 
 static inline struct crypto_acomp *__crypto_acomp_tfm(struct crypto_tfm *tfm)
@@ -141,9 +143,10 @@ static inline struct crypto_acomp *__crypto_acomp_tfm(struct crypto_tfm *tfm)
 	return container_of(tfm, struct crypto_acomp, base);
 }
 
-static inline struct acomp_alg *crypto_acomp_alg(struct crypto_acomp *tfm)
+static inline struct comp_alg_common *crypto_comp_alg_common(
+	struct crypto_acomp *tfm)
 {
-	return __crypto_acomp_alg(crypto_acomp_tfm(tfm)->__crt_alg);
+	return __crypto_comp_alg_common(crypto_acomp_tfm(tfm)->__crt_alg);
 }
 
 static inline unsigned int crypto_acomp_reqsize(struct crypto_acomp *tfm)
@@ -250,6 +253,27 @@ static inline void acomp_request_set_params(struct acomp_req *req,
 		req->flags |= CRYPTO_ACOMP_ALLOC_OUTPUT;
 }
 
+static inline struct crypto_istat_compress *comp_get_stat(
+	struct comp_alg_common *alg)
+{
+#ifdef CONFIG_CRYPTO_STATS
+	return &alg->stat;
+#else
+	return NULL;
+#endif
+}
+
+static inline int crypto_comp_errstat(struct comp_alg_common *alg, int err)
+{
+	if (!IS_ENABLED(CONFIG_CRYPTO_STATS))
+		return err;
+
+	if (err && err != -EINPROGRESS && err != -EBUSY)
+		atomic64_inc(&comp_get_stat(alg)->err_cnt);
+
+	return err;
+}
+
 /**
  * crypto_acomp_compress() -- Invoke asynchronous compress operation
  *
@@ -262,14 +286,18 @@ static inline void acomp_request_set_params(struct acomp_req *req,
 static inline int crypto_acomp_compress(struct acomp_req *req)
 {
 	struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
-	struct crypto_alg *alg = tfm->base.__crt_alg;
-	unsigned int slen = req->slen;
-	int ret;
-
-	crypto_stats_get(alg);
-	ret = tfm->compress(req);
-	crypto_stats_compress(slen, ret, alg);
-	return ret;
+	struct comp_alg_common *alg;
+
+	alg = crypto_comp_alg_common(tfm);
+
+	if (IS_ENABLED(CONFIG_CRYPTO_STATS)) {
+		struct crypto_istat_compress *istat = comp_get_stat(alg);
+
+		atomic64_inc(&istat->compress_cnt);
+		atomic64_add(req->slen, &istat->compress_tlen);
+	}
+
+	return crypto_comp_errstat(alg, tfm->compress(req));
 }
 
 /**
@@ -284,14 +312,18 @@ static inline int crypto_acomp_compress(struct acomp_req *req)
 static inline int crypto_acomp_decompress(struct acomp_req *req)
 {
 	struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
-	struct crypto_alg *alg = tfm->base.__crt_alg;
-	unsigned int slen = req->slen;
-	int ret;
-
-	crypto_stats_get(alg);
-	ret = tfm->decompress(req);
-	crypto_stats_decompress(slen, ret, alg);
-	return ret;
+	struct comp_alg_common *alg;
+
+	alg = crypto_comp_alg_common(tfm);
+
+	if (IS_ENABLED(CONFIG_CRYPTO_STATS)) {
+		struct crypto_istat_compress *istat = comp_get_stat(alg);
+
+		atomic64_inc(&istat->decompress_cnt);
+		atomic64_add(req->slen, &istat->decompress_tlen);
+	}
+
+	return crypto_comp_errstat(alg, tfm->decompress(req));
 }
 
 #endif
diff --git a/include/crypto/internal/acompress.h b/include/crypto/internal/acompress.h
index 978b57a3f4f0..4ac46bafba9d 100644
--- a/include/crypto/internal/acompress.h
+++ b/include/crypto/internal/acompress.h
@@ -12,6 +12,44 @@
 #include <crypto/acompress.h>
 #include <crypto/algapi.h>
 
+/**
+ * struct acomp_alg - asynchronous compression algorithm
+ *
+ * @compress:	Function performs a compress operation
+ * @decompress:	Function performs a de-compress operation
+ * @dst_free:	Frees destination buffer if allocated inside the algorithm
+ * @init:	Initialize the cryptographic transformation object.
+ *		This function is used to initialize the cryptographic
+ *		transformation object. This function is called only once at
+ *		the instantiation time, right after the transformation context
+ *		was allocated. In case the cryptographic hardware has some
+ *		special requirements which need to be handled by software, this
+ *		function shall check for the precise requirement of the
+ *		transformation and put any software fallbacks in place.
+ * @exit:	Deinitialize the cryptographic transformation object. This is a
+ *		counterpart to @init, used to remove various changes set in
+ *		@init.
+ *
+ * @reqsize:	Context size for (de)compression requests
+ * @stat:	Statistics for compress algorithm
+ * @base:	Common crypto API algorithm data structure
+ * @calg:	Cmonn algorithm data structure shared with scomp
+ */
+struct acomp_alg {
+	int (*compress)(struct acomp_req *req);
+	int (*decompress)(struct acomp_req *req);
+	void (*dst_free)(struct scatterlist *dst);
+	int (*init)(struct crypto_acomp *tfm);
+	void (*exit)(struct crypto_acomp *tfm);
+
+	unsigned int reqsize;
+
+	union {
+		struct COMP_ALG_COMMON;
+		struct comp_alg_common calg;
+	};
+};
+
 /*
  * Transform internal helpers.
  */
@@ -31,11 +69,6 @@ static inline void acomp_request_complete(struct acomp_req *req,
 	crypto_request_complete(&req->base, err);
 }
 
-static inline const char *acomp_alg_name(struct crypto_acomp *tfm)
-{
-	return crypto_acomp_tfm(tfm)->__crt_alg->cra_name;
-}
-
 static inline struct acomp_req *__acomp_request_alloc(struct crypto_acomp *tfm)
 {
 	struct acomp_req *req;
diff --git a/include/crypto/internal/scompress.h b/include/crypto/internal/scompress.h
index 252cc949d4ee..858fe3965ae3 100644
--- a/include/crypto/internal/scompress.h
+++ b/include/crypto/internal/scompress.h
@@ -9,10 +9,13 @@
 #ifndef _CRYPTO_SCOMP_INT_H
 #define _CRYPTO_SCOMP_INT_H
 
+#include <crypto/acompress.h>
 #include <crypto/algapi.h>
 
 #define SCOMP_SCRATCH_SIZE	131072
 
+struct acomp_req;
+
 struct crypto_scomp {
 	struct crypto_tfm base;
 };
@@ -24,7 +27,9 @@ struct crypto_scomp {
  * @free_ctx:	Function frees context allocated with alloc_ctx
  * @compress:	Function performs a compress operation
  * @decompress:	Function performs a de-compress operation
+ * @stat:	Statistics for compress algorithm
  * @base:	Common crypto API algorithm data structure
+ * @calg:	Cmonn algorithm data structure shared with acomp
  */
 struct scomp_alg {
 	void *(*alloc_ctx)(struct crypto_scomp *tfm);
@@ -35,7 +40,11 @@ struct scomp_alg {
 	int (*decompress)(struct crypto_scomp *tfm, const u8 *src,
 			  unsigned int slen, u8 *dst, unsigned int *dlen,
 			  void *ctx);
-	struct crypto_alg base;
+
+	union {
+		struct COMP_ALG_COMMON;
+		struct comp_alg_common calg;
+	};
 };
 
 static inline struct scomp_alg *__crypto_scomp_alg(struct crypto_alg *alg)
@@ -90,10 +99,6 @@ static inline int crypto_scomp_decompress(struct crypto_scomp *tfm,
 						 ctx);
 }
 
-int crypto_init_scomp_ops_async(struct crypto_tfm *tfm);
-struct acomp_req *crypto_acomp_scomp_alloc_ctx(struct acomp_req *req);
-void crypto_acomp_scomp_free_ctx(struct acomp_req *req);
-
 /**
  * crypto_register_scomp() -- Register synchronous compression algorithm
  *
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index caf759e4201c..42bc55b642a0 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -292,22 +292,6 @@ struct crypto_istat_cipher {
 	atomic64_t err_cnt;
 };
 
-/*
- * struct crypto_istat_compress - statistics for compress algorithm
- * @compress_cnt:	number of compress requests
- * @compress_tlen:	total data size handled by compress requests
- * @decompress_cnt:	number of decompress requests
- * @decompress_tlen:	total data size handled by decompress requests
- * @err_cnt:		number of error for compress requests
- */
-struct crypto_istat_compress {
-	atomic64_t compress_cnt;
-	atomic64_t compress_tlen;
-	atomic64_t decompress_cnt;
-	atomic64_t decompress_tlen;
-	atomic64_t err_cnt;
-};
-
 /*
  * struct crypto_istat_kpp - statistics for KPP algorithm
  * @setsecret_cnt:		number of setsecrey operation
@@ -416,7 +400,6 @@ struct crypto_istat_rng {
  *
  * @stats: union of all possible crypto_istat_xxx structures
  * @stats.cipher:	statistics for cipher algorithm
- * @stats.compress:	statistics for compress algorithm
  * @stats.rng:		statistics for rng algorithm
  * @stats.kpp:		statistics for KPP algorithm
  *
@@ -455,7 +438,6 @@ struct crypto_alg {
 #ifdef CONFIG_CRYPTO_STATS
 	union {
 		struct crypto_istat_cipher cipher;
-		struct crypto_istat_compress compress;
 		struct crypto_istat_rng rng;
 		struct crypto_istat_kpp kpp;
 	} stats;
@@ -466,8 +448,6 @@ struct crypto_alg {
 #ifdef CONFIG_CRYPTO_STATS
 void crypto_stats_init(struct crypto_alg *alg);
 void crypto_stats_get(struct crypto_alg *alg);
-void crypto_stats_compress(unsigned int slen, int ret, struct crypto_alg *alg);
-void crypto_stats_decompress(unsigned int slen, int ret, struct crypto_alg *alg);
 void crypto_stats_kpp_set_secret(struct crypto_alg *alg, int ret);
 void crypto_stats_kpp_generate_public_key(struct crypto_alg *alg, int ret);
 void crypto_stats_kpp_compute_shared_secret(struct crypto_alg *alg, int ret);
@@ -480,10 +460,6 @@ static inline void crypto_stats_init(struct crypto_alg *alg)
 {}
 static inline void crypto_stats_get(struct crypto_alg *alg)
 {}
-static inline void crypto_stats_compress(unsigned int slen, int ret, struct crypto_alg *alg)
-{}
-static inline void crypto_stats_decompress(unsigned int slen, int ret, struct crypto_alg *alg)
-{}
 static inline void crypto_stats_kpp_set_secret(struct crypto_alg *alg, int ret)
 {}
 static inline void crypto_stats_kpp_generate_public_key(struct crypto_alg *alg, int ret)
