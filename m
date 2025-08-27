Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEDD0277CA3;
	Wed, 27 Aug 2025 15:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756307697; cv=none; b=lNu4y9fNU4/h37VuteQ7RTbOepPRKllq4uR6uP8ujZdTAAKR5+YM3i/tlnOucOWxkL/qRpNf2eBxk15yOdyytxDtMkFVzTEw+sQb7Ii/1zr5VCHoq00Ko33d73Q04Kv/zW07g9R9t/e8R6yNJjMO0e4yzjjua7ePr+Uok04VNDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756307697; c=relaxed/simple;
	bh=5zPEaJIPs9FP9Z3db1Xao92WGzZwgzaULtvXVWtymkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mcx9tI17uePAgT0ABLLIyAfuHa90XC33pQrzIcMlIfWXAFnRIlToZ4Fj3XpHRjkhFCQyQdso5zrYP9UCOsvVKDKhPJXI5kvX2R7s3PTHrvK/qEtjwObrZ1MOThbtpTo5zaAPAyAnZYG2LJUQNn5O0Sh1d/cq2Zeq6UGCm7Laa74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mJq7KQg5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mJq7KQg5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ECD4C4CEF9;
	Wed, 27 Aug 2025 15:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756307697;
	bh=5zPEaJIPs9FP9Z3db1Xao92WGzZwgzaULtvXVWtymkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mJq7KQg563aA9KxgOuA2cg9yHt+bGO4EmyKdT72BXkIjYCFlSMCErB4lMrPirrO8T
	 Z37k8x81IpvbB0lTRaexYKLwFx2YtL9nFpHfnmlKBZPmmf0sUL3h2uHjDB/2kywt8u
	 vVGg6C+HcbfyPsWWmC/qG2NHLt6FphiRSBvhkjioa/35UvumlGdUEhL97L2Wlh8Yeg
	 6LB4ei6VmKsyJRTkj1Rm4mkT9O9GJQAP6zubtT5HL/nMyYTqlPMhhix5YseYjbxA1G
	 Rwf3jSYP1vyaHN63Ns7Mq2UAEYHIof85IJhCQMWJpbrFzDxElOCAjdSqTtLCbk579f
	 ntJhFpRRsGWwg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 03/12] lib/crypto: chacha: Remove unused function chacha_is_arch_optimized()
Date: Wed, 27 Aug 2025 08:11:22 -0700
Message-ID: <20250827151131.27733-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250827151131.27733-1-ebiggers@kernel.org>
References: <20250827151131.27733-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

chacha_is_arch_optimized() is no longer used, so remove it.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 include/crypto/chacha.h                | 9 ---------
 lib/crypto/arm/chacha-glue.c           | 7 -------
 lib/crypto/arm64/chacha-neon-glue.c    | 6 ------
 lib/crypto/mips/chacha-glue.c          | 6 ------
 lib/crypto/powerpc/chacha-p10-glue.c   | 6 ------
 lib/crypto/riscv/chacha-riscv64-glue.c | 6 ------
 lib/crypto/s390/chacha-glue.c          | 6 ------
 lib/crypto/x86/chacha_glue.c           | 6 ------
 8 files changed, 52 deletions(-)

diff --git a/include/crypto/chacha.h b/include/crypto/chacha.h
index 91f6b4cf561c7..be25a0b65a05f 100644
--- a/include/crypto/chacha.h
+++ b/include/crypto/chacha.h
@@ -117,15 +117,6 @@ static inline void chacha20_crypt(struct chacha_state *state,
 static inline void chacha_zeroize_state(struct chacha_state *state)
 {
 	memzero_explicit(state, sizeof(*state));
 }
 
-#if IS_ENABLED(CONFIG_CRYPTO_ARCH_HAVE_LIB_CHACHA)
-bool chacha_is_arch_optimized(void);
-#else
-static inline bool chacha_is_arch_optimized(void)
-{
-	return false;
-}
-#endif
-
 #endif /* _CRYPTO_CHACHA_H */
diff --git a/lib/crypto/arm/chacha-glue.c b/lib/crypto/arm/chacha-glue.c
index 88ec964152831..67ba045cae359 100644
--- a/lib/crypto/arm/chacha-glue.c
+++ b/lib/crypto/arm/chacha-glue.c
@@ -99,17 +99,10 @@ void chacha_crypt_arch(struct chacha_state *state, u8 *dst, const u8 *src,
 		dst += todo;
 	} while (bytes);
 }
 EXPORT_SYMBOL(chacha_crypt_arch);
 
-bool chacha_is_arch_optimized(void)
-{
-	/* We always can use at least the ARM scalar implementation. */
-	return true;
-}
-EXPORT_SYMBOL(chacha_is_arch_optimized);
-
 static int __init chacha_arm_mod_init(void)
 {
 	if (IS_ENABLED(CONFIG_KERNEL_MODE_NEON) && (elf_hwcap & HWCAP_NEON)) {
 		switch (read_cpuid_part()) {
 		case ARM_CPU_PART_CORTEX_A7:
diff --git a/lib/crypto/arm64/chacha-neon-glue.c b/lib/crypto/arm64/chacha-neon-glue.c
index d0188f974ca5c..48097aa34af7c 100644
--- a/lib/crypto/arm64/chacha-neon-glue.c
+++ b/lib/crypto/arm64/chacha-neon-glue.c
@@ -93,16 +93,10 @@ void chacha_crypt_arch(struct chacha_state *state, u8 *dst, const u8 *src,
 		dst += todo;
 	} while (bytes);
 }
 EXPORT_SYMBOL(chacha_crypt_arch);
 
-bool chacha_is_arch_optimized(void)
-{
-	return static_key_enabled(&have_neon);
-}
-EXPORT_SYMBOL(chacha_is_arch_optimized);
-
 static int __init chacha_simd_mod_init(void)
 {
 	if (cpu_have_named_feature(ASIMD))
 		static_branch_enable(&have_neon);
 	return 0;
diff --git a/lib/crypto/mips/chacha-glue.c b/lib/crypto/mips/chacha-glue.c
index 88c097594eb0f..f8390af21dc92 100644
--- a/lib/crypto/mips/chacha-glue.c
+++ b/lib/crypto/mips/chacha-glue.c
@@ -16,14 +16,8 @@ EXPORT_SYMBOL(chacha_crypt_arch);
 
 asmlinkage void hchacha_block_arch(const struct chacha_state *state,
 				   u32 out[HCHACHA_OUT_WORDS], int nrounds);
 EXPORT_SYMBOL(hchacha_block_arch);
 
-bool chacha_is_arch_optimized(void)
-{
-	return true;
-}
-EXPORT_SYMBOL(chacha_is_arch_optimized);
-
 MODULE_DESCRIPTION("ChaCha and HChaCha functions (MIPS optimized)");
 MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
 MODULE_LICENSE("GPL v2");
diff --git a/lib/crypto/powerpc/chacha-p10-glue.c b/lib/crypto/powerpc/chacha-p10-glue.c
index fcd23c6f1590b..5d3d5506d7f94 100644
--- a/lib/crypto/powerpc/chacha-p10-glue.c
+++ b/lib/crypto/powerpc/chacha-p10-glue.c
@@ -74,16 +74,10 @@ void chacha_crypt_arch(struct chacha_state *state, u8 *dst, const u8 *src,
 		dst += todo;
 	} while (bytes);
 }
 EXPORT_SYMBOL(chacha_crypt_arch);
 
-bool chacha_is_arch_optimized(void)
-{
-	return static_key_enabled(&have_p10);
-}
-EXPORT_SYMBOL(chacha_is_arch_optimized);
-
 static int __init chacha_p10_init(void)
 {
 	if (cpu_has_feature(CPU_FTR_ARCH_31))
 		static_branch_enable(&have_p10);
 	return 0;
diff --git a/lib/crypto/riscv/chacha-riscv64-glue.c b/lib/crypto/riscv/chacha-riscv64-glue.c
index 8c3f11d79be31..a15f0aca3fc43 100644
--- a/lib/crypto/riscv/chacha-riscv64-glue.c
+++ b/lib/crypto/riscv/chacha-riscv64-glue.c
@@ -48,16 +48,10 @@ void chacha_crypt_arch(struct chacha_state *state, u8 *dst, const u8 *src,
 	}
 	kernel_vector_end();
 }
 EXPORT_SYMBOL(chacha_crypt_arch);
 
-bool chacha_is_arch_optimized(void)
-{
-	return static_key_enabled(&use_zvkb);
-}
-EXPORT_SYMBOL(chacha_is_arch_optimized);
-
 static int __init riscv64_chacha_mod_init(void)
 {
 	if (riscv_isa_extension_available(NULL, ZVKB) &&
 	    riscv_vector_vlen() >= 128)
 		static_branch_enable(&use_zvkb);
diff --git a/lib/crypto/s390/chacha-glue.c b/lib/crypto/s390/chacha-glue.c
index c57dc851214fa..d8137387fe28f 100644
--- a/lib/crypto/s390/chacha-glue.c
+++ b/lib/crypto/s390/chacha-glue.c
@@ -45,13 +45,7 @@ void chacha_crypt_arch(struct chacha_state *state, u8 *dst, const u8 *src,
 				CHACHA_BLOCK_SIZE;
 	}
 }
 EXPORT_SYMBOL(chacha_crypt_arch);
 
-bool chacha_is_arch_optimized(void)
-{
-	return cpu_has_vx();
-}
-EXPORT_SYMBOL(chacha_is_arch_optimized);
-
 MODULE_DESCRIPTION("ChaCha stream cipher (s390 optimized)");
 MODULE_LICENSE("GPL v2");
diff --git a/lib/crypto/x86/chacha_glue.c b/lib/crypto/x86/chacha_glue.c
index 10b2c945f5412..de7da9d512af2 100644
--- a/lib/crypto/x86/chacha_glue.c
+++ b/lib/crypto/x86/chacha_glue.c
@@ -158,16 +158,10 @@ void chacha_crypt_arch(struct chacha_state *state, u8 *dst, const u8 *src,
 		dst += todo;
 	} while (bytes);
 }
 EXPORT_SYMBOL(chacha_crypt_arch);
 
-bool chacha_is_arch_optimized(void)
-{
-	return static_key_enabled(&chacha_use_simd);
-}
-EXPORT_SYMBOL(chacha_is_arch_optimized);
-
 static int __init chacha_simd_mod_init(void)
 {
 	if (!boot_cpu_has(X86_FEATURE_SSSE3))
 		return 0;
 
-- 
2.50.1

