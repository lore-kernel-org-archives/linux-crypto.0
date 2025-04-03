Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36BE324888A;
	Thu,  3 Apr 2025 09:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743673590; cv=none; b=nzQaNQGP3LpMBd8Jz7sXahLo3Nz3q/cggX27iq1WTfCP0dgzPa8w4TL3g0H0EM41jzAy9ANhI4L0QUr6Tuu0OL4NJDggfTsmyo+UsphMUOyVWrt0AmCI4WOOWM6mxlxM9+0OdpRkmimxlw8HWI06xfb+Qx6mqXEC0TV2YZnOC84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743673590; c=relaxed/simple;
	bh=5bbNInfdg1MM9aCGjoJrXC4MC52Lbn+PgMUqZrJR4W0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pjteVd8S1ggW9HTVY6rAcsvL/9TZDostvs+FD6Zd18QqCdCAmI+GovOuKDmKmJuK9+NqR36/7lWcdbZr2MarhOqkGMASBXlibJjeXJcl5SbPvhbWQI3+PbFpQYsCrBP8eIAWrKuIbW1GMTL8sZSMEumGy/LWsQUDdl3pznSsDSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dtggxHie; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dtggxHie"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-ac2963dc379so105171266b.2;
        Thu, 03 Apr 2025 02:46:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743673586; x=1744278386; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q/C6osgplP09dBNHrhrCsYgH8G4RsK7vOT52ylr7TnE=;
        b=dtggxHie46X6y6Mk49l0TblnFJvI81cDlL1gPT5hl9wwRRy/sO7cum3UIRJV1kp0Zo
         affxg8vuoT5EY5Gr+Wm32HyZ8PMXTJmjek37VwkdeE2OfWKkWLULjFNGkcFqRDfHBVrz
         orRkWCKh/ihAOp7Jsu1RhjcdSUl3IXGhmkH7npDLWBf8t8P5HepyqdBPWXOAr3g2+Aq9
         iIejIDNJs2g1A1ex49457c7p6KPVLJJD0p7Wu80/PrHzsrsglZrs4qP/LE6XAL2DD2eQ
         b9BLIRd1UPRBrN4oHVXSo8d/7DQx7Hdio9zTdgB7tokZ/r2nNisIMOpjy0RWrBMHMa2a
         3ukA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743673586; x=1744278386;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q/C6osgplP09dBNHrhrCsYgH8G4RsK7vOT52ylr7TnE=;
        b=gyOaOOG/YKUvoW9+DpnUyBjHOoxQUIgxhyj1u1xymO+4JgwGd2+ZaHf3nGtOLKyGG0
         DzNY8uUeYV0LjY4rdM4Jc2AEn1SLdPO2b1UlSu20ue7k9n+EwEcs6XM5fLryJnoiAqEt
         M9Fvl5miFXyPMHXrBT5OoIxbuYMnjYl3M+KJcLtD/P6gBZCszuVf0O+OVeihVugypceZ
         ji9hkf1edK/XM4o8cvUZo1H1mpnIVA5lb5SOcypKNhyhK4rx0dJIPmAhJWDYcv1e7qIH
         EBRZjdlXKBO9Rnac9AjYohGOKHGCWMlPNl/KQY9jitDsJF1ZBK/DVmzVJebcgOh/K743
         89kw==
X-Forwarded-Encrypted: i=1; AJvYcCUP0xjGK8ss4D8iIY/B5V7rRwaSjGkD7danx5+NucEDNuJYtZuwUNxH5tKtjP3p+NZLWWRpqzn6sAP2oTg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzBLaFx3kTp6XE00dFqjixu6Lks8MUe4ayG0+01/hXHNWsRr8eA
	6fr2SYVnMbBY1rQNbuppebiTAYydGBi9aPr/c5ueFcdoDVp9VndruO2Toqis
X-Gm-Gg: ASbGnct4nZNgsf9Uzts2bHIqJi392KueMw0KzxXsM3M1IGFCFeVBBGR8Pucwd3ZtSUn
	CmMwJrtptLcVUT13NsO0IVTInzpQ/UmwNaqZhAqTURMEFEJ3LgojAACAe07pcNZryi/bXZKYa+s
	am6nc34/RO7vW3aTkPWOt4stAKLYXkZxx7yLlRP/8yXsU09JYy/fen969uORDOMRy19Kw2sG2Zm
	00vI0fxay1Yc29VHsobAxH/89U1dHRdBxokMErMqQDh5OMP2gJt9qwS9W6N/23X4KAEAP9i5lCw
	3ENxzrs7DWwZCokE6QU3Rx2GTUNzBEQj677Y
X-Google-Smtp-Source: AGHT+IFDzC/ez175rRP6bX2I4QWOsdrfcuAZIM3wm18RK/dbJjn7dMPSnNn1q+2i9DbyX3xJE6XQ7Q==
X-Received: by 2002:a17:907:940b:b0:ac3:8aa5:53f6 with SMTP id a640c23a62f3a-ac7bc0b0a99mr164295266b.24.1743673585785;
        Thu, 03 Apr 2025 02:46:25 -0700 (PDT)
Received: from fedora.. ([193.77.86.199])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac7bfeed008sm65054666b.85.2025.04.03.02.46.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Apr 2025 02:46:24 -0700 (PDT)
From: Uros Bizjak <ubizjak@gmail.com>
To: linux-crypto@vger.kernel.org,
	x86@kernel.org,
	linux-kernel@vger.kernel.org
Cc: Uros Bizjak <ubizjak@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 3/3] crypto: x86 - Remove CONFIG_AS_AVX512
Date: Thu,  3 Apr 2025 11:44:41 +0200
Message-ID: <20250403094527.349526-3-ubizjak@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250403094527.349526-1-ubizjak@gmail.com>
References: <20250403094527.349526-1-ubizjak@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Current minimum required version of binutils is 2.25,
which supports AVX-512 instruction mnemonics.

Remove check for assembler support of AVX-512 instructions
and all relevant macros for conditional compilation.

No functional change intended.

Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/Kconfig.assembler                    | 5 -----
 arch/x86/crypto/Kconfig                       | 2 +-
 arch/x86/crypto/Makefile                      | 3 +--
 arch/x86/crypto/blake2s-core.S                | 4 ----
 arch/x86/crypto/blake2s-glue.c                | 6 ++----
 arch/x86/crypto/chacha_glue.c                 | 6 ++----
 arch/x86/crypto/poly1305-x86_64-cryptogams.pl | 8 --------
 arch/x86/crypto/poly1305_glue.c               | 6 +++---
 8 files changed, 9 insertions(+), 31 deletions(-)

diff --git a/arch/x86/Kconfig.assembler b/arch/x86/Kconfig.assembler
index 4d06fd3c8dfe..d149a0ee371a 100644
--- a/arch/x86/Kconfig.assembler
+++ b/arch/x86/Kconfig.assembler
@@ -1,11 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 # Copyright (C) 2020 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
 
-config AS_AVX512
-	def_bool $(as-instr,vpmovm2b %k1$(comma)%zmm5)
-	help
-	  Supported by binutils >= 2.25 and LLVM integrated assembler
-
 config AS_TPAUSE
 	def_bool $(as-instr,tpause %ecx)
 	help
diff --git a/arch/x86/crypto/Kconfig b/arch/x86/crypto/Kconfig
index 3d948f10c94c..547bb0db9217 100644
--- a/arch/x86/crypto/Kconfig
+++ b/arch/x86/crypto/Kconfig
@@ -332,7 +332,7 @@ config CRYPTO_ARIA_AESNI_AVX2_X86_64
 
 config CRYPTO_ARIA_GFNI_AVX512_X86_64
 	tristate "Ciphers: ARIA with modes: ECB, CTR (AVX512/GFNI)"
-	depends on X86 && 64BIT && AS_AVX512 && AS_GFNI
+	depends on X86 && 64BIT && AS_GFNI
 	select CRYPTO_SKCIPHER
 	select CRYPTO_SIMD
 	select CRYPTO_ALGAPI
diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index e06b739176c9..2f22b381f244 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -43,8 +43,7 @@ obj-$(CONFIG_CRYPTO_AEGIS128_AESNI_SSE2) += aegis128-aesni.o
 aegis128-aesni-y := aegis128-aesni-asm.o aegis128-aesni-glue.o
 
 obj-$(CONFIG_CRYPTO_CHACHA20_X86_64) += chacha-x86_64.o
-chacha-x86_64-y := chacha-avx2-x86_64.o chacha-ssse3-x86_64.o chacha_glue.o
-chacha-x86_64-$(CONFIG_AS_AVX512) += chacha-avx512vl-x86_64.o
+chacha-x86_64-y := chacha-avx2-x86_64.o chacha-ssse3-x86_64.o chacha-avx512vl-x86_64.o chacha_glue.o
 
 obj-$(CONFIG_CRYPTO_AES_NI_INTEL) += aesni-intel.o
 aesni-intel-y := aesni-intel_asm.o aesni-intel_glue.o
diff --git a/arch/x86/crypto/blake2s-core.S b/arch/x86/crypto/blake2s-core.S
index b50b35ff1fdb..ac1c845445a4 100644
--- a/arch/x86/crypto/blake2s-core.S
+++ b/arch/x86/crypto/blake2s-core.S
@@ -29,7 +29,6 @@ SIGMA:
 .byte 13,  7, 12,  3, 11, 14,  1,  9,  2,  5, 15,  8, 10,  0,  4,  6
 .byte  6, 14, 11,  0, 15,  9,  3,  8, 10, 12, 13,  1,  5,  2,  7,  4
 .byte 10,  8,  7,  1,  2,  4,  6,  5, 13, 15,  9,  3,  0, 11, 14, 12
-#ifdef CONFIG_AS_AVX512
 .section .rodata.cst64.BLAKE2S_SIGMA2, "aM", @progbits, 640
 .align 64
 SIGMA2:
@@ -43,7 +42,6 @@ SIGMA2:
 .long  6, 13,  0, 14, 12,  2,  1, 11, 15,  4,  5,  8,  7,  9,  3, 10
 .long 15,  5,  4, 13, 10,  7,  3, 11, 12,  2,  0,  6,  9,  8,  1, 14
 .long  8,  7, 14, 11, 13, 15,  0, 12, 10,  4,  5,  6,  3,  2,  1,  9
-#endif /* CONFIG_AS_AVX512 */
 
 .text
 SYM_FUNC_START(blake2s_compress_ssse3)
@@ -174,7 +172,6 @@ SYM_FUNC_START(blake2s_compress_ssse3)
 	RET
 SYM_FUNC_END(blake2s_compress_ssse3)
 
-#ifdef CONFIG_AS_AVX512
 SYM_FUNC_START(blake2s_compress_avx512)
 	vmovdqu		(%rdi),%xmm0
 	vmovdqu		0x10(%rdi),%xmm1
@@ -253,4 +250,3 @@ SYM_FUNC_START(blake2s_compress_avx512)
 	vzeroupper
 	RET
 SYM_FUNC_END(blake2s_compress_avx512)
-#endif /* CONFIG_AS_AVX512 */
diff --git a/arch/x86/crypto/blake2s-glue.c b/arch/x86/crypto/blake2s-glue.c
index 0313f9673f56..00f84f29cc8c 100644
--- a/arch/x86/crypto/blake2s-glue.c
+++ b/arch/x86/crypto/blake2s-glue.c
@@ -41,8 +41,7 @@ void blake2s_compress(struct blake2s_state *state, const u8 *block,
 					    SZ_4K / BLAKE2S_BLOCK_SIZE);
 
 		kernel_fpu_begin();
-		if (IS_ENABLED(CONFIG_AS_AVX512) &&
-		    static_branch_likely(&blake2s_use_avx512))
+		if (static_branch_likely(&blake2s_use_avx512))
 			blake2s_compress_avx512(state, block, blocks, inc);
 		else
 			blake2s_compress_ssse3(state, block, blocks, inc);
@@ -59,8 +58,7 @@ static int __init blake2s_mod_init(void)
 	if (boot_cpu_has(X86_FEATURE_SSSE3))
 		static_branch_enable(&blake2s_use_ssse3);
 
-	if (IS_ENABLED(CONFIG_AS_AVX512) &&
-	    boot_cpu_has(X86_FEATURE_AVX) &&
+	if (boot_cpu_has(X86_FEATURE_AVX) &&
 	    boot_cpu_has(X86_FEATURE_AVX2) &&
 	    boot_cpu_has(X86_FEATURE_AVX512F) &&
 	    boot_cpu_has(X86_FEATURE_AVX512VL) &&
diff --git a/arch/x86/crypto/chacha_glue.c b/arch/x86/crypto/chacha_glue.c
index 8bb74a272879..ce12ad807af1 100644
--- a/arch/x86/crypto/chacha_glue.c
+++ b/arch/x86/crypto/chacha_glue.c
@@ -48,8 +48,7 @@ static unsigned int chacha_advance(unsigned int len, unsigned int maxblocks)
 static void chacha_dosimd(u32 *state, u8 *dst, const u8 *src,
 			  unsigned int bytes, int nrounds)
 {
-	if (IS_ENABLED(CONFIG_AS_AVX512) &&
-	    static_branch_likely(&chacha_use_avx512vl)) {
+	if (static_branch_likely(&chacha_use_avx512vl)) {
 		while (bytes >= CHACHA_BLOCK_SIZE * 8) {
 			chacha_8block_xor_avx512vl(state, dst, src, bytes,
 						   nrounds);
@@ -282,8 +281,7 @@ static int __init chacha_simd_mod_init(void)
 	    cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM, NULL)) {
 		static_branch_enable(&chacha_use_avx2);
 
-		if (IS_ENABLED(CONFIG_AS_AVX512) &&
-		    boot_cpu_has(X86_FEATURE_AVX512VL) &&
+		if (boot_cpu_has(X86_FEATURE_AVX512VL) &&
 		    boot_cpu_has(X86_FEATURE_AVX512BW)) /* kmovq */
 			static_branch_enable(&chacha_use_avx512vl);
 	}
diff --git a/arch/x86/crypto/poly1305-x86_64-cryptogams.pl b/arch/x86/crypto/poly1305-x86_64-cryptogams.pl
index b9abcd79c1f4..409ec6955733 100644
--- a/arch/x86/crypto/poly1305-x86_64-cryptogams.pl
+++ b/arch/x86/crypto/poly1305-x86_64-cryptogams.pl
@@ -2811,18 +2811,10 @@ if ($avx>2) {
 # reason stack layout is kept identical to poly1305_blocks_avx2. If not
 # for this tail, we wouldn't have to even allocate stack frame...
 
-if($kernel) {
-	$code .= "#ifdef CONFIG_AS_AVX512\n";
-}
-
 &declare_function("poly1305_blocks_avx512", 32, 4);
 poly1305_blocks_avxN(1);
 &end_function("poly1305_blocks_avx512");
 
-if ($kernel) {
-	$code .= "#endif\n";
-}
-
 if (!$kernel && $avx>3) {
 ########################################################################
 # VPMADD52 version using 2^44 radix.
diff --git a/arch/x86/crypto/poly1305_glue.c b/arch/x86/crypto/poly1305_glue.c
index 08ff4b489f7e..8b5593c46da7 100644
--- a/arch/x86/crypto/poly1305_glue.c
+++ b/arch/x86/crypto/poly1305_glue.c
@@ -107,7 +107,7 @@ static void poly1305_simd_blocks(void *ctx, const u8 *inp, size_t len,
 		const size_t bytes = min_t(size_t, len, SZ_4K);
 
 		kernel_fpu_begin();
-		if (IS_ENABLED(CONFIG_AS_AVX512) && static_branch_likely(&poly1305_use_avx512))
+		if (static_branch_likely(&poly1305_use_avx512))
 			poly1305_blocks_avx512(ctx, inp, bytes, padbit);
 		else if (static_branch_likely(&poly1305_use_avx2))
 			poly1305_blocks_avx2(ctx, inp, bytes, padbit);
@@ -265,8 +265,8 @@ static int __init poly1305_simd_mod_init(void)
 	if (boot_cpu_has(X86_FEATURE_AVX) && boot_cpu_has(X86_FEATURE_AVX2) &&
 	    cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM, NULL))
 		static_branch_enable(&poly1305_use_avx2);
-	if (IS_ENABLED(CONFIG_AS_AVX512) && boot_cpu_has(X86_FEATURE_AVX) &&
-	    boot_cpu_has(X86_FEATURE_AVX2) && boot_cpu_has(X86_FEATURE_AVX512F) &&
+	if (boot_cpu_has(X86_FEATURE_AVX) && boot_cpu_has(X86_FEATURE_AVX2) &&
+	    boot_cpu_has(X86_FEATURE_AVX512F) &&
 	    cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM | XFEATURE_MASK_AVX512, NULL) &&
 	    /* Skylake downclocks unacceptably much when using zmm, but later generations are fast. */
 	    boot_cpu_data.x86_vfm != INTEL_SKYLAKE_X)
-- 
2.49.0

