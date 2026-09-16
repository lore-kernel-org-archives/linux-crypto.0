Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012039.outbound.protection.outlook.com [40.93.195.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 315CF44E643;
	Wed, 16 Sep 2026 19:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.39
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789588427; cv=fail; b=eeUmkH/ndWTNlSRS+yj3diEMJHKg3mh2yAIVGPrW5c2wBvvc9iYTOfVEuN1qn0k/5wxbvi1qXdKbtK2NM7Do0QcdbwZN+X62fNCY0ehEve4dAy2GFeI9lBymLGPhf2qF1SuUm1WWYcBQ7K2iHiruhSHsAE9XuWwY4UFWpv2tQdk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789588427; c=relaxed/simple;
	bh=glQ16u9TQa/gm9CQiOq7LIMZBxITzrqL0VOEqaZCjaE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rqNsKr7M+OJTrbrTpE4V8E1LETNWH8MCI9C02mtA/AnuQqJl1JazdZAMTjzN2MoMZ3sCaL2epB5I5EsVO6jtpBPLug1scOysUHoj6iZVa5nQ9HVlV7SGWUG15NJj2RddWEeGCVOE0eLREmxpkRPkVDEKsfA1M9k/GDNkklb7u50=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=kg9RLnwj; arc=fail smtp.client-ip=40.93.195.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="kg9RLnwj"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vpU+8vifJWfhojv03b5MxoL3zj8QhWdKTDRD6WoE2oAbfJ/H6kGdu5d1ogB9Z5YodsUz92ZeOaUGi6uU9KtToKFd+opH9rgtbBuj7VrAP/9WboHll93V+Af9uraYm27tzFdmHf67EzolwBCNX56PyebsaJa24dCAA8d2AMut0t0B2Qu+epY/lD3ZW+wU+Xqx+kG2NKJ9riqdfkT4Hpmdj8kEYER3WnGS7Wc0xEGqBUGf/iDnWycaCkAfMNzBJ2K0IjKuPeBWzZd7DM4aBv41VmpwZgOqmdA20mIxPlNtPM3OuHqw6zhta9aioQjnlawqXuwtbkcdeYd+SMaCT+pNEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jx9/DR6oL5c1zO/3HR+R5VGiU7auSoLdl1/baFFDETA=;
 b=nCu8AqdluxzPGhbUyOySqkXq3DvF8NJLGoSvQLumq4ItAAtWI8d0BxPFSylzTGW38uC9HuWHdtnsqT6jSInz9qiwDIsoa0ZJ2EueCbEr+s664NB6tkG1yyevb7eFrX+/lWDmYmPHhOMGIWdo1YmCPyZjuDLzx36azr8m5ZHEfw8/mHI0ZuCvGxjUuoWNAIroDtQEOV3gFqpznOc4dL0bKo7hhueyUZYpQ/JhlUd2iM6gX4onNhX1dfKXoEf9lJj4lNDkdxIkyC8HLJDdVhhJD/1AoV/vSNyGKIcicbCM29uzSggmWKlJx05NeDi8Bqo5BGtjso/JU9m5JZ7GsS+5Gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jx9/DR6oL5c1zO/3HR+R5VGiU7auSoLdl1/baFFDETA=;
 b=kg9RLnwjONT3U/Mp0urzjMEygvS3Dsejh1cPM5FRRrFiIjaOXS5kNg+FgWklzAMDYR9HWsMRBoOlIa3kR0pSnLwIHPqgPMpVJnxqUHPIoIA0MhgAxyEY1iVuncDwCbcta0HqY84mg0mE+zvZRjJBguHAG0q+NC5TYTerip1AEXc=
Received: from CH0PR03CA0054.namprd03.prod.outlook.com (2603:10b6:610:b3::29)
 by SA5PPF8BD1FB094.namprd12.prod.outlook.com (2603:10b6:80f:fc04::8d3) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Wed, 16 Sep
 2026 19:53:19 +0000
Received: from CH2PEPF0000009C.namprd02.prod.outlook.com
 (2603:10b6:610:b3:cafe::69) by CH0PR03CA0054.outlook.office365.com
 (2603:10b6:610:b3::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.9 via Frontend Transport; Wed, 16
 Sep 2026 19:53:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH2PEPF0000009C.mail.protection.outlook.com (10.167.244.24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Wed, 16 Sep 2026 19:53:18 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 16 Sep
 2026 14:53:17 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<seanjc@google.com>, <peterz@infradead.org>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>, <ardb@kernel.org>
CC: <pbonzini@redhat.com>, <aik@amd.com>, <Michael.Roth@amd.com>,
	<KPrateek.Nayak@amd.com>, <Tycho.Andersen@amd.com>,
	<Nathan.Fontenot@amd.com>, <ackerleytng@google.com>, <jackyli@google.com>,
	<pgonda@google.com>, <rientjes@google.com>, <jacobhxu@google.com>,
	<xin@zytor.com>, <pawan.kumar.gupta@linux.intel.com>, <babu.moger@amd.com>,
	<dyoung@redhat.com>, <nikunj@amd.com>, <darwi@linutronix.de>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>
Subject: [PATCH v15 3/5] x86/sev: Initialize RMPOPT configuration MSRs
Date: Wed, 16 Sep 2026 19:53:07 +0000
Message-ID: <9d57b0584549df093c5134660ee5a76f7972a1aa.1789586444.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1789586444.git.ashish.kalra@amd.com>
References: <cover.1789586444.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF0000009C:EE_|SA5PPF8BD1FB094:EE_
X-MS-Office365-Filtering-Correlation-Id: aa627c5b-911d-4470-efd5-08df142c27c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|82310400026|1800799024|376014|36860700016|7416014|5023799004|11063799006|6133799003|56012099006|3023799007|10067099003|18002099003|22082099003|921020;
X-Microsoft-Antispam-Message-Info:
	tW2d4jrFKNGIfER4ixP7lAKFLnqF/iyE+nP4mMbyJD31IQbNv/GYEAKZ7R0+k1IQ+YEE5IZF5Fp/gmhGtw72TwN0WWZuCeMg253H8jqBGmHeemk67EEWzXHTX6fkGwa9kabU0d7peNWfqgXhE32ca/vRdJ8HCRCLDrfZERt50fEK0ZOJ/QTk9XjBLrBbZb1WckFF4qTWuXf3e943rzSiSIjXxJysFvEkUJwM0iaviZ3ehICW5bP3MDIZSkDd3atBcp2X1dHl6AbRxc+ZunJFxX3GRrh4VKF3OJw/F+0+OYKroqJyw2KfALkHj6cBCzDP+zoHzVLKFYZBtnjwPc1X6Ut/ViPdG1DHm9j6bR/sQKKpEpxsmLEo8tDHZmPjx2CT2Bls/RBObqK3oSdsdZ0gLI6Vf70cS9c75EM3ssYROEVi/dSiLM6SBHPLV8ME8f431gU2Fcb/1ApyAFuxSjqAYl5tQTA+XbQlbzc58mPPtwD3jP4PCokAy4+MdQ5RXTSRAGSHN1qpta6up5WjJeZgRHTL8YJijqgPfi9Gsz47RvUW3hvi3R0ybQBSXijcgoREQDp1kAXWMIY93EnJBDO68mlKjbFg9+NTZWEvNiBwEJk7IJRahVcswsLAgBUv3IrDBman6Zdg8QHBf0ln4DQa/9Bwtr/RuFmXujeSeYPpC9dKMrrQreQ1de7FkMbzwRto+AB6MCSvbWdupov1B48KTFluOjt9OJxsDLkQDiWMxgGkYdfnXU2uh9HZg0fsj5Yb
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(82310400026)(1800799024)(376014)(36860700016)(7416014)(5023799004)(11063799006)(6133799003)(56012099006)(3023799007)(10067099003)(18002099003)(22082099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	9/9bbHHivTq0caSADZww46LS8QqkhvMxOJD8Xx/eCNSDvGuirD+h0ycuRMTnP7Nv32qamOZeFIu/6P5LcIkv7zKT9FJJ3bCOPKlADKBzVnRstHlFdFlKZafbO8/8tVGQ9SxIQ9EY/ArwFdfYZi68cExgrFLCswvUua9qLq54fYzrFHlEpwbEr9aXtD51UaoX9Djr9mvA7hQ3KKaOFlF881Bj7sKWFEp3a5QT6dHYR4eYxnUrB/A3FoXDcIRoJeg6HSp8AsDKKBu5rgDZjgGg+vUdTZ5u6UJTOv89vPDuqPQJ8uvsovG6U9XFK1ENCuzITlm0aJJm4ZxzqHelMkspFxZzNgkbrlmLQ+i/mRCWkxqwDzzaVH6YqeMmrhkUiV+1i0Hzj5CDADCIn+u0gPEPlPhxaCErDbzKqIm0q13ANUNHOvdi9yyhHxsXkBWuKQ24
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 19:53:18.7819
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aa627c5b-911d-4470-efd5-08df142c27c8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000009C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA5PPF8BD1FB094

From: Ashish Kalra <ashish.kalra@amd.com>

The new RMPOPT instruction helps manage per-CPU RMP optimization
structures inside the CPU. It takes a 1GB-aligned physical address
and either returns the status of the optimizations or tries to enable
the optimizations.

Per-CPU RMPOPT tables support at most 2 TB of addressable memory for
RMP optimizations.

Initialize the per-CPU RMPOPT table base to the starting physical
address. This enables RMP optimization for up to 2 TB of system RAM on
all CPUs.

Add snp_enable_rmpopt() to program RMPOPT once SNP is enabled and
initialized.

Suggested-by: Thomas Lendacky <thomas.lendacky@amd.com>
Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
Changes in v15:
- Rename snp_setup_rmpopt() to snp_enable_rmpopt().
- Program each core's RMPOPT_BASE only when it is not already set.
 arch/x86/include/asm/msr-index.h |  3 ++
 arch/x86/include/asm/sev.h       |  2 ++
 arch/x86/virt/svm/sev.c          | 54 +++++++++++++++++++++++++++++---
 drivers/crypto/ccp/sev-dev.c     |  2 ++
 4 files changed, 56 insertions(+), 5 deletions(-)

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
index 558f7924a3f8..f458128b9864 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -124,6 +124,8 @@ static void *rmp_bookkeeping __ro_after_init;
 
 static u64 probed_rmp_base, probed_rmp_size;
 
+static phys_addr_t rmpopt_pa_start;
+
 static LIST_HEAD(snp_leaked_pages_list);
 static DEFINE_SPINLOCK(snp_leaked_pages_list_lock);
 
@@ -575,6 +577,40 @@ void snp_shutdown(void)
 }
 EXPORT_SYMBOL_FOR_MODULES(snp_shutdown, "ccp");
 
+static bool rmpopt_capable(void)
+{
+	return cpu_feature_enabled(X86_FEATURE_RMPOPT) &&
+	       cc_platform_has(CC_ATTR_HOST_SEV_SNP);
+}
+
+static void rmpopt_program_base(void *arg)
+{
+	u64 base;
+
+	/* Only program a core whose RMPOPT_EN is not already set. */
+	rdmsrq(MSR_AMD64_RMPOPT_BASE, base);
+	if (!(base & MSR_AMD64_RMPOPT_ENABLE))
+		wrmsrq(MSR_AMD64_RMPOPT_BASE,
+		       rmpopt_pa_start | MSR_AMD64_RMPOPT_ENABLE);
+}
+
+void snp_enable_rmpopt(void)
+{
+	if (!rmpopt_capable())
+		return;
+
+	rmpopt_pa_start = ALIGN_DOWN(PFN_PHYS(min_low_pfn), SZ_1G);
+
+	/*
+	 * Per-CPU RMPOPT tables cover at most 2 TB.  Program each core's
+	 * RMPOPT_BASE with the start of RAM to optimize up to 2 TB.  The MSR
+	 * can only be written after SNP is enabled, so this runs from the ccp
+	 * SNP init path (and again on guest teardown) rather than an initcall.
+	 */
+	on_each_cpu_mask(cpu_primary_thread_mask, rmpopt_program_base, NULL, 1);
+}
+EXPORT_SYMBOL_FOR_MODULES(snp_enable_rmpopt, "ccp");
+
 /*
  * Do the necessary preparations which are verified by the firmware as
  * described in the SNP_INIT_EX firmware command description in the SNP
@@ -699,13 +735,21 @@ static bool probe_segmented_rmptable_info(void)
 
 bool snp_probe_rmptable_info(void)
 {
-	if (cpu_feature_enabled(X86_FEATURE_SEGMENTED_RMP))
+	if (cpu_feature_enabled(X86_FEATURE_SEGMENTED_RMP)) {
 		rdmsrq(MSR_AMD64_RMP_CFG, rmp_cfg);
 
-	if (rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED)
-		return probe_segmented_rmptable_info();
-	else
-		return probe_contiguous_rmptable_info();
+		if (rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED)
+			return probe_segmented_rmptable_info();
+	}
+
+	/*
+	 * Segmented RMP is either not supported on the platform or is
+	 * disabled by the firmware.  RMPOPT is not supported without
+	 * segmented RMP.
+	 */
+	setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
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
2.43.0

