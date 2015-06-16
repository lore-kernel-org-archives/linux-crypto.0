From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH RFC v6 1/3] crypto: add PKE API
Date: Tue, 16 Jun 2015 01:01:59 -0700
Message-ID: <20150616080159.447.30041.stgit@tstruk-mobl1>
References: <20150616080153.447.83834.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
	jwboyer@redhat.com, smueller@chronox.de, richard@nod.at,
	tadeusz.struk@intel.com, steved@redhat.com, qat-linux@intel.com,
	dhowells@redhat.com, linux-crypto@vger.kernel.org,
	james.l.morris@oracle.com, jkosina@suse.cz,
	zohar@linux.vnet.ibm.com, davem@davemloft.net, vgoyal@redhat.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:21116 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754325AbbFPICE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Jun 2015 04:02:04 -0400
In-Reply-To: <20150616080153.447.83834.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add Public Key Encryption API.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 crypto/Kconfig                     |   11 +
 crypto/Makefile                    |    1 
 crypto/akcipher.c                  |  100 +++++++++++
 crypto/crypto_user.c               |   22 ++
 include/crypto/akcipher.h          |  323 ++++++++++++++++++++++++++++++++++++
 include/crypto/internal/akcipher.h |   66 +++++++
 include/linux/crypto.h             |    1 
 include/linux/cryptouser.h         |    5 +
 8 files changed, 529 insertions(+)
 create mode 100644 crypto/akcipher.c
 create mode 100644 include/crypto/akcipher.h
 create mode 100644 include/crypto/internal/akcipher.h

diff --git a/crypto/Kconfig b/crypto/Kconfig
index f6fc054..264dadb 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -91,6 +91,17 @@ config CRYPTO_PCOMP2
 	tristate
 	select CRYPTO_ALGAPI2
 
+config CRYPTO_AKCIPHER2
+	tristate
+	select CRYPTO_ALGAPI2
+
+config CRYPTO_AKCIPHER
+	tristate "Public Key Algorithms API"
+	select CRYPTO_AKCIPHER2
+	select CRYPTO_ALGAPI
+	help
+	  Crypto API interface for public key algorithms.
+
 config CRYPTO_MANAGER
 	tristate "Cryptographic algorithm manager"
 	select CRYPTO_MANAGER2
diff --git a/crypto/Makefile b/crypto/Makefile
index c842035..6f2940a 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -28,6 +28,7 @@ crypto_hash-y += shash.o
 obj-$(CONFIG_CRYPTO_HASH2) += crypto_hash.o
 
 obj-$(CONFIG_CRYPTO_PCOMP2) += pcompress.o
+obj-$(CONFIG_CRYPTO_AKCIPHER) += akcipher.o
 
 cryptomgr-y := algboss.o testmgr.o
 
diff --git a/crypto/akcipher.c b/crypto/akcipher.c
new file mode 100644
index 0000000..eefcc49
--- /dev/null
+++ b/crypto/akcipher.c
@@ -0,0 +1,100 @@
+/*
+ * Public Key Encryption
+ *
+ * Copyright (c) 2015, Intel Corporation
+ * Authors: Tadeusz Struk <tadeusz.struk@intel.com>
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
+#include <crypto/akcipher.h>
+#include <crypto/public_key.h>
+#include "internal.h"
+
+#ifdef CONFIG_NET
+static int crypto_akcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
+{
+	struct crypto_report_akcipher rakcipher;
+
+	strncpy(rakcipher.type, "akcipher", sizeof(rakcipher.type));
+
+	if (nla_put(skb, CRYPTOCFGA_REPORT_AKCIPHER,
+		    sizeof(struct crypto_report_akcipher), &rakcipher))
+		goto nla_put_failure;
+	return 0;
+
+nla_put_failure:
+	return -EMSGSIZE;
+}
+#else
+static int crypto_akcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
+{
+	return -ENOSYS;
+}
+#endif
+
+static void crypto_akcipher_show(struct seq_file *m, struct crypto_alg *alg)
+	__attribute__ ((unused));
+
+static void crypto_akcipher_show(struct seq_file *m, struct crypto_alg *alg)
+{
+	seq_puts(m, "type         : akcipher\n");
+}
+
+static int crypto_akcipher_init_tfm(struct crypto_tfm *tfm)
+{
+	return 0;
+}
+
+static const struct crypto_type crypto_akcipher_type = {
+	.extsize = crypto_alg_extsize,
+	.init_tfm = crypto_akcipher_init_tfm,
+#ifdef CONFIG_PROC_FS
+	.show = crypto_akcipher_show,
+#endif
+	.report = crypto_akcipher_report,
+	.maskclear = ~CRYPTO_ALG_TYPE_MASK,
+	.maskset = CRYPTO_ALG_TYPE_MASK,
+	.type = CRYPTO_ALG_TYPE_AKCIPHER,
+	.tfmsize = offsetof(struct crypto_akcipher, base),
+};
+
+struct crypto_akcipher *crypto_alloc_akcipher(const char *alg_name, u32 type,
+					      u32 mask)
+{
+	return crypto_alloc_tfm(alg_name, &crypto_akcipher_type, type, mask);
+}
+EXPORT_SYMBOL_GPL(crypto_alloc_akcipher);
+
+int crypto_register_akcipher(struct akcipher_alg *alg)
+{
+	struct crypto_alg *base = &alg->base;
+
+	base->cra_type = &crypto_akcipher_type;
+	base->cra_flags &= ~CRYPTO_ALG_TYPE_MASK;
+	base->cra_flags |= CRYPTO_ALG_TYPE_AKCIPHER;
+	return crypto_register_alg(base);
+}
+EXPORT_SYMBOL_GPL(crypto_register_akcipher);
+
+void crypto_unregister_akcipher(struct akcipher_alg *alg)
+{
+	crypto_unregister_alg(&alg->base);
+}
+EXPORT_SYMBOL_GPL(crypto_unregister_akcipher);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Generic public key cihper type");
diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
index 41dfe76..11dbd5a 100644
--- a/crypto/crypto_user.c
+++ b/crypto/crypto_user.c
@@ -27,6 +27,7 @@
 #include <net/net_namespace.h>
 #include <crypto/internal/aead.h>
 #include <crypto/internal/skcipher.h>
+#include <crypto/akcipher.h>
 
 #include "internal.h"
 
@@ -110,6 +111,21 @@ nla_put_failure:
 	return -EMSGSIZE;
 }
 
+static int crypto_report_akcipher(struct sk_buff *skb, struct crypto_alg *alg)
+{
+	struct crypto_report_akcipher rakcipher;
+
+	strncpy(rakcipher.type, "akcipher", sizeof(rakcipher.type));
+
+	if (nla_put(skb, CRYPTOCFGA_REPORT_AKCIPHER,
+		    sizeof(struct crypto_report_akcipher), &rakcipher))
+		goto nla_put_failure;
+	return 0;
+
+nla_put_failure:
+	return -EMSGSIZE;
+}
+
 static int crypto_report_one(struct crypto_alg *alg,
 			     struct crypto_user_alg *ualg, struct sk_buff *skb)
 {
@@ -154,6 +170,12 @@ static int crypto_report_one(struct crypto_alg *alg,
 			goto nla_put_failure;
 
 		break;
+
+	case CRYPTO_ALG_TYPE_AKCIPHER:
+		if (crypto_report_akcipher(skb, alg))
+			goto nla_put_failure;
+
+		break;
 	}
 
 out:
diff --git a/include/crypto/akcipher.h b/include/crypto/akcipher.h
new file mode 100644
index 0000000..abebbcc
--- /dev/null
+++ b/include/crypto/akcipher.h
@@ -0,0 +1,323 @@
+/*
+ * Public Key Encryption
+ *
+ * Copyright (c) 2015, Intel Corporation
+ * Authors: Tadeusz Struk <tadeusz.struk@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ *
+ */
+#ifndef _CRYPTO_AKCIPHER_H
+#define _CRYPTO_AKCIPHER_H
+#include <linux/crypto.h>
+
+/**
+ * struct akcipher_request - public key request
+ *
+ * @base:	Common attributes for async crypto requests
+ * @src:	Pointer to memory containing the input parameters
+ *		The format of the parameter(s) is expeted to be Octet String
+ * @dst:	Pointer to memory whare the result will be stored
+ * @src_len:	Size of the input parameter
+ * @dst_len:	Size of the output buffer. It needs to be at leaset
+ *		as big as the expected result depending	on the operation
+ *		After operation it will be updated with the acctual size of the
+ *		result. In case of error, where the dst_len was insufficient,
+ *		it will be updated to the size required for the operation.
+ * @result_len: If not NULL this will be updated by the implementation to
+ *		reflect the acctual size of the result
+ * @__ctx:	Start of private context data
+ */
+struct akcipher_request {
+	struct crypto_async_request base;
+	void *src;
+	void *dst;
+	unsigned int src_len;
+	unsigned int *dst_len;
+	void *__ctx[] CRYPTO_MINALIGN_ATTR;
+};
+
+/**
+ * struct crypto_akcipher - user-instantiated objects which encapsulate
+ * algorithms and core processing logic
+ *
+ * @base:	Common crypto API algorithm data structure
+ */
+struct crypto_akcipher {
+	struct crypto_tfm base;
+};
+
+/**
+ * struct akcipher_alg - generic public key algorithm
+ *
+ * @sign:	Function performs a sign operation as defined by public key
+ *		algorithm. In case of error, where the dst_len was insufficient,
+ *		the req->dst_len will be updated to the size required for the
+ *		operation
+ * @verify:	Function performs a sign operation as defined by public key
+ *		algorithm. In case of error, where the dst_len was insufficient,
+ *		the req->dst_len will be updated to the size required for the
+ *		operation
+ * @encrypt:	Function performs an encrytp operation as defined by public key
+ *		algorithm. In case of error, where the dst_len was insufficient,
+ *		the req->dst_len will be updated to the size required for the
+ *		operation
+ * @decrypt:	Function performs a decrypt operation as defined by public key
+ *		algorithm. In case of error, where the dst_len was insufficient,
+ *		the req->dst_len will be updated to the size required for the
+ *		operation
+ * @setkey:	Function invokes the algorithm specific set key function, which
+ *		knows how to decode and interpret the BER encoded key
+ *
+ * @reqsize:	Request context size required by algorithm implementation
+ * @base:	Common crypto API algorithm data structure
+ */
+struct akcipher_alg {
+	int (*sign)(struct akcipher_request *req);
+	int (*verify)(struct akcipher_request *req);
+	int (*encrypt)(struct akcipher_request *req);
+	int (*decrypt)(struct akcipher_request *req);
+	int (*setkey)(struct crypto_akcipher *tfm, const void *key,
+		      unsigned int keylen);
+
+	unsigned int reqsize;
+	struct crypto_alg base;
+};
+
+/**
+ * DOC: Generic Public Key API
+ *
+ * The Public Key API is used with the algorithms of type
+ * CRYPTO_ALG_TYPE_AKCIPHER (listed as type "akcipher" in /proc/crypto)
+ */
+
+/**
+ * crypto_alloc_akcipher() -- allocate AKCIPHER tfm handle
+ * @alg_name: is the cra_name / name or cra_driver_name / driver name of the
+ *	      public key algorithm e.g. "rsa"
+ * @type: specifies the type of the algorithm
+ * @mask: specifies the mask for the algorithm
+ *
+ * Allocate a handle for public key algorithm. The returned struct
+ * crypto_akcipher is the handle that is required for any subsequent
+ * API invocation for the public key operations.
+ *
+ * Return: allocated handle in case of success; IS_ERR() is true in case
+ *	   of an error, PTR_ERR() returns the error code.
+ */
+struct crypto_akcipher *crypto_alloc_akcipher(const char *alg_name, u32 type,
+					      u32 mask);
+
+static inline struct crypto_tfm *crypto_akcipher_tfm(
+	struct crypto_akcipher *tfm)
+{
+	return &tfm->base;
+}
+
+static inline struct akcipher_alg *__crypto_akcipher_alg(struct crypto_alg *alg)
+{
+	return container_of(alg, struct akcipher_alg, base);
+}
+
+static inline struct crypto_akcipher *__crypto_akcipher_tfm(
+	struct crypto_tfm *tfm)
+{
+	return container_of(tfm, struct crypto_akcipher, base);
+}
+
+static inline struct akcipher_alg *crypto_akcipher_alg(
+	struct crypto_akcipher *tfm)
+{
+	return __crypto_akcipher_alg(crypto_akcipher_tfm(tfm)->__crt_alg);
+}
+
+static inline unsigned int crypto_akcipher_reqsize(struct crypto_akcipher *tfm)
+{
+	return crypto_akcipher_alg(tfm)->reqsize;
+}
+
+static inline void akcipher_request_set_tfm(struct akcipher_request *req,
+					    struct crypto_akcipher *tfm)
+{
+	req->base.tfm = crypto_akcipher_tfm(tfm);
+}
+
+/**
+ * crypto_free_akcipher() -- free AKCIPHER tfm handle
+ *
+ * @tfm: AKCIPHER tfm handle allocated with crypto_alloc_akcipher()
+ */
+static inline void crypto_free_akcipher(struct crypto_akcipher *tfm)
+{
+	crypto_destroy_tfm(tfm, crypto_akcipher_tfm(tfm));
+}
+
+/**
+ * akcipher_request_alloc() -- allocates public key request
+ *
+ * @tfm:	AKCIPHER tfm handle allocated with crypto_alloc_akcipher()
+ * @gfp:	allocation flags
+ *
+ * Return: allocated handle in case of success or NULL in case of an error.
+ */
+static inline struct akcipher_request *akcipher_request_alloc(
+	struct crypto_akcipher *tfm, gfp_t gfp)
+{
+	struct akcipher_request *req;
+
+	req = kmalloc(sizeof(*req) + crypto_akcipher_reqsize(tfm), gfp);
+	if (likely(req))
+		akcipher_request_set_tfm(req, tfm);
+
+	return req;
+}
+
+/**
+ * akcipher_request_free() -- zeroize and free public key request
+ *
+ * @req:	request to free
+ */
+static inline void akcipher_request_free(struct akcipher_request *req)
+{
+	kzfree(req);
+}
+
+/**
+ * akcipher_request_set_callback() -- Sets an asynchronous callback.
+ *
+ * Callback will be called when an asynchronous operation on a given
+ * request is finished.
+ *
+ * @req:	request that the callback will be set for
+ * @flgs:	specify for instance if the operation may backlog
+ * @cmlp:	callback which will be called
+ * @data:	private data used by the caller
+ */
+static inline void akcipher_request_set_callback(struct akcipher_request *req,
+						 u32 flgs,
+						 crypto_completion_t cmpl,
+						 void *data)
+{
+	req->base.complete = cmpl;
+	req->base.data = data;
+	req->base.flags = flgs;
+}
+
+/**
+ * akcipher_request_set_crypt() -- Sets reqest parameters
+ *
+ * Sets parameters required by crypto operation
+ *
+ * @req:	public key request
+ * @src:	ptr to input parameter
+ * @dst:	ptr of output parameter
+ * @src_len:	size of the input buffer
+ * @dst_len:	size of the output buffer. It will be updated by the
+ *		implementation to reflect the acctual size of the result
+ */
+static inline void akcipher_request_set_crypt(struct akcipher_request *req,
+					      void *src, void *dst,
+					      unsigned int src_len,
+					      unsigned int *dst_len)
+{
+	req->src = src;
+	req->dst = dst;
+	req->src_len = src_len;
+	req->dst_len = dst_len;
+}
+
+/**
+ * crypto_akcipher_encrypt() -- Invoke public key encrypt operation
+ *
+ * Function invokes the specific public key encrypt operation for a given
+ * public key algorithm
+ *
+ * @req:	asymmetric key request
+ *
+ * Return: zero on success; error code in case of error
+ */
+static inline int crypto_akcipher_encrypt(struct akcipher_request *req)
+{
+	struct crypto_akcipher *tfm = __crypto_akcipher_tfm(req->base.tfm);
+	struct akcipher_alg *alg = crypto_akcipher_alg(tfm);
+
+	return alg->encrypt(req);
+}
+
+/**
+ * crypto_akcipher_decrypt() -- Invoke public key decrypt operation
+ *
+ * Function invokes the specific public key decrypt operation for a given
+ * public key algorithm
+ *
+ * @req:	asymmetric key request
+ *
+ * Return: zero on success; error code in case of error
+ */
+static inline int crypto_akcipher_decrypt(struct akcipher_request *req)
+{
+	struct crypto_akcipher *tfm = __crypto_akcipher_tfm(req->base.tfm);
+	struct akcipher_alg *alg = crypto_akcipher_alg(tfm);
+
+	return alg->decrypt(req);
+}
+
+/**
+ * crypto_akcipher_sign() -- Invoke public key sign operation
+ *
+ * Function invokes the specific public key sign operation for a given
+ * public key algorithm
+ *
+ * @req:	asymmetric key request
+ *
+ * Return: zero on success; error code in case of error
+ */
+static inline int crypto_akcipher_sign(struct akcipher_request *req)
+{
+	struct crypto_akcipher *tfm = __crypto_akcipher_tfm(req->base.tfm);
+	struct akcipher_alg *alg = crypto_akcipher_alg(tfm);
+
+	return alg->sign(req);
+}
+
+/**
+ * crypto_akcipher_verify() -- Invoke public key verify operation
+ *
+ * Function invokes the specific public key verify operation for a given
+ * public key algorithm
+ *
+ * @req:	asymmetric key request
+ *
+ * Return: zero on success; error code in case of error
+ */
+static inline int crypto_akcipher_verify(struct akcipher_request *req)
+{
+	struct crypto_akcipher *tfm = __crypto_akcipher_tfm(req->base.tfm);
+	struct akcipher_alg *alg = crypto_akcipher_alg(tfm);
+
+	return alg->verify(req);
+}
+
+/**
+ * crypto_akcipher_setkey() -- Invoke public key setkey operation
+ *
+ * Function invokes the algorithm specific set key function, which knows
+ * how to decode and interpret the encoded key
+ *
+ * @tfm:	tfm handle
+ * @key:	BER encoded private or public key
+ * @keylen:	length of the key
+ *
+ * Return: zero on success; error code in case of error
+ */
+static inline int crypto_akcipher_setkey(struct crypto_akcipher *tfm, void *key,
+					 unsigned int keylen)
+{
+	struct akcipher_alg *alg = crypto_akcipher_alg(tfm);
+
+	return alg->setkey(tfm, key, keylen);
+}
+#endif
diff --git a/include/crypto/internal/akcipher.h b/include/crypto/internal/akcipher.h
new file mode 100644
index 0000000..8f87b9b
--- /dev/null
+++ b/include/crypto/internal/akcipher.h
@@ -0,0 +1,66 @@
+/*
+ * Public Key Encryption
+ *
+ * Copyright (c) 2015, Intel Corporation
+ * Authors: Tadeusz Struk <tadeusz.struk@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ *
+ */
+#ifndef _CRYPTO_AKCIPHER_INT_H
+#define _CRYPTO_AKCIPHER_INT_H
+#include <crypto/akcipher.h>
+
+/*
+ * Transform internal helpers.
+ */
+static inline struct crypto_akcipher *akcipher_request_get_tfm(
+	struct akcipher_request *req)
+{
+	return __crypto_akcipher_tfm(req->base.tfm);
+}
+
+static inline void *akcipher_request_ctx(struct akcipher_request *req)
+{
+	return req->__ctx;
+}
+
+static inline void *akcipher_tfm_ctx(struct crypto_akcipher *tfm)
+{
+	return tfm->base.__crt_ctx;
+}
+
+static inline void akcipher_request_complete(struct akcipher_request *req,
+					     int err)
+{
+	req->base.complete(&req->base, err);
+}
+
+static inline const char *akcipher_alg_name(struct crypto_akcipher *tfm)
+{
+	return crypto_akcipher_tfm(tfm)->__crt_alg->cra_name;
+}
+
+/**
+ * crypto_register_akcipher() -- Register public key algorithm
+ *
+ * Function registers an implementation of a public key verify algorithm
+ *
+ * @alg:	algorithm definition
+ *
+ * Return: zero on success; error code in case of error
+ */
+int crypto_register_akcipher(struct akcipher_alg *alg);
+
+/**
+ * crypto_unregister_akcipher() -- Unregister public key algorithm
+ *
+ * Function unregisters an implementation of a public key verify algorithm
+ *
+ * @alg:	algorithm definition
+ */
+void crypto_unregister_akcipher(struct akcipher_alg *alg);
+#endif
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 25a4b71..0e3f71a 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -53,6 +53,7 @@
 #define CRYPTO_ALG_TYPE_SHASH		0x00000009
 #define CRYPTO_ALG_TYPE_AHASH		0x0000000a
 #define CRYPTO_ALG_TYPE_RNG		0x0000000c
+#define CRYPTO_ALG_TYPE_AKCIPHER	0x0000000d
 #define CRYPTO_ALG_TYPE_PCOMPRESS	0x0000000f
 
 #define CRYPTO_ALG_TYPE_HASH_MASK	0x0000000e
diff --git a/include/linux/cryptouser.h b/include/linux/cryptouser.h
index 4abf2ea..36efbbb 100644
--- a/include/linux/cryptouser.h
+++ b/include/linux/cryptouser.h
@@ -43,6 +43,7 @@ enum crypto_attr_type_t {
 	CRYPTOCFGA_REPORT_COMPRESS,	/* struct crypto_report_comp */
 	CRYPTOCFGA_REPORT_RNG,		/* struct crypto_report_rng */
 	CRYPTOCFGA_REPORT_CIPHER,	/* struct crypto_report_cipher */
+	CRYPTOCFGA_REPORT_AKCIPHER,	/* struct crypto_report_akcipher */
 	__CRYPTOCFGA_MAX
 
 #define CRYPTOCFGA_MAX (__CRYPTOCFGA_MAX - 1)
@@ -101,5 +102,9 @@ struct crypto_report_rng {
 	unsigned int seedsize;
 };
 
+struct crypto_report_akcipher {
+	char type[CRYPTO_MAX_NAME];
+};
+
 #define CRYPTO_REPORT_MAXSIZE (sizeof(struct crypto_user_alg) + \
 			       sizeof(struct crypto_report_blkcipher))
