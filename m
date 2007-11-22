From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 9/11] [CRYPTO] seqiv: Add Sequence Number IV Generator
Date: Thu, 22 Nov 2007 16:48:47 +0800
Message-ID: <E1Iv7jr-000215-00@gondolin.me.apana.org.au>
References: <20071122084758.GA7536@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1121 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751778AbXKVJCr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 22 Nov 2007 04:02:47 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1Iv7ju-0008DQ-C9
	for <linux-crypto@vger.kernel.org>; Thu, 22 Nov 2007 19:48:51 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

[CRYPTO] seqiv: Add Sequence Number IV Generator

This generator generates an IV based on a sequence number by xoring it
with a salt.  This algorithm is mainly useful for CTR and similar modes.

This patch also sets it as the default IV generator for ctr.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/Kconfig  |    5 +
 crypto/Makefile |    1 
 crypto/ctr.c    |    2 
 crypto/seqiv.c  |  202 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 210 insertions(+)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 0528702..d2e1ae6 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -32,6 +32,10 @@ config CRYPTO_BLKCIPHER
 	tristate
 	select CRYPTO_ALGAPI
 
+config CRYPTO_SEQIV
+	tristate
+	select CRYPTO_BLKCIPHER
+
 config CRYPTO_HASH
 	tristate
 	select CRYPTO_ALGAPI
@@ -197,6 +201,7 @@ config CRYPTO_XTS
 config CRYPTO_CTR
 	tristate "CTR support"
 	select CRYPTO_BLKCIPHER
+	select CRYPTO_SEQIV
 	select CRYPTO_MANAGER
 	help
 	  CTR: Counter mode
diff --git a/crypto/Makefile b/crypto/Makefile
index 4d50435..2770ad8 100644
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
index b816e95..47e044a 100644
--- a/crypto/ctr.c
+++ b/crypto/ctr.c
@@ -286,6 +286,8 @@ static struct crypto_instance *crypto_ctr_alloc(struct rtattr **tb)
 	inst->alg.cra_blkcipher.max_keysize = alg->cra_cipher.cia_max_keysize
 					      + noncesize;
 
+	memcpy(inst->alg.cra_blkcipher.geniv, "seqiv", sizeof("seqiv"));
+
 	inst->alg.cra_ctxsize = sizeof(struct crypto_ctr_ctx);
 
 	inst->alg.cra_init = crypto_ctr_init_tfm;
diff --git a/crypto/seqiv.c b/crypto/seqiv.c
new file mode 100644
index 0000000..77277d2
--- /dev/null
+++ b/crypto/seqiv.c
@@ -0,0 +1,202 @@
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
+#include <crypto/algapi.h>
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/random.h>
+#include <linux/spinlock.h>
+#include <linux/string.h>
+
+struct seqiv_ctx {
+	struct crypto_ablkcipher *cipher;
+	spinlock_t lock;
+	u8 salt[] __attribute__ ((aligned(__alignof__(u32))));
+};
+
+static void seqiv_complete2(struct ablkcipher_request *req, int err)
+{
+	struct ablkcipher_request *subreq = ablkcipher_request_ctx(req);
+	struct crypto_ablkcipher *geniv;
+
+	if (err == -EINPROGRESS)
+		return;
+
+	if (err)
+		goto out;
+
+	geniv = crypto_ablkcipher_reqtfm(req);
+	memcpy(req->info, subreq->info, crypto_ablkcipher_ivsize(geniv));
+
+out:
+	kfree(subreq->info);
+}
+
+static void seqiv_complete(struct crypto_async_request *base, int err)
+{
+	struct ablkcipher_request *req = base->data;
+
+	seqiv_complete2(req, err);
+	ablkcipher_request_complete(req, err);
+}
+
+static int seqiv_givcrypt(struct ablkcipher_request *req)
+{
+	struct crypto_ablkcipher *geniv = crypto_ablkcipher_reqtfm(req);
+	struct seqiv_ctx *ctx = crypto_ablkcipher_ctx(geniv);
+	struct ablkcipher_request *subreq = ablkcipher_request_ctx(req);
+	crypto_completion_t complete;
+	void *data;
+	u8 *info;
+	__be64 seq;
+	unsigned int ivsize;
+	unsigned int len;
+	int err;
+
+	ablkcipher_request_set_tfm(subreq, ctx->cipher);
+
+	complete = req->base.complete;
+	data = req->base.data;
+	info = req->info;
+
+	ivsize = crypto_ablkcipher_ivsize(geniv);
+
+	if (!IS_ALIGNED((unsigned long)info,
+			crypto_ablkcipher_alignmask(geniv) + 1)) {
+		info = kmalloc(ivsize, req->base.flags &
+				       CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL:
+								  GFP_ATOMIC);
+		if (!info)
+			return -ENOMEM;
+
+		complete = seqiv_complete;
+		data = req;
+	}
+
+	ablkcipher_request_set_callback(subreq, req->base.flags, complete,
+					data);
+	ablkcipher_request_set_crypt(subreq, req->src, req->dst, req->nbytes,
+				     info);
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
+	if (info != req->info)
+		seqiv_complete2(req, err);
+	return err;
+}
+
+static int seqiv_givcrypt_first(struct ablkcipher_request *req)
+{
+	struct crypto_ablkcipher *geniv = crypto_ablkcipher_reqtfm(req);
+	struct seqiv_ctx *ctx = crypto_ablkcipher_ctx(geniv);
+	struct crypto_ablkcipher *cipher = ctx->cipher;
+
+	spin_lock_bh(&ctx->lock);
+	if (crypto_ablkcipher_crt(cipher)->givcrypt != seqiv_givcrypt_first)
+		goto unlock;
+
+	crypto_ablkcipher_crt(cipher)->givcrypt = seqiv_givcrypt;
+	get_random_bytes(ctx->salt, crypto_ablkcipher_ivsize(geniv));
+
+unlock:
+	spin_unlock_bh(&ctx->lock);
+
+	return seqiv_givcrypt(req);
+}
+
+static int seqiv_init(struct crypto_tfm *tfm)
+{
+	struct crypto_instance *inst = (void *)tfm->__crt_alg;
+	struct crypto_spawn *spawn = crypto_instance_ctx(inst);
+	struct seqiv_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct crypto_ablkcipher *cipher;
+
+	cipher = crypto_spawn_nivcipher(spawn);
+	if (IS_ERR(cipher))
+		return PTR_ERR(cipher);
+
+	ctx->cipher = cipher;
+	spin_lock_init(&ctx->lock);
+
+	tfm->crt_ablkcipher.reqsize = sizeof(struct ablkcipher_request) +
+				      crypto_ablkcipher_reqsize(cipher);
+
+	return 0;
+}
+
+static void seqiv_exit(struct crypto_tfm *tfm)
+{
+	struct seqiv_ctx *ctx = crypto_tfm_ctx(tfm);
+	crypto_free_ablkcipher(ctx->cipher);
+}
+
+static struct crypto_template crypto_seqiv_tmpl;
+
+static struct crypto_instance *seqiv_alloc(struct rtattr **tb)
+{
+	struct crypto_instance *inst;
+
+	inst = givcipher_alloc_inst(&crypto_seqiv_tmpl, tb, 0, 0);
+	if (IS_ERR(inst))
+		goto out;
+
+	inst->alg.cra_ablkcipher.givcrypt = seqiv_givcrypt_first;
+
+	inst->alg.cra_init = seqiv_init;
+	inst->alg.cra_exit = seqiv_exit;
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
+	.free = givcipher_free_inst,
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
