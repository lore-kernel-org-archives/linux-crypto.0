Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7CED427FB2;
	Sat, 15 Aug 2026 18:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786817554; cv=none; b=O6wW/bzLsnvIINfc32nCrSedmm0ZOmkKkCbkkm8C86y1nO/Ajo1V77ErkssRMKugumb1ZXyZJu70BxRHPLi+Okrh9zMGsPm2bDmrLWv3p3VDhDxQuFYHyJ5xHmZXIilyhNVH9lHn12CyYe/Y/MuRkkgI1MqdV72ACOIkb9fWRIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786817554; c=relaxed/simple;
	bh=zH06ZKSgGhEhXr0gPfiGkd8DxI44+kr5wz8zEOUWQZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UjcfzqtRcCQ8+3pl5XkX6ZurnybvJLaMO68nraio30NGA0Xw4cjg5lXqTBJfQWlO1oINEY8ThNx4fQx+28Z9Tk9GSIMXYXoyB6Axn/y0wyrj8bDO6VS4zHZ83Y8Esk3hXh2tIrNxKxUnP3chZw3oiVtu6egtbS/5QtZARyurL80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ibtt13p/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ibtt13p/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7F1E1F00A3D;
	Sat, 15 Aug 2026 18:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786817552;
	bh=56BaSgitaCOqK+plEdyRoTXW75Ul7dUQbsnofeonq2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ibtt13p/ut3DXj5E1hvkhl1UNTj+CB2aiqwLD1F87/vzPhrcIE59TiioTJtgqrUMq
	 yTuSga0hziN5WGfJgjieQJC2AffTSCOOUIzjYXMBkgV/e7KGKsvWstcibmeiQzHV0F
	 5ELl2w90P/v5Pbwd2rB/My+efCOG3or5vhM+J0VwrWjTbOPC5+XTKJJ9F3AtsEsnsr
	 4k2udMVv6Ab9G68lxpgLu75JhoSVS/jgIjpOspTgqWFi9LjJuN9Fqw+2F8gYTN4K8A
	 QcrRhFfI1myb2qsBXx0e+hxRt2WN/l5TO/s2CwEmZaYfdpSsVMjYUYqWI7w6o0SbLJ
	 7ynQB+TjFHXeg==
From: Eric Biggers <ebiggers@kernel.org>
To: x86@kernel.org
Cc: linux-um@lists.infradead.org,
	linux-raid@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v4 1/8] x86/fpu: Check for missing AVX and AVX-512 xstate bits
Date: Sat, 15 Aug 2026 11:10:17 -0700
Message-ID: <20260815181024.28924-2-ebiggers@kernel.org>
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

