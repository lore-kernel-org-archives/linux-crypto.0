Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB626429CC5;
	Sat, 15 Aug 2026 18:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786817559; cv=none; b=TUym6EyCZI3epDRjX30CGyrMgOBYjDnJhDcY9fgABFzet8VV2K7hLCkLCyq2KImiYhhEIDDyarH23IpjeCTueO67SqgfUI+I2MAGl87+rJXDyXBmoorZRF+c0W5Q2QPtrfDtLu8EhSKYXEIIfZdk/OzjR8jpiTmySSCkFYTxzOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786817559; c=relaxed/simple;
	bh=mF5Si+fJ2SqCKuU/60v4aWm6TNcVfLmMHZQC50LpG1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nh4snxaYgzS4gvsFkVluWtmhzZz2dsrF8yq3HPvSRkTHcriy+HxT6kyg64df4GjJ9sQ0L+FbGF36RgOKl8cJkbIz3Y54Q+3mFQuheXcqU2anFQKMDQYs46lL/TNoIaWS1QIK+4KZVIBp9cYHz3us3wqhyowGYj6xwsueNIFg628=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c4wGJ8Vh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c4wGJ8Vh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D58F01F00A3D;
	Sat, 15 Aug 2026 18:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786817556;
	bh=Q2A0VpZ3jEW63u/fB0uqkGhkDFeSh86cNwd3FvE985o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c4wGJ8VhfbWJcDXsBWiYh+o+RaU1oHSwqYO5XkKUDm3SwYB1bM/Jig7ny6pjVCX+z
	 LWYigBVe0JYLa+bZdolB7OrxOskpY0bDqWsIDBSVS7BrxMuE7l85gE94/PM/ipaLSZ
	 5h8ZjdKFDpA4HAWuoqogtJvw3SvlVVzrC9h61NdU6w71A/bgrQ9+vwqGDnoZO3OUAi
	 pZkHG+lww+sKuVNmgFH4BcNLtj1gZnEgB2k4aSaJ31HFAesK6PBHb5n34NPfj14glr
	 oa89nzefpeYK5UAs++FLPAUJT4ZkbvGFMu2BlW/oOUIHNaDF/g2BszZ66R34poxAmg
	 ZZu4eY3eouuww==
From: Eric Biggers <ebiggers@kernel.org>
To: x86@kernel.org
Cc: linux-um@lists.infradead.org,
	linux-raid@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v4 6/8] x86/fpu: Remove cpu_has_xfeatures()
Date: Sat, 15 Aug 2026 11:10:22 -0700
Message-ID: <20260815181024.28924-7-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260815181024.28924-1-ebiggers@kernel.org>
References: <20260815181024.28924-1-ebiggers@kernel.org>
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

Acked-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/x86/include/asm/fpu/api.h |  9 -------
 arch/x86/kernel/fpu/xstate.c   | 44 +++-------------------------------
 2 files changed, 3 insertions(+), 50 deletions(-)

diff --git a/arch/x86/include/asm/fpu/api.h b/arch/x86/include/asm/fpu/api.h
index 90c63fe19c0f..cfed8b24d64f 100644
--- a/arch/x86/include/asm/fpu/api.h
+++ b/arch/x86/include/asm/fpu/api.h
@@ -99,15 +99,6 @@ static inline void fpregs_assert_state_consistent(void) { }
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
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index 97cfd4fb6cc0..0b17452d1788 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -66,8 +66,8 @@ static const char *xfeature_names[] =
 	"AMX Tile config",
 	"AMX Tile data",
 	"APX registers",
-	"unknown xstate feature",
 };
+static_assert(ARRAY_SIZE(xfeature_names) == XFEATURE_MAX);
 
 static unsigned short xsave_cpuid_features[] __initdata = {
 	[XFEATURE_FP]				= X86_FEATURE_FPU,
@@ -122,44 +122,6 @@ static inline unsigned int next_xfeature_order(unsigned int i, u64 mask)
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
@@ -302,9 +264,9 @@ static void __init print_xstate_features(void)
 
 	for (i = 0; i < XFEATURE_MAX; i++) {
 		u64 mask = BIT_ULL(i);
-		const char *name;
+		const char *name = xfeature_names[i];
 
-		if (cpu_has_xfeatures(mask, &name))
+		if (fpu_kernel_cfg.max_features & mask)
 			pr_info("x86/fpu: Supporting XSAVE feature 0x%03Lx: '%s'\n", mask, name);
 	}
 }
-- 
2.55.0

