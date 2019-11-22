Return-Path: <SRS0=W3IF=ZO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38807C432C0
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Nov 2019 09:46:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE6852070E
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Nov 2019 09:46:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="SslhPqXF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbfKVJqk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Nov 2019 04:46:40 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:38441 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726767AbfKVJqj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Nov 2019 04:46:39 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 34bfece9;
        Fri, 22 Nov 2019 08:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=A6j0paaQTTGqArOIJ3Pe8B0Rg
        lA=; b=SslhPqXFI99hJfXYu0MQr/ESy9X5kiKv3IOcoeVKNaDd3NGl2as4R9I/W
        4IAHchgg1sMeoOCbnkHI/n3cKqho4ejcduJMcH/a8lKfBp5vX2zsZdyfuv3Y/Pka
        KS1GoYgdHKOtJpzBMU6IUX4AbR+EUsXpfWt0otQ9nevBaYiYj3Kt4tCKtnVXnSej
        Zt2bNR7fXThfWrV/Cxn+gZRc/LvpQGfD/RWla2Jeqi59DKrcrRnQ7sSQYDcldFyG
        c/1Zh+HPCZuuMWGVKnDsvOjqSXSBtJr6RDtY85nu9B5FhkygWiSjaQogPvz5gY62
        Ptsc+iuBq5+Oi1Ugh2XDOohmXF1Pw==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id de93179f (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Fri, 22 Nov 2019 08:53:26 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linux-crypto@vger.kernel.org, ardb@kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH v3] crypto: conditionalize crypto api in arch glue for lib code
Date:   Fri, 22 Nov 2019 10:46:35 +0100
Message-Id: <20191122094635.172168-1-Jason@zx2c4.com>
In-Reply-To: <20191122094156.169526-1-Jason@zx2c4.com>
References: <20191122094156.169526-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

For glue code that's used by Zinc, the actual Crypto API functions might
not necessarily exist, and don't need to exist either. Before this
patch, there are valid build configurations that lead to a unbuildable
kernel. This fixes it to conditionalize those symbols on the existence
of the proper config entry.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
Changes v2->v3:
  - v2 was a dud, with a find and replace operation gone wild. v3 is
    what v2 should have been.
Changes v1->v2:
  - Discussing with Ard on IRC, we concluded that IS_REACHABLE makes
    more sense than IS_ENABLED.

 arch/arm/crypto/chacha-glue.c        | 26 ++++++++++++++++----------
 arch/arm/crypto/curve25519-glue.c    |  5 +++--
 arch/arm/crypto/poly1305-glue.c      |  9 ++++++---
 arch/arm64/crypto/chacha-neon-glue.c |  5 +++--
 arch/arm64/crypto/poly1305-glue.c    |  5 +++--
 arch/mips/crypto/chacha-glue.c       |  6 ++++--
 arch/mips/crypto/poly1305-glue.c     |  6 ++++--
 arch/x86/crypto/blake2s-glue.c       |  6 ++++--
 arch/x86/crypto/chacha_glue.c        |  6 ++++--
 arch/x86/crypto/curve25519-x86_64.c  |  7 ++++---
 arch/x86/crypto/poly1305_glue.c      |  5 +++--
 11 files changed, 54 insertions(+), 32 deletions(-)

diff --git a/arch/arm/crypto/chacha-glue.c b/arch/arm/crypto/chacha-glue.c
index 3f0c057aa050..6ebbb2b241d2 100644
--- a/arch/arm/crypto/chacha-glue.c
+++ b/arch/arm/crypto/chacha-glue.c
@@ -286,11 +286,13 @@ static struct skcipher_alg neon_algs[] = {
 
 static int __init chacha_simd_mod_init(void)
 {
-	int err;
+	int err = 0;
 
-	err = crypto_register_skciphers(arm_algs, ARRAY_SIZE(arm_algs));
-	if (err)
-		return err;
+	if (IS_REACHABLE(CONFIG_CRYPTO_SKCIPHER)) {
+		err = crypto_register_skciphers(arm_algs, ARRAY_SIZE(arm_algs));
+		if (err)
+			return err;
+	}
 
 	if (IS_ENABLED(CONFIG_KERNEL_MODE_NEON) && (elf_hwcap & HWCAP_NEON)) {
 		int i;
@@ -310,18 +312,22 @@ static int __init chacha_simd_mod_init(void)
 			static_branch_enable(&use_neon);
 		}
 
-		err = crypto_register_skciphers(neon_algs, ARRAY_SIZE(neon_algs));
-		if (err)
-			crypto_unregister_skciphers(arm_algs, ARRAY_SIZE(arm_algs));
+		if (IS_REACHABLE(CONFIG_CRYPTO_SKCIPHER)) {
+			err = crypto_register_skciphers(neon_algs, ARRAY_SIZE(neon_algs));
+			if (err)
+				crypto_unregister_skciphers(arm_algs, ARRAY_SIZE(arm_algs));
+		}
 	}
 	return err;
 }
 
 static void __exit chacha_simd_mod_fini(void)
 {
-	crypto_unregister_skciphers(arm_algs, ARRAY_SIZE(arm_algs));
-	if (IS_ENABLED(CONFIG_KERNEL_MODE_NEON) && (elf_hwcap & HWCAP_NEON))
-		crypto_unregister_skciphers(neon_algs, ARRAY_SIZE(neon_algs));
+	if (IS_REACHABLE(CONFIG_CRYPTO_SKCIPHER)) {
+		crypto_unregister_skciphers(arm_algs, ARRAY_SIZE(arm_algs));
+		if (IS_ENABLED(CONFIG_KERNEL_MODE_NEON) && (elf_hwcap & HWCAP_NEON))
+			crypto_unregister_skciphers(neon_algs, ARRAY_SIZE(neon_algs));
+	}
 }
 
 module_init(chacha_simd_mod_init);
diff --git a/arch/arm/crypto/curve25519-glue.c b/arch/arm/crypto/curve25519-glue.c
index 2e9e12d2f642..f3f42cf3b893 100644
--- a/arch/arm/crypto/curve25519-glue.c
+++ b/arch/arm/crypto/curve25519-glue.c
@@ -108,14 +108,15 @@ static int __init mod_init(void)
 {
 	if (elf_hwcap & HWCAP_NEON) {
 		static_branch_enable(&have_neon);
-		return crypto_register_kpp(&curve25519_alg);
+		return IS_REACHABLE(CONFIG_CRYPTO_KPP) ?
+			crypto_register_kpp(&curve25519_alg) : 0;
 	}
 	return 0;
 }
 
 static void __exit mod_exit(void)
 {
-	if (elf_hwcap & HWCAP_NEON)
+	if (IS_REACHABLE(CONFIG_CRYPTO_KPP) && elf_hwcap & HWCAP_NEON)
 		crypto_unregister_kpp(&curve25519_alg);
 }
 
diff --git a/arch/arm/crypto/poly1305-glue.c b/arch/arm/crypto/poly1305-glue.c
index 74a725ac89c9..abe3f2d587dc 100644
--- a/arch/arm/crypto/poly1305-glue.c
+++ b/arch/arm/crypto/poly1305-glue.c
@@ -249,16 +249,19 @@ static int __init arm_poly1305_mod_init(void)
 	if (IS_ENABLED(CONFIG_KERNEL_MODE_NEON) &&
 	    (elf_hwcap & HWCAP_NEON))
 		static_branch_enable(&have_neon);
-	else
+	else if (IS_REACHABLE(CONFIG_CRYPTO_HASH))
 		/* register only the first entry */
 		return crypto_register_shash(&arm_poly1305_algs[0]);
 
-	return crypto_register_shashes(arm_poly1305_algs,
-				       ARRAY_SIZE(arm_poly1305_algs));
+	return IS_REACHABLE(CONFIG_CRYPTO_HASH) ?
+		crypto_register_shashes(arm_poly1305_algs,
+					ARRAY_SIZE(arm_poly1305_algs)) : 0;
 }
 
 static void __exit arm_poly1305_mod_exit(void)
 {
+	if (!IS_REACHABLE(CONFIG_CRYPTO_HASH))
+		return;
 	if (!static_branch_likely(&have_neon)) {
 		crypto_unregister_shash(&arm_poly1305_algs[0]);
 		return;
diff --git a/arch/arm64/crypto/chacha-neon-glue.c b/arch/arm64/crypto/chacha-neon-glue.c
index b08029d7bde6..c1f9660d104c 100644
--- a/arch/arm64/crypto/chacha-neon-glue.c
+++ b/arch/arm64/crypto/chacha-neon-glue.c
@@ -211,12 +211,13 @@ static int __init chacha_simd_mod_init(void)
 
 	static_branch_enable(&have_neon);
 
-	return crypto_register_skciphers(algs, ARRAY_SIZE(algs));
+	return IS_REACHABLE(CONFIG_CRYPTO_SKCIPHER) ?
+		crypto_register_skciphers(algs, ARRAY_SIZE(algs)) : 0;
 }
 
 static void __exit chacha_simd_mod_fini(void)
 {
-	if (cpu_have_named_feature(ASIMD))
+	if (IS_REACHABLE(CONFIG_CRYPTO_SKCIPHER) && cpu_have_named_feature(ASIMD))
 		crypto_unregister_skciphers(algs, ARRAY_SIZE(algs));
 }
 
diff --git a/arch/arm64/crypto/poly1305-glue.c b/arch/arm64/crypto/poly1305-glue.c
index dd843d0ee83a..83a2338a8826 100644
--- a/arch/arm64/crypto/poly1305-glue.c
+++ b/arch/arm64/crypto/poly1305-glue.c
@@ -220,12 +220,13 @@ static int __init neon_poly1305_mod_init(void)
 
 	static_branch_enable(&have_neon);
 
-	return crypto_register_shash(&neon_poly1305_alg);
+	return IS_REACHABLE(CONFIG_CRYPTO_HASH) ?
+		crypto_register_shash(&neon_poly1305_alg) : 0;
 }
 
 static void __exit neon_poly1305_mod_exit(void)
 {
-	if (cpu_have_named_feature(ASIMD))
+	if (IS_REACHABLE(CONFIG_CRYPTO_HASH) && cpu_have_named_feature(ASIMD))
 		crypto_unregister_shash(&neon_poly1305_alg);
 }
 
diff --git a/arch/mips/crypto/chacha-glue.c b/arch/mips/crypto/chacha-glue.c
index 779e399c9bef..d1fd23e6ef84 100644
--- a/arch/mips/crypto/chacha-glue.c
+++ b/arch/mips/crypto/chacha-glue.c
@@ -128,12 +128,14 @@ static struct skcipher_alg algs[] = {
 
 static int __init chacha_simd_mod_init(void)
 {
-	return crypto_register_skciphers(algs, ARRAY_SIZE(algs));
+	return IS_REACHABLE(CONFIG_CRYPTO_SKCIPHER) ?
+		crypto_register_skciphers(algs, ARRAY_SIZE(algs)) : 0;
 }
 
 static void __exit chacha_simd_mod_fini(void)
 {
-	crypto_unregister_skciphers(algs, ARRAY_SIZE(algs));
+	if (IS_REACHABLE(CONFIG_CRYPTO_SKCIPHER))
+		crypto_unregister_skciphers(algs, ARRAY_SIZE(algs));
 }
 
 module_init(chacha_simd_mod_init);
diff --git a/arch/mips/crypto/poly1305-glue.c b/arch/mips/crypto/poly1305-glue.c
index b759b6ccc361..b37d29cf5d0a 100644
--- a/arch/mips/crypto/poly1305-glue.c
+++ b/arch/mips/crypto/poly1305-glue.c
@@ -187,12 +187,14 @@ static struct shash_alg mips_poly1305_alg = {
 
 static int __init mips_poly1305_mod_init(void)
 {
-	return crypto_register_shash(&mips_poly1305_alg);
+	return IS_REACHABLE(CONFIG_CRYPTO_HASH) ?
+		crypto_register_shash(&mips_poly1305_alg) : 0;
 }
 
 static void __exit mips_poly1305_mod_exit(void)
 {
-	crypto_unregister_shash(&mips_poly1305_alg);
+	if (IS_REACHABLE(CONFIG_CRYPTO_HASH))
+		crypto_unregister_shash(&mips_poly1305_alg);
 }
 
 module_init(mips_poly1305_mod_init);
diff --git a/arch/x86/crypto/blake2s-glue.c b/arch/x86/crypto/blake2s-glue.c
index 4a37ba7cdbe5..1d9ff8a45e1f 100644
--- a/arch/x86/crypto/blake2s-glue.c
+++ b/arch/x86/crypto/blake2s-glue.c
@@ -210,12 +210,14 @@ static int __init blake2s_mod_init(void)
 			      XFEATURE_MASK_AVX512, NULL))
 		static_branch_enable(&blake2s_use_avx512);
 
-	return crypto_register_shashes(blake2s_algs, ARRAY_SIZE(blake2s_algs));
+	return IS_REACHABLE(CONFIG_CRYPTO_HASH) ?
+		crypto_register_shashes(blake2s_algs,
+					ARRAY_SIZE(blake2s_algs)) : 0;
 }
 
 static void __exit blake2s_mod_exit(void)
 {
-	if (boot_cpu_has(X86_FEATURE_SSSE3))
+	if (IS_REACHABLE(CONFIG_CRYPTO_HASH) && boot_cpu_has(X86_FEATURE_SSSE3))
 		crypto_unregister_shashes(blake2s_algs, ARRAY_SIZE(blake2s_algs));
 }
 
diff --git a/arch/x86/crypto/chacha_glue.c b/arch/x86/crypto/chacha_glue.c
index b391e13a9e41..ce67bc8a9f4e 100644
--- a/arch/x86/crypto/chacha_glue.c
+++ b/arch/x86/crypto/chacha_glue.c
@@ -299,12 +299,14 @@ static int __init chacha_simd_mod_init(void)
 		    boot_cpu_has(X86_FEATURE_AVX512BW)) /* kmovq */
 			static_branch_enable(&chacha_use_avx512vl);
 	}
-	return crypto_register_skciphers(algs, ARRAY_SIZE(algs));
+	return IS_REACHABLE(CONFIG_CRYPTO_SKCIPHER) ?
+		crypto_register_skciphers(algs, ARRAY_SIZE(algs)) : 0;
 }
 
 static void __exit chacha_simd_mod_fini(void)
 {
-	crypto_unregister_skciphers(algs, ARRAY_SIZE(algs));
+	if (IS_REACHABLE(CONFIG_CRYPTO_SKCIPHER))
+		crypto_unregister_skciphers(algs, ARRAY_SIZE(algs));
 }
 
 module_init(chacha_simd_mod_init);
diff --git a/arch/x86/crypto/curve25519-x86_64.c b/arch/x86/crypto/curve25519-x86_64.c
index a52a3fb15727..eec7d2d24239 100644
--- a/arch/x86/crypto/curve25519-x86_64.c
+++ b/arch/x86/crypto/curve25519-x86_64.c
@@ -2457,13 +2457,14 @@ static int __init curve25519_mod_init(void)
 		static_branch_enable(&curve25519_use_adx);
 	else
 		return 0;
-	return crypto_register_kpp(&curve25519_alg);
+	return IS_REACHABLE(CONFIG_CRYPTO_KPP) ?
+		crypto_register_kpp(&curve25519_alg) : 0;
 }
 
 static void __exit curve25519_mod_exit(void)
 {
-	if (boot_cpu_has(X86_FEATURE_BMI2) ||
-	    boot_cpu_has(X86_FEATURE_ADX))
+	if (IS_REACHABLE(CONFIG_CRYPTO_KPP) &&
+	    (boot_cpu_has(X86_FEATURE_BMI2) || boot_cpu_has(X86_FEATURE_ADX)))
 		crypto_unregister_kpp(&curve25519_alg);
 }
 
diff --git a/arch/x86/crypto/poly1305_glue.c b/arch/x86/crypto/poly1305_glue.c
index 370cd88068ec..0cc4537e6617 100644
--- a/arch/x86/crypto/poly1305_glue.c
+++ b/arch/x86/crypto/poly1305_glue.c
@@ -224,12 +224,13 @@ static int __init poly1305_simd_mod_init(void)
 	    cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM, NULL))
 		static_branch_enable(&poly1305_use_avx2);
 
-	return crypto_register_shash(&alg);
+	return IS_REACHABLE(CONFIG_CRYPTO_HASH) ? crypto_register_shash(&alg) : 0;
 }
 
 static void __exit poly1305_simd_mod_exit(void)
 {
-	crypto_unregister_shash(&alg);
+	if (IS_REACHABLE(CONFIG_CRYPTO_HASH))
+		crypto_unregister_shash(&alg);
 }
 
 module_init(poly1305_simd_mod_init);
-- 
2.24.0

