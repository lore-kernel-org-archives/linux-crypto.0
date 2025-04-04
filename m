Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB25318FDD5;
	Fri,  4 Apr 2025 07:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743752507; cv=none; b=aJ0QwDDzC0SIEEYm/yBeah8FVWsJ5yoldJ7tnpy9gqaF/AiEH/YwvfvvO4oEr8W7z++h6+hKntUwZ/Q61PC2GlIFGEnb2gPGjMbxKM3c5bdam/2ji3gkqihcGeyZd5lkn9v2xjQJ9EVkBbl2rk75kvT4jM0Aw4isYCET0IjMMh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743752507; c=relaxed/simple;
	bh=jvt1JioOXT3ZaMG/51uHfdhrC7m62/NHzvooV5WTvF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fNF9flKXMOSlf8Et9/wQmuVsk6nz9hcBLhv+OxnjfTVdPeuJuEAbbj6CjDZGwOCUCm0ZL2CBmCHyKmbwt2wIGqWoIfaYHUMScACNdIrbtnczDSbWrqIIl3qbGKIPqc6B5Hiza1bbHtPcxlb5UL1qy+0qDHhjaGMJYB1WcBUCyOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=enHHkfE4; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="enHHkfE4"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-ac7bd86f637so274904666b.1;
        Fri, 04 Apr 2025 00:41:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743752503; x=1744357303; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wwLokimafnR8j2x9NWOgXXCaOdUwwsv3luK9m0abkH4=;
        b=enHHkfE4qQeCCQrs8k8zexhV5D98jDQtgIbWkdHF+b8jkLYdzI/vo5l0jVBEGLlpYO
         AYqLO732LtsKZXALUh/Ge/2pPSMGMZVpcpirIlDCbravOuYmJS8CafqkmDO5oWCrgWSb
         gs6tqi9BDRZ4nhMCU/sFbeHZdKEYPPtjznnLswJgHsY7VowXzRVNOVlw0nwvMHMJjUNe
         JB43Y60jIStb5Rlzy2ZQXcAnq/gUOzsQcVFaqRR7cI6g+H0U/MpAAdqMEecAclxqM0Ta
         Bv0Jnkgk7/v7L/SO6FFDIT7O7ArfbUda5bCa99gi7zdOeDnvFF6qftS86X9HxRWp/I7L
         6jpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743752503; x=1744357303;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wwLokimafnR8j2x9NWOgXXCaOdUwwsv3luK9m0abkH4=;
        b=kJdqyyQ5IDmKYjXRZ+lYsIV1ozsR2Fq5jEcua58eg9jIWVCETrP1oEwJZmmaa5PEfs
         OavPIDNxUid9FkdIqBWRvaNf0NMPnA0mYduW/3Z1D5QjkTLCl7NfDYljRH8eE+xZnvDp
         q5WaWMi6AaanGFWBhAlhNQ4uNwE0+FjyD7kIiAkLU0d0xfMW7oKX+95y4Y6ANzCj65BL
         UIoKs9VaA1Ym0b6+jE0FIpQWrqoY+nAvQW3zSTWUQBZfMNJtYjamX24G6IJ6zM+zSoqr
         hC2sxLCMBqWS7NAsNbS13JjOh7bQAqgPWzHk3WrlE4qSmTzWMnpqRdBJe/yMry4opHvp
         n5tg==
X-Forwarded-Encrypted: i=1; AJvYcCXZLZRQEdTsQFv8j7aNLP+DpF9R5zdXi9LtsB7MUJiHMXIBHtpXBEHp2Hoxl7AEK2nyaCZsyGQRAqHVVpg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwBkYFrcQQlZwQ3M6sexL6+fTQkFWC0l4gVSehzHZIBkyOOIwN1
	8zkJyGSzjKid5Yke1PqQ3r7+cgU9vkxi1b5rAVH5byAxLQ1WXfvIU3l+KFjv
X-Gm-Gg: ASbGncsM2Hw0XILJo/5USdJHC8jzq+hWnFewQucXkCXf6NEFnvmfQ2cVSSQ15Zylfs8
	ve/6v5ulesWRxBRzskjsu/WDJkyVeHhWE+RyW+Q8iVnUQkv7bZBI2diRtTazzpDRc4DrER4Fvn9
	D6uJAsi4ZXc9EY7tNNmoZefFcLp1b9y3637wB0Sy06VwFXfdLHylcKcc6mvUxI9faL3od6z4f3F
	7jLD8iD+RlD0tA/kXimzJaN4Q9t7S5akGM5O0Lgd3SQfdpA8giGotlpprYYZ9TLOTq5MrHJ9kMe
	CANigimB1cU4mFuFL/uxl0oH0kHYQoKhiMNd
X-Google-Smtp-Source: AGHT+IGLKpqhQVOZd3X7rVbFi1VLjL/rDAAxh6TKYfjC6lZURG0M49KTwhvOwM0PA3RY5GlhIVZyqw==
X-Received: by 2002:a17:907:6d0a:b0:ac7:81b0:62c9 with SMTP id a640c23a62f3a-ac7d2fb9b5fmr166849966b.20.1743752502970;
        Fri, 04 Apr 2025 00:41:42 -0700 (PDT)
Received: from fedora.. ([193.77.86.199])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac7bfe9aa4esm211739266b.54.2025.04.04.00.41.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Apr 2025 00:41:41 -0700 (PDT)
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
	"H. Peter Anvin" <hpa@zytor.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 3/3] crypto: x86 - Remove CONFIG_AS_AVX512 handling
Date: Fri,  4 Apr 2025 09:41:02 +0200
Message-ID: <20250404074135.520812-3-ubizjak@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250404074135.520812-1-ubizjak@gmail.com>
References: <20250404074135.520812-1-ubizjak@gmail.com>
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
Reviewed-by: Eric Biggers <ebiggers@kernel.org>
---
v2: Do not remove AS_AVX512 from arch/x86/Kconfig.assembler.
---
 arch/x86/crypto/Kconfig                       | 2 +-
 arch/x86/crypto/Makefile                      | 3 +--
 arch/x86/crypto/blake2s-core.S                | 4 ----
 arch/x86/crypto/blake2s-glue.c                | 6 ++----
 arch/x86/crypto/chacha_glue.c                 | 6 ++----
 arch/x86/crypto/poly1305-x86_64-cryptogams.pl | 8 --------
 arch/x86/crypto/poly1305_glue.c               | 6 +++---
 7 files changed, 9 insertions(+), 26 deletions(-)

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

