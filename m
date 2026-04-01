Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A1422DA765;
	Wed,  1 Apr 2026 14:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775054291; cv=none; b=heDpDnPDR3ckr3kBUeQHrBfLVr8TUNJWgthqrOYRMf7HaFGNMan+xNJpjZAAWD9mMdIO2Ty9vi9H6UQl6bn3ikN3EPORN9q4jQTSXzpEUDS9w2pbviOaoUc27eYaCBb81682HpMB2G5gcdVHsoKqnWcantUVzXmxLEvNiR35Ofw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775054291; c=relaxed/simple;
	bh=XAbFxS6dIsoB+vJMxVqDhwktDJ77oSl0nf+NrQHhmeo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nhgJaQfVsjjf/Zu0kDtuucFwWhqjBvdYwIWXnw6o46Vq7oks8wpS5WNJ+YWqbktHDwNWP4sIHXLpCXA4supD4hiib//YRw+i8rUh2MI6dZ/jh0IhZUk7S9czP8gdPhd6HfNq1jYlXWKyq5qGXKtW5gwJGaObyblHATW8fLQ/Le4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lldep2b2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lldep2b2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2E82C4CEF7;
	Wed,  1 Apr 2026 14:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775054291;
	bh=XAbFxS6dIsoB+vJMxVqDhwktDJ77oSl0nf+NrQHhmeo=;
	h=From:To:Cc:Subject:Date:From;
	b=Lldep2b27Ps7IrIVqP+7BUuXdPl8tlsuWwqIpjqlyytSaWjJJteHwAr109Y/Du5qL
	 poCSixs/b2VhqQfU416glic48P4nONK7FtQh2P5E8sTtfneKCAcxr7kAJeMdciRqhE
	 kNCmSvZIxc3Z+RImvVutJvZ7BmJyXJnBx/XDxDtbVIto5zf6o5AjjKAGUXjpvXYW1l
	 m7BImWp6rbxGeyedLBrZpgN64ncRrzx+2w3GI/ZLyj54p1VhSvGkK8/D1HtY6XdmjW
	 CjGiAs85iac7DSVT3W/HORyuLAILQJ9D4oannU5mU4dr3de/kwCbGJwJ9GjSaGSdck
	 CU3JviYqIsjtg==
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
	"Tycho Andersen (AMD)" <tycho@kernel.org>
Subject: [PATCH v1 1/2] x86/sev: Do not initialize SNP if missing CPUs
Date: Wed,  1 Apr 2026 08:35:50 -0600
Message-ID: <20260401143552.3038979-1-tycho@kernel.org>
X-Mailer: git-send-email 2.53.0
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
skip the SNP_INIT that will fail.

Suggested-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
---
 arch/x86/include/asm/sev.h |  4 ++--
 arch/x86/virt/svm/sev.c    | 11 +++++++++--
 2 files changed, 11 insertions(+), 4 deletions(-)

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
index 41f76f15caa1..e9ded15dbe60 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -511,8 +511,9 @@ static void clear_hsave_pa(void *arg)
 	wrmsrq(MSR_VM_HSAVE_PA, 0);
 }
 
-void snp_prepare(void)
+int snp_prepare(void)
 {
+	int ret = -EOPNOTSUPP;
 	u64 val;
 
 	/*
@@ -521,12 +522,15 @@ void snp_prepare(void)
 	 */
 	rdmsrq(MSR_AMD64_SYSCFG, val);
 	if (val & MSR_AMD64_SYSCFG_SNP_EN)
-		return;
+		return 0;
 
 	clear_rmp();
 
 	cpus_read_lock();
 
+	if (!cpumask_equal(cpu_online_mask, cpu_possible_mask))
+		goto unlock;
+
 	/*
 	 * MtrrFixDramModEn is not shared between threads on a core,
 	 * therefore it must be set on all CPUs prior to enabling SNP.
@@ -537,7 +541,10 @@ void snp_prepare(void)
 	/* SNP_INIT requires MSR_VM_HSAVE_PA to be cleared on all CPUs. */
 	on_each_cpu(clear_hsave_pa, NULL, 1);
 
+	ret = 0;
+unlock:
 	cpus_read_unlock();
+	return ret;
 }
 EXPORT_SYMBOL_FOR_MODULES(snp_prepare, "ccp");
 

base-commit: cf112712c193e837225d740ec3e139774f2496f2
-- 
2.53.0

