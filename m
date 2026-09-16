Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012017.outbound.protection.outlook.com [52.101.48.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3B284AD7ED;
	Wed, 16 Sep 2026 22:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789596930; cv=fail; b=l9OSwCDhxT8u57pwbsAwJEcef0ud6Hk6MIaG6dexF6umVyz8Ad852k/TjTysHG9vEHD/ODYYtxDvhVzoC/uP4mAQSzKiX0EqfJP/WzLBQXRxYcDuvs4+1o7s+6fdz1b/DP8BofuEZe1h/QwgBtol4SIm77gbkKS+II8dJk1+34c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789596930; c=relaxed/simple;
	bh=HlQrOpdDntHcL3PW48X2DHVfGnTTAneOBtW7uJFZs44=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IHJUuXiV0iK56FlUc8zT2AWCHulW83WsV1QP6OBXh5Sf3nubJA5JIOhQLSrKZHH+4VzZXAj1WFdCjxLdc77Sa/zZEpBonRxaholBCvG5gZkvVtkjkVllQzTve9rLN3HV2+3IlETiuouuTNmaQK9+BZRi0t0BVM7shVXyqfoZPe8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=BvotpjDW; arc=fail smtp.client-ip=52.101.48.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="BvotpjDW"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bPXFQoNsjHclw5FadI0DFpTtbw38Tphw+EZaYhVsFXjAfijMl9HI+yxA/xsqDj5MbPy2AqY3MwDi1Xhrgyqre4ThIRh0E+URPKii6nrfslLJAGUpikdd/bvf5NiL3B8hfXriQVn6LaUlp8Dg8rUN8WAmtXI/zhi0s3TGx8bbVCcFudSY5nBRMnraQ89slXxG12Pxtwg+lbM4XrKm47/NC+9z5jEzk77indSAJRHkDVKu3tRmKU2mQSx38oHMA16jM0mqvEJ3jpL6hBH46gH9FJXYzz49nsjvYFYw+hnS6tXWfO4rbyOFQnuV7jBB+BUOcKo/L6ozr4Z9CwJTGUtkmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eivRtoPiG2Xxrhl+/9BN56Kq3ffcWh2uUNtlTK302kY=;
 b=leF1TzW9MGm3/ESLchtqxxIX+tTOnxAVvRodFJnUTCF9N8kJCmi+T9IVjF0Q66xr5vq1dcsMHVNHQEfGqkRgHmh+rtjhQBNoNZpZCOluTRr5+PC6qhKwV7PtoVYjmmmmrJPjL64SBm/iMXwahYrYbwMkbzejhsJ7SOXf5ScqKhUfB7HBTzqR5WMMf0hm0sp1BwbAZEjOYjEN03dBr8NCfHtwIpJS755xnlzjhXmPnSKCz5IRM9fLyU7XE6Yblrc+x4WVYMFnuJgsG6/kaqgGCxoDb6ltmbFFAl9t0zSVOH3VR/KPjdMTrgCUaKrT8yBIZQCQj7LSUJgjW/us+gp/bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eivRtoPiG2Xxrhl+/9BN56Kq3ffcWh2uUNtlTK302kY=;
 b=BvotpjDW1JehTEeznJQTZOVVj1ReVumTvcC48hYCalQu5pgsKDHRoDepiJTlVDpQvp6QPP21od4hhN+JB+vqi+QSqM1NW2iV20tdnjr51Y6bEudIDandi3CASQjJ/pTDlUhlAphUJHP66kG/vPTmRG5lFhiEulGJXTrk4XnCPpg=
Received: from YQZPR01CA0033.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:86::19)
 by CH3PR12MB8658.namprd12.prod.outlook.com (2603:10b6:610:175::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.10; Wed, 16 Sep
 2026 22:15:09 +0000
Received: from SJ5PEPF0000020A.namprd05.prod.outlook.com
 (2603:10b6:c01:86:cafe::39) by YQZPR01CA0033.outlook.office365.com
 (2603:10b6:c01:86::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.11 via Frontend Transport; Wed,
 16 Sep 2026 22:15:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ5PEPF0000020A.mail.protection.outlook.com (10.167.244.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Wed, 16 Sep 2026 22:15:08 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 16 Sep
 2026 17:15:07 -0500
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
Subject: [PATCH v16 3/5] x86/sev: Initialize RMPOPT configuration MSRs
Date: Wed, 16 Sep 2026 22:14:52 +0000
Message-ID: <7fdf0f5b1be4b561c884c5200d6606a947cbc09d.1789594774.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1789594774.git.ashish.kalra@amd.com>
References: <cover.1789594774.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF0000020A:EE_|CH3PR12MB8658:EE_
X-MS-Office365-Filtering-Correlation-Id: 59a10a9c-d7d8-4142-58dd-08df143ff821
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|1800799024|82310400026|7416014|376014|5023799004|11063799006|10067099003|3023799007|56012099006|6133799003|18002099003|22082099003|921020;
X-Microsoft-Antispam-Message-Info:
	ER2oaiWxFB+LDAwSXI8GK0KbsAY2anTUlm8MB2zlCc6Z+wi/9nAtSpqh0Uk/SbHCdmgw0sd31sbl+sO9/iDxWPohRhwxLSDPE8yXJP+Cwz7TSbJUD2Kq3dqAjXXY5sAjChl6FiNYGZUq3tgWwCK1AZ6kKSq/gViNnFKcL8X8jqr3irB0wRSXeAITfThinrNLGm9QcUTHIkn5QfZopbWrE36YfWbo+zPEr8FZ+Ns4240zIWr//coeJksuejDpqFgPRKFb5pqPlK6NH9AkznKKbjVYDvGfqwTtnnlLLhXiLiYVhPU5j3IyCx3E5xJoNmEMNaSOd3uAj60sTgapj1OXrDBYA/uzUIBJO/lc7gSrCpv7N1x+L0nvyH3ageCM/c32cy3ZzKyYPX4UAdHAkD4UyfOJ2vWqEzvpid+JeY1mb1B/kDA+ux9fc52AOilt8tPBYtYPJbf5PdAmTHVQRMQL/AKRVBIC8TQfViYeLbSPHzYczRoBIJ25lsTDnKw2e3RRoOO53q17uzHRTBCmwBXSFoNSn8YPNxN4S9/sQX3dg1zUJV5Sd/w7C2tRjc7A/VJNo3/JucIrJ2ASsImw+yT8XDnG1vvvBl1WQaiVxI4/hpKxgTx5L27e/zH8n49PKvPEnNCXerPSo3m2k0w/DErkud5F/uYy4lcebj9jcWHV2R5z8NjOX9Hza0eU7lMqQg+1zUr/eAREm+REbDmI4erbIGIicDbTgcFN9wywQtV3jEosu09gX/FZYV93w19Owr1O
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(1800799024)(82310400026)(7416014)(376014)(5023799004)(11063799006)(10067099003)(3023799007)(56012099006)(6133799003)(18002099003)(22082099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	l5qQ7HEfCXVGD7OLC2n2kYPLSZ8lV2Sv7/mHroZm37sDChDJvcpyzIovUBUZ5yFcg3JVl5GWZ53iVj8xqgivBuRNMzXFUU8l/9TfBVKxtnJ7F6l4UG8NH5E3kISvX8+wEwtUgM7ZyvqL7klYU6RDBaayyXc8Z6Zcm0W9PnQCSmbFu4DVsN0W2hw4TcV7qDn2PHhFzYbskLjMA+uJwhAI4gicm8tga+tO3sHoyxKbhSoXgHmuPFP0UomGoKQCPs61HB35wvDzEDg5t6WwXcuB25iEtKcptr+iMtfVEp6qXnZCjdaAqYRRxDaajE390DpD7+vyp5kxeJlnKSHzv3ZlSdxZQqQyUUBqDZh8hUr/UfWhw1ZqnKvbNQp0la1GpAFalunVwv/ESaDIy9sn/Jy3qlObamzTwuYVE627tMtFHsu2OBv31/OEdp+f20xlQq34
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 22:15:08.7611
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 59a10a9c-d7d8-4142-58dd-08df143ff821
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF0000020A.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8658

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
Changes in v16:
- Clear X86_FEATURE_RMPOPT when segmented RMP is enabled but its probe
  fails, so the initcall does not set up RMPOPT for a system that will not
  bring up SNP.
- Program the RMPOPT_BASE MSRs (with wrmsrq_on_cpu()) only when RMPOPT_EN is
  not already set on the local CPU, so guest teardown skips reprogramming
  instead of reprogramming the MSRs on every teardown.

Changes in v15:
- Rename snp_setup_rmpopt() to snp_enable_rmpopt().
- Program each core's RMPOPT_BASE only when it is not already set.
 arch/x86/include/asm/msr-index.h |  3 ++
 arch/x86/include/asm/sev.h       |  2 +
 arch/x86/virt/svm/sev.c          | 66 +++++++++++++++++++++++++++++---
 drivers/crypto/ccp/sev-dev.c     |  2 +
 4 files changed, 68 insertions(+), 5 deletions(-)

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
index 558f7924a3f8..25cb486ff61b 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -124,6 +124,8 @@ static void *rmp_bookkeeping __ro_after_init;
 
 static u64 probed_rmp_base, probed_rmp_size;
 
+static phys_addr_t rmpopt_pa_start;
+
 static LIST_HEAD(snp_leaked_pages_list);
 static DEFINE_SPINLOCK(snp_leaked_pages_list_lock);
 
@@ -575,6 +577,42 @@ void snp_shutdown(void)
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
+	 * RMPOPT_BASE with the start of RAM to optimize up to 2 TB.  The MSR
+	 * can only be written after SNP is enabled, so this runs from the ccp
+	 * SNP init path (and again on guest teardown) rather than an initcall.
+	 *
+	 * The loop below programs RMPOPT_BASE on all primary threads.  RMPOPT_EN
+	 * cannot be cleared while SNP is enabled, and CPU hotplug is disabled
+	 * while SNP is active, so once programmed the MSRs stay set on all CPUs
+	 * until SNP is disabled.  A set RMPOPT_EN on the local CPU therefore
+	 * means the programming has already been done, so skip it.
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
@@ -699,13 +737,31 @@ static bool probe_segmented_rmptable_info(void)
 
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
+			/*
+			 * Segmented RMP is enabled but misconfigured; RMPOPT is
+			 * unusable, so drop the capability before it reaches the
+			 * initcall.
+			 */
+			setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
+			return false;
+		}
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

