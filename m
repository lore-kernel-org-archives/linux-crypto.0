From: Kees Cook <keescook@chromium.org>
Subject: [PATCH crypto-next 20/23] crypto: mxs-dcp - Remove VLA usage of skcipher
Date: Tue, 18 Sep 2018 19:10:57 -0700
Message-ID: <20180919021100.3380-21-keescook@chromium.org>
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
 drivers/crypto/mxs-dcp.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
index a10c418d4e5c..430174be6f92 100644
--- a/drivers/crypto/mxs-dcp.c
+++ b/drivers/crypto/mxs-dcp.c
@@ -84,7 +84,7 @@ struct dcp_async_ctx {
 	unsigned int			hot:1;
 
 	/* Crypto-specific context */
-	struct crypto_skcipher		*fallback;
+	struct crypto_sync_skcipher	*fallback;
 	unsigned int			key_len;
 	uint8_t				key[AES_KEYSIZE_128];
 };
@@ -376,10 +376,10 @@ static int mxs_dcp_block_fallback(struct ablkcipher_request *req, int enc)
 {
 	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(req);
 	struct dcp_async_ctx *ctx = crypto_ablkcipher_ctx(tfm);
-	SKCIPHER_REQUEST_ON_STACK(subreq, ctx->fallback);
+	SYNC_SKCIPHER_REQUEST_ON_STACK(subreq, ctx->fallback);
 	int ret;
 
-	skcipher_request_set_tfm(subreq, ctx->fallback);
+	skcipher_request_set_sync_tfm(subreq, ctx->fallback);
 	skcipher_request_set_callback(subreq, req->base.flags, NULL, NULL);
 	skcipher_request_set_crypt(subreq, req->src, req->dst,
 				   req->nbytes, req->info);
@@ -460,16 +460,16 @@ static int mxs_dcp_aes_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 	 * but is supported by in-kernel software implementation, we use
 	 * software fallback.
 	 */
-	crypto_skcipher_clear_flags(actx->fallback, CRYPTO_TFM_REQ_MASK);
-	crypto_skcipher_set_flags(actx->fallback,
+	crypto_sync_skcipher_clear_flags(actx->fallback, CRYPTO_TFM_REQ_MASK);
+	crypto_sync_skcipher_set_flags(actx->fallback,
 				  tfm->base.crt_flags & CRYPTO_TFM_REQ_MASK);
 
-	ret = crypto_skcipher_setkey(actx->fallback, key, len);
+	ret = crypto_sync_skcipher_setkey(actx->fallback, key, len);
 	if (!ret)
 		return 0;
 
 	tfm->base.crt_flags &= ~CRYPTO_TFM_RES_MASK;
-	tfm->base.crt_flags |= crypto_skcipher_get_flags(actx->fallback) &
+	tfm->base.crt_flags |= crypto_sync_skcipher_get_flags(actx->fallback) &
 			       CRYPTO_TFM_RES_MASK;
 
 	return ret;
@@ -478,11 +478,10 @@ static int mxs_dcp_aes_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 static int mxs_dcp_aes_fallback_init(struct crypto_tfm *tfm)
 {
 	const char *name = crypto_tfm_alg_name(tfm);
-	const uint32_t flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK;
 	struct dcp_async_ctx *actx = crypto_tfm_ctx(tfm);
-	struct crypto_skcipher *blk;
+	struct crypto_sync_skcipher *blk;
 
-	blk = crypto_alloc_skcipher(name, 0, flags);
+	blk = crypto_alloc_sync_skcipher(name, 0, CRYPTO_ALG_NEED_FALLBACK);
 	if (IS_ERR(blk))
 		return PTR_ERR(blk);
 
@@ -495,7 +494,7 @@ static void mxs_dcp_aes_fallback_exit(struct crypto_tfm *tfm)
 {
 	struct dcp_async_ctx *actx = crypto_tfm_ctx(tfm);
 
-	crypto_free_skcipher(actx->fallback);
+	crypto_free_sync_skcipher(actx->fallback);
 }
 
 /*
-- 
2.17.1
