Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1A91155398;
	Thu, 30 Jan 2025 03:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738209295; cv=none; b=qwG7Ew26zmZU/CxV/+fE7o5bNtQUNkOXRyZxa/vEsd9nmbD0mG7/t9wJSW6xCRy8VudLvg+6ZOb8JYM5jUIN+LbEM61NDavdgRAqWKdmZg8raOLw//L4q2PgXNsngIRrZl93LC9+x/o94XyKQT4oMIup2Kk34HnvFsCDC6QNMLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738209295; c=relaxed/simple;
	bh=LVkKE85lv+nW76ABXQ3mr7xRTYEtJ7RPcs6PZye7cpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=komaDbdGZKcWjqZt5VXN2tkjzouuAthkLiwKZzP0IH6Eug5Pxkv1t8Uxv9LEOBeW0B3D00zk8K7mfpGv+T4e/z4xFdg/VatLVO895s/7Z902FV4iY8xDSbdcqCDL2VbXSqtoyoJAWUNJbCXCBr/DfN9N+2QsV3j/x0fFp/l7X6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q/KgJC/r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q/KgJC/r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FA7CC4CEE6;
	Thu, 30 Jan 2025 03:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738209294;
	bh=LVkKE85lv+nW76ABXQ3mr7xRTYEtJ7RPcs6PZye7cpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q/KgJC/rlCBoiNbmKyNAxIrizojuDiWonL4YErWWO+IW4cz89+XYZVg6uFYJrRtI7
	 xAET78kBvAsJcNBUOcxnDBcEoWt3IQKaq5w+tfqEFjL/9JOWPq7P3M9XSuHuhF5brP
	 lHiYsHByxP7/7/FzgkenjI+zZ9xSqQ6P0DMM1SE+IUEcgr3MPAkWwJO8oEdfNZ3dQl
	 56Q7/Nuk9iFVptN2xLy7FvlDCIdGRnW4/SlsB7mOSeKT1uJnOB0ZtWZFR+VLPO8LK7
	 bWGjUxU+w9ETxcvcmtz5HFF/jqV6l0eI3wIOG0Da1GMM0wz/acOT+6qRbbsEDVSJBe
	 xAA5KZwzBF8+w==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	x86@kernel.org,
	linux-block@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Ingo Molnar <mingo@kernel.org>
Subject: [PATCH v2 06/11] x86: move ZMM exclusion list into CPU feature flag
Date: Wed, 29 Jan 2025 19:51:25 -0800
Message-ID: <20250130035130.180676-7-ebiggers@kernel.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130035130.180676-1-ebiggers@kernel.org>
References: <20250130035130.180676-1-ebiggers@kernel.org>
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

Note that full AVX512 support including ZMM registers is still exposed
to userspace and is still supported for in-kernel use.  This flag just
indicates whether in-kernel code should prefer to use YMM registers.

Acked-by: Ard Biesheuvel <ardb@kernel.org>
Acked-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/aesni-intel_glue.c | 22 +---------------------
 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/kernel/cpu/intel.c        | 22 ++++++++++++++++++++++
 3 files changed, 24 insertions(+), 21 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 11e95fc62636..3e9ab5cdade4 100644
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
index 508c0dad116b..99334026a26c 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -481,10 +481,11 @@
 #define X86_FEATURE_CLEAR_BHB_HW	(21*32+ 3) /* BHI_DIS_S HW control enabled */
 #define X86_FEATURE_CLEAR_BHB_LOOP_ON_VMEXIT (21*32+ 4) /* Clear branch history at vmexit using SW loop */
 #define X86_FEATURE_AMD_FAST_CPPC	(21*32 + 5) /* Fast CPPC */
 #define X86_FEATURE_AMD_HETEROGENEOUS_CORES (21*32 + 6) /* Heterogeneous Core Topology */
 #define X86_FEATURE_AMD_WORKLOAD_CLASS	(21*32 + 7) /* Workload Classification */
+#define X86_FEATURE_PREFER_YMM		(21*32 + 8) /* Avoid ZMM registers due to downclocking */
 
 /*
  * BUG word(s)
  */
 #define X86_BUG(x)			(NCAPINTS*32 + (x))
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 3dce22f00dc3..c3005c4ec46a 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -519,10 +519,29 @@ static void init_intel_misc_features(struct cpuinfo_x86 *c)
 
 	msr = this_cpu_read(msr_misc_features_shadow);
 	wrmsrl(MSR_MISC_FEATURES_ENABLES, msr);
 }
 
+/*
+ * This is a list of Intel CPUs that are known to suffer from downclocking when
+ * ZMM registers (512-bit vectors) are used.  On these CPUs, when the kernel
+ * executes SIMD-optimized code such as cryptography functions or CRCs, it
+ * should prefer 256-bit (YMM) code to 512-bit (ZMM) code.
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
@@ -599,10 +618,13 @@ static void init_intel(struct cpuinfo_x86 *c)
 		if (p)
 			strcpy(c->x86_model_id, p);
 	}
 #endif
 
+	if (x86_match_cpu(zmm_exclusion_list))
+		set_cpu_cap(c, X86_FEATURE_PREFER_YMM);
+
 	/* Work around errata */
 	srat_detect_node(c);
 
 	init_ia32_feat_ctl(c);
 
-- 
2.48.1

