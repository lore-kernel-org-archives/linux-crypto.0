Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE2051A140;
	Fri, 18 Sep 2026 18:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789754507; cv=none; b=MPRVh6l4HQyaxeEN9KWLm5WqCz8r2loXxEU0yk61S+newsEPxd/RM8gd7rIAVD4r8ylt43m6K8MvumnFHdXTGZfrnWZy+8BBuYlw5/zOMcc09wU2z2qaKC5ENbr8YuhNnKtGkx2ncYI1+hHksF5zXN5UzlkzTDCT1fcJFhaoxfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789754507; c=relaxed/simple;
	bh=OhEhLLsIoIfy5GHA41zX2jbBNoqjEV2J/4j8Ln8O36M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Uupnuq8D60lWMfkgRtIei2unpbB+xjcNm7FOVpy6c6jRCveuFj6Fkn41FAza4obXq3dqPZxhMRRkmq7YQfr+2u4k3Uq2e40kaWFIONgEEODCW5UfCNw8Ax1PDFM9+2lQfZsp2g1fApmE1YnCPQcewRO5TzynJ44Rs5xp91EmGGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=gqpaSw1N; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="gqpaSw1N"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 515F240E00E5;
	Fri, 18 Sep 2026 18:01:41 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id UWP2W9vP4TKJ; Fri, 18 Sep 2026 18:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1789754490; bh=To2NtLovobbsVi+zYzNAooWSosUMaxwE9+3unUn2R8I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gqpaSw1N8+80u3oWbbKLdEWMvW7Oubu2njowZa3TGpVsEdN4anqh8cFxVdGXGxz1t
	 2VPVF7fmWRKogVD15HKDjFh2P87wQjEb6KDjIzvK36syfdnJa8g+FTvAOJdsccWbP5
	 Pu7GP6sPbzKYOeRDkAOZ1+eA4kIJguYvabFTI2pduLVHksvaWnDyhsoK5gZbIfOML1
	 SRjHmgE0wtD+BU6dmf164CeklInFauRhozNmtnOqDQHtT8H1YrH/0sQ6OmXVPuuGRT
	 WRwClEdlq2Cn14dwDanPsGQjMi7AZkQxPEnzsQGSzruS07zWa1jR4zqPoBeOjnRGAs
	 kcLE8ClOn2OTF/RiLnKDua05Z3G+75hfAAG8bSJEH0s3G81l5N55xyl7hwWSuBsNBN
	 ZHDOu1tt3jPbn+OiQaUt4W9lnwL5uN0Y6iwQ+zCK5m/2a5Kro7G4AWuLNQqRoVwCm0
	 ou143zdnS7axg2AMMtG7ZigRLJmocLsvoahXisKtcR0DwqSsrGhs76pXhqPywd5r7d
	 j/CHPEdtGdWd5n9ZFbKUmJ4J1WTDz2BKHXKfNQrGYBhNDwexU/k0o6EIWrquUGcClG
	 BWcuWp92wzy7VSB6MqwciM6MmywREXPQN7Lce2RbbPbC5uBo9Dnq5RC9u9rf6r65uM
	 fCAtlUgJla1DDEJGW7k3gG3E=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::48])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 836F740E00B9;
	Fri, 18 Sep 2026 18:00:56 +0000 (UTC)
Date: Fri, 18 Sep 2026 11:00:53 -0700
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
Subject: Re: [PATCH v16 3/5] x86/sev: Initialize RMPOPT configuration MSRs
Message-ID: <20260918180053.GAaq18VQB9IOia1S-7@fat_crate.local>
References: <cover.1789594774.git.ashish.kalra@amd.com>
 <7fdf0f5b1be4b561c884c5200d6606a947cbc09d.1789594774.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7fdf0f5b1be4b561c884c5200d6606a947cbc09d.1789594774.git.ashish.kalra@amd.com>

On Wed, Sep 16, 2026 at 10:14:52PM +0000, Ashish Kalra wrote:
> Changes in v15:
> - Rename snp_setup_rmpopt() to snp_enable_rmpopt().
> - Program each core's RMPOPT_BASE only when it is not already set.
>  arch/x86/include/asm/msr-index.h |  3 ++
>  arch/x86/include/asm/sev.h       |  2 +
>  arch/x86/virt/svm/sev.c          | 66 +++++++++++++++++++++++++++++---
>  drivers/crypto/ccp/sev-dev.c     |  2 +
>  4 files changed, 68 insertions(+), 5 deletions(-)

Did some scrubbing:

commit 61132258c7a139a9533ae24b056a099184b70e50 (HEAD -> refs/heads/tip-x86-sev)
Author: Ashish Kalra <ashish.kalra@amd.com>
Date:   Wed Sep 16 22:14:52 2026 +0000

    x86/sev: Initialize RMPOPT configuration MSRs
    
    The new RMPOPT instruction helps manage per-CPU RMP optimization
    structures inside the CPU. It takes a 1GB-aligned physical address and
    either returns the status of the optimizations or tries to enable the
    optimizations.
    
    Initialize the per-CPU RMPOPT table base to the starting physical
    address.  This enables RMP optimization for up to 2 TB of system RAM on
    all CPUs because this is the maximum the RMPOPT tables support.
    
    The RMPOPT_BASE MSR can only be written after SNP is enabled, so the
    enabling runs from the ccp SNP init path (and again on guest teardown)
    rather than from an initcall. This is also in line with the intention to
    not enable SNP by default but enable it on demand, when the ccp module
    is loaded.
    
    RMPOPT_BASE is programmed on all primary threads.  RMPOPT_EN cannot be
    cleared while SNP is enabled, and CPU hotplug is disabled while SNP is
    active, so once programmed the MSRs stay set on all CPUs until SNP is
    disabled.  A set RMPOPT_EN on the local CPU therefore means the
    programming has already been done and thus it can be skipped.
    
      [ bp:
        - Massage commit message
        - move enabling logic into the commit message
        - zap unnecessary comments
        - cleanup ]
    
    Suggested-by: Thomas Lendacky <thomas.lendacky@amd.com>
    Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
    Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
    Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
    Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
    Link: https://patch.msgid.link/7fdf0f5b1be4b561c884c5200d6606a947cbc09d.1789594774.git.ashish.kalra@amd.com

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 3a8e51a0c9e8..1635e2e1c576 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -761,6 +761,9 @@
 #define MSR_AMD64_SEG_RMP_ENABLED_BIT	0
 #define MSR_AMD64_SEG_RMP_ENABLED	BIT_ULL(MSR_AMD64_SEG_RMP_ENABLED_BIT)
 #define MSR_AMD64_RMP_SEGMENT_SHIFT(x)	(((x) & GENMASK_ULL(13, 8)) >> 8)
+#define MSR_AMD64_RMPOPT_BASE		0xc0010139
+#define MSR_AMD64_RMPOPT_ENABLE_BIT	0
+#define MSR_AMD64_RMPOPT_ENABLE		BIT_ULL(MSR_AMD64_RMPOPT_ENABLE_BIT)
 
 #define MSR_SVSM_CAA			0xc001f000
 
diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 9e7a077c445d..fa81aa004e8b 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -662,6 +662,7 @@ static inline void snp_leak_pages(u64 pfn, unsigned int pages)
 	__snp_leak_pages(pfn, pages, true);
 }
 int snp_prepare(void);
+void snp_enable_rmpopt(void);
 void snp_shutdown(void);
 #else
 static inline bool snp_probe_rmptable_info(void) { return false; }
@@ -680,6 +681,7 @@ static inline void snp_leak_pages(u64 pfn, unsigned int npages) {}
 static inline void kdump_sev_callback(void) { }
 static inline void snp_fixup_e820_tables(void) {}
 static inline int snp_prepare(void) { return -ENODEV; }
+static inline void snp_enable_rmpopt(void) {}
 static inline void snp_shutdown(void) {}
 #endif
 
diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 558f7924a3f8..1fecd246ce5f 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -124,6 +124,8 @@ static void *rmp_bookkeeping __ro_after_init;
 
 static u64 probed_rmp_base, probed_rmp_size;
 
+static phys_addr_t rmpopt_pa_start;
+
 static LIST_HEAD(snp_leaked_pages_list);
 static DEFINE_SPINLOCK(snp_leaked_pages_list_lock);
 
@@ -575,6 +577,34 @@ void snp_shutdown(void)
 }
 EXPORT_SYMBOL_FOR_MODULES(snp_shutdown, "ccp");
 
+static bool rmpopt_capable(void)
+{
+	return cpu_feature_enabled(X86_FEATURE_RMPOPT) &&
+	       cc_platform_has(CC_ATTR_HOST_SEV_SNP);
+}
+
+void snp_enable_rmpopt(void)
+{
+	u64 base;
+	int cpu;
+
+	if (!rmpopt_capable())
+		return;
+
+	rmpopt_pa_start = ALIGN_DOWN(PFN_PHYS(min_low_pfn), SZ_1G);
+
+	/*
+	 * Per-CPU RMPOPT tables cover at most 2 TB.  Program each core's
+	 * RMPOPT_BASE with the start of RAM to optimize up to 2 TB.
+	 */
+	rdmsrq(MSR_AMD64_RMPOPT_BASE, base);
+	if (!(base & MSR_AMD64_RMPOPT_ENABLE))
+		for_each_cpu(cpu, cpu_primary_thread_mask)
+			wrmsrq_on_cpu(cpu, MSR_AMD64_RMPOPT_BASE,
+				      rmpopt_pa_start | MSR_AMD64_RMPOPT_ENABLE);
+}
+EXPORT_SYMBOL_FOR_MODULES(snp_enable_rmpopt, "ccp");
+
 /*
  * Do the necessary preparations which are verified by the firmware as
  * described in the SNP_INIT_EX firmware command description in the SNP
@@ -699,13 +729,21 @@ static bool probe_segmented_rmptable_info(void)
 
 bool snp_probe_rmptable_info(void)
 {
-	if (cpu_feature_enabled(X86_FEATURE_SEGMENTED_RMP))
+	if (cpu_feature_enabled(X86_FEATURE_SEGMENTED_RMP)) {
 		rdmsrq(MSR_AMD64_RMP_CFG, rmp_cfg);
 
-	if (rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED)
-		return probe_segmented_rmptable_info();
-	else
-		return probe_contiguous_rmptable_info();
+		if (rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED) {
+			if (probe_segmented_rmptable_info())
+				return true;
+
+			setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
+			return false;
+		}
+	} else {
+		setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
+	}
+
+	return probe_contiguous_rmptable_info();
 }
 
 /*
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index f833cb7e4da3..5c996ab63895 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1663,6 +1663,8 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
 
 	sev_es_tmr_size = SNP_TMR_SIZE;
 
+	snp_enable_rmpopt();
+
 	return 0;
 }
 
-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
