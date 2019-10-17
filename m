Return-Path: <SRS0=Ic7o=YK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F94BECE58E
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Oct 2019 19:10:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F06621835
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Oct 2019 19:10:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Q77SvaEf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503322AbfJQTKX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Oct 2019 15:10:23 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40154 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503389AbfJQTKV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Oct 2019 15:10:21 -0400
Received: by mail-wm1-f65.google.com with SMTP id b24so3669633wmj.5
        for <linux-crypto@vger.kernel.org>; Thu, 17 Oct 2019 12:10:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4gtd4V8gTJz0bBQZsF5rprEvv7fHy66kyVWWSiMwnvE=;
        b=Q77SvaEfuvgp7C5VifuGwbB6zfvDzpOWHvWq35N3mIo0h9svwrm48N0vZH+JvvNpIe
         dm4O1e789EcKibORZyPfjxxWB1g/3NI8paSLCS/ZpLDMYm1okvOAAg7t4sUZ5THOb3Jq
         HDs3L6pBGasE5tzn0B8N8CTLpxy1P7hA3N/C5LRoblZL8XQdzFJi9JDQCMxymSdb2c18
         8vLLCQeg7bbm2ufMhv2FVHhPS1DtrMEtRWnm+y7UHQfNUnbJZr57W9ci7lFBAbvN4mEv
         JXYC3nKA3M1C94WmYPKCmnJfBlOzwKrUyI/0Ws20vCeVCEiM80hMJu9eyJcFt/86VuJD
         12fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4gtd4V8gTJz0bBQZsF5rprEvv7fHy66kyVWWSiMwnvE=;
        b=bHUQntutIsy4G2LB5Er9Ihczm9fxdojDLvbutqdsP0PIwn79IBRxALEW75jkO1B7+x
         hkB3Gz/n2lN/fNOTThs5qeJ1bDAlc/r62XQnfq9EWULww2rMc4r2hQcBLh97EdHjAgam
         gb3R+PUKTLZ7upQ/G1/G1lNgrKnq9HBXbX+C101kUyDa1LZRcW3gMFQSh51zVmbKnnfz
         lsY6akpK3MgyEgZhe23AUtXDslujfF/ydc39CVdV8iL8U9UCk4y+H6c3EkOxHsfVXQ8U
         KPtW89kRgUykIW9vul2AtiYSTxzVeQ8RAmp2+zeQtN+eyasEXKZN8ipxnyr+K8ZQe+iI
         kdOw==
X-Gm-Message-State: APjAAAUHbzosebSwM59QooWZIOFqCBu7D8sZItoHHWbiGt7/zm0qz8ya
        Vd3WpOsnOFc/TiMfRWo14/Jrn0Dch8ivnj2F
X-Google-Smtp-Source: APXvYqx4+fyt4CC3CWb2mfiPEqapY2ddeZhAmnoELHIJ7RZMCedku16XS9kGW59aQRdCohMudzThQA==
X-Received: by 2002:a05:600c:2295:: with SMTP id 21mr3985925wmf.106.1571339419116;
        Thu, 17 Oct 2019 12:10:19 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:ccb6:e9d4:c1bc:d107])
        by smtp.gmail.com with ESMTPSA id y3sm5124528wro.36.2019.10.17.12.10.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Oct 2019 12:10:18 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Martin Willi <martin@strongswan.org>,
        Rene van Dorst <opensource@vdorst.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH v4 17/35] crypto: x86/poly1305 - expose existing driver as poly1305 library
Date:   Thu, 17 Oct 2019 21:09:14 +0200
Message-Id: <20191017190932.1947-18-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191017190932.1947-1-ard.biesheuvel@linaro.org>
References: <20191017190932.1947-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Implement the arch init/update/final Poly1305 library routines in the
accelerated SIMD driver for x86 so they are accessible to users of
the Poly1305 library interface as well.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
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
index 950cf1a8dfc0..325cd31f487f 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -698,6 +698,7 @@ config CRYPTO_POLY1305_X86_64
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

