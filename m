From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v10 2/8] crypto: add driver-side scomp interface
Date: Fri, 21 Oct 2016 13:19:48 +0100
Message-ID: <1477052394-19826-3-git-send-email-giovanni.cabiddu@intel.com>
References: <1477052394-19826-1-git-send-email-giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:27712 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932702AbcJUMUJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Oct 2016 08:20:09 -0400
In-Reply-To: <1477052394-19826-1-git-send-email-giovanni.cabiddu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add a synchronous back-end (scomp) to acomp. This allows to easily
expose the already present compression algorithms in LKCF via acomp.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 crypto/Makefile                     |   1 +
 crypto/acompress.c                  |  55 +++++-
 crypto/scompress.c                  | 356 ++++++++++++++++++++++++++++++++++++
 include/crypto/acompress.h          |  42 ++---
 include/crypto/internal/acompress.h |  15 ++
 include/crypto/internal/scompress.h | 136 ++++++++++++++
 include/linux/crypto.h              |   2 +
 7 files changed, 578 insertions(+), 29 deletions(-)
 create mode 100644 crypto/scompress.c
 create mode 100644 include/crypto/internal/scompress.h

diff --git a/crypto/Makefile b/crypto/Makefile
index 0933dc6..5c83f3d 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -51,6 +51,7 @@ rsa_generic-y += rsa-pkcs1pad.o
 obj-$(CONFIG_CRYPTO_RSA) += rsa_generic.o
 
 obj-$(CONFIG_CRYPTO_ACOMP2) += acompress.o
+obj-$(CONFIG_CRYPTO_ACOMP2) += scompress.o
 
 cryptomgr-y := algboss.o testmgr.o
 
diff --git a/crypto/acompress.c b/crypto/acompress.c
index 4977279..887783d 100644
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
@@ -67,6 +70,14 @@ static int crypto_acomp_init_tfm(struct crypto_tfm *tfm)
 	struct crypto_acomp *acomp = __crypto_acomp_tfm(tfm);
 	struct acomp_alg *alg = crypto_acomp_alg(acomp);
 
+	if (tfm->__crt_alg->cra_type != &crypto_acomp_type)
+		return crypto_init_scomp_ops_async(tfm);
+
+	acomp->compress = alg->compress;
+	acomp->decompress = alg->decompress;
+	acomp->dst_free = alg->dst_free;
+	acomp->reqsize = alg->reqsize;
+
 	if (alg->exit)
 		acomp->base.exit = crypto_acomp_exit_tfm;
 
@@ -76,15 +87,25 @@ static int crypto_acomp_init_tfm(struct crypto_tfm *tfm)
 	return 0;
 }
 
+static unsigned int crypto_acomp_extsize(struct crypto_alg *alg)
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
@@ -96,6 +117,36 @@ struct crypto_acomp *crypto_alloc_acomp(const char *alg_name, u32 type,
 }
 EXPORT_SYMBOL_GPL(crypto_alloc_acomp);
 
+struct acomp_req *acomp_request_alloc(struct crypto_acomp *acomp)
+{
+	struct crypto_tfm *tfm = crypto_acomp_tfm(acomp);
+	struct acomp_req *req;
+
+	req = __acomp_request_alloc(acomp);
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
+	if (req->flags & CRYPTO_ACOMP_ALLOC_OUTPUT) {
+		acomp->dst_free(req->dst);
+		req->dst = NULL;
+	}
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
index 0000000..35e396d
--- /dev/null
+++ b/crypto/scompress.c
@@ -0,0 +1,356 @@
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
+#include <linux/vmalloc.h>
+#include <crypto/algapi.h>
+#include <linux/cryptouser.h>
+#include <net/netlink.h>
+#include <linux/scatterlist.h>
+#include <crypto/scatterwalk.h>
+#include <crypto/internal/acompress.h>
+#include <crypto/internal/scompress.h>
+#include "internal.h"
+
+static const struct crypto_type crypto_scomp_type;
+static void * __percpu *scomp_src_scratches;
+static void * __percpu *scomp_dst_scratches;
+static int scomp_scratch_users;
+static DEFINE_MUTEX(scomp_lock);
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
+static void crypto_scomp_free_scratches(void * __percpu *scratches)
+{
+	int i;
+
+	if (!scratches)
+		return;
+
+	for_each_possible_cpu(i)
+		vfree(*per_cpu_ptr(scratches, i));
+
+	free_percpu(scratches);
+}
+
+static void * __percpu *crypto_scomp_alloc_scratches(void)
+{
+	void * __percpu *scratches;
+	int i;
+
+	scratches = alloc_percpu(void *);
+	if (!scratches)
+		return NULL;
+
+	for_each_possible_cpu(i) {
+		void *scratch;
+
+		scratch = vmalloc_node(SCOMP_SCRATCH_SIZE, cpu_to_node(i));
+		if (!scratch)
+			goto error;
+		*per_cpu_ptr(scratches, i) = scratch;
+	}
+
+	return scratches;
+
+error:
+	crypto_scomp_free_scratches(scratches);
+	return NULL;
+}
+
+static void crypto_scomp_free_all_scratches(void)
+{
+	if (!--scomp_scratch_users) {
+		crypto_scomp_free_scratches(scomp_src_scratches);
+		crypto_scomp_free_scratches(scomp_dst_scratches);
+		scomp_src_scratches = NULL;
+		scomp_dst_scratches = NULL;
+	}
+}
+
+static int crypto_scomp_alloc_all_scratches(void)
+{
+	if (!scomp_scratch_users++) {
+		scomp_src_scratches = crypto_scomp_alloc_scratches();
+		if (!scomp_src_scratches)
+			return -ENOMEM;
+		scomp_dst_scratches = crypto_scomp_alloc_scratches();
+		if (!scomp_dst_scratches)
+			return -ENOMEM;
+	}
+	return 0;
+}
+
+static void crypto_scomp_sg_free(struct scatterlist *sgl)
+{
+	int i, n;
+	struct page *page;
+
+	if (!sgl)
+		return;
+
+	n = sg_nents(sgl);
+	for_each_sg(sgl, sgl, n, i) {
+		page = sg_page(sgl);
+		if (page)
+			__free_page(page);
+	}
+
+	kfree(sgl);
+}
+
+static struct scatterlist *crypto_scomp_sg_alloc(size_t size, gfp_t gfp)
+{
+	struct scatterlist *sgl;
+	struct page *page;
+	int i, n;
+
+	n = ((size - 1) >> PAGE_SHIFT) + 1;
+
+	sgl = kmalloc_array(n, sizeof(struct scatterlist), gfp);
+	if (!sgl)
+		return NULL;
+
+	sg_init_table(sgl, n);
+
+	for (i = 0; i < n; i++) {
+		page = alloc_page(gfp);
+		if (!page)
+			goto err;
+		sg_set_page(sgl + i, page, PAGE_SIZE, 0);
+	}
+
+	return sgl;
+
+err:
+	sg_mark_end(sgl + i);
+	crypto_scomp_sg_free(sgl);
+	return NULL;
+}
+
+static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
+{
+	struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
+	void **tfm_ctx = acomp_tfm_ctx(tfm);
+	struct crypto_scomp *scomp = *tfm_ctx;
+	void **ctx = acomp_request_ctx(req);
+	const int cpu = get_cpu();
+	u8 *scratch_src = *per_cpu_ptr(scomp_src_scratches, cpu);
+	u8 *scratch_dst = *per_cpu_ptr(scomp_dst_scratches, cpu);
+	int ret;
+
+	if (!req->src || !req->slen || req->slen > SCOMP_SCRATCH_SIZE) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (req->dst && !req->dlen) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (!req->dlen || req->dlen > SCOMP_SCRATCH_SIZE)
+		req->dlen = SCOMP_SCRATCH_SIZE;
+
+	scatterwalk_map_and_copy(scratch_src, req->src, 0, req->slen, 0);
+	if (dir)
+		ret = crypto_scomp_compress(scomp, scratch_src, req->slen,
+					    scratch_dst, &req->dlen, *ctx);
+	else
+		ret = crypto_scomp_decompress(scomp, scratch_src, req->slen,
+					      scratch_dst, &req->dlen, *ctx);
+	if (!ret) {
+		if (!req->dst) {
+			req->dst = crypto_scomp_sg_alloc(req->dlen,
+				   req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ?
+				   GFP_KERNEL : GFP_ATOMIC);
+			if (!req->dst)
+				goto out;
+		}
+		scatterwalk_map_and_copy(scratch_dst, req->dst, 0, req->dlen,
+					 1);
+	}
+out:
+	put_cpu();
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
+	crt->dst_free = crypto_scomp_sg_free;
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
+int crypto_register_scomp(struct scomp_alg *alg)
+{
+	struct crypto_alg *base = &alg->base;
+	int ret = -ENOMEM;
+
+	mutex_lock(&scomp_lock);
+	if (crypto_scomp_alloc_all_scratches())
+		goto error;
+
+	base->cra_type = &crypto_scomp_type;
+	base->cra_flags &= ~CRYPTO_ALG_TYPE_MASK;
+	base->cra_flags |= CRYPTO_ALG_TYPE_SCOMPRESS;
+
+	ret = crypto_register_alg(base);
+	if (ret)
+		goto error;
+
+	mutex_unlock(&scomp_lock);
+	return ret;
+
+error:
+	crypto_scomp_free_all_scratches();
+	mutex_unlock(&scomp_lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(crypto_register_scomp);
+
+int crypto_unregister_scomp(struct scomp_alg *alg)
+{
+	int ret;
+
+	mutex_lock(&scomp_lock);
+	ret = crypto_unregister_alg(&alg->base);
+	crypto_scomp_free_all_scratches();
+	mutex_unlock(&scomp_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(crypto_unregister_scomp);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Synchronous compression type");
diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index 14c70d8..e328b52 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -42,9 +42,18 @@ struct acomp_req {
  * struct crypto_acomp - user-instantiated objects which encapsulate
  * algorithms and core processing logic
  *
- * @base:	Common crypto API algorithm data structure
+ * @compress:		Function performs a compress operation
+ * @decompress:		Function performs a de-compress operation
+ * @dst_free:		Frees destination buffer if allocated inside the
+ *			algorithm
+ * @reqsize:		Context size for (de)compression requests
+ * @base:		Common crypto API algorithm data structure
  */
 struct crypto_acomp {
+	int (*compress)(struct acomp_req *req);
+	int (*decompress)(struct acomp_req *req);
+	void (*dst_free)(struct scatterlist *dst);
+	unsigned int reqsize;
 	struct crypto_tfm base;
 };
 
@@ -125,7 +134,7 @@ static inline struct acomp_alg *crypto_acomp_alg(struct crypto_acomp *tfm)
 
 static inline unsigned int crypto_acomp_reqsize(struct crypto_acomp *tfm)
 {
-	return crypto_acomp_alg(tfm)->reqsize;
+	return tfm->reqsize;
 }
 
 static inline void acomp_request_set_tfm(struct acomp_req *req,
@@ -165,16 +174,7 @@ static inline int crypto_has_acomp(const char *alg_name, u32 type, u32 mask)
  *
  * Return:	allocated handle in case of success or NULL in case of an error
  */
-static inline struct acomp_req *acomp_request_alloc(struct crypto_acomp *tfm)
-{
-	struct acomp_req *req;
-
-	req = kzalloc(sizeof(*req) + crypto_acomp_reqsize(tfm), GFP_KERNEL);
-	if (likely(req))
-		acomp_request_set_tfm(req, tfm);
-
-	return req;
-}
+struct acomp_req *acomp_request_alloc(struct crypto_acomp *tfm);
 
 /**
  * acomp_request_free() -- zeroize and free asynchronous (de)compression
@@ -183,17 +183,7 @@ static inline struct acomp_req *acomp_request_alloc(struct crypto_acomp *tfm)
  *
  * @req:	request to free
  */
-static inline void acomp_request_free(struct acomp_req *req)
-{
-	struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
-	struct acomp_alg *alg = crypto_acomp_alg(tfm);
-
-	if (req->flags & CRYPTO_ACOMP_ALLOC_OUTPUT) {
-		alg->dst_free(req->dst);
-		req->dst = NULL;
-	}
-	kzfree(req);
-}
+void acomp_request_free(struct acomp_req *req);
 
 /**
  * acomp_request_set_callback() -- Sets an asynchronous callback
@@ -256,9 +246,8 @@ static inline void acomp_request_set_params(struct acomp_req *req,
 static inline int crypto_acomp_compress(struct acomp_req *req)
 {
 	struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
-	struct acomp_alg *alg = crypto_acomp_alg(tfm);
 
-	return alg->compress(req);
+	return tfm->compress(req);
 }
 
 /**
@@ -273,9 +262,8 @@ static inline int crypto_acomp_compress(struct acomp_req *req)
 static inline int crypto_acomp_decompress(struct acomp_req *req)
 {
 	struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
-	struct acomp_alg *alg = crypto_acomp_alg(tfm);
 
-	return alg->decompress(req);
+	return tfm->decompress(req);
 }
 
 #endif
diff --git a/include/crypto/internal/acompress.h b/include/crypto/internal/acompress.h
index a9a9000..1de2b5a 100644
--- a/include/crypto/internal/acompress.h
+++ b/include/crypto/internal/acompress.h
@@ -39,6 +39,21 @@ static inline const char *acomp_alg_name(struct crypto_acomp *tfm)
 	return crypto_acomp_tfm(tfm)->__crt_alg->cra_name;
 }
 
+static inline struct acomp_req *__acomp_request_alloc(struct crypto_acomp *tfm)
+{
+	struct acomp_req *req;
+
+	req = kzalloc(sizeof(*req) + crypto_acomp_reqsize(tfm), GFP_KERNEL);
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
index 0000000..3fda3c5
--- /dev/null
+++ b/include/crypto/internal/scompress.h
@@ -0,0 +1,136 @@
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
+#define SCOMP_SCRATCH_SIZE	131072
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
index dc57a05..8348d83 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -51,6 +51,7 @@
 #define CRYPTO_ALG_TYPE_GIVCIPHER	0x00000006
 #define CRYPTO_ALG_TYPE_KPP		0x00000008
 #define CRYPTO_ALG_TYPE_ACOMPRESS	0x0000000a
+#define CRYPTO_ALG_TYPE_SCOMPRESS	0x0000000b
 #define CRYPTO_ALG_TYPE_RNG		0x0000000c
 #define CRYPTO_ALG_TYPE_AKCIPHER	0x0000000d
 #define CRYPTO_ALG_TYPE_DIGEST		0x0000000e
@@ -61,6 +62,7 @@
 #define CRYPTO_ALG_TYPE_HASH_MASK	0x0000000e
 #define CRYPTO_ALG_TYPE_AHASH_MASK	0x0000000e
 #define CRYPTO_ALG_TYPE_BLKCIPHER_MASK	0x0000000c
+#define CRYPTO_ALG_TYPE_ACOMPRESS_MASK	0x0000000e
 
 #define CRYPTO_ALG_LARVAL		0x00000010
 #define CRYPTO_ALG_DEAD			0x00000020
-- 
2.4.11
