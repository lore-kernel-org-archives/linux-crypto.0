From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [RFC] [PATCH 5/5] authenc: Add support for the pcrypt aead wrapper
Date: Wed, 13 May 2009 15:10:37 +0200
Message-ID: <20090513131037.GI20366@secunet.com>
References: <20090513130618.GD20366@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([213.68.205.161]:37529 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760014AbZEMNIX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 13 May 2009 09:08:23 -0400
Content-Disposition: inline
In-Reply-To: <20090513130618.GD20366@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This adds support for aead wrapper templates. An aead wrapper
can be coosen via a module parameter. For the moment only
pcrypt is supported.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 crypto/authenc.c |   33 +++++++++++++++++++++++++++++++--
 1 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/crypto/authenc.c b/crypto/authenc.c
index 5793b64..aaa0fcc 100644
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -13,6 +13,7 @@
 #include <crypto/aead.h>
 #include <crypto/internal/hash.h>
 #include <crypto/internal/skcipher.h>
+#include <crypto/internal/aead.h>
 #include <crypto/authenc.h>
 #include <crypto/scatterwalk.h>
 #include <linux/err.h>
@@ -23,6 +24,10 @@
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 
+static char *wrapper = NULL;
+module_param(wrapper, charp, 0);
+MODULE_PARM_DESC(wrapper, "Wrapper template for AEAD algorithms");
+
 struct authenc_instance_ctx {
 	struct crypto_spawn auth;
 	struct crypto_skcipher_spawn enc;
@@ -157,15 +162,16 @@ static int crypto_authenc_genicv(struct aead_request *req, u8 *iv,
 
 	dstp = sg_page(dst);
 	vdst = PageHighMem(dstp) ? NULL : page_address(dstp) + dst->offset;
+	cryptlen = req->cryptlen;
 
-	if (ivsize) {
+	if (ivsize && !(aead_request_flags(req) & CRYPTO_TFM_REQ_SG_HAS_IV)) {
 		sg_init_table(cipher, 2);
 		sg_set_buf(cipher, iv, ivsize);
 		authenc_chain(cipher, dst, vdst == iv + ivsize);
 		dst = cipher;
+		cryptlen += ivsize;
 	}
 
-	cryptlen = req->cryptlen + ivsize;
 	hash = crypto_authenc_hash(req, flags, dst, cryptlen);
 	if (IS_ERR(hash))
 		return PTR_ERR(hash);
@@ -369,6 +375,26 @@ static void crypto_authenc_exit_tfm(struct crypto_tfm *tfm)
 	crypto_free_ablkcipher(ctx->enc);
 }
 
+static int crypto_authenc_set_wrapper(struct crypto_instance *inst)
+{
+	int err = 0;
+
+	if (!wrapper)
+		goto out;
+
+	if (!strcmp(wrapper, "pcrypt")) {
+		inst->alg.cra_type = &crypto_nivaead_type;
+		inst->alg.cra_aead.geniv = "eseqiv";
+		inst->alg.cra_aead.wrapper = "pcrypt";
+
+		goto out;
+	}
+
+	err = -EINVAL;
+out:
+	return err;
+}
+
 static struct crypto_instance *crypto_authenc_alloc(struct rtattr **tb)
 {
 	struct crypto_attr_type *algt;
@@ -452,6 +478,9 @@ static struct crypto_instance *crypto_authenc_alloc(struct rtattr **tb)
 	inst->alg.cra_aead.decrypt = crypto_authenc_decrypt;
 	inst->alg.cra_aead.givencrypt = crypto_authenc_givencrypt;
 
+	if (crypto_authenc_set_wrapper(inst))
+		goto err_drop_enc;
+
 out:
 	crypto_mod_put(auth);
 	return inst;
-- 
1.5.4.2

