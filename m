Return-Path: <SRS0=xGgh=RN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61FCEC10F03
	for <linux-crypto@archiver.kernel.org>; Sun, 10 Mar 2019 19:02:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 27229207E0
	for <linux-crypto@archiver.kernel.org>; Sun, 10 Mar 2019 19:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552244536;
	bh=J3nGD8RCi1aPHFHHN2RAbOR3KytZlhwNLUWEyom/YUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=JW0xoWUBgsFblL90R6DnqHM1J5bj7aDWawpgOPRa8fupKXFTbLOg1qD0ip5F2XlmZ
	 OqqwER0u6+hZydsjiZYO1SywPSah/cld4j+gcsjm7Dy3AQ/Uzx4Zb1AGA9K4TCehDM
	 vQe+d9OUTYnUoQW4TEzT7mQjPFcDC5rH4rJk3y5o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbfCJTCP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 10 Mar 2019 15:02:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:36962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726613AbfCJTCN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 10 Mar 2019 15:02:13 -0400
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E1982087E;
        Sun, 10 Mar 2019 19:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552244531;
        bh=J3nGD8RCi1aPHFHHN2RAbOR3KytZlhwNLUWEyom/YUw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pNa5NSPT7tfrAYfyuk8ywteog95mj4aTc8XPu3KEulSHpZnbhXTRqZmy7bLav5sqP
         K9ois6B8tMyW/0Mclzu7wfocPiwMQmHpzHjwveTRCkSzwoKSNAgmFeknX7/bhcmR65
         LClGEr/3oFbvfJ10e4Eq+YTTaVsVzau1Nw9fnKo4=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Ondrej Mosnacek <omosnace@redhat.com>
Subject: [PATCH 7/9] crypto: x86/morus640 - convert to use AEAD SIMD helpers
Date:   Sun, 10 Mar 2019 12:00:56 -0700
Message-Id: <20190310190058.4912-8-ebiggers@kernel.org>
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

Convert the x86 implementation of MORUS-640 to use the AEAD SIMD
helpers, rather than hand-rolling the same functionality.  This
simplifies the code and also fixes the bug where the user-provided
aead_request is modified.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/morus640-sse2-glue.c | 12 ++--
 arch/x86/crypto/morus640_glue.c      | 85 ----------------------------
 crypto/Kconfig                       |  2 +-
 include/crypto/morus640_glue.h       | 79 +++++++-------------------
 4 files changed, 30 insertions(+), 148 deletions(-)

diff --git a/arch/x86/crypto/morus640-sse2-glue.c b/arch/x86/crypto/morus640-sse2-glue.c
index 9afaf8f8565a..32da56b3bdad 100644
--- a/arch/x86/crypto/morus640-sse2-glue.c
+++ b/arch/x86/crypto/morus640-sse2-glue.c
@@ -12,6 +12,7 @@
  */
 
 #include <crypto/internal/aead.h>
+#include <crypto/internal/simd.h>
 #include <crypto/morus640_glue.h>
 #include <linux/module.h>
 #include <asm/fpu/api.h>
@@ -35,7 +36,9 @@ asmlinkage void crypto_morus640_sse2_dec_tail(void *state, const void *src,
 asmlinkage void crypto_morus640_sse2_final(void *state, void *tag_xor,
 					   u64 assoclen, u64 cryptlen);
 
-MORUS640_DECLARE_ALGS(sse2, "morus640-sse2", 400);
+MORUS640_DECLARE_ALG(sse2, "morus640-sse2", 400);
+
+static struct simd_aead_alg *simd_alg;
 
 static int __init crypto_morus640_sse2_module_init(void)
 {
@@ -43,14 +46,13 @@ static int __init crypto_morus640_sse2_module_init(void)
 	    !cpu_has_xfeatures(XFEATURE_MASK_SSE, NULL))
 		return -ENODEV;
 
-	return crypto_register_aeads(crypto_morus640_sse2_algs,
-				     ARRAY_SIZE(crypto_morus640_sse2_algs));
+	return simd_register_aeads_compat(&crypto_morus640_sse2_alg, 1,
+					  &simd_alg);
 }
 
 static void __exit crypto_morus640_sse2_module_exit(void)
 {
-	crypto_unregister_aeads(crypto_morus640_sse2_algs,
-				ARRAY_SIZE(crypto_morus640_sse2_algs));
+	simd_unregister_aeads(&crypto_morus640_sse2_alg, 1, &simd_alg);
 }
 
 module_init(crypto_morus640_sse2_module_init);
diff --git a/arch/x86/crypto/morus640_glue.c b/arch/x86/crypto/morus640_glue.c
index cb3a81732016..1dea33d84426 100644
--- a/arch/x86/crypto/morus640_glue.c
+++ b/arch/x86/crypto/morus640_glue.c
@@ -11,7 +11,6 @@
  * any later version.
  */
 
-#include <crypto/cryptd.h>
 #include <crypto/internal/aead.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/morus640_glue.h>
@@ -200,90 +199,6 @@ void crypto_morus640_glue_init_ops(struct crypto_aead *aead,
 }
 EXPORT_SYMBOL_GPL(crypto_morus640_glue_init_ops);
 
-int cryptd_morus640_glue_setkey(struct crypto_aead *aead, const u8 *key,
-				unsigned int keylen)
-{
-	struct cryptd_aead **ctx = crypto_aead_ctx(aead);
-	struct cryptd_aead *cryptd_tfm = *ctx;
-
-	return crypto_aead_setkey(&cryptd_tfm->base, key, keylen);
-}
-EXPORT_SYMBOL_GPL(cryptd_morus640_glue_setkey);
-
-int cryptd_morus640_glue_setauthsize(struct crypto_aead *aead,
-				     unsigned int authsize)
-{
-	struct cryptd_aead **ctx = crypto_aead_ctx(aead);
-	struct cryptd_aead *cryptd_tfm = *ctx;
-
-	return crypto_aead_setauthsize(&cryptd_tfm->base, authsize);
-}
-EXPORT_SYMBOL_GPL(cryptd_morus640_glue_setauthsize);
-
-int cryptd_morus640_glue_encrypt(struct aead_request *req)
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
-EXPORT_SYMBOL_GPL(cryptd_morus640_glue_encrypt);
-
-int cryptd_morus640_glue_decrypt(struct aead_request *req)
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
-EXPORT_SYMBOL_GPL(cryptd_morus640_glue_decrypt);
-
-int cryptd_morus640_glue_init_tfm(struct crypto_aead *aead)
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
-EXPORT_SYMBOL_GPL(cryptd_morus640_glue_init_tfm);
-
-void cryptd_morus640_glue_exit_tfm(struct crypto_aead *aead)
-{
-	struct cryptd_aead **ctx = crypto_aead_ctx(aead);
-
-	cryptd_free_aead(*ctx);
-}
-EXPORT_SYMBOL_GPL(cryptd_morus640_glue_exit_tfm);
-
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Ondrej Mosnacek <omosnacek@gmail.com>");
 MODULE_DESCRIPTION("MORUS-640 AEAD mode -- glue for x86 optimizations");
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 1b7238e05cf1..498ec4d98ce1 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -340,7 +340,7 @@ config CRYPTO_MORUS640_GLUE
 	tristate
 	depends on X86
 	select CRYPTO_AEAD
-	select CRYPTO_CRYPTD
+	select CRYPTO_SIMD
 	help
 	  Common glue for SIMD optimizations of the MORUS-640 dedicated AEAD
 	  algorithm.
diff --git a/include/crypto/morus640_glue.h b/include/crypto/morus640_glue.h
index df8e1103ff94..0ee6266cb26c 100644
--- a/include/crypto/morus640_glue.h
+++ b/include/crypto/morus640_glue.h
@@ -47,16 +47,7 @@ int crypto_morus640_glue_setauthsize(struct crypto_aead *tfm,
 int crypto_morus640_glue_encrypt(struct aead_request *req);
 int crypto_morus640_glue_decrypt(struct aead_request *req);
 
-int cryptd_morus640_glue_setkey(struct crypto_aead *aead, const u8 *key,
-				unsigned int keylen);
-int cryptd_morus640_glue_setauthsize(struct crypto_aead *aead,
-				     unsigned int authsize);
-int cryptd_morus640_glue_encrypt(struct aead_request *req);
-int cryptd_morus640_glue_decrypt(struct aead_request *req);
-int cryptd_morus640_glue_init_tfm(struct crypto_aead *aead);
-void cryptd_morus640_glue_exit_tfm(struct crypto_aead *aead);
-
-#define MORUS640_DECLARE_ALGS(id, driver_name, priority) \
+#define MORUS640_DECLARE_ALG(id, driver_name, priority) \
 	static const struct morus640_glue_ops crypto_morus640_##id##_ops = {\
 		.init = crypto_morus640_##id##_init, \
 		.ad = crypto_morus640_##id##_ad, \
@@ -77,55 +68,29 @@ void cryptd_morus640_glue_exit_tfm(struct crypto_aead *aead);
 	{ \
 	} \
 	\
-	static struct aead_alg crypto_morus640_##id##_algs[] = {\
-		{ \
-			.setkey = crypto_morus640_glue_setkey, \
-			.setauthsize = crypto_morus640_glue_setauthsize, \
-			.encrypt = crypto_morus640_glue_encrypt, \
-			.decrypt = crypto_morus640_glue_decrypt, \
-			.init = crypto_morus640_##id##_init_tfm, \
-			.exit = crypto_morus640_##id##_exit_tfm, \
-			\
-			.ivsize = MORUS_NONCE_SIZE, \
-			.maxauthsize = MORUS_MAX_AUTH_SIZE, \
-			.chunksize = MORUS640_BLOCK_SIZE, \
-			\
-			.base = { \
-				.cra_flags = CRYPTO_ALG_INTERNAL, \
-				.cra_blocksize = 1, \
-				.cra_ctxsize = sizeof(struct morus640_ctx), \
-				.cra_alignmask = 0, \
-				\
-				.cra_name = "__morus640", \
-				.cra_driver_name = "__"driver_name, \
-				\
-				.cra_module = THIS_MODULE, \
-			} \
-		}, { \
-			.setkey = cryptd_morus640_glue_setkey, \
-			.setauthsize = cryptd_morus640_glue_setauthsize, \
-			.encrypt = cryptd_morus640_glue_encrypt, \
-			.decrypt = cryptd_morus640_glue_decrypt, \
-			.init = cryptd_morus640_glue_init_tfm, \
-			.exit = cryptd_morus640_glue_exit_tfm, \
+	static struct aead_alg crypto_morus640_##id##_alg = {\
+		.setkey = crypto_morus640_glue_setkey, \
+		.setauthsize = crypto_morus640_glue_setauthsize, \
+		.encrypt = crypto_morus640_glue_encrypt, \
+		.decrypt = crypto_morus640_glue_decrypt, \
+		.init = crypto_morus640_##id##_init_tfm, \
+		.exit = crypto_morus640_##id##_exit_tfm, \
+		\
+		.ivsize = MORUS_NONCE_SIZE, \
+		.maxauthsize = MORUS_MAX_AUTH_SIZE, \
+		.chunksize = MORUS640_BLOCK_SIZE, \
+		\
+		.base = { \
+			.cra_flags = CRYPTO_ALG_INTERNAL, \
+			.cra_blocksize = 1, \
+			.cra_ctxsize = sizeof(struct morus640_ctx), \
+			.cra_alignmask = 0, \
+			.cra_priority = priority, \
 			\
-			.ivsize = MORUS_NONCE_SIZE, \
-			.maxauthsize = MORUS_MAX_AUTH_SIZE, \
-			.chunksize = MORUS640_BLOCK_SIZE, \
+			.cra_name = "__morus640", \
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
-				.cra_name = "morus640", \
-				.cra_driver_name = driver_name, \
-				\
-				.cra_module = THIS_MODULE, \
-			} \
+			.cra_module = THIS_MODULE, \
 		} \
 	}
 
-- 
2.21.0

