From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 01/11] crypto: ablk_helper - move ablk_* functions from
 serpent-sse2/avx glue code to shared module
Date: Mon, 18 Jun 2012 14:06:58 +0300
Message-ID: <20120618110658.28985.58455.stgit@localhost6.localdomain6>
References: <20120618110652.28985.70075.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:50662 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802Ab2FRLHE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 18 Jun 2012 07:07:04 -0400
In-Reply-To: <20120618110652.28985.70075.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Move ablk-* functions to separate module to share common code between cipher
implementations.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 arch/x86/crypto/Makefile                  |    2 
 arch/x86/crypto/ablk_helper.c             |  150 +++++++++++++++++++++++++++++
 arch/x86/crypto/serpent_avx_glue.c        |  115 +---------------------
 arch/x86/crypto/serpent_sse2_glue.c       |  115 +---------------------
 arch/x86/include/asm/crypto/ablk_helper.h |   29 ++++++
 crypto/Kconfig                            |    8 ++
 6 files changed, 201 insertions(+), 218 deletions(-)
 create mode 100644 arch/x86/crypto/ablk_helper.c
 create mode 100644 arch/x86/include/asm/crypto/ablk_helper.h

diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index 83caa4b..ad74691 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -2,6 +2,8 @@
 # Arch-specific CryptoAPI modules.
 #
 
+obj-$(CONFIG_CRYPTO_ABLK_HELPER_X86) += ablk_helper.o
+
 obj-$(CONFIG_CRYPTO_AES_586) += aes-i586.o
 obj-$(CONFIG_CRYPTO_TWOFISH_586) += twofish-i586.o
 obj-$(CONFIG_CRYPTO_SALSA20_586) += salsa20-i586.o
diff --git a/arch/x86/crypto/ablk_helper.c b/arch/x86/crypto/ablk_helper.c
new file mode 100644
index 0000000..284ca3b
--- /dev/null
+++ b/arch/x86/crypto/ablk_helper.c
@@ -0,0 +1,150 @@
+/*
+ * Shared async block cipher helpers
+ *
+ * Copyright (c) 2012 Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
+ *
+ * Based on aesni-intel_glue.c by:
+ *  Copyright (C) 2008, Intel Corp.
+ *    Author: Huang Ying <ying.huang@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
+ * USA
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/crypto.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <crypto/algapi.h>
+#include <crypto/cryptd.h>
+#include <asm/i387.h>
+#include <asm/crypto/ablk_helper.h>
+
+int ablk_set_key(struct crypto_ablkcipher *tfm, const u8 *key,
+		 unsigned int key_len)
+{
+	struct async_helper_ctx *ctx = crypto_ablkcipher_ctx(tfm);
+	struct crypto_ablkcipher *child = &ctx->cryptd_tfm->base;
+	int err;
+
+	crypto_ablkcipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
+	crypto_ablkcipher_set_flags(child, crypto_ablkcipher_get_flags(tfm)
+				    & CRYPTO_TFM_REQ_MASK);
+	err = crypto_ablkcipher_setkey(child, key, key_len);
+	crypto_ablkcipher_set_flags(tfm, crypto_ablkcipher_get_flags(child)
+				    & CRYPTO_TFM_RES_MASK);
+	return err;
+}
+EXPORT_SYMBOL_GPL(ablk_set_key);
+
+int __ablk_encrypt(struct ablkcipher_request *req)
+{
+	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(req);
+	struct async_helper_ctx *ctx = crypto_ablkcipher_ctx(tfm);
+	struct blkcipher_desc desc;
+
+	desc.tfm = cryptd_ablkcipher_child(ctx->cryptd_tfm);
+	desc.info = req->info;
+	desc.flags = 0;
+
+	return crypto_blkcipher_crt(desc.tfm)->encrypt(
+		&desc, req->dst, req->src, req->nbytes);
+}
+EXPORT_SYMBOL_GPL(__ablk_encrypt);
+
+int ablk_encrypt(struct ablkcipher_request *req)
+{
+	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(req);
+	struct async_helper_ctx *ctx = crypto_ablkcipher_ctx(tfm);
+
+	if (!irq_fpu_usable()) {
+		struct ablkcipher_request *cryptd_req =
+			ablkcipher_request_ctx(req);
+
+		memcpy(cryptd_req, req, sizeof(*req));
+		ablkcipher_request_set_tfm(cryptd_req, &ctx->cryptd_tfm->base);
+
+		return crypto_ablkcipher_encrypt(cryptd_req);
+	} else {
+		return __ablk_encrypt(req);
+	}
+}
+EXPORT_SYMBOL_GPL(ablk_encrypt);
+
+int ablk_decrypt(struct ablkcipher_request *req)
+{
+	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(req);
+	struct async_helper_ctx *ctx = crypto_ablkcipher_ctx(tfm);
+
+	if (!irq_fpu_usable()) {
+		struct ablkcipher_request *cryptd_req =
+			ablkcipher_request_ctx(req);
+
+		memcpy(cryptd_req, req, sizeof(*req));
+		ablkcipher_request_set_tfm(cryptd_req, &ctx->cryptd_tfm->base);
+
+		return crypto_ablkcipher_decrypt(cryptd_req);
+	} else {
+		struct blkcipher_desc desc;
+
+		desc.tfm = cryptd_ablkcipher_child(ctx->cryptd_tfm);
+		desc.info = req->info;
+		desc.flags = 0;
+
+		return crypto_blkcipher_crt(desc.tfm)->decrypt(
+			&desc, req->dst, req->src, req->nbytes);
+	}
+}
+EXPORT_SYMBOL_GPL(ablk_decrypt);
+
+void ablk_exit(struct crypto_tfm *tfm)
+{
+	struct async_helper_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	cryptd_free_ablkcipher(ctx->cryptd_tfm);
+}
+EXPORT_SYMBOL_GPL(ablk_exit);
+
+void ablk_init_common(struct crypto_tfm *tfm,
+		      struct cryptd_ablkcipher *cryptd_tfm)
+{
+	struct async_helper_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	ctx->cryptd_tfm = cryptd_tfm;
+	tfm->crt_ablkcipher.reqsize = sizeof(struct ablkcipher_request) +
+		crypto_ablkcipher_reqsize(&cryptd_tfm->base);
+}
+EXPORT_SYMBOL_GPL(ablk_init_common);
+
+int ablk_init(struct crypto_tfm *tfm)
+{
+	struct cryptd_ablkcipher *cryptd_tfm;
+	char drv_name[CRYPTO_MAX_ALG_NAME];
+
+	snprintf(drv_name, sizeof(drv_name), "__driver-%s",
+					crypto_tfm_alg_driver_name(tfm));
+
+	cryptd_tfm = cryptd_alloc_ablkcipher(drv_name, 0, 0);
+	if (IS_ERR(cryptd_tfm))
+		return PTR_ERR(cryptd_tfm);
+
+	ablk_init_common(tfm, cryptd_tfm);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ablk_init);
+
+MODULE_LICENSE("GPL");
diff --git a/arch/x86/crypto/serpent_avx_glue.c b/arch/x86/crypto/serpent_avx_glue.c
index dd81bab..31eb567 100644
--- a/arch/x86/crypto/serpent_avx_glue.c
+++ b/arch/x86/crypto/serpent_avx_glue.c
@@ -40,14 +40,11 @@
 #include <asm/xcr.h>
 #include <asm/xsave.h>
 #include <asm/serpent-avx.h>
+#include <asm/crypto/ablk_helper.h>
 #include <crypto/scatterwalk.h>
 #include <linux/workqueue.h>
 #include <linux/spinlock.h>
 
-struct async_serpent_ctx {
-	struct cryptd_ablkcipher *cryptd_tfm;
-};
-
 static inline bool serpent_fpu_begin(bool fpu_enabled, unsigned int nbytes)
 {
 	if (fpu_enabled)
@@ -593,106 +590,6 @@ static int xts_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
 	return ret;
 }
 
-static int ablk_set_key(struct crypto_ablkcipher *tfm, const u8 *key,
-			unsigned int key_len)
-{
-	struct async_serpent_ctx *ctx = crypto_ablkcipher_ctx(tfm);
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
-	struct async_serpent_ctx *ctx = crypto_ablkcipher_ctx(tfm);
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
-	struct async_serpent_ctx *ctx = crypto_ablkcipher_ctx(tfm);
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
-	struct async_serpent_ctx *ctx = crypto_ablkcipher_ctx(tfm);
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
-	struct async_serpent_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	cryptd_free_ablkcipher(ctx->cryptd_tfm);
-}
-
-static int ablk_init(struct crypto_tfm *tfm)
-{
-	struct async_serpent_ctx *ctx = crypto_tfm_ctx(tfm);
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
 static struct crypto_alg serpent_algs[10] = { {
 	.cra_name		= "__ecb-serpent-avx",
 	.cra_driver_name	= "__driver-ecb-serpent-avx",
@@ -805,7 +702,7 @@ static struct crypto_alg serpent_algs[10] = { {
 	.cra_priority		= 500,
 	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
 	.cra_blocksize		= SERPENT_BLOCK_SIZE,
-	.cra_ctxsize		= sizeof(struct async_serpent_ctx),
+	.cra_ctxsize		= sizeof(struct async_helper_ctx),
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
@@ -827,7 +724,7 @@ static struct crypto_alg serpent_algs[10] = { {
 	.cra_priority		= 500,
 	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
 	.cra_blocksize		= SERPENT_BLOCK_SIZE,
-	.cra_ctxsize		= sizeof(struct async_serpent_ctx),
+	.cra_ctxsize		= sizeof(struct async_helper_ctx),
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
@@ -850,7 +747,7 @@ static struct crypto_alg serpent_algs[10] = { {
 	.cra_priority		= 500,
 	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
 	.cra_blocksize		= 1,
-	.cra_ctxsize		= sizeof(struct async_serpent_ctx),
+	.cra_ctxsize		= sizeof(struct async_helper_ctx),
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
@@ -874,7 +771,7 @@ static struct crypto_alg serpent_algs[10] = { {
 	.cra_priority		= 500,
 	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
 	.cra_blocksize		= SERPENT_BLOCK_SIZE,
-	.cra_ctxsize		= sizeof(struct async_serpent_ctx),
+	.cra_ctxsize		= sizeof(struct async_helper_ctx),
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
@@ -899,7 +796,7 @@ static struct crypto_alg serpent_algs[10] = { {
 	.cra_priority		= 500,
 	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
 	.cra_blocksize		= SERPENT_BLOCK_SIZE,
-	.cra_ctxsize		= sizeof(struct async_serpent_ctx),
+	.cra_ctxsize		= sizeof(struct async_helper_ctx),
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
diff --git a/arch/x86/crypto/serpent_sse2_glue.c b/arch/x86/crypto/serpent_sse2_glue.c
index deecd25..805c91f 100644
--- a/arch/x86/crypto/serpent_sse2_glue.c
+++ b/arch/x86/crypto/serpent_sse2_glue.c
@@ -43,14 +43,11 @@
 #include <crypto/xts.h>
 #include <asm/i387.h>
 #include <asm/serpent-sse2.h>
+#include <asm/crypto/ablk_helper.h>
 #include <crypto/scatterwalk.h>
 #include <linux/workqueue.h>
 #include <linux/spinlock.h>
 
-struct async_serpent_ctx {
-	struct cryptd_ablkcipher *cryptd_tfm;
-};
-
 static inline bool serpent_fpu_begin(bool fpu_enabled, unsigned int nbytes)
 {
 	if (fpu_enabled)
@@ -596,106 +593,6 @@ static int xts_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
 	return ret;
 }
 
-static int ablk_set_key(struct crypto_ablkcipher *tfm, const u8 *key,
-			unsigned int key_len)
-{
-	struct async_serpent_ctx *ctx = crypto_ablkcipher_ctx(tfm);
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
-	struct async_serpent_ctx *ctx = crypto_ablkcipher_ctx(tfm);
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
-	struct async_serpent_ctx *ctx = crypto_ablkcipher_ctx(tfm);
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
-	struct async_serpent_ctx *ctx = crypto_ablkcipher_ctx(tfm);
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
-	struct async_serpent_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	cryptd_free_ablkcipher(ctx->cryptd_tfm);
-}
-
-static int ablk_init(struct crypto_tfm *tfm)
-{
-	struct async_serpent_ctx *ctx = crypto_tfm_ctx(tfm);
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
 static struct crypto_alg serpent_algs[10] = { {
 	.cra_name		= "__ecb-serpent-sse2",
 	.cra_driver_name	= "__driver-ecb-serpent-sse2",
@@ -808,7 +705,7 @@ static struct crypto_alg serpent_algs[10] = { {
 	.cra_priority		= 400,
 	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
 	.cra_blocksize		= SERPENT_BLOCK_SIZE,
-	.cra_ctxsize		= sizeof(struct async_serpent_ctx),
+	.cra_ctxsize		= sizeof(struct async_helper_ctx),
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
@@ -830,7 +727,7 @@ static struct crypto_alg serpent_algs[10] = { {
 	.cra_priority		= 400,
 	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
 	.cra_blocksize		= SERPENT_BLOCK_SIZE,
-	.cra_ctxsize		= sizeof(struct async_serpent_ctx),
+	.cra_ctxsize		= sizeof(struct async_helper_ctx),
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
@@ -853,7 +750,7 @@ static struct crypto_alg serpent_algs[10] = { {
 	.cra_priority		= 400,
 	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
 	.cra_blocksize		= 1,
-	.cra_ctxsize		= sizeof(struct async_serpent_ctx),
+	.cra_ctxsize		= sizeof(struct async_helper_ctx),
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
@@ -877,7 +774,7 @@ static struct crypto_alg serpent_algs[10] = { {
 	.cra_priority		= 400,
 	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
 	.cra_blocksize		= SERPENT_BLOCK_SIZE,
-	.cra_ctxsize		= sizeof(struct async_serpent_ctx),
+	.cra_ctxsize		= sizeof(struct async_helper_ctx),
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
@@ -902,7 +799,7 @@ static struct crypto_alg serpent_algs[10] = { {
 	.cra_priority		= 400,
 	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
 	.cra_blocksize		= SERPENT_BLOCK_SIZE,
-	.cra_ctxsize		= sizeof(struct async_serpent_ctx),
+	.cra_ctxsize		= sizeof(struct async_helper_ctx),
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
diff --git a/arch/x86/include/asm/crypto/ablk_helper.h b/arch/x86/include/asm/crypto/ablk_helper.h
new file mode 100644
index 0000000..6d6b37c
--- /dev/null
+++ b/arch/x86/include/asm/crypto/ablk_helper.h
@@ -0,0 +1,29 @@
+/*
+ * Shared async block cipher helpers
+ */
+
+#ifndef _CRYPTO_ABLK_HELPER_H
+#define _CRYPTO_ABLK_HELPER_H
+
+#include <linux/crypto.h>
+#include <linux/kernel.h>
+#include <crypto/cryptd.h>
+
+struct async_helper_ctx {
+	struct cryptd_ablkcipher *cryptd_tfm;
+};
+
+extern int ablk_set_key(struct crypto_ablkcipher *tfm, const u8 *key,
+			unsigned int key_len);
+
+extern int __ablk_encrypt(struct ablkcipher_request *req);
+
+extern int ablk_encrypt(struct ablkcipher_request *req);
+
+extern int ablk_decrypt(struct ablkcipher_request *req);
+
+extern void ablk_exit(struct crypto_tfm *tfm);
+
+extern int ablk_init(struct crypto_tfm *tfm);
+
+#endif /* _CRYPTO_ABLK_HELPER_H */
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 2c1c2df..8e9145c 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -174,6 +174,11 @@ config CRYPTO_TEST
 	help
 	  Quick & dirty crypto test module.
 
+config CRYPTO_ABLK_HELPER_X86
+	tristate
+	depends on X86
+	select CRYPTO_CRYPTD
+
 comment "Authenticated Encryption with Associated Data"
 
 config CRYPTO_CCM
@@ -786,6 +791,7 @@ config CRYPTO_SERPENT_SSE2_X86_64
 	depends on X86 && 64BIT
 	select CRYPTO_ALGAPI
 	select CRYPTO_CRYPTD
+	select CRYPTO_ABLK_HELPER_X86
 	select CRYPTO_SERPENT
 	select CRYPTO_LRW
 	select CRYPTO_XTS
@@ -806,6 +812,7 @@ config CRYPTO_SERPENT_SSE2_586
 	depends on X86 && !64BIT
 	select CRYPTO_ALGAPI
 	select CRYPTO_CRYPTD
+	select CRYPTO_ABLK_HELPER_X86
 	select CRYPTO_SERPENT
 	select CRYPTO_LRW
 	select CRYPTO_XTS
@@ -826,6 +833,7 @@ config CRYPTO_SERPENT_AVX_X86_64
 	depends on X86 && 64BIT
 	select CRYPTO_ALGAPI
 	select CRYPTO_CRYPTD
+	select CRYPTO_ABLK_HELPER_X86
 	select CRYPTO_SERPENT
 	select CRYPTO_LRW
 	select CRYPTO_XTS
