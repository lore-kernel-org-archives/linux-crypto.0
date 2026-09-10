Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012039.outbound.protection.outlook.com [40.107.209.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2202C373BEC;
	Thu, 10 Sep 2026 22:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.39
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789077620; cv=fail; b=jkCNdt9eF6tiYd+jXd3a3o2BeuDdekxXxTTEFuOH7nwneGBF82mgC4PD7BnDKkReD3dTSQH99/krZaBd2y2seWh/gy7K7gurikczIZzlJOWxwAh3I0BH8pDiIhMo1odpObxmRDEoKvF7F+nL9koOuiLCp2B2JMZqiMJu6dbMqgo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789077620; c=relaxed/simple;
	bh=OK56UVHa8iyFY5IhlY6nmNpVMiM/iljvMNxv+hLK2/c=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gS6hh4Lct+kKMjaAADEILVzjetbT0PhcHQfJ11FU1nVrtpNt5jCdmH9VDnDhF2cIccFxL7tjx85ntny0dInsY0oTo4J8Sdo/9er6UuniQHVkv4856CoeLZMph7lYmvXLVGOoo6+opJhgnVfWmclWwRoWPA6mHXF7DEacQUVUTJ4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=hN9Jbf4x; arc=fail smtp.client-ip=40.107.209.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="hN9Jbf4x"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qR4bFjuTAuo8FSbq+n5eUhiGauOBlgW/B366hhaJ+CHe7xV+XXcgSxsTkT/eGE55xGM5QvL9ZKR5kmlS/34KQPtheGhvC1VIB/vRmn9IOj2izyr0Ibb1Phr+3p2NAA+UcfnxYBreeYMJBbmLQDZK1DVAtf4+7B1AmwIUu8uTpAKCgmQ/pleNdqcidG6A8E4Lcat2wax/LQrNJ6iM2PXoCYBqm9Ij1la47K89FbYwp2vxHZSqqqQrEZ0VjfqufZVsqFWynkbwsrBM0gpIIrfxpM5TI1Np/Hkcxi/UXIHjQvMylXH/jGquTPkxslqsFtT8M55iOVMVm7MwFq0FVfEW9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J0BcvZQwROABkdt2eFBZCWafYEv6bIBynj11EFVVh0o=;
 b=sNSDr8QTR0ljaBBM/x6wX48lb+Q6b7Yadj6X6iEkwJL+31wdS1miL92M7S+b7bL+rFo0mrjIZaGMW+U/5DKMsEu8d/6Dr4VOLUG7dYHwURjp5iepUIk7G4Z+Kan2A/9Ze0V3GXb5MB0F96uws05w+GZblA7PyzNsC93sQ1sNsmGMrMzWoNCL2u1q69vJqE/Reswu9IGCDM6ngC8mB8RyTkwOz6456iC+grbiY4HDJDDlPvyEf6ag5NzdG7CytPD6Z/nKDN0grnHfZcgt46fggDXb/g/DH+mlzUgZaOFqDsxSI6KugHSwYk6MWTRtGEpxa2Uhb6gOAPutvnpZ4Pmx7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J0BcvZQwROABkdt2eFBZCWafYEv6bIBynj11EFVVh0o=;
 b=hN9Jbf4xWe5v1xsRJ9z+MVRB0YrZjg7m7AnptYcnE/RRRMSEOytKaJrAg5WaMOFlATr0foO3Mik9iQEuHw+0BYGow+l+aLdweAoBYyr8VylBM5w+gs6IbfaLd+xg0bBadNOGfiVvVYRFge3d5xRuGVbN1eDBQPDNxKZSYFm3sr8=
Received: from BN0PR03CA0001.namprd03.prod.outlook.com (2603:10b6:408:e6::6)
 by DS0PR12MB6413.namprd12.prod.outlook.com (2603:10b6:8:ce::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Thu, 10 Sep
 2026 22:00:05 +0000
Received: from BN1PEPF0000468E.namprd05.prod.outlook.com
 (2603:10b6:408:e6:cafe::af) by BN0PR03CA0001.outlook.office365.com
 (2603:10b6:408:e6::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.9 via Frontend Transport; Thu, 10
 Sep 2026 22:00:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN1PEPF0000468E.mail.protection.outlook.com (10.167.243.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Thu, 10 Sep 2026 22:00:05 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Thu, 10 Sep
 2026 17:00:02 -0500
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
Subject: [PATCH v14 3/5] x86/sev: Initialize RMPOPT configuration MSRs
Date: Thu, 10 Sep 2026 21:59:52 +0000
Message-ID: <ccf019b69a8e1fb069ade7e74237cafc12473eaa.1788984053.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1788984053.git.ashish.kalra@amd.com>
References: <cover.1788984053.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF0000468E:EE_|DS0PR12MB6413:EE_
X-MS-Office365-Filtering-Correlation-Id: a9a761b6-7b40-4a76-6a45-08df0f86df37
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|7416014|376014|23010399003|1800799024|82310400026|921020|6133799003|3023799007|10067099003|11063799006|5023799004|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	kyi1Bd0iKlCNdu+qiOKlS0I1JJd6uaU8BoIuyQkWMAXYNyT3bWgZLxVaxChIuVppR/Mj3rxvP6LU0PsfpNtAbKiGfzd1k1dql6NNbHbdSqWunAhvbnSRPWoXGKbxtnJatkI+pkNOAU5j125MkIdAlj2nKmdozH0dl9yix1ztupMVpiiF/WHRneG1npad/kz5o7FWRosh1Akh45YfKyt89OnmJ+yHkre2k5XCjM4vkv1Z6bXJCumfPMI7r2RhfPLd8VkztPQBIm4YrdVamcY1HvJh3ymy+ZEHu1L1CUXI0ucR4Qbf+Uj6iJsR6gCQVZVR82jlo7ch8lW4O87GY0P3Za5mGwJF68SWVxGY0BaY8Qvk9oU3AceTaIHIhjL5g9z8ccs2Kgv6Etqz6KaMLgAsKvDEm1647up9lfKwt1YV/hjuE4nhH3HqUOGZ+EKw02HfsSxtvRUfjO2nwkcdjXoGVjcnlbz24CUV4ba4s+xSWfXXIlTeu8vFuXvI2zEgOcF68EGp/PdVpoChcvx/ho9kLIGwKKLuiobE08LSAzs/vEP2b7D6Er2sQ+w2hee2+/UxukJjM0Rd7eVaQ3ThxnO/WX/i+jE3cz3GGs+sMkKhDgDLJuFCwJGdCwTRMCudVY+F5cGcg5WA8pxkdAc2s6UBB7I8zxdiBzyLe0/99sA6ULxbQ3PfNS0E3S/Wan8prrmTEUk/6cAQ5Adr8hC0bKsqaEWz9L3rPqyKNHdM/G3/56zsCT+CQTBPfK++subcwp1L
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(7416014)(376014)(23010399003)(1800799024)(82310400026)(921020)(6133799003)(3023799007)(10067099003)(11063799006)(5023799004)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	kp0NLCQ7pSCdjog3k4UqeNrPmCTTaliNyTdWbRUrSsc2IjDcmsmsQjbtSpf3UDKiu9cE4XHoA+WC1HcQy6A5X9qPEES1rm/m04PtckjM7Qg2dc+tggxj84COs1VhD+dQQn0DmXaOxAHyzKC/1b89QuGOGWYee3U6rSdN1GRF1+oedfN3gcX/wNwXyYenq/nVKAaxM16GYDAmREfbBS5/YlBNwA7aOpJRcRz164+qU1HVAU28WxwXVN8f/c4rQibYyZn97QbRO4Lh5TPIIUeNhN2Y5WX1LHSh99oQ1tT0JMZfd+1KWyBTICisaag9EWHQ1qJZO/9OI/S9f4oPgoCnymBjg2K2TQS2tDNYUkyPVnBN3R7OfxQEr2NR1fuGN0CIM8uy92Pw/ZTZVwIeJ78i8wybY57Pudz9wcBOESuv1is6GymfTfVt/5M5YtuxSXkN
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 22:00:05.4445
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a9a761b6-7b40-4a76-6a45-08df0f86df37
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF0000468E.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6413

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
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
v14: rmpopt_disable() and the RMPOPT_BASE teardown were removed from this
     patch (the disable path is reworked in the next patch, and the MSRs are
     now left in place on shutdown).  Dropped Reviewed-by: Dave Hansen and
     Tom Lendacky due to this rework.

 arch/x86/include/asm/msr-index.h |  3 +++
 arch/x86/include/asm/sev.h       |  2 ++
 arch/x86/virt/svm/sev.c          | 46 ++++++++++++++++++++++++++++----
 drivers/crypto/ccp/sev-dev.c     |  2 ++
 4 files changed, 48 insertions(+), 5 deletions(-)

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
index 9e7a077c445d..5638d09b5132 100644
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
index 558f7924a3f8..a059327dc107 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -124,6 +124,8 @@ static void *rmp_bookkeeping __ro_after_init;
 
 static u64 probed_rmp_base, probed_rmp_size;
 
+static phys_addr_t rmpopt_pa_start;
+
 static LIST_HEAD(snp_leaked_pages_list);
 static DEFINE_SPINLOCK(snp_leaked_pages_list_lock);
 
@@ -575,6 +577,32 @@ void snp_shutdown(void)
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
+	rmpopt_pa_start = ALIGN_DOWN(PFN_PHYS(min_low_pfn), SZ_1G);
+	rmpopt_base = rmpopt_pa_start | MSR_AMD64_RMPOPT_ENABLE;
+
+	/*
+	 * Per-CPU RMPOPT tables cover at most 2 TB.  Program each core's
+	 * RMPOPT_BASE with the start of RAM to optimize up to 2 TB.
+	 */
+	for_each_cpu(cpu, cpu_primary_thread_mask)
+		wrmsrq_on_cpu(cpu, MSR_AMD64_RMPOPT_BASE, rmpopt_base);
+}
+EXPORT_SYMBOL_FOR_MODULES(snp_setup_rmpopt, "ccp");
+
 /*
  * Do the necessary preparations which are verified by the firmware as
  * described in the SNP_INIT_EX firmware command description in the SNP
@@ -699,13 +727,21 @@ static bool probe_segmented_rmptable_info(void)
 
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
index f833cb7e4da3..287a8345854b 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1663,6 +1663,8 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
 
 	sev_es_tmr_size = SNP_TMR_SIZE;
 
+	snp_setup_rmpopt();
+
 	return 0;
 }
 
-- 
2.43.0

