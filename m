Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F5871373;
	Wed,  2 Apr 2025 00:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743553484; cv=none; b=EBouLEtbxuqSSPb8+jSWhoxCKnLavTH3wE0zus6xEs4JW7DT8+HTS8EBXEtNtJVqyMJQmcBHTldjyPE3MV7aoJu0BWEQ83cp8A0t0KNktcAJmXSBeZTWHuGVK5SRHdWBpKmoy5DFLD3x5QONwKJYa4BCNlT2vJMn2/wK28rukjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743553484; c=relaxed/simple;
	bh=ETpb9VgZiZRwoLdTu/XcIdbIz5Fmm4oaTk3q9AJA4F8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BnSd3IyvgKkD/tAochdFf6C7Wcmyksw/o6iTDvewShpytU17XrMz5tFk/lfcS6Yi7W+rZ494k/uouS+DDxTnNpWuzj8xIkekJ45oIre00+xLHa2ZwePp8Xg+QrWcWDUaZXU4fa2emMznD7GSJ2g9HqBYi1Af/+CNBHJt4BBt3yM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R/wTC+nY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R/wTC+nY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06087C4CEEF;
	Wed,  2 Apr 2025 00:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743553484;
	bh=ETpb9VgZiZRwoLdTu/XcIdbIz5Fmm4oaTk3q9AJA4F8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R/wTC+nYgsFi3kyZ9swfs7sIwzx+av9PqQTvPamoSnjSgvaDnYOAwMftWDdjftvoL
	 nTd+128blTdCgIJJCwZiRk5v8lxfVX5By9TKHX5WD4iTVXJldddYk4Vqzvy3pC+uqK
	 kqr8NAXgUURxak2JijpnSmbHluC4Fhi9hLLC+VgWoQImlsqd3gIeC4FitsbR97n333
	 RBgGw3C9UgwPQ6f7sAsP4RnHuay1UjxGse7+t36Ee8MkvdeKjCseOHITU5EL8cOKY1
	 Tlx89sHyI+nA9RQPy4GJJHSq4BX7C/Yxgde1Zwa5J4wr17tvC7+mMU7TIdpl3ZYonv
	 j+PuFvoejOwVw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH v2 3/9] crypto: x86/aes - stop using the SIMD helper
Date: Tue,  1 Apr 2025 17:24:03 -0700
Message-ID: <20250402002420.89233-4-ebiggers@kernel.org>
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
 arch/x86/crypto/Kconfig            |   1 -
 arch/x86/crypto/aesni-intel_glue.c | 158 +++++++++++------------------
 2 files changed, 59 insertions(+), 100 deletions(-)

diff --git a/arch/x86/crypto/Kconfig b/arch/x86/crypto/Kconfig
index c15400efac075..d8f9d6279cb26 100644
--- a/arch/x86/crypto/Kconfig
+++ b/arch/x86/crypto/Kconfig
@@ -21,11 +21,10 @@ config CRYPTO_AES_NI_INTEL
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
 
diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 5bdeda39cef65..061b1ced93c51 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -564,14 +564,13 @@ static struct crypto_alg aesni_cipher_alg = {
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
@@ -579,14 +578,13 @@ static struct skcipher_alg aesni_skciphers[] = {
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
@@ -595,14 +593,13 @@ static struct skcipher_alg aesni_skciphers[] = {
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
@@ -613,14 +610,13 @@ static struct skcipher_alg aesni_skciphers[] = {
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
@@ -631,14 +627,13 @@ static struct skcipher_alg aesni_skciphers[] = {
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
@@ -649,13 +644,10 @@ static struct skcipher_alg aesni_skciphers[] = {
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
@@ -790,14 +782,13 @@ static int xctr_crypt_##suffix(struct skcipher_request *req)		       \
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
@@ -805,14 +796,13 @@ static struct skcipher_alg skcipher_algs_##suffix[] = {{		       \
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
@@ -820,28 +810,24 @@ static struct skcipher_alg skcipher_algs_##suffix[] = {{		       \
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
-									       \
-static struct simd_skcipher_alg *					       \
-simd_skcipher_algs_##suffix[ARRAY_SIZE(skcipher_algs_##suffix)]
+}}
 
 DEFINE_AVX_SKCIPHER_ALGS(aesni_avx, "aesni-avx", 500);
 #if defined(CONFIG_AS_VAES) && defined(CONFIG_AS_VPCLMULQDQ)
 DEFINE_AVX_SKCIPHER_ALGS(vaes_avx2, "vaes-avx2", 600);
 DEFINE_AVX_SKCIPHER_ALGS(vaes_avx512, "vaes-avx512", 800);
@@ -1496,14 +1482,13 @@ static struct aead_alg aes_gcm_algs_##suffix[] = { {			       \
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
@@ -1513,21 +1498,18 @@ static struct aead_alg aes_gcm_algs_##suffix[] = { {			       \
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
@@ -1553,18 +1535,16 @@ static int __init register_avx_algs(void)
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
@@ -1576,26 +1556,24 @@ static int __init register_avx_algs(void)
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
 
-	err = simd_register_aeads_compat(aes_gcm_algs_vaes_avx10_256,
-					 ARRAY_SIZE(aes_gcm_algs_vaes_avx10_256),
-					 aes_gcm_simdalgs_vaes_avx10_256);
+	err = crypto_register_aeads(aes_gcm_algs_vaes_avx10_256,
+				    ARRAY_SIZE(aes_gcm_algs_vaes_avx10_256));
 	if (err)
 		return err;
 
 	if (boot_cpu_has(X86_FEATURE_PREFER_YMM)) {
 		int i;
@@ -1604,56 +1582,42 @@ static int __init register_avx_algs(void)
 			skcipher_algs_vaes_avx512[i].base.cra_priority = 1;
 		for (i = 0; i < ARRAY_SIZE(aes_gcm_algs_vaes_avx10_512); i++)
 			aes_gcm_algs_vaes_avx10_512[i].base.cra_priority = 1;
 	}
 
-	err = simd_register_skciphers_compat(skcipher_algs_vaes_avx512,
-					     ARRAY_SIZE(skcipher_algs_vaes_avx512),
-					     simd_skcipher_algs_vaes_avx512);
+	err = crypto_register_skciphers(skcipher_algs_vaes_avx512,
+					ARRAY_SIZE(skcipher_algs_vaes_avx512));
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
-	if (aes_gcm_simdalgs_vaes_avx10_256[0])
-		simd_unregister_aeads(aes_gcm_algs_vaes_avx10_256,
-				      ARRAY_SIZE(aes_gcm_algs_vaes_avx10_256),
-				      aes_gcm_simdalgs_vaes_avx10_256);
-	if (simd_skcipher_algs_vaes_avx512[0])
-		simd_unregister_skciphers(skcipher_algs_vaes_avx512,
-					  ARRAY_SIZE(skcipher_algs_vaes_avx512),
-					  simd_skcipher_algs_vaes_avx512);
-	if (aes_gcm_simdalgs_vaes_avx10_512[0])
-		simd_unregister_aeads(aes_gcm_algs_vaes_avx10_512,
-				      ARRAY_SIZE(aes_gcm_algs_vaes_avx10_512),
-				      aes_gcm_simdalgs_vaes_avx10_512);
+	unregister_skciphers(skcipher_algs_vaes_avx2);
+	unregister_skciphers(skcipher_algs_vaes_avx512);
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
@@ -1678,19 +1642,17 @@ static int __init aesni_init(void)
 
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
@@ -1698,28 +1660,26 @@ static int __init aesni_init(void)
 
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
-- 
2.49.0

