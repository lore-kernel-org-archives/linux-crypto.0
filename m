Return-Path: <SRS0=xGgh=RN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DE99C43381
	for <linux-crypto@archiver.kernel.org>; Sun, 10 Mar 2019 19:02:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E487520657
	for <linux-crypto@archiver.kernel.org>; Sun, 10 Mar 2019 19:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552244536;
	bh=cLlLD1IQwxOV+DnfhtfYQPPaaOZNg0eYGQXU3646TPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Kfm4JeCBOasoJ2jPRQ3WLT8CA9G/oCTIibymblIUEhtsk25c2/9A0BJwJyG44WX/H
	 5n364smtbNXClCDT58SDBqF7e7KPuD4D9XadHYLF188vkKrgws6omxmXGzNLpefTod
	 mF7ihXFNhtgJxVg/1ACfiQFHuCY/ws1Iwgyw2AxY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbfCJTCP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 10 Mar 2019 15:02:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:36968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726741AbfCJTCM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 10 Mar 2019 15:02:12 -0400
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E51620880;
        Sun, 10 Mar 2019 19:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552244531;
        bh=cLlLD1IQwxOV+DnfhtfYQPPaaOZNg0eYGQXU3646TPc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YSyc9/hOV6BdROpUzDjwVnSDiwVLs+lSXtf1lcBOlEPj8gbkSGzmMLIiS0CdFOY92
         sqWhlJFSrmiTaRL0XwTvJg8VbbTu89FyiJJFkVP0U9GGNpfzWp7pAn3x93I2o4i+ur
         FWDIFfzppdPoQv24mS6P4BNcHDfoCka7tThfiv2c=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Ondrej Mosnacek <omosnace@redhat.com>
Subject: [PATCH 8/9] crypto: x86/morus1280 - convert to use AEAD SIMD helpers
Date:   Sun, 10 Mar 2019 12:00:57 -0700
Message-Id: <20190310190058.4912-9-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190310190058.4912-1-ebiggers@kernel.org>
References: <20190310190058.4912-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Convert the x86 implementations of MORUS-1280 to use the AEAD SIMD
helpers, rather than hand-rolling the same functionality.  This
simplifies the code and also fixes the bug where the user-provided
aead_request is modified.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/morus1280-avx2-glue.c | 12 ++--
 arch/x86/crypto/morus1280-sse2-glue.c | 12 ++--
 arch/x86/crypto/morus1280_glue.c      | 85 ---------------------------
 crypto/Kconfig                        |  2 +-
 include/crypto/morus1280_glue.h       | 79 +++++++------------------
 5 files changed, 37 insertions(+), 153 deletions(-)

diff --git a/arch/x86/crypto/morus1280-avx2-glue.c b/arch/x86/crypto/morus1280-avx2-glue.c
index 6634907d6ccd..679627a2a824 100644
--- a/arch/x86/crypto/morus1280-avx2-glue.c
+++ b/arch/x86/crypto/morus1280-avx2-glue.c
@@ -12,6 +12,7 @@
  */
 
 #include <crypto/internal/aead.h>
+#include <crypto/internal/simd.h>
 #include <crypto/morus1280_glue.h>
 #include <linux/module.h>
 #include <asm/fpu/api.h>
@@ -35,7 +36,9 @@ asmlinkage void crypto_morus1280_avx2_dec_tail(void *state, const void *src,
 asmlinkage void crypto_morus1280_avx2_final(void *state, void *tag_xor,
 					    u64 assoclen, u64 cryptlen);
 
-MORUS1280_DECLARE_ALGS(avx2, "morus1280-avx2", 400);
+MORUS1280_DECLARE_ALG(avx2, "morus1280-avx2", 400);
+
+static struct simd_aead_alg *simd_alg;
 
 static int __init crypto_morus1280_avx2_module_init(void)
 {
@@ -44,14 +47,13 @@ static int __init crypto_morus1280_avx2_module_init(void)
 	    !cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM, NULL))
 		return -ENODEV;
 
-	return crypto_register_aeads(crypto_morus1280_avx2_algs,
-				     ARRAY_SIZE(crypto_morus1280_avx2_algs));
+	return simd_register_aeads_compat(&crypto_morus1280_avx2_alg, 1,
+					  &simd_alg);
 }
 
 static void __exit crypto_morus1280_avx2_module_exit(void)
 {
-	crypto_unregister_aeads(crypto_morus1280_avx2_algs,
-				ARRAY_SIZE(crypto_morus1280_avx2_algs));
+	simd_unregister_aeads(&crypto_morus1280_avx2_alg, 1, &simd_alg);
 }
 
 module_init(crypto_morus1280_avx2_module_init);
diff --git a/arch/x86/crypto/morus1280-sse2-glue.c b/arch/x86/crypto/morus1280-sse2-glue.c
index f40244eaf14d..c35c0638d0bb 100644
--- a/arch/x86/crypto/morus1280-sse2-glue.c
+++ b/arch/x86/crypto/morus1280-sse2-glue.c
@@ -12,6 +12,7 @@
  */
 
 #include <crypto/internal/aead.h>
+#include <crypto/internal/simd.h>
 #include <crypto/morus1280_glue.h>
 #include <linux/module.h>
 #include <asm/fpu/api.h>
@@ -35,7 +36,9 @@ asmlinkage void crypto_morus1280_sse2_dec_tail(void *state, const void *src,
 asmlinkage void crypto_morus1280_sse2_final(void *state, void *tag_xor,
 					    u64 assoclen, u64 cryptlen);
 
-MORUS1280_DECLARE_ALGS(sse2, "morus1280-sse2", 350);
+MORUS1280_DECLARE_ALG(sse2, "morus1280-sse2", 350);
+
+static struct simd_aead_alg *simd_alg;
 
 static int __init crypto_morus1280_sse2_module_init(void)
 {
@@ -43,14 +46,13 @@ static int __init crypto_morus1280_sse2_module_init(void)
 	    !cpu_has_xfeatures(XFEATURE_MASK_SSE, NULL))
 		return -ENODEV;
 
-	return crypto_register_aeads(crypto_morus1280_sse2_algs,
-				     ARRAY_SIZE(crypto_morus1280_sse2_algs));
+	return simd_register_aeads_compat(&crypto_morus1280_sse2_alg, 1,
+					  &simd_alg);
 }
 
 static void __exit crypto_morus1280_sse2_module_exit(void)
 {
-	crypto_unregister_aeads(crypto_morus1280_sse2_algs,
-				ARRAY_SIZE(crypto_morus1280_sse2_algs));
+	simd_unregister_aeads(&crypto_morus1280_sse2_alg, 1, &simd_alg);
 }
 
 module_init(crypto_morus1280_sse2_module_init);
diff --git a/arch/x86/crypto/morus1280_glue.c b/arch/x86/crypto/morus1280_glue.c
index 7e600f8bcdad..30fc1bd98ec3 100644
--- a/arch/x86/crypto/morus1280_glue.c
+++ b/arch/x86/crypto/morus1280_glue.c
@@ -11,7 +11,6 @@
  * any later version.
  */
 
-#include <crypto/cryptd.h>
 #include <crypto/internal/aead.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/morus1280_glue.h>
@@ -205,90 +204,6 @@ void crypto_morus1280_glue_init_ops(struct crypto_aead *aead,
 }
 EXPORT_SYMBOL_GPL(crypto_morus1280_glue_init_ops);
 
-int cryptd_morus1280_glue_setkey(struct crypto_aead *aead, const u8 *key,
-				 unsigned int keylen)
-{
-	struct cryptd_aead **ctx = crypto_aead_ctx(aead);
-	struct cryptd_aead *cryptd_tfm = *ctx;
-
-	return crypto_aead_setkey(&cryptd_tfm->base, key, keylen);
-}
-EXPORT_SYMBOL_GPL(cryptd_morus1280_glue_setkey);
-
-int cryptd_morus1280_glue_setauthsize(struct crypto_aead *aead,
-				      unsigned int authsize)
-{
-	struct cryptd_aead **ctx = crypto_aead_ctx(aead);
-	struct cryptd_aead *cryptd_tfm = *ctx;
-
-	return crypto_aead_setauthsize(&cryptd_tfm->base, authsize);
-}
-EXPORT_SYMBOL_GPL(cryptd_morus1280_glue_setauthsize);
-
-int cryptd_morus1280_glue_encrypt(struct aead_request *req)
-{
-	struct crypto_aead *aead = crypto_aead_reqtfm(req);
-	struct cryptd_aead **ctx = crypto_aead_ctx(aead);
-	struct cryptd_aead *cryptd_tfm = *ctx;
-
-	aead = &cryptd_tfm->base;
-	if (irq_fpu_usable() && (!in_atomic() ||
-				 !cryptd_aead_queued(cryptd_tfm)))
-		aead = cryptd_aead_child(cryptd_tfm);
-
-	aead_request_set_tfm(req, aead);
-
-	return crypto_aead_encrypt(req);
-}
-EXPORT_SYMBOL_GPL(cryptd_morus1280_glue_encrypt);
-
-int cryptd_morus1280_glue_decrypt(struct aead_request *req)
-{
-	struct crypto_aead *aead = crypto_aead_reqtfm(req);
-	struct cryptd_aead **ctx = crypto_aead_ctx(aead);
-	struct cryptd_aead *cryptd_tfm = *ctx;
-
-	aead = &cryptd_tfm->base;
-	if (irq_fpu_usable() && (!in_atomic() ||
-				 !cryptd_aead_queued(cryptd_tfm)))
-		aead = cryptd_aead_child(cryptd_tfm);
-
-	aead_request_set_tfm(req, aead);
-
-	return crypto_aead_decrypt(req);
-}
-EXPORT_SYMBOL_GPL(cryptd_morus1280_glue_decrypt);
-
-int cryptd_morus1280_glue_init_tfm(struct crypto_aead *aead)
-{
-	struct cryptd_aead *cryptd_tfm;
-	struct cryptd_aead **ctx = crypto_aead_ctx(aead);
-	const char *name = crypto_aead_alg(aead)->base.cra_driver_name;
-	char internal_name[CRYPTO_MAX_ALG_NAME];
-
-	if (snprintf(internal_name, CRYPTO_MAX_ALG_NAME, "__%s", name)
-			>= CRYPTO_MAX_ALG_NAME)
-		return -ENAMETOOLONG;
-
-	cryptd_tfm = cryptd_alloc_aead(internal_name, CRYPTO_ALG_INTERNAL,
-				       CRYPTO_ALG_INTERNAL);
-	if (IS_ERR(cryptd_tfm))
-		return PTR_ERR(cryptd_tfm);
-
-	*ctx = cryptd_tfm;
-	crypto_aead_set_reqsize(aead, crypto_aead_reqsize(&cryptd_tfm->base));
-	return 0;
-}
-EXPORT_SYMBOL_GPL(cryptd_morus1280_glue_init_tfm);
-
-void cryptd_morus1280_glue_exit_tfm(struct crypto_aead *aead)
-{
-	struct cryptd_aead **ctx = crypto_aead_ctx(aead);
-
-	cryptd_free_aead(*ctx);
-}
-EXPORT_SYMBOL_GPL(cryptd_morus1280_glue_exit_tfm);
-
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Ondrej Mosnacek <omosnacek@gmail.com>");
 MODULE_DESCRIPTION("MORUS-1280 AEAD mode -- glue for x86 optimizations");
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 498ec4d98ce1..6ad6d11c990b 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -363,7 +363,7 @@ config CRYPTO_MORUS1280_GLUE
 	tristate
 	depends on X86
 	select CRYPTO_AEAD
-	select CRYPTO_CRYPTD
+	select CRYPTO_SIMD
 	help
 	  Common glue for SIMD optimizations of the MORUS-1280 dedicated AEAD
 	  algorithm.
diff --git a/include/crypto/morus1280_glue.h b/include/crypto/morus1280_glue.h
index ad2aa743dd99..5cefddb1991f 100644
--- a/include/crypto/morus1280_glue.h
+++ b/include/crypto/morus1280_glue.h
@@ -47,16 +47,7 @@ int crypto_morus1280_glue_setauthsize(struct crypto_aead *tfm,
 int crypto_morus1280_glue_encrypt(struct aead_request *req);
 int crypto_morus1280_glue_decrypt(struct aead_request *req);
 
-int cryptd_morus1280_glue_setkey(struct crypto_aead *aead, const u8 *key,
-				 unsigned int keylen);
-int cryptd_morus1280_glue_setauthsize(struct crypto_aead *aead,
-				      unsigned int authsize);
-int cryptd_morus1280_glue_encrypt(struct aead_request *req);
-int cryptd_morus1280_glue_decrypt(struct aead_request *req);
-int cryptd_morus1280_glue_init_tfm(struct crypto_aead *aead);
-void cryptd_morus1280_glue_exit_tfm(struct crypto_aead *aead);
-
-#define MORUS1280_DECLARE_ALGS(id, driver_name, priority) \
+#define MORUS1280_DECLARE_ALG(id, driver_name, priority) \
 	static const struct morus1280_glue_ops crypto_morus1280_##id##_ops = {\
 		.init = crypto_morus1280_##id##_init, \
 		.ad = crypto_morus1280_##id##_ad, \
@@ -77,55 +68,29 @@ void cryptd_morus1280_glue_exit_tfm(struct crypto_aead *aead);
 	{ \
 	} \
 	\
-	static struct aead_alg crypto_morus1280_##id##_algs[] = {\
-		{ \
-			.setkey = crypto_morus1280_glue_setkey, \
-			.setauthsize = crypto_morus1280_glue_setauthsize, \
-			.encrypt = crypto_morus1280_glue_encrypt, \
-			.decrypt = crypto_morus1280_glue_decrypt, \
-			.init = crypto_morus1280_##id##_init_tfm, \
-			.exit = crypto_morus1280_##id##_exit_tfm, \
-			\
-			.ivsize = MORUS_NONCE_SIZE, \
-			.maxauthsize = MORUS_MAX_AUTH_SIZE, \
-			.chunksize = MORUS1280_BLOCK_SIZE, \
-			\
-			.base = { \
-				.cra_flags = CRYPTO_ALG_INTERNAL, \
-				.cra_blocksize = 1, \
-				.cra_ctxsize = sizeof(struct morus1280_ctx), \
-				.cra_alignmask = 0, \
-				\
-				.cra_name = "__morus1280", \
-				.cra_driver_name = "__"driver_name, \
-				\
-				.cra_module = THIS_MODULE, \
-			} \
-		}, { \
-			.setkey = cryptd_morus1280_glue_setkey, \
-			.setauthsize = cryptd_morus1280_glue_setauthsize, \
-			.encrypt = cryptd_morus1280_glue_encrypt, \
-			.decrypt = cryptd_morus1280_glue_decrypt, \
-			.init = cryptd_morus1280_glue_init_tfm, \
-			.exit = cryptd_morus1280_glue_exit_tfm, \
+	static struct aead_alg crypto_morus1280_##id##_alg = { \
+		.setkey = crypto_morus1280_glue_setkey, \
+		.setauthsize = crypto_morus1280_glue_setauthsize, \
+		.encrypt = crypto_morus1280_glue_encrypt, \
+		.decrypt = crypto_morus1280_glue_decrypt, \
+		.init = crypto_morus1280_##id##_init_tfm, \
+		.exit = crypto_morus1280_##id##_exit_tfm, \
+		\
+		.ivsize = MORUS_NONCE_SIZE, \
+		.maxauthsize = MORUS_MAX_AUTH_SIZE, \
+		.chunksize = MORUS1280_BLOCK_SIZE, \
+		\
+		.base = { \
+			.cra_flags = CRYPTO_ALG_INTERNAL, \
+			.cra_blocksize = 1, \
+			.cra_ctxsize = sizeof(struct morus1280_ctx), \
+			.cra_alignmask = 0, \
+			.cra_priority = priority, \
 			\
-			.ivsize = MORUS_NONCE_SIZE, \
-			.maxauthsize = MORUS_MAX_AUTH_SIZE, \
-			.chunksize = MORUS1280_BLOCK_SIZE, \
+			.cra_name = "__morus1280", \
+			.cra_driver_name = "__"driver_name, \
 			\
-			.base = { \
-				.cra_flags = CRYPTO_ALG_ASYNC, \
-				.cra_blocksize = 1, \
-				.cra_ctxsize = sizeof(struct crypto_aead *), \
-				.cra_alignmask = 0, \
-				\
-				.cra_priority = priority, \
-				\
-				.cra_name = "morus1280", \
-				.cra_driver_name = driver_name, \
-				\
-				.cra_module = THIS_MODULE, \
-			} \
+			.cra_module = THIS_MODULE, \
 		} \
 	}
 
-- 
2.21.0

