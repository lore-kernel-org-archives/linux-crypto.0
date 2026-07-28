Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43216246BCD;
	Tue, 28 Jul 2026 02:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785205158; cv=none; b=GEDPoPml5pu15dTJXBBl8es9xS7iGvTyXhBr6Kj4CnKtazuAXyqHJEegdK4LtWTf3FWJDIocUhM8iUbI4DlXYJperXgFpZ7srUDO5n0DVK97/IRH/BZ0E3BdZOQzSqzQx4ukB3AIoGjWyi15EVG6AlcRFL/9MDQi8Assrnadi1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785205158; c=relaxed/simple;
	bh=5fW6r8I7SPHHRqw9uoG3rFt8dHB6yp3M0tx8jjprMmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bo0S3hT7pSPmobQMgOB3T/Al/boa3X9yo/atHJsEZwU/amGBeUQhqAfGgb0aenfnKStSUJQtA8nIESdtaLExfCHtRT4KjMcsJT0r2FHGrrrIPi5YKqS1pid9BF2owkZ3yLID6fFLlziFR8r4XKLLr9vKaJ9fBGPozQX9JHjYNL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GfsfHvyy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GfsfHvyy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B70D71F00A3E;
	Tue, 28 Jul 2026 02:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785205157;
	bh=MCVeeNdoxXfPsfpQPY8gX2ITb7N+ezoKC7QMn07irFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GfsfHvyyOAHyP6ZKanOnAHzJ0qgB9nTYymqSkDgkiqF90LytugcETR+egj33wXCm/
	 KUDR+sXyRHVnX95TzapiMFAQ9S/88F0mLxe786heodJ2w8Z8aph5EtXRiUCYbfVshk
	 BfRnHQGJoT+xItyC7/7db325j5yEj6W6JihcpNGWD1mg4cdb8DdEpuD516+bnAgExe
	 FhNIAutgDhFesr6ICNBsFW++npqUy3FhajVERauogUSPZ0oRywDLdcEez4TGrpSG36
	 ryF0bB8G6wjYFkRdEobG8Swgf97desrnX21dfv0qwa8zU3632SZlrgE9bGMgJIq+TD
	 1ZFrNPWx2BM4A==
From: Eric Biggers <ebiggers@kernel.org>
To: x86@kernel.org
Cc: linux-um@lists.infradead.org,
	linux-raid@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 1/8] x86/fpu: Check for missing AVX and AVX-512 xstate bits
Date: Mon, 27 Jul 2026 19:15:56 -0700
Message-ID: <20260728021603.79870-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260728021603.79870-1-ebiggers@kernel.org>
References: <20260728021603.79870-1-ebiggers@kernel.org>
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
 arch/x86/kernel/fpu/xstate.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index a7b6524a9dea2..904ff933c0d88 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -799,6 +799,23 @@ static u64 __init guest_default_mask(void)
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
@@ -812,12 +829,14 @@ void __init fpu__init_system_xstate(unsigned int legacy_size)
 
 	if (!boot_cpu_has(X86_FEATURE_FPU)) {
 		pr_info("x86/fpu: No FPU detected\n");
+		clear_cpu_caps_with_missing_xfeatures(0);
 		return;
 	}
 
 	if (!boot_cpu_has(X86_FEATURE_XSAVE)) {
 		pr_info("x86/fpu: x87 FPU will use %s\n",
 			boot_cpu_has(X86_FEATURE_FXSR) ? "FXSAVE" : "FSAVE");
+		clear_cpu_caps_with_missing_xfeatures(0);
 		return;
 	}
 
@@ -855,6 +874,8 @@ void __init fpu__init_system_xstate(unsigned int legacy_size)
 		goto out_disable;
 	}
 
+	clear_cpu_caps_with_missing_xfeatures(fpu_kernel_cfg.max_features);
+
 	fpu_kernel_cfg.independent_features = fpu_kernel_cfg.max_features &
 					      XFEATURE_MASK_INDEPENDENT;
 
-- 
2.55.0

