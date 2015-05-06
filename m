From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH RFC v2 1/2] crypto: add PKE API
Date: Wed, 06 May 2015 12:36:48 -0700
Message-ID: <20150506193648.9329.27232.stgit@tstruk-mobl1>
References: <20150506193643.9329.75351.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
	jwboyer@redhat.com, richard@nod.at, tadeusz.struk@intel.com,
	steved@redhat.com, qat-linux@intel.com, dhowells@redhat.com,
	linux-crypto@vger.kernel.org, james.l.morris@oracle.com,
	jkosina@suse.cz, zohar@linux.vnet.ibm.com, davem@davemloft.net,
	vgoyal@redhat.com
To: herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150506193643.9329.75351.stgit@tstruk-mobl1>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Add Public Key Encryption API.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 crypto/Kconfig             |    6 +
 crypto/Makefile            |    1 
 crypto/crypto_user.c       |   24 +++
 crypto/pkey.c              |  125 ++++++++++++++
 include/crypto/pkey.h      |  390 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/crypto.h     |    1 
 include/linux/cryptouser.h |    7 +
 7 files changed, 554 insertions(+)
 create mode 100644 crypto/pkey.c
 create mode 100644 include/crypto/pkey.h

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 8aaf298..daa9c07 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -87,6 +87,12 @@ config CRYPTO_PCOMP2
 	tristate
 	select CRYPTO_ALGAPI2
 
+config CRYPTO_PKEY
+	tristate "Public Key Algorithms API"
+	select CRYPTO_ALGAPI
+	help
+	  Crypto API interface for public key algorithms.
+
 config CRYPTO_MANAGER
 	tristate "Cryptographic algorithm manager"
 	select CRYPTO_MANAGER2
diff --git a/crypto/Makefile b/crypto/Makefile
index 97b7d3a..1930f85 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -27,6 +27,7 @@ crypto_hash-y += shash.o
 obj-$(CONFIG_CRYPTO_HASH2) += crypto_hash.o
 
 obj-$(CONFIG_CRYPTO_PCOMP2) += pcompress.o
+obj-$(CONFIG_CRYPTO_PKEY) += pkey.o
 
 cryptomgr-y := algboss.o testmgr.o
 
diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
index 41dfe76..ccc7f1d 100644
--- a/crypto/crypto_user.c
+++ b/crypto/crypto_user.c
@@ -27,6 +27,7 @@
 #include <net/net_namespace.h>
 #include <crypto/internal/aead.h>
 #include <crypto/internal/skcipher.h>
+#include <crypto/pkey.h>
 
 #include "internal.h"
 
@@ -110,6 +111,23 @@ nla_put_failure:
 	return -EMSGSIZE;
 }
 
+static int crypto_report_pkey(struct sk_buff *skb, struct crypto_alg *alg)
+{
+	struct crypto_report_pkey rpkey;
+
+	strncpy(rpkey.type, "pke", sizeof(rpkey.type));
+	strncpy(rpkey.subtype, alg->cra_name, sizeof(rpkey.subtype));
+	rpkey.capabilities = __crypto_pkey_alg(alg)->capabilities;
+
+	if (nla_put(skb, CRYPTOCFGA_REPORT_PKEY,
+		    sizeof(struct crypto_report_pkey), &rpkey))
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
@@ -154,6 +172,12 @@ static int crypto_report_one(struct crypto_alg *alg,
 			goto nla_put_failure;
 
 		break;
+
+	case CRYPTO_ALG_TYPE_PKEY:
+		if (crypto_report_pkey(skb, alg))
+			goto nla_put_failure;
+
+		break;
 	}
 
 out:
diff --git a/crypto/pkey.c b/crypto/pkey.c
new file mode 100644
index 0000000..ab8c0e9
--- /dev/null
+++ b/crypto/pkey.c
@@ -0,0 +1,125 @@
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
+#include <crypto/pkey.h>
+#include "internal.h"
+
+#ifdef CONFIG_NET
+static int crypto_pkey_report(struct sk_buff *skb, struct crypto_alg *alg)
+{
+	struct crypto_report_pkey rep_pkey;
+
+	strncpy(rep_pkey.type, "pkey", sizeof(rep_pkey.type));
+	strncpy(rep_pkey.subtype, alg->cra_name, sizeof(rep_pkey.subtype));
+	rep_pkey.capabilities = __crypto_pkey_alg(alg)->capabilities;
+
+	if (nla_put(skb, CRYPTOCFGA_REPORT_PKEY,
+		    sizeof(struct crypto_report_pkey), &rep_pkey))
+		goto nla_put_failure;
+	return 0;
+
+nla_put_failure:
+	return -EMSGSIZE;
+}
+#else
+static int crypto_pkey_report(struct sk_buff *skb, struct crypto_alg *alg)
+{
+	return -ENOSYS;
+}
+#endif
+
+static void crypto_pkey_show(struct seq_file *m, struct crypto_alg *alg)
+	__attribute__ ((unused));
+static void crypto_pkey_show(struct seq_file *m, struct crypto_alg *alg)
+{
+	int cap = __crypto_pkey_alg(alg)->capabilities;
+
+	seq_puts(m, "type         : pke\n");
+	seq_printf(m, "subtype      : %s\n", alg->cra_name);
+	seq_printf(m, "can encrypt  : %s\n",
+		   cap & PKEY_CAN_ENCRYPT ? "yes" : "no");
+	seq_printf(m, "can decrypt  : %s\n",
+		   cap & PKEY_CAN_DECRYPT ? "yes" : "no");
+	seq_printf(m, "can sign     : %s\n",
+		   cap & PKEY_CAN_SIGN ? "yes" : "no");
+	seq_printf(m, "can verify   : %s\n",
+		   cap & PKEY_CAN_VERIFY ? "yes" : "no");
+}
+
+static int crypto_pkey_init(struct crypto_tfm *tfm)
+{
+	return 0;
+}
+
+static const struct crypto_type crypto_pkey_type = {
+	.extsize = crypto_alg_extsize,
+	.init_tfm = crypto_pkey_init,
+#ifdef CONFIG_PROC_FS
+	.show = crypto_pkey_show,
+#endif
+	.report = crypto_pkey_report,
+	.maskclear = ~CRYPTO_ALG_TYPE_MASK,
+	.maskset = CRYPTO_ALG_TYPE_MASK,
+	.type = CRYPTO_ALG_TYPE_PKEY,
+	.tfmsize = offsetof(struct crypto_pkey, base),
+};
+
+struct crypto_pkey *crypto_alloc_pkey(const char *alg_name, u32 type, u32 mask)
+{
+	return crypto_alloc_tfm(alg_name, &crypto_pkey_type, type, mask);
+}
+EXPORT_SYMBOL_GPL(crypto_alloc_pkey);
+
+int crypto_register_pkey(struct pkey_alg *alg)
+{
+	struct crypto_alg *base = &alg->base;
+
+	if (alg->n_pub_mpi > 5 || alg->n_sec_mpi > 5 || alg->n_sig_mpi > 2)
+		return -EINVAL;
+
+	if ((alg->capabilities & PKEY_CAN_ENCRYPT) && !alg->encrypt)
+		return -EINVAL;
+
+	if ((alg->capabilities & PKEY_CAN_DECRYPT) && !alg->decrypt)
+		return -EINVAL;
+
+	if ((alg->capabilities & PKEY_CAN_SIGN) && !alg->sign)
+		return -EINVAL;
+
+	if ((alg->capabilities & PKEY_CAN_VERIFY) && !alg->verify)
+		return -EINVAL;
+
+	base->cra_type = &crypto_pkey_type;
+	base->cra_flags &= ~CRYPTO_ALG_TYPE_MASK;
+	base->cra_flags |= CRYPTO_ALG_TYPE_PKEY;
+
+	return crypto_register_alg(base);
+}
+EXPORT_SYMBOL_GPL(crypto_register_pkey);
+
+void crypto_unregister_pkey(struct pkey_alg *alg)
+{
+	crypto_unregister_alg(&alg->base);
+}
+EXPORT_SYMBOL_GPL(crypto_unregister_pkey);
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Generic public key type");
diff --git a/include/crypto/pkey.h b/include/crypto/pkey.h
new file mode 100644
index 0000000..abcdb11
--- /dev/null
+++ b/include/crypto/pkey.h
@@ -0,0 +1,390 @@
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
+#ifndef _CRYPTO_PKEY_H
+#define _CRYPTO_PKEY_H
+#include <linux/crypto.h>
+
+struct public_key;
+struct public_key_signature;
+
+/**
+ * struct pkey_request - public key request
+ *
+ * @base:	Common attributes for async crypto requests
+ * @pkey:	Public key data for the subtype of the asymmetric key.
+ *		It may include private part of the key as well as
+ *		the public part.
+ * @signature:	Public key signature data.
+ * @__ctx:	Start of private context data.
+ */
+struct pkey_request {
+	struct crypto_async_request base;
+	const struct public_key *pkey;
+	const struct public_key_signature *signature;
+	void *__ctx[] CRYPTO_MINALIGN_ATTR;
+};
+
+/**
+ * struct pkey_alg - generic public key algorithm
+ *
+ * @sign:	Function performs a sign operation as defined by public key
+ *		algorithm. PKEY_CAN_SIGN bit in capabilities mask denotes
+ *		if it is provided by algorithm.
+ * @verify:	Function performs a sign operation as defined by public key
+ *		algorithm. PKEY_CAN_VERIFY bit in capabilities mask denotes
+ *		if it is provided by algorithm.
+ * @encrypt:	Function performs an encrytp operation as defined by public key
+ *		algorithm. PKEY_CAN_ENCRYPT bit in capabilities maks denotes
+ *		if it is provided by algorithm.
+ * @decrypt:	Function performs a decrypt operation as defined by public key
+ *		algorithm. PKEY_CAN_DECRYPT bit in capabilities maks denotes
+ *		if it is provided by algorithm.
+ * @n_pub_mpi:	Minimun number of MPIs (Multi Precision Integers) in public key
+ *		parameter in the pkey request as expected by the algorithm.
+ * @n_sec_mpi:	Minimun number of MPIs (Multi Precision Integers) in secret key
+ *		parameter in the pkey request as expected by the algorithm.
+ * @n_sig_mpi:	Minimun number of MPIs (Multi Precision Integers) in signature
+ *		parameter in the pkey request as expected by the algorithm.
+ * @capabilities:
+ *		Specifies what operations are provided by the algorithm
+ *		implementation.
+ * @reqsize:	Request context size required by algorithm implementation.
+ * @base:	Common crypto API algorithm data structure.
+ */
+struct pkey_alg {
+	int (*sign)(struct pkey_request *pkeyreq);
+	int (*verify)(struct pkey_request *pkeyreq);
+	int (*encrypt)(struct pkey_request *pkeyreq);
+	int (*decrypt)(struct pkey_request *pkeyreq);
+
+	u8 n_pub_mpi;
+	u8 n_sec_mpi;
+	u8 n_sig_mpi;
+#define PKEY_CAN_ENCRYPT	0x01
+#define PKEY_CAN_DECRYPT	0x02
+#define PKEY_CAN_SIGN		0x04
+#define PKEY_CAN_VERIFY		0x08
+	u8 capabilities;
+	unsigned int reqsize;
+	struct crypto_alg base;
+};
+
+/**
+ * struct crypto_pkey - user-instantiated objects which encapsulate algorithms
+ * and core processing logic.
+ *
+ * @base:	Common crypto API algorithm data structure.
+ * @__ctx:	Start of private context data
+ */
+struct crypto_pkey {
+	struct crypto_tfm base;
+	void *__ctx[] CRYPTO_MINALIGN_ATTR;
+};
+
+/**
+ * DOC: Generic Public Key API
+ *
+ * The Public Key API is used with the algorithms of type
+ * CRYPTO_ALG_TYPE_PKEY (listed as type "pkey" in /proc/crypto)
+ */
+
+/**
+ * crypto_alloc_pkey() -- allocate PKEY tfm handle
+ * @alg_name: is the cra_name / name or cra_driver_name / driver name of the
+ *	      public key algorithm e.g. "rsa"
+ * @type: specifies the type of the algorithm
+ * @mask: specifies the mask for the algorithm
+ *
+ * Allocate a handle for public key algorithm. The returned struct
+ * crypto_pkey is the handle that is required for any subsequent
+ * API invocation for the public key operations.
+ *
+ * Return: allocated handle in case of success; IS_ERR() is true in case
+ *	   of an error, PTR_ERR() returns the error code.
+ */
+struct crypto_pkey *crypto_alloc_pkey(const char *alg_name, u32 type, u32 mask);
+
+/*
+ * Transform internal helpers.
+ */
+static inline struct pkey_alg *__crypto_pkey_alg(struct crypto_alg *alg)
+{
+	return container_of(alg, struct pkey_alg, base);
+}
+
+static inline struct crypto_pkey *__crypto_pkey_tfm(struct crypto_tfm *tfm)
+{
+	return container_of(tfm, struct crypto_pkey, base);
+}
+
+static inline struct crypto_tfm *crypto_pkey_tfm(struct crypto_pkey *tfm)
+{
+	return &tfm->base;
+}
+
+static inline struct pkey_alg *crypto_pkey_alg(struct crypto_pkey *tfm)
+{
+	return __crypto_pkey_alg(crypto_pkey_tfm(tfm)->__crt_alg);
+}
+
+/**
+ * crypto_free_pkey() -- free PKEY tfm handle
+ *
+ * @tfm: PKEY tfm handle allocated with crypto_alloc_pkey()
+ */
+static inline void crypto_free_pkey(struct crypto_pkey *tfm)
+{
+	crypto_destroy_tfm(tfm, crypto_pkey_tfm(tfm));
+}
+
+static inline unsigned int crypto_pkey_reqsize(struct crypto_pkey *tfm)
+{
+	return crypto_pkey_alg(tfm)->reqsize;
+}
+
+static inline void pkey_request_set_tfm(struct pkey_request *req,
+					struct crypto_pkey *tfm)
+{
+	req->base.tfm = crypto_pkey_tfm(tfm);
+}
+
+/**
+ * pkey_request_alloc() -- allocates public key request
+ *
+ * @tfm:	PKEY tfm handle allocated with crypto_alloc_pkey()
+ * @gfp:	allocation flags
+ *
+ * Return: allocated handle in case of success or NULL in case of an error.
+ */
+static inline struct pkey_request *pkey_request_alloc(struct crypto_pkey *tfm,
+						      gfp_t gfp)
+{
+	struct pkey_request *req;
+
+	req = kmalloc(sizeof(*req) + crypto_pkey_reqsize(tfm), gfp);
+	if (likely(req))
+		pkey_request_set_tfm(req, tfm);
+
+	return req;
+}
+
+static inline void *pkey_request_ctx(struct pkey_request *req)
+{
+	return req->__ctx;
+}
+
+/**
+ * pkey_request_free() -- zeroize and free public key request
+ *
+ * @req:	request to free
+ */
+static inline void pkey_request_free(struct pkey_request *req)
+{
+	kzfree(req);
+}
+
+/**
+ * pkey_request_set_callback() -- Sets an asynchronous callback.
+ *
+ * Callback will be called when an asynchronous operation on a given
+ * request is finished.
+ *
+ * @req:	request that the callback will be set for.
+ * @flgs:	specify for instance if the operation may backlog.
+ * @cmlp:	callback which will be called.
+ * @data:	private data used by the caller.
+ */
+static inline void pkey_request_set_callback(struct pkey_request *req, u32 flgs,
+					     crypto_completion_t cmpl,
+					     void *data)
+{
+	req->base.complete = cmpl;
+	req->base.data = data;
+	req->base.flags = flgs;
+}
+
+static inline void pkey_request_complete(struct pkey_request *req, int err)
+{
+	req->base.complete(&req->base, err);
+}
+
+/**
+ * pkey_request_set_crypt() -- Sets reqest parameters.
+ *
+ * Sets parameters required by crypto operation.
+ *
+ * @req:	public key.
+ * @sig:	public key signature.
+ */
+static inline void pkey_request_set_crypt(struct pkey_request *req,
+					  const struct public_key *pkey,
+					  const struct public_key_signature *sg)
+{
+	req->pkey = pkey;
+	req->signature = sg;
+}
+
+/**
+ * pkey_num_sig_mpi() -- Returns number of MPIs in signature
+ *
+ * Function returns number of MPIs (Multi Precision Integers) in signature
+ * parameter as expected by the algorithm.
+ *
+ * @tfm:	tfm handle.
+ *
+ * Return: number of MPIs in signature.
+ */
+static inline u8 pkey_num_sig_mpi(struct crypto_pkey *tfm)
+{
+	return crypto_pkey_alg(tfm)->n_sig_mpi;
+}
+
+/**
+ * pkey_num_pub_mpi() -- Returns number of MPIs in public key
+ *
+ * Function returns number of MPIs (Multi Precision Integers) in public key
+ * parameter as expected by the algorithm.
+ *
+ * @tfm:	tfm handle.
+ *
+ * Return: number of MPIs in public key.
+ */
+static inline u8 pkey_num_pub_mpi(struct crypto_pkey *tfm)
+{
+	return crypto_pkey_alg(tfm)->n_pub_mpi;
+}
+
+/**
+ * pkey_num_sec_mpi() -- Returns number of MPIs in secret key
+ *
+ * Function returns number of MPIs (Multi Precision Integers) in secret key
+ * parameter as expected by the algorithm.
+ *
+ * @tfm:	tfm handle.
+ *
+ * Return: number of MPIs in secret key.
+ */
+static inline u8 pkey_num_sec_mpi(struct crypto_pkey *tfm)
+{
+	return crypto_pkey_alg(tfm)->n_sec_mpi;
+}
+
+/**
+ * pkey_capabilities() -- Returns cababilities
+ *
+ * Function returns bitmask of capabilities denoting what public key operations
+ * are supported by the algorithm.
+ *
+ * @tfm:	tfm handle.
+ *
+ * Return: capabilities mask.
+ */
+static inline u8 pkey_capabilities(struct crypto_pkey *tfm)
+{
+	return crypto_pkey_alg(tfm)->capabilities;
+}
+
+/**
+ * pkey_capab() -- Returns algorithm name
+ *
+ * Function returns public key algorithm name e.g.g "rsa".
+ *
+ * @tfm:	tfm handle.
+ *
+ * Return: public key algorithm name.
+ */
+static inline const char *pkey_alg_name(struct crypto_pkey *tfm)
+{
+	return crypto_pkey_tfm(tfm)->__crt_alg->cra_name;
+}
+
+/**
+ * crypto_pkey_encrypt() -- Invoke public key encrypt operation
+ *
+ * Function invokes the specific public key encrypt operation for a given
+ * public key algorithm.
+ *
+ * @tfm:	tfm handle.
+ *
+ * Return: zero on success; error code in case of error.
+ */
+static inline int crypto_pkey_encrypt(struct pkey_request *req)
+{
+	return crypto_pkey_alg(__crypto_pkey_tfm(req->base.tfm))->encrypt(req);
+}
+
+/**
+ * crypto_pkey_encrypt() -- Invoke public key decrypt operation
+ *
+ * Function invokes the specific public key decrypt operation for a given
+ * public key algorithm.
+ *
+ * @tfm:	tfm handle.
+ *
+ * Return: zero on success; error code in case of error.
+ */
+static inline int crypto_pkey_decrypt(struct pkey_request *req)
+{
+	return crypto_pkey_alg(__crypto_pkey_tfm(req->base.tfm))->decrypt(req);
+}
+
+/**
+ * crypto_pkey_encrypt() -- Invoke public key sign operation
+ *
+ * Function invokes the specific public key sign operation for a given
+ * public key algorithm.
+ *
+ * @tfm:	tfm handle.
+ *
+ * Return: zero on success; error code in case of error.
+ */
+static inline int crypto_pkey_sign(struct pkey_request *req)
+{
+	return crypto_pkey_alg(__crypto_pkey_tfm(req->base.tfm))->sign(req);
+}
+
+/**
+ * crypto_pkey_encrypt() -- Invoke public key verify operation
+ *
+ * Function invokes the specific public key verify operation for a given
+ * public key algorithm.
+ *
+ * @tfm:	tfm handle.
+ *
+ * Return: zero on success; error code in case of error.
+ */
+static inline int crypto_pkey_verify(struct pkey_request *req)
+{
+	return crypto_pkey_alg(__crypto_pkey_tfm(req->base.tfm))->verify(req);
+}
+
+/**
+ * crypto_register_pkey() -- Register public key algorithm
+ *
+ * Function registers an implementation of a public key verify algorithm.
+ *
+ * @alg:	algorithm definition.
+ *
+ * Return: zero on success; error code in case of error.
+ */
+int crypto_register_pkey(struct pkey_alg *alg);
+
+/**
+ * crypto_unregister_pkey() -- Unregister public key algorithm
+ *
+ * Function unregisters an implementation of a public key verify algorithm.
+ *
+ * @alg:	algorithm definition.
+ */
+void crypto_unregister_pkey(struct pkey_alg *alg);
+#endif
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index ee14140..61842c9 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -53,6 +53,7 @@
 #define CRYPTO_ALG_TYPE_SHASH		0x00000009
 #define CRYPTO_ALG_TYPE_AHASH		0x0000000a
 #define CRYPTO_ALG_TYPE_RNG		0x0000000c
+#define CRYPTO_ALG_TYPE_PKEY		0x0000000d
 #define CRYPTO_ALG_TYPE_PCOMPRESS	0x0000000f
 
 #define CRYPTO_ALG_TYPE_HASH_MASK	0x0000000e
diff --git a/include/linux/cryptouser.h b/include/linux/cryptouser.h
index 4abf2ea..fdf9120 100644
--- a/include/linux/cryptouser.h
+++ b/include/linux/cryptouser.h
@@ -43,6 +43,7 @@ enum crypto_attr_type_t {
 	CRYPTOCFGA_REPORT_COMPRESS,	/* struct crypto_report_comp */
 	CRYPTOCFGA_REPORT_RNG,		/* struct crypto_report_rng */
 	CRYPTOCFGA_REPORT_CIPHER,	/* struct crypto_report_cipher */
+	CRYPTOCFGA_REPORT_PKEY,		/* struct crypto_report_pkey */
 	__CRYPTOCFGA_MAX
 
 #define CRYPTOCFGA_MAX (__CRYPTOCFGA_MAX - 1)
@@ -101,5 +102,11 @@ struct crypto_report_rng {
 	unsigned int seedsize;
 };
 
+struct crypto_report_pkey {
+	char type[CRYPTO_MAX_NAME];
+	char subtype[CRYPTO_MAX_NAME];
+	unsigned int capabilities;
+};
+
 #define CRYPTO_REPORT_MAXSIZE (sizeof(struct crypto_user_alg) + \
 			       sizeof(struct crypto_report_blkcipher))
