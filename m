From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 03/11] crypto: aes_ni - change to use shared ablk_* functions
Date: Mon, 18 Jun 2012 14:07:08 +0300
Message-ID: <20120618110708.28985.66691.stgit@localhost6.localdomain6>
References: <20120618110652.28985.70075.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:50705 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab2FRLHN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 18 Jun 2012 07:07:13 -0400
In-Reply-To: <20120618110652.28985.70075.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Remove duplicate ablk_* functions and make use of ablk_helper module instead.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 arch/x86/crypto/ablk_helper.c             |   19 +++---
 arch/x86/crypto/aesni-intel_glue.c        |  100 ++---------------------------
 arch/x86/include/asm/crypto/ablk_helper.h |    2 +
 crypto/Kconfig                            |    1 
 4 files changed, 20 insertions(+), 102 deletions(-)

diff --git a/arch/x86/crypto/ablk_helper.c b/arch/x86/crypto/ablk_helper.c
index 284ca3b..43282fe 100644
--- a/arch/x86/crypto/ablk_helper.c
+++ b/arch/x86/crypto/ablk_helper.c
@@ -118,32 +118,31 @@ void ablk_exit(struct crypto_tfm *tfm)
 }
 EXPORT_SYMBOL_GPL(ablk_exit);
 
-void ablk_init_common(struct crypto_tfm *tfm,
-		      struct cryptd_ablkcipher *cryptd_tfm)
+int ablk_init_common(struct crypto_tfm *tfm, const char *drv_name)
 {
 	struct async_helper_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct cryptd_ablkcipher *cryptd_tfm;
+
+	cryptd_tfm = cryptd_alloc_ablkcipher(drv_name, 0, 0);
+	if (IS_ERR(cryptd_tfm))
+		return PTR_ERR(cryptd_tfm);
 
 	ctx->cryptd_tfm = cryptd_tfm;
 	tfm->crt_ablkcipher.reqsize = sizeof(struct ablkcipher_request) +
 		crypto_ablkcipher_reqsize(&cryptd_tfm->base);
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(ablk_init_common);
 
 int ablk_init(struct crypto_tfm *tfm)
 {
-	struct cryptd_ablkcipher *cryptd_tfm;
 	char drv_name[CRYPTO_MAX_ALG_NAME];
 
 	snprintf(drv_name, sizeof(drv_name), "__driver-%s",
 					crypto_tfm_alg_driver_name(tfm));
 
-	cryptd_tfm = cryptd_alloc_ablkcipher(drv_name, 0, 0);
-	if (IS_ERR(cryptd_tfm))
-		return PTR_ERR(cryptd_tfm);
-
-	ablk_init_common(tfm, cryptd_tfm);
-
-	return 0;
+	return ablk_init_common(tfm, drv_name);
 }
 EXPORT_SYMBOL_GPL(ablk_init);
 
diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index ac7f5cd..7c9d54d8 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -31,6 +31,7 @@
 #include <asm/cpu_device_id.h>
 #include <asm/i387.h>
 #include <asm/aes.h>
+#include <asm/crypto/ablk_helper.h>
 #include <crypto/scatterwalk.h>
 #include <crypto/internal/aead.h>
 #include <linux/workqueue.h>
@@ -52,10 +53,6 @@
 #define HAS_XTS
 #endif
 
-struct async_aes_ctx {
-	struct cryptd_ablkcipher *cryptd_tfm;
-};
-
 /* This data is stored at the end of the crypto_tfm struct.
  * It's a type of per "session" data storage location.
  * This needs to be 16 byte aligned.
@@ -377,87 +374,6 @@ static int ctr_crypt(struct blkcipher_desc *desc,
 }
 #endif
 
-static int ablk_set_key(struct crypto_ablkcipher *tfm, const u8 *key,
-			unsigned int key_len)
-{
-	struct async_aes_ctx *ctx = crypto_ablkcipher_ctx(tfm);
-	struct crypto_ablkcipher *child = &ctx->cryptd_tfm->base;
-	int err;
-
-	crypto_ablkcipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
-	crypto_ablkcipher_set_flags(child, crypto_ablkcipher_get_flags(tfm)
-				    & CRYPTO_TFM_REQ_MASK);
-	err = crypto_ablkcipher_setkey(child, key, key_len);
-	crypto_ablkcipher_set_flags(tfm, crypto_ablkcipher_get_flags(child)
-				    & CRYPTO_TFM_RES_MASK);
-	return err;
-}
-
-static int ablk_encrypt(struct ablkcipher_request *req)
-{
-	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(req);
-	struct async_aes_ctx *ctx = crypto_ablkcipher_ctx(tfm);
-
-	if (!irq_fpu_usable()) {
-		struct ablkcipher_request *cryptd_req =
-			ablkcipher_request_ctx(req);
-		memcpy(cryptd_req, req, sizeof(*req));
-		ablkcipher_request_set_tfm(cryptd_req, &ctx->cryptd_tfm->base);
-		return crypto_ablkcipher_encrypt(cryptd_req);
-	} else {
-		struct blkcipher_desc desc;
-		desc.tfm = cryptd_ablkcipher_child(ctx->cryptd_tfm);
-		desc.info = req->info;
-		desc.flags = 0;
-		return crypto_blkcipher_crt(desc.tfm)->encrypt(
-			&desc, req->dst, req->src, req->nbytes);
-	}
-}
-
-static int ablk_decrypt(struct ablkcipher_request *req)
-{
-	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(req);
-	struct async_aes_ctx *ctx = crypto_ablkcipher_ctx(tfm);
-
-	if (!irq_fpu_usable()) {
-		struct ablkcipher_request *cryptd_req =
-			ablkcipher_request_ctx(req);
-		memcpy(cryptd_req, req, sizeof(*req));
-		ablkcipher_request_set_tfm(cryptd_req, &ctx->cryptd_tfm->base);
-		return crypto_ablkcipher_decrypt(cryptd_req);
-	} else {
-		struct blkcipher_desc desc;
-		desc.tfm = cryptd_ablkcipher_child(ctx->cryptd_tfm);
-		desc.info = req->info;
-		desc.flags = 0;
-		return crypto_blkcipher_crt(desc.tfm)->decrypt(
-			&desc, req->dst, req->src, req->nbytes);
-	}
-}
-
-static void ablk_exit(struct crypto_tfm *tfm)
-{
-	struct async_aes_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	cryptd_free_ablkcipher(ctx->cryptd_tfm);
-}
-
-static int ablk_init_common(struct crypto_tfm *tfm, const char *drv_name)
-{
-	struct async_aes_ctx *ctx = crypto_tfm_ctx(tfm);
-	struct cryptd_ablkcipher *cryptd_tfm;
-
-	cryptd_tfm = cryptd_alloc_ablkcipher(drv_name, 0, 0);
-	if (IS_ERR(cryptd_tfm))
-		return PTR_ERR(cryptd_tfm);
-
-	ctx->cryptd_tfm = cryptd_tfm;
-	tfm->crt_ablkcipher.reqsize = sizeof(struct ablkcipher_request) +
-		crypto_ablkcipher_reqsize(&cryptd_tfm->base);
-
-	return 0;
-}
-
 static int ablk_ecb_init(struct crypto_tfm *tfm)
 {
 	return ablk_init_common(tfm, "__driver-ecb-aes-aesni");
@@ -968,7 +884,7 @@ static struct crypto_alg aesni_algs[] = { {
 	.cra_priority		= 400,
 	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
 	.cra_blocksize		= AES_BLOCK_SIZE,
-	.cra_ctxsize		= sizeof(struct async_aes_ctx),
+	.cra_ctxsize		= sizeof(struct async_helper_ctx),
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
@@ -989,7 +905,7 @@ static struct crypto_alg aesni_algs[] = { {
 	.cra_priority		= 400,
 	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
 	.cra_blocksize		= AES_BLOCK_SIZE,
-	.cra_ctxsize		= sizeof(struct async_aes_ctx),
+	.cra_ctxsize		= sizeof(struct async_helper_ctx),
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
@@ -1033,7 +949,7 @@ static struct crypto_alg aesni_algs[] = { {
 	.cra_priority		= 400,
 	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
 	.cra_blocksize		= 1,
-	.cra_ctxsize		= sizeof(struct async_aes_ctx),
+	.cra_ctxsize		= sizeof(struct async_helper_ctx),
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
@@ -1098,7 +1014,7 @@ static struct crypto_alg aesni_algs[] = { {
 	.cra_priority		= 400,
 	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
 	.cra_blocksize		= 1,
-	.cra_ctxsize		= sizeof(struct async_aes_ctx),
+	.cra_ctxsize		= sizeof(struct async_helper_ctx),
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
@@ -1126,7 +1042,7 @@ static struct crypto_alg aesni_algs[] = { {
 	.cra_priority		= 400,
 	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
 	.cra_blocksize		= AES_BLOCK_SIZE,
-	.cra_ctxsize		= sizeof(struct async_aes_ctx),
+	.cra_ctxsize		= sizeof(struct async_helper_ctx),
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
@@ -1150,7 +1066,7 @@ static struct crypto_alg aesni_algs[] = { {
 	.cra_priority		= 400,
 	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
 	.cra_blocksize		= AES_BLOCK_SIZE,
-	.cra_ctxsize		= sizeof(struct async_aes_ctx),
+	.cra_ctxsize		= sizeof(struct async_helper_ctx),
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
@@ -1174,7 +1090,7 @@ static struct crypto_alg aesni_algs[] = { {
 	.cra_priority		= 400,
 	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
 	.cra_blocksize		= AES_BLOCK_SIZE,
-	.cra_ctxsize		= sizeof(struct async_aes_ctx),
+	.cra_ctxsize		= sizeof(struct async_helper_ctx),
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
diff --git a/arch/x86/include/asm/crypto/ablk_helper.h b/arch/x86/include/asm/crypto/ablk_helper.h
index 6d6b37c..4f93df5 100644
--- a/arch/x86/include/asm/crypto/ablk_helper.h
+++ b/arch/x86/include/asm/crypto/ablk_helper.h
@@ -24,6 +24,8 @@ extern int ablk_decrypt(struct ablkcipher_request *req);
 
 extern void ablk_exit(struct crypto_tfm *tfm);
 
+extern int ablk_init_common(struct crypto_tfm *tfm, const char *drv_name);
+
 extern int ablk_init(struct crypto_tfm *tfm);
 
 #endif /* _CRYPTO_ABLK_HELPER_H */
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 24b929e..471cc46 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -557,6 +557,7 @@ config CRYPTO_AES_NI_INTEL
 	select CRYPTO_AES_X86_64 if 64BIT
 	select CRYPTO_AES_586 if !64BIT
 	select CRYPTO_CRYPTD
+	select CRYPTO_ABLK_HELPER_X86
 	select CRYPTO_ALGAPI
 	help
 	  Use Intel AES-NI instructions for AES algorithm.
