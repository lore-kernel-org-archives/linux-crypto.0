From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [RFC] [PATCH 2/4] cpu_chainiv: add percpu IV chain genarator
Date: Mon, 16 Mar 2009 12:52:51 +0100
Message-ID: <20090316115251.GP13998@secunet.com>
References: <20090316114940.GN13998@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	David Miller <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([213.68.205.161]:52462 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751960AbZCPMN5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 16 Mar 2009 08:13:57 -0400
Content-Disposition: inline
In-Reply-To: <20090316114940.GN13998@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

If the crypro requests of a crypto transformation are processed in
parallel, the usual chain IV generator would serialize the crypto
requests again. The percpu IV chain genarator allocates the IV as
percpu data and generates percpu IV chains, so a crypro request
does not need to wait for the completition of the IV generation
from a previous request that runs on a different cpu.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 crypto/Makefile      |    1 +
 crypto/cpu_chainiv.c |  327 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 328 insertions(+), 0 deletions(-)
 create mode 100644 crypto/cpu_chainiv.c

diff --git a/crypto/Makefile b/crypto/Makefile
index 673d9f7..24f7279 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -19,6 +19,7 @@ crypto_blkcipher-objs := ablkcipher.o
 crypto_blkcipher-objs += blkcipher.o
 obj-$(CONFIG_CRYPTO_BLKCIPHER2) += crypto_blkcipher.o
 obj-$(CONFIG_CRYPTO_BLKCIPHER2) += chainiv.o
+obj-$(CONFIG_CRYPTO_BLKCIPHER2) += cpu_chainiv.o
 obj-$(CONFIG_CRYPTO_BLKCIPHER2) += eseqiv.o
 obj-$(CONFIG_CRYPTO_SEQIV) += seqiv.o
 
diff --git a/crypto/cpu_chainiv.c b/crypto/cpu_chainiv.c
new file mode 100644
index 0000000..8acfc77
--- /dev/null
+++ b/crypto/cpu_chainiv.c
@@ -0,0 +1,327 @@
+/*
+ * cpu_chainiv - Per CPU Chain IV Generator
+ *
+ * Generate IVs by using the last block of the previous encryption on
+ * the local cpu. This is mainly useful for CBC with a parallel algorithm.
+ *
+ * Based on chainiv.c by Herbert Xu <herbert@gondor.apana.org.au>
+ *
+ * Copyright (C) 2009 secunet Security Networks AG
+ * Copyright (C) 2009 Steffen Klassert <steffen.klassert@secunet.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#include <crypto/internal/skcipher.h>
+#include <crypto/internal/aead.h>
+#include <crypto/rng.h>
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/spinlock.h>
+#include <linux/string.h>
+
+struct cpu_civ_ctx {
+	spinlock_t	lock;
+	char		*iv;
+};
+
+static int cpu_civ_aead_givencrypt(struct aead_givcrypt_request *req)
+{
+	struct crypto_aead *geniv = aead_givcrypt_reqtfm(req);
+	struct cpu_civ_ctx *ctx = crypto_aead_ctx(geniv);
+	struct aead_request *subreq = aead_givcrypt_reqctx(req);
+	unsigned int ivsize;
+	char *iv;
+	int err;
+
+	aead_request_set_tfm(subreq, aead_geniv_base(geniv));
+	aead_request_set_callback(subreq, req->areq.base.flags,
+				  req->areq.base.complete,
+				  req->areq.base.data);
+	aead_request_set_crypt(subreq, req->areq.src, req->areq.dst,
+			       req->areq.cryptlen, req->areq.iv);
+	aead_request_set_assoc(subreq, req->areq.assoc, req->areq.assoclen);
+
+	local_bh_disable();
+
+	ivsize = crypto_aead_ivsize(geniv);
+
+	iv = per_cpu_ptr(ctx->iv, smp_processor_id());
+
+	memcpy(req->giv, iv, ivsize);
+	memcpy(subreq->iv, iv, ivsize);
+
+	err = crypto_aead_encrypt(subreq);
+	if (err)
+		goto unlock;
+
+	memcpy(iv, subreq->iv, ivsize);
+
+unlock:
+	local_bh_enable();
+
+	return err;
+}
+
+static int cpu_civ_aead_givencrypt_first(struct aead_givcrypt_request *req)
+{
+	struct crypto_aead *geniv = aead_givcrypt_reqtfm(req);
+	struct cpu_civ_ctx *ctx = crypto_aead_ctx(geniv);
+	char *iv;
+	int err = 0;
+	int cpu;
+
+	spin_lock_bh(&ctx->lock);
+	if (crypto_aead_crt(geniv)->givencrypt != cpu_civ_aead_givencrypt_first)
+		goto unlock;
+
+	crypto_aead_crt(geniv)->givencrypt = cpu_civ_aead_givencrypt;
+
+	for_each_possible_cpu(cpu) {
+		iv = per_cpu_ptr(ctx->iv, cpu);
+		err = crypto_rng_get_bytes(crypto_default_rng, iv,
+					   crypto_aead_ivsize(geniv));
+
+		if (err)
+			break;
+	}
+
+unlock:
+	spin_unlock_bh(&ctx->lock);
+
+	if (err)
+		return err;
+
+	return cpu_civ_aead_givencrypt(req);
+}
+
+static int cpu_civ_ablkcipher_givencrypt(struct skcipher_givcrypt_request *req)
+{
+	struct crypto_ablkcipher *geniv = skcipher_givcrypt_reqtfm(req);
+	struct cpu_civ_ctx *ctx = crypto_ablkcipher_ctx(geniv);
+	struct ablkcipher_request *subreq = skcipher_givcrypt_reqctx(req);
+	unsigned int ivsize;
+	char *iv;
+	int err;
+
+	ablkcipher_request_set_tfm(subreq, skcipher_geniv_cipher(geniv));
+	ablkcipher_request_set_callback(subreq, req->creq.base.flags,
+					req->creq.base.complete,
+					req->creq.base.data);
+	ablkcipher_request_set_crypt(subreq, req->creq.src, req->creq.dst,
+				     req->creq.nbytes, req->creq.info);
+
+	local_bh_disable();
+
+	ivsize = crypto_ablkcipher_ivsize(geniv);
+
+	iv = per_cpu_ptr(ctx->iv, smp_processor_id());
+
+	memcpy(req->giv, iv, ivsize);
+	memcpy(subreq->info, iv, ivsize);
+
+	err = crypto_ablkcipher_encrypt(subreq);
+	if (err)
+		goto unlock;
+
+	memcpy(iv, subreq->info, ivsize);
+
+unlock:
+	local_bh_enable();
+
+	return err;
+}
+
+static int cpu_civ_ablkcipher_givencrypt_first(
+	struct skcipher_givcrypt_request *req)
+{
+	struct crypto_ablkcipher *geniv = skcipher_givcrypt_reqtfm(req);
+	struct cpu_civ_ctx *ctx = crypto_ablkcipher_ctx(geniv);
+	char *iv;
+	int err = 0;
+	int cpu;
+
+	spin_lock_bh(&ctx->lock);
+	if (crypto_ablkcipher_crt(geniv)->givencrypt !=
+	    cpu_civ_ablkcipher_givencrypt_first)
+		goto unlock;
+
+	crypto_ablkcipher_crt(geniv)->givencrypt = cpu_civ_ablkcipher_givencrypt;
+
+	for_each_possible_cpu(cpu) {
+		iv = per_cpu_ptr(ctx->iv, cpu);
+		err = crypto_rng_get_bytes(crypto_default_rng, iv,
+					   crypto_ablkcipher_ivsize(geniv));
+
+		if (err)
+			break;
+	}
+
+unlock:
+	spin_unlock_bh(&ctx->lock);
+
+	if (err)
+		return err;
+
+	return cpu_civ_ablkcipher_givencrypt(req);
+}
+
+static int cpu_civ_aead_init(struct crypto_tfm *tfm)
+{
+	struct cpu_civ_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	spin_lock_init(&ctx->lock);
+	tfm->crt_aead.reqsize = sizeof(struct aead_request);
+
+	ctx->iv = __alloc_percpu(tfm->crt_aead.ivsize);
+
+	if (!ctx->iv)
+		return -ENOMEM;
+
+	return aead_geniv_init(tfm);
+}
+
+void cpu_civ_aead_exit(struct crypto_tfm *tfm)
+{
+	struct cpu_civ_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	free_percpu(ctx->iv);
+	aead_geniv_exit(tfm);
+}
+
+static int cpu_civ_ablkcipher_init(struct crypto_tfm *tfm)
+{
+	struct cpu_civ_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	spin_lock_init(&ctx->lock);
+	tfm->crt_ablkcipher.reqsize = sizeof(struct ablkcipher_request);
+
+	ctx->iv = __alloc_percpu(tfm->crt_ablkcipher.ivsize);
+
+	if (!ctx->iv)
+		return -ENOMEM;
+
+	return skcipher_geniv_init(tfm);
+}
+
+void cpu_civ_ablkcipher_exit(struct crypto_tfm *tfm)
+{
+	struct cpu_civ_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	free_percpu(ctx->iv);
+	skcipher_geniv_exit(tfm);
+}
+
+static struct crypto_template cpu_civ_tmpl;
+
+static struct crypto_instance *cpu_civ_ablkcipher_alloc(struct rtattr **tb)
+{
+	struct crypto_instance *inst;
+
+	inst = skcipher_geniv_alloc(&cpu_civ_tmpl, tb, 0, 0);
+	if (IS_ERR(inst))
+		goto out;
+
+	inst->alg.cra_ablkcipher.givencrypt = cpu_civ_ablkcipher_givencrypt_first;
+
+	inst->alg.cra_init = cpu_civ_ablkcipher_init;
+	inst->alg.cra_exit = cpu_civ_ablkcipher_exit;
+
+out:
+	return inst;
+}
+
+static struct crypto_instance *cpu_civ_aead_alloc(struct rtattr **tb)
+{
+	struct crypto_instance *inst;
+
+	inst = aead_geniv_alloc(&cpu_civ_tmpl, tb, 0, 0);
+
+	if (IS_ERR(inst))
+		goto out;
+
+	inst->alg.cra_aead.givencrypt = cpu_civ_aead_givencrypt_first;
+
+	inst->alg.cra_init = cpu_civ_aead_init;
+	inst->alg.cra_exit = cpu_civ_aead_exit;
+
+out:
+	return inst;
+}
+
+static struct crypto_instance *cpu_civ_alloc(struct rtattr **tb)
+{
+	struct crypto_attr_type *algt;
+	struct crypto_instance *inst;
+	int err;
+
+	algt = crypto_get_attr_type(tb);
+	err = PTR_ERR(algt);
+	if (IS_ERR(algt))
+		return ERR_PTR(err);
+
+	err = crypto_get_default_rng();
+	if (err)
+		return ERR_PTR(err);
+
+	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & CRYPTO_ALG_TYPE_MASK)
+		inst = cpu_civ_ablkcipher_alloc(tb);
+	else
+		inst = cpu_civ_aead_alloc(tb);
+
+	if (IS_ERR(inst)) {
+		crypto_put_default_rng();
+		goto out;
+	}
+
+	inst->alg.cra_ctxsize = sizeof(struct cpu_civ_ctx);
+
+out:
+	return inst;
+}
+
+static void cpu_civ_free(struct crypto_instance *inst)
+{
+	if ((inst->alg.cra_flags ^ CRYPTO_ALG_TYPE_AEAD) & CRYPTO_ALG_TYPE_MASK)
+		skcipher_geniv_free(inst);
+	else
+		aead_geniv_free(inst);
+
+	crypto_put_default_rng();
+}
+
+static struct crypto_template cpu_civ_tmpl = {
+	.name = "cpu_chainiv",
+	.alloc = cpu_civ_alloc,
+	.free = cpu_civ_free,
+	.module = THIS_MODULE,
+};
+
+static int __init cpu_civ_module_init(void)
+{
+	return crypto_register_template(&cpu_civ_tmpl);
+}
+
+static void cpu_civ_module_exit(void)
+{
+	crypto_unregister_template(&cpu_civ_tmpl);
+}
+
+module_init(cpu_civ_module_init);
+module_exit(cpu_civ_module_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Per CPU Chain IV Generator");
-- 
1.5.4.2

