From: Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH RFC 3/7] crypto: add asynchronous compression support
Date: Mon,  4 Jan 2016 13:46:54 +0900
Message-ID: <1451882819-2810-4-git-send-email-iamjoonsoo.kim@lge.com>
References: <1451882819-2810-1-git-send-email-iamjoonsoo.kim@lge.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Weigang Li <weigang.li@intel.com>,
	Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
	Minchan Kim <minchan@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1451882819-2810-1-git-send-email-iamjoonsoo.kim@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Weigang Li <weigang.li@intel.com>

Now, asynchronous compression APIs are supported. There is no asynchronous
compression driver now but this APIs can be used as front-end to
synchronous compression algorithm. In this case, scatterlist would be
linearlized so it would cause some overhead.

Signed-off-by: Weigang Li <weigang.li@intel.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 crypto/Kconfig                     |   3 +-
 crypto/Makefile                    |   3 +-
 crypto/acompress.c                 | 164 +++++++++++++++++++++++++
 crypto/scompress.c                 | 169 ++++++++++++++++++++++++++
 include/crypto/compress.h          | 241 +++++++++++++++++++++++++++++++++++++
 include/crypto/internal/compress.h |   4 +
 include/linux/crypto.h             |   2 +
 7 files changed, 583 insertions(+), 3 deletions(-)
 create mode 100644 crypto/acompress.c
 create mode 100644 include/crypto/internal/compress.h

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 7159520..f22f4e9 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -84,7 +84,7 @@ config CRYPTO_RNG_DEFAULT
 	tristate
 	select CRYPTO_DRBG_MENU
 
-config CRYPTO_SCOMPRESS
+config CRYPTO_COMPRESS2
 	tristate
 	select CRYPTO_ALGAPI2
 
@@ -1503,7 +1503,6 @@ config CRYPTO_LZO
 	select CRYPTO_ALGAPI
 	select LZO_COMPRESS
 	select LZO_DECOMPRESS
-	select SCOMPRESS
 	help
 	  This is the LZO algorithm.
 
diff --git a/crypto/Makefile b/crypto/Makefile
index 16ef796..9157d69 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -28,7 +28,8 @@ crypto_hash-y += ahash.o
 crypto_hash-y += shash.o
 obj-$(CONFIG_CRYPTO_HASH2) += crypto_hash.o
 
-obj-$(CONFIG_CRYPTO_SCOMPRESS) += scompress.o
+crypto_compress-y += scompress.o acompress.o
+obj-$(CONFIG_CRYPTO_COMPRESS2) += crypto_compress.o
 obj-$(CONFIG_CRYPTO_AKCIPHER2) += akcipher.o
 
 $(obj)/rsapubkey-asn1.o: $(obj)/rsapubkey-asn1.c $(obj)/rsapubkey-asn1.h
diff --git a/crypto/acompress.c b/crypto/acompress.c
new file mode 100644
index 0000000..744286b
--- /dev/null
+++ b/crypto/acompress.c
@@ -0,0 +1,164 @@
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
+
+#include <crypto/algapi.h>
+#include <linux/cryptouser.h>
+#include <net/netlink.h>
+#include <crypto/compress.h>
+#include <crypto/internal/compress.h>
+#include "internal.h"
+
+const struct crypto_type crypto_acomp_type;
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
+	if (tfm->__crt_alg->cra_type != &crypto_acomp_type)
+		return crypto_init_scomp_ops_async(tfm);
+
+	acomp->compress = alg->compress;
+	acomp->decompress = alg->decompress;
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
+static unsigned int crypto_acomp_extsize(struct crypto_alg *alg)
+{
+	if (alg->cra_type == &crypto_acomp_type)
+		return alg->cra_ctxsize;
+
+	return sizeof(void *);
+}
+
+const struct crypto_type crypto_acomp_type = {
+	.extsize = crypto_acomp_extsize,
+	.init_tfm = crypto_acomp_init_tfm,
+#ifdef CONFIG_PROC_FS
+	.show = crypto_acomp_show,
+#endif
+	.report = crypto_acomp_report,
+	.maskclear = ~CRYPTO_ALG_TYPE_MASK,
+	.maskset = CRYPTO_ALG_TYPE_ACOMPRESS_MASK,
+	.type = CRYPTO_ALG_TYPE_ACOMPRESS,
+	.tfmsize = offsetof(struct crypto_acomp, base),
+};
+EXPORT_SYMBOL_GPL(crypto_acomp_type);
+
+struct crypto_acomp *crypto_alloc_acomp(const char *alg_name, u32 type,
+					u32 mask)
+{
+	return crypto_alloc_tfm(alg_name, &crypto_acomp_type, type, mask);
+}
+EXPORT_SYMBOL_GPL(crypto_alloc_acomp);
+
+struct acomp_req *acomp_request_alloc(struct crypto_acomp *acomp,
+						gfp_t gfp)
+{
+	struct crypto_tfm *tfm = crypto_acomp_tfm(acomp);
+	struct acomp_req *req;
+
+	if (tfm->__crt_alg->cra_type != &crypto_acomp_type)
+		return crypto_scomp_acomp_request_alloc(acomp, gfp);
+
+	req = kzalloc(sizeof(*req) + crypto_acomp_reqsize(acomp), gfp);
+	if (likely(req))
+		acomp_request_set_tfm(req, acomp);
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
+		return crypto_scomp_acomp_request_free(req);
+
+	kfree(req);
+}
+EXPORT_SYMBOL_GPL(acomp_request_free);
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
+MODULE_DESCRIPTION("Asynchronous compression type");
diff --git a/crypto/scompress.c b/crypto/scompress.c
index 7c9955b..a60f6cb 100644
--- a/crypto/scompress.c
+++ b/crypto/scompress.c
@@ -24,8 +24,12 @@
 #include <linux/module.h>
 #include <linux/seq_file.h>
 #include <linux/cryptouser.h>
+#include <linux/vmalloc.h>
+#include <linux/highmem.h>
+#include <linux/gfp.h>
 
 #include <crypto/compress.h>
+#include <crypto/scatterwalk.h>
 #include <net/netlink.h>
 
 #include "internal.h"
@@ -90,6 +94,171 @@ struct crypto_scomp *crypto_alloc_scomp(const char *alg_name, u32 type,
 }
 EXPORT_SYMBOL_GPL(crypto_alloc_scomp);
 
+static void *scomp_map(struct scatterlist *sg, unsigned int len)
+{
+	gfp_t gfp_flags;
+	void *buf;
+
+	if (sg_is_last(sg))
+		return kmap_atomic(sg_page(sg)) + sg->offset;
+
+	if (in_atomic() || irqs_disabled())
+		gfp_flags = GFP_ATOMIC;
+	else
+		gfp_flags = GFP_KERNEL;
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
+static void scomp_unmap(struct scatterlist *sg, void *buf)
+{
+	if (!buf)
+		return;
+
+	if (sg_is_last(sg)) {
+		kunmap_atomic(buf);
+		return;
+	}
+
+	kfree(buf);
+}
+
+static int scomp_acomp_compress(struct acomp_req *req,
+			 struct crypto_acomp *tfm)
+{
+	int ret;
+	void **tfm_ctx = crypto_acomp_ctx(tfm);
+	struct crypto_scomp *scomp = (struct crypto_scomp *)*tfm_ctx;
+	void *ctx = *(req->__ctx);
+	char *src = scomp_map(req->src, req->src_len);
+	char *dst = scomp_map(req->dst, req->dst_len);
+
+	if (!src || !dst) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	req->out_len = req->dst_len;
+	ret = crypto_scomp_compress(scomp, src, req->src_len,
+				dst, &req->out_len, ctx);
+
+out:
+	scomp_unmap(req->src, src);
+	scomp_unmap(req->dst, dst);
+
+	return ret;
+}
+
+static int scomp_async_compress(struct acomp_req *req)
+{
+	return scomp_acomp_compress(req, crypto_acomp_reqtfm(req));
+}
+
+static int scomp_acomp_decompress(struct acomp_req *req,
+			   struct crypto_acomp *tfm)
+{
+	int ret;
+	void **tfm_ctx = crypto_acomp_ctx(tfm);
+	struct crypto_scomp *scomp = (struct crypto_scomp *)*tfm_ctx;
+	void *ctx = *(req->__ctx);
+	char *src = scomp_map(req->src, req->src_len);
+	char *dst = scomp_map(req->dst, req->dst_len);
+
+	if (!src || !dst) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	req->out_len = req->dst_len;
+	ret = crypto_scomp_decompress(scomp, src, req->src_len,
+				dst, &req->out_len, ctx);
+
+out:
+	scomp_unmap(req->src, src);
+	scomp_unmap(req->dst, dst);
+
+	return ret;
+}
+
+static int scomp_async_decompress(struct acomp_req *req)
+{
+	return scomp_acomp_decompress(req, crypto_acomp_reqtfm(req));
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
+	struct crypto_acomp *acomp = __crypto_acomp_tfm(tfm);
+	struct crypto_scomp *scomp;
+	void **ctx = crypto_tfm_ctx(tfm);
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
+	acomp->compress = scomp_async_compress;
+	acomp->decompress = scomp_async_decompress;
+	acomp->reqsize = sizeof(void *);
+
+	return 0;
+}
+
+struct acomp_req *crypto_scomp_acomp_request_alloc(struct crypto_acomp *tfm,
+							gfp_t gfp)
+{
+	void **tfm_ctx = crypto_acomp_ctx(tfm);
+	struct crypto_scomp *scomp = (struct crypto_scomp *)*tfm_ctx;
+	struct acomp_req *req;
+	void *ctx;
+
+	req = kzalloc(sizeof(*req) + crypto_acomp_reqsize(tfm), gfp);
+	if (!req)
+		return NULL;
+
+	ctx = crypto_scomp_alloc_ctx(scomp);
+	if (IS_ERR(ctx)) {
+		kfree(req);
+		return NULL;
+	}
+
+	*(req->__ctx) = ctx;
+	acomp_request_set_tfm(req, tfm);
+
+	return req;
+}
+
+void crypto_scomp_acomp_request_free(struct acomp_req *req)
+{
+	struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
+	void **tfm_ctx = crypto_acomp_ctx(tfm);
+	struct crypto_scomp *scomp = (struct crypto_scomp *)*tfm_ctx;
+	void *ctx = *(req->__ctx);
+
+	crypto_scomp_free_ctx(scomp, ctx);
+	kfree(req);
+}
+
 int crypto_register_scomp(struct scomp_alg *alg)
 {
 	struct crypto_alg *base = &alg->base;
diff --git a/include/crypto/compress.h b/include/crypto/compress.h
index 4d89a68..f1e91c5 100644
--- a/include/crypto/compress.h
+++ b/include/crypto/compress.h
@@ -73,4 +73,245 @@ static inline int crypto_scomp_decompress(struct crypto_scomp *tfm,
 
 extern int crypto_register_scomp(struct scomp_alg *alg);
 extern int crypto_unregister_scomp(struct scomp_alg *alg);
+
+/**
+ * struct acomp_req - asynchronous compression request
+ *
+ * @base:	Common attributes for async crypto requests
+ * @src:	Pointer to memory containing the input scatterlist buffer
+ * @dst:	Pointer to memory containing the output scatterlist buffer
+ * @src_len:	Length of input buffer
+ * @dst_len:	Length of output buffer
+ * @out_len:	Number of bytes produced by (de)compressor
+ * @__ctx:	Start of private context data
+ */
+struct acomp_req {
+	struct crypto_async_request base;
+	struct scatterlist *src;
+	struct scatterlist *dst;
+	unsigned int src_len;
+	unsigned int dst_len;
+	unsigned int out_len;
+	void *__ctx[] CRYPTO_MINALIGN_ATTR;
+};
+
+/**
+ * struct crypto_acomp - user-instantiated objects which encapsulate
+ * algorithms and core processing logic
+ *
+ * @compress:	Function performs a compress operation
+ * @decompress:	Function performs a de-compress operation
+ * @reqsize:	Request size required by algorithm implementation
+ * @base:	Common crypto API algorithm data structure
+ */
+struct crypto_acomp {
+	int (*compress)(struct acomp_req *req);
+	int (*decompress)(struct acomp_req *req);
+	unsigned int reqsize;
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
+ * @base:	Common crypto API algorithm data structure
+ */
+struct acomp_alg {
+	int (*compress)(struct acomp_req *req);
+	int (*decompress)(struct acomp_req *req);
+	int (*init)(struct crypto_acomp *tfm);
+	void (*exit)(struct crypto_acomp *tfm);
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
+static inline struct crypto_acomp *crypto_acomp_cast(struct crypto_tfm *tfm)
+{
+	return (struct crypto_acomp *)tfm;
+}
+
+static inline void *crypto_acomp_ctx(struct crypto_acomp *tfm)
+{
+	return crypto_tfm_ctx(crypto_acomp_tfm(tfm));
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
+	return tfm->reqsize;
+}
+
+static inline void acomp_request_set_tfm(struct acomp_req *req,
+					 struct crypto_acomp *tfm)
+{
+	req->base.tfm = crypto_acomp_tfm(tfm);
+}
+
+static inline struct crypto_acomp *crypto_acomp_reqtfm(
+				struct acomp_req *req)
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
+struct acomp_req *acomp_request_alloc(struct crypto_acomp *acomp,
+						gfp_t gfp);
+
+/**
+ * acomp_request_free() -- zeroize and free async compress request
+ *
+ * @req:	request to free
+ */
+void acomp_request_free(struct acomp_req *acomp);
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
+static inline void acomp_request_set_callback(struct acomp_req *req, u32 flgs,
+					crypto_completion_t cmpl, void *data)
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
+ * @dst:	ptr to output buffer list
+ * @src_len:	size of the input buffer
+ * @dst_len:	size of the output buffer
+ * @result:	(de)compression result returned by compressor
+ */
+static inline void acomp_request_set_comp(struct acomp_req *req,
+					  struct scatterlist *src,
+					  struct scatterlist *dst,
+					  unsigned int src_len,
+					  unsigned int dst_len)
+{
+	req->src = src;
+	req->dst = dst;
+	req->src_len = src_len;
+	req->dst_len = dst_len;
+	req->out_len = 0;
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
+static inline int crypto_acomp_compress(struct acomp_req *req)
+{
+	struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
+
+	return tfm->compress(req);
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
+static inline int crypto_acomp_decompress(struct acomp_req *req)
+{
+	struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
+
+	return tfm->decompress(req);
+}
 #endif
diff --git a/include/crypto/internal/compress.h b/include/crypto/internal/compress.h
new file mode 100644
index 0000000..088bc5b
--- /dev/null
+++ b/include/crypto/internal/compress.h
@@ -0,0 +1,4 @@
+extern int crypto_init_scomp_ops_async(struct crypto_tfm *tfm);
+extern struct acomp_req *
+crypto_scomp_acomp_request_alloc(struct crypto_acomp *tfm, gfp_t gfp);
+extern void crypto_scomp_acomp_request_free(struct acomp_req *req);
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 726df9b..86baa61 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -55,9 +55,11 @@
 #define CRYPTO_ALG_TYPE_RNG		0x0000000c
 #define CRYPTO_ALG_TYPE_AKCIPHER	0x0000000d
 #define CRYPTO_ALG_TYPE_SCOMPRESS	0x0000000e
+#define CRYPTO_ALG_TYPE_ACOMPRESS	0x0000000f
 
 #define CRYPTO_ALG_TYPE_HASH_MASK	0x0000000e
 #define CRYPTO_ALG_TYPE_AHASH_MASK	0x0000000c
+#define CRYPTO_ALG_TYPE_ACOMPRESS_MASK	0x0000000e
 #define CRYPTO_ALG_TYPE_BLKCIPHER_MASK	0x0000000c
 
 #define CRYPTO_ALG_LARVAL		0x00000010
-- 
1.9.1
