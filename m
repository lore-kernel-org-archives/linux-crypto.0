From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH 3/4] crypto: ccp - Add support for RSA on the CCP
Date: Wed, 21 Jun 2017 17:48:01 -0500
Message-ID: <20170621224801.15132.99552.stgit@taos.amd.com>
References: <20170621224655.15132.20473.stgit@taos.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: thomas.lendacky@amd.com, herbert@gondor.apana.org.au,
        davem@davemloft.net
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-cys01nam02on0060.outbound.protection.outlook.com ([104.47.37.60]:16256
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751755AbdFUWsN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Jun 2017 18:48:13 -0400
In-Reply-To: <20170621224655.15132.20473.stgit@taos.amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Wire up the v3 CCP as a cipher provider.

Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/Makefile          |    1 
 drivers/crypto/ccp/ccp-crypto-main.c |   21 ++
 drivers/crypto/ccp/ccp-crypto-rsa.c  |  286 ++++++++++++++++++++++++++++++++++
 drivers/crypto/ccp/ccp-crypto.h      |   31 ++++
 drivers/crypto/ccp/ccp-debugfs.c     |    1 
 drivers/crypto/ccp/ccp-dev.c         |    1 
 drivers/crypto/ccp/ccp-ops.c         |    2 
 include/linux/ccp.h                  |    1 
 8 files changed, 341 insertions(+), 3 deletions(-)
 create mode 100644 drivers/crypto/ccp/ccp-crypto-rsa.c

diff --git a/drivers/crypto/ccp/Makefile b/drivers/crypto/ccp/Makefile
index 59493fd3a751..439bc2fcb464 100644
--- a/drivers/crypto/ccp/Makefile
+++ b/drivers/crypto/ccp/Makefile
@@ -15,4 +15,5 @@ ccp-crypto-objs := ccp-crypto-main.o \
 		   ccp-crypto-aes-xts.o \
 		   ccp-crypto-aes-galois.o \
 		   ccp-crypto-des3.o \
+		   ccp-crypto-rsa.o \
 		   ccp-crypto-sha.o
diff --git a/drivers/crypto/ccp/ccp-crypto-main.c b/drivers/crypto/ccp/ccp-crypto-main.c
index 8dccbddabef1..dd7d00c680e7 100644
--- a/drivers/crypto/ccp/ccp-crypto-main.c
+++ b/drivers/crypto/ccp/ccp-crypto-main.c
@@ -17,6 +17,7 @@
 #include <linux/ccp.h>
 #include <linux/scatterlist.h>
 #include <crypto/internal/hash.h>
+#include <crypto/internal/akcipher.h>
 
 #include "ccp-crypto.h"
 
@@ -37,10 +38,15 @@
 module_param(des3_disable, uint, 0444);
 MODULE_PARM_DESC(des3_disable, "Disable use of 3DES - any non-zero value");
 
+static unsigned int rsa_disable;
+module_param(rsa_disable, uint, 0444);
+MODULE_PARM_DESC(rsa_disable, "Disable use of RSA - any non-zero value");
+
 /* List heads for the supported algorithms */
 static LIST_HEAD(hash_algs);
 static LIST_HEAD(cipher_algs);
 static LIST_HEAD(aead_algs);
+static LIST_HEAD(akcipher_algs);
 
 /* For any tfm, requests for that tfm must be returned on the order
  * received.  With multiple queues available, the CCP can process more
@@ -358,6 +364,14 @@ static int ccp_register_algs(void)
 			return ret;
 	}
 
+	if (!rsa_disable) {
+		ret = ccp_register_rsa_algs(&akcipher_algs);
+		if (ret) {
+			rsa_disable = 1;
+			return ret;
+		}
+	}
+
 	return 0;
 }
 
@@ -366,6 +380,7 @@ static void ccp_unregister_algs(void)
 	struct ccp_crypto_ahash_alg *ahash_alg, *ahash_tmp;
 	struct ccp_crypto_ablkcipher_alg *ablk_alg, *ablk_tmp;
 	struct ccp_crypto_aead *aead_alg, *aead_tmp;
+	struct ccp_crypto_akcipher_alg *akc_alg, *akc_tmp;
 
 	list_for_each_entry_safe(ahash_alg, ahash_tmp, &hash_algs, entry) {
 		crypto_unregister_ahash(&ahash_alg->alg);
@@ -384,6 +399,12 @@ static void ccp_unregister_algs(void)
 		list_del(&aead_alg->entry);
 		kfree(aead_alg);
 	}
+
+	list_for_each_entry_safe(akc_alg, akc_tmp, &akcipher_algs, entry) {
+		crypto_unregister_akcipher(&akc_alg->alg);
+		list_del(&akc_alg->entry);
+		kfree(akc_alg);
+	}
 }
 
 static int ccp_crypto_init(void)
diff --git a/drivers/crypto/ccp/ccp-crypto-rsa.c b/drivers/crypto/ccp/ccp-crypto-rsa.c
new file mode 100644
index 000000000000..4a2a71463594
--- /dev/null
+++ b/drivers/crypto/ccp/ccp-crypto-rsa.c
@@ -0,0 +1,286 @@
+/*
+ * AMD Cryptographic Coprocessor (CCP) RSA crypto API support
+ *
+ * Copyright (C) 2016 Advanced Micro Devices, Inc.
+ *
+ * Author: Gary R Hook <gary.hook@amd.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/scatterlist.h>
+#include <linux/crypto.h>
+#include <crypto/algapi.h>
+#include <crypto/internal/rsa.h>
+#include <crypto/internal/akcipher.h>
+#include <crypto/akcipher.h>
+#include <crypto/scatterwalk.h>
+
+#include "ccp-crypto.h"
+
+static inline struct akcipher_request *akcipher_request_cast(
+	struct crypto_async_request *req)
+{
+	return container_of(req, struct akcipher_request, base);
+}
+
+static int ccp_rsa_complete(struct crypto_async_request *async_req, int ret)
+{
+	struct akcipher_request *req = akcipher_request_cast(async_req);
+	struct ccp_rsa_req_ctx *rctx = akcipher_request_ctx(req);
+
+	if (!ret)
+		req->dst_len = rctx->cmd.u.rsa.key_size >> 3;
+
+	ret = 0;
+
+	return ret;
+}
+
+static unsigned int ccp_rsa_maxsize(struct crypto_akcipher *tfm)
+{
+	return CCP_RSA_MAXMOD;
+}
+
+static int ccp_rsa_crypt(struct akcipher_request *req, bool encrypt)
+{
+	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
+	struct ccp_ctx *ctx = akcipher_tfm_ctx(tfm);
+	struct ccp_rsa_req_ctx *rctx = akcipher_request_ctx(req);
+	int ret = 0;
+
+	memset(&rctx->cmd, 0, sizeof(rctx->cmd));
+	INIT_LIST_HEAD(&rctx->cmd.entry);
+	rctx->cmd.engine = CCP_ENGINE_RSA;
+
+	rctx->cmd.u.rsa.key_size = ctx->u.rsa.key_len; /* in bits */
+	if (encrypt) {
+		rctx->cmd.u.rsa.exp = &ctx->u.rsa.e_sg;
+		rctx->cmd.u.rsa.exp_len = ctx->u.rsa.e_len;
+	} else {
+		rctx->cmd.u.rsa.exp = &ctx->u.rsa.d_sg;
+		rctx->cmd.u.rsa.exp_len = ctx->u.rsa.d_len;
+	}
+	rctx->cmd.u.rsa.mod = &ctx->u.rsa.n_sg;
+	rctx->cmd.u.rsa.mod_len = ctx->u.rsa.n_len;
+	rctx->cmd.u.rsa.src = req->src;
+	rctx->cmd.u.rsa.src_len = req->src_len;
+	rctx->cmd.u.rsa.dst = req->dst;
+
+	ret = ccp_crypto_enqueue_request(&req->base, &rctx->cmd);
+
+	return ret;
+}
+
+static int ccp_rsa_encrypt(struct akcipher_request *req)
+{
+	return ccp_rsa_crypt(req, true);
+}
+
+static int ccp_rsa_decrypt(struct akcipher_request *req)
+{
+	return ccp_rsa_crypt(req, false);
+}
+
+static int ccp_check_key_length(unsigned int len)
+{
+	/* In bits */
+	if (len < 8 || len > 4096)
+		return -EINVAL;
+	return 0;
+}
+
+static void ccp_rsa_free_key_bufs(struct ccp_ctx *ctx)
+{
+	/* Clean up old key data */
+	kfree(ctx->u.rsa.e_buf);
+	ctx->u.rsa.e_buf = NULL;
+	ctx->u.rsa.e_len = 0;
+	kfree(ctx->u.rsa.n_buf);
+	ctx->u.rsa.n_buf = NULL;
+	ctx->u.rsa.n_len = 0;
+	kfree(ctx->u.rsa.d_buf);
+	ctx->u.rsa.d_buf = NULL;
+	ctx->u.rsa.d_len = 0;
+}
+
+static int ccp_rsa_setkey(struct crypto_akcipher *tfm, const void *key,
+			  unsigned int keylen, bool private)
+{
+	struct ccp_ctx *ctx = akcipher_tfm_ctx(tfm);
+	struct rsa_key raw_key;
+	int key_len, i;
+	int ret;
+
+	ccp_rsa_free_key_bufs(ctx);
+	memset(&raw_key, 0, sizeof(raw_key));
+
+	/* Code borrowed from crypto/rsa.c */
+	if (private)
+		ret = rsa_parse_priv_key(&raw_key, key, keylen);
+	else
+		ret = rsa_parse_pub_key(&raw_key, key, keylen);
+	if (ret)
+		goto e_key;
+
+	/* Remove leading zeroes from the modulus (n) */
+	key_len = 0;
+	for (i = 0; i < raw_key.n_sz; i++)
+		if (raw_key.n[i]) {
+			key_len = raw_key.n_sz - i;
+			break;
+		}
+	ctx->u.rsa.key_len = key_len << 3; /* bits */
+	if (ccp_check_key_length(ctx->u.rsa.key_len)) {
+		ret = -EINVAL;
+		goto e_key;
+	}
+	ctx->u.rsa.n_len = key_len;
+	sg_init_one(&ctx->u.rsa.n_sg, raw_key.n + i, key_len);
+
+	/* Remove leading zeroes from the public key (e) */
+	key_len = 0;
+	for (i = 0; i < raw_key.e_sz; i++)
+		if (raw_key.e[i]) {
+			key_len = raw_key.e_sz - i;
+			break;
+		}
+	ctx->u.rsa.e_len = key_len;
+	sg_init_one(&ctx->u.rsa.e_sg, raw_key.e + i, key_len);
+
+	if (private) {
+		/* Remove leading zeroes from the private key (d) */
+		key_len = 0;
+		for (i = 0; i < raw_key.d_sz; i++)
+			if (raw_key.d[i]) {
+				key_len = raw_key.d_sz - i;
+				break;
+			}
+		ctx->u.rsa.d_len = key_len;
+		sg_init_one(&ctx->u.rsa.d_sg, raw_key.d + i, key_len);
+	}
+
+	return 0;
+
+e_key:
+	return ret;
+}
+
+static int ccp_rsa_setprivkey(struct crypto_akcipher *tfm, const void *key,
+			      unsigned int keylen)
+{
+	return ccp_rsa_setkey(tfm, key, keylen, true);
+}
+
+static int ccp_rsa_setpubkey(struct crypto_akcipher *tfm, const void *key,
+			     unsigned int keylen)
+{
+	return ccp_rsa_setkey(tfm, key, keylen, false);
+}
+
+static int ccp_rsa_init_tfm(struct crypto_akcipher *tfm)
+{
+	struct ccp_ctx *ctx = akcipher_tfm_ctx(tfm);
+
+	akcipher_set_reqsize(tfm, sizeof(struct ccp_rsa_req_ctx));
+	ctx->complete = ccp_rsa_complete;
+
+	return 0;
+}
+
+static void ccp_rsa_exit_tfm(struct crypto_akcipher *tfm)
+{
+	struct ccp_ctx *ctx = crypto_tfm_ctx(&tfm->base);
+
+	ccp_rsa_free_key_bufs(ctx);
+}
+
+static struct akcipher_alg ccp_rsa_defaults = {
+	.encrypt = ccp_rsa_encrypt,
+	.decrypt = ccp_rsa_decrypt,
+	.sign = ccp_rsa_decrypt,
+	.verify = ccp_rsa_encrypt,
+	.set_pub_key = ccp_rsa_setpubkey,
+	.set_priv_key = ccp_rsa_setprivkey,
+	.max_size = ccp_rsa_maxsize,
+	.init = ccp_rsa_init_tfm,
+	.exit = ccp_rsa_exit_tfm,
+	.base = {
+		.cra_name = "rsa",
+		.cra_driver_name = "rsa-ccp",
+		.cra_priority = CCP_CRA_PRIORITY,
+		.cra_module = THIS_MODULE,
+		.cra_ctxsize = 2 * sizeof(struct ccp_ctx),
+	},
+};
+
+struct ccp_rsa_def {
+	unsigned int version;
+	const char *name;
+	const char *driver_name;
+	unsigned int reqsize;
+	struct akcipher_alg *alg_defaults;
+};
+
+static struct ccp_rsa_def rsa_algs[] = {
+	{
+		.version	= CCP_VERSION(3, 0),
+		.name		= "rsa",
+		.driver_name	= "rsa-ccp",
+		.reqsize	= sizeof(struct ccp_rsa_req_ctx),
+		.alg_defaults	= &ccp_rsa_defaults,
+	}
+};
+
+int ccp_register_rsa_alg(struct list_head *head, const struct ccp_rsa_def *def)
+{
+	struct ccp_crypto_akcipher_alg *ccp_alg;
+	struct akcipher_alg *alg;
+	int ret;
+
+	ccp_alg = kzalloc(sizeof(*ccp_alg), GFP_KERNEL);
+	if (!ccp_alg)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&ccp_alg->entry);
+
+	alg = &ccp_alg->alg;
+	*alg = *def->alg_defaults;
+	snprintf(alg->base.cra_name, CRYPTO_MAX_ALG_NAME, "%s", def->name);
+	snprintf(alg->base.cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s",
+		 def->driver_name);
+	ret = crypto_register_akcipher(alg);
+	if (ret) {
+		pr_err("%s akcipher algorithm registration error (%d)\n",
+		       alg->base.cra_name, ret);
+		kfree(ccp_alg);
+		return ret;
+	}
+
+	list_add(&ccp_alg->entry, head);
+
+	return 0;
+}
+
+int ccp_register_rsa_algs(struct list_head *head)
+{
+	int i, ret;
+	unsigned int ccpversion = ccp_version();
+
+	/* Register the RSA algorithm in standard mode
+	 * This works for CCP v3 and later
+	 */
+	for (i = 0; i < ARRAY_SIZE(rsa_algs); i++) {
+		if (rsa_algs[i].version > ccpversion)
+			continue;
+		ret = ccp_register_rsa_alg(head, &rsa_algs[i]);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
diff --git a/drivers/crypto/ccp/ccp-crypto.h b/drivers/crypto/ccp/ccp-crypto.h
index dd5bf15f06e5..5d592ecc9af5 100644
--- a/drivers/crypto/ccp/ccp-crypto.h
+++ b/drivers/crypto/ccp/ccp-crypto.h
@@ -24,6 +24,8 @@
 #include <crypto/ctr.h>
 #include <crypto/hash.h>
 #include <crypto/sha.h>
+#include <crypto/akcipher.h>
+#include <crypto/internal/rsa.h>
 
 #define	CCP_LOG_LEVEL	KERN_INFO
 
@@ -58,6 +60,12 @@ struct ccp_crypto_ahash_alg {
 	struct ahash_alg alg;
 };
 
+struct ccp_crypto_akcipher_alg {
+	struct list_head entry;
+
+	struct akcipher_alg alg;
+};
+
 static inline struct ccp_crypto_ablkcipher_alg *
 	ccp_crypto_ablkcipher_alg(struct crypto_tfm *tfm)
 {
@@ -227,12 +235,34 @@ struct ccp_sha_exp_ctx {
 	u8 buf[MAX_SHA_BLOCK_SIZE];
 };
 
+/***** RSA related defines *****/
+
+struct ccp_rsa_ctx {
+	unsigned int key_len; /* in bits */
+	struct scatterlist e_sg;
+	u8 *e_buf;
+	unsigned int e_len;
+	struct scatterlist n_sg;
+	u8 *n_buf;
+	unsigned int n_len;
+	struct scatterlist d_sg;
+	u8 *d_buf;
+	unsigned int d_len;
+};
+
+struct ccp_rsa_req_ctx {
+	struct ccp_cmd cmd;
+};
+
+#define	CCP_RSA_MAXMOD	(4 * 1024 / 8)
+
 /***** Common Context Structure *****/
 struct ccp_ctx {
 	int (*complete)(struct crypto_async_request *req, int ret);
 
 	union {
 		struct ccp_aes_ctx aes;
+		struct ccp_rsa_ctx rsa;
 		struct ccp_sha_ctx sha;
 		struct ccp_des3_ctx des3;
 	} u;
@@ -249,5 +279,6 @@ struct scatterlist *ccp_crypto_sg_table_add(struct sg_table *table,
 int ccp_register_aes_aeads(struct list_head *head);
 int ccp_register_sha_algs(struct list_head *head);
 int ccp_register_des3_algs(struct list_head *head);
+int ccp_register_rsa_algs(struct list_head *head);
 
 #endif
diff --git a/drivers/crypto/ccp/ccp-debugfs.c b/drivers/crypto/ccp/ccp-debugfs.c
index 99aba1622613..88191c45ca7d 100644
--- a/drivers/crypto/ccp/ccp-debugfs.c
+++ b/drivers/crypto/ccp/ccp-debugfs.c
@@ -291,7 +291,6 @@ void ccp5_debugfs_setup(struct ccp_device *ccp)
 	struct dentry *debugfs_q_instance;
 	struct dentry *debugfs_q_stats;
 	unsigned long flags;
-	int rc = 0;
 	int i;
 
 	if (!debugfs_initialized())
diff --git a/drivers/crypto/ccp/ccp-dev.c b/drivers/crypto/ccp/ccp-dev.c
index 2506b5025700..67cbb3e76888 100644
--- a/drivers/crypto/ccp/ccp-dev.c
+++ b/drivers/crypto/ccp/ccp-dev.c
@@ -415,6 +415,7 @@ static void ccp_do_cmd_complete(unsigned long data)
 	struct ccp_cmd *cmd = tdata->cmd;
 
 	cmd->callback(cmd->data, cmd->ret);
+
 	complete(&tdata->completion);
 }
 
diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
index 11155e52c52c..2cdd15a92178 100644
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -1786,7 +1786,7 @@ static int ccp_run_rsa_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 	if (ret)
 		goto e_exp;
 
-	if (cmd_q->ccp->vdata->version < CCP_VERSION(4, 0)) {
+	if (cmd_q->ccp->vdata->version < CCP_VERSION(5, 0)) {
 		/* The RSA exponent may span multiple (32-byte) KSB entries and
 		 * must be in little endian format. Reverse copy each 32-byte
 		 * chunk of the exponent (En chunk to E0 chunk, E(n-1) chunk to
diff --git a/include/linux/ccp.h b/include/linux/ccp.h
index 3285c944194a..c03ee844a99d 100644
--- a/include/linux/ccp.h
+++ b/include/linux/ccp.h
@@ -20,7 +20,6 @@
 #include <crypto/aes.h>
 #include <crypto/sha.h>
 
-
 struct ccp_device;
 struct ccp_cmd;
 
