From: Kees Cook <keescook@chromium.org>
Subject: [PATCH crypto-next 05/23] s390/crypto: Remove VLA usage of skcipher
Date: Tue, 18 Sep 2018 19:10:42 -0700
Message-ID: <20180919021100.3380-6-keescook@chromium.org>
References: <20180919021100.3380-1-keescook@chromium.org>
Cc: Kees Cook <keescook@chromium.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-s390@vger.kernel.org,
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

Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-s390@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/s390/crypto/aes_s390.c | 48 ++++++++++++++++++-------------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
index c54cb26eb7f5..812d9498d97b 100644
--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -44,7 +44,7 @@ struct s390_aes_ctx {
 	int key_len;
 	unsigned long fc;
 	union {
-		struct crypto_skcipher *blk;
+		struct crypto_sync_skcipher *blk;
 		struct crypto_cipher *cip;
 	} fallback;
 };
@@ -54,7 +54,7 @@ struct s390_xts_ctx {
 	u8 pcc_key[32];
 	int key_len;
 	unsigned long fc;
-	struct crypto_skcipher *fallback;
+	struct crypto_sync_skcipher *fallback;
 };
 
 struct gcm_sg_walk {
@@ -184,14 +184,15 @@ static int setkey_fallback_blk(struct crypto_tfm *tfm, const u8 *key,
 	struct s390_aes_ctx *sctx = crypto_tfm_ctx(tfm);
 	unsigned int ret;
 
-	crypto_skcipher_clear_flags(sctx->fallback.blk, CRYPTO_TFM_REQ_MASK);
-	crypto_skcipher_set_flags(sctx->fallback.blk, tfm->crt_flags &
+	crypto_sync_skcipher_clear_flags(sctx->fallback.blk,
+					 CRYPTO_TFM_REQ_MASK);
+	crypto_sync_skcipher_set_flags(sctx->fallback.blk, tfm->crt_flags &
 						      CRYPTO_TFM_REQ_MASK);
 
-	ret = crypto_skcipher_setkey(sctx->fallback.blk, key, len);
+	ret = crypto_sync_skcipher_setkey(sctx->fallback.blk, key, len);
 
 	tfm->crt_flags &= ~CRYPTO_TFM_RES_MASK;
-	tfm->crt_flags |= crypto_skcipher_get_flags(sctx->fallback.blk) &
+	tfm->crt_flags |= crypto_sync_skcipher_get_flags(sctx->fallback.blk) &
 			  CRYPTO_TFM_RES_MASK;
 
 	return ret;
@@ -204,9 +205,9 @@ static int fallback_blk_dec(struct blkcipher_desc *desc,
 	unsigned int ret;
 	struct crypto_blkcipher *tfm = desc->tfm;
 	struct s390_aes_ctx *sctx = crypto_blkcipher_ctx(tfm);
-	SKCIPHER_REQUEST_ON_STACK(req, sctx->fallback.blk);
+	SYNC_SKCIPHER_REQUEST_ON_STACK(req, sctx->fallback.blk);
 
-	skcipher_request_set_tfm(req, sctx->fallback.blk);
+	skcipher_request_set_sync_tfm(req, sctx->fallback.blk);
 	skcipher_request_set_callback(req, desc->flags, NULL, NULL);
 	skcipher_request_set_crypt(req, src, dst, nbytes, desc->info);
 
@@ -223,9 +224,9 @@ static int fallback_blk_enc(struct blkcipher_desc *desc,
 	unsigned int ret;
 	struct crypto_blkcipher *tfm = desc->tfm;
 	struct s390_aes_ctx *sctx = crypto_blkcipher_ctx(tfm);
-	SKCIPHER_REQUEST_ON_STACK(req, sctx->fallback.blk);
+	SYNC_SKCIPHER_REQUEST_ON_STACK(req, sctx->fallback.blk);
 
-	skcipher_request_set_tfm(req, sctx->fallback.blk);
+	skcipher_request_set_sync_tfm(req, sctx->fallback.blk);
 	skcipher_request_set_callback(req, desc->flags, NULL, NULL);
 	skcipher_request_set_crypt(req, src, dst, nbytes, desc->info);
 
@@ -306,8 +307,7 @@ static int fallback_init_blk(struct crypto_tfm *tfm)
 	const char *name = tfm->__crt_alg->cra_name;
 	struct s390_aes_ctx *sctx = crypto_tfm_ctx(tfm);
 
-	sctx->fallback.blk = crypto_alloc_skcipher(name, 0,
-						   CRYPTO_ALG_ASYNC |
+	sctx->fallback.blk = crypto_alloc_sync_skcipher(name, 0,
 						   CRYPTO_ALG_NEED_FALLBACK);
 
 	if (IS_ERR(sctx->fallback.blk)) {
@@ -323,7 +323,7 @@ static void fallback_exit_blk(struct crypto_tfm *tfm)
 {
 	struct s390_aes_ctx *sctx = crypto_tfm_ctx(tfm);
 
-	crypto_free_skcipher(sctx->fallback.blk);
+	crypto_free_sync_skcipher(sctx->fallback.blk);
 }
 
 static struct crypto_alg ecb_aes_alg = {
@@ -453,14 +453,15 @@ static int xts_fallback_setkey(struct crypto_tfm *tfm, const u8 *key,
 	struct s390_xts_ctx *xts_ctx = crypto_tfm_ctx(tfm);
 	unsigned int ret;
 
-	crypto_skcipher_clear_flags(xts_ctx->fallback, CRYPTO_TFM_REQ_MASK);
-	crypto_skcipher_set_flags(xts_ctx->fallback, tfm->crt_flags &
+	crypto_sync_skcipher_clear_flags(xts_ctx->fallback,
+					 CRYPTO_TFM_REQ_MASK);
+	crypto_sync_skcipher_set_flags(xts_ctx->fallback, tfm->crt_flags &
 						     CRYPTO_TFM_REQ_MASK);
 
-	ret = crypto_skcipher_setkey(xts_ctx->fallback, key, len);
+	ret = crypto_sync_skcipher_setkey(xts_ctx->fallback, key, len);
 
 	tfm->crt_flags &= ~CRYPTO_TFM_RES_MASK;
-	tfm->crt_flags |= crypto_skcipher_get_flags(xts_ctx->fallback) &
+	tfm->crt_flags |= crypto_sync_skcipher_get_flags(xts_ctx->fallback) &
 			  CRYPTO_TFM_RES_MASK;
 
 	return ret;
@@ -472,10 +473,10 @@ static int xts_fallback_decrypt(struct blkcipher_desc *desc,
 {
 	struct crypto_blkcipher *tfm = desc->tfm;
 	struct s390_xts_ctx *xts_ctx = crypto_blkcipher_ctx(tfm);
-	SKCIPHER_REQUEST_ON_STACK(req, xts_ctx->fallback);
+	SYNC_SKCIPHER_REQUEST_ON_STACK(req, xts_ctx->fallback);
 	unsigned int ret;
 
-	skcipher_request_set_tfm(req, xts_ctx->fallback);
+	skcipher_request_set_sync_tfm(req, xts_ctx->fallback);
 	skcipher_request_set_callback(req, desc->flags, NULL, NULL);
 	skcipher_request_set_crypt(req, src, dst, nbytes, desc->info);
 
@@ -491,10 +492,10 @@ static int xts_fallback_encrypt(struct blkcipher_desc *desc,
 {
 	struct crypto_blkcipher *tfm = desc->tfm;
 	struct s390_xts_ctx *xts_ctx = crypto_blkcipher_ctx(tfm);
-	SKCIPHER_REQUEST_ON_STACK(req, xts_ctx->fallback);
+	SYNC_SKCIPHER_REQUEST_ON_STACK(req, xts_ctx->fallback);
 	unsigned int ret;
 
-	skcipher_request_set_tfm(req, xts_ctx->fallback);
+	skcipher_request_set_sync_tfm(req, xts_ctx->fallback);
 	skcipher_request_set_callback(req, desc->flags, NULL, NULL);
 	skcipher_request_set_crypt(req, src, dst, nbytes, desc->info);
 
@@ -611,8 +612,7 @@ static int xts_fallback_init(struct crypto_tfm *tfm)
 	const char *name = tfm->__crt_alg->cra_name;
 	struct s390_xts_ctx *xts_ctx = crypto_tfm_ctx(tfm);
 
-	xts_ctx->fallback = crypto_alloc_skcipher(name, 0,
-						  CRYPTO_ALG_ASYNC |
+	xts_ctx->fallback = crypto_alloc_sync_skcipher(name, 0,
 						  CRYPTO_ALG_NEED_FALLBACK);
 
 	if (IS_ERR(xts_ctx->fallback)) {
@@ -627,7 +627,7 @@ static void xts_fallback_exit(struct crypto_tfm *tfm)
 {
 	struct s390_xts_ctx *xts_ctx = crypto_tfm_ctx(tfm);
 
-	crypto_free_skcipher(xts_ctx->fallback);
+	crypto_free_sync_skcipher(xts_ctx->fallback);
 }
 
 static struct crypto_alg xts_aes_alg = {
-- 
2.17.1
