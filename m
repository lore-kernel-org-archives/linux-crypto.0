Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A30E73451B5;
	Mon,  9 Mar 2026 18:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773079282; cv=none; b=Lej2BkIYrYXeOtcHyRxnTkXOLKeKq19Yk0or0rHdKLiHF0Rl2YMPmk0v+qglmxViPk6Vz6E4JZ5veMLSouzrIt95I9KoEI0GJeUAT7IdioFXSnXSx7+lagtV6MkrNaj/dnnbh631+F/sn4bSWrqRN7T98a3IkO+52Of2pty4hM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773079282; c=relaxed/simple;
	bh=GQScDmLliiJ2MTvHc5TZbOCnDLWhRNkUBAsHFpsWlP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OpvjeQNxbQGMgzh+xm8DTzJO/PWqpcGT9NLUdF2rU1eIct5yukbPSyeZVnc6o6i9an9WW+XLswbGMSKCFlc4/wKBhFe+AQYRqiTcu1/9Z7GTqvcgjMWFamTcccd0asKUz1u4xwgFYfFeBNwysHMq7/2jOXZyaNkMX49BxRDxTNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d6moQUcD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d6moQUcD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14F71C2BC9E;
	Mon,  9 Mar 2026 18:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773079282;
	bh=GQScDmLliiJ2MTvHc5TZbOCnDLWhRNkUBAsHFpsWlP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d6moQUcDLHXgrnKjnVIIltQebAaK2kQFve/zcLYlzHyz/gHFBaAFEjoy5zh2KoFJ9
	 dZA5/DrGYcoKtu7uWLKdn7LC9kD35LK7C1bGiDv3mSipx6PHl2xhTqofZ7T6cUHfCi
	 FAQX8zAI4ahBZUjCm/YdObJF76AokYf9zrYrEN5ml3hu8/wUd7LqjyGZ+Z8vMQQFVc
	 EV0y+RuB+/JadZu2gL6SYl1NrTsR5ngvgK0jYtx5Y4PuwNW67jcXsIbYLoxQzgohls
	 DrWtCg6Mgr0TbyULHUQrgBrLINb3b0g3/W5a0WFDOJaDBl1vcJN1thqwiiv5wwxSH1
	 YsEgsxfwYX28A==
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
Subject: [PATCH v2 04/10] x86/snp: Create a function to clear/zero the RMP
Date: Mon,  9 Mar 2026 12:00:46 -0600
Message-ID: <20260309180053.2389118-5-tycho@kernel.org>
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

In prep for delayed SNP initialization and disablement on shutdown, create
a function, snp_clear_rmp(), that clears the RMP bookkeeping area and the
RMP entries.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
---
 arch/x86/virt/svm/sev.c | 41 +++++++++++++++++++++++++++--------------
 1 file changed, 27 insertions(+), 14 deletions(-)

diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index e35fac0a8a3d..f41b92e40014 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -242,6 +242,32 @@ void __init snp_fixup_e820_tables(void)
 	}
 }
 
+static void snp_clear_rmp(void)
+{
+	unsigned int i;
+	u64 val;
+
+	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
+		return;
+
+	/* Clearing the RMP while SNP is enabled will cause an exception */
+	rdmsrq(MSR_AMD64_SYSCFG, val);
+	if (WARN_ON_ONCE(val & MSR_AMD64_SYSCFG_SNP_EN))
+		return;
+
+	memset(rmp_bookkeeping, 0, RMPTABLE_CPU_BOOKKEEPING_SZ);
+
+	for (i = 0; i < rst_max_index; i++) {
+		struct rmp_segment_desc *desc;
+
+		desc = rmp_segment_table[i];
+		if (!desc)
+			continue;
+
+		memset(desc->rmp_entry, 0, desc->size);
+	}
+}
+
 static bool __init alloc_rmp_segment_desc(u64 segment_pa, u64 segment_size, u64 pa)
 {
 	u64 rst_index, rmp_segment_size_max;
@@ -484,7 +510,6 @@ static bool __init setup_rmptable(void)
  */
 int __init snp_rmptable_init(void)
 {
-	unsigned int i;
 	u64 val;
 
 	if (WARN_ON_ONCE(!cc_platform_has(CC_ATTR_HOST_SEV_SNP)))
@@ -504,19 +529,7 @@ int __init snp_rmptable_init(void)
 	if (val & MSR_AMD64_SYSCFG_SNP_EN)
 		goto skip_enable;
 
-	/* Zero out the RMP bookkeeping area */
-	memset(rmp_bookkeeping, 0, RMPTABLE_CPU_BOOKKEEPING_SZ);
-
-	/* Zero out the RMP entries */
-	for (i = 0; i < rst_max_index; i++) {
-		struct rmp_segment_desc *desc;
-
-		desc = rmp_segment_table[i];
-		if (!desc)
-			continue;
-
-		memset(desc->rmp_entry, 0, desc->size);
-	}
+	snp_clear_rmp();
 
 	/* MtrrFixDramModEn must be enabled on all the CPUs prior to enabling SNP. */
 	on_each_cpu(mfd_enable, NULL, 1);
-- 
2.53.0

