Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D9EB1E25F1;
	Thu, 20 Feb 2025 05:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740028588; cv=none; b=Ow+d7MKTkf3KPcb1I4F9fMVvfk16130dVPCW+IGbv3vxECUxO6iU0Uv0621Xs7H+drtEJGPKksJcQsNKMAQ1XWRvGc+WGk9W8M4WZTMmrxzi8g2+jxFKbk4kbHZ5LVz5tBNmFmvwJOCre0jE8gpYvVPspjpCT2vXwkagCDUEwC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740028588; c=relaxed/simple;
	bh=XYSc5lvDqX/372xv7TWAJwugxIC+lsoCoy7ZM8UiZ1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S9Jlker/GLmmTOdQpo5dRmEpWNgEEbcI7SEH4C5Hos2/R8NQOEcDyU5HHDnDR/xLpfKiQX5KrmTD+c8vFlLlfppAzVQbpdnrfogRLL6/Inh0+izSwP713LR9FNQ2PnYioBxj5rc1CgFCoxnWa70qd1EMHwy+tWl7OTtlpsaH1Bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tTEE4eog; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tTEE4eog"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71CCEC4CEE4;
	Thu, 20 Feb 2025 05:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740028587;
	bh=XYSc5lvDqX/372xv7TWAJwugxIC+lsoCoy7ZM8UiZ1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tTEE4eogcmXB4XvH6khCLKYBNlmUSR8deVEUNleTSQ9vdOOJTUWiDqnlwHlh5MCJC
	 9QWL7KqYgidyIvYmuM6BAkTOB/YVp1dwOJ/KSV2AN7kwYyLc2khl+O8tf3KwIWc+E/
	 LCbm0O0RwhwRZdYLQGX2znuLNbAjLBzOjhCdpmDtk5zTA9CU+SeM8oC3ROohHpbTf5
	 krO9+kxPLHX2pSRvSZwyqs0yL/EkyYKfCpxJS2XThWW7IqM7E/WfGRP+vFHosYSdu1
	 TCfF2Rr+JV7LaNUNOeVlsyUiezDQGl3Nphwhx0C8yb4sBmsAREnDUPOMrndoEMO8QQ
	 eCuWRWdSooCKA==
From: Eric Biggers <ebiggers@kernel.org>
To: x86@kernel.org
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Ben Greear <greearb@candelatech.com>,
	Xiao Liang <shaw.leon@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: [RFC PATCH 2/2] crypto: x86 - stop using the SIMD helper
Date: Wed, 19 Feb 2025 21:13:25 -0800
Message-ID: <20250220051325.340691-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250220051325.340691-1-ebiggers@kernel.org>
References: <20250220051325.340691-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

(This is an RFC that just updates all algorithms in one big patch.  I'll
split this up by file if it's actually going to be merged.)

Stop wrapping skcipher and aead algorithms with the crypto SIMD helper
(crypto/simd.c).  The only purpose of doing so was to work around x86
not always supporting kernel-mode FPU in softirqs.  Specifically, if a
hardirq interrupted a task context kernel-mode FPU section and then a
softirqs were run at the end of that hardirq, those softirqs could not
use kernel-mode FPU.  This has now been fixed.  In combination with the
fact that the skcipher and aead APIs only support task and softirq
contexts, these can now just use kernel-mode FPU unconditionally on x86.

This simplifies the code and improves performance.

En/decryption gets at least somewhat faster for everyone, since the
crypto API functions such as crypto_skcipher_encrypt() now go directly
to the underlying algorithm rather than taking a detour through
crypto/simd.c which involved an extra indirect call.  For example, on a
Ryzen 9 9950X desktop processor, AES-256-XTS is now 23% faster for
512-byte messages and 7% faster for 4096-byte messages (when accessed
through crypto_skcipher_encrypt() or crypto_skcipher_decrypt()).

There's also a much larger performance improvement for crypto API users
that only support synchronous algorithms.  These users will now actually
use the x86 SIMD (e.g. AES-NI or VAES) optimized en/decryption modes,
which they couldn't before because they were marked as asynchronous.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/Kconfig                    |  14 --
 arch/x86/crypto/aegis128-aesni-glue.c      |  13 +-
 arch/x86/crypto/aesni-intel_glue.c         | 168 ++++++++-------------
 arch/x86/crypto/aria_aesni_avx2_glue.c     |  22 +--
 arch/x86/crypto/aria_aesni_avx_glue.c      |  20 +--
 arch/x86/crypto/aria_gfni_avx512_glue.c    |  22 +--
 arch/x86/crypto/camellia_aesni_avx2_glue.c |  21 +--
 arch/x86/crypto/camellia_aesni_avx_glue.c  |  21 +--
 arch/x86/crypto/cast5_avx_glue.c           |  21 +--
 arch/x86/crypto/cast6_avx_glue.c           |  20 +--
 arch/x86/crypto/serpent_avx2_glue.c        |  21 +--
 arch/x86/crypto/serpent_avx_glue.c         |  21 +--
 arch/x86/crypto/serpent_sse2_glue.c        |  21 +--
 arch/x86/crypto/sm4_aesni_avx2_glue.c      |  30 ++--
 arch/x86/crypto/sm4_aesni_avx_glue.c       |  30 ++--
 arch/x86/crypto/twofish_avx_glue.c         |  21 +--
 16 files changed, 161 insertions(+), 325 deletions(-)

diff --git a/arch/x86/crypto/Kconfig b/arch/x86/crypto/Kconfig
index 4757bf922075b..5ef3c32d3d5f0 100644
--- a/arch/x86/crypto/Kconfig
+++ b/arch/x86/crypto/Kconfig
@@ -19,11 +19,10 @@ config CRYPTO_AES_NI_INTEL
 	select CRYPTO_AEAD
 	select CRYPTO_LIB_AES
 	select CRYPTO_LIB_GF128MUL
 	select CRYPTO_ALGAPI
 	select CRYPTO_SKCIPHER
-	select CRYPTO_SIMD
 	help
 	  Block cipher: AES cipher algorithms
 	  AEAD cipher: AES with GCM
 	  Length-preserving ciphers: AES with ECB, CBC, CTS, CTR, XCTR, XTS
 
@@ -60,11 +59,10 @@ config CRYPTO_CAMELLIA_X86_64
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
@@ -86,11 +84,10 @@ config CRYPTO_CAST5_AVX_X86_64
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
 
@@ -103,11 +100,10 @@ config CRYPTO_CAST6_AVX_X86_64
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
@@ -134,11 +130,10 @@ config CRYPTO_DES3_EDE_X86_64
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
 
@@ -150,11 +145,10 @@ config CRYPTO_SERPENT_SSE2_X86_64
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
 
@@ -166,11 +160,10 @@ config CRYPTO_SERPENT_SSE2_586
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
@@ -195,11 +188,10 @@ config CRYPTO_SERPENT_AVX2_X86_64
 
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
@@ -216,11 +208,10 @@ config CRYPTO_SM4_AESNI_AVX_X86_64
 
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
@@ -275,11 +266,10 @@ config CRYPTO_TWOFISH_X86_64_3WAY
 
 config CRYPTO_TWOFISH_AVX_X86_64
 	tristate "Ciphers: Twofish with modes: ECB, CBC (AVX)"
 	depends on X86 && 64BIT
 	select CRYPTO_SKCIPHER
-	select CRYPTO_SIMD
 	select CRYPTO_TWOFISH_COMMON
 	select CRYPTO_TWOFISH_X86_64
 	select CRYPTO_TWOFISH_X86_64_3WAY
 	imply CRYPTO_XTS
 	help
@@ -293,11 +283,10 @@ config CRYPTO_TWOFISH_AVX_X86_64
 
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
@@ -311,11 +300,10 @@ config CRYPTO_ARIA_AESNI_AVX_X86_64
 
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
@@ -330,11 +318,10 @@ config CRYPTO_ARIA_AESNI_AVX2_X86_64
 
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
@@ -364,11 +351,10 @@ config CRYPTO_CHACHA20_X86_64
 
 config CRYPTO_AEGIS128_AESNI_SSE2
 	tristate "AEAD ciphers: AEGIS-128 (AES-NI/SSE4.1)"
 	depends on X86 && 64BIT
 	select CRYPTO_AEAD
-	select CRYPTO_SIMD
 	help
 	  AEGIS-128 AEAD algorithm
 
 	  Architecture: x86_64 using:
 	  - AES-NI (AES New Instructions)
diff --git a/arch/x86/crypto/aegis128-aesni-glue.c b/arch/x86/crypto/aegis128-aesni-glue.c
index 01fa568dc5fc4..c937426abf6a0 100644
--- a/arch/x86/crypto/aegis128-aesni-glue.c
+++ b/arch/x86/crypto/aegis128-aesni-glue.c
@@ -6,11 +6,10 @@
  * Copyright (c) 2017-2018 Ondrej Mosnacek <omosnacek@gmail.com>
  * Copyright (C) 2017-2018 Red Hat, Inc. All rights reserved.
  */
 
 #include <crypto/internal/aead.h>
-#include <crypto/internal/simd.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/scatterwalk.h>
 #include <linux/module.h>
 #include <asm/fpu/api.h>
 #include <asm/cpu_device_id.h>
@@ -234,39 +233,35 @@ static struct aead_alg crypto_aegis128_aesni_alg = {
 	.ivsize = AEGIS128_NONCE_SIZE,
 	.maxauthsize = AEGIS128_MAX_AUTH_SIZE,
 	.chunksize = AEGIS128_BLOCK_SIZE,
 
 	.base = {
-		.cra_flags = CRYPTO_ALG_INTERNAL,
 		.cra_blocksize = 1,
 		.cra_ctxsize = sizeof(struct aegis_ctx) +
 			       __alignof__(struct aegis_ctx),
 		.cra_priority = 400,
 
-		.cra_name = "__aegis128",
-		.cra_driver_name = "__aegis128-aesni",
+		.cra_name = "aegis128",
+		.cra_driver_name = "aegis128-aesni",
 
 		.cra_module = THIS_MODULE,
 	}
 };
 
-static struct simd_aead_alg *simd_alg;
-
 static int __init crypto_aegis128_aesni_module_init(void)
 {
 	if (!boot_cpu_has(X86_FEATURE_XMM4_1) ||
 	    !boot_cpu_has(X86_FEATURE_AES) ||
 	    !cpu_has_xfeatures(XFEATURE_MASK_SSE, NULL))
 		return -ENODEV;
 
-	return simd_register_aeads_compat(&crypto_aegis128_aesni_alg, 1,
-					  &simd_alg);
+	return crypto_register_aead(&crypto_aegis128_aesni_alg);
 }
 
 static void __exit crypto_aegis128_aesni_module_exit(void)
 {
-	simd_unregister_aeads(&crypto_aegis128_aesni_alg, 1, &simd_alg);
+	crypto_unregister_aead(&crypto_aegis128_aesni_alg);
 }
 
 module_init(crypto_aegis128_aesni_module_init);
 module_exit(crypto_aegis128_aesni_module_exit);
 
diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 345c97db06f32..7d184fdbaa0ed 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -574,14 +574,13 @@ static struct crypto_alg aesni_cipher_alg = {
 };
 
 static struct skcipher_alg aesni_skciphers[] = {
 	{
 		.base = {
-			.cra_name		= "__ecb(aes)",
-			.cra_driver_name	= "__ecb-aes-aesni",
+			.cra_name		= "ecb(aes)",
+			.cra_driver_name	= "ecb-aes-aesni",
 			.cra_priority		= 400,
-			.cra_flags		= CRYPTO_ALG_INTERNAL,
 			.cra_blocksize		= AES_BLOCK_SIZE,
 			.cra_ctxsize		= CRYPTO_AES_CTX_SIZE,
 			.cra_module		= THIS_MODULE,
 		},
 		.min_keysize	= AES_MIN_KEY_SIZE,
@@ -589,14 +588,13 @@ static struct skcipher_alg aesni_skciphers[] = {
 		.setkey		= aesni_skcipher_setkey,
 		.encrypt	= ecb_encrypt,
 		.decrypt	= ecb_decrypt,
 	}, {
 		.base = {
-			.cra_name		= "__cbc(aes)",
-			.cra_driver_name	= "__cbc-aes-aesni",
+			.cra_name		= "cbc(aes)",
+			.cra_driver_name	= "cbc-aes-aesni",
 			.cra_priority		= 400,
-			.cra_flags		= CRYPTO_ALG_INTERNAL,
 			.cra_blocksize		= AES_BLOCK_SIZE,
 			.cra_ctxsize		= CRYPTO_AES_CTX_SIZE,
 			.cra_module		= THIS_MODULE,
 		},
 		.min_keysize	= AES_MIN_KEY_SIZE,
@@ -605,14 +603,13 @@ static struct skcipher_alg aesni_skciphers[] = {
 		.setkey		= aesni_skcipher_setkey,
 		.encrypt	= cbc_encrypt,
 		.decrypt	= cbc_decrypt,
 	}, {
 		.base = {
-			.cra_name		= "__cts(cbc(aes))",
-			.cra_driver_name	= "__cts-cbc-aes-aesni",
+			.cra_name		= "cts(cbc(aes))",
+			.cra_driver_name	= "cts-cbc-aes-aesni",
 			.cra_priority		= 400,
-			.cra_flags		= CRYPTO_ALG_INTERNAL,
 			.cra_blocksize		= AES_BLOCK_SIZE,
 			.cra_ctxsize		= CRYPTO_AES_CTX_SIZE,
 			.cra_module		= THIS_MODULE,
 		},
 		.min_keysize	= AES_MIN_KEY_SIZE,
@@ -623,14 +620,13 @@ static struct skcipher_alg aesni_skciphers[] = {
 		.encrypt	= cts_cbc_encrypt,
 		.decrypt	= cts_cbc_decrypt,
 #ifdef CONFIG_X86_64
 	}, {
 		.base = {
-			.cra_name		= "__ctr(aes)",
-			.cra_driver_name	= "__ctr-aes-aesni",
+			.cra_name		= "ctr(aes)",
+			.cra_driver_name	= "ctr-aes-aesni",
 			.cra_priority		= 400,
-			.cra_flags		= CRYPTO_ALG_INTERNAL,
 			.cra_blocksize		= 1,
 			.cra_ctxsize		= CRYPTO_AES_CTX_SIZE,
 			.cra_module		= THIS_MODULE,
 		},
 		.min_keysize	= AES_MIN_KEY_SIZE,
@@ -641,14 +637,13 @@ static struct skcipher_alg aesni_skciphers[] = {
 		.encrypt	= ctr_crypt_aesni,
 		.decrypt	= ctr_crypt_aesni,
 #endif
 	}, {
 		.base = {
-			.cra_name		= "__xts(aes)",
-			.cra_driver_name	= "__xts-aes-aesni",
+			.cra_name		= "xts(aes)",
+			.cra_driver_name	= "xts-aes-aesni",
 			.cra_priority		= 401,
-			.cra_flags		= CRYPTO_ALG_INTERNAL,
 			.cra_blocksize		= AES_BLOCK_SIZE,
 			.cra_ctxsize		= XTS_AES_CTX_SIZE,
 			.cra_module		= THIS_MODULE,
 		},
 		.min_keysize	= 2 * AES_MIN_KEY_SIZE,
@@ -659,13 +654,10 @@ static struct skcipher_alg aesni_skciphers[] = {
 		.encrypt	= xts_encrypt_aesni,
 		.decrypt	= xts_decrypt_aesni,
 	}
 };
 
-static
-struct simd_skcipher_alg *aesni_simd_skciphers[ARRAY_SIZE(aesni_skciphers)];
-
 #ifdef CONFIG_X86_64
 asmlinkage void aes_xts_encrypt_iv(const struct crypto_aes_ctx *tweak_key,
 				   u8 iv[AES_BLOCK_SIZE]);
 
 /* __always_inline to avoid indirect call */
@@ -800,14 +792,13 @@ static int xctr_crypt_##suffix(struct skcipher_request *req)		       \
 {									       \
 	return xctr_crypt(req, aes_xctr_crypt_##suffix);		       \
 }									       \
 									       \
 static struct skcipher_alg skcipher_algs_##suffix[] = {{		       \
-	.base.cra_name		= "__xts(aes)",				       \
-	.base.cra_driver_name	= "__xts-aes-" driver_name_suffix,	       \
+	.base.cra_name		= "xts(aes)",				       \
+	.base.cra_driver_name	= "xts-aes-" driver_name_suffix,	       \
 	.base.cra_priority	= priority,				       \
-	.base.cra_flags		= CRYPTO_ALG_INTERNAL,			       \
 	.base.cra_blocksize	= AES_BLOCK_SIZE,			       \
 	.base.cra_ctxsize	= XTS_AES_CTX_SIZE,			       \
 	.base.cra_module	= THIS_MODULE,				       \
 	.min_keysize		= 2 * AES_MIN_KEY_SIZE,			       \
 	.max_keysize		= 2 * AES_MAX_KEY_SIZE,			       \
@@ -815,14 +806,13 @@ static struct skcipher_alg skcipher_algs_##suffix[] = {{		       \
 	.walksize		= 2 * AES_BLOCK_SIZE,			       \
 	.setkey			= xts_setkey_aesni,			       \
 	.encrypt		= xts_encrypt_##suffix,			       \
 	.decrypt		= xts_decrypt_##suffix,			       \
 }, {									       \
-	.base.cra_name		= "__ctr(aes)",				       \
-	.base.cra_driver_name	= "__ctr-aes-" driver_name_suffix,	       \
+	.base.cra_name		= "ctr(aes)",				       \
+	.base.cra_driver_name	= "ctr-aes-" driver_name_suffix,	       \
 	.base.cra_priority	= priority,				       \
-	.base.cra_flags		= CRYPTO_ALG_INTERNAL,			       \
 	.base.cra_blocksize	= 1,					       \
 	.base.cra_ctxsize	= CRYPTO_AES_CTX_SIZE,			       \
 	.base.cra_module	= THIS_MODULE,				       \
 	.min_keysize		= AES_MIN_KEY_SIZE,			       \
 	.max_keysize		= AES_MAX_KEY_SIZE,			       \
@@ -830,29 +820,25 @@ static struct skcipher_alg skcipher_algs_##suffix[] = {{		       \
 	.chunksize		= AES_BLOCK_SIZE,			       \
 	.setkey			= aesni_skcipher_setkey,		       \
 	.encrypt		= ctr_crypt_##suffix,			       \
 	.decrypt		= ctr_crypt_##suffix,			       \
 }, {									       \
-	.base.cra_name		= "__xctr(aes)",			       \
-	.base.cra_driver_name	= "__xctr-aes-" driver_name_suffix,	       \
+	.base.cra_name		= "xctr(aes)",				       \
+	.base.cra_driver_name	= "xctr-aes-" driver_name_suffix,	       \
 	.base.cra_priority	= priority,				       \
-	.base.cra_flags		= CRYPTO_ALG_INTERNAL,			       \
 	.base.cra_blocksize	= 1,					       \
 	.base.cra_ctxsize	= CRYPTO_AES_CTX_SIZE,			       \
 	.base.cra_module	= THIS_MODULE,				       \
 	.min_keysize		= AES_MIN_KEY_SIZE,			       \
 	.max_keysize		= AES_MAX_KEY_SIZE,			       \
 	.ivsize			= AES_BLOCK_SIZE,			       \
 	.chunksize		= AES_BLOCK_SIZE,			       \
 	.setkey			= aesni_skcipher_setkey,		       \
 	.encrypt		= xctr_crypt_##suffix,			       \
 	.decrypt		= xctr_crypt_##suffix,			       \
-}};									       \
+}}
 									       \
-static struct simd_skcipher_alg *					       \
-simd_skcipher_algs_##suffix[ARRAY_SIZE(skcipher_algs_##suffix)]
-
 DEFINE_AVX_SKCIPHER_ALGS(aesni_avx, "aesni-avx", 500);
 #if defined(CONFIG_AS_VAES) && defined(CONFIG_AS_VPCLMULQDQ)
 DEFINE_AVX_SKCIPHER_ALGS(vaes_avx2, "vaes-avx2", 600);
 DEFINE_AVX_SKCIPHER_ALGS(vaes_avx10_256, "vaes-avx10_256", 700);
 DEFINE_AVX_SKCIPHER_ALGS(vaes_avx10_512, "vaes-avx10_512", 800);
@@ -1508,14 +1494,13 @@ static struct aead_alg aes_gcm_algs_##suffix[] = { {			       \
 	.decrypt		= gcm_decrypt_##suffix,			       \
 	.ivsize			= GCM_AES_IV_SIZE,			       \
 	.chunksize		= AES_BLOCK_SIZE,			       \
 	.maxauthsize		= 16,					       \
 	.base = {							       \
-		.cra_name		= "__gcm(aes)",			       \
-		.cra_driver_name	= "__" generic_driver_name,	       \
+		.cra_name		= "gcm(aes)",			       \
+		.cra_driver_name	= generic_driver_name,		       \
 		.cra_priority		= (priority),			       \
-		.cra_flags		= CRYPTO_ALG_INTERNAL,		       \
 		.cra_blocksize		= 1,				       \
 		.cra_ctxsize		= (ctxsize),			       \
 		.cra_module		= THIS_MODULE,			       \
 	},								       \
 }, {									       \
@@ -1525,21 +1510,18 @@ static struct aead_alg aes_gcm_algs_##suffix[] = { {			       \
 	.decrypt		= rfc4106_decrypt_##suffix,		       \
 	.ivsize			= GCM_RFC4106_IV_SIZE,			       \
 	.chunksize		= AES_BLOCK_SIZE,			       \
 	.maxauthsize		= 16,					       \
 	.base = {							       \
-		.cra_name		= "__rfc4106(gcm(aes))",	       \
-		.cra_driver_name	= "__" rfc_driver_name,		       \
+		.cra_name		= "rfc4106(gcm(aes))",		       \
+		.cra_driver_name	= rfc_driver_name,		       \
 		.cra_priority		= (priority),			       \
-		.cra_flags		= CRYPTO_ALG_INTERNAL,		       \
 		.cra_blocksize		= 1,				       \
 		.cra_ctxsize		= (ctxsize),			       \
 		.cra_module		= THIS_MODULE,			       \
 	},								       \
-} };									       \
-									       \
-static struct simd_aead_alg *aes_gcm_simdalgs_##suffix[2]		       \
+} }
 
 /* aes_gcm_algs_aesni */
 DEFINE_GCM_ALGS(aesni, /* no flags */ 0,
 		"generic-gcm-aesni", "rfc4106-gcm-aesni",
 		AES_GCM_KEY_AESNI_SIZE, 400);
@@ -1585,18 +1567,16 @@ static int __init register_avx_algs(void)
 {
 	int err;
 
 	if (!boot_cpu_has(X86_FEATURE_AVX))
 		return 0;
-	err = simd_register_skciphers_compat(skcipher_algs_aesni_avx,
-					     ARRAY_SIZE(skcipher_algs_aesni_avx),
-					     simd_skcipher_algs_aesni_avx);
+	err = crypto_register_skciphers(skcipher_algs_aesni_avx,
+					ARRAY_SIZE(skcipher_algs_aesni_avx));
 	if (err)
 		return err;
-	err = simd_register_aeads_compat(aes_gcm_algs_aesni_avx,
-					 ARRAY_SIZE(aes_gcm_algs_aesni_avx),
-					 aes_gcm_simdalgs_aesni_avx);
+	err = crypto_register_aeads(aes_gcm_algs_aesni_avx,
+				    ARRAY_SIZE(aes_gcm_algs_aesni_avx));
 	if (err)
 		return err;
 	/*
 	 * Note: not all the algorithms registered below actually require
 	 * VPCLMULQDQ.  But in practice every CPU with VAES also has VPCLMULQDQ.
@@ -1608,31 +1588,28 @@ static int __init register_avx_algs(void)
 	    !boot_cpu_has(X86_FEATURE_VAES) ||
 	    !boot_cpu_has(X86_FEATURE_VPCLMULQDQ) ||
 	    !boot_cpu_has(X86_FEATURE_PCLMULQDQ) ||
 	    !cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM, NULL))
 		return 0;
-	err = simd_register_skciphers_compat(skcipher_algs_vaes_avx2,
-					     ARRAY_SIZE(skcipher_algs_vaes_avx2),
-					     simd_skcipher_algs_vaes_avx2);
+	err = crypto_register_skciphers(skcipher_algs_vaes_avx2,
+					ARRAY_SIZE(skcipher_algs_vaes_avx2));
 	if (err)
 		return err;
 
 	if (!boot_cpu_has(X86_FEATURE_AVX512BW) ||
 	    !boot_cpu_has(X86_FEATURE_AVX512VL) ||
 	    !boot_cpu_has(X86_FEATURE_BMI2) ||
 	    !cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM |
 			       XFEATURE_MASK_AVX512, NULL))
 		return 0;
 
-	err = simd_register_skciphers_compat(skcipher_algs_vaes_avx10_256,
-					     ARRAY_SIZE(skcipher_algs_vaes_avx10_256),
-					     simd_skcipher_algs_vaes_avx10_256);
+	err = crypto_register_skciphers(skcipher_algs_vaes_avx10_256,
+					ARRAY_SIZE(skcipher_algs_vaes_avx10_256));
 	if (err)
 		return err;
-	err = simd_register_aeads_compat(aes_gcm_algs_vaes_avx10_256,
-					 ARRAY_SIZE(aes_gcm_algs_vaes_avx10_256),
-					 aes_gcm_simdalgs_vaes_avx10_256);
+	err = crypto_register_aeads(aes_gcm_algs_vaes_avx10_256,
+				    ARRAY_SIZE(aes_gcm_algs_vaes_avx10_256));
 	if (err)
 		return err;
 
 	if (x86_match_cpu(zmm_exclusion_list)) {
 		int i;
@@ -1641,60 +1618,43 @@ static int __init register_avx_algs(void)
 			skcipher_algs_vaes_avx10_512[i].base.cra_priority = 1;
 		for (i = 0; i < ARRAY_SIZE(aes_gcm_algs_vaes_avx10_512); i++)
 			aes_gcm_algs_vaes_avx10_512[i].base.cra_priority = 1;
 	}
 
-	err = simd_register_skciphers_compat(skcipher_algs_vaes_avx10_512,
-					     ARRAY_SIZE(skcipher_algs_vaes_avx10_512),
-					     simd_skcipher_algs_vaes_avx10_512);
+	err = crypto_register_skciphers(skcipher_algs_vaes_avx10_512,
+					ARRAY_SIZE(skcipher_algs_vaes_avx10_512));
 	if (err)
 		return err;
-	err = simd_register_aeads_compat(aes_gcm_algs_vaes_avx10_512,
-					 ARRAY_SIZE(aes_gcm_algs_vaes_avx10_512),
-					 aes_gcm_simdalgs_vaes_avx10_512);
+	err = crypto_register_aeads(aes_gcm_algs_vaes_avx10_512,
+				    ARRAY_SIZE(aes_gcm_algs_vaes_avx10_512));
 	if (err)
 		return err;
 #endif /* CONFIG_AS_VAES && CONFIG_AS_VPCLMULQDQ */
 	return 0;
 }
 
+#define unregister_skciphers(A) \
+	if (refcount_read(&(A)[0].base.cra_refcnt) != 0) \
+		crypto_unregister_skciphers((A), ARRAY_SIZE(A))
+#define unregister_aeads(A) \
+	if (refcount_read(&(A)[0].base.cra_refcnt) != 0) \
+		crypto_unregister_aeads((A), ARRAY_SIZE(A))
+
 static void unregister_avx_algs(void)
 {
-	if (simd_skcipher_algs_aesni_avx[0])
-		simd_unregister_skciphers(skcipher_algs_aesni_avx,
-					  ARRAY_SIZE(skcipher_algs_aesni_avx),
-					  simd_skcipher_algs_aesni_avx);
-	if (aes_gcm_simdalgs_aesni_avx[0])
-		simd_unregister_aeads(aes_gcm_algs_aesni_avx,
-				      ARRAY_SIZE(aes_gcm_algs_aesni_avx),
-				      aes_gcm_simdalgs_aesni_avx);
+	unregister_skciphers(skcipher_algs_aesni_avx);
+	unregister_aeads(aes_gcm_algs_aesni_avx);
 #if defined(CONFIG_AS_VAES) && defined(CONFIG_AS_VPCLMULQDQ)
-	if (simd_skcipher_algs_vaes_avx2[0])
-		simd_unregister_skciphers(skcipher_algs_vaes_avx2,
-					  ARRAY_SIZE(skcipher_algs_vaes_avx2),
-					  simd_skcipher_algs_vaes_avx2);
-	if (simd_skcipher_algs_vaes_avx10_256[0])
-		simd_unregister_skciphers(skcipher_algs_vaes_avx10_256,
-					  ARRAY_SIZE(skcipher_algs_vaes_avx10_256),
-					  simd_skcipher_algs_vaes_avx10_256);
-	if (aes_gcm_simdalgs_vaes_avx10_256[0])
-		simd_unregister_aeads(aes_gcm_algs_vaes_avx10_256,
-				      ARRAY_SIZE(aes_gcm_algs_vaes_avx10_256),
-				      aes_gcm_simdalgs_vaes_avx10_256);
-	if (simd_skcipher_algs_vaes_avx10_512[0])
-		simd_unregister_skciphers(skcipher_algs_vaes_avx10_512,
-					  ARRAY_SIZE(skcipher_algs_vaes_avx10_512),
-					  simd_skcipher_algs_vaes_avx10_512);
-	if (aes_gcm_simdalgs_vaes_avx10_512[0])
-		simd_unregister_aeads(aes_gcm_algs_vaes_avx10_512,
-				      ARRAY_SIZE(aes_gcm_algs_vaes_avx10_512),
-				      aes_gcm_simdalgs_vaes_avx10_512);
+	unregister_skciphers(skcipher_algs_vaes_avx2);
+	unregister_skciphers(skcipher_algs_vaes_avx10_256);
+	unregister_skciphers(skcipher_algs_vaes_avx10_512);
+	unregister_aeads(aes_gcm_algs_vaes_avx10_256);
+	unregister_aeads(aes_gcm_algs_vaes_avx10_512);
 #endif
 }
 #else /* CONFIG_X86_64 */
 static struct aead_alg aes_gcm_algs_aesni[0];
-static struct simd_aead_alg *aes_gcm_simdalgs_aesni[0];
 
 static int __init register_avx_algs(void)
 {
 	return 0;
 }
@@ -1719,19 +1679,17 @@ static int __init aesni_init(void)
 
 	err = crypto_register_alg(&aesni_cipher_alg);
 	if (err)
 		return err;
 
-	err = simd_register_skciphers_compat(aesni_skciphers,
-					     ARRAY_SIZE(aesni_skciphers),
-					     aesni_simd_skciphers);
+	err = crypto_register_skciphers(aesni_skciphers,
+					ARRAY_SIZE(aesni_skciphers));
 	if (err)
 		goto unregister_cipher;
 
-	err = simd_register_aeads_compat(aes_gcm_algs_aesni,
-					 ARRAY_SIZE(aes_gcm_algs_aesni),
-					 aes_gcm_simdalgs_aesni);
+	err = crypto_register_aeads(aes_gcm_algs_aesni,
+				    ARRAY_SIZE(aes_gcm_algs_aesni));
 	if (err)
 		goto unregister_skciphers;
 
 	err = register_avx_algs();
 	if (err)
@@ -1739,28 +1697,26 @@ static int __init aesni_init(void)
 
 	return 0;
 
 unregister_avx:
 	unregister_avx_algs();
-	simd_unregister_aeads(aes_gcm_algs_aesni,
-			      ARRAY_SIZE(aes_gcm_algs_aesni),
-			      aes_gcm_simdalgs_aesni);
+	crypto_unregister_aeads(aes_gcm_algs_aesni,
+				ARRAY_SIZE(aes_gcm_algs_aesni));
 unregister_skciphers:
-	simd_unregister_skciphers(aesni_skciphers, ARRAY_SIZE(aesni_skciphers),
-				  aesni_simd_skciphers);
+	crypto_unregister_skciphers(aesni_skciphers,
+				    ARRAY_SIZE(aesni_skciphers));
 unregister_cipher:
 	crypto_unregister_alg(&aesni_cipher_alg);
 	return err;
 }
 
 static void __exit aesni_exit(void)
 {
-	simd_unregister_aeads(aes_gcm_algs_aesni,
-			      ARRAY_SIZE(aes_gcm_algs_aesni),
-			      aes_gcm_simdalgs_aesni);
-	simd_unregister_skciphers(aesni_skciphers, ARRAY_SIZE(aesni_skciphers),
-				  aesni_simd_skciphers);
+	crypto_unregister_aeads(aes_gcm_algs_aesni,
+				ARRAY_SIZE(aes_gcm_algs_aesni));
+	crypto_unregister_skciphers(aesni_skciphers,
+				    ARRAY_SIZE(aesni_skciphers));
 	crypto_unregister_alg(&aesni_cipher_alg);
 	unregister_avx_algs();
 }
 
 module_init(aesni_init);
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
 
diff --git a/arch/x86/crypto/sm4_aesni_avx2_glue.c b/arch/x86/crypto/sm4_aesni_avx2_glue.c
index 1148fd4cd57f8..14596091560d6 100644
--- a/arch/x86/crypto/sm4_aesni_avx2_glue.c
+++ b/arch/x86/crypto/sm4_aesni_avx2_glue.c
@@ -9,12 +9,10 @@
  */
 
 #include <linux/module.h>
 #include <linux/crypto.h>
 #include <linux/kernel.h>
-#include <asm/simd.h>
-#include <crypto/internal/simd.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/sm4.h>
 #include "sm4-avx.h"
 
 #define SM4_CRYPT16_BLOCK_SIZE	(SM4_BLOCK_SIZE * 16)
@@ -46,14 +44,13 @@ static int ctr_crypt(struct skcipher_request *req)
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
@@ -62,14 +59,13 @@ static struct skcipher_alg sm4_aesni_avx2_skciphers[] = {
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
@@ -79,14 +75,13 @@ static struct skcipher_alg sm4_aesni_avx2_skciphers[] = {
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
@@ -98,13 +93,10 @@ static struct skcipher_alg sm4_aesni_avx2_skciphers[] = {
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
@@ -119,20 +111,18 @@ static int __init sm4_init(void)
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
index 85b4ca78b47b5..d8289a8fa3807 100644
--- a/arch/x86/crypto/sm4_aesni_avx_glue.c
+++ b/arch/x86/crypto/sm4_aesni_avx_glue.c
@@ -9,12 +9,10 @@
  */
 
 #include <linux/module.h>
 #include <linux/crypto.h>
 #include <linux/kernel.h>
-#include <asm/simd.h>
-#include <crypto/internal/simd.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/sm4.h>
 #include "sm4-avx.h"
 
 #define SM4_CRYPT8_BLOCK_SIZE	(SM4_BLOCK_SIZE * 8)
@@ -261,14 +259,13 @@ static int ctr_crypt(struct skcipher_request *req)
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
@@ -277,14 +274,13 @@ static struct skcipher_alg sm4_aesni_avx_skciphers[] = {
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
@@ -294,14 +290,13 @@ static struct skcipher_alg sm4_aesni_avx_skciphers[] = {
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
@@ -313,13 +308,10 @@ static struct skcipher_alg sm4_aesni_avx_skciphers[] = {
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
@@ -333,20 +325,18 @@ static int __init sm4_init(void)
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
 
diff --git a/arch/x86/crypto/twofish_avx_glue.c b/arch/x86/crypto/twofish_avx_glue.c
index 3eb3440b477a8..9e20db0137501 100644
--- a/arch/x86/crypto/twofish_avx_glue.c
+++ b/arch/x86/crypto/twofish_avx_glue.c
@@ -11,11 +11,10 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/crypto.h>
 #include <linux/err.h>
 #include <crypto/algapi.h>
-#include <crypto/internal/simd.h>
 #include <crypto/twofish.h>
 
 #include "twofish.h"
 #include "ecb_cbc_helpers.h"
 
@@ -72,27 +71,25 @@ static int cbc_decrypt(struct skcipher_request *req)
 	CBC_WALK_END();
 }
 
 static struct skcipher_alg twofish_algs[] = {
 	{
-		.base.cra_name		= "__ecb(twofish)",
-		.base.cra_driver_name	= "__ecb-twofish-avx",
+		.base.cra_name		= "ecb(twofish)",
+		.base.cra_driver_name	= "ecb-twofish-avx",
 		.base.cra_priority	= 400,
-		.base.cra_flags		= CRYPTO_ALG_INTERNAL,
 		.base.cra_blocksize	= TF_BLOCK_SIZE,
 		.base.cra_ctxsize	= sizeof(struct twofish_ctx),
 		.base.cra_module	= THIS_MODULE,
 		.min_keysize		= TF_MIN_KEY_SIZE,
 		.max_keysize		= TF_MAX_KEY_SIZE,
 		.setkey			= twofish_setkey_skcipher,
 		.encrypt		= ecb_encrypt,
 		.decrypt		= ecb_decrypt,
 	}, {
-		.base.cra_name		= "__cbc(twofish)",
-		.base.cra_driver_name	= "__cbc-twofish-avx",
+		.base.cra_name		= "cbc(twofish)",
+		.base.cra_driver_name	= "cbc-twofish-avx",
 		.base.cra_priority	= 400,
-		.base.cra_flags		= CRYPTO_ALG_INTERNAL,
 		.base.cra_blocksize	= TF_BLOCK_SIZE,
 		.base.cra_ctxsize	= sizeof(struct twofish_ctx),
 		.base.cra_module	= THIS_MODULE,
 		.min_keysize		= TF_MIN_KEY_SIZE,
 		.max_keysize		= TF_MAX_KEY_SIZE,
@@ -101,30 +98,26 @@ static struct skcipher_alg twofish_algs[] = {
 		.encrypt		= cbc_encrypt,
 		.decrypt		= cbc_decrypt,
 	},
 };
 
-static struct simd_skcipher_alg *twofish_simd_algs[ARRAY_SIZE(twofish_algs)];
-
 static int __init twofish_init(void)
 {
 	const char *feature_name;
 
 	if (!cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM, &feature_name)) {
 		pr_info("CPU feature '%s' is not supported.\n", feature_name);
 		return -ENODEV;
 	}
 
-	return simd_register_skciphers_compat(twofish_algs,
-					      ARRAY_SIZE(twofish_algs),
-					      twofish_simd_algs);
+	return crypto_register_skciphers(twofish_algs,
+					 ARRAY_SIZE(twofish_algs));
 }
 
 static void __exit twofish_exit(void)
 {
-	simd_unregister_skciphers(twofish_algs, ARRAY_SIZE(twofish_algs),
-				  twofish_simd_algs);
+	crypto_unregister_skciphers(twofish_algs, ARRAY_SIZE(twofish_algs));
 }
 
 module_init(twofish_init);
 module_exit(twofish_exit);
 
-- 
2.48.1

