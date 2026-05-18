Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013014.outbound.protection.outlook.com [40.93.201.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8BC38AC85;
	Mon, 18 May 2026 21:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779140569; cv=fail; b=Mn9Zt8C5UgfO4Yn5WpTh0KPgGiNffHn7VoFj5D4PmWdVDbD4ZgYt1ckFmLxdxbRyuUasRvsSaTWHIKZoBpoLHwLb2Aw2NmxIDWexyHOjQ0qbCrwz0TD6Gcb4KaSpDWPE6rCKofV8B3F2k1UDrqFQx3MEUGNMhJ0w80UYFdaaX0c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779140569; c=relaxed/simple;
	bh=AgyTp09JjTJmgR0TCcTG6IRMJTAN/w1JSWTkYAwSJec=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GklcvykKxSeZZITaXrOGPEYHjAxHyDKwtii3ZqYj/m8Ac+/gaD/dx/jfGdNsJw8rZ8/0tLpBsVJYbewwn6wqyFFmiDAAHGbEkxFbnYbknIMxQvaF1nvf5+hGhmNe4PWFND18uKbr/PfXu/kPxVhOFikrAcNTUuB2g1hVOc4GdIw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=EsHAu/3c; arc=fail smtp.client-ip=40.93.201.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="EsHAu/3c"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WQNqKLDNN3Q2bOjgQKTFGt0EkQt90ItkkT5sMgZb5RcoOORNyr1PDOPz8Uy7GpYBX6JZBD5e/yFMZirINaycHCk/Ayum8Tvww7+zkCSIrrMbIBXeMQw3bep82WnyjY93/5cabQeseWp6We815p8w9kqoWmApBqtpbCU/DNereNjvwtfwZR9QneH0hSE7DOI7Y+DCpXqOUqs/1dcXjDdgBBidq6jX5Ag0wzoSPkfZJX0WaSGJ/fs+MRTEAiL5lf+MjbxImo5VLdvUIK4YK63+sGIacs9frDDi2wYumhVf/j3i73BF1OX3NMuswrkFxQQQgtl02oaAPPZRuQAYSdRsSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o/ZJLko5Zf23sb7ngFnuA+NYtTRobuc6fv+N0U8t3RY=;
 b=HRyrr4WibXKNDFqYr/H57q2z8aR1xII1PkSVTpBaDmeOOA5EINGV/RKpHbs/aEGsMfOqZIXghUW9pIrLQsDE9H1pvw5cmVcGPv6ZYj2b4VqoF6NCZPIbANRFtkKrYmQnmkj4ukaLZyDBG0tqrTxii6joM5gkxRhOEuoXjX1uYbYK/fxziMu56gXhEvjTQeB9pyXB4yiP8HOBJHiRa8VQS1YWRuQZBRYVjmhKIN5T+NfwRYemYnEYGi2abrd9jPjp6qS9u/MPi+4MFPLlvQhzs4Dx0sPVCrt96IisA3hXOTt/8OFbDII+6euSuWVWJ+OTlYMhx/yZRYmj20wEfOM9Tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o/ZJLko5Zf23sb7ngFnuA+NYtTRobuc6fv+N0U8t3RY=;
 b=EsHAu/3c8qrnT56zsOi9+iix962RsqD2tECnFoEubSTyrCjCMlHxop+6D6cZPaEXsfsLhHxIAKETgCAu38cmRXUYhdjeLVu7Q+Baq5nYKGzQQy6oQbYWUFg9yFq6VSlOUOCvNc14qow1Uuk1wqQ51iLrdCncJguiaQCsCWEU91w=
Received: from CH0PR03CA0419.namprd03.prod.outlook.com (2603:10b6:610:11b::8)
 by DM6PR12MB4355.namprd12.prod.outlook.com (2603:10b6:5:2a3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.23; Mon, 18 May
 2026 21:42:43 +0000
Received: from CH2PEPF0000009D.namprd02.prod.outlook.com
 (2603:10b6:610:11b:cafe::d2) by CH0PR03CA0419.outlook.office365.com
 (2603:10b6:610:11b::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.25.24 via Frontend Transport; Mon, 18
 May 2026 21:42:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH2PEPF0000009D.mail.protection.outlook.com (10.167.244.25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.48.11 via Frontend Transport; Mon, 18 May 2026 21:42:42 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Mon, 18 May
 2026 16:42:40 -0500
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
Subject: [PATCH v5 3/7] x86/sev: Initialize RMPOPT configuration MSRs
Date: Mon, 18 May 2026 21:42:31 +0000
Message-ID: <091ac9a1498514744be85ffaffb5e0283d99814a.1779133590.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1779133590.git.ashish.kalra@amd.com>
References: <cover.1779133590.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF0000009D:EE_|DM6PR12MB4355:EE_
X-MS-Office365-Filtering-Correlation-Id: ccb19124-f359-470f-09b2-08deb526645d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|1800799024|7416014|376014|3023799003|921020|18002099003|22082099003|56012099003|11063799003;
X-Microsoft-Antispam-Message-Info:
	QYlkZC41fQBDMPCw99F++q+XjPy3YBhyfDeOnyDsgdfwb7C/6kb+bFFVGWjb4oQ3AKPaEJkMJjD9GZbyT+ZDjeSXr+oxN3DlcnSxCC5iwUAWf9XOZnUV5PnwK4vKzaNWVCrFexOsscfABI8Z/t3RNzDGaqCCzebw2jwBfH421XKJyBakKKKIFyVlq9fE4euT2yyD/nGf5rhE87+U1D2Xwf7KK7tRrBLLnzhxo4nvreYfqqCDY1aG68vOQSXzqsBZW2wcdCpKPUG+NzkWmKDhZ99zSISUvT0Q1siR5tLuKxtU1yR0ATrtVDb1ttUG67qfPEERVLJDkDL4s7YwX2+YYdze3vv1NGKzstrv/g39K9TsK4qbkTB9w70bBpZnKq08SXgDa52Bf/M2kKG00s8cEwvy37WH3YC9s1g0bbZVpeXC8NM8O5BDVSsQBt5tru8l5N4rq5HvPt34WGwT+AoBEp+ptGEamSUX5lU3zvfY1NBSkCxYwuQ/VQxZ7u+oyPvZ8n0i/+EzI+H2sl3CmsOvk75zzi6D61RBUDrsRDf38BunsCE0FBdkHO4MLOhOpkDTby6gfZaSO4NjI6UVei7D/qekeN3dkry4wYub//qTCkX/a1EST6hONN8qHhQM1OixzkxwL3Az9H34Ahkx/twCZKavK3pZzmN1eEmaz5cjobzsogWr/11Ty5a+tAp6f3ZcTuQeCmScfNgYlYy4zqcnCMa8AI/JtkocaQqA4+BMwYQOksvc3xpN7gsNBVmaDVWhgz3BPjssT5MlOTsD1NG+qA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(1800799024)(7416014)(376014)(3023799003)(921020)(18002099003)(22082099003)(56012099003)(11063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	XoL5aTGp1Gt5H+lKoFZWDP9y9Y3J5hIpwpIBrE9DPYD/Q3yGd9TdF274Jq5UZ4epuWMgmbmdZnCkPKZOwRwn96rzaE7+oKPnu1tQ8I68vSAG8JGWCdF8kg4HmDyPZUvtUm+GuUUVvzykkaHeIWkkOnb6GUJssxfiuej2NHw/BxEeqLYQNYwGaY950OQIMR7e575QyI841W/y4Bbe5Ha/YN3+2ZNc9SijWIe0AD9cIOkJlBilG2T5D2DbncFxP1TU21B/I1bcNlC6STAzyXVQEdo9MqANrM3i+Bank4xbaBkHSnjZIEMbB3NLkzZivTwG8YlTsK7SNrElGtOZWsJjN8u9L33W3GkRd9V/EOTVXBtvfedXReYu6a/FV52LiY7llJeVu+/OpdCjLe8CwXLxH/UmZaBPzy86TJbqDAugBWpYGQM9sJtf3mXHX7aPgWyf
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2026 21:42:42.9862
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ccb19124-f359-470f-09b2-08deb526645d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000009D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4355

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
 arch/x86/coco/core.c             |  1 +
 arch/x86/include/asm/msr-index.h |  3 ++
 arch/x86/include/asm/sev.h       |  2 ++
 arch/x86/virt/svm/sev.c          | 59 +++++++++++++++++++++++++++++++-
 drivers/crypto/ccp/sev-dev.c     |  3 ++
 5 files changed, 67 insertions(+), 1 deletion(-)

diff --git a/arch/x86/coco/core.c b/arch/x86/coco/core.c
index 989ca9f72ba3..7fdef00ca8f2 100644
--- a/arch/x86/coco/core.c
+++ b/arch/x86/coco/core.c
@@ -172,6 +172,7 @@ static void amd_cc_platform_clear(enum cc_attr attr)
 	switch (attr) {
 	case CC_ATTR_HOST_SEV_SNP:
 		cc_flags.host_sev_snp = 0;
+		setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
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
index 8bcdce98f6dc..82f9dc7a57c3 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -124,6 +124,9 @@ static void *rmp_bookkeeping __ro_after_init;
 
 static u64 probed_rmp_base, probed_rmp_size;
 
+static cpumask_t rmpopt_cpumask;
+static phys_addr_t rmpopt_pa_start;
+
 static LIST_HEAD(snp_leaked_pages_list);
 static DEFINE_SPINLOCK(snp_leaked_pages_list_lock);
 
@@ -488,9 +491,13 @@ static bool __init setup_segmented_rmptable(void)
 static bool __init setup_rmptable(void)
 {
 	if (rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED) {
-		if (!setup_segmented_rmptable())
+		if (!setup_segmented_rmptable()) {
+			setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
 			return false;
+		}
 	} else {
+		/* Note that Segmented RMP must be enabled to enable RMPOPT. */
+		setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
 		if (!setup_contiguous_rmptable())
 			return false;
 	}
@@ -555,6 +562,16 @@ int snp_prepare(void)
 }
 EXPORT_SYMBOL_FOR_MODULES(snp_prepare, "ccp");
 
+static void rmpopt_cleanup(void)
+{
+	cpus_read_lock();
+	wrmsrq_on_cpus(&rmpopt_cpumask, MSR_AMD64_RMPOPT_BASE, 0);
+	cpus_read_unlock();
+
+	cpumask_clear(&rmpopt_cpumask);
+	rmpopt_pa_start = 0;
+}
+
 void snp_shutdown(void)
 {
 	u64 syscfg;
@@ -563,11 +580,51 @@ void snp_shutdown(void)
 	if (syscfg & MSR_AMD64_SYSCFG_SNP_EN)
 		return;
 
+	rmpopt_cleanup();
+
 	clear_rmp();
 	on_each_cpu(mfd_reconfigure, NULL, 1);
 }
 EXPORT_SYMBOL_FOR_MODULES(snp_shutdown, "ccp");
 
+void snp_setup_rmpopt(void)
+{
+	u64 rmpopt_base;
+	int cpu;
+
+	if (!cpu_feature_enabled(X86_FEATURE_RMPOPT))
+		return;
+
+	cpus_read_lock();
+
+	/*
+	 * The RMPOPT_BASE MSR is per-core, so only one thread per core needs
+	 * to set up the RMPOPT_BASE MSR.
+	 *
+	 * Note: only online primary threads are included.  If a core's
+	 * primary thread is offline, that core is not covered.  CPU hotplug
+	 * is not currently supported with SNP enabled.
+	 */
+
+	for_each_online_cpu(cpu)
+		if (topology_is_primary_thread(cpu))
+			cpumask_set_cpu(cpu, &rmpopt_cpumask);
+
+	rmpopt_pa_start = ALIGN_DOWN(PFN_PHYS(min_low_pfn), SZ_1G);
+	rmpopt_base = rmpopt_pa_start | MSR_AMD64_RMPOPT_ENABLE;
+
+	/*
+	 * Per-CPU RMPOPT tables support at most 2 TB of addressable memory
+	 * for RMP optimizations. Initialize the per-CPU RMPOPT table base
+	 * to the starting physical address to enable RMP optimizations for
+	 * up to 2 TB of system RAM on all CPUs.
+	 */
+	wrmsrq_on_cpus(&rmpopt_cpumask, MSR_AMD64_RMPOPT_BASE, rmpopt_base);
+
+	cpus_read_unlock();
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

