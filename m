From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [RFC] [PATCH 2/5] pcrypt: Add pcrypt crypto parallelization wrapper
Date: Mon, 8 Jun 2009 09:10:00 +0200
Message-ID: <20090608071000.GT20366@secunet.com>
References: <20090608070749.GR20366@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([213.68.205.161]:58207 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784AbZFHHHe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Jun 2009 03:07:34 -0400
Content-Disposition: inline
In-Reply-To: <20090608070749.GR20366@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds a parallel crypto template that takes a crypto
algorithm and converts it to process the crypto transforms in
parallel. For the moment only aead is supported.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 crypto/Kconfig            |   13 ++
 crypto/Makefile           |    2 +
 crypto/pcrypt.c           |  413 +++++++++++++++++++++++++++++++++++++++++++++
 crypto/pcrypt_core.c      |  125 ++++++++++++++
 include/crypto/pcrypt.h   |   85 +++++++++
 include/linux/interrupt.h |    2 +
 6 files changed, 640 insertions(+), 0 deletions(-)
 create mode 100644 crypto/pcrypt.c
 create mode 100644 crypto/pcrypt_core.c
 create mode 100644 include/crypto/pcrypt.h

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 74d0e62..b05fc95 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -112,6 +112,19 @@ config CRYPTO_NULL
 	help
 	  These are 'Null' algorithms, used by IPsec, which do nothing.
 
+config CRYPTO_PCRYPT_CORE
+	bool
+	select CRYPTO_AEAD
+
+config CRYPTO_PCRYPT
+	tristate "Parallel crypto engine (EXPERIMENTAL)"
+	depends on USE_GENERIC_SMP_HELPERS && EXPERIMENTAL
+	select CRYPTO_MANAGER
+	select CRYPTO_PCRYPT_CORE
+	help
+	  This converts an arbitrary crypto algorithm into a parallel
+	  algorithm that is executed in a softirq.
+
 config CRYPTO_WORKQUEUE
        tristate
 
diff --git a/crypto/Makefile b/crypto/Makefile
index 673d9f7..84b9d17 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -56,6 +56,8 @@ obj-$(CONFIG_CRYPTO_XTS) += xts.o
 obj-$(CONFIG_CRYPTO_CTR) += ctr.o
 obj-$(CONFIG_CRYPTO_GCM) += gcm.o
 obj-$(CONFIG_CRYPTO_CCM) += ccm.o
+obj-$(CONFIG_CRYPTO_PCRYPT_CORE) += pcrypt_core.o
+obj-$(CONFIG_CRYPTO_PCRYPT) += pcrypt.o
 obj-$(CONFIG_CRYPTO_CRYPTD) += cryptd.o
 obj-$(CONFIG_CRYPTO_DES) += des_generic.o
 obj-$(CONFIG_CRYPTO_FCRYPT) += fcrypt.o
diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
new file mode 100644
index 0000000..cc960df
--- /dev/null
+++ b/crypto/pcrypt.c
@@ -0,0 +1,413 @@
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
+struct pcrypt_instance_ctx {
+	struct crypto_spawn spawn;
+	unsigned int tfm_count;
+};
+
+struct pcrypt_aead_ctx {
+	struct crypto_aead *child;
+	unsigned int tfm_nr;
+};
+
+static int pcrypt_do_parallel(struct padata_priv *padata, unsigned int tfm_nr,
+			      unsigned int softirq, unsigned int padata_nr)
+{
+	unsigned int cpu, cpu_index, num_cpus, cb_cpu;
+	cpumask_t cpu_map;
+
+	cpu_map = padata_get_cpumap(padata_nr);
+	num_cpus = cpus_weight(cpu_map);
+
+	cpu_index = tfm_nr % num_cpus;
+
+	cb_cpu = first_cpu(cpu_map);
+	for (cpu = 0; cpu < cpu_index; cpu++)
+		cb_cpu = next_cpu(cb_cpu, cpu_map);
+
+	return padata_do_parallel(softirq, padata_nr, padata, cb_cpu);
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
+	local_bh_disable();
+	if (padata_do_serial(padata->nr, padata))
+		goto out;
+
+	aead_request_complete(req, padata->info);
+
+out:
+	local_bh_enable();
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
+	if (padata_do_serial(AEAD_ENC_PADATA, padata))
+		return;
+
+	aead_request_complete(req->base.data, padata->info);
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
+	if (pcrypt_do_parallel(padata, ctx->tfm_nr, AEAD_ENC_SOFTIRQ,
+			       AEAD_ENC_PADATA))
+		err = -EINPROGRESS;
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
+	if (padata_do_serial(AEAD_DEC_PADATA, padata))
+		return;
+
+	aead_request_complete(req->base.data, padata->info);
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
+	if (pcrypt_do_parallel(padata, ctx->tfm_nr, AEAD_DEC_SOFTIRQ,
+			       AEAD_DEC_PADATA))
+		err = -EINPROGRESS;
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
+	if (padata_do_serial(AEAD_ENC_PADATA, padata))
+		return;
+
+	aead_request_complete(req->areq.base.data, padata->info);
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
+
+	if (pcrypt_do_parallel(padata, ctx->tfm_nr, AEAD_ENC_SOFTIRQ,
+			       AEAD_ENC_PADATA))
+		err = -EINPROGRESS;
+	else
+		err = crypto_aead_givencrypt(creq);
+
+	return err;
+}
+
+static int pcrypt_aead_init_tfm(struct crypto_tfm *tfm)
+{
+	struct crypto_instance *inst = crypto_tfm_alg_instance(tfm);
+	struct pcrypt_instance_ctx *ictx = crypto_instance_ctx(inst);
+	struct pcrypt_aead_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct crypto_aead *cipher;
+	
+	ictx->tfm_count++;
+	ctx->tfm_nr = ictx->tfm_count;
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
+	inst->alg.cra_type = &crypto_nivaead_type;
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
+	inst->alg.cra_aead.geniv = "eseqiv";
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
+	padata_start(AEAD_ENC_PADATA);
+	padata_start(AEAD_DEC_PADATA);
+
+	return crypto_register_template(&pcrypt_tmpl);
+}
+
+static void __exit pcrypt_exit(void)
+{
+	padata_stop(AEAD_ENC_PADATA);
+	padata_stop(AEAD_DEC_PADATA);
+
+	crypto_unregister_template(&pcrypt_tmpl);
+}
+
+module_init(pcrypt_init);
+module_exit(pcrypt_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Parallel crypto engine");
diff --git a/crypto/pcrypt_core.c b/crypto/pcrypt_core.c
new file mode 100644
index 0000000..7c807e0
--- /dev/null
+++ b/crypto/pcrypt_core.c
@@ -0,0 +1,125 @@
+/*
+ * pcrypt_core.c - Core functions for the pcrypt crypto parallelization
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
+#include <linux/interrupt.h>
+#include <linux/cpu.h>
+#include <linux/err.h>
+#include <linux/module.h>
+#include <crypto/pcrypt.h>
+
+struct crypto_aead *pcrypt_alloc_aead_tfm(const char *alg_name,
+					  u32 type, u32 mask)
+{
+	char pcrypt_alg_name[CRYPTO_MAX_ALG_NAME];
+	struct crypto_aead *tfm;
+
+	if (snprintf(pcrypt_alg_name, CRYPTO_MAX_ALG_NAME,
+		     "pcrypt(%s)", alg_name) >= CRYPTO_MAX_ALG_NAME)
+		return ERR_PTR(-EINVAL);
+
+	tfm = crypto_alloc_aead(pcrypt_alg_name, type, mask);
+
+	if (IS_ERR(tfm))
+		return ERR_CAST(tfm);
+
+	return tfm;
+}
+EXPORT_SYMBOL_GPL(pcrypt_alloc_aead_tfm);
+
+static void aead_enc_action(struct softirq_action *h)
+{
+	struct list_head *cpu_list, local_list;
+
+	cpu_list = &__get_cpu_var(softirq_work_list[AEAD_ENC_SOFTIRQ]);
+
+	local_irq_disable();
+	list_replace_init(cpu_list, &local_list);
+	local_irq_enable();
+
+	while (!list_empty(&local_list)) {
+		struct padata_priv *padata;
+
+		padata = list_entry(local_list.next, struct padata_priv,
+				    csd.list);
+
+		list_del_init(&padata->csd.list);
+
+		padata->parallel(padata);
+	}
+}
+
+static void aead_dec_action(struct softirq_action *h)
+{
+	struct list_head *cpu_list, local_list;
+
+	cpu_list = &__get_cpu_var(softirq_work_list[AEAD_DEC_SOFTIRQ]);
+
+	local_irq_disable();
+	list_replace_init(cpu_list, &local_list);
+	local_irq_enable();
+
+	while (!list_empty(&local_list)) {
+		struct padata_priv *padata;
+
+		padata = list_entry(local_list.next, struct padata_priv,
+				    csd.list);
+
+		list_del_init(&padata->csd.list);
+
+		padata->parallel(padata);
+	}
+}
+
+static int __devinit pcrypt_cpu_callback(struct notifier_block *nfb,
+					 unsigned long action, void *hcpu)
+{
+	int cpu = (unsigned long)hcpu;
+
+	switch (action) {
+	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
+		padata_add_cpu(AEAD_ENC_PADATA, cpu);
+		padata_add_cpu(AEAD_DEC_PADATA, cpu);
+		break;
+
+	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
+		padata_remove_cpu(AEAD_ENC_PADATA, cpu);
+		padata_remove_cpu(AEAD_DEC_PADATA, cpu);
+
+		break;
+	}
+
+	return NOTIFY_OK;
+}
+
+static int __init pcrypt_init_padata(void)
+{
+	open_softirq(AEAD_ENC_SOFTIRQ, aead_enc_action);
+	open_softirq(AEAD_DEC_SOFTIRQ, aead_dec_action);
+
+	padata_init(AEAD_ENC_PADATA, cpu_online_map);
+	padata_init(AEAD_DEC_PADATA, cpu_online_map);
+
+	hotcpu_notifier(pcrypt_cpu_callback, 0);
+
+	return 0;
+}
+subsys_initcall(pcrypt_init_padata);
diff --git a/include/crypto/pcrypt.h b/include/crypto/pcrypt.h
new file mode 100644
index 0000000..9cea12b
--- /dev/null
+++ b/include/crypto/pcrypt.h
@@ -0,0 +1,85 @@
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
+struct crypto_aead *pcrypt_alloc_aead_tfm(const char *alg_name, u32 type,
+					  u32 mask);
+
+struct crypto_ablkcipher *pcrypt_alloc_ablkcipher_tfm(const char *alg_name,
+						      u32 type, u32 mask);
+
+#ifdef CONFIG_CRYPTO_PCRYPT_CORE
+static inline struct crypto_aead *crypto_alloc_aead_tfm(const char *alg_name,
+							u32 type, u32 mask)
+{
+	return pcrypt_alloc_aead_tfm(alg_name, type, mask);
+}
+
+static inline
+struct crypto_ablkcipher *crypto_alloc_ablkcipher_tfm(const char *alg_name,
+						      u32 type, u32 mask)
+{
+	return pcrypt_alloc_ablkcipher_tfm(alg_name, type, mask);
+}
+#else
+static inline struct crypto_aead *crypto_alloc_aead_tfm(const char *alg_name,
+							u32 type, u32 mask)
+{
+	return crypto_alloc_aead(alg_name, type, mask);
+}
+
+static inline
+struct crypto_ablkcipher *crypto_alloc_ablkcipher_tfm(const char *alg_name,
+						      u32 type, u32 mask)
+{
+	return crypto_alloc_ablkcipher(alg_name, type, mask);
+}
+#endif
+
+#endif
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index a17679c..93e0c9f 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -338,6 +338,8 @@ enum
 	TASKLET_SOFTIRQ,
 	SCHED_SOFTIRQ,
 	HRTIMER_SOFTIRQ,
+	AEAD_ENC_SOFTIRQ,
+	AEAD_DEC_SOFTIRQ,
 	PADATA_SOFTIRQ,
 	RCU_SOFTIRQ, 	/* Preferable RCU should always be the last softirq */
 
-- 
1.5.4.2

