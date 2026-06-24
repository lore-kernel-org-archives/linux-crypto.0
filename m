Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010013.outbound.protection.outlook.com [52.101.56.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C3327603C;
	Wed, 24 Jun 2026 21:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782338214; cv=fail; b=sN16TOKJLfvraqK374DbLZ6XfG5e1McFcDC+Lk/YcwFmrUcTif3W3/sOGtYtLLcv8ZgSNxFso+Iz0kmXoLo8hiNiasnJOd0B1/P2Otyvm6qEYz1SZgV+KykX20nZ69hK27sOK3S8kA87sxIkKJM5q5y6G1yTK3j39Ui3n5iI6L0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782338214; c=relaxed/simple;
	bh=KOpN8nvaPqTpAZZ9pv/2cALy1w0/9NQDcnK7IzjbXSQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OS4sLsw2mjm15ipdPZVYWeAW0H8KkWQJZTHtCcjpO/kLy3VFqLl7TppUrpqudbwU799AP5Y85GAKs4Ip+LObW1VVNfnOYqrRCHO022faRswzfAVZkESwCsMD7vRQFzXoc1OsWSxC4GV9THpoA0NX8dsTmIzOWB+bDKn6Cv3gcVU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=TFvrFxtz; arc=fail smtp.client-ip=52.101.56.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="TFvrFxtz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YBx0j1z1Ta+IjeIrnTZ9rPv9knIEWD35fajLWRaESFHbetGLmgATC4AfRljYyCIIS1cZHHdwxQDhBn7EoQzXKgoeBw+5NVkW45Rho2IfwGPX7XBuMX2MfEhy2S6kIBx3KBWcsYNoe/K3Q2KsSEDI+KC44jdP1x1c14XlJYBFh+uSFldcbNR5XVOTPTsS4wCmDycydw2ZgIThjlyZpr/Mrclf97zv5tgBML6u5bIK5M1AgXn+SO62sJ5hAZi+F8CfguQRpb5/jtiBlpv7vDkw8hw12PlY26IQvK6C7yoWj9LaCVmAgEUiAd85U8rmQsWo64fAeepteHK9hpNbwEZyJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bsRmE9ccc+hpojFnRztqHuVTxhwws9W/V9UmVv88wIY=;
 b=hgz++gxBf6WponLF8ITHLwpKQwWNm5rVYM013wxeMKsreZKpmFRSWoa8BCxiUWjUOcs4+mpD1JIhm7CZ+PGEqJrGIq/BahdM2i84BdVqtx3uB5Wlg8nk9CQNbmwetgQWSMqaQhGfTKKxYP0k2v+wbbtL3VZVuySqHGQiswSBgeqdLpKwNsPoNXIHR0LTWkhd4lc59OedstLCe17qZzRbkrvcdnEDykup+ZePRJK6szJOBH+gQXOrB17eSXabJ6UDb/T2qIyNShsIqLknu7RHyZXRJV3qzi36msuFbaMH+yG0hDbZ8xvmbIrUzQ2bzwks4cZka+SEbbRdNmbHBB+Cpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bsRmE9ccc+hpojFnRztqHuVTxhwws9W/V9UmVv88wIY=;
 b=TFvrFxtzy8d30ROs8LrCJsO5bjz48CgpI7rvpRxuhKWiNTuzx8BxMUEild4MgS2sQzlSxc+IOkHdq23U5GhxqGoymeaqxsz4twxCWit73TxMTdia/jEiV2LYzdNaB74Y3ceYawu8heXsvnhq82flUlGX05+kT5kCSmkoP9i1YGs=
Received: from BN0PR03CA0012.namprd03.prod.outlook.com (2603:10b6:408:e6::17)
 by EAYPR12MB999181.namprd12.prod.outlook.com (2603:10b6:303:2be::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.14; Wed, 24 Jun
 2026 21:56:45 +0000
Received: from BN2PEPF000044A0.namprd02.prod.outlook.com
 (2603:10b6:408:e6:cafe::4b) by BN0PR03CA0012.outlook.office365.com
 (2603:10b6:408:e6::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.159.14 via Frontend Transport; Wed,
 24 Jun 2026 21:56:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN2PEPF000044A0.mail.protection.outlook.com (10.167.243.151) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.6 via Frontend Transport; Wed, 24 Jun 2026 21:56:44 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Wed, 24 Jun
 2026 16:56:43 -0500
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
	<dyoung@redhat.com>, <nikunj@amd.com>, <john.allen@amd.com>,
	<darwi@linutronix.de>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>
Subject: [PATCH v9 2/6] x86/sev: Initialize RMPOPT configuration MSRs
Date: Wed, 24 Jun 2026 21:56:27 +0000
Message-ID: <75e690e5135289c21e497edc76dd3d0b77b0e2aa.1782336473.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1782336473.git.ashish.kalra@amd.com>
References: <cover.1782336473.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A0:EE_|EAYPR12MB999181:EE_
X-MS-Office365-Filtering-Correlation-Id: 9016ca1d-3fa8-4638-4067-08ded23b7b48
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|1800799024|82310400026|23010399003|7416014|376014|22082099003|18002099003|6133799003|3023799007|5023799004|11063799006|56012099006|921020;
X-Microsoft-Antispam-Message-Info:
	6ZNlcy35qxzZe6lsTvUD8EtZwoUBqq5Bn24pZ5pkJfCj9+blYG0yjN3sFqdW2ja/e3LvwA1suX4kdy5vnj3841MV4bHxaUElGIQGoSdWqVZABF8I/is2xvAYJdxtJC4NWKVD1dgGtChzG3LEZrVycSGNLJXIM3NI1Kt0QyJey0DJOPLEq6AL3lVsdo7z5q9LuXVvClCasVk3nDH79EtDs1vQp1LZHNiK4OweVHDRAky3Ff/czAZ0OHMkIRyA4LKUirPoOGIHbysFoIMg18lZqx2XfccKyR0KSH4k9wkhSiWzP4k4JNWn8i04IjeVP1g5Vgw7TZQ8+48+tF8cL60dDwZSVU4Um3pxYycBWdELlYK+9SdDF8i3T3z/SK2PaRi1kVhOg8aBTJ5Fkykvm+ms5F97I1rSYY3O57jwCeKMyNlQaqw2jZznJmj0al/q9sOsEN2macZwF7ziLnyUOH8VZOnWGgR5Iny63DfCKnQYbFp0Us2ewJIPFzqoS+xN3d5rwF1dmgkpD+udznx/k+FnLUGRsAAsuVdbD3Q0DD9EOFUtOg7LdsS5TOMVkBsPjBqPHbnejMUnHkJ2cuegdzZZr/aTRTUam9fLBGPA1/is1bS/e5Cyby74AA5oKsGdrrMciM8229kODHUe+YDG2iFwRxI6Hd5n5o5NUWzsPHHx4WAygjf0i+N2/cepI5iBUDFJMwDEE62eT1wejZl2kSF1k96TNEOLvEA7THgwdo+I8jVHVFpH7wh4fzN4fFO89RWA
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(1800799024)(82310400026)(23010399003)(7416014)(376014)(22082099003)(18002099003)(6133799003)(3023799007)(5023799004)(11063799006)(56012099006)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Rg4Y88cku7ewIYcLsX52T2aHI1MrKZjgN82a3Ogahn99OJQWL132FyJMFynI67w5xilc8GU6tPfhTKdXm/1w75GAERHTHK69G+0TSCi9fISzy0eC0q0Mwxmlvl706HGC/ZdvqQaFzE/SYyGplDM3zpA3lLl/sG75oLd87ydmMaXSej1b4hTZBfCNbcsGo5/ciIRAp9LuTAm0yc/oh2KwSx7IpRTpH72FzsJyqnodsw8aBBX1Ue4S4c12RIjPjYD8udCHX3dC3jCwVk5eN4p3ltDQ6qo4VCSmJr78kPxhulzU21cU0vb7apr4A8Fd437m6HfHrI10aegOSsaxZemRORKQhfqZNkQFT3S40i7DPyCXBKL3oEufT94okPxFtf2Wi5rtPJAP0uDYQCLX0vWncPQFa+9MyL0MLv6PcXCosCXRtszqfMeipUGq4vle5q8C
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2026 21:56:44.5938
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9016ca1d-3fa8-4638-4067-08ded23b7b48
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A0.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: EAYPR12MB999181

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

Additionally, add support to setup and enable RMPOPT once SNP is
enabled and initialized.

Suggested-by: Thomas Lendacky <thomas.lendacky@amd.com>
Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/coco/core.c             |  2 +
 arch/x86/include/asm/msr-index.h |  3 ++
 arch/x86/include/asm/sev.h       |  4 ++
 arch/x86/virt/svm/sev.c          | 70 ++++++++++++++++++++++++++++++++
 drivers/crypto/ccp/sev-dev.c     |  3 ++
 5 files changed, 82 insertions(+)

diff --git a/arch/x86/coco/core.c b/arch/x86/coco/core.c
index 989ca9f72ba3..f0ed6c62d86c 100644
--- a/arch/x86/coco/core.c
+++ b/arch/x86/coco/core.c
@@ -16,6 +16,7 @@
 #include <asm/archrandom.h>
 #include <asm/coco.h>
 #include <asm/processor.h>
+#include <asm/sev.h>
 
 enum cc_vendor cc_vendor __ro_after_init = CC_VENDOR_NONE;
 SYM_PIC_ALIAS(cc_vendor);
@@ -172,6 +173,7 @@ static void amd_cc_platform_clear(enum cc_attr attr)
 	switch (attr) {
 	case CC_ATTR_HOST_SEV_SNP:
 		cc_flags.host_sev_snp = 0;
+		snp_clear_rmpopt_capable();
 		break;
 	default:
 		break;
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 86554de9a3f5..28540744f1eb 100644
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
index 594cfa19cbd4..0243989f229b 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -662,6 +662,8 @@ static inline void snp_leak_pages(u64 pfn, unsigned int pages)
 	__snp_leak_pages(pfn, pages, true);
 }
 int snp_prepare(void);
+void snp_setup_rmpopt(void);
+void snp_clear_rmpopt_capable(void);
 void snp_shutdown(void);
 #else
 static inline bool snp_probe_rmptable_info(void) { return false; }
@@ -680,6 +682,8 @@ static inline void snp_leak_pages(u64 pfn, unsigned int npages) {}
 static inline void kdump_sev_callback(void) { }
 static inline void snp_fixup_e820_tables(void) {}
 static inline int snp_prepare(void) { return -ENODEV; }
+static inline void snp_setup_rmpopt(void) {}
+static inline void snp_clear_rmpopt_capable(void) {}
 static inline void snp_shutdown(void) {}
 #endif
 
diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 8bcdce98f6dc..dab6e1c290bc 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -124,6 +124,10 @@ static void *rmp_bookkeeping __ro_after_init;
 
 static u64 probed_rmp_base, probed_rmp_size;
 
+static cpumask_var_t rmpopt_cpumask;
+static phys_addr_t rmpopt_pa_start;
+static bool rmpopt_capable;
+
 static LIST_HEAD(snp_leaked_pages_list);
 static DEFINE_SPINLOCK(snp_leaked_pages_list_lock);
 
@@ -490,6 +494,11 @@ static bool __init setup_rmptable(void)
 	if (rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED) {
 		if (!setup_segmented_rmptable())
 			return false;
+		/*
+		 * RMPOPT requires a segmented RMP, so indicate that the
+		 * system is capable of configuring and running RMPOPT.
+		 */
+		rmpopt_capable = true;
 	} else {
 		if (!setup_contiguous_rmptable())
 			return false;
@@ -555,6 +564,19 @@ int snp_prepare(void)
 }
 EXPORT_SYMBOL_FOR_MODULES(snp_prepare, "ccp");
 
+static void rmpopt_cleanup(void)
+{
+	int cpu;
+
+	scoped_guard(cpus_read_lock) {
+		for_each_cpu(cpu, rmpopt_cpumask)
+			wrmsrq_on_cpu(cpu, MSR_AMD64_RMPOPT_BASE, 0);
+	}
+
+	free_cpumask_var(rmpopt_cpumask);
+	rmpopt_pa_start = 0;
+}
+
 void snp_shutdown(void)
 {
 	u64 syscfg;
@@ -563,11 +585,59 @@ void snp_shutdown(void)
 	if (syscfg & MSR_AMD64_SYSCFG_SNP_EN)
 		return;
 
+	rmpopt_cleanup();
+
 	clear_rmp();
 	on_each_cpu(mfd_reconfigure, NULL, 1);
 }
 EXPORT_SYMBOL_FOR_MODULES(snp_shutdown, "ccp");
 
+void snp_clear_rmpopt_capable(void)
+{
+	rmpopt_capable = false;
+}
+
+void snp_setup_rmpopt(void)
+{
+	u64 rmpopt_base;
+	int cpu;
+
+	if (!cpu_feature_enabled(X86_FEATURE_RMPOPT) || !rmpopt_capable)
+		return;
+
+	if (!zalloc_cpumask_var(&rmpopt_cpumask, GFP_KERNEL)) {
+		pr_err("Failed to allocate RMPOPT cpumask\n");
+		return;
+	}
+
+	/*
+	 * The RMPOPT_BASE MSR is per-core, so only one thread per core needs
+	 * to set up the RMPOPT_BASE MSR.
+	 *
+	 * Note: only online primary threads are included.  If a core's
+	 * primary thread is offline, that core is not covered.  CPU hotplug
+	 * is not currently supported with SNP enabled.
+	 */
+	scoped_guard(cpus_read_lock) {
+		for_each_online_cpu(cpu)
+			if (topology_is_primary_thread(cpu))
+				cpumask_set_cpu(cpu, rmpopt_cpumask);
+
+		rmpopt_pa_start = ALIGN_DOWN(PFN_PHYS(min_low_pfn), SZ_1G);
+		rmpopt_base = rmpopt_pa_start | MSR_AMD64_RMPOPT_ENABLE;
+
+		/*
+		 * Per-CPU RMPOPT tables support at most 2 TB of addressable memory
+		 * for RMP optimizations. Initialize the per-CPU RMPOPT table base
+		 * to the starting physical address to enable RMP optimizations for
+		 * up to 2 TB of system RAM on all CPUs.
+		 */
+		for_each_cpu(cpu, rmpopt_cpumask)
+			wrmsrq_on_cpu(cpu, MSR_AMD64_RMPOPT_BASE, rmpopt_base);
+	}
+}
+EXPORT_SYMBOL_FOR_MODULES(snp_setup_rmpopt, "ccp");
+
 /*
  * Do the necessary preparations which are verified by the firmware as
  * described in the SNP_INIT_EX firmware command description in the SNP
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 78f98aee7a66..217b6b19802e 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1478,6 +1478,9 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
 	}
 
 	snp_hv_fixed_pages_state_update(sev, HV_FIXED);
+
+	snp_setup_rmpopt();
+
 	sev->snp_initialized = true;
 	dev_dbg(sev->dev, "SEV-SNP firmware initialized, SEV-TIO is %s\n",
 		data.tio_en ? "enabled" : "disabled");
-- 
2.43.0

