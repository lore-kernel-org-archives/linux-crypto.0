From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v4 03/10] crypto: add driver-side scomp interface
Date: Tue, 31 May 2016 14:55:29 +0100
Message-ID: <1464702936-27627-4-git-send-email-giovanni.cabiddu@intel.com>
References: <1464702936-27627-1-git-send-email-giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:34154 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753497AbcEaNzs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 31 May 2016 09:55:48 -0400
In-Reply-To: <1464702936-27627-1-git-send-email-giovanni.cabiddu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add a synchronous back-end (scomp) to acomp. This allows to easily expose
the already present compression algorithms in LKCF via acomp

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 crypto/Makefile                     |    1 +
 crypto/acompress.c                  |   49 +++++++-
 crypto/scompress.c                  |  257 +++++++++++++++++++++++++++++++++++
 include/crypto/acompress.h          |   33 ++---
 include/crypto/internal/acompress.h |   16 ++
 include/crypto/internal/scompress.h |  134 ++++++++++++++++++
 include/linux/crypto.h              |    2 +
 7 files changed, 469 insertions(+), 23 deletions(-)
 create mode 100644 crypto/scompress.c
 create mode 100644 include/crypto/internal/scompress.h

diff --git a/crypto/Makefile b/crypto/Makefile
index e817b38..fc8fcfe 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -32,6 +32,7 @@ obj-$(CONFIG_CRYPTO_HASH2) += crypto_hash.o
 obj-$(CONFIG_CRYPTO_AKCIPHER2) += akcipher.o
 
 obj-$(CONFIG_CRYPTO_ACOMP2) += acompress.o
+obj-$(CONFIG_CRYPTO_ACOMP2) += scompress.o
 
 $(obj)/rsapubkey-asn1.o: $(obj)/rsapubkey-asn1.c $(obj)/rsapubkey-asn1.h
 $(obj)/rsaprivkey-asn1.o: $(obj)/rsaprivkey-asn1.c $(obj)/rsaprivkey-asn1.h
diff --git a/crypto/acompress.c b/crypto/acompress.c
index f24fef3..885d15d 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -22,8 +22,11 @@
 #include <linux/cryptouser.h>
 #include <net/netlink.h>
 #include <crypto/internal/acompress.h>
+#include <crypto/internal/scompress.h>
 #include "internal.h"
 
+static const struct crypto_type crypto_acomp_type;
+
 #ifdef CONFIG_NET
 static int crypto_acomp_report(struct sk_buff *skb, struct crypto_alg *alg)
 {
@@ -67,6 +70,13 @@ static int crypto_acomp_init_tfm(struct crypto_tfm *tfm)
 	struct crypto_acomp *acomp = __crypto_acomp_tfm(tfm);
 	struct acomp_alg *alg = crypto_acomp_alg(acomp);
 
+	if (tfm->__crt_alg->cra_type != &crypto_acomp_type)
+		return crypto_init_scomp_ops_async(tfm);
+
+	acomp->compress = alg->compress;
+	acomp->decompress = alg->decompress;
+	acomp->reqsize = alg->reqsize;
+
 	if (alg->exit)
 		acomp->base.exit = crypto_acomp_exit_tfm;
 
@@ -76,15 +86,25 @@ static int crypto_acomp_init_tfm(struct crypto_tfm *tfm)
 	return 0;
 }
 
+unsigned int crypto_acomp_extsize(struct crypto_alg *alg)
+{
+	int extsize = crypto_alg_extsize(alg);
+
+	if (alg->cra_type != &crypto_acomp_type)
+		extsize += sizeof(struct crypto_scomp *);
+
+	return extsize;
+}
+
 static const struct crypto_type crypto_acomp_type = {
-	.extsize = crypto_alg_extsize,
+	.extsize = crypto_acomp_extsize,
 	.init_tfm = crypto_acomp_init_tfm,
 #ifdef CONFIG_PROC_FS
 	.show = crypto_acomp_show,
 #endif
 	.report = crypto_acomp_report,
 	.maskclear = ~CRYPTO_ALG_TYPE_MASK,
-	.maskset = CRYPTO_ALG_TYPE_MASK,
+	.maskset = CRYPTO_ALG_TYPE_ACOMPRESS_MASK,
 	.type = CRYPTO_ALG_TYPE_ACOMPRESS,
 	.tfmsize = offsetof(struct crypto_acomp, base),
 };
@@ -96,6 +116,31 @@ struct crypto_acomp *crypto_alloc_acomp(const char *alg_name, u32 type,
 }
 EXPORT_SYMBOL_GPL(crypto_alloc_acomp);
 
+struct acomp_req *acomp_request_alloc(struct crypto_acomp *acomp, gfp_t gfp)
+{
+	struct crypto_tfm *tfm = crypto_acomp_tfm(acomp);
+	struct acomp_req *req;
+
+	req = __acomp_request_alloc(acomp, gfp);
+	if (req && (tfm->__crt_alg->cra_type != &crypto_acomp_type))
+		return crypto_acomp_scomp_alloc_ctx(req);
+
+	return req;
+}
+EXPORT_SYMBOL_GPL(acomp_request_alloc);
+
+void acomp_request_free(struct acomp_req *req)
+{
+	struct crypto_acomp *acomp = crypto_acomp_reqtfm(req);
+	struct crypto_tfm *tfm = crypto_acomp_tfm(acomp);
+
+	if (tfm->__crt_alg->cra_type != &crypto_acomp_type)
+		crypto_acomp_scomp_free_ctx(req);
+
+	__acomp_request_free(req);
+}
+EXPORT_SYMBOL_GPL(acomp_request_free);
+
 int crypto_register_acomp(struct acomp_alg *alg)
 {
 	struct crypto_alg *base = &alg->base;
diff --git a/crypto/scompress.c b/crypto/scompress.c
new file mode 100644
index 0000000..5a25e17
--- /dev/null
+++ b/crypto/scompress.c
@@ -0,0 +1,257 @@
+/*
+ * Synchronous Compression operations
+ *
+ * Copyright 2015 LG Electronics Inc.
+ * Copyright (c) 2016, Intel Corporation
+ * Author: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
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
+#include <crypto/scatterwalk.h>
+#include <crypto/internal/acompress.h>
+#include <crypto/internal/scompress.h>
+#include "internal.h"
+
+static const struct crypto_type crypto_scomp_type;
+
+#ifdef CONFIG_NET
+static int crypto_scomp_report(struct sk_buff *skb, struct crypto_alg *alg)
+{
+	struct crypto_report_comp rscomp;
+
+	strncpy(rscomp.type, "scomp", sizeof(rscomp.type));
+
+	if (nla_put(skb, CRYPTOCFGA_REPORT_COMPRESS,
+		    sizeof(struct crypto_report_comp), &rscomp))
+		goto nla_put_failure;
+	return 0;
+
+nla_put_failure:
+	return -EMSGSIZE;
+}
+#else
+static int crypto_scomp_report(struct sk_buff *skb, struct crypto_alg *alg)
+{
+	return -ENOSYS;
+}
+#endif
+
+static void crypto_scomp_show(struct seq_file *m, struct crypto_alg *alg)
+	__attribute__ ((unused));
+
+static void crypto_scomp_show(struct seq_file *m, struct crypto_alg *alg)
+{
+	seq_puts(m, "type         : scomp\n");
+}
+
+static int crypto_scomp_init_tfm(struct crypto_tfm *tfm)
+{
+	return 0;
+}
+
+static void *scomp_map(struct scatterlist *sg, unsigned int len,
+		       gfp_t gfp_flags)
+{
+	void *buf;
+
+	if (sg_is_last(sg))
+		return kmap_atomic(sg_page(sg)) + sg->offset;
+
+	buf = kmalloc(len, gfp_flags);
+	if (!buf)
+		return NULL;
+
+	scatterwalk_map_and_copy(buf, sg, 0, len, 0);
+
+	return buf;
+}
+
+static void scomp_unmap(struct scatterlist *sg, void *buf, unsigned int len)
+{
+	if (!buf)
+		return;
+
+	if (sg_is_last(sg)) {
+		kunmap_atomic(buf);
+		return;
+	}
+
+	scatterwalk_map_and_copy(buf, sg, 0, len, 1);
+	kfree(buf);
+}
+
+static int scomp_acomp_comp_decomp(struct acomp_req *req, int comp_dir)
+{
+	struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
+	void **tfm_ctx = acomp_tfm_ctx(tfm);
+	struct crypto_scomp *scomp = *tfm_ctx;
+	gfp_t gfp_flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
+			  GFP_KERNEL : GFP_ATOMIC;
+	void **ctx = acomp_request_ctx(req);
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
+	if (comp_dir)
+		ret = crypto_scomp_compress(scomp, src, slen, dst, &dlen,
+					    *ctx);
+	else
+		ret = crypto_scomp_decompress(scomp, src, slen, dst, &dlen,
+					      *ctx);
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
+static int scomp_acomp_compress(struct acomp_req *req)
+{
+	return scomp_acomp_comp_decomp(req, 1);
+}
+
+static int scomp_acomp_decompress(struct acomp_req *req)
+{
+	return scomp_acomp_comp_decomp(req, 0);
+}
+
+static void crypto_exit_scomp_ops_async(struct crypto_tfm *tfm)
+{
+	struct crypto_scomp **ctx = crypto_tfm_ctx(tfm);
+
+	crypto_free_scomp(*ctx);
+}
+
+int crypto_init_scomp_ops_async(struct crypto_tfm *tfm)
+{
+	struct crypto_alg *calg = tfm->__crt_alg;
+	struct crypto_acomp *crt = __crypto_acomp_tfm(tfm);
+	struct crypto_scomp **ctx = crypto_tfm_ctx(tfm);
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
+	*ctx = scomp;
+	tfm->exit = crypto_exit_scomp_ops_async;
+
+	crt->compress = scomp_acomp_compress;
+	crt->decompress = scomp_acomp_decompress;
+	crt->reqsize = sizeof(void *);
+
+	return 0;
+}
+
+struct acomp_req *crypto_acomp_scomp_alloc_ctx(struct acomp_req *req)
+{
+	struct crypto_acomp *acomp = crypto_acomp_reqtfm(req);
+	struct crypto_tfm *tfm = crypto_acomp_tfm(acomp);
+	struct crypto_scomp **tfm_ctx = crypto_tfm_ctx(tfm);
+	struct crypto_scomp *scomp = *tfm_ctx;
+	void *ctx;
+
+	ctx = crypto_scomp_alloc_ctx(scomp);
+	if (IS_ERR(ctx)) {
+		kfree(req);
+		return NULL;
+	}
+
+	*req->__ctx = ctx;
+
+	return req;
+}
+
+void crypto_acomp_scomp_free_ctx(struct acomp_req *req)
+{
+	struct crypto_acomp *acomp = crypto_acomp_reqtfm(req);
+	struct crypto_tfm *tfm = crypto_acomp_tfm(acomp);
+	struct crypto_scomp **tfm_ctx = crypto_tfm_ctx(tfm);
+	struct crypto_scomp *scomp = *tfm_ctx;
+	void *ctx = *req->__ctx;
+
+	if (ctx)
+		crypto_scomp_free_ctx(scomp, ctx);
+}
+
+static const struct crypto_type crypto_scomp_type = {
+	.extsize = crypto_alg_extsize,
+	.init_tfm = crypto_scomp_init_tfm,
+#ifdef CONFIG_PROC_FS
+	.show = crypto_scomp_show,
+#endif
+	.report = crypto_scomp_report,
+	.maskclear = ~CRYPTO_ALG_TYPE_MASK,
+	.maskset = CRYPTO_ALG_TYPE_MASK,
+	.type = CRYPTO_ALG_TYPE_SCOMPRESS,
+	.tfmsize = offsetof(struct crypto_scomp, base),
+};
+
+struct crypto_scomp *crypto_alloc_scomp(const char *alg_name, u32 type,
+					u32 mask)
+{
+	return crypto_alloc_tfm(alg_name, &crypto_scomp_type, type, mask);
+}
+EXPORT_SYMBOL_GPL(crypto_alloc_scomp);
+
+int crypto_register_scomp(struct scomp_alg *alg)
+{
+	struct crypto_alg *base = &alg->base;
+
+	base->cra_type = &crypto_scomp_type;
+	base->cra_flags &= ~CRYPTO_ALG_TYPE_MASK;
+	base->cra_flags |= CRYPTO_ALG_TYPE_SCOMPRESS;
+
+	return crypto_register_alg(base);
+}
+EXPORT_SYMBOL_GPL(crypto_register_scomp);
+
+int crypto_unregister_scomp(struct scomp_alg *alg)
+{
+	return crypto_unregister_alg(&alg->base);
+}
+EXPORT_SYMBOL_GPL(crypto_unregister_scomp);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Synchronous compression type");
diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index 8162b48..7830658 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -42,9 +42,15 @@ struct acomp_req {
  * struct crypto_acomp - user-instantiated objects which encapsulate
  * algorithms and core processing logic
  *
- * @base: Common crypto API algorithm data structure
+ * @compress:   Function performs a compress operation
+ * @decompress: Function performs a de-compress operation
+ * @reqsize:	Context size for (de)compression requests
+ * @base:	Common crypto API algorithm data structure
  */
 struct crypto_acomp {
+	int (*compress)(struct acomp_req *req);
+	int (*decompress)(struct acomp_req *req);
+	unsigned int reqsize;
 	struct crypto_tfm base;
 };
 
@@ -123,7 +129,7 @@ static inline struct acomp_alg *crypto_acomp_alg(struct crypto_acomp *tfm)
 
 static inline unsigned int crypto_acomp_reqsize(struct crypto_acomp *tfm)
 {
-	return crypto_acomp_alg(tfm)->reqsize;
+	return tfm->reqsize;
 }
 
 static inline void acomp_request_set_tfm(struct acomp_req *req,
@@ -155,27 +161,14 @@ static inline void crypto_free_acomp(struct crypto_acomp *tfm)
  *
  * Return: allocated handle in case of success or NULL in case of an error.
  */
-static inline struct acomp_req *acomp_request_alloc(struct crypto_acomp *tfm,
-						    gfp_t gfp)
-{
-	struct acomp_req *req;
-
-	req = kzalloc(sizeof(*req) + crypto_acomp_reqsize(tfm), gfp);
-	if (likely(req))
-		acomp_request_set_tfm(req, tfm);
-
-	return req;
-}
+struct acomp_req *acomp_request_alloc(struct crypto_acomp *tfm, gfp_t gfp);
 
 /**
  * acomp_request_free() -- zeroize and free asynchronous (de)compression request
  *
  * @req: request to free
  */
-static inline void acomp_request_free(struct acomp_req *req)
-{
-	kzfree(req);
-}
+void acomp_request_free(struct acomp_req *req);
 
 /**
  * acomp_request_set_callback() -- Sets an asynchronous callback
@@ -235,9 +228,8 @@ static inline void acomp_request_set_params(struct acomp_req *req,
 static inline int crypto_acomp_compress(struct acomp_req *req)
 {
 	struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
-	struct acomp_alg *alg = crypto_acomp_alg(tfm);
 
-	return alg->compress(req);
+	return tfm->compress(req);
 }
 
 /**
@@ -252,9 +244,8 @@ static inline int crypto_acomp_compress(struct acomp_req *req)
 static inline int crypto_acomp_decompress(struct acomp_req *req)
 {
 	struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
-	struct acomp_alg *alg = crypto_acomp_alg(tfm);
 
-	return alg->decompress(req);
+	return tfm->decompress(req);
 }
 
 #endif
diff --git a/include/crypto/internal/acompress.h b/include/crypto/internal/acompress.h
index 294f2ee..e42ce28 100644
--- a/include/crypto/internal/acompress.h
+++ b/include/crypto/internal/acompress.h
@@ -39,6 +39,22 @@ static inline const char *acomp_alg_name(struct crypto_acomp *tfm)
 	return crypto_acomp_tfm(tfm)->__crt_alg->cra_name;
 }
 
+static inline struct acomp_req *__acomp_request_alloc(struct crypto_acomp *tfm,
+						      gfp_t gfp)
+{
+	struct acomp_req *req;
+
+	req = kzalloc(sizeof(*req) + crypto_acomp_reqsize(tfm), gfp);
+	if (likely(req))
+		acomp_request_set_tfm(req, tfm);
+	return req;
+}
+
+static inline void __acomp_request_free(struct acomp_req *req)
+{
+	kzfree(req);
+}
+
 /**
  * crypto_register_acomp() -- Register asynchronous compression algorithm
  *
diff --git a/include/crypto/internal/scompress.h b/include/crypto/internal/scompress.h
new file mode 100644
index 0000000..a88fc8d
--- /dev/null
+++ b/include/crypto/internal/scompress.h
@@ -0,0 +1,134 @@
+/*
+ * Synchronous Compression operations
+ *
+ * Copyright 2015 LG Electronics Inc.
+ * Copyright (c) 2016, Intel Corporation
+ * Author: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ *
+ */
+#ifndef _CRYPTO_SCOMP_INT_H
+#define _CRYPTO_SCOMP_INT_H
+#include <linux/crypto.h>
+
+struct crypto_scomp {
+	struct crypto_tfm base;
+};
+
+/**
+ * struct scomp_alg - synchronous compression algorithm
+ *
+ * @alloc_ctx:	Function allocates algorithm specific context
+ * @free_ctx:	Function frees context allocated with alloc_ctx
+ * @compress:	Function performs a compress operation
+ * @decompress:	Function performs a de-compress operation
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
+ * @base:	Common crypto API algorithm data structure
+ */
+struct scomp_alg {
+	void *(*alloc_ctx)(struct crypto_scomp *tfm);
+	void (*free_ctx)(struct crypto_scomp *tfm, void *ctx);
+	int (*compress)(struct crypto_scomp *tfm, const u8 *src,
+			unsigned int slen, u8 *dst, unsigned int *dlen,
+			void *ctx);
+	int (*decompress)(struct crypto_scomp *tfm, const u8 *src,
+			  unsigned int slen, u8 *dst, unsigned int *dlen,
+			  void *ctx);
+	struct crypto_alg base;
+};
+
+static inline struct scomp_alg *__crypto_scomp_alg(struct crypto_alg *alg)
+{
+	return container_of(alg, struct scomp_alg, base);
+}
+
+static inline struct crypto_scomp *__crypto_scomp_tfm(struct crypto_tfm *tfm)
+{
+	return container_of(tfm, struct crypto_scomp, base);
+}
+
+static inline struct crypto_tfm *crypto_scomp_tfm(struct crypto_scomp *tfm)
+{
+	return &tfm->base;
+}
+
+static inline void crypto_free_scomp(struct crypto_scomp *tfm)
+{
+	crypto_destroy_tfm(tfm, crypto_scomp_tfm(tfm));
+}
+
+static inline struct scomp_alg *crypto_scomp_alg(struct crypto_scomp *tfm)
+{
+	return __crypto_scomp_alg(crypto_scomp_tfm(tfm)->__crt_alg);
+}
+
+static inline void *crypto_scomp_alloc_ctx(struct crypto_scomp *tfm)
+{
+	return crypto_scomp_alg(tfm)->alloc_ctx(tfm);
+}
+
+static inline void crypto_scomp_free_ctx(struct crypto_scomp *tfm,
+					 void *ctx)
+{
+	return crypto_scomp_alg(tfm)->free_ctx(tfm, ctx);
+}
+
+static inline int crypto_scomp_compress(struct crypto_scomp *tfm,
+					const u8 *src, unsigned int slen,
+					u8 *dst, unsigned int *dlen, void *ctx)
+{
+	return crypto_scomp_alg(tfm)->compress(tfm, src, slen, dst, dlen, ctx);
+}
+
+static inline int crypto_scomp_decompress(struct crypto_scomp *tfm,
+					  const u8 *src, unsigned int slen,
+					  u8 *dst, unsigned int *dlen,
+					  void *ctx)
+{
+	return crypto_scomp_alg(tfm)->decompress(tfm, src, slen, dst, dlen,
+						 ctx);
+}
+
+int crypto_init_scomp_ops_async(struct crypto_tfm *tfm);
+struct acomp_req *crypto_acomp_scomp_alloc_ctx(struct acomp_req *req);
+void crypto_acomp_scomp_free_ctx(struct acomp_req *req);
+
+/**
+ * crypto_register_scomp() -- Register synchronous compression algorithm
+ *
+ * Function registers an implementation of a synchronous
+ * compression algorithm
+ *
+ * @alg:	algorithm definition
+ *
+ * Return: zero on success; error code in case of error
+ */
+int crypto_register_scomp(struct scomp_alg *alg);
+
+/**
+ * crypto_unregister_scomp() -- Unregister synchronous compression algorithm
+ *
+ * Function unregisters an implementation of a synchronous
+ * compression algorithm
+ *
+ * @alg:	algorithm definition
+ *
+ * Return: zero on success; error code in case of error
+ */
+int crypto_unregister_scomp(struct scomp_alg *alg);
+
+#endif
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 7987323..23ceb0b 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -49,6 +49,7 @@
 #define CRYPTO_ALG_TYPE_ABLKCIPHER	0x00000005
 #define CRYPTO_ALG_TYPE_GIVCIPHER	0x00000006
 #define CRYPTO_ALG_TYPE_ACOMPRESS	0x00000008
+#define CRYPTO_ALG_TYPE_SCOMPRESS	0x0000000a
 #define CRYPTO_ALG_TYPE_RNG		0x0000000c
 #define CRYPTO_ALG_TYPE_AKCIPHER	0x0000000d
 #define CRYPTO_ALG_TYPE_DIGEST		0x0000000e
@@ -59,6 +60,7 @@
 #define CRYPTO_ALG_TYPE_HASH_MASK	0x0000000e
 #define CRYPTO_ALG_TYPE_AHASH_MASK	0x0000000e
 #define CRYPTO_ALG_TYPE_BLKCIPHER_MASK	0x0000000c
+#define CRYPTO_ALG_TYPE_ACOMPRESS_MASK	0x0000000c
 
 #define CRYPTO_ALG_LARVAL		0x00000010
 #define CRYPTO_ALG_DEAD			0x00000020
-- 
1.7.4.1
