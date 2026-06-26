Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 698AA303C8A;
	Fri, 26 Jun 2026 04:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782448768; cv=none; b=bM0uBxngRsE3/Y7xG3exPdrZMGvv8OiN8vAAZxKz8f1BhwlC/IRI2SzJP+4ZPvgbw774Veety5JCd57H663B3wbV3IITNADxUXlHFVXnu1/19BBCWCA2KHtZriH8GqX6WpatJw7gi3g5nBzuE9XOgiZ7OVMprcq3+463ZS1fyzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782448768; c=relaxed/simple;
	bh=AnFJLbySyDeETlahUwPNSX4yvDcZvB12/BG4xCpoqSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RuUUomZLZYDoZxlpH+GV13SzY+0TDZ4VIq5FC/91rXwSbuVU6jWFJbiOfsAqKpk1oS/sDfEQAKrv6GzXmKYhSihS0n6t4qtT1VGzAYMTdEj8/036swaSCuTnEs2igfGDZA9CzCGQmZ6Bmd9OnjE4Iu8LmSDUdZ5c5CSDKXIKQOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aY5nPgvb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aY5nPgvb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A4E31F00A3A;
	Fri, 26 Jun 2026 04:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782448764;
	bh=LTvew5FISW1+Y3DoGy6/+WEaicn3tFu5Y6jzIXpOte4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aY5nPgvbra9i2bLfegYp1BAgDIW7yQTbZOTbY43eHQpARuNo8vS8rxIW8dHP97WzX
	 FdHvq7EK/hRKLDUYEuOL8JBSgd5gwtd+ZEC43UuakTmE/iZKhQpcuZwi6fmaJRdOYV
	 GDIHewT/RRFX0RcExOrIJoye03Ek8YK6tUlzKStr7oypfBloh3fc2Lr3/GbDiX+UGn
	 TOYnEbWOEXzSlmqJ6AnERYnsgHw8cB/pvZn2U9Q9AfaNZ8WQkM/7LhCkNxdUmaM25t
	 CEhk2lm8DPDXjkUeRPT8yTLMDkekhAGaEX14YILcfCJUuIkCUtf25WlhuQ0TplOzzr
	 G8+RpnKSX1/Pw==
From: Eric Biggers <ebiggers@kernel.org>
To: x86@kernel.org
Cc: linux-um@lists.infradead.org,
	linux-raid@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 1/8] x86/fpu: Check for missing AVX and AVX-512 xstate bits
Date: Thu, 25 Jun 2026 21:37:24 -0700
Message-ID: <20260626043731.319287-2-ebiggers@kernel.org>
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

If the CPU declares AVX or AVX-512 support, verify that the
corresponding xstate bits are also set.  If not, warn and clear them.

This eliminates the perceived need for AVX and AVX-512 optimized code in
the kernel to call cpu_has_xfeatures().  That has never been universally
done, which strongly suggests that it has never really been needed in
practice, but this should remove any remaining doubt.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/x86/kernel/fpu/xstate.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index a7b6524a9dea..7f7e62e4ebc5 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -797,10 +797,27 @@ static u64 __init guest_default_mask(void)
 	 * for KVM guests.
 	 */
 	return ~(u64)XFEATURE_MASK_USER_DYNAMIC;
 }
 
+/* Clear any X86_FEATURE_* used by the kernel whose xfeatures are missing. */
+static void __init clear_cpu_caps_with_missing_xfeatures(u64 xfeatures)
+{
+	u64 mask;
+
+	mask = XFEATURE_MASK_FPSSE | XFEATURE_MASK_YMM;
+	if (boot_cpu_has(X86_FEATURE_AVX) && (xfeatures & mask) != mask) {
+		pr_err("x86/fpu: Disabling AVX support due to missing xstate features\n");
+		setup_clear_cpu_cap(X86_FEATURE_AVX);
+	}
+	mask = XFEATURE_MASK_FPSSE | XFEATURE_MASK_YMM | XFEATURE_MASK_AVX512;
+	if (boot_cpu_has(X86_FEATURE_AVX512F) && (xfeatures & mask) != mask) {
+		pr_err("x86/fpu: Disabling AVX-512 support due to missing xstate features\n");
+		setup_clear_cpu_cap(X86_FEATURE_AVX512F);
+	}
+}
+
 /*
  * Enable and initialize the xsave feature.
  * Called once per system bootup.
  */
 void __init fpu__init_system_xstate(unsigned int legacy_size)
@@ -853,10 +870,12 @@ void __init fpu__init_system_xstate(unsigned int legacy_size)
 		pr_err("x86/fpu: Both APX/MPX present in the CPU's xstate features: 0x%llx.\n",
 		       fpu_kernel_cfg.max_features);
 		goto out_disable;
 	}
 
+	clear_cpu_caps_with_missing_xfeatures(fpu_kernel_cfg.max_features);
+
 	fpu_kernel_cfg.independent_features = fpu_kernel_cfg.max_features &
 					      XFEATURE_MASK_INDEPENDENT;
 
 	/*
 	 * Clear XSAVE features that are disabled in the normal CPUID.
-- 
2.54.0

