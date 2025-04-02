Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 874A717BA1;
	Wed,  2 Apr 2025 00:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743553485; cv=none; b=KFvTS8kSK1wvxeW9x37gAIc/yU63YIWccFwPbHKkVNpPYZ5JwYkQhatkF4x+CvS9ohT5cXFkaz4yAdAGftqo4YM8gH3R/YEDUkibrIH5Xikal1Lyys1Gu9HEX0S53h2D9/GouRUQzszcL7AxtJywNeuOPVcLZo/WoWTLF08zscA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743553485; c=relaxed/simple;
	bh=LIePuUUsKw0olQoa2ouCrCc0doulvlSdCR9d63Yfd1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i14MnsRPWeIe2tMI3lH5NIzcNlCeSjUZTKmCaaq8OQuA/jxPnn+5PqeW8Mko78SgP7RWdgY5K1Msqwia1zAcUxp9B62ycUDh2sXQBbU7VApx+/kSI9C9HY9hX36UBjwk/5xya+52PkcI4cU7dl0WVjNdgtTRFCCVmB5XzNWyGdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LILOtSFi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LILOtSFi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CC8FC4CEE4;
	Wed,  2 Apr 2025 00:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743553485;
	bh=LIePuUUsKw0olQoa2ouCrCc0doulvlSdCR9d63Yfd1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LILOtSFi5I1AYBiGfgoGncRogTU29xSeBOd7+J+L3zSbH9/BXWidU7eXnNrjUGTFq
	 p1NA2fxGPA+3TUimHuNK9zl7CXM/jrIokx/sVaJsoS/iw7ktKKjgKMFN4KmPs6auvX
	 BXWh95qRk6tfNrlxwnPUc16lSTKYXo88j6LrTHu3RwExwDL4aw4n/kUvv0IWQUt3ma
	 EzHa4yb6PjiypJYUqp4Wuzl34P2ve1xstZbbj0zBQSiekbaZLIO7F9mkJAMJB4HYjq
	 s9Mtf9Fn426NmxXT/XsURp5M2aEobqL0RwYwzUuW19Z5ABBU2P2pOSgC/zj4m+DaLQ
	 72DcbATyB1raQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH v2 8/9] crypto: x86/sm4 - stop using the SIMD helper
Date: Tue,  1 Apr 2025 17:24:08 -0700
Message-ID: <20250402002420.89233-9-ebiggers@kernel.org>
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
 arch/x86/crypto/Kconfig               |  2 --
 arch/x86/crypto/sm4_aesni_avx2_glue.c | 31 ++++++++++-----------------
 arch/x86/crypto/sm4_aesni_avx_glue.c  | 31 ++++++++++-----------------
 3 files changed, 22 insertions(+), 42 deletions(-)

diff --git a/arch/x86/crypto/Kconfig b/arch/x86/crypto/Kconfig
index 51c74a496126d..afc1a05e663dd 100644
--- a/arch/x86/crypto/Kconfig
+++ b/arch/x86/crypto/Kconfig
@@ -190,11 +190,10 @@ config CRYPTO_SERPENT_AVX2_X86_64
 
 config CRYPTO_SM4_AESNI_AVX_X86_64
 	tristate "Ciphers: SM4 with modes: ECB, CBC, CTR (AES-NI/AVX)"
 	depends on X86 && 64BIT
 	select CRYPTO_SKCIPHER
-	select CRYPTO_SIMD
 	select CRYPTO_ALGAPI
 	select CRYPTO_SM4
 	help
 	  Length-preserving ciphers: SM4 cipher algorithms
 	  (OSCCA GB/T 32907-2016) with ECB, CBC, and CTR modes
@@ -211,11 +210,10 @@ config CRYPTO_SM4_AESNI_AVX_X86_64
 
 config CRYPTO_SM4_AESNI_AVX2_X86_64
 	tristate "Ciphers: SM4 with modes: ECB, CBC, CTR (AES-NI/AVX2)"
 	depends on X86 && 64BIT
 	select CRYPTO_SKCIPHER
-	select CRYPTO_SIMD
 	select CRYPTO_ALGAPI
 	select CRYPTO_SM4
 	select CRYPTO_SM4_AESNI_AVX_X86_64
 	help
 	  Length-preserving ciphers: SM4 cipher algorithms
diff --git a/arch/x86/crypto/sm4_aesni_avx2_glue.c b/arch/x86/crypto/sm4_aesni_avx2_glue.c
index 1148fd4cd57f8..fec0ab7a63dd4 100644
--- a/arch/x86/crypto/sm4_aesni_avx2_glue.c
+++ b/arch/x86/crypto/sm4_aesni_avx2_glue.c
@@ -6,15 +6,14 @@
  *
  * Copyright (c) 2021, Alibaba Group.
  * Copyright (c) 2021 Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
  */
 
+#include <asm/fpu/api.h>
 #include <linux/module.h>
 #include <linux/crypto.h>
 #include <linux/kernel.h>
-#include <asm/simd.h>
-#include <crypto/internal/simd.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/sm4.h>
 #include "sm4-avx.h"
 
 #define SM4_CRYPT16_BLOCK_SIZE	(SM4_BLOCK_SIZE * 16)
@@ -46,14 +45,13 @@ static int ctr_crypt(struct skcipher_request *req)
 }
 
 static struct skcipher_alg sm4_aesni_avx2_skciphers[] = {
 	{
 		.base = {
-			.cra_name		= "__ecb(sm4)",
-			.cra_driver_name	= "__ecb-sm4-aesni-avx2",
+			.cra_name		= "ecb(sm4)",
+			.cra_driver_name	= "ecb-sm4-aesni-avx2",
 			.cra_priority		= 500,
-			.cra_flags		= CRYPTO_ALG_INTERNAL,
 			.cra_blocksize		= SM4_BLOCK_SIZE,
 			.cra_ctxsize		= sizeof(struct sm4_ctx),
 			.cra_module		= THIS_MODULE,
 		},
 		.min_keysize	= SM4_KEY_SIZE,
@@ -62,14 +60,13 @@ static struct skcipher_alg sm4_aesni_avx2_skciphers[] = {
 		.setkey		= sm4_skcipher_setkey,
 		.encrypt	= sm4_avx_ecb_encrypt,
 		.decrypt	= sm4_avx_ecb_decrypt,
 	}, {
 		.base = {
-			.cra_name		= "__cbc(sm4)",
-			.cra_driver_name	= "__cbc-sm4-aesni-avx2",
+			.cra_name		= "cbc(sm4)",
+			.cra_driver_name	= "cbc-sm4-aesni-avx2",
 			.cra_priority		= 500,
-			.cra_flags		= CRYPTO_ALG_INTERNAL,
 			.cra_blocksize		= SM4_BLOCK_SIZE,
 			.cra_ctxsize		= sizeof(struct sm4_ctx),
 			.cra_module		= THIS_MODULE,
 		},
 		.min_keysize	= SM4_KEY_SIZE,
@@ -79,14 +76,13 @@ static struct skcipher_alg sm4_aesni_avx2_skciphers[] = {
 		.setkey		= sm4_skcipher_setkey,
 		.encrypt	= sm4_cbc_encrypt,
 		.decrypt	= cbc_decrypt,
 	}, {
 		.base = {
-			.cra_name		= "__ctr(sm4)",
-			.cra_driver_name	= "__ctr-sm4-aesni-avx2",
+			.cra_name		= "ctr(sm4)",
+			.cra_driver_name	= "ctr-sm4-aesni-avx2",
 			.cra_priority		= 500,
-			.cra_flags		= CRYPTO_ALG_INTERNAL,
 			.cra_blocksize		= 1,
 			.cra_ctxsize		= sizeof(struct sm4_ctx),
 			.cra_module		= THIS_MODULE,
 		},
 		.min_keysize	= SM4_KEY_SIZE,
@@ -98,13 +94,10 @@ static struct skcipher_alg sm4_aesni_avx2_skciphers[] = {
 		.encrypt	= ctr_crypt,
 		.decrypt	= ctr_crypt,
 	}
 };
 
-static struct simd_skcipher_alg *
-simd_sm4_aesni_avx2_skciphers[ARRAY_SIZE(sm4_aesni_avx2_skciphers)];
-
 static int __init sm4_init(void)
 {
 	const char *feature_name;
 
 	if (!boot_cpu_has(X86_FEATURE_AVX) ||
@@ -119,20 +112,18 @@ static int __init sm4_init(void)
 				&feature_name)) {
 		pr_info("CPU feature '%s' is not supported.\n", feature_name);
 		return -ENODEV;
 	}
 
-	return simd_register_skciphers_compat(sm4_aesni_avx2_skciphers,
-					ARRAY_SIZE(sm4_aesni_avx2_skciphers),
-					simd_sm4_aesni_avx2_skciphers);
+	return crypto_register_skciphers(sm4_aesni_avx2_skciphers,
+					 ARRAY_SIZE(sm4_aesni_avx2_skciphers));
 }
 
 static void __exit sm4_exit(void)
 {
-	simd_unregister_skciphers(sm4_aesni_avx2_skciphers,
-				ARRAY_SIZE(sm4_aesni_avx2_skciphers),
-				simd_sm4_aesni_avx2_skciphers);
+	crypto_unregister_skciphers(sm4_aesni_avx2_skciphers,
+				    ARRAY_SIZE(sm4_aesni_avx2_skciphers));
 }
 
 module_init(sm4_init);
 module_exit(sm4_exit);
 
diff --git a/arch/x86/crypto/sm4_aesni_avx_glue.c b/arch/x86/crypto/sm4_aesni_avx_glue.c
index 85b4ca78b47b5..72867fc49ce8e 100644
--- a/arch/x86/crypto/sm4_aesni_avx_glue.c
+++ b/arch/x86/crypto/sm4_aesni_avx_glue.c
@@ -6,15 +6,14 @@
  *
  * Copyright (c) 2021, Alibaba Group.
  * Copyright (c) 2021 Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
  */
 
+#include <asm/fpu/api.h>
 #include <linux/module.h>
 #include <linux/crypto.h>
 #include <linux/kernel.h>
-#include <asm/simd.h>
-#include <crypto/internal/simd.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/sm4.h>
 #include "sm4-avx.h"
 
 #define SM4_CRYPT8_BLOCK_SIZE	(SM4_BLOCK_SIZE * 8)
@@ -261,14 +260,13 @@ static int ctr_crypt(struct skcipher_request *req)
 }
 
 static struct skcipher_alg sm4_aesni_avx_skciphers[] = {
 	{
 		.base = {
-			.cra_name		= "__ecb(sm4)",
-			.cra_driver_name	= "__ecb-sm4-aesni-avx",
+			.cra_name		= "ecb(sm4)",
+			.cra_driver_name	= "ecb-sm4-aesni-avx",
 			.cra_priority		= 400,
-			.cra_flags		= CRYPTO_ALG_INTERNAL,
 			.cra_blocksize		= SM4_BLOCK_SIZE,
 			.cra_ctxsize		= sizeof(struct sm4_ctx),
 			.cra_module		= THIS_MODULE,
 		},
 		.min_keysize	= SM4_KEY_SIZE,
@@ -277,14 +275,13 @@ static struct skcipher_alg sm4_aesni_avx_skciphers[] = {
 		.setkey		= sm4_skcipher_setkey,
 		.encrypt	= sm4_avx_ecb_encrypt,
 		.decrypt	= sm4_avx_ecb_decrypt,
 	}, {
 		.base = {
-			.cra_name		= "__cbc(sm4)",
-			.cra_driver_name	= "__cbc-sm4-aesni-avx",
+			.cra_name		= "cbc(sm4)",
+			.cra_driver_name	= "cbc-sm4-aesni-avx",
 			.cra_priority		= 400,
-			.cra_flags		= CRYPTO_ALG_INTERNAL,
 			.cra_blocksize		= SM4_BLOCK_SIZE,
 			.cra_ctxsize		= sizeof(struct sm4_ctx),
 			.cra_module		= THIS_MODULE,
 		},
 		.min_keysize	= SM4_KEY_SIZE,
@@ -294,14 +291,13 @@ static struct skcipher_alg sm4_aesni_avx_skciphers[] = {
 		.setkey		= sm4_skcipher_setkey,
 		.encrypt	= sm4_cbc_encrypt,
 		.decrypt	= cbc_decrypt,
 	}, {
 		.base = {
-			.cra_name		= "__ctr(sm4)",
-			.cra_driver_name	= "__ctr-sm4-aesni-avx",
+			.cra_name		= "ctr(sm4)",
+			.cra_driver_name	= "ctr-sm4-aesni-avx",
 			.cra_priority		= 400,
-			.cra_flags		= CRYPTO_ALG_INTERNAL,
 			.cra_blocksize		= 1,
 			.cra_ctxsize		= sizeof(struct sm4_ctx),
 			.cra_module		= THIS_MODULE,
 		},
 		.min_keysize	= SM4_KEY_SIZE,
@@ -313,13 +309,10 @@ static struct skcipher_alg sm4_aesni_avx_skciphers[] = {
 		.encrypt	= ctr_crypt,
 		.decrypt	= ctr_crypt,
 	}
 };
 
-static struct simd_skcipher_alg *
-simd_sm4_aesni_avx_skciphers[ARRAY_SIZE(sm4_aesni_avx_skciphers)];
-
 static int __init sm4_init(void)
 {
 	const char *feature_name;
 
 	if (!boot_cpu_has(X86_FEATURE_AVX) ||
@@ -333,20 +326,18 @@ static int __init sm4_init(void)
 				&feature_name)) {
 		pr_info("CPU feature '%s' is not supported.\n", feature_name);
 		return -ENODEV;
 	}
 
-	return simd_register_skciphers_compat(sm4_aesni_avx_skciphers,
-					ARRAY_SIZE(sm4_aesni_avx_skciphers),
-					simd_sm4_aesni_avx_skciphers);
+	return crypto_register_skciphers(sm4_aesni_avx_skciphers,
+					 ARRAY_SIZE(sm4_aesni_avx_skciphers));
 }
 
 static void __exit sm4_exit(void)
 {
-	simd_unregister_skciphers(sm4_aesni_avx_skciphers,
-					ARRAY_SIZE(sm4_aesni_avx_skciphers),
-					simd_sm4_aesni_avx_skciphers);
+	crypto_unregister_skciphers(sm4_aesni_avx_skciphers,
+				    ARRAY_SIZE(sm4_aesni_avx_skciphers));
 }
 
 module_init(sm4_init);
 module_exit(sm4_exit);
 
-- 
2.49.0

