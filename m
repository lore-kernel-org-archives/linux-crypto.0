Return-Path: <SRS0=xGgh=RN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A74FC10F0E
	for <linux-crypto@archiver.kernel.org>; Sun, 10 Mar 2019 19:02:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C3C020657
	for <linux-crypto@archiver.kernel.org>; Sun, 10 Mar 2019 19:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552244534;
	bh=sJpnBjoG9Jv26q+i4jv/12KxvQXf7GcQiJQQtgaCQeQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=X1dr2UIAtPaUZORbs2L4YT8nFfPt5j0mwVo2pzRb8j1XC+SVqXYXw5xSOPohq9vIF
	 wB8wOHRHjbiRIcCm/zpzOPSicwacKfQRiMOnT7TGvFj2Zv3t4E0pmDpRqJGNNnegVK
	 eH3D6eGiuHJkFTFAXseBV0Gj63v6cAzTmr+p9dI0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbfCJTCN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 10 Mar 2019 15:02:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:36958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726718AbfCJTCM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 10 Mar 2019 15:02:12 -0400
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C05352087C;
        Sun, 10 Mar 2019 19:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552244530;
        bh=sJpnBjoG9Jv26q+i4jv/12KxvQXf7GcQiJQQtgaCQeQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=clljlJCDdooEN91hf51qtPXNtFNCpsZgA8hpdGhhcP/l6Dzzk55vXlPUySV7sggcN
         nk+g2kkFULKU+eEw6Ziuvgs/wVwaTCjFA5ZlGgPimKRYgVG0lJ7xXGve2SD1FVJUqU
         M7q77KC8KhsaKo+8RRMb+WxvCZbH5JHQnKby+HEc=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Ondrej Mosnacek <omosnace@redhat.com>
Subject: [PATCH 6/9] crypto: x86/aegis256 - convert to use AEAD SIMD helpers
Date:   Sun, 10 Mar 2019 12:00:55 -0700
Message-Id: <20190310190058.4912-7-ebiggers@kernel.org>
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

Convert the x86 implementation of AEGIS-256 to use the AEAD SIMD
helpers, rather than hand-rolling the same functionality.  This
simplifies the code and also fixes the bug where the user-provided
aead_request is modified.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/aegis256-aesni-glue.c | 157 +++++---------------------
 crypto/Kconfig                        |   2 +-
 2 files changed, 31 insertions(+), 128 deletions(-)

diff --git a/arch/x86/crypto/aegis256-aesni-glue.c b/arch/x86/crypto/aegis256-aesni-glue.c
index 6227ca3220a0..716eecb66bd5 100644
--- a/arch/x86/crypto/aegis256-aesni-glue.c
+++ b/arch/x86/crypto/aegis256-aesni-glue.c
@@ -11,8 +11,8 @@
  * any later version.
  */
 
-#include <crypto/cryptd.h>
 #include <crypto/internal/aead.h>
+#include <crypto/internal/simd.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/scatterwalk.h>
 #include <linux/module.h>
@@ -242,131 +242,35 @@ static void crypto_aegis256_aesni_exit_tfm(struct crypto_aead *aead)
 {
 }
 
-static int cryptd_aegis256_aesni_setkey(struct crypto_aead *aead,
-					const u8 *key, unsigned int keylen)
-{
-	struct cryptd_aead **ctx = crypto_aead_ctx(aead);
-	struct cryptd_aead *cryptd_tfm = *ctx;
-
-	return crypto_aead_setkey(&cryptd_tfm->base, key, keylen);
-}
-
-static int cryptd_aegis256_aesni_setauthsize(struct crypto_aead *aead,
-					     unsigned int authsize)
-{
-	struct cryptd_aead **ctx = crypto_aead_ctx(aead);
-	struct cryptd_aead *cryptd_tfm = *ctx;
-
-	return crypto_aead_setauthsize(&cryptd_tfm->base, authsize);
-}
-
-static int cryptd_aegis256_aesni_encrypt(struct aead_request *req)
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
-
-static int cryptd_aegis256_aesni_decrypt(struct aead_request *req)
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
-
-static int cryptd_aegis256_aesni_init_tfm(struct crypto_aead *aead)
-{
-	struct cryptd_aead *cryptd_tfm;
-	struct cryptd_aead **ctx = crypto_aead_ctx(aead);
-
-	cryptd_tfm = cryptd_alloc_aead("__aegis256-aesni", CRYPTO_ALG_INTERNAL,
-				       CRYPTO_ALG_INTERNAL);
-	if (IS_ERR(cryptd_tfm))
-		return PTR_ERR(cryptd_tfm);
-
-	*ctx = cryptd_tfm;
-	crypto_aead_set_reqsize(aead, crypto_aead_reqsize(&cryptd_tfm->base));
-	return 0;
-}
-
-static void cryptd_aegis256_aesni_exit_tfm(struct crypto_aead *aead)
-{
-	struct cryptd_aead **ctx = crypto_aead_ctx(aead);
-
-	cryptd_free_aead(*ctx);
-}
-
-static struct aead_alg crypto_aegis256_aesni_alg[] = {
-	{
-		.setkey = crypto_aegis256_aesni_setkey,
-		.setauthsize = crypto_aegis256_aesni_setauthsize,
-		.encrypt = crypto_aegis256_aesni_encrypt,
-		.decrypt = crypto_aegis256_aesni_decrypt,
-		.init = crypto_aegis256_aesni_init_tfm,
-		.exit = crypto_aegis256_aesni_exit_tfm,
-
-		.ivsize = AEGIS256_NONCE_SIZE,
-		.maxauthsize = AEGIS256_MAX_AUTH_SIZE,
-		.chunksize = AEGIS256_BLOCK_SIZE,
-
-		.base = {
-			.cra_flags = CRYPTO_ALG_INTERNAL,
-			.cra_blocksize = 1,
-			.cra_ctxsize = sizeof(struct aegis_ctx) +
-				__alignof__(struct aegis_ctx),
-			.cra_alignmask = 0,
-
-			.cra_name = "__aegis256",
-			.cra_driver_name = "__aegis256-aesni",
-
-			.cra_module = THIS_MODULE,
-		}
-	}, {
-		.setkey = cryptd_aegis256_aesni_setkey,
-		.setauthsize = cryptd_aegis256_aesni_setauthsize,
-		.encrypt = cryptd_aegis256_aesni_encrypt,
-		.decrypt = cryptd_aegis256_aesni_decrypt,
-		.init = cryptd_aegis256_aesni_init_tfm,
-		.exit = cryptd_aegis256_aesni_exit_tfm,
-
-		.ivsize = AEGIS256_NONCE_SIZE,
-		.maxauthsize = AEGIS256_MAX_AUTH_SIZE,
-		.chunksize = AEGIS256_BLOCK_SIZE,
-
-		.base = {
-			.cra_flags = CRYPTO_ALG_ASYNC,
-			.cra_blocksize = 1,
-			.cra_ctxsize = sizeof(struct cryptd_aead *),
-			.cra_alignmask = 0,
-
-			.cra_priority = 400,
-
-			.cra_name = "aegis256",
-			.cra_driver_name = "aegis256-aesni",
-
-			.cra_module = THIS_MODULE,
-		}
+static struct aead_alg crypto_aegis256_aesni_alg = {
+	.setkey = crypto_aegis256_aesni_setkey,
+	.setauthsize = crypto_aegis256_aesni_setauthsize,
+	.encrypt = crypto_aegis256_aesni_encrypt,
+	.decrypt = crypto_aegis256_aesni_decrypt,
+	.init = crypto_aegis256_aesni_init_tfm,
+	.exit = crypto_aegis256_aesni_exit_tfm,
+
+	.ivsize = AEGIS256_NONCE_SIZE,
+	.maxauthsize = AEGIS256_MAX_AUTH_SIZE,
+	.chunksize = AEGIS256_BLOCK_SIZE,
+
+	.base = {
+		.cra_flags = CRYPTO_ALG_INTERNAL,
+		.cra_blocksize = 1,
+		.cra_ctxsize = sizeof(struct aegis_ctx) +
+			       __alignof__(struct aegis_ctx),
+		.cra_alignmask = 0,
+		.cra_priority = 400,
+
+		.cra_name = "__aegis256",
+		.cra_driver_name = "__aegis256-aesni",
+
+		.cra_module = THIS_MODULE,
 	}
 };
 
+static struct simd_aead_alg *simd_alg;
+
 static int __init crypto_aegis256_aesni_module_init(void)
 {
 	if (!boot_cpu_has(X86_FEATURE_XMM2) ||
@@ -374,14 +278,13 @@ static int __init crypto_aegis256_aesni_module_init(void)
 	    !cpu_has_xfeatures(XFEATURE_MASK_SSE, NULL))
 		return -ENODEV;
 
-	return crypto_register_aeads(crypto_aegis256_aesni_alg,
-				    ARRAY_SIZE(crypto_aegis256_aesni_alg));
+	return simd_register_aeads_compat(&crypto_aegis256_aesni_alg, 1,
+					  &simd_alg);
 }
 
 static void __exit crypto_aegis256_aesni_module_exit(void)
 {
-	crypto_unregister_aeads(crypto_aegis256_aesni_alg,
-				ARRAY_SIZE(crypto_aegis256_aesni_alg));
+	simd_unregister_aeads(&crypto_aegis256_aesni_alg, 1, &simd_alg);
 }
 
 module_init(crypto_aegis256_aesni_module_init);
diff --git a/crypto/Kconfig b/crypto/Kconfig
index ff05a87cf9e0..1b7238e05cf1 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -326,7 +326,7 @@ config CRYPTO_AEGIS256_AESNI_SSE2
 	tristate "AEGIS-256 AEAD algorithm (x86_64 AESNI+SSE2 implementation)"
 	depends on X86 && 64BIT
 	select CRYPTO_AEAD
-	select CRYPTO_CRYPTD
+	select CRYPTO_SIMD
 	help
 	 AESNI+SSE2 implementation of the AEGSI-256 dedicated AEAD algorithm.
 
-- 
2.21.0

