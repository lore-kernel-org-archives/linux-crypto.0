Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A80862566D1;
	Mon, 10 Feb 2025 17:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739209561; cv=none; b=FXJ6Ih/kZnfFK45J6/bAQNBrvHWMwN7280KrtPOho21zJaeGhKIMrSQft0In/eKl03uJ9s0X7pbiMoKPG8Oqc4e3WYGNsqY0S3afo8gWZ5Aapt9hwNXEQXVxXpaDfeUnwsor62HF4iZbFlXtuTkLP3VAkStnviDpLH5rqAFO2tI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739209561; c=relaxed/simple;
	bh=z3VlGNh9Ebdd5u3D6w+au8gk9FZ2kN5XGr3s//44UMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JEZW/UcTOZ9fuQZLX1cS4O/sK7krL/eH7Md5uWRZs9PE+C+wCp3EO3Yxt1qBoM94VoCZjFabpErp1LdOp1Az8Y+5SwokIDxZpeYqFE3QLWgv8p2fA6TyrrfLszAu8JWKAsdF6xlyN0rtaGnWTTiwswhsnVPsyr9QJHsE5KTEaSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GW0jRFly; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GW0jRFly"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF98FC4CEE6;
	Mon, 10 Feb 2025 17:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739209561;
	bh=z3VlGNh9Ebdd5u3D6w+au8gk9FZ2kN5XGr3s//44UMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GW0jRFly3izf6lWvztj9ZZjOQCTCztOusGsG+jnQbS0q3F4Gou3gKN5TrlC9IC8xZ
	 IhDt6KLnldJiIu644ADRmjTXCGPCxkCt2AoDoZVyBSb2MhHcgCeuKz0q/fB/qUuf6d
	 wgN6XfQ44AnyAUOugiLF+dxEesw13H+CFhLDyBwzCKQlLbYH25Se37PdptrYvl37sk
	 Fil5Xi2I4WZZIeYf1RfDtDUDSWzW+AShGA+0Wdf6aTGhnyCyiCGudxZqKaz5u0K22q
	 4Aj/61jvOGcMcPOidql9TGp1VtaG2QFFPEugSzYG+MuiDUzERI6n7iubf6sfI/HgsC
	 gqYW5I5y3rKlg==
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
Subject: [PATCH v4 1/6] x86: move ZMM exclusion list into CPU feature flag
Date: Mon, 10 Feb 2025 09:45:35 -0800
Message-ID: <20250210174540.161705-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250210174540.161705-1-ebiggers@kernel.org>
References: <20250210174540.161705-1-ebiggers@kernel.org>
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
Acked-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: "Martin K. Petersen" <martin.petersen@oracle.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/aesni-intel_glue.c | 22 +---------------------
 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/kernel/cpu/intel.c        | 22 ++++++++++++++++++++++
 3 files changed, 24 insertions(+), 21 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 11e95fc62636e..3e9ab5cdade47 100644
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
index 508c0dad116bc..99334026a26c9 100644
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
index 3dce22f00dc34..c3005c4ec46a9 100644
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

