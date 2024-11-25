Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F29B828684;
	Mon, 25 Nov 2024 04:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732507969; cv=none; b=mbKvgDIJaSLT0TEo0UTQil9IMX2/YV4pfHJMbEzc73kw6lCPOXJoFbKXVKYjOyCOQG+6hpiZzS4UUZc9sbs1PCJJaWTsljYn6g4OVardZLM2RMVOPzESlk6JVuzf5Y5vNvScuA2lK2Bn9QgYt7x/UkhfzyZPnPQ/0sn2PRcsAGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732507969; c=relaxed/simple;
	bh=K2z+bqdPllLXnkXaOgcFZIyBICogbckaPeIOPNK1P4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HObIuld3kjFxZMq2aIQpaZX0RXPBYr6FHcBcoMwKfQgEbFLEQpzVAP8Hzx484kZRlpxmarpC3qdwjx8Td0fENnjSxz4E9eqUjHWQpzAu8YqUG/X1b2I+a7ZXaHtoZ5Kb1ihNI+LOtz5GFRiJWbGWA32gP/qvf4AEC8uxGlkeoAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hX0TcKRW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hX0TcKRW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A22FBC4CED6;
	Mon, 25 Nov 2024 04:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732507968;
	bh=K2z+bqdPllLXnkXaOgcFZIyBICogbckaPeIOPNK1P4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hX0TcKRWcodt4aHwM471fRVvfx2Jjr8M2xDXz3mc1WycQQ7Z6qO6siklsvHz9fCiz
	 VoS1nlMrDbi15r33GjKNJEVBejmIiBjYXEXjG/98SXFF+CXsW+furyoFrM16teclqs
	 vGbhsMsAEwwXJHzsJjNMfJ+Fcmx0qjP9XBZlYxmT88CqklIFZord4F66xv0H2pG6RI
	 JLHTsgJmLayr/KscDfwAl1IlQvtvoHjeavhDCkFal8p1xsgA5Uut49iDbpu7uaP88a
	 lB7D6vWZnJyDYPXwJeaAnqWK1o9hS8sIK7b/EkEyD9ylgqeRTTXbmXy+u0LdlCFtg0
	 /bv2a+bxak57w==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	x86@kernel.org,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 1/6] x86: move zmm exclusion list into CPU feature flag
Date: Sun, 24 Nov 2024 20:11:24 -0800
Message-ID: <20241125041129.192999-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241125041129.192999-1-ebiggers@kernel.org>
References: <20241125041129.192999-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Lift zmm_exclusion_list in aesni-intel_glue.c into the x86 CPU setup
code, and add a new x86 CPU feature flag X86_FEATURE_PREFER_YMM that is
set when the CPU is on this list.

This allows other code in arch/x86/, such as the CRC library code, to
apply the same exclusion list when deciding whether to execute 256-bit
or 512-bit optimized functions.

Note that full AVX512 support including zmm registers is still exposed
to userspace and is still supported for in-kernel use.  This flag just
indicates whether in-kernel code should prefer to use ymm registers.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/aesni-intel_glue.c | 22 +---------------------
 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/kernel/cpu/intel.c        | 22 ++++++++++++++++++++++
 3 files changed, 24 insertions(+), 21 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index fbf43482e1f5e..8e648abfb5ab8 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -1534,30 +1534,10 @@ DEFINE_GCM_ALGS(vaes_avx10_256, FLAG_AVX10_256,
 DEFINE_GCM_ALGS(vaes_avx10_512, FLAG_AVX10_512,
 		"generic-gcm-vaes-avx10_512", "rfc4106-gcm-vaes-avx10_512",
 		AES_GCM_KEY_AVX10_SIZE, 800);
 #endif /* CONFIG_AS_VAES && CONFIG_AS_VPCLMULQDQ */
 
-/*
- * This is a list of CPU models that are known to suffer from downclocking when
- * zmm registers (512-bit vectors) are used.  On these CPUs, the AES mode
- * implementations with zmm registers won't be used by default.  Implementations
- * with ymm registers (256-bit vectors) will be used by default instead.
- */
-static const struct x86_cpu_id zmm_exclusion_list[] = {
-	X86_MATCH_VFM(INTEL_SKYLAKE_X,		0),
-	X86_MATCH_VFM(INTEL_ICELAKE_X,		0),
-	X86_MATCH_VFM(INTEL_ICELAKE_D,		0),
-	X86_MATCH_VFM(INTEL_ICELAKE,		0),
-	X86_MATCH_VFM(INTEL_ICELAKE_L,		0),
-	X86_MATCH_VFM(INTEL_ICELAKE_NNPI,	0),
-	X86_MATCH_VFM(INTEL_TIGERLAKE_L,	0),
-	X86_MATCH_VFM(INTEL_TIGERLAKE,		0),
-	/* Allow Rocket Lake and later, and Sapphire Rapids and later. */
-	/* Also allow AMD CPUs (starting with Zen 4, the first with AVX-512). */
-	{},
-};
-
 static int __init register_avx_algs(void)
 {
 	int err;
 
 	if (!boot_cpu_has(X86_FEATURE_AVX))
@@ -1598,11 +1578,11 @@ static int __init register_avx_algs(void)
 					 ARRAY_SIZE(aes_gcm_algs_vaes_avx10_256),
 					 aes_gcm_simdalgs_vaes_avx10_256);
 	if (err)
 		return err;
 
-	if (x86_match_cpu(zmm_exclusion_list)) {
+	if (boot_cpu_has(X86_FEATURE_PREFER_YMM)) {
 		int i;
 
 		aes_xts_alg_vaes_avx10_512.base.cra_priority = 1;
 		for (i = 0; i < ARRAY_SIZE(aes_gcm_algs_vaes_avx10_512); i++)
 			aes_gcm_algs_vaes_avx10_512[i].base.cra_priority = 1;
diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 17b6590748c00..948bfa25ccc7b 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -477,10 +477,11 @@
 #define X86_FEATURE_CLEAR_BHB_HW	(21*32+ 3) /* BHI_DIS_S HW control enabled */
 #define X86_FEATURE_CLEAR_BHB_LOOP_ON_VMEXIT (21*32+ 4) /* Clear branch history at vmexit using SW loop */
 #define X86_FEATURE_AMD_FAST_CPPC	(21*32 + 5) /* Fast CPPC */
 #define X86_FEATURE_AMD_HETEROGENEOUS_CORES (21*32 + 6) /* Heterogeneous Core Topology */
 #define X86_FEATURE_AMD_WORKLOAD_CLASS	(21*32 + 7) /* Workload Classification */
+#define X86_FEATURE_PREFER_YMM		(21*32 + 8) /* Avoid zmm registers due to downclocking */
 
 /*
  * BUG word(s)
  */
 #define X86_BUG(x)			(NCAPINTS*32 + (x))
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index d1de300af1737..0beb44c4ac026 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -519,10 +519,29 @@ static void init_intel_misc_features(struct cpuinfo_x86 *c)
 
 	msr = this_cpu_read(msr_misc_features_shadow);
 	wrmsrl(MSR_MISC_FEATURES_ENABLES, msr);
 }
 
+/*
+ * This is a list of Intel CPUs that are known to suffer from downclocking when
+ * zmm registers (512-bit vectors) are used.  On these CPUs, when the kernel
+ * executes SIMD-optimized code such as cryptography functions or CRCs, it
+ * should prefer 256-bit (ymm) code to 512-bit (zmm) code.
+ */
+static const struct x86_cpu_id zmm_exclusion_list[] = {
+	X86_MATCH_VFM(INTEL_SKYLAKE_X,		0),
+	X86_MATCH_VFM(INTEL_ICELAKE_X,		0),
+	X86_MATCH_VFM(INTEL_ICELAKE_D,		0),
+	X86_MATCH_VFM(INTEL_ICELAKE,		0),
+	X86_MATCH_VFM(INTEL_ICELAKE_L,		0),
+	X86_MATCH_VFM(INTEL_ICELAKE_NNPI,	0),
+	X86_MATCH_VFM(INTEL_TIGERLAKE_L,	0),
+	X86_MATCH_VFM(INTEL_TIGERLAKE,		0),
+	/* Allow Rocket Lake and later, and Sapphire Rapids and later. */
+	{},
+};
+
 static void init_intel(struct cpuinfo_x86 *c)
 {
 	early_init_intel(c);
 
 	intel_workarounds(c);
@@ -602,10 +621,13 @@ static void init_intel(struct cpuinfo_x86 *c)
 		set_cpu_cap(c, X86_FEATURE_P4);
 	if (c->x86 == 6)
 		set_cpu_cap(c, X86_FEATURE_P3);
 #endif
 
+	if (x86_match_cpu(zmm_exclusion_list))
+		set_cpu_cap(c, X86_FEATURE_PREFER_YMM);
+
 	/* Work around errata */
 	srat_detect_node(c);
 
 	init_ia32_feat_ctl(c);
 
-- 
2.47.0

