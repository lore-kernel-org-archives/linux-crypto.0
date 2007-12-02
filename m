From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3/4] [CRYPTO] authenc: Move enckeylen into key itself
Date: Sun, 02 Dec 2007 18:53:10 +1100
Message-ID: <E1IyjdW-0001X5-00@gondolin.me.apana.org.au>
References: <20071122083656.GB7368@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:2737 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751801AbXLBHxN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 2 Dec 2007 02:53:13 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1IyjdW-00089S-WD
	for <linux-crypto@vger.kernel.org>; Sun, 02 Dec 2007 18:53:11 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[CRYPTO] authenc: Move enckeylen into key itself

Having enckeylen as a template parameter makes it a pain for hardware
devices that implement ciphers with many key sizes since each one would
have to be registered separately.

Since the authenc algorithm is mainly used for legacy purposes where its
key is going to be constructed out of two separate keys, we can in fact
embed this value into the key itself.

This patch does this by prepending an rtnetlink header to the key that
contains the encryption key length.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/authenc.c         |   49 +++++++++++++++++++++++++++--------------------
 include/crypto/authenc.h |   27 +++++++++++++++++++++++++
 2 files changed, 56 insertions(+), 20 deletions(-)

diff --git a/crypto/authenc.c b/crypto/authenc.c
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -11,10 +11,12 @@
  */
 
 #include <crypto/algapi.h>
+#include <crypto/authenc.h>
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/rtnetlink.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 
@@ -23,8 +25,6 @@
 struct authenc_instance_ctx {
 	struct crypto_spawn auth;
 	struct crypto_spawn enc;
-
-	unsigned int enckeylen;
 };
 
 struct crypto_authenc_ctx {
@@ -36,19 +36,31 @@ struct crypto_authenc_ctx {
 static int crypto_authenc_setkey(struct crypto_aead *authenc, const u8 *key,
 				 unsigned int keylen)
 {
-	struct authenc_instance_ctx *ictx =
-		crypto_instance_ctx(crypto_aead_alg_instance(authenc));
-	unsigned int enckeylen = ictx->enckeylen;
 	unsigned int authkeylen;
+	unsigned int enckeylen;
 	struct crypto_authenc_ctx *ctx = crypto_aead_ctx(authenc);
 	struct crypto_hash *auth = ctx->auth;
 	struct crypto_ablkcipher *enc = ctx->enc;
+	struct rtattr *rta = (void *)key;
+	struct crypto_authenc_key_param *param;
 	int err = -EINVAL;
 
-	if (keylen < enckeylen) {
-		crypto_aead_set_flags(authenc, CRYPTO_TFM_RES_BAD_KEY_LEN);
-		goto out;
-	}
+	if (keylen < sizeof(*rta))
+		goto badkey;
+	if (rta->rta_type != CRYPTO_AUTHENC_KEYA_PARAM)
+		goto badkey;
+	if (RTA_PAYLOAD(rta) < sizeof(*param))
+		goto badkey;
+
+	param = RTA_DATA(rta);
+	enckeylen = be32_to_cpu(param->enckeylen);
+
+	key += RTA_ALIGN(rta->rta_len);
+	keylen -= RTA_ALIGN(rta->rta_len);
+
+	if (keylen < enckeylen)
+		goto badkey;
+
 	authkeylen = keylen - enckeylen;
 
 	crypto_hash_clear_flags(auth, CRYPTO_TFM_REQ_MASK);
@@ -70,6 +82,10 @@ static int crypto_authenc_setkey(struct 
 
 out:
 	return err;
+
+badkey:
+	crypto_aead_set_flags(authenc, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	goto out;
 }
 
 static int crypto_authenc_hash(struct aead_request *req)
@@ -263,7 +279,6 @@ static struct crypto_instance *crypto_au
 	struct crypto_alg *auth;
 	struct crypto_alg *enc;
 	struct authenc_instance_ctx *ctx;
-	unsigned int enckeylen;
 	int err;
 
 	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_AEAD);
@@ -281,10 +296,6 @@ static struct crypto_instance *crypto_au
 	if (IS_ERR(enc))
 		goto out_put_auth;
 
-	err = crypto_attr_u32(tb[3], &enckeylen);
-	if (err)
-		goto out_put_enc;
-
 	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
 	err = -ENOMEM;
 	if (!inst)
@@ -292,18 +303,16 @@ static struct crypto_instance *crypto_au
 
 	err = -ENAMETOOLONG;
 	if (snprintf(inst->alg.cra_name, CRYPTO_MAX_ALG_NAME,
-		     "authenc(%s,%s,%u)", auth->cra_name,
-		     enc->cra_name, enckeylen) >= CRYPTO_MAX_ALG_NAME)
+		     "authenc(%s,%s)", auth->cra_name, enc->cra_name) >=
+	    CRYPTO_MAX_ALG_NAME)
 		goto err_free_inst;
 
 	if (snprintf(inst->alg.cra_driver_name, CRYPTO_MAX_ALG_NAME,
-		     "authenc(%s,%s,%u)", auth->cra_driver_name,
-		     enc->cra_driver_name, enckeylen) >=
-	    CRYPTO_MAX_ALG_NAME)
+		     "authenc(%s,%s)", auth->cra_driver_name,
+		     enc->cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
 		goto err_free_inst;
 
 	ctx = crypto_instance_ctx(inst);
-	ctx->enckeylen = enckeylen;
 
 	err = crypto_init_spawn(&ctx->auth, auth, inst, CRYPTO_ALG_TYPE_MASK);
 	if (err)
diff --git a/include/crypto/authenc.h b/include/crypto/authenc.h
new file mode 100644
--- /dev/null
+++ b/include/crypto/authenc.h
@@ -0,0 +1,27 @@
+/*
+ * Authenc: Simple AEAD wrapper for IPsec
+ *
+ * Copyright (c) 2007 Herbert Xu <herbert@gondor.apana.org.au>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ *
+ */
+#ifndef _CRYPTO_AUTHENC_H
+#define _CRYPTO_AUTHENC_H
+
+#include <linux/types.h>
+
+enum {
+	CRYPTO_AUTHENC_KEYA_UNSPEC,
+	CRYPTO_AUTHENC_KEYA_PARAM,
+};
+
+struct crypto_authenc_key_param {
+	__be32 enckeylen;
+};
+
+#endif	/* _CRYPTO_AUTHENC_H */
+
