From: Kees Cook <keescook@chromium.org>
Subject: [PATCH crypto-next 15/23] crypto: cryptd - Remove VLA usage of skcipher
Date: Tue, 18 Sep 2018 19:10:52 -0700
Message-ID: <20180919021100.3380-16-keescook@chromium.org>
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
 crypto/cryptd.c | 32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index addca7bae33f..7118fb5efbaa 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -76,7 +76,7 @@ struct cryptd_blkcipher_request_ctx {
 
 struct cryptd_skcipher_ctx {
 	atomic_t refcnt;
-	struct crypto_skcipher *child;
+	struct crypto_sync_skcipher *child;
 };
 
 struct cryptd_skcipher_request_ctx {
@@ -449,14 +449,16 @@ static int cryptd_skcipher_setkey(struct crypto_skcipher *parent,
 				  const u8 *key, unsigned int keylen)
 {
 	struct cryptd_skcipher_ctx *ctx = crypto_skcipher_ctx(parent);
-	struct crypto_skcipher *child = ctx->child;
+	struct crypto_sync_skcipher *child = ctx->child;
 	int err;
 
-	crypto_skcipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
-	crypto_skcipher_set_flags(child, crypto_skcipher_get_flags(parent) &
+	crypto_sync_skcipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
+	crypto_sync_skcipher_set_flags(child,
+				       crypto_skcipher_get_flags(parent) &
 					 CRYPTO_TFM_REQ_MASK);
-	err = crypto_skcipher_setkey(child, key, keylen);
-	crypto_skcipher_set_flags(parent, crypto_skcipher_get_flags(child) &
+	err = crypto_sync_skcipher_setkey(child, key, keylen);
+	crypto_skcipher_set_flags(parent,
+				  crypto_sync_skcipher_get_flags(child) &
 					  CRYPTO_TFM_RES_MASK);
 	return err;
 }
@@ -483,13 +485,13 @@ static void cryptd_skcipher_encrypt(struct crypto_async_request *base,
 	struct cryptd_skcipher_request_ctx *rctx = skcipher_request_ctx(req);
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct cryptd_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct crypto_skcipher *child = ctx->child;
-	SKCIPHER_REQUEST_ON_STACK(subreq, child);
+	struct crypto_sync_skcipher *child = ctx->child;
+	SYNC_SKCIPHER_REQUEST_ON_STACK(subreq, child);
 
 	if (unlikely(err == -EINPROGRESS))
 		goto out;
 
-	skcipher_request_set_tfm(subreq, child);
+	skcipher_request_set_sync_tfm(subreq, child);
 	skcipher_request_set_callback(subreq, CRYPTO_TFM_REQ_MAY_SLEEP,
 				      NULL, NULL);
 	skcipher_request_set_crypt(subreq, req->src, req->dst, req->cryptlen,
@@ -511,13 +513,13 @@ static void cryptd_skcipher_decrypt(struct crypto_async_request *base,
 	struct cryptd_skcipher_request_ctx *rctx = skcipher_request_ctx(req);
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct cryptd_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct crypto_skcipher *child = ctx->child;
-	SKCIPHER_REQUEST_ON_STACK(subreq, child);
+	struct crypto_sync_skcipher *child = ctx->child;
+	SYNC_SKCIPHER_REQUEST_ON_STACK(subreq, child);
 
 	if (unlikely(err == -EINPROGRESS))
 		goto out;
 
-	skcipher_request_set_tfm(subreq, child);
+	skcipher_request_set_sync_tfm(subreq, child);
 	skcipher_request_set_callback(subreq, CRYPTO_TFM_REQ_MAY_SLEEP,
 				      NULL, NULL);
 	skcipher_request_set_crypt(subreq, req->src, req->dst, req->cryptlen,
@@ -568,7 +570,7 @@ static int cryptd_skcipher_init_tfm(struct crypto_skcipher *tfm)
 	if (IS_ERR(cipher))
 		return PTR_ERR(cipher);
 
-	ctx->child = cipher;
+	ctx->child = (struct crypto_sync_skcipher *)cipher;
 	crypto_skcipher_set_reqsize(
 		tfm, sizeof(struct cryptd_skcipher_request_ctx));
 	return 0;
@@ -578,7 +580,7 @@ static void cryptd_skcipher_exit_tfm(struct crypto_skcipher *tfm)
 {
 	struct cryptd_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
 
-	crypto_free_skcipher(ctx->child);
+	crypto_free_sync_skcipher(ctx->child);
 }
 
 static void cryptd_skcipher_free(struct skcipher_instance *inst)
@@ -1243,7 +1245,7 @@ struct crypto_skcipher *cryptd_skcipher_child(struct cryptd_skcipher *tfm)
 {
 	struct cryptd_skcipher_ctx *ctx = crypto_skcipher_ctx(&tfm->base);
 
-	return ctx->child;
+	return &ctx->child->base;
 }
 EXPORT_SYMBOL_GPL(cryptd_skcipher_child);
 
-- 
2.17.1
