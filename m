From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 15/28] crypto: ccp - Use skcipher for fallback
Date: Wed, 29 Jun 2016 18:04:01 +0800
Message-ID: <E1bICLh-0006um-II@gondolin.me.apana.org.au>
References: <20160629100223.GA26260@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:37992 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbcF2KEE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Jun 2016 06:04:04 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1bICLh-0005JX-ML
	for <linux-crypto@vger.kernel.org>; Wed, 29 Jun 2016 20:04:01 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch replaces use of the obsolete ablkcipher with skcipher.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/ccp/ccp-crypto-aes-xts.c |   43 ++++++++++++++------------------
 drivers/crypto/ccp/ccp-crypto.h         |    3 --
 2 files changed, 21 insertions(+), 25 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-aes-xts.c b/drivers/crypto/ccp/ccp-crypto-aes-xts.c
index 0d0d452..58a4244 100644
--- a/drivers/crypto/ccp/ccp-crypto-aes-xts.c
+++ b/drivers/crypto/ccp/ccp-crypto-aes-xts.c
@@ -14,9 +14,8 @@
 #include <linux/sched.h>
 #include <linux/delay.h>
 #include <linux/scatterlist.h>
-#include <linux/crypto.h>
-#include <crypto/algapi.h>
 #include <crypto/aes.h>
+#include <crypto/internal/skcipher.h>
 #include <crypto/scatterwalk.h>
 
 #include "ccp-crypto.h"
@@ -110,15 +109,12 @@ static int ccp_aes_xts_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 	ctx->u.aes.key_len = key_len / 2;
 	sg_init_one(&ctx->u.aes.key_sg, ctx->u.aes.key, key_len);
 
-	return crypto_ablkcipher_setkey(ctx->u.aes.tfm_ablkcipher, key,
-					key_len);
+	return crypto_skcipher_setkey(ctx->u.aes.tfm_skcipher, key, key_len);
 }
 
 static int ccp_aes_xts_crypt(struct ablkcipher_request *req,
 			     unsigned int encrypt)
 {
-	struct crypto_tfm *tfm =
-		crypto_ablkcipher_tfm(crypto_ablkcipher_reqtfm(req));
 	struct ccp_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
 	struct ccp_aes_req_ctx *rctx = ablkcipher_request_ctx(req);
 	unsigned int unit;
@@ -146,14 +142,19 @@ static int ccp_aes_xts_crypt(struct ablkcipher_request *req,
 
 	if ((unit_size == CCP_XTS_AES_UNIT_SIZE__LAST) ||
 	    (ctx->u.aes.key_len != AES_KEYSIZE_128)) {
+		SKCIPHER_REQUEST_ON_STACK(subreq, ctx->u.aes.tfm_skcipher);
+
 		/* Use the fallback to process the request for any
 		 * unsupported unit sizes or key sizes
 		 */
-		ablkcipher_request_set_tfm(req, ctx->u.aes.tfm_ablkcipher);
-		ret = (encrypt) ? crypto_ablkcipher_encrypt(req) :
-				  crypto_ablkcipher_decrypt(req);
-		ablkcipher_request_set_tfm(req, __crypto_ablkcipher_cast(tfm));
-
+		skcipher_request_set_tfm(subreq, ctx->u.aes.tfm_skcipher);
+		skcipher_request_set_callback(subreq, req->base.flags,
+					      NULL, NULL);
+		skcipher_request_set_crypt(subreq, req->src, req->dst,
+					   req->nbytes, req->info);
+		ret = encrypt ? crypto_skcipher_encrypt(subreq) :
+				crypto_skcipher_decrypt(subreq);
+		skcipher_request_zero(subreq);
 		return ret;
 	}
 
@@ -192,23 +193,21 @@ static int ccp_aes_xts_decrypt(struct ablkcipher_request *req)
 static int ccp_aes_xts_cra_init(struct crypto_tfm *tfm)
 {
 	struct ccp_ctx *ctx = crypto_tfm_ctx(tfm);
-	struct crypto_ablkcipher *fallback_tfm;
+	struct crypto_skcipher *fallback_tfm;
 
 	ctx->complete = ccp_aes_xts_complete;
 	ctx->u.aes.key_len = 0;
 
-	fallback_tfm = crypto_alloc_ablkcipher(crypto_tfm_alg_name(tfm), 0,
-					       CRYPTO_ALG_ASYNC |
-					       CRYPTO_ALG_NEED_FALLBACK);
+	fallback_tfm = crypto_alloc_skcipher("xts(aes)", 0,
+					     CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_FALLBACK);
 	if (IS_ERR(fallback_tfm)) {
-		pr_warn("could not load fallback driver %s\n",
-			crypto_tfm_alg_name(tfm));
+		pr_warn("could not load fallback driver xts(aes)\n");
 		return PTR_ERR(fallback_tfm);
 	}
-	ctx->u.aes.tfm_ablkcipher = fallback_tfm;
+	ctx->u.aes.tfm_skcipher = fallback_tfm;
 
-	tfm->crt_ablkcipher.reqsize = sizeof(struct ccp_aes_req_ctx) +
-				      fallback_tfm->base.crt_ablkcipher.reqsize;
+	tfm->crt_ablkcipher.reqsize = sizeof(struct ccp_aes_req_ctx);
 
 	return 0;
 }
@@ -217,9 +216,7 @@ static void ccp_aes_xts_cra_exit(struct crypto_tfm *tfm)
 {
 	struct ccp_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	if (ctx->u.aes.tfm_ablkcipher)
-		crypto_free_ablkcipher(ctx->u.aes.tfm_ablkcipher);
-	ctx->u.aes.tfm_ablkcipher = NULL;
+	crypto_free_skcipher(ctx->u.aes.tfm_skcipher);
 }
 
 static int ccp_register_aes_xts_alg(struct list_head *head,
diff --git a/drivers/crypto/ccp/ccp-crypto.h b/drivers/crypto/ccp/ccp-crypto.h
index a326ec2..8335b32 100644
--- a/drivers/crypto/ccp/ccp-crypto.h
+++ b/drivers/crypto/ccp/ccp-crypto.h
@@ -17,7 +17,6 @@
 #include <linux/wait.h>
 #include <linux/pci.h>
 #include <linux/ccp.h>
-#include <linux/crypto.h>
 #include <crypto/algapi.h>
 #include <crypto/aes.h>
 #include <crypto/ctr.h>
@@ -69,7 +68,7 @@ static inline struct ccp_crypto_ahash_alg *
 /***** AES related defines *****/
 struct ccp_aes_ctx {
 	/* Fallback cipher for XTS with unsupported unit sizes */
-	struct crypto_ablkcipher *tfm_ablkcipher;
+	struct crypto_skcipher *tfm_skcipher;
 
 	/* Cipher used to generate CMAC K1/K2 keys */
 	struct crypto_cipher *tfm_cipher;
