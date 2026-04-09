Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D23E133D4EC;
	Thu,  9 Apr 2026 19:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775764582; cv=none; b=krRMZ8jVARuxk/Jfmuzl9WBGTMf/43KumDInEOjgn6V3NsY1QWUru9kygXEW6fMIS8QVb9uWO1ZVqOL9KlvvZiMaGxR8jTsX3QK/ZkIwHEzq1njEWT/mFa29ibcfVK3xiQI4E7RLLFc3d5948GIBO6bRIe0Wh5m5TV8ny7hinZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775764582; c=relaxed/simple;
	bh=rCqi6vQv9Me+wTUELzy67PDJCYo31sK7SZuE6K2LtBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZnUQQ+mVO4oOaSA/DyBHpZ5yu4IIlg3N2lg75G56tPh04PCIWy7BBt65PPYSpS3BQRdR/zSsjrqH1l5uMkWoeplvXLxbLikLijcBgNuSqC3z5sULh5OhQfWWEfYmliDQYxeXY8C2Iq6nywZA4wY5bdAFjKgO7ZCKRmnypAKinCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GfDb21CO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GfDb21CO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07623C19424;
	Thu,  9 Apr 2026 19:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775764582;
	bh=rCqi6vQv9Me+wTUELzy67PDJCYo31sK7SZuE6K2LtBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GfDb21CO08n90pItVr8ybUfTRqfRJEZJpPnU6D9FK/yIch5v20GyeHP/MiYS3akT8
	 c6+p5wvjjObuuTJE/s2wL2VJbm6QOpg927El3yGGAxfjLPoySJcy9z+4hIE2IjqkyY
	 fygesqYNUvfmWJw2REjSQvfWYN5GGHFz2CppZ70wVESjknFhDXDwrkIPQ3AbrCs1gX
	 GhcSu3jexq7k0kNu2KyixjN+VTCQ6fPND4CPgSTI875Fm3f7khxQ7R1n1YfCusureL
	 8/L6CRwdi+VFhibsdpIigQZdYDBqas5J+j9XqelLXd3PEKrxO7bFogcWRwiScmn5AG
	 uFMio83a6igvg==
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
	linux-crypto@vger.kernel.org,
	"Tycho Andersen (AMD)" <tycho@kernel.org>,
	Tom Lendacky <thomas.lendacky@gmail.com>
Subject: [PATCH v3 1/2] x86/sev: Do not initialize SNP if missing CPUs
Date: Thu,  9 Apr 2026 13:56:01 -0600
Message-ID: <20260409195602.851513-2-tycho@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260409195602.851513-1-tycho@kernel.org>
References: <20260409195602.851513-1-tycho@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Tycho Andersen (AMD)" <tycho@kernel.org>

The SEV firmware checks that the SNP enable bit is set on each CPU during
SNP initialization, and will fail if it is not. If there are some CPUs
offline, they will not run the setup functions, so SNP initialization will
always fail.

Skip the IPIs in this case and return an error so that the CCP driver can
skip the SNP_INIT that will fail. Also print the CPU masks as a breadcrumb
so people can figure out what happened.

Suggested-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
Reviewed-by: Nikunj A Dadhania <nikunj@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@gmail.com>
---
 arch/x86/include/asm/sev.h |  4 ++--
 arch/x86/virt/svm/sev.c    | 18 ++++++++++++++++--
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 09e605c85de4..594cfa19cbd4 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -661,7 +661,7 @@ static inline void snp_leak_pages(u64 pfn, unsigned int pages)
 {
 	__snp_leak_pages(pfn, pages, true);
 }
-void snp_prepare(void);
+int snp_prepare(void);
 void snp_shutdown(void);
 #else
 static inline bool snp_probe_rmptable_info(void) { return false; }
@@ -679,7 +679,7 @@ static inline void __snp_leak_pages(u64 pfn, unsigned int npages, bool dump_rmp)
 static inline void snp_leak_pages(u64 pfn, unsigned int npages) {}
 static inline void kdump_sev_callback(void) { }
 static inline void snp_fixup_e820_tables(void) {}
-static inline void snp_prepare(void) {}
+static inline int snp_prepare(void) { return -ENODEV; }
 static inline void snp_shutdown(void) {}
 #endif
 
diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 41f76f15caa1..95e5127816dc 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -511,8 +511,9 @@ static void clear_hsave_pa(void *arg)
 	wrmsrq(MSR_VM_HSAVE_PA, 0);
 }
 
-void snp_prepare(void)
+int snp_prepare(void)
 {
+	int ret;
 	u64 val;
 
 	/*
@@ -521,12 +522,20 @@ void snp_prepare(void)
 	 */
 	rdmsrq(MSR_AMD64_SYSCFG, val);
 	if (val & MSR_AMD64_SYSCFG_SNP_EN)
-		return;
+		return 0;
 
 	clear_rmp();
 
 	cpus_read_lock();
 
+	if (!cpumask_equal(cpu_online_mask, cpu_present_mask)) {
+		ret = -EOPNOTSUPP;
+		pr_warn("Skipping SNP initialization. CPUs online %*pbl, present %*pbl\n",
+			cpumask_pr_args(cpu_online_mask),
+			cpumask_pr_args(cpu_present_mask));
+		goto unlock;
+	}
+
 	/*
 	 * MtrrFixDramModEn is not shared between threads on a core,
 	 * therefore it must be set on all CPUs prior to enabling SNP.
@@ -537,7 +546,12 @@ void snp_prepare(void)
 	/* SNP_INIT requires MSR_VM_HSAVE_PA to be cleared on all CPUs. */
 	on_each_cpu(clear_hsave_pa, NULL, 1);
 
+	ret = 0;
+
+unlock:
 	cpus_read_unlock();
+
+	return ret;
 }
 EXPORT_SYMBOL_FOR_MODULES(snp_prepare, "ccp");
 
-- 
2.53.0

