Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 497EF30BB94;
	Fri, 26 Jun 2026 04:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782448766; cv=none; b=H6zw9YEUfJzwHm1QzzcSTZfCYMOSxC3/3pU4t5Uca+BJVPtfzs45cU9gHfYuz7xosbPhELWoJuAQl8qmBr8dgD1gfce7nOKvrBWKYSohN97XBPOHT7ztYxOUusnuASHmPUNAiut7AS221YTgoI4Pg3/3SOTcIw6Jx6TJcmA2Uws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782448766; c=relaxed/simple;
	bh=NAhbtKpDga7i4kYyZTPd+ANfMqgjZE95rwHCf5Iho4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EOC1t8WDeXLRrZHfRVirLhznOs2F9G3j4Rg56U+dZX3NdMxQyqYBdbOU/Rn3+FG5Aa4fP/y+3g5b0m/MOuqmPo+jvx9mXsTbyMBOixLzqZEVW9nZJyMJT6x9V6yyby5CyGWoYMsHkeeEHIoqN79q1LTR+bdDELHrliaR1UpMZaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GkVrThEb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GkVrThEb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC2211F00AC4;
	Fri, 26 Jun 2026 04:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782448765;
	bh=gxoZP6Pr0YnypyftwoQrAvxUsTuHgu5ZtqELJ6xUkRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GkVrThEb0HHVT12BGHptgMGDQ/IrMCV5rOnueN6/U+dqfd7d1xz3ZpP0ohlsmAhTW
	 LrN8fpyvwT1ehFZM1fHHUjFP1AupC/iEBiJ+XZ2b9NR6wk3snsElsPkhgB6fpRc7VO
	 +7DBI1CpPW5GpCIUePI5FqgZyclPDs+nZOHbSzzMExxQPciaOzfV7wlE3efI6zOkFX
	 OKfH+YyGVaVc/0h93NHxCl+XdFSYdjV9DIIxIOwMb9oahOnowIgDN2zz2CWeN6yw0C
	 1SbqpH723xphgvJiWUBuAiqxwEt2XrDMvmhIJB7w2sW5/BOgk+Oq5dM78QvCQYPvhr
	 cQck0dR840UhQ==
From: Eric Biggers <ebiggers@kernel.org>
To: x86@kernel.org
Cc: linux-um@lists.infradead.org,
	linux-raid@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 3/8] crypto: x86 - Stop using cpu_has_xfeatures()
Date: Thu, 25 Jun 2026 21:37:26 -0700
Message-ID: <20260626043731.319287-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260626043731.319287-1-ebiggers@kernel.org>
References: <20260626043731.319287-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Checking both boot_cpu_has(X86_FEATURE_AVX*) and cpu_has_xfeatures() has
never really been needed in practice, and it's never been universally
done (e.g., lib/raid/ omits cpu_has_xfeatures()).  Nevertheless, both
x86 and UML now explicitly clear the AVX and AVX-512 flags if their
xfeatures are missing, which should remove any remaining doubts.

Thus, remove all the calls to cpu_has_xfeatures(), as well as the
related checks of boot_cpu_has(X86_FEATURE_OSXSAVE).

In a few cases there was no corresponding boot_cpu_has(X86_FEATURE_AVX*)
check, so add the missing ones.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/x86/crypto/aegis128-aesni-glue.c      |  3 +--
 arch/x86/crypto/aesni-intel_glue.c         |  7 ++-----
 arch/x86/crypto/aria_aesni_avx2_glue.c     | 11 +----------
 arch/x86/crypto/aria_aesni_avx_glue.c      | 11 +----------
 arch/x86/crypto/aria_gfni_avx512_glue.c    | 11 +----------
 arch/x86/crypto/camellia_aesni_avx2_glue.c | 11 +----------
 arch/x86/crypto/camellia_aesni_avx_glue.c  | 11 +----------
 arch/x86/crypto/cast5_avx_glue.c           |  7 ++-----
 arch/x86/crypto/cast6_avx_glue.c           |  7 ++-----
 arch/x86/crypto/serpent_avx2_glue.c        |  9 +--------
 arch/x86/crypto/serpent_avx_glue.c         |  7 ++-----
 arch/x86/crypto/sm4_aesni_avx2_glue.c      | 11 +----------
 arch/x86/crypto/sm4_aesni_avx_glue.c       | 11 +----------
 arch/x86/crypto/twofish_avx_glue.c         |  6 ++----
 14 files changed, 19 insertions(+), 104 deletions(-)

diff --git a/arch/x86/crypto/aegis128-aesni-glue.c b/arch/x86/crypto/aegis128-aesni-glue.c
index f1adfba1a76e..09fc0b15b0e9 100644
--- a/arch/x86/crypto/aegis128-aesni-glue.c
+++ b/arch/x86/crypto/aegis128-aesni-glue.c
@@ -263,12 +263,11 @@ static struct aead_alg crypto_aegis128_aesni_alg = {
 };
 
 static int __init crypto_aegis128_aesni_module_init(void)
 {
 	if (!boot_cpu_has(X86_FEATURE_XMM4_1) ||
-	    !boot_cpu_has(X86_FEATURE_AES) ||
-	    !cpu_has_xfeatures(XFEATURE_MASK_SSE, NULL))
+	    !boot_cpu_has(X86_FEATURE_AES))
 		return -ENODEV;
 
 	return crypto_register_aead(&crypto_aegis128_aesni_alg);
 }
 
diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index f522fff9231e..f6f899db7482 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -1546,12 +1546,11 @@ static int __init register_avx_algs(void)
 	 * For simplicity, just always check for VAES and VPCLMULQDQ together.
 	 */
 	if (!boot_cpu_has(X86_FEATURE_AVX2) ||
 	    !boot_cpu_has(X86_FEATURE_VAES) ||
 	    !boot_cpu_has(X86_FEATURE_VPCLMULQDQ) ||
-	    !boot_cpu_has(X86_FEATURE_PCLMULQDQ) ||
-	    !cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM, NULL))
+	    !boot_cpu_has(X86_FEATURE_PCLMULQDQ))
 		return 0;
 	err = crypto_register_skciphers(skcipher_algs_vaes_avx2,
 					ARRAY_SIZE(skcipher_algs_vaes_avx2));
 	if (err)
 		return err;
@@ -1560,13 +1559,11 @@ static int __init register_avx_algs(void)
 	if (err)
 		return err;
 
 	if (!boot_cpu_has(X86_FEATURE_AVX512BW) ||
 	    !boot_cpu_has(X86_FEATURE_AVX512VL) ||
-	    !boot_cpu_has(X86_FEATURE_BMI2) ||
-	    !cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM |
-			       XFEATURE_MASK_AVX512, NULL))
+	    !boot_cpu_has(X86_FEATURE_BMI2))
 		return 0;
 
 	if (boot_cpu_has(X86_FEATURE_PREFER_YMM)) {
 		int i;
 
diff --git a/arch/x86/crypto/aria_aesni_avx2_glue.c b/arch/x86/crypto/aria_aesni_avx2_glue.c
index 1487a49bfbac..371be2fb6469 100644
--- a/arch/x86/crypto/aria_aesni_avx2_glue.c
+++ b/arch/x86/crypto/aria_aesni_avx2_glue.c
@@ -193,26 +193,17 @@ static struct skcipher_alg aria_algs[] = {
 	}
 };
 
 static int __init aria_avx2_init(void)
 {
-	const char *feature_name;
-
 	if (!boot_cpu_has(X86_FEATURE_AVX) ||
 	    !boot_cpu_has(X86_FEATURE_AVX2) ||
-	    !boot_cpu_has(X86_FEATURE_AES) ||
-	    !boot_cpu_has(X86_FEATURE_OSXSAVE)) {
+	    !boot_cpu_has(X86_FEATURE_AES)) {
 		pr_info("AVX2 or AES-NI instructions are not detected.\n");
 		return -ENODEV;
 	}
 
-	if (!cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM,
-				&feature_name)) {
-		pr_info("CPU feature '%s' is not supported.\n", feature_name);
-		return -ENODEV;
-	}
-
 	if (boot_cpu_has(X86_FEATURE_GFNI)) {
 		aria_ops.aria_encrypt_16way = aria_aesni_avx_gfni_encrypt_16way;
 		aria_ops.aria_decrypt_16way = aria_aesni_avx_gfni_decrypt_16way;
 		aria_ops.aria_ctr_crypt_16way = aria_aesni_avx_gfni_ctr_crypt_16way;
 		aria_ops.aria_encrypt_32way = aria_aesni_avx2_gfni_encrypt_32way;
diff --git a/arch/x86/crypto/aria_aesni_avx_glue.c b/arch/x86/crypto/aria_aesni_avx_glue.c
index e4e3d78915a5..d23fc91c0ebd 100644
--- a/arch/x86/crypto/aria_aesni_avx_glue.c
+++ b/arch/x86/crypto/aria_aesni_avx_glue.c
@@ -180,25 +180,16 @@ static struct skcipher_alg aria_algs[] = {
 	}
 };
 
 static int __init aria_avx_init(void)
 {
-	const char *feature_name;
-
 	if (!boot_cpu_has(X86_FEATURE_AVX) ||
-	    !boot_cpu_has(X86_FEATURE_AES) ||
-	    !boot_cpu_has(X86_FEATURE_OSXSAVE)) {
+	    !boot_cpu_has(X86_FEATURE_AES)) {
 		pr_info("AVX or AES-NI instructions are not detected.\n");
 		return -ENODEV;
 	}
 
-	if (!cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM,
-				&feature_name)) {
-		pr_info("CPU feature '%s' is not supported.\n", feature_name);
-		return -ENODEV;
-	}
-
 	if (boot_cpu_has(X86_FEATURE_GFNI)) {
 		aria_ops.aria_encrypt_16way = aria_aesni_avx_gfni_encrypt_16way;
 		aria_ops.aria_decrypt_16way = aria_aesni_avx_gfni_decrypt_16way;
 		aria_ops.aria_ctr_crypt_16way = aria_aesni_avx_gfni_ctr_crypt_16way;
 	} else {
diff --git a/arch/x86/crypto/aria_gfni_avx512_glue.c b/arch/x86/crypto/aria_gfni_avx512_glue.c
index 363cbf4399cc..e05bbeb22d4a 100644
--- a/arch/x86/crypto/aria_gfni_avx512_glue.c
+++ b/arch/x86/crypto/aria_gfni_avx512_glue.c
@@ -194,28 +194,19 @@ static struct skcipher_alg aria_algs[] = {
 	}
 };
 
 static int __init aria_avx512_init(void)
 {
-	const char *feature_name;
-
 	if (!boot_cpu_has(X86_FEATURE_AVX) ||
 	    !boot_cpu_has(X86_FEATURE_AVX2) ||
 	    !boot_cpu_has(X86_FEATURE_AVX512F) ||
 	    !boot_cpu_has(X86_FEATURE_AVX512VL) ||
-	    !boot_cpu_has(X86_FEATURE_GFNI) ||
-	    !boot_cpu_has(X86_FEATURE_OSXSAVE)) {
+	    !boot_cpu_has(X86_FEATURE_GFNI)) {
 		pr_info("AVX512/GFNI instructions are not detected.\n");
 		return -ENODEV;
 	}
 
-	if (!cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM |
-			       XFEATURE_MASK_AVX512, &feature_name)) {
-		pr_info("CPU feature '%s' is not supported.\n", feature_name);
-		return -ENODEV;
-	}
-
 	aria_ops.aria_encrypt_16way = aria_aesni_avx_gfni_encrypt_16way;
 	aria_ops.aria_decrypt_16way = aria_aesni_avx_gfni_decrypt_16way;
 	aria_ops.aria_ctr_crypt_16way = aria_aesni_avx_gfni_ctr_crypt_16way;
 	aria_ops.aria_encrypt_32way = aria_aesni_avx2_gfni_encrypt_32way;
 	aria_ops.aria_decrypt_32way = aria_aesni_avx2_gfni_decrypt_32way;
diff --git a/arch/x86/crypto/camellia_aesni_avx2_glue.c b/arch/x86/crypto/camellia_aesni_avx2_glue.c
index 2d2f4e16537c..073fa3bb8388 100644
--- a/arch/x86/crypto/camellia_aesni_avx2_glue.c
+++ b/arch/x86/crypto/camellia_aesni_avx2_glue.c
@@ -95,26 +95,17 @@ static struct skcipher_alg camellia_algs[] = {
 	},
 };
 
 static int __init camellia_aesni_init(void)
 {
-	const char *feature_name;
-
 	if (!boot_cpu_has(X86_FEATURE_AVX) ||
 	    !boot_cpu_has(X86_FEATURE_AVX2) ||
-	    !boot_cpu_has(X86_FEATURE_AES) ||
-	    !boot_cpu_has(X86_FEATURE_OSXSAVE)) {
+	    !boot_cpu_has(X86_FEATURE_AES)) {
 		pr_info("AVX2 or AES-NI instructions are not detected.\n");
 		return -ENODEV;
 	}
 
-	if (!cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM,
-				&feature_name)) {
-		pr_info("CPU feature '%s' is not supported.\n", feature_name);
-		return -ENODEV;
-	}
-
 	return crypto_register_skciphers(camellia_algs,
 					 ARRAY_SIZE(camellia_algs));
 }
 
 static void __exit camellia_aesni_fini(void)
diff --git a/arch/x86/crypto/camellia_aesni_avx_glue.c b/arch/x86/crypto/camellia_aesni_avx_glue.c
index 5c321f255eb7..872e5e07220f 100644
--- a/arch/x86/crypto/camellia_aesni_avx_glue.c
+++ b/arch/x86/crypto/camellia_aesni_avx_glue.c
@@ -96,25 +96,16 @@ static struct skcipher_alg camellia_algs[] = {
 	}
 };
 
 static int __init camellia_aesni_init(void)
 {
-	const char *feature_name;
-
 	if (!boot_cpu_has(X86_FEATURE_AVX) ||
-	    !boot_cpu_has(X86_FEATURE_AES) ||
-	    !boot_cpu_has(X86_FEATURE_OSXSAVE)) {
+	    !boot_cpu_has(X86_FEATURE_AES)) {
 		pr_info("AVX or AES-NI instructions are not detected.\n");
 		return -ENODEV;
 	}
 
-	if (!cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM,
-				&feature_name)) {
-		pr_info("CPU feature '%s' is not supported.\n", feature_name);
-		return -ENODEV;
-	}
-
 	return crypto_register_skciphers(camellia_algs,
 					 ARRAY_SIZE(camellia_algs));
 }
 
 static void __exit camellia_aesni_fini(void)
diff --git a/arch/x86/crypto/cast5_avx_glue.c b/arch/x86/crypto/cast5_avx_glue.c
index 3aca04d43b34..5de35e863370 100644
--- a/arch/x86/crypto/cast5_avx_glue.c
+++ b/arch/x86/crypto/cast5_avx_glue.c
@@ -90,15 +90,12 @@ static struct skcipher_alg cast5_algs[] = {
 	}
 };
 
 static int __init cast5_init(void)
 {
-	const char *feature_name;
-
-	if (!cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM,
-				&feature_name)) {
-		pr_info("CPU feature '%s' is not supported.\n", feature_name);
+	if (!boot_cpu_has(X86_FEATURE_AVX)) {
+		pr_info("AVX instructions are not detected.\n");
 		return -ENODEV;
 	}
 
 	return crypto_register_skciphers(cast5_algs,
 					 ARRAY_SIZE(cast5_algs));
diff --git a/arch/x86/crypto/cast6_avx_glue.c b/arch/x86/crypto/cast6_avx_glue.c
index c4dd28c30303..3d7ea48007bc 100644
--- a/arch/x86/crypto/cast6_avx_glue.c
+++ b/arch/x86/crypto/cast6_avx_glue.c
@@ -90,15 +90,12 @@ static struct skcipher_alg cast6_algs[] = {
 	},
 };
 
 static int __init cast6_init(void)
 {
-	const char *feature_name;
-
-	if (!cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM,
-				&feature_name)) {
-		pr_info("CPU feature '%s' is not supported.\n", feature_name);
+	if (!boot_cpu_has(X86_FEATURE_AVX)) {
+		pr_info("AVX instructions are not detected.\n");
 		return -ENODEV;
 	}
 
 	return crypto_register_skciphers(cast6_algs, ARRAY_SIZE(cast6_algs));
 }
diff --git a/arch/x86/crypto/serpent_avx2_glue.c b/arch/x86/crypto/serpent_avx2_glue.c
index f5f2121b7956..72a9e2b306d6 100644
--- a/arch/x86/crypto/serpent_avx2_glue.c
+++ b/arch/x86/crypto/serpent_avx2_glue.c
@@ -91,21 +91,14 @@ static struct skcipher_alg serpent_algs[] = {
 	},
 };
 
 static int __init serpent_avx2_init(void)
 {
-	const char *feature_name;
-
-	if (!boot_cpu_has(X86_FEATURE_AVX2) || !boot_cpu_has(X86_FEATURE_OSXSAVE)) {
+	if (!boot_cpu_has(X86_FEATURE_AVX2)) {
 		pr_info("AVX2 instructions are not detected.\n");
 		return -ENODEV;
 	}
-	if (!cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM,
-				&feature_name)) {
-		pr_info("CPU feature '%s' is not supported.\n", feature_name);
-		return -ENODEV;
-	}
 
 	return crypto_register_skciphers(serpent_algs,
 					 ARRAY_SIZE(serpent_algs));
 }
 
diff --git a/arch/x86/crypto/serpent_avx_glue.c b/arch/x86/crypto/serpent_avx_glue.c
index 9c8b3a335d5c..42c4e1569674 100644
--- a/arch/x86/crypto/serpent_avx_glue.c
+++ b/arch/x86/crypto/serpent_avx_glue.c
@@ -98,15 +98,12 @@ static struct skcipher_alg serpent_algs[] = {
 	},
 };
 
 static int __init serpent_init(void)
 {
-	const char *feature_name;
-
-	if (!cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM,
-				&feature_name)) {
-		pr_info("CPU feature '%s' is not supported.\n", feature_name);
+	if (!boot_cpu_has(X86_FEATURE_AVX)) {
+		pr_info("AVX instructions are not detected.\n");
 		return -ENODEV;
 	}
 
 	return crypto_register_skciphers(serpent_algs,
 					 ARRAY_SIZE(serpent_algs));
diff --git a/arch/x86/crypto/sm4_aesni_avx2_glue.c b/arch/x86/crypto/sm4_aesni_avx2_glue.c
index fec0ab7a63dd..eef73894e777 100644
--- a/arch/x86/crypto/sm4_aesni_avx2_glue.c
+++ b/arch/x86/crypto/sm4_aesni_avx2_glue.c
@@ -96,26 +96,17 @@ static struct skcipher_alg sm4_aesni_avx2_skciphers[] = {
 	}
 };
 
 static int __init sm4_init(void)
 {
-	const char *feature_name;
-
 	if (!boot_cpu_has(X86_FEATURE_AVX) ||
 	    !boot_cpu_has(X86_FEATURE_AVX2) ||
-	    !boot_cpu_has(X86_FEATURE_AES) ||
-	    !boot_cpu_has(X86_FEATURE_OSXSAVE)) {
+	    !boot_cpu_has(X86_FEATURE_AES)) {
 		pr_info("AVX2 or AES-NI instructions are not detected.\n");
 		return -ENODEV;
 	}
 
-	if (!cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM,
-				&feature_name)) {
-		pr_info("CPU feature '%s' is not supported.\n", feature_name);
-		return -ENODEV;
-	}
-
 	return crypto_register_skciphers(sm4_aesni_avx2_skciphers,
 					 ARRAY_SIZE(sm4_aesni_avx2_skciphers));
 }
 
 static void __exit sm4_exit(void)
diff --git a/arch/x86/crypto/sm4_aesni_avx_glue.c b/arch/x86/crypto/sm4_aesni_avx_glue.c
index 88caf418a06f..ed383da5ff46 100644
--- a/arch/x86/crypto/sm4_aesni_avx_glue.c
+++ b/arch/x86/crypto/sm4_aesni_avx_glue.c
@@ -312,25 +312,16 @@ static struct skcipher_alg sm4_aesni_avx_skciphers[] = {
 	}
 };
 
 static int __init sm4_init(void)
 {
-	const char *feature_name;
-
 	if (!boot_cpu_has(X86_FEATURE_AVX) ||
-	    !boot_cpu_has(X86_FEATURE_AES) ||
-	    !boot_cpu_has(X86_FEATURE_OSXSAVE)) {
+	    !boot_cpu_has(X86_FEATURE_AES)) {
 		pr_info("AVX or AES-NI instructions are not detected.\n");
 		return -ENODEV;
 	}
 
-	if (!cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM,
-				&feature_name)) {
-		pr_info("CPU feature '%s' is not supported.\n", feature_name);
-		return -ENODEV;
-	}
-
 	return crypto_register_skciphers(sm4_aesni_avx_skciphers,
 					 ARRAY_SIZE(sm4_aesni_avx_skciphers));
 }
 
 static void __exit sm4_exit(void)
diff --git a/arch/x86/crypto/twofish_avx_glue.c b/arch/x86/crypto/twofish_avx_glue.c
index 9e20db013750..985bc54a2340 100644
--- a/arch/x86/crypto/twofish_avx_glue.c
+++ b/arch/x86/crypto/twofish_avx_glue.c
@@ -100,14 +100,12 @@ static struct skcipher_alg twofish_algs[] = {
 	},
 };
 
 static int __init twofish_init(void)
 {
-	const char *feature_name;
-
-	if (!cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM, &feature_name)) {
-		pr_info("CPU feature '%s' is not supported.\n", feature_name);
+	if (!boot_cpu_has(X86_FEATURE_AVX)) {
+		pr_info("AVX instructions are not detected.\n");
 		return -ENODEV;
 	}
 
 	return crypto_register_skciphers(twofish_algs,
 					 ARRAY_SIZE(twofish_algs));
-- 
2.54.0

