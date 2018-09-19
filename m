From: Kees Cook <keescook@chromium.org>
Subject: [PATCH crypto-next 06/23] x86/fpu: Remove VLA usage of skcipher
Date: Tue, 18 Sep 2018 19:10:43 -0700
Message-ID: <20180919021100.3380-7-keescook@chromium.org>
References: <20180919021100.3380-1-keescook@chromium.org>
Cc: Kees Cook <keescook@chromium.org>, x86@kernel.org,
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

Cc: x86@kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/crypto/fpu.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/arch/x86/crypto/fpu.c b/arch/x86/crypto/fpu.c
index 406680476c52..be9b3766f241 100644
--- a/arch/x86/crypto/fpu.c
+++ b/arch/x86/crypto/fpu.c
@@ -20,21 +20,23 @@
 #include <asm/fpu/api.h>
 
 struct crypto_fpu_ctx {
-	struct crypto_skcipher *child;
+	struct crypto_sync_skcipher *child;
 };
 
 static int crypto_fpu_setkey(struct crypto_skcipher *parent, const u8 *key,
 			     unsigned int keylen)
 {
 	struct crypto_fpu_ctx *ctx = crypto_skcipher_ctx(parent);
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
@@ -43,11 +45,11 @@ static int crypto_fpu_encrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct crypto_fpu_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct crypto_skcipher *child = ctx->child;
-	SKCIPHER_REQUEST_ON_STACK(subreq, child);
+	struct crypto_sync_skcipher *child = ctx->child;
+	SYNC_SKCIPHER_REQUEST_ON_STACK(subreq, child);
 	int err;
 
-	skcipher_request_set_tfm(subreq, child);
+	skcipher_request_set_sync_tfm(subreq, child);
 	skcipher_request_set_callback(subreq, 0, NULL, NULL);
 	skcipher_request_set_crypt(subreq, req->src, req->dst, req->cryptlen,
 				   req->iv);
@@ -64,11 +66,11 @@ static int crypto_fpu_decrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct crypto_fpu_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct crypto_skcipher *child = ctx->child;
-	SKCIPHER_REQUEST_ON_STACK(subreq, child);
+	struct crypto_sync_skcipher *child = ctx->child;
+	SYNC_SKCIPHER_REQUEST_ON_STACK(subreq, child);
 	int err;
 
-	skcipher_request_set_tfm(subreq, child);
+	skcipher_request_set_sync_tfm(subreq, child);
 	skcipher_request_set_callback(subreq, 0, NULL, NULL);
 	skcipher_request_set_crypt(subreq, req->src, req->dst, req->cryptlen,
 				   req->iv);
@@ -93,7 +95,7 @@ static int crypto_fpu_init_tfm(struct crypto_skcipher *tfm)
 	if (IS_ERR(cipher))
 		return PTR_ERR(cipher);
 
-	ctx->child = cipher;
+	ctx->child = (struct crypto_sync_skcipher *)cipher;
 
 	return 0;
 }
@@ -102,7 +104,7 @@ static void crypto_fpu_exit_tfm(struct crypto_skcipher *tfm)
 {
 	struct crypto_fpu_ctx *ctx = crypto_skcipher_ctx(tfm);
 
-	crypto_free_skcipher(ctx->child);
+	crypto_free_sync_skcipher(ctx->child);
 }
 
 static void crypto_fpu_free(struct skcipher_instance *inst)
-- 
2.17.1
