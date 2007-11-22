From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5/11] [CRYPTO] chainiv: Add chain IV generator
Date: Thu, 22 Nov 2007 16:48:43 +0800
Message-ID: <E1Iv7jn-00020S-00@gondolin.me.apana.org.au>
References: <20071122084758.GA7536@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4679 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751528AbXKVIsz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 22 Nov 2007 03:48:55 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1Iv7jq-0008Ce-3E
	for <linux-crypto@vger.kernel.org>; Thu, 22 Nov 2007 19:48:46 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

[CRYPTO] chainiv: Add chain IV generator

The chain IV generator is the one we've been using in the IPsec stack.
It simply starts out with a random IV, then uses the last block of each
encrypted packet's cipher text as the IV for the next packet.

It can only be used by synchronous ciphers since we have to make sure
that we don't start the encryption of the next packet until the last
one has completed.

It does have the advantage of using very little CPU time since it doesn't
have to generate anything at all.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/Makefile  |    1 
 crypto/chainiv.c |  153 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 154 insertions(+)

diff --git a/crypto/Makefile b/crypto/Makefile
index b8b3296..8d6afb4 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -13,6 +13,7 @@ obj-$(CONFIG_CRYPTO_AEAD) += aead.o
 crypto_blkcipher-objs := ablkcipher.o
 crypto_blkcipher-objs += blkcipher.o
 obj-$(CONFIG_CRYPTO_BLKCIPHER) += crypto_blkcipher.o
+obj-$(CONFIG_CRYPTO_BLKCIPHER) += chainiv.o
 
 crypto_hash-objs := hash.o
 obj-$(CONFIG_CRYPTO_HASH) += crypto_hash.o
diff --git a/crypto/chainiv.c b/crypto/chainiv.c
new file mode 100644
index 0000000..25aa244
--- /dev/null
+++ b/crypto/chainiv.c
@@ -0,0 +1,153 @@
+/*
+ * chainiv: Chain IV Generator
+ *
+ * Generate IVs simply be using the last block of the previous encryption.
+ * This is mainly useful for CBC with a synchronous algorithm.
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
+#include <linux/module.h>
+#include <linux/random.h>
+#include <linux/spinlock.h>
+#include <linux/string.h>
+
+struct chainiv_ctx {
+	struct crypto_ablkcipher *cipher;
+	spinlock_t lock;
+	char iv[];
+};
+
+static int chainiv_givcrypt(struct ablkcipher_request *req)
+{
+	struct crypto_ablkcipher *geniv = crypto_ablkcipher_reqtfm(req);
+	struct chainiv_ctx *ctx = crypto_ablkcipher_ctx(geniv);
+	struct ablkcipher_request *subreq = ablkcipher_request_ctx(req);
+	unsigned int ivsize;
+	int err;
+
+	ablkcipher_request_set_tfm(subreq, ctx->cipher);
+	ablkcipher_request_set_callback(subreq, req->base.flags &
+						~CRYPTO_TFM_REQ_MAY_SLEEP,
+					req->base.complete, req->base.data);
+	ablkcipher_request_set_crypt(subreq, req->src, req->dst, req->nbytes,
+				     req->info);
+
+	spin_lock_bh(&ctx->lock);
+
+	ivsize = crypto_ablkcipher_ivsize(geniv);
+
+	memcpy(req->giv, ctx->iv, ivsize);
+	memcpy(req->info, ctx->iv, ivsize);
+
+	err = crypto_ablkcipher_encrypt(subreq);
+	if (err)
+		goto unlock;
+
+	memcpy(ctx->iv, req->info, ivsize);
+
+unlock:
+	spin_unlock_bh(&ctx->lock);
+
+	return err;
+}
+
+static int chainiv_givcrypt_first(struct ablkcipher_request *req)
+{
+	struct crypto_ablkcipher *geniv = crypto_ablkcipher_reqtfm(req);
+	struct chainiv_ctx *ctx = crypto_ablkcipher_ctx(geniv);
+	struct crypto_ablkcipher *cipher = ctx->cipher;
+
+	spin_lock_bh(&ctx->lock);
+	if (crypto_ablkcipher_crt(cipher)->givcrypt != chainiv_givcrypt_first)
+		goto unlock;
+
+	crypto_ablkcipher_crt(cipher)->givcrypt = chainiv_givcrypt;
+	get_random_bytes(ctx->iv, crypto_ablkcipher_ivsize(geniv));
+
+unlock:
+	spin_unlock_bh(&ctx->lock);
+
+	return chainiv_givcrypt(req);
+}
+
+static int chainiv_init(struct crypto_tfm *tfm)
+{
+	struct crypto_instance *inst = (void *)tfm->__crt_alg;
+	struct crypto_spawn *spawn = crypto_instance_ctx(inst);
+	struct chainiv_ctx *ctx = crypto_tfm_ctx(tfm);
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
+static void chainiv_exit(struct crypto_tfm *tfm)
+{
+	struct chainiv_ctx *ctx = crypto_tfm_ctx(tfm);
+	crypto_free_ablkcipher(ctx->cipher);
+}
+
+static struct crypto_template crypto_chainiv_tmpl;
+
+static struct crypto_instance *chainiv_alloc(struct rtattr **tb)
+{
+	struct crypto_instance *inst;
+
+	inst = givcipher_alloc_inst(&crypto_chainiv_tmpl, tb, 0,
+				    CRYPTO_ALG_ASYNC);
+	if (IS_ERR(inst))
+		goto out;
+
+	inst->alg.cra_ablkcipher.givcrypt = chainiv_givcrypt_first;
+
+	inst->alg.cra_init = chainiv_init;
+	inst->alg.cra_exit = chainiv_exit;
+
+	inst->alg.cra_ctxsize = sizeof(struct chainiv_ctx);
+	inst->alg.cra_ctxsize += inst->alg.cra_ablkcipher.ivsize;
+
+out:
+	return inst;
+}
+
+static struct crypto_template chainiv_tmpl = {
+	.name = "chainiv",
+	.alloc = chainiv_alloc,
+	.free = givcipher_free_inst,
+	.module = THIS_MODULE,
+};
+
+static int __init chainiv_module_init(void)
+{
+	return crypto_register_template(&chainiv_tmpl);
+}
+
+static void __exit chainiv_module_exit(void)
+{
+	crypto_unregister_template(&chainiv_tmpl);
+}
+
+module_init(chainiv_module_init);
+module_exit(chainiv_module_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Chain IV Generator");
