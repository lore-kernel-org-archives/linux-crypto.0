From: Kees Cook <keescook@chromium.org>
Subject: [PATCH crypto-next 18/23] crypto: artpec6 - Remove VLA usage of skcipher
Date: Tue, 18 Sep 2018 19:10:55 -0700
Message-ID: <20180919021100.3380-19-keescook@chromium.org>
References: <20180919021100.3380-1-keescook@chromium.org>
Cc: Kees Cook <keescook@chromium.org>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Lars Persson <lars.persson@axis.com>,
        linux-arm-kernel@axis.com,
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

Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Lars Persson <lars.persson@axis.com>
Cc: linux-arm-kernel@axis.com
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/crypto/axis/artpec6_crypto.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/axis/artpec6_crypto.c b/drivers/crypto/axis/artpec6_crypto.c
index 7f07a5085e9b..e5a080e87ea8 100644
--- a/drivers/crypto/axis/artpec6_crypto.c
+++ b/drivers/crypto/axis/artpec6_crypto.c
@@ -330,7 +330,7 @@ struct artpec6_cryptotfm_context {
 	size_t key_length;
 	u32 key_md;
 	int crypto_type;
-	struct crypto_skcipher *fallback;
+	struct crypto_sync_skcipher *fallback;
 };
 
 struct artpec6_crypto_aead_hw_ctx {
@@ -1199,15 +1199,15 @@ artpec6_crypto_ctr_crypt(struct skcipher_request *req, bool encrypt)
 		pr_debug("counter %x will overflow (nblks %u), falling back\n",
 			 counter, counter + nblks);
 
-		ret = crypto_skcipher_setkey(ctx->fallback, ctx->aes_key,
-					     ctx->key_length);
+		ret = crypto_sync_skcipher_setkey(ctx->fallback, ctx->aes_key,
+						  ctx->key_length);
 		if (ret)
 			return ret;
 
 		{
-			SKCIPHER_REQUEST_ON_STACK(subreq, ctx->fallback);
+			SYNC_SKCIPHER_REQUEST_ON_STACK(subreq, ctx->fallback);
 
-			skcipher_request_set_tfm(subreq, ctx->fallback);
+			skcipher_request_set_sync_tfm(subreq, ctx->fallback);
 			skcipher_request_set_callback(subreq, req->base.flags,
 						      NULL, NULL);
 			skcipher_request_set_crypt(subreq, req->src, req->dst,
@@ -1561,10 +1561,9 @@ static int artpec6_crypto_aes_ctr_init(struct crypto_skcipher *tfm)
 {
 	struct artpec6_cryptotfm_context *ctx = crypto_skcipher_ctx(tfm);
 
-	ctx->fallback = crypto_alloc_skcipher(crypto_tfm_alg_name(&tfm->base),
-					      0,
-					      CRYPTO_ALG_ASYNC |
-					      CRYPTO_ALG_NEED_FALLBACK);
+	ctx->fallback =
+		crypto_alloc_sync_skcipher(crypto_tfm_alg_name(&tfm->base),
+					   0, CRYPTO_ALG_NEED_FALLBACK);
 	if (IS_ERR(ctx->fallback))
 		return PTR_ERR(ctx->fallback);
 
@@ -1605,7 +1604,7 @@ static void artpec6_crypto_aes_ctr_exit(struct crypto_skcipher *tfm)
 {
 	struct artpec6_cryptotfm_context *ctx = crypto_skcipher_ctx(tfm);
 
-	crypto_free_skcipher(ctx->fallback);
+	crypto_free_sync_skcipher(ctx->fallback);
 	artpec6_crypto_aes_exit(tfm);
 }
 
-- 
2.17.1
