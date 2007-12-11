From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 10/19] [CRYPTO] chainiv: Add chain IV generator
Date: Tue, 11 Dec 2007 12:05:38 +0800
Message-ID: <E1J1wNG-0002ka-00@gondolin.me.apana.org.au>
References: <20071211040215.GA10360@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1956 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751198AbXLKEFm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Dec 2007 23:05:42 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1J1wNH-00067l-JO
	for <linux-crypto@vger.kernel.org>; Tue, 11 Dec 2007 15:05:39 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

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
 crypto/chainiv.c |  139 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 140 insertions(+)

diff --git a/crypto/Makefile b/crypto/Makefile
index 2a1883f..4b2e0c3 100644
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
index 0000000..38868d1
--- /dev/null
+++ b/crypto/chainiv.c
@@ -0,0 +1,139 @@
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
+#include <crypto/internal/skcipher.h>
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/random.h>
+#include <linux/spinlock.h>
+#include <linux/string.h>
+
+struct chainiv_ctx {
+	spinlock_t lock;
+	char iv[];
+};
+
+static int chainiv_givencrypt(struct skcipher_givcrypt_request *req)
+{
+	struct crypto_ablkcipher *geniv = skcipher_givcrypt_reqtfm(req);
+	struct chainiv_ctx *ctx = crypto_ablkcipher_ctx(geniv);
+	struct ablkcipher_request *subreq = skcipher_givcrypt_reqctx(req);
+	unsigned int ivsize;
+	int err;
+
+	ablkcipher_request_set_tfm(subreq, skcipher_geniv_cipher(geniv));
+	ablkcipher_request_set_callback(subreq, req->creq.base.flags &
+						~CRYPTO_TFM_REQ_MAY_SLEEP,
+					req->creq.base.complete,
+					req->creq.base.data);
+	ablkcipher_request_set_crypt(subreq, req->creq.src, req->creq.dst,
+				     req->creq.nbytes, req->creq.info);
+
+	spin_lock_bh(&ctx->lock);
+
+	ivsize = crypto_ablkcipher_ivsize(geniv);
+
+	memcpy(req->giv, ctx->iv, ivsize);
+	memcpy(subreq->info, ctx->iv, ivsize);
+
+	err = crypto_ablkcipher_encrypt(subreq);
+	if (err)
+		goto unlock;
+
+	memcpy(ctx->iv, subreq->info, ivsize);
+
+unlock:
+	spin_unlock_bh(&ctx->lock);
+
+	return err;
+}
+
+static int chainiv_givencrypt_first(struct skcipher_givcrypt_request *req)
+{
+	struct crypto_ablkcipher *geniv = skcipher_givcrypt_reqtfm(req);
+	struct chainiv_ctx *ctx = crypto_ablkcipher_ctx(geniv);
+
+	spin_lock_bh(&ctx->lock);
+	if (crypto_ablkcipher_crt(geniv)->givencrypt !=
+	    chainiv_givencrypt_first)
+		goto unlock;
+
+	crypto_ablkcipher_crt(geniv)->givencrypt = chainiv_givencrypt;
+	get_random_bytes(ctx->iv, crypto_ablkcipher_ivsize(geniv));
+
+unlock:
+	spin_unlock_bh(&ctx->lock);
+
+	return chainiv_givencrypt(req);
+}
+
+static int chainiv_init(struct crypto_tfm *tfm)
+{
+	struct crypto_ablkcipher *geniv = __crypto_ablkcipher_cast(tfm);
+	struct chainiv_ctx *ctx = crypto_ablkcipher_ctx(geniv);
+
+	spin_lock_init(&ctx->lock);
+
+	tfm->crt_ablkcipher.reqsize = sizeof(struct ablkcipher_request);
+
+	return skcipher_geniv_init(tfm);
+}
+
+static struct crypto_template chainiv_tmpl;
+
+static struct crypto_instance *chainiv_alloc(struct rtattr **tb)
+{
+	struct crypto_instance *inst;
+
+	inst = skcipher_geniv_alloc(&chainiv_tmpl, tb, 0,
+				    CRYPTO_ALG_ASYNC);
+	if (IS_ERR(inst))
+		goto out;
+
+	inst->alg.cra_ablkcipher.givencrypt = chainiv_givencrypt_first;
+
+	inst->alg.cra_init = chainiv_init;
+	inst->alg.cra_exit = skcipher_geniv_exit;
+
+	inst->alg.cra_ctxsize = sizeof(struct chainiv_ctx) +
+				inst->alg.cra_ablkcipher.ivsize;
+
+out:
+	return inst;
+}
+
+static struct crypto_template chainiv_tmpl = {
+	.name = "chainiv",
+	.alloc = chainiv_alloc,
+	.free = skcipher_geniv_free,
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
