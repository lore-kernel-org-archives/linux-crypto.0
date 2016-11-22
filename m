From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v3 PATCH 7/16] crypto: simd - Add simd skcipher helper
Date: Tue, 22 Nov 2016 20:08:25 +0800
Message-ID: <E1c99s9-00038I-LR@gondobar>
References: <20161122120703.GA11911@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:45566 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932704AbcKVMIh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Nov 2016 07:08:37 -0500
Received: from [192.168.128.4] (helo=gondobar)
        by fornost.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
        id 1c99sF-000618-3e
        for <linux-crypto@vger.kernel.org>; Tue, 22 Nov 2016 23:08:32 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds the simd skcipher helper which is meant to be
a replacement for ablk helper.  It replaces the underlying blkcipher
interface with skcipher, and also presents the top-level algorithm
as an skcipher.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/Kconfig                 |    4 
 crypto/Makefile                |    2 
 crypto/simd.c                  |  226 +++++++++++++++++++++++++++++++++++++++++
 include/crypto/internal/simd.h |   17 +++
 4 files changed, 249 insertions(+)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 1db2a19..3d31181 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -246,6 +246,10 @@ config CRYPTO_ABLK_HELPER
 	tristate
 	select CRYPTO_CRYPTD
 
+config CRYPTO_SIMD
+	tristate
+	select CRYPTO_CRYPTD
+
 config CRYPTO_GLUE_HELPER_X86
 	tristate
 	depends on X86
diff --git a/crypto/Makefile b/crypto/Makefile
index 82ffeee..a05590e 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -142,3 +142,5 @@ obj-$(CONFIG_ASYNC_CORE) += async_tx/
 obj-$(CONFIG_ASYMMETRIC_KEY_TYPE) += asymmetric_keys/
 obj-$(CONFIG_CRYPTO_HASH_INFO) += hash_info.o
 obj-$(CONFIG_CRYPTO_ABLK_HELPER) += ablk_helper.o
+crypto_simd-y := simd.o
+obj-$(CONFIG_CRYPTO_SIMD) += crypto_simd.o
diff --git a/crypto/simd.c b/crypto/simd.c
new file mode 100644
index 0000000..8820337
--- /dev/null
+++ b/crypto/simd.c
@@ -0,0 +1,226 @@
+/*
+ * Shared crypto simd helpers
+ *
+ * Copyright (c) 2012 Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
+ * Copyright (c) 2016 Herbert Xu <herbert@gondor.apana.org.au>
+ *
+ * Based on aesni-intel_glue.c by:
+ *  Copyright (C) 2008, Intel Corp.
+ *    Author: Huang Ying <ying.huang@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
+ * USA
+ *
+ */
+
+#include <crypto/cryptd.h>
+#include <crypto/internal/simd.h>
+#include <crypto/internal/skcipher.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/preempt.h>
+#include <asm/simd.h>
+
+struct simd_skcipher_alg {
+	const char *ialg_name;
+	struct skcipher_alg alg;
+};
+
+struct simd_skcipher_ctx {
+	struct cryptd_skcipher *cryptd_tfm;
+};
+
+static int simd_skcipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
+				unsigned int key_len)
+{
+	struct simd_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct crypto_skcipher *child = &ctx->cryptd_tfm->base;
+	int err;
+
+	crypto_skcipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
+	crypto_skcipher_set_flags(child, crypto_skcipher_get_flags(tfm) &
+					 CRYPTO_TFM_REQ_MASK);
+	err = crypto_skcipher_setkey(child, key, key_len);
+	crypto_skcipher_set_flags(tfm, crypto_skcipher_get_flags(child) &
+				       CRYPTO_TFM_RES_MASK);
+	return err;
+}
+
+static int simd_skcipher_encrypt(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct simd_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct skcipher_request *subreq;
+	struct crypto_skcipher *child;
+
+	subreq = skcipher_request_ctx(req);
+	*subreq = *req;
+
+	if (!may_use_simd() ||
+	    (in_atomic() && cryptd_skcipher_queued(ctx->cryptd_tfm)))
+		child = &ctx->cryptd_tfm->base;
+	else
+		child = cryptd_skcipher_child(ctx->cryptd_tfm);
+
+	skcipher_request_set_tfm(subreq, child);
+
+	return crypto_skcipher_encrypt(subreq);
+}
+
+static int simd_skcipher_decrypt(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct simd_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct skcipher_request *subreq;
+	struct crypto_skcipher *child;
+
+	subreq = skcipher_request_ctx(req);
+	*subreq = *req;
+
+	if (!may_use_simd() ||
+	    (in_atomic() && cryptd_skcipher_queued(ctx->cryptd_tfm)))
+		child = &ctx->cryptd_tfm->base;
+	else
+		child = cryptd_skcipher_child(ctx->cryptd_tfm);
+
+	skcipher_request_set_tfm(subreq, child);
+
+	return crypto_skcipher_decrypt(subreq);
+}
+
+static void simd_skcipher_exit(struct crypto_skcipher *tfm)
+{
+	struct simd_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
+
+	cryptd_free_skcipher(ctx->cryptd_tfm);
+}
+
+static int simd_skcipher_init(struct crypto_skcipher *tfm)
+{
+	struct simd_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct cryptd_skcipher *cryptd_tfm;
+	struct simd_skcipher_alg *salg;
+	struct skcipher_alg *alg;
+	unsigned reqsize;
+
+	alg = crypto_skcipher_alg(tfm);
+	salg = container_of(alg, struct simd_skcipher_alg, alg);
+
+	cryptd_tfm = cryptd_alloc_skcipher(salg->ialg_name,
+					   CRYPTO_ALG_INTERNAL,
+					   CRYPTO_ALG_INTERNAL);
+	if (IS_ERR(cryptd_tfm))
+		return PTR_ERR(cryptd_tfm);
+
+	ctx->cryptd_tfm = cryptd_tfm;
+
+	reqsize = sizeof(struct skcipher_request);
+	reqsize += crypto_skcipher_reqsize(&cryptd_tfm->base);
+
+	crypto_skcipher_set_reqsize(tfm, reqsize);
+
+	return 0;
+}
+
+struct simd_skcipher_alg *simd_skcipher_create_compat(const char *algname,
+						      const char *drvname,
+						      const char *basename)
+{
+	struct simd_skcipher_alg *salg;
+	struct crypto_skcipher *tfm;
+	struct skcipher_alg *ialg;
+	struct skcipher_alg *alg;
+	int err;
+
+	tfm = crypto_alloc_skcipher(basename, CRYPTO_ALG_INTERNAL,
+				    CRYPTO_ALG_INTERNAL | CRYPTO_ALG_ASYNC);
+	if (IS_ERR(tfm))
+		return ERR_CAST(tfm);
+
+	ialg = crypto_skcipher_alg(tfm);
+
+	salg = kzalloc(sizeof(*salg), GFP_KERNEL);
+	if (!salg) {
+		salg = ERR_PTR(-ENOMEM);
+		goto out_put_tfm;
+	}
+
+	salg->ialg_name = basename;
+	alg = &salg->alg;
+
+	err = -ENAMETOOLONG;
+	if (snprintf(alg->base.cra_name, CRYPTO_MAX_ALG_NAME, "%s", algname) >=
+	    CRYPTO_MAX_ALG_NAME)
+		goto out_free_salg;
+
+	if (snprintf(alg->base.cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s",
+		     drvname) >= CRYPTO_MAX_ALG_NAME)
+		goto out_free_salg;
+
+	alg->base.cra_flags = CRYPTO_ALG_ASYNC;
+	alg->base.cra_priority = ialg->base.cra_priority;
+	alg->base.cra_blocksize = ialg->base.cra_blocksize;
+	alg->base.cra_alignmask = ialg->base.cra_alignmask;
+	alg->base.cra_module = ialg->base.cra_module;
+	alg->base.cra_ctxsize = sizeof(struct simd_skcipher_ctx);
+
+	alg->ivsize = ialg->ivsize;
+	alg->chunksize = ialg->chunksize;
+	alg->min_keysize = ialg->min_keysize;
+	alg->max_keysize = ialg->max_keysize;
+
+	alg->init = simd_skcipher_init;
+	alg->exit = simd_skcipher_exit;
+
+	alg->setkey = simd_skcipher_setkey;
+	alg->encrypt = simd_skcipher_encrypt;
+	alg->decrypt = simd_skcipher_decrypt;
+
+	err = crypto_register_skcipher(alg);
+	if (err)
+		goto out_free_salg;
+
+out_put_tfm:
+	crypto_free_skcipher(tfm);
+	return salg;
+
+out_free_salg:
+	kfree(salg);
+	salg = ERR_PTR(err);
+	goto out_put_tfm;
+}
+EXPORT_SYMBOL_GPL(simd_skcipher_create_compat);
+
+struct simd_skcipher_alg *simd_skcipher_create(const char *algname,
+					       const char *basename)
+{
+	char drvname[CRYPTO_MAX_ALG_NAME];
+
+	if (snprintf(drvname, CRYPTO_MAX_ALG_NAME, "simd-%s", basename) >=
+	    CRYPTO_MAX_ALG_NAME)
+		return ERR_PTR(-ENAMETOOLONG);
+
+	return simd_skcipher_create_compat(algname, drvname, basename);
+}
+EXPORT_SYMBOL_GPL(simd_skcipher_create);
+
+void simd_skcipher_free(struct simd_skcipher_alg *salg)
+{
+	crypto_unregister_skcipher(&salg->alg);
+	kfree(salg);
+}
+EXPORT_SYMBOL_GPL(simd_skcipher_free);
+
+MODULE_LICENSE("GPL");
diff --git a/include/crypto/internal/simd.h b/include/crypto/internal/simd.h
new file mode 100644
index 0000000..4295099
--- /dev/null
+++ b/include/crypto/internal/simd.h
@@ -0,0 +1,17 @@
+/*
+ * Shared crypto simd helpers
+ */
+
+#ifndef _CRYPTO_INTERNAL_SIMD_H
+#define _CRYPTO_INTERNAL_SIMD_H
+
+struct simd_skcipher_alg;
+
+struct simd_skcipher_alg *simd_skcipher_create_compat(const char *algname,
+						      const char *drvname,
+						      const char *basename);
+struct simd_skcipher_alg *simd_skcipher_create(const char *algname,
+					       const char *basename);
+void simd_skcipher_free(struct simd_skcipher_alg *alg);
+
+#endif /* _CRYPTO_INTERNAL_SIMD_H */
