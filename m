From: Kees Cook <keescook@chromium.org>
Subject: [PATCH crypto-next 19/23] crypto: chelsio - Remove VLA usage of skcipher
Date: Tue, 18 Sep 2018 19:10:56 -0700
Message-ID: <20180919021100.3380-20-keescook@chromium.org>
References: <20180919021100.3380-1-keescook@chromium.org>
Cc: Kees Cook <keescook@chromium.org>, Harsh Jain <harsh@chelsio.com>,
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

Cc: Harsh Jain <harsh@chelsio.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/crypto/chelsio/chcr_algo.c   | 27 ++++++++++++++-------------
 drivers/crypto/chelsio/chcr_crypto.h |  2 +-
 2 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index 5c539af8ed60..dfc3a10bb55b 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -671,7 +671,7 @@ static int chcr_sg_ent_in_wr(struct scatterlist *src,
 	return min(srclen, dstlen);
 }
 
-static int chcr_cipher_fallback(struct crypto_skcipher *cipher,
+static int chcr_cipher_fallback(struct crypto_sync_skcipher *cipher,
 				u32 flags,
 				struct scatterlist *src,
 				struct scatterlist *dst,
@@ -681,9 +681,9 @@ static int chcr_cipher_fallback(struct crypto_skcipher *cipher,
 {
 	int err;
 
-	SKCIPHER_REQUEST_ON_STACK(subreq, cipher);
+	SYNC_SKCIPHER_REQUEST_ON_STACK(subreq, cipher);
 
-	skcipher_request_set_tfm(subreq, cipher);
+	skcipher_request_set_sync_tfm(subreq, cipher);
 	skcipher_request_set_callback(subreq, flags, NULL, NULL);
 	skcipher_request_set_crypt(subreq, src, dst,
 				   nbytes, iv);
@@ -854,13 +854,14 @@ static int chcr_cipher_fallback_setkey(struct crypto_ablkcipher *cipher,
 	struct ablk_ctx *ablkctx = ABLK_CTX(c_ctx(cipher));
 	int err = 0;
 
-	crypto_skcipher_clear_flags(ablkctx->sw_cipher, CRYPTO_TFM_REQ_MASK);
-	crypto_skcipher_set_flags(ablkctx->sw_cipher, cipher->base.crt_flags &
-				  CRYPTO_TFM_REQ_MASK);
-	err = crypto_skcipher_setkey(ablkctx->sw_cipher, key, keylen);
+	crypto_sync_skcipher_clear_flags(ablkctx->sw_cipher,
+				CRYPTO_TFM_REQ_MASK);
+	crypto_sync_skcipher_set_flags(ablkctx->sw_cipher,
+				cipher->base.crt_flags & CRYPTO_TFM_REQ_MASK);
+	err = crypto_sync_skcipher_setkey(ablkctx->sw_cipher, key, keylen);
 	tfm->crt_flags &= ~CRYPTO_TFM_RES_MASK;
 	tfm->crt_flags |=
-		crypto_skcipher_get_flags(ablkctx->sw_cipher) &
+		crypto_sync_skcipher_get_flags(ablkctx->sw_cipher) &
 		CRYPTO_TFM_RES_MASK;
 	return err;
 }
@@ -1360,8 +1361,8 @@ static int chcr_cra_init(struct crypto_tfm *tfm)
 	struct chcr_context *ctx = crypto_tfm_ctx(tfm);
 	struct ablk_ctx *ablkctx = ABLK_CTX(ctx);
 
-	ablkctx->sw_cipher = crypto_alloc_skcipher(alg->cra_name, 0,
-				CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK);
+	ablkctx->sw_cipher = crypto_alloc_sync_skcipher(alg->cra_name, 0,
+				CRYPTO_ALG_NEED_FALLBACK);
 	if (IS_ERR(ablkctx->sw_cipher)) {
 		pr_err("failed to allocate fallback for %s\n", alg->cra_name);
 		return PTR_ERR(ablkctx->sw_cipher);
@@ -1390,8 +1391,8 @@ static int chcr_rfc3686_init(struct crypto_tfm *tfm)
 	/*RFC3686 initialises IV counter value to 1, rfc3686(ctr(aes))
 	 * cannot be used as fallback in chcr_handle_cipher_response
 	 */
-	ablkctx->sw_cipher = crypto_alloc_skcipher("ctr(aes)", 0,
-				CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK);
+	ablkctx->sw_cipher = crypto_alloc_sync_skcipher("ctr(aes)", 0,
+				CRYPTO_ALG_NEED_FALLBACK);
 	if (IS_ERR(ablkctx->sw_cipher)) {
 		pr_err("failed to allocate fallback for %s\n", alg->cra_name);
 		return PTR_ERR(ablkctx->sw_cipher);
@@ -1406,7 +1407,7 @@ static void chcr_cra_exit(struct crypto_tfm *tfm)
 	struct chcr_context *ctx = crypto_tfm_ctx(tfm);
 	struct ablk_ctx *ablkctx = ABLK_CTX(ctx);
 
-	crypto_free_skcipher(ablkctx->sw_cipher);
+	crypto_free_sync_skcipher(ablkctx->sw_cipher);
 	if (ablkctx->aes_generic)
 		crypto_free_cipher(ablkctx->aes_generic);
 }
diff --git a/drivers/crypto/chelsio/chcr_crypto.h b/drivers/crypto/chelsio/chcr_crypto.h
index 54835cb109e5..e26b72cfe4b6 100644
--- a/drivers/crypto/chelsio/chcr_crypto.h
+++ b/drivers/crypto/chelsio/chcr_crypto.h
@@ -170,7 +170,7 @@ static inline struct chcr_context *h_ctx(struct crypto_ahash *tfm)
 }
 
 struct ablk_ctx {
-	struct crypto_skcipher *sw_cipher;
+	struct crypto_sync_skcipher *sw_cipher;
 	struct crypto_cipher *aes_generic;
 	__be32 key_ctx_hdr;
 	unsigned int enckey_len;
-- 
2.17.1
