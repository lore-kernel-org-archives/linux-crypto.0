From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v4 04/10] crypto: add quick decompression api
Date: Tue, 31 May 2016 14:55:30 +0100
Message-ID: <1464702936-27627-5-git-send-email-giovanni.cabiddu@intel.com>
References: <1464702936-27627-1-git-send-email-giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:2582 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753893AbcEaNzs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 31 May 2016 09:55:48 -0400
In-Reply-To: <1464702936-27627-1-git-send-email-giovanni.cabiddu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch introduces qdecomp, an asynchronous decompression api.
qdecomp is a front-end for acomp and scomp algorithms which do not
not need additional vmalloc work space for decompression.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 crypto/Makefile                       |    1 +
 crypto/acompress.c                    |   50 ++++++++-
 crypto/qdecompress.c                  |   93 +++++++++++++++
 crypto/scompress.c                    |   92 +++++++++++++++-
 include/crypto/internal/acompress.h   |   15 +++
 include/crypto/internal/qdecompress.h |   22 ++++
 include/crypto/internal/scompress.h   |   14 +++
 include/crypto/qdecompress.h          |  204 +++++++++++++++++++++++++++++++++
 include/linux/crypto.h                |    4 +
 9 files changed, 491 insertions(+), 4 deletions(-)
 create mode 100644 crypto/qdecompress.c
 create mode 100644 include/crypto/internal/qdecompress.h
 create mode 100644 include/crypto/qdecompress.h

diff --git a/crypto/Makefile b/crypto/Makefile
index fc8fcfe..2621451 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -33,6 +33,7 @@ obj-$(CONFIG_CRYPTO_AKCIPHER2) += akcipher.o
 
 obj-$(CONFIG_CRYPTO_ACOMP2) += acompress.o
 obj-$(CONFIG_CRYPTO_ACOMP2) += scompress.o
+obj-$(CONFIG_CRYPTO_ACOMP2) += qdecompress.o
 
 $(obj)/rsapubkey-asn1.o: $(obj)/rsapubkey-asn1.c $(obj)/rsapubkey-asn1.h
 $(obj)/rsaprivkey-asn1.o: $(obj)/rsaprivkey-asn1.c $(obj)/rsaprivkey-asn1.h
diff --git a/crypto/acompress.c b/crypto/acompress.c
index 885d15d..dcc9ddc 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -23,9 +23,10 @@
 #include <net/netlink.h>
 #include <crypto/internal/acompress.h>
 #include <crypto/internal/scompress.h>
+#include <crypto/internal/qdecompress.h>
 #include "internal.h"
 
-static const struct crypto_type crypto_acomp_type;
+const struct crypto_type crypto_acomp_type;
 
 #ifdef CONFIG_NET
 static int crypto_acomp_report(struct sk_buff *skb, struct crypto_alg *alg)
@@ -96,7 +97,39 @@ unsigned int crypto_acomp_extsize(struct crypto_alg *alg)
 	return extsize;
 }
 
-static const struct crypto_type crypto_acomp_type = {
+static void crypto_exit_acomp_ops_nospace(struct crypto_tfm *tfm)
+{
+	struct crypto_tfm **ctx = crypto_tfm_ctx(tfm);
+	struct crypto_acomp *acomp = __crypto_acomp_tfm(*ctx);
+
+	crypto_free_acomp(acomp);
+	*ctx = NULL;
+}
+
+int crypto_init_acomp_ops_nospace(struct crypto_tfm *tfm)
+{
+	struct crypto_alg *calg = tfm->__crt_alg;
+	struct crypto_qdecomp *crt = __crypto_qdecomp_tfm(tfm);
+	struct crypto_tfm **ctx = crypto_tfm_ctx(tfm);
+	struct crypto_acomp *acomp;
+
+	if (!crypto_mod_get(calg))
+		return -EAGAIN;
+
+	acomp = crypto_create_tfm(calg, &crypto_acomp_type);
+	if (IS_ERR(acomp)) {
+		crypto_mod_put(calg);
+		return PTR_ERR(acomp);
+	}
+
+	*ctx = &acomp->base;
+	tfm->exit = crypto_exit_acomp_ops_nospace;
+	crt->decompress = (int (*)(struct qdecomp_req *req))acomp->decompress;
+
+	return 0;
+}
+
+const struct crypto_type crypto_acomp_type = {
 	.extsize = crypto_acomp_extsize,
 	.init_tfm = crypto_acomp_init_tfm,
 #ifdef CONFIG_PROC_FS
@@ -108,6 +141,7 @@ static const struct crypto_type crypto_acomp_type = {
 	.type = CRYPTO_ALG_TYPE_ACOMPRESS,
 	.tfmsize = offsetof(struct crypto_acomp, base),
 };
+EXPORT_SYMBOL_GPL(crypto_acomp_type);
 
 struct crypto_acomp *crypto_alloc_acomp(const char *alg_name, u32 type,
 					u32 mask)
@@ -153,6 +187,18 @@ int crypto_register_acomp(struct acomp_alg *alg)
 }
 EXPORT_SYMBOL_GPL(crypto_register_acomp);
 
+int crypto_register_acomp_qdecomp(struct acomp_alg *alg)
+{
+	struct crypto_alg *base = &alg->base;
+
+	base->cra_type = &crypto_acomp_type;
+	base->cra_flags &= ~CRYPTO_ALG_TYPE_MASK;
+	base->cra_flags |= CRYPTO_ALG_TYPE_ACOMPRESS_QDCMP;
+
+	return crypto_register_alg(base);
+}
+EXPORT_SYMBOL_GPL(crypto_register_acomp_qdecomp);
+
 int crypto_unregister_acomp(struct acomp_alg *alg)
 {
 	return crypto_unregister_alg(&alg->base);
diff --git a/crypto/qdecompress.c b/crypto/qdecompress.c
new file mode 100644
index 0000000..f229016
--- /dev/null
+++ b/crypto/qdecompress.c
@@ -0,0 +1,93 @@
+/*
+ * Quick Decompression operations
+ *
+ * Copyright (c) 2016, Intel Corporation
+ * Authors: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ *
+ */
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/seq_file.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/crypto.h>
+#include <crypto/algapi.h>
+#include <linux/cryptouser.h>
+#include <net/netlink.h>
+#include <crypto/internal/qdecompress.h>
+#include <crypto/internal/acompress.h>
+#include <crypto/internal/scompress.h>
+#include "internal.h"
+
+#ifdef CONFIG_NET
+static int crypto_qdecomp_report(struct sk_buff *skb, struct crypto_alg *alg)
+{
+	struct crypto_report_comp rqdecomp;
+
+	strncpy(rqdecomp.type, "qdecomp", sizeof(rqdecomp.type));
+
+	if (nla_put(skb, CRYPTOCFGA_REPORT_COMPRESS,
+		    sizeof(struct crypto_report_comp), &rqdecomp))
+		goto nla_put_failure;
+	return 0;
+
+nla_put_failure:
+	return -EMSGSIZE;
+}
+#else
+static int crypto_qdecomp_report(struct sk_buff *skb, struct crypto_alg *alg)
+{
+	return -ENOSYS;
+}
+#endif
+
+static void crypto_qdecomp_show(struct seq_file *m, struct crypto_alg *alg)
+	__attribute__ ((unused));
+
+static void crypto_qdecomp_show(struct seq_file *m, struct crypto_alg *alg)
+{
+	seq_puts(m, "type         : qdecomp\n");
+}
+
+static int crypto_qdecomp_init_tfm(struct crypto_tfm *tfm)
+{
+	if (tfm->__crt_alg->cra_type == &crypto_scomp_type)
+		return crypto_init_scomp_ops_nospace(tfm);
+	else if (tfm->__crt_alg->cra_type == &crypto_acomp_type)
+		return crypto_init_acomp_ops_nospace(tfm);
+	else
+		return -EINVAL;
+}
+
+unsigned int crypto_qdecomp_extsize(struct crypto_alg *alg)
+{
+	if (alg->cra_type == &crypto_acomp_type)
+		return crypto_alg_extsize(alg);
+	return sizeof(struct crypto_scomp *);
+}
+
+static const struct crypto_type crypto_qdecomp_type = {
+	.extsize = crypto_qdecomp_extsize,
+	.init_tfm = crypto_qdecomp_init_tfm,
+#ifdef CONFIG_PROC_FS
+	.show = crypto_qdecomp_show,
+#endif
+	.report = crypto_qdecomp_report,
+	.maskclear = ~CRYPTO_ALG_TYPE_MASK,
+	.maskset = CRYPTO_ALG_TYPE_QDECOMP_MASK,
+	.type = CRYPTO_ALG_TYPE_QDECOMPRESS,
+	.tfmsize = offsetof(struct crypto_qdecomp, base),
+};
+
+struct crypto_qdecomp *crypto_alloc_qdecomp(const char *alg_name, u32 type,
+					    u32 mask)
+{
+	return crypto_alloc_tfm(alg_name, &crypto_qdecomp_type, type, mask);
+}
+EXPORT_SYMBOL_GPL(crypto_alloc_qdecomp);
diff --git a/crypto/scompress.c b/crypto/scompress.c
index 5a25e17..faecab8 100644
--- a/crypto/scompress.c
+++ b/crypto/scompress.c
@@ -24,9 +24,10 @@
 #include <crypto/scatterwalk.h>
 #include <crypto/internal/acompress.h>
 #include <crypto/internal/scompress.h>
+#include <crypto/internal/qdecompress.h>
 #include "internal.h"
 
-static const struct crypto_type crypto_scomp_type;
+const struct crypto_type crypto_scomp_type;
 
 #ifdef CONFIG_NET
 static int crypto_scomp_report(struct sk_buff *skb, struct crypto_alg *alg)
@@ -184,6 +185,80 @@ int crypto_init_scomp_ops_async(struct crypto_tfm *tfm)
 	return 0;
 }
 
+static int scomp_qdecomp_decompress(struct qdecomp_req *req)
+{
+	struct crypto_qdecomp *qdecomp = crypto_qdecomp_reqtfm(req);
+	struct crypto_tfm *tfm = crypto_qdecomp_tfm(qdecomp);
+	struct crypto_tfm **ctx = crypto_tfm_ctx(tfm);
+	struct crypto_scomp *scomp = __crypto_scomp_tfm(*ctx);
+	gfp_t gfp_flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
+			  GFP_KERNEL : GFP_ATOMIC;
+	unsigned int slen = req->slen;
+	unsigned int dlen = req->dlen;
+	u8 *src;
+	u8 *dst;
+	int ret;
+
+	src = scomp_map(req->src, slen, gfp_flags);
+	if (!src) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	dst = scomp_map(req->dst, dlen, gfp_flags);
+	if (!dst) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ret = crypto_scomp_decompress(scomp, src, slen, dst, &dlen, NULL);
+
+out:
+	if (ret < 0) {
+		req->consumed = 0;
+		req->produced = 0;
+	} else {
+		req->consumed = slen;
+		req->produced = dlen;
+	}
+	scomp_unmap(req->src, src, 0);
+	scomp_unmap(req->dst, dst, (ret < 0) ? 0 : dlen);
+
+	return ret;
+}
+
+static void crypto_exit_scomp_ops_nospace(struct crypto_tfm *tfm)
+{
+	struct crypto_tfm **ctx = crypto_tfm_ctx(tfm);
+	struct crypto_scomp *scomp = __crypto_scomp_tfm(*ctx);
+
+	crypto_free_scomp(scomp);
+	*ctx = NULL;
+}
+
+int crypto_init_scomp_ops_nospace(struct crypto_tfm *tfm)
+{
+	struct crypto_alg *calg = tfm->__crt_alg;
+	struct crypto_qdecomp *crt = __crypto_qdecomp_tfm(tfm);
+	struct crypto_tfm **ctx = crypto_tfm_ctx(tfm);
+	struct crypto_scomp *scomp;
+
+	if (!crypto_mod_get(calg))
+		return -EAGAIN;
+
+	scomp = crypto_create_tfm(calg, &crypto_scomp_type);
+	if (IS_ERR(scomp)) {
+		crypto_mod_put(calg);
+		return PTR_ERR(scomp);
+	}
+
+	*ctx = &scomp->base;
+	tfm->exit = crypto_exit_scomp_ops_nospace;
+	crt->decompress = scomp_qdecomp_decompress;
+
+	return 0;
+}
+
 struct acomp_req *crypto_acomp_scomp_alloc_ctx(struct acomp_req *req)
 {
 	struct crypto_acomp *acomp = crypto_acomp_reqtfm(req);
@@ -215,7 +290,7 @@ void crypto_acomp_scomp_free_ctx(struct acomp_req *req)
 		crypto_scomp_free_ctx(scomp, ctx);
 }
 
-static const struct crypto_type crypto_scomp_type = {
+const struct crypto_type crypto_scomp_type = {
 	.extsize = crypto_alg_extsize,
 	.init_tfm = crypto_scomp_init_tfm,
 #ifdef CONFIG_PROC_FS
@@ -227,6 +302,7 @@ static const struct crypto_type crypto_scomp_type = {
 	.type = CRYPTO_ALG_TYPE_SCOMPRESS,
 	.tfmsize = offsetof(struct crypto_scomp, base),
 };
+EXPORT_SYMBOL_GPL(crypto_scomp_type);
 
 struct crypto_scomp *crypto_alloc_scomp(const char *alg_name, u32 type,
 					u32 mask)
@@ -247,6 +323,18 @@ int crypto_register_scomp(struct scomp_alg *alg)
 }
 EXPORT_SYMBOL_GPL(crypto_register_scomp);
 
+int crypto_register_scomp_qdecomp(struct scomp_alg *alg)
+{
+	struct crypto_alg *base = &alg->base;
+
+	base->cra_type = &crypto_scomp_type;
+	base->cra_flags &= ~CRYPTO_ALG_TYPE_MASK;
+	base->cra_flags |= CRYPTO_ALG_TYPE_SCOMPRESS_QDCMP;
+
+	return crypto_register_alg(base);
+}
+EXPORT_SYMBOL_GPL(crypto_register_scomp_qdecomp);
+
 int crypto_unregister_scomp(struct scomp_alg *alg)
 {
 	return crypto_unregister_alg(&alg->base);
diff --git a/include/crypto/internal/acompress.h b/include/crypto/internal/acompress.h
index e42ce28..238856e 100644
--- a/include/crypto/internal/acompress.h
+++ b/include/crypto/internal/acompress.h
@@ -55,6 +55,8 @@ static inline void __acomp_request_free(struct acomp_req *req)
 	kzfree(req);
 }
 
+int crypto_init_acomp_ops_nospace(struct crypto_tfm *tfm);
+
 /**
  * crypto_register_acomp() -- Register asynchronous compression algorithm
  *
@@ -68,6 +70,19 @@ static inline void __acomp_request_free(struct acomp_req *req)
 int crypto_register_acomp(struct acomp_alg *alg);
 
 /**
+ * crypto_register_acomp_qdecomp() -- Register asynchronous compression
+ *				      algorithm with support for qdecomp
+ *
+ * Function registers an implementation of an asynchronous
+ * compression algorithm that supports qdecomp
+ *
+ * @alg:   algorithm definition
+ *
+ * Return: zero on success; error code in case of error
+ */
+int crypto_register_acomp_qdecomp(struct acomp_alg *alg);
+
+/**
  * crypto_unregister_acomp() -- Unregister asynchronous compression algorithm
  *
  * Function unregisters an implementation of an asynchronous
diff --git a/include/crypto/internal/qdecompress.h b/include/crypto/internal/qdecompress.h
new file mode 100644
index 0000000..ed3c2d8
--- /dev/null
+++ b/include/crypto/internal/qdecompress.h
@@ -0,0 +1,22 @@
+/*
+ * Quick Decompression operations
+ *
+ * Copyright (c) 2016, Intel Corporation
+ * Authors: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ *
+ */
+#ifndef _CRYPTO_QDECOMP_INT_H
+#define _CRYPTO_QDECOMP_INT_H
+
+#include <crypto/algapi.h>
+#include <crypto/qdecompress.h>
+
+extern const struct crypto_type crypto_acomp_type;
+extern const struct crypto_type crypto_scomp_type;
+
+#endif
diff --git a/include/crypto/internal/scompress.h b/include/crypto/internal/scompress.h
index a88fc8d..07f3162 100644
--- a/include/crypto/internal/scompress.h
+++ b/include/crypto/internal/scompress.h
@@ -104,6 +104,7 @@ static inline int crypto_scomp_decompress(struct crypto_scomp *tfm,
 }
 
 int crypto_init_scomp_ops_async(struct crypto_tfm *tfm);
+int crypto_init_scomp_ops_nospace(struct crypto_tfm *tfm);
 struct acomp_req *crypto_acomp_scomp_alloc_ctx(struct acomp_req *req);
 void crypto_acomp_scomp_free_ctx(struct acomp_req *req);
 
@@ -120,6 +121,19 @@ void crypto_acomp_scomp_free_ctx(struct acomp_req *req);
 int crypto_register_scomp(struct scomp_alg *alg);
 
 /**
+ * crypto_register_scomp_qdecomp() -- Register synchronous compression
+ *				      algorithm with support for qdecomp
+ *
+ * Function registers an implementation of a synchronous
+ * compression algorithm that supports qdecomp
+ *
+ * @alg:	algorithm definition
+ *
+ * Return: zero on success; error code in case of error
+ */
+int crypto_register_scomp_qdecomp(struct scomp_alg *alg);
+
+/**
  * crypto_unregister_scomp() -- Unregister synchronous compression algorithm
  *
  * Function unregisters an implementation of a synchronous
diff --git a/include/crypto/qdecompress.h b/include/crypto/qdecompress.h
new file mode 100644
index 0000000..6dad3b2
--- /dev/null
+++ b/include/crypto/qdecompress.h
@@ -0,0 +1,204 @@
+/*
+ * Quick Decompression operations
+ *
+ * Copyright (c) 2016, Intel Corporation
+ * Authors: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ *
+ */
+#ifndef _CRYPTO_QDECOMP_H
+#define _CRYPTO_QDECOMP_H
+#include <linux/crypto.h>
+
+/**
+ * struct qdecomp_req - decompression request without work space
+ *
+ * @base:     Common attributes for asynchronous crypto requests
+ * @src:      Source Data
+ * @dst:      Destination data
+ * @slen:     Size of the input buffer
+ * @dlen:     Size of the output buffer
+ * @consumed: Number of bytes consumed by the decompressor
+ * @produced: Number of bytes produced by the decompressor
+ */
+struct qdecomp_req {
+	struct crypto_async_request base;
+	struct scatterlist *src;
+	struct scatterlist *dst;
+	unsigned int slen;
+	unsigned int dlen;
+	unsigned int consumed;
+	unsigned int produced;
+};
+
+/**
+ * struct crypto_qdecomp - user-instantiated objects which encapsulate
+ * algorithms and core processing logic
+ *
+ * @decompress: Function performs a decompression operation
+ * @reqsize:	Context size for decompression requests
+ * @base:	Common crypto API algorithm data structure
+ */
+struct crypto_qdecomp {
+	int (*decompress)(struct qdecomp_req *req);
+	struct crypto_tfm base;
+};
+
+/**
+ * DOC: Quick Decompression API
+ *
+ * The Quick Decompression API is used with the algorithms of type
+ * CRYPTO_ALG_TYPE_ACOMPRESS (listed as type "acomp" in /proc/crypto) and
+ * CRYPTO_ALG_TYPE_SCOMPRESS (listed as type "scomp" in /proc/crypto) which
+ * support decompression without work space
+ */
+
+/**
+ * crypto_alloc_qdecomp() -- allocate QDECOMPRESS tfm handle
+ * @alg_name: is the cra_name / name or cra_driver_name / driver name of the
+ *	      decompression algorithm e.g. "deflate"
+ * @type: specifies the type of the algorithm
+ * @mask: specifies the mask for the algorithm
+ *
+ * Allocate a handle for a decompression algorithm. The returned struct
+ * crypto_qdecomp is the handle that is required for any subsequent
+ * API invocation for the decompression operation.
+ *
+ * Return: allocated handle in case of success; IS_ERR() is true in case
+ *	   of an error, PTR_ERR() returns the error code.
+ */
+struct crypto_qdecomp *crypto_alloc_qdecomp(const char *alg_name, u32 type,
+					    u32 mask);
+
+static inline struct crypto_tfm *crypto_qdecomp_tfm(struct crypto_qdecomp *tfm)
+{
+	return &tfm->base;
+}
+
+static inline struct crypto_qdecomp *__crypto_qdecomp_tfm(
+	struct crypto_tfm *tfm)
+{
+	return container_of(tfm, struct crypto_qdecomp, base);
+}
+
+static inline void qdecomp_request_set_tfm(struct qdecomp_req *req,
+					   struct crypto_qdecomp *tfm)
+{
+	req->base.tfm = crypto_qdecomp_tfm(tfm);
+}
+
+static inline struct crypto_qdecomp *crypto_qdecomp_reqtfm(
+	struct qdecomp_req *req)
+{
+	return __crypto_qdecomp_tfm(req->base.tfm);
+}
+
+/**
+ * crypto_free_qdecomp() -- free QDECOMPRESS tfm handle
+ *
+ * @tfm: QDECOMPRESS tfm handle allocated with crypto_alloc_qdecomp()
+ */
+static inline void crypto_free_qdecomp(struct crypto_qdecomp *tfm)
+{
+	crypto_destroy_tfm(tfm, crypto_qdecomp_tfm(tfm));
+}
+
+/**
+ * qdecomp_request_alloc() -- allocates quick decompression request
+ *
+ * @tfm: QDECOMPRESS tfm handle allocated with crypto_alloc_qdecomp()
+ * @gfp: allocation flags
+ *
+ * Return: allocated handle in case of success or NULL in case of an error.
+ */
+static inline struct qdecomp_req *qdecomp_request_alloc(
+	struct crypto_qdecomp *tfm,
+	gfp_t gfp)
+{
+	struct qdecomp_req *req;
+
+	req = kzalloc(sizeof(*req), gfp);
+	if (likely(req))
+		qdecomp_request_set_tfm(req, tfm);
+
+	return req;
+}
+
+/**
+ * qdecomp_request_free() -- zeroize and free quick decompress request
+ *
+ * @req: request to free
+ */
+
+static inline void qdecomp_request_free(struct qdecomp_req *req)
+{
+	kzfree(req);
+}
+
+/**
+ * qdecomp_request_set_callback() -- Sets an asynchronous callback
+ *
+ * Callback will be called when an asynchronous operation on a given
+ * request is finished.
+ *
+ * @req:  request that the callback will be set for
+ * @flgs: specify for instance if the operation may backlog
+ * @cmlp: callback which will be called
+ * @data: private data used by the caller
+ */
+static inline void qdecomp_request_set_callback(struct qdecomp_req *req,
+						u32 flgs,
+						crypto_completion_t cmpl,
+						void *data)
+{
+	req->base.complete = cmpl;
+	req->base.data = data;
+	req->base.flags = flgs;
+}
+
+/**
+ * qdecomp_request_set_params() -- Sets request parameters
+ *
+ * Sets parameters required by a qdecomp operation
+ *
+ * @req:  asynchronous decompression request
+ * @src:  pointer to input buffer scatterlist
+ * @dst:  pointer to output buffer scatterlist
+ * @slen: size of the input buffer
+ * @dlen: size of the output buffer
+ */
+static inline void qdecomp_request_set_params(struct qdecomp_req *req,
+					      struct scatterlist *src,
+					      struct scatterlist *dst,
+					      unsigned int slen,
+					      unsigned int dlen)
+{
+	req->src = src;
+	req->dst = dst;
+	req->slen = slen;
+	req->dlen = dlen;
+	req->consumed = 0;
+	req->produced = 0;
+}
+
+/**
+ * crypto_qdecomp_decompress() -- Invoke asynchronous decompression operation
+ *
+ * Function invokes the asynchronous decompression operation
+ *
+ * @req:   asynchronous decompression request
+ *
+ * Return: zero on success; error code in case of error
+ */
+static inline int crypto_qdecomp_decompress(struct qdecomp_req *req)
+{
+	struct crypto_qdecomp *tfm = crypto_qdecomp_reqtfm(req);
+
+	return tfm->decompress(req);
+}
+
+#endif
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 23ceb0b..916e4f7 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -49,7 +49,10 @@
 #define CRYPTO_ALG_TYPE_ABLKCIPHER	0x00000005
 #define CRYPTO_ALG_TYPE_GIVCIPHER	0x00000006
 #define CRYPTO_ALG_TYPE_ACOMPRESS	0x00000008
+#define CRYPTO_ALG_TYPE_ACOMPRESS_QDCMP	0x00000009
+#define CRYPTO_ALG_TYPE_QDECOMPRESS	0x00000009
 #define CRYPTO_ALG_TYPE_SCOMPRESS	0x0000000a
+#define CRYPTO_ALG_TYPE_SCOMPRESS_QDCMP	0x0000000b
 #define CRYPTO_ALG_TYPE_RNG		0x0000000c
 #define CRYPTO_ALG_TYPE_AKCIPHER	0x0000000d
 #define CRYPTO_ALG_TYPE_DIGEST		0x0000000e
@@ -61,6 +64,7 @@
 #define CRYPTO_ALG_TYPE_AHASH_MASK	0x0000000e
 #define CRYPTO_ALG_TYPE_BLKCIPHER_MASK	0x0000000c
 #define CRYPTO_ALG_TYPE_ACOMPRESS_MASK	0x0000000c
+#define CRYPTO_ALG_TYPE_QDECOMP_MASK	0x0000000d
 
 #define CRYPTO_ALG_LARVAL		0x00000010
 #define CRYPTO_ALG_DEAD			0x00000020
-- 
1.7.4.1
