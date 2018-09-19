From: Kees Cook <keescook@chromium.org>
Subject: [PATCH crypto-next 22/23] crypto: picoxcell - Remove VLA usage of skcipher
Date: Tue, 18 Sep 2018 19:10:59 -0700
Message-ID: <20180919021100.3380-23-keescook@chromium.org>
References: <20180919021100.3380-1-keescook@chromium.org>
Cc: Kees Cook <keescook@chromium.org>,
        Jamie Iles <jamie@jamieiles.com>,
        linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Biggers <ebiggers@google.com>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180919021100.3380-1-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

In the quest to remove all stack VLA usage from the kernel[1], this
replaces struct crypto_skcipher and SKCIPHER_REQUEST_ON_STACK() usage
with struct crypto_sync_skcipher and SYNC_SKCIPHER_REQUEST_ON_STACK(),
which uses a fixed stack size.

[1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com

Cc: Jamie Iles <jamie@jamieiles.com>
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/crypto/picoxcell_crypto.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/picoxcell_crypto.c b/drivers/crypto/picoxcell_crypto.c
index 321d5e2ac833..a28f1d18fe01 100644
--- a/drivers/crypto/picoxcell_crypto.c
+++ b/drivers/crypto/picoxcell_crypto.c
@@ -171,7 +171,7 @@ struct spacc_ablk_ctx {
 	 * The fallback cipher. If the operation can't be done in hardware,
 	 * fallback to a software version.
 	 */
-	struct crypto_skcipher		*sw_cipher;
+	struct crypto_sync_skcipher	*sw_cipher;
 };
 
 /* AEAD cipher context. */
@@ -799,17 +799,17 @@ static int spacc_aes_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 		 * Set the fallback transform to use the same request flags as
 		 * the hardware transform.
 		 */
-		crypto_skcipher_clear_flags(ctx->sw_cipher,
+		crypto_sync_skcipher_clear_flags(ctx->sw_cipher,
 					    CRYPTO_TFM_REQ_MASK);
-		crypto_skcipher_set_flags(ctx->sw_cipher,
+		crypto_sync_skcipher_set_flags(ctx->sw_cipher,
 					  cipher->base.crt_flags &
 					  CRYPTO_TFM_REQ_MASK);
 
-		err = crypto_skcipher_setkey(ctx->sw_cipher, key, len);
+		err = crypto_sync_skcipher_setkey(ctx->sw_cipher, key, len);
 
 		tfm->crt_flags &= ~CRYPTO_TFM_RES_MASK;
 		tfm->crt_flags |=
-			crypto_skcipher_get_flags(ctx->sw_cipher) &
+			crypto_sync_skcipher_get_flags(ctx->sw_cipher) &
 			CRYPTO_TFM_RES_MASK;
 
 		if (err)
@@ -914,7 +914,7 @@ static int spacc_ablk_do_fallback(struct ablkcipher_request *req,
 	struct crypto_tfm *old_tfm =
 	    crypto_ablkcipher_tfm(crypto_ablkcipher_reqtfm(req));
 	struct spacc_ablk_ctx *ctx = crypto_tfm_ctx(old_tfm);
-	SKCIPHER_REQUEST_ON_STACK(subreq, ctx->sw_cipher);
+	SYNC_SKCIPHER_REQUEST_ON_STACK(subreq, ctx->sw_cipher);
 	int err;
 
 	/*
@@ -922,7 +922,7 @@ static int spacc_ablk_do_fallback(struct ablkcipher_request *req,
 	 * the ciphering has completed, put the old transform back into the
 	 * request.
 	 */
-	skcipher_request_set_tfm(subreq, ctx->sw_cipher);
+	skcipher_request_set_sync_tfm(subreq, ctx->sw_cipher);
 	skcipher_request_set_callback(subreq, req->base.flags, NULL, NULL);
 	skcipher_request_set_crypt(subreq, req->src, req->dst,
 				   req->nbytes, req->info);
@@ -1020,9 +1020,8 @@ static int spacc_ablk_cra_init(struct crypto_tfm *tfm)
 	ctx->generic.flags = spacc_alg->type;
 	ctx->generic.engine = engine;
 	if (alg->cra_flags & CRYPTO_ALG_NEED_FALLBACK) {
-		ctx->sw_cipher = crypto_alloc_skcipher(
-			alg->cra_name, 0, CRYPTO_ALG_ASYNC |
-					  CRYPTO_ALG_NEED_FALLBACK);
+		ctx->sw_cipher = crypto_alloc_sync_skcipher(
+			alg->cra_name, 0, CRYPTO_ALG_NEED_FALLBACK);
 		if (IS_ERR(ctx->sw_cipher)) {
 			dev_warn(engine->dev, "failed to allocate fallback for %s\n",
 				 alg->cra_name);
@@ -1041,7 +1040,7 @@ static void spacc_ablk_cra_exit(struct crypto_tfm *tfm)
 {
 	struct spacc_ablk_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	crypto_free_skcipher(ctx->sw_cipher);
+	crypto_free_sync_skcipher(ctx->sw_cipher);
 }
 
 static int spacc_ablk_encrypt(struct ablkcipher_request *req)
-- 
2.17.1
