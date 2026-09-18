Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4F93AC0DE;
	Fri, 18 Sep 2026 22:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789770261; cv=none; b=ayXVKNk6O638vVasKaS384YfZ6Cpr2IEXjDzTieML/vJ2M0wu/BnkOGeGX7Hu0Yj7kgiLLrrIT9QkI3ucZJVOjpKOQ5UZ93EOnlyT79VyQtEJ/2YndG+tyorSLCeP5BTuZ76M5g450RLKZAarkK2gsFiLvVr7YoOnPJWrAtb/Z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789770261; c=relaxed/simple;
	bh=ycFJ1PRHzy0obJINie/K+YhsAOHo3J6GoleCY5EBl8M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JsRrgufrt6Y5Tv0FQ9FzxnlC0NeFrJjI3uC5pvNWh0S1KZ420nSgkrLCALa+kyAzhPpURlNZ6SFigJtVARkBfld3qQzAk2rPMka6IpGceEuFi+iUKWw33U67cdbIh7/ycS50BzlpXFRibK3TbPLFrRAwtsm/LqhGL3jkJlXmpc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=e5DgYtZD; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="e5DgYtZD"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 83EAB40E00E5;
	Fri, 18 Sep 2026 22:24:14 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 4YZYiPJ9gyOy; Fri, 18 Sep 2026 22:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1789770243; bh=2h3eDBdrSJuj4drNxGGe1s5X52AsdYMPIS8ImcRjdKw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=e5DgYtZD5JyIUwLrkX1y5zxBtJEEt+JhIxnzCTSVxrfBg41mWKN8E+ashLykdIUSH
	 tU/PP42NeksBx+afNG9jG7rizgpqevvYKZdvI1vK6W8TfHpOKMq9eXbcUsT4rxSdDk
	 BfKX/6xNWCU2hNQvhvKmda89qwRXVSfHGPOm4ZnNnM5eylZUtVxeRRDhzuLEfj1qfv
	 7FPrMk+fWiX8px7fX6isLe9cH4mFCacwAywukE4GKzrSP/ugULjevverctSNvW9w+w
	 UwsOFfKTH8T9HqQ31WO8/P/wVWNTXZ3sZKKHMw+jtTxgeoMQ00v2d2FNqKrsszxips
	 1CYcKHfWeu18XQr7OhdoZm30p8vtaQgi8o5+L0fNAuUgzjQG8xHRIxnPM1x6x6I3UQ
	 Sx0uR2YkT1npGgfC1w9SRNX/X/vURLVqYLbX8tlegu89xMnZe1zpoXN0IYfh36FVNG
	 mJAZFJjVW3aM3vdKLmDkbwhyMR28seQzlJ/SHkbaHtXbZfzhLoTnB1FASx/fPbXtej
	 mvPu5Wt2O/ykU7itKuXIODZmcVCFiHGI7I+/n3tqBhrXNg/yazzHaDzGwtvCWhTWr1
	 /5Yh1eZG/o4Ew3/k5Gv+TviQHKhXmeZd+bVfahtkLeIMbwOHr9CXZvncpUPJgQZECK
	 +FS2qg/1Dy208qejJ9tzRpXg=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::48])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id C962D40E01DD;
	Fri, 18 Sep 2026 22:23:29 +0000 (UTC)
Date: Fri, 18 Sep 2026 15:23:26 -0700
From: Borislav Petkov <bp@alien8.de>
To: Ashish Kalra <Ashish.Kalra@amd.com>
Cc: tglx@kernel.org, mingo@redhat.com, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, seanjc@google.com,
	peterz@infradead.org, thomas.lendacky@amd.com,
	herbert@gondor.apana.org.au, davem@davemloft.net, ardb@kernel.org,
	pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
	KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com,
	Nathan.Fontenot@amd.com, ackerleytng@google.com, jackyli@google.com,
	pgonda@google.com, rientjes@google.com, jacobhxu@google.com,
	xin@zytor.com, pawan.kumar.gupta@linux.intel.com,
	babu.moger@amd.com, dyoung@redhat.com, nikunj@amd.com,
	darwi@linutronix.de, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, kvm@vger.kernel.org,
	linux-coco@lists.linux.dev
Subject: Re: [PATCH v16 4/5] x86/sev: Perform RMP optimizations asynchronously
Message-ID: <20260918222326.GBaq253l7rsV04EUpy@fat_crate.local>
References: <cover.1789594774.git.ashish.kalra@amd.com>
 <daa513fbe8f0672b00bc5e026e4399244be6dc72.1789594774.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <daa513fbe8f0672b00bc5e026e4399244be6dc72.1789594774.git.ashish.kalra@amd.com>

On Wed, Sep 16, 2026 at 10:15:14PM +0000, Ashish Kalra wrote:
> Changes in v15:
> - Move the workqueue allocation and the (fixed) optimization range
>   computation to an initcall; snp_enable_rmpopt() now only programs the
>   RMPOPT_BASE MSRs and queues the optimization pass.
> - Gate rmpopt_capable() on a static rmpopt_enabled bool set when the
>   workqueue is allocated, instead of an if (rmpopt_wq) check, and drop
>   rmpopt_wq_mutex.
> - Queue both the initial and the teardown pass with mod_delayed_work().
>  arch/x86/virt/svm/sev.c | 99 +++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 95 insertions(+), 4 deletions(-)

Some scrubbing to this one too:

Author: Ashish Kalra <ashish.kalra@amd.com>
Date:   Wed Sep 16 22:15:14 2026 +0000

    x86/sev: Perform RMP optimizations asynchronously
    
    When SNP is enabled, all writes to memory are checked to ensure memory
    integrity. This imposes performance overhead on the whole system.
    
    RMPOPT is a new instruction that minimizes the performance overhead of
    RMP checks on the hypervisor and on non-SNP guests by allowing such checks to
    be skipped for 1GB regions of memory that are known not to contain any SNP
    guest memory.
    
    Add support for performing RMP optimizations asynchronously using a dedicated
    per-CPU workqueue.  Shortly after SNP initialization, run an optimization pass
    over all physical memory.
    
    As SNP guests are launched, RMPUPDATE assigns their private pages to
    guest-owned state; when such a page falls within an optimized 1GB region, the
    hardware clears that region's RMPOPT optimization and RMP checks resume there
    to protect the guest memory.
    
    Since launching SNP guests clears these optimizations, perform them again
    asynchronously using the dedicated workqueue.
    
      [ bp:
       - Massage commit message and comments
       - simplify code
       - redo some of the logic ]
    
    Suggested-by: Thomas Lendacky <thomas.lendacky@amd.com>
    Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
    Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
    Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
    Link: https://patch.msgid.link/daa513fbe8f0672b00bc5e026e4399244be6dc72.1789594774.git.ashish.kalra@amd.com

diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 1fecd246ce5f..94754f2986d3 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -19,6 +19,7 @@
 #include <linux/iommu.h>
 #include <linux/amd-iommu.h>
 #include <linux/nospec.h>
+#include <linux/workqueue.h>
 
 #include <asm/sev.h>
 #include <asm/processor.h>
@@ -124,7 +125,27 @@ static void *rmp_bookkeeping __ro_after_init;
 
 static u64 probed_rmp_base, probed_rmp_size;
 
-static phys_addr_t rmpopt_pa_start;
+static u64 rmpopt_pa_start, rmpopt_pa_end;
+
+enum rmpopt_op_type {
+	RMPOPT_OP_VERIFY_AND_REPORT_STATUS,
+	RMPOPT_OP_REPORT_STATUS
+};
+
+static struct workqueue_struct *rmpopt_wq;
+static struct delayed_work rmpopt_delayed_work;
+
+/* Software RMPOPT facilities initialized */
+static bool rmpopt_soft_init;
+
+/*
+ * Delay, in milliseconds, before the RMP re-optimization pass runs after an
+ * SNP guest is torn down. This coalesces a burst of teardowns into a single
+ * scan and gives each guest's pages time to be converted back to the shared,
+ * hypervisor-owned state.  The 10 second value is a heuristic trading
+ * re-optimization latency against scanning too eagerly.
+ */
+#define RMPOPT_WORK_TIMEOUT	(10 * MSEC_PER_SEC)
 
 static LIST_HEAD(snp_leaked_pages_list);
 static DEFINE_SPINLOCK(snp_leaked_pages_list_lock);
@@ -565,6 +586,9 @@ void snp_shutdown(void)
 	if (syscfg & MSR_AMD64_SYSCFG_SNP_EN)
 		return;
 
+	if (rmpopt_soft_init)
+		cancel_delayed_work_sync(&rmpopt_delayed_work);
+
 	clear_rmp();
 	on_each_cpu(mfd_reconfigure, NULL, 1);
 
@@ -577,21 +601,80 @@ void snp_shutdown(void)
 }
 EXPORT_SYMBOL_FOR_MODULES(snp_shutdown, "ccp");
 
-static bool rmpopt_capable(void)
+/*
+ * RMPOPT optimizations skip RMP checks at 1GB granularity if this range of
+ * memory does not contain any SNP guest memory.
+ *
+ * @pa is a system physical address; RMPOPT operates on the containing 1GB.
+ */
+static void rmpopt(u64 pa)
 {
-	return cpu_feature_enabled(X86_FEATURE_RMPOPT) &&
-	       cc_platform_has(CC_ATTR_HOST_SEV_SNP);
+	enum rmpopt_op_type op = RMPOPT_OP_VERIFY_AND_REPORT_STATUS;
+	u64 pa_start = ALIGN_DOWN(pa, SZ_1G);
+
+	/* Supported by binutils 2.48+ */
+	asm volatile(".byte 0xf2, 0x0f, 0x01, 0xfc"
+		     :: "a" (pa_start), "c" (op)
+		     : "memory", "cc");
+}
+
+static void rmpopt_scan_range(void *arg)
+{
+	u64 pa;
+
+	for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G)
+		rmpopt(pa);
 }
 
+static void do_rmpopt_work(struct work_struct *work)
+{
+	/*
+	 * Warm up the RMPOPT cache on this pinned per-CPU worker with interrupts
+	 * enabled, so the IRQ-disabled fan-out below only issues cache-hit RMPOPTs.
+	 */
+	rmpopt_scan_range(NULL);
+
+	on_each_cpu_mask(cpu_primary_thread_mask, rmpopt_scan_range, NULL, true);
+}
+
+static int __init rmpopt_init(void)
+{
+	if (!cpu_feature_enabled(X86_FEATURE_RMPOPT))
+		return -ENODEV;
+
+	rmpopt_wq = alloc_workqueue("rmpopt_wq", WQ_PERCPU, 1);
+	if (!rmpopt_wq) {
+		pr_err("Failed to allocate RMPOPT workqueue\n");
+		return -ENOMEM;
+	}
+
+	INIT_DELAYED_WORK(&rmpopt_delayed_work, do_rmpopt_work);
+
+	/* The optimization range is fixed at boot; compute it once. */
+	rmpopt_pa_start = ALIGN_DOWN(PFN_PHYS(min_low_pfn), SZ_1G);
+	rmpopt_pa_end = ALIGN(PFN_PHYS(max_pfn), SZ_1G);
+	if ((rmpopt_pa_end - rmpopt_pa_start) > SZ_2T)
+		rmpopt_pa_end = rmpopt_pa_start + SZ_2T;
+
+	rmpopt_soft_init = true;
+
+	return 0;
+}
+device_initcall(rmpopt_init);
+
 void snp_enable_rmpopt(void)
 {
 	u64 base;
 	int cpu;
 
-	if (!rmpopt_capable())
+	if (!cpu_feature_enabled(X86_FEATURE_RMPOPT))
 		return;
 
-	rmpopt_pa_start = ALIGN_DOWN(PFN_PHYS(min_low_pfn), SZ_1G);
+	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
+		return;
+
+	if (!rmpopt_soft_init)
+		return;
 
 	/*
 	 * Per-CPU RMPOPT tables cover at most 2 TB.  Program each core's
@@ -602,6 +685,11 @@ void snp_enable_rmpopt(void)
 		for_each_cpu(cpu, cpu_primary_thread_mask)
 			wrmsrq_on_cpu(cpu, MSR_AMD64_RMPOPT_BASE,
 				      rmpopt_pa_start | MSR_AMD64_RMPOPT_ENABLE);
+
+	mod_delayed_work(rmpopt_wq, &rmpopt_delayed_work,
+			 msecs_to_jiffies(RMPOPT_WORK_TIMEOUT));
+
+	pr_info("RMPOPT optimizations enabled\n");
 }
 EXPORT_SYMBOL_FOR_MODULES(snp_enable_rmpopt, "ccp");
 


-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
