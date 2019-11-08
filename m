Return-Path: <SRS0=0i+u=ZA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D56ABC5DF60
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 10:42:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A151B2178F
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 10:42:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730005AbfKHKmC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Nov 2019 05:42:02 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:43648 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726149AbfKHKmC (ORCPT <rfc822;linux-crypto@vger.kernel.orG>);
        Fri, 8 Nov 2019 05:42:02 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1iT1iK-00045a-KU; Fri, 08 Nov 2019 18:42:00 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1iT1iI-0002wQ-0b; Fri, 08 Nov 2019 18:41:58 +0800
Date:   Fri, 8 Nov 2019 18:41:58 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: aead - Split out geniv into its own module
Message-ID: <20191108104157.dxot72q7sjpf3jhp@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

If aead is built as a module along with cryptomgr, it creates a
dependency loop due to the dependency chain aead => crypto_null =>
cryptomgr => aead.

This is due to the presence of the AEAD geniv code.  This code is
not really part of the AEAD API but simply support code for IV
generators such as seqiv.  This patch moves the geniv code into
its own module thus breaking the dependency loop.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/Makefile b/crypto/Makefile
index 9479e1a45d8c..fda21bd1910e 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -14,6 +14,7 @@ crypto_algapi-y := algapi.o scatterwalk.o $(crypto_algapi-y)
 obj-$(CONFIG_CRYPTO_ALGAPI2) += crypto_algapi.o
 
 obj-$(CONFIG_CRYPTO_AEAD2) += aead.o
+obj-$(CONFIG_CRYPTO_AEAD2) += geniv.o
 
 crypto_blkcipher-y := ablkcipher.o
 crypto_blkcipher-y += blkcipher.o
diff --git a/crypto/aead.c b/crypto/aead.c
index fbf0ec93bc8e..2185445e21c5 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -7,19 +7,14 @@
  * Copyright (c) 2007-2015 Herbert Xu <herbert@gondor.apana.org.au>
  */
 
-#include <crypto/internal/geniv.h>
-#include <crypto/internal/rng.h>
-#include <crypto/null.h>
-#include <crypto/scatterwalk.h>
-#include <linux/err.h>
+#include <crypto/internal/aead.h>
+#include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/rtnetlink.h>
 #include <linux/slab.h>
 #include <linux/seq_file.h>
 #include <linux/cryptouser.h>
-#include <linux/compiler.h>
 #include <net/netlink.h>
 
 #include "internal.h"
@@ -211,162 +206,6 @@ static const struct crypto_type crypto_aead_type = {
 	.tfmsize = offsetof(struct crypto_aead, base),
 };
 
-static int aead_geniv_setkey(struct crypto_aead *tfm,
-			     const u8 *key, unsigned int keylen)
-{
-	struct aead_geniv_ctx *ctx = crypto_aead_ctx(tfm);
-
-	return crypto_aead_setkey(ctx->child, key, keylen);
-}
-
-static int aead_geniv_setauthsize(struct crypto_aead *tfm,
-				  unsigned int authsize)
-{
-	struct aead_geniv_ctx *ctx = crypto_aead_ctx(tfm);
-
-	return crypto_aead_setauthsize(ctx->child, authsize);
-}
-
-struct aead_instance *aead_geniv_alloc(struct crypto_template *tmpl,
-				       struct rtattr **tb, u32 type, u32 mask)
-{
-	const char *name;
-	struct crypto_aead_spawn *spawn;
-	struct crypto_attr_type *algt;
-	struct aead_instance *inst;
-	struct aead_alg *alg;
-	unsigned int ivsize;
-	unsigned int maxauthsize;
-	int err;
-
-	algt = crypto_get_attr_type(tb);
-	if (IS_ERR(algt))
-		return ERR_CAST(algt);
-
-	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
-		return ERR_PTR(-EINVAL);
-
-	name = crypto_attr_alg_name(tb[1]);
-	if (IS_ERR(name))
-		return ERR_CAST(name);
-
-	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
-	if (!inst)
-		return ERR_PTR(-ENOMEM);
-
-	spawn = aead_instance_ctx(inst);
-
-	/* Ignore async algorithms if necessary. */
-	mask |= crypto_requires_sync(algt->type, algt->mask);
-
-	crypto_set_aead_spawn(spawn, aead_crypto_instance(inst));
-	err = crypto_grab_aead(spawn, name, type, mask);
-	if (err)
-		goto err_free_inst;
-
-	alg = crypto_spawn_aead_alg(spawn);
-
-	ivsize = crypto_aead_alg_ivsize(alg);
-	maxauthsize = crypto_aead_alg_maxauthsize(alg);
-
-	err = -EINVAL;
-	if (ivsize < sizeof(u64))
-		goto err_drop_alg;
-
-	err = -ENAMETOOLONG;
-	if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME,
-		     "%s(%s)", tmpl->name, alg->base.cra_name) >=
-	    CRYPTO_MAX_ALG_NAME)
-		goto err_drop_alg;
-	if (snprintf(inst->alg.base.cra_driver_name, CRYPTO_MAX_ALG_NAME,
-		     "%s(%s)", tmpl->name, alg->base.cra_driver_name) >=
-	    CRYPTO_MAX_ALG_NAME)
-		goto err_drop_alg;
-
-	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_ASYNC;
-	inst->alg.base.cra_priority = alg->base.cra_priority;
-	inst->alg.base.cra_blocksize = alg->base.cra_blocksize;
-	inst->alg.base.cra_alignmask = alg->base.cra_alignmask;
-	inst->alg.base.cra_ctxsize = sizeof(struct aead_geniv_ctx);
-
-	inst->alg.setkey = aead_geniv_setkey;
-	inst->alg.setauthsize = aead_geniv_setauthsize;
-
-	inst->alg.ivsize = ivsize;
-	inst->alg.maxauthsize = maxauthsize;
-
-out:
-	return inst;
-
-err_drop_alg:
-	crypto_drop_aead(spawn);
-err_free_inst:
-	kfree(inst);
-	inst = ERR_PTR(err);
-	goto out;
-}
-EXPORT_SYMBOL_GPL(aead_geniv_alloc);
-
-void aead_geniv_free(struct aead_instance *inst)
-{
-	crypto_drop_aead(aead_instance_ctx(inst));
-	kfree(inst);
-}
-EXPORT_SYMBOL_GPL(aead_geniv_free);
-
-int aead_init_geniv(struct crypto_aead *aead)
-{
-	struct aead_geniv_ctx *ctx = crypto_aead_ctx(aead);
-	struct aead_instance *inst = aead_alg_instance(aead);
-	struct crypto_aead *child;
-	int err;
-
-	spin_lock_init(&ctx->lock);
-
-	err = crypto_get_default_rng();
-	if (err)
-		goto out;
-
-	err = crypto_rng_get_bytes(crypto_default_rng, ctx->salt,
-				   crypto_aead_ivsize(aead));
-	crypto_put_default_rng();
-	if (err)
-		goto out;
-
-	ctx->sknull = crypto_get_default_null_skcipher();
-	err = PTR_ERR(ctx->sknull);
-	if (IS_ERR(ctx->sknull))
-		goto out;
-
-	child = crypto_spawn_aead(aead_instance_ctx(inst));
-	err = PTR_ERR(child);
-	if (IS_ERR(child))
-		goto drop_null;
-
-	ctx->child = child;
-	crypto_aead_set_reqsize(aead, crypto_aead_reqsize(child) +
-				      sizeof(struct aead_request));
-
-	err = 0;
-
-out:
-	return err;
-
-drop_null:
-	crypto_put_default_null_skcipher();
-	goto out;
-}
-EXPORT_SYMBOL_GPL(aead_init_geniv);
-
-void aead_exit_geniv(struct crypto_aead *tfm)
-{
-	struct aead_geniv_ctx *ctx = crypto_aead_ctx(tfm);
-
-	crypto_free_aead(ctx->child);
-	crypto_put_default_null_skcipher();
-}
-EXPORT_SYMBOL_GPL(aead_exit_geniv);
-
 int crypto_grab_aead(struct crypto_aead_spawn *spawn, const char *name,
 		     u32 type, u32 mask)
 {
diff --git a/crypto/geniv.c b/crypto/geniv.c
new file mode 100644
index 000000000000..b9e45a2a98b5
--- /dev/null
+++ b/crypto/geniv.c
@@ -0,0 +1,176 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * geniv: Shared IV generator code
+ *
+ * This file provides common code to IV generators such as seqiv.
+ *
+ * Copyright (c) 2007-2019 Herbert Xu <herbert@gondor.apana.org.au>
+ */
+
+#include <crypto/internal/geniv.h>
+#include <crypto/internal/rng.h>
+#include <crypto/null.h>
+#include <linux/err.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/rtnetlink.h>
+#include <linux/slab.h>
+
+static int aead_geniv_setkey(struct crypto_aead *tfm,
+			     const u8 *key, unsigned int keylen)
+{
+	struct aead_geniv_ctx *ctx = crypto_aead_ctx(tfm);
+
+	return crypto_aead_setkey(ctx->child, key, keylen);
+}
+
+static int aead_geniv_setauthsize(struct crypto_aead *tfm,
+				  unsigned int authsize)
+{
+	struct aead_geniv_ctx *ctx = crypto_aead_ctx(tfm);
+
+	return crypto_aead_setauthsize(ctx->child, authsize);
+}
+
+struct aead_instance *aead_geniv_alloc(struct crypto_template *tmpl,
+				       struct rtattr **tb, u32 type, u32 mask)
+{
+	const char *name;
+	struct crypto_aead_spawn *spawn;
+	struct crypto_attr_type *algt;
+	struct aead_instance *inst;
+	struct aead_alg *alg;
+	unsigned int ivsize;
+	unsigned int maxauthsize;
+	int err;
+
+	algt = crypto_get_attr_type(tb);
+	if (IS_ERR(algt))
+		return ERR_CAST(algt);
+
+	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
+		return ERR_PTR(-EINVAL);
+
+	name = crypto_attr_alg_name(tb[1]);
+	if (IS_ERR(name))
+		return ERR_CAST(name);
+
+	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
+	if (!inst)
+		return ERR_PTR(-ENOMEM);
+
+	spawn = aead_instance_ctx(inst);
+
+	/* Ignore async algorithms if necessary. */
+	mask |= crypto_requires_sync(algt->type, algt->mask);
+
+	crypto_set_aead_spawn(spawn, aead_crypto_instance(inst));
+	err = crypto_grab_aead(spawn, name, type, mask);
+	if (err)
+		goto err_free_inst;
+
+	alg = crypto_spawn_aead_alg(spawn);
+
+	ivsize = crypto_aead_alg_ivsize(alg);
+	maxauthsize = crypto_aead_alg_maxauthsize(alg);
+
+	err = -EINVAL;
+	if (ivsize < sizeof(u64))
+		goto err_drop_alg;
+
+	err = -ENAMETOOLONG;
+	if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME,
+		     "%s(%s)", tmpl->name, alg->base.cra_name) >=
+	    CRYPTO_MAX_ALG_NAME)
+		goto err_drop_alg;
+	if (snprintf(inst->alg.base.cra_driver_name, CRYPTO_MAX_ALG_NAME,
+		     "%s(%s)", tmpl->name, alg->base.cra_driver_name) >=
+	    CRYPTO_MAX_ALG_NAME)
+		goto err_drop_alg;
+
+	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_ASYNC;
+	inst->alg.base.cra_priority = alg->base.cra_priority;
+	inst->alg.base.cra_blocksize = alg->base.cra_blocksize;
+	inst->alg.base.cra_alignmask = alg->base.cra_alignmask;
+	inst->alg.base.cra_ctxsize = sizeof(struct aead_geniv_ctx);
+
+	inst->alg.setkey = aead_geniv_setkey;
+	inst->alg.setauthsize = aead_geniv_setauthsize;
+
+	inst->alg.ivsize = ivsize;
+	inst->alg.maxauthsize = maxauthsize;
+
+out:
+	return inst;
+
+err_drop_alg:
+	crypto_drop_aead(spawn);
+err_free_inst:
+	kfree(inst);
+	inst = ERR_PTR(err);
+	goto out;
+}
+EXPORT_SYMBOL_GPL(aead_geniv_alloc);
+
+void aead_geniv_free(struct aead_instance *inst)
+{
+	crypto_drop_aead(aead_instance_ctx(inst));
+	kfree(inst);
+}
+EXPORT_SYMBOL_GPL(aead_geniv_free);
+
+int aead_init_geniv(struct crypto_aead *aead)
+{
+	struct aead_geniv_ctx *ctx = crypto_aead_ctx(aead);
+	struct aead_instance *inst = aead_alg_instance(aead);
+	struct crypto_aead *child;
+	int err;
+
+	spin_lock_init(&ctx->lock);
+
+	err = crypto_get_default_rng();
+	if (err)
+		goto out;
+
+	err = crypto_rng_get_bytes(crypto_default_rng, ctx->salt,
+				   crypto_aead_ivsize(aead));
+	crypto_put_default_rng();
+	if (err)
+		goto out;
+
+	ctx->sknull = crypto_get_default_null_skcipher();
+	err = PTR_ERR(ctx->sknull);
+	if (IS_ERR(ctx->sknull))
+		goto out;
+
+	child = crypto_spawn_aead(aead_instance_ctx(inst));
+	err = PTR_ERR(child);
+	if (IS_ERR(child))
+		goto drop_null;
+
+	ctx->child = child;
+	crypto_aead_set_reqsize(aead, crypto_aead_reqsize(child) +
+				      sizeof(struct aead_request));
+
+	err = 0;
+
+out:
+	return err;
+
+drop_null:
+	crypto_put_default_null_skcipher();
+	goto out;
+}
+EXPORT_SYMBOL_GPL(aead_init_geniv);
+
+void aead_exit_geniv(struct crypto_aead *tfm)
+{
+	struct aead_geniv_ctx *ctx = crypto_aead_ctx(tfm);
+
+	crypto_free_aead(ctx->child);
+	crypto_put_default_null_skcipher();
+}
+EXPORT_SYMBOL_GPL(aead_exit_geniv);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Shared IV generator code");
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
