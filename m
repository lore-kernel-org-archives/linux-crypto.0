Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E6AF390C8E;
	Fri, 26 Jun 2026 04:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782448767; cv=none; b=qmMyc1bMun1WiLOLHsaF4Xaito/kpQLJFVDxXRbXkkq0f/BhuJ253gsBYPlKntJ9B0WGahisQdrSVK8yzaLOCndY572oKQhKR65U3R5atz1wltprt7Tbo8DWhCgJiBrgGLihFiH3hzPHLTSczMUprbHriVAD43NHdVLUh88KzB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782448767; c=relaxed/simple;
	bh=hbFXBEVMuMODebSorhMuggkb1WTerhR8rzsdX7bjMek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZtDgFYqlsLN3KqNyrMndgzORlcFK7HOPkFAvcUhAWYJDwBhcY/cH6Wb/RDf534+Erp14aQi7gBegXCIuZt8E+uCif2pB7IKskN8mjK/3AANsGmL2ompm1/ZjEkTpSmRQ0i4Lc0C9ZMGHxGY2GuTDjsPDAEsTIGb+Z3+aymWTrik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IscOaURz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IscOaURz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E36F41F00A3F;
	Fri, 26 Jun 2026 04:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782448766;
	bh=aUvemCYU2gM0Md1nHd9zkcg4lEq76VgyKyutQ2xO3OM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IscOaURzwbCIcrFUSIAXfbPZiTU83y04muUJKOhxo/IlHadrjcl89lllQkNW6U9dp
	 ZGwRE0NZZuiHRFwKtmb+eeNPFStTpI96aRAHu8+ybFnB54+lKNZ0L5F3TeuGXyFy/2
	 JPUau7gXAPSyvFluDZTr7m4t40Ya5pm+k28ASfC+9RMGz7kPcuDWChPLSjae7jU7lU
	 wV89DTc0kpcVzrallKtyKi8JNbgOZLSKW39yQEu1if/gxaFHihLdfV6Wj96cjeu/K7
	 RbP88aWZp/1LBLeH9hBjV9I95osabpgIHMOPX6ycdqE2HG6thODuhFAYsUS/Upe6ZK
	 nABQ4RrnXu19Q==
From: Eric Biggers <ebiggers@kernel.org>
To: x86@kernel.org
Cc: linux-um@lists.infradead.org,
	linux-raid@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6/8] x86/fpu: Remove cpu_has_xfeatures()
Date: Thu, 25 Jun 2026 21:37:29 -0700
Message-ID: <20260626043731.319287-7-ebiggers@kernel.org>
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

The only remaining caller of cpu_has_xfeatures() is
print_xstate_features(), which uses it only to check and get the name of
a single feature.

Remove it and just inline the needed code into print_xstate_features().

This also makes the "unknown xstate feature" entry at index XFEATURE_MAX
of xfeature_names[] unnecessary, so remove that too.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/x86/include/asm/fpu/api.h |  9 -------
 arch/x86/kernel/fpu/xstate.c   | 44 +++-------------------------------
 2 files changed, 3 insertions(+), 50 deletions(-)

diff --git a/arch/x86/include/asm/fpu/api.h b/arch/x86/include/asm/fpu/api.h
index 90c63fe19c0f..cfed8b24d64f 100644
--- a/arch/x86/include/asm/fpu/api.h
+++ b/arch/x86/include/asm/fpu/api.h
@@ -97,19 +97,10 @@ static inline void fpregs_assert_state_consistent(void) { }
 /*
  * Load the task FPU state before returning to userspace.
  */
 extern void switch_fpu_return(void);
 
-/*
- * Query the presence of one or more xfeatures. Works on any legacy CPU as well.
- *
- * If 'feature_name' is set then put a human-readable description of
- * the feature there as well - this can be used to print error (or success)
- * messages.
- */
-extern int cpu_has_xfeatures(u64 xfeatures_mask, const char **feature_name);
-
 /* Trap handling */
 extern int  fpu__exception_code(struct fpu *fpu, int trap_nr);
 extern void fpu_sync_fpstate(struct fpu *fpu);
 extern void fpu_reset_from_exception_fixup(void);
 
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index 7f7e62e4ebc5..c6f0264f957c 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -64,12 +64,12 @@ static const char *xfeature_names[] =
 	"unknown xstate feature",
 	"unknown xstate feature",
 	"AMX Tile config",
 	"AMX Tile data",
 	"APX registers",
-	"unknown xstate feature",
 };
+static_assert(ARRAY_SIZE(xfeature_names) == XFEATURE_MAX);
 
 static unsigned short xsave_cpuid_features[] __initdata = {
 	[XFEATURE_FP]				= X86_FEATURE_FPU,
 	[XFEATURE_SSE]				= X86_FEATURE_XMM,
 	[XFEATURE_YMM]				= X86_FEATURE_AVX,
@@ -120,48 +120,10 @@ static inline unsigned int next_xfeature_order(unsigned int i, u64 mask)
 	     i++)
 
 #define XSTATE_FLAG_SUPERVISOR	BIT(0)
 #define XSTATE_FLAG_ALIGNED64	BIT(1)
 
-/*
- * Return whether the system supports a given xfeature.
- *
- * Also return the name of the (most advanced) feature that the caller requested:
- */
-int cpu_has_xfeatures(u64 xfeatures_needed, const char **feature_name)
-{
-	u64 xfeatures_missing = xfeatures_needed & ~fpu_kernel_cfg.max_features;
-
-	if (unlikely(feature_name)) {
-		long xfeature_idx, max_idx;
-		u64 xfeatures_print;
-		/*
-		 * So we use FLS here to be able to print the most advanced
-		 * feature that was requested but is missing. So if a driver
-		 * asks about "XFEATURE_MASK_SSE | XFEATURE_MASK_YMM" we'll print the
-		 * missing AVX feature - this is the most informative message
-		 * to users:
-		 */
-		if (xfeatures_missing)
-			xfeatures_print = xfeatures_missing;
-		else
-			xfeatures_print = xfeatures_needed;
-
-		xfeature_idx = fls64(xfeatures_print)-1;
-		max_idx = ARRAY_SIZE(xfeature_names)-1;
-		xfeature_idx = min(xfeature_idx, max_idx);
-
-		*feature_name = xfeature_names[xfeature_idx];
-	}
-
-	if (xfeatures_missing)
-		return 0;
-
-	return 1;
-}
-EXPORT_SYMBOL_GPL(cpu_has_xfeatures);
-
 static bool xfeature_is_aligned64(int xfeature_nr)
 {
 	return xstate_flags[xfeature_nr] & XSTATE_FLAG_ALIGNED64;
 }
 
@@ -300,13 +262,13 @@ static void __init print_xstate_features(void)
 {
 	int i;
 
 	for (i = 0; i < XFEATURE_MAX; i++) {
 		u64 mask = BIT_ULL(i);
-		const char *name;
+		const char *name = xfeature_names[i];
 
-		if (cpu_has_xfeatures(mask, &name))
+		if (fpu_kernel_cfg.max_features & mask)
 			pr_info("x86/fpu: Supporting XSAVE feature 0x%03Lx: '%s'\n", mask, name);
 	}
 }
 
 /*
-- 
2.54.0

