Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F07103D3331;
	Tue, 24 Mar 2026 16:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774368805; cv=none; b=RDxW23E81X+6M6cZRwc4HMw+umgM+gXmUJsezO8NY0eEtFURM2T/8jbqRy90t0veHjY+uxiyKN0xttqKK84NyIRE6Q5uuqionEvz8RTPWWQ9iufsnq+c9dq5ftFsFSahgOIfwaNG7GC/6LqcJ8/GsLLIBboIUZyhz8kHKxYAiXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774368805; c=relaxed/simple;
	bh=C0cxEGO7pt7MEvBETiZvMxPEovrTI69gUhimZn73XMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X2STEepMkR0w/P3Q6uuF8kNVJiyUdcEnGD7aem74/xOP5BjK/ZXkYL+Ek3r+r5dNCqGTxvAzyzVhKcVqI8yr+5rHLFOqc3ybvWTcpQqdJ8TYkuPU+w97xcVwvHgQMGs6BwKpuQPXLiEOdym4whqePk3EEWCzP1l7wJX2irJSeYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jLCTnQNJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jLCTnQNJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91264C19424;
	Tue, 24 Mar 2026 16:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774368804;
	bh=C0cxEGO7pt7MEvBETiZvMxPEovrTI69gUhimZn73XMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jLCTnQNJPBAOJef4dOdpbbAypmUrud21smWgI0hNoIDyefBNT5v7dR3zfaja5pnGH
	 TIUOlBuA28OFL1qsZn4dqbTVAIb7yFWZ1I489GB28wA7bkZkKJeFQ9uHQ0MhceOdDH
	 UufiSxoP3omqtw4BX1JNRM+kf90dvrGWbHqigJZmtRlanwpmTVysVrXqr79bTPAcbw
	 X7lJqmGMRGUoqCsBb+S887nHNN3JD//2/YNRshwUdsa6MKbr4kZKYvsiVERgasjs1s
	 B37LEe0Zgk/AlKZeEv90Miu52b/8FJ0u804ADGKAbgq+Gz/vgqbXhiOxSFlLl6hrh3
	 MqyjyMFHRzxYA==
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
Subject: [PATCH v4 2/7] x86/sev: Create snp_prepare()
Date: Tue, 24 Mar 2026 10:12:56 -0600
Message-ID: <20260324161301.1353976-3-tycho@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260324161301.1353976-1-tycho@kernel.org>
References: <20260324161301.1353976-1-tycho@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Tycho Andersen (AMD)" <tycho@kernel.org>

In preparation for delayed SNP initialization, create a function
snp_prepare() that does the necessary architecture setup.
Export this function for the ccp module to allow it to do the setup as
necessary.

Also move {mfd,snp}_enable out of the __init section, since these will be
called later.

Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/asm/sev.h |  2 ++
 arch/x86/virt/svm/sev.c    | 46 ++++++++++++++++++++++----------------
 2 files changed, 29 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 0e6c0940100f..2140e26dec6c 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -661,6 +661,7 @@ static inline void snp_leak_pages(u64 pfn, unsigned int pages)
 {
 	__snp_leak_pages(pfn, pages, true);
 }
+void snp_prepare(void);
 #else
 static inline bool snp_probe_rmptable_info(void) { return false; }
 static inline int snp_rmptable_init(void) { return -ENOSYS; }
@@ -677,6 +678,7 @@ static inline void __snp_leak_pages(u64 pfn, unsigned int npages, bool dump_rmp)
 static inline void snp_leak_pages(u64 pfn, unsigned int npages) {}
 static inline void kdump_sev_callback(void) { }
 static inline void snp_fixup_e820_tables(void) {}
+static inline void snp_prepare(void) {}
 #endif
 
 #endif
diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 025606969823..6f4c3f6e2082 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -132,7 +132,7 @@ static unsigned long snp_nr_leaked_pages;
 #undef pr_fmt
 #define pr_fmt(fmt)	"SEV-SNP: " fmt
 
-static __init void mfd_enable(void *arg)
+static void mfd_enable(void *arg)
 {
 	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
 		return;
@@ -140,7 +140,7 @@ static __init void mfd_enable(void *arg)
 	msr_set_bit(MSR_AMD64_SYSCFG, MSR_AMD64_SYSCFG_MFDM_BIT);
 }
 
-static __init void snp_enable(void *arg)
+static void snp_enable(void *arg)
 {
 	u64 val;
 
@@ -503,6 +503,30 @@ static bool __init setup_rmptable(void)
 	return true;
 }
 
+void snp_prepare(void)
+{
+	u64 val;
+
+	/*
+	 * Check if SEV-SNP is already enabled, this can happen in case of
+	 * kexec boot.
+	 */
+	rdmsrq(MSR_AMD64_SYSCFG, val);
+	if (val & MSR_AMD64_SYSCFG_SNP_EN)
+		return;
+
+	clear_rmp();
+
+	/*
+	 * MtrrFixDramModEn is not shared between threads on a core,
+	 * therefore it must be set on all CPUs prior to enabling SNP.
+	 */
+	on_each_cpu(mfd_enable, NULL, 1);
+
+	on_each_cpu(snp_enable, NULL, 1);
+}
+EXPORT_SYMBOL_FOR_MODULES(snp_prepare, "ccp");
+
 /*
  * Do the necessary preparations which are verified by the firmware as
  * described in the SNP_INIT_EX firmware command description in the SNP
@@ -510,8 +534,6 @@ static bool __init setup_rmptable(void)
  */
 int __init snp_rmptable_init(void)
 {
-	u64 val;
-
 	if (WARN_ON_ONCE(!cc_platform_has(CC_ATTR_HOST_SEV_SNP)))
 		return -ENOSYS;
 
@@ -521,22 +543,8 @@ int __init snp_rmptable_init(void)
 	if (!setup_rmptable())
 		return -ENOSYS;
 
-	/*
-	 * Check if SEV-SNP is already enabled, this can happen in case of
-	 * kexec boot.
-	 */
-	rdmsrq(MSR_AMD64_SYSCFG, val);
-	if (val & MSR_AMD64_SYSCFG_SNP_EN)
-		goto skip_enable;
-
-	clear_rmp();
-
-	/* MtrrFixDramModEn must be enabled on all the CPUs prior to enabling SNP. */
-	on_each_cpu(mfd_enable, NULL, 1);
-
-	on_each_cpu(snp_enable, NULL, 1);
+	snp_prepare();
 
-skip_enable:
 	/*
 	 * Setting crash_kexec_post_notifiers to 'true' to ensure that SNP panic
 	 * notifier is invoked to do SNP IOMMU shutdown before kdump.
-- 
2.53.0

