Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A0E3341AB8;
	Mon,  9 Mar 2026 18:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773079280; cv=none; b=NQ3xLlXLkymR4SBRzuzeQZYCboW5cviwJ0khR4wcbLNiOTGvVnnmvcvV8C3rGKE6bg/ht/fTpI1lW5zkbLn3ysnYhedhRVnJzVSGnwOOGp0qTKtsmkuwotAYVNU3v3QFJjzb+xPKIRUpjuxr445MpLTj2quIA0lzEOqf7FREmzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773079280; c=relaxed/simple;
	bh=BDixtaFz3x7404kL2sHxYmQyMahAC6eoXnMaU9q0KE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pheVjyxACDVXYcpFd0P1XcFHydd+L2HQMs2ht2LVT1YJtsmD+7zo6B9Jf4r93aJsuBUPINhsEJJfHxjECfp5mE9qDMljjXhe9tk3tBAUJGHAGJNScJYc2MvhCm/DfWneU2cTvBhPm4d9WU+WthhFznSZQngJqSQHQIPuqf+ZIjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bSfmPjMA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bSfmPjMA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A53E2C2BC87;
	Mon,  9 Mar 2026 18:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773079279;
	bh=BDixtaFz3x7404kL2sHxYmQyMahAC6eoXnMaU9q0KE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bSfmPjMAOAgU7mLnPh7qg1myIXkRtGXq0iladPN/65CwPy+l6uP+dommM7mKkWLeq
	 wrjam9t5eQE4tCwE/FetP0LxjfLRKodixJYRdZvrkC5F+/55pZ8Xmo9rhEfBvolzE6
	 cljtmFKxKpbGG/rPbLQXzh52KkKaH5v92p54hCsddtWPnUkmgBjUN7I9vjpW+J0bx5
	 z4ntnwzAiqsqofqnWZ+uzdDL6HnfXDn/naEhssHIMluXZwtAOs7o63ICXV/zOtc0xP
	 kJV1r/8Q3WLc1esBWdPUzxbwmJ1JGLFMHA8PKk/iuwUkmVOEENPxrco7MTKqy2xx5n
	 tqEE6ARWAYcBw==
From: Tycho Andersen <tycho@kernel.org>
To: Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Ard Biesheuvel <ardb@kernel.org>,
	Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>,
	Kishon Vijay Abraham I <kvijayab@amd.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Nikunj A Dadhania <nikunj@amd.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Kim Phillips <kim.phillips@amd.com>,
	Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: [PATCH v2 03/10] x86/snp: Keep the RMP table bookkeeping area mapped
Date: Mon,  9 Mar 2026 12:00:45 -0600
Message-ID: <20260309180053.2389118-4-tycho@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260309180053.2389118-1-tycho@kernel.org>
References: <20260306153846.GKaar1Bg_1EKm17tXJ@fat_crate.local>
 <20260309180053.2389118-1-tycho@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tom Lendacky <thomas.lendacky@amd.com>

In preparation for delayed SNP initialization and disablement on shutdown,
the RMP will need to be cleared each time SNP is disabled. Maintain the
mapping to the RMP bookkeeping area to avoid mapping and unmapping it each
time and any possible errors that may arise from that.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
---
 arch/x86/virt/svm/sev.c | 40 +++++++++++++++++-----------------------
 1 file changed, 17 insertions(+), 23 deletions(-)

diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 5e07f103c271..e35fac0a8a3d 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -117,6 +117,8 @@ static u64 rmp_segment_mask;
 
 static u64 rmp_cfg;
 
+static void *rmp_bookkeeping __ro_after_init;
+
 /* Mask to apply to a PFN to get the first PFN of a 2MB page */
 #define PFN_PMD_MASK	GENMASK_ULL(63, PMD_SHIFT - PAGE_SHIFT)
 
@@ -240,23 +242,6 @@ void __init snp_fixup_e820_tables(void)
 	}
 }
 
-static bool __init clear_rmptable_bookkeeping(void)
-{
-	void *bk;
-
-	bk = memremap(probed_rmp_base, RMPTABLE_CPU_BOOKKEEPING_SZ, MEMREMAP_WB);
-	if (!bk) {
-		pr_err("Failed to map RMP bookkeeping area\n");
-		return false;
-	}
-
-	memset(bk, 0, RMPTABLE_CPU_BOOKKEEPING_SZ);
-
-	memunmap(bk);
-
-	return true;
-}
-
 static bool __init alloc_rmp_segment_desc(u64 segment_pa, u64 segment_size, u64 pa)
 {
 	u64 rst_index, rmp_segment_size_max;
@@ -474,10 +459,22 @@ static bool __init setup_segmented_rmptable(void)
 static bool __init setup_rmptable(void)
 {
 	if (rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED) {
-		return setup_segmented_rmptable();
+		if (!setup_segmented_rmptable())
+			return false;
 	} else {
-		return setup_contiguous_rmptable();
+		if (!setup_contiguous_rmptable())
+			return false;
 	}
+
+	rmp_bookkeeping = memremap(probed_rmp_base, RMPTABLE_CPU_BOOKKEEPING_SZ, MEMREMAP_WB);
+	if (!rmp_bookkeeping) {
+		pr_err("Failed to map RMP bookkeeping area\n");
+		free_rmp_segment_table();
+
+		return false;
+	}
+
+	return true;
 }
 
 /*
@@ -508,10 +505,7 @@ int __init snp_rmptable_init(void)
 		goto skip_enable;
 
 	/* Zero out the RMP bookkeeping area */
-	if (!clear_rmptable_bookkeeping()) {
-		free_rmp_segment_table();
-		return -ENOSYS;
-	}
+	memset(rmp_bookkeeping, 0, RMPTABLE_CPU_BOOKKEEPING_SZ);
 
 	/* Zero out the RMP entries */
 	for (i = 0; i < rst_max_index; i++) {
-- 
2.53.0

