Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42571341062;
	Thu, 13 Aug 2026 02:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786587622; cv=none; b=cbUCYVSF+GcCGIeH58fgqYH6rYmMZ7i/swNS6u1D6tDbrOqnK8gZKUZxA3dYTwp/7jNTCsTjLxzmjgfWdV7+RtJZ9Ghz2B1i9cqlVSuP025fbGFhv7Ck7JKqBCxxrc7Kblu6fUq+mZqM8GNj9uXaci8X5wCItogehAZ+i9W7Occ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786587622; c=relaxed/simple;
	bh=mF5Si+fJ2SqCKuU/60v4aWm6TNcVfLmMHZQC50LpG1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KijNUpIBADmMhx161+jYFJgLsfxFofe4iweEEbH4K+Z2WgOhjC7qg+aCeBUxTmLhT3KAUYCkao2APA87He9jsxwnlSqhL2AymAPuIVOxAhERo36FYgJ4BEyXc8x5UmevPp2C0tJSBIYVGpIPBeOuc/RHnNFicKPQ1/5SJUYxZkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C4Sg8aE0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C4Sg8aE0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C653A1F00A3F;
	Thu, 13 Aug 2026 02:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786587621;
	bh=Q2A0VpZ3jEW63u/fB0uqkGhkDFeSh86cNwd3FvE985o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C4Sg8aE0DUbh5ju4dG+p+6BhIvIC/yloRPIln0CHHzIDIf2bbAcvc/rN9mK785z0Z
	 ET3+D3+v3rbjhwq3NNJsVpzQjqn0w/bxkuovj2jvDKCNrLrSfn5Win+rMnkAESYmva
	 SL2JZpIGfPsZaGHUCbLrT8Qv3Mdur8U3On5EqrjwyCsMNGjKYS+jVgs/QKE0fxALEO
	 EvKT7oO4LGWRao+6g2P5sFAK0OQF0uUI4kOa0vJtjjsBDm8NhDxD3ZKHU8eI5VonW5
	 1NB5Gj562PVObvKwBsqgEqRN4/lY9feqf5rq5rkYOLdpZLbTBpAup4lnHaNYhPAKwV
	 9wAlWaeVaQoSA==
From: Eric Biggers <ebiggers@kernel.org>
To: x86@kernel.org
Cc: linux-um@lists.infradead.org,
	linux-raid@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v3 6/8] x86/fpu: Remove cpu_has_xfeatures()
Date: Wed, 12 Aug 2026 19:15:04 -0700
Message-ID: <20260813021506.55129-7-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260813021506.55129-1-ebiggers@kernel.org>
References: <20260813021506.55129-1-ebiggers@kernel.org>
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

