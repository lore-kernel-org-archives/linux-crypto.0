Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B15B318B03;
	Wed,  2 Apr 2025 00:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743553485; cv=none; b=X/H6ha4go5XTFhNEwIN5D4dbIltxsxARnhj8JMTOBR8zKQ1Es3M0vWEpG6ejCOifa680G35ozuuDPArzjBKl9+hOYu6EOVe6YP7VqcCcu5YSGKe0+wpH22+FhFaBlpEYcmOTkfx5xiZfYhJEMMJ/I1vOgo5FJ9wXBPxwPcIPCC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743553485; c=relaxed/simple;
	bh=zYXVrACKxXZq0vfVOF20JWzd9UJmCmoup7dXjgoxdfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jSGlhe/Rny+JiaAgtVviKk40/60m/l1jP0/fBUg+fpQUjCeTIvbhOMmF4WEtiJ8gixlRyLmTEFAXbI0d0z+zQvXUkfBeSBX8iXyCJieng41rIdOjr4/zaDRbKoqiM98sUzI83JiqhybnD2k7lQM5dqdH8q2zdlqr+MebrxqtNhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mM05EjOu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mM05EjOu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DE05C4CEEE;
	Wed,  2 Apr 2025 00:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743553485;
	bh=zYXVrACKxXZq0vfVOF20JWzd9UJmCmoup7dXjgoxdfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mM05EjOu8yN1MWHIWMvWBw9tPeITDSCjLMk3aYAE3fbGqJQP2pN/0z0stJHODoen+
	 ffW/Y1aFgCbbZPcKPpPJqXNaOkjJjgogzIYYEylTyUMZ26RelpWVOGEOinIHVaa7zO
	 yZr48CMJtJZtOMxq5QzZvg1OIGv1JzWnvWxYn16W+wTH4uVjkT/b7Qkq5sWUoLjBe8
	 Se97dYKUpuQEzPg0uBudoXxpLQzf7/p0oVxe56rIZXfRM0TRoYCwhPpgoPDvk6yCLf
	 Len0VMbmImLn6UwERsoYYdub11IUFzckH1adT626QSpgA/xWtkPQ1VImIHk53DKI6x
	 iZ5iy6IBmy4OA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH v2 7/9] crypto: x86/serpent - stop using the SIMD helper
Date: Tue,  1 Apr 2025 17:24:07 -0700
Message-ID: <20250402002420.89233-8-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250402002420.89233-1-ebiggers@kernel.org>
References: <20250402002420.89233-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Stop wrapping skcipher and aead algorithms with the crypto SIMD helper
(crypto/simd.c).  The only purpose of doing so was to work around x86
not always supporting kernel-mode FPU in softirqs.  Specifically, if a
hardirq interrupted a task context kernel-mode FPU section and then a
softirqs were run at the end of that hardirq, those softirqs could not
use kernel-mode FPU.  This has now been fixed.  In combination with the
fact that the skcipher and aead APIs only support task and softirq
contexts, these can now just use kernel-mode FPU unconditionally on x86.

This simplifies the code and improves performance.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/Kconfig             |  3 ---
 arch/x86/crypto/serpent_avx2_glue.c | 21 +++++++--------------
 arch/x86/crypto/serpent_avx_glue.c  | 21 +++++++--------------
 arch/x86/crypto/serpent_sse2_glue.c | 21 +++++++--------------
 4 files changed, 21 insertions(+), 45 deletions(-)

diff --git a/arch/x86/crypto/Kconfig b/arch/x86/crypto/Kconfig
index 55800d1ce668e..51c74a496126d 100644
--- a/arch/x86/crypto/Kconfig
+++ b/arch/x86/crypto/Kconfig
@@ -132,11 +132,10 @@ config CRYPTO_DES3_EDE_X86_64
 config CRYPTO_SERPENT_SSE2_X86_64
 	tristate "Ciphers: Serpent with modes: ECB, CBC (SSE2)"
 	depends on X86 && 64BIT
 	select CRYPTO_SKCIPHER
 	select CRYPTO_SERPENT
-	select CRYPTO_SIMD
 	imply CRYPTO_CTR
 	help
 	  Length-preserving ciphers: Serpent cipher algorithm
 	  with ECB and CBC modes
 
@@ -148,11 +147,10 @@ config CRYPTO_SERPENT_SSE2_X86_64
 config CRYPTO_SERPENT_SSE2_586
 	tristate "Ciphers: Serpent with modes: ECB, CBC (32-bit with SSE2)"
 	depends on X86 && !64BIT
 	select CRYPTO_SKCIPHER
 	select CRYPTO_SERPENT
-	select CRYPTO_SIMD
 	imply CRYPTO_CTR
 	help
 	  Length-preserving ciphers: Serpent cipher algorithm
 	  with ECB and CBC modes
 
@@ -164,11 +162,10 @@ config CRYPTO_SERPENT_SSE2_586
 config CRYPTO_SERPENT_AVX_X86_64
 	tristate "Ciphers: Serpent with modes: ECB, CBC (AVX)"
 	depends on X86 && 64BIT
 	select CRYPTO_SKCIPHER
 	select CRYPTO_SERPENT
-	select CRYPTO_SIMD
 	imply CRYPTO_XTS
 	imply CRYPTO_CTR
 	help
 	  Length-preserving ciphers: Serpent cipher algorithm
 	  with ECB and CBC modes
diff --git a/arch/x86/crypto/serpent_avx2_glue.c b/arch/x86/crypto/serpent_avx2_glue.c
index 347e97f4b713b..f5f2121b79567 100644
--- a/arch/x86/crypto/serpent_avx2_glue.c
+++ b/arch/x86/crypto/serpent_avx2_glue.c
@@ -8,11 +8,10 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/crypto.h>
 #include <linux/err.h>
 #include <crypto/algapi.h>
-#include <crypto/internal/simd.h>
 #include <crypto/serpent.h>
 
 #include "serpent-avx.h"
 #include "ecb_cbc_helpers.h"
 
@@ -63,27 +62,25 @@ static int cbc_decrypt(struct skcipher_request *req)
 	CBC_WALK_END();
 }
 
 static struct skcipher_alg serpent_algs[] = {
 	{
-		.base.cra_name		= "__ecb(serpent)",
-		.base.cra_driver_name	= "__ecb-serpent-avx2",
+		.base.cra_name		= "ecb(serpent)",
+		.base.cra_driver_name	= "ecb-serpent-avx2",
 		.base.cra_priority	= 600,
-		.base.cra_flags		= CRYPTO_ALG_INTERNAL,
 		.base.cra_blocksize	= SERPENT_BLOCK_SIZE,
 		.base.cra_ctxsize	= sizeof(struct serpent_ctx),
 		.base.cra_module	= THIS_MODULE,
 		.min_keysize		= SERPENT_MIN_KEY_SIZE,
 		.max_keysize		= SERPENT_MAX_KEY_SIZE,
 		.setkey			= serpent_setkey_skcipher,
 		.encrypt		= ecb_encrypt,
 		.decrypt		= ecb_decrypt,
 	}, {
-		.base.cra_name		= "__cbc(serpent)",
-		.base.cra_driver_name	= "__cbc-serpent-avx2",
+		.base.cra_name		= "cbc(serpent)",
+		.base.cra_driver_name	= "cbc-serpent-avx2",
 		.base.cra_priority	= 600,
-		.base.cra_flags		= CRYPTO_ALG_INTERNAL,
 		.base.cra_blocksize	= SERPENT_BLOCK_SIZE,
 		.base.cra_ctxsize	= sizeof(struct serpent_ctx),
 		.base.cra_module	= THIS_MODULE,
 		.min_keysize		= SERPENT_MIN_KEY_SIZE,
 		.max_keysize		= SERPENT_MAX_KEY_SIZE,
@@ -92,12 +89,10 @@ static struct skcipher_alg serpent_algs[] = {
 		.encrypt		= cbc_encrypt,
 		.decrypt		= cbc_decrypt,
 	},
 };
 
-static struct simd_skcipher_alg *serpent_simd_algs[ARRAY_SIZE(serpent_algs)];
-
 static int __init serpent_avx2_init(void)
 {
 	const char *feature_name;
 
 	if (!boot_cpu_has(X86_FEATURE_AVX2) || !boot_cpu_has(X86_FEATURE_OSXSAVE)) {
@@ -108,19 +103,17 @@ static int __init serpent_avx2_init(void)
 				&feature_name)) {
 		pr_info("CPU feature '%s' is not supported.\n", feature_name);
 		return -ENODEV;
 	}
 
-	return simd_register_skciphers_compat(serpent_algs,
-					      ARRAY_SIZE(serpent_algs),
-					      serpent_simd_algs);
+	return crypto_register_skciphers(serpent_algs,
+					 ARRAY_SIZE(serpent_algs));
 }
 
 static void __exit serpent_avx2_fini(void)
 {
-	simd_unregister_skciphers(serpent_algs, ARRAY_SIZE(serpent_algs),
-				  serpent_simd_algs);
+	crypto_unregister_skciphers(serpent_algs, ARRAY_SIZE(serpent_algs));
 }
 
 module_init(serpent_avx2_init);
 module_exit(serpent_avx2_fini);
 
diff --git a/arch/x86/crypto/serpent_avx_glue.c b/arch/x86/crypto/serpent_avx_glue.c
index 6c248e1ea4ef7..e640abc1cb8a7 100644
--- a/arch/x86/crypto/serpent_avx_glue.c
+++ b/arch/x86/crypto/serpent_avx_glue.c
@@ -11,11 +11,10 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/crypto.h>
 #include <linux/err.h>
 #include <crypto/algapi.h>
-#include <crypto/internal/simd.h>
 #include <crypto/serpent.h>
 
 #include "serpent-avx.h"
 #include "ecb_cbc_helpers.h"
 
@@ -69,27 +68,25 @@ static int cbc_decrypt(struct skcipher_request *req)
 	CBC_WALK_END();
 }
 
 static struct skcipher_alg serpent_algs[] = {
 	{
-		.base.cra_name		= "__ecb(serpent)",
-		.base.cra_driver_name	= "__ecb-serpent-avx",
+		.base.cra_name		= "ecb(serpent)",
+		.base.cra_driver_name	= "ecb-serpent-avx",
 		.base.cra_priority	= 500,
-		.base.cra_flags		= CRYPTO_ALG_INTERNAL,
 		.base.cra_blocksize	= SERPENT_BLOCK_SIZE,
 		.base.cra_ctxsize	= sizeof(struct serpent_ctx),
 		.base.cra_module	= THIS_MODULE,
 		.min_keysize		= SERPENT_MIN_KEY_SIZE,
 		.max_keysize		= SERPENT_MAX_KEY_SIZE,
 		.setkey			= serpent_setkey_skcipher,
 		.encrypt		= ecb_encrypt,
 		.decrypt		= ecb_decrypt,
 	}, {
-		.base.cra_name		= "__cbc(serpent)",
-		.base.cra_driver_name	= "__cbc-serpent-avx",
+		.base.cra_name		= "cbc(serpent)",
+		.base.cra_driver_name	= "cbc-serpent-avx",
 		.base.cra_priority	= 500,
-		.base.cra_flags		= CRYPTO_ALG_INTERNAL,
 		.base.cra_blocksize	= SERPENT_BLOCK_SIZE,
 		.base.cra_ctxsize	= sizeof(struct serpent_ctx),
 		.base.cra_module	= THIS_MODULE,
 		.min_keysize		= SERPENT_MIN_KEY_SIZE,
 		.max_keysize		= SERPENT_MAX_KEY_SIZE,
@@ -98,31 +95,27 @@ static struct skcipher_alg serpent_algs[] = {
 		.encrypt		= cbc_encrypt,
 		.decrypt		= cbc_decrypt,
 	},
 };
 
-static struct simd_skcipher_alg *serpent_simd_algs[ARRAY_SIZE(serpent_algs)];
-
 static int __init serpent_init(void)
 {
 	const char *feature_name;
 
 	if (!cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM,
 				&feature_name)) {
 		pr_info("CPU feature '%s' is not supported.\n", feature_name);
 		return -ENODEV;
 	}
 
-	return simd_register_skciphers_compat(serpent_algs,
-					      ARRAY_SIZE(serpent_algs),
-					      serpent_simd_algs);
+	return crypto_register_skciphers(serpent_algs,
+					 ARRAY_SIZE(serpent_algs));
 }
 
 static void __exit serpent_exit(void)
 {
-	simd_unregister_skciphers(serpent_algs, ARRAY_SIZE(serpent_algs),
-				  serpent_simd_algs);
+	crypto_unregister_skciphers(serpent_algs, ARRAY_SIZE(serpent_algs));
 }
 
 module_init(serpent_init);
 module_exit(serpent_exit);
 
diff --git a/arch/x86/crypto/serpent_sse2_glue.c b/arch/x86/crypto/serpent_sse2_glue.c
index d78f37e9b2cf7..80ee17ec21b46 100644
--- a/arch/x86/crypto/serpent_sse2_glue.c
+++ b/arch/x86/crypto/serpent_sse2_glue.c
@@ -16,11 +16,10 @@
 #include <linux/types.h>
 #include <linux/crypto.h>
 #include <linux/err.h>
 #include <crypto/algapi.h>
 #include <crypto/b128ops.h>
-#include <crypto/internal/simd.h>
 #include <crypto/serpent.h>
 
 #include "serpent-sse2.h"
 #include "ecb_cbc_helpers.h"
 
@@ -72,27 +71,25 @@ static int cbc_decrypt(struct skcipher_request *req)
 	CBC_WALK_END();
 }
 
 static struct skcipher_alg serpent_algs[] = {
 	{
-		.base.cra_name		= "__ecb(serpent)",
-		.base.cra_driver_name	= "__ecb-serpent-sse2",
+		.base.cra_name		= "ecb(serpent)",
+		.base.cra_driver_name	= "ecb-serpent-sse2",
 		.base.cra_priority	= 400,
-		.base.cra_flags		= CRYPTO_ALG_INTERNAL,
 		.base.cra_blocksize	= SERPENT_BLOCK_SIZE,
 		.base.cra_ctxsize	= sizeof(struct serpent_ctx),
 		.base.cra_module	= THIS_MODULE,
 		.min_keysize		= SERPENT_MIN_KEY_SIZE,
 		.max_keysize		= SERPENT_MAX_KEY_SIZE,
 		.setkey			= serpent_setkey_skcipher,
 		.encrypt		= ecb_encrypt,
 		.decrypt		= ecb_decrypt,
 	}, {
-		.base.cra_name		= "__cbc(serpent)",
-		.base.cra_driver_name	= "__cbc-serpent-sse2",
+		.base.cra_name		= "cbc(serpent)",
+		.base.cra_driver_name	= "cbc-serpent-sse2",
 		.base.cra_priority	= 400,
-		.base.cra_flags		= CRYPTO_ALG_INTERNAL,
 		.base.cra_blocksize	= SERPENT_BLOCK_SIZE,
 		.base.cra_ctxsize	= sizeof(struct serpent_ctx),
 		.base.cra_module	= THIS_MODULE,
 		.min_keysize		= SERPENT_MIN_KEY_SIZE,
 		.max_keysize		= SERPENT_MAX_KEY_SIZE,
@@ -101,28 +98,24 @@ static struct skcipher_alg serpent_algs[] = {
 		.encrypt		= cbc_encrypt,
 		.decrypt		= cbc_decrypt,
 	},
 };
 
-static struct simd_skcipher_alg *serpent_simd_algs[ARRAY_SIZE(serpent_algs)];
-
 static int __init serpent_sse2_init(void)
 {
 	if (!boot_cpu_has(X86_FEATURE_XMM2)) {
 		printk(KERN_INFO "SSE2 instructions are not detected.\n");
 		return -ENODEV;
 	}
 
-	return simd_register_skciphers_compat(serpent_algs,
-					      ARRAY_SIZE(serpent_algs),
-					      serpent_simd_algs);
+	return crypto_register_skciphers(serpent_algs,
+					 ARRAY_SIZE(serpent_algs));
 }
 
 static void __exit serpent_sse2_exit(void)
 {
-	simd_unregister_skciphers(serpent_algs, ARRAY_SIZE(serpent_algs),
-				  serpent_simd_algs);
+	crypto_unregister_skciphers(serpent_algs, ARRAY_SIZE(serpent_algs));
 }
 
 module_init(serpent_sse2_init);
 module_exit(serpent_sse2_exit);
 
-- 
2.49.0

