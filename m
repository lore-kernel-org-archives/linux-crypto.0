Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010066.outbound.protection.outlook.com [52.101.193.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34C143C09F7;
	Mon, 27 Jul 2026 19:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785179128; cv=fail; b=qcGQguj3ewEr4uxYZUU+ijdZRKn9xnKpYIj4KX2KRfDzRN+byabpcQdG1W3Y8uattC585UzimEQAGeTrPq39kHGQUdDCBz+Fydapxdov361Fy2CoviX14s10d+74wFO+tXCzTDhG0XsG8c48x+UNuJo3NiCXvd4G7b6TPBhsTG0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785179128; c=relaxed/simple;
	bh=Sjr9kxV98zuy7EFqHB/ftHRGF2Fc+cpF+p8Xdy1Vigw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BtU9ITfW0lItfgsnoP7fI7COj6A0BQGlse97LT2YobyE+VZE0cNqKdSFtA84923NfX6UYSB9919DXg/VO4CDEqBPblmGaZ+5RjirRDYHQo40Q1Jib8SF7EswHIdXZ1uFnNNLqjOTBQw5m7flnh+JQpLvFwE9Ngljh22i0IY4zJQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=rBsRDNUZ; arc=fail smtp.client-ip=52.101.193.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="rBsRDNUZ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rDzxMuZo/2dw5y+GhZfrRRZSKz3oZ9KvcOM0s26mCCzt5vimm1nfK5HKEWzkxDi2ViA8XSETZ95kqbAjgrDCqAOs7R4eFM4u6yuPyilqQfYVJj1PBmEJo402PdgxutrySDig++TjqDX6Ggf5Ahhx+LOXPaVGWjSGHt/YU7ITj+cHO6+BdbZC2Oabm0l+ee+KkzK3319SgDexai9lmZeiLzno9JMAM8N1hDWaDsq6Zqn4F5GtYLYDuWHqHzfV9O4tWXDqm0Pz+B4aEV1who/2Azjxo/d1j+it1ORt181BhUbO7IPbkgWezO/L5XglY4hQlP7lEh0HmEvqGFReHH4Qcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fg3bb8m5axOKlm/h2HSKimKEelNZ9JnZ6MKlcNzJ8DI=;
 b=NQExghTTc8FEmMpuAn8G+cnnzvuh6wFeaHTy7UqmzGlSGMZ3OCxcGpl82eAjSLaEB7Kfdxqt6UFSpCSuZOJFCOIjCFZGwWwNTUomZybO0yYhpp4v1AAN3Xd7N5ACzhSv4Ei3tZH9Uf7TQgLHsjA/4hM/zFjHUWlE2lMf/XyYHan05teoIsEpHVEYdPzbQocwGybsJAvXpK+ZiZx9UX/xTXU9a89AuKSBk6c+Mdo78SVxwYFBH/0w6QFB6K6KFZ8jhSALlMEgeqvUJ1DjB3mLO1leY/g7D8XX5fqa0nPY/iaRoUNPP+IvuzDt7Lo4rXL8WyDlwzwZYvmOH0R/kJPqSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fg3bb8m5axOKlm/h2HSKimKEelNZ9JnZ6MKlcNzJ8DI=;
 b=rBsRDNUZkk7Vg2peFti4DIBt/2nQVns8fAeKhyJG7K/9AAyjfncN4UAlsj3gkPD6CLkuLssXDyrUuqj1oW0Of/XU/kpxtJCoB0mQwLhkmjNvlYmt2FQLcDFrMLg5S96mseciD/q1sC7sziVDcRr9bjbmhy6EH/bVa5Lv/r+WMpc=
Received: from BY3PR03CA0020.namprd03.prod.outlook.com (2603:10b6:a03:39a::25)
 by SJ2PR12MB9088.namprd12.prod.outlook.com (2603:10b6:a03:565::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Mon, 27 Jul
 2026 19:05:21 +0000
Received: from CO1PEPF00012E82.namprd03.prod.outlook.com
 (2603:10b6:a03:39a:cafe::a) by BY3PR03CA0020.outlook.office365.com
 (2603:10b6:a03:39a::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.13 via Frontend Transport; Mon,
 27 Jul 2026 19:05:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 CO1PEPF00012E82.mail.protection.outlook.com (10.167.249.57) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.5 via Frontend Transport; Mon, 27 Jul 2026 19:05:20 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Mon, 27 Jul
 2026 14:05:20 -0500
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Mon, 27 Jul
 2026 12:05:15 -0700
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
Subject: [PATCH v11 3/6] x86/sev: Initialize RMPOPT configuration MSRs
Date: Mon, 27 Jul 2026 19:04:57 +0000
Message-ID: <ff346ea1770cf996e1623270a085ac08d21888c6.1784844080.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1784844080.git.ashish.kalra@amd.com>
References: <cover.1784844080.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb09.amd.com
 (10.181.42.218)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF00012E82:EE_|SJ2PR12MB9088:EE_
X-MS-Office365-Filtering-Correlation-Id: 787d50c9-3cc5-4848-90df-08deec120154
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|36860700016|23010399003|7416014|921020|6133799003|5023799004|10067099003|11063799006|56012099006|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	6dfa0wj23RjoCzsA4J28zIseIhvSYUyfiS9q6BDQXruLHs7hKGaAwM/NoMxIQ77/raFw7hhQc/Kk8IYCojSzyTkh6mIjyTJmLCw91JbUC3uEwRNy4SjrlQIvo2Dbdknf0yBtvMTq26+4M2nCoYf9lRUe0bt/RekXUgtwzkD1/o/eUc6npKY24NfDTBLK8wTTKy3agUIvwr96+qh531Lg12ubk1KznYUDPPu+lyCEK9rXTPkUwIxaFgxNMjNg1FQCuZezRXBUgB+hA67M5aLioZIvRDNa7f2KjwENOrYDPq9+ZTTB7+tloF8mJTwbCOUyKgIM2+D4tqDk+6FY1NwudfOhn1fNFrTU/glVplgFQ9j3am7BJIlJ+XzqmGWzmWd6dS/uH71JfU/5lfjSuSeM1ciE7i8kMHJS3xT12UBSRbfCFc0J140FMo8/+HBeeXaJqLt/tR7UFq53odsU6QPQurIER08UDF7j3+TUehFRq2yIvfthVAKveHdyl7mgaNv9g5hOt+vbu6PHbo14mEcEG6cnUGXQFYLUS5JPUI9CLRvS41HUj4JsQm383kkkeGeLwE6aFJonhOPemjWKXIkPILf1dOY8OMBNk+GLfg7NOo5nrCQJtvJMfISZ20dIlsvl5o6U9zJjDSVt349No0VOkiGiNn86Q2hYPXWPJE0WvgrzB9QBLwz/06WySeUtN4gOlvOSjPpcj6v9g82CVMGaja4NIfvdPg8ruFpaMv7WYqLJZohbyoGzRZSfyANS5eSQ
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(36860700016)(23010399003)(7416014)(921020)(6133799003)(5023799004)(10067099003)(11063799006)(56012099006)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	So0LDk+2QaCFUIl2vhs7OQkP6Itr405g1E6VzlF2z8uXa9NZfD3RIPwfFA+qk2jWHqEvEZo7Ckt6FYHSP4FMn8kle5HyIRvXuWQIKiHvU4kFXHPKyh5oW48NLryyDhfvpftx2qlYDUHEBDu9SYWL+bZfse7N94Yd6pyfr5AaiHyFk9XL0q5bVYNC90pr2csSzFmiGIFw2O6hmYO5Lhm6ZtbauNfK95B+Ef1c7aVD5j40kShLd/6j0j4kangi+zRZw8wHXnC9ZW/FFY1VT82a+YtLG9OKS14LurwrjKnyfjDQPsh4IGIGuf5FtBE5Zs8+M0YHP5Bdfdua+Jj12Nt4eeCws+U0+VS4aoHyDQ8qFhaQw7hpBw6V1fexXYNOwSkECMmQimP37HVEULL+ZTLsMxcazb3g3nWoCJuDalC6YvaKyDBK0DqllJ1DzxPHJw6U
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2026 19:05:20.8337
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 787d50c9-3cc5-4848-90df-08deec120154
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF00012E82.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9088

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
Suggested-by: Borislav Petkov (AMD) <bp@alien8.de>
Suggested-by: K Prateek Nayak <kprateek.nayak@amd.com>
Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/include/asm/msr-index.h |  3 ++
 arch/x86/include/asm/sev.h       |  2 +
 arch/x86/virt/svm/sev.c          | 67 +++++++++++++++++++++++++++++---
 drivers/crypto/ccp/sev-dev.c     |  3 ++
 4 files changed, 70 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 18c4be75e927..d2cb0a7cd0a2 100644
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
index 594cfa19cbd4..6fd72a44a51e 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -662,6 +662,7 @@ static inline void snp_leak_pages(u64 pfn, unsigned int pages)
 	__snp_leak_pages(pfn, pages, true);
 }
 int snp_prepare(void);
+void snp_setup_rmpopt(void);
 void snp_shutdown(void);
 #else
 static inline bool snp_probe_rmptable_info(void) { return false; }
@@ -680,6 +681,7 @@ static inline void snp_leak_pages(u64 pfn, unsigned int npages) {}
 static inline void kdump_sev_callback(void) { }
 static inline void snp_fixup_e820_tables(void) {}
 static inline int snp_prepare(void) { return -ENODEV; }
+static inline void snp_setup_rmpopt(void) {}
 static inline void snp_shutdown(void) {}
 #endif
 
diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index e2f69fba0938..8bfd80284836 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -124,6 +124,9 @@ static void *rmp_bookkeeping __ro_after_init;
 
 static u64 probed_rmp_base, probed_rmp_size;
 
+static cpumask_var_t rmpopt_cpumask;
+static phys_addr_t rmpopt_pa_start;
+
 static LIST_HEAD(snp_leaked_pages_list);
 static DEFINE_SPINLOCK(snp_leaked_pages_list_lock);
 
@@ -558,6 +561,17 @@ int snp_prepare(void)
 }
 EXPORT_SYMBOL_FOR_MODULES(snp_prepare, "ccp");
 
+static void snp_cleanup_rmpopt(void)
+{
+	int cpu;
+
+	for_each_cpu(cpu, rmpopt_cpumask)
+		wrmsrq_on_cpu(cpu, MSR_AMD64_RMPOPT_BASE, 0);
+
+	free_cpumask_var(rmpopt_cpumask);
+	rmpopt_pa_start = 0;
+}
+
 void snp_shutdown(void)
 {
 	u64 syscfg;
@@ -567,10 +581,11 @@ void snp_shutdown(void)
 		return;
 
 	/*
-	 * The firmware has disabled SNP (SnpEn is clear), so re-enable CPU
-	 * hotplug.  A legacy SNP shutdown returns above with SnpEn still set and
-	 * leaves hotplug disabled.
+	 * Clear the RMPOPT_BASE MSRs while CPU hotplug is still disabled, then
+	 * re-enable hotplug now that the firmware has disabled SNP.  A legacy SNP
+	 * shutdown returns above with SnpEn still set and leaves hotplug disabled.
 	 */
+	snp_cleanup_rmpopt();
 	cpu_hotplug_enable();
 
 	clear_rmp();
@@ -578,6 +593,46 @@ void snp_shutdown(void)
 }
 EXPORT_SYMBOL_FOR_MODULES(snp_shutdown, "ccp");
 
+static bool rmpopt_capable(void)
+{
+	return cpu_feature_enabled(X86_FEATURE_RMPOPT) &&
+	       cc_platform_has(CC_ATTR_HOST_SEV_SNP);
+}
+
+void snp_setup_rmpopt(void)
+{
+	u64 rmpopt_base;
+	int cpu;
+
+	if (!rmpopt_capable())
+		return;
+
+	if (!zalloc_cpumask_var(&rmpopt_cpumask, GFP_KERNEL)) {
+		pr_err("Failed to allocate RMPOPT cpumask\n");
+		return;
+	}
+
+	/*
+	 * The RMPOPT_BASE MSR is per-core, so only one thread per core needs
+	 * to set up the RMPOPT_BASE MSR.  All primary threads are online,
+	 * otherwise SNP would not have been enabled.
+	 */
+	for_each_online_cpu(cpu)
+		if (topology_is_primary_thread(cpu))
+			cpumask_set_cpu(cpu, rmpopt_cpumask);
+
+	rmpopt_pa_start = ALIGN_DOWN(PFN_PHYS(min_low_pfn), SZ_1G);
+	rmpopt_base = rmpopt_pa_start | MSR_AMD64_RMPOPT_ENABLE;
+
+	/*
+	 * Per-CPU RMPOPT tables cover at most 2 TB.  Program each core's
+	 * RMPOPT_BASE with the start of RAM to optimize up to 2 TB.
+	 */
+	for_each_cpu(cpu, rmpopt_cpumask)
+		wrmsrq_on_cpu(cpu, MSR_AMD64_RMPOPT_BASE, rmpopt_base);
+}
+EXPORT_SYMBOL_FOR_MODULES(snp_setup_rmpopt, "ccp");
+
 /*
  * Do the necessary preparations which are verified by the firmware as
  * described in the SNP_INIT_EX firmware command description in the SNP
@@ -705,10 +760,12 @@ bool snp_probe_rmptable_info(void)
 	if (cpu_feature_enabled(X86_FEATURE_SEGMENTED_RMP))
 		rdmsrq(MSR_AMD64_RMP_CFG, rmp_cfg);
 
-	if (rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED)
+	if (rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED) {
 		return probe_segmented_rmptable_info();
-	else
+	} else {
+		setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
 		return probe_contiguous_rmptable_info();
+	}
 }
 
 /*
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index ca473ca198b8..c002a7ca26a8 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1477,6 +1477,9 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
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

