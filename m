Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A90F338925;
	Mon,  9 Mar 2026 18:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773079275; cv=none; b=NXFnl/LGAWSwirk749lwf61TSdhHjrBaVcfINNpgkMPuoIPznUuWXbAwNwAKj0nQrwjmquFAN94cBwJhT7gwdCh2yknxU4umwECkG3vUT9ZwEf0cvRgb4P9h1pvCYQyEbwb/Dpyaoq88HFeXsQbCEKbFc1AQvD58h7a3m7LhkKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773079275; c=relaxed/simple;
	bh=z1V7/CvNV0fc/gSHI53kaTC1XLix5Wdwxcqe0vVmlFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LvAOwDi/KFG4ejs5+mRNTQiaQ6PBBtGtQihY9PrI/LkHBFETLJ4pIbqlVZ1kDJQADy/ihftSyFpq+DTI9lgP0Jeo5clxfzqjkHY0lIGuWPtP/9Ixbe3YBIawhBCJmyCtS3mm+BiPCs4OGZN5maA8UbWCmiyTWdKgZ8dV/MPAtcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sdRaeRJV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sdRaeRJV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0CA7C2BC9E;
	Mon,  9 Mar 2026 18:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773079275;
	bh=z1V7/CvNV0fc/gSHI53kaTC1XLix5Wdwxcqe0vVmlFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sdRaeRJVOTmne3W8LRYSJjc891zlKZ61moM4mB2jLFwvKCbigR6TKqoA0y4U/vioo
	 0hOAUdDiGN07dW9KmmBNYAtR0cj7w/dl5SHmBQjTwlOkoIwY1T0FwLH3XdjkoyDJ7B
	 XXJNqnohKbydLF8pYVEElQVEWkH5mRtpeAQMCCbKqalgmytgMwbrAwYQdxOlxwLUfy
	 jEh5JG6z0GP86jkHoXthYicajXDwnt0cQdB17PrWOhmBp1ynMqx3QjyEZemPT7KVxS
	 ku0RPLoD+/gIPp3Yo1xYg3wCMf0piXMRMtffEO9tRF0dRl3yW39/IlzTItGQm6rfAa
	 x3OT0kyYmeGfg==
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
Subject: [PATCH v2 01/10] x86/snp: drop support for SNP hotplug
Date: Mon,  9 Mar 2026 12:00:43 -0600
Message-ID: <20260309180053.2389118-2-tycho@kernel.org>
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

From: "Tycho Andersen (AMD)" <tycho@kernel.org>

During an SNP_INIT(_EX), the SEV firmware checks that all CPUs have the SNP
syscfg bit set, and fails if they do not. As such, it does not make
sense to have offline CPUs: the firmware will fail initialization because
of the offlined ones that the kernel did not initialize.

Futher, there is a bug: during SNP_INIT(_EX) the firmware requires the MFDM
syscfg bit to be set in addition to having SNP enabled, which the previous
hotplug code did not do. Since k8_check_syscfg_dram_mod_en() enforces this
be cleared, hotplug wouldn't work.

Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/virt/svm/sev.c | 32 +++++---------------------------
 1 file changed, 5 insertions(+), 27 deletions(-)

diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index a4f3a364fb65..f404c609582c 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -130,33 +130,20 @@ static unsigned long snp_nr_leaked_pages;
 #undef pr_fmt
 #define pr_fmt(fmt)	"SEV-SNP: " fmt
 
-static int __mfd_enable(unsigned int cpu)
+static __init void mfd_enable(void *arg)
 {
-	u64 val;
-
 	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
-		return 0;
-
-	rdmsrq(MSR_AMD64_SYSCFG, val);
-
-	val |= MSR_AMD64_SYSCFG_MFDM;
-
-	wrmsrq(MSR_AMD64_SYSCFG, val);
+		return;
 
-	return 0;
+	msr_set_bit(MSR_AMD64_SYSCFG, MSR_AMD64_SYSCFG_MFDM_BIT);
 }
 
-static __init void mfd_enable(void *arg)
-{
-	__mfd_enable(smp_processor_id());
-}
-
-static int __snp_enable(unsigned int cpu)
+static __init void snp_enable(void *arg)
 {
 	u64 val;
 
 	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
-		return 0;
+		return;
 
 	rdmsrq(MSR_AMD64_SYSCFG, val);
 
@@ -164,13 +151,6 @@ static int __snp_enable(unsigned int cpu)
 	val |= MSR_AMD64_SYSCFG_SNP_VMPL_EN;
 
 	wrmsrq(MSR_AMD64_SYSCFG, val);
-
-	return 0;
-}
-
-static __init void snp_enable(void *arg)
-{
-	__snp_enable(smp_processor_id());
 }
 
 static void __init __snp_fixup_e820_tables(u64 pa)
@@ -553,8 +533,6 @@ int __init snp_rmptable_init(void)
 	on_each_cpu(snp_enable, NULL, 1);
 
 skip_enable:
-	cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "x86/rmptable_init:online", __snp_enable, NULL);
-
 	/*
 	 * Setting crash_kexec_post_notifiers to 'true' to ensure that SNP panic
 	 * notifier is invoked to do SNP IOMMU shutdown before kdump.
-- 
2.53.0

