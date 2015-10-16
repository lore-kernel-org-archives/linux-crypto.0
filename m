From: Weigang Li <weigang.li@intel.com>
Subject: [PATCH] crypto: add asynchronous compression support
Date: Fri, 16 Oct 2015 23:11:00 +0800
Message-ID: <1445008260-39367-1-git-send-email-weigang.li@intel.com>
Cc: linux-crypto@vger.kernel.org, tadeusz.struk@intel.com,
	Weigang Li <weigang.li@intel.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:28959 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932393AbbJPPLU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 16 Oct 2015 11:11:20 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch set introduces Asynchronous Compression API.
What is proposed is a new crypto type called crypto_acomp_type, 
plus new struct acomp_alg and struct crypto_acomp, together with number 
of helper functions to register acomp type algorithms and allocate tfm 
instances. This is to make it similar to how the existing crypto API 
works for the ablkcipher, and akcipher types.
The operations the new interface will provide are:

	int (*compress)(struct acompress_request *req);
	int (*decompress)(struct acompress_request *req);

The benefits it gives interface are:
- the new interface allows for asynchronous implementations and
  scatterlist buffer that can use hardware to offload the compression
  operations, the new asynchronous API can be called by the linux kernel
  components (i.e., btrfs) who want to use hardware acceleration for data
  compression.

New helper functions have been added to allocate crypto_acomp instances 
and invoke the operations to make it easier to use.

Signed-off-by: Weigang Li <weigang.li@intel.com>
---
 crypto/Kconfig                      |    5 +
 crypto/Makefile                     |    1 +
 crypto/acompress.c                  |  116 ++++++++++++++++
 crypto/crypto_user.c                |   21 +++
 include/crypto/acompress.h          |  251 +++++++++++++++++++++++++++++++++++
 include/crypto/internal/acompress.h |   62 +++++++++
 include/linux/crypto.h              |    1 +
 include/uapi/linux/cryptouser.h     |    5 +
 8 files changed, 462 insertions(+), 0 deletions(-)
 create mode 100644 crypto/acompress.c
 create mode 100644 include/crypto/acompress.h
 create mode 100644 include/crypto/internal/acompress.h

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 7240821..8b8d2d6 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -93,6 +93,10 @@ config CRYPTO_PCOMP2
 	tristate
 	select CRYPTO_ALGAPI2
 
+config CRYPTO_ACOMP2
+        tristate
+        select CRYPTO_ALGAPI2
+
 config CRYPTO_AKCIPHER2
 	tristate
 	select CRYPTO_ALGAPI2
@@ -123,6 +127,7 @@ config CRYPTO_MANAGER2
 	select CRYPTO_HASH2
 	select CRYPTO_BLKCIPHER2
 	select CRYPTO_PCOMP2
+	select CRYPTO_ACOMP2
 	select CRYPTO_AKCIPHER2
 
 config CRYPTO_USER
diff --git a/crypto/Makefile b/crypto/Makefile
index f7aba92..6ad718f 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -29,6 +29,7 @@ crypto_hash-y += shash.o
 obj-$(CONFIG_CRYPTO_HASH2) += crypto_hash.o
 
 obj-$(CONFIG_CRYPTO_PCOMP2) += pcompress.o
+obj-$(CONFIG_CRYPTO_ACOMP2) += acompress.o
 obj-$(CONFIG_CRYPTO_AKCIPHER2) += akcipher.o
 
 $(obj)/rsapubkey-asn1.o: $(obj)/rsapubkey-asn1.c $(obj)/rsapubkey-asn1.h
diff --git a/crypto/acompress.c b/crypto/acompress.c
new file mode 100644
index 0000000..0becbf1
--- /dev/null
+++ b/crypto/acompress.c
@@ -0,0 +1,116 @@
+/*
+ * Asynchronous compression operations
+ *
+ * Copyright (c) 2015, Intel Corporation
+ * Authors: Weigang Li <weigang.li@intel.com>
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
+#include <crypto/acompress.h>
+#include "internal.h"
+
+#ifdef CONFIG_NET
+static int crypto_acompress_report(struct sk_buff *skb, struct crypto_alg *alg)
+{
+	struct crypto_report_acomp racomp;
+
+	strncpy(racomp.type, "acompress", sizeof(racomp.type));
+
+	if (nla_put(skb, CRYPTOCFGA_REPORT_ACOMPRESS,
+		    sizeof(struct crypto_report_acomp), &racomp))
+		goto nla_put_failure;
+	return 0;
+
+nla_put_failure:
+	return -EMSGSIZE;
+}
+#else
+static int crypto_acompress_report(struct sk_buff *skb, struct crypto_alg *alg)
+{
+	return -ENOSYS;
+}
+#endif
+
+static void crypto_acompress_show(struct seq_file *m, struct crypto_alg *alg)
+	__attribute__ ((unused));
+
+static void crypto_acompress_show(struct seq_file *m, struct crypto_alg *alg)
+{
+	seq_puts(m, "type         : acompress\n");
+}
+
+static void crypto_acompress_exit_tfm(struct crypto_tfm *tfm)
+{
+	struct crypto_acomp *acomp = __crypto_acomp_tfm(tfm);
+	struct acomp_alg *alg = crypto_acomp_alg(acomp);
+
+	alg->exit(acomp);
+}
+
+static int crypto_acompress_init_tfm(struct crypto_tfm *tfm)
+{
+	struct crypto_acomp *acomp = __crypto_acomp_tfm(tfm);
+	struct acomp_alg *alg = crypto_acomp_alg(acomp);
+
+	if (alg->exit)
+		acomp->base.exit = crypto_acompress_exit_tfm;
+
+	if (alg->init)
+		return alg->init(acomp);
+
+	return 0;
+}
+
+static const struct crypto_type crypto_acomp_type = {
+	.extsize = crypto_alg_extsize,
+	.init_tfm = crypto_acompress_init_tfm,
+#ifdef CONFIG_PROC_FS
+	.show = crypto_acompress_show,
+#endif
+	.report = crypto_acompress_report,
+	.maskclear = ~CRYPTO_ALG_TYPE_MASK,
+	.maskset = CRYPTO_ALG_TYPE_MASK,
+	.type = CRYPTO_ALG_TYPE_ACOMPRESS,
+	.tfmsize = offsetof(struct crypto_acomp, base),
+};
+
+struct crypto_acomp *crypto_alloc_acomp(const char *alg_name, u32 type,
+					u32 mask)
+{
+	return crypto_alloc_tfm(alg_name, &crypto_acomp_type, type, mask);
+}
+EXPORT_SYMBOL_GPL(crypto_alloc_acomp);
+
+int crypto_register_acomp(struct acomp_alg *alg)
+{
+	struct crypto_alg *base = &alg->base;
+
+	base->cra_type = &crypto_acomp_type;
+	base->cra_flags &= ~CRYPTO_ALG_TYPE_MASK;
+	base->cra_flags |= CRYPTO_ALG_TYPE_ACOMPRESS;
+	return crypto_register_alg(base);
+}
+EXPORT_SYMBOL_GPL(crypto_register_acomp);
+
+void crypto_unregister_acomp(struct acomp_alg *alg)
+{
+	crypto_unregister_alg(&alg->base);
+}
+EXPORT_SYMBOL_GPL(crypto_unregister_acomp);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Async compression type");
diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
index d94d99f..f8a3729 100644
--- a/crypto/crypto_user.c
+++ b/crypto/crypto_user.c
@@ -111,6 +111,21 @@ nla_put_failure:
 	return -EMSGSIZE;
 }
 
+static int crypto_report_acomp(struct sk_buff *skb, struct crypto_alg *alg)
+{
+	struct crypto_report_acomp racomp;
+
+	strncpy(racomp.type, "acompression", sizeof(racomp.type));
+
+	if (nla_put(skb, CRYPTOCFGA_REPORT_ACOMPRESS,
+		    sizeof(struct crypto_report_acomp), &racomp))
+		goto nla_put_failure;
+	return 0;
+
+nla_put_failure:
+	return -EMSGSIZE;
+}
+
 static int crypto_report_akcipher(struct sk_buff *skb, struct crypto_alg *alg)
 {
 	struct crypto_report_akcipher rakcipher;
@@ -171,6 +186,12 @@ static int crypto_report_one(struct crypto_alg *alg,
 
 		break;
 
+	case CRYPTO_ALG_TYPE_ACOMPRESS:
+		if (crypto_report_acomp(skb, alg))
+			goto nla_put_failure;
+
+		break;
+
 	case CRYPTO_ALG_TYPE_AKCIPHER:
 		if (crypto_report_akcipher(skb, alg))
 			goto nla_put_failure;
diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
new file mode 100644
index 0000000..2b3d6d1
--- /dev/null
+++ b/include/crypto/acompress.h
@@ -0,0 +1,251 @@
+/*
+ * Asynchronous compression operations
+ *
+ * Copyright (c) 2015, Intel Corporation
+ * Authors: Weigang Li <weigang.li@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ *
+ */
+#ifndef _CRYPTO_ACOMP_H
+#define _CRYPTO_ACOMP_H
+#include <linux/crypto.h>
+
+/**
+ * struct acompress_request - asynchronous compression request
+ *
+ * @base:	Common attributes for async crypto requests
+ * @nbytes:	Number of bytes to be processed
+ * @src:	Pointer to memory containing the input scatterlist buffer
+ * @dst:	Pointer to memory containing the output scatterlist buffer
+ * @__ctx:	Start of private context data
+ */
+struct acompress_request {
+	struct crypto_async_request base;
+	unsigned int nbytes;
+	struct scatterlist *src;
+	struct scatterlist *dst;
+	void *__ctx[] CRYPTO_MINALIGN_ATTR;
+};
+
+/**
+ * struct crypto_acomp - user-instantiated objects which encapsulate
+ * algorithms and core processing logic
+ *
+ * @base:	Common crypto API algorithm data structure
+ */
+struct crypto_acomp {
+	struct crypto_tfm base;
+};
+
+/**
+ * struct acomp_alg - async compression algorithm
+ *
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
+ *
+ * @reqsize:	Request size required by algorithm implementation
+ * @base:	Common crypto API algorithm data structure
+ */
+struct acomp_alg {
+	int (*compress)(struct acompress_request *req);
+	int (*decompress)(struct acompress_request *req);
+	int (*init)(struct crypto_acomp *tfm);
+	void (*exit)(struct crypto_acomp *tfm);
+	unsigned int reqsize;
+	struct crypto_alg base;
+};
+
+/**
+ * DOC: Asynchronous Compression API
+ *
+ * The Asynchronous Compression API is used with the algorithms of type
+ * CRYPTO_ALG_TYPE_ACOMPRESS (listed as type "acompress" in /proc/crypto)
+ */
+
+/**
+ * crypto_alloc_acompress() -- allocate ACOMPRESS tfm handle
+ * @alg_name: is the cra_name / name or cra_driver_name / driver name of the
+ *	      compression algorithm e.g. "deflate"
+ * @type: specifies the type of the algorithm
+ * @mask: specifies the mask for the algorithm
+ *
+ * Allocate a handle for compression algorithm. The returned struct
+ * crypto_acomp is the handle that is required for any subsequent
+ * API invocation for the compression operations.
+ *
+ * Return: allocated handle in case of success; IS_ERR() is true in case
+ *	   of an error, PTR_ERR() returns the error code.
+ */
+struct crypto_acomp *crypto_alloc_acomp(const char *alg_name, u32 type,
+					u32 mask);
+
+static inline struct crypto_tfm *crypto_acomp_tfm(struct crypto_acomp *tfm)
+{
+	return &tfm->base;
+}
+
+static inline struct acomp_alg *__crypto_acomp_alg(struct crypto_alg *alg)
+{
+	return container_of(alg, struct acomp_alg, base);
+}
+
+static inline struct crypto_acomp *__crypto_acomp_tfm(
+	struct crypto_tfm *tfm)
+{
+	return container_of(tfm, struct crypto_acomp, base);
+}
+
+static inline struct acomp_alg *crypto_acomp_alg(
+	struct crypto_acomp *tfm)
+{
+	return __crypto_acomp_alg(crypto_acomp_tfm(tfm)->__crt_alg);
+}
+
+static inline unsigned int crypto_acomp_reqsize(struct crypto_acomp *tfm)
+{
+	return crypto_acomp_alg(tfm)->reqsize;
+}
+
+static inline void acomp_request_set_tfm(struct acompress_request *req,
+					 struct crypto_acomp *tfm)
+{
+	req->base.tfm = crypto_acomp_tfm(tfm);
+}
+
+static inline struct crypto_acomp *crypto_acomp_reqtfm(
+				struct acompress_request *req)
+{
+	return __crypto_acomp_tfm(req->base.tfm);
+}
+
+/**
+ * crypto_free_acomp() -- free ACOMPRESS tfm handle
+ *
+ * @tfm: ACOMPRESS tfm handle allocated with crypto_alloc_acompr()
+ */
+static inline void crypto_free_acomp(struct crypto_acomp *tfm)
+{
+	crypto_destroy_tfm(tfm, crypto_acomp_tfm(tfm));
+}
+
+/**
+ * acomp_request_alloc() -- allocates async compress request
+ *
+ * @tfm:	ACOMPRESS tfm handle allocated with crypto_alloc_acomp()
+ * @gfp:	allocation flags
+ *
+ * Return: allocated handle in case of success or NULL in case of an error.
+ */
+static inline struct acompress_request *acomp_request_alloc(
+	struct crypto_acomp *tfm, gfp_t gfp)
+{
+	struct acompress_request *req;
+
+	req = kzalloc(sizeof(*req) + crypto_acomp_reqsize(tfm), gfp);
+	if (likely(req))
+		acomp_request_set_tfm(req, tfm);
+
+	return req;
+}
+
+/**
+ * acomp_request_free() -- zeroize and free async compress request
+ *
+ * @req:	request to free
+ */
+static inline void acomp_request_free(struct acompress_request *req)
+{
+	kfree(req);
+}
+
+/**
+ * acomp_request_set_callback() -- Sets an asynchronous callback.
+ *
+ * Callback will be called when an asynchronous operation on a given
+ * request is finished.
+ *
+ * @req:	request that the callback will be set for
+ * @flgs:	specify for instance if the operation may backlog
+ * @cmlp:	callback which will be called
+ * @data:	private data used by the caller
+ */
+static inline void acomp_request_set_callback(struct acompress_request *req,
+					      u32 flgs,
+					      crypto_completion_t cmpl,
+					      void *data)
+{
+	req->base.complete = cmpl;
+	req->base.data = data;
+	req->base.flags = flgs;
+}
+
+/**
+ * acomp_request_set_comp() -- Sets reqest parameters
+ *
+ * Sets parameters required by acomp operation
+ *
+ * @req:	async compress request
+ * @src:	ptr to input buffer list
+ * @dst:	ptr of output buffer list
+ * @nbytes:	size of the input buffer
+ */
+static inline void acomp_request_set_comp(struct acompress_request *req,
+					  struct scatterlist *src,
+					  struct scatterlist *dst,
+					  unsigned int nbytes)
+{
+	req->src = src;
+	req->dst = dst;
+	req->nbytes = nbytes;
+}
+
+/**
+ * crypto_acomp_compress() -- Invoke async compress operation
+ *
+ * Function invokes the async compress operation
+ *
+ * @req:	async compress request
+ *
+ * Return: zero on success; error code in case of error
+ */
+static inline int crypto_acomp_compress(struct acompress_request *req)
+{
+	struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
+	struct acomp_alg *alg = crypto_acomp_alg(tfm);
+
+	return alg->compress(req);
+}
+
+/**
+ * crypto_acomp_decompress() -- Invoke async decompress operation
+ *
+ * Function invokes the async decompress operation
+ *
+ * @req:	async compress request
+ *
+ * Return: zero on success; error code in case of error
+ */
+static inline int crypto_acomp_decompress(struct acompress_request *req)
+{
+	struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
+	struct acomp_alg *alg = crypto_acomp_alg(tfm);
+
+	return alg->decompress(req);
+}
+
+#endif
diff --git a/include/crypto/internal/acompress.h b/include/crypto/internal/acompress.h
new file mode 100644
index 0000000..036f62b
--- /dev/null
+++ b/include/crypto/internal/acompress.h
@@ -0,0 +1,62 @@
+/*
+ * Asynchronous compression
+ *
+ * Copyright (c) 2015, Intel Corporation
+ * Authors: Weigang Li <weigang.li@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ *
+ */
+#ifndef _CRYPTO_ACOMP_INT_H
+#define _CRYPTO_ACOMP_INT_H
+#include <crypto/acompress.h>
+
+/*
+ * Transform internal helpers.
+ */
+static inline void *acomp_request_ctx(struct acompress_request *req)
+{
+	return req->__ctx;
+}
+
+static inline void *acomp_tfm_ctx(struct crypto_acomp *tfm)
+{
+	return tfm->base.__crt_ctx;
+}
+
+static inline void acomp_request_complete(struct acompress_request *req,
+					  int err)
+{
+	req->base.complete(&req->base, err);
+}
+
+static inline const char *acomp_alg_name(struct crypto_acomp *tfm)
+{
+	return crypto_acomp_tfm(tfm)->__crt_alg->cra_name;
+}
+
+/**
+ * crypto_register_acomp() -- Register asynchronous compression algorithm
+ *
+ * Function registers an implementation of a asynchronous
+ * compression algorithm
+ *
+ * @alg:	algorithm definition
+ *
+ * Return: zero on success; error code in case of error
+ */
+int crypto_register_acomp(struct acomp_alg *alg);
+
+/**
+ * crypto_unregister_acomp() -- Unregister asynchronous compression algorithm
+ *
+ * Function unregisters an implementation of a asynchronous
+ * compression algorithm
+ *
+ * @alg:	algorithm definition
+ */
+void crypto_unregister_acomp(struct acomp_alg *alg);
+#endif
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index e71cb70..f051dac 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -54,6 +54,7 @@
 #define CRYPTO_ALG_TYPE_AHASH		0x0000000a
 #define CRYPTO_ALG_TYPE_RNG		0x0000000c
 #define CRYPTO_ALG_TYPE_AKCIPHER	0x0000000d
+#define CRYPTO_ALG_TYPE_ACOMPRESS	0x0000000e
 #define CRYPTO_ALG_TYPE_PCOMPRESS	0x0000000f
 
 #define CRYPTO_ALG_TYPE_HASH_MASK	0x0000000e
diff --git a/include/uapi/linux/cryptouser.h b/include/uapi/linux/cryptouser.h
index 2e67bb6..7cf256e 100644
--- a/include/uapi/linux/cryptouser.h
+++ b/include/uapi/linux/cryptouser.h
@@ -42,6 +42,7 @@ enum crypto_attr_type_t {
 	CRYPTOCFGA_REPORT_BLKCIPHER,	/* struct crypto_report_blkcipher */
 	CRYPTOCFGA_REPORT_AEAD,		/* struct crypto_report_aead */
 	CRYPTOCFGA_REPORT_COMPRESS,	/* struct crypto_report_comp */
+	CRYPTOCFGA_REPORT_ACOMPRESS,	/* struct crypto_report_acomp */
 	CRYPTOCFGA_REPORT_RNG,		/* struct crypto_report_rng */
 	CRYPTOCFGA_REPORT_CIPHER,	/* struct crypto_report_cipher */
 	CRYPTOCFGA_REPORT_AKCIPHER,	/* struct crypto_report_akcipher */
@@ -98,6 +99,10 @@ struct crypto_report_comp {
 	char type[CRYPTO_MAX_NAME];
 };
 
+struct crypto_report_acomp {
+	char type[CRYPTO_MAX_NAME];
+};
+
 struct crypto_report_rng {
 	char type[CRYPTO_MAX_NAME];
 	unsigned int seedsize;
-- 
1.7.7.6
