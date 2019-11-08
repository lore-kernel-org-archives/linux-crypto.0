Return-Path: <SRS0=0i+u=ZA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED90DFC6194
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 12:23:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C18F12247D
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 12:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573215831;
	bh=Qs0Hpb3K9Ha6nGnL/QcmPygJEIcJga5cEgLRV/T8WBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=gRsb7srfLOwJUNwhcvmydvOoiRXsoYnkh94aLdFT3GbgWnCMbkoKHqNuiZsVbzvTV
	 RC5VDy6zVO3nNc2OYQ9+et7siJQq6q8Ds2+TtIuHtOIcjeDAwiFag3Xc8vvHCuCKjW
	 HeobLKFJCeUrwTqjg2vbKwUPfNEpd5yh/YPPrtmQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732429AbfKHMXv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Nov 2019 07:23:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:38234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732402AbfKHMXv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Nov 2019 07:23:51 -0500
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr [92.154.90.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE40B22478;
        Fri,  8 Nov 2019 12:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573215830;
        bh=Qs0Hpb3K9Ha6nGnL/QcmPygJEIcJga5cEgLRV/T8WBQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JZKxxt3nLxf7ryDkt81MWOlu8LTHVh3MsUYQGCPuwRA5B+YNDUSdp9hmfxrymjtCw
         Q+t+xU6clUXmlAitRsJaH3KRxiOy4kPQTJWXmXzd+Y6gwP79IwowqC3/rZijYo5hAJ
         a8FZSvHZR6CmKtrumq3+SCzykSUWQsOCuox3TNMQ=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Martin Willi <martin@strongswan.org>,
        Rene van Dorst <opensource@vdorst.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH v5 17/34] crypto: x86/poly1305 - expose existing driver as poly1305 library
Date:   Fri,  8 Nov 2019 13:22:23 +0100
Message-Id: <20191108122240.28479-18-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108122240.28479-1-ardb@kernel.org>
References: <20191108122240.28479-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Implement the arch init/update/final Poly1305 library routines in the
accelerated SIMD driver for x86 so they are accessible to users of
the Poly1305 library interface as well.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/crypto/poly1305_glue.c | 57 ++++++++++++++------
 crypto/Kconfig                  |  1 +
 lib/crypto/Kconfig              |  1 +
 3 files changed, 43 insertions(+), 16 deletions(-)

diff --git a/arch/x86/crypto/poly1305_glue.c b/arch/x86/crypto/poly1305_glue.c
index a5b3a054604c..370cd88068ec 100644
--- a/arch/x86/crypto/poly1305_glue.c
+++ b/arch/x86/crypto/poly1305_glue.c
@@ -10,6 +10,7 @@
 #include <crypto/internal/poly1305.h>
 #include <crypto/internal/simd.h>
 #include <linux/crypto.h>
+#include <linux/jump_label.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <asm/simd.h>
@@ -21,7 +22,8 @@ asmlinkage void poly1305_2block_sse2(u32 *h, const u8 *src, const u32 *r,
 asmlinkage void poly1305_4block_avx2(u32 *h, const u8 *src, const u32 *r,
 				     unsigned int blocks, const u32 *u);
 
-static bool poly1305_use_avx2 __ro_after_init;
+static __ro_after_init DEFINE_STATIC_KEY_FALSE(poly1305_use_simd);
+static __ro_after_init DEFINE_STATIC_KEY_FALSE(poly1305_use_avx2);
 
 static void poly1305_simd_mult(u32 *a, const u32 *b)
 {
@@ -64,7 +66,7 @@ static unsigned int poly1305_simd_blocks(struct poly1305_desc_ctx *dctx,
 	}
 
 	if (IS_ENABLED(CONFIG_AS_AVX2) &&
-	    poly1305_use_avx2 &&
+	    static_branch_likely(&poly1305_use_avx2) &&
 	    srclen >= POLY1305_BLOCK_SIZE * 4) {
 		if (unlikely(dctx->rset < 4)) {
 			if (dctx->rset < 2) {
@@ -103,10 +105,15 @@ static unsigned int poly1305_simd_blocks(struct poly1305_desc_ctx *dctx,
 	return srclen;
 }
 
-static int poly1305_simd_update(struct shash_desc *desc,
-				const u8 *src, unsigned int srclen)
+void poly1305_init_arch(struct poly1305_desc_ctx *desc, const u8 *key)
+{
+	poly1305_init_generic(desc, key);
+}
+EXPORT_SYMBOL(poly1305_init_arch);
+
+void poly1305_update_arch(struct poly1305_desc_ctx *dctx, const u8 *src,
+			  unsigned int srclen)
 {
-	struct poly1305_desc_ctx *dctx = shash_desc_ctx(desc);
 	unsigned int bytes;
 
 	if (unlikely(dctx->buflen)) {
@@ -117,7 +124,8 @@ static int poly1305_simd_update(struct shash_desc *desc,
 		dctx->buflen += bytes;
 
 		if (dctx->buflen == POLY1305_BLOCK_SIZE) {
-			if (likely(crypto_simd_usable())) {
+			if (static_branch_likely(&poly1305_use_simd) &&
+			    likely(crypto_simd_usable())) {
 				kernel_fpu_begin();
 				poly1305_simd_blocks(dctx, dctx->buf,
 						     POLY1305_BLOCK_SIZE);
@@ -131,7 +139,8 @@ static int poly1305_simd_update(struct shash_desc *desc,
 	}
 
 	if (likely(srclen >= POLY1305_BLOCK_SIZE)) {
-		if (likely(crypto_simd_usable())) {
+		if (static_branch_likely(&poly1305_use_simd) &&
+		    likely(crypto_simd_usable())) {
 			kernel_fpu_begin();
 			bytes = poly1305_simd_blocks(dctx, src, srclen);
 			kernel_fpu_end();
@@ -147,6 +156,13 @@ static int poly1305_simd_update(struct shash_desc *desc,
 		memcpy(dctx->buf, src, srclen);
 	}
 }
+EXPORT_SYMBOL(poly1305_update_arch);
+
+void poly1305_final_arch(struct poly1305_desc_ctx *desc, u8 *digest)
+{
+	poly1305_final_generic(desc, digest);
+}
+EXPORT_SYMBOL(poly1305_final_arch);
 
 static int crypto_poly1305_init(struct shash_desc *desc)
 {
@@ -171,6 +187,15 @@ static int crypto_poly1305_final(struct shash_desc *desc, u8 *dst)
 	return 0;
 }
 
+static int poly1305_simd_update(struct shash_desc *desc,
+				const u8 *src, unsigned int srclen)
+{
+	struct poly1305_desc_ctx *dctx = shash_desc_ctx(desc);
+
+	poly1305_update_arch(dctx, src, srclen);
+	return 0;
+}
+
 static struct shash_alg alg = {
 	.digestsize	= POLY1305_DIGEST_SIZE,
 	.init		= crypto_poly1305_init,
@@ -189,15 +214,15 @@ static struct shash_alg alg = {
 static int __init poly1305_simd_mod_init(void)
 {
 	if (!boot_cpu_has(X86_FEATURE_XMM2))
-		return -ENODEV;
-
-	poly1305_use_avx2 = IS_ENABLED(CONFIG_AS_AVX2) &&
-			    boot_cpu_has(X86_FEATURE_AVX) &&
-			    boot_cpu_has(X86_FEATURE_AVX2) &&
-			    cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM, NULL);
-	alg.descsize = sizeof(struct poly1305_desc_ctx) + 5 * sizeof(u32);
-	if (poly1305_use_avx2)
-		alg.descsize += 10 * sizeof(u32);
+		return 0;
+
+	static_branch_enable(&poly1305_use_simd);
+
+	if (IS_ENABLED(CONFIG_AS_AVX2) &&
+	    boot_cpu_has(X86_FEATURE_AVX) &&
+	    boot_cpu_has(X86_FEATURE_AVX2) &&
+	    cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM, NULL))
+		static_branch_enable(&poly1305_use_avx2);
 
 	return crypto_register_shash(&alg);
 }
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 2c7327a5b28e..7aa4310713cf 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -715,6 +715,7 @@ config CRYPTO_POLY1305_X86_64
 	tristate "Poly1305 authenticator algorithm (x86_64/SSE2/AVX2)"
 	depends on X86 && 64BIT
 	select CRYPTO_LIB_POLY1305_GENERIC
+	select CRYPTO_ARCH_HAVE_LIB_POLY1305
 	help
 	  Poly1305 authenticator algorithm, RFC7539.
 
diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index a731ea36bd5c..181754615f73 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -39,6 +39,7 @@ config CRYPTO_LIB_DES
 
 config CRYPTO_LIB_POLY1305_RSIZE
 	int
+	default 4 if X86_64
 	default 1
 
 config CRYPTO_ARCH_HAVE_LIB_POLY1305
-- 
2.20.1

