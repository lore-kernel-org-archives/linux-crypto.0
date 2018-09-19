From: Kees Cook <keescook@chromium.org>
Subject: [PATCH crypto-next 17/23] crypto: qce - Remove VLA usage of skcipher
Date: Tue, 18 Sep 2018 19:10:54 -0700
Message-ID: <20180919021100.3380-18-keescook@chromium.org>
References: <20180919021100.3380-1-keescook@chromium.org>
Cc: Kees Cook <keescook@chromium.org>,
        Himanshu Jha <himanshujha199640@gmail.com>,
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

Cc: Himanshu Jha <himanshujha199640@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/crypto/qce/ablkcipher.c | 13 ++++++-------
 drivers/crypto/qce/cipher.h     |  2 +-
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/qce/ablkcipher.c b/drivers/crypto/qce/ablkcipher.c
index ea4d96bf47e8..585e1cab9ae3 100644
--- a/drivers/crypto/qce/ablkcipher.c
+++ b/drivers/crypto/qce/ablkcipher.c
@@ -189,7 +189,7 @@ static int qce_ablkcipher_setkey(struct crypto_ablkcipher *ablk, const u8 *key,
 	memcpy(ctx->enc_key, key, keylen);
 	return 0;
 fallback:
-	ret = crypto_skcipher_setkey(ctx->fallback, key, keylen);
+	ret = crypto_sync_skcipher_setkey(ctx->fallback, key, keylen);
 	if (!ret)
 		ctx->enc_keylen = keylen;
 	return ret;
@@ -212,9 +212,9 @@ static int qce_ablkcipher_crypt(struct ablkcipher_request *req, int encrypt)
 
 	if (IS_AES(rctx->flags) && ctx->enc_keylen != AES_KEYSIZE_128 &&
 	    ctx->enc_keylen != AES_KEYSIZE_256) {
-		SKCIPHER_REQUEST_ON_STACK(subreq, ctx->fallback);
+		SYNC_SKCIPHER_REQUEST_ON_STACK(subreq, ctx->fallback);
 
-		skcipher_request_set_tfm(subreq, ctx->fallback);
+		skcipher_request_set_sync_tfm(subreq, ctx->fallback);
 		skcipher_request_set_callback(subreq, req->base.flags,
 					      NULL, NULL);
 		skcipher_request_set_crypt(subreq, req->src, req->dst,
@@ -245,9 +245,8 @@ static int qce_ablkcipher_init(struct crypto_tfm *tfm)
 	memset(ctx, 0, sizeof(*ctx));
 	tfm->crt_ablkcipher.reqsize = sizeof(struct qce_cipher_reqctx);
 
-	ctx->fallback = crypto_alloc_skcipher(crypto_tfm_alg_name(tfm), 0,
-					      CRYPTO_ALG_ASYNC |
-					      CRYPTO_ALG_NEED_FALLBACK);
+	ctx->fallback = crypto_alloc_sync_skcipher(crypto_tfm_alg_name(tfm),
+						   0, CRYPTO_ALG_NEED_FALLBACK);
 	return PTR_ERR_OR_ZERO(ctx->fallback);
 }
 
@@ -255,7 +254,7 @@ static void qce_ablkcipher_exit(struct crypto_tfm *tfm)
 {
 	struct qce_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	crypto_free_skcipher(ctx->fallback);
+	crypto_free_sync_skcipher(ctx->fallback);
 }
 
 struct qce_ablkcipher_def {
diff --git a/drivers/crypto/qce/cipher.h b/drivers/crypto/qce/cipher.h
index 2b0278bb6e92..ee055bfe98a0 100644
--- a/drivers/crypto/qce/cipher.h
+++ b/drivers/crypto/qce/cipher.h
@@ -22,7 +22,7 @@
 struct qce_cipher_ctx {
 	u8 enc_key[QCE_MAX_KEY_SIZE];
 	unsigned int enc_keylen;
-	struct crypto_skcipher *fallback;
+	struct crypto_sync_skcipher *fallback;
 };
 
 /**
-- 
2.17.1
