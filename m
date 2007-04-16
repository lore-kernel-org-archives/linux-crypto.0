From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/6] [CRYPTO] api: Add async blkcipher type
Date: Mon, 16 Apr 2007 20:52:17 +1000
Message-ID: <E1HdOoj-0002u8-00@gondolin.me.apana.org.au>
References: <<20070416105105.GA10188@gondor.apana.org.au>>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4920 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030358AbXDPKwT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 16 Apr 2007 06:52:19 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1HdOoj-0004bM-NL
	for <linux-crypto@vger.kernel.org>; Mon, 16 Apr 2007 20:52:17 +1000
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1HdOoj-0002u8-00
	for <linux-crypto@vger.kernel.org>; Mon, 16 Apr 2007 20:52:17 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

[CRYPTO] api: Add async blkcipher type

This patch adds the mid-level interface for asynchronous block ciphers.
It also includes a generic queueing mechanism that can be used by other
asynchronous crypto operations in future.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/Kconfig          |    4 ++
 crypto/Makefile         |    1 
 crypto/ablkcipher.c     |   83 ++++++++++++++++++++++++++++++++++++++++++++++++
 crypto/algapi.c         |   62 +++++++++++++++++++++++++++++++++++
 include/crypto/algapi.h |   58 +++++++++++++++++++++++++++++++++
 include/linux/crypto.h  |   22 ++++++++++++
 6 files changed, 230 insertions(+)

diff --git a/crypto/Kconfig b/crypto/Kconfig
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -16,6 +16,10 @@ config CRYPTO_ALGAPI
 	help
 	  This option provides the API for cryptographic algorithms.
 
+config CRYPTO_ABLKCIPHER
+	tristate
+	select CRYPTO_BLKCIPHER
+
 config CRYPTO_BLKCIPHER
 	tristate
 	select CRYPTO_ALGAPI
diff --git a/crypto/Makefile b/crypto/Makefile
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -8,6 +8,7 @@ crypto_algapi-$(CONFIG_PROC_FS) += proc.
 crypto_algapi-objs := algapi.o $(crypto_algapi-y)
 obj-$(CONFIG_CRYPTO_ALGAPI) += crypto_algapi.o
 
+obj-$(CONFIG_CRYPTO_ABLKCIPHER) += ablkcipher.o
 obj-$(CONFIG_CRYPTO_BLKCIPHER) += blkcipher.o
 
 crypto_hash-objs := hash.o
diff --git a/crypto/ablkcipher.c b/crypto/ablkcipher.c
new file mode 100644
--- /dev/null
+++ b/crypto/ablkcipher.c
@@ -0,0 +1,83 @@
+/*
+ * Asynchronous block chaining cipher operations.
+ * 
+ * This is the asynchronous version of blkcipher.c indicating completion
+ * via a callback.
+ *
+ * Copyright (c) 2006 Herbert Xu <herbert@gondor.apana.org.au>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option) 
+ * any later version.
+ *
+ */
+
+#include <crypto/algapi.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/seq_file.h>
+
+static int setkey(struct crypto_ablkcipher *tfm, const u8 *key,
+		  unsigned int keylen)
+{
+	struct ablkcipher_alg *cipher = crypto_ablkcipher_alg(tfm);
+
+	if (keylen < cipher->min_keysize || keylen > cipher->max_keysize) {
+		crypto_ablkcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	}
+
+	return cipher->setkey(tfm, key, keylen);
+}
+
+static unsigned int crypto_ablkcipher_ctxsize(struct crypto_alg *alg, u32 type,
+					      u32 mask)
+{
+	return alg->cra_ctxsize;
+}
+
+static int crypto_init_ablkcipher_ops(struct crypto_tfm *tfm, u32 type,
+				      u32 mask)
+{
+	struct ablkcipher_alg *alg = &tfm->__crt_alg->cra_ablkcipher;
+	struct ablkcipher_tfm *crt = &tfm->crt_ablkcipher;
+
+	if (alg->ivsize > PAGE_SIZE / 8)
+		return -EINVAL;
+
+	crt->setkey = setkey;
+	crt->encrypt = alg->encrypt;
+	crt->decrypt = alg->decrypt;
+	crt->ivsize = alg->ivsize;
+
+	return 0;
+}
+
+static void crypto_ablkcipher_show(struct seq_file *m, struct crypto_alg *alg)
+	__attribute__ ((unused));
+static void crypto_ablkcipher_show(struct seq_file *m, struct crypto_alg *alg)
+{
+	struct ablkcipher_alg *ablkcipher = &alg->cra_ablkcipher;
+
+	seq_printf(m, "type         : ablkcipher\n");
+	seq_printf(m, "blocksize    : %u\n", alg->cra_blocksize);
+	seq_printf(m, "min keysize  : %u\n", ablkcipher->min_keysize);
+	seq_printf(m, "max keysize  : %u\n", ablkcipher->max_keysize);
+	seq_printf(m, "ivsize       : %u\n", ablkcipher->ivsize);
+	seq_printf(m, "qlen         : %u\n", ablkcipher->queue->qlen);
+	seq_printf(m, "max qlen     : %u\n", ablkcipher->queue->max_qlen);
+}
+
+const struct crypto_type crypto_ablkcipher_type = {
+	.ctxsize = crypto_ablkcipher_ctxsize,
+	.init = crypto_init_ablkcipher_ops,
+#ifdef CONFIG_PROC_FS
+	.show = crypto_ablkcipher_show,
+#endif
+};
+EXPORT_SYMBOL_GPL(crypto_ablkcipher_type);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Asynchronous block chaining cipher type");
diff --git a/crypto/algapi.c b/crypto/algapi.c
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -507,6 +507,68 @@ err_free_inst:
 }
 EXPORT_SYMBOL_GPL(crypto_alloc_instance);
 
+void crypto_init_queue(struct crypto_queue *queue, unsigned int max_qlen)
+{
+	INIT_LIST_HEAD(&queue->list);
+	queue->backlog = &queue->list;
+	queue->qlen = 0;
+	queue->max_qlen = max_qlen;
+}
+EXPORT_SYMBOL_GPL(crypto_init_queue);
+
+int crypto_enqueue_request(struct crypto_queue *queue,
+			   struct crypto_async_request *request)
+{
+	int err = -EINPROGRESS;
+
+	if (unlikely(queue->qlen >= queue->max_qlen)) {
+		err = -EBUSY;
+		if (!(request->flags & CRYPTO_TFM_REQ_MAY_BACKLOG))
+			goto out;
+		if (queue->backlog == &queue->list)
+			queue->backlog = &request->list;
+	}
+
+	queue->qlen++;
+	list_add_tail(&request->list, &queue->list);
+
+out:
+	return err;
+}
+EXPORT_SYMBOL_GPL(crypto_enqueue_request);
+
+struct crypto_async_request *crypto_dequeue_request(struct crypto_queue *queue)
+{
+	struct list_head *request;
+
+	if (unlikely(!queue->qlen))
+		return NULL;
+
+	queue->qlen--;
+
+	if (queue->backlog != &queue->list)
+		queue->backlog = queue->backlog->next;
+
+	request = queue->list.next;
+	list_del(request);
+
+	return list_entry(request, struct crypto_async_request, list);
+}
+EXPORT_SYMBOL_GPL(crypto_dequeue_request);
+
+int crypto_tfm_in_queue(struct crypto_queue *queue, struct crypto_tfm *tfm)
+{
+	struct crypto_async_request *req;
+
+	list_for_each_entry(req, &queue->list, list) {
+		if (req->tfm == tfm)
+			return 1;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(crypto_tfm_in_queue);
+
 static int __init crypto_algapi_init(void)
 {
 	crypto_init_proc();
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -13,6 +13,8 @@
 #define _CRYPTO_ALGAPI_H
 
 #include <linux/crypto.h>
+#include <linux/list.h>
+#include <linux/kernel.h>
 
 struct module;
 struct rtattr;
@@ -51,6 +53,14 @@ struct crypto_spawn {
 	struct crypto_instance *inst;
 };
 
+struct crypto_queue {
+	struct list_head list;
+	struct list_head *backlog;
+
+	unsigned int qlen;
+	unsigned int max_qlen;
+};
+
 struct scatter_walk {
 	struct scatterlist *sg;
 	unsigned int offset;
@@ -82,6 +92,7 @@ struct blkcipher_walk {
 	int flags;
 };
 
+extern const struct crypto_type crypto_ablkcipher_type;
 extern const struct crypto_type crypto_blkcipher_type;
 extern const struct crypto_type crypto_hash_type;
 
@@ -103,6 +114,12 @@ struct crypto_alg *crypto_get_attr_alg(s
 struct crypto_instance *crypto_alloc_instance(const char *name,
 					      struct crypto_alg *alg);
 
+void crypto_init_queue(struct crypto_queue *queue, unsigned int max_qlen);
+int crypto_enqueue_request(struct crypto_queue *queue,
+			   struct crypto_async_request *request);
+struct crypto_async_request *crypto_dequeue_request(struct crypto_queue *queue);
+int crypto_tfm_in_queue(struct crypto_queue *queue, struct crypto_tfm *tfm);
+
 int blkcipher_walk_done(struct blkcipher_desc *desc,
 			struct blkcipher_walk *walk, int err);
 int blkcipher_walk_virt(struct blkcipher_desc *desc,
@@ -125,6 +142,17 @@ static inline void *crypto_instance_ctx(
 	return inst->__ctx;
 }
 
+static inline struct ablkcipher_alg *crypto_ablkcipher_alg(
+	struct crypto_ablkcipher *tfm)
+{
+	return &crypto_ablkcipher_tfm(tfm)->__crt_alg->cra_ablkcipher;
+}
+
+static inline void *crypto_ablkcipher_ctx(struct crypto_ablkcipher *tfm)
+{
+	return crypto_tfm_ctx(&tfm->base);
+}
+
 static inline void *crypto_blkcipher_ctx(struct crypto_blkcipher *tfm)
 {
 	return crypto_tfm_ctx(&tfm->base);
@@ -172,5 +200,35 @@ static inline void blkcipher_walk_init(s
 	walk->total = nbytes;
 }
 
+static inline struct crypto_async_request *crypto_get_backlog(
+	struct crypto_queue *queue)
+{
+	return queue->backlog == &queue->list ? NULL :
+	       container_of(queue->backlog, struct crypto_async_request, list);
+}
+
+static inline int ablkcipher_enqueue_request(struct ablkcipher_alg *alg,
+					     struct ablkcipher_request *request)
+{
+	return crypto_enqueue_request(alg->queue, &request->base);
+}
+
+static inline struct ablkcipher_request *ablkcipher_dequeue_request(
+	struct ablkcipher_alg *alg)
+{
+	return ablkcipher_request_cast(crypto_dequeue_request(alg->queue));
+}
+
+static inline void *ablkcipher_request_ctx(struct ablkcipher_request *req)
+{
+	return req->__ctx;
+}
+
+static inline int ablkcipher_tfm_in_queue(struct crypto_ablkcipher *tfm)
+{
+	return crypto_tfm_in_queue(crypto_ablkcipher_alg(tfm)->queue,
+				   crypto_ablkcipher_tfm(tfm));
+}
+
 #endif	/* _CRYPTO_ALGAPI_H */
 
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -93,6 +93,7 @@ struct crypto_ablkcipher;
 struct crypto_async_request;
 struct crypto_blkcipher;
 struct crypto_hash;
+struct crypto_queue;
 struct crypto_tfm;
 struct crypto_type;
 
@@ -143,6 +144,19 @@ struct hash_desc {
  * Algorithms: modular crypto algorithm implementations, managed
  * via crypto_register_alg() and crypto_unregister_alg().
  */
+struct ablkcipher_alg {
+	int (*setkey)(struct crypto_ablkcipher *tfm, const u8 *key,
+	              unsigned int keylen);
+	int (*encrypt)(struct ablkcipher_request *req);
+	int (*decrypt)(struct ablkcipher_request *req);
+
+	struct crypto_queue *queue;
+
+	unsigned int min_keysize;
+	unsigned int max_keysize;
+	unsigned int ivsize;
+};
+
 struct blkcipher_alg {
 	int (*setkey)(struct crypto_tfm *tfm, const u8 *key,
 	              unsigned int keylen);
@@ -197,6 +211,7 @@ struct compress_alg {
 			      unsigned int slen, u8 *dst, unsigned int *dlen);
 };
 
+#define cra_ablkcipher	cra_u.ablkcipher
 #define cra_blkcipher	cra_u.blkcipher
 #define cra_cipher	cra_u.cipher
 #define cra_digest	cra_u.digest
@@ -221,6 +236,7 @@ struct crypto_alg {
 	const struct crypto_type *cra_type;
 
 	union {
+		struct ablkcipher_alg ablkcipher;
 		struct blkcipher_alg blkcipher;
 		struct cipher_alg cipher;
 		struct digest_alg digest;
@@ -572,6 +588,12 @@ static inline int crypto_ablkcipher_reqs
 	return crypto_ablkcipher_crt(tfm)->reqsize;
 }
 
+static inline struct ablkcipher_request *ablkcipher_request_cast(
+	struct crypto_async_request *req)
+{
+	return container_of(req, struct ablkcipher_request, base);
+}
+
 static inline struct ablkcipher_request *ablkcipher_request_alloc(
 	struct crypto_ablkcipher *tfm, gfp_t gfp)
 {
