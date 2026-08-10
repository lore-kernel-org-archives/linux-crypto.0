Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013059.outbound.protection.outlook.com [40.93.201.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9186343D4FF;
	Mon, 10 Aug 2026 19:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786389739; cv=fail; b=qWhSkI9JYlS91fd2sFVAGo4gxNf7nqxg+qe7rdZGGCc1ZK3LTTPQZh5QkezhHpri3LbMK6GUw4vawi4BVZdFN1DmXRere/kkKit3OI1EX+7RbrV6Bh/w3Hf5IiKM0fUgszwWiUev3is0UVdUnVRd5eRnM91cE1QOuu6ZHZDjbvA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786389739; c=relaxed/simple;
	bh=tTyjTv0CCC93aZ2QN4uC4QFM6dUeO01o+FQ5KPNe3QE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eRmzU/nOi6jOUrJ5nRc04oO/gWLNiGDEb3u1FR1QOq1+LoOd7pUkotL+AIO4btRxEmSazHkzDMfvprWXkK0CVdpkO5Vv6XIZGZYuq6h1lt8zQu86jwY9uphQ7skAEdvPuceY3P/xBoHM2z14FavXi/sQGTzqCvQ4SH3CaeVuMZY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=raurAdj/; arc=fail smtp.client-ip=40.93.201.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="raurAdj/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SMVFREV7N1v7QfPfiGTR1I2vZZS2tIX4zd+62J25XkiLm+IQ4QyNtVMhBH0kFyIRxEMdjnNPJSDFwZwr0hTqo8tPeF83bJVonnzqkT4+qChIQqt1CS6+7hJvEwquwahMf9z/vflRFwYmE6CJuwqRy6vOaf4AZOOHrOfdnwgMxnGln8+nN/sRkf/cJUKFozQQlj0o7hqqdwkS7DjzjMcJQTCuCgor6x/2JXO7IIRPGvM6ntrmvO9CEU5oLDLwo5TciHKUzOVIAyx/QqqBPshlX8znCC7FUhWKM6NLQea7tr94LJgyA/YJcAFsgrz8V7NbjWclRfjQIOK8tDv47LuRpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PN761cu13yS7T3UqNSV/0kNvPLDlqFRWWW/rnDIMW3I=;
 b=uC8flcs47Qcju4wXMObtqVLgZ0puyfi+3czB+Y0G4GtSrCzvY8YJ+3DnstPHO57njSDKYxSICyMlMwErS8EgL4G+4ArB1p4wCoatPhoSUsK980JYEqPfhZsX1BhPH9EU2AjRe7u8pGE3NtLysd04ZG9eUecezmepjpwjAkjC7cuTw57QG2IEmIXS4oM7rsV1A8sBJU8p3QWvzhLG5EqDJ7yIq5p0aBuvHPJIl6eSj6l+ENFW8y35kF/kOpV+UBULV9dmjNP7u5gXO7s0z0gopZ3rdBoKEsTxV9BbVeuH/9B70MVFLpO4YrC5DjsJWp5TEfHE1mPc/dkatapOebMEOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PN761cu13yS7T3UqNSV/0kNvPLDlqFRWWW/rnDIMW3I=;
 b=raurAdj/CSZlSJoP7FTGMnuzaeIbQt/3vpRoHNzodT6mUQvtWKPkPRmJsZieqNSLgxLqGEzGou7Tmfw2/7NU+frLJrKqiaStH4TM/FtuMFYlf1vKtCFo9LZAF56HRUzeASu9QURyO2Z9fNJ4WxxiNpG/HA5c3HvuxNdgBRFopx4=
Received: from DM6PR06CA0084.namprd06.prod.outlook.com (2603:10b6:5:336::17)
 by CH1PR12MB9600.namprd12.prod.outlook.com (2603:10b6:610:2ae::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Mon, 10 Aug
 2026 19:22:08 +0000
Received: from DS1PEPF00017098.namprd05.prod.outlook.com
 (2603:10b6:5:336:cafe::3e) by DM6PR06CA0084.outlook.office365.com
 (2603:10b6:5:336::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.25 via Frontend Transport; Mon,
 10 Aug 2026 19:22:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS1PEPF00017098.mail.protection.outlook.com (10.167.18.102) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.315.6 via Frontend Transport; Mon, 10 Aug 2026 19:22:06 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Mon, 10 Aug
 2026 14:22:03 -0500
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
Subject: [PATCH v12 3/5] x86/sev: Initialize RMPOPT configuration MSRs
Date: Mon, 10 Aug 2026 19:21:53 +0000
Message-ID: <19b316f26a145646c521943f5fdd5dfc4b2d1e84.1786389115.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1786389115.git.ashish.kalra@amd.com>
References: <cover.1786389115.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF00017098:EE_|CH1PR12MB9600:EE_
X-MS-Office365-Filtering-Correlation-Id: e17ea95d-c753-4012-ecae-08def714aaba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|82310400026|1800799024|7416014|376014|11063799006|5023799004|56012099006|10067099003|6133799003|3023799007|22082099003|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
	emcseP7e6dU935tC4jc57gQsD9JrsyrrNDiYb1NCFOJvpexS4ROo5kQO+jJtPH4sVabxHxpjtAIi6rwc/f+UMtdKxj7M2bBIlIhbnpZE9KIvVb4VDk3v1cU/Tx7eu24CtyWCR/xeAFwXmdLLRinniaVAWhhnH2Ry1a0w0sHRyUTcN1lYySNkgVYyBatWo4bTwpRxohI9M2Apx2bcXHkJDHA7MH1WQ3XD/4mV90biYD+YMcC2sX4Rme6v5IWycHriwMdwpbcgoTTRuBmiAr3jaq1tAxv7xAAlAmVpBF+IH5Tg9QBvuMDswt5APsFs7ccXxoT/gd5sn1efuVUJ6KtE4tcpw4fyS/FWo1KBF5kFPcy5SqN0N9AvHdimusSYMouFvtp7Tu0Ka5Gjjq2CSeTddi/yxu6GZ6LQ5ub9AANgctzLqJrOENVrBcY6ofzyxUirwmeposVcynU/urBDwaFmPAMBboHElWvSkvZ235p8KhFdGm4/CqZgLx3sEjt5XzhAiqofV159j832w+pkiudbCrxI/FT5y7YSPRXfOwT4ofVVQwsX6tkFA2PZBaHmAQuBx0zfrkqeEsNZCkufBiLKBTPaBwVmcLbj1nWG4ce8JXvENVt5QuSlYepAmPMTmyd2/5f9Q4ZlxBeEOwH2ZuAJSiH2i/xtTSvcqhCwYNeQF4c4xTC1mUisgdXSO4s93hkW45cxIYsVXAMk/uPt3ByqA6mVWL7SUMC5YKK8vs9qtU2reXaw8a7RdmcCW2MvNhQu
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(82310400026)(1800799024)(7416014)(376014)(11063799006)(5023799004)(56012099006)(10067099003)(6133799003)(3023799007)(22082099003)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	LHczBtYmos6FVywRYRUgbcKiBrMYONLXzoZq7RYCVVUWu2a8qNIrucey/htt5SpWjbarKRtTOjiTEvdDHYHGNEBmlQvKYtp+UD+NN7bdopPc4Glk3OjogPCdSm+5xFQnmZZAxVH1GTZSggAIzhGdRKss9zhcI4ZKeUV6+asKpNvbsRJAEJB+haiY9ZQJhYk4YtRhcpqkLAG6lqQYx8fe63QAAO6+xGheAHgrKxChzRwViSDcbvTOv4rmo6kAeTLNftXIQQGYHxXoeh0s/kxZGbotyGBBasoOaqvhIaCD29CFnDsTMhkuHK8eso8LF030HuoELeAxxuODpcCf0gnktzTG+Vg6q010PPeQjUPxVBftpvm+SO6aooc1JEqcUhB9h23FU3Gv4Wiry/GIqSEs9BlXNOuFp7WfIIKnmFoM7L/SdFB1YzaMrCQ0+nc3VnxR
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2026 19:22:06.8088
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e17ea95d-c753-4012-ecae-08def714aaba
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017098.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR12MB9600

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
 arch/x86/virt/svm/sev.c          | 75 +++++++++++++++++++++++++++++---
 drivers/crypto/ccp/sev-dev.c     |  2 +
 4 files changed, 77 insertions(+), 5 deletions(-)

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
index 558f7924a3f8..923b7869acd1 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -124,6 +124,9 @@ static void *rmp_bookkeeping __ro_after_init;
 
 static u64 probed_rmp_base, probed_rmp_size;
 
+static cpumask_var_t rmpopt_cpumask;
+static phys_addr_t rmpopt_pa_start;
+
 static LIST_HEAD(snp_leaked_pages_list);
 static DEFINE_SPINLOCK(snp_leaked_pages_list_lock);
 
@@ -555,6 +558,17 @@ int snp_prepare(void)
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
@@ -563,6 +577,9 @@ void snp_shutdown(void)
 	if (syscfg & MSR_AMD64_SYSCFG_SNP_EN)
 		return;
 
+	/* Disable RMPOPT while CPU hotplug is disabled. */
+	snp_cleanup_rmpopt();
+
 	clear_rmp();
 	on_each_cpu(mfd_reconfigure, NULL, 1);
 
@@ -575,6 +592,46 @@ void snp_shutdown(void)
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
@@ -699,13 +756,21 @@ static bool probe_segmented_rmptable_info(void)
 
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
index ca473ca198b8..da12ddf1f412 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1510,6 +1510,8 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
 
 	sev_es_tmr_size = SNP_TMR_SIZE;
 
+	snp_setup_rmpopt();
+
 	return 0;
 }
 
-- 
2.43.0

