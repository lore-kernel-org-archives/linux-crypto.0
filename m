Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB8B7375AA3;
	Mon,  2 Mar 2026 19:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772478881; cv=none; b=oSH+DAuUMhZRWfwvsfRCIii/+Vy8C4BZWxWxaT2VfSvx1cy6YACX0Sn8GMtuSURsHd6MJaxZEwdZs8BojXhxlWpDy9/u/uwL032rKJGk/JyHxkUlujX+kqSwuBM1PHMREQ5E0yPe8dWYXKPFnRFSLC565OH4q6rQup7YyJs7k2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772478881; c=relaxed/simple;
	bh=QJxRtbkiC5rPJpKBs/xYtXpiY4rVpiXxaROoLldlmQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U6PsV3Hdnaencp4S9VSPPZN6D1TTJl6CNey7HRM4Bhpw/Cl4sDvu5j8YmGGCjVzgRAKpS6h1mGbOahgTPkDJJk9Tu9JzignU62wU//1AORGvOjYJ06EfY3GgEc1gbEP9k2JbspqlMAgvbI9NZG+icWOg7ns54oXKJJ+UhLr3dHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DBnwwcQm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DBnwwcQm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99BB6C4AF09;
	Mon,  2 Mar 2026 19:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772478881;
	bh=QJxRtbkiC5rPJpKBs/xYtXpiY4rVpiXxaROoLldlmQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DBnwwcQmkjQgG8rQh9UNx2cNPubvSk2SHrDigyFawO2f/i66AZy6e2IBgoWLtHV5P
	 lZRVNNsrD8dpxqRVHJsXDwmvGAe1PsuqugOYTgb57qBhCBpFg7ForjNNJXQ37ERHAC
	 NKeEguxKNe56Fv4ac239/WOAsspNGbMUAzx3UVSoXZ6+oMtSAxK8vx+bvpAuiwWhMZ
	 tnonQ4r7ei+w8R43QXc9Byp8aRVYfFb1rBUo8z7O/SBrx52G1BKi6NgVVD721LseOP
	 4JvXapazmwa4pekK5ajHuQD0gdk2kuV4JtOg1z2LOVMXqefblb7eJ106hiObJFAWZ5
	 nbIp6lykIHa3g==
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
Subject: [PATCH 05/11] x86/snp: create snp_prepare_for_snp_init()
Date: Mon,  2 Mar 2026 12:13:28 -0700
Message-ID: <20260302191334.937981-6-tycho@kernel.org>
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

From: "Tycho Andersen (AMD)" <tycho@kernel.org>

In preparation for delayed SNP initialization, create a function
snp_prepare_for_snp_init() that does the necessary architecture setup.
Export this function for the ccp module to allow it to do the setup as
necessary.

Also move {mfd,snp}_enable out of the __init section, since these will be
called later.

Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
---
 arch/x86/include/asm/sev.h |  2 ++
 arch/x86/virt/svm/sev.c    | 46 ++++++++++++++++++++++----------------
 2 files changed, 29 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 0e6c0940100f..0bcd89d4fe90 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -661,6 +661,7 @@ static inline void snp_leak_pages(u64 pfn, unsigned int pages)
 {
 	__snp_leak_pages(pfn, pages, true);
 }
+void snp_prepare_for_snp_init(void);
 #else
 static inline bool snp_probe_rmptable_info(void) { return false; }
 static inline int snp_rmptable_init(void) { return -ENOSYS; }
@@ -677,6 +678,7 @@ static inline void __snp_leak_pages(u64 pfn, unsigned int npages, bool dump_rmp)
 static inline void snp_leak_pages(u64 pfn, unsigned int npages) {}
 static inline void kdump_sev_callback(void) { }
 static inline void snp_fixup_e820_tables(void) {}
+static inline void snp_prepare_for_snp_init(void) {}
 #endif
 
 #endif
diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 258e67ba7415..8f50538baf7b 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -132,7 +132,7 @@ static unsigned long snp_nr_leaked_pages;
 #undef pr_fmt
 #define pr_fmt(fmt)	"SEV-SNP: " fmt
 
-static __init void mfd_enable(void *arg)
+static void mfd_enable(void *arg)
 {
 	u64 val;
 
@@ -146,7 +146,7 @@ static __init void mfd_enable(void *arg)
 	wrmsrq(MSR_AMD64_SYSCFG, val);
 }
 
-static __init void snp_enable(void *arg)
+static void snp_enable(void *arg)
 {
 	u64 val;
 
@@ -509,6 +509,30 @@ static bool __init setup_rmptable(void)
 	return true;
 }
 
+void snp_prepare_for_snp_init(void)
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
+	snp_clear_rmp();
+
+	/*
+	 * MtrrFixDramModEn is not shared between threads on a core,
+	 * therefore it must be set on all CPUs prior to enabling SNP.
+	 */
+	on_each_cpu(mfd_enable, NULL, 1);
+
+	on_each_cpu(snp_enable, NULL, 1);
+}
+EXPORT_SYMBOL_FOR_MODULES(snp_prepare_for_snp_init, "ccp");
+
 /*
  * Do the necessary preparations which are verified by the firmware as
  * described in the SNP_INIT_EX firmware command description in the SNP
@@ -516,8 +540,6 @@ static bool __init setup_rmptable(void)
  */
 int __init snp_rmptable_init(void)
 {
-	u64 val;
-
 	if (WARN_ON_ONCE(!cc_platform_has(CC_ATTR_HOST_SEV_SNP)))
 		return -ENOSYS;
 
@@ -527,22 +549,8 @@ int __init snp_rmptable_init(void)
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
-	snp_clear_rmp();
-
-	/* MtrrFixDramModEn must be enabled on all the CPUs prior to enabling SNP. */
-	on_each_cpu(mfd_enable, NULL, 1);
-
-	on_each_cpu(snp_enable, NULL, 1);
+	snp_prepare_for_snp_init();
 
-skip_enable:
 	/*
 	 * Setting crash_kexec_post_notifiers to 'true' to ensure that SNP panic
 	 * notifier is invoked to do SNP IOMMU shutdown before kdump.
-- 
2.53.0

