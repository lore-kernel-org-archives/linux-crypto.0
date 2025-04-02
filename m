Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF39CBA4A;
	Wed,  2 Apr 2025 00:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743553484; cv=none; b=kmM3RjgAg4S7YIDjapstsptru3HZkwIcpYeTjkhcMLyQYTz3U7dyAYbjn6jB3VZFGGLvV8XoSApxobIDWuWFBcuzHI8VpCmA7+RK+lt0dTl+13UtpsSZLgtwmJhx1szGru4+lfsYJFKuIAWDDqbEuosg1ZOVvyKCfhOfktEv8BI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743553484; c=relaxed/simple;
	bh=ZuNv+a/c1q4UM2OWiRA6sn/cDZSxjti9yEaGhk8OnRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RoTCDeXZ+IhPWhaHkbC9WjLP57UpWicuFCJvGRe2IBOXqqO5PxKyiFa6znTS3YfJWnBbunGMe3i7kc3CmzneATMJGX5r13y5imhPF8qfydtEp+kRRKgIPQVeypuISuc9zvwG2VTzBM5jZ8ITX7/6CmK4h3H7X268rhVZuy14SK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CpsKoEff; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CpsKoEff"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44C6AC4CEE9;
	Wed,  2 Apr 2025 00:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743553484;
	bh=ZuNv+a/c1q4UM2OWiRA6sn/cDZSxjti9yEaGhk8OnRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CpsKoEffiZHN8FQn9os8k5ylRDn5m1mfbKMExE+gHZbFKo6mSIUoRd59i4AROAbIX
	 d0v8XbvJX77072XqUyPF4yr7+2lpJN7Lb8ngKB9ckXjQX5nU3dDKXfo1orDDMbrWkS
	 UhjPyQu2whuGcXs9+WIOs0Gb7U839kJfQ5KGz78pMZD4tgSqs0cLjyPjlhYxC9PG+b
	 7Yfep+JIUWwrDADusjkP8EFhbDS9VCJvt0+8blSdCEjfXRgBaMz5bOtTvjcZPVIGIq
	 3M2wztJVEZPjgpcYYYDCm32cVexVmprS/PLcmRGCQsxr6IoiZ4jtV8Fft46Lfr/F5y
	 Mqabx/8CEDtpw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH v2 4/9] crypto: x86/aria - stop using the SIMD helper
Date: Tue,  1 Apr 2025 17:24:04 -0700
Message-ID: <20250402002420.89233-5-ebiggers@kernel.org>
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
 arch/x86/crypto/Kconfig                 |  3 ---
 arch/x86/crypto/aria_aesni_avx2_glue.c  | 22 +++++++---------------
 arch/x86/crypto/aria_aesni_avx_glue.c   | 20 ++++++--------------
 arch/x86/crypto/aria_gfni_avx512_glue.c | 22 +++++++---------------
 4 files changed, 20 insertions(+), 47 deletions(-)

diff --git a/arch/x86/crypto/Kconfig b/arch/x86/crypto/Kconfig
index d8f9d6279cb26..ad00d53ab83d8 100644
--- a/arch/x86/crypto/Kconfig
+++ b/arch/x86/crypto/Kconfig
@@ -294,11 +294,10 @@ config CRYPTO_TWOFISH_AVX_X86_64
 
 config CRYPTO_ARIA_AESNI_AVX_X86_64
 	tristate "Ciphers: ARIA with modes: ECB, CTR (AES-NI/AVX/GFNI)"
 	depends on X86 && 64BIT
 	select CRYPTO_SKCIPHER
-	select CRYPTO_SIMD
 	select CRYPTO_ALGAPI
 	select CRYPTO_ARIA
 	help
 	  Length-preserving cipher: ARIA cipher algorithms
 	  (RFC 5794) with ECB and CTR modes
@@ -312,11 +311,10 @@ config CRYPTO_ARIA_AESNI_AVX_X86_64
 
 config CRYPTO_ARIA_AESNI_AVX2_X86_64
 	tristate "Ciphers: ARIA with modes: ECB, CTR (AES-NI/AVX2/GFNI)"
 	depends on X86 && 64BIT
 	select CRYPTO_SKCIPHER
-	select CRYPTO_SIMD
 	select CRYPTO_ALGAPI
 	select CRYPTO_ARIA
 	select CRYPTO_ARIA_AESNI_AVX_X86_64
 	help
 	  Length-preserving cipher: ARIA cipher algorithms
@@ -331,11 +329,10 @@ config CRYPTO_ARIA_AESNI_AVX2_X86_64
 
 config CRYPTO_ARIA_GFNI_AVX512_X86_64
 	tristate "Ciphers: ARIA with modes: ECB, CTR (AVX512/GFNI)"
 	depends on X86 && 64BIT && AS_AVX512 && AS_GFNI
 	select CRYPTO_SKCIPHER
-	select CRYPTO_SIMD
 	select CRYPTO_ALGAPI
 	select CRYPTO_ARIA
 	select CRYPTO_ARIA_AESNI_AVX_X86_64
 	select CRYPTO_ARIA_AESNI_AVX2_X86_64
 	help
diff --git a/arch/x86/crypto/aria_aesni_avx2_glue.c b/arch/x86/crypto/aria_aesni_avx2_glue.c
index 87a11804fc77f..b4bddcd584577 100644
--- a/arch/x86/crypto/aria_aesni_avx2_glue.c
+++ b/arch/x86/crypto/aria_aesni_avx2_glue.c
@@ -4,11 +4,10 @@
  *
  * Copyright (c) 2022 Taehee Yoo <ap420073@gmail.com>
  */
 
 #include <crypto/algapi.h>
-#include <crypto/internal/simd.h>
 #include <crypto/aria.h>
 #include <linux/crypto.h>
 #include <linux/err.h>
 #include <linux/module.h>
 #include <linux/types.h>
@@ -163,28 +162,26 @@ static int aria_avx2_init_tfm(struct crypto_skcipher *tfm)
 	return 0;
 }
 
 static struct skcipher_alg aria_algs[] = {
 	{
-		.base.cra_name		= "__ecb(aria)",
-		.base.cra_driver_name	= "__ecb-aria-avx2",
+		.base.cra_name		= "ecb(aria)",
+		.base.cra_driver_name	= "ecb-aria-avx2",
 		.base.cra_priority	= 500,
-		.base.cra_flags		= CRYPTO_ALG_INTERNAL,
 		.base.cra_blocksize	= ARIA_BLOCK_SIZE,
 		.base.cra_ctxsize	= sizeof(struct aria_ctx),
 		.base.cra_module	= THIS_MODULE,
 		.min_keysize		= ARIA_MIN_KEY_SIZE,
 		.max_keysize		= ARIA_MAX_KEY_SIZE,
 		.setkey			= aria_avx2_set_key,
 		.encrypt		= aria_avx2_ecb_encrypt,
 		.decrypt		= aria_avx2_ecb_decrypt,
 	}, {
-		.base.cra_name		= "__ctr(aria)",
-		.base.cra_driver_name	= "__ctr-aria-avx2",
+		.base.cra_name		= "ctr(aria)",
+		.base.cra_driver_name	= "ctr-aria-avx2",
 		.base.cra_priority	= 500,
-		.base.cra_flags		= CRYPTO_ALG_INTERNAL |
-					  CRYPTO_ALG_SKCIPHER_REQSIZE_LARGE,
+		.base.cra_flags		= CRYPTO_ALG_SKCIPHER_REQSIZE_LARGE,
 		.base.cra_blocksize	= 1,
 		.base.cra_ctxsize	= sizeof(struct aria_ctx),
 		.base.cra_module	= THIS_MODULE,
 		.min_keysize		= ARIA_MIN_KEY_SIZE,
 		.max_keysize		= ARIA_MAX_KEY_SIZE,
@@ -195,12 +192,10 @@ static struct skcipher_alg aria_algs[] = {
 		.decrypt		= aria_avx2_ctr_encrypt,
 		.init                   = aria_avx2_init_tfm,
 	}
 };
 
-static struct simd_skcipher_alg *aria_simd_algs[ARRAY_SIZE(aria_algs)];
-
 static int __init aria_avx2_init(void)
 {
 	const char *feature_name;
 
 	if (!boot_cpu_has(X86_FEATURE_AVX) ||
@@ -231,19 +226,16 @@ static int __init aria_avx2_init(void)
 		aria_ops.aria_encrypt_32way = aria_aesni_avx2_encrypt_32way;
 		aria_ops.aria_decrypt_32way = aria_aesni_avx2_decrypt_32way;
 		aria_ops.aria_ctr_crypt_32way = aria_aesni_avx2_ctr_crypt_32way;
 	}
 
-	return simd_register_skciphers_compat(aria_algs,
-					      ARRAY_SIZE(aria_algs),
-					      aria_simd_algs);
+	return crypto_register_skciphers(aria_algs, ARRAY_SIZE(aria_algs));
 }
 
 static void __exit aria_avx2_exit(void)
 {
-	simd_unregister_skciphers(aria_algs, ARRAY_SIZE(aria_algs),
-				  aria_simd_algs);
+	crypto_unregister_skciphers(aria_algs, ARRAY_SIZE(aria_algs));
 }
 
 module_init(aria_avx2_init);
 module_exit(aria_avx2_exit);
 
diff --git a/arch/x86/crypto/aria_aesni_avx_glue.c b/arch/x86/crypto/aria_aesni_avx_glue.c
index 4e1516b76669e..ab9b38d05332a 100644
--- a/arch/x86/crypto/aria_aesni_avx_glue.c
+++ b/arch/x86/crypto/aria_aesni_avx_glue.c
@@ -4,11 +4,10 @@
  *
  * Copyright (c) 2022 Taehee Yoo <ap420073@gmail.com>
  */
 
 #include <crypto/algapi.h>
-#include <crypto/internal/simd.h>
 #include <crypto/aria.h>
 #include <linux/crypto.h>
 #include <linux/err.h>
 #include <linux/module.h>
 #include <linux/types.h>
@@ -150,27 +149,25 @@ static int aria_avx_init_tfm(struct crypto_skcipher *tfm)
 	return 0;
 }
 
 static struct skcipher_alg aria_algs[] = {
 	{
-		.base.cra_name		= "__ecb(aria)",
-		.base.cra_driver_name	= "__ecb-aria-avx",
+		.base.cra_name		= "ecb(aria)",
+		.base.cra_driver_name	= "ecb-aria-avx",
 		.base.cra_priority	= 400,
-		.base.cra_flags		= CRYPTO_ALG_INTERNAL,
 		.base.cra_blocksize	= ARIA_BLOCK_SIZE,
 		.base.cra_ctxsize	= sizeof(struct aria_ctx),
 		.base.cra_module	= THIS_MODULE,
 		.min_keysize		= ARIA_MIN_KEY_SIZE,
 		.max_keysize		= ARIA_MAX_KEY_SIZE,
 		.setkey			= aria_avx_set_key,
 		.encrypt		= aria_avx_ecb_encrypt,
 		.decrypt		= aria_avx_ecb_decrypt,
 	}, {
-		.base.cra_name		= "__ctr(aria)",
-		.base.cra_driver_name	= "__ctr-aria-avx",
+		.base.cra_name		= "ctr(aria)",
+		.base.cra_driver_name	= "ctr-aria-avx",
 		.base.cra_priority	= 400,
-		.base.cra_flags		= CRYPTO_ALG_INTERNAL,
 		.base.cra_blocksize	= 1,
 		.base.cra_ctxsize	= sizeof(struct aria_ctx),
 		.base.cra_module	= THIS_MODULE,
 		.min_keysize		= ARIA_MIN_KEY_SIZE,
 		.max_keysize		= ARIA_MAX_KEY_SIZE,
@@ -182,12 +179,10 @@ static struct skcipher_alg aria_algs[] = {
 		.decrypt		= aria_avx_ctr_encrypt,
 		.init			= aria_avx_init_tfm,
 	}
 };
 
-static struct simd_skcipher_alg *aria_simd_algs[ARRAY_SIZE(aria_algs)];
-
 static int __init aria_avx_init(void)
 {
 	const char *feature_name;
 
 	if (!boot_cpu_has(X86_FEATURE_AVX) ||
@@ -211,19 +206,16 @@ static int __init aria_avx_init(void)
 		aria_ops.aria_encrypt_16way = aria_aesni_avx_encrypt_16way;
 		aria_ops.aria_decrypt_16way = aria_aesni_avx_decrypt_16way;
 		aria_ops.aria_ctr_crypt_16way = aria_aesni_avx_ctr_crypt_16way;
 	}
 
-	return simd_register_skciphers_compat(aria_algs,
-					      ARRAY_SIZE(aria_algs),
-					      aria_simd_algs);
+	return crypto_register_skciphers(aria_algs, ARRAY_SIZE(aria_algs));
 }
 
 static void __exit aria_avx_exit(void)
 {
-	simd_unregister_skciphers(aria_algs, ARRAY_SIZE(aria_algs),
-				  aria_simd_algs);
+	crypto_unregister_skciphers(aria_algs, ARRAY_SIZE(aria_algs));
 }
 
 module_init(aria_avx_init);
 module_exit(aria_avx_exit);
 
diff --git a/arch/x86/crypto/aria_gfni_avx512_glue.c b/arch/x86/crypto/aria_gfni_avx512_glue.c
index f4a2208d26383..363cbf4399cca 100644
--- a/arch/x86/crypto/aria_gfni_avx512_glue.c
+++ b/arch/x86/crypto/aria_gfni_avx512_glue.c
@@ -4,11 +4,10 @@
  *
  * Copyright (c) 2022 Taehee Yoo <ap420073@gmail.com>
  */
 
 #include <crypto/algapi.h>
-#include <crypto/internal/simd.h>
 #include <crypto/aria.h>
 #include <linux/crypto.h>
 #include <linux/err.h>
 #include <linux/module.h>
 #include <linux/types.h>
@@ -163,28 +162,26 @@ static int aria_avx512_init_tfm(struct crypto_skcipher *tfm)
 	return 0;
 }
 
 static struct skcipher_alg aria_algs[] = {
 	{
-		.base.cra_name		= "__ecb(aria)",
-		.base.cra_driver_name	= "__ecb-aria-avx512",
+		.base.cra_name		= "ecb(aria)",
+		.base.cra_driver_name	= "ecb-aria-avx512",
 		.base.cra_priority	= 600,
-		.base.cra_flags		= CRYPTO_ALG_INTERNAL,
 		.base.cra_blocksize	= ARIA_BLOCK_SIZE,
 		.base.cra_ctxsize	= sizeof(struct aria_ctx),
 		.base.cra_module	= THIS_MODULE,
 		.min_keysize		= ARIA_MIN_KEY_SIZE,
 		.max_keysize		= ARIA_MAX_KEY_SIZE,
 		.setkey			= aria_avx512_set_key,
 		.encrypt		= aria_avx512_ecb_encrypt,
 		.decrypt		= aria_avx512_ecb_decrypt,
 	}, {
-		.base.cra_name		= "__ctr(aria)",
-		.base.cra_driver_name	= "__ctr-aria-avx512",
+		.base.cra_name		= "ctr(aria)",
+		.base.cra_driver_name	= "ctr-aria-avx512",
 		.base.cra_priority	= 600,
-		.base.cra_flags		= CRYPTO_ALG_INTERNAL |
-					  CRYPTO_ALG_SKCIPHER_REQSIZE_LARGE,
+		.base.cra_flags		= CRYPTO_ALG_SKCIPHER_REQSIZE_LARGE,
 		.base.cra_blocksize	= 1,
 		.base.cra_ctxsize	= sizeof(struct aria_ctx),
 		.base.cra_module	= THIS_MODULE,
 		.min_keysize		= ARIA_MIN_KEY_SIZE,
 		.max_keysize		= ARIA_MAX_KEY_SIZE,
@@ -195,12 +192,10 @@ static struct skcipher_alg aria_algs[] = {
 		.decrypt		= aria_avx512_ctr_encrypt,
 		.init                   = aria_avx512_init_tfm,
 	}
 };
 
-static struct simd_skcipher_alg *aria_simd_algs[ARRAY_SIZE(aria_algs)];
-
 static int __init aria_avx512_init(void)
 {
 	const char *feature_name;
 
 	if (!boot_cpu_has(X86_FEATURE_AVX) ||
@@ -227,19 +222,16 @@ static int __init aria_avx512_init(void)
 	aria_ops.aria_ctr_crypt_32way = aria_aesni_avx2_gfni_ctr_crypt_32way;
 	aria_ops.aria_encrypt_64way = aria_gfni_avx512_encrypt_64way;
 	aria_ops.aria_decrypt_64way = aria_gfni_avx512_decrypt_64way;
 	aria_ops.aria_ctr_crypt_64way = aria_gfni_avx512_ctr_crypt_64way;
 
-	return simd_register_skciphers_compat(aria_algs,
-					      ARRAY_SIZE(aria_algs),
-					      aria_simd_algs);
+	return crypto_register_skciphers(aria_algs, ARRAY_SIZE(aria_algs));
 }
 
 static void __exit aria_avx512_exit(void)
 {
-	simd_unregister_skciphers(aria_algs, ARRAY_SIZE(aria_algs),
-				  aria_simd_algs);
+	crypto_unregister_skciphers(aria_algs, ARRAY_SIZE(aria_algs));
 }
 
 module_init(aria_avx512_init);
 module_exit(aria_avx512_exit);
 
-- 
2.49.0

