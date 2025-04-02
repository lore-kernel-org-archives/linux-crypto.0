Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0794DDDDC;
	Wed,  2 Apr 2025 00:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743553485; cv=none; b=kOlfdWdb8K5Qs2ZU+li8UV0VMeqthHf1yfV0G80Qh34Oehf/wW/46C9lM7JW1yHw18ynJN1jFaNmkRL1gYs70oQMnChs6aqF6bvyA5cLjPj3u68av7R/nU3rNxSQQBFg+bq8Mtzwt+duNQukPxGMoabGKyRtE2/+RjL00B1nrps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743553485; c=relaxed/simple;
	bh=s3LVwFRmxTtaDF+Sq5wSnDzWCovB3mBA5G3HmPzTJsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y+hkON2LTfTFVKU8HQmeTpgwBLMmVM4iN+QLbDFFdyGNxYdyzI0nn8PY3aE5dw4uKvGOG10HG5EmZED5AkVA7gzJs8nQoHPEy4S2YLluEF9WjZZF49FzaI/mkYLEWpTRT+3hVN9HmVTC93fyHSPIcyf3JaGawnspNyDvVCRTNCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XjmLIJI7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XjmLIJI7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2593C4CEF5;
	Wed,  2 Apr 2025 00:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743553484;
	bh=s3LVwFRmxTtaDF+Sq5wSnDzWCovB3mBA5G3HmPzTJsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XjmLIJI7R/gUH6YjDXZHIt9p3ao1fCWGhOnxBwFuxL3uY3VHw0OHYMw/XWD9zQf5+
	 McNAdLpA9O/icbOkTZf1mfjb+rD+b3oKqwtWJ60lj8MXeRd1OjPPlaUxdV6unCCIAY
	 Jt1aJzhoSYc4Y4D4cMRUNsPiMM3zMpLMqEteoDvpf5r0h5Xyga0HeeJQ70ID5kiOMr
	 mxqxxHt3d+niehRlClbr7P21AFGVsTu8GY8gpeEq9FMMFexiDFr7+/sDdBbZKqufNH
	 JuhMNzhy2hRRCsNdTceXhkWTxFwrFS8q+EGhW64R6CBz3UBawkaUSK8QaDOA6T0zat
	 NneAv0tjfTM5Q==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH v2 6/9] crypto: x86/cast - stop using the SIMD helper
Date: Tue,  1 Apr 2025 17:24:06 -0700
Message-ID: <20250402002420.89233-7-ebiggers@kernel.org>
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
 arch/x86/crypto/Kconfig          |  2 --
 arch/x86/crypto/cast5_avx_glue.c | 21 +++++++--------------
 arch/x86/crypto/cast6_avx_glue.c | 20 ++++++--------------
 3 files changed, 13 insertions(+), 30 deletions(-)

diff --git a/arch/x86/crypto/Kconfig b/arch/x86/crypto/Kconfig
index de927df89ccf1..55800d1ce668e 100644
--- a/arch/x86/crypto/Kconfig
+++ b/arch/x86/crypto/Kconfig
@@ -86,11 +86,10 @@ config CRYPTO_CAST5_AVX_X86_64
 	tristate "Ciphers: CAST5 with modes: ECB, CBC (AVX)"
 	depends on X86 && 64BIT
 	select CRYPTO_SKCIPHER
 	select CRYPTO_CAST5
 	select CRYPTO_CAST_COMMON
-	select CRYPTO_SIMD
 	imply CRYPTO_CTR
 	help
 	  Length-preserving ciphers: CAST5 (CAST-128) cipher algorithm
 	  (RFC2144) with ECB and CBC modes
 
@@ -103,11 +102,10 @@ config CRYPTO_CAST6_AVX_X86_64
 	tristate "Ciphers: CAST6 with modes: ECB, CBC (AVX)"
 	depends on X86 && 64BIT
 	select CRYPTO_SKCIPHER
 	select CRYPTO_CAST6
 	select CRYPTO_CAST_COMMON
-	select CRYPTO_SIMD
 	imply CRYPTO_XTS
 	imply CRYPTO_CTR
 	help
 	  Length-preserving ciphers: CAST6 (CAST-256) cipher algorithm
 	  (RFC2612) with ECB and CBC modes
diff --git a/arch/x86/crypto/cast5_avx_glue.c b/arch/x86/crypto/cast5_avx_glue.c
index 3976a87f92ad5..3aca04d43b34a 100644
--- a/arch/x86/crypto/cast5_avx_glue.c
+++ b/arch/x86/crypto/cast5_avx_glue.c
@@ -6,11 +6,10 @@
  *     <Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
  */
 
 #include <crypto/algapi.h>
 #include <crypto/cast5.h>
-#include <crypto/internal/simd.h>
 #include <linux/crypto.h>
 #include <linux/err.h>
 #include <linux/module.h>
 #include <linux/types.h>
 
@@ -62,27 +61,25 @@ static int cbc_decrypt(struct skcipher_request *req)
 	CBC_WALK_END();
 }
 
 static struct skcipher_alg cast5_algs[] = {
 	{
-		.base.cra_name		= "__ecb(cast5)",
-		.base.cra_driver_name	= "__ecb-cast5-avx",
+		.base.cra_name		= "ecb(cast5)",
+		.base.cra_driver_name	= "ecb-cast5-avx",
 		.base.cra_priority	= 200,
-		.base.cra_flags		= CRYPTO_ALG_INTERNAL,
 		.base.cra_blocksize	= CAST5_BLOCK_SIZE,
 		.base.cra_ctxsize	= sizeof(struct cast5_ctx),
 		.base.cra_module	= THIS_MODULE,
 		.min_keysize		= CAST5_MIN_KEY_SIZE,
 		.max_keysize		= CAST5_MAX_KEY_SIZE,
 		.setkey			= cast5_setkey_skcipher,
 		.encrypt		= ecb_encrypt,
 		.decrypt		= ecb_decrypt,
 	}, {
-		.base.cra_name		= "__cbc(cast5)",
-		.base.cra_driver_name	= "__cbc-cast5-avx",
+		.base.cra_name		= "cbc(cast5)",
+		.base.cra_driver_name	= "cbc-cast5-avx",
 		.base.cra_priority	= 200,
-		.base.cra_flags		= CRYPTO_ALG_INTERNAL,
 		.base.cra_blocksize	= CAST5_BLOCK_SIZE,
 		.base.cra_ctxsize	= sizeof(struct cast5_ctx),
 		.base.cra_module	= THIS_MODULE,
 		.min_keysize		= CAST5_MIN_KEY_SIZE,
 		.max_keysize		= CAST5_MAX_KEY_SIZE,
@@ -91,31 +88,27 @@ static struct skcipher_alg cast5_algs[] = {
 		.encrypt		= cbc_encrypt,
 		.decrypt		= cbc_decrypt,
 	}
 };
 
-static struct simd_skcipher_alg *cast5_simd_algs[ARRAY_SIZE(cast5_algs)];
-
 static int __init cast5_init(void)
 {
 	const char *feature_name;
 
 	if (!cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM,
 				&feature_name)) {
 		pr_info("CPU feature '%s' is not supported.\n", feature_name);
 		return -ENODEV;
 	}
 
-	return simd_register_skciphers_compat(cast5_algs,
-					      ARRAY_SIZE(cast5_algs),
-					      cast5_simd_algs);
+	return crypto_register_skciphers(cast5_algs,
+					 ARRAY_SIZE(cast5_algs));
 }
 
 static void __exit cast5_exit(void)
 {
-	simd_unregister_skciphers(cast5_algs, ARRAY_SIZE(cast5_algs),
-				  cast5_simd_algs);
+	crypto_unregister_skciphers(cast5_algs, ARRAY_SIZE(cast5_algs));
 }
 
 module_init(cast5_init);
 module_exit(cast5_exit);
 
diff --git a/arch/x86/crypto/cast6_avx_glue.c b/arch/x86/crypto/cast6_avx_glue.c
index 7e2aea3723490..c4dd28c303036 100644
--- a/arch/x86/crypto/cast6_avx_glue.c
+++ b/arch/x86/crypto/cast6_avx_glue.c
@@ -12,11 +12,10 @@
 #include <linux/types.h>
 #include <linux/crypto.h>
 #include <linux/err.h>
 #include <crypto/algapi.h>
 #include <crypto/cast6.h>
-#include <crypto/internal/simd.h>
 
 #include "ecb_cbc_helpers.h"
 
 #define CAST6_PARALLEL_BLOCKS 8
 
@@ -62,27 +61,25 @@ static int cbc_decrypt(struct skcipher_request *req)
 	CBC_WALK_END();
 }
 
 static struct skcipher_alg cast6_algs[] = {
 	{
-		.base.cra_name		= "__ecb(cast6)",
-		.base.cra_driver_name	= "__ecb-cast6-avx",
+		.base.cra_name		= "ecb(cast6)",
+		.base.cra_driver_name	= "ecb-cast6-avx",
 		.base.cra_priority	= 200,
-		.base.cra_flags		= CRYPTO_ALG_INTERNAL,
 		.base.cra_blocksize	= CAST6_BLOCK_SIZE,
 		.base.cra_ctxsize	= sizeof(struct cast6_ctx),
 		.base.cra_module	= THIS_MODULE,
 		.min_keysize		= CAST6_MIN_KEY_SIZE,
 		.max_keysize		= CAST6_MAX_KEY_SIZE,
 		.setkey			= cast6_setkey_skcipher,
 		.encrypt		= ecb_encrypt,
 		.decrypt		= ecb_decrypt,
 	}, {
-		.base.cra_name		= "__cbc(cast6)",
-		.base.cra_driver_name	= "__cbc-cast6-avx",
+		.base.cra_name		= "cbc(cast6)",
+		.base.cra_driver_name	= "cbc-cast6-avx",
 		.base.cra_priority	= 200,
-		.base.cra_flags		= CRYPTO_ALG_INTERNAL,
 		.base.cra_blocksize	= CAST6_BLOCK_SIZE,
 		.base.cra_ctxsize	= sizeof(struct cast6_ctx),
 		.base.cra_module	= THIS_MODULE,
 		.min_keysize		= CAST6_MIN_KEY_SIZE,
 		.max_keysize		= CAST6_MAX_KEY_SIZE,
@@ -91,31 +88,26 @@ static struct skcipher_alg cast6_algs[] = {
 		.encrypt		= cbc_encrypt,
 		.decrypt		= cbc_decrypt,
 	},
 };
 
-static struct simd_skcipher_alg *cast6_simd_algs[ARRAY_SIZE(cast6_algs)];
-
 static int __init cast6_init(void)
 {
 	const char *feature_name;
 
 	if (!cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM,
 				&feature_name)) {
 		pr_info("CPU feature '%s' is not supported.\n", feature_name);
 		return -ENODEV;
 	}
 
-	return simd_register_skciphers_compat(cast6_algs,
-					      ARRAY_SIZE(cast6_algs),
-					      cast6_simd_algs);
+	return crypto_register_skciphers(cast6_algs, ARRAY_SIZE(cast6_algs));
 }
 
 static void __exit cast6_exit(void)
 {
-	simd_unregister_skciphers(cast6_algs, ARRAY_SIZE(cast6_algs),
-				  cast6_simd_algs);
+	crypto_unregister_skciphers(cast6_algs, ARRAY_SIZE(cast6_algs));
 }
 
 module_init(cast6_init);
 module_exit(cast6_exit);
 
-- 
2.49.0

