Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE41272615;
	Sat, 16 Aug 2025 02:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755309971; cv=none; b=s53SoZxvsVAm44JHXiF3n2b8ZrwbuHGa6un+OQsOZP6TLGp+25Z5xWxzVsd/J3MTgGkQN+9BBH7eKpgu/A3T7DcxO2mL6uRMfW3D0M7yI0NV0ajfzYATCuzMYabBgKA89Uzl4IDqhFRAw9DU+CZWRFSbtZhwsZEEflQc7DcvezI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755309971; c=relaxed/simple;
	bh=NOsxdxYrW7Asq/W2QdVgo1gwbbPwUtpsrHOz1itW15M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FqH5ci40OOjt1RfH0VrA7b4eTxXXMkubVCmwYZjKcNbL/fWT+RA6i7wARtS6XURox6BxMjg8XNSM0NbrQIarrzoGwm/rE25lScVX0wSTaX+jsUavl1NyEZvB4V5A0wAvyQ2D719893lGOJ67YcdLrhxtMofWFCig+G0nFEeKYaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uuRHaz5f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uuRHaz5f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53330C4CEEB;
	Sat, 16 Aug 2025 02:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755309970;
	bh=NOsxdxYrW7Asq/W2QdVgo1gwbbPwUtpsrHOz1itW15M=;
	h=From:To:Cc:Subject:Date:From;
	b=uuRHaz5f7k9WVe138qZd4goHuqfG0/LGO624UkuzkXYUQxK85FxPtQxpOT1uTaFHH
	 zDB/eHiUaJ9p7ul6nb0QkndgkqNOCLFsgEJZRojCI12lB0UZurXk1zKHl8reMSUzKK
	 qVy12XjEewPATjDil0nMQ7iBt3GgcrRkVKfIifP4FSvnKtbJdu7WTotmZHH8lq0f91
	 3W5kDLF3KkNpPwPY5K/r8s3gO7sXSocJqlrh3hNN6DZRwFq15uAr3toOsjnrJA3GyQ
	 Ik2dow4ObrriHrc6gB5LEXPbr+gcJK+jhkZcIfYQZHC/5O57P68qyefNnywqH8DXcf
	 WEQxpDUclbYuA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] lib/crypto: Drop inline from all *_mod_init_arch() functions
Date: Fri, 15 Aug 2025 19:04:57 -0700
Message-ID: <20250816020457.432040-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Drop 'inline' from all the *_mod_init_arch() functions so that the
compiler will warn about any bugs where they are unused due to not being
wired up properly.  (There are no such bugs currently, so this just
establishes a more robust convention for the future.  Of course, these
functions also tend to get inlined anyway, regardless of the keyword.)

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/arm/sha1.h     | 2 +-
 lib/crypto/arm/sha256.h   | 2 +-
 lib/crypto/arm/sha512.h   | 2 +-
 lib/crypto/arm64/sha1.h   | 2 +-
 lib/crypto/arm64/sha256.h | 2 +-
 lib/crypto/arm64/sha512.h | 2 +-
 lib/crypto/riscv/sha256.h | 2 +-
 lib/crypto/riscv/sha512.h | 2 +-
 lib/crypto/s390/sha1.h    | 2 +-
 lib/crypto/s390/sha256.h  | 2 +-
 lib/crypto/s390/sha512.h  | 2 +-
 lib/crypto/sparc/md5.h    | 2 +-
 lib/crypto/sparc/sha1.h   | 2 +-
 lib/crypto/sparc/sha256.h | 2 +-
 lib/crypto/sparc/sha512.h | 2 +-
 lib/crypto/x86/sha1.h     | 2 +-
 lib/crypto/x86/sha256.h   | 2 +-
 lib/crypto/x86/sha512.h   | 2 +-
 18 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/lib/crypto/arm/sha1.h b/lib/crypto/arm/sha1.h
index fa1e924190006..29f8bcad0447c 100644
--- a/lib/crypto/arm/sha1.h
+++ b/lib/crypto/arm/sha1.h
@@ -33,11 +33,11 @@ static void sha1_blocks(struct sha1_block_state *state,
 	}
 }
 
 #ifdef CONFIG_KERNEL_MODE_NEON
 #define sha1_mod_init_arch sha1_mod_init_arch
-static inline void sha1_mod_init_arch(void)
+static void sha1_mod_init_arch(void)
 {
 	if (elf_hwcap & HWCAP_NEON) {
 		static_branch_enable(&have_neon);
 		if (elf_hwcap2 & HWCAP2_SHA1)
 			static_branch_enable(&have_ce);
diff --git a/lib/crypto/arm/sha256.h b/lib/crypto/arm/sha256.h
index eab713e650f33..7556457b3094b 100644
--- a/lib/crypto/arm/sha256.h
+++ b/lib/crypto/arm/sha256.h
@@ -33,11 +33,11 @@ static void sha256_blocks(struct sha256_block_state *state,
 	}
 }
 
 #ifdef CONFIG_KERNEL_MODE_NEON
 #define sha256_mod_init_arch sha256_mod_init_arch
-static inline void sha256_mod_init_arch(void)
+static void sha256_mod_init_arch(void)
 {
 	if (elf_hwcap & HWCAP_NEON) {
 		static_branch_enable(&have_neon);
 		if (elf_hwcap2 & HWCAP2_SHA2)
 			static_branch_enable(&have_ce);
diff --git a/lib/crypto/arm/sha512.h b/lib/crypto/arm/sha512.h
index cc2447acd5621..d1b485dd275db 100644
--- a/lib/crypto/arm/sha512.h
+++ b/lib/crypto/arm/sha512.h
@@ -27,11 +27,11 @@ static void sha512_blocks(struct sha512_block_state *state,
 	}
 }
 
 #ifdef CONFIG_KERNEL_MODE_NEON
 #define sha512_mod_init_arch sha512_mod_init_arch
-static inline void sha512_mod_init_arch(void)
+static void sha512_mod_init_arch(void)
 {
 	if (cpu_has_neon())
 		static_branch_enable(&have_neon);
 }
 #endif /* CONFIG_KERNEL_MODE_NEON */
diff --git a/lib/crypto/arm64/sha1.h b/lib/crypto/arm64/sha1.h
index f822563538cc8..aaef4ebfc5e34 100644
--- a/lib/crypto/arm64/sha1.h
+++ b/lib/crypto/arm64/sha1.h
@@ -30,10 +30,10 @@ static void sha1_blocks(struct sha1_block_state *state,
 		sha1_blocks_generic(state, data, nblocks);
 	}
 }
 
 #define sha1_mod_init_arch sha1_mod_init_arch
-static inline void sha1_mod_init_arch(void)
+static void sha1_mod_init_arch(void)
 {
 	if (cpu_have_named_feature(SHA1))
 		static_branch_enable(&have_ce);
 }
diff --git a/lib/crypto/arm64/sha256.h b/lib/crypto/arm64/sha256.h
index d95f1077c32bd..be4aeda9d0e6e 100644
--- a/lib/crypto/arm64/sha256.h
+++ b/lib/crypto/arm64/sha256.h
@@ -44,11 +44,11 @@ static void sha256_blocks(struct sha256_block_state *state,
 	}
 }
 
 #ifdef CONFIG_KERNEL_MODE_NEON
 #define sha256_mod_init_arch sha256_mod_init_arch
-static inline void sha256_mod_init_arch(void)
+static void sha256_mod_init_arch(void)
 {
 	if (cpu_have_named_feature(ASIMD)) {
 		static_branch_enable(&have_neon);
 		if (cpu_have_named_feature(SHA2))
 			static_branch_enable(&have_ce);
diff --git a/lib/crypto/arm64/sha512.h b/lib/crypto/arm64/sha512.h
index 7539ea3fef10d..ddb0d256f73aa 100644
--- a/lib/crypto/arm64/sha512.h
+++ b/lib/crypto/arm64/sha512.h
@@ -35,11 +35,11 @@ static void sha512_blocks(struct sha512_block_state *state,
 	}
 }
 
 #ifdef CONFIG_KERNEL_MODE_NEON
 #define sha512_mod_init_arch sha512_mod_init_arch
-static inline void sha512_mod_init_arch(void)
+static void sha512_mod_init_arch(void)
 {
 	if (cpu_have_named_feature(SHA512))
 		static_branch_enable(&have_sha512_insns);
 }
 #endif /* CONFIG_KERNEL_MODE_NEON */
diff --git a/lib/crypto/riscv/sha256.h b/lib/crypto/riscv/sha256.h
index f36f68d2e88cc..1def18b0a4fb5 100644
--- a/lib/crypto/riscv/sha256.h
+++ b/lib/crypto/riscv/sha256.h
@@ -29,11 +29,11 @@ static void sha256_blocks(struct sha256_block_state *state,
 		sha256_blocks_generic(state, data, nblocks);
 	}
 }
 
 #define sha256_mod_init_arch sha256_mod_init_arch
-static inline void sha256_mod_init_arch(void)
+static void sha256_mod_init_arch(void)
 {
 	/* Both zvknha and zvknhb provide the SHA-256 instructions. */
 	if ((riscv_isa_extension_available(NULL, ZVKNHA) ||
 	     riscv_isa_extension_available(NULL, ZVKNHB)) &&
 	    riscv_isa_extension_available(NULL, ZVKB) &&
diff --git a/lib/crypto/riscv/sha512.h b/lib/crypto/riscv/sha512.h
index 59dc0294a9a7e..145bdab1214e3 100644
--- a/lib/crypto/riscv/sha512.h
+++ b/lib/crypto/riscv/sha512.h
@@ -28,11 +28,11 @@ static void sha512_blocks(struct sha512_block_state *state,
 		sha512_blocks_generic(state, data, nblocks);
 	}
 }
 
 #define sha512_mod_init_arch sha512_mod_init_arch
-static inline void sha512_mod_init_arch(void)
+static void sha512_mod_init_arch(void)
 {
 	if (riscv_isa_extension_available(NULL, ZVKNHB) &&
 	    riscv_isa_extension_available(NULL, ZVKB) &&
 	    riscv_vector_vlen() >= 128)
 		static_branch_enable(&have_extensions);
diff --git a/lib/crypto/s390/sha1.h b/lib/crypto/s390/sha1.h
index 08bd138e881cc..73d94476a157a 100644
--- a/lib/crypto/s390/sha1.h
+++ b/lib/crypto/s390/sha1.h
@@ -18,11 +18,11 @@ static void sha1_blocks(struct sha1_block_state *state,
 	else
 		sha1_blocks_generic(state, data, nblocks);
 }
 
 #define sha1_mod_init_arch sha1_mod_init_arch
-static inline void sha1_mod_init_arch(void)
+static void sha1_mod_init_arch(void)
 {
 	if (cpu_have_feature(S390_CPU_FEATURE_MSA) &&
 	    cpacf_query_func(CPACF_KIMD, CPACF_KIMD_SHA_1))
 		static_branch_enable(&have_cpacf_sha1);
 }
diff --git a/lib/crypto/s390/sha256.h b/lib/crypto/s390/sha256.h
index 70a81cbc06b2c..acd4835087897 100644
--- a/lib/crypto/s390/sha256.h
+++ b/lib/crypto/s390/sha256.h
@@ -18,11 +18,11 @@ static void sha256_blocks(struct sha256_block_state *state,
 	else
 		sha256_blocks_generic(state, data, nblocks);
 }
 
 #define sha256_mod_init_arch sha256_mod_init_arch
-static inline void sha256_mod_init_arch(void)
+static void sha256_mod_init_arch(void)
 {
 	if (cpu_have_feature(S390_CPU_FEATURE_MSA) &&
 	    cpacf_query_func(CPACF_KIMD, CPACF_KIMD_SHA_256))
 		static_branch_enable(&have_cpacf_sha256);
 }
diff --git a/lib/crypto/s390/sha512.h b/lib/crypto/s390/sha512.h
index 24744651550cb..46699d43df7eb 100644
--- a/lib/crypto/s390/sha512.h
+++ b/lib/crypto/s390/sha512.h
@@ -18,11 +18,11 @@ static void sha512_blocks(struct sha512_block_state *state,
 	else
 		sha512_blocks_generic(state, data, nblocks);
 }
 
 #define sha512_mod_init_arch sha512_mod_init_arch
-static inline void sha512_mod_init_arch(void)
+static void sha512_mod_init_arch(void)
 {
 	if (cpu_have_feature(S390_CPU_FEATURE_MSA) &&
 	    cpacf_query_func(CPACF_KIMD, CPACF_KIMD_SHA_512))
 		static_branch_enable(&have_cpacf_sha512);
 }
diff --git a/lib/crypto/sparc/md5.h b/lib/crypto/sparc/md5.h
index 3f1b0ed8c0b3f..3995f3e075eb6 100644
--- a/lib/crypto/sparc/md5.h
+++ b/lib/crypto/sparc/md5.h
@@ -30,11 +30,11 @@ static void md5_blocks(struct md5_block_state *state,
 		md5_blocks_generic(state, data, nblocks);
 	}
 }
 
 #define md5_mod_init_arch md5_mod_init_arch
-static inline void md5_mod_init_arch(void)
+static void md5_mod_init_arch(void)
 {
 	unsigned long cfr;
 
 	if (!(sparc64_elf_hwcap & HWCAP_SPARC_CRYPTO))
 		return;
diff --git a/lib/crypto/sparc/sha1.h b/lib/crypto/sparc/sha1.h
index 5015f93584b7e..bdf771fcc1f73 100644
--- a/lib/crypto/sparc/sha1.h
+++ b/lib/crypto/sparc/sha1.h
@@ -25,11 +25,11 @@ static void sha1_blocks(struct sha1_block_state *state,
 	else
 		sha1_blocks_generic(state, data, nblocks);
 }
 
 #define sha1_mod_init_arch sha1_mod_init_arch
-static inline void sha1_mod_init_arch(void)
+static void sha1_mod_init_arch(void)
 {
 	unsigned long cfr;
 
 	if (!(sparc64_elf_hwcap & HWCAP_SPARC_CRYPTO))
 		return;
diff --git a/lib/crypto/sparc/sha256.h b/lib/crypto/sparc/sha256.h
index 1d10108eb1954..b2f4419ec7781 100644
--- a/lib/crypto/sparc/sha256.h
+++ b/lib/crypto/sparc/sha256.h
@@ -25,11 +25,11 @@ static void sha256_blocks(struct sha256_block_state *state,
 	else
 		sha256_blocks_generic(state, data, nblocks);
 }
 
 #define sha256_mod_init_arch sha256_mod_init_arch
-static inline void sha256_mod_init_arch(void)
+static void sha256_mod_init_arch(void)
 {
 	unsigned long cfr;
 
 	if (!(sparc64_elf_hwcap & HWCAP_SPARC_CRYPTO))
 		return;
diff --git a/lib/crypto/sparc/sha512.h b/lib/crypto/sparc/sha512.h
index 55303ab6b15f7..a8c37a7d4c393 100644
--- a/lib/crypto/sparc/sha512.h
+++ b/lib/crypto/sparc/sha512.h
@@ -24,11 +24,11 @@ static void sha512_blocks(struct sha512_block_state *state,
 	else
 		sha512_blocks_generic(state, data, nblocks);
 }
 
 #define sha512_mod_init_arch sha512_mod_init_arch
-static inline void sha512_mod_init_arch(void)
+static void sha512_mod_init_arch(void)
 {
 	unsigned long cfr;
 
 	if (!(sparc64_elf_hwcap & HWCAP_SPARC_CRYPTO))
 		return;
diff --git a/lib/crypto/x86/sha1.h b/lib/crypto/x86/sha1.h
index e308379d89bcf..c48a0131fd12c 100644
--- a/lib/crypto/x86/sha1.h
+++ b/lib/crypto/x86/sha1.h
@@ -53,11 +53,11 @@ static void sha1_blocks(struct sha1_block_state *state,
 {
 	static_call(sha1_blocks_x86)(state, data, nblocks);
 }
 
 #define sha1_mod_init_arch sha1_mod_init_arch
-static inline void sha1_mod_init_arch(void)
+static void sha1_mod_init_arch(void)
 {
 	if (boot_cpu_has(X86_FEATURE_SHA_NI)) {
 		static_call_update(sha1_blocks_x86, sha1_blocks_ni);
 	} else if (cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM,
 				     NULL) &&
diff --git a/lib/crypto/x86/sha256.h b/lib/crypto/x86/sha256.h
index c852396ef3190..41fa95fbc3bf8 100644
--- a/lib/crypto/x86/sha256.h
+++ b/lib/crypto/x86/sha256.h
@@ -34,11 +34,11 @@ static void sha256_blocks(struct sha256_block_state *state,
 {
 	static_call(sha256_blocks_x86)(state, data, nblocks);
 }
 
 #define sha256_mod_init_arch sha256_mod_init_arch
-static inline void sha256_mod_init_arch(void)
+static void sha256_mod_init_arch(void)
 {
 	if (boot_cpu_has(X86_FEATURE_SHA_NI)) {
 		static_call_update(sha256_blocks_x86, sha256_blocks_ni);
 	} else if (cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM,
 				     NULL) &&
diff --git a/lib/crypto/x86/sha512.h b/lib/crypto/x86/sha512.h
index be2c8fc122469..0213c70cedd01 100644
--- a/lib/crypto/x86/sha512.h
+++ b/lib/crypto/x86/sha512.h
@@ -33,11 +33,11 @@ static void sha512_blocks(struct sha512_block_state *state,
 {
 	static_call(sha512_blocks_x86)(state, data, nblocks);
 }
 
 #define sha512_mod_init_arch sha512_mod_init_arch
-static inline void sha512_mod_init_arch(void)
+static void sha512_mod_init_arch(void)
 {
 	if (cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM, NULL) &&
 	    boot_cpu_has(X86_FEATURE_AVX)) {
 		if (boot_cpu_has(X86_FEATURE_AVX2) &&
 		    boot_cpu_has(X86_FEATURE_BMI2))

base-commit: 56784a42208677e6fb24ba0bd93a2ea0bd9f41ff
-- 
2.50.1

