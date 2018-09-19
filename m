From: Kees Cook <keescook@chromium.org>
Subject: [PATCH crypto-next 13/23] crypto: vmx - Remove VLA usage of skcipher
Date: Tue, 18 Sep 2018 19:10:50 -0700
Message-ID: <20180919021100.3380-14-keescook@chromium.org>
References: <20180919021100.3380-1-keescook@chromium.org>
Cc: Kees Cook <keescook@chromium.org>,
        "Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>,
        Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org,
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

Cc: "Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>
Cc: Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: linuxppc-dev@lists.ozlabs.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/crypto/vmx/aes_cbc.c | 22 +++++++++++-----------
 drivers/crypto/vmx/aes_ctr.c | 18 +++++++++---------
 drivers/crypto/vmx/aes_xts.c | 18 +++++++++---------
 3 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/drivers/crypto/vmx/aes_cbc.c b/drivers/crypto/vmx/aes_cbc.c
index b71895871be3..c5c5ff82b52e 100644
--- a/drivers/crypto/vmx/aes_cbc.c
+++ b/drivers/crypto/vmx/aes_cbc.c
@@ -32,7 +32,7 @@
 #include "aesp8-ppc.h"
 
 struct p8_aes_cbc_ctx {
-	struct crypto_skcipher *fallback;
+	struct crypto_sync_skcipher *fallback;
 	struct aes_key enc_key;
 	struct aes_key dec_key;
 };
@@ -40,11 +40,11 @@ struct p8_aes_cbc_ctx {
 static int p8_aes_cbc_init(struct crypto_tfm *tfm)
 {
 	const char *alg = crypto_tfm_alg_name(tfm);
-	struct crypto_skcipher *fallback;
+	struct crypto_sync_skcipher *fallback;
 	struct p8_aes_cbc_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	fallback = crypto_alloc_skcipher(alg, 0,
-			CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK);
+	fallback = crypto_alloc_sync_skcipher(alg, 0,
+					      CRYPTO_ALG_NEED_FALLBACK);
 
 	if (IS_ERR(fallback)) {
 		printk(KERN_ERR
@@ -53,7 +53,7 @@ static int p8_aes_cbc_init(struct crypto_tfm *tfm)
 		return PTR_ERR(fallback);
 	}
 
-	crypto_skcipher_set_flags(
+	crypto_sync_skcipher_set_flags(
 		fallback,
 		crypto_skcipher_get_flags((struct crypto_skcipher *)tfm));
 	ctx->fallback = fallback;
@@ -66,7 +66,7 @@ static void p8_aes_cbc_exit(struct crypto_tfm *tfm)
 	struct p8_aes_cbc_ctx *ctx = crypto_tfm_ctx(tfm);
 
 	if (ctx->fallback) {
-		crypto_free_skcipher(ctx->fallback);
+		crypto_free_sync_skcipher(ctx->fallback);
 		ctx->fallback = NULL;
 	}
 }
@@ -86,7 +86,7 @@ static int p8_aes_cbc_setkey(struct crypto_tfm *tfm, const u8 *key,
 	pagefault_enable();
 	preempt_enable();
 
-	ret += crypto_skcipher_setkey(ctx->fallback, key, keylen);
+	ret += crypto_sync_skcipher_setkey(ctx->fallback, key, keylen);
 	return ret;
 }
 
@@ -100,8 +100,8 @@ static int p8_aes_cbc_encrypt(struct blkcipher_desc *desc,
 		crypto_tfm_ctx(crypto_blkcipher_tfm(desc->tfm));
 
 	if (in_interrupt()) {
-		SKCIPHER_REQUEST_ON_STACK(req, ctx->fallback);
-		skcipher_request_set_tfm(req, ctx->fallback);
+		SYNC_SKCIPHER_REQUEST_ON_STACK(req, ctx->fallback);
+		skcipher_request_set_sync_tfm(req, ctx->fallback);
 		skcipher_request_set_callback(req, desc->flags, NULL, NULL);
 		skcipher_request_set_crypt(req, src, dst, nbytes, desc->info);
 		ret = crypto_skcipher_encrypt(req);
@@ -139,8 +139,8 @@ static int p8_aes_cbc_decrypt(struct blkcipher_desc *desc,
 		crypto_tfm_ctx(crypto_blkcipher_tfm(desc->tfm));
 
 	if (in_interrupt()) {
-		SKCIPHER_REQUEST_ON_STACK(req, ctx->fallback);
-		skcipher_request_set_tfm(req, ctx->fallback);
+		SYNC_SKCIPHER_REQUEST_ON_STACK(req, ctx->fallback);
+		skcipher_request_set_sync_tfm(req, ctx->fallback);
 		skcipher_request_set_callback(req, desc->flags, NULL, NULL);
 		skcipher_request_set_crypt(req, src, dst, nbytes, desc->info);
 		ret = crypto_skcipher_decrypt(req);
diff --git a/drivers/crypto/vmx/aes_ctr.c b/drivers/crypto/vmx/aes_ctr.c
index cd777c75291d..8a2fe092cb8e 100644
--- a/drivers/crypto/vmx/aes_ctr.c
+++ b/drivers/crypto/vmx/aes_ctr.c
@@ -32,18 +32,18 @@
 #include "aesp8-ppc.h"
 
 struct p8_aes_ctr_ctx {
-	struct crypto_skcipher *fallback;
+	struct crypto_sync_skcipher *fallback;
 	struct aes_key enc_key;
 };
 
 static int p8_aes_ctr_init(struct crypto_tfm *tfm)
 {
 	const char *alg = crypto_tfm_alg_name(tfm);
-	struct crypto_skcipher *fallback;
+	struct crypto_sync_skcipher *fallback;
 	struct p8_aes_ctr_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	fallback = crypto_alloc_skcipher(alg, 0,
-			CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK);
+	fallback = crypto_alloc_sync_skcipher(alg, 0,
+					      CRYPTO_ALG_NEED_FALLBACK);
 	if (IS_ERR(fallback)) {
 		printk(KERN_ERR
 		       "Failed to allocate transformation for '%s': %ld\n",
@@ -51,7 +51,7 @@ static int p8_aes_ctr_init(struct crypto_tfm *tfm)
 		return PTR_ERR(fallback);
 	}
 
-	crypto_skcipher_set_flags(
+	crypto_sync_skcipher_set_flags(
 		fallback,
 		crypto_skcipher_get_flags((struct crypto_skcipher *)tfm));
 	ctx->fallback = fallback;
@@ -64,7 +64,7 @@ static void p8_aes_ctr_exit(struct crypto_tfm *tfm)
 	struct p8_aes_ctr_ctx *ctx = crypto_tfm_ctx(tfm);
 
 	if (ctx->fallback) {
-		crypto_free_skcipher(ctx->fallback);
+		crypto_free_sync_skcipher(ctx->fallback);
 		ctx->fallback = NULL;
 	}
 }
@@ -83,7 +83,7 @@ static int p8_aes_ctr_setkey(struct crypto_tfm *tfm, const u8 *key,
 	pagefault_enable();
 	preempt_enable();
 
-	ret += crypto_skcipher_setkey(ctx->fallback, key, keylen);
+	ret += crypto_sync_skcipher_setkey(ctx->fallback, key, keylen);
 	return ret;
 }
 
@@ -119,8 +119,8 @@ static int p8_aes_ctr_crypt(struct blkcipher_desc *desc,
 		crypto_tfm_ctx(crypto_blkcipher_tfm(desc->tfm));
 
 	if (in_interrupt()) {
-		SKCIPHER_REQUEST_ON_STACK(req, ctx->fallback);
-		skcipher_request_set_tfm(req, ctx->fallback);
+		SYNC_SKCIPHER_REQUEST_ON_STACK(req, ctx->fallback);
+		skcipher_request_set_sync_tfm(req, ctx->fallback);
 		skcipher_request_set_callback(req, desc->flags, NULL, NULL);
 		skcipher_request_set_crypt(req, src, dst, nbytes, desc->info);
 		ret = crypto_skcipher_encrypt(req);
diff --git a/drivers/crypto/vmx/aes_xts.c b/drivers/crypto/vmx/aes_xts.c
index e9954a7d4694..ecd64e5cc5bb 100644
--- a/drivers/crypto/vmx/aes_xts.c
+++ b/drivers/crypto/vmx/aes_xts.c
@@ -33,7 +33,7 @@
 #include "aesp8-ppc.h"
 
 struct p8_aes_xts_ctx {
-	struct crypto_skcipher *fallback;
+	struct crypto_sync_skcipher *fallback;
 	struct aes_key enc_key;
 	struct aes_key dec_key;
 	struct aes_key tweak_key;
@@ -42,11 +42,11 @@ struct p8_aes_xts_ctx {
 static int p8_aes_xts_init(struct crypto_tfm *tfm)
 {
 	const char *alg = crypto_tfm_alg_name(tfm);
-	struct crypto_skcipher *fallback;
+	struct crypto_sync_skcipher *fallback;
 	struct p8_aes_xts_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	fallback = crypto_alloc_skcipher(alg, 0,
-			CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK);
+	fallback = crypto_alloc_sync_skcipher(alg, 0,
+					      CRYPTO_ALG_NEED_FALLBACK);
 	if (IS_ERR(fallback)) {
 		printk(KERN_ERR
 			"Failed to allocate transformation for '%s': %ld\n",
@@ -54,7 +54,7 @@ static int p8_aes_xts_init(struct crypto_tfm *tfm)
 		return PTR_ERR(fallback);
 	}
 
-	crypto_skcipher_set_flags(
+	crypto_sync_skcipher_set_flags(
 		fallback,
 		crypto_skcipher_get_flags((struct crypto_skcipher *)tfm));
 	ctx->fallback = fallback;
@@ -67,7 +67,7 @@ static void p8_aes_xts_exit(struct crypto_tfm *tfm)
 	struct p8_aes_xts_ctx *ctx = crypto_tfm_ctx(tfm);
 
 	if (ctx->fallback) {
-		crypto_free_skcipher(ctx->fallback);
+		crypto_free_sync_skcipher(ctx->fallback);
 		ctx->fallback = NULL;
 	}
 }
@@ -92,7 +92,7 @@ static int p8_aes_xts_setkey(struct crypto_tfm *tfm, const u8 *key,
 	pagefault_enable();
 	preempt_enable();
 
-	ret += crypto_skcipher_setkey(ctx->fallback, key, keylen);
+	ret += crypto_sync_skcipher_setkey(ctx->fallback, key, keylen);
 	return ret;
 }
 
@@ -109,8 +109,8 @@ static int p8_aes_xts_crypt(struct blkcipher_desc *desc,
 		crypto_tfm_ctx(crypto_blkcipher_tfm(desc->tfm));
 
 	if (in_interrupt()) {
-		SKCIPHER_REQUEST_ON_STACK(req, ctx->fallback);
-		skcipher_request_set_tfm(req, ctx->fallback);
+		SYNC_SKCIPHER_REQUEST_ON_STACK(req, ctx->fallback);
+		skcipher_request_set_sync_tfm(req, ctx->fallback);
 		skcipher_request_set_callback(req, desc->flags, NULL, NULL);
 		skcipher_request_set_crypt(req, src, dst, nbytes, desc->info);
 		ret = enc? crypto_skcipher_encrypt(req) : crypto_skcipher_decrypt(req);
-- 
2.17.1
