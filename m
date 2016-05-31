From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v4 02/10] crypto: add asynchronous compression api
Date: Tue, 31 May 2016 14:55:28 +0100
Message-ID: <1464702936-27627-3-git-send-email-giovanni.cabiddu@intel.com>
References: <1464702936-27627-1-git-send-email-giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:21500 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753034AbcEaNzs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 31 May 2016 09:55:48 -0400
In-Reply-To: <1464702936-27627-1-git-send-email-giovanni.cabiddu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch introduces acomp, an asynchronous compression api that uses
scatterlist buffers.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 crypto/Kconfig                      |   10 ++
 crypto/Makefile                     |    2 +
 crypto/acompress.c                  |  118 ++++++++++++++++
 crypto/crypto_user.c                |   21 +++
 include/crypto/acompress.h          |  260 +++++++++++++++++++++++++++++++++++
 include/crypto/internal/acompress.h |   66 +++++++++
 include/linux/crypto.h              |    1 +
 7 files changed, 478 insertions(+), 0 deletions(-)
 create mode 100644 crypto/acompress.c
 create mode 100644 include/crypto/acompress.h
 create mode 100644 include/crypto/internal/acompress.h

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 1d33beb..24fef55 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -93,6 +93,15 @@ config CRYPTO_AKCIPHER
 	select CRYPTO_AKCIPHER2
 	select CRYPTO_ALGAPI
 
+config CRYPTO_ACOMP
+	tristate
+	select CRYPTO_ACOMP2
+	select CRYPTO_ALGAPI
+
+config CRYPTO_ACOMP2
+	tristate
+	select CRYPTO_ALGAPI2
+
 config CRYPTO_RSA
 	tristate "RSA algorithm"
 	select CRYPTO_AKCIPHER
@@ -115,6 +124,7 @@ config CRYPTO_MANAGER2
 	select CRYPTO_HASH2
 	select CRYPTO_BLKCIPHER2
 	select CRYPTO_AKCIPHER2
+	select CRYPTO_ACOMP2
 
 config CRYPTO_USER
 	tristate "Userspace cryptographic algorithm configuration"
diff --git a/crypto/Makefile b/crypto/Makefile
index 4f4ef7e..e817b38 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -31,6 +31,8 @@ obj-$(CONFIG_CRYPTO_HASH2) += crypto_hash.o
 
 obj-$(CONFIG_CRYPTO_AKCIPHER2) += akcipher.o
 
+obj-$(CONFIG_CRYPTO_ACOMP2) += acompress.o
+
 $(obj)/rsapubkey-asn1.o: $(obj)/rsapubkey-asn1.c $(obj)/rsapubkey-asn1.h
 $(obj)/rsaprivkey-asn1.o: $(obj)/rsaprivkey-asn1.c $(obj)/rsaprivkey-asn1.h
 clean-files += rsapubkey-asn1.c rsapubkey-asn1.h
diff --git a/crypto/acompress.c b/crypto/acompress.c
new file mode 100644
index 0000000..f24fef3
--- /dev/null
+++ b/crypto/acompress.c
@@ -0,0 +1,118 @@
+/*
+ * Asynchronous Compression operations
+ *
+ * Copyright (c) 2016, Intel Corporation
+ * Authors: Weigang Li <weigang.li@intel.com>
+ *          Giovanni Cabiddu <giovanni.cabiddu@intel.com>
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
+#include <crypto/internal/acompress.h>
+#include "internal.h"
+
+#ifdef CONFIG_NET
+static int crypto_acomp_report(struct sk_buff *skb, struct crypto_alg *alg)
+{
+	struct crypto_report_comp racomp;
+
+	strncpy(racomp.type, "acomp", sizeof(racomp.type));
+
+	if (nla_put(skb, CRYPTOCFGA_REPORT_COMPRESS,
+		    sizeof(struct crypto_report_comp), &racomp))
+		goto nla_put_failure;
+	return 0;
+
+nla_put_failure:
+	return -EMSGSIZE;
+}
+#else
+static int crypto_acomp_report(struct sk_buff *skb, struct crypto_alg *alg)
+{
+	return -ENOSYS;
+}
+#endif
+
+static void crypto_acomp_show(struct seq_file *m, struct crypto_alg *alg)
+	__attribute__ ((unused));
+
+static void crypto_acomp_show(struct seq_file *m, struct crypto_alg *alg)
+{
+	seq_puts(m, "type         : acomp\n");
+}
+
+static void crypto_acomp_exit_tfm(struct crypto_tfm *tfm)
+{
+	struct crypto_acomp *acomp = __crypto_acomp_tfm(tfm);
+	struct acomp_alg *alg = crypto_acomp_alg(acomp);
+
+	alg->exit(acomp);
+}
+
+static int crypto_acomp_init_tfm(struct crypto_tfm *tfm)
+{
+	struct crypto_acomp *acomp = __crypto_acomp_tfm(tfm);
+	struct acomp_alg *alg = crypto_acomp_alg(acomp);
+
+	if (alg->exit)
+		acomp->base.exit = crypto_acomp_exit_tfm;
+
+	if (alg->init)
+		return alg->init(acomp);
+
+	return 0;
+}
+
+static const struct crypto_type crypto_acomp_type = {
+	.extsize = crypto_alg_extsize,
+	.init_tfm = crypto_acomp_init_tfm,
+#ifdef CONFIG_PROC_FS
+	.show = crypto_acomp_show,
+#endif
+	.report = crypto_acomp_report,
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
+
+	return crypto_register_alg(base);
+}
+EXPORT_SYMBOL_GPL(crypto_register_acomp);
+
+int crypto_unregister_acomp(struct acomp_alg *alg)
+{
+	return crypto_unregister_alg(&alg->base);
+}
+EXPORT_SYMBOL_GPL(crypto_unregister_acomp);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Asynchronous compression type");
diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
index f71960d..80401d9 100644
--- a/crypto/crypto_user.c
+++ b/crypto/crypto_user.c
@@ -111,6 +111,21 @@ nla_put_failure:
 	return -EMSGSIZE;
 }
 
+static int crypto_report_acomp(struct sk_buff *skb, struct crypto_alg *alg)
+{
+	struct crypto_report_acomp racomp;
+
+	strncpy(racomp.type, "acomp", sizeof(racomp.type));
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
index 0000000..8162b48
--- /dev/null
+++ b/include/crypto/acompress.h
@@ -0,0 +1,260 @@
+/*
+ * Asynchronous Compression operations
+ *
+ * Copyright (c) 2016, Intel Corporation
+ * Authors: Weigang Li <weigang.li@intel.com>
+ *          Giovanni Cabiddu <giovanni.cabiddu@intel.com>
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
+ * struct acomp_req - asynchronous (de)compression request
+ *
+ * @base:     Common attributes for asynchronous crypto requests
+ * @src:      Source Data
+ * @dst:      Destination data
+ * @slen:     Size of the input buffer
+ * @dlen:     Size of the output buffer
+ * @consumed: Number of bytes consumed by the (de)compressor
+ * @produced: Number of bytes produced by the (de)compressor
+ * @__ctx:    Start of private context data
+ */
+struct acomp_req {
+	struct crypto_async_request base;
+	struct scatterlist *src;
+	struct scatterlist *dst;
+	unsigned int slen;
+	unsigned int dlen;
+	unsigned int consumed;
+	unsigned int produced;
+	void *__ctx[] CRYPTO_MINALIGN_ATTR;
+};
+
+/**
+ * struct crypto_acomp - user-instantiated objects which encapsulate
+ * algorithms and core processing logic
+ *
+ * @base: Common crypto API algorithm data structure
+ */
+struct crypto_acomp {
+	struct crypto_tfm base;
+};
+
+/**
+ * struct acomp_alg - asynchronous compression algorithm
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
+ * @reqsize:	Context size for (de)compression requests
+ * @base:	Common crypto API algorithm data structure
+ */
+struct acomp_alg {
+	int (*compress)(struct acomp_req *req);
+	int (*decompress)(struct acomp_req *req);
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
+ * CRYPTO_ALG_TYPE_ACOMPRESS (listed as type "acomp" in /proc/crypto)
+ */
+
+/**
+ * crypto_alloc_acomp() -- allocate ACOMPRESS tfm handle
+ * @alg_name: is the cra_name / name or cra_driver_name / driver name of the
+ *	      compression algorithm e.g. "deflate"
+ * @type: specifies the type of the algorithm
+ * @mask: specifies the mask for the algorithm
+ *
+ * Allocate a handle for a compression algorithm. The returned struct
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
+static inline struct crypto_acomp *__crypto_acomp_tfm(struct crypto_tfm *tfm)
+{
+	return container_of(tfm, struct crypto_acomp, base);
+}
+
+static inline struct acomp_alg *crypto_acomp_alg(struct crypto_acomp *tfm)
+{
+	return __crypto_acomp_alg(crypto_acomp_tfm(tfm)->__crt_alg);
+}
+
+static inline unsigned int crypto_acomp_reqsize(struct crypto_acomp *tfm)
+{
+	return crypto_acomp_alg(tfm)->reqsize;
+}
+
+static inline void acomp_request_set_tfm(struct acomp_req *req,
+					 struct crypto_acomp *tfm)
+{
+	req->base.tfm = crypto_acomp_tfm(tfm);
+}
+
+static inline struct crypto_acomp *crypto_acomp_reqtfm(struct acomp_req *req)
+{
+	return __crypto_acomp_tfm(req->base.tfm);
+}
+
+/**
+ * crypto_free_acomp() -- free ACOMPRESS tfm handle
+ *
+ * @tfm: ACOMPRESS tfm handle allocated with crypto_alloc_acomp()
+ */
+static inline void crypto_free_acomp(struct crypto_acomp *tfm)
+{
+	crypto_destroy_tfm(tfm, crypto_acomp_tfm(tfm));
+}
+
+/**
+ * acomp_request_alloc() -- allocates asynchronous (de)compression request
+ *
+ * @tfm: ACOMPRESS tfm handle allocated with crypto_alloc_acomp()
+ * @gfp: allocation flags
+ *
+ * Return: allocated handle in case of success or NULL in case of an error.
+ */
+static inline struct acomp_req *acomp_request_alloc(struct crypto_acomp *tfm,
+						    gfp_t gfp)
+{
+	struct acomp_req *req;
+
+	req = kzalloc(sizeof(*req) + crypto_acomp_reqsize(tfm), gfp);
+	if (likely(req))
+		acomp_request_set_tfm(req, tfm);
+
+	return req;
+}
+
+/**
+ * acomp_request_free() -- zeroize and free asynchronous (de)compression request
+ *
+ * @req: request to free
+ */
+static inline void acomp_request_free(struct acomp_req *req)
+{
+	kzfree(req);
+}
+
+/**
+ * acomp_request_set_callback() -- Sets an asynchronous callback
+ *
+ * Callback will be called when an asynchronous operation on a given
+ * request is finished.
+ *
+ * @req:  request that the callback will be set for
+ * @flgs: specify for instance if the operation may backlog
+ * @cmlp: callback which will be called
+ * @data: private data used by the caller
+ */
+static inline void acomp_request_set_callback(struct acomp_req *req,
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
+ * acomp_request_set_params() -- Sets request parameters
+ *
+ * Sets parameters required by an acomp operation
+ *
+ * @req:  asynchronous compress request
+ * @src:  pointer to input buffer scatterlist
+ * @dst:  pointer to output buffer scatterlist
+ * @slen: size of the input buffer
+ * @dlen: size of the output buffer
+ */
+static inline void acomp_request_set_params(struct acomp_req *req,
+					    struct scatterlist *src,
+					    struct scatterlist *dst,
+					    unsigned int slen,
+					    unsigned int dlen)
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
+ * crypto_acomp_compress() -- Invoke asynchronous compress operation
+ *
+ * Function invokes the asynchronous compress operation
+ *
+ * @req: asynchronous compress request
+ *
+ * Return: zero on success; error code in case of error
+ */
+static inline int crypto_acomp_compress(struct acomp_req *req)
+{
+	struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
+	struct acomp_alg *alg = crypto_acomp_alg(tfm);
+
+	return alg->compress(req);
+}
+
+/**
+ * crypto_acomp_decompress() -- Invoke asynchronous decompress operation
+ *
+ * Function invokes the asynchronous decompress operation
+ *
+ * @req: asynchronous compress request
+ *
+ * Return: zero on success; error code in case of error
+ */
+static inline int crypto_acomp_decompress(struct acomp_req *req)
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
index 0000000..294f2ee
--- /dev/null
+++ b/include/crypto/internal/acompress.h
@@ -0,0 +1,66 @@
+/*
+ * Asynchronous Compression operations
+ *
+ * Copyright (c) 2016, Intel Corporation
+ * Authors: Weigang Li <weigang.li@intel.com>
+ *          Giovanni Cabiddu <giovanni.cabiddu@intel.com>
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
+static inline void *acomp_request_ctx(struct acomp_req *req)
+{
+	return req->__ctx;
+}
+
+static inline void *acomp_tfm_ctx(struct crypto_acomp *tfm)
+{
+	return tfm->base.__crt_ctx;
+}
+
+static inline void acomp_request_complete(struct acomp_req *req,
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
+ * Function registers an implementation of an asynchronous
+ * compression algorithm
+ *
+ * @alg:   algorithm definition
+ *
+ * Return: zero on success; error code in case of error
+ */
+int crypto_register_acomp(struct acomp_alg *alg);
+
+/**
+ * crypto_unregister_acomp() -- Unregister asynchronous compression algorithm
+ *
+ * Function unregisters an implementation of an asynchronous
+ * compression algorithm
+ *
+ * @alg:   algorithm definition
+ *
+ * Return: zero on success; error code in case of error
+ */
+int crypto_unregister_acomp(struct acomp_alg *alg);
+
+#endif
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index d844cbc..7987323 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -48,6 +48,7 @@
 #define CRYPTO_ALG_TYPE_BLKCIPHER	0x00000004
 #define CRYPTO_ALG_TYPE_ABLKCIPHER	0x00000005
 #define CRYPTO_ALG_TYPE_GIVCIPHER	0x00000006
+#define CRYPTO_ALG_TYPE_ACOMPRESS	0x00000008
 #define CRYPTO_ALG_TYPE_RNG		0x0000000c
 #define CRYPTO_ALG_TYPE_AKCIPHER	0x0000000d
 #define CRYPTO_ALG_TYPE_DIGEST		0x0000000e
-- 
1.7.4.1
