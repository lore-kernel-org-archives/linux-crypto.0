Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2246740EB9C;
	Tue,  1 Sep 2026 14:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788274694; cv=none; b=e2IIekv8L77QswseacdhtJGoVdxjXJui6tKlohfny9+muNiccdiIHvsK9JYykexJk3pxrZ2cE/4YZZZ1R5ElbrBgrCaf5W/cG8uvEtcEwBpV8lydU+20ml9zDi0teFz8x9gblu1k2yyX3wZqIa7EMpvL5cZZnIox2e/mhuZqLcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788274694; c=relaxed/simple;
	bh=zH06ZKSgGhEhXr0gPfiGkd8DxI44+kr5wz8zEOUWQZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TPsUY4dOw1d2yBYI5RYaRyKZ5pdxmXb0NxrYAHPtnufcE/X0h4oBwZH4uwXsidhe5xdJmrTgyRu5mHKP+/7ebbBzM2uraSmdRtb2I27o87CLS/SP6Ak6eVg49r+OVRnVXU9cPI0LW8XoaVMhr0TbhzU+x9CdwI/lcAFdr7N3RfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cysZZLRF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cysZZLRF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 945BD1F00A3A;
	Tue,  1 Sep 2026 14:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788274692;
	bh=56BaSgitaCOqK+plEdyRoTXW75Ul7dUQbsnofeonq2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cysZZLRFOedPPPO//ebfnqWoUAq3ACVHOVowkBLYsRGJLs6dfZ4GNpCIgWF8XKMl1
	 +j2GuQzQOQYK2TfKBNUBNFBBBDAome86zQr8Y51X0jKUXLbqT7cUPA5HtWWPlVeWYp
	 q9mPHrT1s2gFffWPqNKVAgQzr/VaTwoUwNWRsBSMphHqgRR6Nr3HvGEVWWc4XryRgv
	 MPKfD0cf/YATfgKkrTbxcTyyJeOhB37+rZm0meKJhRjmx/HJ7FE+qIGsBHR0i1j4Er
	 woSJpjWbnwlL67kE3yJx7iy9nBBIo5e9Cggk0yhLyETt1PzFjhw+8uWH6XGUw+Nn7d
	 Nd9Xn71cRSTxA==
From: Eric Biggers <ebiggers@kernel.org>
To: x86@kernel.org
Cc: linux-um@lists.infradead.org,
	linux-raid@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v5 1/8] x86/fpu: Check for missing AVX and AVX-512 xstate bits
Date: Tue,  1 Sep 2026 07:57:33 -0700
Message-ID: <20260901145740.42337-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260901145740.42337-1-ebiggers@kernel.org>
References: <20260901145740.42337-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If the CPU declares AVX or AVX-512 support, verify that the
corresponding xstate bits are also set.  If not, warn and clear them.

This eliminates the perceived need for AVX and AVX-512 optimized code in
the kernel to call cpu_has_xfeatures().  That has never been universally
done, which strongly suggests that it has never really been needed in
practice, but this should remove any remaining doubt.

Acked-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/x86/kernel/fpu/xstate.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index a7b6524a9dea..97cfd4fb6cc0 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -806,7 +806,7 @@ static u64 __init guest_default_mask(void)
 void __init fpu__init_system_xstate(unsigned int legacy_size)
 {
 	unsigned int eax, ebx, ecx, edx;
-	u64 xfeatures;
+	u64 xfeatures, mask;
 	int err;
 	int i;
 
@@ -818,6 +818,8 @@ void __init fpu__init_system_xstate(unsigned int legacy_size)
 	if (!boot_cpu_has(X86_FEATURE_XSAVE)) {
 		pr_info("x86/fpu: x87 FPU will use %s\n",
 			boot_cpu_has(X86_FEATURE_FXSR) ? "FXSAVE" : "FSAVE");
+		/* Disable all dependent flags too */
+		setup_clear_cpu_cap(X86_FEATURE_XSAVE);
 		return;
 	}
 
@@ -833,7 +835,8 @@ void __init fpu__init_system_xstate(unsigned int legacy_size)
 	cpuid_count(CPUID_LEAF_XSTATE, 1, &eax, &ebx, &ecx, &edx);
 	fpu_kernel_cfg.max_features |= ecx + ((u64)edx << 32);
 
-	if ((fpu_kernel_cfg.max_features & XFEATURE_MASK_FPSSE) != XFEATURE_MASK_FPSSE) {
+	mask = XFEATURE_MASK_FPSSE;
+	if ((fpu_kernel_cfg.max_features & mask) != mask) {
 		/*
 		 * This indicates that something really unexpected happened
 		 * with the enumeration.  Disable XSAVE and try to continue
@@ -844,6 +847,24 @@ void __init fpu__init_system_xstate(unsigned int legacy_size)
 		goto out_disable;
 	}
 
+	mask |= XFEATURE_MASK_YMM;
+	if (boot_cpu_has(X86_FEATURE_AVX)) {
+		if ((fpu_kernel_cfg.max_features & mask) != mask) {
+			pr_err(FW_BUG
+			       "x86/fpu: Disabling AVX support due to missing xstate features\n");
+			setup_clear_cpu_cap(X86_FEATURE_AVX);
+		}
+	}
+
+	mask |= XFEATURE_MASK_AVX512;
+	if (boot_cpu_has(X86_FEATURE_AVX512F)) {
+		if ((fpu_kernel_cfg.max_features & mask) != mask) {
+			pr_err(FW_BUG
+			       "x86/fpu: Disabling AVX-512 support due to missing xstate features\n");
+			setup_clear_cpu_cap(X86_FEATURE_AVX512F);
+		}
+	}
+
 	if (fpu_kernel_cfg.max_features & XFEATURE_MASK_APX &&
 	    fpu_kernel_cfg.max_features & (XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR)) {
 		/*
-- 
2.55.0

