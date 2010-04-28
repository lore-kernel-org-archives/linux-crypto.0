From: lee.nipper@gmail.com
Subject: [PATCH 2/3] crypto: talitos - second prepare step for adding ahash algorithms
Date: Wed, 28 Apr 2010 05:33:54 -0700 (PDT)
Message-ID: <4bd82b32.0e0bca0a.3ac0.ffffa3a9@mx.google.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53033 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486Ab0D1Mdz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 28 Apr 2010 08:33:55 -0400
Received: by gyg13 with SMTP id 13so7220499gyg.19
        for <linux-crypto@vger.kernel.org>; Wed, 28 Apr 2010 05:33:54 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Used talitos_alg_template in talitos_crypto_alg
so that it will accommodate ahash algorithms.
Added some preparation code for ahash allocation and removal.
No actual algorithms yet.

Signed-off-by: Lee Nipper <lee.nipper@gmail.com>
---
 drivers/crypto/talitos.c |   55 ++++++++++++++++++++++++++++++++++++----------
 1 files changed, 43 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 602387d..9d52d43 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -45,6 +45,8 @@
 #include <crypto/aead.h>
 #include <crypto/authenc.h>
 #include <crypto/skcipher.h>
+#include <crypto/hash.h>
+#include <crypto/internal/hash.h>
 #include <crypto/scatterwalk.h>
 
 #include "talitos.h"
@@ -1481,6 +1483,7 @@ struct talitos_alg_template {
 	u32 type;
 	union {
 		struct crypto_alg crypto;
+		struct ahash_alg hash;
 	} alg;
 	__be32 desc_hdr_template;
 };
@@ -1697,8 +1700,7 @@ static struct talitos_alg_template driver_algs[] = {
 struct talitos_crypto_alg {
 	struct list_head entry;
 	struct device *dev;
-	__be32 desc_hdr_template;
-	struct crypto_alg crypto_alg;
+	struct talitos_alg_template algt;
 };
 
 static int talitos_cra_init(struct crypto_tfm *tfm)
@@ -1707,13 +1709,14 @@ static int talitos_cra_init(struct crypto_tfm *tfm)
 	struct talitos_crypto_alg *talitos_alg;
 	struct talitos_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	talitos_alg =  container_of(alg, struct talitos_crypto_alg, crypto_alg);
+	talitos_alg =  container_of(alg, struct talitos_crypto_alg,
+				    algt.alg.crypto);
 
 	/* update context with ptr to dev */
 	ctx->dev = talitos_alg->dev;
 
 	/* copy descriptor header template value */
-	ctx->desc_hdr_template = talitos_alg->desc_hdr_template;
+	ctx->desc_hdr_template = talitos_alg->algt.desc_hdr_template;
 
 	/* random first IV */
 	get_random_bytes(ctx->iv, TALITOS_MAX_IV_LENGTH);
@@ -1749,7 +1752,15 @@ static int talitos_remove(struct of_device *ofdev)
 	int i;
 
 	list_for_each_entry_safe(t_alg, n, &priv->alg_list, entry) {
-		crypto_unregister_alg(&t_alg->crypto_alg);
+		switch (t_alg->algt.type) {
+		case CRYPTO_ALG_TYPE_ABLKCIPHER:
+		case CRYPTO_ALG_TYPE_AEAD:
+			crypto_unregister_alg(&t_alg->algt.alg.crypto);
+			break;
+		case CRYPTO_ALG_TYPE_AHASH:
+			crypto_unregister_ahash(&t_alg->algt.alg.hash);
+			break;
+		}
 		list_del(&t_alg->entry);
 		kfree(t_alg);
 	}
@@ -1790,8 +1801,16 @@ static struct talitos_crypto_alg *talitos_alg_alloc(struct device *dev,
 	if (!t_alg)
 		return ERR_PTR(-ENOMEM);
 
-	alg = &t_alg->crypto_alg;
-	*alg = template->alg.crypto;
+	t_alg->algt = *template;
+
+	switch (t_alg->algt.type) {
+	case CRYPTO_ALG_TYPE_ABLKCIPHER:
+	case CRYPTO_ALG_TYPE_AEAD:
+		alg = &t_alg->algt.alg.crypto;
+		break;
+	case CRYPTO_ALG_TYPE_AHASH:
+		alg = &t_alg->algt.alg.hash.halg.base;
+	}
 
 	alg->cra_module = THIS_MODULE;
 	alg->cra_init = talitos_cra_init;
@@ -1799,7 +1818,6 @@ static struct talitos_crypto_alg *talitos_alg_alloc(struct device *dev,
 	alg->cra_alignmask = 0;
 	alg->cra_ctxsize = sizeof(struct talitos_ctx);
 
-	t_alg->desc_hdr_template = template->desc_hdr_template;
 	t_alg->dev = dev;
 
 	return t_alg;
@@ -1933,6 +1951,7 @@ static int talitos_probe(struct of_device *ofdev,
 	for (i = 0; i < ARRAY_SIZE(driver_algs); i++) {
 		if (hw_supports(dev, driver_algs[i].desc_hdr_template)) {
 			struct talitos_crypto_alg *t_alg;
+			char *name = NULL;
 
 			t_alg = talitos_alg_alloc(dev, &driver_algs[i]);
 			if (IS_ERR(t_alg)) {
@@ -1940,15 +1959,27 @@ static int talitos_probe(struct of_device *ofdev,
 				goto err_out;
 			}
 
-			err = crypto_register_alg(&t_alg->crypto_alg);
+			switch (t_alg->algt.type) {
+			case CRYPTO_ALG_TYPE_ABLKCIPHER:
+			case CRYPTO_ALG_TYPE_AEAD:
+				err = crypto_register_alg(
+						&t_alg->algt.alg.crypto);
+				name = t_alg->algt.alg.crypto.cra_driver_name;
+				break;
+			case CRYPTO_ALG_TYPE_AHASH:
+				err = crypto_register_ahash(
+						&t_alg->algt.alg.hash);
+				name =
+				 t_alg->algt.alg.hash.halg.base.cra_driver_name;
+				break;
+			}
 			if (err) {
 				dev_err(dev, "%s alg registration failed\n",
-					t_alg->crypto_alg.cra_driver_name);
+					name);
 				kfree(t_alg);
 			} else {
 				list_add_tail(&t_alg->entry, &priv->alg_list);
-				dev_info(dev, "%s\n",
-					 t_alg->crypto_alg.cra_driver_name);
+				dev_info(dev, "%s\n", name);
 			}
 		}
 	}
-- 
1.6.0.4

