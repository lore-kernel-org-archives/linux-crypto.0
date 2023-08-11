Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A729C04A94
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Aug 2023 09:30:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232274AbjHKJas (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Aug 2023 05:30:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234980AbjHKJa1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Aug 2023 05:30:27 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F7872D78
        for <linux-crypto@vger.kernel.org>; Fri, 11 Aug 2023 02:30:26 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qUOTN-0020fl-UG; Fri, 11 Aug 2023 17:30:22 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Aug 2023 17:30:22 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Fri, 11 Aug 2023 17:30:22 +0800
Subject: [PATCH 21/36] crypto: engine - Move crypto_engine_ops from request into crypto_alg
References: <ZNX/BwEkV3SDpsAS@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Gaurav Jain <gaurav.jain@nxp.com>
Message-Id: <E1qUOTN-0020fl-UG@formenos.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Rather than having the callback in the request, move it into the
crypto_alg object.  This avoids having crypto_engine look into the
request context is private to the driver.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/crypto_engine.c  |  215 +++++++++++++++++++++++++++++++++++++++++++++---
 include/crypto/engine.h |   59 ++++++++++++-
 2 files changed, 257 insertions(+), 17 deletions(-)

diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c
index a75162bc1bf4..abfb1e6bfa48 100644
--- a/crypto/crypto_engine.c
+++ b/crypto/crypto_engine.c
@@ -7,20 +7,30 @@
  * Author: Baolin Wang <baolin.wang@linaro.org>
  */
 
-#include <crypto/aead.h>
-#include <crypto/akcipher.h>
-#include <crypto/hash.h>
+#include <crypto/internal/aead.h>
+#include <crypto/internal/akcipher.h>
 #include <crypto/internal/engine.h>
-#include <crypto/kpp.h>
-#include <crypto/skcipher.h>
+#include <crypto/internal/hash.h>
+#include <crypto/internal/kpp.h>
+#include <crypto/internal/skcipher.h>
 #include <linux/err.h>
 #include <linux/delay.h>
 #include <linux/device.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
 #include <uapi/linux/sched/types.h>
 #include "internal.h"
 
 #define CRYPTO_ENGINE_MAX_QLEN 10
 
+/* Temporary algorithm flag used to indicate an updated driver. */
+#define CRYPTO_ALG_ENGINE 0x200
+
+struct crypto_engine_alg {
+	struct crypto_alg base;
+	struct crypto_engine_op op;
+};
+
 /**
  * crypto_finalize_request - finalize one request if the request is done
  * @engine: the hardware engine
@@ -64,6 +74,8 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 				 bool in_kthread)
 {
 	struct crypto_async_request *async_req, *backlog;
+	struct crypto_engine_alg *alg;
+	struct crypto_engine_op *op;
 	unsigned long flags;
 	bool was_busy = false;
 	int ret;
@@ -137,15 +149,22 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 		}
 	}
 
-	enginectx = crypto_tfm_ctx(async_req->tfm);
-
-	if (!enginectx->op.do_one_request) {
-		dev_err(engine->dev, "failed to do request\n");
-		ret = -EINVAL;
-		goto req_err_1;
+	if (async_req->tfm->__crt_alg->cra_flags & CRYPTO_ALG_ENGINE) {
+		alg = container_of(async_req->tfm->__crt_alg,
+				   struct crypto_engine_alg, base);
+		op = &alg->op;
+	} else {
+		enginectx = crypto_tfm_ctx(async_req->tfm);
+		op = &enginectx->op;
+
+		if (!op->do_one_request) {
+			dev_err(engine->dev, "failed to do request\n");
+			ret = -EINVAL;
+			goto req_err_1;
+		}
 	}
 
-	ret = enginectx->op.do_one_request(engine, async_req);
+	ret = op->do_one_request(engine, async_req);
 
 	/* Request unsuccessfully executed by hardware */
 	if (ret < 0) {
@@ -556,5 +575,177 @@ int crypto_engine_exit(struct crypto_engine *engine)
 }
 EXPORT_SYMBOL_GPL(crypto_engine_exit);
 
+int crypto_engine_register_aead(struct aead_engine_alg *alg)
+{
+	if (!alg->op.do_one_request)
+		return -EINVAL;
+
+	alg->base.base.cra_flags |= CRYPTO_ALG_ENGINE;
+
+	return crypto_register_aead(&alg->base);
+}
+EXPORT_SYMBOL_GPL(crypto_engine_register_aead);
+
+void crypto_engine_unregister_aead(struct aead_engine_alg *alg)
+{
+	crypto_unregister_aead(&alg->base);
+}
+EXPORT_SYMBOL_GPL(crypto_engine_unregister_aead);
+
+int crypto_engine_register_aeads(struct aead_engine_alg *algs, int count)
+{
+	int i, ret;
+
+	for (i = 0; i < count; i++) {
+		ret = crypto_engine_register_aead(&algs[i]);
+		if (ret)
+			goto err;
+	}
+
+	return 0;
+
+err:
+	crypto_engine_unregister_aeads(algs, i);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(crypto_engine_register_aeads);
+
+void crypto_engine_unregister_aeads(struct aead_engine_alg *algs, int count)
+{
+	int i;
+
+	for (i = count - 1; i >= 0; --i)
+		crypto_engine_unregister_aead(&algs[i]);
+}
+EXPORT_SYMBOL_GPL(crypto_engine_unregister_aeads);
+
+int crypto_engine_register_ahash(struct ahash_engine_alg *alg)
+{
+	if (!alg->op.do_one_request)
+		return -EINVAL;
+
+	alg->base.halg.base.cra_flags |= CRYPTO_ALG_ENGINE;
+
+	return crypto_register_ahash(&alg->base);
+}
+EXPORT_SYMBOL_GPL(crypto_engine_register_ahash);
+
+void crypto_engine_unregister_ahash(struct ahash_engine_alg *alg)
+{
+	crypto_unregister_ahash(&alg->base);
+}
+EXPORT_SYMBOL_GPL(crypto_engine_unregister_ahash);
+
+int crypto_engine_register_ahashes(struct ahash_engine_alg *algs, int count)
+{
+	int i, ret;
+
+	for (i = 0; i < count; i++) {
+		ret = crypto_engine_register_ahash(&algs[i]);
+		if (ret)
+			goto err;
+	}
+
+	return 0;
+
+err:
+	crypto_engine_unregister_ahashes(algs, i);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(crypto_engine_register_ahashes);
+
+void crypto_engine_unregister_ahashes(struct ahash_engine_alg *algs,
+				      int count)
+{
+	int i;
+
+	for (i = count - 1; i >= 0; --i)
+		crypto_engine_unregister_ahash(&algs[i]);
+}
+EXPORT_SYMBOL_GPL(crypto_engine_unregister_ahashes);
+
+int crypto_engine_register_akcipher(struct akcipher_engine_alg *alg)
+{
+	if (!alg->op.do_one_request)
+		return -EINVAL;
+
+	alg->base.base.cra_flags |= CRYPTO_ALG_ENGINE;
+
+	return crypto_register_akcipher(&alg->base);
+}
+EXPORT_SYMBOL_GPL(crypto_engine_register_akcipher);
+
+void crypto_engine_unregister_akcipher(struct akcipher_engine_alg *alg)
+{
+	crypto_unregister_akcipher(&alg->base);
+}
+EXPORT_SYMBOL_GPL(crypto_engine_unregister_akcipher);
+
+int crypto_engine_register_kpp(struct kpp_engine_alg *alg)
+{
+	if (!alg->op.do_one_request)
+		return -EINVAL;
+
+	alg->base.base.cra_flags |= CRYPTO_ALG_ENGINE;
+
+	return crypto_register_kpp(&alg->base);
+}
+EXPORT_SYMBOL_GPL(crypto_engine_register_kpp);
+
+void crypto_engine_unregister_kpp(struct kpp_engine_alg *alg)
+{
+	crypto_unregister_kpp(&alg->base);
+}
+EXPORT_SYMBOL_GPL(crypto_engine_unregister_kpp);
+
+int crypto_engine_register_skcipher(struct skcipher_engine_alg *alg)
+{
+	if (!alg->op.do_one_request)
+		return -EINVAL;
+
+	alg->base.base.cra_flags |= CRYPTO_ALG_ENGINE;
+
+	return crypto_register_skcipher(&alg->base);
+}
+EXPORT_SYMBOL_GPL(crypto_engine_register_skcipher);
+
+void crypto_engine_unregister_skcipher(struct skcipher_engine_alg *alg)
+{
+	return crypto_unregister_skcipher(&alg->base);
+}
+EXPORT_SYMBOL_GPL(crypto_engine_unregister_skcipher);
+
+int crypto_engine_register_skciphers(struct skcipher_engine_alg *algs,
+				     int count)
+{
+	int i, ret;
+
+	for (i = 0; i < count; i++) {
+		ret = crypto_engine_register_skcipher(&algs[i]);
+		if (ret)
+			goto err;
+	}
+
+	return 0;
+
+err:
+	crypto_engine_unregister_skciphers(algs, i);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(crypto_engine_register_skciphers);
+
+void crypto_engine_unregister_skciphers(struct skcipher_engine_alg *algs,
+					int count)
+{
+	int i;
+
+	for (i = count - 1; i >= 0; --i)
+		crypto_engine_unregister_skcipher(&algs[i]);
+}
+EXPORT_SYMBOL_GPL(crypto_engine_unregister_skciphers);
+
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Crypto hardware engine framework");
diff --git a/include/crypto/engine.h b/include/crypto/engine.h
index cc9c7fd1c4d9..cf57e732566b 100644
--- a/include/crypto/engine.h
+++ b/include/crypto/engine.h
@@ -7,15 +7,15 @@
 #ifndef _CRYPTO_ENGINE_H
 #define _CRYPTO_ENGINE_H
 
+#include <crypto/aead.h>
+#include <crypto/akcipher.h>
+#include <crypto/hash.h>
+#include <crypto/kpp.h>
+#include <crypto/skcipher.h>
 #include <linux/types.h>
 
-struct aead_request;
-struct ahash_request;
-struct akcipher_request;
 struct crypto_engine;
 struct device;
-struct kpp_request;
-struct skcipher_request;
 
 /*
  * struct crypto_engine_op - crypto hardware engine operations
@@ -30,6 +30,31 @@ struct crypto_engine_ctx {
 	struct crypto_engine_op op;
 };
 
+struct aead_engine_alg {
+	struct aead_alg base;
+	struct crypto_engine_op op;
+};
+
+struct ahash_engine_alg {
+	struct ahash_alg base;
+	struct crypto_engine_op op;
+};
+
+struct akcipher_engine_alg {
+	struct akcipher_alg base;
+	struct crypto_engine_op op;
+};
+
+struct kpp_engine_alg {
+	struct kpp_alg base;
+	struct crypto_engine_op op;
+};
+
+struct skcipher_engine_alg {
+	struct skcipher_alg base;
+	struct crypto_engine_op op;
+};
+
 int crypto_transfer_aead_request_to_engine(struct crypto_engine *engine,
 					   struct aead_request *req);
 int crypto_transfer_akcipher_request_to_engine(struct crypto_engine *engine,
@@ -59,4 +84,28 @@ struct crypto_engine *crypto_engine_alloc_init_and_set(struct device *dev,
 						       bool rt, int qlen);
 int crypto_engine_exit(struct crypto_engine *engine);
 
+int crypto_engine_register_aead(struct aead_engine_alg *alg);
+void crypto_engine_unregister_aead(struct aead_engine_alg *alg);
+int crypto_engine_register_aeads(struct aead_engine_alg *algs, int count);
+void crypto_engine_unregister_aeads(struct aead_engine_alg *algs, int count);
+
+int crypto_engine_register_ahash(struct ahash_engine_alg *alg);
+void crypto_engine_unregister_ahash(struct ahash_engine_alg *alg);
+int crypto_engine_register_ahashes(struct ahash_engine_alg *algs, int count);
+void crypto_engine_unregister_ahashes(struct ahash_engine_alg *algs,
+				      int count);
+
+int crypto_engine_register_akcipher(struct akcipher_engine_alg *alg);
+void crypto_engine_unregister_akcipher(struct akcipher_engine_alg *alg);
+
+int crypto_engine_register_kpp(struct kpp_engine_alg *alg);
+void crypto_engine_unregister_kpp(struct kpp_engine_alg *alg);
+
+int crypto_engine_register_skcipher(struct skcipher_engine_alg *alg);
+void crypto_engine_unregister_skcipher(struct skcipher_engine_alg *alg);
+int crypto_engine_register_skciphers(struct skcipher_engine_alg *algs,
+				     int count);
+void crypto_engine_unregister_skciphers(struct skcipher_engine_alg *algs,
+					int count);
+
 #endif /* _CRYPTO_ENGINE_H */
