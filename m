From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 2/2] crypto: pcrypt - Add pcrypt crypto parallelization
	wrapper
Date: Fri, 18 Dec 2009 13:21:42 +0100
Message-ID: <20091218122142.GZ15653@secunet.com>
References: <20091218122014.GX15653@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	David Miller <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([213.68.205.161]:33353 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750869AbZLRMq6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 Dec 2009 07:46:58 -0500
Content-Disposition: inline
In-Reply-To: <20091218122014.GX15653@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds a parallel crypto template that takes a crypto
algorithm and converts it to process the crypto transforms in
parallel. For the moment only aead algorithms are supported.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 crypto/Kconfig          |   10 +
 crypto/Makefile         |    1 +
 crypto/pcrypt.c         |  445 +++++++++++++++++++++++++++++++++++++++++++++++
 include/crypto/pcrypt.h |   51 ++++++
 4 files changed, 507 insertions(+), 0 deletions(-)
 create mode 100644 crypto/pcrypt.c
 create mode 100644 include/crypto/pcrypt.h

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 81c185a..6a2e295 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -114,6 +114,16 @@ config CRYPTO_NULL
 	help
 	  These are 'Null' algorithms, used by IPsec, which do nothing.
 
+config CRYPTO_PCRYPT
+	tristate "Parallel crypto engine (EXPERIMENTAL)"
+	depends on SMP && EXPERIMENTAL
+	select PADATA
+	select CRYPTO_MANAGER
+	select CRYPTO_AEAD
+	help
+	  This converts an arbitrary crypto algorithm into a parallel
+	  algorithm that executes in kernel threads.
+
 config CRYPTO_WORKQUEUE
        tristate
 
diff --git a/crypto/Makefile b/crypto/Makefile
index 9e8f619..d7e6441 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -56,6 +56,7 @@ obj-$(CONFIG_CRYPTO_XTS) += xts.o
 obj-$(CONFIG_CRYPTO_CTR) += ctr.o
 obj-$(CONFIG_CRYPTO_GCM) += gcm.o
 obj-$(CONFIG_CRYPTO_CCM) += ccm.o
+obj-$(CONFIG_CRYPTO_PCRYPT) += pcrypt.o
 obj-$(CONFIG_CRYPTO_CRYPTD) += cryptd.o
 obj-$(CONFIG_CRYPTO_DES) += des_generic.o
 obj-$(CONFIG_CRYPTO_FCRYPT) += fcrypt.o
diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
new file mode 100644
index 0000000..b9527d0
--- /dev/null
+++ b/crypto/pcrypt.c
@@ -0,0 +1,445 @@
+/*
+ * pcrypt - Parallel crypto wrapper.
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
+#include <crypto/algapi.h>
+#include <crypto/internal/aead.h>
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <crypto/pcrypt.h>
+
+static struct padata_instance *pcrypt_enc_padata;
+static struct padata_instance *pcrypt_dec_padata;
+static struct workqueue_struct *encwq;
+static struct workqueue_struct *decwq;
+
+struct pcrypt_instance_ctx {
+	struct crypto_spawn spawn;
+	unsigned int tfm_count;
+};
+
+struct pcrypt_aead_ctx {
+	struct crypto_aead *child;
+	unsigned int cb_cpu;
+};
+
+static int pcrypt_do_parallel(struct padata_priv *padata, unsigned int *cb_cpu,
+			      struct padata_instance *pinst)
+{
+	unsigned int cpu_index, cpu, i;
+
+	cpu = *cb_cpu;
+
+	if (cpumask_test_cpu(cpu, cpu_active_mask))
+			goto out;
+
+	cpu_index = cpu % cpumask_weight(cpu_active_mask);
+
+	cpu = cpumask_first(cpu_active_mask);
+	for (i = 0; i < cpu_index; i++)
+		cpu = cpumask_next(cpu, cpu_active_mask);
+
+	*cb_cpu = cpu;
+
+out:
+	return padata_do_parallel(pinst, padata, cpu);
+}
+
+static int pcrypt_aead_setkey(struct crypto_aead *parent,
+			      const u8 *key, unsigned int keylen)
+{
+	struct pcrypt_aead_ctx *ctx = crypto_aead_ctx(parent);
+
+	return crypto_aead_setkey(ctx->child, key, keylen);
+}
+
+static int pcrypt_aead_setauthsize(struct crypto_aead *parent,
+				   unsigned int authsize)
+{
+	struct pcrypt_aead_ctx *ctx = crypto_aead_ctx(parent);
+
+	return crypto_aead_setauthsize(ctx->child, authsize);
+}
+
+static void pcrypt_aead_serial(struct padata_priv *padata)
+{
+	struct pcrypt_request *preq = pcrypt_padata_request(padata);
+	struct aead_request *req = pcrypt_request_ctx(preq);
+
+	aead_request_complete(req->base.data, padata->info);
+}
+
+static void pcrypt_aead_giv_serial(struct padata_priv *padata)
+{
+	struct pcrypt_request *preq = pcrypt_padata_request(padata);
+	struct aead_givcrypt_request *req = pcrypt_request_ctx(preq);
+
+	aead_request_complete(req->areq.base.data, padata->info);
+}
+
+static void pcrypt_aead_done(struct crypto_async_request *areq, int err)
+{
+	struct aead_request *req = areq->data;
+	struct pcrypt_request *preq = aead_request_ctx(req);
+	struct padata_priv *padata = pcrypt_request_padata(preq);
+
+	padata->info = err;
+	req->base.flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
+
+	padata_do_serial(padata);
+}
+
+static void pcrypt_aead_enc(struct padata_priv *padata)
+{
+	struct pcrypt_request *preq = pcrypt_padata_request(padata);
+	struct aead_request *req = pcrypt_request_ctx(preq);
+
+	padata->info = crypto_aead_encrypt(req);
+
+	if (padata->info)
+		return;
+
+	padata_do_serial(padata);
+}
+
+static int pcrypt_aead_encrypt(struct aead_request *req)
+{
+	int err;
+	struct pcrypt_request *preq = aead_request_ctx(req);
+	struct aead_request *creq = pcrypt_request_ctx(preq);
+	struct padata_priv *padata = pcrypt_request_padata(preq);
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct pcrypt_aead_ctx *ctx = crypto_aead_ctx(aead);
+	u32 flags = aead_request_flags(req);
+
+	memset(padata, 0, sizeof(struct padata_priv));
+
+	padata->parallel = pcrypt_aead_enc;
+	padata->serial = pcrypt_aead_serial;
+
+	aead_request_set_tfm(creq, ctx->child);
+	aead_request_set_callback(creq, flags & ~CRYPTO_TFM_REQ_MAY_SLEEP,
+				  pcrypt_aead_done, req);
+	aead_request_set_crypt(creq, req->src, req->dst,
+			       req->cryptlen, req->iv);
+	aead_request_set_assoc(creq, req->assoc, req->assoclen);
+
+	err = pcrypt_do_parallel(padata, &ctx->cb_cpu, pcrypt_enc_padata);
+	if (err)
+		return err;
+	else
+		err = crypto_aead_encrypt(creq);
+
+	return err;
+}
+
+static void pcrypt_aead_dec(struct padata_priv *padata)
+{
+	struct pcrypt_request *preq = pcrypt_padata_request(padata);
+	struct aead_request *req = pcrypt_request_ctx(preq);
+
+	padata->info = crypto_aead_decrypt(req);
+
+	if (padata->info)
+		return;
+
+	padata_do_serial(padata);
+}
+
+static int pcrypt_aead_decrypt(struct aead_request *req)
+{
+	int err;
+	struct pcrypt_request *preq = aead_request_ctx(req);
+	struct aead_request *creq = pcrypt_request_ctx(preq);
+	struct padata_priv *padata = pcrypt_request_padata(preq);
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct pcrypt_aead_ctx *ctx = crypto_aead_ctx(aead);
+	u32 flags = aead_request_flags(req);
+
+	memset(padata, 0, sizeof(struct padata_priv));
+
+	padata->parallel = pcrypt_aead_dec;
+	padata->serial = pcrypt_aead_serial;
+
+	aead_request_set_tfm(creq, ctx->child);
+	aead_request_set_callback(creq, flags & ~CRYPTO_TFM_REQ_MAY_SLEEP,
+				  pcrypt_aead_done, req);
+	aead_request_set_crypt(creq, req->src, req->dst,
+			       req->cryptlen, req->iv);
+	aead_request_set_assoc(creq, req->assoc, req->assoclen);
+
+	err = pcrypt_do_parallel(padata, &ctx->cb_cpu, pcrypt_dec_padata);
+	if (err)
+		return err;
+	else
+		err = crypto_aead_decrypt(creq);
+
+	return err;
+}
+
+static void pcrypt_aead_givenc(struct padata_priv *padata)
+{
+	struct pcrypt_request *preq = pcrypt_padata_request(padata);
+	struct aead_givcrypt_request *req = pcrypt_request_ctx(preq);
+
+	padata->info = crypto_aead_givencrypt(req);
+
+	if (padata->info)
+		return;
+
+	padata_do_serial(padata);
+}
+
+static int pcrypt_aead_givencrypt(struct aead_givcrypt_request *req)
+{
+	int err;
+	struct aead_request *areq = &req->areq;
+	struct pcrypt_request *preq = aead_request_ctx(areq);
+	struct aead_givcrypt_request *creq = pcrypt_request_ctx(preq);
+	struct padata_priv *padata = pcrypt_request_padata(preq);
+	struct crypto_aead *aead = aead_givcrypt_reqtfm(req);
+	struct pcrypt_aead_ctx *ctx = crypto_aead_ctx(aead);
+	u32 flags = aead_request_flags(areq);
+
+	memset(padata, 0, sizeof(struct padata_priv));
+
+	padata->parallel = pcrypt_aead_givenc;
+	padata->serial = pcrypt_aead_giv_serial;
+
+	aead_givcrypt_set_tfm(creq, ctx->child);
+	aead_givcrypt_set_callback(creq, flags & ~CRYPTO_TFM_REQ_MAY_SLEEP,
+				   pcrypt_aead_done, areq);
+	aead_givcrypt_set_crypt(creq, areq->src, areq->dst,
+				areq->cryptlen, areq->iv);
+	aead_givcrypt_set_assoc(creq, areq->assoc, areq->assoclen);
+	aead_givcrypt_set_giv(creq, req->giv, req->seq);
+
+	err = pcrypt_do_parallel(padata, &ctx->cb_cpu, pcrypt_enc_padata);
+	if (err)
+		return err;
+	else
+		err = crypto_aead_givencrypt(creq);
+
+	return err;
+}
+
+static int pcrypt_aead_init_tfm(struct crypto_tfm *tfm)
+{
+	int cpu, cpu_index;
+	struct crypto_instance *inst = crypto_tfm_alg_instance(tfm);
+	struct pcrypt_instance_ctx *ictx = crypto_instance_ctx(inst);
+	struct pcrypt_aead_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct crypto_aead *cipher;
+
+	ictx->tfm_count++;
+
+	cpu_index = ictx->tfm_count % cpumask_weight(cpu_active_mask);
+
+	ctx->cb_cpu = cpumask_first(cpu_active_mask);
+	for (cpu = 0; cpu < cpu_index; cpu++)
+		ctx->cb_cpu = cpumask_next(ctx->cb_cpu, cpu_active_mask);
+
+	cipher = crypto_spawn_aead(crypto_instance_ctx(inst));
+
+	if (IS_ERR(cipher))
+		return PTR_ERR(cipher);
+
+	ctx->child = cipher;
+	tfm->crt_aead.reqsize = sizeof(struct pcrypt_request)
+		+ sizeof(struct aead_givcrypt_request)
+		+ crypto_aead_reqsize(cipher);
+
+	return 0;
+}
+
+static void pcrypt_aead_exit_tfm(struct crypto_tfm *tfm)
+{
+	struct pcrypt_aead_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	crypto_free_aead(ctx->child);
+}
+
+static struct crypto_instance *pcrypt_alloc_instance(struct crypto_alg *alg)
+{
+	struct crypto_instance *inst;
+	struct pcrypt_instance_ctx *ctx;
+	int err;
+
+	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
+	if (!inst) {
+		inst = ERR_PTR(-ENOMEM);
+		goto out;
+	}
+
+	err = -ENAMETOOLONG;
+	if (snprintf(inst->alg.cra_driver_name, CRYPTO_MAX_ALG_NAME,
+		     "pcrypt(%s)", alg->cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
+		goto out_free_inst;
+
+	memcpy(inst->alg.cra_name, alg->cra_name, CRYPTO_MAX_ALG_NAME);
+
+	ctx = crypto_instance_ctx(inst);
+	err = crypto_init_spawn(&ctx->spawn, alg, inst,
+				CRYPTO_ALG_TYPE_MASK);
+	if (err)
+		goto out_free_inst;
+
+	inst->alg.cra_priority = alg->cra_priority + 100;
+	inst->alg.cra_blocksize = alg->cra_blocksize;
+	inst->alg.cra_alignmask = alg->cra_alignmask;
+
+out:
+	return inst;
+
+out_free_inst:
+	kfree(inst);
+	inst = ERR_PTR(err);
+	goto out;
+}
+
+static struct crypto_instance *pcrypt_alloc_aead(struct rtattr **tb)
+{
+	struct crypto_instance *inst;
+	struct crypto_alg *alg;
+	struct crypto_attr_type *algt;
+
+	algt = crypto_get_attr_type(tb);
+
+	alg = crypto_get_attr_alg(tb, algt->type,
+				  (algt->mask & CRYPTO_ALG_TYPE_MASK));
+	if (IS_ERR(alg))
+		return ERR_CAST(alg);
+
+	inst = pcrypt_alloc_instance(alg);
+	if (IS_ERR(inst))
+		goto out_put_alg;
+
+	inst->alg.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC;
+	inst->alg.cra_type = &crypto_aead_type;
+
+	inst->alg.cra_aead.ivsize = alg->cra_aead.ivsize;
+	inst->alg.cra_aead.geniv = alg->cra_aead.geniv;
+	inst->alg.cra_aead.maxauthsize = alg->cra_aead.maxauthsize;
+
+	inst->alg.cra_ctxsize = sizeof(struct pcrypt_aead_ctx);
+
+	inst->alg.cra_init = pcrypt_aead_init_tfm;
+	inst->alg.cra_exit = pcrypt_aead_exit_tfm;
+
+	inst->alg.cra_aead.setkey = pcrypt_aead_setkey;
+	inst->alg.cra_aead.setauthsize = pcrypt_aead_setauthsize;
+	inst->alg.cra_aead.encrypt = pcrypt_aead_encrypt;
+	inst->alg.cra_aead.decrypt = pcrypt_aead_decrypt;
+	inst->alg.cra_aead.givencrypt = pcrypt_aead_givencrypt;
+
+out_put_alg:
+	crypto_mod_put(alg);
+	return inst;
+}
+
+static struct crypto_instance *pcrypt_alloc(struct rtattr **tb)
+{
+	struct crypto_attr_type *algt;
+
+	algt = crypto_get_attr_type(tb);
+	if (IS_ERR(algt))
+		return ERR_CAST(algt);
+
+	switch (algt->type & algt->mask & CRYPTO_ALG_TYPE_MASK) {
+	case CRYPTO_ALG_TYPE_AEAD:
+		return pcrypt_alloc_aead(tb);
+	}
+
+	return ERR_PTR(-EINVAL);
+}
+
+static void pcrypt_free(struct crypto_instance *inst)
+{
+	struct pcrypt_instance_ctx *ctx = crypto_instance_ctx(inst);
+
+	crypto_drop_spawn(&ctx->spawn);
+	kfree(inst);
+}
+
+static struct crypto_template pcrypt_tmpl = {
+	.name = "pcrypt",
+	.alloc = pcrypt_alloc,
+	.free = pcrypt_free,
+	.module = THIS_MODULE,
+};
+
+static int __init pcrypt_init(void)
+{
+	encwq = create_workqueue("pencrypt");
+	if (!encwq)
+		goto err;
+
+	decwq = create_workqueue("pdecrypt");
+	if (!decwq)
+		goto err_destroy_encwq;
+
+
+	pcrypt_enc_padata = padata_alloc(cpu_possible_mask, encwq);
+	if (!pcrypt_enc_padata)
+		goto err_destroy_decwq;
+
+	pcrypt_dec_padata = padata_alloc(cpu_possible_mask, decwq);
+	if (!pcrypt_dec_padata)
+		goto err_free_padata;
+
+	padata_start(pcrypt_enc_padata);
+	padata_start(pcrypt_dec_padata);
+
+	return crypto_register_template(&pcrypt_tmpl);
+
+err_free_padata:
+	padata_free(pcrypt_enc_padata);
+
+err_destroy_decwq:
+	destroy_workqueue(decwq);
+
+err_destroy_encwq:
+	destroy_workqueue(encwq);
+
+err:
+	return -ENOMEM;
+}
+
+static void __exit pcrypt_exit(void)
+{
+	padata_stop(pcrypt_enc_padata);
+	padata_stop(pcrypt_dec_padata);
+
+	destroy_workqueue(encwq);
+	destroy_workqueue(decwq);
+
+	padata_free(pcrypt_enc_padata);
+	padata_free(pcrypt_dec_padata);
+
+	crypto_unregister_template(&pcrypt_tmpl);
+}
+
+module_init(pcrypt_init);
+module_exit(pcrypt_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Steffen Klassert <steffen.klassert@secunet.com>");
+MODULE_DESCRIPTION("Parallel crypto wrapper");
diff --git a/include/crypto/pcrypt.h b/include/crypto/pcrypt.h
new file mode 100644
index 0000000..d7d8bd8
--- /dev/null
+++ b/include/crypto/pcrypt.h
@@ -0,0 +1,51 @@
+/*
+ * pcrypt - Parallel crypto engine.
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
+#ifndef _CRYPTO_PCRYPT_H
+#define _CRYPTO_PCRYPT_H
+
+#include <linux/crypto.h>
+#include <linux/kernel.h>
+#include <linux/padata.h>
+
+struct pcrypt_request {
+	struct padata_priv	padata;
+	void			*data;
+	void			*__ctx[] CRYPTO_MINALIGN_ATTR;
+};
+
+static inline void *pcrypt_request_ctx(struct pcrypt_request *req)
+{
+	return req->__ctx;
+}
+
+static inline
+struct padata_priv *pcrypt_request_padata(struct pcrypt_request *req)
+{
+	return &req->padata;
+}
+
+static inline
+struct pcrypt_request *pcrypt_padata_request(struct padata_priv *padata)
+{
+	return container_of(padata, struct pcrypt_request, padata);
+}
+
+#endif
-- 
1.5.4.2

