From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH V2 6/9] crypto: ccp - Add support for RSA on the CCP
Date: Fri, 4 Nov 2016 11:04:32 -0500
Message-ID: <20161104160432.18155.29136.stgit@taos>
References: <20161104160140.18155.75618.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <thomas.lendacky@amd.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-dm3nam03on0064.outbound.protection.outlook.com ([104.47.41.64]:34136
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S935059AbcKDQEl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Nov 2016 12:04:41 -0400
In-Reply-To: <20161104160140.18155.75618.stgit@taos>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Wire up the CCP as an RSA cipher provider.

Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/Makefile          |    1 
 drivers/crypto/ccp/ccp-crypto-main.c |   19 ++
 drivers/crypto/ccp/ccp-crypto-rsa.c  |  294 ++++++++++++++++++++++++++++++++++
 drivers/crypto/ccp/ccp-crypto.h      |   32 ++++
 include/linux/ccp.h                  |    1 
 5 files changed, 346 insertions(+), 1 deletion(-)
 create mode 100644 drivers/crypto/ccp/ccp-crypto-rsa.c

diff --git a/drivers/crypto/ccp/Makefile b/drivers/crypto/ccp/Makefile
index 346ceb8..23f89b7 100644
--- a/drivers/crypto/ccp/Makefile
+++ b/drivers/crypto/ccp/Makefile
@@ -12,4 +12,5 @@ ccp-crypto-objs := ccp-crypto-main.o \
 		   ccp-crypto-aes.o \
 		   ccp-crypto-aes-cmac.o \
 		   ccp-crypto-aes-xts.o \
+		   ccp-crypto-rsa.o \
 		   ccp-crypto-sha.o
diff --git a/drivers/crypto/ccp/ccp-crypto-main.c b/drivers/crypto/ccp/ccp-crypto-main.c
index e0380e5..38d4466 100644
--- a/drivers/crypto/ccp/ccp-crypto-main.c
+++ b/drivers/crypto/ccp/ccp-crypto-main.c
@@ -17,6 +17,7 @@
 #include <linux/ccp.h>
 #include <linux/scatterlist.h>
 #include <crypto/internal/hash.h>
+#include <crypto/internal/akcipher.h>
 
 #include "ccp-crypto.h"
 
@@ -33,9 +34,14 @@
 module_param(sha_disable, uint, 0444);
 MODULE_PARM_DESC(sha_disable, "Disable use of SHA - any non-zero value");
 
+static unsigned int rsa_disable;
+module_param(rsa_disable, uint, 0444);
+MODULE_PARM_DESC(rsa_disable, "Disable use of RSA - any non-zero value");
+
 /* List heads for the supported algorithms */
 static LIST_HEAD(hash_algs);
 static LIST_HEAD(cipher_algs);
+static LIST_HEAD(akcipher_algs);
 
 /* For any tfm, requests for that tfm must be returned on the order
  * received.  With multiple queues available, the CCP can process more
@@ -343,6 +349,12 @@ static int ccp_register_algs(void)
 			return ret;
 	}
 
+	if (!rsa_disable) {
+		ret = ccp_register_rsa_algs(&akcipher_algs);
+		if (ret)
+			return ret;
+	}
+
 	return 0;
 }
 
@@ -350,6 +362,7 @@ static void ccp_unregister_algs(void)
 {
 	struct ccp_crypto_ahash_alg *ahash_alg, *ahash_tmp;
 	struct ccp_crypto_ablkcipher_alg *ablk_alg, *ablk_tmp;
+	struct ccp_crypto_akcipher_alg *ak_alg, *ak_tmp;
 
 	list_for_each_entry_safe(ahash_alg, ahash_tmp, &hash_algs, entry) {
 		crypto_unregister_ahash(&ahash_alg->alg);
@@ -362,6 +375,12 @@ static void ccp_unregister_algs(void)
 		list_del(&ablk_alg->entry);
 		kfree(ablk_alg);
 	}
+
+	list_for_each_entry_safe(ak_alg, ak_tmp, &akcipher_algs, entry) {
+		crypto_unregister_akcipher(&ak_alg->alg);
+		list_del(&ak_alg->entry);
+		kfree(ak_alg);
+	}
 }
 
 static int ccp_crypto_init(void)
diff --git a/drivers/crypto/ccp/ccp-crypto-rsa.c b/drivers/crypto/ccp/ccp-crypto-rsa.c
new file mode 100644
index 0000000..6cb6c6f
--- /dev/null
+++ b/drivers/crypto/ccp/ccp-crypto-rsa.c
@@ -0,0 +1,294 @@
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
+#include <linux/mpi.h>
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
+
+	if (!ret)
+		req->dst_len = rctx->cmd.u.rsa.mod_len;
+
+	ret = 0;
+
+	return ret;
+}
+
+static int ccp_rsa_maxsize(struct crypto_akcipher *tfm)
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
+	if (!ctx->u.rsa.pkey.d && !ctx->u.rsa.pkey.e)
+		return -EINVAL;
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
+
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
+	unsigned int n_size;
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
+		goto e_ret;
+
+	ret = -EINVAL;
+
+	ctx->u.rsa.pkey.e = mpi_read_raw_data(raw_key.e, raw_key.e_sz);
+	if (!ctx->u.rsa.pkey.e)
+		goto e_ret;
+	ctx->u.rsa.e_buf = mpi_get_buffer(ctx->u.rsa.pkey.e,
+					  &ctx->u.rsa.e_len, NULL);
+	if (!ctx->u.rsa.e_buf)
+		goto e_key;
+	sg_init_one(&ctx->u.rsa.e_sg, ctx->u.rsa.e_buf, ctx->u.rsa.e_len);
+
+	ctx->u.rsa.pkey.n = mpi_read_raw_data(raw_key.n, raw_key.n_sz);
+	n_size = mpi_get_size(ctx->u.rsa.pkey.n) << 3; /* bytes to bits */
+	if (ccp_check_key_length(n_size))
+		goto e_nkey;
+	ctx->u.rsa.key_len = n_size; /* bits */
+	ctx->u.rsa.n_buf = mpi_get_buffer(ctx->u.rsa.pkey.n,
+					  &ctx->u.rsa.n_len, NULL);
+	if (!ctx->u.rsa.n_buf)
+		goto e_nkey;
+	sg_init_one(&ctx->u.rsa.n_sg, ctx->u.rsa.n_buf, ctx->u.rsa.n_len);
+
+	if (private) {
+		ctx->u.rsa.pkey.d = mpi_read_raw_data(raw_key.d, raw_key.d_sz);
+		if (!ctx->u.rsa.pkey.d)
+			goto e_dkey;
+		ctx->u.rsa.d_buf = mpi_get_buffer(ctx->u.rsa.pkey.d,
+						  &ctx->u.rsa.d_len, NULL);
+		if (!ctx->u.rsa.d_buf)
+			goto e_dkey;
+		sg_init_one(&ctx->u.rsa.d_sg, ctx->u.rsa.d_buf,
+			    ctx->u.rsa.d_len);
+	}
+
+	return 0;
+
+e_dkey:
+	kfree(ctx->u.rsa.n_buf);
+e_nkey:
+	kfree(ctx->u.rsa.e_buf);
+e_key:
+	rsa_free_mpi_key(&ctx->u.rsa.pkey);
+e_ret:
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
+	.sign = NULL,
+	.verify = NULL,
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
+		.cra_ctxsize = sizeof(struct ccp_ctx),
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
index 95cce27..aa525e6 100644
--- a/drivers/crypto/ccp/ccp-crypto.h
+++ b/drivers/crypto/ccp/ccp-crypto.h
@@ -22,6 +22,8 @@
 #include <crypto/ctr.h>
 #include <crypto/hash.h>
 #include <crypto/sha.h>
+#include <crypto/akcipher.h>
+#include <crypto/internal/rsa.h>
 
 #define CCP_CRA_PRIORITY	300
 
@@ -46,6 +48,12 @@ struct ccp_crypto_ahash_alg {
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
@@ -194,12 +202,35 @@ struct ccp_sha_exp_ctx {
 	u8 buf[MAX_SHA_BLOCK_SIZE];
 };
 
+/***** RSA related defines *****/
+
+struct ccp_rsa_ctx {
+	unsigned int key_len; /* in bits */
+	struct rsa_mpi_key pkey;
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
 	} u;
 };
@@ -213,5 +244,6 @@ struct scatterlist *ccp_crypto_sg_table_add(struct sg_table *table,
 int ccp_register_aes_cmac_algs(struct list_head *head);
 int ccp_register_aes_xts_algs(struct list_head *head);
 int ccp_register_sha_algs(struct list_head *head);
+int ccp_register_rsa_algs(struct list_head *head);
 
 #endif
diff --git a/include/linux/ccp.h b/include/linux/ccp.h
index 90a1fbe..dd90670 100644
--- a/include/linux/ccp.h
+++ b/include/linux/ccp.h
@@ -20,7 +20,6 @@
 #include <crypto/aes.h>
 #include <crypto/sha.h>
 
-
 struct ccp_device;
 struct ccp_cmd;
 
