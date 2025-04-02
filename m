Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE21FB661;
	Wed,  2 Apr 2025 00:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743553484; cv=none; b=R0k15ir01JiKB9TWR4RSC4q3DyQmDRzdNkJJft/X+brPdDOV5qQY+gxhvwjMKx/3aEEsAwcMHscFNp3ZPRJA8IRKJeiyNqZTZWL1zb3+grnQ/oXdx5LUL4A6StDBEQEFnCVW/oHZp3yKYJKmfzfP+e4K4Pq/Tcb/p1RXEixC7ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743553484; c=relaxed/simple;
	bh=zxP2LNAwKBH44tj1SYMVnX8vwtbf3lxHr308PDgoBXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BWFRdIKKicflgl5O+Q605Z6MTb+7DFmBqBOtwMnvG4g7T0R8Axm6j9BYh3dqYE/IGO70IcRg6xpNvCjbk0sYR/GNcYH0oLYvjj8eq2rFWmxqHZASFEWruoNy6oV2EG5m9TsoeNnbN9M8ylwE+ou+VwiiUGyU+lLXfk3WRm7lE18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TFK/xyo4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TFK/xyo4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83642C4CEF1;
	Wed,  2 Apr 2025 00:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743553484;
	bh=zxP2LNAwKBH44tj1SYMVnX8vwtbf3lxHr308PDgoBXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TFK/xyo4ll4QIZiPfSFGalg5Jx2FHSfjjv02lTc6MXGO3v7FdOuCSLmR/Kg+rLNeX
	 Jr5xzEAcqp4UQz5fVcx2pxLrprkyCWk8e7GYCWNDe+PC/iKI7eZ6fwoSpuDAnXDKcd
	 Moxf6b6T40wVTDBEIfH4UYhN0+Xn+LiFCPMUKGuSnVXvB1ykFe0mNZBoSzbSiJeeW/
	 92OMlM+p6eXCoMXQzgZVfYTbmBqbogxWd+gtpYxvpuv+c6VIYal537zRrWrq7EnTAy
	 Yi6MFTciCi93yYQ6E3XlasXnCkQFPBW707dteF0sFalbRLuLYtGllHGlj10DF1FCHl
	 NthgGHAKEDBZA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH v2 5/9] crypto: x86/camellia - stop using the SIMD helper
Date: Tue,  1 Apr 2025 17:24:05 -0700
Message-ID: <20250402002420.89233-6-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250402002420.89233-1-ebiggers@kernel.org>
References: <20250402002420.89233-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
 arch/x86/crypto/Kconfig                    |  1 -
 arch/x86/crypto/camellia_aesni_avx2_glue.c | 21 +++++++--------------
 arch/x86/crypto/camellia_aesni_avx_glue.c  | 21 +++++++--------------
 3 files changed, 14 insertions(+), 29 deletions(-)

diff --git a/arch/x86/crypto/Kconfig b/arch/x86/crypto/Kconfig
index ad00d53ab83d8..de927df89ccf1 100644
--- a/arch/x86/crypto/Kconfig
+++ b/arch/x86/crypto/Kconfig
@@ -61,11 +61,10 @@ config CRYPTO_CAMELLIA_X86_64
 config CRYPTO_CAMELLIA_AESNI_AVX_X86_64
 	tristate "Ciphers: Camellia with modes: ECB, CBC (AES-NI/AVX)"
 	depends on X86 && 64BIT
 	select CRYPTO_SKCIPHER
 	select CRYPTO_CAMELLIA_X86_64
-	select CRYPTO_SIMD
 	imply CRYPTO_XTS
 	help
 	  Length-preserving ciphers: Camellia with ECB and CBC modes
 
 	  Architecture: x86_64 using:
diff --git a/arch/x86/crypto/camellia_aesni_avx2_glue.c b/arch/x86/crypto/camellia_aesni_avx2_glue.c
index e7e4d64e9577e..2d2f4e16537c4 100644
--- a/arch/x86/crypto/camellia_aesni_avx2_glue.c
+++ b/arch/x86/crypto/camellia_aesni_avx2_glue.c
@@ -4,11 +4,10 @@
  *
  * Copyright © 2013 Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
  */
 
 #include <crypto/algapi.h>
-#include <crypto/internal/simd.h>
 #include <linux/crypto.h>
 #include <linux/err.h>
 #include <linux/module.h>
 #include <linux/types.h>
 
@@ -67,27 +66,25 @@ static int cbc_decrypt(struct skcipher_request *req)
 	CBC_WALK_END();
 }
 
 static struct skcipher_alg camellia_algs[] = {
 	{
-		.base.cra_name		= "__ecb(camellia)",
-		.base.cra_driver_name	= "__ecb-camellia-aesni-avx2",
+		.base.cra_name		= "ecb(camellia)",
+		.base.cra_driver_name	= "ecb-camellia-aesni-avx2",
 		.base.cra_priority	= 500,
-		.base.cra_flags		= CRYPTO_ALG_INTERNAL,
 		.base.cra_blocksize	= CAMELLIA_BLOCK_SIZE,
 		.base.cra_ctxsize	= sizeof(struct camellia_ctx),
 		.base.cra_module	= THIS_MODULE,
 		.min_keysize		= CAMELLIA_MIN_KEY_SIZE,
 		.max_keysize		= CAMELLIA_MAX_KEY_SIZE,
 		.setkey			= camellia_setkey,
 		.encrypt		= ecb_encrypt,
 		.decrypt		= ecb_decrypt,
 	}, {
-		.base.cra_name		= "__cbc(camellia)",
-		.base.cra_driver_name	= "__cbc-camellia-aesni-avx2",
+		.base.cra_name		= "cbc(camellia)",
+		.base.cra_driver_name	= "cbc-camellia-aesni-avx2",
 		.base.cra_priority	= 500,
-		.base.cra_flags		= CRYPTO_ALG_INTERNAL,
 		.base.cra_blocksize	= CAMELLIA_BLOCK_SIZE,
 		.base.cra_ctxsize	= sizeof(struct camellia_ctx),
 		.base.cra_module	= THIS_MODULE,
 		.min_keysize		= CAMELLIA_MIN_KEY_SIZE,
 		.max_keysize		= CAMELLIA_MAX_KEY_SIZE,
@@ -96,12 +93,10 @@ static struct skcipher_alg camellia_algs[] = {
 		.encrypt		= cbc_encrypt,
 		.decrypt		= cbc_decrypt,
 	},
 };
 
-static struct simd_skcipher_alg *camellia_simd_algs[ARRAY_SIZE(camellia_algs)];
-
 static int __init camellia_aesni_init(void)
 {
 	const char *feature_name;
 
 	if (!boot_cpu_has(X86_FEATURE_AVX) ||
@@ -116,19 +111,17 @@ static int __init camellia_aesni_init(void)
 				&feature_name)) {
 		pr_info("CPU feature '%s' is not supported.\n", feature_name);
 		return -ENODEV;
 	}
 
-	return simd_register_skciphers_compat(camellia_algs,
-					      ARRAY_SIZE(camellia_algs),
-					      camellia_simd_algs);
+	return crypto_register_skciphers(camellia_algs,
+					 ARRAY_SIZE(camellia_algs));
 }
 
 static void __exit camellia_aesni_fini(void)
 {
-	simd_unregister_skciphers(camellia_algs, ARRAY_SIZE(camellia_algs),
-				  camellia_simd_algs);
+	crypto_unregister_skciphers(camellia_algs, ARRAY_SIZE(camellia_algs));
 }
 
 module_init(camellia_aesni_init);
 module_exit(camellia_aesni_fini);
 
diff --git a/arch/x86/crypto/camellia_aesni_avx_glue.c b/arch/x86/crypto/camellia_aesni_avx_glue.c
index c7ccf63e741e1..a7d1623881424 100644
--- a/arch/x86/crypto/camellia_aesni_avx_glue.c
+++ b/arch/x86/crypto/camellia_aesni_avx_glue.c
@@ -4,11 +4,10 @@
  *
  * Copyright © 2012-2013 Jussi Kivilinna <jussi.kivilinna@iki.fi>
  */
 
 #include <crypto/algapi.h>
-#include <crypto/internal/simd.h>
 #include <linux/crypto.h>
 #include <linux/err.h>
 #include <linux/module.h>
 #include <linux/types.h>
 
@@ -67,27 +66,25 @@ static int cbc_decrypt(struct skcipher_request *req)
 	CBC_WALK_END();
 }
 
 static struct skcipher_alg camellia_algs[] = {
 	{
-		.base.cra_name		= "__ecb(camellia)",
-		.base.cra_driver_name	= "__ecb-camellia-aesni",
+		.base.cra_name		= "ecb(camellia)",
+		.base.cra_driver_name	= "ecb-camellia-aesni",
 		.base.cra_priority	= 400,
-		.base.cra_flags		= CRYPTO_ALG_INTERNAL,
 		.base.cra_blocksize	= CAMELLIA_BLOCK_SIZE,
 		.base.cra_ctxsize	= sizeof(struct camellia_ctx),
 		.base.cra_module	= THIS_MODULE,
 		.min_keysize		= CAMELLIA_MIN_KEY_SIZE,
 		.max_keysize		= CAMELLIA_MAX_KEY_SIZE,
 		.setkey			= camellia_setkey,
 		.encrypt		= ecb_encrypt,
 		.decrypt		= ecb_decrypt,
 	}, {
-		.base.cra_name		= "__cbc(camellia)",
-		.base.cra_driver_name	= "__cbc-camellia-aesni",
+		.base.cra_name		= "cbc(camellia)",
+		.base.cra_driver_name	= "cbc-camellia-aesni",
 		.base.cra_priority	= 400,
-		.base.cra_flags		= CRYPTO_ALG_INTERNAL,
 		.base.cra_blocksize	= CAMELLIA_BLOCK_SIZE,
 		.base.cra_ctxsize	= sizeof(struct camellia_ctx),
 		.base.cra_module	= THIS_MODULE,
 		.min_keysize		= CAMELLIA_MIN_KEY_SIZE,
 		.max_keysize		= CAMELLIA_MAX_KEY_SIZE,
@@ -96,12 +93,10 @@ static struct skcipher_alg camellia_algs[] = {
 		.encrypt		= cbc_encrypt,
 		.decrypt		= cbc_decrypt,
 	}
 };
 
-static struct simd_skcipher_alg *camellia_simd_algs[ARRAY_SIZE(camellia_algs)];
-
 static int __init camellia_aesni_init(void)
 {
 	const char *feature_name;
 
 	if (!boot_cpu_has(X86_FEATURE_AVX) ||
@@ -115,19 +110,17 @@ static int __init camellia_aesni_init(void)
 				&feature_name)) {
 		pr_info("CPU feature '%s' is not supported.\n", feature_name);
 		return -ENODEV;
 	}
 
-	return simd_register_skciphers_compat(camellia_algs,
-					      ARRAY_SIZE(camellia_algs),
-					      camellia_simd_algs);
+	return crypto_register_skciphers(camellia_algs,
+					 ARRAY_SIZE(camellia_algs));
 }
 
 static void __exit camellia_aesni_fini(void)
 {
-	simd_unregister_skciphers(camellia_algs, ARRAY_SIZE(camellia_algs),
-				  camellia_simd_algs);
+	crypto_unregister_skciphers(camellia_algs, ARRAY_SIZE(camellia_algs));
 }
 
 module_init(camellia_aesni_init);
 module_exit(camellia_aesni_fini);
 
-- 
2.49.0

