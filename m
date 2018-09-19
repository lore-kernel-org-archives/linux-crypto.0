From: Kees Cook <keescook@chromium.org>
Subject: [PATCH crypto-next 16/23] crypto: sahara - Remove VLA usage of skcipher
Date: Tue, 18 Sep 2018 19:10:53 -0700
Message-ID: <20180919021100.3380-17-keescook@chromium.org>
References: <20180919021100.3380-1-keescook@chromium.org>
Cc: Kees Cook <keescook@chromium.org>,
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

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/crypto/sahara.c | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index e7540a5b8197..bbf166a97ad3 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -149,7 +149,7 @@ struct sahara_ctx {
 	/* AES-specific context */
 	int keylen;
 	u8 key[AES_KEYSIZE_128];
-	struct crypto_skcipher *fallback;
+	struct crypto_sync_skcipher *fallback;
 };
 
 struct sahara_aes_reqctx {
@@ -621,14 +621,14 @@ static int sahara_aes_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 	/*
 	 * The requested key size is not supported by HW, do a fallback.
 	 */
-	crypto_skcipher_clear_flags(ctx->fallback, CRYPTO_TFM_REQ_MASK);
-	crypto_skcipher_set_flags(ctx->fallback, tfm->base.crt_flags &
+	crypto_sync_skcipher_clear_flags(ctx->fallback, CRYPTO_TFM_REQ_MASK);
+	crypto_sync_skcipher_set_flags(ctx->fallback, tfm->base.crt_flags &
 						 CRYPTO_TFM_REQ_MASK);
 
-	ret = crypto_skcipher_setkey(ctx->fallback, key, keylen);
+	ret = crypto_sync_skcipher_setkey(ctx->fallback, key, keylen);
 
 	tfm->base.crt_flags &= ~CRYPTO_TFM_RES_MASK;
-	tfm->base.crt_flags |= crypto_skcipher_get_flags(ctx->fallback) &
+	tfm->base.crt_flags |= crypto_sync_skcipher_get_flags(ctx->fallback) &
 			       CRYPTO_TFM_RES_MASK;
 	return ret;
 }
@@ -666,9 +666,9 @@ static int sahara_aes_ecb_encrypt(struct ablkcipher_request *req)
 	int err;
 
 	if (unlikely(ctx->keylen != AES_KEYSIZE_128)) {
-		SKCIPHER_REQUEST_ON_STACK(subreq, ctx->fallback);
+		SYNC_SKCIPHER_REQUEST_ON_STACK(subreq, ctx->fallback);
 
-		skcipher_request_set_tfm(subreq, ctx->fallback);
+		skcipher_request_set_sync_tfm(subreq, ctx->fallback);
 		skcipher_request_set_callback(subreq, req->base.flags,
 					      NULL, NULL);
 		skcipher_request_set_crypt(subreq, req->src, req->dst,
@@ -688,9 +688,9 @@ static int sahara_aes_ecb_decrypt(struct ablkcipher_request *req)
 	int err;
 
 	if (unlikely(ctx->keylen != AES_KEYSIZE_128)) {
-		SKCIPHER_REQUEST_ON_STACK(subreq, ctx->fallback);
+		SYNC_SKCIPHER_REQUEST_ON_STACK(subreq, ctx->fallback);
 
-		skcipher_request_set_tfm(subreq, ctx->fallback);
+		skcipher_request_set_sync_tfm(subreq, ctx->fallback);
 		skcipher_request_set_callback(subreq, req->base.flags,
 					      NULL, NULL);
 		skcipher_request_set_crypt(subreq, req->src, req->dst,
@@ -710,9 +710,9 @@ static int sahara_aes_cbc_encrypt(struct ablkcipher_request *req)
 	int err;
 
 	if (unlikely(ctx->keylen != AES_KEYSIZE_128)) {
-		SKCIPHER_REQUEST_ON_STACK(subreq, ctx->fallback);
+		SYNC_SKCIPHER_REQUEST_ON_STACK(subreq, ctx->fallback);
 
-		skcipher_request_set_tfm(subreq, ctx->fallback);
+		skcipher_request_set_sync_tfm(subreq, ctx->fallback);
 		skcipher_request_set_callback(subreq, req->base.flags,
 					      NULL, NULL);
 		skcipher_request_set_crypt(subreq, req->src, req->dst,
@@ -732,9 +732,9 @@ static int sahara_aes_cbc_decrypt(struct ablkcipher_request *req)
 	int err;
 
 	if (unlikely(ctx->keylen != AES_KEYSIZE_128)) {
-		SKCIPHER_REQUEST_ON_STACK(subreq, ctx->fallback);
+		SYNC_SKCIPHER_REQUEST_ON_STACK(subreq, ctx->fallback);
 
-		skcipher_request_set_tfm(subreq, ctx->fallback);
+		skcipher_request_set_sync_tfm(subreq, ctx->fallback);
 		skcipher_request_set_callback(subreq, req->base.flags,
 					      NULL, NULL);
 		skcipher_request_set_crypt(subreq, req->src, req->dst,
@@ -752,8 +752,7 @@ static int sahara_aes_cra_init(struct crypto_tfm *tfm)
 	const char *name = crypto_tfm_alg_name(tfm);
 	struct sahara_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	ctx->fallback = crypto_alloc_skcipher(name, 0,
-					      CRYPTO_ALG_ASYNC |
+	ctx->fallback = crypto_alloc_sync_skcipher(name, 0,
 					      CRYPTO_ALG_NEED_FALLBACK);
 	if (IS_ERR(ctx->fallback)) {
 		pr_err("Error allocating fallback algo %s\n", name);
@@ -769,7 +768,7 @@ static void sahara_aes_cra_exit(struct crypto_tfm *tfm)
 {
 	struct sahara_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	crypto_free_skcipher(ctx->fallback);
+	crypto_free_sync_skcipher(ctx->fallback);
 }
 
 static u32 sahara_sha_init_hdr(struct sahara_dev *dev,
-- 
2.17.1
