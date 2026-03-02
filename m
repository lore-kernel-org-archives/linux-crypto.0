Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BABF7366DB7;
	Mon,  2 Mar 2026 19:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772478874; cv=none; b=Trt7e/PdIeNMCIJbIqrSIpSf9LDs0L8UvdCb/S9astKrpe3DCs8cu2icrUrXomv1JaRh+tQK0l/nj1JbLgPTDECGZsZ7Pm3CIlKCP5pqPCqQByAgbmTAs5oQC7aT6CROPTclQ10zd9JmfcIMHiJOO8zZgLbGQ3E7D+o2U6jf8Wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772478874; c=relaxed/simple;
	bh=fFDjbzQSB9XtQHzqU10kxCoVxNcp9uM4c+YvBs9ZhlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aJhro4J31JRqkDAAtSZN4UrcsbLppX3oezH9/7jP5nufQX86aD1OedTkwJieWzSPmjoj44CVgnWwr77fG3BR25+B+2PJNSNAzAXKFkIi4PNCGSVusDANceldLe1bGSNXn8OIENY5qDHYV7zTat/wY4qeTwBdD29IKI5Y47CBenE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hWP/dQip; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hWP/dQip"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40357C19425;
	Mon,  2 Mar 2026 19:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772478874;
	bh=fFDjbzQSB9XtQHzqU10kxCoVxNcp9uM4c+YvBs9ZhlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hWP/dQipIRxAY+GJ2m/uU6alZOvnIgH/bEFHR1CNTMHyJxhl6xUnMJYzc5BaROTcB
	 IUaFe4WBAUEnh1kCa7n4DKWDWc5zg6xZCMbr2Iitg16JjFPK5+gsK8ekx/27WBqkdE
	 u9pC8GyB18eO27iRjo/+n7CSTXRknvnBdvAKSPGbILB+p94z3rwmvWyvrBfX+k+F2c
	 jVy41AQyTHEFDjeI50OT527JW5+PQfnWdjBPwh+vmfgLKs/sl/BvB4uHxo2lo0EPrw
	 28WyQ2LReUrYRFRfDgvaM0Nfw0dwoko1qLzgXlrO5nNQZZ/AJiQj3NR8uPfd9Ypgde
	 QH9nRRl6ozmyw==
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
Subject: [PATCH 02/11] x86/snp: Keep the RMP table bookkeeping area mapped
Date: Mon,  2 Mar 2026 12:13:25 -0700
Message-ID: <20260302191334.937981-3-tycho@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260302191334.937981-1-tycho@kernel.org>
References: <20260302191334.937981-1-tycho@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tom Lendacky <thomas.lendacky@amd.com>

In prep for delayed SNP initialization and disablement on shutdown, the
RMP will need to be cleared each time SNP is disabled. Maintain the
the mapping to the RMP bookkeeping area to avoid mapping and unmapping it
each time and any possible errors that may arise from that.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
---
 arch/x86/virt/svm/sev.c | 40 +++++++++++++++++-----------------------
 1 file changed, 17 insertions(+), 23 deletions(-)

diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 1446011c6337..232a385f11cb 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -117,6 +117,8 @@ static u64 rmp_segment_mask;
 
 static u64 rmp_cfg;
 
+static void *rmp_bookkeeping __ro_after_init;
+
 /* Mask to apply to a PFN to get the first PFN of a 2MB page */
 #define PFN_PMD_MASK	GENMASK_ULL(63, PMD_SHIFT - PAGE_SHIFT)
 
@@ -246,23 +248,6 @@ void __init snp_fixup_e820_tables(void)
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
@@ -480,10 +465,22 @@ static bool __init setup_segmented_rmptable(void)
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
@@ -514,10 +511,7 @@ int __init snp_rmptable_init(void)
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

