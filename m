Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010031.outbound.protection.outlook.com [52.101.46.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 734F03E0251;
	Tue, 30 Jun 2026 18:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.31
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782843118; cv=fail; b=f/jaGlA0TZICFJfThEFuWqZZIGWqaTKabbWCXfWrTEAwgt7Sr5T+bXN39RpO1T4T0Ocxoz4vlJybv0yuzgNWaIBnQbCNqi6D6GNWkFAW+2y7xmbpvof0lJA7GLL8aSbwnIRCxq3tqBcHjMdpmVI/tHGQbf1Ls1mPjplLMD73SoY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782843118; c=relaxed/simple;
	bh=wQTEITPuzFx9GqwQvaFgQ+4QwJ4fXF62FSehsvN+3ss=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GvSoukOhlZu7Ine4m+05Iy6cW5mCKJ9UKgpjEMYmzyF9pm3f7qyM7VatT0jjnaeUOWSJ32eqdYM4Gu8BNZJ7jWZcZZaaHPjq/z8hkLZ6yoELIgzLBYqsTR14KtmcaKyTsuo2weJKg3QKQeABvLtAN3cdeUU4Hc2dujupPvdVvRE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Il7qyAnv; arc=fail smtp.client-ip=52.101.46.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Il7qyAnv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GJsYPGVUwSKGeYs7YutI5o1mBSOkP7v/zCBeR5adu/PSb/ctsJe9B1eU93Bwh3AAJ9ZpUm03oNEBUFEZyoVlAmSkIG+iat+tmMtnuFx98wkcMiLkta6ERGwoHBxvNQ+0ZS6UuCjGWWP1WatjrIRlsJi6f5JzDtnkSjx5Q6tvuadNjgRdDiCXno9q5+Id0FacxzyIBXOSFa3UbjnF3QMK1fInFf1kO90lHVJ5eTEzytZFaP04TMHBdCX1nntdx/CjVy3OdGo7pUGikTD98J27675zmOR4hDP+sjn+uUzWqytMORTGZyQaYXw05IKeJf+SmMYMGsKb1GxzboEp497v3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0OYjtY9y2zUaJf4u15+GwLcVeA3bfYxnUvO9fWsvqtA=;
 b=Ga36qklbOBdrpVuQmXwmkUmoPmbFUoYukVGxJwN+dhNemn10OM3FWjuQcWg860Ta6v9IbLE44BnIlf241zWdoCVn0GRGCu5EDa5jBpeW7PtDL3AjIBFWc5gLwbygH6M3NY3NxSLOIigQtQFKvTKWpddNniZiErbsZqGulZNm2bZlIaOtOCvraMLvRaXQXFbE15QcxTBqRahNHv7+tAwm/+I+a9jVwMz+yCVzOrESRdzU4ewfwsVrvF30yr7p90ERx9af6xHVEhMJgujrTbXGxH0hgK7xqNO19XH0+/X4cNIvVDyqEEU54O58rIwoh4/M1lgPYc+MlTugoXtnDqw9kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0OYjtY9y2zUaJf4u15+GwLcVeA3bfYxnUvO9fWsvqtA=;
 b=Il7qyAnvgZWSghHE5DqdnEH7JuGNsiCEj73kKngLaXONqiJOVs+0f2ZNwMHOuNym1uSAZXNQXLorhJMkn9Vv0W9eLtrodjj4/Hc2LE826/e+taeCX7xfkVExjZu+lXG/BD66XiGhAQswsOdeKlIYi0aDJdJ85/sBEo+ymIvcwaM=
Received: from MN2PR06CA0016.namprd06.prod.outlook.com (2603:10b6:208:23d::21)
 by IA1PR12MB8262.namprd12.prod.outlook.com (2603:10b6:208:3f6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.19; Tue, 30 Jun
 2026 18:11:49 +0000
Received: from MN1PEPF0000F0E4.namprd04.prod.outlook.com
 (2603:10b6:208:23d:cafe::23) by MN2PR06CA0016.outlook.office365.com
 (2603:10b6:208:23d::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.8 via Frontend Transport; Tue, 30
 Jun 2026 18:11:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 MN1PEPF0000F0E4.mail.protection.outlook.com (10.167.242.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.6 via Frontend Transport; Tue, 30 Jun 2026 18:11:49 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 30 Jun
 2026 13:11:44 -0500
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 30 Jun
 2026 11:10:46 -0700
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
Subject: [PATCH v10 2/6] x86/sev: Initialize RMPOPT configuration MSRs
Date: Tue, 30 Jun 2026 18:10:13 +0000
Message-ID: <8518e02c46d6edf1f37a180569c708a3cfa7c413.1782841284.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1782841284.git.ashish.kalra@amd.com>
References: <cover.1782841284.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb09.amd.com
 (10.181.42.218)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E4:EE_|IA1PR12MB8262:EE_
X-MS-Office365-Filtering-Correlation-Id: 8daa4bec-c030-463e-8769-08ded6d30dff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|36860700016|7416014|23010399003|1800799024|18002099003|22082099003|11063799006|5023799004|56012099006|6133799003|921020|3023799007;
X-Microsoft-Antispam-Message-Info:
	IupwEtWd5jGi8TVnqZ2CHulce+Kg/3EtEJjRYzMeVM20WG+J1QBbG/1UdMeuS/37xFzQEFc8OlntwzkNznuKmms6UeW19rr9FdXit5NjDCRPLrjUvChy3Djox6D8deUnXmWhmV3hZuCK98VwTZ55moqP5P38h24sRK+2RwKIFlQ8v99QXU46il/3IlBGRQX3KvnSPvw7Z6uztXt/3/4jsmuclnxnTo1WqLBzh5hT92wURam3xVI/8TODuNxv1DcAIkMRjCH0t+yggXW3EeOuNkXe1dVuZnm66EnO7gsTaYYu0OLZO4cW7KJI2vHipxrIPOjUE/fkwHEnvavHD5iHD+rzWEul/d9wuaMn6wnZI8RE8k3aQ1aYws+YASPJZUQY8hFtkqFxnu4bleQrBmgAa/Wf5LsqlDeA/EDjInmiFTlzd+8GyvWFW6J5Qnc2wpgA8ww8eMXsn2275uldFZPN9eQ5puc1kOLhSqlqD8im3KCMraYGQ6ORq71x8E6+Mk1DEvscoex6nX5jEl3XRTwoWP7tJfOZby1ycIOxr6aHxWvLPFpxleYPKAlC3LDZxPuMrXyI5A3NAPRKML2eg5016OhK962Qir3Xyqrp4YMsMcfZ7jKg5NKUt2puQxVL03ypdqLCl70kyYgNtrjdUPEpqv/nI+zlzzKN0FYY6X8WJJoNrKpuFKH454vNbUf9/A13aZgC9UwMaqphqCbO2CBKI7OVwTxg6Bh9qj16iEwSKUAtvbz6TmZ7AGr+zqEA30Of
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(36860700016)(7416014)(23010399003)(1800799024)(18002099003)(22082099003)(11063799006)(5023799004)(56012099006)(6133799003)(921020)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	PbJdZhxa0y51mqQPR1HvIyzquM33aIGqdOhrSXtIxtxPi8L54DYEo3H3rJZJW7WRRQKXeOTVTo0qf9Wg8++MArKMsOF+4tIVTkvVbzydTa+QqEN1Sd3634WKgHnB58CU+TIL7Ti4VDqGniys/krqSQxK/4USzmQSHJhZiH8f6HkIJGg58MoxAH3TSXrJOZF2BxQ+RIaIht8b1oFiRX2FhRjtTAopDo4ROwSS3K/UQiRnH/WhJlDuT+1hVoMBeev7Z54yD+FrI/P/L0LJ9ofqrWoxL3roBszCK/2jD9di+vtXOWBp4FnvWUKoVX8hm3Z4jfofnV9/CVXBbfnXJ008ZrC0F5iVlYrm3AaqVWOPvsJHxUVuh619we2m2L2bxV+h4yOmzBplmVaUjhWYLZOtuP+pNtAMHIbqW9vUnbsjckfqaueIlWFjEG9Xz3B/fH6T
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2026 18:11:49.4057
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8daa4bec-c030-463e-8769-08ded6d30dff
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E4.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8262

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

