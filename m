From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH RFC 1/2] crypto: add PKE API
Date: Fri, 01 May 2015 09:24:14 +0200
Message-ID: <1788430.tPLLCmOF11@tauon>
References: <20150430223647.10157.82156.stgit@tstruk-mobl1> <20150430223652.10157.86151.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, corbet@lwn.net, keescook@chromium.org,
	qat-linux@intel.com, jwboyer@redhat.com, richard@nod.at,
	d.kasatkin@samsung.com, linux-kernel@vger.kernel.org,
	steved@redhat.com, dhowells@redhat.com, vgoyal@redhat.com,
	james.l.morris@oracle.com, jkosina@suse.cz,
	zohar@linux.vnet.ibm.com, davem@davemloft.net, jdelvare@suse.de,
	linux-crypto@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34645 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752268AbbEAHYT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 1 May 2015 03:24:19 -0400
In-Reply-To: <20150430223652.10157.86151.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 30. April 2015, 15:36:52 schrieb Tadeusz Struk:

Hi Tadeusz,

>Add Public Key Encryption API.
>
>Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
>---
> crypto/Kconfig             |    6 +
> crypto/Makefile            |    1
> crypto/crypto_user.c       |   23 +++++
> crypto/pke.c               |  114 ++++++++++++++++++++++++++
> include/crypto/algapi.h    |    6 +
> include/linux/crypto.h     |  191
>++++++++++++++++++++++++++++++++++++++++++++ include/linux/cryptouser.h |   
>7 ++
> 7 files changed, 347 insertions(+), 1 deletion(-)
> create mode 100644 crypto/pke.c
>
>diff --git a/crypto/Kconfig b/crypto/Kconfig
>index 8aaf298..9a14b33 100644
>--- a/crypto/Kconfig
>+++ b/crypto/Kconfig
>@@ -87,6 +87,12 @@ config CRYPTO_PCOMP2
> 	tristate
> 	select CRYPTO_ALGAPI2
>
>+config CRYPTO_PKE
>+	tristate "Public Key Algorithms API"
>+	select CRYPTO_ALGAPI
>+	help
>+	  Crypto API interface for public key algorithms.
>+
> config CRYPTO_MANAGER
> 	tristate "Cryptographic algorithm manager"
> 	select CRYPTO_MANAGER2
>diff --git a/crypto/Makefile b/crypto/Makefile
>index 97b7d3a..e7dd283 100644
>--- a/crypto/Makefile
>+++ b/crypto/Makefile
>@@ -27,6 +27,7 @@ crypto_hash-y += shash.o
> obj-$(CONFIG_CRYPTO_HASH2) += crypto_hash.o
>
> obj-$(CONFIG_CRYPTO_PCOMP2) += pcompress.o
>+obj-$(CONFIG_CRYPTO_PKE) += pke.o
>
> cryptomgr-y := algboss.o testmgr.o
>
>diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
>index 41dfe76..83b4d0f 100644
>--- a/crypto/crypto_user.c
>+++ b/crypto/crypto_user.c
>@@ -110,6 +110,23 @@ nla_put_failure:
> 	return -EMSGSIZE;
> }
>
>+static int crypto_report_pke(struct sk_buff *skb, struct crypto_alg *alg)
>+{
>+	struct crypto_report_pke rpke;
>+
>+	strncpy(rpke.type, "pke", sizeof(rpke.type));
>+	strncpy(rpke.subtype, alg->cra_name, sizeof(rpke.subtype));
>+	rpke.capabilities = alg->cra_pke.capabilities;
>+
>+	if (nla_put(skb, CRYPTOCFGA_REPORT_PKE,
>+		    sizeof(struct crypto_report_pke), &rpke))
>+		goto nla_put_failure;
>+	return 0;
>+
>+nla_put_failure:
>+	return -EMSGSIZE;
>+}
>+
> static int crypto_report_one(struct crypto_alg *alg,
> 			     struct crypto_user_alg *ualg, struct sk_buff 
*skb)
> {
>@@ -154,6 +171,12 @@ static int crypto_report_one(struct crypto_alg *alg,
> 			goto nla_put_failure;
>
> 		break;
>+
>+	case CRYPTO_ALG_TYPE_PKE:
>+		if (crypto_report_pke(skb, alg))
>+			goto nla_put_failure;
>+
>+		break;
> 	}
>
> out:
>diff --git a/crypto/pke.c b/crypto/pke.c
>new file mode 100644
>index 0000000..c1350fa
>--- /dev/null
>+++ b/crypto/pke.c
>@@ -0,0 +1,114 @@
>+/*
>+ * Public Key Encryption operations.
>+ *
>+ * Copyright (c) 2015, Intel Corporation
>+ * Authors: Tadeusz Struk <tadeusz.struk@intel.com>
>+ *
>+ * This program is free software; you can redistribute it and/or modify it
>+ * under the terms of the GNU General Public License as published by the
>Free + * Software Foundation; either version 2 of the License, or (at your
>option) + * any later version.
>+ *
>+ */
>+#include <linux/errno.h>
>+#include <linux/kernel.h>
>+#include <linux/module.h>
>+#include <linux/seq_file.h>
>+#include <linux/slab.h>
>+#include <linux/string.h>
>+#include <linux/crypto.h>
>+#include <linux/cryptouser.h>
>+#include <net/netlink.h>
>+#include "internal.h"
>+
>+static unsigned int crypto_pke_ctxsize(struct crypto_alg *alg, u32 type,
>+				       u32 mask)
>+{
>+	unsigned int len = alg->cra_ctxsize;
>+
>+	return ALIGN(len, (unsigned long)alg->cra_alignmask + 1);
>+}
>+
>+static int crypto_init_pke_ops(struct crypto_tfm *tfm, u32 type, u32 mask)
>+{
>+	struct pke_tfm *crt = &tfm->crt_pke;
>+	struct pke_alg *alg = &tfm->__crt_alg->cra_pke;
>+
>+	if (alg->pub_mpis > 5 || alg->sec_mpis > 5 || alg->sig_mpis > 2)
>+		return -EINVAL;
>+
>+	if ((alg->capabilities & PKEY_CAN_ENCRYPT) && !alg->encrypt)
>+		return -EINVAL;
>+
>+	if ((alg->capabilities & PKEY_CAN_DECRYPT) && !alg->decrypt)
>+		return -EINVAL;
>+
>+	if ((alg->capabilities & PKEY_CAN_SIGN) && !alg->sign)
>+		return -EINVAL;
>+
>+	if ((alg->capabilities & PKEY_CAN_VERIFY) && !alg->verify)
>+		return -EINVAL;
>+
>+	crt->sign = alg->sign;
>+	crt->verify = alg->verify;
>+	crt->encrypt = alg->encrypt;
>+	crt->decrypt = alg->decrypt;
>+	crt->base = __crypto_pke_cast(tfm);
>+
>+	return 0;
>+}
>+
>+#ifdef CONFIG_NET
>+static int crypto_pke_report(struct sk_buff *skb, struct crypto_alg *alg)
>+{
>+	struct crypto_report_pke rep_pke;
>+
>+	strncpy(rep_pke.type, "pke", sizeof(rep_pke.type));
>+	strncpy(rep_pke.subtype, alg->cra_name, sizeof(rep_pke.subtype));
>+	rep_pke.capabilities = alg->cra_pke.capabilities;
>+
>+	if (nla_put(skb, CRYPTOCFGA_REPORT_PKE,
>+		    sizeof(struct crypto_report_pke), &rep_pke))
>+		goto nla_put_failure;
>+	return 0;
>+
>+nla_put_failure:
>+	return -EMSGSIZE;
>+}
>+#else
>+static int crypto_pke_report(struct sk_buff *skb, struct crypto_alg *alg)
>+{
>+	return -ENOSYS;
>+}
>+#endif
>+
>+static void crypto_pke_show(struct seq_file *m, struct crypto_alg *alg)
>+	__attribute__ ((unused));
>+static void crypto_pke_show(struct seq_file *m, struct crypto_alg *alg)
>+{
>+	int cap = alg->cra_pke.capabilities;
>+
>+	seq_puts(m, "type         : pke\n");
>+	seq_printf(m, "subtype      : %s\n", alg->cra_name);
>+	seq_printf(m, "can encrypt  : %s\n", cap & PKEY_CAN_ENCRYPT ?
>+		   "yes" : "no");
>+	seq_printf(m, "can decrypt  : %s\n", cap & PKEY_CAN_DECRYPT ?
>+		   "yes" : "no");
>+	seq_printf(m, "can sign     : %s\n", cap & PKEY_CAN_SIGN ?
>+		   "yes" : "no");
>+	seq_printf(m, "can verify   : %s\n", cap & PKEY_CAN_VERIFY ?
>+		   "yes" : "no");
>+}
>+
>+const struct crypto_type crypto_pke_type = {
>+	.ctxsize = crypto_pke_ctxsize,
>+	.init = crypto_init_pke_ops,
>+#ifdef CONFIG_PROC_FS
>+	.show = crypto_pke_show,
>+#endif
>+	.report = crypto_pke_report,
>+};
>+EXPORT_SYMBOL_GPL(crypto_pke_type);
>+
>+MODULE_LICENSE("GPL");
>+MODULE_DESCRIPTION("Generic public key type");
>diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
>index 0ecb768..5c46eb8 100644
>--- a/include/crypto/algapi.h
>+++ b/include/crypto/algapi.h
>@@ -128,6 +128,7 @@ struct ablkcipher_walk {
> extern const struct crypto_type crypto_ablkcipher_type;
> extern const struct crypto_type crypto_aead_type;
> extern const struct crypto_type crypto_blkcipher_type;
>+extern const struct crypto_type crypto_pke_type;
>
> void crypto_mod_put(struct crypto_alg *alg);
>
>@@ -378,6 +379,11 @@ static inline u32 aead_request_flags(struct aead_request
>*req) return req->base.flags;
> }
>
>+static inline void pke_request_complete(struct pke_request *req, int err)
>+{
>+	req->base.complete(&req->base, err);
>+}
>+
> static inline struct crypto_alg *crypto_get_attr_alg(struct rtattr **tb,
> 						     u32 type, u32 mask)
> {
>diff --git a/include/linux/crypto.h b/include/linux/crypto.h
>index ee14140..9538e2e 100644
>--- a/include/linux/crypto.h
>+++ b/include/linux/crypto.h
>@@ -52,6 +52,7 @@
> #define CRYPTO_ALG_TYPE_HASH		0x00000008
> #define CRYPTO_ALG_TYPE_SHASH		0x00000009
> #define CRYPTO_ALG_TYPE_AHASH		0x0000000a
>+#define CRYPTO_ALG_TYPE_PKE		0x0000000b
> #define CRYPTO_ALG_TYPE_RNG		0x0000000c
> #define CRYPTO_ALG_TYPE_PCOMPRESS	0x0000000f
>
>@@ -142,6 +143,8 @@ struct crypto_tfm;
> struct crypto_type;
> struct aead_givcrypt_request;
> struct skcipher_givcrypt_request;
>+struct public_key;
>+struct public_key_signature;

Wouldn't it make sense to move the struct definitions here and have them 
documented?
>
> typedef void (*crypto_completion_t)(struct crypto_async_request *req, int
>err);
>
>@@ -200,6 +203,12 @@ struct aead_request {
> 	void *__ctx[] CRYPTO_MINALIGN_ATTR;
> };
>
>+struct pke_request {
>+	struct crypto_async_request base;
>+	const struct public_key *pk;
>+	const struct public_key_signature *pks;
>+};
>+
> struct blkcipher_desc {
> 	struct crypto_blkcipher *tfm;
> 	void *info;
>@@ -425,12 +434,28 @@ struct compress_alg {
> 			      unsigned int slen, u8 *dst, unsigned int *dlen);
> };
>
>+struct pke_alg {
>+	int (*sign)(struct pke_request *pkereq);
>+	int (*verify)(struct pke_request *pkereq);
>+	int (*encrypt)(struct pke_request *pkereq);
>+	int (*decrypt)(struct pke_request *pkereq);
>+
>+	u8 pub_mpis;	/* Number of MPIs in public key */
>+	u8 sec_mpis;	/* Number of MPIs in secret key */
>+	u8 sig_mpis;	/* Number of MPIs in a signature */

May I ask that for such new structs we add some documentation? Currently, I am 
unclear on what MPIs are. E.g. if somebody needs to add, say, Curve 25519, 
what shall he add here?

>+#define PKEY_CAN_ENCRYPT	0x01
>+#define PKEY_CAN_DECRYPT	0x02
>+#define PKEY_CAN_SIGN		0x04
>+#define PKEY_CAN_VERIFY		0x08
>+	u8 capabilities;
>+};
>
> #define cra_ablkcipher	cra_u.ablkcipher
> #define cra_aead	cra_u.aead
> #define cra_blkcipher	cra_u.blkcipher
> #define cra_cipher	cra_u.cipher
> #define cra_compress	cra_u.compress
>+#define cra_pke		cra_u.pke
>
> /**
>  * struct crypto_alg - definition of a cryptograpic cipher algorithm
>@@ -530,6 +555,7 @@ struct crypto_alg {
> 		struct blkcipher_alg blkcipher;
> 		struct cipher_alg cipher;
> 		struct compress_alg compress;
>+		struct pke_alg pke;
> 	} cra_u;
>
> 	int (*cra_init)(struct crypto_tfm *tfm);
>@@ -625,12 +651,23 @@ struct compress_tfm {
> 	                      u8 *dst, unsigned int *dlen);
> };
>
>+struct pke_tfm {
>+	int (*sign)(struct pke_request *pkereq);
>+	int (*verify)(struct pke_request *pkereq);
>+	int (*encrypt)(struct pke_request *pkereq);
>+	int (*decrypt)(struct pke_request *pkereq);
>+
>+	struct crypto_pke *base;
>+	unsigned int reqsize;
>+};
>+
> #define crt_ablkcipher	crt_u.ablkcipher
> #define crt_aead	crt_u.aead
> #define crt_blkcipher	crt_u.blkcipher
> #define crt_cipher	crt_u.cipher
> #define crt_hash	crt_u.hash
> #define crt_compress	crt_u.compress
>+#define crt_pke		crt_u.pke
>
> struct crypto_tfm {
>
>@@ -643,6 +680,7 @@ struct crypto_tfm {
> 		struct cipher_tfm cipher;
> 		struct hash_tfm hash;
> 		struct compress_tfm compress;
>+		struct pke_tfm pke;
> 	} crt_u;
>
> 	void (*exit)(struct crypto_tfm *tfm);
>@@ -676,6 +714,10 @@ struct crypto_hash {
> 	struct crypto_tfm base;
> };
>
>+struct crypto_pke {
>+	struct crypto_tfm base;
>+};
>+
> enum {
> 	CRYPTOA_UNSPEC,
> 	CRYPTOA_ALG,
>@@ -2356,5 +2398,152 @@ static inline int crypto_comp_decompress(struct
>crypto_comp *tfm, src, slen, dst, dlen);
> }
>
>-#endif	/* _LINUX_CRYPTO_H */
>+static inline struct crypto_pke *__crypto_pke_cast(struct crypto_tfm *tfm)
>+{
>+	return (struct crypto_pke *)tfm;
>+}
>+
>+static inline struct crypto_pke *crypto_pke_cast(struct crypto_tfm *tfm)
>+{
>+	BUG_ON(crypto_tfm_alg_type(tfm) != CRYPTO_ALG_TYPE_PKE);
>+	return __crypto_pke_cast(tfm);
>+}
>+
>+static inline struct crypto_pke *crypto_alloc_pke(const char *alg_name,
>+						  u32 type, u32 mask)
>+{
>+	type &= ~CRYPTO_ALG_TYPE_MASK;
>+	type |= CRYPTO_ALG_TYPE_PKE;
>+	mask |= CRYPTO_ALG_TYPE_MASK;
>+
>+	return __crypto_pke_cast(crypto_alloc_base(alg_name, type, mask));
>+}
>+
>+static inline struct crypto_tfm *crypto_pke_tfm(struct crypto_pke *tfm)
>+{
>+	return &tfm->base;
>+}
>+
>+static inline struct pke_tfm *crypto_pke_crt(struct crypto_pke *tfm)
>+{
>+	return &crypto_pke_tfm(tfm)->crt_pke;
>+}
>+
>+static inline void crypto_free_pke(struct crypto_pke *tfm)
>+{
>+	crypto_free_tfm(crypto_pke_tfm(tfm));
>+}
>+
>+static inline unsigned int crypto_pke_reqsize(struct crypto_pke *tfm)
>+{
>+	return crypto_pke_crt(tfm)->reqsize;
>+}
>+
>+static inline void pke_request_set_tfm(struct pke_request *req,
>+				       struct crypto_pke *tfm)
>+{
>+	req->base.tfm = crypto_pke_tfm(crypto_pke_crt(tfm)->base);
>+}
>+
>+static inline struct crypto_pke *crypto_pke_reqtfm(struct pke_request *req)
>+{
>+	return __crypto_pke_cast(req->base.tfm);
>+}
>+
>+static inline struct pke_request *pke_request_alloc(struct crypto_pke *tfm,
>+						    gfp_t gfp)
>+{
>+	struct pke_request *req;
>+
>+	req = kmalloc(sizeof(*req) + crypto_pke_reqsize(tfm), gfp);
>+	if (likely(req))
>+		pke_request_set_tfm(req, tfm);
>+
>+	return req;
>+}
>
>+static inline void pke_request_free(struct pke_request *req)
>+{
>+	kzfree(req);
>+}
>+
>+static inline void pke_request_set_callback(struct pke_request *req,
>+					    u32 flags, crypto_completion_t 
cmpl,
>+					    void *data)
>+{
>+	req->base.complete = cmpl;
>+	req->base.data = data;
>+	req->base.flags = flags;
>+}
>+
>+static inline void pke_request_set_crypt(struct pke_request *req,
>+					 const struct public_key *pk,
>+					 const struct public_key_signature 
*sig)
>+{
>+	req->pk = pk;
>+	req->pks = sig;
>+}

Up to here I am volunteering to add the documentation comments.

But for the following functions, I am not sure how they are supposed to be 
used correctly. Thus, can you add the documentation for them or at least give 
me a hint so that I can add the documentation?

>+
>+static inline u8 pke_num_sig_mpi(struct crypto_pke *tfm)
>+{
>+	struct crypto_tfm *base_tfm = &tfm->base;
>+
>+	return base_tfm->__crt_alg->cra_pke.sig_mpis;
>+}
>+
>+static inline u8 pke_num_pub_mpi(struct crypto_pke *tfm)
>+{
>+	struct crypto_tfm *base_tfm = &tfm->base;
>+
>+	return base_tfm->__crt_alg->cra_pke.pub_mpis;
>+}
>+
>+static inline u8 pke_num_sec_mpi(struct crypto_pke *tfm)
>+{
>+	struct crypto_tfm *base_tfm = &tfm->base;
>+
>+	return base_tfm->__crt_alg->cra_pke.sec_mpis;
>+}
>+
>+static inline u8 pke_capab(struct crypto_pke *tfm)
>+{
>+	struct crypto_tfm *base_tfm = &tfm->base;
>+
>+	return base_tfm->__crt_alg->cra_pke.capabilities;
>+}
>+
>+static inline const char *pke_alg_name(struct crypto_pke *tfm)
>+{
>+	struct crypto_tfm *base_tfm = &tfm->base;
>+
>+	return base_tfm->__crt_alg->cra_name;
>+}
>+
>+static inline int crypto_pke_encrypt(struct pke_request *req)
>+{
>+	struct pke_tfm *tfm = crypto_pke_crt(crypto_pke_reqtfm(req));
>+
>+	return tfm->encrypt(req);
>+}
>+
>+static inline int crypto_pke_decrypt(struct pke_request *req)
>+{
>+	struct pke_tfm *tfm = crypto_pke_crt(crypto_pke_reqtfm(req));
>+
>+	return tfm->decrypt(req);
>+}
>+
>+static inline int crypto_pke_sign(struct pke_request *req)
>+{
>+	struct pke_tfm *tfm = crypto_pke_crt(crypto_pke_reqtfm(req));
>+
>+	return tfm->sign(req);
>+}
>+
>+static inline int crypto_pke_verify(struct pke_request *req)
>+{
>+	struct pke_tfm *tfm = crypto_pke_crt(crypto_pke_reqtfm(req));
>+
>+	return tfm->verify(req);
>+}
>+#endif	/* _LINUX_CRYPTO_H */
>diff --git a/include/linux/cryptouser.h b/include/linux/cryptouser.h
>index 4abf2ea..e801130 100644
>--- a/include/linux/cryptouser.h
>+++ b/include/linux/cryptouser.h
>@@ -43,6 +43,7 @@ enum crypto_attr_type_t {
> 	CRYPTOCFGA_REPORT_COMPRESS,	/* struct crypto_report_comp */
> 	CRYPTOCFGA_REPORT_RNG,		/* struct crypto_report_rng */
> 	CRYPTOCFGA_REPORT_CIPHER,	/* struct crypto_report_cipher */
>+	CRYPTOCFGA_REPORT_PKE,		/* struct crypto_report_pke */
> 	__CRYPTOCFGA_MAX
>
> #define CRYPTOCFGA_MAX (__CRYPTOCFGA_MAX - 1)
>@@ -101,5 +102,11 @@ struct crypto_report_rng {
> 	unsigned int seedsize;
> };
>
>+struct crypto_report_pke {
>+	char type[CRYPTO_MAX_NAME];
>+	char subtype[CRYPTO_MAX_NAME];
>+	unsigned int capabilities;
>+};
>+
> #define CRYPTO_REPORT_MAXSIZE (sizeof(struct crypto_user_alg) + \
> 			       sizeof(struct crypto_report_blkcipher))
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html


Ciao
Stephan
