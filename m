Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EAF2407107;
	Thu, 26 Mar 2026 16:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774541498; cv=none; b=gDXzXbz9pLPgh/8bXooe80Imm1qRxKfY0lb9NngdbnbPljKpUSVMq6wkdbfLo+LKgCXGBPJuSna61/5IUdJKVjg3m2BmEwiasCxhBeIuYoKOhh/8stNkSjg5GzskaHl6mopib9wFD7mLQkeGlcLRb4p+WCHun/SgNXupRNgOBDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774541498; c=relaxed/simple;
	bh=mMAdAHz77n5yl3EsaqAxdFRluO1dNlUpwyqCCq2Be9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hveldr9L8k5uNNrsH8Rm/Zi9wsWGZP2Wj0pLoLekDQTix/yy09ygGUS1ZvNdSVAsYtqcMe0xTdmG8bS3DwtYVGt15iT9V7muvZzaa1r30YKGW3OAOQ/KIP7g9dwkSGJeURAIVhPuvd0IEwteORJWb3+abDhc1I8zl/5m60DatiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FkzBdzbD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FkzBdzbD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C459FC116C6;
	Thu, 26 Mar 2026 16:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774541498;
	bh=mMAdAHz77n5yl3EsaqAxdFRluO1dNlUpwyqCCq2Be9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FkzBdzbDmk+l9xE7W8T87MoBy/5aiKoDZgNYFSisAr/0mMgBTXlTwFurLqig+mNJT
	 Y+ZV+HomOixonASYj0P8yq8M7B6wIyWYLRl11B9pDK62ol7z13YPh5/tBPg7Xy/6Fz
	 Anu82ahrWXYplv4tkWpl5ti7uje7u8PyvU9FXSMHpnRSRbvZzIytXohL2J8KW8PHjx
	 mVk4LvR59zcXRxeGbev37Id748/zpZInhl0od9IDo2kWnsDtwYHUZJiFidjc32H8RL
	 DxbISoYV/gSjy0ul05RCzoIw0Qk/5VDinr2NP3kGic/O2BpUplI6J1/Luzjw9UX/7G
	 qIEqWqUqS1b1A==
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
Subject: [PATCH v5 2/7] x86/sev: Create snp_prepare()
Date: Thu, 26 Mar 2026 10:11:05 -0600
Message-ID: <20260326161110.1764303-3-tycho@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260326161110.1764303-1-tycho@kernel.org>
References: <20260326161110.1764303-1-tycho@kernel.org>
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

Introduce a cpu_read_lock/unlock() wrapper around the MFDM and SNP enable.
While CPU hotplug is not supported, this makes sure that the bit setting
happens on the same set of CPUs in both cases. This improvement was
suggested by Sashiko:
https://sashiko.dev/#/patchset/20260324161301.1353976-1-tycho%40kernel.org

Also move {mfd,snp}_enable out of the __init section, since these will be
called later.

Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/asm/sev.h |  2 ++
 arch/x86/virt/svm/sev.c    | 49 +++++++++++++++++++++++---------------
 2 files changed, 32 insertions(+), 19 deletions(-)

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
index 025606969823..ccec52952573 100644
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
 
@@ -503,6 +503,33 @@ static bool __init setup_rmptable(void)
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
+	cpus_read_lock();
+
+	/*
+	 * MtrrFixDramModEn is not shared between threads on a core,
+	 * therefore it must be set on all CPUs prior to enabling SNP.
+	 */
+	on_each_cpu(mfd_enable, NULL, 1);
+	on_each_cpu(snp_enable, NULL, 1);
+
+	cpus_read_unlock();
+}
+EXPORT_SYMBOL_FOR_MODULES(snp_prepare, "ccp");
+
 /*
  * Do the necessary preparations which are verified by the firmware as
  * described in the SNP_INIT_EX firmware command description in the SNP
@@ -510,8 +537,6 @@ static bool __init setup_rmptable(void)
  */
 int __init snp_rmptable_init(void)
 {
-	u64 val;
-
 	if (WARN_ON_ONCE(!cc_platform_has(CC_ATTR_HOST_SEV_SNP)))
 		return -ENOSYS;
 
@@ -521,22 +546,8 @@ int __init snp_rmptable_init(void)
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

