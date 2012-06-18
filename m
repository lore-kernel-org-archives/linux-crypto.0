From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 02/11] crypto: twofish-avx - change to use shared ablk_*
 functions
Date: Mon, 18 Jun 2012 14:07:03 +0300
Message-ID: <20120618110703.28985.87275.stgit@localhost6.localdomain6>
References: <20120618110652.28985.70075.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:58366 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802Ab2FRLHI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 18 Jun 2012 07:07:08 -0400
In-Reply-To: <20120618110652.28985.70075.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Remove duplicate ablk_* functions and make use of ablk_helper module instead.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 arch/x86/crypto/twofish_avx_glue.c |  116 ++----------------------------------
 crypto/Kconfig                     |    1 
 2 files changed, 7 insertions(+), 110 deletions(-)

diff --git a/arch/x86/crypto/twofish_avx_glue.c b/arch/x86/crypto/twofish_avx_glue.c
index 599f19e..cabe058 100644
--- a/arch/x86/crypto/twofish_avx_glue.c
+++ b/arch/x86/crypto/twofish_avx_glue.c
@@ -39,6 +39,7 @@
 #include <asm/i387.h>
 #include <asm/xcr.h>
 #include <asm/xsave.h>
+#include <asm/crypto/ablk_helper.h>
 #include <crypto/scatterwalk.h>
 #include <linux/workqueue.h>
 #include <linux/spinlock.h>
@@ -95,11 +96,6 @@ static inline void twofish_dec_blk_xway(struct twofish_ctx *ctx, u8 *dst,
 }
 
 
-
-struct async_twofish_ctx {
-	struct cryptd_ablkcipher *cryptd_tfm;
-};
-
 static inline bool twofish_fpu_begin(bool fpu_enabled, unsigned int nbytes)
 {
 	if (fpu_enabled)
@@ -730,106 +726,6 @@ static int xts_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
 	return ret;
 }
 
-static int ablk_set_key(struct crypto_ablkcipher *tfm, const u8 *key,
-			unsigned int key_len)
-{
-	struct async_twofish_ctx *ctx = crypto_ablkcipher_ctx(tfm);
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
-static int __ablk_encrypt(struct ablkcipher_request *req)
-{
-	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(req);
-	struct async_twofish_ctx *ctx = crypto_ablkcipher_ctx(tfm);
-	struct blkcipher_desc desc;
-
-	desc.tfm = cryptd_ablkcipher_child(ctx->cryptd_tfm);
-	desc.info = req->info;
-	desc.flags = 0;
-
-	return crypto_blkcipher_crt(desc.tfm)->encrypt(
-		&desc, req->dst, req->src, req->nbytes);
-}
-
-static int ablk_encrypt(struct ablkcipher_request *req)
-{
-	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(req);
-	struct async_twofish_ctx *ctx = crypto_ablkcipher_ctx(tfm);
-
-	if (!irq_fpu_usable()) {
-		struct ablkcipher_request *cryptd_req =
-			ablkcipher_request_ctx(req);
-
-		memcpy(cryptd_req, req, sizeof(*req));
-		ablkcipher_request_set_tfm(cryptd_req, &ctx->cryptd_tfm->base);
-
-		return crypto_ablkcipher_encrypt(cryptd_req);
-	} else {
-		return __ablk_encrypt(req);
-	}
-}
-
-static int ablk_decrypt(struct ablkcipher_request *req)
-{
-	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(req);
-	struct async_twofish_ctx *ctx = crypto_ablkcipher_ctx(tfm);
-
-	if (!irq_fpu_usable()) {
-		struct ablkcipher_request *cryptd_req =
-			ablkcipher_request_ctx(req);
-
-		memcpy(cryptd_req, req, sizeof(*req));
-		ablkcipher_request_set_tfm(cryptd_req, &ctx->cryptd_tfm->base);
-
-		return crypto_ablkcipher_decrypt(cryptd_req);
-	} else {
-		struct blkcipher_desc desc;
-
-		desc.tfm = cryptd_ablkcipher_child(ctx->cryptd_tfm);
-		desc.info = req->info;
-		desc.flags = 0;
-
-		return crypto_blkcipher_crt(desc.tfm)->decrypt(
-			&desc, req->dst, req->src, req->nbytes);
-	}
-}
-
-static void ablk_exit(struct crypto_tfm *tfm)
-{
-	struct async_twofish_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	cryptd_free_ablkcipher(ctx->cryptd_tfm);
-}
-
-static int ablk_init(struct crypto_tfm *tfm)
-{
-	struct async_twofish_ctx *ctx = crypto_tfm_ctx(tfm);
-	struct cryptd_ablkcipher *cryptd_tfm;
-	char drv_name[CRYPTO_MAX_ALG_NAME];
-
-	snprintf(drv_name, sizeof(drv_name), "__driver-%s",
-					crypto_tfm_alg_driver_name(tfm));
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
 static struct crypto_alg twofish_algs[10] = { {
 	.cra_name		= "__ecb-twofish-avx",
 	.cra_driver_name	= "__driver-ecb-twofish-avx",
@@ -942,7 +838,7 @@ static struct crypto_alg twofish_algs[10] = { {
 	.cra_priority		= 400,
 	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
 	.cra_blocksize		= TF_BLOCK_SIZE,
-	.cra_ctxsize		= sizeof(struct async_twofish_ctx),
+	.cra_ctxsize		= sizeof(struct async_helper_ctx),
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
@@ -964,7 +860,7 @@ static struct crypto_alg twofish_algs[10] = { {
 	.cra_priority		= 400,
 	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
 	.cra_blocksize		= TF_BLOCK_SIZE,
-	.cra_ctxsize		= sizeof(struct async_twofish_ctx),
+	.cra_ctxsize		= sizeof(struct async_helper_ctx),
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
@@ -987,7 +883,7 @@ static struct crypto_alg twofish_algs[10] = { {
 	.cra_priority		= 400,
 	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
 	.cra_blocksize		= 1,
-	.cra_ctxsize		= sizeof(struct async_twofish_ctx),
+	.cra_ctxsize		= sizeof(struct async_helper_ctx),
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
@@ -1011,7 +907,7 @@ static struct crypto_alg twofish_algs[10] = { {
 	.cra_priority		= 400,
 	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
 	.cra_blocksize		= TF_BLOCK_SIZE,
-	.cra_ctxsize		= sizeof(struct async_twofish_ctx),
+	.cra_ctxsize		= sizeof(struct async_helper_ctx),
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
@@ -1036,7 +932,7 @@ static struct crypto_alg twofish_algs[10] = { {
 	.cra_priority		= 400,
 	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
 	.cra_blocksize		= TF_BLOCK_SIZE,
-	.cra_ctxsize		= sizeof(struct async_twofish_ctx),
+	.cra_ctxsize		= sizeof(struct async_helper_ctx),
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 8e9145c..24b929e 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -946,6 +946,7 @@ config CRYPTO_TWOFISH_AVX_X86_64
 	depends on X86 && 64BIT
 	select CRYPTO_ALGAPI
 	select CRYPTO_CRYPTD
+	select CRYPTO_ABLK_HELPER_X86
 	select CRYPTO_TWOFISH_COMMON
 	select CRYPTO_TWOFISH_X86_64
 	select CRYPTO_TWOFISH_X86_64_3WAY
