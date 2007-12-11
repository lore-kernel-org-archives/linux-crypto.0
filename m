From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 14/19] [CRYPTO] seqiv: Add Sequence Number IV Generator
Date: Tue, 11 Dec 2007 12:05:42 +0800
Message-ID: <E1J1wNK-0002l8-00@gondolin.me.apana.org.au>
References: <20071211040215.GA10360@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1969 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751939AbXLKEFu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Dec 2007 23:05:50 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1J1wNM-000682-Fd
	for <linux-crypto@vger.kernel.org>; Tue, 11 Dec 2007 15:05:45 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[CRYPTO] seqiv: Add Sequence Number IV Generator

This generator generates an IV based on a sequence number by xoring it
with a salt.  This algorithm is mainly useful for CTR and similar modes.

This patch also sets it as the default IV generator for ctr.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/Kconfig  |    9 ++
 crypto/Makefile |    1 
 crypto/ctr.c    |    2 
 crypto/seqiv.c  |  186 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 198 insertions(+)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index a31864c..b838301 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -32,6 +32,14 @@ config CRYPTO_BLKCIPHER
 	tristate
 	select CRYPTO_ALGAPI
 
+config CRYPTO_SEQIV
+	tristate "Sequence Number IV Generator"
+	select CRYPTO_BLKCIPHER
+	help
+	  This IV generator generates an IV based on a sequence number by
+	  xoring it with a salt.  This algorithm is mainly useful for CTR
+	  and similar modes.
+
 config CRYPTO_HASH
 	tristate
 	select CRYPTO_ALGAPI
@@ -197,6 +205,7 @@ config CRYPTO_XTS
 config CRYPTO_CTR
 	tristate "CTR support"
 	select CRYPTO_BLKCIPHER
+	select CRYPTO_SEQIV
 	select CRYPTO_MANAGER
 	help
 	  CTR: Counter mode
diff --git a/crypto/Makefile b/crypto/Makefile
index 968b796..1b99b3a 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -15,6 +15,7 @@ crypto_blkcipher-objs += blkcipher.o
 obj-$(CONFIG_CRYPTO_BLKCIPHER) += crypto_blkcipher.o
 obj-$(CONFIG_CRYPTO_BLKCIPHER) += chainiv.o
 obj-$(CONFIG_CRYPTO_BLKCIPHER) += eseqiv.o
+obj-$(CONFIG_CRYPTO_SEQIV) += seqiv.o
 
 crypto_hash-objs := hash.o
 obj-$(CONFIG_CRYPTO_HASH) += crypto_hash.o
diff --git a/crypto/ctr.c b/crypto/ctr.c
index 1052b31..a51f973 100644
--- a/crypto/ctr.c
+++ b/crypto/ctr.c
@@ -210,6 +210,8 @@ static struct crypto_instance *crypto_ctr_alloc(struct rtattr **tb)
 	inst->alg.cra_blkcipher.min_keysize = alg->cra_cipher.cia_min_keysize;
 	inst->alg.cra_blkcipher.max_keysize = alg->cra_cipher.cia_max_keysize;
 
+	inst->alg.cra_blkcipher.geniv = "seqiv";
+
 	inst->alg.cra_ctxsize = sizeof(struct crypto_ctr_ctx);
 
 	inst->alg.cra_init = crypto_ctr_init_tfm;
diff --git a/crypto/seqiv.c b/crypto/seqiv.c
new file mode 100644
index 0000000..9c2d80d
--- /dev/null
+++ b/crypto/seqiv.c
@@ -0,0 +1,186 @@
+/*
+ * seqiv: Sequence Number IV Generator
+ *
+ * This generator generates an IV based on a sequence number by xoring it
+ * with a salt.  This algorithm is mainly useful for CTR and similar modes.
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
+#include <crypto/internal/skcipher.h>
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/random.h>
+#include <linux/spinlock.h>
+#include <linux/string.h>
+
+struct seqiv_ctx {
+	spinlock_t lock;
+	u8 salt[] __attribute__ ((aligned(__alignof__(u32))));
+};
+
+static void seqiv_complete2(struct skcipher_givcrypt_request *req, int err)
+{
+	struct ablkcipher_request *subreq = skcipher_givcrypt_reqctx(req);
+	struct crypto_ablkcipher *geniv;
+
+	if (err == -EINPROGRESS)
+		return;
+
+	if (err)
+		goto out;
+
+	geniv = skcipher_givcrypt_reqtfm(req);
+	memcpy(req->creq.info, subreq->info, crypto_ablkcipher_ivsize(geniv));
+
+out:
+	kfree(subreq->info);
+}
+
+static void seqiv_complete(struct crypto_async_request *base, int err)
+{
+	struct skcipher_givcrypt_request *req = base->data;
+
+	seqiv_complete2(req, err);
+	skcipher_givcrypt_complete(req, err);
+}
+
+static int seqiv_givencrypt(struct skcipher_givcrypt_request *req)
+{
+	struct crypto_ablkcipher *geniv = skcipher_givcrypt_reqtfm(req);
+	struct seqiv_ctx *ctx = crypto_ablkcipher_ctx(geniv);
+	struct ablkcipher_request *subreq = skcipher_givcrypt_reqctx(req);
+	crypto_completion_t complete;
+	void *data;
+	u8 *info;
+	__be64 seq;
+	unsigned int ivsize;
+	unsigned int len;
+	int err;
+
+	ablkcipher_request_set_tfm(subreq, skcipher_geniv_cipher(geniv));
+
+	complete = req->creq.base.complete;
+	data = req->creq.base.data;
+	info = req->creq.info;
+
+	ivsize = crypto_ablkcipher_ivsize(geniv);
+
+	if (unlikely(!IS_ALIGNED((unsigned long)info,
+				 crypto_ablkcipher_alignmask(geniv) + 1))) {
+		info = kmalloc(ivsize, req->creq.base.flags &
+				       CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL:
+								  GFP_ATOMIC);
+		if (!info)
+			return -ENOMEM;
+
+		complete = seqiv_complete;
+		data = req;
+	}
+
+	ablkcipher_request_set_callback(subreq, req->creq.base.flags, complete,
+					data);
+	ablkcipher_request_set_crypt(subreq, req->creq.src, req->creq.dst,
+				     req->creq.nbytes, info);
+
+	len = ivsize;
+	if (ivsize > sizeof(u64)) {
+		memset(info, 0, ivsize - sizeof(u64));
+		len = sizeof(u64);
+	}
+	seq = cpu_to_be64(req->seq);
+	memcpy(info + ivsize - len, &seq, len);
+	crypto_xor(info, ctx->salt, ivsize);
+
+	memcpy(req->giv, info, ivsize);
+
+	err = crypto_ablkcipher_encrypt(subreq);
+	if (unlikely(info != req->creq.info))
+		seqiv_complete2(req, err);
+	return err;
+}
+
+static int seqiv_givencrypt_first(struct skcipher_givcrypt_request *req)
+{
+	struct crypto_ablkcipher *geniv = skcipher_givcrypt_reqtfm(req);
+	struct seqiv_ctx *ctx = crypto_ablkcipher_ctx(geniv);
+
+	spin_lock_bh(&ctx->lock);
+	if (crypto_ablkcipher_crt(geniv)->givencrypt != seqiv_givencrypt_first)
+		goto unlock;
+
+	crypto_ablkcipher_crt(geniv)->givencrypt = seqiv_givencrypt;
+	get_random_bytes(ctx->salt, crypto_ablkcipher_ivsize(geniv));
+
+unlock:
+	spin_unlock_bh(&ctx->lock);
+
+	return seqiv_givencrypt(req);
+}
+
+static int seqiv_init(struct crypto_tfm *tfm)
+{
+	struct crypto_ablkcipher *geniv = __crypto_ablkcipher_cast(tfm);
+	struct seqiv_ctx *ctx = crypto_ablkcipher_ctx(geniv);
+
+	spin_lock_init(&ctx->lock);
+
+	tfm->crt_ablkcipher.reqsize = sizeof(struct ablkcipher_request);
+
+	return skcipher_geniv_init(tfm);
+}
+
+static struct crypto_template seqiv_tmpl;
+
+static struct crypto_instance *seqiv_alloc(struct rtattr **tb)
+{
+	struct crypto_instance *inst;
+
+	inst = skcipher_geniv_alloc(&seqiv_tmpl, tb, 0, 0);
+	if (IS_ERR(inst))
+		goto out;
+
+	inst->alg.cra_ablkcipher.givencrypt = seqiv_givencrypt_first;
+
+	inst->alg.cra_init = seqiv_init;
+	inst->alg.cra_exit = skcipher_geniv_exit;
+
+	inst->alg.cra_alignmask |= __alignof__(u32) - 1;
+
+	inst->alg.cra_ctxsize = sizeof(struct seqiv_ctx);
+	inst->alg.cra_ctxsize += inst->alg.cra_ablkcipher.ivsize;
+
+out:
+	return inst;
+}
+
+static struct crypto_template seqiv_tmpl = {
+	.name = "seqiv",
+	.alloc = seqiv_alloc,
+	.free = skcipher_geniv_free,
+	.module = THIS_MODULE,
+};
+
+static int __init seqiv_module_init(void)
+{
+	return crypto_register_template(&seqiv_tmpl);
+}
+
+static void __exit seqiv_module_exit(void)
+{
+	crypto_unregister_template(&seqiv_tmpl);
+}
+
+module_init(seqiv_module_init);
+module_exit(seqiv_module_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Sequence Number IV Generator");
