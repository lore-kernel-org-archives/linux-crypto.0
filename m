From: Kees Cook <keescook@chromium.org>
Subject: [PATCH crypto-next 21/23] crypto: omap-aes - Remove VLA usage of skcipher
Date: Tue, 18 Sep 2018 19:10:58 -0700
Message-ID: <20180919021100.3380-22-keescook@chromium.org>
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
 drivers/crypto/omap-aes.c | 17 ++++++++---------
 drivers/crypto/omap-aes.h |  2 +-
 2 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index 9019f6b67986..a553ffddb11b 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -522,9 +522,9 @@ static int omap_aes_crypt(struct ablkcipher_request *req, unsigned long mode)
 		  !!(mode & FLAGS_CBC));
 
 	if (req->nbytes < aes_fallback_sz) {
-		SKCIPHER_REQUEST_ON_STACK(subreq, ctx->fallback);
+		SYNC_SKCIPHER_REQUEST_ON_STACK(subreq, ctx->fallback);
 
-		skcipher_request_set_tfm(subreq, ctx->fallback);
+		skcipher_request_set_sync_tfm(subreq, ctx->fallback);
 		skcipher_request_set_callback(subreq, req->base.flags, NULL,
 					      NULL);
 		skcipher_request_set_crypt(subreq, req->src, req->dst,
@@ -564,11 +564,11 @@ static int omap_aes_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 	memcpy(ctx->key, key, keylen);
 	ctx->keylen = keylen;
 
-	crypto_skcipher_clear_flags(ctx->fallback, CRYPTO_TFM_REQ_MASK);
-	crypto_skcipher_set_flags(ctx->fallback, tfm->base.crt_flags &
+	crypto_sync_skcipher_clear_flags(ctx->fallback, CRYPTO_TFM_REQ_MASK);
+	crypto_sync_skcipher_set_flags(ctx->fallback, tfm->base.crt_flags &
 						 CRYPTO_TFM_REQ_MASK);
 
-	ret = crypto_skcipher_setkey(ctx->fallback, key, keylen);
+	ret = crypto_sync_skcipher_setkey(ctx->fallback, key, keylen);
 	if (!ret)
 		return 0;
 
@@ -613,11 +613,10 @@ static int omap_aes_crypt_req(struct crypto_engine *engine,
 static int omap_aes_cra_init(struct crypto_tfm *tfm)
 {
 	const char *name = crypto_tfm_alg_name(tfm);
-	const u32 flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK;
 	struct omap_aes_ctx *ctx = crypto_tfm_ctx(tfm);
-	struct crypto_skcipher *blk;
+	struct crypto_sync_skcipher *blk;
 
-	blk = crypto_alloc_skcipher(name, 0, flags);
+	blk = crypto_alloc_sync_skcipher(name, 0, CRYPTO_ALG_NEED_FALLBACK);
 	if (IS_ERR(blk))
 		return PTR_ERR(blk);
 
@@ -667,7 +666,7 @@ static void omap_aes_cra_exit(struct crypto_tfm *tfm)
 	struct omap_aes_ctx *ctx = crypto_tfm_ctx(tfm);
 
 	if (ctx->fallback)
-		crypto_free_skcipher(ctx->fallback);
+		crypto_free_sync_skcipher(ctx->fallback);
 
 	ctx->fallback = NULL;
 }
diff --git a/drivers/crypto/omap-aes.h b/drivers/crypto/omap-aes.h
index fc3b46a85809..7e02920ef6f8 100644
--- a/drivers/crypto/omap-aes.h
+++ b/drivers/crypto/omap-aes.h
@@ -101,7 +101,7 @@ struct omap_aes_ctx {
 	int		keylen;
 	u32		key[AES_KEYSIZE_256 / sizeof(u32)];
 	u8		nonce[4];
-	struct crypto_skcipher	*fallback;
+	struct crypto_sync_skcipher	*fallback;
 	struct crypto_skcipher	*ctr;
 };
 
-- 
2.17.1
