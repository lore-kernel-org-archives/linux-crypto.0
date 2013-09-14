From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH] crypto: move ablk_helper out of arch/x86
Date: Sat, 14 Sep 2013 12:24:10 +0200
Message-ID: <1379154250-14803-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: herbert@gondor.apana.org.au, mingo@redhat.com, arnd@arndb.de,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	jussi.kivilinna@iki.fi
To: linux-crypto@vger.kernel.org, x86@kernel.org,
	linux-arch@vger.kernel.org
Return-path: <linux-arch-owner@vger.kernel.org>
Sender: linux-arch-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Move the ablk_helper code out of arch/x86 so it can be reused
by other architectures. The only x86 specific dependency is
a call to irq_fpu_usable(), in the generic case we use
!in_interrupt() instead.

Cc: jussi.kivilinna@iki.fi
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---

Any need to split this up between generic/crypto and x86?


 arch/x86/crypto/Makefile                   |   1 -
 arch/x86/crypto/ablk_helper.c              | 149 ----------------------------
 arch/x86/crypto/aesni-intel_glue.c         |   2 +-
 arch/x86/crypto/camellia_aesni_avx2_glue.c |   2 +-
 arch/x86/crypto/camellia_aesni_avx_glue.c  |   2 +-
 arch/x86/crypto/cast5_avx_glue.c           |   2 +-
 arch/x86/crypto/cast6_avx_glue.c           |   2 +-
 arch/x86/crypto/serpent_avx2_glue.c        |   2 +-
 arch/x86/crypto/serpent_avx_glue.c         |   2 +-
 arch/x86/crypto/serpent_sse2_glue.c        |   2 +-
 arch/x86/crypto/twofish_avx_glue.c         |   2 +-
 arch/x86/include/asm/crypto/ablk_helper.h  |  38 ++------
 crypto/Kconfig                             |  23 +++--
 crypto/Makefile                            |   1 +
 crypto/ablk_helper.c                       | 150 +++++++++++++++++++++++++++++
 include/asm-generic/crypto/ablk_helper.h   |  13 +++
 include/crypto/ablk_helper.h               |  31 ++++++
 17 files changed, 224 insertions(+), 200 deletions(-)
 delete mode 100644 arch/x86/crypto/ablk_helper.c
 create mode 100644 crypto/ablk_helper.c
 create mode 100644 include/asm-generic/crypto/ablk_helper.h
 create mode 100644 include/crypto/ablk_helper.h

diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index 7d6ba9d..18fda50 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -4,7 +4,6 @@
 
 avx_supported := $(call as-instr,vpxor %xmm0$(comma)%xmm0$(comma)%xmm0,yes,no)
 
-obj-$(CONFIG_CRYPTO_ABLK_HELPER_X86) += ablk_helper.o
 obj-$(CONFIG_CRYPTO_GLUE_HELPER_X86) += glue_helper.o
 
 obj-$(CONFIG_CRYPTO_AES_586) += aes-i586.o
diff --git a/arch/x86/crypto/ablk_helper.c b/arch/x86/crypto/ablk_helper.c
deleted file mode 100644
index 43282fe..0000000
--- a/arch/x86/crypto/ablk_helper.c
+++ /dev/null
@@ -1,149 +0,0 @@
-/*
- * Shared async block cipher helpers
- *
- * Copyright (c) 2012 Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
- *
- * Based on aesni-intel_glue.c by:
- *  Copyright (C) 2008, Intel Corp.
- *    Author: Huang Ying <ying.huang@intel.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
- * USA
- *
- */
-
-#include <linux/kernel.h>
-#include <linux/crypto.h>
-#include <linux/init.h>
-#include <linux/module.h>
-#include <crypto/algapi.h>
-#include <crypto/cryptd.h>
-#include <asm/i387.h>
-#include <asm/crypto/ablk_helper.h>
-
-int ablk_set_key(struct crypto_ablkcipher *tfm, const u8 *key,
-		 unsigned int key_len)
-{
-	struct async_helper_ctx *ctx = crypto_ablkcipher_ctx(tfm);
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
-EXPORT_SYMBOL_GPL(ablk_set_key);
-
-int __ablk_encrypt(struct ablkcipher_request *req)
-{
-	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(req);
-	struct async_helper_ctx *ctx = crypto_ablkcipher_ctx(tfm);
-	struct blkcipher_desc desc;
-
-	desc.tfm = cryptd_ablkcipher_child(ctx->cryptd_tfm);
-	desc.info = req->info;
-	desc.flags = 0;
-
-	return crypto_blkcipher_crt(desc.tfm)->encrypt(
-		&desc, req->dst, req->src, req->nbytes);
-}
-EXPORT_SYMBOL_GPL(__ablk_encrypt);
-
-int ablk_encrypt(struct ablkcipher_request *req)
-{
-	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(req);
-	struct async_helper_ctx *ctx = crypto_ablkcipher_ctx(tfm);
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
-EXPORT_SYMBOL_GPL(ablk_encrypt);
-
-int ablk_decrypt(struct ablkcipher_request *req)
-{
-	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(req);
-	struct async_helper_ctx *ctx = crypto_ablkcipher_ctx(tfm);
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
-EXPORT_SYMBOL_GPL(ablk_decrypt);
-
-void ablk_exit(struct crypto_tfm *tfm)
-{
-	struct async_helper_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	cryptd_free_ablkcipher(ctx->cryptd_tfm);
-}
-EXPORT_SYMBOL_GPL(ablk_exit);
-
-int ablk_init_common(struct crypto_tfm *tfm, const char *drv_name)
-{
-	struct async_helper_ctx *ctx = crypto_tfm_ctx(tfm);
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
-EXPORT_SYMBOL_GPL(ablk_init_common);
-
-int ablk_init(struct crypto_tfm *tfm)
-{
-	char drv_name[CRYPTO_MAX_ALG_NAME];
-
-	snprintf(drv_name, sizeof(drv_name), "__driver-%s",
-					crypto_tfm_alg_driver_name(tfm));
-
-	return ablk_init_common(tfm, drv_name);
-}
-EXPORT_SYMBOL_GPL(ablk_init);
-
-MODULE_LICENSE("GPL");
diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index f80e668..835488b 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -34,7 +34,7 @@
 #include <asm/cpu_device_id.h>
 #include <asm/i387.h>
 #include <asm/crypto/aes.h>
-#include <asm/crypto/ablk_helper.h>
+#include <crypto/ablk_helper.h>
 #include <crypto/scatterwalk.h>
 #include <crypto/internal/aead.h>
 #include <linux/workqueue.h>
diff --git a/arch/x86/crypto/camellia_aesni_avx2_glue.c b/arch/x86/crypto/camellia_aesni_avx2_glue.c
index 414fe5d..4209a76 100644
--- a/arch/x86/crypto/camellia_aesni_avx2_glue.c
+++ b/arch/x86/crypto/camellia_aesni_avx2_glue.c
@@ -14,6 +14,7 @@
 #include <linux/types.h>
 #include <linux/crypto.h>
 #include <linux/err.h>
+#include <crypto/ablk_helper.h>
 #include <crypto/algapi.h>
 #include <crypto/ctr.h>
 #include <crypto/lrw.h>
@@ -21,7 +22,6 @@
 #include <asm/xcr.h>
 #include <asm/xsave.h>
 #include <asm/crypto/camellia.h>
-#include <asm/crypto/ablk_helper.h>
 #include <asm/crypto/glue_helper.h>
 
 #define CAMELLIA_AESNI_PARALLEL_BLOCKS 16
diff --git a/arch/x86/crypto/camellia_aesni_avx_glue.c b/arch/x86/crypto/camellia_aesni_avx_glue.c
index 37fd0c0..87a041a 100644
--- a/arch/x86/crypto/camellia_aesni_avx_glue.c
+++ b/arch/x86/crypto/camellia_aesni_avx_glue.c
@@ -14,6 +14,7 @@
 #include <linux/types.h>
 #include <linux/crypto.h>
 #include <linux/err.h>
+#include <crypto/ablk_helper.h>
 #include <crypto/algapi.h>
 #include <crypto/ctr.h>
 #include <crypto/lrw.h>
@@ -21,7 +22,6 @@
 #include <asm/xcr.h>
 #include <asm/xsave.h>
 #include <asm/crypto/camellia.h>
-#include <asm/crypto/ablk_helper.h>
 #include <asm/crypto/glue_helper.h>
 
 #define CAMELLIA_AESNI_PARALLEL_BLOCKS 16
diff --git a/arch/x86/crypto/cast5_avx_glue.c b/arch/x86/crypto/cast5_avx_glue.c
index c663181..e6a3700 100644
--- a/arch/x86/crypto/cast5_avx_glue.c
+++ b/arch/x86/crypto/cast5_avx_glue.c
@@ -26,13 +26,13 @@
 #include <linux/types.h>
 #include <linux/crypto.h>
 #include <linux/err.h>
+#include <crypto/ablk_helper.h>
 #include <crypto/algapi.h>
 #include <crypto/cast5.h>
 #include <crypto/cryptd.h>
 #include <crypto/ctr.h>
 #include <asm/xcr.h>
 #include <asm/xsave.h>
-#include <asm/crypto/ablk_helper.h>
 #include <asm/crypto/glue_helper.h>
 
 #define CAST5_PARALLEL_BLOCKS 16
diff --git a/arch/x86/crypto/cast6_avx_glue.c b/arch/x86/crypto/cast6_avx_glue.c
index 8d0dfb8..09f3677 100644
--- a/arch/x86/crypto/cast6_avx_glue.c
+++ b/arch/x86/crypto/cast6_avx_glue.c
@@ -28,6 +28,7 @@
 #include <linux/types.h>
 #include <linux/crypto.h>
 #include <linux/err.h>
+#include <crypto/ablk_helper.h>
 #include <crypto/algapi.h>
 #include <crypto/cast6.h>
 #include <crypto/cryptd.h>
@@ -37,7 +38,6 @@
 #include <crypto/xts.h>
 #include <asm/xcr.h>
 #include <asm/xsave.h>
-#include <asm/crypto/ablk_helper.h>
 #include <asm/crypto/glue_helper.h>
 
 #define CAST6_PARALLEL_BLOCKS 8
diff --git a/arch/x86/crypto/serpent_avx2_glue.c b/arch/x86/crypto/serpent_avx2_glue.c
index 23aabc6..2fae489 100644
--- a/arch/x86/crypto/serpent_avx2_glue.c
+++ b/arch/x86/crypto/serpent_avx2_glue.c
@@ -14,6 +14,7 @@
 #include <linux/types.h>
 #include <linux/crypto.h>
 #include <linux/err.h>
+#include <crypto/ablk_helper.h>
 #include <crypto/algapi.h>
 #include <crypto/ctr.h>
 #include <crypto/lrw.h>
@@ -22,7 +23,6 @@
 #include <asm/xcr.h>
 #include <asm/xsave.h>
 #include <asm/crypto/serpent-avx.h>
-#include <asm/crypto/ablk_helper.h>
 #include <asm/crypto/glue_helper.h>
 
 #define SERPENT_AVX2_PARALLEL_BLOCKS 16
diff --git a/arch/x86/crypto/serpent_avx_glue.c b/arch/x86/crypto/serpent_avx_glue.c
index 9ae83cf..ff48708 100644
--- a/arch/x86/crypto/serpent_avx_glue.c
+++ b/arch/x86/crypto/serpent_avx_glue.c
@@ -28,6 +28,7 @@
 #include <linux/types.h>
 #include <linux/crypto.h>
 #include <linux/err.h>
+#include <crypto/ablk_helper.h>
 #include <crypto/algapi.h>
 #include <crypto/serpent.h>
 #include <crypto/cryptd.h>
@@ -38,7 +39,6 @@
 #include <asm/xcr.h>
 #include <asm/xsave.h>
 #include <asm/crypto/serpent-avx.h>
-#include <asm/crypto/ablk_helper.h>
 #include <asm/crypto/glue_helper.h>
 
 /* 8-way parallel cipher functions */
diff --git a/arch/x86/crypto/serpent_sse2_glue.c b/arch/x86/crypto/serpent_sse2_glue.c
index 97a356e..8c95f86 100644
--- a/arch/x86/crypto/serpent_sse2_glue.c
+++ b/arch/x86/crypto/serpent_sse2_glue.c
@@ -34,6 +34,7 @@
 #include <linux/types.h>
 #include <linux/crypto.h>
 #include <linux/err.h>
+#include <crypto/ablk_helper.h>
 #include <crypto/algapi.h>
 #include <crypto/serpent.h>
 #include <crypto/cryptd.h>
@@ -42,7 +43,6 @@
 #include <crypto/lrw.h>
 #include <crypto/xts.h>
 #include <asm/crypto/serpent-sse2.h>
-#include <asm/crypto/ablk_helper.h>
 #include <asm/crypto/glue_helper.h>
 
 static void serpent_decrypt_cbc_xway(void *ctx, u128 *dst, const u128 *src)
diff --git a/arch/x86/crypto/twofish_avx_glue.c b/arch/x86/crypto/twofish_avx_glue.c
index a62ba54..4e3c665 100644
--- a/arch/x86/crypto/twofish_avx_glue.c
+++ b/arch/x86/crypto/twofish_avx_glue.c
@@ -28,6 +28,7 @@
 #include <linux/types.h>
 #include <linux/crypto.h>
 #include <linux/err.h>
+#include <crypto/ablk_helper.h>
 #include <crypto/algapi.h>
 #include <crypto/twofish.h>
 #include <crypto/cryptd.h>
@@ -39,7 +40,6 @@
 #include <asm/xcr.h>
 #include <asm/xsave.h>
 #include <asm/crypto/twofish.h>
-#include <asm/crypto/ablk_helper.h>
 #include <asm/crypto/glue_helper.h>
 #include <crypto/scatterwalk.h>
 #include <linux/workqueue.h>
diff --git a/arch/x86/include/asm/crypto/ablk_helper.h b/arch/x86/include/asm/crypto/ablk_helper.h
index 4f93df5..0f68111 100644
--- a/arch/x86/include/asm/crypto/ablk_helper.h
+++ b/arch/x86/include/asm/crypto/ablk_helper.h
@@ -1,31 +1,11 @@
-/*
- * Shared async block cipher helpers
- */
-
-#ifndef _CRYPTO_ABLK_HELPER_H
-#define _CRYPTO_ABLK_HELPER_H
-
-#include <linux/crypto.h>
-#include <linux/kernel.h>
-#include <crypto/cryptd.h>
-
-struct async_helper_ctx {
-	struct cryptd_ablkcipher *cryptd_tfm;
-};
-
-extern int ablk_set_key(struct crypto_ablkcipher *tfm, const u8 *key,
-			unsigned int key_len);
-
-extern int __ablk_encrypt(struct ablkcipher_request *req);
 
-extern int ablk_encrypt(struct ablkcipher_request *req);
+#include <asm/i387.h>
 
-extern int ablk_decrypt(struct ablkcipher_request *req);
-
-extern void ablk_exit(struct crypto_tfm *tfm);
-
-extern int ablk_init_common(struct crypto_tfm *tfm, const char *drv_name);
-
-extern int ablk_init(struct crypto_tfm *tfm);
-
-#endif /* _CRYPTO_ABLK_HELPER_H */
+/*
+ * ablk_can_run_sync - used by crypto/ablk_helper to decide whether a request
+ * can be handled synchronously or needs to be queued up
+ */
+static inline int ablk_can_run_sync(void)
+{
+	return irq_fpu_usable();
+}
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 69ce573..7c0a4c5 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -174,9 +174,8 @@ config CRYPTO_TEST
 	help
 	  Quick & dirty crypto test module.
 
-config CRYPTO_ABLK_HELPER_X86
+config CRYPTO_ABLK_HELPER
 	tristate
-	depends on X86
 	select CRYPTO_CRYPTD
 
 config CRYPTO_GLUE_HELPER_X86
@@ -695,7 +694,7 @@ config CRYPTO_AES_NI_INTEL
 	select CRYPTO_AES_X86_64 if 64BIT
 	select CRYPTO_AES_586 if !64BIT
 	select CRYPTO_CRYPTD
-	select CRYPTO_ABLK_HELPER_X86
+	select CRYPTO_ABLK_HELPER
 	select CRYPTO_ALGAPI
 	select CRYPTO_GLUE_HELPER_X86 if 64BIT
 	select CRYPTO_LRW
@@ -879,7 +878,7 @@ config CRYPTO_CAMELLIA_AESNI_AVX_X86_64
 	depends on CRYPTO
 	select CRYPTO_ALGAPI
 	select CRYPTO_CRYPTD
-	select CRYPTO_ABLK_HELPER_X86
+	select CRYPTO_ABLK_HELPER
 	select CRYPTO_GLUE_HELPER_X86
 	select CRYPTO_CAMELLIA_X86_64
 	select CRYPTO_LRW
@@ -901,7 +900,7 @@ config CRYPTO_CAMELLIA_AESNI_AVX2_X86_64
 	depends on CRYPTO
 	select CRYPTO_ALGAPI
 	select CRYPTO_CRYPTD
-	select CRYPTO_ABLK_HELPER_X86
+	select CRYPTO_ABLK_HELPER
 	select CRYPTO_GLUE_HELPER_X86
 	select CRYPTO_CAMELLIA_X86_64
 	select CRYPTO_CAMELLIA_AESNI_AVX_X86_64
@@ -953,7 +952,7 @@ config CRYPTO_CAST5_AVX_X86_64
 	depends on X86 && 64BIT
 	select CRYPTO_ALGAPI
 	select CRYPTO_CRYPTD
-	select CRYPTO_ABLK_HELPER_X86
+	select CRYPTO_ABLK_HELPER
 	select CRYPTO_CAST_COMMON
 	select CRYPTO_CAST5
 	help
@@ -976,7 +975,7 @@ config CRYPTO_CAST6_AVX_X86_64
 	depends on X86 && 64BIT
 	select CRYPTO_ALGAPI
 	select CRYPTO_CRYPTD
-	select CRYPTO_ABLK_HELPER_X86
+	select CRYPTO_ABLK_HELPER
 	select CRYPTO_GLUE_HELPER_X86
 	select CRYPTO_CAST_COMMON
 	select CRYPTO_CAST6
@@ -1094,7 +1093,7 @@ config CRYPTO_SERPENT_SSE2_X86_64
 	depends on X86 && 64BIT
 	select CRYPTO_ALGAPI
 	select CRYPTO_CRYPTD
-	select CRYPTO_ABLK_HELPER_X86
+	select CRYPTO_ABLK_HELPER
 	select CRYPTO_GLUE_HELPER_X86
 	select CRYPTO_SERPENT
 	select CRYPTO_LRW
@@ -1116,7 +1115,7 @@ config CRYPTO_SERPENT_SSE2_586
 	depends on X86 && !64BIT
 	select CRYPTO_ALGAPI
 	select CRYPTO_CRYPTD
-	select CRYPTO_ABLK_HELPER_X86
+	select CRYPTO_ABLK_HELPER
 	select CRYPTO_GLUE_HELPER_X86
 	select CRYPTO_SERPENT
 	select CRYPTO_LRW
@@ -1138,7 +1137,7 @@ config CRYPTO_SERPENT_AVX_X86_64
 	depends on X86 && 64BIT
 	select CRYPTO_ALGAPI
 	select CRYPTO_CRYPTD
-	select CRYPTO_ABLK_HELPER_X86
+	select CRYPTO_ABLK_HELPER
 	select CRYPTO_GLUE_HELPER_X86
 	select CRYPTO_SERPENT
 	select CRYPTO_LRW
@@ -1160,7 +1159,7 @@ config CRYPTO_SERPENT_AVX2_X86_64
 	depends on X86 && 64BIT
 	select CRYPTO_ALGAPI
 	select CRYPTO_CRYPTD
-	select CRYPTO_ABLK_HELPER_X86
+	select CRYPTO_ABLK_HELPER
 	select CRYPTO_GLUE_HELPER_X86
 	select CRYPTO_SERPENT
 	select CRYPTO_SERPENT_AVX_X86_64
@@ -1276,7 +1275,7 @@ config CRYPTO_TWOFISH_AVX_X86_64
 	depends on X86 && 64BIT
 	select CRYPTO_ALGAPI
 	select CRYPTO_CRYPTD
-	select CRYPTO_ABLK_HELPER_X86
+	select CRYPTO_ABLK_HELPER
 	select CRYPTO_GLUE_HELPER_X86
 	select CRYPTO_TWOFISH_COMMON
 	select CRYPTO_TWOFISH_X86_64
diff --git a/crypto/Makefile b/crypto/Makefile
index 2d5ed08..580af97 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -104,3 +104,4 @@ obj-$(CONFIG_CRYPTO_USER_API_SKCIPHER) += algif_skcipher.o
 obj-$(CONFIG_XOR_BLOCKS) += xor.o
 obj-$(CONFIG_ASYNC_CORE) += async_tx/
 obj-$(CONFIG_ASYMMETRIC_KEY_TYPE) += asymmetric_keys/
+obj-$(CONFIG_CRYPTO_ABLK_HELPER) += ablk_helper.o
diff --git a/crypto/ablk_helper.c b/crypto/ablk_helper.c
new file mode 100644
index 0000000..63ee760
--- /dev/null
+++ b/crypto/ablk_helper.c
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
+#include <linux/hardirq.h>
+#include <crypto/algapi.h>
+#include <crypto/cryptd.h>
+#include <crypto/ablk_helper.h>
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
+	if (!ablk_can_run_sync()) {
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
+	if (!ablk_can_run_sync()) {
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
+int ablk_init_common(struct crypto_tfm *tfm, const char *drv_name)
+{
+	struct async_helper_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct cryptd_ablkcipher *cryptd_tfm;
+
+	cryptd_tfm = cryptd_alloc_ablkcipher(drv_name, 0, 0);
+	if (IS_ERR(cryptd_tfm))
+		return PTR_ERR(cryptd_tfm);
+
+	ctx->cryptd_tfm = cryptd_tfm;
+	tfm->crt_ablkcipher.reqsize = sizeof(struct ablkcipher_request) +
+		crypto_ablkcipher_reqsize(&cryptd_tfm->base);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ablk_init_common);
+
+int ablk_init(struct crypto_tfm *tfm)
+{
+	char drv_name[CRYPTO_MAX_ALG_NAME];
+
+	snprintf(drv_name, sizeof(drv_name), "__driver-%s",
+					crypto_tfm_alg_driver_name(tfm));
+
+	return ablk_init_common(tfm, drv_name);
+}
+EXPORT_SYMBOL_GPL(ablk_init);
+
+MODULE_LICENSE("GPL");
diff --git a/include/asm-generic/crypto/ablk_helper.h b/include/asm-generic/crypto/ablk_helper.h
new file mode 100644
index 0000000..ede807f
--- /dev/null
+++ b/include/asm-generic/crypto/ablk_helper.h
@@ -0,0 +1,13 @@
+
+#include <linux/hardirq.h>
+
+/*
+ * ablk_can_run_sync - used by crypto/ablk_helper to decide whether a request
+ * can be handled synchronously or needs to be queued up.
+ * 
+ * Choose in_interrupt() as a reasonable default
+ */
+static inline int ablk_can_run_sync(void)
+{
+	return !in_interrupt();
+}
diff --git a/include/crypto/ablk_helper.h b/include/crypto/ablk_helper.h
new file mode 100644
index 0000000..4f93df5
--- /dev/null
+++ b/include/crypto/ablk_helper.h
@@ -0,0 +1,31 @@
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
+extern int ablk_init_common(struct crypto_tfm *tfm, const char *drv_name);
+
+extern int ablk_init(struct crypto_tfm *tfm);
+
+#endif /* _CRYPTO_ABLK_HELPER_H */
-- 
1.8.1.2
