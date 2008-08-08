From: "Shasi Pulijala" <spulijala@amcc.com>
Subject: [PATCH 1/1 v1] Add CryptoAPI PKA Support
Date: Fri, 8 Aug 2008 13:02:48 -0700
Message-ID: <DB599F406D04E34389140B7D99C71B1B05D9E03B@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: <linux-crypto@vger.kernel.org>, "Loc Ho" <lho@amcc.com>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sdcmail02-ext1.amcc.com ([198.137.200.73]:57896 "EHLO
	sdcmail02.amcc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbYHHUCt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 8 Aug 2008 16:02:49 -0400
Content-class: urn:content-classes:message
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

 
From: Shasi Pulijala <spulijala@amcc.com>

Hi Herbert,

This patch adds PKA support to Linux CryptoAPI. All the basic algorithms like add, sub, div, expmod and expmod-crt can be supported by this interface. Currently the max number of src and dst operands have been defined as 6 and 2 respectively. These values should fit all the above mentioned algorithms (for example add needs 2 for input and 1 for output, expmod-crt 6 for input and 1 for output). Although, there is no specific mapping of operands, it is assumed that for add, operand A would be the first entry, operand B would be the second entry of the source. The output would be the first output.

Signed-off-by: Shasi Pulijala <spulijala@amcc.com>
Acked-by: Loc Ho <lho@amcc.com>
---
 crypto/Kconfig          |    4 +
 crypto/Makefile         |    1 +
 crypto/pka.c            |  107 +++++++++++++++++++++++++++++++++
 include/crypto/algapi.h |   17 +++++
 include/linux/crypto.h  |  153 ++++++++++++++++++++++++++++++++++++++++++++++-
 5 files changed, 279 insertions(+), 3 deletions(-)
 create mode 100644 crypto/pka.c

diff --git a/crypto/Kconfig b/crypto/Kconfig
index eb66c4e..4e112e9 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -38,6 +38,10 @@ config CRYPTO_HASH
 	tristate
 	select CRYPTO_ALGAPI
 
+config CRYPTO_PKA
+	tristate
+	select CRYPTO_ALGAPI
+
 config CRYPTO_MANAGER
 	tristate "Cryptographic algorithm manager"
 	select CRYPTO_ALGAPI
diff --git a/crypto/Makefile b/crypto/Makefile
index 6819da9..949f08e 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -19,9 +19,9 @@ obj-$(CONFIG_CRYPTO_BLKCIPHER) += crypto_blkcipher.o
 obj-$(CONFIG_CRYPTO_SEQIV) += seqiv.o
 
 crypto_hash-objs := hash.o
+obj-$(CONFIG_CRYPTO_PKA) += pka.o
 obj-$(CONFIG_CRYPTO_HASH) += crypto_hash.o
 
 obj-$(CONFIG_CRYPTO_MANAGER) += cryptomgr.o
 obj-$(CONFIG_CRYPTO_HMAC) += hmac.o
diff --git a/crypto/pka.c b/crypto/pka.c
new file mode 100644
index 0000000..532e8d5
--- /dev/null
+++ b/crypto/pka.c
@@ -0,0 +1,107 @@
+/*
+ * @ pka.c
+ * Linux CryptoAPI Module for PKA
+ *
+ * Copyright (c) 2008 Shasi Pulijala <spulijala@amcc.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <crypto/algapi.h>
+#include <linux/err.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/seq_file.h>
+
+#include "internal.h"
+
+static unsigned int crypto_pka_ctxsize(struct crypto_alg *alg, u32 type,
+					u32 mask)
+{
+	return alg->cra_ctxsize;
+}
+
+static int crypto_init_pka_ops(struct crypto_tfm *tfm, u32 type, u32 mask)
+{
+	struct pka_alg *alg = &tfm->__crt_alg->cra_pka;
+	struct pka_tfm *crt   = &tfm->crt_pka;
+	
+	crt->base   = __crypto_pka_cast(tfm);
+	crt->pka_op = alg->pka_op;
+	return 0;
+}
+
+static void crypto_pka_show(struct seq_file *m, struct crypto_alg *alg)
+	__attribute__ ((unused));
+static void crypto_pka_show(struct seq_file *m, struct crypto_alg *alg)
+{
+	seq_printf(m, "type         : pka\n");
+	seq_printf(m, "async        : %s\n", alg->cra_flags & CRYPTO_ALG_ASYNC ?
+					     "yes" : "no");
+}
+
+const struct crypto_type crypto_pka_type = {
+	.ctxsize = crypto_pka_ctxsize,
+	.init = crypto_init_pka_ops,
+#ifdef CONFIG_PROC_FS
+	.show = crypto_pka_show,
+#endif
+};
+EXPORT_SYMBOL_GPL(crypto_pka_type);
+
+struct crypto_pka *crypto_alloc_pka(const char *alg_name,
+					u32 type, u32 mask)
+{
+	struct crypto_tfm *tfm;
+	int err;
+
+	mask &= ~CRYPTO_ALG_TYPE_MASK;
+
+	for (;;) {
+		struct crypto_alg *alg;
+
+		type &= ~CRYPTO_ALG_TYPE_MASK;
+		type |= CRYPTO_ALG_TYPE_ASYNC_PKA;
+		alg = crypto_alg_mod_lookup(alg_name, type, mask);
+		if (IS_ERR(alg)) {
+			type &= ~CRYPTO_ALG_TYPE_MASK;
+			type |= CRYPTO_ALG_TYPE_ASYNC_PKA;
+			alg = crypto_alg_mod_lookup(alg_name, type, mask);
+			if (IS_ERR(alg)) {
+				err = PTR_ERR(alg);
+				goto err;
+			}
+		}
+
+		tfm = __crypto_alloc_tfm(alg, type, mask | CRYPTO_ALG_ASYNC);
+		if (!IS_ERR(tfm))
+			return __crypto_pka_cast(tfm);
+
+		crypto_mod_put(alg);
+		err = PTR_ERR(tfm);
+
+err:
+		if (err != -EAGAIN)
+			break;
+		if (signal_pending(current)) {
+			err = -EINTR;
+			break;
+		}
+	}
+
+	return ERR_PTR(err);
+}
+EXPORT_SYMBOL_GPL(crypto_alloc_pka);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Cryptographic PKA type");
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 60d06e7..2498a9c 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -98,6 +98,7 @@ extern const struct crypto_type crypto_ablkcipher_type;
 extern const struct crypto_type crypto_aead_type;
 extern const struct crypto_type crypto_blkcipher_type;
 extern const struct crypto_type crypto_hash_type;
+extern const struct crypto_type crypto_pka_type;
 
 void crypto_mod_put(struct crypto_alg *alg);
 
@@ -314,5 +315,21 @@ static inline int crypto_requires_sync(u32 type, u32 mask)
 	return (type ^ CRYPTO_ALG_ASYNC) & mask & CRYPTO_ALG_ASYNC;
 }
 
+static inline void *crypto_pka_ctx(struct crypto_pka *tfm)
+{
+	return crypto_tfm_ctx(&tfm->base);
+}
+
+static inline struct pka_alg *crypto_pka_alg(
+		struct crypto_pka *tfm)
+{
+	return &crypto_pka_tfm(tfm)->__crt_alg->cra_pka;
+}
+
+static inline void *pka_request_ctx(struct pka_request *req)
+{
+	return req->__ctx;
+}
+
 #endif	/* _CRYPTO_ALGAPI_H */
 
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 425824b..ae697f6 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -37,6 +37,7 @@
 #define CRYPTO_ALG_TYPE_GIVCIPHER	0x00000006
 #define CRYPTO_ALG_TYPE_COMPRESS	0x00000008
 #define CRYPTO_ALG_TYPE_AEAD		0x00000009
+#define CRYPTO_ALG_TYPE_ASYNC_PKA	0x0000000B
 
 #define CRYPTO_ALG_TYPE_HASH_MASK	0x0000000e
 #define CRYPTO_ALG_TYPE_BLKCIPHER_MASK	0x0000000c
@@ -102,6 +103,7 @@ struct crypto_async_request;
 struct crypto_aead;
 struct crypto_blkcipher;
 struct crypto_hash;
+struct crypto_pka;
 struct crypto_tfm;
 struct crypto_type;
 struct aead_givcrypt_request;
@@ -132,6 +134,33 @@ struct ablkcipher_request {
 };
 
 /**
+ *	struct pka_request - PKA request
+ *	@base: Common attributes for async pka requests
+ *	@src: list of source operands
+ *	@dst: result operands
+ *	@shift_value: shift value for shift operation
+ *	@__ctx: Start of private context data
+ */
+#define PKA_SRC_OPERANDS		6
+#define PKA_DST_OPERANDS		2
+
+struct pka_request {
+	struct crypto_async_request base;
+
+	struct scatterlist		*src[6];
+	struct scatterlist		*dst[2];
+	u32			operand_src_size[6];
+	u32			operand_dst_size[2];
+
+	int iops;
+	int oops;
+
+	u8	shift_value;
+
+	void *__ctx[] CRYPTO_MINALIGN_ATTR;
+};
+
+/**
  *	struct aead_request - AEAD request
  *	@base: Common attributes for async crypto requests
  *	@assoclen: Length in bytes of associated data for authentication
@@ -266,6 +295,10 @@ struct compress_alg {
 			      unsigned int slen, u8 *dst, unsigned int *dlen);
 };
 
+struct pka_alg {
+	int (*pka_op)(struct pka_request *req);
+};
+
 #define cra_ablkcipher	cra_u.ablkcipher
 #define cra_aead	cra_u.aead
 #define cra_blkcipher	cra_u.blkcipher
@@ -273,6 +306,7 @@ struct compress_alg {
 #define cra_digest	cra_u.digest
 #define cra_hash	cra_u.hash
 #define cra_compress	cra_u.compress
+#define cra_pka		cra_u.pka
 
 struct crypto_alg {
 	struct list_head cra_list;
@@ -299,12 +333,13 @@ struct crypto_alg {
 		struct digest_alg digest;
 		struct hash_alg hash;
 		struct compress_alg compress;
+		struct pka_alg	pka;
 	} cra_u;
 
 	int (*cra_init)(struct crypto_tfm *tfm);
 	void (*cra_exit)(struct crypto_tfm *tfm);
 	void (*cra_destroy)(struct crypto_alg *alg);
-	
+ 
 	struct module *cra_module;
 };
 
@@ -392,17 +427,23 @@ struct compress_tfm {
 	                      u8 *dst, unsigned int *dlen);
 };
 
+struct pka_tfm {
+	struct crypto_pka *base;
+	int (*pka_op)(struct pka_request *req);
+};
+
 #define crt_ablkcipher	crt_u.ablkcipher
 #define crt_aead	crt_u.aead
 #define crt_blkcipher	crt_u.blkcipher
 #define crt_cipher	crt_u.cipher
 #define crt_hash	crt_u.hash
 #define crt_compress	crt_u.compress
+#define crt_pka		crt_u.pka
 
 struct crypto_tfm {
 
 	u32 crt_flags;
-	
+ 
 	union {
 		struct ablkcipher_tfm ablkcipher;
 		struct aead_tfm aead;
@@ -410,8 +451,9 @@ struct crypto_tfm {
 		struct cipher_tfm cipher;
 		struct hash_tfm hash;
 		struct compress_tfm compress;
+		struct pka_tfm	pka;
 	} crt_u;
-	
+ 
 	struct crypto_alg *__crt_alg;
 
 	void *__crt_ctx[] CRYPTO_MINALIGN_ATTR;
@@ -441,6 +483,10 @@ struct crypto_hash {
 	struct crypto_tfm base;
 };
 
+struct crypto_pka {
+	struct crypto_tfm base;
+};
+
 enum {
 	CRYPTOA_UNSPEC,
 	CRYPTOA_ALG,
@@ -1264,5 +1310,106 @@ static inline int crypto_comp_decompress(struct crypto_comp *tfm,
 						    src, slen, dst, dlen);
 }
 
+static inline struct crypto_digest *__crypto_digest_cast(
+		struct crypto_tfm *tfm)
+{
+	return (struct crypto_digest *) tfm;
+}
+
+static inline struct crypto_pka *__crypto_pka_cast(struct crypto_tfm *tfm)
+{
+	return (struct crypto_pka *) tfm;
+}
+
+static inline struct crypto_tfm *crypto_pka_tfm(
+		struct crypto_pka *tfm)
+{
+	return &tfm->base;
+}
+
+static inline struct pka_tfm *crypto_pka_crt(struct crypto_pka *tfm)
+{
+	return &crypto_pka_tfm(tfm)->crt_pka;
+}
+
+static inline struct crypto_pka *crypto_pka_reqtfm(
+		struct pka_request *req)
+{
+	return __crypto_pka_cast(req->base.tfm);
+}
+
+static inline int crypto_pka_op(struct pka_request *req)
+{
+	struct pka_tfm *crt = crypto_pka_crt(crypto_pka_reqtfm(req));
+	return crt->pka_op(req);
+}
+
+static inline void pka_request_set_tfm(
+		struct pka_request *req, struct crypto_pka *tfm)
+{
+	req->base.tfm = crypto_pka_tfm(crypto_pka_crt(tfm)->base);
+}
+
+static inline struct pka_request *pka_request_alloc(
+		struct crypto_pka *tfm, gfp_t gfp)
+{
+	struct pka_request *req;
+
+	req = kmalloc(sizeof(struct pka_request), gfp);
+
+	if (likely(req))
+		pka_request_set_tfm(req, tfm);
+
+	return req;
+}
+
+static inline void pka_request_free(struct pka_request *req)
+{
+	kfree(req);
+}
+
+static inline void crypto_free_pka(struct crypto_pka *tfm)
+{
+	crypto_free_tfm(crypto_pka_tfm(tfm));
+}
+
+static inline void pka_request_set_operands(
+		struct pka_request *req,
+		struct scatterlist **sg_src,
+		struct scatterlist **sg_dst,
+		u32  *ssize,
+		u32  *dsize,
+		int iops, int oops, u8 shift)
+{
+	int i;
+	req->iops = iops;
+	req->oops = oops;
+	req->shift_value = shift;
+	
+	for (i = 0; i < iops; i++) {
+		req->src[i] = sg_src[i];
+		req->operand_src_size[i] = ssize[i];
+	}
+	
+	for (i = 0; i < oops; i++) {
+		req->dst[i] = sg_dst[i];
+		req->operand_dst_size[i] = dsize[i];
+	}
+
+}
+
+static inline void pka_request_set_callback(
+		struct pka_request *req,
+	u32 flags, crypto_completion_t complete, void *data)
+{
+	req->base.complete = complete;
+	req->base.data = data;
+	req->base.flags = flags;
+}
+
+
+struct crypto_pka *crypto_alloc_pka(const char *alg_name,
+				    u32 type, u32 mask);
+
 #endif	/* _LINUX_CRYPTO_H */
 
-- 
1.5.5

