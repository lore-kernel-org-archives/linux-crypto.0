From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7/11] [CRYPTO] eseqiv: Add Encrypted Sequence Number IV Generator
Date: Thu, 22 Nov 2007 16:48:45 +0800
Message-ID: <E1Iv7jp-00020p-00@gondolin.me.apana.org.au>
References: <20071122084758.GA7536@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1122 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751813AbXKVJCu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 22 Nov 2007 04:02:50 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1Iv7js-0008D4-Mn
	for <linux-crypto@vger.kernel.org>; Thu, 22 Nov 2007 19:48:50 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

[CRYPTO] eseqiv: Add Encrypted Sequence Number IV Generator

This generator generates an IV based on a sequence number by xoring it
with a salt and then encrypting it with the same key as used to encrypt
the plain text.  This algorithm requires that the block size be equal
to the IV size.  It is mainly useful for CBC.

It has one noteworthy property that for IPsec the IV happens to lie
just before the plain text so the IV generation simply increases the
number of encrypted blocks by one.  Therefore the cost of this generator
is entirely dependent on the speed of the underlying cipher.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/Makefile |    1 
 crypto/eseqiv.c |  276 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 277 insertions(+)

diff --git a/crypto/Makefile b/crypto/Makefile
index 8d6afb4..4d50435 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -14,6 +14,7 @@ crypto_blkcipher-objs := ablkcipher.o
 crypto_blkcipher-objs += blkcipher.o
 obj-$(CONFIG_CRYPTO_BLKCIPHER) += crypto_blkcipher.o
 obj-$(CONFIG_CRYPTO_BLKCIPHER) += chainiv.o
+obj-$(CONFIG_CRYPTO_BLKCIPHER) += eseqiv.o
 
 crypto_hash-objs := hash.o
 obj-$(CONFIG_CRYPTO_HASH) += crypto_hash.o
diff --git a/crypto/eseqiv.c b/crypto/eseqiv.c
new file mode 100644
index 0000000..b171b46
--- /dev/null
+++ b/crypto/eseqiv.c
@@ -0,0 +1,276 @@
+/*
+ * eseqiv: Encrypted Sequence Number IV Generator
+ *
+ * This generator generates an IV based on a sequence number by xoring it
+ * with a salt and then encrypting it with the same key as used to encrypt
+ * the plain text.  This algorithm requires that the block size be equal
+ * to the IV size.  It is mainly useful for CBC.
+ *
+ * Copyright (c) 2007 Herbert Xu <herbert@gondor.apana.org.au>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ *
+ */
+
+#include <crypto/algapi.h>
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/random.h>
+#include <linux/scatterlist.h>
+#include <linux/spinlock.h>
+#include <linux/string.h>
+
+struct eseqiv_request_ctx {
+	struct scatterlist src[2];
+	struct scatterlist dst[2];
+	char tail[];
+};
+
+struct eseqiv_ctx {
+	struct crypto_ablkcipher *cipher;
+	spinlock_t lock;
+	unsigned int ivoff;
+	unsigned int reqoff;
+	char salt[];
+};
+
+static void eseqiv_complete2(struct ablkcipher_request *req)
+{
+	struct crypto_ablkcipher *geniv = crypto_ablkcipher_reqtfm(req);
+	struct eseqiv_ctx *ctx = crypto_ablkcipher_ctx(geniv);
+	struct eseqiv_request_ctx *reqctx = ablkcipher_request_ctx(req);
+
+	memcpy(req->giv, reqctx->tail + ctx->ivoff,
+	       crypto_ablkcipher_ivsize(geniv));
+}
+
+static void eseqiv_complete(struct crypto_async_request *base, int err)
+{
+	struct ablkcipher_request *req = base->data;
+
+	if (err)
+		goto out;
+
+	eseqiv_complete2(req);
+
+out:
+	ablkcipher_request_complete(req, err);
+}
+
+static void eseqiv_chain(struct scatterlist *head, struct scatterlist *sg,
+			 int chain)
+{
+	if (chain) {
+		head->length += sg->length;
+		sg = sg_next(sg);
+	}
+
+	if (sg)
+		sg_chain(head, 2, sg);
+	else
+		sg_mark_end(head);
+}
+
+static int eseqiv_givcrypt(struct ablkcipher_request *req)
+{
+	struct crypto_ablkcipher *geniv = crypto_ablkcipher_reqtfm(req);
+	struct eseqiv_ctx *ctx = crypto_ablkcipher_ctx(geniv);
+	struct eseqiv_request_ctx *reqctx = ablkcipher_request_ctx(req);
+	struct ablkcipher_request *subreq;
+	crypto_completion_t complete;
+	void *data;
+	struct scatterlist *dst;
+	struct page *srcp;
+	struct page *dstp;
+	u8 *giv;
+	u8 *vsrc;
+	u8 *vdst;
+	__be64 seq;
+	unsigned int ivsize;
+	unsigned int len;
+	int err;
+
+	subreq = (void *)(reqctx->tail + ctx->reqoff);
+	ablkcipher_request_set_tfm(subreq, ctx->cipher);
+
+	giv = req->giv;
+	complete = req->base.complete;
+	data = req->base.data;
+
+	srcp = sg_page(req->src);
+	dstp = sg_page(req->dst);
+	vsrc = PageHighMem(srcp) ? NULL : page_address(srcp) + req->src->offset;
+	vdst = PageHighMem(dstp) ? NULL : page_address(dstp) + req->dst->offset;
+
+	ivsize = crypto_ablkcipher_ivsize(geniv);
+
+	if (vsrc != giv + ivsize && vdst != giv + ivsize) {
+		giv = reqctx->tail + ctx->ivoff;
+		complete = eseqiv_complete;
+		data = req;
+	}
+
+	ablkcipher_request_set_callback(subreq, req->base.flags, complete,
+					data);
+
+	sg_init_table(reqctx->src, 2);
+	sg_set_buf(reqctx->src, giv, ivsize);
+	eseqiv_chain(reqctx->src, req->src, vsrc == giv + ivsize);
+
+	dst = reqctx->src;
+	if (req->src != req->dst) {
+		sg_init_table(reqctx->dst, 2);
+		sg_set_buf(reqctx->dst, giv, ivsize);
+		eseqiv_chain(reqctx->dst, req->dst, vdst == giv + ivsize);
+
+		dst = reqctx->dst;
+	}
+
+	ablkcipher_request_set_crypt(subreq, reqctx->src, dst,
+				     req->nbytes, req->info);
+
+	memcpy(req->info, ctx->salt, ivsize);
+
+	len = ivsize;
+	if (ivsize > sizeof(u64)) {
+		memset(req->giv, 0, ivsize - sizeof(u64));
+		len = sizeof(u64);
+	}
+	seq = cpu_to_be64(req->seq);
+	memcpy(req->giv + ivsize - len, &seq, len);
+
+	err = crypto_ablkcipher_encrypt(subreq);
+	if (err)
+		goto out;
+
+	eseqiv_complete2(req);
+
+out:
+	return err;
+}
+
+static int eseqiv_givcrypt_first(struct ablkcipher_request *req)
+{
+	struct crypto_ablkcipher *geniv = crypto_ablkcipher_reqtfm(req);
+	struct eseqiv_ctx *ctx = crypto_ablkcipher_ctx(geniv);
+	struct crypto_ablkcipher *cipher = ctx->cipher;
+
+	spin_lock_bh(&ctx->lock);
+	if (crypto_ablkcipher_crt(cipher)->givcrypt != eseqiv_givcrypt_first)
+		goto unlock;
+
+	crypto_ablkcipher_crt(cipher)->givcrypt = eseqiv_givcrypt;
+	get_random_bytes(ctx->salt, crypto_ablkcipher_ivsize(geniv));
+
+unlock:
+	spin_unlock_bh(&ctx->lock);
+
+	return eseqiv_givcrypt(req);
+}
+
+static int eseqiv_init(struct crypto_tfm *tfm)
+{
+	struct crypto_instance *inst = (void *)tfm->__crt_alg;
+	struct crypto_spawn *spawn = crypto_instance_ctx(inst);
+	struct eseqiv_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct crypto_ablkcipher *cipher;
+	unsigned long alignmask;
+	unsigned int reqsize;
+
+	cipher = crypto_spawn_nivcipher(spawn);
+	if (IS_ERR(cipher))
+		return PTR_ERR(cipher);
+
+	ctx->cipher = cipher;
+	spin_lock_init(&ctx->lock);
+
+	alignmask = crypto_tfm_ctx_alignment() - 1;
+	if (alignmask & sizeof(struct eseqiv_request_ctx)) {
+		alignmask &= sizeof(struct eseqiv_request_ctx);
+		alignmask--;
+	}
+
+	alignmask = ~alignmask;
+	alignmask &= crypto_ablkcipher_alignmask(cipher);
+
+	reqsize = sizeof(struct eseqiv_request_ctx);
+	reqsize += alignmask;
+	reqsize += crypto_ablkcipher_ivsize(cipher);
+	reqsize = ALIGN(reqsize, __alignof__(struct ablkcipher_request));
+
+	ctx->ivoff = alignmask;
+	ctx->reqoff = reqsize - sizeof(struct eseqiv_request_ctx);
+
+	tfm->crt_ablkcipher.reqsize = reqsize +
+				      sizeof(struct ablkcipher_request) +
+				      crypto_ablkcipher_reqsize(cipher);
+
+	return 0;
+}
+
+static void eseqiv_exit(struct crypto_tfm *tfm)
+{
+	struct eseqiv_ctx *ctx = crypto_tfm_ctx(tfm);
+	crypto_free_ablkcipher(ctx->cipher);
+}
+
+static struct crypto_template crypto_eseqiv_tmpl;
+
+static struct crypto_instance *eseqiv_alloc(struct rtattr **tb)
+{
+	struct crypto_instance *inst;
+	int err;
+
+	inst = givcipher_alloc_inst(&crypto_eseqiv_tmpl, tb, 0, 0);
+	if (IS_ERR(inst))
+		goto out;
+
+	err = -EINVAL;
+	if (inst->alg.cra_ablkcipher.ivsize != inst->alg.cra_blocksize)
+		goto free_inst;
+
+	inst->alg.cra_ablkcipher.givcrypt = eseqiv_givcrypt_first;
+
+	inst->alg.cra_init = eseqiv_init;
+	inst->alg.cra_exit = eseqiv_exit;
+
+	inst->alg.cra_ctxsize = sizeof(struct eseqiv_ctx);
+	inst->alg.cra_ctxsize += inst->alg.cra_ablkcipher.ivsize;
+
+out:
+	return inst;
+
+free_inst:
+	givcipher_free_inst(inst);
+	inst = ERR_PTR(err);
+	goto out;
+}
+
+static struct crypto_template eseqiv_tmpl = {
+	.name = "eseqiv",
+	.alloc = eseqiv_alloc,
+	.free = givcipher_free_inst,
+	.module = THIS_MODULE,
+};
+
+static int __init eseqiv_module_init(void)
+{
+	return crypto_register_template(&eseqiv_tmpl);
+}
+
+static void __exit eseqiv_module_exit(void)
+{
+	crypto_unregister_template(&eseqiv_tmpl);
+}
+
+module_init(eseqiv_module_init);
+module_exit(eseqiv_module_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Encrypted Sequence Number IV Generator");
