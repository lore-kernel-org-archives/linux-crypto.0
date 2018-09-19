From: Kees Cook <keescook@chromium.org>
Subject: [PATCH crypto-next 12/23] crypto: ccp - Remove VLA usage of skcipher
Date: Tue, 18 Sep 2018 19:10:49 -0700
Message-ID: <20180919021100.3380-13-keescook@chromium.org>
References: <20180919021100.3380-1-keescook@chromium.org>
Cc: Kees Cook <keescook@chromium.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
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

Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Gary Hook <gary.hook@amd.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/crypto/ccp/ccp-crypto-aes-xts.c | 13 +++++++------
 drivers/crypto/ccp/ccp-crypto.h         |  2 +-
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-aes-xts.c b/drivers/crypto/ccp/ccp-crypto-aes-xts.c
index 94b5bcf5b628..ca4630b8395f 100644
--- a/drivers/crypto/ccp/ccp-crypto-aes-xts.c
+++ b/drivers/crypto/ccp/ccp-crypto-aes-xts.c
@@ -102,7 +102,7 @@ static int ccp_aes_xts_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 	ctx->u.aes.key_len = key_len / 2;
 	sg_init_one(&ctx->u.aes.key_sg, ctx->u.aes.key, key_len);
 
-	return crypto_skcipher_setkey(ctx->u.aes.tfm_skcipher, key, key_len);
+	return crypto_sync_skcipher_setkey(ctx->u.aes.tfm_skcipher, key, key_len);
 }
 
 static int ccp_aes_xts_crypt(struct ablkcipher_request *req,
@@ -151,12 +151,13 @@ static int ccp_aes_xts_crypt(struct ablkcipher_request *req,
 	    (ctx->u.aes.key_len != AES_KEYSIZE_256))
 		fallback = 1;
 	if (fallback) {
-		SKCIPHER_REQUEST_ON_STACK(subreq, ctx->u.aes.tfm_skcipher);
+		SYNC_SKCIPHER_REQUEST_ON_STACK(subreq,
+					       ctx->u.aes.tfm_skcipher);
 
 		/* Use the fallback to process the request for any
 		 * unsupported unit sizes or key sizes
 		 */
-		skcipher_request_set_tfm(subreq, ctx->u.aes.tfm_skcipher);
+		skcipher_request_set_sync_tfm(subreq, ctx->u.aes.tfm_skcipher);
 		skcipher_request_set_callback(subreq, req->base.flags,
 					      NULL, NULL);
 		skcipher_request_set_crypt(subreq, req->src, req->dst,
@@ -203,12 +204,12 @@ static int ccp_aes_xts_decrypt(struct ablkcipher_request *req)
 static int ccp_aes_xts_cra_init(struct crypto_tfm *tfm)
 {
 	struct ccp_ctx *ctx = crypto_tfm_ctx(tfm);
-	struct crypto_skcipher *fallback_tfm;
+	struct crypto_sync_skcipher *fallback_tfm;
 
 	ctx->complete = ccp_aes_xts_complete;
 	ctx->u.aes.key_len = 0;
 
-	fallback_tfm = crypto_alloc_skcipher("xts(aes)", 0,
+	fallback_tfm = crypto_alloc_sync_skcipher("xts(aes)", 0,
 					     CRYPTO_ALG_ASYNC |
 					     CRYPTO_ALG_NEED_FALLBACK);
 	if (IS_ERR(fallback_tfm)) {
@@ -226,7 +227,7 @@ static void ccp_aes_xts_cra_exit(struct crypto_tfm *tfm)
 {
 	struct ccp_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	crypto_free_skcipher(ctx->u.aes.tfm_skcipher);
+	crypto_free_sync_skcipher(ctx->u.aes.tfm_skcipher);
 }
 
 static int ccp_register_aes_xts_alg(struct list_head *head,
diff --git a/drivers/crypto/ccp/ccp-crypto.h b/drivers/crypto/ccp/ccp-crypto.h
index b9fd090c46c2..28819e11db96 100644
--- a/drivers/crypto/ccp/ccp-crypto.h
+++ b/drivers/crypto/ccp/ccp-crypto.h
@@ -88,7 +88,7 @@ static inline struct ccp_crypto_ahash_alg *
 /***** AES related defines *****/
 struct ccp_aes_ctx {
 	/* Fallback cipher for XTS with unsupported unit sizes */
-	struct crypto_skcipher *tfm_skcipher;
+	struct crypto_sync_skcipher *tfm_skcipher;
 
 	/* Cipher used to generate CMAC K1/K2 keys */
 	struct crypto_cipher *tfm_cipher;
-- 
2.17.1
